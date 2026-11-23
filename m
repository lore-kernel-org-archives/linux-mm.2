Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32101606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 07:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LkFCWuzw
Received: by kanga.kvack.org (Postfix)
	id 5DEBE6B05B0; Mon, 23 Nov 2026 02:36:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58FAF6B05B4; Mon, 23 Nov 2026 02:36:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CC306B05B5; Mon, 23 Nov 2026 02:36:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 326336B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:36:58 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31645A084F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:36:56 +0000 (UTC)
X-FDA: 85465577232.29.12C0323
Received: from mta0.migadu.com (out-208.mta0.migadu.com [91.218.175.208])
	by imf18.hostedemail.com (Postfix) with ESMTP id 07AC61C0004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:36:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LkFCWuzw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.208 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795419414;
	b=SzkiTnBp82MML6QOu9f/U43zoRe/oth3W1oWZxbFeLaeZ3iUrWoK2dOFvjArIRnG+GWC+b
	DYhZSOUdeg4Vrq3aJvAQn3CeIejzPdnSII/6lLqCmyscYdEZjuJNnGN9NMWnTwfrtiGXiP
	Jclupy4Tkdzunl/mdzjpT3GMUtaSG80=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795419414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=81kPDDtvuE4JtMEIOKgmGIVDhK7QJRekDLof38gkIYo=;
	b=K3mUnyF6oL7P7KfDJEmrFWX70N5wTCwL4sjyGLzsKMUsQ5ofJZC8LtN9lsDFugII+gI5gd
	OU3/cofO8Ucep/lqZQGQErtYfTpD7USDIe0iExXgJyMgtllkv0boibNtbwS0QpTP+yY6nj
	FwlkKvBLgdCcQQPEGpTHmNas7J77FCY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LkFCWuzw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.208 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Z0+DZ4FEhHpDonNvxmZ+TUvjKPTgnZDclyV2sAUO8uQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795419412; v=1; x=1796024212;
 b=LkFCWuzwvy7MP9EXNHz6uLPt7ONXZq9bO7ivI5WJ0uYHqgO5/fmWts+EDS7aa0l25nNoritP
 lZl0+LZJVSJ9xxgoDCNmx83UjqRJVuNSNLHDcoCUTMTWZQ8b59zBU5dFGEkvQ3vtisIjoQYtOXe
 hScpuE3dQxHyOR9A99KiRIyA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9884a88ac428a34a;
	Mon, 23 Nov 2026 07:36:52 +0000
