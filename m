Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0638FD29C2E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 15:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62F9C6B0260; Mon, 19 Jan 2026 10:15:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DCC46B0261; Mon, 19 Jan 2026 10:15:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8EF6B0266; Mon, 19 Jan 2026 10:15:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C3F36B0260
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:15:34 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA1D3140145
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 15:15:33 +0000 (UTC)
X-FDA: 84349062546.27.ECE227D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E2850C0015
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 15:15:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gxI4WxL2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768835731; a=rsa-sha256;
	cv=none;
	b=sQrVZ4VoSAOx+hieQK0jz6/v5adl1a74YHaJymNqDgs1sal2zSLXtXrxTyBRrlPcobbl7D
	7ADrDBJ4FrvAzkmBFoB26mMj0EhCQZVZHa4M7M1Xv7g1nprSJJxhXeTaRzgA8dOp3ce1a5
	o8A3ZJaePhZ6IhH54/wbEPhxyL2Z88E=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gxI4WxL2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768835731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9Ftm9K3/CrHaz7f4/GeRVwkDMKWl0p/J5d7jFRWMso=;
	b=Qvh19RNTAAlmPmLn6886Lz0qOOvqHg9tVfaGL8x2bfVeuYxOATN4jvz8joCbInLzGC53wb
	1BLRlu9ZFERS/LvgLb51jhxZ1IjlZirQ0Ac2IpyJxul0eKqFP45NeMfwwFtejuqSetpo4C
	ASMCYPFPd+XgxHQcF0hjh6mDnb+UyVI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5441160131;
	Mon, 19 Jan 2026 15:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69928C19425;
	Mon, 19 Jan 2026 15:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768835731;
	bh=ERVCOL+UrRNglZlm0SAA4pm43qoW2KUHl1G7b7RQrY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gxI4WxL2KeCTrT1loBHKBH3ovIoJwmhprmU+FOkz/6UyJBRwPCNr91rYtPs6PacDe
	 evX53ZMWitptOXs+a3Ou7dX4Xl7PmJINTpXNimVuMmPELldGgGgKwE2orlnX9vEBbA
	 S9zf8vJdjTnTTiLxvnFe2ubuKaYj64JwQjSin/DwAW3DE/lzdxLVrNDK3MlujZxjT+
	 auNDVo7pJ+mHRuSAIW33BPcxSTaUZq4xYlOFTkSYXUX7H4tbKhvuq5FRWoiNUs2Ic3
	 6jFzSqIiw323NAlGa63b3YOUyaHnNdp0Pp40lygpqNqT+dC/94X03xDChegrMtacb8
	 sg4uCUhJ1nfMg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8CFD9F4006A;
	Mon, 19 Jan 2026 10:15:29 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 19 Jan 2026 10:15:29 -0500
X-ME-Sender: <xms:kUpuadZdQgQcT-hJnAcxqwQrRPWBaTZjjZ6sEmDykyxNPXKPPr6BAg>
    <xme:kUpuafxWF6RhjiGh0ZhMwjKoYzkIaY-9rVryNen3QkT2jWGMQRb_RBHCNXgjUUTYI
    iQQZKt-MbbhJpCw8FR-vV9DofZVC5ydYQG004hiA9NA71GB8v17i4s>
X-ME-Received: <xmr:kUpuaZV3F7vtVH6jOmDpG767nABDfS7nrvyfbyLEdZfOSa3-0kzC6GGfpsd8vg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddufeejkeelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvh
    hiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhu
    nhgurghtihhonhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:kUpuaTYQNaUhzdNBpaYFc1P_rbbk59geGHZ0hl22WoKGrCcyyaqVmg>
    <xmx:kUpuaUNWmc-LybbWiCZGW4vtfkyMTsoMNExVXE3u9jJhf_W7ocF73Q>
    <xmx:kUpuaXsW82VIWNabQV2XLV1pbDgDsJmzYu-Uw5RdcERSSnjuO55nWw>
    <xmx:kUpuaa3eOPoICmiQDysPOIx1LxU0w755ZSyaZuzAFyTuFHVwwgHMug>
    <xmx:kUpuaVWYJsNLs_16nkft-ftjAmGrP2kreJwGpoYPpku3zr3CnEXalXSB>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Jan 2026 10:15:27 -0500 (EST)
