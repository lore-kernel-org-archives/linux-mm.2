Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65138CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C628F6B00E4; Fri, 29 May 2026 11:24:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C398D6B00E6; Fri, 29 May 2026 11:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4F206B00E7; Fri, 29 May 2026 11:24:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A45726B00E4
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:24:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BD8B8C5ED
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:07 +0000 (UTC)
X-FDA: 84820828134.17.CA0C5DF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0130340018
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ivKOvE5I;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068245; a=rsa-sha256;
	cv=none;
	b=YHuCquw2+rkJ/JB7AZtfnLBj75n3yWg6lz/NurNLuHRx6HX5FgR06tvSSOpVojn1+cu847
	7kUkCAADaZanCkty3/kwZYh7vYs8vgFxFiq7kamWN9O9j8ywp0gWyMv10Yyqq2cKEyQ7Vk
	fMQl/Uhw8UxDXf9GIVBaOyvMsCu3sic=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ivKOvE5I;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p8FgYlTim+1qafXpBvmXgDRFgmjZT3BzBxl1fqmzl20=;
	b=QrPcKF4SIjvdO1iYoWXYDWjvKeJlXmHzkfeEQcnM13rvpRkQrSEFM/Ar4zj4tIBZLMvt/o
	OMT62fyRGassMwbp/IzihSesAe+uPnjLUVLg8KYecMXCUV8G/ouXeZyh168w1quLhhTZ2C
	Kc+03f6wkNLVfShJvWCXuiW1LIZvYGw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p8FgYlTim+1qafXpBvmXgDRFgmjZT3BzBxl1fqmzl20=;
	b=ivKOvE5IumAu6zBp2sy/LwrAw4gvCQ7dDc1mIPzV8A8GFzGlclvZYXm+OarE5s6plf+nLG
	a0ShWOYD0vdIdBis7kbLm51PUUXnfbYeZeXS6PCaOTpq7jejX7egLrEiuRuub4EYYK89Io
	dXmrjSjWCkIlaXYbbDHyPSCBymBMzzs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-1uU4_G0_NRiha4GiPJe86w-1; Fri, 29 May 2026 11:24:03 -0400
X-MC-Unique: 1uU4_G0_NRiha4GiPJe86w-1
X-Mimecast-MFC-AGG-ID: 1uU4_G0_NRiha4GiPJe86w_1780068242
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-45ef3c7073eso483894f8f.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:24:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068242; x=1780673042;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p8FgYlTim+1qafXpBvmXgDRFgmjZT3BzBxl1fqmzl20=;
        b=pH4ehqpG+qOAgJwPi9KLM+f7ijgISut/zvTUcNEHFR14gR83yR4n21RSI1ytzMMI0P
         He1J/AHzhuzHumcoqazHIV6ezxP1TvXLCJS0STWNPwZyR4kmx5RXfiDYjdVt8S2i08Cj
         15YS49fHB9FwXXb6Dl26FhhhSNB7sY0AbUfv3K9lPcckNLBI0Fq435AxH8YdHLD6lB4v
         TtCHIZhHu2SUCQhXkHVnD4+PxjxfAEfEZD4DTluZ5I2TW0sIrlfCXprtklyxLJys0N+o
         eFQ2h54QC4iGct9JMcZMgRX/pcg6HGJOCZ/2pUeBQlr+2EpHRrYvmZcVT69nc+9JtLmy
         fyxA==
X-Forwarded-Encrypted: i=1; AFNElJ+2X2fo+PQowegoVf8X1erl5FqdVhesoblrgiQCFc+TBW0oqD1EBJ9QzxmYTGtfdIYQIkfMk7YqyA==@kvack.org
X-Gm-Message-State: AOJu0Yybem5SEJG/5//z+QMw6TbmuG1y27BE30kfphLUoDfeNsXAQ1ou
	pdEx7phoCQiSfgILgRtsYoLjlOSMEi++AcC5Z/+Lcz/vAxAfAukMSJPuJ8FLTvY5KfrlR8YgfQs
	DaqJ9jfwO1QnruXXb3BuiuKiBDmta9KIYAa4f9Y/iXnP0Z0LF/GMq
X-Gm-Gg: Acq92OHlv1gFkaG5kSm9+x8C1pzQuEWj4Q/+W6QBGduUDz3yKLIeqjI2achx+xL4Rvs
	MYfkCKFjgITgA0LSKUFAG5gUL0+fID6rcFfmesMv5xhDbYSfBgjMU9yN1rgHMFMb9lp5Fi5+Xa1
	TSQhSX0qePYlTyVzPWoz+DXUXNyM426jL6yhgXVlsUd/Cn6BkK/P7oDxLyIzbaqT2kRGr3k42Us
	blzwz3d3YoCfBCwaPzf20+BH0woPS+Yx/UTjn2vYo4RjHEgvwF7BGQK9jr4HnQEeWA6fpWPuEmE
	cNXHk/rQdyUnOeg7XITAG77xmKo0KM1MN6TRgEpRNIwVLOzA/cnXTZBXd9zX4u/peyAIaLZ1/GO
	vIFywxMPEV2ZdIXR+j29Z4kcv2I4v6WLn7UviCXz4A+JTEkSCXaQu/g==
X-Received: by 2002:a05:600d:6445:20b0:490:4f91:5519 with SMTP id 5b1f17b1804b1-490a2958db9mr848925e9.18.1780068241666;
        Fri, 29 May 2026 08:24:01 -0700 (PDT)
X-Received: by 2002:a05:600d:6445:20b0:490:4f91:5519 with SMTP id 5b1f17b1804b1-490a2958db9mr848535e9.18.1780068241185;
        Fri, 29 May 2026 08:24:01 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c104920sm16482535e9.21.2026.05.29.08.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:24:00 -0700 (PDT)
