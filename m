Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CA96C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53CD96B00A4; Mon, 14 Sep 2026 13:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49E046B00A6; Mon, 14 Sep 2026 13:16:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38DE36B00AA; Mon, 14 Sep 2026 13:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F1DD6B00A3
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:16:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91E961401F6
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:16:00 +0000 (UTC)
X-FDA: 85213020480.16.A21C56A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9E994140005
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i5PMS+LQ;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406158;
	b=1czkVmI8q+jX88kXpZ/GVfDFu0UFzQKLlWkNWRSZhlXTXVr0HiPTv2YjYySAKH/sPMVLnN
	E9jlrbKr/1LO61VnAYSVqm69KobkpsGvTyyQsI26x14hm90O5IgaCC9r4Ma/3yduwsNtt8
	koa4oPKCGydk/rDe0Iqvq9803bR0O2o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i5PMS+LQ;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406158;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Haob9zftt7bYbVolhyk3YHKUp2Zn7O0kTspfkoiupV8=;
	b=UiXi3yhlVhMR4wvn3dVqhDKMD2tAdQrgL8qNEO6A0qB3olzef29g81B1jFc8ufnLpcEuA3
	1W9BJAMaJuFM4UvkP1annPIjta6DsG5R/ql0a0Ll8oraCK14WlA1/FJ+uBKcl+Xm3ulseY
	9moPp5c6m4P/Xx5CjU+mZdND1W5qjmQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 10DBB43F48;
	Mon, 14 Sep 2026 17:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3D05C2BCF6;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789406154;
	bh=PMQHdaDFoVPlbnLKjoEylgmD0i2JbGkUP9Bs0ajFI4A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=i5PMS+LQdPKMa7GdFCsBTZ+eDdgBjSyGmtc5IuwEKG5bM/XKq4UXTr0CZ3LHC7hbK
	 2U0rb+HlB0EOZU7XjaM5OaNDWU2ITdreL4YUXux2/smP3NC5xX0W8o4a/3mJFYmbWt
	 lFwzAH/Pn6de5PWBLGjcYC3QTHmpxGa2SCxzLT4xP39YzVs5KH/zz23jzW6t4cAiN2
	 Wpb24nkyOVyNuythvO07znEO7+wXNaBLbueLNv1MSYV3lRvOJZvsEHkSOetCGPsRHa
	 9AXOqx7roRWyxNPJ/ZUR/3rYn0++A6lOXEx4nR8089Z8ZHJfmNKjHNfpuh5BGJYNE1
	 eVnlz+bqO1DEQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF5CCC88E72;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 15 Sep 2026 01:14:56 +0800
Subject: [PATCH v5 15/17] mm/huge_memory: clean up after-split folio
 freeing in __folio_split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-swap-thp-cleanup-v5-15-39878b37dfb0@tencent.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
