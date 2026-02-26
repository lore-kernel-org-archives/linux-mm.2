Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31E57FD45F9
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87B046B0099; Wed, 25 Feb 2026 22:25:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 852E26B009B; Wed, 25 Feb 2026 22:25:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 751CC6B009D; Wed, 25 Feb 2026 22:25:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F1A76B0099
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:25:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1DA595B2BF
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:25:30 +0000 (UTC)
X-FDA: 84485167620.14.1E5BEDC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 31988140008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:25:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BT9EhksL;
	spf=pass (imf23.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772076328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SfLd/jOL4Vy+mfYtaQJ5il7IpnC0cI4WljhJzL3cpIg=;
	b=7rlwEnFx1OocjwHmfmyd069YgDqMEF6YncjIFTQE0/HQVlvhP5ZnY+qYPnmENtptVMc0MX
	5K8Mhuhau8Ysfnwqqx93MXBWqwDfyEadc681gz+mgYtEqWOjAesqfp0S9GsBiXTO1vnTHf
	nLO5Ig9jO3GKE/1aZs0ER37LGkHf8Pc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BT9EhksL;
	spf=pass (imf23.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772076328; a=rsa-sha256;
	cv=none;
	b=amhWu1CwrBVJR0k09DGh3wtUoENsHR+FgJOSu95do62saigD5w/vT9JxayTNpHEYG+lU3e
	hJPTKmXPOqcFQ9esjyghuZww1EG9vCHp05LxNBUYy68h0iwkMAj2FNrRxD5csI3Abe7Lra
	saompA4uPTEpxyBWWdGE+Cg5OzGY/CI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772076327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SfLd/jOL4Vy+mfYtaQJ5il7IpnC0cI4WljhJzL3cpIg=;
	b=BT9EhksLj237WDwPQbsp/NKZy0B1tup4AsqH+6/M7FcaRYlcn4K3tULej+qP39JIfw++P1
	48DKuPLZhGTZZvJlFHU3O3Sx8fBO7AXdL/sH+staUN16q+33nCtz2jIQa7IVmsky/W/3Oh
	iafb/vMSoyILqgzx2uQmGeMPRIornTQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-606-9dMps7mAOgO9yrk7axfpBQ-1; Wed,
 25 Feb 2026 22:25:22 -0500
X-MC-Unique: 9dMps7mAOgO9yrk7axfpBQ-1
X-Mimecast-MFC-AGG-ID: 9dMps7mAOgO9yrk7axfpBQ_1772076316
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41DD51800367;
	Thu, 26 Feb 2026 03:25:16 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 983A73003D88;
	Thu, 26 Feb 2026 03:25:06 +0000 (UTC)
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
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
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
Subject: [PATCH mm-unstable v15 07/13] mm/khugepaged: add per-order mTHP collapse failure statistics
Date: Wed, 25 Feb 2026 20:25:04 -0700
Message-ID: <20260226032504.233594-1-npache@redhat.com>
In-Reply-To: <20260226031741.230674-1-npache@redhat.com>
References: <20260226031741.230674-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dOc6dvWIj9RemjiAJDmO8ubYbOEYC8IzLnF3Ug18Kvs_1772076316
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 31988140008
X-Stat-Signature: dnbqqratz5fdp5nxndxqj7jc9n1e1qc5
X-HE-Tag: 1772076328-247906
X-HE-Meta: U2FsdGVkX19y6tx/uwGNI1VqEvL4uuSxmP+aIWK6xKfZHCtqfJkKG/63bnY4uw3VsKCmkcQr5SD9mnqPQmhiAq/hkxGmitWrhflwUYkDWMKur2WfBAXsVcOaZuZbiqRPfbL+jVwH3BzgLwO92jiS6Tic39grc/gZZIs4KqHS7q6Yq3lDL0rHyrqcMTPSka7nShdymKct1IFQu1Isf3QYkFGR7HmA5jFDMbGngrw3LNnSOVwc4CFisusuarksBW/vf6F+mNmezEu08iaPsiOjC3/GY4z1qum+mAGQKWFmVD68OfxDwx+DbZye18VuIiyxk2mOwng/TxXwBwM4+3TPRbMAWiPpPXDoIE3T49T9ype6BcqkSB7jXtx46w4g4XWVf1PykN4pZKUG26S07mQuYvDhSHEnvxCs2yjKkejABWHMDpvWzP+294GUO1GSc8tBJ4XcPRpakdBxyRfFBeOcr290B/4n6xVscLTIr8dwMxDl8G/P4scVnyJdd0lrQVmorIlTCPONmQ1gQKxj4V6PBPD4s9hDVGpQA2hr1BS7Y/mzpD73fZkoKvH9dYFwaY2uqdg7rpskXZrku4QYA5r0/Mwkkol9ka4/HtABJcAUsExstnnecn4ixdsdj4Q5SVpTN0h2s0GvaPoTIR6MKb4Q8XIyjZ9iHVhqzmCSh4fzW1GGsmFPLGTgqYk3u8kV2f6z/Y656Cnu8a2vB8KJu+Or231+L26e49hcjCP/Xx5vfEnETMO+kRlZApOut+hg+ftEurnvLtMQPrUtkKSN4Ou6vYqGjBL/oCUsjgqCT42VUyw5MMres3yeLE/s5QiTrsWoZFjG8lzOyaAdsmLTMct1Jn5rnKU8YN8ynwgtcUCdMER2cl4LDRMMxsIUdzFq9uCfq35515HASW1sYGcPuzWs8X42Fj/rJioGHaKPTPBo9XvdFVNsxN4mIj3UcDmgtenBt9Yqyag2GnC8/SMjla3
 DpPzRxo/
 DAmgUEBRhEf2ULl9IP8MxMGmMR7njOlN9ZsiUrVEO1U+S+ILhxNVvxmMtWs5l0eTcmsMV1sK8ehxfzi8XwcOLVohZxd0rUF19erSV4uuXZuqYDOWTtgnxvOstaWjBnb15HHqRS9slqToCTcQz0JFdkVN9/oU2Q81fgOxZfNsJBlke4UDSrU+gkNWlP/pOG+kXktnrwnhtkotfA8eUKwQgjB3q3GEIpvkYv+xQFnTXlw+xd4E2ZHIxisSGBa3f/UdP2sE6HkD8+SnqKYgQmaaqGyLpk8f6y0luvqaXPfHJvpSQ0RgtSmdIu1WsZpZFx8eju+cQ/mdP6ApTd8abYuDtPxHUgv/OkxrFUqdxGlbuad1dldktkLhP4h1+kT9XHf3Wo6aCA9voG26uj6mV2N+ASuELdSw9HWZkL0x/9V/GVab0BJG2+HvOkXQz5w==
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
index 228f35e962b9..1049a207a257 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -642,6 +642,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
 DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
 DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
 DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEED_NONE);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+
 
 static struct attribute *anon_stats_attrs[] = {
 	&anon_fault_alloc_attr.attr,
@@ -658,6 +662,9 @@ static struct attribute *anon_stats_attrs[] = {
 	&split_deferred_attr.attr,
 	&nr_anon_attr.attr,
 	&nr_anon_partially_mapped_attr.attr,
+	&collapse_exceed_swap_pte_attr.attr,
+	&collapse_exceed_none_pte_attr.attr,
+	&collapse_exceed_shared_pte_attr.attr,
 	NULL,
 };
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index c739f26dd61e..a6cf90e09e4a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -595,7 +595,9 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -631,10 +633,17 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -1081,6 +1090,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 		 * range.
 		 */
 		if (!is_pmd_order(order)) {
+			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 			pte_unmap(pte);
 			mmap_read_unlock(mm);
 			result = SCAN_EXCEED_SWAP_PTE;
-- 
2.53.0


