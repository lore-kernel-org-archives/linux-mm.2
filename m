Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DBA5C55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173BF6B009D; Mon,  3 Aug 2026 15:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 124716B00A2; Mon,  3 Aug 2026 15:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E44206B009D; Mon,  3 Aug 2026 15:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AAE026B00A0
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:47:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 294941207B9
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:29 +0000 (UTC)
X-FDA: 85060992618.14.CEF708D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 351F3C0002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vzi4z2uQ;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785786447;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wTv3aI/1CDh5WegWisQliObncN+ilcs3sQis72pub10=;
	b=LDy9FiCIUOViljUS6hzHvSnNjsukYN8etwUlko0QLiivc/DuYzQbIddZhQ0lc26JRInlsf
	HXtG5LPSZyvUN65fEqJcZku8j4bzm/sOp4XGM7xiWeAhyDMEeiJC1MIOdzqqJ4H05o56/H
	KiS/98+CrJ6BRgGCqKJH4dKe7JgdkWM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vzi4z2uQ;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785786447;
	b=spd7j6hLKX0TGyoEG42FqU1Yh7Uv5JxHPfVFAPBceuVBE0TeS2lyJBDcMQXEcBxfl0MdXw
	RwBFYoCtjUJb6LwYrZegCSnre8QRV61tJqwQyOkOT8ZpGQahytsL0OPBx8ymTAyREsgo96
	n3xcY1rInPDEqfmKvMrBpB+U2ZHKLR4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 833BB450D6;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61217C2BD00;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786443;
	bh=KnWmpT9oaTCGf6Iw2Wd4BLWFdHkuktfOvH/1O23SoQ4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Vzi4z2uQBatDLSnAke9C7dGrFDH32+Nw8VbM64cqPyRHnSJVf4sNLTmTo+byjHoq5
	 g12QYA+zrgxjU0zoYbN6Qb6Fi4sPXGLMOEbUq+5jhHxsJUcnSkwyYCuQL5SdqC5Hhe
	 5Z4rKW3CuEoLFUq16XFgTOAB2zR8P4qPV8qnRAeItPxDh6DQj2lvnuWCvdjU/PM3DR
	 +JKumL6fI8LU6o4U8A+sSv9+7GxY8MxBNCewE3p/ojT8q+3CBL2i0+lE3706up+xdC
	 91j1xPPybG2pmacfz4OUkPm/F1jKGvpuKNkCljTxfMgADdcCecFuEFoE7Dnvm02qlJ
	 aBwDsOXWAn9cw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D1A9C55822;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:47:10 +0800
