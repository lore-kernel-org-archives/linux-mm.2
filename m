Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98903C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:11:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ED886B0093; Wed,  8 Jul 2026 10:11:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C50C6B0095; Wed,  8 Jul 2026 10:11:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DB066B0099; Wed,  8 Jul 2026 10:11:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66F346B0093
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:11:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA4F286D8F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:11:16 +0000 (UTC)
X-FDA: 84965796552.02.ECA18C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 39F1A1C0003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:11:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dY3fvVBG;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783519875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E+AlVizHAu3WzgjL8uIczk1k7KNNNOBonScKWHpcsCI=;
	b=kegVcXCKA1bHqq+kHhEMVU+kRWvsSPewxep5IlXN2ThLtBicjqnHvyPXQfhQuHNV7fY8pw
	wgtngmovJlBo0Pa6Nyjwj8RpTZ5FisV3OHNPwb1cl9YFUIOSXZqG1kr5GC3jO//8jX8MLp
	1mjDRTV2+TjiPTmJxtR3hnzPMblVy30=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dY3fvVBG;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783519875;
	b=nrytgKAyUwXm7AdJuKc0gZf5JTVPn4GnkP/02a5eSUSsrHrnscXDSgboWIcz8sw0+nY9RV
	6b/eqRDfpnVa8NOnLq9OZ0XcmsNhlvcFQVegeYU7p2xFeKqcarwB8JY1cYERqCVoFpgfei
	3VUKCBENgDAezoapTplN0n6Hkrx90IU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A5D343E67;
	Wed,  8 Jul 2026 14:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E112F1F00A3E;
	Wed,  8 Jul 2026 14:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783519874;
	bh=E+AlVizHAu3WzgjL8uIczk1k7KNNNOBonScKWHpcsCI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dY3fvVBGl/2fsM7e1EHOWO7ed5WSNaMRvRaOwku0a6Q27yhD/O0RVg/OSyF+Ygk22
	 Rp/VjvKdYcvRgKOBfjpEcVyucHkbasJ9I8s4ksbOQTI+O4LCdkFPcm746p8SUj+w3G
	 S8ksj55L+O/ElhURv+Wz7hu/jS49UIPERbbQD/hRc1yez2Ylk5+DhBOcrU28HBP6Ud
	 HFR4Rt4NATcRrwlc9HG6RP9wigX4bQdXFSDQlBXljrQ37a2CYQJMqsIhCO64I85Qp9
	 TEqNLOtMtLelimYChR7VsPxs8D+OFpLfRGfycH3VIp5nZCim9Ao1VPcOOvPS8K9Eqx
	 ujlOSmn0L/HTQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 08 Jul 2026 16:10:56 +0200
