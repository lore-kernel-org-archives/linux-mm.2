Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBFCCCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:05:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1154B8E0007; Fri,  5 Sep 2025 15:05:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C6498E0001; Fri,  5 Sep 2025 15:05:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF7388E0007; Fri,  5 Sep 2025 15:05:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC4008E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:05:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6EE898438F
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:05:31 +0000 (UTC)
X-FDA: 83856125262.22.8E0FE36
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id BBB62180014
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:05:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HyiAhuxG;
	spf=pass (imf06.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099130; a=rsa-sha256;
	cv=none;
	b=ltxlDu2oy+YeYSk0Wu6xK88k1eP6mH/i/dZdhCZ2kiAAjCJA+RveScvmBKVCYU7AIJZxeL
	EJoyNp+vxEHXfWuYzsM8dCnMNogVMWpMoXSkNoq+JEx3wwYc3XIV22CE22C6uiisdkLdzZ
	HbGxVi70+knd5H6iJ0qUk3Qih4F2Ezg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HyiAhuxG;
	spf=pass (imf06.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBdBbd9rF6CefLoKkHIThKZGfWxDEedn2PW+zbsTzWM=;
	b=fhgdmtgha7iyYdqiAXAE22jkA4U8tc2xMbi3E/ImTLv+Wq7mOEkl8UqYMW0aMKHMI2NN0S
	50LP96XNKFx/t7mqMTe3fhmmEm/UpniXosaquBaeA7cAiRE/O7W8jMqkCIkekUgZcHUmYz
	ZS+EECCHaqphB47cyL/JW3uiNYN9oQA=
Date: Fri, 5 Sep 2025 19:05:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757099127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TBdBbd9rF6CefLoKkHIThKZGfWxDEedn2PW+zbsTzWM=;
	b=HyiAhuxG9cVVBHaUEZSJ7rZK1hcY2Uy3HKrlUrLe0shw+fKFuKb1XSxfJnMvDYeuWoMvG9
	VGindFQfzCodCmnBuFl+nX1P+fto2XrtWqcd/xrBx65FbFT0RCGIzXoVNJ8kcbixk0kAjy
	80eMNrAO3zECB8hXBEUHgdUIGuyOkHw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: zpdesc: minor naming and comment corrections
Message-ID: <mgt4ejjyz64ehnyskv24nzjllxxie4jvxb6i2dzlq43yev5dtu@sfltngevykts>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250829162212.208258-4-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829162212.208258-4-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BBB62180014
X-Stat-Signature: 59otmy93htb1niroqfitmxnnfguuxtaz
X-Rspam-User: 
X-HE-Tag: 1757099129-196344
X-HE-Meta: U2FsdGVkX18JmjQATfLZf7FFr/etZvwSH//fP3RGbM2f7pgB8TYfNLEPcDcZuIQ4lnyu2XjzBumcu1bthrpzGiFz9st3hPHSd1pu8cHjpbqfaTJE0Xtnkjoy2G8bzaKfEvWLiQqiRG35SeugO/z6vXzLfZaVfqu0fHtBkMv6LNtLj+gRsRTevS9ktY1VM5yyqxnU2sJYTMfZ89B4iG8Q9kxOJQBgPRKd0ZR3mdWpzdgI4FyKrt4NyZgOV5NGU/iWJJkH6STmvuFlUtD3BFwIK1OtDRb2oTJCHnRUqbNsOsTQW7xlUh1ZQhAbLXcVeSyoYPQiHcgrFkDf/TXC+t6vlaCUf0HncRm8zEwQkH5kkFcMbc+O4IJcTTaRk1Z2x5r75+4FhDQfWJhfQlRLkcL3lPAJHqdqnDkMdrUgJnTA7RWtDQG/bTBSDz313MAMyAmaj5lqpXyaDuzwDln+2H3i8PV+1N+3I7KuSP8BziBPzI9uPvFkxsnsJ2/spO0a5kJh2X8zj4oILFmta53AohCt6OcWsPbiqxb/gBnp3ami66vLRtcmoNAJo2pRL8P3/EdEgOFSUtme0PF79dChNgUSDXwQP4vFGLHiHuu2VwwwgJaQ2bcavoPXtOAXBnbC+MU5ZYJQ1KxOcjICUGxlVk4PcRf9XvP6FhnIxONXnPNABivDC7ARAJfanqG/QtgEtKtVlNZ++XF8oqprfj77fnxEiNwFl4jmG0e3HNzZaLCmk/5Z/icFNfgZLqRxrvzw2Im8dAFUT91oAQcrHuLeeL8BNWrVpsbdO+wNpnjoveoKUhavvlfaEOk5eFuWfQ1pDxU+cBX0XGwk5YZngBfOa3HKXBzsUO0Bfu5EhgzOaOhEwpQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 05:15:28PM +0100, Johannes Weiner wrote:
> zpdesc is the page descriptor used by the zsmalloc backend allocator,
> which in turn is used by zswap and zram. The zpool layer is gone.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---

Why not rename zpdesc to zsdesc or zdesc while we're at it? It's a lot
of noise but it's just this file and zsmalloc.c IIUC. Up to you.

If it's just the comment changes I would squash it into the second
patch, but not a big deal. Either way:

Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>

>  mm/zpdesc.h | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/zpdesc.h b/mm/zpdesc.h
> index 25bf5ea0beb8..b8258dc78548 100644
> --- a/mm/zpdesc.h
> +++ b/mm/zpdesc.h
> @@ -1,5 +1,5 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
> -/* zpdesc.h: zswap.zpool memory descriptor
> +/* zpdesc.h: zsmalloc pool memory descriptor
>   *
>   * Written by Alex Shi <alexs@kernel.org>
>   *	      Hyeonggon Yoo <42.hyeyoo@gmail.com>
> @@ -11,14 +11,14 @@
>  #include <linux/pagemap.h>
>  
>  /*
> - * struct zpdesc -	Memory descriptor for zpool memory.
> + * struct zpdesc -	Memory descriptor for zsmalloc pool memory.
>   * @flags:		Page flags, mostly unused by zsmalloc.
>   * @lru:		Indirectly used by page migration.
>   * @movable_ops:	Used by page migration.
> - * @next:		Next zpdesc in a zspage in zsmalloc zpool.
> - * @handle:		For huge zspage in zsmalloc zpool.
> + * @next:		Next zpdesc in a zspage in zsmalloc pool.
> + * @handle:		For huge zspage in zsmalloc pool.
>   * @zspage:		Points to the zspage this zpdesc is a part of.
> - * @first_obj_offset:	First object offset in zsmalloc zpool.
> + * @first_obj_offset:	First object offset in zsmalloc pool.
>   * @_refcount:		The number of references to this zpdesc.
>   *
>   * This struct overlays struct page for now. Do not modify without a good
> @@ -79,8 +79,8 @@ static_assert(sizeof(struct zpdesc) <= sizeof(struct page));
>   * zpdesc_folio - The folio allocated for a zpdesc
>   * @zp: The zpdesc.
>   *
> - * Zpdescs are descriptors for zpool memory. The zpool memory itself is
> - * allocated as folios that contain the zpool objects, and zpdesc uses specific
> + * Zpdescs are descriptors for zsmalloc memory. The memory itself is allocated
> + * as folios that contain the zsmalloc objects, and zpdesc uses specific
>   * fields in the first struct page of the folio - those fields are now accessed
>   * by struct zpdesc.
>   *
> -- 
> 2.51.0
> 

