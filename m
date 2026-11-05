Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C214E606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 06:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=VVOgo3uE
Received: by kanga.kvack.org (Postfix)
	id BCDF06B05B3; Thu,  5 Nov 2026 01:12:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6266B05B4; Thu,  5 Nov 2026 01:12:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A702C6B05B5; Thu,  5 Nov 2026 01:12:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4676B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:12:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03B9A1208F6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:12:42 +0000 (UTC)
X-FDA: 85400046606.29.BE792D7
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7B5B0A0007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:12:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VVOgo3uE;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793859161;
	b=WpyreTkeDjQ1kBuZwHWEx//br8ktc5qtwle4WVOL/NA/HSqPrskT2B30xRQrm/wQygvCpF
	fLdYFHxupJrGezMASnhnZcN70t48ixoxWejkKSzF4c5LlGHyjKRIfvjPJlPqZKxZ+xbhQt
	z990ygAZGwF1qeGJMcRdV/x0wOF29lE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VVOgo3uE;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793859161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZM306HbMXxWJth45MNpskHOeaLxazIrhxWXy+ExQUgY=;
	b=KEJPnfJ0fQ32iIzsq8B1dhKOlW0YE/pbyJk9akwmocPL+bxZdtYgwTv6AG6yda0Xsdk2CJ
	BmsFkSs/ejG4S7PfY+wkUCKBRcFx+rKcVkFwc2LpDUpTarf5SlOYVHLXZKk3E9rS8f0Dkg
	JtQV02D6nuxzqINVDid3+Qj+3BRoTrM=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3b09a83d12aso788215a91.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 22:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793859159; x=1794463959; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZM306HbMXxWJth45MNpskHOeaLxazIrhxWXy+ExQUgY=;
        b=VVOgo3uEl6+Viq6O03nYROrH6mg4JJXFsbUfgpUmvMadERhC+j5y8MidXA45yK+vyR
         3On1RMwVCa5oBQOR0mUmd1hasIm3HPTxQywq+aPQ0A91s9eqvGtNXgpx4a32nE7Lxf2l
         QJwBQLXbXmhApZcel/kcoBRGVb4YvrmIhpbYyX3jYiJRCRUDyWcsUaeGXW5Jfy10nAim
         vEQ3AYt1ONPWWmDe8Vo8NIaJ1e8C0U29nYG1x05o12+Mfwaxgx6HIa6SjPdc0Wjoc4Oa
         9KEK+7VgtOZv9VOFa32AGOjrCLCBO6mpCZFpQckpGSa4FXh5ZmQg17Snd+rDoiXecr44
         axHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793859159; x=1794463959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZM306HbMXxWJth45MNpskHOeaLxazIrhxWXy+ExQUgY=;
        b=1TZd7Knq6HCIf3cVS5/SuxJkHEA8ozOntaSTWad+FVGfJ7yeve/SBcna2bHEYBjRWk
         qLATqwXZNOcV8j5Dv/d1FibxCQIEbAWjPCnL5NOdiDJnd1xaV8kE/JBDgWclAtWBKfCt
         ToVCsrPTW2Wen/JDWmTOghSBH5xsTpjs3tqo0JHSLsNLlCCoEBV1Eg6DOXBhvE/4O9tU
         mK9dGSfZ0JHi7CnpdxQAz1P7vluynkMXnQWmoA6c7Cfe+DDnqanVcYVqKRJiymh2TPXj
         fn2gsFN2NIjQABZLwUQ6c4CizkXa+TAPeW1ypYK6nRbBEVT0vPiXXMEQWZw9akaqWaVL
         QFWw==
X-Forwarded-Encrypted: i=1; AKwUvBykMjOj4QUDwiRAEyjKSUMRD/O4Ql4FH4rV8q5/dXxiU42uln8SpEHPJhEo6+64jHd5q77XkYw3Nw==@kvack.org
X-Gm-Message-State: APuU4Z8CtTdWN8c2ofMjHAcM8pUkADuNVoKFiUYvF3/O6GSmFuWeoHXZ
	t1IFXtYZL3lXYRqV0R08imlPTDr6EzoSHNJfSgxVjnqcqJWhYHcKhFfMTgz28yh7M7M=
