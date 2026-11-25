Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 205C1606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RU7VdEp+
Received: by kanga.kvack.org (Postfix)
	id 3E11F6B0989; Wed, 25 Nov 2026 05:10:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7BA6B098B; Wed, 25 Nov 2026 05:10:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5F56B098C; Wed, 25 Nov 2026 05:10:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 043406B0989
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:10:47 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82E12160D90
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:10:47 +0000 (UTC)
X-FDA: 85473222534.14.270FA24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C4FD5A0004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:10:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RU7VdEp+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795601445;
	b=biGsijstak/BdO1sEE86bxqAPKMshnZ3nF93o3T7i9OgbAnZEoREqpAJuJCOWGTezWHONq
	d/5hV+lzOx0bDqLErSC8ugjwtYfqKbcv3hxOZJNoej5eNMVT6iQO2fVW+bC4at1Y5m7r07
	v/6vvZEb3zeo581eLUvdYaWWWG04qWE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795601445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mu024QmHDvgvYMUVNzXnXivyqSL4wI/j3FC6aH6IbZ8=;
	b=6zLQeHzyOMGdP26AmWEnw3ZyoFiEiDf5YDzWgQ436BJ0stakRbw+gxksPM9EGsr+6+2oFH
	7IB5Co9iQAOFosBg5t7dNMBe3xKPveuNb5wnY5STlw1Q7WUxCTCLV6wgwHqJQsorvk563x
	t0MGxlt/SPrwwd3wMSlGXC2e83R7OrA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RU7VdEp+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B15262557;
	Wed, 25 Nov 2026 10:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CB51F000E0;
	Wed, 25 Nov 2026 10:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795601444;
	bh=mu024QmHDvgvYMUVNzXnXivyqSL4wI/j3FC6aH6IbZ8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RU7VdEp+uQaJQTpx4ry0WTeOcxTev6KoYGQJYDB+lzjlmCfZPn362tXFwosYKRSkf
	 dpUd4KPHR1KjAlpkI6+3pZhUBWdCC0oo9t2ne/xLDTNvZWvBQ+ryFsAhP2sq2bMxUh
	 vewss76bYYnlC2qfeKk45o43f30xxCXaBatgNH4XNeubPGRA7rA6pAdqgVkVJbvflp
	 Bi97DX6JK36dRAQdZj4BnREXCiNqMn85w998eS0D2lyJehBFUC7yiEkN+8Vra5hDqY
	 6mDdC82jp1UZLmbZ75glZCe1YpTameE1o5BOkX/xojSGpLbwLc45H98z30LjJpTKZx
	 H5Wm5zJYDBKBQ==
Message-ID: <fe08f69a-0e62-4e4c-b87f-d4f3f9fb2a0b@kernel.org>
Date: Wed, 25 Nov 2026 11:10:27 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/18] mm/madvise: adapt for LRU refs based operations
 for MGLRU
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>,
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang
 <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org,
 Tianyi Chen <hi@tychen.cc>, Ridong Chen <ridong.chen@linux.dev>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-14-8ffea39934a6@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261124-mglru-fg-v6-14-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y6cozjq9j7owkcbyjtqtoqnf76rkqwaf
