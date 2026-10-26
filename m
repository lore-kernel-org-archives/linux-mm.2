Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9A2D606A322
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A/EO6/mr
Received: by kanga.kvack.org (Postfix)
	id A92566B05C8; Mon, 26 Oct 2026 19:22:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69BD6B05C9; Mon, 26 Oct 2026 19:22:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959B96B05CA; Mon, 26 Oct 2026 19:22:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B3706B05C8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:22:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 32A40408EA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:22:20 +0000 (UTC)
X-FDA: 85366353240.28.8E05A1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6451440007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:22:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/EO6/mr";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793056938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ord/cNP4CRsRT4Xvi9c7rgpbK1vGRFp0LVhUmuKhqjI=;
	b=g9n2Kyopv4H7N24aZ78sHcKZsHREMgLbVc5eV2Z9yaRJTN/Slbk5CAUKYSaE8HEcoa+h8p
	+Pg/tayOxWwmiHxtON/P8PBidFEWC9im57gVkxO1hoE+OCJSdt43HmAN/upyADPAXpkrqq
	dleawM7GsdUhZnBoYAX+Ld5wp+gLJ9U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/EO6/mr";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793056938;
	b=PNrVd7cpiJcKh7hSYOMRd8HnMdZ/9+aNq3pDnEPpOY9wYr0a6cz91bBx91LJdJGARopeeW
	YggDrfa0SFzG+BaBsrFFhjpvFVXplMxeuCWWaTzy0u7uwNc3NXyT/48u9InfgOef4JVFXw
	xJJadL+1jf68IK8ozTOARd/mSckKV28=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A3F0541460;
	Mon, 26 Oct 2026 23:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B94E1F01825;
	Mon, 26 Oct 2026 23:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793056937;
	bh=ord/cNP4CRsRT4Xvi9c7rgpbK1vGRFp0LVhUmuKhqjI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=A/EO6/mrzkD/mg3LADo0kMno6NcudvbnDZM8+tP9DZDoU8h9co0wU4clyW6YZLGFl
	 ez77QV1LIY6IfUQBxzaqwM2+Y8X4xFpLbUPyaBW70KMfkz7RLbSPEpjilPcUHcVlaz
	 Nc9VIAX3oxSv0TtODqmK33x8Gw+Djny92ATTXKcaqlSN630jZjUPuTr//5PNs6+tUj
	 Bv42ssVm1ha1+CGtMl3ZCTjR1Vr36giZAnOD4Sa1XOnawJ5sMZ9PD0aJQeKTO0fxuS
	 lWZTZeTL6k/4c+Sx5wtd160zyY8s+XW3ZtFGyroIsKFMK3n51Km+Sv+lIi+J0jrgRR
	 77f61FFUxGTOQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:34 +0100
