Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65053606ABB9
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g5jXfmAk
Received: by kanga.kvack.org (Postfix)
	id 89E126B05D2; Mon,  2 Nov 2026 10:06:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8753B6B05D3; Mon,  2 Nov 2026 10:06:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B3446B05D4; Mon,  2 Nov 2026 10:06:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BEF66B05D2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:06:42 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E674E160176
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:06:41 +0000 (UTC)
X-FDA: 85390505802.12.48E4961
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 381A480009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:06:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g5jXfmAk;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0DFho69O6i+rlC573E8+GaY0MO1KK9pTFWx3bkx1uo=;
	b=tgQXtGDsAsF0Ihb2u9nhpuY1G4d0eSpxrhb8kmJ6ZJO2vsnEp3P3G5aD2OWL6FeB1qFRGc
	VfXa7QIhN2NEy9A9vk5vq3du+yZCLxIsWAqt3OheUM+IrLGx6d8yLWx8cKECc/c6K6mgrD
	6vOcdnTwJqScd7AHXEFIJ4Rga475v1o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g5jXfmAk;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632000;
	b=Al7QZNVvNbQ1j8TUwVyAesqQIBZ0PO05Baq4WmpcfQR8qi1lLeeblTpQmNmkwwa497vhi2
	U5zrmAbXtDlFN6SNm3UGNa0cddeID4dgJ97YNxe/aLY+keGuzwKhwosw8dchRVTZ0BVXUT
	GnmEVEaojvxkxd0kN18b4y37bx9bELI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 175FF6012A;
	Mon,  2 Nov 2026 15:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9F61F00A18;
	Mon,  2 Nov 2026 15:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631997;
	bh=D0DFho69O6i+rlC573E8+GaY0MO1KK9pTFWx3bkx1uo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=g5jXfmAkkpbVCcZt3JDC6TsuxQAsfUSbPkDCW7uGVgAQzBE/zvcO7qIvScymWJQ1K
	 n8VazwD2M6Wv79JGlT69a8nmYNWac2kVIU0U/zNaRABKDdAMHpHFgYNA7PEr0PWLeq
	 AebGp1CYYILUE3HH0K8Y/R8JSuxQScRPfh8nZYzeZx50h2vf5qPHNhypeg7PD0iwQv
	 2+ikdTJsIqiI2yCYwee54jqzaLiVLYJuCtuzzPKkyLzadUHizvSp/DBA0MNt56rv5I
	 6IBbiNCpEUyFyP/cack1HnEo1QC0pmP0eyaIxCT6k4iIzuTLNpD4qjm+qx0GtucpmL
	 2tYUkabqdbO9Q==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:42 +0100
