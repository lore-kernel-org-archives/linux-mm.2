Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC76606A885
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=YzISiqkl
Received: by kanga.kvack.org (Postfix)
	id F00916B05B8; Fri, 13 Nov 2026 14:45:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED71C6B05D1; Fri, 13 Nov 2026 14:45:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC60A6B05D5; Fri, 13 Nov 2026 14:45:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B4B746B05B8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:45:24 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4ECFDA01CF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:45:24 +0000 (UTC)
X-FDA: 85431124968.20.0B7878B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 273E1140009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:45:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YzISiqkl;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794599122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjLy+MNfOWSbu5NtI+C6mzKEH0S8YN5kvQWQs6kfrkc=;
	b=ezm9lr/jZdWoeWEiqryJea81knSlvJOFIi6IhKDdMEfcPkDZS9RV3Mb1H5+SEAqldVDGFr
	dcZwxPSC+nYkm1I+eO9hi981dmvWskH9c2CkhgjKTzxeO/J4YPapObeIU2kK/RdHUxyuWr
	VjWNUZtifrsKR+hYIrl3EFltwKjUa8Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YzISiqkl;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794599122;
	b=TGhFL9IacS7qKuWUzMUOP1BWvUS+RolR6O1lOt19V8QZ7wEqhE0XH0iQWYlKb2uhJd6YWj
	pRdeWHl1VSvAkHn6YU/YgoNLfluYDsZykESDEkww0m42lGkcocsMYnb2cl3XJAyvBlmTxF
	WcHpNoNewno84RxL6BLLw0Aa17Lbxfs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gjLy+MNfOWSbu5NtI+C6mzKEH0S8YN5kvQWQs6kfrkc=; b=YzISiqklc3XmZrEQ4ktPVVJEkp
	Cs6TrBIfJSI5GVzQaJ/BxOH7V9mOe6ECuhT9tR991M71QRZmMQbRkr3h5jYRETRQ1/NqAtljElDZy
	ZK3Yn97v5vfAfW8turrQxs3YL0t2dKfAcAxEDEFgaQqKOpnyfIK+wlJltQMRvfKjQct8kqa5cBPSu
	3/qdKKUa6v4PQrDIpsV+MzoTrOqFsqMwJwWHol9uio29w4LKmd2+5PbypGIl0kWmmAJ8SlOjzRxrL
	nO+exbnLtFOurhTYJxZVDL2lXdeoETe9g1o7Kvf6PjbPLnlZ8Mhcx7fBSgFEk5Yi5tP+rgZ+DQEj2
	Z9VNHkUw==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRxCo-000000052Uc-0jPI;
	Fri, 13 Nov 2026 19:45:02 +0000
Date: Fri, 13 Nov 2026 19:45:01 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Steve Sistare <steven.sistare@oracle.com>,
	John Hubbard <jhubbard@nvidia.com>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org,
	iommu@lists.linux.dev, netdev@vger.kernel.org,
	Chris Mason <mason@kernel.org>, stable@vger.kernel.org,
	Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v4 1/9] mm: limit pagecache folio refcount when mapping
 pages
Message-ID: <avdovRTVITLwuit_@casper.infradead.org>
References: <20261112-refcount_overflow_stable-v4-0-ad3deef0bd23@kernel.org>
 <20261112-refcount_overflow_stable-v4-1-ad3deef0bd23@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112-refcount_overflow_stable-v4-1-ad3deef0bd23@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 273E1140009
X-Stat-Signature: ehgyyuzkqs3ysqj817gwf8mhoeqko1m7
X-Rspam-User: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794599122-1473
X-HE-Meta: U2FsdGVkX1+UgXFPRk8+hT2pBbI4uEaGIXXBqygDHqzXMoSYca8xn0vsYsWCYkNHD83rAyPD/iQalg+iVAXOjsUOWGa8QQssLpSqe7MvKYT0vxCpPQx9uMw2zm4ydHIcPYhpFveTPFkOwldwDxEhrPf34wswGnwiyFAJqKsG6VLZYgl8GVgkS/hrhrBd+8iB/zoKkHT7WQso3t4pleXoVHnQvtOFwhDs2em9BnOtVevfaTUPp5GLWQSAIM2TwOo0sEkmHD/suxo/gKK5kpWyYEvEKzkgA4y3D9yMKS15XAjFa+5t68dUByBDN0jtfBELR4OQb4ZerbQzi5sw5+gmqj2xNaciQl2BIT/sUUjMPdtCPORytn0MztI/HuKtm+XHK9OZ19EaY+7AMSL+ed0u/jbsOtRzMA0Pb3vERdNJGKZq6fF+0D9X9mFLJi5sXFAxVIHaXxznn+xys+DistFLSDk2YyGn5d1Zma3yurge+7rPfJUW+m/83OcG2aZomTgK7csRbQsPZkYQRBiWfcgWGFJwjP3EmalVExj8dlkg+mAWXx5FaDPex6CiHH6x/5+XpWwt5maSNnHumYivAXOGm7w2zPxmkAZa/GngHNQjPcKwjh6QqM0jGVaGy2klkOekEVyzPOGIEkDXqaYCaTgT1abxlLg9pVwsb+5HZSf7TL28EMX6k21DsNQTNxJVIz9hiFiqWQxrcvpkgyhJxck53m+9IPiLAGqF/sPVrK/XW76JvK3MjtuA0Q2LZ1MHXy1ngwV0zOWuITgRPLR7U1AzhH0M8fmm/Df0KCSbLmAa042WonCJNzVWnHefVxlWgyhwDYfTS9jjDikF+cpfwwe6+bpNHfTtv8H11wnm/1l/LUaIZRmp+UMmD67O29Q8p826ADSjg+aHz6fR/oJaAiqKbs3qG0CjDpv5T6hRsOWkkk95B8mV4IV4R+eGs1Ng0IvLEqCNfwXfQcS22x8mp0H
 KmrVJxL/
 ft6U0agG7juBcCYfEpEWowzQOkeChPeE+cqtdHgXwCWPbDZFrIKRCYIevaD9UKQmiTT0ZffyyklSqHgJXGFx3ZXbLwE+uBk3ex98BM2jIAdYk/51emZ+34jqpzeEFJlzQ0C8HZw2tBiSKHcag9hfA1t+W8Iy1hfO6rvVoKcogtdWWzyo95DUApfI+R0pBwjK91hTFXEL6Z0uUjtve2u1DOvPHgxU2NqumOhxztYgBSIS7zUvcZ+LG110t3Dt2z+kfIwukkbaE1HO0XjUw45tscbhs3FVdmZiB2pcxddi6XNnN3ec/f90DOjbHt1CFjtmmKGhRnzO2VdJwfPuOxIiz0tFH+i9hIo6hbRgq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 11:53:20PM +0100, David Hildenbrand (Arm) wrote:
> Being able to overflow the refcount is not really big news, but it's about
> time that we do something about it because some modern technology might
> find ways to abuse it :)

Yes.  My primary worry is actually it finding a path where we forget to
put the refcount on a folio and that gets exploited into a UAF.  I'm not
sure the "reserve for root" aspect really helps recover from that, but
I'm not too opposed to it.

> As a short-term solution, let's introduce two folio refcount limits:
> one for ordinary consumers and one for admins. Leave some headroom
> before the refcount goes negative, which we really don't want (having
> the mapcount go negative is also not expected).

I don't think a negative refcount or mapcount is really a problem.  What
matters is that we don't get to zero from below (for the refcount)
or that we don't get to 0xf000'0000 (for mapcount).

> +/* Leave separate reserves for administrators and concurrent reference gains. */
> +#define FOLIO_REF_COUNT_LIMIT		(INT_MAX - (1U << 26))
> +#define FOLIO_REF_COUNT_ADMIN_LIMIT	(INT_MAX - (1U << 25))

I think these specific values will generate bad code.

> +static inline bool folio_ref_count_over_limit(const struct folio *folio)
> +{
> +	const unsigned int ref_count = folio_ref_count(folio);
> +
> +	if (likely(ref_count < FOLIO_REF_COUNT_LIMIT))
> +		return false;

I would replace this with a simple signed comparison against 0.

>  static inline void folio_get(struct folio *folio)
>  {
> -	VM_BUG_ON_FOLIO(folio_ref_zero_or_close_to_overflow(folio), folio);
> +	VM_WARN_ON_FOLIO(folio_ref_count(folio) <= 0, folio);
>  	folio_ref_inc(folio);
>  }

And I would drop this hunk.

> diff --git a/mm/util.c b/mm/util.c
> index 80f6c714844f2..c9c3dc4b490fa 100644
> --- a/mm/util.c
> +++ b/mm/util.c

Now we have mm/folio.c, I think it should live in there.

> @@ -791,6 +791,32 @@ int folio_mc_copy(struct folio *dst, struct folio *src)
>  }
>  EXPORT_SYMBOL(folio_mc_copy);
>  
> +bool folio_ref_count_over_limit_slowpath(const struct folio *folio,
> +		unsigned int ref_count)
> +{
> +	if (ref_count >= FOLIO_REF_COUNT_ADMIN_LIMIT)
> +		goto over_limit;

Maybe let this go up to 0x8100'0000?

> +	/* Background threads must not consume admin reserves. */
> +	if (current->flags & PF_KTHREAD)
> +		goto over_limit;
> +	/* Neither must interrupt contexts on behalf of the interrupted task. */
> +	if (!in_task())
> +		goto over_limit;
> +	/* Capability checks are not safe with IRQs disabled. */
> +	if (irqs_disabled())
> +		goto over_limit;
> +	/* Use the task's credentials, which filesystem overrides cannot change. */
> +	if (has_capability_noaudit(current, CAP_SYS_RESOURCE))
> +		return false;
> +
> +over_limit:
> +	pr_warn_ratelimited("folio:%p refcount:%d mapcount:%d mapping:%p reached refcount limit\n",
> +			    folio, (int)ref_count, folio_mapcount(folio),
> +			    folio_mapping(folio));

If it's worth doing folio->mapping, maybe also print folio->index?
In fact,

        pr_warn("page: refcount:%d mapcount:%d mapping:%p index:%#lx pfn:%#lx\n",
                        folio_ref_count(folio), mapcount, mapping,
                        folio->index + idx, pfn);

might be worth pulling out into a mini helper from __dump_folio()?


