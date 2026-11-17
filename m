Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3486606A891
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=aa1DJ0ZL
Received: by kanga.kvack.org (Postfix)
	id AAF526B05B1; Tue, 17 Nov 2026 03:44:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60096B05BA; Tue, 17 Nov 2026 03:44:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94F5F6B05C3; Tue, 17 Nov 2026 03:44:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C17B6B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:44:45 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C96A0140316
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:44:44 +0000 (UTC)
X-FDA: 85443975288.12.1CEBB0E
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id D360F40002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:44:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=aa1DJ0ZL;
	spf=pass (imf11.hostedemail.com: domain of alex@amutable.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794905083;
	b=H4qBP9XBx8i3KCeFi/SLHsPY0NeuVRXh1pxuGbAeJG80HC0y8Ji/UqOWjVFOykTp8rLiMi
	1Oed6dG+BFbHKlyp0UdmCk3UI6b7ZBNZnyuBGeUnTwmvDQDkjbLLcBbkJGX7XlB/shsJNr
	i3WJil4Hs75brcQwb53eY/Dye4kkMuo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=aa1DJ0ZL;
	spf=pass (imf11.hostedemail.com: domain of alex@amutable.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794905083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtgOPMlBsDbDRTTami0iaeC2PfdAlPMUJ3BhZBWqnDY=;
	b=G2Bh6yG52Nb6rXkGD6ynKMDhKvuP7VUiaVZbe5iT/G2/dbBQTMOLKO0QaYoxWtlsxqpoBq
	7UVlmD/KQfdWtxtN2DQL+Z0rg3He1x0pI7a3MENgq9injq6+eTAuCB0Kn/dZbrfaQX5etr
	pO1tDukdvHACI80osWHfbH3pRKaEL+8=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48e46e449e8so3217597f8f.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794905081; x=1795509881; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=YtgOPMlBsDbDRTTami0iaeC2PfdAlPMUJ3BhZBWqnDY=;
        b=aa1DJ0ZL84/7KXGB/FRfBb5uhaFRUxxMQ8WoySoWF35PmSRVFxvW16E5UnriTbaB3D
         vdO9WW/s3606LdQwvBb/B0Fg7DbjnlkLcrEP7EzumFSY35n4CsCavaqVDL8gL+3tSAvj
         yd6gqEtBrd6yYmlUHpSZuBkpxoKeLRnFRUHowrqysIOIgGF5y1NqLC1seFoW8SgZRdJR
         LzbC3YqmFJf1GAWJdqMyzEqex5o8SCSQrk+Fu1aCI0MPTOVL21CEczQ2MJ9VBtvlvIOB
         1PTC3qse+V3TSJ4JOuosGqSBgaYiNsITGax8QJSgN6Kj9An9nZqlfgWnGNSZC2xjDxqe
         XxAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794905081; x=1795509881;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YtgOPMlBsDbDRTTami0iaeC2PfdAlPMUJ3BhZBWqnDY=;
        b=zz3mYAlf2RyvUjdKos+s1uNUI10A4i73UbwL7S4NEy2vtfEmLHZddg6esjITTBX1w5
         xQ8DazZ255qvwnI354VQsq0cxNRCm/qdu1lEgPd2SdzTedQQZg/J9aW/spF+CKMfBav5
         Ck7FOV2jqQGc5znOtsyZxcpu+ETgjBkneYAOXSE4E3Z4GwMtFxTxEaqE5R1SOfmH1FWH
         uz7B6Uoz98ns7/4vE/DYEuWrIiaWnTxmr2M4nZ3NqTmHBsuo7KwWIlfy6cn7JwNyOtcN
         3tzRGsFJZMDT8McvotIVBAc3HnqIofYaXIOnMBgClcy2cKNfopuGZDJJKtyrAeFu6u32
         fQdQ==
X-Forwarded-Encrypted: i=1; AL+hErHuNmJ1/+6AsP2h4IRvuLZkaMlDD1Z80O0/iOQOYNlC8h7wMVMabuBch1GuvbBWcr2SBuPz1Hqbhg==@kvack.org
X-Gm-Message-State: APuU4Z9gddpOCmq/shkFXY08CucwE33u03zvra2/n98Xx39gGf/fF6lZ
	NEUw/OrybuVuKsK+SKKwYboXk56aWjjUuWHF+kA9hKzY+De0ZdLJaoToLLVsAWRq0/hm
X-Gm-Gg: AZFdTZcHSG3KHbcq7wmqAPZs9lwB52vqGXslHBvohO0DwxLx8kObk3WNCat9pqMyo1j
	LCIPvPseYpYUgTiGA/RSskup1/cAYFH6gOnPuzam4yJdJkED1br6Ns0LlIJzVwk20iyFfvr+9EP
	u7S7f8AWCW4leCo9z+3titc/S6POdrykECv0/Gr2mqFROizfbzQjivJH8ZkNma3vx2oF1U4AmoU
	9D656g5Whjz1M9C4OfdHn/pZc8TaNSFvaLoTsz984ZEJgAsenpgjF9IyEFSTAx3em3N2CqiQWFp
	iWDrxlfIfkdXizkppiFyVRVT9EuWzPeaAhLRgKRzREl7hTAzy4hE4DWG775yTFncolIzn0dFAyj
	z5zO+cLfLO8ghNxm6I64NUg5zVezXL5RoSl8OtFFXUer1qkJjwjNl9ywls2W5EYbhbay6SC70l1
	It2JUBytf5FxWhWd1IqEqvUjEdxQblN3AOHCKS//7V4ZlSBCnBTYDCHPy/LsL8LRZEfMK+iLnDP
	C6/zUCkSNOAbxxybO3HVi7OPZUOv7tZcWCiyh47fcuO9/EtPBevttf18lmQ3t4gDQc0CvxvXVhM
	i6TnQDFUSL07WDtNMUHObALyw9quMn6vJ8aphZriwysfY40d5n97QvC5HB7FR8ntOnJBuDnue7u
	s6n/uQVB2WVIs19vqiJYNURiICdcbkQp3iS9v3V6SKv1/H0OATlsFis0j2kMSZn7OLb5KvhoFQ4
	OqKg==
X-Received: by 2002:a05:6000:2411:b0:48f:f26d:c5c with SMTP id ffacd0b85a97d-49c70b051d1mr27471178f8f.9.1794905081269;
        Tue, 17 Nov 2026 00:44:41 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49d673ce75fsm19982260f8f.55.2026.11.17.00.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:44:40 -0800 (PST)
Message-ID: <d18a972cfc6a7d6da39ab9674903d7ae6e4c1826.camel@amutable.com>
Subject: Re: [PATCH RFC v3 35/44] fs: add file_check_backing()
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef
 Bacik	 <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
Date: Tue, 17 Nov 2026 09:44:39 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-35-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-35-8cbbea1cf34f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D360F40002
X-Stat-Signature: reeh738bmijfshaqfq4j5ox4e6i5351x
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794905082-162587
X-HE-Meta: U2FsdGVkX18GhRG2+M4SSDL4KDTtxP1TvL1dAJT2IZ24FxdXHFi1xsr7jU0SXrzHv44uxnkwILLg5yp0clD3qZ/WYlMTCTAP9og9lM/bGf0s68w1ln3oUNG1aj2DyCkn4gmJ2VrVqRY9YxlRLQ3O0ljHrm3C1Lg/O7C42P0ri78fuf57b9J0+lTvxlhV/YW4gCVjojfrDwKycj5ExsmEbRRAdeAV/jhiLRBCZOSw0Q1nq1SvA6mZXDERz4nqxn1WahOwgWI0hTcupeKqxrXmCRcyHLjIGgp8aYircSJz226I/h/Pcdg7Zb4zc/EBVBV2G4V9p8T9a37zQV7j7icJ9JpXa4buvZNlImiP58AXij5dW03yMbU2Ztyl/gC2m8GFGmVke9hvmOB4KYoTF2dU/pBxsFF11Y1coKCiLCawRBeYVbGC0kzHTtJFJ49bd6lnvdu4AdmG7MlhZW5UFC3Sa4UqqtOFb3WFMK5//gZ0o1DA4UxwCLeSRk97SeeJpKFaHzeolaXur8Uz0nncwZLHZqZPYhBWb6sQ3ES9CAmLyIyfqyGaxuiNKJ3IcWtK6q1np2XrW6Ab9Tzcvn6k74g8HERXfgmBL2ydhMDgXdKvGqBnfduS424pLMhxWmkM8iKOwRQ+QNGBaPO6xukCZVSdMfrK6ZuT805SjMaj7eOeR34E4rp9dTiy4kINuMQgKxlBMI6w1YnN7pq7g+fNUiLtLhUeAx2sU56PQkgYpEyeGOUjfSmwKUw37sW9C0RUsRcwziFbtHg3PcQMa0IrnyTse43TmVYGhSC+eLP0U1vOWat+C/x1rWqGbI3qi8dTqRPvw4d0DqDHgR7crjGnnOHpHM74zAbwCUSuOBIxCUDKPSOzaRfCpmW+2A1RgWWat+6eXiG4niBOgSUrbKnZX6LmskWK9Sndx/XMeaaOfZhpUKOwAu1CXIa1eTmVNkfOe77NqcT28CppNKeKKpe1TNx
 2y9oP+mz
 faLlC/VQVpTzz6vadldRx5Tm/v7afihHyvO/+iBajfTrgLhBMSSC5/dJAtIoXDLPcQJoaNpWdJ3nB5jaug4F4utTsULlX5SUpunRgJgAO5a09NGOLxN7gumKSoWqH3f9+yV+Up5aTvXt5HmAQaIed+RcATo1jpBEbg+28WY+OuxfV/5yTzuWM02jWe6bfJ/c+uGb8ZOcsbMXNzLlgf+p8/nrUqcKHVylmgU2W2ZsjxCKaiawIIW11FKmTPBPyXpUNxfydFlHQZjAs28hfheVEg4QuuOKAjcWLBU1+vrLHPHOVTL3OOngJ3IITG7cBsnJ//+qZbfhopU1aMGt2xQWWs+8RDDdAkQ9xUk3uBdra0JsGzLXpjREI4RNJ1pxXGeyYP/+GcK6loowQprgSD+z+vNxhQbaG+mvPV0x3bhbTrI67S6eyhSfCXtgf96TjXCokbxuWBnJSBBH0wFffJApAOSWubFmsTPQJRYm8Q6PWFgvWWNwjssQpzN7R+t04Luh0j9rRCFu6IKKSRl48jlL6xUG0GxN/9dD0FmHL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 12:05 +0100, Christian Brauner wrote:
> Loop, zloop, the nvme target, the scsi target, fuse passthrough, the
> usb
> mass storage gadget, erofs and acct all take a file from userspace
> and
> use it as storage. Currently, each of them has its own idea of what
> to
> check before using a file like that:
>=20
> - loop and the gadget check for a regular file or a block device, the
> =C2=A0 nvme target, the scsi target and zloop take any file type
> - loop checks the open mode, the gadget checks FMODE_CAN_READ, the
> nvme
> =C2=A0 target, the scsi target and zloop only check for ->read_iter() and
> =C2=A0 ->write_iter()
> - apart from acct which refuses procfs and sysfs files none of them
> =C2=A0 cares whether the file is a kernel interface
>=20
> Add a helper that does all of it in one place. It only accepts
> regular
> files and, if the caller passes S_IFBLK, block devices. It refuses
> files
> on pseudo filesystems. And it checks that the file is open for what
> the
> caller is going to do with it and implements ->read_iter() for
> reading
> and ->write_iter() for writing.
>=20
> O_PATH files are refused unless the caller passes FMODE_PATH. That is
> for callers that only need the path of the file. fuse passthrough is
> one of them and has accepted O_PATH file descriptors since commit
> efad7153bf93 ("fuse: allow O_PATH fd for FUSE_DEV_IOC_BACKING_OPEN").
>=20
> Block devices are fine even though bdevfs is a pseudo filesystem. A
> block device that userspace hands in is a device node on devtmpfs or
> some other filesystem. Files on bdevfs only come from
> bdev_file_open_by_*() and never end up here.
>=20
> The pseudo filesystem check looks at the inode that actually provides
> the data via d_real_data_inode(). overlayfs accepts sysfs, cgroup2,
> debugfs, tracefs, configfs and securityfs as lower layers and reads
> of
> such an overlayfs file are served by the file on the pseudo
> filesystem.
> Checking the overlayfs inode would miss that.
>=20
> For an O_PATH file nothing might have looked up the data yet.
> overlayfs
> only looks up the data of a metacopy file in a data-only layer when
> the
> file is opened. d_real_data_inode() does the lookup then and if that
> fails we return the error.
>=20
> Note that the file type is taken from the inode of the file and not
> from
> the host of ->f_mapping like loop and the gadget do it. A driver can
> point ->f_mapping somewhere else in ->open(). It makes no difference
> for
> block devices as both inodes are block devices.
>=20
> No functional changes. Nothing calls the helper yet.
>=20

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/read_write.c=C2=A0=C2=A0=C2=A0 | 53
> +++++++++++++++++++++++++++++++++++++++++++++++++++++
> =C2=A0include/linux/fs.h |=C2=A0 2 ++
> =C2=A02 files changed, 55 insertions(+)
>=20
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 6767283108991..9f1e7bfcbd4f1 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -866,6 +866,59 @@ static ssize_t do_loop_readv_writev(struct file
> *filp, struct iov_iter *iter,
> =C2=A0	return ret;
> =C2=A0}
> =C2=A0
> +/**
> + * file_check_backing - check that the kernel can use a file as
> storage
> + * @file: file that userspace handed in
> + * @mode: FMODE_READ and/or FMODE_WRITE the kernel will do I/O with,
> or
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 FMODE_PATH if only the path=
 of @file is used
> + * @type: S_IFBLK if a block device is fine as well, 0 otherwise
> + *
> + * Call this where a file from userspace is taken as a backing file.
> Only
> + * regular files and, if @type is S_IFBLK, block devices are
> storage. Files
> + * on pseudo filesystems are kernel interfaces and are refused. The
> file
> + * must be open for @mode and implement ->read_iter() for reading
> and
> + * ->write_iter() for writing. O_PATH files are only fine with
> FMODE_PATH.
> + *
> + * Return: 0 on success, -EBADF if @file isn't open for @mode, -
> EINVAL if it
> + * can't be used as storage, or the error from looking up the data
> of @file
> + * on a stacking filesystem.
> + */
> +int file_check_backing(const struct file *file, fmode_t mode,
> umode_t type)
> +{
> +	fmode_t io =3D mode & (FMODE_READ | FMODE_WRITE);
> +	/* Drivers may point ->f_mapping at something else. */
> +	umode_t fmt =3D file_inode(file)->i_mode & S_IFMT;
> +	struct inode *real_inode;
> +
> +	/* O_PATH files are only fine for callers that just use the
> path. */
> +	if ((file->f_mode & FMODE_PATH) && !(mode & FMODE_PATH))
> +		return -EBADF;
> +
> +	if ((file->f_mode & io) !=3D io)
> +		return -EBADF;
> +
> +	if (fmt !=3D S_IFREG && !(type =3D=3D S_IFBLK && fmt =3D=3D S_IFBLK))
> +		return -EINVAL;
> +
> +	/* Look through stacking filesystems at the inode with the
> data. */
> +	real_inode =3D d_real_data_inode(file->f_path.dentry);
> +	if (IS_ERR(real_inode))
> +		return PTR_ERR(real_inode);
> +	if (real_inode->i_sb->s_iflags & SB_I_PSEUDO)
> +		return -EINVAL;
> +
> +	if ((mode & FMODE_READ) &&
> +	=C2=A0=C2=A0=C2=A0 (!(file->f_mode & FMODE_CAN_READ) || !file->f_op-
> >read_iter))
> +		return -EINVAL;
> +
> +	if ((mode & FMODE_WRITE) &&
> +	=C2=A0=C2=A0=C2=A0 (!(file->f_mode & FMODE_CAN_WRITE) || !file->f_op-
> >write_iter))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(file_check_backing);
> +
> =C2=A0ssize_t vfs_iocb_iter_read(struct file *file, struct kiocb *iocb,
> =C2=A0			=C2=A0=C2=A0 struct iov_iter *iter)
> =C2=A0{
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 99caef43ff3c4..b1c7ebafbadbe 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2553,6 +2553,8 @@ static inline const struct inode
> *file_user_inode(const struct file *f)
> =C2=A0	return file_inode(f);
> =C2=A0}
> =C2=A0
> +int file_check_backing(const struct file *file, fmode_t mode,
> umode_t type);
> +
> =C2=A0static inline struct file *file_clone_open(struct file *file)
> =C2=A0{
> =C2=A0	return dentry_open(&file->f_path, file->f_flags, file-
> >f_cred);

