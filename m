Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81427606A332
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kTLpHzIi
Received: by kanga.kvack.org (Postfix)
	id A455C6B05DC; Tue, 10 Nov 2026 04:18:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A14466B05DD; Tue, 10 Nov 2026 04:18:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92A906B05DE; Tue, 10 Nov 2026 04:18:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6FA5D6B05DC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:18:51 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 15FA0120212
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:18:51 +0000 (UTC)
X-FDA: 85418659662.27.39C614E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5A8AE140005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:18:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kTLpHzIi;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302329;
	b=YN1Wn4rGVKfoUsDaQcfs76Yo5QaXQSE+gOiS4GhTDu7YHQNf2T3Ym0algMSIjRw19rVU6y
	6Kr8094VPpHmI3JmPTW6QJCz24xYu2iS1juLVv0BAPJASjr81iiD5B2doHEFfjgmNvHinV
	7QISJ0JwDhQ/DL6A5Hh4p5VBkzaLJ3Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kTLpHzIi;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gl42dR2sxHaP3ITJS3b/B04ib5WpCUL9VRtP4KLsRoM=;
	b=1fK2fc4iw+NTpnUr7NWbbgh0KgMHD1iokyofm9Q0pSedCd3UjYqcx87eIWrT3PrjgxunuP
	KBrXSxWJKI/2bhI+qYv7JRW8N0L3bXwQpqqm7mTQcEqh4ugJj37DHyyeyy/rHxfKwxUcsk
	Lv55htWvLI3MSV5Z56jYFV880TJzdRo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DAF6063808;
	Tue, 10 Nov 2026 09:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CC51F008A1;
	Tue, 10 Nov 2026 09:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302328;
	bh=gl42dR2sxHaP3ITJS3b/B04ib5WpCUL9VRtP4KLsRoM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kTLpHzIiEoHD/GMs6J5o0BY79JvOwuUY76u4r4LtuPpprEn+sEXP1gtvybcHlSLtT
	 CmJYU8iAHI/ofaZXWihJ5XxShjsnWfKREnaREBGEhVpJuVA8UxIujLE4opfHxMa4l2
	 4bvvQUPUjvQ2EsFdGM14Zv2VXWcqMXokoHGLWd7/ZTwsxC4J9iKJbm5nnnjuBRICkU
	 3Q/oQzewdcDhdx+fyfkGitRE0raCCijhxDU/xYg/eIt2ZjWUYaKm5ljV/gc4aZMDUG
	 Xo7ddzkxLrqw+Yw44oZ3PVfS7jJUGpuyM3cYrfutFlXsGLkg0INiBaZLGiYPLlJfeW
	 ZQQCq/yJeXwMA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:41 +0100
Subject: [PATCH RFC 25/41] pstore: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-25-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=882; i=brauner@kernel.org;
 h=from:subject:message-id; bh=JyexvfbQ5pzTQXeLd6YfvhDNydDQY3kHD9zcB9wbg2k=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erAx2J15TcWtFdu9W+eIHjgye9faLyYyW74GeK1Uu
 /LQcab9to5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJ9Nxl+M0aJKtZkDT715G8
 vUqnmxUTdvZHiW417mNNuXFzkjPT9FuMDEfPTDuhOseiqbXY1vy/93S+RZWzPGUXneAoPhv++bH
 pOWYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5A8AE140005
X-Stat-Signature: pn9f1cfdcpjc9n4dntdqypf7hdkeu754
X-Rspam-User: 
X-HE-Tag: 1794302329-419263
X-HE-Meta: U2FsdGVkX193KRCVrYbBXDs/QY/tyHCn6nnwfgfbRQBtvzd4UQua1r5GccwTky+wRnWUk+fkXgwpfSe+fI9QXW90V3R5pG2T3B5rr14/jDKhrUT8MkoS5zr2X8yMrRboGni3iVHX/Z+ylACfcFLolqpyPjRUiOKCsT8ERz6zSpcKNnM2BhUcchNYx/HfAaVSeg5ORhu8p+9K/KPzhY21skH0aXpeCYZIKOIzxMqapoUsotktLKGbgIEAyAMHzX6qIbiKPBS0bYbqD+liFfJP1h2kTYAbdTp/MTDnVEbgvrkdnAqmcGM2yELVxf6SPMBVCIOcXt+7OhJQ3pGYqDMCB1eQWYPnVu4UFuvEh6tSr4PsaMHN+lUiyzr7JOiIHt2SlNav4Lk4f5Y3UTTpp/LyfqHO1v6BiB7HBLrEvhObRSU4QzCCXa4tKndCQBwWCzdCT400seIo2DzgL3ggf1SqfHhvDSUb5J+ACG5HKsuEgEPpx7MSWehDcdmgjqKaWnqEcwQsAMFA3S3ZH5KAFZa9DCeXiPUVsWFdzldDjYE2W28so/42MiAYX0B5/pELfwKMErnzgejOAwbN9MeEcdXJ+0NqHhCo6i5McKab3Y0PlxLWwFNTwGHEOOgjKbRKPbBuRsjyUfkH5gW211ZJ8wW2cQwBfjW0pSvxZut8kXh3vqgR6iHeZg+s5/k/nanOrIfHs04AVTrBhCz30AYZmfMf46m8hIF/CP+ECscYbZKFUNWMDhfS3QJ0UnohOIvbmvMA5gxzpkJKLs9KR+kZjZfN5MOAiRa2WMAuBWwnn6cyh0DVRqww3xIkT++1Brbd4ZDv6W/7OOtvz+MRUD+16VVPLzPMEn0/BXAum7USxVD9vpqZ1wZSlchuUki2/lsftoA46Og+R/cbRMxmSpil7s8qg1fOenxIxRdbeXfOPEgIwUYqWQxt3nkmXSo+HnWIwdyU4C6WxoARB+3WeBTlwzL
 23v++B5I
 qTNuuABhyUmi8v0i50Fc/5ur5gZpW829ulFuB9Kcb708OA3D8lfd42mEBiMM1esIRFOBxO5/jS+sN5LLVBbPSMA/s3NtmRBDB94HbpcvWePwqHi8xkd9PiohWlnmJsE6vJAPw9XjsJCzVC4083ohKOBFM0i0jVXDJBfgUJ7vUsSzlaXNKRK66BTrfE7j7VKHuOgrDI4wQB/ajexlT6aO+HuMzy0u6jq8rNqYOJWq8/yjx4/Xv4PhUd5u1KMaXOV9nUJXxioBmeOSp7T3WymKGacHREvRAujmR7I3xeiqI8bvEz+tmflguv6mSbUsTEEl3m/YArcIBhKQJVXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize pstore as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. pstore never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/pstore/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index cf499ba72702..4658561cf90b 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -18,6 +18,7 @@
 #include <linux/ramfs.h>
 #include <linux/fs_parser.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/sched.h>
 #include <linux/magic.h>
 #include <linux/pstore.h>
@@ -491,6 +492,7 @@ static int pstore_init_fs_context(struct fs_context *fc)
 	ctx->kmsg_bytes = kmsg_bytes;
 
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &pstore_context_ops;
 
 	return 0;

-- 
2.53.0


