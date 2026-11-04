Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D39608177C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VG9aD16B
Received: by kanga.kvack.org (Postfix)
	id A540F6B05B8; Wed,  4 Nov 2026 14:38:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A045A6B05C2; Wed,  4 Nov 2026 14:38:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CCDD6B05CC; Wed,  4 Nov 2026 14:38:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 629906B05B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:38:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA9F61C3FCE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:38:51 +0000 (UTC)
X-FDA: 85398449262.03.5D78765
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2CA4314000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:38:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VG9aD16B;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/usm8OdHJAbA2hfj2koEwGvMkvG3A+8dTBDDaCx7vxs=;
	b=n4PxwuJQh5jWQEoJn8BAUUB9Z0jMEoodEm0GOxWXF7FmPIoKYGz0SceVkCQiKCmVv+86Zh
	tdbnY5eeUIXZ2fVUDt9Z85lyTAGnDxMifMPDr+xnmUlvg3rpL20CmjLCkpSAQoN5lyOume
	tl0koLbY04VIPmn182ojD7d3hEhkAWc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821130;
	b=NeS5Ga/YxmHVymPyue8pXQdtrZ9lIKF1wCzagYuZ24U7jzZ83OP1qnN7iFv0fHdDXIjvfs
	6M6MztT7XIDTDEOfeAPJXqYmpxUGN/o25Qycxby99+4HQFIZIY9lMcwwhK0bw6IEuoOmTJ
	dG2vl2vOX56M4/f56r393RgbFxWktHk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VG9aD16B;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F6F643751;
	Wed,  4 Nov 2026 19:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054E61F00919;
	Wed,  4 Nov 2026 19:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821129;
	bh=/usm8OdHJAbA2hfj2koEwGvMkvG3A+8dTBDDaCx7vxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VG9aD16BipFA7tZuupqgRtwFap9WcbchfWvSLq945hir63gYqXdpi80vOAxoJ6uPM
	 cGHQCLmBx2ftZtapYkLEZ01PDmHVVJJ6TxDs2YfkhL4Tz3whK38cqBsbSJLqCyBYf+
	 gBDBJ8A+zDWtTGWfh0XzkkbqrUQFGel+TcOUKlppnZVQjC+jU8B4Zk2c26ZwwjfYtv
	 t2JAQgGes6iwh+TO5a+TpZU2REcYYU954SbfBpwomyUlI9AGoe10aNZpzCVlgu4/Ap
	 mcCAmdx4loPFchYrvpr2CApq9ZKm/4TYtC5Q45UDzuVte6ccEDB3+w2Nw0bEL49v9f
	 TtPtWfNEAs+XA==
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
Subject: [PATCH RESEND v2 12/23] um: let procfs copy in writes
Date: Wed,  4 Nov 2026 20:38:34 +0100
Message-ID: <20261104-work-procfs-arch-v2-12-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2448; i=brauner@kernel.org; h=from:subject:message-id; bh=hbsAC6NXcgHJtASZof1yKKfWcOI33KFILjWjYjO2r50=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97vjdKe7M5N/Jdq7B56hA/YL9IjOVLyw8Oc9bq+xt/ 5wFLV4KHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABM5XcnI8LBv1xbhm9Vn913c +zjG1zQpPqn9s9bnOVH7lmW1ZC7a5sXIsNf3qtTiWZ5719z8tKH1Bvu/k4F1O179z0idHcB3w2/ WTS4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: a3g5yuk7pczs1g786u7bpz65i46sk9q6
X-Rspamd-Queue-Id: 2CA4314000C
X-Rspam-User: 
X-HE-Tag: 1793821130-628194
X-HE-Meta: U2FsdGVkX1/uu1DIKxEQ9/7/exEgA+WmO6IWyunJ4ssCNsGVWSCUYSloUFouXBYpWfwXc1Qo19rDzMWFZLknKKcHQS3A1Mp1EjxagrK9fR7R+2R0ZK5d8DXj0GFB5f6T0RaOQj42rg3gJ+62HzWRsyg0LVMOfbwCaRGSW39wclQvukUf0AD4V6vs+TvW22CbcE+Pu1fzK8kGmeycxP/WWy8CnVhHRK3xwkimf8YHjghXSYcBGVcIp9bY8sn8ERz8gNHAfU7GAPa9EwPYcTHGHHqfXskdmNSc+xG4My/oRWVKqnbSWM3U3SnSaAfjmIwC2Je75aMTFI9skB378DSfoXn9LHbhsUl7Pa/TQjEAbGOgeEM9u6bOSR8kZuSAkC3llrfJ8caGUgSk3kh8EhLstLyY3aFXujEKkIPqxFeHGNANzrxdFuBnmS4Xy4bPRORkgmTyogQhgdl3q0HalwR+7vDCMmxgMSKDZxjHVAphvXPz1Mn3lPGLDZ8pxA5tnnJmvqexByAYnNNk3vGyO/ioRs+b4rrfcMHZL9JWGJGJIiKM/z8uxDlGBrnngGtS4/NsvgGcpOLOpuT6nq/NeQ7cLRj03wsL1ADWV2Md8jUL0/bEU2eK8xybCdtAAX7h4pgdr6E0bvgbZLCf0L3/b3/qedDutsU+jLzaY1wILjejcxq9eahwFtcPDneP20Mmc5DmtNyD1wbhzwc6DZCzYR+sBKcP7O9+pSfOw7iiTvesmPGm/LYO6FTs/7pPrb4EJV6ZjuSG1LRNICeJ966rPDKX4OqzgFzVWDR61cWT5+yBVfN6kWR6wqmIKppkLuAW4oIcK7zB3HT4tyf7P0kbIjtjyqYp9oHuT/5x6E8elvKEyiOPWLznAmCM1jbbXF80Rrva0OIOvWEYFBuXfFwT3FT8kb5wy5yNw2sb4PlLcPdWv9FEexChb75SmzdKsbYPQhIjJWulop3ieiidE99MkpQ
 LraHmriu
 AF7+7JtJGvIsN5QTHw+r8ljdsLfHkzJii9K/tM2EnFjqRR1GrYXLxyybPkOdBTrz0FmhwtV6BJh02s9lkgcClmCfApqB9/C7sKvQ3Ij1KbBE6nr/wWVymArXWlaQr0P13sLwYXmQv8+iO67dA1/v87ylPYINNGOOa4tc6MuK6jVDg6rzysj8pBlUozvrYjXy/CS1ukYlwMMVe9ADmJmJDlwkZ0TJA6x9TCTsvXkwwnFnP0NrImcH19CAkh5L2JoblNy3Ga4oBMk2lAwmmpJE7+8JEhFGPE8JAImLrBerz/GTYcO/4weqxBbV43TU6sp7oIKUY2mfiftkMO0MGBiLQbwjd0qUsTFMkPd1y8ymR4sfp0QPcWrdukmQbDaajL7MlP6bqE5MgWzoyMKp2zgwPaHAjQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() for the mconsole and exitcode files so