Subject: [PATCH RFC 14/15] mm/khugepaged: consider workingset folios as
 referenced
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-14-4d8dad39dad6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=1957;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=HMlEqaXAqytxjGsOSQ1y0vS58P8dpXTZRRV+ITOk0K8=;
 b=hnHXcfL7XYuZF3ifhfyr250b99EXPZETH4Gh62F4nWF3Hz6MzoB9rwDrPS18A+Ns4mOMfBCXI
 K4dGqE5c7HxA0+8DZ2H8QLMV297MA/7uO9Suo8aKeXAAYU/OtiXsZ+E
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 351F3C0002
X-Stat-Signature: bffbwn417ztsgeo3agxpn583h51yo91z
X-HE-Tag: 1785786447-177697
X-HE-Meta: U2FsdGVkX1+bDLQv6CU/6fzVxXpgd6vMCewD/uQXFbCvjGPJlVZWNGNooO4x6Kk1U+aDgwEKJwxnrRm8B2K+NkhrVjWq0ol9494g2h479LhLCfuDNi0S2fL3/WLMEoYKNjcRz+HIddVm38CPuXP5ljN8uFLFvLvRw8De+DYspK3XJQVSIXIuKwHe+mZ4mS4poutxjYctMcFJpTeBXx4Qp2MWLcrzaSYli1rtC71fb8CV/PE172QRfF/fVoWMds4zrXjUMYHldAJ/bq0nqJ/REFUrS9CzTvRI/Bp71GOP5Yd3PEOmwBzkzIE+2d/1qSfTXSH8BKFBFN3w+jTqIf3dqQIFabO5VjcSYP2ilIls7sSOZURVxWtjy9MCKNHOQUljBJd9dtH3b1xXMBD+IRtN/QGkBRV+S2wQTZMc3OUMPNP2gwFzIkyQDDgJS/3k5WKv1cCS7olneol0dRVwykSMO0sr6yCjKwqJ9Q4HvPp96A0J0Wm4lUB3EVthd8BzlPbVmfsDhTajXJgYTuGBbqFGtphtTzf4KV9vNlWUD2vIORy9WLC49lVwp7YPlpr3vh6KVIRinwi9rCPGLrrcfQRmzERsH/cBJHz/fPPQK9BnOxjgwotx05ycAPWmOlE5h2UV1ng2Y/2xwwMEmvQsv5D/2vlnPbcvlbwJKmw0zekxSme6Kuie8hBSqdjnMXKFDH3KiKlM3U2kUneh06Imwgobhf6vgMnCxbHcIr8N0cv28Aehkku5vsL9bN0cTQ38AMtcmxD7i0gNWfAqsDYw6a+D22kXR9+4C+VHlQjRkRps0jF+lFk/BLRna+bqFjVFMrd4tYiRkB6mU+JGMesBYlYSuqKlYF0pIbY7inF9ALjLYceUZ6AWagQOO+3ujJaV/eXrnMrZu3Q6OfuxTxcqYNW3V/SUZpl9i3pnPbVvEdPthK9XiaU/xYGI93U7LmlJ1ifhGst6wghNLlowbkNRWsr
 I6na2oY/
 ijWfEvFkxNcMHINHoIFELxmjLBc3iHwQt+7SOYzv3mYyWTf4rete8mi9F8O4Nx/VADA1l1H+V7WtpGuUu6ubU/EzfD8GLIuSHoNTjf0iI9rtLg6jjXYN7e+s1VRjRV1t0tk63rRAzbWXr24MXIVZo1mbnd454cz0flgYZrbPtOAjQOvtD2U1j2LV9l4V7jVHjRaDbg7ASr/20jT38ul5fbmwC5koVaG/k/KnWlnbPYTR7eTn+o6xg3tszKxDhHoiC/wbwWpj93g3QfWDQPxeBa4Rmy4traG0v63RV7SjZUOkP4CUbeXquNJJGjcjuY1cKBoWrqdnIQgJpLTtmVg+jtsZ1zcRvYZ6guDljy1cKNDj7KfNSQ/dvbFa32l3dkiVaSaFP0VDDuctqWZxuulA2OqumhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The folio_test_referenced check here is clearly trying to test if the
folio was ever referenced. It was first introduced by commit
8ee53820edfd ("thp: mmu_notifier_test_young") as an supplement of the
young bit check.

Folios are marked as PG_referenced on first access, but following access
will clear their PG_referenced on second access. So checking only the
referenced flag is not accurate enough.

Switch to use the new helper, so we can cover the secondary and following
access from MGLRU side. For non-MGLRU, this will make it return positve
for workingset folios too though, which should be OK.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/khugepaged.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b237f6e7662a..86c9b07dece6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -809,7 +809,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		 */
 		if (cc->is_khugepaged &&
 		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) ||
+		     folio_is_referenced(folio) ||
 		     mmu_notifier_test_young(vma->vm_mm, addr)))
 			referenced++;
 	}
@@ -1767,7 +1767,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		 */
 		if (cc->is_khugepaged &&
 		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) ||
+		     folio_is_referenced(folio) ||
 		     mmu_notifier_test_young(vma->vm_mm, addr)))
 			referenced++;
 	}
@@ -2752,7 +2752,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		/*
 		 * We probably should check if the folio is referenced
 		 * here, but nobody would transfer pte_young() to
-		 * folio_test_referenced() for us.  And rmap walk here
+		 * folio_is_referenced() for us.  And rmap walk here
 		 * is just too costly...
 		 */
 

-- 
2.55.0



