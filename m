Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D548C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 200BA6B00CF; Wed,  2 Sep 2026 10:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B1826B00D0; Wed,  2 Sep 2026 10:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1476B00D4; Wed,  2 Sep 2026 10:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA8D96B00CF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:58:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7EB8C1601AC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:58:44 +0000 (UTC)
X-FDA: 85169128968.11.18F1BB3
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 468D5A000B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:58:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yB4II0i0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vw6IATGV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aYHKtq46;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HrSxe+Yz;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788361122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+gn1TAUO4/JHYqM9pNukdAnd9lWGs9C3oFxBr7I6LA=;
	b=M8K8KJDk4GTh7nYL/x4a/L/HMXOH2GKtruXYYAQMtLyp891Mdctn5Wf7iuUugLtjZa1c9A
	84IaB2m2GDI+scR/f7mjb53AIivUgPGq2VCdO0uajoNkKHXbpZe9A6BOeVvGYhm5C6q710
	XxQZJGtZYk2PgPQAI2/OT6Wna04n2lE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788361122;
	b=V3vfVJS5auNPEvSRnf47GvUpJYTnruGLpUoC4CfsSMiFlmnQn0y/qrJ0QLEPDyPywWPZWH
	NWpbR6nPGeQZ7qATttrdNY3HJ0oouJP6Tqh+Kq2GQpIFyZtqzLwMtd3K5wwc6uGMNSxoew
	EpPvaPkSIlMghFW28OrHEPMATzuUprI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yB4II0i0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vw6IATGV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aYHKtq46;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HrSxe+Yz;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C79D21FB1F;
	Wed,  2 Sep 2026 14:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788361117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P+gn1TAUO4/JHYqM9pNukdAnd9lWGs9C3oFxBr7I6LA=;
	b=yB4II0i0MBU7zS5j/xSWF32ik8O3RA4ImGCMDSNFcDBim5FAi39Ct4aiKMAlX9GYiQWUKv
	J1QGJiIepDAM01WetOkL0vRXo8+005nUmeHYkDMih2Sq6ZSSAc2p5fEGRAu1ylMSDJyteR
	utJa7+yyDoBT+i+2XC/CqVMVQ4Imbcc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788361117;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P+gn1TAUO4/JHYqM9pNukdAnd9lWGs9C3oFxBr7I6LA=;
	b=vw6IATGV16sYLj6IghrydJ+GqQCy5ZVQKXab/WOFjQ2LyXuM6cgtZjGsJZ7jWb0GBsIyUR
	8dPEaIzX6Fh8chBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788361112; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P+gn1TAUO4/JHYqM9pNukdAnd9lWGs9C3oFxBr7I6LA=;
	b=aYHKtq46F2CoMksVaFbUxgiNgtz9AbZkmUClCqqE396U4EUGEbYSl3zNVpN/sA6a25lUQC
	1TXgWtZkNiaRGyr7/C5HUEGSdp31OWorBUnvGvCx1hi2eQEf5viaOOKmGJqtwMCGpgjiad
	p9N8O0zhhVkEV/Zzomxm4z1V+54Si4o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788361112;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P+gn1TAUO4/JHYqM9pNukdAnd9lWGs9C3oFxBr7I6LA=;
	b=HrSxe+Yz7nWi5vVuEcn9hTc530rXE1eyHhw7KCmGkEXyK9qmghZAyJQAzp3zxbQaUn+/aU
	QHMeV6nuqe0t2vBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2DB4613888;
	Wed,  2 Sep 2026 14:58:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Q9wUC5c5mGq1NAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 14:58:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3F442A13B5; Wed, 02 Sep 2026 16:58:30 +0200 (CEST)
