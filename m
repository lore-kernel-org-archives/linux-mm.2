Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2EB160BC02C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lwKeAIr5
Received: by kanga.kvack.org (Postfix)
	id C0B926B060D; Mon,  2 Nov 2026 10:16:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBC776B060E; Mon,  2 Nov 2026 10:16:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAB076B060F; Mon,  2 Nov 2026 10:16:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 812A76B060D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:16:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1517514016C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:16:36 +0000 (UTC)
X-FDA: 85390530792.01.53CAE9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 50D6620011
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:16:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lwKeAIr5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zft31zEOyoxpoaQra2tyBUnsx6CBcNbPccBHjIcKUVg=;
	b=aWiHoP/sBihKqmJpD77ZZqhwR2TgHsZcaWkwV5nugK/p0+UGAr+RD7rSKOxokfQSpgbX/r
	olrOtZVu+5k3babo7dLR400QSfmlzNT8/PcMmAUdLPoEX//5Whd+E+fb2fpdOvNhYEqUjM
	qKOWDTqjLNjsbwxtwKHUkzqu7KbxK0o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lwKeAIr5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632594;
	b=JZylqlZCtreZ+Dift/3IDKrCCIDqShkDp4H2Rc11wIZ25zeWO5WjexOHZuQhsqAG5OGs45
	yUWB+Jvy3dpqdM6Sx5whPuYjkpPM0XNGiWlpPtfijXoZwDu5MGXrQjH8KN0uAOkH/tfKxt
	McYs6T6Pv9LbdIoZc3XJNqt8PvAgkzM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CAECA60218;
	Mon,  2 Nov 2026 15:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700B71F00A17;
	Mon,  2 Nov 2026 15:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632593;
	bh=zft31zEOyoxpoaQra2tyBUnsx6CBcNbPccBHjIcKUVg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lwKeAIr5gfFdOVWI9d9xeAawLRX/+XVqTfNIZzgNtLrSPX6u/1CsXECEJL5tNDzMA
	 81vHXmP4nFBhwRmc/4DERMlJX3QJMwM96cPu9uFbIdibRRS+aHrZI2E5D8a9x1Uv1l
	 y72FYfS6k5k1GClENyne0V+By+vwxAzdEjY9MbyHJUJx3+nI4+K7kwwgkmi1p0ISO4
	 9ghnaezbHX5aMMMApF32QawdIaGRPpRDQgJtdD1vqFI5zB7VZbE3n4IduXje7eWoWa
	 uAZM2qTjPRKpyLwg4MYMHyPaKwvk2dOe0ToVz3+E2luGZiMaQunD5RVbSRamL0hSZ+
	 ETwAKz10Wwghg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:25 +0100
Subject: [PATCH RFC 18/23] wifi: ipw2x00: let procfs copy in writes to the
 debug level
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-18-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
In-Reply-To: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1605; i=brauner@kernel.org;
 h=from:subject:message-id; bh=SZl2laNUZYNGFN2sYGUP5fs3tBGCqMuq/D28k7CZWwo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG64euvV9Mi0G6e/pc2cvZ5tAkOWU9ijuqL1VrnM1
 97MmMJxqaOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiBnMY/pddjIrb5bFlB/vq
 T/1p1gs8F8lNfdO6cLPPKu/tLFWSX2UZ/mk7OAg3F8ZXtHXzM/o7ck37wd4VdH5/R8b9gzV2lT9
 NGAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 50D6620011
