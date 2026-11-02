Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A0E606A900
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zz1tW5Xt
Received: by kanga.kvack.org (Postfix)
	id 759186B05B7; Mon,  2 Nov 2026 10:00:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70A1C6B05B9; Mon,  2 Nov 2026 10:00:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620B56B05BA; Mon,  2 Nov 2026 10:00:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 408E36B05B7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:00:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C424F80144
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:00:33 +0000 (UTC)
X-FDA: 85390490346.06.54A682A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C66F1180017
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:00:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zz1tW5Xt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U5mZzHxukjxLRr+A+lD/tdwf1LEzGDGeSNZ2whis+uo=;
	b=7akzX6wdVEp9OKejOHD2HV+sKZKmoDMh96XmD+r9oPTMdxAzUq0ci0o9FXa0cWx8jU476+
	qjreo0VSjXLDDjdtAkSo3I+qlYYiZ5KjPuZiT7ame46IQDqDmyybZ+Eh+fkbKRjts8R9bp
	c9Zs3fVNmTDTvWo6Bbvq8cQMoC5xhnw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zz1tW5Xt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631631;
	b=koGVW5h+uq15xaZV7v1Xh93A7DvPD8ZNeDj8lrC+1LlS8oV5iOZ6zmvpcmHtmH4jiVFRe9
	Xot1GYTWINKqoPVmwLG07xCJAYgYKytR3Tw6gTa8WJ4H45n2xgdv5paIUD2mWAhA7VbjkY
	hZ07EIGPTwgQjG0uSrymhFDFFbOnWnw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3243D602CC;
	Mon,  2 Nov 2026 15:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BAA1F00A1C;
	Mon,  2 Nov 2026 15:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631630;
	bh=U5mZzHxukjxLRr+A+lD/tdwf1LEzGDGeSNZ2whis+uo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Zz1tW5XtBNM/d+mjny8hcfR/4iAYkqcmlWTYxYCIV7g+aVhufWqrhGEyT8Boi/IPr
	 JAIhXXD2RZm1G/CwC3/k02VHwHpNmTGSwd58veF7P4Hq6KJ4HMsr676Nx+bEEKxATq
	 iUFuGrohuVqI1/y4vsPsNthNYQa/3J6IWcjlYAzxjO6QCdHTRUmPXk5rHb5Q5ioFFC
	 yxLID907OAltPHkASDThMZJnoOSO6Q2vNdDW9bRzv1zTDIkcRj/iT6nZCscjiI9JnT
	 20N+6mGEl6lWOxyXpc9zj8jxJRlwSu+rkfjx2zSBxlgxaxdGqi0nBTrjzJmljxNfiC
	 CQmDZtgOP8SFw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:48:55 +0100
Subject: [PATCH RFC 15/16] proc: let procfs copy ioctl arguments in and out
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-core-v1-15-75df35e4f8b8@kernel.org>
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
X-Rspamd-Queue-Id: C66F1180017
X-Rspam-User: 
X-Stat-Signature: k65epue3s5isoxr9oejoisjumy78hhst
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793631631-473464
X-HE-Meta: U2FsdGVkX1+mwIr1ghbBel8FEjMZ0Sd+lgyI9vza/RX5LxT0ay4ST4QmKVG2b1bGbJgzj07MMojnhMSqZdh8wO7x5eHRB7v3k8wZ00kRvtkvoXAibMFAEPZNnUiDcQ6FVXoiVyLospAUKvt7UfovlyQUYCQhiRAkx/IZwwQrDhjLT5uuLF2lIDOYO+i1+Lo6jCc0Xz1tQhW2hR0cvBjWiX95o/A37I6s0xIK5KprC5yyz4B2DqB8jCdcEoCLpkgmbEsrjvM0Yai7GFA0qgHNV6w5dFxosgpmgyABWv/P5lGdkVXelbCsv1YAiF3V/EvQ/pTpn+mTaUYan3+OfMNQ3MXmfW26xwyMwPiQnq4LaqUFedI1R9DtG+BU23yOy0yWwP/1zdGpY6v0Pn0i7QMr/Pi/s7eVjWKZySQRVJ+vlxk4qv9fWUvYBdAE9vEwQ/Iqff7PvsDbTTn5XjvcbxP8VcJMmWjObAz+VyT/vryk+pplsUDzq/1DTBfaEDoUBrseN8vsVHSqNNbgAHff0yrxyLysSjgzEut6H4xsRtOGs+Re5XwcNxgx9KA2gNwrsc4IHKyoBSNHR0wsX6k6vNB45tl6/pcZjJyMog7DPTVJqz5Ajpf8N5YMF9irROpISuDk/XQPVzqCtEUpD1kdDmgzKXiUjX+MOJyH8W8xVtH7uk9NlFtQmpfjS2OLs+J1Vm6m+NR5fh60dqKj5GTvdsOw8Z/z48BSS/6OBY1mr63OMJSO0wVx96tQhbLaY/FeGnPcEutK3IIZGNhQhqcZrpu/PdPpRhkS/cwXlGAe0I1QNoAHWM8V7VgQqLmwMPT5iqYxXkxJx3AV7tn/EUkJANl9qnSiG9U7mR1Bg6okk43AoZ3I3YKM3eQwEMolYjsTXU8EnaC0C/nyMaHjNypGBNdtaCb5vVyBuRlynYAdsewd7u9vZJNrPqKwx7jWK/vqeFexeoIEBOkYaeWez7b03wr
 JwP8VAz3
 C5U2wn1g2K0hi9S8b6NGnZTI9h6APY6Gw/ha3AanNEKsyKjqRZyTZjdZcTJ+02jUVPtTtclmTkYhGt9KYbHeCnq58uikSLTvm0OC2Kd8YE3sVvC65MhytH8kieBnS7pDE229SPWFnPypX3AnwfZrBdbf26wPG4tzdUMggncpTDySo47rDyHysIj4CpoonwJuiFqf6iUaGURiJZzDOt68e1M0URURztKHuOBVyYxaVGFzi3vwLoMOBKaWRwSvxfkHSa+802XSii+///e/yPXD3UCBnD58pQ0tpzofo
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
and i8k's encode the wrong sizes. So do what DRM does instead and list
what each command copies. An entry that implements ->proc_ioctl_buf()
lists its commands in ->proc_ioctl_args with the number of bytes that
go in and that come back out. procfs copies the argument in before it
pins the entry, calls ->proc_ioctl_buf() with that kernel copy and
copies it back out after unpinning the entry if the ioctl succeeded. A
command that copies neither gets its argument as is, a command that
isn't in the table fails with -ENOTTY. PROC_IOCTL_IOC() fills in an
entry from a command that encodes its argument.

