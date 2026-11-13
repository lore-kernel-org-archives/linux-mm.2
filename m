Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B188B606A336
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mwYSclny
Received: by kanga.kvack.org (Postfix)
	id DC57B6B0705; Fri, 13 Nov 2026 07:02:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D75636B0708; Fri, 13 Nov 2026 07:02:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8BB06B070A; Fri, 13 Nov 2026 07:02:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 956AE6B0705
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:02:33 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E77721A02B5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:02:32 +0000 (UTC)
X-FDA: 85429958544.02.0B92422
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 16454A000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:02:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mwYSclny;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qt0v88hxlQUHI5QSZLphXypscQRdWRHgm1ofeIg78vE=;
	b=bAW5owdK34eVfSWi6fYDFr7e9z9Xi7TQVLtaIcnEWDGrQ3OoL9wIRjNynmE7kBbyjyfX2q
	jUWN17RovVqhjr2sznvuhWjWhaoLNTNhb62C/qFAqOKcLhAgnJ6vvM/1TKXUC7yypLcc6O
	/ZtQ2WuASDvxmws5iItLP7HDRbjenlE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mwYSclny;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571351;
	b=m8XgYRegMh5en5+dtixRv/3Jsgb4prNpMfGOsLSHBfVwNwlQixaQy4OA/INHt4HEu36zDL
	NVcCvlsyVO3cYqCTbGye4kbuccN2jcUU9Rdcv5O3waANxgzY4FtBtySAlRo6jJqBzl8rY1
	Lmu9XN3bk2s5vr4J/ZyL1Y0++k7XgY4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60B88411A4;
	Fri, 13 Nov 2026 12:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5F71F000C5;
	Fri, 13 Nov 2026 12:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571350;
	bh=Qt0v88hxlQUHI5QSZLphXypscQRdWRHgm1ofeIg78vE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mwYSclnymZN538OO44zhjeiEF6ZBwOXg+mNWuDn2mVMpnozTukYByPU2VgZwWVlDc
	 8xvcI8z68lxnamK03WoMc/sB/4yH0m1mIAy22y/0RN0mL5Pip9ZsoY8rM536vNcpRO
	 Fp9Yfhil3dDe21+/vxCwhBUlwdHiJ8sYmcN3wgI//hBpOa9+a8+MZggxdslsmwdHKk
	 /PtldJ1cR3JjJTGX1l58yZ4uFbBE56y458DWqBNcap2sbf7u7VQmpCwLN2C7t+Xkv5
	 EoeS8LhRnwEcexIRsxUlQqnxWH0U01IxyKtPS18Og0Ph9Um1ZWSD3IiKJYuaOlhIMx
	 m5h4cQZ/ZZhIw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:28 +0100
Subject: [PATCH v3 32/33] ext4: use the generic emergency read-only state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-32-0be92bb73709@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Jan Kara <jack@suse.cz>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1968; i=brauner@kernel.org;
 h=from:subject:message-id; bh=zrZfOrGsMUXliH43rTDbUbAuKN/ihY34a/GnGYlk2N0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+70/IHPi5j8ze6a9MUj6Ed4VbFn6fMHhxGfa69pff
 LpexvHrSEcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEBJcwMkz8vWXzrYkLLY+d
 Whp69v8jweSr7KumH5kkxXtikSHHrzwLhv8Bj4w+WD5692yWYNEenn+bWBdNqHVfUBEgWtKXeyj
 xXBcvAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 16454A000B
