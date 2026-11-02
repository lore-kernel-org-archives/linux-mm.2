Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7409606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=WKWvf6O6
Received: by kanga.kvack.org (Postfix)
	id 002C56B05C2; Sun,  1 Nov 2026 22:27:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECE6E6B05C3; Sun,  1 Nov 2026 22:27:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE5276B05C4; Sun,  1 Nov 2026 22:27:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8F9C6B05C2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:27:11 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4117C160ABD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:27:11 +0000 (UTC)
X-FDA: 85388743062.19.D109C17
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 801A440002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:27:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WKWvf6O6;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793590029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VRYuw1luqS/ww3kCs9ZujMYb2eCvCkQYnqlhruelWuM=;
	b=dV0c/A63zSqvMK7Sxt09rXOTvn55i+5GI5wSmuxetAfo4Naw4y5lh4lRHwVX8YQAs904Aw
	kpfXuSqmpaJgfMnhBIG0fG8dcUNxRWHWIMGXruMBz1LpdOal9dV7w1HKmFd4/qgdzcR7rg
	jSQyDRt6fdyrh5lIP93z+jDBmfjgGNI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WKWvf6O6;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793590029;
	b=Nl+kORX9EtFDKN9vt3psugz6csYv6nymGkhL4s6RnuPqVbEAakC1sjMuzb+lNmg9Tz32wC
	FflFc9IEqwnNcXOVriAy4xx+HxgfkIX7gsyUzOfvomTNeNHfxVIvmLBq1j/p6z6AiMSaQS
	uy4LfPpJ7vottA3OstOYcaIaxVNL1Gk=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc7d154ec4fso1071373a12.0
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 19:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793590028; x=1794194828; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VRYuw1luqS/ww3kCs9ZujMYb2eCvCkQYnqlhruelWuM=;
        b=WKWvf6O6HgpYt+0AIC+D7RqmGh987/bkcoHIg7MP78X4M51h6ChBAH58AWe/MtTjs3
         OWOmAZBIVkEEujBhUxwyI/Z9I3wVbYfYzo4AQpIvRTQo+jo67kZ7KcNbOlH98NoelXO2
         idBmZsuhHhod4TgMp8CYN6N+q68B17JsNP1o73+I1cbCP6n0xm5IXB9p6Of37j/JUeSr
         FobuKUrBoLt2fgEOAqw5e0JLttWpg3FgavzNWqpWhUIhK2vXtaBkp/wy242PM0aMX/LB
         kIoPQcaRKNkLS5hxSki8RaEdVN402W1JTbFr9YLCiiD6P1TeE9BTYMbX2hjOfBf4Sjnv
         UHMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793590028; x=1794194828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VRYuw1luqS/ww3kCs9ZujMYb2eCvCkQYnqlhruelWuM=;
        b=2L5+ip0SPDC5pGApNxtXpFOR60JsB8v8Fr5u5O1IaTb9qtgI6kcP2K1/GwMgextPQ4
         qMPTJOT0s6Y2MBGlWWusUXT+6+p8S8gcr69wDmZb+hIt8Gt3mE6K+suAAu9cHm46Okqs
         7YZRx9/HgmLybtDAH7kFZZP3CtAaUxpbbMxUxhq3YIiu7X6JfMjY6pcsUBiSbm/Rg617
         HaOtFA61d9sDXkxc3qB08GRVvbqVaeD0wor99LvyVEAL98y6LyFVbFbsIM3nXEADYl6h
         sgaiUrFTYUTVE6c5tFngEarf/0YUk1aC5zeryon1OJV0XIKg3qGUxP8s0WzV9xZ4/P3w
         r/Xw==
X-Forwarded-Encrypted: i=1; AKwUvByoiCmxrhsog/gkGLSHR9VPAUR8zcv+P7ugoGJI+S1fwoKqfadIP9ocQk9fKnodaOWv08sHf13lEA==@kvack.org
X-Gm-Message-State: APuU4Z8E6UEF1Jb7KW7RlRR42TBO/5Y96GXCUvtC2EQox+JqciHlhlLG
	a5oHmCgD4NWF0aYIKbwdBP8dBj669TE4lW5LRsAY16HkfpEtErOy8AyJLdLKcovGjc4=
