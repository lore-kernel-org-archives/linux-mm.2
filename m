Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 194F1606A337
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 02:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=dmJo6jxo
Received: by kanga.kvack.org (Postfix)
	id 3BDE46B00EF; Fri, 13 Nov 2026 21:17:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 396566B05B1; Fri, 13 Nov 2026 21:17:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284596B05B3; Fri, 13 Nov 2026 21:17:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 06E926B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:17:29 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E0CE12030C
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:17:29 +0000 (UTC)
X-FDA: 85432113018.05.CA460D8
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf21.hostedemail.com (Postfix) with ESMTP id F31831C0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:17:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=dmJo6jxo;
	spf=pass (imf21.hostedemail.com: domain of chengzhihao1@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=chengzhihao1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794622647;
	b=TqWIQbLlNP3DdNTrtDOCeRS0ZFcOQOvLyotj1TGApx7VgKZ0k+QWRatwDeYpe9H7h/elw/
	vVKHBsohV8F6NKAcOaMIQTXMWIdmLl/CJsBQC4wWdYu5FAW1yCROpiWOYckI8q0p1h4ViK
	QOffjT7MqvOJVwvWfB6F2bL/3QB+x30=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=dmJo6jxo;
	spf=pass (imf21.hostedemail.com: domain of chengzhihao1@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=chengzhihao1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794622647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lamjSy1jct+Y32LWUG/7mqOA0l+lzlvT/xdWWaLZFKQ=;
	b=kIKkPN2hI8/fmTMp2q+2JEIeIDPJ0dKp/Vt2OKUCoLPxpwt2sesCjDsVy/5I4Ob0ItTwOg
	a7EWeGsh5IsAiEPR7ZFJSwhgBnxxojnKRowlria0nnrR9HslUuxAJikoePJ+bw60HKFcaC
	ySzggvDtrRCLewnRHywvneELM2LDB+M=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lamjSy1jct+Y32LWUG/7mqOA0l+lzlvT/xdWWaLZFKQ=;
	b=dmJo6jxorxqj/soF5hgiJAk0L/VbZ+b6NQ150G77AKdiKykroxkSgy9jha28sMjYHaadv7xU4
	gX5qGcCNkavMkbqMIDp0Pr2diskt5hVLJa0+T41ntlJJoc8GUBBS7KeBABGtvyISA72TUzk8pOV
	JKQ3g1KA+Ky1blIGX4Su+70=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4jRHnX4bKrz1K98l;
	Sat, 14 Nov 2026 10:17:04 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 8F8174048B;
	Sat, 14 Nov 2026 10:17:15 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 whupemo200011.china.huawei.com (7.152.185.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 14 Nov 2026 10:17:13 +0800
Subject: Re: [PATCH v3 30/33] ubifs: don't set SB_RDONLY after errors
To: Christian Brauner <brauner@kernel.org>, <linux-fsdevel@vger.kernel.org>,
	Jan Kara <jack@suse.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, <ecryptfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <jfs-discussion@lists.sourceforge.net>,
	<linux-nilfs@vger.kernel.org>, <exfat@lists.linux.dev>, <linux-mm@kvack.org>,
	<ntfs@lists.linux.dev>, <ocfs2-devel@lists.linux.dev>,
	<linux-btrfs@vger.kernel.org>, <gfs2@lists.linux.dev>,
	<linux-efi@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
	<linux-xfs@vger.kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-30-0be92bb73709@kernel.org>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <17287026-cccc-f56c-15a3-029b9a2c38c9@huawei.com>
Date: Sat, 14 Nov 2026 10:17:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-30-0be92bb73709@kernel.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemo200011.china.huawei.com (7.152.185.179)
X-Stat-Signature: kqb9r3qs5c1gtspxf4w4331wtjzhuqhh
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F31831C0005
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794622644-344942
X-HE-Meta: U2FsdGVkX18jfb05oeKWob/EBeQmLOXJpqUEDprpfq5ojNNv+NIKoXcb+b8tKItYLarhozCMEQ0QrhzFCVeI2tql1Va1Xq8jmrQCWvh6URdOnIAPKIoBHEKAX7swRVymtlFA/ZziujlNeaz7AMzr1LsHNi9hQWyA1ttvn0RzpOqNit8ZQfwOExmA2MHVbPIyxKW9y5mlWH416+Oy0wgjOrrXKpNLUQtBhUAx/DiZeh0YMS5COXS/7j4ht/GdpQPqlPyP8/nkxtT3+klE+1C3ePOWwAkb8Y7yhLZQbbG2tWBhkQ65Sytkg4TDUSgnMr8akzVMsrJNbndLsjglSJio+q6yLYIzBRICbrXeBuDFnLufpGJpue2rDZM4zTx5hKibhIakIyKV8uhI/SCCb4TVrCs7pWtM+na8Z8Gqu+TSBdVm718aCMM3X4SVKMaqF/hB+JM0rWPFIlJKnCaVG4leJQvyCJeom7WzRjfHcFk2LB7zFIKWEy6UAut1XYgDxfZ1XhUNb1aEGnmDt2zVUaegUEyHIKrBSfIpDLQKlvxFd7PUr5h/abQIbg7JOGh0jtIqtye7pgnzo61R0hIBmeYVc+H49r0YkDAM0sdyJTgwvD/GoXhjcReZ5CkKb4H9R/T7wthftWPHLqXw71JhTdPw5btd4pHGY0Dfm4LlUCY3KW2PdeV1/TXIQYqpo8Rs8M0ZyH+zCG22yiL/m4TuQyYk7HtI4YB/LFiSkIUpXFsZPfkXrwjUyCRWD+hPHhFpou1wleXNzO1zl4wq8ETS54DTfONMV94GHM55qdrpPR3T+mLhHDR4g/a9cN5L8ZkU9ZluC81cZ1PhvAdaP5K+z/5eHkKwyKxfhYZFoJPFXhw26F8tOD6mQ4y+I8STnqbzGb05xqEfSf+T1r2zPWt33kRncBPdCCHWpYAyQrgjTPe0y0/dUhuu9hE/oOuQgZ79o9fRtiUsLxE1E2Iq29OuZjj
 mXf07ZXT
 pW56ElFTh8LSAVoEWEuVnKl2isN4IyLMv1k3BpkQVIVTzUCH2nhDA/MDuuPk+IAFvR5o+Iu6HjUPzb4wXF81rtTSSoEjjyD9I6N4Rc8bgxBHyUTggUKv0G5OMVqSvcz3VHVajxaOYPfMTuvUypGX3LoYCp9mSoojXVnzZeMkUGhtcRS83cSfyy46PkuBBLxNPoYwmWzwaZItkOqPpUxej50m8UumkmBz52M8ncS/8MEw6eAohz3RCXmz8cHe3d5DTwe0d69nrzA76bjWgGkPz68PwNk+tggJAWDfmmxzdM/pojixHHitYM0o3RxA8RGdtM+BvrPwKiuyA9AcfuzrJDGXeuqr2PXuTimxXu/h9n/75sS9DOXHjc2v1MdADZdV83LtEWpIjogmw3X+yb0YpM6G8Uo050H/fjr28Z/ovaeLOIdwdaP4k7EaUsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ÔÚ 2026/11/13 19:59, Christian Brauner Ð´µÀ:
> ubifs_ro_mode() sets c->ro_error and SB_RDONLY from whatever context hit
> the error, e.g. a failing write, and without holding s_umount. UBIFS
> can't be frozen but that still races with everyone else changing
> sb->s_flags. And c->ro_error alone already makes every write fail with
> EROFS.
> 
> So call sb_set_emergency_ro() instead. The background thread can hit
> the error before SB_BORN but doesn't hold s_umount either. The xattr
> setters check c->ro_error as well because ecryptfs calls them without
> write access on the lower mount and they change the inode in memory
> first.
> 
> So far a remount to read-only after an error was refused and a remount
> to read-write went through and cleared SB_RDONLY again because
> c->ro_mount was never set. Now going read-only works. Nothing is synced
> for it in that state and ubifs_remount_ro() skips the write-buffer syncs
> and the master node like ubifs_put_super() does and only cancels the
> write-buffer timers. Going read-write after that is refused by the VFS.
> 
> The flusher still gets to the folios and inodes that were dirty before
> the error, also after the remount which sets c->ro_mount and frees the
> write reserve buffer. Every journal write fails with EROFS after an
> error anyway. So do_writepage() and ubifs_write_inode() drop them
> without going near the journal. Otherwise reserve_space() trips its
> !c->ro_mount assert for every folio after the remount.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>   fs/ubifs/file.c  | 12 ++++++++++++
>   fs/ubifs/io.c    |  6 +++++-
>   fs/ubifs/super.c | 40 ++++++++++++++++++++++++++--------------
>   fs/ubifs/xattr.c |  6 ++++++
>   4 files changed, 49 insertions(+), 15 deletions(-)

Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
> 
> diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
> index 99dd52715eee9..4eae6c2ae2eea 100644
> --- a/fs/ubifs/file.c
> +++ b/fs/ubifs/file.c
> @@ -898,6 +898,13 @@ static int do_writepage(struct folio *folio, size_t len)
>   
>   	folio_start_writeback(folio);
>   
> +	/* Nothing gets written after an error, drop the folio. */
> +	if (unlikely(c->ro_error)) {
> +		err = -EROFS;
> +		mapping_set_error(folio->mapping, err);
> +		goto out;
> +	}
> +
>   	block = folio->index << UBIFS_BLOCKS_PER_PAGE_SHIFT;
>   	for (;;) {
>   		blen = min_t(size_t, len, UBIFS_BLOCK_SIZE);
> @@ -918,6 +925,7 @@ static int do_writepage(struct folio *folio, size_t len)
>   		ubifs_ro_mode(c, err);
>   	}
>   
> +out:
>   	ubifs_assert(c, folio->private != NULL);
>   	if (folio_test_checked(folio))
>   		release_new_page_budget(c);
> @@ -997,6 +1005,10 @@ static int ubifs_writepage(struct folio *folio, struct writeback_control *wbc)
>   		goto out_unlock;
>   	}
>   
> +	/* After an error do_writepage() drops the folio. */
> +	if (unlikely(c->ro_error))
> +		return do_writepage(folio, len);
> +
>   	spin_lock(&ui->ui_lock);
>   	synced_i_size = ui->synced_i_size;
>   	spin_unlock(&ui->ui_lock);
> diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
> index 6c6d682427793..931a88329b5f5 100644
> --- a/fs/ubifs/io.c
> +++ b/fs/ubifs/io.c
> @@ -72,7 +72,11 @@ void ubifs_ro_mode(struct ubifs_info *c, int err)
>   	if (!c->ro_error) {
>   		c->ro_error = 1;
>   		c->no_chk_data_crc = 0;
> -		c->vfs_sb->s_flags |= SB_RDONLY;
> +		/*
> +		 * SB_RDONLY needs s_umount, see sb_set_emergency_ro(). The
> +		 * background thread runs before SB_BORN already.
> +		 */
> +		sb_set_emergency_ro(c->vfs_sb);
>   		ubifs_warn(c, "switched to read-only mode, error %d", err);
>   		dump_stack();
>   	}
> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
> index 38972786817e7..2d71274e89ad0 100644
> --- a/fs/ubifs/super.c
> +++ b/fs/ubifs/super.c
> @@ -312,6 +312,12 @@ static int ubifs_write_inode(struct inode *inode, struct writeback_control *wbc)
>   		return 0;
>   	}
>   
> +	/* Nothing gets written after an error, drop the change. */
> +	if (unlikely(c->ro_error)) {
> +		err = -EROFS;
> +		goto out;
> +	}
> +
>   	/*
>   	 * As an optimization, do not write orphan inodes to the media just
>   	 * because this is not needed.
> @@ -327,6 +333,7 @@ static int ubifs_write_inode(struct inode *inode, struct writeback_control *wbc)
>   			err = dbg_check_inode_size(c, inode, ui->ui_size);
>   	}
>   
> +out:
>   	ui->dirty = 0;
>   	mutex_unlock(&ui->ui_mutex);
>   	ubifs_release_dirty_inode_budget(c, ui);
> @@ -1839,19 +1846,26 @@ static void ubifs_remount_ro(struct ubifs_info *c)
>   
>   	dbg_save_space_info(c);
>   
> -	for (i = 0; i < c->jhead_cnt; i++) {
> -		err = ubifs_wbuf_sync(&c->jheads[i].wbuf);
> +	/* Like ubifs_put_super(), don't write anything after an error. */
> +	if (!c->ro_error) {
> +		for (i = 0; i < c->jhead_cnt; i++) {
> +			err = ubifs_wbuf_sync(&c->jheads[i].wbuf);
> +			if (err)
> +				ubifs_ro_mode(c, err);
> +		}
> +
> +		c->mst_node->flags &= ~cpu_to_le32(UBIFS_MST_DIRTY);
> +		c->mst_node->flags |= cpu_to_le32(UBIFS_MST_NO_ORPHS);
> +		c->mst_node->gc_lnum = cpu_to_le32(c->gc_lnum);
> +		err = ubifs_write_master(c);
>   		if (err)
>   			ubifs_ro_mode(c, err);
> +	} else {
> +		/* Syncing the write-buffers would have canceled them. */
> +		for (i = 0; i < c->jhead_cnt; i++)
> +			hrtimer_cancel(&c->jheads[i].wbuf.timer);
>   	}
>   
> -	c->mst_node->flags &= ~cpu_to_le32(UBIFS_MST_DIRTY);
> -	c->mst_node->flags |= cpu_to_le32(UBIFS_MST_NO_ORPHS);
> -	c->mst_node->gc_lnum = cpu_to_le32(c->gc_lnum);
> -	err = ubifs_write_master(c);
> -	if (err)
> -		ubifs_ro_mode(c, err);
> -
>   	vfree(c->orph_buf);
>   	c->orph_buf = NULL;
>   	kfree(c->write_reserve_buf);
> @@ -1977,10 +1991,7 @@ static int ubifs_reconfigure(struct fs_context *fc)
>   		if (err)
>   			return err;
>   	} else if (!c->ro_mount && (fc->sb_flags & SB_RDONLY)) {
> -		if (c->ro_error) {
> -			ubifs_msg(c, "cannot re-mount R/O due to prior errors");
> -			return -EROFS;
> -		}
> +		/* After an error ubifs_remount_ro() can't write but still works. */
>   		ubifs_remount_ro(c);
>   	}
>   
> @@ -1994,7 +2005,8 @@ static int ubifs_reconfigure(struct fs_context *fc)
>   		mutex_unlock(&c->bu_mutex);
>   	}
>   
> -	if (!c->need_recovery)
> +	/* Only valid without a media failure, see ubifs_put_super(). */
> +	if (!c->need_recovery && !c->ro_error)
>   		ubifs_assert(c, c->lst.taken_empty_lebs > 0);
>   
>   	return 0;
> diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
> index 3b0e8a270f594..572f6f3e52ad3 100644
> --- a/fs/ubifs/xattr.c
> +++ b/fs/ubifs/xattr.c
> @@ -260,6 +260,9 @@ int ubifs_xattr_set(struct inode *host, const char *name, const void *value,
>   	if (check_lock)
>   		ubifs_assert(c, inode_is_locked(host));
>   
> +	if (c->ro_error)
> +		return -EROFS;
> +
>   	if (size > UBIFS_MAX_INO_DATA)
>   		return -ERANGE;
>   
> @@ -564,6 +567,9 @@ static int ubifs_xattr_remove(struct inode *host, const char *name)
>   
>   	ubifs_assert(c, inode_is_locked(host));
>   
> +	if (c->ro_error)
> +		return -EROFS;
> +
>   	if (fname_len(&nm) > UBIFS_MAX_NLEN)
>   		return -ENAMETOOLONG;
>   
> 


