Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F34BDC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 15:44:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D08396B00CC; Mon,  6 Jul 2026 11:44:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDFF56B00CD; Mon,  6 Jul 2026 11:44:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6406B00CE; Mon,  6 Jul 2026 11:44:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 933B76B00CC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:44:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BD4A167380
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:44:38 +0000 (UTC)
X-FDA: 84958774236.17.781D6AB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2AB5AC0011
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:44:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BPoBQ1kc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783352676;
	b=HY0/bBSuNg7hGFdKxwCOHpf4FcGas4G8NkxacjWQT5at57L/68+IP8jKE+cRZNNONGiO0X
	uEEUe5+1vF3c50lBkkbirJ1glLz39YUbZcpodQkELl+BYi9BWBD4RIMGVrl53BsnDkH0zO
	dd6nhnambLDjGtgg6hZB5BQbw5N4eoE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BPoBQ1kc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783352676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ri1h3tN8eEN6boK6iP4+hRTCKqh6Pl+RZ36BeSYkv6o=;
	b=O2fxMeuyHTrFEMPeQcPlYE4Lcdp9uuWXF1gxQlyW54vQQTpgaWPzHrHSKNMJc5XjUjB3oa
	eS8U8B2/oytYYThnmuAfPRONvgIBNzxapPRxdk135A1TEJ49OmKqzUYaIdlrxrkVWG8VI0
	nKvnS3M6Z0zxTFQSmdV8uU2VDvdPFKI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783352675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ri1h3tN8eEN6boK6iP4+hRTCKqh6Pl+RZ36BeSYkv6o=;
	b=BPoBQ1kcQw7+pCb/fo+QVTCCkEz/1lI7oZ/oWjUHZWRPCqaxH0V0NFBMiP4F9iKdhN7OZX
	c34nEIfFR4l9pTppmBgrpFAVAEU+2hwe4EAunCMBYgMZC1Sg+oN+UDpJyRXWfCEC+UV55s
	/EB5KiI4l1uWpfkE/wC++zTuk9m+BnU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-22-wUX65L7YMZyFrm8Ipz-Xig-1; Mon,
 06 Jul 2026 11:44:31 -0400
X-MC-Unique: wUX65L7YMZyFrm8Ipz-Xig-1
X-Mimecast-MFC-AGG-ID: wUX65L7YMZyFrm8Ipz-Xig_1783352668
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A13C91802669;
	Mon,  6 Jul 2026 15:44:28 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.58.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4EC1E195604B;
	Mon,  6 Jul 2026 15:44:19 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Nico Pache <npache@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 2/8] mm/khugepaged: extract young page check into collapse_is_young() helper
