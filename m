Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93C19606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 13:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4A06B05C7; Mon, 16 Nov 2026 08:07:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78D626B05C9; Mon, 16 Nov 2026 08:07:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CA576B05CA; Mon, 16 Nov 2026 08:07:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CFB66B05C7
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:07:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E242BA0840
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:07:47 +0000 (UTC)
X-FDA: 85441009374.08.6BA4531
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 85DECA0007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:07:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794834466;
	b=kwsRj00lIvWCvKxaYPUkH9A7DfOrE4k+ybqSDHaRc15bXv1gJdJyyKb0k03Wiqs9HLOlna
	V6l5SiqFEeNvV4unHAWbqlALRUyDMeWK7pUxX0WNQt8qy7UI0PcNhKNcFa3xrmDLcSjdIz
	YafARibJvK5BzeJLAKhQ0p3TMvK8iJw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794834466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/79yD/ePkhOWtFp46GUyu6ts/vcC2MmXQ7vdqbMevlI=;
	b=8U5o8vuZTD/OxkBQfxFoViiZ1LSpahGRt7JBVqxBd7CCM4p/+7K4ONIqK/oSf5y8WoccZG
	bdtcAw1jWMZsd12GDyt9SpXwi97FHU5sF8LH4+wckRgjB5857WZnElkkimaDkKnPY36keS
	gbGEG8FKCvFK2UJBOFL0IpkMcDuDqos=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 19E8621DC4;
	Mon, 16 Nov 2026 13:07:44 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DE2B51334C;
	Mon, 16 Nov 2026 13:07:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BvIgLh8A+2pNEgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 16 Nov 2026 13:07:43 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 6CC7424E06; Mon, 16 Nov 2026 14:07:43 +0100 (CET)
Date: Mon, 16 Nov 2026 14:07:43 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
	linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC v3 35/44] fs: add file_check_backing()
Message-ID: <fvmgoq6g3orrcbz5j7xoxrqkz4kc4jiopndjfar4cv45pj2y4g@bfgcucrsffnm>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
 <20261116-work-loop-pseudo-v3-35-8cbbea1cf34f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-work-loop-pseudo-v3-35-8cbbea1cf34f@kernel.org>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spam-Score: -4.00
X-Stat-Signature: 8au8myqdo6hqb7hnbn3q8h7mxqsyn8om
X-Rspamd-Queue-Id: 85DECA0007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794834465-468834
X-HE-Meta: U2FsdGVkX1+byFaAO6cgZnkM2OXY0EIWLtLW/dI4KcfY0JiyzeIWHVuvg2tzbm2mZwi36prj9WqW3kcMReHsfba0we3PMSco2PmUs7Ri/eGloLjBpDHBfl3UyayEgKz1nkinfxADBH4mhdraHCNnsh9FwKrOcwefBfG4LOIGvRKc3xb+OVgAIw3BsU7/1rUwKUkWbPrFYgwVY1IfxHqksBcX5R5sdqAfin8gBJir+un1CnX0DAl0eKrD0wbZcSRGq1Sx+G0XmOra8krRHh2VdXJKcpV81+qaZ68sB9AyjiNbWJ4kMaROCXfFPHJEnYWDZcILzpcWxmEtQ5Sg7K/GmRzNmDAYj/vxBjSRUupSPngizfUyBOLKL+i2FNVF255IFVPPQMddMXKEV4n9pAfNoucgFVcltj5G6roQiDPs95+0Qkoef5P1Au86cULKYC2TomrEnxVKC8RkEHXfofVzP5S3WrENW3+CvLqTviSH1jaHegfn7gDLg+zxBRpXycMWYqGcAgP7x5mLmPl776XHBpmzrcTJonRx+QDN/xLcHZQ8SJUNc9sZbRI/se1NYes7zgz1olgclieTHQlUwo6Dcm7tKFCAobIKCZrtEtWjbIyLn0P5tPW3muZ1mi1D/8kTFM461/2NKNPqpV/aJS21yWK1W/n2PDOyoEpBdacl9FkI1cPKFzdqiQKjYmXMq06mvuoMzvDY/xGUxP1wsvWaoz6aP3P8DQIKFLu76GJ2tFfNrpfN3Cq0QIBqXCJtFSzIZaVlXTqNA0uWytdn+DlIE0hTljlHHT9G/GZyXj7b3DiopXmKkf68XWerb2iHiERl2NQTM5HXMnCuOilt5wW6hM5Z47msse9g9UYzJosC4bh1Vgx7rn6im6cjBkMXJ8nO6lPyGhMrQ+29G9ukzDzqLqHWoxbPB52nsltbNhb5USFnNobgREDZeKe/aFbJHN+Zi4oyTD2cYt7k7j5r1eV
 t53xLNGy
 +u5O7aQv4X5BgRwWw7piv0kRsrEyudzS4HIn6AjariFAEpyCZtIb4OM6xjc+g+qB5L6rUeSsAvEpRCzSnGOLAIF5E+WDnC8qogUJ6f+AYyfPth+VLsdxZMh2vTPTFNCXchzErv1t3WQsuuhO3kMAFlFCxNOy+AcRbcQ0seuHweWPP+lEzl/JRa81qxcL69Nia2r9qfFOqMrbwKv4BS0sunUF/R+GkphTREA3hGpCWp0ymZXV/nJrrcYRLHcJ96s8XCUGV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 16-11-26 12:05:08, Christian Brauner wrote:
