Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59567D4660C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C36EA6B008A; Fri, 16 Jan 2026 05:46:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFE2E6B008C; Fri, 16 Jan 2026 05:46:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0A666B0092; Fri, 16 Jan 2026 05:46:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC7D6B008A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:46:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DA941A05C4
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:46:47 +0000 (UTC)
X-FDA: 84337498854.09.E8A9240
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1B296180004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:46:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Dh7SnjiR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JngxdL8w;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Dh7SnjiR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JngxdL8w;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768560405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LLf4/tCwvZINw0T/0iWsFlAQXM25KnpgNkic4lwBVt0=;
	b=qlkn25plFFJOpHR8pXblnUkzibrG0jvRIw3VKEFlPPwgYgiGHnbYT0YS6QMkitKUtVfMWP
	yxZ5GjnFL46wOiy+F5MKiHmop7ojAkpT3JFOP5gKtpgTC4csQCZAXvYX+OSIuT6tZqAuFt
	oI9Y9ivnIuen5zJJSVgkt3v0EfV6UJM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768560405; a=rsa-sha256;
	cv=none;
	b=aDMb3mtlK8CkWpReRGGA77rWC4WbCU+dVHdHTYYSIyc4lFQVngbMlcJDsn/tCOdCcY+vdW
	4v58EzJT7GZ9es0wIYcBSEX+evEd1OUhugnDVv9r8Cm+XLVdoltE1WmqEUMFleZjZZ6W1s
	IP/hcHJzirw9vjcCY0MBOgColXddz8k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Dh7SnjiR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JngxdL8w;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Dh7SnjiR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JngxdL8w;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B34A0336AC;
	Fri, 16 Jan 2026 10:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768560403; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LLf4/tCwvZINw0T/0iWsFlAQXM25KnpgNkic4lwBVt0=;
	b=Dh7SnjiRKN5ZLxwaQCzKaRU4hPs2cUr4T6RT3yMyC9NwOzAfIhq51nLWqMWJa1JBUaKN6M
	VyIWPJc7bMZX5Sw0Weqh8k3Kge/MNpGLws//mDvbdBmoz17A42nnyKhEvQSuywB0LaMp3l
	psvOUcIpdE69J4CVl6sU5Yrml+5UbFM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768560403;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LLf4/tCwvZINw0T/0iWsFlAQXM25KnpgNkic4lwBVt0=;
	b=JngxdL8wTQw9LQCJAoX4/DLQZN2ID6p1vylYUhDFUqAfI0+VyVendKJD69hNTBnMkReZnH
	Dc5JXbiKnr5/HvCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768560403; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LLf4/tCwvZINw0T/0iWsFlAQXM25KnpgNkic4lwBVt0=;
	b=Dh7SnjiRKN5ZLxwaQCzKaRU4hPs2cUr4T6RT3yMyC9NwOzAfIhq51nLWqMWJa1JBUaKN6M
	VyIWPJc7bMZX5Sw0Weqh8k3Kge/MNpGLws//mDvbdBmoz17A42nnyKhEvQSuywB0LaMp3l
	psvOUcIpdE69J4CVl6sU5Yrml+5UbFM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768560403;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LLf4/tCwvZINw0T/0iWsFlAQXM25KnpgNkic4lwBVt0=;
	b=JngxdL8wTQw9LQCJAoX4/DLQZN2ID6p1vylYUhDFUqAfI0+VyVendKJD69hNTBnMkReZnH
	Dc5JXbiKnr5/HvCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A27463EA63;
	Fri, 16 Jan 2026 10:46:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RQqnJxMXamnVCwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 16 Jan 2026 10:46:43 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 593C0A091D; Fri, 16 Jan 2026 11:46:43 +0100 (CET)
