Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3792C60BDA3B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M5RO5Q8k
Received: by kanga.kvack.org (Postfix)
	id 459586B05CA; Wed,  4 Nov 2026 16:16:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4311F6B05CB; Wed,  4 Nov 2026 16:16:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3474F6B05CC; Wed,  4 Nov 2026 16:16:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1386B05CA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:16:34 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A22F5A814F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:16:33 +0000 (UTC)
X-FDA: 85398695466.04.2ECDFAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id CCA7212000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:16:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M5RO5Q8k;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793826992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z1ZOJsRk1XloR8+X/iuIjf2Funsf7/y+/bk4jcaChHA=;
	b=Y7th1fE0C0CwuenI4bXSLdqoNTthVb4Zd0Kh6nSWZYdiVGaIARExR0LySqRGS6eyxENdaT
	zikkfTgLx6vn1/jEOieaaoCqjeO1WsPCQy9gbFoMSgnurbLux7ijZweMK0QVWPkAiLGtyr
	NVkFVOAfh8gjSnyWJziSTDa5DevPRds=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M5RO5Q8k;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793826992;
	b=CvWaxDG2N4B/aN56uX6BRtLXv2wCFtmIRMtm/z4rTyscdqy89lbNNTTi6WXSGmwUw7xQqA
	ON3eMLQkm48MtRkvcg6XvvJW52FnBO8EXSpiNGWupaMpw7D3Xj/in/NoPtuydht5YdUzhT
	fco7tRyHhKufrUlYZ55jgwRNSd9qgis=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 234F143BBB;
	Wed,  4 Nov 2026 21:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C8C1F00A17;
	Wed,  4 Nov 2026 21:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793826991;
	bh=Z1ZOJsRk1XloR8+X/iuIjf2Funsf7/y+/bk4jcaChHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M5RO5Q8kBtwDno+ViL1y5BXewnnzbSUiD0Ia6wQ1ZDr5urhi8E89jYOlntRIgMa6v
	 r9RG9WmdIkXzJfLAx6IEAN4oxhymXK8NsuNUBDZD3nMRrupGitCaAlM5t0w1l3kDgL
	 mARlOJCbNgn+LG3omXIPOAWaGFV2e55MLLVLTjfJkon0ltiDwAfT1Rt1ryiES87BRl
	 cEGRifGzsCYmn1JslL4AfUjzCoN8zMhn9yu3J19mR1xJZ8GjCByKe2bS2hgjUJtRn4
	 /Ud57A9OrseLYf/NwNssA42XtxJOU93lZkF6vGX3KXvmVx1xxIECpGp59Xx8FusjIn
	 0mcxJDl2Ikwlw==
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
Subject: [PATCH RESEND v2 4/6] proc: drop ->proc_read() and ->proc_read_iter()
Date: Wed,  4 Nov 2026 22:16:16 +0100
Message-ID: <20261104-work-procfs-cleanup-v2-4-1e6687e226b1@kernel.org>
In-Reply-To: <20261104-work-procfs-cleanup-v2-0-1e6687e226b1@kernel.org>
References: <20261104-work-procfs-cleanup-v2-0-1e6687e226b1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7998; i=brauner@kernel.org; h=from:subject:message-id; bh=abGcIl8EeF+AIW6UdJlLnKo66cLyls2IFZNMcomaikg=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9XpBYNFfA2KRJOfDTZK74ZD22FKmLHxed5Kk6wORr/ ZpL4dihjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIvYMTIcWimfoSnAVe9ge+Os 4tXw7JYtfefvJm1XPtb7fo/MxUtiDP9MH79h+uV3N1BJ9vml5a5/Vp2Wkxe2lT1h7Fs82/qXzEd WAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xkjqbeuxqxe714gis6xjgo61jaghm9wk
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: CCA7212000A
X-HE-Tag: 1793826991-905134
X-HE-Meta: U2FsdGVkX1+WX7sRjb6jmoZG2nW+J3HW/9W3HruIPTexTRfhZzw+EtvSnXQMIoxffRISxnm/SkytmrgV+WnUbguERm2T94EINI6d3v123IhvwJDxbx7zKQfaaTvlIyLjy88hRrlrjDX+O0RQFhv0p5nUCYJelNj/rKx4t2/4hzMWulKQPYrJjb2SFcwaqEAWZBZh2Pa7v1hXMEJxDxGO96QEBoez2HMQo6QzOC+fk3HzSf2VpQrM2jNLnOb933tOp4f772Qfe4kl6wYsOcof5rYcEoQqfb8SN+S8AjoY5ZRqYROr2fAUlcQCQUjtbnEF0TpvRMagva0tXPWnQVZ2UvSkgScpgdcaovOL+luAKbFkYI29vMLqJeP6GlJ6xHunl0K7z7dHrdR/x87hPn77FvXGrrXMU/5H6Yt5YuOU9lWVo6PujHTmrZJ41gAkUGDbK+SlboVVUK/UF9abDGuEkF2JS10ad1yyXnGQWS1LvHhRY1FQKkjKidoYInhUP/cKdbvDj8GEBXF0F5FKOKIQAT84I0s1EPgMeZOOZZgkgNp5Ro0COaU5lPV1uvbgRi6if3xz/AqvUze11XYeqKHNZmooIp2LMjdo6aSRHKDtjJHcazTeuYenzvRGBayPtfQQm2RqWrEGKS00vtAItmBHb0zdBcEExw8uoA7glabtKOvjmzCr/vGV1Tj4waac1oxXRZ2qlku9pGjJyJ1KLTBgme533HWmiomBAERz4cCdpT0czXQVahZXbQoV2E9++RjmcLhETdSMWY4qK/pm4A7CNV7Kp42izcbkv+eisZjpalqa5caT34dovgEdtkqW7Y2xYXN6aexJ9inTe48D4HsZPVyE3s74/UcKlzoLVweVQZ31Y6snQd1AGGlEPXgTW85sQ0k8l9apDGyol0ohT9Cs8GaHhC7mBQ5MXTTv5+5oZloSXQtPQO287Mon1Fv8mjlh9SNMXr6SVv5rAIbhUgz
 hEDH8gW6
 TfD+O12W32l+1kXpZ9GYeojL3ofSkH2kEotrDlMjvj80QFroXsGStPqdPOAHeYbafvE2KbuGz9NeGVz91ArW/XWsh0R9E9pTR5PaqYJe+NmVd4e86VWgNH8h/canCQWjIiJtU2TDwZUDAgsvVHxE6sjCLy278+NUmE6W8Swt6NiNzF/K2fkyV3TmRawfWGVEKV5mDTbzQc+W6Q7Oymx6ShHba8TDJlQBxkN7p/sIGD5K7yw5VmLoDZgVPnOuJirPTOv5V/QAQ6e1OuQwe1tqPBTKKEkAG+9UOFoFXst/fHN0COnylJMVW0PoeM1/stTeWC+opNDqZhB7p1zE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Nothing implements them anymore. Every entry that can be removed fills
