Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9B75CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:59:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48F686B008C; Thu, 11 Jun 2026 23:59:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43FD06B0092; Thu, 11 Jun 2026 23:59:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32ED76B0093; Thu, 11 Jun 2026 23:59:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2354E6B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:59:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DFB321A03DB
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:27 +0000 (UTC)
X-FDA: 84869905974.20.992402E
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id 26A3FA0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=C86NLH3g;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GLckvYu5EL2MaiuWaMvOvK8C88YkCBw4frh2Emu1ze4=;
	b=4ZmSTzPlWixrBHz4c6JdJlOZ3PKIF/AnYIsFPYQx+cPZxnq5bgA0RouwNanRkUQncpq25Z
	sPIfuqYlEWsVlI9bb0xER+MtEWORBkEyh97fI3EMjaM06cNcj0YL8i7Yg7LrnUfFK6vhjS
	YrqzbtKlaq8Vfq8dwaGml9QebQxbuNI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=C86NLH3g;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236766;
	b=y6WNUn2Fmt5QGbhHV1WNC4EpSklXajdXDTs4jhvXRga2K5jw2ywImyUBTxn9jRfGNTqgLD
	L9P7Kv4hC833HSB55zCV5NUE6lilkJ1PrA0M5iRpxVsVeLsefwEVXqQgw/BvTGaTkXBKHu
	TUo/g6fuBapCqiemtVJnBHADCnaP3IA=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c858b392697so233755a12.3
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236761; x=1781841561; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GLckvYu5EL2MaiuWaMvOvK8C88YkCBw4frh2Emu1ze4=;
        b=C86NLH3gy7ILetClVmP6qZdBc9kHj1W94dlpMFezyp34mNKDqvvuOkW3finBtCHjE/
         cjXxan/GEAtgrVXngnNciE9RcAsw50/Zx1+DBI6JfDNaRNWVyqHVR/1UzvRTUoz2ZaxL
         2XUJx1sB7F1WuS3twkkS9egwaC3F6inzj/B3lbMiRxscXLh7AB19EtqLP1+/LOklzv2f
         /dKw9EGO1ZkjqLLUg64guSFpkMDonmfwqONVXey4h4guWIOwI+WuWa8+SHhEXxLb9MJV
         Asxq4VzapCXMgXVKmy5PUoW3BYWMRx01yqthb1xTlZSKZZPNxBwBZLKhDOBDMfuHJAJR
         Abnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236761; x=1781841561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GLckvYu5EL2MaiuWaMvOvK8C88YkCBw4frh2Emu1ze4=;
        b=G729MihPxLBBv2T20CTCb1ApEtD4iUbO+/NTKSYvX8IFCqTrOhBtmyFCLovXvReB56
         EMS77iOHsn1UTDezw3aNqNSeRp5asYHNlx8xGnjrDFOoSHpcVsx8S7KD71vWFtK9OulZ
         GtiYX0XV15LIEl9J9hkKNAgHqIr59iqdFa4apMvc73U5x3ldzrlhwl6lpPsAvv/mgpAD
         EWg/L9+hqBEyyA07h3HY2DhyapssQhKstudrXzx2/MFS8Kjmp5VXgycjT6C/d0v9iDf0
         Ufahh2l21DIUPUdWkNPZ+pD99P4JHRt9RuzNcQ6oSHB/9IqGw61GLPnRd2Gd6/y+x/2B
         FJYw==
X-Forwarded-Encrypted: i=1; AFNElJ8gZDMT3o+B8i08Ah51fmspk1TJqgWXy/2dqV7F81YlDJJkVEI/4rb9Ne5vmUHYJ/ZLkznM08AFww==@kvack.org
X-Gm-Message-State: AOJu0YwiMyWTIPko9lr4NJwFW2QEcfdLB1cjOCfCQR8YaXVRprtq98rL
	+fUGVhEKcGYbITNXd7veF7SdRIEW5A6KAsG/b23ZZMCNoCrl9UkEcx4bP89Vysbu1nU=
X-Gm-Gg: Acq92OEURVQg6hRhH+nOi8vaqV9BQWtQ00cUs4O7NVHMemSaj5/sC1xxaKzfbzGMSM3
	RKAD1d3mgjPtjjnknPklqvXnBQYfy5ETcD9xzo0AmRy9LScQZLJt9+M3CvwWSYu0liRIMcB8bgr
	zo4x5pNoek6UolTwPWQB4jTrUvkJFX8p4p7mD1gHq/CvythPAM4A5aUBMtWndk/hhqngfoFex9A
	ijBvyneOHEP8a5ABOSSaJh7FowrEj6l4SAp4UX4ckBqW96uErWZgb+DR9IKvsi3xN8zarFO1Enu
	z2vGFaMxnlcoCfYd6Lgs2myobJelkM8OsDY0ahd9+DgmE/BGR2jlzQAZzNloaux+xxH0UHmuF2V
	CiaMbJ5uUZCuEO6dknr8/saYyTKNKe43mh7Xm0NZ47kqywSxYaQwfQwyXf/kvMSnQvLkwH6UpY5
	cpwSiyNjbkp2u5kDJKkfcq0P3A4J5WIPoAxqjbhcgmDFs=
