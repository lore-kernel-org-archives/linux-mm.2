Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5360C6070C91
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IiiIdQDE
Received: by kanga.kvack.org (Postfix)
	id 73A9F6B05B6; Mon,  2 Nov 2026 10:04:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7120F6B05BA; Mon,  2 Nov 2026 10:04:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64FB16B05CB; Mon,  2 Nov 2026 10:04:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46A076B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:04:43 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D112E160152
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:04:42 +0000 (UTC)
X-FDA: 85390500804.23.DA0EBB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1D518140017
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:04:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IiiIdQDE;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=moTp49XZfW2IxIkO6/t4/a2jJtvDF10yNUa6q6hnE3E=;
	b=i5tUuHX8YAOittWLueM2MEITC1bHtHAzL2x3vhIq3/TLTbaCNA2RWHkFKs5C3lfssIpv1J
	qrzQ9p7mZ5A0s6F1N/8+JzPKX/rynwRz22UT3alXh0lKOPowsSKVG//ltpjXsr+TpGiSpP
	ifU4yAYS6idQRULNKXANatgXlZTyHjU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IiiIdQDE;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631881;
	b=Cp6U4xzncN7krvgbGW6bNNnRGpAZ85BtOuWdgWL5Tv/8srie7mHWjZ8UazTfB3lVkAhDvr
	ODW83e5D6EZItMvPF+P8k/GT9OpNLrw2jDh8xKPVgF3/YdD3ycucBvVd/CmR2rQZ/N81Ww
	7nkWMbEvF0Wr0PcKSYSyBBsP/Wf3R1Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B94C440B2;
	Mon,  2 Nov 2026 15:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271441F00A1A;
	Mon,  2 Nov 2026 15:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631880;
	bh=moTp49XZfW2IxIkO6/t4/a2jJtvDF10yNUa6q6hnE3E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IiiIdQDEZtu3zrQxqnMzxL+byWk/RAlCN8/hC422DxTxacxYbFQWlllhBgr+wCmCQ
	 o9JOkaQkWd0AQIOfZ2O+qkAIOysyokSE2fcTak2VdOZoJKRHLA0f+7hXRqhPBAMdky
	 vgWDoWlfqaLnAWRNoKk8RC6jFoyccCUDgzz/C6H/mIYktv6mCSN/TWi3bYAQ7NRiTd
	 5S25YeBcc3fgExVmao12q8Y5BebuiNbZn+zxcQiNl93jyDgvg9mLGIhUCHtUIS5ANV
	 /YEQs36+1Zxizq9lsuD1fhZ94uGyuaO2p6IZK+qsp1AhT+1p7srUwebEMTN+HJIWDu
	 Gdu23GXfY3v+w==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:36 +0100
Subject: [PATCH RFC 09/22] sh: alignment: let procfs copy in writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-9-c9492ab08480@kernel.org>
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
X-Rspamd-Queue-Id: 1D518140017
X-Stat-Signature: 9yab9f5sxfjrtw5umd5qboen9rmqeeib
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793631880-962321
X-HE-Meta: U2FsdGVkX1/2m04AR85YQGIa5tEnAnJ6mWEvGBAKmXr4BH5Qky/CbduatzC3Ovdbxq30OxLyTVLY7AAN1ipOF/Ma1rBh7tBlxZuviVrOAuGGDdLu8zPRNcdJPeSp6ga7r/HEEAHz2ne8Y3Af9q6dns8G+zkjHwRWHQv0Kw/DFtM0cJNkjzI/oseocOUmiT3d2A27Yt3pg5lyrJhhVdkwRxBODY6aO9aoektYiV29PdsF3jb9s73HcyHLT0x++cj7FeM4Sk2OjMmavjY8Xj6CqtOB/RIqHUVPB+K8Nh9Vz3sooQKPTCffSBTRkOWoBwcqBbgAPznduFbsbMcDeoRq5LkQoZ3w2yoGqdAPBE6iXgeWTwPcwxIqdEAT37MF/gOhXatxm0UzlKgGbBz3P5llHLr4LdsbBb8huv7HOe9hDkvmTp0jPXo+3+VNmZ/YQ6leI1ovwam2Qbabcfbnh2wujfpC3Z1GxEMtjj6bnpq8bwDR22lP7k5s6pOzbmzyn3Y6kl77bTC6I30vfO3sXmyCdC9a0rIGSIpZjfzxgrtAkI8dISh+NRP8/l01aSRf992mgFKk9T+DMlZ0n55IvTaBnDqV9sR8b+qdr4dNdfUBj0HldM8Np2+x1AUjbJwSgGJSNwoOPgpt/uGoFgroYHECrhbKpYyxoHQJz5uzEucd2iQ0Ufzd153kEOW6E+OSamIxYypGpwY4dWSzEOK+89kXS9qFREqPmGn/2cL8RZDpHbPVwkft5jCzn9EsDsuKejLp2yf9vtkoFD5wfaMUIJuI4zLQ39gnnsxYsbdPU12RrM8Vz2J7GcueckvsN3HsPZ/OlGfYJWY7F6pSBtx9IRFD5VCJMdDc8dyUq0BwflYXC+Y974K+sTBvlcwe3qDLyVT7fhHjYfQSPQ/5e2JgPQygbXq7JDXt1qnTvx1QejswWtWJUtRjuWZXWzmHGLq4tGjGOcibZTubpzFzt6nmQZE
 mTxzYz6N
 +ZR0gZyXx5hD4JT2+KgTkfaUyRQWOZMbBQGJVx5usPCyCoFovLlub3Uw7ufXpBbGKkWn5VJqnNYVLSxY9coM+SPceEseFmOnIlxZfK0df3TQZFbSnPzfJwYncvmu5fLA59hGpjZH9yn4NlaqtYE+ce1UZChFbL8uPxlqRHgWTwqmV/8v5/zfeDWQ4o9sQ7m8vHYSy63wumBOtKhzXScdBAlxcrIL5FVlthozLG3GogsQM5EXCYT+BjHA3tRLAcJwxf6QzgqnHZ+FIRfCEkyIRroWmQHgB26RnTmjF
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


