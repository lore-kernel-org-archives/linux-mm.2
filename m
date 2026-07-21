Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 033EBC44531
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 02:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F3DC6B0095; Mon, 20 Jul 2026 22:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 176B46B0093; Mon, 20 Jul 2026 22:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1586B0093; Mon, 20 Jul 2026 22:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9F06B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:53:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D150914033C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:11 +0000 (UTC)
X-FDA: 85011262182.02.A1FCAAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id EF71620006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XEHybAo+;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784602389;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NVNsKl/7btL+2KqAV7Pf+R4Iorkfm2pA8rUSdx+4lEM=;
	b=pm3WGbOD54k5FHN+V39bHK0wLfoBxfQ6V82OrZj1TTHMMU1t9JrcOtUOMQxEjJZMTAzcBy
	0/F3Vnm7W2rWGjlns5YmVy7VHVc50NRr1WlZTRIkQJ+8mktfq+9ad0JhNSsm40OzV7gjmW
	S9wmNFNsLWV9S/ZqQseCd5OQC0K7xbQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784602389;
	b=7wesxMLtHfdrYuhWNAI4OaJ2cvUgPyuoN5BZWocc76gZ5zCCHyxQXrq5cos2X1eB1UMpOU
	wAY8NK2X9IXoEUn2ZTk2BSpHTqxpb4Ew6EQ7jEVfBPtN7zk2UTcFCx+x2ZgHXXl2Wf4PZH
	5RF9oDiKUqjoB++4xGd/NfnARiInwSk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XEHybAo+;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 75A7F60A88;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23057C2BCFF;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784602389;
	bh=kSh9BQgS5QmHyKYjO89WZ2+3iTBXW5J+wxxG9vDVAJE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XEHybAo+2kZNVVGNyUv5FLdCH48YFNU3aR9zcL663YF8cgoDm5tEZG8C6kZrrD9ZQ
	 pUEKKPPhBB7T6MqJfWl8D1DxrKjorfKgwda1tcObkLEIva/ABl+y2OTShLxOpWAUfb
	 QGduIUi/81ESq7KJdMoxhAiAHjQNOB0vy63QE/d3RLQf52zMHPqaeVLUSCIrxY8MWQ
	 dda5HhbojUX3i6VuawQDBg8/VAFZfiNWnUISIbCVxcOkhCyA/wA09bHEvklUdRiWL1
	 2w8kogzEW4PrGK1QROYUWNaocIGPYtbMtZS3DnV3h1H2Tc2VCrX22TRJsV3ZO2u6oe
	 SKlAsthmOF/vg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF6AC44533;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 20 Jul 2026 17:25:08 -0700
Subject: [PATCH v3 05/13] mm: hugetlb: Fix subpool usage leak on allocation
 failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hugetlb-alloc-failure-fixes-v3-5-7d2a169aa9ee@google.com>
