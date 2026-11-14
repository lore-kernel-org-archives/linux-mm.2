Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321DD606B0F2
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hEkWoi0t
Received: by kanga.kvack.org (Postfix)
	id 56BB96B05D2; Sat, 14 Nov 2026 08:08:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F54B6B05D3; Sat, 14 Nov 2026 08:08:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BD7C6B05D4; Sat, 14 Nov 2026 08:08:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 19D586B05D2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:08:01 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A43F41203CE
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:08:00 +0000 (UTC)
X-FDA: 85433752320.12.74F15DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E01E42000C
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:07:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hEkWoi0t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4kkI+IPK2+Ut0+1ZoXiEi8rjJhct2bhRJIg1CarRCAo=;
	b=PnMJlMpqFli4W3I0Gm9Bx8StdNaaaVzYHsoiRWhpLfwMfRJv3LeAkcVr61agBZd7unV9g4
	u5PVLFNrs+tGYM3jqmvD3gvdAOK2RRE7A0q03ClKdCREXNaVs0YDciQkYsEKzoeDauoE2M
	UpUk0yro0ibI8lnnWph6f8g150oaEZE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hEkWoi0t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661679;
	b=aioUH7qJD46uhwvroR1ySBCUFrzioRlUGMxuHvy3SPXlaqeywd5hod4XPvU0PbVCiG2YYm
	omVLq5MSmKRkf6bAM06UJRZoL1MfayEiXON3cjaffVotMwFYlscllPgty1IOQrCSWu62ri
	ofIrwH3wqInehUva73sDCi8HaX5vsqw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C11340C08;
	Sat, 14 Nov 2026 13:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0AC1F000C4;
	Sat, 14 Nov 2026 13:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661678;
	bh=4kkI+IPK2+Ut0+1ZoXiEi8rjJhct2bhRJIg1CarRCAo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hEkWoi0tyCsc9zadGHLm768O7sYlLi/D+fGyMzmvsQLG0ecR+NMw+wied9l5d5Zwz
	 gXg/BXMBhAqtrrbzcnX7swbJyRTSoeXkE0/Xj4exo4chOq2rqW8u9NgVvtGNx7NQ4N
	 tXKYibjQAPgJeWrE1gEMbtIXMLXERqjMNC3NkxnywycmncD6Z6ELQskYJq/tDcjGyo
	 b7MiLG6d3/YOLC/qD+DFLTnmKp2Eap+cYDtfpnlvFm0Sd20bv+GLE20cwwAUSwJX76
	 vkqL8xuR//PPoR3nag7/4uwnKL0zHsmwqxxmbWxXcW1V6+IGZWFTG9QrabHpoz3t6k
	 wNuuL3/EHnOaw==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:01 +0100
Subject: [PATCH RFC v2 20/42] apparmor: use fc_init_pseudo() for apparmorfs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-20-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1033; i=brauner@kernel.org;
 h=from:subject:message-id; bh=2+D6KLg9w3laVv0BnjhP1IDdcfwT6twoVX6+ZeNTRuo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iKmZKcpwLKbq/umvv9mCX4WuWfO/R+PnjY3u1b0xy
 aJzTtb4d5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk1w1GhpYuUdG4qi+fP0qp
 P5/cI7ND32rq574Xhq4Gah0nZWLEwxj+Z3padK6OzZ+r0dD959lvmcWH1WL54+qWl5q+bm665Hu
 KCwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E01E42000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: o4bayrdgxymi9jctozbr7ptc9is61zhy
X-HE-Tag: 1794661678-949352
X-HE-Meta: U2FsdGVkX1+e6viEH2xFsoethRZ8+64c2NsdYJYh0fMQLF51ml3jTa/rWUEuQ8ZZwGfUScEEHB2fPSl9hr53R/GShq76eIx74oez5kuSCkTU1GpPIrin3mujWuDoSND9w1YhxCOcQXMA0QIHZHog8hDPmqvbmKD8CCASggZQBOZqUquoJl0EcWeVJrqUaogJit+DvvqZ83xLskJOEAIru7ZvvPBsXnBWCJw2ce2d96OxKcqcX0LYUX2dHkIaadVpEu98lwKYCsZLHzr2eShKs4XNuh9+5CL6mQVxcZHmzYn06/TU7/ZI4vMJQTbLXjT68eILEbw5AsOkttGK2eJaucFwuQx285RfRp5hKBaiKl+p4Ud0Kqx7ZtS31oSFvWE8ObJvLIiTmLv7V1thlKFz4NGEqxDer5UsxOWekeiKS0Tivz9OyfCnforJvteU/SkWIsWJtGjpX9u0tvjPjveq5yuX7LzkeR+DF/tiZWzcCLLhdwAIN4rfJ5sWvvtdFsb1yo7l+dMZCaK/xj0nqnVGFo6uGUEKbmhoLwlJG3qCNO6nCs4grjBh1cKJ0zU7xdknpi2z9s2AcUBhjl5p1iG8o1ImksbRVQqMltqJCw6zBi8UXD81ht0tGsrQe4ERZ0AXpLvMX6CXpR+u8O33PqlNnc/bUb05bL2BRF3oKmTLEq8aA/nRhGjY7BBKL/XB4KfEzMgfiHiVFm5AWupkI3js7CD5g6BC513Pmtnl46Ueyp/ZSAAaYIuU4SQxeLb1OPoHIlxqWqzbUMAsG0JQTbfNmUwV87w/edcABYPEw58wL/MIchL4l2BGUSbnqrxmnejFS1NleauZUBTbDVvv3GgfusigqRubphK7b1ajp2NdrnTj2p0iEdzRlfht6djbYNcyfnHeOmF75khpjsFLz3bIR/iweHUoOOX6u6/ZP7ug6e3xVQMGIpanDmL8qZd9oST/au60T5Ea5yqukt61ayl
 9FjNArkX
 mMyR8H71u72mUZOzplj+UvKOtazOFhdc/V8KxSIN/ZyYfGH4obmD9A28WBZMChIafOFBB4hG9jPmNTVD/oLIPnfxTa+RyisJ15D+epQBH44DWZt1vCP7aX1sF+Boncq10wfjPGKB2xmXyAk0n0e21rtx/CA5J68hTBMZTyYBp5HEAAIbPgwHxE5iElV+y6e9/WvGdZ6bywUqaYn6e6mLMS9tTWTwMzm9ZrsFcK91hgO11T7dAuKW/L+wQD0Nu1zbqGBT/+fwK5NZKiBYCy0vXXMYHIHtgF2sbnmrLzT7sLI6QKW+LOfU5noQq4fJTL+YJ7t7QGuOmV4I4TrqrSzXwPPCpwExiwed1hcMgtN6cmssMyeG8y4LHLcBUCNfRjD9hdBWn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize apparmorfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. apparmorfs never holds executables or
device nodes.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/apparmor/apparmorfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index a993664672173..351ea3a7120e3 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -21,6 +21,7 @@
 #include <linux/rcupdate.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/poll.h>
 #include <linux/zstd.h>
 #include <linux/string.h>
@@ -263,6 +264,7 @@ static const struct fs_context_operations apparmorfs_context_ops = {
 
 static int apparmorfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &apparmorfs_context_ops;
 	return 0;
 }

-- 
2.53.0


