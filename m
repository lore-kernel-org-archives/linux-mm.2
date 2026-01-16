Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EF3DD4660C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37EB36B0088; Fri, 16 Jan 2026 05:46:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32CA46B0089; Fri, 16 Jan 2026 05:46:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3756B008A; Fri, 16 Jan 2026 05:46:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C4EF6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:46:01 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E9461405E2
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:46:00 +0000 (UTC)
X-FDA: 84337496880.14.48E2A34
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1A042C000E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:45:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="NM/kSQUl";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YPA70NjZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="NM/kSQUl";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YPA70NjZ;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768560358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJuLQN1/VqCQ5MzAXUwztUOsWD7c/6Ri8BvtTGrLxeQ=;
	b=caSarUe5tkRRIvtb65TePgQjgC0HlRVYsWRqCyKoPkG8YdtNOo+C+klVIGcq/5VhGvhTE4
	mi5kIoDxrB0g4OQn3uMGN+GAv4rFlemWRed5UghXyPqQ8NTi/2sDkAqwJrwVUaVQIdKsQi
	KcauNop8Ok5w9iVbmfWVKNhXwg+iam4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="NM/kSQUl";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YPA70NjZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="NM/kSQUl";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YPA70NjZ;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768560358; a=rsa-sha256;
	cv=none;
	b=69Gqn0sCuxHRhu2ENUt3WhKvyXIn4+cGIHTySBWpFa1MfL3iZ09E2MBNf2yxYt1HszXiuM
	ybUmVb2zy/xgb1e622mlyP2KfURX2gOSDZwQuRFz4Y4ULsgd4V+ZXG5JUrDGZSaJ9E9/5U
	ibv85hJ8ATyjSzCBiRyPqMte8d4fGGI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A863F336A7;
	Fri, 16 Jan 2026 10:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768560355; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WJuLQN1/VqCQ5MzAXUwztUOsWD7c/6Ri8BvtTGrLxeQ=;
	b=NM/kSQUl/op+YKS2s6eKZXfE9Glh5kkfMDr9vCIJsC9FWe94PjEgFUboHs0ZKmqO49bUWq
	GGnb+NiraWiGN0Yc7/GMi+PXcDAXYotsEPDcTaiNspuD+pdYjp5VDufc+cwlF6YloG+qs3
	uSGr4retqv1mJn56UXxhwHQeZysiV4E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768560355;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WJuLQN1/VqCQ5MzAXUwztUOsWD7c/6Ri8BvtTGrLxeQ=;
	b=YPA70NjZ53LaWpg1U5dSvh7NjJzYXWZLUEwmMsCnm1ykEpF60x4KxRv4KCQctMxjo+19kZ
	QfNXpE3F5HGTWWBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768560355; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WJuLQN1/VqCQ5MzAXUwztUOsWD7c/6Ri8BvtTGrLxeQ=;
	b=NM/kSQUl/op+YKS2s6eKZXfE9Glh5kkfMDr9vCIJsC9FWe94PjEgFUboHs0ZKmqO49bUWq
	GGnb+NiraWiGN0Yc7/GMi+PXcDAXYotsEPDcTaiNspuD+pdYjp5VDufc+cwlF6YloG+qs3
	uSGr4retqv1mJn56UXxhwHQeZysiV4E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768560355;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WJuLQN1/VqCQ5MzAXUwztUOsWD7c/6Ri8BvtTGrLxeQ=;
	b=YPA70NjZ53LaWpg1U5dSvh7NjJzYXWZLUEwmMsCnm1ykEpF60x4KxRv4KCQctMxjo+19kZ
	QfNXpE3F5HGTWWBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 965853EA65;
	Fri, 16 Jan 2026 10:45:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6CqxJOMWamkVCwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 16 Jan 2026 10:45:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 30814A091D; Fri, 16 Jan 2026 11:45:55 +0100 (CET)
