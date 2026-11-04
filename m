Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04724606C927
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n6uNIEN8
Received: by kanga.kvack.org (Postfix)
	id 237B66B05DE; Wed,  4 Nov 2026 14:56:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E76C6B05DF; Wed,  4 Nov 2026 14:56:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B02C6B05E0; Wed,  4 Nov 2026 14:56:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCC146B05DE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:56:05 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 856D31A0856
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:56:05 +0000 (UTC)
X-FDA: 85398492690.24.485E76C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B812F14000D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:56:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n6uNIEN8;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822163;
	b=JqcwZhMh5kGWET18noyuTfYlYHxRQJaLky1AEf8wRd9/R7NmZlYF+vjR06eUzAGD09a2FC
	DITIl69D1cSD318jUh8p9Ugt98YlMvBMDrUq5LZRRWxwDUpC+l6OhkO6pfV2yHSgglHJ33
	JJwgAZ+FNAbSeLmfzDcn0qz180K6KKQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n6uNIEN8;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCEpJCXGgk21zgMyVrJnsb9d3IAiyaFEBDru2XgYb4M=;
	b=rO3WXxo8099YTNw8wRgtFCSLSxkYsr8SaV2xyWI8vTXWRpnVDi7zECmAUQzPzoWjjztTf+
	ZQZgXkvQrP9vzELECweeP2Q2vwBsVNJkulu0ezcHTLb8dBK7IEUWYXgUf7R13RbPHinMb4
	mUNEeDSUuay8mNe2H4x044DM0spZTp4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1015F40196;
	Wed,  4 Nov 2026 19:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9F61F00919;
	Wed,  4 Nov 2026 19:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822162;
	bh=bCEpJCXGgk21zgMyVrJnsb9d3IAiyaFEBDru2XgYb4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n6uNIEN8UtFFIaiDpvbvTTBdWrfLopeDookEM+XOfGJBmQaBLBud7PW4ZywRa4UqY
	 sj9lKf00u87t0rYyILLdTAzUShhG08ZdGf/Lzb6uT5y+NXjXXOrpjMTCCufRj/+vUf
	 qn2Hm5dCkKTQ/5xyNTYylulY92AYSZ+tzxPbaFXkvFnu/q327E+8W9jss69XVk/qWl
	 RFW6EwVAfNKvgEJ3eedNnGhh4txPJEwh75Q839TLwgEzuVUSv49ucfVtBinxI3hk3b
	 fb0M7feqk7mkAAGLRXxYscDizmCBmFG4sFYYV3OBo/qiimcnQoXdcT6kySNh1lRNIF
	 bhwX+vUqpJ/hg==
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
Subject: [PATCH RESEND v2 25/30] alloc_tag: let procfs own the seq_file of /proc/allocinfo
Date: Wed,  4 Nov 2026 20:55:48 +0100
Message-ID: <20261104-work-procfs-fs-v2-25-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2428; i=brauner@kernel.org; h=from:subject:message-id; bh=w2e219TOPzYhqaNEYdOja/Iy2kqKR7KfDC/oRUWRjFA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97vFcddfCmyOAVbf9SsDD2QKqjkaTBOc97Z200n3GL K1V/52WdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExEm5mR4fL8sPeSEVKLCxs1 t6daZRx/N59v9c2uBvbciVVGFpzdXxj+itqIaCekhc3YHW/sfpNlJ0++MIP1I9HZqYuF7+sHn5n NCgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B812F14000D
X-Stat-Signature: sen5dnn6r1ks9a9ajdsxwydnza777ye5
X-Rspam-User: 
X-HE-Tag: 1793822163-173884
X-HE-Meta: U2FsdGVkX1/2TkZ0Z6wmP60byS05JrSwKEh+w3dhxdPpZ98oI6LXALpwsf3piJG5mgpB62l/hiToznHqz59tWLrWCADvz33L71QeyszQKertCgPFA0AyaQbE7MV/nd0G/GTISCEDQA0Q5Jp0nlmxWxZOGscwSoGYv63v/9+s6jTmkk5RTNJKneZuPf26FmjkoiOzc5M4vEyLw1m1gydc5WEtnliOIyRgG3jdI3TNpKn3EorHL8Vbll65VsNoTdZ66uhrinuXR9HDnLqUZwtaRjBbKibc0EyQ7eI09U8Fnq3V9g7CjXzke5etEREuXKrYMTRI+ag0VjfJ38Wf7uQh541dXOpDyvfoB0Hs5v2+Hk+3GTG7Tqi8Q3xRBFAwnntrBmJrtnD1dLtjz3lxJxO4cnG5AWYtjR9g0/hJOu2nEJFDzJRJuEwmEDJJ/+I5kjsCsOb9EUJOb+LJpj6bDMHfS+i1dURD1U0WASr9YBzYdm9ltxNxCk1UGOKV04G690hz+JHE3siYTk7U/oPpKtf42LVNI4ewIyidaLH3zCBxSD1n8fMUdLrlUBV07pN6odcQ1L2xYNeS1GHEueob/oMr4+nAJyLWs3PqOjRT/Qp8uuYF5QFRmHAysyWNmK7o5H2NWVqofHscWHNI9M1H8XbpHg7Iakq6g37+F2fUuR8QZhJu7VoieBrJq/Hytb7VVpJFIfEo6X5mK67HjNmApLFje4CixJ6ofLucQVD1pmn+V7hoaqV1YOYZgprkEb2nJSagsWuYSCVNORzMmFdZ2ODTXSi2ixWTQLjn69zZRXw+/RT7U3kiMZZs9sNGjt+7bU2iVfPG3inx8x47pO3x/p038uNGOM9CSYQ2bcJEhsynG0wO4yw+k3A0dltYvMXJcgiwWgDvTNAnHDgFXaUD71oGQdL+cx08Mg/y6o7lAPJMjYK3UksSpCtiq1it/r9wjguwaVpTc5TuNGL3wOEQP8X
 s8Dt4ell
 wHCGAVeqG0XaxVras3Dii1nkzSqtVZlSg9w6aetjRifah/Xv1/mY1f1UpkifGITljEtEckrKaU7I5AB98SOEv34pCMXRo2q1ToDvYy564HJ9P3iwzLVWDe6aMl5A69MlwZgwkOntJNJLwXdZ4QXji5vpi+FKZNveGAPSfTVz4VT9PCIyAxUI7GQZkBHWQa1Fx5ZOMqCp6jwykPE44L/9vX4zoAXPi659F8M+9rXoyRuYwLB2uK2WE9wbs6KtnPwdi+2+4V8aA9Uqp+jX8fp6OlHqSIIMVlNnX3qwnfuN9gcwO/f9VHGXvsjAvOslNxwJNv1TcdwzgJD8CMBe7njAvBdFA0RSxxDVioZKJRbv94pG3RaoMVt15U47ncBJ/vhCDT5rMSX4XiBxEfeeTlte1gSitnwEQrVoOBg117tB/BFakK8vTzRWH2YnesIUH/cDDHPtA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and the size of the private state and let
