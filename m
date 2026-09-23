Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55E6FC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 20:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58A656B0088; Wed, 23 Sep 2026 16:09:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E7E6B008A; Wed, 23 Sep 2026 16:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42A336B0093; Wed, 23 Sep 2026 16:09:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1AE986B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:09:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9131E12087D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:09:41 +0000 (UTC)
X-FDA: 85246117362.19.A36F2C2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 67F2C1A000B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:09:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FJu6gYxw;
	spf=pass (imf19.hostedemail.com: domain of agruenba@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=agruenba@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790194179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4bP7fGq0D9N6et9vLtHh3ggTZ3WPfdjkQHIKkyIDF3Y=;
	b=RR4Rf1PgLYLbxOgaiZnhdF9ciOG+3UM6mh6ZC5Q547Z8o8oss4JNMinrhUMxOXM8tUARZx
	FaYH7Hg0l0eqCNq1nS6Cc3/Q1nVsj8IJkELFYtlV5TbabwpqcInHeUW6btchEadSiNZwB1
	fhp5nI2lb3f3jN+NE4bHrWH6clMX1ig=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FJu6gYxw;
	spf=pass (imf19.hostedemail.com: domain of agruenba@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=agruenba@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790194179;
	b=7ObEZ3qLC/mrD71p9aKyRMeD75zl5DG60rwB+IwQRZMNvatfudQ2GX3jVhTpb32/wS7842
	J6r7kbUYp4GSKaxculB7TQPNU0VhNmHp+4LxUtrNyfEdmm4o9kJTxP0vOZi6YrkRdmCFlv
	t5R1wBg6yPUF9ze5OzqhPbHui8poF2w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790194178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4bP7fGq0D9N6et9vLtHh3ggTZ3WPfdjkQHIKkyIDF3Y=;
	b=FJu6gYxwDpUlzQnxmb6/P9MHz+QgKOovb0c28Z5wFTRO1b+iiJCQqYUuXCWV2xMycpdW/Y
	1LBuOBNQK+GDerRrAgzGXqjuemw5BWm63mVOovqthNiVKaih9VH3DZ24jcoAht8o3aG4Ix
	dX+ZJcDnN4S6GCpJ2sl3ECvgUE6PHGM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-382-3bUbSWLjMwaswqP8KKIuJA-1; Wed,
 23 Sep 2026 16:09:35 -0400
X-MC-Unique: 3bUbSWLjMwaswqP8KKIuJA-1
X-Mimecast-MFC-AGG-ID: 3bUbSWLjMwaswqP8KKIuJA_1790194174
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 37B9218011FC;
	Wed, 23 Sep 2026 20:09:33 +0000 (UTC)
Received: from pasta.redhat.com (unknown [10.44.48.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1A7591956087;
	Wed, 23 Sep 2026 20:09:28 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>
Subject: Re: [PATCH v2 3/5] fs: Basic infrastructure for offloading inode reclaim
Date: Wed, 23 Sep 2026 22:09:26 +0200
Message-ID: <20260923200927.1834507-1-agruenba@redhat.com>
In-Reply-To: 20260911085142.1774803-8-jack@suse.cz
References: 20260911085142.1774803-8-jack@suse.cz
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: R_LkzNv1GAPRwSPv8sXMjcFES9zw1J6ZR2pAhe_1MY8_1790194174
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 67F2C1A000B
X-Stat-Signature: bxhg5i6tmkpert5uwoi73358oiuo3drw
X-HE-Tag: 1790194179-424632
X-HE-Meta: U2FsdGVkX1/aRjPQNC2MSMZldOAHiJ3iouvO5AchT1izjvL/EigXH7OjzYKYz3t+7QL9Np6NFUtxJIdWQ/N+hp4KqkYyfzOlsv5taMGNWeoB64rIKwqx0J1sBpjfPM21TVkmMZFSklIfCs6Ww0jno3MQEBK93uvdElG2bgQrO6nZPK7dQXIHfjYnDw1LlbHNMgUKPHosIfK7Vj2phU979YL6wAg73jzsecYI5dIKyLd2Dk0Rx4/Xv3d/ZyNbnoUdyPOaK04QCbulYg8DHgm8gaCMub2nGt+eDif43Cpgv0+xjMoeE7vJmsM4JfnUunh7mReEeZcH2hCqom1qb1/ELBOu7QJKfrUI/46eAM57fIrG8KuNmg9DAMAc7uOyGeMISsMl94enQBf2l/HYnm2OILwbZ8HZnV88a0woCvQw8MA/uAPouk6QUcCE7ERZCsfDEdkb0gSv0j57ssARqFAYwcL3+yIJHp9Nsc4tq5ooFXRLwv36b0JWhv4ggNCUzeQI4xMQa0xWQVefEbbIHbLo1xDZhhW35N5oxHlTk6CTiNXtWFB5A2aBROk/QjbqYzcrkASa06rPixswPpluxEyuz5IXLYoAmRrRAGHIUgtMCqMKKQbFrHi8ehJH96pRwIwSJLTSJRXmZd3engmhJtZYBv1+j350/sCcKil+tb//VceRlXeDJcKaXDRjj/s0y8kwaLbYw56LHahLDdvDxbnRvFbj7baarvYg2rxjZKu3g4ly2GEO+On1Ge0kHLBt8WgBL6DvmRgMCuwMD5HktssQ/1peANbdk79jjtuKW+L2rFlPrPMIc2yw5TUDgCW8yJE5oTVcBVV2azbclQ5e+oCX14aQUFG+afdFQHEpc+HCLpd7uF8eUmWMkcAQWDNhmxYa/3UdyNDPC8L5IJVuVrYQShSdIQHyMlb19pq5/Ooqjk3SrTk87mpbrekpqhuS1btl37SSjIQs97ib5PCRk1N
 2unNF6kz
 2WkrAsudVQZJSB5i+l7JwF8yUCS5Ss9KmzYyuNJBB3ikFDocUyRKYmL59S03pVPebYSme69BHw757TGQWYc4WOh63rFBqCOon4MB8Ru/bv1YCfeXO/M6tE9q17OMd3TPU7U8/lYtpXh/jOjCw2ypmwBgD+IxzRoMxgJqXzIJnqYS6oL7wYMCAB/i3Z8BEjH2oruOdSjFoV+5+puR2+BjKo97QYiEZnEybNp1t/8Pj1o4/Q//tOZD++tL/2S9Xo9y5dL38f6rmls4saWpQUskXBtkQCqzYjlVCuu6OC/0ilLgxQCHp9ND4J99LMWqlxQE9y3os
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jan,

it seems that we don't really need struct inodes_to_prune; see below.

diff --git a/fs/inode.c b/fs/inode.c
index 7c69ef44619a..f8303af66fcd 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -938,12 +938,6 @@ void evict_inodes(struct super_block *sb)
 }
 EXPORT_SYMBOL_GPL(evict_inodes);
 
-struct inodes_to_prune {
-	struct list_head freeable;
-	struct list_head deferred;
-	unsigned int deferred_count;
-};
-
 /*
  * Isolate the inode from the LRU in preparation for freeing it.
  *
@@ -958,7 +952,7 @@ struct inodes_to_prune {
 static enum lru_status inode_lru_isolate(struct list_head *item,
 		struct list_lru_one *lru, void *arg)
 {
-	struct inodes_to_prune *lists = arg;
+	struct list_head *freeable = arg;
 	struct inode	*inode = container_of(item, struct inode, i_lru);
 
 	/*
@@ -1013,13 +1007,7 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 
 	WARN_ON(inode_state_read(inode) & I_NEW);
 	inode_state_set(inode, I_FREEING);
-	/* Inode will take long time to cleanup. Offload that to worker. */
-	if (inode_state_read(inode) & I_DEFER_RECLAIM) {
-		list_lru_isolate_move(lru, &inode->i_lru, &lists->deferred);
-		lists->deferred_count++;
-	} else {
-		list_lru_isolate_move(lru, &inode->i_lru, &lists->freeable);
-	}
+	list_lru_isolate_move(lru, &inode->i_lru, freeable);
 	spin_unlock(&inode->i_lock);
 
 	this_cpu_dec(nr_unused);
@@ -1042,27 +1030,34 @@ static int get_deferred_sb_id(struct super_block *sb)
  */
 long prune_icache_sb(struct super_block *sb, struct shrink_control *sc)
 {
-	struct inodes_to_prune lists = {
-		.freeable = LIST_HEAD_INIT(lists.freeable),
-		.deferred = LIST_HEAD_INIT(lists.deferred),
-	};
-	long freed;
+	struct inode *inode, *tmp;
+	long freed, deferred = 0;
+	LIST_HEAD(freeable);
 
 	freed = list_lru_shrink_walk(&sb->s_inode_lru, sc,
-				     inode_lru_isolate, &lists);
-	dispose_list(&lists.freeable);
-	if (!list_empty(&lists.deferred)) {
+				     inode_lru_isolate, &freeable);
+
+	list_for_each_entry_safe(inode, tmp, &freeable, i_lru) {
+		if (inode_state_read(inode) & I_DEFER_RECLAIM) {
+			deferred++;
+			continue;
+		}
+		list_del_init(&inode->i_lru);
+		evict(inode);
+		cond_resched();
+	}
+
+	if (!list_empty(&freeable)) {
 		int id = get_deferred_sb_id(sb);
 		int i, wake_count;
 
 		spin_lock(&deferred_reclaim.queues[id].lock);
-		list_splice_tail(&lists.deferred,
-				 &deferred_reclaim.queues[id].list);
-		atomic_add(lists.deferred_count, &sb->s_deferred_reclaim_count);
+		list_splice_tail(&freeable, &deferred_reclaim.queues[id].list);
+		atomic_add(deferred, &sb->s_deferred_reclaim_count);
 		spin_unlock(&deferred_reclaim.queues[id].lock);
 
 		/* Queue works to process inodes we've added to the list */
-		wake_count = (lists.deferred_count + INODE_RECLAIM_BATCH_SIZE)
+		wake_count = (deferred + INODE_RECLAIM_BATCH_SIZE)
 						/ INODE_RECLAIM_BATCH_SIZE;
 		if (wake_count > deferred_reclaim.workers)
 			wake_count = deferred_reclaim.workers;
-- 
2.55.0

Thanks,
Andreas


