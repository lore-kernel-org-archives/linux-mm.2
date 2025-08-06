Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771C4C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 16:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DFCA8E000B; Wed,  6 Aug 2025 12:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B83B8E0003; Wed,  6 Aug 2025 12:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F4C38E000B; Wed,  6 Aug 2025 12:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 03DDA8E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:57:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B21D1604C8
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:57:00 +0000 (UTC)
X-FDA: 83746937400.30.EA95E82
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id F126740011
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:56:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oyO1w+tX;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754499419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5PqbvjRGjMIDF7i8slXvowPSAzu5lPRPgUKGUscwGWc=;
	b=0uFDeJbGc6T83wj/g7hd8H0igUUl6YB62YOSYx9ULusZfm/C4JZppL9KKSl2VptdbLOCmX
	wE8iVVnj+rk9feoHqawrHopordsBs7LB1lqLh6WiWmBKZdZsk/oJjxLZ2iITDMqfFYhILA
	xGCvsLzsJFUpFmC7CgE3dQVRn5k4+tI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754499419; a=rsa-sha256;
	cv=none;
	b=4EDrhE703f0H3QOxu3RnyAnZzjrXok5Su2vdKDbaYFFP/dfPYDZY11KvrYgs40lNqsjgow
	dpcimY6YXrNyc8YmG4Ozu1ntdjRpnAyU8GJvC49zeZNf6MZcpHOZe42qu/QgiRU9MyJ79w
	pvv01TRyhDp+d027GipHKrG5RzP4e9g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oyO1w+tX;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A6D560203;
	Wed,  6 Aug 2025 16:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC30C4CEE7;
	Wed,  6 Aug 2025 16:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754499418;
	bh=6VJOV51UUM14Q8/toC0ZbrbyRUsviN5blQFEgzQCA58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oyO1w+tXRvmiUp12Id1M7+/SjgE51p/1pDK/nVK9GoltG68CmJ07Wwx69+qZjNFLQ
	 9r+MVfZa65D3mUjDTiZsCuOaoFvddZASOU1KAYIm/cE3XylteMIwMneX+qyLcp+KXV
	 TD/KLyJXdj79naEXJhxdEt0St7f68Xsr74sLRsiMJ7YuqbQQdNxmzLChlNX3o1uaa9
	 3YWyGxzF/PjDOWCcNwjGpEPwu1SXwyOIP7DxPKhsFxEW9XaPlq5wHWFi7G1EkSvjG5
	 /USMn3F+LgtRTRZiyZdZiNhsdImC823BHD6hFdIi906eXddeZyJRmO2rn5o1KtePia
	 K6UxH9+YFFhew==
