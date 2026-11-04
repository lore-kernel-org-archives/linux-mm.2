Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C02676073D3F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fNbNglso
Received: by kanga.kvack.org (Postfix)
	id CA9586B05D8; Wed,  4 Nov 2026 14:44:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C809A6B05DA; Wed,  4 Nov 2026 14:44:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B97C26B05DC; Wed,  4 Nov 2026 14:44:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B8A46B05D8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:44:57 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3EB211A0865
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:44:57 +0000 (UTC)
X-FDA: 85398464634.17.FD71C15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 717C2100005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:44:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fNbNglso;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821495;
	b=VwIqg+0KAk46KTyZW3RwBojOV+KqErhcFyLTOcVT/blrU6XIx3yf4+VHrAs9AhE6fPVI+L
	FLuUJGmDlhpv2SQk7N59Hi5seQOowKHjFN1ILD0kg3m0EGW/eYH2IDtVVYaio6WtsAS71s
	fcy9iTQ1LEb2dj02mwBtkkbM8wijQ2c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fNbNglso;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWMrcMxphM3j3KhJxvOCR+KbGizC6kQdxxuLzJskxVk=;
	b=imOOgqE4QpH4jz0VZXQ2vYYNcXdtUeVeLHxNpSllQkgkJO88pF/gcQk6mm38nCXu/78XC0
	g+BtDxAIgYLCl7ZJo6m54JywH3ioNz1zSRzAh1mRBbh0v+UF+arZsvptfCbLpdIULb13zS
	uRhe6NXWHJQdh69J4XPEOwPTUpnGYKU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A555E43884;
	Wed,  4 Nov 2026 19:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7662A1F00919;
	Wed,  4 Nov 2026 19:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821494;
	bh=BWMrcMxphM3j3KhJxvOCR+KbGizC6kQdxxuLzJskxVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNbNglsoaWY3MivB4Krb9ygur7tWm8mUs0cHqsxMJlnZL4hmvUj4NpZPpgqhoir+9
	 r6P5HeFpIBHXJbSEB1+ztv1etbY3xwg/WTpoGehsLz8jmkAj1RB2DsjnvTrPDDAQR1
	 sJxSC21gvDIE7uTnl/T371mLEerBpkg/OZ92Zb/0+EEpN1sW+zMoMBLVEVPXdcExqD
	 GqdrJq5fzzTLTFc7aowd/VBqLgscxEBi2alM3GjBK6H0BCw6YwXohUUphzup2egq9W
	 Pmz19wJ6NZuK6lPrdMcy2P/XXD4nxOm/SXvk5581ENxcjbB9FyVMTHMEjr9pYUVAlp
	 GcZdUK6ukGA+w==
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
Subject: [PATCH RESEND v2 10/26] scsi: let procfs own the seq_file of the host files
Date: Wed,  4 Nov 2026 20:44:40 +0100
Message-ID: <20261104-work-procfs-drivers-v2-10-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1394; i=brauner@kernel.org; h=from:subject:message-id; bh=l1PqfsIz+cqTipGWNtI2ZFkSTs3hYfw6G0B1mtmwjUo=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97qqfsY95+37HSwsWhLI3/eIN/LJB4/DUJtffcYbse 4MOv6/v6ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiInzojw0dt25WLcirjIi9n xDf8Nz3LU+uhej0insNI9taHalfRDQz/0+/+X7Hnzkupq83x31NuGk1YKW9296S/iazikQuTstu 7+AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yi39rh1czdi3f4fa7ywt4bozszjttukf
X-Rspamd-Queue-Id: 717C2100005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793821495-736563
X-HE-Meta: U2FsdGVkX1/x9Mi2b550KHwqy+IdeB3u1aNFhMPA0V+KXY2eUzQrlM2/OxnR2hC5f2IdKUQ7Ag7wkiuGOWYR5pTlBYqcMpCIpOQcsfM0ceACqqg8yTxupN2RkYXhTNC2EZJf/Uh+vmHaAg6VOzxTSJZ6vYBaraTM31l+HyorbY5G/UUQDFJNkGc9BORWKwIPIb1p8Fz1jzlzsa/tH9kriVtZhlQjPTsA5/fHFZ2AJuX5riVvFlgDqMoxA1FMEG2Xz8o58Qgqq5iokq9r8gHzFHwphXdOEEm5hP4uMyP+4iAdE0C/lTbUU0jPQas6/4W4tgIXZgc2lqRGpiDsBvUtMpVuAvrwit/85Jja9dObhX0/KHIrXT/MeD4SJRIRksWEMEz4e5ScRjRMtiQ7qH6GUw9XTJ62aWq3JT/PzH3c+cVV42qBI/A3BeLlAfajZ7VKwmtI8of3x05oGCUtKp5kYo15pV2JmAR0Psuu7OCdb8lWYcGj/CSh3V2rx9SLEv38TG0ksy2Ddin/a2IE34+YMdfvN/5T9EgYi/UZMDZ4ptbqaH1JDchSUSFh0NkTslaJx/anPAx7/0xqcYIKbcVcN9RvOxk8k03VzVRHfv3q1fAyIEZmvrrjw4maDATbb2hvFQ/sSV+pmGxUuwklol0mYkYqWPJpiG3L4te5R0kSgWbphWBNNyJaR21IiX9idManNG4Z8L+UsBhBekM4upoLxwPeLa0WiodimbTGdf0irAWeVS2yqGYnHC78by4EktR4xAKOPWvj/RxFR64bQgUJo3w2Qc1OXDksn4h6b+EoQ8nWZ/pb6spHoosDe+WTIqpS+kh69e6lR61D9RRcmDHxyqxWl+iGfQMzS+iB+HBlchzAMuNzZBlgnaHNh8Mto/NdQhYlPFiPW5HACk8xSagcXUeXkm0zSxaKQn74ksau4wJ+LwkFoh9mV4dCWhFqLQAQZzlIbplGauoiyFXYIcY
 Icg08Ij0
 r4MIqFa4uIVMKwKzdqjPH1y670ToWSLpB3jft9I3FzNiMQR3UHfW1TY6xnVhElVq4dA2lNSBN4vejJxupwmsBtYB/2s2hCkijvMF//yIguqtc1VgRJqPZBAUsOT1ld4eJlqo01Iko1DjQJn0Spo3PXFxaT60+mxMoUQP3fIg+Ls18psy88+9D861VfsDo1PfTI089pUKiFMPPmvD97ne/yKiehzMifDdKYDlUDr2ZyyLdIPd5R9Xm8hJMv8BquxDVPDCzsQRhzBzZgQ4QS+v6pdEPC8QjhMdyscPxzrQFuHkxkfXJwOkTV0bhDIw0PLlVPGUTxTYSoDIaXf4w3nqlcbRF02GpcyLf+5Ui6KLQtZ7mB2B9eu/UxKcMtZOQzN+cUCidvoI2/dtQydWXEZ8HNIOC7WBjBDAHHeTpbNFibFYdeQu+BzcrzDWIfm3Bov0IuxVi
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


