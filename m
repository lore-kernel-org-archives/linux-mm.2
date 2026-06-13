Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97B80CD98CF
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 05:10:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D671B6B0005; Sat, 13 Jun 2026 01:10:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3F8A6B009B; Sat, 13 Jun 2026 01:10:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7CD26B009E; Sat, 13 Jun 2026 01:10:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B19076B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:10:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F9301C148B
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:10:01 +0000 (UTC)
X-FDA: 84873712602.25.3328740
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 011AF180006
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=dyHeeylu;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781327400;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XtXmcCiq3eJia7JzFxANPEPogqTgQiMYpvOYfxZs+RI=;
	b=nEtcrzVYKjVJT/uhhIjM+MKwsyabYgQbB20KopOpXsQr4pn/ile2v+YvLtz/VAazQLyw/8
	vAsCCTdf+NuhU7T3XOKhmAdBvktFE+/9JF7Kq5CaCHR4KiVBUHUpIyHYvmcTZCkE/DkAL7
	khqT9Xfo36gjUsxcp4txicTEzwgwn2Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=dyHeeylu;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781327400;
	b=540ePq3ePqR9LjpINJaApQh2gbG35W/nEQlOeNIVz0CRNj9n3EEJhpvssuiTUD0Sf9Jq0g
	6Y6rXdZfcPcrXfrK9QMfo7+Thpb1yOBnMsc8SozQoRxjntlPbtwCq2JcuT9bjIl/j7JgV+
	6/x+FqVNiHkoukSp+SZWF3euQAfAorM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XtXmcCiq3eJia7JzFxANPEPogqTgQiMYpvOYfxZs+RI=; b=dyHeeyluUZy0tNF1xDjbs0cye7
	QUcXMQZKt43B3au7afpBnDPKDBhntdCElDqVDjY9EJQgqkojGccgFEKSF/HAeGzL7IL9UiSae5SkO
	F2CAOSLyLjsg/amwKum+/sSSreXBmAVZf5xM6T7xydiEEWGuUKCqusP80B+3xdQTIegxxtEklg4cg
	kX70DJ1Hl4m86ch4m88Oh3VMfDgTZW75wmlXoPeV6YVlTO9eNpVtvqb9rvFumP/ZCyUQBzvJ8Sp7f
	3Vr289ENtvgX7U8OnsiY48SG+fbD580ulV80A/V/yssae8KDpSSxZ3bxI0qq3A5tjOmAVw5zHDutr
	NaedRhgg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wYGcz-00000003aTZ-2SiR;
	Sat, 13 Jun 2026 05:09:53 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 10/10] make ufs_inode_cache statically allocated
Date: Sat, 13 Jun 2026 06:09:51 +0100
Message-ID: <20260613050951.855141-11-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260613050951.855141-1-viro@zeniv.linux.org.uk>
References: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
 <20260613050951.855141-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 011AF180006
