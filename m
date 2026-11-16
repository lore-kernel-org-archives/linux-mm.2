Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A197F606A7AE
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qv+gp8Sx
Received: by kanga.kvack.org (Postfix)
	id 8FAF96B060E; Mon, 16 Nov 2026 06:10:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 884E66B060F; Mon, 16 Nov 2026 06:10:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725766B0610; Mon, 16 Nov 2026 06:10:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EEDF6B060E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:10:35 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A412A40969
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:10:34 +0000 (UTC)
X-FDA: 85440713988.14.832FC12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id DC90680008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:10:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qv+gp8Sx;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1H8Xh93n2dg9eAr21Dx1zMiF5X4Ak3L7LjGKuq60qTI=;
	b=Ygp5qnXXcf/jfjp4nIqd00fM7waG9O4qTxkqRWE4/xS4ZNmXNRvmM0awtfUpjwmjX6owP0
	2hcaK9Mx92aS88c4pULT/BW5HYyZ5+IDbUmhlO/g2/piDkcGDvpjrn+1xHvt9RG4ICi6E6
	MmhzOiXJKIdWoJUqzZRS5daLjLWXKV0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qv+gp8Sx;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827433;
	b=7DRB1nyrXsabViuRwy0olpBE0+oGjF4y4qAL/Qc5mye7owJzHVFdY4JcRxH+/F34cjLtj+
	VmMupNYc/HRF6o+NnNLI3KZHyVapLIthPECfzh/4D3tX4q11WhvP3UfDopC714jqDMnLzD
	PZG14KOQg7BxGul9kpMyUUM+JxyrmSY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7447F6291F;
	Mon, 16 Nov 2026 11:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482751F000C4;
	Mon, 16 Nov 2026 11:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827432;
	bh=1H8Xh93n2dg9eAr21Dx1zMiF5X4Ak3L7LjGKuq60qTI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Qv+gp8SxFvTYEiGZq7WIE/agQK090FiR70GXAeekS1OplOolirKwCH/zLYBDNXzq0
	 82XLudzjNFrzvVWoZyEOTPSZTpmeNXt/UCBPmq+05hm/YtAPZrCgKRToGO46LgRBEX
	 ImP9hFUWMZDojefV99IdUQmIRI+I1B7gKqWJ5KJPAMj3aUpw6raPzU1ubhxuAVkSAJ
	 ratfucFWbzuqRWKtRRRoBJoHNQ4F/vgweZWDI2Sw1yxx+sabg478I4+vwvLIxnXThc
	 PsvH2zBjetTl0YhopTahD70H4fzJ1QCjbHQcFIEDOKvLzH+H893kI0I79oiEWjYL6e
	 EM050TCGdUUMw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:09 +0100
Subject: [PATCH RFC v3 36/44] loop: refuse files on pseudo filesystems as
 backing files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-36-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3933; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YAQ3VdFop25KuddjJBUap+th0WtUAOpdA+YAegR0Rwc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9etyh2q8/O/2EyrvzpQZi063lrY5+en/xo+aSZ3/ms
 jfEizF86yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIvjMjw6qdbrWvhSInlW25
 tWMX66LDx9s7/s7Nfv+I5daJH1dmHXFh+Kct9n/C2iBp+SNzhLSebHrBvzTs1qak9o6IM+UMyxL
 f72YBAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: ci4rw85sousxuenhnoytt7k59d4hig7b
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DC90680008
X-HE-Tag: 1794827432-477454
X-HE-Meta: U2FsdGVkX1+SzF36ONx4qeu69kv+wyu+MC2cP4UlZ+UOxF6tLaenQHXn4vq1v9msoxO/r+caJ9dMsmxH4jzUv4ZYLLkqD/HB/7sdl4mzNbI66EWJUA7puoYRYSedmtx/BC7wj5swK05boulPz7aV+dqneYGDImAi/v6qhIE0SqUV1y1bvMlgfNP+OZmysX9hpO0ooEzLYOHxEzBupHe+pwQKLg/Jw8UKnPQitlykVzXtKhy7nOG8leqlMia/SLPRgLn/srnbTF6JWMsh9e8E7FAu+E2w0eXsI+B0ye2d1RWgpTQk91y8Tp37ta2KrXJIWFfkLKLGfVVrMG6KhYt/CxR/WG76LQTb9txRSaxNX2XflahHN5oa/6kEqX9Kdwz838A3ePzzRUAq+X+R6Ox9bXvdbNvxD9w1kehdwwLdKKkbcH34y7rHSfT1r/Z5HaDWcO+pJ9bJXcr8JFs6uhqmBzQw+LUXoxNr2mQ9DdQPzEv2haAOSJDG+iM99NUW26k02R68CNBzghtKmm8SFLInc78eetAVSPRlW5mT8dFHbjLdONOTdZMyZojm67Vdg2KnMlahFn1W4EFRGxXlkW1dNF645O+2yW8DmDVNLIZ7vaxKh4XD/PSS5DRuD3erF/yPm2dVQX8R2BizaoX+A3Dm36Q3ioR8f5yzSrx/eK7j1ZJVcwdsYU53xx7wmPwO1XM3iMnI7xphkSlZITlGvHDY0MTTv6VszIRqXH0eZHBIHSyIh4WBvQcv26Aodx+kR91ANpenXf1zJPLwdYaR7Iu9WFjRY//ZGBVuaCuGUkh5qUP+O61pmBUrAJ1ssaIt/32PxSkoj94qwoLlt4mquPOZd1Gi1KiL2u34HSoJ2ZBwPTj574prRu5bor2yFkKOVVGZwO2B9jys2XpFO1VVHW/ZmQrTxMqKrjKICQW73/s0puU24Qvfkf2DO2WISOF1nW0kQH3t8bOVu5mSArNBkLk
 exQMDGgl
 flwiLKLE63t/TPNrmcGZRxD69uJNGCcocOrrAKQKVbxbeNt+R+/5L5wd/L+8nGhqmn/usS7izP4NHA8o2jrjJRJjRsPMLGX2KpFLwYZwq08Mz7WOVhahzbm2AYicQX4SsjWnrtAsFJuaqITWRhdh6f1WCZbVNTb1JJD0UTx3nIIt497AS9rdg2WrIIGYQDUn6QAhXv5ce0f+5U6Uv8W9cUzfclnq2gkKvL2z12c3I6BxsNZLcZQ6iRuS/b3ZqMQZofSRCKGDwzSjPao98JmNEMfWYz5QxSXGMlWXPxW6Yr7yI4dUJ2MzqFO24+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently loop accepts any regular file that implements ->read_iter() as
