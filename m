Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A23B360A2620
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=HE1t8D7o
Received: by kanga.kvack.org (Postfix)
	id BA09F6B035C; Tue, 20 Oct 2026 07:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79546B04A2; Tue, 20 Oct 2026 07:58:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A40AD6B04A3; Tue, 20 Oct 2026 07:58:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF9286B035C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:58:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 661801C0F68
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:58:48 +0000 (UTC)
X-FDA: 85342857936.15.ACBB0A0
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id 01D6D40007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:58:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HE1t8D7o;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792497526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Wt7D3no7nuCFnhCnq0cbe/ydNVwY6qp6AQIlxupHhY=;
	b=O+Zpi5sCSxjOHZvnrjxFwmz1i9pM22U5rmeJOQkd0mw8Sq/qAZ0pS96BDTClxGqm/PyWQc
	JEufIiWM0khL+MRwa97hmli7QC5xq45yY5GeAxO+vca7nhydhVloOC1yHkBH186LaH7Msv
	jazWQwUh8ehvHrSH4+DCG8FK8V30k+w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HE1t8D7o;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792497526;
	b=Z4I34asoOKBFcseeLG3pakpdApMOagy4SubxPRUFgwJdjyeSn2xxT1zW4cIw+03DIAQqQs
	1AuBkuL35Pyi+/EO/o8pQCokeMtr+aFB+UCWMBj9FY2A4jSM7T60CzQx8LYeiYOmZOzgOF
	0IlqVPbG34QmF2szkwKWajzw5SfT0bw=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cc4c02ddd62so1514077a12.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792497525; x=1793102325; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5Wt7D3no7nuCFnhCnq0cbe/ydNVwY6qp6AQIlxupHhY=;
        b=HE1t8D7oJqaGE8pHCLZjF8sigqoZAhFnjdu1MH7jGEe8LcyV6PEqbtNpSenN7mhfCL
         jnRWhhqIfKlGuS+j3gnKC81usK9+2VElLNSuX3toDw39rxZ78tOmh9M4zSChi5F1iQrr
         eNff6OvFs5sRwqxfZtQlLzUa5Q0T7TqxTD5In9fXmjGMPy55eD41dE1uI+e9sENP2v+7
         cCWDaIKhKEn48qKAZ9Gqdic1n4jt1Z5LVKvwkXtg+X5CQPZng/zHRV6WwxNFRkFcyrKG
         k8qFF94ACcNSz9xMAPgoh+UIfE/Ey8/YzqsSXITZqKYfIQ3HsXhkguGSbRfByqZPDjF2
         OEvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792497525; x=1793102325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5Wt7D3no7nuCFnhCnq0cbe/ydNVwY6qp6AQIlxupHhY=;
        b=Nej/T2Xp5F22nOtlT6jfzCssHSDk4lafaiO+Yjr1sGmWcESiqKgutKBpaZUwU4py2L
         IdIV+gBPoI1tt4S8E39JcRblgzSZfOX8Yywbe5L1516jlWOxE8YS6HSY037ObZsvcCLC
         Uou8aMyiX5JCHLNdGFK7RaYQrWMcLfFfy1U474BkZu3diyXxt1D3T5MLjsrJo1yvnvWl
         hOLt9BNv80xp6dBzltEaoyiKoaQoQLTNuvo71NVt1zghqy6QZQL5o3GVaSCkDmKBRZxQ
         Ug7aE1xlR+SCYXCg5YLn+KmzUJZisck5EoHzd3bLhw3CVawBGjBgzgpZjnSUkEVmPRKj
         GE7g==
X-Forwarded-Encrypted: i=1; AKwUvBx3nkZ0CNNaAXU19wMtPLzuLLpyjZqn0ilPtXe9nEySMVRYXZpc6nEkq4x31kXZdcAQrR0ML7ZHBg==@kvack.org
X-Gm-Message-State: AFq9FYJHPsxzQ1WDKlNrSI4sTWj4Rv6GSnl+PXh6Eh3+jpK+99UalKwL
	bH9ETRHuc8XY8uTU/K9+EYk96aVirI8rvYGTpjqaXZCAobYqzy429tDp9Enpl+1CZ1M=
