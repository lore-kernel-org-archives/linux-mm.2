Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23E78C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:52:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E71486B00A2; Mon, 13 Jul 2026 21:52:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFA7F6B00A3; Mon, 13 Jul 2026 21:52:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9CFB6B00A4; Mon, 13 Jul 2026 21:52:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98EC26B00A2
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:52:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 168254026C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:52:17 +0000 (UTC)
X-FDA: 84985707114.22.A8F2ED6
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6688B140009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:52:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=phiRJC08;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783993935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Pj2O1XV/iVkFDN8GVAoeYlkqg9Q6iDpIRfEcXtGxjw=;
	b=u2U41zYokHbYE+dmvhz1WhdcPXtAc/N47eUrBmIsWBVNk283vCqSuQB6KY8Xko24dQ7Xas
	3SpbA1deCXnum+XeFRDjJYZ9/Z4u6hRcy9r0Trx8VsKcFuK/4LlWCZJmNKL6bGniwyKzPi
	UVZ0lx+/gk5Y/zwDag8K6CD0ijsIp9U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=phiRJC08;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783993935;
	b=XDo+PMda+cs5nEU5r+gPLjyLx5FXoCM8wAWyQJ63RWrHPMZzb4jg6rk6c0rxQxKCvKRdyb
	VMFghcnTq9VYJ6jMotNxYbreTa6r1cVis9jFlBa5+pW8Th24y8uVswBQJcMn7Ey69lIDf7
	7ApVPR3/z8/nyoRunbUxZ98PFOgFRo8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783993934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Pj2O1XV/iVkFDN8GVAoeYlkqg9Q6iDpIRfEcXtGxjw=;
	b=phiRJC08q5I5JcA3F6fMnZB1OyZRYKqEqiv6Y0aGluxJ7VzGnXQkfpPONgcPdItEWoGzZD
	9BBqeYTV0ttmcWvgeZyk1QB1qPUFGkmxxSy0L2TEvXBiX/MMGMENJ1iuQ0M6Z7zXFyQ/31
	vBthOxmjYMQXREFgpPs0km+9AM32NWE=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 9/9] mm/page_owner: use memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()
Date: Tue, 14 Jul 2026 09:51:08 +0800
Message-ID: <20260714015117.78351-10-ye.liu@linux.dev>
In-Reply-To: <20260714015117.78351-1-ye.liu@linux.dev>
References: <20260714015117.78351-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6688B140009
X-Stat-Signature: oprzktm4xmtn1tri5o956cirmf1x17ye
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783993935-775551
X-HE-Meta: U2FsdGVkX19oZxU/t7M567bfTlWHI8qUqTOYnRJ8dqCwiU0fVggHPI1XpTvhJSHsBZdcvCTQXnHauTI0Kh2hu/FxK3TecJitAbn/wi7PhToaG6mWYXp7pB/xZv6wEriCCQfcwSgD5aq/y5w2G71hIRdQoP0QabvybtHKsciX+/RWr6R5HntMu1aHXudz/Mdh82uaeKnVllp8PlJ3hL0a20WqE2iOtX/With9ku3W1x+SZV1AElXP6hn5djZm7/Gn0eGyMK/Rw/DKPNIAHOVZynGaIWEm38CMmJCvyfWqnU95VSWSUD2vtE/HNZbbCN408Oy81JX7VQwGFT5Fv2nl/6LIJX84zInn+VopQg4gBeELtQ0EpRBpJyX0LhvRAhVxByt/gh8cz/iDcjyOkNp/voy3y6DnsMa9lMkqw/pKo0DatKjLA1R0BMEGqYv7Y0Po2c95VfzNxKM9qQnViZz3rGEKT7K5u2WVOpAX6BRn4gYfY/9IuDw5b7ciNCwQN+lYClzv0MpsBmTOWJERuRMRfID0H7Qmi/dXG/VPBSX5AsbYL6AVJ26BGFXqNjdDkjhT1VZiyt+cM6T2VJ7X/ZycLJAnRANsTbR7jUaWwk9CJQdjz0Df9UF7jbP68J7BjUIniiLziiIAfMK5B3YFntOcxFfTjQIdoT12qiAK2e/flZYnES9LQZGhMNya7IimvlasNDjG3GDJZ4c4G1pUMN2H2UP+i+b+NM0GmFF+TnFp9EmTzBvvI2UZNfLnaF8VrXM/q0aErFbDEHw0/KcARr31DktOq0BMlxt2eWJWjcRrBNhoKTd4ri+Zz3xtsejGh6JjXzu4bvasG6h8/WuExo0N/gxYKMTyK1JqOvMIN3FMSidMyVYWia9S4PWXd+sM2JUED+qguid8ZNZgsXbmv2KLsyXX5DRZrz8tQJ253fsx0dAsYbblEetN3RfItWUxTh77YKPsRlbd31fe+NJQswb
 zaqqgVnq
 BF9tjdY8cksZWdzNwsPnr5rZc02VQs1/z856fEGWjHuoSm3LBwBHjGkFCXnqUCXp+RkrBSuJSUaBqkXOpxeX7bjrQfZuX/40tTnW0wUhFQ0aoPlUkIAYvD7gDNvxzSqT5JYKYyMcXoOqmLTfsyTLQ7K/3+HWVA36qcRLX/5O40cqEftbnVfPc+mV/Qa2eCwdMpgMzHfdACI4f5CiwyyQfUwaE+RuN11m3ti8diiVwivQpYJX6R+4aMxWdjkC+PxtY5cNn8hKBzdU2Hoq17k2Mtpw6Fwwi813RukkGE9/++Eh1e9TVFgyi3ssb1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

