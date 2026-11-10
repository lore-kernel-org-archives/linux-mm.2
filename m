Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6976460A383D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=bsqIqyVz
Received: by kanga.kvack.org (Postfix)
	id 86D7B6B05C1; Tue, 10 Nov 2026 06:50:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8449E6B05C3; Tue, 10 Nov 2026 06:50:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 783666B05D7; Tue, 10 Nov 2026 06:50:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 54C1F6B05C1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:50:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CDEBFA06BF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:50:00 +0000 (UTC)
X-FDA: 85419040560.19.F4D651B
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf25.hostedemail.com (Postfix) with ESMTP id E720FA0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:49:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=bsqIqyVz;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794311398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YFBzfgvcaAI9nXT1PpZ0S3WFs1S5hCkHR2kcZ8iUck=;
	b=caBqCgslu3wN9kZUFNNL83JH2Q9Zhz+LxCvVMcpxKNOBjnm0wo8THVQjDAtf6kzR/Fgl1e
	Bb1o+3wz5GgsZZiJb5XW++0DC2ixPNJUeVrD2iEOHWBlf253ni+5+KboMiRx6D7gm2wmRm
	rDvotJH5RJCpTWYpMpzBqHkUWs5PCFQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794311398;
	b=XehjG+iHJ4857Tdyf3qC4rA0aaYevI+FYyHcpFcl0/ZIt0PPgQmu5YDaKxA3GkTRl9MAkO
	pm+7TXGIgd88FnyXbRN/uiuogNeBgDTdqYQgF4AFHLjsv/vg9yy406w6oYYCE/8lWxuwSr
	q7nGU5j9FvB8PjewrWqFJ8J0DYzPOig=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=bsqIqyVz;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794311392; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=6YFBzfgvcaAI9nXT1PpZ0S3WFs1S5hCkHR2kcZ8iUck=;
 b=bsqIqyVz1AUrOF8aU5CbYX+0FyX7WRjc392zC8KiC9oPXHBYnFazvHxf31bYQALgw3y21P
 rN3ooYdumcekSv93NJZumytc/u6+xQeYHEA4Vghv5nPVGLH0Dk1tYGIWz4iz5sw0RcckEk
 l1YPzSPiSIpElte33m3A0wltHa9ZfrfaFFqXAIOxvzel3QPcsFWpOlGtPoSQd2Eszd4kKL
 dlhj0NDg2YtMoZ1B1npBFfq3GrdFWug3qNXg7Gzjyf7A2OhUFXN8rkVXnsMayQiOu+aovf
 Whi4s5Oi70dusFI54nrIB+9ptprt+dWxeX2IEq9w46764B4kYpGHHRQw+EiV5Q==
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v2 1/2] mm/mm_init: factor out memmap_init_page_from_template()
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <balbirs@nvidia.com>, 
	<david@kernel.org>, <muchun.song@linux.dev>, <osalvador@suse.de>, 
	<rppt@kernel.org>
Date: Tue, 10 Nov 2026 19:48:58 +0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110114859.76343-1-lizhe.67@bytedance.com>
In-Reply-To: <20261110114859.76343-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26af304de+46af57+kvack.org+lizhe.67@bytedance.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20261110114859.76343-2-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: y3p6nyujnqou4ze1ki5df4jtifjawdfk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E720FA0005
X-Rspam-User: 
X-HE-Tag: 1794311397-860273
X-HE-Meta: U2FsdGVkX19J6xURbM+7g7VMSFlQgiD23dahXjys6NS3NWnk9mEWDlDTiEdRl54YPH3oTQhVVtcoYT21UoDPKTkot1riBApJrF3K5y9r1Wa/yILXy6TmM5Ku97YStC1q0YHz96CfRofbUuUP3kkeeqsjSwNnRW2se/hoQ7kGq2Bn/mBhrda9Q8OnqLiXeQlUUlrCYsBqv+p6Fs5cW/pgsOTA0GZM9Kkq/VSVAOYlBs1p7GGSX5jQ+bM9aiwnVsok13FnwFwoYB5qE695tqxZUimQfaqL5qEdLtz1k6qdH0wIwjWzO3o2CghTui4E81pyxyXufLtN7eYBJr8kyRmAv4nsnO42ZC+mBcqQzyQ7DnIIzg4AQua51B+VwZ8jl3kCNvMaJyoJZdCz8wFXch5GWt1xBt+ag8XVdKf8/Eumr8nWmxYOfmDu3e0JXRjWVkzYNtsJ0RTlaAFC/FZTcsdHrWZlojOMPKggJpd0Azd2mAVBlJzmIxPFR3VxsP5RGrGcfkzG0DwBBjlMlqI4XKMFutpij0O0D5IcHumnCloABvMRzCY5fVmjBSdHPjTfydwNNsucnwwpjZXglTdf863dHvuP2S8Ddg0158HMBT4F5miLORXwh1uijHm+3ztWz4CgylNXEX1Wvbe6lm6PLTeb3ALvXPXj/KPVbmW+uOwlo+LAcvyWJNKWtH7nwNsYzt6wirCpkE5s1jy2yflxyOtOjhAv1i0mMtuRn/fKrOuCM8BnRdSnRVpWjxcvDxG9a+7VyikhXEfEfd1kK/ctv2Rlgop12eSwnNo6DCNlxY7R79G0R3h+SRHk6LDptJ20coR4cM7SxBhtWE/1xEE1jye6uuMdln52sACJ3UaVvAOZ+y4RhwKR4S5PUfBPXz4hV/mFNg44yVr6g/eRCgUh5pxuh+nvtT11FYtDLf9w5n9suCslAV2Fya93/aoaxb/RymHGDksq6WSTuQuwM8iLzhI
 ccaEWBaL
 9CBNySLFg0ZSColhHHN221oBb4CbO5SjWZpJ7a9TmYaA8qrTbKt4Ss7qTYYAe8IkGsFDF2l/oIU+hZavGhuEYirwJslRCY6XjFhRD9C8PsoQzqQRvbAdlC+gYkLvdWpjABa956O3mv3KYFrMbmnEzQykyGY0Fvv67HlWR6D/7UvvSBL1x+6x+uV3Q5/stuQ5dblvXHbp+SZjHQcrxmcy5++LrlFAUi6SGHi9n63nmZtd1PI7hnXQsKdwwdj9jFy1VKSycqvxKsWwYflAvKJz6pXbVa2o38p/rcWVlzusKYQbCNF2O00LzuFqB8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ZONE_DEVICE memmap initialization already uses a reusable struct page
