Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E849EF3382B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CF136B0089; Tue, 17 Mar 2026 05:38:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57FE66B008A; Tue, 17 Mar 2026 05:38:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447F96B008C; Tue, 17 Mar 2026 05:38:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FADE6B0089
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:38:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCC3D1CA03
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:37:59 +0000 (UTC)
X-FDA: 84555053478.05.D197718
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 747414000A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:37:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=A+0DMHAb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xmUefSO9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HfXH0TzA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JOi5WNGR;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773740277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XMAS/3KJsstwA3paQv6TW+kjF9gkITW3NZUnc7bZnuU=;
	b=F5yx5AD42cVxZdx+WyJP3Do2efbbHb/XOmpcOMM/vmdk3bAZnA0LtlYpiFnzC1E6LGiXs1
	9SafQU+oNHNVfDTT2tj8QYVmNWiPeP6Sxv46lBKZ3lQAQmXxVJzK9u258gTZ3vCemeQUjN
	kxCJinT/b/2RjDrTW8JfTknbr5e//RA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773740277; a=rsa-sha256;
	cv=none;
	b=ZZMwOJ5fkwdM2K11hrAjjiXd1M81Izc+Z35EHTWrIV7hFdHNibEjBhUiBwpu18Rs/xdlrH
	K2NuUximGY/g5y+4dhpnSX3PSwsyoRv73MF1N/Tlkh1JMASL3VV1HM/LH9sIH7sb7TW9Pk
	Xr68dKpiQwP2fYSPKq0Haxe/kv+r9cE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=A+0DMHAb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xmUefSO9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HfXH0TzA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JOi5WNGR;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8F3F85BD96;
	Tue, 17 Mar 2026 09:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773740275; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XMAS/3KJsstwA3paQv6TW+kjF9gkITW3NZUnc7bZnuU=;
	b=A+0DMHAbfbhM8MnlBUqVL+W87T4tqLjqUGgvxNRqk88xckeEeRm82e+ypnsFgad4/XiqOe
	eFQnLDIV+dM8cXwaoMX9AvcuSz0XaJOKBqB0bzHsm6RA5PfmHqn2hYLlC9HiNT/X/xWX3q
	BqIvjViI9CtSct4EF5Es0QJY/LKW1HI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773740275;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XMAS/3KJsstwA3paQv6TW+kjF9gkITW3NZUnc7bZnuU=;
	b=xmUefSO9ArclnNvP01TmJwVa9hwB1H9Ezy/G04E5yEHJeukkDoWlTMUncfdfe52pgfQsy2
	oR1nH2U5mzv18+CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773740274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XMAS/3KJsstwA3paQv6TW+kjF9gkITW3NZUnc7bZnuU=;
	b=HfXH0TzA0f1d2CSbAyldJl2xl9aWzYbpw10loZV1kNcn1txaCSCXzrSvfKHAIHGI00VNao
	b//U5Itged1fc1C/uxZj0ysYyWI8ysEt0UM5ZsojSOhxVbgzKeS+lof0B9W59LS9IUq6E2
	yDhoArHhElh4lGLUjlD4eJXEl3bpa6o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773740274;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XMAS/3KJsstwA3paQv6TW+kjF9gkITW3NZUnc7bZnuU=;
	b=JOi5WNGRhJfP08gEJXjzmktG0GqpaBSxSS7XTpG6foqsalkoejj3JitKc4S0PHtQ5wznJC
	I5D56EajKt5gebCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7D7054273B;
	Tue, 17 Mar 2026 09:37:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Cg+ZHvIguWnvMwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 17 Mar 2026 09:37:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 43970A0AB1; Tue, 17 Mar 2026 10:37:54 +0100 (CET)
Date: Tue, 17 Mar 2026 10:37:54 +0100
From: Jan Kara <jack@suse.cz>
To: NeilBrown <neil@brown.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jeff Layton <jlayton@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	Jan Harkes <jaharkes@cs.cmu.edu>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Steve French <sfrench@samba.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Breno Leitao <leitao@debian.org>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Tyler Hicks <code@tyhicks.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, coda@cs.cmu.edu, linux-mm@kvack.org, 
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, 
	ecryptfs@vger.kernel.org, gfs2@lists.linux.dev, linux-um@lists.infradead.org, 
	linux-efi@vger.kernel.org
Subject: Re: [PATCH 33/53] ext4: use on-stack dentries in
 ext4_fc_replay_link_internal()
Message-ID: <pb664u5mzlaqthyhwfsio66wgv2hwuqazzbrtzunnja76khowi@v7l5o4xkzci2>
References: <20260312214330.3885211-1-neilb@ownmail.net>
 <20260312214330.3885211-34-neilb@ownmail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312214330.3885211-34-neilb@ownmail.net>
