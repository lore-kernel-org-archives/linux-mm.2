Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53336072FA3
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CY3vhRi4
Received: by kanga.kvack.org (Postfix)
	id 8FD096B05B1; Wed,  4 Nov 2026 14:42:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D4996B05B9; Wed,  4 Nov 2026 14:42:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79DE56B05C1; Wed,  4 Nov 2026 14:42:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 48B7B6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:42:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF7AAA07C5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:42:43 +0000 (UTC)
X-FDA: 85398459006.03.FA0D28B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4EE3120003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:42:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CY3vhRi4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhE82sMafPzxvfPBNz7KCycPN06o3nm9WBF7ozqhvvQ=;
	b=0jQ6pouE2JGcYtRqi40/G7d/yf83Eu4U1D1kOwNkqHOSlQjIhAnwDRMERL0rjL9GhdjSDG
	d1A3Wyk1EUAuMZki+axCzYfNr1J2vrK52kAAcxmtQunCH5KoCSxHAl9yVvJpb2IhuCz7G2
	sPz1Zr1kDkV6oUprhKLmKLun60Lql0s=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CY3vhRi4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821362;
	b=KlHhwiSZw81mwVxkS7TvczE9K5GbxI4VaZ8Qd1w5KOLMxjoZs4t6+lc7l/AawpME6Sedf+
	6PFQ5qqwbPsSIN6ZOyxHjtZ1/8MnS5p3NTghL+bU80B+nHec3hEHreYUfzSXOvieD9Nc2r
	Y+CBa275l211ahYMolG/4YvZQD67VpQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A9CCE60F10;
	Wed,  4 Nov 2026 19:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B831F000C1;
	Wed,  4 Nov 2026 19:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821361;
	bh=uhE82sMafPzxvfPBNz7KCycPN06o3nm9WBF7ozqhvvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CY3vhRi4hQxkqcpQ1Mm/O3l6e+OzedeN/4+37SeNZjOvlqXmy34qriVvD3TH67ywH
	 DQzl6FzuyIa5uiOv7Dc7vMjmQMkxqYHlBr0eMd+Xera9VB0QWJPHsXDK0rpkNzXBBK
	 tX9Y7Jq5/fQhLGsvIaKNSEhYv51qK+oUfD0NCrdQZjRmHE0FizjDeNxZM3dzQpWJZy
	 HRwBQTyj5k9AawVsBYNGBCFZHPpK+UsKw3yqcCB9jomRWBq8KMKMHMiOAFjbyWU1JH
	 JbXTNMiiUjnz72MrV0u90yAZ2M59tRnRkIXF5dI/J/zo2XxESLkUQl4Q5E9EaHZPuO
	 H5e07M+u+h5bw==
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
Subject: [PATCH RESEND v2 01/26] nubus: let procfs own the seq_file of the resource files
Date: Wed,  4 Nov 2026 20:42:27 +0100
Message-ID: <20261104-work-procfs-drivers-v2-1-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1301; i=brauner@kernel.org; h=from:subject:message-id; bh=x7z4QEHcj9RNvDtDgoKANKctl9Sfloc7qmQpa+Y73Ns=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97ioOOa68o/Kq2fmOY5NWuTU8iP3ZEGF+bqWx4z+Wl OQWlcZPHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABP5yMrIcHHmjxMtv47deeBR f8hmwmHx04XBoiyTn7ROi1p5ovDEfjGGf0pS7v/tJ675tu3LE5ZOszvfVmhY9L9Rd7yQdf+7rII THxsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4EE3120003
X-Stat-Signature: 8mtoxdr8rr1musz48si4fmiy3qrkj9i3
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793821363-304340
X-HE-Meta: U2FsdGVkX19npo/dQEMQRnBqoYxaqY+/V3KMBmgNGtHXCjZMZew7TzsLj46adN0fOcsWbRDUvKSDTxvwY9Ahn1yM8zf1aVjHfD8Of889+c0uWTHk3kcfJYThvhrRY/XHwHhZZ88YKJNh1gQWydm7e+Sg7ce5hujVlavJjYLpf25UGQvooHz5sme6Xhzhv4Y/Vwctw5JResbs6wSYhv014J4JL3lZ+Q6d6tp3l+3zbsKnxOi0PMaIi8ajF0xObvZOvO9Z8RjYCH4ShPTmkM/etJf7V7weECalflZi8ujJKj71z2T3tP93yk0u86O50JKBuqMy2i7q1uOgIpriRxOXpVFfkPPqK+DvmQ9PdyW7P520g3A2TVTK2w8Rcv789hnvbNhfojRiTvLTqY3npjlNNplWgEJERirXsV8xurcpOpp73BpPeOsepZo3KbBwdyhNz29p4peDiHDU0A18RtSoPqKk3xs1JSyxcdTCpIXyiglgyqw5HzLfJ4hyD6KzSjKffy4u6/8B5liHELGWY2XYkBm2pI9Pppz1Px0metyUqN9iJCT89tRWLOm9Fy/YPuRSgE3bHGNdsAcrUrTtv7CQjk+LwzBDQPyFE8jo3e4bznZqym3Fj2vRnnW2DJ9CYi/zYPuuNPtyFtMEMQ+hbzJG6fPirI/yClf0xWHVLl2MlYXu+VA6wcMse5w7qvkPU/aFmzHewrpEZRYtUWu3tNQ574B1MP/mn2SnuhYhopjp6nAHgXZBLGURF1CEnKJ8XsINaeRGeiqL8yCCBi3uiujpW3rdZnO6WNqthA1x3k3LIh6tYCX2+eba5679cEIV8fYdarOsrfjVxvwXEeQnNLwcVlQdi7QXPwHDhj7eCpekJrZg3rO7hceMp7FVGWJiLCekwTA3g6Yx4HMJX3K/aCjQ0mE8Ka6M3L3WdZEfEed8r5P3ZT5+msm+RzuxMKv3iYsPdOayN0D/NWDKcOElsY6
 IEE2LkMq
 7eUTwruHKzKzOASC33kLS+OtinRWzmXRF/txdc7dYXcDABanM65CoIPQXas6fYS+Wwrg955B0uvGZLPUoJE+DcP2Fx60uf4d9tHfvzW3E2Q8CnjHeQdzW6485q/mfapI2qcgX3K+BjZlUy9oy9Ayeo8hpvKg9mnp68ppzylFkZC/hpv4IFaKaX2S0IXHFrQBY9rof1YHxzgofS0qCc4MsZeC4fMs4YIgryMxejUYfszYcIgVNW1rYRjyKQ6+gnx+Nxu/QPsU6Wd3JQA9GER00d5nDJ+K2CsrXmTuRKz9YNl/3Vpa6d26Ag/XoDNkrZEHzT4lbBF/r19p+r0eiaLItww337yyzqutAaKBNMzznSZa/79iA/Zs5s4WHC1PBxCVki/Qt9m8E/GYGwbPaWvsUMTShv0yXc+3peHmv1Oanktwlf6HffQaIzl0rd2AUm/46J6Px
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Get the inode from the file instead of ->private, declare the show
function and let procfs open and free the seq_file.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/nubus/proc.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/nubus/proc.c b/drivers/nubus/proc.c
index 3ea3d1738eae..cb21ad1d9964 100644
--- a/drivers/nubus/proc.c
+++ b/drivers/nubus/proc.c
@@ -107,7 +107,7 @@ nubus_proc_alloc_pde_data(unsigned char *ptr, unsigned int size)
 
 static int nubus_proc_rsrc_show(struct seq_file *m, void *v)
 {
-	struct inode *inode = m->private;
+	struct inode *inode = file_inode(m->file);
 	struct nubus_proc_pde_data *pded;
 
 	pded = pde_data(inode);
@@ -138,16 +138,8 @@ static int nubus_proc_rsrc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int nubus_rsrc_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, nubus_proc_rsrc_show, inode);
-}
-
 static const struct proc_ops nubus_rsrc_proc_ops = {
-	.proc_open	= nubus_rsrc_proc_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= single_release,
+	.proc_show	= nubus_proc_rsrc_show,
 };
 
 void nubus_proc_add_rsrc_mem(struct proc_dir_entry *procdir,

-- 
2.53.0