template when initializing compound tail pages.  The template mostly
contains invariant state, but a few fields still depend on the target PFN
and must be refreshed before copying the template into each destination
struct page.

Factor that operation into memmap_init_page_from_template() so other
boot-time memmap initialization paths can reuse the same helper.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 34 ++++++++++++++++++++--------------
 mm/mm_init.h |  2 ++
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index d99af80ec752..905222772548 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -625,6 +625,22 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
 	vmemmap_optimization_verify_zone(page);
 }
 
+void __meminit memmap_init_page_from_template(struct page *page,
+		unsigned long pfn, unsigned long zone, struct page *template)
+{
+	/*
+	 * Refresh PFN-dependent fields in the template before the
+	 * non-temporal copy, so the destination page does not need cached
+	 * stores after memcpy_nontemporal().
+	 */
+	set_page_section_from_pfn(template, pfn);
+#ifdef WANT_PAGE_VIRTUAL
+	if (!is_highmem_idx(zone))
+		set_page_address(template, __va(pfn << PAGE_SHIFT));
+#endif
+	memcpy_nontemporal(page, template, sizeof(*page));
+}
+
 #ifdef CONFIG_NUMA
 /*
  * During memory init memblocks map pfns to nids. The search is expensive and
@@ -1073,17 +1089,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	}
 }
 
-static void zone_device_page_init_from_template(struct page *page,
-		unsigned long pfn, struct page *template)
-{
-	set_page_section_from_pfn(template, pfn);
-#ifdef WANT_PAGE_VIRTUAL
-	if (!is_highmem_idx(ZONE_DEVICE))
-		set_page_address(template, __va(pfn << PAGE_SHIFT));
-#endif
-	memcpy_nontemporal(page, template, sizeof(*page));
-}
-
 /*
  * With compound page geometry and when struct pages are stored in ram most
  * tail pages are reused. Consequently, the amount of unique struct pages to
@@ -1136,8 +1141,8 @@ static void __ref memmap_init_compound(struct page *head,
 
 	/* Initialize the remaining tail pages from template. */
 	for (pfn = head_pfn + 2; pfn < end_pfn; pfn++)
-		zone_device_page_init_from_template(pfn_to_page(pfn), pfn,
-						    &template);
+		memmap_init_page_from_template(pfn_to_page(pfn), pfn,
+					       ZONE_DEVICE, &template);
 	prep_compound_head(head, order);
 }
 
@@ -1192,7 +1197,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	for (; pfn < end_pfn; pfn += pfns_per_compound) {
 		page = pfn_to_page(pfn);
 
-		zone_device_page_init_from_template(page, pfn, &template);
+		memmap_init_page_from_template(page, pfn, ZONE_DEVICE,
+					       &template);
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
diff --git a/mm/mm_init.h b/mm/mm_init.h
index 0034e37dbabd..22c465122b47 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -111,5 +111,7 @@ void memblock_free_all(void);
 
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
+void __meminit memmap_init_page_from_template(struct page *page,
+		unsigned long pfn, unsigned long zone, struct page *template);
 
 #endif /* __MM_MM_INIT_H */
-- 
2.20.1

