Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A725C60BB5A8
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NJqxLTIM
Received: by kanga.kvack.org (Postfix)
	id BD2E06B05C6; Wed,  4 Nov 2026 16:16:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAAB46B05C7; Wed,  4 Nov 2026 16:16:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9DC86B05C8; Wed,  4 Nov 2026 16:16:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89C616B05C6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:16:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1CE268086D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:16:04 +0000 (UTC)
X-FDA: 85398694248.05.D77BD37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4E3A91A000E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:16:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NJqxLTIM;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793826962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYDbJcSF6MsxMTYnsYlWsg5fOwbFhsLezcPYxvIMO7Q=;
	b=mlNAPfrIhY+5YoLbu4i8sj2M6vpnL13oxfE+A2whAXxYa56slcxwzC+hkveX9fFr1ctTPv
	yaWGfSuE5WC7PW2JOuLZ/EcFpJZJgLkz+eEvbO1KbHnmWLydJROzOzJhKqbuHJ2Ujjd84x
	thlsD32rS3VwZCNMD3ZlOaxQafuYio8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793826962;
	b=6HH43a/IlW1p1WkdwDMjepMcaqOnJ/25XZRKtFih6CrPDQv05+4WHkm9CW3ucDpGfTjX+C
	u1kE2eUAordChk0eFBq6F/FFp8l43nWAcG1iytyoTUAvgsifkcp8tK6V622ZZKPgVtC+hY
	gnd26A1uCymEQ040US+JQgiDHWRupUY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NJqxLTIM;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9AA3043C19;
	Wed,  4 Nov 2026 21:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8011F00A02;
	Wed,  4 Nov 2026 21:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793826961;
	bh=cYDbJcSF6MsxMTYnsYlWsg5fOwbFhsLezcPYxvIMO7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJqxLTIMyD+z+OGEGPKdNb5DVJxeR+ZPL5Hcq0qLrVgti4NdCfPFcWN5oUkoe2r24
	 hntfK6cgVi/rSYBO0Vazr2E3tI24dW6AI+U7mB0ifoQfnKDA49wXp+nR253l3y375P
	 wRumH3HzpRYvKA4sFylxrcLZdiNyh0VDgySBpfdUmQJQ/VqyOsczmMJ2TRKByc5yGh
	 GWcMxajP7bHhTdPaZGg2JmWINVCr1wyP0683KcIJteDz3PQliV6Sj1hoLQ7P6nL/P/
	 cRVmuMwa9WdES/V3C4Gr9BvODn9V/9W1+LLNyOEIXtRMer0IaVW/ukmhiV9vxIusLC
	 Jt+17gTxG4kvw==
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
Subject: [PATCH RESEND v2 2/6] proc: drop ->proc_ioctl() and ->proc_compat_ioctl()
Date: Wed,  4 Nov 2026 22:15:47 +0100
Message-ID: <20261104-work-procfs-cleanup-v2-2-1e6687e226b1@kernel.org>
In-Reply-To: <20261104-work-procfs-cleanup-v2-0-1e6687e226b1@kernel.org>
References: <20261104-work-procfs-cleanup-v2-0-1e6687e226b1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3710; i=brauner@kernel.org; h=from:subject:message-id; bh=TJmOpj0pffvqgfu3ibe3PI3xVK1s2JegNCopUc+R49E=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9XhAfyCV0buqRnk1zX1d6OZ2eMalH8eJipr0uMWG5P A23N5kIdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyESYzhDyevW1XFrfUf/qk0 7NeebL/7t/RqlyWCZU4H5euv2ca3zWRk2N39s2b6VCe3ycEuHT+SW44aVxkHnG07/u8yY8AaN5Y uXgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: o13h6rju15i9dnc1ozu5fpdbcrxw1nc6
X-Rspamd-Queue-Id: 4E3A91A000E
X-Rspam-User: 
X-HE-Tag: 1793826962-711082
X-HE-Meta: U2FsdGVkX18yKYrKdzLy9cOn1+L+ukMI+vxcwWlls+D4uvZuPgasIccLTF8HGxehNH1eK8btwTU89H0NT/zM5C8LBRdl4HA17ZqLRbct7pFdVza/eg5Z2YbL6/jXSTc1sxw8cLAubxr5UaDK+mHtxARNune/Vf9LkzCx/gnbkcKvSnCte/ZzqRf6IQ7y2JXJU4ht8BCLf8ftyjwCk5kowckhmQGQ6Tm1PSHctWnfg6FJYJ0WmpbWh+m8suf1mbjWtLBPssRd9Is1MoYK7Z5Y/hy1ZmeJnAaRZMHTrf8ofywFC4O8KlUJNGjOAm4w/wM6UOSV6hvoolhDsRFSLsUzoomGwqoknU2E1seWV0eZnY79s9B54/UdkYCVUhBNkhZu+IGkLoPq2ZIzpQ9FmgsD1udg2F41d2oeKPsX5Oz9VnphplBOoJYC/MY7LWLr7kwFnl9daXhuMALEomun1xVueSusOkDiov70zMLgfZZ1saG/OJrClpG6hk0lKz0VzQpIIzoT0D7WBBcMeVo0BwVcMOya04pzvHaTuicVnC+ZO/d/o5M0uFgTQIVK+iGZo3dlfGlsIMs+HeZAeTpDwKNomQNLbE+0gWS7huZvQpu8TTyqcTwf0WyBtsMdMIy6slkVpqEAKg5BgZ9oRuyKEC4Zn2eGcX+jZMcvRjF6mD3bBrQE13WAYPjhqpGtJxfiN0uSS8KFAjJ5LHE0rJ4pbTqHZJJfvMf/yDCAWAQS89kx9TBnsKI+5PgFotvuPVc0ewQ4WOwSIzocOoJ299xKbICMnwnjVUGB2XEb7Avyx6U1feWm654t2Ma01UBZi8zmnsIP+Ikq3NHZrk7hq4t7vvFLU0ejLvQjeaP69Zp9ZVInnNwM/jN10/HTfasp91+Y3C+2M+YnPhdafVVA1ZdpdkPXuLehu2zhmFpVkqRh9r63dUG5EUN38tWJ5M9FmBm78oWaciKL2FxABbqv1Wl/67/
 J+E3tdTr
 Jxy5nH0DhdQfiSEH5/SLb115+7S3XMQaMqvAlsyTUOswAZimjVKYYLEvhK2Qf/b7ayK3CX1qWCsyKPfyjDDlSF6AEFQzZbMk7mNnX8CZHWjFxNjheBdfZC9aNirwsogyuFY/WDJvDtGp7gfzNYUpbRz/SgSfpMSPAU1TR7VoB5SMbiA7qTNTdphxXTElfwLDlaMqPRsE5Gdt4kHaeGLjbp/dxbN8S3k267mVUYtXcCjg8cqtgi3nnjsASGXvf3PdLDdaMnQc8XeJf7BnBQRDopXgcBwcWPxiqtzJBEsyu3/BmrboCaddOV0WpsmpvKi7vFnSCBqcUKyvvJTs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every entry with ioctls implements ->proc_ioctl_buf() now and procfs
