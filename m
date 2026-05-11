Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24D12CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:13:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EDA26B011E; Mon, 11 May 2026 12:13:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C4086B0120; Mon, 11 May 2026 12:13:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8012F6B0121; Mon, 11 May 2026 12:13:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 705EB6B011E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:13:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 187178B338
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:13:42 +0000 (UTC)
X-FDA: 84755634684.16.366EC82
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 10AAF40019
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:13:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Usj/C7LS";
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oP5yysdDDPIjgsiPxg3R6ga9RgA7ojwMpmnEubfpxdI=;
	b=U/RMgfCeqff4/7MbGYAxnFg4kAXz3M9OH6WyxFXrSjHhRk7c0rHccyfRJqith6aElECLAB
	NUxOadMt1YWRc6fzYKtGdDsUOMQP1/nY8zTNbFdRVbFrzwuXjAZsLXjlddtTvsfRQqTIwI
	rMEDFS+a691cldrJug6sG4WtMNWLgHI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Usj/C7LS";
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778516020; a=rsa-sha256;
	cv=pass;
	b=tovOl4ABTOMEE2oAEXEzY4Pmo90Ga8mCQ5R1ftpBdDwPp9yudBk3Iua1Juarqt9NahnACR
	fhQEeJtEjtrYL4U3hSs5SqFgmNXw2YRwegs1mQu5VZDZcWKm1VlHsWyY856T8imD/wquUu
	VAhFo3N+tuPZkQjy10G/gQhNTRrCyHs=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5a865d1547aso5063480e87.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 09:13:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778516018; cv=none;
        d=google.com; s=arc-20240605;
        b=BooMD5vdb/5YSE58LglWDAC5E1SOFnOjr+RRgLNZaZYgmcK2mamoCKyQ5OOQIUAQLI
         wY+MlppT1u1F5rNcSYAZvhDR9Exqt8ykYZd+pyBR68v1Xl4v0u04D8EpU+vBgkY665+4
         0+bGwU2tj2VAsIG3e7r1UW62DJRmcIrj4Ar5spxGSw5HAq/QBBoMM/GxQpjAfKLSHGie
         Tkm1ZMkQPZ7MeCNsldfVJJhNq2coYbmNnD3sLjHDjNxVFpyMZu+9cWAZ4hk7J3YaxUFJ
         BmG/R7oHgImHkxnLSgtJBkfb1/EfB18D9YvKF08XQo6eBwatjILwCdTKGAYLSVG7y8+O
         E7zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=oP5yysdDDPIjgsiPxg3R6ga9RgA7ojwMpmnEubfpxdI=;
        fh=WQ+tCyhMKHcAMXiu5kqHVweKP/4Z5CIBqGWEIsuVKns=;
        b=YZ5zPO9rk2X2Sc4FxjzH4TXrZ5FAzBMO5OKr4po4rqGJAkIaJSNciU8waWmmmqfzuW
         MPxJZ28FX66tOeWP0EN1WCC9KkjaGtfXFxQBH08lNKi2G5txcMB2NCz6moMaOByhYq1s
         P1AcSLlOMpOE6d2Tt3CQN9ZCwxdg/zA181I8ijeQGrhFEb6pK5DlMDUGPypGvL5enKIC
         CqUlDmZXkKo9tbe8LAFAzGIH8Tm3d6YUpeXeoqBswikIKnljVcc1FG1EzUaXeCKjUE7v
         itFlyEiAewRpT842Ssy77jWmDjNgnMAorLQRKjKIEb0uAEsligvjxMrsB0b0GdMI0Ut8
         kn1g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778516018; x=1779120818; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oP5yysdDDPIjgsiPxg3R6ga9RgA7ojwMpmnEubfpxdI=;
        b=Usj/C7LScuFpUMsMG2yVuyk7etnd8mJ3rvDLyu8Lt85vIa9iIoJt8WvEzt164CZBtV
         iERXa9lcXsXvUwtLWGq5pMqHdxHVD3/THr0nqcoc5DYZeAZwen0Jy8O6qiTjAr/fuZZo
         l0qltUEgRL/lzppx8xRr4vz3yGpwNtu9z1XBkb2lEFiNdUPEHinXWJUzBtxYE4Hb2b3I
         OXjig3wh0wTMahvGe0o3ha53kbiIYazuAO3fHfryFOFK1m8EuGFNHlA3XHCf5lg+fH0f
         ubYWyfo0O76Nmz0I4SRxJUPk21XUW09ZFKfw6eYeN15Rf7XZ8QVFWJT0OhsxQ0bJCewX
         LbzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778516018; x=1779120818;
        h=cc:to:subject:message-id:date:mime-version:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oP5yysdDDPIjgsiPxg3R6ga9RgA7ojwMpmnEubfpxdI=;
        b=AKTaJ8joBZah/bgh3DCBxaPto2IesdZ637xJFN2IjiCgWu06MFvY23zRdRgYpS3Wui
         2yB+Ai54Zn0z3IK+1UCGGGaQmkpiVDCWd/k8+SkWLoGlzT/40JBBmOHVa2zzDbbZPNnF
         2KEFAqKfmbbvz5Nkdq1gQe8PQ2TvVmRV/mGSbttwwGrVtlbjB8x4ju/kb3Cy03S9abVr
         5v7+fYBzfGYrzwXv8Q5yPV4GNFZf5AaTiYmVblX/8IUxJeOcgq3DQs0gb0lZcVS+ZWTv
         jWYhcdAQg/jE8hYL1Sr/+si/ZMt6IEC1pJKrnomUnUtIkGSugPvhqLkUtwX/O3YIEOpb
         svNw==
