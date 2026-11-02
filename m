Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18718606EEA7
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B6cTTm4Y
Received: by kanga.kvack.org (Postfix)
	id 30DE66B05C8; Mon,  2 Nov 2026 10:17:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296C96B05C9; Mon,  2 Nov 2026 10:17:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F7E6B0610; Mon,  2 Nov 2026 10:17:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E79C96B05C8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:17:34 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 523E6A0176
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:17:34 +0000 (UTC)
X-FDA: 85390533228.05.A6FB7F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8EEB340007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:17:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B6cTTm4Y;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S8BhauG/lP2s9np5J0R1zzems7E8P5CDYFcbPs7MISk=;
	b=U5TSjsZJoGXYziaH0DvjBJ2A5rqBrODAUSmMGrCkUSmKjV7v1ULI2YChNPoihlFmRmgKRB
	CZ7HCSfuA5niTanf7f2ZC8UnDl9AJ/pr/XsbB5QYCf1Z4EJzP/hLhuprKgtqcCdxaWyVcZ
	pXerdI/QdlGhpF6quSEN0QzigC4YHc0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632652;
	b=a8jX7II7VESCjfDQpSIU/x9DX/6RjvSBHfyi8nJGE3xu8h2Z15RlzMZcdyySSwjBgxHei4
	wr7bxCgUVlLFLfVkG5hP2UbzzT+aRi/JJsUzfPdGIx09HyEr4PPYFEVhHM4VArabmSd6rM
	bdpRcbN1Ges8eFTvf2oKNn2/rkRd8N8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B6cTTm4Y;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3078E609D3;
	Mon,  2 Nov 2026 15:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367381F00A16;
	Mon,  2 Nov 2026 15:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632651;
	bh=S8BhauG/lP2s9np5J0R1zzems7E8P5CDYFcbPs7MISk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B6cTTm4Y/wdooL+ApfO/HX/ZDcHy871M+X9n7WkLV4Na54VVI8Ta+GbpUioF3ohSU
	 HHQo9Jkcew+x0HR14YfLduB3vudFo6GZ0wfYcfe7ffo/MAUQIiTmuM8ZFUOm9Sg5hr
	 9kkUsh2Q8m4eaiyTGh20A2ag1ZbWNy43odsaE3VIqiomPZmHmYzMxoNcG2FL1hoMLH
	 78N6Ik+BUAAl1xtmFBWvurEQT0AERbrvBCCfciM03MgEELv6G4mkS4ovaRu4ohxvyl
	 4wGuLeQtigGuCLneFLcOpa6Ayv00b+mXvCWgBazmSkXDaCma8Dt3CVFcCwkH1dWK1q
	 5bg3vsSIrSD6g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:28 +0100
Subject: [PATCH RFC 21/23] ALSA: info: let procfs copy in writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-21-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4905; i=brauner@kernel.org;
 h=from:subject:message-id; bh=LuuwL6UJ7KGtrckYm3Uj4kQJlkSBUwRuOX3mF2sG+Yw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG6o6D7rw7X6A5dqbtx35bCpa3Q+EXL87IJ3SqrHA
 5Yqn/zyo6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiLfMZGVr3H8tc/DUgTOey
 t8qOf6wHdFd+DO0+5PpnP8fEQrsrMdMYGfY2374+1XfmNYM73p/uJBzp37b9zN94sbn1Hn7frnz
 n+s8BAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8EEB340007
