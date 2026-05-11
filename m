Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B01CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 063756B00BF; Mon, 11 May 2026 10:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03A006B00C1; Mon, 11 May 2026 10:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C2B6B00C5; Mon, 11 May 2026 10:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D72AD6B00BF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:01:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FF37883B5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:01:37 +0000 (UTC)
X-FDA: 84755301834.18.8B94D88
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2E8F714001C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:01:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OzY0pRQe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778508095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLxdBiQPOmfB7/g+TLxJydEaBaSnzL2xZwyzDF9vo8w=;
	b=ywPB6xRiGImgDbFzasvazY+U6rqFSJOmqKJymdTOoC7/8mc4bpmNV+a3IB0ajIS662rDcp
	WKPzzNdLMPPhlQeeWA8iiRTiU9qQ6abtkbjgHoxjjAwr/1U/Nt2Zb7umUwNfQESZEMpXWz
	kD7zUSsebW5RQUrMJ91u6CK5Oc0b5V0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778508095; a=rsa-sha256;
	cv=pass;
	b=67Zi/RXTn6FLrDncSDwklHNJcL9omd5CawX77GyOypVdQZatrzIS2JdRtdMqCEezqwbM95
	KPkFiTGfjF8ppaWgEW4IhHNjFXz/uiLvLlWYsicSCsfljGCSvj4L0+50xtXYZKmRKmuO8A
	tNlyEqqxnwhtXHIHpkKAFAWSDjWk9kw=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OzY0pRQe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-678a16429c6so6660353a12.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 07:01:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778508093; cv=none;
        d=google.com; s=arc-20240605;
        b=a6BQuB1F8SsMuyVIc3GgiuzTK0wv0VTbPO348pfUjTQz+XElAxSKCWqGXwnUBYy+/E
         qnov8aa71qsS1svHBzBlNZOPwoC2jd/AO52JHCwYkOPs/A02dMPDBE0t7iicdE49AEHq
         6ASew+ucDuU/C+3yTJr5RYUe8qW1JtyOcP377R/Lj/pEPS3ifBbL1BbPnuoFuFU+JDAe
         +KMlnOZYPZQSAeSntAa1XBbBD2pm86Zwb5Yd+khstRV04W7N8bCQUF0TID3Xl0I1JQHl
         8HhSixEZyCLfvlE0FBH7biRO4cqZGG6qaioDxdiGJVkx1Cg0o6KgxVTt3rPfHhBdDgN8
         fl4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kLxdBiQPOmfB7/g+TLxJydEaBaSnzL2xZwyzDF9vo8w=;
        fh=kru6sGnpJBr4H7yBEtiJZ08vAx7JZMpe0Tym4wpcaaY=;
        b=lkgG80JridHrN+NwLc9lRy9BQY3d75j4OrI2h7UQvUEpRe6ds1FSdM9f0P6dhOyTGL
         VrnxCupSKsmNk2iTL58/igjofe6/9dYudHDiQ6UyUpob2uYGcHkNB7hIoZfgk5dy7HTr
         mgyXyobi0bCNWrfyO8cRg+EHmurSKtVMHZ8qgkNKEbaGgTICBN+J5T9CnYKhkhNjILew
         Meg89rO2//yVq0bYIEbuHYi4C/NdVkYl1xUaVo+v/AlDBKn+iZ13KZTNrtZIYySheOOS
         E2s+L/QWszbClu5atV5y5wFOaPMWV/7bdwDEFRfGL2tvkJqme/qCygN1h+gxDbTrwWin
         sDGA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778508093; x=1779112893; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kLxdBiQPOmfB7/g+TLxJydEaBaSnzL2xZwyzDF9vo8w=;
        b=OzY0pRQeOliGGsi4In3AkT3TovIS6gxk9IrfBucaukwx6FVwvOeb+8MS4+M/nsLXx6
         LZ3OG+eKqJuA/GmSTGEpGwTnkOnQAq1KJ9sR2zPHbJCz1ZMXCdThX+x1eRc7/Z+ar93O
         FLdVIAbXIMLSuH2KwRziOhGSCa72BNAnrP5Mknbq2GkZMM4U0oESRsq1TRyXpeRyMPUO
         JgBdpvP8jGRQdgdarsmg3pbg1C1CATniAkb3/opxBtIwJzW3/jv0sEHcTZTCJznliqXk
         UBBk118b8QhIPIW/bDDuDakQdjeryuGAqU2Vh326rydySXw3Az7UgDEop/zZkoSYO+5a
         ubTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778508093; x=1779112893;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kLxdBiQPOmfB7/g+TLxJydEaBaSnzL2xZwyzDF9vo8w=;
        b=FRuwISvU+82Qg+C2FenFP5LbsHSqyPldOcIyjQrp4wR9K48px6deULrPbapmdJTbwP
         sMKddwK8Xyjw77QWy5lPblIF3DvzYw8eGfaHGbrXDOUOQT7pKM7HyOK4eRAblXFN2cwq
         rllJ5BmV6C+dd8LcZsjPhh6G2XnVID7NRMm7Pwc3ynICeh+8srFnk1pclQWQVwLyYr/3
         FODqHgUPbWVBP+0BnworfDtVTJemalhB6A/g12o2pK2Mr08343GiVQnV9Cd2ac1GmYAK
         XmuVdAxPNtY+p8uC7ma57LxKi5ZhqpDcXm6Kc3WmgZguEwL1QwnyqYUYdEzUB9YOpuNy
         Ctvg==
