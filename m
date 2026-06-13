Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55D71CD98C5
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 05:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E5776B0092; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 995DA6B008C; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85BE06B009E; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F1D16B0095
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D327FC177E
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:58 +0000 (UTC)
X-FDA: 84873712476.02.7632985
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1ADC620005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=gDTlF0Jp;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781327397;
	b=lgMRKZulypPsO7KvLJfcNGln2+h9Q5K0AAuSSB0BpYSOfjwJ73NaxiHOwA/u/oo0yp3a6A
	agmoB6YMrYVeiTf/uCIGvVU0Q12KNF0O9KeinOOOCQfxbelRhpSiZHqEWIbdSFYyPYVwgC
	QR98e55edqs1Tge3PkTb3lm1iRgqDHM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=gDTlF0Jp;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781327397;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6f3OoggzlPIzKQe/th8iqmFArhYwFRFyJgw+Gf2/5vg=;
	b=EMWMkmlBqWlV0NNM7SLz+vwgCplcFKx6XhtwtmIt/XQCUVhrK9Ag1zFV13YpxidGh2HU5r
	7Ysgkl6ZXljTN6zNQRVREy5J/Azc8HQwX15xOodtpVcKwplQXophKqyhKRvwcPnBAdf7LW
	BXsCpPRqzlO7hvH8qT6NObgBNEu28Sw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6f3OoggzlPIzKQe/th8iqmFArhYwFRFyJgw+Gf2/5vg=; b=gDTlF0Jp7OiugKRzAwtDz8Jfwm
	neDfrE+2AytAPJEGebM+9vkv8xGIEzPWzFLqaLdDuS+qGjNBPML5W4bYsKzqZQFruNy6Q2NHb2TQ+
	cUxO+r8m3+1QTQfcSTteMRP5eI3oP4kikzh/m7pvN7NNTH7Q3x+VIR2oVSgGlVHhuakPNwbfeIJzK
	Mg7DxKAChWsErdIaxYK4TGeXWjY5m8mHOw6eD+U6lIw1+rXMScNQ+Y0hbISppLVKdbU1jSfAPYPDR
	4EXK3CI+dIusUiQmPK4CrOD/KDdnbtD59Qf10pLNBVIzvyq74rejZxZhUmSetIlA5zb8bxAUI6slN
	jTboEJ9Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wYGcy-00000003aT9-2z85;
	Sat, 13 Jun 2026 05:09:52 +0000
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
Subject: [RFC PATCH v3 05/10] make inode_cache statically allocated
Date: Sat, 13 Jun 2026 06:09:46 +0100
Message-ID: <20260613050951.855141-6-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260613050951.855141-1-viro@zeniv.linux.org.uk>
References: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
 <20260613050951.855141-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1ADC620005
X-Rspam-User: 
X-Stat-Signature: 4e5yfiujz6jje969ut97z68j1crmpb1p
X-HE-Tag: 1781327396-163892
X-HE-Meta: U2FsdGVkX1+SEDBaStu8uB/+NAvwCf9IfjgEnRuQz06PXFaQeOPODmK8yHT5dahrdHOETDu+acmDlOIhipLVSikDgVB1UH19yPQm+GKf0w73Hp1DMJn11gvqB/5m8hBpKivz1zGVnVtes4BZqZskfsS+Je8EDWSbnJBFdsSnKNS9hQX/d5eB73myq24b94rP2zsTrM40AI5opJ1DYWM9eCeGGoxjz85ClXWXfKC7K5xVUMCxv3NdR1OmXX54NwQPDZsoXFw7OqpBQmWze20v+UA1EqEFyCuxOO5jpfB2iqQZyB291HElUnMSx2hGmZxJI31q+WB0BKGC++req6vTKjCImNwwa55Lj4EJnFtwX/ZZzdPbF7wFPmvTU/79mDQfAIVXk9uq4u5HytB31HqsvMt+56mPZztDPZzfuMlBelCZV1+M0trLXyYbonQHGJh5cWSu67PHB3cNIDNnXsjN2oUADtxXcbObM8kHlM7IxdII9GRTOYZo/o+YeegdGLSQXa4QGom30ku70L6EHWu119QlrCPBFi7l7VcA7ZOWD/ujOtzAB9muJ4n9dNkIEpjLR3CjjPM70T9S761Xx8n3lpm5CHfi1v4165LOOnVRhpzbRGE2seIzOwxOk1d1qmsSlsfLYpr27OA08ifvDNYNaEdKCL0Z4O0f/O3PnKZTxW4HfQfiqz9XL1mjhhqZiZV5tTEW/GUgZhWFhAw8Jfo31wj2ffRUPg020r8eC4MpHBYuRQzzL5RKFCXmbmNPor57LqTIaSQOJvdFsMzBDKPuI5+05sXLtfk3e5Xg+ItzNa/5HJLozuzwpKERCGLXOQiUa3Xf8sdEbFG6gm0x4bcJrDcUz/LydusjLrZdlit/fyQKVR0Pc/zXbUwj+gxs2Iw1eLsocETbCPgfsQmEZuG35YAfT+yOabOK2e7ptgng+AtVN2BiSBJD4z6W6TxQuSk1B067tV3Cuy9AN/CSe+0
 uTDc8zkC
 q1HAnlKALB73qh+h0anAkd4VUN1URAGn05hEoOIHlFz4A8eTejI1XV7tqheEJ91JYKggbb3u3QxJcQ5HKuTJmNF0HZOsJcmagl1H5grYpopNIkx9KM4Jke+UygYYIs+e/mGrSoQWIkZHwpPtVPWIvSLLCPgMFNC3DQTD6I6z4S+8oOWNwBATu8tPtccyb33cHt2TR0hc/W6inX4SNZ3bwyKvpoLWMw8WH13LYc9okobggrvtnT5329aPwy9E00Bg9NCkVwzcMJNrAaLdCSsdDkMd7Jxp4wl0s01k8ioLV5r2oGerYVAanAgY+PxJy3qYdOxbbfeazJA1jX0qJTZWaPep6kFhZccHEihUMFOtkt8i5kZphytCNEswSBS3ZjAeGPxg/qzGYeBM0pa1HdfsaXw2/wk8lMmAPorG7cDAtplXEvZ0BMKqcDxuLu8Ou7ojXFP3VokI+0kIxbxoW2nbUTLzAGSs60XxQVf99xAIiwQ0nVqsfErz+q+aJfA==
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
index 62c579a0cf7d..1c657ac99084 100644
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
@@ -2598,7 +2600,7 @@ void __init inode_init_early(void)
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


