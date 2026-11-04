Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2264607E917
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dEYUfVLB
Received: by kanga.kvack.org (Postfix)
	id C285E6B05EA; Wed,  4 Nov 2026 14:38:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD8176B05EB; Wed,  4 Nov 2026 14:38:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA3AC6B05EC; Wed,  4 Nov 2026 14:38:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8794D6B05EA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:38:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2961F1A0854
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:38:22 +0000 (UTC)
X-FDA: 85398448044.14.C3FE531
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 62419180010
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:38:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dEYUfVLB;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=moTp49XZfW2IxIkO6/t4/a2jJtvDF10yNUa6q6hnE3E=;
	b=hvnnX/Hd7HmJgqkx5H9Ci9iWjvUpk+Gnmm1gcH0kqCvYqIpRyvZXARrxK9p9wF+99w0U9D
	rrY/9b7xjf23XYh/5XQ8gqnFthZRsg0jTcH+amfU5hUB0vnJpBl591PFjiBLMmZvTkaZpC
	+JC2xcunNh+VjddvCxHmp6jhaeTkOrs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821100;
	b=vSq6v9wjpHHutwAmcqyLSSjGaKM87lRoYHrZZz/0dfrDMhkZkyWRZYk9pqPBhtw72mif2r
	tMaXmRg3nzq1IjJD9wQj7vRU8nr7yWdx8PDuFnsXZUlg+yaNVsLIiCEtexy9wSZz4EV0yY
	ubc7MplgIdij8CoeKGTdFJebTSpudvU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dEYUfVLB;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB3DC60D9D;
	Wed,  4 Nov 2026 19:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655801F00919;
	Wed,  4 Nov 2026 19:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821099;
	bh=moTp49XZfW2IxIkO6/t4/a2jJtvDF10yNUa6q6hnE3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dEYUfVLBA2EwlpohdyDXzTpTkRMJNpEZw07PenB3nQEME5dlyhNXhUUoG8mOjVcfv
	 oPDIsebnx4tZSNv75ByRLEUZV0ZfOVLMGkLYWrqFTsxkA4voQYbiWI7Chp/G19hq8j
	 DKzQFd+kG9Z/ZczXaQksi6FimDULy8ynh1v+zV87qzzRKlJkR46N6iuYi3HyauJb0/
	 ixnpXSjhwjAMxt3EXBGirkIdHW2TupS7i0FdK5IMsq4hJkLRXlD9MCqRth25zPpRvr
	 XFXCckKRVb1cNliO2C/VaesIJ4kkrjLqwN3PZvlgzr9t7ORqmcl1O6UD3IPPtWLnEr
	 6EHLI6lqSf6WA==
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
Subject: [PATCH RESEND v2 10/23] sh: alignment: let procfs copy in writes
Date: Wed,  4 Nov 2026 20:38:05 +0100
Message-ID: <20261104-work-procfs-arch-v2-10-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1293; i=brauner@kernel.org; h=from:subject:message-id; bh=pcWTmpkZi08Bh4Hys88761LsQ4siFbSCZrSZZozxPfE=; b=kA0DAAoWkcYbwGV43KIByyZiAGrriPihaE1Ps2uzOVufjFEo6SEyunTx1SnW2Cza+IFLmTCnS Ih1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmrriPgACgkQkcYbwGV43KIBxwEA3vYT I915GRHPWFgUXtRSl6XArUTI58ux3r8jCqihWjgA/RPKZfjZEripcr0Hh6B3Oon/z2/aODYAora Qp9As5NML
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: rj5qbqifruj3qdkhmd9skn6nxrmjmqt3
X-Rspamd-Queue-Id: 62419180010
X-Rspam-User: 
X-HE-Tag: 1793821100-874828
X-HE-Meta: U2FsdGVkX18mx7T3kgAVdHXaRzh+hXTAnktVVtBJSNmexdqBb9EJfoOCSvY9qWDLD7EnWruSqf7O5XmTazlfPcN+T1zwgbadTwEpymV/XyzZHGz6Vpc6WkCFWlaUxPqwPmFYaD10x7xQReuqVuOQYImRaHggktGyBTGgpYr9XgsdamAeiVVmbijh4pngLcJ9GiNvv5PV0KtCmg0VwHKLkk6gEAvLAZE9qjTsopYqaBcv1BuM65Vd4OWysgATdsYrBG1a/cp2u81KIb8ch9VFJYKc6v4FhYILFWSxgWJj3vWTUep0HHeN+/VaAjUMp/CIobyHC/oUjMTBylxRs+Hw9MD5Cm6/2Umz/vo+5TpA4z2oK4Y9H9b7cPr4LOCNVtSQKAKXwrfJiyOrfwOh7y7L2kbFSQrVzQn0Se+Q7GvPP1V8zVWruXWtvInQ8q7+V2dcB3Eqn2l2nDf1hqNiNGrz7HwO0G72eXIItgjMCeqQNoeV95NgKr9uZXp0XsPHPJPthgxdI8Iy1c8ghosp5sXDFv19+25/v1uPGJstprGWwDfoHTvmgCQ6PiWOq5exKb53aDdhMFmfe1+A7Yff3vtA+wl+pwn1jDKG5aUcG69Kdu0tysbSoDLlJWBn/qYThCeveIxHPviWEtTtFrawBDzTZQwS+w2l1g4KxQn5aTV1V8pnC9FbwWFXvonu5M65qQaEEXfFpJXvmGQpKjQpd3+y85/UgvJBy7CV+mhFIZb9i5+IqNFGqdTkJazVushR4ilO0Ou1yqJA1YE66L7tqKeuWE+vg+SuctXAUHttN/OwVI0YVoFqt3CuNiDrgugzL5qcIt39VMrJ+omVpveNDp6dF9aCi74LncbimJgjrF1kAdMLF7OPPPwc08ppTXLLBuowygY86tTMdvEEvMsWKaJTPkHFtfxtpQjg/uoJcF+2rOlz3wW0/LrIZccSGLBmlicFA/CNIP29PnbSYooiWFo
 YBKNobNo
 hL8pUAHeurpITNUj8csLF06C7uknvU8nEGs8YoWFg5Be4RktZGGVwkBjZleKo7Qf+3/OYo4AvVCxXLLm3jMQ5wMnp5fZQ4EzTdphM+axow5xd/blA/hSTxWsbZtOJ5O6/twP73x7J7k5QIVMOaXztvVAqFm6QY/8yAfAjf8+IuZfoda9suw67Hne+NeBqzHK2gielSL6fdU67ksqcRw/xQheO/UXD2CTSCPNTpZ+BdZ4lrvO7K5CIkyyYlbqaf4nKtoGJXTFXfZiQcvW4Ur22Mfyvhu6yiQ5vJxbkioj6SUGt3qKMeCrUNg0hoynJxUOxpyuVOyeHcr23fDqya8mCfuyVsJSBk4rSCW0i/BhjT52EwQNGJ/D2BOzR1Lb5JlfnPt+qx6qqpd0hWVlJ07BzbjOhJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written to the
alignment files before it pins the entry, and take the mode from that
copy. Writes larger than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/sh/mm/alignment.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/sh/mm/alignment.c b/arch/sh/mm/alignment.c
index 2198c6f2ea63..d832249a8e18 100644
--- a/arch/sh/mm/alignment.c
+++ b/arch/sh/mm/alignment.c
@@ -133,14 +133,13 @@ static int alignment_proc_show(struct seq_file *m, void *v)
 }
 
 static ssize_t alignment_proc_write(struct file *file,
-		const char __user *buffer, size_t count, loff_t *pos)
+		char *buffer, size_t count, loff_t *pos)
 {
 	int *data = pde_data(file_inode(file));
 	char mode;
 
 	if (count > 0) {
-		if (get_user(mode, buffer))
-			return -EFAULT;
+		mode = buffer[0];
 		if (mode >= '0' && mode <= '5')
 			*data = mode - '0';
 	}
@@ -149,7 +148,7 @@ static ssize_t alignment_proc_write(struct file *file,
 
 static const struct proc_ops alignment_proc_ops = {
 	.proc_show	= alignment_proc_show,
-	.proc_write	= alignment_proc_write,
+	.proc_write_buf	= alignment_proc_write,
 };
 
 /*

-- 
2.53.0


