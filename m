Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1C8DC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3658C6B00AD; Mon, 13 Jul 2026 12:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26FBE6B00AB; Mon, 13 Jul 2026 12:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026D16B00A6; Mon, 13 Jul 2026 12:14:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B08956B00A9
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:14:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D84FA0209
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:56:23 +0000 (UTC)
X-FDA: 84984205446.02.7882A40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 966E140007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:56:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XVNKvtbY;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783958181;
	b=mAQUtNF5qX5KmTkMr+xfbfbYnj6AwNtQeI5NDHoHbntPbuOiUx1rJ/KWURTuVZLckajhXB
	mr1a8DNgw02W89Yw4USV6LcieXJbLksnomEIAdD3fABLPEGc+mlOTCJPnE/MmZOr9/Rdxi
	fj2IG+JPp3yRrp87S+ng2TmMhVZIz0E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XVNKvtbY;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783958181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2hRNlK5GbUM2BXSOT1bCJlv6QwIluqoBZWiGq7IjONk=;
	b=tK6N7WaM8TN8+T2iiYPK/RuQG5DTmkmXUdUvyVaq7XSAJ+SP6FsR83EWPNoJ6HM8/w+f+s
	dftoBh41ERvD2+uXHVvfGPvdCNPqgl462mDcjWx8KJQtPtvxS4g9RZT5dN04YUH+SEl13N
	fxSx4kbD8NQDF0R/c5RgGqOG9HTi8q0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 781E142AEE
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A9D1F0155C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783958180;
	bh=2hRNlK5GbUM2BXSOT1bCJlv6QwIluqoBZWiGq7IjONk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XVNKvtbYKpLzG0Yhbbo1cnBXgL5L9iTHLGaCqc6pZI+1sqiaFApbXbn6ETZ44NhgI
	 P432eE82xvzyRpUasUiI0L2K7cHbD2oFQOqg5vjCjecIPRQLr90eY5eM96c8LcIIwn
	 X1QKiKltFL5339Wq9d1XSPgNE5hFnjE+nMDPum9MviD55JeGztrCfmN30eG+U184rr
	 Si5OYhIL0oAxQWwZPOmyfdJghJzVN40jZU8uZCU8g4BrbuSOzKqIkTb7ilgpsTZ4UC
	 8FDUL7Qbf+Jv3piCDXqZdcEz08CAgvCjYR2BtUrJ58ihiR+jdDWRH4nI4g3hdbND9e
	 aQSt3l1+E1HpA==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-697564cb69eso26074a12.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:56:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RodfQ9AScUTqh6nOGMTqEbtWtjSjy/b6VNVPzCHjm5pmpiEm87OYj2NigZ0Dhjxt7AZZqbUJcY8CA==@kvack.org
X-Gm-Message-State: AOJu0YzLop/tClwR6y/zDBJ07guR6ktAKvqQJWUNoxJ9qTRT5xkZYeXr
	DIgqQap4e+SNJItElpxqFy039cuZY5qQ7JFZQ/K5Dgm4nfSkPoVU3Tfen+SLORK4i32KYgjXu4X
	z02zWa7MyJiYiL6z+81pV+pQ/7Vk3IQ4=
X-Received: by 2002:a17:907:cf87:b0:c15:e614:7042 with SMTP id
 a640c23a62f3a-c161e9a840cmr416947166b.25.1783958179115; Mon, 13 Jul 2026
 08:56:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260713133613.2707815-1-usama.arif@linux.dev>
