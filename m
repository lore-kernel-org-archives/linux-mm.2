Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5248606C567
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mb0GFpd2
Received: by kanga.kvack.org (Postfix)
	id 172EE6B05BF; Sat, 14 Nov 2026 08:06:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1232F6B05C0; Sat, 14 Nov 2026 08:06:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 012AC6B05C1; Sat, 14 Nov 2026 08:06:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D84D86B05BF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:06:49 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80B55A7BB0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:06:49 +0000 (UTC)
X-FDA: 85433749338.01.57021AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id C5DB320002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:06:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mb0GFpd2;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661607;
	b=5J1jO3ulIWoMaQ9ZoRzN09wUXSjr3niEiU2RfraajauXMrpyrUV2C8Dp9fw+4UzPwNQQUX
	esQ+XjaVldzEZMHpM8HPppFtM+NlKsPgqxkNCWNMRZfJEkTzFSj4E3qh/U3fJME1esRnBN
	Mb93l9cd3w1ju5H/MpdxVDE2EMlh/Cc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mb0GFpd2;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FpatCwjw3dsO4JQBQMC7kZ13u2vnGsecGcPNuVpa3KA=;
	b=TGGqtu0j4UZ6/r6OaeYm/2WYaT+yZVCSug8mAw3nGmQvToReHpCuzSmfMMnRWOuTrKRGRi
	ueNbB5YEQTSQpdcnj2IORBSmx1+OkQzwmTiRhXGetbPSne7gPyylkMSXpPB68IACx3SCbJ
	EB97PP68BA7/CdiVWwrHythCKNFYWV8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 54C506271E;
	Sat, 14 Nov 2026 13:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DE71F000C4;
	Sat, 14 Nov 2026 13:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661607;
	bh=FpatCwjw3dsO4JQBQMC7kZ13u2vnGsecGcPNuVpa3KA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mb0GFpd2C5fDNr1HezZ4StZUVzaHMoEClA0IeuQL8e+ljakrtqDhCEASV8IAXvP4d
	 RC1oa5y1MsN5q8MWN8GXMEbVUZRKyYW/fl7AOLLjvARkDSTMVvI+gSxb3II3v2DsJg
	 96C3cn9NrBLsKPz/zWvh7GCVaCkTb4ADqAaobil0bVhIyLY+X8wvCP6duLHOwmTcEu
	 nUOIlhP4wuqWbLoMwB6uNjziIgKsIHHQgxQhQSZBtr6h25GDdzhH7Odii9UtlPy/VC
	 EmCy06jsWG4U6l5QmzFbeJBNBHn/Dz6c/O1FULUO7sYXxvju+nwGNQCS8SodWc8ZVk
	 Uvl0fK6ioapVg==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:51 +0100
Subject: [PATCH RFC v2 10/42] nullfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-10-98639a2286fb@kernel.org>
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
 Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1042; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5XsIgU6fgQKzvWW2wDjrcokIetPacs/QWCdr4iIPKEo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iCk8KTdXmVfntRBnvfSi6up7tXNUNn2+7OgpMrv+X
 X1Phd3UjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkUvmD472Toe9Lf1rqM+4vC
 vnQTU32GmsSg7adtuL+nHlrQZ//mDsN/16arDJPabmxYrPfimrJMB6/AxA41v/6kPF6G+28aHm9
 nAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: t6oub8a1afmqnofg5s8mw4rgmky6gcu8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5DB320002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794661607-823048
X-HE-Meta: U2FsdGVkX18T98BEvdwBIdSF9vsOdqYn4mvIO2tt9MvUM1QZuXlxhdaCiTk1WTJ/jVZOPSjxsD8AkcTUB//okOsgsMgbxu53Vl2dYtk60lQ5gD58i1MRx4z+0piVc4qNsEo+wKvTwuwBVGA/fmRcXZlyL36BcmNpFxMdSkiI0G6KV6fQK+X1CenQkBmEXoWD/vFfBogzQd9s6x4y12LrqYe7J3No3dHmHqlQXOtotwtdOAskisxDXeEYDWPVQCOI/t6peV+vyINUGsJBHT+V4Y/CJK5lP8PDcQQ17/3k4BNaBs9hEIG9kvGB/h95qzcJMTJc42W0ZxflSDw+dcVq5Ac3jfbVGC+u+fa9pp8EMoge3oOiyK2OUwQWkWqV7xqV8MvsllLelOd7eRrgVdY+SIVhUfin2+J+R41wmvdTropxM9loRYuZPiwF3j3SE4dpMehPOli/1qywshsW4uoDWIhC/W42bMLzIQq3gdpSgiDVwrXdvXBspradPnFtV9rJy0I6DtiIZZkhQA5F27Ga2Ut1H1Q6wbHPYFrejzuhe4AfBUnVhNf2uo9qsq7JF1WT6ujrncSKtHlBebumCVzznT83jAeUtVaBoHZ47/866Qq5+qhNW1jfKTJj72sDPZEyQ4G8Y7ZuPLTy8KOOMRmNTGyhpNBmauZVBEllzqgLi9ANpcLeDBFQwXBV/kPjddEaboYo8syxx0K5BXQff5QtH0gn53l4XZaAlMooEpblKSf0ym2PjVcwiq+hNFzmBYqttft2PyZETJwFOj2QE/icaM7oFAqnt28MjbAL9um3NR5/lsptJPIHtLeAE8mxaaqqZUz3Zbb2ZVV3upReKQWlSCCkVlquVQ8DtRHz9PabnmSZ5xZCeKqo1d1eYHGUpP4VvkRoZwmIJbhBWOScdzmxw5Z+52ipaqhUaxCZAD0FpRL58wJ6uIKpKl4/uvqSNl5klof+ticEkKSgbObUOP3
 d2SNRVwq
 RSfJYrWPpohH9UlBGzqyyLSWVLCWNSVAnU5CUUXNXYd7IaT5CgG6Wq5DGPXQfTWqAfTtDkOjkbJWpww3N1Mj5l4hMq9kCwuM5FtShU2WzI6hfS1EcH37DyUjJD3dzKse/pPUof2JKskWjnP5LrBwWQpnj1joJ2wh8WsSdWXMazmbjhyBnWKadmplM14ww4RmZJhgZAfY1EOuBqe46IlydVaW6vVK9mD1JcRuU2X4MkY+pwHMPXZfgDV23YRPDtxS1HBdMDuJqPla2ikYHfMm9A8aJ0XHKHbsKpjtOpsbCzMooymFvSKM0J36vpJ76TeV8h15xs9ssL3J/Em8DhbAdo5Rqf9vmMLKY3yju
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


