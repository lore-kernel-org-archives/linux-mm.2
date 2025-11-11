Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D7B6CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 737D28E0017; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53F6C8E000E; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4065E8E0010; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE5328E0014
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C87D88BEC
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.21.385EC9B
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id C8A98C0006
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=KJyJxRMc;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=NBLB5G2KphXe6U2CCGiooE3kbEeTOh12xAWvryw3JPG8arCrBXHjdhnpoYnKcS9ud25rCG
	h4DGCV+53MO28FBlI5UIU48KmB/Y1m0YQK0SlJtqVnkFUiinyDXiAC7EXlvYdyk4obkviv
	8keVaWBeKBBw6qTZOK9MNgJPtCC/M4o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=KJyJxRMc;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JiG9nHcsxcwZpHb/L0Tx41DaV7imD29tLb/ai1sU578=;
	b=KBLzO78whQthk66ZjwiwhVglTjWwccqx4J76+kqKUKaSPKYKqEnNeXU4H40PO27aqSpguz
	PvT1cmjYZmNlV4+G8+QUhhe7wg5UWF8Hjrj1t7RnzIQgrxebH3rca2JXv+CNSr2ffNTXsJ
	6NB0bTZ2c5jlS5Lr8KsXpFVrnJpA7zI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JiG9nHcsxcwZpHb/L0Tx41DaV7imD29tLb/ai1sU578=; b=KJyJxRMc0dvbQcOITZBVA+WBk6
	ifKPkydBj5RdVYpkYeX6lt/kJ7ld5xb0t53muvLxLstYnB5Kj+ibW1kF1JoNVPQmbi/Msmgp6IIua
	rxkVOKwaX09nya1yIHsO/LXlke4OexR2bBkWG9LhOwtpTOY2ugBYceF0WF/wnns6qgtdqeY6EhATx
	NaphnnRAzZNypERmbf3t7xl0oXOouhXWk5Ks9Gq+2D+L1HLZ20izPqJ7SWklcqVqWcK8WfltyTXu1
	JWzC4NyfbA4dtQ5vb8jg0/lTWmXs+f02YOh/csRHhSEvARsXS9htgina50+ZEPcUaq8myz/AFR1Nu
	i5DDMhaA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHj-0000000BwyK-2Gux;
	Tue, 11 Nov 2025 06:55:23 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
	neil@brown.name,
	a.hindborg@kernel.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	kees@kernel.org,
	rostedt@goodmis.org,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	paul@paul-moore.com,
	casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com,
	selinux@vger.kernel.org,
	borntraeger@linux.ibm.com,
	bpf@vger.kernel.org
