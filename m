Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E41606F2B7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CgsURsVq
Received: by kanga.kvack.org (Postfix)
	id 281ED6B05D9; Wed,  4 Nov 2026 14:33:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2589B6B05DF; Wed,  4 Nov 2026 14:33:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F206B05E5; Wed,  4 Nov 2026 14:33:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE8FF6B05D9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:33:09 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6DF01A83FA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:33:09 +0000 (UTC)
X-FDA: 85398434898.28.7E422F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id A452114000E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:33:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CgsURsVq;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820787;
	b=IMT+uyez6p4U6NHcWHI+Uo2VpQUJONt/AwRmKl3Sqofaj94/Y75qTVXAo58ci7zEQbjo7a
	Je1TZZUQ1SGchYJd7B1TaUfsDAgmFohSjOhH/y1ZdBObVXRqy0KVemLqhAqM4fWFrxZiXj
	dZDMD62SKXcNFfFhxJqRzo3L5YWoFsk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CgsURsVq;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bS0sqLKel+zUDQBuy6UvkvN+2OJYA4B2QiuiWjKQHbI=;
	b=kPEtTql/GNNF14ctz365Up5xnHlpnW7o9a0J8VBfzK71kh6CGNA82srD4zf5IBaCk3lk4b
	xtA7kyxfWzmb7bY193vGWBHfbx8vSFJULcH3eaxRYAKvh7dctPhWv3lXP1Dc8tIhWvkgrg
	/TaE5EQ2ZuUJFgsRTrLywGbqt8oUJFw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F58560EFE;
	Wed,  4 Nov 2026 19:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CA41F000C1;
	Wed,  4 Nov 2026 19:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820787;
	bh=bS0sqLKel+zUDQBuy6UvkvN+2OJYA4B2QiuiWjKQHbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CgsURsVq0Jx5eFRo0zL6RwUdX7cUmbxMgnQjR3CMq+yFZIda516yMqyvBv+VJRJGO
	 CbRCX1z+4jH3yckp40oLZ6lMELKkxDwpzrcg0f9RJ9jEHC/Hsv03D/zH6Lx10+B4Bt
	 X/wbIOi1D3PUVzGQ6YhnWd3C8dsAQnA/OIxZCUV8kuieU0SPky9t32VZMhyiWmCb2w
	 dtwzN+2E1HUKcv5yvjwIdFh89CychlyOMck6HVW5unLzvI8CmogFoCE24ieoQJchGw
	 r1bEuYrplyx6w+yzZtWvOCdITnPyD1zHwGOdEyKGuPARBjL5BWklyjO75BAEBmnPmJ
	 Ewa8XfzsEzj2w==
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
Subject: [PATCH RESEND v2 15/23] proc: copy in writes to the network namespace entries before pinning
Date: Wed,  4 Nov 2026 20:32:53 +0100
Message-ID: <20261104-work-procfs-core-v2-15-76ace653a773@kernel.org>
In-Reply-To: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3064; i=brauner@kernel.org; h=from:subject:message-id; bh=AKTwCBJOA0MAIxlMr3DfHwtMd7LDbYNJiozzVu/aJkI=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bm+WesP7dEdWSvHufyFWH5UK5YQX9jbJ+M5Paa65f p/d5URwRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEReH2Nk2D1/7+NDTTy7PZKz 7f9EHnjy1uDeyosSwXs65NyKfv8S5mL47x5iYCO9wu1y66mHL+5tO8j54rTT+22v5bpDHvKfz6h ezQYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A452114000E
X-Stat-Signature: hgy99gxqbgmdst8tbzdptygetoion77i
X-Rspam-User: 
X-HE-Tag: 1793820787-413107
X-HE-Meta: U2FsdGVkX1/3fLW9cZctYpbfEWhL7iXfgQN8X5qfv/esKduRth5mng7Yt+kACBcz8kIR7056hyD3//zFI5S6m2qlb0/ZJ8hfUk8kNi4dtumR0rhgThuFaYyvAKHwKNxm6tfdFRIhdGurTyEw1fDBw9kuJaY1+ammoxy0puDEsI/y0Id0LIO1u5Z4aE5pqD3Z0+dsSmip1r2TKJbJbnXGAwBuEGhqlTfp+MLBIRG95xqTYqsOggN83BF3TPDVSUXCsQR+or2PVPSw2yQAZEKcWwRnkq3QA7jBup+v1aY869jMXWgDDvk4nzCMg9gkUZAXvUFvdJd2t57YLqpDWGefNfNVRm37asxxm7zbFi1zFKPilt1bnGKoxHh4DSZiliIk4NnwxtIHphGbZQchqW+IS1vJ/u8aRhK3AMJdqHwGMruyC4+0vx2AfG/iAPahPceLqSmm/U2xtMG+fe605I2lS9MRKkVTC7EE6L6piaQYpKJV2By/M9OiI0pkH4AmH/eeyBF5HBlKohtydFnD9tIWb4Kr5D83McUqpV5J2czougbqy0pLS3PqpoS/3AgEnTi4CgQv+mJ5ovfNEL8/gN8xk9Jm2dWqAGjRl/18lUTiLrIaCkAWSKbDY5hCdPTGITFjARgDIp4NYpCk6FPS1iBhXIrsrLfnKPt47pxrJdZETmMMqnunr33E13ZMmBAoc1HJtWhIPhIKAp77xC/iqstN6HIMqsNTm/Q1YRWvM+nWl9LtCOdTacCelEwCXCsHhX7lD/Rzqs9b9t34C5GuaNoaHEZAMTKYMaUpgsthN3f9VcrAZtfhIkkdlcPi71IzD5z55Y3P15PnytvQl2CcOrumtUeF5D0zB5lCNV41e8xDzW4RV7KUKtu4NMRZ3QPmW4FXdHeNrb3dAcRte/DasejvruWHPKGITpJDiJIXpvkVxynSWsAB4ADTzzwJYMH5/GMILOG4Q2o9zessYpX9FO4
 5LNaZamE
 JaO1Ey8bQZz5RqeG+fa/WOYH9fy3yJ3pVRlMQgsS3Q3kSsAOON+SvdWnG9H9yMxKc4TJmuVz7IDsT7vG4weM9aIxy5Tae3glilF/n00XyY7Qff9roca3/C4dEmeqjB8IPcAit37lEzFOSTCIy236gqIfqfowA78PBYtp+iE8TOP9WoCJsy7rAzKJh1C1GAVM/mxZdQv+6g86+3L3PcPScqVXYp+BHZd9DgFOUndvW+zSOGvWY2R9C6dEolt6J12HAoD2pyR42yAWWvDF1hWltSNAhQstro6IYTFZ2ozU9NF97wJGyMg8qM0KEO0DMhEgc0LWcoHnAymL9sLzV8RBSumpnqRmpnOaOSwi93mCr/+LAd7LsL80O5Kt4+ecDlsZ932lFG4sWbDN4U1BdF0t5tuaXOfAQFWXxTqcUAkeA2ANiH8mgmsfwa2UADQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_simple_write() already hands ->write() a kernel copy of what was
