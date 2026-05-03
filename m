Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 383BFCD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 11:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CB4D6B0005; Sun,  3 May 2026 07:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D306B008A; Sun,  3 May 2026 07:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 391D96B008C; Sun,  3 May 2026 07:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 287F76B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 07:55:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE92DA06B2
	for <linux-mm@kvack.org>; Sun,  3 May 2026 11:55:54 +0000 (UTC)
X-FDA: 84725954628.24.34D3FF2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id BBEAE1C0003
	for <linux-mm@kvack.org>; Sun,  3 May 2026 11:55:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gyiR4lME;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777809353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CE0IODkixju0+rcNdA3JHyloJEzjxQGb1seeQBb+Rz0=;
	b=LSvWBWbiON/r9IYMjvE3aazpf7AVTaHYQXXyNkBP3nHbR5KSWuZrgk7aZIXqF4Qksg/H0f
	So41gZY8j7mrjwuqPw2oM6lSpSE67Y4DDz4R4P9zoVzxx/XGVk/zbG+8G/AhuHA6vAf+iQ
	ZqZmEondMQ9bWR6SlNmx2NgGoMfU3x0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777809353; a=rsa-sha256;
	cv=none;
	b=RALFcku8aBEVIVkh+bCxIjzPO2NeC7h6Gt+dUY1XClNgXEa8KoAwGJnhU34wK+nTSUR1Q5
	E5WiKn9t9h3kwG1VzgR5KtnDsf6IZbRWeCqAarn9Gth6rZAwRLZRAzeQSGhu9DMxzAei2C
	NfKjGH9UBDNooM01RWiv3nWWNdNyMlE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gyiR4lME;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=CE0IODkixju0+rcNdA3JHyloJEzjxQGb1seeQBb+Rz0=; b=gyiR4lMEmEdCdQiJcUiy0/H8IQ
	9prnP/1UmTUCdQJZViZhxCo7RbhgQyuTyMbYCriAdYf4fLEU2PtrM0JCI/hQV1hyzuHZftBHXBysU
	oX+Xdre6gg0mqdZ5sqHXsRB1IWlS+3gP2T5afTfNz80luUvxOuc9B931xnZmMe+MdV70dF0CGp4v9
	9Rv7l3EBFQ9Th1XhsSgbrNUAAkQkSJzG429IAUTh9kbWr3dEA4aX4axR5hHJdp3zWcOiKfwQq96b2
	mpnP8L3G6AeWEDeCFrwvPYrtbdTiawmfq18HoE6Fm6KAsB08pKNxk6Pon+n9mQHAZ0u+9J/OIE6FU
	2e7Tl+cw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wJVQK-0000000Gx1K-2mC4;
	Sun, 03 May 2026 11:55:48 +0000
Date: Sun, 3 May 2026 12:55:48 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Salvatore Dipietro <dipiets@amazon.it>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Vlastimil Babka <vbabka@suse.com>, abuehaze@amazon.com,
	alisaidi@amazon.com, blakgeof@amazon.com, brauner@kernel.org,
	dipietro.salvatore@gmail.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order
 allocation
Message-ID: <afc3xFgKogxF5Lbq@casper.infradead.org>
References: <cxztt8nw.ritesh.list@gmail.com>
 <20260428150240.3009-1-dipiets@amazon.it>
 <a4uhrqet.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4uhrqet.ritesh.list@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BBEAE1C0003