X-Forwarded-Encrypted: i=1; AFNElJ8wJUlmyoJ3L0hC+2XTOAa1VYyuyRfCGoR0t/gbMYh8LLOmZrhoWdfApBJBau2kQnACDD13CuLiqQ==@kvack.org
X-Gm-Message-State: AOJu0YwuimX9DSszaxMb7efSOCknVga8Fcyo9lPUIXqEaY8uul8r20/I
	Sm3wOb0EARIBLZHwivbhxf18qcvoQUIYcSJ57w4pjALMofvw+YVnjVu/OWA+oZ0a/AM+TdbFomw
	xZk+OAGifLTy6PZajpFkrBJH+Klp0XCiUay9aL45v
X-Gm-Gg: Acq92OHd7IfOJEDWELCuZGg3AgcfGECTTrVBRhzTJI6xc1okxrHRP02jWLV6BiS4665
	Wee8mOmWSEDSU/ATW8ygz850CRF3ovbWcY9LfFvGlAPS2DizlMC+ANr03Hypusez+KskWYwWVXR
	TMHHhio9MEslw6KFAQYpXpG1bMoYklwalDK827CO4dMK+q1djtZJyQB69A3LjINwL7NtgY5oJqT
	Df41JY67v++jfZPpJj2dungJ+Rwhyu+j9bqXG9ODG4DccCA8aF/e4mFfu/iCL72aBSKYfyB2G0u
	VhVycWjP6ymydtAiU0YOEmQ9KdjCCMs27cyub5bBRVq4TOt00/4vKFCCW3aVc2JiCWRnKFRRkdC
	bLUQm
X-Received: by 2002:a05:6512:686:b0:5a4:d0d:84e9 with SMTP id
 2adb3069b0e04-5a8e0ec4f2cmr52775e87.4.1778516017324; Mon, 11 May 2026
 09:13:37 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 11 May 2026 09:13:35 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 11 May 2026 09:13:35 -0700
