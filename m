Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC35CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 445D76B0092; Wed, 24 Jun 2026 09:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D256B0093; Wed, 24 Jun 2026 09:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35D116B0095; Wed, 24 Jun 2026 09:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0F56B0092
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:56:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D2D2C1A73
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:56:33 +0000 (UTC)
X-FDA: 84914956266.09.58D4B34
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id AE7D840010
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:56:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pVcKV8sE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782309391;
	b=eHzjAtdF9PwthbkrvcSW0PgNoI3ppPBpNhl5iamiB/fXtQfqKy3pUz1+zzma1CLvFZVOR+
	N/FxQRJz7dzSe69rcdWjJ1kDvxNJ2BQvWwWo/ei71/3bXWbHkOFB7krc+sbvJRm3JlKSJG
	/DkKsbC1fHXVhgZSAlVawA7qNC4iTWA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782309391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhOQ1fCCKYR0seWDVSohdEYn3Ru81Hspd+3PeUi0x6Q=;
	b=rnggTduwZktQML4DBBoy7CujGUHQchuGkXbFITmMGxLicHTAs8zDe6EBfJo78gL7zcVgx2
	8v54qOT+0PbBEPiXEl/szPPcpXrLrVjfk+asN7b/yO0PRONMTz0tUw5OQwQ/rRi2bvCpqM
	pwsziSD54adBoRyk3LXejU1g21jHpgE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pVcKV8sE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782309386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FhOQ1fCCKYR0seWDVSohdEYn3Ru81Hspd+3PeUi0x6Q=;
	b=pVcKV8sEVkHL2uhIGf6kM1ZJ9NIoML98FTDczN8Xx1UIWwDoa1sBVW9gT3VW91qlGGw6Eq
	dEJgSV98/pVczBfGm3odsbvyq4msPugCC4TVvmyGweJTNrmUPhzl53NitGJSTMm8x9SjEX
	qSyYqc7s67JhHCeVJ/oAqAWCxafD5PQ=
From: Usama Arif <usama.arif@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [RFC PATCH] shmem: Use invalidate_lock instead of shmem_falloc
Date: Wed, 24 Jun 2026 06:56:20 -0700
Message-ID: <20260624135621.2526146-1-usama.arif@linux.dev>
In-Reply-To: <20260622204250.1170280-1-willy@infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE7D840010
X-Rspam-User: 
X-Stat-Signature: chgsx1ucixdu5hbqq7wgnmuma5omzn3x
X-HE-Tag: 1782309391-506679
X-HE-Meta: U2FsdGVkX18zNZAeO/g/CKY7iX+Gl0VzZ2wMlsmz2zeVjna9iHTnP4/46muKmyEThlpt5YtHTwFiyPxAsiAWPVeFeyWQ0Ez7mJf6yu75L9VHyv6F0hN2K19cmRUDyrRx8HGgaN+m/xspvxI4x9STEv4QcBZddKQodh10AVKJxI+z5aIqlxnB3bCRBa9e/BcgpluOQJrnYN3diXPGza0h+3gQ+d9T6c+jAdRtWlNbAw4poSBfumWV3tL0hAHN2phcnydkUi3Edwjj7FGvVQ/BRgwwyE4FuXOt4AVuEYewbTTVzy8x6i8y0mClypvtXrmXtJy/Oo2QMP6iGR8+perCGqyPkqQ+Z/mT75My8UurOTZ9RiXcAhq5Dl8LWjI5kKpV6H//9KjTcpUTM6xWnRisAQcMp0CsPr2lzXzAIQ6OVd80RqezxdyrSzbuR2y837NUzJJ1/h6ha3/lE+rPQXuPgP6rLHhmhvNtO8iA77uEmHgTrNCyAcs2hGNlDuVR0n6Z/TN+PrBEN2p1GvHwQbwH1iiyTFVv7XpCcwIBFPPQBUxEFWf82qMjho36F7DLwQ8ErmeSpVdTbu/Nhwp5uOvLT1mOwuyaN0TT02MreUu3g/ReBOJaCq4zLzxMHn3ZQFQsWaxP0yoOYyzYbcOh3Us8J0y8pcukqnKip/eQhPfePn8pFWka1lk4tcqgrF2Ql+yxEmt0qHPVFtZI3r95rxxb5qSrqxcDFmB2xomg6hcIeBVprDurqI4FyTNtofvDhN41U8iiu+M5xKeKumL4rl51NEyTihj5XCNiZjn/OOfYPkRwANKLWyI4e2DXENHf8xP9zoYuU2G4HTmU28/juRf11jWVov87OInxMxJ7W7fwaSU20brTO2Rjm4kg1sHLog6GrOLhEPetwd0BoOJc366YHbXSGYLm5YA8RzbKKmsC/kjiT1Xl/Roulp0e6jINnClfKCXIzxAxTPh4fvKZySW
 ME8ptEqg
 r8RFbTMM/QOhyaIbgqSIW5lD50i79BeOBV02a0i43/XoI1Au6F0a0QI+MIpJxl2T43K+GSdp584EzsrPtdQ8+7txjc0ofe3djSkbpPuwUfkOUzbTJr0BbN/6RZ2FEe3Jzgf0WXT4sWbR5CLprIEa1kHOh/F7p2Mx7bD9N4/+5twWoNWXSv09lIQ9nXBuocDzRjWl4mMMHdLUKeK7phTr9H9Ttqz1WrYHcAgLghmMh7wrQb7DuEE1UB+rW/07yzbUF6KZJi7/0DP+uPCCQrLwavXktFN8DDDOtehHxSw7Iynn5z5aYlI1K4boY8ENN9wngIARXLsoENdZTuwoUT7HaldaTMtoAkaFypY7Q5tdal7ysktb2rIs/3zmUYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Jun 2026 21:42:47 +0100 "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:

