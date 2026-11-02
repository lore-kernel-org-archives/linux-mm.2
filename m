Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39D0D607A885
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B3KPtGIP
Received: by kanga.kvack.org (Postfix)
	id 4DC2E6B05D4; Mon,  2 Nov 2026 09:53:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 465F06B05D5; Mon,  2 Nov 2026 09:53:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356586B05D6; Mon,  2 Nov 2026 09:53:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 101BE6B05D4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:53:44 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5F7C1C1012
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:53:43 +0000 (UTC)
X-FDA: 85390473126.22.90563AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 059E040005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:53:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B3KPtGIP;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1qgL1NkV0P+SHvidYZZZVaI2a05IzcudOOYTRjrcE88=;
	b=VeDZS9SBnsRsyEQjDFBhbV9IbYwJ833zlGesjw08YsQsdevgdpJgfZdnVnvlMVTMrq0D/i
	C89Uc24pL8RWm8o3cAb96/ti8wes1nchCrWpz4nGikwB1D6GcPoq0eQkjblPWkP777I1MA
	KZgy5Pz9qtK8ZLkMrcdmMKQ80BrzdX8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B3KPtGIP;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631222;
	b=73Q0sctMCZRGlFlLI6vABLgCRc2z97s+LLhAyGbBOmCRn2weHDcqkiLGCRmfN/E5tEax6C
	RvDmib3/0VzGTy2rPsExbLSOwyMQ7Hg8yorv6vtUZUTcmlMC7S9ww5+9l8Q2UkZzZiOyzk
	LmSJADh7QLfcnR5wAO/DaNXrZ6n5t2A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 927EB602A8;
	Mon,  2 Nov 2026 14:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625C81F00A16;
	Mon,  2 Nov 2026 14:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631221;
	bh=1qgL1NkV0P+SHvidYZZZVaI2a05IzcudOOYTRjrcE88=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B3KPtGIP7tGmYNWXeX+H1i7tzVg1QuBKxBa4wYZl9yFfxSPwV/nb6la4JTArPoEWx
	 ykM6GuLSG4T3qFKBXJYZCkJGC3vo8ibb5AaiCteOj34CmMoEHIQ9jN+136jYWHeTth
	 F1T67wbusbZFJFAB68aEdSrwP7ELsjghDN+oafO9DTOUCxgQLH239365ae129l0kUM
	 nRwyjSkChWEnrjfxrrWb5DyXYYNqiMK3X+fZLo7P3uKVMTCCcTjvGOV03/bfp2Z8WD
	 FOtEMf9oTbUWnSFUeeH5hrLQ9dj/aKDWVT6F7HwyJbdDISBaRlBZGt5VGMwbWH7Jme
	 DcXRqIaFfxaXw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:48:52 +0100
Subject: [PATCH RFC 12/16] proc: copy in writes to the network namespace
 entries before pinning
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-core-v1-12-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
In-Reply-To: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 059E040005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 5mq36dbwi5anp8dmk3me99hwjhy1bk5p
X-HE-Tag: 1793631221-624946
X-HE-Meta: U2FsdGVkX1+DqW24Riu+GCQIt7QShkC86XwOvmDo1CJDK2GfUGgOOMA6GYpZewnboANHN/Nr8mrS0GHbWA81mpC8t7tdqpTA6ku9vYeEJNmIseLa7i1Yw5vOF4AtbbAL2G9I1sSbxJ9JmrCKnIUdzVfC7Yq1P017uquJiKCVwNTXYj06srw7O0cZIfsYCO6tCRQgfTJFwV2InP+5bCALydwQQcvT/Mdjar8ml7EJ/rbvQH/8MlwkRJu+GyuFJm43/uQsrC9rYKmNJuZBearUnDOb/Vpx+IEem9iklzYh5F7hVdRktB0m9ylZX7cut9TBObOIrdMbUF+j6zlz4CSA2h92rs+cy5fMA9xSCqPpgdk17zAU6E6KZLSIhg3NLRDrXg0Y6i3tckUi+fc6pkSYY/CCgsUSn/AeCN+pdyIhX6y5rNaw6hYY2nkxSP11Gx3cVGES0DrWzGWRNn4A4LwrOgxZpXjQtKltE5TM38X381TuIP4jqpwpXLATuXdMPmVF8eoLftShuT1SFcnaPMd2gBNkPB+7fIt+bCEJ6PIVW0M065FHuJVuLMJcLHMD+ZFxMLmaWLD8iryDHekPljxalcMFQ6ZPvVh0hEF6NvNmElrUgAuL94LdH5OhhL/YuXVf9WSfcvFpO/kX6he9U9NznAEuL/CLiqU6UdYCZsJT2CbnFprLrET6n9rIi0PctuMx4ZQkTUk7pTcbI0L3figOYzjvLOcqf0o9O9CvW2gvfu4BF+P4I0iTCeXTjBQ1OEeOLva4Wmq8uWSGySjHWv8TQP0CY1dxM7H/4nVjilVxg7XJLcdUTxButwXtY6bmzOxjNQG2g3AyaP3Us2r8J9YN+dq4J4CNpudt2TfBxsAjiwEdkTTtrJdTgD3PLLfsH2skmSCE1lx46ZKN8f/e/HKdTLTa3dP+ZnctuqRI6alxO8aUPxqaCWzKgZ8lVb/rnqqCDT2XK6QzOVBknxaFa0w
 hX7tIFTN
 /IdbxUYIcrCvxyF6/R1LYNLiNKhAacD+y2mVrpSbJhMKz2JHIFPf40YM0ewug0zXn2yGdcDkTRTxzbVHXxHaLL/n9/nsuakMC8YkQIHdGmlLGrQEYoi+ilNpApXxgC3noK1u2r1gVL1HThAeCzShVBrzjcbV7GN3UvsjOqEt7oaPH+h2j6m0VNhLLVIadBo7PBLKZ4Co2aebvhfFhs0Pi14oypinrmrVCPjKYXtVZH0+Bn2IHXS8tOw2SCuTGV2/5Sm2Ui1vsFq6EX9NcDl/YgGDXWj9zMmkUMfVxPgRmuv8rvrOivwKtfBGaiF1Yax2kXYPV
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
index 7dc7df101286..83d273778a60 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -904,26 +904,19 @@ void proc_remove(struct proc_dir_entry *de)
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
index 80b346a3299d..ed22c6dfb0bf 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -317,7 +317,7 @@ static inline bool is_empty_pde(const struct proc_dir_entry *pde)
 {
 	return S_ISDIR(pde->mode) && !pde->proc_iops;
 }
-extern ssize_t proc_simple_write(struct file *, const char __user *, size_t, loff_t *);
+extern ssize_t proc_simple_write(struct file *, char *, size_t, loff_t *);
 
 /*
  * inode.c
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index fa485581d05e..cdeb2e025d2e 100644
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


