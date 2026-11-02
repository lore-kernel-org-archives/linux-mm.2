Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6C1E606A91D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PfFcHu8I
Received: by kanga.kvack.org (Postfix)
	id 0E59C6B061D; Mon,  2 Nov 2026 10:35:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 096C46B0638; Mon,  2 Nov 2026 10:35:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7A76B0639; Mon,  2 Nov 2026 10:35:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C64616B061D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:35:01 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6198440100
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:35:01 +0000 (UTC)
X-FDA: 85390577202.18.6748476
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7D22C40005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:34:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PfFcHu8I;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ulWAa08tPZnJZAAMojZfgqs4wxYXZkHD77FK42yiGkc=;
	b=rnkSakXnF0ITsD2YLpGOkw/NtnlhcVOk8pdPuqcaRbYf++YZTQdoZ6Hkfa0ZN1BC+3ofrE
	18QMCyItd6jiFT1u1MWC5JscNDIgzx2fACQX6cyxLUJ0cIhJFBOrcVdGgylwEmg7PWmxLh
	iZyVs2CqOCZHrUm251gLzofeLiYT82w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633699;
	b=cm4zOkA7ZVFb7s8Pa1FS+ej5ug4Pu3VtmkVTiU50fHVFmh7UCHSR3LrpTNTK0XCvVI+Sy8
	g8JrDxiB8ALvM2Fq4d7UOuGUyqZWjHMYQlNMe5UeNplPvtEUlh2XHwnPEjxmn79EhHkMia
	xsCwNRg24FKuExiXsh7fW6+cIpQ4NS8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PfFcHu8I;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D17DA436EA;
	Mon,  2 Nov 2026 15:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0F51F00A16;
	Mon,  2 Nov 2026 15:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633698;
	bh=ulWAa08tPZnJZAAMojZfgqs4wxYXZkHD77FK42yiGkc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PfFcHu8IBWcir3zWLPuevPTmn2FH1O7NAWSytCLKB2vywNn2OURo4QLe3pteKKhQ5
	 Bfjp3z46zNPbSSOcldRfo1MfN/eHjNC/FEZwM+hOZZ1SrgUl2987I3wnN/6Qhpz8u+
	 h+Zo+EgQmtTxYjKVO1PK7PTyk+17j3IQ3luoVrnilEYf97ksMn2/9hMDi2C1SdwzP5
	 pEgh4EbwBnwEYCiQ9Fpriwr/KAxat0dZyL36NrcXB+GoWNXGpvEfmeQXawM9lhuJcn
	 bRYIHlfjqYj93JSJ18MlNaEuFao8XaMk8JIhJ71DX2G29goCMENz6tPu/GCcoBJiCg
	 s2hgrd9oFJynw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:25 +0100
Subject: [PATCH RFC 11/11] samples/kfifo: let procfs copy out reads
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-net-v1-11-982104a4f592@kernel.org>
References: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
In-Reply-To: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3702; i=brauner@kernel.org;
 h=from:subject:message-id; bh=20rJkgesQhfyVvX+iP+2cn2t9uRQnDiG02PYUBwi/V4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG7yZ/7FDwsifooGMJc3ds/I7m6u/fBp6rcCmRo+t
 imb4pR+dZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzEUpXhf7HCvd1Ci3ccsanY
 xP6t4JnXXklWPoW34sI98hwf12YZtDL8j3zfcmDGjjt/p/CWFp7ZuWC587OTkueWSXM+eMQevaW
 EiwEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D22C40005
X-Stat-Signature: qaaagjmzbwnwbrqcza4yhjr75kptokri
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793633699-862590
X-HE-Meta: U2FsdGVkX1/a4dsl+SLbeL4UPI5BZ2ZsNME9rGeLYbQO2XSp3lGKNA1+C3LSsHlclJRxSxE7ioSfdo0kQoBcp+pnEB1YaIUGPDjMGhHebGOr6G+ATi+d7RuuIeSoJC8o1SFTTUOC6vi6i2lRz3/Y6j41qzDXF0/z7FWQICYHp9hb9BoId94VZWwCAqGS7mDifdJ8ri3fv9uJcWiKBN8zvBI3JONPKD/JnoVL0M4GsooEI38iQE/IKqnJ2LoskEQBrhvIICMJtoJ7IT+7K6ZxVrtyVuTY5gFODjyLORev2nb+rgks2m/KTXVwM7EoOEgeI6duNkKuHepXRALOdHlJTC7WV3wq07pdiUlPxEgit3+Ckgi3egx3ao28uv9wYT92b2mtG71MNk9pBdNB45sIQEk9QSxj5yQJuXwBoG0uV0MiofJcUsABFBEhIp3qznSDVsUinWPNaW3Mue11/2A9ylZ32hOualXISz+joCUBX/GplUk1qY1GqS4ZVDnNRHg7FYsHztx/R/1xyLles17D3eEdPMuSdq+1bRXPgWcGxC+RHC0uxFzJMm6s05DTQ4vY8IVVg6gM3EhSR73f1pgxN7ZP5NxkScqfplhc0amlKhcKD+TZ9Q3ceeZLDGnoUANCBRNUiTAc8XPbWYT9HOpIeciJXVAFRjlEDlXMuZ6vTA3QQUbSx7pcEqhwM5JeuD5QetI8Q8IDfhvyczA6+lDCzWd5iJRJmgShzmKW6Je1hC4N+F7ZXeu3W+V/VUNKRcZY0BKumYGP+O40cbrqUUbvzE0OFiUy5HYBrH/qFHau+mmAy8lsPn8ChuCNOUqonoDpDJwJBjB55W19C2WlXHy+u28ETj0I8UK6c37ygSPvxvQz9GUKQDHS/M2AbpKCGezQIvMXC9qj4l+t/lOxca3kTB7mN42rduvjd0OufPio7ODNGpaX5T5ErUfVK+f8m/g06kHSGQvJ0UHQ6j7or9C
 C7ei6msv
 QWTNq8V3E0O+qpJJfLCoQikAdVMrY9rNWOJ5JG68Sko45iPj50cjYqfoDU1kbTtot42f70ZjL2nKIsuHLz/ba7nf0kaJGtqPS/uYethh39Ttmax1uc6Ot2yvjKNKjgooqyEWj7+GC0MK+wBBosnrWTYRHDB/podcQLIi+oPFIsw+1mJO3dI6s7cTBmLd31iizq23Jlma60h2+TMboqw/V6niR9uQYjyng+F7x/FLDYFFSYDSWd/+Dma3sPhe2jaKDTalhoC8Fy5J61se4jkNEg8u50O8tXXxAYI+j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read to userspace