Date: Fri, 29 May 2026 11:23:56 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v9 19/37] mm: use __GFP_ZERO in vma_alloc_anon_folio_pmd
Message-ID: <6dcf0045e069812ef06a71ebcf67ef0c819eb51d.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fd4dZ9dGcf_kHgP4HBFdVkDInQRJgEGdLJ5GCcnrUzY_1780068242
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 0130340018
X-Rspamd-Server: rspam03
X-Stat-Signature: m5sjeawi1ku45kmftbf88igsyhkakfpk
X-HE-Tag: 1780068244-74552
X-HE-Meta: U2FsdGVkX1/ff28MooeN2SQYDfCCkctQkh3n3F5O2jXuLBCbdQnaKWpLKjGFLCZxRIYfPPp5/2Lfy6c8wkKRvfRBVNNaQK2TIg5nDUpm8gJSVLLMrc7lvjcjbFThZLG+9YTo/Cz6tAwcg7t9SSYt+O6NNBdUvmy2r3rpnNWDcElUVrysgwy4uw+zKbvehZUmTxC6uiz5K18KHbStZ/8yTe8vx2Q814LIXP7fwyLM0qExdt7hjqRdPrOeumUI2vn1yAcx+s0+5dj7UntRH+F/wgi1V1BzyAemzEVVdokAVPID4t3Y79YHBSGVOl8haPoXFRqrJFEI6X8uUbbq7ogpB4zP76GTA3oJZJUjvRxPH/AezzyTkJ/s2loS1XbQtln7JEUHvUI4bGVtTrAZwepDpHMS+k9xFpndtd/U5t15J+1dcn5fUX3s5ZPnh/LSdnFCHck8ues7T2PIKql0gRAE1IxiZR+yLTMphqv44TrWGFPs3wa79ecqqLZHnmLMH6vVI8yC7fP9UZRJW4iX12nwDYoUrKVXwJIU8PKir24WHOyC+EDHxiXeakMm8YPTX0KEU3Y+3aEn1O3MCG3DMxl/Xf4gsw3dQOuwli/VQ3tlbzwUSQ5KHCn48J0eKLORQlcsscBgjrCKRrWVJ7sc1GvD0AUXol8MVp7v0lDN+nPkmX4n8CpnYkQ55yk7g2AlBphtIqeFtlQJTYrQ//tJZ5Q/BVvZbqZPCMBhZQYyPUc7aIdb6pN8HiqjuWDOeBxcNLHrj2XaV9kXqLU62sf6JSzt5/FFixVAUdsIzXGwqjdVRg2gIwS3G6wUDHkWaWEX5N4MOEYs1u7gSJlCaVRXf2/DSK7OGX7RRgcFEB/2MUZ+wLE3VOV8Ctxlhnn3Xgi/t2+Ypbu8SnzQfwiAZ09phHe/S0Qya7yTByTHtB/d19YAnOJEaTSrXmCfFsxD+njdbyjLNAD46wzaAMY2zON2oYG
 3YIWqXNd
 HYymZPbtAfKOkHoERi6AbPv9uTG77ZkITYtRsEvNKGYTGRFwfQEpIe0ui9ek7uGi18m/Yh5gkR7cyI3nhCa9kYGMsFAjjOgTaS4PzoKph/MFScSIPfi8fs6A2vpPE3HyqngAxILp1zWSJpoqNb4SzPwc4laqwo7sFb4aqwEamP3doexsxqFXzv6WGEuQivbf0s8zPeXC16dFrjFQ2mJFuDDAgZ//cbwkEoynVR4Q1P2JGhKrylB8Z/+dl8UOf2wMouCKYu7PHrhsVcQTjJCK6slBACSV7bxHFAKI+Az9oYPtcE64d/A2WCZgtagzdptM7vgIDkXhTRL8vz7O4aFcEWvNi8T1CUo72RH27voMmGfEyiMBq1WqLhK8hlTuEj7tyYuH6HgJ3NP4XUdc1LZnXEdNJ15yQVfvFdTLMJRVKGNgBU78zhC30vOgz7qzuJYJa2EBCNYoapjB5/xfmSvuC+Ia0GNQ3+/xxv0d22p1COV9Rn80hr4bXt9+Cjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert vma_alloc_anon_folio_pmd() to pass __GFP_ZERO instead of
zeroing at the callsite. post_alloc_hook uses the fault address
passed through vma_alloc_folio for cache-friendly zeroing.

Note: with __GFP_ZERO, the folio is zeroed before
mem_cgroup_charge().  If the charge fails, the zeroing work is
wasted.  Previously zeroing was done after a successful charge.
This is inherent to moving zeroing into the allocator.
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
---
 mm/huge_memory.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d689e6491ddb..4978d34532ea 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1333,7 +1333,7 @@ EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 		unsigned long addr)
 {
-	gfp_t gfp = vma_thp_gfp_mask(vma);
+	gfp_t gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
@@ -1356,17 +1356,9 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	}
 	folio_throttle_swaprate(folio, gfp);
 
-       /*
-	* When a folio is not zeroed during allocation (__GFP_ZERO not used)
-	* or user folios require special handling, folio_zero_user() is used to
-	* make sure that the page corresponding to the faulting address will be
-	* hot in the cache after zeroing.
-	*/
-	if (user_alloc_needs_zeroing())
-		folio_zero_user(folio, addr);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
-	 * folio_zero_user writes become visible before the set_pmd_at()
+	 * page zeroing becomes visible before the set_pmd_at()
 	 * write.
 	 */
 	__folio_mark_uptodate(folio);
-- 
MST


