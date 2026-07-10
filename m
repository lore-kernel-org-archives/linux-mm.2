Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4795BC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 18:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DAF16B0092; Fri, 10 Jul 2026 14:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365556B0095; Fri, 10 Jul 2026 14:03:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5386B0092; Fri, 10 Jul 2026 14:03:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E20696B0092
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:03:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3471BA0505
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:03:19 +0000 (UTC)
X-FDA: 84973638918.24.FC45FFB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 936FF20009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:03:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vrVhH6CZ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783706597;
	b=jFX0FK6cyw+AuFEL65vAoXRvF1llBLfDYejwE3pMRKpX2A34g5trL2zk1KfgCdd/Be5/s7
	SdC6QEkb1IcB5KLLW6Xr1cQ6qJgiphVq9We/ai9sXOjmtOLmHz2FyDoaZkterJgiovGBD7
	owWXuAiLQsOwLSN8i0xenXUpEEfw/+w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vrVhH6CZ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783706597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aavlYHK65oZ9/GvkqG4vhVx7lYGAHZXQDwnk4WMg/dU=;
	b=MP1ntCXd9DAFdE+iaf3uPeBTuNOY1tmpoiaeXLIZ46bU3K+b62f4/t3IznKMdCEwE7znAF
	OM0RSqUSYqcJXucywpO6nhVLbZ30WJ3jNCqb4Xf/sG4fixubFajwz2ZMj71jeAyeao3I6Q
	NDUZxpjoVkuM5G3zESDNiY6ryjkvkjk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aavlYHK65oZ9/GvkqG4vhVx7lYGAHZXQDwnk4WMg/dU=; b=vrVhH6CZ43iMT+yYcxyiUFLLu7
	6n+lRXruBnU93GSLongig8SFlKm3AgZwxoDzqo0wCFEhLVi87OcdBvy8aEyLkK6uObGGpp63VQwi0
	hSuIpfQAUdKbz4EsnK6t5wjQvkQ/25WKWlk+JecIt/nOtDbO71fPl9LF/Y/NWdanurlhHNyyBxsjK
	XSgbg9xirVLA2JFSb6mTgsgwyUUGEvEy/Tq4u2cqbUgu7cHfzICrLfyLQIGbF4vEvE/JodppgC3p9
	nGpQPd0upaeQCTcahdsyxydddO8e2FVnQstNr/bwE9fIu3MRbNdbcIipOiQ0Iglr3voabEDxdG1xk
	h5/yoyDA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wiFZA-00000007b0h-2b7J;
	Fri, 10 Jul 2026 18:03:12 +0000
Date: Fri, 10 Jul 2026 19:03:12 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-mm@kvack.org, hch@infradead.org, ritesh.list@gmail.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	dgc@kernel.org, vbabka@suse.cz, djwong@kernel.org,
	brauner@kernel.org, alisaidi@amazon.com, blakgeof@amazon.com,
	abuehaze@amazon.com, dipietro.salvatore@gmail.com,
	stable@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v3] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <alEz4Chf7Ibyg-ZG@casper.infradead.org>