Date: Mon, 19 Jan 2026 15:15:22 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv3 10/15] mm/hugetlb: Remove fake head pages
Message-ID: <aW5JqibNe4CVBa07@thinkstation>
References: <20260115144604.822702-1-kas@kernel.org>
 <20260115144604.822702-11-kas@kernel.org>
 <30ae1623-63f9-4729-9c19-9b0a9a0ae9f1@kernel.org>
 <aWkhbWR-3fWjeTaE@thinkstation>
 <53980726-C7F0-4648-99E9-89E10645F2E7@linux.dev>
 <aWpTopypeRTOIVGR@thinkstation>
 <0F1C93F3-9A1A-4929-9157-589CF8C0588D@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0F1C93F3-9A1A-4929-9157-589CF8C0588D@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E2850C0015
X-Stat-Signature: ehtko1935anxgmhrmue9naqfmroszkf3
X-Rspam-User: 
X-HE-Tag: 1768835731-267831
X-HE-Meta: U2FsdGVkX1+a7YhXimJkDZbvSo0bZWjsRbOpzr9768B0pCyT6ufyy9rAFDsNYXOl0v8AKEc/Oi1BIZrSq1pJm5W3rupgtintHHZIm5tXmees7VK0gzBjdXkmcWv/wqD9U35YIYUQ0ethgwloSZSYBcsFUnljDoAIAi4K6Il/xk4veeppihqPIfihh0c1+T4KZu9TYBNR6zYUAhuAFwZyaGD29IiduhNL7JoAZHU9EglSiT8tzC+Dx6A+lcZf1RKLRvahEiybLcWjbm6SSSS+95+loeTXpZCxNksM97+ZuO0qd5saLeWvHYM6rR3+9lTgrOgxh0GTZmRWee1dqnw535RkJJQQXBE7ax7bTa7FvmujHfkeJXqstn99w8LmlZmAheYhOAOth71d2lpwe6Ldb/9CsZl9OxqV1MM4ncXf1O/8Ej4xVYL0SC0Ywufv2g7Q41stMXU3DapZIbpjvuAhY/m5zPW2Gudtbrne8hpx5Gm9m38R7Ig5Gs2/mOTv57uOpvypkMe3lYkAu/4fzMRA5pfeajLiKNKASyROFa4VhXk6H5HOwbFRZofiQv9TYyzvun6fFr/jb11PRvUj7P1FYYCCg/usuTl2nVuhU0G6DaKf09BojfQpmRYJB7oUM5orlpTtsk8PzxeAzHoWvuMZBdboCzqAM739Ssb65zawnGI81muEj+nf9bhLIUuXG1CweVvOmvbO4bX5m9lT4+/Jh6PQGFJm6+qEbaFBVbyTIFOJ0qa7pTYvIO2iuK1MNbxBglP32RYw/JeaQvDu5ajWmIaEVV9RbsrkjKzm5IIAMcxCCe/txcWGWk2xT08pqufgVXgv3cxL+2HFNROVJ6TcMgJdJZlRA60bUQMVaI0fPqOjysyTpdbCWHHCuEwsEs1QkFio/FZyap7uvnSY8mK3qM4B6cFXr1bXSMSBJP6mM33vHrb36RAacoGh4fwRaqfoebDEoHjE/0OVQTWwxjj
 XLZ2Udwz
 B0z7X9Oyz95d6S9mu4TdREM1CXz574nwyaJsKsNM5nW9vYAmKo6ue6OAbBPi0yaOiRECo4F3X6GPiwDCZCF38XEIJRtomLgZdL46BjZAEhnx9HKj6XgEj12zKZyolrjufqpMepi51TJojozBeyWJY/YL897IwsGdb75rghAmWAWkxp6GF0FSkkweTtp15bZ/N9B+V3IEkImzj5FHjUbYvUiB3n9PTnibIMkirolxsQCiNxcMkUj7SzSHB9d/1zxjTOPmeNd/E8lPdMy8eR15NZbyUhNphXR6JQ4fAbHQLdxmLbtM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 17, 2026 at 10:38:48AM +0800, Muchun Song wrote:
> 
> 
> > On Jan 16, 2026, at 23:52, Kiryl Shutsemau <kas@kernel.org> wrote:
> > 
> > On Fri, Jan 16, 2026 at 10:38:02AM +0800, Muchun Song wrote:
> >> 
> >> 
> >>> On Jan 16, 2026, at 01:23, Kiryl Shutsemau <kas@kernel.org> wrote:
> >>> 
> >>> On Thu, Jan 15, 2026 at 05:49:43PM +0100, David Hildenbrand (Red Hat) wrote:
> >>>> On 1/15/26 15:45, Kiryl Shutsemau wrote:
> >>>>> HugeTLB Vmemmap Optimization (HVO) reduces memory usage by freeing most
> >>>>> vmemmap pages for huge pages and remapping the freed range to a single
> >>>>> page containing the struct page metadata.
> >>>>> 
> >>>>> With the new mask-based compound_info encoding (for power-of-2 struct
> >>>>> page sizes), all tail pages of the same order are now identical
> >>>>> regardless of which compound page they belong to. This means the tail
> >>>>> pages can be truly shared without fake heads.
> >>>>> 
> >>>>> Allocate a single page of initialized tail struct pages per NUMA node
> >>>>> per order in the vmemmap_tails[] array in pglist_data. All huge pages
> >>>>> of that order on the node share this tail page, mapped read-only into
> >>>>> their vmemmap. The head page remains unique per huge page.
> >>>>> 
> >>>>> This eliminates fake heads while maintaining the same memory savings,
> >>>>> and simplifies compound_head() by removing fake head detection.
> >>>>> 
> >>>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> >>>>> ---
> >>>>> include/linux/mmzone.h | 16 ++++++++++++++-
> >>>>> mm/hugetlb_vmemmap.c   | 44 ++++++++++++++++++++++++++++++++++++++++--
> >>>>> mm/sparse-vmemmap.c    | 44 ++++++++++++++++++++++++++++++++++--------
> >>>>> 3 files changed, 93 insertions(+), 11 deletions(-)
> >>>>> 
> >>>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> >>>>> index 322ed4c42cfc..2ee3eb610291 100644
> >>>>> --- a/include/linux/mmzone.h
> >>>>> +++ b/include/linux/mmzone.h
> >>>>> @@ -82,7 +82,11 @@
> >>>>>  * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
> >>>>>  * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
> >>>>>  */
> >>>>> -#define MAX_FOLIO_ORDER get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
> >>>>> +#ifdef CONFIG_64BIT
> >>>>> +#define MAX_FOLIO_ORDER (34 - PAGE_SHIFT)
> >>>>> +#else
> >>>>> +#define MAX_FOLIO_ORDER (30 - PAGE_SHIFT)
> >>>>> +#endif
> >>>> 
> >>>> Where do these magic values stem from, and how do they related to the
> >>>> comment above that clearly spells out 16G vs. 1G ?
> >>> 
> >>> This doesn't change the resulting value: 1UL << 34 is 16GiB, 1UL << 30
> >>> is 1G. Subtract PAGE_SHIFT to get the order.
> >>> 
> >>> The change allows the value to be used to define NR_VMEMMAP_TAILS which
> >>> is used specify size of vmemmap_tails array.
> >> 
> >> How about allocate ->vmemmap_tails array dynamically? If sizeof of struct
> >> page is not power of two, then we could optimize away this array. Besides,
> >> the original MAX_FOLIO_ORDER could work as well.
> > 
> > This is tricky.
> > 
> > We need vmemmap_tails array to be around early, in
> > hugetlb_vmemmap_init_early(). By the time, we don't have slab
> > functional yet.
> 
> I mean zero-size array at the end of pg_data_t, no slab is needed.

For !NUMA, the struct is in BSS. See contig_page_data.

Dynamic array won't fly there.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

