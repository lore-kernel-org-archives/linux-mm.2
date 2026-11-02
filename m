Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAA416070CA4
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UIWGBig/
Received: by kanga.kvack.org (Postfix)
	id EDCFE6B05CE; Mon,  2 Nov 2026 10:25:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4726B05FE; Mon,  2 Nov 2026 10:25:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB166B05FF; Mon,  2 Nov 2026 10:25:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB5316B05CE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:25:35 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4DF34160159
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:25:35 +0000 (UTC)
X-FDA: 85390553430.22.C458A06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7BE611C000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:25:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UIWGBig/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=el6PFkO3xcLBJA86iuA3itBWUpq/ZBw6RIw3oM8RbD0=;
	b=vre6rKfOVTD+saJYMfqugBuBDf4moCH7mhVoDMXNLOUPVBO/yEIG2vZyydSxjlm54VJ4NK
	zSsVffaoXyhO/o3/2uv4sGpBRp1ykv/l4ojk3Hy1fxW7J0ggiMG9nS+UNDQMdWjrI2c7aG
	5kb7On6sjrcioeq5+317hIfewyirATE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UIWGBig/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633133;
	b=mQGMhSbAVTU+P/f09P57xta8PO9mZM7ztajjhiivnWxpZ6nYVIJXBeHubs1SN9Anwuhbs0
	MaWirNs+tHIcjQy1fPA3i3+fnrY4TMNyfUDCK7bKPjIKXQKbAf0427zqr+SkAF4GR1mcwV
	q/Lr+T0or7cWNSGgNWEcM0IQvzmws6I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C7E5C41A9D;
	Mon,  2 Nov 2026 15:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18D61F00A17;
	Mon,  2 Nov 2026 15:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633132;
	bh=el6PFkO3xcLBJA86iuA3itBWUpq/ZBw6RIw3oM8RbD0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UIWGBig/hERSv8UC2SBY2/AHoKZwbp+vwJFVHzMXkPYGqF9dt5+0EHsg4lTeFLkeY
	 CX0dkWtDTbDh5piV0+jALeqJO7PUPJCWq1rupoLvRrR9hiV3ruK5lQ5JOwWAGeI3m9
	 WHFwZ3fPrTC2yVGxGOTIiQVUBriwWhb2Nv/E2ooxajbFUJ7ShCeNadjFtrTnu8oFHf
	 xwdUD2zrQXvpkIQ0+Qui98P3kjE0XPPvTcVbSYvw3ebU20McuSBsFpLwx/BeWQxlQ8
	 9LtMFh6B4imtlAnC4skherstPQYyR/MSLL3rf0G6z64tTDIw/TLE29S7Z0kORviOLo
	 N/TEiOL6+fxLg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:26 +0100
Subject: [PATCH RFC 16/27] sched/psi: let procfs own the seq_file of the
 pressure files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-16-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2971; i=brauner@kernel.org;
 h=from:subject:message-id; bh=nkKdnljsMnki7Ruy8D8hScsbrXYOUFXONWdXZYhGvI8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG40a+nMGLu2+z9eheoKh0w5ullw+0k5Y81bXIHrm
 k3i/y2o6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIhQCGvxKS9lN+rOr+uvCY
 g43mie7/U77u6rTN7Zd/x/ExmrlJaCLDf8eDZ2sYnGNzPy0zajRR3fOy/on3y7yddT/K6nOLk54
 ZsAIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 7BE611C000C
X-Rspam-User: 
X-Stat-Signature: yh648gxyx4k65gg618p6hwfmoodwkrmu
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793633133-845864
X-HE-Meta: U2FsdGVkX1/IAajGV6TYmSmPY4Bp60MeUMbYrmJEF08j46my7nfyhGd7DPXsGfJrYq/8CNvIUnrozVEvi8BFfhX26U9K9Es8AWM0z4SIBSU9P7zH11V9wQ/gnhacSOO0mDgcyeQeyegeD834+HVMePN2dhXm+SDLVaXs0Ist1XQlf0IDTrnovRFuosIYx4c6sDXXT0+HswVUYXs2wAZ0bLA6mBzqqrr5dtoo48jjLBeGHNe0rdIdCZVQxaQznaFGUywU4DoDPmJqbxAl7g64pEuCSOP9brj98xGFaHqxDGEXqeQcdQpfHcOamyL/OS7mbPxzP07F2uR4AqHfXkli+bKv5NVjipPXzMJXdlBDPICceFiJLBPvTyTYxpArw2rAvkgGWV6sBO0+35kiOs8U1opyGoEVRod7lfQgzySGgqhWTxD+qw/oVR/ZUTzVkk6JQmmIU7zQv+BWDFA7bx4iGKOdi7+SiMPBKzRCDsd4/jPJon+WSJX4Nyz5uIPfrwRESfJ3XiXabVP2/MsDARjo+iZJhUcmznn/cbwJu/8/Tljlnn5i6Fe7KexJsYw4EPdIliaHHgbJsyrOeB4mgSMCOSzrzlPyM+xNeXdyoG5I5K68L9tcv1bYy3FLNHp8Bo3wR8+nGc5shlX3YACl8K0jPXtbHsYua4hg4x9ETS54fZlrC2LoF9adnYY6bV73bLMtDNYwQmDt7j3jLRR/r+pu1/UXmx/kluLTVYtnJmli1Mho11XCH6KWCZQfDw28P0Jsquu3wDWD98wQz1rVjuKmxPYBMrHOsbuRCpB71ka/IZZoan1K5N+JC/Y6kWHY8BF2wYhK31koPMrsWUM0kvESHAmOABwV8C3YnSCX/nlR/d/gana9YedFLJQYSjKTLlAC0cIAaatXhuAazxqrZtJlKu4PEyzUQaomnII+7NnKd7Rc4o2b0M1MqrE1dXSLi0dEXrfq28a1mEpWMkpKPDJ
 9y46mWFq
 HB3ZC85p7uES7f9NYUkZK/yRBvbeCai/AZj3SHwL2+7vOS8mS5gJBh1fUkXPNeaqqfTOZrIVLIOYrrQs1pmGzWfB9zZRAwZNu7tcSaQD5raQ6MIiy+XwYUnHQUfz3th1PD1NLDwZx4cLnxFrxDndg8yJ4mCebpOds1OSIxQR92PkSIhodzLDVQNNzMy0JaarebHZb3yV2alg6K+ltPmoRHVk2Pc8JVxHrZ4hEThNDr2uVYhtaeBUCNUF1BV27D0AleyGt2+Z3nni7PI/XaetKHeG/PYcnvLKG6cDfGk4fwNg89lbmSAG9AusV/r13tzcNkSwbOoYMnQlyLxs=
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
index 7c5381423334..bcb8bf4e0b69 100644
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


