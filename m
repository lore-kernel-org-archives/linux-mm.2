Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D8ED60AED2D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mIjK3Qwt
Received: by kanga.kvack.org (Postfix)
	id 8834F6B05FE; Mon,  2 Nov 2026 10:13:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835A66B05FF; Mon,  2 Nov 2026 10:13:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722B16B0600; Mon,  2 Nov 2026 10:13:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1D16B05FE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:13:25 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D87C81C04C0
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:13:24 +0000 (UTC)
X-FDA: 85390522728.20.F17938E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1F40A1C0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:13:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mIjK3Qwt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWMrcMxphM3j3KhJxvOCR+KbGizC6kQdxxuLzJskxVk=;
	b=NMmE/Fu9l3H/sDha22YumG3bynfepp+FO/hJFUSSW31Roqk7DmNUh4CFPMZzcLDa0I0s7v
	HvTeYIRirkkSFitF04cVVCCSnL9jziYNRmpuNa3TN053FeOdJIWKJsNUR5XzfJ3+8KwauB
	pVVfEZTP//dGGhhA7eIpWmMFrDz3gow=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mIjK3Qwt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632403;
	b=5EL9HmDVzr0HgoPOteLZdD+nRFlBRRViYRvFH4tLfzx+Wz/Bfk0IXBIMu11mIHdWeyCCO7
	YNs3pQBFM04d1HAzA4VxNVXu2sZ8j4V5zmG+5Zdgwoo0HuCWrR/bOznr2ySHNuK/mHlOPe
	bvAu4vd2nZJiM+OBjouJZQ+UE1Atdq8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B11BF6053E;
	Mon,  2 Nov 2026 15:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643241F00A16;
	Mon,  2 Nov 2026 15:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632402;
	bh=BWMrcMxphM3j3KhJxvOCR+KbGizC6kQdxxuLzJskxVk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mIjK3QwtTVilSpcRMeaoz6MTKvP7Sy6dH4N9uXF4AEtvkmOD+/LZgf883MtrMNbfX
	 Fc7qy6+hRUrZLI12uqt+tFP3+FSAd9d3s0S7Oj/5J8YKb9MuvzMCclBQW5ujuLEY3R
	 0jZ40m7Qe6thFpBjmEpgSnaWIQpr2OFaA+Hu2iHvPuRwIzTy5CX2f99EzFV0hO5HRa
	 v3h43WiiAhfIdyZllqL5RbxOqUX3/Hcfx8oBtLvZRAePXNc6Si2FGn6GzYJmq+441r
	 GdWXtRs4TvUpEjCZFIA+oogkhKJvXJm8hEiDfFaliMcEnFuCVmnTvn4+eIcYomOAzM
	 v0Y6JeRoVTSgA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:16 +0100
Subject: [PATCH RFC 09/23] scsi: let procfs own the seq_file of the host
 files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-9-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
In-Reply-To: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1394; i=brauner@kernel.org;
 h=from:subject:message-id; bh=l1PqfsIz+cqTipGWNtI2ZFkSTs3hYfw6G0B1mtmwjUo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG4wo+Pp/Vmn2AIF2jK3Rnc8S5TW89ldrDXNvflSK
 a9TlSBvRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwER2/GNk+LjMbs1f+SqdgEVP
 95yaUyouP9NB9EfZdvNTxdef/51/W53hnylf8tFqgbuGLVyB25bLi7g6NKw02Kjm+6TD3337TuM
 +XgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 1F40A1C0005
