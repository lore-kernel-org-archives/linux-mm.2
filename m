Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C97CD606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 08:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QtpM+94P
Received: by kanga.kvack.org (Postfix)
	id CE2246B0678; Wed, 21 Oct 2026 04:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C92D46B067A; Wed, 21 Oct 2026 04:33:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B82786B067B; Wed, 21 Oct 2026 04:33:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9E26B0678
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:33:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C8921A04B4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:33:16 +0000 (UTC)
X-FDA: 85345968792.18.A124A9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id F28E2100006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:33:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QtpM+94P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792571594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MKByxw8dDW6HSJz8+UMbqi5YMYg3uB2cb2BltWyQmtY=;
	b=hmHHIvJedsxic1JSINC8g9tKTIWNIvOhwCON6G6vsDoahA2yLNP/TBYFWk5caSB0Os2ckC
	tB17mPpiKFktbT4YTrGKRnmUOuCfDdQtRC3gGBSgntDOY2gDFHpLVb9uog+E9itfpT2oII
	xzLxoMtbGQ3lEjJL56zzwkx+wDInr+Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QtpM+94P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792571594;
	b=AXMGNfPayFXkGlZAWIW8wMFIvToWzNQrqXRdzfLyEJydDyb+xw5ZnGHMhwsj6w1gri8MKm
	U/UGUTBGvPoiBb289RhrfouO/iLe+hBpFUqcqGTYZnM8E3EeVw4+4eEh1uGR6ix/e2QwoF
	MSWLN9wDgZzqWJf2yfVuNPYk8c/9CLQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2197843D26;
	Wed, 21 Oct 2026 08:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F32E1F000CB;
	Wed, 21 Oct 2026 08:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792571593;
	bh=MKByxw8dDW6HSJz8+UMbqi5YMYg3uB2cb2BltWyQmtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QtpM+94P0z/ja2LfWi1SKDPVylIFLra5YBht5Gdl4ToK7koxRMrqLfqlFA6US5oc3
	 3+xUnVvo/Y7M+Izf5+pXUzsRxldK98M1KJrd5mNfp4ME9zkbgkkajDpOwKYTgtw/qj
	 r1DUqsE4e8dj7RM7K+JilygqmHkigjTqfMnclTo1YQ/YNCp1YGE8NcrGv9LF9qln6a
	 +OAHHmrFUeL9DW2HyspbiMqLPl5iXJX6S4GfOHC5geAqZpkLySVG2ImEaV4xp9J2LZ
	 jIz1SbEL45Sunpjq0AFLoRcG9SE/lz9ACwk7ieWFZy79gzhKLxYKkn26a6SIOEvMvE
	 AdV58TpRxBNYA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 96A7C198004A;
	Wed, 21 Oct 2026 04:33:01 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 21 Oct 2026 04:33:08 -0400
X-ME-Sender: <xms:vXjYaqD4Edw4zlL5mp13NmLz3tRKqOiPZcTgJgIpShC3QPuWlBmNTA>
    <xme:vXjYarPSQW8giGM80hU1G-6AKAFbQFhhzu6FP8FXkbGl_xwgSJXoZvt_wthwHPyXS
    Agw8fpGcsh-UE5pbchgsNIVOkgnQW1hQUb4Mj9xsynjFrOLv644KYZW>
