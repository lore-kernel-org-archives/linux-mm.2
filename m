Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8E11D47CD3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E2B46B0088; Fri, 16 Jan 2026 05:47:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A9C36B0092; Fri, 16 Jan 2026 05:47:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369DC6B0093; Fri, 16 Jan 2026 05:47:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2497F6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:47:11 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ADE7D59B47
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:47:10 +0000 (UTC)
X-FDA: 84337499820.08.01FA60C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 695751C0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:47:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2hcr2hsL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yetHVfPV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YNI0fP0u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=a5rOcxSP;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768560428; a=rsa-sha256;
	cv=none;
	b=mueY7s7UBVzYZl/p9HJdyXeXmrhuP53B5/2ZNLfsOJq7aohqwny7bL7D+uq8IWy1Km8s/9
	E0zYxGRAxp0gPAQGfIbYZbf8LJ0awD84Q855diJZOBDPj+dI7SUKj5qtYJttFv44BQvJha
	sNFzysGfBqaU3wWf+mOft1yObD2gNIU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2hcr2hsL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yetHVfPV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YNI0fP0u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=a5rOcxSP;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768560428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nhQTtNIBA2tMcAjaR+HOsu/vm0Hf5La0b3bvYJ0Bq0Q=;
	b=uO+A+SlY3r1oMXOUGy8B4pWnxGKQmOemkKyBWT8g0pIqEigF/aG5fFK0JlVVw6EW4MS/xJ
	ptoY8bFnS1bOBJBzFG0M9m9djVLVK9FK5Hq61wX551O2FM+zxgssERZ4O+KvDhFQWmjrnU
	PXaiCunKqU9NN+rqVaFXpRfXM0iSCzE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CEAF75BCCD;
	Fri, 16 Jan 2026 10:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768560427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nhQTtNIBA2tMcAjaR+HOsu/vm0Hf5La0b3bvYJ0Bq0Q=;
	b=2hcr2hsL5eFX1fbXp1esYhEhUHrr21EVahAExf5MvMYukY5mYzW/TEGzFEWyqdRUTE9h3k
	mL6LVUJ3th5LUIIq7c/DrGjVH01KFmvPxdxN0VEb318letI72UaP8m99FGdVni21nQSf1T
	vfQjCvR8JpdcwX3xPuiF+zckuiX14LU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768560427;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nhQTtNIBA2tMcAjaR+HOsu/vm0Hf5La0b3bvYJ0Bq0Q=;
	b=yetHVfPVsMQQbQ4pwk/qwZxPnG/cgaKCSc+he94LlA5ir/TQMhSt2Mn/ddyQwhde2L0+lB
	vTNVuJzIa9pkq7DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768560426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nhQTtNIBA2tMcAjaR+HOsu/vm0Hf5La0b3bvYJ0Bq0Q=;
	b=YNI0fP0urTRgtxJoSCfeUDrSdRBDW+XOtZy+WyI6aJLZbveCQ8D9BiVP/Bmp2UpLMEuUdU
	no9nkHdMplocYIUdSsacluXs7LRoopl9pF7Iw6Sato7ATWNy7CVc27FuQv4/CXzkzwh0JR
	N1qo4myI2M6eo5/0nbGCZOekXbwmo7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768560426;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nhQTtNIBA2tMcAjaR+HOsu/vm0Hf5La0b3bvYJ0Bq0Q=;
	b=a5rOcxSPDJ+EC0mdImqiF+5FC+KRZ0k75kuCS7KKI8PPCf8uePpaPiihAOCbbNB/esfW/l
	OfbspTnn3TEZkYDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BFA523EA63;
	Fri, 16 Jan 2026 10:47:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id paDCLioXamn5CwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 16 Jan 2026 10:47:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 850C2A091D; Fri, 16 Jan 2026 11:47:06 +0100 (CET)
