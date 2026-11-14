Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DC5460A3836
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbvqUTJK
Received: by kanga.kvack.org (Postfix)
	id 4CE166B05C2; Sat, 14 Nov 2026 08:07:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47F226B05C3; Sat, 14 Nov 2026 08:07:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36DDE6B05C4; Sat, 14 Nov 2026 08:07:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15FC06B05C2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:07:04 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5160803E1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:07:03 +0000 (UTC)
X-FDA: 85433749926.02.39C8AFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id CF311C000E
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:07:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bbvqUTJK;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=unDyG99Rc2/QnFjGnYYD038yieUDExHdgCgrjykz2ZY=;
	b=TvKXWwqU2iWtUxQAfNQuIe4+YC8EjXcZIX+I8xQtAWVGRLD86pfO6PDXrDZ0B7vaN8IcLR
	4Ly+w1nuINHc2OP+dpnipLGVz0LYCJT/hsJZ07yepiQdq2QRfGeQ6+B8pKkDEnpqjB4v4d
	fP+8KW/BGdLxBR+jgEPiRHfSmMR0hXk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661622;
	b=xsgbuhXiVyt605o7S7gGXEEynEeeZeeAl9InDqdLIVv2xnZkY2c0WfgTJroGo6RQr3356V
	rSI87oYmD1rNWvlY04H9wiRNAqtHmAGYtBJtUch5b7TH/MVfdT4rFvBnwwfN90jJ4VSl4n
	1NTXfVCnj8gBLZfWbnEj/+Vj+gaMIfc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bbvqUTJK;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0959F4149B;
	Sat, 14 Nov 2026 13:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F5E1F000C4;
	Sat, 14 Nov 2026 13:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661620;
	bh=unDyG99Rc2/QnFjGnYYD038yieUDExHdgCgrjykz2ZY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bbvqUTJKtvMzosAC+DFxEgbW2Vt0FzW0cgiaoIw4p06+FQN0Sb1Tv1DIYKxkGIHgF
	 nr/z4/kJVkGC0PVIG0S+X2+IVr9KgB6EEAlRappl1aI/jvUBiq8DuKNlLNE8vxcBA5
	 0JKTxwjjXckE+NeBCr1Bi8VfSd91eEzjplmFXA/4XP/TxEXjCKcLqdTFBZyvuK/4TB
	 XM/3qFzs564jbujRGcQ6pIz5ll5eRxjrkU5c0H0jv1xeSUhUu14iRQDCczLPJNQJAW
	 bobeXvnmondRh0cNkkJpqbnGO+HCtPYOqhf/9OsJt9+WANi8Hptd1u6XdBIoycR1Dw
	 5PqAgnFXrJ7Rg==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:53 +0100
Subject: [PATCH RFC v2 12/42] rust_binderfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-12-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1351; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Se/hTFkDp0LtS3ScLeBDxadBnc0o/SVsPeEgiuoeVFc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iCn+frwhSzhtu6ttd9fzjo+dooobf9y0jSo35l66+
 IDLR4G0jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkUJzD8lbV+Vvz0VtVGta/L
 t5z8Lnjs6u2MqK7DthlNXFl91kl+LowMq9Zuux269XP8tl+abt/e3Tu14f6n3JqV77gfTzl4Z/J
 bEzYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CF311C000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zw516oxxnf5dez6jiwm1mzr5abhjjzp9
