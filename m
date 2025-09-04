Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E401ACA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 09:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 478A68E0009; Thu,  4 Sep 2025 05:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44E6E8E0002; Thu,  4 Sep 2025 05:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363CF8E0009; Thu,  4 Sep 2025 05:51:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 22FF68E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 05:51:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B3A7A86BDF
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:51:43 +0000 (UTC)
X-FDA: 83851100886.28.FF1A597
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf16.hostedemail.com (Postfix) with ESMTP id 74B7B180006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:51:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=UP15EjQR;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf16.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756979502; a=rsa-sha256;
	cv=none;
	b=DCLPerKWI2h94itzdqG6uosSPpvHhsfyRmj2IqxUAY6iV5x+jNWclhf+/80MI0+845Kt3H
	clK5nuK/TY4ZObNEo47uUiuGtljXULG9LPf4qrni/ZX6H53VStUv49crzAvzWjHWic5eBg
	+KiBrU+tssTWbxVXZKMHUXtFilBwdgk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=UP15EjQR;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf16.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756979502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=x783YplO/5tjt9thpzQQW4QfxErzCVsQDB0HrQ3Femw=;
	b=ZcrLgwOSU/N1gUg6ogxoc7BOwlQvDYwk2IFKNvXKA8RlCR1wiAQdc2z6JsmFiQhqWGAFY/
	8mh2GSWmdr0EDzWq/INpleoQj3qWHGwdzfN+z5KCo2A90bJrsk/xqEC/UzQJ1fv41xQjfO
	1Asz5t4CU20t2WChyEVZX3lJdWMoCIA=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4cHZWD5Wcdz9t9t;
	Thu,  4 Sep 2025 11:51:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1756979496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=x783YplO/5tjt9thpzQQW4QfxErzCVsQDB0HrQ3Femw=;
	b=UP15EjQRTgf8AXTpzsUwtLgs/7Bh43AuvseBH6zA+zqpIGOnDB2Ttbegpp8PFC6uq923Za
	i44sQ0lkIt2NgHybBfJ0ovOylQzEQA9aUm2ZrmnqjU2sZho+QbFhkufhOvUboplEBcrZAq
	vRkv7A4p0CSUNaJXRMTCAixbLx3hYGL7YRnwIYeQIo4YBo1l08WVF0IevcqZR/P0v4zQsC
	qTal45fJLavRmizwApYOPj2lz+n4qjDPf9vC31hldT5k4gOESnpa5A5tDb+x47AFOeM5fI
	8kfVpxM1TkF6GvZGshPs9DQStJN/SSQQEUZsNKm+sZLIDJ6uHOtGh9G8lcVSyg==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Zi Yan <ziy@nvidia.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>
Cc: linux-kernel@vger.kernel.org,
	kernel@pankajraghav.com,
	willy@infradead.org,
	linux-mm@kvack.org,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v2] huge_memory: return -EINVAL in folio split functions when THP is disabled
