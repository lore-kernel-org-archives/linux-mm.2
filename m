Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFC5E10F9300
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 21:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 128716B0092; Tue, 31 Mar 2026 17:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DAAB6B0095; Tue, 31 Mar 2026 17:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE36F6B0096; Tue, 31 Mar 2026 17:04:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D96026B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:04:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D753C43C8
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:04:02 +0000 (UTC)
X-FDA: 84607585524.30.66F6D3A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 93F3A180008
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:04:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YEi+YEkR;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774991040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h+dwaOX5n/ndczpCteFPr7DnAUnnVSzfSXSdmQ6aRIE=;
	b=YyhDJ9yRkjHPE+FioBaJAMoSwGU6d9tJT7rMYlhWyz29tm1NF7eiZAXSosfA5lBNzCAToT
	KXScCVFCp3xFSkSJD+PRmEHLTPyZRfVtx/3pFGUQXfC5GnLTINJ4ZB34MQgWTFwbk4pe5b
	WmAkNoQqLCHjSOKd7XOPkIzuCfXWiOk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YEi+YEkR;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774991040; a=rsa-sha256;
	cv=none;
	b=EOyQ0UD++ZDEhRLMjDThGjVNJMNs4BzHDXfzUsR/AJn6X3BRLCgscyKxWM0JAAgZP1y1FS
	VvnETkSOY17HMq+dcXVXwPy0PxYCNMY4NKtdQYMLmHA0k44U8NCPHlTF1v4+1E9+Okibk4
	p9DK3E5uotuivd95iFseqAhZsXcSyRc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E43343934;
	Tue, 31 Mar 2026 21:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314A8C19423;
	Tue, 31 Mar 2026 21:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774991039;
	bh=KaBden7SmExwPJHyzGaa+U0JAT0uZGYaGJjpZd6mGJM=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=YEi+YEkR+oCasLray0lq+5kuo1+2wZ9JRos7Qg4UUWgwha+H9wKNwDVDaVRiQjhM0
	 v1qP22U72McErMgBo6jEMZ9ELTBCKF7d6geGf/b0NrhcNNuGf1oCXJmSvXezqJeye5
	 Q/CHgNU2V9CFScX8CF/IvI6TlvajmHjsJbOYGwTgatP05znUKtosMjHDxhpAkdDHwr
	 dJpBpOgNqeM36k+CxQ2keQ2a3jR5O7gBS7CIYZ3bClGKgLM6r39yWfRGXnpFbJvwAv
	 MWR4NcpHOwKXQMQPA4yvQ6TBZ8ZZJWZJm1gdWl1nuVjUvyWEaUjplrBLJMNmqNXnIi
	 sqbN3ebOmZnvQ==
Message-ID: <9d5a4703-a15e-4be6-926b-af2d98db40c0@kernel.org>
Date: Tue, 31 Mar 2026 23:03:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v4 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260325114022.444081-1-npache@redhat.com>
 <20260325114022.444081-6-npache@redhat.com>
 <7760c811-e100-4d40-9217-0813c28314be@lucifer.local>
 <0223d45b-e8b4-49a7-882b-477250d0c14d@kernel.org>
 <fef63b28-a364-4e7c-bdbd-6d0403632920@lucifer.local>
 <26fcec86-ee78-4f5c-8ca5-0e6230699cfd@kernel.org>
 <440d6b8a-d299-43eb-83b5-6625f9468e5e@lucifer.local>
 <37132e09-9c03-4afc-bc73-4bca416c5343@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <37132e09-9c03-4afc-bc73-4bca416c5343@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: z1wssy6azmoc368or5tcisojayyxy617
