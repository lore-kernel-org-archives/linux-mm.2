Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A0F360A2602
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=hT7FmSP4
Received: by kanga.kvack.org (Postfix)
	id 856546B05DA; Wed, 11 Nov 2026 04:38:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 814556B05DB; Wed, 11 Nov 2026 04:38:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68DCC6B05DC; Wed, 11 Nov 2026 04:38:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2806B05DA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:38:12 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A99B7C0269
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:38:11 +0000 (UTC)
X-FDA: 85422337182.16.FE2DA1A
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id A24FA80005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:38:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hT7FmSP4;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nNJ7JQckRH+BEIq6xP+FgdYGraXKkj9NjALFdeEe068=;
	b=b3ohlYhNRMF+/xltcbyz66y/9RCf9bvDlPrIYAEjGHVtdtKVThJ/BMG7a0BQ+9BVgyv7v1
	gW7zddUUdZKKuczONlQFmakp6RCQK8Ie0rV6SN7OF248C1Ta3bKS9JclDdJaqUi7pFRNRe
	YBqzlEDspZH7nMHIW+CBAJ5U6KiQY/w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hT7FmSP4;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389890;
	b=TGZQHs5X6SBz/mS0+tsfP8nW5Aq0yCE03Agvp2Vrib1upDJ/yJAkgOBmEeVXxN4/mLxyNN
	+lFVXDEVfk8RgcJr02k25SfMg4Z3xCIkYELhuW2c3BOwNitMD0VDRxnB3JsrCwY9XI9vKO
	VY+zJK9z2jmGp3VqmS+Bqpb2dOhVTWk=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-3704d30b84fso3820555eec.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794389888; x=1794994688; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nNJ7JQckRH+BEIq6xP+FgdYGraXKkj9NjALFdeEe068=;
        b=hT7FmSP4RHkLB1icAxiZeGPxcaEWBFNVIcyD0O5HM4uHOoC2ARUNygkaK/GhWbWsMZ
         nsgtRkHVhS9T/Q8wVz93KrhITZdJ885YLHcYqGJZEke+zDK9KDdQibDn/7Fh/rfk8ysc
         +MdMqjMOgtloRPuJyazr+Bwcz4eeDjPXjTtjcRqXjEpgJ+yXqGtPxtZq/ltfrfxM379Y
         H4OeEuzbJwnBvj0Y2lQST/4QffhJEtE3iMslGxwapLXN0Qh0iFTLROY8mkLzHoZ9bILP
         ZZw2KJ50WnizfW8Z6ZMqjZOyu9v1yy09q6oqoRoPWGicKDmxzH0gzqy6O6oqJeRGsQcC
         n0wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794389888; x=1794994688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nNJ7JQckRH+BEIq6xP+FgdYGraXKkj9NjALFdeEe068=;
        b=jj122tW4S09fMBDrO5o29yua2RQlvZYpwBykaqP+Pu/CSEoypsHRF9U6lVEMl4PEAU
         HPk9QCZyMhjtoKTxzT5RFW2BTGkuFOFGXDl4Qj6nbVUHbp/nbt05uxcduFlTKe2VNjGJ
         CqeAvKcHSjaT0KKuEpbkDVrDSgUC8H6k4KdyCc/S++6bkhVSA07Izw83z2JY8Mz9JPE7
         Ab8eB8lDQuejNHKtremXR2eTlhAV02OWS8wBqLmfzvOki9AicAt456WRdNZQPaA9PZwe
         heMN6GICqtW27oL9o92D8/AhYXdPTxyIlg3U0ukLOGupBebti6REP3VJER/2Qb2A70KN
         FO/Q==
X-Forwarded-Encrypted: i=1; AL+hErH+fqnxAG1HYAgQxEuBjW5ebIO5uUDejuC6LtVINIcSqk0l6jVXwVKvQZTaih0Ks5814bEMr4e5Ng==@kvack.org
X-Gm-Message-State: APuU4Z+pVvZd95tWAfWL6WNY9/XrfYtdZj3Y2HQxihp06LKSbJzE2Nc9
	ud3scA+P+pv1XO8/klp3m4WzUe01KBrrCty3TwJStiZEoxm3Y70r6hXOUdY8xN4Ez3o=
