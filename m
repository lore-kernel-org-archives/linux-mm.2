Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE616076FB1
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cxCVzhBy
Received: by kanga.kvack.org (Postfix)
	id CEBC76B05F3; Mon,  2 Nov 2026 10:11:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C751F6B05F4; Mon,  2 Nov 2026 10:11:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8C3A6B05F5; Mon,  2 Nov 2026 10:11:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9653D6B05F3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:11:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40E5A160165
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:11:16 +0000 (UTC)
X-FDA: 85390517352.21.639C95D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 809FC140006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:11:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cxCVzhBy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vqkxnch8qakIwUVP+9QJA5QeGLg7HpbhcDTmIF75pEs=;
	b=xgtiWL91tiAw90kZC4yd8UZ2QU7wVWxqa798qV8r1pSDsCe32eDmanBzwV1vRBVS9tdlU3
	d/S67hRuvy82bRvQ+h3X8msehpY7xMX3lPq21zE86C/WBHI72pyB8JA3Hy2MrqU55aNOxQ
	J5vDQh6//s0XB+lJSsHbloXibKUpyeM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cxCVzhBy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632274;
	b=2T4f+foBB+3mLi6Qhxl0/NslYNTucgxKxOigr08z5R6afnejxmeEriqbFztg/0z+Xe2LR0
	hrVuKDicyBYmpUzzlzEWtlwsfYqHKqyCbPPU/SHJmxTJEinBnqM5uvt1Y6cClb/jVfcS7g
	ZDb08XGeKWBqdWIg6nheY0N59nRfXgI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 182B8609CE;
	Mon,  2 Nov 2026 15:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C151F00A16;
	Mon,  2 Nov 2026 15:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632273;
	bh=vqkxnch8qakIwUVP+9QJA5QeGLg7HpbhcDTmIF75pEs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cxCVzhByWu3o4NPMXdI664xNWkShTHR36O9m/09VZ9+jFA9OG6kKc4h3juX9pF4hG
	 KES/99TyZfxZMZsILDCBbUPiL2m0c7yvku8def0K3xyx1BZSfmHoibrjV4xOJY9TRv
	 aRQUlDzCSvfjdbS81rVindZYNfHG/n3/STb1D5KKMtjDWOzG48TPwOOda5MyUodL1/
	 sl6+1c+KcBwatTkHqiITxDL+ifFRuErDfWC3t7wYwV8vzWLwDTzNDzYcITGLDruDX/
	 CBg0J86Rpsxds6f1vNXAUOdjLXrIDS/33ZjvCLz1gmlcS3YhkDRMkNQrIFMIeovXK6
	 qXYbgPdy439+w==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:10 +0100
Subject: [PATCH RFC 03/23] PCI/proc: let procfs copy in config space writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-3-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3416; i=brauner@kernel.org;
 h=from:subject:message-id; bh=FHhIortRJiKYhZazrarBsz8LKuG1O3uAWYPgQRTjmaQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG4Q5v+r4smER+KNHzUv/1vj6ThP4Dffzpik1rx7S
 Ye2i2bmdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk62VGhs6XkTMTRfwbPBQL
 /x4Lzpj+wfz/1vf3Y5U2mfjmTS4+wc7wz+JImkaMBv+rn36HnuYuOOJ748u9kLuro6932ZoynGx
 15wQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 809FC140006
X-Rspam-User: 
X-Stat-Signature: zdiouct9xxcxts17nbe4cyixxnjhkdg8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793632274-42063
X-HE-Meta: U2FsdGVkX19VuyD/WE6DEpzyGBw+/8kZ0qp+Eeg0zbSI/jpR5WuUbnExxrssypZzlaLZb3wcYrUaDPY5HiNQmkYukvw0dE8+/ldNqSIa2uRCO/AeQuLolavkwoktB6TwkroWcyDrzqjUfWcrh4NU5RVelOnEZFZvbt1p6u67V1L9f4wFMRQ831lX5/Hp3YQRBB8DIgW0AjyIXAewuBfjI6hp3A5o8NGp+MWapSWgv90/0WuaYhhEUGBjPqr+9c0a2LnmN2BCDDBloBMMFtxRj0VwckH2Y8x3rYek4vxtXChiV36tANh7nCgMmH9sW8I3O/7SoAbkg/ddt46GRz7xAv06t+jIhe8Y1POnGF48Zm6ZprJiHjIIwwEYhfHft8L7ukBgdRvtS1c7LClKU5dbRxdIy/TC72XQDNrdbP5+g8r7b6LyV384kDSCUi4qs8ZdNvuUgWgguR4qGQKxHYxLXNobKURrdMsWyNndCeBTAA7eFPsAFcEjdrL4Lnpdr1aSp2drY82N1V8kWth3PZTWQosMNgIqGfMTcZB1ehmYoZbxELadROTOGxzcpu78rDXwvnbX48aYif+6mO/zLEWODDCOWkIpG5hSUG9ueQMMl5az7YdxpwMcUIchdUhtWdI5kjfZRzJ8eCNFtl2aaU6SbB6yO2mxOohsyyTgkH8v4TAXa6T4amTEvC4wJaxfzQ6BRbTiYDfyq9lRsXfIG7+WdSeGxI+q0xTMni03GTIH3OLV1Gje0sSrQ7d1FjAtNzvzZ/LyX632r0eWbiRFmauq6g4SkF4qtCrcPNAuo/yVkW5ezfaznjzNpNPYGMR0X8ePX2haw6JmC7uaTFRiV2fEm5CZkNZHabAnLkG/2RHRvIwDk3l5wLU778uMYipVhcW9s5SFkVrN1JdwTdzwEF2uoJFfGiv/OtoXCMlYnb2MfJ6tdB0XrUd3jWT006LIy9twZD4b3qeiUlFlWcj0CRF
 UX4RBzOB
 V0fdxEbOfBFlN8FU9pClfOWYlMSaIOJ2uywmONID5NU0Ol/VR4kNGy5l+7Ktp8DhWe88kz0NjeFTgIzPNq1dkhDPT7tfgI1uToenBKSCs9hmbAjt5cfrgM0I3l7uCAxzQCmfYOW9UzhC329kQpvw6bEyerYY8R7qeePSLRmdkrR7UaxNSsJ27pAg4ZEkz4i+ojaUwE4AER5gTVPnNiJ/ZibDpulP2EjrguNH6nQ9Cx+cLd605iU0lIZMztayI4HtXwSMIAdmUi+lX0OHakfEKjkBuc7c3/dKqkKKAYd7IitHQTZcgXh36Djz27bVZ038bL3Ai
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and write the config space from that copy with
get_unaligned_le16() and get_unaligned_le32() instead of get_user().

