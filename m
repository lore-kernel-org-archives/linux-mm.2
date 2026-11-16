Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C92CC606FDBB
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h7CXi/T8
Received: by kanga.kvack.org (Postfix)
	id 6F8D26B05B4; Mon, 16 Nov 2026 06:06:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D02D6B05DA; Mon, 16 Nov 2026 06:06:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598AA6B05DB; Mon, 16 Nov 2026 06:06:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 384386B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:06:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CAC3DA7432
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:52 +0000 (UTC)
X-FDA: 85440704664.20.8F00339
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 18D414000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h7CXi/T8";
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oChNfLTK4rw7xE/V7Z1VAqgEcNGqqiTJ7bEePsgI8+0=;
	b=iwCDhgvZD56SB1s1qI1QbJ0X07oN/76L1Qxlu47RFDjCMkJYJlxjybttcN+Nt/D6IY54/e
	au2AyWZfNE1lj4gPKps350x/WZSKzIULdU8zBi3FzyDT/jvo3i2x9yYWoM/jOzlPOE9aCX
	zWf0cw9TNcAY1Swr1DC4BDSsdih6NmM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827211;
	b=wjXpGrKWgJjPPnqEApWjGJWIq5cbxAuD3PKg6YYMQ3xaJgPZ2EymGc4WYy17tXxGyj90bO
	+1PvEChzCItbsaWGPCvtNBiKmUwobY2+Uz9sKBluib/aUIUKkhlYKFsZ4g9z0tsdaFblcf
	pa6PrD3mABMCiiyhW/FfvaYsEXA68n4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h7CXi/T8";
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD2A16296A;
	Mon, 16 Nov 2026 11:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7387F1F000C9;
	Mon, 16 Nov 2026 11:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827210;
	bh=oChNfLTK4rw7xE/V7Z1VAqgEcNGqqiTJ7bEePsgI8+0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h7CXi/T80VNFQe+1pnYyDyh2qBlV6g5249gmpoEK/oFyp3rxtx7XiOHqGFA0b9uRf
	 X2xLH2Skg3D0sBNcTtVcs6zgdHUXzZYHUZGaysiF/lwo8EnuSu959abAX0kFQcge1n
	 Xzw3YR9Um2gylgRrQMFHzZbZ9bBGTBSiwzlLZArzyxBiMKVJuxKyXXmg8B55Dx/aqw
	 8L1DchIEJLV0I/73xS4ZZ8jYy6MCTeYnKUSLkxd482HOnnHGhdbaf6Ie9oFIoUMwbb
	 pArvGYXqIS5HCNxl1IyvDitc72nIjyXgcVrUc6r55xEsqjGWvNqc1YcOEP36u0QQE4
	 PtRiWTT84Yo9w==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:39 +0100
Subject: [PATCH RFC v3 06/44] proc: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-6-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1502; i=brauner@kernel.org;
 h=from:subject:message-id; bh=O+LGaMZ0N6Bs6+mDguHowtHROzAFu69RKO3s/nDEI6A=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epwa/fyZ5LmIiN+RTC9Pt6wTeMornyQXvpLfz4rhN
 bfymsuTOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACaSeYfhf36ad/RMx0zJi7NO
 u1Wsfsb31Vrvhsy+F3zdv+dbvOJ6WsXwP/DEsU0Xgo+/9awQ+Do190d6wP2jxqUddSK2PFYrS9i
 VGQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: fhmw1cka7mosrjxa45mekdcy518654ib