Date: Fri, 16 Jan 2026 11:45:55 +0100
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
Subject: Re: [PATCH 01/29] exportfs: add new EXPORT_OP_STABLE_HANDLES flag
Message-ID: <6bajjyslarqrjr2brzyy6bgrmqrdxyhc42q7pfmz42d4y4kjtn@fod6fi4uf6qv>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <20260115-exportfs-nfsd-v1-1-8e80160e3c0c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115-exportfs-nfsd-v1-1-8e80160e3c0c@kernel.org>
X-Rspamd-Action: no action
X-Stat-Signature: t4pooe691wfuu6m93334fgtytb7ejknp
X-Rspamd-Queue-Id: 1A042C000E
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768560357-693597
X-HE-Meta: U2FsdGVkX1/35hYMlP17OM5o5z2PSvbw3g3bagzdZJSkVnKxdxAmcdQrtfcEtOQwG9Ss3v3HieEhs8YpLlcOf/dWwzqBwsDYx92wnyvgbP6k1oOF3bWrmWtjYHLjiO8jKGku66364gjlChaR0RsZqIEn1NpJSME1dRLnNKXFj5l9/Zr12eKSCjJQGXwxoy+gmpTMQ89fTjsRNk45gQCb1i2CcgjCfUAYkjUYW+Zvh6ody20qcav5Nk7ACYJ0tu/ZzxdQIlzfOFlmJcCZ6kVBN+iOBUQ6INyLxxaAo7Wu7oefY0OYw+kO9I2SeYxDYA0jgwTK3PMyZkzoppUuRK85qwivpu0e74XlYnunM+XD9Ups7bSbvkQgnq9R3KLFvffNWiCZtcJF7geSNV4sCb2K9k5XXBGg4+Ws2P47B+FSgXDapT/PkuX4RgghOFVB+YEiB761MEkjNnz1br3crK/EMZn87qaBDMB5PN4hpucflUWE2VoSg2aLpRYrHpvt5xCdAROM9sQDRw7hroJBw6VoeX102PMwBi85F241Za0yQ0iiK5Zlxi9MUXf5MpTiNUQ12tdwExZdN8cGAb2MfdC0IpHMDzlO7cGxiqis82XXc48Y24D96+wUiUOkp80CqUSHJQGEEi2yIA0xiFuROMS3muh3JSMkaFshteIvxFJ9Oee9kVdgBK6GeNav9/oKQYt0bKek1j0tdacaVfzfyE/f+aN+YSKS7nk+TXuL468cRcq2Z1DUbh9RI3I8FG4n+YbcrwYLsDQBSWRah/hye6aqmG3XsBD7D3fdihJ22M2dKa5QFLLPBtDjcRPyO3b89/IWy+g2Sj1CuRHgXvZyFRYAsPu+bY1kvhA/XAAH5RboyMYe8FCYdf39MpWmx6+WwRPwUoNWqtwnoyoZH3ODPjw8sBmzgmW8pua6EJQQSRGHEh3WudYIEjq0fIUTxe7Cv0/U5eCo+uT17mzr8ebX9jP
 en+ThlJV
 aBuVY8MtOmIFSIT033DXhhhz7+Do/cf9Ush6vLCsqSsJdByQWLmf+BPyGPb+UjVQvXfY7GjBlGtByfNKVEdrLdahelewIn/107KbQkxTSO1kpImHA7Pve0sI6CHIYZS/MUdl1Nf7zLApg4kGy6QoJzjvmSO2TtiL3jIbS4RrFAKyBEqyuUAAXz9soU37vUsZBPHLyDFSUnJFpz0LL3CHpit9U+V92l9H/5rjyuqeIgJ6icJ4YNupgRZEnxXAtr5aEv/VvuPn88IMFbGVNqgOzopV9M0xq0W2JAdvKNeLEQuxKC4lpMvhHVfiwKIsaPwH6KXdGskzvJxERyIW2mrpiNWHvekli8dOExxRaDohdw560D/8KHJKUxB8EsaVQRYsK2M6itZtXxnW8YfX+u28YEO3kLB+kEbuplHuI+1z+QToYNb/pasZrXAWSGXBN1ByG8tqtwJ/tW0zJ2mYOZEwcwYr6b3NP7qZrBXD0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 15-01-26 12:47:32, Jeff Layton wrote:
> At one time, nfsd could take the presence of struct export_operations to
> be an indicator that a filesystem was exportable via NFS. Since then, a
> lot of filesystems have grown export operations in order to provide
> filehandle support. Some of those (e.g. kernfs, pidfs, and nsfs) are not
> suitable for export via NFS since they lack filehandles that are
> stable across reboot.
> 
> Add a new EXPORT_OP_STABLE_HANDLES flag that indicates that the
> filesystem supports perisistent filehandles, a requirement for nfs
> export. While in there, switch to the BIT() macro for defining these
> flags.
> 
> For now, the flag is not checked anywhere. That will come later after
> we've added it to the existing filesystems that need to remain
> exportable.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

...

> -#define EXPORT_OP_FLUSH_ON_CLOSE	(0x20) /* fs flushes file data on close */
> -#define EXPORT_OP_NOLOCKS		(0x40) /* no file locking support */
> +#define EXPORT_OP_FLUSH_ON_CLOSE	BIT(5) /* fs flushes file data on close */
> +#define EXPORT_OP_NOLOCKS		BIT(6) /* no file locking support */
> +#define EXPORT_OP_STABLE_HANDLES	BIT(7) /* required for nfsd export */

The comment "required for nfsd export" doesn't quite match the name. I'd
change the comment to something like "file handles are stable across
reboot". Otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