In-Reply-To: <20260713133613.2707815-1-usama.arif@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 13 Jul 2026 08:56:07 -0700
X-Gmail-Original-Message-ID: <CAO9r8zP586AFSeNKuaUVZgkPb-mKuLGbQ8m5_od_-GLg7bu90w@mail.gmail.com>
X-Gm-Features: AVVi8Cc8w2GyfUCat11G_elbDa74woQHSvrz6tR62KY3kcf0DOpn_B4GiDBiiV4
Message-ID: <CAO9r8zP586AFSeNKuaUVZgkPb-mKuLGbQ8m5_od_-GLg7bu90w@mail.gmail.com>
Subject: Re: [PATCH v4 00/11] mm: PMD-level swap entries for anonymous THPs
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, chrisl@kernel.org, 
	kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org, 
	ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, 
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 966E140007
X-Stat-Signature: c5r9i7tpxsbnudpzm7dwid3xhcrproak
X-HE-Tag: 1783958181-529704
X-HE-Meta: U2FsdGVkX1/A6yA0X85LmXc0PcCY332eM9a/pOIM4heQom/5gjNwgGRR5kasziMkSqmWcieBgUVuGlnfstezQnbCxQGQu6YTRHxoP7uF5NdXCoX8D4MaiJmbqKpy4g9z04DFDnCjbw025+cmQFvLq8G8juzvxrwmAxGds5xEB+tbSmR44mPRnjEHtLxJmj0nWT7O4sQaIKpzwAI6iUFnP4fp5LMHqJWJfcmP5KgSp6WHEum0fNPQlzpznXxUiTHayNSE4MlB9gYj+sheQDayScDzrGmsLP6ZFFms1+lQ0DtSd5YeXeauf2IO6GfPvFj1nRMgDv3kLKu8eZXMaW52KwX+Y4Cf5532XJ/MNejRi2vsBVZeqAITLQtcF4gPWjMREWZ7c/8RI9wLi3BtnifLE/HR/yE/oy/E0LrSEncuXmHGwSPWtlYAI4ByivsaCHfmvS4CFFIJSsZdm3VXJJ5Ix6LRD4Y5TPmIWZmK4N0xZnNj9j9Uu1kYLyq8HRT9mJReKPgbfSrXedxT77JkKHDhndMfLY3cRcGXBrqtj6Cba8FS5Uub/IiixKyQTGdUPDOT8OPgSy8367hadJUKlrJYs553NpswM9FMuy7XQZvWyUc9JImd3i8xj7Z2dsxqEI3dBLGmhoLoeABYiWpgK7L5qlk+QI6zIicz1jrim6S3GJRe+9pgvt2/wS1EErqf5IA5bLqlJ/tgd1C4gx9aj1XTsVGZfUr3v6zKsOaV3UxZSBCr1OOAe+i/Q5wbdArBNKON8CDxileZ+vTEXRNOBNZt/qu1gGfEXreDvyAtzoP+fBONW8az4ubliV/5H72w+09hdXGasBnTjcmwi80FRxuyWzEKYRSvdzqDiFmUUbovHKLi+MmI4F0LT5icNM+bYjRm671mPBihCP5Ts9xNhtlwLnI7GaeygmsBkXHQQmHGpfj7n385E5I6yZN4IwQ6QWZPRyFCZkEkHiG9ZfQ7Vdf
 jvxYS96C
 we2RxWIHeIskIFGkyCRzmcPjt3soSx1CEIYTJw9Dtua9uyjM4CYl4ZxM3QNO0cnr/qZLodv/M1+0oFhruvXOc7NYCQan59WsTQLFW8ZKGLEV2CpVA+4HHHThGq0QE/vyL/GEcKGQRJbySW+A/05x5OH9XCWdYf9LEjKpdDPDfRfu6550UetSlSIWV1cpKY14o/vxFQUlNVFznxowlRQWvLDsW++ItFwui8i0hVkaUBa0lXMpJF1QC5N4gqW5JJ6zxUe2qmh5pjO1ifb157HaHDp+/gvvYnMaOsSTf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 6:36=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> This is the PMD swap entry core series. The preparatory PMD softleaf [1]
