Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B346E606A334
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=KPH4ZA4O;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=nAwA4w5o;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=KPH4ZA4O;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=nAwA4w5o
Received: by kanga.kvack.org (Postfix)
	id D2EE06B05B7; Tue, 10 Nov 2026 09:41:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D06C76B05B8; Tue, 10 Nov 2026 09:41:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6A56B05BB; Tue, 10 Nov 2026 09:41:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 996966B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:41:57 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48FD014089C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:41:56 +0000 (UTC)
X-FDA: 85419473832.01.873795B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 24C291A000E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:41:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KPH4ZA4O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nAwA4w5o;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KPH4ZA4O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nAwA4w5o;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794321714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qDtnp52mCOLGIeKAoTkP/VE9bDmOCKAJNKVe/si6vCg=;
	b=QU/GzjNzu7Akcv7hJu4kt4L0jA1cW4VHIV5Wq5fkBkbDS6FijCWVjAvbDlL5BgYGXUahZW
	84iU0VEGF3FT3ZGO8tlFzOmRscTnDr6fCML0UsZKzPVU0EeSMFUhDzUOazEs2pJbIwey6D
	+KSZhcJBon+WYQwFyhXfAQ6NYn0jxAU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794321714;
	b=pVAGKXuWPa/x54YUYOEEJZJ2BgIE/4PHuaxykr2U/qKK62BEAfoLS2afJurWzi16m7QVRB
	S7hogeOlpVxZhOGWgmZZE86URZCz7y0U4wNbGP1k+As6fX4zBr2egyQm1txpu2utfHoN/X
	WCAktCT0JHbZymKf1cDtfcxswrA0Fdk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KPH4ZA4O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nAwA4w5o;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KPH4ZA4O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nAwA4w5o;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1F9C621EF0;
	Tue, 10 Nov 2026 14:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794321713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qDtnp52mCOLGIeKAoTkP/VE9bDmOCKAJNKVe/si6vCg=;
	b=KPH4ZA4OCUNQteAlThJVSMdVv+b5CITqUYVDYv0DTYGBh3lYfp14gNkrIBhN3QW8TrZ5Zu
	8cw3fegXEqyg//sIFlGsygW3ZNppe5S6nwsQ0jNmzUxBYyv0WNVveJumfvFkFKzmvKemzb
	QpaqM/pVXZxp2ljdJnBPVJc1vEVX1cQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794321713;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qDtnp52mCOLGIeKAoTkP/VE9bDmOCKAJNKVe/si6vCg=;
	b=nAwA4w5op91jEWjfS+enW+W0YGrrCz6iJT8kEaFIkP6kTQL1V7Xx/i770Qaf/dBHb75kNs
	cnRMKm7wWkaGMFCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794321713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qDtnp52mCOLGIeKAoTkP/VE9bDmOCKAJNKVe/si6vCg=;
	b=KPH4ZA4OCUNQteAlThJVSMdVv+b5CITqUYVDYv0DTYGBh3lYfp14gNkrIBhN3QW8TrZ5Zu
	8cw3fegXEqyg//sIFlGsygW3ZNppe5S6nwsQ0jNmzUxBYyv0WNVveJumfvFkFKzmvKemzb
	QpaqM/pVXZxp2ljdJnBPVJc1vEVX1cQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794321713;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qDtnp52mCOLGIeKAoTkP/VE9bDmOCKAJNKVe/si6vCg=;
	b=nAwA4w5op91jEWjfS+enW+W0YGrrCz6iJT8kEaFIkP6kTQL1V7Xx/i770Qaf/dBHb75kNs
	cnRMKm7wWkaGMFCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EE948134F4;
	Tue, 10 Nov 2026 14:41:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jkRDMDAt82pyMgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 14:41:52 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 80FD72254E; Tue, 10 Nov 2026 15:41:48 +0100 (CET)
Date: Tue, 10 Nov 2026 15:41:48 +0100
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
Subject: Re: [PATCH v2 36/51] proc: don't let NOMMU map procfs files
Message-ID: <shez4l3sx2gonaj5peho6rtfckgiqom7cennfitxv34oceq4qf@csr6sjmey2yy>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
 <20261104-work-procfs-bugfixes-v2-36-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104-work-procfs-bugfixes-v2-36-bbf7d5546809@kernel.org>
