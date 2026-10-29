Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02B0260A2613
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lZ/NtxuW
Received: by kanga.kvack.org (Postfix)
	id 5126A6B05B5; Thu, 29 Oct 2026 12:07:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9D36B05B9; Thu, 29 Oct 2026 12:07:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B22A6B05C5; Thu, 29 Oct 2026 12:07:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 146356B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:07:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B45F402CF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:07:58 +0000 (UTC)
X-FDA: 85376145036.29.990221D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A7AE7180003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:07:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lZ/NtxuW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zxzMnAfr+mLITGlXVw2HHwWaLKEq9rk+KQbTmA0gnZc=;
	b=lEeYltnoLe85RDLAclOJ7TXDx6+dS9KBu0bTLG9zFPVxuK7UVgnfrg49ZwUKQnnuUD6sSa
	vRdoEpW3p3vaLpT+Y6I/r0i9MnDvluI2zE1BZIrfOyhoJgk1eZxqMMEVE09G6v/lnBg9fH
	LqVgZUZYB1o/CWjwy4g1dqEhbVKCMKg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lZ/NtxuW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290076;
	b=nJ85JmGIP2pVHyDIQQ/SP2lcetfIEODeUfMgZ2SFKU/0KBABIxE3GJK9XWMZSaqvKpHTf0
	BPCP3uA2YLWhuqZg6gcOjeyh7O8me0tKKBRFhQl3oWxvLIJzjkowwfo8G1RLuF/9UXpjaY
	dgRwqm8my77FWnD3sKiUoJZiSfFnI2U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03AE043BDD;
	Thu, 29 Oct 2026 16:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B3F1F01829;
	Thu, 29 Oct 2026 16:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290075;
	bh=zxzMnAfr+mLITGlXVw2HHwWaLKEq9rk+KQbTmA0gnZc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lZ/NtxuW+whuET0o12ey+U43ax2RjET2OlE1sxt2rJYT5lAhZhE7nCGkk3w6L4uwG
	 Gpv/NOomzhz109Zgzhq4ZopFhZ2MqmhhfkdciraP6cyN0KAKmTutcGeVw8Xkpm47h+
	 FdROUWFWq9PkGga8qYGhHhY5JrKfsEITLjdQLo1hWaee+eT0E47r3yYiQ+/tVof5F7
	 y9Fg4mwMp73+2lplQrwS8LKDTmw+4HTlimsHI+cMqnEXzXwpqtu0Hh1YDQkP1I24Jx
	 KHO1QAvKX55syZQXI09EsjRMmKBALzT1TAqTfLVEWIXBaCchpAjEV6fwXEikbormVj
	 gommYd3qzRDIw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:06:59 +0100
Subject: [PATCH v2 08/34] exfat: keep the current mount options on remount
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-8-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3964; i=brauner@kernel.org;
 h=from:subject:message-id; bh=mZbazIJ3QS8ZQ3YBus7040jsx8ku0rcjHK0u0BKdtWQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztfvmdgeu79zf5Tfy+ctSyx97ngf2HGVPWRfrAuD/
 OtDnxz/dJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkWg3D/4gbJytOb0pfIrqu
 /PG8B9lxZzaeb1ZeLBr68J/43z6faRYM/1Qf1nipbj/0ZfLEa0cn9U5Ybb4iodhmjjoXt5SzQpP
 xeyYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: A7AE7180003
X-Rspam-User: 
X-Stat-Signature: 6f7ub4b8wdcdtuoffn7nmxr8occg1nq4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793290076-399834
X-HE-Meta: U2FsdGVkX1+UjoWzWk0GFfu5e/W8e9zWEeH6t8c5Rz81tyn6diwlMx6Cz0jv5HYXwXvRzMufEBGqRl1CjXwuwIe6rJTiYR44ITNoODcQZ6zUnBhPwNITpFvrBmFaFELAJFwdfSVZeNpQfFJY27Qna4o3WpnQYHzbGS9S6LWbqyQCupXz0YfChQagVHmGOfcA5if/tnL2RJCfeCoMXG3mABKOLylKp6WSCoKvL8n3RmF1Ojf66h30ig+RMjIeNugpKnAI8ZbaX5ameoxEhl7JadPievECDgIkzqGzoWvzJM/2h8prpZnfj5tRngaOxw5ijWAAW0vflbalr+yeOM5SUsXGiatNxnFzKrwXzZyFWUx/+5fHMHL9jiAcySRyzfb8Mo1NAp19ZhW2EKpfZm22nuSdVXUTwIeOH5kVJAmbbB+9ZGEA2SSo34oPfsQnvZIEYJ9I2yATDYV6qmtZnW3a/stOwKu+IyBPoPzBkRgHtOpag4Sdt3oZcIR83JXk6nZx8ZGTn88eNhWGJAta+xtg0hCRZIWt2EMuttzgHMNsHOWsU8cpHLLI7RE+riSPdbs/tSoIBt+L3vRHfRKUKWuhwpoW3qEDDTstlqDNXZll6EgBqDHenxP3bWxL6A64YdJV+4jgej9OMvuzvSDUHkKt2Ybm4SBswUBZdxia8zFApD/ZarG0bqr1OxthSLqfo/I+A4einLKdYztNaQs7+r5aoPuG7aKgn/ApjbJ1howqY3WeAxsY8kKoJDlxjE5RhzUMnCz3pPbsUDi1xJ/tDZwFzYMZg3FY/JeE5lx4dq8yNwW1CSmmnqXp1GqK4cr+2Aw0T/mSExQMkuAhLhbNhSRPXIaEJcI3brp+JVqyC9hJdr7z8e9SMXlVU5mIMPVZ8T6TXw1ujy2ST9fbXGU7Z+hmNHkc9dY9P1xQkRzffDXp3S4wQgg7PLL3oFr0di6jwgHETF7SfK9YGbw/A5tbWlA
 TUyR93Ma
 KgLSjX55ycBeqOnTKpwtNShDvFxj0KudmvDF2BunCGCWrIhPxHtnZbyMsJa0V24otk00UIbjWHoMy1w/LM4bVrKFWVlH94OBH9zl3EWllTmML2gZqRvsN3iyGCR7s6yPYsLdqcgUUX+QEXm9dnv+AJrF+jRFx369ZD9GDKIlJizNTMjdAOzmbqa97v1p+1Qn03hTTRTEIKyhYaPLPybQZfEm7L2JEqzClEshwkkcuUwRgnlAYnRiIzIKkpK2HTPBrO9nUenQn1nmLWjfOIfomOaslr09ZKFFtwltg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

