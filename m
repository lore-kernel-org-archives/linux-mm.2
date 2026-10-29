Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 475F4606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iUNGuoc0
Received: by kanga.kvack.org (Postfix)
	id 4E3466B05D9; Thu, 29 Oct 2026 16:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BA4A6B05DA; Thu, 29 Oct 2026 16:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D0A56B05DB; Thu, 29 Oct 2026 16:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15EBB6B05D9
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:40:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9767A140506
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:40:11 +0000 (UTC)
X-FDA: 85376831022.17.05D408B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C274840004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:40:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iUNGuoc0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FUMlocCCR3FNPkXe9l59Im2VqUBDzK2bwkLLReRcpPc=;
	b=XAr6SGbjHQe6aIXLEoCK/KCRp6X3nQgAfCeoRhtrlG7hrq/V6YBJZdShoydXv7dRlqS/em
	synR7F2PMuVE/9/IosVH7of+KyDM+nC8VYPxDQ/wQzwxzUAnkxsDz0Muiar38Fof5T/Vgo
	7JYDPRYaT8bvUI0SuTOIN5ImrZj/mjc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iUNGuoc0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306409;
	b=QzIN2sWCCFwyvfyGD6PZfHHpEOsBhmQZsm3Kb0YsDGHKa8LJU5RezCvdBPPU71YU6PBVJi
	a9cNSjjDQ4Q2FFgDTIqzEvZUDcWFZxNUlz7pwOp/ZYC89qkX22rodnGv3KyQWJ7OAra2t4
	khOpVflbexWuTiG01AZdC4k0hevuG6Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E8436061B;
	Thu, 29 Oct 2026 20:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01EC1F01825;
	Thu, 29 Oct 2026 20:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306409;
	bh=FUMlocCCR3FNPkXe9l59Im2VqUBDzK2bwkLLReRcpPc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iUNGuoc0WeakiHgmDXnhuPlSghajcP6iyTr2aD2FuFZ51pYroFUry3bk8JUaMuEA3
	 XXcNDCVFvoALkSqrqd4c4ihHA2LGsPX/upOgvPJuWvhrp+8/2zaa0PLUJuKsN/8plW
	 9iGLRa5wuxHYdpBgli4Hpi+HHP6EIxJmTlApX431kJFtoeZ0B1B1M0Zp4gzk9TElJz
	 VP0ojaFjbHD+kB+2kggTzsPRUHMqSoFzPO0brdXePjOTplmQj3LV3C4wd16dRHjz6d
	 LfhgkMqYVhJp4fw1eMSl1gAQOa6lfEyik4W4IucHpl8YgrOAayJWXboJOwGq83GAdS
	 y6H9j/Ymf33KA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:22 +0100
Subject: [PATCH v2 27/47] mm/mmu_gather: fix flushing ranges with 4 GiB or
 larger
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-27-a64ce7f83abb@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2091; i=david@kernel.org;
 h=from:subject:message-id; bh=QH73tRoFq91DTzVscInadBQ8PK5Px8G2ighCsSz8YrU=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer23f+WLDDxbu6impZza76Sw7pvh0S2eDTcz8nSb2D
 zL3qncc6ChlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAizaYM/905uFk2VqfFhrmz
 XVlbZVP9L0C+ZDrvTsdXQa7Hvk8vSmL4p10dqrF9woXJN66x3TSeKXedRyrsAptEvgMXa+HZI8n
 PuAE=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: C274840004
