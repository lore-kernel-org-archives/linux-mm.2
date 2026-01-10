Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0B45D277D1
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:01:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFA106B0098; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98526B009B; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976236B009B; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 79D5B6B009E
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 415CDAFCF4
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:02 +0000 (UTC)
X-FDA: 84314703564.07.36CD64E
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 565A0C0006
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Oh21CGyR;
	spf=none (imf22.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017660;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZf11oaVG8ivyzTNge5GHP/XJRZoy6qcj6JDxNkRnvE=;
	b=gxC54UFA7rRy5qGvosn+guzL+9wIeUPf5UnT+0R/twmrLtfohz9V6AWDU69pYmiCW83q0g
	uo5hlKXY52wi87PLGyV+m5tl3fg8H1oSo+cwEfr32Jh+MucWYNAekA4CBTlZSSWVcV5b/Z
	uPQ4sj1CDoNfsMpVJnJ9wD29pUiFGkY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Oh21CGyR;
	spf=none (imf22.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017660; a=rsa-sha256;
	cv=none;
	b=QkaQyLLrcZDUl+vE9cEY7VXKNvAh4obYQqB3mPYNbomFPyZ6W+MBM7ZO+dfhZ8RM6mFD2A
	9YAfInuDT8QI4++ZkHsHleCK98lTkBHq1pO/GrFP0OD4qchy4T4I8TUtdFAqKT5Zmk4dkw
	YMZgmdRDAJmFdk9s+BtcxabQxNLpDqQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tZf11oaVG8ivyzTNge5GHP/XJRZoy6qcj6JDxNkRnvE=; b=Oh21CGyRYIJtmhTTrv3WWAHFZk
	WyKnrb9+Lq4dJ6PThShkmi1OBPCSSw0dGVcCPQVYJzxTD9REu8ry8b21xI+yIW46s0d3s/AsKI0sE
	9DkUQ085pME+pCzCFJRGrbI/IRLOu5GG31NzMy2zbS+0OzxlXKMBNvJ52aq/eOvb7fH2BLtjku4fW
	hth0ZhhYJ1LWjAd71v02+xhnE4OiGdzZAP8pTQjm9k9jSnvothmroIKhCdLJZ4IARdo4me8gbPKXi
	Ocw9Tp2vCBQFtSeAdZHH3UeJTO2nwVOfCcniJG6O3gbWtHtN7NF0fMZmW8F14o5Wo2bwqfDf3uan/
	VN38yy2Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1veQB9-000000085bC-3YyP;
	Sat, 10 Jan 2026 04:02:19 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 14/15] turn inode_cachep static-duration
Date: Sat, 10 Jan 2026 04:02:16 +0000
Message-ID: <20260110040217.1927971-15-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 565A0C0006
X-Stat-Signature: h4fenufbjm747619cep49gxgu79hubhx
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768017660-116309
X-HE-Meta: U2FsdGVkX18cn+8TqVOHRefFumaDAbioLID1A1COGjxUqzJDuh5uuzMQPFYmLOvjZy8Jvx5ceN4cGKCSA7KL+z193jb+FmSx/DgEEqZHR2M8DWDNprMMB01kZwfvgF4fbFsK7sDZNB1yiRglvvXySz4N8LTfNn5Q1DzBIhZU4CZOfrJ4uPNMCM3fJwoW4vgIPbFWg2a55J/xz9UyuZLAp4hk2E8VJZVYWNfTqVCsd8Y5SthZ8dL+5ygZM98YJwemT4GXeLgmdPm35TLOvr9qOIshqjIBNzzm27j3u8vluk3bS+/k2C6MPQAO2U+QnTkdeKOGoI2KNT5m2KyOuughbXYqtABxbKh14Fc5Rug7pjCFrkdqNBtvcvTM3QzcvWNHWyJCmo26cdZ93NrI5stevVCQJ+VTocSJqnxD0m0Y610xPhaCxgXapLW6NF/FEydDsIywllOZdwLG4SonOqQ6l4sNn1EVQGmAhduoLpoRmcnWb9x7ws8HQmomF3dpBxQ4dc3ZIMVH40seTRKgVuLLJEbxAoK9plwP4laHu17VWRGwookHEF3LL4qFSVZUOLDXq2Uc5vkqZwW6Mh2Etbp4/8OYsLkaiYOpte+5MIWQ9CLOWIBqgI3ebqhR9fNVNdwhbwOKqqBh2XUqc5ur75XD1oOQBrFnTQThuxPmzFuQMhzMkQFKKy65YNWfthUMt08jlpBNSa3X6nlV4XOJB2NrkEWqg6LLkORHbZxTk/4h6Xi3A4kcdjUfR3spxZXQ71g3gYbtpGk44Jist+Rrd9iskKjRkGlXtehgpyJcmeZ6CX59uWXfyG2CM1pmlK/GNZXSB3UYwDjUA2IHh1sqAEec5jP6QzFZCap5bjnoxG6hcMcnSMGdjmFpjv9HNMkKixjq32IhmL0U22UB/CoHT6UI2mOY573KVy0f6XpXHATj86uKZkr6JxKLUPpdPgooX8TFi1L0lfZ2s1bicdRS38/
 J7MoexpC
 S+Efvfh+Bcaht2oudalf1JEREDRMRhxYok09H1Uw2x9NtE+bN8lbSwgugozBo+PeNxbXd14LaAMcflw1JECy9+oolOqsGmDqh7234HLDp4iempVzGv5efN0d/f0Ljd40/7RwIgCTa5a2rLajj+M7GWjs8RDAOm4vd+lkpAsg6IvyPKUS9lMeciO5LQL+kYMItNqGXZFNgiusbEiQ9zKxLWcqhfMgdnqZ4ep4SicLhZZUqSekALdKJbVMB2ikKu0WurAshAfGyWkgvMzG0I9XMlTCYljTNV0hjNQ9j08oqITzRVHjvdsCqVt70ENW4X//jn5pWSsv84p2n94TbSml3NEYiXavwrcCXfjpYofASv9w4D9BitfTVvWpyT49j9F+zfNLo5ULnlgQR7/6XytGyDNaCzwq9ee61F4dm/mw2jF1TIemLBHUoEhL1GOBLwnLTl/Toh0OfgR6o3h8cNfScqOtyNEGUc2GOdP1a2cQwlsh8asYsSpnOeRyk+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 521383223d8a..7c212696ba67 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -23,6 +23,7 @@
 #include <linux/rw_hint.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/slab-static.h>
 #include <trace/events/writeback.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/timestamp.h>
@@ -76,7 +77,8 @@ EXPORT_SYMBOL(empty_aops);
 static DEFINE_PER_CPU(unsigned long, nr_inodes);
 static DEFINE_PER_CPU(unsigned long, nr_unused);
 
-static struct kmem_cache *inode_cachep __ro_after_init;
+static struct kmem_cache_opaque inode_cache;
+#define inode_cachep to_kmem_cache(&inode_cache)
 
 static long get_nr_inodes(void)
 {
@@ -2564,7 +2566,7 @@ void __init inode_init_early(void)
 void __init inode_init(void)
 {
 	/* inode slab cache */
-	inode_cachep = kmem_cache_create("inode_cache",
+	kmem_cache_setup(inode_cachep, "inode_cache",
 					 sizeof(struct inode),
 					 0,
 					 (SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
-- 
2.47.3


