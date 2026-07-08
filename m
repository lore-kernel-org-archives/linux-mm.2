Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A5FBC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:11:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AD3D6B00AE; Tue,  7 Jul 2026 23:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75EC96B00B0; Tue,  7 Jul 2026 23:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674E36B00B1; Tue,  7 Jul 2026 23:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 346776B00AE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B4BEC3724
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:38 +0000 (UTC)
X-FDA: 84964134276.07.57CB3C5
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id D4AA416000B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YVVuzaKV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3579NagoKCPYhrfmsefrmlemmejc.amkjglsv-kkitYai.mpe@flex--jthoughton.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3579NagoKCPYhrfmsefrmlemmejc.amkjglsv-kkitYai.mpe@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480296;
	b=tU5EaLQUFcsLAlkoKFfGcXVgy0iqhLvkUTRmXNvAFFk7XIHLbc/RSEEr93d83GW9jv5A+B
	6ktYS9Q/LIaC9FaIYeeFbnFlGv7XIGsNCoe7w3bTO84xC4WKJj0N+9Je7LOgmAfugSJDas
	fTlLQ9+AARw2B0vkTNkcB+hzDkkKtvY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YVVuzaKV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3579NagoKCPYhrfmsefrmlemmejc.amkjglsv-kkitYai.mpe@flex--jthoughton.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3579NagoKCPYhrfmsefrmlemmejc.amkjglsv-kkitYai.mpe@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yn77aa8uoI89j7RCjY/OwI/1RZwt436WtRsFNItz3AY=;
	b=zNDwrU2mbfBCUdmKhv66T0Xr2jSSj7gG4iPp6s2I0Gkj3LcL0HgOcPwr/CMtfWI+GeM3v9
	Pd2BbTIM4CY2i6/CCC150ApKqc0aAKOoEg5hL5SJYnvtUPtjqypbv7rOeGKyDStv4K7Iav
	bvOZp7sath21iKjdx782k6rN7PqwUM4=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-380fe2a3fc7so257364a91.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480296; x=1784085096; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yn77aa8uoI89j7RCjY/OwI/1RZwt436WtRsFNItz3AY=;
        b=YVVuzaKVUfoiAO5T8wpIv6p3XKQDGYl6EQB8sJulbnTbgsnNuIGc2ZDd+aYrHuyYs7
         32lG5LVSnFtk1Ee9T64DD0c1NYQtod/a/nQfQ0+gFtBxlbqM/ibuxt3vRfI7uSgOkEy4
         o/Y4jr3colf71lwHsK8fSQFu3yJjv4/XJ9pAaRhwSYm9EpB/5La7gD67MezvDJhzFbYC
         y/NrvL26SNcvmvpslF0QsCQoNPauMiBoE9h65uMmKLKkMwyO1PgUTvViUUKPCdp7mr1s
         WzCn55DNUuuiQbtNvcF7TaMNSvJoccBZeskjqE8K8jN0BiTmJJPuFilt7sIAMY/0TAsF
         zIHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480296; x=1784085096;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yn77aa8uoI89j7RCjY/OwI/1RZwt436WtRsFNItz3AY=;
        b=HPclkRWV237q41IAdeOU2KqGTF35eKWTRiq5WJU3TcEkQf9794lPVzsIJSuXPM0qj8
         t3R3PVzpuVqEduhrU3yQPF6XU2aSJga4jtBOAvXWVv+FQ3ioF/csC8g/BAVda1zYeTbt
         oxRBaHH5+GC9P3cTe91V8phBKQVVrJMaamaTXa0XfXLupKpeWiSSY7VGnuXgh3O3NHun
         Wyd/+vIo2qWpcZFMqNH12WUDDNxebPHAOowx2l6XrSWJm3gj5dUEboSHEA/wcsYFEkF+
         x6fmdint87aT8oYBEDW+yjcyfGAzH2y8twDPLv6WNFec7f1WpH1xAanytN1j0mGC61E7
         psLw==
X-Forwarded-Encrypted: i=1; AHgh+Rq1xn8PdnkWkeuxTCnKxVMZ0Ax3hEOIIVt6XBrfvvNsg9kwbmXO4zmGEEVGfkgPRtFbbPWG53KETQ==@kvack.org
X-Gm-Message-State: AOJu0YwzBI0q/lABCERBvrillKrbFdSSz2JHdIH50NKxShg/48yD7CZk
	Tq8yXBgePFVCXqlcR3VZhiiY9MvI+0griDHfoYk0xcgoLcCgKbmfZALR3smo9E2Ow2N0ovq1lLf
	ZdFaykLY9E2VX/mh5CnKMPg==
