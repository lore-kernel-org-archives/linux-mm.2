Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB04A6083610
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gH1uQceN
Received: by kanga.kvack.org (Postfix)
	id D53266B05B2; Mon,  2 Nov 2026 10:03:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2B2C6B05B6; Mon,  2 Nov 2026 10:03:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C416F6B05CB; Mon,  2 Nov 2026 10:03:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0446B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:03:50 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B7C38016F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:03:50 +0000 (UTC)
X-FDA: 85390498620.11.7ECC954
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 63DFE40005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:03:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gH1uQceN;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631828;
	b=cELsMI/Xl92s/RUHpCyGvBnFUngthvUTvx7gxMW8jJa3F9W79ewkPR9cgNHQeYZoCE1MwQ
	L4b7xOIGqAwMXQ76qK9jd96NtSJGNLPU5uPvb/eBPHVhewvlwyKMz8ErRcFI4jHF5F5Q0O
	Pqk7kJDkNRqCPCFct/eIs7W848pV0C0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glw1dCbJy4In8cXqUP53v95R3+j+o1Gb2tGtrZFmQOQ=;
	b=ktcMG3Do6L+g1Q2ZdCTKy0NiVnc+zV8RnGxXCvkYX1dD1KDndpzQqwYBE/1gtqub5tkhWy
	hTiTEddWzPkHsiTKNvRy7a3zC57sCOy8EaI4EipWRy16mx77esfFqtwhhyRsdKIAIqFKxd
	M6xF9eolb2KqNLWTv+xWZX2rv5OTCPY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gH1uQceN;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00178605D4;
	Mon,  2 Nov 2026 15:03:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB191F00A1A;
	Mon,  2 Nov 2026 15:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631827;
	bh=glw1dCbJy4In8cXqUP53v95R3+j+o1Gb2tGtrZFmQOQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gH1uQceNT0pe04RugL3tkndtCg/BNWtt8gjyfjkjxpxrv4DD5Kj/ry0K4iVOfTu0T
	 XyqCfm2AIZe63dMJyEouauqLimhfpL7Ahx9TJUWfLtSMlGm6wbGGbzqxmjJDCoGvoi
	 8bXwyOHcBtFikAWlZHrtqTOUm7T60Rc1rGMBhy6wte8Tc2C2WHnRkyW6FZfLwJcAlt
	 QIxSWGPq1Pt9aUCZFw5Fr8TfPzVXromMNqTo4BfW3zJS3GdVdZxJ1jiE4RlzKmMIbu
	 NMgDHlNBEuimzLNekTMW7U7s+08uLY2Cp7ql1hPbJQuDeycC8awPE3b+o47F+6OePW
	 BX1NU0ZbhTSrg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:34 +0100
Subject: [PATCH RFC 07/22] powerpc/pseries: let procfs copy in writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-7-c9492ab08480@kernel.org>
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
X-Stat-Signature: p474cabd174owasswqsmh91m9d4t4mpj
X-Rspamd-Queue-Id: 63DFE40005
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793631828-440341
X-HE-Meta: U2FsdGVkX182/i5V0QkrIMUyoepOukC8mvc/At8gmr+sgmk69WQj3YrsvNrcLUVamA26dXe7lxHkd1I6wqPFR8kaowXCpynGkMCS1IVMMe55qJVQ8RI0TFdyXHyghIHwl2ytWgAKR9glQEexMbPqbSxSaebNFmfJXJ9D/ZuMbmUyQwaQjASTjoKLLVsBK8rm7W0acyosK+3wB/MswxoUdw2GVEwYPHhPcUFsy3oTC0z+jFyT1LJIYoYp86wRed3g9mwyU+Cj3zJBtoU6CGbi4bcC+uRulgzgCoUcbX4I4rHOxxGVzl4EofA5KonB6T/MKhrdhIi9HxtGbQCKFrAB17EV+DKnsMryNgFxCMmsXg4DNY4bACzc1Y1bN3x4js/+4FOIx+cY6yCjbEL80CXA/LawEd01LmOzfiSHPA7jD7gyRD+Tr8ZMNlyWyni9PSTSMlSQHDKj1Go+Mcl5gJi9nkWo0AM0/HnBVyhPPQ130PfmmQHh01Gz5B9W9Mza6F2i7rSbWqeGDJFbsMGCMBAnSuqnyzmib3F9sVNhuFO1lwqJ8s/z5xidvzW4WQCj/IU5+4tpOfltuzMDAO314NsTu+yr0x3z8lPx093GW1Hq/A9cHOng1WINi6XNu2dMUGnDP87KtyQUjam9VauGjZLtRuUFYpb3i6kivCjYD/h5upzLVjccG8XINnnRZTn4PtPPEgQ1KU/gPx51EgGG1+xEMftDKDIeWZT29+460+JaLzpsKVrM+uBVsGLr/Sdfdj2P3yUtChHQWg6aj0turQnxIgfFW2ss2z/1zW3rS6oA5SE7lDeu7RULp1oaCCF1rj4Up5BibNtUUopmPfeSgtS+Xh1FY7+f0NJSjAdRZhodapFj6nRjTf2DbvAAYJ5HYkbJcgsOcJ/zFXejlgPvlRyMYE/gdHJkPUqECI8AF0qoAQDT3ihq45rql7slewsYbfnvmgTtSa227c5pwI1v0nk
 ssyXSUlH
 +sMRvHBgoi+JE+F69iPf31mtH6w6FHBPJHdrphNTtSArK3B1uliKkrzmcJXkQhyru/EhIMVaUCPHCSFcIhszFPKfrvhlJJfKBZzk/lcUSEbN1R/O5k9fcssSeht7qiShTrKoMukVEc0yrWYgtwJstCWFUp4p5OIpTJxPz1thyBeYMk3WjGBG7VgY5vUNtW2/T8Z1TZussJSn5HI6B1Vwk/QVcVgy1u0BOLOVpzc7mW3PzUzvCEiPWexBUFmiQsadIHEaUjIarud3ZRofzkMB2cGneIyrg4ivxj58fNApLiYeaz8Wl/6f/RgrcjMCRCk0zAr1zr7GS0GkA0d8=
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
index a6a137ce44ce..43af7f820fab 100644
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
 	if (count == 0 || count > sizeof(kbuf))
 		return -EINVAL;
 
-	if (copy_from_user(kbuf, buf, count))
-		return -EFAULT;
+	memcpy(kbuf, buf, count);
 
 	kbuf[count - 1] = '\0';
 	tmp = strchr(kbuf, '=');
@@ -799,7 +798,7 @@ static int lparcfg_data(struct seq_file *m, void *v)
 }
 
 static const struct proc_ops lparcfg_proc_ops = {
-	.proc_write	= lparcfg_write,
+	.proc_write_buf	= lparcfg_write,
 	.proc_show	= lparcfg_data,
 };
 
diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
index b41c5db726c9..f406e826a03e 100644
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