X-Stat-Signature: zdxxqkr1jrdbj6hkcbh56t4ey6tgze84
X-Rspam-User: 
X-HE-Tag: 1777809351-694406
X-HE-Meta: U2FsdGVkX18Y4v5/NmsgosqtT/HHedCrog2Yn5k9dutD7HOGosQGwBQg6Aw4XOABDLBrPQmv0SF6XL25YHXSzt+a4FzrsbtTpKlfe35kfRHLvA9/FKoVg/3yf+x7zdcdoDsC9HOVYzX/WntKfs+76pSZeD96riqaRMA3hgexJZEq1epogTN0+v2TzzKONIGMopxK3fUUy/f0RfFyGV7fQ4yAAbdzeRz0v4AQpkCxpqxbbtKkZNpvpFtxLyOULm2qEfJ+FhpC93iSi+qwnOBuffpn5hGKzoJo+wNY6v2Ew17RWikDRV9uDas6jAzD/jAXTlSvg9EaEk4RN6RD2FIgrw/OKO+oGqUAEQN/0HS1Ajzoea3whChi7zBQ2iPItiswoQWyQCoTFOxEBNpB/BjekV5BPgM9sieJ4kPYPYGJOPLPsBiMHHE7SDNCUyrJzBfGYchry49lHT2csPslPl+xTxhaMBgrt0I5TUeFO+hmfe9qKe0LdFi3T80H84Pp45GCzn8ht0mLT/jY/uPNXgHPr/1Np+Rr2xDoraZ+587rXSXDz4ax8Fs95bHQ38TceT8zR8GDuEpxfkO3DziXNMdX1t15lkNXXeEeSJykxMba0qh1h2ZQElKnSK7XMdJBw54YVyAEqvapOE3ElT7zhfisRBMi8qHfyFmlOsDwbKC4Q/AuQhDqfiVnVuvR9uwR8fj15dl0JxTYaJjinUcTIWBi11Ph9RWa43fu1PpOK2iJh5T5/7mbd0rAkaMhK5+Yub9TCa4aXIfdP760S1AxoJ2+bvlXx3qQpltg1gGN7zdD+Kg3piyeQnGpY2mLgr8hqqjnf5A4OlG1gAiV0wBUCIK5gXiIcwAi1gKkbCLKNsh99OBmq7p/eFDcK+2UlnpH+TzOO8P6cPgsbY27XlD6JZF93Yq8u/kSRVODI+2ioybDOesxDH7Oo6rroIeNiILSC3qffI8PLzbn7BTeVEZmGVd
 DGplPILB
 rRzGUVQovFNXX+78qIAe+DHkMTp8iitwX4+Q/00RIFxGjAnarLfyfHCdZaeyO5jLdXER+Eww0uWJr3kCW88MQiMn1DQvWLVJ0At0XOC/XwHcGfh17xzxnbBq42eQD92pgymW6uiX0LwusjqEVRiClE/ococssies8pI1MlRpihdaEGxrBnAsGMUWcvseh1zyMUiGCgCAlAXC9VzE+Dy06WGPoCcF1OxuT+g36pPQF5tIT95djQIEtj3O3b8P/8QV0lfalFz//iSvuB1DqJA9NVAl87ejnmMg++DCOFPfwrnbIjUPdWwsuBEHbeGxTU4hD8+LEH9PSYvbGJUoRGMxQuN9rkiWCF1+VHcPK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 03, 2026 at 11:22:10AM +0530, Ritesh Harjani wrote:
> Now this is what I believe could be the reason for memory fragmentation
> with this workload - 
> In Linux, each PTE page table uses 4KB size (assuming you are using 4KB
> system PAGE_SIZE). When your workload forks a
> child process for each new connection, child gets its own copy of the
> page tables which maps the shared buffer.
> Since each PTE table is a single 4KB page, hundreds of connections
> spawning means hundreds of thousands of single-page allocations for page
> tables. So it looks like, the major source of your memory fragmentation
> problem must be these several order-0 allocations for PTE page table
> pages.

While memory is fragmented, the _problem_ is that we try too hard to
defragment.  From the original post:

: When memory is fragmented, each failed allocation triggers
: compaction and drain_all_pages() via __alloc_pages_slowpath()

We really should only try compaction once.  If it didn't make useful
progress last time, it won't this time either.

> > | Patch                |    Run 1   |    Run 2   |    Run 3   |   Average   | % vs Baseline |
> > |----------------------|-----------:|-----------:|-----------:|------------:|:-------------:|
> > | Baseline             | 107,064.61 |  97,043.86 | 101,830.78 | 101,979.75  |       —       |
> > | Proposed patch       | 146,012.23 | 136,392.36 | 141,178.00 | 141,194.20  |    +38.45%    |
> > | Ritesh's suggestion  | 147,481.50 | 133,069.03 | 137,051.30 | 139,200.61  |    +36.50%    |
> > | Matthew's suggestion | 145,653.91 | 144,169.24 | 141,768.31 | 143,863.82  |    +41.07%    |
> 
> 
> The main reason, why I proposed the below patch was because, this only
> affects costly order allocation (i.e for order > PAGE_ALLOC_COSTLY_ORDER)
> by skipping direct reclaim for those orders, while still keeping the
> behaviour same for others.
> 
> So, for smaller orders (order > min_order and <=
> PAGE_ALLOC_COSTLY_ORDER), the allocator will still attempt for direct
> reclaim and compaction (which I guess is required to avoid oom too?) And
> also, this looks like a change which could be easily backportable :)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 4e636647100c..f2343c26dd63 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2007,8 +2007,13 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
>  			gfp_t alloc_gfp = gfp;
>  
>  			err = -ENOMEM;
> -			if (order > min_order)
> -				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
> +			if (order > min_order) {
> +				alloc_gfp |= __GFP_NOWARN;
> +				if (order > PAGE_ALLOC_COSTLY_ORDER)
> +					alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
> +				else
> +					alloc_gfp |= __GFP_NORETRY;
> +			}
> 
> 
> But of course let's hear from others on their suggestions / thoughts.
> Maybe the filemap is not the right place to fix this as Matthew, Andrew
> and others were pointing. Any other suggestions on how to approach this,
> please?

filemap.c REALLY shouldn't know about PAGE_ALLOC_COSTLY_ORDER.
That's an internal detail of the memory allocator.

Either we want an API to say "allocate me a folio between orders A and B"
or we need more understandable GFP flags.  Or the page allocator could
use the __GFP_NORETRY flag to say "oh well, this allocation has a fallback,
I'll kick kcompactd to try to compact some more memory, but I'll fail
the allocation".

