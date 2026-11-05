Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D44A2606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=b/7E7q75;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JDx0i97w;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=mLWeeCDw;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YxG1QDwo
Received: by kanga.kvack.org (Postfix)
	id D48B56B05B1; Thu,  5 Nov 2026 07:00:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20666B05B5; Thu,  5 Nov 2026 07:00:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0F506B05BA; Thu,  5 Nov 2026 07:00:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 964B06B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:00:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 06F44A09E1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:00:07 +0000 (UTC)
X-FDA: 85400922054.23.65C9230
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 776C51C0009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:00:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="b/7E7q75";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JDx0i97w;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mLWeeCDw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YxG1QDwo;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793880005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLYMptSjatVyJOFwpffoaDfgZgE6X8q+QC3Cbs2KtOY=;
	b=s2tVfwCZD0c/wIM4feF1Zz299jvzqEK4EOavGdEQbJBnXqAbHNMwwIYpxBGCxXhVIAJ0kI
	UrhbVax72HRxmRUxY9H/zM8fPsBaBW6Z7pFbJHuOiIw1BYFvlXuWFjAOXbGiCLkZ5OHTTi
	kfWHUDF4CNjF24OQC0nFXH3rVXmX1c8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="b/7E7q75";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JDx0i97w;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mLWeeCDw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YxG1QDwo;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793880005;
	b=OOP+hxLxuU2Vb2eaRum8ETo+oCaK1h18+XtWKP1AYon9/J8V4jjDFwQYnSWt0dbH4MhblU
	DX5QPH30uBG4OEkJ9EsS9SeFrB9Le1ZYsyyQS0p6vBvlMB5nlLndbSDoI+fRiEzlBxtQL2
	b14jxgK+fXxKbuTuFUKKRYdiU5n9mPU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CEEAB1F7B2;
	Thu,  5 Nov 2026 12:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793880003; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TLYMptSjatVyJOFwpffoaDfgZgE6X8q+QC3Cbs2KtOY=;
	b=b/7E7q75Fkdxb52orAjoZbXYQBUbdEfyIMUY5KYffgKEl3SftOuIqEV8ngx1yDWZRjk/n6
	bcW4DaJ+DJesYwhmHDJbQueDDkhKwHtvMyv9aSpA8Lt7ya2pChK0qgY6QYS9CmmsvHkOK4
	jJMMwvDu0gzY3VPTrkiWBbndK9Cj4r4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793880003;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TLYMptSjatVyJOFwpffoaDfgZgE6X8q+QC3Cbs2KtOY=;
	b=JDx0i97wJKHZd4UujUUGy+r5V+7SwHGCXiipankywlJ5hQsT+6s3w7Jw6t2VazsdfK8AY1
	WJHbAEOlSA/0TuDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793880002; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TLYMptSjatVyJOFwpffoaDfgZgE6X8q+QC3Cbs2KtOY=;
	b=mLWeeCDwnpy+InK0QiCjbUloTdC5Bagr6GdPyphx3JUr8rlWUYWJkI/cC0MEcY5KnRLE2w
	ykIsFJgnU9zcIFKkxQCdM6r225n55SXevDgdB0DuPBW9+ukMWc8uZJergg7m/QeOydCzfG
	viFSPByPoS3DjY/DTtU5THJ0Xft//ZM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793880002;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TLYMptSjatVyJOFwpffoaDfgZgE6X8q+QC3Cbs2KtOY=;
	b=YxG1QDwoZ8i/+DzPhl0+xb1FjsPH7mvqx5iQvvwKiJfg63fv9j9GedLc1cASyxe5ud4weM
	kBw8lHrcxyMNjRDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 90808134F4;
	Thu,  5 Nov 2026 12:00:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HqVvG8Jv7GpGCgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 12:00:02 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 74E5BB6C3; Thu, 05 Nov 2026 13:00:01 +0100 (CET)
Date: Thu, 5 Nov 2026 13:00:01 +0100
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
	Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH RFC 19/38] proc: resume readdir after the last name it
 returned
