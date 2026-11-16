Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1DAD606D785
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FUIH1F6N
Received: by kanga.kvack.org (Postfix)
	id 06E186B0605; Mon, 16 Nov 2026 06:09:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01E866B0606; Mon, 16 Nov 2026 06:09:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E28486B0607; Mon, 16 Nov 2026 06:09:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF43B6B0605
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:09:44 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 45EC71C3E1D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:09:44 +0000 (UTC)
X-FDA: 85440711888.17.2835244
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 84AB34000F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:09:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FUIH1F6N;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUBUitc/wTfMb7cZo0KLtSOkDXoKMBIaahrb6Pvq2WU=;
	b=s/95Njrb6XvFO+o1xCGYwxHnhxcosEh8uFxyn++wzcSiDX8oCE/Pj8IBMis9s6JI8FoM3w
	2iNL2/bz7qbRuZRpEQVKK8O06+JbRH+pHgJVu9ENIJFLhd58aWUv3MYClQXoRxP7FG+a8Y
	6EXOuvRd0OBSS4n1GK4zJlmI3Jc20As=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FUIH1F6N;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827382;
	b=k95jbO4lfGdkiq22O0GTRaK/1HsC6QFFse7/Og5Z3iIREpAWpnh0B2sji3T2nx50Qf32Lx
	jPpkr0z5He3AgC927kqiKfakgnHiWsHrz7G/hW6kXwifPCCRthyQIWiqrh+HgsJsxf8kst
	5hyO6+AzGbUyzSuZGU/rhIOkFhjuMzg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC6D0436A6;
	Mon, 16 Nov 2026 11:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6731F000C4;
	Mon, 16 Nov 2026 11:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827381;
	bh=JUBUitc/wTfMb7cZo0KLtSOkDXoKMBIaahrb6Pvq2WU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FUIH1F6NGssyVW4COeuJyW+JXf9ZOuXxGiqbs4A0riZEC9KRZSSdvKNcURoDsDRgh
	 9xYCbzX7EojI2QWlJla3qu7db5L+WQYXUZcNIeoO8I7Bq0+B09BmicfrMgxZ/Ox3on
	 bFe8B7Gi//6ibg1Rcjs9Q9iX4wuprOmsQHVd3UNmADXkOZuZMUFwH7kba1alb352e9
	 OJSNgp54/odFq5qdzwapiUJoJRaOPOoAwCSGsb7ksHyXtWMzlopVECEIT0G38kcQBE
	 pg6QF0PX4eGcaaN9wK+k7kydBrzrK2s+1vVH5dg8hQFATIYPm4jdZtaIfe7R5PvR2a
	 60xFyqANj+2cg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:02 +0100
Subject: [PATCH RFC v3 29/44] s390/hypfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-29-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=900; i=brauner@kernel.org;
 h=from:subject:message-id; bh=EnQ7f/LKwwXo6PyRpnVfj7bCGw1qYUMZQQO6IXtl1m0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9etzAs//A4QyrntTfr5Y7yH5s6yi2sbvx+oICZxt3h
 d1kbZ/4jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIk8e8HIcCtlltKlLKv9RupJ
 PUs2C3cvYefO2P3yrXS3UKbMrdVTVjH8M14Z2P06RDR52paz7g98lpWbd4vzSeWeD7J7ZqRssXQ
 eDwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: umobrmopagku4m3fjt7oou5z7se6rcje
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 84AB34000F
X-HE-Tag: 1794827382-488401
X-HE-Meta: U2FsdGVkX1+HYt9OcZigG6oT6KgvIyUUYEcf95YAcUtnukq0r9yQ819vAHTOh7xd79qq4Wz9M8BJbjTMSJADoix74IlKLKeH6UiNJ8yL4+2H/bbzj/6Nj0xaDCfNtTvy/Ob2M0u8ldA38FNqb0feKNGGpt0nUblWeaO1lgZYUy83rJPjlkENJD66quMH0P+XyXolC/jTI3RS80ak3s6C/uVCJMUh94dZ+ttPsxdmUqiM6fxH4Ad6xt2iH6b4QMH7X/h+Jk32K+Svq8n8NIC7Git7TRmaV0/fJ1aGxDj81UFn3ufKin5ztfb+L3jIGaYkrYlLxJRlYdzhLoUnQMaatIskw3FI9Hgz6x7Pb/30U9axy25vakXnYHcsCQvDL0IkVvprNt7rZeb9yMSO4qzUHwLTzLBmTLeNjoHM/gr8X5XIVNRXs48TwsCOHiQlWoR3Pwp0HCYpRKyKbuaB26B8Kx8QsKbjnPLW8v3DKOC4JFkMySVXoc82xJYZXxamPmKO7dwwYxYQ0wmir4qGkGyj9Bz/0oqWyfisH8cwN47EWKGzdwyRKVs46iIpEM/l6e+pKMXBriuivrCG739FVlmKuBL2/3egn+oqTBbSYGjqPloECULEnGqq6FuOYbvKAr8mPpNNpRuDvvuCFeUWZNi58lWUza8eSQk1/uZAu8SBhrEb/+td5spe7ZH3xuiI1IJhmFvulI3NGUzwg9xrPhcXh1NIdRe9y+Ty4axOM1cBYwk/89PtjOCr3Uc9+mvSU+Zu9VREOltZmo98g2DMFvFKFn2pExTpac0yOIV1hWcQiwRpz5rJ8UwAWUMysdO7l/xjacke1ivKXz7Ma2URxxVqM0CEqAJAnbO8ZcXZKNLdNB2I2uSj+rtDYsElFPvHhCGRVaWgbJuknPDEuf3bE2YcrWy2jEpvMO3riKd3UvgvVxUCNu6E8l6wjQqu4DuAxAgluf3zQDL9biyS0KeXDLN
 CIQ9yO3D
 OWyS9oy8Vjn1u0jXaiRg58odctmWEbZrj46sla9N8j6V7pKwcziDX+qzTa8bBfYU7KuVYrYjvgBzuyj4Yvu+AXpqMOCu8yTS4KnftmJD87UEYww+q0zAigaFXlJ6qMCsepHoYX6IdB7biBwVIcBo2tJqMrjA9Q13Ivz8b5OnAxMC1t/y5C/AtYghrsjMvESF42K/Aeczbth/Uz22tzmXXrli1pItO5htFmAmknHSUojgzuV52d9GmHyc8PN8TUylWD29zNdkEJfI4ilNJGhQ1OAaonAdv1nL60ZpkEreUSIN+wRM5sTFPrbzhLeZWxT2Rfeg3haX+IV1PlSh3qgkvRpPyp0oTEvpjibL5AQOv/nalobACuwt8kmL1rN0OiurHckZ3YTlIDqEUGvozvzb++JoEh/v0uRHngAxaohD71Dqic4epUgh6OfJG6JXlZLJaT6wf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize hypfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. hypfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/s390/hypfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 559b011e68800..8662169de477a 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/namei.h>
 #include <linux/vfs.h>
@@ -301,6 +302,7 @@ static int hypfs_init_fs_context(struct fs_context *fc)
 	sbi->gid = current_gid();
 
 	fc->s_fs_info = sbi;
+	fc_init_pseudo(fc);
 	fc->ops = &hypfs_context_ops;
 	return 0;
 }

-- 
2.53.0


