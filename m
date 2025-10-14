Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6344CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 11:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4676D8E00E9; Tue, 14 Oct 2025 07:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A2778E000D; Tue, 14 Oct 2025 07:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21C378E00E9; Tue, 14 Oct 2025 07:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD078E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:34:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ACAF713BE90
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:34:10 +0000 (UTC)
X-FDA: 83996511060.16.1CBE920
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf09.hostedemail.com (Postfix) with ESMTP id D67E314000A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:34:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=O0KE4txq;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760441648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkhosY4kudM5b2LDvScLHpmry/qDRID3Z35q3P72RpI=;
	b=rIyVWqZ4ahjbU5JVxWfHCsjKIyrvPbySFLoZyDjRPF9RwjeKtClweVXIDhq8kYgcP7Z+RD
	wUcDCeuMPJX3Cl7yPC6py3id4wM48Lc87ai8kUu/AwtWB2iQj5gDxMkfB4GrzXgWK4GmJv
	qemUPHv0BOrfZVie2wCValKNdidz9o0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=O0KE4txq;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760441648; a=rsa-sha256;
	cv=none;
	b=AfhWQvI4IHDlX+gIEg7wXAs+lNM3Sqtoih/7T6rT23FKKCgAUm4HdatP1I+tZLQA8HWZa5
	uQsIojfFJOgllNW2HItpuMO6d8JfIcwhBup6oNu3VJnC7geyuwXy7JG+RLfLiNerDd/UPM
	3ihgUb9pvQ1ojosEZuY8eo5tbqZb/7E=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=OkhosY4kudM5b2LDvScLHpmry/qDRID3Z35q3P72RpI=;
	b=O0KE4txqhyV3Vzh26t9+GWh7OSn/fdvdkDSIto4DukT7foH1H2jJEjZU8DETzLQZtkDWWqtzN
	uwDRBLzwt52cMawThoI2BHdPvjmJsmkYQdfHZZvBpyfkdnNbmZYSwZYqX6ivS5MAlqjwXhdR8uN
	N9xpd8CHdU+IaD7blDzlvQ8=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cmBtb3bKHzKm54;
	Tue, 14 Oct 2025 19:33:43 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 267301400CB;
	Tue, 14 Oct 2025 19:34:03 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Oct 2025 19:34:02 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: [PATCH v2 1/3] mm: mprotect: always skip dma pinned folio in prot_numa_skip()
Date: Tue, 14 Oct 2025 19:33:47 +0800
Message-ID: <20251014113349.2618158-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251014113349.2618158-1-wangkefeng.wang@huawei.com>
References: <20251014113349.2618158-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: corj7kw7ucmhyw7icaxxpoekkzwz7oww
X-Rspamd-Queue-Id: D67E314000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760441647-252696
X-HE-Meta: U2FsdGVkX1+owQTK1yzeiMPcFKzmspqpDPqBM+ajivrHia5yW/RqmNaqphQgJ+JNdwh7e7XL0yzjh1Ixnwq0xBgdb2OeaF8PqXR+3x6f9ShUNIQOyKUekC2GlRoQfRCxH4mjAJvgmUMfd9fxB6meLiFkAGpEtB1Xd5ua1a9bAcq0c2Z4KbqoEi6GJ7U3v2u2J+2s4DojvUjGfEjveYjK5TAwf1uH+MeFWI/MJo2Xk05EMtpSKLtg5Jqp6rF/S+G3oA/7Ez9z/rpQ7KVypFNCetMRI3cIbEvq9EP9W9VXUoTJ9NwR/ohyHUx7jvCcQwtdvE/pczYOlYJQso4JkJ8LVqJ0op9ghjdY6dbh3z7b3mFHQKeiJSmU9NnJh5+2tffhY6ZJ1t7pt8HDgmBIEpSmaZT2SgylL4sZbcJjW0MPcP3mv4gLuJjBAWpnjgjngDgfPcXQK9QZPRR2jdvw5UHnocXb9yqeTeCcc8R+ELv0qS6rRYDZANTf0KQoqKwVxd+HCiNei+vuKg1lXVKBMjXC3zJDsVbGfG4HBHBoUq7hE+k7LE7B7zteLzedHIqA6TwBqwauzhWUcn9jztoUUMXBttHMxisfxSKO02zOSEeDKd1giLSshJmIKelvEULiUyqbZzdVL7HyjcAFuB/y5YCHm7mANrm5UBCgrn/5rxGOKyxtL5bP6F7L6/GMd1ZIEeU9uHdn6+gZcTAiGTAFwMe1bDbx5U+wY9O/N2OYKGkWSifeycTVFIKHGkaFQp5Ez2Amkh6lDQ0EzG49oqHjdnZmQBgZHndNZNqNTRJQhDA3zxMCXiJnSQx9ViqUnkqY/xbrN0PmeV0bGWte4V1WhN5iJSRcgyhD+KTVH3BaINngK7yWtdPLo9MsDSLP1KihryeWQeMud0OIF9DoaGV6CnU4+xp4OuY4qRa8fyL+a1Hfv+AjUKxbzasd1H98VkNK9uw7rrR/SNfz9AH5K/TqyRH
 y8dLmP7e
 wvAy3GOAIZIRvLQavYl5oReVGtAc/5BgEUqlekdGTfWVUOM3nm0lI88dVHf//q55FuoPM5tHhSM3gftilCUTmaJtXguZQJo5u9lFUtgZ5HihOUtmKxFeMdg3/PuZLE3FcrftlX2Nc8vXmeqt93JxuiTT6c5j77dWbplxJIZps+UGMTctpMddpQW4jEr3NtyElqg0pqZ12iYHJ1K9N4ymTX+dsqUorIC1d5aDGKqTuOThEFXBAH8iapzz0gsrlGx9AzHwyZhVa+CmTusTr1alfgj00oD0D/5DYO1mISEkWhnq3tK6rI0k5ir/YPPUONZO2iObMBj2rVNPjCISODxlbQbwKharvFOIqrixJpZRrEejxOMgiHzYnc4EzvjChKlNzDRoJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the folio(even not CoW folio) is dma pinned, it can't be
migrated, so always skip pinned folio to avoid a waste of cycles
when folios migration.

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mprotect.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 113b48985834..bb59a42809b8 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -136,9 +136,12 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
 	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
 		goto skip;
 
-	/* Also skip shared copy-on-write pages */
-	if (is_cow_mapping(vma->vm_flags) &&
-	    (folio_maybe_dma_pinned(folio) || folio_maybe_mapped_shared(folio)))
+	/* Also skip shared copy-on-write folios */
+	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
+		goto skip;
+
+	/* Folios are pinned and can't be migrated */
+	if (folio_maybe_dma_pinned(folio))
 		goto skip;
 
 	/*
-- 
2.27.0


