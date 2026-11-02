Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4DA6607A895
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KxNpZEKk
Received: by kanga.kvack.org (Postfix)
	id F172E6B05D5; Mon,  2 Nov 2026 09:54:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6F76B05D6; Mon,  2 Nov 2026 09:54:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB59B6B05D7; Mon,  2 Nov 2026 09:54:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4E936B05D5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:54:12 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 519954014C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:54:12 +0000 (UTC)
X-FDA: 85390474344.06.42392D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8B5C340003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:54:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KxNpZEKk;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631250;
	b=NW4JE/Vz0N057fFNsywAzitvC/kihaB/VPwHJTLlY6RTEAx5faMmDV4eHpzfatassyiG61
	DaD1N6VERHUkP5eSsLTQ+VoluMCCxzEo60ymN+uy46uTdav6K1tg/JLKvez6x3BOVn/Pt6
	RxpBhQv/iGT/7b4djy1BOIhrzzehhYk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KxNpZEKk;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6D+rhj9AMzsL4ZxAMbTTFRqO6BNcfNzlOGN8XoIy1BQ=;
	b=TZDvTH2pMsRBpfefHpviiYfvZnG8IHn3UwxxcWnOPgibF0q0BkFajHMP1IGwXF82twtKIl
	2mg2Ygioy41MShtiz238/TlIJp5x+IQDGYz30mVLThkV1otvzxKWOOQQFa7r9CeJuJB3Cm
	Lv19sXB1/7NEpecCxpqUfzK1xD4t8ko=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB68741630;
	Mon,  2 Nov 2026 14:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292341F00A16;
	Mon,  2 Nov 2026 14:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631249;
	bh=6D+rhj9AMzsL4ZxAMbTTFRqO6BNcfNzlOGN8XoIy1BQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KxNpZEKkyph0s1VFnWYugNb2QhC01F2/bH2mO62CWQZ+LGZOjH8D13WJhEvaEvssq
	 ll1kDcMtrg3ROkFYJi4p7/Ri4zQ67sgTvcwZMysRa8udyqg9CDy7DJ1FOKzlD3OUC5
	 hck0+uoaMFl0apM+ydUoJxSpyX1BiEd45EYN5ZcmyZZdhFNON3LUDyLw+HmFRG6kWj
	 hKJyb7cb24m5nGVzK7xwTb/BfbuX6mn66mIH+I2qikOKVjpdkTR++4BkGvLnpQYbfU
	 N42B37TnDt/oZhvY4ym1lTPmywWw6rqu+aAeSl/T4Fq53VdxKX+t4v7df9GH9Jeepm
	 bu9oR3VWn5S8Q==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:48:53 +0100
Subject: [PATCH RFC 13/16] proc: let procfs copy out reads that don't go
 through seq_file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-core-v1-13-75df35e4f8b8@kernel.org>
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
X-Rspamd-Queue-Id: 8B5C340003
X-Stat-Signature: 56trn1b5mqrs3pdiw7xxqo64si1w4muj
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793631250-212968
X-HE-Meta: U2FsdGVkX18MYc7cKWFInnVhxDVI6hMQfbVFdXhtcx8ujnMjezGtCFkzptCIau349oHt7yznCIrczbhnnvd7ZaCErgSWYDiJ3+OR83u7FTfLgsDIKGRyXXrU5S8m2jIP0ohVr69y9uTN31BWKT6MYGwTZWxhh7JR9jqThgL+ajdYMaxJEsRwV3ciRDl5eeXNHTxykKuTaSLk7u9NmFAzRbXyoa5noKdW5vQhAQFmacSdtTgCuZpq9yUek2eVhUOmneVAyhIv6SwiK+Ou+P6J2wYrpwGB/IQNoHAddqTF+1+Vg6d0b1A40WXMsP4gratnoTEACy3wlqeJGVVX7X5okwLqkwDNbJ/qZWFYRGxTmQW+Rt4hJA21ucQpeFQ4Q1zFJl7ZdBCYnRn/pHohz2T+9WMxN2zDUOryQJhb6QPLIQMXpsTl4ibuiiqPHj4IRpGBPel8FVQKTtUridK38hA5Z0TH/RNuBJRkbY2lgPAH2oCMdhlzEsZZxaTlxNbSjTOrFog+hL3YFmm332M0tiopTqi3VS5ks1fbOPPS6C3naKoQyNU3l3onb+WnTSRlxosETqfnWYur/AdA8oczOW+u3bXRCM4Yvg8KlkcUDp+gsmFAW6KYSaqx6OnptDvADxj2wAWUvhSLpl58uCRNWTs9osjbl6sYDVf6OpK42+jjiBw5s3Jq7JYsORix1Dq21mC+TQqM6604gZq4Ih+J7kK2P4FZ07Jq5eOwopgdWGbyNGt2X2lVVkqHqUtf8OYQy05GoOqpu0ThZOwk5U+ItYStm/IWqWs/PqWrW7J+p3nJcXBcxvfhTcBomG2EbmXf4eiBd0nF7ThH9KipXU3TofL26cPzVK+ZWXBCpYkflmxUb+/fYpJrsdN3iNhqLgjucAC4yhFeHOTKmpC52lLfbK5zmYqzUauXgIJLirRMR+x4JFI4hzJSmNuLoW0v1yx/SED1PRltf9vVXlJz3tMH5GJ
 vu/c+x9j
 hui64Z6dd5fgWIbGaOlPOWZO3aCkp0uTqIljq+aAa9nAsSsSStQg8Whm5n1xRtb916VZ0QTD4gOQJlzkjnG++yTQep6Cwe7iL/XjH+Kq6nrUJehRY7dsdpYEBRsqsBV53KwayqH2s6lZVr/krSQ1Z/rTyP8y//St/k6woel7Gj8d4eHu4UAD4v0DAWlDxWFei7TcQpUFfjUVxFNFI3QNRmlmCDis26Oe6nnFkNJHF4EAHdDGug/bjXU9qsZZny7kLUIdZLGvHbaFd+NqHXpBdg0I1RaTMDwTPvYYZi8W+DV3ZXzEGUUqkCkVEvcKSjqJ6V85yiTpcKC6Lxb4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_reg_read() and proc_reg_read_iter() pin the entry and call
