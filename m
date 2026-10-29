Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A13C1606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YezDjZU2
Received: by kanga.kvack.org (Postfix)
	id C0C296B05D3; Thu, 29 Oct 2026 16:38:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3AC6B05D4; Thu, 29 Oct 2026 16:38:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFA106B05D5; Thu, 29 Oct 2026 16:38:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4ED6B05D3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:38:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0DA69804B9
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:38:57 +0000 (UTC)
X-FDA: 85376827914.05.CFD2B1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 348CD140006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:38:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YezDjZU2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VnQ13mkoh6ozIDWGTVX+C6HT4vjQEoXrCm0MooEO04s=;
	b=iyjYXjrybIBiiiFbvIO8YCC0g94kgv0EuZVWc3ug/yTRB9G/UUGWvN6ibhwgiE2+btdy9g
	tv68b1ybMVNMMZh0ouV1dOLfkYjfVug/COk1kNgBkNyG+2vFmDRzAq9NmU7oTf+Kfjuzu4
	x9fNCdOIzVqf4pfar44kMwEeC7O9HeU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YezDjZU2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306335;
	b=YidAIUEILUbgG1Md1Tz0GmMvY2bGynBSU+2hDA3gcUjgL8q6WwBg0+cmU9BVw7hzIBlXgV
	bTZHfqLm6OBoAtcIHYoXJzk1g7XqLGy1Zc1NwjbcH3kmOKnW0sj+bXbp9Wr3AsWhLS+bKK
	wrt6/9bR6+fVGoNABNQTDd4HvyCdOKo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EE5F4366B;
	Thu, 29 Oct 2026 20:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736391F01829;
	Thu, 29 Oct 2026 20:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306334;
	bh=VnQ13mkoh6ozIDWGTVX+C6HT4vjQEoXrCm0MooEO04s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YezDjZU2yi5cWmUqfDHysvLO9HwSd76jRjz2DKKiJKmvX5TchaYVydd2c1v8z1JoG
	 ukY6PBjO2jSZ2MQea3k0Ss09Ud/uCHu5P7yCWtRSy256Tb4AzyVTKkJiiDAcgduQg7
	 xrppl9xLjFoWu1REw195bMUI8zpRl7qt7xONHzxWgUiB25CSuIO+I9FXJAhMAXvIxe
	 9vFj0edvZ4NkCIz0Xn+Jfn8csY2hF2LHytvnUSwkq/J8TpxTtMH2yoRQoiT7o4M8eY
	 68bluiNVhI3XJ1TLn1f1fRogMry8mga7lzsNOhsJevsO9wM1nRRKTRUXOiJoCR3V2/
	 aAjnkIfXbMGHA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:17 +0100
Subject: [PATCH v2 22/47] mm/gup: check for overflow when converting
 nr_pages to bytes in GUP-fast
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-22-a64ce7f83abb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1309; i=david@kernel.org;
 h=from:subject:message-id; bh=1C5sa/S2cZ8sLgA0w/Gi6tvhiudETPPmM19hS9JNC5Q=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer21vLdw0040r6ZRnZU1d3rZlDw/pO7lrXgmoYp4wY
 /tajl38HaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzEYTkjw+vlHL3B1hunvHr1
 /9a717nmGp87rIONvDT4+Q4o6P65soKRofVY6M6Jcm9fbfnHGVBQEHrm94n22fOMc+78Cd67bJV
 1FjcA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 348CD140006
