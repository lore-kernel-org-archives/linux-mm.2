Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3880C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 08:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B56476B0005; Mon, 29 Jun 2026 04:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07A16B0088; Mon, 29 Jun 2026 04:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6966B008A; Mon, 29 Jun 2026 04:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6937C6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:40:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C10AF1C36B3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:40:24 +0000 (UTC)
X-FDA: 84932303568.03.B6246E8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 57CC516000A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:40:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="C8vj/Kvh";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782722422;
	b=p/Ucg0OfxNkwkIpNkQcaDRJfPmOmfGLjlw7JVr0pFWvoj/UOOGU9h6AXa5IRL7X7kJsMSD
	xYuIRQv7BP9P+OYPgJ7IW/GZ7jFwKkLXJDfxkQy4O8VAuACbERfAFQgYO/zYEITCqH2t/W
	WCuO2GdsLcuDw/RDqJtUj42vGuADyvw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782722422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=apbP0/mAALs29zIL1Jivy2IR2lGWYH+nRz/CLVDLR20=;
	b=WSIRLT2VEux3b2/vPvZjnt5SD+u3c1aVlAd5BWz5QlCI2uM58i5QrkzhbiFL1lj+eCSHPu
	z+K0T3hBOYCQOGIONf7BoJQ6u5rUlizlACbIkkxuL7WpfEGS9Ammt7ncwHItxN0TirFP3O
	ad532VYYCgQs5LyA/47pv7KFcmhgSjQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="C8vj/Kvh";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782722421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=apbP0/mAALs29zIL1Jivy2IR2lGWYH+nRz/CLVDLR20=;
	b=C8vj/Kvh0AQNuiLFrS6q44bfmoFUjBSOcF+r1teUS80WLuSd+f0DodAuXlGruK+q7b6k0U
	sxXnVVxd9D/04SgX7vTTkkwV/Cht+JbtvjvDwejcFuXG0Uezuj0xp8OAybyUcABgS4Vnri
	goucjaSKHtVFK9I1QjTsoGiy7ktewtk=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-Uh8osKEuNQSKEXJOafZE8Q-1; Mon, 29 Jun 2026 04:40:20 -0400
X-MC-Unique: Uh8osKEuNQSKEXJOafZE8Q-1
X-Mimecast-MFC-AGG-ID: Uh8osKEuNQSKEXJOafZE8Q_1782722419
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-37c9127e316so2052294a91.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 01:40:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782722419; x=1783327219;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=apbP0/mAALs29zIL1Jivy2IR2lGWYH+nRz/CLVDLR20=;
        b=JymuLYhg9iW1yeU1M5oxilEJUUNImtMOhkXb1/gONVb9tdhYUFOmVzrgaeDn83ak02
         IwXlYZmSYO9iZACM+JsCDKM4YZlsVhZB3c1hygg0Sg3W9Q4YpL97wtLHhTq4PMIKaOF8
         ZZ0zRb1lfBRMlOs4is/Pu/5V6f2GzUqgMCR5NBEaZ3v6ff/0u25t0qdQPNeeAX4WrWvq
         GB3bqOi4LWomfOql5Z2J9Rk9LDs2kubT+cJ0a/3JA3FEv0UmZqh1systJiz+rX3RaifT
         oXeM4Z/FYxQbA+aPts7w+WXAaKbv3Lw4a8EGg8XZC02bzr37TRfAvjgiJKutCW+8ppWH
         QRdA==
X-Forwarded-Encrypted: i=1; AHgh+Ron96VBqpC+4yBM4L/NhGIAomn56yF5JdjYJSk9sZdAiX66oqTpPKgT0LUQREkAs+BvbTStixL2DQ==@kvack.org
X-Gm-Message-State: AOJu0YybeRfRimqn64Rm4ZwxXXFkx9TZkRv3Tuf/j1O9RhBM/8Y0TXXW
	vgVpXTAJS9zI53MHwZ1LXDjOSny6mfYDjQm22drSwfI720lH2Hmg+74MxR7MCqu3OXahriIdnX6
	qqjIE2nNuElNFcOLYNB+ZNmMxjWWua0tOFhyFO7X3vTgPxDAS3UMC
