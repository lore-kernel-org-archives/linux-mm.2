Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A28D9D47CD3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12D016B0095; Fri, 16 Jan 2026 05:47:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F3A46B0096; Fri, 16 Jan 2026 05:47:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 009476B0098; Fri, 16 Jan 2026 05:47:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E2AE26B0095
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:47:31 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 85F185993D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:47:31 +0000 (UTC)
X-FDA: 84337500702.29.C85515E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6C3FC160003
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:47:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Ftw/w48A";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/0mnXymQ";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Ftw/w48A";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/0mnXymQ";
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768560449; a=rsa-sha256;
	cv=none;
	b=xybm4J+5qV6ryjxfX6yT2mXKDob6XIHNnRsSIcKVLRRloK3IksVL2hjHhHnBAlHjcZy04q
	GrXs1VZBL4wzWk3aHdWbsHtl3tfV0jFChY29qR8WVb/Eaq4xR4x0lOJ8tG88X3l3hjDn9P
	O33cqKcxR6LgbIIiFjJquwn91LD8zjM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Ftw/w48A";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/0mnXymQ";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Ftw/w48A";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/0mnXymQ";
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768560449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2lMC4dV45oi1mlY5BXp8fQKt2SNPdaLd6Ilt8JO+JmQ=;
	b=LTMHjGMR2d9DfbMtnLBxCyrqdl7XVklUCxBOnts3eJqgZDgA9Q6bMkGpP9+AcmfQUA/Koi
	iYRkzSNLT3urfV1AoHm3SUDftn+OaHmp0xuVNm89UtMOUs6GmHy+DEOB2Z1hvz4DFBMqF9
	93N7JgNYw8p0PrvASMxvyOU94vQy+q8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EF1155BCCB;
	Fri, 16 Jan 2026 10:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768560448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lMC4dV45oi1mlY5BXp8fQKt2SNPdaLd6Ilt8JO+JmQ=;
	b=Ftw/w48AH2FIze8c5NCpGY+5XO/vnHkjGCmtVV9PTeJB6y2k7VTfqEVHahDLJnyaun4vrT
	jZwEXiGVCIwZUyt3JbbArZXWmWmE5e5aZEA1Gruu+xovaSyAFw4iXisViVzre8n7BBI/TR
	X0JT5TV78n0RM2yYJOHbOFg0cunt5rE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768560448;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lMC4dV45oi1mlY5BXp8fQKt2SNPdaLd6Ilt8JO+JmQ=;
	b=/0mnXymQoI/apVzzXrkGOFLQrtf7ARYoukgV2ygH5/30E/hcAH6PZ8LZ8kwGADlW1g3sJT
	6D8IQPk6mXId1oDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768560448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lMC4dV45oi1mlY5BXp8fQKt2SNPdaLd6Ilt8JO+JmQ=;
	b=Ftw/w48AH2FIze8c5NCpGY+5XO/vnHkjGCmtVV9PTeJB6y2k7VTfqEVHahDLJnyaun4vrT
	jZwEXiGVCIwZUyt3JbbArZXWmWmE5e5aZEA1Gruu+xovaSyAFw4iXisViVzre8n7BBI/TR
	X0JT5TV78n0RM2yYJOHbOFg0cunt5rE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768560448;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lMC4dV45oi1mlY5BXp8fQKt2SNPdaLd6Ilt8JO+JmQ=;
	b=/0mnXymQoI/apVzzXrkGOFLQrtf7ARYoukgV2ygH5/30E/hcAH6PZ8LZ8kwGADlW1g3sJT
	6D8IQPk6mXId1oDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DF7B83EA63;
	Fri, 16 Jan 2026 10:47:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sMCYNj8XamkZDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 16 Jan 2026 10:47:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A8D37A091D; Fri, 16 Jan 2026 11:47:27 +0100 (CET)
Date: Fri, 16 Jan 2026 11:47:27 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Chuck Lever <chuck.lever@oracle.com>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Amir Goldstein <amir73il@gmail.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, Phillip Lougher <phillip@squashfs.org.uk>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, devel@lists.orangefs.org, 
	ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, linux-nilfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 02/29] tmpfs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
