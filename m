Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6B3D606D811
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y8XX+R/3
Received: by kanga.kvack.org (Postfix)
	id 1F1416B00EF; Tue,  3 Nov 2026 10:12:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C89F6B05B6; Tue,  3 Nov 2026 10:12:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DF9C6B05B8; Tue,  3 Nov 2026 10:12:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD3CD6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:12:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79C4540477
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:12:30 +0000 (UTC)
X-FDA: 85394149260.25.F3B2380
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id BA969A0007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:12:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y8XX+R/3";
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793718748;
	b=EPl5wh1mLAvljBOJJkx/EnC2GCMSx3OEP+HA5RbhWCdfabAn6ekRF0YvIUWuR49xGRWGVo
	VDzSjebq/qiiszBWoKHxOIJOkjZZfM2cvQhFo8pql5tvlefr/GlijJYO8r0UdjVmFAqk54
	nS+Ej6dNs10LhGNW2R0CmFHu/bCsDa0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y8XX+R/3";
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793718748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zV1T+I0M/X5fYajz5gf/61terI3BQ0fU42btgMq0usc=;
	b=LrXQ0/AtXH+T2vMSRJCSG9tYOyw8e1N8XEosdnAyz5yrHWiXJVkbf7aqC8SOKx3uloEY3E
	Nht2SrUTqtGmN45ejG9z/nvbYBkpxsYnBDjqUlE9Qawh2hnzxuUNHeTpMdvBbCOMDe1+SP
	KU4r5EJizVwEUWoxdbdS3EJmYFeJ8+U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A999A60136;
	Tue,  3 Nov 2026 15:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E921F000C1;
	Tue,  3 Nov 2026 15:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718747;
	bh=zV1T+I0M/X5fYajz5gf/61terI3BQ0fU42btgMq0usc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Y8XX+R/34RU2qrAch5IzWEomeYhJRgnOPmQV0c1P4ua7aD9u6KoBL27GfTNHLhW4b
	 M+894MvjRu0FPV7UZqNf0BqBv+B3NPVLyYnLJEUvBvfNhTYzb/ZTgeFtmB8zxvqN1L
	 f8DVezDosMAJUoosTpIUr7qnBX3vQNbpsLPOOfx1bEe1EEFPm8kBu30mbWU4I3dxko
	 27z/yk6OveFo3E9sLlQLkZlcZpAGw3pxxon+OT0zrLkv7HhFxty/juVata4jEjgw0G
	 4p6/HQn1Ufn0qLwAYZn70b/sNfSCjlnNRLDhQhgy1o9iXAPrvL/jsm3XC4EJgColuC
	 3OGNqx1zKipNA==
Message-ID: <6091a4d5-ded8-423e-a806-2c4b11f21e09@kernel.org>
Date: Tue, 3 Nov 2026 16:12:20 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] mm/page_alloc: don't undo another isolation in
 alloc_contig_range
Content-Language: en-US
To: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 kernel-team@meta.com, akpm@linux-foundation.org, surenb@google.com,
 mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
 ziy@nvidia.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 osalvador@suse.de, muchun.song@linux.dev, iamjoonsoo.kim@lge.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20261027042204.3741307-1-gourry@gourry.net>
 <20261027042204.3741307-5-gourry@gourry.net>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261027042204.3741307-5-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qzxxftbb3qq9yfzz4r4qbci9j34eysp4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BA969A0007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793718748-858798
