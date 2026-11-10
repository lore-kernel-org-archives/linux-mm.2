Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B23606E5AC
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HZwAEC7y
Received: by kanga.kvack.org (Postfix)
	id E0A3D6B05C6; Tue, 10 Nov 2026 04:17:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1AA6B05C7; Tue, 10 Nov 2026 04:17:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1AC6B05C8; Tue, 10 Nov 2026 04:17:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A87DF6B05C6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:17:22 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45319C0388
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:17:22 +0000 (UTC)
X-FDA: 85418655924.04.E21D163
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7CFB220009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:17:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HZwAEC7y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302240;
	b=hM1Kw+HvoN0MiNB2QCHhQ6243t89cOAbZkY1LCT71dwp44CH1gy91wSO+KKtNAueYnqNoe
	kTqs7Wzu1O+bqokUE3Ub0KZJv5xzFIUA8uc7tLuO7+QvcRrCXlrFQX/PGBRcMKS/pY17kO
	9L4yNX6ZYr4VWJt68RVmuRdrSrViCZE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BDssZE8GnxXJphkJa/7u6Kmpiz0qYyZXv4DcRb36RZU=;
	b=lAc0yHVZUBa9fKTx/oVhjxFawhpqU08tfR0e8RX5b/k+QLFWSnFdpoXFgTJ3jgo/mUHTXp
	DK45+c+hE4ddkTCUs8rlr6Ji1DYQLjl3j+ALsvIvt6cRLvFIbQEnlqYgm7LCoPQF/RkqiR
	N4RtitB+LqCmd11fUZI6Er/2Tp7Bvs0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HZwAEC7y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C62E63810;
	Tue, 10 Nov 2026 09:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F81D1F008A1;
	Tue, 10 Nov 2026 09:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302239;
	bh=BDssZE8GnxXJphkJa/7u6Kmpiz0qYyZXv4DcRb36RZU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HZwAEC7yTB7xRGKnMoMrQZ9sxFhShy/lcUuZ/x28dAQF2zKH4dms8JkefpvImrQ6x
	 XC17RCkuC5DS1kjza0TXcL7CFDfklhb43tkgjYep+m/Ktv9OM8WFbgu+n53zFr0v99
	 oA4dvldcm7IP98DtTd9OniKq7I49xL8jcVtYPn+hdsEuh9403uECXy9gbC3SQ3i3KX
	 69hVJ4ZtgMy9pBNrX3/NQCtI3QLLlYI9QKbR1ljiyee3SOwCPkfnPUCR39DKczXa41
	 B7rewxNEm+xa8FVjYKfML4jkp/JG7IHWJl4xIRYdJ5VcaUC/EIXdXrICC3YYuo9a0Q
	 vQiRwTkVcDJ/A==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:28 +0100
Subject: [PATCH RFC 12/41] rust_binderfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-12-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1349; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ia59pqse5bfG3zsSypUZSF6rnakCYrHaj4vJVOgAczE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erBwbu+MRZLWcXVeu3+t3xy2+WPblfNtxmUPzkxuZ
 kvRVVts01HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARzmhGhtUeaQcz2VY03m2x
 8X+zz3bz86e+3F0Sc0+/XnSvs/WJ/nKGfybCIVeWvGvzeXz9a3rPAre2kNeaOolzS/+H7js9+Wh
 DJgsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 7CFB220009