> cleanup series has been merged in akpm/mm-new, so this series is now
> based directly on akpm/mm-new.
>
> When reclaim swaps out a PMD-mapped anonymous THP today, the PMD is
> split into HPAGE_PMD_NR PTE-level swap entries via TTU_SPLIT_HUGE_PMD
> before unmap.  This series introduces a PMD-level swap entry so the
> huge mapping can survive the swap round-trip and do_huge_pmd_swap_page()
> can restore the PMD mapping directly on swap-in, without waiting for
> khugepaged to collapse the range later.
>
> The PMD swap entry is a compact page-table encoding for HPAGE_PMD_NR
> consecutive swap slots.  swap_map accounting remains per-slot and is
> unchanged.  Importantly, a PMD swap entry does not promise that the swap
> cache always contains one PMD-sized folio.  While the cache is empty or
> contains one PMD-sized folio, PMD-level handling can proceed.  Once the
> cache has split/per-slot state, users either inspect the individual
> slots directly (mincore) or split the PMD swap entry and retry through
> the PTE path (fault, swapoff, MADV_WILLNEED, UFFDIO_MOVE).  Likewise,
> if any slot is still backed by zswap's per-page store, PMD-order
> swap-in consumers split and let the PTE path load the range page by page;
> an all-on-disk range can still be read back as one PMD-sized folio.
>
> The series is ordered so every consumer can handle PMD swap entries
> before the swap-out producer starts installing them.  The swap-out patch
> is the last functional change.
>
> Patch breakdown:
>
>   1. mm: add PMD swap entry detection support
>      Add pmd_is_swap_entry(), teach the softleaf layer that PMD swap
>      entries are valid PMD softleaf entries, and add per-arch
>      pmd_swp_*exclusive helpers.
>
>   2. mm: add PMD swap entry splitting support
>      Teach __split_huge_pmd_locked() to split a PMD swap entry into
>      HPAGE_PMD_NR PTE swap entries.  This is the common fallback path
>      whenever PMD-level handling is unsafe or unavailable.
>
>   3. mm: handle PMD swap entries in fork path
>      Copy a PMD swap entry in fork via one
>      swap_dup_entries_direct(HPAGE_PMD_NR) operation, with the same
>      swapoff/mmlist preparation rules used by PTE entries.
>
>   4. mm: zswap: add range lookup for large-folio swapin
>      Teach zswap_load() to let all-on-disk large folio reads proceed to
>      the backing swap device, and add zswap_range_has_entry() so PMD
>      swap-entry consumers can split only when a specific range has
>      per-page zswap state.
>
>   5. mm: swap in PMD swap entries as whole THPs during swapoff
>      Add swap_pmd_cache_lookup() and use it from swapoff.  Empty cache
>      and PMD-sized cache state can be handled at PMD order; split cache
>      state, zswap-backed slots, allocation/read failure, or non-uptodate
>      folios split the PMD and fall back to unuse_pte_range().
>
>   6. mm: handle PMD swap entries in non-present PMD walkers
>      Teach zap, mprotect, soft-dirty, uffd-wp, smaps, mincore,
>      mempolicy, khugepaged, HMM, and madvise walkers about PMD swap
>      entries.  mincore reports PMD-sized cache state directly and checks
>      per-page slots after the cache has split.
>
>   7. mm: handle PMD swap entries in MADV_WILLNEED
>      Let MADV_WILLNEED prefetch a PMD swap entry at PMD order when safe,
>      treat an already cached PMD-sized folio as complete, and split/retry
>      through PTEs for split cache state, zswap-backed slots, or races
>      with per-slot cache population.
>
>   8. mm: handle PMD swap entries in UFFDIO_MOVE
>      Move PMD swap entries whole when the covered range is empty or
>      backed by one PMD-sized folio.  Split/per-slot cache state returns
>      -EAGAIN after splitting so retry can use the PTE move path and
>      update per-page rmap metadata.
>
>   9. mm: handle PMD swap entry faults on swap-in
>      Add do_huge_pmd_swap_page().  It maps a PMD-sized cached folio
>      directly, or allocates/reads at PMD order when the cache is empty
>      and the range has no zswap entries.  Split cache state, zswap-backed
>      slots, and PMD-order resource failures fall back to the PTE path.
>
>  10. mm: install PMD swap entries on swap-out
>      Stop forcing TTU_SPLIT_HUGE_PMD for PMD-mappable swapcache folios
>      and install one PMD swap entry instead.  Zswap still stores the THP
>      as per-page compressed entries; PMD-order swap-in consumers preserve
>      a PMD-sized cached folio or read an all-on-disk range as a whole THP=
,
>      and split before reading per-page zswap state.
>
>  11. selftests/mm: add PMD swap entry tests
>      Add pmd_swap selftests covering swap-out/in, fork, fork+COW,
>      repeated cycles, write fault, munmap, mprotect, mremap, pagemap,
>      mincore, MADV_FREE, MADV_WILLNEED, UFFDIO_MOVE, and swapoff.
>
> Notes on zswap:
>
>   Native PMD-order zswap load/store is intentionally left for a follow-up=
.
>   Alexandre Ghiti is currently working this.
>   This series can still preserve PMD swap entries while zswap is enabled:
>   zswap stores the THP as order-0 entries, and PMD-order swap-in
>   consumers split any range that has zswap entries before reading it.  If
>   zswap has written the whole range back to disk, or the swap cache still
>   contains one PMD-sized folio, PMD-level handling can proceed.

So in the swapout path, a single PMD swap entry is created, but
order-0 pages are compressed and stored independently in zswap? Just
checking I understood this correctly.