X-HE-Meta: U2FsdGVkX1/BhJJKzN8/kLPOzMbClHc6152T9CA//Jj9DbcpfNeHZnoWT1zriuqJEA3pJYIk19GyKHnLKNd8/14B1j5isqvlpw6M/pc3O/FB1hhptIe79O+oPfkVVaj9bvlUIO9OFnAtskq/mxiDXHhveVGiE4N52FvCB+slSVOk+tE2n+hMx/+AMkNOiy6N9EfyRX6ZKqReYLi8UQ+VjFPGKdPaftY/PxZB6/kobDQCxRjqZdEctahZus3tANtlJPaAYQ5eBVI9QM55ELTgLOT65aLwQPQyMCox8Wsuvw2g57kHWjlfXy4dgitxcl7dq0AyrOlRZ4fd1ytL3KigGygbNe+CFSRBm/34XH5yM7lPAonjdL/tPQRkuqRnRJZ3kp2FZVQh5fvM9eYkXA7wG62rkIM+M7DRVWUC5wHPNXqN2touCNbX4Dl4jiHjTxgfUX8KMp9MQOgN2U/gugps75L4y2EVgX5xfhGNDIrysBTBLsrrDtwHWVtXmMHNJFvucKg/4/vBT24QsHCAynPlLIYL+1+SpqrGgDSMwwWGE8tOq2LjSpD+lRiD6IHqxEHZw6lX4+hUQIvfryBJiMEqtlW7u8rnFC3/T+Vyl0grzckSG4EwliP51hDhHQK77xJGJntTap4DxW4NcmDtqJ1ZtKTFwx+nEMEK8GlwEDyIxuhYErtv8jf+7zr0TnQzKTP86870QrLAWIeqz/6zKPVTwAcbjiAff7QhTqZs3W1UhtH5J3NUCOGGWmp2kor6RWGBaqk9Rh2Re9KU0BggcN4oSvozYfTADjW5/HryC54bhQcFEpwnAlPkjM0e4KD4mPtiZPj6GOlkdn6DgIhnIZbtIPbZ2JT8aOMLQdlLWi7Sur4AM9mgtCHbqfcLz/6YAR82Sl5iQAIMOG2MRTPg4F7oPTrZbQMrIdl/MDzHEcZ8CTiEHDA+fnNEgdL68pzzGjibTvwnkrVWGnn4aJ/HqwC
 RMBDk0Xu
 NXQKL9UMKM+/VcijTax4+T8BtbaVGK0mjRgkWAoMRy7RVP8qwiuJ75TrBKl6pdIiWHkazrMF9HvxvJETFiZGVTSWAn1odYdu5NGTG66mf0hSiYY+DVRRzxyQExoX8nOFTizRq0Xd9dBYjC9ue6btDstgfQDgMW6jv0I+jcN/tVxLljSnadY2gHZY/dabeNncGp6hnfsGnZ2q5gtrmPxWw8Lt9DuDIBvhewVop4r+m1++KPrJCV/WOESetT06jcb8TsYFL/zSex9B4YQI4z8RnUSihJ2j0Go083ai5RZCrkDUpmT8cFBnY0f4FmNR11Ce+cKMj/nSiRzBu/hw1sjSxcGKonbSNnx5xJBWmz0VuWVWTL9VuGnBINpWURsqZer6v59zw67sR3ItwRKOxL8uHIWDvtmegTyz2xPF0E15o3EBRAiXsna6uJd7M/Svyf9XZNZs0ONHf/oZDnUOQ9klnsOq/qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 05:22, Gregory Price (Meta) wrote:
> An alloc_contig_range() that overlaps a block going offline can leave
> the offline spinning until it gets a signal, holding the device hotplug
> lock.  When isolation fails, alloc_contig_frozen_range() undoes it over
> the whole range, clearing the offline's MIGRATE_ISOLATE too:
> 
>   CPU 1 (offline_pages)               CPU 2 (alloc_contig_range)
>   start_isolate_page_range()
>     blocks are MIGRATE_ISOLATE
>                                       start_isolate_page_range()
>                                         -EBUSY on CPU 1's blocks
>                                       undo_isolate_page_range()
>                                         blocks are MIGRATE_MOVABLE
>   test_pages_isolated()
>     never succeeds again
> 
> start_isolate_page_range() fails only on a block someone else isolated,
> after undoing its own, so this undo only ever clears another caller's.
> Return directly, as before alloc_contig_range() went pageblock granular.
> 
> With offline_pages() parked after isolating a DIMM block and a 1G
> hugetlb allocation made over it, the offline on base still loops 30s
> later in 4 of 4 runs:
> 
>   offline_pages+0x5b2/0x1570
>   memory_subsys_offline+0x17e/0x470
>   device_offline+0x250/0x340
>   state_store+0x88/0x110
> 
> With this patch the allocation still fails, and the offline completes in
> 3 of 3 runs.
> 
> Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

I've applied this single patch to page_alloc/for-next-fixes and will drop
the version from Josef [1]. Also transferred Zi's R-b since it's the same
code change (plus comment).

[1]
https://lore.kernel.org/all/20261027-pgalloc-ai-hotfixes-v1-1-9c7d1aca801e@kernel.org/

> ---
>  mm/page_alloc.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 55d3fc4b307f5..bb3c7e95f2ed4 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7396,9 +7396,13 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>  	 * put back to page allocator so that buddy can use them.
>  	 */
>  
> +	/*
> +	 * On failure this has undone its own isolation, and any other
> +	 * isolated blocks in the range belong to someone else, e.g. offline.
> +	 */
>  	ret = start_isolate_page_range(start, end, mode);
>  	if (ret)
> -		goto done;
> +		return ret;
>  
>  	drain_all_pages(cc.zone);
>  


