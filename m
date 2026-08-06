Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F6B3C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 593396B00A9; Wed,  5 Aug 2026 21:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CECC6B00A5; Wed,  5 Aug 2026 21:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 396366B00A9; Wed,  5 Aug 2026 21:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE9BA6B00A5
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:12:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5762C062C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:12:15 +0000 (UTC)
X-FDA: 85069068630.19.7DB5E3D
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2D1C4100009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:12:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ue8/quJh";
	spf=pass (imf05.hostedemail.com: domain of 3bN9zagcKCFU6L1FzxF3BB381.zB985AHK-997Ixz7.BE3@flex--jyescas.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3bN9zagcKCFU6L1FzxF3BB381.zB985AHK-997Ixz7.BE3@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DoxO0tzkkRxeSpf9e1eNsTCkLzdHL150fG3Ixk6g9Us=;
	b=seLMUKN4b1/vru3YHYLDUTb68q8e707pMRMg82tzESe6E9WV/zx2usJynC2JaVCqNi4sXJ
	xj7RtNHazBKjt9ANo6wx3X0iq81vQRFDodRhST+0rZeePff8oylA/TaZhzW/yOfELJyY9s
	aQRhUDRKobQLoy7Y0Rr2IhISINwaHAo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785978734;
	b=dhgvKrln6EU+9AkF7xTH51Z4Vm1JmR4auHdgHkkjLB3EXERVzPh8Bi1wQ7DSYp/NfajQNW
	aMU4zbRrIjyOzhIpcINbdvQlMw7KhH88pAhPWamxljh0Lb0RifXaxBtxZ1IKf6PBWxhXn2
	RwjvOUpF9Y6IGycrVSoiFR97NyKMR4Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ue8/quJh";
	spf=pass (imf05.hostedemail.com: domain of 3bN9zagcKCFU6L1FzxF3BB381.zB985AHK-997Ixz7.BE3@flex--jyescas.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3bN9zagcKCFU6L1FzxF3BB381.zB985AHK-997Ixz7.BE3@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3811279d51aso2636522a91.1
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 18:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785978733; x=1786583533; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DoxO0tzkkRxeSpf9e1eNsTCkLzdHL150fG3Ixk6g9Us=;
        b=ue8/quJho7SNVT+xJ8F/Mguae9GxmZLi4Cg/KS6OqI8lmO+P3WbWmq/4Cki43GKCDL
         VEcN9zfns2nqJqYkBiU63S2M0kyRJGyeejVeNXEEcINzkKtCK9CeJCOk13OlotwUlgA3
         FzZsDK42HegNeMtKw8PjK9MCGdrjwzZhoGPSkTrARdwHpGSwiw7q7M58OG47O3ZtGtWh
         uexgoBDqbssEQGuFpwu0n8aQ/IgUaWsTN6RDCJ4lrRBbPNQUBLItHMzV87rAa6DzONz0
         VxPo4tv6Rsgo1m5FcGZpaEoHBeFO1YynWU5yn275rYcy8OQSpyHTeMqIbPlpkkU3B1JZ
         TbmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785978733; x=1786583533;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DoxO0tzkkRxeSpf9e1eNsTCkLzdHL150fG3Ixk6g9Us=;
        b=cRYFfsL7VPyBgCoW7HlmLr2axRJgFsa8hlB4kMfxf2qKYxtsHl5AVMLFMPVbf4Sxn4
         EKoCbM3bf0pKi2PyOMYOsXFFzJf99ucm/sFWJNdMUzbVT7FqFnyGmoHtEIeQ9DhzHSAG
         WuQb1q43WIBW4jz6KNONW6YUtazKRpJEWIFKBxTgZXxJqy71RvTKvEdN6lVkdQoW5OSR
         r3Jv08Df6NuhvHU7Lw5RTV+ukbdnamXcToU6ooQIcYXFTI1x7hJjwPTfNYyTxAFS/+3n
         Bshpxlq3daTZ8Wuy7JmN0Ielh+0pAe7sOr3UPeVJkGQLL20OVEkpiKuTfC4qUqFJgGGv
         /DZA==
X-Forwarded-Encrypted: i=1; AHgh+RqPnRmu03l6A9A1yh5EhZXw+qtWycd2yFeEWer252VimEYT0ACVE2ETFk9tiOU2L5PM4t0A+4TVOw==@kvack.org
X-Gm-Message-State: AOJu0YxpKxwM9OZ7zv7kV2M0ZCLTLboK62TNoewe3lsszIWAozRpCvTd
	kkrAR3loh917hkhNCK5WoZubRlN/e628B2xYiH2N42GNnx31jjp0Y/MO+O2dpTNn7GTFyGWyIzx
	oNgXJYgrpnw==
X-Received: from dld11.prod.google.com ([2002:a05:7022:30b:b0:13e:5fe8:61ef])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:560c:b0:38e:70d5:b12d
 with SMTP id 98e67ed59e1d1-3903c537991mr11924708a91.6.1785978732757; Wed, 05
 Aug 2026 18:12:12 -0700 (PDT)
Date: Wed,  5 Aug 2026 18:09:07 -0700
In-Reply-To: <20260806011048.517229-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Message-ID: <20260806011048.517229-7-jyescas@google.com>
Subject: [RFC PATCH v2 06/16] mm: Define function to create a dir for each
 page order
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, ljs@kernel.org, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2D1C4100009
X-Stat-Signature: qr4ee5za164pqgtawkkoj6ws4b9e8e5j
X-HE-Tag: 1785978734-992799
X-HE-Meta: U2FsdGVkX19hz4WsgGak/n0sjWYtgbfRu3t/VYcZhwlqxp9yi6NIYnPIuYdqlJLSVWaj8uG8z7dW17Jt2gjt5CAHS59xJLGb/XixrFKYhNmfHgPc2LM6o+PhHAXUrZVuPp9CF3jD8kOCZWZHN4h3ZfDR7qy9NxNbihwwBhP0kTf6hSzeNtAjb0oH8JRxgFe7WZ14VyV527zRCS+4/l8FdFANMjMTrKL3JI6UCBrLuv+uLW2huj0aCbdkUuz5/ErzPt40TKf3lUFNq4ioyV708pBjTq36cdLs92hDmCR65eO8Ef9ru5BT/uqSzPMPfroTtV6H0CjsN7juWqukyC0F4DcsgxBsBN7BrVYXXZ8LhY4pWdmq21sowlqlpnI0dZcBgQhNWDL0s5blKM99I7vVq5t20Puuyz2zqGY9kT9ryYzVh3TmTOnl4A0Z+NhVIECLoKaxUW55kJnxkLhIcUIomaQMq/cOYdFb18BigAtLstrzIKwkGLOoQiDlPFzKZfRGEk8VXNGD3XO89W/JgVxxsnmHC3pwF02kRHwvalG6pLM8rlI2UG1qWqPRcmnlGTOq/R+XqKliFvPOo0q8InCTILmFCfaOeeFZobEyHwRSVWhxNy9Q7ugZ7d31HipBwRaNVAXxJJb8ogdlv35jGTIRzH+WkptAFHpknOZendAfP8cF+VG2JcqSl+62h9vd1fbUfsqx1VyFMG3RAFanfhFgvwwE48P5NkB53zvgffjaz/t2mVzItP/bHrWDFaxtyITjlSihVLZt8LTkU5TcVK/8lXUsnVofaeMF4g15aCpiWT9BsglMvlsvUaB0fYVeL79gLJmRy2nX0Q/0caZ/+RYVbuPdho3UPrzMKeEpB8muSRIPkJFebM8BWnwXnJFs/881xeupLqewQZ8HCD6GD9mNS2YfyIUQY8A1Q8++4YgBkpqagZe/tVz1bx7gXqZn8fn+SfBV4T9YTEX1ejFQIEG
 hExpb4SU
 JPE/RoNVNZZbNzW5zlcyyjC7DGFRkFKjxb4w777XWHW1UrG0azbrSyx9yZx4VGdPDWQl3QZYen3Ag7Vahbf/wgzeSQZPsWCeBnnmEW9f5NhM2wyoNGrlOYIaiQJ0g/4A+2YS3ar4Cu3Lsc1qNlBoyU5Qy+d6VyUQfp0oBMvgccogz81yFQrSL5pXI948D0Cf2MPcgaDvUX7bwUQh0rNg4kG3Tj9jnxy20hJPYr5GPT0auaPx7xwMW0ZWGhfZJI2UaKpbuIrdhmwl2uWa6izLEGUaWWfZ96ZFtLMGsMkZsiD4HCD8zRddPkGLt91gW5EkJ1Iz4qBPqYV9RNo1eZsB/oBq6xIW24EZqSYAcLMS5CBClQ3gKF+Q3lZpZVUHvfcyCFVbPzHuA2bldyxXOcmKePJzlkXEFLLXjIpmBAoHDPxWsGLwC8hgbeIJhVQD5vv/gxPsEys7tOZ9Zu5eSvKA97Aw2ru2jIayCt/0R8zk7kepQO5zggU3KED8pE+6S07r6yncgL4FxfQ053ujCAx8f+iJ5g/9/QdJfHxjDyxb7KTZHrUPGdC4az5G7aKDniwcyFfSZ8LsyY1snO0Tiy+JKyZR7kKUjSHX9ErNm93hhjSFPwCwZgQBVpcaVcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change creates a directory for each page order inside
the zone directory.

Signed-off-by: Juan Yescas <jyescas@google.com>
---

Changes in v2:
	- Update comments.
	- Remove unused parameters in function.

 mm/page_alloc_hogger.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index e8944080e82e..24856f7ea5d7 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -127,10 +127,29 @@ struct page_alloc {
 static struct kmem_cache *req_alloc_cache;
 static struct kmem_cache *page_alloc_cache;
 
+/**
+ * create_page_orders_subdirs() - Creates a directory for each page order inside
+ * the zone directory.
+ */
+static inline int create_page_orders_subdirs(struct dentry *zonedir)
+{
+	struct dentry *orderdir;
+	char dirname[12];
+
+	for (int order = 0; order < NR_PAGE_ORDERS; order++) {
+		snprintf(dirname, sizeof(dirname), "order-%d", order);
+		orderdir = debugfs_create_dir(dirname, zonedir);
+		if (IS_ERR(orderdir))
+			return PTR_ERR(orderdir);
+	}
+
+	return 0;
+}
 
 /**
  * create_zones_subdirs() - Creates a directory for each populated zone in the
- * node.
+ * node. Once that the zone directory is created, it creates a directory for
+ * each order supported.
  *
  * Note: ZONE_DEVICE pages won't be allocated using this driver. The main reason
  * is because they are not managed by the Buddy Allocator or CMA allocator.
@@ -142,6 +161,7 @@ static inline int create_zones_subdirs(struct dentry *nodedir,
 	struct zone *zone;
 	struct zone *node_zones = pgdata->node_zones;
 	char dirname[24];
+	int ret;
 
 	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
 		if (!populated_zone(zone))
@@ -155,6 +175,10 @@ static inline int create_zones_subdirs(struct dentry *nodedir,
 		zonedir = debugfs_create_dir(dirname, nodedir);
 		if (IS_ERR(zonedir))
 			return PTR_ERR(zonedir);
+
+		ret = create_page_orders_subdirs(zonedir);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
-- 
2.55.0.629.g250fe7f194-goog


