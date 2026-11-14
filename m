Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 522F1606B98B
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NsZWIZ0u
Received: by kanga.kvack.org (Postfix)
	id 67D596B05D3; Sat, 14 Nov 2026 08:08:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62E026B05D4; Sat, 14 Nov 2026 08:08:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51D396B05D5; Sat, 14 Nov 2026 08:08:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6966B05D3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:08:08 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C6ACC1C3B67
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:08:07 +0000 (UTC)
X-FDA: 85433752614.01.678B2AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id EF66D140005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:08:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NsZWIZ0u;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M+wQ9mIvjJGXRJRbFoASGD8D6MKl3oze995xCAu4PIw=;
	b=cG5wq8W6ZdA1D+iDEmgsjur2nbRi2l9H4oHZIqFIYRr42c1hDIFfRdPkFGBqTxRchAeLAz
	7A5N1219Cel8/MU+d14eXhHHWWjENkDWl656h+88y0h2Jzw5vIBzCnLS8zGe3jJK9RuHpM
	dMjCkYrYiaN++6KVB7fjWdrx7jUGsPM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661686;
	b=B8X9miIkpCP81mlJZ21lJdbNDrcoNd7Y8Jv7QxPQI9Z0L03M4kr3JWp47i9jpKW6zPXOjK
	SnKgxLsfV4dkYTFeDIUeip6kXUEVy7GLf23exGwDKBHSZJEChkIraTtIyxpt3q6EGfTEl0
	eGztEXjZSL7xMtUPztwOQaKUFxdtW28=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NsZWIZ0u;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F23040ADA;
	Sat, 14 Nov 2026 13:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9255F1F000C5;
	Sat, 14 Nov 2026 13:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661685;
	bh=M+wQ9mIvjJGXRJRbFoASGD8D6MKl3oze995xCAu4PIw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NsZWIZ0uyJ/kEeg27LNsarwDMno74uYeR1qvyZgeFqeOAzIo39kAe0MSpeaDBfyna
	 OG+SkTUFAd55NxkkZY4/tgrlFTOMIlMqstHT23WH9HmxSQHID6HZivP6RTGGasAtEv
	 ghdyrIYjK3Gq6GDN43kCLZl7rWTXSXciNlNO9nHbFmzAoVc7dcCL6Fvc9EA7GbsEHM
	 JDKJiOhvg95JFUcodZAZ1CCOfjp/PYgklweHBo4CkLN70q6kRCKVJf5HI0WMNA4lCf
	 fVobYC0NGlECT/3MARJG5ONmb7zmOAQZxfL/PpE2kk6Jb29ZnuuOdRMC+6AygDXLUO
	 SOqbbaseGw8nQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:02 +0100
Subject: [PATCH RFC v2 21/42] nfsd: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-21-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=938; i=brauner@kernel.org;
 h=from:subject:message-id; bh=333wt1W/Zu6jr+pk5l0cVZ7RaBW0U1/QWczclcq5D2g=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iKmLTHPo2r7Kfu7yRemXBPUWve7/actZfm6rc/k25
 jem724e6ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIRR5Gho4FIlHz9++53fnK
 eYmA2xVfqS8fnermTZ72xHcPu+nShFOMDBvE1IVLnCTmP3kZv4jlPnfC5t2t7WarJxSWKke6dZS
 u5QQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EF66D140005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6a7whpyynfzufhr1abqoc481h1z14hfe
X-Rspam-User: 
X-HE-Tag: 1794661685-103575
X-HE-Meta: U2FsdGVkX18TYi5AVFUzbsEHdsa/2KtuQ2hJomOgc56xwU6CgRpeTP0cJGhYbOUmCMFKIkbfXqpGS9sVKHgt+YsGue6TqMzEkmkLtk/pkgi6xDYt0eDSAkx+BKcVEIsgekRzrXsF7TYx5z3ZCJxqRBVFgTJwE36SnwF+/EJ4jfiHr9LA7yTiJcsFUZsk8nJtmUIfn93eCzw2/JsyLqePH/aj6jutyxz2JjyTnBMmvQ2/DG+rq4u6FU3o/Fi17xFOgcfbmywCijCsLUD5lYdBhw4xqedpMSKmKW/3mPEqlFPIWOl+B51f2+89lw68ARBj3Gw+zFa0ieNOCzPlu+jt/Be3tA1xJjjieRPYj+THBu2mrHARTrwpWzywDTSuYLh8RVG8wK3HVjFahgrYvfoXOyUYYaKnB8yCNGA0k4iOUGu8Fh5IRqlHn0bRde1+ZkExCLVbxIBwLHoLwR8Xyl2++jyKFRy9qq+Lqt+2Tf3lh46I8sGKyXcRF+txUmHI5982X/S2Kuzw97Po7NKGsDE2XE65SGS8pIVUub5Ok01xOrQZfKF8jcPw2HvhdaawvMGmaHsebQ//ZMHq5qZkZNsMGBy88xV3/3R1LqATuW103TztuHPfpVlI0bh5J2d9Fy3FA33mIjtsRG80lYUzU1MkVT/PTDvq6+vneJxx8CTuoYO/ssJ+pDiR9r2548puc9N6l3iZT8Xkjlh23aMsqySJhUQa3iK2z0bDNAjSs06qQ8epyRAauCaSpsgp9iXyCDtqYN+YGNAya29gySRP5BeXD1+1DBOiE6PoquJZDqp5pDrHgCTNYuobXlrHcHZnj2C9yhKMroTAPN5VIvgz4Ig+Gx9J7WUnealP8oJ/VbZn4elvF1u3cRhKSDvtbrnWcSnj0jxtvwDVqGUX8UdlZbvWhunH/Q71sjRf9QDk3JEzM79O2X1cW8g36fdUoE0EGnw4Tdx16D3W16KWh/oGn+y
 LQi3aR18
 GPOF7uVeOCiCFMUvdzTj6ygfbWSTzbBMq2GZSOJhDdhkXZL1hMdBJiytkhXpAFdhRpLShvdNV6hsWrh96QNogT8KDqFV26u2zFokMzRKElM7ME1YH2gXudnx7Ezn2XzVmkKHmuqMICT2f7Pg+3EVc4fpMu7JsoAp766X9+ajw/xk68GQSzfvBmqO/urIylF0QqNK55oVKAIXTXJKHONoHjIAcVUIhis8AC271vrCzcqadSPo03hkcEsSMpLJw46AABiNXvQkRz+gmho0vP74DMHxDar23Rhn95wcKSiv5xZGUlfkQn4aOjG4wEi6xHF6ofL32Db9fG4O+PaUTd5n/n2RRMAcxKWZiyxH45KrJ2Bs4+drB/kPhIeu4JSQRN1XY/01SaiEQhU8sneqQgs3yPDqDUpNn9mZ0DAiUKecx9zzpX2ndYSanUlw9WTYqtbE4jTay
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


