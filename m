Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 772FCC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:18:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AA4C6B0088; Mon, 13 Jul 2026 12:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781A26B00C1; Mon, 13 Jul 2026 12:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BEB46B00C2; Mon, 13 Jul 2026 12:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 310346B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:18:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF1B5401F5
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:18:15 +0000 (UTC)
X-FDA: 84984260550.24.E7A59B7
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 87E6E80009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:18:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ia1C88PO;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783959494;
	b=4FFl3vPviZc7HdcUqIn0zhKuF/kE0rhIqbKLHcfLVZ3rRvb+TyHuTzA+P5FUNMo5xX4WGC
	PymgpP86eZWAu0cyubI0Y9J1gfJmAr+ECUVlxFNI9PaCzLb7ZdmmiCP+TT8+Yr3tExInet
	YuTVGV64gmUIb7x1IxgH8/PbZ0p1MqA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ia1C88PO;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783959494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NE/5A5qkR6uAqQiCbOoPzdzcNr6Exfk7cAXEitmmrI0=;
	b=NVgByK7IgX3Pw7djUsPCAAhtEaPSrv+NoXe2IPrPcEx2FNU/Ik/FTcKvQUOqDG9G6pNl+1
	HIAQhKSthvYKnQCbnvAQfp2oxlWmhv9hMkpQyho4Z/vvzBlJkCQToA6YBjHHDg8GREbvfW
	ntJ5jB2HBReQTEGWOxg0kmkILDqTDnQ=
Message-ID: <03a20b9a-2984-4666-832d-0e35df919a7d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783959488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NE/5A5qkR6uAqQiCbOoPzdzcNr6Exfk7cAXEitmmrI0=;
	b=Ia1C88POnfJWrehgtJH6hSDce7pnx2cVNEFya3NdYsLuxozRTM1E5DnT5nWldTjrWQZkM1
	hF2ehYIrLZzj7kDXyGBtwMsDXrPznZLRKyz37HLJbu7psPRzQhgtQiQhqMmF8sT2Q1V6qI
	4dOJKPLlVONdcPX4+8y6ZtfcRoAc+FU=
Date: Mon, 13 Jul 2026 17:17:57 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v4 00/11] mm: PMD-level swap entries for anonymous THPs
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org, ying.huang@linux.alibaba.com,
 Baoquan He <baoquan.he@linux.dev>, willy@infradead.org,
 youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
 Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 kernel-team@meta.com
References: <20260713133613.2707815-1-usama.arif@linux.dev>
 <CAO9r8zP586AFSeNKuaUVZgkPb-mKuLGbQ8m5_od_-GLg7bu90w@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAO9r8zP586AFSeNKuaUVZgkPb-mKuLGbQ8m5_od_-GLg7bu90w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 87E6E80009
