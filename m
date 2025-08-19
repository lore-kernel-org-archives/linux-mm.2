Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E82CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 14:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9623D6B00FB; Tue, 19 Aug 2025 10:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93A226B00FC; Tue, 19 Aug 2025 10:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828AF6B00FF; Tue, 19 Aug 2025 10:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 71DDE6B00FB
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:17:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B3561A073A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:17:10 +0000 (UTC)
X-FDA: 83793709020.03.A8C6A30
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id DAF3EA0019
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:17:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y3mF3+fX;
	spf=pass (imf15.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755613028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AyWTWLJP6DW1C6EfE8Dr/2WHmv98BO2UL0YW0p387dM=;
	b=U0UCtVpoewDbjR0eCO6nw2tHhOUtClz46dKoDHfMPbeja9avb1CpzhyxaVgsUa8OFSnUuv
	TmJpGJSvxAnk6svVmBvhpu3Hk2kPVuU3lYcb74kkVseZGkZjqCMyU2L1Bnm5eRssLfaDVW
	rELbzr3m7/WsqZ9xGWZDIxMNcQjgkpI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y3mF3+fX;
	spf=pass (imf15.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755613028; a=rsa-sha256;
	cv=none;
	b=XapvP5dVPOwDcjGy5BoU5IunTGUuAAePn2/QAUx+PEy1MmuS4c6cNcV4msJRFR4J4os+/8
	vYjdrv9UdtWdEhgRb8znTk6K18n8l5pD7G0pE6a/vGZGM5sCPxjMHAHF4RHuUdDWnz3E37
	GBVmQsit+Y9eW+fIBk1PYuy+8V42AnE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755613025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AyWTWLJP6DW1C6EfE8Dr/2WHmv98BO2UL0YW0p387dM=;
	b=Y3mF3+fXnMdGRmRyxp8VuZltvaAj1u6HyFipMz+w5RXZrQNQ1ZKkSKN2cws6++NwM3uJuI
	dhQpFFNyC4y2zhj0Ije7FO/eRrh4OsNvbaExjz+bnG/eDfVW8/JCqtfzcnAIuhKdxo57fY
	swWS5vThTyUBjIJDxVrGdG+jwiBReeU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-97-WICi4W53MiWUgZ8wwI-hHQ-1; Tue,
 19 Aug 2025 10:17:00 -0400
X-MC-Unique: WICi4W53MiWUgZ8wwI-hHQ-1
X-Mimecast-MFC-AGG-ID: WICi4W53MiWUgZ8wwI-hHQ_1755613012
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BCDA188280A;
	Tue, 19 Aug 2025 14:16:50 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.137])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4EBB019560BC;
	Tue, 19 Aug 2025 14:16:28 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	willy@infradead.org,
	peterx@redhat.com,
	wangkefeng.wang@huawei.com,
	usamaarif642@gmail.com,
	sunnanyong@huawei.com,
	vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com,
	yang@os.amperecomputing.com,
	kirill.shutemov@linux.intel.com,
	aarcange@redhat.com,
	raquini@redhat.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com,
	tiwai@suse.de,
	will@kernel.org,
	dave.hansen@linux.intel.com,
	jack@suse.cz,
	cl@gentwo.org,
	jglisse@google.com,
	surenb@google.com,
	zokeefe@google.com,
	hannes@cmpxchg.org,
	rientjes@google.com,
	mhocko@suse.com,
	rdunlap@infradead.org,
	hughd@google.com
