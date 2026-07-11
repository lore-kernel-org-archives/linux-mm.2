Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0B1AC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 21:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D9DE6B008A; Sat, 11 Jul 2026 17:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889C26B008C; Sat, 11 Jul 2026 17:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77A1D6B0092; Sat, 11 Jul 2026 17:38:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4801C6B008A
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 17:38:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B6E33407CB
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 21:38:13 +0000 (UTC)
X-FDA: 84977809266.02.F983C1F
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.167])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7724520004
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 21:38:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=NtgbPoJJ;
	spf=pass (imf13.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.167 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783805891;
	b=2pj4HsiOApd7AMHdMuTIXEJNBCjqaaai0V9nqrOmlzS79QhuzwnXoWNPZELZu0MxnVJl6D
	P3xFKl52uJFQ4auOkr9zrE/scZuDndVVWqEEqMCT9kb+1L2HlROZIwYSdyNRqNHdbBzvLR
	YHwWBSVYyqH/jaJuFUKxfsOcrKkOiZc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=NtgbPoJJ;
	spf=pass (imf13.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.167 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783805891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SBJebS8jLRzRA7+SKiwlGxr0ddufRJVoJrg6ial4USo=;
	b=KdzFYXpjsS2PUy98SylfSA+A82v2E7oLUT483+K/LfTaxwusT9kbKhQJcwT1L7/Y4MGZZM
	ZAfrJfe/0/KjkPI3Th1kFeqtwoFE/oMGmiouTHsfxiND7BunOkMT+PCFHaJvztATNgXGXF
	ojQKGM12MbQBc9j2gWql5D8LFfD0feE=
X-KPN-MessageId: cf11c8de-7d70-11f1-b2a8-005056abbe64
Received: from smtp.kpnmail.nl (unknown [10.31.155.39])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id cf11c8de-7d70-11f1-b2a8-005056abbe64;
	Sat, 11 Jul 2026 23:38:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=SBJebS8jLRzRA7+SKiwlGxr0ddufRJVoJrg6ial4USo=;
	b=NtgbPoJJ4SWd+BrFbHtqhBI4aoirr1sZ7+KiVO7kuxZ6mDK5xWwoWEiV4wSTy4l4xCAeCPqpzTuZc
	 gKh7twiR3XyZoSBIkSUqJJyPkrza42oVXeJ0IaUpT9EtRb/nVRuhLZpm1o99eMX7VK79qF2/948KB4
	 V1//bK/GWYvqQxSsYYB0PhtuhWaV5OlfYm6Z4nZOM17/r1fZ+z84BNEmOXENmsP/brtXR/YB2vWdpR
	 b1IYN5lGnzcZX3NCHQ3YpOR6AXBEA7RAd8D58Yet9fEpj5iu6/LhOX7K5fqhB4Fvfm4yzezVfO1Rfl
	 Uio/VEaEwdxV2hvGLIzTtr4j/RcePVA==
X-KPN-MID: 33|qNAdK+3j9nNmPD9YkJ021KjAR0T2MYWFOKG3z7M12lNW65D1hNJygaD+35oUWnR
 6pGcnYSOP+c5lV0gkny1biYJHf+heogZtivdTsrZCct0=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|6GB5UOB/HSmz5cXV+uMjp+q2hlashJ9GVHX0QmFKYv18TSPm14Yv6eNJKRVKFkF
 1uVZ5W+dmBitp+cl1G9xYYg==
X-Originating-IP: 178.226.150.234
Received: from localhost (unknown [178.226.150.234])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id ce6bb879-7d70-11f1-a8b4-005056ab7447;
	Sat, 11 Jul 2026 23:38:08 +0200 (CEST)
Date: Sat, 11 Jul 2026 23:38:04 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 05/24] binfmt_misc: use RCU for the handler lookup
Message-ID: <alKzv9cAGT0yqSW6@lt-jori.localdomain>
Mail-Followup-To: Jori Koolstra <jkoolstra@xs4all.nl>, 
	Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-5-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-5-a162f7cb58d6@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7724520004
X-Stat-Signature: qosj7e85kwj3wujd9u6gj3c3nzjzrm1u
X-HE-Tag: 1783805891-156891
X-HE-Meta: U2FsdGVkX1/3NOGXSovZWsGaYEs9NF8EtYmXr5+XFsm1YLZCKt5MF67gBwPkw0j2BLuGqT/B6bnaO3HXDaYZBNaFQjLxqwaTnJW+tMBFyB0K/L0HixDWbogNv7ZUmHZFKVfu0dBwr7yVryXu/y1Hf9kTS3QuYUFyD7IxQ8uT7udoAHjyyd3TiVmL2eTOXsQtf9ibFbv766uIh5LXKVfNU7onQl73fQzND3lZs2b5i/bLOgAzkg4M5o4BqUL+8IlQAhS+oCK59k5WmtJSG3E2mDn6zDLR+228IdE34np3hoHVowjtz41EjL8JiiOBL7ZeiKaD1+v1z3lVHqA9ie3abwTRa9Yw0QGP45zvljwU2wFUCVzvhIw6AFMc91kUsJbwArzFSvkm0cX07FdOPA3llSkzNlwnYVxMOQowbMlLj7ai94FlU+i6v3QKvNumOO0HRuJTEqtCEjkqYWod8JrfDx5bI84JFOmDOt099M67Xf4cwMKEfvxiKA3h5jQMNEylUQ/Ls+NIU2jCLCe/2Bh7NaQDhczN/rrNhHMZi3hqav1t+Q0tFAiTQzmBOBRGfOHDNX/vFSHASPN3lh8pU9Igi4k46Ggznyt3XfujKHNu5fa9BfNcMQ7/m+/VeoUFQM+UZqs8wYXZobabqKp2AQmaWaHfm0ZH4iugtaxp9Kp/2Znd4AljR4WkVwzPEYPm/RHT7alnw0N43wQBdT9tpCRJiOOSmr4jymO41b7DC99wnwpp8YYfihj3/s3OtiptTsqQPqSs3uEEzPeHhc0wt1cMHMZcjF0OKBKiFepMlVHiH12Bm3HUi1FdwAVytb78EjlTFsaa4sJCgtbUwxNSYpgG4C5pOZVPHYU89GwqVsgAq7/MLCPH9oTZDRArclTiOisk66I9Ri+wftm/172NiPDYuLmNr7AimVE8jKPKQJCMlvnSaix3nPI42GEXoLLtuA0rRTAd3B6Bf5tQds+8n6i
 55HYxN6x
 Gga7EIuKn8EextrtyEOF/mgmG2CXm5bbKX+dmO+3v4Pq+NTWByfPKrO+x3+LgkZDCC5J05AwhnA8V3d/4+R/xXtAQX3u9wQNxjkN6xf1hARr1At0zTeeqw7JDaqJsiCvolfsarfmErk1/QSX5dTpQbgbnzHSUiiEhQY5hOiGYjpLaF/p6IsmuAuCN+G45fEBNuW7C5LYPN2py3qccOSW795miaj/Qakzg75RF1wOY+K32bFOH8JjhCQeKkFgzdzuXJg1hUipeA9TWQBPEbq2NTEufxneWhOQnaY68qN5cLzdbDjgKA2fdWxjWfSQ92L5rL2o6hx3kW42yIjrspEx8HBhiqQO8WUPhGN0I1+99ufVcqTqQOAoHLX9HukjZ3r6GFdPO9bx7o8iOxX2foDFsxl0pfkQPnRbiGxxScgx1mImUti3Hq7f8gv+T9KsfTqhGVrcsfSYfci0ZeJygH0284VeZ7fwxLn//YpWjXbd14FDKydb3oQ5OMYGBV545VUd+7TIDeq5k3cTwzz6g0oxhr3x0mqY+d8vsJMS+2RjTV60Pw2TSh1mr+acm3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:06AM +0200, Christian Brauner wrote:
> Once binfmt_misc is loaded load_misc_binary() runs for every execve()
> on the system since binfmt_misc registers at the head of the formats
> list. Every exec therefore performs read_lock() and read_unlock() on
> the entries_lock of the relevant binfmt_misc instance, i.e., two
> atomic read-modify-writes on a shared cacheline. User namespaces
> without their own binfmt_misc mount fall back to an ancestor's
> instance so on container-heavy systems every exec on the machine
> typically ends up hammering the cacheline of init_binfmt_misc. On
> PREEMPT_RT the rwlock additionally turns the handler lookup into a
> sleeping lock on the exec fast path.
> 
> The lock protects very little. Entries are immutable after publication
> except for the Enabled bit which is already toggled locklessly via
> set_bit()/clear_bit() and entry lifetime is already handled by the
> users refcount via get_binfmt_handler()/put_binfmt_handler(). The read
> lock's only remaining job is to make "the entry is still linked" and
> "take a reference" atomic with respect to the unlink sites.
> 
> Switch the lookup to an RCU walk:
> 
> * Lookup walks the entry list under rcu_read_lock() and acquires a
>   reference via refcount_inc_not_zero(). The refcount can only drop to
>   zero after an entry has been unlinked so a failed increment means
>   the walk raced with an unlink. Restarting the search is bounded
>   because an unlinked entry cannot be found again.
> 
> * The unlink sites use hlist_del_init_rcu() which keeps the forward
>   pointer intact for concurrent walkers and preserves hlist_unhashed()
>   as the protection against double removal.
> 
> * The final put frees the entry via kfree_rcu() as a concurrent walker
>   may still dereference its flags, magic, mask, and inline strings.
>   They all live in the entry allocation itself and thus stay valid
>   until a grace period has elapsed. Closing the interpreter file stays
>   synchronous. It is only used with a reference already held and all
>   final puts run in process context.
> 
> * Writers remain serialized by the inode lock of the root dentry with
>   one exception. bm_evict_inode() called from generic_shutdown_super()
>   during umount unlinks entries without holding it. Keep a spinlock
>   around the unlink sites instead of relying on superblock lifetime
>   rules to make that exclusion implicit.

OK, so you did address this. I missed that in my review of v2. Writes
here are rare, so the spinlock cost is low. Therefore, being explicit
about the locking outweights the cost, makes sense.

> 
> Handler removal semantics are unchanged. An exec that acquired a
> reference just before its handler was unregistered already completes
> with the removed handler today. The read lock never protected against
> that, it only made the window smaller.
> 
> With this an exec that matches no binfmt_misc entry, the common case,
> no longer writes to any shared cacheline at all.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c        | 59 +++++++++++++++++++++++++++++--------------------
>  include/linux/binfmts.h |  2 +-
>  kernel/user.c           |  2 +-
>  3 files changed, 37 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 89da2d4e7f91..bd7790a1317b 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -24,6 +24,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/namei.h>
>  #include <linux/mount.h>
> +#include <linux/rculist.h>
>  #include <linux/fs_context.h>
>  #include <linux/syscalls.h>
>  #include <linux/fs.h>
> @@ -59,6 +60,7 @@ typedef struct {
>  	struct dentry *dentry;
>  	struct file *interp_file;
>  	refcount_t users;		/* sync removal with load_misc_binary() */
> +	struct rcu_head rcu;
>  } Node;
>  
>  static struct file_system_type bm_fs_type;
> @@ -86,6 +88,8 @@ static struct file_system_type bm_fs_type;
>   * Search for a binary type handler for @bprm in the list of registered binary
>   * type handlers.
>   *
> + * The caller must hold the RCU read lock.
> + *
>   * Return: binary type list entry on success, NULL on failure
>   */
>  static Node *search_binfmt_handler(struct binfmt_misc *misc,
> @@ -95,7 +99,7 @@ static Node *search_binfmt_handler(struct binfmt_misc *misc,
>  	Node *e;
>  
>  	/* Walk all the registered handlers. */
> -	hlist_for_each_entry(e, &misc->entries, node) {
> +	hlist_for_each_entry_rcu(e, &misc->entries, node) {
>  		char *s;
>  		int j;
>  
> @@ -134,7 +138,10 @@ static Node *search_binfmt_handler(struct binfmt_misc *misc,
>   * @bprm: binary for which we are looking for a handler
>   *
>   * Try to find a binfmt handler for the binary type. If one is found take a
> - * reference to protect against removal via bm_{entry,status}_write().
> + * reference to protect against removal via bm_{entry,status}_write(). The
> + * refcount of an entry can only drop to zero once it has been unlinked and
> + * a restarted search cannot find an unlinked entry again so the retry loop
> + * is bounded.
>   *
>   * Return: binary type list entry on success, NULL on failure
>   */
> @@ -143,11 +150,10 @@ static Node *get_binfmt_handler(struct binfmt_misc *misc,
>  {
>  	Node *e;
>  
> -	read_lock(&misc->entries_lock);
> -	e = search_binfmt_handler(misc, bprm);
> -	if (e)
> -		refcount_inc(&e->users);
> -	read_unlock(&misc->entries_lock);
> +	guard(rcu)();
> +	do {
> +		e = search_binfmt_handler(misc, bprm);
> +	} while (e && !refcount_inc_not_zero(&e->users));
>  	return e;
>  }
>  
> @@ -166,7 +172,8 @@ static void put_binfmt_handler(Node *e)
>  			exe_file_allow_write_access(e->interp_file);
>  			filp_close(e->interp_file, NULL);
>  		}
> -		kfree(e);
> +		/* Lockless walkers may still dereference this entry. */
> +		kfree_rcu(e, rcu);
>  	}
>  }
>  
> @@ -679,10 +686,10 @@ static void bm_evict_inode(struct inode *inode)
>  		struct binfmt_misc *misc;
>  
>  		misc = i_binfmt_misc(inode);
> -		write_lock(&misc->entries_lock);
> +		spin_lock(&misc->entries_lock);
>  		if (!hlist_unhashed(&e->node))
> -			hlist_del_init(&e->node);
> -		write_unlock(&misc->entries_lock);
> +			hlist_del_init_rcu(&e->node);
> +		spin_unlock(&misc->entries_lock);
>  		put_binfmt_handler(e);
>  	}
>  }
> @@ -701,9 +708,9 @@ static void bm_evict_inode(struct inode *inode)
>   */
>  static void remove_binfmt_handler(struct binfmt_misc *misc, Node *e)
>  {
> -	write_lock(&misc->entries_lock);
> -	hlist_del_init(&e->node);
> -	write_unlock(&misc->entries_lock);
> +	spin_lock(&misc->entries_lock);
> +	hlist_del_init_rcu(&e->node);
> +	spin_unlock(&misc->entries_lock);
>  	locked_recursive_removal(e->dentry, NULL);
>  }
>  
> @@ -754,9 +761,11 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
>  		 * via bm_{entry,register,status}_write() inode_lock() on the
>  		 * root inode must be held.
>  		 * The lock is exclusive ensuring that the list can't be
> -		 * modified. Only load_misc_binary() can access but does so
> -		 * read-only. So we only need to take the write lock when we
> -		 * actually remove the entry from the list.
> +		 * modified. Only load_misc_binary() can access the list
> +		 * concurrently and it does so under RCU. So entries_lock only
> +		 * needs to be held when an entry is actually unlinked to
> +		 * serialize against bm_evict_inode() during umount which
> +		 * unlinks without holding inode_lock.

This makes it sound as if this serialization is strictly required,
instead of just for clarity. Unmount cannot happen while we are holding
a struct file into that mount, correct?

>  		 */
>  		if (!hlist_unhashed(&e->node))
>  			remove_binfmt_handler(i_binfmt_misc(inode), e);
> @@ -801,9 +810,9 @@ static int add_entry(Node *e, struct super_block *sb)
>  
>  	d_make_persistent(dentry, inode);
>  	misc = i_binfmt_misc(inode);
> -	write_lock(&misc->entries_lock);
> -	hlist_add_head(&e->node, &misc->entries);
> -	write_unlock(&misc->entries_lock);
> +	spin_lock(&misc->entries_lock);
> +	hlist_add_head_rcu(&e->node, &misc->entries);
> +	spin_unlock(&misc->entries_lock);
>  	simple_done_creating(dentry);
>  	return 0;
>  }
> @@ -899,9 +908,11 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
>  		 * via bm_{entry,register,status}_write() inode_lock() on the
>  		 * root inode must be held.
>  		 * The lock is exclusive ensuring that the list can't be
> -		 * modified. Only load_misc_binary() can access but does so
> -		 * read-only. So we only need to take the write lock when we
> -		 * actually remove the entry from the list.
> +		 * modified. Only load_misc_binary() can access the list
> +		 * concurrently and it does so under RCU. So entries_lock only
> +		 * needs to be held when an entry is actually unlinked to
> +		 * serialize against bm_evict_inode() during umount which
> +		 * unlinks without holding inode_lock.
>  		 */
>  		hlist_for_each_entry_safe(e, next, &misc->entries, node)
>  			remove_binfmt_handler(misc, e);
> @@ -979,7 +990,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
>  			return -ENOMEM;
>  
>  		INIT_HLIST_HEAD(&misc->entries);
> -		rwlock_init(&misc->entries_lock);
> +		spin_lock_init(&misc->entries_lock);
>  
>  		/* Pairs with smp_load_acquire() in load_binfmt_misc(). */
>  		smp_store_release(&user_ns->binfmt_misc, misc);
> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
> index 071da63f2b48..7e7333b7bb0f 100644
> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -102,7 +102,7 @@ struct linux_binfmt {
>  #if IS_ENABLED(CONFIG_BINFMT_MISC)
>  struct binfmt_misc {
>  	struct hlist_head entries;
> -	rwlock_t entries_lock;
> +	spinlock_t entries_lock;
>  	bool enabled;
>  } __randomize_layout;
>  
> diff --git a/kernel/user.c b/kernel/user.c
> index c6a2bfb4d918..21bafdc11379 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -25,7 +25,7 @@
>  struct binfmt_misc init_binfmt_misc = {
>  	.entries = HLIST_HEAD_INIT,
>  	.enabled = true,
> -	.entries_lock = __RW_LOCK_UNLOCKED(init_binfmt_misc.entries_lock),
> +	.entries_lock = __SPIN_LOCK_UNLOCKED(init_binfmt_misc.entries_lock),
>  };
>  EXPORT_SYMBOL_GPL(init_binfmt_misc);
>  #endif
> 
> -- 
> 2.53.0
> 

At any rate,

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

PS. Let me know if me reviewing is welcomed or not. Obviously I can't
review with the same depth and oversight as you, Jan, Al or Neil, but it is
a good excuse to learn more VFS code and I intend to continue
contributing to it, so I should also do some reviews. This series seems
like a good candidate to start...

