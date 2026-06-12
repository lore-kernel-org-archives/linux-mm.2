Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99D8DCD8C9D
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 049B76B009F; Thu, 11 Jun 2026 23:59:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3C6D6B00A0; Thu, 11 Jun 2026 23:59:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52B36B00A1; Thu, 11 Jun 2026 23:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D3E0F6B009F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:59:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97BFE40735
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:54 +0000 (UTC)
X-FDA: 84869907108.02.141A86D
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id BA3EE20003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZxVxePro;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yvhwqnMK3KcBoOi11nGPI5ToHj8BHKdLuYKZ2RNMESg=;
	b=fTJOvOQVyPzxF/TfHrigE/haGYCpAKskgrUgK6g8mrZ9j/351P7QxUexYhxF4SMXJzegDL
	agorklRuItXttadxeLx2qrQ1rlAfNlhcksMybpArBuC+Z7bjf2PkK52Wt1IDPX1b6gTCHV
	gZSufTxyqu+9niBRAN8Rp41HiGGFXXM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZxVxePro;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236792;
	b=zN18rq/AaTa4526db3fAXs+apzOCW+i1wXWNrpRZQBpnrtv38TXkT8BOyewXYFKQt3bBgo
	usSZFAA0vmbUwEO6NMuOkhaxAZzwyQLFqVs8PSFuHhoiRH54Un4CR1DqK0idGwVRCKTcQ6
	xEysN9nvnFR1Cl1bFP1ZIRpPU1N2sPA=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84275887a3fso1129273b3a.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236792; x=1781841592; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yvhwqnMK3KcBoOi11nGPI5ToHj8BHKdLuYKZ2RNMESg=;
        b=ZxVxeProqilzW5Vyw0l+N6DVbgHCJZJw+2aW6hhge5/oAlTUxnIHp6zpe24q2rLa/I
         +v6eXWoKIyC7t7Bjrdm+DALmnOYJzhxg/JJKSwozckXEe9G7M6UrrnWkCYaoa5zulYWv
         Txp217qXAtoTE86Qqvq9zxjI9OIywvh4YwmhQLSr137BvWbWaDotd2+LTSfpvL3L3ANn
         GyxO1uymzL8V9VLLaQQhLKvVZW8NrdYHko8Jl3JI4/rktVJHCjMsna1aiIkMSMFNnh/1
         NxKxWElzVBIHlEJ2kRLKGCpBOYiNrH1qguuAholDSj2BGKnTnSP/M7Ls6m1UrqZN1xsB
         qe/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236792; x=1781841592;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yvhwqnMK3KcBoOi11nGPI5ToHj8BHKdLuYKZ2RNMESg=;
        b=byXlcpLbRhhZHtpw/FKmPzUVq9q2kZJzyyZLMGDpFzKFqMqGYR2rc6TrJg6+5+p6sR
         BcnUOGyLXKeD7/VT04FfMZE6zwBAlPV7+wWiLMjXrtluwsCDhrOQ9xLtVC2k0dzh96ur
         l5mRo/uDrt/j0EFJcqRW+7Zh2NKbJFD5n+D8WLGsHawGwLF2WiAACkApZzZzJi3A95aK
         jcuTvsP+A6iRTX24BEALRJRz5tnvxtXedXhuabuSNHksPeMrB9Bhi+I/wpF2gDLFjRN8
         /qJYmzYx1U4F45Kmh6OL2ZQoLXYMrzTaTndOFEAnJSA+nbk5fqhG98tObLMpPVlq1nIy
         EKHg==
X-Forwarded-Encrypted: i=1; AFNElJ+flA+0y5KNMkesQFFH6WIAILNyLKigia0lXqpFm6eNG4917to2yEb6rgH0mmdfIbgtBhR5159YPA==@kvack.org
X-Gm-Message-State: AOJu0YxrvPrXhFwftTIaCCOn3l6NTWx8JjztZXktW/6aDJSjtADU3yDI
	f/wlvdTqZzIVllPrB/lXbJHcdiQnv6De9yb1VETXpjAbQJAe4HXcw6IGvHOaAe8MLIY=
X-Gm-Gg: Acq92OHnjlhFVeI1e3+sjglUE/OoFbl0WqHSI0gUyoIxUi/6kkSdLadzA8XKfwDjwVU
	VUzJ9Z+ZCfjFX3ncBJMIO38XbzUboPGqDtMkO97V5U/kixPYQVCjDAEQeZQXSB6J2u+zb8R03cq
	95j9epI4OZRAiqJbjJ1N37gTxH2n7PXb+KivUs+yF6N3MnVLFEm8qaAacsyghXEC37RXDIOrvHr
	3nXY7OwOWON7xHNVWEu3iFXciDrhnpTnw/JefV+UKk2A7UXr0+cHZmWJo0fkOk28Wz+baUspDze
	JQzQMU8LEYlEWm//UDlC3EIF+QDxTG7nqMIlcCO5GSNR/3dNgoqRjvxGdtFI5jn+DzqiG29w+68
	bvKDX3prrtgB/FOVN8+a7yv3QkOMfBeWPYIFoHaIYUzSo73B9FIkfvmTKCZnlrv0okjwCvZ8Q6x
	rAUWNocaML7umwU1c48puCc7Us7x7qs8683w/FYaDs+Rw=
X-Received: by 2002:a05:6a00:3a10:b0:82a:146d:36a3 with SMTP id d2e1a72fcca58-8434d0d07f8mr834215b3a.21.1781236791584;
        Thu, 11 Jun 2026 20:59:51 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.20.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 20:59:51 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	"Oscar Salvador (SUSE)" <osalvador@kernel.org>