X-ME-Received: <xmr:vXjYau6T3aVIkWBowCPXTm5p3pJwbJMNfUI5vSNXMq4n7tgqoQE6ZaLep5U>
X-ME-Proxy-Cause: dmFkZTFrsjqyNAVpEK98oebWFXwZpI7LqX9Aov6fN8jUp2sNNep1ITMUB5YykhVbmPS/JW
    hhu+Ze1IE7IQhEqDUpsMd7Cg7z0t93UpSSU3DYZM/EVADOuUVk+FjdtAeACf5DVZ07Qkhn
    t/PA68gModROd74o4gybU16E1jPYQsNXGLetxZ7IOa6m+sCSckxL6wwATbX1RUo4X8mwkX
    tvQzyXOt7I1CuCjEyKtXxHmz4HGj57DN9ITZyqARldyoDovSDBIwoWizcJ+AuScX7751LZ
    GsLMiHVmGYyi+16tRQPq7oISzc69Z2qZ+zI4txcHKFEUanCWKZTYL39zREtM9rxHRO8Jhq
    WH7pVuWso/HHzbbIyQWn+a0kjP0y4p2oz5+TPjDWJrRopIdu1nE5WVdG0PPJFjuufj8M0L
    GJ//TWPi0snycliRS5JJ37gww9RykpVb7LoEMV6J/YhMqGDXlyLbJ0tx1TUjl9rfgYneJi
    OKTrtcZU/jhXGREu335v/vLNLk3WQxS1jzpklNaJ7gFd3IhswJL1OmaUOh/+v2t6E1l+Bl
    AWWX+tWL4e/AZIyHtWrbzT8WHj0a9UNa5jeHi82Da4a/8bdG8RYbXxatW9tRg0y2KQIITM
    GFV8HOuowBhoXkp3irIUh2WZcBODF2cXEfd1sZfpqWHqGU10kSs+RI7+0DGw
X-ME-Proxy: <xmx:vXjYauqfryVHxqE4auQn3axpAf2N62CEDED2JFHUY1W7ULceo2orXA>
    <xmx:vXjYak-s_P_X8IEzwImFUarcxPBVPLP1kPrB88HbNgTTf78QDf_Xxw>
    <xmx:vXjYapX7GsewJFLd_bHvVob-INQxR0pTumlNEYFqdaGdZvJll5VOVg>
    <xmx:vXjYarAmMQmJsCyknzln-QjD_6RT5voeOhvjDeH7JEsjPXELfo-Org>
    <xmx:vXjYagbgYiwyZnitRIjHGBhDBbxop9wsVdzJkQiMncCsOZqnbKYQxt5s>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Oct 2026 04:33:00 -0400 (EDT)
Date: Wed, 21 Oct 2026 09:32:59 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, 
	Hugh Dickins <hughd@google.com>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, "Liam R . Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	"Paul E . McKenney" <paulmck@kernel.org>, Pedro Falcato <pfalcato@suse.de>, Harry Yoo <harry@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, kernel-team@meta.com
Subject: Re: [RFC PATCH 13/18] mm/filemap: store the end of a read in f_ra
 only when it changes
Message-ID: <ath3Fk56VcWp7NPe@thinkstation>
References: <20261019154913.1765974-1-kas@kernel.org>
 <20261019154913.1765974-14-kas@kernel.org>
 <CAHk-=wjJpuLXt5BHieXV1qBE-uoWDXKugcfGgR+DiVGVZQ8RvA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjJpuLXt5BHieXV1qBE-uoWDXKugcfGgR+DiVGVZQ8RvA@mail.gmail.com>
