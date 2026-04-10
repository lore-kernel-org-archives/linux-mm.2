Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DCE9F4485A
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 13:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C25006B00B2; Fri, 10 Apr 2026 09:40:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD42E6B00B4; Fri, 10 Apr 2026 09:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B11A86B00B6; Fri, 10 Apr 2026 09:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A1D756B00B2
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:40:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 435AB1A058F
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:40:27 +0000 (UTC)
X-FDA: 84642755694.25.BE01FAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 693D1A0018
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:40:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UHSTE6IM;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775828425; a=rsa-sha256;
	cv=none;
	b=4D1UY51qxKwnUw27Li13Hp2iN+qA+1mOjklPo5GxQHUjuR+g0OsOVnxkCQKWLvdMxHIkkA
	tGy37bvHb59uWKQXIlZ4yffZaMpeSsn+D25+76unfRshZarSzrxiVeW9CBAsVBayxa+thj
	eNeN0PCfIxzx33s7gP4VmP8c/FVk4pA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775828425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MuYd7Z8THuy690SL3pmRgp4/G50oaqRuO3RfkIq5o9Q=;
	b=QW4Ue6W4XjXnPl+1C8YWio3XbddrSH+Dkq9NlLG4t/Cjnpvj/mD9f6eCVQtSoW0mtTD28n
	IXlHqa5e7+oeWIjEGIFMl8T8ECNbgcy3mEfEBWNZLgpCSwWOyvMGgxF0iCxUveDFbWkYhX
	dlpbdD7Pa03H0IZuF3Tp/NH0FDBApDc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UHSTE6IM;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BE6C40020;
	Fri, 10 Apr 2026 13:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AB4C19421;
	Fri, 10 Apr 2026 13:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775828424;
	bh=Jmq4huoKFN3asEcsgm2oAg98uUDJCLdndkFfOq1NdGM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UHSTE6IMVQDomDbCGIFhYASkfTGfr6oz0VYFpZEq3J1oQsGPQ537Iv+Sl8WUzLKsC
	 rkvyLW6o45EQPOXK8FeQZgcGTedLsnwXEhBIht0mPGhQMsLWePBoMcR+wPPEb9d073
	 uD2LYNWGvCaKObN1+A3zma6BHBSvpWcePvmyraAu1PqQbZDoVpQHAynmy0yU4SlzHP
	 Jj5wBfR7j3UbhO4lrD+IiuPDHa+rvfMUeiuiwtTwcD7KVn+lFaXG8bJkdWLW8OfJiD
	 i21JoqNUv4HgRNMTYTrYQZdNraep8pIHCx4EU1WOLENsfGUCE+B44BuDSuJ6jrBKOa
	 SHdBrJXo951qg==
Date: Fri, 10 Apr 2026 14:40:19 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: jiang.kun2@zte.com.cn
Cc: akpm@linux-foundation.org, liam.howlett@oracle.com, david@kernel.org, 
	vbabka@kernel.org, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, xu.xin16@zte.com.cn, wang.yaxin@zte.com.cn, 
	lu.zhongjun@zte.com.cn
