Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85DC7607E934
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AOGtv8Mf
Received: by kanga.kvack.org (Postfix)
	id AB6EB6B05DB; Wed,  4 Nov 2026 14:25:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A86956B05DC; Wed,  4 Nov 2026 14:25:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DE76B05DD; Wed,  4 Nov 2026 14:25:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 72BBD6B05DB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:25:05 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0463BA07D9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:25:04 +0000 (UTC)
X-FDA: 85398414570.10.B33DFB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 35AEFA0003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:25:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AOGtv8Mf;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x8nH5QJkKiZNUTowDxB/hMOFyVkHqFnuwosL7qreMAM=;
	b=fdo/Y/RQGcOAuJ6m2sB850azip+jkewZE1QsoQlEzmiXwZNtBCm0F/3OjA2PFixCIKn9O6
	PR0CoVNRt33D1KByIYAs3rTCE+SpEmDzdcrQI/VdDNse22BoUVPG0yGUXfSZfqtZEgQd5W
	zmQDgP+uNdUCwDTwbHbEf93lNV1jgak=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AOGtv8Mf;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820303;
	b=mv1nt9CbmUXRUVkeaYH2+zTjU4iDYCGuIt3oYhFgqlxQ1eneKWDF/O9iv0xjEWQpMlKjFU
	YHUC35gJkv57zWzI4NycM4sLYQGFLr2PR/OF0nDy4Y2d0RfxyfHDTUIYnQdmUkSYP7k5oK
	kU9dCjkqMxgYF/1r3ZjEYfM5V3LiRYo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F12341256;
	Wed,  4 Nov 2026 19:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A96E1F0093A;
	Wed,  4 Nov 2026 19:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820302;
	bh=x8nH5QJkKiZNUTowDxB/hMOFyVkHqFnuwosL7qreMAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AOGtv8MfSvpV7/N3SPQdxO34HN0jitae0lUNpVEJDAU9XLw0mdF8nEKatSbYah4D4
	 pJnFyEpZO1zbMa9uji/9OWzr8wEr6lfii12mf0iU2Lh2VjsLavJMVeCqDZp/52sjZ8
	 3Go4KV6nkkS39oFoJGSvgQnMVnncUKXYL8Mx162m4aQQqRHIlpeUtyYZQRcyHTHG+m
	 F6SJS7Gx3owS0zf+1GA3KxpXJd3wQWd0E3FPh1GuNLid6UQ0pR28EaGxERe/wN3pMg
	 +vSX7Zm5D1718tOrlyhaV4OrQ07V2BymOcNC4cPME/yryrTT1k2SVGUu6wuwzfR22j
	 +9kSochp+NapA==
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
	Chuck Lever <cel@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH RESEND v2 36/51] proc: don't let NOMMU map procfs files