X-Rspamd-Queue-Id: C4FD5A0004
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795601445-566613
X-HE-Meta: U2FsdGVkX19j4/I7S7NYY5Xu/F94htelAHBg8XL1uoik3dBGzT4zo4X5HrIGSXrdQ8xf6lfnyxKoxr3ngg8wGfsVL9Y2YAZm5484YLNDtkUR/lxBPlf5JSlYSoTY/zb+DBug2LD/Jd0p7cY8FPj1yIjaX0ilk1rbfSB9scNONdoCBdqf6q+9fliEFPCdBOkix7FWzQmjib2bUYiSVKUpjXoq4GCtsrVqlUHCOW5Q5j/gSUmZhSv3NDCRfFSEFeC8zjLtF2hpt/wBv3aBki7ExFj2Xo5qjronOzGJ3OXvoa9vU8jbf7kCYqQ9cFnwS+JR0W30LEBWvg6BnAwrIGapzIVtNzMB+vDxLwV36iBaYOWrE/5iBu2bVm47jf2AxJhW8WwlG0BvvGX4/rOVmk2+khI7Dk0fiGVQZMfPLHk4dWi6liYQplLPJpNzIHAdIOJ+QQH1wzE4U7G70WMOl/UB6XTpFYMPD5cOzz6FlxfJZtmowEz622T9ybL9eXUBjcNhwJoWv/WKhiVx6HJVqxaRKiSygzbTRtlU6L7TqsZytxY6vnG44tDzWCd+Sg2SOUfo/8ahX3lLzGn92dyFIyASQnFWw+MSw6ilTAHtvvN3wBCP6BFu+jLDCSCBHqaZJHaXFTboYC2gVu605pOgBEfMA0jbU/edn7K+yiiJe4X+FcapDnDaX0zgbTL8egCefDHQ8sQkG1PmB/cxZ9uwXCWlfZxKIkroJ39NGbyXB7c4VpIPnRE8cqXvgoDDL92/TBPXIQqV1QTROak8G8WihkVmehlUfzpXL/y2UGfTRZ9TpUy561o8nwIM6I13rRJICKV4keXVo2kZ9G7YlJByOx/N0ad/wOQR3GjHIDdeHP7iL6Br9y4RDtWtFz4oipejVhRtWQAZHmGZbxED9Pfvl09HvkENkAaLt1MA5WXGi+P2TOHvBITSzhLzYyXiIwR7T4Dts0CvCXqb29s8EwYjTPb
 7Nv1wHtA
 pRoVsUwGkEERCV2mMJxfNLOEvDE4ZiTI99LdhhcJJbsNom93wjg5dBtUTiUtmRIMNcgjtlqHY59GiEzdqdxPd4jokI3Wp+9yLAHSQEkAU+km6c6nnOKZ0g7ksqjss0O4yNOau3nETmOzX7fui5GSWuUCMopyIA9/47V9murDe2y/IG+9jr48W0upFCcdElI+3wl6s3qJJJJEjThMh0Qc+a2yfnguNJlR69EYwvh7LFiXWySrufoSI+DFvxbol5mY2QRSWJQp80woiF+2XCZx6zOwprlDbSLL7OsOG2Iyo3klM7fyhLVLoHUicKbCBiWMyzdHvN8J0e4OQXGaelF6SkiTPs1Uhicjh9IGEW+UgOamioTPyPyju7X8oRzLZQ9W1sBl1YuWzZNeS3pvXxyjrLnTPLxAuQ2KufAPE50oQbuCfXaFliK/ITV5POwpeNUqeeqd1TAb38RUpMQ+7B62gh2wA5WhKBnkgztgZZXpqLZiD67VYsTjFWGTVAmHz9DfWwPNfQKS++/lh4b2XqG7jC26llihbB7lBVHiBg/ogU8moyTs/+F2vmEThTVkA86i9FD6QC17aecBIH8xX63V7rBFJvoqLKkiBveC2qTVECo5d0CFoVh1iXIqeDjOyHxM5a2yb39rvQo3mzDhgpQiVSf/9C1vwKZ0POkhH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> For the active/inactive LRU, madvise clears PG_referenced so that one more
> access is not enough to reactivate a folio, and keeps PG_workingset on a
> folio demoted out of the active list so its refault is still accounted as
> a workingset refault (PSI).
> 
> MGLRU keeps that history in the folio's refs count instead, which now
> lives in PG_referenced, PG_workingset and LRU_REFS_MASK, so writing to
> those bits directly corrupts the count. The two hints want different
> things:
> 
> - MADV_COLD resets the count in folio_deactivate(), which also requests
>   deactivation.
> - MADV_PAGEOUT clears non-workingset refs and caps the rest at
>   LRU_REFS_WORKINGSET after isolation, before handing the folio to
>   reclaim_pages(). The hint marks the folio as cold, so the
>   eviction shadow records the capped count and does not inflate the
>   eviction/refault counters of the hot tiers that drive aging, while
>   folios at or above the workingset threshold keep their PSI
>   classification.
> 
> PG_young is cleared for both LRUs as before, so the referenced walk does
> not count stale history as a recent access.
> 
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/madvise.c | 54 ++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 40 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index a36cfe98dd81..7e562e78d52a 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -360,6 +360,42 @@ static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
>  				     FPB_MERGE_YOUNG_DIRTY);
>  }
>  
> +static void madvise_cold_prep_folio(struct folio *folio)
> +{
> +	/*
> +	 * VM couldn't reclaim the folio unless we clear PG_young.
> +	 * As a side effect, idle-page tracking loses recent referenced history.
> +	 */
> +	folio_test_clear_young(folio);
> +
> +	/*
> +	 * For the active/inactive LRU, a folio demoted out of the active
> +	 * list should have PG_workingset so its refault is still accounted
> +	 * as a workingset refault, and the referenced bit always needs to
> +	 * be cleared even for inactive folios. For MGLRU, MADV_COLD clears
> +	 * refs in folio_deactivate(); MADV_PAGEOUT handles refs after isolation.
> +	 */
> +	if (!lru_gen_enabled()) {
> +		folio_clear_lru_refs(folio);
> +		if (folio_test_active(folio))
> +			folio_set_workingset(folio);
> +	}
> +}

These are all not things that madvise.c should have to worry about. Can we have
some call into folio/reclaim code that will take care of this?

-- 
Cheers,

David

