Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD66A606A85B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WGVy0U4Z
Received: by kanga.kvack.org (Postfix)
	id 028AA6B05BD; Wed,  4 Nov 2026 14:46:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0003A6B05CF; Wed,  4 Nov 2026 14:46:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B776B05D1; Wed,  4 Nov 2026 14:46:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB6056B05BD
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:46:26 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 390FAA0837
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:46:26 +0000 (UTC)
X-FDA: 85398468372.07.A2D8E3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 588BD1A000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:46:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WGVy0U4Z;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821584;
	b=PyFpSJb+nVuFNWylLHe7ICA66aOBpN5Vk7hnX97ABqkGb43fWNeC/2w+JXA/7FahBImEGa
	JtzZ4Ybt78fC6XC9tsj3I7LJSl7p7JniqTFBNBSO0mHlCXDfJ/sW/m3HEuKn1suQxyV7sY
	eWBCDOUCXTzcEwXwjMirAVWEt4B4djE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WGVy0U4Z;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bLxRwCxtJ/P3YNIr6jvbkvrLQvoA3ATHIuHzWzBn2J4=;
	b=hD5UTwfAR9pwG2IMKCwe4MqkS6zUJJTJcV8km6Ch2yibNHynUsiyDn2b4eBYV2d6DFZfeL
	IczApj8LweBFISpoa0xRPENzFS+W6y07BUO7/hYiyYwH51xWznQiAWrVU1LZB8yrqw3p62
	wzjHvIT/St8Aw/+nnhyeDFlUGos5zkQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ADDAE4158F;
	Wed,  4 Nov 2026 19:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A131F00919;
	Wed,  4 Nov 2026 19:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821583;
	bh=bLxRwCxtJ/P3YNIr6jvbkvrLQvoA3ATHIuHzWzBn2J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WGVy0U4ZGU9MGVkN5s11MIXd6L4ZW80HabYvpXJKD2FbPo/xhXTihbhJIMMm5yjgp
	 g4YoG2gYjBvHEd55qb/8eKrNcGJy1t5KQ1dMFb+unC9akGOcKREFdMTo+rMdiE6MjK
	 Qwst++hGuwNHrO6Pz5Ks38sCNLj6UOvHgHDN9vlcHkhT4XUB9TDAQIPtYVe0zpxjMO
	 fYYp180+QK9mYvyWZuTSecCl9SsUr4g9V4K9vcGIrma64ubmtN9f0W6WY/GJ07Agnn
	 WhsV+QgTvy+81YnNiXhZ06V2DcHYqbpniOh2Uv9igjKmY8z2zlPURD68B8addMVZFO
	 hlNvylhXD/36g==
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
Subject: [PATCH RESEND v2 16/26] hwmon: (dell-smm) let procfs copy the i8k ioctl arguments
Date: Wed,  4 Nov 2026 20:46:09 +0100
Message-ID: <20261104-work-procfs-drivers-v2-16-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4573; i=brauner@kernel.org; h=from:subject:message-id; bh=negOiIwbpBXFbC2+4UQ2qelUCL0pz2XjdZael8czB8w=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97mqLC7v46Tq/2OM60YXF/IwJT7t91n/WXTRlC8/Kr INzkoqfdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykz53hf4aK+JOF56xXan+K c/qQJNoTJsxh93zLrnNOQlZHxI5n5TIyNMhMV5L+1b3683u1mdyPpT5ct+p2sVs5/2nS//WVvHM S+QE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 588BD1A000A
X-Stat-Signature: nwg9ergrttfup84of4e85pnthiswfgcw
X-Rspam-User: 
X-HE-Tag: 1793821584-52697
X-HE-Meta: U2FsdGVkX1+KQ/rJ8EcU/V2gCH3zVOJKU+sBpET77ZBcWpqbA/p862lSNLhKZB5V/JeusilNev8/qvV72pIcjXm4teCVev0bJVKLctTh52UH/dYWzjps7TjMXkk07BPb9Joen9zEm4rsfQGCvmjXTuZZ7KJxwWzMLJQOqekbDEasw629U7ORzz6s7eX+bEjy4R7KCuJ+/WOa8OVntcSQzH1koK7DiFvu2X79RcMm2UX7yOW1tktwkt66MJfLjh3FnQhLr8EQwTP6Ci7ONlLWB0yxTKqngHbro0k5RDp0Hujorvko67YoZfhc0xaIkgJ+srdLedzJSCT2Inp5bpfjh+x05F6v3YJg2A3P+BGn0ACnYt1V+pUtFWsYcEebj+DJ50GpNmUJUN5143nX5n5Y4W0F+v9p3+H97q4K7Nuwrp2TtkSqKUgjWRbdmWJiKmwtmCv5lsh7JNwdN8md9ozAm8/friDHfQ3MHzIkVcahyMQk3qArsGbQ6jWHDMhdOOoEAsHRQz+7EGlAEXwvFKVoCNveDDF8CmphhFMsEc6LFWhWwr+7np6MVCGo4KlS3ynmox3H91daeitCVgOXu1Axq4jY2l+fMXtd00+y84v3/pPMBjCI+SkXsW6Wvx3ZX8wJLsAwpCDPwCubc8NOkntUM2WzghKGWThTo8kg1BR5crCGE1edKVYG9TH2hzj9WKqXx7f6IX13m/ZomhrfeBU8nXXHIxNuTULsU3JLFs4nPPBFhH7WMLmnUK7AMznT/yQk7IUY5h7U1iTXVcMd4yedgLIGFoKZIhpDl7e2970gTL2yt49HWp7+LKDmfwWBawLif4X/bRNKGMtfYZUZb1jQMqYqY4dAohNXDOZhECo/RvDn60ZOXztaABDHWEmg3gqfvHaWv2+gFc+t4lYja2sdzndwkKOoB2oycFEKqz7DfRXE4POZwT0F49aQkOOpmnGArmRJuovTdlsj9vX5cpy
 TUZpdchm
 s68a6eBK9n/qIG66dDbRyVBw0j1A9HjjLXbFw8fycoXf3Dwj9JzN8uvhrkc1xGWGxUUXBqNcZYZ5Z1ZWsDlHvIyau0spGmOowtTHnuQfEOAjyCNRVQJ3NfZDdvdeVU4eXqFKsvkQ1t8qsFTfIuGhFbuAlU8vIjqhmpgq3Myqb/djsHmHIqqBeBPUncpKV+cm6OtwDP07SprP2ERF+DU7OChsnc4nS/YL1rJODDRTCsuKhl0M0AEmNPu4D3pjRLFAXZ6UNnI28cARztGQ/61svETQz7FziyL+3wFWbPGl2Cujv8GLLrJJHjNhcigaXsbaITswVlnMI0XgKj+aDdqK2qIzPD50+XZrksGBnOO7LkwNdEEC8cPj2CzVGByxPX75rnsO/W56AaZbshOjGyGlpsZ0Tdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_ioctl_buf() so procfs copies the arguments in before
