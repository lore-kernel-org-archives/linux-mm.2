Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3EC2FF885A
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 05:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1835F6B0093; Fri,  1 May 2026 01:56:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15AEF6B0095; Fri,  1 May 2026 01:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 098126B0096; Fri,  1 May 2026 01:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F24D66B0093
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:56:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 890AA1A06FE
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:56:23 +0000 (UTC)
X-FDA: 84717791046.08.C7AAD21
Received: from outbound.ms.icloud.com (p-west3-cluster6-host3-snip4-9.eps.apple.com [57.103.75.12])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5D5ECA0008
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:56:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=uUSHoXHu;
	spf=pass (imf15.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.75.12 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777614981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTc75O6iqIlRbMB1yKe5C3Mh2lstCHeNt4Mg/bpL3vw=;
	b=kdPLSjwG1qCXa0gFLsS+4RzMycZx68niGFcMQewP0poOCODHNUpwy5O18YWbT5GiPhs716
	XDrv6xxCgPXWU8luVSXCohbpjse4xf/CRciivlM5I+HKtlBJvhVqfz13QxEwEyDrn9ESS7
	jgOsKO2Qj5EDNjKwaaMVuoUvLO6D/j8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777614981; a=rsa-sha256;
	cv=none;
	b=KTPlJZLuptPLHws7vHIC9/en49AwwDovv/DsHxRCdJ5xfDoVSgHEFG1JJzk5Ld7FcPy4i1
	bQQzF7eCs4OQGXY7qfCuEpn7EykjMKgEA682G/eqWYrND5aXLfSMxx7vYR1PeaNOyS0+rf
	SUaNtpPkBuJ+0l0IuI8KUivteMzoXBM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=uUSHoXHu;
	spf=pass (imf15.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.75.12 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-8 (Postfix) with ESMTPS id 25775180013C;
	Fri, 01 May 2026 05:56:19 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhAA0MFWgFeAUEdXwFLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEFEYGVg1dE0wLcwRUB10FXVZQAlpLQBMESgZNXw5eHwQXRhlVBEceXVZeHhkCURxWDVdDVARfUEkMQVBsWgBHF0gdXRlZb1BdHA4EVAddBV1WUAJaS18ZXUUPXwdZBEAMSAJAQwNCL1oXREBBWh9EFEgDWARcBUQBSwReDytGFVcbVgNDRVEfVEYTGU4bV01QG18CQg8=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1777614980; x=1780206980; bh=NTc75O6iqIlRbMB1yKe5C3Mh2lstCHeNt4Mg/bpL3vw=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=uUSHoXHuJYBtBBLMFZ0mT71iSIQKAlT7OmyDAPpC/9pqXS5wGxAOnZTs5MWruPL/XTsLH88XtoXc4ypeefbWSKFEe9Gm4zQorK851OQ7FIJvKdEyEpuMT3L4hwa3hPpX2HmskD9Y38c43h3g+OVPQPlV55Bdlmil2r8eXpkWiTnQmGZCU0/IEe5U+BEch0IELcyIDlHF++IJfeitK+C0g0SiuI7um4MqcovRuqsZt7kkEU3Oct8fWofpbw+O1D0rnvgD7cm1RGaHk7oQ3CwCZxt7P3/RC+9/piZvQe5WNbP0dti3hYWOOfg5epZ6pQmcJYk68nGsrEcYhNuR55D9Xw==
Received: from [127.0.0.1] (unknown [17.57.154.37])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-8 (Postfix) with ESMTPSA id 95CF7180013B;
	Fri, 01 May 2026 05:56:13 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Date: Fri, 01 May 2026 13:55:45 +0800
Subject: [PATCH 4/5] mm: enable map_anon_folio_pmd_nopf to handle unshare
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260501-thp_cow-v1-4-005377483738@tencent.com>
References: <20260501-thp_cow-v1-0-005377483738@tencent.com>
In-Reply-To: <20260501-thp_cow-v1-0-005377483738@tencent.com>
To: linux-mm@kvack.org
Cc: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jann Horn <jannh@google.com>, Arnd Bergmann <arnd@arndb.de>, 
 Kairui Song <kasong@tencent.com>, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
 Luka Bai <lukabai@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777614950; l=5934;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=+oyohCA+JyGfxecKQ+uLxgtNgUJn9qwmjDlmDdf3vA4=;
 b=o4S5WSyWmT9V8olRnoso6ocnjd/DjId8IpedIoTth013Ruy23KwTts2OKjnQPnmADSAcGkBiN
 zsQZBJhZ+OYAcm8T7fUoN1R6VaeYZUf1wNhB/0ly3aMkSCogw3ymlIz
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Proofpoint-GUID: rUdIpohAvfkWAFbvPlg88ZZnOitWks7N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTAxMDA1MyBTYWx0ZWRfX+BMl8P4W0kcJ
 fhPM1yM5aQ9ptg08zmo3MwKy+HVVZj3LguMEemdbGKyevCga4TwGVEAxV3IwOVDlhrjaRja8Ytx
 zTj+TkKlXXJh5J+ulbqMUkXr3cdC0eLCodoqdLxi12JgZK8RhJ1Sbki9Yede/r11K+8fyolz0Jz
 nzzK/+GIFdtXWiVRF+r5KaeSrCKozVIin2hMHYQIquBziWURXPCSDvjXhxtQKeQo2rE5Vmyvnjv
 8cb9UsCsSHBOiBoiSj5GGpmLD/BMrP//DlimIBhtCg+rgnik7CeY8aNVtH61yM0a3fDNSO8I8C+
 HcHBi1yOQlb9FQsaaOLNyiqBNphHB4Y6ycQO6JhqZm5rARL8gA9A/bcnPNSpN4=
X-Proofpoint-ORIG-GUID: rUdIpohAvfkWAFbvPlg88ZZnOitWks7N
X-Authority-Info-Out: v=2.4 cv=aqm/yCZV c=1 sm=1 tr=0 ts=69f44083
 cx=c_apl:c_pps:t_out a=qkKslKyYc0ctBTeLUVfTFg==:117 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=GvQkQWPkAAAA:8 a=XO4sgXVVO50CB33MxqEA:9
 a=QEXdDO2ut3YA:10
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5D5ECA0008
X-Rspam-User: 
X-Stat-Signature: 51m8e4umr681tuaizzty8w6jd4gjmp1z
X-HE-Tag: 1777614981-226761
X-HE-Meta: U2FsdGVkX1+Ecpl5GhAnPy6fQxCb6a9Tq4lq7OeF/jSVs7sP2DTVxrBRlBa8tG8zFLVc/5vLYBLuOalPaQbQ1aP/aUoK1O9AtaDesaRVqDWQ12cTmm70SclYHGaGOwz9O8iR90AYzWuwmsZUDGVtTaz/8jDzDSddATT++wcSR0pE2z+6Pj7jswR+OGaVc26tG7Hm1YvQ8zW/P7YX6CZAUHPeflKXUa+KzfS30UtQbBtOKc9qZBD/b7cwdDK/2gdnT+vWj2VCsWc6Na7Z5sbEiUf4e5Z6IJfF6h+Ej4Dsi+GvPyrq6MoOLFs/Pz6KGCTRhyLr8tTUyS7Hv9YY2eKaloWOlI/gklq8l1AvlEIHr1DHI82fMuDAQdZhP2WZMXRO7+E2S8WWroI4YlDfvQr2hVN0x6mngn5RLE49E7fI2z+fQndryhpqHbPfa5xTeLtnvbvZn3jpBIwiMcrD0kP3bwQWzyTWGujrI0J63d+nyHBReQOvt4XyvjCxvLpA+EcjoHqhlLK6BFhblz5FzSXHrnRs1jT96QdCD71wSkidVmqmeRpwieMzB21P/AaoDDObu7RRXqyr3f05Wdf+S34szIpPj9LaBmSHZzeOOYGMJicCsclEXs5rYeFrVQe/AJ+oclJgKJPrdYNjW/lZr1Ff0tYlE7Y98xcij8PbCNhPdWggG2UOEXXmbfkW3eddLt8xV/yR0dD0vITrbBlGeVpWy9vav6mIS6QWRdXsTfdwM1T+27cwAQXh+9ISCsBJE948ZOSKsY/V88/eUi/rMoogHJokgeQXd5acltGZTITYafCrsU0/xjstAuOR13zc0V/FW7xekO06BAYqJDra9jdRoDcRpywQWNW8YoRH6SM81cCZ4uGw7cDfen/Y4vbasOUPH7VuH+eKiFokWoO0sAZDecjGg492+b+XCtqkINeZL1x93KRs5d+veBIMlUBLBn2xb5zP+KtYxGtOJ77abn3
 xHh5LhPK
 gf5+D9rR/osfbSh+VvFsoNl9sxGTUWSxQahC0wyPrCl3GC/UiW4oh7g3BIRTH0gcbOxgXBXATYAHqWEll98f+uvZag6v5IdZ0b+b/FVpC1DXW9oQPQSqYLU8SH2dQrQQsz9wK6yU2tpqwPgrADbDR/JXcqKpsyn595voOHe/qY7lw9NyzUhCJiiYPrva2se1nSiqvd2cOwMLR/Wb1qGMlK/5dYFRJuXbBLIzS5SBUJN8GP1W95mobmjadO0yb8Hk/aoJgxlDP5r6tDXMY8lq0Ul2Id+URW8cBSIjGWrENVnDxGLIo/kPWV6m5YPXNchNgQen15lZXs1oo2jz31d8zY6TicA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luka Bai <lukabai@tencent.com>

Function map_anon_folio_pmd_nopf was able to map new anonymous pages.
Like in function do_huge_pmd_anonymous_page, it handles all the mappings
and statistics correctly in one call. However, it doesn't support
FAULT_FLAG_UNSHARE.

Normally, FAULT_FLAG_UNSHARE was set when we just want to separate
multiple non-exclusive sharing apart, it follows the copy on write
process, since it also does the checking like whether we need to copy
memory, or just use the existing one, basically the same work like
what COW does. But it doesn't happen because of writing on a RO pte/pmd
which is actually permitted to be written to but simply for "unsharing".
Hence we need to copy the same permissive and other marker flags into
the copied new page table entry just like the old one when doing the
duplication, without making it writable. Now, map_anon_folio_pmd_nopf
only tries to make the new pmd writable that is not what unsharing wants.

We add unsharing support for map_anon_folio_pmd_nopf by passing the
vm_fault struct as a parameter and get the unsharing hint. If we are in
the unsharing procedure, then we just copy the soft_dirty and uffd_wp
flags into the new pmd instead of trying to make the new pmd writable.

Signed-off-by: Luka Bai <lukabai@tencent.com>
---
 include/linux/huge_mm.h |  5 ++---
 mm/huge_memory.c        | 34 +++++++++++++++++++++++-----------
 mm/khugepaged.c         |  8 +++++++-
 3 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 3e5c6da3905b..61f0e614ca52 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -610,9 +610,8 @@ void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmd, bool freeze);
 bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 			   pmd_t *pmdp, struct folio *folio);
