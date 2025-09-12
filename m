Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3714CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C058E000B; Thu, 11 Sep 2025 23:31:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263D28E0001; Thu, 11 Sep 2025 23:31:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12C038E000B; Thu, 11 Sep 2025 23:31:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2AAF8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:30:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C1C7F86D51
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:30:59 +0000 (UTC)
X-FDA: 83879171838.15.FFAA7E3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 08CB9180004
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:30:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bw1GDi97;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757647858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4sAUP2U7MWVtynazKGYhR7cq+RzRKWoz39ZZu9Fjrk0=;
	b=HnzjBXc0iTQduhS4PuXcJccJ4BT+WMQjoazMABqLG5xa1pXNkOzho2Xbcigsadt8eM88N6
	/mjauTUO2w5Xgtc9e8jhH7334zkg7j/BYCOSMnLKUfyrs0Sceq5YgAg7NHaGd+ITazRCyz
	mJSPXH1JoOdZAbuGR6mcsALxdxiBMQo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bw1GDi97;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757647858; a=rsa-sha256;
	cv=none;
	b=ZeOU/Hcr6yGYPTY2nOfZG8ZsiJuD2o6SklTTMEATIuuUY9/fGwCEHdhtWZxUTQOnVEtqWI
	sORmgb3USVCBz1NTDyB+5rlQlesnaEjYFmmlaHF11wpboY97j9eZCOGDvRZTKOc1dQfeZC
	d98gURk8RnTe+gMpiVp4h/pVEB3FMhg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757647857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4sAUP2U7MWVtynazKGYhR7cq+RzRKWoz39ZZu9Fjrk0=;
	b=bw1GDi97prlvtCx+0bEDfk54s+hAPthdt5odcLbRrmT8S7MWe8StLYAURWUHhYV8hZ7gR+
	/4ZOyijXsko26WotLfaIfuMIq/VL0+fzfyH3tqWDxiBiDofNVAhRZmhsham3zzyT8jVpqA
	hwd58PlB9Z7v/cmoYgDm+RcsY2TGTp8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-599-zKvBvyLYNf-nURx5EBNA6w-1; Thu,
 11 Sep 2025 23:30:54 -0400
X-MC-Unique: zKvBvyLYNf-nURx5EBNA6w-1
X-Mimecast-MFC-AGG-ID: zKvBvyLYNf-nURx5EBNA6w_1757647849
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 88BD51800289;
	Fri, 12 Sep 2025 03:30:49 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F1C351800452;
	Fri, 12 Sep 2025 03:30:39 +0000 (UTC)
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
Subject: [PATCH v11 09/15] khugepaged: add per-order mTHP collapse failure statistics
Date: Thu, 11 Sep 2025 21:28:04 -0600
Message-ID: <20250912032810.197475-10-npache@redhat.com>
In-Reply-To: <20250912032810.197475-1-npache@redhat.com>
References: <20250912032810.197475-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 08CB9180004
X-Stat-Signature: 114gfc6bihymxtpuox3o3w9w4zyjgg3a
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757647857-197177
X-HE-Meta: U2FsdGVkX18KFhcyfhq6fhQ7p4AUsFeia4kQdRmpZroklvU81OcNBJbX2eklcFrIyfLjboaiB2aWeZRYCeZkDvRmsE9yMBdMZ1KN66nrO7JKAOS2aWsQONP9cVTJopDZZUUwPxIbSTgwZqbXDR3+HdLFjcegNs4/39opOck6mF920yhI01tF+Y2tuRZkBq4j4dPMwWtoJ/YPv6ZIkr7fzQfzhjGVX8TehjF/qo5Z2xsF25g2PR4fQVAU/hK6zR/i0GwdDXiqG90NogKJTdr+X28P9uMYoM8l/j93Klb7zKgWCQVgi2I8HTqi8aEk8VOs8tJAZfcodlengFbw0eualpBlAHUdXcD8zOH/1uGCbeT9kdNFkII2jY/HDlLKzK9/mynbd+ruYpbczDKB39GswEgd2FXDBdefNG1PUB55pI2Nl0bM3f2m2H1rjg4jfx7Uz6XFkruzcVn0ujYNQmqv971wTUu0qqNwsujPB6Bbqvv0M1WnIh4RSj0RU81NaU+XuQkP2NkxqqkmF/Hl+ZcsZqj4xzCnHBypT88fdMkCpnZG0+7BmdyM1pMLV7k+6pW3wuQIjWlh5r+t/RsKvwwP1eBAH5uAEjioKQfR4Dyg+1dU2e3BI+gWAWOVrSuGz3KBHP/D1ZYlNoMevmQzDKHmK5atYXcHOsD2OQhyfVCw52uAQi8GutnscbQ07dmpUl5r8RABy6V9IdquCB3/Ew4nJ96iUKrzOfG6rRGVq93Xap7WOfrGw4spk4Ka8zECjxIozbG9uXjfqKI/Q8cOmHWjFt9MfP1r5+aQ+Se5vJbf0kwAQ7yRsmL3+ayF+xQMYyzzw+/+I8ATKtXzOwxfdTW4voiauqivr6ed15y0GYbJDx+oHpuVpcOLHIrHvygEz3JNUaQY3lI9/3OC9pkHhnLNXe8Kyihy1P9AKXfC5Y8U+jh1Wn2MmlIjLm+zsGxjTgwkmpbPIzL/WRqrWf0fizb
 gF0zYVj4
 DikhowxkZn9Qcnfj9zcR4s5BfYTEQafS+nV5CyzWfnZwJw1/XtdG5Uf9CqJw0mbj/nt+wTuUwMMbCKSDclUx7l0P/2Y/bZWmcDJgf8o4LKjdJk1YNYuksathDyine1eP8Q2IEwRZZIEViMtQWv3JJQ4Tsc4HNbtZQRUB/dpPXIHNrlqGLCEjLxCF2JKM7MNlX3LoIDVUeihqwtimAVujURYD4sgGD6WgFmAnQNjiAWf53H7Xj2WbL0YGk1zmHMugpB5Pm8XUj7u5hy3A1ipbe/kSDBeOwVeDTp/46OkILqvRFWBdJu8DNIMimwsoAfgflJEwP0oc1KxiuPzCCUbwbm9kj10TUD+xkshRFGOA6hy9u7eJI6EXQniwqxhG/PXY82TNcVDWyKB/mnyNK4CUrIXJHig==
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
index d442f45bd458..990622c96c8b 100644
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
index 76509e3d845b..07ea9aafd64c 100644
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
index ebcc0c85a0d6..8abbe6e4317a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -589,7 +589,9 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -628,10 +630,17 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -1071,6 +1080,7 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 		 * range.
 		 */
 		if (order != HPAGE_PMD_ORDER) {
+			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 			pte_unmap(pte);
 			mmap_read_unlock(mm);
 			result = SCAN_EXCEED_SWAP_PTE;
-- 
2.51.0


