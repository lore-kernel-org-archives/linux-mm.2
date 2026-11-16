Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F643606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WWdam/AP
Received: by kanga.kvack.org (Postfix)
	id 2AD656B05B4; Mon, 16 Nov 2026 05:42:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25DD06B05B5; Mon, 16 Nov 2026 05:42:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1756E6B05B6; Mon, 16 Nov 2026 05:42:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED0A16B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:42:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6FB371C4240
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:42:58 +0000 (UTC)
X-FDA: 85440644436.05.B7A582D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id BF37840009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:42:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WWdam/AP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794825776;
	b=oRo/gDoeqP/Z1Pwfb20Dr688zFnT3JZ9PxxvHMH6+myNW1j9C+6yvSBStTAhhEb6wlZWL1
	v8bLu7X5bLvvZ+qzOAdi5zK5c9S26coPJ3ZSSosKFYo6GZTPgoY2+v21Z2AflohfRNQ21l
	sP4b7szstkMw/0aIkh25Xo3G2VELXJQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794825776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ptIJKF4G1UyjI76O74jlBN8l9/s941YkkxlNAdtuMu8=;
	b=L9cQnAlSqdrIrRLZF/bkVnG/VqCE3SpcOVf84ty02PEuneLYhTAx3a8e6M/MuiIU87MFSP
	Ydnh+KqEXXwqkzDMC5xSvDnTFvfnpYOdZcMbo88/2hogkZDDYNt5lINmBOs22pihZRkkZh
	yO1fdsR91c0o8D1+qcPvfeMbCHXU+9Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WWdam/AP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0718F461FE;
	Mon, 16 Nov 2026 10:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0781F000C8;
	Mon, 16 Nov 2026 10:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794825775;
	bh=ptIJKF4G1UyjI76O74jlBN8l9/s941YkkxlNAdtuMu8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=WWdam/APL/qDE1ME0tpyATJX4h2N/NfqBMABhQRZsr4y9omZlBqCigBlE9sUqU7EK
	 cUkQMn1C1rLkvY4rUd9x8Z+HBw4XfjIMAyKZ2JcFGQq+tdwnJsxdedh81DVxU9rDSR
	 4j7fOmJPqL2Nst2xXzhMh8D7EDJ3ZPokdDlsWL1I0XjnMkUCfgdGKTU9nuJwa2Eb+F
	 6rfk9XwqeEvLKoNieOUsZVEvF6CBnMGeHNq619ngLJO+p7RUmjK/l3xY/y7kOoNdZ6
	 Ec9nBZCNL9sjHdB6XEWlor1cIK9jkhj/UbTQBrKFoZRoc+2mdMNLUZaJJLMSyhjBcr
	 NzHrMuPHYp55A==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 00/14] mm: Unify memmap initialization for compound
 pages
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 Mike Rapoport <rppt@kernel.org>, Li Zhe <lizhe.67@bytedance.com>, 
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261113033442.62970-1-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
Date: Mon, 16 Nov 2026 12:42:48 +0200
Message-Id: <179482576829.2379196.3205677806966393313.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspamd-Queue-Id: BF37840009
X-Rspamd-Server: rspam12
X-Stat-Signature: t1ejrm3hzt946w91paa6yc9fq8ttgo59
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794825776-783159
X-HE-Meta: U2FsdGVkX19MPuzBfxNRF90UqI5xP1qNmVvWtFYcE7Et5vRblAKW8wxn7k4TGHsearsNTI6AcfugLba87RNXkAUJ7+IpijIy07wkp/slKda9mbwymb8oK8WG99KSOcypoazrW8HWumEuMrjobslKUVV3AEAWUgl59wgU5eGrZcsbuNdXTi1yzJ2953n9RMy42vBaIy1PcKFEUpLdYp8BaND5pVAJWHX+RCT8ZdJS1Y/tLqxS6t0sKkcD2H0Qoj3dmGm5jbmmwSBV3zGV+DB4nQphZw1KcDg5oAPrhRfrQyHRcPT07deadG30qwx0Sh1I0PBOEUiNRfPKLTcL7IDicxxUh+fhV/hDjBZ00T+eY3133q8+V3iWOX/AGOQVUBFcGCapvE2w2ZIJmNQIVUuSfFtzVRx+4URfKK0jiaL4wZlTyb+EzRAQizBwvqwJ2HKX+T2RHk/fXJEIA6xeD+zY/FxZJaTL7KFC2nqfK/mYcorP30qyY3902MSBn2clXeNDGnw6okwbtSqTlJmVjJd0VY5dQpH+pb7zpASr99Yp+w5OF0/nqqD0pU2iLNjChWw9/YQQA99+QYP4ZoTRZO5P/ScwlcE9fr1sjCjX6Wa5r+XJXD+iOl0iPQt8fF9pSFtHZnT0c/qhjKhWO8Mu//msm6qpFT8PmLEmN4jyseTPaYArLnqQRutiqPbZvGCN8W1eTtvOpy5Yc7r/2Key6WOvkbzAd1EBj07iI21hweTTNpdYoxvpFiscL8uIEkiUqMwL9Zygy5X4i7voPjcpgTCksx3/47jtH01r/gnwi1r0qPudih4ViaQ1f+bAGn30oDFx8awM17KzzSj82iP5s5lYyWCj1lP6fM6MFpyJy9CWMjSBE9FanHeTv42VfPObTj/cBJbcmwUHln0tEZK+LWj7Xg8Qoysynv7AmrBg9+QCelKuFK36JKCSX1i5tUhc39bOzkYx5qjpvWWkZfopzkj
 dxG5jayx
 8RhE2rRLNP2km6SaSbesVM1R2t/jTjZgd5wZw7DhUOHCffAffrey52WfnZANDii41m+6a2Sej9CDOviWrfT+APpIR8FKVGptXmisvOEfDK1gT9seSxXyWXRR0xDB5JYXZ54UDmCXIIq6ZR1cJymI3Y6X8rGQlmPet9VsMrEkOLbPs3o8mf9MWZnPnB263wwGWGWx5oDl/b4bPnHojrQyKEVwy3PB9wQiWEW3tq5zKPwwwKA/lRcYRAoZ7iX6ouIE5bzExY3vpnaveOCW0R0q4k8XoDQYkKR6KHd/Ur+0r7emEs1NI/cXfOs09vFdAQDVtszQiK9Zj/3EjvefCmT6is585rtxItCFi4nBEVgR4ob6tW/bZsBc1ZyrDig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

