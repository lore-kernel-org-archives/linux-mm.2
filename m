Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99D05CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:11:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0799C6B00B7; Tue,  2 Jun 2026 06:11:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1E3D6B00B9; Tue,  2 Jun 2026 06:11:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0D576B00BB; Tue,  2 Jun 2026 06:11:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C45D96B00B7
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:11:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4640D1208E9
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:03 +0000 (UTC)
X-FDA: 84834554406.06.04F269D
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2D5E8100004
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LOTuoIj5;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aE8gFeezLetNlZxC9KnzUv4webDUXLM7puFdMIz+EH0=;
	b=JgACanYGKvUPLgp5szfaYcyyteKwmvbJrEQQk7ZXOw2pwK5sOdsG3WbOAe8qlAhmwmTcnT
	xaHL0we5Zs5r2ZMY6Yg30HT792eLoUPppfhDU67cIM9mlDMeEl2cHnUNKsFzMLcf3vOHTA
	xAMlnlKbQ2sa0IckSHnqV87OKZ2UM68=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395061;
	b=D48Ew14SQ2+8BQcNkxz2qjNwqquKT1+chUS3PORzVJGBa4Pocf/i9Vh5AWrMBKNfYveIGu
	ZeI3orojihMfcI2g1wYxeX94WeJd4y9GF5bqMD8G/yvIx6n+S9pljbnPBpvJ2+a2pIaLSR
	/f/Un+epXxcjp2pNZJo5MLpEtzIOXB0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LOTuoIj5;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8423f869421so1673923b3a.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395060; x=1780999860; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aE8gFeezLetNlZxC9KnzUv4webDUXLM7puFdMIz+EH0=;
        b=LOTuoIj5eQ0h3vjbwKRKKXf4MBCoRtHrpMQhnkSMf2JbkJ63hXoqr7c20/dEmVCR8r
         QG7rS7gnCcb0pVDvV0MGaCqoDIVXeoS0m8N+5JHG2ADtrdUTVIcrldN5Q4WWPBdkiZGe
         ZYCGPXPTeATh1DU0s32OiTaIfdBWJbO6/YBwFLVkr6hcSKpgtvkGAteSmTPvLTntNZCA
         0sYLyoex1q2lHqC5cFdUZDnfgmV8lMgui298DeYcHj9Ge7yiZ8cDX9MlWTFLO/n9Pq3g
         Oy/NSLJeqsIRX8iXjJDdR8LHqOGiuARkdFdRADO2BPfpsvlLXUzcqLxkLd6tRNKO65Jh
         JL2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395060; x=1780999860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aE8gFeezLetNlZxC9KnzUv4webDUXLM7puFdMIz+EH0=;
        b=spl4inU11TT+bMXrmBVwAHp7cotUQPGF4ZCgPnDEcF9/m9P5Z/ihsURXC+YAMVZMGu
         +vx7b1BqJwlj8dAgL1bZBqc2dz6JKJJTlVx3nwhNYDf8j7xMvHI3bkzEDIRYNd6agUaM
         mXUW3/7581adJO2b5BNm9Rs10tQibCrsPnM48ncoB2/YQ78ox0aeRJ/01sGZZQYdZcwo
         doLHEcY5PTj1Ov+Oa5y3DAInWiphRYhLYyM8pv0pf+4MMYu531dDmCAZCKWFyZFstXBh
         QnqLVLv0cm+hXZAj1naEXfoQROPIKXOeBnXzTmDemhB8XotyHalajPv2svmKR5AttGdz
         mqqg==
X-Forwarded-Encrypted: i=1; AFNElJ+rQvkuYsjGAGFfilxXIcOm7+s0dstmBGvcRnnRgS7Rxt7sV9UOtyuqp8rh970+68+s5wlb15qZZQ==@kvack.org
X-Gm-Message-State: AOJu0YwR8Re2tWxedLhGWTteJPH2dpBI3YbaufmkClI0lOqCogyhaMGz
	AP6wvFbY9lPnh2RO4pN+COyCVGhk8e8hCqlHPzcRp7RRTdi1/yF77rUDenNU1FcMmUY=
X-Gm-Gg: Acq92OHP11IASZbQv3EvQ+ButWnq8s7QZrhRNG/TCQC3+qlW9VUoJWnraKt/p0dUls9
	FUsTMqhqtrieIw6mknkyVjKc70F8GMa1exhUH0QI0DamdFOsCBKNI6xtp+5IzaQjj3/v4hA0eq1
	OoGhxMs6GuZnS2ps7mofaB+1UaFqIJ1zM8pNeJ7BKdkXDRyz3LjTA7taSlsaJRSAIgC/F7XkDom
	rDME3D/rlL3tF8azVbijOubAIQknq4KtlN5HeS9GsImMoU+7mt0+mXVOM5Tc/hxhjR0lePaCiHB
	o40GbwjMk6qssbLKk/mgwW4d0GrUdrOisNL01/4knNkikQse24eThNP8qRRRkr5ORG7iI7avZ0d
	NNjvycRRvgVQKxUgNpu3CCDqIZNvCjBQfYIsqa7dllyTXHSCcYfohXXx9WsriR0XQhZYHaMlZM7
	gspKm+8eDwLyGNc/YHe2mCCIqS+yTLLdmDsczp5wWJW9CXagvx0gDOlDY=
