Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 721F9CD6E60
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 10:22:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEFAB6B030F; Mon,  1 Jun 2026 06:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC7D56B0311; Mon,  1 Jun 2026 06:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADE046B0312; Mon,  1 Jun 2026 06:22:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C14E6B030F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:22:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3CA66140507
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:22:36 +0000 (UTC)
X-FDA: 84830954712.02.E6828D0
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8D4E8A0002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:22:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p7dsjWCH;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780309354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oPZZdv/NbNMHW5NCcV0iaaUZxovjPZu3VG+R2rQdX+U=;
	b=xSR7MKOiTwgg7vsx7axlXGjTxhR8LEmme8dubGmrK7NTBS7f99k+4cxqdjwf0ME8KjjQZz
	FiTk2pv4jfbIy+SsOIb4hVKjfKoMb/cSYM4uWxK0CyAaAN64d/cpzmWzEqD8zC4gG8LBXw
	VfOWZ4N/fxRAmZec8Jnvs25nY0VnbGI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p7dsjWCH;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780309354; a=rsa-sha256;
	cv=none;
	b=RxOOfBX6dxdrF78kdAD2o5HRy4XgEzrL2BV+uTFaXHNvja7/0JHQTSIXiBYMxa+vCkRXv4
	dk+8kYRFNsor9qy/adgYHvMuqVuxj9TSsrX9ScM7+UhK+2PiIiRi29YILJbZeDSeWWDjL0
	wdv5G/GjIj4y94rrGgES4uV6cq1gMTk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780309352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oPZZdv/NbNMHW5NCcV0iaaUZxovjPZu3VG+R2rQdX+U=;
	b=p7dsjWCHL7EpFMCaLyQrf7JLU/eEAG83YHK41hodap461fEKBTCpvHcg6QaMvbIVabbEuD
	rDXBjEqPL6/pOhxj51YoHh1WwSj5xBhRRt9AWX50DXF6rv3q1XKIBhQBBSGoDKv6cg4/fP
	JZs/KGtesM/+F98iHSLMIvREohG76CM=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	willy@infradead.org,
	ryan.roberts@arm.com,
	linux-mm@kvack.org
Cc: pfalcato@suse.de,
	r@hev.cc,
	jack@suse.cz,
	Andrew Donnellan <andrew+kernel@donnellan.id.au>,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	dev.jain@arm.com,
	kees@kernel.org,
	kevin.brodsky@arm.com,
	lance.yang@linux.dev,
	Liam R. Howlett <liam@infradead.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>,
	ziy@nvidia.com,
	hannes@cmpxchg.org,
	kas@kernel.org,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v7 2/2] mm: use mapping_max_folio_order() for force_thp_readahead order
Date: Mon,  1 Jun 2026 03:21:18 -0700
Message-ID: <20260601102205.3985788-3-usama.arif@linux.dev>
In-Reply-To: <20260601102205.3985788-1-usama.arif@linux.dev>
References: <20260601102205.3985788-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: y196m7yh1ir38tthjen53dbr7iqsg9ja
X-Rspamd-Queue-Id: 8D4E8A0002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780309354-907549
X-HE-Meta: U2FsdGVkX18tEQehFOGe8YcEE51ola8H7lwrD5pVkoBE/ZQ0xNckp/1fu4FbEAMHVRfSOayQymXWYuLQpZc0GrRq6+jjRqn/VyEG/pR4jlGjtomn8wkaefxM8J8jRbpY4fXw8ZBiA8jirroPZXevZzCsjWOThsLzSjGmfuaHHFT5M43iiobF8F4ljHYMfneCt7OO0vbZeLq7fWUhmTh1lQ3EH8cbyxQ6JYIapu/7t3fy+zQqu3J46pTUi/MmEP0fkwnCSZuMPO7uXHz9GZxLxr0mbOVtybSwmIHsmqi1F3BSYhOz2fHLNlHcVCswcUkEKtb7eEWEFp6Z3bgAYXmN0KKfs2v0EM9wTdBvlezZLIEHYac5/SU0BicQEKn9NCTHHE9gGVO5u9Zr2+Iz/qnwmVxOuLBDuYNgITokR7kUAp7bhrHykihhVBiMBzPrmlGKtrLBl+pzQCyJY+nWsJm7tuojmrK1fEW+OPL8+ev4FrE5Hpxzq9JTbFux/3ZheSxfVa5QQ2BQdR/RTVXRlkm85C1sEFv6KMxiRrgTpn8sh6nT7tOS0ntmF7x0jbfv0r/29dJftdpmlog4b6VYHre/tzzgwjnt7Byy8zCaK6AbejW5Zdvwc+8dCpomH/h5XVs4S+q2m6Pzbpi7MsyG2X9K9UOfswP2z9FpG6xtRl9f1UqTCyCoZoIMOasxkgqk/x59oLe2RKoR6Jey3inCQl0V6iN4h0NJGAsmxnqzUsHjVartfiLrnj4uyayI6tN4l21m8pfjCL2cJ1jbF07maJjMRDZe2pec75sEULQtlnl1q9pqfN7XUtbo0RH0FV8EQ5XTRNLgfvjkS/StQgxccz5ywiqAJjXU0ql/lYipqqPoL1ESasJXq6TneQ/yvbZEwcIshqdbdiL5ljCVMkoNc1OoefexurIZukJX6liyhUA6nmkboZZdG7nC3qj83Yaphn+gX8ecfphEVPSVdXz3GLH
 M1kkj7tJ
 yG50pQbyhS7Mj1Pqb69hWphrOAf8Wg6wVgHl30WcMHgdgB1aq2uv2uHVmgwR0wcuQ5Fe9AZLUxuRgMw41qYtkmBuPK+dBYkv8p1JJMoAIN886W/STHpP6UVNuHrWmP9ynFpeOV+04Gd2TxcfFf1/AHu3UPGbgwdmOfAtPCbww7NhRzMFTrLg2HWT++xlifzgJ5ysEZfSGwclN/C+3tH9bdpq+iLnGbbRr7gfBVI3LZ/v06iG9fr5ayCfrajFVclmRXM+AVuEYWUd371Sj3NHFWw84IwK+Lww+cLkFYaZQuyiGwgPJmaywqa6IDwqNDbVBLGu3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The force_thp_readahead path in do_sync_mmap_readahead() is gated on
HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER and always requests
HPAGE_PMD_ORDER / HPAGE_PMD_NR. On configurations where HPAGE_PMD_ORDER
exceeds MAX_PAGECACHE_ORDER, notably arm64 with a 64K base page size,
VM_HUGEPAGE mappings cannot use this path and fall back to the non-forced
mmap readahead path even when the mapping supports useful large folios.

Enable forced readahead for mappings that support large folios and request
the max folio order supported by the mapping, capped at 2M.
2MB is chosen as the cap because it matches the PMD size on x86_64
and on arm64 with 4K base pages, so the size/memory-pressure tradeoff
for folios of that size is already well understood. On arm64 with 16K
and 64K base page sizes, 2MB is also the contiguous-PTE (contpte)
block size, so the resulting folios coalesce into a single TLB entry
and reduce TLB pressure on the readahead path. This will result
in 32M folios not being faulted in with 16K base page size for arm64,
but with contpte, the performance difference should be negligible.

The final allocation order may still be clamped by page_cache_ra_order()
to the mapping and request geometry, but this gives VM_HUGEPAGE mappings
on such configurations a large-folio readahead request instead of
dropping back to base-page readahead.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/filemap.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index a16b33e0fc71..9cf89efaf3f1 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3312,14 +3312,26 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	struct file *fpin = NULL;
 	vm_flags_t vm_flags = vmf->vma->vm_flags;
 	bool force_thp_readahead = false;
+	unsigned int thp_order = 0;
 	unsigned short mmap_miss;
 
 	ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
 
 	/* Use the readahead code, even if readahead is disabled */
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
-		force_thp_readahead = true;
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
+		/*
+		 * Cap max THP order at 2MB: this is the common PMD-sized
+		 * hugepage size, and it avoids memory pressure from very
+		 * large forced readahead when mapping_max_folio_order() is
+		 * high (for example, 128MB with 64K base pages on arm64).
+		 */
+		if (mapping_large_folio_support(mapping)) {
+			force_thp_readahead = true;
+			thp_order = min_t(unsigned int,
+					  mapping_max_folio_order(mapping),
+					  get_order(SZ_2M));
+		}
+	}
 
 	if (!force_thp_readahead) {
 		/*
@@ -3354,17 +3366,19 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	}
 
 	if (force_thp_readahead) {
+		unsigned long folio_nr_pages = 1UL << thp_order;
+
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
-		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
-		ra->size = HPAGE_PMD_NR;
+		ractl._index &= ~(folio_nr_pages - 1);
+		ra->size = folio_nr_pages;
 		/*
-		 * Fetch two PMD folios, so we get the chance to actually
+		 * Fetch two folios so we get the chance to actually
 		 * readahead, unless we've been told not to.
 		 */
 		if (!(vm_flags & VM_RAND_READ))
 			ra->size *= 2;
-		ra->async_size = HPAGE_PMD_NR;
-		ra->order = HPAGE_PMD_ORDER;
+		ra->async_size = folio_nr_pages;
+		ra->order = thp_order;
 		page_cache_ra_order(&ractl, ra);
 		return fpin;
 	}
-- 
2.52.0


