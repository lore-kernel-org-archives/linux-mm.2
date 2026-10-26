Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C5B8606A323
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a2oBtA1M
Received: by kanga.kvack.org (Postfix)
	id 6A5D46B05EE; Mon, 26 Oct 2026 19:28:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D426B05EF; Mon, 26 Oct 2026 19:28:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56D996B05F0; Mon, 26 Oct 2026 19:28:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EB3E6B05EE
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:28:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A69B5A8262
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:28:16 +0000 (UTC)
X-FDA: 85366368192.20.5624EFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id DBBD820005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:28:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a2oBtA1M;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MsPh/eggStrjiHwP9EayEEqNGoFUTjhuNZcTRbaJqvA=;
	b=M9XE2hpvPLbqbscVpPhn55g0uVrYUXN37RPIcCv9JCg7lDQ+fp/dZ79BKsrhtv1kT5ClZ5
	iwe6BJUs757oeBW+wuY9aVyhwo32GzEJKz6ad7Ch8VaYviooK8z5eqy074RUBpQSi2Tl+j
	fDwWYkPkj2CBSfDmBHyqSAhaYO/Fd80=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a2oBtA1M;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057295;
	b=FSLSfCqLRD0oRH95exVDfusGMSlR4Z3bY6Gstvr27bmPhmW4BxUdNhxNYnDvyGiFOfuuAF
	4rw5GOTDAXRHQ5Ky3H+2fZA7ld3LIn+phfaQ7BwJ/lyjfWq2Z9KvHqTzNrz5VzS/hj5zt3
	JLjr3jOoVn9mkob8oFD4WAxv+67s9q8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FE2041FF9;
	Mon, 26 Oct 2026 23:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B5F1F031E8;
	Mon, 26 Oct 2026 23:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057294;
	bh=MsPh/eggStrjiHwP9EayEEqNGoFUTjhuNZcTRbaJqvA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=a2oBtA1MZUa66kHRki/kVGEs4Zx8bYN/Yl5uKbWs9K/ii8a0kAHkMnSDLIdapPOWX
	 tT9/m5gFYOUnJ0bxIPU3CBuADzf8viUbnqgkZg+qgxV89v2GUDN4AHW0Z1wAHkcduk
	 PIxQdnRdZJHbXvgTH5eaPIsMoZPvrYBYhtl/jAi8ljDXzIVG1kAItasz/VnHm/ks1x
	 Iuz1X6uJ7GLX4jmLwHxR9GyQb3CUrqzCsMYq+8T3s2R5uK7EIuMRjtCCGsaXSkwqoJ
	 fIyFLJR3wL5Y6vXz+2Okd6zBZ1WqzzuUzJB6PvOkZKTgLrcpSfx84MZ2uDvQrjryH6
	 7UK0jOt7OUuWw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:53 +0100
Subject: [PATCH 33/46] mm/madvise: fix data loss from MADV_FREE on a KSM
 page
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-33-6f74bec9a5bb@kernel.org>
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
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1695; i=david@kernel.org;
 h=from:subject:message-id; bh=qp+B7fki+e2EPAcFDpqxiM3FT4Otm8jPFLB5fTfcqqc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35++XlaKOa1L9OCCE0uzuD4K1eSJ2TXlGKhMad/5+
 7MYb/7rjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACYS9Z3hf4lNQMf/pQy/qw6c
 fx1krnTVIfBoMcfe/NDGiKW8PNPauRgZLuTsfCHh5j9fZiH/fc/r4R9ag06c/lFl0HhBN2Pn7x3
 2/AA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DBBD820005
