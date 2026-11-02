Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A8E96079A8C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k2L6lcib
Received: by kanga.kvack.org (Postfix)
	id A81B36B05D3; Mon,  2 Nov 2026 09:53:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A315C6B05D4; Mon,  2 Nov 2026 09:53:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9222C6B05D5; Mon,  2 Nov 2026 09:53:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 640C66B05D3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:53:21 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3AF514014A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:53:20 +0000 (UTC)
X-FDA: 85390472160.17.5EF1B64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4E5E3C0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:53:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k2L6lcib;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SuIwn2r98IWfqwTZEZpGxulO+eCOsS/OzPuASS7qjfQ=;
	b=h2Xt0BEcVYIC7ahmnuQi7QI56ODgNSTiQcOVhuoPpP/67ZctQ5Na9DuIkign15I8m0KqbR
	8Ls+WhW49mQ491eDKIpfbRud1qSG7bZNY3gsrBM26bfebmFEdY+w8Pq5dAEtXZI3Rj4Aas
	TFimfuc4vKBh2vKEdY4tYJiNh+jhCXg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k2L6lcib;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631199;
	b=IM4eGm5dlWIPVdr4xlnVJdLlmAL86TjuiX1abcqC1LOw6z1pokb4nWFA6o5Mcxefq8vlZw
	kzqQcX7ymXNBimTtcAJHmyRo+qYcpzwJGErm774p2mHvCxAhhdsypqGBIo3d2bxvau1TWl
	fUjAOi3g9At2cUmdTZ7u+az5iYFxQWY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E3B78601E4;
	Mon,  2 Nov 2026 14:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3261F00A16;
	Mon,  2 Nov 2026 14:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631198;
	bh=SuIwn2r98IWfqwTZEZpGxulO+eCOsS/OzPuASS7qjfQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=k2L6lcibhhKdv5bNLuwXbZmsfwzqvWwfwfZBS/eCf10awP60Wjanun9ZPK7oQruFW
	 KAcLZA6ECIFhwbDmPQYeBgLo1RfEogbBQHv4UEPmeTClP1/TCKc2QeEax047wQdumO
	 W0YE3jPgoRd/LmLaUtzca4qSMLcaei0NK+lXWxavlWmeeyNH5nmuwBkbR0kVT1sHQn
	 ZsMYcO881dzVUBN/9pT74wlmk+ab9wqr2yJQ2aCxtEgQ3a76we2PDn3LnSGHPCJ71W
	 l/Ayog1x0iLUa25PHtbJu1dJlwcPaGZm3EPOMbWysr+KgooO5mZVhjlchoAznOAeVa
	 tYwRxP451ni0A==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:48:51 +0100