> Loop, zloop, the nvme target, the scsi target, fuse passthrough, the usb
> mass storage gadget, erofs and acct all take a file from userspace and
> use it as storage. Currently, each of them has its own idea of what to
> check before using a file like that:
> 
> - loop and the gadget check for a regular file or a block device, the
>   nvme target, the scsi target and zloop take any file type
> - loop checks the open mode, the gadget checks FMODE_CAN_READ, the nvme
>   target, the scsi target and zloop only check for ->read_iter() and
>   ->write_iter()
> - apart from acct which refuses procfs and sysfs files none of them
>   cares whether the file is a kernel interface
> 
> Add a helper that does all of it in one place. It only accepts regular
> files and, if the caller passes S_IFBLK, block devices. It refuses files
> on pseudo filesystems. And it checks that the file is open for what the
> caller is going to do with it and implements ->read_iter() for reading
> and ->write_iter() for writing.
> 
> O_PATH files are refused unless the caller passes FMODE_PATH. That is
> for callers that only need the path of the file. fuse passthrough is
> one of them and has accepted O_PATH file descriptors since commit
> efad7153bf93 ("fuse: allow O_PATH fd for FUSE_DEV_IOC_BACKING_OPEN").
> 
> Block devices are fine even though bdevfs is a pseudo filesystem. A
> block device that userspace hands in is a device node on devtmpfs or
> some other filesystem. Files on bdevfs only come from
> bdev_file_open_by_*() and never end up here.
> 
> The pseudo filesystem check looks at the inode that actually provides
> the data via d_real_data_inode(). overlayfs accepts sysfs, cgroup2,
> debugfs, tracefs, configfs and securityfs as lower layers and reads of
> such an overlayfs file are served by the file on the pseudo filesystem.
> Checking the overlayfs inode would miss that.
> 
> For an O_PATH file nothing might have looked up the data yet. overlayfs
> only looks up the data of a metacopy file in a data-only layer when the
> file is opened. d_real_data_inode() does the lookup then and if that
> fails we return the error.
> 
> Note that the file type is taken from the inode of the file and not from
> the host of ->f_mapping like loop and the gadget do it. A driver can
> point ->f_mapping somewhere else in ->open(). It makes no difference for
> block devices as both inodes are block devices.
> 
> No functional changes. Nothing calls the helper yet.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/read_write.c    | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h |  2 ++
>  2 files changed, 55 insertions(+)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 6767283108991..9f1e7bfcbd4f1 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -866,6 +866,59 @@ static ssize_t do_loop_readv_writev(struct file *filp, struct iov_iter *iter,
>  	return ret;
>  }
>  
> +/**
> + * file_check_backing - check that the kernel can use a file as storage
> + * @file: file that userspace handed in
> + * @mode: FMODE_READ and/or FMODE_WRITE the kernel will do I/O with, or
> + *        FMODE_PATH if only the path of @file is used
> + * @type: S_IFBLK if a block device is fine as well, 0 otherwise
> + *
> + * Call this where a file from userspace is taken as a backing file. Only
> + * regular files and, if @type is S_IFBLK, block devices are storage. Files
> + * on pseudo filesystems are kernel interfaces and are refused. The file
> + * must be open for @mode and implement ->read_iter() for reading and
> + * ->write_iter() for writing. O_PATH files are only fine with FMODE_PATH.
> + *
> + * Return: 0 on success, -EBADF if @file isn't open for @mode, -EINVAL if it
> + * can't be used as storage, or the error from looking up the data of @file
> + * on a stacking filesystem.
> + */
> +int file_check_backing(const struct file *file, fmode_t mode, umode_t type)
> +{
> +	fmode_t io = mode & (FMODE_READ | FMODE_WRITE);
> +	/* Drivers may point ->f_mapping at something else. */
> +	umode_t fmt = file_inode(file)->i_mode & S_IFMT;
> +	struct inode *real_inode;
> +
> +	/* O_PATH files are only fine for callers that just use the path. */
> +	if ((file->f_mode & FMODE_PATH) && !(mode & FMODE_PATH))
> +		return -EBADF;
> +
> +	if ((file->f_mode & io) != io)
> +		return -EBADF;
> +
> +	if (fmt != S_IFREG && !(type == S_IFBLK && fmt == S_IFBLK))
> +		return -EINVAL;
> +
> +	/* Look through stacking filesystems at the inode with the data. */
> +	real_inode = d_real_data_inode(file->f_path.dentry);
> +	if (IS_ERR(real_inode))
> +		return PTR_ERR(real_inode);
> +	if (real_inode->i_sb->s_iflags & SB_I_PSEUDO)
> +		return -EINVAL;
> +
> +	if ((mode & FMODE_READ) &&
> +	    (!(file->f_mode & FMODE_CAN_READ) || !file->f_op->read_iter))
> +		return -EINVAL;
> +
> +	if ((mode & FMODE_WRITE) &&
> +	    (!(file->f_mode & FMODE_CAN_WRITE) || !file->f_op->write_iter))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(file_check_backing);
> +
>  ssize_t vfs_iocb_iter_read(struct file *file, struct kiocb *iocb,
>  			   struct iov_iter *iter)
>  {
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 99caef43ff3c4..b1c7ebafbadbe 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2553,6 +2553,8 @@ static inline const struct inode *file_user_inode(const struct file *f)
>  	return file_inode(f);
>  }
>  
> +int file_check_backing(const struct file *file, fmode_t mode, umode_t type);
> +
>  static inline struct file *file_clone_open(struct file *file)
>  {
>  	return dentry_open(&file->f_path, file->f_flags, file->f_cred);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

