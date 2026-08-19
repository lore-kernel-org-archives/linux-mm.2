Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 997F7C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 13:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ACC16B0093; Wed, 19 Aug 2026 09:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85E556B0095; Wed, 19 Aug 2026 09:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74CBB6B0098; Wed, 19 Aug 2026 09:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1396B0093
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:21:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6EC2A80523
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 13:21:41 +0000 (UTC)
X-FDA: 85118081202.25.A58AF82
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id E45F1A000C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 13:21:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=MuFTdgS2;
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf25.hostedemail.com: domain of "prvs=6691494d99=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=6691494d99=alexghiti@meta.com"
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787145699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PtiRvdva/W6LwhggdidoDLcSFrJ9IqJR7sQ+L4wJiB0=;
	b=1vYQnZqOeHnM/9s4jmLPIRKwWgCMVcgZ7HOkGjqwpuP+Mg6owzKxujRvnfmBjRVHPB8EDO
	LxQj0fL0rZMRnbdQdCH9L3LceNehzOZAm5Bte1X0Kr0K3L2jvN35jOOXnspxwJD6I20xmD
	pck+JkmKzk+gx2x0CymtwndnFtcaKSE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=MuFTdgS2;
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf25.hostedemail.com: domain of "prvs=6691494d99=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=6691494d99=alexghiti@meta.com"
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1787145699;
	b=t3+Fu7UbTU7FbZ/mrd1mNO7aPXba6TvjzKDi0IHnp969dIK7Lf69BZx5dDsh7CUearvhn/
	B68kj/ItIZZidDUgBpiy4HW33qHnVPo2jpyDOfBh58eTi99IasMTUUDIxL5f9LEw6zLKht
	5JCSNhcbwm3vWCx3AtZe/dJ4ezALs80=
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JCp2vL2551722
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:21:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=PtiRvdva/W6LwhggdidoDLcSFrJ9IqJR7sQ+L
	4wJiB0=; b=MuFTdgS2+CgTzE8hRoFWzvFqDxUNhI0Ay4kC16HK1+yiuUa74tU/P
	XMjBcnrGy+oEgnoTP6opmjmKRCyHaKqJ/AwYRrkbFr588E1BrpwXOu9HyXqt0xHh
	nsoWk3w/BctFY061fxJlXi+BpPhg3sMYpHXILc5uRmFYLs2qOAQmk8w+LSwyhtSM
	Om8YVWGXU5w1gP6/Yx8Ap5zDPYREpV872o+geBgwMJXC69oQvC8JiUdb0QQEC0xl
	/g5xqXFAt3HnAHXSaPATnQIKKC7Ywc052OcYNwH9IIbsd/VSxfmwV99oRmrKeOL5
	JCOghmWxErrc+VM4zFYsbL4Y4X+nhy5pA==
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4g4yfgmra4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:21:37 -0700 (PDT)
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-698a99b6140so990277a12.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:21:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787145696; cv=none;
        d=google.com; s=arc-20260327;
        b=KQ4bB/e770NddpNmP9ht4UxErh3B0dhaHZfoWs22OLS1fUdz3nk2rN8OPwr8dtaPg1
         Rc4U7iYIbCFlOrTNdvQn3dzuvZBVnya+c73qKmEHD45kaaBayDo0QM/neHMf0uzPv3cQ
         V2LNX6DZ3A3B7/ftNshhUw7qDe9bpgjFS7gPPl2BdI/H8546T03Ss1CLYOSGxwe3LCRw
         qXE7PmC9R0wVpaY4S7K1uV4JJOTt5ni+MsYFflmq0ppVbKJI39i+BM/JHjcFAOfSYjAw
         yjrHPXU8ueZPY0JxWJfcgwKBS6dQ4+UA1FF/NI2q2PnTDtiGgwCT5viq3vl5VhXzZPGq
         uotg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=luASDSg4qblaUVIxdnI5pe7GtluJWKBQ8z+ftBCuGAs=;
        fh=1nFAqP7pZvqW6xMeywyhk7z7c1OE7nZKDzGD2x6TutY=;
        b=CcZb8CoGsItV1qOjPoGDgsCwx52bqkGdopElX3DbJM3iY6BsSJ9E9Ft83EVhKNNW4d
         57Cs+FSIHnokepK8hWVJNXlZYIyHzus7h0MDLqr3hrU6YresdH56/zCrUbjnz8xSLDrK
         QMRTaPtu5lebJ9ILSocmJbKjRmWWBwUAR+UW0QGRvMRvGdYa8yhKYWBxkalEZklY9g7N
         q3VK/uPDhfMiWz2DMHwUI+D2rLuTiYZ/xgxAoLiZU1gG5gTUUhpxyFopFF3dZfH5Ak+M
         UM4QNVKWsFGZGy6P4SAyrYk7SSgM3JvLIleDcqA1wNF0gM9/LQNoBIrRM+GHIA3Dy2tR
         L8kw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787145696; x=1787750496;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=luASDSg4qblaUVIxdnI5pe7GtluJWKBQ8z+ftBCuGAs=;
        b=UlKOHWH4Uhve5hEwDTh046Fc9YX++lz96Ws6GyBfzhrcSoX+C3E5/yrg2c/4wR/1oo
         82/NhnPpfeGoBiy5+XcDyOzLcEIyGKxHPmMbAI42GaUvpy8GWoliBgrkaDZ+KSq8lArG
         PgYFiiI41EUDUoQweHg/N0/NNNyqtztjaj63oh3gHLMFTxuxOdZwGYyOjch4ISF7LRmK
         Zn6Nhv8Gjb7ml2AgTud3AvBZRTk+WjDxk/Pg0OL+QXNyRaej/KJmqnwPkZOkQ21R3EPH
         mAZnaG/WcfbyQy7wh8qfnE+5IwPZ/QSXv8xPw9GefA9+iUECK7H+jX6sy1OB2ieNknPa
         icTQ==
