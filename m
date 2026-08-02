Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F0CDC55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 19:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2064D6B0098; Sun,  2 Aug 2026 15:53:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D7486B0099; Sun,  2 Aug 2026 15:53:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C6D46B009B; Sun,  2 Aug 2026 15:53:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9B4D6B0098
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 15:53:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 55001A1D14
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:18 +0000 (UTC)
X-FDA: 85057378476.27.B207621
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf17.hostedemail.com (Postfix) with ESMTP id 669AD4000D
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="k Nz7ivY";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="V/LoVwbA";
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785700396;
	b=TDxS1DfNDdelKsWMct8jIgfSBOcEEHtgIQTSMh+4LYeexddI2L/PIDUWWCK3OS8glclgTk
	6p2p0vwtE4vyUkDDS3NV89O+25jX7lsmJxUu3D9UG6AGm8Evd4GEPRK2/BL1dn23iMM6oG
	9MvfECofOW6LciFsiibBs2hORFgvcMc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="k Nz7ivY";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="V/LoVwbA";
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785700396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H44JK26m4Zj+SfIrO6VuSUoR2cZlhVi4rAW+EimBh4E=;
	b=Cdh20+Pbscdkxv8qDqlO3SaF8rAHGX83q/t95l803BYDUqpjDiymEOSumL8ICmDbp9/txn
	FjLScUlW1oXn6rMfxQePVjY7QZLVkEPaIdryii0+LoVeDgVWUPrsuo22xawXMNJS74UOiM
	dtiHtqIxiIkkkP0wPPYOR8v6jdbHOk4=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id EC3AD1400056;
	Sun,  2 Aug 2026 15:53:15 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Sun, 02 Aug 2026 15:53:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1785700395; x=
	1785786795; bh=H44JK26m4Zj+SfIrO6VuSUoR2cZlhVi4rAW+EimBh4E=; b=k
	Nz7ivYDag2BKut0ro5VbcV/4kBFwahLe2YjpLoej9Jyi+ixkAEdALVL2Af47PFux
	J/X1n2m1RE3Mtml3fpY28gaQ50mjwTFpplW6PcV0/jivcGK1o56SVk65a4aTZWjs
	0blXcDeARdqn/juo34WKHZA3DpqC+q/VqME8byj4DKvM3J7BpCOCzczNGNvcEHnE
	EUt51VjqEokvRDWl/svtQ0CbWuk6oBFTY+bCJu0OoJgRK6kwTa9gEIFR3zHXkuWc
	B7OzMsDKcZpPzGR0CpVJynuWPWZ3ZL60OsnnSMBJ2V2V9d2lY33lG9tNk3V7/w/k
	zDGmIw1JlpxsvRPqeYy1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1785700395; x=1785786795; bh=H
	44JK26m4Zj+SfIrO6VuSUoR2cZlhVi4rAW+EimBh4E=; b=V/LoVwbA1IbgqMEGa
	H24kE8AQoXybM2lBxYJFwN4mDDGYX7JA5OUpVY2eSRJXJxHvqfW4Iz8p74d8maUf
	TYIYFENy1CIp/Zbav4g7hx4Ei+NrlGhHEtzzJrwZ9E0we3CoV8ExZUAlJpIPCrqU
	bAljleKHnp4Dz9xoFpNfqaT7Gj9+RVEgCCSRVETi0TiiED1q1aMWOul5bnGF1KUD
	hNr9aaOrJESiBPIArQ55pX15/frvXqG5vWKPamWLsbzmsuwGihV3jI7/eS44aJak
	gjZXnJrtyZA7YcvOA/f7K2TJT5H6wCaRddNOomMcSVYwGIaZh4SDTy8zOD75mKo8
	bP8pw==
X-ME-Sender: <xms:K6BvakRh8eom8_Ld5GSEQkdMWuOrTn1_JS1yC5GcYl09VEGEiMichA>
    <xme:K6BvasQplTOME6kZ1Uya8aff57qkpjA11hu7aFpMB-grxSDtfKbkQwZgQfCuxCYFY
    CcIivhada8MK0FdWbAlsyJKV7VvRA6g0xfikiZJklqE83D_ikSmaoOp>