X-Gm-Gg: AYBFou3LakjxPrAgykVOv8UrPpsbrB8Vn6W6FFiMqNtlYKpwHE74EIfzhAtePpwkznL
	XDVuyZdUcWN2qVH+D3B9zK+5yFideezAV5kTTtrctjYV4BkFw2A8mCqvo5v14crGgsZtMqfE82V
	mmngjClWdZHH0l9XyTrZIl3u/wonCQg/qdzYQm95k8l74tqJYQ6t/mK/jSw9wcBmKehDA86rcVn
	pya9uH3yZQ8LqpUCEj2treop27iZWOkSJ7x68Ho5m3aRHXRfGsV7iNWm8Wb+DIsTx75KpQD+J11
	ikaPMsjM/PWjKW7n7m7n2ZJDu2K2PSkVwe9giKdbTPOSWnqCa/3LdFI3TWAKvXrhSnsCMUhcQn6
	jKCH+vRNjSkcL6nHykuqMpgTOidBL2xQpX7ZJACO7BUwFxZcPLwjTnNeXZJzBfwp+m90Q+6nvA6
	7Fjvd38FCxhA52EWvZqCXkuNnqzKbI+qO9VwzrmoqstJrzThXXTU7OuKFHVFy5zIoauduig4G7J
	cRR3RXKVgcTpNnHqkhpDzNWk6kaVac=
X-Received: by 2002:a17:90a:d44d:b0:3a4:6f38:f2a2 with SMTP id 98e67ed59e1d1-3acef19cb63mr8571724a91.25.1792497524625;
        Tue, 20 Oct 2026 04:58:44 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad60274fc1sm3448095a91.0.2026.10.20.04.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 04:58:44 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 05/12] mm: hugetlb_vmemmap: unify writable vmemmap page preparation
Date: Tue, 20 Oct 2026 19:58:17 +0800
Message-ID: <20261020115824.823278-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261020115824.823278-1-songmuchun@bytedance.com>
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 01D6D40007
X-Stat-Signature: 5qia1i7wiho1fruw3ti6a3j136dcjgsu
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792497525-392058
X-HE-Meta: U2FsdGVkX19xcaXoZylIfPFZzGqSLwYMFVQGpBrQHJh8dLXnaipir+q1X/y7O1PwcxeqD8nqPSZF1G1soej8guL+hepwZ6iLNIGZeLgVbYuH8hocb1wpUgQqKOkxQGoQv6PAn8gv9NmiA2zWjwMjKmOqv8r3R0ADu6WHxzuSRX7ceylwAqejTJ11JFjHNv5quOkKIM95kaVaS5b79qnwb9mGU1TY3tXG9uFFuWJKcgmN8aKCGNPPh6SmAozGujJR6Hgy0I7pWQ/do24g6j408ezqR0QT2prtsjFnWFxfrM2NnVn7RQNdjKhL5xnq0bSJmGGFTnF4RTCRd+bJlehU/UK5zRL3+7dFVHoo0vnq7Mw4HGtaO9ATTJ0ZGzNni2NMPf2urgxcAQE/6pVgNHeqf9duzZZhvY6qPpo1bjYs91Y94H/iV9hD0iDyrKebOYcQI09Vm1upBlpW8H18xpIQK3P9kdkRaGykMioOTvdNUq57UGw2dHQfSArPSUbXPVPYdzZoBeJSsN5PFYTjFCz4fpHyv/8mhUr9/tengbvymbO+umCOHqCbAJQqAt5R8KYFIEE4MQwn9r1chGcXQXhkiIlZdbLRY3RQ3Uk/TdN5WQWnUJgJP9zQXNMcqqQxmDV3tchBTC8rKrOO14omrw1pbcA6sysgSt38qUMc8azoKtrqO/Ztc8OLDBOSV+vDNGBZF8+KsGD/bt6GNlSFL7kG6D8NrsZkQKTJ9ty/6pBqWV6C6PPIQ1jXVjHvhpXGGoWrmmA+gGEdMad4zxkPxPfrHWztxwhkQcV1qWdaHKO8KRTuUIewFrSWpSnwamKayo8fespC3F6hpJ3uMEvGEHmkexKQturTM+U/Z/gdToDN/KvOT+1+5CkvjNZno1M11Q6wn+By8kvwzgS5710k7Cp6tdo7ZyFHFUBgAwAApAy24kvbwM1mbY7nSN3popQbO215oJPKvHf/sdQndxLhQt3
 2DgJgogE
 iSwFKKFRON0F+Tz7PKa4qW/Nb4kcFhnvXV/WeldPjcSLhWIjTG0Ph/01NDIRKHww/x7Kbekw5xHBeCqr/L7RqHkG807bV42yPdIdWov7okRvf6IJu/haSpOIKcccqASfGubvzb04V2uqz96gf1Y1SBq0qtw5xv0z6cHrzKNfxgvUxL2yodTJBzk80khtvjKr0kpJUl1A7Qt8nc1Y+uhglpgK5T2KamCduzmNwB8ZHOKo5daw4tXDkfKuEm8c05+9+mADuyiBthq5YpiZA/WkfKwtQkpWvLvoL0xLdJAsfJ5tgnazNRq7gP+Ai4TXo9nIsy46qGDP7HC8nPsPuKKaHR959u09Cia9KDpsKTJ37Sc+IerA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Installing a writable vmemmap page requires consuming a replacement page,
