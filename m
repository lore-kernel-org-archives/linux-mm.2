Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0367E6076E13
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CBYYTwmq
Received: by kanga.kvack.org (Postfix)
	id 2B6B66B05F8; Mon, 16 Nov 2026 06:08:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267206B05F9; Mon, 16 Nov 2026 06:08:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156BA6B05FA; Mon, 16 Nov 2026 06:08:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E88416B05F8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:08:45 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A7394093A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:08:45 +0000 (UTC)
X-FDA: 85440709410.12.FA81941
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C0B0E14000C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:08:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CBYYTwmq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K02XzgiVey8Gk03FTq4yCzsjgwwRpaqpi89MgT4x0oA=;
	b=xxZ/5qidrx26lqcMwXoeWnJe2X4f/eeY/HZ0PsevrONC3j25ghrYXOGxDUE4/MSvFW5Flb
	7zrplGX51QbwqVGyIsax6RVTZocEpj6bFHn6ldb7CQMQWeHtcYr/Edl90ArJdnkX5JdQxu
	s+vKxjoBwbwvGlMee0dRHcKR7xrtFcM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827323;
	b=CvzUG9gPlyGXB10R5zJG6dz1DBivDHokl/Oqod5yglyReXX9pZsti/WAFvCXYImHx4+k+p
	HxfT4xpMMAQSf3/2Dts2U1OUyragYyW6kbrRWvl/XHtDFGOKZZ7pgkooSS831+bFGHxuAH
	ugqsZC7x+oqYMw5lMLKz5FnAUx+1ANs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CBYYTwmq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13153438FD;
	Mon, 16 Nov 2026 11:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65B61F000C4;
	Mon, 16 Nov 2026 11:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827323;
	bh=K02XzgiVey8Gk03FTq4yCzsjgwwRpaqpi89MgT4x0oA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CBYYTwmqvG/X7Q1l09jl1lt6vhCiE5IixemW81zB87kv5VWwVCu+tjT7HIpe5m/Ic
	 rxTmpOcLM7fWrYpsIwJ8v9k3Sf119xYtmjZcCDB7XbSsd4ABWeI+YsnncIXfWZ+/TI
	 xyQQQn1PI1wVSECNnc86kj2hevZ5aF/XcQ3GcJYqC9a2J3KgM2w1fVfu9HwheK/PA8
	 hisUgw9t5Yl5+t7FmbOe624VXKlLm9W5/RFSY8WmooHM6Yob3+/hUP5CSs0+2NwMPt
	 KJfFm8q2GyauIZaZ2VNRQuWbKCc6Y0kY+1prHY800HPVjDEQbg/XtxqDqCAofCoKqG
	 B6ZtxIV9ZkJ9g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:54 +0100
