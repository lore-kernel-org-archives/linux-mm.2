Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E357D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 998476B00A6; Mon,  1 Dec 2025 12:49:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 949436B00A7; Mon,  1 Dec 2025 12:49:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85ED06B00A8; Mon,  1 Dec 2025 12:49:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 746176B00A6
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:49:14 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F0C114033B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:49:14 +0000 (UTC)
X-FDA: 84171638628.24.9078EEC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7918A40008
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:49:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EtDzoPQg;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cjUuHHa90Y5IKsfTWg529q3nhn1oVjrxX3eoFK3Exgc=;
	b=JCotVF5P8/bddimiG0D3/ZDy4EeYvs6Fw7izrb5CXnLRV+P5JbhGh9tkB+MmeaPF5TCRdJ
	5QYGwCRe5vTmlQ7xKLJb5TmAuF/i6bGPfJa0ycQ9BVVK/flRrhX5ELDvXddowCNOZ9tfjh
	a06MDuznLZkXwdOS4CCKgsrqi0whi7M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EtDzoPQg;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764611352; a=rsa-sha256;
	cv=none;
	b=W2g29a4XyzcQhfCVzbCBOEf5HcULJahLkiwoGPub4XiO0uvWf3VKXdRCOX42rYG6kaur2p
	vY0DakfBwjfmuGi8Gc+GDPq8yLTKPpTzxtFZiXrJQIAq++pKUVs7kw/JYIxNG1KptG+uiY
	6IMvco+0bpTuw6frDxUQgLFL+4xmexg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764611351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cjUuHHa90Y5IKsfTWg529q3nhn1oVjrxX3eoFK3Exgc=;
	b=EtDzoPQgzGd3qyoqhePf+LAJlHRLLX4g3EyNV2aW/m9XOpmsYu8mNoYConDq463DlHKV3C
	2hDuVdzfhUMTXpom+zRwWHwusqCIl45PVFrOEaN30Cci6jPceqIEBrNZ71Kz1bPSpRWozw
	WFy9mPdlKD0B/qvT8A6ykfrNetaCkdw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-eOTyu6xXPtyHIzairCYkZw-1; Mon,
 01 Dec 2025 12:49:09 -0500
X-MC-Unique: eOTyu6xXPtyHIzairCYkZw-1
X-Mimecast-MFC-AGG-ID: eOTyu6xXPtyHIzairCYkZw_1764611345
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E00921955F3B;
	Mon,  1 Dec 2025 17:49:04 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.66.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0D1F1180047F;
	Mon,  1 Dec 2025 17:48:54 +0000 (UTC)
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
Subject: [PATCH v13 mm-new 10/16] khugepaged: add per-order mTHP collapse failure statistics
Date: Mon,  1 Dec 2025 10:46:21 -0700
Message-ID: <20251201174627.23295-11-npache@redhat.com>
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
References: <20251201174627.23295-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7918A40008
X-Stat-Signature: gtrateoku1xfhysesm3dwi3159yaom51
X-HE-Tag: 1764611352-461070
X-HE-Meta: U2FsdGVkX184SvbUMqH5tYHPw9KJIU1hMC/nA+U6xEDScHeSb2yN5jbQ+y/q7OMg6OZjMdRXwLVJ55qsMaVyFO7rZrOjJn5JvT0L7jgS5Q+Xn2ongLyeaGKRcL+6IzerNdmqISNc2kSr3MjFV1C11127QNXrDiRKf8hyzCjZETv4IAWNLqFYhEegZf5tfbaZ3UaLcklD9tBquV0rnRyFsKmgCqI4ZCeVR3T1RvXZ8JdooCDw02IoJc55Fne1FvGodyANFVTOz+BgGjD2tO9MOgJNjRmT6lDQUmeRgFoTf5FIdQuGjq4yM38wpaVZ/taEt8c6epnGeBkFurvzdhygG8zi5sgEllNospvLLPtygAAIBQI+Z3je/NUC5iEaQ9DIkCqGaE3iMMAn59AencPwNvVc5kNr12TSQkm7hKjsZWkwaiCE9qA7c+mGPi821jr1uK/W67mhYaAIBop7ivST4KrFqGIlaBSPrYED1xucmMVkAFm8d6oEC9W3rqi/VgTNRihyoioTiqXfUffahC2XYNIbtqwkbcIY4d1niK0bSTNmHEYG+hMlScMM0UDFe5SIZmrqYYnzvfKueMS1j1ejWBUvwhLu2EqNcovYISv46Rt0pqubWjcOsh7tXKn65gZlzrGNXEzNLmP4aPuV+E7dhPSiOG1a/mXdhgbGjQYaqT+cuSuHlbn8J3W285EH7GJb6hjZ09aH1rFgOnTeQJTigXc/iDpYX7dyqIIbtHx2+t7lDAsTygtSd8xMZUCnZAzcrpczsusn1o5rY6i3c4HmdYmHfYTs5np9kuB5OeXz6M1zo9ATkC+VP04/5Lhc1JK2lsIuZCUlswO0b3MjWGPLxB7JSztyvsuts5MqMMHZwj94+WvfRA7D0mFK5xhzyEi36Rhe8JFn3CqiiuefWHgMoU7K5lxPPVz27FUKIjuWepabx9UyXrLcVBiydHe43/Jy1vO0b9xDx21QAbbOkQ7
 BVqbXwjB
 eWB0rbREbgbDrslHf+VInoSlGwvinZ1EbhZLhHLrRVno0oRFONjjzI/1gGAQ8ji59qMM6gWPgJTWGI8dzJqor79P0lgi8EZyO5XwPfmbqltmYyQnuo+Mu1jf+cB0eEO2kjaveVuDmq+yKxZBDcLNrE27seJeIZ/VyFDQiZpasypSPXN1W53WgKcqZp9RpUy/IB0IuoaC2KmBLYOjA+wvlbyyNyBo2vzvLE7X7NX7C0x0PjEuBbRoMmE+udIZck7FdZ95PQokXVIjjzaekUxjFEZFEGYY2396cK4ukMBAt89CGS8k+qsoYKzKGJohxbOJNn1HP/zWAYT1+OVHRd4esgAIwZSxz5tCSSklngxFp/FkuzENbe7eT5zRQD+duRPVV/MY5tGkykSsCZro=
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
 Documentation/admin-guide/mm/transhuge.rst | 24 ++++++++++++++++++++++
 include/linux/huge_mm.h                    |  3 +++
 mm/huge_memory.c                           |  7 +++++++
 mm/khugepaged.c                            | 16 ++++++++++++---
 4 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index c51932e6275d..d396d1bfb274 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -714,6 +714,30 @@ nr_anon_partially_mapped
        an anonymous THP as "partially mapped" and count it here, even though it
        is not actually partially mapped anymore.
 