after it unpinned the entry, and take the data out of the fifo with
kfifo_out() instead of kfifo_to_user(). A reader that passes a bad
buffer loses what was taken out for it now, kfifo_to_user() left that in
the fifo. The samples can be spliced now too, and a sendfile() from them
into a target that fails or takes less than was read drops what was
taken out in between, like for the rtas error log.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 samples/kfifo/bytestream-example.c |  9 +++------
 samples/kfifo/inttype-example.c    | 10 ++++------
 samples/kfifo/record-example.c     |  9 +++------
 3 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/samples/kfifo/bytestream-example.c b/samples/kfifo/bytestream-example.c
index 8c58fb46a2bf..214e46a64cc1 100644
--- a/samples/kfifo/bytestream-example.c
+++ b/samples/kfifo/bytestream-example.c
@@ -125,26 +125,23 @@ static ssize_t fifo_write(struct file *file, char *buf,
 	return copied;
 }
 
-static ssize_t fifo_read(struct file *file, char __user *buf,
+static ssize_t fifo_read(struct file *file, char *buf,
 						size_t count, loff_t *ppos)
 {
-	int ret;
 	unsigned int copied;
 
 	if (mutex_lock_interruptible(&read_access))
 		return -ERESTARTSYS;
 
-	ret = kfifo_to_user(&test, buf, count, &copied);
+	copied = kfifo_out(&test, buf, count);
 
 	mutex_unlock(&read_access);
-	if (ret)
-		return ret;
 
 	return copied;
 }
 
 static const struct proc_ops fifo_proc_ops = {
-	.proc_read	= fifo_read,
+	.proc_read_buf	= fifo_read,
 	.proc_write_buf	= fifo_write,
 	.proc_lseek	= noop_llseek,
 };
diff --git a/samples/kfifo/inttype-example.c b/samples/kfifo/inttype-example.c
index c5d16b815e73..8384d7f8de6c 100644
--- a/samples/kfifo/inttype-example.c
+++ b/samples/kfifo/inttype-example.c
@@ -119,26 +119,24 @@ static ssize_t fifo_write(struct file *file, char *buf,
 	return copied;
 }
 
-static ssize_t fifo_read(struct file *file, char __user *buf,
+static ssize_t fifo_read(struct file *file, char *buf,
 						size_t count, loff_t *ppos)
 {
-	int ret;
 	unsigned int copied;
 
 	if (mutex_lock_interruptible(&read_access))
 		return -ERESTARTSYS;
 
-	ret = kfifo_to_user(&test, buf, count, &copied);
+	copied = kfifo_out(&test, (int *)buf, count / sizeof(int)) *
+		 sizeof(int);
 
 	mutex_unlock(&read_access);
-	if (ret)
-		return ret;
 
 	return copied;
 }
 
 static const struct proc_ops fifo_proc_ops = {
-	.proc_read	= fifo_read,
+	.proc_read_buf	= fifo_read,
 	.proc_write_buf	= fifo_write,
 	.proc_lseek	= noop_llseek,
 };
diff --git a/samples/kfifo/record-example.c b/samples/kfifo/record-example.c
index dcc749247c64..29d08e90a63d 100644
--- a/samples/kfifo/record-example.c
+++ b/samples/kfifo/record-example.c
@@ -132,26 +132,23 @@ static ssize_t fifo_write(struct file *file, char *buf,
 	return copied;
 }
 
-static ssize_t fifo_read(struct file *file, char __user *buf,
+static ssize_t fifo_read(struct file *file, char *buf,
 						size_t count, loff_t *ppos)
 {
-	int ret;
 	unsigned int copied;
 
 	if (mutex_lock_interruptible(&read_access))
 		return -ERESTARTSYS;
 
-	ret = kfifo_to_user(&test, buf, count, &copied);
+	copied = kfifo_out(&test, buf, count);
 
 	mutex_unlock(&read_access);
-	if (ret)
-		return ret;
 
 	return copied;
 }
 
 static const struct proc_ops fifo_proc_ops = {
-	.proc_read	= fifo_read,
+	.proc_read_buf	= fifo_read,
 	.proc_write_buf	= fifo_write,
 	.proc_lseek	= noop_llseek,
 	/* kfifo_from_user() cut a record to what its length byte holds */

-- 
2.53.0