->proc_read() or ->proc_read_iter() which copy to userspace
themselves. Like for seq_file reads and for writes, a reader can make
a page fault in that copy take as long as it wants and
remove_proc_entry() waits for it.

So do what kernfs does for these reads as well. An entry that implements
->proc_read_buf() fills a kernel buffer of at most ->proc_read_size
bytes, a page if the entry doesn't care, and procfs copies it to
userspace after unpinning the entry. The entry moves the position like
it did for ->proc_read() but that only sticks if the copy to userspace
worked, like in kernfs_file_read_iter(). If the copy fails halfway the
read fails with -EFAULT and the position stays, where
simple_read_from_buffer() returned what it had copied until then.
procfs remembers ->proc_read_size in the entry like ->proc_write_size.

Larger reads come up short, like with kernfs. An entry whose readers
want all of a large file in one read asks for PROC_ENTRY_FULL_READS and
procfs fills the read in pieces of ->proc_read_size, unpinning the entry
in between. A piece whose copy fails ends the read with what the pieces
before it returned. kexec-tools treats any short read of /proc/vmcore
as fatal for example (cf. [1]).

These entries are read through ->read_iter() so readv(), splice(), aio,
the RWF flags, kernel_read() and io_uring work for them like for the
->proc_read_iter() ones. io_uring's nonblocking attempt gets -EAGAIN
though, like loop_rw_iter() gave it for ->proc_read() entries. Neither
the allocation nor the entry can honor IOCB_NOWAIT, and io_uring would
take a short read of a record file for an unfinished one and glue the
next record to it. So it retries from a worker like before.

An entry that implements ->proc_read_buf() and also declares a seq_file
or one of the other read methods fails to register.

No users yet.

[1]: https://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git/tree/util_lib/elf_info.c

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c       |  9 ++++++++
 fs/proc/inode.c         | 60 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/proc/internal.h      | 11 +++++++++
 include/linux/proc_fs.h | 16 +++++++++++++
 4 files changed, 95 insertions(+), 1 deletion(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 83d273778a60..fc4d10c92d7c 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -476,6 +476,15 @@ static int pde_set_flags(struct proc_dir_entry *pde)
 		if (proc_ops->proc_flags & PROC_ENTRY_SHORT_WRITES)
 			pde->flags |= PROC_ENTRY_SHORT_WRITES;
 	}
+	if (proc_ops->proc_read_buf) {
+		if (WARN_ON_ONCE(pde_is_seq_file(pde) || proc_ops->proc_read ||
+				 proc_ops->proc_read_iter))
+			return -EINVAL;
+		pde->flags |= PROC_ENTRY_proc_read_buf;
+		pde->read_size = proc_ops->proc_read_size ?: PAGE_SIZE;
+		if (proc_ops->proc_flags & PROC_ENTRY_FULL_READS)
+			pde->flags |= PROC_ENTRY_FULL_READS;
+	}
 	return 0;
 }
 
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index c0bb40e7ff96..3f29a1663d26 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -23,6 +23,8 @@
 #include <linux/sysctl.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/sched/signal.h>
+#include <linux/uio.h>
 #include <linux/mount.h>
 #include <linux/bug.h>
 
@@ -400,11 +402,67 @@ static loff_t proc_reg_llseek(struct file *file, loff_t offset, int whence)
 	return rv;
 }
 