X-Rspam-User: 
X-HE-Tag: 1794661621-212502
X-HE-Meta: U2FsdGVkX1/qoN67NnhDAfGhhfQNWs+lLpvOg5fhv2XdjnGLQ4OkLof303RPFxCEDq87w0Hs54VQhUX4ckTPzDLiJMkkbCff+8tbAU7xGvl3rr5QM7JKj9CFC0RCrmzBYzZ+rdRrgymdiKfx77oPtOK6km/c6UaBIenuaMsYA2yjBYjAvDdU2bMrxk2yQXD51vytqrB8UfXI8pLxxfogyrC7LvXlK1IDvjzrKLw4PVuO8NHkZa1v2f2esHYxZ+/ALvUf5w5tcQBTZiUZcmRfVlZdn7XjfdGMEhRYxMF5OEk3vHOLI2PHsIXqk56r/i64uV4B/TI1ubKFqKhzgRsqbuABdqEQncK6UK3dFeCr5yDJGMLu+MzJIsQX59sQ85096DJ3HHAnQt2m2+6NFl4xNdTcMnW42OqwQqVFUuEDIFuLHVFSV0ft+vWalxmqS7v84bQ/2m9SYfrVDqTSopO5RpBCqlk7aUXlgYafAp/bbnG/EA707GvcjSbxRLxASPBXNBNhj52Zcu4j66z5EN1cj4AbYIcRydkxOvAnv1FkWOc0ch698ptNgvrO59YJZhpZPqpx6XDwXcKRHMkpw4ahCTsnaQidG4kbD2A3oWkzCtC+k2haOppsIgdXJtepEak9NJZ9BHXltXGkl6X2BGOKottxjvpZuSPtTHk6oYv7Vnkg3Pk+LDB3YYKf3SXjB3DbP2B/KixiRNGm4caZI3clUfcyRqi0Xn4iiQe5Z8qnC+uu0E/7pz8PkRHhAYLUfyD6z786afrAZYycrAcTJelSeAOW0MxiCuRSnMbpDxFsMAH4if8bNMJLqFVaIQdytu3CKcCkgvIvGVlB09yD+3lDTuwIwGdSi0QSBkVX3LNWKy/c2taRw6GCEVI9NlblOXnpsWQP38vbAwK2MfD/lPjP2MDJ4dOZAGv5M7QQ3AYUqs/HmIhiwklk30K1cgE9EX2w0QaOjaSWiEsZr3SoOmT
 uvV/xK26
 7SqjRmL3bI0XyKO2mHym15SX5yNrt5uJ9RbdK/8G8JV6BhuJFlDHmdtLN0yoSpoO1MuJpqG/7UwGrMjYFvzYwrnUBenpRr4Ck9h1AbRfgFr+YYxvN6r/dFGO4GhMjSffVSZf8mDXFzqZliX59X5nIq1mIgnh/w+yOBBDYUHUJUcaGogYecyMJEHShqGVg01LgZHGYLEr1XzkwPiPXGb1eUY1DggKCZW4ofbVB+CiKWAXLhMclH/e+C/e2p4XPIcv6nEtAP/cwIgrwaJq7vMCZYCcd3FQipIaJKleQKYqefjVDH4W2C8fpS+4Fb6eZg7ExEcsEFqsBpv6WLBnp4dRzTI+TLwchzUldIQr8W1KM2/VcUy2j+Y/tofhbEQRPAS6Rmo58NibBom+NqDKK55aAJbFQyP823fIrG5VEyjVzs9wEwQF9D4yIerjaeKhrp6vXkACk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize binderfs as a pseudo filesystem instead of raising SB_I_NOEXEC
by hand. This adds SB_I_PSEUDO. binderfs_fill_super() keeps clearing
SB_I_NODEV for the binder device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/android/binder/rust_binderfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/android/binder/rust_binderfs.c b/drivers/android/binder/rust_binderfs.c
index 5f020226720db..04468c5b5c116 100644
--- a/drivers/android/binder/rust_binderfs.c
+++ b/drivers/android/binder/rust_binderfs.c
@@ -3,6 +3,7 @@
 #include <linux/compiler_types.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fsnotify.h>
 #include <linux/gfp.h>
 #include <linux/idr.h>
@@ -667,7 +668,6 @@ static int binderfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	 * necessary and safe.
 	 */
 	sb->s_iflags &= ~SB_I_NODEV;
-	sb->s_iflags |= SB_I_NOEXEC;
 	sb->s_magic = RUST_BINDERFS_SUPER_MAGIC;
 	sb->s_op = &binderfs_super_ops;
 	sb->s_time_gran = 1;
@@ -759,6 +759,7 @@ static int binderfs_init_fs_context(struct fs_context *fc)
 	ctx->stats_mode = binderfs_stats_mode_unset;
 
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &binderfs_fs_context_ops;
 
 	return 0;

-- 
2.53.0


