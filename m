Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E52AF53D79
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 17:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0AC6B0323; Mon, 16 Mar 2026 13:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97AC06B0324; Mon, 16 Mar 2026 13:02:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866A06B0325; Mon, 16 Mar 2026 13:02:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7016D6B0323
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:02:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 11E361A034E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:02:02 +0000 (UTC)
X-FDA: 84552543684.30.68CB395
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 55CB6A0002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:02:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RRylpIw2;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773680520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EDEzAu7iXfGF9KAKdvQsOHbXlhemKN29+aR8dv4u33g=;
	b=MRxi1FIcyXwTHws0k8mhSaZxlK14C65JtoSQ7QGfSJGN/Xo+Q9VwtB655PNCW0bEt+F+wj
	YP9EQRiqaGHKJBM+SHpH0iCgw9bC6gLV9IfsxFFy6qYilkadAODrl+ZB7T/g3TQsYLTVZV
	bQ2v0R6VaMURbZ5KVanNYI+22uJQwhU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RRylpIw2;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773680520; a=rsa-sha256;
	cv=none;
	b=74goupRRJ40tl+ogyBVcsoPJhp31wom3IYb8zyvTLI8goaUfyNu+oK8enejTaGK20Xugjp
	5nfNuZBIWVqChUMKcHMKOR76GPIT5eRxP8DdVUM2DTb0xw9BitDf8KaEck8rWWk4NbFgZt
	vYunwQKOirY+ZiBkjiK6yY9BVwFM38g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9918260123;
	Mon, 16 Mar 2026 17:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270D3C19421;
	Mon, 16 Mar 2026 17:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773680519;
	bh=ETulvVJzr+X1Ku5WeaZkYZesCeUYQzFa7GOml7F5mxs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RRylpIw2eIVb7L9jiz2iaEGM/RV33gOA0TX/2UtNgBjLDL0za8hdtwl+ym1TAAdYk
	 rO/D1H+L3G1jrcZpLbeEc2exebBJs2fRf1RQSnrbK92Ngemue+WX+mZAgPQwylYlg7
	 rrtziz7OHiiUjLsV2PO6Yt6gNFCMroC3kGBcfKE8WHHNOqhHgy1Zpflx1aZ3o4n18g
	 2SQZtJwZ3EMpYh5DzRdtBwa4OzrSQGhQgJB35B1KNH2DyUN4F/07GxjVNpC7KsxmEa
	 xO/vDMwFbDZ32X3ASDl4Nm10wMbRwhWHgoPD7VFx16hAd1yqWX/C/XUKbRXao8DJj0
	 E3S68YKLGpmGg==
