Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0705E60A5BD1
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hoGLsylU
Received: by kanga.kvack.org (Postfix)
	id 2B5166B05D9; Wed,  4 Nov 2026 12:56:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2656E6B05DA; Wed,  4 Nov 2026 12:56:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12DAA6B05DB; Wed,  4 Nov 2026 12:56:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E1D686B05D9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:56:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DCCE1C4155
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:56:03 +0000 (UTC)
X-FDA: 85398190206.29.B351FA9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9C3A01C0004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:56:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hoGLsylU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x8nH5QJkKiZNUTowDxB/hMOFyVkHqFnuwosL7qreMAM=;
	b=azs8p8dt9zgYSkT2MLFRgRtj4dymZiH9JSCk4NgXAm8eAyI/ToKkHfmhJZyhsKs75hiSGu
	o0vo64JcSHnPwamp1bGDTmPOuMNDVrSqZeQ4bAYH2lNFYo2GLvgKvvTbU3h9G94DflsrIX
	viasYFFF/KeyhiGZN/ICVkR4yf4JNlM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hoGLsylU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814961;
	b=2mORBhaFOC2KPAwHghunIQGdMAASProVASIMKk5Ymd9f5vhYc8VzQic/YUNRdUcQ3zebH6
	o/mcJVhjJTekePjf1AeCNZ5rlJ5w3cFt9AF4BzMUnKW3GUxew7KLG2hsDoFmS+/NjHrCFs
	ztq1z7J+G6ARgBV/JC1udMvt9uO1xpw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A53660A06;
	Wed,  4 Nov 2026 17:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAC61F000C1;
	Wed,  4 Nov 2026 17:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814960;
	bh=x8nH5QJkKiZNUTowDxB/hMOFyVkHqFnuwosL7qreMAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hoGLsylUTixNPsM6JjA8vEQ97GS0PU64B/S8mW42LCSUIEW0+Oup1fKeKwWKQdTUs
	 7hA+IwbT8SOA6SNIASsjDmnoUBtHx7XyqRnT7bzWmyNx3XbQeq35t1VBobNh34XJek
	 TdXWkSK6MqCihvsWYtZOw1/JX14O29VjTCo9F+UA4nJfcs4I9UbzXBW1IEI742yd39
	 aSY2cFacXu9jS6PUQxhQcjsZmHKA5h2Hba77Wfcqi3vnGnQV+UzZn74wBpWJjO9vss
	 WWfchnn/2CaHA/1giIf/i0HUORN8nxETI0UgTQa+bm9oE2krXPKY7Xy+xru556UT4i
	 GtoMTdnZo42Nw==
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
Subject: [PATCH v2 36/51] proc: don't let NOMMU map procfs files
Date: Wed,  4 Nov 2026 18:47:22 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-36-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3847; i=brauner@kernel.org; h=from:subject:message-id; bh=JTUUxaAv8g+OiylD/jB4kSfUdacg86Bjtrwx1fOwQ90=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9znst+bi3gVMj0u9q8/OL7/9NXaGRp93F4cL6Kpxd9 LWzfr9TRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQ89Rn+WS/RVtYXufbh4oFN 2w/v2mu6PuPztYBDb9L+TapKvCWZJs3IsLjj1Za9+0LefPka4qY2Q+HryzrJUraItnPnOr5YHLr PxwcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9C3A01C0004
X-Stat-Signature: 3wp7bswkjchwhy4qscsjmpfs8uu6owie
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793814961-413751
X-HE-Meta: U2FsdGVkX19LIxrfRA15oW8knbsaM7OQ9MRJFhDkehj2xpi5l9uq08n3CuMef1uyFe9nFbqAY/ZQFJSUXHTobB9/rxAbfT/qJ2zmKx7MTVjhlTyBR9VAQ+JRJ6ZDIMeY8KxX7iOtk26hbAPUeI78TAja0k1kVOO8g24dddzkZ1dj70fp8G0ls5UgYbDuYGadNG2bQZd4LjLg8eAvNU9txbD5WMI7sJV5wtbWhMxpoESc5saG81fnsB1+guiWKGT4gctc/+Z7fqkCKYfvvmLR5QCmnqB8HZIv2QYsd3KRomZ9ADwSsVlY1HqvuV7vLYGoYdRjo78BUZxTcegi4UDkD0DwdvLm4xCoF3R8B5m5XPBy0bjf43+CkbpnRcP2MMqOMhgLxO+mfKxacsj63aYJnXJ02+XsKUKFo0aCy+g6s5sJlZb4JuT/cU2gy0VyIC/16Kv60UGFMBH4ii5n9wdOe1oKK9O0C2FteSD18eSc0EiNQ7sw6MK0dFBW08snYlJLF99xkt/gdcW3bZQl8WAz3tAjgBBzRShLdqxoGtickGXTBPQ+LdTuNeCiGuBkMC/NwOZ1dhs3oDIob9s4xNW6FXhRLqj+llaL7Zpb3joVzmlaCgR6PxtJfhH4XU5jltkiYgyBLoUZp6rx1YMA9v830ywJLEXJuflDHCvpY/Sh/NQzmp7Gz9DbujPxCoMQaCOyGFi4r1Ym4GhA5LOuRT7WVu2hCKRKjyL7PCUF13d8oCbEY7FLHP97TrPkzPZwpcCNoc4EGWpDgPSUN/HO0avZKmd9UKY2AUt1B57oSPUBrb9L+o2VwAbhRXFk6QBC1oNX7E3o/zTCW9yiIglNQAMrK8unl5v0H9Yc6qiNpqD+KmVijR7ttPzsfAfAIXVm+UOckWMnDcx3dGByvwEWgWPjZTdmk34YN2/fJsX9TS0LdV8TO18qkg6NM64Be/grA/JFbvICO0Hej6KDbVMd3Qs
 EKe1Tb2e
 MK/dS3a9EWBOzXnP4Mukb4iBMmfLA4Q5li3Mlc9EEbhQ+M/D6+2vlH6AHFOCykodil31IdeMc4SaP/scU6/28emOhW8QcmLv0FPsv3Qj9FtWx3f8Ig9vRluDXhf3BqMTUGWN91XT1I5xBu8fWsVQFOq2X0n7UnoHT/yLqTnQw1xULMx1IPkDsmAkeDwaz2nc0VVZKvpIL2I7N3zamMEFbbZcxwLdnhcGsXwhKK3geTv/btW7+Ows8lgopVq0EjFvLgvBr7TrqtVDYpcI9lDqiF7DwJg==
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