X-Stat-Signature: ih1bcsbsddesp816z4ya9buqoggxqczu
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793306335-743556
X-HE-Meta: U2FsdGVkX1+n6GuBwO+0mNu+LmKUXysh5QPIevbbQElKb6Zn0c8tj2ADEn3QcL1ESeUhxet7etPIEy7vipiBU9FofAxj8aqugrtvf03qIkqIAeG7dkyu/Ah5bvcefEn7AeBkybgmCnYy4FyeF3R81jXyc3PnSDAhx0WsesYa8HkGBsQblUDN4wg+ERuPghzUYMIIPq296suFW+ZxcD8HDEoF+tJPgw3S2oxQaPG4Ud7372JAYicA8+8dXKRt6h4s6cJQ5rp/o9hn65PP1RVwm1Pk6lY3p/CmETjWbuqPc4ltDvd6g7JUGs3sYVkEiL/RZGe5FM6I8O2aCMqMetR1sAVGAObdP/cUrriqvJsvfex1EHv3PsXqryxIDeCcOVSGcyBW2WpmlhKMoXxdu/xXOoSqleLGpDBHIUoRa9GU3sslq+cNjPQoNRQOM+3OknsQbTL63do8+qk9gDBtx7GVrHzu1WUeTIDu+cbHIAOHaww9UKvpayH1Yysq/FhPExOzDz2qWtAiTv1E153ov1o62gbegkXOMspju9e2gDqCGBxxfVnJcsxvryBM1JTM1SJ6Zmq40eMZVpjxtB2wdAOZFOOsqwj/iBxOgL4meLv5JLj3+WlX8PSo538n182NKY/QSOTKmIduUJimxIK6IMLpkDutq9WO9oYpLTdcqmUbh9/ji14DQcOsyLwgB516da0qm8YOxA1eRNw09crdIsSUSymGYJcK3AEBc0pdaNMabVZ+5lGqSwdpJcDHqJMPhoInqJ6SIjZbp8aGMiBkBEATu5TaZJ1BgpMEQU+ECr+TubNGVz06XjC3IfL3tbUERg/3urtGMUOp7eIa3EojxU0b7RlVD/gic/L6N9AhbDC/Yn6s/XEjOVb5pHBd7Os2HpQg8cFGsl50oc0GeAq0lu3UyPrz66+5mNo1CwbMY0zRU9Mx2Hcb1UtlMMUfyvzJfs1td4IMmlvlomvxPdoL8LI
 OuyPuMfk
 mHsEkVRtQqLOuI5kXqtuCon2mN8KKUkUJisFrHpp34dZu5t9J/I114TjXDw9YDVyQDMS+PKGtm3E4RcPPN0cDFt+zvGF2mHzOi//aFrWHmeE2JZlwGpNs9/CIFZPe+6JRYuA1Wb+v3e/TbBFDIQJyR+pz0jzX9UTlvdFYCNV8z33uSRbDJ7woojmhaeBZjB3qs9wX9acwCXpkGJ20amNvsDTsK5CoFQVpCUay8igXUmSRa2K99SzzbJ+9zIM06Bcw2bbCkAPgVDSQa8KgKz+XtOTWnkVNSpOClKUQEME/lH2FIQpBPPy2uVTemneHdLUY+vhFRHseOEOX0AaE3kPTLHoaCzL+1BXfbq3pmmfuxOXGwZDtBdW3IJTgsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The overflow check in gup_fast_fallback() only covers the addition to
start. The preceding nr_pages << PAGE_SHIFT can already have truncated
the length on 32bit.

Users such as RapidIO's rio_dma_transfer() can derive such page counts
from a 64-bit userspace length.

Let's just check_shl_overflow() to reject any such overflow with
-EOVERFLOW early.

Fixes: c28b1fc70390 ("mm/gup: reorganize internal_get_user_pages_fast()")
Cc: stable@vger.kernel.org
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/gup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 1c2ac7c66c30..ba4907b35232 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3225,8 +3225,8 @@ static int gup_fast_fallback(unsigned long start, unsigned long nr_pages,
 		might_lock_read(&current->mm->mmap_lock);
 
 	start = untagged_addr(start) & PAGE_MASK;
-	len = nr_pages << PAGE_SHIFT;
-	if (check_add_overflow(start, len, &end))
+	if (check_shl_overflow(nr_pages, PAGE_SHIFT, &len) ||
+	    check_add_overflow(start, len, &end))
 		return -EOVERFLOW;
 	if (end > TASK_SIZE_MAX)
 		return -EFAULT;

-- 
2.43.0