Date: Mon,  6 Jul 2026 09:44:49 -0600
Message-ID: <20260706154500.39178-3-npache@redhat.com>
In-Reply-To: <20260706154500.39178-1-npache@redhat.com>
References: <20260706154500.39178-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: ncapPFPp0bvDM2cHtGxEm477OiBLz-sgo1M3PG0ZZ-4_1783352668
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 2AB5AC0011
X-Rspam-User: 
X-Stat-Signature: mjqtqjjnmgjpawn6bd1kqj9iiduzjbdo
X-Rspamd-Server: rspam03
X-HE-Tag: 1783352675-824111
X-HE-Meta: U2FsdGVkX1+81YQBFtgQKNM7T1NouncedzBiISc9Fl97ld4nh7QXF7cZYsD13Ma9SvT0SpNp6AncpLEIMY0sPtmQjca3Oq4jXcnI08GRvQ1WuU0zLqAgOdee3vjUdUwMPfbiMtvXOI6CS9ydwMf2r9HPnC+5KA3aoDA994T+DoQWt1B015ZhNf3ExNC29JXJGe6w5l+Jx+b2iB/BISPYxbg2Nf5Filzlm9wjYU4tpZQrhFBetQCVJDA0szTQcK7yAjpiu/9u/FNArB6dS/JVBTshogQyKYh0UpmLasZ6oqEaLlFJqJx0xO4vKruai+5BS0mXxVsdyr5BtxcSANGO+DXJ0lHGIu/Zev5BvCln/CXS1kL9F0khM1FXPZ17BpBxi6Swg7WsMKw3+oGRh7slkUdgtGUYhxUlORxjaJLBRM3VFBRA+PuHHaSovdKz2paALEdHu/jUSDiQOfnZUeKO7M6qN88eJ0hDMgGNe/PVSiSmFPzuDMEsrRRD5GwVGchBbj6tBx+1eYHDYoeppWIpBwrLviGHqNL6zZUBEmdxjXnnY0ZeEIZS0D6zbj73IrjlCTn0T2HuBI3zJuIUA97UwFQHqkEZCcM7wbHR0mnXQEnQVAFFTWwryIGqR63StbtWxwJ5YsoN1Yj6v9Z2aNeZtTonLYRBHCOsgutrck3sBe+5NK7pPCVr3TcQcbkLuT6jRZg7xo2Us5TChZUCA0K1zpfBKJD9MyaeKIF9dybE7VOgfklptjDYJLVE9NWcICuEIDZE242T6p4NG9K1SQYtsP9icI8a9CjEtXs8jN2NxuTMCivQ3P8zQRsFkdewYtwGwGoZhRZXg6Ihv293oIk9Axsoguc+ciiT/6XKHAncJ+mk/PEr0R55suTn2x4F+W6GZcUKkEV73WxLMUlF0Nl42DrTGB6LRwrqUSwq7VK7ryQEbQDbYfOzgrU6hbIcdCNPw5hRLDCL3KKpsQ3YnI1
 90sXvldD
 2rviH1aPoBkRbfgMAvVjBYfQjjJsT31VWSLmawbq4JUbr0l2zQVJj/OX4ng5SCPgGaJemTmCDyES/W7c0/rD5wjoJ59N2aU2uOBeukHzYNnDbdCn2UA7zyyVXNBcwo5gLXXyAAnWfgkUGsTLc/CBUvhbnf66HcAmD4k8aB3vARXcXOFS2t2T5i/VelDYk0VDHe7sYy87w8HZ30iN5GTX93KSLBgaCZfkw/fWurieiD66Bmlhq/UAyxtgAsgQi61GvqUHa5vvlm+1SDaFXzfKmdGray1fNtm14CCmZho6jD/nR2sDPqO1Fq233wdvoxXsFdludr4lNMqIbJHgaA/FnngU7Vp58ruzymT55LiN2AExJrMD9n1+NJrYSW1iZlwNaZBRz5dodGtmToR8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The change deduplicates the "is this PTE young enough to count as
referenced" condition that was repeated in both
__collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
a single inline helper function.

Also move the comment and use it as the function header. While we are at
it, updated the comment to clarify that a young pte is a recently accessed
one.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b3985b854e77..48b008a3c891 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -675,6 +675,23 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 	}
 }
 
+/*
+ * collapse_is_young() - Check for enough young pte to justify collapsing
+ *
+ * If collapse was initiated by khugepaged, check that the page has been
+ * recently accessed (young pte) to justify collapsing the page.
+ *
+ * Return: true if the page has been recently accessed (young pte).
+ */
+static inline bool collapse_is_young(struct collapse_control *cc, pte_t pteval,
+	struct folio *folio, struct vm_area_struct *vma, unsigned long addr)
+{
+	return cc->is_khugepaged &&
+	       (pte_young(pteval) || folio_test_young(folio) ||
+		folio_test_referenced(folio) ||
+		mmu_notifier_test_young(vma->vm_mm, addr));
+}
+
 static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
 		unsigned int order, struct list_head *compound_pagelist)
@@ -813,14 +830,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		if (folio_test_large(folio))
 			list_add_tail(&folio->lru, compound_pagelist);
 next:
-		/*
-		 * If collapse was initiated by khugepaged, check that there is
-		 * enough young pte to justify collapsing the page
-		 */
-		if (cc->is_khugepaged &&
-		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) ||
-		     mmu_notifier_test_young(vma->vm_mm, addr)))
+		if (collapse_is_young(cc, pteval, folio, vma, addr))
 			referenced++;
 	}
 
@@ -1769,14 +1779,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			goto out_unmap;
 		}
 
-		/*
-		 * If collapse was initiated by khugepaged, check that there is
-		 * enough young pte to justify collapsing the page
-		 */
-		if (cc->is_khugepaged &&
-		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) ||
-		     mmu_notifier_test_young(vma->vm_mm, addr)))
+		if (collapse_is_young(cc, pteval, folio, vma, addr))
 			referenced++;
 	}
 	if (cc->is_khugepaged &&
-- 
2.54.0


