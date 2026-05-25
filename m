Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58394CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9235D6B008A; Mon, 25 May 2026 12:17:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FAD26B008C; Mon, 25 May 2026 12:17:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8113D6B0093; Mon, 25 May 2026 12:17:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7084B6B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:17:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E11FA0174
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:17:48 +0000 (UTC)
X-FDA: 84806448216.08.275E90C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0D8728000A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:17:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NnTuw9Qf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9yAYd8D0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NnTuw9Qf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9yAYd8D0;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779725866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LiOhrDB5Siu3BTzKB3ll2nZPIejX17ixL8z+kYTNnLc=;
	b=YqZoqPAbPp6RQGSYHMcISwQ/vT/AMgMP4VVfrloMccP2jGrvf8tmWKvcr6HMsnlsWXg6Wb
	AfbUAK152NEC4iw4ckd2jws1QnrGBUEW0J9FszwtSvlC8ZIGeIN7Yeh3qdaW3mwMcheG7R
	nw6X7lKREbZRRYRdGH5SDLFPuG1YhkM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NnTuw9Qf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9yAYd8D0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NnTuw9Qf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9yAYd8D0;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779725866; a=rsa-sha256;
	cv=none;
	b=LkhHcTx6F83JOEw/OAxYLKEcP6kXg+HdpJ8a+6//B/KQ6YsHjj5HjnT3BhaN2M6ipKh6QG
	pw2gzCmjvYQB5oFxfvL+o1SEWL3YA6MhF0XX/kcX/j/Yi1DTt0ybXl7ELwKTkMqPzohh9V
	DElpcKh1kfwQGXpF56aNcVSNirwmRKc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BE9D06B9D6;
	Mon, 25 May 2026 16:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779725864; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LiOhrDB5Siu3BTzKB3ll2nZPIejX17ixL8z+kYTNnLc=;
	b=NnTuw9QfP7qRtu2Fcp2vHUcRpfCDPlfel0Odrx2m+0NDQPjck4mgVNMbs4uoYUGxzZoO0v
	5V1kkbw+CDrwdCjYTS8Fo1NSl84SIozibO6xqnzX29Rpc4y9FeVI7ssusljL01vgsGrBK+
	aP58bM5ofqnG+wnRmVQOK/6ypGlJUWw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779725864;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LiOhrDB5Siu3BTzKB3ll2nZPIejX17ixL8z+kYTNnLc=;
	b=9yAYd8D0/oNcJBhN5rQ5AnAGQq7z/4JSzQDJidYmuem9vnfeYzSvD7oWP7sni9eRMOLXwp
	EIxPW5DxVLeI+5Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779725864; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LiOhrDB5Siu3BTzKB3ll2nZPIejX17ixL8z+kYTNnLc=;
	b=NnTuw9QfP7qRtu2Fcp2vHUcRpfCDPlfel0Odrx2m+0NDQPjck4mgVNMbs4uoYUGxzZoO0v
	5V1kkbw+CDrwdCjYTS8Fo1NSl84SIozibO6xqnzX29Rpc4y9FeVI7ssusljL01vgsGrBK+
	aP58bM5ofqnG+wnRmVQOK/6ypGlJUWw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779725864;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LiOhrDB5Siu3BTzKB3ll2nZPIejX17ixL8z+kYTNnLc=;
	b=9yAYd8D0/oNcJBhN5rQ5AnAGQq7z/4JSzQDJidYmuem9vnfeYzSvD7oWP7sni9eRMOLXwp
	EIxPW5DxVLeI+5Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B08C659D25;
	Mon, 25 May 2026 16:17:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fbEXKyh2FGpqHwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 16:17:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6D2D7A08D7; Mon, 25 May 2026 18:17:44 +0200 (CEST)
