Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F1A7606A323
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TH08ns3i
Received: by kanga.kvack.org (Postfix)
	id 33E736B05C6; Mon, 26 Oct 2026 19:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 315886B05C7; Mon, 26 Oct 2026 19:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22C406B05C8; Mon, 26 Oct 2026 19:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B14036B05C6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:21:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 249821208D1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:21:42 +0000 (UTC)
X-FDA: 85366351644.17.02517DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0F4D020003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:21:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TH08ns3i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793056900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iGg0JuKjpWH+18cq1a8i4lvw2ME9xlVqud6fOrE70qM=;
	b=zIqBhnRgt6exp3B2uLElWBmySrQDfuqAdNnA52HT/6o+hNxxF/NS2EBSyg7iSzgMMf9xDJ
	oSLxZjLRfQEno7JOBUMScWbCBpQyz2VqYWpmrZc+FpQ4X5a10/F3rfr5tGtIG1uGPED592
	CLxepUWGUPVjdv+5p12FZGSJ+Qg2Z9g=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TH08ns3i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793056900;
	b=3OeFZDqsRzg/PDOnFXWzLFsuqWSE7igDv+jDK89OELvPMwJmHdSAOWIo7iRU3yhi+8a14+
	Vb4aji85RiOltFZOxsr77Mnu1VJotPZ4h2CiZjI+cJvl/f0Va3prwO2AHaHOlmKsrbAxzq
	io9dunWfFP8Nt7iFCv1KOj/zZlclP0Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 754A843D7A;
	Mon, 26 Oct 2026 23:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EFC1F01828;
	Mon, 26 Oct 2026 23:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793056899;
	bh=iGg0JuKjpWH+18cq1a8i4lvw2ME9xlVqud6fOrE70qM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TH08ns3i1lGdchO8U/Wa8lJXAKl8uG3gfTu/o5/+L3yVW2EfB0dI1Or6Zye9QA6a4
	 U2oWp3nYq/QVlWgsXjjiuQi53fz5EKConQu9zpfjVi9TXa29hl2mf74m+U1pLCDZn3
	 s4wPRw71BXVh+F07l+672CQViwuZKk2bdsz3BMjjdev51nbaBm1TwDRsLwp60t8JVq
	 wJvSw4iz4piKzE/VBEizjsUxU01KDNU1iMyriQmv/8fbbJ8g02GovtVc7Q71gzsSHS
	 5jpDpO/BNAhDhty+di7pwtZZTtDh3hxVt8Iayp5jDmuSU0W73PvSD7mvQoexLzDt9R
	 BDBPl+UA2DcYQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:32 +0100
Subject: [PATCH 12/46] mm/huge_memory: fix livelock on device private folio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-12-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2169; i=david@kernel.org;
 h=from:subject:message-id; bh=frowMj6hVq4GFUzEcG8t6DtzEstvQZjTWtFOOY06Pig=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35/yw1Tu+suA4g9c83rynqWcE3t4ObxXytNbOFrWa
 Z/5GfXHHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExENJyR4WFBRmja09TbMxP0
 /e3s5l/Tj37ard0oueJCcDRHdUbTAUaGc5Purqs/F5llM/P2uayk7CPH7Tb+f/RlVf5DFp6T9Xo
 v2QA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 0F4D020003