X-Received: by 2002:a05:6a00:2d19:b0:842:4f49:71bc with SMTP id d2e1a72fcca58-8434cecab4dmr1092576b3a.46.1781236761177;
        Thu, 11 Jun 2026 20:59:21 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.20.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 20:59:20 -0700 (PDT)
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
	stable@vger.kernel.org
Subject: [PATCH v4 02/19] mm/hugetlb_vmemmap: Fix __hugetlb_vmemmap_optimize_folios()
Date: Fri, 12 Jun 2026 11:58:46 +0800
Message-ID: <20260612035903.2468601-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: r9k7pjjwhq68byrgmpf94xz5jj9xj9h6
X-Rspamd-Queue-Id: 26A3FA0005
X-HE-Tag: 1781236763-90776
X-HE-Meta: U2FsdGVkX1/qjQRncfZZzGm2qP888kyhSqAOhwjCTHJKShXgO3MUZZhfdYiiI4vR+hWMKJOmBpXs/BuDbZAHuiJlDlZCmLfdSUFXLCK3gh0G9hWF43TQGs4PYgXkBPp0ILZY8h3tzRX2mvD8VbuxZVBwk15IjIh9AVBZnoAADp5GmYSSGXdjgnLVkQXJX5YPa18KIy2kWpbduFn1v65/9zPk+7+Je+QfTMsCWSBgaAo5EKY33+fFPG8UKrghwAa7MTtDXoToplTUowsgfV9Wjialg97r3tdaObQ3sVxjgybSaFrxh1oIZOZXVLppT2zZkP8lYt9Q9XGAcRLaVbTBw7UZ0M7lKuppqiqhMnpB91LREr/P7bVGqXq5Axvs1Chpp8NYIDeBmdF0BYy5WuYx7geoGUcWEzkm7/0ee2gy2A8UIRYNbhUzkSWeYLutJC84fFU3bKzLAd2ay0K6ycBRNqsHB80fV4Q996jfO1o16Us6fGgasl7mgYQilO1UTCFdqSG1NNoeEztU95apRYO1QroFsPX5O4v7CFtN7AXRbrKKlyWnF26h16KdRhHkaVEkcIBvmWlzNnP/guJieuiFXfFu3dWoN7PJX2p2LN45aWJb64EGpIyQ+bEg1VimzYzawBGpSXGSNH+YpFRxKVE3aNdVndIh2N5rV+Ku+yP59vvid8r6RoAQjCj2VfdbLAft8NhHr/tP11zWn7iCyAXfiwd2WQaCFGfm0MV73gqfdFJct5kWrJkNnx8P1hZUvOFdTtF7qrfkLtlNzWT70zOFBcXNr6wSPZMdSt83pgw/1Kxlx8NE9ZH5a9Zdk58onL/h7u+riCssr3YaKvUE9Aks/Zg8+T8u8SqAX5lT3HRjjTizSBHRLDWjg6fyOr/gAVpcTbIqriahiZ6sqbXSN6iIpXW1pHln07MZw5t0lXlsb+nabPOXD08ZhDH5/A8f31XLZ+V2GSHIaT7pkvNDmeN
 Gf/d2MD+
 yw0BCWf1XBz/gyJsdsXFczX8fOkSt9YFEZO/gbQhwf8M2wG246DcVLpg2KAN++Key0yifIbITfgb6fZ0NDdYtRT8nvPd0j6qimARJkgxYpaIT1Ysx3sd5dj3RybqBhhzA4ocMr/k2xLsE3whvYM/LR0NdA3fRWlGRjZsGyRZ1GUITqi7TsVETvxvfdJKh5Ip/nTpq5H4FzmtVOOORACBCYTt66l3c0ylYXQis7MZ7dx/8FP5TLMddTFUMCybFF53j4kdsHtBt0mn+aaUfYHSjrlIdvkovblgUkLCuRUQoGJsOy1Z5RRpFtWRZphxyMttUJa3+o97B4IaeEl/kmyCrttnPr2pcBXJwfyqPhtkWHqQPelNhfnYMU3pG0gCOul3WC0lE1YT5kNO9BnN/A90xK2XpVHr/YnkyHCWjizvFSG7a+nShBI9lqA1XCKom1NPqDntc8beArU8AL/I=
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
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
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


