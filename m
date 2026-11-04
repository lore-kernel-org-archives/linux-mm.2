Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0565606D4DA
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fK9Y4ENF
Received: by kanga.kvack.org (Postfix)
	id BD1EB6B05BE; Wed,  4 Nov 2026 14:33:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAA246B05C1; Wed,  4 Nov 2026 14:33:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A986C6B05C3; Wed,  4 Nov 2026 14:33:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7DB1F6B05BE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:33:53 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 118901207FB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:33:53 +0000 (UTC)
X-FDA: 85398436746.05.A64AFCF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3BD51120005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:33:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fK9Y4ENF;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3MZo+TaiYyYx3tHsERSPy6nplvi8yhZWb/0lCcSs1KY=;
	b=7ZJs3YHhW4azz7+MraSBTl3isGvBa7ylM1EAGeyCQdfkmnD9h5yVbU3kP6oOupvSLPDJ7e
	uITSw7xI7dxtS0gzoVRW/un+lswLlF0KIiSZkIZNqReioMMB5OOnVGika5rkI8SJwlirAQ
	RAWM35gSUN9FwJVZP5YSiH2+EKrMm4E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fK9Y4ENF;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820831;
	b=UxVpt7z4awd243pKzJeOgYaJCPu82ObpNP5z8tHfvIegfIaqpErM2HDyrVH22UaSjsExw+
	t+ln5yDTzCfjInsM1YaLunUzo5E7suqxixMP/4sMS/5B6LcSiTKflkneV7KpT4wrzVUSOn
	xYXIstqwXKn/+O9ZYilxr8aiHyjaZa4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C547160D86;
	Wed,  4 Nov 2026 19:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEC01F00A1A;
	Wed,  4 Nov 2026 19:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820830;
	bh=3MZo+TaiYyYx3tHsERSPy6nplvi8yhZWb/0lCcSs1KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fK9Y4ENFCiPjlRhFU8wV0NlIbZT/hojlER6vttE1d9qa9+Jv04mjKNT/AdVjfLsvE
	 pnHGuiqlLIith7DXpu2rldR7OZ4JXxOrF3FmGhZ+hcAyvIfnXydcAkEbt0rsRswpWF
	 rMaHm/bA7eZaczpsr7CrwIIykA6o23RG46MLlTwRYMZdak300MMJqwwACovyeq+tKT
	 2KyHlejSNd+u0EofNWzRGgxy+TfjN9hTb+ITqwbkSil+9AMAkMiwkrDOmrdHy0cXp2
	 PK79oEUo50XZ3m9hxyac2iJx7pLZU9KofoEu1kaGXYc6KIzGZy/s8yLmMVee57H8VV
	 DqTwfEsFuyXtA==
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
Subject: [PATCH RESEND v2 18/23] proc: let procfs copy ioctl arguments in and out
Date: Wed,  4 Nov 2026 20:33:36 +0100
Message-ID: <20261104-work-procfs-core-v2-18-76ace653a773@kernel.org>
In-Reply-To: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=8290; i=brauner@kernel.org; h=from:subject:message-id; bh=UJky7Q6NDXKrSBAbJxpUbP7z2/GQ36tDnB+V6uTqjs0=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bm8Lmszu7LBi/Z/Xwars1f7rHT980A4ojrtZa3O2N KVHpC+ro5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCLFCxn+CrjcND2wQ6JooomG RMbSs1fLmHq7nM8uW2k3/Y2a8WUjBoZ/9hq8GtYe398fWWuQOuvVBq3ZJ7dbr55R7fgxIG7vlwl GnAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p6a4rnzynxe85pdakma1gwe3pigdywpe
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3BD51120005
X-HE-Tag: 1793820831-988028
X-HE-Meta: U2FsdGVkX1+eHHN6j1JGYcVD4ospSqXlVqXCmiHkMMyf6mNffBDqKtReocDNFFrFhRLLLwWZzyGT2SoO5Je0aNnC908XySaF9LEBDtCYCLMlbJ/ra8Km6QyJPnYUPBYBHuthhwvO6Ld6vuy+ntG702hXRSV6tJoIHHfiM/t2BkCRReeNkwxr0L+IB2EE4BXY5B56YXnKCOdctpY14agYouUox/0HP5EbCtPSSFRD/wH8O+FUX7Osy5VpwXV/ofg5lTuYI8DwY7UDE2RCOaboDBOHuMZKtIpN/EyfRiOlYmyNNGp5Zb6r42FzldrZUcQBxxczjSqOcN1yRzhhAAOWNgyoZJK8aSUXZdlh+GGCcMxZthVKvAv+Om0NTXtvouVIzFZqXLiky4/4eh+gnGdcNH8LIbBXeXnJyM6m/qXPGcgkZOl7XfwPlQ4aZDqIvXSn8/H3CQ3CEpEJsyCi3MqDo0DtpVnLaRgvkv/PNwFpVfTtFSPFLOxyWQXkSM3Oyqlr1NY8TFAr2jOoqEgdmISkfvMjgTsGVkyVQp5HCHVpRNdDJeFKfVyj5uYONxalFvUuvdS0Fp0KrtXVIgNtvNG8s6wswDIEElCAkfEbqMgQrdEWfSij49N3U/bWPAlLc99c3aBIcY1jhEuNmv2GVHmWjVSK9uYyRZ7bK4eHt2ezPHh2WtvlqIh6BWG3+eRJJoEDrZ+b9LZzDkaRztCAOtQ0auk8LFYjQlgB8gyQJ/JB6wxHwGmpePSgKy9M0axD4p0mh5fS76rlBi+83DjzhDaw2Qlwuoe3KILrreKkSj1w+V7W8vG3jUEHRIKnAJIe7vXV7IG2FoxUsmGiPsGkrNKtDICqLDlrUfhUylpISahf0IgFrgZ5MiQ9mE3wtxUYCE5UlCG6BYEHQE/CbVuuwsB3kBSampTUwuXGsvwcMInJhA+htuZoRWX9weCLpV+xuilnGe9jVTXAFQEaoBAzOoq
 aWIDSyCy
 4a38rwnszeWwbvubT+1c8ewRFVyeS38ohPSmKCki8tZqmifWVpfw1uPqTJqMlhks+nFenpEeCVV/V/VMIJ+hBZdX9yaNZ4XXuDEvilh0QT6FrmKsishj7JYOIj0qZOj3H6U5zszdnD9Sn12QOyTQgsiIejtE8Uo2ll/qCiN2k67k2HHLYS8NDhc03XyLV4FLwHUSpPTceDiqVG8QdZoZcUZ0OcT+6no4bZHDeLXewN1Mpy2++ODIahUbDgH+l3TggtpZ0Zi6jX1+Nxqg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_reg_unlocked_ioctl() pins the entry and calls ->proc_ioctl() which