X-Gm-Gg: AYBFou3qKtF0wXYEB9CP+a8sXPlFVbnXekqXnEUBUgDs5b57Rw4X2NdkYKlaloX5yEl
	lVvliMKUgngsEpOWIofGD5rHs2M97Qx3gp2R14TPTBghyB/hpPJeMW48gzd/S/AD51CKdlZ0MHM
	D0JuBEnF9aU98nWY06q/9KJPx5qVJT6eLsBFXHmiXhjHftSuih5CcH6OIAX7ZMelak9AeZK7jzn
	KhamTSkG0DLxXvdHopsvhjASA1J9BZvbzIY/ugipYadWMsjvdtZlhF6fpGW6bsV8vCCgju6wR77
	FPs1COXAytcCqV10s0/8UgKbYPXJK3pU/7ERP14QtoJDEuDxpShryXOsbCam+PfPl9520Q7wkvf
	B0iM9hEZ8awwSL6jtNGxhDOAWsSI2qZxTywww173rAkbMmbopZojzyuku2doPlGFTQMBKlBMULh
	3U3jK2iNvvTW1frHJAa8gBO+Wkg2U8zEq9Bwx57h+S/6Cxr470ulSYWQl0qpTYtUBvHrsTuNUpu
	kCPYcORbiB5k1w0+dv+KALChB9UOLIqSnQvk7fY2eyESltpm8zXEpcBmk7ePkQHaGIvuGotcSgb
	OC7Idg3aM34h+XtRhOZlGvq6O4qTkb/O09X2tIDIOKJom9w4kG7MZZD26ZKMsiBRzg==
X-Received: by 2002:a17:90b:3d4b:b0:3ad:eb4c:26fb with SMTP id 98e67ed59e1d1-3ae897c87acmr15846459a91.23.1793859159284;
        Wed, 04 Nov 2026 22:12:39 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b323a1fdsm2107528a91.5.2026.11.04.22.12.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 04 Nov 2026 22:12:38 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: David Hildenbrand <david@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Lance Yang <lance.yang@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 1/5] powerpc/mm: make vmemmap_populate_compound_pages() static
