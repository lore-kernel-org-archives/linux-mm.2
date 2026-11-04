Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B61D6071A07
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BGoQWKYK
Received: by kanga.kvack.org (Postfix)
	id B41216B05DD; Wed,  4 Nov 2026 14:40:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF2D26B05E3; Wed,  4 Nov 2026 14:40:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B8826B05E4; Wed,  4 Nov 2026 14:40:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 707776B05DD
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:40:02 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44760A83FA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:39:36 +0000 (UTC)
X-FDA: 85398451152.15.2749AA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7E08D120006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:39:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BGoQWKYK;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLir7M9bUqyYwhZJ8zktlBEIF8q4TgFqxNnhzWbUGpI=;
	b=3VNjRxC/KcRtqvy5s/S2/cbQJXeahIqmIuyACVvnAZXsH89nLEuz3XY7cTsZIoFIKrRtT2
	H87cdS77xORhz4rl6AHWOs00YDv5cBAgtKNSJIGYnqnF37jfJ38qS/5VgDAcAWt3wG7pBl
	dvmba63KfOeQypFY3/QcnU3tB31eEVg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BGoQWKYK;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821174;
	b=2/08OAoC8H7TwA7VzWqitsqaO4NHxgkZGdqp6YAvUHIipZJFyjKY/taknBc6+tInxCtihn
	Uue7V+kGeKG2guDN0H5VmSy4OFZhFn8IxKcAzvQ4HXNsBPHr+V0E3aAFB/Zc6/iMlf5nsm
	EtGk57batwbx5Ti+zIHvUxS+NiUPnBg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 169BF60F16;
	Wed,  4 Nov 2026 19:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1E51F000C1;
	Wed,  4 Nov 2026 19:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821173;
	bh=OLir7M9bUqyYwhZJ8zktlBEIF8q4TgFqxNnhzWbUGpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGoQWKYKlGRHqH707lt8XPTrvhILrDN2CTBKW6sy4z5pHja4DdtN3raBG+NHLj92g
	 lT3j0AXWk+7UPpWWF1UqKr0teEMq0y/evuKx3wT6DI1igbFRETKr9nHjbLI1nR+NjU
	 nEQrgLu5V7p8Qbs7lNxg7pYdY0OS3AJ/InKacvNpa8Yy6bqqt2ucHdsOEUVuRjnglA
	 2neUJAv7gx7ca66gWQEIWKVKaKhIVOkX6ditAtUOyn0NGQtQzqUmcl3a3hd5YUr0He
	 y/DG+4nLiOv9JHOQGcWwzY6YiJ6Wsg6U5djleaHL/yx5FfWJcZpIQT5B9uaN3JkFIL
	 szVI5opji+ZoQ==
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
Subject: [PATCH RESEND v2 15/23] x86/mtrr: let procfs copy the ioctl arguments of /proc/mtrr
Date: Wed,  4 Nov 2026 20:39:19 +0100
Message-ID: <20261104-work-procfs-arch-v2-15-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5220; i=brauner@kernel.org; h=from:subject:message-id; bh=t9lK4yPSWnjPiNqpcmr+36rhqvijTQ7A+lZHV62u0/o=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97vj/uHT//LsHnab9aFnoUuZU1fZb4kuq29bvwVZqM xnei7cs7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIbxlGhonnGEILvndsKS85 4PR6CvPGms8/XAXntzvM/P7oi4Bb8TJGhpu+z1R/eV2YMPmXmkv3oae5PxjPCl3dUPM/5vMn56O LV3IAAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i8gwd1wih156okamidpbf6rwz4om7dkc
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 7E08D120006
X-HE-Tag: 1793821174-996586
X-HE-Meta: U2FsdGVkX19bGaTPPOkFu4YBqhSgheeGxsb3FsLreyGEQVlgijF5IXcNciptc3sgNwc7hUhVkrjsCk8wS797Sw1/BQLpZCWYC/e/e4kSrwbrCJEPuQuN+bMJNf+Fh9R4rlGgghc0/VWwZOy7hUojGxEdi5RXtsAnQ97fUrPgwbcjszyk1862fpqpMy5VhSWjux4ap4OCvOF2NIiVpWLkzZmKiFvfXMSCwP+BtBwt7sOv6ITkoKjFyqwG7JHL2n+XJQWhLxBXcenJcB5sc6OVEgn8bQ+Z2ZfYbhOgVZwDmrtqaQXrGSUFrUU/xV0ipOEUy2z/HMVRk2c0tZBMhtBXfpAzKb42A9PuUBgMiZF1F3Cbrev6v6mRmCrwHDJqj9+jbiTW4uFG5hsNsL4YMRVnDchlGRHH/cOlpDK0LL2EEItxnFZH9xmp2BjfEAJxknCc6OgU+8NOVcIKOJtVi4KSsB+o2BBBk4TZ038RSn07iB7Wj3BwV4gOw0mxG1emB96S4m390Bn8pX/jPmvOlG+IV1rlgvMvyEKTs2o7Z4Q7XWUI9BOpgodFI1Fve8/dGbvDtLU45vbY1f0AzRAQ41uCcitpvIRnGGVLI3aZcW2OyoSEAjLirwNk7JKoLjZ9XjWG6T3Xhhmvs4nKqCoBY7TBtZCT/Xyrhs78z8/f4mWAYp9F22cEf+5Qor3jjnxk/0yfBZjHMPCBRMJ18XxrtY8ft9p26QTAM3YwVtC9H5V9mfvp99zdcR5wa8ujneJpXT82kvkGfQyI0ozOWpC2QulUk04RB+wltLRM4WHGXUWVR+adOfmsib/+HDh6GfIdY1E+8Yl6AFITRvwwjhtfgO+tbTyB6J6THlyT1QFFtfXMM9wmZ6RVHhNy2oYcqWePFKaKOFpq2DDK1gdcp+QcqboMVD3XGVzL0R3tglbcZqlEslfzPcezZKc1CPEy8EtKZhunG687IPgwViOZGmH6fj4
 Zncjmb6d
 5kZkj5+iuLC5Uvj1bD/CijYlT5JNNkVhsGhnQGSVwj4PjqqPBHWZocnOM0VeG8BgHAdcIKpXCLJRP/rUpn9FcnaDtezzP975wHSDPDyEOm8I1YSt8e6eg+ibNsAur65chb99k/+HF9QArmLkiFVMPskaB7j7sWhmSjkR5ZjtGFGSnszyVzxBYg44MX33v1zv6NLq6MmKn1ATt2h9Xik2PW6MBbu1vNLy9QtQhMLQ0pNXQ/K6iUUFBUK6WmcrbxQXPGMPhkNZPdpyM9xAsDzLgSaHtvCw5B63wN9xj9U+S4+A0YqW7vY+0n975YZtHJtDWsNeweP2ZFcr2eVEG8TOifNR4HmHeWfcG+iU1lRf9op7VGcqD/jd4Uu765fMTyM/dIqtEeFcvDv09gEQ9bT54n22a9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_ioctl_buf() so procfs copies the arguments in before