X-Rspam-User: 
X-Stat-Signature: opt7e1h9x86gjupfbda49mw3684c9d4x
X-Rspamd-Queue-Id: 747414000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1773740277-181463
X-HE-Meta: U2FsdGVkX19IiblEx/OZkHRkVRNaYXbJtonDVPy6tMFYFzcm+mLwJhPyD3iJ5xOgaFrCVuNu2J66KEgzVGoggIiyNhYV8Tmd/bcZrnM1D9I4Pmas2580cwMZsmaIcZ87b21Qfpz8vzScP0YpQGwpYg3Ee1fIdWrlfDIOQd+c1fqSnTR3K0ehwDlUjyk8JVCaiskKrQZC+TuGqE5ImD2K0iiGYzDakKOcEAFmubjpWGq3OHJ0n46hG/wnzzqPtCjDGaRRn8F1ekhepOYcbDc81UILo6qlzOrmqq3fO+4bIYjw+hiH+9I4Mc7a/jnBxS2AnOHvZ0Tn8rX80XBn51Ull+wBWAThL4bRnulSNfqZ/hbeKyqqIAO0A8NRhYXbre1ZlCZOiGs62rrn+4GOsJ0z9oWC4B8eg9fFN44jH1mhX65wu/p0DsadYLfurONvVxTmhHUmLMVSNtRyvs7PXcJ3hyv8glPZRLw0YeGzAAPkITMj+qTztQtz62o1qRaypQ6Iz9iwRYnADIil/74DkQi8Y99C7k/WmAkdTC8xHGpq7HTfww+P+YBH8Vu602k99GlDP1F2tcthOQwztoGlDjDE06UCSfiMNX4v92j9gnA8y8Rp9N8JWV0N6pfx9LLNoo2Dc9hcvU2nBf7ahOk6yFLdh6soj7asOi+1cTqKYL4dI+pHC1it36qCFCHPV/5HbThkrrr9ZygIXXLZPVJ7F45UI5uaz+oC4kl2AHnwni4ebLUVfduQag1YULQRYG5Gyhq9UVWwZ8yvdS2m9N5kd6iddHWN2WWgKBvQmXl5mI5mc3+AND/8rZP5ZM3LDjd/ZyotozRG87d91sWbtySJqQvmhrSTZQxZbDn0N73ahbAHJ7DqvA26hebFb1ys/urcbbADUg6IF0pRynPQjm8DHPezVLqiptq5VBLIx9EPgl9SqYKfE/KjGkv6888Ap8FU+C2bJHrIMPiHy4x3gTDEqhi
 iWAwARvz
 jzshIUt3T0Fnlw7Mna2vvAXTxsmbS82YC9P7U4nK7mX3Ah2TPNRlSBnVTO09+OmkjbZKSPSn1JsBANtD3ALDoSsyRB64mMn6pdJ3OWPlwsrXaNYeN4xd7VFqG7KkY1JCXc0UHxk1UVO/JbnMIKbrpIoCcVuK9i7MJNyJHEPh/9M6cKaK2c8FXaLi8Q3i/NAc5Ssii8Rbynay7CCSqKhqHEdWElyKNzdMb4WgfNnkf/KhDLtChR9HA+YQ7xdYx8mK5vGm2Q8P0mzB9kq8l3X9kCKTxTbQTr4ZkkA8a9lK74Iq0wyVKY0LvUQcMTlLrBNskwEDbHqBFc4F1oU91mXUF9l+M5kXDTSIkolo0B98DOvsXcm4DT9vbriLVn4vbHxZevku8L8F/YL6EL5IqGm+4V2MhfztRB6tt69ZrC00IzdLwDAU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 13-03-26 08:12:20, NeilBrown wrote:
> From: NeilBrown <neil@brown.name>
> 
> ext4_fc_replay_link_internal() uses two dentries to simply code-reuse
> when replaying a "link" operation.  It does not need to interact with
> the dcache and removes the dentries shortly after adding them.
> 
> They are passed to __ext4_link() which only performs read accesses on
> these dentries and only uses the name and parent of dentry_inode (plus
> checking a flag is unset) and only uses the inode of the parent.
> 
> So instead of allocating dentries and adding them to the dcache, allocat
> two dentries on the stack, set up the required fields, and pass these to
> __ext4_link().
> 
> This substantially simplifies the code and removes on of the few uses of
> d_alloc() - preparing for its removal.
> 
> Signed-off-by: NeilBrown <neil@brown.name>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/fast_commit.c | 40 ++++++++--------------------------------
>  1 file changed, 8 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 2a5daf1d9667..e3593bb90a62 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -1446,8 +1446,6 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
>  				struct inode *inode)
>  {
>  	struct inode *dir = NULL;
> -	struct dentry *dentry_dir = NULL, *dentry_inode = NULL;
> -	struct qstr qstr_dname = QSTR_INIT(darg->dname, darg->dname_len);
>  	int ret = 0;
>  
>  	dir = ext4_iget(sb, darg->parent_ino, EXT4_IGET_NORMAL);
> @@ -1457,28 +1455,14 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
>  		goto out;
>  	}
>  
> -	dentry_dir = d_obtain_alias(dir);
> -	if (IS_ERR(dentry_dir)) {
> -		ext4_debug("Failed to obtain dentry");
> -		dentry_dir = NULL;
> -		goto out;
> -	}
> +	{
> +		struct dentry dentry_dir = { .d_inode = dir };
> +		const struct dentry dentry_inode = {
> +			.d_parent = &dentry_dir,
> +			.d_name = QSTR_LEN(darg->dname, darg->dname_len),
> +		};
>  
> -	dentry_inode = d_alloc(dentry_dir, &qstr_dname);
> -	if (!dentry_inode) {
> -		ext4_debug("Inode dentry not created.");
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> -
> -	ihold(inode);
> -	inc_nlink(inode);
> -	ret = __ext4_link(dir, inode, dentry_inode);
> -	if (ret) {
> -		drop_nlink(inode);
> -		iput(inode);
> -	} else {
> -		d_instantiate(dentry_inode, inode);
> +		ret = __ext4_link(dir, inode, &dentry_inode);
>  	}
>  	/*
>  	 * It's possible that link already existed since data blocks
> @@ -1493,16 +1477,8 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
>  
>  	ret = 0;
>  out:
> -	if (dentry_dir) {
> -		d_drop(dentry_dir);
> -		dput(dentry_dir);
> -	} else if (dir) {
> +	if (dir)
>  		iput(dir);
> -	}
> -	if (dentry_inode) {
> -		d_drop(dentry_inode);
> -		dput(dentry_inode);
> -	}
>  
>  	return ret;
>  }
> -- 
> 2.50.0.107.gf914562f5916.dirty
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