X-Gm-Gg: AYBFou0RWCDbb24Nt4Qe++34gh1hblrAMFvGJZl9e6GxeShBF3fTpH/thkBv06giu8E
	p/ChYYoUedGQaujSFZDgpFPYUl13RoC35Ox1Wyrcvo+VBsJJAganRARAn7BiFeT897Sj6UF4TMw
	LXjLtP+7GSZDxzwSo72kDzEJfsXfoqsTMwvEuct3FqUt6WgLGOqsCjfsNeL8G3IeRXAxLoC+Kb3
	g1TLVv2FP/5shR17gJZZIihOY8cLRvxiD2ua0Qyz1VIh625rW82Zt0BShNdCaLmKqYEtHRD2b9P
	kANo8JHZ3M1HIEjaMS3xz2IB2L6hltDRyUuc906b+nNHtP9zSB3J9ayubZjXfTleVlc2h0aCrlX
	zHm/1Gn+2uCF2HevStJG/jbSXSlZy2GdySvEwx0Mk4Qba1qDppkyUxC5h5zLbxXMx1tBwu/At8B
	eYeM6XpbjUlrUEnU4lsTFZLuFtSU2rKaAP0609qnhz9Vr/tkVKXcjiymnh+0IsnTRoT1yVe6uDc
	xJAvR0y+bcQerCekIkdrmJ24oKi41xEYIqfvgF/Y2mTeAI8XU3nN33zhXUIi+xpc3Ceul+WvIVx
	4EpY+jxMOFc/aLTstCs1zQ1nmx45qpx4YMEGQCvTr5lI42PbCG1i/EJr6uRwqA==
X-Received: by 2002:a05:7301:4902:b0:376:f63a:cb24 with SMTP id 5a478bee46e88-376f63ad124mr1305017eec.3.1794389888322;
        Wed, 11 Nov 2026 01:38:08 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-375212e9e03sm29016749eec.23.2026.11.11.01.38.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 01:38:07 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Sashiko <sashiko-bot@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 3/3] mm/hugetlb_vmemmap: fix deadlock during PMD split
