Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 490C5606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HzZLpbCK
Received: by kanga.kvack.org (Postfix)
	id 3F1996B05B1; Wed, 18 Nov 2026 04:21:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C9236B05B8; Wed, 18 Nov 2026 04:21:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1446B05C4; Wed, 18 Nov 2026 04:21:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 092D56B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:21:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71D4E8028F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:21:35 +0000 (UTC)
X-FDA: 85447696950.05.F3FB91D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C037A100008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:21:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HzZLpbCK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794993693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lcN03BFrUVuRLyZhzYAenj3/VDeI8OU1AfZJ+NJkCIg=;
	b=v+FZsMyX/8njT2jfVMFEUf9hfZx5wv1KSSfoDMwdgV6cMn7AxdzZcriqwmyAugsevUYFuB
	b/QyaMv21A7vJV66u4pxfL7W+85rp5k4R3l9VnICde65Cveh5kKIP0Aznb90e2IGvolgX5
	aYiokNHz4EsXM8NTuV63vaO9eCkRzK8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794993693;
	b=cHJttuOrq3t2GRSLS6K04cQrFb41rTEsZQ4878MSIRYaRDGsFkVBhKC5Gr+E8vjF7J9voi
	FskfgYbyHMbW47sHlmgzacCkUKMtMHVDw0+TAqJcsePo1iTdJ32eHRi0b+u8N+RWFt/xhm
	xLnvBmLuxk0nnJu+seiWrCs1t+Ddfao=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HzZLpbCK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B1B861E99;
	Wed, 18 Nov 2026 09:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362CC1F000C4;
	Wed, 18 Nov 2026 09:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794993693;
	bh=lcN03BFrUVuRLyZhzYAenj3/VDeI8OU1AfZJ+NJkCIg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HzZLpbCK9AGaEnuP4cFp3OGO+VnzS4PHvl2aJ/d4Rc1W4oOUBXGlvkpHcGrUaytVJ
	 wcxCe/JTjMIULeKrzpUPwLMfE+/0tb5AMfpANxx3MRFklA5sIXW15u8H24VCUf7jn1
	 Ok7PXGqOw5T7NtvDM1j4+aMBK+2yX9uJ9fHxRG4I+o7MperUm21DHkExkJ+8BCJb0Q
	 HVOkl/4urAo6Ab3ZBQIbQB2/0kxKajG7dUtKyhs2BCWedrZPiXzOI1AsgzB5uxPLq3
	 PyWcuYgeVkrPDHd4G7mt9wdGizua/w58hbyiqZlSJvRNmS9/LFngCZYFK200TQ9zLx
	 bhDgVuxNeoVhQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 18 Nov 2026 10:20:37 +0100
Subject: [PATCH 2/4] mm/vmscan: flush deferred writable TLB entries before
 unlocking the folio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-file_folio_flush-v1-2-e9e739ed14e0@kernel.org>
References: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
In-Reply-To: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 "Borislav Petkov (AMD)" <bp@alien8.de>, 
 =?utf-8?q?Cenk_Y=C4=B1lmaz?= <cenk@deepfinresearch.com>, 
 Zhang Peng <zippermonkey@icloud.com>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Mel Gorman <mgorman@suse.de>, Sasha Levin <sasha.levin@oracle.com>, 
 Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, 
 Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>, 
 Axel Rasmussen <axelrasmussen@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2390; i=david@kernel.org;
 h=from:subject:message-id; bh=w4iaf/Vfi3av01ERqlZd2baVtI78nCv5zLerY8P7EDY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLL+5v6c83aReG8Nl90RhW+nKhPaYlqenO/X/xQnXuIbJ
 c6WmDu/o5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIlsZmdkWGO7Uyn66WXpJ7NO
 NPOuWaTv23Ly9tSQjVvC3Hae3LwgT5Xhr3T94+vKwXku1pIqUd0HpOYwJQYJHGiYkXZZTtMliuM
 BPwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C037A100008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: hq7gp8fbtb9g1u6funzacj9hkxpk383a