Subject: [PATCH v4 08/19] mm/mm_init: Defer sparse_init() until after zone initialization
Date: Fri, 12 Jun 2026 11:58:52 +0800
Message-ID: <20260612035903.2468601-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BA3EE20003
X-Stat-Signature: 7rtj495zmjmu6jypdiiaboq6f43tc3on
X-Rspam-User: 
X-HE-Tag: 1781236792-113159
X-HE-Meta: U2FsdGVkX1+PpPrHt2QomwuVmCf20y9JMMkWAh6sGu1S3Pl7P05j1BN9uSIYKEdGHR+/7VfS44JheCBHGEBsm3DVEYDGyh0yboeTx9VulcCe1l4C2m8RpFq0hB0EDrcdfanu6O4uQ/1lm7D+kHXApNd0EIJLCaUIdaE23WY1PvdBsqwjw4F0SOzfVsh0TZ2rBN++A9n7oMv2cG6ERQ9NNubjufO8nMPYI0YguAvMegn+mNUs3+wcbjJGPox02bInTerVzEFXXCO0QWgOHi1UZgvJb+QHOKOIjOamibi0jBssc+BLrgI4L7L9q7skQkphDvAcyeHRWE+qELG1em7f5b3UdKp7VRa1dcxnamCKg9FrFkDsPea/48PFGlCOJChpFHubXY2UfVWUn5qJR+S7ZO4e7w/DPM+WPvbKsZrHsmxAmP7e2cWYhLDMJZ+zTF4cJHSn7LjUal/KHBBrzMFRn7AXOebf4Yjn4j5bnIkKPmrdpQBMGGsUewZdviie2bIeqXsjiFCq93UF5jDR8JKI6JS7YQcgwojq3BPODjXE5Ete7VWOAca+pWbJokcIrboVJAvBCJrjiNoyUj/H59fT2qVdm6ofJLmoYbP1nDr6zHsfRmSM4Bu7qvmh12oDbiUwDfVS3pl7+b02qHgFibE+QxPjVGWqBAn2+GGVFF+r5r3H+uVIjFrZGQ2jrsJYTz3jbkrrAQDv3kvfiOXY4PXyvff+CTmFrLz2kObOKJKcBfQ351+Jbb76w32ebtacTzMYNGuUuaOk2JUaZ/Oc/1DWQCXT1SSQ+JmX9HC5FhjZHpFgMwYaz1n2wgMfeRdpKs+rFfxc3pHMEV5KxxqKfQCwrfmasKhI7QLwjuK2WTOXQR9t1lDtSMmaRGUvtHQbPU3NyoCOw4i9x66vBe0vT75v3S9Stngv5QDH8y9oZ0Ak16uyn1z1yv13M5v3WalLpKp7dTP/8byJnfXh7LTRSr+
 fytUYwpo
 3Z2afEAabd5VM4ge1GEcln0X4+oYZdNKMQtLVQxGSuUNxPEbJDzOu2LEhUymOgAmjFpHWuI3Gl8ccacgjws5jgsR5vee0Qu8Vwl5LUtb5PY8UvlwxnCaoprFABsOprYrUcyovdYwe4kWG6ZjR+2UyPobFePgV3fF4dMhQu8EmvV4DHjLHl3yFxI9wD9HYrTixi1T+gI+jW6frwCH1i/3f1AZ4JDsc2q9TG/nsKhX6zJ21ibMYsn2w29Rm7UQvyHyEgfcKdZF+mEbfv2X4TzZn6XFkia59OWCngmeY/4if5ez1kt6GbvEoHouOCTeaAMrOW9thmOQ+GAi8rBSmHOL76g3Wd5ORpbiDlv+ogU53ewD8spQZ4niA6gueex9T0uW0bUUe1XLZ9LABfCvU1zjsyDKcmVrkZueH+fHxp/YfcLkvEXfhoUkkKNLb1E8sMdGyaP4HNWX4m0C9MEQcd21Qir7ZmBuP+JvZh7Q1o5Q1e+MFNnaQpPBH3O6gIREcZK7a9rgzp1l7+NjAqw56M7eZvjVSClrlp1XJe+V3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_area_init() is responsible for initializing pgdat and zone state.
Calling sparse_init() from there mixes in later vmemmap and struct page
setup, which makes the initialization flow less clear.

Defer sparse_init(), sparse_vmemmap_init_nid_late(), and memmap_init()
until after free_area_init() completes, when zone initialization is fully
done. This keeps free_area_init() focused on zone setup and ensures that
sparse_init() runs with the relevant zone state already available.

This is also a prerequisite for later hugetlb vmemmap changes that need
zone information during early sparse vmemmap setup.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
---
 mm/mm_init.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index dbcd60a38c49..bdeaceadb531 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1814,7 +1814,6 @@ static void __init free_area_init(void)
 	bool descending;
 
 	arch_zone_limits_init(max_zone_pfn);
-	sparse_init();
 
 	start_pfn = PHYS_PFN(memblock_start_of_DRAM());
 	descending = arch_has_descending_max_zone_pfns();
@@ -1903,11 +1902,7 @@ static void __init free_area_init(void)
 		}
 	}
 
-	for_each_node_state(nid, N_MEMORY)
-		sparse_vmemmap_init_nid_late(nid);
-
 	calc_nr_kernel_pages();
-	memmap_init();
 
 	/* disable hash distribution for systems with a single node */
 	fixup_hashdist();
@@ -2679,10 +2674,17 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
+	int nid;
+
 	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 
 	free_area_init();
+
+	sparse_init();
+	for_each_node_state(nid, N_MEMORY)
+		sparse_vmemmap_init_nid_late(nid);
+	memmap_init();
 }
 
 /*
-- 
2.54.0


