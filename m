Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6219E60A260C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PK/1xJP3
Received: by kanga.kvack.org (Postfix)
	id 703926B05BE; Tue, 10 Nov 2026 04:16:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68D216B05BF; Tue, 10 Nov 2026 04:16:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A30D6B05C0; Tue, 10 Nov 2026 04:16:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B91B6B05BE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:16:48 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C5ABF1A0433
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:47 +0000 (UTC)
X-FDA: 85418654454.01.50B4346
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 20C21140004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PK/1xJP3";
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6iLMVu7/iMBDJai9Frtaq88BtgFpmQIL1GiZqP6G3sI=;
	b=BjJlOsa5die7Urh+dR4Y3f6FpgrjgfVeYsmRvNGse1FUL2s0Jedc+UVOyh9Y5HCPLnmJuD
	S72dshTu61E04kQ4gXCsmOcgoVT5M9N5jz0chTm3y+b1vtlfQnrdsJX2c5LC9WVF8ZY64x
	6VXBa5Ls9gtdybsbiQxxTp67O0dWZUA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302206;
	b=BODSfJhPjaVPJAiWGfdRO/+G5tn7Hw2/CukkkYzr27l4wBvYDRmwvW9GWD+YbX8Usn5SD0
	kfG3EVrBTfWIbRv2MYnzfs7VGtZx5WOczC34noz9BMWswA+qpQKAn8s+LbjnZ3We2Ns9z4
	Ocn0UXvK3VvlBWg4M7ENrSM0w/Q88wQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PK/1xJP3";
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FCDD469BC;
	Tue, 10 Nov 2026 09:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40961F008A5;
	Tue, 10 Nov 2026 09:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302205;
	bh=6iLMVu7/iMBDJai9Frtaq88BtgFpmQIL1GiZqP6G3sI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PK/1xJP3LiuE+nt9clqn6XzH1ykuCvGLk3pJedYJU7MenGMVki1YReFMeqHc2zbsn
	 f172wPMgNRu0JWSTlIgtjrHD4rRAL5eo4520JocrDxATE3L3QlkqPhQ9KQk+e2lr0U
	 Z36S4rtp/Z53gBsFmJhmg4BkAtm0NXKKNbbu/pQH5R9bFuSUNl6MT1vw2mzIJB+cHB
	 GEBOatAxu+reiIAHlIkDGmUecEYVk7FAdx3uXRaXJYFCUAdz3m+wvz8PXNcaKaCVki
	 JtIsqDglq1gfmT2kaiK580I9+CfdeeDheRHydlXbZS6YOU+oHBKlCiswiLTGKFt073
	 cI6f92QGFv0dg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:23 +0100
Subject: [PATCH RFC 07/41] binfmt_misc: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-7-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1237; i=brauner@kernel.org;
 h=from:subject:message-id; bh=UVUPWAqqIx2djk703y1XHtcvgboItkTJfb/9RmtQVkY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9ejBn84pzm65G6TrPnLRrvZZh1ewlwVPObmlaECUjK
 7ZLaeoizY5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJ/NJl+MPnlu8e4KGSGHCt
 mDNIumRG+SSJIzc+6bMINy6T/Wpmeo6R4ej/ewWKW0xWbLL7tadJ5iOL4pbdcy4cKXfp5/DfHPj
 1KQ8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 4y6czh1uscqxu8x8ztjtbggwzh3z6dq5
X-Rspamd-Queue-Id: 20C21140004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794302205-133641
X-HE-Meta: U2FsdGVkX1/IyjijWuuXpseqe3DPqpur0Q4rKjofAGcN/wCHBv0tOdPO54hx1tgNnChH1V4lrFsO9Cb1Oz9RCJy7nbjIzmgxpkKfSAD8sbmmPT4+MUZNxTCRAlvtwn2fKdROxFaaN4v7Plp+WEa6WPDFAyFIpsXAJs0nFxlCS/kfx9Vt5tLls8OvsRWwRUEs3QZQpeoyEQZLBGW5ofzM4cHFJ6wf/KwGIJPw3UArw53375tUxjAyECIPSz/9LUPevk68n3dtewe9CyRHK8TanpGpSYvWNRoiN2ZCD2KRhN43sJ65FmZLCshKvSgYuIxK53x2nig8qnX3NnYlx0VB0b/DN54IYBub1SZvp/2pLYjLtlygAK9WFwl4PKxlwZK2UD8/D9US1j8eZfmIgmPLrm0jFIH+GaPgif0a7N41ecKwjc9356+UO/xBaFyawyVR/BT/wQDMzino7a1ZPZNTDAwrBz4si3+vr1SeHwZLVwatyORRIlVM+9Q1yvNCXVDd4ETHXU3s/cipy62xE1rfQ5Zph/MlZstUGzhA/jmWVmY7lCS2ShpIjheeQROSNVS/zV7ER9oUrfIgCZKh6PX9AxyczpAtQtJcHMU4XmEvMXW9gGzRALt/l7/Vy6YNRJnUGNA426bXVIIz+rBZ82zjAi+liDvrEy5wexIX722r5+wXZvqzlI6Jjo+9W7v58Z6vGWTq0u6d3xFpam96vhbxpcMlA9aHzrsb+50Dvh4UKgHnfHgzPyCO15fyNCGMqsZZC4TQnFc+rBSfZxAFVuSvTmWYcPsatfAGmdCVpUzA6rwRhrjV9u1ze6QxTGwg0hwSGySl/pN3fmlqqOWhF7Z7+u2Er5SgPmPokzVhekELEfS+eWdZgLp1xkaAlFOtHFVcSy4DX+z6tfffg1h5up0LXSE1OSDw8oroafaC5IGbpA8/6Ah4pNSdPIv7CTRD7UDFMEqstZzamoZLANyOXeI
 UCbovWTQ
 3TcIJ9eoFrqLYXW1+2Z3oqxM6/4g8QXz0a28zXjETnQFGj+LMtCx5ShscgFyJOZuOIf/remtQ/LomxQzFzmdQMT3/c9N+LMTPlMCHwdJnB1Q2XZ4xRgvHSj1g8lJwgDCmqI9E330Vtrog/OB6gdKe50Wh9KZF4xsa12KDIAO/gjYRtqsql5kr1wdYpbpk5Xu4rcAQ0Lq+K5u88SL86llhBHs9SjFRn4BeEWjMWELn1pIhbey5yuRpeOwxq2xHjNeQC3kCR/dk7Si7sTW+XYkCZzyoW0VYRdpFhlfcO8hVf3Mr1EsLmijvbS0HG/1JO6JjX1E0HKNmxDL4Uv0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize binfmt_misc as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index d945b4f6e158..7dc233becd98 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -22,6 +22,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/init.h>
 #include <linux/kstrtox.h>
 #include <linux/limits.h>
@@ -1575,8 +1576,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (user_ns != current_user_ns())
 		return -EINVAL;
 
-	/* Never exec off this instance and never let anything stack on it. */
-	sb->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
+	/* Never let anything stack on this instance. */
 	sb->s_stack_depth = FILESYSTEM_MAX_STACK_DEPTH;
 
 	/*
@@ -1660,6 +1660,7 @@ static void bm_kill_sb(struct super_block *sb)
 
 static int bm_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &bm_context_ops;
 	return 0;
 }

-- 
2.53.0