procfs' buffer through ->proc_read_buf() or is a seq_file entry, and
the permanent ones that still read straight into userspace have
file_operations of their own now.

With them go the flag, the registration checks that kept them apart
from ->proc_read_buf() and the seq_file entries, proc_reg_read(), and
two of the three sets of file_operations for regular files:
proc_reg_llseek() and proc_reg_read_iter() hand a seq_file entry to
seq_lseek() and seq_read_iter() themselves now, like
kernfs_fop_read_iter() does, so one set serves every entry that has
proc_ops. That set has ->splice_read(), so a splice() from an entry
that can't be read at all, a write-only one, fails with -EIO now
instead of -EINVAL.

Nothing in struct proc_ops takes a __user pointer anymore.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c       | 14 ++++------
 fs/proc/inode.c         | 69 +++++--------------------------------------------
 fs/proc/internal.h      |  5 ----
 include/linux/proc_fs.h |  4 +--
 4 files changed, 12 insertions(+), 80 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 4e0142fec582..2515df3a0110 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -454,8 +454,7 @@ static int pde_set_flags(struct proc_dir_entry *pde)
 	}
 	if (pde_is_seq_file(pde)) {
 		/* procfs reads and seeks through the seq_file itself */
-		if (WARN_ON_ONCE(proc_ops->proc_read || proc_ops->proc_read_iter ||
-				 proc_ops->proc_lseek))
+		if (WARN_ON_ONCE(proc_ops->proc_lseek))
 			return -EINVAL;
 		/* and frees it, see pde_seq_release() */
 		if (WARN_ON_ONCE(proc_ops->proc_release == seq_release ||
@@ -463,11 +462,8 @@ static int pde_set_flags(struct proc_dir_entry *pde)
 				 proc_ops->proc_release == single_release))
 			return -EINVAL;
 		pde->flags |= PROC_ENTRY_proc_lseek;
-	} else {
-		if (proc_ops->proc_read_iter)
-			pde->flags |= PROC_ENTRY_proc_read_iter;
-		if (proc_ops->proc_lseek)
-			pde->flags |= PROC_ENTRY_proc_lseek;
+	} else if (proc_ops->proc_lseek) {
+		pde->flags |= PROC_ENTRY_proc_lseek;
 	}
 	if (proc_ops->proc_poll)
 		pde->flags |= PROC_ENTRY_proc_poll;
