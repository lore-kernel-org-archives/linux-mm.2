Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4C5606A330
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lmBAsOPf
Received: by kanga.kvack.org (Postfix)
	id D6FF76B05B0; Sat, 14 Nov 2026 08:41:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D48316B05B3; Sat, 14 Nov 2026 08:41:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85F76B05B5; Sat, 14 Nov 2026 08:41:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8B6B6B05B0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:41:04 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 311A040410
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:41:04 +0000 (UTC)
X-FDA: 85433835648.23.E66E229
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8D65E20008
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:41:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lmBAsOPf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794663662;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yXQkQV7ghx0H2LCchBrsG02Gbte5BQvNzSrSlI170Mw=;
	b=7bLPjpjW86S2vV62xLL4x53t9myRZVTd30cFyQFvY5SDtfw2jHnjHECcDgbD58bt1YHt5T
	oYgWVf3WVIP7H9jz1AC7hBbFfkZ18BkJflUmuqE1zamDyKW+GjY5ZV1iFC4yhQKcJuRsgS
	sY+MJDOViJE6oWJKPXYzRDIM2jPjaVc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lmBAsOPf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794663662;
	b=E7XkvzMu8fzYgfwKeaLZcGHqyteyjbJfw9A13NJkopxto+WLPhGwCs6WSnZBK4MQede9MI
	xOMTO2tEov3bxb/N+PSptUfPK/x/xPlmFUz65ZfgLh5QJ10yIiohRdn6yQJCKjecUd+rA1
	wRUpF270Li0dIc4ZOO4BYffR6HmCzus=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA79E4349D;
	Sat, 14 Nov 2026 13:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CD71F000C4;
	Sat, 14 Nov 2026 13:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794663661;
	bh=yXQkQV7ghx0H2LCchBrsG02Gbte5BQvNzSrSlI170Mw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lmBAsOPfe3o3JaLJ+3oDGJJmLGVY6hAF3tSM3gcWZ1iQrafVf961dhzL/XsCaeGiH
	 GH09TDzUZI8HjZI+icEaMgYAKQiT39BjWBGrgg1c0FcyFD1vGiYBqgh6CN2zXdtPo0
	 G8zLlYuHs0bpRE7qFyKG8f60WQjclKtPOpuPQYZ3Jc/eWVaX4bCXkOIkkCnxwBhaLZ
	 KsMVto+VTz1yzNprKmGZ+rOLvOpbbmQC5iknV/o6rFdWocERI8o2Ex/rNM/H59Eqf6
	 X1wIjaGPZSM01lpgso8X4EBJQts1LTHY82dLV0cVJU5dOvGeEC+ehhgQpAtOXUWRKP
	 3G+b7hu0zPApg==
Message-ID: <sashiko-outbox-214583@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 38/42] fuse: refuse files on pseudo filesystems
 as passthrough backing files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Jann Horn" <jannh@google.com>, "Chris Mason" <mason@kernel.org>, "Josef
 Bacik" <josef@toxicpanda.com>, "Christoph Hellwig" <hch@lst.de>, linux-nvme@lists.infradead.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, apparmor@lists.ubuntu.com, linux-efi@vger.kernel.org, linux-s390@vger.kernel.org, linux-usb@vger.kernel.org, "Amir
 Goldstein" <amir73il@gmail.com>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Anna Schumaker" <anna@kernel.org>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261114-work-loop-pseudo-v2-38-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
 <20261114-work-loop-pseudo-v2-38-98639a2286fb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 13:40:59 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8D65E20008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: a3ktiondframnriznw4eqm1gn9z9ckg9
