Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71658CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 07:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F134A6B0088; Mon, 12 Oct 2026 02:59:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3336B008A; Mon, 12 Oct 2026 02:59:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8B186B008C; Mon, 12 Oct 2026 02:59:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1C136B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 02:59:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C31580957
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:59:56 +0000 (UTC)
X-FDA: 85313074392.08.DE3BFDD
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf03.hostedemail.com (Postfix) with ESMTP id B438520004
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:59:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=G9gV4hQR;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf03.hostedemail.com: domain of "prvs=874515ac43=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=874515ac43=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791788393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CcWrqNemADK/mln6DNzOJx+M3ACSVL80PiMouDsi/xQ=;
	b=oTilVxvrzqOWWLq71PRkrKnOCjcZqcFTfxxG2/vr4+UDNZElRdSrz7KAaQzmzr0O5ReZZT
	ijOmFGN1m5i8eVSN6ibMXu9uS6PdA7gbhjcmBvD4kWJYx6vb3OJuOkW8gBwG2qpP0RNpcu
	F9YvUFjv5mSP1o/8b/T5ijxk6wDrUqY=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=G9gV4hQR;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf03.hostedemail.com: domain of "prvs=874515ac43=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=874515ac43=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1791788393;
	b=IgfBQ5Ep9ffgKtZ9vLLtfr8Gc7IFDKSG9myNGun8EtcHH51nvYvTDqRc4LGNwfnew0T62/
	LoPiSZJPolTagPSN5ywebiqox2RSQuAT4VbCvcjXROpQDyeNPLVlUTUqtyoyndODnkDose
	PrnZ/qSqkjzJmKoS+F104gPlQr+/kZU=
