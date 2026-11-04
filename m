Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DDDF606A851
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S3SzdWSz
Received: by kanga.kvack.org (Postfix)
	id 852676B05CC; Wed,  4 Nov 2026 16:17:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82A216B05CD; Wed,  4 Nov 2026 16:17:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 740326B05CE; Wed,  4 Nov 2026 16:17:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2DB6B05CC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:17:04 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2FFE1607D5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:17:03 +0000 (UTC)
X-FDA: 85398696726.28.41163E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id F38A1C0008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:17:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S3SzdWSz;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793827022;
	b=4f1SvR2jNzC/+QFCgt6+Wksz3zBuC6/Xk5iUy4t+w3mUj0Vuz27pOacJ6yix+gcLnfzvP/
	QbIujjC8ABzcYjSL+EkrWrT98MRRjO8jMpIBiiGQD3cJ0XoN7QEtxWzLfsBEaUEdNnx2zZ
	PtdngZGArFv3bSlhXHgxQQhSPnB9EI4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S3SzdWSz;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793827022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zeHs9UAP7YIb3jk19VW8WXuXpSby7HHZ4SLZ7Ya7qeg=;
	b=30+N+KQ39Z0tif5ePVwtRdyVfUkIjKsxzgx5L2L+8hqtFwRqxPq+0HuXyAxD5Y3AQzrSzG
	+98rDGsiKJxak+nKsPjzv6elREG89rrbx6xYOUDX4TorlT7fSTGwToEijq3SqaaoIyX+7z
	Ksm6DjDlQoxtgMASGhyZu0p75FaB17A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A16544D84;
	Wed,  4 Nov 2026 21:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AC31F00A02;
	Wed,  4 Nov 2026 21:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793827021;
	bh=zeHs9UAP7YIb3jk19VW8WXuXpSby7HHZ4SLZ7Ya7qeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S3SzdWSzW86Oi7IX1tUBoRNN3T1qaKpCsD195aJc0q3DFSVT8WBvY060bSLKhgobb
	 ozqt92gwXbw5PQb0azuNQvXlPB7WnJ6cBECkdsTADqTj+zV4KFstm2CIoVK3RnyKHw
	 qukYCNAdRUYdRI6RQkFYFD46MOjD+1c8YqXVIsSOalpjdzN976W0rXYKybUDWkvkIa
	 rfbNpjRPuRxsQxtxAfSij5iqz5tsGOkFhdPq9CXCzRhQ5vabAbm6JESEBXYkE7I8Zz
	 Xcw2dOWqmhnKSnz+HejYopwm49XOlRK/JAYtCOxhFx3vpJFr7q8EZmlKY7qc7HALif
	 bf0zrDFVpbYqg==
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
Subject: [PATCH RESEND v2 6/6] proc: drop the poll_table from ->proc_poll()
Date: Wed,  4 Nov 2026 22:16:46 +0100
Message-ID: <20261104-work-procfs-cleanup-v2-6-1e6687e226b1@kernel.org>
In-Reply-To: <20261104-work-procfs-cleanup-v2-0-1e6687e226b1@kernel.org>
References: <20261104-work-procfs-cleanup-v2-0-1e6687e226b1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5605; i=brauner@kernel.org; h=from:subject:message-id; bh=xctjOvW/3SEZoVIWJreYFKvLSI3LgHd/aggSpp1K3Wc=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9XpDCwWfSYe8eveS8yHFO7St6c86UqkTd43v8XXbxs eORD9pDOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYivoGRYdl9h7P19TJf4stb 3x3lv8VUfL7o3Cmvh99vBMo/PlY8S4bhn/KGbxquT4Jf+f7xcV3IcHfqg01FBpdsX2pJecw75bG miBMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F38A1C0008
X-Stat-Signature: gr47oc8xch4q8mw9jtabo53bewwatq63
X-Rspam-User: 
X-HE-Tag: 1793827021-526960
X-HE-Meta: U2FsdGVkX186JQ87YTGT8T+oKaHqd7wcSdpklmZ7jshHdgok4mNvPpM63lJomiM979k72ircchsWRdQvE//pBXTmSc8Yp0zeOsAid/KY19bnKqsYZrY70Kih2o+Gp6G0xNSgtC/tC/iFtH3kD8BD3Hf928JNpTKkBH2dddpA8p18+RDPteu4XtdsLyDdQ3UbkNWTY+uPCh3YTupguFMuTuPp8bZcnrsvZafTBvdm/HDRbP0t/4ZklBUtVg5xOSLwVk3tgB9Wenm+6zLcSIAIjgwv5QsaGFJBubicv2vcB2yfGM2FOK3Plg3d0Mv0yY7jOI+k9QehHMZXd7SClTOPDHhEsRtzfINBMdiiTELCeu5ujiE503mqOOAr35UuHAiA12a1APc+HrplKpRacHRTIA1GajQq7CbeOwLWoOfyKlBr9cX3qudFBKKyV5MeAlxS/VV/L2f87XDhHv2md/JziaaMeJYdr8vF3TpAelG865BHI0BB3BtG5I1WCYVAdCZdAHqhK9kAFu28ONUDEGocUd5Eu7RgluQWECotikqGtqHdddgUsuLRMe31JZhDPtppJ39QW/E3QSqZLG/lLyt1UwK/wjH4WqhZV/UT5Kla2wnUdPG3i7cGBzfIoUI9d5Zj44vMKE2eLNcPWrGeSsQ8cg1kZ8aQ3qkrfv27jjIDZ6P2wvoezV5vSlORUMdrKvtXaVnERDz8ah9M1kIoLhW+LhAagFF8cVf0BPkpSqGXrcjwUsMYbWp4VtK5yP+P++buGuh8d8EVFoSbUvX2aT6BMTprbWrM3PKi68kZXMRnxWbckFbrrCC75TMV7rDYwSZc4OUNgVnlcJ7eXOGbVgXIgZtwIMLiWHRnJisDdAacEVxoAgZzW3V8i2oSv2bBstWJXhpjEMpuYRtZVjVeOmuRgl8JfkM00LI09yDu6C+lSJKX9jtGkmvjGnq/BNo/HHzUmyBVocAVMt5UTU9zDRN
 vg+t9k5a
 qLLIy6cWn/z5WkcBfUyUs0xAH39GzTIykvBdW1TfdJ6jjx2hWf7O+z6P59S9LDevRME4PneK8bnJ+7ubg4Jop67w4+/THWO6LKiQgeME0SNkIWaI/RIQwiQpTsS8pl/M46D/550psjSNpVEzu/zbTBJ9fzj4tEk7nbe6oOCOG/8PonXOj6mJiWytT1VksLOcQY0UK/vwhJWELwdbOp5BCgamOaHmct2b9U8Xy+PaPRQvpNYeN90UMYHo5EdvKBVgGlrkA5DYtBAee9tiiOyL+crKaFrHgT26MEsOZZanee2UsY2Ii+OSmofOzEv+Ah8ohSb+tDPER42Q69qc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every entry sleeps its pollers on the wait queue procfs owns for it