procfs copies in what is written before it pins the entry. Writes larger
than PAGE_SIZE - 1 bytes fail with -EINVAL now.

exitcode parses procfs' copy as is, so it no longer stops at the first
six bytes of what is written.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/um/drivers/mconsole_kern.c | 11 ++---------
 arch/um/kernel/exitcode.c       | 14 ++++----------
 2 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index f01b7d8a07bc..a4370470286f 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -769,21 +769,14 @@ static int __init mconsole_init(void)
 __initcall(mconsole_init);
 
 static ssize_t mconsole_proc_write(struct file *file,
-		const char __user *buffer, size_t count, loff_t *pos)
+		char *buf, size_t count, loff_t *pos)
 {
-	char *buf;
-
-	buf = memdup_user_nul(buffer, count);
-	if (IS_ERR(buf))
-		return PTR_ERR(buf);
-
 	mconsole_notify(notify_socket, MCONSOLE_USER_NOTIFY, buf, count);
-	kfree(buf);
 	return count;
 }
 
 static const struct proc_ops mconsole_proc_ops = {
-	.proc_write	= mconsole_proc_write,
+	.proc_write_buf	= mconsole_proc_write,
 	.proc_lseek	= noop_llseek,
 };
 
diff --git a/arch/um/kernel/exitcode.c b/arch/um/kernel/exitcode.c
index c71657df38f5..8f76e3b20c18 100644
--- a/arch/um/kernel/exitcode.c
+++ b/arch/um/kernel/exitcode.c
@@ -32,18 +32,12 @@ static int exitcode_proc_show(struct seq_file *m, void *v)
 }
 
 static ssize_t exitcode_proc_write(struct file *file,
-		const char __user *buffer, size_t count, loff_t *pos)
+		char *buffer, size_t count, loff_t *pos)
 {
-	char *end, buf[sizeof("nnnnn\0")];
-	size_t size;
+	char *end;
 	int tmp;
 
-	size = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, buffer, size))
-		return -EFAULT;
-	buf[size] = '\0';
-
-	tmp = simple_strtol(buf, &end, 0);
+	tmp = simple_strtol(buffer, &end, 0);
 	if ((*end != '\0') && !isspace(*end))
 		return -EINVAL;
 
@@ -53,7 +47,7 @@ static ssize_t exitcode_proc_write(struct file *file,
 
 static const struct proc_ops exitcode_proc_ops = {
 	.proc_show	= exitcode_proc_show,
-	.proc_write	= exitcode_proc_write,
+	.proc_write_buf	= exitcode_proc_write,
 };
 
 static int make_proc_exitcode(void)

-- 
2.53.0


