Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3740F606A326
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=co2U/BF4
Received: by kanga.kvack.org (Postfix)
	id EDF306B098B; Wed, 25 Nov 2026 05:11:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6606B098D; Wed, 25 Nov 2026 05:11:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCC986B098E; Wed, 25 Nov 2026 05:11:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B25B26B098B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:11:55 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4ECC0A8CDF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:11:55 +0000 (UTC)
X-FDA: 85473225390.17.CB51149
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7FB1D20007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:11:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="co2U/BF4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795601513;
	b=GZl/ndfz/FHBvbO3zkbNGrZMeAZxTDWrvrw8bF++hzFnnhNfonLV5tPKIQNh0eCjkPqtl7
	0ucD2JGwyNElQUZa0ML48gsBwJ8twuMrT/YLm5B+q8nMfMpuUXq03RhlwzXmQ5IqC7qVYl
	DDOl/VPb5fazaWU+laaeFakg5zvEqQc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795601513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2lnw2VBoTPe4pSzAj8K8uN3voNBLLDm/zB9vt1dAGos=;
	b=4bTur8XY2PnHdxJticb47tcNI+tSsHiqOU4l05rxqfpKIh6x3oKAmYAEcEKFf9w89FodjT
	OU2ZuaM07xHJdKG6OOzEDKYj7cwDe0ofpy5X86ck3//R8PYITDHfcmgU1hYEoAIjuYKDmb
	+qzKGabVk8PRmO/ziU1PgfhIlj1iFiw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="co2U/BF4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A643B41B0E;
	Wed, 25 Nov 2026 10:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F981F000C4;
	Wed, 25 Nov 2026 10:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795601512;
	bh=2lnw2VBoTPe4pSzAj8K8uN3voNBLLDm/zB9vt1dAGos=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=co2U/BF4t593FB4si2gzyntO74akVWFVjAM2GnoiSXGGOe3RnSSpQnvwwSEp61/eX
	 fJhft5L7UUU5YgscVMCej32sq6Kb8JR7uC3i6FFVdmB9RfSOeSLq9TIRP1jz/9vip3
	 kowt/mYqicPg5jbq0yQ+19kt3IBZVxGd0WjR+w5U5czAUD92PPXk8zob15ABWIBj46
	 GPfYjKCRWDgPaBHGHR82D4+vVEGxzR/9mt+p8Y7un8x8c1fRENuD6v2XffV0Ns5QD2
	 uNC4jNRyoyQF/fywMUKA88+3WVJYwfFgsPhvleMioyUVMkCfHn/yiXZ6THnnbpDFAe
	 tb32jl0dWsZSQ==
Message-ID: <43abc7c4-c435-48a9-8dc2-616095105d45@kernel.org>
Date: Wed, 25 Nov 2026 11:11:35 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 13/18] mm/khugepaged: convert to LRU refs based
 operations for MGLRU
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
 <20261124-mglru-fg-v6-13-8ffea39934a6@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261124-mglru-fg-v6-13-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: gqhjofuyinqng7hnkmx6ey6fi1o4t1k3
