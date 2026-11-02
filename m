Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A69B5608F393
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eoCb1xon
Received: by kanga.kvack.org (Postfix)
	id BB45D6B05F7; Mon,  2 Nov 2026 10:11:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64B26B05F8; Mon,  2 Nov 2026 10:11:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A53DF6B05F9; Mon,  2 Nov 2026 10:11:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 813E36B05F7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:11:51 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20DE1A0125
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:11:51 +0000 (UTC)
X-FDA: 85390518822.03.0992D3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 519B9180004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:11:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eoCb1xon;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/r9Fhg2Z0/w3CqoKnG0DKCxv08Z9PpiFGMKT+radK4=;
	b=xsXzfWdaldZHDpHDQOvYkCQ5WcwsqVy7pam8yXAsRJ51qHe8de6hGtAAqlTis6lPiNgxd4
	+G1em9sHE37f+i4k+GDQSDFdk31Ap4LfK/tfbYVj2WLbtFAbiQl/EqJmTc/htdpcvmcIF1
	mchoXtFI4mk/CJvowoHqeLFQk4n0duY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eoCb1xon;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632309;
	b=6kXlyTrkZp0kKmuWmQZ7xaLZj9KpLLbJq7q9ffHP4RiRwh5JNNDBYDUNQ7R76t8Uhl3/JW
	F71nnlM+zCKhK+bEJXIW6tOR2Z+vYm5zXVg8eyLO2k4HNj5Wu8M8izEiN7+SUkxCsUEIX+
	AiUPu9JvcVjroY+NodJ6irbf+0lowiE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 905ED4396E;
	Mon,  2 Nov 2026 15:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834C51F00A1A;
	Mon,  2 Nov 2026 15:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632308;
	bh=Q/r9Fhg2Z0/w3CqoKnG0DKCxv08Z9PpiFGMKT+radK4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eoCb1xonaSPckn24MdF4TgpzPnhB0gLnhwB3+q7VZZ4/VwLP7qSPXNuTMQ/2dNldh
	 eVFE9vGUSsn5YYaxGqoLLphvtZLuTJd+KylQIE7mCxvO73SPam6GZq8mc3b9CVyDie
	 3exBK5rK2UuFrqmUvsRYmGiv0WPcd+dv1jT5VIdTEL0j46lSeijrTe4sxEh10rR5bK
	 zOsOn6lvifS4MnTOAh0Y2SzLal5mx1R7DipSgL85s9IzFy3jc8hi6gaFxlmb2VYUgw
	 Yg+IrbZgj5ldjUEp69Bi1JJ+66r8wybqWUuSMQZmJ6kfSVqJ9+zpEm7bXhkzV6eqzB
	 WMso6y2HpsKNQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:12 +0100
Subject: [PATCH RFC 05/23] PCI/proc: let procfs handle the ioctls
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-5-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2106; i=brauner@kernel.org;
 h=from:subject:message-id; bh=2F6i7ISm6IP0WfraLShTjEfHw8rrOdRgm90gAFJMkQE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG6wz+y23KkZj6QTN7spL27IM+Bm2tTyUNrgV7+Tr
 M+uN3Y9HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMJymT477j82eGua2tPP5/u
 /iU1KyGvJs8tjK3vYeGHHaWzRJ14ZzH8U7obxHZv93mOC8mXehiflUxYs0bd3NzPJcDnTdn/mMJ
 9vAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 519B9180004
