Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38F75D2ECF3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 21:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DEE16B02F5; Mon, 19 Jan 2026 16:43:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B63F6B02F8; Mon, 19 Jan 2026 16:43:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2506B02F9; Mon, 19 Jan 2026 16:43:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8786B02F5
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:43:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D3E713A5DE
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 21:43:27 +0000 (UTC)
X-FDA: 84350040054.15.EBEF4FA
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1B46780004
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 21:43:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HqqchUhM;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768859005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=drri65b8aV+ZqrzX4Tm4hMZ5Kt+PzHt2FoP6nDtSGV0=;
	b=yFibL3PTO8dec+scm+6G0RJWchoQ1dSG8zyO7rvUwqXYu399VBM7OFb+PWek0a6nf5Rkn5
	KZS5NxjxbYgRF2kp9uEbhG1ko5kvWRYHJt4XUBsxJbaBTV5jNahe09WTUuSmMOnsE/1WG3
	gLsFjMf4Z46PxtGagdLAK+BVYi8a7ts=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HqqchUhM;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768859005; a=rsa-sha256;
	cv=pass;
	b=jpPN3y2apHYB5ib0pyTFCxi8x+S89m8n3xSQNB8qn323IF5IwwYjS3MT0Dlt+Ztbh6iiS8
	pr+8cGsE6eY4zfVvjIa+jLrjfj1p6nnqG6uokvM7s+im3usk3wJn4OW1NVIQKhDSoij1ED
	MxnAZZxp+efJ1qN01yQIt9ahsz1Z6V4=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42fbc3056afso2894001f8f.2
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 13:43:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768859003; cv=none;
        d=google.com; s=arc-20240605;
        b=NCLY72nQ760JTrzWrE0ckjL5YAALP/y+1nXuakJicAiHNNx6S8HakMcPKsCAkg9c8r
         aEDet9aJk56lDAgfRS5/9sunBOOa0WMnd9CsasGlnsvEXsVddGZ5zBpIFWa7oB20V7RJ
         AKzwrRz+0KhSGZvmmsO5dRivEc136xQRsgiJ/OoLp4kX7+ai8wUjok8/qmGYAjrhnA7l
         KjtS1ESt64WtQ0yvgtbXpO8mE/+KQUSBcQovO77VDIW3EAyTyZgUdLCKyQ6pGRKMqZyI
         FQGE61BJbKWaEj8AOzx6NTX48pDH2EWb6sWpMxKi0D+1uR+xXSguRW3fVdmqPuonVN2q
         xyVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=drri65b8aV+ZqrzX4Tm4hMZ5Kt+PzHt2FoP6nDtSGV0=;
        fh=U2/qlL52+AtE+KDTF5buOtPHZGiliyTcdXjJBpMIFnI=;
        b=OHf3cqC03Y/s3R4EGKx5/jJlAeAdfoRXV3BJfQU3Lny8OjJ7/ib8meK4v/rz/3iQqL
         C5xuZdaVIC3zCJOiArCLbkOzVBBT+spAo7EsnVVPaBhTxj7laPNnp6JA7oD3/C3Nl4Zr
         zqWA51OPIRi58d/TRSW1pyyjs+umnZokklABI4v+DwYqnS0osIksbDZWSqQI69DEgM5g
         lUfd6UJtabwqkS9HqWVBKeWnOJPxrXtFBBsqM0Wi95cbt1blY0FzpOVLOl8I4pudIieG
         /vRAtMQAEH+0TwqUVtJEuTpcGODSEUWGytDF/hocvbUJiWVJ7bCwjITET01HQodWPKVy
         roqA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768859003; x=1769463803; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=drri65b8aV+ZqrzX4Tm4hMZ5Kt+PzHt2FoP6nDtSGV0=;
        b=HqqchUhMto+OGDE7aPV4MWhIwgsuwO5Qa4Lm4iB7IcxxVh/pw0tP11WAcHx099e0WT
         qlws5JZfI4ppouPf42ZdLZyoid8Rxf168mQUlN/FbVLXG2V619lN6tSCg44OV5GQSToF
         nGXlaQLl+RusRzh8sYlXIRdoVhnniNFiZXJkPC2+Kr+CQZm05M6FwvbavwBEcIlK3QVn
         rnMvuAxTauxvxGtm9ktkL1Kdhg21NamMH+/X7mAoiHBqQKcm3/FCUrAIsdeLfl54Ckr7
         C4w992Q8mBMPlVCKleBaChayRaYx0Uqamer6PxWZDl+NfQh1dFmwfMXn78qzGhE4MG/X
         eoDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768859003; x=1769463803;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=drri65b8aV+ZqrzX4Tm4hMZ5Kt+PzHt2FoP6nDtSGV0=;
        b=xJAsW7k5Ou+D3gNrn5dCvvv0RIYJabjEaeADporIUqmx5mQ6GPuV01ETbY7R49wifH
         cgHz7/oVdIQ6b3loBeMf6In07XvwAMnXF0V+dwzuBqDi96sQ/x4Y+C4hkrbVh5vMbXZ0
         JnYDMKf4aJr+2N2bCc9uHFkXySPr6lQLsBsCDCcqMQF9WsUSXFrOLzx5Zrq5s1iD6Uy0
         9yLAoUFj6dzDbqHyU5g5GdYWZTCZNhyd0f0c1vGzZfL9DszdRmACfMV29btXEKT+f9/O
         bLOquhQVaJVncNsL5sbE+cxIC1ifgfyZA6FMoK3x/FJpcqUhVTrlUXDl+5l/BvkvlWNs
         bpnQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3CoKF64PhKVLdIR5BS9atM9JKuQ3gS7w8sIjiXVNbs1zs7LhC9GDGKE7nXqDoePy47eRmMO4PqQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2PjtbpJ2VhA0SzAZewtZbzO08an0SHh/j1PzG9qxCN+FSsP/Q
	zu+BmTBMNAqFovlxW01+rQuhIIEomDrSSA4zWpP3tlexaMVPQp+Y8fA0+aifi0tM9E8ujjgSxxZ
	+0Bdj7tIAnY5O9sswwXUBsLqFKV43bKOf52gADNrSIg==
