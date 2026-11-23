Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5346606A330
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 07:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=o8OnsbjB
Received: by kanga.kvack.org (Postfix)
	id CF9E96B05B2; Mon, 23 Nov 2026 02:27:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0B66B05B3; Mon, 23 Nov 2026 02:27:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E3D6B05B4; Mon, 23 Nov 2026 02:27:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0C526B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:27:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 764C44081E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:27:21 +0000 (UTC)
X-FDA: 85465553082.11.0DAF87F
Received: from mta0.migadu.com (out-46.mta0.migadu.com [91.218.175.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2AB2E1C0006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:27:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o8OnsbjB;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.46 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795418839;
	b=SJsgRrCSAkH+eVm9TrcL1EjHHsFvRRau0YbJwQ6ShKQkSCSyY1Ax8MzY7OePGP+4LlDB+k
	W4rrq5nEh3jjqme392Oj/idX7VIdiZagRnId8avdv+ny411MFT8f/fDCmfS8zW4ljnxL3X
	dRPgJk4H7Vhg8QOr4MjZTB69NmqXHjA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795418839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WgehDg6pcaH9Fwnyu9osCErYzzR7cI1YfyGC9vqBeEE=;
	b=j3hDyYHcfpRJjetc52muBkV42XrtYHBTK6kBTKyWEhOLYYrU7DhcPL3irnHWbaRRy9vryI
	Lg9xlQHR/4NlTNHktIe9f85rJ0anKnHBR1gTcB6CTtNwQg97Jgm7KAKph/vm3NZgt3mDEK
	eQR+STnpkszNkpjIhaaVp2i6XKXJtYw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o8OnsbjB;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.46 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=82ciyE0YI3UBAfRF/D8QcRgrNL2qnfQIx+kCfemew/4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795418837; v=1; x=1796023637;
 b=o8OnsbjBENvlOPircJWSJjeWz4aEo33MiMhV7zlMs8EdkrlvyuBREWEgAueyoLwRS6XYPwkE
 nwAM6O/DvSTM9DROdGe6izAyVCrADEOEl9iO4MpMCvneA8A/t9LA+K2FotubuRCL/epPgeDtaBF
 5PwLr/z+gkAdyqpn7jeI47uU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f250bcde65441288;
	Mon, 23 Nov 2026 07:27:17 +0000
X-Mizu-Trace-ID: f250bcde65441288
X-Migadu-Flow: FLOW_OUT
Message-ID: <1d164f38-5c0f-4ea4-9c0c-9ce225498596@linux.dev>
Date: Mon, 23 Nov 2026 15:27:12 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/11] mm/hugetlb: initialize all struct pages for
 bootmem hugepages
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
 <20261120100856.16929-7-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261120100856.16929-7-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Queue-Id: 2AB2E1C0006
X-Stat-Signature: ewyms4578muejppkwqwiegswabfbjnrb
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795418838-32823
X-HE-Meta: U2FsdGVkX1+ISL5c0l8u6iapUhBWSftyyYk9QTjMtdYacGYzumv+BVuiHyLmYPbD+PHAVtbcAkqc2qwV2Y077uwkNoRsmnqssdMwNMv8YFHwd3ms0q9734IQJs9Y/1osRGrhddcrTBI1RN1HTSCFXqG55lAzuzMi6GXjfJfAx+Dg8//+cL9z5LmbtcmTflYTV++1MYDAuRyuqqmapbrTRpuELHjnrDDpuVrA7AdnMJ5p42m73nhzOatrxrzZnzkACKaMRc1DJbiSrUkeuLOqcv8Pr8SS1++c0N9JlEE8mn9ggRDXzTKJE88s0hFOYyY4OIcI6INKCPhImWK/jHoLlx59eY5HWsFxJbuE4svLkP3KtqCYtUk9+7z/fJBy87nBvZgZnEcY9QftAsbrhcXQam2KNAyx9y4FuuNr9KgrEcwYQH0C9iqQgSqnVW2DtFw7DWHfkl/lxShAluGKBU8H1YWKsqMXNiNALSysPi5s+O3L7cx4jjnNIwtsv9DOhtYfIIIurGxtC9P6aLSCWPnXhUkxEyOQljuAJZ1eoWisZXDTUAaAiKA9mc3M/6alwX0VF3oGCe1bzSCr0javCf26MFuAG5F7x4R7LXyLoQgkIujIkGTYsLlMekpopAFJzXI1kgb3PbtxptL8S815gnaWtqUxus6AylBknrzKciQGQDLf6HZI4apeMYfPtzPFavc2W7bsvnUf82rzXVoKEnA/49kpACIc4fXlYcJJz8+oxqHAOp+blZG1T/63nTVa380J5wGk9E3XN3LiTREEl41xyGNXnH0H/Y5XVmACv4SrD53hAB5chOwEAwOHUxS6iZySHQgAJFxxyNsBIb0a4vh9PJgQOe26JcjmeUdL/vRCp1PuA7XINxKY/1x8L0fnGWOfa1qK/obPaWdtUkvFeGyPnRqqER3/TaoPN+JnJnrpZFFe+T5eWAhaOOUs2uffUdJ4/qvZe+XIB1KeSW7HiBF
 9+g/cxqH
 5qfGCF/RyajkC6HNXNml/nTFs1Ssh9qHAmLLcjCuB+4zeKtE+2IJZRhQgU3wyXh0l6VjC+5WGgQ02p5JslLcni6IVy2SVFNHqupmedgFhVuO5648wVH6JyVopAvfHckporgqXnesaceVUeD6YgGJR0z+hvZUvpIp2GJfzJ6USTM2csosAWEqFFt9dqjbDDb193LH29yU3ZSAq/HR8I74tj78NXUi/RQlJ0STAYTg9Y5uTW1yBsY0Ykz2QOdVT3c5hkL9oY+xTBBAq+j1e4c64iB83H7GbYzAG0NghIhc5QyDEiaLyhUvCI69kauTwT2UHKGen1DTLRyYitPSwcCkvLrUgpMYEe/9qWVJFRGMSfi7QcAvOJFS2vkoOYsGrucJVtCy9J0K/D/MA/fJXI910O4LtyBKWCk4KwLkQaAp41zaFE3/DbgaB9tHDCT2WrHMF2V4uf61PMqCwc8qVJt9+ayUlweLNvXhG9nUkzBSkwGwebnB2s9XHTGPiLkqHH/CcUMRy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/20/26 6:08 PM, Muchun Song wrote:
> Boot-time gigantic hugepages currently leave the head struct page to
> the generic memmap initialization path while the HugeTLB code
> initializes the remaining struct pages itself.
> 
> Mark the full hugepage noinit and initialize the head struct page in
> hugetlb_folio_init_vmemmap() as well, so the whole compound-page setup
> is handled in one place.
> 
> This can also reduce memblock metadata overhead when many boot-time
> HugeTLB pages are reserved, because physically contiguous hugepages
> can be covered by fewer noinit regions.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v3:
> - Defer the HugeTLB template-copy optimization to the common helper
>    switch after integrating the series (suggested by Mike Rapoport)
> ---
>   mm/hugetlb.c | 27 ++++++++++-----------------
>   1 file changed, 10 insertions(+), 17 deletions(-)
> 

LGTM, so:

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


