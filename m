Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 997E8C88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 22:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 546986B00D3; Sat, 12 Sep 2026 18:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6D16B00D4; Sat, 12 Sep 2026 18:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E6556B00D5; Sat, 12 Sep 2026 18:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 011AE6B00D3
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 18:35:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CEE501205AD
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 22:35:16 +0000 (UTC)
X-FDA: 85206567432.06.48FC127
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf20.hostedemail.com (Postfix) with ESMTP id 153A61C0003
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 22:35:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v+Z0OXe9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of hughd@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v+Z0OXe9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of hughd@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789252515;
	b=WEo7QFUdgmAjmOcjibzdU/g4JheuaNNtHx5mAEa/GWSxnB83SNjp3A9QTsi8WGPwbYxpQx
	Ova9X8tFKy+B+xNxDX4efhjhIrof/vrhWK/gfh/tVNMLCca6m7DbZUZID0D/JPkmCCvy7i
	0EOE4S2iHVw52B+7e5xXOZhoCjS9Kpk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789252515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XyqTSD7+XEJxR7K9Lr2Cp4DYcxTxFY5cqwi53+WEaFU=;
	b=n8BNxmQ30HoiYAgErS9rmkuTLogIdtQmMjJokQswdk/AAwwrJ6oDNGIocsazWe7qQ707Fk
	2XMx01Swk/U8JD6uiJBC6hXAU3AQejlfu8tziXq1vs0IR00S8J6a2LT2ioxJO5HNJpUjAp
	5SGSvZgKjta5Sgc/yJdnVnB+wwTs/ec=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912e64ccso6829465e9.0
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 15:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789252514; x=1789857314; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XyqTSD7+XEJxR7K9Lr2Cp4DYcxTxFY5cqwi53+WEaFU=;
        b=v+Z0OXe9OsWLd2m6pU11cBmo/KZpYqxw8Bh88mUCqJAKIQiXr+SMmtuKSsQGphmUls
         1xb5qgHzjST0Yh+gWyY9QWzMtqB1r1sS7Uq936Z4ErFs7WXrOinQRHiB9bod8hKXOOEZ
         zeqXt1jORU2FSCAKWiKodnVZRn4OjrH/jkKdYopSBm8gxh59NHtGsbXpsN6vOZoLJSWg
         dL4g61+6mE0kPi2oTdZFHzn/HVDF8cSgVrXtKtGL8SrsZ81gkKbh4je+NHSd7+v8U67l
         xgSS5Qj//lrHQFWuvZwjQ+Sx/eAvWW5bf0/GTfCQZelwNNY5DkBsohlAb3x0lfkJEC7d
         gBZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789252514; x=1789857314;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XyqTSD7+XEJxR7K9Lr2Cp4DYcxTxFY5cqwi53+WEaFU=;
        b=HFr3unKioeilB6mfSuHrl2SUwRkI605zf+nBzJwPemkE7nEDWT6NRjAWY9sWCZHQeO
         Ekb/ylpB2MI+vtPa+MlA/QZHyVt6x5H493Z4ah1mqcRnBakJzvpwUm2h5gAkW4Pg++kg
         DG29g0Mbb5c7veli2xkH5d5HNGuF2IP6Rwts02jjdA3WcZD/4cGe0h1xGsmxX7pINFnX
         OzGroAqROIRdMoxHXqpkRoTXmU9LzrWTIPLntSVtRn6nKt3JMQGxWs+B9mk0JDot2Vmb
         bx3CTgb9oig/3waOBITrCqzWdTap2iS2b89ytrjBha3tVnzvYPoBI47QcN8wrN0q1eOP
         /zbQ==
X-Forwarded-Encrypted: i=1; AKwUvBwTCj5MD/Ufs3AAD/TpoS+UCX50AZJhb/cN+7Lz1WT96OnrK84ndNE3QLKHWLkIVKCPaH8Df9gA6w==@kvack.org
X-Gm-Message-State: AFuF++mRVEM2+Ddh3XsA+8qudvmysVcSHmhgTvkWA+hhSQYPzIvgGykb
	55NzIxpEd3n8C/qLWtkNXMll0YHTZJq0mS+23JC2VIqcX4EvEU2M4iSMRFRb9s0z1A==
