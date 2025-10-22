Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEFFCCCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:40:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57BA78E001B; Wed, 22 Oct 2025 14:40:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553018E0010; Wed, 22 Oct 2025 14:40:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469398E001B; Wed, 22 Oct 2025 14:40:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 364068E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:40:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1F08C093E
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:40:01 +0000 (UTC)
X-FDA: 84026614602.18.ACDDC4D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 40687120010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:40:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TDbBAhTW;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761158400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vK1RS4Zk73trufPBSaFPSUR9TYlw/wAla4oKRU3Q2A=;
	b=sX1bep23fE9XjRWws9GIN1LMWuwD0rbONa7VJVvk2QVxKDx+jAqSipl7UWY/Rw2pc6uNDR
	ZN10O3U4qJDCZKzeM1B7TJngY3Azi//ok8AOUowgRstiJNWgeU4awayiyElYmEvJPgWcNM
	tQ7Ci+cseGurDQyRcNPwXpg96fYsAvw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TDbBAhTW;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761158400; a=rsa-sha256;
	cv=none;
	b=jf4vzsywY+57UurRLnpcnsZcaRxo8MgZV1PKRo8s8jvQ5DP1d6nSAigFGIqPHPsZldl2tR
	Y5KRYkoIVg9OyWsRNO2APylmGUY01ef2Tjw7QIcnpLlgE+VvTUNACPfPfpLN3vXq4FmF53
	LJm63k5K0AXKp5hk7JItWxn2yYKIvhc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761158399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2vK1RS4Zk73trufPBSaFPSUR9TYlw/wAla4oKRU3Q2A=;
	b=TDbBAhTWVNJh7z3IBS4w7IWnWgceVGD1fqUpMn8Sa0nj9VMyVbGfsNU76zHcQWHru0rptr
	i33E6wwoK8VA3xjUOkZE6BvFIjXklNMmwy9U4Rg0KD5fCwVCmBgPrzXCJaLSFpSIV0www3
	JnNAKqjtsNC3jKBA6DnmJJxWVy39Yd0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-16FQH2eaOmWNqsjZWIxpBg-1; Wed,
 22 Oct 2025 14:39:56 -0400
X-MC-Unique: 16FQH2eaOmWNqsjZWIxpBg-1
X-Mimecast-MFC-AGG-ID: 16FQH2eaOmWNqsjZWIxpBg_1761158391
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7BE9E19560B3;
	Wed, 22 Oct 2025 18:39:51 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.41])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 55D0C19560B4;
	Wed, 22 Oct 2025 18:39:42 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
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
	kas@kernel.org,
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
	hughd@google.com,
	richard.weiyang@gmail.com,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	jannh@google.com,
	pfalcato@suse.de
Subject: [PATCH v12 mm-new 09/15] khugepaged: add per-order mTHP collapse failure statistics
Date: Wed, 22 Oct 2025 12:37:11 -0600
Message-ID: <20251022183717.70829-10-npache@redhat.com>
In-Reply-To: <20251022183717.70829-1-npache@redhat.com>
References: <20251022183717.70829-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 40687120010
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: qnwtx8oh91y346m1hqkijr6hcrnew88o
X-HE-Tag: 1761158400-474197
X-HE-Meta: U2FsdGVkX18a1IGP4whWM2w4mrg9qPeCDixiRLes4N72c6P7nvMeDaLgU1GnZGHBaU9HVeytdq/Xae21IRgxOvY906tmxpMJb6WwNPf/pOi9mJV6Htnj0BKqyDJg+rSJ1WtVY+4JMZwVbL24bksfBME2RjVyU4CFDQzUQNrd7j6uaH12yOJucE1LjZzYBccnzHq2qR9SsAhux0RtPmeV4zKr3H5Xr18vpWmSzFlIbnNfGkrM+exP71d5GpkkfXRzC576xHFRwZDnSSVszJ3G2AdrH/cVNOum0XcG6qZie2ciwQJCR6Psc16rVLWOejvf1S/mnrMNlrDx7JfBxGgWK+Wc3lb0Ndywx+5zG3Xutnknfc6CB9xw2SROkpgjzO5JGX70K1OLbSWebLsXgr+bV/FzVgOVscBvTr80AIZHTQzvEj6h43/1ANoTw+X66BQhnSL+ZEuUVEUnLtTsNySOKxL5H0lF8p0KXuXuib4WVsm4YYsRnaPov6VEVT+TYbI8zVv16+6cwxcA3ouPo7CkQmAh0x1mh+Yo/wGCEXglXSwAx1LQvE9pCoNM+iNu+D5WbJ90W5rGD0i8fB+pnqepMjD5PodQ9WN2bZcOWxVKpbIE9NZi8HKY4e46ASdEB4cHkeJnN2SP0oRz/e+VaLbpQXJl7SPl3lyYC0WiZsF9N2ZsB5BhY1en1IMzbHLl2GK3+CcVWI/nAWKMdMnF+vJiaFQli6JLR71RrJvB4hjcMuctZ4CV/gfK1QwQuCoh7A8J10TsVZP0MRHDoYQBXfJfw6FUDVqULXuztZzKbLaPfWkSw+GlDqgXUvUU9NaAYWbmbTx9+UinNOit0yfMBNAXyEn3vZ4tpM70XlMUbaJLZeLXOzGi/DhiHdWE838UU0NKb28KFy9DZSJj1ahEQ+yZ92jnTkUJ9shjyR56cR3PUEhUVpDEiGgRAYXKOjfjpThB5TQWoiV1nodwYbHaiWS
 NYaes6Nr
 r2XgiKbHTO36USpgQsbToQ3IBWS2ElsCPu5tCCf38Toh/OHUqXhSChqnHIGkrB6Y5W98EXvtdLl2N2wuaoSzVFMJF204zk8G5gsAmxFeSdevXdhOikfocyLk+M9jKhOa70a3z/7dhV7S7RgOAwGL23lTp1h3qDzG6Opvefdty9fWzp+MizQWZpvmYMp4ovmjXtZk/DWhP4k4G9V+aGODrES1HTjb3G8OzS5RemwQQSbBzQCE5wk7rt7BWjiMx14WE8+jGAnc82QLk24Bdm0Usy2fiMpdZVT1rCpqUPyuAntdtNHyRxkRuH/588IJKya8E6ZY5glXYo3OJ0EmdVEmoqhTdiiLS6urPGJfh2kjJ5gm0ek7S8yNDDDqIAr0Eok9wHnnxQTktFlAANQLNUXuYxr1NLTQe0joWEg48U7QuH+G+KsU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add three new mTHP statistics to track collapse failures for different
