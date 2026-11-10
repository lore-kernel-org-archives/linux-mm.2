Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE361606A336
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CjYzYxSG
Received: by kanga.kvack.org (Postfix)
	id E083E6B05BB; Tue, 10 Nov 2026 04:16:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91B96B05BC; Tue, 10 Nov 2026 04:16:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59B66B05BD; Tue, 10 Nov 2026 04:16:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9CBF36B05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:16:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 275011A0147
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:34 +0000 (UTC)
X-FDA: 85418653908.10.D46C236
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7472B180006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CjYzYxSG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGG9W0yWfKzRivIQZoE53ERZFH3qHATHiSAlm/rfViI=;
	b=krQwU1txFRN2y1iKWe1TrAuJNaQaAyp64zue6PGmE87DIX1/bfcs7EH8+WrTp4fxazn487
	RcKUwlC0JTuEN3ix/Ruy/+TLR0I9MyOSUs0oJ/OXWqH3rdk27z8k/Dq10R/gal2mlTZw85
	JcUsrcbt0/v1mJE2YZC0q6mYvALwHrA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CjYzYxSG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302192;
	b=RGmtnkT0ksJFd9uLgo1D3buBO9M1VmwNoNF55vAP6G2TFn2uMoul4Bc+W3//fbAJIFjEdl
	xfc6Hy9G+4Tecu6A4M4C6olTK93KbArdSF9hI39T9MoNDmOjfPyUoXmaK+KifHSPa+XBYm
	I/g+XsXh0K4hYQnoMAa1CtQ2VtFE0tw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1686F611CD;
	Tue, 10 Nov 2026 09:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8126C1F00902;
	Tue, 10 Nov 2026 09:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302191;
	bh=eGG9W0yWfKzRivIQZoE53ERZFH3qHATHiSAlm/rfViI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CjYzYxSG4MF/PYOuhfPotw8YsrgHpqEMmvVsealc1nZYA5sYB8ePEA/BT0law6L4c
	 H4DwOy7PJ6PWOuylSpgYpzMq2zQGYiIT8+FEalpf9CzWwtAbdti5C3COkrTAoZVyOC
	 98zYnncAcJul/uKitX7mc2xPlqIIYPds4N05d66Wgi6oSv9azb1TV2yyF+MJgyG+uT
	 +q4Aq0251HvqT0ZVS0wHPkEhV8CPEhOZQuBNIukUVbH00aNshGt3HqKek36mnvJebH
	 4omkN8WkJOC0ohRp48kohw45G0TEI0wyMWnb2yC/I1jgI5cFhMlDgFavrTXU4YWzSj
	 7d78+YdkJ4mOA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:21 +0100
Subject: [PATCH RFC 05/41] kernfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-5-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1308; i=brauner@kernel.org;
 h=from:subject:message-id; bh=oxvnYqP+iDvCdTKHYHpfovNIFRCjsigYBDc/6gG4KoE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9ejDzzd/Z9nGXbsVbBqjycnSqNVW8nKT5dary583xR
 9dNDt3g2VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRjaGMDOv3/hK7rKMoLKFw
 cJvq3Wdf7eI+x+zYPCvtnPsBx+pD2VMYGd6l2F1wrJl6IHntnnLtfb/v/1wpEWL5tkZ74nuPD8z
 fDFkB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7472B180006
