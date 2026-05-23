Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7515CCD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC0B66B00AA; Sat, 23 May 2026 13:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96B46B00AC; Sat, 23 May 2026 13:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAC7F6B00AD; Sat, 23 May 2026 13:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BAFBB6B00AA
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:56:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88E21A0BD5
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:56:04 +0000 (UTC)
X-FDA: 84799438248.10.DCBA3B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id EBF5440003
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:56:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oZhkwgXq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779558962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xn1afLPdDj00dLAc64xuCdT5ncjg8HMcRvLHoM078ak=;
	b=Le1COUCEuX/y6oUCMYno1Yy+6CUCfsqjsCiG90yS8sG93SkJdDgnlDCIpZGZFJbQnFsi8m
	WYSs6jTBawc4SX9uJSMWwvxuxitfahnnU76BTjb17UxwVfZOnrkxoYxE3hsDTGB6nGpPua
	6bS6/dt1Le8w3nO1DQFt8LQx1VHRhko=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oZhkwgXq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779558962; a=rsa-sha256;
	cv=none;
	b=tZQy08ooub5qrM9Ahf3c790kzJB0oXdHoTSN9IT0zKbL+ojUz6IeEC408TXI4P3dMVZVSR
	4sd8bcaO0Y8y7TH4tVg8qpVr+yUdFNEOKSCNV+zYOp1N/Ep0kkK8FYxrTOY8MWfWouBLd0
	/pJrqCXnyPvsbJ+Syd8zRum69A9rp90=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8508B60138;
	Sat, 23 May 2026 17:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4E91F00A3A;
	Sat, 23 May 2026 17:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779558962;
	bh=xn1afLPdDj00dLAc64xuCdT5ncjg8HMcRvLHoM078ak=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oZhkwgXqudyq5TncLZzYhSy/KChNIJsYMPo7KO3BUs0B5I3D4uMMlIJHJ5H/ZsIiR
	 O7WDgdKc/37mYX8oVhIB+gQOs7nSvU3Wkc6MhR+TfDmZFcgB/B9ilaXie8CblGN9d0
	 KHAaqP8o4lh1HFEljI32jULXkHy6jjdEpet+Q/9ZjLd1IIUD9RwCL8TlSbnwXy2Ff+
	 529elZn3TrKG4mapsyPR44RG0R8lKa7ncAu3JbZz7V/nyli4itQLLBzlDHjolS+khv
	 Efkoiz0JR9RL0vbHFM55SfWM2z9m/9FY7WC1YyCJnnsu0Jf6lvKqAF9GJ0G7WAhp/b
	 WbyGsmdljEtLA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 23 May 2026 20:54:23 +0300
Subject: [PATCH 11/17] isofs: replace __get_free_page() with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-b4-fs-v1-11-275e36a83f0e@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
In-Reply-To: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
To: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
 Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, 
 Kees Cook <kees@kernel.org>, 
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EBF5440003
X-Stat-Signature: mn3xeorz37mngwg5jnfz59wfarkpe3bs
X-Rspam-User: 
X-HE-Tag: 1779558962-286549
X-HE-Meta: U2FsdGVkX1+DblktTTHHeiPxxBHg2zxywbzVmepFpbhX5TY9bCdzMI7bO1VIgjecMxn5I9Pmh7D6zVfiTePNHmcU0M4rTWp/Ry0b1U78Y7diwx8tKwo/5dgc1WptcnW9yfNaoNJLRpOXtxvF3Kxra94VLJdX1sK9ITz0M6fOjJUtU/Ksrtyu5H57z7xFMvz48brSnEOFjvW6Ou594iMXaSQhX9F1ghX33ve0F038niWcXaSpWVVypigRSviQTdYAw4YAKzzk9kiwJnoIrZJ3bFW+vQF/yNhSsozau88JdzQP/IV9bW9EJlaVLcEt6yYFUhYBTMhEekxzHrMo973rX79lKv5EOK25Xz+tgTkJ/Qu/vr/lDnmEXqRc1FVB3luIb4H1Kgtrb6KUpBNSzbep2qSdfWVD87GM5G0UdeWKT9uJXhzvGJ61fooznw1tp/rqSTTQxvnYDVjxPN0sl5LaeVI05cNlLjdYohn/lD6mKzOSFk5jPN20RbimFHkgAl4HUqRsV+EIIMtNANXnVy1G+ELKXc5FBwFdTgPc7oiGo7ZP768GMGDI6+VZJEhSeoDG+bwh6hrMXcA1QYyDUARHIhC4UYdfegvyzg8C9jemhKk/WYkJtQqaRQeSwZ5CoZV949qFadPAHCPpBmQK0PIvQxqc4f/93PxOhITSDITNs5yat5HBDmoL4GXQpnleMlh97DOoI/1QGAUDMX9YJ6e61bNOedfmHlO4D14bfZJSffgz/U3obCAcAZ2TeI3Jnr2ATHE3fW8lIAxivTx/GGQneUf3bXrIBbyExcla59epB1D+t83E4PFdNRj1u9x3hCqiXpEeMI4VLBmoBE1AS47BRCvpJUSIdILG6ptnHDEtDGayPI45X5BqLf0sMo/ahD43Ax7aryj73oNh6qWyHyBw5qfVw++oKEJ/JeGt8Ckc3W3DW9nHnNro76r9L0eBDd0R0Vlqr9E97hskVdpMdPF
 VbMbVRoc
 w4O2oXQ1XzsFZ6cYrLz5FIuYhhJSKQNiGlj6vz1CRF5/eVbtPTF1UpSqgQE5W9M+a7XyoDuPR2BmW1ZGd85fHU2y5NXaSJ0ifPR2rmIf3uWU9KQ+aDu9UlKqfSegk2ddx4BVw4wc7XWjVcIMnVC/bysxTp3Eomvc7Diy/imIvSMuMSVHzld1HHZgHX5zcfyEDk/OposMfYfacfLQrOTsy9v/yH2uT4V8OzdCwIbD7OWSL3Z9Jkz1pJYT9RzzP0rZbbSGlgfz/tIWZVyM8NxGVGSR1Gr2+9Cy96I7aklQd2wTIuQpSr4eof4KSOo68WvdTZB42qk5MVy7i0NAjRYgfE3VA0wHrpplE3hBX6wEphsvL7/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

isofs_readdir() allocates a temporary buffer with __get_free_page().

kmalloc() is a better API for such use and it also provides better
scalability and more debugging possibilities.

Replace use of __get_free_page() with kmalloc().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/isofs/dir.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
index 2fd9948d606e..6d220eab531e 100644
--- a/fs/isofs/dir.c
+++ b/fs/isofs/dir.c
@@ -13,6 +13,7 @@
  */
 #include <linux/gfp.h>
 #include <linux/filelock.h>
+#include <linux/slab.h>
 #include "isofs.h"
 
 int isofs_name_translate(struct iso_directory_record *de, char *new, struct inode *inode)
@@ -255,7 +256,7 @@ static int isofs_readdir(struct file *file, struct dir_context *ctx)
 	struct iso_directory_record *tmpde;
 	struct inode *inode = file_inode(file);
 
-	tmpname = (char *)__get_free_page(GFP_KERNEL);
+	tmpname = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (tmpname == NULL)
 		return -ENOMEM;
 
@@ -263,7 +264,7 @@ static int isofs_readdir(struct file *file, struct dir_context *ctx)
 
 	result = do_isofs_readdir(inode, file, ctx, tmpname, tmpde);
 
-	free_page((unsigned long) tmpname);
+	kfree(tmpname);
 	return result;
 }
 

-- 
2.53.0


