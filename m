Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EFE9606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kv3sEfb3
Received: by kanga.kvack.org (Postfix)
	id 31F7D6B0996; Wed, 25 Nov 2026 05:29:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8B16B09A1; Wed, 25 Nov 2026 05:29:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FE336B09A2; Wed, 25 Nov 2026 05:29:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D74316B0996
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:29:56 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62601140B5E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:29:56 +0000 (UTC)
X-FDA: 85473270792.18.8861D0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 87FB640004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:29:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kv3sEfb3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795602594;
	b=saUMCl8xrNsmkNAzi/46YcsLOadzp8vaOBGIVSotDQo7f/DZDNCIQUpFI0wQtDaKtovSMW
	WJCTxviHXFAWIYBfXhumVsxrBsTnapb2u10k5ogtJjQyodZ7Mym3hMUVQPEZpfV08gVCim
	ySxqrsvufYmpK4mUgqpBeKBBpCeux5k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795602594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cV15oLjwMNgk/g1Q+nr1ktVJ0SDw2D1b5XtLlmxbxaM=;
	b=WWPB2eiKbEYblpeIOfD+w1pqNBr22HtN54W6NYnm1BIa5CVgAlJZSRs7vOlKQiOA3mBU1S
	gdbqePShtYXm45RdVc3+uLlNRWWejpUzkkulmOcz9CAm1XEGW9UBcEvfdLHLUdYu8Hd/N9
	ddyI50ug7amgymu+2WkU0Wm0nq2l/kc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kv3sEfb3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B33D843215;
	Wed, 25 Nov 2026 10:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC961F000C0;
	Wed, 25 Nov 2026 10:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795602593;
	bh=cV15oLjwMNgk/g1Q+nr1ktVJ0SDw2D1b5XtLlmxbxaM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kv3sEfb3VmLNDgnW8QxTAmJX8KNK1JjIIvs6JjhV9xR3Idtt+E/Acy4sgcGCIppE4
	 fnJkMqDZbs0YxjZI0omhdwO3pmG/m9f2/9M8y5Js9tcxthcTUP5V6USECeO4SB+aGw
	 MNSMXUKRiLYUbWzfDy3760p/XFwm07QheI/qTMYLKOBevoQP2wctWbyOORugl2n6IE
	 /2KRvK78WomCoAN9r3JZWj9Ek7TJlv5tIy6tBjzQ0i9U8yc4aj9H+FLBxpPrUxHzJc
	 FAXgnTDwMkU+YF3HjkZ+frzy5AN+WW2sI2x/TTrk+C3BQhLZ+SpHYGbXKeCKqQjq90
	 yApJVfo9MBUlQ==
Message-ID: <d2d127d3-6791-4c66-8900-36b717fcdf9f@kernel.org>
Date: Wed, 25 Nov 2026 11:29:35 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: kasan: skip KASAN for GFP_HIGHUSER
To: Jeff Xu <jeffxu@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Marco Elver
 <elver@google.com>, Boris Brezillon <boris.brezillon@collabora.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Chia-I Wu <olvaffe@gmail.com>,
 Dev Jain <dev.jain@arm.com>, Ian Rickards <ian.rickards@arm.com>,
 Jann Horn <jannh@google.com>, Jeff Vander Stoep <jeffv@google.com>,
 Jeff Xu <jeffxu@google.com>, Kees Cook <kees@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Peter Collingbourne <peter@pcc.me.uk>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Tomasz Figa <tfiga@chromium.org>,
 Will Deacon <will@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Miklos Szeredi <miklos@szeredi.hu>, Baoquan He <baoquan.he@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Allison Henderson
 <achender@kernel.org>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-mm@kvack.org, kasan-dev@googlegroups.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 fuse-devel@lists.linux.dev, kexec@lists.infradead.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20261123033111.2349160-1-jeffxu@chromium.org>
 <20261123033111.2349160-2-jeffxu@chromium.org>
 <7ed1f755-5759-4b5b-ae00-a814f16b7903@kernel.org>
 <20261124195455.164425-1-jeffxu@chromium.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261124195455.164425-1-jeffxu@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 87FB640004
