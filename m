Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3715CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 19:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15D078E0007; Tue, 21 Oct 2025 15:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BFEE8E0002; Tue, 21 Oct 2025 15:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA22B8E0007; Tue, 21 Oct 2025 15:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4F668E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:46:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C93913B3BE
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 19:46:16 +0000 (UTC)
X-FDA: 84023152752.03.35435C4
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6DC7714000E
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 19:46:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bs8OTV67;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761075974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qFcHRErR3E6NpM+7IUll+f8tDVmMlaLL6Mv+17zBFxY=;
	b=UciSde8dwL44Q9zYbILAkcT8kDiWFW9GgEu20pcjah/tRyBzSRSASfWTZkWpyub7zY0+s2
	arCCsqfOQj7QtGd3o5JM16A+XRxu/G0uErdHTTWmltfu8Laz2L8Ksi68nqZHFduZ86xmzz
	8MCWF9UygxvBGDHeEsXwSS0++51qPXg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bs8OTV67;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761075974; a=rsa-sha256;
	cv=none;
	b=GM5Shft5XCPI0C4g992K+yQ0s0yn/SB2DmeWR9WyiTkulEHcYtRaMq13yBTT4/YlEG8Qrp
	H6hEq6dNRj6db2Oo7EgKGJyud2fAommDqz7qautXMPhwcu7hlsvoSak0acj6BBmImdMO4K
	cljXya+CpRu4bxjIwd6hi1P2iMsiVMI=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4270a0127e1so2906330f8f.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761075972; x=1761680772; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qFcHRErR3E6NpM+7IUll+f8tDVmMlaLL6Mv+17zBFxY=;
        b=Bs8OTV67R2cawpXXMd1FjkXxqjo5rmnSMB8Hd5l/3K2yGPSU2Su03EKDPneXLVE/WD
         k1ADPwof0ZeYl6TwAUZMC8udInQemoBcV9woGd0GZfPnXIZpQd2BnOQVT4uylmE86hRH
         tLDXf8LTq481+kPmygAxE4Jb9P0BTMRp6XNJBMWabCBJRMgcouUQdcTF3mq26TwJVZCu
         CyCVUNIJzapUFwxaqEqcAqb094mmCvuImByICQawmrM3VXwNya9lwgeiTQidba3eqsVb
         OWqaSjluhHH/3cfVanvd9PHJwAMaYsRW8/bISjShxaqxuLY0WguNQzR8qpCsCsEcO9Z2
         gM3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761075972; x=1761680772;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qFcHRErR3E6NpM+7IUll+f8tDVmMlaLL6Mv+17zBFxY=;
        b=Tlq0cxR4TM/lJJmVWIxqkK4q8zJNCzKjzymJzHT7f2hZUKAh0rz2Uw4q6VOjDV7Z3S
         HNVSHQ4Bj08L50XYgzyrqbm3yRR1vEmAJC9MDOKtRr020rwdsu2N5wnb3OlX2Wpk/Q39
         tr+uYXR84VV8eithGtQJO/yRxcnJR4aihbn1iNB0RcrjSRSU4IwLbp41yApUyNK4JHqf
         49anWXuOgR5GVJk+jJi2XFl1k/KleUI6VftipNwTRfJLXbyITo3RGC5SUK4vQ8fQvGTn
         d3ypXyQ9TZL2er9cfj2T2ZjlIxqQSpJQZFh9NzZMcCroLFUCRXwdFiDup/M3/qzIEpCG
         5F6Q==
X-Gm-Message-State: AOJu0YzA0/SFbL84lpSdSOdYyCc9eo1TQDQXlnNCCAsOkJ3CoeMCrtBF
	PHMi7Zd/3wtcTy5KWlEet1tZqYi3YtvbJWGMUOXU99YLg2NIA1EjjLfjjJHCM1wd+IUnNA==