Subject: Re: [PATCH v2] mm/madvise: prefer VMA lock for MADV_REMOVE
Message-ID: <adj1h3JlrUWLzPnm@lucifer>
References: <20260410160249749i98jwNgNLmLMKRNVeoKVe@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410160249749i98jwNgNLmLMKRNVeoKVe@zte.com.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 693D1A0018
X-Stat-Signature: t3a6osatsjc849hxjon5mo8cqb18zaq3
X-HE-Tag: 1775828425-450794
X-HE-Meta: U2FsdGVkX1/rDlwTuqiUt62uEsEl0WQC4k3unzU42GIrqCaL4r0J9hYWbjOX1W5UDSHp8YHfW95WEOOBdF65PPUEYOYLhkqeLBPaYte346CYfGNM4ccvHojos9jE58FNA7Uxr/VPD+ASfUTLpn/cn5FLf+mHdPnfPFSG6KtBPL3wscsqDZfHYulR5EOR1m+Da+TSbO720NSzkM/x/CrexoVf503XRFYw4udYvcgHlR9T3KKQJtlRAepScEt8TZkiq7OoP5gdrM//KJ6vH6u8twQdP6+ShxoQrh6FQxRBXKWBDbeIHAd5Shi51CCcPoQhsaUT8xkZ2QiIaRCtug+q5spaJVotRB2lRmnI91Yhideup0dKeZ+IAWvxPd8DHwf08PKyGcM4vZ9sVGn6oRs7mZR6+7JS27pg84lfmApdYVeurJzYtTZptlbtMXlMS0BhOPnI6KZaLtgyhlyST2SPr5YQzDvsUXN5AR02F6egmDMt6MDYhXeD4ZNvyv4wy4hv4e2JyuRciLxIStrEspXhdszd3hHqnfadnlHRRSPRQmSo2/sBgL3qw0Zw2LlY0/0FHvyOZKPi+xh3CywtAgeG39lRqoAxJsasCXvkmvJixBlEEdM7CbDLfyoH6j8GtF4YPz6rRsxUXKdOA6/cBJl3nwJOv/BOrwl8X7Ixhg6HmLofc5PK8C8Z5hhIWxQ2q0nbPvvZWBjnAl8Zju5ylOMoWvqxI1sDpnJidwsaTN+iX61iEGN4s6/ThFYkkrVTpcR4ZeDkP5uDHKGjcqZLD/6wJ9GpSgCR2YcsftoJPhlMP5RQIfZAzJqcSB0pH8yKThOT0sfWmd+gaRbEjTUefc83IGBMI4diJELjU1I2HjpN7ZrRxF7rr3TwsvC64E3nd9DA6S4Jk/VFkaFqCIEEZDWZBRljhyh9Nymb98aIzQDSSBmdcB3rWvl9vhBuAJiCOpN6d0vZd6SBJni/rnoHOIw
 1vw9+3UZ
 VSCQmSZlE1IcwttVVKXnpzIJ8QRuy4pk6owJgEjq/M/3lJktTvQtnt2/arQnSnssqEetAVG9OuTNOy/prRI2ohhHgWFx5kjtfdwXQspPWpBFlDZvjhDOc4BYydnySjXbR1TbK7Gj/Rbp6wtamLyqTaR3afRMLSjudfRmLhJB+ofI8j/qObS/hm9G+SFq1DoCzIHm8ykHO5cQeYPOrVcQnTwNiJ4xWwqnkahkdlWW1LfO4OjnGm4tyvTWHdE0K4v87PmvFcM/xCzLhoiLcOC1bxpEnOO6cuTFYGrN4xnZloTrzEK340gjs+4R81GAkYu2sTHfDYIQG3a34+HTEyN+PF2wUo7ahRLy9jbO02xLd38FwCO8se+UG9LzJNo6Lupw9TIm8SmdONjnurdP3n96wE67zo1iZimtEptEBgaSjXNH7YBk7d9O56HdoGISwTBJybRzUTxkhNkNLGNYaNtA8NxPchrMEsvo3OC6IHV+JwgH7HjOzuKYuB8mp0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 04:02:49PM +0800, jiang.kun2@zte.com.cn wrote:
> From: Jiang Kun <jiang.kun2@zte.com.cn>
>
> MADV_REMOVE prefers the per-VMA read lock for single-VMA, local-mm,
> non-UFFD-armed ranges, avoiding mmap_lock contention for such ranges.

I'm not sure what 'MADV_REMOVE prefers' means here? You're making the change,
you should be making a case for it, ideally with performance numbers.

I'm really not sure we should just be enabling the VMA lock for things
arbitrarily unless there's a real need for it.

>
> However, calling into the filesystem while holding vm_lock (VMA lock) can

Not sure what vm_lock is? :)

> create lock ordering issues. syzbot reported a possible deadlock in
> blkdev_fallocate() when vfs_fallocate() is called under vm_lock.

It's not really worth mentioning an issue that came up in a v1 of this code in
the commit message. The commit message should describe what you're actually
doing, why, and any details that might be helpful to people looking at the
patch.