X-Stat-Signature: 37fy6p31k4icaz1q7rehz1r1knpue39s
X-HE-Tag: 1783959490-191028
X-HE-Meta: U2FsdGVkX1+WbdqG/PwSsAHllwWOlXEQUQ0zNd51PKcX0I6HlhnpWQRz3M41s/s8Nc5osPvf0o1uGQFeJYE+Vr5L3jJ8ClOgWqzFpgm4joBxgzRXHZgF60EfKdRmyjgOMszS6wGjuoR0xD3Q6HjrazXCd8gs59IsTJNH6Igo4DWb2jo/zroXWUIsstkQKdKeS7YknHrZKk54grXp8UmcUyZy+ILaMOo9DeXppIeD50debi7YHWB9iT5Q/3uax31M36aQDhyaOkW4NPpYNMZTnP2KesnSftordqr2FuqkfEo1R8coQvSYvFeg2Yo+mg/Q61zSuEMXL4iR4ns5Htkv2tXqqozO9fxSwLRYPlTeflRabYi7WWAP04qYd4gUkPitVCTeQy8ESW1tspVXCr383sXiGdIYfWyIJlGVHFg4PDoU9mKxYDGYESdR1hwzPQOFlQMRjHd5rUdE6stjAqifBL7IFnnEPZWcx5gCFH0f5b4QQV31+CTtv6a/1e49dJ+K16wQyuEGgFkMD1eDDz9fqky753VIaLJFo50P6L8NE50UayIv+/HFBJV0zni6SdU30wAULv1/N3f9frwbJovZzwtutFuto0W846cnXFCXJ0RtYx3vMJrhSYN/Q4qHfQQ5ae5fgekh+xIckzK+vXt/cmQ/+duphZ/3CCeM68hJkkNp4onwwNWEWn6RXeeC+7qtVQl9M/JNxo0cb2BEGsESIk/+ruWvWeOFtn9SJv9JfgYFL/20HtpTMnKxBkNXZ+5K9n9SCr8GSWCMDnY/YxkdnapL8VUcvf3W01vCSWuesM8qOHFTlGD9Yx8dHjkbO/7FkiRScFcoU2LT1VRhAg5fuIB3vSQgOI0hXFvIOrqjItW50pyZ3dH9YdYs5B8a4rlNK3WKgWA9x47uSedN2xd3h7jKPEdhswY/eQcCAHdG2rF6lyRUfMN/SUq7CyH3eBjnGhczUc17hnor5Od4PlV
 Y7JGWwZg
 yY1mbbwHiPON6PvBH0cxZiAX9Ztkt3dDuCCmcjdorecbYmXAOJncYSxXZDXnIaNjkYyU4yKg5wTFiiz1ONNxIj5/a9WWA6N+W9HmNoE0r9PQ+wKe4lc4UtG3pRvBblKor7HgN0SLsz3pi1diKRgMf7AgNW4qZPihetcWCdA8bVpI+hZHq0zwMuS6rZbMUZgZYjT3hI6Q+8/jF0J7j4Vob3g/IsHpkPtXxinmzNn4vczl1zx0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/07/2026 16:56, Yosry Ahmed wrote:
> On Mon, Jul 13, 2026 at 6:36 AM Usama Arif <usama.arif@linux.dev> wrote:
>>
>> This is the PMD swap entry core series. The preparatory PMD softleaf [1]
>> cleanup series has been merged in akpm/mm-new, so this series is now
>> based directly on akpm/mm-new.
>>
>> When reclaim swaps out a PMD-mapped anonymous THP today, the PMD is
>> split into HPAGE_PMD_NR PTE-level swap entries via TTU_SPLIT_HUGE_PMD
>> before unmap.  This series introduces a PMD-level swap entry so the
>> huge mapping can survive the swap round-trip and do_huge_pmd_swap_page()
>> can restore the PMD mapping directly on swap-in, without waiting for
>> khugepaged to collapse the range later.
>>
>> The PMD swap entry is a compact page-table encoding for HPAGE_PMD_NR
>> consecutive swap slots.  swap_map accounting remains per-slot and is
>> unchanged.  Importantly, a PMD swap entry does not promise that the swap
>> cache always contains one PMD-sized folio.  While the cache is empty or
>> contains one PMD-sized folio, PMD-level handling can proceed.  Once the
>> cache has split/per-slot state, users either inspect the individual
>> slots directly (mincore) or split the PMD swap entry and retry through
>> the PTE path (fault, swapoff, MADV_WILLNEED, UFFDIO_MOVE).  Likewise,
>> if any slot is still backed by zswap's per-page store, PMD-order
>> swap-in consumers split and let the PTE path load the range page by page;
>> an all-on-disk range can still be read back as one PMD-sized folio.
>>
>> The series is ordered so every consumer can handle PMD swap entries
>> before the swap-out producer starts installing them.  The swap-out patch
>> is the last functional change.
>>
>> Patch breakdown:
>>
>>   1. mm: add PMD swap entry detection support
>>      Add pmd_is_swap_entry(), teach the softleaf layer that PMD swap
>>      entries are valid PMD softleaf entries, and add per-arch
>>      pmd_swp_*exclusive helpers.
>>
>>   2. mm: add PMD swap entry splitting support
>>      Teach __split_huge_pmd_locked() to split a PMD swap entry into
>>      HPAGE_PMD_NR PTE swap entries.  This is the common fallback path
>>      whenever PMD-level handling is unsafe or unavailable.
>>
>>   3. mm: handle PMD swap entries in fork path
>>      Copy a PMD swap entry in fork via one
>>      swap_dup_entries_direct(HPAGE_PMD_NR) operation, with the same
>>      swapoff/mmlist preparation rules used by PTE entries.
>>
>>   4. mm: zswap: add range lookup for large-folio swapin
>>      Teach zswap_load() to let all-on-disk large folio reads proceed to
>>      the backing swap device, and add zswap_range_has_entry() so PMD
>>      swap-entry consumers can split only when a specific range has
>>      per-page zswap state.
>>
>>   5. mm: swap in PMD swap entries as whole THPs during swapoff
>>      Add swap_pmd_cache_lookup() and use it from swapoff.  Empty cache
>>      and PMD-sized cache state can be handled at PMD order; split cache
>>      state, zswap-backed slots, allocation/read failure, or non-uptodate
>>      folios split the PMD and fall back to unuse_pte_range().
>>
>>   6. mm: handle PMD swap entries in non-present PMD walkers
>>      Teach zap, mprotect, soft-dirty, uffd-wp, smaps, mincore,
>>      mempolicy, khugepaged, HMM, and madvise walkers about PMD swap
>>      entries.  mincore reports PMD-sized cache state directly and checks
>>      per-page slots after the cache has split.
>>
>>   7. mm: handle PMD swap entries in MADV_WILLNEED
>>      Let MADV_WILLNEED prefetch a PMD swap entry at PMD order when safe,
>>      treat an already cached PMD-sized folio as complete, and split/retry
>>      through PTEs for split cache state, zswap-backed slots, or races
>>      with per-slot cache population.
>>
>>   8. mm: handle PMD swap entries in UFFDIO_MOVE
>>      Move PMD swap entries whole when the covered range is empty or
>>      backed by one PMD-sized folio.  Split/per-slot cache state returns
>>      -EAGAIN after splitting so retry can use the PTE move path and
>>      update per-page rmap metadata.
>>
>>   9. mm: handle PMD swap entry faults on swap-in
>>      Add do_huge_pmd_swap_page().  It maps a PMD-sized cached folio
>>      directly, or allocates/reads at PMD order when the cache is empty
>>      and the range has no zswap entries.  Split cache state, zswap-backed
>>      slots, and PMD-order resource failures fall back to the PTE path.
>>
>>  10. mm: install PMD swap entries on swap-out
>>      Stop forcing TTU_SPLIT_HUGE_PMD for PMD-mappable swapcache folios
>>      and install one PMD swap entry instead.  Zswap still stores the THP
>>      as per-page compressed entries; PMD-order swap-in consumers preserve
>>      a PMD-sized cached folio or read an all-on-disk range as a whole THP,
>>      and split before reading per-page zswap state.
>>
>>  11. selftests/mm: add PMD swap entry tests
>>      Add pmd_swap selftests covering swap-out/in, fork, fork+COW,
>>      repeated cycles, write fault, munmap, mprotect, mremap, pagemap,
>>      mincore, MADV_FREE, MADV_WILLNEED, UFFDIO_MOVE, and swapoff.
>>
>> Notes on zswap:
>>
>>   Native PMD-order zswap load/store is intentionally left for a follow-up.
>>   Alexandre Ghiti is currently working this.
>>   This series can still preserve PMD swap entries while zswap is enabled:
>>   zswap stores the THP as order-0 entries, and PMD-order swap-in
>>   consumers split any range that has zswap entries before reading it.  If
>>   zswap has written the whole range back to disk, or the swap cache still
>>   contains one PMD-sized folio, PMD-level handling can proceed.
> 
> So in the swapout path, a single PMD swap entry is created, but
> order-0 pages are compressed and stored independently in zswap? Just
> checking I understood this correctly.

Yes that is correct, swapout installs PMD swap entry in try_to_unmap_one().
When the swapped-out THP reaches zswap, current zswap still stores it as
independent order-0 entries keyed by the individual swap slots. On
PMD-order swap-in, we only proceed as a THP if the swap cache still has
one PMD-sized folio, or if none of the covered slots is present in zswap
and the whole range can be read from disk. If any slot is still backed by
zswap, we split the PMD swap entry and retry through the normal PTE path.