The copy holds at most PCI_CFG_SPACE_EXP_SIZE bytes. Larger writes come
up short with PROC_ENTRY_SHORT_WRITES, like they did before because
they were cut at the end of the config space.

A buffer that can't be read used to write zeroes to the config space and
report success. It fails with -EFAULT now and nothing is written.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/pci/proc.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index e0dc70123f82..d420353ee2b3 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -16,6 +16,7 @@
 #include <linux/security.h>
 #include <linux/panic.h>
 #include <linux/sched.h>
+#include <linux/unaligned.h>
 #include <asm/byteorder.h>
 #include "pci.h"
 
@@ -114,8 +115,8 @@ static ssize_t proc_bus_pci_read(struct file *file, char __user *buf,
 	return nbytes;
 }
 
-static ssize_t proc_bus_pci_write(struct file *file, const char __user *buf,
-				  size_t nbytes, loff_t *ppos)
+static ssize_t proc_bus_pci_write(struct file *file, char *buf, size_t nbytes,
+				  loff_t *ppos)
 {
 	struct inode *ino = file_inode(file);
 	struct pci_dev *dev = pde_data(ino);
@@ -145,51 +146,38 @@ static ssize_t proc_bus_pci_write(struct file *file, const char __user *buf,
 		nbytes = size - pos;
 	cnt = nbytes;
 
-	if (!access_ok(buf, cnt))
-		return -EINVAL;
-
 	pci_config_pm_runtime_get(dev);
 
 	if ((pos & 1) && cnt) {
-		unsigned char val;
-		get_user(val, buf);
-		pci_user_write_config_byte(dev, pos, val);
+		pci_user_write_config_byte(dev, pos, *buf);
 		buf++;
 		pos++;
 		cnt--;
 	}
 
 	if ((pos & 3) && cnt > 2) {
-		__le16 val;
-		get_user(val, (__le16 __user *) buf);
-		pci_user_write_config_word(dev, pos, le16_to_cpu(val));
+		pci_user_write_config_word(dev, pos, get_unaligned_le16(buf));
 		buf += 2;
 		pos += 2;
 		cnt -= 2;
 	}
 
 	while (cnt >= 4) {
-		__le32 val;
-		get_user(val, (__le32 __user *) buf);
-		pci_user_write_config_dword(dev, pos, le32_to_cpu(val));
+		pci_user_write_config_dword(dev, pos, get_unaligned_le32(buf));
 		buf += 4;
 		pos += 4;
 		cnt -= 4;
 	}
 
 	if (cnt >= 2) {
-		__le16 val;
-		get_user(val, (__le16 __user *) buf);
-		pci_user_write_config_word(dev, pos, le16_to_cpu(val));
+		pci_user_write_config_word(dev, pos, get_unaligned_le16(buf));
 		buf += 2;
 		pos += 2;
 		cnt -= 2;
 	}
 
 	if (cnt) {
-		unsigned char val;
-		get_user(val, buf);
-		pci_user_write_config_byte(dev, pos, val);
+		pci_user_write_config_byte(dev, pos, *buf);
 		pos++;
 	}
 
@@ -337,9 +325,11 @@ static int proc_bus_pci_release(struct inode *inode, struct file *file)
 #endif /* HAVE_PCI_MMAP */
 
 static const struct proc_ops proc_bus_pci_ops = {
+	.proc_flags	= PROC_ENTRY_SHORT_WRITES,
 	.proc_lseek	= proc_bus_pci_lseek,
 	.proc_read	= proc_bus_pci_read,
-	.proc_write	= proc_bus_pci_write,
+	.proc_write_buf	= proc_bus_pci_write,
+	.proc_write_size = PCI_CFG_SPACE_EXP_SIZE,
 	.proc_ioctl	= proc_bus_pci_ioctl,
 #ifdef CONFIG_COMPAT
 	.proc_compat_ioctl = proc_bus_pci_ioctl,

-- 
2.53.0