Date: Wed,  4 Nov 2026 20:24:48 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-36-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3847; i=brauner@kernel.org; h=from:subject:message-id; bh=JTUUxaAv8g+OiylD/jB4kSfUdacg86Bjtrwx1fOwQ90=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bvzxcvsOxp23JLZfCWya6MPaPHGnRYPLhkVvf4fHB W9U5hb431HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRyk+MDK+PBU/le8dv0ftD 839XV15oaNPWrTw8hs1fHTLi/wid+Mbwv6CPOeDfzSePDj+a/VD2SORxlTWdy84uUOARvTIlTdD JgRcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sr9sfoddxwxdddoxiwu83ohp4qotazje
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 35AEFA0003
X-HE-Tag: 1793820303-441517
X-HE-Meta: U2FsdGVkX1/wzl8+QK0asb5FfNcH/rMomj0hsZCKQB5l6gOr0V4j7wYR9iZaopnFdPy8l1zGguNleu8Ooz0jjQxvcQ8f7225ikLPeeZ23iX19dB+bEPucECcecT7Yc65fCDHZQAlZEpufw2vnW3QEzCbp7nBoJfwFhj8N7R8Xuxz+EKIwdX0d+oBXjGCdPmoVtuyCoziRkHBiogwr9hSZjb20hz5erVjNGHRHAbPXmD5PiiMXwISzmcayVralJT0ef4+mV1C/EOuXrKj5uVptT1i7l+ucWnSg3gIA4KWJbvsgL/+mpsN3VMpBHBAPvmk4Sto6l8qI8N+PkEgVa6gyVCl1dt85cfZuJGS8OXx8XbGIpsnzf18Jmb5tcyLo8hmksRVZcyu9KX3i8Z0yphmYotyEQcsh1S+hKHKCiCKKD+vf7zgLPZVwlhxV9yCciQG4LeSOUiX8cwuuwu5uK8xIpziGX90lCMj/Z4tmZ/Nku3SPRsEzioqDXcy2YUqbvM6KSiHfnOod9It0RxZsj5ZGIxfyfLjSSN/KBW5oTpVzJ4Cfe94N+pl6/t/nHXjglx79AvTPcGv+lMtiwdSDtTfHfhcRd07aCSCzFzmNEyjqnGRL6f43D5FgtDii5cfzoF+StymKnaraordg3EU3iJFI9SPMNrrONxyIV3kKDdOX8ymJA3SU7JnsT1Tszij/To2vX+RchKGkmYP0pugJcq26e78P9WmAyVCC3Nn1d4ygXPzNUoI8QEf1nMpj5xpjjNPi22boafdPggvbonvumkqGww/jtL4TP4q1gHpjl0g3KZ4FAmp9aB3x4IMSe+jiMF9YVvtWFmOwMqqrHEHGtMwEVm+JFXN+98EJPxHkTF3h/tSDywr0A4IVWTy/0kdB2qEHEmo44feRSyL4asLNBCb+21oKnpYx9492Vdf1gyRW7Lr/D2j1NrILXKm1n/JbeLm53+V6N0OipN5UmH9LJy
 TyLPJME6
 R5mM9Xk6scH8R3UlPfSsdZsGeka1uqvbG+iHl0YYkQXDq6bWQbMTUdrDknjbhQcTNfk7jaRtWueq3v6Ru2VC4vZZx73xtwqctaWTIvw4pJK18iMhmBVEBT/vTsJsV4PVPG4DjWHifkZ8Y6ILoqVDSk6+k5dSzlZJO4UtVVAhaMv60xiVuIguHkDFDqb7xDFNrDjsmelFQEvl84WbLLuWPy2y/34kByRf5WYxF6L3NqjzbVph5whvPIl+sIwhujIHupnMBQmevnZnvqUeh+ltKgVhXl2WDML1JZteInfQYsGynGCO9pDKA8iJ/kH/6tyVpyG9TXFFG5NAuS9C3ey3XIcyvEN+tBRGUSrriFzn8ntZ/BXmurdnGscAalozmlahqGEpgpMqVDLpC7mwm+rCq8aHfBGb1aUlGcafJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every procfs file has a ->mmap since commit 786d7e1612f0 ("Fix
rmmod/read/write races in /proc entries"), whether the entry has a
->proc_mmap or not. On NOMMU validate_mmap_request() takes that to mean
the file can be mapped. procfs has no ->mmap_capabilities so a regular
file gets NOMMU_MAP_COPY, and a private mapping never calls ->mmap at
all. Instead do_mmap() takes nommu_region_sem for writing and
do_mmap_private() reads the file into the copy with kernel_read().

Reading /proc/maps takes nommu_region_sem as well:

  mmap(NULL, 4096, PROT_READ, MAP_PRIVATE, open("/proc/maps", O_RDONLY), 0)

  do_mmap()                          // down_write(&nommu_region_sem)
  -> do_mmap_private()
     -> kernel_read()
        -> seq_read_iter()
           -> nommu_region_list_start()   // down_read()

The task hangs for good, holding nommu_region_sem and its own mmap_lock,
and every mmap(), munmap() and exit after that hangs behind it.
/proc/maps is 0444 so any user can do that.

Give the procfs files a ->mmap_capabilities on NOMMU that allows
nothing. That covers every entry and not just /proc/maps, procfs can't
know which entry's read takes nommu_region_sem. Mapping a procfs file
then fails with -ENODEV, like mapping a file without ->mmap did before
786d7e1612f0. NOMMU never called ->proc_mmap() for a regular file
anyway, procfs never offered NOMMU_MAP_DIRECT.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 786d7e1612f0 ("Fix rmmod/read/write races in /proc entries")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/inode.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index b7634f975d98..9933f03ab9fb 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -466,6 +466,18 @@ proc_reg_get_unmapped_area(struct file *file, unsigned long orig_addr,
 	return rv;
 }
 
+#ifndef CONFIG_MMU
+/*
+ * NOMMU never calls ->proc_mmap() for a regular file. It reads the file into
+ * a private copy instead, with nommu_region_sem held for writing, which
+ * reading /proc/maps takes as well. Don't map procfs files at all.
+ */
+static unsigned int proc_reg_mmap_capabilities(struct file *file)
+{
+	return 0;
+}
+#endif
+
 static int proc_reg_open(struct inode *inode, struct file *file)
 {
 	struct proc_dir_entry *pde = PDE(inode);
@@ -559,6 +571,9 @@ static const struct file_operations proc_reg_file_ops = {
 	.unlocked_ioctl	= proc_reg_unlocked_ioctl,
 	.mmap		= proc_reg_mmap,
 	.get_unmapped_area = proc_reg_get_unmapped_area,
+#ifndef CONFIG_MMU
+	.mmap_capabilities = proc_reg_mmap_capabilities,
+#endif
 	.open		= proc_reg_open,
 	.release	= proc_reg_release,
 };
@@ -572,6 +587,9 @@ static const struct file_operations proc_iter_file_ops = {
 	.unlocked_ioctl	= proc_reg_unlocked_ioctl,
 	.mmap		= proc_reg_mmap,
 	.get_unmapped_area = proc_reg_get_unmapped_area,
+#ifndef CONFIG_MMU
+	.mmap_capabilities = proc_reg_mmap_capabilities,
+#endif
 	.open		= proc_reg_open,
 	.release	= proc_reg_release,
 };
@@ -586,6 +604,9 @@ static const struct file_operations proc_reg_file_ops_compat = {
 	.compat_ioctl	= proc_reg_compat_ioctl,
 	.mmap		= proc_reg_mmap,
 	.get_unmapped_area = proc_reg_get_unmapped_area,
+#ifndef CONFIG_MMU
+	.mmap_capabilities = proc_reg_mmap_capabilities,
+#endif
 	.open		= proc_reg_open,
 	.release	= proc_reg_release,
 };
@@ -600,6 +621,9 @@ static const struct file_operations proc_iter_file_ops_compat = {
 	.compat_ioctl	= proc_reg_compat_ioctl,
 	.mmap		= proc_reg_mmap,
 	.get_unmapped_area = proc_reg_get_unmapped_area,
+#ifndef CONFIG_MMU
+	.mmap_capabilities = proc_reg_mmap_capabilities,
+#endif
 	.open		= proc_reg_open,
 	.release	= proc_reg_release,
 };

-- 
2.53.0