Date: Fri, 16 Jan 2026 11:46:43 +0100
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
Subject: Re: [PATCH 03/29] ext4: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
Message-ID: <yaflh5yuvprahi53xjx7k745lxsixxzqea5g63sxge2fqrwe6c@q7w7lvxs4xb6>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <20260115-exportfs-nfsd-v1-3-8e80160e3c0c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115-exportfs-nfsd-v1-3-8e80160e3c0c@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1B296180004
X-Rspam-User: 
X-Stat-Signature: bzxntsdzupf8z6et5jyi9r5t6ape5t65
X-HE-Tag: 1768560404-933969
X-HE-Meta: U2FsdGVkX18ejtofitlmy4Bmxv5hP+cBbs5WKfYppCD9CiSQr1XC1oyBc/3W6mhDhc65HsPt43Gbv45PURlrJYHeDE3mwFNETKYxR2NoPfrmfGhPAbFhmFQbGzruZp7A0y0oQMS3BRMetoA/P82c7EJbuuxl1uK7vweRNSc9TmNntzRBNUl9DsmGYDbMQB86/tt5rBuXBxqUXAFf9daain2UQyHVn47EsRp/dFXNV1vyf6hRgK3H5mKcmxw4d6CG4uYCY9HjqN4ExdT3KKoHmd1Zsx/MQ9kdOzUSAaUkJ2ckHRQkZktLy6lpZwYt56AHHTu5lsdyDSDdxHE0W84ErJZmr963L2PZMumhtDaEEDTHVS4+RHXercUMCDHGSTAc39520yn4hQK2u9jGRZ5vg/xw/Mr5eFmBjcwdXEYB0kvEyDz6Mbd4qpixjEvN4OB+7tL87J3qvk123tedVLQuHom/QQHbk1sqaCs5oKC5ceqLNIL1qjcAvg3+FNwjR9tLMjdVQYkkHiVfBJx0tNs9no6Hrm0B3jG4CK5+7VL6pSNAqWTysLcEoFs3hiB2jfKKJJc1Taz/PmCErwjp0qe0YZevgpVDyMvMb8i8O/eNjNw9EDLfhEEAnBqyG5b9xcFb/2N5oIlDHlHNHbT81GgmlB2L/eP6rzgYB5dS8NtSRsr3aX0CSkWrGKbIMSLXwPCcAbBYLobRvfA9WfEViDlCV7D4ik/dplcSCoresm1aXl/KAiR5+tHLUaUJqsF834pt452u+eSZNp9y+7g5m6PtfvFjCGUhD/tyk97TjN+xpP8kSTjNXYPS0tqQaHzkpihdPOGtBkeASmwxdsZ28J+q/wTVInEV1EglF534XDgyHr0ZC/2jE4WRQF4R31CwjVo5wRw6IRpA4rsSpZPrCSADEtxEYneYjFyS9SGEM2qwU15uPf8FKNB5hpvGTrreg/cXze7Hq8feaDEMZBPvekw
 ErltwWCz
 tmdnLnIP70dlhbeXom74qfqP/QJPihx28KbzsKwJG0mahPqSM9yPMJhND0ElisoBRBwZ+askS/+vGBhYjGf+DlBcV6I4NPFHjINTBIxO6E7KnVzP0iRU5G/RLYZEVkVmfVy1UOaSa8uF8G+5wf7X5OyhCkLbOSpvKKPTAnxchJsuPaTmjfrT8FYcj9oPNVzz8qsjZv5ZAuOdWnYwB+pX+cgdXZ8S4e7kNrgbm5+OHyOrmseAyb7ICiz/r7J13wUjAZfOZF9rnmfXyq2qqnYeyb2ZHWycI4sinRwxIXwXHKSI9vp2N/Ooo9RgEKb/sYs/6IEyvIvPR6vl/HEXKbhNXvNNXm1wJZJuJaCRzkOc+L3RQOtKcHt9HSSio+CqIxJiimbMS+/qUzNTHweGgW8Yp+69AwAqqzF5gmWQU7BqylBDKGhqc3IWU47MNa+qX9oI7EEuU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 15-01-26 12:47:34, Jeff Layton wrote:
> Add the EXPORT_OP_STABLE_HANDLES flag to ext4 export operations to indicate
> that this filesystem can be exported via NFS.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 87205660c5d026c3a73a64788757c288a03eaa5f..09b4c4bb8e559da087ec957de3115e4f7d450923 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1651,6 +1651,7 @@ static const struct export_operations ext4_export_ops = {
>  	.fh_to_parent = ext4_fh_to_parent,
>  	.get_parent = ext4_get_parent,
>  	.commit_metadata = ext4_nfs_commit_metadata,
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

