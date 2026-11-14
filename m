Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FDE96074965
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dlOT4YO5
Received: by kanga.kvack.org (Postfix)
	id 45D3E6B05E1; Sat, 14 Nov 2026 08:09:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 433B96B05E2; Sat, 14 Nov 2026 08:09:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3236D6B05E3; Sat, 14 Nov 2026 08:09:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 123F16B05E1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:09:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A12C9803DC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:09:03 +0000 (UTC)
X-FDA: 85433754966.03.B438D8E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id EF3B540006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:09:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dlOT4YO5;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUBUitc/wTfMb7cZo0KLtSOkDXoKMBIaahrb6Pvq2WU=;
	b=tPagYSP8b/HRSG+pu4Oe0JHQW40Z7xNwegYqr5Gl4+nbBAmdVuoKmjJtdRTkBivETgZU+o
	0Y54DtJ1MfI6PBfnQY/KRkg6iXIYiHhg8tD29vdjdoH1Tat1pjZuAgo4+cARNUNcESfcSC
	VaGc1cOu25veQNq9kWsOfGU0JUSfsTM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661742;
	b=z+fYZw7MglH5FnlUNrKzIa9Q9Mr2iSrLs/OYEbSgG23rj/q0sv9JB1+4q7+riVhCPxqBzc
	NF3CqqhUFW7po1UDBA5O7SP822w/3XCe8kXLNo7/1EjeukMWXe59uU6asppZ4ZzlDLKyJu
	DhMdddiaJYHb6izUbMFz9BIJSdX8QFw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dlOT4YO5;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C0996252F;
	Sat, 14 Nov 2026 13:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29D71F000C4;
	Sat, 14 Nov 2026 13:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661741;
	bh=JUBUitc/wTfMb7cZo0KLtSOkDXoKMBIaahrb6Pvq2WU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dlOT4YO5RUhq//nn1mQfQ7uOlDeSIq5sssMs038ZLPvaS/NPy8Dd9kK6JgIFD36Dz
	 pbaKu0DmFSuCCYRW1H64pQ0+m6nqqsSc1Q9h1ff9ICae4VWI86+QQlpB4OVxciYpOR
	 WS2ftQrfKT4rvIwCLZSKiVCNFlea6iSt69CtGZ7qjcOt9yahpM2SqQayK7CrApgHSF
	 /ZgQ8JKhCJKGzp6iRqEmeIMd+/DRWTit4BCmJyFLKQdTK0auEDWhyzWkLdOk7NBjOR
	 dFLtiah/d1hBHwXdufprCHe9iPnbKhpmiiCOpc4bqTjZ0cGwlKuZ9Vy7R5WvJt/oit
	 calDZWfHw6uKw==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:10 +0100
Subject: [PATCH RFC v2 29/42] s390/hypfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-29-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=900; i=brauner@kernel.org;
 h=from:subject:message-id; bh=EnQ7f/LKwwXo6PyRpnVfj7bCGw1qYUMZQQO6IXtl1m0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iGnvvPFlftQB7ZsfC97+fWh+Z+EM5e8fnz6omGjy+
 1HN40e5ch2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQATidZjZFipe7RPJDUn62fQ
 /TkHXz1TvOM0nXPJoowHKhln3kV1Br9jZJiffO/flXWm6T8ffDBjOxkgvOBdhEHUvXZBZanc0td
 ivqwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: 48x7sog3ztqjsqbkqpad7hyr5kxp6sc9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EF3B540006
X-Rspam-User: 
X-HE-Tag: 1794661741-840737
X-HE-Meta: U2FsdGVkX1/bizSG5QePbwOE/+ERyDULZFqa62huVSSBzrfLMV9ylKAfvCQNApvw1loa8lk09trxsItk9azWDenUIbLeo/zIz4pAapVe4258/n7mUh/177Balopj28aY6fKEZAGebNS1N3C7LV9CPmWHbAgiDkcFgQXeGPhUKVWT2tPQkVFRcRXnzMGd4nkt6S+vuWch5y/rBjDmTCL8vQ6OM1I2KPQUOKdJ8eoPQ7nqNM+f9mjjrwYiuHqnPtJR2eVVAMZ47OFmWJKre1r4oCCudDiGqeXi5dbn3cVMbeEeFGa0fQ1dRKUb0g3hliw0f05l2JLYIWBROB+QZs2oVtkdO9fcm+5YqGCMQe8hZiQ9WRjIMTImMpQBMV++e2JWFUMKG+frc/gltfp/qBpbalWX4lY3mQd5oA/MfGnj9BGH1nrKf2k13NHmJFPynY8bS+WMawTfRJmyuS1r9YMyOZQjdZ/hJqoiHpPn4FT7R3HPwF9QoKi8RrYoeXo6BsglkXNK6hDUuRUOYiPZC44iEv4m68Ojnktcg5xA8hP9zmD/EzQAAqhNO9NWdhosjWeQSX5RDyINCs1DaSCMU9JonS+NMcuRnTZgm6tA5ouGi6+DpCTXKQ1DfrBJlpqv7WQ70GShAM94mnyrY4ZlEKRUmgCE8l4n7lse9xktTtvHOdff+vA25jf6ciRzBBDREKw65ehIGRX+tqT9JYzkqCLddrslhxzKOUA+2tiA6VjEl/Lq1Lh51IioOHaOO0+Zz/9MZdrF8Q3ZI+xrb/OqqIx6KSrVeRW2Ezf/FkM0cgQ3xDmurSkveaAIQHQs5JAcIx3I5cK3CacApATAPJUl6I+7pE5rv8p8jVg4GLbPn/E6HTfaBzqo7Wjny/wJq15tnBZ9kYXbFaHleewTGqfzQUVkO8X1m3VLBkkR6/sG6/16PkKcAt5ISC6/3XWtMcpB5tw8rjGDR8OL+xgZQJ2A8aZ
 fJaHJQo4
 26ejRi0n8mRVeHDvMRFKUJmCYKzZqxQmyay42uM3Tay0VlXABtIct/F7vJoVChA7IajpglcRqRetgxCVLrCbLmAJ5dg2vL9PMLL6aeFZHeffkJU0MYk52veCKpeuVs0N6CV4F4jgcLJwjdpKAcueFcGc9o3tiKfis8JzW5QUhDh4AIEnPkewiBXByJLx5oqsCyt7/ht902Pa5otacicDn6Z6ilz9F83xdD6HeU2ygBMeXHAsT5D88KxUnPea7nV+9JH4VZyGtDsTKlCkMrkU9/kMifHGcsq6BpHRHs6D2cpn+ByZb60PCHhz4KYMBLnQK4rziNobaSdTASwnl/F9hYprthykeFQoVU1KmbIaizASBBwc0Id5huw8SJLQc/byxEh1R8TPbc8mx5pzo+emgCDmw8SaMGMOMjAGgdcuf9hzWZz3ofuS31cnGvbWQ84pBOPJg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize hypfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. hypfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/s390/hypfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 559b011e68800..8662169de477a 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/namei.h>
 #include <linux/vfs.h>
@@ -301,6 +302,7 @@ static int hypfs_init_fs_context(struct fs_context *fc)
 	sbi->gid = current_gid();
 
 	fc->s_fs_info = sbi;
+	fc_init_pseudo(fc);
 	fc->ops = &hypfs_context_ops;
 	return 0;
 }

-- 
2.53.0