Subject: [PATCH RFC 15/22] xtensa: simdisk: let procfs copy in writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-15-c9492ab08480@kernel.org>
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
X-Rspamd-Queue-Id: 381A480009
X-Stat-Signature: hw7ycr3cnej6phmfxi79h1djidsdzq5p
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793632000-792240
X-HE-Meta: U2FsdGVkX1//elRt7pEEHk7oXtyCxMnUFxuO+5pqcl2px6GRlKpNxwfUXs0R8d0L2pPsc/q4KGfAJpBd3TT2zCLffDAJvFFHLw28NlSQLz3LufeK5vmAi7HGMq/BJK+uexmUV6cwcf91QLEwHfhzMCF0E3aK8LXhEN7g5wnwsJ4JoH6oKlRRXcSgrNs7nLSaXoAenISzkVM8J9ckzx8f4ekex+88ptzcHBH/kUtpK4H9mqZdMSxTrW1wHLfpqq12N8CPvwuy797fFI7BYARka144DNgOVcf4HTjTzI/WdxWmwmigptS8iNiea1Igqh6PNSfSIUbuZZu7qq2/ayz5J83bSMjU3aStUR2xMdn07bY9V40gKqPv1nbyJEXvyDzD3YvuM3h1NhXDYsbAcwkyX1CbavAesmskTTQM+ifaveBguA9r58Y/+CtIYI1pXpPX3Pw8JsvZbULkP42UIk5WDb7SwKC37ZLfBVsFAy0uq0n6wwuBD/5xmMO8pFmm3Ov4yURtBuw1mZWjVBlGEk612yK2O5TvIKw9ioMeL4ewUL8EvQzohQUTzFPBqGvW8nhyKAfUodqmrOYWXzGtJ+GUtYYGaxYG+qtZqye90cacPDlogjwRF8BN96hMAaQIAbD3I8cbn78KJyQo69d1zn1Uj99wwrzZAy8yf8OWp0LLiZAgW5p3u9nvY56zo2+Oi677RiY4S+RV/PhtbtWGIR6bOF3dN843udMVdxpbB1cPuHO709JYC+twcMZHGgO+kScbXcWofKpLw2oO9JK6feyXOFsrka/65G6yqxDwDPeAnpLlnM2I7IIFn+EgP76g7pGnetasUWlU1XW+ZCV/Wf6zSLjH25tXX4QSbsdU5vT6teJr7OC3m50WwQtKpCcXgrXssk6YaEcGg/j+XYqTXmbRgsgzqII+ytNuH314HtHLS4GLsGO1gE/Ly5FmK30DrBOXQLLaOWqD359FmUdb/t2
 eY/sYRkF
 cMzEFE/prhLy/C2a8dYH5j8RCKjnxlYvxMt4hpRDMD1iPfoKX5hsECCcbGyF/sYGTCOmaZYvCBpmJBJ3AuoIX3i5LUT/y0fXU66ejKO3Mx/tR9VxIcvvompt/RYYLyXIt353e4vVDzeoeD3b83+0hcCm6ieWj/hOMUY7NC4pp1sEO5c6UDUvXBAoVEGRW8S3Uu8t7tNA2tIFXzXl8wwYioKAImzlI+CLigUnxrYVWdACPmr2xBQlRf58YPMG9EvV1pnjF3oyt2etoJmk190JWtRDqxHmnsQ1A4CGB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written to the
simdisk files before it pins the entry, and take the file name from
that copy. The files took up to PAGE_SIZE bytes and keep doing that
through ->proc_write_size.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/xtensa/platforms/iss/simdisk.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index 7b115e023de9..b2f9e7f3ade3 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -241,7 +241,7 @@ static ssize_t proc_read_simdisk(struct file *file, char __user *buf,
 	ssize_t len;
 	char *temp;
 
-	/* a write sets at most a page, see proc_write_simdisk() */
+	/* a write sets at most a page, see simdisk_proc_ops */
 	temp = kmalloc(PAGE_SIZE + 2, GFP_KERNEL);
 	if (!temp)
 		return -ENOMEM;
@@ -255,40 +255,34 @@ static ssize_t proc_read_simdisk(struct file *file, char __user *buf,
 	return len;
 }
 
-static ssize_t proc_write_simdisk(struct file *file, const char __user *buf,
+static ssize_t proc_write_simdisk(struct file *file, char *buf,
 			size_t count, loff_t *ppos)
 {
-	char *tmp;
 	struct simdisk *dev = pde_data(file_inode(file));
 	int err;
 
-	if (count == 0 || count > PAGE_SIZE)
+	if (count == 0)
 		return -EINVAL;
 
-	tmp = memdup_user_nul(buf, count);
-	if (IS_ERR(tmp))
-		return PTR_ERR(tmp);
-
 	err = simdisk_detach(dev);
 	if (err != 0)
-		goto out_free;
+		return err;
 
-	if (count > 0 && tmp[count - 1] == '\n')
-		tmp[count - 1] = 0;
+	if (count > 0 && buf[count - 1] == '\n')
+		buf[count - 1] = 0;
 
-	if (tmp[0])
-		err = simdisk_attach(dev, tmp);
+	if (buf[0])
+		err = simdisk_attach(dev, buf);
 
 	if (err == 0)
 		err = count;
-out_free:
-	kfree(tmp);
 	return err;
 }
 
 static const struct proc_ops simdisk_proc_ops = {
 	.proc_read	= proc_read_simdisk,
-	.proc_write	= proc_write_simdisk,
+	.proc_write_buf	= proc_write_simdisk,
+	.proc_write_size = PAGE_SIZE,
 	.proc_lseek	= default_llseek,
 };
 

-- 
2.53.0


