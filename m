Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BDE7606F230
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OQ/4og82
Received: by kanga.kvack.org (Postfix)
	id 9C4CF6B05C9; Mon,  2 Nov 2026 10:17:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99C806B0610; Mon,  2 Nov 2026 10:17:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B956B0611; Mon,  2 Nov 2026 10:17:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6265E6B05C9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:17:55 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03EF3120147
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:17:54 +0000 (UTC)
X-FDA: 85390534110.25.D93AFC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 492AE2000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:17:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OQ/4og82";
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632673;
	b=iZOf5MoJb0eo6vYAcpXBCnSY7u6BuR6A9+gYJO91kMMySb0QoHdaiqM9XI/mi9u/y9NVl2
	u9WngHFEbtSpBcEgO6827kj4RQfeqDCR5FrJoYeKhXrTTT81UCvc85LLSQ4UC7fM8LV18t
	+HrM4Jcnd22BlQV50g1ziqUYFOsKI4w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OQ/4og82";
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qZN/E0hKCQd7OXCbkpVH+SDzGVUVvjPXCiNKFmCsSbY=;
	b=B8IQcHPJBJDi2K/3MjcM+mQd+9zJAdI50Xd8/ByMpa/maPDrpDWjsOD6rvFtmlt3AlX5az
	ulQ+xRsxJ5BnoK6RYTUBqbLxj+Bln+6SbuycJITuMAczK2rclJvn3A+0Ce4cFnFZyMqwZd
	MIhvHwWalm+PnJkwDTsfggeqtwZAYVc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD6CD6053D;
	Mon,  2 Nov 2026 15:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9321F1F00A16;
	Mon,  2 Nov 2026 15:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632672;
	bh=qZN/E0hKCQd7OXCbkpVH+SDzGVUVvjPXCiNKFmCsSbY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OQ/4og82Ht0aNZAQGurqlMIUKahbiaOSO5PTnwZlTZ+/ocmR8RnGh+7BqWAnUwmxI
	 a4dmFM3OxaWot8+GB3b3K0aXXnMYg0FXhwxmSedCs/lUK1ucuE9GCf57/Pd8Xkf+6J
	 ElkfN7bSwR+MP1p88q2Pe3ymWklXBBOZVT8Nbt//crP+X++/9/zskErTDjhfe2URMg
	 EXRG4OhrQzBcqZyIUIoWocgzsoWWtT1MqjtF8N4Boij64fy0LA9RXEtYTDghtiYwDk
	 8GI+MaMSHQl01ZUfoGNTF/MXZJ0ymMlkEauyjMW0ZXyiugQTjA5EHpamAXZhZjHzzA
	 jmk4uEa8lPOQw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:29 +0100
