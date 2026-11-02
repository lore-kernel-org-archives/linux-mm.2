Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDCC4608F3BA
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=edn0AYPt
Received: by kanga.kvack.org (Postfix)
	id BB5696B05FA; Mon,  2 Nov 2026 10:12:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B66A66B05FB; Mon,  2 Nov 2026 10:12:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55A66B05FC; Mon,  2 Nov 2026 10:12:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9286B05FA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:12:26 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B73C14014A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:12:26 +0000 (UTC)
X-FDA: 85390520292.21.BE33247
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 52C46A0011
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:12:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=edn0AYPt;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGxB3CLuL3hdMOFW6c8rETuQc0/Gu93ks+OA3zHK0Kk=;
	b=ahMbdQcb7LusJFf5a94p7MD7EM4henPHbQk2LsNmdy9cszJLtW8WUi3uqmbYr1k8sHDXzA
	WAyY7pXgL97T76TPgyBtbz1aKwEObSASLxxLU/8r7ymFMz4n+ThGnjZfGTNaGobKiKwQSF
	Cx/nP8px9GxpsjwStm5W7/VJDYCrdnY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=edn0AYPt;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632344;
	b=b9x0mEwiWfAEAeQaineN3XUeIIfAlYnyHXwOr3qyF0rV9qAdUTABgkndaBPFoOuQPBufMI
	O1ifeLvrupI0wrNbXomKpa7FktoMD16ThV4fSHorZ/0O7xukpN0e83CyJYwxN6PlX/5N3K
	eYK2ERpfGmSgnqv52Ky5+DYT/eBcfks=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4443605C6;
	Mon,  2 Nov 2026 15:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82CE1F00A16;
	Mon,  2 Nov 2026 15:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632343;
	bh=RGxB3CLuL3hdMOFW6c8rETuQc0/Gu93ks+OA3zHK0Kk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=edn0AYPt5jRwhzogids3xv0SIWD2ZJhmY0NQPvBljECs8aa0X00ejVbwi8wkj25C/
	 2U5H4P82mtq9mk7Gq7o6e3/c1q4G3kbagk9jpohANeLaXrMVCD+eHlCpevZFWYYYSS
	 zfdTR6xsYkavU1Yyn93mOd5uM9GVA/ziiwPly/tLPD8EKmEgx8k3MJ6ijWmLm10fQ5
	 aAJwWIQlFfdnqETK+vq3WSm6gSr6XKfcJMe7u/+KEhkto92jBEq1FJaT413U5aWoNC
	 fX2qVLNTgmiFU3l4keyd4RISYlleq5zE0TOEd/g/8NAtAr7PPLpG0OuAXPXHvgwwGx
	 A5koDE6WAQthg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:14 +0100
Subject: [PATCH RFC 07/23] s390/dasd: let procfs copy in writes to
 /proc/dasd/statistics
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-7-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2121; i=brauner@kernel.org;
 h=from:subject:message-id; bh=tPoM7KW2jugAI3HBgjDAkvMMKrMKVevq5gq8BMZsIqc=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGropzCjfwupU8fn9+VxtZv2ThSIu2nz9SfrAQKMYBoRl89VB
 Ih1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmropzAACgkQkcYbwGV43KL3vwEA7DgZ
 qwKtRcRruUUjfm5rBcGQ2NDy+57vyMOGubX9wNEBAPGDTMKrc7NwpMTdmoTSB/UBaD6PA7NAvur
 lg4LjKr4D
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 52C46A0011
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 7nmafgucyesec4yhryunew319irizrhh
X-HE-Tag: 1793632344-364689
X-HE-Meta: U2FsdGVkX1/XINf6wZMvSEPYPcloIY6UmbqhQyV9whlAorGUiyE4eavCXGDZ6CHbVz1Vh2OGFIWj5vHLq1B4j3xlKSZEPDV3DFTxNg6RnJJ09INr12v/MXzlbGnbMRJ+EWe4cW0estvGm1O8gSeOnEEkkF33GGoKoHyDIRkbw//AY+p+EPeqHH2JSxElg/gcaWeQbRNmAJkRoELbkFeF7koFq8ZkTB4fP9Wxg/D473lWieTm9EECCOz2zdjfnUo85hlpDKd92mrF/AKGZ+P5Sic6gWAcBgLK0pVFMllMZ3LmMp/VlVEqwq7JDrOvg1VxrWixS4Wv6zpt9hywypyBIByUUDbPOI0h/95xL+oSOrGcx//oiKvh5MjewO63dYkrLle3hP1TVndStOgST2rQ9p7QuWVqXi3ll7YrZ43yY/9IrunKHO979Ne/4LpIEHyK5O6ZElmrHbG7GFt1FhJuRzBHZUp3/IqdMX5FoyQG7GkpfVquY4+WUYSVWWxcSx0WfVfLLf1Pv717pgZQ7RZlEDDwr+zCq7Nlxp6yhZGdgAo2NjyEYUMUIvXKiFw2V2PVgmcMXN1aJk7lUpSfo202pGXtW/BO2TTKJtxx+tWPBUFeqBZP6g7viqIjXTnLQQ/bjl6sBGlPsGyCSrJToi+4iRWICZ9CE86lw7a9q/N3txOBDdImfXMQZ2TB/gjUuBniGo0UcZPG79Hq0surnOMF2r1xqI7E8H9bqcf28Ng6ZuzPE5HZWKEYyjFPS37LlVQcTrpGlIUxhcJgFLXZu3k1KgAQ90HmJAatrL2U5kqMFfV1z6cGDNeEb2hNJ0+NfW+1mOIJK4aFmsarMqAJe+00pN43j5BwiiT2gkssjSqSz8wTDxwXNRgUHsenaNDeXhC2oMyM+Izb5+8Rqw8LH8EFFJTBMg96AnBsu8muF9mCLUsk3gQdyKFqo4/L4H4sofzviER/pvqUAYxN67fBTx4
 OOguBy73
 RzNpae8YQjVV1In13vqVFNXUh+EAs+I/W2uyWSXDwiFKu3VKp1/xYK1kSuRIKqi+6duUv2PnMrwIIkCXsNSI6PFjeu+9sMyI9D4AIZh7VrraqBOSuFDBw8g1j7Ddj38LLOJG8TTheam10EtX08ZDVk7qUlYlHD+CB1AL/qJCgRhMnGLF6fr63OrOeOqU7ZtdOwAr/40AjFsHHlamF+ccRGG4Qjj1h6g9u/MHwb3sRU+XhHfOz0oOw2fXiIHbF6HnOuApOWyDO8xQvikgdoHw7nP3ozdiUrJfnaC5lTYJ2Q0YE5mEKbHd+JMBOIkcf0FIJ2Uyk
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


