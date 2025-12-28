Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FC6CD3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 19:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 296C56B0005; Sun, 28 Dec 2025 14:20:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 244416B0089; Sun, 28 Dec 2025 14:20:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1265D6B008A; Sun, 28 Dec 2025 14:20:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 02B756B0005
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 14:20:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 935CCBD321
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 19:20:46 +0000 (UTC)
X-FDA: 84269846892.18.9AED1B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id CFE9280007
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 19:20:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ccOhWjzz;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766949645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cS4PEkXRekfNrMN0zaxa5vqhNj1MA4ODvoK3bHEYmZs=;
	b=S9V3/lKwZlg/09u0tlajj1kHow2hZs3ImOwcQSN26k1hgRQepN/DIGxXhY5GGXKQ9j069X
	SQhx0kdIUiRL0gr2p4wDD90am6ypL3IuOgI4ruL/sn3MxWK9dWzcd6Ok0ZMQL7gr3Heo78
	VL/KAoQXzuzUffTR8I4Liu8cqD4PadM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ccOhWjzz;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766949645; a=rsa-sha256;
	cv=none;
	b=3rU1Yvy9JwbDe8MUzb4FoqRBeoh8SL24RAOUX14Ahq3gE56IEU5f6VrJS2PduIneUppZZQ
	nKJdFLTv3PgirtkKxRrRilAmqkjpdxzNTqq1pIIassnYFNXqgs9cFXmNmlgndNOnKLkPL5
	CRF6fpblOgO5WMNr9susvnlPtixUI6Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E75640E20;
	Sun, 28 Dec 2025 19:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C05C4CEFB;
	Sun, 28 Dec 2025 19:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766949643;
	bh=IhyMm2V7Mz+czGr4Iy5eh9IjUPja8iB0XGAF1orLhiw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ccOhWjzzblKGls3obvK88De2u73Btq8NicABADZf0Ujq52o6NfnybpWNuTXIEwxSU
	 Z2vWIVoVq0l42B/MEU6QJXiNcS0tCoCCPwK5ENqzdrRZBYw6jKa5TsDuedb3Yn2aRq
	 KpmVih3KacttyKTLbkn3713nS7nNHO5c0OHtdbFWK8OyV51a6dcGDAixn5Gj4Z67ep
	 BTY0z1JmMiYldzSeUg58+jFjLYFXIBPDGnmB8EtsHJSCG1yEjRVxT4LBIcTs8zpapP
	 Dq4DY9MNwmg13BA3rkI9W0BTXODAsWyuaUNAbi5EP/bPtpi0pUk9Gbfbu+DUENm/L1
	 7utVDHlnpXWhA==
Date: Sun, 28 Dec 2025 21:20:35 +0200
From: Mike Rapoport <rppt@kernel.org>
To: shengminghu512 <shengminghu512@qq.com>
Cc: akpm <akpm@linux-foundation.org>, david <david@kernel.org>,
	"lorenzo.stoakes" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett" <Liam.Howlett@oracle.com>, vbabka <vbabka@suse.cz>,
	surenb <surenb@google.com>, mhocko <mhocko@suse.com>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"hu.shengming" <hu.shengming@zte.com.cn>,
	"zhang.run" <zhang.run@zte.com.cn>
Subject: Re: [PATCH] mm/memblock: drop redundant 'struct page *' argument
 from memblock_free_pages()