> Hi,
> 
> This v2 is based on the mm-new branch at commit daed51c91051.
> 
> This series is split out from the earlier, larger series
> "mm: Generalize HVO for HugeTLB and device DAX" [1]. That series
> generalized vmemmap optimization across HugeTLB and device DAX. One
> remaining piece is the separate compound struct page initialization used
> by boot-time gigantic HugeTLB pages and compound ZONE_DEVICE ranges.
> 
> This v2 also folds in Li Zhe's two-patch series, using that series' v2
> as the integration point [2].
> 
> Li Zhe (2):
>   mm/mm_init: factor out memmap_init_page_from_template()
>   mm/hugetlb: optimize bootmem hugepage tail vmemmap init
> 
> Muchun Song (12):
>   mm/mm_init: verify zones for template-initialized pages
>   mm/mm_init: factor out common struct page initialization
>   mm/mm_init: simplify zone device page initialization
>   mm/mm_init: factor out frozen compound page initialization
>   mm/hugetlb: drop boot-time HVO handling for gigantic folios
>   mm/hugetlb: initialize all struct pages for bootmem hugepages
>   mm/hugetlb: use common compound page initialization helper
>   mm/mm_init: make __init_single_page() static
>   mm/mm_init: make memmap_init_page_from_template() static
>   mm/cma: centralize CMA pageblock initialization
>   mm/cma: localize init_cma_pageblock() to cma.c
>   mm/mm_init: move pageblock migratetype init to memmap helpers
>
>  include/linux/mm.h   |   8 --
>  mm/cma.c             |  24 +++--
>  mm/hugetlb.c         | 111 ++-----------------
>  mm/hugetlb_vmemmap.c |  17 +--
>  mm/mm_init.c         | 247 +++++++++++++++++--------------------------
>  mm/mm_init.h         |  13 +--
>  mm/sparse-vmemmap.c  |   7 +-
>  7 files changed, 129 insertions(+), 298 deletions(-)

That's nice :)

The series would be easier to review if Li Zhe's patches were integrated
rather than stacked in. I hoped that the changes for template
initialization would fit into the patches that rework other parts.

The way it's done now several patches in the beginning of the series
change code that the later patches remove or turn some of new functions
into static.

Another thing is that the numbers Li Zhe measured were for a different
implementation, so they would be stale for the state after these
changes.

I have some nits and naming comments in a few patches, other than that
the series LGTM.

-- 
Sincerely yours,
Mike.