-void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
-		struct vm_area_struct *vma, unsigned long haddr);
-
+void map_anon_folio_pmd_nopf(struct folio *folio, struct vm_fault *vmf,
+			   bool cow);
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline bool folio_test_pmd_mappable(struct folio *folio)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index babca060feca..1e661b411b2e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1423,13 +1423,26 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	return folio;
 }
 
-void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
-		struct vm_area_struct *vma, unsigned long haddr)
+void map_anon_folio_pmd_nopf(struct folio *folio, struct vm_fault *vmf,
+		bool cow)
 {
 	pmd_t entry;
+	struct vm_area_struct *vma = vmf->vma;
+	pmd_t *pmd = vmf->pmd;
+	pmd_t orig_pmd = vmf->orig_pmd;
+	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
+	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
 
 	entry = folio_mk_pmd(folio, vma->vm_page_prot);
-	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
+	if (unlikely(cow && unshare)) {
+		VM_WARN_ON(pmd_write(orig_pmd));
+		if (pmd_soft_dirty(orig_pmd))
+			entry = pmd_mksoft_dirty(entry);
+		if (pmd_uffd_wp(orig_pmd))
+			entry = pmd_mkuffd_wp(entry);
+	} else {
+		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
+	}
 	folio_add_new_anon_rmap(folio, vma, haddr, RMAP_EXCLUSIVE);
 	folio_add_lru_vma(folio, vma);
 	set_pmd_at(vma->vm_mm, haddr, pmd, entry);
@@ -1437,19 +1450,18 @@ void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
 	deferred_split_folio(folio, false);
 }
 