Subject: [PATCH RFC v3 21/44] nfsd: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-21-8cbbea1cf34f@kernel.org>
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
 Chuck Lever <cel@kernel.org>, Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=986; i=brauner@kernel.org;
 h=from:subject:message-id; bh=d+yGSgu2S03C9xQeqDtaPfOPhebk0oACv2/eOKg0Vkc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elyumnaqyWZxzLXpTtpXJb5GHHixO+VpRKQ1z1run
 Tz5M3cVdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkzktGhrd93+pWM9fyhmS/
 MygPf3Z2QtHdrz7etVe7fpe0f5yn2MzI8OdsYFzH1ZNi1otv3d/007j7z8WC0v3yYseyfBnuV32
 aygQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: n3xhubq67wgtsyp3ik5uzx4kxxt7yibj
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C0B0E14000C
X-HE-Tag: 1794827323-784629
X-HE-Meta: U2FsdGVkX1+EJ1iM5GX9UhZRpc/7/vgTvbSYiDSrYSh1f+KrC2PC/uGLZqLi0jupJrZJrX1sX/B72S6lIa2ib18ZV8+bSlGe5prLa8LwMX7zABlBp51WN84eOuUuVEfHZEqXcbro7NrD0142UcQypmZV8FP02L3fINjTXL4Y3LR8SKoUZD0nuw0l+YhOOHszUzkKxvBK4nYYQ8rfl6nyKuGhiK+gmED5Gz2NctXCcPSQiNGn1ysMVj1ml3Cy3P8BfExOS+LkaiqhdNO/m+TVBaKgs0JTrT1Vk8leKm1QaBJH4mldTVtmWsH0/F1MdOrqpTfvDL2TvVfyIr+wz5xcjYzS8v4G0Enfb1aIKBIjDRYqNS6V0k2gJK/ry6yrbhTYovMUCZIkcLXaJXwkGGDk742He5tnjjC9mXQPJABsh477yPLnaGw3xy0KkpCkfuAVMIBVT9z7r27A4Xcnil6GemSgdE/p36S6A6Dck58zRwSDsbmUpOvGPk0+/15Ez6QGVoSpnWLtWnWn/inS5tetuKhwMVXdlXFivq0Dus6l0E/TKzzvcfY02qd9/8lKh2vWESP8pvm9JJ2rAIEWjTz+cvvMjw0ZUoFBvh7VDmhsPavKBcsad7hrOk7zKkI5W3avsCKwojAM+WTID5yIvtbulc+UBCHdZWEF9Tu3bBb8UpYyL+6mi+hFh/hBsCfrzWoXlxAm7LJFv0jtWhBxHsZwYi5IpuNpJE/nDPZ8yUHJUVfOw9FcySNHUfCNNP0eF4KvtMuWhDCDoEg1It5KnRR3Zux2zwftvBZDPim8qVOEuPPCl4mhzcoIL4TaEVn7OBMcKQ6rM1htuk5R7H7x6C8la2mKlSgSr3VQZhWEmSbzEzeavIwvqlt1IlaTUnf33xxcda//hbliPAIF8W9GNe9Dl7VtoN5lKJqnJiPnuCuGHmhP1jSVRr8jn0xrUtvBELELfwv8sz3UBoJR9TCQ1hN
 ktydq/ba
 diIQ0MzFbrEduq62/EXfjtDiXuVztTWo+oyzO3yBRp2aJ4Yrcv+DWIfzQwqInegnvyruh/cBzHk82XYE9+nSyd/j7wjtCEj1PUvc9BvkrXPG9Bi2BgyXXxtZjEuW3BgTcePlb6mhc4hhUxaUVDOAZse6BrN7+HEASISEGaLlq4/3yRS+uV0b9cFQWV+OJJcK/ShGEsYiDMLXKyHIHg06Ubc9KQ+R3oXjuMTbU3kZl+zdioCScZW/QgVnlULOQtT7BUOoYTurhHRWDs9XDML+bZQEWsOJ5meejTjedPF6RRb3cgftjL/WkV4sDiOUPZu8j1Q6FExNdz1qWHeM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize the nfsd filesystem as a pseudo filesystem. This raises
SB_I_PSEUDO and also SB_I_NOEXEC and SB_I_NODEV. It never holds
executables or device nodes.

Acked-by: Chuck Lever <cel@kernel.org>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/nfsd/nfsctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index f32311f2d7cf9..ce2666deddbd9 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -9,6 +9,7 @@
 #include <linux/namei.h>
 #include <linux/ctype.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 
 #include <linux/sunrpc/cache.h>
 #include <linux/sunrpc/svcsock.h>
@@ -1375,6 +1376,7 @@ static int nfsd_init_fs_context(struct fs_context *fc)
 {
 	put_user_ns(fc->user_ns);
 	fc->user_ns = get_user_ns(fc->net_ns->user_ns);
+	fc_init_pseudo(fc);
 	fc->ops = &nfsd_fs_context_ops;
 	return 0;
 }

-- 
2.53.0


