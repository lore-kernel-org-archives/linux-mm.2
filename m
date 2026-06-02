Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D138CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18946B00C5; Tue,  2 Jun 2026 06:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7FA6B00C6; Tue,  2 Jun 2026 06:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7E86B00C9; Tue,  2 Jun 2026 06:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75E076B00C5
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:11:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4048F914F1
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:38 +0000 (UTC)
X-FDA: 84834555876.01.92A8701
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id CC9DF180010
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JATXsXOp;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r2XnUrRZ1W0TfW9t5CZRJtozKMCRYAjD9rqyDyxjcoI=;
	b=4/R9jwXTlT1xLdcpe9wfxVrTxFtBe+1+p9t6S1faLScs91/GULPSNKEEx/cGIp0vbYZgcs
	jm2irBclMOTwCHR+x3Hg05leWsDYaknNIqPvD/Qb/GP6Xhlsgj/U8UTiEOqdor1rjtGB+F
	ai/FMmr5ppYCpsnODKXEGvo4d7lJsTI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JATXsXOp;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395096;
	b=DWUgVdesid6lXmdPzXwDJNfsWRiJVy0NR7alRhvrzWVbK4x7wRxLajsJZnb3hsMODOGkCZ
	AIeCyD2IIjmBTnAU7ESnjXtaunnVW9/V22/3zd2Jc+90juNcSgZaXz/SfagYKXBxTfGAYg
	wuM8Jl1wrQALHNFi1V76yPHVN5Ndi0M=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-842288702fbso1144846b3a.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395094; x=1780999894; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r2XnUrRZ1W0TfW9t5CZRJtozKMCRYAjD9rqyDyxjcoI=;
        b=JATXsXOp5oq7tDVdsO79tRm0G4zVYLwaBXq6md8xcE//LHGE76nBUfXe5UHpniIOL8
         GqVCrJ2FK89owyY5MP0mrR4exrSAS8TF53QBOdtTApmE9UCnwB66CMkxZHRVu133WhFt
         zUrO2CcJLrUjqV+Fi1Cc8qFMAmYgYsWZXrzuGH5QQb22nl52aaUMjNptZl07g9W10CMs
         Q+jOFq8MNA+byfugD/zNq874vxHU2fTDilau4Ox9QC5mg2qSJ1K54JvUjLwyc/QW+aam
         62MKfnATpNarcySXbcAyo5jErgoV80/qtgSE8xRceT8NlSs9DGRl00UeJQ2MZcatWsi6
         VzNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395094; x=1780999894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r2XnUrRZ1W0TfW9t5CZRJtozKMCRYAjD9rqyDyxjcoI=;
        b=cCrZ+LFGFfUXmbFo1i6e9/lCvBxMODHFcvB2C/FtQ8Sgq5oLPSqXueLo6kold2eAdM
         JdMt0s9DjfJrTYZMMSzJ9QIC1O3csaZjYZEtXm5QbYg9s8npOVsOU7WmmBVo1zQWPsM2
         bVPp0wVgX5ZyuYjFZ2L/VKr3/S1U2faMHFWNv1nfgw4C9esZek6TXAgH7zqsdoHpELrE
         loUDsFVuhEmxECRKLiyMVaGpP8VCufZkzcmEIHBqlAHgfwVY+/LFdunWTqQrHg0Lq4ms
         i59b3XoIyMXD5boxUvaqe92FJQEDnBpjSiT2YWindFZEovTo01OObwH7t0cUBavTswTC
         gNSg==
X-Forwarded-Encrypted: i=1; AFNElJ/xYpk4b2us0BYny9DauguVMK9AHCyUiArjFEneADTJXyv4ZFWfninVO7ZFfzaTygME7d//Fm5Snw==@kvack.org
X-Gm-Message-State: AOJu0Yw7qpaoMhCDv4qPT3wynU22ZIY8NMiVIHJplg7DfmGpEd64Yr1g
	EJzF+qOGIj5pxlax68exAaiW8jThl/7OToI0T86WktpKd8TEFBzvOx1IuEJt57U9Rcw=
X-Gm-Gg: Acq92OFro6ajMx7YEDNOna+Lc0cg8HErowonT1uUcek1KSU23CVoQke2RBEkMLxRtu1
	z2PnZMzC5Xd2PNp9M2TxfJBPD4SzrvRIkaCtP7+COdLBwyDDI4lycHocaDcNzvW66GulNa1CgD4
	eXRFEnMZea7nroRIqWcn3EnviEhUsnl7eAaYKkR5Rh9DvwthB3Fv2/1/MRkvgTeLkkb4oRDG6QS
	N7lJRXpxEHmV6NvuteDR5mdgzCD4vWg7Go4aKv/zmjrMEoXE0fODiHvhdJu2t/7Bl6rlafT5SHf
	1Q+jbaHXQZbZTzXHhz8TcIv/irTzn8b+KakPT2xJlfUi+4hQC1Xy+99knW4gVyKfD/N49CDPzcr
	eeZ7IVV85wjbCEchWXlg/XYQF8m3jQpr5Z0o81kobYyarCJ3fFprKLYsTQiPVgFFfHcJHZzHiaH
	lZon1NYtrjIWSfCGsLJLZNnLh4IhIfV1ARNb73HLQHlnOFu3qdiEoZqXV6FMCxF8lzTQ==
