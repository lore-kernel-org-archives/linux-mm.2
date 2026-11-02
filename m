Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AF00606A33C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CGKeYdZH
Received: by kanga.kvack.org (Postfix)
	id 41C736B060A; Mon,  2 Nov 2026 10:15:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB916B060B; Mon,  2 Nov 2026 10:15:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BB0E6B060C; Mon,  2 Nov 2026 10:15:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00AA76B060A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:15:55 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A619A42AF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:15:55 +0000 (UTC)
X-FDA: 85390529070.02.3B09CB9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id CB1A8A0013
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:15:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CGKeYdZH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/po/gL747wOLzB9LODGeMVhVpt9eaPUzZYdg1qfmMOQ=;
	b=W3Pr7qyNyeY5nQqFJ8KBpEUuXavGxXHWoJRAhFhIS1+14tD/iwUwvHyu1fHRZe93fm4EKP
	pps39jifKNmKRA0IM+Lk9NwSLQcQqmxSp+8OawJTeRw/5MOk302B/j0EG7CmmyFOTzmgKs
	T9ZUqfMs5nQh2feC4KXpCL/gPTzB6zQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CGKeYdZH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632553;
	b=LHFh9NV+/TLst2o8I3JAob5RPEzUHBfDF/zMbjYmRL89GoK4mrJzuUs+zs6ZQgz6h/VW/x
	RLkj5B+bT/TQIzuStAf1jqo0h/ifOKrRR6A3KTk92HO9MbZA6tOUqvLCUNaMi+X2cK6IOm
	5RKsRTPazp/mBXG6vtQcgm5EA3BwH1k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7587C608FB;
	Mon,  2 Nov 2026 15:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2421F01577;
	Mon,  2 Nov 2026 15:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632553;
	bh=/po/gL747wOLzB9LODGeMVhVpt9eaPUzZYdg1qfmMOQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CGKeYdZH3IwAOCMuWH4rKgTK8AFjvD4vT1A8MvChb7ekc5exPD2bZli39nsFA0rll
	 Wro/pLXxHNScoGUOu2GS9dEhVACBfx94QMr+3AMAn65A2xaiLaTjC73SUe8x8Vxwck
	 TeCW4nmblkVEQmFIwgDcUhlYB0U0/KpXLfCzgE+9+Se3WYxVgLhbEreVGTJlTh7c4u
	 7jg8GYZ3EUYQeyZJ6KtO5lHZzH6stQjbxp/hT7OtsLZZLQOnXqbHn3uMLytT76+H+J
	 11fMUBwYPr5hdM+l9taHXvznWRfSrNsArNpSfoPYVGe++uXgaOyNJuTilC2BxjGnzX
	 V3ffhGBeXv1JA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:23 +0100
Subject: [PATCH RFC 16/23] fbdev: viafb: let procfs copy in writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-16-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7373; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IvpcER7zxYNfDUB5gfp3pz3pT+0GSZCEEAhc7Zgpx0U=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG54f1e88Ubf1/OUJVMEWfZ4yKg+n9wdmu7zh8P0w
 mbtexXfOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbyYx/DP839pVLn/F+/fJc4
 901N3fx3nhnHtzv3nPPxi2y8FyOeH8Dw3+1pcIH7Q+ViI6Yijo/tvDyhr4RWLF3tMmnmydKdZ9Y
 mswMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: CB1A8A0013
