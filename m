Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E34EC606A339
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Lg0my0Vw
Received: by kanga.kvack.org (Postfix)
	id D681F6B05C1; Mon,  9 Nov 2026 04:58:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3F996B05D1; Mon,  9 Nov 2026 04:58:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2EB26B05D2; Mon,  9 Nov 2026 04:58:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D7A36B05C1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:58:51 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25B07160606
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:51 +0000 (UTC)
X-FDA: 85415131662.01.37F4A7F
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id 49954C0003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Lg0my0Vw;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794218329;
	b=1UMUzbZ+GfdhQvyhsW47h6cDv1st8Q5eXXiGhIsBc9tqse7WW+aesFYaN8i8/RAMo36jRa
	u2ju5+WWpt9tn42J7XrvLr9aIwziJJKJKBO/bobY2mjm446Q9zD8JfnDVjnRNNK/1dgt5m
	2CSzkJZcSGZGIXUa/ISBG1Mu3MrWjD4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794218329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tLLqV/79ic6LaYQ9gny2eZCESoOQIsoKnn0MRua10fI=;
	b=tVHIndn1/Xrp0EE5cPhmhJzhdyTApKywZ51l8kYEm9/0MUYZlU1SG392ll+ReYanrgvJKj
	XKkS+LD8K2Hpge5nX40GzXPPb99Zkumytd7ZE1WP8aRFwyY3I3+Cg7Axta9aWVKWmByk91
	Olm3uKxbliNPG8UHTQlzBLeuMQ0vAik=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Lg0my0Vw;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1b1ce85287aso607563c88.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794218328; x=1794823128; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tLLqV/79ic6LaYQ9gny2eZCESoOQIsoKnn0MRua10fI=;
        b=Lg0my0VwToHJeGM09actQbecxlTrq4JVRKYOHLIKTmZvEOqb9TreLy8NnlINEf7/gp
         2XxbrhhspQAPKWiRJjSlgKuWp4hy0lblYVCAYzfsMrSxKfl/gJD/5DYIxoQqn9LxS9lC
         peCK29jeZwSwzLKTu89CBZDIo+Fti4Ds+ojovVZmMMQGrDOmrb4j6wEO61/V69O4U2X4
         V3+6U0r7mIHBITKNqfqJc84HQO5tWqly82JuCb6dUmjNB9/VEhdCIb6b97PImQITl1ts
         Zks5t2KAtvL5NmyLqv0MLbYaclBsyTFhG2BPDj7lGHBPzTgXbpCU7+QNSq/9l+Ob60gW
         fm7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794218328; x=1794823128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tLLqV/79ic6LaYQ9gny2eZCESoOQIsoKnn0MRua10fI=;
        b=Dq3p0dJnBR4d0Kg2YIFVR8rpTDLPr6k3FLtGdyklBGSkgVpDZeWFC/coOaHpvFJR4Z
         BaDdmG+hKQ17bPINunSjy6XE7glWAm5OdSjYYRDmjrPqRfxCPmxQewQkMVhjUZamE5CX
         S8l170IfpKzsfkVfoD/2/2it1O7c4RRPzBV8+amI+dXQDgqzPJKJ5dSyAbwUzd6uuzwr
         6GHFpP71ouWv2Ot8ms1x6bC7/sb2cj1daDRs4CXEanaQeK2Oz7rtCSZi+DFqCp/sKMwZ
         40qWbz8eTm9Uu1H10EJ6TYdMgpcX7wXdWWRbqdVRpBTmWI+N2qtbOrolNNKB1IX5tbU/
         1z/w==
X-Forwarded-Encrypted: i=1; AL+hErHk3MHn4MkykiJ6omxyAj41KdiGKHE4acCRaXv5Yn0kneR2sOrjBF41vg3yCEYEL0OSwZ+bJ+Jn4g==@kvack.org
X-Gm-Message-State: APuU4Z9aYDDqijE0a8AtrD11Pp3wbGWeE0VqUgDOx/Vwg5DlSuiYsPxm
	xOz9SN9ZjzCTeJS07GbKcsiTdgQAB3y+LfNsiXdcZuk4yx5ebOJDshZ+NmXMzPQzvn8=
