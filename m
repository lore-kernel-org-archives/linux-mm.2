Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24FE760A262D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HIkxfGMd
Received: by kanga.kvack.org (Postfix)
	id 415316B05F1; Mon, 16 Nov 2026 06:08:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5606B05F2; Mon, 16 Nov 2026 06:08:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28DB86B05F3; Mon, 16 Nov 2026 06:08:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0438C6B05F1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:08:15 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94D701408CF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:08:15 +0000 (UTC)
X-FDA: 85440708150.10.9695B6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id C209BA0011
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:08:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HIkxfGMd;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJH2iXtlvXAQ8vmVXS7YlK1nqDuNE+Y7w/0TSEUR3RY=;
	b=ffPvByeWaYBZv7jTt84/jYWWz0xO6eqHpsdvZjPRFVWFBhkw8U2wBvwi4/zd2xD4w1EAjc
	qPBDm1dj1fa421OsxGX/V5AkyeFUn/JYXb7Y+/G7I77fY7TiAcu8GxWQM2NCrxArjERG0P
	CB3ZS68JtBUmmT8U++j8oQH1hykKUBc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HIkxfGMd;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827293;
	b=mvVrZutZII9suvXe9DzBcxCCyZkCtEJOwEpQvKkTV7vLxVESqjjZnNeQySPyMJs80UmQYx
	mue72RquSUgEwzZ7h+ow4OMT1bzvJfl+qt7WNEJxucdB1j8lJ8KOmrgzeYHbDJCgpnSOmX
	66mUVE80UiMbaB9EH8jerUY9SEFf52g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E9A35462DD;
	Mon, 16 Nov 2026 11:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5931F000C6;
	Mon, 16 Nov 2026 11:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827292;
	bh=jJH2iXtlvXAQ8vmVXS7YlK1nqDuNE+Y7w/0TSEUR3RY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HIkxfGMdUZtGdK4Kyr7o/gTlv8ZzXp4gu6qrVAb4Mi1nnN7RMCKTFnvNj6DybtLgc
	 AHpwMbgdBEBdQKvIdWkLLqy8q7+45+OXfY92P5OEXj/H4ADDnabjO5G+yBO5TuVatA
	 MFF2RA1Cy0v2VSwxx5XJ51Ix7KelG/hvQSBuRW7KHcNRzbpZWV604qauakNJhq+Vcs
	 HgtoSO3gaP3AF1V4QcL5ioNNJPbmcnLGz2POKI6AWbF0hLhNVccJR1dkh+5vgg5sRK
	 7YLeitsKwxZW+JsLiaGeRecqNKH/zqzZKp++6AhvbMTfFdhhc9eRFrchMy2yAzmJst
	 8xRA1FBIMEQ0A==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:50 +0100
