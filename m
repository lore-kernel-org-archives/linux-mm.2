Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F8A9607A8BA
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dcbte5hd
Received: by kanga.kvack.org (Postfix)
	id 790A36B05D6; Mon,  2 Nov 2026 09:27:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7689E6B05D7; Mon,  2 Nov 2026 09:27:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A50D6B05D8; Mon,  2 Nov 2026 09:27:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43F606B05D6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:27:10 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC27C14013B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:27:09 +0000 (UTC)
X-FDA: 85390406178.20.14CBFF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0CCF916000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:27:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dcbte5hd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vzxa9WYWKU2hIPXRh8KIDL7iPDal71uWut2R3PeQ4Y0=;
	b=JYv15Ir7ih1FYU3Xxa49864znVVtvHvluwL+mGbnxlHFeVdB4xXnJYpJn7QSTbADiXvi/F
	onhuom106jUEpAOKHiKqfJvaGx971TKDOoTce5gGNxW0W4J+5BPSO+nT5tdO8u9Uaqf46U
	9c6g/pBba/qoQFg9eayRIF4Vj/UyIC8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dcbte5hd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629628;
	b=lrzB2fGyiAASGETe+u8W8iI38tqCuoQvWBxxcpOBeHPpj9NNxs3jW+Zry1VfMx4u9Zp9QT
	kWbSu8MQebBs8vkex71vn/n2tUEqLaRVoK9mfENmZYUDvAddMNcxZlv9+v7uQXKuvIdVkh
	OPt3hsi7MM1rg5LPcC1t0zLfaosLMec=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 47F0B41ADB;
	Mon,  2 Nov 2026 14:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929881F00A1A;
	Mon,  2 Nov 2026 14:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629627;
	bh=vzxa9WYWKU2hIPXRh8KIDL7iPDal71uWut2R3PeQ4Y0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dcbte5hdW7xjuWRdXMJ9nUGRptVMxwMDxFZD2ZHCRvhATLFLbmCjO/p7ODwW6VkxD
	 y7TF4q7FxSh3ont9POQCTTY0PwswUZV/ZqG4O8wvRMxs5F8284pF+mcGzm4MaK93NQ
	 QpE3IepC7NC3BeKk4OMULpvVs62kxU/MrowPIKoZY6XO5y1lgBCb/ZkDGZhuIEq6NW
	 CebUwpQ9Bu8ybMNIDU6UpP7VHTtt7ORw+YnjUGlgQRZHNtXQRbikAiiBKHiyiL/Vym
	 Kt3ER8pjmFooN4uaNfApJD5LlOSUElugetgObusGmTVg7V6wXoTDdDCVHauOcLAVDL
	 k6v5tGZIFoVqg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:38 +0100
Subject: [PATCH RFC 23/38] proc: don't let NOMMU map procfs files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-23-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
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
 Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3736; i=brauner@kernel.org;
 h=from:subject:message-id; bh=z8wCFpT+9QBGZHOy3TWX3BTOUWtbXQrp/PYYpjal0N4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJPtsd9LyTjxn8etT/1L5/2vmRnbF3jUb0ZGzE+VN
 WutAza+7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIwGxGhonbJLQPhS/4cP0g
 78WZUsuMuwP0t0uVRT6JrMjxPpyY/4WR4cI2pcs8h/Usw6/eF8xTrDD7dyb70sRAec7Qk5mztX6
 2cwAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 0CCF916000A
X-Stat-Signature: g5hwqryotwje1et686n1f7xyyuj45g4x
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793629627-316332
X-HE-Meta: U2FsdGVkX1/qyUcCKV/JADYK+PsbO6QYUu6XVIPVD+yAn077o9tBE0t+UjvvwCWUIqcPvdgxbNYiEZt/5GZ1oerBot6JPryWIEfCmW1Q90kJTQYl1Uk3RCzh5MP3+QOhxEDBMTlAKQFfN9GB1ZqmexjR7qK85wqa6xV3zQTNOIpfcE/B2itoqrdv43WtEhHFbqf2XGs3rJj1Rs88uO7STF8+POBVKQEPmyYpLIYOo92UcmmX9K048GUk+enpHnYeV5hkwYKDW1wtJPj7slomNAGf5A3n3rF5ybhn1428czJlr/g9FVX25hyKu4V/iLVYbIi/RxyC1Eo+O+67sboJCeveGDWozKBE9nKAXbW8k+KiXfuYdgdp62qCox9arw7UPFCrCrJZMO0e5PVNmr3+tucsDlW5CBxy9i1QLH8ECpb7QIRXQAeXdjwS2k4Lrb0X0vaiU/FjyrdGD1GDsjduVYsxSsaRbUlZg4dT35gBPAXC28IfEJ0KZj9vARhruoZYdCtMSegscIdtV3IrFqDAVmh0dntneErJi7gKGUb/EszbWuA/Rp9ikstMG2K5E/h58/7Dnk0pHe4RWmaopFzUCc4CRXP0hKHqVHqWgeAtc+u2sTVAEs1Zo3ApumhgUHrbS7mZ6Qdb4LUAL322xsdCdynS4tJ7kdSkmGBH6EhPIBnahpLura5yNs1w7uGCDONhIjqrC2zqrd30UR4rzs9LSJqV7M6fXt/bIdBC5HGI0epifY2BmWG5hcW7H1wygQa5FtIjORst2qHIahu903Gw3d8IhFc0b3ZuqYlMRGSFmGGxhh+Mg+lDrQl9SfcOaki5xAblq5wfnGdZYN9qWPmpYRvFuPOB3o+FME4QYiIYgzarUbLt5S/q9SrPhDGcnuRINM8HZMhAyCpzLGgID1b1N9s1O72zdCPQQ5q2/IXOSZph6t94JObqwLtvTO8HsUTHGHtxAiT0gkPuQsKUv3E
 WKyr0G8O
 oeC8GnWdcdd2GaAlsa7XrfMxJdsfmQBWThnQSscHADBNa9cxmfNTyO/KJTUtDOQjpXDc+/EVQ7IlKUjuTxJlbtEBpr6h/AoMWK4DtoD3u7UY2zLw2RJA4r8PLHiyTPd8lSp5t03Kg3XzjvJ3PFULxPfXimfb4enFilRHycTvePdyG3UCm0XqsYcyrPeIQwvlpTSnDImOu4iwZp9UwJO77hFjMeUGRv6jSTSYrsdPyxOfmanJao34cEcpYuez+6jn7kvpYthFhbV0678s+j6a4zAyai1kPVTAvKWSt
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
nothing. Mapping a procfs file then fails with -ENODEV, like mapping a
file without ->mmap did before 786d7e1612f0. NOMMU never called
->proc_mmap() for a regular file anyway, procfs never offered
NOMMU_MAP_DIRECT.

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


