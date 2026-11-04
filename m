Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 325CA60B4C21
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IGC4y00A
Received: by kanga.kvack.org (Postfix)
	id 3EA656B05DC; Wed,  4 Nov 2026 14:37:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39AB26B05E0; Wed,  4 Nov 2026 14:37:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262FD6B05E1; Wed,  4 Nov 2026 14:37:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAB8E6B05DC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:37:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83A081C4240
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:37:52 +0000 (UTC)
X-FDA: 85398446784.06.A445563
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id ABBC71A0008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:37:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IGC4y00A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUeWoKePwtQbwIaIqH9pLOo2XgGktDed7c18k0485G4=;
	b=8qjndtoJwOqskB40PO3YLi09terY2lU3i7QMjiM0AlE/cU1iVcbvt9uUQlPbLps2CmNzr9
	lXAChefRkOE4vFBlWdnK3C98j6dgJauo+mkhNS9TuKwee2zE8durZNrotvzAoBNQucJesB
	zG3kPxK8hyvCeo2vj5o+i7ByCJy9BD0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821070;
	b=dLVWgcR5Jix4oT78ttX2R8ZAfsc/rupU5sP57bTXr9KBtLFncEOhiL5BMuYt61CWEx1hZ0
	7Yfg3aIB6A0ybWREsvW8hitWIAQ5zwaO+z1EyS6i3a5MxVZw2MIcdre0zSCuIhs0mibXWZ
	f6mfvacVAghZm4GGkO7RTBhciXLFr8Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IGC4y00A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C9C741875;
	Wed,  4 Nov 2026 19:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099291F00A02;
	Wed,  4 Nov 2026 19:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821069;
	bh=JUeWoKePwtQbwIaIqH9pLOo2XgGktDed7c18k0485G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IGC4y00AETc18leOOoiGNlJjI14uptUXwL1lAk39h5bFLDzozGmXP95FjcQk1ai3d
	 qHvAP6G/y59z8vruoDW5Y1VeWIGTKlWb3dS3NUkuiWuDTaM3k3qDR2DhBmAlAVa/1+
	 jkEC8ZsTOxq9kedteP9jaXc0YU1IKsX6hdj0bx6p0gNUMMcxE+pQQ/pK252kFB4GIS
	 hTq5UB6PWymKT/rN8RRkkmh+m3ZSylCXxhaihAqxEz2EOYZbBvhmLGNZuz6vL29QGa
	 VhgHDRMX/6Xwut4w4xO7r/ecc/JCMProqA/4Q644WrS17ADmUJzAwlPQ6KlQcm2EPd
	 PESuNHlL70alw==
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
Subject: [PATCH RESEND v2 08/23] powerpc/pseries: let procfs copy in writes
Date: Wed,  4 Nov 2026 20:37:35 +0100
Message-ID: <20261104-work-procfs-arch-v2-8-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5534; i=brauner@kernel.org; h=from:subject:message-id; bh=R72k2XaBDNkNWoVo7wOLN896i1gM+zYb0aj1A9vFVUU=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97vgWxbNt8wYWhvlH5RZK+OjxWGdnm7duUb1soNTor 3Rw5+3ijlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInkrmVk+MQl1Nv2KdDqueyX 08pFh+YVduR7t06b45nf4Rck/P9LDsN/n+PLK+08DBJ4p96cFfH166t5EqlFHC8yROYun/7XY7Y 9JwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3gjqnoxm7qw51bp5e5337mhc8i39zax3
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ABBC71A0008
X-HE-Tag: 1793821070-387232
X-HE-Meta: U2FsdGVkX18TVzX83sXGABn0tQBOHTaqr3fxDXLdXxinahr+S8h37ZnO6ak5fMwA54ZAW0kYKLOJfSWiYzij1CTAIKri1+F/8tXuN0oHRf3tCydzhv/gsnZOfP03cbnbF7cqlGnV1mAPQZ/KPCyrfEwlCZCbLcTLjJsOODxuHGWF708SSZUwQ+YZu3JqlWBS6MOQHh9SBkXXQAYKBAM/bPux2USu1pSMpQwgn/qcwTaAZrpazAYuzh20CmU+61oZIzdzn0WS4S2NR4/iIGRDA5Hx3rroPNUN9WjtyshoYe+y3TW1dNJf7gF/TJ/5X5f+oWM+r+FnX1MiZ7oXiXohaBeNonm/WmXNpmVAL+Lms8QYV7SaSMn2pY//0PCIim/wVzB8AvUlkVNgixa3oy7NRRPCVcgt3x9E0CEoa1l34AJH6UxNgZcZ4KzWXnpE8GQOoqH2kkB2lSq4GsQWMkClTXPRsrUI55g0X9UhL1LBwap34x37UQndGls9m6rH8AFuvhytfQjireLcozMVCFpndLfI5PEoKdBHxE2Zz42e0akAxpCy2tOzJkPCm2CmU70QzyEA/f089EG+XucKA3cOFaiT+SFIE9+h19N+V7FvwvoKwQe8/ItwYYPLnnxlm94hqIJC5s5M7/7XwUaDMPz07D3hszKDSoHCFxxE9CrXdFjBRJxAgIytOVqga4zu4I5tya/tgarn8FECvV9NOWJlUggPjbqyIEuClCMgyEuu23n6j308T2R+xRVzFQG/CfOr9AhS6NM4UGSh6Zn3sAutuRBwAXwoMcUyyeo02YpRJNiRXZQOPPmQGcBd5qV3+IZawULeV2pIqAKQI4YLrvx3WWN7EAPvvsYmb6EwoC/NBHkv18HXcbJTX1koFnznwH3tMrShKEVANSA7VXirI8eVl//m9V+7EUk2GWLNqBpkYNqffNY9+wFXibxMoEzwPaS+STkblgauJ2MzsFNT8eU
 Hc7wIFiQ
 +zq0ccNeb+LnQw7CWAnP9Las4r/wtzQiwtAQeIpQp368HP7H+H3ssl4gXIRbu/6AlSJYSRmfo36RnD1k2ogcyGPTEKxK7XXh/uk+7wt4bpwoYpc5v/3CCCAnd216fe4UvkrtFoK28zkd1eMtgDpuvbhyRSoDeyWJYD7RxfaYx8araaOA9WE5u2FbVANPtKAH51/PJKVv1k3Gdeh5n5cDtwpyXzX1fRKrh1T1n1RW0HOdJpsDZFyc9ax0uiyNsa6MdaTCSKWeUBmwhepwD4rk21Pfyhnqgy9CPITiizw3vNgaLVY8UFipdqg0Aye6Kcy50N4FsDEPRfHumu4krN6uCI+44IHJzbeibKtlNiRvwL5EYnwUKbsANb/3T/zCgaxHgmQLcLPAP357vqH8COr06I/kg7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() for lparcfg, ofdt and the vcpudispatch