X-Gm-Gg: AfdE7cmB6qLYVkTJmtud2sxmo1KXIZmOI+yMjJmBulucxgvfRMTpiYrk/HnmnJ2lU66
	l8cSzc703wihyK6ABkQbaBRgTHNXMesLInyCk1z5COrYRflqBjReK1zzpDIGRDN4gI51gf/ONkn
	Pv+t9Mb+VcwJW8CKAV5jiRHWffEDBhGiJ8+6HThnlrI2h3tly/GUkKyrWzLRgSw0iIXQmC/9oRb
	cwWQxrmXcPEVWo6BziinbV6RRV0Jvvt3rTidL2qc0+ublvFXFRSF7Wsl6taXeg4rnVcHu2+kYuf
	ZnXOAQoym5F169pVdOMJCwihBXSB4Spm6KciVVUR/KrIK3bUILHK/7zUXvUk5ic6qmgWTs3D/yH
	pqiBRKWanBk9S56bUwQ+nSsTPgKkwHSA1
X-Received: by 2002:a17:90b:1c10:b0:37f:c69d:ce69 with SMTP id 98e67ed59e1d1-37fc69dd07fmr6710631a91.10.1782722419079;
        Mon, 29 Jun 2026 01:40:19 -0700 (PDT)
X-Received: by 2002:a17:90b:1c10:b0:37f:c69d:ce69 with SMTP id 98e67ed59e1d1-37fc69dd07fmr6710589a91.10.1782722418371;
        Mon, 29 Jun 2026 01:40:18 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37fa9629f8fsm4643541a91.8.2026.06.29.01.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 01:40:17 -0700 (PDT)
Date: Mon, 29 Jun 2026 04:39:53 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Byungchul Park <byungchul@sk.com>,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
Message-ID: <20260629043417-mutt-send-email-mst@kernel.org>
References: <cover.1782676497.git.mst@redhat.com>
 <akHUboUaYi-OJHFu@firstfloor.org>
 <20260629033608-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260629033608-mutt-send-email-mst@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2Hd8FMxxLjmmo11JiZaUFZ4PS8ckBjgl67bPhB762b0_1782722419
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 57CC516000A
X-Rspam-User: 
X-Stat-Signature: b1ajppjhx87krhs59qww5o61gt3ggjx3
X-HE-Tag: 1782722422-353961
X-HE-Meta: U2FsdGVkX1/9+A/l2JPUSvsBSplU7jyVF8c+4QLUfHbsdmrtppht4NWMBHF5ENHbYLF3ZJGGbtFfP2GIWf471UgAq9YKjCkUyku0oSNdBRy/AENy/Ko3MxB1iJm5+i9I7MQW+kT/V45nq5nNiSrg+p1yWQW0z7MQ8kn8PrcwUn60t7wiJPm0xw4/5dWLG/T8w1isBeq6AhUx0lFY4HcBtPEHmeG8QErbpnSBQ8vJU6W6h/2cCad+SghbZ2aKcg/AvxQbc+Mx7e75s1tiwukzsG2gDNFykoaAAZ6UEVJz3RepTO3IY3mO4/L+GzVdLr8Im8kYES2LV3jKU9YeuVeP7rzqW2mN5jCAVsbNhQwYHghybLEKBg5YMG7LcfJMs2d5fQDOkmI8Yyt/z3CSAVDMmae3dVU0CRMeG/Za/CWUDg/PG4WHisCq9IBzcoosWznbA7QFRJh0oKBuTS+7zLRBWOLdIj8GiJ3eY3HP67N8tDW9GtauwWgpz71PGu0dmIj9q9nU85L4wNi7/ihx0hhjoTyVi53XtJ72ZjxMRvYRVzvuxLrA42o4Bd9q9qt555vkuXe/dhTKZ6Nhe9ot1z38lSV9MjXh/90sT1dWp3aCwB4cKd8gqbJx3AT3YmV2R4ZpTd30JCBBhHu69yvZJ9wEpyBhgUWjNG4yvlm7T4uyqkUNeEvR6nBsfzzdNw1/ejOMjRcT3AqNT1C+VTv3y29UbGTnVT8f7CZ9dKUZJK9rEZ2Z9D6Fwy/sNX9TbGAIiC3lezojorpBfaKLYsEhHqIJITixK6GMAbwvRGzDd9P0RqrtSiGcpUtx4lOSBPl4v28Lt5B+BQPEcAwA7BO+OyOcYFPXgau73ST56wamSPwbB2ZhGpilSZmp3qPdQKyhJpx6ZuXgi/mOmh57BotkEu7vwlqRpTrB04gLrLIdDzyZBSjbo+GsyBnkzAKl+HGOgdHgfaeCBqv17Em4ScmbVP8
 YgVC15iY
 o5qdJiC3pkuhAjBlEyQTgfVmCQTmcB0pp/caVC9KSgLenkCEpfCqavt9SYO80qmZQMgz0/+SWiaQ2mIcp5XDXSvQEZ94SbpF/8jvPh62FbBdJqOIptBfCp5w8ZqDJtTK3Yj7rbFqomSi7Sll/B35AjGzHn97h7JocI0SKqiX8c+bajthnQBuyeIhP9fidqW2jR9fRLZVyyzy0z19jaUDs8sngmSERJc5b98peeQgbUP+P2MfGH/NHC84I/6nXknV4Gc1DSZjqj1CTgbbttIw4BS7BCL7oXS+gXpMahq32EJ3PzRKwDRYfsxN0FMCXdKJjjZIg1NFS4uSpSrGDlDjCsAewlEVDhujnvnRhRLTJ09NnEle0b6wrWOCYPi/y+GW+Sy0Kg4TNDqqIe4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 04:10:33AM -0400, Michael S. Tsirkin wrote:
> On Sun, Jun 28, 2026 at 07:11:58PM -0700, Andi Kleen wrote:
> > On Sun, Jun 28, 2026 at 05:45:22PM -0400, Michael S. Tsirkin wrote:
> > > This series fixes the race by:
> > > 
> > > 1. Having memory_failure() call synchronize_rcu() + retry after
> > >    setting HWPoison, so that any in-flight non-atomic RMW that
> > >    read the old flags value completes before we proceed.
> > >
> > > 2. Wrapping all non-atomic page flag operations in
> > >    rcu_read_lock/rcu_read_unlock (CONFIG_MEMORY_FAILURE only),
> > >    so that synchronize_rcu() actually drains them.
> > 
> > It wouldn't surprise me if your underlying performance assumptions 
> > -- an non contended atomic is cheaper than a rcu_read_lock/unlock --
> > are not true in various CPU/kernel configuration combinations.
> > 
> > Modern CPUs have fast atomics when uncontended in normal circumstances.
> > But it probably doesn't matter much either way because the difference
> > shouldn't be very much.
> 
> 
> Hmm. It's a bit silly that I didn't try. Seemed clear to me, but,
> on this old xeon...
> 
>                                    insns/iter    cycles/iter
>      -------------------------------------------------------
>        base                       12238 +/- 1.0    17889 +/- 97.9
>        rcu_read_lock              12251 +/- 7.3    17991 +/-191.6
>        atomic ops                 12233 +/- 1.9    17733 +/-136.5
> 
> 
> The diff in the noise.
> 
> And old, slow CPUs maybe don't have MF at all.
> 
> So maybe just atomics instead of all this mess.


However, this was a basic test, when allocating 4k pages. With 2M hugepages:

                                   insns/iter    cycles/iter
     -------------------------------------------------------
       base                       20758 +/- 12.5   191208 +/-1946.6
       rcu                        20785 +/-  3.7   197108 +/- 132.1
       atomic                     20727 +/-  6.4   204591 +/- 160.2

       rcu vs base                  +27 (+0.13%)     +5900 (+3.09%)
       atomic vs base               -31 (-0.15%)    +13383 (+7.00%)

and even with THP:

                                   insns/iter    cycles/iter
     -------------------------------------------------------
       base                       27220 +/-  2.8   192151 +/- 483.3
       rcu                        27248 +/- 30.1   194159 +/-2746.6
       atomic                     27186 +/-  3.2   200526 +/- 746.2

       rcu vs base                  +28 (+0.10%)     +2008 (+1.04%)
       atomic vs base               -34 (-0.12%)     +8374 (+4.36%)


needs more thought.



