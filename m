Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE39EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:12:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6D4E6B00B9; Wed,  1 Jul 2026 02:12:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B44906B00BB; Wed,  1 Jul 2026 02:12:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A811E6B00BC; Wed,  1 Jul 2026 02:12:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C08A6B00B9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:12:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0397C140235
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:12:11 +0000 (UTC)
X-FDA: 84939187704.05.E8FFEBB
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5A0C0140005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:12:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hQYvkOCq;
	spf=pass (imf09.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782886330;
	b=5Jqr7XalQupjxlwHMeIqKGSe+Ru5dcwrltQMgmcTdXivBSRemHTk8oNiuPjVcQQyJVaT5f
	aKzC8NPiVmhkr+UfUGenBRcaKrZSbnBiqwi8Gvs50fh0jnoFXLA+oxAA0nfuqAthDrmPcj
	CiZHHe5TaqDQqGJRTpUcppEHM5CK8AQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782886330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPdMSwpWK7V6fRo0p2kvQ6pvML08ypL3K7qCcleN4AQ=;
	b=buxUX9d8caqQ5mxoJBnfAYhHrRXgt13LCOCldKX0wCfcDrMt5lZ7GoxCABTt+q/cZ3qvQx
	MXfEWKi93Ttn+hmhJekIzH4k8r84Ko7zmdJG1Y50+QbsN3ntB9oJ8oafg08cFPQynBWhRp
	9LBgKhrwJqFRyKvoe+hI6l1IuPxa7iU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hQYvkOCq;
	spf=pass (imf09.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782886329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kPdMSwpWK7V6fRo0p2kvQ6pvML08ypL3K7qCcleN4AQ=;
	b=hQYvkOCqxZ+sYtTLVbwOEVJuJpQU3RHpvBv4p6VLBMnIHVSMNL6RVPfY/BeVdawllR+9RK
	K5Ew8NxOJgKbzvlpMixaeBVFvCf5isTx6YQt254dlm7YUh+5qcy88DQrPdHEPltAw5EMbt
	+W82bi1y1qwhxS/SnC/hzNuPoSuQomU=
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
Subject: [PATCH v5 9/9] mm/page_owner: use memcg_data snapshot instead of PageMemcgKmem() to avoid TOCTOU VM_BUG_ON
Date: Wed,  1 Jul 2026 14:10:52 +0800
Message-ID: <20260701061101.344679-10-ye.liu@linux.dev>
In-Reply-To: <20260701061101.344679-1-ye.liu@linux.dev>
References: <20260701061101.344679-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5A0C0140005
X-Stat-Signature: ijrxujsymu96xdcnzbcnuxej1i56whxa
X-HE-Tag: 1782886330-82546
X-HE-Meta: U2FsdGVkX1+iAdgVf8TbLrQTLck3u7N2tFt6WZO1Cy8vdiifNwO8wgeeG8xE8xsHLSzR3IPnofVYsXv2yxxCy/MXUm3mhLoOyTGyoly7gO2IjTfxs7x0EPRqu6bvoTLZsDw8rI8DIngYseJBN2pBRK3h9MwsqZmvw9ULVhLWbp1+SmNML0NxTNl7D+jnh6098WMw8yonRUiH6sWpMci08jz+pvrw7khhgLDsZWdFb8+EOFhfu8gpgGFb05kv7MfylpSQ18SCRsOsWScsYQhaix3iYfUa3xPWLqWdtqyDHXfdYcIaf37rDFyKuY6MrJ3zrX++tJGBBtuyslsn8LL8POlWd5omcE3HAaEJyqha3pnTB4I5W+5fxPe/mh3gcV8KyFQTwrIuHxHpbakFl+ZGS+Yt0GseiGCkvQs8AGctx1BQBM712r0KXJO4NwVPeMdPWt4l9DIkKLgCHDNd+jycsUPzQbEq1Ovv1oxVco0Q6mqZdp3NIGx7Ijjha/Itx/NkxLapwAQsW7XHnEjsb15kwuAz9wnPLY6OEdM/onol/CY+95B05inZEivQevieFa9GGvDsDec1wbodhiqhdKdbXfAk3UfHeAsuyHGaEWCGESNDUV2bu9DLyHrNikQGiza0oDHSn0jD+A0Jsz1we0K69MiE30KP4pk5LJQcNF/AyCHhA4L75MMqTWTS9zO0NS8aQf/pndY7ED8M5Z42eUt9CXUyu7iwwstfKw46V8ZErBebbSKCXpHOCgejGxW87hOoepBN0s03is4/wfnSxtRksCGPRHPE49y9Hul80Iv1ct+SjTmY0qdMmerxu7WPfj+tza8wU9gp3kKCddVShoje1bvLg+9Ya3s8mopMgcW4KMReNZBvqYCjET4ney3rdSX4o43XkpFzq6hFejyiRaHJqgTey+aYf1NoZIeoVZgsPh8wgA+Sp+SEtf86cMY8/GP1Vz0nOLA2pnp2wjUWS8b
 C2a0wWoZ
 QX8jEqGiW2hf6uXGshazUgYi7oMP89TkNy8JPBgM92qn6LYIGSRaNcg+TWA9dpsm0+znMoaQYBLHDeqCOvZlx/QHSIYBCZEl5LD+sB+PezF2r9bxQ80Rv4ga3QsIjYtVGUBzPeUs6AUSK3pSUQLBR5eoO9F0w50V4qNBXHZd69Yyk1R/KB9eZ1rpTUH1RGddbAk14Jvxynr4JKCf5/YWW2gGzLNPRKLVOStzKIw+vK3A+80LbFDfvC9KYUsnQhlDPgQmEIZnwUE1w1KrYtc2suTvQ0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

print_page_owner_memcg() takes a snapshot of page->memcg_data via
READ_ONCE at the top of the function and guards against tail pages
and NULL memcg_data.  However, at the end it calls PageMemcgKmem(page)
which internally calls folio_memcg_kmem() — and that function re-reads
folio->memcg_data and page->compound_head locklessly, wrapping both
in VM_BUG_ON assertions:

    VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
    VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);

If the page is concurrently freed and reallocated as a THP tail page
or a slab page between the initial guards and this final call, the
VM_BUG_ON assertions can fire on debug builds (CONFIG_DEBUG_VM=y),
causing a kernel panic.

Fix by reusing the memcg_data snapshot already taken at function entry
instead of calling PageMemcgKmem(), which is semantically equivalent:
PageMemcgKmem()->folio_memcg_kmem()->folio->memcg_data & MEMCG_DATA_KMEM.
This avoids both the TOCTOU window and the assertions entirely.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
---
 mm/page_owner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 2e3880053a34..efbf67d54ee2 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -561,7 +561,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
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