Message-ID: <d5755c59-d010-4770-b26a-b233fd000190@kernel.org>
Date: Mon, 16 Mar 2026 18:01:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 12/18] mm/hugetlb: Remove fake head pages
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-13-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227194302.274384-13-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 55CB6A0002
X-Stat-Signature: ku4uhndxp6hji3e987szmk8nxru6qnjy
X-Rspam-User: 
X-HE-Tag: 1773680520-991271
X-HE-Meta: U2FsdGVkX1+MD9qBDayia6q3k/kxAKtG/tLv3RUumxiC6SXL4ejgS6Vnzb0m4XEGYvUQ3qJJr997qS0EeerjpGiUuXYkiZEwrWurCMQbdla775sb4nThxkpzRUZSc+HYo5QLvxtImjbjui1qypkPcptGlCV3yStPxcGkMSpV9LahOZStKi7G8hhNXHZ+HJywV33u0ZtX5hMpky+IVqgJYWqlqi3594RihJKWOyvdKCQ3Qt3hTfHiZL/ueIbYI8ifz7VpnzxjiKkqWn1YKgXlhU3Nx5ag/m04sXf6QeRVAjz2CVo+i6GXRCjCQx2+eabnAdD5VmHY8XSPXHRsh5Pgv0HhYWG5GPG7uBUTKX+m+T/OQ0SBzAXHY7s7bLBUttkFjLGhZV/W5sqEazN1/oOHrofFPakh7K7GjqxjqgnftK4d086WazGyRKtmvWh9ThpJNLenzQgrqoiJtTsVkc8uJjr66eSghQ2tdpfmnIlB+jBkuMOT/LK6SBilwRoHx4CqV1OIvjC7RLcAx9qW6WsmcAndHT2JyMK0z2Gmicb1sAwCGTNEQ0bu9vSwLJ9dRVX1JdAQYdFiHSPpzOSJH4GBoGyV+bjMe7kih1lxG8+as+frUOSiiUucQZGUd7BUuAqIgnMdh8O8ONMvMqhvJMeZTF8iiLNJXiwlpB/gWTfFUHgATGwkDvInKhcGS39IArZdecgxl/EBHcLN+0AfKXP5DYzMdSAWF2o8PQkv1n/ks384f2MrUQXCjMX+RcFcRkV9yMHHR8ejIPQbTU5s3maMmQEkflXGISCCPyFSBpUBGn+hueFsmQzz7MMzQbH0US2lftUG9wENFu+gOMg6wQieT2QRMqG+Ttryd4oq57mGsAhq82QwypoFTWaIeNstXcD9yhovzdYPBeo7qCt7nhlZkx3tf5Z70n+896JMq0MBxMFemNmh/IhfDh3x9ABjdaGPwcwWCi/aHKWcE4zW37y
 8uWri5FZ
 S4ZO1LPxMRGAriJzPmeGC7SP8QRPo+E1u0b13aW1E6NNQBW0cFefJM4EtdQkNReF7Huy24YEVDAdzG7nyy3MIB2v1CSSmrirygRvN+7WpVicrKnMj0aaqNa73m3zsV92x+D+LXC3kpRLQqG8Hdwio0fbx/cmYZ/OY3UOteeI/iasDBrGMcxghRfFNNoTaalXLVsH4MU4g7IMJo7XO7wIEUHyH6QVkhSCmbiXTr+wxjLViNdiNX0rgDwMvFVEwNa2aNNJV/7+gllTug/vRzc1uALuU6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 20:42, Kiryl Shutsemau (Meta) wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> HugeTLB Vmemmap Optimization (HVO) reduces memory usage by freeing most
> vmemmap pages for huge pages and remapping the freed range to a single
> page containing the struct page metadata.
> 
> With the new mask-based compound_info encoding (for power-of-2 struct
> page sizes), all tail pages of the same order are now identical
> regardless of which compound page they belong to. This means the tail
> pages can be truly shared without fake heads.
> 
> Allocate a single page of initialized tail struct pages per zone
> per order in the vmemmap_tails[] array in struct zone. All huge pages of
> that order in the zone share this tail page, mapped read-only into their
> vmemmap. The head page remains unique per huge page.
> 
> Redefine MAX_FOLIO_ORDER using ilog2(). The define has to produce a
> compile-constant as it is used to specify vmemmap_tail array size.
> For some reason, compiler is not able to solve get_order() at
> compile-time, but ilog2() works.
> 
> Avoid PUD_ORDER to define MAX_FOLIO_ORDER as it adds dependency to
> <linux/pgtable.h> which generates hard-to-break include loop.
> 
> This eliminates fake heads while maintaining the same memory savings,
> and simplifies compound_head() by removing fake head detection.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---

[...]
>  
> +static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)

I'd make it clearer that this some hugetlb helper, not just some
page_zone(pfn_to_page()).

Also, it's only really valid during boot, where we cannot have
overlapping zones yet (hopefully IIRC).

static struct zone *hugetlb_early_pfn_to_zone(unsigned nid,
	unsigned long pfn)

or sth. like that (throwing in an __init).

[...]

> index c76122f22294..928e79c7549c 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -886,6 +886,15 @@ static inline void prep_compound_tail(struct page *tail,
>  	set_page_private(tail, 0);
>  }
>  
> +static inline void init_compound_tail(struct page *tail,
> +		const struct page *head, unsigned int order, struct zone *zone)
> +{

In light of the refcount rework (lock/frozen bit), it might make sense
to directly set the page count here to 0, so it's easier to spot and
consider later.

set_page_count(tail, 0)

> +	atomic_set(&tail->_mapcount, -1);
> +	set_page_node(tail, zone_to_nid(zone));
> +	set_page_zone(tail, zone_idx(zone));
> +	prep_compound_tail(tail, head, order);
> +}
> +
Nothing else jumped at me

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

