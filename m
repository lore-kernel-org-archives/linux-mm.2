Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2526A606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oVdw61b8
Received: by kanga.kvack.org (Postfix)
	id 443B06B05B4; Thu, 29 Oct 2026 16:38:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41B4F6B05D2; Thu, 29 Oct 2026 16:38:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3319E6B05D3; Thu, 29 Oct 2026 16:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13B5D6B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:38:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD081A80EB
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:38:42 +0000 (UTC)
X-FDA: 85376827284.04.B063B1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E15111C0004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:38:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oVdw61b8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hUEcnN9ydaxDMlr7FSPNgc2BgiAcB7rSVu3xqMV261g=;
	b=Vcrkqy1DQAoDDMC5KFgwFzNGLYGd//9QZIhd5WSxwb1xHLGDKqzlmWPaA/iFKnpzSIi5Sb
	UgRFDOM20RNcm5y63a4MrEnY2ik3fIOwgHLGP97XgKO4XV7YCQBgROceMNEFBQgNruEoSP
	7YKPyW+do3nasMcc0lF3+iboaBwXJKU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oVdw61b8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306321;
	b=TwRl50/SKXG4TQrQXwDWaOTk+931YOgk6bXtrTnqYVoz63LqwgXSJXW5AvMALNvPFrjv2A
	U6E7aIr3Q00ELZn7NtmRt2ld8XYdJUZJtEfiopL9Hh5L+eXpc0Vs6LPDWIMewp1vT0QL+1
	KwST49ExNZ+tT2ax/SY60GpEu6wzvxU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EBB140730;
	Thu, 29 Oct 2026 20:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF331F01825;
	Thu, 29 Oct 2026 20:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306320;
	bh=hUEcnN9ydaxDMlr7FSPNgc2BgiAcB7rSVu3xqMV261g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oVdw61b8fprlozgBHncc41LpdVLG5SLHt1W2WOHHdwpmEHY1UxuvvBPOvqfUxJ6TE
	 ypj1G/DGtqCz4M/Mncb0zLIyJD7YZU5Q9CwKBWyL9J9dnBrvu/xczhapnmY6bqMauH
	 cFW+yKoFtTCsaGgX0DaGpv7jF2hxRsfJnJ0YRpK3Cjo5KggitCplBM2+XWYS/AUOMh
	 5Qtft9UTttmKosFmaVLBtNXQus22sqElhihxeqFdjS/65EW05g7NDzHOAN3aITVvcf
	 pDVlw7VhPB6Fkbvk3twLQO4Jx+uPVK41BSLLOJJbyUqRT/3NwuiE1YXtG+OOAUcs+j
	 AEGV44bySO/jQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:16 +0100
Subject: [PATCH v2 21/47] mm/gup: fix out-of-bounds write for nr_pages == 0
 in GUP-fast
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-21-a64ce7f83abb@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1263; i=david@kernel.org;
 h=from:subject:message-id; bh=nCaomD0R1GmRaMbC4ikA/oDPAe1RZtNKP6V5LWq8bsk=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer227ZSqbsjfo/PkOsbOhrnde/K8U2hdmLqwoELi84
 uqRtBdJHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzk8WlGhuutW1yb5HykeVbc
 c+eWPREaIBpb4SyWKbC8rZtNv2v1F0aGKVM/LJjuEBViqMyy/c3RD1erLQu2rvZ/6eWeIbAgyci
 XEwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E15111C0004
