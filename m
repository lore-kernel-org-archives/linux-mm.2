Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FE10D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601856B0332; Thu, 22 Jan 2026 14:31:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 580486B0334; Thu, 22 Jan 2026 14:31:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E636B0335; Thu, 22 Jan 2026 14:31:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 23C726B0332
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:31:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB62A8C58C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:31:53 +0000 (UTC)
X-FDA: 84360594906.18.8F0628E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id DC167180009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:31:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bSC5BHyo;
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vnTtNcQqLnyAtCjmCaSMz8Sgg0jhE6UAUhgK77mSITg=;
	b=euJ5ZVVpzl/Goxppbico0wU3IyCxLXlinIXQWDhXtbB2+ZitND9U7YlwJe+Cw04AqwnjbL
	FDLFuS+Bz2fK6zRNwCQIQR7mnmzWsDDr/I6N9YiZF7kSL0qB5Y+nryVGk4lMCpF6tIPFd3
	NZZOZwvl4wyTuoAFckSBD7K60vSZEP0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bSC5BHyo;
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769110312; a=rsa-sha256;
	cv=none;
	b=wo87OaJK//fPq8p9gC1gexcRNwCcYe5FZs8rGFRWNYj/zI7M2Yc6OvTF+5p/bo/HGPuQjo
	+jPKmYNZnTG4h+R8THgfeoUxUIM+VNJPkJDuF5bVZU5M+2wGswlMyLAlCtsAcg30B+lQ43
	taWyswLWDgYS5qBgfjskDG0IE7TpWpc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769110311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vnTtNcQqLnyAtCjmCaSMz8Sgg0jhE6UAUhgK77mSITg=;
	b=bSC5BHyoLn1cY/GcEpSVpTcE+ItSUcDfaVpc+jjffQ7QmTgqpEJjLj7txxwvn9Mq+y94qT
	Br4hp7uZQvc3QVII/nvdlJYgBk7mZjPOMoHZgKpLWZvANpXWVL2BgzbqrU4Y5YgLRuqaW9
	/xKFnboumt3026om2ve1SQpjgCya3/4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-97-Eu2iOd3WOAe8vDZNYZmopg-1; Thu,
 22 Jan 2026 14:31:47 -0500
X-MC-Unique: Eu2iOd3WOAe8vDZNYZmopg-1
X-Mimecast-MFC-AGG-ID: Eu2iOd3WOAe8vDZNYZmopg_1769110301
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9EB1718005B7;
	Thu, 22 Jan 2026 19:31:41 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.88.59])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 44AFF1958DC6;
	Thu, 22 Jan 2026 19:31:32 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: npache@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
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
	zokeefe@google.com,
	rientjes@google.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com
