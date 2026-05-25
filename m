Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADFC4CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B8656B0005; Mon, 25 May 2026 12:10:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769146B0088; Mon, 25 May 2026 12:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657DE6B008A; Mon, 25 May 2026 12:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 542C26B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:10:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 038AB1C081A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:10:05 +0000 (UTC)
X-FDA: 84806428812.02.4D823FB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id A985440015
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:10:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fO4rShwn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8CuABOSu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="U/5mq3v3";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ePm/y7Ab";
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779725403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QzQMwNuzcTyDWDBbrPJPk+oWqpbFufgu+tYxwJzuBcA=;
	b=L3nXrFjV1kDY7z5LN4PuhUect2LomTuK7iJ6QMtyT1Jm86LcSqQ7UhYKGbuO++zLHJysMw
	6dNdCy2I8d3iOHlzdFygNZeQdGyDA11jDeTYkCocrO3/bwXWnb5rhVm1RINK1V+qmPrTGH
	0iPdYs3bHk2YLcQnxERgPeHEwIbB1Dg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fO4rShwn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8CuABOSu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="U/5mq3v3";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ePm/y7Ab";
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779725403; a=rsa-sha256;
	cv=none;
	b=ZBsDRmj5zo9ku7M5l+FJtGUGQJ2iukjiXdFHHpDY7/TeOFruFT8/QwuVfz1CIKuA0ngZ+Z
	kz241TBbSKwzlM71sg/aegDTVo7PhJWxNJdW9kHCALTAikRMCIM55h1aPWdxK6CVJqu+zK
	/+WZh/hea747Zu7rVldnHPeWPbweNl8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DF4BE67348;
	Mon, 25 May 2026 16:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779725402; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QzQMwNuzcTyDWDBbrPJPk+oWqpbFufgu+tYxwJzuBcA=;
	b=fO4rShwnpRca/Qq5O5dxQ0BFI4I7JU8ZvchsxsYB2KOnAHYByNilhFy7ZhQmPdse2qBgxr
	1EJdV6hae2L3Q2wFNfmlzmlMqdCDBUmuYcAsTvw0e7hEOeO/oASDzBJmlh8N0cUO6qkv/D
	u/VTU/tIoYlYjbzA6JqzmS3QJkei470=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779725402;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QzQMwNuzcTyDWDBbrPJPk+oWqpbFufgu+tYxwJzuBcA=;
	b=8CuABOSukBh/JOGoxdhoaM6XBagg0YJ4CgJiNPWcgimpcpAHRDawAfN6EsFSfMjXWRl/9H
	fQS3Dit/JgMtZyBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779725401; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QzQMwNuzcTyDWDBbrPJPk+oWqpbFufgu+tYxwJzuBcA=;
	b=U/5mq3v3OCXAkr6Sjo6oRmqrs0tOQEwI5lkKi618l1AhAqyBkmorllMpPseqWOS0et5fHv
	ovfPAMkU8QK34zrEPC5YWj3ZO3pym0SHQxLtDufibCoit05OiVufj9a80rYcRFqLG9XwEf
	MZcxcPxZaybt//fplWyDTNqSi7HPLnQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779725401;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QzQMwNuzcTyDWDBbrPJPk+oWqpbFufgu+tYxwJzuBcA=;
	b=ePm/y7Ab8Y6GajHNFTPHGNLubf7O6wf3vduHG1/Gag7Bjb3cUucL32Ipd0cybpnJns+YVi
	CKubuBr2EdjSLsBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9E05359D1D;
	Mon, 25 May 2026 16:10:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YBHzJVl0FGqXFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 16:10:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D01BAA08D7; Mon, 25 May 2026 18:10:00 +0200 (CEST)