Subject: [PATCH RFC v3 17/44] securityfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-17-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1852; i=brauner@kernel.org;
 h=from:subject:message-id; bh=eMcnNCEpWBwKj5om0lrEeWJ5nBa2aNmgGW6gKfibtdI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ely05XJ7OEvs8TnzdthOuj5jRmeNvcusK/wb9d009
 sqseiv+uaOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiZtwM/8tXxgrFR/CedHKe
 0mA1KbT0X+dFm3JBzXc/uE6/jTfZp8XI8K/AdXL+qxbtObkKd1SmMq4za1/jJnJCs+L8dFueFAl
 3PgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 9sdbqkoaa3acj9ysbtn4osozqq17hac5
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C209BA0011
X-HE-Tag: 1794827293-337467
X-HE-Meta: U2FsdGVkX1/X0g8Jp/TZyUfQavMzGx+qLAR5JlDbI/Nx7/OAjUi5JcNQQEdGfPz4zrIFZE8cE+eBmGbpqpT31Q9WViUKPPheX4SCJ0UAn/MabSUXG2PqImujRdDkMERNv5waUyj/WyFsNCG09x/rCFIXbKPiNqA5vR24otg73S2rgKHy7da2wU5Se64TY7hirreDMO9cdSBXLSlhbuBmznH0WWhYqjvr5NlRZdlEny8GhfQsDkf8AGYMVgmojv5ff4j4jek9fMM9mNvmSm+17mh+9dd3dUC+lBtTgjq76LR3DG5Vm0aOv6LyTW0iJpQdABEXJg9dtx3GgzpayMnN/OMJ788Zf0prKvs1xugZVCHAr6UYLXG/SAjzClOmrpwquLE9O3N2T0aJOQ+LLEGbRiyOcsyyDnMP3YkB6vJ8c8m8nQY5LY5cs1ZaL37AzUFSMp8/ofy2vb/T7SiIryFaoykfQN2HYo5j6e6GWOGpSu/0nLacndbifCY7Ble40yjCv+JR+hDAzRfKpptROEnD/6TixYFOd8rfojUA6iCs6ysYr17xLV61/kFn83wTLePnu5N7Dr87ZJ2capruWiGfCULJQfvcG4s/ppCnbE81pBezIPiZajWcGQwkxV0SHMt2fnHNaL1v2MoijEqmy5taDxAhZBF0qmDVDpX+3swSIV0uBL6fy2u+RrdWeQp5X/pQaQaO+B/8gvjmd5LDEwlOGzZ2IwfZyuay+ON19uQS27nJJmQzGeDcFOIGlnRK6h6cy/RYYVmvUTwq6y8pxlC3TA6pjrJsFuIkY8CRGk/A0Tnv7/Upkxsw/L2ac+iPyvzo3Uosfy0+KsT6z5BlMCh+IuEW5UIU86xgHUaJwDYnB3wH9m2CKjSCas7QS+cabQtUrNPHh/cqxOrXXBDmA91UF3/JUts1Y6Row6qzMsARTa7axIEhmRWnoUPGB1OETy70ZOzdEmIz6o8BDPFk4x9
 6UxTJZtx
 koz4RUxwyTQGBxPL/xNZ6fWK9KZgxtRtYG7qyOEAAZNrbRJIWoUVMjIVOvSSX1N2LHnHRMt6FMAsxFB0/1b50fHklBgY+cbI/dIrV2HM/YLxs7LsBpslJjr+uteDzCxCJH9WNvI1MGEFP8QKOhnMAvVC2llHyTqxlzspFMRzOny7DzEfhyxzyVLOEbWBQnl8got/dk0GVuEdlN8oGkGR5z+6TiaNpzKWCWdAMBkemec++Wj4atRZvwRxYXw8I38A4RQH3Xt25MqadYNFrSHSnmcEPjmtMUdQKEhAEX0q1OldyoCyqDjB82deSGpGPDJ5QnvR7SSQZ0RZ9YoC0oJIqIt5ZbmH0G3L+qUtH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize securityfs as a pseudo filesystem. This raises SB_I_PSEUDO
and SB_I_NOEXEC. securityfs never holds executables.

But securityfs needs device nodes. AppArmor puts a .null device node
into securityfs. On exec it replaces file descriptors the new profile
isn't allowed to use with that node and opens it via dentry_open() which
doesn't care about SB_I_NODEV. Such a file descriptor can still be
reopened through /proc/<pid>/fd/<nr> though and that's what opening
/dev/stderr does. The node itself can also be opened by path as
/sys/kernel/security/apparmor/.null. Both go through may_open_dev()
which refuses device nodes with SB_I_NODEV raised. So clear SB_I_NODEV
again in securityfs_fill_super().

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/security/inode.c b/security/inode.c
index 0804023676741..edaebf0f1972d 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -14,6 +14,7 @@
 #include <linux/kobject.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/mount.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
@@ -49,6 +50,8 @@ static int securityfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		return error;
 
 	sb->s_op = &securityfs_super_operations;
+	/* Userspace may open AppArmor's .null device node by path. */
+	sb->s_iflags &= ~SB_I_NODEV;
 
 	return 0;
 }
@@ -64,6 +67,7 @@ static const struct fs_context_operations securityfs_context_ops = {
 
 static int securityfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &securityfs_context_ops;
 	return 0;
 }

-- 
2.53.0


