Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1459DCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 07:53:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45CFC8E0005; Tue, 11 Nov 2025 02:53:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40D2A8E0002; Tue, 11 Nov 2025 02:53:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FC128E0005; Tue, 11 Nov 2025 02:53:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0942A8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:53:22 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BD15413AEA0
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:53:21 +0000 (UTC)
X-FDA: 84097561002.29.34E1837
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1B58312000E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:53:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o8p0McGb;
	spf=pass (imf29.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762847600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NLoaUhRplSc2c+OLwLIc3JhAwVgSH0o4v+ejZHdX3XI=;
	b=mB+1S9CwVL6YojvLyJ9I+2a82n4QYK5wbaWaXIAlKL02Icr3rOF2iiPXlK+uZsLKDTcegU
	CdvbCCVKCvzAgScMM72A/tacRhVhYd1JUODg4EY8Cnq55evbr0AisV6Tkk9F+XIoumlcfj
	kDQkSEzOcd/Yvmw5YrIIHMyNN5ce3nM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o8p0McGb;
	spf=pass (imf29.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762847600; a=rsa-sha256;
	cv=none;
	b=Lsv1cUBYMrvMbP/fASBIPAnYaHAxeV85UXZK4oOEozmMPi0iKX/jpsNdVkcMZyksDQYfnS
	ioq4nHq9ZVP8XBh/j2Ytkt35oruXG4SXFNDlFvvjKd19XlgsED8I6Ut8PdQ3QEdROPVzsE
	BMg6Xkg8xWn+TWjP3o9cJ0/SZAY9J9s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 034B143E59;
	Tue, 11 Nov 2025 07:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73270C116B1;
	Tue, 11 Nov 2025 07:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762847598;
	bh=7qxex0fb9sux6H6YiFyflQQ1fF27LToi81rAOC7nyJw=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=o8p0McGbUBg/mt4W0NwniQY9deSF651afKOoP439t4jTJeKv5LTx9vea9SGEQP8si
	 Q+5a+sIU7/rr5zqsP+ur8SebApGAvWVYTCiHpEoBxnRS/ATLz92ZlOpzA+IPHvqxX7
	 dy4GVB4pVeP8wFW2h7PYHaYeO0gbrMbOZYKJPHlrur9uUuvNsp9xny9Zx+MXTS3GYV
	 cqyVrLtwlM6rSDu0Fgu90qu055/duQnw869B0CGPbEtwgor0ofWM7MG2wjg4jSiR0W
	 0z4Ylk8vrW16xqRUmM/x1Dj8l4LfK4kIc0/1RsgkaikoHSoF9wMUFwvk/QGdaVgMjc
	 CIoMYVMhdAYTw==
Content-Type: multipart/mixed; boundary="===============1170773288298516893=="
MIME-Version: 1.0
Message-Id: <70d825699c6e0a7e6cb978fdefba5935d5a515702e22e732d5c2ad919cfe010b@mail.kernel.org>
In-Reply-To: <20251111065520.2847791-35-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-35-viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v3 34/50] selinuxfs: new helper for attaching files to tree
From: bot+bpf-ci@kernel.org
To: viro@zeniv.linux.org.uk,linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,brauner@kernel.org,jack@suse.cz,raven@themaw.net,miklos@szeredi.hu,neil@brown.name,a.hindborg@kernel.org,linux-mm@kvack.org,linux-efi@vger.kernel.org,ocfs2-devel@lists.linux.dev,kees@kernel.org,rostedt@goodmis.org,gregkh@linuxfoundation.org,linux-usb@vger.kernel.org,paul@paul-moore.com,casey@schaufler-ca.com,linuxppc-dev@lists.ozlabs.org,john.johansen@canonical.com,selinux@vger.kernel.org,borntraeger@linux.ibm.com,bpf@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 11 Nov 2025 07:53:18 +0000 (UTC)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1B58312000E
X-Stat-Signature: i9q7314eusk14c9mbr84jcwj3ax8dfh6
X-Rspam-User: 
X-HE-Tag: 1762847599-281063
X-HE-Meta: U2FsdGVkX18IutfxBFpj+aT9Xi+F6YPi7Om1Lpt1k+/JLwrYgzUs5L2WP76vxErQYthXVpPkNtWXuVxWx6JyKUohSVai9woMYT0O6ADZ3hjP1VaqExOY+dgVlfsl5uxQFwxhkKnBiajAAQrcVZw3RZWWFMUS11f+OQvn70cwUSSweaCoCREZvVF4GRolrfQM7Su9XpCYYXYciGnQpTp93p+WxaLn8UeHpEcbMfMNSUh6A2yKU5tJgaS3XPicxdymQ9vSxSjwhIlVVg4TlUIXp7n9yrDl/+iFpkDvCl17YCdfMdBxG56055S9mWvGE084OkWuL/BJavFz8v0zJ0RhGUidSyqtIPrH2hELTsDc/ZEAbvyoK+gf1yt4t/zLOWbXOhyuBV+1QW/sbSE/Lt+A1ca/OVi3Sqz2BtgZ6yMRfSlEH3/V9e7so0TSfFpoDe4jFj3x3SLSkuvcfezoTxfJMvQ+B6kz/Ba9bDylOoiorwp03hjUbJmoN2g6xZ19GTJQ/c8lowYAKrrXKW50zwA7qdNgc28YJykY1tAqfqFQT/1+gEcM30WzHQ8vt+bYQexu+5dfTc10NkUb3+sF5Q97n2QZ53T1wqWG7GSqTTljLj6/TB/DbmUOCQgPrhB6C65E8UyUahI62XhriPudPkjP+03aKdEYi45XZj2UbvIZ5B9K/eSXrX54jJUQMrHooyvDUcrRWo0u/OgPmEessjw7fhajXHgtXXPkyKiA66psMJInI71xAFIvA4vBdbG0+uPunN2loJLiSK0Wxs2k8pa9cGR8pzjJ0I0HFoDSHBp7rEe5yWAYNm+dkURgJsASPgp4MX/kPjW0izjzu84h0dNDr0PKHw67VPJDtH01X2APrAzxo6mAM3vBk7um3JlRFeLX97HRhw16h7xBUEiNe5OugVPg0FfUe6aZe+gWBk2hJwKIZMaaTFILMok7xjXsHpHL6SGQ9pjN4MbWZ5jkJr1
 dOig99nS
 WKSaN1loi3deB6q94GvvwOsno8ocEnrzDk+z/x7QJOiczSjH/T464QRCUGSApkEJeXH+a+at8gv9jkzX0B36KQH88cJ9SzXqcLRYJ1SLsxcxcu28oQacqKtUNj3/kwEBQCKS1N0BPDswqVDm8q+6RtjFmBR3d4EKRKAK/Lm6HvURm8uafZ3iAB/eBW8mFIZHOKnRJH287TT+dI9rdIiJ9RYvWFQC9HW/dNpDY8Fz0hawNpKN/SuK8f/keJ9uPTc1xDnGkAhTDynlv6uzPOPbx1yopgqstvPnS1qK5f0aZmoBdI3qgtH4KJlhkdrkPDczIOp7CAr/odexDTgfP1kPqgDT9i3nphU1ToDKpojK5TJdlU3tUX+MTu1eBbDAdraoVmi5QbHNqNG4yJxbJZP3ojOC7F1jVQCwdswWwCdqpXAWTq2M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============1170773288298516893==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> index b39e919c2..f088776db 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c

[ ... ]

> @@ -1197,6 +1197,25 @@ static struct inode *sel_make_inode(struct super_block *sb, umode_t mode)
>  	return ret;
>  }
>
> +static struct dentry *sel_attach(struct dentry *parent, const char *name,
> +				 struct inode *inode)
> +{
> +	struct dentry *dentry = d_alloc_name(parent, name);
> +	if (unlikely(!dentry)) {
> +		iput(inode);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +	d_add(dentry, inode);
> +	return dentry;
> +}
> +
> +static int sel_attach_file(struct dentry *parent, const char *name,
> +			   struct inode *inode)
> +{
> +	struct dentry *dentry = sel_attach(parent, name, inode);
> +	return PTR_ERR_OR_ZERO(dentry);
> +}

[ ... ]

> @@ -1887,31 +1887,23 @@ static struct dentry *sel_make_dir(struct dentry *dir, const char *name,
>  			unsigned long *ino)
>  {
> -	struct dentry *dentry = d_alloc_name(dir, name);
>  	struct inode *inode;
>
> -	if (!dentry)
> -		return ERR_PTR(-ENOMEM);
> -
>  	inode = sel_make_inode(dir->d_sb, S_IFDIR | S_IRUGO | S_IXUGO);
> -	if (!inode) {
> -		dput(dentry);
> +	if (!inode)
>  		return ERR_PTR(-ENOMEM);
> -	}
>
>  	inode->i_op = &simple_dir_inode_operations;
>  	inode->i_fop = &simple_dir_operations;
>  	inode->i_ino = ++(*ino);
>  	/* directory inodes start off with i_nlink == 2 (for "." entry) */
>  	inc_nlink(inode);
> -	d_add(dentry, inode);
>  	/* bump link count on parent directory, too */
>  	inc_nlink(d_inode(dir));
> +
> +	return sel_attach(dir, name, inode);
>  }

Can this leak the parent directory's reference count? The parent inode's
link count is incremented with inc_nlink(d_inode(dir)) before calling
sel_attach(). When sel_attach()->d_alloc_name() fails and returns NULL,
sel_attach() correctly cleans up the child inode with iput() and returns
ERR_PTR(-ENOMEM). However, the parent directory's link count has already
been incremented and is never decremented on this error path.

In the original code, the parent link count increment happened after
d_add() succeeded, ensuring it only occurred when the full operation
completed successfully.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/19257803162

--===============1170773288298516893==--

