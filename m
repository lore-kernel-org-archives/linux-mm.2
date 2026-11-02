Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5756C6076738
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PyH2KrOv
Received: by kanga.kvack.org (Postfix)
	id 684CB6B05F5; Mon,  2 Nov 2026 10:11:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634EC6B05F6; Mon,  2 Nov 2026 10:11:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 523FD6B05F7; Mon,  2 Nov 2026 10:11:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BAE26B05F5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:11:34 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2030A6571
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:11:33 +0000 (UTC)
X-FDA: 85390518066.14.1C21CFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C63D9160003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:11:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PyH2KrOv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Veri64uIgSpvDnn8LOw8Zp4yMSBZFCckYlFRYYQC2Vw=;
	b=NrN0jxE/EXXahFNYKPoX3j917Dqiv7sZsUCqZXyb7uxkd2qHU0cdRbM1KZ9HuFbt9ejjrl
	nJwlLFa3WFVpU36k4NMbwAuOXqDSVBcT23KDanSIOF6z6HG3nquEfKm9u7fZ/NEBvLisd9
	whMvsmBdaC7GR63THPYAczImRC9BenA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PyH2KrOv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632291;
	b=lRz5jBL+tvjyIvnJH8YBHZ1JvriuoI4ilu52A2HTKhvLZEdzA9AVwMX6M2D5CPHpDfTTut
	NNSBRaU7jKWWCis3zmueYQHNoPNYexZlZy3oP/bS8fMOv4Wbx1Lfq729MM5+SHycsC+c85
	vI/gQwShN6PcGsN2NrYjDegUwi8avsU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F33BF42002;
	Mon,  2 Nov 2026 15:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768981F00A18;
	Mon,  2 Nov 2026 15:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632290;
	bh=Veri64uIgSpvDnn8LOw8Zp4yMSBZFCckYlFRYYQC2Vw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PyH2KrOvZD+BL9zUl6AU8BXeJKg3ikWP80JWS5gYZgMQV/kTMBB7CrV1pMxIJKL4f
	 ztIp9wftXZwnWLrgNLehHtxksIhWl4dHOxqRJBldIuhEhovhTDw55IVzZ9TROxDjjW
	 XA3pUmsiO+q6HP7XdahCpcrGPElFCvPN3654lH68oxzD+xgivEgvKHiEVuaV9AbVh7
	 gyekICA6wkoIzDKxIYuvGIz/7JyEv4UkOBjueUDWmWdaMOfSLMFTmp8c9Hk+Fh9e52
	 reAWSbDO2KsmTnQ5LN9feY66XkFi20tGnzFSkSmvDBITpiXfojEd7sdGjrZi3hZ2oI
	 HUDwrYxyBrmbQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:11 +0100
Subject: [PATCH RFC 04/23] PCI/proc: let procfs copy out config space reads
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-4-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3228; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jf9xs+FhfBfS3vas7oIWufWfAbP2hJLFKyaoEXyHsWk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG5wN0zQ9uaOcyyafDNO7BVlT6yIqtn0O/D5wm0tX
 HyZC1w2dpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExk/wWGv/JrO7p2sJvf/nju
 4TeP5aUBLptarsV2/Ve9+3Wq/HwZljUM/2OVDpj3tT+a1faKoWnzHc6CF5vXOViwS7hZp5smJdi
 asAIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: C63D9160003
X-Stat-Signature: tq95gsz1t4gkytr3um849fb9rsx9jruu
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793632291-58153
X-HE-Meta: U2FsdGVkX18FkhVaguozrHVEeyptd4EBF0oOY43s7AbMwMnJz62rSxBEA2O2RrlMv+0kRxKMUBIBME3HaKjjCKNNqIPwbqf6JSqDbzBDMh0oSOhWsHHcp5Q9FXhrJPADIvOyEk/uh9OGqaGlJNMsrQ9egt5GRSHkMzllo9jboaAGnEA8h3TNjPSrPhuEa7jAYLBfPmEYW5Lon5UnWX/JHG0B02D5ADa2AKsuB6rf1p9bPjXmQenPn+P9hh/H9MjZ//NRZeXg6QtUgkqXz9R6oLnahoEhmZJw1mO56H35PvEjsV8xmzmHgyzyOgcHD5YoqCvp4PZyjEtYPqNTXe70eQJo4Ca4s6L9drQ5ksbia2YiauGJ2HZNVNxaveo0CbHqR7p1Jy6ylX7hXr9Ltq+EcPGBPc2ij+teEZVxecfJVXADK1b+/kskCg94AYcaWih6YcK8cSXK/Zn8RgNnB3Twid5bAU4WfigDjY2gRN9GRcccaZOtPBiMM8knCmx3UcxDptPCtHjbns25dMS4tGhnl2y8V+RyO2KuPm0Dq9qBjTxFTicIVaCI0aRcFrsNOIUGdaokdxvwaE1UZTWUwK7Wrp4bTBQp5Hn5hOGxpeblnxa98llCH71a/FUiosTeFK77VWpa44bUD7uHCipTu1nOqzZZWHFHdiaPtzEWIXO2thFEFeMw5bRidhhNdFNIHGsPsQNxiwMwRowi8UrAg/teqrv8ZI2YLtFiPZr5CORw/7YdQh/f59KXmcwvCnrDpiUGMnBfqK5uWzCsNcEhJouv0gAUQQVD61Wp42UxqCFyL/1oQBTlOePngFxQSQm2knhybEsoWvvyTtLHMAaF+9BJMWitO+YUZo1ScM35IhP3E5cz5uXWQzyh0elpK/QiNSDzOIDUHi0QJiuEMO+x+KvkiTKLG3IN2dKjIHsJbju7ZacrX+NxpNtLzlHMGCW6OnFIjdJj7T7U0TH7F0ov+AD
 rx4BC3vs
 tbo6wkPUQrygeUWnnY9s/yyD5Ee+DQo4InIiMz8kRvdu+KqzdEIODV+qmTSo62bF0fHiIXHqZnBjT/HSpoV9ZdGNWeEWUsVCXIUsmTDhMa1kF07z3h7/G62d4VbC6Ea+Ss+8J1+uzhJ7aVMmCSlumUCbbYBPfYv9ND6mEwsG4GnYnaC6GPun9wg2c+1riXRuZrQ2r+aAwhaWLS7k6dLalz3XXrkE7oa8sTOkCHpBvYr1uVSr6CmeiloKEBQK6Vib7IZGHjxKsP0JUlcEw4Eajwojyf9QRujNwt6gT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read to userspace
