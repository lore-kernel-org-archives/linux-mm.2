Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 412936072F88
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NFupU1rs
Received: by kanga.kvack.org (Postfix)
	id 4B7B06B05C4; Wed,  4 Nov 2026 14:43:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B916B05C5; Wed,  4 Nov 2026 14:43:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359816B05C8; Wed,  4 Nov 2026 14:43:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F27996B05C4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:43:13 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E1CD140845
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:43:13 +0000 (UTC)
X-FDA: 85398460266.11.77884F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id BF4FE180002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:43:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NFupU1rs;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821391;
	b=QZvL9GZubkvv+br7WH5bw3sfsiXyM7joXwMpVq7k20k3xp6zNByE8BEzDkSsdHD0kKm5Fs
	6++vmegTEuFuxLZtP4J/1R1Js7r3yGwTACRWmBgqfJyukHWpLi05mISvCV2Ea6SGhigDdo
	wrHUlo84IHTFH/6ROUeJAyWTMfhFHjE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NFupU1rs;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vqkxnch8qakIwUVP+9QJA5QeGLg7HpbhcDTmIF75pEs=;
	b=hM8oCgJTATbKU8svDZi2qymU0c5UFuJEQX2ZS+lt1abLVotBr9jFsgd6s0BEU+4pNyExZw
	RYEWAedYpMUkyVP1fU3CTmjZvGILxIVt1y3D4m1d9k6208BDfKjdRtVIYndiI6h0ySAl3S
	/V74oG5zVWODFQl0ddeoMtBLyUMtCFw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA55343590;
	Wed,  4 Nov 2026 19:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D174B1F000C1;
	Wed,  4 Nov 2026 19:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821390;
	bh=vqkxnch8qakIwUVP+9QJA5QeGLg7HpbhcDTmIF75pEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NFupU1rsFN26uYyirSpy7lFw664I+g703aMbJGP14Bae8+IhtR1KZcpCy5pdfPvMw
	 eV/2lBYEER+x1ZleUxLp7sD4d71dwM9dIy6LqnYceAMqDaXbDyZm9eAyIxvw4CZ/zw
	 cL0lQa1+LhuyYV8RPMrhtaCZQdVkmeCOGe9Gdjg6JKWj1oo+B4rwwcNJJZSZ97bpQ+
	 ZCUOUvVHmdEIToX0OugSV/yJ7Ok+GTvHw6HO0EWJbZSEzDaJxJrnp2ZDpD3fDUV7mJ
	 KbZm/VwBsDiiDXD5PZdNyV52+UmubW1d60Nh97+JH1pD4lkNt+RcBs+FCN//W2HPve
	 8OGziJyI9UIlA==
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
Subject: [PATCH RESEND v2 03/26] PCI/proc: let procfs copy in config space writes
Date: Wed,  4 Nov 2026 20:42:56 +0100
Message-ID: <20261104-work-procfs-drivers-v2-3-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3416; i=brauner@kernel.org; h=from:subject:message-id; bh=FHhIortRJiKYhZazrarBsz8LKuG1O3uAWYPgQRTjmaQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97ipbd2aJ7totIq+iew42TZ73tN+H7Rjntr0y7q9bn iqKvEn26yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiI0lpGhskhIdpTXxn2X1+v 5tcotHx+77XQvl3hnbJzvA3uziu8v5zhD+cfrvnz0tvOrTVaZiYb88BDz/rzsT1fFDfO3fJhwru ZsUwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BF4FE180002
X-Stat-Signature: n3mbnx9jgiok71hu45ucft6t456ndy9i
X-Rspam-User: 
X-HE-Tag: 1793821391-938053
X-HE-Meta: U2FsdGVkX1/a9jSoKIHXv8qVf73zWRDA7cMXKplA3Dha5gAa0o4FeVn4mb1GREdFvPMFqHX3p2TocQl/E3tzwZTnXlDyrP3DNMiWYmWf9agJbfALv7BTCUtUGukvZif3A2Y5xvUHeTsyAJmR+FDwqz26MDc7CMUYtfCqv8QyEsKbdMny8kbn00S1A+ypIpJMoNzs4u3kOGdCWLqgpLWD7EwGGy4rltfrQHyED5DXI+iCOgIZogJuSIzCk1Ia+BmAUX+25ATD8b6WRk1CD5fBxSKe0nux30jJjt+ZB6Be1ryYD7fSgUI4z1Af1ihfOGO00/sNZjMyVw0g+jR9YnM4CFKG39FdJv7gdW0OyqbPHi7GHPzay8U4KhF2W3L6khmNJwk/fqAs7hzEn6GYPZ38NJlZVHw0s90r6WFbIPsw0zdHU5EoKYnTSlgJYoVKFIq+YYe8p/b4yzWIr0GJru8wTEzeEzvlv27U9DOkqu6uZ3Vu35pjWgElZ/EtFv4rTSXJJmPYIuj10BIda5f3PPvkJ7RAv5qBenZkj57vzNnWxZz1Wi6atbuVz+BospRNbDCAGQZHwr8hymxn/vNmFyAep+l8iXtWLn8Yr+t3ouWeBo0jCjrRPIPhU7UR7N84VUltSL+407NLhEHPyuRkeyvlV32UYQ3CN9RK6du1a3RIcQRlEQumAD5pLbvMnaELqIMWoZtQeG8YAd5q5KHgIxjdqtiabC7ewHbt+7GgtWzSNvI5J2ge8CfmHJYCPRO+f0LHozwZ955Km8w1PB//1BlltB+a01GAFVOQOxBRSjKxhRfsU0OsI50U4aPmU+YAkYwBt5TE6nra1+ca/DNeGTfHvDwbRL6LQtvV8Pr//Ts7lePaWdr+/PM4gasyxDG/puoL0Oqk5up3Xs2FhsVnSZw0IP+ovlIkhq4Myp/ur0j6W+DqM08evUBVpnyGpCbXYJxurMp+/HJKwH4ac7Pfz9x
 bWuwWH0E
 91JNEWVaTT7ARqb1YykE1I2oA61X6986EIXeBU0xfU+WO/KK8ufnG+XVdF2lE4DAk9l+vMlbUu3DmYA6wE+h67cQxhi27+ZuUWgHkSbiH0PTqo3xMKzrtmz1/tB2zykCVNVDlaht5usiHJireCBPtT0X5JYOUYKrRfH7L4FzQVOnvLyTNOUjl4p9wdSUWcdSJhSg6/OioQtQGpARbupkXcmgCDz3I1O6emHJMoE3feYeVqs9ImB8B2ZLf+IDAGzneE3C9yhKMcezCo+02MYFCWhdeFY+CaRhbAeOtwjbUG00WLu99RwD+H9ySlda0w2QzKxhMvPgExNRNK2dmy1rsODyboxqKyD0SqCagg/umqegopNZGTnLPLo+4K8+S97AthBRMBoyKPgkPgCeManFeyEv/1BKfWq0tWFFrnoXQCBQN4LZtCeMKJmw/uQ==
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