X-Received: from plkb6.prod.google.com ([2002:a17:903:fa6:b0:2ca:c401:c941])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5290:b0:381:6466:7160 with SMTP id 98e67ed59e1d1-38941acc1ddmr622962a91.26.1783480295545;
 Tue, 07 Jul 2026 20:11:35 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:12 +0000
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-3-jthoughton@google.com>
Subject: [PATCH 02/18] hugetlb_vmemmap: Move vmemmap_get_tail up
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D4AA416000B
X-Rspam-User: 
X-Stat-Signature: qi5ygy8epqmheh3p3a1dgw64ghrft9pw
X-Rspamd-Server: rspam03
X-HE-Tag: 1783480296-578125
X-HE-Meta: U2FsdGVkX19cZgMs1cS0NinXZzIUIlgmxrw7D8Q5zp6skfgeZd6HdyOn6+I0sGlBtrG7BPEmHcNUN69ogcYPj8N14Jj1zQtcKNf7SYvYln0zJ8wfz5wPTME3BMoAx2mqBjtwnuDpK06Z6SlDYCmT7yAVucJz5lAKPQICwMYRqXEjsJcD7n/iRVXIcv81YDwYBluwWWSTzI/L7NYNdgYh3peAJgLwH6boXH1ceM1QdiwAKPXyRGTWMmVgnpFdd0boIL1Otym6uCWJGqRVEyjqRjzVnTC93fA08ShqaVZ+4moWV0+IbMsg7SA+jKyZUwNa0rmT8ZcKPt8uu6bCIPkc2Bx0QyBXIbOb6DUXcAVAgcpg1VNWIB2ONzHULxLRIl91LxHS33JeGIxlkB1hz6y+Z9Wv5RBGOflpxbFH0aj9ZJlNews/ve/nMQlMNLbcx472Vy+OvmOTXox+ahwlVQWLj0Xqm9x/6IAXLXhFdNzRD6Ycbe3wmm2H3zeiRulT58pap0+bjs546+TXKedOrfKKU+Ye3Sy0SvVJcVLc3jXNT/Bsdmlnc4WXLrsW0jmY9hm8Dv79AwuzgtIaXKH8JcCAwfDzfIBka0B64V/riMYe0PeBB5rp6luST++gNscUEydJnquMhUSqbjRVkoLe51fYaJ9OQ8gg8VIUxqTTkNI/Lvpj2ABMer5f0mS1Wh0z/QIJoTZOlolZ6tZfcYLBLB1AOKLxhjRSJ8s434qnURqXjha9nwnslD1jI6yRZpN8qcHpHhu6cWu8N9jSHS9rHbmPix1dUc7UEuO5yVy3WbszLFkDTx4gWR+W3e7J8UHlP5DsRzH9uaA+emHH+VG15BKOzYAu14/+FWXk2glPxzITyOmmknrKE9W1EFOz/nz+28p9dyYmXWSlZmkKGqshXK0VSaqxmAva2GaLM+GORhxM5iaGT7Eo8fY/EgLh0P4RusGA+BVHlql4e9BcgxXYkqY
 AQlTvHhj
 BcmeiWGWZmjJ6n+xd9BmlDF+pMbV4+5l86hQjGt1hqsuzwSNHvlpVRO4dydI6ft/P5Aiulo9d8KO0+HGsDzKBDiPxrSCSDpjaMjYmW3m8J0WFlE9xgBor6GKJuIBEyoPV0Hr1mumDHXul0n4wpsD0Gqv6okg1bRbwfXfOLgOLHNbLcZCUEpe0EZeHpCq+WJBk2usGyswtbRfUQFjSpTeXKpWG74bSFHX35S+1xMGawbw4qswZKeOk8PXYR4C22cyo1hx7OAs68+1wKk4MA6u6vHhFxB3HisgECMVH2fcR3DL1CSluK2idmxhcDwChhcRhyQnmegTfw8zv08A24U6qQsD8wamlEWeEREujoYCjE6rghs0wvZ2vkwH+t+iFtF0f47mXUECY2Yql2Rc48ghUy4cYu7BTSI6J+vdNK+UBetP6DFX5A2nR6AUDvCyroplTnp5k0dA/O8QdRA794roUTLSJ0J3td7XY/TKCp4NXeiAm3PvkKoMUu8VEIXfESbFLBw02WtqjlHyCYBGRaH4M/tSDsavFHmtNfSKXbOj7aLEAyfRvHBJ32HXhEFHpu0/H+mb68SA0JTcO2A3/nQxTzLhpCeJ1sYfR6gwTt/GPHoMGdhXaSmHcGOuyeVhxt9XHv+/WagOI0qiwx2QtD4tfgxJu74dQrZBIiSuAIH9li/Pse1gX+AklNPZi9TdHsgeXxTBX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In a follow-up patch, it will be used in
vmemmap_remap_alloc().

No functional change intended.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 mm/hugetlb_vmemmap.c | 52 ++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index da29954e9533..8d4e8ee51fdd 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -355,6 +355,32 @@ static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
 	return -ENOMEM;
 }
 
+static struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
+{
+	const unsigned int idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	struct page *tail, *p;
+	int node = zone_to_nid(zone);
+
+	tail = READ_ONCE(zone->vmemmap_tails[idx]);
+	if (likely(tail))
+		return tail;
+
+	tail = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+	if (!tail)
+		return NULL;
+
+	p = page_to_virt(tail);
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		init_compound_tail(p + i, NULL, order, zone);
+
+	if (cmpxchg(&zone->vmemmap_tails[idx], NULL, tail)) {
+		__free_page(tail);
+		tail = READ_ONCE(zone->vmemmap_tails[idx]);
+	}
+
+	return tail;
+}
+
 /**
  * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
  *			 to the page which is from the @vmemmap_pages
@@ -491,32 +517,6 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
 	return true;
 }
 
-static struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
-{
-	const unsigned int idx = order - VMEMMAP_TAIL_MIN_ORDER;
-	struct page *tail, *p;
-	int node = zone_to_nid(zone);
-
-	tail = READ_ONCE(zone->vmemmap_tails[idx]);
-	if (likely(tail))
-		return tail;
-
-	tail = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
-	if (!tail)
-		return NULL;
-
-	p = page_to_virt(tail);
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
-		init_compound_tail(p + i, NULL, order, zone);
-
-	if (cmpxchg(&zone->vmemmap_tails[idx], NULL, tail)) {
-		__free_page(tail);
-		tail = READ_ONCE(zone->vmemmap_tails[idx]);
-	}
-
-	return tail;
-}
-
 static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    struct folio *folio,
 					    struct list_head *vmemmap_pages,
-- 
2.55.0.795.g602f6c329a-goog