X-Rspamd-Queue-Id: 7FB1D20007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795601513-629931
X-HE-Meta: U2FsdGVkX1/nQdRESAmaXBoZBGt2Ol8Spm0Rti48bdfnXzarY92TXYs2iuStlb41fDmX4eI99r+ClnynDqXQ6BCLvVyQrSdY2AOKnUOWKEYN17RTdrozSDQYOJj242F7Q3hw7fBLHeNCoISsN23+fw8z70LEnJc2x0JwPFWrYjxmoN3H6m8K2lHF5ahMOAOyPNei3ikqqoC7voSu0o7lAmgkyynyBjxoeFdSw3661gg2R28HO7aOHZv1F1mewbD2M6uCrBko+pX1Hu1ux6idZ7SIecXj1zn2P7XfDhoExcMi2Y5yt4dqJ2VhMY1MY3wThCtcSo/GyuBYGC+aF95rg8l6pAcYBVeEt2/7BPbPac5zSSMUMDPd4gQtBgSMWpR+DPt8ftMmo5e0xKJE/hVYtGmJiysbhile+cSYOzgqAr5OStc7b2R/WeIBkB+KgzJiKzsCR5mWtSu8u9RAl+kQZ1h6ijOChl/tkNBkh9jO2E/HDvAM5cnUVV59WclyEOetcdMZUW4yx24+mEnQAfxrYRF+Ntzaba+KBu6IcVjKOEmi1IIr08gebhL4UpRkEAjX5f/enf4iNtOZy2eeWvsrzUhmS7q/NMeojfLT4ET25SJgKF8Z6D26zgudV3YmaJT4FezfdJcYegw/NEMAwBoEGnboYZCN2xr5hlqPpc+Ha3mNzNG5AqW/lT9hqliqkP7MeHdZkm57beR+YWsGsK281AN2fKjUL8J9bAPus+QLUvQh8twGZviX0uo80657S7v0GOSQ4+EDvADxDcV2n7FgRSHalHpnsd8jqutiCCZyaJXULzw4wV2Kmbf2MMYlaUPmQjr5fpa1+4VE7jOi2GN4HDzuODr1Ztnl8zuUCavrM5QPdQINOfGPTmBaq72/RnEBuGNgc7fkjOiW77Bc3PU+ULN8OewHUFJHVjldIYr+H2pAsrDt9bdNu89ehH0SOta/NNF6NuprHpP7tqDzT7m
 yqN7PVIC
 rjdZH3tPBk+ry0SG0ZOTGb2j6jN05QJEOfnxgpkRXBuMJe7bFjUTk7FAjAuioUsH3REDVt9sba4nk+FOfhbewAPhvjScPZyRyjISxqC97/AHgTYUnL7wN8UQThhlYBo8SQ4qi9UQM6FHNsGeu+Dt3WJ2+vJ7Mn6YgtFxkk5vx36dB3i9pjcfXQhy0gyQa2yajzjbpRW8IIjiJCcM8vTOzyA9n39sK5oYJdiJ3K5pa7XOm3Ayo5D360w+TWHKcBXwww/TsTgTn7jGTqTIXwag8a/Ke8awr5Ov0r7NiMsdXV94iS4Y9xVRXKif4YP7wBNhDFxVdMxYBq6d6zgx4By485ZklM2PNgP9SnxAV42nVsG0f4u5WrHAssYGUdLRAmjv8netOXMPj30NhwHXJ8sPoh7LxjGbG/iETZHRP6POPeik4Iw15Iub7sy0rT3pmFUVF1riPYaPvMxwOOIDvscKzrhDb5nr7h3h7Vxym8SSdMYe+/xJcim/JWE86NbjzYaA+uocckaTdwPfYhwl8sROQn1GNkfNL7+HvA/RjQbJ9z6Y6HFtqwxd4r1R0Rm//SoAdPGmaQagKIITkI/TTDrYP/d1+ZbfF9IvciKiN8jE7d5jHkX7da1z0l7GyYN41YcsHEZ3oN0VrWWQc+MYnYP6/jFW9O5Xt6l+UIn+dcTsorBk6GlY3Jp7byt7RT6TQ5Urc7Ct/9B9VurmlfTh60PrIBpO3eg==
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
> For MGLRU, PG_referenced is only the lowest bit of the folio LRU refs
> count, so folios with nonzero even refs no longer have the bit set.
> folio_pte_referenced() testing the raw bit misses hot folios at
> refs 2, 4 or 6, under-counting the referenced folios of a candidate range
> and aborting otherwise good collapses with SCAN_LACK_REFERENCED_PAGE.
> 
> Test the refs count directly when MGLRU is enabled, mirroring the
> smaps conversion.  The classical LRU keeps the plain bit test.
> 
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/khugepaged.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 2dc4245814df..5e768481ac22 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -579,7 +579,9 @@ static bool folio_pte_referenced(struct folio *folio,
>  		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
>  {
>  	/* The folio was referenced previously ... */
> -	if (folio_test_young(folio) || folio_test_referenced(folio))
> +	if (folio_test_young(folio))
> +		return true;
> +	if (folio_check_lru_refs(folio))
>  		return true;

Why separate lines?

Also, is there some way to abstract this that core-mm has to worry less about
the details?

Some helper that tells us using nice semantics exactly what we want to know.

-- 
Cheers,

David

