Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8022606F2A2
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I5QLB5cP
Received: by kanga.kvack.org (Postfix)
	id C1EAE6B05D1; Wed,  4 Nov 2026 14:32:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4416B05DF; Wed,  4 Nov 2026 14:32:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4A56B05E5; Wed,  4 Nov 2026 14:32:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 81F856B05DF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:32:55 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08AAFA070D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:32:55 +0000 (UTC)
X-FDA: 85398434310.30.E33ECF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 58D4C4000E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:32:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I5QLB5cP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TEHVy98izX4fxXB98UXZRCAsXp7Vv98/GN00gGR5FH0=;
	b=0ONqOWWBuzvVeRr9IqxsK37YLbMRrR05aOewNXV3gg4D//yRJzzBr6eFpcO6s/NGzRUDJQ
	jKQ2F7FsgGlAqK5y6sPZD5VwvqDP41joxV/x+KXvZ7AxgddBtaRMNfCy1uKt+i/EXsDeBW
	TI89l4x5jTLOJawybNYm8lpclre+fuc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I5QLB5cP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820773;
	b=p3O1LAAsuT14TWCbdPIZy5w+lsxMINQuhaWcnJwYdJBo0d2gxsAuVOXprPXoSQ70FIh8b6
	VSqp+MTlsWcfHpQX35dB97TtFvfLCIawPzHSCvYXPMnOR1JxYgrI19Fxgwkver3mYE0euy
	4JICwRscTv/uOzRIIO1mrK0G0JQgUik=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA56A60DC5;
	Wed,  4 Nov 2026 19:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC9D1F00919;
	Wed,  4 Nov 2026 19:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820772;
	bh=TEHVy98izX4fxXB98UXZRCAsXp7Vv98/GN00gGR5FH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I5QLB5cPRnqisNuC7Gqo3F5XkxxQOdtVGXAFMUWMhX2Z7BYWw49ADkpvPU7MqNxI+
	 j48ixtJJYVGr31znu8c/7Be9nnUewJ72aON0xf/R4isMFiSrAYisnnndH+E4ED8VQQ
	 XcfgL+2d4gDdQBsrsE6enNmVb2q9GlukpVqvYJqVvErrOeF7xxKhbqDxo8qTklwVA5
	 Y30cOxhhLbdaCZP3DnUVtJZjx6p43P/fTZQgcWsWTuUtDrOyubqKAr0fQ8lDQzcJg3
	 4R05YEMlvwuvN8sRYtajj3sC3E3jrB8F1lxhZNUzV+Nt7eI5ePNgQkrGR4Ab/7mBVU
	 5ngUzPN2tzJhg==
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
Subject: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before pinning the entry
Date: Wed,  4 Nov 2026 20:32:38 +0100
Message-ID: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
In-Reply-To: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=6007; i=brauner@kernel.org; h=from:subject:message-id; bh=XY7ojw2MJH5q6cdYnSISI9dPPhcEOijXA7taVvYOt3o=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bm/kTxWWFrr4tjFsg/6s4/3d3zQzvzzb8u92uexKQ aWHfpMOd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExk+06GP1wi7B7/1rWYZy25 JqbSIlC9+W/y8g03z9R8S54pVjXRwpiRYZGPccC8jU98amU92Ti0XJqD2prb62ev/Sv9RV1n1mc JZgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 58D4C4000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: o6ptubrbza1w8ekd8rc1hm9fg158z8ft
X-HE-Tag: 1793820773-494365
X-HE-Meta: U2FsdGVkX1+MEW39NwgMnm5ZLjEojRKgRDku2hA4xvUnTmmV9MwAEg/tlZLDAe6GvrIqUONdkn9LVl0/cz5x8ZPeKhEfMdnO0rILszppdKDJnkHklTO10jUxhb9lQpa/EoTRSwqC65b4i+Nd/o9wNW6Bg+mct05X9YsHEUqzor8kiA34pfdVP6BI5rmLFjvdl7Kh3llFvnXtCHx7uIHSODujuSvrjispErcA2RICyWji18qgDl8trLBXk8JA65B5eD1dcZXHen7SbHzEViQPaVN15+aZzmOnd1tqqQBxqxyqv/YGP/+LFHs8bINbjA8RYHhca/xHSa9A6kz27QmGtNKFvLlna5HHPKndqbm/go/MFH4d0A1UV9iA0SIsrEdfWK5a5bQcsuJAzPYeFdeNZZ/OYDFTapoqOEhUDLTF9z7faQQMRXln04rtfvSNjDb/NEGllCsObc9C/l+Z9mgG1x3hYRYaoFOHaCnPnK4L8b02QtJGJJm19rXUK8pb1CCrstx8LfSdLoQR34jI3KUo7bujqm2h9xCXr/mt6Mz8AWWIjvYByUky0ks9lKzmGRenTeaxn+lbZ5XqnBnL5ofPZVt0gpFjldV0dK0WBACt7xZ6zXMrBeOCpOZkg7hrlhh5Ahy4wEvqxtVoFnnkCjvPfC8bjGPluy7ki2Sg0cXWvq//Bg3gxcBiwNxnd8QhM/Y+DgVMsmX+HUh6bKUoNKLZKJXrtVYxEtGhkpt7romkRBgDnAe38xw0PWT+SuqZod3Cv3Su2flrVQI6ITlWKjAURaFkxcPUXXA31zrxmxOtqVXtNJh2PXujzrMfQO75egKuCaud5H7OWpkRkxEjpKJ6rRRnbhkBKHIa0aUoZtf/Ddty/0XUFmSqxcMa6pffQD/f9MWHJ0ZgI/wcaAWHOinYwhfKhXQCIfLoej/5O0BNJErs+HaEFudtaca3T5A4e0iIh6RHxr7xqT/VhE+zG4q
 waTRkE/m
 AMBO9KLwrAIoZQZS8jRRUlP+1Cz7xX+raN+ydd0rdNrl8TNRupaZEjkdLv9/I3ym3B+MsIXQTTIDWxPtHD6qA3N2auM+HuaBqukJr0KFjRbjP7F1U1IOYqMctLc3voU2/vuofx0pTiKzn1LZixbbnE5aPWsb9Oe9qnBliE4I9UY/s92zyasjXv5rdmbL4IEeJndReiQEsDdSodRhe5tERQqsuPkDpSxqgX5fZkDiVE/zMdanZMk7xbEtYmSEaYAj0K2cESIIceKZ+tiUxwYbBxKd7HqJPYHNPf6Zl1ELmH4Y8Cw6/B86TYgddq0aFJP/2P4aKX1Rr7H4WJrRAW1c7xl2AkOs2KIS2js/i2LD28AKUPIOgG5YxkW+kAI83MNzXFetsWGifrCrDGZb/p1sEKQSkaw==
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
index 959bf9e33245..4f1f83e9f288 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -466,6 +466,14 @@ static int pde_set_flags(struct proc_dir_entry *pde)
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
index d51ab7548b11..df1caa0f238d 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -417,11 +417,44 @@ static ssize_t pde_write(struct proc_dir_entry *pde, struct file *file, const ch
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
index 674e6b4ed21e..da246c5ed4bf 100644
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
@@ -109,6 +110,16 @@ static inline bool pde_has_proc_show(const struct proc_dir_entry *pde)
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
 /* procfs owns the seq_file, see pde_seq_start() */
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