Received: from pps.filterd (m0528005.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69C54aLh4193036
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 23:59:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=CcWrqNemADK/mln6DNzOJx+M3ACSVL80PiMou
	Dsi/xQ=; b=G9gV4hQR+tfzrodz1RVBmkPNPwacUyqePsb1GVv7iCXF7H1Jqbrqp
	KHqs4qY4nR4K4k+ezZqK2a3t6X2mxpgZnhP/dJFq8Pn09mNrwTi9lw6Kc6lo9BiM
	GQB3+TKyzs73V2LlqDySWrRVictTiZy+4iLdqaw/odxdcQ3LAGsALLskePnIh3QA
	+yvoHC5A9JwfYxa0X9SQD6gEI33+1aTsOHQPIKgIhV1nOHlcXqEFswzHggMG29lZ
	GRs4Ca9v0sr9hsxvrYeY0MWbQrWbBtGGrVsPvsZXZgAIlfDGU3BSs2W0SJON+Ejq
	2EAJc0o5jr9Fgsm8DOl/CoB3bYnJWy25w==
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4h86xhn1uv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 23:59:51 -0700 (PDT)
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c2e1db672ebso188210766b.0
        for <linux-mm@kvack.org>; Sun, 11 Oct 2026 23:59:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791788390; cv=none;
        d=google.com; s=arc-20260327;
        b=jf9LUFskyAZNnWspdQ/QMdNFP1SJJqaM6zxfLEjKNCAX0XEFcdwwHnEkg6tcY0Gmdf
         9V77i7VtEoOLKdVODzx//awX1eKD8DTYCbLXtHaKUM9jNHw2o89VvV15eK2bqqxPSxb9
         zKfghtsUZMeU3G1EyHFAdddefjeUT72Gd6z/6haWe/hMif0ssc0x0sGLnch5aLObzUW6
         safLE53LvjzD0XsS8KDrmlCFEyYv6Tc1dPOTl1icN+9lUPt7xc2m1BK4PAC0TRuGkMm7
         RfXTUv5WLWCBrjzIEYzXQ9tg0yBp289oL8mlzDKpopHLgn3c2Dr+1hZwy5hE1hAIEi6M
         PyJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=taHU/KI4QI2caWxNyUiB5tVDqT2+4EOk9Xdzto/bT6A=;
        fh=8UjjqNGQ6FISKkp1HtVHcu6du3/vD26fjKnBuA3u0l8=;
        b=OIKHhzWGgrkL/U6KpywwhMRZbYJceMbyNTSRW/SBQWCPBgp36Ga93HIStyV0y6wfgM
         V4jNPNL8dJtvBH11Hs4hkwXktiKuXfIROkg3cJr4P0+Ts8dFzSax5F+Q0azXQH+bh554
         ejyeK+rehArXWXZ9FTn0hhajWD8weUaHUWESjPyMWDIBo7TZt6RhvMcauH8DFbMogTQZ
         esaDxolRjs3oZ7kIxUbJ+BcmwT2ZNk98ECYhTd3kKMHzBqb97TWfUQ7awPVWX8UQecoq
         JJEjmAFfO3gb4hgxWlcAMhWDYcWbS7yZrh+aL0SizYJo2ghELaU5hE2bja2Q1UxvwQKj
         Jskw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791788390; x=1792393190;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=taHU/KI4QI2caWxNyUiB5tVDqT2+4EOk9Xdzto/bT6A=;
        b=tqJrO/7acce8gTnDLIc7BrjkRDWD+yvux2l0fnJVH0HxEwbTIa4kyfobz/le/Lyc17
         qeW6smTnrsN4W/RyUGE1IpNqRFoN5ejLYxu6xXSaOs2/dPI2wkeRMCA2Rw+Lm73rHd/e
         VYvXoCHYoh0NKTZ1/oXyuTco2td3xxiFtV442ZzSGJOXliLHSK0f/uAfwEiMHlRNisMh
         yGbidILsHhCCDfKVr3w47qTel2RDLOiSLvtDshT9rLG0wBQPtvoMe9Io/a67ngYv1cKM
         sG5jpwIJYtG2ZTdABTeJG7sH6Tynjy/yfazUCxW2o5zfXdajONiyfKA0OeFhD2ARue+p
         foxA==
X-Forwarded-Encrypted: i=1; AKwUvBywrVa8yRRonuta5vwuO1sOqbzhPE+on4XmYmQtIGv1ZjO0dNl/Ftnt3+oeN0olaAYanSDYTiMhtA==@kvack.org
X-Gm-Message-State: AFq9FYIIO9rPOs+4wX/P0ExFRThM4EtQYg6rxZa6/Ynmgij6v8rigMhn
	UGyC/rm13S4hJRfD03uAyfWOkuIfExawpg7JRWUeOXCvUvittosPgroN02FwSLXVct72vG/vBaq
	RxhCvbB6yvVNfDgDgpCcEqsIpHmai06MZQESS1t9mCffQ0aNa7wSnk2Tm9oNz/M9B3agjxXqIsf
	W7mdR3Xubdy2pn1+AG1JowuRqC3w==
X-Gm-Gg: AYBFou3XuVuGYnEUeQ8gw9gD2MWgOBqVCHpONRm6qm6r51KOB/F9BwIJzB4iMBgDN5N
	y/NRvoS5GjPS0CZPDSMO0uLcejcu9zzImCD5j9iN++3FKmHSoM6X+iAYtK28D18tTW1TSTfCdfm
	2S3Cs9SePv509jt5S20um3O4VAH4rupskyp5nXlBdyWV6ES0JCxULGRg8tbWCXhQRAwKSdXHsYN
	uKNqovH/ZVFbxF48w==
X-Received: by 2002:a17:907:7210:b0:c2e:3124:2394 with SMTP id a640c23a62f3a-c31a9fb6cb1mr848803466b.41.1791788390441;
        Sun, 11 Oct 2026 23:59:50 -0700 (PDT)
X-Received: by 2002:a17:907:7210:b0:c2e:3124:2394 with SMTP id
 a640c23a62f3a-c31a9fb6cb1mr848801366b.41.1791788390002; Sun, 11 Oct 2026
 23:59:50 -0700 (PDT)
MIME-Version: 1.0
References: <20261007153915.53429-1-alex@ghiti.fr> <CAGsJ_4xyzgUH4uhKqpD7PTVuOzdsAkYgowsyn5iT1LHWiaYqqw@mail.gmail.com>
 <CAEmasaWQm6DPqAhmW_z=kuR+3LDWJ=h+yM0hAs+ryNoFQd6qmg@mail.gmail.com>
In-Reply-To: <CAEmasaWQm6DPqAhmW_z=kuR+3LDWJ=h+yM0hAs+ryNoFQd6qmg@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Mon, 12 Oct 2026 08:59:38 +0200
X-Gm-Features: AclHuK_YHJJZcoS-MZ9-u5zq7ARhz27VmsFbDhDGqeJGqqJr4YJZ9_eIeNErZcQ
Message-ID: <CAEmasaXa2pB_Jm_VgBZAWQwu1p75yUSY2=dr0Opt5okLgWk-YQ@mail.gmail.com>
Subject: Re: [PATCH v3] mm: bypass swap readahead for zswap
To: Barry Song <baohua@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org,
        hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
        shikemeng@huaweicloud.com, baoquan.he@linux.dev, youngjun.park@lge.com,
        chengming.zhou@linux.dev, david@kernel.org, ljs@kernel.org,
        liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, kasong@tencent.com,
        ryncsn@gmail.com, chrisl@kernel.org, usama.arif@linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDAyNyBTYWx0ZWRfX49mmimJIxL+f
 9TRT7ad5FflcRMrcoqCwsmObHn544b3PoyZRYHj0zqxk6qL25kHw57ohPy8tlo+pzD3QjXlIUls
 t2na5bcUOv3SUxwQX+Xkm84zrjzGJ+s=
X-Proofpoint-GUID: Yxlyutwb1uOCjG2CQMrJSzZEseAW30yp
X-Authority-Analysis: v=2.4 cv=eeGo7LEH c=1 sm=1 tr=0 ts=6acc8567 cx=c_pps
 a=edIAN7ErZTGbxav20d8A7Q==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=jCddH8ec0KUNCymVuxII:22
 a=VabnemYjAAAA:8 a=VwQbUJbxAAAA:8 a=fcEPiMyxzdwRcWG7a60A:9 a=QEXdDO2ut3YA:10
 a=nIuFr-8touD1a-RngYHT:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: Yxlyutwb1uOCjG2CQMrJSzZEseAW30yp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDAyNyBTYWx0ZWRfXzfha/akfXr+H
 rj6JvZU2ps3P6MZcAF0XrGlA/v7GU65vmPdP5UASXS1jiFc4kAAZp+XOflk4G138+2r2PHc29HN
 PzlNS0vLEgl7ga8wnW8u86WKN+gwvqp4jJPlBjnS0xH9IFWnJqSD+rugKOemsEULXodoNJkMI7p
 Ber+c5qKannh/YDvwCOIOF6xJA/5gamkr+Xf2d+iaeoupJ9Cs0+qdHNwIlM3d4BpUftnpMh/6zY
 p8c0c/8GilJByVry6nv5lhkqaGVxOLaX1hj/lv+88Boa/C7jx6Pw8LQ8oXY48L0dlQIs1/kcupU
 AYBAsoHqK7ERRV01Ckg/PIXOcTfOnNZ6BeFJu0ta+Wvg3tVM3X2raCulkC9Ux2eOhq1dRrs3bxV
 VfX2X6OSekkFIq53mOx/FWGN/KEovg+m32MRJo9MiNHx6TiJlmhFbBsHCMsq+YBMBRavahaqOYz
 6ndi32N133YjVuFTjoA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_02,2026-10-09_01,2025-10-01_01
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B438520004
X-Rspam-User: 
X-Stat-Signature: mwcso17fq1dy38pagwqe1cya93g5673w
X-HE-Tag: 1791788393-5503
X-HE-Meta: U2FsdGVkX18mPsnKGy7VgQdU3ZYNhY04QWTBimsn3MXVH121bnycn5Wj5dVnV/SZ6Ya7TTNxZFyy1TMyMl2xR7uROL9t9TvsmnizMhpASI14l7qblr9h01bPdqlmwTFI+/nVk2tds4VqammLRphscOiSoIOvEKCsbP7P38mvC9n10aSwFt0jrLpOvUtLldOUJSG8rSHaM8bassxPizocUc87uw+au6kfM4NjTix40DA+gjy8nX03LEAp6WXNYFkZfr4qAB0ufpVm5ep/FidNm8OwYVgfvf6XQjoz2IWHyWGBEOtCiZlWgrz+qBFEAY5Cp2cy9YwNtS43ig2hpqLZfJKovB6Ce+U09nKH3Nq6ZwE24es9Dz0ufx3Y9vB8qeanrVNg+Xm/ddZT5BckBFU7c714EzCX34PB5xO3bWWcy6LWnT/yPrc4FzSq7xkcm6fwIIjbsvR3FBOgWGrcOOwZXKygqpwuhO+hYpPQjja0pFL3QDfxZOwn5R21RIyzPeWEC4G7lNrRGvu76CBIjwE89rIRwrne0IrfTtQwK+PzwYFiSGUEp+7QjW2UfsDt6Z3lJvLM4LXJT7oigD3OVAdJ6sy7hg/jVNX4lbruTsDowuW0dykv+WElctpgM3hDrXW1Vbh2qTFCibOA0bDA1QdsQEmRxRpcGQZyJb37TDMV6xWTb4HbGCdK2e5zWXwAw68eO5UhjDX0XP3BQgprSA+G2+CchSIoZP6whhuYyHIsucqymdO2GjAEqm19x7hfDjvUGNkehVk5+eOmmiRiEbQjlvA7bztHPIklzriDY8CwFIYYQPpqzPzgASSDsa/rSf2r2bQzncb4zbqNQcgYdfQfRZCf4TauvjEfakJX4F4qYoRJs9ZkTHhtUoYEtPjDsbf2wfwSuPG9fVFia02fO7YXVEvMid9dRwpso+CIyFPT66YhB4x28NjaI4GzkX0f4irp4L4OhiNB/vj19rymlfa
 UO1uf2tx
 M8rDFL+cF0oNAk4MJxJMENEYAtre2DeC8NJ/E5NkO168iBTRm7w3mVml8wfH3ivsjiPKzq16ThnQtJS6QdpWPTZg9iKJu5MjmjK1YlhFItsX2iS8vky8ZfRo2g14jpKto0ioIo6f1veuhzgoInHUedABXTgBN5928A8hBbLNnth25CguytApvZTDsIzkZ6zgzGmTVKEmOT8/zHo1Rh4Sv7QKPwmaJin2lgcAwksOhnR6j72x584ryLaSekxOWaN+JAV2T4oxCmWlS9hQ77kCspLpnNlMGddkRXGBLqw3zCjHsPS81mkKyku3mJP/3LFWj4YP5P3z16Bi7aHYOlpuFIfTx1nBhdFtMdhjptjEluKhC/xORXUsYzjMNdMi8JcyY4HigF/m34l3ghYyDOVDWJIr7OkSQdw8UaIcspET+k+AkaBi8nXR3nkSh3R+pu8JCG+MRqYtHPan5BjNvcHGnEqYCE2ms8+0meWepfSc+lAkY8TJeISTVyED9j8iDlDEf+jcMwl7SsAS1otTnM4CoODpSoBPFwiHPZNuuoZxctyr3aTjBaDkvw9xVFjfO6Dj5FpwgSe0nV40jyR84z5t/hXPUmhe2yWSrEzi0w5sEcXC3ww5F+F+dzn/ccjmOh3pnFoWn9h9DpZv5hqylrklkBrS6mA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

On Fri, Oct 9, 2026 at 8:22=E2=80=AFAM Alexandre Ghiti <alexghiti@meta.com>=
 wrote:
>
> Hi Barry,
>
>
> On Wed, Oct 7, 2026 at 11:05=E2=80=AFPM Barry Song <baohua@kernel.org> wr=
ote:
> >
> > > >
> > On Wed, Oct 7, 2026 at 11:39=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr>=
 wrote:
> > >
> > > Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchron=
ous
> > > device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readah=
ead.
> > >
> > > zswap is the same kind of in-memory, synchronous backend as zram, not=
 a
> > > swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
> > > swapin_readahead().
> > >
> > > Here are the results from bypassing readahead for zswap too: it was
> > > measured with a kernel build (make -j16) in a memcg, zswap=3Dzstd, sh=
rinker
> > > off, on Sapphire Rapids and 3 iterations.
> > >
> > >   768M memcg (sustained swap thrash):
> > >     metric                 mm-new    + bypass    delta
> > >     build time (s)          405.0       341.7    -15.6%
> > >     zswap-in (GB)            79.5        53.0     -33%
> > >     zswap-out (GB)          144.8       115.6     -20%
> > >     swap readahead (pages)  6.79M       0.45M     -93%
> > >     swap_ra hit (%)          72.1        89.9     +18pp
> > >
> > >   1G memcg (light pressure, build not memory-bound):
> > >     metric                 mm-new    + bypass    delta
> > >     build time (s)          177.7       176.0    ~same (no regression)
> > >     zswap-in (GB)            10.2         7.5     -26%
> > >     zswap-out (GB)           27.7        25.1      -9%
> > >     swap readahead (pages)  1.07M       0.08M     -93%
> > >     swap_ra hit (%)          68.6        87.2     +19pp
> >
> > Hi Alexandre,
> >
> > I assume your configuration is as below?
> >
> > / # cat /proc/sys/vm/page-cluster
> > 3
> > / # cat /sys/kernel/mm/swap/vma_ra_enabled
> > true
>
> Yes
>
> >
> > I am curious whether setting `/proc/sys/vm/page-cluster` to either 0
> > or 1 would result in the same performance gain on a zswap-enabled
> > system?
>
> I'll test and report back here.

So I ran the same workload (kbuild -j16, 768M memcg, zswap only, n=3D3 per =
arm):

    768M memcg (sustained swap thrash):
      metric                                        mm-new
page-cluster=3D1    page-cluster=3D0    + bypass
      build time (s)                               530.0      462.0
-12.8%      452.3  -14.7%    452.7  -14.6%
      zswap-in (GB)                               95.7        66.7
-30%         64.2    -33%     64.4    -33%
      zswap-out (GB)                           169.3      138.3
-18%       135.2    -20%    135.6    -20%
      swap readahead (pages)            8.37M     1.93M    -77%
  0      -100%    0.53M    -94%
      swap_ra hit (%)                            73.6        86.5
+13pp          -          -          90.7   +17pp

Exact same results with page-cluster to 0, so I'll add that to the
changelog as you suggested.

Thanks again for the review,

Alex

>
> >
> > >
> > > Similar gains were observed on an AMD EPYC 7D13 host.
> > >
> > > The gain is from no longer prefetching pages that are pointless for an
> > > in-memory backend: readahead inflates anon residency and thrashes the
> > > page cache (file pages get evicted and re-read), lengthens each fault=
 by
> > > synchronously (de)compressing a cluster of neighbours, and adds
> > > compression traffic when those extra pages are reclaimed.
> > >
> > > Bypassing swap readahead for zswap therefore makes sense.
> > >
> >
> > The change makes sense to me. I am just curious whether setting those
> > configurations would result in the same performance gain.
> >
> > Maybe you can mention the `page-cluster` configuration in the changelog
> > as well.
>
> Sure, I'll do that.
>
> >
> > > Suggested-by: Usama Arif <usama.arif@linux.dev>
> > > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> > > ---
> >
> > Reviewed-by: Barry Song <baohua@kernel.org>
> >
> > This is RC6 now. You probably need to respin it after the new RC1.
> >
>
> Thanks Barry!
>
> Alex