print_page_owner_memcg() takes a snapshot of page->memcg_data via
READ_ONCE at the top of the function and guards against tail pages and
NULL memcg_data.  However, it later calls two functions that re-read
page->memcg_data locklessly:

  1) page_memcg_check(page) — re-reads page->memcg_data;
  2) PageMemcgKmem(page) — calls folio_memcg_kmem(), which re-reads
     folio->memcg_data and folio->page->compound_head, wrapping both
     in VM_BUG_ON assertions:

        VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
        VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);

If the page is concurrently freed and reallocated as a THP tail page
or a slab page between the initial guards and these later calls, the
VM_BUG_ON assertions can fire on debug builds (CONFIG_DEBUG_VM=y),
causing a kernel panic.

Fix both TOCTOU issues by using the memcg_data snapshot throughout:
  - Extract objcg from the snapshot via objcg = (void *)(memcg_data &
    ~OBJEXTS_FLAGS_MASK) instead of calling page_memcg_check(page);
  - Test (memcg_data & MEMCG_DATA_KMEM) instead of calling
    PageMemcgKmem(page), which is semantically equivalent:
    PageMemcgKmem()->folio_memcg_kmem()->folio->memcg_data &
    MEMCG_DATA_KMEM.
  - When memcg_data has MEMCG_DATA_OBJEXTS set, early-return after
    printing "Slab cache page\n" since objcg != memcg for slab pages
    and there is no meaningful cgroup to look up.

This avoids both TOCTOU windows and the assertions entirely.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
---
Changes in v6:
- Rename patch to cover both TOCTOU fixes rather than only
  PageMemcgKmem().
- Also replace page_memcg_check(page) with extracting objcg from the
  memcg_data snapshot to fix a second TOCTOU issue.
- Add early return for the MEMCG_DATA_OBJEXTS (slab) case since
  objcg != memcg for slab pages and there is no cgroup to look up.
- Update commit message to cover all changes.
- Link: https://lore.kernel.org/all/20260701061101.344679-10-ye.liu@linux.dev/
 mm/page_owner.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 2e3880053a34..e18512a49e38 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -540,6 +540,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 					 struct page *page)
 {
 	unsigned long memcg_data;
+	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 	bool online;
 	char name[80];
@@ -549,11 +550,14 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 	if (!memcg_data || PageTail(page))
 		goto out_unlock;
 
-	if (memcg_data & MEMCG_DATA_OBJEXTS)
+	if (memcg_data & MEMCG_DATA_OBJEXTS) {
 		ret += scnprintf(kbuf + ret, count - ret,
 				"Slab cache page\n");
+		goto out_unlock;
+	}
 
-	memcg = page_memcg_check(page);
+	objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
+	memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
 	if (!memcg)
 		goto out_unlock;
 
@@ -561,7 +565,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 	cgroup_name(memcg->css.cgroup, name, sizeof(name));
 	ret += scnprintf(kbuf + ret, count - ret,
 			"Charged %sto %smemcg %s\n",
-			PageMemcgKmem(page) ? "(via objcg) " : "",
+			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
 			online ? "" : "offline ",
 			name);
 out_unlock:
-- 
2.43.0