now, so take the poll_table away from the method. An entry can't hand
procfs a queue of its own anymore then, which is what went wrong for
sunrpc, and the method only reports the mask.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/kernel/rtasd.c | 2 +-
 drivers/input/input.c       | 2 +-
 drivers/md/md.c             | 2 +-
 fs/proc/inode.c             | 2 +-
 include/linux/proc_fs.h     | 9 +++++----
 kernel/sched/psi.c          | 4 ++--
 mm/swapfile.c               | 2 +-
 net/sunrpc/cache.c          | 2 +-
 sound/core/info.c           | 2 +-
 9 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/kernel/rtasd.c b/arch/powerpc/kernel/rtasd.c
index 49036790b67c..34705234db57 100644
--- a/arch/powerpc/kernel/rtasd.c
+++ b/arch/powerpc/kernel/rtasd.c
@@ -343,7 +343,7 @@ static ssize_t rtas_log_read(struct file * file, char * buf,
 	return error;
 }
 
-static __poll_t rtas_log_poll(struct file *file, poll_table * wait)
+static __poll_t rtas_log_poll(struct file *file)
 {
 	if (rtas_log_size)
 		return EPOLLIN | EPOLLRDNORM;
diff --git a/drivers/input/input.c b/drivers/input/input.c
index a984810eb80d..5a0547296c6c 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1097,7 +1097,7 @@ struct input_seq_state {
 	int input_devices_state;
 };
 
-static __poll_t input_proc_devices_poll(struct file *file, poll_table *wait)
+static __poll_t input_proc_devices_poll(struct file *file)
 {
 	struct seq_file *seq = file->private_data;
 	struct input_seq_state *state = seq->private;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7560dcf0f5c8..94926a7c3d6f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9176,7 +9176,7 @@ static int md_seq_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static __poll_t mdstat_poll(struct file *filp, poll_table *wait)
+static __poll_t mdstat_poll(struct file *filp)
 {
 	struct seq_file *seq = filp->private_data;
 	__poll_t mask;
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 7f6c63885f53..c35e13b44eed 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -546,7 +546,7 @@ static __poll_t proc_reg_poll(struct file *file, struct poll_table_struct *pts)
 	poll_wait(file, &pde->open->poll, pts);
 	if (!pde_pin(pde))
 		return DEFAULT_POLLMASK | EPOLLERR | EPOLLPRI;
-	rv = pde->proc_ops->proc_poll(file, pts);
+	rv = pde->proc_ops->proc_poll(file);
 	pde_unpin(pde);
 	return rv;
 }
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 872f3bd54c11..6e2bcdf3c1b5 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -84,11 +84,12 @@ struct proc_ops {
 	int	(*proc_release)(struct inode *, struct file *);
 	/*
 	 * procfs owns a wait queue for an entry with a ->proc_poll() and
-	 * does the poll_wait() on it before it calls the method. The owner
-	 * wakes the pollers with proc_poll_notify(). A poll on a removed
-	 * entry reports EPOLLERR | EPOLLPRI.
+	 * does the poll_wait() on it before it calls the method, which only
+	 * reports the mask. The owner wakes the pollers with
+	 * proc_poll_notify(). A poll on a removed entry reports
+	 * EPOLLERR | EPOLLPRI.
 	 */
-	__poll_t (*proc_poll)(struct file *, struct poll_table_struct *);
+	__poll_t (*proc_poll)(struct file *);
 	/*
 	 * procfs pins the entry around ->proc_mmap() and wraps the
 	 * vm_operations of the mapping so that ->open(), ->fault(),
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 9362c27d47ab..ecb9028b5c49 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1606,11 +1606,11 @@ static ssize_t psi_cpu_write(struct file *file, char *buf, size_t nbytes,
 	return psi_write(file, buf, nbytes, PSI_CPU);
 }
 
-static __poll_t psi_fop_poll(struct file *file, poll_table *wait)
+static __poll_t psi_fop_poll(struct file *file)
 {
 	struct seq_file *seq = file->private_data;
 
-	return psi_trigger_poll(&seq->private, wait);
+	return psi_trigger_poll(&seq->private, NULL);
 }
 
 static int psi_fop_release(struct inode *inode, struct file *file)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1d063a1cef43..e7c019871e35 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3315,7 +3315,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 }
 
 #ifdef CONFIG_PROC_FS
-static __poll_t swaps_poll(struct file *file, poll_table *wait)
+static __poll_t swaps_poll(struct file *file)
 {
 	struct seq_file *seq = file->private_data;
 
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index b8f70d8c3b0c..4854a42d43a2 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1588,7 +1588,7 @@ static ssize_t cache_write_procfs(struct file *filp, char *buf, size_t count,
 	return ret ? ret : count;
 }
 
-static __poll_t cache_poll_procfs(struct file *filp, poll_table *wait)
+static __poll_t cache_poll_procfs(struct file *filp)
 {
 	struct cache_detail *cd = pde_data(file_inode(filp));
 
diff --git a/sound/core/info.c b/sound/core/info.c
index 3439ae341e26..8e64d8e3e5b2 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -184,7 +184,7 @@ static ssize_t snd_info_entry_write(struct file *file, char *buffer,
 	return size;
 }
 
-static __poll_t snd_info_entry_poll(struct file *file, poll_table *wait)
+static __poll_t snd_info_entry_poll(struct file *file)
 {
 	struct snd_info_private_data *data = file->private_data;
 	struct snd_info_entry *entry = data->entry;

-- 
2.53.0


