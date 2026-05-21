Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A051FCD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 17:25:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A4406B009D; Thu, 21 May 2026 13:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07C1E6B00A0; Thu, 21 May 2026 13:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFAC36B00A1; Thu, 21 May 2026 13:25:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2A406B009D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:25:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD7031C056C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:25:33 +0000 (UTC)
X-FDA: 84792103746.30.46D8F0A
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5986E4000A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:25:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YmVIoM7s;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779384332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMwxwYsInnQKNuZpDpS5C1/ioRJ+8U1UfRBdgFKYaUc=;
	b=w53FeMxpwJgYGELBV8OB/I4cKUCNM7rmjkorQrWUvambBKC3vQ6zqhsTq92o/SqLskGqQF
	lKVWR+YyPzPfdtUaXAjR2wxfXYunSRbJMyeryzCHr0b5d1G1WmDb5IAXaisE7QtRhkM0gR
	8EckKXCxr2vJO4ya87qafErpre2n1XM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YmVIoM7s;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779384332; a=rsa-sha256;
	cv=none;
	b=MhvkfeiOeKDcMugJRfb6VnrKdZR0tnUEKYC5mlhfiwK3LGdaxrJadW0LJSC7V0BGUnIOJ0
	CseYmGC7cQ4eOZfRBNwT9DRaXxHT5JJLLvl+lDGjIrQ0h8Zbs5xO0ef/e5Tey1ODA/t2jt
	uUrhD5gfdBKXDUUs33Nbf+mh+hoLv/Y=
Date: Thu, 21 May 2026 10:25:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779384326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iMwxwYsInnQKNuZpDpS5C1/ioRJ+8U1UfRBdgFKYaUc=;
	b=YmVIoM7sBMemQ/wGQmebFrGGn3b1FfSmy2xsVZhLKgadJl+TMfwx4qj3xmAFBd4E5nekDc
	qZiao4IOLB0FhuCE9ppf8VD/37qOpevXEKQ6RTy4DnpjmnURHE2K3CHi7tKyi1RYR0UnjA
	4xAEDOf3Cz7+ibx+oPvAZmOIYpIeHlA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Minchan Kim <minchan@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Wei Xu <weixugc@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 2/8] mm: percpu: charge obj_exts allocation with
 __GFP_ACCOUNT
Message-ID: <ag8-Dfoco9qQho0A@linux.dev>
References: <20260511202136.330358-1-alex@ghiti.fr>
 <20260511202136.330358-3-alex@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511202136.330358-3-alex@ghiti.fr>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: tbahgyeqrbxzk8td77pe9paekih933ej
X-Rspamd-Queue-Id: 5986E4000A
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779384330-182622
X-HE-Meta: U2FsdGVkX1/9tJx5SlD2d3yahgKct5GXvdjwLy0O2CltLjLtI3LbdpWgEkHiU7UbS8WhDFcVrKFNlxjKyR2ZsUisDASK3uvvf1QBcRJvOYWjazTxeb421ZEpO+QCyqy1fOX/tVUcr+oFpNpH+JDAeyqo8y2xnolqnkqj1FsbsJT0dckfFH9VZSEJayq8cHsQGk33P3eppU9uJdZ7oxswEZr1fCPzcccDUWjCbLMNCBt/+WZLwJaFdI4xv9RAFQ5qtpCTuNzu9Df0AGoJ1tYPA3dkPEVKGXHOXOcRsVCgT5GIaZeyK3grYba+C1lwHBWLpzD+9WjQA3pRsJZgN5WkcxJm6qPjvA5wSLM5j8qT96bhMgIn0+sqTDRGacb1KG/tLLCR0xWP2qY3wDXpZxOQPLFdQ8wzg0jb/lQ4nfnn2X0ohl/TSLOhelYheitv/0Yis94XDh3JOc7Os5iFtcFJW1pPmmQamGDdLVBDWHnke/pt4PbMUbriCC9xWjwNFnmETU0b6kTvslpiBvAEDqHCbKeycCKerM/8SRKwdYlyb6rFkXlPT/H47At44lDvtoCbWfAGNJDWHoDc2xJPY1Yqyigit6bk6YUeWK5Zgdk9vNap9g4DFK5OlWYocd5KrWmHLDo+phl+akKRbTSxSJedI+Ij5E/WOXJjZkDtv9PIyNxnmxdwcDFAgDVHeIm36x8arFWEbZl5ai6oAN2z3ZiR0RvGLPVJNWTL1JK2jJ3epWHqpk1NaukOZsOakIcQx/6WcrVIZobCOUp7LVTNmk2qsY4TZLAlJb4A86xbkYx2sO/eOAKIC/8D0574JkyJGPqmPwhNa5NjXtJne+rI7bH8jGcHOvnEVN3nhw8UzbcdsYp9uE0YgUVZ+NErlV0j9SA6ylenrbDhCCx3EvijBRWCPRDLIcV4dQ+WMgZX3U00z5N0jCUt11HhcwHadxIhFDBZJIjYZIi5uL0KZ9DwNCV
 U2JPuxtU
 GtY929X8BPK2X2ydKLbIiN3eaFCDX8r6o1JA8vJ9GYXjfoPXWLGAsoMp3dEeutMMlq213xy72nouoCAU6Uut0isSP7RG2JNqNxUYdv2IJg5IcAROmLgj0LcTdlmTofsPmjpkB3AJtIH60OG1Ej5Vlf5aNTT5pkPyYTR75n6ar4Nk9d8agRb9cMQK4q8NimaQ8l/ijk4PM4nilbodjABJkuvPYaaP1iXUFW4hd9HAZ9MEN35ZlHSJR1kGWzrd5Sp7NrKCkn0sreZCQXCu0cJ8KL197iolbt/DPAhBDVTUSPKJ8g17+iN7yf9sEHWDvYPMdarkAQFbtrDp3vyA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:20:37PM +0200, Alexandre Ghiti wrote:
> This is a preparatory patch for upcoming per-memcg-per-node kmem
> accounting.
> 
> pcpu allocations are always fully charged at once using
> pcpu_obj_full_size(), which returns the size of the pcpu "metadata" +
> pcpu "payload". But metadata and payload may not be allocated on the
> same numa node, so charge the metadata independently from the payload.
> 
> Do this by explicitly passing __GFP_ACCOUNT to the obj_exts allocation
> and remove its accounting in pcpu_memcg_pre_alloc_hook().

Will all the entries in obj_exts array be for the same memcg? If not then why we
are charging the whole array to the one which happen to allocate the array?

Sorry I don't know the details of percpu allocator, so asking some dumb
questions:

1. Does the alloc_percpu() (& similar functions) allocate the underlying on a
   single node or does it allocate memory for each cpu on their local node?
   For slub, it is on the same node, so the situation is easier to handle.

2. On a typical system how much memory is consumed by obj_exts for the percpu
   allocator chunks? I am wondering if we don't charge it, how much will we
   loose?

3. What would be side effect on assuming that obj_exts is on the same node as
   the given chunk?