Subject: [PATCH 01/10] x86/mm: drop order parameter from free_pagetable()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-bootmem_info_part2-v1-1-156ce4986598@kernel.org>
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
In-Reply-To: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-s390@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 39F1A1C0003
X-Stat-Signature: 6s3i664yuso9drmd8k6roaosar31io75
X-HE-Tag: 1783519875-343461
X-HE-Meta: U2FsdGVkX1+TDfF7cvSsw3wZVSGJ7k1zN6BFsw50K+9rAhz71j5QL4uCrFsTpRsPg4zCb8ExMemnld1FRvf/yMnXWB6b5n2DpyZqUlufKNBqi5Ldp4osfOLhnvYPk35z4+euTsn7j+SPT6cJdOafAMVlibTaHgY1lSl+dRlZzQH+LTiIDDlJfx9Cn1Xo6Tmfd7Ir4tAkoG5HFH7KnNoM8QqOw8RApFae4Q20E3O4dlxHtLm1lBYFX7NSghYijc/0vCHiDXvD7wGz8duL0reayQIIwoD6X4yLK9D2+selFR7TU32UVFMaMfQzg31eRdriPytDc3L42pJEjQumL3HNIw6DTKdoiLw7KROu34iK1N4uWSi4/5wH0CaFIu3GYNV8EZ8n/n9NmicW2t1knIJAZQHd8qs7BL11xvVs0Xb6ZvFsNrppW0JS3Auwm1J+lgCYOiApEATEcUag2Gt0OAA1Y0t8lFowNmeDd6MDig6H041FDUqcEjXeMdPFlWelQ5DNZQUqx4qITvXcWiOPw/1ie0iWKvrucyJHP/EjLooyq1hFdex1LuyIIB88Z1VJCpX+EyiJolM6LX5dX9FEIkV8O5Qe3Jubp9zyLDd45j2j5ui2Y3bW2wS84wtunqxePZEOjV2EuRwS944Y8j5xGRsoTGSYOnTAUylBQWxgmGUvKxUzzN98G52W2U7wliLu+FJoc7pecfG3LVXPXhmf6LeChvQmtK5cnM8HpdaoPdTfdEm5gvqrbNGnzLSaFAz51q0tiSaxe2XdKafTNx0sJC2UjprarmNtPBOrBTvhcTZQRFCbg6nrJQAafPlCbV63GwoKDGCkHnUzwI1vceaMX70NIi8pRVFNjcSqvlSR7bUPzaGPVEU3mTeRh2qMdJQqvAwVCV358Mzqj0A8s2MaSVtpRcEGlHgxE1I4rJC+idGxSrpR2jAPbRFbkDd+Mqazx3nS5jC/ilwkq8H25Et1rCl
 S3+5dxA2
 /jNRW8pFnQ+b8PptDZLBZCCXM5g2bdt0+a8qUrosd81coYP7SwiimipEnvimEF18mMBkHPUw0F3BYTJNKoazZKTQ8/dqBnoGPGcVJ5IHmLlffPVf8rRu8PqoOSq6+XV1JAnA7LskJVyghwWofvqRNENVukNIXEQNRa+SDQXRnPee/VG1QPxExXYsidsfLmmCuiRS/uhRXoifP1wq8mz82mnM3EXvdLlD6sP7i2NYZIP0nuXQKTWZW5/WTAHLXj+d5g/CVw/+zulFMKeSuJjTAMMukAOQ6gQmcEXZHGyKtXTf6Z1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All callers pass 0, so let's drop the parameter.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/x86/mm/init_64.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index d57f29ca23a5a..69e36f02a663a 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1006,22 +1006,19 @@ static void free_reserved_pages(struct page *page, unsigned long nr_pages)
 		free_reserved_page(page++);
 }
 
-static void __meminit free_pagetable(struct page *page, int order)
+static void __meminit free_pagetable(struct page *page)
 {
 	/* bootmem page has reserved flag */
 	if (PageReserved(page)) {
-		unsigned long nr_pages = 1 << order;
 #ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
 		enum bootmem_type type = bootmem_type(page);
 
-		if (type == MIX_SECTION_INFO) {
-			while (nr_pages--)
-				put_page_bootmem(page++);
-		} else {
-			free_reserved_pages(page, nr_pages);
-		}
+		if (type == MIX_SECTION_INFO)
+			put_page_bootmem(page);
+		else
+			free_reserved_page(page);
 #else
-		free_reserved_pages(page, nr_pages);
+		free_reserved_page(page);
 #endif
 	} else {
 		pagetable_free(page_ptdesc(page));
@@ -1060,7 +1057,7 @@ static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
 	}
 
 	/* free a pte table */
-	free_pagetable(pmd_page(*pmd), 0);
+	free_pagetable(pmd_page(*pmd));
 	spin_lock(&init_mm.page_table_lock);
 	pmd_clear(pmd);
 	spin_unlock(&init_mm.page_table_lock);
@@ -1078,7 +1075,7 @@ static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud)
 	}
 
 	/* free a pmd table */
-	free_pagetable(pud_page(*pud), 0);
+	free_pagetable(pud_page(*pud));
 	spin_lock(&init_mm.page_table_lock);
 	pud_clear(pud);
 	spin_unlock(&init_mm.page_table_lock);
@@ -1096,7 +1093,7 @@ static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
 	}
 
 	/* free a pud table */
-	free_pagetable(p4d_page(*p4d), 0);
+	free_pagetable(p4d_page(*p4d));
 	spin_lock(&init_mm.page_table_lock);
 	p4d_clear(p4d);
 	spin_unlock(&init_mm.page_table_lock);

-- 
2.43.0


