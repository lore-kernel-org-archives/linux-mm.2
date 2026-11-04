Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DA9F606B2C4
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=njOAnem7
Received: by kanga.kvack.org (Postfix)
	id 7F6FE6B05F1; Wed,  4 Nov 2026 14:48:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CECB6B05F2; Wed,  4 Nov 2026 14:48:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E4AE6B05F3; Wed,  4 Nov 2026 14:48:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0736B05F1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:48:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E078EA0700
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:48:39 +0000 (UTC)
X-FDA: 85398473958.24.56253C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 36C8D40009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:48:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=njOAnem7;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ngy72uTMwq8MvwxWP/NtrsM5SokWnoNP+4Ao9ix0Oqw=;
	b=lVyA2QIHkFAySwvt6AThyLck9uql51ZgpO83fXYYpwKz9YeBsU9wnG5aa6kojewQOiy3Hs
	XpRhPVXCpDYM9fZXbkAb5vrdG1xxDTd5OedY1ODzOSq67KB0SC0qaNGgIsJxfqKlPZomTn
	o4cbAFHlMmrEygQvV6UTNR1Js1VOcdU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821718;
	b=d+loVjdxyqw74RXM4MR0f5cFYOwzhleUBmfSa+j+lNptf+Wc5iqjIpVMScJTqEo0+5J9YU
	prQeD2npHA/aD3rdk28ntTk1nvHgdnnzRohzHziv+mgBeDR4AZSy/M1t7uSqLKc7ugknAW
	xnUlt3Ys/KeGu9wrngfGmtBbI72AMU0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=njOAnem7;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C429F60DB3;
	Wed,  4 Nov 2026 19:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0BB1F00919;
	Wed,  4 Nov 2026 19:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821717;
	bh=ngy72uTMwq8MvwxWP/NtrsM5SokWnoNP+4Ao9ix0Oqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njOAnem7hZCWCyoet0RXEP40JyR4Yvp8pSYpBwltayKMJQbQC02d6SDgwP3xfs2tW
	 xugmM2WcWgYjdXPF6Mpd2U1pnELiviUGXPgsNw3v3y4DzBw8QX4m5zjJ4eAZUEMths
	 UuP11YcxHe2FKmrAnf0bFq7VlBn/6YRgVmBP1T8N1Pr+4kbSLl5O+osL1UE7K2ty1P
	 oEnDJhUirOpG54zRCn9fBxOKPvej4c0rIHuyjklb9YxqCXBsCkIQ2RjAx+czJOY+yG
	 SGBgiczQci/1p6CrIWfHpSe7cjL18eekUFtsRfK2WYjztl+jvPA9MqISF9cLRounAB
	 d6ISRqW2l121Q==
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
Subject: [PATCH RESEND v2 25/26] ALSA: info: drop the ioctl hook of data entries
Date: Wed,  4 Nov 2026 20:48:23 +0100
Message-ID: <20261104-work-procfs-drivers-v2-25-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1977; i=brauner@kernel.org; h=from:subject:message-id; bh=ytKHjP0KrW2lhifPjaN3U+UGytfp8SXew1PrSRALrDc=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97prYf73Zf87rJ/bzhO9o2U2cd3uTmky32JvXZSUnv D87rpJj7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIqQcjw3w7mYjfZf/2BjgU yhprzp8/L8lsS7vIuu9/1C6a3Z2zPZnhr0jr77LtKiqlbqL+yafW33ec+O1HujL70h7GlBuzOj/ lsAEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: da38hbgc7djdafpajwd5o3hir47u7rm5
X-Rspamd-Queue-Id: 36C8D40009
X-Rspam-User: 
X-HE-Tag: 1793821718-967753
X-HE-Meta: U2FsdGVkX1+nekdJPxwK4hSKobJmWpb4oZDCKqXgTU/lUE47JjdD61GUEnz5nuDU4kWa5C8qjdgCX6JoTXrIIrKAmdPYFCgDNTEeIFlNVK1kKu0PZQaIhA0l5PB6aEZdJZ9AUoAatNBeIbhhebVK1E5thW2m19ptC7HqqmxNqArD3c/n376MonHOxZuSLNt5+nN1l0UPpRhPqsb/2OklskPCPAZn1jCfN85UWRUP14C18oBaUL5MpYYKTSWjNGyVX7IhHY9hrsLL1fYoBhK+2VkhaIhe5haxljl1+Q25Sbi0PhitR+pjAlA8gI4kKAaHLJqVrL+ytzE4Au4hs+uey8XrRK3EiMSlLWMND2/PnypzaFAkK0pPuoMM++Hi2PV2M2UDACCh6kp8fCo/ay/C4Vtt6AZ1BaUgrRrCcyri5nkMsgMXWdG21SiUfc7vPfyyu6CGF0r6/ztFzPXL/s1A1dDz4+Ydd5vnz4MQObKpcFEod3vTc/WDTA2GX40A6xCliIinvVACyll92Drx+jfJFsmlM+a4FmcUaLxHUOgmFgeq/x3/QJwtmX5DFYvlTwdUlr/F1qhQEM8mT7++DMy80zKCew3KoF46gwONLyBVn5EabjkixsYcmfOoHtOcB0/UjGkTjkmminRZm9mEPxMIrgo25bGznboLIGm25qE6kigDzyKmJgdK+tB/ssy+EZTk3XL5js4tNVz5W1rcPulnfdTrLN4dLwaB5izPX/M9ULaU5EttMpIhCcx29MGK16E+J0Y6TtHL7V6mOTaAIh7l8zSXPW+ntMeG9hC/855ezeeUBITvsaSk0lcbcPC2uAKC68E3g7HrS/R3Q3uY4kOHK6Sp39JCaAnko8/yT5gBWZ88Vd/iVoqpXH5nHzNZAkNn7F4VlLgSXYiffUZizw9e+IYYqzSxYA0cRoRkAkAqQPFfnhgssFZxzmVeIRB6xy9qn5FcfMkCcY0gIy85vW4
 GsNr/9Dh
 kJXAuKY9Htx5r6CmVsvDNT9001XOb764X9wwF4i3Rl//jhK6V+wC5VtMgs1bvlYBIIMoqx1dUu7jKa23n1m8QV1GIFcetblFz+6OeMlQhO4E5Ol3s2yF1sxRqcvXIQmAgAnWOdgAPRhYu2/HDlnbck4jbSvLqQi0PhDJ1QsmWydXdbzYjAVoSk8yhDXQ7Kur8hCR2tM2S/tmI2ufq5RL+pwu1/LfEsX4YY1MiixRCLZntUcngS079AveGrx+G8LNZPVMSq1DMzoP6zbg9+kT/Fh82zSzkf7yvTSpw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