Date: Wed, 2 Sep 2026 16:58:30 +0200
From: Jan Kara <jack@suse.cz>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: locking: Fix bracket
Message-ID: <ffoup27vuua4yo5weeyhgdjevtb4c2nkoz45lkk5kzipnnhzsn@wckefd3i2vv4>
References: <20260902143936.703665-4-manuelebnerli@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902143936.703665-4-manuelebnerli@mailbox.org>
X-Rspamd-Action: no action
X-Stat-Signature: h66fgy1sdzxy6ufw5xrgnc7un1qrojt8
X-Rspamd-Queue-Id: 468D5A000B
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788361122-769949
X-HE-Meta: U2FsdGVkX1/bgkY86L0bvQc6afhdLuNrwoAGsJuz1O09OZXP4W+4PLplyMkzYYPe0Yeqw5CuiOjSgUjzkCekn5k1JoFHsN5P+VwODmtRswjl+O/MJtzjDKk1RrZsJ99z5sJJ6PtPqDsTqYmr43mU1coTve728h9Hn4Oz1xf1gDRgrBvC07829MCl9PGYGLOt858c165rvfskAsLa5hQTRHOVAAT7tIX7vqOPKX55kEInY8FIMRnyluboMfGMc425e5THOqvKE4baOHuNJ08zapotJ/fmHOlnCfUIa3qxcIMheVG1dC6mulcrKTnZkHto0uUNV0wTvWKJUYjRZgeYACYn4bOgKHnsztQwrI6T71sH2uBS9dDkaNjnVEhzfh4+VlRhprCVxkCmJMfSXgFLR/7utMFHkjFLY80ROBDwJzd/ncZ7qhG8y2CHD8tVazohxn1p0vE1xvXB3WtNV0EmQmKoG4WzNgjmgfkpOO70pd2gTnkWYKYpaKb8ToWLVqIhJ6mLc91ECveSDyFzEG3ChPQ+zvSb18aCnLfORpA5FsKXxLxcU+2FncK1KkJl7KwIUgxjFTRjrQfPyihEvxurVfD4imjQ1yp9d3p/Tb7xloiM3PEXM7bp4+HxtMNFYl2Ky9YxO0d+L6l0AGZMANSZNPqgU4g4C4OD4L4jA35sNvHuvkXy+uSECZfaN5/QTipZfQVR7t9+vNGNKAkaajgCPemT8UXAmlsO6r8DosxoF7RiZsYsPyG7w+cG/zoD6+sijDrP6XUkM5DgtVUFkQX1rE+2ENQACVF1A51iP1tjcrOCoI8zoPVxmzJQoIVHbMMfSl8BU41zrNNMHn4gR1+PhVByAj7SSO5C/WQanbBUJJsmXHG9kfIfcTyfW0UT/Q8DQ7wqe7RdbPIIypEAZ46GIQ5eqaGN7/XHMDeasUg1G9CID/jRzwx2cba2vOfaC7983BpBJbq5CNBgGz5VirE
 OuvfV54q
 XwcU4wqhO5otxNyQZ+XtGzkkbvEFIbbLo3q+Hya/Y4zzVpX41rTdMLfv1v4QFjit40F/13AoLmSxVHd7ObyWe19ceqQL1ywVLS1JL81hS3Nd5Z8pWetEJANE6Rz7pvw3pMR1h+py96uBf8q0bP5xImAaSPBZT11P2Rxa0HJHygzd5DlVv6/se7aephiBsIgM5nh/aWhFGu0M3mygVPSF+dAhHOBb3yhfqq5+UL72noEFEdCcGG/bg3IiWHyYI930U0ft0A+hohfULwGl6SpnzyrvbzHo5xpNy9IznZeddzjuXBfSF+w68LfSrxShYLXPqGi5shd7hnlceECfGBg5MHyk9qYYeiavzTYPK33vGug4ndr+qHhbCDLYrm5SyULL4nw4+Sm+W0LfWsNk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 02-09-26 16:39:38, Manuel Ebner wrote:
> Remove needless '(' from code block.
> 
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> ---
> Should I also replace ')(' with ') (' as it is in the second code block?
> It would improve readability in my opinion.

Dunno, at least I'm used to the way which is written here :)

								Honza

> ---
>  Documentation/filesystems/locking.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index 844d65eb4..1598cf555 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -27,7 +27,7 @@ prototypes::
>  	int (*d_init)(struct dentry *);
>  	void (*d_release)(struct dentry *);
>  	void (*d_iput)(struct dentry *, struct inode *);
> -	char *(*d_dname)((struct dentry *dentry, char *buffer, int buflen);
> +	char *(*d_dname)(struct dentry *dentry, char *buffer, int buflen);
>  	struct vfsmount *(*d_automount)(struct path *path);
>  	int (*d_manage)(const struct path *, bool);
>  	struct dentry *(*d_real)(struct dentry *, enum d_real_type type);
> -- 
> 2.54.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

