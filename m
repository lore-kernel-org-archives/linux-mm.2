Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE1C6CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 20:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34A978E0007; Mon, 15 Sep 2025 16:00:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D43C8E0003; Mon, 15 Sep 2025 16:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C2CD8E0007; Mon, 15 Sep 2025 16:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 047CF8E0003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:00:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB4921DF555
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:00:29 +0000 (UTC)
X-FDA: 83892551778.05.B351F4D
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5D4F3180012
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:00:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eZk1KD2s;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757966428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EFAzIzkGyy83vkY5iLmnI1QK7ML7+RNPnvuPL8o2hhg=;
	b=JI0wci9rG3ARl21Tmj90RO2rR0bjHQXWNef4MO96u3AazqhURs200DXb8PODfbmSG46HuL
	3WJMhfhVboC3VSxTvxPQ74WRkuCMwSPBuPewPE2+Xfo4mnvJgUfTUFLuvO2EJONBwL7Nhp
	eubXUHe+krdavPtlGnaWZ9J3jObZe10=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757966428; a=rsa-sha256;
	cv=none;
	b=sjtv2N8LuRCjudiexH3goUyaAttdCikFjnA6OK3sGTFS8tig5JHzMWMSrgwmF4dgzbShyB
	Qm9cjRXzhQkaAmg03IJyzNAiMlG6YqCE2tbjgWB1XJOoWGutW0iRtAcbJF7czzvExeNDGP
	H9XKINLTjSo/ToOBGqSgBbcehjIHTBg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eZk1KD2s;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 15 Sep 2025 13:00:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757966423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EFAzIzkGyy83vkY5iLmnI1QK7ML7+RNPnvuPL8o2hhg=;
	b=eZk1KD2s7qbkOKSDSTmkSAP9qY0RlH1GWtoJr5jNgQB+oYXB8AwMWcuKEGGGb1IO62O+e6
	t5LJo9/9fyQ6LrHi9Smyu1Nnk4xHZiGj91g+FFTrAeA8GLX1adPhyfsxmJ+xtSIzPg2W4n
	INbMHMugd21QVTN0doHgllBfgqUWYaQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@redhat.com, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com, 
	hughd@google.com, willy@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
Message-ID: <giqlfqh3itraeh5w5aofkrhnae7kglc53f3uzbe357chk22blh@xx2tqnp6dmch>
References: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
 <b8c0fe71982aa1cafafd59d8e71064efaac16007.1757648598.git.baolin.wang@linux.alibaba.com>
 <qe56xt2natnxnkht7wgknsb5nqjhinaaajomvvvgnfpwry2jih@hsj2w5zqj6wv>
 <02798d6c-1ad3-4109-be3a-e09feb5e4eda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02798d6c-1ad3-4109-be3a-e09feb5e4eda@linux.alibaba.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ayfyus5fzt7yepwe4gaokna3i6g68aw7