copies its argument from and to userspace itself. Like for reads and
writes, an ioctl can make a page fault in those copies take as long as
it wants and remove_proc_entry() waits for it.

The command number doesn't reliably say what an ioctl copies. Some of
the procfs ones aren't encoded at all, like the PCI ones or esas2r's,
and i8k's encode the wrong sizes. So keep a table of the commands, like
DRM keeps one of its ioctls, and let it say what each command copies.
An entry that implements ->proc_ioctl_buf() lists its commands in
->proc_ioctl_args with the number of bytes that go in and that come
back out. procfs copies the argument in before it pins the entry, calls
->proc_ioctl_buf() with that kernel copy and copies it back out after
unpinning the entry if the ioctl succeeded. A command that copies
neither gets its argument as is, a command that isn't in the table
fails with -ENOTTY. PROC_IOCTL_IOC() fills in an entry from a command
that encodes its argument.

Note that, like for writes, procfs copies the argument in before the
entry's own checks run, permission checks included. So a bad pointer
fails with -EFAULT where the entry used to say -EPERM first.

The table lives with the proc_ops, which go away with the entry, so
procfs pins the entry to look the command up and lets go of it again
before it copies anything. 32-bit tasks go through the same table with
their pointer converted by compat_ptr(). An entry that implements
->proc_ioctl_buf() and still has a ->proc_ioctl() or a
->proc_compat_ioctl() fails to register, and so does one that lists
commands without implementing it or implements it without listing any.