No driver implements ->ioctl() of struct snd_info_entry_ops.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/sound/info.h |  2 --
 sound/core/info.c    | 13 -------------
 2 files changed, 15 deletions(-)

diff --git a/include/sound/info.h b/include/sound/info.h
index 67378da4d36c..d6cb0346f77d 100644
--- a/include/sound/info.h
+++ b/include/sound/info.h
@@ -50,8 +50,6 @@ struct snd_info_entry_ops {
 	__poll_t (*poll)(struct snd_info_entry *entry,
 			     void *file_private_data, struct file *file,
 			     poll_table *wait);
-	int (*ioctl)(struct snd_info_entry *entry, void *file_private_data,
-		     struct file *file, unsigned int cmd, unsigned long arg);
 	int (*mmap)(struct snd_info_entry *entry, void *file_private_data,
 		    struct inode *inode, struct file *file,
 		    struct vm_area_struct *vma);
diff --git a/sound/core/info.c b/sound/core/info.c
index 663ecb96f828..f837cfbe7313 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -201,18 +201,6 @@ static __poll_t snd_info_entry_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
-static long snd_info_entry_ioctl(struct file *file, unsigned int cmd,
-				unsigned long arg)
-{
-	struct snd_info_private_data *data = file->private_data;
-	struct snd_info_entry *entry = data->entry;
-
-	if (!entry->c.ops->ioctl)
-		return -ENOTTY;
-	return entry->c.ops->ioctl(entry, data->file_private_data,
-				   file, cmd, arg);
-}
-
 static int snd_info_entry_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct inode *inode = file_inode(file);
@@ -283,7 +271,6 @@ static const struct proc_ops snd_info_entry_operations =
 	.proc_write_buf	= snd_info_entry_write,
 	.proc_write_size = PAGE_SIZE,
 	.proc_poll	= snd_info_entry_poll,
-	.proc_ioctl	= snd_info_entry_ioctl,
 	.proc_mmap	= snd_info_entry_mmap,
 	.proc_open	= snd_info_entry_open,
 	.proc_release	= snd_info_entry_release,

-- 
2.53.0


