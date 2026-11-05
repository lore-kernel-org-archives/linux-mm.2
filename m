Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95468606A32E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=x9Zosn4E;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OA7rJSNx;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=x9Zosn4E;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OA7rJSNx
Received: by kanga.kvack.org (Postfix)
	id B9BC56B05B4; Thu,  5 Nov 2026 07:24:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B739F6B05B5; Thu,  5 Nov 2026 07:24:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79606B05B9; Thu,  5 Nov 2026 07:24:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB466B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:24:23 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C8AA809E6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:24:23 +0000 (UTC)
X-FDA: 85400983206.05.5AEC723
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id DC36E100002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:24:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x9Zosn4E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OA7rJSNx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x9Zosn4E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OA7rJSNx;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793881461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qZ2SbYk3GrokaaO0nBX/KKA3dRohO53XWjNLOWBHmzM=;
	b=BYW73j/azXYIlKeZOcdmbjOs+wzLVQ7dX0kV5Kzh5r2MOxZu7+katR3pgizwNDMcJyIyOL
	fRuYhg5S6zZgBhxisNYLEmdUZqEb9aTtybeamRqfAUPiGvekRFOI6XT3P6MX/NzX1CU8Pj
	rNwJ7AtHz++M8T4BbCU0kvtysOAOGVg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x9Zosn4E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OA7rJSNx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x9Zosn4E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OA7rJSNx;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793881461;
	b=SJRT0QiQd2ay+sdnytRddf7bH5AI25Spes9C0MMWxxP2U/ipaAAf50wTszdQ9aoFpYuWOx
	fCHkmyckRKjmBLOglcPI6Qc6W0R5e+zXwx3avJBnP88/LhtqE7JjcQeVT6O+PD5udlaQ+O
	Eq+A9/s5xuqkigmj7quYcHbtRyQdUkI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9F5B121F9C;
	Thu,  5 Nov 2026 12:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793881459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qZ2SbYk3GrokaaO0nBX/KKA3dRohO53XWjNLOWBHmzM=;
	b=x9Zosn4EbchHGeE5udevL1r29rgPf9Y02dysOElisjHj+VO5UilfwMafmPydaCNnTjwNzv
	UF86KGWPiD1Le7Ah5EEn+d+JCboYs72l6yBZbRCo6mTyh4eKiPufQjAAHaHoFJVIZkad7k
	Ds8jF1cavCxTYhTDUloFMVoekboGBwY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793881459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qZ2SbYk3GrokaaO0nBX/KKA3dRohO53XWjNLOWBHmzM=;
	b=OA7rJSNxuyCmeklmiqZ15Mq0PWDdCAvs2gjXUAdfvq+IV2EYP6LI9FD76bFqQPglYJgSmh
	0coVcjc/QUeRzhDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793881459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qZ2SbYk3GrokaaO0nBX/KKA3dRohO53XWjNLOWBHmzM=;
	b=x9Zosn4EbchHGeE5udevL1r29rgPf9Y02dysOElisjHj+VO5UilfwMafmPydaCNnTjwNzv
	UF86KGWPiD1Le7Ah5EEn+d+JCboYs72l6yBZbRCo6mTyh4eKiPufQjAAHaHoFJVIZkad7k
	Ds8jF1cavCxTYhTDUloFMVoekboGBwY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793881459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qZ2SbYk3GrokaaO0nBX/KKA3dRohO53XWjNLOWBHmzM=;
	b=OA7rJSNxuyCmeklmiqZ15Mq0PWDdCAvs2gjXUAdfvq+IV2EYP6LI9FD76bFqQPglYJgSmh
	0coVcjc/QUeRzhDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6CAA4133F6;
	Thu,  5 Nov 2026 12:24:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HDRiEnN17Gp/IwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 12:24:19 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 0060FB6DF; Thu, 05 Nov 2026 13:24:18 +0100 (CET)
Date: Thu, 5 Nov 2026 13:24:18 +0100
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
Subject: Re: [PATCH RFC 34/38] proc: sysctl: look at the table under
 sysctl_lock when creating an inode
