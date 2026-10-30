Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 809E2606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 05:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vHfRjYMT
Received: by kanga.kvack.org (Postfix)
	id 05C836B00EF; Fri, 30 Oct 2026 01:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00D646B05B1; Fri, 30 Oct 2026 01:32:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65336B05B2; Fri, 30 Oct 2026 01:32:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B362F6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 01:32:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E16DC120545
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:32:28 +0000 (UTC)
X-FDA: 85378172376.11.945AE0C
Received: from mta0.migadu.com (out-26.mta0.migadu.com [91.218.175.26])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2AE2240007
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:32:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vHfRjYMT;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.26 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793338347;
	b=G+8TEgxRJXJGX5rZJcSbMi+GC7YQIt+p7VdyNfZUec/z12PSmC6SeNVSzqG2gPusKhfIW2
	UNW+UkWqC9rl1x/jonFDadR1K2u0vw1du/8pCNVTxBIvNfXpkVcVVdTnRipiNzzgf0HT+q
	idyV+qtDCyaoYk49AvWSqKhwJPsRzSc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vHfRjYMT;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.26 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793338347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VTDrdrBuAyTJnkqjgvXYYtVwc9zTl+F88XwMGcc4YDE=;
	b=2RToVLDpEL579m10saUyZOT5SujOBxK/xDCTSAYwq8nkvvL6VlrploccgWrPQ9bJq70Qe3
	eLiAs1ToE+EKU1IVcM+1um5vZX8ZwWVF0lwmsSIPQBuc1rpL754JtKKFcFuuBptORmcjra
	vsJzubMTN+6IEHz+RlltccVyjSFtUR4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Bf0WWkeJSETIqyNNL0Tk2W1KhY+0SCl/fI1XWH+Qygc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793338342; v=1; x=1793943142;
 b=vHfRjYMTLE8GNmV/NQ930J2ywQJhyanjVI75XVY+Rep9T7tsczB1jt3b7nefwWbYQQHhTYpb
 iqzg8eNAu1Xwp0lliVRb1Bc0n0dDbxlw7ENRHSVJ1UOiue1mIXVgC4W1E5mOo6hJME16DhnrQBq
 go8H6oQ4AOnRkh5x1foQvjtU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 9f9ebc0d777873bb;
	Fri, 30 Oct 2026 05:32:22 +0000
X-Mizu-Trace-ID: 9f9ebc0d777873bb
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] mm/hugetlb_vmemmap: Fix usemap overrun on nodes with
 multiple ranges
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261029212137.3141875-1-tim.c.chen@linux.intel.com>
Date: Fri, 30 Oct 2026 13:32:06 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Frank van der Linden <fvdl@google.com>,
 Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org,
 Mohini Narkhede <mohini.narkhede@intel.com>,
 Pooja Jain <pooja.jain@intel.com>,
 Doug Nelson <doug.nelson@intel.com>
Content-Transfer-Encoding: 7bit
Message-Id: <0611C182-4A76-4751-A04B-0849EC31DAD3@linux.dev>
References: <20261029212137.3141875-1-tim.c.chen@linux.intel.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Stat-Signature: yhqagkqoyumfaswp4rw5ifzcmt6yd3hi
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2AE2240007
X-Rspam-User: 
X-HE-Tag: 1793338344-957322
X-HE-Meta: U2FsdGVkX19j7WQDeFvegYw1PCCNtfZNxw9kHPLh6iz8QMMfypOkkU/pnUYYjHFh+lax54DYT5He9J6d3QWOnK+c+LzrI04bHlO2jQt3pAVDl9N5bJFNc10YDHuCZZ4EMMDbRLBUYYivXHDdC3N2LopRmO9tNn4LS2UyQchUvXCytVxSe/ljro5qMb58105L0jVOySfb8AJ5egKwiJvjVszMGyuIo3fc/D/YmIGuE9j87aZpmFqNiYDDvoFUlwILka6xcZsBcADD/1Kvm73y/47DHr/KQm1mh6SzIiv7pC/8/4CFoOROVW5ko7fs16f+PW0vpgszEBI2hwgdIUkPyrr+R6X1lkFP7fblQVu1ecgwjqJqw4Zloi2T8WKu1UWMRoE2ou6Er0PCF7vLr8SSrWOqErbfeq2I/2enpyfGfgSKbX/0yqa4w4za5jP5qYFt3r3hwDpkVQpdRDtj99v1dkZsf9kipt17dbng4BQlewpezRfFVuqpJRnEurN0sshzK00HiGNHmG58ETEjed4jL66PGsOpGgHZsnCVVAAx0MmOl7ZeN3duUjjL5RSy8CmEWB+DP9J37h8LZkkzMdRUVT+O+wx6NgAeEs3veIDJ6RGnXlt8XxboI7ro4ennkm7UuOWLAPJ4sfW2sKC2QssCF/l7BVJofwcv8RLweaACfvWgr+MUyPykUdM6fdR6Udu+ojcO6u07gBVysi6Doo7acOfJ8ZZu+y6tzcDp3hQtfkwUP4zPVzfWuArStXUSeGEm5WpEAiZr0dcwOgAD4NOxCx72j2MSnxf5c7LPK2RHF2Xlw7B3n6bTUbO7aeNjvNQH0/VefIXL9UpCarNHLGlRpjP314tSnGaymuRNjzlRAd8pxUg+GyHXgJWZTuDL/oQyyqLzvoqloPpmVH9bW7O6OOXlvlwHypuu/ALMLAqI9c/iLaJhPxZo79J520GHkOk4JaRbFPsr1Wa+C8dL+L8
 lOMPoQDW
 PXR+58Aa+6gWApaBzkHFhWl2sID41RV2e1q5ltOhitOKpCANbzTTDrz7o0teH/apnPQXKCTFgkJMaNdVZvpkZl7jXAuEEf0jKTYQGo4hqN7SRmPUEDs0nkC6Lv8pdFZ/AHFKDfDx0z5iadH/X5gtDq8egepE3IdP5ZgdvgH3KdDyUnOAHf8Lkn1qTGwJ/LAjiD7cZKpS2PDbDDc/Hrl6QYhkCwYb7umV121ZXgEtoEeTnGYxJDfDi66dqDLisK8SyNg8pVv59I9sff6GDJcemOQYNYFWWkqayfMj1SnEYevNenmpfX6B3HMBeO5WID1rJOZ+xACypgO1m+HM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 30, 2026, at 05:21, Tim Chen <tim.c.chen@linux.intel.com> wrote:
