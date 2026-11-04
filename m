Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 204D36092800
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ViWv5liE
Received: by kanga.kvack.org (Postfix)
	id 2EF356B05E3; Wed,  4 Nov 2026 14:50:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7276B05E4; Wed,  4 Nov 2026 14:50:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DDE06B05E9; Wed,  4 Nov 2026 14:50:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F0D806B05E3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:50:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8159B1207FC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:50:23 +0000 (UTC)
X-FDA: 85398478326.23.AB096FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 997BB80008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:50:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ViWv5liE;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gDybWaXH0yVqSHGh6cSao1kY+huQ+XTPXQ1Vld4D+UM=;
	b=harK7t9DQyr2BOTrl1B8e2dglnWxUMfP5mmejkQAMfcQ5suun7F5z0n08/2TQBLVsPesa6
	8JxmwcCnvQJcQSBhtg73C00mToy3MgP9pvItoPAolOm5KaRKLs7kS9CSPYENSXX9306yj1
	xfYUx8iD2zYOIYh8LbNk928REzLvFHM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ViWv5liE;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821821;
	b=oC2My0oKDFksnAVYgV48VTZ07T/2Naf6m4noPLjUvj+1eIlq5Hisgj/NcUUcVqNNE/h+CE
	U3eYlL2Huw7Od5TTzmX/FY/CepCFox6lWOAFqA/h6H/AGyL6zbLP6lfr7e3Xmnpt7f3Ppw
	rt/h9sMCD5RynhKGRNIbZUuC4ldRxhQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B36B60F38;
	Wed,  4 Nov 2026 19:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5EE1F000C1;
	Wed,  4 Nov 2026 19:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821820;
	bh=gDybWaXH0yVqSHGh6cSao1kY+huQ+XTPXQ1Vld4D+UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ViWv5liEfHdMHPO8R1wapbcJqOA3zpGPpbB02hMT5/E0508nWx30DxqIPL6KtEmgU
	 u+pmFn3FsOd19p4MgLsNq//oFD4EhVxfbRb3hFQDajUha4PG308MHKfbBxuQRI2T+1
	 gpfAFci1AHyTvujOOroEbIobGBHWkRbja9thyu+sIlV6GnLkbKj+7KO+0ZAH32xVH8
	 iBv7uhmdL2bAAOXVUHaVgSNDhqWBsAdgXyxjuxMQt4FvbC+ZMkyYx1jsvDEISH0f4o
	 af3/XVxyIwOpd+kA2KJQBzwNtAgTJZ+nIEKqRvJiOre/ZrMnKSk9pNUZKOAQUsYWh4
	 hiwj+uPWiEFJg==
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
Subject: [PATCH RESEND v2 02/30] jfs: let procfs copy in writes to the loglevel file
Date: Wed,  4 Nov 2026 20:50:06 +0100
Message-ID: <20261104-work-procfs-fs-v2-2-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1370; i=brauner@kernel.org; h=from:subject:message-id; bh=izEZyN2ciF2azWBwOiarD7rxdH5SrLb74RUgxhmuQ3M=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97tGJzso6nn/w61mbive7Xqy3zX3zdMnSHJ2eBVw3m Q2DcmIjOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZyciEjw/nFJ7zrmRr3TTvN 7yT61kBSiuve9sV8G24zvhXijXX584zhr/RSZtXdspF7F/LOFVzmc/vt+qo5X9YsanqxkXF3yLP QUzwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 76uctw3beqmsuw1mbhdrpwp5186iyr7a
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 997BB80008
X-HE-Tag: 1793821821-910158
X-HE-Meta: U2FsdGVkX18sfWuolj/FDcufhP0RJ1aVr05btFxmUcF9gVnrNXSS7dTbEM35IGkh3z177WxWPStAgIOM9JKjVnFR2FpLb/I9/72gs33UDB2iY/hWoHOxUTVb2+Z4EV0dI3Uj9ySp2rWbWDtSD6ZllQtWTu0NiCxm45KgOS6ZXCrGSLYlHvUPUbWlawKPLEIvIOfd+hJIg7667cBqzPq1+TrfgIz+gYMkEHZMY8R1QP99U1GISZX7Hunp69U1tF0pnoSGozN8WINAh7Ru2ZSst3SmhvEggO4dCW4yhSpY0wIter6aCLYiRkqKl4x05g3nVdGn38Y3q5Uz8SvPPe4spYSBEKGNUKcvSAAScWZpsbQAFsnQ92XAK4HTBfAg5Ap2Oaq3NLLbDeFIE0REHAJxqtmPCNj6dLom8yMWoXhMQnPAO1qMfRUgTF1+W54tF7avQYad0au7swP+QOcLhio5tdkJUFMuJJ5bAJzIdON72wOiffGMVSrY/UoRP6/Ch2Wip4TyD7U+OtLX30j8y/Uw0orTjKgiwr0q1IEYp6MvYZ6gC3dygfnfqo//Q8gzHKEUrICQQJl42NmPKUo/HjleazlKda1yuLBxWzU5E/hO5ACdcHI8FzCpy63oOrf2lJkWDBnOMvhDKoHL4CboYeXRUxvPm0Rwl4YVQxIe6t3Lkz31LOcHEEfkQUn/6NGCGiPoB9Tm0/DKJmnqzohyxmEZgmmIBpbBJA29V2avv1HuUUyxOLrN5Gvs8ndVfx/BB5M+NDen6WppKKm2qZ2+RqNwvF+TfpZr8waIH/PjR1c9DxBDsQ0EsMlUZy4H0QJGcHFvdp5SOuERLHmgaW6atgm7GDlpL5ACgiUGDs20qFY2tIeEJXK8PSn1ZpPXX9KjBfxod/ztlM7+5qFMcyZR629KB0xqTX7pABGtYyoBsZG5wRCjptfP2H4D1R/R1OTBzFWkQQefq6lcuxlQ6hvz/Cj
 lcCyRekK
 T2Kj8aKrYD4akY4orZ7whqlVLVpRBTVruajUubaNmFaM+V4hwZFDqKSFi0l0Nulg0TSQUji8Sf/X1QBzbEVHJYlnpCueUAz7BAKr/5wjnLJcdynt6xZfowvSHHYN/W/RJ4sjpmut2bEt+QCfyY43Rpmd0LiB5Bj4qFuCnTxvVwuflyhAq1pTxj7VkCxGevNkhvrZs4v6SK28f+M8z0B+q1A2jqCbRDfs5TY0JlfuD/zsJHczC6k2mOmLIXni7Vih1OsUKtsdPZYiVHULO+M8ba0KjBfB/eVGQRsZI8G7rSvCp2SaV/7C91tr9qz2sB6BHjCxGkqzNuxLQLLG0XpjscYMjEsDCbohBMZ6XPb6o20q/N67GDl370vOa9cR0WMB8OuWRNTMTQSXRo5y73pl7uu4uEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and take the level from that copy. Writes larger than