Subject: [PATCH v10 12/13] khugepaged: add per-order mTHP khugepaged stats
Date: Tue, 19 Aug 2025 08:16:10 -0600
Message-ID: <20250819141610.626140-1-npache@redhat.com>
In-Reply-To: <20250819134205.622806-1-npache@redhat.com>
References: <20250819134205.622806-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DAF3EA0019
X-Stat-Signature: 8nahx96oknsk4i7ya4ga8x31ogzipeon
X-Rspam-User: 
X-HE-Tag: 1755613026-876016
X-HE-Meta: U2FsdGVkX1/0JAyQgw9O+R9SzN3jpE149abMswedzCRkRFRveLThN4xhscIzLspfjkArPMMCGUPLkVMHydnq5KxXvJ8emmrj9+aeJcj+nNkcysfWWOlD0TepMUl7Ywz9/v3n2a44+V7RfQml9+KKZFQ1B9fe21IyKJZ3+kHszWEBuekE/Z0MFiwKcYqXwhnqtoclzPKCgKwjweh2fb417bBYNzXIsu9s/Kz4DujLEFbB6K43p6WgeSwI/y6NmciTnD7SfUl9iITVIkYhdz+Zjf98tvJqrzfwycezI5Q5dDY/j9CskSzv62CN7U0QTpL4HJnLChyuayn/oTOsFUnugl6tMIea/WDr4lE+vq4GkfK41nigKN+jkqL3Vrhgd+JDxgf5j0Vuad5fVIhud+SGsC6X4f3eWoo+2fEtgoPp++uIQG2EjklGYstjPbNtid+KAL+VjKNDi8jhZ0v5nRPn5fBIothkveb+0DCn2QLbPolsFR/Di2RdQGzFMLgkoOn+N6Y///8QsPh6RZ8VyxoIhE59UO01Hg7yWzQta7ofxyB+oAAYLnPOBKfR0poXGEYeTL3wDCluGwgIvqg7hAjfSo+2Zr1mx63T5XYx+dLe/Luwxf7cGaLQF6AjGkC30kypoX8vklm/zl9ThNMOfrZhnPmWiKb8FaAgF/srGR5aYGfg/NMT7Ii4WaZslQEdRVQmBFhVK1WaB2UIwIiRo59wggBiSeHrnCBCVw75fojCa7sFpNqmUd9kd0XVi3HMICwDSVLS+h2dAVp8nUgYb4KxdIO4wtsG9kUWlivZISxuUJHQgW41/vgRTJijoQm2r/Zrsa7IvGtfI7s04gDNj6XaXXX3+Xd81yGFBNQnEu/H8X0+3YqwTgPa2bb57IgonqZqTjMFhKIIvxXuGpRO6hxuhYUOMpvEn5YwjFBmzhIT9orZomZBVPqQFC5nHt9kODDTpSq81B+GivtpXGCabTM
 lnLhTeN9
 KZhWdz2IQ8586PZp3T4/LU9ZyuU/NAsHhFtDXFw0oIOMd6t8cKrQVzLUOfbBObfpUd+YIy4zIrs34gYTs4NjtB6haD6SdOVsknsbIpDsuYMBdhm8jRuHQsaWMUWGdAxA8FvFF3QLFqmuOb+l4dGBdIXqcNP+FKQ3A8NUspxP+GYc4nS08TiTB1+fySaNQbaCCJqF6UrSSgv4XsvcnPQLXDsv+l07nx6rxjlkuLMBo3HrvP91SPgzsBCXORkGTvJoi9A6z4ZlB/09fe04FmK9yp5rwE80/7eONBOL62mr9tbYf1A2/p4GQ2LN6bgRmGRLMK1qzIYCw9DJ6bVRdVTTuzt1QDWQvq3GG8rdZBKe7ig5e5KrSuD6yUhLh0urCbcLggV0Kgc7Q4qOJ5cmJ8hKSIk8C2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With mTHP support inplace, let add the per-order mTHP stats for
exceeding NONE, SWAP, and SHARED.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 17 +++++++++++++++++
 include/linux/huge_mm.h                    |  3 +++
 mm/huge_memory.c                           |  7 +++++++
 mm/khugepaged.c                            | 16 +++++++++++++---
 4 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 7ccb93e22852..b85547ac4fe9 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -705,6 +705,23 @@ nr_anon_partially_mapped
        an anonymous THP as "partially mapped" and count it here, even though it
        is not actually partially mapped anymore.
 
+collapse_exceed_swap_pte
+       The number of anonymous THP which contain at least one swap PTE.
+       Currently khugepaged does not support collapsing mTHP regions that
+       contain a swap PTE.
+
+collapse_exceed_none_pte
+       The number of anonymous THP which have exceeded the none PTE threshold.
+       With mTHP collapse, a bitmap is used to gather the state of a PMD region
+       and is then recursively checked from largest to smallest order against
+       the scaled max_ptes_none count. This counter indicates that the next
+       enabled order will be checked.
+
+collapse_exceed_shared_pte
+       The number of anonymous THP which contain at least one shared PTE.
+       Currently khugepaged does not support collapsing mTHP regions that
+       contain a shared PTE.
+
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
 huge page for use. There are some counters in ``/proc/vmstat`` to help
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 4ada5d1f7297..6f1593d0b4b5 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -144,6 +144,9 @@ enum mthp_stat_item {
 	MTHP_STAT_SPLIT_DEFERRED,
 	MTHP_STAT_NR_ANON,
 	MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,
+	MTHP_STAT_COLLAPSE_EXCEED_SWAP,
+	MTHP_STAT_COLLAPSE_EXCEED_NONE,
+	MTHP_STAT_COLLAPSE_EXCEED_SHARED,
 	__MTHP_STAT_COUNT
 };
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 20d005c2c61f..9f0470c3e983 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -639,6 +639,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
 DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
 DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
 DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEED_NONE);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+
 
 static struct attribute *anon_stats_attrs[] = {
 	&anon_fault_alloc_attr.attr,
@@ -655,6 +659,9 @@ static struct attribute *anon_stats_attrs[] = {
 	&split_deferred_attr.attr,
 	&nr_anon_attr.attr,
 	&nr_anon_partially_mapped_attr.attr,
+	&collapse_exceed_swap_pte_attr.attr,
+	&collapse_exceed_none_pte_attr.attr,
+	&collapse_exceed_shared_pte_attr.attr,
 	NULL,
 };
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index c13bc583a368..5a3386043f39 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -594,7 +594,9 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				if (order == HPAGE_PMD_ORDER)
+					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out;
 			}
 		}
@@ -633,10 +635,17 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			 * shared may cause a future higher order collapse on a
 			 * rescan of the same range.
 			 */
-			if (order != HPAGE_PMD_ORDER || (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared)) {
+			if (order != HPAGE_PMD_ORDER) {
+				result = SCAN_EXCEED_SHARED_PTE;
+				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+				goto out;
+			}
+
+			if (cc->is_khugepaged &&
+			    shared > khugepaged_max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out;
 			}
 		}
@@ -1084,6 +1093,7 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 		 * range.
 		 */
 		if (order != HPAGE_PMD_ORDER) {
+			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 			pte_unmap(pte);
 			mmap_read_unlock(mm);
 			result = SCAN_EXCEED_SWAP_PTE;
-- 
2.50.1