> 
> 
> 
> >  It seems very complicated for something that
> > could be much simpler.
> > 
> > But I guess it's fine.
> > 
> > -Andi
> 
> Indeed. David already said he's gonnu look at this himself, but here's what I
> tested, maybe helpful for whoever wants to try this approach:
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 7223f6f4e2b4..8f0940cf2f29 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -404,6 +404,44 @@ static unsigned long *folio_flags(struct folio *folio, unsigned n)
>  #define FOLIO_HEAD_PAGE		0
>  #define FOLIO_SECOND_PAGE	1
>  
> +/*
> + * When CONFIG_MEMORY_FAILURE is enabled, non-atomic page flag operations
> + * must be atomic to prevent clobbering concurrent TestSetPageHWPoison()
> + * in memory_failure().  Otherwise, use the cheaper non-atomic versions.
> + */
> +#ifdef CONFIG_MEMORY_FAILURE
> +#define __pf_set_bit		set_bit
> +#define __pf_clear_bit		clear_bit
> +
> +static __always_inline void page_flags_clear(unsigned long *flags,
> +					     unsigned long mask)
> +{
> +	atomic_long_andnot(mask, (atomic_long_t *)flags);
> +}
> +
> +static __always_inline void page_flags_set(unsigned long *flags,
> +					   unsigned long mask)
> +{
> +	atomic_long_or(mask, (atomic_long_t *)flags);
> +}
> +
> +#else /* !CONFIG_MEMORY_FAILURE */
> +#define __pf_set_bit		__set_bit
> +#define __pf_clear_bit		__clear_bit
> +
> +static __always_inline void page_flags_clear(unsigned long *flags,
> +					     unsigned long mask)
> +{
> +	*flags &= ~mask;
> +}
> +
> +static __always_inline void page_flags_set(unsigned long *flags,
> +					   unsigned long mask)
> +{
> +	*flags |= mask;
> +}
> +#endif /* CONFIG_MEMORY_FAILURE */
> +
>  /*
>   * Macros to create function definitions for page flags
>   */
> @@ -421,11 +459,11 @@ static __always_inline void folio_clear_##name(struct folio *folio)	\
>  
>  #define __FOLIO_SET_FLAG(name, page)					\
>  static __always_inline void __folio_set_##name(struct folio *folio)	\
> -{ __set_bit(PG_##name, folio_flags(folio, page)); }
> +{ __pf_set_bit(PG_##name, folio_flags(folio, page)); }
>  
>  #define __FOLIO_CLEAR_FLAG(name, page)					\
>  static __always_inline void __folio_clear_##name(struct folio *folio)	\
> -{ __clear_bit(PG_##name, folio_flags(folio, page)); }
> +{ __pf_clear_bit(PG_##name, folio_flags(folio, page)); }
>  
>  #define FOLIO_TEST_SET_FLAG(name, page)					\
>  static __always_inline bool folio_test_set_##name(struct folio *folio)	\
> @@ -458,12 +496,12 @@ static __always_inline void ClearPage##uname(struct page *page)		\
>  #define __SETPAGEFLAG(uname, lname, policy)				\
>  __FOLIO_SET_FLAG(lname, FOLIO_##policy)					\
>  static __always_inline void __SetPage##uname(struct page *page)		\
> -{ __set_bit(PG_##lname, &policy(page, 1)->flags.f); }
> +{ __pf_set_bit(PG_##lname, &policy(page, 1)->flags.f); }
>  
>  #define __CLEARPAGEFLAG(uname, lname, policy)				\
>  __FOLIO_CLEAR_FLAG(lname, FOLIO_##policy)				\
>  static __always_inline void __ClearPage##uname(struct page *page)	\
> -{ __clear_bit(PG_##lname, &policy(page, 1)->flags.f); }
> +{ __pf_clear_bit(PG_##lname, &policy(page, 1)->flags.f); }
>  
>  #define TESTSETFLAG(uname, lname, policy)				\
>  FOLIO_TEST_SET_FLAG(lname, FOLIO_##policy)				\
> @@ -806,7 +844,7 @@ static inline bool PageUptodate(const struct page *page)
>  static __always_inline void __folio_mark_uptodate(struct folio *folio)
>  {
>  	smp_wmb();
> -	__set_bit(PG_uptodate, folio_flags(folio, 0));
> +	__pf_set_bit(PG_uptodate, folio_flags(folio, 0));
>  }
>  
>  static __always_inline void folio_mark_uptodate(struct folio *folio)
> @@ -1162,14 +1200,14 @@ static __always_inline void ClearPageAnonExclusive(struct page *page)
>  {
>  	VM_BUG_ON_PGFLAGS(!PageAnonNotKsm(page), page);
>  	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
> -	clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
> +	__pf_clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
>  }
>  
>  static __always_inline void __ClearPageAnonExclusive(struct page *page)
>  {
>  	VM_BUG_ON_PGFLAGS(!PageAnon(page), page);
>  	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
> -	__clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
> +	__pf_clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
>  }
>  
>  #ifdef CONFIG_MMU
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 06bbe9eba636..931dfc84319f 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2343,7 +2343,7 @@ int folio_xchg_last_cpupid(struct folio *folio, int cpupid);
>  
>  static inline void page_cpupid_reset_last(struct page *page)
>  {
> -	page->flags.f |= LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT;
> +	page_flags_set(&page->flags.f, LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT);
>  }
>  #endif /* LAST_CPUPID_NOT_IN_PAGE_FLAGS */
>  
> @@ -2503,8 +2503,8 @@ static inline struct zone *folio_zone(const struct folio *folio)
>  #ifdef SECTION_IN_PAGE_FLAGS
>  static inline void set_page_section(struct page *page, unsigned long section)
>  {
> -	page->flags.f &= ~(SECTIONS_MASK << SECTIONS_PGSHIFT);
> -	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
> +	page_flags_clear(&page->flags.f, SECTIONS_MASK << SECTIONS_PGSHIFT);
> +	page_flags_set(&page->flags.f, (section & SECTIONS_MASK) << SECTIONS_PGSHIFT);
>  }
>  
>  static inline unsigned long memdesc_section(memdesc_flags_t mdf)
> @@ -2719,14 +2719,14 @@ static inline bool folio_is_longterm_pinnable(struct folio *folio)
>  
>  static inline void set_page_zone(struct page *page, enum zone_type zone)
>  {
> -	page->flags.f &= ~(ZONES_MASK << ZONES_PGSHIFT);
> -	page->flags.f |= (zone & ZONES_MASK) << ZONES_PGSHIFT;
> +	page_flags_clear(&page->flags.f, ZONES_MASK << ZONES_PGSHIFT);
> +	page_flags_set(&page->flags.f, (zone & ZONES_MASK) << ZONES_PGSHIFT);
>  }
>  
>  static inline void set_page_node(struct page *page, unsigned long node)
>  {
> -	page->flags.f &= ~(NODES_MASK << NODES_PGSHIFT);
> -	page->flags.f |= (node & NODES_MASK) << NODES_PGSHIFT;
> +	page_flags_clear(&page->flags.f, NODES_MASK << NODES_PGSHIFT);
> +	page_flags_set(&page->flags.f, (node & NODES_MASK) << NODES_PGSHIFT);
>  }
>  
>  static inline void set_page_links(struct page *page, enum zone_type zone,
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 970e077019b7..100226f59490 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3624,8 +3624,8 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>  		 * unreferenced sub-pages of an anonymous THP: we can simply drop
>  		 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
>  		 */
> -		new_folio->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> -		new_folio->flags.f |= (folio->flags.f &
> +		page_flags_clear(&new_folio->flags.f, PAGE_FLAGS_CHECK_AT_PREP);
> +		page_flags_set(&new_folio->flags.f, folio->flags.f &
>  				((1L << PG_referenced) |
>  				 (1L << PG_swapbacked) |
>  				 (1L << PG_swapcache) |
> diff --git a/mm/memremap.c b/mm/memremap.c
> index 053842d45cb1..194ca2f04a87 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -494,7 +494,7 @@ void zone_device_page_init(struct page *page, struct dev_pagemap *pgmap,
>  		 * blindly clear bits which could have set my order field here,
>  		 * including page head.
>  		 */
> -		new_page->flags.f &= ~0xffUL;	/* Clear possible order, page head */
> +		page_flags_clear(&new_page->flags.f, 0xffUL);	/* Clear possible order, page head */
>  
>  #ifdef NR_PAGES_IN_LARGE_FOLIO
>  		/*
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d49c254174da..a3447124a725 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1359,7 +1359,7 @@ __always_inline bool __free_pages_prepare(struct page *page,
>  		int i;
>  
>  		if (compound) {
> -			page[1].flags.f &= ~PAGE_FLAGS_SECOND;
> +			page_flags_clear(&page[1].flags.f, PAGE_FLAGS_SECOND);
>  #ifdef NR_PAGES_IN_LARGE_FOLIO
>  			folio->_nr_pages = 0;
>  #endif
> @@ -1373,7 +1373,7 @@ __always_inline bool __free_pages_prepare(struct page *page,
>  					continue;
>  				}
>  			}
> -			(page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> +			page_flags_clear(&(page + i)->flags.f, PAGE_FLAGS_CHECK_AT_PREP);
>  		}
>  	}
>  	if (folio_test_anon(folio)) {
> @@ -1392,7 +1392,7 @@ __always_inline bool __free_pages_prepare(struct page *page,
>  	}
>  
>  	page_cpupid_reset_last(page);
> -	page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> +	page_flags_clear(&page->flags.f, PAGE_FLAGS_CHECK_AT_PREP);
>  	page->private = 0;
>  	reset_page_owner(page, order);
>  	page_table_check_free(page, order);
> diff --git a/mm/slub.c b/mm/slub.c
> index a2bf3756ca7d..a55199f642d3 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -617,7 +617,7 @@ static inline void slab_set_pfmemalloc(struct slab *slab)
>  
>  static inline void __slab_clear_pfmemalloc(struct slab *slab)
>  {
> -	__clear_bit(SL_pfmemalloc, &slab->flags.f);
> +	__pf_clear_bit(SL_pfmemalloc, &slab->flags.f);
>  }
>  
>  /*