X-ME-Received: <xmr:K6Bvaux93rgGQLjmDdat9CQA0sFKmd4qU-uyKke-w4D_zMdWie_C79k62oA>
X-ME-Proxy-Cause: dmFkZTFcbv35QwNbwWPHQBcJdrWasH4YRFOBaNWig98oa0GgLD3LmQrthvyDgK5JnDhp96
    dBkNywOXlTP9Hby+cm0vRQHofuB4BhsdtVcBrMer/A2AOpegfr9Hr7RYzI6OqquxWhxeXC
    aB5bOw4cR5G6EDzO4v2r94SJnXRDYvi2NMwyCB/quID+suEuw0TjLUMYjjQ5pFm1F3OqpQ
    Ctej7rOharBpUeBz9hjZojzUlseCYYYMV+BulSa6+jD3O5m4ZOeULsSyQlLb9bciCyrhiP
    bT+z0cGYr8PFizBGTpPnPZCe+jZkx/DQlEsoaoSV2SjHlZpE6q2+n/t1AcZaLqu1qPGmas
    PhunGhbdXSVZZ0JW2Q7u2nd7H4XKfvnaBGal6+JQcn3sAZmJmQi/ZpIuGEya+WRJ2S+d86
    vxuCjftE5heNijEnl+FTv2HJYJjIZgU9pge1DM+9loyjS1KVWWWm/0TYqsnaUEWxQ+MIWw
    gG8Bj5uTuWOLL9k/NeM8rR66FsqQ09OYUZ8FlGkoxsmuh/Uuke9lLp3v92RwsVo8ecKtww
    TryvXTNqp/4AxVhP0g4gAko7bDM6IlXDicRZiOqygUSyw9IXXAuAeTnh/OHn8my296Jwm1
    uEBU/1jc1apLoQukcKLULVKlskI2rytGv0n8FgG4Xq9cXjyfAtOoDLD4jhCA
X-ME-Proxy: <xmx:K6Bvaqts2nQDudW01QQH8DIkKgJnWBGlaeYNNmv0PNhMyvGwKqNHKw>
    <xmx:K6BvalwqBEsxfUEs-kVa4pws498HnLspE54o5AEYlTYZPl3jjpA4QQ>
    <xmx:K6BvaicI3Zlqy-PQI2z3VPGQIOZPcUV2kwyU4FuEyJlLKYRYVWZtNw>
    <xmx:K6Bvaj37Gma1iABQWWCQQKcwidQqpuqsZBc-BBe9WfonAwZeX5MqDQ>
    <xmx:K6BvaiNjCW6LUDIX5UaIFKBG6pyQGm78sThDIwuE-cjopUTeq1-2rXK8>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Aug 2026 15:53:14 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Nico Pache <nico.pache@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 08/16] selftests/mm: skip collapse_compound_extreme where the PMD is too large
