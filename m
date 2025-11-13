Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C071CD98D3
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 19:13:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA3288E000E; Thu, 13 Nov 2025 14:13:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C53358E0002; Thu, 13 Nov 2025 14:13:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B42B48E000E; Thu, 13 Nov 2025 14:13:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CDAD8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:13:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29B055C6E4
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:13:30 +0000 (UTC)
X-FDA: 84106532580.24.D5EF710
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3C99F140014
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:13:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ypy0j+Fx;
	spf=pass (imf23.hostedemail.com: domain of agruenba@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=agruenba@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763061208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TyHzdpDFZ+y9Xq3UcqZS1nBRZScwrGk9PLsYYKXTicQ=;
	b=eVEqgGCK/O/Gs9abSF6C/w+mDUsAM09hZRn9Wd6VuT/8vNU5Y748cuUjCpuJYWLvscIHvb
	AdZAHBbm3NO+krnB118rJGwHwN8NPqM3rPsvO6agmKfQl05OJjHDbe10o+mPNb/BBfyAPM
	QMqY/aWqwJy/J53k80/fVznvP1I0MBk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763061208; a=rsa-sha256;
	cv=none;
	b=gTABybh/LND73/c/8KyNhNtAsAxk2gvGGNMjbYTH5EWuhSEEz4y09eP1OuhK1eJ2DyONpM
	QNfpq9cGHeOFoxVDAgj8wc3s7f9HpAJaaqxldzcJ/gY1p1NhYsTXA+5wwQlei7u65543Ue
	mIsZ5I3e1aYllYZLuQ5QBjkVLNsk8qA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ypy0j+Fx;
	spf=pass (imf23.hostedemail.com: domain of agruenba@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=agruenba@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763061207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TyHzdpDFZ+y9Xq3UcqZS1nBRZScwrGk9PLsYYKXTicQ=;
	b=Ypy0j+Fxtqgrw+2RrBDKC8CU142cXxqqCqEcRrK61eScCMePItcE3eruaVcLcoYWw1taOc
	vDU//F7L8OpkGbSFPZvQeRfre/eye3YHnc8SxNwWsrh7xOUuMB10ljugjS8wa1MvlmUbvo
	tiMmSu5HC0ot7tcIOb0jKQYEFLZAK/Y=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-422-15YijcbmNi2ii0LkA0cgSg-1; Thu,
 13 Nov 2025 14:13:26 -0500
X-MC-Unique: 15YijcbmNi2ii0LkA0cgSg-1
X-Mimecast-MFC-AGG-ID: 15YijcbmNi2ii0LkA0cgSg_1763061204
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A2DD719560A1;
	Thu, 13 Nov 2025 19:13:23 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.44.32.90])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 097331800451;
	Thu, 13 Nov 2025 19:13:15 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: gfs2@lists.linux.dev
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Dave Chinner <david@fromorbit.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Price <anprice@redhat.com>
Subject: [PATCH] gfs2: Prevent recursive memory reclaim
Date: Thu, 13 Nov 2025 19:13:14 +0000
Message-ID: <20251113191314.1679300-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3C99F140014
X-Stat-Signature: fhobg964xijfkx9emaopoyq49txmxquu
X-Rspam-User: 
X-HE-Tag: 1763061208-832179
X-HE-Meta: U2FsdGVkX1+gcD04z1ivRbtvqlE0kM7ZGWHbPNtO3MmgJQa8Bz2+0AgLTWOGWDtcus3MaiH6fBNSC6Rot8Skt7IWvJ3VlqlCPQuYq+5Lnz7p8/kjrIBbb157y9HjZMkHOfcvDsW3SjNdUosP2VyaUras8yhYR0Ypv2asepQHQAWIfewCoNfhVstlnvkA8gCPBLfr+noKRRiSvQ4vtnLMnEcgsUwuRObmkr/P6zo+LeS74CjarNNOCyb2EAQd8mzl1Zagm5S3ETLYwCX7pzHV6gJkKa4dPFqoFYv7Zu4nDheHRnBBptKPI0XNU5Ze2mpwC8GzVCZBy7PmP/ihyeIs3+fxGH/m3lsNMUfHyj1moOBfgZ/Mh1Bf7x2GxhcyqMXeXRcUHOneeon4Irt5Pul0WST8om8SJ5PVpGquJwaKm3+GIH3OLOxIq6yhuJLypmsoWDcK2gnzlXbtIRH4VrkQKCdpM4nK6quPSfpNR35ZQ525s90om3WajVQSlR1ApO91u4GuHFN82RhAPBd+YsTiVlRk13oa/T3cFsY9j9hzq8gbDezV41vE7Ez4RdJJuuF+71zmieEBR7ptmx7iOrNekz95LU3nujQOG5Nzu4aiX2ebTpKiB4BjGmD5+FUGT21/seKmC7n1xF0miFViOfXqZdBUsxHsb2MvHdaGXtLgJDwsLvzP/KWqq59zR3zAnGMT4EAJrBdDaEcZrwKvvtGRDil90IROm2YYeCoRtNRznHgQ2WQjehRvxdvjKL2FwpcQunv+SgGI/1IPa81Idcj35zj1J6y0XH0xo/0R7npchKdcgg9joiprTqLOnqUGbLe0qJ8rCqqO5nOuuo5wLWQEWR7w6U9Pnjb8IvNenQxpq0C4YONJB1vYSy32AoxbWwbBi2oAKA1BvoTFNPQWTkDKzFspGca3o0yJIQMVr0KOlMWQSATrJ+0HKLyTLGZk9mQCRSUsAcEWfSmzx1AB0R1
 GZ5UlzsB
 Z0yUo9G2ACcWa7VorzzAV0SxShanuQNtaI/g5D6mT2Dxf+ZQ6GVaR7pDo+gB8J65domyfjMCVqD+UI3PswUu+tY7wYNwGuY7UG51ZiKbUEmHPLh0SNyJ3gSg+GmRyW2Ejb+7bTMQOnUJSoSRKCEf+vAwEEWs3OofS+LAbumu6L54HpiIrVzW7w9r/jwANGz59+2a+pRCLifihOLdcgs1Po0T04iRqYNbIK2IOsh6OYXknFctnTuX5I7eX/UHWGDnepdq1htlYckHsjrDivIICFnGzWrgRHNzGnoXN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Function new_inode() returns a new inode with inode->i_mapping->gfp_mask