Subject: [PATCH v3 14/50] convert mqueue
Date: Tue, 11 Nov 2025 06:54:43 +0000
Message-ID: <20251111065520.2847791-15-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C8A98C0006
X-Rspamd-Server: rspam07
X-Stat-Signature: ceypzwrzzkykcgeeum15qrfanjbfzehf
X-Rspam-User: 
X-HE-Tag: 1762844130-194047
X-HE-Meta: U2FsdGVkX18yciwfGm2NsNZ91RZyDN6lhyHXHksoti9vajMFEp3pmJbMk+bmbG7crDLiRS4/hcX7x7hZBxLNynFndEn5S/Ky6iywc1fetwh7mWnz91f8VZ7w6t3NSRqY4Orm12TSWyUO46tmsnJJ9OxAPDjnmJS3MSEjLK/cCskm5ht9wa2pspB2YYktycpaXwrf+eRTbrer7KG/poWQd9S+LnpOgHwmKIuDgRhzE7x2q2x3DHy9qWs4YlLq3JhrfI3zykhHBgg1IeOrXTwnyRhUVdJBRhdowlcv1jdA6kVZdIFCnbC2yTvUXJVXSx4kl20PF/hiWVCGdL2mRqUzLIUAv5vNEZ6ldbiP2FVrSqaZGR5ZeHzatvgxfWj3M3PJQlAtcqAZga1/2bxTSi+ItYRu4n/SMihf9WRfr58mWXK+KnOtSI7Iexh3joevGhnGrGUrp4OS71bpfMd73gVoHoWoNWfr5leJBBuj6YMY0zlDeJxchTw72zY0Z1nyL19hVxKn4p9TqdWJQEXZzC1nP6+tnWzsEGRqL8jYYFpUen6JAl3nVNXoBsCZQ4G5BHqZlazJqghBlSxby/bPc+npyepB76TxEgKK5LkABlxhBdhdVPp7YvUBqwG8VhJupMiWZQ3t1wY4BV0Xgcu4h0GoqLVDNGX1BzaFITki2b7/qYwzO6sWTymYE2tBxETH5ZQ54hg7WJAZPkgDbMGEJM1pbvi6fXsDb+41cn4bSI69exaUtrL2bTvJYSQiZDRbPof0ahABwqUq/URa10xnurSG8YeJeAiYto5JgLmDgJWwev/CKFEDfbSt0acgicb993y6a8Jr6hYwv/+rcChUTgG6wU1SjH9xlTmlFaGtTtUo+svlM6F404kWTgI9CSektuH47Td4dgvefQ87GZwMU/CL3vJSBwec+YWRjhR4uN01IdS/rApDdY4R9RYp8BFipjDgWTnRehDPyWi2JeKxDt1
 SVjvCnv3
 1crRlKzWFFcyUFQW7UmJ/QlYAUCUmsTjDaiViJL2ZVFVa+wqcSn7Qs3z2NnCMzEV9CiyYJDSUaVhFKA6Em2p+U/v5RmQ4F3Z2dPPwyn938Agqw2S4EMXNypx0ROQ9oBzmWw6WC+QNQ/AUfZqxl8SOn24bvxj1Z4jqeSyh4HFnBoHeCpvXu+L/bmlD+E33G6fNGP8Kevp6u7VoXIBtFc5Rk048KB6Ahzu05ZcWM1D79hL1YW5kfEK304cajIDCI8Lhg9KQzqJnCnwxONRxxQ0dS9MdLKFt8cawkYsBjVirhIMUnmsYNYCH3aOCCP4xYPfGot4R8/rbtcIWSTWgZxEkghvklY5iwF1r7U8VlLl/deoA9pO55h46ky3yWcbNL57wQAQhV2ieIrIbmxsz/htlEJZsrW7xVLWJmawE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All modifications via normal VFS codepaths; just take care of making
persistent in in mqueue_create_attr() and discardable in mqueue_unlink()
and it doesn't need kill_litter_super() at all.

mqueue_unlink() side is best handled by having it call simple_unlink()
rather than duplicating its guts...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 ipc/mqueue.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 093551fe66a7..5737130137bf 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -599,8 +599,7 @@ static int mqueue_create_attr(struct dentry *dentry, umode_t mode, void *arg)
 	dir->i_size += DIRENT_SIZE;
 	simple_inode_init_ts(dir);
 
-	d_instantiate(dentry, inode);
-	dget(dentry);
+	d_make_persistent(dentry, inode);
 	return 0;
 out_unlock:
 	spin_unlock(&mq_lock);
@@ -617,13 +616,8 @@ static int mqueue_create(struct mnt_idmap *idmap, struct inode *dir,
 
 static int mqueue_unlink(struct inode *dir, struct dentry *dentry)
 {
-	struct inode *inode = d_inode(dentry);
-
-	simple_inode_init_ts(dir);
 	dir->i_size -= DIRENT_SIZE;
-	drop_nlink(inode);
-	dput(dentry);
-	return 0;
+	return simple_unlink(dir, dentry);
 }
 
 /*
@@ -1638,7 +1632,7 @@ static const struct fs_context_operations mqueue_fs_context_ops = {
 static struct file_system_type mqueue_fs_type = {
 	.name			= "mqueue",
 	.init_fs_context	= mqueue_init_fs_context,
-	.kill_sb		= kill_litter_super,
+	.kill_sb		= kill_anon_super,
 	.fs_flags		= FS_USERNS_MOUNT,
 };
 
-- 
2.47.3


