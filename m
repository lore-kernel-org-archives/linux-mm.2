Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16751606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 08:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fJpl6GbS
Received: by kanga.kvack.org (Postfix)
	id 2FFEF6B05B4; Sat, 31 Oct 2026 04:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1856B05B5; Sat, 31 Oct 2026 04:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8DD6B05B6; Sat, 31 Oct 2026 04:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F19A46B05B4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:39:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81743A808A
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 08:39:01 +0000 (UTC)
X-FDA: 85382271282.09.CBFB76B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id CC8D24000A
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 08:38:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fJpl6GbS;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793435940;
	b=6fkbqJoL5j6FzrxbOFnwOa43GcgdeFA6yfoWeZ0YLf3vUxgWjWQJAzUZEMv/Saklmre2pd
	CGjDzZxNJE7klksxgk1q9QbEqBTDWb6g2CtIe685MQmfvuNvVjKVlykBDw4aCrGvyfbjC5
	3L9c2pX8P5c2FkqzlTgkqqz/+jTRwas=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fJpl6GbS;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793435940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3G0mQTQHftTI3Jmfn04UefoKAIl/mRArjq16cqT2p2I=;
	b=xLCPWhi5yP3ecSzgaCqkb+kq6fYq8ja7oQ4LtJvao75AA9vQ/J/h2VEgpfKSuBFymuEMlD
	IkA0SA0Cvs/jHDZrKDXwmlt0lB8JxeblIBkDACUlH2DDm5iV99sfxIiZEPXRg8RVAVTElR
	6oDAvAMXlEX1ewXM0vwvPXDk3HdIqvA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D27A5401BE;
	Sat, 31 Oct 2026 08:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D09D1F0093A;
	Sat, 31 Oct 2026 08:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793435938;
	bh=3G0mQTQHftTI3Jmfn04UefoKAIl/mRArjq16cqT2p2I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fJpl6GbSGq3CpHcVHA4UwfFGRXni0xeWUxJDdTKtzdZ2YeBqeARjjA62BuHvu6eye
	 gDZeNruTADmCbTekJNxOVhpsAqV2sUFYfcqQZW55dkch7rEFv7vQWqhPTHLXC9Yota
	 FLO2mQWzrFK/MkgXrvC9GUgqS/X+QnT/akNaTlqCzsAVMPGlX1xb4uzA8eVc+YyaH8
	 S6lHBOIPxS/iDnCGs0yleut4iR/9tAQ7D7Dy8TyIqgOd590BAGdclQuYOcnQ6ahIHw
	 9WxsJLjQI69Si3fddHA/CRriFfVDeSkXEQjNq/892h/Ka32wQHxw68TZzhZq7MuzJI
	 vLEywa2JNpglw==
Date: Sat, 31 Oct 2026 08:38:43 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Byungchul Park <byungchul@sk.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Dave Chinner <david@fromorbit.com>, David Rientjes <rientjes@google.com>, 
	Dennis Zhou <dennis@kernel.org>, Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Matthew Brost <matthew.brost@intel.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, Nick Piggin <npiggin@gmail.com>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
	Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/7] MAINTAINERS: mention for-next branch in MEMORY
 MANAGEMENT - MEMORY MAP
Message-ID: <auWpDuqqLwWyEulD@gremlin>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-1-97278f8a5f54@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-maintainers-v1-1-97278f8a5f54@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: CC8D24000A
X-Stat-Signature: s7ypqughe4r7qtditcty897udni6okk6
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793435939-285326
X-HE-Meta: U2FsdGVkX19UhHVS4Bp4ihMUteWUnKS+yy6vVc8gldNBdBCfjQ+u0/DkHOFDySs6iVFG5RwA4W/nxd4aZOlGdeGft1fuCOSnkP2tbFwAoq6AmOPjMCu36edbDCfNYzVQteNGL1Zka3nHXiOfAftqKUgXmkw1HGa66CizCDpCqZQaSSAf4ScwgajVQrV5FxC3wGyFqkFp5IpXIFF/jBvjGHDnylxv9YfhFAoyb+aQV+lPudIjDQ0ypjy/AO4Z632F1ckoQImqIV4j4zGU9Bf+hiDL+M1LKkwtu6qvTB6x2POSbttEdp+skgaeILF3ZpCFn9bBNVClgZkMQUzo/56HQ/blRI0/02pkTu0Hjxvcspfyv4O0kjoOOhwI0Yh2J6MIY//kjEDkrHNy3l7UzVueNC4s2MYlPdb0OA/YPPaopeqsgrnW/vUAZDdKhK/Ark1JLp7IU5cgjo4NnvU2aC/aEYTzZs1vg15s6yphyEC2K1Tzw/r1J9HES5C+utPVFJ/1X6IwVsE4Vl7oOoFexoqYZaGnk3jHY/J6IALDvKy54ESnHwZQyembdXlymhY6XZKl1DUkSn2Auh86V3Eia0fg950DaqrYc4WXOMda5hO+09eLLxeUKl1C64hpIgytdRgEh3IA0xqOTdK+MlDl+VYj46XTKqExP3GCJjAAp61hess26Vcp972vX7n7bcoeH93HIHPMZZQBzha8YG0eti6QqI8/1FGSHZ9abpbeNkrG+S1kRk60lOqdlH3ckHiKYyqd0za9/d6D6DSOQLDq8Jugoru39tnmjjw9bV9KruQyxb92SFptpENURoiY5Dg738uJIre+WcFvIK8OxuvI2q45oBkGN6ohMtoGVeLHP5WBjM5/5TfdzKMyvsAus3dFgSU6k64WQDJ+0V1GF7DlAjzpg3MwZi9thFOXN8KeIbTT5Hs7DpvmHFllDl1igET+4+7hU0EyG55zjIuB1NZscEN
 UUG1c+hg
 /UVbvRReSFzkItfodKPnL21w9HmsTgiZf/oeQiTV+EkEAnaNixtohp5xo+9B6B+vck3KQV1Ke0KjF7p738YzGQaFFRlNBW7FcbMWy8AcgQb0c58J5NCatlasf7xeJGGdXHEExA96dzgTab0sPesnxNAemP6BT39KUirxaEfyOgYkyeSXGZDuu0OnLRCjJPmG7pNtWi5c5zM3Wr/TKd3iEN6/Wok4OkV/KBjEMgJQEwqXf/Tl7Zrn3znB5Q0APVaQHdjvwhFknvMJCXx2cTjz03dsJM0t7VA4juF2O4U0GVVIbH1xGlg9KW6Ss2NEZr9BtiLs10OHpR2we80CaKQVR40lphls0H7E/33Z0rhtl6DtM3cSVjtyq5qvbVV98TkiKqiIW9Je6YFUXPPIgjFxm5M2qigqZa9lo+bvh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 10:34:25PM +0100, David Hildenbrand (Arm) wrote:
> "memmap" will be used as a prefix for branches, but not as a branch
> itself. "for-next" is the integration for all these things against which
> people should ideally send patches.
>
> Not mentioning a branch makes them assume "master", which is wrong.
>
> So just mention the right thing, which is "for-next"
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7a162e9bcab10..dbb5582ec1c74 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17566,7 +17566,7 @@ M:	Mike Rapoport <rppt@kernel.org>
>  M:	David Hildenbrand <david@kernel.org>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git memmap
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
>  F:	Documentation/mm/memory-model.rst
>  F:	arch/*/include/asm/sparsemem.h
>  F:	include/asm-generic/memory_model.h
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

