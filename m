Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C73E7C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAF636B00A9; Tue, 11 Aug 2026 12:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86C36B00AA; Tue, 11 Aug 2026 12:52:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76B56B00AB; Tue, 11 Aug 2026 12:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 925EB6B00A9
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:52:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34EDBA0CB1
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:52:34 +0000 (UTC)
X-FDA: 85089582228.04.D809DA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 805114000C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:52:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jvgo3kgj;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786467152;
	b=nA3bIp0cSqfMPwKKV+SOhNP4if1uHoR3Zljtkaswz+IcQ2HUlpFGDVs5Y6jxxoQVLXkj+K
	i99LUmq/R4/hPFx4ZaJ6wnJe5alMcOulj9xt8ysE7xvXRmBUlhMYVSpNfO0ma2+xpXWcMX
	M7LCfiZWEUHXPRVLTgaiyvxml8fimY4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jvgo3kgj;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786467152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mAasdSnBH2Brz4u/CC8frp1bw4E9g00TGcYdxzOdfsA=;
	b=VMzIe2E0IYZkyoJYPvuj2hE9Zgg/9H3Uv2B59TUaFHc7vvyHgHF8bm1suF5EPi/wWJgGwq
	gUC4/AVkjyz7SJIXB4TJWKj7j0duklAF9zoXJaobbpUClHJArz4+FFcwgN+EDXqL6Ufn0Z
	dMhyW9kRk7HpRwjcIsXxuRBDyPry/hc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 15E81600AF;
	Tue, 11 Aug 2026 16:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439D81F000E9;
	Tue, 11 Aug 2026 16:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786467151;
	bh=mAasdSnBH2Brz4u/CC8frp1bw4E9g00TGcYdxzOdfsA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Jvgo3kgjY22ALPkIQ10MF9H8O7gsSZFQkE5mIk5zgk+cuUdPf/TwHKsAj380JXuL9
	 ZJdMXN32JXVeLsOT0zIz9b12l8r78MZdt5F/tur4FrcUEjjg8eJVMI+gJ2YdDcMhJX
	 XJx8LKunvZ3X84G3aqdNdoLAwld1AfwKkD06m/1UzCgr+HDS9N99IbFU0wyXdpX2Ah
	 xRNi9aUI/Z36g+5E5erW4QK25QCCx85ilTwSlJrawqpXWRvtE4/xoHTTOcU6p2Q1cw
	 9iXdpTA2g6Ve4dAwca/wQKOSuk04hk53wIbcp/78Vuj9M8ZMNAm8QSRwxmcf6nf/cN
	 WfAjn2fsV2CKQ==
Message-ID: <ac29dd48-c150-454f-a3ed-d5971db10f19@kernel.org>
Date: Tue, 11 Aug 2026 18:52:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 14/20] mm/rmap: use anon pgoff to track MAP_PRIVATE
 file-backed anon folios
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Alex Deucher
 <alexander.deucher@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?=
 <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-perf-users@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
 <20260806-b4-scalable-cow-virt-pgoff-v4-14-ab318a350404@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260806-b4-scalable-cow-virt-pgoff-v4-14-ab318a350404@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 805114000C
X-Rspam-User: 
X-Stat-Signature: yc38q7nj5ywq6b3zmmrojywhcxchaio1
X-Rspamd-Server: rspam06
X-HE-Tag: 1786467152-671126
X-HE-Meta: U2FsdGVkX18WkzF0cByir2dsc2+aFrd+Hg8nx6kR2DNr09L6lwDAe6ViXwcw5OMSqhts7tkvCpHdr5ga6VOItjlikTXlDWKUmhJ7EQ+4La8rBkFEq4vWzsP0XUA5TaJqYxoAu2pe1VXS1zmmbj43lbcAN5fEF9xMWb6YbOEtAYn5XJa8dc/HwL3jzJ0t1rx4Jjg+tjWfOcWCvV5BtcCsNUpIGv3ptoHpJINvLaAy1f/l9ug/ah2Sc9cfpLZm3vEp/lYN8TIpQWKADjV44PU6+J0gzeUDzFakOVHZhdpleXwyb+wPAuMVRj6vfADXYfb8ySTSYo9AsF9B9ZwkxNtanEt+Vb990fEA7JwdFi6QhtAB54Aue/CKf/eZt2nZgIegxtphnxLE8iF5QJkLHBiKyjACnnl9A2MTNL3j0F3bhGPedymL4CT0suhRibMoJ+DcBkzTewoIfx38yDARDO/w/YOvVR+wug9g6PhuU0xSrM7B7lqXj1JDcQAwhMZLeg7EgTBsq2ooq0v0JP/pz2Z14FKgA9cIczsj6ZmDkgBDoPNugpL9Dkbsfa+kbq9/+H/X6HK+j8SupZVLTtSmHdN2u5znssISFYRQCQ8vQnezwDS5S4IELJxfceo6OzrX9GZr/xPKLxARyw//LqE93v5xHThqtCqn5XmXun2bjKcbLFv8q5JLDno6Yhgot0XwrleDEc4XPtikPdr/LkqlST3akTpdrlb823K4XikXaUc7YokjnqDH35sYW3kiy9UfVOEDtPgwG6E8ARVCMpkZoOXJGnIEKPBWFI1r4rKvBvSnaJEAf4vhpuhJQKiZ4RGpwjVHn6/OigUlpb0ER/IQn1VrwjqXfaivsfljdZ83q4Jm25FNUJJJi85ahRI97wXqBFF2aL00ONffZJVvfsvmOgBD5K6qeu/PkOleOMaZGKhzbdHe1+sRyduQaeTpLY2Y2YYNS/eryzuchHAB+872Id/
 jzaGCQ6t
 QjeYNxfKtkgwk8ZtKywmDOPTp1Me44ujcnRG7ZsJ0PvXexDU6KrPXA5mPU+cFK78W/9gzz6cAnFRWqCr4l8e2R4YZAZ54AE/0ToX2djQUdkzR7WFzkSp6PSqVsbjc2KtWwHZbKxl9D73HUlwuZ+6AIaQiZSEkgEwWsCcD8syFvx8PohDPXEEfhHFkSQhL98vSXwgy1UfQ1R0xGSgArOfb2DvxrHvS0sPgGMMrYQ1N/34oq9eNwIboNfu30U494BbWDLYWv5LefjmoggObvdSOSFOUtKioydgaHe7Q4bXCDgDmehkn3S95byXktQkxKZ8HVudgK/btZ1t0Ds6cNEEBOVve1Fpd3Na6I8PlZxvmy7NN7QA4E3o9ASYHlu18fhk+Etb8D1XR57TeKfVLT0EsObYaZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 22:21, Lorenzo Stoakes (ARM) wrote:
> Currently anonymous folios belonging to CoW'd MAP_PRIVATE file-backed
> mappings are indexed by their page offset within the file in which they
> were originally mapped.
> 
> This differs from anonymous folios belonging to pure anon mappings which
> are indexed by their anonymous page offset (the address at which they'd
> belong in the VMA when first faulted).
> 
> This change fixes this inconsistency, always indexing anonymous folios by
> their anonymous page offset regardless of the VMA to which they belong.
> 
> The foundations have been laid such that we need only switch this
> functionality on such by:
> 
> * Using linear_anon_page_index() in __folio_set_anon() to assign the
>   folio's index to the anonymous linear index rather than the file-backed
>   one.
> 
> * Otherwise using linear_anon_page_index() in all instances where
>   anonymous folios are being referenced or manipulated.
> 
> * Replacing vma_address() with vma_filebacked_address() or
>   vma_anon_address() as appropriate.
> 
> * Updating the merging logic to check that anonymous page offsets are
>   aligned as well as filebacked ones for MAP_PRIVATE file-backed VMAs,
>   introducing needs_adjacent_anon_pgoff() to figure out when this is
>   required.
> 
> * Updating linear_folio_page_index() to invoke linear_anon_page_index()
>   if the folio is anonymous.
> 
> * Updating vma_address_end() to use the VMA's anonymous page offset when
>   pvmw->pgoff is anonymous.
> 
> * Correcting folio_within_range() to use anonymous page offset for
>   anonymous folios.
> 
> This will have no impact on merging of anonymous VMAs, whose page offset
> and anonymous page offset are identical, nor will it impact shared
> file-backed VMAs, which will continue to be merged based on the file-backed
> page offset.
> 
> However, MAP_PRIVATE file-backed mappings must now be aligned on anonymous
> page offset as well.
> 
> In most instances this should have no impact on merging of file-backed
> mappings, which are usually not merged all that often, let alone
> MAP_PRIVATE mapped ones, and rarely remapped and faulted before being moved
> back in place (the case in which a merge may now fail).
> 
> One subtle impact of this change is in NUMA interleaving - since commit
> 88c91dc58582 ("mempolicy: migration attempt to match interleave nodes"),
> migration heuristically tries to maintain interleaving behaviour matching
> the policy using folio indices.
> 
> When doing migration of CoW'd MAP_PRIVATE-file backed ranges, the 'base'
> upon which the interleaving behaviour is performed will vary for these
> ranges. However the commit notes that ranges spanning multiple VMAs will
> already cause varying bases, and that this is an acceptable approximation.
> 
> It is very unlikely real world use-cases will be impacted by
> this (MAP_PRIVATE file-backed mappings are already an edge case), and all
> that will happen is that such ranges will cause interleaving to be rotated
> over the CoW'd range, with little to no impact.
> 
> This commit lays the foundations for future scalable CoW work which needs
> to track some remaps, meaning that most remap tracking can be avoided, and
> in nearly all cases the anonymous page offset will be able to be used to
> quickly find the VMA in an mm.
> 
> Note that the need_rmap_locks check doesn't need to be updated, as any
> remapping will offset both the anonymous and file-backed page offset, so it
> suffices to check only one.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