Date: Thu,  5 Nov 2026 14:12:13 +0800
Message-ID: <20261105061217.13302-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261105061217.13302-1-songmuchun@bytedance.com>
References: <20261105061217.13302-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7B5B0A0007
X-Stat-Signature: ujofaao8qr473gr4gawqhcurqy3p967j
X-Rspam-User: 
X-HE-Tag: 1793859160-909378
X-HE-Meta: U2FsdGVkX1+KtPncsElan7I4tyh7pn2dXHr94QuMEFid/FxQ+eXtYRHfWW8ciCiqRZ1UjfSTpxFmF/f/d2XXpsjcRihSayVGl7Ee0IxVBM6dqWIYszA9jKkcgRVCUEny3WUAHDE13r0iqg0+eKMXbGgeNPP1OW3g8vuDi3EW4+1vldPQzc57HfIgS8uWmk10AIDFTBl9G4VUjnTIw/pMZIwUC4OzCjhPcdUGNu6z74Ju3wW4BoLrduaw8wIzcbZgT9QuMh0xyB14BFTxaLXhSlO5KVPphxjEjgxPmrwKQ0Fiq8qiMVRu/wWuqUs7g9C2uI8t90KkOcue+SPq+WgaNqpP4a99/+uoEEQX6xz6b9Q1R99cPN0+LVZR40mnMB+wKRRehQhht36hSo8UwH79hBC8RSdeCBYE8ng2N3X7uarzdYjPTDNxQFyBpSwrV0p7JzJz2Ckh485Xiel+ZIGiZ6pGGQds1MywrZ86HUl9CpFeQaWNqfg64LVvVOKbCpfVeonMMr3g+iAX6XKhYpvvvo3OYZrVuozBmXPPapBverH1LglaBw8R9L/kvogUyCJxC/u0vNQKEE0bL2CFsMQAn5dSTV/ZGTKEejD3dLG8BMTU20KF7fkWyHkJ4nonyZ6FrzJnR1pgQ1NUKFyIwEAmJlugTjGZYNk2OsmeG0NOrjcrpEc34xvbI0g8wpjbAFGOPoBa4t09MM3u+/g+SMq4D1OhubH8P+jURWpuBanoMpmEX4+ZMNyO4KUB9xgorfz/ETNPd0Nofu8RUdHSdM7ZAH0nXsCog3a+jEiUp9nuKOPGz+79YYun5BoRulAWEclkys09pXYSMGxv2z8M38aXsBfKHVAqfp6LjjFJmgVOA8CHqT1XBdixch9fY/LND3INzKW5/wRCSNvBZ8/vSaMq616hScWXwgd9M9IhspqpSd9av4bcIlMBeaSNWBerJ4FFl6VHob/gwQM59wGp/q/
 OL98cUwS
 rZyyAlEq8DUy5dFxL7pe2cfxokCHX4xdGEqZaPqIsFcPbcuNv62NccsLDC0nR1zuIKqZuo5/nEa4dfL3Py6YmHVBpgjtZy+FgQ2zc+PzqiFG4QLZrfkBr9YWHkmBOgtilVbOOavIjyh7hKmzCR4CiBBAn+PjfsfX7rYX9gT3dztogPmRdNQwaeo2KEIr5ks7jwJE/LG85C/YiDhq8fbNPro9U6Ho6ZVDBzX5mradmo0g42r1cNaoKg7HTf8iiBx+a+sh7JpE2IS4wZ4WId3UTstwsfRjrUd2c5txWtqcxQYDdYe23P1YtyXuzQVgy1f0sTvl9tnJwaZTQ4RNlvPJCZvp3VIOso4X8+f8vjvD0cTCKL4XdOIKgFZIfFZPr7n0M2+X01YdlNDqlGNisT/ewRKWb0+/q5QZzAmHxebYRMnql8ViDDYUBBNKi4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmemmap_populate_compound_pages() is no longer used outside
radix_pgtable.c.

Make it static and drop the unused dev_pagemap argument from
its only remaining caller to simplify the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
 arch/powerpc/include/asm/book3s/64/radix.h |  6 ------
 arch/powerpc/mm/book3s64/radix_pgtable.c   | 13 +++++++------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index da954e779744..8452a2714cb1 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -356,11 +356,5 @@ int radix__remove_section_mapping(unsigned long start, unsigned long end);
 #define vmemmap_can_optimize vmemmap_can_optimize
 bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 #endif
-
-#define vmemmap_populate_compound_pages vmemmap_populate_compound_pages
-int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-					      unsigned long start,
-					      unsigned long end, int node,
-					      struct dev_pagemap *pgmap);
 #endif /* __ASSEMBLER__ */
 #endif
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index ebac5f9058f6..2924604fbb38 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1117,7 +1117,9 @@ static inline pte_t *vmemmap_pte_alloc(pmd_t *pmdp, int node,
 	return pte_offset_kernel(pmdp, address);
 }
 
-
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node);
 
 int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, int node,
 				      struct vmem_altmap *altmap)
@@ -1132,7 +1134,7 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	unsigned long pfn = page_to_pfn((struct page *)start);
 
 	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
-		return vmemmap_populate_compound_pages(pfn, start, end, node, NULL);
+		return vmemmap_populate_compound_pages(pfn, start, end, node);
 	/*
 	 * If altmap is present, Make sure we align the start vmemmap addr
 	 * to PAGE_SIZE so that we calculate the correct start_pfn in
@@ -1228,10 +1230,9 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	return 0;
 }
 
-int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-					      unsigned long start,
-					      unsigned long end, int node,
-					      struct dev_pagemap *pgmap)
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node)
 {
 	/*
 	 * we want to map things as base page size mapping so that
-- 
2.54.0