procfs open and free the seq_file. ->proc_open() and ->proc_release()
only set up and destroy the ioctl lock now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 mm/alloc_tag.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 7d7ad6704953..697e44468ebc 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -152,27 +152,21 @@ static const struct seq_operations allocinfo_seq_op = {
 };
 
 /*
- * Initializes seq_file operations and allocates private state when opening
- * the /proc/allocinfo procfs entry.
+ * Initializes the private state when opening the /proc/allocinfo procfs
+ * entry. procfs opened the seq_file and allocated the state.
  */
 static int allocinfo_open(struct inode *inode, struct file *file)
 {
-	int ret;
-
-	ret = seq_open_private(file, &allocinfo_seq_op,
-			       sizeof(struct allocinfo_private));
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		struct allocinfo_private *priv = m->private;
+	struct seq_file *m = file->private_data;
+	struct allocinfo_private *priv = m->private;
 
-		mutex_init(&priv->ioctl_lock);
-	}
-	return ret;
+	mutex_init(&priv->ioctl_lock);
+	return 0;
 }
 
 /*
- * Cleans up the seq_file state and frees up the private state allocated in
- * allocinfo_open() when closing the /proc/allocinfo file descriptor.
+ * Undoes allocinfo_open() when closing the /proc/allocinfo file descriptor.
+ * procfs frees the seq_file and the private state.
  */
 static int allocinfo_release(struct inode *inode, struct file *file)
 {
@@ -180,7 +174,7 @@ static int allocinfo_release(struct inode *inode, struct file *file)
 	struct allocinfo_private *priv = m->private;
 
 	mutex_destroy(&priv->ioctl_lock);
-	return seq_release_private(inode, file);
+	return 0;
 }
 
 /*
@@ -475,9 +469,9 @@ static long allocinfo_compat_ioctl(struct file *file, unsigned int cmd,
 #endif
 
 static const struct proc_ops allocinfo_proc_ops = {
+	.proc_seq_ops		= &allocinfo_seq_op,
+	.proc_state_size	= sizeof(struct allocinfo_private),
 	.proc_open		= allocinfo_open,
-	.proc_read_iter		= seq_read_iter,
-	.proc_lseek		= seq_lseek,
 	.proc_release		= allocinfo_release,
 	.proc_ioctl		= allocinfo_ioctl,
 #ifdef CONFIG_COMPAT

-- 
2.53.0


