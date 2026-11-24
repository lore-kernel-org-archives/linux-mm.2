Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B6E5606A322
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nTnIoYeC
Received: by kanga.kvack.org (Postfix)
	id 36D856B062D; Tue, 24 Nov 2026 03:11:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31E0D6B062F; Tue, 24 Nov 2026 03:11:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20CB36B0630; Tue, 24 Nov 2026 03:11:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD3916B062D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:11:13 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 080E7A8685
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:11:13 +0000 (UTC)
X-FDA: 85469292426.20.01E1D84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 33631140007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:11:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nTnIoYeC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795507871;
	b=xeZBN1MnGMdPTse8XG/JVUEporTaLXrXuuXat2WnEk3aacAzJPYBpInPKNhek4lVB6GeYT
	pGgeGGul+VHl3Zfqp+PyEkrSwvap2aRVIMoNhfY7LbgLhZsnld96UD9P2NlQ1Z7WCN1a5C
	2ZMxB7jKeXFn85igdT4jOyrubUCSAMU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795507871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HT0r4HcDbQnSXCvlZ/RECDLVWuKCcbSUYpyd1IXB0iM=;
	b=6EPjH1yg+jxdCR5kayfhQrguFZEXZLL1FyZp96ys8/rMH+JNL4TkE6wvdtbjts3F1NJSHT
	p/Sur6OlME/+DI+WLWVFTWmDXivzV6uM4a2TrCHnapkSw7iD1HolmjEMn0KMNgXnsqHqp0
	sIqt1akpqOzWJRldc+36ViEBJfmKjB8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nTnIoYeC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F5844434B;
	Tue, 24 Nov 2026 08:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4B61F000C0;
	Tue, 24 Nov 2026 08:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795507869;
	bh=HT0r4HcDbQnSXCvlZ/RECDLVWuKCcbSUYpyd1IXB0iM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nTnIoYeC7NpBkbQZJv/CMbaZo4bkDmpeccQb9Gf4juySQf3zaSYGjjOQDpfz3LVoA
	 7gwFR0TIw3+Qi4g6ZkX3nIy5l/JZi/nqwsTpj6sOz9qZnoMMmswBQnZ2wXtRq4ZBf/
	 7gjIDylfQXm5mAOGeOq8RX1pOp8dELAb4tSY/t3s0QKPMTiZAPXi794iYxQBvdrNF6
	 zcMf37Gev3dZOOKtngRQWB58H+LAYVTmGUJV5sgnPAZbj0/ULKYX7QPyJ6MExILy5r
	 7VqhHRw649o6ZE2jl1sU1ZxMRnK9E6W6Cu3NhrwzXtedpDQZWP9XUv9nQFCi9qWjNi
	 E5IfY33x8mH4g==
