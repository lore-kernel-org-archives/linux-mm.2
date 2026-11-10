Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 364BB606F940
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZazHNZp9
Received: by kanga.kvack.org (Postfix)
	id 539A76B05CA; Tue, 10 Nov 2026 04:17:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2216B05CB; Tue, 10 Nov 2026 04:17:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D03E6B05CC; Tue, 10 Nov 2026 04:17:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1DDB06B05CA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:17:36 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B63B21C2F46
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:17:35 +0000 (UTC)
X-FDA: 85418656470.04.83A7FB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 02C15140009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:17:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZazHNZp9;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302254;
	b=4F2xF54PSHpAUbJ0EQiD8UOmEYKTl+ipiu30Re19DlmcIYhcXndcm93v77uefbVqfO/2Fn
	qMRIT0bbMkSbDG4Erqi+amCgu3zpL+MmaNbdvOwXtdFosikbU0Gsji7lIXl4ea+pfwC9tQ
	/YKEgQuOY8yTbPez2UdGMMIn2URBAy0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZazHNZp9;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=is6/oCzWlYT0dy5hhdJaeL3p/9SOujmsKB1o+eMmEtY=;
	b=05dPxfwPeZgcW3fVJJYH2duEp3HMEEDrHLFBTqPpl62fUSBvHeEaJdLeT6K8fsXz388G/Y
	NVuSFE3K3VK99rrRsGzXKdd+NG+ZCiWsxcEPT+jbvZ72c6NiDuGm0WdJZN4WhFwPUlUL5S
	W1g8QcTraP09eJUKF5i9AB6sDkw/yEk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5531D4166B;
	Tue, 10 Nov 2026 09:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0867E1F008A3;
	Tue, 10 Nov 2026 09:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302253;
	bh=is6/oCzWlYT0dy5hhdJaeL3p/9SOujmsKB1o+eMmEtY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZazHNZp9OYbLw5mOghlT7zT71BJtkKFeTeYcEEEKzzDfsXiViM/CU7Z8cqPuBHNmQ
	 e9Qsk2tN4gY4RJ80Z+UUxi9qzyvuPPNm8ps8zOEOpz7rLmAYJ6n7ctVBBlUT6hriyl
	 KooXsFO8OBY87qPing6B2f+iBZiovte1ZeeWe7o4pK+dmJB9iSNS/HlIBxl0Amx46b
	 gPvb9WPdxrBx6TvqW3glbSTH9bY6q5ObY70N6N4qYVjM2ZhX+jdcQ4SzRPts34JoOG
	 w3dAqOx+U6EfK5Jcx8iiCprAhcZ+V/vGt/hia8DQYE5ftDBbr0PZ3CyxQdoj/Bvs3n
	 V978BIl4Z9EIQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:30 +0100
Subject: [PATCH RFC 14/41] debugfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-14-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1035; i=brauner@kernel.org;
 h=from:subject:message-id; bh=MkToblHF88kh8NI/b687M2tj3J3ly45eToQK3A7xE2E=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDEXWDJqs8a6Uaz4h5pdum8snm92LRlGYv8/rrdx
 ++tihfu7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIXgeG/7nTnxz5dOX1QYaX
 PAb8ovMeP3CTevdb7d/7G5YRbf0/Nn1l+O/6l1t14a8Lqh23G9cePX75b+SKyohL6acucmz+3vh
 s+zYeAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: msheuxitdjtaxojpbr1ord7ucrqxg9yc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 02C15140009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794302253-707881
X-HE-Meta: U2FsdGVkX1/NM1/kdD+URRJfl3XZJO1cGn0QOcawlr3/ema01mhibxHp586d9jt21kM2PUZGtsDHgQOVSdbgUyUjBJlJeha9HYfRwXPuidSjW0Zec984xT1IovWB/S8PDvD0EKu/fpRpIhZnahsxMXCTqObGmggDJvFymj60L+U8WdCct5t8P3Yn7mxJZy7NcJ8QZes+oqAJl7iuDIOx8It5o3zjNvWg+Cf/GsHJ0D6PYoMSrARjZK+SA9CSBuS6XkRfKw0jSI7g35x0/nGFsCZyG0gcjSpMVxFYSHIbvUmLTYng2Q6lI99wFlykaiJENJ2w/DGD98dVMzP2CCsFMCMw5+su0sW8tr4R5MwB6+YeoSuGUM+AUbqeiRutrJDK1S9WZomaZc55KXiZ4I2p4OYP09CQFFTJMUCrxQn/+081Pl7AyncDmFWaMsJ/DNYwM3WDmBoEfzPCmOHGozGSYr7MDdG/CfE4xChZhcQwRbuSUAExvolUgChpVj5vP/h+4eEGzQXAoN3tfBb0ffJQMI14egi/TvjfJqhrdvpz9H0OA07jn6oQiOJ9Sq8dozEYSsIAuenR4KrYABAGlOdXRIZ7t649U/kIuU0OH6eWrBlHuYeX/1/dCDqIcaj146mm/WEg7E86REwSyVJIvNx0OOaIdeLc5ERbfrhP8Gw5q/18hQkNtw7AnAxepjZCROGfhpNVD/g5hSMiWAuMMq3/LHiP4HDXpjFLziKv7ka3RsCSK29TpbycQZoilVUy2kBMRacp8IW08MYw+cgTDb9JmpClbaSKBp04mToaxtp03OWbf8Frc3Xc/eKZ3CGUTkY50OuvQPBt4wTYT8vZaS/pNeFq+rrb/CVOIeRGQqI4/Rv6yIdgyt4Xs32ktj1m1DooJiZwovoKERD+IaftndBynJRnFC4wTEz/2m9eO08ki+n0yJBvWST/0UXCtXq7y8YtCWy+T/KUvC4Tnzq3xNp
 Irg4uYEM
 Jw6MpqGg6BOy8xHtGOQjOGeT00RXual95ebUVh1sQxBrPtvAfAfgxLyiy9DPxFGCINwKjUk64LO9BWUbPZ15ot28uvDjsczsWIZzCznj18Drtzc0/ls9DVzVe1FrVm6b7qoMdwlRzYiYcXWMSXQCXASc1G0co5DwmFsW679ewA79p0XQedG9Tl+JQWRQENkpmtZE9cEtZ2MEv+tA56T783NG4WnRA+miKOCycSn1uDVM9CiEYP6/Ucc39pT/jZ5Olu9NlgNgEYjBKV9MSogHqicvvjW/7s3hkJEKH+LBcNReN9WICfTXYCNLHB/EQzDBtXQni2dBQ9jbK0Nw=
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

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/debugfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index b4915551ad31..f163f0bc5703 100644
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