No users yet.
---
 fs/proc/generic.c       | 17 +++++++++++++++
 fs/proc/inode.c         | 58 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/internal.h      |  5 +++++
 include/linux/proc_fs.h | 35 +++++++++++++++++++++++++++++
 4 files changed, 115 insertions(+)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 2d503250de75..1bad3b068d53 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -483,6 +483,23 @@ static int pde_set_flags(struct proc_dir_entry *pde)
 		if (proc_ops->proc_flags & PROC_ENTRY_FULL_READS)
 			pde->flags |= PROC_ENTRY_FULL_READS;
 	}
+	if (proc_ops->proc_ioctl_buf) {
+		if (WARN_ON_ONCE(proc_ops->proc_ioctl))
+			return -EINVAL;
+#ifdef CONFIG_COMPAT
+		/* 32-bit tasks go through the table as well */
+		if (WARN_ON_ONCE(proc_ops->proc_compat_ioctl))
+			return -EINVAL;
+#endif
+		/* the table says what procfs copies, see pde_ioctl_arg() */
+		if (WARN_ON_ONCE(!proc_ops->proc_ioctl_args ||
+				 !proc_ops->proc_nr_ioctl_args))
+			return -EINVAL;
+		pde->flags |= PROC_ENTRY_proc_ioctl_buf;
+	} else if (WARN_ON_ONCE(proc_ops->proc_ioctl_args ||
+				proc_ops->proc_nr_ioctl_args)) {
+		return -EINVAL;
+	}
 	return 0;
 }
 
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index caa47933c233..717cbaad65df 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/cache.h>
+#include <linux/compat.h>
 #include <linux/time.h>
 #include <linux/proc_fs.h>
 #include <linux/kernel.h>
@@ -548,11 +549,66 @@ static long pde_ioctl(struct proc_dir_entry *pde, struct file *file, unsigned in
 	return -ENOTTY;
 }
 
