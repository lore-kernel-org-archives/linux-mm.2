Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A5BB6078719
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WxVxzqco
Received: by kanga.kvack.org (Postfix)
	id 766186B05C9; Wed,  4 Nov 2026 14:55:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73D7A6B05CB; Wed,  4 Nov 2026 14:55:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62C526B05DA; Wed,  4 Nov 2026 14:55:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 48F8D6B05C9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:55:36 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E209CA07FC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:55:35 +0000 (UTC)
X-FDA: 85398491430.19.37127A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 29E44A000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:55:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WxVxzqco;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C2fJYdTojRFSaODFdjPHql9M0bzE3FJwr1E018LBBO4=;
	b=VDA2yw2Qk89exb2iq5Wohb9ikOg4+p8/HfLlYeLJbdmqZQnWcw2DDjWrz7zSLVlDkq4VdL
	PPHgBYYHb50D/lueFrVfveA2ULTVbpFOuFh/wgA9to1j+cFCoCaEH9eRMXi8vhumUqexZc
	XEVOq448w68x9vRQdV2a9mEt7y5dtz0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822134;
	b=7ANn9/4uMMm91M/qq07GTjhi+xljTnU3/30UN7AyczoPdCtiF2jx18tvDS1i+aO3M4WenO
	7gmx8aep/dMAzsluHM0iAMtTsXTDDXyqpiKb6cUNnwS8rgrUXQuSWzl+M9/2wOr2Nx/BOC
	x9KWuIRlaJbRveH6LfEQydPNGRpo/w8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WxVxzqco;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A456060F37;
	Wed,  4 Nov 2026 19:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721521F000C1;
	Wed,  4 Nov 2026 19:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822133;
	bh=C2fJYdTojRFSaODFdjPHql9M0bzE3FJwr1E018LBBO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WxVxzqcomPDLAWsqX85EWcLe7WZlzoKJpHDpOQhf+KZ1aYuixFo4RGC5WENxIeYDR
	 pLwBWxDYw0foUZ3wHytSbwfCa7iq8dLIZnc5m2y8FT0LfPDL7Q2pae5sK1fKW87eH/
	 TLoxZJitlHu5XhrmddtW5nHOKeuonavA/4uOaPJGmBoWC6YghAhb5YkhkwxhSp7tHZ
	 SnDT1yEyHPjdo3S7ahmm98p5SQhtKbsglzOsqjH27sqF26J+nVkJrN5qpLWC+cZqHa
	 3bxRMiT/Z2318AVzkaEXIjv3kDFVAW7sr0AInZ9NSC6cPhwH5gTxJMnKg8DEI8HGOJ
	 jel/AuRNeS6+A==
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
Subject: [PATCH RESEND v2 23/30] dyndbg: let procfs copy in writes to /proc/dynamic_debug/control
Date: Wed,  4 Nov 2026 20:55:19 +0100
Message-ID: <20261104-work-procfs-fs-v2-23-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2288; i=brauner@kernel.org; h=from:subject:message-id; bh=Awi3L5zR/nArf9JZW1OMhl80jxJR2cXziAHCcuF5CR4=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97nHPjBBTr3NykX/wLUHBgNnn4SS7+fVKVwr6yxuXL 0uRqJrSUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJEb0xn+Fy+YXCV0Oe/Eaz8H 4b8ha/yUgz2teDZt31XB+vfCvnbjCEaGI7bdptPVH0oejHTQsv2wPFNAJufAZvvExUsuC73W+Mv LCwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: cfh6goobp19i5eiuiit3urrrsxrkce54
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 29E44A000A
X-Rspam-User: 
X-HE-Tag: 1793822133-165351
X-HE-Meta: U2FsdGVkX1/l9L4eqAPQ5iQClhpDoxe0dMFy/CxegXUxMraAnTiVSCCd9bUPj7auKihNpcMZRZUbkz+XPECt2u7l1BFs1+/qZuTOidYmLxIHVz+2306YLzel54CvCUprK95Q7FBcwp7BG+t5IAJt7zW/jc809d6mXXzIWa/oz7RgBU8HzWYuSxz1Ib8PM9q5cDmfPicrzRgioqnAJsNIGc4JfjliU4xbtFUjMllFz7HlUED6DL+UQ6yQxeGqxUBF0+EiTyqxsQF7hdcXeWdiBY3SnMRzFsRy9kI+bwVZyRWDH742EKtFr0CP1w71jb6rJmWcjuN45onmvIVNofQdl3MlafBNO+P1BEncjU37au4to4Ld2tu4PEwo3Bv63jD+o8rsVfl8uLKTeldLIUuZIxMedSQX3upa7dF1baKA745fszH6rjSagpQ8dCwEwy1tVf+7rTyEZbljT49iPpJ6a4Nf6g4bwRS8/FXS9CO8+kh4RvQClOtwGnK6VbYEJj5g3W/UqqCxjaFLLUdPIzHsdPKv/gx2Tq92RrX/d+m9l1+m3+TQER3yklx1jEiEFH4PZybGdsa34hRYKNTcYVQjY+yxDyjGxKsFwpMQb423j+UOuLDhvRISYUMMCy8JUKQXh7s+uiBhGF4EJFqS8/PODs+cwEQ9+DJX6vLVmewJ1xxUYUCAlQXstCcp+W97tgtd73hUXTa2mpIQSxuxSoMVW52wPMGQ43mDFi1MpIQStSNNpy+JxAVmIkf3Po1s44dPLPQh6IJWyVx8qBQECG1tL5DdJyrrfOwkWOVyEjo14RdXVkG4xV05omgp9ainuqbBpu4AmGK5pDDjfNVJXHjSzmu9LZdATu2UTbYNovK9OKDTdJkoQ0iF2CYKC3joKHPvVQVTau0Wp3rZWABO4yNdTD14qgEqGpeuEuf7Jh+MbzPc6rY3FGq0nq2rD5zg1gHj+r0ya9QkTwcrjq63tHF
 6wuVJItn
 g4Wkj7mF4DgWrtf5G8Emj/pdZs57oKgtUWwb53MfFoCVl3WZc4i2E+5jbx2LBeENq/cTeTB8hkGk/NVbUhc+o4mgU90oRSNibbU2FXl01CENf/IFqqE37o0NEmaOiRdQAgmjnqtVPtNoEvPsxYYT4QYQ++JIm3xVdPTYWdxATEeBWEUcdcx7VuOS1wM0hrmIysuoFZXIEOTGa7yPFifP6rwwnkBm0ZDqLjpatEDO1MWMKvamlb4YNnmPoXsfMxRwiumdJqyehT4wsagG+4KngL4/H2DSH0y/5dNKiDaZyJSU1kwPMVUnvY8do8Y9awK+QpLHfuNXjtJBbMnw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move the parsing into ddebug_proc_write_buf() and implement