X-Rspamd-Queue-Id: 5D4F3180012
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757966426-853338
X-HE-Meta: U2FsdGVkX188QxC/VE4FAjmkIFhicEw1nR0d3WMgvyK9thY5Kvi3lLZBf/RlkAG9fZo2PNxOA2mxp4H6zpYcuLJMDZ/7lY7rcRt68fGEdfOHpD4HwlMYmOP/+SE7Os01u/wcTcfD0en2Qy7cAJVZtt6tANIC2NIBLLM6Hd510Tk/H4WKJVYfnaOiJeCOHaXCkVOXps3AoWQauv9fy+w5JdMyAQOil5Dqk5blSWkpiQS6qfMCaN4fyA2J+PN6QhTO5ygOEOuMxdda38Fylw32MuAa5XoE7tWqyxzZm66w48L8nlxqtEG6j4JQA0CmS/64fCJ5W0zt0OHuZkZADZ0ql7Yavx+jlDN03cChcShgjdnQJqlVNP8H3AMuHroAy13JsgXSEa936i67yJRXvmRxl+ZLfapbiHtemIMTKQabXHj1Yx1wjvEcF6aO16XHrXy7WywuxvaDecAmRuZJ0G8u1Gzhz0Ix1lXFVptpacv8wp9gz2c8ffNX7FDotxlp8cAo+Y8TRfGeMrXLOHcwfJPxGpwsvAl4/fEFUaxKso9tAuC2nEZmKq1MfF6VSmmr1iezwCUlIlH6CDM4D0dotbTnSe6N3FFN+9En+248JNo263OIaBBlOkInUkbwj0Z3JcaZ76FUU7+r5MZh8U6ZhAEfjNz8R9ZKfUv7SHuv8vVVMs35gq0XqQlV1xgkGGIs6wOgloqV+oDQygizz9V6Ul+bCcXftLnsPfeWeKkb8U7QYOuCmfgtbFghCEELwHFDARC8rBqhOMIDm4AZYU1R0VrSAL6Rilo3XjiYQt9R9MkKISjPGWJ2f5MRa7QeVf5hXtK89/x2a+3ig1vlGWg+Tj6yJdgKLfuiQ5YaK4wTUroF75SA3lne8P1JCSBiLBJxGjW5KvunddEUwRdqchMDEb6/OZ+lhnnq2YD8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 13, 2025 at 11:24:35AM +0800, Baolin Wang wrote:
> 
> 
> On 2025/9/13 00:13, Shakeel Butt wrote:
> > On Fri, Sep 12, 2025 at 11:45:07AM +0800, Baolin Wang wrote:
> > > Currently, we no longer attempt to write back filesystem folios in pageout(),
> > > and only tmpfs/shmem folios and anonymous swapcache folios can be written back.
> > > Moreover, tmpfs/shmem and swapcache folios do not use the PG_private flag,
> > > which means no fs-private private data is used. Therefore, we can remove the
> > > redundant folio_test_private() checks and related buffer_head release logic.
> > > 
> > > Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > ---
> > >   mm/vmscan.c | 16 +---------------
> > >   1 file changed, 1 insertion(+), 15 deletions(-)
> > > 
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index f1fc36729ddd..8056fccb9cc4 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -697,22 +697,8 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
> > >   	 * swap_backing_dev_info is bust: it doesn't reflect the
> > >   	 * congestion state of the swapdevs.  Easy to fix, if needed.
> > >   	 */
> > > -	if (!is_page_cache_freeable(folio))
> > > +	if (!is_page_cache_freeable(folio) || !mapping)
> > >   		return PAGE_KEEP;
> > > -	if (!mapping) {
> > > -		/*
> > > -		 * Some data journaling orphaned folios can have
> > > -		 * folio->mapping == NULL while being dirty with clean buffers.
> > > -		 */
> > 
> > Can this case not happen anymore and try_to_free_buffers is not needed?
> 
> For dirty file folios, pageout() will return PAGE_KEEP and put them back on
> the LRU list. So even if mapping = NULL, background workers for writeback
> will continue to handle them, rather than in shrink_folio_list().
> 
> For clean file folios, the !mapping case will be be handled later in
> shrink_folio_list(), please see the following comments:
> 
> /*
>  * If the folio has buffers, try to free the buffer
>  * mappings associated with this folio. If we succeed
>  * we try to free the folio as well.
>  *
>  * We do this even if the folio is dirty.
>  * filemap_release_folio() does not perform I/O, but it
>  * is possible for a folio to have the dirty flag set,
>  * but it is actually clean (all its buffers are clean).
>  * This happens if the buffers were written out directly,
>  * with submit_bh(). ext3 will do this, as well as
>  * the blockdev mapping.  filemap_release_folio() will
>  * discover that cleanness and will drop the buffers
>  * and mark the folio clean - it can be freed.
>  *
>  * Rarely, folios can have buffers and no ->mapping.
>  * These are the folios which were not successfully
>  * invalidated in truncate_cleanup_folio().  We try to
>  * drop those buffers here and if that worked, and the
>  * folio is no longer mapped into process address space
>  * (refcount == 1) it can be freed.  Otherwise, leave
>  * the folio on the LRU so it is swappable.
>  */
> 

Thanks a lot for the explanation, yes this makes sense.

With that, please add:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