References: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
In-Reply-To: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784602387; l=2183;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=TxFD58wSA2jJAufxG4ptcnmkIwsdZTWOv5gzU++/HSs=;
 b=Cuw9IMu+njvxpvmnRk8QFmkwsKKjZPzSykOuLnRokUuqa3Z2CbGxGweoxUKCN7Lg7QoL0WSrH
 bxvolGurs8gCNt/+T6VZcrW5RuSxaR+OKnxfVIbStbxrn7DKeQ8rJkq
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EF71620006
X-Stat-Signature: n9cwy9t8h4iof9frs4wan6kymkatnd7k
X-Rspam-User: 
X-HE-Tag: 1784602389-15956
X-HE-Meta: U2FsdGVkX1/x+I7INCgow/Ra9XHZtT5QlL8zNEf+ub2pGVTEux9JUUQLf2vcj7P9tP5he2fyM0YtRxzbZQyzCFJzs16pmyHtBTLJgPEJvcPRtUFTGKT6zmqBGfW7WVf+6mvME51yw+PC2fMl0qBhyASvuIirvXJ6dWsYL1u434cIAIGPBbhH9Z/+fiLapGEJCLPVsfLRSL0DfLT/3ay6lqSoTrX3QasZCkVVEuNO/LF73MEoRbLjCSMqZUFk6xutTdiCFUcH3cOrgm1xd2ZyMI0TmZx0nU/2fO2HS1KCc6KxWvVhqNUsnqzcuLY3cJNJI+/WN75U2l5co9E50BKRLKLkzJ34sV6FE0JaPN5A19wIbHPMAnftGQBAn61SWz5T5apAdGeie3FJ+qG9h0KC2U09C+LsznX2UddQ+3UNFAEjLmmoCXcEOd9FQl2zM4o0pl7ZzrAfPjyi1zq63poknqgw7cJcqSw6DBYeZUlOrm2ExPw01jgTdPizG0ufMER2PiKzlXCiSNz6F9XXghuu4ig5FFP+QTKzlVhGFG4BgZH0p3zGDWElpo0ApioQTacgOawQpwrz2qxTPsHF+BsVuRIA5YfSdENg1RA9b0YKP3x4jGXpWtmtEQeq9DM3KVhzZmLFrbYi2417sZv0azPvbDhiFZ8UoDfO0ppRzDBenAKz+Rzp3xGAeJGErYH6lkV7kuPwspdFj228FW+4aEIJpeKqq2HKOd8GFiPNG+ljKplN5t6z2nJCOnOc9xvwNukvICIj+f5n5XRXzRHOjrng7fAq1rpHf+RiMCvLLrXy79iBDSyC9xAgxqkeNXbgLQ0mXGi4nsSRf8dkg2qpbKS7iBUEoK++r4s+LMC/cwF65meA+50IZ1ZYPGRW5/0tuxig6PU8ZnjKkMyghn23s3folD8QgYANFM25HHNB3rC2D2UlkDomMlHk3k39oWCfNl7VwAms+LJ9Q+c5kaYEIYX
 7F5kXe4Y
 ZdproWXcWM27olNeIath6v4c8BfC4cy6FHkjWy9bQ+Q/Nd8H4LYq0bZEyoDn9ojS9PTUKdvMA02AJWsOhLN4LiiTvJxh9keDU3mGfXLlBnFJr7YO5z3MTghQxYN/2al7WR2IxXpBWTud+9QrZOqeZR3QD//WWUxDTwV7PRGZJBT855fTBUoWhBk1H8qm2NqUk6wI6ag0g3j6ULTQA/CJSWEP3mqdCmfXzr8gtj+z+LqtrQtt3mdwrX93wBneM0w8/fRf6lqTPTPoYqxNoOjFoN9gPX8jy6sBNmd7Ytwx1Gtw6/YVqw6WKwMhMxmy03mC14M5VRTR12IDqjukD/+chcSWAE5/miG9GNh6f2SXIIdygzjHbAZmKBCRIiwYzjtmu0hlWLWA+JT7mZQFfR8IvSH8vcX8PGbVRR4SZ3DWGMjUxMum2RPfq+55RNe0rfHB7m+1KhhuPmeM/1c4loUE0kFaEQjwh+yj4e5GK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When alloc_hugetlb_folio() fails early (e.g. buddy allocation failure or
hugetlb cgroup charging failure) and gbl_chg == 1 (meaning a reservation
was not used, but a global page was allocated instead), the subpool page
acquired via hugepage_subpool_get_pages() must still be returned.

Currently, the error path out_subpool_put: only calls
hugepage_subpool_put_pages() if !gbl_chg is true. If gbl_chg is 1, it
skips it, permanently leaking the subpool's used_hpages counter.

With the earlier patch to always track used_hpages in the subpool, always
call hugepage_subpool_put_pages() if map_chg is true to consistently
restore the page to the subpool. Only call hugetlb_acct_memory() to adjust
global reservations if gbl_chg == 0 since gbl_chg == 0 indicates a
subpool (and global) reservation was used.

Fixes: a833a693a490e ("mm: hugetlb: fix incorrect fallback for subpool")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 061d7250c202d..3f6189d2d0188 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2859,7 +2859,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct folio *folio;
-	long retval, gbl_chg, gbl_reserve;
+	long retval, gbl_chg;
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
@@ -3009,13 +3009,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
 						    h_cg_rsvd);
 out_subpool_put:
-	/*
-	 * put page to subpool iff the quota of subpool's rsv_hpages is used
-	 * during hugepage_subpool_get_pages.
-	 */
-	if (map_chg && !gbl_chg) {
-		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
-		hugetlb_acct_memory(h, -gbl_reserve);
+	if (map_chg) {
+		long gbl_reserve = hugepage_subpool_put_pages(spool, 1);
+
+		if (!gbl_chg)
+			hugetlb_acct_memory(h, -gbl_reserve);
 	}
 
 

-- 
2.55.0.229.g6434b31f56-goog