>
> Fix this by dropping the VMA lock before invoking vfs_fallocate(), after
> taking an extra reference to the file. Keep the existing mmap_lock fallback
> path and its userfaultfd coordination unchanged.

It's worth mentioning this, but not in terms of a bug that happened in v1

>
> Repeated benchmark runs show no regression in the uncontended case, and show
> benefit once mmap_lock contention is introduced.

Numbers please :) ideally with some statistics like standard deviation etc.

>
> Link: https://ci.syzbot.org/series/30acb9df-ca55-4cbf-81ed-89b84da8edc1
> Link: https://lore.kernel.org/all/aWcZCwz__qwwKbxw@casper.infradead.org/
> Signed-off-by: Jiang Kun <jiang.kun2@zte.com.cn>
> Signed-off-by: Yaxin Wang <wang.yaxin@zte.com.cn>

Some things to address, I have attached a patch that reworks what you have
here in a way that avoids duplication, so if you're good with that feel
free to send as v3, I don't need attribution other than a Suggested-by if
you like.

The logic in general seems correct, but we need numbers! And the commit
message to be improved as per the above also.

Thanks, Lorenzo

> ---
>  mm/madvise.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 69708e953cf5..0932579bccb4 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1008,8 +1008,6 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
>  	unsigned long start = madv_behavior->range.start;
>  	unsigned long end = madv_behavior->range.end;
>
> -	mark_mmap_lock_dropped(madv_behavior);
> -
>  	if (vma->vm_flags & VM_LOCKED)
>  		return -EINVAL;
>
> @@ -1025,6 +1023,20 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
>  	offset = (loff_t)(start - vma->vm_start)
>  			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
>
> +	/* Avoid calling into the filesystem while holding a VMA lock. */
> +	if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK) {
> +		get_file(f);
> +		vma_end_read(vma);
> +		madv_behavior->vma = NULL;
> +		error = vfs_fallocate(f,
> +				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> +				offset, end - start);
> +		fput(f);
> +		return error;
> +	}
> +
> +	mark_mmap_lock_dropped(madv_behavior);

I don't like this code duplication, you're literally copy/pasting code here.

Let's use what we already have.

We can avoid duplicating like this, make mark_mmap_lock_dropped() valid for VMA
locks too and rename it to mark_lock_dropped(), then change the logic around a
bit and have something a bit nicer I think.

See attached patch, you're welcome to use this as-is (you can add a Suggested-by
if you like), but that avoids the duplication and keeps things unified.

> +
>  	/*
>  	 * Filesystem's fallocate may need to take i_rwsem.  We need to
>  	 * explicitly grab a reference because the vma (and hence the
> @@ -1677,7 +1689,8 @@ int madvise_walk_vmas(struct madvise_behavior *madv_behavior)
>  	if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK &&
>  	    try_vma_read_lock(madv_behavior)) {
>  		error = madvise_vma_behavior(madv_behavior);
> -		vma_end_read(madv_behavior->vma);
> +		if (madv_behavior->vma)
> +			vma_end_read(madv_behavior->vma);
>  		return error;
>  	}
>
> @@ -1746,7 +1759,6 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
>  		return MADVISE_NO_LOCK;
>
>  	switch (madv_behavior->behavior) {
> -	case MADV_REMOVE:
>  	case MADV_WILLNEED:
>  	case MADV_COLD:
>  	case MADV_PAGEOUT:
> @@ -1754,6 +1766,7 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
>  	case MADV_POPULATE_WRITE:
>  	case MADV_COLLAPSE:
>  		return MADVISE_MMAP_READ_LOCK;
> +	case MADV_REMOVE:
>  	case MADV_GUARD_INSTALL:
>  	case MADV_GUARD_REMOVE:
>  	case MADV_DONTNEED:
> --
> 2.53.0

Suggested reworked version below:

----8<----
From 97f6ff9749a38256e919a24ff2867a077a6f8cfc Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Apr 2026 14:37:23 +0100
Subject: [PATCH] slightly reworked

---
 mm/madvise.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 69708e953cf5..4af0565809f2 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -269,9 +269,8 @@ static void shmem_swapin_range(struct vm_area_struct *vma,
 }
 #endif		/* CONFIG_SWAP */