X-Rspam-User: 
X-HE-Tag: 1794993693-87054
X-HE-Meta: U2FsdGVkX1+RTcQ7ZoEh0cd7c5WTwVqC7AhzAep53XX/np0VIsz28YWYZI7Fv543ycr/e+GcEHEau/G+W1GpoxgqSDgyGMPPRzkd65NScbCrn6zUoDEvJlC02XXM3nH5zVaR9jtUPdxUxKmnwISBJtGto50s7h9LG8EO79QRq8YyYqUvkyln2GGl+jvSoSVzmh5t4MMHHeeugEAMIwG5FiElk7Io+D05VQNEY4cJoyP0ZR67bD0HQL/IY75alEjmA94It+8a/3d+2xgT12pWAUAJNt0ZDq6WMGy0VhBYX11UG7vg07LtDSMLgm6SOuU1smplsu1/95GyETcwjD4m6F5OihHwK8Gj83vi6BPbrGG0wvr+H5yJ3HIGbI3dE0vVJXH/axGbaCWS6MXlcOekWzpCpXX06WvhYjmtg5KE+lebzHJJ4f2zAZkBDm9HGlxhoPHMqNkItfs1gJtaei1/L2Un9OvtzfhocnfVfw4+fgQ5q2F1lOqRDcZowzPrVctmBqhcdUwC1SBuNENiThhGId09EC5+B4CxeUgsUoDPWVft5MyudTSq/w/lIGAfgC0Ot3/UetoCXFfI3jJUgXk2OlcKs1ylEkNNZadFwXyWQOlTCyoS0idadjpUOPZ4H6V6c8PsZDPz0GudKR3cCgfrb4sncSmu9eHAF1ewszPXsD/OwHEzxpvQaPrD5eFq6MxMQN4sbg5W0kOXkWlHxkke/5WzssB3t9kNM6W7Om+xMYzq+i431Dy8gCrslLIyp+u7DcrwT+MYs7pGx89+iM0R7GBQ5Nto9an9kRY+5mGhYr3rYJx7yRCFlPdw6mALyf51z/Yvw14GcyDFcy8NTxaTamw2bkyn1+YjoCVEf0M174073jm1UQMflmkM9vV1G0glEbgG8YlrPl+0133QqCTLrpvLSkFVNRdz+aLZGVANryZWzrASNETfFFhK/fMbId1Tpxl/l7UsAFUJ3MsAp7N
 LQAT8054
 lhn9WQTjLCYxbO4Wr3c3Ath0KCiQ7ivm8FToyfyigTeV+sjgcXUlk3vCDFmxoniA1Mb/in4KcJ+6dxMNqXJjKTmqVgoiJlm0UYvqatLtWyvGMAJmuJAUVG5id8APAEPrLo8+mHxrMvlj2uuygok+KzN4wmp7rl+V4UvTv5F/nCfAOWdXKt/0bmvpM7/S+p0G8s5EV5c1WHq2xBj/yFgSMml7P8kLGScS94u5La9SduOfL14XNWnbsQ1jY99vVCnI0tWb9OHYDg+swIjqCWvjRw8ZN2LVo+878+JBW4zitBzjebNdaWcQrg5HtWm8uLjpaofQg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

try_to_unmap() with TTU_BATCH_FLUSH transfers the PTE dirty bit to the
folio and defers the TLB flush.

Reclaim must flush the TLB before unlocking the folio, otherwise stale
writable TLB entries might be left behind temporarily: writeback started
by other mechanisms (e.g., fsync) will not find any mappings in
folio_mkclean(), so it will neither write-protect nor flush anything.

A write through a stale TLB entry after the folio was cleaned gets lost
once the folio is reclaimed.

However, reclaim currently does not flush the TLB if the now-dirty folio
does not get written back (e.g., gets activated or kept instead). Fix it
by flushing right after try_to_unmap() if the folio is dirty, which makes
the existing flush before pageout() unnecessary.

For dirty page-cache folios that reclaim activates, we will now flush the
TLB immediately after unmapping them instead of batching the flush, which
is the right thing to do. Performance-wise, it shouldn't really matter
much, because folios with dirty PTEs are usually young and reclaim won't
even try to unmap them.

Fixes: d950c9477d51 ("mm: defer flush of writable TLB entries")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/vmscan.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5495d9be90e88..af7831643ecf5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1455,6 +1455,12 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				flags |= TTU_SYNC;
 
 			try_to_unmap(folio, flags);
+			/*
+			 * Flush deferred writable TLB entries before we could
+			 * drop the folio lock and others could start writeback.
+			 */
+			if (folio_test_dirty(folio))
+				try_to_unmap_flush_dirty();
 			if (folio_mapped(folio)) {
 				stat->nr_unmap_fail += nr_pages;
 				if (!was_swapbacked &&
@@ -1496,12 +1502,6 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			if (!sc->may_writepage)
 				goto keep_locked;
 
-			/*
-			 * Folio is dirty. Flush the TLB if a writable entry
-			 * potentially exists to avoid CPU writes after I/O
-			 * starts and then write it out here.
-			 */
-			try_to_unmap_flush_dirty();
 			switch (pageout(&ctx, mapping, folio, folio_list)) {
 			case PAGE_KEEP:
 				goto keep_locked;

-- 
2.56.1