written but makes that copy with the entry pinned. Let procfs make it
before it pins the entry instead. That covers everything created with
proc_create_net_data_write() and proc_create_net_single_write(), the
afs files and the rxrpc stats.

So a write to a proc_create_net_single() file without ->write() can
fail with -EINVAL or -EFAULT now before proc_simple_write() gets to
refuse it with -EACCES.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c  | 15 ++++-----------
 fs/proc/internal.h |  2 +-
 fs/proc/proc_net.c |  4 ++--
 3 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 4f1f83e9f288..5e2ed5a04ec9 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -947,26 +947,19 @@ void proc_remove(struct proc_dir_entry *de)
 EXPORT_SYMBOL(proc_remove);
 
 /*
- * Pull a user buffer into memory and pass it to the file's write handler if
- * one is supplied.  The ->write() method is permitted to modify the
- * kernel-side buffer.
+ * Pass what was written to the file's write handler if one is supplied. The
+ * ->write() method is permitted to modify the buffer.
  */
-ssize_t proc_simple_write(struct file *f, const char __user *ubuf, size_t size,
-			  loff_t *_pos)
+ssize_t proc_simple_write(struct file *f, char *buf, size_t size, loff_t *_pos)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(f));
-	char *buf;
 	int ret;
 
 	if (!pde->write)
 		return -EACCES;
-	if (size == 0 || size > PAGE_SIZE - 1)
+	if (size == 0)
 		return -EINVAL;
-	buf = memdup_user_nul(ubuf, size);
-	if (IS_ERR(buf))
-		return PTR_ERR(buf);
 	ret = pde->write(f, buf, size);
-	kfree(buf);
 	return ret == 0 ? size : ret;
 }
 
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index da246c5ed4bf..1d36fe4b1af5 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -344,7 +344,7 @@ static inline bool is_empty_pde(const struct proc_dir_entry *pde)
 {
 	return S_ISDIR(pde->mode) && !pde->proc_iops;
 }
-extern ssize_t proc_simple_write(struct file *, const char __user *, size_t, loff_t *);
+extern ssize_t proc_simple_write(struct file *, char *, size_t, loff_t *);
 
 /*
  * inode.c
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 9973f846c467..b78d627b024f 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -77,7 +77,7 @@ static int seq_release_net(struct inode *ino, struct file *f)
 
 static const struct proc_ops proc_net_seq_ops = {
 	.proc_open	= seq_open_net,
-	.proc_write	= proc_simple_write,
+	.proc_write_buf	= proc_simple_write,
 	.proc_release	= seq_release_net,
 };
 
@@ -186,7 +186,7 @@ static int single_release_net(struct inode *ino, struct file *f)
 
 static const struct proc_ops proc_net_single_ops = {
 	.proc_open	= single_open_net,
-	.proc_write	= proc_simple_write,
+	.proc_write_buf	= proc_simple_write,
 	.proc_release	= single_release_net,
 };
 

-- 
2.53.0