X-Rspamd-Queue-Id: 93F3A180008
X-Rspamd-Server: rspam09
X-HE-Tag: 1774991040-929628
X-HE-Meta: U2FsdGVkX1/dulfbXP2ZlBbG7b9b4bspKxthGJAR8NQOt8F1BjszcW1RQD9HLZlQe6vlKFwtke6ExBkNaXnBLTdPkS9t72QYaBo/r6Vaq032saDXUqCJIXW99QTOikEcxy+ykHiAeDZN989Mc2gfukVgPF/ahUnj7ZBbqVLhhHbU0MHYfJneNOQglwtpfiXStJx9K3T9Jyqyrww3XFcosCR8QhGwl3tNveDTgXwGwrH9x/XnOUzhScYG8M7FadH0G+Se3ZGzVV2KKDPQ9ZNefNN2Mmp/oebykSb1NDlQDglpMloOZfAJgMr/nZkc5PB+VgsPRapG6hL2l9g07Fx0jvSTb9yU/iGsGfBgsoDPFCuhoQr5+U7NTkeA534xp8f0DmqeeZDDSGGSqhVowDaAXY5VGysHXzb5JXXVOqXihhGcRVwcfdcRii3Qbzu58iE3NWiKkdwyd3R5hEOtU81Upgh0JpxvHwHMUSAqj4w/4RBcLUDhi2CLHjzOOcsVqcKxhif8WFSQwQT+MVp4nwjKkeR9Wbv87BMlAcSKJiK+xqg2O8OlLlYgbJi9m3cBk6Kid3MIHVnw/QygMtiOwQk/acHiQ+3FDoCPFIljED2uWqdzcetVwOEeDaUNvzlWpQPATKBjLPUaTPhxXdW4OyKs1Y3SPC7gw7bCVSwpftEDwe1B5fzJZOGj5mWhfmQ4KejWrDUKHH+qMBKRRryCjtmN/BH1E1cEJoLyqXgTgMHqzyOhB2tGzf2wr+P/Ca8awCuYcygaSTz6VdbpL2Ohqo/LQPVGYAmc75WqHWuoXnQ9mv3ezBbl8kDlbtgXbuKL+WakYeqA35ozB6PDSflQ4pLtiQVL42ZEXbzdzyoj2fUZ9CYuUMIPS0XfkSwdPQ6LCqWQaPVDZw/oY9StixibM70Jmpu3F6JTugNQ6uDpbOU3m9b5jY74Cai6l/JbQaMRZ7K7n8fpx7eJ864gq5/hq/o
 ZAOLEH2I
 JN0FiCma9hPQVirICuLkbuJpiB+btHo/dNPNzxPJRZFuR0PTEDROHlaxMCrxghC+d5l18F5uoGgn/NzpHaJKdjXjAQQWKXaopsO8JFZFbLTiWBklt/BeeKJWcKhkVNz48OgSC6ixXi7LpPFGd1d61E5W2sJVBp+nFSb0lcRZp5HOFWGDdPz3tfJQXWLJeaEByHbS+G3ItiNnRBb57AMRxvC/FBP82XPBcZ9mkb8KRcHk7t7XbQGlBSzhuEGtP3ROtY0rqgejyosVxuX6lSIzktegNlD91uWt0bhR/XXF00zb8mRk8DqvUOoE8WbAGP2z7m64TG/mGvs8k7XvTx56v7vvzXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 22:50, David Hildenbrand (Arm) wrote:
> On 3/31/26 22:06, Lorenzo Stoakes (Oracle) wrote:
>> On Tue, Mar 31, 2026 at 10:00:58PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> Right.
>>>
>>> The original code used
>>>
>>> 	bool mmap_locked = true;
>>>
>>> If the fix get squashed, maybe we should revert to that handling to
>>> minimize the churn?
>>
>> Well collapse_single_pmd() and all descendents would need to be updated to
>> invert the boolean, not sure it's worth it.
> 
> The code is confusing me.
> 
> In the old code, collapse_single_pmd() was called with "mmap_locked ==
> true" and set "mmap_locked=false".
> 
> Now we call it with "mmap_unlocked=false" and it sets "mmap_unlocked=true".
> 
> So far so good.
> 
> However, collapse_scan_pmd() consumed "mmap_locked", now it effectively
> consumes "mmap_unlocked".

Okay, I'm too confused for today and give up :)

FWIW, this is the effective change, and the effective changes to
mmap_unlocked and lock_dropped ... confuse me:


 mm/khugepaged.c | 146 +++++++++++++++++++++++++-----------------------
 1 file changed, 76 insertions(+), 70 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 26c38934e829..3ffff9f98b2f 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1253,7 +1253,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 
 static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long start_addr,
-		bool *mmap_locked, struct collapse_control *cc)
+		bool *lock_dropped, struct collapse_control *cc)
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
@@ -1428,7 +1428,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		result = collapse_huge_page(mm, start_addr, referenced,
 					    unmapped, cc);
 		/* collapse_huge_page will return with the mmap_lock released */
-		*mmap_locked = false;
+		*lock_dropped = true;
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
@@ -2420,6 +2420,67 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	return result;
 }
 
