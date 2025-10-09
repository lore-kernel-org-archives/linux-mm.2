Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA976CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 17:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BE388E009E; Thu,  9 Oct 2025 13:25:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36AF08E002C; Thu,  9 Oct 2025 13:25:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25A078E009E; Thu,  9 Oct 2025 13:25:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 13A6A8E002C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 13:25:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BCCAC11B251
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:25:02 +0000 (UTC)
X-FDA: 83979251244.16.E27ECDA
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 022FC4000A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:25:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hxTx2buj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760030701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GDbuLJWcV0DP64SCpKYdu9KRYGqMQUurSvhwqHHtxbw=;
	b=oJ2aXeFTH29jOa7pCovTiUwVCI3xxrrNX5RM3wEL+MeB0y15ZUSyHYUYEXGBu79s3TsQVw
	BATpQpekK1elOOpyS4hstMNDi/ksKe+/IaUpQ6mG6h0f8nX5ONuJ7r4OnBjlwfZGqdXkqe
	60JYCH+L83UNpB+6vhzWLLlj09y+s2I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hxTx2buj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760030701; a=rsa-sha256;
	cv=none;
	b=cv9MyEKCjcq5nYgmtdUX5lac+eYk54wDRFDuScODfNsWAe0m0gNLHWIq9pu7qMIfs+otND
	gt5rHb171rzHI2myrx1nQf9sHuBSDsJDnEFx/DwnSICJzhtZQddFGmEG+dl4Z+0c+Uf7VI
	LRPis4VHlxVS1jf11z0Z4sCjTmlFPsk=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-723ad237d1eso11689667b3.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 10:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760030700; x=1760635500; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GDbuLJWcV0DP64SCpKYdu9KRYGqMQUurSvhwqHHtxbw=;
        b=hxTx2bujZP4al7m/iubS0/6QtmbTDuRAJlsy8Stw4VhWBYOCW3A/X/sAK4IBJ8n2Mf
         WdT/+o7+fNTskzMMg/3BjtLt/96eqNAU484lhSKzlwGS9EmtFNpQSdkeFzeR9JzG6UZk
         HQtOWte3Qbh7yDbXF5GcsQzAu6Ltu+ov0yT0BX1J9FlMkO7aKFGiaAclMjhElIkG8Fc1
         o4kpiGVXvj+m5gOo2qE/3ui7e0vpWick7bg0znyKzYmeyyFrfeTfn7G1g6TW9VSekVbF
         1wpUVE+Wad/zBJZrtWSdc6XZHd1GP01R6pXUfULrraXnwm7uuBdF3plngWHRWc7aJdHI
         9IlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760030700; x=1760635500;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GDbuLJWcV0DP64SCpKYdu9KRYGqMQUurSvhwqHHtxbw=;
        b=xHJD8V470h/md0XH7NGOV9Vc/5C+WFQCk0nE0HgI+HxO4UQxl5ehKj2g9vAiWuUW3s
         k+LrZxm84VE5+Pobpz3OB0ZkUYxoo3PDoXev0O5ID///pGlkP+vO1qr53EtgM7M/Yd/l
         TYCV4rQyRnmATQiI6iwnwDC5OAdFGEhGWrjim5kpLWIlaYy7cq7w/OvE8S08rOlAP8rg
         on1aDD6LnZUhu7SshS83Yy0D7Hhr0s94u0mewPPoTQDK/v/4BvocBlzZdqzpKdXfxGgw
         /6tg6feK4n8RXQs8f14M2oiXglX/DCl4LXS1fod9e3IVy5MeMK5O2VcCicoy/2h/c35X
         m2Kg==
X-Forwarded-Encrypted: i=1; AJvYcCVSldSk7Zs+H8caWL1YToknTg+rYY0W/QWN7YCk5T0cWj6yXaJNP9kZCzGelWBQzN83g80mkt+Giw==@kvack.org
X-Gm-Message-State: AOJu0YxS+mO94RmrVIePWBXwP9R13ORi5prRvFCHaNvcjPejXhSWKR4B
	VicxI+YuHMC+6P8iLDtcsS2iX8ikYtUSpIvWFm6qvduxbkpocOf3J3V3