Note that, like for writes, procfs copies the argument in before the
entry's own checks run, permission checks included. So a bad pointer
fails with -EFAULT where the entry used to say -EPERM first.

The table lives with the proc_ops, which go away with the entry, so
procfs pins the entry to look the command up and lets go of it again
before it copies anything. 32-bit tasks go through the same table with
their pointer converted by compat_ptr(). An entry that implements
->proc_ioctl_buf() and still has a ->proc_ioctl() fails to register, and
so does one that lists commands without implementing it or implements
it without listing any.

No users yet.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c       | 12 ++++++++++
 fs/proc/inode.c         | 58 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/internal.h      |  5 +++++
 include/linux/proc_fs.h | 35 +++++++++++++++++++++++++++++
 4 files changed, 110 insertions(+)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index fc4d10c92d7c..35dd745a0357 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -485,6 +485,18 @@ static int pde_set_flags(struct proc_dir_entry *pde)
 		if (proc_ops->proc_flags & PROC_ENTRY_FULL_READS)
 			pde->flags |= PROC_ENTRY_FULL_READS;
 	}
+	if (proc_ops->proc_ioctl_buf) {
+		if (WARN_ON_ONCE(proc_ops->proc_ioctl))
+			return -EINVAL;
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
index 3f29a1663d26..7e4ca5751abb 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/cache.h>
+#include <linux/compat.h>
 #include <linux/time.h>
 #include <linux/proc_fs.h>
 #include <linux/kernel.h>
@@ -571,11 +572,66 @@ static long pde_ioctl(struct proc_dir_entry *pde, struct file *file, unsigned in
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
+		if (copy_from_user(buf, uarg, a.in))
+			return -EFAULT;
+	}
+
+	if (!pde_pin(pde))
+		return -ENOTTY;
+	rv = pde->proc_ops->proc_ioctl_buf(file, cmd, buf ?: (void *)arg);
+	pde_unpin(pde);
+	if (rv >= 0 && copy_to_user(uarg, buf, a.out))
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
@@ -597,6 +653,8 @@ static long proc_reg_compat_ioctl(struct file *file, unsigned int cmd, unsigned
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	long rv;
 
+	if (pde_has_proc_ioctl_buf(pde))
+		return pde_ioctl_buf(pde, file, cmd, compat_ptr(arg), arg);
 	if (!pde_pin(pde))
 		return -ENOTTY;
 	rv = pde_compat_ioctl(pde, file, cmd, arg);
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 11bd3fa07705..93d20995b6fe 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -129,6 +129,11 @@ static inline bool pde_has_full_reads(const struct proc_dir_entry *pde)
 	return pde->flags & PROC_ENTRY_FULL_READS;
 }
 
+static inline bool pde_has_proc_ioctl_buf(const struct proc_dir_entry *pde)
+{
+	return pde->flags & PROC_ENTRY_proc_ioctl_buf;
+}
+
 /* procfs owns the seq_file, see pde_seq_ops */
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


