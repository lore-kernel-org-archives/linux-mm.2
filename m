Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F999C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3036B0088; Thu, 27 Aug 2026 12:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57AA16B008A; Thu, 27 Aug 2026 12:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491636B008C; Thu, 27 Aug 2026 12:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D4266B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:32:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1993A0125
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:32:47 +0000 (UTC)
X-FDA: 85147593174.13.C78125B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B598340006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:32:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nIcGb32m;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787848365;
	b=R4Wz7cOySwKL4ac/rw4lN6zCFFRGFi/+kY3YSsdajksTfD2nOgtxjLMpvMuLWEBTyoUa5u
	S5PAjq9yo+IxX2W0Ysm0VGbhL7HnexkEHBJqZ1g2h9K/vUULYt0NpDDKwLConP467H5M4X
	4IhM27upcjjpbFSZ5jVw+BsufwuwDAw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nIcGb32m;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787848365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O2H9pqs8u34SiJIXHKDFq+rwx9sPKmCRJst1ewdjsNw=;
	b=DT90wroDtBP4TNm1manyS4JLH8Jh3XNJwcrNAFjH16LMTuXuQ/KPfl/rh1uNvXAwad2ivb
	KpoLpyjH6PWQqZDy1d0TRnx4ctyQL6QCHFcbyoEmqMcizmEdDIdZlmZ+NiiWJ7JCxIS94R
	l2uyQyJUucyrnL6EdifGCP1bPmeBG2I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 094C24086B;
	Thu, 27 Aug 2026 16:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344981F000E9;
	Thu, 27 Aug 2026 16:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787848363;
	bh=O2H9pqs8u34SiJIXHKDFq+rwx9sPKmCRJst1ewdjsNw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nIcGb32mQfEr6c/fcEN/unuJaN/W+Qai8SWc+gqmzERucF4JQcZxBJAy6tDJ5kwZE
	 9Ni44t4HJbM0K5MQwkd1989ITcJMutInWJLazhW1TRGQatqyvS+9KoSkD/RxEWhVtQ
	 7HkqFznudh4UyftRHSxasaensi8nlbc6+8qPGQpqNu5brWObfQ0/hLADkZNOYh5+Vo
	 0Vo//IkWKNxX8asFOMxmzccBa93DGq8g82aaGExia98Nc0pIBe2l+tZczq4h+zn5dF
	 hk05oD0xVv0KoAdlBHsN8MypXoClZj7LPfiZCwlQVo6x6tlmiwNgODgYrso5oHxzzK
	 z+mJOE49ynIuQ==