copying the current contents into it and making the copy visible before
publishing the new mapping.  HVO currently splits this sequence between
the page-table walker and its caller depending on the remap path.

Centralize the sequence in the walker so all writable replacements follow
the same copy-and-publish protocol.  This keeps page preparation with the
mapping update and removes path-specific handling from higher-level HVO
code.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index ffb56ffed680..9ea961291b3a 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -199,6 +199,20 @@ static void free_vmemmap_page_list(struct list_head *list)
 		free_vmemmap_page(page);
 }
 
+static struct page *vmemmap_dup_page_from_list(const struct page *src,
+					       struct list_head *vmemmap_pages)
+{
+	struct page *dst = list_first_entry(vmemmap_pages, struct page, lru);
+
+	list_del(&dst->lru);
+	copy_page(page_to_virt(dst), page_to_virt(src));
+
+	/* Ensure updates to @dst page are visible before set_pte_at(). */
+	smp_wmb();
+
+	return dst;
+}
+
 static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 			      struct vmemmap_remap_walk *walk)
 {
@@ -211,16 +225,7 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 
 		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
 
-		head = list_first_entry(walk->vmemmap_pages, struct page, lru);
-		list_del(&head->lru);
-
-		/*
-		 * Makes sure that preceding stores to the page contents from
-		 * vmemmap_remap_free() become visible before the set_pte_at()
-		 * write.
-		 */
-		smp_wmb();
-
+		head = vmemmap_dup_page_from_list(page, walk->vmemmap_pages);
 		entry = mk_pte(head, PAGE_KERNEL);
 	} else {
 		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
@@ -251,15 +256,7 @@ static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 
 	VM_WARN_ON_ONCE(PageHead((const struct page *)addr));
 
-	dst = list_first_entry(walk->vmemmap_pages, struct page, lru);
-	list_del(&dst->lru);
-	copy_page(page_to_virt(dst), page_to_virt(src));
-
-	/*
-	 * Makes sure that preceding stores to the page contents become visible
-	 * before the set_pte_at() write.
-	 */
-	smp_wmb();
+	dst = vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
 	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
 }
 
@@ -497,7 +494,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    unsigned long flags)
 {
 	unsigned long vmemmap_start, vmemmap_end;
-	struct page *vmemmap_head, *vmemmap_tail;
+	struct page *vmemmap_tail;
 	int nid, ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
@@ -529,9 +526,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 		goto out;
 	}
 
-	vmemmap_head = list_first_entry(vmemmap_pages, struct page, lru);
-	copy_page(page_to_virt(vmemmap_head), folio);
-
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
-- 
2.54.0


