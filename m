Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CDFA606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PJUUy5Wj
Received: by kanga.kvack.org (Postfix)
	id 4B17D6B05B2; Fri, 30 Oct 2026 17:35:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 489516B05B3; Fri, 30 Oct 2026 17:35:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378336B05B4; Fri, 30 Oct 2026 17:35:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1319A6B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:35:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ECD22A85A4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:35:07 +0000 (UTC)
X-FDA: 85380598254.14.50C209B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 43684100005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:35:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJUUy5Wj;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793396106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1+5veRcUECUHly0A5XA/CEflolz9T2ehe39P3T8hUGg=;
	b=gZ/qbNC3ZS5jPJYiQbH9kH1INKfzA78VmCzf1qTq1lDOyrY6Npp0pVwJUbg3eD9zQBlxpL
	Dafs47voKXQUje/xO+kUbnRSOh5wkvO4NOejJoPQR/Uvq2ApZaaOU0bMKazAYcnyglSesv
	U2WkYDDXSPjMfGlM1Jjdcz3fuzBMX7M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJUUy5Wj;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793396106;
	b=5BjOO+5AgA2ZgmTYzLBtTfbydshLyU2u6+qEw9GMkZjUl2Nqm3jZDbIT2simCTcFauEB0k
	JVLL1fkc9kMpVFAp6F6tYI4zfbqk2/X1ZqW9rBs7DKJz4DGNOTIVqGhqjx2h47efWSZwsN
	Z1BXZVWWpzu1uMIL7Bm9LRmOPBlIx+s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD2546062E;
	Fri, 30 Oct 2026 21:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C271F00A17;
	Fri, 30 Oct 2026 21:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793396105;
	bh=1+5veRcUECUHly0A5XA/CEflolz9T2ehe39P3T8hUGg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PJUUy5WjqOFEOxxPslcS9cq4MRpfXs039oRUc7R6QiTbVXF82widIkdQ8Pp4EF62s
	 3fDDxpyXa4VvrI5WI1oZcH3kM0gxdCtz1/nzGt64w3YVK/DcZn4ePMllnHx5uA7UZD
	 fVWkW/Pa8lpw8MUnexfi3Lw50bZlecr54soRm4itbXSJPISr/dPv7efWoyWemgNwVu
	 Qyjd1gzv62LrwQoud9q/diiIdAn8Nygg/Yal9ASP/pHLt3SDon0LS1frQBDdE1Ckl9
	 uS33/S4QNRkZHcM4Ml6EXoCkQJbTyf729p4IX+pbI7Idfmf7vblYdIsMIilaeu7Vg9
	 5dNUfZMBkDCEQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 30 Oct 2026 22:34:25 +0100
Subject: [PATCH 1/7] MAINTAINERS: mention for-next branch in MEMORY
 MANAGEMENT - MEMORY MAP
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-maintainers-v1-1-97278f8a5f54@kernel.org>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
In-Reply-To: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
To: Alistair Popple <apopple@nvidia.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Byungchul Park <byungchul@sk.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>, 
 David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
 Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
 Nick Piggin <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>, 
 Peter Xu <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
 Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=987; i=david@kernel.org;
 h=from:subject:message-id; bh=7LhecTsls3AZLNquyQvMAAtG4l+9TG1hurjRyz/UVtU=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKe8ub+msSa2L//3hX1pffWrdjklXMk1MiGd+tJyaXWV
 d5ldkU9HaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzEqZbhr/yM3p1tOh/jhVfG
 9u3q/LiNq3HPsZfmnpbZMg/1uA54uTH8Zouca3uz/EPdvIWb54h08/Cp/sydcORc3DOBUMsOQY0
 yLgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 43684100005
X-Stat-Signature: xbi4bwjrys8eek1j9jf1re8rr7qhdow5
X-Rspam-User: 
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793396106-484247
X-HE-Meta: U2FsdGVkX1/v71ANnN4m1C6UvXrtSNJ3i6Kch9rBtbFSgmI4LCpT+8v3SxLZ0vUT+K7nu1hQltlbZh901LiidDw5/WWRS2ugpdoJoK9LOAXOzXQJql5vAAt71hHARqfXPTz0oZZKcoIi0rskL1E+jLaCHOFXA26bRdfvuViNKdCxjlNmf80EmZ2La7BdDgWlCksCU492Ox9kHsehtsW4zzAYevLIKV81oTbygCf77hmPLK++FZEzM/0jVMrEEqc04zXto81IF0Al4vIpzAsGceZuf4WD6m+LoOaOMFsFjY/EBqg9322gfQ1gGDSgOVpHAubjUIhZCVGrg/qCZrztur9PzyieQHI5P100HNz3BPdJ+fLvmtSYFHLBLw2O6HcjSV5HceakfHGS+2y+TonF6zE77uC1g2Pxk1oYc70ztxMV1ty75FDyIyqoht+WEJC2OQbquTCAGWE+G9FMq7udVo3Z2D1QQZq5vhidaukZqBjgc0v29X3ZY1WctOkSmbiHVKHewNiquUoJXyvVez7DlqxBdj/NN7NMV0y1CGwjW4vin7qTJJzWK2BZjBWKRpHeIXPOjSlt0ZNRbz5sT58YFbyJjL4rsWDHSmKF9hN00JQcswSSxUmdcBCzYXqhVck2bCWW+75VB7GbDab/0J0lEEskYlYJIJP35/5+XZpK3Qh7m1clgoSd+aulQePbsw7tPOMRK3JZTSf86iVrxyB9N085ehU/0M80opTQmVHN4fkUVLMLjIq1xwrFUkte7/XicJEb0KUeBZfMXYxXJNU80RESqKMzcHXIcQoW2mUcvo5Sh/UfPTW7FXxn3xJ93B8++I9p8gtmmpYnv071zP/1dvXBBRncwqJk+BFN/rZsa4kEG++oiQ1Q2kZkwSBfSVzTmjScvDBJ4Qc069B09YSOLAhPMUlptjlGorZZjwjY9icEzT+bhkyDdyW5l8+I02t6w3lJ6F5uNDp0QIaHcCn
 Qobqr32q
 ToVuPw8t1LCd5bRgb96KT2o3a1xu0BHgNejJO3D+u+PiO/NWmhzCiIVISC60kXX/+25wdYkqSf6gaa+DB74EYGIwEd0mEWHmY0KAwl+kanuMpIVUuqrKVjj6Qi9FPpP1iMP8MUevZ15Hh/Xhkeap9/MA6/r7hJOMVidufv/M+gHc5RNRs7qr+ba51sgA3KbAFPHlQa7un3/wgs92hNzCM17tY2UMI/T9EtbvwzswHZXumL+jFLnhSxR2H4vgFfBi1ba9s0v2+NXuFPmmJTTpt1/3yFFmkQvmXkwm3Z1iimoY2LMv0vKNvjw1wTTL/WKO4WZdJyStiMNak7ruizpZtGyqFsbNIve+XS7phdKzNl9/TNXgayend+if6DP29n0hJ78Ep
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"memmap" will be used as a prefix for branches, but not as a branch
itself. "for-next" is the integration for all these things against which
people should ideally send patches.

Not mentioning a branch makes them assume "master", which is wrong.

So just mention the right thing, which is "for-next"

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7a162e9bcab10..dbb5582ec1c74 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17566,7 +17566,7 @@ M:	Mike Rapoport <rppt@kernel.org>
 M:	David Hildenbrand <david@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git memmap
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/mm/memory-model.rst
 F:	arch/*/include/asm/sparsemem.h
 F:	include/asm-generic/memory_model.h

-- 
2.43.0