+collapse_exceed_none_pte
+       The number of collapse attempts that failed due to exceeding the
+       max_ptes_none threshold. For mTHP collapse, Currently only max_ptes_none
+       values of 0 and (HPAGE_PMD_NR - 1) are supported. Any other value will
+       emit a warning and no mTHP collapse will be attempted. khugepaged will
+       try to collapse to the largest enabled (m)THP size, if it fails, it will
+       try the next lower enabled mTHP size. This counter records the number of
+       times a collapse attempt was skipped for exceeding the max_ptes_none
+       threshold, and khugepaged will move on to the next available mTHP size.
+
+collapse_exceed_swap_pte
+       The number of anonymous mTHP pte ranges which were unable to collapse due
+       to containing at least one swap PTE. Currently khugepaged does not
+       support collapsing mTHP regions that contain a swap PTE. This counter can
+       be used to monitor the number of khugepaged mTHP collapses that failed
+       due to the presence of a swap PTE.
+
+collapse_exceed_shared_pte
+       The number of anonymous mTHP pte ranges which were unable to collapse due
+       to containing at least one shared PTE. Currently khugepaged does not
+       support collapsing mTHP pte ranges that contain a shared PTE. This
+       counter can be used to monitor the number of khugepaged mTHP collapses
+       that failed due to the presence of a shared PTE.
+
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
 huge page for use. There are some counters in ``/proc/vmstat`` to help
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index f93365e182b4..1082b78e794d 100644
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
index c1e1e91b0e61..b4d9b3ac9a7c 100644
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
index b2ea56c9bb42..efb8a47af65a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -604,7 +604,9 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				if (!is_mthp_order(order))
+					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out;
 			}
 		}
@@ -634,10 +636,17 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			 * shared may cause a future higher order collapse on a
 			 * rescan of the same range.
 			 */
-			if (is_mthp_order(order) || (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared)) {
+			if (is_mthp_order(order)) {
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
@@ -1086,6 +1095,7 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 		 * range.
 		 */
 		if (is_mthp_order(order)) {
+			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 			pte_unmap(pte);
 			mmap_read_unlock(mm);
 			result = SCAN_EXCEED_SWAP_PTE;
-- 
2.51.1