X-Mizu-Trace-ID: 9884a88ac428a34a
X-Migadu-Flow: FLOW_OUT
Message-ID: <dcf39487-2b7b-4c67-a26c-90f3391e1227@linux.dev>
Date: Mon, 23 Nov 2026 15:36:43 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/11] mm/hugetlb: use common compound page
 initialization helper
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Muchun Song <muchun.song@linux.dev>, Li Zhe <lizhe.67@bytedance.com>,
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-8-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261120100856.16929-8-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 07AC61C0004
X-Stat-Signature: 9f97og7zs7uy1eqx57s6n7u65hye86hu
X-HE-Tag: 1795419413-241054
X-HE-Meta: U2FsdGVkX1+9ge3kwa7O7mGTQG4Y58MvwLdD11tYl3VxnQPUOWzp8qJ+6hAqmS+AXdLoGbpX44ALzTzOysqRyaY9gju8FWundmrmuiuJ6D30zzCRBPScEQy9buGOg1YwoxVnZOdmMi9vzpzLAvp5dwnbXArOs2NXR9E1+kvZPQ0Ur8ogIUJOM4knbzVK9ERWCz1oHVsuIvC0CTEYpv/QaYdJy7MDIkBBz3KBvtPwndALodEe/9GZjwJenoBNByQ3DqOrTjeQ3y+oRCuKaZTKRCW4ew1rim1NupMO9WCpbNbbeH5zo53EInciv3ImnFdYutR5KJfTLSwWNuxC4YRn1/vIThhOxaoDHowBokXTZez26G9gZCeRbZMMH57ZgCzZQuwPgjhq61UC0mS/KA+6IfHdJtnum/5PxNT1XUQWAwsJuw2P+zTbGe0tMrsqcx9L4tGZX+b4OqySOx4q7r8RLp1bx6/haOoWrMwySdxwjPcfsyJsUxF4sXGST8fRMshpZL+82iqJ+FPYM6vHg5OCh9tPBRvu4ybSzgNSNKvRfoPCIDDkZkGwMBw+9a5yUuDWVVWIiF5800DFhWQXno+IR1Fs95S7134Dy3isauXuIvpz+8FSpB6zVLucuEUlt+dMszL2i5BKbswJWuKVe7yPV4hhGGEf0looXGaD9o6HGVmzJI93t8kJj9xchJDqEwdeyqfCyUoaDXP+tcv2gr3mZpv0slyqiCuauvY8HiBFBqxnlLW8aO7MPOuFQanqLpAytwFE0edi7F2Ct4e5IQ0SeEW9WVkTMwDftgvrkuOVibJk9Rs4AE91O6DhkM5u1f0e4C6N5zYQzDsc9fHw185pAmu98nETXwxRdgSml9y6ZvuPZ7O0jOAfuOyRwOdYDVvFxO9DMEARkTYHKef8mxaEU37EtuEGIGcSf365cXsEmwxAzMSbq/Micaja8jtEOWf4vEgyzEOawSDpdck/FVq
 usXu+Vad
 aP3sFiarl+/BR3hgSVHvATNqkmkPj5M4pxnb5M3fd8iygcN8Xru8EpfsHnopPU3es8uTj5zFdytup3DXLT0HUFAUlxTc/6ea5z3k5zWC0s2JbtKnTS1ut9Z8e6G19f4ivc0G6BHKZ16VnqzCrt14epantG1LaglgsMqY4vWf4nOtr3n7Sv3MHe6C0Vpc9DhI5D/VDuP440U6pguP6JigQmW1DnkVbcLljQoXwnZO9uBYVCjOh/fwE0S7g1JxvwxxVuoS1P0E45PLLBDQf0f/3Ey2vD9mf66hy4ynXSU8kQl1B39W2aoZKKpvPGsB6WQ+Cd56AtN9AUWQzsBRyWNoj0Tsgu1aHjXr4ViEwXjbUMFSH/+BNUbgIecKBlAObfovdiA3CABn3BHxnCLeXA1pfI0QWO39kYtgjv/WnQQjUoOUZ6/DI68E6S+l9D08P04DjFVgWZ3KrkraLdqQl0wUsAbOmN+fsQE3bSsjprodvYX4iGikDJ3tXlecMXiyLwgCiGlGq0V7L0TJeZin61L6Cr4ForxROJdkDfCbXiPprGnriIY0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/20/26 6:08 PM, Muchun Song wrote:
> Boot-time gigantic hugetlb folios currently use a separate path to
> initialize their compound struct pages.
> 
> Use memmap_init_compound_page() for these folios so that HugeTLB and
> ZONE_DEVICE share the common compound page initialization path. This
> removes the HugeTLB-specific implementation and improves initialization
> performance.
> 
> ZONE_DEVICE initializes struct pages by walking one contiguous memory
> range. Boot-time HugeTLB instead initializes multiple disjoint ranges,
> one for each contiguous hugepage. Measurements showed that memcpy()
> performed better than memcpy_nontemporal() for the latter access pattern.
> Therefore, use memcpy() for normal memory while retaining
> memcpy_nontemporal() for ZONE_DEVICE.
> 
> The initialization time for 64 boot-time 1G hugepages with 4K base
> pages was measured as follows:
> 
>    arch    without this patch  with this patch  reduction
>    x86-64          195.60 ms          170.40 ms      12.88%
>    arm64           374.40 ms          237.60 ms      36.54%
> 
> Co-developed-by: Li Zhe <lizhe.67@bytedance.com>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v3:
> - Integrate the template-copy optimization into the common helper switch
>    (suggested by Mike Rapoport)
> - Use memcpy() for normal memory and keep memcpy_nontemporal() for
>    ZONE_DEVICE
> - Update performance results for the integrated implementation (measured
>    by Li Zhe)
> - Add Co-developed-by for Li Zhe
> ---
>   mm/hugetlb.c | 52 ++--------------------------------------------------

Glad to see this.

>   mm/mm_init.c | 10 ++++++----
>   2 files changed, 8 insertions(+), 54 deletions(-)

LGTM, so:

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