Subject: [PATCH mm-unstable v14 10/16] khugepaged: add per-order mTHP collapse failure statistics
Date: Thu, 22 Jan 2026 12:28:35 -0700
Message-ID: <20260122192841.128719-11-npache@redhat.com>
In-Reply-To: <20260122192841.128719-1-npache@redhat.com>
References: <20260122192841.128719-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oeuRgR9PAoOF54fPPoAgEOtDDxWZsJU2KocyM-sfLws_1769110301
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DC167180009
X-Stat-Signature: 553p4awbbdda1ykztpyhj8wxjzb48qki
X-Rspam-User: 
X-HE-Tag: 1769110311-75065
X-HE-Meta: U2FsdGVkX18DMRxyN0eTJcwdoW8tYrf/per5H8TbsvAn+J4qOP3O8IjFK0XXiO51UKN9p9JCmwC0ypQcrvTi7AXogIWgTF0g6QQlBkkxb+52kApfTix7e0H42F+URx3hGZB5uEG+sYv+VsaXrlXrhr550eVPANum+YjUdeHT6j5uAmTRo1zGugBR1GSgDL8lG/5NBuLEALS5CL1T5t87O+mgkFlq337U//khpekRnBwECj/76MWuTxTXDbSUkgp1ZRe5LTTXMsP2jS1/VhHYgnLym6cuC/2iTw1ErllW1bB5x4FQ/3q9RcKjGivr75QB9wE/WZ2Q+gy8Tcn13Hl9p3h+gEO4huKDjSkidoMPec3zsephoRp6vyyIesCgospcl+FV0ZoJ5HYrh2KtdtUCHG/hGi0As5UOVBwUrTWINnhnQv/EjWxIOkJLT8MMGTlfjkjk4dHHcPoaN1sVVOMgKCefBNPqzk1/MOtvCLlhG1vzR9tWxKD/gM3Ng/pnGkQfQQ8Too+Y9ELkSD0rc0rvNUzqFAvnO/NDeEsE7qvv2KG8MMbv7U6XLs6nY0zTRh1zuhwLiEnNeQ1dnP1nKZaqeLFpIP8u9YRKVxYGSWI5DVDCuFSqtx17ZHibeydITRK1s+oEaA6L0CurAOZZa57nm1xmIEptEXpayy65FUNb7QwQa5MOBCFPBH85+GrBSCwtv6piG1Hv4ljq0h6Pmf9VRtvNkt/t/pfRd0O9ltlSK3O60nNHvsVnsWYSGoUD4l3IYb8roeuBnI2Xx8yYHQy+pOhftSvQIpKBfF6zuYxs7NDRfJgCYP4jcDwg2pzz9dSQtKnUm9fErcV/7po2SBCJNn7skyrN76Pz3NqddZhqPkUWgQTc9Ekbvkvj9TMjJFOCF+8DWAdiEFSfTpp1hhYXCuAxaPj/HEWanyW4J1OcMjkpNa3vVM0q71mEFK4AVlmiKIwqOQfwY4TmjCNPGBX
 3AJHKXca
 fcNV94y7Qt2iF9+fPWKyHzGEdpFewrKU4UW63ikDDzBoDsNB/JILYi4Ly6UHmlAEt2vBfZmxftn4F6t2QsB8iCSAM9fOSEJ88tByMRTCV3LeVPkEf2Xo82EFtEwnzaVmhdxOQ+tAvMUQoM3ipIuj3PC9BJy2Pn/iNuhb2Jfzs6AV7x8nI2z4Ky3lo1GA4pVyUB13AlT/RTtzSijhpHudK/TJQxjQ0os/y+5pdM9Q74Mt42WFHQuxUF5VF0vvcLFW4rBhGP5cQ58jePuK6otGpm25xJhgxBVXBmjSlb/Kekpm+KG41ZMRS0aNU7K9kUunHncmurklnPkVDOuV7h3uGP5QXOgR6hlRzVu/5rMa3rPO7gRKXEp/NQ9fINs7uPZcG+r8gpR4L1iWEAzJlDEdt8oWvNen1MQWMbUidG0/2TPbh/NHruvnnfvr0eA==
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
index c51932e6275d..eebb1f6bbc6c 100644
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
+       try to collapse to the largest enabled (m)THP size; if it fails, it will
+       try the next lower enabled mTHP size. This counter records the number of
+       times a collapse attempt was skipped for exceeding the max_ptes_none
+       threshold, and khugepaged will move on to the next available mTHP size.
+
+collapse_exceed_swap_pte
+       The number of anonymous mTHP PTE ranges which were unable to collapse due
+       to containing at least one swap PTE. Currently khugepaged does not
+       support collapsing mTHP regions that contain a swap PTE. This counter can
+       be used to monitor the number of khugepaged mTHP collapses that failed
+       due to the presence of a swap PTE.
+
+collapse_exceed_shared_pte
+       The number of anonymous mTHP PTE ranges which were unable to collapse due
+       to containing at least one shared PTE. Currently khugepaged does not
+       support collapsing mTHP PTE ranges that contain a shared PTE. This
+       counter can be used to monitor the number of khugepaged mTHP collapses
+       that failed due to the presence of a shared PTE.
+
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
 huge page for use. There are some counters in ``/proc/vmstat`` to help
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 9941fc6d7bd8..e8777bb2347d 100644
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
index 00fc92062d70..7c0b072fc6b2 100644
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
index 8bb70e1401ad..96f1c28646ba 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -602,7 +602,9 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				if (is_pmd_order(order))
+					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out;
 			}
 		}
@@ -632,10 +634,17 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			 * shared may cause a future higher order collapse on a
 			 * rescan of the same range.
 			 */
-			if (!is_pmd_order(order) || (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared)) {
+			if (!is_pmd_order(order)) {
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
@@ -1082,6 +1091,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 		 * range.
 		 */
 		if (!is_pmd_order(order)) {
+			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 			pte_unmap(pte);
 			mmap_read_unlock(mm);
 			result = SCAN_EXCEED_SWAP_PTE;
-- 
2.52.0


