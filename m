Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 441E160960A9
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T4zZjUyv
Received: by kanga.kvack.org (Postfix)
	id 6A0896B05BA; Wed,  4 Nov 2026 14:54:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 677C36B05BE; Wed,  4 Nov 2026 14:54:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590016B05C0; Wed,  4 Nov 2026 14:54:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 336EE6B05BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:54:23 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCF4F16027D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:54:22 +0000 (UTC)
X-FDA: 85398488364.09.73EF8E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1259A140006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:54:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T4zZjUyv;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3UZDf+ZvXwviYYRO81gR2i4wUh8T09vQdpdtKHPc3tY=;
	b=oEiI2GMSRNpACmnoPnx8kfeZNFuhKW1ZElBg7jbA0p/cd9/eKIgTnxSYZRMWRIGzCmZ+B/
	WRE8OvOPgxGvaVWH18Vwj3N1MrB6zq2kcRqsuh6ITLWJxirc/5SjZ8tcaY0m8+epbKXnGh
	8DqGwu65byBm6J1VmvYNDu0RWg+Z8X8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822061;
	b=iCAoBcKHnl7XzloYf/odwzkkXGW0IVJB7HvwbtUrsrUFkJ4uW4WuHDGWhn6VW67jbL4CIO
	ENJzXcatQ/EfuRfyk0rMxuVYcy/EojDFGt9qOBU+EI0t6Y/+ecDqVZ33eo9n1ttIAhf4Av
	f3OjIzkuexDaiWMuDvuAFrJGJsxJ0JA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T4zZjUyv;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59C7040B34;
	Wed,  4 Nov 2026 19:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4E51F00919;
	Wed,  4 Nov 2026 19:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822060;
	bh=3UZDf+ZvXwviYYRO81gR2i4wUh8T09vQdpdtKHPc3tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T4zZjUyvc3j8nw3tiflJSUeNICqOlNSqZovU4PoZ6gqCLCJf1dfKY62TesU3x1UnQ
	 rmZH4PA14yEQGPUY0YxDG0RLF29s2Tc2EyPqEGnB33L1aLAfYW2dCKFRRME35LIF5T
	 ncjRWjlBOplt1Gz8nR2aQbwv2fsoF4i8azGGjYGRGrI199iNcnWxdpu1tFvYa5Pmpb
	 JcJSuGXigc7SbojgiY5EU9UjG5D2ih3JJM0YL4I1nZic7W+eZGo5koWndEV1Ufg9G8
	 /FSOwWp9czad84mKKOxlionZ073H7QGZaSlWz8kMTn/3mg1OD/MujBFOLbo3nYt0Gi
	 26tgrAqEobkXA==
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
Subject: [PATCH RESEND v2 18/30] sched/psi: let procfs copy in trigger writes
Date: Wed,  4 Nov 2026 20:54:06 +0100
Message-ID: <20261104-work-procfs-fs-v2-18-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3970; i=brauner@kernel.org; h=from:subject:message-id; bh=wWLtSsgUcAuxacgI730BoqUXYkuflISVemeZC+f0CIc=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97nFwW38zhO9UotLDx/VsMk/yam9uPJLL+qFY6vTfF 3seHvV90FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRvX4Mv9kWr98nfWmlb03+ h81e7R+kzPqWLzi0OS2lKImDXydEfT7DPxutE1ttrSQnvPViFjQ72dR23S6Wj1Fuwh2VGOEVO53 dOAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1259A140006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gjcpyjchurekk1s7mt8bs7rcjbycd67q
X-Rspam-User: 
X-HE-Tag: 1793822060-789087
X-HE-Meta: U2FsdGVkX1/j2VkgHLHAUyigqJOig9zJzmPRr71OUuLjAIBkhbEc+BO4iGesmoT90v5hcR1oWBDkZ/D1sQdTLxymbejUwSZXHnnarKA2uUbTB7ePwXMsljKsRE8StgjR5VvgSB+efqRo7sdy8JtlZqhNVRp6y9GpwE4CNqi9ViWk/mAJwp0ZxgGgs61yJ1hNZS4s80WGzL4SEx6DF42cFoyqMxicK5U2J08wbfr6/0jKc38IAPXQb3TL2lA3LvlEuxXUTCzijl1mDnJFojErNsxWWdxiyOQOKmywhQxU0e+IQWajt2m1Q6BVpvLwuwbDb29Ne7xtWH7TotE7DjxZTFFg1ad0JEQ4KD23lb2aKn5MLiOHgfiB6qlVSAP95SdMmlVlC2h74flFgytMqiFxMQTXu8WtUlTcfo2MGCo0t3k/w95zNAjWEgDf7Q8RPKPp254RRdXKkdqmqSTMeUE/TPlWqlt3w0xI8H5EPzQK611DPqu2LVWtDQ0WB6CZ4x2HV4BcV9Tb0gyyjW/eJS0pERnAOPfaEfUN+I5j4ZdWzFuOxnBNdPNKmKPznfDTelpKkQxaw2GuJH1Go4fSIRn6mXYr/OesKnGzmE+4zZFWIqzsOzjwsYdZm5hgeDeJggbSJ8ZTrdC5E/JMJ0PPKfNiWt5bolHZ+4h531S4/WiHPxUok3fEVZ5akzf5hYeWh3j6vj13fqnCjKVcUje8e/jAfQeYReDMwKm+n6roWLqQajQ6gzqzeGurlhLVa9f4qMIUQk86+NKZFo/DcCtyuLoFqFjuzCXj4Bv6syOXw8qndM1Vx7GSpobl21kaydjOLJ1TGyw1LZm326Q64aTMcn2np1CSDL0g/gnnfQxJSRQwjwCGjr8DKJhoqKljK0V+gc3B0/PKzRfkuEnIsi86LoMdLA47rpyflzgshmd9hm20JTEB9q7PxbuKeWNLady1Ezu6RDgK5e2kVY6wuAgRFKq
 LR6OazZw
 DADxfJM7D8Th4QFGFpGxIY8DIufk2we+/jEWEkaFTeuX4Zwf9vXWQR8u04cfXHmDuGv/TrMLgsCG/R3QArOka7WsawVnVo41IaAC8LqcziXMHAdwtwliKNblnZKWLjDUS4Agw0j0GjPuV/5HKCKW7H6W3Yeu1lHDqDIiudxR9jlerO0pPx6bs9BODyQLg5mfKaX9LDgPq0sh2OekhIsOR3vPdhbIQXmerlJ+Eyst+ZpvGlsGTj+INJjhEXZkbeB56RhyxesreAVS1iswBZNj7X/MN58hMwOwejHyY6wOG2KFOomZds0FLyoZnVBJ3v4sEmUi+Msp/GhGvrFud1tGJF4dp5pHCY14yttFPFOfgD5uDfh+Fyvp7OAigfx+V4XF/tf2K9cOUBBiKDe89NtPskOuFqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() for the files in /proc/pressure so procfs
