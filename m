Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BBD4606A333
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=duEJD6LP;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=nEuQ44sk;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=muH5tH8X;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Twh/XSEi
Received: by kanga.kvack.org (Postfix)
	id 391A66B05BE; Thu,  5 Nov 2026 07:08:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3418E6B05BF; Thu,  5 Nov 2026 07:08:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 209FF6B05C0; Thu,  5 Nov 2026 07:08:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E82B16B05BE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:08:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8DD89409A9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:08:23 +0000 (UTC)
X-FDA: 85400942886.19.CC86523
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 515EBA000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:08:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=duEJD6LP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nEuQ44sk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=muH5tH8X;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Twh/XSEi";
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793880501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+AscXsLOMvfsFvCViguJi+L1fCFKAfWK/UhUpwog254=;
	b=QQrGbjDe6cS4wN+O7W1/tsXHdHPhOYHAddTP5teEdK4f7Y+YkleNfHmaloVmkyOtd3/0L2
	VnCreKORJvcXkRRMcKfzTFKbyHfrB7J/bgfD+f3ZBw65hCS8ekwQfLsiSy08m29bc0Kqaj
	OYeI0DHls3dPMWlHk1sGqpaVtAYPeTw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793880501;
	b=AwfGOC/6RkIsQHAp9mZF6LUUvBj3szzIlLWbhluSr5Ijlj+YHOQibryEEA1i5JSKkVo6Xm
	OpoA3FmK3H+HqF4o0cr+vn3HaWELHFp4LFauOKh5akDbRmYTMO49Upb5j/xBSFSIE0j2rf
	z9gb0DIRT4HUdIWvdYgS6+HCOjObHRU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=duEJD6LP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nEuQ44sk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=muH5tH8X;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Twh/XSEi";
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E09301F7A8;
	Thu,  5 Nov 2026 12:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793880500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+AscXsLOMvfsFvCViguJi+L1fCFKAfWK/UhUpwog254=;
	b=duEJD6LPekOEhn61R53kKb81GPHaXPGJIngKUTQX9WEfL8ykFAMPfmr3OERdgYmnfr5bEr
	no/QUoCTwr2IM6pfVyWZvbGB+kH7jg6VMI0t/BL5piRkhHqFijSOo3qTB/uJ7xYzQrEyBs
	gOFq7XIKvrhTvOnsUSKrNoDYiDAIbok=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793880500;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+AscXsLOMvfsFvCViguJi+L1fCFKAfWK/UhUpwog254=;
	b=nEuQ44skKENyJxG2nI0WEya/Z6UeAf8j7o1gUA14jvXxD5ttTBDmJR+hSpD3AjkE27erIs
	22RVTyoAXPvvBVDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793880499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+AscXsLOMvfsFvCViguJi+L1fCFKAfWK/UhUpwog254=;
	b=muH5tH8XGabU7XsT+4HLUn0YWyclJMbdrP8YC6jbblzcOUCNg6bIn+AZUHE8jVHVN8jliF
	hdBtv4Gwr4LOd7CEkfIcFH+Z/XWj4sxlIWVLYY8yjERT78lqpfyk0ziLE47S7PXtNzHXyJ
	8uq8NljKVjD/sxwntTPUE8trLhX/m8Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793880499;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+AscXsLOMvfsFvCViguJi+L1fCFKAfWK/UhUpwog254=;
	b=Twh/XSEinlJ2UHBYu888sP3yxbsAvwQL1/rVLh+t/1fyMiI6SbhSYK2ev17aVQ6HLXKdNo
	dDP1A3DjZ6h02FAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC4C6134F4;
	Thu,  5 Nov 2026 12:08:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LbztIbNx7GrJEgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 12:08:19 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 3E083B6CC; Thu, 05 Nov 2026 13:08:15 +0100 (CET)
Date: Thu, 5 Nov 2026 13:08:15 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-acpi@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	netdev@vger.kernel.org, ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
	coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
	sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org, 
	Chuck Lever <cel@kernel.org>
Subject: Re: [PATCH RFC 21/38] proc: let proc_remove() remove the entry it
 was given