@@ -482,8 +478,8 @@ static int pde_set_flags(struct proc_dir_entry *pde)
 			pde->flags |= PROC_ENTRY_SHORT_WRITES;
 	}
 	if (proc_ops->proc_read_buf) {
-		if (WARN_ON_ONCE(pde_is_seq_file(pde) || proc_ops->proc_read ||
-				 proc_ops->proc_read_iter))
+		/* procfs reads through the seq_file itself */
+		if (WARN_ON_ONCE(pde_is_seq_file(pde)))
 			return -EINVAL;
 		pde->flags |= PROC_ENTRY_proc_read_buf;
 		pde->read_size = proc_ops->proc_read_size ?: PAGE_SIZE;
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 49ae30b6e515..9719c1b89de3 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -413,6 +413,9 @@ static loff_t proc_reg_llseek(struct file *file, loff_t offset, int whence)
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	loff_t rv;
 
+	/* procfs seeks through the seq_file itself, see pde_seq_start() */
+	if (pde_is_seq_file(pde))
+		return seq_lseek(file, offset, whence);
 	if (!pde_pin(pde))
 		return -EINVAL;
 	rv = pde->proc_ops->proc_lseek(file, offset, whence);
@@ -477,37 +480,15 @@ static ssize_t pde_read_buf(struct proc_dir_entry *pde, struct kiocb *iocb,
 static ssize_t proc_reg_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(iocb->ki_filp));
-	ssize_t ret;
 
+	/* procfs reads through the seq_file itself, see pde_seq_start() */
+	if (pde_is_seq_file(pde))
+		return seq_read_iter(iocb, iter);
 	if (pde_has_proc_read_buf(pde))
 		return pde_read_buf(pde, iocb, iter);
-	if (!pde_pin(pde))
-		return -EIO;
-	ret = pde->proc_ops->proc_read_iter(iocb, iter);
-	pde_unpin(pde);
-	return ret;
-}
-
-static ssize_t pde_read(struct proc_dir_entry *pde, struct file *file, char __user *buf, size_t count, loff_t *ppos)
-{
-	const auto read = pde->proc_ops->proc_read;
-	if (read)
-		return read(file, buf, count, ppos);
 	return -EIO;
 }
 
