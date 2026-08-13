Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88A5AC5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 17:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E7996B02BB; Thu, 13 Aug 2026 13:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99E5A6B02BD; Thu, 13 Aug 2026 13:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 860146B02BE; Thu, 13 Aug 2026 13:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58C3A6B02BB
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:54:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 57EDCA233A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:36:29 +0000 (UTC)
X-FDA: 85096950498.18.F530989
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9843C140009
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:36:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QZ6OwOIV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786642587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p0ckbLWugOOUGCY6PMxy8vsH8dtr8rQdR8d8zrRRsVc=;
	b=MIkUPiSLAT84YqTJeLUmdN+tWCQqdoAonp0GyC2PB6eLUzRvl8KGIIacm0zpI1uzK8DaXA
	ENby2ksWEHOpJ+G09DW3WquhU0xwIByZQugECg2p0psLeWrrGerfPrERIy14dXoP21ekQd
	RKz3Pf8iyQ0sRJiZQr9GSG4r8cN/eLM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QZ6OwOIV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786642587;
	b=pOFToMTLaYk4RyYLxjjWPMIQdNTGDwk2a/5UUTgU6OwrOt8xDQU+kWBZT8qV7ps5YopChR
	TsIyL+vSvww9HCSZR+30pqhw8DicbHlRz3u9RnOYsxs3LptNUHpkbsjfU9vbO/uOis4EQC
	UmJTpqMOr8pZYHLBiPpkXtgHwQD7yMY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D925600B0;
	Thu, 13 Aug 2026 17:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171001F000E9;
	Thu, 13 Aug 2026 17:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786642586;
	bh=p0ckbLWugOOUGCY6PMxy8vsH8dtr8rQdR8d8zrRRsVc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QZ6OwOIV6rnPZ7gDW//HB57G0jreHQ3d0pRsOiPKbI/u0+vpItGyz2BKfdF3roLos
	 jLuBLuws6qd9Xepg6sAzESfGaaDZh8sIkysFXu9qEOXl8VIGq0pX08wNsSl1tXnzgM
	 RzW0q2FCKrXi3FF7ErrAUvRLoSVu78UIUvBDqgzuQKHW5hKBmaZmqZH4D4Oq6OxFFo
	 LAGKNBQevXYf6YqhwSznZ63wKUSLpV6AFeVyjkoK9HbQ8IklLOCoL4JOQcBfoBhmfd
	 JnyG5EGLVTook5lrh3MF/eEEeaYKOwqwnVGKsDq5le5qtJkrr8yr5z9SbTDvvL50wm
	 W1NraZ6QVjotw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 13 Aug 2026 18:32:27 +0100
Subject: [PATCH v5 10/16] mm/rmap: track whether the page VMA mapped pgoff
 is anonymous
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-b4-scalable-cow-virt-pgoff-v5-10-c21581c0c3c8@kernel.org>
References: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
In-Reply-To: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>, 
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
 linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2340; i=ljs@kernel.org;
 h=from:subject:message-id; bh=795PEltcwnxXCtrgqOcEpUiQ44/tIXKOdzD9y1SPcjQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJq/6+5yFEtVfRauCfxzfpoC4mgIKvnczfxaAtwtuW16
 +1QW/62o5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABPR+M3I8OTS7YWmL358cbo8
 d1nro1b2P8+XTl0ft0VdYHOJS9fTlD6GPxwpba8V47wMT5lzv5eqvF4rN/Pnz2CxZOcM95Tlehn
 lnAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: 9843C140009
