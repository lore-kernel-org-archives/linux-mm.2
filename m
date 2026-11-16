Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D8FD607496A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d4AsBCAD
Received: by kanga.kvack.org (Postfix)
	id 5E9526B05EB; Mon, 16 Nov 2026 06:07:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598D66B05EC; Mon, 16 Nov 2026 06:07:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487C86B05ED; Mon, 16 Nov 2026 06:07:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2942F6B05EB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:07:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5552C0928
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:07:52 +0000 (UTC)
X-FDA: 85440707184.16.D93FA0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id D8879140012
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:07:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d4AsBCAD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=noVXPKL/og69bpc9W91xJU4Acp5mP0BVhDE9sjv3SIE=;
	b=EvGfi3NgC5GPzLQe4odM2HZgJnx/0E5LSEZ53kbSd5cO8UclmC7dG6Hq5g2E7AcxYk5wkR
	H3jYqSWNJMVfw7GFmehZKcsCGe50wMUwVQzW9Pi6STbapKMrdAWv6D9TPVggXxeijxdXEy
	Rh2LLieSM9fzpqiPLRZy3rJwOK0/8WM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827271;
	b=Dlhyuf28uCcduDatn1ufs7qbR4IaBr6L2S4G/OC6GR3cDvG/NsSj1H62fk/FgLR6KaXUoe
	G41SrHfpcKT0sC8b+7UN23mG3BC2fD+UwWrXmZN9wCP/lXRYywkdz7l5k4fz/Wu7+bhOmV
	8c4+jwAgTGRxRznrgGqs/co4Ij739E4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d4AsBCAD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 299E9462D9;
	Mon, 16 Nov 2026 11:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09EA1F000C4;
	Mon, 16 Nov 2026 11:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827270;
	bh=noVXPKL/og69bpc9W91xJU4Acp5mP0BVhDE9sjv3SIE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d4AsBCADtblGWR9WmNzc/DEiDFBjSUivsWERw3pTmg4xXqpyh2WyGQku9f8392N4s
	 lfp7IFHxwJWFFx4/59deH/zuDtHGCY6wN7yNaETZqW9wHK/nTklbztbkm3Wwcrl5rs
	 /PJrwjLnB2b8CQO7J05TacPexxC4CdTFDq6H0mUnYoCkhrcI8qk+w4xvBTttcE0blv
	 o5BvIuIcseSCY08bFNm0BzpUGXQUSuzvPjVlG78Ls3ZLMo4LLkvGz8bdDEukYq7Vao
	 aHiqggmt77TpKf0+EPd6nrKM/u0GR6gducTj/TJI46cLCwmRKEJBv1/6Cyuu7zx5LS
	 hfk7yo69L3CNQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:47 +0100
Subject: [PATCH RFC v3 14/44] debugfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-14-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
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
 Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1179; i=brauner@kernel.org;
 h=from:subject:message-id; bh=BMUOzEt5tvGDwdfnxxzb3r0lJ0rbiII34CFK/yH29Y0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epxnx7/ATlD2sfyF6Q/Ob+LauKkocK0zM9/G/RKir
 je4M2+zdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk40+G/3WuJ83uZj8TS2Pv
 P+y8X7rLQErNXSRM4ffcO+2RcrZsBgz/k29eZL535s1/3bTPB6VDJWd2vyq4ffGpScB+y0nHBXn
 MeQE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 4yzy1qpk35fwt6w39tggrmgeemzh4ntw
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D8879140012
X-HE-Tag: 1794827270-674415
X-HE-Meta: U2FsdGVkX1/fEwnlgYFkBdoAuMDujZueBU9lMF2CuOZotNBXcezjDJHPm2cEiCr8ZCGrKrgY6+L0f/aIGr0xidT7gMARs5naJSCuXoMOaW6T/Ht6nASFeSTDNLBNNbUcquZ70/AkY2nTv5jfZZqlDfSQoXIszjf4YfavWUlGC0fNydBOjVBVp0JsA9XtjXWnkMhROHSkM92JAemRE0WJq4miISzGmcL4Fag5PhclPR9968NCIVi79prIdMwYdYc3Gmbj2fsxS7O0ypfwwv7U13TOSSXdRUnMaDivu81ZaHNvZWzNNuvZdmaECh/TYS4cp76YxaHNUFuV8p8yCuVjHUebZ/ywU1OHbyaUoEp+9UrOOIXkT6ntqFpMZ6Cwbh2rRGhRUmCpF+nBxZGtcU1UAc9/Xhsu1NeO7qWAoMgcL4pQCVOG4ud+/n9+CMKg4hCi2REbV4BEgltUS2Jkiw+6uXpUywX/h6c88ETue5JS+VbscpfKAqGRYuHfLOT5VetyM7hR5N8UCrWLDsl3tPGGp+pyM2SOacViKqiPaKn6hUGnh9kDXyPm4NKrxklmuEi8/luNkhEhb611b+iQJ30KAawKwa79+8nqje2sC4JEs1IaRnAuLG1MkTsgHrPZHO+3QICcPbmEgkgp5ydzGLEJXUD86+IKye3FfWam6XmG9O5kzOso8KIq/DClMeDqasW3F/+Xfc3p9/kgNRLkzlog9kfj0SjH5p3QBA72JCFhr/v+usiQOuhLmxTFjldfvD14zA+MkeWZKGwUuwWt7Ul29JrqT/vtF7hotZc7H6brATjNvVU6ikNxCG4DAYQ/zK00dpM3mXWb70wYfiZnxUC4bjlGn5W2NHyi6iBh961gLejhG8B30L+NxeIyd9r9z1IEbh5obY2854cFXVO4Pxxgm32GxsX9SkjXJO19wPyUkGhffo+S+GCYSzvI3anf/8Es5krBiFqRDZNzbFf5/0i
 UO56yVA9
 +7rG68ORRpJpSIbiGQKGBHOqlRORHxBUrWCpTFoAuiwa2w02fvBBh482SCFvVnLsWsECAg79sEF49dzTbSGWD1LovvztdHtLmBc8KkhPlzpQSNZQ+Y4KszTBH7Kb4QLRvj/xkeZ/WC1RCa0l1rNF0xCHy1dE0hv1waT4g4/Fmaq9DiWOemQN+NPFB1cZioxF4OVEqF0GNWlqMzi45Ll+SLIxGrxqgiNwgpKlKqxiPuw/XYBkFyEknGcVuVBRb3SCzsCpG/EuX4jD4qq/bcPNxVMeN/KVY2L8JziyrZEWRTq2gCI1MjBpva/qAj7HCZXbtmPROX4MZYVq2WRyIm/MzSNOzAwfOk3Nbqhh3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize debugfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. debugfs never holds executables or
device nodes.

SB_I_NOEXEC also refuses PROT_EXEC mappings. The debugfs files that
can be mapped, kcov, relay channels and powernv's memtrace, map data.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/debugfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index b4915551ad315..f163f0bc5703a 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
@@ -317,6 +318,7 @@ static int debugfs_init_fs_context(struct fs_context *fc)
 	fsi->mode = DEBUGFS_DEFAULT_MODE;
 
 	fc->s_fs_info = fsi;
+	fc_init_pseudo(fc);
 	fc->ops = &debugfs_context_ops;
 	return 0;
 }

-- 
2.53.0


