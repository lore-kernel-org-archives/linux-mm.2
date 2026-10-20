Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4585F60A2626
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=ARy5qvpZ
Received: by kanga.kvack.org (Postfix)
	id A42A06B04AE; Tue, 20 Oct 2026 07:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A956B04B0; Tue, 20 Oct 2026 07:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9302E6B04B1; Tue, 20 Oct 2026 07:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6312A6B04AE
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:59:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA7771A0007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:59:14 +0000 (UTC)
X-FDA: 85342859028.05.13CA0F7
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 22A641C0004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:59:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ARy5qvpZ;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792497553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zgPekKjovvl8zoMfDt3tTZBqBHO/YqQvoPiE7cFhRPs=;
	b=UKxW+bPl0S7kiSDkDT4KS275xRu7CCHgZjkk+MF32iHuUXszkqWRPcoS5zCIexw/LeF24n
	w2aH/MWD2cow4Gyoe4yM+H6ERVty3Ap1esmIX5TyEcbdypIGMP07Sq85HbJKkz3939rjIK
	2YdgWzdONJpy+V36E/ln67ooBiU+uTQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792497553;
	b=VxTNdwfP1AY15+nfC4OHyGuPYjxQ1z9pHIXMgesvLIjLuXNIe6EUmVolpYNGa/4Cl3H2ef
	sZEnFLrUo/uFQN+MdnjtDge9q21P2c3ZNCk6KyGh7fsAly3i6ECVDTNTzMlagTHFhhPOuy
	7cXzdD6mIN3bLg2Y+b2idpYVxFYh72s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ARy5qvpZ;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cd3310348d2so237328a12.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792497552; x=1793102352; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zgPekKjovvl8zoMfDt3tTZBqBHO/YqQvoPiE7cFhRPs=;
        b=ARy5qvpZwaiuzEvWIk7xv9PiVeaJlk2dccj4GnXByj6M0JtHHdsfiBZwoK1KeU3h6+
         6tpBurORGJWyhMC7JBmqnoQXowS519c8SktRUX1Ok2N31o/4SMyYweVX+E/wsiCytgiN
         CtZJUFs1YKviu3aQe93l99oJlaL4q8vc+7emFNZOuNTbOYAqKo4wIsnNp1teTx9exhiV
         FTvEa1kYfBGT8w8xdBCUAuaX7YFOalNrSdjnJaaVLBRxlqEbxcx0yT9CR+FVyZDvfySm
         6HL8w6SHHK6LlYSERrle5A0wbVCRWn+9fL2Z9N+FWOUy3MNA+PgUkB30rVTMY1kZIDoG
         oY3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792497552; x=1793102352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zgPekKjovvl8zoMfDt3tTZBqBHO/YqQvoPiE7cFhRPs=;
        b=OOfkEZdB8yr545stSY6CsZ7nS+5JZATybABZdmsNrOPpaEcei65zHVuLRO3tp+S1IN
         n5MUZwSCl+50vujfNSJdWH4T9HdPfJgJKIjyOkL/FFjME7mAVtnQqFOj3gCF6cdmo7zK
         vwww4ooGIiOSLPkbXWZO6I4lHDqst4sX8gy29Sv2V40IL7bFUML8mytRj/J8v05/rrli
         2JCV3cnC7er1ldL5Y0Ik0/fV905oNBrJ9Mqw/jq7Jr4tCQBYOLEhiUUJmRwusqvPiwBy
         u/eWnQJhqc/CB2A9c16Gz36VHHqTbQ7XCNTRDP2BmNdc/z8Etii6EI24z6ou2YbKS5qf
         KtpA==
X-Forwarded-Encrypted: i=1; AKwUvByhbDnfNDHFwdw3xlPcDuLeWeuHphf03H6fTBkLneGF6ukv/5MqDXRY9FutjpUpkx1P1LzS1wYTQQ==@kvack.org
X-Gm-Message-State: AFq9FYINyzQ0cmSHb1zKpNAcDCA8kdXWeuE997lKY9ICJ7KL1bF9a0wv
	1rr28+nXaQ2833yMoJf6i3TUBufqqitD449UZqrGZxt/5rMJP+OOSc4eGQxrNUBfYDE=
