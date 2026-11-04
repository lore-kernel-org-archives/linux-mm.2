Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC37F606C58C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E4RqvCC3
Received: by kanga.kvack.org (Postfix)
	id EDAB46B05D0; Wed,  4 Nov 2026 14:52:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1856B05D4; Wed,  4 Nov 2026 14:52:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC82A6B05D9; Wed,  4 Nov 2026 14:52:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA0D66B05D0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:52:23 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 587ADA07FC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:52:23 +0000 (UTC)
X-FDA: 85398483366.01.D164885
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id AAF0240004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:52:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E4RqvCC3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cbUv3n1tBnI1k6VxTZ3ZcHd/CVUe8/cnvkVP6mlO6Yc=;
	b=y61iPu+XSFlVt5IY84POEi3xJFxbmaHt2xVc+y4NFPb3J+WVv+8yDZh0uVqOElDYayE0sw
	2LfVtu2RUYBzHXVdRSP8QXE4NmRN/MfbnqsT7Ge7MdxbcKMcIpjmlWXiC2YqQ1guXlZWHB
	aUaMeoN5CO1QIUFqUEhTWNLaKh/HdpU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821941;
	b=lthh1tiiYf32KJrIjL2HGnViR2B96w6FD2CRL0mwww1+423qyOWsjAThs5NLX4R8bGspwD
	nKBspJnDXSNbDbqCzXxplxapbEXRz5K3JOFHFZpcJAnNjXqfuEVfTUVqQ99ns8neqheCgg
	7VKMK5vxsJyw0LtdkTn37C1r55g2nAQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E4RqvCC3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 28B1760D99;
	Wed,  4 Nov 2026 19:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F8E1F00919;
	Wed,  4 Nov 2026 19:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821940;
	bh=cbUv3n1tBnI1k6VxTZ3ZcHd/CVUe8/cnvkVP6mlO6Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E4RqvCC33TjJz3vsdxt6gVY1KKu7vjxv4xFkRitk2vuws+TlWcgf7WMt9M4i+MGOG
	 5RqBFuiDLeSXKpam105hMVUy3rhZtAy4+MdMi+B7rIZnwUE4pEJ3q3s5wEaYNPAvME
	 KGEwRiAVWj2XYJWhDQNc2XFGUB4R7PXjlOfMJ1Wd48dn4EheS4oMJIcqJ7f5JQYPgB
	 TSPocNG2UWf2+B18aoxxNlwBlUst0KSwQJOkoIQQZUfrJ7zcLgoYvoDopw5KBBJBn/
	 8DxYWNnsXOWVRZ4gVxW8YDBrz4dlklthAuCncsHXYWBPclGriCH6RWHTj0lVCLeuJN
	 1w/HFHcR3YoYQ==
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
Subject: [PATCH RESEND v2 10/30] genirq/proc: let procfs copy in the affinity masks
Date: Wed,  4 Nov 2026 20:52:06 +0100
Message-ID: <20261104-work-procfs-fs-v2-10-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3770; i=brauner@kernel.org; h=from:subject:message-id; bh=WZPzG5+ElQbjbcTuZJJKbql/hLS5VpybW+Y2WsbSVy8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97jFTOsnPsPqVcfq0tE/cqcL/tgpv8fLebHHL7+Kde 1dYK5Ofd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExEejPDf4d249cV1q+X8Xi5 lzKEZHld3P2sJ++tcMq/aU/+3/3eHMjwvy5Y6WGkzT+rx1e/T7mY5upvvFxP0ovZMPeTMvtUxrP urAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t7tyjpq7judanj5d7awn1qhufd64ib3m
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AAF0240004
X-HE-Tag: 1793821941-717870
X-HE-Meta: U2FsdGVkX1+QIjPql8G7YDcWMyJq8B7tOfFDehYMLbnXIXaHmSumx/xYwy4AOrhrAIa6+Gy0yNN3JW/4WTDJj6cL6ptYXFKMoodlWlI0COLV0kVz8lfndnJuE0haK29sJojlJ0/6OblxW/JNDxUxKK9aygbloKyydMzaIyI2hEjEoTO+n1YIsIysNwG5jR3GfhalcJU6VqvfUkLkaORYazC49wYTYWbbmmngNwm9/ZSQ7ddqS2uW1TWEP2F2pVcU1OJAtv0ASlZQOuNM+yqMQnce0sDxTToOeYAg2nWQohKKyL4Dugs5CD/PXahCARkyZDw+LZS1wJ0cWeTAIb7SlHX/IYJkVKxecehHYde7T2Zp6MnP/k8Q/7NUshK82FriJA5db9mTjBBLglMZV/JjQsSFe1Rl6dCHRTz56yUVmqbMfOxQ48459jcn/t1Xb7qPvB5i42YO/aOYDSYphR3b2CcfHfSsHIehjCB8kTK+Z8wtuOuOjOc75ExQQNpmnYRBBuoJB16M4WCg3+QcmpAzipq/+YyELbSAuag11eilTj2J/qLqFPL/IHMS/NspaXUSEhTBIR9dKjeJyWdLrpXuyWKuDzEUIFMe0UiInu1D1N38YmHBVObQp1d8NrfM0yhJdzX461oznEwXfntnqaWYwBpM+33M9J8cdWgEg0pyV71NT5NRT08sLk1L0QwgIVSyCDcK7/jXyQWRnJ7GMH9iVumDfBlUnVAn2mQtElc/PCQvdjDdFXwTyFs9AaFtdSwsLMwopH3xzUinZfHvSuS2CL3seHcn2MggpQPDigaWcHjlfpmc/Q+EHPOGsuikpO/asBc1Hyg3PcFQDLMN11aHIoqZQj5nm9SZItQJRn8mOF/GvF1gUzCl3H4xNIwSIC4fiHYUnOt2OK0OyCEBh9aUduu2/gVTHyh43HThbyBJ41r3/Fl61j/Xsa3nSqGacuyO9qXCV5mrBf4OcjIdTFH
 S5qn7Ii6
 hgyCyXYas4MaKPfsCziUaJtsQsw0QI2o3elkNs15egkaAqZjQE56e1rBaAo/Oo488HhjB5mNmBjmq+9BC56BJGiBsnxmkEbpXzil0uANt9lWJL2N4rjOpfoeIpu0zxoCKlGqQbt6ce+Kg0JqSa3e+EgDT5IrkufIKT5mIQmklQlp9Q+LKPfEAf959lsJIgdbj7jzaPMbPRYzUbnABKAhmuSAVRd2jpD7PWeOKOL0Q6Vu+QaWpHuTfVmX0y1ELV+EsqLFBteMwXYw/9P127HpdBsPtKv3H9x8a9uey166H8BiXpqYecY2Q8o9+Pkr9z9sjeyDvpJy9ALlFyWv6FIVJ46ZsXJDDFNXifPtt/DR79Ni89Rg1J0oSeTliL9N08WWzs8b5gIHaagkb02B8JbaPlLfwKnI3Kit00iJMOReN4wS/rEtLylIyBusRvQ==
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


