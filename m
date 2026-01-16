Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 127BDD4660C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793836B0099; Fri, 16 Jan 2026 05:48:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75ACE6B009D; Fri, 16 Jan 2026 05:48:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 653086B009E; Fri, 16 Jan 2026 05:48:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51D056B0099
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:48:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 102D31405E7
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:48:12 +0000 (UTC)
X-FDA: 84337502424.27.96E4CE7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id D04AB40016
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:48:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PbmhajUM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=daVLxafa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PbmhajUM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=daVLxafa;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768560490; a=rsa-sha256;
	cv=none;
	b=Lqs9rFXgTfHujoC5vta3moa9ouswmExCBfru7ZUQqgxucxW1SXFWomoWcuRQllItMTdH+t
	0tGscaScFx/B4rSwsGneWt5DiTMEKdH/n53gk/FGr2+VyPCYbnBGuFIuIEbPMYPrGqsb4p
	WWkPe1nRUZL56ZaI2i/DrtsvvJLeRtI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PbmhajUM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=daVLxafa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PbmhajUM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=daVLxafa;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768560490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F1fxP8WDQyzhf1npSWxiq5MSReyQYyy5v76FcnijHMA=;
	b=1b4RGeGR6VG2MnuYxioZY4cPneYSIstjKFb2H54JzOWtRuQY8Cw8TEHKYImY3eo3pPGfcD
	qtHAip4Wz0gexMBNsSXUNjnPddAcFpdvDZy7hhJiCeyToQqI5NL+UfqDX8nPFiwBCXodzs
	wrCL3E9GvQQSjURdGXxY/ari4GK1Nms=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7BDE25BCC9;
	Fri, 16 Jan 2026 10:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768560488; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F1fxP8WDQyzhf1npSWxiq5MSReyQYyy5v76FcnijHMA=;
	b=PbmhajUMmbJ8yRqKOVcww99WPrHziWw7DJMQxlzN0jGmHXvolDfWqMrMe7DmnKsFo8MwIx
	YI1GJP6PN1rQu3cv+ABZlCU4JBshwzNdZywyZzYB1HQeePrkqHz7Tg+xZ/Ry58tIaNT7Tc
	xATB6hj4wejZpWh6InyHFn4HPINO8r8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768560488;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F1fxP8WDQyzhf1npSWxiq5MSReyQYyy5v76FcnijHMA=;
	b=daVLxafaELeJjfY/n1Wb6KYXPmr+VqfyON78bEDOVjmCPDiAImJK5TAGZlvPs0fY4icrbC
	yyouaeQgwAqIPRBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768560488; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F1fxP8WDQyzhf1npSWxiq5MSReyQYyy5v76FcnijHMA=;
	b=PbmhajUMmbJ8yRqKOVcww99WPrHziWw7DJMQxlzN0jGmHXvolDfWqMrMe7DmnKsFo8MwIx
	YI1GJP6PN1rQu3cv+ABZlCU4JBshwzNdZywyZzYB1HQeePrkqHz7Tg+xZ/Ry58tIaNT7Tc
	xATB6hj4wejZpWh6InyHFn4HPINO8r8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768560488;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F1fxP8WDQyzhf1npSWxiq5MSReyQYyy5v76FcnijHMA=;
	b=daVLxafaELeJjfY/n1Wb6KYXPmr+VqfyON78bEDOVjmCPDiAImJK5TAGZlvPs0fY4icrbC
	yyouaeQgwAqIPRBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6C53C3EA65;
	Fri, 16 Jan 2026 10:48:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gWtkGmgXamnWDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 16 Jan 2026 10:48:08 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2EA03A091D; Fri, 16 Jan 2026 11:48:08 +0100 (CET)
