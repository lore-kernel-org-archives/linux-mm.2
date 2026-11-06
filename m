Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D60A606A32D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IgGruhZp
Received: by kanga.kvack.org (Postfix)
	id 52B956B05BE; Fri,  6 Nov 2026 05:06:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 502E26B05BF; Fri,  6 Nov 2026 05:06:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446436B05C0; Fri,  6 Nov 2026 05:06:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 21B2C6B05BE
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:06:22 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B91C7120BFB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:06:21 +0000 (UTC)
X-FDA: 85404264162.05.05AD5D9
Received: from mta0.migadu.com (out-128.mta0.migadu.com [91.218.175.128])
	by imf05.hostedemail.com (Postfix) with ESMTP id 25124100007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:06:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IgGruhZp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.128 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793959580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84LIFW+AvMdbqkXSFm047CRtvQ9GP0clJy2Lqj2p5f8=;
	b=0Qd8y+kPS5MVrUZC+UmkgOlT5VUFLBWRqkoh64kHuXFrs5KoonuEDAtaSLMvN17hMwxoW+
	GrZ+o+LZc6IBtRarDQ/hEn0ClAm4k2JS2ct3Qzr3nuU5WcPWeyRvG5FouMKfHkLje+NO0x
	4mL0aginhIyTcxqMjLpp5f1Jj+sfeM4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IgGruhZp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.128 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793959580;
	b=XMNqiHHX74kruZWR/rGAoqxbUpI7rpRx/rhPBRt0HMWRBOpebzPqgAvemcX3uvGpTPsBox
	FKEVL3wj+YdvUuyOL2J/Onyj4Twk/QoO2DiAHJIfaEvRy47Lz4boaK11ec/FtfXpNObbC6
	lSoElEweoERDM0u0FCb8ECTEHkfWvs0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9W5E0aTicTRcozWJfG/+L+M5IQx5AOnpXJfN4HLzHSs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793959573; v=1; x=1794564373;
 b=IgGruhZpDLOXxyBCxUc7kPAa24gzvdY3E3hdfzGfdTdUF5ff7hZXhd4gSLMyKUpOSbrQP6Zf
 A+cK0kK2jrHRc0rpNtXRDqRn6YgJbPa/LSybGQBsev36mKcNlQAuY5MvKiDojbJROMFhJ1+h1ja
 yuudZFpe8iHYu9T0U5jnUa44=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9dea5587c19e644f;
	Fri, 06 Nov 2026 10:06:13 +0000
X-Mizu-Trace-ID: 9dea5587c19e644f
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>,
	Zi Yan <ziy@nvidia.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Chris Down <chris@chrisdown.name>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v3 3/4] mm/hugetlb: fix NR_HUGETLB accounting for unused surplus folios