Date: Fri, 16 Jan 2026 11:47:06 +0100
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
Subject: Re: [PATCH 12/29] udf: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
Message-ID: <c6qrz6ioenic7y2mxlkkvu4ca26scsjvbn23scgud42fvywvir@udtb4xkl3vfo>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <20260115-exportfs-nfsd-v1-12-8e80160e3c0c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115-exportfs-nfsd-v1-12-8e80160e3c0c@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: k8gkfjmb1axxyapjygemu7bhrg5aexz5
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 695751C0005
X-HE-Tag: 1768560428-415675
X-HE-Meta: U2FsdGVkX1+pTO7JxTv5hWYF/2W0zt8ukIsjAdtZmubatFv+kLbsl5KlDBqh3MFJeJN/TcYDT2UbFsn8pfZkcqd+bBYNhLSBkcBu+EfPiiCaDMuUrEZo48p+6jJWkiDbPFazHFHrEVEUjrg9gCTS++q10olKJjEeNFhc7G1ywe4xYIUvvxtZIcF9TEmh6sk+4f0yqDh08mCqvQsRGr8HFrbJBfRGYBY+wUX13sCQuh9mM6oymxHLcmR1LpIHAKFB7uXmNskDWLkG4OnqZ3NxQ4taXoEBZrNUFjUYvIdHwFeZVMyIbTrCeAw2FHr/9BUlw7RjSBvaAirbh4zwAjQ4Rs4yZA4s9FztjMQrO+4EdqitBJm89YJQv35x2mU3JpjkrStPR76ATXX2Cy4usoB6YTotgrH7/BZOqQ8l5TybW+bZpFvAvQ0IbwqZtSn4wtil4Nr3k/i/2DNq8fH7lWpL4msaWw83/l8E3KcrKTMgauzwOCFFd9OtdRmp4V6llXGwIU32KCRmq6BLMyx3/71M320suHk4jBQdKYGD7IaCIyCJOAu+Ni1+cOH/djwPqWgABspxjYAfroabk7Wr02G24fmRnnsSbP2fYU8NPGVy58idkevA4uUn2PIQEUjvoryzeKweeydhTR38LjMnK7s8idX5Oz4YXBXEFmTdIMK5O8iAm7x/stcLO7wVwIr3uGP+GHFYjvVl7ktnR6vDdp/TK6+/o0FyC6v59MFf5eSh6GKVWdW3JzQunZy+nhfdWnApiHgkxxxe0GDm1QKt1JGYBhqYGvJjRF/6W1LxxNBYCfMjCc9UY5Mg0yl0UNDmHLcpIMi/PQHS/MybyXa6Uohhx4QodgX5h8m0DqKTdtpN1EhrzYVeuGDoC3bFv6Sv4/nzr2vV4nGc9TvImRPevyWUTwq7rQWf/70SpDyZMZ1rG0pNMW146Hge35qydTgX4X1/PxLyT/X3YY5/IVrChCk
 KfnPV9V6
 TpRH/41tKdNKM1MlsV4KKcgmvM8WJT7keerMWNSpNFGodJV0l1+GMeysn8si37dcoS3/436738Vm2l0AdwAo827YpFCOru5Y3qFaReXBdFwzCfV7VZjDhe2MEIrYtQpmUqpQUQi6NDapbnPpTBfyx9AXzbaKZLAtWfLj9ISHYdgmtv2aUdKUtP7yfUK+RB/6SpvTsYqvJGwrRsL+HAzGBP5Hd73ASJe2Z+APwC4X7CVKVpciOdiBt+MT1wRl5JYbXvfoK0sqr0kWhr9TcD42luMl68Gx0u5c4PlGpuKJ6otsa6ypvxaTk7vknTjC3EClbxToFKtuJF5nbQs0PlQU8ofrSNWwMKYS4El1wDnxDZqp1RUm3K2HB/RKZsMoFWtKpzOaJwm0YbraNrTLol2nW7jGb+dGTdDv9CIriI54qUS00eNpP3hxnmHGWKz58bdzTceMuiRdD++rZNriEhsDyJV9Ysivo1OaRA3Y8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 15-01-26 12:47:43, Jeff Layton wrote:
> Add the EXPORT_OP_STABLE_HANDLES flag to udf export operations to indicate
> that this filesystem can be exported via NFS.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/udf/namei.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/udf/namei.c b/fs/udf/namei.c
> index 5f2e9a892bffa9579143cedf71d80efa7ad6e9fb..7b8db8331c77bb43d9a3c4528aee535eac2bbd37 100644
> --- a/fs/udf/namei.c
> +++ b/fs/udf/namei.c
> @@ -1012,6 +1012,7 @@ const struct export_operations udf_export_ops = {
>  	.fh_to_dentry   = udf_fh_to_dentry,
>  	.fh_to_parent   = udf_fh_to_parent,
>  	.get_parent     = udf_get_parent,
> +	.flags		= EXPORT_OP_STABLE_HANDLES,
>  };
>  
>  const struct inode_operations udf_dir_inode_operations = {
> 
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