Date: Wed, 11 Nov 2026 17:37:46 +0800
Message-ID: <20261111093747.50048-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261111093747.50048-1-songmuchun@bytedance.com>
References: <20261111093747.50048-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A24FA80005
X-Stat-Signature: z8g76t39bq7ka5gcq5kj5q6u5q13rt7j
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794389889-998130
X-HE-Meta: U2FsdGVkX1+Y2m5C5xocArFzTwhqr+B4CMGEmaAolgBg3SvWnJpPEfAPryRlEQPUNoC2q0uimn8X/r8O2Li1yU7KMlNWZbYSCNqKoeyr0FcP56NzpQR6GqflEUiv2gZ97Dnr8hR6n72ITg9W9XZsXK8gvYM+n6MRUY9ooQW71yStnXxoxoXcJX6v9L8hnfG4ocPPlZ3LtVGVwrv6Y1gAsC8+nG0R3jVNFrKtoajMLoZniB7wb77TpNWP1MjKLxJMAcSyw/ykR1RW2Sh6GVPFuWJdi7D0dfOnx3mYGCJrknzYEdqV2xNJDsx3LX0g0Ir8T0lIsRZfAbASR9QQRTkLsyBLRNva3cCkg17OfXxwSz+7tEMqDmTSXmtrDu8d7W6t0QkHGqxPM/p4wQQFZCzwBJL/KJ6y+fnVL1ipSMWaF1XqDRJyC2vPFgpXpWJrizbvrQkjJuQLOKfhyhLyQgyD1+CGZEyeSpWXxbjZHKPnHh6jIx1sPghnjHO1eLYsrkf/wZ+0jXAhMWg19d2dBrpg/cUcaRtOqWVEgCSs1B7TpxqPpbG485vWM5Be91E/I6qDXzHSH8wNmxujF+4BDNNBbrpqFTiSyUXHVHi8pbQfE90swauyA8W4HiI2DFe9/ZKrV/hFaACBdtbZr8b0Mxkc52HL59W0eDbVz0OZrUhWK1RYbmTdmkZCWDsl8qLXa58aMINcBs9KOL5wlBnsRoBiVK4kKW7beiPHEA+QCEg8c0MknzhX1ZFUtLOwG1vK7t4dRU2p4wm3bJkszySlGKNX5wDoUS3roTSHNQftcxZ1X58PJZ7ERGWcXNZLsZ64cAsi5GZtXb/rSvRBZRCee5Y7Gw/l5XaB3GWZvbAgUHBwSoHU38sVwgMmrKdtFRBjx9ooSdlt5cfGGR1bbAXunzeY3hht4LkvUcQx3C+ClSfFetWL4NKEoJHnzFKg+EaSwgNfZ+oFl5Dwrq9IRYRwtYy
 7BgPQqJi
 WJ/H+f3LrtP/GDrdxRCJ4JAJRsBjmy6835q+bDNwgmNI+/M/sLzUbknJJce7JfwYYixx2loeAnnHSuIpx6OOiT+W9UxPlcBvwhA0LFicPj/R2/YaZL8iVopcK1f/GwEd8w2OxzO+yA/9nGPOtQPT4iJs6e2zWHtT/RS/MYCIC/Vz4Mnh+oVf6bT/TOMl0rtLMXSlh8yw1JaloD7om2shmw5Ie5mf+HtyTaUdz3/49o+totJpR8HjeCf53YCtU3cTV05C0MmwoW2+JRhwfU4Ci+IUPkTxDxr94CdTY4cbiVE8m7cwS00kyPql599fKBtjdrmOpVuf3LHgvBy20iKnrE0wvxG5jBp+pYoNHU5Nhzk2tG9GWser3NQtcWFlanaXR2cvdNGnTQUj91rzaQyx58VeS3KzkyZ2GQaEk6IBB7hpw/Ip6pWhU41OZep+CqfXCa++LxAud7KS3Hic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmemmap_remap_range() currently walks vmemmap page tables under
init_mm.mmap_lock. If the walk reaches a leaf PMD, vmemmap_split_pmd()
allocates a PTE table with GFP_KERNEL and can enter direct reclaim:

hugetlb_vmemmap_optimize_folio()
  vmemmap_remap_range()
    mmap_read_lock(&init_mm)  <-- outer read lock
    ...
      vmemmap_split_pmd()
        pte_alloc_one_kernel(&init_mm)  /* GFP_KERNEL */
          <direct reclaim>
            ttm_pool_shrinker_scan()
              ...
                change_page_attr_set_clr()
                  mmap_read_lock(&init_mm)  <-- self-deadlock

Since commit d5d8b8662e6e ("x86/mm/pat: Acquire init_mm read lock on
attribute changes to avoid UAF"), reclaim through TTM can enter CPA,
which also takes init_mm.mmap_lock. If a writer is pending, the nested
read blocks behind it while the outer read cannot be released, causing a
self-deadlock.

HVO walks vmemmap ranges whose intermediate page tables remain present.
vmemmap_split_pmd() revalidates the PMD under init_mm.page_table_lock
before installing the PTE table. Use the lockless page-table walker so the
allocation no longer runs under init_mm.mmap_lock.

Fixes: d5d8b8662e6e ("x86/mm/pat: Acquire init_mm read lock on attribute changes to avoid UAF")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/sashiko-outbox-206969@kernel.org/
---
 mm/hugetlb_vmemmap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 6fba3184356c..5852b0a1c479 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -161,10 +161,8 @@ static int vmemmap_remap_range(unsigned long start, unsigned long end,
 
 	VM_BUG_ON(!PAGE_ALIGNED(start | end));
 
-	mmap_read_lock(&init_mm);
-	ret = walk_kernel_page_table_range(start, end, &vmemmap_remap_ops,
-				    NULL, walk);
-	mmap_read_unlock(&init_mm);
+	ret = walk_kernel_page_table_range_lockless(start, end, &vmemmap_remap_ops,
+						    NULL, walk);
 	if (ret)
 		return ret;
 
-- 
2.54.0


