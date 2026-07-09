Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C48FDC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2BF26B0093; Thu,  9 Jul 2026 06:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADC666B0095; Thu,  9 Jul 2026 06:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CDB26B0096; Thu,  9 Jul 2026 06:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 644446B0093
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:46:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFAFD1C86CF
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:46:58 +0000 (UTC)
X-FDA: 84968910516.18.FD0DF97
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.186])
	by imf11.hostedemail.com (Postfix) with ESMTP id C352E40006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:46:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=LHax4I++;
	dmarc=pass (policy=reject) header.from=xs4all.nl;
	spf=pass (imf11.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.186 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783594017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGJ85lyswz7H64xtvY5/lRfspGPNd2ggZFXYklBEsPY=;
	b=7D5JdnJRMa0/W+rtUBpw7j/F6DcAdEBsD2YhuyGO86tmLShFKo+CpMU1JMczUwTMyzlk6e
	Zi4bswvL7eQsXO6rmOAiDovU4ZtIC4pqOZHZwRCBegjv/IYzKViNif1Ho8kfNanqRfPPB+
	04xuz7/Y9+v7/fUW7+cftkbWykCpuvY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=LHax4I++;
	dmarc=pass (policy=reject) header.from=xs4all.nl;
	spf=pass (imf11.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.186 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783594017;
	b=y7DQuQ6LPs/CzTjvzEQ/v/fD2fhpue5eWhFFWuKTkKsKQ8Z0HIiZmjOtk62lvmpNUOeZTR
	ju3bMxHmD+yDAFHigQqVHvNjg0Xg2zihMohn03PdRNh/QSjp3NGJn/l+HQq1zDchPTkTXr
	owbiDUClnwjIMd3Gy+GHbCnk6BA6vOg=
X-KPN-MessageId: 800399e9-7b83-11f1-bfba-00505699b430
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 800399e9-7b83-11f1-bfba-00505699b430;
	Thu, 09 Jul 2026 12:46:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=bGJ85lyswz7H64xtvY5/lRfspGPNd2ggZFXYklBEsPY=;
	b=LHax4I++KvfSgL9NuLOWgUBi1dfXl9X3IosCb1GxBkAbIGL2f2dlLrJSeiFzbg+QiEW0V47NkRzq3
	 Rs4Nl7mCCVAftibeBO9ZLF7qdZyCqb6mVNnegpeTAlxjorYgBmJt6qPoie/AqYB2+rU8BNf5xoLkqh
	 vq0Ryn2I4NzfcvZdaIfNg1mpmScg6enr21HYD19aYY6AkilsJmDdS5U7rFpuygwN/WHyqCQIaAJ9LQ
	 gOvFVE53tBcdXMf8dd6JilWVKJH8NH0erer1AFbGDMmm2TU2GADXDjctwhzgzjCXTCfxzY8UEYGkK+
	 jlq8NgcYJQULnSHcMT9XJ6C30W1Ze8A==
X-KPN-MID: 33|Vyna2IAIRpXftOMbMqP6NqzZyURmWe8oFc0pLlwGSvZSEqYbTpQHIRsO8K0Lhws
 E4SrZkDx5lbEZTQwgeBHdRz3qyevteVA8v/DX8wE7H/c=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|WJIhhbMH98XZmzCvbPYv+WbbgljD0xEfauBx5MLe1WkAfyP0v4F9Laeasb8Upk2
 bRjkEFy6OwW11LBqA8EOzxQ==
X-Originating-IP: 178.226.150.234
Received: from localhost (unknown [178.226.150.234])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 7fbcdffa-7b83-11f1-87f1-00505699b758;
	Thu, 09 Jul 2026 12:46:54 +0200 (CEST)
Date: Thu, 9 Jul 2026 12:46:48 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH 1/3] binfmt_misc: convert entry list to an hlist
Message-ID: <ak90aO482k7p5fdz@lt-jori.localdomain>
Mail-Followup-To: Jori Koolstra <jkoolstra@xs4all.nl>, 
	Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
References: <20260708-work-binfmt_misc-locking-v1-0-a009dd5b56db@kernel.org>
 <20260708-work-binfmt_misc-locking-v1-1-a009dd5b56db@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708-work-binfmt_misc-locking-v1-1-a009dd5b56db@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C352E40006
X-Stat-Signature: 3ci1ggdmwspem4khaazfsuadc4cgrdfy
X-Rspam-User: 
X-HE-Tag: 1783594016-61400
X-HE-Meta: U2FsdGVkX18NlJWmp4uv8a9dkhK5nZ/oAavWENzgO7ZS6m43GF7GFKcO7q+3cFjSTv/ZhmZ6sewE9LlI7tG4+2+mLdY3PY376sud51U7m7snpOXKGdqUr1P1R8baCHpmAyd1IxgzBWiCtfqhJESTrpcY5bN4sVmISpMbw/BKz4WBd4Z5tJ0+c0zJ3fJTXn0wSIDdKdDtEW6SfTkA9TpHX2Z6ZzNZVV885Go2SY75bpxiy6CiXBfA8KBvsPlwbINo7FKNYWxjBVh8of2eD8uibmIxJ61F5HKBGwaezNyBuLK9XHWFvT9k9iK8qRjcGUWsn4AkepEIVA11Q0V6+M75H0XavBZYP3C6Ut0R9uXzQRMTCGLnvyKXEy0s4DBbIPfB86xTM+0jqwn43nE/kXDdKWMs2txp7FtjwYrLwE9WUQFBkfbEPanzDYH7B4VCH14rCfcq064vzz8mMSWawAf+/8Td2tCys56mSPAEWsCzFLaTCozipDjT36kgTC31uao/pJHaBp7MV3pP7Zg7Z5C/Mib+WqQcxjGMATO8SXi/eC8dYFefTQqr4Yl5k0GOmiB29atzn/5VxpvB9TaMsqRdIBh+hEpB5PFvgAOPoGmZW5hdcRtllp+UnFkATzu4fKUKFJMGui7m6p7E4i9rTmunuohu8KoXKHE6uoUk0Bdj1hjfOKV1UJL+UINA6YZ095wAZIWomk0WHJr3spdHHoEGZUAjN76fIq7f05phWexap0zcf2arG/PAQdEHjrRqVpwcKEkehfmtEATOGcQ14tuNE248PtkqIXsR3W+djPGnSjMS2/PmkCtg04Z7SnX4WEVdA5Kqu29ZVIWsR/Bi3JbsT/B5fjlBBnsdT/v35wl5HXAvjmdtMCWpSh8vBR45Rt51pZZ7D4GHW6TQMiPpbIDuuR1FA2nytegYnHG1XvGs+z7YF7S4vi1lbIoKM62hEYnMnVg9KZWg721ALnmI9j7
 7eWC2/rA
 krDunzLMVJM0TGiqr5nviL/1OQSk/nopQWfsbAfK6IwzT/yfaYaHezlgO1zyUOiHFGn9v7iCx16rRe40JZ+AzocK0pO4BmCyTs5L7h0hfOI0aUgEWxNLGs7hblMOl4ZOi+ganOWFcqJC8VNQYyN3rgU9IvlhLA0Nif1uVZl+Qm1tBM1wqna832ia/FnKtUqSo+nkgHB8a1Z2Nvv6IQTVkbMqSGemJn6ozC6cgcQg6aLQqqL+0QUOtrR+NWlz7bocfomj/aGNhkDJRcCOzRVce2jdFVPd8idoYIRIVCa3aIZRn7xP9W7NtLcq+Y12VAkQ0r1ELogf7/mFRHHExBVfIF3CaxPblOlwtfV3lMFeVrrh9XkO9JCVv59yrL2HJrVT3wzU4tFOVl6Rnk6d0QwuqyMlBbd/q7QFH9aawkdUqNsfDyLl2cAEyd0eoKMgyndfwcdiskT+lpkT22W+SkSmy46H5i/JXgwz3KK7mIQ5DCniL7UoBOguyFDlc+/137+xOn6Fc1Mim4JkoMbqjqMcuMfpPlWHzidYMvBOWyzldzgJO++kyMeqmmjcsgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 06:51:16PM +0200, Christian Brauner wrote:
> The upcoming conversion of the handler lookup to RCU walks cannot use
> list_del_init(): reinitializing the forward pointer of a removed entry
> would make a concurrent lockless walker standing on that entry loop
> back onto it indefinitely. The removal paths do rely on
> reinitialization though because bm_{entry,status}_write() and
> bm_evict_inode() need to detect whether an entry has already been
> unlinked.
> 
> hlists support exactly this pattern: hlist_del_init_rcu() keeps the
> forward pointer of the removed entry intact for concurrent walkers and
> only zeroes ->pprev with hlist_unhashed() serving as the linked test.
> 
> Convert the entry list to an hlist now while keeping the rwlock so the
> subsequent RCU conversion is a pure locking change. hlist_add_head()
> inserts at the head just as list_add() did so lookup precedence
> between registered handlers is unchanged.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c        | 25 +++++++++++++------------
>  include/linux/binfmts.h |  2 +-
>  kernel/user.c           |  2 +-
>  3 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 84349fcb93f1..34de1b01e9c2 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -48,7 +48,7 @@ enum {Enabled, Magic};
>  #define MISC_FMT_OPEN_FILE (1UL << 28)
>  
>  typedef struct {
> -	struct list_head list;
> +	struct hlist_node node;
>  	unsigned long flags;		/* type, status, etc. */
>  	int offset;			/* offset of magic */
>  	int size;			/* size of magic/mask */
> @@ -95,7 +95,7 @@ static Node *search_binfmt_handler(struct binfmt_misc *misc,
>  	Node *e;
>  
>  	/* Walk all the registered handlers. */
> -	list_for_each_entry(e, &misc->entries, list) {
> +	hlist_for_each_entry(e, &misc->entries, node) {
>  		char *s;
>  		int j;
>  
> @@ -654,8 +654,8 @@ static struct binfmt_misc *i_binfmt_misc(struct inode *inode)
>   *
>   * If the ->evict call was not caused by a super block shutdown but by a write
>   * to remove the entry or all entries via bm_{entry,status}_write() the entry
> - * will have already been removed from the list. We keep the list_empty() check
> - * to make that explicit.
> + * will have already been removed from the list. We keep the hlist_unhashed()
> + * check to make that explicit.

Right. That's a good idea. The code reads a bit confusing because of the
two ways we may end up in bm_evict_inode(), but that isn't an issue of
this patch specifically.

>  */
>  static void bm_evict_inode(struct inode *inode)
>  {
> @@ -668,8 +668,8 @@ static void bm_evict_inode(struct inode *inode)
>  
>  		misc = i_binfmt_misc(inode);
>  		write_lock(&misc->entries_lock);
> -		if (!list_empty(&e->list))
> -			list_del_init(&e->list);
> +		if (!hlist_unhashed(&e->node))
> +			hlist_del_init(&e->node);
>  		write_unlock(&misc->entries_lock);
>  		put_binfmt_handler(e);
>  	}
> @@ -690,7 +690,7 @@ static void bm_evict_inode(struct inode *inode)
>  static void remove_binfmt_handler(struct binfmt_misc *misc, Node *e)
>  {
>  	write_lock(&misc->entries_lock);
> -	list_del_init(&e->list);
> +	hlist_del_init(&e->node);
>  	write_unlock(&misc->entries_lock);
>  	locked_recursive_removal(e->dentry, NULL);
>  }
> @@ -746,7 +746,7 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
>  		 * read-only. So we only need to take the write lock when we
>  		 * actually remove the entry from the list.
>  		 */
> -		if (!list_empty(&e->list))
> +		if (!hlist_unhashed(&e->node))
>  			remove_binfmt_handler(i_binfmt_misc(inode), e);
>  
>  		inode_unlock(inode);
> @@ -790,7 +790,7 @@ static int add_entry(Node *e, struct super_block *sb)
>  	d_make_persistent(dentry, inode);
>  	misc = i_binfmt_misc(inode);
>  	write_lock(&misc->entries_lock);
> -	list_add(&e->list, &misc->entries);
> +	hlist_add_head(&e->node, &misc->entries);
>  	write_unlock(&misc->entries_lock);
>  	simple_done_creating(dentry);
>  	return 0;
> @@ -863,8 +863,9 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
>  {
>  	struct binfmt_misc *misc;
>  	int res = parse_command(buffer, count);
> -	Node *e, *next;
> +	struct hlist_node *next;
>  	struct inode *inode;
> +	Node *e;
>  
>  	misc = i_binfmt_misc(file_inode(file));
>  	switch (res) {
> @@ -890,7 +891,7 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
>  		 * read-only. So we only need to take the write lock when we
>  		 * actually remove the entry from the list.
>  		 */
> -		list_for_each_entry_safe(e, next, &misc->entries, list)
> +		hlist_for_each_entry_safe(e, next, &misc->entries, node)
>  			remove_binfmt_handler(misc, e);
>  
>  		inode_unlock(inode);
> @@ -965,7 +966,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
>  		if (!misc)
>  			return -ENOMEM;
>  
> -		INIT_LIST_HEAD(&misc->entries);
> +		INIT_HLIST_HEAD(&misc->entries);
>  		rwlock_init(&misc->entries_lock);
>  
>  		/* Pairs with smp_load_acquire() in load_binfmt_misc(). */
> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
> index 2c77e383e737..071da63f2b48 100644
> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -101,7 +101,7 @@ struct linux_binfmt {
>  
>  #if IS_ENABLED(CONFIG_BINFMT_MISC)
>  struct binfmt_misc {
> -	struct list_head entries;
> +	struct hlist_head entries;
>  	rwlock_t entries_lock;
>  	bool enabled;
>  } __randomize_layout;
> diff --git a/kernel/user.c b/kernel/user.c
> index 7aef4e679a6a..c6a2bfb4d918 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -23,7 +23,7 @@
>  
>  #if IS_ENABLED(CONFIG_BINFMT_MISC)
>  struct binfmt_misc init_binfmt_misc = {
> -	.entries = LIST_HEAD_INIT(init_binfmt_misc.entries),
> +	.entries = HLIST_HEAD_INIT,
>  	.enabled = true,
>  	.entries_lock = __RW_LOCK_UNLOCKED(init_binfmt_misc.entries_lock),
>  };
> 
> -- 
> 2.53.0
> 

I can't really comment on whether the cache bouncing is really as
significant a problem to warrant moving to RCU, but your argument makes
sense to me.

At any rate I see no issues here or with the RCU change. For this one,
feel free to add:

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

Will look a bit more carefully at the RCU change later today/tomorrow.