X-Stat-Signature: uiaqhwjpyacseyg5w5umnpamci547p68
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793632309-667639
X-HE-Meta: U2FsdGVkX1+fwM/dLL7PBmRQbEeB1SOT8ki/AgEK1AkSZbXx7ObKr+09Y7XVo3Pv86urpv5Y4Ei0BBfClqiWEcetEXLsc4kGdfSnoABmie96cmVNKGDzhLi6HSEN3+x3mLF++/eNNG4zZa2kXotBLRIrzFjDzOtoGsemzyXzY7hK6PLDCNE9t/B14Wike4S1JwXrFDT6ue1keY20oRW3sdhsqWNMh2uoOtHaGIrnchqXBgYn7qZFj0RZem23OIlYSBJnVqN6HELOwpf1jTbUEhfjIoOnwTz4QZ1V4kih1mBywGXIkZ05OnaLpG/f/f39H23UtLbmJ0offdS9kn7LGR2v6oZM+O3J8loJhO5x7jRAf4jN7us5Ei7/JwML4HFYKejRHC67GeEr5i8aL9Pa9u7ONJYXjnL0Lsfrln7g5ZemgqGtFBsejERqt/fhRzjZRk7U849nDs9dlxGpLZJx5tddiLPnvEGdrelIdhXd8T08cfYTQlXx3pTmV3ni7FpzNiXI/CqPYXmxVXhhwJzynTen1GbFTrYTQVGKM0QyAxFrG2rsAKJYfrrKZuOXqrwWw4vFVS5Ftkz5zBaLyFsKOVdel0At5xp+JjlezoMghSw+DD/WzO9VBFS9lb+pMHfCDCKILvJRh/EzxWQYqwufpCG1MMvzZqXhAQj35PJZ+79pdRWsA1jXwJwRChjatN8iVZqiWW5UMtVuxb5doQIpsmzAVXbhlo0xkLGu6a028WCyVcAql1ZjvNGYuQeqVvMhlS3tLZazXvRHiNepe3LpxDnAb10tGoX5yAri6PQNyEjWbZYi/98RkW7RuI9+/07TfQFMZDj239FwnyoOKzU5yPv17KeCJWIHD7X5dRzcd8TbXYlyifOA26ytH7HrRjq8QO2geFqfE9+KMC3nFdSByr2Zj9iu87yH9ohWZS1ibYm6x8gHHyjJIXy0XD9zKvG5Xqz249ygHHg0KNNH9zz
 dA3ZoAZG
 jycJts6rLk2PghMExeXb8CLWLdSKgCRpMj9t+8gh7WsEr0mj/AZKZSRevAHpHKpFkHv2QqqB35hO5ReEj3HONcwJK6p5b/ZyM1Hlgf7hCq7QG/yeL9L2gHriTOjUgbeHQ3Zfnua1iVgqp7GzaClAvNmwu/1PS7dcYkovbI/RiLtZdKq4JFmLilS3kk2yUOpCS97rlsvwiP0w8ehjoAD3kcOYP5Infn1O9ze+rgnXbseE767gZlxhJH/fCHu0dN+raCeGqppDtC6Dv798SS49apcGCUtTaNmXtCzrX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The PCIIOC_* commands take and return plain values and don't touch
userspace memory. Implement ->proc_ioctl_buf() and list them with
nothing to copy. 32-bit tasks go through the same table, so the compat
hook goes away. Unknown commands fail with -ENOTTY from procfs now
instead of -EINVAL, and instead of -EPERM under lockdown, since they
never reach the handler.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/pci/proc.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index a8d7469f222b..6b0cb5bcbea3 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -192,8 +192,7 @@ struct pci_filp_private {
 };
 #endif /* HAVE_PCI_MMAP */
 
-static long proc_bus_pci_ioctl(struct file *file, unsigned int cmd,
-			       unsigned long arg)
+static long proc_bus_pci_ioctl(struct file *file, unsigned int cmd, void *arg)
 {
 	struct pci_dev *dev = pde_data(file_inode(file));
 #ifdef HAVE_PCI_MMAP
@@ -321,16 +320,23 @@ static int proc_bus_pci_release(struct inode *inode, struct file *file)
 }
 #endif /* HAVE_PCI_MMAP */
 
+/* The commands take and return plain values. */
+static const struct proc_ioctl_arg proc_bus_pci_ioctl_args[] = {
+	PROC_IOCTL_ARG(PCIIOC_CONTROLLER, 0, 0),
+	PROC_IOCTL_ARG(PCIIOC_MMAP_IS_IO, 0, 0),
+	PROC_IOCTL_ARG(PCIIOC_MMAP_IS_MEM, 0, 0),
+	PROC_IOCTL_ARG(PCIIOC_WRITE_COMBINE, 0, 0),
+};
+
 static const struct proc_ops proc_bus_pci_ops = {
 	.proc_flags	= PROC_ENTRY_SHORT_WRITES,
 	.proc_lseek	= proc_bus_pci_lseek,
 	.proc_read_buf	= proc_bus_pci_read,
 	.proc_write_buf	= proc_bus_pci_write,
 	.proc_write_size = PCI_CFG_SPACE_EXP_SIZE,
-	.proc_ioctl	= proc_bus_pci_ioctl,
-#ifdef CONFIG_COMPAT
-	.proc_compat_ioctl = proc_bus_pci_ioctl,
-#endif
+	.proc_ioctl_buf	= proc_bus_pci_ioctl,
+	.proc_ioctl_args = proc_bus_pci_ioctl_args,
+	.proc_nr_ioctl_args = ARRAY_SIZE(proc_bus_pci_ioctl_args),
 #ifdef HAVE_PCI_MMAP
 	.proc_open	= proc_bus_pci_open,
 	.proc_release	= proc_bus_pci_release,

-- 
2.53.0


