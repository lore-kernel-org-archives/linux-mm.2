Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ECACCD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 19:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6FDF6B0088; Mon, 11 May 2026 15:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B47776B008C; Mon, 11 May 2026 15:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5DDD6B0092; Mon, 11 May 2026 15:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9441A6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:01:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59198160251
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:01:02 +0000 (UTC)
X-FDA: 84756056364.02.927091A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2682910002B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:00:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RUDga3jM;
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778526060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8e2qzigC/xY2XpcjFQgEwoieIEMsFnLfRsrtEYNcvCA=;
	b=guT7lfYdCvdR/u2DEAlurBbNZ1PTHfPQDOQWzsrAlQp415rg6KbeZQCPP7FJKLvUII13J1
	Bxd1rGjOWyVi3lmTBoA87+gVVHbYBDUkjWmZadMUp0w/KNQfWambKssKmLG5x42OkRJp3r
	tmd4b40SfESLUMZiBLsULMFN/Q13Njw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778526060; a=rsa-sha256;
	cv=none;
	b=kOHoRagQILpNLlsC+0VpyXPGpbxX/dndEQMVXDk10r+kleF9gMnmy/Q5Eh3yPYcHk+JIWr
	IJ0eD7SbfMSnY6oHi+bcgCZO8TM+eBFTJrqcmr6kany5E34gS9wpeShodti8zRML38hacg
	QN1l+0fwYD/OZim140QhJpQYIW20zTE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RUDga3jM;
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778526059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8e2qzigC/xY2XpcjFQgEwoieIEMsFnLfRsrtEYNcvCA=;
	b=RUDga3jM+aTmwxPcqp1VwFpnb+uQFsvyXb4P2PdC+BC5l/ixUlE30cDu4Bo/YbJwFVWt8D
	mBv2Js9wwodkLxr11+8PDug5u/TQSNw6TowomWJDLIJEOZ/QIQf0ghxqkW/HQGS0pfPndM
	o+3gXdH881AQ52C96SHgNVC4Vjkymgc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-477-qssIB9RaMaiyi2YLa1DWfQ-1; Mon,
 11 May 2026 15:00:54 -0400
X-MC-Unique: qssIB9RaMaiyi2YLa1DWfQ-1
X-Mimecast-MFC-AGG-ID: qssIB9RaMaiyi2YLa1DWfQ_1778526049
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F3D0D1800617;
	Mon, 11 May 2026 19:00:48 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DF68A3002D30;
	Mon, 11 May 2026 19:00:28 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: [PATCH mm-unstable v17 08/14] mm/khugepaged: add per-order mTHP collapse failure statistics
Date: Mon, 11 May 2026 12:58:08 -0600
Message-ID: <20260511185817.686831-9-npache@redhat.com>
In-Reply-To: <20260511185817.686831-1-npache@redhat.com>
References: <20260511185817.686831-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nUxNn3GRM_SGd8TdWkWFhUd7JWTbJDnFnAN9TbvAMY4_1778526049
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2682910002B
X-Stat-Signature: 6kexkxgoiqrc6j1ngnsjh43wbtdgxd6t
X-Rspam-User: 
X-HE-Tag: 1778526059-560278
X-HE-Meta: U2FsdGVkX19uQt7Avdf11Dz8+7VtgLbiGLrDlkzXoDWD6cDCAK+OJeGsLSYg+vesSGJYuUMfMuYBdQ8KHinBzJEE+saL7YClCN0mKjAOtUzd31vJvjWkO5oR6+1WeKimiZGEX/zEnUkFS8IsNx04WrT2luZUE068/nsme8RdAiegvaygjCcwk00cKdYGfFdqB5vsNibVnK+By4a6jNwC+ccwcaV1o89mg97zAcCCMWuF+JClT3CBZ9SgviMvd5smQUUjmCBoU6hQ0YTUKKhjmQkVD+EyY4eMnFt5X4ACRQniyhyZ27a8sD7uEsNrq6oIeZSgFGS8SbaRuV4p3XN8Rg6B+uHt7fGZ7tpO7aniF6YANCApy+qll8pG76dKlsQNV14pU8ip4JotqFlW84T0evPYbM3TPs0svV5xg8BgYLF8GzEmgXlXK1SjH77EGRLxfb5Jzs21CTALTitHDyXhFy0ae1q0eRlBozOb4CUoLGIN4O3MK3RBrN48bIVvpJAhnoy6M6ByeL2LXzjF0J4eWkuph2kfMP9h7y6bdBnotoh2fpTImy15GqMisHG28nnfFhHZfAEXV8Rr/XxrGNVgDkjEv5p77ZjgExIm5AyjcqeATBn7LVAY/WyOGCKsssHzKrDjnGXLcH3uaR0DiYvrP370KCdse8Jn5uMPaTHV7lSUbkj2G1GESeIZ9uygeJUvF/qZa6F8TjF7Af748PgriwnSDv/VcQAqK2URil8fK70Ti71kfTj/lsQObmrqGXWKTLXQMXNdiyCCfctYmodwsOa6UKpURJQPBPCJyDrGjH9AbIIvMXfOsRg0Ysw2lZ0i13XyaNka9BlJ3a1Diljj5oetCIVL+bQFaR4LfAOPtZKnqpGxoMivs3lr3bOjIfV4wBRXIoovnJLaK1D4swZbY+a3ONqCns/uXtZytuPLgtY4Py0xLrbiA/RLgugczhiX0AajEeIUl/Ip8Oaw/F7
 OHVIQOKu
 5/qd+2He7eMehJCe0dIWXJACT7bfwEBj769II2aQ3J51MqgwLn2kpM6A3anPZlcAUZITZhjCN3RBnW696nTXv6CG0x64g2kJiEulxUgrznAY3g2DCPEYf4wM6fT/+8N411kLBNi61iFQ8Y39DIoJfNZYCabgcxQpKKCWK98vDjVcZ8Kr9FGHKe+f9n2no1fCipKbziUFfe8EbjvtUEhEGjurUcbc+U04j/294SFKKH6b7hcDSGQBZszaMeQdVaZqZ8rQ12vXOTZD72lxw431htmL97P65P0nas48YN7KWIJT+z7YjxDgA2sw1g4Me5oFkHnVGGivxIVebHJ+gIOqA6sd1s3v4UFmK3eulNdNMu4xR/yhAWy41bwBaGxgJZ7aPNpx7qPu3z+PiugWQAcsdTa8WgGiIAc5AZqcY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add three new mTHP statistics to track collapse failures for different
