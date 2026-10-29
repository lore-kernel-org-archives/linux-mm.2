Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9420E60A2639
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PbsN8DUM
Received: by kanga.kvack.org (Postfix)
	id A0BC66B05C4; Thu, 29 Oct 2026 16:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BBC16B05C5; Thu, 29 Oct 2026 16:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AB086B05C6; Thu, 29 Oct 2026 16:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7FC6B05C4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:36:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BDCC9140511
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:36:29 +0000 (UTC)
X-FDA: 85376821698.03.BFBC308
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0048B1A0007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:36:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PbsN8DUM;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qltIiuXU+zlhML5RIS5IOe+lQ29Yj3eoAi87jDTJsc4=;
	b=CCDQmOzy7drL5w3/scLr+5y8iHuq1YF3Wx6IMmVhlEsBPyyQohxX9Pg8Em/uyNpkdgjXRi
	LROW8NoGK5xL8O7aBm61bXMzDcfKN38nHyrnY/dJNkubrYIuJoVjlVtM0ax5876G3xoHNW
	GEnnj3UXMbAB24MvEPvFos2vmtHQWvk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306188;
	b=Y6uI525kYs6gFDwYcId2LPp1I/y7kfez7fNLJyGh5siHHhlH+ZetJMmSPKIAkrAXfH0Th/
	CYStW1Xc56y5AEgEVxuHoxX7JA3jWyZ4ZHLfOl/miRy1K2Qg9syEii3LyYqKFjfQeaFhWk
	psTJ/a5VkLCwFjsy81yj76ml/411HWg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PbsN8DUM;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 75E3F6020F;
	Thu, 29 Oct 2026 20:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1151F01825;
	Thu, 29 Oct 2026 20:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306187;
	bh=qltIiuXU+zlhML5RIS5IOe+lQ29Yj3eoAi87jDTJsc4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PbsN8DUMZHet0eiaz/YtPnbseBFjT1WXluzzZmPAiGCnwOVZOmGfKM9mh4Hhr8RQL
	 7YWdZwjM5Y5r6JqhpSIgRiraov8JyP5s3tVFCEdzVv5TXOjLSA1th27MnlnYUVgFgL
	 sTC1CQ2rinSRaPVNA6+7XHDreBot/Mj62PBOaQUurFuFoTySKorBt6xAL5tvLLjPn7
	 mhhTElRxbidvb5VwGdMn4KiqZOXsOdHbTTmCNjbgcCnwq18newaSnJDP+nYR6R1cS6
	 RKvmRadHrc65MZtqR3trGpVjQPff933JBn/tkhEaQ/OjVCubDuvzFbz+wtW8t1s41u
	 n6zXIzSEWRF7w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:07 +0100
Subject: [PATCH v2 12/47] mm/huge_memory: fix livelock on device private
 folio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-12-a64ce7f83abb@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2251; i=david@kernel.org;
 h=from:subject:message-id; bh=tTSXVaSqYcMlwqAolP5RSmpCZsM2rRJpm1YXsCV5Hb0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer20905Lzv2PqpDmTOl4ztoqsFfh5lK3YtmudyjV+x
 SV2qq+mdJSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjARzo0M/+y3cLez3TOs/a+7
 1kfwzeSVL85PeZSotXbB1S1i9enXP1UzMhw/XBApxjFnktgLNZlCZa/Fr75NZQu/Grl5xyH1p24
 +e1gA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0048B1A0007
X-Stat-Signature: stmajh84gz7eu7yd8q8aa9pmpwozkb15
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793306187-880670
X-HE-Meta: U2FsdGVkX1+Z7visJZg/O0E81vS5LKUMoEnow/nMZ81iv58tNPU5F03mttI9xXRAawYyeInmKm/EOwvDpgLMRtv+irhBP94P7HElwdqBJ1sfbyp9zklogrjiUPpMmnw+4V6lwscNEZJrBTfotbLjnvYcd7Tz9d2qfo5QepyBb2Kc+7mHaBFQImMORyKYCm++GlK96bnuf5rHnLqO9gdy4+5p1j/V6zbL1Ysp5CHkolO/cNu2x3Z1kZUvPHASlMABeUY+7YSJ+Cvk+G/sviqCnZ8muAnJqUgAfNRQLC+eXN6akVp/gevdzWzTXupaxIQTY7rTHyozlFUA/pl1xB7nHOftApKVgQRNbU2Ast6i9Vf5ML7/56cfEGwwsRFk0XgGdxbzjviiEpGwWHbdSGvqV5rNF3cvtJdbV7YVcNfvqxxfOVkAoX/IOUgiC3aLag+z/H/wo7VvjJnb6PH+TGTfgEMeOKjfqUUxUu1/i422faD+ZBTBjEwn8cvFPCQZGndynMVrjR/gs6NinhtI+P/ZKhFBw1v38nqZTb0UjgotplRrFF745FsFPezh+U4u7JaWYlngzCCNp+Dbs4lcGcOLlkip1aIgxxSNuQIAPRspzoUg3HMiz7zHg15AO5uYVRxEjnRJyT7JNuKGEAkU5KBvmL0F1zCVfmjI43uEFdLMQufPPVJg2OKtOWAQwcF/kkvYL890IQpxQ0JqfW46fbiKuvbOJFbbiYd5dFcaEHkMEWBYLijEGJqEJYekJ6Yi+jQoBwtRQabVQUYlMGl9UY/EHbSgQyB+JFrbxUiWUsp8jqepFU27hewYk98PgAoXgT6jd8xW7xtoicanyfXzVNyd1rXgi8D817QfJ3UNBnjX1GFgzKOMe1bp/9OFc4ew9hfWbKjSVbyoDQ0ED5tVNDEoacazZ/HGrdCaa/jRq2YlpBd6w5aDppDfsZJuIMqBFrR3NcVBNTHbH6hj7MU9KEr
 fSjFzL8p
 lB7tEe/tpraztKeT0KlkGvwvjx1fBaHO0Etktqa30urCkdoVm3YpYzMoKanjKWg9iyknkpUOS2D2Y+C47qKSesNafrfnRqGCV0WLVIIYzCw8kTc280ml+Zsxd+n2otfK/6v6yc3RPiVj7PR593zn+1YzdPoVd21CkMFf0G+l+wgcbgO8fGiMoJ/sx3ER47oZT2svAFds3acUNY96QQ/GDP1zwgbqq//zS2eHtaYpjxjxv/aFqr/5xUqUufNyWeut9jkdYiJrPKe6coDHnjA4OyqOmVXT5x+mz3QittH8qVRWOvTqtZHO3u0Ze0rg8QoWGAB4K0uSwkT4Wai+5WrZbhesLXSSzGT6sYzVBIFicr7JGnsFrTCnUINEbmwvuvMtTypJX08SmZjRpBtHgw2OqslUTB78lUzqZln7AE416S/irtCmgmV1Z8k4BVGePDJPTa8vXYXHl85BXyGU=
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
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/filemap.c     | 4 ++--
 mm/huge_memory.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b04be64a5069..e85a4114d2ec 100644
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
index 283c4bc8b927..2b31a425c7a3 100644
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


