Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E76A7607383D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HynF0hwX
Received: by kanga.kvack.org (Postfix)
	id CF6DC6B05D2; Wed,  4 Nov 2026 14:44:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA7416B05D3; Wed,  4 Nov 2026 14:44:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B96326B05D5; Wed,  4 Nov 2026 14:44:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 963706B05D2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:44:27 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 31D7D8083D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:44:27 +0000 (UTC)
X-FDA: 85398463374.02.85EFC42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 725FF180004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:44:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HynF0hwX;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGxB3CLuL3hdMOFW6c8rETuQc0/Gu93ks+OA3zHK0Kk=;
	b=P4D2aXHA9yL3C3/yR/vtCbteprPtnaHzTxFZJlmoRNpTN73wml6pyd24KhPrssxH+8nR4q
	FJderrn+qFsMbpXH54J5tcXYFwE0dVnniyUN3KHqHtmLah6ZZ0eEqclrVAhLQAryNlQnkb
	AHSvV2Gw3Z6WLJxt5ERCqlLrfQlsGiI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821465;
	b=yO9l0PY3jWFw1kA2J9cRTsz/ovVqEkYOrk6fmH9W8PxyyvwdwKt/HCzFcTvOb1Oq+VvvkT
	+BY8sVrfhKMmm0LcK6Fu7F/j8rhhX4ITMjBProoEdQGUoi7g8Y/FoxbumsPHvShqB9dvJn
	VqzY3IJFYMIemokHOKWY5IG3cefB0io=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HynF0hwX;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E839260F13;
	Wed,  4 Nov 2026 19:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9144A1F00919;
	Wed,  4 Nov 2026 19:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821464;
	bh=RGxB3CLuL3hdMOFW6c8rETuQc0/Gu93ks+OA3zHK0Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HynF0hwXz2ytbvRQ/tRwwiFgyWz0vIkPCQxUNQGSX/NnDGQ1w68NuKQ3Kbl+MqoQX
	 8J7oHXHcLTQG2lwNLxQCXX70LF0ZV8X7+sNuxCRB/h6LupRGDVaGgTpLhVB66N3rc6
	 tI4jBI+gZnk53Jn6xXJOB3T4pShCBRo0303YUYjU36zpeR5Fq1VBCTSBJgs9D7xNoL
	 nRM7Nf0ZRQUe280MUMB6gTrfEPRIGT2ideQc9QRKVPxb3VQzoUYiRRvvW4mXYoSbZK
	 CT7o3OoXqIatD6R9YkyrZxRNz94QoWOLCKEAfJ5VkH6HUvCBuSP/1PTuWytCnUt3iX
	 I33mD4o8jVx+w==
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
Subject: [PATCH RESEND v2 08/26] s390/dasd: let procfs copy in writes to /proc/dasd/statistics
Date: Wed,  4 Nov 2026 20:44:10 +0100
Message-ID: <20261104-work-procfs-drivers-v2-8-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2121; i=brauner@kernel.org; h=from:subject:message-id; bh=tPoM7KW2jugAI3HBgjDAkvMMKrMKVevq5gq8BMZsIqc=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97qqZsvLFCqNf+6XMazRbVi3d/ODSoR215t5nK5i4r bYImJcc6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI84cM/wy2X+zn+HlNtd83 kD+IaZPCPqU9hps4WOckbNvx/OehSHlGhlOcc5yPTdmUf3fCaiuLkJ2aUg1lKVZe31ctszCW1p/ gyQMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: rprg5mgg7qc1ab44qtwjcjub5t655354
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 725FF180004
X-Rspam-User: 
X-HE-Tag: 1793821465-578375
X-HE-Meta: U2FsdGVkX1+eDaPO8x+wjnDWpciPizgbih0cuoD4GfA0kwYXW1/bl/oCLZa6tEIqVgC6J8Oim12/YeAbfY+b/FsB3S/rCbgwTWXjb3c/7SJJhNV/3c4nzu/9Jw1UNnLTEuSTMjMFubc/yQ7F5LS5Q7/GF/Dh1rZkknCnt/ROVyfq+kZoJABsh6pYWNgXeschm+p9GvBh23Ipq5jfHkHxstgCxd1Krftt5RbMnyL9yGeeAUX00xqX8u7HPbFTtoNwSzORiRRN6HK+r0G/dUvwCSFfBbm3i0yN3wIg4h7CuX7OkndR3VuCBIofIdMiLV/OBQ5J9kyWkrKhOyG8XE6SVkXWOp+tb7tISSryg4GBp5VN5T9Sq7Gvc0vcmkdJkuB0oP3f0BvNq6ytp/hh2pHiIV7UHf1+aC3BHcelfj5EqisAF3Ig1Fw8BlKuBZSezgt9TnnO1QBB7ggzk/D5QQ8jDjtIIB7UowKJFpJCxLMHQRti0n3IldBllXJ9stB/C+NlVdbHp2zY8Mqqh0F2xPiu2g6Ni0i3RYStvz5nJrlFkLi0KoR7fCFUj1xwF4VcNWfaELo9azb8/6H4NwTz2s1Tz139JXHz8JkS5RIzM0c/j85xJD+Uqyx3OJAyI1lYLL/9e3ko/Pxv6lAdEXcDawGG0zJy9i3U5RqKIauxIWvHQ1pb15fQnqFeVsuma0MzrY0ujq0xkeByBuWskjZMq8o+hxS3itetLmwhwdShJd3+lqxNVAhXliGY28rAU5UYZTEE86xqsveK/XKlvWiExSX082v5i7VYgexHDe+jCkolOuLmIP/O5Pa4lzzRN/ZZa8UJQljG4hFa0zezDrwc8Os4WOP6RVTa4ADWUMhcHI6pBAKJTTxjTpUappe5eRdt9qAvFdnHJMgFRK/uNLlJOZW9J8NHcaSQDwNPJGXZQwls66JlKxS5CO5ZviAciuleZkyPDZ9E4h9otzpxLtiB+pN
 wivONrC7
 I+/cSaOAeVSytGzT+7372Bks3oR7TevAXwPiLcTZQ2zKlCE5Zhn6jVBkA2VtujPfLpaeiW3q9knNwC2KYrgGkRjFgJY8vWvABc2Q6LZsoltHTJIdwX/yfo5TCQPLjTWbuGuNyPcBCeucfOhdHECUcxYmYCMUFMPeScYI6veuCABwFpwtEn+MRv5Tjn4F4WwXJ78ffiV9oL1HxbGxewC0CNxBFA//PWc5B6lxeD4Xo1fxl8Rv1hbj6Ky5UPThcvmUax9qzbjQb5vGRrU0Jrw73r5HKFyoqFQV7XtD7twrtcphh+jIpyTi8Xv79DvfD+x7IgFfhAc8uZ2Bx+sVbg4hRasDu7KlFFjhsWz6QZEXBYfupRmawKCvEe4YFpzZUnchq2Y3JQ/nptwCEDV4ydU8Q72VRO9lPaPaweJ/fxBAz8339vquWW8/b0C/2ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and parse the command from that copy. Commands longer