Date: Mon, 25 May 2026 18:10:00 +0200
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
Subject: Re: [PATCH 01/17] quota: allocate dquot_hash with kmalloc()
Message-ID: <xsmgh26s23da43wv6jza3dqrzhbxuetupiykjis2gkaq53yx3j@kttd6p2ba7f6>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-1-275e36a83f0e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523-b4-fs-v1-1-275e36a83f0e@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A985440015
X-Stat-Signature: bu7jy5g1sisfmryem4juppqqptcbmnof
X-HE-Tag: 1779725403-762623
X-HE-Meta: U2FsdGVkX19JQ06S6PCAjbfMy6QbJ5TK86MYPR1VxV99wjLYaL6EdwHVXEwa/YvyIXinr1P7nNwda9v2f1QR0mxDM1KZzvFK40goq2T45npoUjBOAPDbNgcFUbjKDPQiIxHpyWFH1JWMLnJWRa1g8pj25c2gMbdMirtt/EnTwKSmXoegbw8OMQa2lIOZFle8/rqXKdAat4F8fvXGX+V6kzweJB79Sxe+uD3C6kKkFdfbAlTGvoxFan1Ugn0OC2PhksDY+O94kn3og4vjW9pNgJjSd7/Fr5BGKyDFEhlv8or+se+LdT8BTkBAeW35omT5I5evn0jQMiNbwQMPPtcgUGodOwClRg5WcxCwhPdtoPMi2q5t2fp8Cb24eHr6/xhELhlhaVnBrGZQGrPNF+AWoGpv1JIDHaWcnW6ZvkyeXSQKDLa8FZ2WYOZR2tGfC1BLxw654czAgC7HR12R7gPG8MTWgaj5TOqTmyETktYi3BIq0ZbLDgmMd+zxNrBiSXa/jNbMc+u4gHSJHil/kFWW/wSAuEx9x6a5Ovpm2b2YGsP7rGOe1LThNyPVwcktQrxsdaPgtc5ZUM+Zgn9DLBraUufrBxNcZiiAiT4LnGCXFdGrIQq1BCqWMd24SG1dXDpc+GQUDLNWHc0iCraJn/c3RrrUFBTiZtLju6hO07B8IT8HLNnmCdbbUZMbWEp4ezJ6oj+ysHIJUChUa0H4wLmLfoeE/xtbybWKYBKKBYv1DIitMhHc+lfTCGjC3zhBG1mw8UKdjJkJVZCUlW8XSXzr3B0GihMh5fVBEod0DurJvTLkgM0Hia6QFVK+WMAJFxSbQd1l/EtQyAmGxp2NSXSM2XV5RixavS+GugurUe1AmbWo5Tfy5dLOQIZUDxTBP7PmFAKDq7tCUO/ykKtF40f59M2x4m8gjG/+wWrZXD0WWoeqDyGSIyap6lSPYhBTa3MRpRzvYaXYzPi7JtF4Rrw
 AhsbHRrL
 fKIjOpZc0rVsxhkblj3I+zGdEYgECF5SKMTknahKUBYmk6HgKi/OoeXDX5O4xYgGEZzZEPfOls5f2pIv3SCItag2FN/RE+hPWVZB3Cv5oSLTLFcGZ/4PUUyNhY1GWhu0csGyDUX7EoVtTTcoyww4sPolA5zaMr+BVko2XDz9n/YTjAIILCegwhC5vALNLNhhERVMp92jk0ZCroIoRkwQOKPt/vNqYThuAS2w7PtrOmFpIzaUtMcQfEH4fYSBB2vMx3PvfS4Zc5mHoVG7jtcE15uTJ5pzIuApBv1AMl/YJ/hD8W8OGKX0bSY1LvA+nacH+hoRJCHlz5rTMzbawHhVSC/y48gWhWy6q6gzSjxcWR5HijCu5X1jZZkBKouWEUhVnKBVapBQU97rP+cKzt59k2IHtloz3wFfcSRBQ8D10d1/FAaQRW1yzC6hd2FgZbFqoNL9qrm/tspTTw7U6K2xDUqXJF3lDOoVuzSDp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 23-05-26 20:54:13, Mike Rapoport (Microsoft) wrote:
> dquot_init() allocates a single page for dquot_hash with
> __get_free_pages().
> 
> kmalloc() is a better API for such use and it also provides better
> scalability and more debugging possibilities.
> 
> Replace use of __get_free_pages() with kmalloc() and get rid of the order
> variable that remained 0 for more than 20 years.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks! I've added this patch to my tree.

								Honza

> ---
>  fs/quota/dquot.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 64cf42721496..9850de3955d3 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -3022,7 +3022,7 @@ static const struct ctl_table fs_dqstats_table[] = {
>  static int __init dquot_init(void)
>  {
>  	int i, ret;
> -	unsigned long nr_hash, order;
> +	unsigned long nr_hash;
>  	struct shrinker *dqcache_shrinker;
>  
>  	printk(KERN_NOTICE "VFS: Disk quotas %s\n", __DQUOT_VERSION__);
> @@ -3035,8 +3035,7 @@ static int __init dquot_init(void)
>  				SLAB_PANIC),
>  			NULL);
>  
> -	order = 0;
> -	dquot_hash = (struct hlist_head *)__get_free_pages(GFP_KERNEL, order);
> +	dquot_hash = kmalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!dquot_hash)
>  		panic("Cannot create dquot hash table");
>  
> @@ -3046,7 +3045,7 @@ static int __init dquot_init(void)
>  		panic("Cannot create dquot stat counters");
>  
>  	/* Find power-of-two hlist_heads which can fit into allocation */
> -	nr_hash = (1UL << order) * PAGE_SIZE / sizeof(struct hlist_head);
> +	nr_hash = PAGE_SIZE / sizeof(struct hlist_head);
>  	dq_hash_bits = ilog2(nr_hash);
>  
>  	nr_hash = 1UL << dq_hash_bits;
> @@ -3054,8 +3053,8 @@ static int __init dquot_init(void)
>  	for (i = 0; i < nr_hash; i++)
>  		INIT_HLIST_HEAD(dquot_hash + i);
>  
> -	pr_info("VFS: Dquot-cache hash table entries: %ld (order %ld,"
> -		" %ld bytes)\n", nr_hash, order, (PAGE_SIZE << order));
> +	pr_info("VFS: Dquot-cache hash table entries: %ld (%ld bytes)\n",
> +		nr_hash, PAGE_SIZE);
>  
>  	dqcache_shrinker = shrinker_alloc(0, "dquota-cache");
>  	if (!dqcache_shrinker)
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

