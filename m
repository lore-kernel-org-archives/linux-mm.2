Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B0E3CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 12:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2956A8E0006; Mon, 10 Nov 2025 07:34:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26CDD8E0002; Mon, 10 Nov 2025 07:34:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182F38E0006; Mon, 10 Nov 2025 07:34:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 00DCF8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:34:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E9CA5A313
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:34:13 +0000 (UTC)
X-FDA: 84094639986.17.A67499D
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9CBDF100012
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:34:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R8zHq+DC;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762778051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sy5DjoSQimDCENwTSGtt2eMZiZGbRj1r/HV/Tgc/t8U=;
	b=WO+ZbekFqqvCkbZL1Qe/rbsqwvvB6ur/3zWIE17j8DsdtzsbJXOxL/36d9xpBkdd0sCQ82
	xfL5DO/ejYGP/kBuyl1Favjr/l6x8cXQnKlyBzO8VcSR1n8tOclwX8VIxBFpQCjc20O+bg
	8Wf5CZ0VaC78pCMGUYb8Tb6cN8H8/Kw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R8zHq+DC;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762778051; a=rsa-sha256;
	cv=none;
	b=X6U0P9qvfDlc6EA9LZREOgjrXcR4hH1f2Z3dTUqMWCKiAI0C/eguAJY954rj+3ETcqGEDW
	iQTYit2jzxMsyUzOVjHFAOIV2lfNT1ZKgCOrbQkChB8iyjb1yh2dH7OwdLnUKVf9EcE3cM
	Lx8JK+QzuBxEuMVjHDbl4pyu0S6hFes=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-793021f348fso2006094b3a.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762778050; x=1763382850; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sy5DjoSQimDCENwTSGtt2eMZiZGbRj1r/HV/Tgc/t8U=;
        b=R8zHq+DC6srkQYIEfQ3jKKz32mVpxCpl/FuyrJdfvi0Pe8IQ0zHO1e1ft8NphzRkZ1
         c1AG4wnaAoUG728BNaCxEe5tFlBPaLmLR824V/AestDszthbct79CaHHoEcnbo+wLmvU
         6bD1RBXXQkjALKkKCDYYfpMU/AttOgqC5G6wjETXOHlAAvIdyrXtyKy9mNlUJddAS+v6
         EG1pXe//VqlymNCGRDAT/PD60/vWHFSDros8LP5OvS5XPxMCpAe7rq0735AEV+p+3v2c
         YBJlQl+gIWfZ3WUwvDyfQXVMx18HEwELc9e5DYYucVTWnnTc8bZV8tUAyOzrIkvTqtfS
         eTBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762778050; x=1763382850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sy5DjoSQimDCENwTSGtt2eMZiZGbRj1r/HV/Tgc/t8U=;
        b=CIqMMuMXzeg4Due7hMhBa8Iczo9wudIIW9yoq24MMp/Bd2qgwNrjiVWgY1WAXGZRRn
         tgD6ZFDDyiBOT9PA85y0/zBqI+LvjcxdhGHHoiijGs+2046N56ZyhQ0hsJIh+n2ObJ9S
         f6x/LpXZoT3i2Og1nBuuZyCid3OtstB3xVlMe9nzgjfsf56CSgLizyseD85AtggaxyfY
         O8opN6xGZqmbK79PAh1/g5NZFLWJ3VlP+RyG1JbhDt/35ze+wJR4DuBqcKkBOjs1N0m1
         i00S83KmGMcqrR9f8HUAfK/MmsZgnnmqBFuWF2u0pZEUB/gmK4sDDjTGHLwnJ05QwZmQ
         1d3A==
