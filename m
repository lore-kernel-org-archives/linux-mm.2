Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55EE310F9303
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 21:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C15E6B0092; Tue, 31 Mar 2026 17:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771986B0095; Tue, 31 Mar 2026 17:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 639236B0096; Tue, 31 Mar 2026 17:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C05B6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:35:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E01058B82D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:35:43 +0000 (UTC)
X-FDA: 84607665366.17.2BEA806
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3276E16000B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:35:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sJaBUwGi;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774992942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cFCy8hZmLmmaLitye/ZKvqD4twJE5DUoU25LS5GRwM=;
	b=h491IrAo+oMC3zh4dWZsVrz3fWUuQ6Cqe7DD/V+LsbOvcG2hWdsV2fLz91k1s5mqxI3BzM
	WaqYzLb/s5Ry9MpM6X4o+yr+FlH1SXlVZ5wP7MyLIsHs0l6B1ews0wri5ET698lkBgY9PE
	U+HZvruJqw20vytYJQw4mTIVfhC4MsQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sJaBUwGi;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774992942; a=rsa-sha256;
	cv=none;
	b=wriDd06d/abvuaTmWrLJx3Va1QZGIxtn8RKpPmTX+XVh0sScEEghQN0Arpnu9V20Ij6aUU
	5QmE9jvz4ygVUtrxu/tnFlkG21K23a4izW04tvu6fUKeXPpCPPnNdiu3MYbZa7cHr2qhr/
	Lvzxh9Uzxjdqxj3qbUe7xPJb5JQsCS0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 580E4600CB;
	Tue, 31 Mar 2026 21:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7C2C19423;
	Tue, 31 Mar 2026 21:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774992941;
	bh=ItF2C7vWxavYeti16KEiOx27zwXUGG1kSH+fSMaNpzQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sJaBUwGikN9Norhx8A5uvQMDFYl0Mwp8HvEEwLjLgR0wuVFvcc7ERqkxy5ZlLYsDg
	 0LCAEdD0oTQbmCPM/6MJpOZ1EnAVOzkvmzSr34CThvn+U01XlYliRQ//lSoiqgZDlT
	 Zofky4ajLoqO68zDBfo8dclRZkoicrnAxBT6bOdE=
Date: Tue, 31 Mar 2026 14:35:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Nico Pache
 <npache@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, jack@suse.cz,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v4 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
Message-Id: <20260331143538.f41a5fef4201a7384388f31c@linux-foundation.org>
In-Reply-To: <26fcec86-ee78-4f5c-8ca5-0e6230699cfd@kernel.org>
References: <20260325114022.444081-1-npache@redhat.com>
	<20260325114022.444081-6-npache@redhat.com>
	<7760c811-e100-4d40-9217-0813c28314be@lucifer.local>
	<0223d45b-e8b4-49a7-882b-477250d0c14d@kernel.org>
	<fef63b28-a364-4e7c-bdbd-6d0403632920@lucifer.local>
	<26fcec86-ee78-4f5c-8ca5-0e6230699cfd@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3276E16000B