Date: Mon, 25 May 2026 18:17:44 +0200
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
Subject: Re: [PATCH 11/17] isofs: replace __get_free_page() with kmalloc()
Message-ID: <wxxq23pmklhklkmp6a6i4wfrzb4sn2wnvqlmmfeefbpbj4pmj6@y2k3f56igj3u>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-11-275e36a83f0e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523-b4-fs-v1-11-275e36a83f0e@kernel.org>
X-Rspamd-Queue-Id: 0D8728000A
X-Stat-Signature: brk6csthaqk98fytccsafir6xrdruhsi
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779725865-144566
X-HE-Meta: U2FsdGVkX19vU6b9ODl8JrR1dfQuQLSLuIwMMuzASEol62ajkLqpkco8DppIo+T7xtXsXOCgGqMw/pI80DRf3HcRL65BNu1gap3CUpFLlicu6yI5Ul/vVkpVeiaUAXDQ25o7WKuBND2sTz2Ytz0xVpQVU/W57/g5amgNaoTHd+UpHwClI6niRpn23YLCe2fgIrVZiAQ0gWxGrEVRImFSnYpIyuWsD8bPVJIkQw2w/iW34h+MFOFn5LtpPsAyvjXmDtWNReKzbfmPmAAt66iEFMRHKyUOwkBzdHpv2C7ajEocgaY+4j9YM67O0Fy7AXzKjf8WColuW+itra3rrovZmNThG+X+UncZmqybaI1ymbdrEU+op99+Tq+AB5be87oHu4E2A5c2zYlRvzGiWqbl7CK0mt1kjl89EW9VkYzc3scUyVGGMYZXdkjuSl/zO09+ru75vZ6oATpGT9VuqTPNjAdQ9aOJ8ydIACj2Q+Ol+pAj3aeU/DGYrl72ypLE02fJagnfhcpsma6cWoE0mAxkiqoD34eSQMS9NCqo133X9+HoVXuFRJHxZk3aUkNrSR7HHpAR3CxBehEAHQ1zPoaJ2Y9WIQ+tlxMnIjRW6qwHohlVrrLl9p79aYiU9l8v5L+Tv6hMKsh/NLj+xAVZBZWZPKI9hOW6EUC5vbXj1mIvYIy/x7zIXFvAX58EbCbOBJohqelUzvAtUQRH45+2GTdVioZS/Hm8TfJhtF9StrPk0NU7PudaMPHUPbToVE2ocm/HM0NFtFBh90AGvPLG00i0ldH3f9C97lBMBpFbHDa1GdLT/8fLM/fkzDrI/EqY2KiIUo0jG++IhTxCTcHPKEgznUZMLgomKBQYpCx8HKFlrflUlZfDGFy310hhAkI71bmdOavgC38sVHcanYjEd26wTVHvG1kk+et9vvcw1ZWjRy4CZbP+9CpCcL7sAfTp7NOWrAMS8HLG+BpM1Q6CxsJ
 FLSt+7pn
 eFfi0HWB+kuFE14hoVExlqtlyGFEKwYfl5US44R7cfjHllm8/l4yx9Pr7xjW49GMmvPYnpD4OPRtYG51KJt0Pxsx9fzr3SsYM6rbj4ReS+0Ao935N5It24OIhNx8nrn0ayZEXwbnZA/xC4O845lY0F5kPSWuMlD1xL8ZOngsmCv2syHkPP+lxXiJQxoRG8Oy8VVR6fGTbbP1KPB+umqJizsVk9Ou4W22l5P05UbRriPDxoy0gTBeSlqH7gkZ3I1BcZO6OctEFkaDgFrHAzTBpggpUknEr6r7z2DUVr3dvlfOQS/fMpBMlwt+FvxiO+8MyzGbCu7nRm555qNEHtb0EPlGRjU/P1opWVDltBvFT5Qv4s1rW1fnWCx5c9DpuiwCYNNjFn/Wbu0swS6klgFr/puBlPwRSI1d3YKN1VfizN3C5yogMlYMDtCCVUf0hqy8dPRtY42FvpEcPNw6oFozMSsTrzQXxvGT7aH4/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 23-05-26 20:54:23, Mike Rapoport (Microsoft) wrote:
> isofs_readdir() allocates a temporary buffer with __get_free_page().
> 
> kmalloc() is a better API for such use and it also provides better
> scalability and more debugging possibilities.
> 
> Replace use of __get_free_page() with kmalloc().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks. Added to my tree.

								Honza

> ---
>  fs/isofs/dir.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
> index 2fd9948d606e..6d220eab531e 100644
> --- a/fs/isofs/dir.c
> +++ b/fs/isofs/dir.c
> @@ -13,6 +13,7 @@
>   */
>  #include <linux/gfp.h>
>  #include <linux/filelock.h>
> +#include <linux/slab.h>
>  #include "isofs.h"
>  
>  int isofs_name_translate(struct iso_directory_record *de, char *new, struct inode *inode)
> @@ -255,7 +256,7 @@ static int isofs_readdir(struct file *file, struct dir_context *ctx)
>  	struct iso_directory_record *tmpde;
>  	struct inode *inode = file_inode(file);
>  
> -	tmpname = (char *)__get_free_page(GFP_KERNEL);
> +	tmpname = kmalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (tmpname == NULL)
>  		return -ENOMEM;
>  
> @@ -263,7 +264,7 @@ static int isofs_readdir(struct file *file, struct dir_context *ctx)
>  
>  	result = do_isofs_readdir(inode, file, ctx, tmpname, tmpde);
>  
> -	free_page((unsigned long) tmpname);
> +	kfree(tmpname);
>  	return result;
>  }
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

