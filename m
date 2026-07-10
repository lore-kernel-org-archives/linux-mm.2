Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E17EC44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 10:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916FE6B0088; Fri, 10 Jul 2026 06:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EF6E6B008A; Fri, 10 Jul 2026 06:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 805076B0092; Fri, 10 Jul 2026 06:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BED06B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:54:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E3DC11A03F6
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:54:06 +0000 (UTC)
X-FDA: 84972557292.18.310D9D6
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id ADCFF40006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:54:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=ZTVJAugP;
	spf=pass (imf12.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.169 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783680845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X4n+np9AWPL4qAkwo9IYgXcjnYkVbOzZSP7jXvbWnCM=;
	b=P4yyckcjHDNGZBefl0H0k1SHVUDjqKY+tYxl7dKjITd9akkJTBFLxZRDgC4ezre3icIbon
	65Mxer5zNGuM9kqufVHpMvMQKA3L9uuNCj0YSKoSdkGp0Qy3YJCbFtnx0cay8gXA5Ep7YU
	paQbhcOcCMaxYakxaIinNYwe0Rakn7s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783680845;
	b=FblMtTdvPM1qMHAZRNBRhMOE6wDhzfMaGusS4g5n75iESDgWurjgqK+A0H3fMF0LPcJ/G8
	kNaKa8N36ySrwPw4W1qcO6KfsAKAUh4YyrhY643FFXMJzJOrbcROU3UUE6gx0xOFAMVfHf
	yEmYqssTWo3eOG3r4U8U4xrGrWpTalE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=ZTVJAugP;
	spf=pass (imf12.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.169 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
X-KPN-MessageId: a9500364-7c4d-11f1-a055-005056abad63
Received: from smtp.kpnmail.nl (unknown [10.31.155.38])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id a9500364-7c4d-11f1-a055-005056abad63;
	Fri, 10 Jul 2026 12:54:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=X4n+np9AWPL4qAkwo9IYgXcjnYkVbOzZSP7jXvbWnCM=;
	b=ZTVJAugP8PN+MQr3q3tB4syIzQJnpOKulvAvkDCUN/HqZiDJrtHmMLJ28g7To9SMr21pJL4Ex/Zhp
	 gCfU+Ie1DjXKU2gZjdFQx/NyS9vYygYCuCfI9K7Rv/0wayZzoXbREfVJ5aQVYsPbGlrCPigRku8agc
	 eHe3fCemjlfmgs83Pb7K9TC48xK8+mvENdXwcFhSrc6w75yjfyVQmn2yZI7vmjlPLl4gFHlpiKkmKj
	 Q9mB0GSFUggVV43pNJeqT85bZj4uQ1kXvzYtDlfTDyEsZQ7yItVwEqX1/mbD8gPnwrj4sZeG4/m2CY
	 zlyLzKk71b7aRAKyq5y9B4w2C4N3ifA==
X-KPN-MID: 33|Y+ysXTzHkP7LKS6budrKCnoCOuyHOgJsF3SAfmxgWu0oWnO5CVSPaKtIXPoxlUS
 khfHUO3XzQSpL3z6y4LWDQA==
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|gylGVY+FLwF+cDz2/gCuFR1uWWSlWitgVqvNRWWJofZc/tWVmdK5054noQ9kRah
 91HMWeMvf/kPV+r1zKVrf+Q==
X-Originating-IP: 178.226.150.234
Received: from localhost (unknown [178.226.150.234])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id a8ff44fb-7c4d-11f1-a998-005056abf0db;
	Fri, 10 Jul 2026 12:54:01 +0200 (CEST)
Date: Fri, 10 Jul 2026 12:53:57 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v2 04/23] binfmt_misc: use RCU for the handler lookup
Message-ID: <alDC4p6zRKkE-e4L@lt-jori.localdomain>
Mail-Followup-To: Jori Koolstra <jkoolstra@xs4all.nl>, 
	Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
 <20260710-work-binfmt_misc-locking-v2-4-2a1c3d4126a7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-4-2a1c3d4126a7@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ADCFF40006
X-Stat-Signature: iftpus9qscszxtpj8is8jogw5gxfax7e
X-HE-Tag: 1783680844-455912
X-HE-Meta: U2FsdGVkX185XBAku7SMtWJ4xkqE5BuLfTKJ6asnGmITJzNdBmmVoVwKZuKeKC6SpO+SdtygPmeyzFF9bLA2BUR5KV0YVKWmJevHiRX/V6RrznlI9fiSqRtHPlZiwbPXaZOpmZh6qfJX95T+PX+OIJ0wWh4vAaIizL9VQ6hSg3lhi9J0qRgeq4ESeNj1HENoDjQc1Up6/YkzP6oAcAkU9k5L56MGnVbIHdopicH8AA81swFjQNzS/pnOxOVViIwT0GwVxCz2+f4cYa7yCcTDfHW+vR3o41h+fv+5bNRnq/L34fwmrQhL8ZqhQ2TjA4k722Vf6UQsuA9lXkuQqono+kQ/C2vnj5yR6Z0Gt09L023tGTGFEN3dFfNc37+yZSumDPC8QIU+cThK7efVW7PIRW8MVxVyiTOQz4VXYmY4lz6n9He2qHZXb7/MSo0oFPRDlvMJ7HvWnxHnq5mwpvQd8xatSxjvdECYTwZcmACXj+0WppaxuUQjBoQ0uYyu/lzWtjottT2XRCT13yGF3mHOGF9D9mUB60goFWZ18eI7OuWLOXwWzcKHZYBTZP+c8M9jbOVmY+GqNt4ywDpcsvq0A84ccHD72YW/Wa+Wnq+c4OD/464/KlisGmIo1snuLTRzA0cXu39+AFCAO1dS7PboDjTkLIiaA/yNmAqO5A9dlJQseUH/+uYA6HhqJfQA3NxLFm/EnOhVYVLHeE2V7WcEMaZwUJM4mdQcSGq86/zr0WKxd9oSe3Oa2JQxbu/rsNWudn78Ka8TnNHl8kCfNSzuBTl/ONYKqRXm1/XXqYQDsbPzK3mEOS6oDTOVg9zaeMjPWs777uUZbMMon5WHXBH5R+AA4KJ872r+P0kSwLp+MH4LKHmPeea6i0sofcY2R9/7Q2VVQWVPzNigSo2gx4VOoq3vTFvXZP32Uz4le2tOz5vl0U+df9Mqf7uk8y7DlOpoGnTdypKVV5xYJaFyIgd
 jy89Tvxl
 pzc0eZI/3Y8PHCcMj0aOO1K5d0s6vVJu9ukljDB0tB9/yDZx9FYH/FcykFljpqiGVhifsqbSg2zXoTEQ72pgPSMQ7byDdZHVv/EqbYOfkXRU4y/dgeqvvx5NW7cW8/luLLCjbBsOARoMr6AF+FYbU5Wuse9K9QpHYIPgghendLqZGcxVEF4EtIdL7+4OlAZWKq/sYj/5CydB0pwb+RveQPiUrA0zFVrZ3o9TdkhMzXbQ8D/7x8UTCf07YzGb0YoF0hGmZQBkVfeX70sfWZr0myg1tpItt5WHfvRRhKrYFHIscG935VSa/qv9lUCA6/rr4g93SYyy3O7iJ+jUSPicIeB5/C5Wd1ENdEMOQDeax53K4LUHdnBkihPP6YV+NCgzYubszPNnc/7F0s/n9tC8sKIYj1tX2YM0QnkiXIBJeijjzzKd+oiPzZtLvlCK4QLyfFdf2rajLF/5t8GX1ZoTDDagJZtPlL1TU2YKAtQ87RIpIvyTDS8+cOjtmTXpsX4NhhLn3hFBokP+jCaE/iiXm1YYElaLP1HBl6Dlw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 12:29:59AM +0200, Christian Brauner wrote:
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
> index ab7dbd898977..08fd7991d4c8 100644
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

Right, unlink happens before refcount decrease everywhere.

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
> @@ -675,10 +682,10 @@ static void bm_evict_inode(struct inode *inode)
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
> @@ -697,9 +704,9 @@ static void bm_evict_inode(struct inode *inode)
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
> @@ -750,9 +757,11 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
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

Why do we have to serialize with umount here? bm_entry_write has a live
file as argument, so its inode cannot be evicted afaik, and therefore
there cannot be a race in this case with bm_evict_inode(). And when
evicting after calling locked_recursive_removal(), we have already
unhashed and

		write_lock(&misc->entries_lock);
		if (!list_empty(&e->list))
			list_del_init(&e->list);
		write_unlock(&misc->entries_lock);

becomes a noop.

>  		 */
>  		if (!hlist_unhashed(&e->node))
>  			remove_binfmt_handler(i_binfmt_misc(inode), e);
> @@ -797,9 +806,9 @@ static int add_entry(Node *e, struct super_block *sb)
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
> @@ -895,9 +904,11 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
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
> @@ -975,7 +986,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
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

Do you want me to readd the reviewed-by tags to this v2, or wait for v3?

Best,
Jori.

