Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1528B60A3811
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=noCFKCgL
Received: by kanga.kvack.org (Postfix)
	id 31C196B05B6; Wed,  4 Nov 2026 12:48:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CCF36B05B7; Wed,  4 Nov 2026 12:48:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC3E6B05B8; Wed,  4 Nov 2026 12:48:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBF776B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:48:49 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE7061C4091
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:48:47 +0000 (UTC)
X-FDA: 85398171894.22.2BE9877
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 28C5440003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:48:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=noCFKCgL;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0oFqdYtQQ93hmf66Xu9P3kJmoMCkLJeiEqd5UgVqoAA=;
	b=Sb6Ck+HVADcLVvMHb0nv7XVWam+NChZgVk+zz4jfquG6KyQ1oKcNMZTky2rhKz0Dz9fpOp
	bC++I1Jz04pObtvkQS3Mb1rSHAwe6medRVF3QxtYTeNoB8cUwxlpAWIBzGNaG/Qyov9MvD
	2N+dFEhw5aqZJ8aU5NS6N/xmgICIuCs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814526;
	b=vf2TdKi2S20Ir3SfMaTQrHmWvEOKloLL8BuOS/0Ai2UH3RwJGWyxZBInCmQdpcAFpFaOqh
	BQH1TMCq8x5fZyvTT3AW2+BcKOWpvdF1Pe+u+YLzeMsrABSkrtjN6Iw63kyJNGblGQiLLp
	kZYP01LwOxWk0LkAA+Qc9K1J8ITfAnY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=noCFKCgL;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4ACED43DA8;
	Wed,  4 Nov 2026 17:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05981F00A25;
	Wed,  4 Nov 2026 17:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814525;
	bh=0oFqdYtQQ93hmf66Xu9P3kJmoMCkLJeiEqd5UgVqoAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=noCFKCgLdEz18/sqF1FCWtVxsv/QyKV8mQTymoxWK+iiCMJtG9Zq8MeqLvY3hYEr3
	 hW0ksLKsCqDeUuyeCxIewkpGMAQxP5+SbkknINTi3v5SKU9g7u+iNy/q6EWBSY9M47
	 a1HQI18KNvLYtRt2WygIYuE3c2BaTAI19pyJSUQbaTz/JNG7KXivQ8k0SWqUWZ//Sp
	 Lzi0wOR/fuOZR0XnuR86I0XCuZc2sD6cH4+TLvQA7RQoawB8oy5aktiHmUQYq3Xkoz
	 UcEpl9KlnnxOyIAxi4Pq7KbGS/jLgYWdG338W7ywff7d3Gg7oQPjS/4lnVEktzCirU
	 mKurYZoNKsVQw==
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
Subject: [PATCH v2 15/51] PCI/proc: don't truncate the position of config space accesses
Date: Wed,  4 Nov 2026 18:47:01 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-15-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2714; i=brauner@kernel.org; h=from:subject:message-id; bh=57Zv3BgjxHPYJgAYtfWWUhWCD6jzurA4v7Zp2iJg+04=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zrv4QSS7QmxmKncEz+ddbFt2TmsVZdYQ90tKWuXxf jfnr3lMHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMp/8jw39du2rR1IQ2zol85 T2Hk+y4ZopKb1hC0/t8rkxtned7ZfWVkaIoWnH59RriBT2Zy3NRn+o8WPb/8RpnjV+SftqXfD/1 8xQIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 6noxokhe3wi536gfhieef5dyy56iut65
X-Rspamd-Queue-Id: 28C5440003
X-Rspam-User: 
X-HE-Tag: 1793814526-981640
X-HE-Meta: U2FsdGVkX19NuFQ2rdwc/fX6SGJp8FJScVioVhKC+9fSsPOAkRAiq5klHyctvee+ifKXgbazT+qEfsiHZLrLKo9clYSGBaIGHm/jk1tt+tNzkEQtTH9LnSWRi5HvCYOQc5Fh7bC/2zDywf5TVbSvXDZ3ebDtmukbqOklYujT0iInrE5nzs75xvI3qow1jR68JS/GPQpBXyqBykxUKRsyEaI66L/NHrKhMlMQ5zC+9ERR38aKOvEiUQrpTjHl6PzbyFv0btvkMOfpUlCOI+b+FaZkljSL9wMTenNg0w8Sr3ZCpRXaJ37KEB1HKI10N2hf+ChhbHGgdbbLhTrV4y12HngaNJ1M2rmgGb8FX3ifZYetgZyu3zcyhutWtKXi1o5Q6fMMQ80PLNEo1DVM/fNXhk0DVUhRyaq+bUWz6vqwJgHvCclDbuf9o3UDQKMietg8eDUQBulevteDvFu0xQLuWM7XYUYdLdmuneuu5DHirIXGYeNXwirRKxD+FMWGbZmlf0Ay/oSKTg4aIjckKQf0Nipeack8CQ21uxU15hmZeD3dEDyt+pFWD9uXinEqOASezS3jBc9xFivkZVHvF2zaZ2Rg0eyR191GvbwJ6XlghpMvHHTzSfGbb2/OQs3g/bW7fbkcg5Y7px+2xgrMpjp6bN02M2gfOxgSY5XpO4Dq0ZWWbBE7Ds7yALJ7XCeVV23v50Xl9OeXkAhgTU3x5mlPt1CduJQO7MItVzniz/G4t3lhYrtmX+0UJa7wwcHdFBnkyV0+jTjNUXC65AJrIFh+K1HxVIniIizfDyD9jNKIXgVifSkpdiG0gr8tLZm4jQNI5zWTMoEaxWr0yxpfISuFhT3dFmDSdvwUH9jyfiCdhPaY+c7Dx/0jOAKIBV99R8GvaWYWm/qzlsgXLZ9SqagoDCW83w7EblNFHzdDOWLpGcQHbOs1+W1DdwiAEsC188x5Fv5v7dAEKbhmIc+sHcv
 AAyXEtMK
 +LZqy0+wvUtySjgEnA8T6eDWmpEvvLVAgGOyohQAazGJGUOAyxiV72hRo1J/Zluy4XpSjHB36G/Rth08usoRyAo/OuDvwRqB8erLVKQGPuNaKfHk1voUOu8TyPcV809XSaB5gLEhDfciXqDKsjAHap0qSAMZiEC7nRWBP/RHvHtJU1cV8r7W8tn+440essxtwhPxxtlVN6QpBCROdSo0FapGMMR18PawWZgc77hnPl2YdUC+6MnH6MYviNiiGd0aNewOnmJHqZinaU2+R9H69E8ZW9Cmwc/fKLKUxL/Bhrg3j6zPVYgs6QevRWEoa1QbnjyScWp852Dlvfiw7qQ9PQp25ID8APNV00h+vA8z+HGNbkcu9YC2WCuSbg+JQxBNM24rnhj56wema2MFoqlK2ryjPUg==
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


