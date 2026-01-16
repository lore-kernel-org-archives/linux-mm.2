Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41524D4660C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC0596B0088; Fri, 16 Jan 2026 05:46:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A739A6B008A; Fri, 16 Jan 2026 05:46:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96C3B6B008C; Fri, 16 Jan 2026 05:46:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8864B6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:46:34 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 33E7C59AB8
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:46:34 +0000 (UTC)
X-FDA: 84337498308.05.008B314
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id D98241C0007
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:46:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0mRq6Rxl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kCQ2Vfii;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0mRq6Rxl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kCQ2Vfii;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768560392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uP1q9Ovfy/E+Cb02Q5R0pXn9SOKljKsu1y7iUqVaCJg=;
	b=czM8Pdzi3qT3CKe5TVwojwaYuUv17U71hdi6Bq/I2HPbGXBGhEZnMIWSgKbUFhoAhaBVKD
	vdpJvL+ffbKu8L224CNCG6c3RHBbiDNdsS3qwu3aHRl1CphOScMBiynBqxuLL2ruSIMEeb
	ZmYO+OYwhHXs7KX97ekzDV38/7uEAzo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0mRq6Rxl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kCQ2Vfii;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0mRq6Rxl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kCQ2Vfii;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768560392; a=rsa-sha256;
	cv=none;
	b=LnknKZf7JYb7Jum12mo42Y0t4hTuQumeJlE3NXOwqeYZjID/pFhZ/NbZe6STlDMRcwz9QS
	pyz4tHj9hdl2IGoMMRTNkEa/RMtvfkwAi8O46vatmlZ/8ZUzSzXWSCt9Jgdi4Usx+cSgDb
	H+TwhMKJEPoJLSQat57vWwx2GGHtjkQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2ECD3336B1;
	Fri, 16 Jan 2026 10:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768560390; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uP1q9Ovfy/E+Cb02Q5R0pXn9SOKljKsu1y7iUqVaCJg=;
	b=0mRq6RxlS041cU28r/V0rH2liCE+HXIRHLEQk7V6v25qkNoSrSb95EvqfcEYtA70/qpPXn
	XqE5rgqfKQ9BlV11BMkJemRBF9ahXFNjYlxtCMXyREmBTv+S0pi2hgcekcP8ARBR3Wz5CS
	rWCkiSDOxS+pn7MUFzee2xtcJiv43Rw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768560390;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uP1q9Ovfy/E+Cb02Q5R0pXn9SOKljKsu1y7iUqVaCJg=;
	b=kCQ2VfiicHiIqbHfnNCsi7dmRDgCLtDQumWsVhBj1o/P/fPEg/QLxVCwJPbocJYikftmzf
	MNjNjJFwZUJp0iDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768560390; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uP1q9Ovfy/E+Cb02Q5R0pXn9SOKljKsu1y7iUqVaCJg=;
	b=0mRq6RxlS041cU28r/V0rH2liCE+HXIRHLEQk7V6v25qkNoSrSb95EvqfcEYtA70/qpPXn
	XqE5rgqfKQ9BlV11BMkJemRBF9ahXFNjYlxtCMXyREmBTv+S0pi2hgcekcP8ARBR3Wz5CS
	rWCkiSDOxS+pn7MUFzee2xtcJiv43Rw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768560390;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uP1q9Ovfy/E+Cb02Q5R0pXn9SOKljKsu1y7iUqVaCJg=;
	b=kCQ2VfiicHiIqbHfnNCsi7dmRDgCLtDQumWsVhBj1o/P/fPEg/QLxVCwJPbocJYikftmzf
	MNjNjJFwZUJp0iDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1D33F3EA63;
	Fri, 16 Jan 2026 10:46:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id //MZBwYXamk+CwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 16 Jan 2026 10:46:30 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D9E10A091D; Fri, 16 Jan 2026 11:46:29 +0100 (CET)