X-Gm-Message-State: AOJu0YxqG3+xBYZjK06b9s4NwseScole28q6xc6pXSPkIZpz4JH7ypls
	ZMJZKSWSIQnXfYD4k4b6ssJ1dMgxV7uiGPaTOWLwhVDlVPKVpDzL6cisTpn1B4gSn7cZVWMrqGv
	Bczc3DBKYOoQfWo2BWaP0z/3Y+YjrQqA=
X-Gm-Gg: Acq92OGd+Q6AO/eOuIZ8v8qQdQ+sym8lbGbaDa1MJHIxH8h1bc/Y308YVj/VXl9z8BA
	Lz7LFEA7nsl2RPPREILDTUqmAPhZIconnpDY+xajkcgtl1hYhNwd4Fxo2dZyoXBmQU33PgJAR3k
	0d1uv6M+LJNSXrUttFtzzIQ1CgpkzNu35BIjTh+aFj/1zsgX2URPEsZJTvkZ4JvuGJNL+i1RZ/J
	+d+aQdst9v/bi0TrwLsZymXSn1zYUtQhZMotHNoTbgZUseKUIeWnjo9MbkOoSMuB2Sz1eHJqxpw
	hZYQGcUwsVzp3yqpkSEIvLXenLVZvsyqs81D0XIXbJ9DmfR47iQ=
X-Received: by 2002:a05:6402:3207:b0:67d:bc41:334c with SMTP id
 4fb4d7f45d1cf-67e0e0dc799mr9245127a12.5.1778508093235; Mon, 11 May 2026
 07:01:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
 <20260218-swap-table-p3-v3-9-f4e34be021a7@tencent.com> <agG6Dp0umhs6O1SY@gmail.com>
In-Reply-To: <agG6Dp0umhs6O1SY@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 11 May 2026 22:00:56 +0800
X-Gm-Features: AVHnY4Jx7EcJNZnLx0AlWh4ZVG4uz0bAnIgRy38784zCd0pAdsdbn5B_rGV-vWc
Message-ID: <CAMgjq7CQHibiZmsrcHu3MXZ-zuRgWJZtQm8WYrGCf5pR46_O-A@mail.gmail.com>
Subject: Re: [PATCH v3 09/12] mm, swap: use the swap table to track the swap count
To: Breno Leitao <leitao@debian.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
	Chris Li <chrisl@kernel.org>, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2E8F714001C