copies in what is written before it pins the entry, and take the
trigger from that copy. Only the first 31 bytes were ever looked at.
Writes larger than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/sched/psi.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 9f1d9742bac9..9b99099017e1 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1535,8 +1535,8 @@ static int psi_cpu_show(struct seq_file *m, void *v)
 	return psi_show(m, &psi_system, PSI_CPU);
 }
 
-static ssize_t psi_write(struct file *file, const char __user *user_buf,
-			 size_t nbytes, enum psi_res res)
+static ssize_t psi_write(struct file *file, const char *kbuf, size_t nbytes,
+			 enum psi_res res)
 {
 	char buf[32];
 	size_t buf_size;
@@ -1552,9 +1552,7 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 		return -EINVAL;
 
 	buf_size = min(nbytes, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-
+	memcpy(buf, kbuf, buf_size);
 	buf[buf_size] = '\0';
 
 	seq = file->private_data;
@@ -1590,22 +1588,22 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 	return nbytes;
 }
 
-static ssize_t psi_io_write(struct file *file, const char __user *user_buf,
-			    size_t nbytes, loff_t *ppos)
+static ssize_t psi_io_write(struct file *file, char *buf, size_t nbytes,
+			    loff_t *ppos)
 {
-	return psi_write(file, user_buf, nbytes, PSI_IO);
+	return psi_write(file, buf, nbytes, PSI_IO);
 }
 
-static ssize_t psi_memory_write(struct file *file, const char __user *user_buf,
-				size_t nbytes, loff_t *ppos)
+static ssize_t psi_memory_write(struct file *file, char *buf, size_t nbytes,
+				loff_t *ppos)
 {
-	return psi_write(file, user_buf, nbytes, PSI_MEM);
+	return psi_write(file, buf, nbytes, PSI_MEM);
 }
 
-static ssize_t psi_cpu_write(struct file *file, const char __user *user_buf,
-			     size_t nbytes, loff_t *ppos)
+static ssize_t psi_cpu_write(struct file *file, char *buf, size_t nbytes,
+			     loff_t *ppos)
 {
-	return psi_write(file, user_buf, nbytes, PSI_CPU);
+	return psi_write(file, buf, nbytes, PSI_CPU);
 }
 
 static __poll_t psi_fop_poll(struct file *file, poll_table *wait)
@@ -1625,21 +1623,21 @@ static int psi_fop_release(struct inode *inode, struct file *file)
 
 static const struct proc_ops psi_io_proc_ops = {
 	.proc_show	= psi_io_show,
-	.proc_write	= psi_io_write,
+	.proc_write_buf	= psi_io_write,
 	.proc_poll	= psi_fop_poll,
 	.proc_release	= psi_fop_release,
 };
 
 static const struct proc_ops psi_memory_proc_ops = {
 	.proc_show	= psi_memory_show,
-	.proc_write	= psi_memory_write,
+	.proc_write_buf	= psi_memory_write,
 	.proc_poll	= psi_fop_poll,
 	.proc_release	= psi_fop_release,
 };
 
 static const struct proc_ops psi_cpu_proc_ops = {
 	.proc_show	= psi_cpu_show,
-	.proc_write	= psi_cpu_write,
+	.proc_write_buf	= psi_cpu_write,
 	.proc_poll	= psi_fop_poll,
 	.proc_release	= psi_fop_release,
 };
@@ -1650,15 +1648,15 @@ static int psi_irq_show(struct seq_file *m, void *v)
 	return psi_show(m, &psi_system, PSI_IRQ);
 }
 
-static ssize_t psi_irq_write(struct file *file, const char __user *user_buf,
-			     size_t nbytes, loff_t *ppos)
+static ssize_t psi_irq_write(struct file *file, char *buf, size_t nbytes,
+			     loff_t *ppos)
 {
-	return psi_write(file, user_buf, nbytes, PSI_IRQ);
+	return psi_write(file, buf, nbytes, PSI_IRQ);
 }
 
 static const struct proc_ops psi_irq_proc_ops = {
 	.proc_show	= psi_irq_show,
-	.proc_write	= psi_irq_write,
+	.proc_write_buf	= psi_irq_write,
 	.proc_poll	= psi_fop_poll,
 	.proc_release	= psi_fop_release,
 };

-- 
2.53.0


