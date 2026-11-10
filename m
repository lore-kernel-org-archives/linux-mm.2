Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 152FC606CF9C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LlMaKIGP
Received: by kanga.kvack.org (Postfix)
	id 382416B05C3; Tue, 10 Nov 2026 04:17:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332AF6B05C4; Tue, 10 Nov 2026 04:17:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2226C6B05C5; Tue, 10 Nov 2026 04:17:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F2E1C6B05C3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:17:01 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8EF15C0388
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:17:01 +0000 (UTC)
X-FDA: 85418655042.17.C3F8858
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D3C16180005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LlMaKIGP;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WY71Uo54gYhZKR4pKqr/19QlXycB+RRfAfSK6SBkMOo=;
	b=DTUwoNBEIf8Ah+9ckYsrC6nFt10AQKZjiBB3LBv3VIZHsSoy5frhfgcd2DeaCp/+0GXMej
	gBcFiszMA18GCH8ZzBIlrS2nAc88BIQWDvQ+4RBuo6U8BdRQHRsI1O141ytUXWPQ1aulWy
	Tuo7Myut+fhfQSFTJ5hJcQ66hJj1dWY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302219;
	b=4IqHjX8pCIsqE4aZWyURL6OHKGB9USbYfd8NhkJoJsm89nu2KFNSE8oa4MAak1Y5UtKHrX
	OoDH+eZeJuLMtWQWNPcnEe8EGiyBqJM+nk36zwa6NJtJcvHDe02c5cBYRwT+1AkLHVUzyd
	QJ4RO+RGj210nzT39NBubJEZjImDvWY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LlMaKIGP;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6DE5F6302C;
	Tue, 10 Nov 2026 09:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02601F008A1;
	Tue, 10 Nov 2026 09:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302219;
	bh=WY71Uo54gYhZKR4pKqr/19QlXycB+RRfAfSK6SBkMOo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LlMaKIGPglPkcvGNxGDrg7KApXX+gHKG5SrrawRrOpvdcrBWjo8TZvaYC/dVHXPkL
	 o7Q4vzGLaTH3tPVI6EK6P52H//aWm8LX6LNA9wx7GzZylS8Tm5t7Uihc8gqN/tYIDQ
	 PP3rUbIEqyxUIjeAdPOxrVHEdBQihQ2084RfxCjhwr5G5bFc0E6zHMFFmmj7AzSVaR
	 tXO6WvEI79qn/4DPL9toj7+CN6z0DqQ1WOgva9FN1PkhAS1Orh3mr0q9GB2K5qslXC
	 scXEvlIXqJ5srN3BcqIAjqdwqr7UK9xIGt0dTlwV0MKzMAeX4GxKcYRYlOYndv3UdD
	 j0+mmKCFyRsXw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:25 +0100
Subject: [PATCH RFC 09/41] bpf: use fc_init_pseudo() for bpffs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-9-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1203; i=brauner@kernel.org;
 h=from:subject:message-id; bh=NuPA4jHbua+UQUqvE1NH9WnvUCJeB7nsXYSG49yrfac=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9ejBv9qN9iY0qd75n8gck3laXYJGcP/Xvwpp6nhV1l
 +fz+Fhu7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIHQmGvyJmG6+tnBjH3qJw
 I1e/7XGpNFv1HyWFz9buJ/bVbr2pzsjIsPmDUI3mIZewOZLzrAJLZy6ad+vu3j8/r72fuW2C0oR
 /b/kA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: rosx6nqyn1bcr1us4j7wq39gzzi3oj3a