PAGE_SIZE - 1 bytes fail with -EINVAL now and so do empty writes, which
looked at a byte that wasn't written before.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/jfs/jfs_debug.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/jfs/jfs_debug.c b/fs/jfs/jfs_debug.c
index 5eb35b0d420f..e1c0211a6a32 100644
--- a/fs/jfs/jfs_debug.c
+++ b/fs/jfs/jfs_debug.c
@@ -23,13 +23,10 @@ static int jfs_loglevel_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static ssize_t jfs_loglevel_proc_write(struct file *file,
-		const char __user *buffer, size_t count, loff_t *ppos)
+static ssize_t jfs_loglevel_proc_write(struct file *file, char *buffer,
+		size_t count, loff_t *ppos)
 {
-	char c;
-
-	if (get_user(c, buffer))
-		return -EFAULT;
+	char c = buffer[0];
 
 	/* yes, I know this is an ASCIIism.  --hch */
 	if (c < '0' || c > '9')
@@ -40,7 +37,7 @@ static ssize_t jfs_loglevel_proc_write(struct file *file,
 
 static const struct proc_ops jfs_loglevel_proc_ops = {
 	.proc_show	= jfs_loglevel_proc_show,
-	.proc_write	= jfs_loglevel_proc_write,
+	.proc_write_buf	= jfs_loglevel_proc_write,
 };
 #endif
 

-- 
2.53.0