X-Rspamd-Server: rspam12
X-Stat-Signature: cb4b6swjy5hpp5uzycy3jdphfu1xiywm
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794302240-551738
X-HE-Meta: U2FsdGVkX1+Ck96C7ZIJBzMdH7ts/s31b7YyrvHWhyGhrDhGgPxixveHXnzEWu8FJjS/sSF7obvTLwEIuykIsclJxy7DdM8X0x1Xkvge9C+lGlEtIumUzbh+yZLKU7aEtz7RipzyEY7DFS25jKNbFkJ9v3tOdShun9ffwYdt9s2jk5K+r5MP7/7+mqGFlSSPU+u/mr6/zaiEQ+GDP7LFfgpenEZpkEVGNbQabVfUJkOhHG2cDBD5dL5gpck+LRq+9acf//OvHgEWB3WBfRx9vEpPhhhDoRW/6oKaEMXiHIw6tMbRMh7kcyHL8I5YRxZlBEXIIJjoDZ0LhhNqcBOEwdFGatEO3Ic10TlyKyyebMxNjlVQplGSyupAhgGvPfnXGG8djOQAFFtilk1PhewfjDjafQbwuVperlXskc7mXMyEsrZYOWwlET1I34OZeiZHo6dNEuBuj6vI/RQKrKod46KrERYyDTAvhWxMYX0TRaRGihNvmc0NQ01EKUYvrgi6QamdBXREtI8+KlCLf5voYBhOB8/8T49EpWuj2H2gwfvJPt+JItrvVHumVifjBbfVDX7XxPxNAquYQBjv7aLKSzh/Kd3VvGWs2CzpTD9pQx38H301go2JMvh3bya5Wv/boC7SOtvZCvHNjQUIcptRrKfAZ4VPh1+rtCAk74CBNoYHe/HZ6/gHAQrBP1KD18qHWs/bTOoQpD/1EC+TtKcELUUf9JmgHM1UN5tVn5MJwlN4HFHyxTTzN9uIt/bW85WwnvDN7s24DpxX9hGPhsKo5rAK++y7PZI/7myQfIE7Bq8JT0D2eAfIygLIxOVQIS0BgTsTWL2pHyZERBAHQBtNf2Wz6plQqKzkYUl7bBNx0rH+FkYUz49vMoxq3CxRw9Td7m/EZfVWbdMowMhreq4WXVgt4hcsMusySBJ1Bz01nndvNTb2MUsP0kdR2o0loHclPcDCBYaQl6o9j+SNweb
 IbIbwQvh
 1Pbc2c+s0UWQCMLbq8eiDzgCI5hZfI7/S6oNzlvzofjST92p9kwZj/dTehA7Co0JtKrbByWm2MhViTdqLwG8FS6lgwYLZdDJnnbeIZbG+89A96aZV+4qP7Li3Z/81kB42+Javog2q4/HzPouVmneM4wMggjJ4z8NBd49CFwUlvbUYmyIzYAQel/pjtci1FPYfvAau0OCDAFbRyGEQRLpvTOTD63xJxZi84tJhxUxADPRDfBdDT/HWEwf/KjyIpU+BNebx/ugTBhThtohpK4MAa/hBOydpo7IMNfmPzj+jAdMeeexru1sAkzVV0/ZqvyWcw8TlDsAR3B3dCjEMH6v3r1ca4F4LbDVHihNDsl78cwnE2HzLvNflvcwHLSkp72gokofaQNqjgPhZf07jWo4QoW4AXvEaHpwBHCtgG8KUht+ecE2udtMQQFzKDyAWyjENHKBQ8safYkl5iAMrCVgvWlRY/J+a0JeabtPz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize binderfs as a pseudo filesystem instead of raising SB_I_NOEXEC
by hand. This adds SB_I_PSEUDO. binderfs_fill_super() keeps clearing
SB_I_NODEV for the binder device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/android/binder/rust_binderfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/android/binder/rust_binderfs.c b/drivers/android/binder/rust_binderfs.c
index 5f020226720d..04468c5b5c11 100644
--- a/drivers/android/binder/rust_binderfs.c
+++ b/drivers/android/binder/rust_binderfs.c
@@ -3,6 +3,7 @@
 #include <linux/compiler_types.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fsnotify.h>
 #include <linux/gfp.h>
 #include <linux/idr.h>
@@ -667,7 +668,6 @@ static int binderfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	 * necessary and safe.
 	 */
 	sb->s_iflags &= ~SB_I_NODEV;
-	sb->s_iflags |= SB_I_NOEXEC;
 	sb->s_magic = RUST_BINDERFS_SUPER_MAGIC;
 	sb->s_op = &binderfs_super_ops;
 	sb->s_time_gran = 1;
@@ -759,6 +759,7 @@ static int binderfs_init_fs_context(struct fs_context *fc)
 	ctx->stats_mode = binderfs_stats_mode_unset;
 
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &binderfs_fs_context_ops;
 
 	return 0;

-- 
2.53.0


