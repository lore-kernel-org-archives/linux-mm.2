Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DF5B606A323
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hLIyzFr/
Received: by kanga.kvack.org (Postfix)
	id 466BF6B05C8; Thu, 29 Oct 2026 16:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4170C6B05C9; Thu, 29 Oct 2026 16:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307C86B05CA; Thu, 29 Oct 2026 16:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F15B86B05C8
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:36:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7BCB91A01F0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:36:59 +0000 (UTC)
X-FDA: 85376822958.09.3E7516E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id B8492120002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:36:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hLIyzFr/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=39sO4eVWOAhWIFY7dwmw5wDLBZR1O1Wkdyg2pyVIaSw=;
	b=8mKiC8g2s7jOcEhZ35MoUzPLlSqO3fBUCavocklegj7diDOpgWJ9hMfZnGX41V0cZ/yTVT
	VpDI7SlFZ4+XFaTwBg2uw+fpsuSpVOnp7/51wdJprDFDa8oyFSRuqN28TgbbXGtTrX90Vg
	AS+iPH/cgYwnNvmZgMItXSYdRTDxG6o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hLIyzFr/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306217;
	b=54R8rAAMZaXHRhoFWYaoT7aoT3V8U/Nk4NGeLvgQx9lcvGCJi1AbJ8UJx6WWPvpzs+6+ES
	ts67pzq6a/SvPAWTAomujUIcqTs0gI7pyVSxsSBJsdg7J4BGSPpqESOyjhx9ww0SuTb3/C
	oO9bu3SBwMthvSj/l7H8oj7d7Mrdhs4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 59B46605CA;
	Thu, 29 Oct 2026 20:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E0E1F01828;
	Thu, 29 Oct 2026 20:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306217;
	bh=39sO4eVWOAhWIFY7dwmw5wDLBZR1O1Wkdyg2pyVIaSw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hLIyzFr/V/VvcGfnmQExxQg7IIwVIxjs2CWLB1sCab5pSvGmM4huLIGWjFbTIQt/g
	 LvIjs//slU9Pq4A2SJLgO204tjYJlgMOO2JybMj7kVGc2TG/vohe/X3Zz7FeCoRLRc
	 nrf/oQie/gYaRI5uDKW3ey8ucpkNlAPAQfa6wQ9bTo3VzjDmA6sP4x+IV/OttkAqd3
	 JyWct3e8oJ1K9D8M52trvZOLS6s+qHpCPGamQ5HJ5Fz9lHdo495ySJkjCRlFWivA2z
	 btGsxZgoULfAhGK6RKAeYV19UJkhbRKtCZuqzEA68xNrUH7XyrReQRSJ+prYoLs7a3
	 fqpJE+V6bRCdQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:09 +0100
Subject: [PATCH v2 14/47] mm/huge_memory: fix zapping migration entries for
 device-private THPs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-14-a64ce7f83abb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1532; i=david@kernel.org;
 h=from:subject:message-id; bh=I7I0jhaFoDQ+nBqhpxvpT0b9yhPeTYbK2Z2XhTeg/TA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer21bu2tt8uaHDhHRMpPkLUTW16ivZ94sK3hdWn5lQ
 8L31aqJHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzkghUjw3rfBSFaX+RXSHif
 D2cU2Dqz50GT77tKx0VZSuXaaz3ahRj+KTklP/0QL6kglxAToL0i5/q5rtPBtyrT2i1fVd2MMHv
 HAQA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: B8492120002
X-Stat-Signature: b4uu6ity7pbhhb8jipeo7w66h1khf44o
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793306217-279631
X-HE-Meta: U2FsdGVkX19Y2t724/oI8Lrv8AX0nLM2bMpeuh0M5ExKzu8q8wkGQ3m5nOEPrK9cxLl5tjMKEPmzFBHzU8u5CNntiR26BYVcmgIT9de5HQ9ldotdw45svDkB1vXSyXXH2a5DdSNRwwX/F9//N6xFqgqym6VCkSFRxLvGTDb91VtZC3UgsG++CaUs/HzAbNkHPtA0dtWcfp976xK0Dinh0ZZ1f+2o5eLovntPjaA3TERyLsaVWVC2i61B7CTw3c2ZmGyhGiZ8XWIgOumvbvr1sJM5i60/Pa8Ye5qlcPpkFtFWG4Wt21NJxuA8CWnk6jvB2m63C1AiDDRy0//MS4jig+js+fQ+yofZGPat3ycLNv/DIYJSMjgbFy9REo7DB0AQtgn0W0tdSajjhWwB29mKjrZFBDFsdbs930T/NKiWYvQ3J2TMGcwG1ykD7W1WsGrfvO5njLdqdNsfA9bwkUtpk7ZOToLgAvlRjNgtgsVRVMgkPibuAhkVcVgifGx5D3c9fnvPc3atEi59lxIfxBoLR47ADcayHkXmJ33DXGSI5nEe1ZX0WE00mYWDlonpQrqq6SuuZ8nspX/GddBoKi71bt+MS+TjTW+Xija0HXhXlqCVX0m9MYO5A+t2UIL/l4fziRp7qWp7uARE2U2tLAb4moI6M5wzeFv3hGSx232XyYl4xNtXW5ImNkXDVfG2pB4tlfjTtaAvrCEq3C/BGX1tzqyQV42EZ/zjghrNtZKN6G/37i3veW0N4b3MBDHsALqKxGOI/fGsIrttZA3IecGwkd/88e7bzi6tycY+Kn/hLNliovSQZ3jmJASs0UB6Wv9QikRHUVSxzR8EZfBaP8RLgWPRQSpBgHUyHM7e5VQckBZhFg75pxCzdXTDR1W+APzauFNef+EuxEOupicnDbrmaS73cb6XxZ0ByrYL40Bz7a5HqtVzMu3ePVrUFZ+o47R+I+x3JJH722mySsq9aaA
 G7pjOlRq
 W8EI7GSO15HpO5q+zdlx4tSDGrOTmr9G5zmR44jhDlDp1+g/dtSoW0TR3l6R1uvq9OUdPZan07RmlxV6X2ve2NKr1P9OcbTiGQ/rRBUc22k/Xf1Qg4cN2uptuOr13W+6foeFgR0Q5r85ovU6flGaN3tPULsnZ/JnPNdC7235o70TPgnOTM1KHLnIDILFzuuTA16wxHFnOnTo0ExxBRNakCptTI3cb/nrF8fqHstRtQW6QViqZEqvBhFhcpU3j3PrPnqx3JuM7CO935obc+Pm+mrh+GqqRlHZQZhtWBmN7DerjQuf0ymgGlggUmN2X1UJT/aUDUxlA2zFUbLrtW2ML1fln/NnVx0Zu8ssbYjn9HojCDBI=
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
index 1d65c4f576f9..c5aa0a0a407c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2493,7 +2493,7 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 		pmd_t pmdval, struct folio *folio, bool is_present)
 {
-	const bool is_device_private = folio_is_device_private(folio);
+	const bool is_device_private = !is_present && pmd_is_device_private_entry(pmdval);
 
 	if (folio_test_anon(folio)) {
 		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);

-- 
2.43.0