X-Stat-Signature: q1e3e69jfkwgiysm4mbroxdxmsnatgy1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774992942-966645
X-HE-Meta: U2FsdGVkX182ODPNvydihfJR2GJSYn3ibTNkaTTtbwmzOCB3jtyilM9AYgncahx7Hh2BPRpawhx+BloQPdB/MpUXvIp3eOxZdOOlHH7YZANbIaQRarWjcjRXwp3gI+4vD361hI3KGQIQrydxYMsvjbumNqkahkB4yWPr2t/eqBA3W5Pq5Ha3mw5jTrdXztA5gKxryM22NEkbYK1b5FJTIXJq1wxiIM2YsKa1kjaPsSl2HEyqNDgwMZXvKS9b3CIQ33lY0/nxSNb9XC0zPyEPf0Q4rmOs3M+wbMkvMM1TYAyYEub2U67H/6FHusvceHZXDWd34JKgQ5uhJ/PRdvXZ1i1ilNWNhkle0XWFrEM7AM4yZ3LTw6hAvcvSNsUcxheB45PDrzfcrYvOqa93Oum5scEHeGwvWpaU+8vs3HBqswZ33XJpyhJtnfkdQmgB0QPWX3fs7Posv7MV/nWj78V2k7rPRi5EjY9RRxt8ZpWXh++u40a33mr9PaqPyzq8DeBFh8RLwtZDsE523M7xiaEQ3QyGaS9GOJbuaWUSUEVt4QMz3tMrdhpE6VP+z1JGYZ/aq3B+NmVkjQBeykyfO/RXuciPvGhW0i3OwCRiUykkFrB4ocaU+taAExDtqcF6ATl6rGgdOkhp3c+oAgR1EBwZD0PodRdJuinAYvnBZYHjxO/K6ELSEcztPtxzDdiSI5Lkro14kj+a5QCnaCLD3J7C0HVt+CtIOKG4ySVgMbHXv6xdn7v1tK4JGLFyhTnrArQi5Ks5skxE2I1T0Ps+nYzw/xmcdR5vuAqAO5mO/yUotTKvGvUY5bpydrxSEhpRRldzC9k0wLzhA58yrjvkZd2wGp2w3Q9TQM8EzcBAn9He47XpnEMNDxZrhq0IpcS3FeQWbehIneni/o12G9SpZCkvRSpkdvTZmDomR2WvYYIF+IkHwBFO5STKVZn++tJeF7+451C0dphmCegrjXHbbGm
 BhhUh8hF
 vQe+8ZRqA9ox/DcFke7BY2/MlS0Lmp9rcrL4DKh+/r9u1Rs6XTOlYIVgkcL2a8NTotAXPFJuooery1/82SWAV9W78NE8s/AU4IPQ+tkM4Gl1fn7qdpQdkML0Bi1SEwZbFe4dLeBGWhrH3F6CEdeArOUkFtHZhtZFHqvKyfmiKPNQWzcd1cr58NQQY1NAAVyf5zhTDK4UpDVD4l3ZgD1SaRXrz3YDBJyT2RrqV2yjrSoYKhuR9h22ySnhAH57uKTYroo2dHe9bzO4zuGFOWx9sf0qLcABB0h8IPtYqz+rl/jC6iOZy30d82dM/07wR+RHItg5jtTMCsriDlBq+j/evQQFa2MmZGoicHCoB0tfsxg+F9cN+WeToUheKLfhYM2J6stNnETSDlBLDhx7Xoa8h5fo9sii+t03WcR40ZLea0+o/JUiJK+vsBPrbMuzYDZ8Lj+o+NyPA0b0d/DUdWk/EcjrPqnFDh+7YRdYeCQgJLIzNpsWUrfj64haRCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 22:00:58 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> > out_maybelock:
> > 	/* Caller expects us to hold mmap_lock on return */
> > 	if (mmap_unlocked) {
> > 		*lock_dropped = true;
> > 		mmap_read_lock(mm);
> > 	}
> > 
> 
> Right.
> 
> The original code used
> 
> 	bool mmap_locked = true;
> 
> If the fix get squashed, maybe we should revert to that handling to
> minimize the churn?
> 
> (this is not in stable, right?)

"mm/khugepaged: unify khugepaged and madv_collapse with
collapse_single_pmd(): is presently in mm-stable.

Doing a big rebase&rework isn't the done thing, I believe.  So queue it
afterwards, add the Fixes: and tolerate the minor runtime bisection
hole.  It ends up looking like a later hotfix.


Below is what I added to mm-unstable.  I added a note-to-self to check
in on Nico's question at
https://lore.kernel.org/all/CAA1CXcCYLGQBy9nT-MSTPVK=XgWWtD6Af-QiA_6pXtM_2pybPg@mail.gmail.com/T/#u


From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/khugepaged: fix issue with tracking lock
Date: Tue, 31 Mar 2026 13:11:18 +0100

We are incorrectly treating lock_dropped to track both whether the lock is
currently held and whether or not the lock was ever dropped.

Update this change to account for this.

Link: https://lkml.kernel.org/r/7760c811-e100-4d40-9217-0813c28314be@lucifer.local
Fixes: 330f3758a3bc ("mm/khugepaged: unify khugepaged and madv_collapse with collapse_single_pmd()")
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Nico Pache <npache@redhat.com>
...
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-issue-with-tracking-lock
+++ a/mm/khugepaged.c
@@ -2828,6 +2828,7 @@ int madvise_collapse(struct vm_area_stru
 	unsigned long hstart, hend, addr;
 	enum scan_result last_fail = SCAN_FAIL;
 	int thps = 0;
+	bool mmap_unlocked = false;
 
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
@@ -2850,10 +2851,11 @@ int madvise_collapse(struct vm_area_stru
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
 
-		if (*lock_dropped) {
+		if (mmap_unlocked) {
 			cond_resched();
 			mmap_read_lock(mm);
-			*lock_dropped = false;
+			mmap_unlocked = false;
+			*lock_dropped = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
 							 cc);
 			if (result  != SCAN_SUCCEED) {
@@ -2864,7 +2866,7 @@ int madvise_collapse(struct vm_area_stru
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
 
-		result = collapse_single_pmd(addr, vma, lock_dropped, cc);
+		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
 
 		switch (result) {
 		case SCAN_SUCCEED:
@@ -2893,8 +2895,10 @@ int madvise_collapse(struct vm_area_stru
 
 out_maybelock:
 	/* Caller expects us to hold mmap_lock on return */
-	if (*lock_dropped)
+	if (mmap_unlocked) {
+		*lock_dropped = true;
 		mmap_read_lock(mm);
+	}
 out_nolock:
 	mmap_assert_locked(mm);
 	mmdrop(mm);
_


