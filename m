Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99012CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 17:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFF246B00A4; Thu, 11 Jun 2026 13:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAF2A6B00A8; Thu, 11 Jun 2026 13:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC5276B00AB; Thu, 11 Jun 2026 13:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAE236B00A4
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:31:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64421165643
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:31:23 +0000 (UTC)
X-FDA: 84868323246.12.3D8F3D6
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id D5630120003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:31:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=KJK6qiV0;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781199081;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XtXmcCiq3eJia7JzFxANPEPogqTgQiMYpvOYfxZs+RI=;
	b=kUCyYMXw0cX6QkXyYwRAfXB9u3LC+bN3r4MUaYvlq1yl+4jSiV4HMbEPrgaRHYQjZ2VH/v
	RA2G9zzxoHR2UYDRvuL4tW0uCQbvbac+QZi/MjRXf0eBy4z8Q6FTUXU0e4xLmMMMn5NmEp
	ITJr0DWM6UKGiK8wr9wo0c8tEha4y2Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=KJK6qiV0;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781199081;
	b=WPUmQTwZX0UbwCPYbp0W2HV3FE8bjFb5KYpaAbvYZkJOQ1XGBxdbF2j0ZKvC8v9FqP/4nx
	O1JYwcCiuod8yqSE5q/7LcVz+3zBbXrgGXvo0BtshwQbMsvoXgb7C8Ek6fypmJGiBUbG+h
	SrDcaCbTlQsHMzmCc8QQHDyazlCnH4U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XtXmcCiq3eJia7JzFxANPEPogqTgQiMYpvOYfxZs+RI=; b=KJK6qiV0e0G8WoQlcK2JqYtaui
	8miztq7wA6yYYX/f4HajFclZu8p1SKefoIT0q58+ZY6NpFablzxRG59VFh/+xfPLt5AbvsLlPmvmk
	X4RzoemUbpYOzr4K2d/WDoNwo4ic3kK5bFwC+K4IrLm/I4yKp6GwWbIjMpFvQu03zBhK+7hYbstEJ
	9qO2lQEVeBqiwYx4SO7xzIQcQQN3iMOXx3QdjKcJpuBngCbXGtPVH6rMtiOjDaRNXvH3GDaDjUyvT
	2nx2yo9mReMaNcG5Rn7kfRC63u+ihLXXxGgXthaboOXA1qvCcfuHDwWnGCrlcUYFNjH6xOvo0sN47
	hC09ZUeA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wXiz4-000000070nS-36xx;
	Thu, 11 Jun 2026 17:14:26 +0000
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
Subject: [PATCH v2 9/9] make ufs_inode_cache statically allocated
Date: Thu, 11 Jun 2026 18:14:24 +0100
Message-ID: <20260611171425.1671254-10-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
References: <20260611171309.GN2636677@ZenIV>
 <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D5630120003
X-Stat-Signature: 35awsme9ac94tmtn3oyw1fkz7x3tyyt6
X-Rspam-User: 
X-HE-Tag: 1781199081-342782
X-HE-Meta: U2FsdGVkX19n+JJXTP0/RM9Q6kbie3bEdd36VNnnbXbCJizNZsM/YYRIUXL2KwifMzQ7U3V6cokfM+dEF8XQnsV10rNRJklENb53+5RxBHD2jFtACpOzMigW9DmihkEro/qBi+hqEfBTZ6/QrKgguuWskRZo/XNQhLQjkrF7mO3lurUtl3bAgl4c9tPOMMP1Wfg6eS3voMNVfp2vgnYmLQFsLP0TZ4BvflPOtdz00z+LleNcumO5tCrRgkvNd3+ObHAC3G66eFK0EdUUhvuGXwP1E6Pbhw/XqSeNPIyfzxuAv4jojJ6bGHVyVna3wcPNmjldflCgoaSGeUS1pd+kuKfpI0loPbmuh6iKP9fuPwwLpXZLrI0qFURDVSSlTL8FOA9N+U4tTfZAIu03DAeX8n8vCUa/PcRnI35Pe7+M0zFA2b0xgaBqkSx/+Oc0I6XJKhWHuR6SR62lkzMHCRTselOC5OGugd81B9nEaJ/AJFRh5BRsVusPpMcwd0VEB8QpeIfc0prXcUbiDizbemM/99nMCNaNE66/UVDMa0XllR0N4UrJjZepzzKZUHh7hn8SQmZRQiY+NxusVcyRT3nP9JFliI+Bd4RpVigNZvh6bce6tCf842psK6vVfHNA9m66tgAQ2TfpspMIZbC2f1xW7LI+dfYhMDDmdLoEYkC9rHBUnE9dXEhEM3JRIXCot9kLNLzmUSYNeGDopuG3R+xql+P9+DXcymUE26xGqiUac4grE+9rAGyTL/lwGeOYrsdXZyeGdW2rmSvk2Nvh+86zIyFRbWsXbq9hmvUtU4idmUkbJuZvR4MW/wXwHTRhdejLXawFBeQugWBUo5aG0LE2u1CVjd72kea/NvSr5aJ4U2vctjMTN/iK54l5UZa4jVY0UJk3LWkFojEF/lsE3FAKfQzkFqs23/QrYhELirMFfDrSMfgcN6NRMZecu/QvS5T6t2g24REQqZscCxUh597
 vDS6IK5L
 0qAb0Q9aDZpNIODPyaIgrB38ScLPgySEEs/4ADFYszk4hQb1ZqFgsIXACbWwguvIxaQ3zXbGgGzc64oVEH/lfutFA+S5AchXfwFCZCDNyM4eevx3cuOAP42ItsJ9qidIVEJZHrGPe0HCNSDZbR1dcgdaPLXFGhHNiOtkx55oeWVfZbG1wTQZSYu8DmpOrVgFZzBrQdf9T5NVsbYiQZYSVnh4UmQUoB6eDl08BTcqYX/ASOg04kwC9YXk76Ex4m2vUttHKjb+/ckKvg3zGNyRnV0baY0bJmc2hvPQKKrdcF8if+LjZXEAk86ij4i6cWGkbHSODWjHbeYlaQHr4DZOmwQTaQhMeUvuRY8bQXBgUJ19oAVOHSQeGvukwGS1/VWi6CYK3wBAxQ+IXKEEywANiE1f47HC/r63BsZsVigjyPg42Llk/iG1u8thBE6r28pPsgjjR6WYhR9A2tMPZ595omuGqDg==
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