X-Stat-Signature: kf7cdh1ftfhizpfbog5kua9bnkrzmwt9
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793632553-555905
X-HE-Meta: U2FsdGVkX19pU1HI9piMdqDT1/o52NlqBstKnxk4nY6+YdCnsMhBwVbw7FW7sk1WOOK7iNLODxqDBulQtmNywaDOEe4iX4vUHFl4IydUWprwQRWKOfEVzZNQVuj04leTA9Tk8SN3qervZjtzebInr9ob0QTk6ThCHyw66cA98ZhunWTW/NKBAmkVyj9jyNjcVAeH2SbjQbMCRFHXky7soyA4JSLhrzf4iMdh+2wVS6squ+dFxjQVTU6voJfZmBbgjv8kSwpvbevdCu+iL2ZXbt3Ndbd+Cu+oNaITNGFhUotTaHv3m4D3AbVoW8XqgLIiRNh0r9llU1G5wZwOsRoGLzm8v7pRYqwfNSDSE/R99Ef5jDWpkAMAG6fseGYsCt0SSNVGLQIawmDaB10ngbtj8q3BBSoDmWSDyvesL1eKKOcmGEV4Hsl4OZ5/hiI4xwQLe+mR4bVwKjFVgt6MPfkB2G+I6Wu9W5uHK5Qw7qhser2IfGtfUkN2uBAnPVjFs1k/oR51bxZmBHlkCFfV1au3db6HaOWEZitvN6CiikrxgrRMBW5eXWCyZtjgyYcxErvjQhaky1VVPbFMOP2kQqR7HGN2FMnxDWVeflAPQCY1DbywQpr3ik3/SnsbixpIuibk55ZKH/T3TCfjmh+j3/0f6CakxaqZlIoCtLUnCG+1ebtMD2EH5cM7v8S/CmN3vrPn87C+cPVP1KE70fG+KkPIBx/+jRmx6tl1uFPtrryMGksyMhRRB0A3wbNzjD1cbqMMmFRPSLkCE5rdOTHMwak7nTiX1DI3zJoJXVsnOpltzpn2DuYzDTvEmpIcgzqIfG1yK0gg/SWLt3oiRYuFcGlw1BUmCuAgzXzZARKV7lmywA2eYxiwxA8uRUB6L1D3G7EjlVLQDvqibac48vbaiB4pgtoCZvWWjtjpqQzUhfsZ5Qc7JjdD6egMxuZSBnTAV/Vx6bY9xMFxp2boOoHkRMX
 1ZDRa/wf
 zQeU7v5HlCX8ww9DzIkk6Bp0gPEu5HUEaGDNCBPE43jSJi1w7pen+/8u8BkiCKCoA/ahkzztj3YVCnQDI1md1LBSJU3RZn8Xcy2ihDGGtw/zNJH/i4LDtyDNSgUsHaIehHi8pQOLtTKkEhVQTjx3WJ/c+AucsFawz/GSbEocCrYMsXBaqnYKrNZLnaICj3WiXNrYyhV5VzdWCWv+JX6XVfSrRrg+OXgS/iBxAfOMk+VkUHqbVZEyAvalqOSDOCPwqm9tPhla6Uk5vBSMmh1otawH8ruJartKPrSEI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() for the files in /proc/viafb so procfs