X-Rspam-User: 
X-Stat-Signature: muk7smbw8wcaoteckz5uqtokiawyxqce
X-Rspamd-Server: rspam09
X-HE-Tag: 1781327399-700531
X-HE-Meta: U2FsdGVkX1/r+D9SDI4GGzK/7OgrolVGCWbJq1j+4ZQkf6v1eRls8mv4u9d+6bpuXB3PWQGcLlhXjqLTtObOE6wXd1PgWNV2eWBcu7jDivIFiBxYXo3nX3nxQOPzqDwYBNc1czzkt9zwDTY4ADqkAsp/KTk5QCE+BOfDTMsCKE58gx9W8+U48OZ/q1nlBLmJsMbLNI5JXtuXYl4aV0yEt/K/DyP0Yxgbh/t4eqYYxxwCklV1S8N5ESnrpgFDqWrW87owPx+C2A3Ecm7tqiuF7l0hsixvzZEMDnmnef1CI1vwAGAXt7+lM89F7scbbG9nYKGUGdx9XC55TGtAl19b2n9BMQNMd0IeCWf9Y/0kKZ+u3OnrIz80WCtKODeIAg5R6kLonyekvPbXITk2voW21SAVkjcvR+glfn9AxUuEu1Wn7WNP9JzDtisHObu06ZFa6APbV9kzhMBbptjteW+g2kghlzNh3AaY9lSy0KgnMvj1iP0hgi7RaUgrIVntUjHo4kArfoSdycO8YVLdj6PsNtoU7mkODElwGjdTos7Ra88pdPu1wgzKxv7BeQ/3l4JXv+9hO/NHBzeBTiyUUXVQ31NehE1LEE4QdUPPgQyWD+mZ56E2tSutC0GlGH+Lv+Rb1pPfzWFeGezT565PsmgcIJ9/ht4g+p7fIcd3Xx8TMynqx5dCrQu6FpvYujyvlX/sezLLeRZnMPn3wIznEEvEAM40CRHJVXGhsfMuHISbB3x+vMFREQXFx85k5jT3z1Q3YKA4IQEeDZGac6ivilYV//gWofOm46l5StGv6jR73C45ReUTR93vlV8tZfdW6p7KpYj+XFgSxfKqAu/YrwkhpNPmvLsNPC6uz9siUWV4803LrHwnpbQKXL5znudZLtnOEthN2TTaKOfL/roffhT8Vy88d/mctKzC14gWHGHxWrumxGGQSb9sp3vWC7zG6jcDNf4BtNrU3S0tuTqpKYk
 qEzskCr2
 whWFN8//UHI4D/bXbe0PJV/gf7pfDR1lNfjKysDdmz9iYSATaCtHNAKwOWczyOYQ/Z5xEL3WC+Erws00NG3Gg8vsQSeN5osizatU61W381RB81ffkDMh2WrFqW3z3eyHcomscclLGBZhT2lz8n/h8VdAF7F40lgwyehnTGKz+nn56ohWTj8pdCvSnkFkdJvoLLjn4mXj1VmWGrPbJ1thbWFUQVxMBc/KlMLHJsMH09vT/n+6LMwBJDy74A6XNIwJjBKwoH5HY+OQ7A1iVMNvUXRfzCKc75Wpf7nyZ3CcKfdrSYnxD0dIYdi3nPZCC+zwDj3XkZDoIdSy48yN9ig5WVBTRKKm47vvY+8s2xyqEKxZPtlT3E3bPfPqld+LvCSYFwYXyCLQ+73s35RK1sDtJQtRWCNflVLYqmoDkLt1vd55CX4ps+TEN6WhX9ZfuIAYQmLdAIy7KGjLgbDsb9bmyfkSvSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A modular example I used for testing...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/ufs/super.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index c4831a8b9b3f..72053bc9c8dc 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -90,6 +90,7 @@
 #include <linux/log2.h>
 #include <linux/seq_file.h>
 #include <linux/iversion.h>
+#include <linux/slab-static.h>
 
 #include "ufs_fs.h"
 #include "ufs.h"
@@ -1353,7 +1354,8 @@ static int ufs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
-static struct kmem_cache * ufs_inode_cachep;
+static struct kmem_cache_opaque ufs_inode_cache;
+#define ufs_inode_cachep to_kmem_cache(&ufs_inode_cache)
 
 static struct inode *ufs_alloc_inode(struct super_block *sb)
 {
@@ -1383,16 +1385,13 @@ static void init_once(void *foo)
 
 static int __init init_inodecache(void)
 {
-	ufs_inode_cachep = kmem_cache_create_usercopy("ufs_inode_cache",
+	return kmem_cache_setup_usercopy(ufs_inode_cachep, "ufs_inode_cache",
 				sizeof(struct ufs_inode_info), 0,
 				(SLAB_RECLAIM_ACCOUNT | SLAB_ACCOUNT),
 				offsetof(struct ufs_inode_info, i_u1.i_symlink),
 				sizeof_field(struct ufs_inode_info,
 					i_u1.i_symlink),
 				init_once);
-	if (ufs_inode_cachep == NULL)
-		return -ENOMEM;
-	return 0;
 }
 
 static void destroy_inodecache(void)
-- 
2.47.3