Date: Thu,  4 Sep 2025 11:51:29 +0200
Message-ID: <20250904095129.222316-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 74B7B180006
X-Stat-Signature: pqiiwjg9k4qrnokn5pmqttiayya39djh
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756979501-881703
X-HE-Meta: U2FsdGVkX1/qrfLUJQCFhv6L6EXUD5VHPAe64BBXNAjvZRtxBohuCyf6WfVu+BDsjHX75uFmhYOqjBKeaobMoFnp4vVJ4wXjJJxfXlCDEnZLHpp3rP0fQYHbMguXwbpDcIwu+btvgQ4QEN3swdYz6cz4+NjrP8OPbwkvaYzk8Rw6bM5x5X5/RzphgMu04SbngnuCx5xv+YfNILjjot6YWCaqBP7Rw/VBQxP67PR9cGL5tYjTKlHQk9ngUSXrhBR6xxEZmKC9FmcMcJMjsD5FmN3hDqhFZR019pyZMv5blHHKqAQ3NCEU4RgJHVCGcMCm1403VrJq3ios8ePkzge61TpUlFS6ORh9BE/krk2W8waQL5TVVgsKO1pJsPhoRQVnxCwnfkAK7/hW0xDnnB2xNgHvXPcBPo+UKHG8I7PzOGbb+Cw3CpnkDo0bcI1PU3ljCdGw5sUPSHLOcHna1fS+pS0YqWfyqfL8YoJrzbifd1RHQY0pGIDsHhXomYN/wz3mpmBqgNIJeqZENDSqj9ecEdGt95nFI7JkjI3N10T65r+Qksgk3Em7zVkVIbVsyQXXn+8foNL4x6O+QQMoeQIOt6JexKSkeUZWNt1oI4/TJt0QnU/xezQRtsyg+QdwIpg2xhSYYm/98Exebva2/TZtSkyYGmBKC9vug+AK3RQkTGT4Dsis7PXQa8LulbA6JtJJSFCeQlDL7sY/NCy9HWkxz5sFJ/3Zf7NLZ6x3A7ETeB4qMJK478uSTEBHQ2EyH2cx1LbdMvms43VVd+Oi4BpCRxQuMbxK2Xr1m1WoHvSGppgCnLkXzVDsdMQGkpR/8dNJbw2arB71Yohk0w2IxpcSuHOdujdKhHTAGy+SVcyKaZI2zPDpp968V2W3TSPlhlhC8CSVAcqL50ts7/4NGOIi+qOYeV9wRwgqgSnDJWY63AP2xn0Ve+Uq8tewac4640tkWDxPcrhdHE05VmkwpAu
 0OS5bf8R
 Pv69ejJECECFmYIXgwsFQo+DqvhWcUizi7TQZR43PrhTZ+skxgRX0UJ+jSQMSoBWvwzTFGAeCkm3jUUSWRSZnWfNfMgXDvOxASoSr+4nLTkX2kOXeS+x7fUg7KYSe/QEDumG7fYbAVeVKYxmDPC3Y6XdvXdRo+23WEJ+VMiQ3EngWlcmhanDsQl2fsZO/TM/ghb9V6q8jVFDMuH6aCwaf1uQ/rzoxVcN5HTVoYHNd+hmhVnF1N27NZg7OUU1v9UErrxlP3GYaK2AHs79U32UG618QF8SCs07DQ3Y6qr8qHyEJBq0wu6PehqrcXPt/HRTh6N7igaTc/utXZ3Hu7Zyn6y3QX5T8UiqHJZn/iERSiqoO9kBK0K/9D5ogQq61ekPvSaA3H6vMFbMyh+4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

split_huge_page_to_list_[to_order](), split_huge_page() and
try_folio_split() return 0 on success and error codes on failure.

When THP is disabled, these functions return 0 indicating success even
though an error code should be returned as it is not possible to split a
folio when THP is disabled.

Make all these functions return -EINVAL to indicate failure instead of
0. As large folios depend on CONFIG_THP, issue warning as this function
should not be called without a large folio.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
This issue was discovered while experimenting enabling large folios
without THP and found that returning 0 in these functions is resulting in
undefined behavior in truncate operations. This change fixes the issue.

 include/linux/huge_mm.h | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 29ef70022da1..23f124493c47 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -588,22 +588,30 @@ static inline int
 split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order)
 {
-	return 0;
+	struct folio *folio = page_folio(page);
+
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
 }
 static inline int split_huge_page(struct page *page)
 {
-	return 0;
+	struct folio *folio = page_folio(page);
+
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
 }
 
 static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
 {
-	return 0;
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
 }
 
 static inline int try_folio_split(struct folio *folio, struct page *page,
 		struct list_head *list)
 {
-	return 0;
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
 }
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}

base-commit: 291634ccfd2820c09f6e8c4982c2dee8155d09ae
-- 
2.50.1


