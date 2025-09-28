Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D383DCAC5B5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 21:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C49358E0003; Sun, 28 Sep 2025 17:55:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C20ED8E0001; Sun, 28 Sep 2025 17:55:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B36478E0003; Sun, 28 Sep 2025 17:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A0AB58E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 17:55:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E4DD1A01C3
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:55:20 +0000 (UTC)
X-FDA: 83940015600.10.9DC0764
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3EE901A0004
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:55:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UuXlS1H5;
	spf=pass (imf19.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759096518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pMA3FY1cLbcNhfw1XHhs0JDOqj11mx6kBKtX7cr5kdQ=;
	b=BuWrcs65HJ8xT30mMgu1BtuLrNLlxEsYaHV8pfsFpOg25JKtAwA6wApJrp59626DcTn9BM
	g06Beot8G4+2bKVyr3lwYIkJQCYNIV92smbpFYg6HAB37jQKNCWhZgi+SSqxpxEp0bJ2Dk
	AsP/YiXgCPowjrDNfEiPTZi9nwJ3fgY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UuXlS1H5;
	spf=pass (imf19.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759096518; a=rsa-sha256;
	cv=none;
	b=HBWC6CHXUQdfx+psdTGva9jGA+jj2CsVv3S0gbbvFdiAB0sQMr/YMxhrQqM2imNLH8DUOP
	OI0scbEWEYXDy84MEC8EPMY/x8jUvPeHfyR3gETuiOnWaAp2d22Kq9cISVLFoaCdONEvJW
	eyJ4b3OhsJqAw0SGw7GFLiZbcEt18ww=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-46e2b7eee0dso71365e9.1
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759096516; x=1759701316; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pMA3FY1cLbcNhfw1XHhs0JDOqj11mx6kBKtX7cr5kdQ=;
        b=UuXlS1H5p8gT6YFGuLOQWcejLjbQvOuxyBuNk/PupAUXcla9KfkENMXx7beWnwn2mm
         bf9N41w7sWI0ypL8ZbWMTlS7q3RR+hDrSTAKeqY28JGsfZG2faFc3w6A3MAu1LgnLCvx
         vUkUc0HJQEBMxwsxGuYYhidZMmgZ80fbCUg2SsJ7i9GR0ITtwUi5JItf0A1J8XGr1rEM
         2yVYXIFC2Mv21y8OizzQtFYirfG2bYg/SOqQDJFw3czRpZrAwJIt/TbwU4vWn90G+ulF
         TO1oK/EZ+P3MuT1mTbXnEiujqn58MPkW26Uj/RH1wSZgu8De74ch61fG7k2Gl/CufkQ+
         7gtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759096516; x=1759701316;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pMA3FY1cLbcNhfw1XHhs0JDOqj11mx6kBKtX7cr5kdQ=;
        b=qM7yNY8fxCy2zVuh1pmCSJe+mbgQvMbhxDPFQ5rJieYF8/qc7VnnU/LxaJDqIgHpqv
         LIXMWkWCvl55SqnCCx9Z6JPqdWNtZeHNk8SbDM768JRUQaf9O3RWY4BA41dTpMfSPN5b
         bTpdUTfVD9rtUSgCTTvTr/FKt/FJo0mkTZEB5pLumTyB9wpVV8lowOAaFcXSyVgHoz+F
         /8iaccbB9YZnw4FE6FB0hjOtWwNzUGoGdcHcmTfhXWWc8UDBNaSoCA09ckiNTFkaFAps
         twh+aV5COW70Uan06l6r/jDlDW+ZilbgjQAN4v1ehfuHmlOJb8vF6iNWFxApgHwdf9XG
         9UFg==
X-Forwarded-Encrypted: i=1; AJvYcCV2L3QezjQcJuw0wYq5KVV0ThK1msOh6cF/5lhqRlnghiUSJIg/JB96Os1U+hOC8Ff8LwwKj97LpA==@kvack.org
X-Gm-Message-State: AOJu0Yw/G1NbYaTz2t2h9s+aOohS2vMk6OIuM/6+BQHmYDwTrl+PvvjH
	hXgJSIyviyFly6kqBbpAeUYDc+52+iwWa7HblC1NanrWTTk1C5T83OzWdUYb6Tzd5E62mzgy80t
	NCIqRwbqKNWMo8maXi6EtJcf9gGFAUIXd1C+2oV8a
X-Gm-Gg: ASbGncuZXVD+aZrcB+vDK4kaPkGxlCEjdZZKdYiFActXJ2dTAVcL/iLe2GrHgt6Znzx
	+dRvAb7x6zwqNW9laMC47nwseCnQPpplaQRFBNMG5ePkofTcwb2ISfb+8uSVZR7xpIKVNX1c4nm
	hzahgAkep/qlNVw+7Z2BTQJFshlwzAKRmts/6veaJs88HorkPM50gtSq4gZuCugq1gXVlr5PLNp
	IjJHdGfHKYCUH2bwgGBvAGTKuQJMNvJryVXruma
X-Google-Smtp-Source: AGHT+IGuuHuV6NhRdtb2XbDDFb64hZXsw9U4K9RD49mZlUNSm0AUIK8jLtLvPojHIhekgdfDaYZhLDQcukon9pUOy4U=
X-Received: by 2002:a05:600c:1687:b0:453:672b:5b64 with SMTP id
 5b1f17b1804b1-46e3af88c70mr4043975e9.2.1759096516280; Sun, 28 Sep 2025
 14:55:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
In-Reply-To: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sun, 28 Sep 2025 14:55:04 -0700
X-Gm-Features: AS18NWCZXYADEm26_yLS0Zgi7PqfD8kDWiEzPUFTAPAgj2X_CDKkUG2kA8H6SOk
Message-ID: <CACw3F50ijQ20Vg8ycMROSCccf_XtjB_fFvLGxvQZ7eaNQoLwGQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm: prevent poison consumption when splitting THP
To: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	linmiaohe@huawei.com, tony.luck@intel.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	nao.horiguchi@gmail.com, farrah.chen@intel.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Andrew Zaborowski <andrew.zaborowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3EE901A0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: phzb6s5cku3qix6td7cscofkn9uge8an
X-HE-Tag: 1759096518-653674
X-HE-Meta: U2FsdGVkX1+VLYO+rCIgkES26zOMjW3Zb802C2e/T0RhTIBFGGkQPga2AvVJyl6SygHPBONPVPSS4pXYs4bySss6MELv6cDnpjbdQ7tVPf4CcY/YQnAsIwl2Trni97MN/88CUiNRZH45ys0mbc9VF1Yd6+2JXpZ1thFxVWKIxPc239qCDmEQBFRIo25xXDxs+VvCaXfDfCJoverHmoJ7wvM9w3s8COl+2h10lZIgyBRW7NEbekozY3uOIv7GCPgeFA9EsabdGGSKeqjsAol4vDubX7MNbQbO0g1usQjXNwZEO+VJo5m6TYRM54D1VwAw5+8iuOIot2rriEK/1AvHxEVmrgNpjSY19A2um+KVX1m2YBJ9yRDt9ikKzcRqfMKFChn4FHYnkHPN7IO/yp3O/cMAhME8WSnKBCGARJuxo+r8vv2rVGU9okJrZ5mi4N9T/IVMM1ethru8RWcjC9xBScFCpW6HK3bs+fLPFBGUUVj5hrvjncuPjYIbXSZjVvwMITfElJXBqyR38G1xX2kBrG73J0YJBfsSCySKBNOavFUfcaPet2um7wLbacfFDART4DRIKS9xP8jipYCdmLC4Qw5ygjRXK53hNKYO0HwlL40mwoSYM416ruzzTlaK4MD78LfobAZ8y00R8MqFkLED+530Z8kllaDpp38vGNQfMyoHTFHZe1LIDiOocY/L8571GofRi/LXU3yoKjFgLcVpf60P1T+eh5wRfeyvZRqKtJZloPctOXxLWAjpcoX6F1vmDU4tcKQ8ksV6MVV/c1GcD6CRvSL3VcqnUtsUkrudDHcnUd6kqgsaa4BfhAYbOw3s94tK+DagyR6mCTUDF9mf6BE076t3M5w7J/k5KrhBiDRBb/GtCpP5VcWenSRoYqZMF6m52yUGc7Bxtvko3ZfuxiGeL8NpD3aA31rOtU1NPPUZfVGKqxT09IhMLu0RJc8tx5mUZ8RYrT1RNZy+p1P
 1xtj5uRa
 GCW0NZgrSNBRmcQdBkZLJCj7M/UbcD6ACpBcgwwEqUG+veF1NW3xmoa2plmIE9YO7HmRDqnyKWavtFMUD/Y/Di4f1b67lWxYHzh3Ka0G/9ksmUeoYgLWopdYWWAemMmx1ZpVuzk3gDIC3ncUKYwV6kQKLczsAewoA10XkW6oykXA+Kt2ZxsQV0KNeOcgBWEKqKhhXi8U1+ktdlAVGpWS20au3koaqbBNtU2u/aLvJYp0ixwmgRWHfISVW+LCPhplIJtCiPjQfcmAdGAkajqN5zlVD++JtSExA7XjdSvyxT4hmtho6EWyxfkSzcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 27, 2025 at 8:30=E2=80=AFPM Qiuxu Zhuo <qiuxu.zhuo@intel.com> w=
rote:
>
> From: Andrew Zaborowski <andrew.zaborowski@intel.com>
>
> When performing memory error injection on a THP (Transparent Huge Page)
> mapped to userspace on an x86 server, the kernel panics with the followin=
g
> trace. The expected behavior is to terminate the affected process instead
> of panicking the kernel, as the x86 Machine Check code can recover from a=
n
> in-userspace #MC.
>
>   mce: [Hardware Error]: CPU 0: Machine Check Exception: f Bank 3: bd8000=
0000070134
>   mce: [Hardware Error]: RIP 10:<ffffffff8372f8bc> {memchr_inv+0x4c/0xf0}
>   mce: [Hardware Error]: TSC afff7bbff88a ADDR 1d301b000 MISC 80 PPIN 1e7=
41e77539027db
>   mce: [Hardware Error]: PROCESSOR 0:d06d0 TIME 1758093249 SOCKET 0 APIC =
0 microcode 80000320
>   mce: [Hardware Error]: Run the above through 'mcelog --ascii'
>   mce: [Hardware Error]: Machine check: Data load in unrecoverable area o=
f kernel
>   Kernel panic - not syncing: Fatal local machine check
>
> The root cause of this panic is that handling a memory failure triggered =
by
> an in-userspace #MC necessitates splitting the THP. The splitting process
> employs a mechanism, implemented in try_to_map_unused_to_zeropage(), whic=
h
> reads the sub-pages of the THP to identify zero-filled pages. However,
> reading the sub-pages results in a second in-kernel #MC, occurring before
> the initial memory_failure() completes, ultimately leading to a kernel
> panic. See the kernel panic call trace on the two #MCs.
>
>   First Machine Check occurs // [1]
>     memory_failure()         // [2]
>       try_to_split_thp_page()
>         split_huge_page()
>           split_huge_page_to_list_to_order()
>             __folio_split()  // [3]
>               remap_page()
>                 remove_migration_ptes()
>                   remove_migration_pte()
>                     try_to_map_unused_to_zeropage()

Just an observation: Unfortunately THP only has PageHasHWPoisoned and
don't know the exact HWPoisoned page. Otherwise, we may still use
zeropage for these not HWPoisoned.

>                       memchr_inv()                   // [4]
>                         Second Machine Check occurs  // [5]
>                           Kernel panic
>
> [1] Triggered by accessing a hardware-poisoned THP in userspace, which is
>     typically recoverable by terminating the affected process.
>
> [2] Call folio_set_has_hwpoisoned() before try_to_split_thp_page().
>
> [3] Pass the RMP_USE_SHARED_ZEROPAGE remap flag to remap_page().
>
> [4] Re-access sub-pages of the hw-poisoned THP in the kernel.
>
> [5] Triggered in-kernel, leading to a panic kernel.
>
> In Step[2], memory_failure() sets the has_hwpoisoned flag on the THP,
> right before calling try_to_split_thp_page(). Fix this panic by not
> passing the RMP_USE_SHARED_ZEROPAGE flag to remap_page() in Step[3]
> if the THP has the has_hwpoisoned flag set. This prevents access to
> sub-pages of the poisoned THP for zero-page identification, avoiding
> a second in-kernel #MC that would cause kernel panic.
>
> [ Qiuxu: Re-worte the commit message. ]
>
> Reported-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Tested-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> ---
>  mm/huge_memory.c    | 3 ++-
>  mm/memory-failure.c | 6 ++++--
>  2 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 9c38a95e9f09..1568f0308b90 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3588,6 +3588,7 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>                 struct list_head *list, bool uniform_split)
>  {
>         struct deferred_split *ds_queue =3D get_deferred_split_queue(foli=
o);
> +       bool has_hwpoisoned =3D folio_test_has_hwpoisoned(folio);
>         XA_STATE(xas, &folio->mapping->i_pages, folio->index);
>         struct folio *end_folio =3D folio_next(folio);
>         bool is_anon =3D folio_test_anon(folio);
> @@ -3858,7 +3859,7 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>         if (nr_shmem_dropped)
>                 shmem_uncharge(mapping->host, nr_shmem_dropped);
>
> -       if (!ret && is_anon)
> +       if (!ret && is_anon && !has_hwpoisoned)
>                 remap_flags =3D RMP_USE_SHARED_ZEROPAGE;
>         remap_page(folio, 1 << order, remap_flags);
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index df6ee59527dd..3ba6fd4079ab 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2351,8 +2351,10 @@ int memory_failure(unsigned long pfn, int flags)
>                  * otherwise it may race with THP split.
>                  * And the flag can't be set in get_hwpoison_page() since
>                  * it is called by soft offline too and it is just called
> -                * for !MF_COUNT_INCREASED.  So here seems to be the best
> -                * place.
> +                * for !MF_COUNT_INCREASED.
> +                * It also tells split_huge_page() to not bother using

nit: it may confuse readers of split_huge_page when they didn't see
any check on the hwpoison flag. So from readability PoV, it may be
better to refer to this in a more generic term like the "following THP
splitting process" (I would prefer this), or to point precisely to
__folio_split.

Everything else looks good to me.

Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>

> +                * the shared zeropage -- the all-zeros check would
> +                * consume the poison.  So here seems to be the best plac=
e.
>                  *
>                  * Don't need care about the above error handling paths f=
or
>                  * get_hwpoison_page() since they handle either free page
> --
> 2.43.0
>
>