X-Gm-Gg: ASbGncuUGHqkrg6lcewEouxwYMAKKBmAocAswaW+pXfzQMScicYqpdlOB1wk7LVD5Vv
	GnLcHWQQ76+m+iqrWm8QmONdgqcwphOWWPyBx5VawJmNiDeskZWTfTHlU6Uj7klvubeTlOwsB96
	EVUYWKiGmnuK5GBi9ylbRt+UV4pph5YJLiYMfUVMXrnIPEyCffZZDV7aw+1SL8sWUSyNenjN1lK
	j8dNO5r0InnlUnwn+JBCJZhBiw039SO2xyMFQHs2x/GwQn67PlIT3nNqNDHkkL9tyT1+UlT9fao
	bTIkKycJXuG0npYUgHdEMT/vIqsIOoyxcLbTUg5/7wkmg2PeW82Uf45nWUTqNvpk0rVQ25IdTv7
	dixHl/uJd8UvNsC9/t83KmMp+g1Rf7QGLwh6F4rpSBZNE9k5tgwB1zMVFHoS/ErdM4gNiYpTTOd
	3yAfa1qs36hZY57eIoCHV4deKMHJrlXwR0uNGD7yhGXw==
X-Google-Smtp-Source: AGHT+IGa66oK1Ku/F3PiZN50n0zTqmr5IA7b19DfK2SzeLpd1kEHYq8mnoX0k3rpIbXU5X4W0Hzr1w==
X-Received: by 2002:a05:6000:2005:b0:427:9d7:8715 with SMTP id ffacd0b85a97d-42709d788b9mr9713022f8f.34.1761075972252;
        Tue, 21 Oct 2025 12:46:12 -0700 (PDT)
Received: from fedora.customer.ask4.lan ([31.205.15.105])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-427ea5a0febsm21667227f8f.6.2025.10.21.12.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 12:46:11 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH] mm/vmalloc: request large order pages from buddy allocator
Date: Tue, 21 Oct 2025 12:44:56 -0700
Message-ID: <20251021194455.33351-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DC7714000E
X-Rspamd-Server: rspam03
X-Stat-Signature: i1w5u5hfq9bohgtsh5k3ok6usnmyaqjx
X-HE-Tag: 1761075974-958903
X-HE-Meta: U2FsdGVkX1/jeEMvv13sPO8yavJsJxu0OHNDU1msk0ktPqxXhwXjsxaV8RTnnlMuBzolRitUfb3C//n0dL/4+2v7cQAhuBKpJYYmVqcVcZdNZlICGTbQKttDKgGasdF1Iag0Wflx/C3l+0616hMb0ukSvyhXyO0luZU8MbrlMSpGj2Z73Dy3dkz1I+vDqsEXfxSXQZtTlXvuv3VjsBEKn2uZARxfVNd1Qn35ILZqcV6lvKhHx6gs8qg5d76guA0ujznjPUMfeGv0alDTkfSP35MYnHT4vyUmrPr9L1qAEjh6fq0e8ULRDTsmKpWf2N0/M3H9qpgpapwAZpR/3XX+vEsVB6dy8JT850Y72BDP2oCjKewc0GRavKxKhYplc8qa0ZPa8EhxH4tMM+PZD+9lZR+66angsiVAeFb7bUknBFFLQxfehwkQDke3eO0RWsnlFI2fRIOiksHitimEvHpU7LMp7G4oezU0Q4/83bc1Ngpl+kwLI+ha/89vHsgb22Q/40CS67HbP9ROZrXQkSX/tUWdVuZ+ByG8/QPwnSXTCs2DKTfkvrV3r/qedE7gsFHfcrbQ72ysTD1sSBJb88CCnpVdbDG5B/xwoxsjzUm15g5Wlom44MVxJziuIyYf0SIoq/EDv8tJkHKy9N48X1WZKOoY7qwMl8hQtbfivTkuc1IHfZ4wlRuR2zWS+AqizwGA7ktr2P6d92H6FS1pdDoXqysOdq/i4T1yGVR6q15cGhncgKLtuQ3D/LoFMAmZfA56cAj/2lWew8XVQOLJgZXq0UXYgbw32Do9veycafhjk4AlNhPoMw2QCq5MQuC/sHN1XvqZjiCpGPXwcgR2SY0WZDxOWTh2mLRYePzNESOn8xFTPR0csM2v7tzlbAvR6HtrTsUyvoqRlqWSp2eb+rY/9rSloFu4hMXoQXXGEw8/l+8FvSRr1qNwKlmIzqD3vRpELQx/shEXExVzXnxqJZC
 wLdgt/ky
 A/ZC9znriFuMax60Ig51+kICRBHp3otxUdWwf2VEcZ1n73kZPL+v6B7GsAufis8SvOpAqL4d480vcuM6qDY2CAfhGP/f88iMvmGNXtx4o2edAbsdLe7AO/POsANIrfmDfN7BA0LkmJfhj0/5o9BJBnzmqa7NR1fM1Wm97t5M9wT6AKhvlN31P2vA9LBc1/vcf/vcPs7PDa+J105pxfItsyNroqiDs9PyjDiQjrdHrmyxmEAaN5gnjVgEBfj74UjQU4miKSPg9wGwmn9znokBgLmygHWG+0PGccurU0dVrGDngrVNE3VWtyvRyI2nGLMO6neW1XDmVpe/GzgufO+N5q+zSmNHi0DeL9dVe6zuVLK9sPlb6gidpeLOWWuEn8LE1X2BeGAHsUTVLiTW8zHnSWateb1Owz3zFUOGyxPNi38smjYQeZN6ZiUSrUwQ7It+MPIXsjMKxbrRnzcE5rbWZzNPhdB4M7rIovmcf9NSZq5bEPukGLdJ1XW1DEVUvvvtDRTzSfrv0WiUga8Fzae5I4k9LJihSNo8HaaH9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sometimes, vm_area_alloc_pages() will want many pages from the buddy
