Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974BD60DFAED
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hDIYsiNB
Received: by kanga.kvack.org (Postfix)
	id AE62D6B05D5; Wed,  4 Nov 2026 14:54:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABD526B05DE; Wed,  4 Nov 2026 14:54:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2226B05D5; Wed,  4 Nov 2026 14:54:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D2DC6B05D5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:54:08 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0287A12080C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:54:07 +0000 (UTC)
X-FDA: 85398487776.22.33E2F0C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 48A3D80005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:54:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hDIYsiNB;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822046;
	b=3VCGTpexr1YOaM+/B/knD8G3YlbuQtzGU7F/CXLQerbWcVUJmKlKvJN/jg5nQLXfttjvzg
	IgxiUQ34TrGEFYUJLg2Bgw3bFQ8KRBIu1yKwesuuJGzwWs52qGF3vwMimeXh2zyd1alsrR
	mVz2KrQ/QBgtHqheEynz98kVRtalo08=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hDIYsiNB;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wa2DxwoY96vQ+as6UgZb3UJIgeJzEwCZb2I3vpV0xHo=;
	b=BGmYHLRobn3PoqHs377DDBDMlFgEwy2JrzbTnBXk1Lqj665l4bjolcIKcyernrC8W0OiWf
	oaF3m0csnGHl7oeyLnzIuyvb4Yquv/Jn0pItji4VAM8L99yo+apMoG1I0vai4zqRe2AKMV
	48THj2SwKRyLIarxbI9xwstGZUVOGeQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E2FFF6143B;
	Wed,  4 Nov 2026 19:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3BB1F000C1;
	Wed,  4 Nov 2026 19:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822045;
	bh=Wa2DxwoY96vQ+as6UgZb3UJIgeJzEwCZb2I3vpV0xHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDIYsiNBBbAB6nCICl2CgYVmu1Hc5MI7vg03BuY69s+e6pJT+WUTVg0+E2R7BXucW
	 ASIEwQD/8dKh5gLCW56yPPqhr/8yzBSB3mWD610B6YBFxv2MwcgJq3I6t4BOpmtLEi
	 w6X4zToEWrG1oxCry2goo1fqiSX0980JJHxIp/b3+x2Ri2+ReMv/Jb0QANsRd2Di7t
	 Rzpga7r+AFVcSz5t835+amCK62QzA458xk0IuFMIaQ5wJCfI9SpgS4G48o8mHpSNgB
	 +voP9K2fVkENG08+Y1lBh+7RUetaZbq4uubBe+qWoiy60DFlrYcnLc2yMGlLbTHf9s
	 swfqQ47cYsOow==
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
Subject: [PATCH RESEND v2 17/30] sched/psi: let procfs own the seq_file of the pressure files
Date: Wed,  4 Nov 2026 20:53:51 +0100
Message-ID: <20261104-work-procfs-fs-v2-17-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2971; i=brauner@kernel.org; h=from:subject:message-id; bh=pvcY7H3zDMUPKTR5VRDjfAM6gaPdAO9YnwSNmLk0d3g=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97rGfE8i72E/yhZutqDL7PN47uzQ8K50TT+4w3Hhbf vutkt0VHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNZfZWR4efcj3di9RK3nt10 KDbRd+L7jS/X575VFDqYfmbv94ueCxcyMqxquv8teNcGj2WSIeec/c4dzeWyOO2pu//Is1kJNi7 cT1kA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 48A3D80005
X-Stat-Signature: 8s7m4x5rpgt4unn7buo4pamei5z3ppx1
X-Rspam-User: 
X-HE-Tag: 1793822046-912086
X-HE-Meta: U2FsdGVkX1+8PBEZsx0JGKrcDo0iu0RHVWH6XcHwbaFkOtXzePmM+2zy+ERzoaE+IGQ8tqVPVbwRPu+b7TVBgmiM/zf6fNQsl7q0MoTIVWmv6BQS9276RlEtPlGUxtoYhFH2wTSaLG/12+luIfNEbtYB7YUEHSSUTOUpiqerXlrw3saqzlbL4ilOZPub6WSWHjhdxpHGYSuXYD2pOSV5NM2QuPfnC/9UBCF3Os4ycaI/ksf53aXJQ5S67q0rmwVBNU8WMgMKQv45SNEBhDHAtE8s/PnTHkiqisGw76GtDQtul95TyaUTwBqDdPIvvjUQvnPObVOUBIl8zdInoAFckvO4YPOqxJCs7hdQ1LHi6rT06RR9P16hbw0AumAoArNn5/HHce/uJ1/BLBAA0RSBtlR1wIwe7sUAuc/MI4cqkukZCaIDnynwgKjl4+TxLoHrLtDHlSPT/OzKGwJNO9stq7Z4Clf/XAZ2htSImW4WK5RH+WnOA4tA9qglYmto6XoZqM9j+5qYkXmIXGU0nLIcwZZAYdu66rJNM6whAK5LlP03xXr323t2sR4naS99YJHuo+GJj1nYfxMC9j7fKRIChujS8sLXLYeRm3bf2RypyGA0Qb0NxOGvJwVNUeswhPN0+m7PS8QZw0lHuoppIgAnD6yvvHhV68V+aVO9jfeyy/FuyENX8qcCJe2nxcEKumnafMV6XOOwfd9gSkbt5p6rEOp4eUKEJK5+NGl5NiIPtqVIA9NQiYhymSNUJcAZ8zElPbsEhuac7hONc9Bt9+unId+hgLIp4uUfbpMOdUWJz3aM3ba3/eq+WGaoo8bXQ/IoUtylEKgJxJn0C7+s23eE1uXrVtQDsdG9Rqu22/WhoEAhaeo1mspW74QSJ+9ypLIQjjXLm9x4SPtO50DvVywnojiY0gmDV3pd8ci7GRICsx4uSFzswj6BVvctioGlGWY9cYqJUvvtbRDzO4iAZXw
 Joc+33pm
 zvRK2uVW7nNFDLqQk71mxkiBFZlqkL5JWEJOVDwIzHjq1oYsDZfRoZGoeaxrm5yTsPG7cbrKc+Ii7rY9/4QMl1UBoW1c82Bw+twO2RM89PE4sJgVYny9SmoAjv8Uybs2qRSt+uRd64s2YEXbg3EohOEWJ7VBM54vk/1ZEVWtXMGtp9fqcpZC/piiT3lNHnaKP/Zq/zlHJJt2TnP0/MT39sImCobSZKtZ+T4dPEX/f1fx6/EGAswAdQeiymW41QZQaRnY5/TCMFvW2G5TnpEZIMQ9zXego//PoPqx3Yr1VagfUztERg1fwuY4K7LvQN8OtH2AE8qY82lnghNV6Af65vL1jS0fFhAu/yrNBloowLbDEV+oI3lGDPz+Zji85NSpcBpgKPenKsAZHxNjwKIUGgFcaNJWb7alQX7cwP20vvxiYEH3edYKRghw8b+sdiJfIDvfB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the show functions and let procfs open and free the seq_file of
