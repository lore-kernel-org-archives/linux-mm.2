Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62649606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h5aR9qt2
Received: by kanga.kvack.org (Postfix)
	id 84E916B05B2; Mon, 23 Nov 2026 04:21:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FFAF6B05B3; Mon, 23 Nov 2026 04:21:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 715566B05B4; Mon, 23 Nov 2026 04:21:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 574226B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:21:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CED84A0824
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:21:41 +0000 (UTC)
X-FDA: 85465841202.25.6D2A268
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3651240005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:21:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h5aR9qt2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795425700;
	b=6I9PQkbp56C2hJrfZkHJR4FJhK/VE4gcWFtweeGimRSinSobtnKgjJiC269tYDQuesC/us
	qBvRFmoBC4+h1veriMqhDvtXWCbHHHJdQaf+s/zyIpxtrQApnoMfu2AWi91cZTnkod2o+H
	KjAIJzY+dQE/HJg85dbnwvXf5P14COU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795425700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MXSMwC3EA3gaqHKW4Fb2hsBvbWnm96vp3sI6EUJmVdg=;
	b=iIPnBplnfq3Fy2EFU5bV0bxeLe+bw0lTEMhUuSnt6OMbHpr9Kidd0EiROLDX5vsTNd0GDg
	iXzM0E0K8rWuyg3IbScO+Pw0pii1u+cLnolwL7nh0L1PvnbRf/vbHt+8DABlIOlhMVlGDB
	dtX+DUZEmuM/XwxbXTxCqDgIp/7bRGw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h5aR9qt2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7CB6B61332;
	Mon, 23 Nov 2026 09:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8773F1F000C6;
	Mon, 23 Nov 2026 09:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795425699;
	bh=MXSMwC3EA3gaqHKW4Fb2hsBvbWnm96vp3sI6EUJmVdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h5aR9qt2lMqmI3Rizi1Q28Ii4IEpiI0lfJRb052ftraEp8M1i2TAW6k0mUro9BJco
	 ZFHoll41KKNBinMH6mi3R9eNbUvbkzbOF2BxfG9iBvSDFSiOJyPigFuUILINUr0jzt
	 gilZshzmq2dF25Du3wLejMylMI19FAQ8HC8CPYGEoORN10ZsWLpSjKyNDXG4CGePuV
	 ZXT752joMsC2sK9eZOPNDmUBSz4TId1KX92BSVeVqcWA+lyfLs+OGHdMPUqZkmb+eS
	 jXYgzJDaJqgIuC+D1jrezc4FDj+rxqsgHUEJvciU+mYgraPLmOnIvXfCNPI3Yzo+yO
	 VZp42ZsVXZwOw==
Date: Mon, 23 Nov 2026 10:21:31 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>, Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/11] mm/mm_init: factor out common struct page
 initialization
Message-ID: <awQFm3tF7uxCR86o@localhost.localdomain>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-3-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120100856.16929-3-songmuchun@bytedance.com>
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3651240005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: w3ft85jpk49psmzz81dtujpgc3bz5aog
X-HE-Tag: 1795425700-30438
X-HE-Meta: U2FsdGVkX1/TteWnwiXnv0y7wXumoYhDRY0N5bIMTBchlR/vmFFtjxHGG2HWgK6J5V+J95YJ34jZ4cbqWpojnoOTaSAYrMaiQfEXZX/rfkiZEnbZbmg2CXx0G9dFUoL/5qDLXNOYEVrzHV4QM544Z7/EClin2Fn0D2yJ/1ZAMFE9wvKFZZhM2BQNLR5aNl902k18jWJdfYFdoi0/KLMHVJ86eMe6vzt/NYTBk7L3IcHWqpCEp8jZxFxppvhi6hGAmQkkVwjcUh/1M42uSIxSuYRuUVavBZtXzddZ6DK1i3ukOaBs+LDua3GutORoFDkztYgEw7f5d3t4uFm9Mn1qWLh8N0vJgEomw0Q5/3wiA8unEIXU209iPw4dDHDzl4KAzI4jsTga1bbndBz5pKMSocz9vKWhdv/Tfjs3jm0Y1zXuQ+Ta/OBqUIyb2vmSRwEtx7XI8PfLFww9qbLCP71GBDLXYnOZj0XPe4DRRsq3d1BsrlrwKrysGCnMOhkKieURNTft4Nqs6FYJw4Uk9xgsfv/v2NEiLXzoowPsjMtjye8c4Dg2v/4/n2O9fwm6eNdLfCTR/M2WtN9SfjLXy1JOua5Ue6ZL5gpk23Z03UTeCE4rZa6gmUYYTHhuIT6aZSA8RvWHB9mglY6Idiiocwc9PnjzC8zerHNcGlIA+yDcU7QlECbUySODPHoGKEK1LYa86LnrGbWasP6QFuBIivHmz1KdjcFMPYbGDVXBH7uPijfqlRzyz6Mz3UJ6urX2YK/Hnwwun/zD/heBVv6srPiG0tnJOI7U8Z4eXnsWa/MhJZNlgFYEFmVeJdnYaaDUlp6mZJslcpACfnDp9kjwtnbhSYQ2Tn0X9eRIRVURiAxHiu+MmPmhM0CNp6GQ+zBXD8kiyBlovQP7EVY2IekYLYEG9DbDkqNObhWVH+NqMx0njM16DLl841BV+bAaUig42FXMdpZSECkbL4Yk4IUVeGb
 rmH974XT
 PP0AK3fNgFHZ/N+6umYTghr3/YSLvjHLtxwd5ij94w0uxscI36b/lyJ+NcV6MK7RKWP+YuE4gMOtpDvy8tXEWa3EfYX0ieWHv4QjiMuUbjkg9/ULcqS19061c7rv5tjmBI4bYWcCnPfSBuVEdsVUEzziCFaftidqmTD6KCjpCTiQL7uGHe4OhOU6cL66AeIO1mJONKpB/iV2D7nnRX/Dn4RoVOoc7WB9jVMPk78O5Q2bSSErN2hQyNCtTCSdN4ZEf3HMvftsmGHKaZKqGkze02P4gbqo4k++v8S0aIvDH/P6Zke9W77u4HEPA764SMXhz87+OCCsHPPYhGXweW6pNQnsCnNen/H5Wp4VkZoylJS3i9RBq6Gpt/FkW1SncbUWQOAEAnWdjq7trWjci5qz3Ydtco7WaoS52DDacxy61LqG1G71RboXYAJqs0V//ZgysElAUC4pfFbXwEXN5snP/4PIHgywQ6m3ocxXVuu2n5lp+JEEcTxoSWxoZcEzpoAoRuYW1rz9TRE4vW8TjUcCw7IdGrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 06:08:47PM +0800, Muchun Song wrote:
> Several struct page fields have the same initial values for every page in
> a zone. __init_single_page() initializes this state as part of its
> per-page setup, while the shared vmemmap tail path open-codes only a
> subset.
> 
> Factor the PFN-independent state into memmap_init_page() and use it for
> both regular and shared tail struct pages. Keep section-, PFN- and
> instance-specific initialization in __init_single_page().
> 
> This also initializes the last cpupid and KASAN tag for shared tail
> struct pages consistently with regular struct pages. Since
> memmap_init_page() marks ZONE_DEVICE pages reserved, remove the redundant
> update from the memory hotplug path.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