copies in what is written before it pins the entry, and parse what was
written from that copy. Writes larger than PAGE_SIZE - 1 bytes fail with
-EINVAL now, the output device files refused anything over 63 bytes
already. kstrtou8_from_user() looked at the first 10 bytes of what was
written to dfph and dfpl, now the whole write is parsed.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/video/fbdev/via/viafbdev.c | 46 +++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff --git a/drivers/video/fbdev/via/viafbdev.c b/drivers/video/fbdev/via/viafbdev.c
index 4b617e80a77c..94b303006915 100644
--- a/drivers/video/fbdev/via/viafbdev.c
+++ b/drivers/video/fbdev/via/viafbdev.c
@@ -1121,7 +1121,7 @@ static int viafb_dvp0_proc_show(struct seq_file *m, void *v)
 }
 
 static ssize_t viafb_dvp0_proc_write(struct file *file,
-	const char __user *buffer, size_t count, loff_t *pos)
+	char *buffer, size_t count, loff_t *pos)
 {
 	char buf[20], *value, *pbuf;
 	u8 reg_val = 0;
@@ -1129,8 +1129,7 @@ static ssize_t viafb_dvp0_proc_write(struct file *file,
 	if (count < 1)
 		return -EINVAL;
 	length = count > 20 ? 20 : count;
-	if (copy_from_user(&buf[0], buffer, length))
-		return -EFAULT;
+	memcpy(&buf[0], buffer, length);
 	buf[length - 1] = '\0';	/*Ensure end string */
 	pbuf = &buf[0];
 	for (i = 0; i < 3; i++) {
@@ -1169,7 +1168,7 @@ static ssize_t viafb_dvp0_proc_write(struct file *file,
 
 static const struct proc_ops viafb_dvp0_proc_ops = {
 	.proc_show	= viafb_dvp0_proc_show,
-	.proc_write	= viafb_dvp0_proc_write,
+	.proc_write_buf	= viafb_dvp0_proc_write,
 };
 
 static int viafb_dvp1_proc_show(struct seq_file *m, void *v)
@@ -1183,7 +1182,7 @@ static int viafb_dvp1_proc_show(struct seq_file *m, void *v)
 }
 
 static ssize_t viafb_dvp1_proc_write(struct file *file,
-	const char __user *buffer, size_t count, loff_t *pos)
+	char *buffer, size_t count, loff_t *pos)
 {
 	char buf[20], *value, *pbuf;
 	u8 reg_val = 0;
@@ -1191,8 +1190,7 @@ static ssize_t viafb_dvp1_proc_write(struct file *file,
 	if (count < 1)
 		return -EINVAL;
 	length = count > 20 ? 20 : count;
-	if (copy_from_user(&buf[0], buffer, length))
-		return -EFAULT;
+	memcpy(&buf[0], buffer, length);
 	buf[length - 1] = '\0';	/*Ensure end string */
 	pbuf = &buf[0];
 	for (i = 0; i < 3; i++) {
@@ -1225,7 +1223,7 @@ static ssize_t viafb_dvp1_proc_write(struct file *file,
 
 static const struct proc_ops viafb_dvp1_proc_ops = {
 	.proc_show	= viafb_dvp1_proc_show,
-	.proc_write	= viafb_dvp1_proc_write,
+	.proc_write_buf	= viafb_dvp1_proc_write,
 };
 
 static int viafb_dfph_proc_show(struct seq_file *m, void *v)
@@ -1237,11 +1235,11 @@ static int viafb_dfph_proc_show(struct seq_file *m, void *v)
 }
 
 static ssize_t viafb_dfph_proc_write(struct file *file,
-	const char __user *buffer, size_t count, loff_t *pos)
+	char *buffer, size_t count, loff_t *pos)
 {
 	int err;
 	u8 reg_val;
-	err = kstrtou8_from_user(buffer, count, 0, &reg_val);
+	err = kstrtou8(buffer, 0, &reg_val);
 	if (err)
 		return err;
 
@@ -1251,7 +1249,7 @@ static ssize_t viafb_dfph_proc_write(struct file *file,
 
 static const struct proc_ops viafb_dfph_proc_ops = {
 	.proc_show	= viafb_dfph_proc_show,
-	.proc_write	= viafb_dfph_proc_write,
+	.proc_write_buf	= viafb_dfph_proc_write,
 };
 
 static int viafb_dfpl_proc_show(struct seq_file *m, void *v)
@@ -1263,11 +1261,11 @@ static int viafb_dfpl_proc_show(struct seq_file *m, void *v)
 }
 
 static ssize_t viafb_dfpl_proc_write(struct file *file,
-	const char __user *buffer, size_t count, loff_t *pos)
+	char *buffer, size_t count, loff_t *pos)
 {
 	int err;
 	u8 reg_val;
-	err = kstrtou8_from_user(buffer, count, 0, &reg_val);
+	err = kstrtou8(buffer, 0, &reg_val);
 	if (err)
 		return err;
 
@@ -1277,7 +1275,7 @@ static ssize_t viafb_dfpl_proc_write(struct file *file,
 
 static const struct proc_ops viafb_dfpl_proc_ops = {
 	.proc_show	= viafb_dfpl_proc_show,
-	.proc_write	= viafb_dfpl_proc_write,
+	.proc_write_buf	= viafb_dfpl_proc_write,
 };
 
 static int viafb_vt1636_proc_show(struct seq_file *m, void *v)
@@ -1313,7 +1311,7 @@ static int viafb_vt1636_proc_show(struct seq_file *m, void *v)
 }
 
 static ssize_t viafb_vt1636_proc_write(struct file *file,
-	const char __user *buffer, size_t count, loff_t *pos)
+	char *buffer, size_t count, loff_t *pos)
 {
 	char buf[30], *value, *pbuf;
 	struct IODATA reg_val;
@@ -1321,8 +1319,7 @@ static ssize_t viafb_vt1636_proc_write(struct file *file,
 	if (count < 1)
 		return -EINVAL;
 	length = count > 30 ? 30 : count;
-	if (copy_from_user(&buf[0], buffer, length))
-		return -EFAULT;
+	memcpy(&buf[0], buffer, length);
 	buf[length - 1] = '\0';	/*Ensure end string */
 	pbuf = &buf[0];
 	switch (viaparinfo->chip_info->lvds_chip_info.lvds_chip_name) {
@@ -1404,7 +1401,7 @@ static ssize_t viafb_vt1636_proc_write(struct file *file,
 
 static const struct proc_ops viafb_vt1636_proc_ops = {
 	.proc_show	= viafb_vt1636_proc_show,
-	.proc_write	= viafb_vt1636_proc_write,
+	.proc_write_buf	= viafb_vt1636_proc_write,
 };
 
 #endif /* CONFIG_FB_VIA_DIRECT_PROCFS */
@@ -1416,7 +1413,7 @@ static int __maybe_unused viafb_sup_odev_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static ssize_t odev_update(const char __user *buffer, size_t count, u32 *odev)
+static ssize_t odev_update(const char *buffer, size_t count, u32 *odev)
 {
 	char buf[64], *ptr = buf;
 	u32 devices;
@@ -1424,8 +1421,7 @@ static ssize_t odev_update(const char __user *buffer, size_t count, u32 *odev)
 
 	if (count < 1 || count > 63)
 		return -EINVAL;
-	if (copy_from_user(&buf[0], buffer, count))
-		return -EFAULT;
+	memcpy(&buf[0], buffer, count);
 	buf[count] = '\0';
 	add = buf[0] == '+';
 	sub = buf[0] == '-';
@@ -1452,7 +1448,7 @@ static int viafb_iga1_odev_proc_show(struct seq_file *m, void *v)
 }
 
 static ssize_t viafb_iga1_odev_proc_write(struct file *file,
-	const char __user *buffer, size_t count, loff_t *pos)
+	char *buffer, size_t count, loff_t *pos)
 {
 	u32 dev_on, dev_off, dev_old, dev_new;
 	ssize_t res;
@@ -1473,7 +1469,7 @@ static ssize_t viafb_iga1_odev_proc_write(struct file *file,
 
 static const struct proc_ops viafb_iga1_odev_proc_ops = {
 	.proc_show	= viafb_iga1_odev_proc_show,
-	.proc_write	= viafb_iga1_odev_proc_write,
+	.proc_write_buf	= viafb_iga1_odev_proc_write,
 };
 
 static int viafb_iga2_odev_proc_show(struct seq_file *m, void *v)
@@ -1483,7 +1479,7 @@ static int viafb_iga2_odev_proc_show(struct seq_file *m, void *v)
 }
 
 static ssize_t viafb_iga2_odev_proc_write(struct file *file,
-	const char __user *buffer, size_t count, loff_t *pos)
+	char *buffer, size_t count, loff_t *pos)
 {
 	u32 dev_on, dev_off, dev_old, dev_new;
 	ssize_t res;
@@ -1504,7 +1500,7 @@ static ssize_t viafb_iga2_odev_proc_write(struct file *file,
 
 static const struct proc_ops viafb_iga2_odev_proc_ops = {
 	.proc_show	= viafb_iga2_odev_proc_show,
-	.proc_write	= viafb_iga2_odev_proc_write,
+	.proc_write_buf	= viafb_iga2_odev_proc_write,
 };
 
 #define IS_VT1636(lvds_chip)	((lvds_chip).lvds_chip_name == VT1636_LVDS)

-- 
2.53.0