exfat_init_fs_context() only inherits uid, gid, fmask and dmask for a
reconfigure. But exfat_reconfigure() refuses to change iocharset,
keep_last_dots, sys_tz, time_offset and allow_utime. So every remount
that doesn't repeat a non-default value for one of them fails with
EINVAL, including emergency remount (sysrq u) which passes no options at
all. And an option-less remount silently resets errors=, zero_size_dir
and discard.

So start a reconfigure from the current options like gfs2 does. The
iocharset string stays NULL in the new context because
->init_fs_context() runs without s_umount for mount(2) and a concurrent
remount could free it. It's only compared if the remount names one. A
shutdown turns discard off for good so exfat_reconfigure() keeps it off.

The next patch stops exfat from setting SB_RDONLY after errors. An
errored exfat then stays read-write and emergency remount would run into
this as well.

Fixes: e6fd5d3a4317 ("exfat: support modifying mount options via remount")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exfat/super.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 4943cef97741..44d2000007df 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -797,14 +797,12 @@ static int exfat_reconfigure(struct fs_context *fc)
 		mutex_unlock(&sbi->s_lock);
 	}
 
-	if (new_opts->allow_utime == (unsigned short)-1)
-		new_opts->allow_utime = ~new_opts->fs_dmask & 0022;
-
 	/*
 	 * Since the old settings of these mount options are cached in
 	 * inodes or dentries, they cannot be modified dynamically.
 	 */
-	if (strcmp(new_opts->iocharset, cur_opts->iocharset) ||
+	if ((new_opts->iocharset &&
+	     strcmp(new_opts->iocharset, cur_opts->iocharset)) ||
 	    new_opts->keep_last_dots != cur_opts->keep_last_dots ||
 	    new_opts->sys_tz != cur_opts->sys_tz ||
 	    new_opts->time_offset != cur_opts->time_offset ||
@@ -815,6 +813,10 @@ static int exfat_reconfigure(struct fs_context *fc)
 	    new_opts->allow_utime != cur_opts->allow_utime)
 		return -EINVAL;
 
+	/* A shutdown turned discard off for good. */
+	if (exfat_forced_shutdown(sb))
+		new_opts->discard = 0;
+
 	if (new_opts->discard != cur_opts->discard &&
 	    new_opts->discard &&
 	    !bdev_max_discard_sectors(sb->s_bdev)) {
@@ -823,6 +825,8 @@ static int exfat_reconfigure(struct fs_context *fc)
 	}
 
 	swap(*cur_opts, *new_opts);
+	/* The iocharset can't change, keep the current string. */
+	swap(cur_opts->iocharset, new_opts->iocharset);
 
 	return 0;
 }
@@ -849,23 +853,24 @@ static int exfat_init_fs_context(struct fs_context *fc)
 
 	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE && fc->root) {
 		struct super_block *sb = fc->root->d_sb;
-		struct exfat_mount_options *cur_opts = &EXFAT_SB(sb)->options;
 
-		sbi->options.fs_uid = cur_opts->fs_uid;
-		sbi->options.fs_gid = cur_opts->fs_gid;
-		sbi->options.fs_fmask = cur_opts->fs_fmask;
-		sbi->options.fs_dmask = cur_opts->fs_dmask;
+		/*
+		 * Start from the current options so a remount only changes
+		 * what it specifies. The iocharset string stays with the
+		 * superblock, see exfat_reconfigure().
+		 */
+		sbi->options = EXFAT_SB(sb)->options;
+		sbi->options.iocharset = NULL;
 	} else {
 		sbi->options.fs_uid = current_uid();
 		sbi->options.fs_gid = current_gid();
 		sbi->options.fs_fmask = current->fs->umask;
 		sbi->options.fs_dmask = current->fs->umask;
+		sbi->options.allow_utime = -1;
+		sbi->options.errors = EXFAT_ERRORS_RO;
+		exfat_set_iocharset(&sbi->options, exfat_default_iocharset);
 	}
 
-	sbi->options.allow_utime = -1;
-	sbi->options.errors = EXFAT_ERRORS_RO;
-	exfat_set_iocharset(&sbi->options, exfat_default_iocharset);
-
 	fc->s_fs_info = sbi;
 	fc->ops = &exfat_context_ops;
 	return 0;

-- 
2.53.0


