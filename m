Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E559109C027
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87D3F6B0093; Wed, 25 Mar 2026 10:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854816B0095; Wed, 25 Mar 2026 10:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A496B0096; Wed, 25 Mar 2026 10:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 662056B0093
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:53:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3BAB25BAD1
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:53:34 +0000 (UTC)
X-FDA: 84584879148.25.B06145A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6F08A18000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:53:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bvHMKGo7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774450412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pg9BGRjMnJsXPkM0swwEs/eI5ok+Dj8gFwFH1IOCh5g=;
	b=k78Xf0rhxrC940yyK/n88a1UZj7r3qReoCSyd1fWyPA1WEg6XkywPNuCugqpVOgMUxcUQI
	IChBlOmQ4smDT88bXo98zt09KfHwztrtHY6bodCP7ohVJfypt/XusA8eLd95pJsfbcx2r8
	w+JErtDa6VaPh7JY6+oOc/9gOQ0IEBo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774450412; a=rsa-sha256;
	cv=none;
	b=bA6PC1qjadIo458mZh2Qh5VuII4Z16UNA7OUgHlR0kK+HecHUPpeGQp+FW5yLkoYCXGKf1
	2SD0R036QD49GSHJ0AHvPPe7Y1C44AI3SX+T4ryU7T/ENPocvH5XHVADrjbffpMlX8ceEU
	XX8PDQ7nHMcofuMBNCHo9aYMOdA4tE8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bvHMKGo7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EA564189D;
	Wed, 25 Mar 2026 14:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1631AC4CEF7;
	Wed, 25 Mar 2026 14:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774450411;
	bh=pg9BGRjMnJsXPkM0swwEs/eI5ok+Dj8gFwFH1IOCh5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bvHMKGo7C2FvWUchrPoeFaP+aBjxBO1iDfBDPu1ftOdOR9CZZDLVUFhCz/c7WGA7e
	 why6Yw24IOjuRI1p2bP95VB6ClN3gKVLzT0jfMnfC6i/nYozQuCobhRSSwOyXF1N3e
	 byo4/RyWBj3jJuX+8109h+cusNOVoW1YRJJbnkzrjTlLtysvhWEr4e7NJhA0wos2+k
	 fx1cPkStcPHCC3jsOhMQDS1F6pwJ6xb82zQvvaulOqpwhrnvUJ/5TyvKvTmDP6MVMS
	 pJz6XV1MltczUwUgLDYNLrOBFtEIandUJarxRBC8UrloEnhtM8rgFwrglv5AFfDkkq
	 NMz0cLZrxbpPA==
Date: Wed, 25 Mar 2026 14:53:14 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/6] mm: rename VMA flag helpers to be more readable
Message-ID: <f72132e1-a2a3-4445-80ec-adeb525dcfff@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <0f9cb3c511c478344fac0b3b3b0300bb95be95e9.1772704455.git.ljs@kernel.org>
 <6c6le67q23xsity3tkfq2uazzhwustmqcsqj3talft6qq737hz@dytog6bi4vsa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c6le67q23xsity3tkfq2uazzhwustmqcsqj3talft6qq737hz@dytog6bi4vsa>
