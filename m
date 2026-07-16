Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2F19C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 16:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 929A76B010B; Thu, 16 Jul 2026 12:58:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DACC6B010E; Thu, 16 Jul 2026 12:58:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4C56B010F; Thu, 16 Jul 2026 12:58:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4BDA96B010B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:58:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B06A0120257
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 16:58:06 +0000 (UTC)
X-FDA: 84995247372.29.2494A5B
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id C3F9D140008
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 16:58:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NzoLBRtD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784221085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jC4p4Ne6/jLWSLskeAq6PhK3LdwKo4FxILlpTyonIAI=;
	b=1LnPuftR/h5Qi81alQ1sPap19fVVLGWD4rcaptQjmws7+B4aozNK4rVQxC88JGXzsPOWzM
	w549LUz5XW80VJOGY9Oo9wc5fzD9e/s8im4qDA/cWpIobguHsfq/JrTK9ledKhw5q53S6A
	PL0bopzQxkzbQzw7fLFRFYfRm9vmjRE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NzoLBRtD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784221085;
	b=2iLYALsCDahHhUhSozljYwYtQLifrMTKewXUpr4d1PLlbaLV75DV4fm4HFhFg9RUawD8Np
	Csp+nbzMGnQEAxqY/6tx1wvMcEUpAgbKNZGG59gUJW+qrAU6r+AuOarHMkicsI6MJVIEwi
	Drvqm98QgGCL4pSsIyMpMgS27UZ7DCE=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784221082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jC4p4Ne6/jLWSLskeAq6PhK3LdwKo4FxILlpTyonIAI=;
	b=NzoLBRtD+O2u9AcgHZtfKMgXcga+qLhFKthO1GlzTLVouCV2Aq05/j9oIk+2lQHxV40PwN
	0CZS3G9sfJCFe61gaEjL1Q7fJWRNA4sS+jMvmZvl8bmFZnpaizzIf57h2e2ss7V/vBGwCw
	47u9tjpdeInTvHDJ/D2zx4vURd9rMGQ=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 16 Jul 2026 16:57:37 +0000
Message-Id: <DK05KUIDJVLZ.61UIWOL0K3OT@linux.dev>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Zi Yan" <ziy@nvidia.com>, "Jan Kara" <jack@suse.cz>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, "Hugh Dickins" <hughd@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Chris Li"
 <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, "Kemeng Shi"
 <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan He"
 <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun Park"
 <youngjun.park@lge.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, "Will
 Deacon" <will@kernel.org>, "Robin Murphy" <robin.murphy@arm.com>, "Huacai
 Chen" <chenhuacai@kernel.org>, "WANG Xuerui" <kernel@xen0n.name>, "Thomas
 Gleixner" <tglx@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff Layton"
 <jlayton@kernel.org>, "NeilBrown" <neil@brown.name>, "Olga Kornievskaia"
 <okorniev@redhat.com>, "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey"
 <tom@talpey.com>, "Trond Myklebust" <trondmy@kernel.org>, "Anna Schumaker"
 <anna@kernel.org>, "David S. Miller" <davem@davemloft.net>, "Eric Dumazet"
 <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni"
 <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-fsdevel@vger.kernel.org>, <iommu@lists.linux.dev>,
 <loongarch@lists.linux.dev>, <linux-nfs@vger.kernel.org>,
 <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] mm: move internal mempolicy APIs to new internal
 header
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Matthew Wilcox" <willy@infradead.org>, "Brendan Jackman"
 <jackmanb@google.com>
References: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
 <20260716-folio-alloc-cleanups-v1-1-5363b8e92d33@google.com>
 <alkLSzQvzT9zJbY1@casper.infradead.org>
