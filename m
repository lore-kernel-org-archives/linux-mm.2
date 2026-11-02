Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFE5760A6EEA
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gtwKUokO
Received: by kanga.kvack.org (Postfix)
	id 206BC6B061B; Mon,  2 Nov 2026 10:23:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DDF76B061C; Mon,  2 Nov 2026 10:23:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F4936B061D; Mon,  2 Nov 2026 10:23:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3B0D6B061B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:23:14 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8678F140193
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:23:14 +0000 (UTC)
X-FDA: 85390547508.13.D1E74AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9CE8B1C0009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:23:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gtwKUokO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cbUv3n1tBnI1k6VxTZ3ZcHd/CVUe8/cnvkVP6mlO6Yc=;
	b=ptAIa54zIdc6mRYXzojlid6ZheWeOMAzTeDGfAdCsoSfN2bhf9ckwEQbpfoCX+6LSjJdgW
	LFicOyTtUr+Jx96Z8YuWrJ8whJZQLKFGK1sTnAS+fkvzQc3jQC0cdu+kwokrETPs14zuDQ
	2D3I/S1sKlxGye9zjBjlSI1+C+2tQAw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gtwKUokO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632992;
	b=YazxPRlql5DAuZWoSe6/tQQ8sLKGRRd2zPhuoevVYysHedV+xIVJfNeS8yIbVGHC80Uwgs
	BUg6lRYPiucx1nkykij1HiRGOKQKBSMeAmg1TJdKiX9NdX+aBGirn5Uta2veeIy4szLHwU
	Y/LKjrPV2IyXdF5uL1c+Cs9QnHSHsWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E368343BCF;
	Mon,  2 Nov 2026 15:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB961F00A16;
	Mon,  2 Nov 2026 15:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632991;
	bh=cbUv3n1tBnI1k6VxTZ3ZcHd/CVUe8/cnvkVP6mlO6Yc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gtwKUokOODP26lfp4y7mSUu6DYdG/zt2FxgYuDS+oho+JQ5cga5uqjc8YY6VgrcQs
	 VTaytOyGE9Q36HAhmeQO/tpkWrmaem5nfcs9DoO11v1we3+YYyPqsUjQ0RtzlSJ/r7
	 PjD7PtqydOyrhI0RMb58/TQgdn/JW1bEao0zBiP6y+8iVzXby6r+qrPSMfF1VCtR3o
	 f+fxAzOWnAKXVVQlIcMAzpg04hv/Asv4XFoEe0YrkCVsCJLh0AlwObscrypUo3bOUD
	 I88qZEPZKE9AXxN0jtQQ7Cv/rHCklqSSX1h/8YUYGnUDPn7pa9hj9iyObikXEB/IoK
	 IjWpl3b9MOeCg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:20 +0100
Subject: [PATCH RFC 10/27] genirq/proc: let procfs copy in the affinity
 masks
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-10-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
In-Reply-To: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3770; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WZPzG5+ElQbjbcTuZJJKbql/hLS5VpybW+Y2WsbSVy8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG6Uyh8z/eu1hrs32SIFLvZ8+rqj2fax/9rr51N3L
 TzROveFV0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBE5soyMtz79dy2qTFnUlGi
 7Rv7nTPlZCfr1j9uiJscE3tp0bIdbPYM/10MrwvWc26+27EhfVkc7w0pUx3fZeee9Fxveua24pn
 WK1YA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 9CE8B1C0009
X-Stat-Signature: no89qjwbwp8hrzk59x73zc3rs7e5643y
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793632992-744690
X-HE-Meta: U2FsdGVkX18IOzd5YRlqa4h6A/Bo6afCLMz7+uxMz/Wkx5q5DtdaJ4xeoRI7ddPWYqYyfgXfhoTSzTe6tzS6nrnFxVaGiJ2imfaOuoTvuuk1o7MVvYOKITdX0LKorMKh3V1Iv5nur/+Z0P5qd5l9ymmo3JSErDiWvDNGVFPd+MbKBc9CxyCRKUROolxomRvsC9O5PU0kTeCYFDqCABFlVSx6iOOwuTIDbldmOsi1hbluKZV3OCUV7lLCH1VXwY/GC/UdLgie9ZnBTu0TK74MOX2sTDdH550JxUuwvO51onXiUTNHYLD7zra4ZqtTAMcNfrOBBZKBk+5Huya2JODsbi3YN5sPy7FmSK1YcV0l+2Lnqkmy2Q5/aR0j2t282f2VMkP0KYqnxRAmVhvD6XA8sZAvrkgesQ1KknYMm7aiyGWyTytSyE1Mf/pFuCChW2G3WBHobZKq7Mpj1t/eTXLsOOYorxwnhRh1v5LHNxb36IzUxsLSfSkdZfWrKmGiWJtPp57iU2fzwCFhgC7iOoGXEOchIVjNAW+fmeT1InUMNVqOvjtYYeKPrxQLn4BRwIZ10MtOXM0+GFYc87nMCmp5gtT5Br3DWQ4zw5kMJuqnjiDW/CDlWLuMuon7MeuPhYI7gd/5IU3ub4PDyHa8atbwaA/3EraFszzMIIjaAi3jsocVcJroESd/NtwLR3k6F+EGDxjHTjma1/fhJvZWY1dWVKCG4ttLHiWJpaQP5LSIom9tcY5zMkNySgyUW5Jnnt4Fyhbp7EjD7VPXYroV97FGF6w9dcb6vpjLGHBJMGfLZi2r5ZanG8aov7kVMrhVm94KKei+vFEUF6GnTXGwy7Oqh7dTAHEpcikuxMwKz+5mAAtMiWvI/nf7rhUboNewAzxspn02Fq+ZOiXWLSTQrz4IiKdt2iKhLyLOwLUjiiNVv9Sh7/NosQ8qKJUZNcH5mU8nKiPI66WGgi/gL1waiRF
 4yjE7wKH
 xQKmIVrY5OhobtKfdSu5zVInlSp/SgkuR0U03jS+khgJIHsKuBuit9+fTeWMqm2gWFCgqrqDUQJZ4A2yRSXywxKf6JKiO7HZrxsubt5VcPpBpnx9gqOaJMaTTbJVfp0U+tZyigk18NnUFFjoLcydEhQeBYmB3xPAeBe4udwEU300/Racirovnxi0BE8dicG6CANb3qOmOif5/3/qCzy3Y437W4CgsePp3rZZcI7T6WiFJEIwZ06zj2s43/yH3vSH6DzkaodEbr82kwlumcV255ML3yyuqc8WOb1cXuItpwL2Q5Vbjt3p8kFQx5WIwEkwUTR88
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() for smp_affinity, smp_affinity_list and
default_smp_affinity so procfs copies in what is written before it pins
the entry, and parse the masks from that copy. A list of CPUs can be
longer than a page on large machines, so the files take as much as
memdup_user_nul() could copy in before. Anything larger fails with
-EINVAL instead of -ENOMEM.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/irq/proc.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index aa3d5544cfc1..fe683457a088 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -9,6 +9,7 @@
 #include <linux/gfp.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/kernel_stat.h>
