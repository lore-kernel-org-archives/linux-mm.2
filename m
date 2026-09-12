Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6084C88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 23:33:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64EDD6B00BE; Sat, 12 Sep 2026 19:33:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FFB06B00C2; Sat, 12 Sep 2026 19:33:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EDF46B00D7; Sat, 12 Sep 2026 19:33:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2502B6B00BE
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:33:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6994F1205CC
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 23:33:47 +0000 (UTC)
X-FDA: 85206714894.22.3352ABD
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id A01CF100007
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 23:33:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g6wRM0Ep;
	spf=pass (imf05.hostedemail.com: domain of hughd@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789256025;
	b=RMM7EkKdoWAin8Gw7FyG3oRRd15YMUwze9OlUF+TGeUYaH1+3LUY5bXA7MIXC9EMigF4aN
	mmAdV56eW9JFsDFABI9Ht19ycR04ioQUUfRzE0oVbLHRHSGfA7K7csgmnkkzHUvq1f6XjA
	vbTlycUQryvcBUuJ1tiN7jbmMnefA8s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g6wRM0Ep;
	spf=pass (imf05.hostedemail.com: domain of hughd@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789256025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GfWZA5VorxPvBHCBstYGbBsoifsqUoZdc3SoHINZf28=;
	b=gWeui5Z1p0E4B17FyjQ8rCcX6/BK38+V1DxlV55kR767RdeIzXh8xwTF4GUwQvmOeRnKa2
	OVUUVaEYMuzsIkcOkCdBH6rL+4OtAhwpqTGZlNWOulpqct2hhGMGsKqlyYO/DSvVCl3iVH
	3oN2VlVPU3Jo7b+yOo/lCnt5uIRBFog=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49e6e69d528so7308415e9.2
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 16:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789256024; x=1789860824; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GfWZA5VorxPvBHCBstYGbBsoifsqUoZdc3SoHINZf28=;
        b=g6wRM0Epv1pYrsarD3gGF2M3owDy5Y5deSAKj1feJNpvz3qIgRdqYNEDIo1hT7lFKr
         3682nYQKngLdzwTB9qZDWxdcO1dxjHkM0WtDzMq0p8Gw+vNtiTFsm7vBQY1FYyINt3Q2
         6pBah4Ub8Icoq4XqmIwXqfQI4MQCH73T6+0VmhgbfxtY0knOdtWEo1YaSKAHo7Anq8d+
         i1eebcQpd9mwls4pE+LW+ez744s0uDEpYKRmbX2nPwbBTDETE2ATullFG98wzLnuC4vx
         ykmyEH4qT1b3nmRyCrRdBAI6tJHG2Mx71nrQzo2R6seGM4mu5aTV2PkRJZmHZBq3elgY
         ybwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789256024; x=1789860824;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GfWZA5VorxPvBHCBstYGbBsoifsqUoZdc3SoHINZf28=;
        b=iLaHJZB5CAv9Ps929qUDoCArk91EbiCLkgaQa00lsG9Ip16Kq2xsOaYrMgEa3a3s9F
         eaGqSDHG+2FcbzuG+AHyKhZcuWWYEQiCaJDNR+ygU4Fhj7Fg0DKH38UcFVSljhxPl/wE
         qgNacW24dx4wOLiuXayWF/HvaM6JXxHRVfBjNZaRWD6DxSgkymdgtp30ha5qY3I7vDX6
         x2Sgyk/aadVfSHJxatvoATm+buxVM7Uk5pfKCfcHZ11NyprbcwxU9WUQ5chRzqt/hs/H
         sDS397ajhEsu/OngsBhF9eVTkdXEC96eVa4JIQJ7r/j5wkZu2cXJotQKptSQus5UKPik
         xaIg==
X-Forwarded-Encrypted: i=1; AKwUvBzhva631HGWyvWZS3j6+b/ul5eyX2r+/0wr6wTZFC2QRejADqVmtHnq/yk/i3OV6Tr7ini7BHNsEw==@kvack.org
X-Gm-Message-State: AFuF++l/z8AMg+zy8XxCXSPKaiIfHo4A786R6jcLa/SQtGssw0fhjLku
	BSdIEHMweZrsFAFBI5MKCpFlP1OfNe9xQ2yq2Ig9e2245sJeYqMM1nfdgMzzFGO86A==
X-Gm-Gg: AYBFou1dhnZRgbGVKAQFuw55IVWaXpXm8VLTiD4H7M8Z5f48037pvuaq4gD+gaDGquS
	WOfA8i53c+DMRsIVZJ+BrA7JLsBj6NcPGcUPKHFQa62IL8NL1/8YiuHj7UDo0vUChxVEMMZapI2
	S1uzqVzPcggIV8TjPafrE4EcytS71GC/wRq1MPJhtSHNER0723FYTi2WlTgFu+T47J6iARvuCZF
	HbNMZYEWvcXutN9w9jjrG4llgyGv8FJEykAjbDDMlABbEGQx7RUVB7+2dKoqDHWx9XrEQJjaXtM
	XCNhsxKWgJiReVxGkaAOQ+XdHdYotRrVg6FokXQgCmLNivf96TZIBKfBHCbagUO2W7FBz7GZAPi
	F5qbFV2he1q6TZ0Ylc0ACLEO0lSTqPKDxRyXqn+d7pKzkqRL0KaqLQBeNj9hgqNZtGirVkM+pN4
	i1Pu4yWOAsXxyx8q40w8Hum7NiODG3cs3+yPSc4yiCfXsmEdimEduT5xFDkr8/VG+KRJ2VIwrD9
	lG7LaH4eaCb6QXcYbES
X-Received: by 2002:a05:600c:8b41:b0:49b:d45:703e with SMTP id 5b1f17b1804b1-49e6198865dmr137086655e9.8.1789256023669;
        Sat, 12 Sep 2026 16:33:43 -0700 (PDT)
Received: from darker.lan (104.157.125.91.dyn.plus.net. [91.125.157.104])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26be3e35sm266378545e9.2.2026.09.12.16.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 16:33:41 -0700 (PDT)
Date: Sat, 12 Sep 2026 16:33:39 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Kiryl Shutsemau <kas@kernel.org>
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
    Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>, 
    Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
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
Subject: Re: [PATCH v2 07/26] mm/fbatch: LRU_NEXT_ACTIVATE bit to optimize
 folio_activate()
In-Reply-To: <aqLaa4QvXMbQaIWG@thinkstation>
Message-ID: <84fecd13-f1e4-7d40-94c9-963f5c2f7aee@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com> <c44a34f8-ea3c-48cd-27d5-02df129be685@google.com> <aqLaa4QvXMbQaIWG@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A01CF100007
X-Stat-Signature: sq5xmpibiwmydrgccpdy49h89ey6pn1y
X-Rspam-User: 
X-HE-Tag: 1789256025-763862
X-HE-Meta: U2FsdGVkX1+Y6bqwbl38INZmm7dquoRehwULkClMBcOfjKF6Em3a/VU3yKy0YtOsBrS42ZITVvExOPkETUrv1Z78Ug6m+/4eeHbHdRO3oeAgEdpJrqqod6g9VvsYt5AVoQ+EGHQ2jnsQ661yL3XT4jnWAGlYejlGd9mqGhrQwbeO9VevThZj2pm2U5S4cAaMuMCWR4tQFptMXX2P+YSlXM62wcH5IK8VjqYQ5ZqM3pf58Mf152eQL/BU2yn+48TugU8VoDyrtjBx+UxZkGjZ5NyNkX47g8kK8pW8Wm/G7zWuKB/4nbQwhge2YPyxWNuzBZgPWkFNXlWZ899kKZrcHGRsSMV6CkTa6xOroxvUVuCFyUahuQ4kG1Q6nuhZM0cYAPxaNuaOfeawSdv8+2h93/1X0TiOXNEzOz7V5ldAiawNsJ9BsE8qdvv0X3EyHx1WCCcCDn01zwko6JR+zkEqHyO3xtiWwXVJIo7b36UUEewDI1awz+LQ73V0u4ZGijgLfrSyICJ2k/B6bwk3WjZ36aC+UIKn1NKye5qdKWwjmsXZWWjhq1c9Zum+VOcoW3B5D9qvB6i6zsZ9EoxuKUyC6Weo3ZGDjsJrdT8uvWnt+j666NRNOYZlyveqKtmaQTDM/Q8On1Hx39nHU9nsHFvPf4UmAs/5dc86A21+/9KhK1FEp5mxMqa/kX/fMBgJysaQ6JBdiD1qWlghlcd1yxjwRN/f0gGG3je5LyT3xvERnthwC/3zCpj1r6l4Nv5ByVhvLNeQvuHe1uNM+VJsjAs+z+KwZ3+ggNISByci9kbQSmWN6QuVRX7c1D1fCzOwG6+62OMx4T1OiOz/vT+PgEmQO1N5VF9696XWkqq7Fenb0ySAOsfwL8lrMuSPRVSGOz9NY7eXJdU06VAbrIB8mYqGaZ4ihXGCD7Lb8bCMx3wczI8il3X22SvqyJAmlTheMLmsRGDVOVOLVyyL7ZsdDPA
 ysvliclG
 OFWB/1JsVjfMEZ/O7ple750DKFlvuDCiE3tuariY+6HlDgWq8bcIVa8nsqp0tCi5fll942UXMkwPOnGc2DSG4R6cO93Ro+P3zCSb2FfcrvekTdxZQsjpiYPlY7Ke9nTmgGbXBDPU+rVs+Vq+s6xM5SO/2a5kgBxcl3QbMIrydk9coi+1lvuScHokbTjbKLGHT6WIdxF+lNbLGONY9kP0dDXvB3j1zhQCoP4SXyeE51uOt+bivPqCwV2PMHEEg9Vu4xS7B7gJvmk2hzb4OEHt9f3Oo1eymNrdbopbCE0iaPPxumB7kALtOk2LgfiP3EQl+JrmvSI8kYwAJbpCT0aC9WkQL311NAtM9YNnbJ/+4Ex12ItZ3OiST3jUeqpl0Z+vf37XEM8CmbVAHKiHsavKxC4jC452PWYH0VIqPcvRl4VUc0EvZpJZja5fj0NRi9pY0v7u+ODxkNC9St04F7XNBvYWzE6+uW0q74hqm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026, Kiryl Shutsemau wrote:
> On Wed, Sep 09, 2026 at 02:55:41AM -0700, Hugh Dickins wrote:
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
> >  
> > @@ -358,6 +359,9 @@ bool lru_add_del_folio(struct folio *folio)
> >  	if (!(lru_next & BIT(LRU_NEXT_BATCHED)))
> >  		return false;
> >  
> > +	if (lru_next & BIT(LRU_NEXT_ACTIVATE))
> > +		folio_set_active(folio);
> > +
> >  	WRITE_ONCE(folio->lru.next, LIST_POISON1);
> >  	/* BUG_ON(folio->lru_next & BIT(LRU_NEXT_BATCHED)); */
> >  
> > diff --git a/mm/folio.c b/mm/folio.c
> > index a18d8ef6afd5..0b75c3b69d5a 100644
> > --- a/mm/folio.c
> > +++ b/mm/folio.c
> > @@ -256,15 +256,32 @@ static void lru_activate(struct lruvec *lruvec, struct folio *folio)
> >  
> >  void folio_activate(struct folio *folio)
> >  {
> > +	unsigned long lru_next;
> > +
> >  	if (folio_test_active(folio) || folio_test_unevictable(folio) ||
> >  	    !folio_test_lru(folio))
> >  		return;
> >  
> >  	/*
> > -	 * XXX: It is curiously difficult to recreate safely the old
> > -	 * __lru_cache_activate_folio() optimization (folio_set_active()
> > -	 * directly if it's on the local lru_add fbatch): revisit later.
> > +	 * This optimization is intended for the common case of folio
> > +	 * having been recently added to this CPU's lru_add fbatch.
> > +	 * But since other CPUs can now take it at any instant (after
> > +	 * a folio_test_clear_lru()), and we may be migrated to another
> > +	 * CPU, it is simplest just to extend the optimization to all CPUs.
> > +	 *
> > +	 * folio_set_active() would be unsafe without the lruvec lock, and
> > +	 * a folio_test_clear_lru() here might cause a racing drain of the
> > +	 * lru_add fbatch to skip its lru_add(): so use try_cmpxchg().
> >  	 */
> > +	lru_next = READ_ONCE(folio->lru_next);
> > +	while (lru_next & BIT(LRU_NEXT_BATCHED)) {
> > +		if (lru_next & BIT(LRU_NEXT_ACTIVATE))
> > +			return;
> > +		if (try_cmpxchg(&folio->lru_next, &lru_next,
> > +				lru_next | BIT(LRU_NEXT_ACTIVATE)))
> > +			return;
> 
> Hm. What prevents the folio from becoming unevictable under us here?
> I don't see anything.
> 
> __folio_add_lru() wouldn't like it:
> 
> 	VM_BUG_ON_FOLIO(folio_test_active(folio) &&
> 			folio_test_unevictable(folio), folio);
> 
> folio_lru_list() has the VM_BUG() too.

You're right, thank you. I thought I had deleted all such VM_BUG_ONs:
and indeed I had, but only in a patch I later decided was too much for
this series (removing PG_unevictable, using !folio_evictable() in some
places, or folio_test_unevictable() testing another POISON in lru_next).

That excuse is not enough for this series! Yes, I must send a fixup,
but not today.

> 
> I am not sure what the right fix is.
> 
> Maybe lru_add_del_folio() should only call folio_set_active() on
> !folio_test_unevictable() folios?
> 
> Or should we allow occasional active+unevictable

Yes, that's what I did, just removed the VM_BUG_ONs: but I'll need
to check again whether that other patch also had to fix any ordering
of checks. Offhand, probably not: once the "Unevictable LRU" became
an oopsing fiction, it was important to check unevictable first:
unevictable must take precedence, and then it really doesn't matter
whether active is set or not.

> so if they are
> munlocked, they will go directly to active list?

I didn't think of that, but I don't think that "active", set racily
back when the folio was assigned "unevictable", bears much relation
to whether it ought to be put on active or inactive list when later
made evictable again. We should probably be consistent, and
consistent with existing behaviour, that they go to inactive when
made evictable. (I'm not looking at that other patch at present,
I don't recall where active got cleared in it.)

Hugh