X-Gm-Gg: AYBFou1BA3T1/cQ0Ep16i3WWDC/UHIcKGZsIBzCIE6TPxeLh0ZGlW6Xd/xoCmBJuGeX
	gRyWEyjdCbpTxdr+AgKs30gU84mTVosTyIiQNtOjl4J11w/I2JjpjEriC/DPWpTmFkvANyDe2Yf
	//CoVDjzj6l7bwD35XZXcC02bNtuEanEiniK2uobaTYv8TjXkCkigcBBwm7pSq9Oc15mse73dLe
	llFjn0VAVmj4oSVYBY6tEZtwpX1dJIbvFNTGXKVeXLJQWQrBn9RmF5j4I/8EG90ueWjvaJh2dtS
	jKW62JK1fjbGbY88wFuXvMJ6q/3RPpntSHXWnNf9KTR1p8AQj2b82kp3OnqzrH7RP9v14kSOsLl
	/7hJ54+J247p0PZ081e6D4uQrtp/s7G4Yr/xpsuPBd687ftrrBIcbD+U+nCnAMIS9Ine+5bVpuX
	FHyH/t83UnY5+nT3IgmomTX9+GD6x0pRW7rOk8gjMwl4Mhm4cLGIIHi3rEn2JI4SU5JWELKc5Mz
	4Xp3tzjE5IH+7kLjLWz5qBrxItaeXIUQ0jIMFtuzfRbVDM/7A0q+A7xoBJLtneWjOAf43GWPCLj
	eiy9j5ZS9Ftz86Hi+289BbCOThCLrV7DMN2hT7SqxV5do7kjoT/lPpagaVWBblS59iBh4HE=
X-Received: by 2002:a17:90b:562d:b0:3ac:8527:3fcd with SMTP id 98e67ed59e1d1-3ae898385a1mr7245105a91.39.1793590028314;
        Sun, 01 Nov 2026 19:27:08 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae845984absm12303317a91.10.2026.11.01.19.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 19:27:07 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 12/12] mm: hugetlb_vmemmap: make vmemmap PTE conversion folio-oriented
Date: Mon,  2 Nov 2026 11:25:25 +0800
Message-ID: <20261102032525.3597743-13-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102032525.3597743-1-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 801A440002
X-Stat-Signature: 9k41eqjr6diys544u1ryksapb3xfi568
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793590029-154601
X-HE-Meta: U2FsdGVkX18Brw4TkuLVwCqdVNC/2ZvFYVwa9HajD7h7OqiTa/J4EWbfRh3WImu7pXwHHAJQK9OQH/NjN7/IsVBJU3Vk5Ao3fbJiqO0hUDCvoaBR4sVJzMr2SNGogakRtkWHt8G7YyNcb+BSiuwFYBdHerFsq0ciIrnLBD5ScKT7a7i41JR9x/f9XOTDAe2u5afcCD3Xf1Hq+wGbIJhIlJyDIWrf/m8Vedwu6/jLOLCGVvVQHaD2MTycr2uEENZ+DJ3SQ9rwHhMtwpTNI2K8V4dOkHMtUfqCtdcBmOIwaU89xMqbvGTbo1wMt/cYkgoJbkduv6oqTJfSCEmpzRofUNOhpGZs1XunXT/Ah+oyN1Cnh8o7KfZvdvpXnm/Fl0Zvm7fnWvXgqPa1AnjQFp7yvyR2aBatFoHP+VY8fvp/l335gk2zYkE5g1dNZ5Tdth3DjLyC+wbdqlGb6TW+tIadQdpn1HNxCuoTg1c93EcBDSfSpNNpBCCQyIg7e4UuaVyM4kK1AkEfM2wywR8uoEM/SGYaSL1QNqQpCV7WR7/U3NQ/XxEKqyJJFAZKveOZU6pkl7RTwRrX4rxPidPTxOLb1t1V8HAbWOhE2BvQ9tIxMz13XfSTazGPNBt5Wzh/PNCSWeDa4ec6FgnrGuOIVFByd12j9ZIPGOIq1+jKF26R3dvYLAZzs8MQcxeXM4d/c+eGVM30fhoeoG+iz4AtE204TtfXcqcdttpOzfk+d0MOvmCEuHRuD/Z0n0n63kWo/JT5/R2FHyKk05iK7ZIem7WiXdowkLKuIDn73e4WR3eWn3eb/11Tm0wvkZuF6ESlw/g5iwCvyFdaLi/NaubWrfqxISxaaY7tWIaAHIHvr4kIZoSGeqL/WKXOLqeJQ3oGPHp/Z+V9rRwi6mfw+XiTRy/WTXl8cAocgvy/maoFd/hYx+OYuB91r4oElWqnPRrA8bdGCUrAiK+KhO516EF70uo
 NphvHdvW
 FnpX2ULzNCVzh0CXtXPUIBVIl0rFyxzd1zGa0str8WfIdT6ju7ROqmUuPMuVhfS6EnjhBDkpOoaqWIjjmXCcL2hoPjQngVREykN7WO93FTs0sP8o56yn7JI/RsGhYKkh7/mxGZC/emKeQJUlyo6v092Ar9NMYOK4CMF5eBX0X9KUkRLRqy2iGu2M/s/BGDvtm6XP849nSZn7GPLPAPlp562Dzz2ED26CCFmZBp1sBXTfz32TFUBTD6yYpbZFXHmHb8jCf//Ht7876fS+9q86Mtk+CK0XWC5f/k68Ykay1LpGOqfbbrNI3fEYYRaoMFXvUuFfzGHKCnDGCNFPX/sw4cEfZaew1oN2Ql7f1Ah+X9skRkUoMC4nX6HgWqJ5bB2bWlAiZYdlxScFvhS4G6S/IE6MghdM+yPV8B8ykEbtBAsUzPKDrBqfPx6543zq56B5axOa6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Converting a folio's vmemmap mappings from PMDs to PTEs is a per-folio