->proc_write_buf() with it so procfs copies in what is written before
it pins the entry. The debugfs file keeps copying in itself. Writes
larger than USER_BUF_PAGE - 1 bytes to the procfs file now fail with
-EINVAL from procfs instead of -E2BIG, and without the "expected <4096
bytes into control" warning.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 lib/dynamic_debug.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 64a211290872..1d6012c9eb41 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -1002,11 +1002,28 @@ __setup("dyndbg=", dyndbg_setup);
  * command text from userspace, parses and executes it.
  */
 #define USER_BUF_PAGE 4096
+
+static ssize_t ddebug_proc_write_buf(struct file *file, char *buf, size_t len,
+				     loff_t *offp)
+{
+	int ret;
+
+	if (len == 0)
+		return 0;
+	v2pr_info("read %zu bytes from userspace\n", len);
+
+	ret = ddebug_exec_queries(buf, NULL);
+	if (ret < 0)
+		return ret;
+
+	*offp += len;
+	return len;
+}
+
 static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 				  size_t len, loff_t *offp)
 {
-	char *tmpbuf;
-	int ret;
+	char *tmpbuf __free(kfree) = NULL;
 
 	if (len == 0)
 		return 0;
@@ -1017,15 +1034,7 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 	tmpbuf = memdup_user_nul(ubuf, len);
 	if (IS_ERR(tmpbuf))
 		return PTR_ERR(tmpbuf);
-	v2pr_info("read %zu bytes from userspace\n", len);
-
-	ret = ddebug_exec_queries(tmpbuf, NULL);
-	kfree(tmpbuf);
-	if (ret < 0)
-		return ret;
-
-	*offp += len;
-	return len;
+	return ddebug_proc_write_buf(file, tmpbuf, len, offp);
 }
 
 /*
@@ -1196,7 +1205,8 @@ static const struct file_operations ddebug_proc_fops = {
 static const struct proc_ops proc_fops = {
 	.proc_seq_ops = &ddebug_proc_seqops,
 	.proc_state_size = sizeof(struct ddebug_iter),
-	.proc_write = ddebug_proc_write
+	.proc_write_buf = ddebug_proc_write_buf,
+	.proc_write_size = USER_BUF_PAGE - 1,
 };
 
 static void ddebug_attach_module_classes(struct ddebug_table *dt,

-- 
2.53.0


