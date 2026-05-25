Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBF71CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 14:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2DD56B0096; Mon, 25 May 2026 10:58:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E03506B0098; Mon, 25 May 2026 10:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCB356B0099; Mon, 25 May 2026 10:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B69AC6B0096
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:58:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 824C38B05C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:58:04 +0000 (UTC)
X-FDA: 84806247288.17.729356E
Received: from outbound.pv.icloud.com (pv-2002i-snip4-1.eps.apple.com [57.103.64.132])
	by imf28.hostedemail.com (Postfix) with ESMTP id 82E6CC0002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:58:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=AcqvTFCi;
	spf=pass (imf28.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.64.132 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779721082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=44yuq/wuzHQyeR1qrNWG3c1aoPjDydahfdtIBLgV6K0=;
	b=Vb/PhP+NcIWtaTsF7O+x3Z7+KpsDuhEkqJznZ0VpZ6ukd/Ld/IGhl52Djikx4EyvcN+PX+
	kvzqCdKIdIPXtL9Pm7ykr3ysTu7uHrzKa5H93KmRgUbRnargZ5VixjbnYfS+uN3vD7PzCg
	dP1FrS2qOZo08okX9EzGDGDkbyjyn9E=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=AcqvTFCi;
	spf=pass (imf28.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.64.132 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779721082; a=rsa-sha256;
	cv=none;
	b=8FSivqcNSUBj3WegpnbEZxtSR3zUn1QiyhOoVnGybYS9gBxTYCzZovMCRCu1/VG7c4RtQK
	4/z89tmxLkySGHLmHC6hbwV3+ls3jD2+qlBJn92xrulPZf7Z7tDx+p254/gj/mJTuaQhDm
	/QC1jC7BaYWoAGcRxtK5JcvzaPuD7Q4=
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-11 (Postfix) with ESMTPS id 4B99618000CA;
	Mon, 25 May 2026 14:57:56 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhMHV8FRQNBF0kFWBcOVk1DEUMdUhlfH1cTVhR3AlEcVg1XQ1QEX1BfHA4EVAddBV1WUAJaS0ATBEoDTV8OXh8EF0YZVQRHHl1WQxsZAlEcVg1XQ1QEX1BJDEFQbFoARxdIHV0ZWW9QXRwOBFQHXQVdVlACWktfGV1FD18HWQRADEoGQFUKRhNRVUcBVUZUHEwLW0BBXx9EFEAAWg9SVkZYGlBdBytbE1UXRgkZCF0dB1hHFEcODxlaFFwYUw==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1779721081; x=1782313081; bh=44yuq/wuzHQyeR1qrNWG3c1aoPjDydahfdtIBLgV6K0=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=AcqvTFCi4RwdLMbQVXoXo7fxFim0i48H4zO0ujJqNM2CsOWaoZDMBB6+PPcxWQO8YeAZEaYLDjPk6I7LmW22vsGJ3DebtqgghVkfpBBUWS1oW97rZQduOzJwNJHza9YRpcamrKvxn7PaSRjN8sSKuCCkDeieb98ZlbtgAvhMQpwam6LG7gJUXYxi5c1ZpFayspy7DoLKYom0EuQIKqBMvioM+KlEfx12+lPIbj2vkLCMcY0UUOFi7ccpicZX6kP3FMqpBbxXQ6M6r0SXnozTpt5JyVyPKAyS7KYRi5any914FNIs7d9nqTH73F3YOEAmEAdVh44w/Ky3aJ/M+vbdxw==
Received: from [21.6.122.162] (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-11 (Postfix) with ESMTPSA id 3898218000B1;
	Mon, 25 May 2026 14:57:49 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Mon, 25 May 2026 22:57:20 +0800
Subject: [PATCH v4 4/5] mm/vmscan: extract folio unmap logic into
 folio_try_unmap()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260525-batch-tlb-flush-v4-4-83789d6abc00@icloud.com>
References: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
In-Reply-To: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779721049; l=3701;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=9uk3LS+tzE9ezvquZlv0cIiXReVHWUTgs5lv55QvXHQ=;
 b=DAi8J/M4yWtspca16GxLFVZqd0brWJgHWGdZx4/pALgJ4+AiYI7i52SaGQCt0J5C0rdSp+L73
 pzrFgyuoE31DTB5si0WXUXiyLF+y3NoS6jUW0qiTHBpkg2pfcgeml1L
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-GUID: wGvB_WRPB1zvlL9m_0EKbp0KOah48qvF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI1MDE1MyBTYWx0ZWRfX1SEJVbjACY+i
 6D/Yrx5mWnD5vABx0L09n2vG40fqWbla9joKWtzsQsBLnzydYyOjtSBI2w1wf8ioJs1NXwYPV6u
 ZVm5+fEBfcHBKRwxEy8FfqwMQ8nTWhV0ziGeFkGNLveabiHDPpqHR7pDkqn8/4eAKsXqdt7RXwE
 5o1UJ8duXWdHkMckPpp7YT882AqRlhDw/m1zP9Hnl1rc+YH1FjO+xkV00DwMcC7tR3dtp8jPuzE
 V7I23QXDypflToj4K9i9/itNAxWNfrwaMf1zBRefPMLqt04bdgeRVbBxGSCngrfGPqmrijdcOOd
 JGFoTrQMpFcTm5B6ITuMN2sUqax8hxz64FQgtuwXe/rTlGKOvTwyGLtBmI7q0I=
X-Authority-Info-Out: v=2.4 cv=EavFgfmC c=1 sm=1 tr=0 ts=6a146377
 cx=c_apl:c_pps:t_out a=azHRBMxVc17uSn+fyuI/eg==:117
 a=azHRBMxVc17uSn+fyuI/eg==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=oO7xqvO4U2nGjC6lxGQA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=R6HnoDE5lksTgPyyjrIf:22
X-Proofpoint-ORIG-GUID: wGvB_WRPB1zvlL9m_0EKbp0KOah48qvF
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 82E6CC0002
X-Stat-Signature: yuegsymoh47nmrsse8545o3zr4y3nuc8
X-HE-Tag: 1779721082-755559
X-HE-Meta: U2FsdGVkX1/Jn/mn4yd5zb7PKAy4DfxNIkpSNytcwR5WpDZWHBOxiC+2AsvcbpH8RoRrTnklbFuMTDKQqs7uZKGR0TOUehPBUG7Kitu9XL/ZMK4dM1Hs/XIyVy+UncUvCSpfsxx6GdxeeIB9hS56juiMV0Jsol1THhUOO2vEs4GN0sUXyRd5Re+WdujF/7n3oBBcHcjLtqauPza3WsZJFvWpcsbQ7ArvlK32HWUD/RE/bzyVa/ECfJFBTJ1HbsFf8civuNXs9lY5u9TEPOF+rOaqZ00e3wJzA7NPm7yT8xxoo+QtB6rsbN55vXwpeH3DSvY1uAnMvX2gj2ZdFperCLr24acSo0jWTovu+2arqWecF973mKURdc8v1iX7X21/1lBubZsx/jdvgz1e7/jbsBRgh4DEJ+gr/qngxQEN79C384L5ooN9oD4NAJqZbWJMwUIq6wJ+NE3QnfeBkyr9YAjxELiTGphlU8HYu/vhYjmMUfVTdlHao6ZuoYr2M3pKIulo91w/3No1X+NpK145rjCmkM7bkwBp8rpFxI1ESG+IAN6ikA4vx3UEjNzKKLz40agd/eA3Reek3TNF7mESG8CM0aQGpzTTelxo5T913vPHGSgb63qgiTS8Jj9XqnDzGVS03aDrE8zSkovdArioMLgC8ZKIStjZJOVEHJZzOpP0kCf6Zj+J6WBKs2pCnjd6N3GvfSpwsx6/DxlodTaS6qih1W0GD4QXshgKGOBUIG2AK9557EgOQyRKEfd1yU/t5T5oqS8iYVLlyAxzA7Xri1of8BItwMmklzBPe1XRIJWQRHRFs38T0S7IjGSgBCaGS1QJnK4WXNvZDnqfrB+4Ob0Go4U2QMXBjlStX8XIKB1F+F3ampjxyqDO2AUdtlSHBi+J9QQL7iDBGpnsrL/YgdaGxKZBy6NIOyZBzL+XiY2ciL0NUEI7f+aeUQ+OtrKmrMmxv7B8ZvXENxEgJW1
 u9ojaKsj
 oPitAYsD/l5kg0HpmgEvt3ZuTN/Oaq1xGqXOC17noimIIRx2GILMCBbLldeFERoRmKAV4TRCc4RgnOG76QtkV34UNFaMd32rRC5BW9AFjVlBOLkJ5UiGAYz1kNjST0KZJZ0bmofikje3SAStLnIRjY6pRXXVglwCc0a+ON1Tn7VWnoOQGOxVmClyBLdQjmsoUgQBYTPO7/qx3QIEUkAvBsUAG5yfl2S4AVBQykpRarWl6CbO6WdY/RVzqdMBYbJMyX22Aw629E0MJ/uHjOvmEOeWrdVy82+co+g5r6Wx0kdPAO0idMBfpWfB+hW/gQ9wiu41hMTmGJPg/1V4nGdzycBWtqrK1Xi00dSRE/lmNl2dAI5aDd7XYXXrOKPFQUuDAZH0w3woQGqtw1CinergcPJ/qsGLypkB6YNrm/iWrWkamsnuvp81bBc7T/2vcDt2YRajxU9RcOtXkleV9JPgkh+mBxk2knEjHAmWapwrCGNGieulW5AtLM9e7KTPvIFnapcVRDCfnaNG7tM2lp+wM0HQVtAiLB54xjsT0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shrink_folio_list() contains a self-contained block that sets up
TTU flags and calls try_to_unmap(), accounting for failures via
reclaim_stat. Extract it into folio_try_unmap() to reduce the size
of shrink_folio_list() and make the unmap step independently readable.

folio_try_unmap() is only called when the folio is actually mapped;
the !folio_mapped() check stays in the caller, keeping the function's
semantics clear: it tries to unmap a mapped folio and returns whether
the unmap succeeded.

No functional change.

Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 68 ++++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 456d38eb172c..abf3a2878456 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1221,6 +1221,41 @@ static bool pageout_one(struct folio *folio,
 	return false;
 }
 
+static bool folio_try_unmap(struct folio *folio, struct reclaim_stat *stat,
+			    unsigned int nr_pages)
+{
+	enum ttu_flags flags = TTU_BATCH_FLUSH;
+	bool was_swapbacked;
+
+	was_swapbacked = folio_test_swapbacked(folio);
+	if (folio_test_pmd_mappable(folio))
+		flags |= TTU_SPLIT_HUGE_PMD;
+	/*
+	 * Without TTU_SYNC, try_to_unmap will only begin to
+	 * hold PTL from the first present PTE within a large
+	 * folio. Some initial PTEs might be skipped due to
+	 * races with parallel PTE writes in which PTEs can be
+	 * cleared temporarily before being written new present
+	 * values. This will lead to a large folio is still
+	 * mapped while some subpages have been partially
+	 * unmapped after try_to_unmap; TTU_SYNC helps
+	 * try_to_unmap acquire PTL from the first PTE,
+	 * eliminating the influence of temporary PTE values.
+	 */
+	if (folio_test_large(folio))
+		flags |= TTU_SYNC;
+
+	try_to_unmap(folio, flags);
+	if (folio_mapped(folio)) {
+		stat->nr_unmap_fail += nr_pages;
+		if (!was_swapbacked &&
+		    folio_test_swapbacked(folio))
+			stat->nr_lazyfree_fail += nr_pages;
+		return false;
+	}
+	return true;
+}
+
 /*
  * Reclaimed folios are counted in the return value.
  */
@@ -1495,36 +1530,9 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 * The folio is mapped into the page tables of one or more
 		 * processes. Try to unmap it here.
 		 */
-		if (folio_mapped(folio)) {
-			enum ttu_flags flags = TTU_BATCH_FLUSH;
-			bool was_swapbacked = folio_test_swapbacked(folio);
-
-			if (folio_test_pmd_mappable(folio))
-				flags |= TTU_SPLIT_HUGE_PMD;
-			/*
-			 * Without TTU_SYNC, try_to_unmap will only begin to
-			 * hold PTL from the first present PTE within a large
-			 * folio. Some initial PTEs might be skipped due to
-			 * races with parallel PTE writes in which PTEs can be
-			 * cleared temporarily before being written new present
-			 * values. This will lead to a large folio is still
-			 * mapped while some subpages have been partially
-			 * unmapped after try_to_unmap; TTU_SYNC helps
-			 * try_to_unmap acquire PTL from the first PTE,
-			 * eliminating the influence of temporary PTE values.
-			 */
-			if (folio_test_large(folio))
-				flags |= TTU_SYNC;
-
-			try_to_unmap(folio, flags);
-			if (folio_mapped(folio)) {
-				stat->nr_unmap_fail += nr_pages;
-				if (!was_swapbacked &&
-				    folio_test_swapbacked(folio))
-					stat->nr_lazyfree_fail += nr_pages;
-				goto activate_locked;
-			}
-		}
+		if (folio_mapped(folio) &&
+		    !folio_try_unmap(folio, stat, nr_pages))
+			goto activate_locked;
 
 		/*
 		 * Folio is unmapped now so it cannot be newly pinned anymore.

-- 
2.43.7