X-Stat-Signature: 6cunjzhejy3bnxr7nzyx7or11ak77ue6
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794302192-591521
X-HE-Meta: U2FsdGVkX1/hIspA5A67cjmmJTo5dd6CO67HFUODKmMo+ppEbuzKbrJ35y/g3vLWwcr5TuDKMX6sn483URSEbS5BULpyI8ZnxDBYOGKEobE9fpzR6IwTqyISLKgHYEb3iyJmZS1j3WQjyhA9FX/dUG2XMy4wu56qTGBjVHvv+NQP9xQrgIjZ9CXX9+f+rxqY9a1uLGbHaghvreDnTXYDEdCfunZDvrH51Hsa3+HKA6tonTLOiOHZ/Wsw1BBxQUqZ00f4+9wpjM5hlQDf3ZRb3nt5/hhPSXSHJEuMGkxBfIcq+rGfr7mTpiOy1IeQU6hM79HkWYPXS0NVFdZchpZ0GgWOBC1nju773rbGbBndGUsjsVcknF27zfjPQzcgeexDMCD8HYNU8eJHfJlNfYKI3+zj6OFioVaWwxNAzzh5Q+bXRk+AuPzitGbmiHwop+Ar2cAzn25yZhnx18ySuqYKR9J6RuP6Vtr/TBIQhY6hKDGmVn8f+yFiJ8Wtru6O6u28AYqbDipmsIA+2r3/dNUe1NlDw17Nn57qyDrPRwhKbHtW3Ys+BG4AvgNRzK56I2JGfCry8ztI3veQztQpeJCM4pMNQnDRw9k4DiBu/rIJNA8RhU3EeTrVRoMjTvBqiFi+v/vTgstile+VK/+3Bna1w8txGKFkkrWuQ3wng85r4qThOKAeEQTqUDBu2x7CXw3I9XAVTxSfs1kr3qoWdR+hyxTxWPpvgYDWzwao2Xvxe5Fb7Y0HXPcTq11o86h7KtK+oMZjSlpvCF2scTrQWGQT3uOsTnxX0V+qRXT998e8En8isnksHxZGs+2SDSY+dKTkPxG8mR+UrYA4wJQv2A2qxcoN+be3t2DoCXCJ8PUh16KbbHtRP1fWGOCu5S+GcYqqJxOWluIfpVgAr7OgaOtNaarbrXih8DkjyHUqAQ/BvdnRCKjaBm2kZMzfrH8c5RvFX1q2KSm/ZBRUH2dBV9h
 e10S/xdf
 4nILf53ecjX2+tk7jfO1rSeV1c8vK4Uye1looJKwyCYwfRsMI/AtDSgQT33em1JAKRQk2t3rhILMbe/EBQ5GnVps5tG462xbH0ItiKRV8mzsOIR0ArlD+jSbEufNTE0XpPemX3z9KbIYDEWpGbf79mvKGzL6nIpBt3+Kp0Ja/VBOr0gvlCfmePKjSXIcO+I4JZjUvatmMbN5jKgcjwXsrbkUyXUiJuVwT9+ExMaAQPUCKUi/ZMQXgpISOrl7Cclcd0f1Kc2inAfiap3J5lzFR0uPLMaw8gntgdvzyt4t6eWhguEOxOJnhk2zsa3LV4Od/KPlt1LejyBK+084=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize all kernfs based filesystems as pseudo filesystems in
kernfs_get_tree() instead of raising SB_I_NOEXEC and SB_I_NODEV by hand
in kernfs_fill_super(). This adds SB_I_PSEUDO for sysfs, cgroupfs and
resctrl.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/kernfs/mount.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index a0be784bfb06..6b60d212b003 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/pseudo_fs.h>
 #include <linux/mount.h>
 #include <linux/init.h>
 #include <linux/magic.h>
@@ -298,8 +299,6 @@ static int kernfs_fill_super(struct super_block *sb, struct kernfs_fs_context *k
 	struct dentry *root;
 
 	info->sb = sb;
-	/* Userspace would break if executables or devices appear on sysfs */
-	sb->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
 	sb->s_blocksize = PAGE_SIZE;
 	sb->s_blocksize_bits = PAGE_SHIFT;
 	sb->s_magic = kfc->magic;
@@ -388,6 +387,7 @@ int kernfs_get_tree(struct fs_context *fc)
 	info->ns = kfc->ns_tag;
 	INIT_LIST_HEAD(&info->node);
 
+	fc_init_pseudo(fc);
 	fc->s_fs_info = info;
 	sb = sget_fc(fc, kernfs_test_super, kernfs_set_super);
 	if (IS_ERR(sb))

-- 
2.53.0


