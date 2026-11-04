Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 941D2606D81D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hz+Hi3BA
Received: by kanga.kvack.org (Postfix)
	id 59D8A6B05C3; Wed,  4 Nov 2026 14:19:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D526B05C4; Wed,  4 Nov 2026 14:19:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 415F16B05C5; Wed,  4 Nov 2026 14:19:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 04DF06B05C3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:19:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 784491C40B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:19:55 +0000 (UTC)
X-FDA: 85398401550.23.6D3F07A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id AADB440006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:19:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hz+Hi3BA;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819993;
	b=1rrwjdzX6znXhDrOZZkggObp4cq/9KXTE0adNRCtQpLRK9czhGGYIfjiGxebL6Gzefw75r
	WRPGH1IdR3nCAkNXDlEzn9ViVVFN6f3CeHodplpuyA88rOhED3RRRWvQdDpc5sgPk6Yv6v
	7cJ3kLf9Fzunmdxy9N4fL/xLq6efELI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hz+Hi3BA;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0oFqdYtQQ93hmf66Xu9P3kJmoMCkLJeiEqd5UgVqoAA=;
	b=QBwXpBvwoQEc0KwL0Ae+g63VouDSmImgbJ6yvnPmAeKDXTz57v8kmcE6BoJRm3cbrq3GC8
	pUY+jC7Gfw4I04gBe5XH5a0e/o/SkdPD1GKh+RjCCgWoZEBhGRpn6QCWYke9yvn5F4zFhB
	lbdDgzJeu25di22bonyJ2XzFKKKYYBU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A7CE60A86;
	Wed,  4 Nov 2026 19:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FB41F00A20;
	Wed,  4 Nov 2026 19:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793819992;
	bh=0oFqdYtQQ93hmf66Xu9P3kJmoMCkLJeiEqd5UgVqoAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hz+Hi3BAL89sr/lh4dJvgeuEtclyRy1SO0NwI+zM8ybFv2jV939+Dv5j/nFojjivC
	 34KWZ812aeES23dMGvAnt3ycz/SqajABSGrcdN3MX9xaOrork7AxoU/7QteXfxvHfl
	 /V4rWTo2CoC5Jzjt8ZGo2GAXtUIc69Tn9FoUURbwhYdsskX97AesbdGMm73a/kHJmu
	 TWwsRNLr3d8FIdQP7kWnDBE0CbOSCCNE5mAI3+7DlKk2UgHvWoVbDBDqf4bqYXIQ1F
	 1/2Tfi4Gd8xeoe7KjATEoAV/9UDvE75iATYms6WdPb3WRBuJ8ZphmbEUZbFmU49bNO
	 mp7Eo0gjrTdqA==
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
Subject: [PATCH RESEND v2 15/51] PCI/proc: don't truncate the position of config space accesses
Date: Wed,  4 Nov 2026 20:19:38 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-15-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2714; i=brauner@kernel.org; h=from:subject:message-id; bh=57Zv3BgjxHPYJgAYtfWWUhWCD6jzurA4v7Zp2iJg+04=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9brzb+9rGxHjWvh7zmt3Cx6bFvVAJkBPctFNvxnKOf apBXbbyHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNRf8Twz2qLtYhEpvbj94Wu aQbrKrb8tHnS1sSutCx7f+mETxuYtRn+Cnk3vJkpqGW+cuXUS7IR5159W7FMY03xNO+3W9a/8tV 5zgYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AADB440006
X-Stat-Signature: efryqy7cxtreozeupghjgsityws6ep4j
X-Rspam-User: 
X-HE-Tag: 1793819993-891804
X-HE-Meta: U2FsdGVkX1+Bv+FvOA+md1sn4XYShYOgMKZ7RnIHSQtun9gHmKRGda/WZ0JpqQmYgHVCOixvugqocyROTPYoPfdDDPmNuS4fyGnrcTPNUEWY711XRX+6CDpjNLsKUWrmzOvfOLU4d2L9svGdSyNxsgONQIoI7p7fTGZQK/oAhkladDcpM9RGF1kQ0Yp+xLuZGLo8NhfTN+CGD8GdPyWswHKhOp6fro0hxHQPomiUXnX+cV08YHLEce9YyiQthBKI1koqSti2ije6fhtkTj3WRGKdKKf3FgkBh9ffjB4f7Hemum6wJTcnxtsBFC+nnNJkiLAIJqjYt8UQilkwcezxZLhhGQHbO/+ozwI1jGcwsl/xBGaiqL0zbhvAAa8Wws+3+Dt/jsotloC31FXwb+6VDYLJ+BWj2kCzXJYi5RAAsfrkvOE4/AUEzsvgX3jc7Ut6kPJCXZFlxqC5cqB4rYepLwZkTsYC0kEBIxEsqKhy/Opyv0OEBqN5T2o7JIbygoCIyKRNjhumg9JGr7tX9bswCConpcn8dZPnDJlHGY0lT1Ld2MDiYcq1asv/0IhHG+JB9YW/BVFh4MXzOvFs3UjdxKcNuxIywcjpnZ157DJtYkAdtirR7TgU5Y57+AJP/h4MKroFlOwiA8Ck6KDkd6D4E0ZF/azJxfZngvHmQwPkfyLjq0RhP40vdBmUEexxcE5wcyIVgSgT57oGned1coVBiW0jvva3gHjlgUo9si4BiXPGs2nr9GQtS5uuQ0kYkK7cFs9TsWnKaoIyU7iXGOUfWxxAjgDibSVi55sRG9wQUu/SHh0eDKG4zwAiI8S5eV0pwuBvN5bw89I/f8TwFLC6cX/SYxL5MJ7/melpuMxKB+GzPxh2Y4Z6XM8fWfFjfInFlnNMTiOZz95p3aBF3B8xR/bKf8TiU5emiROK/WotTMl2rRT9nMs5xrPaWMDjCRA1tApKn0T8JEIgrO9POIb
 BPX9hoNI
 6TK4psUTvcYy2Gi8Cm9Ozl2rsZFui7dajy9ffB4KQcHj/J4zbaLJdBSsPLaoJzoXy60YyCJw/ya1EUGtaohSKBKcTf2fRpm0GD9lcpfrnk3JYqapgaPoCNFqYSE2wiwX1rqvfBn+vNgsZu+cH9ZTzndL9I1bz8lwUK76ckmr8CoohiQZjeS7o2cwtooKBopBsoVIno50gDZfZbR7Noor/vNY60EyNu82T6QaXqBIhwTRQnQCdYFxSdABmOpLz3GeEFuYmkhpCRrrf48YE9pbyn54+pTzM6NQdZR8qBDPge0c/iz+/Y0ePTuDCYYv6Ao2g8qUxmmcMZIxB7MAkbrrXI4AWt0UK5jwxVRUwBTR7bVPZ4GtDkY0B/PyF3ofGlQt5pARuhp402ACQ0+i/T0sycOR0rQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_bus_pci_write() truncates the file position to an int. A pwrite()