Date: Fri,  6 Nov 2026 18:05:20 +0800
Message-ID: <20261106100521.30099-4-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261106100521.30099-1-kaitao.cheng@linux.dev>
References: <20261106100521.30099-1-kaitao.cheng@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 25124100007
X-Stat-Signature: p9cqmamj3a9irm8bk6abr4nxhripyrbo
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793959577-898369
X-HE-Meta: U2FsdGVkX18qDWXs3kltZKjTIUFX3T/bmsh8vKyQ/op6LghqYY+hnnkLBaw2RJgI36UUSC7tMMJG1Z2K0memQS9LJCVa8UF6AT7ywwPRaW4qnEuwJu1S1FcbHSVKIZWoDaJDXCywJZYcH7zHoivc/aeuF9nfSUJYv9bI13V0tDoYSbQ4omEjH+z8FRWUq0GlsKn5fQk/gHCH9Z2PBVNPsnzHiPc+ek8d5M4HABpYXuVup9UGfYf0yNZbhkrI/padD/GNm+bYQgDO1+VVi3kfe4vvHYizWgb1lqEs1fR9X0/9S3kPzXB+T7BrExEcc69z/AEL/NpdAiLRTl5znAKlQ2pezI4nlM9KMDyUGTJOtxny2V0V0AuoFRiO2U/ZtvlHzuhji6I3JcIN7Zk9YROkmtXssA4Cd9UG2HJaht08C9yOZtb7rtfiWMqwg1WrF9uH3nkhEFxNQiDfKzpllKZstQ7+MGZPgqaI+Jx7UHq/Tc2nwM3pW+/DcTk7GVLehFicZNrktqlDcvzl8Rg8ftEXhSNKT8tShjpTm4kxSJAqgivaQJHhENfNVoG9S9xb3YnBubrGU5rZSxQFJEKLNDX5pXKTer5vHZ3qps8CFLY7nk655Xu6m7GAZxvZMrNYgQHRzHC7nI0aLvo9tWeyib3XcHBIcSiIczDUaaoG91m1eV6Mz10HmHZkqUdHvjTnEz1cSQ1WUBoYWzuuwDT9BNoN4oXQMKqXV63JlguVE3FKhWHZahN1Zp3Db9DLeb8UryeflhsH9OZaWDqrITD4S/ZBRxBg9gZt3CT8EMe+KlS6tzOQ7t2ANeHAkb35AKSE0IWYGOHoXiyOT5/MVCKKCkOAphispUiOVoRAIIdIaShXT5ennTxlFVPRj2KnxdCjn/ZmxmQ3P7kHcfYhgaU9Hy2S0H/PbTsGJKMOY28Wg7eFiZNxtxJOrbE/WpBBnHNuGDv/xvlGY483KRiYqDI9JAa
 IN7aeQDB
 VzAV0JJkeyiu5MQK3Usk9cVSoBmh5N6HFZRaX2QaGJlRz21qZ/DVFWNmE7z+TCW2wzpRDcLc4Da9rcWXKgCx0UcxlSy8e2LljfV1e3QncsFI4TZbVNEbDXEA9ZGv0lOvYG6XYzOnsOg/dktSbZda4WmHhC5GDNCgoQPEEpW8088EV6evZFxB8Dt3YX8apq7x0MJTfOnhOCS+Kv4RjyJiJZFOqp6xY5AwgoAEagcTryj5PXuJ0+iKkTo0UZbKzUBq9qvePQXryEYheVO+RXlvoCQdWLx9J/KWQRyfkgcd2vpjvBfVcctD6XpXfg5ovZmCk3iOMc8Hiw1e87v3r+pRvtsjm7PWzXxf6+bWHhqp4tOETk6RLCQz3aVMmC7FE6MhN+7GmJzuer4gFjjTx4rxzRiLY4JjcTe3q3U+Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kaitao Cheng <chengkaitao@kylinos.cn>

free_huge_folio() unconditionally decrements NR_HUGETLB, but freshly
allocated surplus folios can be freed before the counter has been
incremented.

This happens when alloc_surplus_hugetlb_folio() rejects a fresh folio
after its second surplus limit check. It also happens when
gather_surplus_pages() frees folios because a reservation cannot be
satisfied, or because concurrent pool changes leave excess folios
after the reservation succeeds.

These paths leave unmatched decrements, causing HugeTLB usage to be
underreported and potentially underflowing the counter.

Increment NR_HUGETLB before calling free_huge_folio() in both paths
to balance its unconditional decrement.

Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
Closes: https://sashiko.dev/#/bug/linux-860a3b8f-0b07-4cd5-a122-aa2288463bee
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/hugetlb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5b5353ff5ee2..31a92ed4165a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2140,6 +2140,8 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
 		folio_set_hugetlb_temporary(folio);
 		spin_unlock_irq(&hugetlb_lock);
+		/* Balance the NR_HUGETLB decrement in free_huge_folio(). */
+		lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
 		free_huge_folio(folio);
 		return NULL;
 	}
@@ -2384,9 +2386,13 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 	/*
 	 * Free unnecessary surplus pages to the buddy allocator.
 	 * Pages have no ref count, call free_huge_folio directly.
+	 * These pages were not accounted in NR_HUGETLB, so balance the
+	 * decrement in free_huge_folio().
 	 */
-	list_for_each_entry_safe(folio, tmp, &surplus_list, lru)
+	list_for_each_entry_safe(folio, tmp, &surplus_list, lru) {
+		lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
 		free_huge_folio(folio);
+	}
 	spin_lock_irq(&hugetlb_lock);
 
 	return ret;
-- 
2.53.0


