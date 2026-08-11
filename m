Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDED8C5CFE7
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 12:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3B9E6B008A; Tue, 11 Aug 2026 08:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12A46B0092; Tue, 11 Aug 2026 08:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4FD36B0093; Tue, 11 Aug 2026 08:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF6B86B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:49:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5943B1403D5
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:49:21 +0000 (UTC)
X-FDA: 85088969322.14.8D8B144
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 776B4120007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:49:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="F/7oQKIh";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786452559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kuNQsqzvtCZAP+SHoQo5hA0FdI47IdyWzMAeT08TjCc=;
	b=d9KYDlOaRwVZ61z6nxsyHy+DjcqqWUK6PsN1LEV0KhkYQ0Wz+9lRfb8kG0K6mHoWO+ujrt
	nvilkwpUBT29EpSNkAiS/K9khFxYuv0RanqCoGdpb+hVb8pvJ+e3XZTrG0GWqTI9NmglpJ
	9ChlA5A5FVskMF1cqXXcGdVWQg2iwKw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="F/7oQKIh";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786452559;
	b=WIq5unOcyFv41BnGAhQtpqusm7UphfR0vBaYjeyqNHp+nbUtREWvLScBdNdhwhZKozpb0V
	IE34JhxHlnf8pdLT5IC+ycK2D1BRWrFAZzKuhwOJp2v/3IgLDbTgSFPBrCCsQSjD/smwg7
	BasOYfg521CenCxlw/KVFBGqUEacVeQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786452558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kuNQsqzvtCZAP+SHoQo5hA0FdI47IdyWzMAeT08TjCc=;
	b=F/7oQKIhzcjKpaS90dMYU+kVFsTaH6eg2Cp9nDwfSbrXRBqPeQRDxlDYuCywYAgx03L4LI
	PxSbPPceAnbNdYwekHfJ0pLrAc5i6WcfoojCQcdWf1hBX1rE1M8P/KvWaP/RQaJ4xDudkt
	9kDpp9tSinOpTmHiSrPlk0HbA1qeHC4=
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Date: Tue, 11 Aug 2026 06:48:33 -0600
Subject: [PATCH v4 1/7] mm/khugepaged: refactor per-scan state clearing
 into collapse_control_init_scan()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-khugepaged_pte_refactor-v4-1-ddac39d61c4a@linux.dev>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Nico Pache (Red Hat)" <nico.pache@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 776B4120007
X-Stat-Signature: y4s5ekq5poemcqspj1sidgoordbyndif
X-Rspam-User: 
X-HE-Tag: 1786452559-207488
X-HE-Meta: U2FsdGVkX18Yt+1IIOGkGzWEabjaD9ytDdZHd6pRcAobDnhkeuilcHbrkxI/1vC72vINkoAUyVH682PWxTNB7kQVlo3dPYH6ya2CNQOEYSm6oBOe1UIJzq+dsEx4dewh1g99igi1v/Ch4zM8vqK9CHOtMY2Ny74M48fY3FjB4N89+ikgVJGcaQKgBKxCy2YvuTGQkICEnvQusUE+VEb5Dclff/S3OExLj0tR41iUJ+nOikuy74Rh/9tkbfPOlnziO6EqwcjOC8vNlPS/Se6+vbYRUbRubMJnRafTLZ+ZIQJF1bk+0oi9DzPt/Nx2VGFFhAKYBT/IE7J1OaZ6JORLwMJZri/ZsYfeS3CEXuhLIRwC94dFDQZRlKOAtpYuFyyp9j5F3dlaMJvrN/G4oVySpbJxWmqBe+aZyieOP8o8r0j68hexyMoiboWJDTueSHrBDC/pB7YnFc95AciAixTmE8EvSLRsGrwYJBZU3Et1l9urMfU00zR/5NadpVtTLQJlqWg/542U3qDeGSPUFujpAXiepQje3KctE5ygr0rHbD2nS3tkdFqKyIbixwVNZoZ37rPrHRPYhvHkc+hzigwIONzG35ET8B5kxwfg3XOTNtaaIHGxgqPlcg65gPzVOND5DwpntuJzaMWv/19OB+ShbEcEyPqlQXUBlGnwkZ67oeRJd701hQ2XoL53qbyIGqtrnoYJvI2Ybaf/hahVl2zSvrQA9A6BZ504cI2CZiuPmfSbNOvRHvvfJgtglwc2Knizpd80R381NfIdueQBi2udOy5eW/6emw5iP+DDOS453qMDSWWFNnP2eZVb6Ht1UL1Hd0xvaL+RMj/nyhYO2rJ8Sd93h8BS47ncZdmfYW/MFKOCV94hEBkArWQYAHOGNBBN5ew/kzlew+yRPYJDnp3iFUdk5SKrzHwbMAi96m/wabkEgCR++7qpK8WvrJuPUSJ4xUz0DeAgnJAou4IuJad
 ROFYv//V
 ej2HprbuSdTcsP5CT0PBAN1QbYOiygNQag8pG72cuRlr/FeyCe6OpQ2Q9pV3tLtuTKbyD3WoCtlABuyeGTBD6CqJ2rOYL1ue3MDjLlVGhDgEZ+hNhSpfoFKGQsQcPP36KwgoLDzDIwIeJE1K6JWUNvfCuOcIzJWKubMJCl7ER6yhqEp6SvazEze3wo4CvVAwPhgscdtvgWWNlXbESUnX618d0v5n1Xnb52txq51pBU21NDAME9NYkGQRFTQIPCoc3FBf1L0MkGblrDgIuX8eNIrv6XaeEXv1SsVMO2G6Q3KixkDRr9LZTjnE5AuyDU1O1Zd+73Tuj6XxEWIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the repeated clearing of node_load, alloc_nmask, and
mthp_present_ptes into a helper to reduce duplication in
collapse_scan_pmd() and collapse_scan_file(). Althought file scans do not
current use the bitmap, they will in the future, and clearing it now is
harmless.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
 mm/khugepaged.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b237f6e7662a..1e26ea97381a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -629,6 +629,13 @@ void __khugepaged_exit(struct mm_struct *mm)
 	}
 }
 
+static void collapse_control_init_scan(struct collapse_control *cc)
+{
+	memset(cc->node_load, 0, sizeof(cc->node_load));
+	nodes_clear(cc->alloc_nmask);
+	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
+}
+
 static void release_pte_folio(struct folio *folio)
 {
 	node_stat_mod_folio(folio,
@@ -1617,9 +1624,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		goto out;
 	}
 
-	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
-	memset(cc->node_load, 0, sizeof(cc->node_load));
-	nodes_clear(cc->alloc_nmask);
+	collapse_control_init_scan(cc);
 
 	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
 
@@ -2691,8 +2696,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 
 	present = 0;
 	swap = 0;
-	memset(cc->node_load, 0, sizeof(cc->node_load));
-	nodes_clear(cc->alloc_nmask);
+	collapse_control_init_scan(cc);
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, folio))

-- 
2.55.0