-static void map_anon_folio_pmd_pf(struct folio *folio, pmd_t *pmd,
-		struct vm_area_struct *vma, unsigned long haddr)
+static void map_anon_folio_pmd_pf(struct folio *folio, struct vm_fault *vmf,
+		bool cow)
 {
-	map_anon_folio_pmd_nopf(folio, pmd, vma, haddr);
-	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+	map_anon_folio_pmd_nopf(folio, vmf, cow);
+	add_mm_counter(vmf->vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	count_vm_event(THP_FAULT_ALLOC);
 	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
-	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
+	count_memcg_event_mm(vmf->vma->vm_mm, THP_FAULT_ALLOC);
 }
 
 static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 {
-	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	struct vm_area_struct *vma = vmf->vma;
 	struct folio *folio;
 	pgtable_t pgtable;
@@ -1483,7 +1495,7 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 			return ret;
 		}
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
-		map_anon_folio_pmd_pf(folio, vmf->pmd, vma, haddr);
+		map_anon_folio_pmd_pf(folio, vmf, false);
 		mm_inc_nr_ptes(vma->vm_mm);
 		spin_unlock(vmf->ptl);
 	}
@@ -2174,7 +2186,7 @@ static vm_fault_t do_huge_zero_wp_pmd(struct vm_fault *vmf)
 	if (ret)
 		goto release;
 	(void)pmdp_huge_clear_flush(vma, haddr, vmf->pmd);
-	map_anon_folio_pmd_pf(folio, vmf->pmd, vma, haddr);
+	map_anon_folio_pmd_pf(folio, vmf, true);
 	goto unlock;
 release:
 	folio_put(folio);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7d48d4fbd5f3..18d309b69d30 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1402,7 +1402,13 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	if (is_pmd_order(order)) { /* PMD collapse */
 		pgtable = pmd_pgtable(_pmd);
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
-		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
+		struct vm_fault vmf = {
+			.vma = vma,
+			.flags = 0,
+			.address = pmd_addr,
+			.orig_pmd = pmdp_get(pmd),
+		};
+		map_anon_folio_pmd_nopf(folio, &vmf, false);
 	} else { /* mTHP collapse */
 		map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);
 		smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */

-- 
2.52.0