Subject: [PATCH RFC 22/23] ALSA: info: let procfs copy out reads of data
 entries
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-22-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
In-Reply-To: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
 Greg Kroah-Hartman <gregkh@suse.de>, 
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
 coreteam@netfilter.org, kexec@lists.infradead.org, 
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-debuggers@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=13379; i=brauner@kernel.org;
 h=from:subject:message-id; bh=W5FVoTEiqLzpH4N1OnkJ9iOTklCDyiLp/vkBPrzU6TM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG74e1cUT59imXn2wS9vLSss/xW7H1bLfLHb2Oq0k
 r3RaptNHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMxW8/IMNcnSWZVy6L/54Ou
 iPK+3X6QRy3wzTJhi9jMEF47LpGLPgz/U7U/nLie/X+/R7rbpmsrL7lGFa54eTjHTO1EEvP556p
 LuAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 7jaek1ihz6a7icxjjj6thwph9u143g1k
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 492AE2000D
X-Rspam-User: 
X-HE-Tag: 1793632673-521556
X-HE-Meta: U2FsdGVkX1+RW2uqTu5EnTZiIO3KwkhBg7qyJVCEAqXM6Cw/uTA8XoOrsdPDj0/dX/hzP2EpyMknvvXMeWi218/Lsf8WKJED6F+slf8fzQiEC/OmyB+0a6SAN7sdaGqXeSZT8g+TPeFmSssWhk4N+2xCJBYJFGLvP1K6qakwwOIZgUL4yqIxxfJK06pxLZ23HCp7zBrCpUDwcBrskUWvGqWc15Jcfk646MiFz2W8Yk/1YlWrrt0s3545jHizI1qIusjbnasY83e03leq4mcjcEVIjP/f4SMUnk+WsIZJkKW7RnQaYzASvJVwVsIEGm88RWCP9J0iRkQuaoB3+CK2j5R9UAq7aao6t3h6j1hM8vrYWG4ffWtFmOSysLtOeJKB8XZH6/KMF/GacsBXylvCGjadJ1sogG6zB2BTjaricBpA0EDKRbMboxjMmx4u5lzwX8Y8ZrExF2t1B49CKced/8CTCqOBFAWVVWARDSk+iRzuVfU/CBoofMlXO+Ee1BN8CnD2am0p5u/eAODT7+lZbLFOWf7I0u+5jUbas942Myod+kunhcxgkPpEFmL2RG/v1w+qlxtbMqvtUFstFxNnSeIJ+N0R4mEsoBdCo6wvvbrNRHBGxXCuh9z4A9Fsfq2xGAJAjfKesffPBOwOOiHMmin0oMdv/WZW3dObo5/JeREwFfVOA6O2gtgksFOz6/El91UO6ZXZz1UkX0Ygf/iGh/jW1/eQAZX46RcySSSeClz1ihuQJtzxf5LXvdFkFSz/FW7XXRlPFJ5SE9+tXHyH0mJMZnxwHU+v9nJNK8dtbsPMsbE43qCBu/Et6SMLNX+CI8129Y6AEs7af4Yj8rwq46uQkx1JHAyID0A+qgGshr6Ot6Gg08ANmgSd4yLKtXABoSRWP8tvxi03Wvt8IBe3KWBe+7x9uZb0nkG0o6RgXZ5TFIPHS8CvIkC9DHXVCO7IzdGKCM0/VdE8Hr4hrPu
 N04p47i0
 19F7TPM8KM9ON+2eco5IOFez8ono8JZa4NGTaGLXj/WuCDm4pZPlFvtH9MjtJJ2U2/QqXujCX4M6qaTpSURiccxRwdpDxXyJtednlMnSXAvIr23npuXLzvgz0KtTwkoaA4rElxQyOrMG5eYEwotdh+iFC1k2TiNlsvjot1XQW+BMN9LJSPpDboBkZ6kt0l/D9zFv5RbYMLLmgRTZcWIvbrC5NhAxVoc/C/IWi0FfejPNNeezu9r6z0YTrwYEGTN69SnT+zOlg/3fKgpsfMtlRRwQiyUE2MnBOKx+k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() for data entries so procfs copies what is
read to userspace after it unpinned the entry. ->read() of struct
snd_info_entry_ops fills procfs' buffer now. opl4 reads the sample
memory into it without a vmalloc() buffer of its own, gus, cs46xx,
emu10k1, scarlett2, cs4281 and mixart copy into it instead of to
userspace. The driver guide still told raw callbacks to copy to and from
userspace, so update its example as well. Data entries ask for
PROC_ENTRY_FULL_READS so that reading all of an entry at once keeps
working. A read that faults on its buffer in a later piece returns the
pieces before it now instead of failing with -EFAULT.

Unbinding a card then no longer waits for a reader that faults on its
buffer.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/sound/kernel-api/writing-an-alsa-driver.rst | 10 +++++-----
 include/sound/gus.h                                       |  2 +-
 include/sound/info.h                                      |  2 +-
 sound/core/info.c                                         |  6 +++---
 sound/drivers/opl4/opl4_proc.c                            | 12 +-----------
 sound/isa/gus/gus_dram.c                                  |  7 +++----
 sound/isa/gus/gus_mem_proc.c                              |  2 +-
 sound/pci/cs4281.c                                        | 10 ++++------
 sound/pci/cs46xx/cs46xx_lib.c                             |  5 ++---
 sound/pci/emu10k1/emuproc.c                               |  8 +++-----
 sound/pci/mixart/mixart.c                                 | 10 ++++------
 sound/usb/mixer_scarlett2.c                               |  9 ++++-----
 12 files changed, 32 insertions(+), 51 deletions(-)

diff --git a/Documentation/sound/kernel-api/writing-an-alsa-driver.rst b/Documentation/sound/kernel-api/writing-an-alsa-driver.rst
index 86b64de03140..d4b4753879b6 100644
--- a/Documentation/sound/kernel-api/writing-an-alsa-driver.rst
+++ b/Documentation/sound/kernel-api/writing-an-alsa-driver.rst
@@ -3679,9 +3679,10 @@ For raw data, ``size`` field must be set properly. This specifies
 the maximum size of the proc file access.
 
 The read/write callbacks of raw mode are more direct than the text mode.