after it unpinned the entry, and read the config space into procfs'
buffer with put_unaligned_le16() and put_unaligned_le32() instead of
put_user(). A read into a buffer that can't be written used to report
success. It fails with -EFAULT now. A page holds all of the config
space, so a single read of it still works, libpci treats a short read as
an error.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/pci/proc.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index d420353ee2b3..a8d7469f222b 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -29,8 +29,8 @@ static loff_t proc_bus_pci_lseek(struct file *file, loff_t off, int whence)
 	return fixed_size_llseek(file, off, whence, dev->cfg_size);
 }
 
-static ssize_t proc_bus_pci_read(struct file *file, char __user *buf,
-				 size_t nbytes, loff_t *ppos)
+static ssize_t proc_bus_pci_read(struct file *file, char *buf, size_t nbytes,
+				 loff_t *ppos)
 {
 	struct pci_dev *dev = pde_data(file_inode(file));
 	unsigned int pos, cnt, size;
@@ -60,15 +60,12 @@ static ssize_t proc_bus_pci_read(struct file *file, char __user *buf,
 		nbytes = size - pos;
 	cnt = nbytes;
 
-	if (!access_ok(buf, cnt))
-		return -EINVAL;
-
 	pci_config_pm_runtime_get(dev);
 
 	if ((pos & 1) && cnt) {
 		unsigned char val;
 		pci_user_read_config_byte(dev, pos, &val);
-		put_user(val, buf);
+		*buf = val;
 		buf++;
 		pos++;
 		cnt--;
@@ -77,7 +74,7 @@ static ssize_t proc_bus_pci_read(struct file *file, char __user *buf,
 	if ((pos & 3) && cnt > 2) {
 		unsigned short val;
 		pci_user_read_config_word(dev, pos, &val);
-		put_user(cpu_to_le16(val), (__le16 __user *) buf);
+		put_unaligned_le16(val, buf);
 		buf += 2;
 		pos += 2;
 		cnt -= 2;
@@ -86,7 +83,7 @@ static ssize_t proc_bus_pci_read(struct file *file, char __user *buf,
 	while (cnt >= 4) {
 		unsigned int val;
 		pci_user_read_config_dword(dev, pos, &val);
-		put_user(cpu_to_le32(val), (__le32 __user *) buf);
+		put_unaligned_le32(val, buf);
 		buf += 4;
 		pos += 4;
 		cnt -= 4;
@@ -96,7 +93,7 @@ static ssize_t proc_bus_pci_read(struct file *file, char __user *buf,
 	if (cnt >= 2) {
 		unsigned short val;
 		pci_user_read_config_word(dev, pos, &val);
-		put_user(cpu_to_le16(val), (__le16 __user *) buf);
+		put_unaligned_le16(val, buf);
 		buf += 2;
 		pos += 2;
 		cnt -= 2;
@@ -105,7 +102,7 @@ static ssize_t proc_bus_pci_read(struct file *file, char __user *buf,
 	if (cnt) {
 		unsigned char val;
 		pci_user_read_config_byte(dev, pos, &val);
-		put_user(val, buf);
+		*buf = val;
 		pos++;
 	}
 
@@ -327,7 +324,7 @@ static int proc_bus_pci_release(struct inode *inode, struct file *file)
 static const struct proc_ops proc_bus_pci_ops = {
 	.proc_flags	= PROC_ENTRY_SHORT_WRITES,
 	.proc_lseek	= proc_bus_pci_lseek,
-	.proc_read	= proc_bus_pci_read,
+	.proc_read_buf	= proc_bus_pci_read,
 	.proc_write_buf	= proc_bus_pci_write,
 	.proc_write_size = PCI_CFG_SPACE_EXP_SIZE,
 	.proc_ioctl	= proc_bus_pci_ioctl,

-- 
2.53.0


