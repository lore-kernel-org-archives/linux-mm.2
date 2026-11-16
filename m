Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 841E5606A33A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 21:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YRz5t8jC
Received: by kanga.kvack.org (Postfix)
	id 675376B05BB; Mon, 16 Nov 2026 16:03:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626966B05BC; Mon, 16 Nov 2026 16:03:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53C6C6B05BD; Mon, 16 Nov 2026 16:03:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 306D16B05BB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:03:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C40CDA01F9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:03:46 +0000 (UTC)
X-FDA: 85442208852.23.3151EC2
Received: from mta1.migadu.com (out-138.mta1.migadu.com [95.215.58.138])
	by imf22.hostedemail.com (Postfix) with ESMTP id 348F6C000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:03:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YRz5t8jC;
	spf=pass (imf22.hostedemail.com: domain of luiz.capitulino@linux.dev designates 95.215.58.138 as permitted sender) smtp.mailfrom=luiz.capitulino@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794863024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ikTLCztXVjoeaw96G/as+sU0mQkTLug+7IxY5by8NuA=;
	b=kw/2aG21V9SEB2ytTFhjjRcA6heh80Ea8+SIG3OVfrsMAvRKxeGzAQhpQPja4QENOGSnnM
	n5RAba/j73Dx5psdDNgpBtzilNK88uCAaP2Po16yiYJcdoDF6Zecc0POJDw79STuei1B7E
	Je/TXQL7gJrsO6enV/cwiVXGLWaSmzc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794863024;
	b=6v0rOlaJagtpWHBaTxxxPgtkBCYjfkMcMhtYdEu7GnZZN59xQEt3uGJAGK17jRZpUhfm/y
	HIQb82U9yTsTteBiUuudqoDB+Aoo+ptWyefnbA3tx/C/3USGxHEYSMifCO9S1xf3Sm95Ah
	a/vcgzJSra3DRjz2tGo55RZB9RilsQM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YRz5t8jC;
	spf=pass (imf22.hostedemail.com: domain of luiz.capitulino@linux.dev designates 95.215.58.138 as permitted sender) smtp.mailfrom=luiz.capitulino@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MwUlEU6UA+1p7eL2QxWULcMIS2F/vL+3zPY714jTYPE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794863022; v=1; x=1795467822;
 b=YRz5t8jCIKWPIThCDXl56Dh7elLKSSS/bRd9skcpLvKx0+WWfSfWQTapAupzV4HI/mMdeV44
 oxpcEVPqlQtUjtJYvqvGUF7RFhGfDudOqCkDGdZ+SPKnALEDBHntagkbMg6oxuL8CnxxzEnxwhC
 8OWyrDOrZMKhSxkcg5E7rFOY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d132572e0baffed5;
	Mon, 16 Nov 2026 21:03:42 +0000
X-Mizu-Trace-ID: d132572e0baffed5
X-Migadu-Flow: FLOW_OUT
Message-ID: <32c5f583-1b2c-4ca2-864d-bc98cd24cb73@linux.dev>
Date: Mon, 16 Nov 2026 16:03:39 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/util: fix retry detection and handling in
 snapshot_page()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shivank Garg <shivankg@amd.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Shao Mingyin <shao.mingyin@zte.com.cn>
