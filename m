Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08AEA606A333
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=knLIey08
Received: by kanga.kvack.org (Postfix)
	id 209BA6B05B2; Tue, 17 Nov 2026 05:53:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E1976B05B3; Tue, 17 Nov 2026 05:53:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11F346B05B4; Tue, 17 Nov 2026 05:53:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3E896B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:53:35 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 80B511C3B0E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:53:35 +0000 (UTC)
X-FDA: 85444299990.10.3F73F75
Received: from mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id 536A61A0002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:53:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=knLIey08;
	spf=pass (imf19.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794912813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CsXhM9ytjFEN37udrZ3Xji2sYLgVWqA0tFv8jS/Jkp4=;
	b=wHUS5p2vsAStEy6ymC5blKqKq2CyDBkuceti9tiPFJnYD4mY2MXW39GGHQWXxrC8YarYeZ
	+j0wSTrqOOoWPwidswjamrklQ87timZc9lXi+I+QhMrV1R8LRI2ZB9UXN7ruLe+1Qefqjb
	2ANJsRGizJPZHF4UJQj4BLNkhBAZSZk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794912813;
	b=k6xMiYIYNq9NF5SZbBL2vdk4wAH4QkV7EbRn5fJUmijejJ4rRJbRuX0+f/kz3wz7CEmgzC
	ORMLz2b2Zieql/D1MXk+CSs4pqf7NIS3CcZb4k8hooIxSfpzilYHCP8cgfkbuPa6Poqw/h
	w17KlvHuGsAPi8XAzcBlpqoMi5UwUIg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=knLIey08;
	spf=pass (imf19.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wBzKicx0cQWljDK6M/ai40hT3cChWMPzAJb7JvpDisk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794912811; v=1; x=1795517611;
 b=knLIey08JCH0xmq+hHEMWSJNnk+1xTrGzeL7VXwZpuFG7hPQbN8ohOHQuzmkUQbmx0UmM02w
 eMIuWCT8tQlwfUFoHKMbsjpLw7vqWvTdHuWzPl9/pmt+23PHItX3aRZR8WXPHJp0bJAae427XCq
 zvP481Cb7r+vT8ckporExq+o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bdf8bbebe49c3e29;
	Tue, 17 Nov 2026 10:53:31 +0000
X-Mizu-Trace-ID: bdf8bbebe49c3e29
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Tue, 17 Nov 2026 18:53:11 +0800
Subject: [PATCH 1/2] mm/memfd: drop redundant hugetlb allocation mask
 narrowing
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-for-memfd-v1-1-fa68f433171e@kylinos.cn>
References: <20261117-for-memfd-v1-0-fa68f433171e@kylinos.cn>
In-Reply-To: <20261117-for-memfd-v1-0-fa68f433171e@kylinos.cn>
To: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: hongfu.li@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794912797; l=1716;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=6lBD4a5aUEw2qNRL4yfUHQwl9S1KTGlkZCmy8GxlQ6s=;
 b=OVCcqACbYB014S2W/DctNpGn9u9W675ly7lfiMNVYl+BCRAl7R93T9GGbmay4sgOzMvoKUMtz
 zGKvIz3MIqVBYFcJrHAy2KatehTjcTkX5Q/+UC1eYQXUwURz3gpCA1M
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Stat-Signature: fagrsdjdq5uqtpyj7b8rhkc445f6j6i1
X-Rspam-User: 
X-Rspamd-Queue-Id: 536A61A0002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794912813-691442
X-HE-Meta: U2FsdGVkX19irICdPUMQByMxgmUj/CWncenDFVqByKd4KUXhpvlv5kiGjVSOZiJiDx2FQlAKexNt0Km+Mua4Nh7Y98qXh/zlm7fcM+cHrrUsacOrqyx0lFKZ3227nECwgl3MViwyrsQcg1nQIRozgyls2BwCce5eMun53xcCHh2ZpU2i9HFMrIY3w2hBIKyAvZNZr48Pw6SKc8nbXNgghyhKKA2fcD+DnXcqkfAv2ViHZhPd6eU/wzKb3gLrc0E+nWbfR3eAZHosFNzyvm9kJEP7XWSF+8vjTHQPmlFzRiXc5OURXZ34KcDsfH9jqMFuAvs7K+rocgK9/4yfU0GVTop8ozGFZxgjr9HqD7VCQREGjMb2ZfzlSoOxu6vFDZyzSIq9QvGEyGFaDwv+sF5hMLC0F6afGTz+eckvXRzfuMssYEdxP3vrDa23TiW6U3SoobaK5c4JJGQJE3JnkJT5DY3wwZ6DjHK3L+lLItC72I/I0i7M3gj4+a4p6pUaBcNzpdcR20KUdVmefy/CmRLTwmsJzr+X86ZopVcNG04fHITy/Bkmq3UvbJFoLlTtYVFvzzHmkUj6hdDTA0QaJxt5c9yBzOT6FHRSSEQNIslD8QA8SdbdaxYsSF5tvgkp+VCpdVUvF8bvCsburn95DOEOygR2B+eLL9ZxaeOO2b1QVnWR3sL5H7ft5O5fS+A3SDOd2Jgy5epP7bOsFaIrNwG1BN1vQF2Z2vv9V8iBzqeK9ZDGS7oLbU+DyrCcb1M1umlSOOWHf+DGtRlvmTZdd4dub97ZsnXvAH6RiyxrlsEBEimt+U88k7DpoRfaRySCds7m6tMIR2tyxMDknu72mzUAJx8469ZMhELnlQnMittoXWRP9wm2yNseKzsGYyDtN1kt80PQLXgqK1N3kgkTQRKQ9dyA/CAIjjWHtt2tDn+NqNDXatzIbOEAyfWevwJ+tXKjI2t7sbwZkiDk+8Cd8pV
 sTb/6ss7
 5Naq0MTFCNzClCdTFgJ+1QIrX6acLDuP2cFHWG3F6q24OzHdOJrtOvuTgN2yTBT+xqEK2V726pvct0xXirqXlsfi01w8FcR0UjqlL3EviIPMMeQI05WTNeUUt3OcXKb7cSPq3ayXd+fs4VVGntwZF1suzy0oFcGzzmilTeQ8cFfpPOQSVTmluZNO5mDh9LnXB9k/b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hongfu Li <lihongfu@kylinos.cn>

memfd_alloc_folio() derives its allocation mask from htlb_alloc_mask()
and then clears __GFP_HIGHMEM and __GFP_MOVABLE. This mask handling was
introduced by commit 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios()
for pinning memfd folios"), when the fallback path in
alloc_hugetlb_folio_nodemask() could still call
alloc_migrate_hugetlb_folio() and reach the buddy allocator, so the mask
decided the zone and migratetype of freshly allocated pages.

Since commit 26a8ea80929c ("mm/hugetlb: fix memfd_pin_folios
resv_huge_pages leak"), this call site uses alloc_hugetlb_folio_reserve(),
which only dequeues folios from the existing hugetlb pool and never falls
back to the buddy allocator. The mask therefore no longer decides where
any page comes from.

Long-term pinning safety no longer depends on the mask either:
memfd_pin_folios() obtains its folios (dequeued from the pool, or freshly
allocated) under memalloc_pin_save(), so PF_MEMALLOC_PIN makes
dequeue_hugetlb_folio_node_exact() skip any folio that fails
folio_is_longterm_pinnable(), and current_gfp_context() already clears
__GFP_MOVABLE from any page allocator request made under PF_MEMALLOC_PIN.

Drop the narrowing, which has had no effect since 26a8ea80929c.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/memfd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memfd.c b/mm/memfd.c
index 0e3ff3eebfa8..8905e3e9efc8 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -85,7 +85,6 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		u32 hash;
 
 		gfp_mask = htlb_alloc_mask(h);
-		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
 		idx >>= huge_page_order(h);
 
 		/*

-- 
2.54.0


