Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50666606A338
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WAJ2uDjA
Received: by kanga.kvack.org (Postfix)
	id 9828B6B06D9; Fri, 13 Nov 2026 07:00:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92CBB6B06DB; Fri, 13 Nov 2026 07:00:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B986B06DC; Fri, 13 Nov 2026 07:00:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF326B06D9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:00:57 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DEF584022F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:00:56 +0000 (UTC)
X-FDA: 85429954512.24.3691DE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id F16C41C000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:00:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WAJ2uDjA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571255;
	b=syUOU++poe9WCyCv0McI1OvpQPLulG6t14L8UtowmGuN/mmxWzy5U72Y6PwTCtrctKn1sL
	r04+z2vY/zQ9gybD7EtBTtj6YaZUNy4sbi/bUu2xJ6hvrRcN9YlRyPAvh0MiuFvNgqVfSk
	OLlhXKfMbQCG98LhjMHSykaIpMROYzY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ypt6ULu3JwdPcJUCYN4Pu3PAb0qap28rHPCyQWyGM7s=;
	b=Ob1ORwvX55JNauMD5deFLpMBNi7E6adoREffbbOzDXt43jGkdDOpMhW1my3Y0ij5w6V/8U
	Ly3z82mIYn/D/Vu6FqR0nEm/KBQSYqwbdMlGOsUSuuPaWvksU/VlmBEkXyj35W9G499Ht9
	O8iXBMZDl/GKqv9N2JmQZUPoSu1n8Fk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WAJ2uDjA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E76B46275;
	Fri, 13 Nov 2026 12:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C001F000C4;
	Fri, 13 Nov 2026 12:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571254;
	bh=Ypt6ULu3JwdPcJUCYN4Pu3PAb0qap28rHPCyQWyGM7s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WAJ2uDjAWudaH8KPpTusxWD5T3lyda66Qun0huxINDe2hQlZsWqFpuproeFGHqH9l
	 qgVPMsSmjd15IllLkxMEHr1fu68/jaHjUmhyQl+GSlICHMsh8INQwIwoYZ+KZEbzXH
	 MZsQSnDpkE/5CUquOzq8zpDYEE/XneMMYIhr1I6weg7CiGvwKHLTLDm1KliMI21XRp
	 XmyAwx59+M70ZeTKRl9Mt35u8qedo9LKYI3dy5hMpdmBRemUM7/zhtPDhVttb8LSQ5
	 sT9VbWwKFSYZZ5iB+w9HJJj3mZIROf/grZRgKjY4FC62T1nN82taUsbfoZvaZSpxPB
	 Vorm2daFZNsSg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:06 +0100
Subject: [PATCH v3 10/33] exfat: keep the current mount options on remount
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-10-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3966; i=brauner@kernel.org;
 h=from:subject:message-id; bh=xVd1t6ge+zArPbkQcafgR82XBzAI62aSa6+KImihqMQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+730sNAfFnlho9cqhmKf3s/ePfn7RIU7t9QLoqcfn
 PxnMsO06o5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJxL9nZOirrgy6Neuj+pu6
 QyeaP+ac5U09tzpWyOSx1QeXNTqrgxMY/opOem3tX7bb9f6lxXcZs084a6lu3JJzQv2nduniah3
 53cwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: F16C41C000A
X-Rspamd-Server: rspam12
X-Stat-Signature: fafc8asnb1snu8j3w1ewqniyjaqnr3qe
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794571254-517704
X-HE-Meta: U2FsdGVkX19PeXK3QgttZzfAbPokq3SX6eYGnrJcXJeQKAqkbSzrOSc2bxU1mzzpQ/HiN9h/uUtDGJKdgL1RR4I+u2teOr3HINM7w/NOtjZFYGyAg5iNKh8zjm3H4vQ1bd2kATJIEeftpfG3Jh5UALU6nGyZGMNwg3cXYpP+Y9JY0BSUcmZ3S4zRwoKW2/r9qZDM0UqTNx59EKl+LYzGdMg1r6bjJQBkqqUsdEhQhNd7qvYBbJ1ps0+MUmmXw3HjwvifsmD/2k5YToTBvxFpS65EfTYYzW7vTEdtUQQv/HWEUugAPrbqbY6F/gaFIJJtnxHbuFxL5rku6rQvA6m94NsFX8CRz9KRK3hzowxYuhGBE9v1/xU6A4HNoEOOeQ4BE8430MZDbVUpeyTjaobF+Di9jb38TCNKZV5laJz5REGKWyuCiE/tep/0byiVQHeFvhd+hEXr8yJe2SFnJBeDSznM26LtIn3e0H56L3c1cZcNd6HBd2LWk5qVqzeUGjPq79xEJHpBCdgnVK3UAjbKJv2s6jkKpdE2Andl2yUKpgQhonR45YVnVBQXhYCEguRbIizkp3wE34o5TrrwPCbPSLXKdF9Rex7B+sFb2WtjYhHZKpqdqlNDCIbo/Ns9p1bxrd4sIxP8xJjdQBQ++fK1VL4G+4yep/JPX8acI8Z8S/svcaPt1sKTNFoRsLIKZSq9rD9ZS9rnOErdrHa2BgvXEfKWjLbfU/LO7ljpVkSNzDbhIbF0d+piKUzSjwZjAEx/2OePiJOHwr0IJ+DfAIRbHD7QKTJrUQJ+1fH7fQRIMwXEq6YA+bx4tMTF6sYUwvpbLTee5Qw8tEv0ULaryWwvTzC5jAtM55cGoiJjvuxD5rXzDbi5fmYuHsZ5aLhU/x52t/nGSkVHL6AYtMxI3AknoTX1LHA/4b4EVk3MGaTYmueU+jVdWf4VsFyoKW+2G6hSNxgSsWUbdMPbATZBrRH
 hDU7fOpk
 Glux+NA+bQRLTiIg8f2RY5D0sLUI8kgye4K7DVvE6nvBseUai+jFzJmkXlhzRebT0XHVtkYmn8xCUsKrGqAINxjpOHNFONUzmHljaTGFOoVlAcocYr+r5R08sYmnP0WnLKmRwlcvqCGExIWwySzMW1fkb8GAClTh12lTzKHWdn/OlQh1Tt316rrqK0C0djlVzU3AD4wzTb5BEMpCK4J0MQR9BOIJOH2KdAWrGSfhhsdyF3A71ggyhuiH+eVRxG1JlvNfRokWymyP+S5us/DPxKvMpmuNaBiZo6v2aZvSEP8Bu3GMdw5c16v7i3tH048bL3OP4tBkCsfks0QG/HAOxp6apS7zGsvWIZLDzzA79gDNNqx2qKxPy49NTBZqTugP/tAZMlzpNb3LBJYNwsgUISB90XdmRGu4vUsyIMol2gl8LI+5ZylBWJfajeQ==
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
index 4943cef977418..44d2000007dfb 100644
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