X-HE-Tag: 1794663662-412214
X-HE-Meta: U2FsdGVkX19GyVIRQy61KqqXtvd5mpejsJVPOYQPv+lFFqPH3StzZ+I6BAlAnyeAEXd4Xb3h1P5jZYwnwPbH7RKdeUqjqLNL+uwU/p5U5lLs/mwdw5IRpRHTLdgVrikneDDrTFPwv2+tATqVSFlbBm8AsQY9IwWYiGxInUU3uZJc4d2P3iNOPNv0XlzrlXwkqwuA1VmX5/qx2Ehj0pWIb0nHiR2Bbp8JoZbg8F54DaFozl43KyKf5QaBqSM9VpuoHwwa3ATEBIFcH9gZurtY1kWpKbjFf5wJvxskkUG1CBajcgl/hCm4oLUsXGEWCtuXqkmhDUJqMQodq3hoH8vIGbqg6h9XWgW+O2nIUcwgaQMZt5pac7Ge6MY1SND7gIIk1TjlO4ZHDaY19h9Zh/PKk7NKLd2JzzJEnIIQK5GKdG9McupoiC0mmPYCChOF/yG/kKZvguyuEdLXkdCVZ3vBfo6oswX+vcDfMdleNB6JRSyZnkGCg4UHXu2k1OTlquuFTc4WxrfU2ijY42eVzbVcGSnUw5O4vmXlELlbbaKcnFED862FJmedmVT+9h7kS2w1rQQq4+hUcngica8KVmiWgJ8jtj1CSxhuSA8x7c3h/wcOUU3uiLYWCI3ySbV+pHcMMfNPkcFdOINENhBTGiy7kd+1xpar0L7UA5mZ4JsvTN1Tdi4brk4jsovxH93JOI2cHA7mfdBXXJqN46r8DXX28pmGFik4AbIoqq2EXEH5VKOFPOcX/A0vQ5nzCHLdA1g/4Zl3n7OMa+BrGQizf95ExrlBdG5oKiR1MwA5jMJd/zAaBzB6/LAwo24Bfs4hPXwz8uk649fJNdmaBByS8q+mZK4Aeok+A54XuxGixgyAGgU2CMUAFWS5FaByCXKEaw9ZK7S10Wf4XnpnCXdUQ1uSBTCOB1f+mZCm8D8oy4bF8njjCjZ/35bDW1kn5ouO/psQD1n9F/kE5NqzOmM6906
 1Un6n6Rk
 k86SsgL6yDnR9gsF0axDLMzz08eS4QPZ0iMBuDM+rgDJ7IIhxSzvj0+c6rVkLDWp/m40Ox74RDqooVTSOwNB16HJrHusIWICBBTDBSLSG9uCbaxAq5XOYLkkngvyogGR8vhESU+BCELxvSSFZP/cLMPN762F3httN0P6T9rQcPXqcdN/epEj/1TBJ42O4KH74ia2aEgWLe6wGocZzdhgrWbgjwbiF0DVXwt7V641WIsJoznqAaflee4dQMz8Mqfp3s2zOitt6MwSOWqKb96fA4PKtBRnt01t+p9KcaKN0Jxz0VZIwHPYmz+vv1TpXtTS8bRpm2VZBFOl6DsPwIWI5oH1lqqLepccumOsx2vK2CvuCt201yaho+V4IyTKfiwY5755l3C+mLWddUa2yZX9Sg7eo5Az9gVk8aLxcdhYvQIXZ5TL+CtILYfChSNfoMRdiqgAgxH0vXudGUdOsVC0636hXVgWU9OKagAPGd84DMbCsDFwiamirzN+bJ7luTSEPdKvz3Pc3iGD8JRJSW/CGCsfYVEN8Lx01BFJ+M/9FgBJ+XvB6gchOX+nLhpbVKaqCWRoMzsOw0mIN01fPE4LPkGLd0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] fuse: file_check_backing() with FMODE_PATH on unverified ovl
  dentry fails open
--

commit 3377a8521784786f7f79c18bd3aafabd17e04633
Author: Christian Brauner <brauner@kernel.org>

fuse: refuse files on pseudo filesystems as passthrough backing files

This commit calls file_check_backing() in fuse_backing_open_file() to
reject regular files on pseudo filesystems when registering FUSE
passthrough backing files.

> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index 8c21a8a74efb9..7527f3ecb90dc 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
> @@ -147,6 +147,10 @@ static int fuse_backing_open_file(struct fuse_conn *=
fc, struct fuse_backing *fb,
>  		if (inode->i_sb->s_stack_depth >=3D fc->max_stack_depth)
>  			return -ELOOP;
> =20
> +		err =3D file_check_backing(file, FMODE_PATH, 0);
> +		if (err)
> +			return err;

[Severity: Medium]
Can calling file_check_backing() with FMODE_PATH on an O_PATH overlayfs
file trigger a WARN(1) in ovl_d_real() and fail open?

Unlike a normal open(), opening with O_PATH returns from do_dentry_open()
before calling ovl_open() -> ovl_verify_lowerdata().  When
file_check_backing() then calls d_real_inode(file->f_path.dentry),
ovl_d_real() runs ovl_verify_lowerdata() on the unverified dentry:

fs/overlayfs/super.c:ovl_d_real() {
    ...
	err =3D ovl_verify_lowerdata(dentry);
	if (err)
		goto bug;
	lower =3D ovl_dentry_lowerdata(dentry);
	if (!lower)
		goto bug;

real_lower:
	/* Handle recursion into stacked lower fs */
	return d_real(lower, type);

bug:
	WARN(1, "%s(%pd4, %d): real dentry not found\n", __func__, dentry, type);
	return dentry;
}

If ovl_verify_lowerdata() fails (for example, -ENOENT on a broken metacopy
redirect in a data-only lower layer, -EIO on verity failure, or -EINTR in
ovl_maybe_lookup_lowerdata()), ovl_d_real() hits the WARN(1) and returns
the overlayfs dentry itself.  Because the overlayfs superblock does not
have SB_I_PSEUDO set, file_check_backing() returns 0 and registers
fb->path; if the failure was transient, a later fuse_passthrough_open() ->
backing_file_open() -> vfs_open() -> ovl_open() can still resolve the
lower data dentry on a pseudo filesystem.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114-work-loop-=
pseudo-v2-0-98639a2286fb@kernel.org?part=3D38