X-Gm-Gg: AYBFou14bnDUUIQByUEOjmFKSpuutTnCddgxjVENVA9uNg+V2Z/8Nsmey/sV7l7a6I9
	OHQbFHJNjzR1xgOUrDZp7/cv0r1MtcQSJI4zWrKupbI56qqA2qw4NuMDT2AULtU5ugNYlPthUkC
	osJLFH0hSV+tOki/ymMch+JVtLK776y3gYoLiPLCiP1S2L7cPrqWufkKWu1piPttuGro00F8R5N
	bB7zJz8bAemygPeUai8RziowqH56uDoFZBcY2vb7AI5k8k2v7nf1wOVHRWMmLXzxM4uZR5Wfo6R
	LmtoJC6BiwO8rAB2i4FzIkEhaV0Qu53DJLVrYzxsDF7w69QifcZLsIhDXKT3fZjSKD95zLAsm/B
	eci4RG9d1l3Ti7A2clmQXdhaEcKOwaeLt175E8B7ntB4qQPA1Syux8Kl2hpFYI67rlhiE0grYSG
	92owyQ62O+Dv+OSCmhHM+22FVJLUSO8WYOzSLEDuydN19flrtNMmr3vVSVs7p9EXzDKKphpqcAU
	2nw7ese5OivKdNJhW5WA4ltbwXnj6E=
X-Received: by 2002:a17:90b:4b0d:b0:3a0:d82b:237b with SMTP id 98e67ed59e1d1-3ad64bba7a1mr1118419a91.25.1792497551857;
        Tue, 20 Oct 2026 04:59:11 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad60274fc1sm3448095a91.0.2026.10.20.04.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 04:59:10 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 12/12] mm: hugetlb_vmemmap: make vmemmap PTE conversion folio-oriented
Date: Tue, 20 Oct 2026 19:58:24 +0800
Message-ID: <20261020115824.823278-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261020115824.823278-1-songmuchun@bytedance.com>
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 22A641C0004
X-Stat-Signature: bup65ekorrjqzzzeg996nh35pb95txc7
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792497552-841938
X-HE-Meta: U2FsdGVkX1+tM6eStxhma8NEWHJOM9n7g2a2UHkfdFeiN7H2o6kFYynxAhYJsl7gHcPDr8I0Ib/emKnjRy6vgvpBykHndJGoeXH++YzB32cJvPdu0DhOCtrAABOJsIlAmusA0G2/Dcyx5CopSd8P2JsqXmcqS0mpyjnjPrE+wwOtoEMaQ91hlhETTnINnUkpNOom5VOut00MGXSCMswvy5MsyPJNixwELeouyCCgxBh3VWXXiqFkw5KfAm2T6J7NXPBwHHlYESF9SN8TdfyD3KuHUSa+UINHEHgwN/lufsbrusT4w5oo802mVGR4hvY+zQuqC67miIi1rxHEhbwSfbwKxlAeN/xyy4UatI15ZrztjqS2lu/Z9jvFzHLB5cQEXn3xbIzCutjSNzFAAH1Qk+/pqrDSq4AUy7pngFNyls5DKOPa/empD9kLGnf6b1fjNgJmd74pXriVVSpR5I65Ogtso7AlKhQyKWhJMkGP102HDO5fptLkWuoImxR0Cv0FOYlIRZk6+N7bsidLTG9fqtgEV0ljoWjusL8J7PLtuPqD1GjwWByCMkbX4WzhBpjbF1FBqnHuJTHrqcoXZE6pRRo7SEdXhSobFjUhTl2Qj8KesXz8VXwpSj27n5fBa5H7+lSMkV8xuBB/l1CrmZMAttWBFjNB9eRrZeqoeeDnpbncNMa7UBYATAl9TsNB8okgYFQE7OTl37O2b5CnqEC90fbfotwStRTaBHaQ7F6z1oi58V0FJ11fku0R78oPDSoVjWnAjJbP0peU2xl1nk9CL5o9gRnu1tfIJRrBxkOW4P3oYr3s/CUXm7U2hxaXeFjhS5GsH7AkE6KARtuXNS1vP55rCn4hTQgFOgvPLcl+wVR5HQumke4zkPPwNdreoeB2qMC3f2YdrWkFaZP+k4FXFDoU3kA9he8ly60yPoi6uQ0iL3x7m3SjjcTuOBiqhCWSSnJqKhpnceBNi7rbW9I
 vB390BlT
 8wmZf0hf1+WAuovDXFuuQ/rMgI4Hwpq7mvizGWgABvOqzoFQ5QODoCF9DFvR5aMPmdm/m5S0DtH2JBbtwHK+7K5Rw+9XLSq+CMKkKjgrs8WHv3xxChdxPX/1gC+agN77TCFI5PFCtMyJ0k9yHiGhU+znJ0SXRdupWQYpYIS74YIUTSVjSv2SEvim6SbTCR4d978ALxmmpRXcLr6zMXneRwU8N6gC5losaodEr1Ls6tH+dzZOPJNTgvP0oVJFa9vaGmertxvhcEzIPO+8FI0B15iTlK8lkgKPKxOibxYP1TcdbQM6Dg7sRZrXhlpvPHxEKQZSf24M5x8YNCde8wFl3CDaDX3Tcp3AMPYM5TCXBB6cNhcA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Converting a folio's vmemmap mappings from PMDs to PTEs is a per-folio
