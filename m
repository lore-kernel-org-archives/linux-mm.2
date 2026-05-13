Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62631CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD0D06B008C; Wed, 13 May 2026 09:07:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8706B0092; Wed, 13 May 2026 09:07:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBE526B0093; Wed, 13 May 2026 09:07:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA9096B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:07:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 692CA12072C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:07:47 +0000 (UTC)
X-FDA: 84762423774.28.36C4609
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8517C140010
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:07:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XSGHZ996;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bn/gOs/8i5hYCJdtJbGnpMg4EbzU/bTW8mznM7ekqW8=;
	b=mGXUCFx+59LsMPEiPaVgik+gXm3n0CnA9dl5nOAU4kHBIBjBWF+2x5KmDx+CYp5J0J/A7p
	WDjDZWY+P69+q41T/HxC3bOIUMNsMj9FdUiCkcp5EQt9hpPTba/ovND2OpkugwAJzXeJwt
	22rZyCu0rsCDwXBOQKv0/iTgye/ySFA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677665; a=rsa-sha256;
	cv=none;
	b=YhpagFX2thZU/Nwma+72CE2kxj1SDDMmmBDu5DiKznO9r+8+lJ0VZdOf3PmApuKq3oQGM3
	3i4IHm+COi0umhNRRk906U2O6vrvy7hjDSsMa+HvT6bavjSJT6B4vnZRuYH3VIgnoV0E8h
	fuCVLSYRDoviWDKBMJa/I6TfZYuu0BI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XSGHZ996;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2bcd730e090so24778275ad.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677664; x=1779282464; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bn/gOs/8i5hYCJdtJbGnpMg4EbzU/bTW8mznM7ekqW8=;
        b=XSGHZ996dXnVvK9dc2s79GzddxuctJUft7JEFZ0h6HDXHQhTuDa8VKCTdzHRiGjHby
         mpUBXi6teRCGuCpaoRvWspqe8jdPEMKA+EhRANh79l7oJ/NMAa/HE/BH/Ytcl6JOLkNJ
         Sa3KHg9dvmlsRTYLruTZsxHaZuaCHfITaustCimdkY42sy2Pt/+GiXSLd99LklSOqkSJ
         ZxnD+CLd987Sxe/xs1l6Ok2BT/IclON6krpVbyGsQvFx1RuMzbYvX0hiGbTXDcd9FyNB
         1eFhzvtztyCviNIAXvBylBQOSYe7tzIPggj4JFJDduw/qLrMRmjBpUej9kmVqzgg2iL5
         RaaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677664; x=1779282464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Bn/gOs/8i5hYCJdtJbGnpMg4EbzU/bTW8mznM7ekqW8=;
        b=tJRBhmISl7Sqfkv15kfQMCvXLxytI5QBpRkYmOlFee0DkD7a26BZhuVI7qwvb6yLu7
         NvtlYDxtRGwCqfCI9cT+nxgqEbhpJbXzaHSVmpuufORuq34rt5h4WjsUDHm1WW9lr7Me
         3sitOSnkmlV93F0A0rabAcNdXToOR3/juP6EcFQ3X234uKSdnTIjrcONJrRBedErzO6z
         AViD5i/wdfO5F6h+IzZgXDofLvyZ/0eJlfzBTe7qJwpW7O0DYHOlFCmUb3bLrfdnzvls
         E3ItQkP7N9FL1JL6murI1iOvGsauf2o5uqNGzIG0UvhStljRSQuQgdpvyo3IQ1kyrMi/
         kMqg==
X-Forwarded-Encrypted: i=1; AFNElJ8+JOigjeHDGXGG+Tg2+hTo2EJchemfBqohqqsiUYr8pS3JN9VMTcxPeqWzsJy9nUomaU9VXYZbKg==@kvack.org
X-Gm-Message-State: AOJu0YywUCtJ0yu2duu3VEkiUBAPQqJX8RWH/friwP8nmw+NkO3iGF4R
	Cq2CP+oxtqdYyjyIIHaRHQwDzHSPVcwX73A4lEe+G7S8FTKuiBUxiIE1VA1JGL5BgPo=
X-Gm-Gg: Acq92OGQSOMu+e+9idckrFWR/ySxI963nShUfFxMJhb0Y6t6FIQfAjo1wnUd1Sv5zux
	I0ShenGtCdbTguAEMTHJYGoQS5XwETLM1zALbLBgoODyDQ9e+amBbAz73OH2UwPZ8Tu/9h/fHuH
	pNmELEmqwno+aUfvG/SxWYAK9yCgk5wb09cuxQxpHIOHCX+/7jimo1hueYb6tQynbyGfuhzdS8X
	Il+kUQEMfs1zopzHsvuX9JtJzvY7Sn5k5Npc+giAYmZt0bFtHIddv08eDWPk+tvGfhx3miOECEG
	6w23X0oFNg1C0M4P3sMQPbpH6n7rURMl0zDdyb5RfaejAttr3rtUK7OSaRBMWGf8XRZZUbTPbPn
	nR7ovJKMcUDjOQiAGLoN9D1Du3vcRbxJh5+FNlVCMi7WTrmNu+qfh6xunrOMOGKlCNiv0dWBo6e
	BKlVCS2En0G/5A0Ui5IybUXnuRWc3t0JaIKXqaegk+CQsRgdheFRm+DcHcKrM=
