Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73137CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 17:04:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4C0D6B0205; Fri,  8 May 2026 13:04:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C234F6B0207; Fri,  8 May 2026 13:04:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B39806B0208; Fri,  8 May 2026 13:04:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2CF06B0205
	for <linux-mm@kvack.org>; Fri,  8 May 2026 13:04:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57449A01D6
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:04:51 +0000 (UTC)
X-FDA: 84744877182.16.B741D8C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4B1ED40005
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:04:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=geHnrGjH;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778259889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Uhqqq5zjmv++wjvi9vo5W4Deo40CH51hKj2PJiivblU=;
	b=7W+4Xsd+avVPiUcNzqgNKcFI2CBIgieaSuZSuI6Pn1/n6WoiH1J1L2hcmEIrVywCxVuKJu
	mNRXM0PJ67rEB8vi7E1sk2IK1dZdJWiFkth3yUAq5qwp8zmMMpKG2YZKxllnVom4fTrnYT
	96pD6cemeYRIIlFrMzsjfPbaZikxQLo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778259889; a=rsa-sha256;
	cv=none;
	b=J6zuibS9PifgR4+4zbw56ZUVuq1hu1Rs4SoSFn47LkjdjCJ1jelVOYxmUmwC/ZjJDQ9//h
	nHOJymR1SwXbu/65gI8yXqm6fN8O49RXgZFGbTd1Y9DR+wg0+/Ok1SmZrbgoog9Gd1ho5j
	RGK3p2bLI+3+adkxbTwPSqmJsGGRzFo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=geHnrGjH;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778259887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Uhqqq5zjmv++wjvi9vo5W4Deo40CH51hKj2PJiivblU=;
	b=geHnrGjHvyMFy0OlMecfdwP3kmn/+FLE2EZWiwP8072fPq/PvMBMy/QJF2LJGJ6V+tYqqw
	2gMxKack8yPVJw+aVV0qC9tQ2XJUPa8s+j+rKVHHbfp04R1LwsWTSy6/Dxp6OdQV74lw13
	dWP0qsEQIdCx5iXdC2Ef2q1QY3sDIwA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-632-p5EM7MKBMKSSwNgtKcwPFQ-1; Fri,
 08 May 2026 13:04:43 -0400
X-MC-Unique: p5EM7MKBMKSSwNgtKcwPFQ-1
X-Mimecast-MFC-AGG-ID: p5EM7MKBMKSSwNgtKcwPFQ_1778259880
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 45DE11800343;
	Fri,  8 May 2026 17:04:39 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.7])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1F1B43002D2F;
	Fri,  8 May 2026 17:04:33 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: yuzhao@google.com,
	usamaarif642@gmail.com,
	lance.yang@linux.dev,
	baohua@kernel.org,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	liam@infradead.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	ljs@kernel.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	Nico Pache <npache@redhat.com>
Subject: [RFC] mm: restrict zero-page remapping to underused THP splits
Date: Fri,  8 May 2026 11:05:09 -0600
Message-ID: <20260508170509.640851-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: JCAMPQIaSGhpzm6Curm0j7wjcBlsqMH9fOo9QtLgct8_1778259880
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4B1ED40005
X-Stat-Signature: 1isbuxdw4kakmpakpihheoidjg7zhm71
X-Rspam-User: 
X-HE-Tag: 1778259889-390228
X-HE-Meta: U2FsdGVkX1/crFOcQOS8sB5akwHK8FHRfCwWb8ApxiOhJ+rqpsXcvYA24g3Q1NrHoB/TyAZ6MmrWN1YhrX7raocYwXyePX3QNmU7R1UdZsCcVkHktE3Bza8qCxpy8owrgWKPQGIJOpTKzbfGT7iFk3fs4BVXL3D9/yN8e8OusN6HNjsxQYurNpvS/p/V9ElBl9vRMA/uSD5wKCV+Bob9xNSFHGNoHecY+HIg/+7sR4R6wOx4hlHaxr2wFUsNmG1PjS1tIKcXkrR8b9y1jvR4dZzz06u3jpgdloStH0ojd+QASguaU9r+dn06SBQ2dNmPyDu++R8R1MWYag1yGbXcXnOB5ScEuUVCTTcq4HleP1pBXQuIiEvaacOGisRIlopMDNIjVQ03Td/Rx3x+YK/EkeVA5SaCAkX0TzV5No7QrYJ/vu4IVZCNfNMjYPZw8Qs9ZBQ9qio+jmTWvt5igKirH01dgGzX2txoBRf4Ys5GDe5v8CNOc0aecUHEolb40s0kz2suimeGUt6dcAOx2lNBdIEPWcH7PtnvrsQm78oyyO1RKqA2XjZLBx/sL7KQRN5UoRTPwI2nmv/njdBsweWad2XM6aCJhx/u+DT+MC9AhAxTfKvAOoRrWI60uuNEgmjHnH0JJOQUW9UNy0lyrIvu1gdGYIO53n+BO4Jc3YYluGy4PbzWWvHYJ26yghm5UrThtF5rkwzJHWsRZlUS8a71gwTtB6kHcnUxu0Fz914RWAGgLBk9ABueObWtxf10/ISqsb0b9Ik0NxBp07sa0O8OwTn3QpbLohVpIIU9TsO+sBclFblzHteyZVs7+vT3HCDmCX7oA7vaHgBnq3KxbOmBPKEeDPPmCu5qI78FNXTu9T8CTdJDUwCIooG+d3M1FJvAqAT5WvUYO+UfXrGXpLmAeb0d01zrgC8PVF3bRMD8ulpvVVzja4WsX9aRHLCLOBe1mVazfZJH9/hJvyO2BWR
 gQecjWbC
 +s0TBIeS4Qpc9RC4UDrJNeQhtPgiH2KhDO2R4ZVzK71oQ2W9hMRVBbhAAs/AD9EovCaoNYdw+6uOM/j4+iK5XGoZomMAwl1o4ZdTW4w/9qmo/WH/neMWlpbD8ESHUDwosCY3ZY6PxF0qO7ljNBk15mdmQcHCGS6IXSqvYiIsoQDnI6oaE0jzAIbUPVQ+uarZfwsc0Jdyz2lfkybXJFO4P+ALJ3vPpP5Afn9CsKE4Pc7dLB0oZicRl5ltQ8JV2mlllNJV+x+CsT0N/TgZZfQapROssKCOqeaKVKW/+pLQqDezuX6VeIFOSh9j5G55Qz2vhOYhfgFZXSqon8yoZYMvtT7kFHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
