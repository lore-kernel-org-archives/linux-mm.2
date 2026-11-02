Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D5F60716F4
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qg2kQwEJ
Received: by kanga.kvack.org (Postfix)
	id C4AA56B060B; Mon,  2 Nov 2026 10:28:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C22CF6B060D; Mon,  2 Nov 2026 10:28:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B11436B060E; Mon,  2 Nov 2026 10:28:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D4596B060B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:28:44 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24B0914014A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:28:44 +0000 (UTC)
X-FDA: 85390561368.23.B521F14
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 571A140002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:28:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qg2kQwEJ;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633322;
	b=AVdgi/VgxrE+AR6vMBfcPAogGFL6hvd5RLfyPwU9EHhgMLn6RCbtwqWxG7PQ9zQ2enCXyl
	oqD/IuWyD6svuQgLK98XRz5HgDdxqLdDq0DcIaw0CaW11lTSDpkkbnSJ4Hq76vTNELxVjS
	yjUNfEsp8XP170bwErx8vmhTf8Qwsag=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qg2kQwEJ;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=toX2CmHD2NzUUtPxn+B9S++PSadbiUkEaQUUA5VZdL0=;
	b=BH1wTlK9VOoZsa00kzfJpGHhdYGDwn8N3QlfnUxRHwhPFe0of8husXbvACBg0g1cHUmtZ0
	9xLFTDgFsYq9+y9BGiaekubHWhVgF5m7JkKg4Z1EBxHY7KNmyA7AOpiHqbwDttpLLpoqrQ
	0h5IZZs/PmQE2L2Ti8eus2tF8B5qtT0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C5D5560A52;
	Mon,  2 Nov 2026 15:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD6D1F00A16;
	Mon,  2 Nov 2026 15:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633321;
	bh=toX2CmHD2NzUUtPxn+B9S++PSadbiUkEaQUUA5VZdL0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Qg2kQwEJzBBud2YUJ5gCy+8AwyrbfP0wjUoQmOVfGfnhhid1zR1YXGmw9lG63Cq5H
	 PnFT4z0kjd/vnLavLzmjV+cc1mZrSe7esUryOwNy8DlGgP0iR20nKduRu/kIzHHsrQ
	 gjv4+UrQipmVe0//KR6hmG2uBXfpQI7HpEbsZeXm0dGsbxjJywIm3X1O6YZKcRgI8R
	 fyDrbQhVDukMWPxLMGTE6xRuHe8cYGAyiRM5fIGe9b1AtfTA3oMoQ+m+woQvg5dZTm
	 aWP+sNADJwOPXcf78LIFpFrYKl//E/ARw2Rvrj2196gNLVEEXBWWB+0PsauKpZ5TfT
	 cXvrUnM7DQOgA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:34 +0100