In-Reply-To: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789406149; l=2611;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=dr8cj1MiZNdjCIP4W8Q7fhdNiHKYjsEUhKzB6ydXT6A=;
 b=Xmzz9Kz4mcajOdOHBr/KOP30VBbagZLlKdmPpj1V3hiPN6YbK46VnS2GemrEGwca+qd9ckI8+
 cnvl8ltJvEGCPA7vEQYOPW6gb4nkcPgpoNnetICCN89PCjSkaQYR2uW
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9E994140005
X-Stat-Signature: u3dnuugww8m485x39qn1toy1qr5ob5gx
X-HE-Tag: 1789406158-100968
X-HE-Meta: U2FsdGVkX1/jHOwzwKI0Y7OUmKl5D2Riy+BX1FzS4OshghcOkxIyNKpSqf/yQrIUwHLCt6o7OJHLa5vQx6oOnElUud+pvOCc4JF12HgY94AY6psOB/uesE32MA1u/aHyJsLTXV6RxmIpkGMF9EODVgh+p6nuyAB1z509CjTSSGks25tAp7MmFqGI2uSaitUOPJpGtBZTWb8qd3LS/tCzAYc51jtalkwCNT1jjAoUq5oU/ig1b8i9NqUPp9rc5I7edfdKmsHsCrSd6MKadl+rnWv3HhPqc5mtZ1opplDAJTUS1WcdLTUEQ2Rp9+u07lhGjbAm/aQeOSztFAE9yVrsQTIAPM+H/rCV0+1Np11inFc1I8ey9/TFz9YHrUbFnXRD5FAYC1ghLOxFkX54v3ODNHCbfLhWxYlIQYkPxP77jMfcu+Y+b+xDRSmZTo9riPOjsG1C6wJU2NE33JByEihKC6By2dWVT+Z8YCx6cOuL4c3NJpvg6CQOg0X+B9jbsr2MOKvivtToMx17tnzDo1uqjNORqVQrcfYNeea5dO8WR7fEXZVAzp5NNF3KS/G8VmFZTYNv3YjFT+MMH3TFymcW/1H1nhzRKR4y9Nmf8ohGGVPuJ2vBYbYSzf2HhjBzJS+HqSSRxHqhzKh+3hlm0S063t8OHw35CNYLsqC4uPfBYZF/8MCm0EAJyt6zH+yaHBRTC7/4phurhD+vT/pLEke9BCDRXjCNORHBdVe9Q6Nl/e6HBql20BSXk8jPb6llgmo+f/WFrMTz1Ub/Ue50c/hGer7DO+znwqYApbRKS0EOgcblG8M/wbUgDco8GR4ansVbmNBcRnRZzvOhAQjGmZ3HlelYrjQ3ntB5FsqFPtovccmUNheJdPyFd1urGmFLXcK+lIhDCNdkekfjeJ1Q9iKJxY9UIMf+cRxu8334jz30ZpCPUuojzwlcEa8Kk2gjJx35uHNKnEzoepaurRFgkUt
 5V0cbwRY
 N0dKaIYffZJoZ2/hgMWoQjmIknG9mjAnoVIwXwVjtLXszUSnoqsXCeCSRMVxqm+CdN6yGEur7LPkauSPR7/tCVjZNgr1YKmXswCOQJhKQQCN8wJt0dD1XoNHy6GepUGmypioF8AJMFxh2g/59TgjTYDXPaCDaauPbzJDZVyXryAdCrc/v4/06leLqPP+E+06vTx88vCjSTxReRieEmfzmwFpTcfDJizM0w1P6F1jLdASq6i8XN4bLXN/SGRxmMhttUoDnJVEUo2e7uMuyvkBU8khf5UuyCEpmr0VfPWuuxmsSJZE/HUIngIA87accb2oWZxO/3k+jKzET+CQHKfg2W0fhT1fs6Q7n1drH+BZ8MzsgIJKpMWy7mA+jrEefu4VbWY5wa3Xrm6tH8XqJEHCTtf0Qc+nYeyJxZeRYNSJvfKQO5d3swRH4Efd5DWx0znNTLmexFm0PL+KqNuJ1KIiTT762/vpwMho5N6E5nsVmMw7V5M3iGA0pg9bfCW/0XbuY03murFsLQKAQBC2AEjMJXFHNWWqyNtYh1m88Sw8rLkvuoo2ionR22zHzVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Replace free_folio_and_swap_cache() with an explicit folio_free_swap()
and folio_put() in the after-split loop.  free_folio_and_swap_cache()
must trylock it again and re-check folio_mapped() before freeing the
swap cache entries. If the trylock loses a race, the entries are left
behind even though the folio reference is dropped.

The sub folios are still locked here, so just directly call
folio_free_swap() under the lock if it's unmapped, then unlock and
drop the reference.  This makes the swap cache freeing deterministic
and the reference drop explicit.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b134acfe1542..ea8bcace028d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4327,7 +4327,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
-	bool is_anon = folio_test_anon(folio);
+	const bool is_anon = folio_test_anon(folio);
+	const bool is_swapcache = folio_test_swapcache(folio);
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int ret;
@@ -4367,14 +4368,16 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		if (new_folio == page_folio(lock_at))
 			continue;
 
-		folio_unlock(new_folio);
 		/*
 		 * Subpages whose mapping has been zapped may be freed
 		 * earlier, but freeing them requires taking the
-		 * lru_lock, so we defer put_page() on tail pages until
+		 * lru_lock, so we defer folio_put() on tail pages until
 		 * after the split completes.
 		 */
-		free_folio_and_swap_cache(new_folio);
+		if (is_swapcache && !folio_mapped(new_folio))
+			folio_free_swap(new_folio);
+		folio_unlock(new_folio);
+		folio_put(new_folio);
 	}
 
 out:
@@ -4401,7 +4404,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  * isolated from LRU (if applicable)
  *
  * Upon return, the folio is not remapped, split folios are not added to LRU,
- * free_folio_and_swap_cache() is not called, and new folios remain locked.
+ * folio_free_swap() is not called, and new folios remain locked.
  *
  * Return: 0 on success, -EAGAIN if the folio cannot be split (e.g., due to
  *         insufficient reference count or extra pins).

-- 
2.55.0



