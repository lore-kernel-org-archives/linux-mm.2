Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 565B760A3806
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=MUVsr+ph;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=zZopj+90;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=MUVsr+ph;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=zZopj+90
Received: by kanga.kvack.org (Postfix)
	id 2C8B66B05B2; Tue, 10 Nov 2026 09:38:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F9D6B05B3; Tue, 10 Nov 2026 09:38:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18F006B05B8; Tue, 10 Nov 2026 09:38:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDAB16B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:38:24 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 018D11208DB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:38:23 +0000 (UTC)
X-FDA: 85419464928.03.48651D5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 96E661C000F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:38:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MUVsr+ph;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zZopj+90;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MUVsr+ph;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zZopj+90;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794321502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fh5qOtVM6KsLzFpIRsYYHC+bSYz/O+LnqFiFi3TOwW4=;
	b=w2g9erJcgb7y4GbAiil4AQ4Rd4m82NEb2A0d5XOJ8hlJ8jo0DXffVVVUkMcIjtamsHWGDw
	sI0ZUuPhUw+IgHGQ88jU5J2Dr5HoHt5BkA5nWIQ/NayT7TFJ2M6uQgOuaXxvnGuYYH4ulv
	4s6byg63BntPBg/vIFge6y5Kcg/UKxs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794321502;
	b=so3ytq/SVfcVyT8M7SrYi6XQDHQvQHHjpxVgsF45a5P+PK9KvvYew5vpRp11HFyektnHOt
	o5AkExsYBopNpOvnKP6EOWWFOwhizk8CrQaKMDaNE2FDkmMajmfGw1PsrNBCwTnCFtfsJi
	JOwNPdOiRqFDRUeCdsYLKVshqVc9WuQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MUVsr+ph;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zZopj+90;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MUVsr+ph;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zZopj+90;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6600221E9C;
	Tue, 10 Nov 2026 14:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794321500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fh5qOtVM6KsLzFpIRsYYHC+bSYz/O+LnqFiFi3TOwW4=;
	b=MUVsr+phhfZbFW8xjR4b3N1UtGCeg+l0uYLOI5bLig6ZTedYwIElDXlSxhCLTjeiSHCd6k
	bg+NDUgRn4V4Cz63o4lwC/9gvtBeJXiSrYK+hYpxXqxLvSnhU0GeyZW39zoyzRQ0nyBJQY
	pyMpVSkOGDsd5a+gix4rvbt7CSWAcbw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794321500;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fh5qOtVM6KsLzFpIRsYYHC+bSYz/O+LnqFiFi3TOwW4=;
	b=zZopj+90aGJKBJGWq3ccQNKWjno338Dvu06+ctjiTjzqDLlDaVJHiPN7g0hSfMYZ4HR0wM
	fsnCVhe8MldfL9AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794321500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fh5qOtVM6KsLzFpIRsYYHC+bSYz/O+LnqFiFi3TOwW4=;
	b=MUVsr+phhfZbFW8xjR4b3N1UtGCeg+l0uYLOI5bLig6ZTedYwIElDXlSxhCLTjeiSHCd6k
	bg+NDUgRn4V4Cz63o4lwC/9gvtBeJXiSrYK+hYpxXqxLvSnhU0GeyZW39zoyzRQ0nyBJQY
	pyMpVSkOGDsd5a+gix4rvbt7CSWAcbw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794321500;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fh5qOtVM6KsLzFpIRsYYHC+bSYz/O+LnqFiFi3TOwW4=;
	b=zZopj+90aGJKBJGWq3ccQNKWjno338Dvu06+ctjiTjzqDLlDaVJHiPN7g0hSfMYZ4HR0wM
	fsnCVhe8MldfL9AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A3411339F;
	Tue, 10 Nov 2026 14:38:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w7B7OFss82qaLgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 14:38:20 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 7F6FA22545; Tue, 10 Nov 2026 15:38:15 +0100 (CET)
Date: Tue, 10 Nov 2026 15:38:15 +0100
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
Subject: Re: [PATCH v2 34/51] proc: let proc_remove() remove the entry it was
 given
Message-ID: <gb7ibchjlghrlulokvwae7khr6w3uxutfbfq6kuvypmhiinha6@4557bv2sr4im>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
 <20261104-work-procfs-bugfixes-v2-34-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104-work-procfs-bugfixes-v2-34-bbf7d5546809@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -11.51