a backing file and any that also implements ->write_iter() as a writable
one. That includes files on procfs, sysfs and other pseudo filesystems.
For example, /proc/kcore attaches read-only as a loop device the size of
the kernel's virtual address space, 64 PiB with 5-level paging. sysfs
attributes attach read-write as 4096 byte loop devices. Writing a block
to the loop device of /sys/kernel/mm/transparent_hugepage/enabled
changes the THP setting.

That's not just nonsensical, it can be abused. Loop calls ->read_iter()
and ->write_iter() of the backing file directly from its worker which
runs with kernel credentials. But pseudo files enforce part of their
access rules at read and write time against current. Dozens of sysfs
->show() and ->store() methods call capable(). Behind a loop device all
of these checks are done against the loop worker instead of the task
that opened the file. And setting up a loop device requires no
capabilities, only access to the device nodes. So on v7.4-rc1:

- uid 0 without any capabilities can't write to /sys/kernel/reboot/mode
  as mode_store() requires CAP_SYS_BOOT. Writing "warm" through a loop
  device works.

- uid 0 without any capabilities can't read the files in
  /sys/firmware/dmi/entries/*/ as dmi_sysfs_attr_show() requires
  CAP_SYS_ADMIN. Reading them through a loop device works.

- An unprivileged container that was handed a loop device can't change
  gro_flush_timeout of its own network devices as
  gro_flush_timeout_store() requires CAP_NET_ADMIN in the initial user
  namespace. Writing it through a loop device works.

The same goes for hard_offline_page, the md and sd attributes, rfkill
and others.

Refuse files on pseudo filesystems as loop backing files by switching to
file_check_backing(). Note that it looks through overlayfs so stacking
overlayfs on top of sysfs doesn't get around this.

The helper also does the file type, open mode and method checks that
loop did itself so far. The check for a regular file or a block device
now happens before the loop device is locked and it looks at the inode
of the file instead of the host of ->f_mapping. For regular files and
block devices both have the same type.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/block/loop.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c96e35c3ef423..776bd063f900c 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -492,7 +492,6 @@ static inline int is_loop_device(struct file *file)
 
 static int loop_validate_file(struct file *file, struct block_device *bdev)
 {
-	struct inode	*inode = file->f_mapping->host;
 	struct file	*f = file;
 
 	/* Avoid recursion */
@@ -510,8 +509,6 @@ static int loop_validate_file(struct file *file, struct block_device *bdev)
 		rmb();
 		f = l->lo_backing_file;
 	}
-	if (!S_ISREG(inode->i_mode) && !S_ISBLK(inode->i_mode))
-		return -EINVAL;
 	return 0;
 }
 
@@ -528,16 +525,10 @@ static void loop_assign_backing_file(struct loop_device *lo, struct file *file)
 
 static int loop_check_backing_file(struct file *file)
 {
-	if (!(file->f_mode & FMODE_READ))
-		return -EBADF;
-
-	if (!file->f_op->read_iter)
-		return -EINVAL;
-
-	if ((file->f_mode & FMODE_WRITE) && !file->f_op->write_iter)
-		return -EINVAL;
-
-	return 0;
+	/* A backing file that isn't open for writing gives a read-only device. */
+	return file_check_backing(file,
+				  FMODE_READ | (file->f_mode & FMODE_WRITE),
+				  S_IFBLK);
 }
 
 /* loop sysfs attributes */

-- 
2.53.0


