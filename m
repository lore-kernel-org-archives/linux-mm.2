Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DA29CD98CF
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 05:10:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B23126B008C; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA5E66B00A0; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 947266B009F; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DD716B008C
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCE861651D9
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:58 +0000 (UTC)
X-FDA: 84873712476.12.3615DE2
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 14D4840005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=is2Egeu6;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781327397;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQVmtnuRTUVgN+XDKa4kk4jqSyJyiqHHhlvxjk0X6XI=;
	b=jrzCs7mhUN1nNw9qAkaPAiDA9rksUHjLx7/HWhSStoPtj4OHeH9FxPwnNec9SyrKyD2Y7h
	axSSthlcAnfx65Vh2EDZE4R1tPKF0bsg1OTRKbhQbCN8uxV1ZjCl1GsHmG/ifiLREVf8pK
	B2Ww5UlEhRUc6aAMvLgUfzRI2YlwE5E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=is2Egeu6;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781327397;
	b=QKrci71qK4zq75BSu7lT6TavKVHn9O43iCrOWRdrb8Al4W8N35JbLJE7pVg/c+xkMVTMs/
	GOqPfcZ0dLxT9SKy35AdV2z3YNmMF/HNJjylpShchZtAQfRCjFc/iZnY8oRz9HPxCDJ63E
	gl5TuOLnTrk6LBiK0MTerw40YEfHu4U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XQVmtnuRTUVgN+XDKa4kk4jqSyJyiqHHhlvxjk0X6XI=; b=is2Egeu6/E0Y59HwEGUchJIXbu
	vvsTtdmBZVMK9LVkHzW5SRn8tRwn8haNo97Vx6NZxgxFEEPJVVOPdliXHTN9GexiGDWV/mqmXTcA8
	vTfgF1nIfWZKBhfV5HkbwQ6FjA3hvM0e0PDElW34aUCUUTN+ozI8zgzNjOUP6Lb/LqJUxuoc/xZP4
	j5XSX6SpMJjb8qlFtUdEq3mKuQhl7xoBTAm5BV08AzyNvC8aX13uRur90nerQGGkzCCQNHMpk1UTN
	DUgSVtPIJpFiFqEU2bgsuvMk2CEw/NOUHFF5PORb/YmV3ERUzaGFz9D7j+DtVtdMwiNs+xBPPjOuu
	tbCUcFWg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wYGcy-00000003aTH-3jDL;
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
Subject: [RFC PATCH v3 07/10] make bh_cachep statically allocated
Date: Sat, 13 Jun 2026 06:09:48 +0100
Message-ID: <20260613050951.855141-8-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260613050951.855141-1-viro@zeniv.linux.org.uk>
References: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
 <20260613050951.855141-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 14D4840005
X-Stat-Signature: 769o6315g9g7zsukur8y5w3413ypedyu
X-Rspam-User: 
X-HE-Tag: 1781327396-202242
X-HE-Meta: U2FsdGVkX18zHMrNbo3NJDh2I3Hzc46vrrQTClfuhbihDuhb857EZ/C18Ow8XrSyCYL7qEzGAT6JzywNEO7MV1N0TbhSBdyrQJhU79/PoUyZ20iOZCJivjldIzH4lLjTwZOkmqzYD06BnA1oWOXlDnYi2XcN7ACcgFQKxdgvWjjofnp4lwU3opCeZXb8N534qQJS5vpS5Ha9zF649vZsrIjPrBwZzpBgK6JgIitb/SGeyGKtqHTsPgm0nFZgBmmwnFVJ6AumHRpKqlnPjwGieD0saljMKWJx5LHGAqorO1tNw1a8DJ0II7GlPfnOxe9hevwOZBjlqjm1tHVCN7T2NM1a+3VDg3o8zcKO11C6RbjbsRIa69fuLy0iTpexsEK65SSmC51TeGBfcR4iRevo30dTFQ0bBMy/6bFDnpJ6/5p+KpMQqxxlpdieHG8G3L8N6DzmgghH6qVi8zJIMh27RlpEf9bfYCCK/J9d9++Vry5LmfbclyYsc7+6Gy9JZD2COe+W6vnbdh0M6HSpgnDFLvWqsE1yHtCYelVjrNjhg+h/XP3juQtZ9ItH1ircnLJ6B9eCgXBckN0UlnHIMVsvBJy6xLemFKIxhxyAgBs65T/oelhY64kHcLD03KY8J0CxkrS8WQJyRwlOJuVkCKGjeTFRb2tKRJrcVrwtIvcdZRdT68Z3Gsv5E25u1IEcsqhBluTxAyfUpR9eRnkDOuXBzu63oaFJYabjRgFzUpxbP8pB++RT1p4K5+V73Du13iA9M9/v/7v0PJQO/rT8nyaEWz2OfJoqxIVeE2obdp+diueCdCiOJyPSvoOoa/R74Mgr1fLDAhNaRx98yr5dwUxQC2lbkwFmgQAv8v7gWiptW6EdwO4odoG3Uxv+1EOBLGyTEBMPIRwrg+rNoCyvWJtF638j9vE4p2foooHbsKtBr1SgW26jgAHXPrQi+gQ8fB4T0JTnNHRvwu7iyS2Jjsk
 GtVaMCWm
 L2rqAgmszzD9YR3cH/ABSYDNxTn1kObcOb6n74mqqX3q8xF/kv8l7kA7kfnAO5gO9KqVdZgeSi3uH6OokMN/E2w1LXeQFahlVz+6v+3Kw9/md/UEGRSKVUsiyMba3qqqMnUxU5p4i0UUP4yjeAKzrbdI65g+Z+Lnp1CK/E98+h2iWhdc0g8do606UvAsGq1QuYC8MApyGm9mHcWs/B5DDeXc7UTr5f/tMK57Uj/pcnsSjGUpypSwhChhKwR9OrlWV10KRVvS+ZLLnrHs144QGmjPlqe2yKSgKr7VzcpepejdBztzCGNNf9zXqHnZijGCoRz1lZWfZtIVsEmBHMcfBGZul6HJMvUTI8EZgdAiGZVQoA43ZAvUJEr+orYi5/K4kIV92XJ2JAifPECPqpXk6rQSePH0SbtCGQPRJPV2mm4ucdz8TGAPPYX9ruo/lCeICYJ/4Nb2NbGqYceOPhkogdbs2bRhPeOzKilmHbJ51AWmYJqsMh2pwZTh2HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/buffer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b0b3792b1496..e834f7091f51 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -51,6 +51,7 @@
 #include <linux/fscrypt.h>
 #include <linux/fsverity.h>
 #include <linux/sched/isolation.h>
+#include <linux/slab-static.h>
 
 #include "internal.h"
 
@@ -2906,7 +2907,8 @@ EXPORT_SYMBOL(try_to_free_buffers);
 /*
  * Buffer-head allocation
  */
-static struct kmem_cache *bh_cachep __ro_after_init;
+static struct kmem_cache_opaque bh_cache;
+#define bh_cachep to_kmem_cache(&bh_cache)
 
 /*
  * Once the number of bh's in the machine exceeds this level, we start
@@ -3065,7 +3067,7 @@ void __init buffer_init(void)
 	unsigned long nrpages;
 	int ret;
 
-	bh_cachep = KMEM_CACHE(buffer_head,
+	KMEM_CACHE_SETUP(bh_cachep, buffer_head,
 				SLAB_RECLAIM_ACCOUNT|SLAB_PANIC);
 	/*
 	 * Limit the bh occupancy to 10% of ZONE_NORMAL
-- 
2.47.3