Message-ID: <7ed1f755-5759-4b5b-ae00-a814f16b7903@kernel.org>
Date: Tue, 24 Nov 2026 09:10:53 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: kasan: skip KASAN for GFP_HIGHUSER
To: Jeff Xu <jeffxu@chromium.org>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261123033111.2349160-2-jeffxu@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 33631140007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: h8ss3ojbijuknp7mu3y5yng37ar3cwi9
X-HE-Tag: 1795507870-903687
X-HE-Meta: U2FsdGVkX1+J8twmGeQ/TBnUdE8oBpM7knpAydRlwGP3+rsAiXFYEzG6bNepNfafytdRjPk5qkNJE7IgxGoI+aWjTKZfZ7BY0efWebwTp1OXvgPLdff3fcsXg6xo/zZtIQte6wJrXO/l3oE7abcOepgCVf2gABSPaHWFPkHuNX41xOyOKbdzf3GA/BdPc86HWOY2zGgK65jCU1wz3Uz1JZi38YGAT66uju917VBXHysQrFXsF3ICmjPEdAECzSudAkMeOQa1t0j7g2jI5/gKoNev9O5bHS/t2f+eeluJrhetaKBxMLAC6m9KSuUkR26IwYfbxEtoid0ae7gjEQ/+Aah9T7RrJZqsaTL3wriRfBW9/mLaSWnkBSaEL/X+LLXFLsYxXH1T4QcsmqDrgbsOsisM3H00wMvvwZzk5FDz9Kzv9ghpT98tpejomT8anA+KNO71esdGi+ELXmfZanMkC24PfpgD14BsySxr/fSLyqwVcUkKBK63jG6528d7zAJSz5LJZkLkpVsigukcAGBQFTVpYzhRQcmw0ZJ421+31QL54sW/8JdjIm5KIqVSy200TRVjDHKO5ClkCW8yELIwODeRRiNlrKnjXSGdnZIt0qkDwKBBydpUulfQAXEecA50Oc4twz1RCFsBxc0TtMu0J1RGOKBs4+68OFEIZLOn9ZKCtFdt7WwpvYpcidghUQCenUimxIDecYDIhXTCLebEX8Lzc4G60bJI06XrMhJ/kUQbBsq1j7tqmH0JzPeoRHrGQLuNKyS7oduupQ10DuSzccbgIzdg2UwwV1SafqHE/luDduG/HnCc7jion+kPyCah0Gdux1BjUG7eZSNXm7t2FF5ahGWzL40eY1mQ0lWh0cahBI59bvnEmIApvl6YIZ4bs5n86csOcTuX1LlaAjnMHNQ+n7TsiKyBvplsC+Za/YcV1iubjQDwe2X5XgkoKDy3DpYIeDn/M3IwHWWTZs8
 7akq6SfG
 cr7gArOZKl9PPk2ZKu2aiMGKHjrb0dq/WbdSgKqjP+82Dx/++Ty7w+GEruhrxu6f7iY1zesakZEtGcZf3aHIZutrreZZWnGoG8MUg1mv3kZQ1IrhQBZjGE3jDWG7gNGjB6PO/bivwovnnOoU3ZuVZMDa9h5rsMMh+aEh9SpMhzO8kUUS9vV759RPny+BRKK7vHKHas3CTJDwvFR9/8OWSUntrFzL/2ttF39zbfPbz9m4gXZ9U4JL7umwQeJfn4eVav1opYiHHm9+H3wqCF/M/bdKQe8MEdqyld2MfQTo3gYzLSoaaatVBQnJ8Ma3Svi6hAacDdcFLv/21uMeW+BS6IU+Ij1YyiHJCOJ37epZScD3VpqrmNeo2FZE4MULlGPBfXBjlfoos1gVcEgMtZrXvLuKCIeOKMnT0L9Ddf9WKhysrRbyroOoTFA55RDpyH1S2ZkzaFkLn6elyF+6kw10YOSdJJKv6gQL1lSOf7HJHjTxPGEHUOGT/9fHJfcca3XTdci3GQTNYczDdn60ROmk94Sqs6OyGeU42YW52DL3ljGtUJJNRMW9pC4hZp0JoWwsgkAlA3mREPeZOnUPNG2TFaEE7D0HBAJZtP2kQxCx7uERXRfok3CkfxEe43A+9n9YBVw5Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 04:31, Jeff Xu wrote:
> Move __GFP_SKIP_KASAN from GFP_HIGHUSER_MOVABLE to GFP_HIGHUSER so
> non-movable userspace page allocations also skip KASAN tagging on
> allocation and poisoning on free under CONFIG_KASAN_HW_TAGS.
> 
> GFP_HIGHUSER_MOVABLE already skips KASAN because user pages do not hold
> kernel data structures and tagging every 16-byte MTE granule on
> allocation and free is expensive. GFP_HIGHUSER has the same contract and
> differs only in being non-movable, used mainly by DMA-BUF, DRM/GPU
> buffers, and non-movable HugeTLB.
> 
> On an Armv9.2-A device (6.12 kernel, kasan.mode=sync), this reduces
> 32 MB /dev/dma_heap/system alloc+free latency by ~80% (~59% alloc, ~98%
> close) and improves an app-loading OpenGL benchmark by 15-23%.
> 
> Callers that access GFP_HIGHUSER pages through kmap_local_page() or
> page_address() (such as ramfs, pipe/FUSE buffers, kexec, and RDS) lose
> HW_TAGS checking on those pages. None of them store kernel structs
> there; this matches the trade-off already made for GFP_HIGHUSER_MOVABLE.
> Generic and SW_TAGS KASAN are unaffected.
> 
> Signed-off-by: Jeff Xu <jeffxu@chromium.org>
> ---
>  include/linux/gfp_types.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index c1331bf0b239..bb54c7abfb02 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -376,8 +376,8 @@ enum {
>  #define GFP_USER	(__GFP_RECLAIM | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
>  #define GFP_DMA		__GFP_DMA
>  #define GFP_DMA32	__GFP_DMA32
> -#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
> -#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE | __GFP_SKIP_KASAN)
> +#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM | __GFP_SKIP_KASAN)
> +#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE)

Can we please add a big fat comment above GFP_HIGHUSER, explaining why we use
__GFP_SKIP_KASAN and which security impact this has?

-- 
Cheers,

David