References: <20260710143437.12379-1-dipiets@amazon.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710143437.12379-1-dipiets@amazon.it>
X-Rspamd-Queue-Id: 936FF20009
X-Rspam-User: 
X-Stat-Signature: 8dr3g1a53471y5kzn77aidutkta87qd8
X-Rspamd-Server: rspam03
X-HE-Tag: 1783706596-781377
X-HE-Meta: U2FsdGVkX1/soaJwJKtzmye568s11LTYjXS2bI59oqrUKi4NqaLPTHAD1ANQR8ahuUbqZ+ivOoIkpVZ7O7IfSXv4XguHq8w7rpW4WvD5f4/yDNUSgfxNRzwKDcY3EYeiQ2bq1zXWwj1khy3HDi/UyvBaaiERTq1G+CNqoeklJvjsy5l6O/zD1rlxSAhguvkyGVg1B/tWbj2V391HInS68IGmy+D3K2yT0gliQ+8NWhPQbaEYtOjoRlnp2CYertMHtgFSp0mJRyf4Rh7+9ExUNNewG2usRtYIsFmL5mzu1kqe2YSD/7bp7yyMNqeJWuUdJyL5XDEE3WShDsA/RlymOCR+aagKbJY8us7q6bwfPjVu8EOZ9yd7THHb3L/mPL6+cMDEGtBtbgWReJdrCO/BOwApgFq2x6wadDoClGDBIoF72Cik3utWw2RMCADv3ge4yGpBK+2Dat3Hlo2Yvkhem+8+ThltbQX7rW0gMHicV2AHo2nR4lQ99nbn4Dw5m91f1tBsJPEzSrF+hf8PPW1KtW13w6i6oXi7g5u+VU7KjgWj3fwyw57V9oWek0VGyemt2KP8vaB0cPw7CJel5Pc/dMUD2ZEa/S5yZz+mIWHP+XWnk7BrVnDel3HATcwAolmMTqKJGyP2XdUaszl33wfhj2169JKYxIBEftxRNBlERVNf/Rh2UUGd9/55DTLKVn1LZNWKvwhO+BnPiykmP3Ekv5OT2yIKVzx7wY84LllZbrOU2THEgZOC6o4DI+ARDRQn5KFqpKCE5yIK7U1Cnknu3mH3ydO04YyNMzTghnbpF09YDZHUTwZw4WhBY2E29xbTdM7CbcFmgNFPKhlKmln3u63oNGVRaClpiR38NrZq88t7o9uBQ+axT53w7FWeckmha+XjdlryekBCHFH/YmxtFOezkw1bpFm256maTNhf++wRa1gR6yJ9yYQPmxCYpQwNFNIfgiWjAEXt+1z3wTn
 plaWh5zg
 jz/QE2bb6M0w/+JDebPT1B0nRfZjFG0nNznehxDyD4mt+oeuhuGvXutXTRk0ekMefmJ16h0CFz/eu2G3ArtPk/unnhWfttNn3bhfEknSnlTsCkyzYWmXenEwqIlBWtO16JS6SnlHuvarmd28wd+weHF1B7WiL/fhHqeFECbzLQuHiQRuTuCUVo3Gi9oKRHuwLE6HO6dVNVdoJJzg7m19ZcGwaWGoIH0zsiduzB5aN4oK6edZAfu90BjrzcQ06MT4r7B2NyUEECell7i1R/6COUrd7WNIKXQOYY/cdtYXSAxIkvIG+4rWl+RlogwMiWsOQOZxjm0u05Myxkl1wrXTxZViLGRIPPYf/kAYYFwlOEyLGMPsLtTJV7f339ZOPncf5C69zW9aolrpNwWDbLy97kVwGR21Olwetmq2xTnctJKUJrpWQoWnDncKIwSkbu0mB1gRdvy7mdNKQN18yRMJ+Iu4zflm+QZi48XXM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 02:34:37PM +0000, Salvatore Dipietro wrote:
> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the iomap buffered write
> path.

https://lore.kernel.org/linux-mm/aeZzP6iQel-tkZOu@casper.infradead.org/

I just had a go at implementing what I thought might be the right design
(having a folio_alloc_orders(min, max, gfp)), but that's not really what
__filemap_get_folio_mpol() wants because it needs to integrate the actual
adding of folios to the page cache into the retry loop.

So instead, let's try this.  The idea is that we want to try direct reclaim
_twice_.  Once gently (ie with NORETRY specified) when we're trying to
allocate the maximum order folio.  But now that we've tried that once,
there's no point trying direct reclaim for other sizes, we just want to
ask the page allocator if it can give us memory of any subsequent size.

Until we come to the minimum order.  Then we want to try exactly as hard
as we were originally asked to try.  So revert to the original gfp flags
and don't set the NOWARN or NORETRY flags.

diff --git a/mm/filemap.c b/mm/filemap.c
index 58eb9d240643..23eecaf9b328 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1983,6 +1983,7 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 	if (!folio && (fgp_flags & FGP_CREAT)) {
 		unsigned int min_order = mapping_min_folio_order(mapping);
 		unsigned int order = max(min_order, FGF_GET_ORDER(fgp_flags));
+		gfp_t alloc_gfp = gfp | __GFP_NORETRY | __GFP_NOWARN;
 		int err;
 		index = mapping_align_index(mapping, index);
 
@@ -2004,12 +2005,11 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 			order = __ffs(index);
 
 		do {
-			gfp_t alloc_gfp = gfp;
-
 			err = -ENOMEM;
-			if (order > min_order)
-				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
+			if (order == min_order)
+				alloc_gfp = gfp;
 			folio = filemap_alloc_folio(alloc_gfp, order, policy);
+			alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
 			if (!folio)
 				continue;
 