X-Gm-Gg: AYBFou3/iILxAxmXW9NiSctgzTFYpzZeyomfq9bPHOMxai/W2/m8K3Ba032P6flh1Vs
	I7uJZ9lMvNaxKG2/bN3bDkrR3XnIwMQQAbvU4Gnw+209bODFycveO9jcaWZWIjy2fd64u/lkDEs
	iS81ABtItW+Ea1tVYJ0DkFrKQB2ShRwJXO/sLg3ceKIZFLqpxgBGIlbJuoWLc/qkAZjOYcYK7f5
	2jhg7/GqlBiknCJ/5ZsQm+Fd47prwgV5ALabicrv4HPbgpkPD0QUqanmIyOLv7zYswJy8k5Ngzf
	rUXaZupW87LCnUTOn4x6lqe/BU+XMUtX2l8l8nJWSX+z2ROug7Z9AWELGudMQj+79x4ThTEIzJa
	oIF5josIhNjLRDKecAnYvdRKUVBBvqij6rsSjVqlPwezZEzkmKOeXuURPMDwshz0xCib+kiR+1+
	+NK38q2sXz2pHzzp28NyTlyvUM94zMxlqkk5ajry6s8l9cVcRtqNhwSal3UAGRQP7huQXHYSM0V
	B+eq8XsN7gTMlJ526VDemUOFkGrTumdvhu6BTTlCEqALiFuIjHlEdeHQIVwU7h2M0JI/4fGVc2U
	GMIMXOv1p+Fpqvsvm1gXRiOdDB3NCpgyhGz3+6idxUFxYxcp+nDiVHtJ+n7azw==
X-Received: by 2002:a05:7022:4588:b0:144:fb42:52 with SMTP id a92af1059eb24-1b39feb42f0mr7894237c88.28.1794218327859;
        Mon, 09 Nov 2026 01:58:47 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3755e8911sm12841684c88.5.2026.11.09.01.58.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 01:58:47 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 07/11] mm/hugetlb: use common compound page initialization helper
Date: Mon,  9 Nov 2026 17:58:02 +0800
Message-ID: <20261109095807.41547-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109095807.41547-1-songmuchun@bytedance.com>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 49954C0003
X-Rspamd-Server: rspam12
X-Stat-Signature: f3jfyk946p97oi6dnjjfbqn3pmjjnu7z
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794218329-466956
X-HE-Meta: U2FsdGVkX1/QP4mS53eAkZ0vM2+lAbiXaeFL4ZkEsl7fJn575F6Su5YBXQPVLSNduvbWc386IlI76Zp/fSYaQbL0tWVK+0vBry3cRxQ8/Y96fpS2LmQDyMCAjGXnZdClB4HstrzTOMVC5XaZNHO15vrW6U3n/+i+73ivGgpcC1znJqCdALrFLemt8tCB7r1ytuymRNnxtdmeFpZafwJkIjWE8iltvmfVoa9H29olAnBfpYL3ij1Bj6PaMwHxzxfZps/I+W5bwEvJ/hpnvJFaLXNrY6Zn70D9dwt2hUU4dHRrgYcP0ux7ZDcY41FESC9wSWXs0HUz+ON+wDgskd54BO8hOtNbzBMcdzs/e5XyXkoYNYF9WIzNNz+JFUBYJJ8feYPKuVnHN7Sdywx4r7yF1bwolxGpvScsRQQhwHNHjcXJD0U3dq+tBu5Wp/133tRJ2AMcu0YlDgG3zqiCvtaj5AFrwwo/yM1x4I4N7DBzaAqGdQd+iblOWPy25v4nexeI6nZxaSb6fr9WPSdrtC4tnU6AWQaXlXW+8FXP1fNAGVvsMzB0sz0OvixzjPvr0mTl6dKFvr+jndX2mASNhkSj4UClGhIq+XAs8SwjXq/AsfWdrAaKzs+igGL22YZhQL/oAirWc+17Fs2rLLDdJWB6g8N+C7R0/DPWEggA3CUIjgPSMys+qASpTGerxQhYd0lBydz6YCWDyNn81AEKzP3u2xfvu1NjYOSFDdrkI2IzBJZmfXZIk/BxfLgC0Z+0XneW6CP+W5+I7lPok8kWjVfx1tBaw2bArCCejb5buB/LPfXn8CnZlWsH0Ip0mug+/kpOSEgmX7Scu8xIrqUnSfWsOVx+ARW0DJPVvVKkmXMGIQlDxzFY5zJ9Yta3GGZnvGMm2lcX6y+LJ5tJfbBDxXptGu0XydovkpDoSjupdLgcT/nti1etyUS4BHyllYLm8EfRrkXLXSMx9Dn4ElWZJ5H
 CTSzECLX
 ldPO7kmGYb9jmQ0C/f/6so6wpoLoYYkVw3EKVn+5jiu4752p/EgU3VCQCTW8h4Tsj2ZayasRUchRO3OviRV7r452KpZsnXeMKTpOAcE7c9Zy7V6I+sUWewUEpWf8ezILAE4weQVxKuz2bs8qTNEFh39C8L+HyItb5S8hQI7XT6QamMO+sw2GONSK25DIbBsJzwtQb+UdIUQHw/bHXhASFyL9f2w0XgpdJ3WhWgmt34EACP/aC2SBlbg07LVyBcoOCgdtYKUQpgaIUzcfyl0VoeCJMx+OQGPZdLp06XdZcOz82YwzrsS/fZZt6YpW9mKpHtTsBbdPc4qQUjgUP2hm577iEjF4Wqbi198zRuK4roH/wEpcmH4qekPW4YBno78EWsGw1/ipACPEbVpjBNqXm1LwfrpwnwsSLaCU/QT3zOdaaCYOGFsSAcvP5PxMLb2owp5Y9YpNQwstPXZI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Boot-time gigantic hugetlb folios open-code the frozen compound
