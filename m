Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF354606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rY+wQo1z
Received: by kanga.kvack.org (Postfix)
	id E36E46B05B3; Wed, 28 Oct 2026 22:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7BA6B05B8; Wed, 28 Oct 2026 22:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D251D6B05B9; Wed, 28 Oct 2026 22:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B154A6B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:58:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 47B2B140246
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:58:15 +0000 (UTC)
X-FDA: 85374154950.07.E008AB3
Received: from mta1.migadu.com (out-230.mta1.migadu.com [95.215.58.230])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4C3C540007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:58:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rY+wQo1z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.230 as permitted sender) smtp.mailfrom=liu.yun@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793242693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4t/58VQY6uGFv3BJNd/mxfYYdph2iDJI3P4xclljW2E=;
	b=1zPIRrDRfMeOmjWbfznp88UDj4rYLebDFn9BnW82l+kaJYoZpqZay6Eggcf80T3FSEwa80
	HSrx5u0Cx2AXazH6N6+X60eHfzZFux4wIHgfw98vND0VRI6/aGUG8CKPKPcHSusmcur+ZS
	BtBdnPRnFkoQwyUNIId8wyqgXwhtF/M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rY+wQo1z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.230 as permitted sender) smtp.mailfrom=liu.yun@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793242693;
	b=q3S6X+Y07tJiXiuSbvfzVMcIfjAz69T0J5Hc7qs0MhX2wTbWi1ABDpoWcqEdD9e271jw1P
	eFymoiumlHPdlmL9uiv39JdP4bmuyBW+pUKFYwH9tSWS3EpoMUbxvAXD5bBpkiKBWKCBGW
	/zhNVho7AO2kOskM8PMCMO2krnpWCgg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+39d0NGOMvaVIPFPclocdM/7kXjxTVeWQYHVHxVYSk4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793242692; v=1; x=1793847492;
 b=rY+wQo1zuXcI1/YW3ZCR93n6sav6UjsvA3Gf6F+9/V+qgYt2nXklK6nKXrdgrczEP24qdt3y
 dPCAvV3rcL8J+5ZIRdLt8DESjX3vp/7TEdKmdB5Sx1Kn2e55WS1n0b7jrESlv+x2AT8QyE6gvz4
 xJ1eBI2Pa79bjpTyfj3ez4bc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6be960242b83a71d;
	Thu, 29 Oct 2026 02:58:11 +0000
X-Mizu-Trace-ID: 6be960242b83a71d
X-Migadu-Flow: FLOW_OUT
From: Jackie Liu <liu.yun@linux.dev>
To: glider@google.com
Cc: dvyukov@google.com,
	elver@google.com,
	pjw@kernel.org,
	alex@ghiti.fr,
	aou@eecs.berkeley.edu,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	muchun.song@linux.dev,
	liu.yun@linux.dev
Subject: [PATCH v2 1/3] kfence: fix pool cleanup on metadata allocation failure
Date: Thu, 29 Oct 2026 10:57:41 +0800
Message-ID: <7e0fc28c73fbb594c296f6121ca506392511ba5e.1793242457.git.liuyun01@kylinos.cn>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793242457.git.liuyun01@kylinos.cn>
References: <cover.1793242457.git.liuyun01@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4C3C540007
X-Rspam-User: 
X-Stat-Signature: yiqjxe3aubp841drtx5eiqdsne3jjknj
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793242693-904303
X-HE-Meta: U2FsdGVkX1+MgP5fLj1/aK/N8oz+A5jQPnShSDS1wZitrJMx7zD71ov7lkBbNFwzLDAmU/KffelDsDinyvudraeRfXDsy4+nVXyRobxL1twj80VSYauebJ/ir+fPwjKnrMmOfs5LNG1C5USTMsGAxMZx9Jti2pAYaH9pf/+RyQEaMWRipryrXdex7RdIfAismugeOl6BiNUAkd1h4MWZLcrPaU81R0Oh5wp03V0VyU44RybcmNvEGa6WcWqpOEfNIYPgQ94ORWFLv/ciAijgy9ZpNs6o4GZs+V8Snh2OW4R8YfRFedhT855dKMpe6/m1avDrpxEVEk3NFBd7URFWtz6dFuGpFkaFuYEBrkE6CcHb4W20BZS2gfANq9KsYYJPPyglBNUwnNkN0nCKPhIa7aXLCz0TBzB/iyBn1P+rJCHHYFMBbndyZhxu5cFM2sJadUQCTQpOm48XFUqXW/DuTvgazJZvY+ldqKOlfP2GIzu+it4LiOpjrLNqJO4YnPbivgNco3wpTLqdUpe9BAN686uNHdHu3P5Ucbjk3c0wN2cAsDclfWvTBfUHU7WVA14tGJJnCh6qBQEhXt3bjk8XIcOp+qGtuFPxH0ozrKIuKN85lKRwt6izhiPh+9A4jS954cbI8Qjq3IG7eYwGRBeD8t7zkMR63Tal3iGQCuas5StwNYkVYjpIaFE9IkJfFRVGQgen5eqIvkT8cebs/csDucuN8MhvjlCnX1y8B7B2zYSXosnxkFpE4CG7GJ5rzvNrFNS6fv+4bwXhIXpjwRrxDwldWK31DBcs5gDq3KcsJia6pJViwdkb+oxHIZIORlLK58QXnIu7Rv1s1Z9+vSkinOmEPnbKvtMcObymZmwbT1ShCHOgoc5PI/HfYudrQSI2bHaYlZl9o2G8ER8kS1g08o7lY0fe6Wtnm3OEvKy1v+tX1XTroh/GbUrhHi1JcRzyqRbQLsxYlMMZzixpmGp
 q2tq7cFu
 yQsLXmJdy6C0Hb4oound2lJcaCaTe82qYI9bfZ7Nt290LJM8aJqNeo4VRvB5zg73nH3UQLMvHlQHKBgbcfHxaXIlMuO81YxGidpJBeHNdvcptbVaW1EqlZc+Lmw/NvrZiHgqqkq6OdX1KcFk4pZJ6piJljuhyWIvO++fP9ZtXbx1Lm7H2rM35wJg4VGTUDUv4Y3wIX9o/lJm618l+/J1kaXTxnVbcv7DviyLXA+HA3SyK72s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Jackie Liu <liuyun01@kylinos.cn>

kfence_init_late() saves __kfence_pool in addr before allocating the pool,
so addr is still NULL if metadata allocation fails. The error path then
tries to free pages using that address.

Set addr after pool allocation so cleanup frees the allocated pool.

Fixes: cabdf74e6b31 ("mm: kfence: allocate kfence_metadata at runtime")
Cc: stable@vger.kernel.org
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Reviewed-by: Marco Elver <elver@google.com>
---
 mm/kfence/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 90925c646c4c..6e3d01bccdf1 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -999,7 +999,7 @@ static int kfence_init_late(void)
 {
 	const unsigned long nr_pages_pool = KFENCE_POOL_SIZE / PAGE_SIZE;
 	const unsigned long nr_pages_meta = KFENCE_METADATA_SIZE / PAGE_SIZE;
-	unsigned long addr = (unsigned long)__kfence_pool;
+	unsigned long addr;
 	unsigned long free_size = KFENCE_POOL_SIZE;
 	int err = -ENOMEM;
 
@@ -1032,6 +1032,7 @@ static int kfence_init_late(void)
 						 GFP_KERNEL | __GFP_SKIP_KASAN);
 #endif
 
+	addr = (unsigned long)__kfence_pool;
 	if (!kfence_metadata_init)
 		goto free_pool;
 
-- 
2.56.0