Subject: [PATCH 14/46] mm/huge_memory: fix zapping migration entries for
 device-private THPs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-14-6f74bec9a5bb@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1559; i=david@kernel.org;
 h=from:subject:message-id; bh=0T8y59LcTWa+97MvrqvLjbP/3maGmTKua0tBD9F4/0I=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35+ia/cvPpk1zX/O+d5dB20O/XTZps6+dGX6/C/Wn
 32/e/6/1FHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEdq5m+J++r4l1Vdemiaxr
 97IsOrB126Hm5Fs1z7zO++7NmFr9v2YlI8MSV+slVydHMX/KX/44/mLh7Gc8sTxTlc/N5lTMr6r
 ZxMMDAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6451440007
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: xczmg5r6ks39sgua54u6tt5yr9gw97yn
X-HE-Tag: 1793056938-751442
X-HE-Meta: U2FsdGVkX19jSSozUEkiKLfwoq/UKPD43aJGB/X0JCs3WwwVO1BkyAUWsdVGtNXru8LYGLLeDiABI0tuCT7Zuh9ElRjmOLZOMQJ7BiTUcu+9IV76sXRqih1O8gTpgPpH5RkNU+R5kglSii5V/Q3foS/c2ovRAeu41sipOM6x8G2CnEfacjkArwUficAUM/RT+n5AsKaQOkohr6jeZknECNi8ldJfKj7stZr1ED74F9mgY+fWnbfCsITlLEs581zdzgFL6LWxsqKwrNE3Oce6jN6NkCF9vnjnskHSm4Ic3vSFuVomas35lkAWnQ5HAmarDqDhOTLxYYtN8SugpdLRAIx84jyGXPHJ2xIlh3mhqwIYeZdkuTH+6Qp0wX/pN33xa0v8sgY861Iu9h+cPorqyTEIl5MB0wOhMdbkQuY4Ef8lum7HsR+zs1OuaQ3j+NDSiDFRf+TY07dR4lFCBEoe0iHMQugy43in9TCZoDy7d9Arr0Y45p36+p7qI5DRRY/Hq0jMskrRO2bBw3lMadPtZeRX4a9r4lCbH7imMlrCdY1Y/ypUaJvaL9tYJJctvn7sEFm1uBpUUtWBXKAAiN8iiuA/GctnxIBkH9sGuioVsvYl4pONgWUzRHGEhmsX5QLn4UUqoGE8s+3a06/OTNr5z/dmsu41P30Bm+ls7aGx36plXTX7NNf+CmlgPV3ZySHyJved6SH1eDe2uY9LPOQ6fp6SMLqNSZs4ptLT4BLMReune5p4F0EnV32xS+AWv8HkWFLN2VCBaKtPd9lWbPzaVBd7d97ihMfr6QBSbdfe4fiQu9OvDsvPNmjFcYXO9nDVTyvMegiNgUpPeTnN9nTVrWh64MKSiX0NN5wHctQfbz4d9MYLlhJxHh+d0fIImbqHJn2pzImxQVUTTifeC6KlN5fXYiSAt4mzDK1pVNRk2YzqBcuYOEc8oCELAHIYstapDIgm1m831mTmeE+/r1l
 rrL/GkLf
 WD4dmE3SmeAj1ImTgsDqvZQi/CTHpuUh9mpocKQdG0sWe6RbkaR5U8+tC3YJMFhQyfBn6ckWkCF0unHd4hO+uwLflL9Oy+j7ujnHdvmjRtzaf5D9NDcZv4uU79g6i/VLqEb2zYR+mniFrnCr43orWMBFj8EQzGJj5hmMgu4mHgvksPJdSQuKncGcmRf1GNWjmM3ORoBMAK/mgs7CaVSm2Pf44yQ7I6k4mT1Jfk4GRsuSn7TfZA/zbkZi94TbhT6ab7BZcLsgLyBHr4SWh2DdKa5syg/OYaZpvdWP+zjmja6cbNDQUzMTzuFgjJ8GANvOHfkcLLgYseg0SjMzZQCOmLkvHLpfeQO6KUuWNFfERmAMeXfvOorywPFsqiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

A PMD migration entry can refer to a device-private folio.
zap_huge_pmd_folio() checks the folio type instead of the entry type,
so it treats such a migration entry as a device-private entry.

Installing the migration entry already removed the reverse mapping and
dropped the mapping reference. Zapping it must not repeat those
operations. Concurrent MADV_DONTNEED during migration back to system
memory can trigger this.

Check the PMD entry type using pmd_is_device_private_entry().

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: simplify description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index eda020dd6e33f..1b50cc2b35351 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2493,7 +2493,7 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 		pmd_t pmdval, struct folio *folio, bool is_present)
 {
-	const bool is_device_private = folio_is_device_private(folio);
+	const bool is_device_private = !is_present && pmd_is_device_private_entry(pmdval);
 
 	/* Transfer young+dirty while the folio is still mapped. */
 	if (is_present && !folio_test_anon(folio)) {

-- 
2.43.0