X-Stat-Signature: 8g1qr5s8dpdhnmghq4mdgn67dtydmmtx
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 96E661C000F
X-HE-Tag: 1794321501-955903
X-HE-Meta: U2FsdGVkX19c/q8mqp/CyVUKJGvkkSBdGJT9zsOVKtcj3k3soimd9D79SwFGPY5Y6MSmWr9DnHKaqjSq3Fpl4mhlH/z18RmX1YG/Ibwo4Dbc3weYTw6jgaFec5FwheKyeRV1WiwbZpMaSYc4uVp9BWApRrIkugCK70quCd8BkarIxIhLPTNCiDCWE23r9k+B/+2hlGEgt3B8/a9ZOQGHz5uk1RrFqWUkSXrwQvpcA9uMQHUQjZka9aI13ksYSnmmXf1f6NazfQ1ZCuANOMmH78ygipkdm8D/IsYJfdxJnSfoJ0tnBQZ8+FDbK7C3nkUn5dBRNBA+ig/U5cIYh88kqrKwGBs6zgNGqknTQ1gRUUpmHL70sbTlGbk7Bc/wSLWR5/Nt10Rj5k22UlgxJ6IP81fO+Ho6VezvAou1CFD9XELwiq5f6jjG9n2OamDDFTy6zw9ysxmiD1j1bcZ9pXS1QkIwFhvgYydt+vSyOIryIMpHzIZSSsL8JnO3pshzr7//J+2pNpbIalyGVjM8gjpC7oN+JkiN2gkNT5MNvThDpektm9jZ0E225eRNLMwbtDCp96NQWB1lnrpGAsV9e4hvkhuO8zFCofSsBrEe93GbDsPubXvhDw8u6z1LavOwDH0p6sd+glF6trthpmRGiE5+qSxdGbJpMUY0kaU1KnVhzshuB4OtTnjTf3Z5d9KI6xAuyMgWwIONv7p/L4p2V5O7oQPD+luI5W6I/ZbADxtYc4q7Q/2SGKpxtO5x5FlyqD2TokpgSVFNFmWNYQUCI0KCijqPkAkMPgv3MiqimgmamcHfQyhl4Ip3R5S1g+3UQtR+aWhKMdZSwRYpwlU+/7mSCkB9MWgEfZ4trBDlHFl1q41u3gqKonN7cKIxuRgMBRKo19xkitKztQ62ntbLZgZN2DiWU7ETie4+GG4LtNMVgIPA2dtApOGD+Q2N2MTgt8ALtpY7L1U00gXoIB3v78t
 pnlYgDSX
 /wQwEbQsLLruYKZQ+xz6f67u1QeHdW/mVWW9y2qoQO+PaUFj2Tn+ZA3Vl5+J1fpJ4rROEB6TMNYKauu+am/j38JAx/NkO415FxibLEppT2k2tvzkD1grfjvwxM1b0YFJBjFgW+aSkG5gcGOkDCCh4h7HDVdN+rueG8THzHjI/fafkdS3VMMhfL6n6JM6G9ElMXdKGOb+LET+tQx91zjvBf2eNCGn9ycdz3F57kjSI6sZ65syofTviWRMthd6ffPDcRyxPD6lLlp61t/FIzz1MXAZXRdbkg8JpsSUhPa2TqIgaXgYAM/Ld1jAgDDg1tQ6bme4HXERsJu9CvZVtvIHh9LHcBXXPfss1VabRiJvj/k+YVIbXl3zUGULn8yGXKlLv0I6xX1TDVJm3AXhKuFsggXj2Z0F+BO6PwjX/qwabH9NHFEGX5fhtXH9rUHWpPkFB3WME4QePpgoP1Dc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 04-11-26 18:47:20, Christian Brauner wrote:
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

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/generic.c | 78 ++++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 51 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index 588999058e66..9a0a2fcac7c7 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -818,33 +818,14 @@ void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
>  }
>  EXPORT_SYMBOL(remove_proc_entry);
>  
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
> @@ -872,6 +853,34 @@ int remove_proc_subtree(const char *name, struct proc_dir_entry *parent)
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
> @@ -883,8 +892,23 @@ EXPORT_SYMBOL_GPL(proc_get_parent_data);
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
>  }
>  EXPORT_SYMBOL(proc_remove);
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

