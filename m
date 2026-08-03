Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17C34C55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4591E6B00A0; Mon,  3 Aug 2026 15:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 409E86B00A2; Mon,  3 Aug 2026 15:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25E846B00A7; Mon,  3 Aug 2026 15:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E42136B00A5
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:47:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6DFF914080E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:29 +0000 (UTC)
X-FDA: 85060992618.06.49E2AEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 79D6D140004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Af+zpRdy;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785786447;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCxfaahFDyt0qNqTKutBp2d3QeBYKTWDtRruTDRSr8s=;
	b=6OLiIf6hROWSTeMjhE5aShEoKfyWNnjqdDWDct6gWnY3PJ32O8gO6gsJZt6xZFt/SEXT+J
	6xpgA6NOi7tpf1l5wMc0CnuMWCJCH7it2Mg/ipOt49/ByHLSdGJyK6z+6m8Qxk/9iEioow
	SWmcD4gvmKNmy0h5tGTu7NeAMCqESzc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785786447;
	b=ZJmIX2ASdpBiQZFZPvRCKdjxqnbRlFKZ9/l1mcXICBBs9s1skZVJ4ca/4eA1fePZ24oFE2
	HXdSlbR8KtJl9n5hxj9cqfSEfXHXyQC4N2uf8VPWNIBcTT4gFbHWCkrIAnBARMZ2apWRmh
	Tukp0ASqFdTV300lwcS1kCDB7q9bPQ8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Af+zpRdy;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DDF145098;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C583C2BCFC;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786443;
	bh=S5TdssiSZAp76+zKDFhJcytSk6RO5zBrHmYRHuO0F6E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Af+zpRdydIutQ6SAx43Q3inKaMriMXd5MoFrCXgchJohl7fa4v3MGhkt426MP4s0B
	 aBQe3XG1uMO90L4AN6ite34KW+M8twVLkYW8/PbaLgDGs8OgAEMKZ+jiZz0Cww+3HB
	 KBOkMBc4plqjFAfjNVtfZofSlj8RpyhR1nErY1+QTGRRMdvCR+91CsjcB0S6eerdIb
	 06tImMnTumDIpFJz1AW7oYqmRmY6K0RnADpsiUSMDdzuBua1JjiwSBZBSVXpHTUvt8
	 kHWGffKCuAs4CV3fMPesksrzTepX8fdMVmBlXJARn76QLo2jxpQ67U3YSNZ5o48rYC
	 fNOzrxASBVfNQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39035C55182;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:47:09 +0800