Date: Sun,  2 Aug 2026 20:52:40 +0100
Message-ID: <20260802195254.1937477-9-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802195254.1937477-1-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tbj1zcw6jugdr8o1cd5nus5rhw4to448
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 669AD4000D
X-Rspam-User: 
X-HE-Tag: 1785700396-437965
X-HE-Meta: U2FsdGVkX1+Z7Cir/d9EOQium0Xdby37JXu6l2tUlw5F8bQTVVW3xOyEr0/f3WfaQ/rk9yQ/V1yHCTAcvPwF+k/LRyCdXCBNQaprsWiDBOGXFhBjg3Ixwbl27RC1IGZmzBH9jsqYvYM937yRg2oSmJMoZFkBu6T2Prz/lSmRdj2aM7JoD/Syfn3R20qPwbFsle4GpJw6CpnShwtAVqsJZHXIRbcefLhiAVp4graNcrEyC6ZmKPZvFYGoYbUz3nnuL7ZlBQiOZwEPPDjOzh1k/0dQ/mUW/6okl2MBYqtvxsRQAJhjwuD5E8mnzprgl0JK4nn8mc01AAIw6CDBwxyyb0Qwf2uJ1Gq5Uo8G38xsDLs0Y8fLoxtn0Fa2VRYaAiop885mKeen2HKw3nVomCaEK87VOAvNnwfOdsrJ6eU7HMI1Q2pVKdmfE1EkwaETNY1RVfWUBD8HDH/6rCANElK32Ml3TpvGQvHnnbbIp3Ui5YAdkV6wlj3j/PI9PZV2BRi4i3ZDHpPFEZcS+5pFtzeq6vQaRYZiLugpYJJaOcx0jt/fMicfd2r5k3C6oRoBjfL17Is0svCeWsN0bXNNaqzEw4ZAEkQGsjyRsxbEOH3N7OhzGKpj4xayxzcx5RlDVVcQiNU2ce14xMlavIoMb13WPtWge1fJbOcnJah2M8Tctsy5YNEfwANEgAWqCyvFw/x3ikOil+XkS0HAJl7ktpXeqm1Ys1RNK6BF+SWghTbSf2nGDeH2YfXf+gJoGSNkh6Y8It393RLmJljxSww+FGXDbUQ5whiVlwVOf0+hkKUdjjBR2XftiaA70SYWQoNDta0d5ImH6YpJI7bqh07JJYmQf6FSIZjrjS6QVLffhnPxyi1rAInmnnGAVqkznXo4Y6z0FoE8N4YW3X3iYDNO+ohPwTv79mXYep/VBFuHu3IEZJzmlmDYKwOKdibSpmBidqoxCkO6IwXI5VvZ0cjZ9lk
 OajGgoIE
 2UPM2fKis6gb28EVa2VKjzf6UIYahB1iBJR/ReYebWWJSfPs7eOc+g23HEvql2IMhczfvoVoLhH8Aoqxjv5dGpf83J484lUA//9/hFScxy4RKApqqcj6vnJrQwIIh/Ughg1+IaiCyxP6rqE8cPFq76zmbDk+js+ZWT7alUX5iHRe3QRobV0IiD6cbavbu+MFIyfogY8cKcg3sfNmMMZUv7sqjE2F49h6+IYcNZuuqH9YIj9hZUDQCToWSR0bdPje7J7EzsmdX6knohZvpnR99+47B4xPEfTli2mcbRiN+QsKy1zzVyd6JpRqNjbGOeLUfi74+QfYEoowJRchbVPqVMCyVfyT//pA09EjA1CpVqUwUGS+QSb3CQ/YJXipdXVKeLw1tHv0/Ho4Q+pdLAdgZt1JEi/dOGK3kTw+felaNeEULWfTL6Cs6V84n2D86oWl4LoPN9tQm5ylibKN9QB3A1y1YprUFiFc8ksWnvvxfTvQyZX6J+8InGgoyfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Its fault-time THP construction (x hpage_pmd_nr) cannot hand out a
512M order-13 page on arm64/64K, bailing the whole binary. Skip when
hpage_pmd_size > 32M; MADV_COLLAPSE-driven cases still exercise PMD-order
collapse there. No effect on 4K (2M) or 16K (32M) PMDs.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 81001e15765c..b43e060b4118 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -857,6 +857,21 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
 	void *p;
 	int i;
 
+	/*
+	 * Builds a PMD's worth of distinct PTE-mapped compound pages by cycling
+	 * hpage_pmd_nr fault-time THPs through mremap. Fault-time THP allocation
+	 * is best-effort, and this needs hpage_pmd_nr PMD-order pages in a row:
+	 * fine at a 2M (4K base) or 32M (16K base) PMD, but a 512M PMD (arm64/64K)
+	 * is an order-13 allocation the allocator cannot reliably hand out even
+	 * once, let alone 8192 times. Cap at a 32M PMD; MADV_COLLAPSE-driven cases
+	 * still cover PMD-order collapse on the larger configs.
+	 */
+	if (hpage_pmd_size > (32UL << 20)) {
+		ksft_test_result_skip("%s: PMD too large for fault-time THP construction\n",
+				      __func__);
+		return;
+	}
+
 	p = ops->setup_area(1);
 	ksft_print_msg("Construct PTE page table full of different PTE-mapped compound pages\n");
 	for (i = 0; i < hpage_pmd_nr; i++) {
-- 
2.54.0