Subject: [PATCH RFC 11/16] proc: let procfs copy in writes before pinning
 the entry
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-core-v1-11-75df35e4f8b8@kernel.org>
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
X-Rspamd-Queue-Id: 4E5E3C0005
X-Stat-Signature: u34ouh3gkkf1i53py4h8hbkegyro1id5
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793631199-600633
X-HE-Meta: U2FsdGVkX1/TZH81FLqPiKp9qopDuo2Fum5isdBHeIQRpDpobN2fg8AaJTwzSgxuwY9q3r1HTAV+ZhXcvVH5zOmX8MpF7r1QrG1m5n89JQQ5qWQ5nJgkIPKWAFI4mBY0sdUh2jPVxaHrzkXiRI6t9iNs5hMat/CYHrs4f1d1MBC9TwtFAHLJEyRwwAvbukySL+CQX5rWsdIZP7CENVPPo1/Hsum20pW0qYrQuc48V4P7Mxcg48wNyUujn22CEwfICzqNlHEv3O4wbCvqkD9gm0CRI//dRo4ToJ3k4I0Pwtp+/IIHJOPb3SYB8abC7gdMDlsTgmNf3RxlpT3IkXo5GHyX0Xz3J10wHIlvyCkqs4yK29JXXnslSqrrNko0V9AetpXZcV8tFgzV0z/z+od7sbmFZxk56i76P1HpMCIKBzCRdzJ/JrMkY9RnM+7cVdmC3VhBhV1uKX6ffwElTUFqwHut34jzo2c2F3T1Nd0nmu46E8/SRRZOBAYAfWRYvDgTFLRFVTd+Rq6NBboG2t6MbX60Sp1lb0bHbZYL00gKXBPU/4bva4napRkOGsJtxBhBRst7LArVbLeKhtHziKR8+7P89a11Q50PmCE27od5huYvaU1ztPFJLfABKk9kJpab/UQ5Qfe2YCmcp0OSLJ+mZAm8DdemU6GqcxE1vJaKV/8USKGd5mKuBNi6m8TlwcL2gRrp7UbUVWlsWhxEt4uh9R0A+ZVO36R4ZCM6se/8q4J+31rHPVT3dQxM0FHynmZdDkWO/q8oRimHDwKnwDMxF05/rVWAyilL5C+uZyNB8aZMWzcKFfmC/4DhKMb3Syg2rIiIjxaei0FJGTeGYbSym20hbnE8gAqq6VZMyKtBKhYyso2EaJeoYPVhv/U55c2HoUdEYUjJlOoFeFlN+lPrt6/SG+Ht5WXkcVXjLB2YLYMQeQ2jDtM9Mct4HF1wfF6NFOcWu/SM7k6yghXEgeE
 MvxVylTx
 kNTUh/Q5+pIXbMnOTugD/zNyyZnk3QNAIwOVQ9U3LMzm6nwxEWm6NZDq+nsvzGo1h2udkAYg2Z0gls3JLfH7i3fyTUrIbjqwXa8/ffLX6qObRH6c4iWSZRwOZFUblDumtK1LppRSZ8+5kYZxlUd/orOFyxa/P2/m0+3mE4/mLXtflc4SVxJ8Y3+nunsPskDvx+0Z7IoCsZEZ9Z6kP3IPdt+PlAmeWpel9ZProCr5BhCsYHl1pXeS9GM1fGdt7AJrQje+c7c0GYHTdPEregKFu5vc7uNj/R7kRYHG3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_reg_write() pins the entry and calls ->proc_write() which copies
from userspace itself. A page fault in that copy can take as long as
the writer wants, just like the copy to userspace of a read, and
remove_proc_entry() waits for it.

So do what kernfs does for writes as well. An entry that implements
->proc_write_buf() gets a NUL-terminated kernel copy of what was
written. procfs makes that copy before it pins the entry. The copy is
capped at ->proc_write_size bytes, or at PAGE_SIZE - 1 like
proc_simple_write() if the entry doesn't care. Larger writes fail with
-EINVAL. The proc_ops go away with the entry, so procfs remembers the
limit in the entry when it is registered, like the size of the seq_file
state, instead of pinning the entry just to look up a number.

Entries that take binary data in pieces, like the PCI config space,
ALSA's data entries or a firmware image, can ask for
PROC_ENTRY_SHORT_WRITES instead. procfs then copies in the first
->proc_write_size bytes and the write comes up short.

->proc_write_buf() gets the position like ->proc_write() so entries
that write at an offset keep working.

Note that procfs copies in the whole write before the entry looks at any
of it. So a write that is too large or whose buffer can't be read fails
before the entry's own checks run, permission checks included, even
where the entry only ever looked at the first few bytes.

An entry that implements ->proc_write_buf() and still has a
->proc_write() fails to register.

No users yet.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c       |  8 ++++++++
 fs/proc/inode.c         | 33 +++++++++++++++++++++++++++++++++
 fs/proc/internal.h      | 11 +++++++++++
 include/linux/proc_fs.h | 17 +++++++++++++++++
 4 files changed, 69 insertions(+)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 6ed8bc313db0..7dc7df101286 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -468,6 +468,14 @@ static int pde_set_flags(struct proc_dir_entry *pde)
 		if (proc_ops->proc_lseek)
 			pde->flags |= PROC_ENTRY_proc_lseek;
 	}
