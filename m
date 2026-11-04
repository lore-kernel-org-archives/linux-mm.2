Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F066075252
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lkp6RIn6
Received: by kanga.kvack.org (Postfix)
	id ED4C56B05E5; Wed,  4 Nov 2026 14:48:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EABBF6B05E6; Wed,  4 Nov 2026 14:48:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC05A6B05E8; Wed,  4 Nov 2026 14:48:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7BA36B05E5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:48:10 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4DA6F8084E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:48:10 +0000 (UTC)
X-FDA: 85398472740.24.7A36A43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 905C7C0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:48:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lkp6RIn6;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ONplUVUaTXxK76De6Vn1Er9qs4C1NOSJXP/cPYa1zD8=;
	b=Ypfaf6ZQqYLYInyuIIre6mpxesgewkvNZ4y0+X2INydRBEGIW0O1vaooMVfm7LEwsmYHLf
	WeGSLQGIS6oLmwF9c09rnYVZQgwsvbFVPqVXIWy7u05vXG6/QPVJweg98f6Ra6pYnKNZQx
	892Ns7Wfr5e5SRUQ/TcHm83mqj1a1zk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821688;
	b=wCQ8qu66yMST/+2Y/YKSlKKhUCC44OQv77Erz+Pu36ru9HVDOBT7bMTnqTvj1rYwWzxrT+
	qYSXcuA8vKu0zVLleQnrASDCcBPfSQWmW2kbOdMyKO2VgTwNv193O9g285Xxci0uhGuyBB
	0UgaeyKRmEXeR7X1ivYd2fMS864ok7I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lkp6RIn6;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31D6D60F05;
	Wed,  4 Nov 2026 19:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FC71F000C1;
	Wed,  4 Nov 2026 19:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821687;
	bh=ONplUVUaTXxK76De6Vn1Er9qs4C1NOSJXP/cPYa1zD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lkp6RIn69wa7QrxD965N76gTH76+Ad2SR2O4p5PIPFHK1xPstYpO5rXkJqMhkQ1Lt
	 f15stAccZE+S2yUy9VGYtTIgb/gLZoRkrtlXoSacpGUOek+JW4mciApeqg2m5gx7x7
	 jGcS2vzRcQT4C4Y2PMcgBIOORBdEDw5OW53AWsnhXJof8U2cIcsSBGzLLOhYFg8OY7
	 xr0CoygIBWv0A8Or/m5mqhRp+z3mn0v/XHAYgjIlNWHV+2hv84NzEvNyWKQmtZ3LQt
	 Nr81LfNZpAVIjzqW/eNpYRsboymU0WuZFRUFGyiYnkNPIl/SIoK0dzBDYI5+8c0PL1
	 46Zaq8Svqs2Yw==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH RESEND v2 23/26] ALSA: info: let procfs copy in writes
Date: Wed,  4 Nov 2026 20:47:53 +0100
Message-ID: <20261104-work-procfs-drivers-v2-23-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4905; i=brauner@kernel.org; h=from:subject:message-id; bh=9ArjgwxZmmzVVHcaJKjV9iOUwuFu8vZkTaYAiSu/pJs=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97urfa8O39IWQ3sMqj7K8++pB6682y+x4pbRQuVd71 /ZZwXuOdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkaD8jw6qXkrMe32mW0Fr4 KjZPsovjwSUF/kq/82FOm+4YrNPjX8Pwz37zUZPZUqvCmfvMVYrnaPSeXD/5c/zt75vbeeakVdv 5MAAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: umj8ygj1j45fkq3b7b58u3q6c3t64zj9
X-Rspamd-Queue-Id: 905C7C0005
X-Rspam-User: 
X-HE-Tag: 1793821688-135225
X-HE-Meta: U2FsdGVkX18SZ4S4+0Q6r4VQafFClcAypcQhjGA2/fuv8sOS16xLPeO839J52gD+P+lE+tmpi3r9qNGHDquxpx20cKn0bdwR/5SAmU0cmUzWr8Se4jND7vv1nuNZ8EtqS9oxIwpYsh/NaPCqArz/MTLH2SL7biZf6tQxJqnfVJZ2MdmoGZaGCWTaH3hc50B0P37Tc0+79AneT8t9KwsPsd7TJ5PH3PDquHuOsYYrFRx+hvyCOVAqz/zpNZ9jqFz0nHH+TC3q5x2IO38V5KYyTxes1IKBPxWzcbhaMtk6KyZjJCooN1Hnji0fVPv2iQnCQI025QORhA1rss5uUyziRxil5IRLwf2EWHQKKiQbtEUjeAGXleeudMhjFEAj6A7H6w+tYt3dAKnLIjvHfnfHgiFodNdhVrhimitE6GCSspsaRdJA3tKY5Qsrz1aWp/7q9zKRDCz8Gf8+MseIYXiko7O5yDupqeDSUCrIct6WhIoZ0nci7kp7aOEhBm0NejQ1HfqwXmpthDdlMhw+CwXTSs75y84G1kXmGAk6P96vx8M/Kotn4l7zZ9c+MR5adGy/2T3zqxnx7WaxDE+G3Uro175ie75DwBgERNY9OKwSnKgL46fidlsp9SPIsC7M4ImzzOgyUN9rRQ083L4dcnaBYv/uWHSOLkbSJ3jzSazTcfqkH1NKvQe/X4kRtwudeSIMZxk60QHyp0HUyEH9uccMmvsKzetY7jqbWB35XrVEl/Wkqc3DGlGCQx++utRNJq+/zCe+enPgfRQsiKRQi+PEWBhgETahxuvB0/r7lCqRn4cjw8CiDMpwRoL/KeXCNtp4HsF9MQRTVZLXXdbJ5XEBHFgR6/+Kmrc4/ghHkp+vgh4CIJawc1cB0bbxky6CHflMVHP6hA0bJqaRDGdUy0si9RG5S96Nfzm6gnkpPdH3bnh1OdQeAvzN/YhmPxyEIdJthW2G/PLcv5ZRvucU9W1
 F6zBLevI
 Ae0u4WavUxzH1uY71lEng2NTsyEvhF4YXHjGlEE6LAbkIiXPJGktW0HHyna60k9KGvAXRtrg3axa93j3FoiMK6mKW03tlhlIl8xehCjLuViJbgNwSWe0m++Mrd2gHaCUBSZaxWrSo3FATpyXrnIZS88BJQCKOTSyOrxuFR+1sdzcS8A/y3CnDqfvyHFChZN1lBqEjSY+816JS0ZbF1GQtwQJWzLuSQXNm0LAnJRoSit/HgfF4tnWqPGiDBOIPbiKehfrOfpbbMcKLc+gd7Y/wh2ebBzJTUW+kHFuXMFk7DQ8mO7a14+8/RUFCbeuxGgy/tFsxjGnvwq87Nr8AN6fiI6aipU/JnBHjP79gurqBoIZUjtaSIKubypflKFqiunR9QF9H2vgTlNdnaejAqyHLo1Xwcg==
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
index f216291e5c41..a9344c44e352 100644
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
index 42a4f8fb3198..3bfeab1a5a1f 100644
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