allocator. Rather than making requests to the buddy allocator for at
most 100 pages at a time, we can eagerly request large order pages a
smaller number of times.

We still split the large order pages down to order-0 as the rest of the
vmalloc code (and some callers) depend on it. We still defer to the bulk
allocator and fallback path in case of order-0 pages or failure.

Running 1000 iterations of allocations on a small 4GB system finds:

1000 2mb allocations:
	[Baseline]			[This patch]
	real    46.310s			real    0m34.582
	user    0.001s			user    0.006s
	sys     46.058s			sys     0m34.365s

10000 200kb allocations:
	[Baseline]			[This patch]
	real    56.104s			real    0m43.696
	user    0.001s			user    0.003s
	sys     55.375s			sys     0m42.995s

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

-----
RFC:
https://lore.kernel.org/linux-mm/20251014182754.4329-1-vishal.moola@gmail.com/

Changes since rfc:
  - Mask off NO_FAIL in large_gfp
  - Mask off GFP_COMP in large_gfp
There was discussion about warning on and rejecting unsupported GFP
flags in vmalloc, I'll have a separate patch for that.

  - Introduce nr_remaining variable to track total pages
  - Calculate large order as (min(max_order, ilog2())
  - Attempt lower orders on failure before falling back to original path
  - Drop unnecessary fallback comment change
---
 mm/vmalloc.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index adde450ddf5e..0832f944544c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3619,8 +3619,44 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		unsigned int order, unsigned int nr_pages, struct page **pages)
 {
 	unsigned int nr_allocated = 0;
+	unsigned int nr_remaining = nr_pages;
+	unsigned int max_attempt_order = MAX_PAGE_ORDER;
 	struct page *page;
 	int i;
+	gfp_t large_gfp = (gfp &
+		~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL | __GFP_COMP))
+		| __GFP_NOWARN;
+	unsigned int large_order = ilog2(nr_remaining);
+
+	large_order = min(max_attempt_order, large_order);
+
+	/*
+	 * Initially, attempt to have the page allocator give us large order
+	 * pages. Do not attempt allocating smaller than order chunks since
+	 * __vmap_pages_range() expects physically contigous pages of exactly
+	 * order long chunks.
+	 */
+	while (large_order > order && nr_remaining) {
+		if (nid == NUMA_NO_NODE)
+			page = alloc_pages_noprof(large_gfp, large_order);
+		else
+			page = alloc_pages_node_noprof(nid, large_gfp, large_order);
+
+		if (unlikely(!page)) {
+			max_attempt_order = --large_order;
+			continue;
+		}
+
+		split_page(page, large_order);
+		for (i = 0; i < (1U << large_order); i++)
+			pages[nr_allocated + i] = page + i;
+
+		nr_allocated += 1U << large_order;
+		nr_remaining = nr_pages - nr_allocated;
+
+		large_order = ilog2(nr_remaining);
+		large_order = min(max_attempt_order, large_order);
+	}
 
 	/*
 	 * For order-0 pages we make use of bulk allocator, if
-- 
2.51.0