X-Gm-Gg: AZuq6aKb+LhXEzTpO+DvmQhOL5pnzSFTFuteUe6DmpaI+3yWYi+K9qopMlJ1dVKNCmh
	Y9ZGxOukv9vYcRyjNtpewtXeffKJ5mS5zoHCIfDbt5ZjUotEvSLnoQnL8ZxvX7jeC5FSKfiv1ws
	H/nn3NRmXOCj47XZIOfmu97r1g/+93Hb8V8qgT//6fiDzrHjhC9NTmpRpvQ0/4ZFgNscrIjHJOC
	+cQ/YTmJ/vZ2lYGV7qiXoAbTD5Cqca7930Q+wTNmjn9iiRpo7GKgSXS1GdzNDFo2XKbW+Y=
X-Received: by 2002:a05:6000:40dd:b0:42f:b871:66b9 with SMTP id
 ffacd0b85a97d-4356a0718bfmr17808774f8f.56.1768859003510; Mon, 19 Jan 2026
 13:43:23 -0800 (PST)
MIME-Version: 1.0
References: <20260116044841.334821-1-senozhatsky@chromium.org>
In-Reply-To: <20260116044841.334821-1-senozhatsky@chromium.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 19 Jan 2026 13:43:12 -0800
X-Gm-Features: AZwV_QjkdE-CDaIoPzn36Rrcg5-JIGXzqMTKsE7daaqmbXMcnYgB6SNBKBKc8mA
Message-ID: <CAKEwX=PxJo6RijehmJMz+kK45Qr9AcQMCedO7KY_+GWzsW20tQ@mail.gmail.com>
Subject: Re: [RFC PATCH] zsmalloc: make common caches global
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1B46780004
X-Stat-Signature: uwy3ddqukakrc6sjkjwi38nmsx689bmu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768859004-830632
X-HE-Meta: U2FsdGVkX1+8UxLvbtTbXlP0MMejE5GgsgDwEl+Y8U5NRcC2gAVpCaNpLEKr3bhLNUxpSsjQbeebmVI844TfgmtcvsV41V+cLDP6H0KLJJ6N+rTx5cnmGENqe31XVrj0tXSFtMbVQirGlu2pqQd5kdw/Tg5JXI4VVx/ipW0D/944HvgaDRevznTGQHchsORmmQp80i7jY+6f1aEbOuhYBvwRzfD6GWqLYdbY2EFFwuxavu3kBalXtszuQlIsUthg9XLDGRGGPnQlvqMn3SMfF/e2CVYWQCcLbyOmzyxlYmpRtH1yv4oSdoNLq5z+ZPuB8M5c3eNv4YYy7Xxu+GrZ2N0v5mldMe9vimBWhqpnz13rcRscuYJa5vpIUiv7Gk+OYY6u2Bs0XswgEIr+SWvrd99IGhaFVeL6863bvtO8g6eCCdLMGMuPjJY6Kq0TIC5qg3wCwEY6B4JwPE/MrWxKpj7Ym/EpxU607mExQ75WZKPxiKLIXn+5yFQUcijoHimHQciET6SWn4j+x08Tme4E+HwC672V7H6OxdPzZb1P7f/0OshIIjcBsyQVsc3TqcqCodS6chMkL9pSMHbQE/horcoQrV6TLlK72Pe4N2wY515mkAETpL3ewNB/BZrAKLUlo1AUZK6yLlw/O/h3wfKfMLIsPnW/fc5hlyfxEeVyOJDc3X9r7EGkH8TTTT34OP3KRdai5kQjjYniEzwC1nqSOz81K4gxQE87orcEl8HpA2Y6uS1rlslx+H+ea5Ie1pMoVlR+oLuUpXsZ39cvGB/0Zgahy5XQzm19fq1zgICPaN3qE/qDK+4uRP38HIsXzVKKsjTpH8PTxOGLtkRDPFsrcEGJTMqbfwZ+E8WKs5X5faWtoVcSFmloMrX5FV2U018W1kKY5jc5AsIj5t1/2LUMlqX2+yHVS3C/Qgn1UaHVXct5r0+pMj2s678HKxbDTP933YoZk0fVq8vUlQjEfwy
 ivDGerVo
 5A09lqnTXYVWvyNtYhhxch1ycygY5I8Kpjor+d7TWqSG2IOtutfkruwa0OEctqi524fitOsnuweYN+sbri02wJbpRUNMrH1lYYGNZ6bTEKkchHxQYQg1H7Fdh+Enp8oF1L7Bz8ZZACDCZHdeecE6kTzZp+6LfDFoRhFFRFRMohTJPjcp3Utj4chrfYqHSug72Zf6Fhq1wYCBuOtjwQ3k+REmSf+t4mbvPgiCGs4fMEd7DolYfAgKHNCbfMpEYmzTnmSW0YBEQTTz1HzE00E2zsNw18HOwafmEZSgTpnQmewTbpxXiNADjy10+HlULwcdLV6sYazsqYC0ZKzZYXYk3FUDWVYgPjslzMOcuKvwWwlzfUkjTBVk0jyvb271SBZRNi13dSdaFr6QLAsl0N9bVYG6O9Anvmjq4gM0twNQSSFlR3dE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 8:49=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Currently, zsmalloc creates kmem_cache of handles and zspages
> for each pool, which may be suboptimal from the memory usage
> point of view (extra internal fragmentation per pool).  Systems
> that create multiple zsmalloc pools may benefit from shared
> common zsmalloc caches.
>
> Make handles and zspages kmem caches global.

Hmm yeah this sounds reasonable to me. No reason to have dedicated
kmem_cache per zs_pool (in the case of zswap, I suppose it's one for
each compression algorithm, which is usually just one - but still...).

Is there any lock contention implications?

>

