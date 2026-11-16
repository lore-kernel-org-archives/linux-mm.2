Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D5686071B38
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WAHd6iSb
Received: by kanga.kvack.org (Postfix)
	id 599D76B05E5; Mon, 16 Nov 2026 06:07:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523BA6B05E6; Mon, 16 Nov 2026 06:07:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4392F6B05E7; Mon, 16 Nov 2026 06:07:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E46B6B05E5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:07:23 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ACAE11A0694
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:07:22 +0000 (UTC)
X-FDA: 85440705924.17.5AC696C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E3D7D40004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:07:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WAHd6iSb;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQcOz9pf9yUAnUZyyI8ZqFilBp97onIP4xdHL0RQnuE=;
	b=s32ZbHUAW1MCcIH0zIseFR3BTEIJjNRB/8ZtijRtAhhSA8f62XcW/AOVFyMLAE8OMkoiVh
	II5mqVfLMmiUJevAX82KCNDvX3xkceq+UE562wPXzHVU7qyWBQf6Jw+c2m/YnWVshV1j4k
	Pe63zIaRBb4pskOC5XWT9JOi5qNGNEc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WAHd6iSb;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827241;
	b=td15jMnZC3+fcwK37nxKA0r/L9ZtArR08Gegjk37hjYlx63GNGRJo/Gzms29RJ7SoBjDV5
	f9dbV7r/XDTzG4NU6LC5u/N0Z/mdnCSQekJNtnMGvF4DzXtNX5FjoezsmHUHrQKTWKWuHZ
	fakcwj6j8cBY+faFW8moyY3/frMNzr8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 806126295D;
	Mon, 16 Nov 2026 11:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1991F000C6;
	Mon, 16 Nov 2026 11:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827240;
	bh=CQcOz9pf9yUAnUZyyI8ZqFilBp97onIP4xdHL0RQnuE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WAHd6iSbCEtifefZMSqk0cXPnktLAZIBAaCQy60YJ2nJaxqT8DKgVk5VsUN67+gWm
	 z8mxW0ifANULaEn6eoO1YSyCH77pTBjTLQpEuHRCSgNzBdVAIhSKqn4sWkQPFyXdBt
	 tXJ1An451qL0NHQ9VXwP8ewze057R4HqD/VydKBcBWfCdpBT29zz5SWbRmbhPZIy7t
	 krh0rS/lszKzpG2HbfXO42srT3A406priAC+52NrNl/HXbwY35qFpwU2cri/sdCERB
	 F2qr5cKieSSqcVwo+4jbRcbTuZvJ374VxYIuXO00ayF/nT6+GuMDVyrWKkf+vRGeEh
	 HJAAygLW0S83g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:43 +0100
Subject: [PATCH RFC v3 10/44] nullfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-10-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1090; i=brauner@kernel.org;
 h=from:subject:message-id; bh=r8cREnFKSRz4SaxSdJTVTJtjPA949EUN40oz/vuaT38=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epx17FvHFoV3U5iXzd8/4c/mG66STx2Sspkf5j38u
 eHRZFGGWR2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQATmR/NyHDKmqvQXFLhWaON
 1Yr9emFz317b8/vF0rgo9uCmt549tVoMf/hXbrBsap/pJMm51TgxM3VdUKfemt6Ay/afb55aob/
 BigkA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: mza7fou6jbfbuh8adzp3pmadjuezngph
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E3D7D40004
X-HE-Tag: 1794827240-198577
X-HE-Meta: U2FsdGVkX19vPNNuT4Ki3zy89amzTu9aLp/R8sVJyZ30euG/RCHSGmExcZWxobPN75gw+seDgPOvrnN/lm68ApRcKlc0+r48iktNYbbaNCPXN0qx/3UUlDYrBjchhVcvbQVfoWj7Pk5Et5QajX03d4J8l4RtTp3fsGHv3gwGhMhKCa7p4Atus6+pvBLnKCsknQx0pA+Fgf8GNDGt1/RvoLPv4Ua0pThyNHKUtjoSuW+JmSK8ZlIq55RpTYR4qdVkl92kApGaJwNIr/BdUVwkFPW1b5QJl7XEY8jvCnq6wa0QBw5FL4jQ6yxWysAcFB/a4eYEgsfLsV3IKbsy9m/6DuWLGQxlhh1KdTaoehrMnqCiXkYUi8mCactqAYoiG9zMSAoblb3yz2gsUHJvV3hvPhzICcWMlrGWd2zICYu0dBsGGT5zpUIA1rJ4Npazm41FBoz04EWbXjl7M8gQrb6wNnUptvVWCbmtkFgH1bryxcKNDiBKbar5F+5l4qwXOhbwLEYNwSso50sh+NNTSdnmv5vi3pYZTxIAsIFIBajnGa0pgcUS/Gw36OhjN+52rmDgpX/HGbmbwL+gAuVeWkWs0LtL9kZWQSUmyZeZJywIOu6d8PjsBZ+1LKNYRizXAg+vvIl9uAuCywEFqXRXaBWe/wLb+n/MRgy1ghWSZDX38xvcswlDNeVc4GAK8xR3naYT1U84rO5afh7FT9ddXcKUfjTvAQytS539Wsc02aCHWTRW/tSXmOGnj15jCB9HD9AbOPSjym4gqjavoyTSVOhZxK4+23JlbkaLwnfrhg3FqjFdzGLiquFZRCNGO+j5pI7gyfviiVoUKXwtBQ0BvIrt9cYr+wFcY+wmhaB76ZtqB0SMwDoe+cC3XBLKJ7imoXezr6JamSz75Av364zsEkbNrjY0JLzcRGnq+45Vrf/7K/vxrQW4ZV1LVxoTDDE7bO6ESK9hvsGyf2bBrsWkLP6
 ccE0Pj7x
 VPvMmyhXWPNKyrJ6UJDPa+8O6rQVKFvqXrrzs26nWovRNlVjId8c4F6NXYnkUnHtfy/t2g+lnG7U8vZB8TPStb8lWwaDpw++y/HrmkUW+xnq7vqrx2Mtzy73aBAgs+9OB8W9Rcw1s20yx9E+ZxCnBOtV+GyKxk40tRHaIOKGbVO4WDH8f+swC7/kWpA6MXj536h/VM/OqJVUqc/NdpMb3olP02nWcP5Iv1Dz7+yOypYZOuNj8pdYHDxLIr0AOBKERSM1Yx/zsKCrqeMudQAIATqAREz3e9tPr/MHaAl/annB+YqzTYrkXXDE7WwXRyN49qG5fuyj2HdqWNchcZXRs3IBtxPVKgBJ7p6ob
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize nullfs as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/nullfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nullfs.c b/fs/nullfs.c
index 319c2f5c5a671..2fe24cb97160e 100644
--- a/fs/nullfs.c
+++ b/fs/nullfs.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2026 Christian Brauner <brauner@kernel.org> */
 #include <linux/fs/super_types.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/magic.h>
 #include <linux/splice.h>
 #include <linux/uio.h>
@@ -174,7 +175,7 @@ static int nullfs_init_fs_context(struct fs_context *fc)
 {
 	fc->ops		= &nullfs_fs_context_ops;
 	fc->sb_flags	|= SB_NOUSER;
-	fc->s_iflags	|= SB_I_NOEXEC | SB_I_NODEV;
+	fc_init_pseudo(fc);
 	return 0;
 }
 

-- 
2.53.0