> 
> sparse_init_nid() allocates one usemap slot (struct mem_section_usage)
> per present section in [pnum_begin, pnum_end), and
> sparse_init_early_section() hands them out in order, with a BUG_ON() when
> they run out. hugetlb_vmemmap_init_early(nid) however initializes the
> sections of every bootmem gigantic page on the node, including pages
> outside the range being initialized. If a node's memory is split into
> more than one range, sparse_init() calls sparse_init_nid() once per range,
> and this takes more slots than were allocated. The same happens if a
> gigantic page straddles a node boundary.
> 
> For example, with this SRAT layout every node has a small range below 4G
> and a large range above 4G:
> 
>  Node 0 PXM 0 [mem 0x00000000-0x2fffffff]          768 MB  (low)
>  Node 0 PXM 0 [mem 0x100000000-0x80cfffffff]               (high)
>  Node 1 PXM 1 [mem 0x30000000-0x5fffffff]          768 MB  (low)
>  ...
> 
> In 128 MB memory sections (x86_64 SECTION_SIZE_BITS = 27), node 0's low
> range is sections 0x00-0x05 (6 present sections) and its high range is
> sections 0x20-0x1019. The low ranges of the other nodes are 4 or 6
> sections, all smaller than the 8 sections of a 1G page.
> 
> Node 0's first range has 6 sections, so 6 slots. With "hugepagesz=1G
> hugepages=400", hugetlb_vmemmap_init_early(0) then initializes node 0's
> 1G page at 0x67c0000000 (sections 0xcf8-0xcff, in its high range), and
> the 7th section hits the BUG_ON() (seen on v7.2.6):
> 
>  kernel BUG at mm/sparse.c:268!
>  RIP: 0010:sparse_init_early_section+0x9f/0xb0
>  RAX: 0000000000200000 RBX: 0000000000000cfe RCX: 0000000000000020
>  RDX: 0000000000000cfe RSI: ffd7e1d09fc00000 RDI: ff252cb28ffb3f50
>  R10: ff252cb28ffb3d40 R13: 0000000000000d00
>  Call Trace:
>   hugetlb_vmemmap_init_early+0xe1/0x140
>   sparse_init_nid+0x56/0x370
>   sparse_init+0x192/0x2b0
>   free_area_init+0x7f/0x690
>   start_kernel+0x64/0x540
> 
> Here RDX is the section number, and R10/RDI are 6 slots apart: the start
> of the usemap buffer and its current position, which is the end.

A detailed analysis.

> 
> Pass the section range to hugetlb_vmemmap_init_early() and only pre-HVO a
> page whose sections are all present and within it. Ranges are disjoint,
> so each page is handled once, in its own range.
> 
> Skipped pages are not marked HUGE_BOOTMEM_HVO. Their sections get a
> regular memmap from sparse_init_nid(), and the pages are optimized later
> by hugetlb_vmemmap_optimize_bootmem_folios().

Thanks for fixing this.

However, the master branch has already switched to section-based vmemmap
optimization, it has been already fixed. So this fix should target the
stable kernels (6.18, 7.2 and 7.3).

The change LGTM. So:

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.