In-Reply-To: <alkLSzQvzT9zJbY1@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C3F9D140008
X-Stat-Signature: c1ob7tfkfddjdib3bnbrpce6zp47nu33
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784221084-646637
X-HE-Meta: U2FsdGVkX18b3/uZyZsLEh+s23O9ffmt8nom20y2X3zGQRwMpnLN1oDEscOYamWi460+T2LsjZ/XX2GvwMk5Jl+XVAieDjhkhGD990YMc65cxx0g9O8cDxWTzB0qXpcK6mahrjjnAERQQJ9460IUlsKtIsN8gU78Bp/dLdY3oehwwpScdWtXN7USaKCYnpDoJYYsbjbqhSsfzFc3Hzvk4qsqCRbv6BJyoSbEQ9dtr8Hh1kmYuYVlG98rkvBS2Gi82DEnQxcJD+jsu+N4y+v/h8jcFKN7ZkfL/duDxznBSYVRaBkEnrE5gKufKlp6miFdkDRUDQ1nyPpdefpzo1esbIQqeiViyxk7SYUBwtWKOxf3+oz8bS5LtlbvRWVBbPSSOHk3eesykigev6J75MnQtPskzla5K8Wntyqyh48hML8AO4C+XZqFgfrgtJ2VNqtuPFGYxGv2fRhKOdAkd4KOUa9SraLroMODgiPlLotW0raI+QDksU7puscjwTX/vytiFj4u7yFQb3KJPcRktkoFyUb8R36XdvmjOTKRd97ZYXtv/S/cfdkdIhKnL4EjUeO6S7chFBjAm8Ur767IFh13IZ28XeywaszefmaIxSTk1EpksKAgdft/63dRMbDR/tS8biwJ/vz7gCuzuxx4z1XHk5BUqzurQWLpahZAdAgamSCl0xM5Hzf84/iWnfomARoOOUW02nByvsdV8THUx4j7s9oaAUTTukKkjR1QdwJEEuOKb1MQWUcSrx3+H1bFvA5U0+w2ac+l6aVpPqh4EAgoII98TAMx44OO55FgwBw+fDBFcsp3UxYNT68GhQIhStxsH1k67ZK6Y0oRqDjUkNgr0ZPj2cMi2n6/y/IxqhxjPLk5I13hL8K6vVTP8pQnei1/O++reE3NpfKTbtEx33mBS8Xt65k5DqmTncHeeZAdj5oCfgafrNrItTxkq6xAmt0vaHKVmtw5PgOfTPCJ5dt
 +jvKHvHq
 2/Qjaq67vJpBHorRe0qz1efu41z10QKf6HToCd22JxYz8wauFuyV9clYi6tofezCS8J4CYwnBpsvMXI/hXs6VAoW3AK/Txhd7AmyuofE1iugmJCRvaQjStT47bSNF+h/aGlLGKJQIdBL4spcI2Hu6Yroz9FLit82RMyMQN7fJB9Yb3Ig+n1djl6XlPMsF7L2MCfiiGIwMykLCRuGVellB+TfCIyEvGyzo45elU88drrvvr/3O1OeLlDBeT83jfXnTyh4mZlKY2mnxa+cvtH40IQhcTgAyARcF+2ATWwwCAZ6VRAV4dSzoJDLl+ifes/xEK/emWefSdukU+KfOP773ox4S8jSvdnHMikq1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jul 16, 2026 at 4:48 PM UTC, Matthew Wilcox wrote:
> On Thu, Jul 16, 2026 at 02:30:10PM +0000, Brendan Jackman wrote:
>> There are no external users for this surface, reduce the scope.
>> -struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
>> -		struct mempolicy *mpol, pgoff_t ilx, int nid);
>
> Hm.  So what we're saying is that allocations which respect mempolicy are
> only for core mm and not for, eg, device drivers to do.  Is that really
> what we want to say?  I don't think so, because that's inconsistent
> with having just widened __filemap_get_folio_mpol to allow guest_memfd
> to specify a mempolicy.

Yeah I agree, mempolicy definitely seems like a "public concept".=C2=A0 All
I'm saying here is this specific function doesn't have any external
users so it doesn't need to be an external header.=20

... With the ulterior motive that I want to add a new parameter to it
that actually _is_ mm-internal. Namely, alloc_flags, so I can add
ALLOC_UNMAPPED to implement AS_NO_DIRECT_MAP, i.e. the next iteration of
[0]. So basically this is
about trying to extend the allocator without creating a GFP flag.

So I'm envisaging if an external user arises for it later, we'd slap two
underscores on the beginning of the internal one, (with the alloc_flags
arg), and then bring back the public one as a wrapper.

Does that make sense?

[0]: https://lore.kernel.org/all/20260410151746.61150-1-kalyazin@amazon.com=
/