X-Forwarded-Encrypted: i=1; AHgh+RrXk0W6BtxTru47/Mi5idIO8A9amolCzohKrdF42IF/EAcF+zD+eItRKUir3J9udPRdBsX9A6sYtw==@kvack.org
X-Gm-Message-State: AOJu0YwwJ68TnIQKIV8RXJtrQZ4FW+k2sshzWHQlFapIoobW0eHoGgXm
	t8jCT8StUQoUWdPgRI130nS9F5SoIKptpiJBHTkD5EcCid7lK+Vu7LA/hb+fTcf7fPgoXy+9uqY
	ZmzKkIX9B6czwUxAUMcfEJ3UXvLLzk9a0fcMfqUOFrzW5sRTZyY3HEP/jQCuqKJySWISWREwX4B
	ezKvYuvDdjTYf5owSZ/g1nmLoc5w==
X-Gm-Gg: AR+sD12N8w5EYKOZIukkym7565Tn6s0RN6tltRq8JxCNpHXTuKQO/SLd2ZgDRW9uAXb
	n9BnNsq0VQAI1qscyCwDKiK8qDX/ZcMxNnxpowRVw8VBPv+PGMPwlObZW6QufBB2AXZeveXSLu5
	l4T93sGTR2jdY9aYS5/JEHVS6W7xdvWkPL+Q85QUX7eduTMecIzjZt0fd8NbrWWVXNaeiwmBH87
	6q3kEe9vN1c5iaDsQ==
X-Received: by 2002:a05:6402:538d:b0:698:c13e:179a with SMTP id 4fb4d7f45d1cf-6a4033425f1mr2929021a12.10.1787145696116;
        Wed, 19 Aug 2026 06:21:36 -0700 (PDT)
X-Received: by 2002:a05:6402:538d:b0:698:c13e:179a with SMTP id
 4fb4d7f45d1cf-6a4033425f1mr2928972a12.10.1787145695753; Wed, 19 Aug 2026
 06:21:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260722163536.773166-1-alex@ghiti.fr>
In-Reply-To: <20260722163536.773166-1-alex@ghiti.fr>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Wed, 19 Aug 2026 15:21:24 +0200
X-Gm-Features: AcwNN1XoNPFk9LgE9FCqHZwUPLi0sUY9trj_jDaEZvMbWV34mZuU8yHB7KXcWH8
Message-ID: <CAEmasaXi_OFYSPvqv66tXRifw2FDiK6LGCPfAB7oe0K+4SL+NA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] mm: bypass swap readahead for zswap
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, yosry@kernel.org,
        nphamcs@gmail.com, chengming.zhou@linux.dev, david@kernel.org,
        ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, kasong@tencent.com,
        ryncsn@gmail.com, chrisl@kernel.org, baohua@kernel.org,
        usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=feudDUQF c=1 sm=1 tr=0 ts=6a85ade1 cx=c_pps
 a=9KvDgq78n9V61H3VJbnhTw==:117 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=03ozwUkBphtHgyqjj1sw:22
 a=VwQbUJbxAAAA:8 a=kkopZaX46kMaqBy36YsA:9 a=QEXdDO2ut3YA:10
 a=j5kO0B45gQVIxiUYEfTy:22
