Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 544DB6079934
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aoFGcx0p
Received: by kanga.kvack.org (Postfix)
	id 5C5C46B0601; Mon,  2 Nov 2026 10:14:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5761A6B0602; Mon,  2 Nov 2026 10:14:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 465616B0603; Mon,  2 Nov 2026 10:14:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0FE4E6B0601
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:14:22 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8BF6C40150
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:14:21 +0000 (UTC)
X-FDA: 85390525122.24.7729507
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0A76540015
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:14:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aoFGcx0p;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTj8vGUhriHCrFXvGM0jGNx3xl9ERozaQgV9GXGsY38=;
	b=vMXtFO6gsuMgDNO5lhEeOPIXmTcINFBMlK4VuEVWX/whBR1G62rpYJX1seE9gaCoA8HgFC
	ElmrB4zF09xP0dhDbNauiw78FmPDkvWmePjX7VRG0HMnF9O83RnikfH6IpOx0CwNqzLtXw
	uZtW2sj6caxk4ajrLaGUHWeiGuF2qmQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aoFGcx0p;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632459;
	b=etxaHeKGqxko+UrL18wVZBWRRjVg2/9W8iDQalkWZgNGZQ5nmrH6/zkIuE6dbJ95uBIhbP
	tFHX0IinKpNzmNhNPgFOuoneycN8vS3PLvWskX/q79K6Byf6YZzskWMsrKZbBNrkB867Yz
	6xf7jN4Moy+7p3BVOcBxsDxVrXJWUmI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 89AA960230;
	Mon,  2 Nov 2026 15:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8441C1F00A1D;
	Mon,  2 Nov 2026 15:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632458;
	bh=CTj8vGUhriHCrFXvGM0jGNx3xl9ERozaQgV9GXGsY38=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aoFGcx0pELaJ5RYWtke+xC5t7aNB65DB/8p1Zyd+Mct0qYV4hXDTpFdt2jN92OjLm
	 cm9P26FLH82HHv9uw3dBZcgwAFDEPF2a3BUk5VP4UipyUvYMQBZsfzU8GWvk6Denxt
	 E+8h+vKxlfMsymem4bXtYNAdw6PVC20yhamxn7bhY3LAKScGG+UHFtjCsk/SsEKeLw
	 mKt9GtlF0fXNneJBDl1wbvMAkvsv60mfPqz6Wg5a7kgDUDRlelGwablxe1YjuJDu/A
	 zVy69YNLIhqAiQvfFY8ZlaEu8v/NK9WoKplt79CxDhcQu2uFCnSjhECk0F4Ds7DT4j
	 Xm4j29KusNR9Q==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:19 +0100
Subject: [PATCH RFC 12/23] scsi: sg: let procfs own the seq_file of
 allow_dio and def_reserved_size
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-12-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3098; i=brauner@kernel.org;
 h=from:subject:message-id; bh=i7XPA6oQ9lTisv2fJhwkVTww2SSinfY9aqbIviKN0Rk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG6Qf8grL/vRBPOFfc2hW3RiHI9mZiQELndpn9khL
 RHPWBrfUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMBH+LIZ/Znxfdj0svxz/x0KW
 cdfJXz/uVP2z5WL92Rx27MvazyK/WhgZXtf0pV+c73nSVO8zu/lFWSMbjbVtv7ecN4xQ/S9ns82
 bDwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0A76540015
X-Stat-Signature: 8xtbpt4h1cffwbqiq6y8ubi7pwzwhhbm
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793632458-272314
X-HE-Meta: U2FsdGVkX18ytZFt0CBRfEtlHt73FsizLTfI5bSnmN2JhFRBRfNQALiSzK78KlQiTX75iACEK+7v1j3yvJvkV/3tSehE3ZUl9NvhY+MVcB0e5Ni6pzaLlqbshAx/Mhrlt7GCv1PC99Kh6Fhbfiv7rgz9vTAGhlC50B8V8Fd4BxYFEQ6HRvfYafp2dr0fEqrvEjFMG/jiIJuX5FfSd4IcQ0pDN4kbVYr0cGTQghrkB7qOqHxu77Hj4VDG/b2B0PXfKmoVGk1vluZcJ1o3JxueyVs3bvyYEdBh46zh7TeKpi6EvCw3vCqiL8ibGsKbPwP6vJTbVhtTzHSC7WNQkAzeybvhJWeDzXk73IghuQA78IQjCoiO5kRT8GiqWrjrL3qtL1OXWEuBt5YXloAYjqDDGE6WNkpT+Opc22728Nk95aSXK+aa17LNvNw973DdEgKBbX8hpyK2Ob0SWuDZdpiykDukZ4QFg1hoR7NSBK480oWTDrNChE5Guaw+hcWTeAg+VQpkCKSJBxfDP/ZFsUL59N2W+fy/ISmpyo4+3Dib71ouWHdmFZVHRSCQxaIpZCCvax5tK0N6rkBhF8vM9K7RGqku41uxgvK1xadOX00PNS5krAI+yIdIwAeLd7Oz77bbpFeF3e4WFM17/968Pzd3rPVZpssdJGz1Ko1j1bUH9qHqkhwHmtya5WmXFy7oWx6rPJaHylkHHfQU2w24PlK56lD1mFZB6s038sx4u8Smc/sCJURgnIAr6mje0dRnzVgiEEF8C4268EfzUd1dLA1G3KFeocDh4/0cydqu/PE717I2HRRQV/ZrBy8zVke4fk8U128Py2LEh3+TEskTmzZ3ZIFxF6uKJfGo4beMfN04T3utpFQRkjwlqTbRowka8wwnpQHMNnKM/yWEpFo9H3F6kFffFbw0SFDsYVhAhUzlFPhz6yrVF7f+P3j0c46zR2OHPSe5Pz+dMC+BzcJssWc
 kJWmm/Id
 +O1/t26bUcwhRFIlxl4uzzDaHZOdnUqmHk/QwULejh8Uv6PVOEJbZbJbMCb7oGWWCda+NMN3Izs0lbPu6WsJwDV8y4FS9tXBYYIKvfPp1pmb6RD5NUhPfsmV1L2WeZ1knie0j2TAltKM3x8oX2Z46r68plS8uznjsLrGNl53iI1IE/7h0Wkah/SKZjzUfkIYaygA8RCJITRK/4bNBdtdHgO15Fe5jEPk67UDM0yyGicjJ0zrJOHHgTZcwm+Brl4+oSTj4lDlR5WpfLVjBreqT9qRxVIYkURa9pJQFqZeW7NuY3rXmRzl9r9RSetxssOgaNAGOIP0/qqOgV2E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Pass the integer they show as the data of the entry and declare the