at an offset like 0xfffff000 turns it negative, the check against the
size of the config space passes and the count it clamps to ends up
larger than what was written. The loop then reads past the end of the
caller's buffer and writes all of it into config space at negative
offsets, which pci_user_write_config_*() pass on to the config
accessors unchecked. The write also returns more than it was asked to
write.

An offset above 4G that truncates to a small positive value writes to
the start of config space instead. proc_bus_pci_read() keeps the
position in an unsigned int, so a read at such an offset returns the
start of config space instead of hitting EOF.

Check the position against the size of the config space before
narrowing it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/pci/proc.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 3d7a9ed5fc22..e0dc70123f82 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -32,8 +32,7 @@ static ssize_t proc_bus_pci_read(struct file *file, char __user *buf,
 				 size_t nbytes, loff_t *ppos)
 {
 	struct pci_dev *dev = pde_data(file_inode(file));
-	unsigned int pos = *ppos;
-	unsigned int cnt, size;
+	unsigned int pos, cnt, size;
 
 	/*
 	 * Normal users can read only the standardized portion of the
@@ -51,8 +50,9 @@ static ssize_t proc_bus_pci_read(struct file *file, char __user *buf,
 	if (!nbytes)
 		return 0;
 
-	if (pos >= size)
+	if (*ppos >= size)
 		return 0;
+	pos = *ppos;
 	if (nbytes >= size)
 		nbytes = size;
 	if (pos + nbytes > size)
@@ -119,9 +119,8 @@ static ssize_t proc_bus_pci_write(struct file *file, const char __user *buf,
 {
 	struct inode *ino = file_inode(file);
 	struct pci_dev *dev = pde_data(ino);
-	int pos = *ppos;
 	int size = dev->cfg_size;
-	int cnt, ret;
+	int pos, cnt, ret;
 
 	ret = security_locked_down(LOCKDOWN_PCI_ACCESS);
 	if (ret)
@@ -130,14 +129,16 @@ static ssize_t proc_bus_pci_write(struct file *file, const char __user *buf,
 	if (!nbytes)
 		return 0;
 
+	if (*ppos >= size)
+		return 0;
+	pos = *ppos;
+
 	if (resource_is_exclusive(&dev->driver_exclusive_resource, pos, nbytes)) {
 		pci_warn_once(dev, "%s: Unexpected write to kernel-exclusive config offset %x",
 			      current->comm, pos);
 		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
 	}
 
-	if (pos >= size)
-		return 0;
 	if (nbytes >= size)
 		nbytes = size;
 	if (pos + nbytes > size)

-- 
2.53.0