Date: Fri, 16 Jan 2026 11:48:08 +0100
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
Subject: Re: [PATCH 24/29] isofs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
Message-ID: <o7p2kfxnhexpjpdwuqexjepysef5xghk7pnft323zyzvligstd@mdauljykdl5i>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <20260115-exportfs-nfsd-v1-24-8e80160e3c0c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115-exportfs-nfsd-v1-24-8e80160e3c0c@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D04AB40016
X-Stat-Signature: 391r7k8uu3uors67onby6go8n9txwmw5
X-Rspam-User: 
X-HE-Tag: 1768560489-463733
X-HE-Meta: U2FsdGVkX1+lsiXpOZu0kSu6SBC9XugHiJKhHAVfUqvs28nVnSDvqVD2stMuMC4dQ2RIo6YIT28j3LURZhVtheGxJrjqx+a2/STs1J6NivFqnt2dtRBDJHStPVF+GOyNUOvE4Hc0Jkzfpn09vqmtikCrG5AVxzgiI9FUOsfFYHSJmcknO4n9pupL2HtztwMu4HVN0tay5lhBrkqbOJr7PUZQO41M4KjH8mL23GKcaWctLxmTXwEfCCgq51B1J9SyOwVXEzkbdRl5drbKZOWKgnBWwbDCmoS6eYyNTSi5NASn9jF98xqkSjyVFAAjPp0pboMdC2fIu6UnaD9N5XVcI9YIvHH6mLodSPODAzIHU3hDDfZa7c3eTbNUsEpzQlEjRdcEdki1SCvUaeYgkpRX3E4tO3Aiei176WDyn3afvR4/LtMT07KCfiHRg/I/ILqg1MOC1OzAlxVr6HwGbzkjSxxALBxMe3DbLqpYAsifDufEV+Ev8J/rCp9B1Ki4qKQFNtChsNNU9qO1HBvh8hLyH2BJinI+1RoCP724jBvzxOqVkUdOcDfUyzxnp2sEUPMTnsK1AL526/ZMHo63+ZagVqGUjRJjPyxj28VsXmnnhCsbTd+XOxHYA5qEIDZitn2txV3WUEy5w6w918tsGCdKSoxLOxtsOvcrnRpyfH+UJvV9/pXv7w2gLdj6gcSbOKvzvS9z4hflmGt4UKJjEG59bofGN02OyrYo0W6BIuxXV/h5P6XxK0zEkKGsmt47E6x6lNZ/JeHt8oW3bKOVzGcS23/k/TtcxfvJkGDBLps34Et59Ee8ZP8dWRf1j3ivVTxDc/m3LtoDbRWrf7cw5u0p5pa0LEq1s9LQzRxLW1e9IZH968Ldl4H6wwom3sTjHMc3ur9wlIWBfC2FkmVWq8D+7LhWRj3nIbs9VR8T5OTnnUbfYwf0KZ1wMYTdQsFXp2tJbjN928lGmsmlNTojkTW
 F28DW8MX
 ixyswtXQMQ0mvOSZb9K1UcCJNnw0uShocU1CdAF4gobxQ2bnS544D8hNl94kIGFUYkRArKaTuA5sWsz20hJ4tAODF5RswJBqwZ4llavoDRsZUJEVcVcP9KLMq0LbATtxzRmwhLzFSFzxVfwvqwI6oHXw+szgcjSwlmmo5pQhZ8FE+tIfLmqWQx+IHN1RU7dExMEMuDbnBd4T/DTqYtZjFp6V2qPpSzBBmqiqaVj4JLFdilMb5AjvEyHZwVytnNKRynlWKH1AkwOfkflqdVaQ87X9hitWYAz11MZAUAIi+gwYjxzdrbjSQ0dCaN5y6COU0uKWySGtfkrk/CbBnDOx1zmgEDPgk6BTjv+LOb4RXSseXc2Z0rPL3QxP8KE9H2BMm15RlWeYFBqQJXwHFFtwQo3nPHoFCODyc8A9DiOjUZwud2SMKIsQidRkdJ2LsGkBYM1DTRpzWnG45dOLD4aF4HO/So5E3VSr++jiD8l/Le+fw8edtbCyU0N/FsXj4FZu8K33ukSc/pGWyUg9MhQ3KmBcFusd8p1zIwt+cgSVG+YFoKwFmLlf+aDczrsJYoH7PoQrzRLGQqCXq5IRV7hucmrXnBbIqSfDOGUuI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 15-01-26 12:47:55, Jeff Layton wrote:
> Add the EXPORT_OP_STABLE_HANDLES flag to isofs export operations to indicate
> that this filesystem can be exported via NFS.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/isofs/export.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/isofs/export.c b/fs/isofs/export.c
> index 421d247fae52301b778f0589b27fcf48f2372832..7c17eb4e030813d1d22456ccbfb005c6b6934500 100644
> --- a/fs/isofs/export.c
> +++ b/fs/isofs/export.c
> @@ -190,4 +190,5 @@ const struct export_operations isofs_export_ops = {
>  	.fh_to_dentry	= isofs_fh_to_dentry,
>  	.fh_to_parent	= isofs_fh_to_parent,
>  	.get_parent     = isofs_export_get_parent,
> +	.flags		= EXPORT_OP_STABLE_HANDLES,
>  };
> 
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