X-Stat-Signature: d3tyh49kjcqf9ftpwtna5kz4d49mm53q
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793632652-715008
X-HE-Meta: U2FsdGVkX18l+Ub8v91YhyMZ5ljt17cLl6VUOEIF70rPxIIABNZ1tl7oOmThRzjAuxLrEFTmkGAh9W51fEI/C11rwhqrjXrMKl+hV0OvNf+vsj9Etz5m8RkdL3VdCEIURaq4q7jjJwPY54sdbYFJbPZFOJKFq7JqH0GlHQPoey0clXi1fl4np/rqAE5apcojGm4R4aqMdEfs5/CpD+GboGFeAaA6M9F8Fu+LqbDqvEOq/OJT3beMCnzciNMivVSMY3+06QYSmYrlPYVPwdXDV3btvsxCuxyv2P/HbpmmfTmF2rT3N68fOdlODIQEs0Zi1+xFk8DE5N6wbBS9VNfYr6hFEKth5ulYAnJ3zoxSmp8c8Lupzq26aKHJwPLwrJxWmXOTGXKV0pA8CNr7fmEmT33WDbKMrOPQdiW/Ozk7uXY+dMiB3K6ZbGkq3gA/6fn9adeRi9ELpjbM3+u5MYDCl79IG5GKCnhiqGbTCCz61vlHnEVGtMUZIdQdKKAjKF+EFGJYGeITyS3AUOfFqqKVhUXGGlMI9utdH7DByvcAbbZUz2afUflT+jUHM59aL7ti4DYVKg3JjJldLW/1AIFZMXubO9AmX9GezsHDIT6OwD6ylK66GPROXBTX47QQnT299dpnCgoiPBV/Z35NqKE9vKcR/2UaYo4MZEW8PFl80A/vL7z5EEtawbh5jRGq9JNIgDyrDYnBIRUXN+XdfQfFVhPyI6a4aDSNg0+z0LoozluQtR3WzniZ/dt51rkSMkUEEx3px4gVMn50a2JEsm5AeXY5nhxIbfBzi/I2t8RUDmKfFnJY+3ndj28nSJOYb4GYJlCJVO7pA5qAGag1TIgljSuNIjhfLd4gA0YDnSjiI+yHG0EznkeFSUagEXnYMae5HFN8sLAFQWRitJ+dueMaXsVgb0/EO5hkqe0f31b5PM6d+89x/KSyjQRrVYRSgh4gfjWRMGqFkA+1EXLddeA
 pGfsAXxf
 9ZXiRXt3HQKRNcrdGQUHnpiTDQRvh46/jNkGSt+kPPExOAj7dIrhKBAQJuY0lWPyAOUDWcWj0x8NVUFCuAaydOTyJ5D8jKrvnEAXN0rh0Nad9BAddGzpmApsfTBdZCUUCJeUduzUndBgqplCYymtpu/OYNq2Eg2PKekOQZJp0RJIz4KV2Ectf6NP12rKeA+CmtwcD++xOoBAszw6PWjqY0eknbO6Ug57Um20S5BZDg4K6h8P9sBcF/gAUE8sXLfxyHknsjYtim8eWx4y55EJV8QKF2H7VCtPqpnNB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() for data and text entries so procfs copies
in what is written before it pins the entry.

Data entries take writes a page at a time with PROC_ENTRY_SHORT_WRITES.
They used to get the whole write at once. ->write() of struct
snd_info_entry_ops gets the kernel copy and opl4, its only user, writes
it to the sample memory without bouncing it through a vmalloc() buffer
of its own.

Text entries take up to SND_INFO_TEXT_WRITE_MAX bytes at once like
before. A single write that is larger fails with -EINVAL from procfs
instead of -EIO now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/sound/info.h           |  2 +-
 sound/core/info.c              | 21 ++++++++++++---------
 sound/drivers/opl4/opl4_proc.c | 11 +----------
 3 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/include/sound/info.h b/include/sound/info.h