References: <20261116-snapshot_page_fix-v1-1-8e425984e8d1@kernel.org>
Content-Language: en-US
From: "Luiz Capitulino (Red Hat)" <luiz.capitulino@linux.dev>
In-Reply-To: <20261116-snapshot_page_fix-v1-1-8e425984e8d1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 348F6C000B
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: yone8jsx6oei9wr9ttp5r43iya196jmu
X-HE-Tag: 1794863023-331698
X-HE-Meta: U2FsdGVkX1+zkcRLRc14tsbJ5+K3+o2cdbuY8PHo/DpIZuZTp71r/fL+44beDxbzlNJXf21QO+XI/FtksK/tlxi3QMLij/PZNVbIVg0rMs8s0ad0VdTNEIx+OqEdicDRMO1rP0FgSIdlP66oKLH2aFXsQ4Te3jQozoHPE1amShj91CzRGjk1vdVNICsMH2mywpwRC4T5qyfz72Uf3hnJMk+QH+Rf2wOsJDB0GK0hUzLIhGxmQJoPWfYdWtjBtu7dQO0y3jPNJh/0ogz3drrJKB8S2O7tPIU0myZ+Sr2WPAx0MG0F4DzNjvRhCW0C33tTNruvKbDf5HJZ+eU1WrsJlJ8eMIijIJC6AH0NrmTs9yLBLBuqpZMc5kaffqNVKinkf7d22N/WNKv1t+LsCx+vEeAK/sa2o3qLPNOYBwWtEcfrZrb85n1lmG7LVCBgoeV93EleZLZlXJYP4S6UwVa80Te5yvwnwHleA9HG2vQagDXnlNDqQv9H2rfErMZb4DjB1syLrl6Nd3bbYK26hq/B1H6Z/EzElrGJ2z2Xz7IIr8DwoDHs7HSxH4koUPSa3dQnB+gzjackJzBRJMaV96ljuAtatS30c8TiNoHsNi9qbT3nMIrGeX7TMRoBxwZLSVv/T2W98rDhCAR86ULxO4sCX3FIm2aQHnVp1UWTOmF8FbHe3BjGWK9RYCan5MbbidGCW5eEaThD1D2KWhSu3WXBC/9/U2xXK5eQ19W1uvGzr/KGap1oUJHM/+kpTRMridrdg0xCE7lbWNHs8SbojPRJZwyjAi6xihfOzGhWKbfh9SuHzUd8n98Dp5iKIMJXdW+xRUW7YtYCQwqmvS4gwy1bQjulxJVbPi5g0CwdLByRO2QFFFZeuCDkj5UxVkECs3zplvTEr3qKQopxRdfJhG8OBAZMsbHO4hbgd2a7oRT799tyGA5bpkbszwRl7h1dkppkOjHgNmSxYJisLHd0fVD
 kISa3NvM
 fMGyF4+TqcmLBiDp9dUbdfYJFcwfaJ3DQPc4jUiTxa8EM3WF0brU0X7etGUKO2trbeJtCfDXDT1N9vVPYzFWht9/PArem1c0MjdQDb6BcFFMiZB+zvTvIHtVVJMNR1tRVO+db7j0zj7pGz26J0t+l0MG5KVeSWBx3ScdoekOfTmU8n3wIOWEkIkTM3PhEkH4JXo+pzC7BgjH8+zChZhpSKuyAhFgitmq1oUSSuwEGzK8hVaYzGcdeHs8nPbwemrQz7XvwRPNvHgcRk8oWvjo73WEoq0FJ5lelSIHk658vYxySnfyII2TbZ/2QSKWFA2zmcqQds88zkeUIHLg/jWGsSSCaphTdAB/xo2qFSfaY2un50IN0xepZmhztfQUZa5aiKpBVPfOyLYDFO1w7/fq8X5E7EQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/16/26 9:12 AM, David Hildenbrand (Arm) wrote:
> snapshot_page() detects races with concurrent folio split+construction by
> checking whether the given page still falls into the folio. Unfortunately,
> we have an off-by-one error in there, and we should be checking for
> "ps->idx >= nr_pages", because idx 0 is valid.
> 
> For example, we might currently report a tail page at idx 1 as faithful,
> although the snapshotted folio is now a small folio.
> 
> However, there is one complication: As we don't hold a folio reference,
> folio_nr_pages() can return 0 on races (or when called from page freeing
> code). Handle that by just setting it to 1 in that case, so we don't
> wrongly report a head page as "page does not match folio".
> 
> In addition, we should reset ps->flags when retrying, by just resetting
> it to PAGE_SNAPSHOT_FAITHFUL. Otherwise, PAGE_SNAPSHOT_PG_BUDDY and
> PAGE_SNAPSHOT_PG_IDLE from a failed attempt could stick around.
> 
> These races are fairly rare, so this is not really critical, we simply
> report something slightly wrong. No need to CC stable.
> 
> Fixes: d863a12108f2 ("mm/util: introduce snapshot_page()")
> Reported-by: Shao Mingyin <shao.mingyin@zte.com.cn>
> Closes: https://lore.kernel.org/r/20261115004657890Pz8ERDf5nCtE-B6M7KFzu@zte.com.cn
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Luiz Capitulino (Red Hat) <luiz.capitulino@linux.dev>

> ---
>   mm/util.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/util.c b/mm/util.c
> index 80f6c714844f2..338f259b00351 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1406,9 +1406,9 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
>   	int loops = 5;
>   
>   	ps->pfn = page_to_pfn(page);
> -	ps->flags = PAGE_SNAPSHOT_FAITHFUL;
>   
>   again:
> +	ps->flags = PAGE_SNAPSHOT_FAITHFUL;
>   	memset(&ps->folio_snapshot, 0, sizeof(struct folio));
>   	memcpy(&ps->page_snapshot, page, sizeof(*page));
>   	info = ps->page_snapshot.compound_info;
> @@ -1437,14 +1437,15 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
>   
>   	if (ps->idx < MAX_FOLIO_NR_PAGES) {
>   		memcpy(&ps->folio_snapshot, foliop, 2 * sizeof(struct page));
> -		nr_pages = folio_nr_pages(&ps->folio_snapshot);
> +		/* On races, or when freeing pages, we can read 0. */
> +		nr_pages = folio_nr_pages(&ps->folio_snapshot) ?: 1;
>   		if (nr_pages > 2)
>   			memcpy(&ps->folio_snapshot.__page_2, &foliop->__page_2,
>   			       sizeof(struct page));
>   		set_ps_flags(ps, foliop, page);
>   	}
>   
> -	if (ps->idx > nr_pages) {
> +	if (ps->idx >= nr_pages) {
>   		if (loops-- > 0)
>   			goto again;
>   		clear_compound_head(&ps->page_snapshot);
> 
> ---
> base-commit: d164c7d754f0e1f020298366ea92430e62476089
> change-id: 20261116-snapshot_page_fix-fae185e61c94
> 
> Best regards,
> --
> David Hildenbrand (Arm) <david@kernel.org>

