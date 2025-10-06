Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EBE2CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 13:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C85928E0013; Mon,  6 Oct 2025 09:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C36388E0002; Mon,  6 Oct 2025 09:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4BE78E0013; Mon,  6 Oct 2025 09:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A27DA8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 09:29:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C78259BD5
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:29:04 +0000 (UTC)
X-FDA: 83967770208.03.3C48E86
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 04EFA40020
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:29:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=e5FSunWt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=udmEe+sy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=e5FSunWt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=udmEe+sy;
	spf=pass (imf12.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759757342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmQkrksLlt0Dju/XPbVmLnx0iwCrgY81znO3vDFEw2o=;
	b=Xm3WSrDV9xEwNbBZOZF9855MRPEgU+Y+C51EPnGaE59Xyu7E3yP/udjmITTdZAS+M2Vn6U
	6mEq0cmh09+MxDGC6l2xuYvmrlSDAQ5+GuNmHqratCLjPviz35CrehJFf3jnUAS3N0aXAX
	YhlEGw/6JNDNEtE+ikbiD94u6nKWAvA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=e5FSunWt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=udmEe+sy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=e5FSunWt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=udmEe+sy;
	spf=pass (imf12.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759757342; a=rsa-sha256;
	cv=none;
	b=iJPxgWToeUp4Fxiv9W3jw1yavItlO0bOYUGYI3k8Sb++l4bp2sfAZuYihJ/S99x25zOEcF
	N+dXgSmCLZkY/PIuHvBlnDixWF/PAoutgj1aB8RuNA8/+r0FthuXJPwM0IgzUgxd8twRC2
	HtBH+wZbPsYvyqYjRhjqD9Ms0N8EBBg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6674B1F7C1;
	Mon,  6 Oct 2025 13:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759757340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nmQkrksLlt0Dju/XPbVmLnx0iwCrgY81znO3vDFEw2o=;
	b=e5FSunWtnLxCK0NWpRn7i1aC8/XK3geJ4CKHRjTJateym0/L7RDOqwKK5e+6t5kmTCYRsB
	EPRwzGfp5nBJfLOOJl8S/3BAgdEii0RQZtJlMcq3VapCT6B7fgBGIuSvndiTYmhsq8YfXS
	LFed7MyVYYL2Eja14snDPJu82aLF4ko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759757340;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nmQkrksLlt0Dju/XPbVmLnx0iwCrgY81znO3vDFEw2o=;
	b=udmEe+syEUzPxvOpywR7StoUmtqqjRk58CQIRWj0dyNq58xlrCTv3cqtV620Mq2FpLegpz
	2nF3jEdov6D6s3Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759757340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nmQkrksLlt0Dju/XPbVmLnx0iwCrgY81znO3vDFEw2o=;
	b=e5FSunWtnLxCK0NWpRn7i1aC8/XK3geJ4CKHRjTJateym0/L7RDOqwKK5e+6t5kmTCYRsB
	EPRwzGfp5nBJfLOOJl8S/3BAgdEii0RQZtJlMcq3VapCT6B7fgBGIuSvndiTYmhsq8YfXS
	LFed7MyVYYL2Eja14snDPJu82aLF4ko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759757340;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nmQkrksLlt0Dju/XPbVmLnx0iwCrgY81znO3vDFEw2o=;
	b=udmEe+syEUzPxvOpywR7StoUmtqqjRk58CQIRWj0dyNq58xlrCTv3cqtV620Mq2FpLegpz
	2nF3jEdov6D6s3Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9CC9A13700;
	Mon,  6 Oct 2025 13:28:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yN+GIxvE42hUCwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 06 Oct 2025 13:28:59 +0000
Date: Mon, 6 Oct 2025 15:28:58 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: muchun.song@linux.dev, david@redhat.com, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	broonie@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] hugetlbfs: skip PMD unsharing when shareable lock
 unavailable
Message-ID: <aOPEGkWdbeY2htsH@localhost.localdomain>
References: <20251003174553.3078839-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003174553.3078839-1-kartikey406@gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 04EFA40020
X-Stat-Signature: f9xmddkuoqc8iwsxiys9c7x7qzs48bsz
X-Rspam-User: 
X-HE-Tag: 1759757341-476061
X-HE-Meta: U2FsdGVkX1/kePD9ZAi8lkkz4cJJSdPxtsEW8Irk6YuyUMQNH8avsHQX43/efZYvm/hvnmT3jYZr/55K1tEEzqAWPaim4Y0Uwf//OjmFqj5FPVXRe3Bil8A1fdpv4QDu2GPgmGqULky8k5WcIiu9O2qxkh/dYnUV+RH77ZLKaSA4FOYoJFsG4WEFRv9B2SLjFvnn3PIOqbjwh2LLLl9NWTIhCJMu8Wbx2rrzLE8NNarVjyXzOJ+8dDJKog9lXHBGQ69dMtDMyYE1sr+ggpM42fjNlI/4y8FJvmZHoScv16mntTNXhHO0cvQTDZtGiwSBJQAUrg6aBtIvI2C4pC2Yi6QE+cwLP2y+JjmIoahP+ML4MDNCRTPiBvuIdKSV2bvmE8OICXyXf7rs0FDinLT39Pyjzs0FHfU/W4O0ZeiJh2g4dCsGlyfk4PwI+mssLkUE1OUDkFN5K8p7rof3EC28Mf0bRbfVoSFQRtMcQwfxTXQlCvp5YhEmND6GtnaPZE8Vl3ntXjUwWw9xamRMTD354Hen8eKPKWemupMr9ZAGKGnYSE1sQrc1OAuCOnWAVci5nnw+IzDw5LNo/Nes9C8cw+Qd83NzMxQwJVPrX0Gu9xy1jO50wXczIM+wBFENTG7yEinJWUiPobEXHbVO+OqPO7fF7CkGkvS9N3p9bnTQFCkjnYF+RNmHq6MA8r8hGpuQMi/rYClnKPgqsQ05ltkoA7wrnkBudIQQOIWNXtCNMMyqBytDaeS3Lm0rYjabyvxRJQv9SyivqPhrHuzK8YUsUxN8hgvAj7X5dE1M1RQhIf8l3FLO0YbJU9hXmjEKtdqdnylgeY+xEZGXnHWWXhJ265YzqMwzei+GwafjKMoseHEOKTRESA6074EelIf+KppOc9+DZpbSomjfU2TPXJg26aCcURcIo2JFl6x4xCcpoMv+wqzCCsS0MPzS6oEmLAC4xVBNKhf7APCEFlqWeqB
 k3m8Crjy
 /HgDDvsASfRhDTGQ8p0RsK0uUwdghVrvcTzWNAnth5QYKYaHlKaMSb4smu5qwhi1o1TMnPA/TtaQi4SeRxEngJLDai5SJxjwEhE5iD6+cAhMt64ZVgmro7zqPfDDJ0aye9HBNYvIHrOuvxRbC2pUh0j+bx4Ezgbfgj1/pk4WbkpBAxi3FfS5GYIwctw9deiFEfDvce3iTyqBUWOsON1k/GN2CMTbtDwlIyUKwJqWNzBS/HKoUis+T+Vlw4TyIeghPGOjwzEGR5npMGjDeOPdG6Uz1Kc2kksOTMkX77RDW4BM5kRRXl133vcaQpMG4RzO1uYxsp80XnlyLQSM+LKlC7LnYs+edeB2NOWtfnqijkDGdHSo8zNLSgjp44uT+uVyaENZ6CTBPy8HwY19ObPCqO29c/Hyf8Bb+D2BI4mZWoYG4A0WC4Jj9ypkeCMJKqO+Ahd0lTGcUbGzuYGJ9Udp01GKZ1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 11:15:53PM +0530, Deepanshu Kartikey wrote:
> When hugetlb_vmdelete_list() cannot acquire the shareable lock for a VMA,
> the previous fix (dd83609b8898) skipped the entire VMA to avoid lock
> assertions in huge_pmd_unshare(). However, this prevented pages from being
> unmapped and freed, causing a regression in fallocate(PUNCH_HOLE) operations
> where pages were not freed immediately, as reported by Mark Brown.
> 
> The issue occurs because:
> 1. hugetlb_vmdelete_list() calls hugetlb_vma_trylock_write()
> 2. For shareable VMAs, this attempts to acquire the shareable lock
> 3. If successful, huge_pmd_unshare() expects the lock to be held
> 4. huge_pmd_unshare() asserts the lock via hugetlb_vma_assert_locked()
> 
> The v2 fix avoided calling code that requires locks, but this prevented
> page unmapping entirely, breaking the expected behavior where pages are
> freed during punch hole operations.
> 
> This v3 fix takes a different approach: instead of skipping the entire VMA,
> we skip only the PMD unsharing operation when we don't have the required
> lock, while still proceeding with page unmapping. This is safe because:
> 
> - PMD unsharing is an optimization to reduce shared page table overhead
> - Page unmapping can proceed safely with just the VMA write lock
> - Pages get freed immediately as expected by PUNCH_HOLE operations
> - The PMD metadata will be cleaned up when the VMA is destroyed
> 
> We introduce a new ZAP_FLAG_NO_UNSHARE flag that communicates to
> __unmap_hugepage_range() that it should skip huge_pmd_unshare() while
> still clearing page table entries and freeing pages.
> 
> Reported-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
> Reported-by: Mark Brown <broonie@kernel.org>
> Fixes: dd83609b8898 ("hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list")
> Tested-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> 
> ---
...
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 9c94ed8c3ab0..519497bc1045 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -474,29 +474,31 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
>  	vma_interval_tree_foreach(vma, root, start, end ? end - 1 : ULONG_MAX) {
>  		unsigned long v_start;
>  		unsigned long v_end;
> +		bool have_shareable_lock;
> +		zap_flags_t local_flags = zap_flags;
>  
>  		if (!hugetlb_vma_trylock_write(vma))
>  			continue;
> -
> +
> +		have_shareable_lock = __vma_shareable_lock(vma);
> +
>  		/*
> -		 * Skip VMAs without shareable locks. Per the design in commit
> -		 * 40549ba8f8e0, these will be handled by remove_inode_hugepages()
> -		 * called after this function with proper locking.
> +		 * If we can't get the shareable lock, set ZAP_FLAG_NO_UNSHARE
> +		 * to skip PMD unsharing. We still proceed with unmapping to
> +		 * ensure pages are properly freed, which is critical for punch
> +		 * hole operations that expect immediate page freeing.
>  		 */
> -		if (!__vma_shareable_lock(vma))
> -			goto skip;
> -
> +		if (!have_shareable_lock)
> +			local_flags |= ZAP_FLAG_NO_UNSHARE;

This is quite a head-spinning thing.

First of all, as David pointed out, that comment is misleading as it looks like
__vma_shareable_lock() performs a taking action which is not true, so that should
reworded.

Now, the thing is:

- Prior to commit dd83609b8898("hugetlbfs: skip VMAs without shareable
  locks in hugetlb_vmdelete_list"), we were unconditionally calling
  huge_pmd_unshare(), which asserted the vma lock and we didn't hold it.
  My question would be that Mike's vma-lock addition happened in 2022,
  how's that we didn't see this sooner? It should be rather easy to
  trigger? I'm a bit puzzled.

- Ok, since there's nothing to unshare, we skip the vma here and
  remove_inode_hugepages() should take care of it.
  But that seems to be troublesome because on punch-hole operation pages
  don't get freed.

- So instead, we just skip the unsharing operation and keep carrying
  with the unmapping/freeing in __unmap_hugepage_range.

I don't know but to me it seems that we're going to large extends to fix
an assertion.
So, the thing is, can't we check __vma_shareable_lock in
__unmap_hugepage_range() and only call huge_pmd_unshare() if we need to?

 

-- 
Oscar Salvador
SUSE Labs