X-Stat-Signature: ycz8sxnm4scdyqdwjg9egdour7goe9r8
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793057294-25376
X-HE-Meta: U2FsdGVkX1/BkF7AwhQLR4FkRyiryRtp4UUTJrE8GSc9rY+HTS1auyn3GGcDDWTdp0GqKasZPJV6g2UWS1WsQlFNtVliHzE3GceM3Mhv9MdCvzhqbuk1mbOPaEGFqFsWazS0UQKoplY7+BJrh0wMo2aTQJdTZsQijBSKXSUW/0jDaMCAgBchbUbAUefi+LoN1lSBUqIbbD/JfNg4QJ8CSzHXMmBG8INzj5YJOFBEQOxYOpQImVKn9sAcC/ySk5e+JX2mFG7lYY+5k0DaimVROG0M7lP4Nk4ysOzNxCkLqiuyamXoZe4xpnIcZrAU9GqixiieTVwH+bBmNEf7tM2AFeROqchWjem3hh+PzLMU51OfEL5+mLXw+ONnwV1sfHIA9YeL/KjQF6sJAi9FrlPrg08obj5Sdv4eQQo0B3SCt9Zk9ssNYuvwmr0xujldfB+1Nmfoiin+kw1oCLxyL9u30iX6VVP6g3+f68ckNzwu+o3H4NmnUAMy9bjdtcVtHhUWMjoZ6VHiZIhW2gkXOQE7+dZnBpRgxI+l1dB4sqSWg/gmyMxQKbFJeRsgY4XkCkVRsroBoiy6zxTvGgTvsuY/aPDF/7jUv9yviD5XbevU+evI8EEMBdC+O44Vl33D8WmjBOABUYkIn1bYnGkqKq3W13Dz6/tmccW3RaOZmBtlJu1P8IlGANVjuS8nz9VeG1NOsY9dSpeZz0DCATPEvLuO85JZX1L+4cqAbis9ITOKvWpOnXQgc3u3TNnOAijVoG6uPplykh547eYGw1A9G9BktM6MrBPRadpM7UWNdxAtd/xsORA4AUNHQrvJXHM+1m+LwXKNPi9s/X4/CU88OXyTpPv4sU3nWH/Sdt0hDIrSkxoXI5oA++cbkQ9BJnvgPZVeCI2KDCeVPcBkSPavza0TXbqarxb5Bq8hNOjfTDFhkWV161tbtj5/ralZr/20Ec3ddl7j378zqNu+QdJ/In9
 J64rwxur
 E2gzDjOTtyKabfuZxyuNzaEiruTHprM5+3rKw7XXzAZxNiiIto4PVdNl+6U4EZCSyThdpE/S6orEvmFwUsU/rgSkHLXUOTTUxDihQQAMiTcOWKeZ1pzwl2i1+O+wUIcXP9GG1HQLIxjOv0FQGtxNVNTGuPjnm39YdU8tbU5N1h2s9Z2yKns7q/WAA/M38bwicIezokeM891X79GGnFMjant10AfytwgQR26wvkNvLdOSCe7eCHCwoqpAVAplgxslh59phVF4fWgiQKx9Cfzi5bOimcmWKruvmophA37dze7oNo3gAeOLAcNSb0PGJI8HPgHOlHWv+/7tDutfKl2i9CT0QCDyaID6vY52Az9De9UpVoEpLy+AXeBHUN2Vpeel/9gZXBXc1v/kbZ6JJ/LEqI8m/+60G5aix6F6AtA2NwR8YmxQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

MADV_FREE can clear the dirty flag of a singly mapped KSM folio. The
folio remains in the stable tree and can gain new mappings without being
dirtied again. Once marked lazyfree, reclaim can discard data that those
mappings still need.

KSM always marks a folio dirty when converting it to a KSM folio in
try_to_merge_one_page(). Marking a folio lazyfree clears PG_swapbacked
but leaves PG_dirty unchanged. Preserving PG_dirty makes reclaim restore
PG_swapbacked instead of discarding the folio. This also protects folios
that were already lazyfree when KSM converted them.

Skip KSM folios before clearing their dirty flag, checking under the
folio lock to serialize with KSM conversion.

Fixes: 854e9ed09ded ("mm: support madvise(MADV_FREE)")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/madvise.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 75b409e97dbf2..a16e3cb256b7b 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -756,6 +756,15 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 		if (folio_test_swapcache(folio) || folio_test_dirty(folio)) {
 			if (!folio_trylock(folio))
 				continue;
+			/*
+			 * KSM folios can gain new mappings at any time, so we must
+			 * not clear their dirty flag.
+			 */
+			if (folio_test_ksm(folio)) {
+				folio_unlock(folio);
+				continue;
+			}
+
 			/*
 			 * If we have a large folio at this point, we know it is
 			 * fully mapped so if its mapcount is the same as its

-- 
2.43.0