X-Rspamd-Queue-Id: D3C16180005
X-Rspam-User: 
X-HE-Tag: 1794302219-669364
X-HE-Meta: U2FsdGVkX1/P5s6TOJxEC5MQgRioG+LIAFqTW3xy5ael0YvhQoGHMXkxQrJAtCJU9abmTe8E4TAsku8DLsNIj6Q/9OAQDuWjl5kOfppLpZ1Id2zH0PAgE+3hr8khXZR/IFlaML3zHJcQiuMCilAanXuH4hGR56fLRyxAkKpl0lrGb9LoQbMXqAqfR5aG5X77zERyoQkaEBGuekz6qO+4IOuwkqdcsq0N4Ht275/tuEudLP0+rs3Gb1aypsuaDHMI3XzRByp5is5k2lWypLLE9/6b70OF1X+m4a1igSn8VC+cbvw65DAR6p94lUYWcMZ07nwtYFsYKxAtlltdixc6ZIgHfng8KYC52pecVabA6YbWG6fddnbgSGyFI6Bhj03QXm4lAHM1hkfYKoRnBDvbow2dQSHwlYDRrYf884p3CV8hancB8zT0FL0WfogKkOfwMr8gLaSoM/LCCYz+YXnzCfGoZJzD48RckIoJimID56Pz0DJJWbrvV7pCza1qqPE2X5waZxieUqytjHus9tTxVJT6cViAqDJDBHpbTQMxSnSon1DXl/J540td1z4lvFF/rVUUTrR6p+lBz/VWsJ5EJJmdK5jzO+S6EwwbOIymBpUbObpF9RyS5YkzjJTd57B/GdeM6QGUmusmWSexqitZLS35RPX6mG6ulxSfVr1cj3QjMJuZRmHfg11Utn78JKPqR3gzcG6KAfvfmgNmjt0PxIqjjzvO9+at7ksSNg0mB9Jw0vRzFu9Xa4BHTCUrlXRYNkeczoWeWM3PiLbmIN3J3p7liu8Hqgu9FqszALJ2/bYlN0oUyFJY1Tpt0S1xyQC8yHsFXSmay3pVSlemuPJMpECcYvgW8VC0ICe0gFmko3ztWgWcJDCbquROEj1EW+KiF1li9VQQV9TXEpBmfMsRxCPslK8eBy+z7g4vLzW0YGBwT4O3ZUfaYB6Sh2C2AjsuiMPklGbHmOW+cJAxyh3
 8a4mSw5F
 nySyiuQ1pOKGeVnilrNkk+Qp3xpwykmntnADhWG/X+af9xCIkSmclpOLOqImdXwkAlQ+F+ZV+UMtPLpqrcXjp3X31UueROXLoYzW/HUPZ6PwbEcvEWR4WZdHUURSJzakcUvz2pBtENvEObKnaXrMtZIV5wB8sHKHOWbkpUQ+pPNMiLsXQM1YA6PHBnzQ4qmtNG/QjDHRNLryjlQMmY5to5/hdd8yJiQyFjNF/f1EQU1vRxCGcdncqSUWm5gpB/CxCngKMtCqcBfKvpKNwcL4RbsSZ+S68TedEs6ufNOssJGF0LGw8OaWB0FGJvQSLQWt/CeheUN5hU548MDM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize bpffs as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/bpf/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index c6f328e4752e..57cf3775c076 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -15,6 +15,7 @@
 #include <linux/namei.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/kdev_t.h>
 #include <linux/filter.h>
@@ -1197,8 +1198,6 @@ static int bpf_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_magic = BPF_FS_MAGIC;
 	sb->s_op = &bpf_super_ops;
 	sb->s_xattr = bpf_fs_xattr_handlers;
-	sb->s_iflags |= SB_I_NOEXEC;
-	sb->s_iflags |= SB_I_NODEV;
 	sb->s_time_gran = 1;
 
 	inode = bpf_get_inode(sb, NULL, S_IFDIR | 0777);
@@ -1261,6 +1260,7 @@ static int bpf_init_fs_context(struct fs_context *fc)
 	opts->delegate_attachs = 0;
 
 	fc->s_fs_info = opts;
+	fc_init_pseudo(fc);
 	fc->ops = &bpf_context_ops;
 	return 0;
 }

-- 
2.53.0