-You need to use a low-level I/O functions such as
-:c:func:`copy_from_user()` and :c:func:`copy_to_user()` to transfer the
-data::
+They get a kernel buffer that procfs copies to or from userspace, so they
+just copy the data. The buffer holds at most a page and isn't zeroed, so
+a read callback must return exactly what it copied into it; a larger
+read comes back for the rest::
 
   static ssize_t my_file_io_read(struct snd_info_entry *entry,
                               void *file_private_data,
@@ -3690,8 +3691,7 @@ data::
                               size_t count,
                               loff_t pos)
   {
-          if (copy_to_user(buf, local_data + pos, count))
-                  return -EFAULT;
+          memcpy(buf, local_data + pos, count);
           return count;
   }
 
diff --git a/include/sound/gus.h b/include/sound/gus.h
index 3feb42627de1..1b504f516ebf 100644
--- a/include/sound/gus.h
+++ b/include/sound/gus.h
@@ -594,7 +594,7 @@ void snd_gf1_uart_resume(struct snd_gus_card *gus);
 /* gus_dram.c */
 int snd_gus_dram_write(struct snd_gus_card *gus, char __user *ptr,
 		       unsigned int addr, unsigned int size);
-int snd_gus_dram_read(struct snd_gus_card *gus, char __user *ptr,
+int snd_gus_dram_read(struct snd_gus_card *gus, char *ptr,
 		      unsigned int addr, unsigned int size, int rom);
 
 /* gus_timer.c */
diff --git a/include/sound/info.h b/include/sound/info.h
index 32fc608d056c..b4b5bdd6898d 100644
--- a/include/sound/info.h
+++ b/include/sound/info.h
@@ -39,7 +39,7 @@ struct snd_info_entry_ops {
 	int (*release)(struct snd_info_entry *entry,
 		       unsigned short mode, void *file_private_data);
 	ssize_t (*read)(struct snd_info_entry *entry, void *file_private_data,
-			struct file *file, char __user *buf,
+			struct file *file, char *buf,
 			size_t count, loff_t pos);
 	ssize_t (*write)(struct snd_info_entry *entry, void *file_private_data,
 			 struct file *file, const char *buf,
diff --git a/sound/core/info.c b/sound/core/info.c
index 09d4420202e5..9665600ca5ac 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -138,7 +138,7 @@ static loff_t snd_info_entry_llseek(struct file *file, loff_t offset, int orig)
 	return offset;
 }
 
-static ssize_t snd_info_entry_read(struct file *file, char __user *buffer,
+static ssize_t snd_info_entry_read(struct file *file, char *buffer,
 				   size_t count, loff_t * offset)
 {
 	struct snd_info_private_data *data = file->private_data;
@@ -277,9 +277,9 @@ static int snd_info_entry_release(struct inode *inode, struct file *file)
 
 static const struct proc_ops snd_info_entry_operations =
 {
-	.proc_flags	= PROC_ENTRY_SHORT_WRITES,
+	.proc_flags	= PROC_ENTRY_SHORT_WRITES | PROC_ENTRY_FULL_READS,
 	.proc_lseek	= snd_info_entry_llseek,
-	.proc_read	= snd_info_entry_read,
+	.proc_read_buf	= snd_info_entry_read,
 	.proc_write_buf	= snd_info_entry_write,
 	.proc_write_size = PAGE_SIZE,
 	.proc_poll	= snd_info_entry_poll,
diff --git a/sound/drivers/opl4/opl4_proc.c b/sound/drivers/opl4/opl4_proc.c
index bdcae02a4dc2..b8b282cb0a02 100644
--- a/sound/drivers/opl4/opl4_proc.c
+++ b/sound/drivers/opl4/opl4_proc.c
@@ -5,7 +5,6 @@
  */
 
 #include "opl4_local.h"
-#include <linux/vmalloc.h>
 #include <linux/export.h>
 #include <sound/info.h>
 
@@ -33,21 +32,12 @@ static int snd_opl4_mem_proc_release(struct snd_info_entry *entry,
 
 static ssize_t snd_opl4_mem_proc_read(struct snd_info_entry *entry,
 				      void *file_private_data,
-				      struct file *file, char __user *_buf,
+				      struct file *file, char *buf,
 				      size_t count, loff_t pos)
 {
 	struct snd_opl4 *opl4 = entry->private_data;
-	char* buf;
 
-	buf = vmalloc(count);
-	if (!buf)
-		return -ENOMEM;
 	snd_opl4_read_memory(opl4, buf, pos, count);
-	if (copy_to_user(_buf, buf, count)) {
-		vfree(buf);
-		return -EFAULT;
-	}
-	vfree(buf);
 	return count;
 }
 
diff --git a/sound/isa/gus/gus_dram.c b/sound/isa/gus/gus_dram.c
index 50fe738ee3ea..98b94db8e819 100644
--- a/sound/isa/gus/gus_dram.c
+++ b/sound/isa/gus/gus_dram.c
@@ -45,7 +45,7 @@ int snd_gus_dram_write(struct snd_gus_card *gus, char __user *buffer,
 	return snd_gus_dram_poke(gus, buffer, address, size);
 }
 
-static int snd_gus_dram_peek(struct snd_gus_card *gus, char __user *_buffer,
+static int snd_gus_dram_peek(struct snd_gus_card *gus, char *_buffer,
 			     unsigned int address, unsigned int size,
 			     int rom)
 {
@@ -67,15 +67,14 @@ static int snd_gus_dram_peek(struct snd_gus_card *gus, char __user *_buffer,
 			while (size2--)
 				*pbuffer++ = snd_gf1_peek(gus, address++);
 		}
-		if (copy_to_user(_buffer, buffer, size1))
-			return -EFAULT;
+		memcpy(_buffer, buffer, size1);
 		size -= size1;
 		_buffer += size1;
 	}
 	return 0;
 }
 
-int snd_gus_dram_read(struct snd_gus_card *gus, char __user *buffer,
+int snd_gus_dram_read(struct snd_gus_card *gus, char *buffer,
 		      unsigned int address, unsigned int size,
 		      int rom)
 {
diff --git a/sound/isa/gus/gus_mem_proc.c b/sound/isa/gus/gus_mem_proc.c
index 04c212882718..c939bfd5a966 100644
--- a/sound/isa/gus/gus_mem_proc.c
+++ b/sound/isa/gus/gus_mem_proc.c
@@ -18,7 +18,7 @@ struct gus_proc_private {
 
 static ssize_t snd_gf1_mem_proc_dump(struct snd_info_entry *entry,
 				     void *file_private_data,
-				     struct file *file, char __user *buf,
+				     struct file *file, char *buf,
 				     size_t count, loff_t pos)
 {
 	struct gus_proc_private *priv = entry->private_data;
diff --git a/sound/pci/cs4281.c b/sound/pci/cs4281.c
index b831f1d50750..1444e39fdbc1 100644
--- a/sound/pci/cs4281.c
+++ b/sound/pci/cs4281.c
@@ -1104,25 +1104,23 @@ static void snd_cs4281_proc_read(struct snd_info_entry *entry,
 
 static ssize_t snd_cs4281_BA0_read(struct snd_info_entry *entry,
 				   void *file_private_data,
-				   struct file *file, char __user *buf,
+				   struct file *file, char *buf,
 				   size_t count, loff_t pos)
 {
 	struct cs4281 *chip = entry->private_data;
 	
-	if (copy_to_user_fromio(buf, chip->ba0 + pos, count))
-		return -EFAULT;
+	memcpy_fromio(buf, chip->ba0 + pos, count);
 	return count;
 }
 
 static ssize_t snd_cs4281_BA1_read(struct snd_info_entry *entry,
 				   void *file_private_data,
-				   struct file *file, char __user *buf,
+				   struct file *file, char *buf,
 				   size_t count, loff_t pos)
 {
 	struct cs4281 *chip = entry->private_data;
 	
-	if (copy_to_user_fromio(buf, chip->ba1 + pos, count))
-		return -EFAULT;
+	memcpy_fromio(buf, chip->ba1 + pos, count);
 	return count;
 }
 
diff --git a/sound/pci/cs46xx/cs46xx_lib.c b/sound/pci/cs46xx/cs46xx_lib.c
index 797a5f09cade..2a4910e5b497 100644
--- a/sound/pci/cs46xx/cs46xx_lib.c
+++ b/sound/pci/cs46xx/cs46xx_lib.c
@@ -2741,13 +2741,12 @@ static inline void snd_cs46xx_remove_gameport(struct snd_cs46xx *chip) { }
 
 static ssize_t snd_cs46xx_io_read(struct snd_info_entry *entry,
 				  void *file_private_data,
-				  struct file *file, char __user *buf,
+				  struct file *file, char *buf,
 				  size_t count, loff_t pos)
 {
 	struct snd_cs46xx_region *region = entry->private_data;
 	
-	if (copy_to_user_fromio(buf, region->remap_addr + pos, count))
-		return -EFAULT;
+	memcpy_fromio(buf, region->remap_addr + pos, count);
 	return count;
 }
 
diff --git a/sound/pci/emu10k1/emuproc.c b/sound/pci/emu10k1/emuproc.c
index f6186b5be049..acacce976415 100644
--- a/sound/pci/emu10k1/emuproc.c
+++ b/sound/pci/emu10k1/emuproc.c
@@ -382,7 +382,7 @@ static void snd_emu10k1_proc_acode_read(struct snd_info_entry *entry,
 
 static ssize_t snd_emu10k1_fx8010_read(struct snd_info_entry *entry,
 				       void *file_private_data,
-				       struct file *file, char __user *buf,
+				       struct file *file, char *buf,
 				       size_t count, loff_t pos)
 {
 	struct snd_emu10k1 *emu = entry->private_data;
@@ -415,10 +415,8 @@ static ssize_t snd_emu10k1_fx8010_read(struct snd_info_entry *entry,
 		}
 		tmp[idx] = val;
 	}
-	if (copy_to_user(buf, ((char *)tmp) + (pos & 3), count))
-		res = -EFAULT;
-	else
-		res = count;
+	memcpy(buf, ((char *)tmp) + (pos & 3), count);
+	res = count;
 	kfree(tmp);
 	return res;
 }
diff --git a/sound/pci/mixart/mixart.c b/sound/pci/mixart/mixart.c
index f451554cff5f..c44001f0d320 100644
--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -1110,14 +1110,13 @@ static int snd_mixart_free(struct mixart_mgr *mgr)
  */
 static ssize_t snd_mixart_BA0_read(struct snd_info_entry *entry,
 				   void *file_private_data,
-				   struct file *file, char __user *buf,
+				   struct file *file, char *buf,
 				   size_t count, loff_t pos)
 {
 	struct mixart_mgr *mgr = entry->private_data;
 
 	count = count & ~3; /* make sure the read size is a multiple of 4 bytes */
-	if (copy_to_user_fromio(buf, MIXART_MEM(mgr, pos), count))
-		return -EFAULT;
+	memcpy_fromio(buf, MIXART_MEM(mgr, pos), count);
 	return count;
 }
 
@@ -1126,14 +1125,13 @@ static ssize_t snd_mixart_BA0_read(struct snd_info_entry *entry,
  */
 static ssize_t snd_mixart_BA1_read(struct snd_info_entry *entry,
 				   void *file_private_data,
-				   struct file *file, char __user *buf,
+				   struct file *file, char *buf,
 				   size_t count, loff_t pos)
 {
 	struct mixart_mgr *mgr = entry->private_data;
 
 	count = count & ~3; /* make sure the read size is a multiple of 4 bytes */
-	if (copy_to_user_fromio(buf, MIXART_REG(mgr, pos), count))
-		return -EFAULT;
+	memcpy_fromio(buf, MIXART_REG(mgr, pos), count);
 	return count;
 }
 
diff --git a/sound/usb/mixer_scarlett2.c b/sound/usb/mixer_scarlett2.c
index ed5fe746d438..48557235c389 100644
--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -9763,7 +9763,7 @@ static ssize_t scarlett2_devmap_read(
 	struct snd_info_entry *entry,
 	void                  *file_private_data,
 	struct file           *file,
-	char __user           *buf,
+	char                  *buf,
 	size_t                 count,
 	loff_t                 pos)
 {
@@ -9785,7 +9785,7 @@ static ssize_t scarlett2_devmap_read(
 	while (count > 0) {
 		/* SCARLETT2_USB_GET_DEVMAP reads only on block boundaries,
 		 * so we need to read a whole block and copy the requested
-		 * chunk to userspace.
+		 * chunk out of it.
 		 */
 
 		__le32 req;
@@ -9800,7 +9800,7 @@ static ssize_t scarlett2_devmap_read(
 					 block_size,
 					 entry->size - block_start);
 
-		/* size of the chunk to copy to userspace */
+		/* size of the chunk to copy out of the block */
 		size_t copy_size = min_t(size_t, count, read_size - offset);
 
 		/* request the block */
@@ -9810,8 +9810,7 @@ static ssize_t scarlett2_devmap_read(
 		if (err < 0)
 			return copied ? copied : err;
 
-		if (copy_to_user(buf, resp_buf + offset, copy_size))
-			return -EFAULT;
+		memcpy(buf, resp_buf + offset, copy_size);
 
 		buf += copy_size;
 		pos += copy_size;

-- 
2.53.0


