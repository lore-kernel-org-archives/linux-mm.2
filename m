Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BC8FCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 13:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F6FE8E0003; Mon, 17 Nov 2025 08:43:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A7248E0002; Mon, 17 Nov 2025 08:43:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 395B48E0003; Mon, 17 Nov 2025 08:43:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20D0F8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:43:22 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A90C61DDD4B
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:43:21 +0000 (UTC)
X-FDA: 84120215802.26.59D2216
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 09D8A2001B
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:43:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Jjh93+km;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763387000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9YVuu7zAULl0ixowM1tYF4wrONsB1jmbz+W8pAwYhcU=;
	b=HySqjhNr0CQQvdjh1uT/KeqdXNHNWhkIbLBiQNld7dl94XODvMayvW69sK3fd0TLM0rYKC
	eMoA7lStPhbyBKBWpRaTeGvhvvCFBZvbaLSq8vFrSnKV4jeUiiqYhJbnjXd2py7lx3/RvM
	crAAnNjnSlJQ2BipF6sNKtC/cOcIlvM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763387000; a=rsa-sha256;
	cv=none;
	b=dfNuo9WeRYiBHMhGqZgO4ag88eNKyJWRDuSyeS+hRI20gPneY+k9jEAcmlk1TS9pVDsX9Y
	vBK0DeB7LehclEk+6lO6G2FOMs/GWa4AhItQYVuUZho7dlIVKFJePjeHs7o4ja43fHuAox
	MtdCa999h9KObiIxOddPVfCOHTdEEXQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Jjh93+km;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9YVuu7zAULl0ixowM1tYF4wrONsB1jmbz+W8pAwYhcU=; b=Jjh93+kmr9SpMk/YF5lvhgC2u1
	ZlLsFwt+ATReBnLApmCMvDdJSY2oNVNipqTUPFWCQry6k8bU6FXiczgKhMtGrjOEm0kvGhrY+PTH5
	7aynII8OLBrKH8zYUJV1vdToERpFDa8P6bWYOHLmbH7JpYg29hoM3vHl0jll7oo+MHeVcxV21b3XJ
	S+kqdLRnmwBA75pDGLJDgsSWUY+NB3F2rS+32Suu8VkMT1mloxKDd1vZ8xc1rMCTp+DIYxKLls+fD
	oW0POF7znBkybXltQwPWEILV7jBbFvCKGZm952EKG3CmTi+AyRzaylIyPLpvyIbLFobnUvKx10mR9
	+7DS/e5w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vKzVY-0000000DtlN-38y7;
	Mon, 17 Nov 2025 13:43:04 +0000
Date: Mon, 17 Nov 2025 13:43:04 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>, nao.horiguchi@gmail.com,
	linmiaohe@huawei.com, ziy@nvidia.com, david@redhat.com,
	lorenzo.stoakes@oracle.com, william.roche@oracle.com,
	tony.luck@intel.com, wangkefeng.wang@huawei.com,
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de,
	muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v1 1/2] mm/huge_memory: introduce
 uniform_split_unmapped_folio_to_zero_order
Message-ID: <aRsmaIfCAGy-DRcx@casper.infradead.org>
References: <20251116014721.1561456-1-jiaqiyan@google.com>
 <20251116014721.1561456-2-jiaqiyan@google.com>
 <aRm6shtKizyrq_TA@casper.infradead.org>
 <aRqTLmJBuvBcLYMx@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRqTLmJBuvBcLYMx@hyeyoo>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 09D8A2001B