X-Stat-Signature: ng4qudaaxtn5c8mz98o9kj1uepn9dark
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793056900-214103
X-HE-Meta: U2FsdGVkX1/T8wRZrrd+EATftB43iNkisHNZMQfeag402dmvJ1TMiZuhvpSSQ8D5YzHIEQAnB9pJgqMQokraz1rBGN2xcn4fOafnNoESMkkjqENyIAdcW624RMFEJAt0z0ZicKk3QZX23I6oqcBsITMkFq6YEtH7bRaQ6Q0xuXhp3iC2hKEBdfU4+GXFoSyfCv3xOxyRafk4ZVije3YbDN5k2TUd8lo5I0NQNcTd5oPFzoR5VkBF/nMy4J7f3VSgX14m0VzvAd0lgJ/m4BUL5WZeyjJTqGsgxySG14W71byMoj9oo2NNRGyf1/2GtLap9Imj5sJa8HMQaNFlJ5d/JzqIGARbsG+Xi4q/NywWVpZe2VpQ1VNjv6D8uSFIKohCbp630nLwEq5xOsrqnyGQ/CJiPqntAzRp1DCTikNnAuF/jOaCM7yVyRcSX0K5+c/qljzFZu1YNrr1W0nXXY5cZSgGeFEKrB+pSG6N7wVhUPTqx5LJGDYb8vfKVYwGUat09NpTJLJRntHOJgXmT0W9DFZObmUpiTtdCe0DuJfDz/tA04LO4RQDO3eA+1ajkB88ELhG9JZ7P/swW5/e0vPfCiyVThBTWdFcvE+ydQbDNpul35e6uYUS+kp0pYax+yPxucjVjNGqZnsXfi8aFz87s3y2lDqsqg8ABpSjzzexTEY0nr0y/ypB6toQkFbcYfzgYR15+vvm8gXPTR4vqQGofSOiiQZBNUZ3yffoRYseHDod5sw7XOJbJefUGM9fAixURxaqNqC0uTKl6cyEifslWoD8PvIzEtqRaqp4kro98j/YS7JMPnOCxoy+eWbj+Fw1VL+HDGkdqeaOcg7ekSq66CSAwHyQt1/mnugYAfkKS9+4XSUNvGR74PVFTmv8hlAF3RRW+YYUbHygyl8csvOSCCinWapt09avDQdY437lZLDfQmKJ+znVuv3DoJjLUtTZW6vTK9FJbo4Hhzn1rnw
 eSN1Ct0s
 vrvCCA8WGmo/nQAypBNR0pZYqpR0MdNFPLSsr9b+8Dw2tnxNu3eCcLJ6O9t1M6NxGPWYrlsbRwDaZCDCwQ9g2Dro4P34L68ppBgnITUQ0zFvrUrRecDhOmBeVym/AnZiCz00hFkqwyM8EDxgFrHIUooBoeTVVaukuEvx3g5MwszYpcI0Kmbewxq+5H789+BiLbAEzekKF6jCJQ5t4d73Gt4UYp+fQynrxNgo4uIVUSJascivPUQETblJgWONtvbhMn/xfDWmGHbHHjL2SinKUKxnLQ3m+HTTd0GtMTp6PBf/++zWbC+ilkQFmO/vVlBgn8PVt2R1hglc09Y2K0CongiPcjYStwNa0+xmdmcw3jht3Pmlep83WrZTtg1SBbZWgSaTx5MOVwuTaNjY285QGwh132iGn4ztc4ApxPrLdTuyS6h8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

If do_huge_pmd_device_private() cannot lock the folio, it simply returns
to try again on the next fault.

Just like we did in commit b570f37a2ce4 ("mm: Fix a hmm_range_fault()
livelock / starvation problem"), let's wait for the softleaf entry,
which will drop the PTL and wait until the folio was unlocked. This is
precisely what we do in do_swap_page() with device-private folios. This
avoids possibly livelocking.

Update softleaf_entry_wait_on_locked() documentation to clarify that
device-private entries wait until the folio is unlocked.

There seems to be no compelling reason to backport this to stable
kernels unless we actually see problems there.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 4964099163d0 ("mm/memory/fault: add THP fault handling for zone device private pages")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: simplify patch description, fixup softleaf_entry_wait_on_locked description]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/filemap.c     | 4 ++--
 mm/huge_memory.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b04be64a5069f..e85a4114d2ecc 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1395,8 +1395,8 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 
 #ifdef CONFIG_MIGRATION
 /**
- * softleaf_entry_wait_on_locked - Wait for a migration entry or
- * device_private entry to be removed.
+ * softleaf_entry_wait_on_locked - Wait for a migration entry to be removed
+ * or a device-private folio in a device-private entry to get unlocked.
  * @entry: migration or device_private swap entry.
  * @ptl: already locked ptl. This function will drop the lock.
  *
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 283c4bc8b927c..2b31a425c7a32 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1500,7 +1500,7 @@ vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
 		folio_unlock(folio);
 		folio_put(folio);
 	} else {
-		spin_unlock(ptl);
+		softleaf_entry_wait_on_locked(entry, ptl);
 	}
 
 	return ret;

-- 
2.43.0


