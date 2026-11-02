Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB37E6093F75
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QHFOrs5T
Received: by kanga.kvack.org (Postfix)
	id 096F56B0603; Mon,  2 Nov 2026 10:14:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04F9D6B0604; Mon,  2 Nov 2026 10:14:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78576B0605; Mon,  2 Nov 2026 10:14:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A555C6B0603
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:14:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 31BE01A014D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:14:38 +0000 (UTC)
X-FDA: 85390525836.19.5FAF419
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7063320008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:14:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QHFOrs5T;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ClNRz/kRlLxFCzx32+9FVAcbIhgPE+GVqUynSQSCrm4=;
	b=Kkynze9sckqsHzHBPyno5ESOp/dio8OFWGqMmMKN8TYRHsDSGUklHrlWfAPGcfhozKbxVk
	gqgxvNRqxKdOylwYrRq6s8rOJca5OHNyN0mfhQKXJF+FFh0zZru5+WTwJMPh0OGvLf2Pyp
	2CBUquwnj3dMr8U71Y6bXxRZb+E2JNo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632476;
	b=IKjBLo1kFlF4XzIlUfzTDo+sPZjmeUyfKsEtixGFefEw0Z06AvU+Brg+Eag6e8lIb/afbD
	aRFpeM6ZTXPP3sugTedwooAVZSAcmkTAlYHIeCuJBWwhmfIAjF2n8hKL0e5FxGgL6wkWpy
	HyneL1jqCSw07nYIhJwDwUupZ6snPQU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QHFOrs5T;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D82A60627;
	Mon,  2 Nov 2026 15:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51E61F00A17;
	Mon,  2 Nov 2026 15:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632475;
	bh=ClNRz/kRlLxFCzx32+9FVAcbIhgPE+GVqUynSQSCrm4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QHFOrs5TpHpo0M5R/FfZ1ou8JGe4vsZ6cA/Hi393fx1BxX5IT5o4flelNXsYEXbE9
	 vynnBOwvEgghDbKEFxBD372pa+SwW8x0NGdMYbCse3kzzNveXnPAdVohl8yxS5NJs4
	 3excMQXr6T5ACjipWAjM243eKSbSoi6d16BYCMEK6QVhsklDRevfPXj3KIgQmn5uPJ
	 LZb4wVnkhoqe1laPMLMGYfVrzfbSiC1JXQPw3VBhRO6fCYMUcXexMRS4g13lbVrz81
	 DepT7s422YBCQXEEEk7d+FgsSC3stLOiMHy9D0lHpcwxe4kj0+zJyTLCnY18Ca9szE
	 Xhc9IT8ucAXuw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:20 +0100
Subject: [PATCH RFC 13/23] scsi: sg: let procfs copy in writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-13-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2854; i=brauner@kernel.org;
 h=from:subject:message-id; bh=JvNn9BiAujB73ykVLFuVWE/fT8/HBZYijRncXc4d9K0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG7QvpbRg3P21cqJ8ja/jDbycj3eZxhYsFFhyvyCU
 9Jr5m792VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRezmMDGdFpl5cZz2xV6VK
 67ro+4sRqiHvTXWiV/ytnnPXy7w9S4mR4UuS786S182/LwXZn3kWWap7OH/GKcMfobE/OF7euZe
 9ihEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7063320008
