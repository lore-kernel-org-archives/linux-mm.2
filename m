Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 349E4CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 16:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DAA26B00B3; Fri, 22 May 2026 12:24:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58B396B00B9; Fri, 22 May 2026 12:24:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8DF6B00BC; Fri, 22 May 2026 12:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38B4F6B00B3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:24:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D635590B71
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:33 +0000 (UTC)
X-FDA: 84795578826.25.9629E17
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id 37D9D4000E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lMNCd9XR;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779467072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eUEQkfCpS48vhd7pG3LWfZQvlZUUwQD6sQuoo1yRhAc=;
	b=Bm11rc3mMG/9DH4E1/OTh2jNYUY0AWKbvUH4yBCh5nO2q08lmHh7UqtzDJTN+sVVCwFgm/
	3ESqCC4PXHdU1u1sWLSoBYPz+ZuuySv+CRDY8v45dWeTg6YfbDlEOFUsXHn+kYPVs+wnG/
	wl8QmRANSyhz3VscZQDLBq2Y4VH359w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lMNCd9XR;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779467072; a=rsa-sha256;
	cv=none;
	b=hsNt3c5r9PisdxhzeKz5DZp4AtBYPXUoj1TFBnqQhr2zPt8GGybhawiBhk00Pi2VGlqBW9
	bY+9mdB8Y4hkDKy63PPQuGzf+9d2qpWg90zOQVgOeTQNzKw1LXgFCIdbH8poURnY8/2DWh
	iefEnT/waozu808LtZzNxbP/W2Si1dk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779467070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eUEQkfCpS48vhd7pG3LWfZQvlZUUwQD6sQuoo1yRhAc=;
	b=lMNCd9XRdfAveCRrAZVzZGtFHR+8BsTSPcCiUD2gffC1zj+IJ41AGwd7nC7/37XTySS+s/
	+hRTJ0xdtmfvIQHJ7SI+REBFiBoehAxHB3RSlvfJPSzmzJWDYUr3kl/awo58EEq7/58BmP
	stsTkvN4x6Y+lbbb+JdldPwshzI90OA=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	willy@infradead.org,
	ryan.roberts@arm.com,
	linux-mm@kvack.org
Cc: r@hev.cc, jack@suse.cz,
	Andrew Donnellan <andrew+kernel@donnellan.id.au>, apopple@nvidia.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
	kevin.brodsky@arm.com, lance.yang@linux.dev,
	Liam R.Howlett <liam@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
	npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
	rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, wilts.infradead.org@kvack.org,
	"linux-fsdevel@vger.kernel.l"@kernel.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	kernel-team@meta.com, Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v5 0/2] mm: improve large folio readahead for exec memory
Date: Fri, 22 May 2026 09:23:46 -0700
Message-ID: <20260522162422.3856502-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: y3fk6fmgefmm6wbsgfwm65396rn9tykh
X-Rspamd-Queue-Id: 37D9D4000E
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779467072-693486
X-HE-Meta: U2FsdGVkX1/R7depWXx0ukv+0mkuqhiPbmX5ycHbuwaSSGGjNmx5M5t716WxEJ9QmKy4ajhAC1znMULmBwXRHPrKO0L5W6mJjC3NG6vMqHvnnDuAFDpX4MvwvxLDmeVp8nsEm+YWzCaOoi8+cuTgWzuMNmrDdA1J4wdneYphYmO4je/u+ClS9QBiuwl5xbqNj5mZdZFmBCFuk4k3ttlTU2MA4X0KEVmonGihAaMblYQe2SQQOPA1znG1TYcBrJEXp0rgdqZuZRmhNk3tbPceIKWzjnQxm9mnw2UwHw4ZI61BPPNbA1jCY0SuYR+AkPy3ZRy9xIyyeARfLu6aiUMffMvLCQM+AEGef3L8VFgrWHkdVr1CeUgprD9oS6GHF9ZLVnmhY6gjeHGqzoJE3zE1VugFhhUGR6xslPUwvXWszMAY0RhqFVNZ5iYLbOrpP812uk3fqsjNjMLMwjLPJNO5yibg6gsaj8a+I2xGBdWl4M4t0Inrh4duUl5hFYWZaQcUPzX+9F1p/EbpUaJBZeayFwGq2dfkKCUWW5kZfby2XCdq8KYh2QdwLDehqzGkUsB5G7o+ccylpL+sxcekLVV5rx7QaOSH8H47TSoTbYHjEAPjnXwzCwbN4dd15OIMCfb79s8iMgMEuv1wSZmuBrBec/np0BeufpD/UtlFNaoeogUN+5LXbwWtGpSZXWCOYGdY3VH2BbKPoWrB/sF8sLks8JDntFeBlQxFUjdC4Bouhq0xi52/GqXpNm/x2gAcSG7FSpV2k3ToN00kr2di/PjW1bz7w8eLU4MAZHpytmHecZI+9P8YlG/+E/CQril6hSqhdBeGRB/j3k5+LMhA05Tg6vRqEwRwjniq40LbOsbjKt7FiyVmVZhPl1uK3WogOpNNCogLSKozaBJ2jAxILevfNSaQiAqJmFKfSdCWpLwPgE8xHGYUwaKE2IFQDEGqbEQuH83Cp6FK96E1U8jnYin
 QwIhtlga
 xtPIOdrVCHVm9IsT+E70FNOTq5z1COROqAGM5AMC6UyEZj72f3qt1xx53rRDyAwFh6nEk+1YcXlhnV84PvNQHqieYc7MevO6hbcrEnl1roe91kRtw89Xc6RS/ezIMIMUCXR3tZ2sKUV3+Jh9jpAuYLAd1oOXGYO3JQnwey2xSMBV7E9tlR2OMRbaVGD0yfjl6KrCUk9Ns8kuXgOgKoIFqrmrkzgnUJb4N+tCvU87zwGptwnVXUJsRzL2h35QJoM3Je36/jQIBkUSQvTaNACqciAC+JRJJ7sv/b+14oGbnFMvii7nOMRPM/iR4bTC8nEMXcQPIhk4AwoMNF/o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two checks in do_sync_mmap_readahead() limit large-folio readahead:

  1. The mmap_miss heuristic is meant to throttle wasteful speculative
     readahead. It is currently also applied to the VM_EXEC readahead
     path, which is targeted rather than speculative. Once mmap_miss exceeds
     MMAP_LOTSAMISS, exec readahead - including the large-folio
     order requested by exec_folio_order() - is disabled. On
     configurations where the mmap_miss decrement paths are not
     active (see patch 1) the counter only grows, so exec readahead
     is permanently disabled after the first 100 faults.

  2. The force_thp_readahead path is gated only on
     HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER and always drives the
     readahead at HPAGE_PMD_ORDER. Configurations where
     HPAGE_PMD_ORDER exceeds MAX_PAGECACHE_ORDER never reach this
     path, even when the mapping itself supports usefully large
     folios well below the cap.

