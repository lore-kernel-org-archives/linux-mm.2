Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3C1AEEB577
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C19A6B008C; Sun,  5 Apr 2026 08:53:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2728F6B0092; Sun,  5 Apr 2026 08:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 139E46B0093; Sun,  5 Apr 2026 08:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 077F66B008C
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:53:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ABF5B8CB9A
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:53:43 +0000 (UTC)
X-FDA: 84624493926.24.813A9C3
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id C859C40010
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:53:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MtmnNSQM;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svlwS891ot0oMz7BvAOAaxoIhgC5OOWs0OTR+KAyilA=;
	b=CAFOrsZOjwOuVyJjDYEOLpDJoh0lZbYbm2dkUPEToaE8RTqa42KJiOBOH6DIzRqXJS0xq2
	YYpX0OQa4zDWt1XT3geb0xSaB4U2u8fHTxfBTBjj/JBOF3qE1dQ7Gikosw5rfigI9EyiU1
	IYPL05xHeqp0Qxk7HhUmr/SsCFqOE6A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MtmnNSQM;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393621; a=rsa-sha256;
	cv=none;
	b=5wtmCeUeIRWsx1iPn9ZfQIRO+bW1QNYa9zNIyqN8d7e+OqDX8g7COZIbcCUxRohjiTZxuv
	MvmqJe3hZVnOhSHUeVCA+m3VQGZmHirqDNuLyQ5sp+1jKAF7cx6JpZWmWUezHv1WqqCo3+
	cdQ8EkC+egx8PRk8WE23BeQukrACiFI=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3567e2b4159so2008897a91.0
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393621; x=1775998421; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=svlwS891ot0oMz7BvAOAaxoIhgC5OOWs0OTR+KAyilA=;
        b=MtmnNSQMSkzkoyEy7nwWcYT9cAtrbpz8D6H6aD0sXRxbz8h7WmZ2KzF2W/+BngpmNL
         xaYEuWuaFfdK5l5Vw+zQXRDvO4unGD2svK/DAdscgtbTqHrm9Euxf+3tbBvRFhi2J6vZ
         lmp4iV19sFBpzkkAPA2SXQziCbQdJdgxv63EphMKmSB8ymUM0FhqZihLZTMTVpbJ+w9t
         k4yJGuARHN/VtiyjnS5n0fMkl/WSlkH2bZuGxgqXg2n6swKiuTbATolVCvlszC1gDI7Y
         33gcvyLTIXSybi4IzyyoP+ShhvLG8yrloDRFLMJINaBh0434bGMpMKrmFf2uZGpoZZqz
         avkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393621; x=1775998421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=svlwS891ot0oMz7BvAOAaxoIhgC5OOWs0OTR+KAyilA=;
        b=UaNCnwUiZY514tPQb7gsIBVqDrmcHxfwKz9l9bmr1ywTNxyy+5+pyyj584fbZKrrgT
         MponGgpCXFOXhmjqQxPuaPTxhd5/c0VixNpcOPWv4M8cW5mc4kdUAbYZ1VRKsrnRAPOn
         dmr3+WC9vkQNSM8rVgutef2SHhlBUr59a3AH01PHQ+WQxj4bc9OTgbZAK5ZOEK7FhiKx
         TaqI0fkBp1Rqa9MMR9kBElsO+/MlFLMt/s9MJpkS66BAQpkE3B01GK1wgM5Bue//g3/H
         CuN3lJC7vTdDoxP2IX5cYyR/khop3CLy6I/SX8x4yrySWriFQFNUvfyZDs6dByfHU764
         GofA==
X-Forwarded-Encrypted: i=1; AJvYcCXhq72L6yz88tFumSeolva4wHV22jVxM8fVe7Xgr5iaS6zJO1vW9vX+kalITctlYPdlwj9BSYWKlw==@kvack.org
X-Gm-Message-State: AOJu0Yw0MqXBEXPpHDnm27fqoBfZ2V3vcsEPA4tVIPC1rgE9TsjX17fP
	SO4a2dG7NnQPLa9vx7N2hu+3MiX7jnYAhJ4c8VQ+s5azc8nMHzGOY/sU7wvzZvvRoYg=
X-Gm-Gg: AeBDieuEJnot9XVJHyFmac3D2UWzM9O9QWhGRr+3+mfCaIoLx+nyiXdSCKYdQPBnuwI
	2R08bqov9lJCOM0Ppy37oWM3bvHEHY7qGcAWB5O84DK47CIUsapQzhRWFDQgzEi6unqdP3pzXIZ
	TZ/zcGrTld1C1bWYnLIF+kQBhFKWXYb4hkVLZPmZtHh29HKiRtulQUlNUbr5FZPqpZiBeYVdlgH
	4h6r4Sx0/TcDG9dFu6BYWI+s6Zx4IjDT4UmjPjlmEs3IUSuRTIeZVLFfnDhreFBB0M1Sf0lifvo
	fkjAgZiF6c+rU5f2eWqkH5QHsXeJc5Rioef4tfq7f0CTPq/uBmqAyyB84fQmH/DjqQDZUVByLjR
	8THwccAgZBgb8pNpqVOPIZtRoi5YQUqA1XN41z+w4Ze4mdzx/q1tnkuXKVy+NbwszyZfEcxEAuo
	0F2kCdbOA0vbT8dSnFLAf/nXAsPedHb+ax8HLW+231hpYOcVCNgAsN4w==