@@ -134,8 +135,11 @@ static inline int irq_select_affinity_usr(unsigned int irq)
 }
 #endif
 
+/* lists of CPUs can outgrow a page, take what memdup_user_nul() took */
+#define IRQ_AFFINITY_WRITE_SIZE	(KMALLOC_MAX_SIZE - 1)
+
 static ssize_t write_irq_affinity(int type, struct file *file,
-		const char __user *buffer, size_t count, loff_t *pos)
+		char *buffer, size_t count, loff_t *pos)
 {
 	unsigned int irq = (int)(long)pde_data(file_inode(file));
 	cpumask_var_t new_value;
@@ -148,9 +152,9 @@ static ssize_t write_irq_affinity(int type, struct file *file,
 		return -ENOMEM;
 
 	if (type)
-		err = cpumask_parselist_user(buffer, count, new_value);
+		err = cpulist_parse(buffer, new_value);
 	else
-		err = cpumask_parse_user(buffer, count, new_value);
+		err = cpumask_parse(buffer, new_value);
 	if (err)
 		goto free_cpumask;
 
@@ -177,25 +181,27 @@ free_cpumask:
 }
 
 static ssize_t irq_affinity_proc_write(struct file *file,
-		const char __user *buffer, size_t count, loff_t *pos)
+		char *buffer, size_t count, loff_t *pos)
 {
 	return write_irq_affinity(0, file, buffer, count, pos);
 }
 
 static ssize_t irq_affinity_list_proc_write(struct file *file,
-		const char __user *buffer, size_t count, loff_t *pos)
+		char *buffer, size_t count, loff_t *pos)
 {
 	return write_irq_affinity(1, file, buffer, count, pos);
 }
 
 static const struct proc_ops irq_affinity_proc_ops = {
 	.proc_show	= irq_affinity_proc_show,
-	.proc_write	= irq_affinity_proc_write,
+	.proc_write_buf	= irq_affinity_proc_write,
+	.proc_write_size = IRQ_AFFINITY_WRITE_SIZE,
 };
 
 static const struct proc_ops irq_affinity_list_proc_ops = {
 	.proc_show	= irq_affinity_list_proc_show,
-	.proc_write	= irq_affinity_list_proc_write,
+	.proc_write_buf	= irq_affinity_list_proc_write,
+	.proc_write_size = IRQ_AFFINITY_WRITE_SIZE,
 };
 
 #ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
@@ -217,7 +223,7 @@ static int default_affinity_show(struct seq_file *m, void *v)
 }
 
 static ssize_t default_affinity_write(struct file *file,
-		const char __user *buffer, size_t count, loff_t *ppos)
+		char *buffer, size_t count, loff_t *ppos)
 {
 	cpumask_var_t new_value;
 	int err;
@@ -225,7 +231,7 @@ static ssize_t default_affinity_write(struct file *file,
 	if (!zalloc_cpumask_var(&new_value, GFP_KERNEL))
 		return -ENOMEM;
 
-	err = cpumask_parse_user(buffer, count, new_value);
+	err = cpumask_parse(buffer, new_value);
 	if (err)
 		goto out;
 
@@ -249,7 +255,8 @@ out:
 
 static const struct proc_ops default_affinity_proc_ops = {
 	.proc_show	= default_affinity_show,
-	.proc_write	= default_affinity_write,
+	.proc_write_buf	= default_affinity_write,
+	.proc_write_size = IRQ_AFFINITY_WRITE_SIZE,
 };
 
 static int irq_node_proc_show(struct seq_file *m, void *v)

-- 
2.53.0