X-Gm-Gg: ASbGncsIC3n2XlVlMdrxVDAKNUB3AK7hLGR8fA+nGCFA92RpEIHqt6GXb9dPEF5i4b+
	TW2//Xe7TviSrDLF+040iuk3VFu/jtZ7XtOSIS1jOe+tPhSlTnYoBbGXUXdTOhCnVm/fflIpu2P
	P3OfvsQ8VmH2i/miF+kJDJleJYpt20bqWtO9iUYvoRoiHYmenJnjBdSbVDz9DR/wq/KxEuDnfqY
	8PKHgQ3n56LHIh8ogVQJ+ejzyJFFjh7tQ9oCZlAOKI5052UnuBRT+cOFZSiB5H0hmPLJTuuPY42
	hwf3wDi2oIbnmInXfiPqavitepdu4/luHMqtvUH5TOThCYO2KHkFq7hTVweu7fn+a+tBPlQDp7b
	c9TefwqiM049EsiQ6XmCqLMyaJi7KuWpoxn9eAGMRZsl3T0Wu24Bga0eNq77Ed1tVCFk=
X-Google-Smtp-Source: AGHT+IE0HeRkcSWt/qNt+REpafTXmTS86WuRWboi7HnZzYqvTb7JpaI32/8qMbasmYlxV/NiCrYEFA==
X-Received: by 2002:a53:dd01:0:b0:63b:9ebe:faec with SMTP id 956f58d0204a3-63ccb90ae68mr5781162d50.26.1760030699978;
        Thu, 09 Oct 2025 10:24:59 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:72::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7810724444bsm181727b3.43.2025.10.09.10.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 10:24:59 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	Andrew Morton <akpm@linux-foundation.org>
Cc: shakeel.butt@linux.dev,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	kas@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v2 1/2] mm/hugetlb: create hstate_is_gigantic_no_runtime helper
Date: Thu,  9 Oct 2025 18:24:30 +0100
Message-ID: <20251009172433.4158118-1-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 022FC4000A
X-Rspamd-Server: rspam03
X-Stat-Signature: zjxe63uhgde94poex13sgoz316cjd6gr
X-HE-Tag: 1760030700-294399
X-HE-Meta: U2FsdGVkX18+6ENbLS7Y33qNr2WxJUIPb9TbLcZyEfjiextqsMHjYlEHTYO1+TXITEFM2hCGJ8nunT61yeUQIgYDhdtSiNgbNhrK/zV/fvl1HEOhtOggPX0VXfvFBO3B4ee/VbXbephWAgbbdyvm5vg4+e4ocaRdxTQ63FwMdgBhk/XGz3RurnTclGV0t+u1guZFy8qBkk95H7vLUSpBmQ4OKZaliMh47btnbLGHwRmtiZOLE4Mo58oWLZXHMb75ERd62hQ+v1C2Eo15UnNVIFglvcbWieeQyZBmEUe0S8GgVPjv048nNc2ImCo2fYo+4iu2TvZALDyGowm9QDaKt0dek4QrtLpmhZFnYjLUYeVhsDLCHrVKjOCUslrFHhN1bRG29fYRFxaPTkLlLoNkk7Mrg7MbRSttVTqymqaK/BRDJOYGUt71Aedty71lahUFczr9QwhQca7H2pbVBXPtphFDX64jZe2u2Tqxx0i04ZR5L9c4ml8m6SUnwAcBln2TdRJWJuO9nuhAO0P8ms3Mtuu4CLvH3Y6CnI/AwWUqNwCxOs3dCgBCZZ3SqBD4yAcHNOgaLk0awIjtWaHO8XwE+8SijOghNMqPUDmkHneDqvst6Wdn2y2pFsifwuAX3uI3+Haeg7dC8sMd3ayXqQZQxZBslwtATc5Mh9kYiQxv354xGydwiL3QoS2ReuJ2QXLwzjLBGz7JU07sr2TzeBRruL1cHTjL6d8zsiXAwEa4cKll2u8GsTBVY+R+4UcVF7xzl7jSzjbcotNBDA6JHxMBDw4Bd+0B1McfdpEzi5nvTaxkI43mhWweGpyseRVivtNQADK1GZad+LMxyL5WDccgiQ4kw5ZqNft9biViEQvMJOSGtV/iiZtfMexmHFTMac/tuSHEesSpLtXl5yQL0tPhIPDHFUp0+PyIP/ekQazSdI+MdWB2Gssmntg+3tcUicDSLYp2qIoOAZ/yuFd4U3/
 pgmCvw3+
 FfA7gwmrfomYsUo3BRCHKXvjx/3lBkT5naOcGKavucBLDBGIjwVfQYZ9PH0luxlLVJMxcVSU9x+Phr8A7bXh77w+JLEIe8mtsa/1COibQigwSEUt5/DUcpP2fnSjXO6HzIsHdNgmiK5fxSet1zd5RnQSKVA8aXRZ3dCBjyJ5t5kXKy09UpSOoa8d9HobxzLsh8sKcVBdOE5dhKE1Df4n0g0vNVXiEQSAP1Bgs2jgFV0QfgWeTc9PHCRMD4sDHoce+itz08Sq2cbvIjz/bkcrsLXlRfCQNG2ZzlO1p0CoDIJ8MfvhUbTxbt4JfHcCfPbCYwxGLkycv+cGcwXwIspzNY5bY2btm/YChS8OotUsgDBrE0XKHhy4z8Srh/jDQEutU/PmXl9W040l6U4WnLMQZ90BfbVfYMpygdpf+o25ZyR13k5iOdfHIDtXcR8kQhfPcwvi6SlcOlebR9L24pOpyenHd0Wosl9ryFMh17fI9zHsPfHPz6A+Im43WMU2C1VWYuLFrusNQjLZb8/G/SP5EYUPwv8I8qugNP4G8CrtQ82bVWJleRiLY+xRMcOFmuXq4S8TnI4PSo5HxjoCX/amxYpl80O3fqB72uDG3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a common condition used to skip operations that cannot