operation, but the current interface exposes a raw address range and
hardcodes deferred TLB flushing.  This splits the common mechanism
across layers and couples it to the HugeTLB batching policy.

Make the folio the unit of PTE conversion and let callers select the TLB
flush policy through the folio-oriented interface.  This keeps
HugeTLB-specific eligibility and batching outside the common operation.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 370e604c8056..c04f53f708d2 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -300,20 +300,26 @@ static inline int vmemmap_restore_range(unsigned long start, unsigned long end,
 }
 
 /**
- * vmemmap_remap_split - split the vmemmap virtual address range [@start, @end)
- *                      backing PMDs of the directmap into PTEs
- * @start:     start address of the vmemmap virtual address range that we want
- *             to remap.
- * @end:       end address of the vmemmap virtual address range that we want to
- *             remap.
+ * vmemmap_pteify_folio - convert the vmemmap backing of a folio to PTE mappings
+ * @folio:	folio whose vmemmap range should be converted to PTE mappings.
+ * @flags:	vmemmap remap control flags passed to vmemmap_remap_walk.
+ *
+ * Convert mappings covering @folio's vmemmap into PTE mappings. If TLB flushing
+ * is skipped, the caller must flush TLBs after all pteify operations are complete
+ * before remapping the folio's vmemmap pages.
+ *
  * Return: %0 on success, negative error code otherwise.
  */
-static int vmemmap_remap_split(unsigned long start, unsigned long end)
+static int vmemmap_pteify_folio(const struct folio *folio, unsigned long flags)
 {
 	struct vmemmap_remap_walk walk = {
-		.remap_pte	= NULL,
-		.flags		= VMEMMAP_DEFER_TLB_FLUSH,
+		.flags		= flags,
 	};
+	unsigned long start = (unsigned long)folio_page(folio, 0);
+	unsigned long end = start + folio_vmemmap_size(folio);
+
+	if (!vmemmap_optimizable_order(folio_order(folio)))
+		return -EOPNOTSUPP;
 
 	return vmemmap_remap_range(start, end, &walk);
 }
@@ -532,21 +538,13 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
-static int hugetlb_vmemmap_split_folio(const struct hstate *h, struct folio *folio)
+static int hugetlb_vmemmap_pteify_folio(const struct hstate *h, struct folio *folio,
+					unsigned long flags)
 {
-	unsigned long vmemmap_start, vmemmap_end;
-
 	if (!vmemmap_should_optimize_folio(h, folio))
 		return 0;
 
-	vmemmap_start	= (unsigned long)&folio->page;
-	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-
-	/*
-	 * Split PMDs on the vmemmap virtual address range [@vmemmap_start,
-	 * @vmemmap_end]
-	 */
-	return vmemmap_remap_split(vmemmap_start, vmemmap_end);
+	return vmemmap_pteify_folio(folio, flags);
 }
 
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
@@ -571,7 +569,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 
 		nr_to_optimize++;
 
-		ret = hugetlb_vmemmap_split_folio(h, folio);
+		ret = hugetlb_vmemmap_pteify_folio(h, folio, flags);
 
 		/*
 		 * Splitting the PMD requires allocating a page, thus let's fail
-- 
2.54.0