show function, procfs then opens and frees the seq_file. That makes the
open functions unnecessary.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/scsi/sg.c | 28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 3f9e08725602..c7386fbe5580 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2287,26 +2287,18 @@ sg_get_dev(int dev)
 #ifdef CONFIG_SCSI_PROC_FS
 static int sg_proc_seq_show_int(struct seq_file *s, void *v);
 
-static int sg_proc_single_open_adio(struct inode *inode, struct file *file);
 static ssize_t sg_proc_write_adio(struct file *filp, const char __user *buffer,
 			          size_t count, loff_t *off);
 static const struct proc_ops adio_proc_ops = {
-	.proc_open	= sg_proc_single_open_adio,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
+	.proc_show	= sg_proc_seq_show_int,
 	.proc_write	= sg_proc_write_adio,
-	.proc_release	= single_release,
 };
 
-static int sg_proc_single_open_dressz(struct inode *inode, struct file *file);
 static ssize_t sg_proc_write_dressz(struct file *filp, 
 		const char __user *buffer, size_t count, loff_t *off);
 static const struct proc_ops dressz_proc_ops = {
-	.proc_open	= sg_proc_single_open_dressz,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
+	.proc_show	= sg_proc_seq_show_int,
 	.proc_write	= sg_proc_write_dressz,
-	.proc_release	= single_release,
 };
 
 static int sg_proc_seq_show_version(struct seq_file *s, void *v);
@@ -2347,9 +2339,11 @@ sg_proc_init(void)
 	if (!p)
 		return 1;
 
-	proc_create("allow_dio", S_IRUGO | S_IWUSR, p, &adio_proc_ops);
+	proc_create_data("allow_dio", S_IRUGO | S_IWUSR, p, &adio_proc_ops,
+			 &sg_allow_dio);
 	proc_create_seq("debug", S_IRUGO, p, &debug_seq_ops);
-	proc_create("def_reserved_size", S_IRUGO | S_IWUSR, p, &dressz_proc_ops);
+	proc_create_data("def_reserved_size", S_IRUGO | S_IWUSR, p,
+			 &dressz_proc_ops, &def_reserved_size);
 	proc_create_single("device_hdr", S_IRUGO, p, sg_proc_seq_show_devhdr);
 	proc_create_seq("devices", S_IRUGO, p, &dev_seq_ops);
 	proc_create_seq("device_strs", S_IRUGO, p, &devstrs_seq_ops);
@@ -2364,11 +2358,6 @@ static int sg_proc_seq_show_int(struct seq_file *s, void *v)
 	return 0;
 }
 
-static int sg_proc_single_open_adio(struct inode *inode, struct file *file)
-{
-	return single_open(file, sg_proc_seq_show_int, &sg_allow_dio);
-}
-
 static ssize_t 
 sg_proc_write_adio(struct file *filp, const char __user *buffer,
 		   size_t count, loff_t *off)
@@ -2385,11 +2374,6 @@ sg_proc_write_adio(struct file *filp, const char __user *buffer,
 	return count;
 }
 
-static int sg_proc_single_open_dressz(struct inode *inode, struct file *file)
-{
-	return single_open(file, sg_proc_seq_show_int, &def_reserved_size);
-}
-
 static ssize_t 
 sg_proc_write_dressz(struct file *filp, const char __user *buffer,
 		     size_t count, loff_t *off)

-- 
2.53.0


