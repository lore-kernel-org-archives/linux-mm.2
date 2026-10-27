Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8706606A330
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EBNUrHgp
Received: by kanga.kvack.org (Postfix)
	id D48B96B05C5; Tue, 27 Oct 2026 04:56:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8EF6B05C6; Tue, 27 Oct 2026 04:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0F816B05C7; Tue, 27 Oct 2026 04:56:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91B496B05C5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:56:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 213DE40933
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:56:18 +0000 (UTC)
X-FDA: 85367799636.11.6FBC5B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7772A1C0005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:56:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EBNUrHgp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793091376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LLjeyafLWq906e/KlV7udPCtdijPfLEIi8SSit6QWfU=;
	b=rDImWxpuwo+IdYJzKD3mnxizlKytiJjQtrBaBLLdvU20c5Jl3rUnbPxgdSvtJDxJ7wSFSm
	7UykiKJf5inW7PY6hgYj5f5BPLZsThqLpt3dNhVVyvKZK7uVoR7l/Iud4WYcjPHtBiTxvt
	dIskIztJl0kcCjjYftghJoEIuRSK3tQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EBNUrHgp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793091376;
	b=WCblGNLEi1c9s2L3GsSRBDnPrWbzbmB1MeZ+vByoovjCy9Q88qq8+m4zqu6c2nz5ckajzZ
	I0pcgtKoEWogA8Vomxvsy54XDRvnU3WER44dpefpYpaKqHQJssZboGqUgWIbmlAr6ZBVRp
	1YrOnqnMfGwaCMhbBgRKJMOVH+eFj4U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 54FED405EF;
	Tue, 27 Oct 2026 08:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEAE1F01828;
	Tue, 27 Oct 2026 08:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793091375;
	bh=LLjeyafLWq906e/KlV7udPCtdijPfLEIi8SSit6QWfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EBNUrHgpyjuV+uDWfTfjiZjrVUSiaANjjrfsc3nkFZWTw82J+OqHpWvLIciRV9TNx
	 2ZYRqlKawGk39ZaulprNCM2tNwh2zki3TsMiowIH13vcslKJA7833dN8riI4s3kDAM
	 Q3qfXOkNFX5VxnUmiQtmg5QWQCqFP+dYzLxz19uSTgl5bash6cqoBqqOskiaRk2/C6
	 RL8HDc2rNHtv0XIn1ejrOpB1M3CI9bhEBJhZRP1bllfI+FRzWtybU61jzIzwI0z0Od
	 /meOw5AGq2fgtE0iXpBuP7zSuxszxjxhbNpF90J6AdO/j7okIvx+jpqUI1F2fZM2tZ
	 5wOIAvJFgckew==