it pins the entry and back out after unpinning it. The native and the
32-bit commands encode their arguments and share one table.
mtrr_ioctl() reads and fills procfs' copy, also in the 32-bit layouts.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/x86/kernel/cpu/mtrr/if.c | 79 +++++++++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index 038e2dc38797..9c33c0428dfe 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -149,7 +149,7 @@ mtrr_write(struct file *file, char *buf, size_t len, loff_t * ppos)
 }
 
 static long
-mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
+mtrr_ioctl(struct file *file, unsigned int cmd, void *arg)
 {
 	int err = 0;
 	mtrr_type type;
@@ -157,7 +157,6 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 	unsigned long size;
 	struct mtrr_sentry sentry;
 	struct mtrr_gentry gentry;
-	void __user *arg = (void __user *) __arg;
 
 	memset(&gentry, 0, sizeof(gentry));
 
@@ -170,13 +169,11 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 	case MTRRIOC_SET_PAGE_ENTRY:
 	case MTRRIOC_DEL_PAGE_ENTRY:
 	case MTRRIOC_KILL_PAGE_ENTRY:
-		if (copy_from_user(&sentry, arg, sizeof(sentry)))
-			return -EFAULT;
+		memcpy(&sentry, arg, sizeof(sentry));
 		break;
 	case MTRRIOC_GET_ENTRY:
 	case MTRRIOC_GET_PAGE_ENTRY:
-		if (copy_from_user(&gentry, arg, sizeof(gentry)))
-			return -EFAULT;
+		memcpy(&gentry, arg, sizeof(gentry));
 		break;
 #ifdef CONFIG_COMPAT
 	case MTRRIOC32_ADD_ENTRY:
@@ -187,27 +184,21 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 	case MTRRIOC32_SET_PAGE_ENTRY:
 	case MTRRIOC32_DEL_PAGE_ENTRY:
 	case MTRRIOC32_KILL_PAGE_ENTRY: {
-		struct mtrr_sentry32 __user *s32;
+		struct mtrr_sentry32 *s32 = arg;
 
-		s32 = (struct mtrr_sentry32 __user *)__arg;
-		err = get_user(sentry.base, &s32->base);
-		err |= get_user(sentry.size, &s32->size);
-		err |= get_user(sentry.type, &s32->type);
-		if (err)
-			return err;
+		sentry.base = s32->base;
+		sentry.size = s32->size;
+		sentry.type = s32->type;
 		break;
 	}
 	case MTRRIOC32_GET_ENTRY:
 	case MTRRIOC32_GET_PAGE_ENTRY: {
-		struct mtrr_gentry32 __user *g32;
+		struct mtrr_gentry32 *g32 = arg;
 
-		g32 = (struct mtrr_gentry32 __user *)__arg;
-		err = get_user(gentry.regnum, &g32->regnum);
-		err |= get_user(gentry.base, &g32->base);
-		err |= get_user(gentry.size, &g32->size);
-		err |= get_user(gentry.type, &g32->type);
-		if (err)
-			return err;
+		gentry.regnum = g32->regnum;
+		gentry.base = g32->base;
+		gentry.size = g32->size;
+		gentry.type = g32->type;
 		break;
 	}
 #endif
@@ -312,19 +303,17 @@ mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
 	switch (cmd) {
 	case MTRRIOC_GET_ENTRY:
 	case MTRRIOC_GET_PAGE_ENTRY:
-		if (copy_to_user(arg, &gentry, sizeof(gentry)))
-			err = -EFAULT;
+		memcpy(arg, &gentry, sizeof(gentry));
 		break;
 #ifdef CONFIG_COMPAT
 	case MTRRIOC32_GET_ENTRY:
 	case MTRRIOC32_GET_PAGE_ENTRY: {
-		struct mtrr_gentry32 __user *g32;
+		struct mtrr_gentry32 *g32 = arg;
 
-		g32 = (struct mtrr_gentry32 __user *)__arg;
-		err = put_user(gentry.base, &g32->base);
-		err |= put_user(gentry.size, &g32->size);
-		err |= put_user(gentry.regnum, &g32->regnum);
-		err |= put_user(gentry.type, &g32->type);
+		g32->base = gentry.base;
+		g32->size = gentry.size;
+		g32->regnum = gentry.regnum;
+		g32->type = gentry.type;
 		break;
 	}
 #endif
@@ -393,14 +382,38 @@ static int mtrr_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static const struct proc_ioctl_arg mtrr_ioctl_args[] = {
+	PROC_IOCTL_IOC(MTRRIOC_ADD_ENTRY),
+	PROC_IOCTL_IOC(MTRRIOC_SET_ENTRY),
+	PROC_IOCTL_IOC(MTRRIOC_DEL_ENTRY),
+	PROC_IOCTL_IOC(MTRRIOC_GET_ENTRY),
+	PROC_IOCTL_IOC(MTRRIOC_KILL_ENTRY),
+	PROC_IOCTL_IOC(MTRRIOC_ADD_PAGE_ENTRY),
+	PROC_IOCTL_IOC(MTRRIOC_SET_PAGE_ENTRY),
+	PROC_IOCTL_IOC(MTRRIOC_DEL_PAGE_ENTRY),
+	PROC_IOCTL_IOC(MTRRIOC_GET_PAGE_ENTRY),
+	PROC_IOCTL_IOC(MTRRIOC_KILL_PAGE_ENTRY),
+#ifdef CONFIG_COMPAT
+	PROC_IOCTL_IOC(MTRRIOC32_ADD_ENTRY),
+	PROC_IOCTL_IOC(MTRRIOC32_SET_ENTRY),
+	PROC_IOCTL_IOC(MTRRIOC32_DEL_ENTRY),
+	PROC_IOCTL_IOC(MTRRIOC32_GET_ENTRY),
+	PROC_IOCTL_IOC(MTRRIOC32_KILL_ENTRY),
+	PROC_IOCTL_IOC(MTRRIOC32_ADD_PAGE_ENTRY),
+	PROC_IOCTL_IOC(MTRRIOC32_SET_PAGE_ENTRY),
+	PROC_IOCTL_IOC(MTRRIOC32_DEL_PAGE_ENTRY),
+	PROC_IOCTL_IOC(MTRRIOC32_GET_PAGE_ENTRY),
+	PROC_IOCTL_IOC(MTRRIOC32_KILL_PAGE_ENTRY),
+#endif
+};
+
 static const struct proc_ops mtrr_proc_ops = {
 	.proc_show		= mtrr_seq_show,
 	.proc_open		= mtrr_open,
 	.proc_write_buf		= mtrr_write,
-	.proc_ioctl		= mtrr_ioctl,
-#ifdef CONFIG_COMPAT
-	.proc_compat_ioctl	= mtrr_ioctl,
-#endif
+	.proc_ioctl_buf		= mtrr_ioctl,
+	.proc_ioctl_args	= mtrr_ioctl_args,
+	.proc_nr_ioctl_args	= ARRAY_SIZE(mtrr_ioctl_args),
 	.proc_release		= mtrr_close,
 };
 

-- 
2.53.0