Both issues are most visible on arm64 with a 64K base page size,
where HPAGE_PMD_ORDER is 13 (512MB) -- above MAX_PAGECACHE_ORDER
(11) -- and where fault_around_pages collapses to 1 disabling
should_fault_around() (one of the two mmap_miss decrement sites).
However the fixes are architecture-agnostic: patch 1 reflects the
nature of VM_EXEC readahead regardless of base page size, and
patch 2 generalises the gate so any mapping advertising a usefully
large maximum folio order can benefit.

I created a benchmark that mmaps a large executable file and calls
RET-stub functions at PAGE_SIZE offsets across it. "Cold" measures
fault + readahead cost. "Random" first faults in all pages with a
sequential sweep (not measured), then measures time for calling random
offsets, isolating iTLB miss cost for scattered execution.

The benchmark results on Neoverse V2 (Grace), arm64 with 64K base pages,
512MB executable file on ext4, averaged over 3 runs:

  Phase      | Baseline     | Patched      | Improvement
  -----------|--------------|--------------|------------------
  Cold fault | 83.4 ms      | 41.3 ms      | 50% faster
  Random     | 76.0 ms      | 58.3 ms      | 23% faster

The patches are based on fb61d7dda82e416a89e1f918a08535ee38976995 (akpm/mm-unstable)
from 22 May.


v3 -> v4: https://lore.kernel.org/all/20260402181326.3107102-1-usama.arif@linux.dev/
- Drop patches for elf thp unmapped area alignment and deal with them
  separately. These patches will just bring folios smaller than PMD
  at the same level as PMD. The 2 patches now should be much easier
  to merge.
- Tackle size of THP for exec pages at the same point as PMD instead
  of tackling using exec_folio_order() (Ryan during LSFMM, Thanks!)
  pr_err("KKK %s %s %d\n", __FILE__, __func__, __LINE__);

v2 -> v3: https://lore.kernel.org/all/20260320140315.979307-1-usama.arif@linux.dev/
- Take into account READ_ONLY_THP_FOR_FS for elf alignment by aligning
  to HPAGE_PMD_SIZE limited to 2M (Rui)
- Reviewed-by tags for patch 1 from Kiryl and Jan
- Remove preferred_exec_order() (Jan)
- Change ra->order to HPAGE_PMD_ORDER if vma_pages(vma) >= HPAGE_PMD_NR
  otherwise use exec_folio_order() with gfp &= ~__GFP_RECLAIM for
  do_sync_mmap_readahead().
- Change exec_folio_order() to return 2M (cont-pte size) for 64K base
  page size for arm64.
- remove bprm->file NULL check (Matthew)
- Change filp to file (Matthew)
- Improve checking of p_vaddr and p_vaddr (Rui and Matthew)

v1 -> v2: https://lore.kernel.org/all/20260310145406.3073394-1-usama.arif@linux.dev/
- disable mmap_miss logic for VM_EXEC (Jan Kara)
- Align in elf only when segment VA and file offset are already aligned (Rui)
- preferred_exec_order() for VM_EXEC sync mmap_readahead which takes into
  account zone high watermarks (as an approximation of memory pressure)
  (David, or atleast my approach to what David suggested in [1] :))
- Extend max alignment to mapping_max_folio_size() instead of
  exec_folio_order()
 
Usama Arif (2):
  mm: bypass mmap_miss heuristic for VM_EXEC readahead
  mm: use mapping_max_folio_order() for force_thp_readahead order

 mm/filemap.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

-- 
2.52.0


