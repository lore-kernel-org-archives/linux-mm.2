Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0584607352A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SusEQFRX
Received: by kanga.kvack.org (Postfix)
	id B47C86B05C8; Wed,  4 Nov 2026 14:43:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1FE26B05CE; Wed,  4 Nov 2026 14:43:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EDAE6B05D0; Wed,  4 Nov 2026 14:43:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F0C86B05C8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:43:28 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FFAAA64C7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:43:28 +0000 (UTC)
X-FDA: 85398460896.13.D329D3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4000440003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:43:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SusEQFRX;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821406;
	b=LsKKafITMPZxJLjC9MJv/TiSYZKufQ6sA66OHedyB6i9vDcJgJ8jCQs7jzOeSKGheWR29p
	pUaMjcWa0O7nmF+8n2/E7Nn9hC3EL8f/xVsoMhkURSv0563nNs8OYBGWEhkisDqAk9n/lw
	1PxKhfuwSngxaP6nbiGZ1IAzZFXXQ1g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SusEQFRX;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Veri64uIgSpvDnn8LOw8Zp4yMSBZFCckYlFRYYQC2Vw=;
	b=6xC0K0UimFSLY33pUWHBhdRA4Yun4+PPpLep8ZQ8kYHkQSaSUYJJUIKlinhCNG2zCdgdDc
	KQ5e0ctsc9No5q87zn4bXdklw/8JWtYQhOaTNp0qMU4EGy4dO11s5u98zlW5Jxj67gNJao
	DM9M10s3JTcNoewD6WCOOeSNTGb+VFY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBC1960EFA;
	Wed,  4 Nov 2026 19:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6561F1F000C1;
	Wed,  4 Nov 2026 19:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821405;
	bh=Veri64uIgSpvDnn8LOw8Zp4yMSBZFCckYlFRYYQC2Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SusEQFRX0vw00hvdflsRFt4PdmrzgmGzhuUGY+Rl3VnhWNBf9hDomdph1bbV0F8YD
	 /dCAYJhqS+MxZGuEFhMqoCKGxoVbNjBfabzq287i+cKDNtU8pg4W1SVc1GRk6DBVXt
	 3A+QcfkxH6hyhy0K4QTMOeX42qB7Nx5dwHLbBtihrIDS9uJHsRW2OnODxddayGpgPm
	 rFI3vYy6V9qWvpH3sT0FL5q1c9mQH3+TpkhRf0GW6ZchNR1bazcOQ86K/l5/HEgCzN
	 T/Ch/TUPZ0qqMdy6fO0LWFN5yzZLB4RRivSIYxPK8aIOEmXpZE3jTdEOFQMZUCGw6q
	 0wH0f/TZnjGfQ==
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
Subject: [PATCH RESEND v2 04/26] PCI/proc: let procfs copy out config space reads
Date: Wed,  4 Nov 2026 20:43:11 +0100
Message-ID: <20261104-work-procfs-drivers-v2-4-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3228; i=brauner@kernel.org; h=from:subject:message-id; bh=jf9xs+FhfBfS3vas7oIWufWfAbP2hJLFKyaoEXyHsWk=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97qpw3WZuPMmzd+/cU6veZXP0/fl7uP4DT+TNmE93Z qU6pl7911HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRlc8ZGZ5OS1D6xS/6MK30 z2qjpysyUk/pmdocFd+pL/M6x8MkqpThf+i2B9puJe4mcxcX7OJ8w14/ub53b/aCHp9Irvn7HsX X8QAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cghj8di3i4189ccoguwshg4qgiu3tdme
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4000440003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793821406-286551
X-HE-Meta: U2FsdGVkX1+JjJkRW9A8udTn27WOZoHb/oc1v2lLDtJPE8ZvaPoOQRWbG/o70coPav8V+6P7JLPkrb/E+Q1YN9cWHa3VFZA50S30PkupE9NB+nUa9C0cEa2pmFQBbkmkvM+pGo3JrGiQ0iVIf8q9V1rtbWPLqxRmFCrVQuAV63QBnn8IGnMb64rFhR3OvN0us7OKUsLqFSzR/RtMn2xShAmRVY2lQg0m+eML0p9pgZSfi0c1q5HpyyokYkGTgJ3Vap9m49mnAmOj1rvmgOoMzW6WIeQYXXaAcJrq19WwVhgVZ+BNm4uD1LbuwzDxrUNF+Ig+/S1M1o8AgUsByt+Pb0lAgrdqS2AqIqQkQ/xmHS1YhetTHx133Le6kZSa1uuTUKVHXCRcQ9hOFYWPsxd4qqyb1KpwIuT/LhfnXds66oYbcsz3xoNHoeuj+eDC6stA1OOSV62W1YPmND45yVsWkSEfeaPmlh1EpJSvJMPnRs6LIhE+Tysno+2BAaRLnVlWXm5JVtEiRT0Ml+A4ZZoAqLMVsiphmCou6F/QBYfn0HQv1qjaI63sZDbkeFG3PrRDX6ZaivK5GO8/2OO3CKiJLJ5JbMOXkrl+Tvbdeo18JUT3HXHtvKGH9SpL70D/xQHih9kJwSDbXhvSdBIKUo05Z4KUt6uWHiTFPLlbdTq44FNDPOLoCn1bobF6cwzvDQ7lJ+xoVxV+hXWj8uYZkbibApWpg7Wgw757kVsMNKEbXOWg7h7M7rWe4hRTWe/Tu1H0vdQjCkY8r7R7RMAvB7vumiMgFu/AeSrwpgwJ8bQ37bWifnnLvZmes+6SAqQHSwN5rzJwv9Hv0gnqRIkoyrbEPf4PYirafl23Br79M52H1wHgkSFnE2igNh677snOH/Mkwq9yHTtyQtnXHNJnPZG6TZc4CCUOex2vWkq9lCtvM9LCJQyzJIghQbb9wYirBkfwPWIk41CGwF+KGVpR8V1
 Mx5wXiei
 QY/O1Kiv5kxZVZFs+1W2zUk75j8qPAHkXzS2Ao838HLonP6ESBov7hfH3f5xd2o84ACVY3jdnZuUrcmxjWFAQcug8jud8B9XfsNzkFJBx/3vuHgR+M1pSGhvZJkxFrdgTEfU4k2MXM8xSVmdFiTW6ipCm3p0sd7DN+PYW/JlhxJWdFTHGE3p19sBk+LwPnHG77zEu2e9hz0C2JASO1Krx/l0lpez0+g5uBnqlDqoWnKArxL3KatdPiy6f7ZzEgEMMlyv2fB0a4nYdIL1ZVehY4u0AGvMXK5v3EDIKSq8OgGSVorT2ybgZ8/SV8uA2VRAb2plHtIMTrRh78TFNApnikBGyA41CLGZvGvzzCUExKeEIgHx0AtM+E+cBomBrfK0+XOXifXkFshqZAYWJg9FnkNlbDA==
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