-static ssize_t proc_reg_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
-{
-	struct proc_dir_entry *pde = PDE(file_inode(file));
-	ssize_t rv;
-
-	if (!pde_pin(pde))
-		return -EIO;
-	rv = pde_read(pde, file, buf, count, ppos);
-	pde_unpin(pde);
-	return rv;
-}
-
 /*
  * procfs copies in what is written before it pins the entry. A writer that
  * faults on its buffer then doesn't hold up remove_proc_entry().
@@ -923,41 +904,7 @@ static int proc_reg_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-/* For seq_file entries, see pde_seq_ops. */
-static const struct file_operations proc_seq_file_ops = {
-	.llseek		= seq_lseek,
-	.read_iter	= seq_read_iter,
-	.splice_read	= copy_splice_read,
-	.write		= proc_reg_write,
-	.poll		= proc_reg_poll,
-	.unlocked_ioctl	= proc_reg_unlocked_ioctl,
-	.compat_ioctl	= proc_reg_compat_ioctl,
-	.mmap		= proc_reg_mmap,
-	.get_unmapped_area = proc_reg_get_unmapped_area,
-#ifndef CONFIG_MMU
-	.mmap_capabilities = proc_reg_mmap_capabilities,
-#endif
-	.open		= proc_reg_open,
-	.release	= proc_reg_release,
-};
-
 static const struct file_operations proc_reg_file_ops = {
-	.llseek		= proc_reg_llseek,
-	.read		= proc_reg_read,
-	.write		= proc_reg_write,
-	.poll		= proc_reg_poll,
-	.unlocked_ioctl	= proc_reg_unlocked_ioctl,
-	.compat_ioctl	= proc_reg_compat_ioctl,
-	.mmap		= proc_reg_mmap,
-	.get_unmapped_area = proc_reg_get_unmapped_area,
-#ifndef CONFIG_MMU
-	.mmap_capabilities = proc_reg_mmap_capabilities,
-#endif
-	.open		= proc_reg_open,
-	.release	= proc_reg_release,
-};
-
-static const struct file_operations proc_iter_file_ops = {
 	.llseek		= proc_reg_llseek,
 	.read_iter	= proc_reg_read_iter,
 	.write		= proc_reg_write,
@@ -1026,10 +973,6 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 		inode->i_op = de->proc_iops;
 		if (pde_has_proc_fops(de))
 			inode->i_fop = de->proc_fops;
-		else if (pde_is_seq_file(de))
-			inode->i_fop = &proc_seq_file_ops;
-		else if (pde_has_proc_read_iter(de) || pde_has_proc_read_buf(de))
-			inode->i_fop = &proc_iter_file_ops;
 		else
 			inode->i_fop = &proc_reg_file_ops;
 	} else if (S_ISDIR(inode->i_mode)) {
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 84c5c13651aa..0a22237e6778 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -103,11 +103,6 @@ static inline bool pde_has_proc_fops(const struct proc_dir_entry *pde)
 	return pde->flags & PROC_ENTRY_proc_fops;
 }
 
-static inline bool pde_has_proc_read_iter(const struct proc_dir_entry *pde)
-{
-	return pde->flags & PROC_ENTRY_proc_read_iter;
-}
-
 static inline bool pde_has_proc_lseek(const struct proc_dir_entry *pde)
 {
 	return pde->flags & PROC_ENTRY_proc_lseek;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 05e0d6e4f918..9c09766b8f72 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -17,6 +17,7 @@ struct seq_operations;
 enum {
 	/*
 	 * All /proc entries using this ->proc_ops instance are never removed.
+	 * procfs calls into them without pinning them.
 	 *
 	 * If in doubt, ignore this flag.
 	 */
@@ -26,7 +27,6 @@ enum {
 	PROC_ENTRY_PERMANENT		= 1U << 0,
 #endif
 
-	PROC_ENTRY_proc_read_iter	= 1U << 1,
 	PROC_ENTRY_proc_fops		= 1U << 2,
 	PROC_ENTRY_proc_lseek		= 1U << 3,
 	PROC_ENTRY_proc_seq_ops		= 1U << 4,
@@ -76,8 +76,6 @@ struct proc_ioctl_arg {
 struct proc_ops {
 	unsigned int proc_flags;
 	int	(*proc_open)(struct inode *, struct file *);
-	ssize_t	(*proc_read)(struct file *, char __user *, size_t, loff_t *);
-	ssize_t (*proc_read_iter)(struct kiocb *, struct iov_iter *);
 	/*
 	 * mandatory unless nonseekable_open() or equivalent is used, procfs
 	 * seeks seq_file entries itself

-- 
2.53.0