X-Gm-Gg: AYBFou24cLjAwSgMnWlc3XUvnFbu6vRR/SnRmvmkICAacP9yKdSiYEE7X9QCWOyOAQK
	oXDPA7ugkE2aB+2UwMCRw7pESjgenePaDlXdtXwx28ZYO222B0hQbCVUUfS609U3CqhJOJax5wU
	7nOqD6jXFXbVxd0cCxwvEs1HvYxpFBJ3B4jpPeUaZJLSa/X0U3yxbN7MH8CzYoB0MOEKcyspyjS
	wOhONkC7gviRTP+NmO4z0YYJe2rkhbc2n3GOcLeE+u4JdZM+D1jm98X+a10oa7dfPttnvwqbAxb
	uicM7o07kZS+R/QYnb7pyP9gErKiDak9LQFqBqBrAzf18uZDdPglVyesY6gFQ8TahWbRdhrynr3
	hG7LRVverw8E/ak6pQ+EvIbMFO+GVniFa2treAMQK2LJFU0Vap42TjpYt0BYe+Fd8YteAqw0FIw
	uSBCvMimbPBVilzhOytuOOsOvjL462o+KpYTMLuHWOKp8mYQc9S3jzbPXn3rNuKgInib7esQuN7
	pT1n+sRjqIBBpcg+eZD
X-Received: by 2002:a05:600c:3513:b0:493:f140:c3fb with SMTP id 5b1f17b1804b1-49e619c0357mr193958835e9.7.1789252513196;
        Sat, 12 Sep 2026 15:35:13 -0700 (PDT)
Received: from darker.lan (104.157.125.91.dyn.plus.net. [91.125.157.104])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e60acff8bsm191751465e9.9.2026.09.12.15.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 15:35:11 -0700 (PDT)
Date: Sat, 12 Sep 2026 15:35:09 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 07/26] mm/fbatch: LRU_NEXT_ACTIVATE bit to optimize
 folio_activate()
In-Reply-To: <ddab52d0-48c7-4d2c-b403-45f11e041654@kernel.org>
Message-ID: <bbf33dc0-6812-f204-188f-f2176a4faf4c@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com> <c44a34f8-ea3c-48cd-27d5-02df129be685@google.com> <ddab52d0-48c7-4d2c-b403-45f11e041654@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: 153A61C0003
X-Stat-Signature: 6hufg7kn4srr1wnphg4pppnc41q7k8xo
X-Rspamd-Server: rspam01
X-HE-Tag: 1789252514-621490
X-HE-Meta: U2FsdGVkX19V6eBAg6z1CyFwHnj7gHp35R8esO2H4AjWzXM64gboPUMmHdlG/bIaGdihpn+RN05OvBTd6g9mokB7mv0ehiUW/oE85mauNF2wkWAG5cxLiUm6uC8jkKGv2edDg5qkOUimYUBY2xDuau2Is2d2fG+HJhgkwqxMACfFw/P+wt3BFEWaSY+DtkevKjtQaXBumTtnzL2PZaRmpKNUF45FI2IWk/EJA8o80QU1tFO6pzV6xulpS35nd1QEZxP608ASmpBByukmOzqJ9vBjj8Ao8h2u96XO6bAsVEpAaOXY1rfsxf6NHTRJEJTgODOD3Oz1rnoAM3eECqoB6fVkPtpzgo6ketw64MtJ2tehmLi8+p9fntYs92yw1ckfJJmlvXX1fyJVVDn8IhRc7VmcPmpGy5fGFCFSEGcAM5V6bYdQGjHhGytH80sPdTsp0Dhf4as9yrP8JZ0p8FE8CxcOsC0Ezo2cfV9Lp/TpSL2+UMjVZ7SvobRF2dx3bgk7PFHtvTxXjWO2oGLvGBFs+PeRxtqn6cLTxPnnhRgO8KWU08xMbkjA8RFY151fYr4HT91PE7Q5n9z5aNcAxu26AVK3NZGGcsib0T3dTVNdsiND0PV2cUVLSQLX2JgfkWY1CHS3b2RUNagGLh7+m9639bVJ77yrwLq4Qm76smVcxL4RXuqTaM5GZXGdJfzyOy7XlvWXeXR6WmveZIxan9kkYA/EKWY5BWy/vRO5HBaaakJjTLqZimv+s7IozrOEVImLm9fanzWYkwoe/XxsK4q5xez89gIl1kXiq5GQhiMISs0yO2dCmMhVj1m3VPd2Rn/wea49nMXMT/nOuOe6r6kvDQHOsSEy5NQTP50fE4Duia8bUnD2nkpkDIHgVNWkdyPMR9TmRymI1leAjegcHFcsX2ooBFkDGPr8xOVlmcHQsDPRtdqIfCX8REb2CUn7x+Qr5hno1KE3/o0FdVe6qHR
 vpeGXp/a
 55GVxYmXXcrVeXeoI5YS2IkW4WagPrekE3QbThz5ikOFAW9KcSFx9T++KfwJOmGOE/C85knVbyKrmv2JMYMxbthPICRgwQNcFF6bWrJb40Md026feOOmAH771n4GgFBqYfTpQ027jwzjNmed9rUoNED5R/SUG11ENkoz92mf29wwLfgTDJKVclIR8ZqclpIKWO0APCwuiWvUXXpoQj0UDqoqyMzB3u7t/aJL+QbB0qCu1n6aO/lkmfGey5wbEXky3wYSjHugvi2yjMsNecHP66i+nL5YtoIDz/sSj0wc0fnpOG/bGUOYlwJLky779LLMlVDV3aAx2i7s0OQPRkNX0oUYFHCZ01tirxgE/SDjCXwGfLXPxcuU5JRgyMX2Mblt5Jwoj4Mj33fe+MWZhEsEdZtYMxEamjvSq5yzvH0EKX/CDjbgo9uk0qWbuCwBLz4LNc5Obhzy6/M7f0d4IrX2Xiuy6hQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026, Vlastimil Babka (SUSE) wrote:
> On 9/9/26 11:55, Hugh Dickins wrote:
> > Implement an equivalent to the old __lru_cache_activate_folio()
> > optimization, to activate a folio recently put in the lru_add fbatch,
> > without having to put it through the lru_activate fbatch too. Neither
> > lruvec lock nor lru bit can guard this safely and efficiently, so resort
> > to try_cmpxchg() on a further, LRU_NEXT_ACTIVATE bit in folio->lru_next.
> > 
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > ---
> >  include/linux/mm_inline.h |  4 ++++
> >  mm/folio.c                | 23 ++++++++++++++++++++---
> >  2 files changed, 24 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 8420b1276535..8f5efadf9c7c 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -346,6 +346,7 @@ static inline void folio_migrate_refs(struct folio *new, const struct folio *old
> >  enum {
> >  	LRU_NEXT_NEVER_TAIL = 0,	/* Used by a tail's compound_head */
> >  	LRU_NEXT_BATCHED = 1,		/* Not used by any aligned pointer */
> > +	LRU_NEXT_ACTIVATE,
> >  	NR_LRU_NEXT_FLAGS
> >  };
> 
> This addition, and the comment "/* This mask will do nothing on 64-bit */"
> in folio_add_lru()... does it mean that now this is breaking 32-bit? Should
> we make this optimization, or perhaps all of the cpu fbatch, 64-bit only?

Answering second question first: those could have been options, to
disable the activation optimization or all per-cpu fbatching, on 32-bit;
but I much preferred them not to diverge, and tried hard to keep 32-bit.

First Q: This does not, in the end, break 32-bit at all. But while I
was developing, I thought it did, and reluctantly switched the encoding
away from holding lru_add entry pointer in lru_next, to holding
lru_add cpu and lru_add index in lru_next: from those the lru_add
entry pointer can easily be calculated, and there's lots of space
left over for more flag bits (which I thought might come to be needed).

But then I had that marvellous realization in folio_batch_move_lru(),
that it needed to service "wrong" entries in exactly the same way as
"right" entries, therefore didn't need to distinguish them, therefore
didn't need any address there at all.

I have kept the address for debugging, and do put it to some use in
the paranoid vmstats patch 27/26. On 32-bit, with 4-byte pointers,
this LRU_NEXT_ACTIVATE bit does then leave one pointer covering two
adjacent entries, when it's deciding whether the folio points back
to this lru_add entry. Is it possible for two adjacent entries to
hold the same folio (and so perhaps miscount the stat)? Yes, it is
possible (if that folio is freed and reused and readded immediately);
but so unlikely that it's of no importance when gathering stats.

Hugh