Subject: [PATCH RFC 13/15] mm/huge_memory: mark file folio as accessed more
 accurately on split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-13-4d8dad39dad6@tencent.com>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=1826;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=CJ94TqcOoIUBLTvAe1Ubz/gZmv43vqcSsxqrYElZJYw=;
 b=VAOrM0iKC69AZ7qWggVe+gnW+wnbWJ/uxpCHJjI4Gjx+GlW4HXfap1IE5/CsinA+y3hXAUa+7
 vT7U8ic/6W3CGO/AEQt2ELX54Q2EI94FR/sfhb7iinRxP5+wthKZiST
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: x1xat13zbetbxfwtrfsujphr9p9pcg4x
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 79D6D140004
X-HE-Tag: 1785786447-705584
X-HE-Meta: U2FsdGVkX180mbWf4h+nKw3vA0M6UMfneR7Q/3F1JL9DflBdYmM5ru8aZbaRLHFahLzkYUfMA8p0cF1TtTmQGrJE2/ByE5bbGv61EeqJPiv2oW+jClXQuFNeP0TlBwpXoP0jGb5M06R+UQleNneBvTJwKt84uiM+cvpMIeBUFRyQo8ca5nekSIAikDdz9wgVMOWIPMo0Uv8iQO3KPDBx2ynJxx3hf5ASbhuqGZOXXwVcgul6ZcN/lOpxTsl2q4JM8MjTDgKDwQD8ZSUVsUhL7yU6w6km+zywgXvQ5a1nTzDz7rGzr80OJ9SjwjG1IwJBPElQkRYB8xp+3j4VeiSQn8m+tE4K4bP03vV3H/K9UnKUF3/QLSD+vRb35yQDY6MpSgAa1OAiEpL8Gzr0wpnNC0r8mHaTAUc1G+/sUkmVBZvuJHbtM6rxnoY/v9I0mvJVCBMD3XInUZXnRsz/824EO+pfCTcjRzRNmzwAZwpJImb1RuacadZla12QXzgpaCNn1rYuJ6mfirHmI0pSwt2xKq2G1d203n2bXkll8DFRlSHpWRklgPTIPpvDQ7ZUwIpjcuPerFBsR/BA3wr7Opb6o/bHEmgYldOr2TO9m+NseSOjVcek8jsSDic3Ca8aKiNgh73MgW2K2UHngRorUBkVaT9pfnJNTjdsX8rEzc98x6sBiloGWQDVWLL4LIQcY+8hZ4PB4183FMsXuidRizOp2RKNfR8l99bwXm39jEjUTOPZXPH/U8/48sSkh2EyGm8sFJmlcQsa6LvpY/klZgOB2koIhsZfR/+B9HdembUGQp8L06E1x4VPMlJvD92of0zEV+QZk1VtkjMus9FjOpGgFJ/+63Dsx480vswoDkByX45lyOw/4ZjfeECd/326p19eb0ya6+YE37yMTqJr8RijV0iN8dDaErcQio0vNBTeIRg/oBQdQxNAv/0RCaoocJEO4gN0cuD7pB6dGB6rsCG
 pRQ6u1Ta
 WbXSGB7vYTr34TuC0rQhdDvImeWboSbGQ5+5j2kmA9Wc3yZWCPcVydNKt9NLMP4LxEp+dwJ9y+xUMLGpRVh9ne6VcvFmbF8tForaGrXwomTAAwSrQcHOh6bw6sd1AaXeQ3bllywp5oZxSFtp081IrbJ8XMn9TiygHp9og9JPlkY+Ly6tPmRE5gLfIk3DmvYSdciA23q61YN+DFrorTObI1vDSqbEf5XG0TYh5c4oWWOZXAhYnKDZm2gy2eAr2V+HfPfmaBYEHgix2iBNgXxLSe/bonn1+7eAKtnQALpIOYmmImCljPVKKtL6LJN7IHfHG532ydrZBdL8foI4WMyQ553nBBsPua2Pu7eM8SW+0w1WVibe3Ye6cDJKQRZF6N/H5poXlipy7s3tUeIZdVXGqM2Qp/KXY5v9pfY6emLWlQDFedrSmOq7OpFIrmskxbVcdKK6v23jyhOgn6rE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The behavior of updating the folio's access info isn't consistent for
huge mapping splitting or ordinary unmapping. The page table's young
flag has to be translated into folio's access info.

Right now it only check and set folio's referenced flag, which isn't
enough since folio flags update on access have its rules. Ordinary
unmapping (zapping) calls folio_mark_accessed(), and it also checks
if the VMA has recency to avoid false updates.

So first just use the right helper here to be more consistent.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 21c92ee48e46..043c9ac963b4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3058,8 +3058,8 @@ static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
 
 	if (!folio_test_dirty(folio) && pud_dirty(old_pud))
 		folio_mark_dirty(folio);
-	if (!folio_test_referenced(folio) && pud_young(old_pud))
-		folio_set_referenced(folio);
+	if (pud_young(old_pud) && vma_has_recency(vma))
+		folio_mark_accessed(folio);
 	folio_remove_rmap_pud(folio, page, vma);
 	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
 		-HPAGE_PUD_NR);
@@ -3181,8 +3181,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			folio = page_folio(page);
 			if (!folio_test_dirty(folio) && pmd_dirty(old_pmd))
 				folio_mark_dirty(folio);
-			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
-				folio_set_referenced(folio);
+			if (pmd_young(old_pmd) && vma_has_recency(vma))
+				folio_mark_accessed(folio);
 			folio_remove_rmap_pmd(folio, page, vma);
 			add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
 			folio_put(folio);

-- 
2.55.0