Message-ID: <aVGDA8Vydmh6bT6u@kernel.org>
References: <tencent_600D1BCC5E1B5DB4DDD98679DA7DC3123C06@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_600D1BCC5E1B5DB4DDD98679DA7DC3123C06@qq.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CFE9280007
X-Stat-Signature: gaoytmng146zfr3orzu57iucupnhcars
X-HE-Tag: 1766949644-205206
X-HE-Meta: U2FsdGVkX1+er/yc8R+lbYYNKgRHXRIVnichDDXxNf++2DmGQ7zeM64oesd47XoDLT9lMJZQ08e+fe15AZ8fZiQJlWgVSeSWlMI70TL+Ljaeh079O6xwz9pR7Xmt/WnSqv0lAbEDOYyJgDhGCD4nGx9yzfC47fbmAl3hGwnUAGtYJvMlZxJuGMEQUT1WBFmMFnLacd34QM3Cm0mG5qtUjYkwC7+6PvD7CTFUcoF+0MU1u3oYrrsvVlpXBF++82eAQJCPpbvS5uGr/cpDf2NBJ9G8CXVvREQ6OKonIbNy83NG6angTM9iTv4wKZqqgot7lCrV8rLoB4Ji9HJRXjAeDZ6DXaLlzzbEvFsJ3hHXC9hlUov3kD35kmPMpuOmBJ0b6uOHkd+8LzEuy+ewqUBXi2LfxQyuIybqGmCtIuezJhUxi1WDwzNne0E+MRdLGbTHzQjKGeV1WlTzRz8qcGZY3rCrmO9qyzg1F5k773O6+fCSikUiOxFHesN794CG6QF1NbZlQw119ZqF+wiJYopmrNYVY20YWrgfW2KZVXKvP6mRc2xy6YgioYKh6vOQZ0dm1e5UcmYANgACiJFuB0TtwyFKOpHwiTwpHxWP2Z/ZC9dPcu6BFFf9JioNg3yD8Sdvy7/uzG0cjQXOwAU6c9woEV+IIcvoaupblNqOX1PCMswWyJua9SuGmyruX/lCrt6NJz2YfZLEi85xwblxOavucHhNDmyW0InQtnPm/V6H27FjByfmwMdMQfgqv2tGZsD0hUtKmFEbIBe81w2WbzG5zxgY3C1twwtUAoDu85cNGU26J/NPZPMZh1LMxd2R+LWUYPA31Rj0wwqVzjattQwFjqpWlbN86jWOnOhiSvCHRjHWziLzZGPONJ4Cs+aO708FuaSJqpeq3bFWJkl5qn4BLy7ttiYZY7OMVuAaRdXKZFMobCigQMZBKiL003zhZhUsiFL6PKyQt/0U6skWpx7
 SBFGlS7A
 erPgNRT5NgJXhM1EDIAtetDqzdvI7JqZ+2idTxfS33Sl2AHOORf49oco6fgbNB3YOdZKpfPGZqRIfCN6wDYNG9AbqH286TIS+Do0RYcZ9j4QGXImP3XIAclXRqhymukJBkUOnxwLdqBXi/m/IFPlm6XN2cV6HCjHPwVDqcSUBMUq7PXnc0bNCwN9hLhqFG7hACxS+uOCQh7cxu4UUWD2EHmQF9Xo7losVvBKE5v9Ud1EM7/2E3IxFX80d+QwbqpgN1f9HpO9+0K0KgXR3eIAp+d0QUiihLCi4nqgSs08wwJZqVQHNM2hwuGC1jpL3MA0NOtSs0uMFAiRzpQG836UjBzpCsuIkVpSQQ6kaSeMZNJ38hB8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 28, 2025 at 07:38:50PM +0800, shengminghu512 wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> memblock_free_pages() currently takes both a struct page * and the
> corresponding PFN. The page pointer is always derived from the PFN at
> call sites (pfn_to_page(pfn)), making the parameter redundant and also
> allowing accidental mismatches between the two arguments.
> 
> Simplify the interface by removing the struct page * argument and
> deriving the page locally from the PFN, after the deferred struct page
> initialization check. This keeps the behavior unchanged while making
> the helper harder to misuse.
> 
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---
>  mm/internal.h                     | 3 +--
>  mm/memblock.c                     | 4 ++--
>  mm/mm_init.c                      | 7 +++++--
>  tools/testing/memblock/internal.h | 3 +--
>  4 files changed, 9 insertions(+), 8 deletions(-)
> 
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2480,9 +2480,10 @@ void *__init alloc_large_system_hash(const char *tablename,
>  	return table;
>  }
>  
> -void __init memblock_free_pages(struct page *page, unsigned long pfn,
> -							unsigned int order)
> +void __init memblock_free_pages(unsigned long pfn, unsigned int order)
>  {
> +	struct page *page;

page can be initialized here, the compiler should figure out how to avoid
extra instructions.

> +
>  	if (IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT)) {
>  		int nid = early_pfn_to_nid(pfn);
>  
> @@ -2490,6 +2491,8 @@ void __init memblock_free_pages(struct page *page, unsigned long pfn,
>  			return;
>  	}
>  
> +	page = pfn_to_page(pfn);
> +
>  	if (!kmsan_memblock_free_pages(page, order)) {
>  		/* KMSAN will take care of these pages. */
>  		return;

-- 
Sincerely yours,
Mike.

