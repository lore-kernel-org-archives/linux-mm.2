Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57BFD606A338
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EtA9LyX1
Received: by kanga.kvack.org (Postfix)
	id 7F0396B00EF; Sat, 14 Nov 2026 08:40:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9716B05B2; Sat, 14 Nov 2026 08:40:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706306B05B3; Sat, 14 Nov 2026 08:40:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 47D006B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:40:15 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFC80A03E1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:40:14 +0000 (UTC)
X-FDA: 85433833548.08.3B8DEC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 256E8180002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:40:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EtA9LyX1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794663613;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DO/pcsGH2E70PyxeObnmbVUNA7RxRjcw0EQOKMlsdEM=;
	b=cdFbBxrlbGID3vw1qnasCwZ8rfDwV9cavWW8J5sdScu5AgkJkkzqR3l7rR8MzRubJrlSOY
	q0MIfYe7eAG7sSwzjsKkfNup5B/Arl7dlV0WF6oeM0LXZvgozny7z4oGRJ74dPjrAQrkAM
	g00op6whlgQQqlDPERi/JLx9QFJ4zII=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EtA9LyX1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794663613;
	b=4cChWRxEOuxa3QecbbmKYwiW2hX84TBwuLPLWtzcTgHSsv/sQNo3Ss2d1NfqHe3j3gc27u
	USu6PkkfeZk7qXpILee567vyBYpnXJ9IRui6niI2Rjd9t3oBP1NaLVZqt4LyW15nUSW12O
	Xi8rXG2rOKhHqz0LtInAuuf++IYfEeY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DB6943AF7;
	Sat, 14 Nov 2026 13:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EE71F000C4;
	Sat, 14 Nov 2026 13:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794663612;
	bh=DO/pcsGH2E70PyxeObnmbVUNA7RxRjcw0EQOKMlsdEM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EtA9LyX1DQPmqIivWqEued4cucJAK1+nJOQ/GGvKipbsSCBQuo+oZ3kPO9RKq7oYC
	 zIcaqW85WuT+78yc6J4OdCXsw3apCSEsQ7sYevNDP5gzBcxQY0m3Hv+1Ms0/aVZ7H8
	 CDlb2C/w82i3kqyY8BfiXhGvlQIigUINjN/hsFCRLIaM2Ubpq32rCz1dM2EFAIdocF
	 nG9Yz57EvfILKbQDtDytbmBzQCS6+NOxq3b2IHcbiz+ugsNkMobp3XIkLgDnxk7t1p
	 F4jXXVsDKS5hVcmfN7uciWAYXm2W6m4JRPhYfmt9AfelqpBckVtT7QDcKzpdjQSs7B
	 YV7fH2wGKn7Ug==
Message-ID: <sashiko-outbox-214581@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 33/42] fs: add file_check_backing()
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
In-Reply-To: <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
 <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 13:40:10 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 256E8180002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: 8fzqkxw8ietxrzdmjtepct85usd85i7k