files so procfs copies in what is written before it pins the entry, and
parse what was written from that copy. ofdt takes as much as
memdup_user_nul() could copy before since device tree updates can be
large.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/platforms/pseries/lpar.c     | 14 ++++++--------
 arch/powerpc/platforms/pseries/lparcfg.c  |  7 +++----
 arch/powerpc/platforms/pseries/reconfig.c | 22 ++++++++--------------
 3 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 48fe0be71a89..dfd027cc9047 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -498,7 +498,7 @@ static void dtl_worker_disable(unsigned long *time_limit)
 	up_write(&dtl_access_lock);
 }
 
-static ssize_t vcpudispatch_stats_write(struct file *file, const char __user *p,
+static ssize_t vcpudispatch_stats_write(struct file *file, char *p,
 		size_t count, loff_t *ppos)
 {
 	unsigned long time_limit = jiffies + HZ;
@@ -509,8 +509,7 @@ static ssize_t vcpudispatch_stats_write(struct file *file, const char __user *p,
 	if (count > 15)
 		return -EINVAL;
 
-	if (copy_from_user(buf, p, count))
-		return -EFAULT;
+	memcpy(buf, p, count);
 
 	buf[count] = 0;
 	rc = kstrtoint(buf, 0, &cmd);
@@ -586,11 +585,11 @@ static int vcpudispatch_stats_display(struct seq_file *p, void *v)
 
 static const struct proc_ops vcpudispatch_stats_proc_ops = {
 	.proc_show	= vcpudispatch_stats_display,
-	.proc_write	= vcpudispatch_stats_write,
+	.proc_write_buf	= vcpudispatch_stats_write,
 };
 
 static ssize_t vcpudispatch_stats_freq_write(struct file *file,
-		const char __user *p, size_t count, loff_t *ppos)
+		char *p, size_t count, loff_t *ppos)
 {
 	int rc, freq;
 	char buf[16];
@@ -598,8 +597,7 @@ static ssize_t vcpudispatch_stats_freq_write(struct file *file,
 	if (count > 15)
 		return -EINVAL;
 
-	if (copy_from_user(buf, p, count))
-		return -EFAULT;
+	memcpy(buf, p, count);
 
 	buf[count] = 0;
 	rc = kstrtoint(buf, 0, &freq);
@@ -622,7 +620,7 @@ static int vcpudispatch_stats_freq_display(struct seq_file *p, void *v)
 
 static const struct proc_ops vcpudispatch_stats_freq_proc_ops = {
 	.proc_show	= vcpudispatch_stats_freq_display,
-	.proc_write	= vcpudispatch_stats_freq_write,
+	.proc_write_buf	= vcpudispatch_stats_freq_write,
 };
 
 static int __init vcpudispatch_stats_procfs_init(void)
diff --git a/arch/powerpc/platforms/pseries/lparcfg.c b/arch/powerpc/platforms/pseries/lparcfg.c
index cb3d96efb225..bda3cac1552b 100644
--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -687,7 +687,7 @@ static ssize_t update_mpp(u64 *entitlement, u8 *weight)
  * This function should be invoked only on systems with
  * FW_FEATURE_SPLPAR.
  */
-static ssize_t lparcfg_write(struct file *file, const char __user * buf,
+static ssize_t lparcfg_write(struct file *file, char *buf,
 			     size_t count, loff_t * off)
 {
 	char kbuf[64];
@@ -702,8 +702,7 @@ static ssize_t lparcfg_write(struct file *file, const char __user * buf,
 	if (count == 0 || count >= sizeof(kbuf))
 		return -EINVAL;
 
-	if (copy_from_user(kbuf, buf, count))
-		return -EFAULT;
+	memcpy(kbuf, buf, count);
 	kbuf[count] = '\0';
 	tmp = strchr(kbuf, '=');
 	if (!tmp)
@@ -798,7 +797,7 @@ static int lparcfg_data(struct seq_file *m, void *v)
 }
 
 static const struct proc_ops lparcfg_proc_ops = {
-	.proc_write	= lparcfg_write,
+	.proc_write_buf	= lparcfg_write,
 	.proc_show	= lparcfg_data,
 };
 
diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
index b543afbc1efb..d74a0710ec74 100644
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -349,7 +349,7 @@ static int do_update_property(char *buf, size_t bufsize)
  * ofdt_write - perform operations on the Open Firmware device tree
  *
  * @file: not used
- * @buf: command and arguments
+ * @kbuf: command and arguments
  * @count: size of the command buffer
  * @off: not used
  *
@@ -357,26 +357,19 @@ static int do_update_property(char *buf, size_t bufsize)
  * whole nodes along with their properties.  Operations on individual
  * properties are not implemented (yet).
  */
-static ssize_t ofdt_write(struct file *file, const char __user *buf, size_t count,
+static ssize_t ofdt_write(struct file *file, char *kbuf, size_t count,
 			  loff_t *off)
 {
 	int rv;
-	char *kbuf;
 	char *tmp;
 
 	rv = security_locked_down(LOCKDOWN_DEVICE_TREE);
 	if (rv)
 		return rv;
 
-	kbuf = memdup_user_nul(buf, count);
-	if (IS_ERR(kbuf))
-		return PTR_ERR(kbuf);
-
 	tmp = strchr(kbuf, ' ');
-	if (!tmp) {
-		rv = -EINVAL;
-		goto out;
-	}
+	if (!tmp)
+		return -EINVAL;
 	*tmp = '\0';
 	tmp++;
 
@@ -392,13 +385,14 @@ static ssize_t ofdt_write(struct file *file, const char __user *buf, size_t coun
 		rv = do_update_property(tmp, count - (tmp - kbuf));
 	else
 		rv = -EINVAL;
-out:
-	kfree(kbuf);
+
 	return rv ? rv : count;
 }
 
 static const struct proc_ops ofdt_proc_ops = {
-	.proc_write	= ofdt_write,
+	.proc_write_buf	= ofdt_write,
+	/* what memdup_user_nul() could copy in */
+	.proc_write_size = KMALLOC_MAX_SIZE - 1,
 	.proc_lseek	= noop_llseek,
 };
 

-- 
2.53.0