Date: Fri, 16 Jan 2026 11:46:29 +0100
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
Subject: Re: [PATCH 04/29] ext2: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
Message-ID: <bvcnfrf4kg3md6b3kvklrisa4tuwlszr6fjakfmudtiwq4uy2d@5rfpe3unm5tm>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <20260115-exportfs-nfsd-v1-4-8e80160e3c0c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115-exportfs-nfsd-v1-4-8e80160e3c0c@kernel.org>
X-Rspamd-Queue-Id: D98241C0007
X-Stat-Signature: 9iz67htspzikaczx3oykbzxumeqap8h1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768560391-987786
X-HE-Meta: U2FsdGVkX1+d41pJQknncYKx64lBTxJtNYMZgC/34iTG3uapvDWo1domgiEo5aPe5bwq+ej0+TXBhUFgxfSEQS9FNByF44efqv099i22gdWLT/Ya4dhRaWd/+CwArIcLZxNut42zxYWL6U9ManypcXb62Mu86VY2htahkaLv3YY6KTvNzST/RRJDHCg9J0fYraM58uXm8uvepBROkZA635c1i54dmr9Rtt247bu6C795ox2nVMztLifD4UXBvIWmmYiuq6WlZ3XcEjNsTkrX3MuDSaUTylXYDY5uX+SBqfwkf3sao2VXcS8dEh8vlxUWXJPjTzNUQIURhDnK0tuScSSYUc/w8g7ZAAbYJ0K85DLuf3w6PIpCPBnRqsJBxRfGWIp2q19TMQS8G+6mDdAZ5FgV8IfwfWOHjPCTPoHY1eQYzJ44EsDZHHNKxo2+lqg7cYFY9qBLW+B07QT8ps8VuLLUhv91SBy0faxtPJvzVFU72btK1hVEorGm0vyasJ7sPikAf21j5OwA31y1fbgCNb5nvOIwD6KQu0APexA4ZBqYP6J0bSaFLtFrS9DExwDAgB1tQuM7cJfzI9vCZxPkTXhPiU6/9G4uqsPIt7IaTFwQFg0Uv9P5WOGbffJoL8aqhRFcEloUnesTYZ9M0tB8D2V6jbnyEzl1SOyuwJjgN79zX52KVisR8v5iCVOQ+Fsjh4z5yuyt465xRWdGV4Tgn6JHeEjXsU2OeyG6+goDwHLqoKbKg5jeGue7L0ama6ebj4J2EPaAq0LhUL1yTH85AIJi4rINmjNgz+TNjC/y9EOfQiu2R3klSuVyPEKY5PaARt87Ykze2aidMAHzZn+9YyQTCYx36KrPJuPiRTEKfvmDJq8GJnPRP4wNqbAdWcD6Pz+S4v+NmCPQHqRqaeK1A8jWN41U2L0+aIleqgKwGfxvxg7eMHtc6YL90D4tC83dw10WoVj/17FWaoM8bEe
 +HFUSmDV
 Pkx4WfytM3PL1YB+dv17u6d5CXjKyton7fXRvdAVZUg3hCIhtZr1uCahhGdITgLVdZuKE7LJ/+7RH0dxLtlU3haXbn1dcINUqhvDhn6Ht2GzbFU3hd5ixhY926QmtuT0SRYtrmSlVUK11aaxRrPOvwzfRdM6Ol+1WOp+NiGg0PoFESziUkTuNdi5Dw58ezlMqIAqjNqcuomz+tgNe75m4vPQ+TWpZxPa65hQ17UHTOz3clDL9pctEtrwd5NMDqq9NPYUadubol7tlI5/rei/uOouvMZOhYKE2WQftILDkYa7OJPHh1vcgKbfSmOfBWCnhtu1HdZ4yJPba1AHvUiU4VpjakX8bpvPDIYjOFEFDId9RjarJ6AsdKju889qnvw1HbuLlJgz6JCVW+y8UhqOwqWn2LlcgRwAKUz4LwnIrW1omirCAFC/zJb5gG63Nw3V3k1XG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 15-01-26 12:47:35, Jeff Layton wrote:
> Add the EXPORT_OP_STABLE_HANDLES flag to ext2 export operations to indicate
> that this filesystem can be exported via NFS.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext2/super.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 121e634c792ab625d7a07251e572e5844242fc2a..936675f06806d268ded5a3ba5306575c437ca9ce 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -426,6 +426,7 @@ static const struct export_operations ext2_export_ops = {
>  	.fh_to_dentry = ext2_fh_to_dentry,
>  	.fh_to_parent = ext2_fh_to_parent,
>  	.get_parent = ext2_get_parent,
> +	.flags = EXPORT_OP_STABLE_HANDLES,
>  };
>  
>  enum {
> 
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

