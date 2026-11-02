Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C32046087A25
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=esP1NXiJ
Received: by kanga.kvack.org (Postfix)
	id D08FC6B05BE; Mon,  2 Nov 2026 10:05:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBC216B05CD; Mon,  2 Nov 2026 10:05:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7336B05CE; Mon,  2 Nov 2026 10:05:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 987B36B05BE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:05:59 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 205E2C017A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:05:59 +0000 (UTC)
X-FDA: 85390504038.21.59E801A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5CE0240005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:05:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=esP1NXiJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=08oqN1TE6XF/zda2aaIy/jJ7rzXSJoF5jY3Jq8EQn3I=;
	b=DI+tT8NMXxfJRWCmfVTjlragIGbCchprBR1s3IfzdExQcQh8cnI6M226hckhNuk+Cuj0te
	xnX24J1qqm3ShpxMz+pJi354JIXGQA1wBLiRtHQIfl8+eapNKM8C1dBkSmv5qjgvhRbT15
	jxyzU3/pRtQgLCn7Kitp/f/uJ9lYWuI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=esP1NXiJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631957;
	b=wDaoJchDJ+2d1g/Cjr4ehMgHw8gyRrOIr3kj6FDMP7CYIHawb3RQQzTBJ4ODr0QqPtnzMR
	GFNOqpgNY23YTwGzhx0eusL8HSoHK8YgpO40EHnXiieA+Fxs3FcWv5LjhFCCfHJrUnoyMG
	RrkkKAPbod+iLiRYpb66OU7HM27ZZbg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DEA543A26;
	Mon,  2 Nov 2026 15:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD921F00A1C;
	Mon,  2 Nov 2026 15:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631956;
	bh=08oqN1TE6XF/zda2aaIy/jJ7rzXSJoF5jY3Jq8EQn3I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=esP1NXiJtkWIwe0zxy+yALxJft8aenVVlvrmNyeWEmPwwMUFoGj4vVXV8t6fYRCCr
	 PUrWrFhkorqvWNCdJaSQMLf/MWYFqMu/fjhYRkfg/ntu2jTry0OdIErXKyYUuaX9b2
	 s/YJB0wieY9b+/J0uqo3gTDUZNa/iAbOQ22VE6vCDejVVu2QvhNeen/wYMi1uUBddD
	 otQ6tttXu5fna5CmPdbWZ3/5LvyLR1HZD3qs4y3l163vI5ZM0FWutUhg0hU7z8iAs6
	 9fnCJsDMduAv+8gXV1qLG+g/a4WXlmT3vfPCv0fZZv3ZT7nfZmWkFHzOiAfiEsinuc
	 E814TEauo1aaQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:40 +0100
Subject: [PATCH RFC 13/22] x86/mtrr: let procfs copy in writes to
 /proc/mtrr
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-13-c9492ab08480@kernel.org>
References: <20261102-work-procfs-arch-v1-0-c9492ab08480@kernel.org>
In-Reply-To: <20261102-work-procfs-arch-v1-0-c9492ab08480@kernel.org>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5CE0240005
X-Stat-Signature: ih4xywcxgxcxucci8ocjz57dmzpimuyh
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793631957-64900
X-HE-Meta: U2FsdGVkX196sl5Ao0sctpddU3uPFqc7YKzLe4arC5BWC8+4yKQ886KZil+npuWolJrRdihAJgebRNk1i5bWPDEAIhQrDLtgOKkXjUDUso2O+AlhD3Y1FWFp/chySXq5BLPxgyzk4K+dIL93qW14Y4lQ2OSH/j9h3g3QpgErVi5KUGnSrchF2ziArwt008laDC7LMNq7tv807z4JyW8RFht07881na0L5GKj0j5TU9eVaWHtQYralRnZEUb+W8dTbKeQKQMPPpG6op4WMqGE2MHrlqPDRi9MaRephNcnUOVtfWJT4q9Z5aKtAaTLH7jYeVtHACErG8ucLecV0X1+Cm1FlHKkowXEiIMGJJVyneZDow9dv0psHr/3MSlylicf8X+kd1ofectuM4HX4aC/tQXXhQQrTDpppT97ep84YxFrmLoMf0zoR0RTRBttF9Nh0uZOVJZF+3wqpoXwPXUJ0iZUl2XjDPHQDNQf+njOjleZ6UElN1+BAJpI1sBZlYgu+/Ql5ek32BlU4dOb8v37Q++el1IzXcARl3F3nyTPEaaKwiNj89H+bmDA+Kl0Q/Y9kL3GwrXTPym/tXBghy7/a8e55WupRsmulwqrQ9ejxqHGPGBqYFNSmLrY2UoTdWv8bapH41kj/f09qaX8Ntx5ezSfjEewNbm74wWMii/QJXAprna3uFGJ8SISuK0LY3fAluemB/uYk0XkoTAIUxnVX8SNVnkJzsnr+MtJMPeyXbkEcVh+Zy8sPk5iI9OmOfkwegCatw1E8Jl9tCP/n7zGGFf0hED0u+sTpOreeXQoax1zKdfE0SLi+p0WJp2YwIRYUrt0VH0V6hHh2NNbMpGQcw/VolrHJ482Bqze2u0rR8CNLR3LOiAcsWmSh8e7Mzw856Tywcxkb2xD3uES1j5hmjowu5pU4kTc9t6OfY8yZQZZWI4yd1+FdMjpRnXltVJSEE34yWvlbplZzlyLY8I
 NXuG46Ol
 pyewA8k8B/in4tFD6Ezez8NGa72v46Rahn3vvZ5jHKvzZJOoPxJoskAnmHAMMIvpXLm/IHjMzsJBCat6UTdr11393v43gkiMBVuW670ybQpi4I0c4XL90I5zgjFstaOjeX8/VccAwisNouLazKNwyjyyMjknG25eA3s/aKRJhIWiw4y1kgRudX0nNN/gBSUL9R6fE6ltkmphnLJPclAI73MIsfKS8FvhRWSr6aLP6jSBX6+2d4Xyq8+3+CrEP9Qzf9uOA8NEs3mYIeOPvKsR9IVN+TvgpCgyd6GO8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and parse the command from that copy. Writes larger
than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/x86/kernel/cpu/mtrr/if.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index 9510e01d5103..038e2dc38797 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -91,7 +91,7 @@ mtrr_file_del(unsigned long base, unsigned long size,
  *    "base=%Lx size=%Lx type=%s" or "disable=%d"
  */
 static ssize_t
-mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
+mtrr_write(struct file *file, char *buf, size_t len, loff_t * ppos)
 {
 	int i, err;
 	unsigned long reg;
@@ -103,9 +103,8 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 	memset(line, 0, LINE_SIZE);
 
 	len = min_t(size_t, len, LINE_SIZE - 1);
-	length = strncpy_from_user(line, buf, len);
-	if (length < 0)
-		return length;
+	length = strnlen(buf, len);
+	memcpy(line, buf, length);
 
 	ptr = line + length - 1;
 	if (length && *ptr == '\n')
@@ -397,7 +396,7 @@ static int mtrr_open(struct inode *inode, struct file *file)
 static const struct proc_ops mtrr_proc_ops = {
 	.proc_show		= mtrr_seq_show,
 	.proc_open		= mtrr_open,
-	.proc_write		= mtrr_write,
+	.proc_write_buf		= mtrr_write,
 	.proc_ioctl		= mtrr_ioctl,
 #ifdef CONFIG_COMPAT
 	.proc_compat_ioctl	= mtrr_ioctl,

-- 
2.53.0