X-Stat-Signature: pp61i735z6r4e57n74a9tgyzp3bia4fc
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793632476-463757
X-HE-Meta: U2FsdGVkX19k9M7PqJADdxkgOrcZNk5pDnGPc3TCKS91gq/9Yz5pqquLiHmwGIXLo1FJkDxvWMRBG79jYzrCiSaqDXEKuwgf+Fg+5EHZemiAGrUc8ff5M8clkLoGUjN62K/qAuKXHSsDSxvnM+dySJAXFZNWXbACHmnU2MjYPONoRdlEB0ii6p1bMWYHuuti776aitXp3gJWBC6DY5+WUXK+bEaxu0IlpSIeP447aYhphTglzdcxmlVSuAPbLn3QNg+3hT1XhPIj65lpuiBzhL1Cxt019I0NYtTD9MrFarHdohdf3k0KVztfVNOqp8m2qeqpqq4ITkBqMRgIdGng2k0iBTn+utWMKxNM+lk7Kxo01DFfNPaiieR+jsBuioMv6JWY76rQ2TTUF7+CBSzR8MvxaNuPS6EN1kAgzyHowtsfMFHw02rYuGxeOyJCJ4iEWWKWcZib9Czxv4K7Rk5FONJjZM2wlkB8IMN4YOJ8MaW0anZWC606AmuLXlkVgtae9HcG/dDjr774Pmwlmizl4NmbpsG1qfV5g5FSE/a8gxZSeiG+BZ8DkFdxNv7E4VYExIcLGUcdnXaqzE53buHLgpdHBnodbqmFblrclRAhPqzZ+uC8hnHzw5+pnLVfc78TH97LKQrXUvAEDQqQFuyQmN8txFTlFts5O3rspW6cbGWLxpcrgdrnw3b1ieo4FP2thXurwwAMWoZ2tFlEJCVA7CYZVB7QrsMxtRTrpvrtk+NM0QfLVo8IoBSIAKGI9zxVeq0NrA+D60BibPiPU2Z+NvkqjBk4lKmR7b8HptK7SdnIlmIjkzBGrikUU3Mr6ctbE3j1VTVGOCRViz0sHVEcgiPrm7wmrmYJvcwRyNfh4lwxt9I93hatriRnT/wPOKuixDn4ZZnkFpSrGrVYG/e6dvoe0W2Hlw6KYF9SXfVEAnWyrdd2Ej2JB980RRUWkuJT8adu/GEE8pk1Uz1z9vc
 PD5vyDLC
 BDJGf9dXYokBGjRjSrun6orYRcZYYnPucHZMYioGdala9+w8CeAFdZUZOrX9SXufM1doYrqpqDTW22nmfwOCNY9jKGpwjatpH+XX970ZakdRLyfKZFILaxOv/BB3S3Wxpe2H9CrkPLnWFzJwjU4JcgDJaf1XjmhqbM9VPOMfkAYzZyLosaXki2K+n9bIYA5LFr19tSNrRnliG0NQ8DuktzjnLrGnFAYs7I+MukFM2wSGubeJSGG6siJUV946vo8Pj2QQPiepyIoId5BOH3n/Hnt7NZrWkdDWNBFhc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() for allow_dio and def_reserved_size so
procfs copies in what is written before it pins the entry, and parse
the number from that copy.

kstrtoul_from_user() looked at the first 66 bytes of whatever was
written. Now the whole write is parsed, and anything larger than
PAGE_SIZE - 1 bytes fails with -EINVAL from procfs before the
capability check.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/scsi/sg.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c7386fbe5580..87569e302f26 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2287,18 +2287,18 @@ sg_get_dev(int dev)
 #ifdef CONFIG_SCSI_PROC_FS
 static int sg_proc_seq_show_int(struct seq_file *s, void *v);
 
-static ssize_t sg_proc_write_adio(struct file *filp, const char __user *buffer,
+static ssize_t sg_proc_write_adio(struct file *filp, char *buffer,
 			          size_t count, loff_t *off);
 static const struct proc_ops adio_proc_ops = {
 	.proc_show	= sg_proc_seq_show_int,
-	.proc_write	= sg_proc_write_adio,
+	.proc_write_buf	= sg_proc_write_adio,
 };
 
 static ssize_t sg_proc_write_dressz(struct file *filp, 
-		const char __user *buffer, size_t count, loff_t *off);
+		char *buffer, size_t count, loff_t *off);
 static const struct proc_ops dressz_proc_ops = {
 	.proc_show	= sg_proc_seq_show_int,
-	.proc_write	= sg_proc_write_dressz,
+	.proc_write_buf	= sg_proc_write_dressz,
 };
 
 static int sg_proc_seq_show_version(struct seq_file *s, void *v);
@@ -2359,7 +2359,7 @@ static int sg_proc_seq_show_int(struct seq_file *s, void *v)
 }
 
 static ssize_t 
-sg_proc_write_adio(struct file *filp, const char __user *buffer,
+sg_proc_write_adio(struct file *filp, char *buffer,
 		   size_t count, loff_t *off)
 {
 	int err;
@@ -2367,7 +2367,7 @@ sg_proc_write_adio(struct file *filp, const char __user *buffer,
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
-	err = kstrtoul_from_user(buffer, count, 0, &num);
+	err = kstrtoul(buffer, 0, &num);
 	if (err)
 		return err;
 	sg_allow_dio = num ? 1 : 0;
@@ -2375,7 +2375,7 @@ sg_proc_write_adio(struct file *filp, const char __user *buffer,
 }
 
 static ssize_t 
-sg_proc_write_dressz(struct file *filp, const char __user *buffer,
+sg_proc_write_dressz(struct file *filp, char *buffer,
 		     size_t count, loff_t *off)
 {
 	int err;
@@ -2384,7 +2384,7 @@ sg_proc_write_dressz(struct file *filp, const char __user *buffer,
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
 
-	err = kstrtoul_from_user(buffer, count, 0, &k);
+	err = kstrtoul(buffer, 0, &k);
 	if (err)
 		return err;
 	if (k <= 1048576) {	/* limit "big buff" to 1 MB */

-- 
2.53.0