X-Stat-Signature: fkuwq1pwy1h6t3dcgnwdrmpcxzj4csgy
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793306320-293677
X-HE-Meta: U2FsdGVkX1/6lDTkwpWrnCz0Pp/Qru/XH0Bgl/HMGzpTxv3yN8goxm8l4yjuuO+kzUubTwv30dLNvKLezz4dIJEcv2/VqdUmrbngX9XeGQSPVILEJX2YwbU1bFQZ+AI4MubTJgt3Wwip4KM80ZY9ebuKiztpnRkNphQpIbhS8G3RYih3q7E0LkaEWDwtt20pt4Wh55KjMsE2lppPTdFvC7JGcLchr6S5gTDysNT1sFRbbBhi13KoL3E3dkCoqy/ZoNmIKw48sT36xWIJFgS+dnc8rbmOIa9JPSZttPcxCs6vood46v6BIIWqfVSYiIFW5PCbGgUwNk+1L9QwpQIJp4emPkQ3ycMuIf4N8iulGyhWfslNWruM0Wer1aNRew/JHYupynHy/8Mit/8HED+aBlmc/dIlKggzswxJwxS4UWilt9buTKkS1jTnunqzrOrMWGNGPGxOwtvgO73OV+XopesJ8kC+Q2huQPzGXcE6FkfzTdUSzNuCTqDGZGfpHUF7ljNvQJC5U8nNoYHMAgYs9HtKr1Djdc2/+BrQzkf0t3JcpQl61yQFjhqJMbPnXte3VICkiGjP+Gxmqq56X75uPP2MJqN/W/PKBUwa134dcAy0/wHzTUlikOnOZmBFbnjis+OlGFUWIHAHjJRhDwKUihVUGdKTX2WWC368Y454GgkaLWrArReovrq7ffS22FJnc9dNRaf5GJtzsVfDW9qy+blGB4eMEIbcztNeAcjgfTRkaroIniIXgm3hHbviECD4b/UljrSJBrjO6lUqfw7GIOe8EJQlZ19CkbHsq5ywMbbhLRnpvp3roVgW+WdOaVhUgZVXSrX6WylBwVYKIsg1mSfL38wFbKg+D06DZeos2ijiHeDR9fxwwOMIJhqWutnrnJ0Dwe3SuLDENQ7IuDFv/68Se/meIq4V0lSg26XNEa40Ded6vbmQzAyKVUF15SRq+NKojIRHezEzxjea9V8
 aRtZYJdH
 UUSoDwMOVQIt9bWUDqVvH1kTK9UTAMu5+EZH/YLCyD9rG4/bQrerqK3Xbr/CLzQV8TTbI/f1hEe7tSW3EU1fWLUELtM4W22Kh7wZbGACk+fbPWHj9b0R9NcNJUvCYT7CvvffIT8ZPqWbSm8n6hWsOKnedBQLe+rJ6MI5GZSlKQ80whA/GZ4Rk7Wy82Zap1dY+Heh6ju/COMfSltW9I5HqLmlQDcvQt1AA2yeQTEhUtzAnf2EEQjFwveGbj2kdGYtZ6UkTd80+7e+RZKb7bXS45CqbJxTTxcxD5eauIKSnj2GnUKV5GV5cs0UNwTZ5fq0b3U58lSr1jbQJ3SIrQmqRWCLSkakV6z+c0IbnzwR5B1h156I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

With nr_pages == 0, GUP-fast still enters its page table walk and can
write past the caller's page array. The old end <= start check caught
empty ranges, but was replaced with an overflow check.

Users such as OrangeFS can pass a zero page count derived from a
userspace-supplied length. So let's return zero for nr_pages == 0 before
starting the walk, just like GUP-slow.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: c28b1fc70390 ("mm/gup: reorganize internal_get_user_pages_fast()")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: simplify description ]
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/gup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index cc4fa18783ce..1c2ac7c66c30 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3215,6 +3215,9 @@ static int gup_fast_fallback(unsigned long start, unsigned long nr_pages,
 				       FOLL_PCI_P2PDMA | FOLL_HONOR_NUMA_FAULT)))
 		return -EINVAL;
 
+	if (unlikely(!nr_pages))
+		return 0;
+
 	if (gup_flags & FOLL_PIN)
 		mm_set_has_pinned_flag(current->mm);
 

-- 
2.43.0