Message-ID: <a7f16d6b-217e-400e-812a-528493d45134@kernel.org>
Date: Thu, 27 Aug 2026 18:32:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/18] mm/huge_memory: move unmap and remap into the
 split helpers
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-8-9b43f5163238@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260821-swap-thp-cleanup-v3-8-9b43f5163238@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B598340006
X-Stat-Signature: 9eatbkopzx6opk7o5fdicqoru4ax5xgt
X-HE-Tag: 1787848365-418609
X-HE-Meta: U2FsdGVkX18QKjTRxh2B8dPvduCFB95Dhw/f7OD/rVGeHDvm5blSO2MYDxwZkxpqqYpKtZtD1erAIql1TEIT6bZgYBcumJ7Uw33hucFChQcic7Y550DuwF+ZRZJw1BoH43VTft4Jm8+pa+Z+TaaUlsy/56u/XAbh4Wnp8PfCC5D6Q5Zid9GkAkE8sMKPMrH0jt1MqxXXHgCaBLUrqLrJlEN0XAs9VT4vD5aLNrTqiDSieWYAQHSfpJza9PSrrthkSRlwagTWFVbjUaKc+62MYbQje14+28lbtPQkNfj4x4497MwJ6UjkGIaGWXmnHZ7jtjPyn9YkNBQly2P+ZsNEGYTqUZzyORbIBlJUF8i1JrVxjiMENPqbKhgYp3lr4r5HHnIYL1WXMzwlip1/2iMiDmwYgqEH4xCzvVwHKKdPuYBS/yx7V5opcRF/Ewvz8YWOSmCsOh9WDnBe44X5of2apV1JAAiFI3k6hvXRksQVPIyTcVRejdJddj5LZ9oj4JPirBYaLM1WhmiIiRt53bzOqCdzKhL5oocVIFy0haCGQzl1NhPSgFcFOIlDx2EGpHz4jlCvceR55dD5ihd20BsgdM0GHBSnR9Adwpk7AxzC4mo1d3Uv7h0pji79RnePR1hBlciae5ULM2LM0qm6skPme+CFtCOoyQ1gvHWgd+VRTgsd2dlYRmmzrlO7zf/M5m4NGwYhixOsiaoL9/mwvRNeq0EMROkM9o0mfZWKy7zvTlwPuCTwpn/UfLXUqkLn9CEOapMC3YOiCYnI4D3+ZEKj5HRYykvIl4bPOs5EaZPhi5eQwKnL+ITkdYFDxl6ELyYmDyAK0saFd74mqH1bCI0C4WxH5Qigdvh0O70CLYCGVPD/xORKAlq6prI9CtgJ3CK4E/Dk83mL9wDZqTobZwzYiCS46LFZyoP2nZJFIJ5YBZW+C26PGpGVaGkVb8faqFMe95zB5u6WUPD+J/EogBz
 nMHaOXxY
 wrloJ9JJbsJ11RhuQPsZbVh2yM/C43PgobVhE2hl3sdhwYLbZJneW8AVBBrW3UYxuOiklQQNIzWAaFRye2/3egw/Wuxm1eH2Ds6PMAcuXfh4usPhNHgW1W3fpCEGUZoyBiUdnTRUQcJtleZO7l3UTHUdCN+6klwPCBhO1wZDrpq4kSmmQtQYULK+GWG57LBagMi0KjxhxuqReimScVJK0/D6tDjSlk/+5ge/wJ0vkdnh/gS0VSWZiIZXxxgnVtNg+QbJAqGRtzaarzcbL4TL/ddU17CIZl6KWXpmRiPUC6jS6W0bkmyU3Kx+0hEI1eTlJKRqErDgjJeujp0VgVN0YC5SnuNZrX9L7Q+oh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> To prepare for further cleanup, move the unmap/remap handling from
> __folio_split() into the split helpers.  Only anon folios need to
> be remapped, so remap_page() is now only called for anon splits and
> the anon check in remap_page() is redundant and can be removed.

I can understand why we would want to move the remap_page().

But why the unmap_folio()?

> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 58 ++++++++++++++++++++++++++++++--------------------------
>  1 file changed, 31 insertions(+), 27 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 01c8cf428595..af9c2edd1fba 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3589,9 +3589,6 @@ static void remap_page(struct folio *folio, unsigned long nr, int flags)
>  {
>  	int i = 0;
>  
> -	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
> -	if (!folio_test_anon(folio))
> -		return;
>  	for (;;) {
>  		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
>  		i += folio_nr_pages(folio);

I think we should rename that function now to unmap_folio, but likely better
unmap_anon_folio().

> @@ -3933,19 +3930,23 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
>  	return folio_nr_pages(folio);
>  }
>  
> -static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int new_order,
> -					      struct page *split_at, bool do_lru,
> -					      struct list_head *list, enum split_type split_type)
> +static int __folio_split_unmap_and_freeze_anon(struct folio *folio, unsigned int new_order,
> +					       struct page *split_at, bool do_lru, bool unmap,
> +					       struct list_head *list, enum split_type split_type)
>  {
>  	struct folio *end_folio = folio_next(folio);
>  	struct swap_cluster_info *ci = NULL;
>  	struct folio *new_folio, *next;
>  	int old_order = folio_order(folio);
> +	enum ttu_flags ttu_flags = 0;
>  	struct list_lru_one *lru;
>  	struct lruvec *lruvec;
>  	bool dequeue_deferred;
>  	int ret = 0;
>  
> +	if (unmap)
> +		unmap_folio(folio);

I really hate that "bool unmap" parameter.

folio_split_unmapped() has this VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);

So you can really just do

if (folio_mapped())
	unmap_folio(folio);

Or have an early exit and hide it in unmap_folio().



-- 
Cheers,

David

