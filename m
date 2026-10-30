Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 354E9606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 03:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=6lgTf+Ts
Received: by kanga.kvack.org (Postfix)
	id 16CA86B00EF; Thu, 29 Oct 2026 23:42:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11F206B05B1; Thu, 29 Oct 2026 23:42:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033D06B05B2; Thu, 29 Oct 2026 23:42:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C4AFA6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:42:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4CDDEC05CB
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:42:29 +0000 (UTC)
X-FDA: 85377895218.04.F463F54
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf13.hostedemail.com (Postfix) with ESMTP id A035920002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:42:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=6lgTf+Ts;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of chengzhihao1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=chengzhihao1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793331747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lyCCkGxsVqCH5Jxp2Gx73Ra2R6gYJ0X0+xLM8KV7Nyw=;
	b=XqYoPqXku9w6fttJesJsCN58wOmCCI28tXveX6i9KgUI0RaC4PovZh/+eIF4668ZSQxKYk
	YXHV/i0XhWD4hYTlejJpqvUR20q11+ufXu9re8hH87ZJLhdK5gM0B87wXcqjRnUJDKdO4o
	wL1UFGh04KQrcAFOKiwVzwBWlyU3O0A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=6lgTf+Ts;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of chengzhihao1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=chengzhihao1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793331747;
	b=e7IrsALz7nFRpm4rMKkMU4r9wmlqBbDdynSSqbFGhwSvyy+LCGXpaYjdWz8K3KfkTQJBFs
	C2kRV10NCzHUFD5Plz9nMbYksJG8/Mm4i/1v8I/HZL3SFZd0m3lyGwYE9RDPORcxlmMrM9
	2MrpqjttsBjGvPRIvAU0Si3zCVJCSFA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lyCCkGxsVqCH5Jxp2Gx73Ra2R6gYJ0X0+xLM8KV7Nyw=;
	b=6lgTf+Ts1V+YHSBCrEFvDEXDhiMC9GXMq3b2wsOqtZVSt4aNi9cNouzzS6JDieVJF34tbk3Eh
	hET2+S5R51zLlg3+fDdAp58YFcw5B6/T2rmuCau0hbz720kofk1l0vMy/ktC5xSYSNUX71IMs/h
	Me1Uuzuu58wyIDDAb/XNnkQ=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4jG6NZ0f5mz1T4G5;
	Fri, 30 Oct 2026 11:42:06 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 483B3202E6;
	Fri, 30 Oct 2026 11:42:18 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 whupemo200011.china.huawei.com (7.152.185.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 30 Oct 2026 11:42:16 +0800
Subject: Re: [PATCH v2 28/34] ubifs: don't set SB_RDONLY after errors
To: Christian Brauner <brauner@kernel.org>, <linux-fsdevel@vger.kernel.org>,
	Jan Kara <jack@suse.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, <ecryptfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <jfs-discussion@lists.sourceforge.net>,
	<linux-nilfs@vger.kernel.org>, <exfat@lists.linux.dev>, <linux-mm@kvack.org>,
	<ntfs@lists.linux.dev>, <ocfs2-devel@lists.linux.dev>,
	<linux-btrfs@vger.kernel.org>, <gfs2@lists.linux.dev>,
	<linux-efi@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
	<linux-xfs@vger.kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-28-2f44f64f0b66@kernel.org>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <0d472865-6cbb-cbb5-b361-1f2bf71dd528@huawei.com>
Date: Fri, 30 Oct 2026 11:42:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-28-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemo200011.china.huawei.com (7.152.185.179)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A035920002
X-Stat-Signature: kb6ghhw81bmb6uh4fb5fkz56fj7ejrti
X-Spam-Status: No, score=-18.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793331745-566238
X-HE-Meta: U2FsdGVkX18RKqadLEw3XPbrE1qGPoZh3UN4I0j5NbOYcSmHpr188K9JAZou2TvVUot/No/lLfFGNKGLYW6VU1Nis9vYIgpX0Q2kFk95rxIFxhfi2EXcTPoeJ9BeoQVnrw72zTRQfaAVTQHqmyRGVgaP1Bfr0RY/5DFmReWixH48iUUSK3khEsHuJ4ebM5fvsWsYMTVYXOeolktZtWowFxOgy9A9i3TZrtvvLdRAr9Ywn4+SOHFS3wSSJ38Xn+WW5IOv5YO0BOA/8IotojfA2juf1vF2fu8vv5TlFZUHZx6PVVwjlwAWYRO+VtJf1I2f0uDEInSVdqWa9sBj6grrHhRY252st5Co9AS8Eb9IyVE5RoLS5I72YuY9FZFvym+gPMjfSqt6IFfzt6TsHwUlPctzSDO6KhOyr3HiaSHrRnLG8gtS6EM+m/n9FjI2brVwPcmCYha2yhbAH2qFUIjCR0DIjAyqoxzK/ZdpZMwH79ZWxdEV/YJ3kezQfzpzO3tSkSpaekLC4/BW1Lx/iMEgz6DVrXqCQuHX2uEFnr1lBK6x6Ra62akStp0OlEUfP0RRj/k9A4i8uaS8oAyIgoxItj1dewrEJPMjkBJRcXs+F7jraQYUtbIobh3rKDvXYF0/BT6CNIQdOCgzXbjVufnt5bSveqakdUyzuNEk2KkEufiygd3vBOxB2Me7uWjAvqUcNew4+9jSrZlJRh2Iq/SfvvfarrpKlhzvkJeQ+OKI2O7jwN2YKmZRHk4MR7mu1KtKXkYutlVDk0C996RWz/8/GDrAB1gqpRf3aj7LlaTa9HRBXcz+HJbU9yoN9V3ihqaUjEXYaJizpdexxu/2y4Yb3whIq8POe6xyU3zLwgjZ2FMIdPxS/7vx33XYb0VjWrYYEUprZS+oxzSyC7RQsvOBeo+Awvi5z5XvGuFvFoFcoyssp7UQq0n4OyFA7PotmdtTVmapBy3BhZ1IdM3ZFAi
 N639DFLF
 f9GClhra+oY07/For9xuUwES4jjiyCIhg3LPtDD1efs2NuFw2lsqKiqSAgcCIMF3TdLkXjXia71E92VBGLrJkt+FlZfPct+o4tr23C9dbDyoiNhL1o87ggvwnSuBYKHIYqLkkDCmZzuqLCIKOsma8dkX3qY+trptdzT0x9l022osjr6SmH9vxjIchqAgisUtXKaAok3yIkjoAfsLDWWqpaXw7aa2WereEBtr+Sua9AOy4Ko3zAzyZH2OU97GuaBM+zGYFXv488w9paLy1pkNfg0PmanKDcwz8ZEjRVn6kaPlGRWUSl+qX5Sje/5h6ajNdjxH7Cr2lcjF3xJINq7YWIzHOoMoQZXsbXdFcx6R405z3YqW17syMFMhac53CzDf1yE/X32yzs2YiGZoQKcY7+ZZTWG/pXU4a2yp1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ÔÚ 2026/10/30 0:07, Christian Brauner Ð´µÀ:
> ubifs_ro_mode() sets c->ro_error and SB_RDONLY from whatever context hit
> the error, e.g. a failing write, and without holding s_umount. UBIFS
> can't be frozen but that still races with everyone else changing
> sb->s_flags. And c->ro_error alone already makes every write fail with
> EROFS.
> 
> So only set SB_RDONLY while the filesystem is still being mounted and
> call sb_set_emergency_ro() after that. The xattr setters check
> c->ro_error as well because ecryptfs calls them without write access on
> the lower mount and they change the inode in memory first.
> 
> So far a remount to read-only after an error was refused and a remount
> to read-write went through and cleared SB_RDONLY again because
> c->ro_mount was never set. Now going read-only works and its writes fail
> with EROFS before any I/O, and going read-write is refused by the VFS.
> fsync() fails with EROFS instead of taking ubifs_fsync()'s read-only
> shortcut.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>   fs/ubifs/io.c    | 9 ++++++++-
>   fs/ubifs/super.c | 5 +----
>   fs/ubifs/xattr.c | 6 ++++++
>   3 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
> index 6c6d68242779..7a59aa1ea5ce 100644
> --- a/fs/ubifs/io.c
> +++ b/fs/ubifs/io.c
> @@ -72,7 +72,14 @@ void ubifs_ro_mode(struct ubifs_info *c, int err)
>   	if (!c->ro_error) {
>   		c->ro_error = 1;
>   		c->no_chk_data_crc = 0;
> -		c->vfs_sb->s_flags |= SB_RDONLY;
> +		/*
> +		 * Before SB_BORN the mounter holds s_umount, later see
> +		 * sb_set_emergency_ro().
> +		 */
> +		if (!(c->vfs_sb->s_flags & SB_BORN))
> +			c->vfs_sb->s_flags |= SB_RDONLY;
> +		else
> +			sb_set_emergency_ro(c->vfs_sb);
>   		ubifs_warn(c, "switched to read-only mode, error %d", err);
>   		dump_stack();
>   	}
> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
> index 38972786817e..ef39da4e780b 100644
> --- a/fs/ubifs/super.c
> +++ b/fs/ubifs/super.c
> @@ -1977,10 +1977,7 @@ static int ubifs_reconfigure(struct fs_context *fc)
>   		if (err)
>   			return err;
>   	} else if (!c->ro_mount && (fc->sb_flags & SB_RDONLY)) {
> -		if (c->ro_error) {
> -			ubifs_msg(c, "cannot re-mount R/O due to prior errors");
> -			return -EROFS;
> -		}
> +		/* After an error ubifs_remount_ro() can't write but still works. */

Hi, Brauner
If we remove the c->ro_error check, ubifs_remount_ro->ubifs_wbuf_sync 
will return EROFS and trigger ubifs_ro_mode() again, I think we can 
retain the pre-check placement to trigger more error printing.
BTW, a remount to read-write after an error is refused too.
>   		ubifs_remount_ro(c);
>   	}
>   
> diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
> index 3b0e8a270f59..572f6f3e52ad 100644
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
The sb_rdonly won't affect the sync_fs_one_sb() after an error, and 
sb_emergency_ro check in not added into sync_fs_one_sb, should we add 
the c->ro_error check in ubifs_sync_fs() to prevent the failure 
ubifs_wbuf_sync executing?