set to GFP_HIGHUSER_MOVABLE.  This value includes the __GFP_FS flag, so
allocations in that address space can recurse into filesystem memory
reclaim.  We don't want that to happen because it can consume a
significant amount of stack memory.

Worse than that is that it can also deadlock: for example, in several
places, gfs2_unstuff_dinode() is called inside filesystem transactions.
This calls calls filemap_grab_folio(), which can allocate a new folio,
which can trigger memory reclaim.  If memory reclaim recurses into the
filesystem and starts another transaction, a deadlock will ensue.

To fix these kinds of problems, prevent memory reclaim from recursing
into filesystem code by making sure that the gfp_mask of inode address
spaces doesn't include __GFP_FS.

The "meta" and resource group address spaces were already using GFP_NOFS
as their gfp_mask (which doesn't include __GFP_FS).  Inodes allocated by
new_inode() will have their inode->i_mapping->gfp_mask set to
GFP_HIGHUSER_MOVABLE, which is less restrictive than GFP_NOFS, though.
To avoid being overly limiting, use the default value and only knock off
the __GFP_FS flag.  I'm not sure if this will actually make a
difference, but it also shouldn't hurt.

This patch is loosely based on commit ad22c7a043c2 ("xfs: prevent stack
overflows from page cache allocation").

Fixes xfstest generic/273.

Reviewed-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/glock.c      |  5 ++++-
 fs/gfs2/inode.c      | 15 +++++++++++++++
 fs/gfs2/inode.h      |  1 +
 fs/gfs2/ops_fstype.c |  2 +-
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index b677c0e6b9ab..9f2eb7e38569 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1211,10 +1211,13 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 
 	mapping = gfs2_glock2aspace(gl);
 	if (mapping) {
+		gfp_t gfp_mask;
+
                 mapping->a_ops = &gfs2_meta_aops;
 		mapping->host = sdp->sd_inode;
 		mapping->flags = 0;
-		mapping_set_gfp_mask(mapping, GFP_NOFS);
+		gfp_mask = mapping_gfp_mask(sdp->sd_inode->i_mapping);
+		mapping_set_gfp_mask(mapping, gfp_mask);
 		mapping->i_private_data = NULL;
 		mapping->writeback_index = 0;
 	}
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 8a7ed80d9f2d..d7e35a05c161 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -89,6 +89,19 @@ static int iget_set(struct inode *inode, void *opaque)
 	return 0;
 }
 
+void gfs2_setup_inode(struct inode *inode)
+{
+	gfp_t gfp_mask;
+
+	/*
+	 * Ensure all page cache allocations are done from GFP_NOFS context to
+	 * prevent direct reclaim recursion back into the filesystem and blowing
+	 * stacks or deadlocking.
+	 */
+	gfp_mask = mapping_gfp_mask(inode->i_mapping);
+	mapping_set_gfp_mask(inode->i_mapping, gfp_mask & ~__GFP_FS);
+}
+
 /**
  * gfs2_inode_lookup - Lookup an inode
  * @sb: The super block
@@ -132,6 +145,7 @@ struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned int type,
 		struct gfs2_glock *io_gl;
 		int extra_flags = 0;
 
+		gfs2_setup_inode(inode);
 		error = gfs2_glock_get(sdp, no_addr, &gfs2_inode_glops, CREATE,
 				       &ip->i_gl);
 		if (unlikely(error))
@@ -752,6 +766,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	error = -ENOMEM;
 	if (!inode)
 		goto fail_gunlock;
+	gfs2_setup_inode(inode);
 	ip = GFS2_I(inode);
 
 	error = posix_acl_create(dir, &mode, &default_acl, &acl);
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index e43f08eb26e7..2fcd96dd1361 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -86,6 +86,7 @@ static inline int gfs2_check_internal_file_size(struct inode *inode,
 	return -EIO;
 }
 
+void gfs2_setup_inode(struct inode *inode);
 struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type,
 			        u64 no_addr, u64 no_formal_ino,
 			        unsigned int blktype);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index aa15183f9a16..1a2db8053da0 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1183,7 +1183,7 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	mapping = gfs2_aspace(sdp);
 	mapping->a_ops = &gfs2_rgrp_aops;
-	mapping_set_gfp_mask(mapping, GFP_NOFS);
+	gfs2_setup_inode(sdp->sd_inode);
 
 	error = init_names(sdp, silent);
 	if (error)
-- 
2.51.0


