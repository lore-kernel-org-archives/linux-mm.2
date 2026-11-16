Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 011F1607BDBD
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oFIEwLKD
Received: by kanga.kvack.org (Postfix)
	id 2DF6B6B0607; Mon, 16 Nov 2026 06:09:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28F9D6B0608; Mon, 16 Nov 2026 06:09:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17F3C6B0609; Mon, 16 Nov 2026 06:09:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9F186B0607
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:09:51 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 874B78091C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:09:51 +0000 (UTC)
X-FDA: 85440712182.08.287F4CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id CA0A3C0008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:09:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFIEwLKD;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=id4PRLDY8xxqmv09Cy60S/mO+ESr2mIJ65uM2WRQC7s=;
	b=m5FoMiGDzt75EM0XspKEpjIfKh7VKjBbBGcW9j/+tNG9w1S7ofQy5/w3WQY1KRlmYIyc9S
	lDDYTSEO70dYqpUXyDDaTMbJO1qoC2C/+d41AXh3FFvlfbAAjxEJh0xnPyTBESrf/19DtI
	7367+60hHarZSJDv0vT6aEEB+1gUTBs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827389;
	b=xy8gtG94HdW5DhxPhT7c5cMn5oXBfAnD3fw+7dHJejomni7a9PdQtdZz6mrTEiP3S4A41G
	DrfmDoQbn+7Xr4+4rzczalDV5/3iHL7DY122N03GlBWOasmAkAiTNVgNH/oHzENWF5Vxuw
	e/FnjlIDHWsYVyycER7iAgh7wiqkRwc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFIEwLKD;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 134C443C84;
	Mon, 16 Nov 2026 11:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451AC1F000CC;
	Mon, 16 Nov 2026 11:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827389;
	bh=id4PRLDY8xxqmv09Cy60S/mO+ESr2mIJ65uM2WRQC7s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oFIEwLKDMkGdxOt/DDlVAriXa/3JhjU6B0wnumVBLhZbrKad6BNjyN32ljVZe1gr2
	 evSiKb98KYiK7ox0NLucJoulMze+sd3HtzyZ/Phmkxks/AbKfj8BC1no0C9EH7ohN3
	 WQMFdiKsZiXF4sj6E2AcrSrWMXjOjOyhtElSwZvxW5uxffrEIpX/hWkpl+FofkZOLx
	 b2aRFRpLcgHXUzQNqoClVFfyUUZQ+h9kK+k31gD/lsiHRjzSHuUqTUFbozUt5OYusI
	 G8Q6nJwUvut37/TzsrYXpAmX9f8vZm1SSdPUv+Ge/ufOtx/LttiTnVQr4RWG/x7ZZT
	 n5AYYwK7BC2Ig==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:03 +0100
Subject: [PATCH RFC v3 30/44] powerpc/spufs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-30-8cbbea1cf34f@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1161; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IfUgpka9O6kutLnlSG4nrBix3fgpTd+0l8aZ7VY9Wl0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9etyY0bbQpb9/stRd2wNcz8MesFWKZlzUZtZQfdaTZ
 /NkW8OzjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIncd2FkuM13RtqwR3sRb/7u
 73H9Vgmqz68LeQWvbp3DZuV3SdfelZHho4jyyh1BXWnl1lUZlWu/W/+8XHi6s7LFRtpfibX7ThQ
 TAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CA0A3C0008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: a6kqtq11a8nqp7z85zzxy8kn19pca1he
X-Rspam-User: 
X-HE-Tag: 1794827389-739043
X-HE-Meta: U2FsdGVkX1/BUuxSqieCqzF+C18iqFTSwqIFz69P5QPIxHkAV/Pyp2/yul+SIdykM1lmnDHrY1E827s8JIsTsWSCu3inUituUrpjw46R5vmjvWvuTQR7t5C15EJpMsOUkbx+0wKdXMJ8eY8GANtUDt22IY4zdMFfJ3ZSHBqLsxj2pIEYosKEotH7fmdIHC+Q5j6YNAnGI3Lc8Hw+r2nosRR5+9peFN5q+/6MPbeMIv29jg7B1WL9pR+r+vGlkCg6mYh4F/y7k6rKn8sbjX5AR2ntwwDUwkdg/h3/PChDLCFNLDnM6zlMtkuaWION7fdDWwxgtk/EU5CV6lOeoc1KAOq4xMZyTtqMAfT6mmZQrq8V/8hZ0NEG+Q0sFJsnCX91xy4KGJwTfWHitGqg20QIcii/IYG5f9KwhRV+ZNpT1/AyzdSSk2ENWYSj1BBWWPYdksfkn/tfwJDsEbh5C55wLAwrJZEFP+kTO7nPnje1Pz2JW40fHRwhw4OE840TqM4XIPpyyNT/453bBDY/Sd20xeK+vU6GKqbwbOxAi0P0tx+rkSe/aBhIbYZN1B7NcUXwPu7YbdPGME/RG7lZqQm9D+U027VtfyJZjh2Y6OKMjdHjrAIzkjj0/CXzcgeVXkhHRPBRUkm+zSL3riS2SjZ9hR/5lq/4NnNPHARmjE3sEtSMZoFm14oD4WS58glmPAMuPO434zHGWIulLwKj3XK+JwJcigfcBYC1T2Xg5IOJRHlDQ2f0VDoe42JO/QetnKgXNpBwd2MwqFRp41JzoOhuqGWDKMReLTqcGi3cVssEP9HE+O7vFXyA5rrKH8bneI8svlGva5ZV+uCRha/Fa+CxyOhIPvPLNv6QTckUQmuF/MGcGh2mB/gPOoID4AGjLiEEmsfJDW4+9dt/KsvR7KHFD4Lh8LowUh5Lg1yVXb6iahPPqUKFHu8B0YagSLRFk0+HBErHoU0Qb/t5zoIuCHw
 R+C7Awp/
 Vk0sxpdreT0BSRszf8fC/h2DOkZ5CLRtjSqYiXg7e7HkS14SFUipO0ur/J1W42AmGzgBnL56eCHbOpYDmqaJrIiounxTRjAeoouT6wbGOq5N7hiNhmSR8YSBw68DWAd35Gl8ym95Efs9fOJ6SXGRwh1HZdaNdMo/OLmSNKref2tfSS3IPKxmLH2n27GJAqkdcmU4wE8LRas0pEnfjyglfG3IPKrfaeLmzlwOv3KGXdu4/c+H28FlG2hBD/bcyHEWnggDky6LY0nIhMABFw7FE5nLclsoobfgu/ZoKnQFMg/IFr9JIc7tTzGfApwog8Uoa69k9TYIV1zDS0HphFrYbeuBmNX3cU7rdSvp0Fbg1cDykljTExWl9f6tyUC6qGYqP82L2XAYRnI9aNkpLq0G/PVfTcjn24qx5M8gYA/3fG1dRyHiOQVXOJbDU3YpL+ixh53fd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize spufs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. spufs never holds executables or
device nodes.

SB_I_NOEXEC also refuses PROT_EXEC mappings. The spufs files that can
be mapped expose local store and problem state areas of the SPU,
nothing the PPU executes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/platforms/cell/spufs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index f066d9c7344d3..54b45932aecd2 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -11,6 +11,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/fsnotify.h>
 #include <linux/backing-dev.h>
@@ -741,6 +742,7 @@ static int spufs_init_fs_context(struct fs_context *fc)
 
 	fc->fs_private = ctx;
 	fc->s_fs_info = sbi;
+	fc_init_pseudo(fc);
 	fc->ops = &spufs_context_ops;
 	return 0;
 

-- 
2.53.0