X-Stat-Signature: pr5k66e8aari6b38uqbbaamaoeh14tu4
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795602594-95327
X-HE-Meta: U2FsdGVkX18qd5Rf18CThbtA/m2r6niOp/Qzf71DII3WPa/tDWYkGL/G9MoIf5xFN6QZmebwHW2JUTxWlTxE1EvSiaChiH0J5aM9NqzfNuGxL+YaYz02jlmxoK4teLgKmHnlK7L35gsxyjOUInqL0izR3dnVkXN13C7Z0JAkTsgpdvZOLyLIcNF/ogcGENqmbt8qgUvIeymiMMopvagjuCoSf9JXC6k3IAcr1n/MPoApFFWWjJhogp4XGPVtgOUH9IJD2RAR8JWiRVktDK+HqspLsOCv5KUyJCY3MzACQn3KnzgDxhnJiFTHn6LrzHwKfu6Ieym9jVbFsvHl+MuR0X3mfbUcIUZu3kyxCqQchtdqp9KaJH19LspwSRk68y6mlf7Hv4i75dxowlkjkRsAfIrU203reSMbFz4zDruGiM9r1BPTSOGCK/kQdQIahExp+YNcySSXkpR2Sf1Vawka88Xc+XdOabupih4WFVPthVLxmWu8Gy3ezkxYmfdBUmAQM7mmzSynQ9DEK9nyjHY2TequuVJRSpD0FhLjh0WlHI2Om7U7EixanHS4gqee0q4dfhauYK+OLyb6iiwlxA/xlqqA7FTBCkPWlSjM2n0qJUldslbnpFGd8EdeYN0Y1oCqoJXES4lv50DPc4DaWohg1pGM+nY+uuvk62S/maRVlLwpHvZl+2Yo1cT/yhzvGZn2IWAkwSCp2vtP4WkT1zjLdLuwbgICi8hB/5grSUE1HktMRXCruROhRQ6S4+91yDAx9pw3Niculb9/77O9LO6qHFzWlxWXOp4OZbng5roSt2RwwNlCNzFHoOa5T+nHWnUJotMNpratIwlxWu2ZblxwM/sp3+qlRKLtfTOLue2kwKNxrKvfT14hqxyjAkg44bgKVwCIMFlpHTqUjrVWPYLXn3E2XWXBIt/vdAOudviHuSqUVDDKLXsqf+CnK2X3sTC6IjDTqUt/du75u5Crtg6
 MzR9aofR
 UPfGMvKlAMXziPjrHps+JJJM5wuWVM1KraWxisGu43ravPQacXwMO+XNtrOH5Z4YWmUjb2D9bq6RtkR+HET2pEGUbuVEh02nEMrPxxyK00ss9/1niXvdBi5tNzuT01dcwCsvWcfgoKDwDeTLUoHhGi2ZAwwzFtkNsdX0w7wJi/WspTvf89daU5Dp/8PRM3XQW/+X2Tc9b7sKUJV9vuILcGlFrjtgaH0ZEedorzl2YJYxMgwFBGQd3ha9a/lyIygcuNjgp35wu2BEOoHvLi3gnNLjXrC0nHgvknyZZ6kNaHtqShFS0JPgB/Aui3VEsOp/QJ1dpfCiH9hod35VUPt6YIs5AetyAfTF1f8eTrnit6Otx2gJPQwHuSIzC1aFFrOwJqgSZGyCyjjh2+LAj3Vz/+Jq8APz9R4V4c806EEl6f/wBS1ub6xhG3bt8N+jraFprNQW2EP1r8drGwatM6IV6KLORhMLdX8yKffl5wZMKX61oqsaFr3mEOtfJ4Q71zCxJKs/Bci32fJCGYS2LcyzDGZ2j1OfSLVuARyYPbuaVbJvt111Ic5XHi3qqPI7HGajVa/Jz1cbbfJcklaQRYsAe4EjW03SnJGNHc20uUaia0T6vSW8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 20:54, Jeff Xu wrote:
> On Tue, Nov 24, 2026 at 09:10:53AM +0100, David Hildenbrand (Arm) wrote:
>> On 11/23/26 04:31, Jeff Xu wrote:
>>> -#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
>>> -#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE | __GFP_SKIP_KASAN)
>>> +#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM | __GFP_SKIP_KASAN)
>>> +#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE)
>>
>> Can we please add a big fat comment above GFP_HIGHUSER, explaining why we use
>> __GFP_SKIP_KASAN and which security impact this has?
> 
> Sure, I'll add a comment above GFP_HIGHUSER in v3:
> 
> /*
>  * GFP_HIGHUSER (and GFP_HIGHUSER_MOVABLE derived from it) sets
>  * __GFP_SKIP_KASAN to skip HW_TAGS tagging on allocation and poisoning on
>  * free. These pages are meant for userspace data (e.g. anonymous and page
>  * cache pages, DMA-BUF, GPU/DRM buffers) rather than kernel data structures,
>  * and tagging every granule on allocation and free is expensive.
>  *
>  * Security impact: under CONFIG_KASAN_HW_TAGS, these pages carry the
>  * match-all tag (0xff), so kernel accesses via page_address() or
>  * kmap_local_page() lose HW_TAGS out-of-bounds and use-after-free
>  * detection. Callers that store kernel data structures in these pages
>  * should not use GFP_HIGHUSER. Generic and SW_TAGS KASAN are unaffected.
>  */

Yeah, that sounds good to me. But let's wait for some more review.

-- 
Cheers,

David