it pins the entry and back out after unpinning it. The command numbers
in <uapi/linux/i8k.h> encode the wrong sizes, so the table lists what
is really copied: an int or the 16 bytes of the machine id out, and one
or two ints in.

A NULL argument fails with -EFAULT now instead of -EINVAL, and so does
a bad pointer to SET_FAN from an unprivileged task, which got -EPERM
before, since procfs copies the argument in before the entry's own
checks run. 32-bit tasks can use the commands whose numbers don't
depend on the size of size_t.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/hwmon/dell-smm-hwmon.c | 48 +++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index 492b2b6c6d7e..67b8c6e5752f 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -549,16 +549,13 @@ static int i8k_get_power_status(const struct dell_smm_data *data)
  * Procfs interface
  */
 
-static long i8k_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
+static long i8k_ioctl(struct file *fp, unsigned int cmd, void *arg)
 {
 	struct dell_smm_data *data = pde_data(file_inode(fp));
-	int __user *argp = (int __user *)arg;
+	int *argp = arg;
 	int speed, err;
 	int val = 0;
 
-	if (!argp)
-		return -EINVAL;
-
 	switch (cmd) {
 	case I8K_BIOS_VERSION:
 		if (!isdigit(data->bios_version[0]) || !isdigit(data->bios_version[1]) ||
@@ -568,17 +565,13 @@ static long i8k_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		val = (data->bios_version[0] << 16) |
 				(data->bios_version[1] << 8) | data->bios_version[2];
 
-		if (copy_to_user(argp, &val, sizeof(val)))
-			return -EFAULT;
-
+		*argp = val;
 		return 0;
 	case I8K_MACHINE_ID:
 		if (restricted && !capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
-		if (copy_to_user(argp, data->bios_machineid, sizeof(data->bios_machineid)))
-			return -EFAULT;
-
+		memcpy(argp, data->bios_machineid, sizeof(data->bios_machineid));
 		return 0;
 	case I8K_FN_STATUS:
 		val = i8k_get_fn_status(data);
@@ -593,8 +586,7 @@ static long i8k_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		break;
 
 	case I8K_GET_SPEED:
-		if (copy_from_user(&val, argp, sizeof(int)))
-			return -EFAULT;
+		val = *argp;
 
 		if (val > U8_MAX || val < 0)
 			return -EINVAL;
@@ -603,8 +595,7 @@ static long i8k_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		break;
 
 	case I8K_GET_FAN:
-		if (copy_from_user(&val, argp, sizeof(int)))
-			return -EFAULT;
+		val = *argp;
 
 		if (val > U8_MAX || val < 0)
 			return -EINVAL;
@@ -616,14 +607,11 @@ static long i8k_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		if (restricted && !capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
-		if (copy_from_user(&val, argp, sizeof(int)))
-			return -EFAULT;
-
+		val = argp[0];
 		if (val > U8_MAX || val < 0)
 			return -EINVAL;
 
-		if (copy_from_user(&speed, argp + 1, sizeof(int)))
-			return -EFAULT;
+		speed = argp[1];
 
 		speed = clamp_val(speed, 0, data->i8k_fan_max);
 
@@ -643,12 +631,22 @@ static long i8k_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 	if (val < 0)
 		return val;
 
-	if (copy_to_user(argp, &val, sizeof(int)))
-		return -EFAULT;
-
+	*argp = val;
 	return 0;
 }
 
+/* The command numbers don't encode what is copied, see <uapi/linux/i8k.h>. */
+static const struct proc_ioctl_arg i8k_ioctl_args[] = {
+	PROC_IOCTL_ARG(I8K_BIOS_VERSION, 0, sizeof(int)),
+	PROC_IOCTL_ARG(I8K_MACHINE_ID, 0, sizeof_field(struct dell_smm_data, bios_machineid)),
+	PROC_IOCTL_ARG(I8K_FN_STATUS, 0, sizeof(int)),
+	PROC_IOCTL_ARG(I8K_POWER_STATUS, 0, sizeof(int)),
+	PROC_IOCTL_ARG(I8K_GET_TEMP, 0, sizeof(int)),
+	PROC_IOCTL_ARG(I8K_GET_SPEED, sizeof(int), sizeof(int)),
+	PROC_IOCTL_ARG(I8K_GET_FAN, sizeof(int), sizeof(int)),
+	PROC_IOCTL_ARG(I8K_SET_FAN, 2 * sizeof(int), sizeof(int)),
+};
+
 /*
  * Print the information for /proc/i8k.
  */
@@ -696,7 +694,9 @@ static int i8k_proc_show(struct seq_file *seq, void *offset)
 
 static const struct proc_ops i8k_proc_ops = {
 	.proc_show	= i8k_proc_show,
-	.proc_ioctl	= i8k_ioctl,
+	.proc_ioctl_buf	= i8k_ioctl,
+	.proc_ioctl_args = i8k_ioctl_args,
+	.proc_nr_ioctl_args = ARRAY_SIZE(i8k_ioctl_args),
 };
 
 static void i8k_exit_procfs(void *param)

-- 
2.53.0