X-Proofpoint-ORIG-GUID: CI_Ltp_j4mBFq7qFwGCrOU4gdk41glPv
X-Proofpoint-GUID: CI_Ltp_j4mBFq7qFwGCrOU4gdk41glPv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDEwMyBTYWx0ZWRfX1/EoKu2LH3yD
 bbArocQA+6awrHKWyQFk8JnsjTZUKTzCc4S2cwdSjheRStWGEOdzLOZ3WIxBRu7WqJPq5l064qo
 wsNFFISg+7KK7SLCGq5gESJlhg7mk2s2+c0LLzUBxpxqTxeZ4pt2rteHGf6tB87yWmLcx2vjdnR
 QlR0CWKHUwP5iCtzc85la2rnY+Ki2n6B/xW6a+s6jUxO/w5L74yOby+L+gBvWphALz2z5RgsLpf
 gh2/I74IJnjO5FJzYYa4sJ5v/e9RC1nmxJQoqon+VdT6QlvQ1Htq0XskkHFzrSncPhqyw84/9s8
 44vQjGkwDMqyYQ3lN7TqnMCjE0dBKqkX1Qhpn+Jil4FAekFoNuP6hPpivLjYA0XvCKvxsdabsxw
 h0xwhgj5xbKwO07ixGFEavcBTfv/Wz48y+x+9jqfc43Aa71av4gjqBP7axMLlpGtSRczbzRTmex
 4Cxip8q+rVhYV0v2Afw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDEwMyBTYWx0ZWRfX+9PUu9O4Ttdc
 fi2ozLhdMr08w8Mp4YZTbY4tSzDttpA/ctYgt4Z7ZKKeOk1DCJSRWHQ1gsmMYET0nAk8f67x5TY
 qlzOAp+OWZrf1pQEBKlP63wsETxqVQg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_03,2026-08-19_01,2025-10-01_01
X-Rspamd-Queue-Id: E45F1A000C
X-Stat-Signature: j31zqfq9dqftq11ex7oeqq5cmu4ufwtp
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787145698-445123
X-HE-Meta: U2FsdGVkX19Dwt+9M3OhvHvFi/Icm8RqF1cHlJFHmZT2EJ7iDRyaga+fDTKXAAEvmI8E9sdZaEDZwM5cQS/q3Iljd0YwhRbyQYndlFON1OI4OG+XcjJ+o5dlqKRLgZIR9Jqo+pZvYUc/dj6IJuap2+5w+R4eU/l1KVNBjAZkehHrzeTEUXxEs5bIynEQFpUCzgN7G6nDWvLbkjRdys24FR+eiV6wAAeIOhUEVpqoPLCuca7V+7IcK4FBt9ulFeLsNiifvXGdGlz5DV7cJjBFeKKVAFKTQdLNM6QvarUjcP/NEZ9UHtKsO82pR5w8v8+gL9EmBVo7LWLriAfsuxnX4zCBHVjmwCQV1jPUrawKfBydpjSGbJZuBH8jM9TKrg222T7fKhCE1A7XsciDLe3BVPXWqY3Ocv0POIFGTnIuCBlKgAHAJLtdx6850EnWovKBFh+jLs4DCOVvnp9ok6ODrosCVSsdxiBHS6Dhed2WpkBxfVEirP9AVFX+g7GMlztwjXD2iQ+vQU4rBC3qlYsiURkqOCLPTPIgBIHdQ+CTJKRQ2uqhfJoeijRWivS11WuEY2xJQeV+DWevoFYL4ITjCLXALfzpaxcklH9uKS5h4lYHTj2k9TiBHLXxIRaOe/PygqtI3Y4s2pAhnmaZDQtmXhklCw42C2aemzQ7bpl1ySnZVslZpgIPweKPqgcPlOcXRSJ5/HYgtMeb3X0FEDoe/zeB8luHxzjdT4Gq0jKQHRxfhiQxrm6CC5OZ01Eh4vxDBccWMSv7qXkzI6W6XA3yH4CNT8Itx9e33gBKtwiCJrTHqZciMjx2nf5B3+BozUP4vvR43cDYk7AMFbnr8CmMNQvobrTqpnCJSRh/l4ZG2+RxCs9DTq14aigUtn/njX6CwZKbGUmMzJ6+LpB7EVykw2Hf1mdcJk0+Ah2trXQT6c5/Kdr5z3j+iXnOpcEdPSHVsi3kUSCw31TfVvB9QQh
 WqpOV5RU
 BqilOgMxjamUYFNxbkrjz17PLF6QcjaVa8AdDOwXqN2cpldUbdzX8c/NxUGjseNxhReNS9XUhLHG3/v4M4G9LmYPPUQvgclReLGxrV0s1yi93g7U4KCUNISLDW2bgJE9LI3Zm1btr8pcNGLo1ClxVf5QYc4u9FqI+N8XVybXOfoBrFsj5g9scyTQ6HGa8NStQo95rNV4YPFsQsdFQ6d5oYfMvyUH9HzAJ3mgabNMnda4tuxrtQ1p4kalld+GyoNXNqER0g1R0CD/blzmaoUxPaX3HaUF/0yruUdZtfNGk6EE73BmMk9xj2JWAtbhQECKXqgPllYskX8ypgIHiuDOp0dEZCOlnYtYHYZg3zo8es1yZbN1MIR0Itd8qJfOi0yBI7a+6gM8AuO9hGC8aXAOMFCDF+V+ix6XR2moxHgALIufXb9PmK52OfHGr1r5cSnnzXo5RSL+00Y8rfJvYr7KV1q7Sr67lblozgrovEy6o2Wbmk1y1YAicpxpwOUCvgzT6xyag
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everyone,