From: SeongJae Park <sj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>
Subject: Re: [RFC PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Wed,  6 Aug 2025 09:56:54 -0700
Message-Id: <20250806165654.82673-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250806163221.GA1795303@cmpxchg.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F126740011
X-Stat-Signature: r74wkcfngh5z9n48hzb7mjuxhjw5ggq8
X-Rspam-User: 
X-HE-Tag: 1754499418-632562
X-HE-Meta: U2FsdGVkX1+C0LEDL678HUWIYzARsvlgfv6jv9t/+WEetgvk3dJu0+wsBSC7bfcp5FbjyHkvT7ISoySXyopoodXDgTe/H58nLCbnPHNzDDjEiWX8k0ayuimFDeF0wQTSRAyBV/Lw0huZvoL3h8SULymgFH7Rl7hZjNQyCFFF/pqkzz9NtOGFdPH1/Kuz4zSqiEGBawbV8hGZhN9Lf3DymHoQosx4M9o4q2GxmFIzn6rdbgSieJFrIw2sgTTClBfMJMpmZto9wfX+Ea6o4Cwwb+zyBEqzrHglQwDI2dVYnx8C0wHYoEmNvgSwQc0OyHq5ZK1RxieohShrYp8VzfgxvyKkT05ehbDAm7AmXHBkOS39iZXitUwt3fU+/L1dEURsi3yh2tv4OVBdmSliekrWmq3DwxeEKeLTrczk7V+bm3iQ6tMlXwymha8Kkr089KlDEQo/iGOh7r22GqIExnvC815hum+xnKy5cDUxzAHvHLvLQcAii/CJP44E2vMPGChIiKdIxHVilCcjtACkVER73mk6PF9csX85Fa9E7FvRGF4OAVwnrMKOfY6mdZDTuL1Y429hc982drS4qwdKkF/JmtcFPpsxCDXiU00KPrwydkeWUP5dcImrHwKDn3HhmqcmgFbkc/q/dsqFZJIfNYuKv8Glnu4cGm3M4qYp86OrvCkXEVBLpGJgrJHQBUmm4p/34RrNl1+YJXHJO1ZEDs6pSGZ725yW/6HFGsGoZQQPRWmKBy1XHTUrxYyyj0X4LoBD1EWTOshvF1ZflcHU54XbumXCXBmjHZd2x5eEmFheKjTnkMfY3724MHpjRbFv3zovxfRKsHiMUkLyHB9hmMywEqLze2CE+/el7UYoFKf+49GQCreotmXf6GmDHDKwX8Td4cZuYpYhehm/dGmM3ZHsc0py5uGf16OGL77xbQw6GMF6fKuv8MnSRF91WNaaeKfJjMdCmCgnqWJ7yNK814J
 v2QoBePX
 jZ1pVEE6idVZO99Dba56BzdycaEYMkFgaUtqANWsH55xWC4VoleQtUsWjAkpllYHhWjvZJVytOSwt9ElgMcRO2ek9KHdlWKEjSPmBWd8tP2ws3X5nQhFcc3dZynCgck9ibiXhMttDkN6nmOr3pmoMy00slhDeSENbYOw30LoRE1+u5CVDewFK8r/tpK+riVv/HS2j1QYvUKXyG8XL/1/USFK1Vc1F+2+qOySRY5XGtRngo60vGSfigPFu9XVb5LFJSv/5N4IrVxSooBhSlCCIztYCgc0uXb4YZUyBy1EFRsDfgjAqyPM43aCby+BlXM7fnhh4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 6 Aug 2025 12:32:21 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> Hi SJ,
> 
> Overall this looks good to me. On top of the feedback provided by
> others, I have a few comments below.
> 
> On Mon, Aug 04, 2025 at 05:29:54PM -0700, SeongJae Park wrote:
> > @@ -142,6 +142,15 @@ User can enable it as follows::
> >  This can be enabled at the boot time if ``CONFIG_ZSWAP_SHRINKER_DEFAULT_ON`` is
> >  selected.
> >  
> > +If a page cannot be compressed into a size smaller than PAGE_SIZE, it can be
> > +beneficial to save the content as is without compression, to keep the LRU
> > +order.  Users can enable this behavior, as follows::
> > +
> > +  echo Y > /sys/module/zswap/parameters/save_incompressible_pages
> > +
> > +This is disabled by default, and doesn't change behavior of zswap writeback
> > +disabled case.
> > +
> >  A debugfs interface is provided for various statistic about pool size, number
> >  of pages stored, same-value filled pages and various counters for the reasons
> >  pages are rejected.
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 7e02c760955f..6e196c9a4dba 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -129,6 +129,11 @@ static bool zswap_shrinker_enabled = IS_ENABLED(
> >  		CONFIG_ZSWAP_SHRINKER_DEFAULT_ON);
> >  module_param_named(shrinker_enabled, zswap_shrinker_enabled, bool, 0644);
> >  
> > +/* Enable/disable incompressible pages storing */
> > +static bool zswap_save_incompressible_pages;
> > +module_param_named(save_incompressible_pages, zswap_save_incompressible_pages,
> > +		bool, 0644);
> 
> Please remove the knob and just make it the default behavior.
> 
> With writeback enabled, the current behavior is quite weird:
> compressible pages to into zswap, then get written to swap in LRU
> order. Incompressible pages get sent to swap directly. This is an
> obvious age inversion, and the performance problems this has caused
> was a motivating factor for the ability to disable writeback.
> 
> I don't think there is much point in keeping that as an officially
> supported mode.

Makes sense, I agree!  I will do so in the next version.

> 
> > @@ -937,6 +942,29 @@ static void acomp_ctx_put_unlock(struct crypto_acomp_ctx *acomp_ctx)
> >  	mutex_unlock(&acomp_ctx->mutex);
> >  }
> >  
> > +/*
> > + * Determine whether to save given page as-is.
> > + *
> > + * If a page cannot be compressed into a size smaller than PAGE_SIZE, it can be
> > + * beneficial to saving the content as is without compression, to keep the LRU
> > + * order.  This can increase memory overhead from metadata, but in common zswap
> > + * use cases where there are sufficient amount of compressible pages, the
> > + * overhead should be not critical, and can be mitigated by the writeback.
> > + * Also, the decompression overhead is optimized.
> > + *
> > + * When the writeback is disabled, however, the additional overhead could be
> > + * problematic.  For the case, just return the failure.  swap_writeout() will
> > + * put the page back to the active LRU list in the case.
> > + */
> > +static bool zswap_save_as_is(int comp_ret, unsigned int dlen,
> > +		struct page *page)
> > +{
> > +	return zswap_save_incompressible_pages &&
> > +			(comp_ret || dlen == PAGE_SIZE) &&
> > +			mem_cgroup_zswap_writeback_enabled(
> > +					folio_memcg(page_folio(page)));
> > +}
> > +
> >  static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> >  			   struct zswap_pool *pool)
> >  {
> 
> > @@ -1001,6 +1034,17 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> >  	return comp_ret == 0 && alloc_ret == 0;
> >  }
> >  
> > +/*
> > + * If save_incompressible_pages is set and writeback is enabled, incompressible
> > + * pages are saved as is without compression.  For more details, refer to the
> > + * comments of zswap_save_as_is().
> > + */
> > +static bool zswap_saved_as_is(struct zswap_entry *entry, struct folio *folio)
> > +{
> > +	return entry->length == PAGE_SIZE && zswap_save_incompressible_pages &&
> > +		mem_cgroup_zswap_writeback_enabled(folio_memcg(folio));
> > +}
> 
> I don't think there will be much left of these helpers once you
> incorporate Nhat's feedback, but please open-code these in either
> case. They're single user, hide what's going on, and the similar names
> doesn't do them any favors.

Agreed, I will do open-code these in the next version.


Thanks,
SJ

