Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90A69C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 22:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D7B26B0088; Fri, 28 Aug 2026 18:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 288BD6B008A; Fri, 28 Aug 2026 18:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177B36B008C; Fri, 28 Aug 2026 18:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBF9D6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:20:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75F80A4033
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 22:20:21 +0000 (UTC)
X-FDA: 85152097842.20.2543F2F
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9B05E40003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 22:20:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iqvlyjhc;
	spf=pass (imf11.hostedemail.com: domain of hughd@google.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787955619;
	b=aebMlquWbO8ZTOxAedqj4fralwpRxKrohhHFWcfE9FdVgVNfOa7zYJyNRwLPIDZMCCMNne
	mPM3ZhpVU6HKGCky/5kgst18xQPP6vyvay5DknyaTkhoDaQLDfoXeOV6AHDelcj0UgbU4e
	E3vltrS+941PVeW+RXFVSJ4y1xVChvI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787955619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b4S/8Koo0tWCwmsJIfU4dprBEqIORdY9GwO+Ne2fREg=;
	b=QoXfsj1msoY0VXbV5/WHghSwYBVguEsvxSJq0+5zdD4cfBfqrRXP2huezWdFNhWetPDU3J
	vMb8VHcnmdBKwan9Du9/agxR5SqENXGKYZbCrTkTpC2I60NiW1q6Yj5OqBMT38IFMii1NX
	uyK7rky6cW5O2S1sFWrDGrx35jK84a8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iqvlyjhc;
	spf=pass (imf11.hostedemail.com: domain of hughd@google.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-66ceaade3f1so1472007d50.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787955619; x=1788560419; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b4S/8Koo0tWCwmsJIfU4dprBEqIORdY9GwO+Ne2fREg=;
        b=iqvlyjhctr1ODCjxFMOWQtnH3Bvo6G2creWOF9+TKjRnOk1eE25GJb8UHxxX1P+x/A
         P6dfWRDVpOip4iCofsqCL/GauKaEgqWx/xxY8D/dX6IHPS5P1cE39sjR44FoVUWcmawu
         n/9fzkqbK6k+yP0JnCrodqiacty6QYBd9W73oMacUTp0uMhlxDym8X6E9B2b4cPWWuOp
         Exc0mt3btlhelE7geDGFuQY2bnKHdJD2rsS2QaXbY6Oks97LEoxntj88e3GRlPB4MNGh
         RllHIt2Y96OPD7zsvejeWERdAddctxbaCjsqMOmBwdV7WTrKTvJn416mTLSW5NFWB16C
         2ovQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787955619; x=1788560419;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b4S/8Koo0tWCwmsJIfU4dprBEqIORdY9GwO+Ne2fREg=;
        b=C3zZuBZedhPfaqTwn76WF7dIO5etN2tXoF6XUOmbLi6TARoPNRbPUA7DSgywqoryG1
         uNrosEzk5SVK2Dzk5Xp3mIoy//1Z9jrZOVIdzzeaY5E/QIJBj6GpOtlbeVdDtKRAlK/0
         tRqSQEnnnL8vE9XYL4qVV3L7Vh/Xn6a7AQ69ab3EKFyqWE8yQl7ND20PqDbIsfbmXOv4
         kxXjEkczz+dgHdXfJ5eariuhUhMW+166g8Ayie7zPMczUn2npOWst28PZF+N8DgkPcqU
         9ppjVTimC/Yfx4VilV4B3nOCSsfRRzpNjmnnTD38f9tbHUlur+8aU9fz8KD4vTRq8ucO
         6S1w==
X-Forwarded-Encrypted: i=1; AKwUvBxrf++Pgtrupd+TLiu5jFiVZSe31Ggkgs7YSZ70bvdfUUvTNiSEZFd6wLrnYu00itSi/tgKoQ23hw==@kvack.org
X-Gm-Message-State: AFuF++lW7zGHVvfRP2nh8fQ9dpQ+syzO5Dm9LIudwMSstvfl8G6n94Sh
	Lts1za2rqg9EEAc6HPjwTd7mW28DHYc+A6s2TJCAo864VaPqCWiLmOLl9WY4wAMMmQ==
X-Gm-Gg: AYBFou24Z+LjcWLypOe4b08+yrBdPWoyr+FBxrfiMb+88B5H/n6sU1n8Au+3ewWn5Ip
	+UDCxk+5eAkKjzXrKa+6FN+Zt4HpAHIHJDbUofz7JIOFDomTywKipmNf4SgvR4k1awSvBJMnp6M
	y9DXQXsT+fle9E/wq53lDW+PUgY5XKFY/gUp391KaeQcbqAWmGPia1ojFkEW+BF3RT4g8jtGHoK
	xZUYGLQzCQ2Z4sUcEcC4Ib+rZl6MX5qiWA/I91OoZ7RnW3WfwzcBj3d4SUJ1FnL7gJy429p8fEd
	SfiRCjqDq7mFpl/1wNBf029tdmAm+f+ds1PAHbqPWN23vvi4hmIa7JYwaNl4k2p270FV3Oyj4w/
	Hx4kcyWQrDn+tPfMLJ7p1fDPVBAS/Kk/c1OckjLw8Ag1C4PGm4/rcJjSZUoWHsQ+Ps6OpCa2dud
	NnDa3mjH9jaqfggSCBn5C8305CZPwSTOdfoJ2ptFTknikWLOsJoQKyRHD5c89xkfPK5bIffe1Mm
	/7IuKT4AjdmdwMHduDcu2+8qW1ntlscOoeLNPHk7UXNL851k7SZTNGEruE=
X-Received: by 2002:a53:e884:0:b0:66d:2e51:5690 with SMTP id 956f58d0204a3-66e4c6242d9mr2552474d50.11.1787955617852;
        Fri, 28 Aug 2026 15:20:17 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66e4ed2c78esm1613351d50.19.2026.08.28.15.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 15:20:16 -0700 (PDT)
Date: Fri, 28 Aug 2026 15:20:11 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Matthew Wilcox <willy@infradead.org>
cc: Hugh Dickins <hughd@google.com>, Kiryl Shutsemau <kas@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>, 
    Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 04/25] mm/fbatch: lru bit set, no extra ref, while folio
 on per-cpu fbatch
In-Reply-To: <apGd6T84Zs1RgTVg@casper.infradead.org>
Message-ID: <d8834642-140a-0bc6-0b3b-abcfbb8ada6f@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com> <e0887417-85a7-453e-e733-561dc11db08f@google.com> <apAaWsWPV9QEeVwn@thinkstation> <3b8d9cc4-d6f9-6bd6-f774-34cfca9c48c9@google.com> <apGd6T84Zs1RgTVg@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9B05E40003
X-Stat-Signature: sejg9ijccghjg5g9ohs5gpnb4a9aumfs
X-HE-Tag: 1787955619-245165
X-HE-Meta: U2FsdGVkX1+fqZ5EzXKq3FwEn+vPCmfIxEsxW3XBhaVVeG5HtTRXEXY5Ic9t9iH2M7radO47YaRIK802ELkqTKns/6N4bFqYOR7/OP3OW2K4UJXkWoosP8COL6szaEBdhUm9Pu9kqtR105XeCzRok+7NabGyRxvvUYU/u6Pjz5PnhdgXJcDvEvmWQ8CT1CGWZrSa8fwFF+UVgDKIosxkBBKjfM3pSPMakkOsPdvZC+QC0POkdLSSSuTM/eb3B9eoI6OpY/euukqxUPzjSKgxNzZ5ZftEjE+wRexOwzsT/NV54X6XoN05pnH9o/mccl+HhtYJJNjtMqnpVY2foAqYd+QPD1zWe0yO4zmaKa7zj9zAU0ElLXNieDM6jetlXauL1uyHDdu/xcCYw8PS2wvlVM4BkQrvoZ+06grqF+TR4zUePAPoU4PsO8OcwdkI3WYHj32HpEKRc70ffi/xhzdKPHz9GEf/pSJH3B6ChayHbvVbnKYNgo8fbOygHioWYPeGJDoaOvBqPj6rdslkSsFwMQz2sHO8Sp/Enr54IIZgJgDkj6QlfIa8I1cXFurJb2FC8LyKQlwVMEkUrEZGudgGWMwpt6uXaLtwACcgOIe67hwAaoX4mnQjryeCKo6k89Zpqg/FY38zEr26G8gAz/AQJGRKbBpfEfg4dDt1jZmBJq4g/nzvUaZIZ/yjlVI2fzy099ne2b6exQlXsgw2QBNw29cR7JpfT8XHn1A35tkH5OiBGuyDEUmWmOh5jnVAA7dGQORS0dHs1kJ2sudTdjZughN4xTorfRd+POLjWF6BpBTeuO6Vb5eWhHoZKMSRWYHzMdXSFni3sg+j2pFe/wijK110DXoybu3Ac1mncV0PcbRMJj8X9XlwS4ZuJOfauHmwzSED7VqNhKaeC4C9svVAHFKqSUnBi5Fp4hmarvOecZJ5e6NciF06Ur03A265Zm9dyiGp0k+9/x2tGP2gikF
 v5P9m73y
 ONgor4qdjA8NDUKAeQpknRfzKDhNSXjHFn/pGZpqPwWJxPUDWlj7bEfRO3nSRxBPM0LUIyMUbKeHmh06T9RfEXAfeKVJu3ZKk6vULql/X3nDAf0nUnPEHPghHUkRe42DcPNyZ8TqOi56eVlU16A0CuMC+Cayv5G3y7KF6ie/+Ib1WllZHO9F/mMp1nB0TQzsysGTjEEijY5VxHIOSqV1V/6p0xERCiJm977ETjR3i+t47mWMSNQsP3BHj0vA1sqMacV4n46uMXk7/z3GRxwztfO2zl1L+HGKVwZtQ53S1+9KNlsQt1nOGdXLpnt9qh+pu9RLv+zeo+ELKqgxuw+teMjeI9yGEuyKWaQ4nPZLFoR6mALqYRK4SI5ejSYaH/5ok5Twq0v+0XIjGUPn0UXmQPXY5PCRnW7M8YKS0uK9Fii2GLTM7FkM92r8dyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026, Matthew Wilcox wrote:
> On Fri, Aug 28, 2026 at 01:04:34AM -0700, Hugh Dickins wrote:
> > On Thu, 27 Aug 2026, Kiryl Shutsemau wrote:
> > > On Mon, Aug 24, 2026 at 07:01:20AM -0700, Hugh Dickins wrote:
> > > > Treat folios on a per-cpu fbatch as if they were already on the lruvec:
> > > > with PG_lru set, without holding an extra reference. This will enable
> > > > the removal of most lru_add_drain() and lru_add_drain_all() calls soon.
> > > > 
> > > > Recognize such a folio by 0x02 set in the folio->lru.next pointer by
> > > > folio_add_lru().
> > > 
> > > Hm. pfmemalloc (__GFP_MEMALLOC) thingy already claims the bit. Is it
> > > safe because such memory is never on LRU?
> > > 
> > > Are pfmemalloc and PG_lru mutually exclusive?
> > > 
> > > Do we want to be explicit about this? Like, folio/page_is_pfmemalloc()
> > > shouldn't return true for PG_lru folios/pages or something.
> > 
> > Gosh, thanks so much for pointing that out: I was completely ignorant
> > of the the pfmemalloc use, and a bit (bit 1!) shocked to learn of it
> > (why wouldn't they just reuse a pageflag, I wonder? but doesn't matter).
> 
> The idea is that it is used temporarily to communicate from the
> page allocator to the caller "This only succeeded because of
> PF_MEMALLOC".  Making it a page flag would require all callers be
> aware of it -- most simply do not care.  PF_MEMALLOC was set on
> their behalf and there is nothing they can usefully do with this
> information.
> 
> So we want to communicate it in a way that allows the unaware caller to
> discard the information, and I chose bit 1 of page->lru.next.  We
> used to use page->index == -1UL (which was also naturally overwritten by
> the unaware caller), but we needed to have it be part of PP_SIGNATURE
> and that needed to be not part of page->index ...
> 
> Commit dc8cf7550a70 if you want to read more about it.

Thanks for explaining, I had looked at some of the other commits
implicated, but not that one.

So, it's a special snowflake which can melt away before it interferes
with anyone not interested (which a page flag would not): yes, that
makes some sense.

> 
> We do use a page flag in slab; we check the pfmalloc bit and move it
> into a page flag (SL_pfmemalloc).  But we don't use it for folios.
> 
> While there is a folio_is_pfmemalloc(), I think that was a mistake
> and it should now be deleted.  It hasn't been used since slab was
> converted away from folios last November.
> 
> > Anyway, as you've rightly guessed, it's not a problem at all: these
> > mm/folio.c and mm/mlock.c per-cpu fbatches are entirely for folios;
> > and if any pfmemalloced page ever get used for a folio (dunno) and
> > put on an fbatch for LRU, then of course its use of lru.next is
> > immediately overwritten (first by what this patch writes in lru_next,
> > then later by the lru.next pointer for whatever LRU it goes on to -
> > just as before this patch).
> > 
> > If you were to tell me that some subsystem uses PG_lru for some
> > other purpose, then I would have to get more worried; but we can
> > be fairly sure that's not so, since mm/compaction.c for one relies
> > on konwing it's free to  play with PG_lru folios.
> > 
> > Whether a folio is ever allocated with __GFP_MEMALLOC, I'm not
> > certain (haven't looked), but there is no need to exclude that:
> > it simply would not retain that page_is_pfmemalloc() info across
> > folio_add_lru().
> 
> That's the correct thinking.
> 
> How about this patch?

Oh, when I said "This certainly deserves a comment somewhere",
I meant an acknowledgement somewhere in my series, not a complaint
that it had not been already commented.

Once Kiryl pointed me, I found the comment in page_is_pfmemalloc()
good enough: the problem is not the wording of the comment, but
knowing where and when to look for such a comment. We have many
header files, and understandably no registry of low bits in pointers.
Wherever you put a good comment, I'd have missed it.

So, I was okay with the original, but your longer explanation below
looks fine, and the removal of folio_is_pfmemalloc() good, but best of
all is the comment line (nit: wants a full stop) you add in mm_types.h.

Thanks,
Hugh

> 
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dd09c438fa23..fcefffb52d3e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3122,36 +3122,25 @@ static inline void *folio_address(const struct folio *folio)
>  	return page_address(&folio->page);
>  }
>  
> -/*
> - * Return true only if the page has been allocated with
> - * ALLOC_NO_WATERMARKS and the low watermark was not
> - * met implying that the system is under some pressure.
> +/**
> + * page_is_pfmemalloc - Page allocation should have failed
> + * @page: The just-allocated page
> + *
> + * Usually the page allocator keeps some memory in reserve.  If
> + * __GFP_MEMALLOC is used, the page allocator can dip into those
> + * reserves.  The caller can find out if the allocation came from
> + * the reservers by calling this function.
> + *
> + * If the caller does not care, it can simply use the page as
> + * normal.  The field that the information is stored in is usually
> + * overwritten by most uses of a page.  Nobody should call this for
> + * a page they did not allocate as it can easily have false positives.
>   */
>  static inline bool page_is_pfmemalloc(const struct page *page)
>  {
> -	/*
> -	 * lru.next has bit 1 set if the page is allocated from the
> -	 * pfmemalloc reserves.  Callers may simply overwrite it if
> -	 * they do not need to preserve that information.
> -	 */
>  	return (uintptr_t)page->lru.next & BIT(1);
>  }
>  
> -/*
> - * Return true only if the folio has been allocated with
> - * ALLOC_NO_WATERMARKS and the low watermark was not
> - * met implying that the system is under some pressure.
> - */
> -static inline bool folio_is_pfmemalloc(const struct folio *folio)
> -{
> -	/*
> -	 * lru.next has bit 1 set if the page is allocated from the
> -	 * pfmemalloc reserves.  Callers may simply overwrite it if
> -	 * they do not need to preserve that information.
> -	 */
> -	return (uintptr_t)folio->lru.next & BIT(1);
> -}
> -
>  /*
>   * Only to be called by the page allocator on a freshly allocated
>   * page.
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 09cb1e18bc16..9bcfc4213b91 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -85,6 +85,7 @@ struct page {
>  	 * WARNING: bit 0 of the first word is used for PageTail(). That
>  	 * means the other users of this union MUST NOT use the bit to
>  	 * avoid collision and false-positive PageTail().
> +	 * Bit 1 of the first word is used by page_is_pfmemalloc()
>  	 */
>  	union {
>  		struct {	/* Page cache and anonymous pages */