Subject: [PATCH RFC 24/27] alloc_tag: let procfs copy the ioctl arguments
 of /proc/allocinfo
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-24-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
In-Reply-To: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5002; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Df+mpuPO24WuA65Z3R+CqgWoIsjjCuc3kLgbPQbmkBc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG7M+GnFOi/L79sZ/3nKHOl8OmlN0p/Mgq2y3fUHM
 zOWcK5f3VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAnCT+RgZjmkkrJpwrImlTOP+
 7JSdp5pyDvu1zYz6ujT/tMhRJ7dTsYwMu1c1SXtoHp9uOvfWFiYRtj/J6WeC+vuWLjBUsk9nYHL
 iBgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 8gwoqx3f3dd38d9o1e8baqqfdduttb5x
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 571A140002
X-Rspam-User: 
X-HE-Tag: 1793633322-291047
X-HE-Meta: U2FsdGVkX18R1F5eVBaxlsXqDiftPMX/aW7+O21nWbSEvR+4OZqI7EDihZv7003G2RvR6ilbHWnLOxewDW/YI1ft0Af09Z+GfjU2SYm6vMSe630bfibUweyfAON45taSIoXfnIFzKPHg8d3qTB7jZxRVt7k0wS+TmCAdzsnHQrIJk93byCASaWLU710Z/DTGRFiuDWsMumEInJxSuwozTC5utw6/zwJXSjEI1kNIZ7feLg4IEz6sf+tZuJqTpEJ2dUjnH/oZreqfVFLtP0ARxhGThcARLeBEBjc2HMFGvVUJb2I9BMi/vmjMNcmnJY6evS3864nRi5vPABx1l0snVYGaYwM7qFrubJu81uMi/qfSqFSVIdjFa1cM185ocBOiiZxjyH8JBfNx4Bx19dccNdE6cDHsaq95w8btCZne2mTANxybVn9jHrOQsFLvds4lZv6HQxACIkPhhNQQId3soiEmgB23OY7fyBKusI3lYVbtbWXG9RlH5oB2WmrVcv0s5llJQx+n1ot5feR1C4+i1tng0qEgxqjY1Mbkku7fP4t0DvsYYVung4FAGkiTci0TWG/iRqHYyUS0qY75SyXZCq2ZI2CFBqTViWKcq0hOSuxbVqumBCdi621k72XCJFIUSONmaby3kHAdiLFgoo4PW4t8k8jJdDVVbGfpYXUK94dppBw7RzbSpp4gZocbJybXaZgVp5/ApVwdQrQ7ghBjhZZXkBAKcYMLYqVAXN30o5xlYLWNUxgJJvf2S+VN61dtYYeNlih2sYP8Q2asuVZCqhyNGodLeIVzEVPqhx9aFDrZqWlRnwHEEEHwuWPkxL3wOAuPpYe2tJnTBEID4mi6Aufl4A8nY4BtIZ7/ycdoczOuUQg3+1/yobZ6+7Fg6fNxlq7TZ6YtBzHc1GGgTqYmhrgnEJnuJx6mhS2AK5+XnoYTvYShJ+gT1HseIPVgZCDI+oa3IPsuI01Tc9kG0rn
 325ZvLco
 W2ma2q11Bdts28Ee8iTXFBdWr2Dx3EJlVGwmtYoNkJWHAKNJDo0bzgRFLF1gNagCbj77DUVHj209lTFO0PbHjG8WHgznDzCXtUaFPhKGWrvEUCc/qiJ1qJora7FIhFtRFCnQr0nNzdr7rcC9DsAFlAn/6VBFRmCNoOJIkpsWrm6ouYzoUvgdbezNFDKoPNiUDLmU3HZxDxqg3T92gGAP203kJ0bhrz6qq2Bos467cx9Okk7LwBj16muArQfuEXl0XvRBla91fNjcHDuqwdkJkkMCxAs1GZxo1eUMmozZ2Q4IfDIQAUvWLFszPnCZPpHX0IU9GJNnaLl2xu1B5oqmhd8bOm8BdaVkef32gdmDmGYpNvK10QdAhbdwxzG0loFvodve0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_ioctl_buf() so procfs copies the arguments in before