Message-ID: <tmxt2djcskr7qa6a2ewpelbhnyxtd4xp6dabc2uq5cdea5xdex@qn7wcwyjf5ah>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-34-59422ed3e465@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-work-procfs-bugfixes-v1-34-59422ed3e465@kernel.org>
X-Spam-Score: -11.30
X-Spam-Level: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DC36E100002
X-Stat-Signature: qu7gtyu676fixgi4ztk9nsp5jpqwdte6
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793881460-125690
X-HE-Meta: U2FsdGVkX1+YxFb9Rl72nGxxa3vDFdJfPvE3IwdDvxyzervGiiv1XHxOAleEHOZOb3cUz8djyTJUrWvzPw576OwdwnsdZ+6FT4qmeT8bSkQq3NzBePB/pip4tDCPPk6GBxVH1Q3OwK/nb3UUT75LAdlTiousHa9/sGwLm9AS1cFFeWf1JMD3ookBLAKCKv//vnOb94hjC0TSE9leCHFWDqxkWaod5ea5oCqZkSIvJnCpgOaOiEan+abWz0y/AIOHExrUTzXITfxPdP6hrgcJoPLiyou79bdIDGbuTo9s/BSchjGMoQBadEWcBIlxP3v7Vfm5cXMhXj9wlE8Qj+25nhAoGWH6uvj4cXOoGX2YIFvGhcW9osJVAwA50dAZQGp9yDNGWVla6EkS3yEZSKIVKjiQc7gSLb8q0AAy6bdWII7yZ0RsqQcmvtZ9JMh12kO92z6oP0uF+qBNzAXRuXocoU8Cz9oOnYx9pUwbWcxcHZdhmMOwJU9Hj0j1Bbo/jsbAD6A1sej7EUHS1xSIB4bNrdTqVORMftFl2D75A+Eo1bob2AOObBGgIkbXvVaWOzGFAS3gHBbMCJnFoeoQQ/EPUJKnv1esOr4US44Z9jxxm1DTqlXDm2PtA4oPv9rsihr8bgsh2Ao1F1EKLXx6vj7jdOI31xYh/frgoSIzjpfxSq5yjMJ2Y5E+aqdLro8dGxmBZPFkQQxNgFTTsaQHFtepMmJrQtbsZdkdm5hM9P2yA8bU78n1hLXWylfcIrCHa7ICogkvhpqNK1trF1lJ69MD1QkkNkQX1Pa4mQ5gBF3lW3o2+PyxXWMJqMbMrAvuqWsyzl1jhYSlZPrnVo4FLyo21Ax7f9YYwYjOTRct15aes1lkv4wErCEwHVKYWfyVpV7RTcWK0nxniBS7V0wl5Cx0Qa6R4ZKfK8Hck3eOI97ChCZhiAh32VtNEKkCAZB2AkvBFbC+odM/XV+hDK9deE9
 ITKeKkmW
 VYQ2QbnywIcjRAdQrfui18CABGdTvCNVNq527p3Xbyk/gl1JnVXldAFwaB0PUCKvKkIZOXgzu7uNp4EysYZqci0r8ZnhWEiw42hB+S1Fd7gK1fjQKtRpOBYvzjUexCdNE7j1bDuQUWxTPyj09E4tn37+vNd0tBF3onIQulDYxHHC6v88GYwr4rwazmfD0M/4ieMHS181C+8GhgWbI7HbHdoXtoqTlZOzCOGwiXoT+T3bYa5CZ6v72rt2ykNk8AuqM+R64MYvG0MWS7ouvVxThuIJNNnb1hPAGsmEk0sZFTkZrUKmeeoH2/Fxwbh/XblsKsJq1Eob7XZoPcoPlG+zG1h4GZuL0s4+nTC/8rKfVNqTC1mzw4BchxA3alEjdMIs/oyHBQK6GdRJsgTi41QOEED1keWkKcSTNr8N38nI4CFoQ80S7OXGeCa2SBmHKog5Nrth/QoL7Zdy3CjBfpsQ2sLixNebx7irhg0ZZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 02-11-26 15:21:49, Christian Brauner wrote:
> proc_sys_make_inode() checks under sysctl_lock that @head isn't being
> unregistered, lets go of the lock, and then reads the mode of @table
> and calls ->set_ownership() with @head. That's fine as long as the
> caller holds @head in use, which keeps unregistering from getting past
> that check. The next patch has a caller that only pins the memory of
> @head. For that one the table, and whatever the owner of the header
> keeps behind it, is only there for as long as nobody unregisters the
> header, which happens under sysctl_lock. So read the mode and set the
> ownership before letting go of the lock. The ->set_ownership()
> callbacks only look up ids in a user namespace.
> 
> No functional changes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/proc_sysctl.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 2150cf842919..a1242247f492 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -500,6 +500,7 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
>  	struct ctl_table_root *root = head->root;
>  	struct inode *inode;
>  	struct proc_inode *ei;
> +	umode_t mode;
>  
>  	inode = new_inode(sb);
>  	if (!inode)
> @@ -509,12 +510,22 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
>  
>  	ei = PROC_I(inode);
>  
> +	inode->i_uid = GLOBAL_ROOT_UID;
> +	inode->i_gid = GLOBAL_ROOT_GID;
>  	spin_lock(&sysctl_lock);
>  	if (unlikely(head->unregistering)) {
>  		spin_unlock(&sysctl_lock);
>  		iput(inode);
>  		return ERR_PTR(-ENOENT);
>  	}
> +	/*
> +	 * The table, and whatever the owner of the header keeps behind it,
> +	 * is only there for as long as nobody unregisters the header, which
> +	 * happens under sysctl_lock. So look at them before letting go of it.
> +	 */
> +	mode = table->mode;
> +	if (root->set_ownership)
> +		root->set_ownership(head, &inode->i_uid, &inode->i_gid);
>  	ei->sysctl = head;
>  	ei->sysctl_entry = table;
>  	hlist_add_head_rcu(&ei->sibling_inodes, &head->inodes);
> @@ -522,8 +533,8 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
>  	spin_unlock(&sysctl_lock);
>  
>  	simple_inode_init_ts(inode);
> -	inode->i_mode = table->mode;
> -	if (!S_ISDIR(table->mode)) {
> +	inode->i_mode = mode;
> +	if (!S_ISDIR(mode)) {
>  		inode->i_mode |= S_IFREG;
>  		inode->i_op = &proc_sys_inode_operations;
>  		inode->i_fop = &proc_sys_file_operations;
> @@ -535,11 +546,6 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
>  			make_empty_dir_inode(inode);
>  	}
>  
> -	inode->i_uid = GLOBAL_ROOT_UID;
> -	inode->i_gid = GLOBAL_ROOT_GID;
> -	if (root->set_ownership)
> -		root->set_ownership(head, &inode->i_uid, &inode->i_gid);
> -
>  	return inode;
>  }
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

