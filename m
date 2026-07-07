Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55719C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 426776B00C7; Tue,  7 Jul 2026 09:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6F36B00C9; Tue,  7 Jul 2026 09:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29EF06B00CA; Tue,  7 Jul 2026 09:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDE2C6B00C7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:53:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 788824041F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:53:33 +0000 (UTC)
X-FDA: 84962123106.23.4417631
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id E464F4000C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:53:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bOEfrOOd;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432412;
	b=w5ObouU4WHeJ7EnQUF8NV87yrj6VALIwv88aPqAB32B5SF5WZ5H9er9ztT8dCvBOkrpG1n
	Zh236TvuGoem9zlrKKK7gQ11RSKU7VwEuzFjIkE9/rzq0pA+JHAqgP/B47DI+BmdAZiwTY
	pj5TemnJ696laBzHvTjfphr7EaDYCvY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bOEfrOOd;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=quqW7QPkkOmuZBsVPZ6/a3v09/W0iGtXtzNekQUkyPQ=;
	b=IN36mrv3UiJ18mZiBNTJ9lSGv+86HT5NkN/yltNBlwekvxzbOrIpoaJSvAAn5xIKAgc7H0
	UZpuBtpcCrOP/pg5o1pqS5rWYyeEFJgRV2aXpawJsrH/Ua2XOyZWCJepFen1hH04w/ZlC+
	ruQTAR/9+N2FF9q/13UXyo9JUsHRaBs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783432410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=quqW7QPkkOmuZBsVPZ6/a3v09/W0iGtXtzNekQUkyPQ=;
	b=bOEfrOOdGuOrim4uKpsIvxxBxZIz2xNb0Lp6GVAkmYdPwWkfmxFv6q82lsGngNwTn0Uhtp
	0PC09+w0Q0nUSEvYgcdT5eDKB6MtOIP+K18zkmp6Oz768mkISYkUXPW/EEug62fjQXhSqm
	oitahOP5nju9IzBuRypc8sqyu+1TQZg=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	npache@redhat.com,
	rakie.kim@sk.com,
	ryan.roberts@arm.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org
Subject: [PATCH 3/3] mm/huge_memory: skip device-private PMDs in madvise_free_huge_pmd
Date: Tue,  7 Jul 2026 06:45:09 -0700
Message-ID: <20260707135255.292870-4-usama.arif@linux.dev>
In-Reply-To: <20260707135255.292870-1-usama.arif@linux.dev>
References: <20260707135255.292870-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E464F4000C
X-Stat-Signature: 3gtyach748c1bk3xm6wyb7m46eusomo9
X-HE-Tag: 1783432411-331580
X-HE-Meta: U2FsdGVkX19GF6e6grDtpI4TaY2/903heq10gyXD1d7X288bW/roiIXBYWDga4bSZVcIAvi6nj+wafL7vzsoLlCyerzcsE8mHINgUtMcg7FPoDHGkcbr9AvJ5svoh5lt21cDJSXDqLJt5HMZ67W9y4mMsU/80QZqUsxyhilxgO2MPiRlwh65yxvWmEJbScweoZerQICjFa+Ih2mZa9QcLYDx0NSbk+pw6y5Fcrbvj5dRAsZ7efUeKb/xo1rMxwxWSaNH4Xdr3LDoXbv100LXar3P3JiGgwRt1f2+4JeZuuLrAT2oJEWugw3RoVR2+fVv69yTzirWtX88NsTWPv1EktBDy0jI4p4aiFb0gorSGYLH0JNt7F4G1X0nZJzxT9rN0fKWQC+a3AzdY4tREuzfY4KzdCfRYXVOHaXLnOJrjLKue0kV2kzDl8wnRWSMcU+YAvJl6yC2o8KVN2/eVrW1jf6KmiHvB+KaeLIR4dzjMW2tOJ4Avk1PPxt0blivnHnkv70CwuA1FCNarm4pYtyQIUwlqI42bAyBdrx7I2zBnrTHzqjBXY5AJ8Nrq6YJ9+SuHtOuaSg0y+UCoQk8DNKARDdN3xj7sa2pWoSeI2+2ZkcBoV4A/L7N1kYQ0gQJtoGjwjqWbgRwm40ddmqIm74xzU7VF4WrvnbDUzckFsiZOW77mb0Layhm/6GKH65fFc5iAXQZV/UCLhKZlko29Ljm3z1XmJzaECN8z7OBF6BnkQaWKvdNTeJPDpyS3IVI3ere3X4dPD6681Bh3VUhYsxhaNVqptD279ropwiPRmgx6rQsXjXrmB2L+0Kf8XtS6HxIoZwthETWeM6cajrE6aJKUPG16AI71fixa5OZZWPQCt6O2cZ5h0h+sjvI30nKwmzB+6sW0bFkZ5GkS4CiPJ6BLveq0lpnsQT/rUBsPgNlqHYSsFbUspQ7mWi9gXZT1/Gf72NmUGobCdUpt5MeafL
 DDQWgB2P
 7WiXlZJX+jkXPB8ta/Vr8PZwRZkkdizi5eQTnQXFiXGqD+vW70Ie4mfV4yqMKEW8/Kw5dilIOYMQvVSiPE7d4rPECrRIPHWphCiDYwODCdBQK1rG+pwI8GCVVTisiYfiyhHIFmV+o1xhLQAiahl0I7+31icS7sVCqIZdiv91nv878lLjse27mkM9JTwTnVPI5PX9MvqN/NgSg4ZQrw+EPchArQFraoyzhioqvFNsrMWJ5NpcdyftSnAx4ftDjspFuyPWPVJ24fJSO5AWkmkqMbIhS62kg6vuh1PkO4XhivmGG/yWZNzarkTmw+K8srFSfdRy6jaw19A51FUKqVikJfR6Ufa6GGojUgyViW5WvZLTC4HIiiqYIa4AQXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_free_pte_range() checks pmd_trans_huge(*pmd) unlocked, then
madvise_free_huge_pmd() takes pmd_trans_huge_lock().
pmd_is_huge() returns true for a device-private PMD, so orig_pmd can
be device-private and hit the VM_BUG_ON() on the !pmd_present() branch.

Potential trigger: an HMM-based GPU driver races with madvise(MADV_FREE):
migrate_vma_pages() flips the PMD to a device-private entry between the
caller's pmd_trans_huge() check and the callee's pmd_trans_huge_lock().

Skip device-private PMDs after taking the lock, before the
!pmd_present() check.

Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c0892cc533a9..cfce9f31b30e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2296,6 +2296,9 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (is_huge_zero_pmd(orig_pmd))
 		goto out;
 
+	if (pmd_is_device_private_entry(orig_pmd))
+		goto out;
+
 	if (unlikely(!pmd_present(orig_pmd))) {
 		VM_BUG_ON(thp_migration_supported() &&
 				  !pmd_is_migration_entry(orig_pmd));
-- 
2.53.0-Meta


