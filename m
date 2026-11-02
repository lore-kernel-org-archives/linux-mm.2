Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 086FA606A933
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IzlZDjTa
Received: by kanga.kvack.org (Postfix)
	id 2AB416B05D3; Mon,  2 Nov 2026 10:07:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 283096B05D4; Mon,  2 Nov 2026 10:07:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 199156B05D5; Mon,  2 Nov 2026 10:07:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F191B6B05D3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:07:18 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B107C0134
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:07:18 +0000 (UTC)
X-FDA: 85390507356.10.77A0B61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id D887B1C0002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:07:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IzlZDjTa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mGdLlGj/NJAJr68kXbSPslaJvhomImSQvB5hgldkHFg=;
	b=CnthQwJlk7q0D0I2HIpbhUzVo+DExCs6vbC67d0HSuLu0NAwgswwRDAdJ1wOWgOyk8sljW
	HO4DKn+pBtfyqc23nEOy576ljq8w5dwgycDJ6917OVJYM5ZrvUhifNTLmt8RpSGfzB6/PC
	5AzhniTusA32EqvRTenMhl0BDX8LpWg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IzlZDjTa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632036;
	b=L1xdtolF9Rd3LaWPwbTUOzZJ4Olarv5rd1cqIYq1JX5qgoe1vSM/clPod4K3NRjkwYt5ZZ
	zY5AHnCjLE+7QO6E1YbsCGUYLz7bgB3K8hPXaLQY1J6Cl+4Z5VkPUFZixQlqH4OzlQ0TO8
	2VgmnkM89FH7lOIiuKxERw7cCqhqBCU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FF48605C9;
	Mon,  2 Nov 2026 15:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26C51F00A16;
	Mon,  2 Nov 2026 15:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632036;
	bh=mGdLlGj/NJAJr68kXbSPslaJvhomImSQvB5hgldkHFg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IzlZDjTao7VjuIjRRsnw52RX/0AjF/WBmgT4NSpXmtjt4TJbN8zegt24j5DOlUa3Z
	 44pMabJRvDCRlnweMnKPhfJPYcWc+E6OtpWq1y0Ac43VD4FbMRQP9qey5otxK1q5PL
	 oT9zsk1HsUa3Ue3zXl6S6BVtFghJKXFiWTJwHmxl0PE/8ztq9iyqz6BcdrpCZDdpYi
	 3XtzkYqJlHCU6ToIaLkgAjRlsjmuFBtw97UNIAceQYdi00vVfKPn4AuQDU9qRHk19M
	 URA4zqhN0uKI8rAUpyUb++ZQsVmLXvF7KAChG6Fit1JA/MDvvneOl/7dLgJJZyJ32o
	 yDuj9+i1oCVEA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:43 +0100
