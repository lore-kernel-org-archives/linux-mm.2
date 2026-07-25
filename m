Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 130B3C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 15:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A8756B0098; Sat, 25 Jul 2026 11:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 081166B0099; Sat, 25 Jul 2026 11:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDBCF6B009B; Sat, 25 Jul 2026 11:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B30296B0098
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 11:55:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3AFE98031A
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:55:30 +0000 (UTC)
X-FDA: 85027748820.21.A4ABF45
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3F7D7140008
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:55:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=YlaC956p;
	spf=pass (imf09.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.183 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784994928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2caielAy5YWpSfpB/EvCdmvT5rYo4ECYSr3Z0BRh1k=;
	b=bVxzK/h398uA8aRyPOmmLQjJecXoKCKfbxP4sOo/u5nYv1oufsbuyMzcblG+aeZsEDai2+
	My3LFteMpVOMkrx+pShzLSh988z8wd8sM3d76Kiabi6RI7832mmMyCUPyUldonKQeD1xZj
	oWGq2RcsjvKYZ61213sEf3ZLN+PBl2c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=YlaC956p;
	spf=pass (imf09.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.183 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784994928;
	b=ySJiArrviJQjBIB0BSdB/bNktlqbobBVJGwTRpoQCwnb/gLiPT/5+omzYGxN9rfpTzNHA/
	B29yydxT2+efzxcDS0+4MQ9P+3th4YGYPo/ucAPKluFIfTbUWJgMOayCxmgkkM9+gaWDrc
	UMmWZ8qewUFcxeQdHX68C1gvfxqBY/w=
X-KPN-MessageId: 40948ed9-8841-11f1-8f54-005056992ed3
Received: from smtp.kpnmail.nl (unknown [10.31.155.7])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 40948ed9-8841-11f1-8f54-005056992ed3;
	Sat, 25 Jul 2026 17:55:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=N2caielAy5YWpSfpB/EvCdmvT5rYo4ECYSr3Z0BRh1k=;
	b=YlaC956pxurcbVdpySmYk4W1hG0rWtqeLuOXN0FesBalrGE6LRXyt0jhoufOiZrHOz0O0L3kJYvMd
	 WxYGGkfFpxk9zuTbAOSGTQbn8C4w3j7TJx0nBwgC3TZxyN4MZoCMNJuNmLgkx3AMiChd5lJX12IVOx
	 ln0vlt4hW/fpPDb5EoC9k1mWJGl+mbNJS3XiFHw71jody+LyxpvLPypjZBsu688DvkdioI3C87HHV+
	 luBw1L+Hc8qF3OS5ECGQhYyVwY/DZHNJPXXyPYIqbWFRRP2PsLkH7ytlS1GIQZy8fBgxCL/0Dlt6Ww
	 fOafHXtd1rGfigOPaGsUkP/xrq0i3tQ==
X-KPN-MID: 33|B+iYy1xhRWmj0mq9FQCVTULLba/wIX0QZ4uD5umAj/VgNq3X306kFN7L7VogFfD
 aX8XwpILauRRhWBzDeDHQAdj8MRe6FiAeSh3UULWhqYA=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|5gvSlG1MYtR2kFh3LM/ln0e9EiGfxMcSrfPFBq1WvKYa12t7NavajxYZmyQrm61
 b9mM5EverqLBHkX+M8CEeHQ==
X-Originating-IP: 85.144.169.142
Received: from localhost (142-169-144-85.ftth.glasoperator.nl [85.144.169.142])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 40379afb-8841-11f1-8089-005056998788;
	Sat, 25 Jul 2026 17:55:26 +0200 (CEST)
Date: Sat, 25 Jul 2026 17:55:24 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 17/24] binfmt_misc: factor out the entry removal
Message-ID: <amTcOh-bqBGgp8me@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-17-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-17-a162f7cb58d6@kernel.org>
X-Rspamd-Queue-Id: 3F7D7140008
X-Rspam-User: 
X-Stat-Signature: hh4tur3gw1uaeuqqxkobqw46cfx5xdh9
X-Rspamd-Server: rspam04
X-HE-Tag: 1784994928-938836
X-HE-Meta: U2FsdGVkX19qR+yBut2TTP1byBKae/oMWeixRHZigT6B6e+rpTUnmEcsad2Car0v0ZP1W9qwiry5q0bTJHAjJRpJCx4fKpfrcyuNIM95qwry6WVKot0ZSfyqe8H8ybYPY1nQDJ3ayXxdvaj2tbwisdRRT55KBpwi6x1EAo4nRe2wWsv/VlKnNrEHaKBzoeyUaYtAyNRzoLYEkCUOkZNTvAv6prfPpVGea1s7orAw8JQ+e9t5ddrW7cQyXhgn7nUVMi8Y27i+dpJL7rHtlRR5BwpMPJyW4jRz049JTTgKo7ofaj8K4xUojz/OgO9xD6ARykKLpNv+pY77aH6LFSXKQNslDg3D2GZIMPiwyaGyVNJYFZil4XQFuK6Sq/G2ZeozpP67HvS9d8W2nqer9ASD4mD0jEt78MYX2hOzR7G7w7mDlIAKoAXYXPz2MDfXy9tBId47fIQU2Jvn+xltJ/irwGuxCQ3eh+kCrFkVR4zUWC9G7iyHrou/MOTNaXo/L4+AKYxtonSxhmkwYub/85GPb/sugo2jaI8J3eB200RWhf7Q/wIJ+JLKRK3OYpp6gwiMqPLoAZWIURooQAvdSwKY1nOEzXfuBb0Cne6i2+nggYXBZbs48BYS1G3EAJuFBKjnr76o2AKZbjW3BOTXmAbGWXwfC052mT0CJqc775DIdtmfL5BhigK7zySbSCwfbtx0f176T6Px2kWxTKWFwoGwlpEFKXaJUekMyOHu6yygnmVTWXkeF3dkEEPvt/j8QuPO0vtx+iUReqNdT5o4xMzRPklbeDtJCcMbbkrYaavLq3vtfhqSWrlQ8sV31Yv6XQh2zTmcW/DG10QloFJGvMQaJ4zOI+B2PzeE8e8oTB4RudMfuMrMKijWnc0ZwNKdkGqE9DSyktT3PL7OCMFN0c2mxfBBVRPvJilsN2FqbEGl6ZEg4oAiWwXNJDMFzs/rgeoc3wUal14+KSZ84JfMV6I
 0VsFp6wI
 bn2y/O7N6ScREbFcAZLeCuaWyi3/4bsUY/E3i0Yu5T8rc0DYvBJf+BwDqdCUJn8a1KMxVB9qBN753FU3O2FlPdGa70juko+PwuGMcbOfbLRo8E9X9VoYyWAX8mD2LRy9mNXst+z1EY3xngDZhM3B456AzIPO84BHVSUIa/mIOf4XP9c759Cy0CofPvhHRzdO04zqxxMpjaKm3kzkKY9bJtDCqTYGSKhRrsmiiCqwF/dz04eAJpQL7fiq1U1IGrPYZraM8AJ1wLiO24v8mpgba4+wt4VJ30TbiueKZaJNcDJir9dv+S6R4U0KjTqPSxtZFJCLx0CUgrLlzIi5dHFRESucvlP9vmwD5KosrDc+mMuTQUr0GyYitX06PV7e6Dso5d/IbcYcX+AcHuzG+BH1X+4TeEr7MW0yspwWtfGJqJEfB0zkH0+ueSReotHWqPf/u+u17+chMvTuYapMJ5YAqbBPmGtJ8LTxFY2aLS4BRoCqm6XIx1JBP2NHCXtJpQzAeBVElFrixt46+lSHcJUiXy1pXKYZLlaQa5lm8KiX/Omf8OAz/9Yd68jI61w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:18AM +0200, Christian Brauner wrote:
> Both write handlers open-code the same removal dance - grab the root
> inode lock, unlink, unlock - each carrying a verbatim copy of the
> same eleven-line locking comment, and bm_entry_write() reuses its
> inode variable for the root inode halfway through to pull it off.
> Move the dance into bm_remove_entry() and bm_remove_all_entries()
> and the locking rules into the kernel-doc of remove_binfmt_handler()
> which both helpers wrap.
> 
> No functional change.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 84 +++++++++++++++++++++++++++-----------------------------
>  1 file changed, 40 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 1f2b1d136819..d6bc2abc4a7f 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -686,11 +686,19 @@ static void bm_evict_inode(struct inode *inode)
>   * @e: binary type handler to remove
>   *
>   * Remove a binary type handler from the list of binary type handlers and
> - * remove its associated dentry. This is called from
> - * binfmt_{entry,status}_write(). In the future, we might want to think about
> - * adding a proper ->unlink() method to binfmt_misc instead of forcing caller's
> - * to use writes to files in order to delete binary type handlers. But it has
> - * worked for so long that it's not a pressing issue.
> + * remove its associated dentry.
> + *
> + * Adding and removing entries via bm_{entry,register,status}_write()
> + * happens under the exclusively held inode lock of the root dentry keeping
> + * the list stable for writers. load_misc_binary() walks it concurrently
> + * under RCU. The entries_lock is only held around the actual unlink to
> + * serialize against bm_evict_inode() which unlinks entries during umount
> + * without holding the root inode lock.
> + *
> + * In the future, we might want to think about adding a proper ->unlink()
> + * method to binfmt_misc instead of forcing callers to use writes to files
> + * in order to delete binary type handlers. But it has worked for so long
> + * that it's not a pressing issue.
>   */
>  static void remove_binfmt_handler(struct binfmt_misc *misc,
>  				  struct binfmt_misc_entry *e)
> @@ -701,6 +709,31 @@ static void remove_binfmt_handler(struct binfmt_misc *misc,
>  	locked_recursive_removal(e->dentry, NULL);
>  }
>  
> +/* Remove @e unless a concurrent write already unlinked it. */
> +static void bm_remove_entry(struct binfmt_misc_entry *e, struct super_block *sb)
> +{
> +	struct inode *root = d_inode(sb->s_root);
> +
> +	inode_lock_nested(root, I_MUTEX_PARENT);
> +	if (!hlist_unhashed(&e->node))
> +		remove_binfmt_handler(i_binfmt_misc(root), e);
> +	inode_unlock(root);
> +}
> +
> +/* Remove all entries of the binfmt_misc instance @misc belonging to @sb. */
> +static void bm_remove_all_entries(struct binfmt_misc *misc,
> +				  struct super_block *sb)
> +{
> +	struct inode *root = d_inode(sb->s_root);
> +	struct binfmt_misc_entry *e;
> +	struct hlist_node *next;
> +
> +	inode_lock_nested(root, I_MUTEX_PARENT);
> +	hlist_for_each_entry_safe(e, next, &misc->entries, node)


I do wonder, we are relying on superblock lifetime rules to make this
iteration safe afais, and the reason we take the spinlock at all is to
not implicitly rely on that, but then here we do that anyway. But this
is already an assumption in the old code too, so

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

> +		remove_binfmt_handler(misc, e);
> +	inode_unlock(root);
> +}
> +
>  /* /<entry> */
>  
>  static int bm_entry_open(struct inode *inode, struct file *file)
> @@ -732,24 +765,7 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
>  		set_bit(MISC_FMT_ENABLED_BIT, &e->flags);
>  		break;
>  	case BM_CMD_REMOVE:
> -		inode = d_inode(inode->i_sb->s_root);
> -		inode_lock_nested(inode, I_MUTEX_PARENT);
> -
> -		/*
> -		 * In order to add new element or remove elements from the list
> -		 * via bm_{entry,register,status}_write() inode_lock() on the
> -		 * root inode must be held.
> -		 * The lock is exclusive ensuring that the list can't be
> -		 * modified. Only load_misc_binary() can access the list
> -		 * concurrently and it does so under RCU. So entries_lock only
> -		 * needs to be held when an entry is actually unlinked to
> -		 * serialize against bm_evict_inode() during umount which
> -		 * unlinks without holding inode_lock.
> -		 */
> -		if (!hlist_unhashed(&e->node))
> -			remove_binfmt_handler(i_binfmt_misc(inode), e);
> -
> -		inode_unlock(inode);
> +		bm_remove_entry(e, inode->i_sb);
>  		break;
>  	default:
>  		return res;
> @@ -865,9 +881,6 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
>  {
>  	struct binfmt_misc *misc;
>  	int res = parse_command(buffer, count);
> -	struct hlist_node *next;
> -	struct inode *inode;
> -	struct binfmt_misc_entry *e;
>  
>  	misc = i_binfmt_misc(file_inode(file));
>  	switch (res) {
> @@ -878,24 +891,7 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
>  		WRITE_ONCE(misc->enabled, true);
>  		break;
>  	case BM_CMD_REMOVE:
> -		inode = d_inode(file_inode(file)->i_sb->s_root);
> -		inode_lock_nested(inode, I_MUTEX_PARENT);
> -
> -		/*
> -		 * In order to add new element or remove elements from the list
> -		 * via bm_{entry,register,status}_write() inode_lock() on the
> -		 * root inode must be held.
> -		 * The lock is exclusive ensuring that the list can't be
> -		 * modified. Only load_misc_binary() can access the list
> -		 * concurrently and it does so under RCU. So entries_lock only
> -		 * needs to be held when an entry is actually unlinked to
> -		 * serialize against bm_evict_inode() during umount which
> -		 * unlinks without holding inode_lock.
> -		 */
> -		hlist_for_each_entry_safe(e, next, &misc->entries, node)
> -			remove_binfmt_handler(misc, e);
> -
> -		inode_unlock(inode);
> +		bm_remove_all_entries(misc, file_inode(file)->i_sb);
>  		break;
>  	default:
>  		return res;
> 
> -- 
> 2.53.0
> 