X-Stat-Signature: hxwui6ueikeeohx7prwgc6z3fkyo8ezb
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794571350-560335
X-HE-Meta: U2FsdGVkX185REIikc49I6Cg7uIDkjAhPYHpB/qNOMraW8SMYv9BPlO+oVEdeunj0q2HToDj4VsOvKlB4WIvPkBnoV7Kws4kJJsrIeRBz14p9RX6nmCR6W4n/PUqk8Hn6DNwkQ2M/Y9DtwF7u5F7bzQgDAO4HmnOGzvrNBZiqpeQULTw6chHt9ZY3WO7b7UiYINtT2/r2BM4Y2JOAbtHIkAF0lWKx7fp4695fgrkzJIGNf776MsYGV/l9rwGUH/OzySYVar2PX1BbAWqyCabrcNwXVCRkGh73lm2zVt4XYT9OfiynP2BzakhWc4rUAdVbZDh5afYdvjys+znHeMpBabtWyR2aC7BFiqdHqUspWZlTFCJQnPRHKhSLofnY5YOi0gzCAcdeabmUeQ92oMEjH0wgpNWI9Z05i+wvfVRNpll5XTlCihy6oDZt36zatOjNMMJoGxNtuf3f/dJxN801tLMZCMGF5A4yrCvTHlTnr7a+jcmRJVsGyDWnTvYJyZ7ca041MmTx2QL6BnSa1b1IQMk5QX6HZsx49uEtP2GMD1jbIVY8RmIcdlmSykUbaGP2eql6IyaPLJo/Cd0z8Z0TnBKSMYL2OyNCvWqclaDAhnp1ia7/Q1b6J5eVgGN6rgUJw6W6J3qHwLysePuyiR1qEU3i909/dK3j4cZo28RM9KotJSmGloSro12OEFp6WbTXUBrcDbkiwIx+DQFqG18HDoEwn+kRYrbkg5b+EvQMNU4QSX9tvp4YAek5c5vrxKeYy7/gycl/C8vvpKiE3lZs8TXLrs3Eyq2nHv+MnunzGw1hY2ecVVCYzIURP1LOzv3hlewEWZTgIKqlA+OpHhHI9eTig4K35MRW2pPTKvfONRNiJsZ9QEAnPQcusQ24M0h42EhULHYBWoGT94Vqtk9YEl4Pu3JpvgpiyJFkNXfroZ4hPbRNjJ0QqeKw57zTdbXwufssBt68mQMHflsPIu
 4hGhdODO
 PfeM3015z/gTyoJZW1ORPEzgXSmQdNv7zQ4psI10+rEPt3AQApr4iRFnvRajR80BU12o47SZqfK2NJg/1DqH/Hz9Z/d9DH0cI8Uha7DvZjgwJJtKm+BapLwnwpSzNV7r4dLhDr6eRNnzKvL0h9OgPWEBdfSo4A5VDe3/EoQNKGmMmJQfZdnFyAM34t0WEzfYSVXbPLeU8Zlj8oySg3k74N7wIXoWCKCssbYoWLdZF8w4kVna4FOLWgNt9VfrjSD6d+v9n6EFGNgT8AGRheS2OIYUMl+T+PRbVF/Nx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Set SB_STATE_EMERGENCY_RO next to EXT4_FLAGS_EMERGENCY_RO when an error
makes the filesystem read-only. The VFS then refuses modifications
before they reach ext4 and reports the superblock as read-only like it
did when ext4 still set SB_RDONLY. The shutdown state stays ext4's own
and so do all of ext4's checks because they cover both states. ext4
keeps showing "emergency_ro" in its mount options.

EXT4_IOC_SHUTDOWN with EXT4_GOING_FLAGS_DEFAULT fails after an error on
mainline today because ext4_sync_fs() fails the freeze. freeze_super()
refuses it in the emergency state now. ext4 refuses writes in that state
anyway and the journal is aborted, so shut down without the freeze like
EXT4_GOING_FLAGS_NOLOGFLUSH does.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/ioctl.c | 4 ++++
 fs/ext4/super.c | 1 +
 2 files changed, 5 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e8e579498c990..ce0e0ebdded61 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -821,6 +821,10 @@ int ext4_force_shutdown(struct super_block *sb, u32 flags)
 	ext4_msg(sb, KERN_ALERT, "shut down requested (%d)", flags);
 	trace_ext4_shutdown(sb, flags);
 
+	/* After an error there is nothing to flush and freezing fails. */
+	if (flags == EXT4_GOING_FLAGS_DEFAULT && ext4_emergency_ro(sb))
+		flags = EXT4_GOING_FLAGS_NOLOGFLUSH;
+
 	switch (flags) {
 	case EXT4_GOING_FLAGS_DEFAULT:
 		ret = bdev_freeze(sb->s_bdev);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ae5ba6823c01c..afbdbb607b144 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -757,6 +757,7 @@ static void ext4_handle_error(struct super_block *sb, bool force_ro, int error,
 	 * and other problems.
 	 */
 	set_bit(EXT4_FLAGS_EMERGENCY_RO, &EXT4_SB(sb)->s_ext4_flags);
+	sb_set_emergency_ro(sb);
 }
 
 static void update_super_work(struct work_struct *work)

-- 
2.53.0