Subject: [PATCH RFC 16/22] xtensa: simdisk: let procfs copy out reads
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-16-c9492ab08480@kernel.org>
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
X-Rspamd-Queue-Id: D887B1C0002
X-Stat-Signature: sk6cyi895fb8zj8sgfq39np91xyfdy58
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793632036-835229
X-HE-Meta: U2FsdGVkX1+KxhwAHtVQOYu7OW1AOG1oT1zn+8RJR4VaXZu3hpW4hbT59IeP4F7/B8LFklIcxpEEQkOqdagtZ7Awf8CbDxHnISh5MU5ZlwNyP5SoiGN/n6iZou3lL03h1cXZH//G8rNMjuIAwoWCa+yJ5ljn8rMC9PO+z0Jd0Z8+QZmpP+KHUFGktbrt0yIQwqDjLRmunZHLKvj4d/002rp+FVs3GdpF8J84vh2wpCsrKvuKnj4TsurYeSHC4dK1a2EWVkCXbSPDep8p9414EY9xftdaMawzmbnJc7oF99noJ20f7FWUvFpsgaTaC2MsuVpXHC7tcKY+Czyzj1usEC06XpkttXIlf+TQOR4uv1XSdy39ruIDxGyT4T+pwr/hdNbXkUC7amg/Bs3OZpwZ5iWaR+S64gq61F1szzW3lReRNRu2S9A28BRmutskq42c9shH0Uij+8BN86nxZIxO0G7aHdq+rCcFbaeq2/MZWz6VVNjy7DfnT2h/nCMV0qeDD/QnH+RTf24/9ReLDIM1LN2KvjOScXvK/0KZ3ZOhFvBc2enh28hnx9JEaJrhgUl1GEDtwfenqO0GMXM1Zg6eO+vj+8uMCj8Jw1hDr8K3qvV1wRUj9qe/k7CTpHF156+CQ1xNR2+0Pr88xtwIJT72RgsR8S8OjAQdgMmtbtPdfw5RKXU9dwYMu9I3OuNrh8iCNS/+Iqj5Uh2Zvyh1bmCs5gn2wYEC9x+p1S3MrGw7y+4BzZ+J1LH7AbQEVaeKDNyMgV0rDt4QirjfUq+8H5f7t7E53ya2Rf8w/iBHSnKQ7Mi189BN9cbfNJYLADwq01LK7mUHOcd+BHbaGW7xxmcllCXaCxtiYKckX1DtKT8AyaFN4wqZuRCl2L+elSFY7E+Xlx8fJC54bLHC9p47AI0EaPOU118d5B6PM/U+9weeOMD6fwHgP41UsCBgkLCKdQcP0qNhkcJnywxi4TGMYwG
 VfT7j2IV
 wcXwbJLo8EkD9aNzGRsH2/JPks9wD+CK1Rfa7Ax167Z68POxvxEwqgOjzFZWpx24phlAPYbqx4+Dhib2qUKdhFW0N5vLh1gAOZlc+qIwvFR8YCGOeF/373hkMQmnPMhEqY2jBPOiTkXNAnCjuK2PVjFqq8dcQigiUfYuyeXsNpCPIpXliOw0e5IllpKJuh9RDXZ+eXLx11mFNpxtZy0x61S+2SoDsogcHUifnoOf1eAaZ0nmHkZe5SWopnc4bqZO33XArX48H2/xDjZAG3Af5vfWMnKYAhPPs+jr6X3zTKCCHLRtykGY3IkLrNLmo95SE6jgs4x59vxVSK9c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read to userspace
after it unpinned the entry.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/xtensa/platforms/iss/simdisk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index b2f9e7f3ade3..b597d8642e8a 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -234,7 +234,7 @@ static int simdisk_detach(struct simdisk *dev)
 	return err;
 }
 
-static ssize_t proc_read_simdisk(struct file *file, char __user *buf,
+static ssize_t proc_read_simdisk(struct file *file, char *buf,
 			size_t size, loff_t *ppos)
 {
 	struct simdisk *dev = pde_data(file_inode(file));
@@ -250,7 +250,7 @@ static ssize_t proc_read_simdisk(struct file *file, char __user *buf,
 	len = scnprintf(temp, PAGE_SIZE + 2, "%s\n", dev->filename ?: "");
 	spin_unlock(&dev->lock);
 
-	len = simple_read_from_buffer(buf, size, ppos, temp, len);
+	len = memory_read_from_buffer(buf, size, ppos, temp, len);
 	kfree(temp);
 	return len;
 }
@@ -280,7 +280,7 @@ static ssize_t proc_write_simdisk(struct file *file, char *buf,
 }
 
 static const struct proc_ops simdisk_proc_ops = {
-	.proc_read	= proc_read_simdisk,
+	.proc_read_buf	= proc_read_simdisk,
 	.proc_write_buf	= proc_write_simdisk,
 	.proc_write_size = PAGE_SIZE,
 	.proc_lseek	= default_llseek,

-- 
2.53.0


