Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7043EC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 14:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E98DD8E008D; Thu, 24 Jul 2025 10:50:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E20E08E007C; Thu, 24 Jul 2025 10:50:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74ED8E008D; Thu, 24 Jul 2025 10:50:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B129F8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:50:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6097A58EC9
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:50:28 +0000 (UTC)
X-FDA: 83699444136.07.2946942
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8ED7EC000B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:50:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=fGW1OltX;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf28.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753368626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOp/GZbIELNxUFAy4Lvk7xSAmNGCaCvGZ6cxvtiBNgE=;
	b=zgy1ELpWhGTPDAui+8jk+VxYWczwY7/4XV/blzsG/CQ1qUZyEiokXpoRfAkWP67FdhI/Ri
	g29lB0k7ttvVYtwnK2HgsqXvzX2EK3SEzfggSFREBHWtBWTENhXuJ5YNHLiuNdOOc1gQZU
	bjYAYnSlcYGjS7cy7WfLPJOOVIhK2Ho=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753368626; a=rsa-sha256;
	cv=none;
	b=62ThJ5g2Az9CMRxTowqfslgyEMTb7Yy2WtRyoH2O+Ba4oiCJzUtk+22VG6sYYTLwOgD6tN
	IHjpwVTYTqu/HZvuEs/6H8UoiOhvj0VoIy1w28/3cseTaDTDPMo15KZqJ4Pier6qQWhUG7
	81znukl9tXoTaUp6fovYf7SUqtFDKAM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=fGW1OltX;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf28.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4bnv7L5sBNz9tV9;
	Thu, 24 Jul 2025 16:50:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1753368622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FOp/GZbIELNxUFAy4Lvk7xSAmNGCaCvGZ6cxvtiBNgE=;
	b=fGW1OltXhLG1qiHyJSscjoHS8RAejuySa0WcLuJd2nbCWCzpDlr2zcCXbGwexZt9B5CUCI
	FgFH5JmvrYdCQZ0E3o2yfc02Ndr6hONgtkOBoKajck9dEl/yL9eewMOY7V5GWVOfneM9SM
	oapFzHxro2NG2ZomEFCXnc4Z89zLdTy51XADLaAknjCA4FDQuRmgYCn9hPv3f//+yT7UtC
	E6yhUE1mP8yKAkoT+GKp062MZXLTuHDMiA8dDKvLe2DSxSu790SXQm04rnrUbIi2yphu1i
	KmD6XqflycMsCjHi4mAPKdwuVa5SPuYW/0xXxf2wwIL3dic33soKYhgNCvmkXQ==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Michal Hocko <mhocko@suse.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	willy@infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [RFC v2 1/4] mm: rename huge_zero_page_shrinker to huge_zero_folio_shrinker
Date: Thu, 24 Jul 2025 16:49:58 +0200
Message-ID: <20250724145001.487878-2-kernel@pankajraghav.com>
In-Reply-To: <20250724145001.487878-1-kernel@pankajraghav.com>
References: <20250724145001.487878-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8ED7EC000B
X-Stat-Signature: cj16dtd6gr65uucqzzc4otibkxgqrzhy
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753368626-146130
X-HE-Meta: U2FsdGVkX1+1dild3JmsdrD5xROUYURyNFK/uMHWBvwct8s6nU7VCM7N7wivzKMSzzhmZYKh/ZEqwrxVVPvhomzXa75Dk6kEZK94nMvE0k/9oH/x9DAhMWUtinvyDZHMFvLhuEpLmjk7ahUMJVahek2voNzhqfJCleZQRW7/JUEEoa0+Tkd/0GmiE/DFbp+iAq6sddymT2GcExqjuTmYPtiWf5Cxd4AihnnuZbbM4hfKuGsJkb8zldceubdhG8BBT4ulz1Adi66FbTQ/8jNfQhAm+FifeQ2rcRbiczm1pjv2LBlDoPmHfdjaeqMI6GvLhzBy5c8TJKsp6GzOgjZXj/y80gXk4zd9CnxsAPVJglKh5kn3uBkGgXBP6Exgq7lv/hlqDWJFDDZkGO2HJPOTOSDGZl9+6RZ3q0k/1IQF1sS6VzHKzHJ/mo2CLz6PN/eQscKhzCiFUtmIipj3kyspRD9Pl4gaJFRrhRvd2P/LeNeNMiGzPEdFxSZl1xNOQMmz64hDKy0zyC6e+hhNwchLaYaXwBm8Fv/CN/AzGmw2yfj4NgnUtkkA8BBhqdyB8pkN6j47xAHykDD3Q+/uUKW1egAiGQD8WLfLePWWKwovq2O4Pv5JIdj7qq27UhPGpdcii2jTNSaMtPqAZ8/0PIFYL2GSdotLyhC3iSBQDoB3XNW8taVN2aNa/atMW49Uxk9IJZs/loo73tdv56nMCLgBSEsykGzjVV/Sonx/OAfNI5r6liV7Q6k2esAAyJdwEw+vgPJhiH05lwlSwRB2fcXuc86vY3mDe7TfFXTbSaZ5C7c03W5Fu71igzTJEp3Lg1Epgk6kNLcraQuyeKVjQVhB8G2JiPiAuvlHXu6z2dDZfTOdzstvA2iQEd9vyVi7a00vR7Wi4hd+gewPlW3eFthMZ69UY39shRArl7/EvvSGCAmLT0aMtApag1e2HHrw77VO510GchX0rfw/EZ7NjtT
 qUQcCJnE
 0EgS+1gPqmQ/S1KM6IERzjoYtPRoyCdbibfS73cKqyZKhx6DRmArm7suoW9EKfZ/2WJd/sB30l5NRrag+sxzn1WdrziN+xBmc7naBTzZsjBcNjkZCg6E1dSO2Yz3c3o+PkOjFCmG+m+7q1McK7qVdHSt3FtaU5xy0e39cU/zH+102T/LJQEm/caPX6lFwhTXNBmh0Ij4p95ElCP7gvfY5YzhuENTfvh3iPS6VGkqjwcL2cUTjCPytqgnsu1kZ7G8hNJGnEto7Xqg4i/EIU10qvpbKpOLE9ulgeQmgpN6h4KfQEHgeWTGbnqjz+R7R1A5pO83PIihjX3jmGgxtltfw0bAAcmmXp+ttN3pbuIMUOw9QtVMy3Ikrl5rFupbcGGuSL9HTuGecxFjcMdx1i8RSPVUKQ8SgF+NlyTELgYveeV34X1c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