Message-ID: <epeo3w56c33kgxtx7jj6xyjl2gq3n67y6eqq4jlxfvg2qrgjod@3fn2xqpb66bw>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <20260115-exportfs-nfsd-v1-2-8e80160e3c0c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115-exportfs-nfsd-v1-2-8e80160e3c0c@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6C3FC160003
X-Stat-Signature: cfashxbh8qcod5cshtmsrmnu3ot4zf5n
X-Rspam-User: 
X-HE-Tag: 1768560449-111722
X-HE-Meta: U2FsdGVkX19puvjTMpo8Br5l2uBlHgW1gEcgC7o+Wz8Uj4JjKylI+PWaK/xNqVxgxvBeXRSfz/BqgF/idFGS2lRDsSDGSkSOkk/WHGfEd/jI8hrIZRu0YoIb9gOReK00575TczsxTJOp3VROiJCXJwKjDOGS+HxXfCu6XtRSOD53RH32pnM9gNd7l3+Es87moEJ2sfDGUk9dVA0+zEzjXxQhA3gW5+LthelcIAy1dfeLirxpYqXMxjtA/UT76n11fK8X6OJ2SYQWx+yyIJIQWyhBs4aE9Gm81hoxhHR9ASA3MHeIETB+meJ6gSF2uQPrwZESFzhmWRqm4bmjWHnEJ1usH+XxQ0xEwDQGF6tjiIDdWH9EqV8kyjBHq9SbDB3cvbtN8LvEg2W98c/l6LoJh8CxJ/tiPwvL7CsQQ4Bh/TGbus6dVO1s9Oa7fvc06qzdtxFkaTSQJnQk6ouJPQsx+lShSbT+fzABxVGmsjLqXxkEBCIsI12UIbdeiQX25rYrFp60fajKcI/qdpmh503ircblMhQ+o30V0WfOp74rGXM0EIHGmQeO+lg7NQ/vm3x/xgKUBLhIIIBy0YOXC8Z9O0eIpqk+JAvbCL2Ka1gk4ynFAr8R0zm5p86JGLP1E1utN1ZKSAAeJvRKVJtofWNLH+y072xktkw3VtnqgkTjl3kuWYz2YaqRclJoKZRs5+jcreBJBjRefrghYxgMfPwPKZRTPJWAB546RTpZClL6qKC6Qev7EX0gdqsuED5x0GF7AxdDtI5/2ZJLAyY+e3kq90j9CCV6yJ9amJq1FV/ZnoF/32V27qIgYKh5QfdHs2Ua0ajz8drTMruuNbqiWH8YVm7bRUD+srPchVNMRcYFUlAUqu2p4yuQiQXxuOO/npb55Z2kQ31+6oCu2GWugmmt6BlWp/gApLQvOAyVZdULRNtLyzgY1kHAi119vuXTkZ166k9YPVOKMApdVVdSQKM
 mz0xLlZK
 hvDVn7Jm5WIf1NvpDNoYjsyojgJUFvTvbRSyOmow+7846ubOHHYbQQvPqsDJwnsVwAAK9Od6BueeQmZI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 15-01-26 12:47:33, Jeff Layton wrote:
> Add the EXPORT_OP_STABLE_HANDLES flag to tmpfs export operations to indicate
> that this filesystem can be exported via NFS.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/shmem.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ec6c01378e9d2bd47db9d7506e4d6a565e092185..c64c4410b4fd9961599a5ea768b469d8184e713e 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -4477,6 +4477,7 @@ static const struct export_operations shmem_export_ops = {
>  	.get_parent     = shmem_get_parent,
>  	.encode_fh      = shmem_encode_fh,
>  	.fh_to_dentry	= shmem_fh_to_dentry,
> +	.flags		= EXPORT_OP_STABLE_HANDLES,
>  };
>  
>  enum shmem_param {
> 
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