X-Received: by 2002:a05:6a00:4b50:b0:841:edbf:6424 with SMTP id d2e1a72fcca58-842253d6616mr12648288b3a.13.1780395093559;
        Tue, 02 Jun 2026 03:11:33 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:11:33 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>,
	"Oscar Salvador (SUSE)" <osalvador@kernel.org>
Subject: [PATCH v3 08/19] mm/mm_init: Defer sparse_init() until after zone initialization
Date: Tue,  2 Jun 2026 18:10:28 +0800
Message-ID: <20260602101039.1867613-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CC9DF180010
X-Rspam-User: 
X-Stat-Signature: a6q7gzxh1keonrzngd9edk9yadiqu14k
X-Rspamd-Server: rspam09
X-HE-Tag: 1780395094-992870
X-HE-Meta: U2FsdGVkX18zw7QB50MMcD/mzL4Q1q1KiXTTJNqmKl8UkMFLfo6+BVQc/DxYxPRC3f/8MYoQHCFi/NZo+nZDsndixIgfDnFTFJkLKNdrV/jrjzvuwD8r2kAsGuKd19jmh9mxZbQjGUg9uo4jYGNltmkbM3z6D+TpBygmDoqDZC/EeC9FS+DhQEShzL4jPCOQ8kscymqlkqiyEKAK3rlCHXU32J3cF8sJEW5hsswhLduntWGRInDcniTQ0yaiKFSX4U7zEtsz4MHK3+5Q0CSUd8E+vNYK5G/M9FBVVasKVLJxKcZcz9DogBLt3X0kng0Ym5IsxfsQeFcvkxtUZQX6zhsyUON5OSagho+mn0sttzyBfa3PF1Is4aIeZ5v2mLpVHlYo/NFbb63ydO2W7UTvbW8Zy1uvaBgG6aunt3y2bxTliIDhAa397k4xL599XP6HUP3UTNvd0QMGdrQ6i9TayKyTYIz71pjmLuWh56DheRYtayqXywzyBjcBw2Rkh8tGcUZMjwIF2f+7i3g+F3h0qRgZJNJEZihxEB2k8EMMpGaWd5ZLiEG2xMxCJQH8XfJt439UfjKi13YYV5HXqV9ONgD3r4B1s2CbUNY/ZR5XM8G4OWEt2re9nipElRgmVS68tTZKrfcmXjS4NZOBIqrZBaQSTkAli/x3NMBI7y47o+D8rZY6E+fKrhhPJp1BpYa0YQyriawKqvqKvPAkt+xGdCsHc3d02Y91novL7n6KCMvHuIwF0hZnmkj3BfAjbDpY6JswFwNzcJu84S/mgSMbWSgLHryaGssAP5NddaPcKwHOx/mIlmH24BDbh+pi3erxsjWbi8vSfURl4B93eXcv30t8xkVoJu6Zg+3ZcjFu3xIuXjDrRmEOgjIxV3CTHxlxsxzYD0WGTZ9jrfyJxUDJYGR495zDQXynbtitRdOUrRop948o5GNfQhOSuDu6HzJy5VTpDdCi9lZgSgpMV9v
 5B7aM/9U
 cNz3X5f0AJOxuJXqFaIQFCd69B+ZWx5Twf3FwfGh/JKnUx2Iju1GFPk329YM7AjerAFDGpSWn2wIpyOOdC1L6Domk+UctHgJLuirEPfGauW7ox86OuyhcwSbLoXDRdz1my1CWh8EHX3MDXSK+VI9vcuEEBCulOqA37DnEm/SB2nR4m/Odcl70DAbNS3Ek954c2iNLXPhdAgXotpSGGsr6OSvTTYgQMVJLr1sLXvajav737eEyuMaf6FvhmnbOHAkM/w7PDI0GpYan7bCH08Gi3shV36Pzvv0tCWLXvxnFsty5bI4J0LNGgWljW6PTV8IQQBA0KjSuILrx4dEDp/icLaEjtINt7NWrFxZEkixyg9WAdGkazSvpvY60v+QTkLlfXwHDUeuaNvKpoUQEnzgM6YwSgyojLMSHl7R4jIBUjZ/fLakgjfJ7kwWOuJOOCf6zotIDXhxMO7utf2Fgw0cMJ4LbBjsaznGwyHN04M72YqDqb0YfvgETIPqbRL16o+3VES49x6GBOsYATadTA4omecEeMFvKLmtoq6gK
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
v2->v3:
- collect Reviewed-by from Oscar Salvador
---
 mm/mm_init.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 3a57bf5a9b46..f349a6f34139 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1829,7 +1829,6 @@ static void __init free_area_init(void)
 	bool descending;
 
 	arch_zone_limits_init(max_zone_pfn);
-	sparse_init();
 
 	start_pfn = PHYS_PFN(memblock_start_of_DRAM());
 	descending = arch_has_descending_max_zone_pfns();
@@ -1918,11 +1917,7 @@ static void __init free_area_init(void)
 		}
 	}
 
-	for_each_node_state(nid, N_MEMORY)
-		sparse_vmemmap_init_nid_late(nid);
-
 	calc_nr_kernel_pages();
-	memmap_init();
 
 	/* disable hash distribution for systems with a single node */
 	fixup_hashdist();
@@ -2694,10 +2689,17 @@ void __init __weak mem_init(void)
 
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