X-Stat-Signature: uxy7ucuydy3ho39wsg4ja9psauk9dzse
X-Rspam-User: 
X-HE-Tag: 1763386998-749703
X-HE-Meta: U2FsdGVkX18J6GXTcVXgsDPxgFRYLBZPo7h6zrpdG0gN+Z4V/zT3qt+DC+cXv1J9K2Tvz459YL+bD8v06QDuEwMJseL/9s4IkuF0E4t3oxLxDb0SR3Stlbku8E07oTM4KJeEFT+W/KL1JGoONgmPke8gLaiCABq3wzRTJt5Wky/9UQx0Ch/cUWxFD7qIDm6Pd9LEf/hQS30BeEtbD9wTb5ZmgTzdloqjl/7gP6qCZ0bXEUxVKlWepvYSWcv5xqyHXYYf6X567w/QZB2He7JaGXE5ccfBRJ0bSr3wS2/gA4gotTsGBlpKNVyR5mOI/Uuj2zlibbUIy1Ih8dZiQ/40UtCsXnWzqPZbnhF105Otu+MVPi2nvhYIOyBG7ND8Clbdz7sgEjA4cHsdVnh5IuSp0iuVzXqpeS0EeJ/oGZH0MgVLywhS75USIVLg0v3GiDa1rYUVNnRrvuBMqMnG2yjwuaYQmTdsA3/iqZT+IKGz4Ma/e2TujwRjC4Wx1jB2RCAuyFMRKR80MI715k3TktzLLhg1kYAfV1uDFk06/NDTY+MRd28YOx0M4Xsg6QGeVbCEUwLCKgma5afsT+XFRQRlh/ue31oFZ7Bk5MetvCTbQuGbIz0bCRwwoOr2L9nmG6rOlmszglXaFGyHl7fUh4Didp5aKgazldcA21EbNFrBWgYJMf5MFG4qEk2CwF98Ia6vpUwBmh1Mh3Nk4yoojK29BltkAOlu2DG45v4GG6LJjXRcrlATjW4mktufHzRf3roAhPZOQiewQRsxi2rutal7cxy71bz4fxDNnyL4leLQvu3DFIP6TY7A/jL/I3FGMb6PSm9EZ2BIgRQFuYIaSm/kNkFxnHAHt8y0h5g7BzTfrTfyDA+RurB9mdgVskjkrHoFaFkskbSygf8edB9jX+8nUTHCCRJF0VGfswxGEX7eGx/ddVdX/4vmDdZp+v1HLGGQKjbrGGDYDcvlJBSLcwB
 rWryM/qA
 QqEfoOOOivRv6nbgjfRXQ+8yfd6+/wzH+5IILdiuwQ8I0lNYUXBz/E73JPw9zKsgGHEKGhywbwzw87c7CkznfSEaUgnxoISBNTNvymlZYQN2lIQBeKA2ot9kIdftalDylvboNTQfgpJVWlJguF6zjj8LjS6JAxgMvmmCRL+OKX0mlouUCAb+H/yR4Tuww8qXfrTF5m9nt8UtPb3RCDGjKjsPLTPh4aLsKtANWh1MyPChxn4ZvErhgfS8w8ZGQPI067s0ANczUu5lyADfqeY2YXm22DMyi69tz71Jc5gSFPHCyCNm8dvEjfdoNhr9mdOLTCa6fuRP6Yt6lQ+g6spMH68ALjc1FicmxzribGLZPfHkhiBhqwc50axlXSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 12:15:23PM +0900, Harry Yoo wrote:
> On Sun, Nov 16, 2025 at 11:51:14AM +0000, Matthew Wilcox wrote:
> > But since we're only doing this on free, we won't need to do folio
> > allocations at all; we'll just be able to release the good pages to the
> > page allocator and sequester the hwpoison pages.
> 
> [+Cc PAGE ALLOCATOR folks]
> 
> So we need an interface to free only healthy portion of a hwpoison folio.
> 
> I think a proper approach to this should be to "free a hwpoison folio
> just like freeing a normal folio via folio_put() or free_frozen_pages(),
> then the page allocator will add only healthy pages to the freelist and
> isolate the hwpoison pages". Oherwise we'll end up open coding a lot,
> which is too fragile.

Yes, I think it should be handled by the page allocator.  There may be
some complexity to this that I've missed, eg if hugetlb wants to retain
the good 2MB chunks of a 1GB allocation.  I'm not sure that's a useful
thing to do or not.

> In fact, that can be done by teaching free_pages_prepare() how to handle
> the case where one or more subpages of a folio are hwpoison pages.
> 
> How this should be implemented in the page allocator in memdescs world?
> Hmm, we'll want to do some kind of non-uniform split, without actually
> splitting the folio but allocating struct buddy?

Let me sketch that out, realising that it's subject to change.

A page in buddy state can't need a memdesc allocated.  Otherwise we're
allocating memory to free memory, and that way lies madness.  We can't
do the hack of "embed struct buddy in the page that we're freeing"
because HIGHMEM.  So we'll never shrink struct page smaller than struct
buddy (which is fine because I've laid out how to get to a 64 bit struct
buddy, and we're probably two years from getting there anyway).

My design for handling hwpoison is that we do allocate a struct hwpoison
for a page.  It looks like this (for now, in my head):

struct hwpoison {
	memdesc_t original;
	... other things ...
};

So we can replace the memdesc in a page with a hwpoison memdesc when we
encounter the error.  We still need a folio flag to indicate that "this
folio contains a page with hwpoison".  I haven't put much thought yet
into interaction with HUGETLB_PAGE_OPTIMIZE_VMEMMAP; maybe "other things"
includes an index of where the actually poisoned page is in the folio,
so it doesn't matter if the pages alias with each other as we can recover
the information when it becomes useful to do so.

> But... for now I think hiding this complexity inside the page allocator
> is good enough. For now this would just mean splitting a frozen page
> inside the page allocator (probably non-uniform?). We can later re-implement
> this to provide better support for memdescs.

Yes, I like this approach.  But then I'm not the page allocator
maintainer ;-)