X-Rspamd-Server: rspam07
X-Stat-Signature: ry6nsap3kgbx3iyspbt7hkwa3mcg8ag9
X-HE-Tag: 1786642587-432980
X-HE-Meta: U2FsdGVkX1+OuiW6gsMfMlbrDZV3J80dvwT/0YCneICr9rpjTcWOwId3wktQIloRW9dSHDX7oQejpYCg1pFANaOyaoDafPYmJgeJZaF6KgBt8Lg0hDbgTYx9Jw0P5RRP6ZJbydEzZUhTqDV4Ij8K2t3NpF8urc+RQGeMS80oe/j46apu8V/7ZYG/ipnFF+ZXhEb+Q/M6Rijm/wwaKAM74w7pvajJjw1IjKldnBVH4T7MximfazLoej3g4DQsqbzHtqf0mfAFRiy9INEy2ekx4waxdVCkCfgw/bIKJwXiXQDmxP3uCGMWnrN0iCkwhlVs0Qkpt4PpxPIJqo00XhZx65Dm4aSaueGVVy5Ph9cTe+cwmq+aOUfFUedVok0QDM6OOTSf/7PIXHcrUCG/cNFmADG/7JDMqMRhjNKq6Nu8No+xkKvkTX82LpVxr2Y1H9WnW8kGekU9BjM09X8FGLMFJk9zg02GKOMkpR2kC1uhrWjO1wR5ZNt8mgIMI9IuAok2FNQKjSEE9c7VLnjTMac+foH4kiCyo/YDagdGwAd4aMi0ej6Y3ke+tRYNDDNDpBIQ/63jFOKQvwauWasCB5NhPqpNL5Wloeyf1utZbrSjL6UnMKL2JPzaO0Tbxm3Xc6Kuy78/yfk9FNzepv4psiUp0oxiumGG1yZz6akvI0JlFIAyaTiX80RuMtKWiU1C5LQo5kQhGFCKnc2T8hWQneFJmHvxlZwu8YkAMPLKIBH23nKD0jg7p2KujedbWEvvwqwWCx0bZsW3vY4Szf1Xtzqm3+/AJG3pGCR4anffv/nLBLGzlxmM4F49cbDZKjQuO3TuAQuYNMVKP4fBkdz0uVT2MnNutchMZG8IWqPNGKIdWmNPG0VRNMqM3fRc4WYMHScMtXz+rvBzSdKyW/iovM37Y4+S5v+drzi0LkdwOVEdrGshHzuFloaTkhjYp5Lmvyi1CjoVvCSe6kozsQWf15A
 Cj1k7vI4
 etAG2dKx40Uj+2SXXbR5fmpEnw0kRBuU9GJTdhGA3VBrtF6lsSQCyt8qcB/rZESHC9bvvrhQJwsHqpVhJmatARQK4aCmBJLz4+G0oh6CGLlZdJeSZo1FEZAYoVYRB7nnXDsGcfassM1f8TZ9yleUhUrgg9PWFlFDcFOKM+tIYSZ6lDqiDemWR0u0nrUjDRCRbvGQzqns+IaHKDI5rugyJWWBRP4fuvjgg14uvqXW2W8ZZpRKGQYZuaKu3z7aL+H8VagLmU7q+ZokOEGacOYJ0AakJhuQc9A5IItGV8AnegtmYXclFIg1nmSgiVGLMMKJXJFlz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the page_vma_mapped_walk structure to track whether the pgoff being
tracked is an anonymous pgoff or not and update the comments to reflect
this.

This is necessary in order to determine the correct VMA page
offset in vma_address_end() when pvmw->nr_pages > 1.

Also document that pvmw->pgoff is meaningless for pvmw->nr_pages == 1 and
for KSM.

Do not set this field where pgoff is not specified.

This is laying the groundwork for eventually using anonymous page offsets
as the index for all anonymous folios.

No functional change intended.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/rmap.h | 4 +++-
 mm/rmap.c            | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f00..0574537a355c 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -864,13 +864,14 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 struct page_vma_mapped_walk {
 	unsigned long pfn;
 	unsigned long nr_pages;
-	pgoff_t pgoff;
+	pgoff_t pgoff;	/* Only meaningful if nr_pages > 1 and not a KSM walk */
 	struct vm_area_struct *vma;
 	unsigned long address;
 	pmd_t *pmd;
 	pte_t *pte;
 	spinlock_t *ptl;
 	unsigned int flags;
+	bool pgoff_is_anon : 1;
 };
 
 #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
@@ -881,6 +882,7 @@ struct page_vma_mapped_walk {
 		.vma = _vma,						\
 		.address = _address,					\
 		.flags = _flags,					\
+		.pgoff_is_anon = folio_test_anon(_folio),		\
 	}
 
 static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
diff --git a/mm/rmap.c b/mm/rmap.c
index 5798427d007f..ab3f879454de 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1240,6 +1240,7 @@ static bool mapping_wrprotect_range_one(struct folio *folio,
 		.vma		= vma,
 		.address	= address,
 		.flags		= PVMW_SYNC,
+		.pgoff_is_anon	= false,
 	};
 
 	state->cleaned += page_vma_mkclean_one(&pvmw);
@@ -1317,6 +1318,7 @@ int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 		.pgoff		= pgoff,
 		.vma		= vma,
 		.flags		= PVMW_SYNC,
+		.pgoff_is_anon	= false,
 	};
 
 	if (invalid_mkclean_vma(vma, NULL))

-- 
2.55.0