X-Forwarded-Encrypted: i=1; AJvYcCVNfyne9OWU00SbQTE73a9JpTCPZ5kz5dgaqNvLz69zX3ApUat0ihJca6128mzQDziMRuDO01AvTg==@kvack.org
X-Gm-Message-State: AOJu0YyoZb9Nu/80LD8Kd3Or7vYxNeAu6PWJ9AmVYVq+dtYcnXa0sWGO
	bbdwGJx6jm3DyTzvKWcaHxVXNtbcTBxUuk/OZHw1NnsRsZCi+7XDTAzx/Pd6oK1SUjBu16eQPyv
	BKMQ7PLm8AFnLNma8dgjx2vAd5rktJgQ=
X-Gm-Gg: ASbGncs5hYpkIa6JBConAJgLnoVpWPScpTGWHuvcTcEvHRC63QfCS8qNNSEu33+pMuy
	lEGgz+BrJow5OPsg7+3llPZBYwtCz81emRSkD3hSms52qVVAgxysPmMU7GuTCCd6S4Q3JuatZKI
	PCaRituy8sjbVVstDRSgq5kJkBpkI2YyLNHcGLNnZfYor8gYB5TNRJp76SfKvvUZeP0wc2Vyeda
	pd59sL8BV0ULVtuohvWFi1OVSbXFYnZfw9HlWooj/cBJPTsh9iZsgrq24OOXIuxyNST60/XGZE6
	qdHg0SoZTqel6UNH3C+IMI7Zzpk=
X-Google-Smtp-Source: AGHT+IGyg9aZV4dgyvFuRtdSsElpeyZ+CpTXqovvGuPUeZo+pqdjOClLE9fxRv8gppzbemj2+mN2w/AMZs0pWBdc88E=
X-Received: by 2002:a17:90b:3b43:b0:340:dd2c:a3da with SMTP id
 98e67ed59e1d1-3436cb7aa3emr8354432a91.8.1762778050319; Mon, 10 Nov 2025
 04:34:10 -0800 (PST)
MIME-Version: 1.0
References: <20251110-revert-78524b05f1a3-v1-1-88313f2b9b20@tencent.com>
 <875xbiodl2.fsf@DESKTOP-5N7EMDA> <CAMgjq7CTdtjMUUk2YvanL_PMZxS_7+pQhHDP-DjkhDaUhDRjDw@mail.gmail.com>
 <877bvymaau.fsf@DESKTOP-5N7EMDA> <CAMgjq7BsnGFDCVGRQoa+evBdOposnAKM3yKpf5gGykefUvq-mg@mail.gmail.com>