X-Received: by 2002:a17:903:bcb:b0:2b9:cd2d:6f14 with SMTP id d9443c01a7336-2bd2f4f740fmr22511335ad.2.1778677663953;
        Wed, 13 May 2026 06:07:43 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.07.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:07:43 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 02/69] mm/hugetlb_vmemmap: Fix __hugetlb_vmemmap_optimize_folios()
Date: Wed, 13 May 2026 21:04:30 +0800
Message-ID: <20260513130542.35604-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8517C140010
X-Rspam-User: 
X-Stat-Signature: witf7h9symk47k85ier5razpo3wuuhnc
X-HE-Tag: 1778677665-273942
X-HE-Meta: U2FsdGVkX19ark146m3Yep2AmzPJ5uPN3uEkahIWQS0sUaaxFVpqyn67rUuZKg6lDXb6lL5gVv3N7ycVEztyDUl1GX5xUJe0Ypk+QCp8YAGXOLEJaorELKnGOYhdHzEg0zHMjlhq1YGDP1/hqle3nUlDv4FgV9dqcWfPdLVknkBDawJW/88hAJnYTiwciEm2fOJOOj9HjLKR0T+yo6/tsIUBrToShBYrOCkQxrL4UNueBN1jp7UY3yyUKpqpnaLOzHOaPHEcyc2KBvRYjyuXh25t5Ek0zzkoyvbIJzCBPAiXvF38UDMC6594QABSKJO1JZ+4ph2d2HHQ3w2zqRAwfQ9EnrC2HJnxh47hZnN6fhSyyeaWvwyADyZJHgi7brqH8h+AfumkjeH/jjqrVcgBqFpKRQiXKh8IBjda3941CNZ71EOILl/AAH2l2uvYW2bDJRx5cOX6x4F6FEGRHrnLnszRzgEEt6+zI/KJeHHblbjGH1quD319vik+YJtldVyGB+6ipR4KvQPvLIIN2XUDgvl6uQfUlRzRYPd8Qhtj88OnMMCIPGckxieOVi+rl/XaccR/godhvyEcdgodCbQz0Z6hOOJyUW9kPJUdYBITa9G40ULStoj/E374Bs9KU7f2wCshDOAZrAc9FO8Ck1deYqzOzlqn18pyxtfiCxf4DolqhnKpnPgxtTdnyAhCwhZFWIaaXO9NHMggBJutDb43DGDOixIVS1Mvqpy2j+J35ahZN5xtrM+JkmedJVc+xkzTa4VU7nBI1sgqHdxYUFmhjd9NQGYPavU+M2bBCMkXx0nVHSGvyLIDT9/gFybg+lnPtE98EhRHKi1ojCTwZ5VDcFgEug2COHC1cOwMbyuM58vvg8BPIWIz7NBYcccxb+kM+xkxRbhVwntG5qYzLAwy6wd4/HtDaphBJk6+ZROx7a4klthAedTA/dYU4egBB7NOmuVh+lYop8ZpJIcOWcz
 kUnK2Yng
 XqlbXaY7E1ETvRoxY8Ur2hfN1nyJ+aK0jTXwC259/8bZv7FK8UzJp0M1TOETSW3JPM+Pi6EEp8/723+jOgz9ZaySlCg8TtYEwSJm4mnuaWiLNtxBEZHHdxD8xde3ynzlJeMyBoDk7izC4DnN0JoeuSdI+9r26eRUXYI+7D38QlMdxPB8bOsSOMFL9mqY+KFNA7muJt/w5qDk1PXzStsM1uIbcf81eUXeBXgpMIDp+Ut9j0/7Cswtb1N1utIbpD5X7jOk3L0Fu/xyp5LSvqRUNhWbPW3SLOHwu/LBJ/g3zGD+0nE+N1VjG9XLXgFC2eWz+FRBMYgqNdEKBIzO+B6mrsqSpS6Qvx4CGF3GkNNT4ziTBdNc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__hugetlb_vmemmap_optimize_folios() uses incorrect arguments when handling
bootmem HugeTLB folios.

The section number passed to register_page_bootmem_memmap() is derived from
the vmemmap virtual address of folio->page instead of the folio PFN, so the
bootmem memmap metadata can be registered against the wrong section. The
helper is also given HUGETLB_VMEMMAP_RESERVE_SIZE even though it expects a
page count, not a size in bytes. In addition, the write-protect range is
based on pages_per_huge_page(h), which does not cover the full HugeTLB
vmemmap area and can leave part of the shared tail vmemmap mapping writable.

Fix the section lookup to use folio_pfn(folio), use
HUGETLB_VMEMMAP_RESERVE_PAGES when registering the reserved memmap pages, and
use hugetlb_vmemmap_size(h) for the write-protect range.

Fixes: 752fe17af693 ("mm/hugetlb: add pre-HVO framework")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 62e61af18c9a..4f58cd940f61 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -635,12 +635,12 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 			 * mirrored tail page structs RO.
 			 */
 			spfn = (unsigned long)&folio->page;
-			epfn = spfn + pages_per_huge_page(h);
+			epfn = spfn + hugetlb_vmemmap_size(h);
 			vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio),
 					HUGETLB_VMEMMAP_RESERVE_SIZE);
-			register_page_bootmem_memmap(pfn_to_section_nr(spfn),
+			register_page_bootmem_memmap(pfn_to_section_nr(folio_pfn(folio)),
 					&folio->page,
-					HUGETLB_VMEMMAP_RESERVE_SIZE);
+					HUGETLB_VMEMMAP_RESERVE_PAGES);
 			continue;
 		}
 
-- 
2.54.0