From: Ackerley Tng <ackerleytng@google.com>
MIME-Version: 1.0
Date: Mon, 11 May 2026 09:13:35 -0700
X-Gm-Features: AVHnY4KOmfBGJRuh2muMrz7XUq1AEoAtQrmqBfgNBg1bhfN7BYvKUkZnUAn4pXY
Message-ID: <CAEvNRgHAOQbkPWfdDiELxx54B6A=gdtbyjX30+dCUjvkG4PjDQ@mail.gmail.com>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-05-14
To: linux-coco@lists.linux.dev, linux-mm@kvack.org, kvm@vger.kernel.org
Cc: david@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 10AAF40019
X-Stat-Signature: watroq6wfbn5nisp17dtzysojeetfwe1
X-HE-Tag: 1778516019-246111
X-HE-Meta: U2FsdGVkX199CsRekDZqe8o4Fy9PDP+wq01JsvoT+v9D0s38sQzy3WSpb2vfIEe22XNH3Tow7rxL+ebHotbOjSopJ3nEJH1pO/kd5ay7V14XMA8wf/YnxgZOMO2Vcw5hlZtLDd+vm+foOPFSPXb8P93On/i5flnOy4c66TU0e/JAwr2fwKsIoIHapehbp1CbWofPiCt9lXSTGfOyLwKwK74hKbPps9g5kMBclpjcFu85DP9UbmVETPbCxW6XdkDAxskJlu7Zvs9etNoo8HJfkiY2vp5FP3rbdf7NAelQtvrPov+kxcJ97x6H1SrU74sN63ikuH/QIhMEGtvNkBGFObJCv8JOjghaqMbAEfvGXq8Mr9gD0RXfs5QKktBxRbI1GtU/m/SMQ9yYNOZJ1/d9GDbqIv1Q4b5Hkxd8hO2rZFLCdJwvxl0yhhEXCiA1+2WaqoH0nZPJND4FcziBPHBqudpCNU1CMBnuDIXfG9tPbCX+jSOp2EjKJ64xVxw/Hififn4ysGIpuPqXMO+5JreCSBXGiDXva4wkWxz3Img9XG+y9cE7vY/RftOjQCKRuOxQxAJt3Wm9AGJj/n1WgztgSzEZbnIwpWzuoP7CJEW1ae7BpxcQyyL8tlFh6QvDmuox9C6wQWQ5WkEI0b40jl4wUYjvnlc0ewqPmdaHL+rFg7yL2zzvPopdwcTltUF3TcGCrikwAEbaiTXSRtn6LAawaiP8bO0efKuffeu1GKVkzlkur6Jz8fEO1lG7p+JUZy00YKMGkjS89Uofcv7f2oKMruHKZcgWeEfGeLXGahGIYWVfsF9PWxAt5XgQBEyzICDUSZ6u6E19L/zuV1K+2tcYYZbzQDjBDO+z0aMIfe3e9mRvcCAh+1iFmIm4mhMaRK2ApHqmz1Fb5U7SbfWwRZL3syH5tzFSVa6QKmtXRkUqrTRv+XsZ6+Q1rfSmhPRWsPX8xRayNtYF+2HUE12uErE
 qPaO5RyY
 7DWYL3JBh8ZLmjxZJE7XHdn/BGDVt3Qwj7boSROZktsK2QNmMj42sl8m0wyXTzGafCgGk8AZNMzS1NzWcidtMSzw2BkY5CWrEo0dJ3Vox71/faYvUZKW0BYFDTVDWGVPrXNsWVrpF6s8b+vmWgE1LowVV2ydAqeXKvadepv/k4YGGpVUn7S+gnYTvpJf9lH/pHELinA9e4iqxH3MVNxDoXRcY559i4/Qzq8LariCPZjKCb0WDW3gcoV2ePfh69nytYc0eg7OIZZtbr9PrWfnD4/mdiNg6QTmYMZs/0cWT2gq+UwWldag7SwfwWeMsrRr3fwX0iL30UIaFiu6LCjQkXWxfngPgXDGqWnh776YaERBe28+5CZDjni/J1PSaZZzoMgWA7F73Dr4+BJw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Our next guest_memfd upstream call is scheduled for Thursday, 2026-05-14
at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

In this meeting, we'll have some quick check-ins about the progress of
guest_memfd direct map removal and related patch series.

Then, Frank would like to talk about pluggable guest_memfd backends!

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write
Ackerley or David a mail.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1] https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing


Ackerley