index adbc506860d6..32fc608d056c 100644
--- a/include/sound/info.h
+++ b/include/sound/info.h
@@ -42,7 +42,7 @@ struct snd_info_entry_ops {
 			struct file *file, char __user *buf,
 			size_t count, loff_t pos);
 	ssize_t (*write)(struct snd_info_entry *entry, void *file_private_data,
-			 struct file *file, const char __user *buf,
+			 struct file *file, const char *buf,
 			 size_t count, loff_t pos);
 	loff_t (*llseek)(struct snd_info_entry *entry,
 			 void *file_private_data, struct file *file,
diff --git a/sound/core/info.c b/sound/core/info.c
index 8f905f398a0d..09d4420202e5 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -160,7 +160,7 @@ static ssize_t snd_info_entry_read(struct file *file, char __user *buffer,
 	return size;
 }
 
-static ssize_t snd_info_entry_write(struct file *file, const char __user *buffer,
+static ssize_t snd_info_entry_write(struct file *file, char *buffer,
 				    size_t count, loff_t * offset)
 {
 	struct snd_info_private_data *data = file->private_data;
@@ -277,9 +277,11 @@ static int snd_info_entry_release(struct inode *inode, struct file *file)
 
 static const struct proc_ops snd_info_entry_operations =
 {
+	.proc_flags	= PROC_ENTRY_SHORT_WRITES,
 	.proc_lseek	= snd_info_entry_llseek,
 	.proc_read	= snd_info_entry_read,
-	.proc_write	= snd_info_entry_write,
+	.proc_write_buf	= snd_info_entry_write,
+	.proc_write_size = PAGE_SIZE,
 	.proc_poll	= snd_info_entry_poll,
 	.proc_ioctl	= snd_info_entry_ioctl,
 	.proc_mmap	= snd_info_entry_mmap,
@@ -287,11 +289,13 @@ static const struct proc_ops snd_info_entry_operations =
 	.proc_release	= snd_info_entry_release,
 };
 
+/* don't handle too large text inputs */
+#define SND_INFO_TEXT_WRITE_MAX	(16 * 1024)
+
 /*
  * file ops for text proc files
  */
-static ssize_t snd_info_text_entry_write(struct file *file,
-					 const char __user *buffer,
+static ssize_t snd_info_text_entry_write(struct file *file, char *buffer,
 					 size_t count, loff_t *offset)
 {
 	struct seq_file *m = file->private_data;
@@ -307,8 +311,7 @@ static ssize_t snd_info_text_entry_write(struct file *file,
 	if (!valid_pos(pos, count))
 		return -EIO;
 	next = pos + count;
-	/* don't handle too large text inputs */
-	if (next > 16 * 1024)
+	if (next > SND_INFO_TEXT_WRITE_MAX)
 		return -EIO;
 	guard(mutex)(&entry->access);
 	buf = data->wbuffer;
@@ -325,8 +328,7 @@ static ssize_t snd_info_text_entry_write(struct file *file,
 		buf->buffer = nbuf;
 		buf->len = PAGE_ALIGN(next);
 	}
-	if (copy_from_user(buf->buffer + pos, buffer, count))
-		return -EFAULT;
+	memcpy(buf->buffer + pos, buffer, count);
 	buf->size = next;
 	*offset = next;
 	return count;
@@ -404,7 +406,8 @@ static const struct proc_ops snd_info_text_entry_ops =
 	.proc_show	= snd_info_seq_show,
 	.proc_open	= snd_info_text_entry_open,
 	.proc_release	= snd_info_text_entry_release,
-	.proc_write	= snd_info_text_entry_write,
+	.proc_write_buf	= snd_info_text_entry_write,
+	.proc_write_size = SND_INFO_TEXT_WRITE_MAX,
 };
 
 static struct snd_info_entry *create_subdir(struct module *mod,
diff --git a/sound/drivers/opl4/opl4_proc.c b/sound/drivers/opl4/opl4_proc.c
index fd0ba4704d9f..bdcae02a4dc2 100644
--- a/sound/drivers/opl4/opl4_proc.c
+++ b/sound/drivers/opl4/opl4_proc.c
@@ -54,21 +54,12 @@ static ssize_t snd_opl4_mem_proc_read(struct snd_info_entry *entry,
 static ssize_t snd_opl4_mem_proc_write(struct snd_info_entry *entry,
 				       void *file_private_data,
 				       struct file *file,
-				       const char __user *_buf,
+				       const char *buf,
 				       size_t count, loff_t pos)
 {
 	struct snd_opl4 *opl4 = entry->private_data;
-	char *buf;
 
-	buf = vmalloc(count);
-	if (!buf)
-		return -ENOMEM;
-	if (copy_from_user(buf, _buf, count)) {
-		vfree(buf);
-		return -EFAULT;
-	}
 	snd_opl4_write_memory(opl4, buf, pos, count);
-	vfree(buf);
 	return count;
 }
 

-- 
2.53.0


