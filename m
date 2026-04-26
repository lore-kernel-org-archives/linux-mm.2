Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8571FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 09:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45A706B0098; Sun, 26 Apr 2026 05:27:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40B476B0099; Sun, 26 Apr 2026 05:27:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 321C26B009B; Sun, 26 Apr 2026 05:27:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 23C106B0098
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 05:27:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D95321601EC
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 09:27:42 +0000 (UTC)
X-FDA: 84700179564.18.784A417
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1107980006
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 09:27:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dSFst2Jb;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777195661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKHGjwyqOWL6rVsBt0Sw/YSvydX7Gt+2C2Tpk5skGPU=;
	b=5cBnyvOZjckA6KansdSyA5KCq+RNRqdQUpBi60wD298brVtThE/cW56jepRT6kaaUIhUpt
	y/W4KoARb+LtpIMtLbXfzImeIKxku688LQewyoJSpra9XTnmBAr5NUAdJQKLnrr7OMQp0e
	pPy2cOaSiw0TASO/p602z0I3cqLhHxA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777195661; a=rsa-sha256;
	cv=none;
	b=UQbRDhk1P1CUhdo54xLR+UOPbVrTUDfionh4rTvX8C09kxUtgyCOgH8iQ1umYF5sLPQtGs
	sqZHAl/rAc5HuyGigRtbDHN+C0a5uHEFUe1LZVAl4dwW4Z89sCeB4k78HuF8HV0LrdAU9s
	MZqEKvMHGtOa9Pzpf+ntTI/DD/6OGp4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dSFst2Jb;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2b7adb38d65so30870375ad.2
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 02:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777195660; x=1777800460; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sKHGjwyqOWL6rVsBt0Sw/YSvydX7Gt+2C2Tpk5skGPU=;
        b=dSFst2JbBhmX+1eIMPT3ez+zDAidvlLM37/mgvoXqzA2yfcKuYLqof9R2ZhLYqfils
         WGJOMGWLhTpWLpTVraqIT2fASkyMjfs6X8rRUHKZu0V62khdK71KKpZD1e4r0+fDqL58
         IjRjSFGj12O+/BVbzS22PVFAFbtRu0HcwNAftymkSpAN3Nn8Jawv3yNXN9ErGo+Q/F4+
         Oenav+oLgDdIe6HcIz7rwObivGIvWsdrRtbdGuDXdunu2/dHU9hoPxE42mrFWCUrVF6O
         uz9jviMC8JO3BSRFpnzdx7PMC4WxBrfbw4IwY0qS0pvLv4HZUyF+nVapIzbI8mfvZZaf
         HW5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777195660; x=1777800460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sKHGjwyqOWL6rVsBt0Sw/YSvydX7Gt+2C2Tpk5skGPU=;
        b=VZ9F1zjVhBXQVq2hOKIkgUjU+TEVznNGtWc8pcsmisjcTuTtPgM/WERYYuyuDNC/Lg
         7wZPvV5W8dS870o/XU8p4MSTIVASZSYV+bgVGMsqvL1SbzP73/SgmwlL/DluX1wWkWoV
         gdorhlNdRG/i5lV7cVRsWoaKVivy5iUcnM1xzgwu7iMQF5Q2Dky0k0X0I9YcCGa302cp
         M8N/siyxEonAltqGfipZsI4B7ZvQJ52IGUwQGuK0/o6XjnNLk30YqrIwdWaBjnAl9rgp
         8MihoDNrIEGVsVghN6GUG5tICRHfHG0Zd9eUyeyajzpne7jIY5dY4sMsABChI0ILQjW7
         OAew==
X-Forwarded-Encrypted: i=1; AFNElJ/xwSWzfjIm4buB1plMr1oq3/CGSFpTecQQNbBSzTxvbcuR0hzGZYJlHWdbe8r8EzMI9UVLCsBIag==@kvack.org
X-Gm-Message-State: AOJu0YySEIY+ePvjbzEAGi1UHkjm4JEIs2l0NjkTHTvpNPJhOYakgw1Q
	bNToKq5eSAA2Ysfk2QonLk7TkSIWN5GL61eTOxOXskta63xWLA4sGMrJV6MzVYCoINk=
X-Gm-Gg: AeBDievjrUx1PGxwNzKJn1Gss2ewFgbRIv09D4dO+HdDvyklSeMN2rutc9WYkcyVwvI
	UXbdf1S7W2VhgI7FoAGb+HTWRw4/EP2QP7DdVTZYKUJlpmpQ6+PNR7f6KVrcvGGHgD290FcInWl
	KMFF1UxQ7TSxfrYD2jQ1nMjDMHCWbE5Qw9i3xHNzPVd/ifotkJ2t1Cgh/KNzq/bfB9V4kWlrUeH
	IIJkF3fNHvUyUVslKY58khyZPvJVMlXOzBGUX5molqMP2/3Zne8ZUqiWw89hSj4QoPpwP4nbkgV
	/aNQS7FSHtu/HvCYYlqNlJWFyxoInumiI0WT1000vva0pjrRafFIWW533lN6B2AAkbC3R8Baq/K
	i7iSIbjnopOIKPPVc6atjWxBWf+uVPeusKKW/SLS/cWslgaufUraee52RwD6ihjRNywyUOZKVqO
	En+hAgawMzZBGdI4NwP763UqtMRHN5