-static void mark_mmap_lock_dropped(struct madvise_behavior *madv_behavior)
+static void mark_lock_dropped(struct madvise_behavior *madv_behavior)
 {
-	VM_WARN_ON_ONCE(madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK);
 	madv_behavior->lock_dropped = true;
 }

@@ -315,7 +314,7 @@ static long madvise_willneed(struct madvise_behavior *madv_behavior)
 	 * vma's reference to the file) can go away as soon as we drop
 	 * mmap_lock.
 	 */
-	mark_mmap_lock_dropped(madv_behavior);
+	mark_lock_dropped(madv_behavior);
 	get_file(file);
 	offset = (loff_t)(start - vma->vm_start)
 			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
@@ -909,7 +908,7 @@ static long madvise_dontneed_free(struct madvise_behavior *madv_behavior)
 	if (!userfaultfd_remove(madv_behavior->vma, range->start, range->end)) {
 		struct vm_area_struct *vma;

-		mark_mmap_lock_dropped(madv_behavior);
+		mark_lock_dropped(madv_behavior);
 		mmap_read_lock(mm);
 		madv_behavior->vma = vma = vma_lookup(mm, range->start);
 		if (!vma)
@@ -1005,10 +1004,9 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
 	struct file *f;
 	struct mm_struct *mm = madv_behavior->mm;
 	struct vm_area_struct *vma = madv_behavior->vma;
-	unsigned long start = madv_behavior->range.start;
-	unsigned long end = madv_behavior->range.end;
-
-	mark_mmap_lock_dropped(madv_behavior);
+	const unsigned long start = madv_behavior->range.start;
+	const unsigned long end = madv_behavior->range.end;
+	const bool vma_locked = madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK;

 	if (vma->vm_flags & VM_LOCKED)
 		return -EINVAL;
@@ -1029,18 +1027,20 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
 	 * Filesystem's fallocate may need to take i_rwsem.  We need to
 	 * explicitly grab a reference because the vma (and hence the
 	 * vma's reference to the file) can go away as soon as we drop
-	 * mmap_lock.
+	 * its lock.
 	 */
 	get_file(f);
-	if (userfaultfd_remove(vma, start, end)) {
-		/* mmap_lock was not released by userfaultfd_remove() */
+	mark_lock_dropped(madv_behavior);
+	if (vma_locked)
+		vma_end_read(vma);
+	else if (userfaultfd_remove(vma, start, end)) /* uffd didn't drop? */
 		mmap_read_unlock(mm);
-	}
 	error = vfs_fallocate(f,
 				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
 				offset, end - start);
 	fput(f);
-	mmap_read_lock(mm);
+	if (!vma_locked)
+		mmap_read_lock(mm);
 	return error;
 }

@@ -1677,7 +1677,8 @@ int madvise_walk_vmas(struct madvise_behavior *madv_behavior)
 	if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK &&
 	    try_vma_read_lock(madv_behavior)) {
 		error = madvise_vma_behavior(madv_behavior);
-		vma_end_read(madv_behavior->vma);
+		if (!madv_behavior->lock_dropped)
+			vma_end_read(madv_behavior->vma);
 		return error;
 	}

@@ -1746,7 +1747,6 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
 		return MADVISE_NO_LOCK;

 	switch (madv_behavior->behavior) {
-	case MADV_REMOVE:
 	case MADV_WILLNEED:
 	case MADV_COLD:
 	case MADV_PAGEOUT:
@@ -1754,6 +1754,7 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
 	case MADV_POPULATE_WRITE:
 	case MADV_COLLAPSE:
 		return MADVISE_MMAP_READ_LOCK;
+	case MADV_REMOVE:
 	case MADV_GUARD_INSTALL:
 	case MADV_GUARD_REMOVE:
 	case MADV_DONTNEED:
--
2.53.0