struct page initialization across two helpers.

Use memmap_init_compound_page_frozen() and remove the open-coded
helpers. This keeps the initialization rules shared with ZONE_DEVICE
instead of maintaining two implementations.

No functional change is intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c | 52 ++--------------------------------------------------
 1 file changed, 2 insertions(+), 50 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d2aaad235458..290e7859b2d7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3222,50 +3222,6 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	return true;
 }
 
-/* Initialize [start_page:end_page_number] tail struct pages of a hugepage */
-static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
-					struct hstate *h,
-					unsigned long start_page_number,
-					unsigned long end_page_number)
-{
-	enum zone_type zone = folio_zonenum(folio);
-	int nid = folio_nid(folio);
-	struct page *page = folio_page(folio, start_page_number);
-	unsigned long head_pfn = folio_pfn(folio);
-	unsigned long pfn, end_pfn = head_pfn + end_page_number;
-	unsigned int order = huge_page_order(h);
-
-	/*
-	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
-	 * we must initialize them ourselves here.
-	 */
-	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
-		__init_single_page(page, pfn, zone, nid);
-		prep_compound_tail(page, &folio->page, order);
-		set_page_count(page, 0);
-	}
-}
-
-static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
-					      unsigned long pfn,
-					      struct hstate *h,
-					      enum zone_type zone, int nid,
-					      unsigned long nr_pages)
-{
-	struct page *head = &folio->page;
-
-	/*
-	 * This is an open-coded prep_compound_page() whereby we avoid
-	 * walking pages twice by initializing/preparing+freezing them in the
-	 * same go.
-	 */
-	__init_single_page(head, pfn, zone, nid);
-	__folio_set_head(folio);
-	set_page_count(head, 0);
-	hugetlb_folio_init_tail_vmemmap(folio, h, 1, nr_pages);
-	prep_compound_head(head, huge_page_order(h));
-}
-
 /*
  * memblock-allocated pageblocks might not have the migrate type set
  * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
@@ -3323,8 +3279,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		struct folio *folio = (void *)page;
 		const unsigned long pfn = PHYS_PFN(__pa(m));
 		const unsigned long nr_pages = pages_per_huge_page(m->hstate);
-		const enum zone_type zone = zone_idx(pfn_to_zone(pfn, nid));
-		unsigned long nr_struct_pages = nr_pages;
+		const struct zone *zone = pfn_to_zone(pfn, nid);
 
 		h = m->hstate;
 		/*
@@ -3336,10 +3291,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		prev_h = h;
 
 		VM_BUG_ON(!hstate_is_gigantic(h));
-
-		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
-			nr_struct_pages = VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
-		hugetlb_folio_init_vmemmap(folio, pfn, h, zone, nid, nr_struct_pages);
+		memmap_init_compound_page_frozen(page, pfn, zone, huge_page_order(h));
 		init_new_hugetlb_folio(folio);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
-- 
2.54.0