orders when encountering swap PTEs, excessive none PTEs, and shared PTEs:

- collapse_exceed_swap_pte: Increment when mTHP collapse fails due to swap
	PTEs

- collapse_exceed_none_pte: Counts when mTHP collapse fails due to
  	exceeding the none PTE threshold for the given order

- collapse_exceed_shared_pte: Counts when mTHP collapse fails due to shared
  	PTEs

These statistics complement the existing THP_SCAN_EXCEED_* events by
providing per-order granularity for mTHP collapse attempts. The stats are
exposed via sysfs under
`/sys/kernel/mm/transparent_hugepage/hugepages-*/stats/` for each
supported hugepage size.

As we currently dont support collapsing mTHPs that contain a swap or
shared entry, those statistics keep track of how often we are
encountering failed mTHP collapses due to these restrictions.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 23 ++++++++++++++++++++++
 include/linux/huge_mm.h                    |  3 +++
 mm/huge_memory.c                           |  7 +++++++
 mm/khugepaged.c                            | 16 ++++++++++++---
 4 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 13269a0074d4..7c71cda8aea1 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -709,6 +709,29 @@ nr_anon_partially_mapped
        an anonymous THP as "partially mapped" and count it here, even though it
        is not actually partially mapped anymore.
 
+collapse_exceed_none_pte
+       The number of anonymous mTHP pte ranges where the number of none PTEs
+       exceeded the max_ptes_none threshold. For mTHP collapse, khugepaged
+       checks a PMD region and tracks which PTEs are present. It then tries
+       to collapse to the largest enabled mTHP size. The allowed number of empty
+       PTEs is the max_ptes_none threshold scaled by the collapse order. This
+       counter records the number of times a collapse attempt was skipped for
+       this reason, and khugepaged moved on to try the next available mTHP size.
+
+collapse_exceed_swap_pte
+       The number of anonymous mTHP pte ranges which contain at least one swap
+       PTE. Currently khugepaged does not support collapsing mTHP regions
+       that contain a swap PTE. This counter can be used to monitor the
+       number of khugepaged mTHP collapses that failed due to the presence
+       of a swap PTE.
+
+collapse_exceed_shared_pte
+       The number of anonymous mTHP pte ranges which contain at least one shared
+       PTE. Currently khugepaged does not support collapsing mTHP pte ranges
+       that contain a shared PTE. This counter can be used to monitor the
+       number of khugepaged mTHP collapses that failed due to the presence
+       of a shared PTE.
+
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
 huge page for use. There are some counters in ``/proc/vmstat`` to help
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 3d29624c4f3f..4b2773235041 100644
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
index 0063d1ba926e..7335b92969d6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -638,6 +638,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
 DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
 DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
 DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEED_NONE);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+
 
 static struct attribute *anon_stats_attrs[] = {
 	&anon_fault_alloc_attr.attr,
@@ -654,6 +658,9 @@ static struct attribute *anon_stats_attrs[] = {
 	&split_deferred_attr.attr,
 	&nr_anon_attr.attr,
 	&nr_anon_partially_mapped_attr.attr,
+	&collapse_exceed_swap_pte_attr.attr,
+	&collapse_exceed_none_pte_attr.attr,
+	&collapse_exceed_shared_pte_attr.attr,
 	NULL,
 };
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d741af15e18c..053202141ea3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -592,7 +592,9 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -622,10 +624,17 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -1073,6 +1082,7 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 		 * range.
 		 */
 		if (order != HPAGE_PMD_ORDER) {
+			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 			pte_unmap(pte);
 			mmap_read_unlock(mm);
 			result = SCAN_EXCEED_SWAP_PTE;
-- 
2.51.0


