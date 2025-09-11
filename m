Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1E5ECAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 22:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFA6A6B000C; Thu, 11 Sep 2025 18:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1ED6B000D; Thu, 11 Sep 2025 18:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0EA46B000E; Thu, 11 Sep 2025 18:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CDB916B000C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:23:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A338869AB
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:23:27 +0000 (UTC)
X-FDA: 83878396854.21.2B97C5A
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf25.hostedemail.com (Postfix) with ESMTP id DE922A0006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:23:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="oYf4Wl/v";
	spf=pass (imf25.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757629405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9atdt/om7OmffbDgov9WTxIsiO59X0BmEMtINP1uP9A=;
	b=Pbru3F8RH6sPjiGvQ5+ghke01xur/mgy9Uj6G6KO170a1VCZWqG2zvLGPhwGirk9OokrO0
	qAgiBIvPZp71A5nIONnK0C5JHNV4Q+OgWthKjU9X/KXMpWhNWsqNofZ49IN9TlKCkwwDs8
	JiQn6J7yFNI161Ao8F+KoiCAXOSiv2I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757629405; a=rsa-sha256;
	cv=none;
	b=PQcFBsiiqfUtr+k4b9nFaUjMKDQg3k8ZlWW1rp7TdRXLkLhYkCIKganyo5OjW7cRDmA7ED
	IbLZpgJTov6na+KXex3ddN/32VvXS/xvE3e+6jFQLqZea5gDHNjM+phTu0dsp+1xpupW4A
	oB4MM7U2I62m8RF8fnpHoKJo+JvE1y4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="oYf4Wl/v";
	spf=pass (imf25.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20250911222322euoutp011634560d57af0d6769ea82508ee6c7b3~kWqER7Qs81513015130euoutp01K;
	Thu, 11 Sep 2025 22:23:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20250911222322euoutp011634560d57af0d6769ea82508ee6c7b3~kWqER7Qs81513015130euoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757629402;
	bh=9atdt/om7OmffbDgov9WTxIsiO59X0BmEMtINP1uP9A=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=oYf4Wl/vK4mtCwLnlaPuk0Vbqm1kIIG4/GofumuhdavmIiBHyUZQRceOU6BgMduk5
	 UPpbMvZbaMJvAX41rCofkjz8fUum8Xd7cFaLczcWfrjE46zM7Gw77+bY+gxYbnaXwW
	 jL8zkycMTQXVpPJyDpmR0+MuvHwC/4FUakNYU3YU=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250911222321eucas1p114043a72e011e2fff92df33a2133b21e~kWqDhtt8p0600006000eucas1p18;
	Thu, 11 Sep 2025 22:23:21 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250911222317eusmtip2aabd06b78078a7146730dff557f2cb71~kWqAG3AB-1019110191eusmtip2F;
	Thu, 11 Sep 2025 22:23:17 +0000 (GMT)
Message-ID: <5ffc63e9-19bd-4e12-92fc-57fe12d10f4f@samsung.com>
Date: Fri, 12 Sep 2025 00:23:17 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v6 03/16] dma-debug: refactor to use physical addresses
 for page mapping
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Abdiel Janulgue
	<abdiel.janulgue@gmail.com>, Alexander Potapenko <glider@google.com>, Alex
	Gaynor <alex.gaynor@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>, David
	Hildenbrand <david@redhat.com>, iommu@lists.linux.dev, Jason Wang
	<jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>, Joerg Roedel
	<joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, Juergen Gross
	<jgross@suse.com>, kasan-dev@googlegroups.com, Keith Busch
	<kbusch@kernel.org>, linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org, Madhavan Srinivasan
	<maddy@linux.ibm.com>, Masami Hiramatsu <mhiramat@kernel.org>, Michael
	Ellerman <mpe@ellerman.id.au>, "Michael S. Tsirkin" <mst@redhat.com>, Miguel
	Ojeda <ojeda@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	rust-for-linux@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, Stefano
	Stabellini <sstabellini@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20250910052618.GH341237@unreal>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20250911222321eucas1p114043a72e011e2fff92df33a2133b21e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250910052628eucas1p160daa0dadb6f81d7831d8047628aa9d4
X-EPHeader: CA
X-CMS-RootMailID: 20250910052628eucas1p160daa0dadb6f81d7831d8047628aa9d4
References: <cover.1757423202.git.leonro@nvidia.com>
	<56d1a6769b68dfcbf8b26a75a7329aeb8e3c3b6a.1757423202.git.leonro@nvidia.com>
	<20250909193748.GG341237@unreal>
	<CGME20250910052628eucas1p160daa0dadb6f81d7831d8047628aa9d4@eucas1p1.samsung.com>
	<20250910052618.GH341237@unreal>
X-Rspamd-Queue-Id: DE922A0006
X-Stat-Signature: iw1ugndyag3nhdognh41nryx4xqz9wei
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757629404-683424
X-HE-Meta: U2FsdGVkX1+I1gPYZsRooo8RFar89t4s02ERDSUA6zR0Ri+qTEJl4C4sq0b25yMKoJb7Hl4fBVGvk1NPleA6oKhrP9kjyRiyM7c3XJIGvSl89/JympnJSQbKtmKuGaj7sz0SHjciAYLFDZ2F154Zb7tsvyQSJ2l7/iHNa19AOFlbDPu+XQtzfESHNpVZSKo6ZpgvBSgkUoZuCgDuu8JCEOzxeVpiZ7g01zK6hPJvrP0IpHK2ipV+WUiZYR5bon6m4pY7ETKx7jxH1AwmFLRyzl12w14NQhcj6lMrXIdj3MckzPoZ8lL6N0n4lhlPLTUr5K/n8hszjdzjLDWX3pix/b/w98QQbnAwGrDF2lmHp6cT0+ReqbSZt+4HQ0n+B2h9kHkJoWHiFB3h31bl6OGOdSjji/+m9Jab8wfhbZ/3KgC+LEhjXpVVbaObAV0zCVGCbZ023Srb/ojhmpK23PbKbTBDADsk1NDq233jQCo+jkVn8izDrR4GjKTc7YnupkrlrUNdRxzYAU0vzQA7r1XuXLHEzIREb4T5qQC7TYqRNa8jh3lflkgRhZ5sX+Wi4vUBuAegyDVlmxzVVpLA+u8+zIDgGZ1mvI/m/RDxGqgiLAPo/qxtGY8dmF4L31LT9QedwT/5w5Ju5/2PU66GyDEf4hIZ46rugI14JPPvT3q2yvWL8HUDlvqSCC8Ntq28VeLeLPI0rKqudDCkHlC2O8Ptd8nKCiLQIt+pPKv2va6DEAX5cychFVQ6mlFjXi20ssyAOkrKgyIYBrUHwOQL/RE1fp6SEVQSi14YFKfpkKrb3ez2aiOQtT1bk/VubN4AduxKNR7YG23ktm5NmnV6jVC6299SfFHe25wMoEzsyANA1uwQD0bh9yRZz540MHm2UYgVByDeBnncHTw7tQn4iWNRX1uojXObW3n2Jk3ylIqnXk/sU3m7/wyWZAU8GYA4iYfdYptmVJHD42Yh88/4rKe
 w2brqSwq
 THbvf5POCiDkefJtjFcwjZOQU/5dmLmuJ9+fpDr2v0IdFjrb+hRZIaYjY/IADDKs/TmwFCZQABFG7NyCfTxovjqAOjYZNWe0km60lB0m0k8sX8nbB+yXMDGtfoTYhVKuYZsBsWt40OQsvKSoOO5zZfp30I1kGVRMik3V4k5/T0no+n6c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.09.2025 07:26, Leon Romanovsky wrote:
> On Tue, Sep 09, 2025 at 10:37:48PM +0300, Leon Romanovsky wrote:
>> On Tue, Sep 09, 2025 at 04:27:31PM +0300, Leon Romanovsky wrote:
>>> From: Leon Romanovsky <leonro@nvidia.com>
>> <...>
>>
>>>   include/linux/page-flags.h         |  1 +
>> <...>
>>
>>> --- a/include/linux/page-flags.h
>>> +++ b/include/linux/page-flags.h
>>> @@ -614,6 +614,7 @@ FOLIO_FLAG(dropbehind, FOLIO_HEAD_PAGE)
>>>    * available at this point.
>>>    */
>>>   #define PageHighMem(__p) is_highmem_idx(page_zonenum(__p))
>>> +#define PhysHighMem(__p) (PageHighMem(phys_to_page(__p)))
>> This was a not so great idea to add PhysHighMem() because of "else"
>> below which unfolds to maze of macros and automatically generated
>> functions with "static inline int Page##uname ..." signature.
>>
>>>   #define folio_test_highmem(__f)	is_highmem_idx(folio_zonenum(__f))
>>>   #else
>>>   PAGEFLAG_FALSE(HighMem, highmem)
> After sleeping over it, the following hunk will help:
>
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index dfbc4ba86bba2..2a1f346178024 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -614,11 +614,11 @@ FOLIO_FLAG(dropbehind, FOLIO_HEAD_PAGE)
>    * available at this point.
>    */
>   #define PageHighMem(__p) is_highmem_idx(page_zonenum(__p))
> -#define PhysHighMem(__p) (PageHighMem(phys_to_page(__p)))
>   #define folio_test_highmem(__f)        is_highmem_idx(folio_zonenum(__f))
>   #else
>   PAGEFLAG_FALSE(HighMem, highmem)
>   #endif
> +#define PhysHighMem(__p) (PageHighMem(phys_to_page(__p)))
>
>   /* Does kmap_local_folio() only allow access to one page of the folio? */
>   #ifdef CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP

Okay, I will add this fixup while applying the patches.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