+/*
+ * The entry fills a kernel buffer and procfs copies that to userspace after
+ * unpinning the entry. A reader that faults on its buffer then doesn't hold
+ * up remove_proc_entry().
+ */
+static ssize_t pde_read_buf(struct proc_dir_entry *pde, struct kiocb *iocb,
+			    struct iov_iter *iter)
+{
+	struct file *file = iocb->ki_filp;
+	char *buf __free(kvfree) = NULL;
+	ssize_t rv, done = 0;
+	size_t len, count;
+	loff_t pos;
+
+	if (!iov_iter_count(iter))
+		return 0;
+	/* neither the allocation nor the entry can honor IOCB_NOWAIT */
+	if ((iocb->ki_flags & IOCB_NOWAIT) && !(file->f_flags & O_NONBLOCK))
+		return -EAGAIN;
+	len = min_t(size_t, iov_iter_count(iter), pde->read_size);
+	buf = kvmalloc(len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	/* PROC_ENTRY_FULL_READS fills the read in pieces */
+	do {
+		count = min_t(size_t, iov_iter_count(iter), len);
+		pos = iocb->ki_pos;
+		if (!pde_pin(pde)) {
+			rv = -EIO;
+			break;
+		}
+		rv = pde->proc_ops->proc_read_buf(file, buf, count, &pos);
+		pde_unpin(pde);
+		if (rv <= 0)
+			break;
+		if (WARN_ON_ONCE(rv > count)) {
+			rv = -EIO;
+			break;
+		}
+		if (copy_to_iter(buf, rv, iter) != rv) {
+			rv = -EFAULT;
+			break;
+		}
+		iocb->ki_pos = pos;
+		done += rv;
+		if (!pde_has_full_reads(pde) || rv < count)
+			break;
+		cond_resched();
+	} while (iov_iter_count(iter) && !fatal_signal_pending(current));
+
+	return done ?: rv;
+}
+
 static ssize_t proc_reg_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(iocb->ki_filp));
 	ssize_t ret;
 
+	if (pde_has_proc_read_buf(pde))
+		return pde_read_buf(pde, iocb, iter);
 	if (!pde_pin(pde))
 		return -EIO;
 	ret = pde->proc_ops->proc_read_iter(iocb, iter);
@@ -814,7 +872,7 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 		inode->i_op = de->proc_iops;
 		if (pde_is_seq_file(de))
 			inode->i_fop = &proc_seq_file_ops;
-		else if (pde_has_proc_read_iter(de))
+		else if (pde_has_proc_read_iter(de) || pde_has_proc_read_buf(de))
 			inode->i_fop = &proc_iter_file_ops;
 		else
 			inode->i_fop = &proc_reg_file_ops;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index ed22c6dfb0bf..11bd3fa07705 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -52,6 +52,7 @@ struct proc_dir_entry {
 	void *data;
 	unsigned int state_size;
 	unsigned int write_size;
+	unsigned int read_size;
 	unsigned int low_ino;
 	nlink_t nlink;
 	kuid_t uid;
@@ -118,6 +119,16 @@ static inline bool pde_has_short_writes(const struct proc_dir_entry *pde)
 	return pde->flags & PROC_ENTRY_SHORT_WRITES;
 }
 
+static inline bool pde_has_proc_read_buf(const struct proc_dir_entry *pde)
+{
+	return pde->flags & PROC_ENTRY_proc_read_buf;
+}
+
+static inline bool pde_has_full_reads(const struct proc_dir_entry *pde)
+{
+	return pde->flags & PROC_ENTRY_FULL_READS;
+}
+
 /* procfs owns the seq_file, see pde_seq_ops */
 static inline bool pde_is_seq_file(const struct proc_dir_entry *pde)
 {
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index c81c93325044..0f0997898ba3 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -38,6 +38,13 @@ enum {
 	 * failing with -EINVAL.
 	 */
 	PROC_ENTRY_SHORT_WRITES		= 1U << 9,
+	PROC_ENTRY_proc_read_buf	= 1U << 10,
+
+	/*
+	 * Reads larger than ->proc_read_size are filled in pieces instead of
+	 * coming up short.
+	 */
+	PROC_ENTRY_FULL_READS		= 1U << 11,
 };
 
 struct proc_ops {
@@ -84,6 +91,15 @@ struct proc_ops {
 	 */
 	ssize_t	(*proc_write_buf)(struct file *, char *, size_t, loff_t *);
 	unsigned int proc_write_size;
+	/*
+	 * procfs calls ->proc_read_buf() to fill a kernel buffer of at most
+	 * ->proc_read_size bytes, PAGE_SIZE if that's 0, and copies it to
+	 * userspace afterwards. Larger reads come up short unless the entry
+	 * asks for PROC_ENTRY_FULL_READS. The position the entry moves to only
+	 * sticks if the copy works.
+	 */
+	ssize_t	(*proc_read_buf)(struct file *, char *, size_t, loff_t *);
+	unsigned int proc_read_size;
 } __randomize_layout;
 
 /* definitions for hide_pid field */

-- 
2.53.0