when splitting isolated thp"), splitting an anonymous THP remaps all
zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
This flag is set unconditionally for every anonymous folio split,
including splits triggered by KSM.

When KSM is enabled with THP=always, this causes two regressions:

1. use_zero_pages=1: KSM calls try_to_merge_one_page() which triggers
   split_huge_page(). The split remaps all 512 zero-filled subpages to
   the shared zeropage at once, freeing the entire 2MB THP when KSM only
   intended to process a single 4KB page. This bypasses KSM's
   pages_to_scan rate limiting, causing ~1GB to be freed almost
   instantly.

2. use_zero_pages=0: The same split side-effect occurs through the
   stable/unstable tree merge paths. Each pages_to_scan iteration
   triggers an expensive split_huge_page() that silently frees 2MB,
   while the scanner wastes cycles on tree searches for zero-filled
   pages that were already freed as a side-effect.

Fix this by restricting TTU_USE_SHARED_ZEROPAGE to only the deferred
split shrinker path (deferred_split_scan), which is the only caller that
intentionally splits underused THPs to reclaim zero-filled subpages.
Introduce folio_split_underused() as a dedicated entry point that
passes is_underused_thp=true through __folio_split(), and use it from
deferred_split_scan(). All other split callers (KSM, compaction, etc.)
no longer get the zero-page remapping side-effect.

Reviewers notes: this patch is one of two potential approaches. This patch
turns off the zero-page freeing that has been done since the noted commit,
in all the other callers, only leaving the underused shrinker to do such
behavior. We can also take the opposite approach of with something like
split_huge_page_no_zeropage() and call this within KSM.

Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Signed-off-by: Nico Pache <npache@redhat.com>
---
 include/linux/huge_mm.h |  2 +-
 mm/huge_memory.c        | 17 ++++++++++++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2949e5acff35..4ae1b52d7411 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -378,7 +378,7 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 			   enum split_type split_type);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
-
+int folio_split_underused(struct folio *folio);
 static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..91f7fad72c8a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4045,7 +4045,8 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
  */
 static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
-		struct list_head *list, enum split_type split_type)
+		struct list_head *list, enum split_type split_type,
+		bool is_underused_thp)
 {
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
@@ -4174,7 +4175,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
-	if (!ret && is_anon && !folio_is_device_private(folio))
+	if (!ret && is_anon && !folio_is_device_private(folio) && is_underused_thp)
 		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
 
 	remap_page(folio, 1 << old_order, ttu_flags);
@@ -4309,7 +4310,7 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
 	struct folio *folio = page_folio(page);
 
 	return __folio_split(folio, new_order, &folio->page, page, list,
-			     SPLIT_TYPE_UNIFORM);
+			     SPLIT_TYPE_UNIFORM, false);
 }
 
 /**
@@ -4340,7 +4341,13 @@ int folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct list_head *list)
 {
 	return __folio_split(folio, new_order, split_at, &folio->page, list,
-			     SPLIT_TYPE_NON_UNIFORM);
+			     SPLIT_TYPE_NON_UNIFORM, false);
+}
+
+int folio_split_underused(struct folio *folio)
+{
+	return __folio_split(folio, 0, &folio->page, &folio->page,
+			     NULL, SPLIT_TYPE_NON_UNIFORM, true);
 }
 
 /**
@@ -4559,7 +4566,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 		}
 		if (!folio_trylock(folio))
 			goto requeue;
-		if (!split_folio(folio)) {
+		if (!folio_split_underused(folio)) {
 			did_split = true;
 			if (underused)
 				count_vm_event(THP_UNDERUSED_SPLIT_PAGE);
-- 
2.54.0