In-Reply-To: <CAMgjq7BsnGFDCVGRQoa+evBdOposnAKM3yKpf5gGykefUvq-mg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 10 Nov 2025 20:33:31 +0800
X-Gm-Features: AWmQ_bnm3NOQhTmQKSG361K0h_1KBf9RdCY2Qg8AObjYfkOGH4tdJ9Y2X52coCY
Message-ID: <CAMgjq7C5H0rV4tkosUEtwvHTd5bO+jxyQkW4xjP+8-qnjh=oiA@mail.gmail.com>
Subject: Re: [PATCH] Revert "mm, swap: avoid redundant swap device pinning"
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9CBDF100012
X-Stat-Signature: eyehrdtxoe6dhfbqofydefkabnzjoon7
X-Rspam-User: 
X-HE-Tag: 1762778051-746855
X-HE-Meta: U2FsdGVkX18x4JIEd0e2LcAaHlz0+2Bn3Jsm1arWycnjpZwDExiSFjDCrXrEeoYSIAmrEby4CWI9G/cZsU3QBJLPaz5oF64Hg0z8ooCNSR7yHW/wLTZi5wlKEodkETpuoRzNL7S+D/MY9lZ3oRCwpTQkYdnqEhFi4Ed5BwWY8szf31X9QhIeCkgqPU+dXWtGybV13j34izdea8g8cGdbyOqTbpVAcgBOvPvjPH4KvXXa+lIHuXj2B/C9GfCOFySe8SShER7DNJh/fg4o2/ok4N+8rXdIQuS9u8lLbvml2JCQM7F+vn4AwwnspcHz83ZdxUvQ4exYNDuUPDsrP2rOrJZpV9VW8tOTJpSc4WYUkGBVtsc1QNL3BdiNwnnTiwick3V1uWzyE3X37V/q8jjI4dxadSu3TQV26eNTskp1acjllIv5v9XKlch+xphz/waJz6/holX1HP+IHkhQ8zP+cbtXyIgD5FO6Fv14hpiXFr/pIwyPLPoxFnu13hL+05oxUb9K0TCahSL0uwxJ39G5mp0qSTM0gufyAH/04rnLGOnfkgzM0QYdgy+sxS7CFfjNTR7Y7K/DplhcgEr3VNtwaam68L6rBU0Hx272rPl9t72gxNrWgYBUys56mgF1O1T/ckgd2WKxt04uPBGDBV/Akk1UrBwJ2PcI9GPs2bqSk1/AFR0hcM91vKXrFD47uJ3Dl/9wbMCFvHIcVUq6SAz+iFdmsWdAPk2BFXvMouwP9OljoWYLpKmyUxS8TaFqI3J7TRv/XzTorzSfHGpkxGPn798c99ijoaKfkvc1WUIRM9F1Ww7xq/d9vb6Fnoe0jM7cwLrGx6l7jIwH6myflgGkpYw+tOmkfDtPtxVWW3YLA+KVU7BVEL5Xpem8D2OSr6ZVD9pzFhw8OGP5HSo2SRa7yxlvqyzbVgKJI+w3cE6xjtI2Ra1EKV8Jo8aEyKr2k1Mbp0Wu7J7UoTPcKN1uRAK
 a4afCvji
 iPMRYLm15VJloCFbStPx/0A99FLKbAWEhyTAme3IFjNCGwG9qYfjErJVOtVsRzSpsvlUVeSmUHmqNu4tcruPWwMMLV7q3Ad1ytpqyCOIHLw+ReCwfl9LwSZJOa1S6YN6tytu2RjJAaSvhv45tdHVBuSMsmMUoVoOJgwdqKySsR7SjLwmNejREP3I/7er4XEopu3zw/ByFfMjPQwYBXQrvM/Edtu5IQiVjHzmanlR158Yt4rKUVvKxHOL31wKNJVpgio8aVpdupCsn3crxwlWRyXLE1HQiHjCV0OojR3wNlAhHRtEebrFnz4UbGuvmWgUwO3nN+8u5uTNyTHWSAZ8ziMA8PjBmKkHan+fGp03OU7DFEKTbTKsBpXsGrNYIPiijgiSrc4+wzoBbRfCGHQn2DeRZAS7SY0zmRoC5qw70p9o2IyR1+IhRqLgxC1D44rP3K6pmElGHDG8m14zX+knI7MocQ53CdRWeZRvWjsLTCl3CIbIjb66NlEV/PRiG9b7nmVJB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 7:37=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 3f85a1c4cfd9..4cca4865627f 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -747,6 +747,7 @@ static struct folio
> *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
>
>         blk_start_plug(&plug);
>         for (addr =3D start; addr < end; ilx++, addr +=3D PAGE_SIZE) {
> +               struct swap_info_struct *si =3D NULL;
>                 leaf_entry_t entry;
>
>                 if (!pte++) {
> @@ -761,8 +762,12 @@ static struct folio
> *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
>                         continue;
>                 pte_unmap(pte);
>                 pte =3D NULL;
> +               if (swp_type(entry) !=3D swp_type(targ_entry))
> +                       si =3D get_swap_device(entry);

Oops I missed a NULL check here.


>                 folio =3D __read_swap_cache_async(entry, gfp_mask, mpol, =
ilx,
>                                                 &page_allocated, false);
> +               if (si)
> +                       put_swap_device(si);
>                 if (!folio)
>                         continue;
>                 if (page_allocated) {
>
> I'll post a patch if it looks ok.

