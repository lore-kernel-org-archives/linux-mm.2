Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57BD9C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 05:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70B596B0096; Mon, 20 Jul 2026 01:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E33E6B0098; Mon, 20 Jul 2026 01:08:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F93A6B0099; Mon, 20 Jul 2026 01:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CD566B0096
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 01:08:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C134E1C0A5E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:08:21 +0000 (UTC)
X-FDA: 85007974002.13.C07C187
Received: from outbound.qs.icloud.com (qs-2006j-snip4-6.eps.apple.com [57.103.85.227])
	by imf16.hostedemail.com (Postfix) with ESMTP id C92DC180005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:08:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=HdTIZPLJ;
	spf=pass (imf16.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.85.227 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784524099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oxorjIprI4mpAO6TiEZUTmw1D9wu+4GV0+L2FBilTss=;
	b=xZjlnJvazfa6xZbE6nfUfaECl3m82cHfYBpBMMaH6B90opGdojjNMqlNPPX7NykauaELtw
	7TiFxZHhSvP4J8AJQxqQchs/QJA74DaevevVj54ocwuEC2BMufXb6iI9ZNpw1sR3MZ0BTK
	as0CM8jRl6Zs8IYAdy0/fbEW75hIk8s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784524099;
	b=BJoU99KLvU8L5r5OO5QZcFU0kade0z+7m+eHFba/AmI0CROokipR1fbGGItjPKvCp1E7zO
	AtXPf7hImQd8ZWS8pFLJgXkuPUUb+6e7mxyAd0gco/u7c+y8VzznPqw85ptw633JK3xU/T
	ZqKMhRTCxPgquCXN6bynOXIoebdZwOQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=HdTIZPLJ;
	spf=pass (imf16.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.85.227 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-7 (Postfix) with ESMTPS id 89436180013A;
	Mon, 20 Jul 2026 05:08:16 +0000 (UTC)
X-ICL-RepId: 019f7dec-c3da-751e-9eb6-011f49e09339
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhMHVwGXRxCCkEdXgBLVxQEAlodRw5AHVYWWAhOK1sTVRdGCRkIXR0ZHldQXgheH0wcHQ5YBhICWkUBXRcDVxxWRVwYQwldBVccHRxERVsTVRdGCRkIXR0ZCEcfCjADQg5WA0MHRQAtGRxXUF4IXh9MHB0OWAYSHVAcDlEFWwBGCU8BXRoJUwRaEB4ZWwkfFlUNQAUaHQddDVVXDw5fAREJHAMJAQlyGVoUXBhTRVEfVEYTGU4bV01QG18CQg8=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1784524099; x=1787116099; bh=oxorjIprI4mpAO6TiEZUTmw1D9wu+4GV0+L2FBilTss=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=HdTIZPLJfpgSLxqnWXwavTqKBbqneLmo5rYK9L4QUqrDsCOwqDFpGMKBM8By1mBAlgHm2uGgChRFQI6Cecf+5sd+K+HSMq+cEi76FuLZmJqOwHTAY3VZLVjykJl40gkgDsdwyrcnJxWLLk2OblSUWJC+dt1mdkxD8nZZ7kfza5rPAqRQAxWenSspL/d0Mwm+SZNOfvD9CPHjV1BerWWegs0B+UXWGzy7AzoRACohH850NPYFeBZlyj/8bO15C2WUWpZKDFlbNW0hFvqhHYOiWkMPwyj+unnY2IcLaA4Pi63Dibq7juxpKVrKZwC8mGI0eF2vb3twRnz2pCHjQNtHRw==
Received: from [21.6.122.162] (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-7 (Postfix) with ESMTPSA id 04C041800142;
	Mon, 20 Jul 2026 05:08:09 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Mon, 20 Jul 2026 13:07:41 +0800
Subject: [PATCH v5 4/5] mm/vmscan: extract folio unmap logic into
 folio_try_unmap()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-batch-tlb-flush-v5-4-db943a0d0d6b@icloud.com>
References: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com>
In-Reply-To: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
 Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784524064; l=3675;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=1wbXcA3EwOgkLmlnWmmIkzMkHOobeEr8JUOUrutpQDg=;
 b=A0Ybc/7n8H9VBZRr6lMHF+lordRq5fKgCvcJzGPaTIFmdjV7Kt2djrb+R+w34345x0tJId+O5
 eDmYa8PgD6BClRepn7xUiQO66idzQllacf+nVS/AVw6vzDFHQqcY6EG
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA1NCBTYWx0ZWRfXwY1/FyH0WiBA
 k74iNQLescyWi2rEr4XWd/WubxdgqWEAtqPeXf9mLvJ1yT+6zVSHltWjIKLTa7iZSlcC14ZVoOY
 0REYlT5ADNfuDHM9YeoHw08cSyWKT4FCSZvtdnb3cClwYjle5EquaQPSNYPvxvPlCK/ie1F0RGW
 486IL/k682lPvsZlnMa60/FqUoLCK8ZLRAN0Ne8ZHpjGooo0EUtYKhHAkCXiWSuJQnZtds/M+QY
 JkURkqkl6zea6miskrgrFQC6vGjt2rc9gYbsDeUJZWJYq2O3cjNNTZGsKAgvkUx5sPRq7vGd7Ta
 KgA06dJZpNwiGxjSK4O
X-Proofpoint-GUID: GG3EJULa8lsx5m573CbJU4TMSUiB9zCl
X-Proofpoint-ORIG-GUID: GG3EJULa8lsx5m573CbJU4TMSUiB9zCl
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C92DC180005
X-Stat-Signature: hpo93fiaqroqoyofzqhswwezg5pnfy1b
X-HE-Tag: 1784524099-136589
X-HE-Meta: U2FsdGVkX18WkVOhAS/b3e4RQjWtUEwabkg4em2A4NZWu9drtSpy/BP54Wufrjkv9W2/eMw6zFNnszDkpFIgWOULBY4oa7UvbjJOZKftYqfvxkqcr8c7y0zz397fZRr/6bk9W5ytda9n1pl00MkJzErGsxJqGcNC9q6HsNAwqXIzrZ3N9tE07O+1Lh88LPkq84Yf+3q3skAfnTuFdPq2Bhwx8GoFFU2Ue5cHOB5Vnz+CtQ2iIdCTnN2wcuYJ61gl3vnCZWMcJSCZxR3HcFA8W7W7wYAgZLPYA3nOpAE1YK5bJAVvwbZO81ZAnq0WoglvlZG8qW4zvHEQZlPVCfNskD/R8QvWXvGEk5VlA2tkGvJKTAyJfz0xv/E2c2E7Y4Ctacyes2tz+5XnLk/JJLI09qMCmvHAMqmUmhyi5ySMVlG3VoqNbMW/MA2uOavJwWPt7kVMkH02E7EBXJC6xpv0BKjcceDWuB2k7XXNJ01Bkd5d2S4U/i2TqcclaS7Y/GMYTVFCknUs3FFFkVxOoHdzBJktB4oozoUb9z0EIhqpgw46lHlhnzqWWy/txPiAaGLFq8kYlsL569ut8iWqnTG5+3rRFVVE16VU02Rg6ZxnOAoVdd4U9f7bc75lsK6PEs76hCm772dwQeyBGfeLMukD/Vlqkdzj+vzmrkUSVukjk4ZahaFFHbO/r2R9Rk58JZmSkh6JSxe0uqk/Zsa8KmId6SdwbOf8QkAdx41+oQDZVdBt3E2kqcDDSymlsQYr9oUIXO+cWv71WUGkIfept2kM72oPjqzobGxIqa/LXxHxU1925yXdTU/c18LUcNAfIW01LVYey7/SbLDypSve2+QzHnSjWCRskqYyT55/PXm4QGgBawBb1UZOnPPHJJTCe7w8yz14JF7MMM1/Prx4ZRl8oQNMiLvAhP/Hm3CK9bKLu2VUDJ3k6cRm201q81AoPWCsOjaggLdoqCiG1Zbf4a7
 3odHF8MR
 TlqW0lCizpmw0CbmF+SJ7WSb6kYbJQ9rrfVecocdFKbKgZWCfd/auyxscnNWaEI4Ng0oETxHythUOC77Ruh9Ew3AGCfq9hd/3UwRjrEwz6CZdKDMltn4UWx9Lfgz2kWgpNjVfxHf2hDiiExUE2dgVq5p0O3dgbkIhkkMUssCBYK8Jywb1A7RkFRjAYfcZeq2xHTcHc2YouoIvSRr+Zj90RAVmGTLAaATGkhZUOKD8omKGPk3yza9qZZEMtP89uEldRUQ3gyVmRa6kaTswIpOj8JWXHHrUNJmIQcHAhlHblHX8VL9yhH+YKzDjPgkTCV03mGLPPyD0HhidIhoD++wvkUzZ6OUVo8v2CMibZfRRojV/uBT/p+QG9yYOvHbRndxQo8ib3BUt/iktFWlQLppfWPuvWn9c9MYLutNCitHjuHL06DI2zeESPGXO0n3EM7xvimal
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
 mm/vmscan.c | 65 +++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3e18948e90d1..bb479ead1ee0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1220,6 +1220,38 @@ static bool folio_try_pageout(struct folio *folio,
 	return false;
 }
 
+static bool folio_try_unmap(struct folio *folio, struct reclaim_stat *stat,
+		unsigned int nr_pages)
+{
+	enum ttu_flags flags = TTU_BATCH_FLUSH;
+	const bool was_swapbacked = folio_test_swapbacked(folio);
+
+	if (folio_test_pmd_mappable(folio))
+		flags |= TTU_SPLIT_HUGE_PMD;
+	/*
+	 * Without TTU_SYNC, try_to_unmap will only begin to hold PTL
+	 * from the first present PTE within a large folio. Some
+	 * initial PTEs might be skipped due to races with parallel
+	 * PTE writes in which PTEs can be cleared temporarily before
+	 * being written new present values. This will lead to a large
+	 * folio is still mapped while some subpages have been
+	 * partially unmapped after try_to_unmap; TTU_SYNC helps
+	 * try_to_unmap acquire PTL from the first PTE, eliminating the
+	 * influence of temporary PTE values.
+	 */
+	if (folio_test_large(folio))
+		flags |= TTU_SYNC;
+
+	try_to_unmap(folio, flags);
+	if (folio_mapped(folio)) {
+		stat->nr_unmap_fail += nr_pages;
+		if (!was_swapbacked && folio_test_swapbacked(folio))
+			stat->nr_lazyfree_fail += nr_pages;
+		return false;
+	}
+	return true;
+}
+
 /*
  * Reclaimed folios are counted in the return value.
  */
@@ -1494,36 +1526,9 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
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


