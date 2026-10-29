Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA2A606A32D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BizzfTpX
Received: by kanga.kvack.org (Postfix)
	id 029216B05DF; Thu, 29 Oct 2026 16:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 000616B05E0; Thu, 29 Oct 2026 16:40:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E59EA6B05E1; Thu, 29 Oct 2026 16:40:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BEC556B05DF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:40:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 566ED8031A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:40:55 +0000 (UTC)
X-FDA: 85376832870.25.39DE9BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7615A14000D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:40:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BizzfTpX;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306453;
	b=cmIyvSGNXrlF1Hasgj1YWbNbrDT9rLiCptRZ++4p4JcTaVlZKN62Dr2lubZPTqRQx/daZl
	S5t10QRHUT/6h6JsmkVx0ucKTSqzb0e130vZBHxDgX7Jla5je4vWwbMs6dMQpcw/9WCBQ8
	AsOek+h5rpP4cyc4U72FHPdYbPsKE80=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BizzfTpX;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X+A4bDZDQi3RaQKtCdHq4Q8CuoDLcygQanGTwpRAvoc=;
	b=NT/M707qDJTMwX9Eu4dSgFOhPx9zUUS4aM08WTfApDLk0yVZ35wfh/IDxf8aeBWfHsBFGa
	idZVC0vxyMYXMJcsPpA71hddDSrRhTZ+nzz96Mr/04LK/u5iwU07DPkZQj8PKCoDbmnsso
	/K3qo3QBDpq4s7SYaBI+nqd2YDQtO+4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B040A43981;
	Thu, 29 Oct 2026 20:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BA41F01816;
	Thu, 29 Oct 2026 20:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306452;
	bh=X+A4bDZDQi3RaQKtCdHq4Q8CuoDLcygQanGTwpRAvoc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BizzfTpXd6POIT2VXSctKqd3AYlrKo21t0yuW7k67ZzOykQkrmsF70tvdF27m6nHR
	 yNjzirG7yxUIMePV6cd6o6LqX0pSAl/IgEUme2KHxm9O9PpZuALo6dRUKAQxGfhH+t
	 DA4gWLZ8yol5BW+DLrHcMvUGxusQPKgKUrtfujihDYvPnJt/TJ6tSS39u2H8P+KZTy
	 nZoUv3JERjR/gKqqgwAYI7hfD8T9nuqpmpfN6GDlxYR++om/RP/DZmQULDWoiS4s/L
	 v9kzIakhQuG4RHlpqlhNNq5l4cyBf7BOUkPJX3p8OED7PzmsQ16EQbSRbPchOgEa/p
	 CExcoOfTYv/tA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:25 +0100
