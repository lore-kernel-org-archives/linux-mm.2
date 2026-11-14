Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 018966078A15
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hPdnrLSv
Received: by kanga.kvack.org (Postfix)
	id 1505B6B05EC; Sat, 14 Nov 2026 08:09:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127A46B05EE; Sat, 14 Nov 2026 08:09:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 017206B05EF; Sat, 14 Nov 2026 08:09:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE7BA6B05EC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:09:37 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CB2D1203BE
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:09:37 +0000 (UTC)
X-FDA: 85433756394.25.1849E7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 853A7120005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:09:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hPdnrLSv;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQQiNDOpqfhw0WpEQK13PFU/iv1KFQKHHI1yG9J6CXI=;
	b=wWKgVdRSoTOaOW3dIyEAvaXE8NVYEvzKuECWnZm2Q6suKiX0FRFIHq33IA1Dvp1xF8/Dzh
	odAb/PD/4CiWth902Miy1UAxyDPtJnnqIdeUPE4YDQco8qUv9MThSZmYZ07fCcqrPtRp3U
	Fup7plT/u3biLA8xJOg8fpKzSQ48PbE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661775;
	b=IsHuhXJIEwFLEPiGTjq3XL4ICOfoetx7GwsDaBXmhI/C42PAG0tuKWQ9pP4FLHe3/9Ui0p
	hdaMCML86eoUk7vQvwm1aN0Bg70UpMzBbPr7aOxAL/dxqIeMHwZLfC35HfXFlj417GVXGB
	mttj75NGT5YLzhJjPKCf4ZbLrgY0L10=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hPdnrLSv;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D5183465CE;
	Sat, 14 Nov 2026 13:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6A41F000C4;
	Sat, 14 Nov 2026 13:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661774;
	bh=VQQiNDOpqfhw0WpEQK13PFU/iv1KFQKHHI1yG9J6CXI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hPdnrLSvIijKxqVhgZncYFJ1riM4IpNWYY8zX0cDtr3bj2nUfd/HZPMoRPQxIsnfF
	 DaMPjcjIj1YLJkAadaq+ac00V6lcALenldxa+ypuLeNF59j7yQq8JBxIVcGftAIK9J
	 oJLvgeew639qhyHDyTQ8PUuTOHup6ZjpZwoQIqUDLRHfDG4LKQSixZvz3hgHPHSGR5
	 dpwpfUmcZw7lZxrLuSwTR8JtVbvS7Bs/oHTFYy93RAxjeDeApGYYrfov3VLkt/xJWH
	 wPPbq8rtHc0wKic1Ypk+fQn/9tJOpCxIbX37BMGRzUaq2yGGKQGoSfgDtV3IYLZlfp
	 lF2hCNHNtssPw==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:15 +0100
Subject: [PATCH RFC v2 34/42] loop: refuse files on pseudo filesystems as
 backing files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-34-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3745; i=brauner@kernel.org;
 h=from:subject:message-id; bh=uVejF7TG5lNB+KlVeH9oWZ72FFSLLOo68t1IwqUCfW8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iOndk8naYnP82AqB3h1Fkd9lpt7fmfPG6ENPQqbjn
 V1vqjZu6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIr2hGhkXahobeJrW7761Z
 /zvh90kpx6wb1uwvkt8V9fP/2Cg1PZGRYbmEVRl7+zPxbOvv/1bqvHQ4V9SW/+c46+dNT+7nXDu
 nzA0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 853A7120005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1iossqhzj5kkdds5bn9qkhab93gk5wwd
X-Rspam-User: 
X-HE-Tag: 1794661775-387584
X-HE-Meta: U2FsdGVkX19EQUBmTKlPlrqXHnTwPaZRRBwO47FIsXFf1RS150ZNy7Un5KSucS3Owx8vdJurFNyeu+hp16NbiRPFs3wMOQUfGu6ANqW+BsPbh7UzyLivb36PR5ER0gwbL0lGTRWrBEhvXPziYlJckCJf5LQq6gpsqvM+pittHxmqf5aXrCPH+96PPj2Qol7f9zp9ofvWs5DdtwKKgks+xKoFQp+gRL+RHyYmswsOak/kN9Y72MJSFG4EGCMswZ/PJfJRoPbaG/ocBrqEF3u2U0brKrOnxRT3uxktFQ/J1yHI7z7vx0xkWiKP3RuIIEGq9MUH1w+6x3oTt9NXmsw6toqhgxST0sYqZjN7O27hHKD3oyLw7V5YfWDVWzfQBAUPEZaskQ8nGTl1B1jWpZKeBDD1e1tu23ikmi6eF72AV6RlFlcyxPIC0BCJsBhmN8qIf9x3BAdm0HYcAetUVSFsL/7BSfixGLo0WhLcYLyI+Tcy7a0af3wjoyp3HXFR8Da8ILyA15RUhJVjyar/7yKC6AS+VPATv7nlUiCKEZJ5rGrLQaRJMemY7HSW0ZY9+wELxf9X7uoq5YXPb1IJ6tyQWsitoVVYvc5iSf/SNhW7HDA3o3Uhod8xeW5g3g3wVHmyLGdBtFjCijD1GV/LVO7qFpIV+NLrOMBAhm9ELiRSUji5ec5I/D/zTUdFiQPXtidWlkoBILBktyn9HOftFypvKPjga8VmFJ9mDV7Urouog+e3QMWJ850lQhDpz2H6b3oNx824eojjaItCnae1T87F2ylA6heHGT/FUm7+OmjaPGqOw8IlAirOg5kil8jLWmqFvTGKMjrAa7gBDxpPwaY3Z2JjE64SJ/0HClZkOANHbtGrqI3SECZuKtfabQIEcLTTaT2WPVwtPwiQ12WDwPVZtBvGKuGAe37Ega8H0M1CwJAlM+uOeFolw+i9RvIzm3Uw4c5D1CiZ+HaWEhkMyRL
 qcylDWt2
 Rr7emTSjY9JGjoKv0xiFG/OR+upa/HgARuwA8icDazSdPeV4UAURhjMjuKlWxjakRD2ZblxsWRpB8O2q0RlSOlD+0+MQNSMYYZ4pJZSW6VVFidi0WEuqOImXt2EIZL36r/ERA8HAAifmipqUcJe7VGAW38Oek6yjYGIiv/IausC9T5OfkGHrW5MjvvNK0h7+ppzSoqUUgIq8WmieeCXGDn0k8n8Dcw19F0PBpjt27kdYZDV20nOm3Ka6xEw==
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