X-Rspamd-Queue-Id: 18D414000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794827210-263079
X-HE-Meta: U2FsdGVkX1+TSlnxtLkpLpPooF7Tz01OGWNlA1K0U1l/FPFeJ+cddBpfJsm4pH7AmlmHuhe+V2rCMWafZc6yiv0ePfKDNp4nvmrnzQVl1NDBIeYgmA8vyce8GWgvxq2wWnVQ+Y3EXO4mSlwmBaHE0Vl6rqvQnveI1fFwJaSl7Lm9swM0SgWkNaqWwRSgobmOEWW6byeIDluBZlctuxUxGfNpWz1PzQG6Pn6wAsgSzEGNgOCy20yJpD+4uVFGBxA7BcyuLsVebtF6FFDKZMZHkGJMHnH0VOL4+X1dBXeG4U+W0spVdC2PmV2EmuQovKGh7tlq34Pb013/WtCSTTec/kTsiUiF6Qx635/M0qrX41iAxh6YzMXgOlvQ2gkaPl4y4AgDaw3UNU19Xg7nBfsXMwoiS2ZGdOMqancIMJG8Pq3KMDuZ4JySI6H53w42HEDyxsYFYi3rqWu13Bayy0DFIuTNcbfYExKqQh8t8/5wgMY4GO+SFUmC4tk3OnPDyZc+y/5juBetGF3zLGiSx3N/8LEVJ89M1QxsW838+bXtEhhVYBBnox2PuOXrQhpNC90D5JRh4TpEUkI/gsUDQZNWUoyAe9o8tuLy10SjXfcxwRHsDx3ift3vKa+D5cxZm9SE8WLGuLy0I3nGRMc9I/LZFVo7z7edV98qBrUHJrYYltR9S3oWax012Zak6hinPrfRlYVarVtYHkR8ZDWXlkISI1oNSveQDEyy4PXrEihxEI1NODZVEbrzlsgNB8j9WY4dSCm5LyHll0K/AKDi2AiidPdUq21vVCRWNRzOMIUIQsFMj0SmZ7oORPNH4460L+On1xZWPhOy1yxoI14H2nT5DWRcJzv9X6kRUBLyHI3mvMyeG5q194fPrGl01IjexE5h5jtkabSq8Dpbpt4Xwo3wbpyYkTMBxY1qwA/GIb3GbsJPtHELEQbTMM5u0sCJLfN8svEombcUQmXhyczrXHX
 ApaNB44a
 16nkkqwrWgBaVYWYvR3xlretEgeGFVnuU4sbaxnZJIWkZJ2jUjgTSj8UA18XKCZRKQ00mBXSZyfJVWtDA+YoTok2nuQoX34TXjl1qrZE4wOpo6Fnf2Yzx6sK9VGh405ypVEZHGrqXedNSBhZ3ll5CrFrgEVpHpN09EVAVKTpjbpL6BqsylfkNlBY71B5wEIfQggLScdskIJMG2HWf6NvnQinz4INjrZL6upEW/ldtuaXSRYdN6WvfG/hUo9FwoDoc7Is2T+1tSG8TbzGiZR4lqkRJUtv/tgJykbv2xLhVHpV/vil1hJEND1GCBelxG7xVm3rce7r1Zze8bRu7s23mn0T7M5ol07+EibMU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize procfs as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/root.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index 7fbbe92bf73a7..ca0e75081934f 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -17,6 +17,7 @@
 #include <linux/bitops.h>
 #include <linux/user_namespace.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/mount.h>
 #include <linux/pid_namespace.h>
 #include <linux/fs_parser.h>
@@ -265,8 +266,6 @@ static int proc_fill_super(struct super_block *s, struct fs_context *fc)
 	if (ret)
 		return ret;
 
-	/* User space would break if executables or devices appear on proc */
-	s->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
 	s->s_flags |= SB_NODIRATIME | SB_NOSUID | SB_NOEXEC;
 	s->s_blocksize = 1024;
 	s->s_blocksize_bits = 10;
@@ -350,6 +349,7 @@ static int proc_init_fs_context(struct fs_context *fc)
 	put_user_ns(fc->user_ns);
 	fc->user_ns = get_user_ns(ctx->pid_ns->user_ns);
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &proc_fs_context_ops;
 	return 0;
 }

-- 
2.53.0