As we already moved from exposing huge_zero_page to huge_zero_folio,
change the name of the shrinker to reflect that.

No functional changes.

Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 mm/huge_memory.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2b4ea5a2ce7d..5d8365d1d3e9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -266,15 +266,15 @@ void mm_put_huge_zero_folio(struct mm_struct *mm)
 		put_huge_zero_page();
 }
 
-static unsigned long shrink_huge_zero_page_count(struct shrinker *shrink,
-					struct shrink_control *sc)
+static unsigned long shrink_huge_zero_folio_count(struct shrinker *shrink,
+						  struct shrink_control *sc)
 {
 	/* we can free zero page only if last reference remains */
 	return atomic_read(&huge_zero_refcount) == 1 ? HPAGE_PMD_NR : 0;
 }
 
-static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrink,
-				       struct shrink_control *sc)
+static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
+						 struct shrink_control *sc)
 {
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
 		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
@@ -287,7 +287,7 @@ static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrink,
 	return 0;
 }
 
-static struct shrinker *huge_zero_page_shrinker;
+static struct shrinker *huge_zero_folio_shrinker;
 
 #ifdef CONFIG_SYSFS
 static ssize_t enabled_show(struct kobject *kobj,
@@ -849,8 +849,8 @@ static inline void hugepage_exit_sysfs(struct kobject *hugepage_kobj)
 
 static int __init thp_shrinker_init(void)
 {
-	huge_zero_page_shrinker = shrinker_alloc(0, "thp-zero");
-	if (!huge_zero_page_shrinker)
+	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
+	if (!huge_zero_folio_shrinker)
 		return -ENOMEM;
 
 	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
@@ -858,13 +858,13 @@ static int __init thp_shrinker_init(void)
 						 SHRINKER_NONSLAB,
 						 "thp-deferred_split");
 	if (!deferred_split_shrinker) {
-		shrinker_free(huge_zero_page_shrinker);
+		shrinker_free(huge_zero_folio_shrinker);
 		return -ENOMEM;
 	}
 
-	huge_zero_page_shrinker->count_objects = shrink_huge_zero_page_count;
-	huge_zero_page_shrinker->scan_objects = shrink_huge_zero_page_scan;
-	shrinker_register(huge_zero_page_shrinker);
+	huge_zero_folio_shrinker->count_objects = shrink_huge_zero_folio_count;
+	huge_zero_folio_shrinker->scan_objects = shrink_huge_zero_folio_scan;
+	shrinker_register(huge_zero_folio_shrinker);
 
 	deferred_split_shrinker->count_objects = deferred_split_count;
 	deferred_split_shrinker->scan_objects = deferred_split_scan;
@@ -875,7 +875,7 @@ static int __init thp_shrinker_init(void)
 
 static void __init thp_shrinker_exit(void)
 {
-	shrinker_free(huge_zero_page_shrinker);
+	shrinker_free(huge_zero_folio_shrinker);
 	shrinker_free(deferred_split_shrinker);
 }
 
-- 
2.49.0