be performed on gigantic pages when runtime support is disabled.
This helper is introduced as the condition will exist even more
when allowing "overcommit" of gigantic hugepages.
No functional change intended with this patch.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 mm/hugetlb.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c07b7192aff26..e74e41386b100 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -134,6 +134,17 @@ static void hugetlb_free_folio(struct folio *folio)
 	folio_put(folio);
 }
 
+/*
+ * Check if the hstate represents gigantic pages but gigantic page
+ * runtime support is not available. This is a common condition used to
+ * skip operations that cannot be performed on gigantic pages when runtime
+ * support is disabled.
+ */
+static inline bool hstate_is_gigantic_no_runtime(struct hstate *h)
+{
+	return hstate_is_gigantic(h) && !gigantic_page_runtime_supported();
+}
+
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
 	if (spool->count)
@@ -1555,7 +1566,7 @@ static void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
 	VM_BUG_ON_FOLIO(hugetlb_cgroup_from_folio_rsvd(folio), folio);
 
 	lockdep_assert_held(&hugetlb_lock);
-	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+	if (hstate_is_gigantic_no_runtime(h))
 		return;
 
 	list_del(&folio->lru);
@@ -1617,7 +1628,7 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
 {
 	bool clear_flag = folio_test_hugetlb_vmemmap_optimized(folio);
 
-	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+	if (hstate_is_gigantic_no_runtime(h))
 		return;
 
 	/*
@@ -2511,7 +2522,7 @@ static void return_unused_surplus_pages(struct hstate *h,
 	/* Uncommit the reservation */
 	h->resv_huge_pages -= unused_resv_pages;
 
-	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+	if (hstate_is_gigantic_no_runtime(h))
 		goto out;
 
 	/*
@@ -3725,7 +3736,7 @@ static void __init hugetlb_init_hstates(void)
 		 * - If CMA allocation is possible, we can not demote
 		 *   HUGETLB_PAGE_ORDER or smaller size pages.
 		 */
-		if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+		if (hstate_is_gigantic_no_runtime(h))
 			continue;
 		if (hugetlb_cma_total_size() && h->order <= HUGETLB_PAGE_ORDER)
 			continue;
@@ -4202,7 +4213,7 @@ static ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
 	int err;
 	nodemask_t nodes_allowed, *n_mask;
 
-	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+	if (hstate_is_gigantic_no_runtime(h))
 		return -EINVAL;
 
 	if (nid == NUMA_NO_NODE) {
-- 
2.47.3