On Wed, Jul 22, 2026 at 6:35=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> >
> First, the title is a bit misleading but this patchset is a follow-up of
> the zswap bypass readahead, so I kept it.
>
> Swap readahead walks a window around the faulting entry and reads every
> neighbour. Some of those reads are synchronous (a zswap-resident entry
> or an entry on an SWP_SYNCHRONOUS_IO device) with no asynchronous device =
I/O
> to overlap them with. Today they run inline during the window walk, so th=
ey
> are pure added latency in front of the read the fault is actually waiting=
 on.
>
> This series splits the window walk into two passes and reorders it around=
 that
> distinction:
>
> Patch 1 (overlap): issue the asynchronous device reads first, defer the
> synchronous neighbours, and read them while the device I/O is in flight. =
This
> overlaps the synchronous work with the disk reads instead of serialising =
it in
> front of them -- the win for mixed (zswap + disk) workloads.
>
> Patch 2 (bypass unless the target needs I/O): when the faulting target is
> itself synchronous there is no in-flight I/O to hide the second pass behi=
nd, so
> skip it. This is the zswap readahead bypass, gated on the target: it helps
> pure-zswap workloads and, above all, keeps synchronous-target page-fault
> latency low.
>
> Patch 3 (SWP_SYNCHRONOUS_IO): treat SWP_SYNCHRONOUS_IO devices (zram) as
> synchronous sources too, so a disk-target fault overlaps its zram neighbo=
urs'
> reads behind its own disk I/O -- the same benefit patch 1 gives zswap
> neighbours, now for mixed zram+disk workloads.
>

Let me know if I went too far with this new version or if you'd prefer
something simpler. Or anything else you need, I'll be happy to come up
with a new version.

Thanks,

Alex

> Changes since the RFC [1]:
> - patch 1: overlap the synchronous decompression with the in-flight disk =
I/O
> - patch 2: bypass the second pass when the target needs no disk I/O
> - patch 3: extend the same handling to SWP_SYNCHRONOUS_IO devices (zram)
>
> [1] https://lore.kernel.org/all/20260624075700.751467-1-alex@ghiti.fr/
>
> Alexandre Ghiti (3):
>   mm: swap: overlap synchronous readahead decompression with disk I/O
>   mm: swap: bypass synchronous readahead unless the target needs I/O
>   mm: swap: treat SWP_SYNCHRONOUS_IO devices as synchronous in readahead
>
>  include/linux/swap.h  |  6 ++++
>  include/linux/zswap.h |  6 ++++
>  mm/swap_state.c       | 67 +++++++++++++++++++++++++++++++++++++++++--
>  mm/swapfile.c         | 11 +++++++
>  mm/zswap.c            | 17 +++++++++++
>  5 files changed, 105 insertions(+), 2 deletions(-)
>
>
> base-commit: 13a1e1a618858407fa12c391f664ea750651f6b2
> --
> 2.53.0-Meta
>
>