orders when encountering swap PTEs, excessive none PTEs, and shared PTEs:

- collapse_exceed_swap_pte: Increment when mTHP collapse fails due to
	encountering a swap PTE.

- collapse_exceed_none_pte: Counts when mTHP collapse fails due to
  	exceeding the none PTE threshold for the given order

- collapse_exceed_shared_pte: Counts when mTHP collapse fails due to
	encountering a shared PTE.

These statistics complement the existing THP_SCAN_EXCEED_* events by
providing per-order granularity for mTHP collapse attempts. The stats are
exposed via sysfs under
`/sys/kernel/mm/transparent_hugepage/hugepages-*/stats/` for each
supported hugepage size.

As we currently do not support collapsing mTHPs that contain a swap or
shared entry, those statistics keep track of how often we are
encountering failed mTHP collapses due to these restrictions.

We will add support for mTHP collapse for anonymous pages next; lets also
track when this happens at the PMD level within the per-mTHP stats.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 14 ++++++++++++++
 include/linux/huge_mm.h                    |  3 +++
 mm/huge_memory.c                           |  7 +++++++
 mm/khugepaged.c                            | 21 +++++++++++++++++++--
 4 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index c51932e6275d..80a4d0bed70b 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -714,6 +714,20 @@ nr_anon_partially_mapped
        an anonymous THP as "partially mapped" and count it here, even though it
        is not actually partially mapped anymore.
 
+collapse_exceed_none_pte
+       The number of collapse attempts that failed due to exceeding the
+       max_ptes_none threshold.
+
+collapse_exceed_swap_pte
+       The number of collapse attempts that failed due to exceeding the
+       max_ptes_swap threshold. For non-PMD orders this occurs if a mTHP range
+       contains at least one swap PTE.
+
+collapse_exceed_shared_pte
+       The number of collapse attempts that failed due to exceeding the
+       max_ptes_shared threshold. For non-PMD orders this occurs if a mTHP range
+       contains at least one shared PTE.
+
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
 huge page for use. There are some counters in ``/proc/vmstat`` to help
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index ba7ae6808544..48496f09909b 100644
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
index 05f482a72a89..3e9eabc74c6c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -717,6 +717,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
 DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
 DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
 DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEED_NONE);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+
 
 static struct attribute *anon_stats_attrs[] = {
 	&anon_fault_alloc_attr.attr,
@@ -733,6 +737,9 @@ static struct attribute *anon_stats_attrs[] = {
 	&split_deferred_attr.attr,
 	&nr_anon_attr.attr,
 	&nr_anon_partially_mapped_attr.attr,
+	&collapse_exceed_swap_pte_attr.attr,
+	&collapse_exceed_none_pte_attr.attr,
+	&collapse_exceed_shared_pte_attr.attr,
 	NULL,
 };
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ba21b134fc86..27654ea3f5ca 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -645,7 +645,9 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		if (pte_none_or_zero(pteval)) {
 			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				if (is_pmd_order(order))
+					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out;
 			}
 			continue;
@@ -679,9 +681,17 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 
 		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
+			/*
+			 * TODO: Support shared pages without leading to further
+			 * mTHP collapses. Currently bringing in new pages via
+			 * shared may cause a future higher order collapse on a
+			 * rescan of the same range.
+			 */
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				if (is_pmd_order(order))
+					count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out;
 			}
 		}
@@ -1130,6 +1140,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 		 * range.
 		 */
 		if (!is_pmd_order(order)) {
+			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 			pte_unmap(pte);
 			mmap_read_unlock(mm);
 			result = SCAN_EXCEED_SWAP_PTE;
@@ -1426,6 +1437,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
 				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out_unmap;
 			}
 			continue;
@@ -1434,6 +1447,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			if (++unmapped > max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 				goto out_unmap;
 			}
 			/*
@@ -1491,6 +1506,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out_unmap;
 			}
 		}
-- 
2.54.0


