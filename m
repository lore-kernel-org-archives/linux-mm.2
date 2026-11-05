Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C587E606A336
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=gmOcblTI
Received: by kanga.kvack.org (Postfix)
	id EE30D6B05BC; Thu,  5 Nov 2026 07:07:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8B826B05BD; Thu,  5 Nov 2026 07:07:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA18B6B05BE; Thu,  5 Nov 2026 07:07:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B92656B05BC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:07:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5122EC09C7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:07:18 +0000 (UTC)
X-FDA: 85400940156.26.06F93AD
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf21.hostedemail.com (Postfix) with ESMTP id 630331C0007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:07:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=gmOcblTI;
	spf=pass (imf21.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793880435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8OcxAA2gqpojmN7yaA8Tg1JRGUaJg5iMD5QS2qC5vIs=;
	b=AfvaONJtZwB9KmZkx7nDOGc2FgMZjLhdKi0luoAhxVftbaPP0zeu7IMJZJ3PsLTeRCG12X
	e1Xmg71/Kkyqtiyq3IcCYSLtT/+1TwiDCn5XtzngfL7njAHRfuj92ziCMIpDCj/g9Mw5iX
	zIQyw2OxJW3XQJaOXrEM2BhONCgXZVs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793880435;
	b=o6tLUay9DTNCoxkDYniHS4MOExYQPsd7K4X2ZY6snlAsfvy1+UhjJ8hDQztfY5m35ray/k
	icPJPLVM5alwfO99Xf3KDbEPjgktYNGDFDVytdhvEIhDmtRH3eh/0k/XKEQFnE8x1Zyf/e
	Stn9fckc6SwaUKytXkKqdvclDLyTFmE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=gmOcblTI;
	spf=pass (imf21.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793880428; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=8OcxAA2gqpojmN7yaA8Tg1JRGUaJg5iMD5QS2qC5vIs=;
 b=gmOcblTI5AxbE0CuFcvKs+dd4SIfzxfAesNL+B+0KMim6UQC7VN2OEDy1mGiA6j4Bu5MN1
 21ekqNR8+J3JVC6nuCFJ+H8Ytb/qtI4aXRuyEgytSqIeanb3ZqWCBO/gx0MnG/xVh+WiD+
 LqUCrJGci7ukbt5nhHtyCPLLxl5iCRR3S5iNp27JugJrIKcItMaWE31K5rTTtfwT988qNx
 Udxnn3GN5OVlzTsDjdeVowRnK8fDBmiNbXY0aEcFYOCJ5+1M77ki70s6W/RSdaQpWBF2GB
 v2YnMvpfvYOiYCZhXYkzDtFoPJ9RcORQjhzW53aYlpi0iGau2ChYvo+4eKFC9Q==
Subject: [PATCH 2/2] mm/hugetlb: optimize bootmem hugepage tail vmemmap init
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26aec716b+7a1bcc+kvack.org+lizhe.67@bytedance.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <rppt@kernel.org>, <apopple@nvidia.com>, 
	<balbirs@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20261105120615.16817-3-lizhe.67@bytedance.com>
References: <20261105120615.16817-1-lizhe.67@bytedance.com>
In-Reply-To: <20261105120615.16817-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu,  5 Nov 2026 20:06:15 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cxoj5nbyobd3iukqr9y6xgjqtm4y1i3c
X-Rspamd-Queue-Id: 630331C0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793880435-391091
X-HE-Meta: U2FsdGVkX19zGfnbSnMndIPLCC8mqBRKBNKuEmNNl1APuArwFEVgJqX8BCSoSF1KLjA9gLNlfby+GKPNgtu/oe4xs/G6lSv/FiICQ5qgwYKlSWcrp6V025YWioOTzfGu1k3rqJOk+nYmJlvtkvYbzbLcnYL+SN0MqddaeCfdcDLE1YsyEwccxOx5v5Fkqw5JE/zJx7OXASAU8RRmOyb2rYRVMaqdILydeeX9MF6d39paCLJ9g5L8Qb2hY7Lp8slTYWtSmJozGFhTAlHdhZr3oQtIGCEHmfkP4Pxr11LBt5a87LrsM+8NNQLZp7DDWmV39bnrYqZrdjvH129LPZjo8/mhhu1asLg1QGjyDyUl9aHYJfHWRkol5s7gIx8Ot0C8RsqtqbwCbyMHZ8gzX1G8kW6mgtCEknW1afFLmPv/W3eMQ7AJtKG3c4NJhM02+Wov+lzxnLq1sKubKkE8CqsrzKZtKY9Qtp1xCG3S2IPiTde8Wxe9OV40NE7oNaQUPQUkLRnBhPJGrGmDLKvqBVYf2PPZdPjXppSDIFUeZMP6IDckeKEc8MEl0J3fQIM77zWpsUGBiwOfzV82tvGTAFTo9MeyNhDIUJRCSKmq+sF8ObZKtr6irRkhEE7BtjgFgtzLMsS9xbDE5g8U6yOBzNL2jSMYWa1P1rjEHRWblNRjTsDCOsKgTSqBvrmuugAxisgsHu4A/IpnKR33ZY+7T/igO1VSIB9crhaEKIJNZYSDUEgvdu6DDoj4Z01ZYqzqX3/28NjDxA+6NNvsdlY3sznPJ07AWg3CVte47xjrU5QZQqqy1qG1qr/5N/kiOBkISDqZI/nXQVMr0UGKBmNdRVq6Q5AqI0x66u35nBKyEESw3v3qV/IgoXRmleYvjPcl+xsc7uBZhqzoUE+JlPhdKdv9lvMJ0eDYP714EcKS6+RfqiYynGYXra2P4mPo+6uY+IRUsfYgLj0z83UUp4Nv5Y1
 u648rxW0
 LDbgFiIwLqaElICmn8rEowpYOpOUmZo261bwaxRqBZx+RmmgX6OFQ8ZEDdMTq+/UGzfCPm0OWTX/ajBxQQ7zLebo1++avs7iTVN3FO2zfHFcuKgefY5ngWwopjOn5JapJngj2aTKQql+Xg5Xz4MKlJgDC7EHy9s79FoFhTIzCKPhxlIoarbi5U9rj4BfR6D8IpwQpvm0QonuqRJ13CZAU0ZmX75wRkhlTsW29Ed1ky6XB+/LOvMkP1n8QXr2/IUZGkTBK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Boot-time HugeTLB allocation has to initialize tail struct pages itself
when HugeTLB vmemmap optimization (HVO) is unavailable or fails.  For
gigantic pages, this can cover a large number of tail pages.  Most state
installed by __init_single_page() and prep_compound_tail() is identical
for every tail page in the same huge page; only PFN-dependent fields
need refreshing.

Initialize the first tail page normally, copy it into a local template,
then initialize the remaining tails from that template with
memmap_init_page_from_template().  This avoids repeatedly doing the full
__init_single_page() and prep_compound_tail() sequence for state that is
identical across tail pages in the same huge page.

On an arm64 QEMU/KVM guest using 4K pages and 64 boot-time 1G hugepages
(HVO unavailable on arm64 in v7.4-rc1), the measured fallback tail
initialization time improved by 36.43%, measured with a temporary
jiffies-based printk modeled after the existing timing in
memmap_init_zone_device():

  base:             318.4 ms
  with this patch:  202.4 ms

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index da5d04edf7c1..987f16a5ea27 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3219,19 +3219,32 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 	enum zone_type zone = folio_zonenum(folio);
 	int nid = folio_nid(folio);
 	struct page *page = folio_page(folio, start_page_number);
+	struct page template;
 	unsigned long head_pfn = folio_pfn(folio);
 	unsigned long pfn, end_pfn = head_pfn + end_page_number;
 	unsigned int order = huge_page_order(h);
 
+	if (start_page_number >= end_page_number)
+		return;
+
 	/*
 	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
 	 * we must initialize them ourselves here.
 	 */
-	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
-		__init_single_page(page, pfn, zone, nid);
-		prep_compound_tail(page, &folio->page, order);
-		set_page_count(page, 0);
-	}
+	pfn = head_pfn + start_page_number;
+
+	/*
+	 * Seed a template from the first real tail page and refresh only
+	 * PFN-dependent fields before copying it.
+	 */
+	__init_single_page(page, pfn, zone, nid);
+	prep_compound_tail(page, &folio->page, order);
+	set_page_count(page, 0);
+	memcpy(&template, page, sizeof(template));
+
+	for (pfn++; pfn < end_pfn; pfn++)
+		memmap_init_page_from_template(pfn_to_page(pfn), pfn, zone,
+					       &template);
 }
 
 static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
-- 
2.20.1