X-Stat-Signature: jp3zao6azhuyb4cspht7xo1uffgooj3y
X-Rspam-User: 
X-HE-Tag: 1778508094-633004
X-HE-Meta: U2FsdGVkX18ZgA+4WSxSQIE21N+xyfRa7ML1qwVbAG+zxrp43ashelQFXOisebqPetEVANtkSOCIzMbdfb/USH/X+M7/zvDX81O0gOoSBR7O8l6efWMqgYEylxcv3nZRFCaHzcYlxBv7BkiahnQD1fB+ZWt38sEL7bevzeM0havGcrkm8asPHKBv7tjeyHAASH9P107ayEQxijiG2NBRj9kZhSPPyZau3g81FgrRm3/tIPs/IZ7H81tqEeV08GhrGtbKEfgFFJDhX4UweEZBpmAI6KmHqWY3RaKUTpMu6LTX/9tW0q5KZePgch9dXMvRzvbY8KturkbvzLKYIbuACL4teDMFdge9mS5sea9sSlIOoQC1twZRhdLOyMrhSR9clw2Qz8Gez/KXg2i/+P5UggUIsSZZzcXVdeYIVHzYat9wPPCZlzSiYQGebvb8/oR4wprcyFysiPOCztBLWfUMSmSr6KaicOdhqv7VyPoJf/U4U4ZnjPoPfy/YPcYi2bY/vLih+BEy/SZge+eSUAGCOMWAUbbFyaTdwtgd/DY2z4ebU+4YCP2Ct6N6aogU1k+TOcY9SZYR2GCEXxDeEku7qPonIS4EftJz8xzqQtPWJ9bvUgkaqILBslhkuaSnnaKtBIWOmqABm+4StgiKJHBvYFQ+n04bj9lTdTRfU8TKjEQ+rbPoGPOWd27Y6M4cv39oC+xDzhAe6tvSsh7F19gnUZbWAo1meiTPOytmx5bVP0+nRAuo1/p6mXlyzr+NCZBK5bc0eDJVgiJ23+0nJZvzlMUiQNKD6sB75sGZPBSXg3+uuFQ4xTNnWujyENuXqYrEDmQ5r4Oqdh4eaBlV2YGgD9b+d9Gil2lsliY3p0HGKZBb7JvMVinCH4hmUsQQHROdx5n49LwTGXiEPm0fTEYGU9mgRCgmWiwSQvXONDqv+HDk2RGgHJeS15eeagwTkJU9HOmv9VWD2StpH4Inlkv
 d/UcASvk
 LARNFFVt77Wx8we0b6pvpyDPFMyExZzFRNyoDZCy97/6j+lSih0jMxgdZZ2XtqaS8ZlrjbL9GqcAhynSLQw9jzOkPpCTwMS92312X/eWxjLbyYI3d/YfG0vo5319MX0aDBVaWiK8EWaUGmdAhd67f5Q1JSqhPLEzhaqPbdmBRpnvn8zmy2wC1uEYfvxmjLxIHpIp5ep6ITsWXQyMK4PK97bClH6BBLpx7psvh3Gp4RYI3Q+WmGwXFubugXXm2CV3hst0lRDvmn9KYMtnGM5fQYS+sN9M5Jvb04SY96XdRZ33ptOA/9T10PxUqiwDQtSiZcvLDXP0jFVOFPCEDSSQYTuxNjd/gb70Yq/fVSF0QJMyHZe6wPpspFduSUEmTIW8z8xo4pmPvkDniUI/vCzfG5tIbzNXBM8GpPM48Vr1rQH6ezND32CBLvxAaz5LienfFvi5K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 7:21=E2=80=AFPM Breno Leitao <leitao@debian.org> wr=
ote:
>
> Hello Kairui,
>

Hello Breno,

Thanks for the report.

This information is very helpful. I think I know the problem now, it
seems we might left a dangling `ci->extend_table` if
`swap_retry_table_alloc` is called during fork, and somehow the swap
count is decreased during that period. Fortunately, it's not a serious
issue and a self healing one. The `ci->extend_table` will be cleaned
up the next time the cluster is used, so it's not really a leak and
the higher-than-expected memory usage is quite undercontrol.

I'll verify this and post a fix later. Thanks again for the helpful feedbac=
k!