Message-ID: <4woxjrofo67qve236jz54znbp74hk34ouesbpgh46g5lfb7bwn@v7dnw5ixlgff>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-21-59422ed3e465@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-work-procfs-bugfixes-v1-21-59422ed3e465@kernel.org>
X-Spam-Score: -11.30
X-Spam-Level: 
X-Stat-Signature: 4zokf44aitichbcns1kp3dyzirz4b445
X-Rspamd-Queue-Id: 515EBA000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793880501-19382
X-HE-Meta: U2FsdGVkX19ESIrTxMctFYJ/HYgUlDW+lNbfmg9FpLMV6mY982ND71ZkxsKOvXt86eu7UFx14Ux/i8i+Fm6qpcvLvHQXwXE8n4a019HddsTU/7DfNPZdC+VH+eOJAWHf0eUu2wi22I0ur1tZK2Lg9FIkOYZhOxc2RjoRtG6rz9Tcn1VhsyjoXrJEATYO30tSHSpNqj4UzRbXVypquQL8VZ/9S2l7s9sh4Fti3UMyWD3BrOJyEEgVZ6AfX2icuq7a8wJxQcDRNUw7wfUSTj3m1C/X7pPhdwcSgshIsn+kyHZnS51vGEnVjGadg6mRiwyLYGPnVC+xkD7ji5Kju/HBPQR3bN1Hpn05B7iBnogRsT5FRWoHnmijdpd9xMvlnVozBBh9E9yjg0iGDOQWoFTEXrxFy7yHxIIF+dfxMI+IsVVXdwiXRu1bZn05Sup9PyOZdojkj1U/hu2UXH7rJw1hf1Yr9Ts9QZU0GYq2agQSIyNr3BO0pK/ecGPcTSHBIYlf+FoSc0uFJebQkcmygQlw+y0v1DLiqFIQ6Fk+/0SiyCVmxev7YTJgVH0iMRvNNn3C2W02jf06QUdetKhV5KZ+qJAhdPyj50qUaXU9VdugKmOoro8kq5kdkY5qWPaxAHcJKBvEhht/BtDkyNNUyvpLQv4piJF64Rc/iAVuYH9cifnJqGu41BAinaztDyxZMAMnvK9vOEV+EvDJhddF6wMe+EbS70POTEuqQanMhasorkhVM0fj4Pg2fRsMVsZ2MkJbJr2q8uxopqAyKW37/NZJoPHdOfNjfGvezEhARs7SRVJeLudpZ/psOW1fMwseCcNKhxrRHXRCEM4NByqBo48cc9TGPsvgBky1cCgNl3pY7Wq3oYsYdC9+dbDfuKJekc2fFLO0q3zvw1CF6pvTBmq+ypcbJY1NzmCXr79boNe06jlhqYtG5v/LOk8E/qMmfhYrZBBHzZ6z7oixtPoSSIa
 5GvSjVr/
 qXEhcTwhnju2yaZXIBpk5LC7t5JfyKJfOCRfA6KFYjqF/ctMdpJYK3PgrMaFcwT8BbFAB5Q41Q3LHMm6+P4cYPy9P8hJch+bu1/+dsW2bhgqNn9+EAPKPOHQfuda2dDHT0zviIVP9PFwGXK3d+tcskgKm5MX6oSK8VbGhTZmPemzBS4vg1vfQhBCyT9El3T3dp7TEovJNJYyh4/hUuI9K92I7v1lWIb5JkBhf2fNV4aSihOisapV/9b27hVMrY8pLWVvixheyrgqmJiu0DiKoum9CrznNt4xpTdk4w5HUepWj3l1KOsUukVvsOx7JlXOYOzaSxTQRV1GUFz20a+VelLJKIiGaaidf5F6LQti3CvHwBjn9NWvk8GvffCJ0d5G+RgrUbEYJoozAYQXl0+zHog3nnDmFCysqcFpG5QsNkat7A9dyobF85voe6qZMfSQiA3ZOMSxhr1DahrI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 02-11-26 15:21:36, Christian Brauner wrote:
> proc_remove() looks the entry up by its name in its parent and removes
> whatever it finds there:
> 
>   remove_proc_subtree(de->name, de->parent);
> 
> If the entry was removed already, say along with its parent, that is
> either nothing or a different entry that got the same name in the
> meantime, and de->parent may well be gone. Two removals of the same
> entry are a bug in the caller, but going by the name turns it into
> removing an entry that belongs to somebody else.
> 
> Since commit 895b4c0c79b0 ("fs/proc: fix uaf in proc_readdir_de()")
> an entry that was unlinked has an empty rb node. So check for that
> under proc_subdir_lock and otherwise remove the entry itself, with the
> loop of remove_proc_subtree() moved into a helper both of them use.
> Nothing can help a caller that passes an entry that has been freed
> already.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: a8ca16ea7b0a ("proc: Supply a function to remove a proc entry by PDE")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