+/*
+ * Try to collapse a single PMD starting at a PMD aligned addr, and return
+ * the results.
+ */
+static enum scan_result collapse_single_pmd(unsigned long addr,
+		struct vm_area_struct *vma, bool *lock_dropped,
+		struct collapse_control *cc)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	bool triggered_wb = false;
+	enum scan_result result;
+	struct file *file;
+	pgoff_t pgoff;
+
+	mmap_assert_locked(mm);
+
+	if (vma_is_anonymous(vma)) {
+		result = collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
+		goto end;
+	}
+
+	file = get_file(vma->vm_file);
+	pgoff = linear_page_index(vma, addr);
+
+	mmap_read_unlock(mm);
+	*lock_dropped = true;
+retry:
+	result = collapse_scan_file(mm, addr, file, pgoff, cc);
+
+	/*
+	 * For MADV_COLLAPSE, when encountering dirty pages, try to writeback,
+	 * then retry the collapse one time.
+	 */
+	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
+	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
+		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
+		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
+
+		filemap_write_and_wait_range(file->f_mapping, lstart, lend);
+		triggered_wb = true;
+		goto retry;
+	}
+	fput(file);
+
+	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
+		mmap_read_lock(mm);
+		if (collapse_test_exit_or_disable(mm))
+			result = SCAN_ANY_PROCESS;
+		else
+			result = try_collapse_pte_mapped_thp(mm, addr,
+							     !cc->is_khugepaged);
+		if (result == SCAN_PMD_MAPPED)
+			result = SCAN_SUCCEED;
+		mmap_read_unlock(mm);
+	}
+end:
+	if (cc->is_khugepaged && result == SCAN_SUCCEED)
+		++khugepaged_pages_collapsed;
+	return result;
+}
+
 static void collapse_scan_mm_slot(unsigned int progress_max,
 		enum scan_result *result, struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
@@ -2481,46 +2542,21 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
 
 		while (khugepaged_scan.address < hend) {
-			bool mmap_locked = true;
+			bool lock_dropped = false;
 
 			cond_resched();
 			if (unlikely(collapse_test_exit_or_disable(mm)))
 				goto breakouterloop;
 
-			VM_BUG_ON(khugepaged_scan.address < hstart ||
+			VM_WARN_ON_ONCE(khugepaged_scan.address < hstart ||
 				  khugepaged_scan.address + HPAGE_PMD_SIZE >
 				  hend);
-			if (!vma_is_anonymous(vma)) {
-				struct file *file = get_file(vma->vm_file);
-				pgoff_t pgoff = linear_page_index(vma,
-						khugepaged_scan.address);
-
-				mmap_read_unlock(mm);
-				mmap_locked = false;
-				*result = collapse_scan_file(mm,
-					khugepaged_scan.address, file, pgoff, cc);
-				fput(file);
-				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
-					mmap_read_lock(mm);
-					if (collapse_test_exit_or_disable(mm))
-						goto breakouterloop;
-					*result = try_collapse_pte_mapped_thp(mm,
-						khugepaged_scan.address, false);
-					if (*result == SCAN_PMD_MAPPED)
-						*result = SCAN_SUCCEED;
-					mmap_read_unlock(mm);
-				}
-			} else {
-				*result = collapse_scan_pmd(mm, vma,
-					khugepaged_scan.address, &mmap_locked, cc);
-			}
-
-			if (*result == SCAN_SUCCEED)
-				++khugepaged_pages_collapsed;
 
+			*result = collapse_single_pmd(khugepaged_scan.address,
+						      vma, &lock_dropped, cc);
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			if (!mmap_locked)
+			if (lock_dropped)
 				/*
 				 * We released mmap_lock so break loop.  Note
 				 * that we drop mmap_lock before all hugepage
@@ -2795,7 +2831,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	unsigned long hstart, hend, addr;
 	enum scan_result last_fail = SCAN_FAIL;
 	int thps = 0;
-	bool mmap_locked = true;
+	bool mmap_unlocked = false;
 
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
@@ -2817,13 +2853,12 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
-		bool triggered_wb = false;
 
-retry:
-		if (!mmap_locked) {
+		if (mmap_unlocked) {
 			cond_resched();
 			mmap_read_lock(mm);
-			mmap_locked = true;
+			mmap_unlocked = false;
+			*lock_dropped = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
 							 cc);
 			if (result  != SCAN_SUCCEED) {
@@ -2833,45 +2868,14 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
-		mmap_assert_locked(mm);
-		if (!vma_is_anonymous(vma)) {
-			struct file *file = get_file(vma->vm_file);
-			pgoff_t pgoff = linear_page_index(vma, addr);
 
-			mmap_read_unlock(mm);
-			mmap_locked = false;
-			*lock_dropped = true;
-			result = collapse_scan_file(mm, addr, file, pgoff, cc);
-
-			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
-			    mapping_can_writeback(file->f_mapping)) {
-				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
-				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
+		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
 
-				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
-				triggered_wb = true;
-				fput(file);
-				goto retry;
-			}
-			fput(file);
-		} else {
-			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
-		}
-		if (!mmap_locked)
-			*lock_dropped = true;
-
-handle_result:
 		switch (result) {
 		case SCAN_SUCCEED:
 		case SCAN_PMD_MAPPED:
 			++thps;
 			break;
-		case SCAN_PTE_MAPPED_HUGEPAGE:
-			BUG_ON(mmap_locked);
-			mmap_read_lock(mm);
-			result = try_collapse_pte_mapped_thp(mm, addr, true);
-			mmap_read_unlock(mm);
-			goto handle_result;
 		/* Whitelisted set of results where continuing OK */
 		case SCAN_NO_PTE_TABLE:
 		case SCAN_PTE_NON_PRESENT:
@@ -2894,8 +2898,10 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 
 out_maybelock:
 	/* Caller expects us to hold mmap_lock on return */
-	if (!mmap_locked)
+	if (mmap_unlocked) {
+		*lock_dropped = false;
 		mmap_read_lock(mm);
+	}
 out_nolock:
 	mmap_assert_locked(mm);
 	mmdrop(mm);
-- 
2.43.0


-- 
Cheers,

David

