Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECDB7C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 12:10:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 129A26B008A; Thu, 17 Sep 2026 08:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1026B6B008C; Thu, 17 Sep 2026 08:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 017D46B0092; Thu, 17 Sep 2026 08:10:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA9B76B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:10:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B7301202F0
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:10:40 +0000 (UTC)
X-FDA: 85223137440.01.A168A9C
Received: from mta0.migadu.com (out-83.mta0.migadu.com [91.218.175.83])
	by imf18.hostedemail.com (Postfix) with ESMTP id CCBF11C0007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:10:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u1YnfjAG;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.83 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789647038;
	b=xjC0B80xnNnJ6Oc011UDtxM+kjYOyS1MrScxqm2nZdL3ESsQhZWp+iOxBjW+IgVEVxiaMX
	AralO9VgSyPNUyUrwZFg2KnkiuE+NUnAkmmpWGJcSqoB1vp1bxIxanTYKw0Dn2Rd+2plG8
	GYTPq3nA++Gdq4MEA4TRsYbwSPVu45I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u1YnfjAG;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.83 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789647038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1yK9LjGjzswWhDTloRtiXnZ9aMCl9TBDCDiIwpuA+iQ=;
	b=07hfEAz7ERDcH8367ShXPw++fIACgZwf5lMWfLBywMENcddECj43jc3ad3SH4xQDHAzzcu
	pEf72V9j8iaozwlLC2KslRnWtzuFY59DnGQ6diT8eQxh0phAyoJVOySFoCxUUfhLjYVC8q
	vSj8Rg8mHxImZgHeWn9VUs4AiX2HOCE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=47vcZ904lW3a6rNy/Fy96vjfGFEJ8yr3KRqKx1ywsiU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789647035; v=1; x=1790251835;
 b=u1YnfjAGiN5FUhnln2+X/676E2irZhLeKYEPvFPpUaHzWhYAYIheDL21c0PBRGXXBpoc/oD4
 SMnPtdlGZ1+xn2iCciyZbvjqQQZfOCHJLS2iHBIzlUxKuQ32z/Jy3f+L+vSNgX1pARRhBiRRhOm
 ptcY+6DhH8x9L9kQI2AR+m5I=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 44dfbe1cd77953d7;
	Thu, 17 Sep 2026 12:10:18 +0000
X-Mizu-Trace-ID: 44dfbe1cd77953d7
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] mm/huge_memory: disallow raw PMD mappings of the huge zero page
Date: Thu, 17 Sep 2026 20:10:10 +0800
Message-ID: <20260917121010.60966-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CCBF11C0007
X-Stat-Signature: wsmkum1ncgahresbbogesyuo18333amq
X-Rspam-User: 
X-HE-Tag: 1789647036-69277
X-HE-Meta: U2FsdGVkX1/Q6gjwCVSHeQ+L4pcXda5n6Z1iAXWvyjKC/fVzKeY2oo9KJ9/t7lqX+YMQbcpznuWo1wpqD92bzQSHm3sMXsa+b9ZU0fAjcW+fqusWrLxcZt/gQk5XBEO81tMW+QKGbvNBHvApyuR+urjVtq2fU7Wj9MihR/z19Obv7VAxlis0Dc5ma77Ba5FdbVDnfhM+IfkyOQuOfMBGIwDg8HVGfsGYw+DlUoKntTFX9KMJijwOeuO/yAs2SpACjhFryUaWelWXPOV01Q89mkjOaDcEcDPdOs7YkiWUd3Kp8fdvUNQqloxYbhVZ4BXQxaP0q9NbKALCzPytX0ZttVaApYpYKdrtlDcF68VJSYOT+SDWifJILTyFjcc5vW07Y3GloM/IoPHUjsneVKHUDrAhWyTixtbuquH4dnpMoqQzvEYUzM4SrSI2SCCM0K6reOj8DEJFtPLz9rCV2V8Ri4WyaNsLEfiqzi4KeQk2gLhyzGr2f62lpAoIU61cHMI+/BJEZSA8+JaJwb7XaAG9aEdIZTatreLyouJ6pmrnSErRZveg+QoLedSx6MBiK0CP3UA1RfPT9x4oOjdYprAUEjnyqvTFfVyWg2eUMuKzHjTQ1qH5JtBFLFjyBci0dIcQT6a7r2MGAAqW+d485cMl/GtG59TNjann4ppv/JBjbI12RS0wfnPnTcSgke7r3pv0izJ/cxyuBQul09yRrMXXwufnss69jejzD/eK8J11GI1DstLPlBXx4tHXO+3pL2Tcwd2R0bajdZ4oXlkpEkMuYFoJu76wAPkiZ+JZrr6h4/e+zOChiWMloatBg36RYc41/5dlRYE0iYRI+7RrbIUkuGsF9MzJMHO+n6wxzFOo8qkCwt7fxKnFaMvKdBJ5wdog9m4Ln8z0B3bBAz/b9YiwfiydOLwJ+r0AFYPf+K8rgB684PgXhxDdf07+2xa9k35L+0dzdOi7lw3CzDIyEQr
 QlQt2JXz
 W+hdGJIKYMDPc6oFnyI6Cncfac1jgK5gk0BmdIFGa5RodzPqwdrmTGBMjUxpavkBEkMvgqT+dxr36A4KZ2NT+nCutJxHbRyJ2sZTcSkWB0Co+hYdFcJS4gmRYKHytu0Zj8h7QXaOjNZTdcU/pSqa1LPBR0VnqjECKsTv9CWxW0Lb6cz1swzVJd84pyGO3AyxL35F7Y4iufEUFZYRxDGXCLH14mlrxOjLjG+SYgZ35kQdIzorFcMsTsKhKXYkjuvn62CSvvYR6mPq1LAcpHE95NtmCoQ9TFtaLplagaV77Iw1MQBQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm_mixed_zeropage_allowed() validates zeropage insertion into
VM_MIXEDMAP VMAs. No in-tree user needs to insert the huge zero page
through vmf_insert_pfn_pmd().

Return VM_FAULT_SIGBUS if vmf_insert_pfn_pmd() is asked to map it.

Link: https://lore.kernel.org/linux-mm/f76beaf8-351a-4b22-b362-a945a5e1af6a@kernel.org/
Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/huge_memory.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bfd972b997f9..c02f21ce4f4c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1728,6 +1728,9 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, unsigned long pfn,
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
 
+	if (unlikely(is_huge_zero_pfn(pfn)))
+		return VM_FAULT_SIGBUS;
+
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
 	return insert_pmd(vma, addr, vmf->pmd, fop, pgprot, write);
-- 
2.39.3 (Apple Git-146)

