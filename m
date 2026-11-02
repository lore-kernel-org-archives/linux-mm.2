Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFBCD60722B5
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DXh2wTXC
Received: by kanga.kvack.org (Postfix)
	id 1BF006B05CF; Mon,  2 Nov 2026 10:06:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 197426B05D0; Mon,  2 Nov 2026 10:06:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0589A6B05D1; Mon,  2 Nov 2026 10:06:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC4D66B05CF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:06:21 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 54FF38017C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:06:20 +0000 (UTC)
X-FDA: 85390504920.25.6C49307
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A1CDE180007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:06:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DXh2wTXC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLir7M9bUqyYwhZJ8zktlBEIF8q4TgFqxNnhzWbUGpI=;
	b=zt0BBcqbuBM8KBCiREcQw+E63UKNxyrelOpZT7Zkis74rE8WE9OSIGWnSwZ6ecABbhLvEA
	LRpSZX6fx/vE+DZ1RMBZN8wvHBS8LLEWnSP/u4XUW4FNRJYq5t4VmqExJw+NQQzkMXDQi3
	uPELSOh+DE7lwl9iDorTOQa2E8ZVd3s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DXh2wTXC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631978;
	b=TvAcJ8tU8AZw63L0hs6i/LybKlGdhNZjY7HUaFm1sdbZieoFs1IaJJj2mYsfThIjZSZ9wy
	Bt0v/IGiC5bDXlqBtDF7If44Fezl9Nvs3PoeliEspsUfklcO24bKX8hXmgbTqqXC/zSHU0
	Dt7UH7shuocnaMHiv/xYiAeu2Q3ylK0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C7FD6091C;
	Mon,  2 Nov 2026 15:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D671F00A18;
	Mon,  2 Nov 2026 15:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631977;
	bh=OLir7M9bUqyYwhZJ8zktlBEIF8q4TgFqxNnhzWbUGpI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DXh2wTXC5VH77hnNnBlykaDhaUktPNfk5KXDpgV/7gXuYGd3odp2PAnlkIjkJcfwQ
	 o9sxUl0dG/poWSGN79w2hy79MhM+2ztMpCOszGkOriShPgsszxRZ3ZRol64cXOqv2A
	 8eMmQU21JeKaxaR8/PkbA3dv0fEzY8Yy9ptwbGLqD9ZhBkx9YpAOAdrNHRRRoTVx07
	 W+r1ujTQggO56FKWxnPRth4ymfmLY/JbPNj9rdkw26qWgcW6WoX2cQIQ4o12qUFDB+
	 qh+O9CiaFL8rKOi7/exZPrc7xKe5i7H2dzyzLS2B7MYRkTDDfrAkgu/6EfP23mzFom
	 VD4IVD7SeTZBQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:41 +0100
Subject: [PATCH RFC 14/22] x86/mtrr: let procfs copy the ioctl arguments of
 /proc/mtrr
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-14-c9492ab08480@kernel.org>
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
X-Rspamd-Queue-Id: A1CDE180007
X-Stat-Signature: fznwdj1rmmi1bg1fm5z4754hh3z6uixd
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793631978-807705
X-HE-Meta: U2FsdGVkX18jrN9GqVDGFl6BScjTnsf+i3dyWvH0Dr9EnXpoBhffgS+nmcMCWXlR1AfBqsyHsIa5W17RErDAC3mD1HoDZUhoS4E+hfsXbtB6Io8Fo1Z++DU1rB6fdU/uBbMYTavJBvo6FtzSy8e095ypHg7qvJMsKx52Hd4tzGoNP2tMlY+nElAQ1XEAaPoITgHOIWRHVTSducFRBBALwD9Fgw79pIOhIYMU0m+RiYMtoKHNcRssQVokAYosyVqbWyW55JA2U6wG4hPs2ZEkrfaAJikXo5wumHYqptrb9uDeITSBW8aq5W36sDNgqLaE8oCJOvjyEcELUMZfa5RmNQs6QFsrUY4uCmIWQuf++mALEerDpPf3sBG54hLaHg4nmda/E0hXW2phyn37S0v99L6fQnAgDl6ySClqOjZ8Fam2nPN4QD7CGMQcHFpo2G1sFFWsMkiKM9UJbJwTHpFh8kAXnKZnKAXY74cN+z6ocNs6+9SWL44ocmUbkdJTyqCqC7YOaPbzcJbYFTeistu+mHrJSOhVJKEUNXbsUr++1c7kaiWitMx0jGwExHWdmqrRbON0GwnuSkFt0g3IjUep3plEjK+f4fhvddURi86XH6PDNJNwaPlS3iiUzIt0O9qjwlk+yhC9mSH9XbgyrRUZ9zF1jEQBQnG5qGbZHEkAZb2b/0wTjMTV1witu6SYSUr3tKRMnTn8MD9Z7FHckMiHOpS5QnEWXmUGtHPawctbMzH0t1aS98xx4yzfqZmihuTZHB7dOzmD2VMZgD1+1//4siLV6rVcLyuUiMsN/oVAbLgmC/zqNMXWhgaiNVbyU5UROUa5gZIc1UbEz83Q3Y8BvwvAj+rYEJ4PqDG0DRYj0jexqT8PlZmrZLPDh27exy8Ydo47qf6ECD6pt/s38q9hqToB5k/iUUqvlu1EwFwKFgUTFzxfkVOAsCpwQx7STSbx0uUV2PfnX6Fd3zPfMYO
 kMs170ZP
 /zOTyJyIk4pJaWDfADXABrZ1IEMBQKluNhqPPowuaVnh5ccu8EyjF4aSnSqubRdqMRJpjxPoH1NnoSfR2pH6Pvg+coRpVECmPtkHuQbkkJBFzFnftXJ3AmqtMHn/2LGW0ZAMJ0F9mtf8xI9zUqpIhFr5jTFLG4rHN0bZda4sUwqnQQD2Gcycs/sqX8axMzCwdUtDQJj7lvGenNinC7z0C7fzF/rhkzkCz5ScFVwLcBGeYdnPc4DkuGScgidrjARHol8EFezxUxTdZjVP8/2lCOupY1g==
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


