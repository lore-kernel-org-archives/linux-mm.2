Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00A70606ABAD
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gPYohCzD
Received: by kanga.kvack.org (Postfix)
	id 148C26B05B1; Mon,  2 Nov 2026 10:05:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11FE56B05CD; Mon,  2 Nov 2026 10:05:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05D6B6B05CE; Mon,  2 Nov 2026 10:05:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6C026B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:05:37 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 734101A0170
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:05:37 +0000 (UTC)
X-FDA: 85390503114.27.028BCE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C8374180013
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:05:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gPYohCzD;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2GaZul5nsAkiA2gFzaNhtmiz6cl7FK3FoYt1S3NMwg0=;
	b=pTc7S0UigngWm7LQ3Qxf+nTPz3QmaQwAD0pxcpF36RtWBYO7RySEKaG4m79fJYpes5Driv
	qkxtIojhMSk6AjAryNmAE43WQ2D7GaFLNDflgrEH1SD8acsRgL8q1vIbmik3GxhgOdIOUS
	hFhMToCJqqqwJ4t9xSMh5cPzkO5lBTU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gPYohCzD;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631935;
	b=C63B+RI7ZQO0rO57/acDnNIh7vSdtsy59o/uIRac9QcAEKDZPMKv1krqQU7iuQeaQGR9wz
	5tQCqoUhoiQYSoyuaVqMBas1NI61SZ56765e9vT6L0qSmKwAUVYh/xayOduHtIOhvZiON/
	RXzi7zAIMm9Trh3figQzH9+LUqWGQhk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6749160617;
	Mon,  2 Nov 2026 15:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC891F00A16;
	Mon,  2 Nov 2026 15:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631935;
	bh=2GaZul5nsAkiA2gFzaNhtmiz6cl7FK3FoYt1S3NMwg0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gPYohCzDqrsQn8T7TOjQzO9kH78swG2borvDZMC6jw8GKugG2jigIBNCmf3EfbRog
	 yxvhj7CSRV/sJqfNt6IzZWz7NbW/xuPFzaZzRxL8W9WId9cYqsYqwOpJnSNHd9Zx00
	 cVCWJlmHSPUqmOWftRxlfoYvxfeTa2bvDLbr+SmQTCQMClvPyfEa80ucz/9F7McAts
	 lpUGT6YWauh99d+fYUOnejKSIPRBXooAdLcFwky+UxQUTCrbGWHl0wHARoO6g8KLF4
	 jS4r3/hO+n7We6evEMM+LHhfwrC3xfWwpo3o7tQV451heeAi+52LI3LZMXaeoL+eQ8
	 lXFrvyo0JPSLQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:39 +0100
Subject: [PATCH RFC 12/22] x86/mtrr: let procfs own the seq_file of
 /proc/mtrr
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-12-c9492ab08480@kernel.org>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C8374180013
X-Stat-Signature: prg75z9eq7cqo1sspgkxgwn7ft6fmuxy
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793631935-180034
X-HE-Meta: U2FsdGVkX18wz27WiGxJ7Ik5Mx8MpwmGpJVluNpX89fprwjGgLyQ7XK8gxAzNaY91Vn7xsABmMKRO1iXa34CncIcTxHn7BJ2mKWoXVxpJQ9pKGPtNox3Az1O05TWNgF/cZfaPkOQX6mBBp2tuW1l+CkWW4as9xQzuPFwSqMAIGmE7yxLi5F2n368Kpq8TM3wImJ+kKDK6ilYdHEg3iSoxK6hzoOlOGF2A6wOXOvO3w4wLAx0BcnTuGyDK1lQffdJ9kQZIEizz/4gwbAgw8ZwoXQ4ZXRuv1JSV7vATeOsQ6UNeqpUVSDlH4TnFyFFmj/Zv8Gc9ncSiI1lOdq8S0g7TpbALYY3hNWdtSsX9+/vF/CO/1fJP2AY3EqWrJHSC0YqsJRavrdCjTYIEKkwnLz7oCzFVqEFU/s2pG0h3YgejqJOlfxFtS5thzNBA6D0W1wxrx74yIgDWH8xAEQOaxnEBK5+XIZbNl3VOybtPEUVtI6jbdK19gJIW8t2nbpu4zyxYkyqcjuJW7XvXxS95d/Mct/l0LTJiIlV4o30jILVIDgDRKGIh8eeQAByUD9QtKazJ0+vzZ51uelWgXghXkcQI4BVSHdEBK8kJFwbnmjWvHWIS8jvgsRVNfCYpuFl87lmNeEVQEOWfXxi9uQDVjDbsr9AD+XpzXL+hCXz+FGxinSjvx5LXvcir1+vPG3YOqfUKVgOy9Ni0769xqH2tPY+EQU3WiWtIKNKMARjj5Y2RXzWHfp0hxcH3hCa5DaB4swrtnI+cuzFyqpR8K54zrDYbC9IoAKDJdq1gIJ4gvJCaquO/m2U1aWuE5Wz52Zvtuw8bAhX9+Rt7s+Y3nQLz9lkbrwNadUwHTkcRwDolpOQqOwS807S+cXHg7Q2zbAMxTQ0m1B8Nq/HcLPs1p57UqL/hAJlXO6CjCYaayIFCa2HVtDs06xETm7TMYjIFSRiLfUdWry/yG5SPkmyTC9DpD7
 qN0VylAH
 dqsPrBMHvhv5cCurFAY0HOptPkdJjyCG+jLtK3KC/NlSkiF5JIp73L6xey2Jhn4i0CMPg32UYxKnPr9ZiSSP5Cf0ycP8S+516E6gP+/tHaAliPAAU0O/kGNUqnI8CGYf0+8RjtuOkbibFt7Q6A2mLL6gVr4xHxNtsDhZgUb9hBpY3aNCFviNxUHPBz55GBTVyEKxulffRFQR7yeIiPtONHPJAl95mkPbps2ytFZilfOBk6w5G/ybTUfopQXuVaeIggtPphrsjufLztybU9828EZPuoLH5b/m2D64/d9CvoP5p9ALy69dZ5hxwz82aPpUG9IzT5q7R3vrT0no=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the show function and let procfs open and free the seq_file.
->proc_open() only does the checks now and ->proc_release() only drops
the MTRRs the file added.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/x86/kernel/cpu/mtrr/if.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index 4049235b1bfe..9510e01d5103 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -349,7 +349,7 @@ static int mtrr_close(struct inode *ino, struct file *file)
 		kfree(fcount);
 		FILE_FCOUNT(file) = NULL;
 	}
-	return single_release(ino, file);
+	return 0;
 }
 
 static int mtrr_seq_show(struct seq_file *seq, void *offset)
@@ -391,13 +391,12 @@ static int mtrr_open(struct inode *inode, struct file *file)
 		return -ENXIO;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	return single_open(file, mtrr_seq_show, NULL);
+	return 0;
 }
 
 static const struct proc_ops mtrr_proc_ops = {
+	.proc_show		= mtrr_seq_show,
 	.proc_open		= mtrr_open,
-	.proc_read		= seq_read,
-	.proc_lseek		= seq_lseek,
 	.proc_write		= mtrr_write,
 	.proc_ioctl		= mtrr_ioctl,
 #ifdef CONFIG_COMPAT

-- 
2.53.0