X-Received: by 2002:a17:90b:3143:b0:35b:9777:8bb1 with SMTP id 98e67ed59e1d1-35de68ec770mr8284643a91.19.1775393620585;
        Sun, 05 Apr 2026 05:53:40 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:53:40 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 03/49] mm/sparse: fix vmemmap page accounting for HVOed DAX
Date: Sun,  5 Apr 2026 20:51:54 +0800
Message-Id: <20260405125240.2558577-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C859C40010
X-Stat-Signature: 3h4teiqa9jouaakuq43ewixodt9r4ky1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775393621-853729
X-HE-Meta: U2FsdGVkX1+siayzF7dWv+QhpUYTUEn5ZAaDIRvTQ3ddpM3TVxa46GoDR1iniQq11aTYYnK1rD2U8rCD/nneTJkvvhJGLQ+Jmin8tcFG6lSROCUTZxQNen+Vgf5l7KdVn1OtZEOFhnEQp88xZRYxs5MxLGTCdVaOTo9XaYgZoS4zCV8HD2o0kwY9Eap3g9snJ5A32ArzYLtmR6VTNIk9TGIMBMnnoMddnVsCT6bb+V2n208GLYFI10oFp8gs7K29coNLKzYveic8rlR5mcL0dsIZhSAhV24AKWAnFo8vCTblfH2ZOEHjV+8K8EWayKflc9WuiUHrsiLzjxor8cPhGNAuTwwRf/WXC6rc0E6ZzRbWbkQzspiUV2/E/2S+9aVWs0Vwdq9CXge4oxGSXDxgQUMXIKGv1lGfFb7a835XAFWBDsHv9gK9Ld8F0g8Z26J38NKzVIHeD+MdbMQwdpt3bbgZTmWhHJBTwQU2pMh9Cerad7OisFqWqiq2kvyGIFFj4VjXy6u6ipzJQaAHZXWmMbcvv5dFJhjW83d8gtfHcR5qkDEKzLizL/PzqWKYTG+Je0+lXYI3YsROHeSvUZI+RwaSedLF+fbC124yfoo1l8QhI9F1SxYw+NHlqFnm4nyN0f556poV94jWf0J2kHk/jVPPl3kZC0zmxcOgzI+kdEo+4fbd8mV+05XsOuLN3xghUDttxvQRCe3czILwxcW57Lr/cg6MkIc6lS2NpjA4r0K24NtRLpjvS8iz2E1QNUmIbLLDT6Bs9mVSYxw8CuCFLzasOOu8iJ3HV8ukrQw0USRSPoU+c4axjxr3GFhCFMYK2hWkWy5A6B7kW6M7kWUFO4YMQrfEa157XtSgXiRkeL+5yjyvIvqRTA87TQ9qiONgVFwjXnUber0i9TgVHiuzZ2IZM28ZCj1UzS/eFZujsiQGZ4Cjwj5PGPL/9rZ4VkdkvbqVw5h8xsigaUu0jAj
 coK4lXP3
 uNkez+jQA76+ncZgg9z9jQ/FsaVkZwvb7bnBgpXj13+6zN9M2EL5b6Z3nM9VuPZpXkFWnlVSsXqZ4ovp/H8qCUCsgFPIvPFtQzd4wvzmaqtyisO4L4ACyZnn92McpLDQn4+fLnDTb9sNMr6N0I1tbwx+jbuROG7/RZZVeGwp1X5bdM6DMgEEO+LqD4LJ5PP89qbIy24CwvkEnAcmM1bncI+kJtr+pqm9ka2b2FCC04zmFyPc2kJXqa1DUQja57o+wUa/qex5wKJI3rtjyVxRDxVat59ZAo71f6qfcaUL9Aq01jg2hyr8NXGUDIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When HVO is enabled for DAX, the vmemmap page accounting is wrong since
it only accounts for non-HVO case.

Fix the accounting by introducing section_vmemmap_pages() that returns
the exact number of vmemmap pages needed for the given pfn range.

Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 7aa9a97498eb..0ef96b1afbcc 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -724,6 +724,27 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
 	return rc;
 }
 
+static int __meminit section_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+					   struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+{
+	unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
+	unsigned long pages_per_compound = 1L << order;
+
+	VM_BUG_ON(!IS_ALIGNED(pfn | nr_pages, min(pages_per_compound, PAGES_PER_SECTION)));
+	VM_BUG_ON(pfn_to_section_nr(pfn) != pfn_to_section_nr(pfn + nr_pages - 1));
+
+	if (!vmemmap_can_optimize(altmap, pgmap))
+		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+
+	if (order < PFN_SECTION_SHIFT)
+		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
+
+	if (IS_ALIGNED(pfn, pages_per_compound))
+		return VMEMMAP_RESERVE_NR;
+
+	return 0;
+}
+
 /*
  * To deactivate a memory region, there are 3 cases to handle:
  *
@@ -775,11 +796,12 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	 * section_activate() and pfn_valid() .
 	 */
 	if (!section_is_early) {
-		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
+		memmap_pages_add(-section_vmemmap_pages(pfn, nr_pages, altmap,
+							pgmap));
 		depopulate_section_memmap(pfn, nr_pages, altmap);
 	} else if (memmap) {
-		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
-							  PAGE_SIZE)));
+		memmap_pages_add(-section_vmemmap_pages(pfn, nr_pages, altmap,
+							pgmap));
 		free_map_bootmem(memmap);
 	}
 
@@ -822,7 +844,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 		return pfn_to_page(pfn);
 
 	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
+	memmap_pages_add(section_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
 	if (!memmap) {
 		section_deactivate(pfn, nr_pages, altmap, pgmap);
 		return ERR_PTR(-ENOMEM);
-- 
2.20.1