Message-ID: <2pfmlrmhrjuos74lnsdr3ctjndj7vahxedhmsdla75ggblj43g@ttj5yg5f5p7l>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-19-59422ed3e465@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-work-procfs-bugfixes-v1-19-59422ed3e465@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 776C51C0009
X-Stat-Signature: deacp1q55hcwpxys9bu4d9ciq19rt7ay
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793880004-114645
X-HE-Meta: U2FsdGVkX19t4UoXArBsoUML2ffyQUL/1muEpTTsaOK2fOUbTrZyX++Sa6qLFsA/vra+QkNOC9Ftg5jv3yBhwAwpabEOAS9o20hqN3mu9HvNmqb9TEusU1oM0PVqzcHHzkNmiXHpH/0ThIRIC+xl9x8CSQLS4YCyDMDFW0UfxdQg9twC2oIED/pV3gMM1XSdHPslmFSUyxUAuSJA2od4Gz5mrYue0Vzh80a2KR74EX7UmZCTv+79TGWnHX0/sdiHeNa6iqF0KzkNO1AkRyDZOMoOJEfE5L/I0tc35mkrT2oF6vEwcpSL8FtZ2s0iwwVK+z9aLse90RI0whEu7cIkMnXiawWs3vNyqjVXBOPUgCBtC3Uid2OlzpC3Awes+Rynds4nJYLubKgDD2y4UBAkafVeU2kCFw6Q9OpBRwKU5DQjsaeERka/WPulH/Fmnb2P9v3q+z4c+vUW8Uq82kYqZVE2UfJKhYZ7WE4iWM+py/95ITOWqgE7VzNtG6BfDW14W1sFqQqlNTHsiVfvtQJAE0F2VbkdjqHoZVxg0QWsvF6SXi6WLYyPo3jy+bjdokL8Wai/uqrVKNp/7Kj54QJDpM+hE63ZAoCQYSxX+Fad//NQGvRK4GVCe1WfW37480KoGgVRANOGnXMDFYX/W4tO413UNkqyV4bQIiNZ58EnRTuAyQHZWBoz44HrUec6NkiMSpNrL7eLwZxibvzAmmUkSVncsk4rJ5jPLIf500VRK+JgZ97yvW2q7zDgogtou0ZqohAi/ivfqazAMUnDfv5DvQnBuUJTqp0An1Y1rVZhVHjFxuIlrNW4L25yYJYBLwP/ma/Fv3wO3lXYxljhAZl2PuYFaQVqC6h6QsoOh/RGfPQIq7lQ5NN48JR8Hy5e+ma7dUoshaQEM77ec77DY759B73CeD1LoGZtISpmESzIDNDZtKBjxElOZ/cp/1Ww+rQBCjUPWmh4YkeYEsj37Ys
 /dxaJ6+w
 KqK/F21sclEmDM+EihHNnRkcbJGzhH5sZi16voTwuOny0DXN3FyLlkCFH1JHEOzAxpT4hrKqFC2eCfNYYbslh/whFM+9t2332QN4hvkQOAsvZpQ2EMsgdjTS5gLMRiJt0CwXhRhDNSrBaB/3G3YYJHyF/6pG5Sv8FmaTJHub7tI9p1Z2sLth5tYEXNBoOi+mddDqlIUmht2AHmtNfUXlfT7aITKWv4JMC5VY0gk4LK/MhGQLEi/Ix7Bl0UQJMvjs8hSwfiB5R7zqwGmdT1S75wCBPD31LbZtIJes5iEznOH9Qtd4/viUowUmM5QSbkA2glw/xXLK9oWMElYrgkyB6eoVd5MvAKbca6pYXk6cfBO5b577+QCfTfx4VEpbqQPrl6QCcc65y4wyYffN0DoeaNS4tiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 02-11-26 15:21:34, Christian Brauner wrote:
> proc_readdir_de() counts the entries of a directory and resumes a
> listing at the number getdents64() stopped at. The entries are sorted
> by name, so one that is added or removed in between shifts everything
> behind it by one. Listing /proc/net/dev_snmp6 with a buffer that holds
> ".", ".." and "lo" and adding a device whose name sorts before "lo"
> makes the next call return "lo" a second time. Removing one that sorted
> before the position makes the next call skip an entry instead.
> 
> Since commit 895b4c0c79b0 ("fs/proc: fix uaf in proc_readdir_de()") an
> entry that is removed while it is being emitted also ends the listing
> right there. pde_subdir_next() finds nothing after an erased entry, so
> proc_readdir_de() reports the end of the directory and the next call
> resumes by number, skipping another entry. For /proc itself
> proc_root_readdir() takes that as the end of the static entries and
> moves on to the pids, so the rest of the static entries is missing.
> And if the position is behind the last entry when a call starts
> proc_readdir_de() returns 0, so /proc then lists no pids at all.
> 
> So remember the name of the last entry a call emitted in the file and
> resume at the first entry after it, like kernfs resumes after the node
> it stopped at. An entry that was removed while it was emitted is
> continued after by its name as well. If the position was moved by a
> seek in between the listing counts from the start like before.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Fixes: 895b4c0c79b0 ("fs/proc: fix uaf in proc_readdir_de()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/generic.c  | 89 ++++++++++++++++++++++++++++++++++++++++++++++--------
>  fs/proc/internal.h |  1 +
>  fs/proc/proc_net.c |  1 +
>  fs/proc/root.c     |  1 +
>  4 files changed, 80 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index ef804cd3ec45..47830d6af255 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -87,6 +87,28 @@ static struct proc_dir_entry *pde_subdir_find(struct proc_dir_entry *dir,
>  	return NULL;
>  }
>  
> +/* The first entry of @dir that sorts after @name. */
> +static struct proc_dir_entry *pde_subdir_after(struct proc_dir_entry *dir,
> +					       const char *name,
> +					       unsigned int len)
> +{
> +	struct rb_node *node = dir->subdir.rb_node, *after = NULL;
> +
> +	while (node) {
> +		struct proc_dir_entry *de = rb_entry(node,
> +						     struct proc_dir_entry,
> +						     subdir_node);
> +
> +		if (proc_match(name, de, len) < 0) {
> +			after = node;
> +			node = node->rb_left;
> +		} else {
> +			node = node->rb_right;
> +		}
> +	}
> +	return rb_entry_safe(after, struct proc_dir_entry, subdir_node);
> +}
> +
>  static bool pde_subdir_insert(struct proc_dir_entry *dir,
>  			      struct proc_dir_entry *de)
>  {
> @@ -277,6 +299,40 @@ struct dentry *proc_lookup(struct inode *dir, struct dentry *dentry,
>  	return proc_lookup_de(dir, dentry, PDE(dir));
>  }
>  
> +/*
> + * Where the next readdir resumes. The entries are counted, so one that is
> + * added or removed in front of the position would shift what the next call
> + * returns. The name of the last entry emitted doesn't move.
> + */
> +struct proc_dir_cursor {
> +	loff_t pos;			/* the position behind the entry */
> +	unsigned int len;
> +	char name[NAME_MAX + 1];
> +};
> +
> +/* If this can't remember the entry the next call counts from the start. */
> +static void proc_dir_cursor_set(struct file *file, struct proc_dir_entry *de,
> +				loff_t pos)
> +{
> +	struct proc_dir_cursor *cursor = file->private_data;
> +
> +	if (!cursor) {
> +		cursor = kmalloc(sizeof(*cursor), GFP_KERNEL);
> +		if (!cursor)
> +			return;
> +		file->private_data = cursor;
> +	}
> +	cursor->pos = pos;
> +	cursor->len = de->namelen;
> +	memcpy(cursor->name, de->name, de->namelen);
> +}
> +
> +int proc_dir_release(struct inode *inode, struct file *file)
> +{
> +	kfree(file->private_data);
> +	return 0;
> +}
> +
>  /*
>   * This returns non-zero if at EOF, so that the /proc
>   * root directory can use this and check if it should
> @@ -289,23 +345,26 @@ struct dentry *proc_lookup(struct inode *dir, struct dentry *dentry,
>  int proc_readdir_de(struct file *file, struct dir_context *ctx,
>  		    struct proc_dir_entry *de)
>  {
> +	struct proc_dir_cursor *cursor = file->private_data;
> +	struct proc_dir_entry *dir = de;
>  	int i;
>  
>  	if (!dir_emit_dots(file, ctx))
>  		return 0;
>  
> -	i = ctx->pos - 2;
>  	read_lock(&proc_subdir_lock);
> -	de = pde_subdir_first(de);
> -	for (;;) {
> -		if (!de) {
> -			read_unlock(&proc_subdir_lock);
> -			return 0;
> -		}
> -		if (!i)
> -			break;
> -		de = pde_subdir_next(de);
> -		i--;
> +	if (cursor && cursor->pos == ctx->pos) {
> +		/* Resume after the last entry emitted, wherever it is now. */
> +		de = pde_subdir_after(dir, cursor->name, cursor->len);
> +	} else {
> +		/* Moved by a seek, count from the start like always. */
> +		de = pde_subdir_first(dir);
> +		for (i = ctx->pos - 2; de && i; i--)
> +			de = pde_subdir_next(de);
> +	}
> +	if (!de) {
> +		read_unlock(&proc_subdir_lock);
> +		return 1;
>  	}
>  
>  	do {
> @@ -318,8 +377,13 @@ int proc_readdir_de(struct file *file, struct dir_context *ctx,
>  			return 0;
>  		}
>  		ctx->pos++;
> +		proc_dir_cursor_set(file, de, ctx->pos);
>  		read_lock(&proc_subdir_lock);
> -		next = pde_subdir_next(de);
> +		/* Removed in the meantime, go on after its name. */
> +		if (RB_EMPTY_NODE(&de->subdir_node))
> +			next = pde_subdir_after(dir, de->name, de->namelen);
> +		else
> +			next = pde_subdir_next(de);
>  		pde_put(de);
>  		de = next;
>  	} while (de);
> @@ -347,6 +411,7 @@ static const struct file_operations proc_dir_operations = {
>  	.llseek			= generic_file_llseek,
>  	.read			= generic_read_dir,
>  	.iterate_shared		= proc_readdir,
> +	.release		= proc_dir_release,
>  };
>  
>  static int proc_net_d_revalidate(struct inode *dir, const struct qstr *name,
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index df873df9afc5..04f7ce2b24ed 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -287,6 +287,7 @@ extern struct dentry *proc_lookup(struct inode *, struct dentry *, unsigned int)
>  struct dentry *proc_lookup_de(struct inode *, struct dentry *, struct proc_dir_entry *);
>  extern int proc_readdir(struct file *, struct dir_context *);
>  int proc_readdir_de(struct file *, struct dir_context *, struct proc_dir_entry *);
> +int proc_dir_release(struct inode *, struct file *);
>  
>  static inline void pde_get(struct proc_dir_entry *pde)
>  {
> diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
> index b1f5eafb069a..dbcf87a257e1 100644
> --- a/fs/proc/proc_net.c
> +++ b/fs/proc/proc_net.c
> @@ -351,6 +351,7 @@ const struct file_operations proc_net_operations = {
>  	.llseek		= generic_file_llseek,
>  	.read		= generic_read_dir,
>  	.iterate_shared	= proc_tgid_net_readdir,
> +	.release	= proc_dir_release,
>  };
>  
>  static __net_init int proc_net_ns_init(struct net *net)
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 7fbbe92bf73a..dfee1caa26f7 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -441,6 +441,7 @@ static const struct file_operations proc_root_operations = {
>  	.read		 = generic_read_dir,
>  	.iterate_shared	 = proc_root_readdir,
>  	.llseek		= generic_file_llseek,
> +	.release	= proc_dir_release,
>  };
>  
>  /*
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