X-Spam-Level: 
X-Spam-Score: -11.30
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 24C291A000E
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: 36w1zk3i9ntxcmzw3hdxisfjwucd87qg
X-Rspam-User: 
X-HE-Tag: 1794321714-150270
X-HE-Meta: U2FsdGVkX18BGIR2+cYsze8Z4K5+AC8NZ8kFQOg64yo85ZN4ZoAr5spFyLobjMqjJGOATGsnUJclQOIrcIH0J6bR1is5yD3pVo1H4UZF6tatyQcPYUqo18vEaOBrMUFzNtAKtJ+Q86TtTxjo7Ta4/qWd5hQeG+oa8bI/r5aXvRycYJvuSOolxEC0iP+rEHwhaIbcRFwI0sDbGIx1my8Ay6mM2+kYo34Ln5jonBlAhR66Ug+uk23FZasK/DY9R2rbefaKWYPAkVI2jhdACvo/yLB6ZERRE6+aNWQtuM/i91WEqzF6wKU1e/+MEfVCRmGL3O2sKHT/d33k4TY/yzTq+e4YQ5lbh+m230oBi5Q3t924JpzU3m9QTPZSYp/nJpJ+uXzrwY+WDzhRFXkmi5FSfvaYjKTif+JquNdJV0jItmIVsWoqpDoSA8Tns+PirTyvuNqDTeqEFNSeCOWEb3/Gxll1TjK8VryURRwraUopzVWZb2XtGqd2Z3mjHpo98f7jlqESzSmkRo7wUbEXrNE+ZvwN0m7LQNldmslFOgmuzhzwyNUmjeoddFPm4qYHT+n5SCLL8qWRRGoXZMTwV87khHen8s9OQELMKuF816bNrDwkomgOuXn/yp9ZVOlKXTn7GzqrGbDwek8qxaHXkgL/XPFjRG68kGThJexaNVjWbtIomDcej7ETOfQ9zJ62zJb1qekSAREpPaL5xPpWWjaZ57rHOa5TCwkO6V2CbumKMXqWR0iEAxxApHfiZoCyM6evdZ+193Tn/OGyLygoxmLOjghw+Xe98BPkDYkMz+DHJfXdM3p8P5BqxfvWIzdUI3d75Wz9g3E98fxvAKZGd8/9SOfjJjdg1YSR28uY+dDienir46GaFJQoM+AwgA9K6/MaHYDs0Hs/7NUPeSy7GS3PxqV720w44kFPnsXLlrrKoVVX7u6lf1Iav3xkelAO80aKFSOKl817Zv440mw/ldX
 oF1FiJOP
 qZuKXYLenW99UFomrDh4CKZHk3huVyxMsB6XtDrTUL3+AAFauX4m8qgrlAYMiJijXKrPjxG7M2qJrXJgVF8N1aNan9guzRtSMxcyyAAZAjhFhE+o+0jOhVC3JjqCiLlo6vSlE5kCJvap+snC98aFYjdx9lxBdOm3ffmlr6mok5PV3PLRqEylN7g9scmycDnSbj88wSs5i9Zy+p2G2wgbjMe6Ztxgt88EL9N3zh5l1WwBt4D4H5pAglbh9giEhQj/DlfQqeLswqYVJEBvfQxBRxrDtzs4LtYa2TGy0Uf8aibTUjrZlFRCg2xwK4ZMy1pAmlOLkNnfjIGl/4T2AQaW51hdvWwh0M7BQm4ow5fhmq2ueDB0INkBP0sZXyOkIFZLfjNnNaT3oCkpFHq7iHpVdX+/Pcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 04-11-26 18:47:22, Christian Brauner wrote:
> Every procfs file has a ->mmap since commit 786d7e1612f0 ("Fix
> rmmod/read/write races in /proc entries"), whether the entry has a
> ->proc_mmap or not. On NOMMU validate_mmap_request() takes that to mean
> the file can be mapped. procfs has no ->mmap_capabilities so a regular
> file gets NOMMU_MAP_COPY, and a private mapping never calls ->mmap at
> all. Instead do_mmap() takes nommu_region_sem for writing and
> do_mmap_private() reads the file into the copy with kernel_read().
> 
> Reading /proc/maps takes nommu_region_sem as well:
> 
>   mmap(NULL, 4096, PROT_READ, MAP_PRIVATE, open("/proc/maps", O_RDONLY), 0)
> 
>   do_mmap()                          // down_write(&nommu_region_sem)
>   -> do_mmap_private()
>      -> kernel_read()
>         -> seq_read_iter()
>            -> nommu_region_list_start()   // down_read()
> 
> The task hangs for good, holding nommu_region_sem and its own mmap_lock,
> and every mmap(), munmap() and exit after that hangs behind it.
> /proc/maps is 0444 so any user can do that.
> 
> Give the procfs files a ->mmap_capabilities on NOMMU that allows
> nothing. That covers every entry and not just /proc/maps, procfs can't
> know which entry's read takes nommu_region_sem. Mapping a procfs file
> then fails with -ENODEV, like mapping a file without ->mmap did before
> 786d7e1612f0. NOMMU never called ->proc_mmap() for a regular file
> anyway, procfs never offered NOMMU_MAP_DIRECT.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 786d7e1612f0 ("Fix rmmod/read/write races in /proc entries")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/inode.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index b7634f975d98..9933f03ab9fb 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -466,6 +466,18 @@ proc_reg_get_unmapped_area(struct file *file, unsigned long orig_addr,
>  	return rv;
>  }
>  
> +#ifndef CONFIG_MMU
> +/*
> + * NOMMU never calls ->proc_mmap() for a regular file. It reads the file into
> + * a private copy instead, with nommu_region_sem held for writing, which
> + * reading /proc/maps takes as well. Don't map procfs files at all.
> + */
> +static unsigned int proc_reg_mmap_capabilities(struct file *file)
> +{
> +	return 0;
> +}
> +#endif
> +
>  static int proc_reg_open(struct inode *inode, struct file *file)
>  {
>  	struct proc_dir_entry *pde = PDE(inode);
> @@ -559,6 +571,9 @@ static const struct file_operations proc_reg_file_ops = {
>  	.unlocked_ioctl	= proc_reg_unlocked_ioctl,
>  	.mmap		= proc_reg_mmap,
>  	.get_unmapped_area = proc_reg_get_unmapped_area,
> +#ifndef CONFIG_MMU
> +	.mmap_capabilities = proc_reg_mmap_capabilities,
> +#endif
>  	.open		= proc_reg_open,
>  	.release	= proc_reg_release,
>  };
> @@ -572,6 +587,9 @@ static const struct file_operations proc_iter_file_ops = {
>  	.unlocked_ioctl	= proc_reg_unlocked_ioctl,
>  	.mmap		= proc_reg_mmap,
>  	.get_unmapped_area = proc_reg_get_unmapped_area,
> +#ifndef CONFIG_MMU
> +	.mmap_capabilities = proc_reg_mmap_capabilities,
> +#endif
>  	.open		= proc_reg_open,
>  	.release	= proc_reg_release,
>  };
> @@ -586,6 +604,9 @@ static const struct file_operations proc_reg_file_ops_compat = {
>  	.compat_ioctl	= proc_reg_compat_ioctl,
>  	.mmap		= proc_reg_mmap,
>  	.get_unmapped_area = proc_reg_get_unmapped_area,
> +#ifndef CONFIG_MMU
> +	.mmap_capabilities = proc_reg_mmap_capabilities,
> +#endif
>  	.open		= proc_reg_open,
>  	.release	= proc_reg_release,
>  };
> @@ -600,6 +621,9 @@ static const struct file_operations proc_iter_file_ops_compat = {
>  	.compat_ioctl	= proc_reg_compat_ioctl,
>  	.mmap		= proc_reg_mmap,
>  	.get_unmapped_area = proc_reg_get_unmapped_area,
> +#ifndef CONFIG_MMU
> +	.mmap_capabilities = proc_reg_mmap_capabilities,
> +#endif
>  	.open		= proc_reg_open,
>  	.release	= proc_reg_release,
>  };
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