X-Received: by 2002:a17:902:d652:b0:2b4:62bd:ee3 with SMTP id d9443c01a7336-2b5f9f5eac7mr310134635ad.33.1777195659828;
        Sun, 26 Apr 2026 02:27:39 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::34a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0caa9sm270352885ad.40.2026.04.26.02.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 02:27:39 -0700 (PDT)
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
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v7 6/6] mm/mm_init: Fix uninitialized struct pages for ZONE_DEVICE
Date: Sun, 26 Apr 2026 17:26:40 +0800
Message-Id: <20260426092640.375967-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260426092640.375967-1-songmuchun@bytedance.com>
References: <20260426092640.375967-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1107980006
X-Stat-Signature: im597f8zhnmetswjn4wbmcdpntew7i7t
X-Rspam-User: 
X-HE-Tag: 1777195660-627824
X-HE-Meta: U2FsdGVkX18Qvr5fg/1aLBrtQWbJsJxAFPp6PwXGmL5X/9kQZp6wlLvzoElb7bxflg2Ic9rk3d6D3rC9cqkDwIAlZlFh8p9OgDUE9EkNpE8ZBE44c3RIo6Lg0BEuhPxU5aRXp83Yp+uIM7iaj1mFU4d+v3z2t/tdUbnO6VHeuLI49tfdlMe7o2AnyV8q78uYGr6I+8ETkYsDh8GV8L0DULgWYsTcbuO4hsGc92CTt4MLZjDxfmKM7j3H+rFklZu7A3+MiruSp+4d8/bZ//RFNTRy1kIlOQmBe/5uMtzIZKIiztuJppyThLSj2D7GPNiE5AZcetI/kj2yEI0OugbE1d+cl82P8c7bvP2879D+mvf3l2IEMjWl3hpUP0z/+uCtx/B8mxnnjRG2FUYbmVaWOHv9PQgpsXdIrW9tO8iDrJffsxWZlPX4fohvVvC4+lml+nL2dWvOPg+6tdzostYYi/ejVBwosaaMSYfe4psdRHnk/6NlTbVFQRGcbSNwEXcQ9hHNKr43UR3skXD1E443cyqXiYFYOUXEOSNANvrNxwnrooSl7o+EOUA098zOmjy2S4Q81gqLlQXCyzXm7qQ3wYxh3vp7DIydMjdom6UGkAlLtIsssITzPso+8FcT8J4G3xK8qsEM3NQXNEBQxZqzck15qhfIm6R3lxZqeFeYaQurLRHdjmNlxrfBPGpPO5hDY0GIEs0vCvaWUNa+AYicA/Lol57G8GT4fEOTP35Ka9i7Rooy68l64BPQwsCAqzJRPyIdBrXtv4OT0REintLrTscnnjPWZT1I65ThlhQ9xYZ7CYCF1ZVhGGxfhdPIBGyOZcqbpNZS3oV9NcJXDv77SszEdt6jBqCDqV8wgGSSNGsvCf9Z+ixEwS2vSgEyTi9j3coA+EFJL9hslBjg1bFruh9Wm1eliuKJj0v1ys3NjV8Sc/cEJ+i3wksO/jE82pvOKR1SpIMWwzlgoeU2eJ9
 Otih8eoB
 awW8HXq49KECrJ+z8zMYyHPHQy1+7QsncCJ+t5qsswmmLPweuy18PW/AJRAjJ6Pqz7ag6rXu/xEk7tb28rCtfCEPEpMRh6QSs8UIctF54CPSnfiX9v2bnl0XhkJWRzdv6tQbrM7Nx0HhX+QbMeIUJVPnT/I3tEPklPont7S7D0kOjo34DeTNG23TJ45f4+ytSZ3sTnnPL/uW2gGqQg6Z0F5K1f7CrOYInYgJmoqapmeEsa6b29O66mYRpRfuQ5Ixo+88BxjSEaDuJ+aJTvAJhhulEyLd1ms+rj9ZpQIYmfiCfCLFTKifTx07lyGKz273OaxOGapqsbijQvbN8ZYsNeOeMWy6qREo9OPy9/v5hOshowVrbSjvmThWyYtxLvzfNRsrVl94qV/OsYg8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If DAX memory is hotplugged into an unoccupied subsection of an early
section, section_activate() reuses the unoptimized boot memmap.
However, compound_nr_pages() still assumes that vmemmap optimization is
in effect and initializes only the reduced number of struct pages. As a
result, the remaining tail struct pages are left uninitialized, which
can later lead to unexpected behavior or crashes.

Fix this by treating early sections as unoptimized when calculating how
many struct pages to initialize.

Fixes: 6fd3620b3428 ("mm/page_alloc: reuse tail struct pages for compound devmaps")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index cfc76953e249..bd466a3c10c8 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1055,10 +1055,17 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
  * of how the sparse_vmemmap internals handle compound pages in the lack
  * of an altmap. See vmemmap_populate_compound_pages().
  */
-static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
+static inline unsigned long compound_nr_pages(unsigned long pfn,
+					      struct vmem_altmap *altmap,
 					      struct dev_pagemap *pgmap)
 {
-	if (!vmemmap_can_optimize(altmap, pgmap))
+	/*
+	 * If DAX memory is hot-plugged into an unoccupied subsection
+	 * of an early section, the unoptimized boot memmap is reused.
+	 * See section_activate().
+	 */
+	if (early_section(__pfn_to_section(pfn)) ||
+	    !vmemmap_can_optimize(altmap, pgmap))
 		return pgmap_vmemmap_nr(pgmap);
 
 	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
@@ -1128,7 +1135,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(altmap, pgmap));
+				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
-- 
2.20.1