it pins the entry and back out after unpinning it. The commands encode
their arguments. procfs converts the pointers of 32-bit tasks, so
allocinfo_compat_ioctl() goes away.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 mm/alloc_tag.c | 47 +++++++++++++++++------------------------------
 1 file changed, 17 insertions(+), 30 deletions(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 788c9d7f7151..1734705e2990 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -6,7 +6,6 @@
 #include <linux/kallsyms.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/compat.h>
 #include <linux/page_ext.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/proc_fs.h>
@@ -235,16 +234,14 @@ static void allocinfo_to_params(struct codetag *ct,
  * Retrieves the unique content ID representing the current allocation tag module
  * layout, allowing userspace to detect if modules were loaded / unloaded.
  */
-static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
+static int allocinfo_ioctl_get_content_id(struct seq_file *m, void *arg)
 {
 	struct allocinfo_content_id params;
 
 	codetag_lock_module_list(alloc_tag_cttype);
 	params.id = codetag_get_content_id(alloc_tag_cttype);
 	codetag_unlock_module_list(alloc_tag_cttype);
-	if (copy_to_user(arg, &params, sizeof(params)))
-		return -EFAULT;
-
+	memcpy(arg, &params, sizeof(params));
 	return 0;
 }
 
@@ -309,7 +306,7 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
  * Seeks the ioctl iterator to the specified 0-indexed tag position, reads its
  * profiling data and returns it to userspace.
  */
-static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
+static int allocinfo_ioctl_get_at(struct seq_file *m, void *arg)
 {
 	struct allocinfo_private *priv;
 	struct codetag *ct;
@@ -318,8 +315,7 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	struct alloc_tag_counters counters;
 	bool fetched_counters;
 
-	if (copy_from_user(&params, arg, sizeof(params)))
-		return -EFAULT;
+	memcpy(&params, arg, sizeof(params));
 
 	if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
 		return -EINVAL;
@@ -374,9 +370,7 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	if (!ct)
 		return -ENOENT;
 
-	if (copy_to_user(arg, &params, sizeof(params)))
-		return -EFAULT;
-
+	memcpy(arg, &params, sizeof(params));
 	return 0;
 }
 
@@ -384,7 +378,7 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
  * Advances the ioctl iterator to the next allocation tag in the sequence and
  * returns its profiling data to userspace.
  */
-static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
+static int allocinfo_ioctl_get_next(struct seq_file *m, void *arg)
 {
 	struct allocinfo_private *priv;
 	struct codetag *ct;
@@ -424,10 +418,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
 	codetag_unlock_module_list(alloc_tag_cttype);
 	mutex_unlock(&priv->ioctl_lock);
 
-	if (ret == 0) {
-		if (copy_to_user(arg, &params, sizeof(params)))
-			return -EFAULT;
-	}
+	if (ret == 0)
+		memcpy(arg, &params, sizeof(params));
 	return ret;
 }
 
@@ -435,10 +427,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
  * Entry point ioctl function for /proc/allocinfo routing requests to fetch the
  * layout content ID, seek to a specific tag, or read sequential tags.
  */
-static long allocinfo_ioctl(struct file *file, unsigned int cmd,
-			    unsigned long __arg)
+static long allocinfo_ioctl(struct file *file, unsigned int cmd, void *arg)
 {
-	void __user *arg = (void __user *)__arg;
 	int ret;
 
 	switch (cmd) {
@@ -459,23 +449,20 @@ static long allocinfo_ioctl(struct file *file, unsigned int cmd,
 	return ret;
 }
 
-#ifdef CONFIG_COMPAT
-static long allocinfo_compat_ioctl(struct file *file, unsigned int cmd,
-				   unsigned long arg)
-{
-	return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
-}
-#endif
+static const struct proc_ioctl_arg allocinfo_ioctl_args[] = {
+	PROC_IOCTL_IOC(ALLOCINFO_IOC_CONTENT_ID),
+	PROC_IOCTL_IOC(ALLOCINFO_IOC_GET_AT),
+	PROC_IOCTL_IOC(ALLOCINFO_IOC_GET_NEXT),
+};
 
 static const struct proc_ops allocinfo_proc_ops = {
 	.proc_seq_ops		= &allocinfo_seq_op,
 	.proc_state_size	= sizeof(struct allocinfo_private),
 	.proc_open		= allocinfo_open,
 	.proc_release		= allocinfo_release,
-	.proc_ioctl		= allocinfo_ioctl,
-#ifdef CONFIG_COMPAT
-	.proc_compat_ioctl	= allocinfo_compat_ioctl,
-#endif
+	.proc_ioctl_buf		= allocinfo_ioctl,
+	.proc_ioctl_args	= allocinfo_ioctl_args,
+	.proc_nr_ioctl_args	= ARRAY_SIZE(allocinfo_ioctl_args),
 };
 
 size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep)

-- 
2.53.0


