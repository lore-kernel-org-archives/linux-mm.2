Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 249F5606C642
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mYHHEVUH
Received: by kanga.kvack.org (Postfix)
	id 360626B05E3; Tue, 10 Nov 2026 04:19:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 337376B05E4; Tue, 10 Nov 2026 04:19:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24DA16B05E5; Tue, 10 Nov 2026 04:19:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0999D6B05E3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:19:26 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 942E24014D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:25 +0000 (UTC)
X-FDA: 85418661090.06.6F043E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C66F8C0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mYHHEVUH;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JIdhS4jftRPy5dmxkGvzK/pMKfIiaESXVrYafcc8TvI=;
	b=8TwHFS5yVSlDHkXkPceM308hHQveA2NRTxhN1T4FOq+4+awSmigCVdezYI/sypi8pcsJwn
	cinnTnf3zjsbLkHI8ohJ3Lvwdwk0VgQiR028Cq/822X9r/srAzJ6nKFVKsfUCRUmxFFQzJ
	enYa0QBQNFxkkNBzhA7NLG2pgTggylE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302363;
	b=1HCcjGtheUaFnya/dRZIRRQhAHL2jM9oWku94qw619PbSTQ9nkKewjongOvAS7GDy778op
	fe1+Cs0oSM6nCyDFZ/b2yKFemqP9xinM30AuFxeyUgHm2Jj3bMXzcYKkk5Wpuez5GOy7UK
	t5gq1+KNTf2Z+D9yVPVWiiYcPf96E+4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mYHHEVUH;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 25E2E43908;
	Tue, 10 Nov 2026 09:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C363E1F008A2;
	Tue, 10 Nov 2026 09:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302363;
	bh=JIdhS4jftRPy5dmxkGvzK/pMKfIiaESXVrYafcc8TvI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mYHHEVUHk7mqBzZMRRcGK3fZI9JsYBE1ZTG0cjDKv2LFlPJXQyDrPAKc8bfKf0tGr
	 20cWdlmj2e6r9qTNntdUZ9fi9cszimzNeELmIamI9OuH+mBqpijs9/s789F34csANJ
	 fgWDE11qgNW8E9wTIgD1km9GI/swk+tLAKgjcvqUYxAEaRLAlzh/ZKAHlBj0Ky1PjG
	 0v/WkxNUgqmlKJXpJY525QsBtQhynnTkAMo0QExBKteka4qwdTE2za1SUpdJj+FcNu
	 WkR6hVqwaMbvytyvpFnjFRkLcYmdydpW0DidQOFfml4GF2k8PUvSil9bGhPenPlkb0
	 TdQ33wkV+qEig==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:46 +0100
Subject: [PATCH RFC 30/41] powerpc/spufs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-30-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1159; i=brauner@kernel.org;
 h=from:subject:message-id; bh=wZMRP8kJpVwewK9De4Tzgbv2SYhdkU5PV6eswxkQBIY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDtr+T2Qx2zP0qG7677LHLr7pKfRQf+MM64HrclZ
 SuL9FO7KR2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQATOWLA8IebTSHoxg9+k5c/
 HuRK8bM3/ZTN6c4W5XKTeHVB/4Zwcyojw/uS1Y6aDdePS9jN2MxSI7BiksRHOZ0gg9pTf6p5VkQ
 e4gIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: notwuwn9szcdk6pyaxqu6rcjc6p9ec4t
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C66F8C0005
X-Rspam-User: 
X-HE-Tag: 1794302363-30766
X-HE-Meta: U2FsdGVkX18WSH8rzEwmZS4oofg4PfS8lUkzx5VwQ8vKX9T7Db+a7CJNtePNKYiBYkyqTA4RXHItormWY3hkUCpXK9h+lqMGelCJnop+EPAoH3ISlI+w75VsNzYW4yqolM4CHKfv5DCX6hjpvqw6tHUAKxUk9frMao63TJb0SU+qSSwo+vGBLjAyiWeifo2kTk6nAjX4PHhAR/YFy/+NF6ZH8CypI25TtjKf4ptYIACZSoNLrYpjkMkwE7nusQ941Jy5C7qbSapzByhBlbh8aL76VG2p40bFLNJ9PkWZM8OJJsPv0p6BZC96v8ksCa1zIx07c3p0thxGC2iQ4KRMIzOrv334RcV80QLTMBCIj9MAIEOsMt1UmHUA6PGsjCEDPzaajYL9JHNXLmnKcYh8JzHTo0aYlfM5VpHkqoPTfB0+73M1X0U3MvEPA0xAVGdeYuwUptOJFB5B35FmHTK3NeeWk/8sWY9wNfxnKg+lJS6nAlUxRTAU+l5ouRfoBbLTIdJiyZ9jm15TGM5Kzk8iY05B9aeItGA/ag3kHOb7PqtGWiC/UtwW8WAiCFJl9mBeuqdiIEQydyni/OWHi3VgKCJoWuyj8bWHVPyHySbBgZTssu25PplgOrM5vE8hWWlwujn+/ngdHPlsgOZv5wJvJ0JkytzivxuHd/ZlZyftczjWkvTlcH47kfLHfI5+O7NsBygkgD5ooLo0uUJR9yZXHT+3WJG9ZNp7fbCs6qcaWuICyLSnVdIn36NucE4I4LEPXqhMcG+MJlC7mgfvNLQ8E+jWwxgyyrtkh3vtPr0Dx/WghxQ1t2tgcENe2yK9VmKJhnsKSXiIwjYciQIB5BdvjCX5aEHuXBVFv16JOFt9SI/PXOMFQX1ubRCFUeC4Q/Z+NFbnj3azJDFHEqsqZlhnu+eOTcP2RoJ4Fd7yl/q9+wgJu1vkBY1FFjyKS/y2JdqaCJW54Vvdn+vFJVUCMpG
 oBgnDA07
 A/S0u1mSeqeAevxaw29GQ/tFwgOyOsjmrOiLZ+okEajLvHwo3+GIKA5eUEu3uCFjM1LwdXzM2JsP9gIKudsriAcL7VJluDbzBOmhnJkeXU2aC5ZFXmvLw5/w5c8QiD88aFI0y9NpRvSE53bh6SKzk1brxoQxzvpE0aP9snGdKw8pBguEGVGrxuAcwQkp6Mju2WfedbN/VRG8MZlEcFqegb0xS9GetVVawNW0X29Iz+KV48/awbQiSa0VwrQ8WsSSd6014OrDkbHDK3nkU0390yKQ8OFGay5i1w33Asdyw2xEn0zRnqxJ1n9mjtXJ3EKtoFHILrljmpBHsWLs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize spufs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. spufs never holds executables or
device nodes.

SB_I_NOEXEC also refuses PROT_EXEC mappings. The spufs files that can
be mapped expose local store and problem state areas of the SPU,
nothing the PPU executes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/platforms/cell/spufs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index f066d9c7344d..54b45932aecd 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -11,6 +11,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/fsnotify.h>
 #include <linux/backing-dev.h>
@@ -741,6 +742,7 @@ static int spufs_init_fs_context(struct fs_context *fc)
 
 	fc->fs_private = ctx;
 	fc->s_fs_info = sbi;
+	fc_init_pseudo(fc);
 	fc->ops = &spufs_context_ops;
 	return 0;
 

-- 
2.53.0