copies the arguments in and out around pinning the entry, for 32-bit
tasks too. Remove ->proc_ioctl() and ->proc_compat_ioctl().

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c       |  7 -------
 fs/proc/inode.c         | 30 ++----------------------------
 include/linux/proc_fs.h |  4 ----
 3 files changed, 2 insertions(+), 39 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index e3ae11805c0f..b0027400ed23 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -488,13 +488,6 @@ static int pde_set_flags(struct proc_dir_entry *pde)
 			pde->flags |= PROC_ENTRY_FULL_READS;
 	}
 	if (proc_ops->proc_ioctl_buf) {
-		if (WARN_ON_ONCE(proc_ops->proc_ioctl))
-			return -EINVAL;
-#ifdef CONFIG_COMPAT
-		/* 32-bit tasks go through the table as well */
-		if (WARN_ON_ONCE(proc_ops->proc_compat_ioctl))
-			return -EINVAL;
-#endif
 		/* the table says what procfs copies, see pde_ioctl_arg() */
 		if (WARN_ON_ONCE(!proc_ops->proc_ioctl_args ||
 				 !proc_ops->proc_nr_ioctl_args))
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index a7ebbe334afa..75561e3f3355 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -588,14 +588,6 @@ void proc_poll_notify(struct proc_dir_entry *pde)
 }
 EXPORT_SYMBOL_GPL(proc_poll_notify);
 
-static long pde_ioctl(struct proc_dir_entry *pde, struct file *file, unsigned int cmd, unsigned long arg)
-{
-	const auto ioctl = pde->proc_ops->proc_ioctl;
-	if (ioctl)
-		return ioctl(file, cmd, arg);
-	return -ENOTTY;
-}
-
 /* the table lives in proc_ops, which goes away with the entry */
 static bool pde_ioctl_arg(struct proc_dir_entry *pde, unsigned int cmd,
 			  struct proc_ioctl_arg *arg)
@@ -652,38 +644,20 @@ static long pde_ioctl_buf(struct proc_dir_entry *pde, struct file *file,
 static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
-	long rv;
 
 	if (pde_has_proc_ioctl_buf(pde))
 		return pde_ioctl_buf(pde, file, cmd, (void __user *)arg, arg);
-	if (!pde_pin(pde))
-		return -ENOTTY;
-	rv = pde_ioctl(pde, file, cmd, arg);
-	pde_unpin(pde);
-	return rv;
-}
-
-#ifdef CONFIG_COMPAT
-static long pde_compat_ioctl(struct proc_dir_entry *pde, struct file *file, unsigned int cmd, unsigned long arg)
-{
-	const auto compat_ioctl = pde->proc_ops->proc_compat_ioctl;
-	if (compat_ioctl)
-		return compat_ioctl(file, cmd, arg);
 	return -ENOTTY;
 }
 
+#ifdef CONFIG_COMPAT
 static long proc_reg_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
-	long rv;
 
 	if (pde_has_proc_ioctl_buf(pde))
 		return pde_ioctl_buf(pde, file, cmd, compat_ptr(arg), arg);
-	if (!pde_pin(pde))
-		return -ENOTTY;
-	rv = pde_compat_ioctl(pde, file, cmd, arg);
-	pde_unpin(pde);
-	return rv;
+	return -ENOTTY;
 }
 #else
 #define proc_reg_compat_ioctl NULL
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 8c406f4d09a5..f1ac112aa0fc 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -90,10 +90,6 @@ struct proc_ops {
 	 * entry reports EPOLLERR | EPOLLPRI.
 	 */
 	__poll_t (*proc_poll)(struct file *, struct poll_table_struct *);
-	long	(*proc_ioctl)(struct file *, unsigned int, unsigned long);
-#ifdef CONFIG_COMPAT
-	long	(*proc_compat_ioctl)(struct file *, unsigned int, unsigned long);
-#endif
 	/*
 	 * procfs pins the entry around ->proc_mmap() and wraps the
 	 * vm_operations of the mapping so that ->open(), ->fault(),

-- 
2.53.0


