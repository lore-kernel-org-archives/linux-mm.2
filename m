Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3964FC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:49:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A827B6B012D; Wed, 29 Jul 2026 10:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A32C76B012F; Wed, 29 Jul 2026 10:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AC9F6B0130; Wed, 29 Jul 2026 10:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C76B6B012D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:49:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 97256C062A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:12:42 +0000 (UTC)
X-FDA: 85041551364.26.894CE30
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id E1879120008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:12:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Ir/iBewO";
	spf=pass (imf29.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785323561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=nTyZ9PRJp3TwjvvPuCfZvXx+PS2jKEDPXYVBjSEwgD8=;
	b=mW+CFi1gKOKrPlAxTFSEsKzCfFHQTsdiG80H+WLb0F8eUa6n6e8Q/LlFcE25HPRsoIpUBr
	6lhyPHs84HFeYB8nPn9NCRxMkvb/TGj3karsBwb8O3h9NZNG6zYL8QN7BiXJHSsr8Ket+d
	zCmoIwoRgW8wZA3E8n9mHMWIvTKhJYc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785323561;
	b=JBFkSc4n0n3gKInzVY1ylzX43Oz6nBd3nBIZzqDD55JsHoXUUArwGxQKLYiCpWQ1IEPkiK
	pXF3P65/QzMq0Sk2hOTyfJGtR5YryjCB1w7gGhrdetTwhcK9x+9HKILKI+5+b6+2Z0MCWe
	TFYvK9Hts3+2fdp8zaogri4vFQkgHl8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Ir/iBewO";
	spf=pass (imf29.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=nTyZ9PRJp3TwjvvPuCfZvXx+PS2jKEDPXYVBjSEwgD8=; b=Ir/iBewOL5tE27E5VqmhfuOTiC
	BkQytvIaHJzDLW2RbnI/uuYTj/DsPq5UXSpvV9l3OZ8qUnvJNAOkzphrsl+LBXp5531Fl19SOn/M3
	KbEVhkjuY528qmdv7vKzGVvrw8mAfq93xoKkLdt9LNLvs+Iy5SCBHNJRF8oUbbYHKAPXRSZR1rtBU
	H6qOFjZEMjIpN9FyMxxp0MqxlnqJfy2ULcvqSXmFTKVNpIE1BaupC7svMZcUONzfc8IOgs8eltzs9
	y3jbCoQv8DT2/4mgtwOg5URfgzK7BpJMp1hiTh7xo3vydTP4G7Wd1Q2vNBlSO+PtIUh4NAtGM48ZY
	DvcU6WNA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp2CU-00000001xXw-3ea2;
	Wed, 29 Jul 2026 11:11:54 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id B75E930114F; Wed, 29 Jul 2026 13:11:40 +0200 (CEST)
Message-ID: <20260729111119.488154104@infradead.org>
User-Agent: quilt/0.68
Date: Wed, 29 Jul 2026 13:08:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
 peterz@infradead.org,
 Andy Lutomirski <luto@kernel.org>,
 Borislav Petkov <bp@alien8.de>,
 David Hildenbrand <david@kernel.org>,
 Ingo Molnar <mingo@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Juergen Gross <jgross@suse.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Kiryl Shutsemau <kas@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Lu Baolu <baolu.lu@linux.intel.com>,
 Mike Rapoport <rppt@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@kernel.org>,
 Toshi Kani <toshi.kani@hpe.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>,
 linux-mm@kvack.org,
 x86@kernel.org
Subject: [PATCH 2/3] x86/mm: Use guard() for pgd_lock
References: <20260729110807.797920433@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E1879120008
X-Stat-Signature: nxchc7cxtd1yeaxdjr5a13fofq76rsrb
X-HE-Tag: 1785323560-272095
X-HE-Meta: U2FsdGVkX1/W4g1eujePvuUhYhmXzAHNU6IddADIVUsYE1//L8xZ0EOsA6VAIRgObkrEgCe+5RZKaKILvmu9AXwQ0cO09sJE/7qLUmwhJDDjZqEBCNJtbjuJn4Pnn3FpeY8VMC5YgZEOI0uhJxbIfxg+9sugRO/PwmghxqcC1P2IKzRLtxxS0O+cu6eX2VfS3+L6RF8N4b9eHVYMY5/8MU2nDklYxCrwgbvNYsW492PxB2QxD7c4on1HOHAfPIY2Hv8rGJ3r31EWsKremnTuUmrDMZK9gwj55o6X4aXFoHbugDDl1xWDJB+4exrD9OPFJlqVl/pR5vEWDFXD8cKnwv+ue8uqW34aK4Ff6UPTOb9VSghgMg25LNYU8GIfBVFRcLzpPe3Vxm5zz7BLj/L6+ZmY1NDz9bd6i48LM1QLElOX0zRRh0kblVwpdx2BUFpAsESflDmkWImz62DvqssvDbJ1HqP0NcKJepsozj7uz3/qHpfnrNAhSBXdXVUg93ToK5XWQeJY+gxfWTDCZ8HXkYxVIwkC1VSIeKodMBDTCv2Wsf+zFXykqilYHcULw8xSQ8b8MeRIWAIp5+DYIOPskdULorWdf3vu0ZuNjz+ljkqLXVhdKrI6Dc5zyJuHtHaYvfF2cxvPj6E9vdCP91bNtoZL0W5eV9A0DPsnLwwjwXfT9MqATk6O7r3HP61ZBTjNfbGbUvjHQ2KkVWhcBui1S/7KskZN+OS+g0qEkt012tMLdGuJqo+tYDreCA9tplfxwtpqU+bMb5itd7rYnyBLhO6IdCTaM9tOrwKy+BQZBNnSJiFE0RhQL1GNbI41NhdHqBZLDIROi+p/wDbOlSZq6O589TwKCwTVleXkY973wUyNFTlYy0/PlgJLIQB6yU7qDez97Upd0Vyi5zeBP4sWQqHUYHfn9nV8Cwx+9JxSjnli1QJDrOFEvWYo0M84PYf6zmXPqD9s9fFz+KYQK4x
 zb1btpT2
 RoXWeGV+nYGgwdR+6zyA1aFlQYg6/sOM0OXQAVZFPu/OimJHFG6BlH8R8mrHflt7CmHvpBWlRWuuiuirzN4G96IXtSitwMSLQ1mD8CcTDqbyZIag5uJwo0Nkzn2ulTgG5am0X3HKM57ejyYunjk/s6mfDdrG14W/A7/6QdoE3wxKkE+tPKidCpcfJZ5u/jku7kZn2mz6QiZhQGXv5N8OxrYIkYe+tWN9xLwMkMZA1+DzZBL13G4j+MOmGoezDpaoe26B8rJoE2DWn8J0SJbbMP+d6DlNvD8AXgfNLEUEdZV6dAtRfoefivkiN/524rjftMmGOoiA16WS5S+h2xMAc2XbZXVqyoUNMkiKPoe7hPt7m6Ua3+o9ETt3m0hvOoXgdnp7+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/mm/pat/set_memory.c |   34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -85,9 +85,8 @@ static unsigned long direct_pages_count[
 void update_page_count(int level, unsigned long pages)
 {
 	/* Protect against CPA */
-	spin_lock(&pgd_lock);
+	guard(spinlock)(&pgd_lock);
 	direct_pages_count[level] += pages;
-	spin_unlock(&pgd_lock);
 }
 
 static void split_page_count(int level)
@@ -1075,16 +1074,11 @@ static int __should_split_large_page(pte
 static int should_split_large_page(pte_t *kpte, unsigned long address,
 				   struct cpa_data *cpa)
 {
-	int do_split;
-
 	if (cpa->force_split)
 		return 1;
 
-	spin_lock(&pgd_lock);
-	do_split = __should_split_large_page(kpte, address, cpa);
-	spin_unlock(&pgd_lock);
-
-	return do_split;
+	guard(spinlock)(&pgd_lock);
+	return __should_split_large_page(kpte, address, cpa);
 }
 
 static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
@@ -1135,16 +1129,14 @@ __split_large_page(struct cpa_data *cpa,
 	bool nx, rw;
 	pte_t *tmp;
 
-	spin_lock(&pgd_lock);
+	guard(spinlock)(&pgd_lock);
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up for us already:
 	 */
 	tmp = _lookup_address_cpa(cpa, address, &level, &nx, &rw);
-	if (tmp != kpte) {
-		spin_unlock(&pgd_lock);
+	if (tmp != kpte)
 		return 1;
-	}
 
 	paravirt_alloc_pte(&init_mm, page_to_pfn(base));
 
@@ -1177,7 +1169,6 @@ __split_large_page(struct cpa_data *cpa,
 		break;
 
 	default:
-		spin_unlock(&pgd_lock);
 		return 1;
 	}
 
@@ -1225,7 +1216,6 @@ __split_large_page(struct cpa_data *cpa,
 	 * just split large page entry.
 	 */
 	flush_tlb_all();
-	spin_unlock(&pgd_lock);
 
 	return 0;
 }
@@ -1373,7 +1363,7 @@ static int collapse_pud_page(pud_t *pud,
  */
 static int collapse_large_pages(unsigned long addr, struct list_head *pgtables)
 {
-	int collapsed = 0;
+	int collapsed;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
@@ -1381,26 +1371,24 @@ static int collapse_large_pages(unsigned
 
 	addr &= PMD_MASK;
 
-	spin_lock(&pgd_lock);
+	guard(spinlock)(&pgd_lock);
 	pgd = pgd_offset_k(addr);
 	if (pgd_none(*pgd))
-		goto out;
+		return 0;
 	p4d = p4d_offset(pgd, addr);
 	if (p4d_none(*p4d))
-		goto out;
+		return 0;
 	pud = pud_offset(p4d, addr);
 	if (!pud_present(*pud) || pud_leaf(*pud))
-		goto out;
+		return 0;
 	pmd = pmd_offset(pud, addr);
 	if (!pmd_present(*pmd) || pmd_leaf(*pmd))
-		goto out;
+		return 0;
 
 	collapsed = collapse_pmd_page(pmd, addr, pgtables);
 	if (collapsed)
 		collapsed += collapse_pud_page(pud, addr, pgtables);
 
-out:
-	spin_unlock(&pgd_lock);
 	return collapsed;
 }
 



