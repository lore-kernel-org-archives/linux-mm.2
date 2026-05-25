Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D15D4CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40F76B008A; Mon, 25 May 2026 12:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9D36B008C; Mon, 25 May 2026 12:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96B186B0093; Mon, 25 May 2026 12:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 81D816B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:13:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18DA74017D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:13:45 +0000 (UTC)
X-FDA: 84806438010.08.771E6DF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id E249240006
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:13:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TjBJNAzB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CBlBCazy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TjBJNAzB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CBlBCazy;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779725623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=27RqMrsc/HyYpcKKC895GgpS6rD7RsFIOjFaMcayYkU=;
	b=lMas78TpbYlqOxNCuNdhXOIYthUOQdrBb4NMNKxFXWuXVmmADBike5UoZaUf2Zf04ohDLb
	J56jZWOSQOVcM/fYSmLz2S1Lpvu98pVE9W86A5/SRxBNMtoMe8YscvsafqbXb8ZNoY9kcw
	vIXPU7kMWOtt8O9RurbO9tkFvFgj/sk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TjBJNAzB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CBlBCazy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TjBJNAzB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CBlBCazy;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779725623; a=rsa-sha256;
	cv=none;
	b=uRvOpZWTLJXZIod2oUjlrPGRIawFFde40PNvY37sZ9b33K6mQR7SyPd0YzgL2eETKHsIp8
	MtDbDbb75bF6n9YUdeUICBesYBCzmQCGN1JPgP43RJz4bfe+Ap8lZqF4sG6YGd4JLJlXyO
	6hF9HGcu87JyJqezTfVxYcdHb2iAIRw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 65D4D67980;
	Mon, 25 May 2026 16:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779725621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=27RqMrsc/HyYpcKKC895GgpS6rD7RsFIOjFaMcayYkU=;
	b=TjBJNAzBA+cavyzS9h4Ksm50NiBUq6prYAiJSxscFaJoQOPK+1LWzQJcVWdcQbiD6lGcln
	MED/W+RtqFyxc4AxW0iXhY65+ope8eAKQMBwkvzfow+daKjZYQM/FJiaJsDRiNyo5ncYgd
	mV6yitDH05w7rg2MJ2Lbx3mM0OhI1Zg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779725621;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=27RqMrsc/HyYpcKKC895GgpS6rD7RsFIOjFaMcayYkU=;
	b=CBlBCazybZJb5mYghpd9dcVMD47k/+oTvUbOccSM7j5/exZQpOfRJmSj9CSBVb+RrQBGlP
	DdyANGP/XVbIhMBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779725621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=27RqMrsc/HyYpcKKC895GgpS6rD7RsFIOjFaMcayYkU=;
	b=TjBJNAzBA+cavyzS9h4Ksm50NiBUq6prYAiJSxscFaJoQOPK+1LWzQJcVWdcQbiD6lGcln
	MED/W+RtqFyxc4AxW0iXhY65+ope8eAKQMBwkvzfow+daKjZYQM/FJiaJsDRiNyo5ncYgd
	mV6yitDH05w7rg2MJ2Lbx3mM0OhI1Zg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779725621;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=27RqMrsc/HyYpcKKC895GgpS6rD7RsFIOjFaMcayYkU=;
	b=CBlBCazybZJb5mYghpd9dcVMD47k/+oTvUbOccSM7j5/exZQpOfRJmSj9CSBVb+RrQBGlP
	DdyANGP/XVbIhMBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 52CA959D20;
	Mon, 25 May 2026 16:13:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W8EyFDV1FGr5GgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 16:13:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E5405A08D7; Mon, 25 May 2026 18:13:36 +0200 (CEST)
Date: Mon, 25 May 2026 18:13:36 +0200
From: Jan Kara <jack@suse.cz>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
	Miklos Szeredi <miklos@szeredi.hu>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 03/17] ocfs2/dlm: replace __get_free_page() with kmalloc()
