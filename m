Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 230E9606E0EF
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eNMLKdTx
Received: by kanga.kvack.org (Postfix)
	id 36EC56B05C3; Sat, 14 Nov 2026 08:07:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31F2A6B05C4; Sat, 14 Nov 2026 08:07:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7406B05C5; Sat, 14 Nov 2026 08:07:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2C096B05C3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:07:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8FCCF40401
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:07:10 +0000 (UTC)
X-FDA: 85433750220.27.A0EAC02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id C915216000A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:07:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eNMLKdTx;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4DogC3leTMvellKkr9nWRooBo/YpeiaomL5EWz/ARI=;
	b=DhRXRJpl+JbG+M2b//T6DXR2l3+s1J9FqucmNiDdJBrFyrW180hhFPkI7nxVEtDtzj+GMX
	ITGhwJGCLbyMS+irLIapd7xER+pzCrn81Vir/6FUxxUAlyyMOqW88DX4vcpWION5xDM2zp
	n7g9uK6Mix4REDPTYQCyegDjoI/ia+g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661628;
	b=Y/ZlosYc2UzePHbalHj+2D+xU2iUc8RUrlZw1YGR65zqTvHu+S6npmNzRgptvFh/LLBgJm
	+ijizZibcBC5Cxindzf6qc+f1I+YI4YbILDmT1Z9KgWjZycdiERWlSMYAvjliJP4isCiNc
	0PD4DOY1JaTkMpSbtoVvqNSnHeMmWYk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eNMLKdTx;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 62F98626C1;
	Sat, 14 Nov 2026 13:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5541F000C8;
	Sat, 14 Nov 2026 13:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661628;
	bh=a4DogC3leTMvellKkr9nWRooBo/YpeiaomL5EWz/ARI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eNMLKdTx3dymmeQj42x/tiPQZlsYxo3BnxO2lle2ggCk5ik4UVoGb9FneQv4f+PfE
	 iPtXg6wJ4NiBYxVUKwrwV6BjjDW1PYcTx9AdLPDNYcRJOa/njeQT1Tui+yB5OKPTPd
	 pBiRmu+dYcCDMMFEP47vr4N9dOso2DnIN4N2dS49BqxUX+8EhXORqAc5k/0HnUrAep
	 9Yh+6V9R/3YLoNJ8Vj+tT9kmqKS6ojGo0ggbD6EZRxvoiqNbm9pHagQWaWsSziNoLX
	 cDNo+Xtyw5HdAJaWdM3yOjBIu3OaQSIdSq32D7VRiuAD0Ykly4nDMli7qT1xKcfmFF
	 gfkjM96ebjM0g==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:54 +0100
Subject: [PATCH RFC v2 13/42] devpts: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-13-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=974; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/9KDxh8T8EW09H7q8v3DIxE+0d7Rcpp1sL669Qzx9RY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iCk5MqFtZ8uZ5Vpfmq9aXrFPb+e5ILP/w0bNwh/9p
 jtOP348taOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiuccZGe7P+j9R4cfXIK9F
 kskbJ11+sv2x5N5pR3qFQ697SPMd/n6HkeHec5OmTsUeRsv1nnuXcvV1232cPa9UY1dJ3KG88C2
 nSjgB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: kjgnaij5nzumafczb3x59paapig1zcz7
X-Rspamd-Queue-Id: C915216000A
X-Rspam-User: 
X-HE-Tag: 1794661628-646900
X-HE-Meta: U2FsdGVkX1/Guq+qEWAK5mgFEWTq4GutgznKM2u4S+qp3pgJeAWGEBF1yqTD8G60ehbZFMza2jENhl7eIZz05upKnfxO8mhhOMcI1fUtOVju8yDeCEsDqNTSbA3VDO2LUIqXY+tH+Fx3GZXCX0AuHLJa06NK39pO45U8YGO4fSPGmeP2MPEVLABb6r+yRvhZa9oZ2f/ERSyFm+JZh6OnJrxxGADMO+kEkGj8aBymtS+8RjLyRoR7ChgdeZ2YnO4ZERHfRPsLNppI7H3lz4tfJHZ+q6GJesVwFmFKtnqU4o38NdOcC5xlh9Z8xBypPa0w1Jd5HW2H2Q6ET5m8ejH3e8hB8dUyyA8PwZsAfsgIXmIkwXr+D2mWsfMYSyaqC7cOyiWShVo7PG7kSPXL6a60r9UvSdb9fo4FKfR44FZxyviPnVaahZoCpWOcY2NDb1HkZuaKURADxz1quCS0qcz0BbUjW8Mrx0fyZwF2BfL7it9IeYC2Ruw5QvqJx3rZlKjFuxCdYxZGTNscdzTvdt7eYWmNK4RmGsV2ogql3jlbpXXpRWZFbUB473l8+aVgayerP/tqsC/P2ZavBoC9ZPzF1wew/RZeZePazJVbUwRluXBkipprutL7AM4sZ5GVEkc5BLRwkQzxvD4uaX0zEwfr27YzVCfYV1+RgT/VU8tvQZ3Li9DkScBOnvxxW/RcPBrPtlw1me80+mG1kxinu0TyIP4wDhdrz4nEzNlookiEBEoUaBXsHaHv7brwuzeiZ04oOkkSfkkhfdLnNXYEeX6asN65nzi9FlYp55DSvXfAKIKNUmzjkMF4hwMWa/BoCVrRdyShm43N/FEWYdYaBv2AP6O7U2bnl2H0kdQLj25PYK20MFetcq7piuLIRgUUvAi98Uiw0mbJPVzflSTAUkt6iYGJPT196s1zSGd90lr6gLI8jUHbgbaOw+SDU4lybpXLHO3DeUoU9yniQdF5yIX
 mDDap7u1
 LpOV1jhKHwGJFJQ8fXNEt+0ti/BGvmEhQbrVEj9m5bjcsji6yBwcOmH/GNcqtK6WIbUQqVWHovLnsiyuQNbxod/zaaKkDW6pX4o8ut6dDG3CufM71LpDOM4bnyu+ex0a7ZQDadsXAlpHOoRnB3R9LMt2ptOY5tfG/u4mSj2QDe6V64cpBwl1RE5p4b1Q6xFMDOQ9aoFtAwUkIyz+OR7vxdgFys5U9vGSeYumBGKAZcuok/wLzl6MCkouPd+i5DXAIwZ5FfjWp9F9TVSuWhICULpIAp47FUaqigxjmlbAnpKanVo084FzYAdJp4xOkM4e3Ol2VYE7P3anjcR0b671aj/zNz7pW/rzsyT03
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize devpts as a pseudo filesystem. This raises SB_I_PSEUDO and
SB_I_NOEXEC. devpts never holds executables. devpts_fill_super() keeps
clearing SB_I_NODEV for the pty device nodes.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/devpts/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index bd1e8eb26edb7..47ef12241d92d 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/sched.h>
 #include <linux/namei.h>
@@ -438,6 +439,7 @@ static int devpts_init_fs_context(struct fs_context *fc)
 		fsi->mount_opts.reserve = true;
 
 	fc->s_fs_info = fsi;
+	fc_init_pseudo(fc);
 	fc->ops = &devpts_context_ops;
 	return 0;
 }

-- 
2.53.0


