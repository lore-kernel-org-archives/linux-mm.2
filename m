Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07E4360A34F5
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HAfEog47
Received: by kanga.kvack.org (Postfix)
	id 23F396B05CB; Mon,  2 Nov 2026 09:51:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF586B05CC; Mon,  2 Nov 2026 09:51:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DF806B05CD; Mon,  2 Nov 2026 09:51:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFDE56B05CB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:51:03 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8EA2A1A012F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:51:03 +0000 (UTC)
X-FDA: 85390466406.18.09946B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id F3FDC80009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:51:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HAfEog47;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNga88T+PVpZfmycjurDSPkD9sK5xR0SX7kfbe+Tx54=;
	b=eKeQBL4yHWnsB2bI9f6ZBrLmNZnDZY/Pmy0pZ9bIRgllNjcDO2oU+TAjDpROfoEmUPn2Cq
	SAzPC6Aizy0Uq817M0gA0lYOIjOcPQ2ZoMu4ePCv2uLhzXPNFCvYnTk6H0Ll8Xne64ZX43
	JX+F2+OluLyaOeg0sMsbfMbv7azH8P8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HAfEog47;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631062;
	b=JoBsXr7fiCN8sUpmAtkiFtI0PtzCYCoX+TRz2KDiOFIhq+NRGmQXuLeW/rNxZrFjISRUgc
	6W3ElHiGG1NHn14Z5tQukedrTiCanzNlZcy5JRo7IxErUztrlQXls4fWUEOVYw4yYEZemI
	oaDvEv4s/QqBxSALlfGzJJSXNSvue3w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7725E6025A;
	Mon,  2 Nov 2026 14:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0841F00A20;
	Mon,  2 Nov 2026 14:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631061;
	bh=iNga88T+PVpZfmycjurDSPkD9sK5xR0SX7kfbe+Tx54=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HAfEog47xda8zTdFMvaAY8UduaibQbmV5xxRBJ0191OlQqt2XydHGZFtrSXUNbS58
	 AFtT00ZqBbfVJ/H/XjgGtIZDGDle82Pa+tLqZ8FQyxzXDykVFW4+gDpHKY+tRzFlIw
	 YK6e8OsM0kDvZDoN8nl4W7r6Syhu+TVQ07b4x+H0xeJkJuUzcBSQBDtmTErPW6xGGD
	 OXD3SZC4tYwy0PvCMkPLOtkiB76JNpNZOV81oGLnAyA/hYKEjzUYYgs5lsCvafcDSS
	 XOjHy+nXg5pWeHaWMYPWeuKt5azway4LiOnI7RzIv1EzsUvbR06rvuDChMCv/TCU6X
	 LHOWdM7kjMyMQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:48:46 +0100
Subject: [PATCH RFC 06/16] proc: let procfs own the seq_file of
 DEFINE_PROC_SHOW_ATTRIBUTE() files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-core-v1-6-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
In-Reply-To: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
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
X-Rspamd-Queue-Id: F3FDC80009
X-Stat-Signature: 7twdcj5anjtgnfask9x7diqiwmzm6syw
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793631061-804145
X-HE-Meta: U2FsdGVkX1/OaNjnU8Ip8cLCk/DZ3yyM15K7sc54ep3DsU6fvyGAm2KfTBOy+bbec9pWIsZAPCcUOhqr38s/SwU1MNkF8XNjyZvDnRu0IvsEQzFK9od3NpeoG67cLHUR4sKxfRApeSQl7tPQKlsqT0fJd97mFeX69GgEccCL6PG3JzlUw0XVuHwXHriRJM1fwCzMfDIoNTC5XQyk5HBrblTeIiW1IKQRzpzTUDIzSzKdUWZz3S1ZNpDp016jkC6Ircixn83FaQ5kDUwA5bFSwd5zO7IVqnInT1cNuIhBpnTT9zgDAoFjGlbKo0YJrXLT6UJoSefmNP/cZUsNZ0Gk4qBpo4uCjPAjGra0KD7IpOV6yOcT/gOd/OQHjpQxb/NFGEcridlTsBNUNbokdayECfFZ3Evhvww3qLnZxFw4XJw/LbiWMojAYzKKSQLblmOiNCsxTGXjLPNs1AKiHUBmNN4rvajzYl8Oj4T9bX67zjuFkADOwUgHAHT+jOrfl3+BnWk+kOdjNJ1GVqDNi68HlHCVsSVlA0E87yqKGcgvQW+Qhb9iGf12+Bw6ho2Z/ZKVfv55RWDObmLLxrKNdArpZatYIQLCxgc7wJnwxaejdtTNp/epEBow9OB3xKJIqtIUbLprR4+e37WD1tAavkYdD9wy/k+BobQJhUzSjB3dzXJo5PJ833BgoDVzAaj+/vqHFHR6k6gEMXowOxvOoMvIx06B8Zq6WFheZBdNdla5esJcZtC7mpm6N5+bw+3KSvIqMrcgPJ4qChd6tVC+Qg5U/pONM60o7J9MCZlTuyu+bU7+2Qr01JzxxwZ8/rJjQ6nxw43EmFPLI+dEFiebT8bUr0P/0e8LyjpQlyalnFxvQ7l/nj2t3XU1ajFpTa1rSdJeqTx1SzvQfB9QttJASOjHBuIFnFwvyVBOxH6bxZUIY5LlYnoYWliFyQv0WFUu7FpCcXPPO0ebLYDbGGqTrvB
 MNN7V+gC
 ZChCeX+EdGw6COR01WP95aJxurppmIsZpIOp0XXD52XcjhdkvEMJ07Ycxc5yaamZB8TpBFIqixu0bEqlP38xkWXeNul/orRAD96qbZGsquSI54ToR7lx2ntYeGG5oi+Hbl6Nrynz5jYIBkTlH0CcouyFT/4DT+Ph+f2oK24E+xoQCZpSJ/8ojukuf/SX+RI7FPvg0bgdz1S9qe2wapCtHvmbDCmk8fAoTp4DMLaVg0MYZQ0CfQBtD41EDaGA8+jZ9CBCEORczFDBRCX0U1D9pSRxfGOVQL8HvWMuomw7ryIXc5qnxoRqXDibwIrHj/OeiN+C2ybTZzlXXbUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the show function and let procfs open the seq_file.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/seq_file.h | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index dc0e8c62d9e0..b813b7e63d89 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -233,16 +233,8 @@ static const struct file_operations __name ## _fops = {			\
 }
 
 #define DEFINE_PROC_SHOW_ATTRIBUTE(__name)				\
-static int __name ## _open(struct inode *inode, struct file *file)	\
-{									\
-	return single_open(file, __name ## _show, pde_data(inode));	\
-}									\
-									\
 static const struct proc_ops __name ## _proc_ops = {			\
-	.proc_open	= __name ## _open,				\
-	.proc_read	= seq_read,					\
-	.proc_lseek	= seq_lseek,					\
-	.proc_release	= single_release,				\
+	.proc_show	= __name ## _show,				\
 }
 
 static inline struct user_namespace *seq_user_ns(struct seq_file *seq)

-- 
2.53.0