Message-ID: <zozs55fvd3cifliymnyfo6uzakhhu4rerhiod6kpiix6hbn3an@ysj2ih7fuvqq>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-3-275e36a83f0e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523-b4-fs-v1-3-275e36a83f0e@kernel.org>
X-Rspamd-Action: no action
X-Stat-Signature: hshdcjbs7bi9tgwb1nkocwthq8q1czzi
X-Rspamd-Queue-Id: E249240006
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779725622-3169
X-HE-Meta: U2FsdGVkX1/N76yQLqoIQPhUcf/3FqEw8NRQKBlg2f6hUx4ljs55xQuDbWcvkvkTWxjiGMHp3fGmqUiN3c7KGy5WG2RxtnU4TZhGQnWg7hAdfqdjguFhkY1w7CT+wrfimFZswIs0mEy67vtIdKYFCVio7gVjkYs+0rI5ip2PdjQGFlONJDyJ8Zc9fzzx+86zFzOQsN6KnzfUQQKmwwYEa1M34Eg8giuG2P8Il4+eGRr3tkdyaXLNYE2gyNKw144Dwb1b02GZeSFq+Z9D3XG/UXEtzDOXXzX+wpQjMhYgXdP00SbTzoG8JZHeVFgE0y+kgDxAACVq05vfqC/iWrCtUc1tPeetkOZ49iuOihaoZa1cNHrrmAZ3CWwbv7sm4c/2HVLqjGt3sde6TFWKDD7gvH/N5FONjmitOEuUoOc3R6xGYn2JIXH4zSah6pJmHBisgnT6GWNds81BbGRt2tmTlpwtIgXK+ic2OcxRV8Pdo9ks2lJFOjscSU0cbi4OG5vbBRwhZywD47qPdq5uz/2jqlpUUUEnBj2FH0UxrivEf1NZarO9PN/sW3BC4s3vsraTc/PKG4K/ICx8j6nYSjBN45O+O4SFsKWMKrmj/SXshccBpMS1kNGcl2ekE3hMPgMa6KlUvnuG7e3Nx/yB0dfv8zBIn4UosAUGufJldsl8s2NGdrqO61Uqc/kzDwLE7/jgwvqF95KMJvfRJBJzU9eqLxx0UIVr8PDFPtePX8C98QI2kd9nNk0LU8mcl91XJA7P2I9gFchr1DMynp/VnBsjYdYVg2/XdQMsBuutmhIW1lAeZftpHkqPu6Rsdnf8lKT/5rhzT69Zm6xS4TWkSRVs6ReqEWu3Ci3m/hZI8518Y63Vk3QQILIZTUnTlHHZ4D3OQZCJL5z4i3F4bKIAvZfzJ66cAHLP5GEy3h+jM1QMBYbGgxJB+QtcTZIJ0cT7rv7bKV1KJAk3kA408KxJruP
 fMFiDIY0
 nq6bI/080Ljrn7pPKryF6lZxShYIRrttDi3innA5/sEGdeAfHCHWgeL76DJxQTo8Kot7LA572yzukoBzYrWfZD/U9ErZK+wnt/RdpVGJ/jOGnq/8yZMYTLA+wdF1s1Uf2yvEbzzFXIgfjIKTULz9F8QGPgJDsTtLizrk/jYmri+W/Riukj4CZPQQDtIIwSkdNdHvphK4oAIVnLH/SWab37qVfJelcMMIswnU055CKNWZtxqzVpKDSOUFwXvn9fSnBm06g1tTFa4Uz0Fv4bqjVMyjsrH/NHcccoaovq+jME8yCOTA1K2gdsQEtBQBHg9vywiq/9tfPpVjtueopYbMJgT4noei/O9aZECw4iaRdx2OOqBd6tz6dB1pBmANzMAlW+A/jiAtmt2HuxJ+ZXViu/1n8iizoXFdMw9OnnGmbij7zjtB75KjIGgqARjOwjzeD62QOcrpTXOSfcdjmIlEA66EZM4W8QJTldmTc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 23-05-26 20:54:15, Mike Rapoport (Microsoft) wrote:
> A few places in ocsfs2 allocate temporary buffers with __get_free_page() or
> get_zeroed_page().
> 
> kmalloc() is a better API for such use and it also provides better
> scalability and more debugging possibilities.
> 
> Replace use of __get_free_page() and get_zeroed_page() with kmalloc() and
> kzalloc() respectively.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ocfs2/dlm/dlmdebug.c    | 24 +++++++++---------------
>  fs/ocfs2/dlm/dlmdomain.c   |  8 +++++---
>  fs/ocfs2/dlm/dlmmaster.c   |  5 ++---
>  fs/ocfs2/dlm/dlmrecovery.c |  4 ++--
>  4 files changed, 18 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index fe4fdd09bae3..6ca8b3b68eef 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -260,10 +260,10 @@ void dlm_print_one_mle(struct dlm_master_list_entry *mle)
>  {
>  	char *buf;
>  
> -	buf = (char *) get_zeroed_page(GFP_ATOMIC);
> +	buf = kzalloc(PAGE_SIZE, GFP_ATOMIC);
>  	if (buf) {
>  		dump_mle(mle, buf, PAGE_SIZE - 1);
> -		free_page((unsigned long)buf);
> +		kfree(buf);
>  	}
>  }
>  
> @@ -280,7 +280,7 @@ static struct dentry *dlm_debugfs_root;
>  /* begin - utils funcs */
>  static int debug_release(struct inode *inode, struct file *file)
>  {
> -	free_page((unsigned long)file->private_data);
> +	kfree(file->private_data);
>  	return 0;
>  }
>  
> @@ -327,17 +327,15 @@ static int debug_purgelist_open(struct inode *inode, struct file *file)
>  	struct dlm_ctxt *dlm = inode->i_private;
>  	char *buf = NULL;
>  
> -	buf = (char *) get_zeroed_page(GFP_NOFS);
> +	buf = kzalloc(PAGE_SIZE, GFP_NOFS);
>  	if (!buf)
> -		goto bail;
> +		return -ENOMEM;
>  
>  	i_size_write(inode, debug_purgelist_print(dlm, buf, PAGE_SIZE - 1));
>  
>  	file->private_data = buf;
>  
>  	return 0;
> -bail:
> -	return -ENOMEM;
>  }
>  
>  static const struct file_operations debug_purgelist_fops = {
> @@ -384,17 +382,15 @@ static int debug_mle_open(struct inode *inode, struct file *file)
>  	struct dlm_ctxt *dlm = inode->i_private;
>  	char *buf = NULL;
>  
> -	buf = (char *) get_zeroed_page(GFP_NOFS);
> +	buf = kzalloc(PAGE_SIZE, GFP_NOFS);
>  	if (!buf)
> -		goto bail;
> +		return -ENOMEM;
>  
>  	i_size_write(inode, debug_mle_print(dlm, buf, PAGE_SIZE - 1));
>  
>  	file->private_data = buf;
>  
>  	return 0;
> -bail:
> -	return -ENOMEM;
>  }
>  
>  static const struct file_operations debug_mle_fops = {
> @@ -775,17 +771,15 @@ static int debug_state_open(struct inode *inode, struct file *file)
>  	struct dlm_ctxt *dlm = inode->i_private;
>  	char *buf = NULL;
>  
> -	buf = (char *) get_zeroed_page(GFP_NOFS);
> +	buf = kzalloc(PAGE_SIZE, GFP_NOFS);
>  	if (!buf)
> -		goto bail;
> +		return -ENOMEM;
>  
>  	i_size_write(inode, debug_state_print(dlm, buf, PAGE_SIZE - 1));
>  
>  	file->private_data = buf;
>  
>  	return 0;
> -bail:
> -	return -ENOMEM;
>  }
>  
>  static const struct file_operations debug_state_fops = {
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index dc9da9133c8e..97bb9400e24b 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -63,7 +63,7 @@ static inline void byte_copymap(u8 dmap[], unsigned long smap[],
>  static void dlm_free_pagevec(void **vec, int pages)
>  {
>  	while (pages--)
> -		free_page((unsigned long)vec[pages]);
> +		kfree(vec[pages]);
>  	kfree(vec);
>  }
>  
> @@ -75,9 +75,11 @@ static void **dlm_alloc_pagevec(int pages)
>  	if (!vec)
>  		return NULL;
>  
> -	for (i = 0; i < pages; i++)
> -		if (!(vec[i] = (void *)__get_free_page(GFP_KERNEL)))
> +	for (i = 0; i < pages; i++) {
> +		vec[i] = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +		if (!vec[i])
>  			goto out_free;
> +	}
>  
>  	mlog(0, "Allocated DLM hash pagevec; %d pages (%lu expected), %lu buckets per page\n",
>  	     pages, (unsigned long)DLM_HASH_PAGES,
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 93eff38fdadd..aee3b4c56dcc 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -2548,7 +2548,7 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
>  
>  	/* preallocate up front. if this fails, abort */
>  	ret = -ENOMEM;
> -	mres = (struct dlm_migratable_lockres *) __get_free_page(GFP_NOFS);
> +	mres = kmalloc(PAGE_SIZE, GFP_NOFS);
>  	if (!mres) {
>  		mlog_errno(ret);
>  		goto leave;
> @@ -2725,8 +2725,7 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
>  	if (wake)
>  		wake_up(&res->wq);
>  
> -	if (mres)
> -		free_page((unsigned long)mres);
> +	kfree(mres);
>  
>  	dlm_put(dlm);
>  
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 128872bd945d..9b97bf73df22 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -837,7 +837,7 @@ int dlm_request_all_locks_handler(struct o2net_msg *msg, u32 len, void *data,
>  	}
>  
>  	/* this will get freed by dlm_request_all_locks_worker */
> -	buf = (char *) __get_free_page(GFP_NOFS);
> +	buf = kmalloc(PAGE_SIZE, GFP_NOFS);
>  	if (!buf) {
>  		kfree(item);
>  		dlm_put(dlm);
> @@ -933,7 +933,7 @@ static void dlm_request_all_locks_worker(struct dlm_work_item *item, void *data)
>  		}
>  	}
>  leave:
> -	free_page((unsigned long)data);
> +	kfree(data);
>  }
>  
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