> Block based filesystems also need to exclude fallocate against page
> faults (and other activities).  Since commit 730633f0b7f9, we've had
> a centralised invalidate_lock for this purpose.  Convert shmem to use
> this rwsem instead of its custom shmem_falloc exclusion mechanism.
> 
> I may well have missed some subtleties here; I do not understand the
> shmem_falloc mechanism in its entirety.  It's certainly a more
> coarse-grained solution than shmem_falloc, but maybe it is enough.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/shmem.c | 167 +++++------------------------------------------------
>  1 file changed, 14 insertions(+), 153 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b51f83c970bb..5d0942cbb717 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -97,19 +97,6 @@ static struct vfsmount *shm_mnt __ro_after_init;
>  /* Symlink up to this size is kmalloc'ed instead of using a swappable page */
>  #define SHORT_SYMLINK_LEN 128
>  
> -/*
> - * shmem_fallocate communicates with shmem_fault or shmem_writeout via
> - * inode->i_private (with i_rwsem making sure that it has only one user at
> - * a time): we would prefer not to enlarge the shmem inode just for that.
> - */
> -struct shmem_falloc {
> -	wait_queue_head_t *waitq; /* faults into hole wait for punch to end */
> -	pgoff_t start;		/* start of range currently being fallocated */
> -	pgoff_t next;		/* the next page offset to be fallocated */
> -	pgoff_t nr_falloced;	/* how many new pages have been fallocated */
> -	pgoff_t nr_unswapped;	/* how often writeout refused to swap out */
> -};
> -
>  struct shmem_options {
>  	unsigned long long blocks;
>  	unsigned long long inodes;
> @@ -1650,31 +1637,15 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>  	 * value into swapfile.c, the only way we can correctly account for a
>  	 * fallocated folio arriving here is now to initialize it and write it.
>  	 *
> -	 * That's okay for a folio already fallocated earlier, but if we have
> -	 * not yet completed the fallocation, then (a) we want to keep track
> -	 * of this folio in case we have to undo it, and (b) it may not be a
> -	 * good idea to continue anyway, once we're pushing into swap.  So
> -	 * reactivate the folio, and let shmem_fallocate() quit when too many.
> +	 * We have to prevent racing with fallocate, so just block until it's
> +	 * done.
>  	 */
>  	if (!folio_test_uptodate(folio)) {
> -		if (inode->i_private) {
> -			struct shmem_falloc *shmem_falloc;
> -			spin_lock(&inode->i_lock);
> -			shmem_falloc = inode->i_private;
> -			if (shmem_falloc &&
> -			    !shmem_falloc->waitq &&
> -			    index >= shmem_falloc->start &&
> -			    index < shmem_falloc->next)
> -				shmem_falloc->nr_unswapped += nr_pages;
> -			else
> -				shmem_falloc = NULL;
> -			spin_unlock(&inode->i_lock);
> -			if (shmem_falloc)
> -				goto redirty;
> -		}
> +		filemap_invalidate_lock_shared(mapping);
>  		folio_zero_range(folio, 0, folio_size(folio));
>  		flush_dcache_folio(folio);
>  		folio_mark_uptodate(folio);
> +		filemap_invalidate_unlock_shared(mapping);
>  	}
>  
>  	if (!folio_alloc_swap(folio)) {
> @@ -2610,98 +2581,23 @@ int shmem_get_folio(struct inode *inode, pgoff_t index, loff_t write_end,
>  }
>  EXPORT_SYMBOL_GPL(shmem_get_folio);
>  
> -/*
> - * This is like autoremove_wake_function, but it removes the wait queue
> - * entry unconditionally - even if something else had already woken the
> - * target.
> - */
> -static int synchronous_wake_function(wait_queue_entry_t *wait,
> -			unsigned int mode, int sync, void *key)
> -{
> -	int ret = default_wake_function(wait, mode, sync, key);
> -	list_del_init(&wait->entry);
> -	return ret;
> -}
> -
> -/*
> - * Trinity finds that probing a hole which tmpfs is punching can
> - * prevent the hole-punch from ever completing: which in turn
> - * locks writers out with its hold on i_rwsem.  So refrain from
> - * faulting pages into the hole while it's being punched.  Although
> - * shmem_undo_range() does remove the additions, it may be unable to
> - * keep up, as each new page needs its own unmap_mapping_range() call,
> - * and the i_mmap tree grows ever slower to scan if new vmas are added.
> - *
> - * It does not matter if we sometimes reach this check just before the
> - * hole-punch begins, so that one fault then races with the punch:
> - * we just need to make racing faults a rare case.
> - *
> - * The implementation below would be much simpler if we just used a
> - * standard mutex or completion: but we cannot take i_rwsem in fault,
> - * and bloating every shmem inode for this unlikely case would be sad.
> - */
> -static vm_fault_t shmem_falloc_wait(struct vm_fault *vmf, struct inode *inode)
> -{
> -	struct shmem_falloc *shmem_falloc;
> -	struct file *fpin = NULL;
> -	vm_fault_t ret = 0;
> -
> -	spin_lock(&inode->i_lock);
> -	shmem_falloc = inode->i_private;
> -	if (shmem_falloc &&
> -	    shmem_falloc->waitq &&
> -	    vmf->pgoff >= shmem_falloc->start &&
> -	    vmf->pgoff < shmem_falloc->next) {
> -		wait_queue_head_t *shmem_falloc_waitq;
> -		DEFINE_WAIT_FUNC(shmem_fault_wait, synchronous_wake_function);
> -
> -		ret = VM_FAULT_NOPAGE;
> -		fpin = maybe_unlock_mmap_for_io(vmf, NULL);
> -		shmem_falloc_waitq = shmem_falloc->waitq;
> -		prepare_to_wait(shmem_falloc_waitq, &shmem_fault_wait,
> -				TASK_UNINTERRUPTIBLE);
> -		spin_unlock(&inode->i_lock);
> -		schedule();
> -
> -		/*
> -		 * shmem_falloc_waitq points into the shmem_fallocate()
> -		 * stack of the hole-punching task: shmem_falloc_waitq
> -		 * is usually invalid by the time we reach here, but
> -		 * finish_wait() does not dereference it in that case;
> -		 * though i_lock needed lest racing with wake_up_all().
> -		 */
> -		spin_lock(&inode->i_lock);
> -		finish_wait(shmem_falloc_waitq, &shmem_fault_wait);
> -	}
> -	spin_unlock(&inode->i_lock);
> -	if (fpin) {
> -		fput(fpin);
> -		ret = VM_FAULT_RETRY;
> -	}
> -	return ret;
> -}
> -
>  static vm_fault_t shmem_fault(struct vm_fault *vmf)
>  {
> -	struct inode *inode = file_inode(vmf->vma->vm_file);
> -	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
> +	struct file *file = vmf->vma->vm_file;
> +	struct address_space *mapping = file->f_mapping;
> +	struct inode *inode = file_inode(file);
> +	gfp_t gfp = mapping_gfp_mask(mapping);
>  	struct folio *folio = NULL;
>  	vm_fault_t ret = 0;
>  	int err;
>  
> -	/*
> -	 * Trinity finds that probing a hole which tmpfs is punching can
> -	 * prevent the hole-punch from ever completing: noted in i_private.
> -	 */
> -	if (unlikely(inode->i_private)) {
> -		ret = shmem_falloc_wait(vmf, inode);
> -		if (ret)
> -			return ret;
> -	}
> +	/* Exclude fallocate */
> +	filemap_invalidate_lock_shared(mapping);
>  
>  	WARN_ON_ONCE(vmf->page != NULL);
>  	err = shmem_get_folio_gfp(inode, vmf->pgoff, 0, &folio, SGP_CACHE,
>  				  gfp, vmf, &ret);
> +	filemap_invalidate_unlock_shared(mapping);
>  	if (err)
>  		return vmf_error(err);
>  	if (folio) {
> @@ -3600,7 +3496,6 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>  	struct inode *inode = file_inode(file);
>  	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
>  	struct shmem_inode_info *info = SHMEM_I(inode);
> -	struct shmem_falloc shmem_falloc;
>  	pgoff_t start, index, end, undo_fallocend;
>  	int error;
>  
> @@ -3608,6 +3503,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>  		return -EOPNOTSUPP;
>  
>  	inode_lock(inode);
> +	filemap_invalidate_lock(inode->i_mapping);
>  

I think there is a deadlock here as write lock will be held across the
shmem_get_folio allocation below. Those allocations can enter direct
reclaim. If reclaim reaches shmem_writeout() for a not-uptodate shmem folio,
the patch's new filemap_invalidate_lock_shared(mapping) waits for this write
lock, which is held by the same fallocate task.


>  	if (info->flags & SHMEM_F_MAPPING_FROZEN) {
>  		error = -EPERM;
> @@ -3618,7 +3514,6 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>  		struct address_space *mapping = file->f_mapping;
>  		loff_t unmap_start = round_up(offset, PAGE_SIZE);
>  		loff_t unmap_end = round_down(offset + len, PAGE_SIZE) - 1;
> -		DECLARE_WAIT_QUEUE_HEAD_ONSTACK(shmem_falloc_waitq);
>  
>  		/* protected by i_rwsem */
>  		if (info->seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
> @@ -3626,24 +3521,12 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>  			goto out;
>  		}
>  
> -		shmem_falloc.waitq = &shmem_falloc_waitq;
> -		shmem_falloc.start = (u64)unmap_start >> PAGE_SHIFT;
> -		shmem_falloc.next = (unmap_end + 1) >> PAGE_SHIFT;
> -		spin_lock(&inode->i_lock);
> -		inode->i_private = &shmem_falloc;
> -		spin_unlock(&inode->i_lock);
> -
>  		if ((u64)unmap_end > (u64)unmap_start)
>  			unmap_mapping_range(mapping, unmap_start,
>  					    1 + unmap_end - unmap_start, 0);
>  		shmem_truncate_range(inode, offset, offset + len - 1);
>  		/* No need to unmap again: hole-punching leaves COWed pages */
>  
> -		spin_lock(&inode->i_lock);
> -		inode->i_private = NULL;
> -		wake_up_all(&shmem_falloc_waitq);
> -		WARN_ON_ONCE(!list_empty(&shmem_falloc_waitq.head));
> -		spin_unlock(&inode->i_lock);
>  		error = 0;
>  		goto out;
>  	}
> @@ -3666,15 +3549,6 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>  		goto out;
>  	}
>  
> -	shmem_falloc.waitq = NULL;
> -	shmem_falloc.start = start;
> -	shmem_falloc.next  = start;
> -	shmem_falloc.nr_falloced = 0;
> -	shmem_falloc.nr_unswapped = 0;
> -	spin_lock(&inode->i_lock);
> -	inode->i_private = &shmem_falloc;
> -	spin_unlock(&inode->i_lock);
> -
>  	/*
>  	 * info->fallocend is only relevant when huge pages might be
>  	 * involved: to prevent split_huge_page() freeing fallocated
> @@ -3696,8 +3570,6 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>  		 */
>  		if (fatal_signal_pending(current))
>  			error = -EINTR;
> -		else if (shmem_falloc.nr_unswapped > shmem_falloc.nr_falloced)
> -			error = -ENOMEM;
>  		else
>  			error = shmem_get_folio(inode, index, offset + len,
>  						&folio, SGP_FALLOC);
> @@ -3709,7 +3581,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>  				    (loff_t)start << PAGE_SHIFT,
>  				    ((loff_t)index << PAGE_SHIFT) - 1, true);
>  			}
> -			goto undone;
> +			goto out;
>  		}
>  
>  		/*
> @@ -3722,14 +3594,6 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>  		if (!index)
>  			index--;
>  
> -		/*
> -		 * Inform shmem_writeout() how far we have reached.
> -		 * No need for lock or barrier: we have the page lock.
> -		 */
> -		if (!folio_test_uptodate(folio))
> -			shmem_falloc.nr_falloced += index - shmem_falloc.next;
> -		shmem_falloc.next = index;
> -
>  		/*
>  		 * If !uptodate, leave it that way so that freeable folios
>  		 * can be recognized if we need to rollback on error later.
> @@ -3745,11 +3609,8 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>  
>  	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size)
>  		i_size_write(inode, offset + len);
> -undone:
> -	spin_lock(&inode->i_lock);
> -	inode->i_private = NULL;
> -	spin_unlock(&inode->i_lock);
>  out:
> +	filemap_invalidate_unlock(inode->i_mapping);
>  	if (!error)
>  		file_modified(file);
>  	inode_unlock(inode);
> -- 
> 2.47.3
> 
> 