Date: Tue, 27 Oct 2026 08:55:58 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 44/46] mm/cma: don't release CMA pages still in use
Message-ID: <auBmRQDzFPea5FeS@gremlin>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-44-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-44-6f74bec9a5bb@kernel.org>
X-Rspamd-Queue-Id: 7772A1C0005
X-Stat-Signature: ic4kudrybfdeaikw11fkb4qrcyy84ca6
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793091376-376421
X-HE-Meta: U2FsdGVkX1+5obdfnCKvbhI5Ln7jurXu01sHPjP1Xrf7yBI1N+TCMquSY7fBmT0DcTyrDzcKD+1DNOmnLw+GVAlBdG81hEpmv6wdcjdIJFT1wpbBd5VXjQM78FUt4MxUas9I2aqjyY4o0gTf4QW1HYaEzWC64rO8yp1Or5uRFgjoEXJc/UDwmAmCrQMqikroy4qxg4cKFKdz0UN1QOzG4ONVkhvfVOEeQP4S1PnQ2STjKHZmulCMIBeLcMH7+x+ncQQvVwvKHXwen2nUhiOurNguIHtGOVMjEYBotfnhGDBoOwXOV4UrRlVCyRRYZvUCpHoo5XNMZZnu0UhQxUops16gpO3AfnVB7NwRvjhjU1UJlNzevzx9tAI2oY223vmkdfU6JguNtVXzquWXHd1kYx5Jk+028ElVPtVIsL8stF8AmXUSxZyrF8Y1S+Nq1oQbO4V+YQ0t04ekPSt0rxaWqrIGk078RGPEEFB5KZbM4NNRUb4S8Gj0Xnl06v3pHeLIStYUOO4IkrRywiVzb3UQ0e9a77uXUVg+zm2bijs3UrgOkCAYDFB2+jc8c4wiHoE2fZJjBhdNG7+PsRwWrDBS8j/0EvGSVI4h7MIhTtOtjdPLWC1lO5re1e7cuvoibHmZfOKbqXQ+knA5FncEaHbuvlv4elqaYvZxJyIhbiThWsnZH51bT1V+2FLCT7m5LOd9D6C/l37XFS9xVMdpOBtEV9uwW9pQwTWd6bWv+9EaUC8qNVVp9eg1CVtM9su0JUjkwv1T+Zq2O86GgsU5nFjp86I1IQn07CtbRMyMUVvr1tmkW+E7hjfpajuufA6BSzGMngYYLGhPhitlgcSNPfPLm+eTSH5AUWhjSxVrWpnBCLZTEc85Ma4G6l3Ex/CrWbt1KHr1vufh6OmHckFTTmINzeC4SLsTytFmP1Y+Ks01LrPy464oa05GauJbXutocX0kOzhjP8lo73pVcCbq3ma
 EcuE6YBQ
 9B9IlGEqzp+cQSjvfZvYbRtVEJBbdRILaq07mrsZObMU7kBkZKN8bLqFRAS9fBFn3yWg1PUhdlJw9Uh3aozBrXFqUNY0POPhxOja3LQqePGuRbtkhAEUp9PUd1imP0tSC9sZFLb6M4si8CF+prvvTDuGl9CcDL7P7UmfANws+V22eaVMVCwF9jGTNOqZlKd14vziRNOX14+0fdIW5z4K3zg8iS5nMjg3J2AIfw/DVJExAjGA/hq6HEi8LvMJU+QJ0syg4V57hLuzkBTWrHuf7b/WovywugtGuqf3tdRMecI4I+8xE3FBDTk6zxRN7EmEDTrzgEdZaSIhmJrUvG9knqDps+9E7YFXxv/RZT5Q/BAaChCZ3Ub/tmp4/cGXaZmoe5ueJWfW5gskS/uu1I8KOgHNaKndyR7Clqiwk0LTcF0AS4m5ooH1H67t3QPu/u5Wcld70pt6yhM6YhQR5817M1gRVlm73NB+tKylTwfwf7HX42R1MKaNryXvF3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:18:04AM +0100, David Hildenbrand (Arm) wrote:
> From: Rik van Riel <riel@surriel.com>
>
> When a driver calls dma_free_contiguous() before quiescing DMA, the
> page might still have a reference from the device.
> put_page_testzero() there returns false, WARN fires, but the code proceeds
> to free_contig_frozen_range() putting a live page onto buddy and clearing
> the bitmap. A subsequent allocation can hand the same PFN to a new
> owner while the original holder still references it.
>
> A concurrent put_page() that drops the last reference between the
> testzero loop and free_contig_frozen_range() can double-queue the page
> via page->lru, corrupting buddy lists.
>
> Avoid the corruption by not freeing a CMA region if any of the
> pages inside are still in use.
>
> Make it explicit in the warning that the driver allowed a leak.
>
> While at it, use page_ref_freeze() to make the semantics clearer and
> switch to pr_warn_ratelimited().
>
> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Rik van Riel <riel@surriel.com>
> Link: https://patch.msgid.link/20260811132045.5f114772@fangorn
> [ david: use page_ref_freeze() + pr_warn_ratelimited() ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/cma.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/mm/cma.c b/mm/cma.c
> index a10ea37a261da..871f95c9ae9f0 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -1020,7 +1020,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
>  		 unsigned long count)
>  {
>  	struct cma_memrange *cmr;
> -	unsigned long ret = 0;
> +	unsigned long leaked = 0;
>  	unsigned long i, pfn;
>
>  	cmr = find_cma_memrange(cma, pages, count);
> @@ -1029,9 +1029,13 @@ bool cma_release(struct cma *cma, const struct page *pages,
>
>  	pfn = page_to_pfn(pages);
>  	for (i = 0; i < count; i++, pfn++)
> -		ret += !put_page_testzero(pfn_to_page(pfn));
> +		leaked += !page_ref_freeze(pfn_to_page(pfn), 1);
>
> -	WARN(ret, "%lu pages are still in use!\n", ret);
> +	if (leaked) {
> +		pr_warn_ratelimited("%lu pages are still in use, not freeing CMA region!\n",
> +				   leaked);
> +		return true;
> +	}
>
>  	__cma_release_frozen(cma, cmr, pages, count);
>
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