X-Rspamd-Queue-Id: F28E2100006
X-Stat-Signature: huzru845kx5h3js9f313jatrdyh6gq99
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792571593-741476
X-HE-Meta: U2FsdGVkX194jeX6XQx/izGmZ1iiOSxcfnSx9oFQRA6nLw2S/w8PJhf3sFKHYBqxm5Z2oHnzmKl30VJMjaRwTOm/zHND0Zb3XVjhIUv9WSbmfZ5olhTfgudvzFwZxqM+kaCq9/vnei6GEPIix+TyQYZPEKgWZOcVpZ1D7BDWTfhiNonfhfO0riqkaFdahvlApnxWsKfXjPA0MhQQhfRGlSwOuDs3P0YcvOn4NZfsnbmF21lGM5RFLI259yXk/ruXzH9HC/Z60U45xo0hGoI80KHU8CZIJ011GCyIxnji9Tr3MOLsXNs2z7wK6y8+kluoae7ZlWHUVy56zef+zzmxB1C+4AXyEFyFwZVesIglOibPuNJN5ipFAa1UwHIrb8DnxE58oHN9H1D/tTZJayV7R/X9+yGRzEXfjyw5gOjtcHzCfgrSyY/eHqeEXlziTzaql42ldhcJU4w4wZn2w4Pwj5PjRVMm0gqnlqh3tFKh0ufyZKncnSaydKCVATb4gZhiiNWboF8kafNGoFADNqWYV0LoH6YQBK710wf/GzX3eEgjIuoUUqd9FJ1NjYNcwr3g3ukPU/GTwolK7SeJ2F2Tb735jK7UayygkUHCYg0khpvvx9Nf2affDS+691wdDbgo0BOOirMPlXBrTptvpoUiY7mU7/ICrHKp97tyfjT6XuaknmYC9MSE02lTuhL8alvtH2YB/JAbEHrFRHXeUxr+Mz0m9EArvZ653Bz/9pAff30GLh1GXRNcF8cUrNAfzHmnXnThSUr70NRNPW+AsuUI0HzxlxFeAsWBxg2bS5AX2XprdpERqqruD/0tQnt7+QAjbJ8KWhA8DUG9I+lZDp62uk0t6Hc2atLywEurRq55llCtjZ5YagFXGEIxVLya/fKQaDVxSi2AaT2K8Bo4NRYY86iI3YoNeEqv6kyNLU+ai8c1ejOG0ksiZFkIYZZ0NvCFVKl0lUetJ51TdDgIFK4
 OvaGiNid
 JjMLaUBoI+FWGPt8du6dEz+iW5P6P4a+KmvI+UKrwNqdFZq5TS28S0MAIjHfAsuVhOMqkzUdt50KXsvHjbVFNqZSd+aMTzaSA0DP9z/P5C2bASTn0UvRUCOVcMT3A46wvEScFfnD0zbUsybLyFfbjNSGMGFTdOC08vO9kqrEWjYKCAPG5eBFXQprfzkply2UJujM75IudDBRPmMrRRkNE0Op8vmNJThIVVBrc61jpEuY2+dnaBYCpBlCJzbnOmjIG8Sc0q7tIMoFCL5JdKJ7Etxn9oNRHlVsgGaVnlzwRvwc28KTPKyFCgTeiRHe0AT2QOFbLEb5uTiV3rUfdr8nSPtVNQuq/tInH2n5GEEKIJWL+Ot0Jo/FO1Nw/oC83LWlRsetKX/ipeVmIlf17UrfnDBNbIwuU6RdJ0UjWUyg/O9c6Hh6ENRjVGgCjbxJluZH9rTZlC115XFBarFc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 11:20:00AM -1000, Linus Torvalds wrote:
> On Mon, 19 Oct 2026 at 05:50, Kiryl Shutsemau (Meta) <kas@kernel.org> wrote:
> >
> > filemap_read() writes the end of every read to file->f_ra.prev_pos.
> > Threads that read through one open file all write that cache line, on
> > every read.  The value often stays the same, as for reads that start at
> > the same offset each time.
> 
> This seems silly. That "often stays the same" is only true for the
> pointless benchmark, no?
> 
> I don't think it's ever true in any real load.

Right. The patch is bogus, not only the commit message.

It is worse than useless: for random reads prev_pos changes every time,
so the compare reads the shared line and then writes it anyway.
Bisecting a RocksDB slowdown led here: with patches 1-12 it runs at base
speed, this one costs 4-5% at 16-64 threads.

The store itself does matter in a real load.  RocksDB threads pread()
through one fd per SST file, opened with POSIX_FADV_RANDOM.  With the
folio refcount gone, the prev_pos store on that shared struct file is
what they fight over next.

For an FMODE_RANDOM file nothing reads prev_pos but filemap_read()
itself: readahead is forced and returns before looking at it.  Skipping
the store there takes a small hot table at 64 threads from 10.7M to
14.1M Gets/s, against 12.5M with the series as posted.

I will replace this patch with that.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

