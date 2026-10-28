Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 415E960A2633
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 12:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HGFXhUzd
Received: by kanga.kvack.org (Postfix)
	id 68E126B05B0; Wed, 28 Oct 2026 08:11:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F716B05B1; Wed, 28 Oct 2026 08:11:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 556616B05B2; Wed, 28 Oct 2026 08:11:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3923D6B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:11:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE3CEA80D8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:11:44 +0000 (UTC)
X-FDA: 85371920928.27.03DBDB2
Received: from mta0.migadu.com (out-109.mta0.migadu.com [91.218.175.109])
	by imf17.hostedemail.com (Postfix) with ESMTP id CD8584000A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:11:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HGFXhUzd;
	spf=pass (imf17.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.109 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793189503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1n8Nl6PcS9qe7BAYox6Jdh47tIB1fu4WdM8a6GV3D+Y=;
	b=5QJRZvoAaAa5/jnUKehXadccALpBiQXa3ZZNpGZdaX6fLVCyCJ1dX1z77XCPg6jRPZKOb4
	/nktUHpQfiRnIsCn6rR558vRVljmxq/C9qgICG+QgykLtubWb64wnf1s9GTY2+hLzC9PIq
	MvHhLPqrYGNDzSLY6WVQiH9dnVx1M9w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HGFXhUzd;
	spf=pass (imf17.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.109 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793189503;
	b=H67cMMYGscVz1SjXoc+jRPSmpgDzfr2ivHqb3P8RMFPyR6oXhhQy1/3TDK2NwjVoKv6HJJ
	WbD+qZdTRdVvaW2uTJmO7uLqsU4AHshpdWsrfhNkEcRpmM0hVvcdc11KGfz5rufPYO9e0y
	li5SRnxNDqsjHgFQUI/fBiyjdGH4kec=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VBww6JyZdZNMzXtg5bsJzwRztMR9lQ4fQNuST7CnsK4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793189501; v=1; x=1793794301;
 b=HGFXhUzdmdQulfBCY2M2K+fSCl7Wnx+XIZdGsFytpCZX3JvXb9tx4nd0BlqEmMAjS6Lttajl
 81P0zB7AiHR0GCpkrhnuNhEE+SSi/UQymzub62sZG/ALEWD1tv2/wFNbInbQaOGc+xAYq8blECC
 sj7VwGd3k7QYnVkaeK5QiQuE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e40994bb9d03e662;
	Wed, 28 Oct 2026 12:11:41 +0000
X-Mizu-Trace-ID: e40994bb9d03e662
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH] mm/sparse: simplify the vmemmap alignment check
Date: Wed, 28 Oct 2026 20:11:29 +0800
Message-ID: <20261028121129.39916-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CD8584000A
X-Stat-Signature: hubpyw9dfmsemz1hsx3bmhzeizrxa7zu
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793189502-906964
X-HE-Meta: U2FsdGVkX19yX/w0EvCU1YUqM3NmIFsxFq1+YBk6oau7BVnkkyuf1Qzix+GzQw4RE6ARB4EhkUde8cSUXbztfQiAOSgzlb3O2xzAQpsxpAU7GeAQK84NCBJFCOu+A1QuGIfTWFP0k9QOg/VVHVlffw2QjHJsxMJx1QimF6fHZZVq17YMTHPslzG3M2/kvdJ910Jyid63lSNprHrWnLFU6mWI4MUy4UJjqAWOciiA1dva+iNFR4Ipw+V5i+Q70M0i8LFwYL5rhLDERBQaCGG2GEC4ZZVTqSrNtbIiRhVThO06jEeL1LXQ2Zq6MDie+LmYqM+g3sjNEIsjHNgY0+y1SneRXTqv6ny/3WGy6Oq9fTc1zJadsx2Se2nrP52wFwAMoaAZQJM6wKcqBrcHcf06vPfU68jjbE2lQVqV+nIm9cct0RgyAZGzQcXzlzY3prvFAK7bVR8wgoDX5ReDZc6R4sJl3YoT0//f0kkNjTnjmPMpPVbBMWaiTMdDjbPKzd9LHfoqWBgCZlSCPuZxHG7OXO0xcnI9y4eN/B/lmhH7YJgflGpNJySeBzjEDQy2sHT7txaGw5A8FlCTpfLg/fA6AMz9MMXpQMEE6stDa5vZefEGXmTyYAMoTESpRNAnQm8CnF41/TC2M0g+k5FpNdsG9tTTD2QPXiD+91d21kQLlK1IlJ0SFU7U8XBVNC3GQM/qHCo4Ur3Qm0Uv4tInYhXKSMo/GjOcKGrLSpz2KarDLr+0lNU8xq3nB+mi0RqwE4/TST8vfkqbqqPd1H0dVlQoVJwESI5ZiCK3FTHw0B4f+lztynIVuUhYSamV0X5nE9Svvy9RBYRlTJocvK/zJFAqjhcGNxB8h1Bf/ylmu8fhnFYNh/nFI4ehr3laIOvdUpQz24tYARlT2NvrQB4nitkFk2yS0Y0QZeMx1wKPDptaui9xWZf10wHKLo8RnhHSFE8k4zzxWwe94BLl8WzK3IT
 Ku1lbWrr
 anlLaOBUt67zsR8+OYIOPx3GyOAvPwpMVEm6zzdRIQx9lV/waQ4rwwtYdl+IczfmVHwnqY8zvWUB3vOYiskxxpulUiRxrppg+y29VN43fAf5s01n2eib72/mF/WoDoIhDAjmXOfoHE5yqylyvJbiDI2M/MPQR3QucGzbPerbhTLUmPmOwrnXEXTx8wMMxF3lq95pYDOiPz/KNKaQFK1Ch6LbRom0Sgd4Wj2HS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kaitao Cheng <chengkaitao@kylinos.cn>

sparse_init() is called only once during boot, and the vmemmap alignment
check is outside any loop, so VM_WARN_ON_ONCE() provides no benefit over
VM_WARN_ON() here.

Use VM_WARN_ON() and fold compound_info_has_mask() into its condition,
preserving short-circuit evaluation.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/sparse.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 6acb628c8a73..248bee2d39b9 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -277,10 +277,8 @@ static void __init sparse_metadata_init(void)
  */
 void __init sparse_init(void)
 {
-	if (compound_info_has_mask()) {
-		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
-				    MAX_FOLIO_VMEMMAP_ALIGN));
-	}
+	VM_WARN_ON(compound_info_has_mask() && !IS_ALIGNED(
+		   (unsigned long)pfn_to_page(0), MAX_FOLIO_VMEMMAP_ALIGN));
 
 	sparse_metadata_init();
 	sparse_init_subsection_map();
-- 
2.53.0