X-Received: by 2002:a05:6a00:1ad4:b0:842:5d9b:d590 with SMTP id d2e1a72fcca58-8425d9bd996mr6238843b3a.30.1780395059676;
        Tue, 02 Jun 2026 03:10:59 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:10:59 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 02/19] mm/hugetlb_vmemmap: Fix __hugetlb_vmemmap_optimize_folios()
Date: Tue,  2 Jun 2026 18:10:22 +0800
Message-ID: <20260602101039.1867613-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2D5E8100004
X-Rspam-User: 
X-Stat-Signature: pgmn7drd8tt4o3g8denyjfrsbx4xe8w1
X-Rspamd-Server: rspam08
X-HE-Tag: 1780395060-86851
X-HE-Meta: U2FsdGVkX1/1tpUrxwdDfI8ryuPbPWyTjYuMLTSHwyzQJwfMOp/ogOhJALxCP9IUlotZ8yi0d9nI0CopUJ7c2p6cAJSjSb7/3vj4wHDS+70cMZuMnOEoUFOobNYvKCbKqhWLqNGp8AKUlntP4iAOlR22kcX4kBc+c34M7Vs+zcKFXKsvq0QgAQNHHworlsKDWUg7Qy8gxfLN9pU9nTGL24yd/+rPvU5Ko6GLN2DUMuqv+h3EH7yW6RVJR52FLtPpd7AsRIrkhR7c8jEElo6rvuKp6opCMgTPuOAkcd8UdUfP7Eei5dAdTw5glMISGRBRnTxc++GYyWLekXT3+guvE4IrTgQXDVxpp3HrRxRHMAmfclWcuB2LYyO0A4zOsEsPEv3hZ1UUg9Qyk8W79YaGaKY3xGliwtnDVLvrJBiFUhaIUl7JoUKN+FVRSrNjLbyDznEz6A4/TD92c0IflJ19c6HIIooxuT2Mk96DFwhcUbyaUmUZ2Q+moAAI8WGz4WgsFeg+pQHkElJBKWMAzDB2tcw4ushXIAE8phMn0Pad+O1cKtIejmm3YfHPYkA6Lazs9CZNWKV7RQHnogAYAkuvhdlAskLRE61jKkQqigtlhctIviqkEPBLlxTPaH27bgPulFTuXb0yPZ86c0U5WJBx3mR5RlHAtQr5+prQywCUAmL92Q0Rwfe8taTJ/c4ahqVeS9muLl7mJUbHpLLvIL77u7w9LfwvZkTnmYiNpy9WzjQAmHNV4uEYoouiyU6sKjjIB08B+feZhPJEgiQEt+srnAPvCppscKi4n2W9pvBGCtbK7mB5ySOR1ytIufYlWmBQf3mA8mIU9wej/mPY/zMwha+DtTtA/7g+Z8ysSFrT/iIivDieAwIXG/C/2xHVYfL1X1ZfROWhnTZ9zrFv+qIfS4Qdk/c9fWp+36fQc0bAQBzH7KFjinMXrkTpuB+VueCv3flaRN8AiSt2Q8DhAli
 YLf30Y5R
 WrUuBDJU7dZzewAemUJrrftWqV3BqcuFKwAxcAS/wuHBgwB4WmCScO3W6D35Yg47Av0By3TvhLBwECa3DttVPrNRL4EIHN6Sbn0POlXxkeDsfcPPCmGv7UpEngms2u5neQWkQx9pM32rirIaz0jBJpPHuMC4v/wFCO7b1UuLmbk0gGVMRMBkQ7ppa0LAJee4jjb4soNk/Zosgs9hrK2/5WbbLF7jMvUbXJRVJN3SX8tTzofzXDzyk3SLXaK3Y4YUtUCEpiSGAFrGfbsXeMAx7Ahrti8VFpKDbiU+i/qbMOXHAod9AA3IVQE0hiwsIHsOFJG6e4jNtqJQdKTyz2hpjgi07T/z59pzN9V0c9kbno8t+iSCkFVFqsDoY0CsqPF3MjHbtf5Rkmc3ucMKoiLde6KXo46OypA7eVzDjM8eY1DqC0Me9Ja2MNIyuyw==
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
Acked-by: Oscar Salvador <osalvador@suse.de>
---
v2->v3:
- collect Acked-by from Oscar Salvador
---
 mm/hugetlb_vmemmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index c713c0d2593a..ea6af85bfec1 100644
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