X-Rspamd-Queue-Id: 6F08A18000B
X-Stat-Signature: iguxuuk5yuc8h1tct93jsr4hp6d8awp3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774450412-921289
X-HE-Meta: U2FsdGVkX1+pYuxMK+gNJ2Sy/COztKWZmede4Z8K069n8iCGJW6IqU0JrXL1qZ4zfak4GUkeEKMNOC28HA+bdpayJyAdjcgH33Hd0/x9SoEbvwqXDE/7QUAYEsxsxNnM6ATFUbr1lVjxXbySMKg+3TLFW4Bm5L12IiBY5btvbBTIOU84ruTmgS4dngMgvt2QLwosGCDnck7SX5NnuN35WszDiN7Dovflqsb+mrhg/a3DM1wUBO+fnDr1DepaET5vkUV729SMYsSMuHheDrNJ7SjO2SKGAlxcjRezkkaxbtNwVEW/GkgrQHubqcP2T4vYDlAHDOhNy+kl5a3TWO9L3N8UqSH832Ck7jwfOSpqDM58lXZ1VcGBDP80wHUxMOVYIzVHm5OBP5Y5up6s8fXwUL020Ldcs22evHr6Kk6TQGntxuvkBQ2TZQ9ZaX9RcCpezE6ncTtwt9AJ7Bs4wj5c6zyHAfcLzQ88u/fB6xPjP8hEdNyCU/lf4r6ZDanWoXSjTFKJJ2gCZEs9/nIqWcBPvNDqetX4P+7+ss8jNRET3iX3uWfw6ukpZQMHjzaRuZ3w8/A3cO+aR8hW2rR6uyLURu75kvABMbly7LAlVxtaZDVaRqBGulc6VOmPVm3yXwDvEmb+WbfnfsiENv20sz0/qzUafFR02wmb9IpYFrgTmwUS9UzZn+dvXBXQ3RY5fuvCiTgqYVS3Z0fDgYUKV819ykTE4CUiEo/+UGxnjQrLvdwGkGE2et8FQRFblxhjJfrj4hUbVVyuMVLFISU404f31st7CWHYWuuShuBYxGJaM8/+5Tv8384CZxyQPI6QGthoPXFQzbgKqY8KjbiTs8mLU2/aUTrWQmTVJc+jye3d5oi2x0iKMKXTnhqFbPY+38GGuyoa/EyvzE7fHEvcqFOzSiUpYyO5dFRt5P75q4kerorTNgSSGpj6JpRyPWUknsquhf3G8p6V0PbBbbNVLcn
 RGNtZvAj
 z+JLQfP7fzntB1XyvedZX1cQb4MzMd9iUqzj0dZSMlSshkLQ9LTDGk9ySL1ibb29p1slCRweRHh7st0xy9mAi8e6HHjZNI/ZVX7wsaWETxcrvYyS7GwEV09NkUUL0kBapLwCPu944IHl0NRVWRf+3uqh3mYPG6Y12JsudQJhzYLnHEleYKta4HKjN7FCiImuDkTRUii3g6SDEfoyWywbrH2vCxBVjh6pekFFOub7hrrnPJeg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 02:51:04PM +0000, Pedro Falcato wrote:
> On Thu, Mar 05, 2026 at 10:50:14AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > On reflection, it's confusing to have vma_flags_test() and
> > vma_desc_test_flags() test whether any comma-separated VMA flag bit is set,
> > while also having vma_flags_test_all() and vma_test_all_flags() separately
> > test whether all flags are set.
> >
> > Firstly, rename vma_flags_test() to vma_flags_test_any() to eliminate this
> > confusion.
>
> Hmm. The names are getting longer. We should fix this One Day.

:) yeha it's a bit of a trade-off still. But for now keeping it (fairly)
straightforward.

>
> >
> > Secondly, since the VMA descriptor flag functions are becoming rather
> > cumbersome, prefer vma_desc_test*() to vma_desc_test_flags*(), and also
> > rename vma_desc_test_flags() to vma_desc_test_any().
>
> >
> > Finally, rename vma_test_all_flags() to vma_test_all() to keep the
> > VMA-specific helper consistent with the VMA descriptor naming convention
> > and to help avoid confusion vs. vma_flags_test_all().
> >
> > While we're here, also update whitespace to be consistent in helper
> > functions.
>
> Extremely amazing patch! you were truly inspired!
>
>
> > Suggested-by: Pedro Falcato <pfalcato@suse.de>
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

:) thanks, I don't know who could have suggested such an amazing idea, well I
won't read the tags to check + spoil the surprise... :>)

>
> --
> Pedro

Cheers, Lorenzo

