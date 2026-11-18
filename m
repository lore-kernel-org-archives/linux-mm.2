Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E44E460A2615
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TjsgJxsb
Received: by kanga.kvack.org (Postfix)
	id 0F82F6B05B9; Wed, 18 Nov 2026 09:19:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CFD96B05BA; Wed, 18 Nov 2026 09:19:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00C7F6B05BB; Wed, 18 Nov 2026 09:19:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D66706B05B9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:19:00 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E70016074C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:19:00 +0000 (UTC)
X-FDA: 85448446440.14.ED2864A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 74DF780002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:18:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TjsgJxsb;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795011538;
	b=EdYLNX2k9N8caQbmFrOLDUFhdej8BmeA5FCdUwNpJxLXZkoNwkmeaTupp1uGkofbLfvykI
	Xgez3iAuzgsLOKsd0xrE1j8RkYhqMU2X6djERHUd5FTfqiqAJ62lsXRvqqeXYYfDI46ue4
	zIz4D3y0HIjLSXFr/AgQZdiEv/mi0bc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TjsgJxsb;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795011538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yspg3RYK6hfplwr2guwVtoc91Gns2znX/lR8zgZBFVs=;
	b=m06JwvnQeRq0ZlB/bwE+CaX0giPsBc6dkgngq3m9uQQ8IFIRBOC56fNcmGBnIY+Cb7lZ1n
	SDm6vkvr+I+mJ2OT3Avmd/6QIRuysVBl90DXQbLm3/AxIS7Txm6E/jeAO6MDFYBAeikgX1
	v4seUHHMh9DCmcy8ZaK/8Ly71bTZmeI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CD7C42E7B;
	Wed, 18 Nov 2026 14:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896811F000C4;
	Wed, 18 Nov 2026 14:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795011537;
	bh=yspg3RYK6hfplwr2guwVtoc91Gns2znX/lR8zgZBFVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TjsgJxsb3omgZC7Y7BqVmG9Ex9ZO4k8c2B1tbSP/96Q0m5xKS+UvBbENGt+SaQib9
	 9kUbL0e5wLlwJegMYSiSzUPGcows/z3EtystFW8tMA2Izw5ThIzP4oA+E73pK54zhD
	 pTjJ+HJCkJg8pdSfKAp7mW9qElOyGSzrm+b7bTUN9wUnOrH1Au3oUxHBI9P838qb45
	 bI41cCj3uoYB0day2lARxxnN8bF0wjB7hlN2wnAaMTIl/RtvRJOlAPdAaNrImCwE8E
	 Q6CIIgWSCViQL/WRgnaNuQGPB7lDcH8fnD257mcfFw3w4bbDXMb7IlMJIvIb3gKmHF
	 Jk6E5jDwzWb4A==
Date: Wed, 18 Nov 2026 16:18:45 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sashiko <sashiko-bot@kernel.org>, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 4/7] mm/page_ext: use common allocation and
 initialization entry points
Message-ID: <av2zxfDZI-ECPByB@kernel.org>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
 <20261117120627.50601-5-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117120627.50601-5-songmuchun@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 74DF780002
X-Stat-Signature: usfoffta7djftxunqpx5ojdz1a9kpdxn
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795011538-454759
X-HE-Meta: U2FsdGVkX1939a5p0XZnksdOt0YCUU+bofFl7Hl3JlIzv07wsGMPahCRYvxXO9+xMHN7ZDGwT3n36Xd/vD5LJyzCPpqJ0rc208DvS1RZbCv5Y6LivlJ3/INhNqRfvcqtvkXdZ55dTKoEKx2ckrT/6rb20BjphAOHJDjmb/vSglaS8iYJIyMJAQvF3ZqG03U2fqSsL3SuaJYq26QNgFb4+kNHhSQLZ0UkLedI7k3EwuO4kj3M86aevdA/cHTqFP69LI8xEvk1RjO6E9ghmSLXntXLEzyj8ptUCNiKFzXIKF2pEgk4dQCgt94sXAKGOgYeYkn9U7JA63Tcnff3/+K2DlIVPdeika5rb22u9yDhm4chHm+lanBye1nvOEwq4hKmJdLAJ1BtPlKbHrYJKzJEbqWXlDpBsYW3AlaLjn87HrU9/9chB31lCdj7tcT+9CD+4rj2XaY0iTobybvdsO4z7UgvOficpueo38u6DNvvYM9LxBjV0DnpX4wZrF0p1jWdCYHYhTaMzoAu7wvJl8gAGnTvt8wsd97IUTtQVj3SRmbK5fYnVlqYsDc5RrL+5xq5D8gm352iNUNPXF6/tzMmyay2znPGxptarNuMA+vdVKydVKlzUWPfWAI6Ou8BiLAZAZkFXXdcwOQYHSDXqhyVA8Dtjd9pRid64L8qtD62UdLEogMXfTcR8RjCCaIbxgZ4G25+3HkcrAmRL5HLHlqJPDoW+siLWwAqYSKOWyI3UZAe5h1ozsAOMUiIh45aGCutmPJA/8+jgxFv+VaAGbBg5xj+RJ+gZnOpQDE1HqGOE6cp4OqBhg8C8+91vlo8paO2u95Wr21nMxI9U8G4gCRsvY9shrMHkRuzJs23g0IvWpPP7crYko9YktTc2ivhjc/temJmavWymZksS8kVQC7Ty0MYyN1ERtXO8dJL7Gf/Ck7Kg82igIUNgWNGMwk2FFFsh7WQa7hJPDjjY1Ws4Jc
 46AFpHlf
 Lf6PMeJtzwQDKC+bDZ8eK85eFpsDH7Z8Z2Pvmn6u/dxOZKrMQFpoppp6KdUSGYbf9YBuKdw4WEPI6gAp9WTnm1SeSD+oGCg4x9IrQgw9k9TmMhT43dBw9YE8L1hEHL9L7rrNM0WT+DcrMX/1UYjUg7CzI5EjR9X3kjtjsnHEkDRwNmi3tp2TJIB3TZ8MejwmxnKHp+FC2d86zmeDv8aBlYdo+3rt1YjX+PNnS5SMqkJPI4vrAqmbEGnbid7W/D+WFP55J0ZI5vxiEbDlkET2a9FgkIU8FK0KriNXbfCrgG6YmftbbVB3pP0H32sGR7nXYQ3gDcAOC6iWmqlJsc6o9gga4RNC8WRsBiZHY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 08:06:24PM +0800, Muchun Song wrote:
> FLATMEM uses separate page_ext_init_flatmem() and
> page_ext_init_flatmem_late() entry points, while SPARSEMEM performs its
> work through page_ext_init().  This exposes the memory model in the
> generic boot sequence and obscures the allocation and client
> initialization phases.
> 
> Rename the early entry point to page_ext_alloc() and use
> page_ext_init() for client callbacks in both memory models.  SPARSEMEM
> keeps its existing late allocation behavior for now; its
> page_ext_alloc() remains an empty configuration stub.
> 
> This also moves FLATMEM client callbacks from immediately after
> kmem_cache_init() to after vmalloc_init().  The callbacks still run
> after the buddy and slab allocators are available, as required by
> page_owner.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> v2:
> - Split the common allocation and initialization entry points into a
>   preparatory patch
> - Document the later FLATMEM client callback timing (noted by Chris
>   Down)
> ---
>  include/linux/page_ext.h | 20 +++++---------------
>  mm/mm_init.c             |  7 +------
>  mm/page_ext.c            |  5 ++---
>  3 files changed, 8 insertions(+), 24 deletions(-)

-- 
Sincerely yours,
Mike.