+/* the table lives in proc_ops, which goes away with the entry */
+static bool pde_ioctl_arg(struct proc_dir_entry *pde, unsigned int cmd,
+			  struct proc_ioctl_arg *arg)
+{
+	const struct proc_ops *proc_ops = pde->proc_ops;
+	bool found = false;
+
+	if (!pde_pin(pde))
+		return false;
+	for (unsigned int i = 0; i < proc_ops->proc_nr_ioctl_args; i++) {
+		if (proc_ops->proc_ioctl_args[i].cmd == cmd) {
+			*arg = proc_ops->proc_ioctl_args[i];
+			found = true;
+			break;
+		}
+	}
+	pde_unpin(pde);
+	return found;
+}
+
+/*
+ * procfs copies the argument in before it pins the entry and copies it back
+ * out after unpinning it. An ioctl that faults on its argument then doesn't
+ * hold up remove_proc_entry().
+ */
+static long pde_ioctl_buf(struct proc_dir_entry *pde, struct file *file,
+			  unsigned int cmd, void __user *uarg, unsigned long arg)
+{
+	void *buf __free(kvfree) = NULL;
+	struct proc_ioctl_arg a;
+	size_t size;
+	long rv;
+
+	if (!pde_ioctl_arg(pde, cmd, &a))
+		return -ENOTTY;
+	size = max(a.in, a.out);
+	if (size) {
+		buf = kvzalloc(size, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+		if (a.in && copy_from_user(buf, uarg, a.in))
+			return -EFAULT;
+	}
+
+	if (!pde_pin(pde))
+		return -ENOTTY;
+	rv = pde->proc_ops->proc_ioctl_buf(file, cmd, buf ?: (void *)arg);
+	pde_unpin(pde);
+	if (rv >= 0 && a.out && copy_to_user(uarg, buf, a.out))
+		return -EFAULT;
+	return rv;
+}
+
 static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	long rv;
 
+	if (pde_has_proc_ioctl_buf(pde))
+		return pde_ioctl_buf(pde, file, cmd, (void __user *)arg, arg);
 	if (!pde_pin(pde))
 		return -ENOTTY;
 	rv = pde_ioctl(pde, file, cmd, arg);
@@ -574,6 +630,8 @@ static long proc_reg_compat_ioctl(struct file *file, unsigned int cmd, unsigned
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	long rv;
 
+	if (pde_has_proc_ioctl_buf(pde))
+		return pde_ioctl_buf(pde, file, cmd, compat_ptr(arg), arg);
 	if (!pde_pin(pde))
 		return -ENOTTY;
 	rv = pde_compat_ioctl(pde, file, cmd, arg);
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index b5c78f4f392c..ae0f9779cf1b 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -131,6 +131,11 @@ static inline bool pde_has_full_reads(const struct proc_dir_entry *pde)
 	return pde->flags & PROC_ENTRY_FULL_READS;
 }
 
+static inline bool pde_has_proc_ioctl_buf(const struct proc_dir_entry *pde)
+{
+	return pde->flags & PROC_ENTRY_proc_ioctl_buf;
+}
+
 /* procfs owns the seq_file, see pde_seq_start() */
 static inline bool pde_is_seq_file(const struct proc_dir_entry *pde)
 {
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 0f0997898ba3..2ba4e4a39e13 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -8,6 +8,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/fs.h>
+#include <linux/ioctl.h>
 
 struct proc_dir_entry;
 struct seq_file;
@@ -45,8 +46,29 @@ enum {
 	 * coming up short.
 	 */
 	PROC_ENTRY_FULL_READS		= 1U << 11,
+	PROC_ENTRY_proc_ioctl_buf	= 1U << 12,
 };
 
+/*
+ * How many bytes of the argument of @cmd procfs copies in before calling
+ * ->proc_ioctl_buf() and copies back out after it. A command that copies
+ * neither gets its argument as is.
+ */
+struct proc_ioctl_arg {
+	unsigned int cmd;
+	unsigned int in;
+	unsigned int out;
+};
+
+#define PROC_IOCTL_ARG(_cmd, _in, _out) \
+	{ .cmd = (_cmd), .in = (_in), .out = (_out) }
+
+/* A command that encodes the size and direction of its argument. */
+#define PROC_IOCTL_IOC(_cmd)						\
+	PROC_IOCTL_ARG(_cmd,						\
+		       (_IOC_DIR(_cmd) & _IOC_WRITE) ? _IOC_SIZE(_cmd) : 0, \
+		       (_IOC_DIR(_cmd) & _IOC_READ) ? _IOC_SIZE(_cmd) : 0)
+
 struct proc_ops {
 	unsigned int proc_flags;
 	int	(*proc_open)(struct inode *, struct file *);
@@ -100,6 +122,19 @@ struct proc_ops {
 	 */
 	ssize_t	(*proc_read_buf)(struct file *, char *, size_t, loff_t *);
 	unsigned int proc_read_size;
+	/*
+	 * procfs looks the command up in ->proc_ioctl_args, copies in what it
+	 * passes before pinning the entry, calls ->proc_ioctl_buf() with that
+	 * copy and copies out what it returns after unpinning the entry.
+	 * Commands that aren't in the table fail with -ENOTTY. 32-bit tasks
+	 * go through the same table. The copy is zeroed and as large as the
+	 * larger of the two sizes, it only goes back out if the ioctl
+	 * succeeded, and a command that copies neither gets its argument as
+	 * is.
+	 */
+	long	(*proc_ioctl_buf)(struct file *, unsigned int, void *);
+	const struct proc_ioctl_arg *proc_ioctl_args;
+	unsigned int proc_nr_ioctl_args;
 } __randomize_layout;
 
 /* definitions for hide_pid field */

-- 
2.53.0