than PAGE_SIZE - 1 bytes are rejected now instead of cut at 64k.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/s390/block/dasd_proc.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/block/dasd_proc.c b/drivers/s390/block/dasd_proc.c
index 86399427f01d..6c3bbb7dfe85 100644
--- a/drivers/s390/block/dasd_proc.c
+++ b/drivers/s390/block/dasd_proc.c
@@ -15,7 +15,6 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/seq_file.h>
-#include <linux/vmalloc.h>
 #include <linux/proc_fs.h>
 
 #include <asm/debug.h>
@@ -247,17 +246,15 @@ static int dasd_stats_proc_show(struct seq_file *m, void *v)
 }
 
 static ssize_t dasd_stats_proc_write(struct file *file,
-		const char __user *user_buf, size_t user_len, loff_t *pos)
+		char *buffer, size_t user_len, loff_t *pos)
 {
 #ifdef CONFIG_DASD_PROFILE
-	char *buffer, *str;
+	char *str;
 	int rc;
 
-	if (user_len > 65536)
-		user_len = 65536;
-	buffer = dasd_get_user_string(user_buf, user_len);
-	if (IS_ERR(buffer))
-		return PTR_ERR(buffer);
+	/* strip linefeed */
+	if (user_len && buffer[user_len - 1] == '\n')
+		buffer[user_len - 1] = 0;
 
 	/* check for valid verbs */
 	str = skip_spaces(buffer);
@@ -296,13 +293,11 @@ static ssize_t dasd_stats_proc_write(struct file *file,
 		pr_info("The statistics have been reset\n");
 	} else
 		goto out_parse_error;
-	vfree(buffer);
 	return user_len;
 out_parse_error:
 	rc = -EINVAL;
 	pr_warn("%s is not a supported value for /proc/dasd/statistics\n", str);
 out_error:
-	vfree(buffer);
 	return rc;
 #else
 	pr_warn("/proc/dasd/statistics: is not activated in this kernel\n");
@@ -312,7 +307,7 @@ out_error:
 
 static const struct proc_ops dasd_stats_proc_ops = {
 	.proc_show	= dasd_stats_proc_show,
-	.proc_write	= dasd_stats_proc_write,
+	.proc_write_buf	= dasd_stats_proc_write,
 };
 
 /*

-- 
2.53.0