One nitpick below. Otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> -int remove_proc_subtree(const char *name, struct proc_dir_entry *parent)
> +/*
> + * Remove @root, already erased from its parent, and everything below it.
> + * Called with proc_subdir_lock held for writing, returns with it dropped.
> + */
> +static int __remove_proc_subtree(struct proc_dir_entry *root)
>  {
> -	struct proc_dir_entry *root = NULL, *de, *next;
> -	const char *fn = name;
> -	unsigned int len;
> -
> -	write_lock(&proc_subdir_lock);
> -	if (__xlate_proc_name(name, &parent, &fn) != 0) {
> -		write_unlock(&proc_subdir_lock);
> -		return -ENOENT;
> -	}
> -	len = strlen(fn);
> +	struct proc_dir_entry *de = root, *next;
>  
> -	root = pde_subdir_find(parent, fn, len);
> -	if (!root) {
> -		write_unlock(&proc_subdir_lock);
> -		return -ENOENT;
> -	}
> -	if (unlikely(pde_is_permanent(root))) {
> -		write_unlock(&proc_subdir_lock);
> -		WARN(1, "removing permanent /proc entry '%s/%s'",
> -			root->parent->name, root->name);
> -		return -EINVAL;
> -	}
> -	pde_erase(root, parent);
> -
> -	de = root;
>  	while (1) {
>  		next = pde_subdir_first(de);
>  		if (next) {
> @@ -871,6 +852,34 @@ int remove_proc_subtree(const char *name, struct proc_dir_entry *parent)
>  	pde_put(root);
>  	return 0;
>  }
> +
> +int remove_proc_subtree(const char *name, struct proc_dir_entry *parent)
> +{
> +	struct proc_dir_entry *root = NULL;
> +	const char *fn = name;
> +	unsigned int len;
> +
> +	write_lock(&proc_subdir_lock);
> +	if (__xlate_proc_name(name, &parent, &fn) != 0) {
> +		write_unlock(&proc_subdir_lock);
> +		return -ENOENT;
> +	}
> +	len = strlen(fn);
> +
> +	root = pde_subdir_find(parent, fn, len);
> +	if (!root) {
> +		write_unlock(&proc_subdir_lock);
> +		return -ENOENT;
> +	}
> +	if (unlikely(pde_is_permanent(root))) {
> +		write_unlock(&proc_subdir_lock);
> +		WARN(1, "removing permanent /proc entry '%s/%s'",
> +			root->parent->name, root->name);
> +		return -EINVAL;
> +	}
> +	pde_erase(root, parent);
> +	return __remove_proc_subtree(root);
> +}
>  EXPORT_SYMBOL(remove_proc_subtree);
>  
>  void *proc_get_parent_data(const struct inode *inode)
> @@ -882,8 +891,23 @@ EXPORT_SYMBOL_GPL(proc_get_parent_data);
>  
>  void proc_remove(struct proc_dir_entry *de)
>  {
> -	if (de)
> -		remove_proc_subtree(de->name, de->parent);
> +	if (!de)
> +		return;
> +
> +	write_lock(&proc_subdir_lock);
> +	/* Removed already, maybe along with its parent. */
> +	if (RB_EMPTY_NODE(&de->subdir_node)) {
> +		write_unlock(&proc_subdir_lock);
> +		return;
> +	}
> +	if (unlikely(pde_is_permanent(de))) {
> +		write_unlock(&proc_subdir_lock);
> +		WARN(1, "removing permanent /proc entry '%s/%s'",
> +		     de->parent->name, de->name);
> +		return;
> +	}
> +	pde_erase(de, de->parent);
> +	__remove_proc_subtree(de);

I'd move the RB_EMPTY_NODE() and pde_is_permanent() along with pde_erase()
call back to __remove_proc_subtree(). Both callers need them (so it is
unnecessary duplication) and also logically it makes sense there.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