X-Stat-Signature: 4fct1bco4ue8kaoq8jwf8xr1wk6x9cji
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793306409-577772
X-HE-Meta: U2FsdGVkX18ZR9qrkLWTF7hFeHnq6K029Qa8k6FgeKmeXGrvL7JE2OJYBXeclrtBTO8KPE9DeLDIWnd29hNcT5omxtXhLW/yE3i45k9pQ3BSCB/Pps+RETNbLNvgT/Z1/PfjlCk8L6Y31ztdUA9IeuXnwpjI4OYzVNkKAM8Dex/lqW2JwWaCuhg5L9VcNs0Mwwt7/GH/gabngkPW1Koej1tUXDLwhoyWrqd6mFlUcnZ02R2sWT4vDoRW6Cu/x3pTBE1vMr9Ecvd8V38tmbfsGCeS4Fs+DHrPwYZfbsBN/cDIUs7DZ+vfkQY0DvNeI8+jTLOwtLlIvlZMLL3GGq7y7hO1qsBAfHdNMk5HShc91U16pInFGMJhkqmbImGMRIwQEZhF7qt8hV3Fq1PT47DtvxXNToqxvjEFcTizHrFRyDKSJYSxrSrK13VveoJDFYxaT15cztkmf7rViyTSOzJEzlT9DAK42neLNqdZpe4sc3tTPyM5kWpgsjV5+ecpy1TFZfJO8KShGOsrHJen2MmB/mpxxB8NiTsDXxnvvEMrXv6b7oT6PmM8pk6eT4AGR9b7UqWMBUUwJdBXu4ILBjrvIievH1VQYEW1ZkUPn2g+wFufKEQWFEKaDrUlI7hpTTzRzUtWDVz/rVQeW2Vj8NMjLCro2tTnqIX3bWmO04aoi7LsZyj/NaSR2YhMtahv+9bJR4IxH8QVbk72a0lbWC1JE+Qqkl2mtMdQVhBOXuAcaA5Ul3+/M0jS0icWAdtmamiNr3V6jPlV4tLRfduDBHJWYGV29fLDDDURDLGffLdm5Acxva8d7FzsvXYaEzIApz2dCECeS3m0DH5QiNmthAiAdDTzKoBt4uzTNHQ4wV0GSk8N3G26rQZ5SqRJSeTwSIG+blqlCOjKBK8BS58cJSjEhYkksf7pO+Z+2svh3orr+67gOZdnEg2LlWtLBPLh+T5eJlqHEvPMi1Ys72GoYYH
 PEVog5i9
 OXMnIiIdxe5UBajaZFJik3lIyIP1Tb47jrobZxXw+wsP8LSU82T/mTnknzrbOZX3gJGo6nTBvnT9tDSgL1Siu6Yfu8AMaHqYfjp+I0zUTKix3JaFgCu8B4geGgR+T+gs28Dz7x/ZujnKd9mUzXsekqfnQ27MODE57IQT9AWolyj0mAe/Algw0pxqbR85n3o398FgHUnyL0zEivpS5upEBcwFHx4rvWgZh2UDgUI6KnTXhZbLHn+VsnwSrKqseCKYw9gfc1YHXMaDRc68UyvN38os8AAmK1AmQyFhAf30+GmovW2PdKFE1Rz3x4YYjwYUTFlG0MBFgJWI122eugMYg85P+txqvZP1AB1/+idmdlmRYvuM4TvtEAlASo35p7WNsX6rfp9zOzbUAN+TZz6HDiJfsj7vQM9tD1sTOxhfTRoy9ETVYDUnIU/+9iR/nbQGbLqA0kQMXO8GzE8MvUGiusd19+8Dnr1lshkQbyzTcfTMkzAgA3AFc69vh0BxUNWf0IvxL7oHC2pi/4Rt9oSPCMSF6yT1dGjSyYhxsXMjMa7DyqbI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

__tlb_adjust_range() takes the size of the range which has to be flushed
as an unsigned int. Its callers, tlb_flush_{pte,pmd,pud,p4d}_range(), get
and pass an unsigned long. Consequently, a range that is 4 GiB or larger
gets truncated, possibly to 0.

On arm64 with hugetlb, a 64k kernel can have 16 GiB hugetlb folios
mapped contiguously at the PMD level and flush them when unmapping, and a
16k kernel can flush 64 GiB PUDs through tlb_unshare_pmd_ptdesc(). So
at least these two scenarios are affected.

Fix it by flushing the proper range instead of the truncated one by
properly using "unsigned long" for range_size.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: b528e4b6405b ("mm/hugetlb: add tlb_remove_hugetlb_entry for handling hugetlb pages")
Fixes: 8ce720d5bd91 ("mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
[ david: use two-tab indent, simplify description ]
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/asm-generic/tlb.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index fbe1114e9a44..3f4a180b48f3 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -350,8 +350,7 @@ struct mmu_gather {
 void tlb_flush_mmu(struct mmu_gather *tlb);
 
 static inline void __tlb_adjust_range(struct mmu_gather *tlb,
-				      unsigned long address,
-				      unsigned int range_size)
+		unsigned long address, unsigned long range_size)
 {
 	tlb->start = min(tlb->start, address);
 	tlb->end = max(tlb->end, address + range_size);

-- 
2.43.0