+	if (proc_ops->proc_write_buf) {
+		if (WARN_ON_ONCE(proc_ops->proc_write))
+			return -EINVAL;
+		pde->flags |= PROC_ENTRY_proc_write_buf;
+		pde->write_size = proc_ops->proc_write_size ?: PAGE_SIZE - 1;
+		if (proc_ops->proc_flags & PROC_ENTRY_SHORT_WRITES)
+			pde->flags |= PROC_ENTRY_SHORT_WRITES;
+	}
 	return 0;
 }
 
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 8425465aae5d..c0bb40e7ff96 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -440,11 +440,44 @@ static ssize_t pde_write(struct proc_dir_entry *pde, struct file *file, const ch
 	return -EIO;
 }
 
+/*
+ * procfs copies in what is written before it pins the entry. A writer that
+ * faults on its buffer then doesn't hold up remove_proc_entry().
+ */
+static ssize_t pde_write_buf(struct proc_dir_entry *pde, struct file *file,
+			     const char __user *ubuf, size_t count, loff_t *ppos)
+{
+	char *buf __free(kvfree) = NULL;
+	size_t size;
+	ssize_t rv;
+
+	size = pde->write_size;
+	if (count > size) {
+		if (!pde_has_short_writes(pde))
+			return -EINVAL;
+		count = size;
+	}
+	buf = kvmalloc(count + 1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	if (copy_from_user(buf, ubuf, count))
+		return -EFAULT;
+	buf[count] = '\0';
+
+	if (!pde_pin(pde))
+		return -EIO;
+	rv = pde->proc_ops->proc_write_buf(file, buf, count, ppos);
+	pde_unpin(pde);
+	return rv;
+}
+
 static ssize_t proc_reg_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	ssize_t rv;
 
+	if (pde_has_proc_write_buf(pde))
+		return pde_write_buf(pde, file, buf, count, ppos);
 	if (!pde_pin(pde))
 		return -EIO;
 	rv = pde_write(pde, file, buf, count, ppos);
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index d8093451524a..80b346a3299d 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -51,6 +51,7 @@ struct proc_dir_entry {
 	proc_write_t write;
 	void *data;
 	unsigned int state_size;
+	unsigned int write_size;
 	unsigned int low_ino;
 	nlink_t nlink;
 	kuid_t uid;
@@ -107,6 +108,16 @@ static inline bool pde_has_proc_show(const struct proc_dir_entry *pde)
 	return pde->flags & PROC_ENTRY_proc_show;
 }
 
+static inline bool pde_has_proc_write_buf(const struct proc_dir_entry *pde)
+{
+	return pde->flags & PROC_ENTRY_proc_write_buf;
+}
+
+static inline bool pde_has_short_writes(const struct proc_dir_entry *pde)
+{
+	return pde->flags & PROC_ENTRY_SHORT_WRITES;
+}
+
 /* procfs owns the seq_file, see pde_seq_ops */
 static inline bool pde_is_seq_file(const struct proc_dir_entry *pde)
 {
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index ea55ed85a2d6..c81c93325044 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -31,6 +31,13 @@ enum {
 	PROC_ENTRY_proc_show		= 1U << 5,
 
 	PROC_ENTRY_FORCE_LOOKUP		= 1U << 7,
+	PROC_ENTRY_proc_write_buf	= 1U << 8,
+
+	/*
+	 * Writes larger than ->proc_write_size come up short instead of
+	 * failing with -EINVAL.
+	 */
+	PROC_ENTRY_SHORT_WRITES		= 1U << 9,
 };
 
 struct proc_ops {
@@ -67,6 +74,16 @@ struct proc_ops {
 	const struct seq_operations *proc_seq_ops;
 	int	(*proc_show)(struct seq_file *, void *);
 	unsigned int proc_state_size;
+	/*
+	 * procfs copies what is written into a kernel buffer and calls
+	 * ->proc_write_buf() with it. The buffer is NUL-terminated and holds
+	 * at most ->proc_write_size bytes, PAGE_SIZE - 1 if that's 0. Larger
+	 * writes fail with -EINVAL unless the entry asks for
+	 * PROC_ENTRY_SHORT_WRITES. The position is NULL for a stream, like
+	 * for ->write().
+	 */
+	ssize_t	(*proc_write_buf)(struct file *, char *, size_t, loff_t *);
+	unsigned int proc_write_size;
 } __randomize_layout;
 
 /* definitions for hide_pid field */

-- 
2.53.0