X-Rspam-User: 
X-Stat-Signature: bu1px4bwitmj3zkwrd7pffe1ihguyqrq
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793632594-228965
X-HE-Meta: U2FsdGVkX18ZFBdix3s1cT7qmag0J1AcSU6p88H9Mg809mWhB2wv+fYQhPQWnTrIFNfnKZOrjrzG77KqF22pRIOP0UkkqX08kpQWVTIfKfCU2zD0cSwPv7zXlj4tqq60l3+42yghn8qARsc+HDbM6HZpv/4MTSm3eakfPjVKUrR2Kfjxdv/cc17z3umbz2U5pGkvbv7q+YAbRHrE6iW/xUZOnCpOyLuzdTVnAPA3gdAMpURtEyKLtjdZP+cC6U5jBtEUZ4/8l5KRmrVtatJ+5Vz9LXXtkpai8Pb116DyqasYxI+TMCAHcOCbesnbiIoMMTiM9/pJaWu6XWkUc587zQ6wMG9Vr2H4DyzdmWDdoy/LQiCfCy1UGQE/xKpR2b/39l13eB0RhPFW8nmf3xct4m/mfu0+pJmH1aa9+3pkrxWy3+Ez83yWbhZZwZJPpAYrVihzWnJcQIhjPOEUEjc2ocs8iY9WKyPu6X9iUfeIUTXlk2f2pfGDMQEeDQirT43wxE1sqroLPl9+YvsZzPga8Jz8w0Se+OP0YIlFJjiZYJ1NXIOde1QNDlL6ZrFBdFW/q4eh6nG23R1c/JgZPqme1NmDHwq0i9hreabZfcYtCt4zD6bUKx6Q4STNqxeltlVjMLkPmG8iNw14LQYJ1FGieqNsclCjeqwRXCRJN7Y8bLcwxkBB8N2a8LCGgV1KyMk6LfDJtC6kp5DOq0l45WQq4z/YMyFUJ0sZBk5FwDkEveVPRGiNFh0Evv3jIAcSQ6YKi7kDdX0IGqWeC8LGK1J0BEOzxJQFwVfdyCssKAbdDPOpA2W+lruziu+f2h2k+lvwh5vHv9b0yERj/S4dYzcq2GRMJDmxRAiZJSaPk/dGxSNrWOnjG8wv8vfSIZnnmpxORIvY8jKWpwnxUpJ49mqLcMiWNvkLSXrQsaCdqb+VhmtrO0WCXi493LUrVq1P/c2IfhNqIFcSiaJFqd0fvvv
 e3bHNaPL
 uDcBEPYPTQrDxQWvgO7cOYoSxo0Ms+pLLMVP10FbBJ7OYmJWAV7azgXV44RXRkETrVHqfGSnpyX2AxeH6PryG06N5cpV97SCdcKa1FVqFiSZ8rw7g5cMwg9t52fJ/po1QSUEzZuF3ocQnD7v1dCKBBDzaNjsvxTlATF2r/UxbTYheujzSxcecqoULdc2uYYDrRhzUC6qzZuwFmc5QaJ9lCuZPnPkxOGe07OsSz5jELgxYLhmJ2f1Tp0ID1OouCQIr/4c18znCuAwH1ECgJWh9Qm/uZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and parse the level from that copy. Writes larger
than PAGE_SIZE - 1 bytes fail with -EINVAL now, and a buffer that can't
be read fails with -EFAULT instead of looking like it was written.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/libipw_module.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_module.c b/drivers/net/wireless/intel/ipw2x00/libipw_module.c
index 15d9a5efb581..08cc0d7f57c1 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_module.c
@@ -216,14 +216,13 @@ static int debug_level_proc_show(struct seq_file *m, void *v)
 }
 
 static ssize_t debug_level_proc_write(struct file *file,
-		const char __user *buffer, size_t count, loff_t *pos)
+		char *buffer, size_t count, loff_t *pos)
 {
 	char buf[] = "0x00000000\n";
 	size_t len = min(sizeof(buf) - 1, count);
 	unsigned long val;
 
-	if (copy_from_user(buf, buffer, len))
-		return count;
+	memcpy(buf, buffer, len);
 	buf[len] = 0;
 	if (sscanf(buf, "%li", &val) != 1)
 		printk(KERN_INFO DRV_NAME
@@ -236,7 +235,7 @@ static ssize_t debug_level_proc_write(struct file *file,
 
 static const struct proc_ops debug_level_proc_ops = {
 	.proc_show	= debug_level_proc_show,
-	.proc_write	= debug_level_proc_write,
+	.proc_write_buf	= debug_level_proc_write,
 };
 #endif				/* CONFIG_LIBIPW_DEBUG */
 

-- 
2.53.0