X-HE-Tag: 1794663613-501598
X-HE-Meta: U2FsdGVkX18lx887TPDotWpurAKGbtAvHTzCMM3/ODmTcegDsHjq2bjRm/NlJu2D2SVbIEe5uucZ6SNfE/kDzRvL6HYziFLn4JnGXxYsy9zkyYKP9qA1p8pNbANhvWbfrqli/VpApMx+59Gq+Qp7EXZ0PPiCjUwkf19L5T5X9ytqK0IhYKCfjVNQhC8CHTGul3SoBXV+90vABpYs9e/KoBKMHvuYKky97dZXPI19fh+1Nv8+hOX2lrsPf56lQDTAG5Pwc7Hkp2qL8OZl/qqxSMgb2TPZNToGpy0t1wESz+I703aaf/HwETdIy2eUoXCSdYcfQyR3jhY9o5NvkdbL2c4rOdBoXbAkrWXDKw0CTyPfqB7bBfk2w2JVobgTF+5CpRPPNdVojxTSSvdwrLP8CmkU3SFV1isgAS6XeZ3DWtfZ4UQMbKNC4oaDVQzY3g0T06pK0IkyD2djDqs/Fjn8J8h0D6PFOLjcGzHF85pm3cPz3yD79PIuR2nu4Wh7z7Q7be2a72tErmaLkAanxM7q9Nk7ROegfP2WaE2BbAkJGtEKFCUWxa99QhUkDyyTFDslAqALGCbJcgPv1rIVGeYzAv4+0GnlBw9s84fZDtstmJE2FyiDJ1WHFfbVW5ow5CsjPnAZ+174Lmd5lifXLwdAnWtWyaI2IXN+s84HDix4mnP2mgWSBw6tmjjI2ddCBY/QFWNxg2PlRJ8rPEXkPQBy2x1TPzKqsD7tApeTpW3aZOW88DlPnSvDp+sjAxVcvYv4QYCDJzyA89D4r6e+OD3YMC0RnYkTogDlXEAKvUw2V5TGnOWrXnTkMNu6HZgcQm0GjBUazPCF+YTDOId2ne5wylojnQt5N5CG2H8Aa/lR1hzrFMTKwA+VVRZGCB/LIdZ5UYD22uYSaRfs8cY/1RnpzwsiEY9yFQy7N15Qd5i5sMB7AnUmAMA/PAR06NOq8MALLpLDJVBQhAwOMiVieRF
 iIIdS/en
 Yp7O3J4uE6HaJNsDHR8nUNP6fjV0010JStn+vbe9KM6w1qTP2MeQxJqWug7B6ZC5kI7tg1MXLe3xuVGzWCTdGuRZNREPkgF/MpydM1RcxgVG+yTg2NNs2Yszm17Cu6s1Ln5uEAAuvNsTVvu8h+mVypF9u7il3QJ7DrpjTMmqGRJw0XGQCshWo5LJ/gBssvv+vGEmrAAT2Jrj1Xl2Xqu7V35jmb4CiTYz5QF80yvujwjf2lbvk7YVuW3RfHOiuklHxSkxoTkQ0tagW0k4HaMunV5bMBnS8JCooTc5aH4FdgZSyujEhwDZQaCYMbAo2IOOhFtymRBqRapD7dkAj1T3+fj1w6uXxmhlBdWrxCFBDRaBYa9gAVWUGWRk19zkQpc+G7xk/ArdVwg5pKJ1O9LitWl+BX+clPs0dsMCSsiJ4DY0u3YwsLPEvGGPHaW42V+frlRa5dBkWG7hprJNHprAUuSkhTqlVZkoUNZUUan7IMwlvNmoxePxkpcZf5nYBgADET/OeX4LnA1I4hTwxIt4S0RY1srZH+WaT7JUh2Lqx8J9f4EH6+kquQz+7lumFLFfhbaQrFP6qHOCIO9bU0dnvORgb25UjVcd9SzIzWGiwjHlQQm5S/rlkRHTZbklIG6vz3gzA5c6xhEw8EQw=
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
- [Medium] fs: unverified overlayfs O_PATH d_real_inode() call in
  file_check_backing()
--

commit 12b4c886c3329cc29a995a96a698923b0df5e8e2
Author: Christian Brauner <brauner@kernel.org>

fs: add file_check_backing()

This commit adds file_check_backing() to validate whether a userspace
file can be used as backing storage by checking its open mode, file type,
pseudo-filesystem status, and read/write iterator operations.

> diff --git a/fs/read_write.c b/fs/read_write.c
> index 6767283108991..cedbe654add65 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -866,6 +866,54 @@ static ssize_t do_loop_readv_writev(struct file *fil=
p, struct iov_iter *iter,
>  	return ret;
>  }
> =20
[ ... ]
> +int file_check_backing(const struct file *file, fmode_t mode, umode_t ty=
pe)
> +{
> +	fmode_t io =3D mode & (FMODE_READ | FMODE_WRITE);
> +	/* Drivers may point ->f_mapping at something else. */
> +	umode_t fmt =3D file_inode(file)->i_mode & S_IFMT;
> +
> +	/* O_PATH files are only fine for callers that just use the path. */
> +	if ((file->f_mode & FMODE_PATH) && !(mode & FMODE_PATH))
> +		return -EBADF;
> +
> +	if ((file->f_mode & io) !=3D io)
> +		return -EBADF;
> +
> +	if (fmt !=3D S_IFREG && !(type =3D=3D S_IFBLK && fmt =3D=3D S_IFBLK))
> +		return -EINVAL;
> +
> +	/* Look through stacking filesystems at the inode with the data. */
> +	if (d_real_inode(file->f_path.dentry)->i_sb->s_iflags & SB_I_PSEUDO)
> +		return -EINVAL;

[Severity: Medium]
Can calling d_real_inode() on an O_PATH overlayfs file trigger a WARN(1)
in ovl_d_real() and bypass the SB_I_PSEUDO check?

When a file is opened with O_PATH, do_dentry_open() returns before calling
f->f_op->open(), so ovl_open() -> ovl_verify_lowerdata() has not run yet.
When file_check_backing() is called with FMODE_PATH, d_real_inode()
invokes ovl_d_real(dentry, D_REAL_DATA):

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

On an overlayfs mount using data-only lower layers or metacopy verity
validation, ovl_verify_lowerdata() takes the inode lock interruptibly via
ovl_inode_lock_interruptible() and performs lazy lowerdata lookup or
verity checks.  If that fails (for instance with -EINTR from a pending
signal, or -ENOENT / -EIO), ovl_d_real() fires WARN(1) and returns the
overlayfs dentry itself.  Because the overlayfs superblock does not set
SB_I_PSEUDO, the check here passes even if the underlying data layer is a
pseudo filesystem.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114-work-loop-=
pseudo-v2-0-98639a2286fb@kernel.org?part=3D33