Subject: [PATCH v2 30/47] mm/mremap: use pudp_huge_get_and_clear() when
 moving huge PUDs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-30-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1293; i=david@kernel.org;
 h=from:subject:message-id; bh=Bwj0I+EdpwxOB+DXKGU57G1Zy0OI6QgT1Ao2qNPPN2Q=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer+1YqffjAfvFE1GvVCPrynaJrxGaF5yRGLK27FbyY
 f3NFjY8HaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzEtJDhvzePiszu11vf/Jz+
 fcHuUKufNir2r8+1Gp+U2pslsLRl02qG/4lXDK3vLmCe9X8G+/cET8cdsvu85+ru1m57H2Vyc9r
 crywA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: dqtjzyuu9nahm17u7sexpm979uss4nzx
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7615A14000D
X-Rspam-User: 
X-HE-Tag: 1793306453-32435
X-HE-Meta: U2FsdGVkX1/JQSuVxfBQjtXQLZgpXm/iSo4Mngwrwmv4MGsWTds52PB2p/spkRCEqJEAXPEZ31sJSh7cZrPuxwD+WqzyfKZT5hZPYJ4tiZfOCfk/2czmmpRGV1l+yhzZbrHo6h27jDOQZ/JkQQuMkcpkHbtuYWYbX3OFlrhkL/AWYcyqia9eTmIfy55HKOTJ/dDUyfrx+RQ8cYVhspX4oSYOJorhfrLhBCHNrLboHG2Z4D5C32sT19THwz3SAo0eNd8rG9CH46fE/OEz1Hz26r2w4XNyW044TcP0Fpr0wX5MBBr/tTEdY+A3kiVnreRCd4As3mGXzK2Px6QPZg00+eEma4gsnASZh6ndafNdSPQsf7AIIysgXCsZfVSlO2aFwpDlwZ9kk3ZFMD5fTkjqIyFbwaWTSDn817yHCHvQiCF5ZDStfHrGBp/65NvpRuZ/81ZVaARs/izptKZzrh++P2vYzyuUdCfyqBFL77y2v3wI1TMZgrM45NDBt0a/j3MaNGytIxmShtvT6i1JHoT7zb1ajILKI++V8eYHt1pQzAVR9TH4EzIkdcMeJ2OB4vnggBz1ozHE/fj1Ptpu/H27Zhr3AYqXbZ0LgUUa0uqyHuH9yxm1nj6FiboWcVlD4M7EMLxaUpzSpE4ud5ZRrpztQQtRF9iuPreS/nGXiHH+Byc12ViARQExTKbLLd9Dvkx4tVQnopJxkVqeK51nPSG+0ngWc/l/2iuVeh+loiQ0q5OYh5Twx7LCVErhjro4rsv73FHdgjrXTgvfKBJvqY9QucIGAdmbOMvZGNurc8Vl5sdIykTXM2AbGQFPlAKzB0qwtBhaMzoQe/1bHeeVqMSZwa1Oy3yjobniQB2lx5eeELfFnMiGq4NmYXLKWPyiLre5Kssy4MdP/ry1rzBm44oJFq2HPdzD84ioJxcvz+8wVHxYHkgipXwwmwObx91OOKPJLlqtJMX13Nk0G1B/VQN
 jlfk8Gir
 Ctx9JKbmTEiII0mw4eOQaEDTE3NoOAQ0vbuuFs+Xg2A1mB4NOfKQZp406sHRqzAasOBkSpu1ZVEVp29F3TuyjbUQK2DlRBq26l6SAFIurUbH+sngoK0wKQxsM0YMSDHM1fVHPVZkcDnhpLsolsXFhdK6wjBCOSVlogG3gidZCJiQtGlqMb0u3NqTIs70dWFP7pPAOatxPwMU9QIJ5/zUerdvby26o02MpRk6UbYPKYTh70LiZIllB3AzFuofdSjH5ZRRWd7jpUzsAo8+utb6kQFzEP17lqQJZF4hzbWpib/Phx1BdP4LiERuxhyuv2WWFE8rDM603VwzcDN06BhFhcU9n4gcvL6aqQJhBw3RpJwzeMf0KCoAM1bYcapa07rn1Jw+kU3ujLXi/TWPubjmFIb7ukQa/kQm4xdsabfxpxtfByk4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

move_huge_pud() reads the old PUD and clears it in separate operations.
Hardware accessed or dirty updates between those operations can be lost
when the saved entry is installed at the new address.

The raw pud_clear() also bypasses page_table_check_pud_clear(), while
set_pud_at() accounts for the destination mapping. This leaves the
checker counts unbalanced for mappings tracked by page table checking.

To fix it, simply use pudp_huge_get_and_clear().

Fixes: 7d846db7d0e2 ("mm/mremap: convert huge PUD move to separate helper")
Cc: stable@vger.kernel.org
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mremap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 0d06d7f37f19..16e736c72d9c 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -509,8 +509,7 @@ static bool move_huge_pud(struct pagetable_move_control *pmc,
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 
 	/* Clear the pud */
-	pud = *old_pud;
-	pud_clear(old_pud);
+	pud = pudp_huge_get_and_clear(mm, pmc->old_addr, old_pud);
 
 	VM_BUG_ON(!pud_none(*new_pud));
 

-- 
2.43.0