operation, but the current interface exposes a raw address range and
hardcodes deferred TLB flushing.  This splits the common mechanism
across layers and couples it to the HugeTLB batching policy.

Make the folio the unit of PTE conversion and let callers select the TLB
flush policy through the folio-oriented interface.  This keeps
HugeTLB-specific eligibility and batching outside the common operation.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 2cfb88dc4fba..75ab5584abe3 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -297,20 +297,26 @@ static inline int vmemmap_restore_range(unsigned long start, unsigned long end,
 }
 
 /**
- * vmemmap_remap_split - split the vmemmap virtual address range [@start, @end)
- *                      backing PMDs of the directmap into PTEs
- * @start:     start address of the vmemmap virtual address range that we want
- *             to remap.
- * @end:       end address of the vmemmap virtual address range that we want to
- *             remap.
+ * vmemmap_pteify_folio - convert the vmemmap backing of a folio to PTE mappings
+ * @folio:	folio whose vmemmap range should be converted to PTE mappings.
+ * @flags:	vmemmap remap control flags passed to vmemmap_remap_walk.
+ *
+ * Convert mappings covering @folio's vmemmap into PTE mappings. If TLB flushing
+ * is skipped, the caller must flush TLBs after all pteify operations are complete
+ * before remapping the folio's vmemmap pages.
+ *
  * Return: %0 on success, negative error code otherwise.
  */
-static int vmemmap_remap_split(unsigned long start, unsigned long end)
+static int vmemmap_pteify_folio(const struct folio *folio, unsigned long flags)
 {
 	struct vmemmap_remap_walk walk = {
-		.remap_pte	= NULL,
-		.flags		= VMEMMAP_REMAP_NO_TLB_FLUSH,
+		.flags		= flags,
 	};
+	unsigned long start = (unsigned long)folio_page(folio, 0);
+	unsigned long end = start + folio_vmemmap_size(folio);
+
+	if (!vmemmap_optimizable_order(folio_order(folio)))
+		return -EOPNOTSUPP;
 
 	return vmemmap_remap_range(start, end, &walk);
 }
@@ -529,21 +535,13 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
-static int hugetlb_vmemmap_split_folio(const struct hstate *h, struct folio *folio)
+static int hugetlb_vmemmap_pteify_folio(const struct hstate *h, struct folio *folio,
+					unsigned long flags)
 {
-	unsigned long vmemmap_start, vmemmap_end;
-
 	if (!vmemmap_should_optimize_folio(h, folio))
 		return 0;
 
-	vmemmap_start	= (unsigned long)&folio->page;
-	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-
-	/*
-	 * Split PMDs on the vmemmap virtual address range [@vmemmap_start,
-	 * @vmemmap_end]
-	 */
-	return vmemmap_remap_split(vmemmap_start, vmemmap_end);
+	return vmemmap_pteify_folio(folio, flags);
 }
 
 static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
@@ -577,7 +575,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 
 		nr_to_optimize++;
 
-		ret = hugetlb_vmemmap_split_folio(h, folio);
+		ret = hugetlb_vmemmap_pteify_folio(h, folio, flags);
 
 		/*
 		 * Splitting the PMD requires allocating a page, thus let's fail
-- 
2.54.0