/proc/pressure/*. That makes the open functions unnecessary and
->proc_release() only destroys the trigger now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/sched/psi.c | 38 +++++---------------------------------
 1 file changed, 5 insertions(+), 33 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 8b59635e95d4..9f1d9742bac9 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1535,21 +1535,6 @@ static int psi_cpu_show(struct seq_file *m, void *v)
 	return psi_show(m, &psi_system, PSI_CPU);
 }
 
-static int psi_io_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, psi_io_show, NULL);
-}
-
-static int psi_memory_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, psi_memory_show, NULL);
-}
-
-static int psi_cpu_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, psi_cpu_show, NULL);
-}
-
 static ssize_t psi_write(struct file *file, const char __user *user_buf,
 			 size_t nbytes, enum psi_res res)
 {
@@ -1635,31 +1620,25 @@ static int psi_fop_release(struct inode *inode, struct file *file)
 	struct seq_file *seq = file->private_data;
 
 	psi_trigger_destroy(seq->private);
-	return single_release(inode, file);
+	return 0;
 }
 
 static const struct proc_ops psi_io_proc_ops = {
-	.proc_open	= psi_io_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
+	.proc_show	= psi_io_show,
 	.proc_write	= psi_io_write,
 	.proc_poll	= psi_fop_poll,
 	.proc_release	= psi_fop_release,
 };
 
 static const struct proc_ops psi_memory_proc_ops = {
-	.proc_open	= psi_memory_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
+	.proc_show	= psi_memory_show,
 	.proc_write	= psi_memory_write,
 	.proc_poll	= psi_fop_poll,
 	.proc_release	= psi_fop_release,
 };
 
 static const struct proc_ops psi_cpu_proc_ops = {
-	.proc_open	= psi_cpu_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
+	.proc_show	= psi_cpu_show,
 	.proc_write	= psi_cpu_write,
 	.proc_poll	= psi_fop_poll,
 	.proc_release	= psi_fop_release,
@@ -1671,11 +1650,6 @@ static int psi_irq_show(struct seq_file *m, void *v)
 	return psi_show(m, &psi_system, PSI_IRQ);
 }
 
-static int psi_irq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, psi_irq_show, NULL);
-}
-
 static ssize_t psi_irq_write(struct file *file, const char __user *user_buf,
 			     size_t nbytes, loff_t *ppos)
 {
@@ -1683,9 +1657,7 @@ static ssize_t psi_irq_write(struct file *file, const char __user *user_buf,
 }
 
 static const struct proc_ops psi_irq_proc_ops = {
-	.proc_open	= psi_irq_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
+	.proc_show	= psi_irq_show,
 	.proc_write	= psi_irq_write,
 	.proc_poll	= psi_fop_poll,
 	.proc_release	= psi_fop_release,

-- 
2.53.0