X-Stat-Signature: 5e6hhj74p9nhx1qnh6fawn99x7gkni5b
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793632402-97959
X-HE-Meta: U2FsdGVkX1+1660n/xAJw2dpXDiN9MQ2Ncu29Z+jlJGZaC0QB9I+zZOoJTVXQro9Vdn5bSrI6dqXnMcFkSOCsATZx8oEON+dM/uDwANJ72KrVXlyek2580X6kDIlH1lAVTyq6off784jN9HrXBTufU/D290jiUwgCH4UDt5AW8LapO+P96CjCEF0H/dRCGmZL/dK3S11jwepxtayHnZBCmgjx482eDVohi/QdDEUMfSBd3ea/N6lnmuK4vmrXgJOG5HidF5GumwmAAvagyNPU5oS7Cwq9eaWQgqT9t172VeVlJqJ2HF0pe6a63/XapQigxT58RAkV667cB2Eua8khx7EKMXpoQ1O+q6w/9gORcPFt+NBdfd1SnzriR365ueUNwH3+28XKC8XsawdTKr24279cQhQelB/34pwUQ4WsenflodOLmXtiPDdu8tPqee7Imq0+Rxs28z806/S3xBS19l6TDfvxMZqXZrrdOJoIExrVwzPXcBggU/9Db8LjLDfXO5Z1ltZrPHPIWwMck9mucfNEeiIivlaFyJB5iFswDA3Q5SgGgJlzLRou2qymh7uWdF3mW1ZmZofdt/5/iJcNicPtEo1huxb7Xo33zK18u0xCx41g4gv71DiAHz9GQmGr96dhFO1ZZpjn/zbBfks1+Pxf/ETIiQtE0JsjRYjtFiDeEbqQ9awEk5spMZb2Ze26FYn7jOq0xwmO9WUvm5BRKCTx7eM0FJP1MdSsbj2/xvUloIomUtyHzZDTHQOhxNmlm2uLqynWQ229w7VQ0UL1nbgN2AASsItm8dTwiIZnE60GKORORsi8kJorjJpiYuBNCrH3CllVyeROyRbSDmaKJzs0dIGm8z6PhmpR9I7RTsaPP9ZyXhyjZr6XnYWnNCwixQ19wTepAcM0nRe1+w45mcEA7dZA+Wd8m8kvFaTmBFqt6yRvH/KFsJJfBiVea7EzsqHwilnPiqTl/36Dto
 Qtpw+QLb
 sQxr1u27WezX9Lzh1grY9d7qlEhS2oDjClBtIEW7t4+NuEl5uNmlR1aGJjzEGC8A76pJFxmK25YYgjKx8djJe36JG2oRhFEMhQ9h6kWALsSMnbJM0IOEKaZavEXwCyG5unlnbqIgFbS0I5GN4lT+43hRMt4iH9u3Xw6SYM7k8h6i6QRy527hrhVFMLfQHnuooiGpEWU6RNcaMZ/9GnftBcl91zThE9vmjX+YFMFVvvPTOozjt+G5/dUn/Z7WRoA5JWuJ66hXA+k0+wAtOu7XKXL6QKhK0fwl8xOXkq+7xiFUCvbBw7kvtyb2ZdEuAzDC6s9LZ0wvYE6CjYoY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the show function and let procfs open and free the seq_file of
/proc/scsi/<driver>/<host>. ->proc_open() only preallocates the buffer
now. Reading the file then no longer holds up its removal when the host
goes away.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/scsi/scsi_proc.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 3e49c4c8704f..59229bf9938e 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -94,10 +94,10 @@ static int proc_scsi_show(struct seq_file *m, void *v)
 	return shost->hostt->show_info(m, shost);
 }
 
+/* procfs opens the seq_file */
 static int proc_scsi_host_open(struct inode *inode, struct file *file)
 {
-	return single_open_size(file, proc_scsi_show, pde_data(inode),
-				4 * PAGE_SIZE);
+	return seq_preallocate(file->private_data, 4 * PAGE_SIZE);
 }
 
 static struct scsi_proc_entry *
@@ -140,10 +140,8 @@ scsi_template_proc_dir(const struct scsi_host_template *sht)
 EXPORT_SYMBOL_GPL(scsi_template_proc_dir);
 
 static const struct proc_ops proc_scsi_ops = {
+	.proc_show	= proc_scsi_show,
 	.proc_open	= proc_scsi_host_open,
-	.proc_release	= single_release,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
 	.proc_write	= proc_scsi_host_write
 };
 

-- 
2.53.0


