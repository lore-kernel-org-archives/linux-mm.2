Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FBF9C88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 20:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A60F6B0088; Mon, 14 Sep 2026 16:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12FF36B008C; Mon, 14 Sep 2026 16:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00F376B0092; Mon, 14 Sep 2026 16:19:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C8A8C6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:19:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED336C021E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:19:43 +0000 (UTC)
X-FDA: 85213483446.12.E6D6810
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3A6E31A0009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:19:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="DLw73bm/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of hughd@google.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789417182;
	b=7JvIlV2B6HCx6IeScl95Xx7gCJINlsvqicrjZhStc3wZJWGjWldSbXCl0fUzQZOim/F7Gl
	BJWQkuyAO7ImpxJXqB/4lPWf/3+UiQAXwMqWDITRGnX0RckZzMgREK1PghrHk1JEqKbUO3
	lkxMdGO0+Ln/5+n3fu8zB1WJchAULls=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="DLw73bm/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of hughd@google.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789417182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+AktPzAMD7v7+puIIygBX5NaQs925spQsBYks3yq6yc=;
	b=bsC11ACW78+dCf8VUgYGxBSIpoE00qqInM3Y8XzS7sYXM/CCl7GCXWx7QP/+AtQRdBub2t
	FPraLe/Gr4wxgm/v95banRY4ODfl9c5lu8V5ULiJTTcY4tZddKWZRMnu6+bgElb4JGdCNo
	eGkYsCPHmJckMvC7JZ3ftsFXwKqA4gU=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f633cd78so1257029f8f.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789417181; x=1790021981; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+AktPzAMD7v7+puIIygBX5NaQs925spQsBYks3yq6yc=;
        b=DLw73bm/ekU2r4BeTvh/pwDY4uKFEKll4udkSOhJv9VEuj310baE5vHlr85RW/efQA
         5c2CYxRZaZLWgi8w6BtNe/34FqowTBrdSNtRaOWOZ1f1n1yI5pbqW+dWo793ubppns3M
         hx2Tf//sycJrVHRLgOXIm0Uuoh5V0z/nTdn4erydzOQO8DbMXmBt4UmcgJI0QnUXd0XR
         dSVsQiNsiG2ZEitzsCiXYb9+IwFDTUGJll7u6rdTzDB9ntFu5RYDklbR5OwLYViYTvOL
         lQpbqfP7aUu5oxZm4Jd959mM1BXSOocjDToggzVOTLylB5h3cbVXBX3W9978yKr1r2qK
         RTqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789417181; x=1790021981;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+AktPzAMD7v7+puIIygBX5NaQs925spQsBYks3yq6yc=;
        b=IwFDMmspUXKXnwYi6ylSLsprqjv9W9YNJsel6KsSfHesVHPcvww7U/od3rcmD6vuGA
         uMb1aDBZsKZh8hg211eGjXmo9BzO66p1zuQt8pjbWXC+4zvzxM6M04p2Ty6MetCLkK38
         7llvaNFOYV0Y0MTs780CjI/YOzISB4nbhPJbgMI2i1pVFE9kZPfDxuznPByFbb4v+Xpf
         9sI9SKNhjARbA/o3YBceB6t1MHivacBTzq57N0OSnWE/0Pba6zuhDs5TDGV+Wcg9bj7M
         n+CMIC+QqwDSdaqZQqPpDto7DEaEdX4hvATulu5Zn93Stx0HfrhBJbHNIv7z52q2DhdD
         4vxg==
X-Forwarded-Encrypted: i=1; AKwUvByyXFKVLlHZF+0kjzcmbUDvcVLpsZZdsF+0hdkIhnR2Wjz9Ger+LMRMcz9nQ4+pAAX87GQ8kTsklQ==@kvack.org
X-Gm-Message-State: AFuF++l4n3TR2+nYwYeUfgXSiKRhWM8pnGHDETOejpdrc1pEOQaw293Z
	21ax5121rIi0QwJCPhfHZ0yegf2IVFosj7eg7SU+vohWJSgGbuPLrl6a4KRoxwuWkQ==
X-Gm-Gg: AYBFou2bGvzOOw3cFK9SkYI5IxiUuY7/cRrIlxJvLVfe6QG7cX9DTqE4R/ulYg5Lvh+
	56iklkQsy84xiyXZh6wPdWpXysgMLGUS0b0+0HV6n1SO/SE6jbbRKB8a7FOqduw848EAn2lWV1v
	5YnkgVHur/r/GpHOpodmXhyl14VAajofFes4YGkNj06vzg7vWxtJzRE0fwlv7FIo7tWUTfUYXU6
	08XnnTDt8nekfkX/OJXrsVXmlH5tsizpqyPoFfDhVPu6rRB34+Os8oDteMXbaobjbMzNJKoqvNN
	J9EVANanjJLqHhqn3MQsJqUAXd9B3VgbGhWw16RtVWE669a64LngIyt7x464osVoUu7lDhb6xdE
	RsFF0EI2rkErfuo5KRY8HJ5GMtdBEbb2p8gEHv8SJdnCKLF9q23Pn402O41KPaUWEChoF8irKBg
	5rBc5Z4zH4MF/vbzze8Ws6dKvxnUISELq03hmDrxpWKD7Xw7dpPLv3H/KzMncgzT3yuNa01s0LO
	uSmIBhHgT0stK1khp5KDA==
X-Received: by 2002:a05:6000:4b13:b0:485:4277:fbab with SMTP id ffacd0b85a97d-48702b3df5cmr4952883f8f.27.1789417179939;
        Mon, 14 Sep 2026 13:19:39 -0700 (PDT)
Received: from darker.lan (104.157.125.91.dyn.plus.net. [91.125.157.104])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb32d3c7sm27112352f8f.10.2026.09.14.13.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:19:39 -0700 (PDT)
Date: Mon, 14 Sep 2026 13:19:37 -0700 (PDT)
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
In-Reply-To: <84fecd13-f1e4-7d40-94c9-963f5c2f7aee@google.com>
Message-ID: <5bd863e9-30a3-c01a-dc8c-c3802b864a6c@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com> <c44a34f8-ea3c-48cd-27d5-02df129be685@google.com> <aqLaa4QvXMbQaIWG@thinkstation> <84fecd13-f1e4-7d40-94c9-963f5c2f7aee@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3A6E31A0009
X-Stat-Signature: 94oj9ubsc8jza9bhfxq9y1goe4kktrsj
X-HE-Tag: 1789417182-663471
X-HE-Meta: U2FsdGVkX1/gQIqvFfmM3TKp2wFcgi6P508d2BcgIz87jo3tdoOnpi+NA/IOp+uHsSSvjIgYtjbRR47YJSx7O4W5L3gnTEC04OlKhCB9gNLDVeHHu3NOCHA70QWztjbkm7b2Rz7gCU2kQdjzNZVfNmXKdsoXViKigKGb3nyJ7/MY7FTEzpHln+PeP4H9c7hoAo/cFky5Thw+92z1ftc3+v3Kp2s1kqlS9HDetjT6Bx2aKLgSeJ4ojr53fdzxUZIHcfRktudv4URlbG4QO75iefKcUQN+uPuANZexNO47BDZJohIOWZtRbwEAp+ywJ1uhRs8/ymS0d2op6OQ+1B2HUohZzAoE+b4eW268RlZBe1yerQuuCxRG2olpzqO688MUaPO3tHMN9tr1ExuyY8QamzHOXQ1dkDeI4aeNlYAYoTPTgbiV/2ChiCvwe2k7N3VX5xD08aIuOiXy9m14L8dXecREFKTZY0pLfFlQLm8DXRkEfFqlre4gJX5guS4l4cnN8HJQ2XKt7dHABHYskHssY2VWWkvq7MuRUjKQfvkr5M5nnEbE94GPe0b8tI8xRjHhCEiCBcHwVvwfpaKWFiHn6dRoDJq6tR75iMC5ePdXn4zjVejI9Z/VQd4Ocl5OmlfsQHZUKdqUOTR2xbGW2l8wg8peLWajKjn1s6pj20shaapNNJ//n4NcE3jra62UE54mVGo1pF0M3uPO7EY2cSsg9wXcrBLCfsNtzunwMu6Slr96f3bW8fAeuMAo79gVez5fl1jS1WvZ8DhDGmBY0semBZcSGIBJpAXcn4DEQps/zT7PLv3UEZioKboXr+ErfP8T8+yhv3eV5m9RURjrOd/3iOt2nre+McjvrS3WuGx2Oh9nM4msjE3PjN9v4WZT3mqzV/Gz2UrhqkdFWDeIUo1VkJ0DbL0auZIaSMrE4mPodx+MkTm/KtmrscPV5hH/SIuLqZp3EBU96OCrpb5Ly0Y
 USnfgJ+B
 JIBxfRBUnRW/L0gjDjh3S/LK/emZoqVbwY7J0+74I41goYsZNvllzlhWy/fUNjm09Ty45EVQDHdhkaDh8h0o4HTNE0A5AwFa7xZa+riSvCKSaCrH867QsFi5Ss591QlCEzKlYIFDGO7luZEPCueBBLz2jfFe63FZlgvFenb7ME/rc8iiaqtKi5jBlrxV6bDFGtjyGSYVvjDPleKEIU0kX998CvPZgiHx7Tx/Nr4cQumbL8geF/AMdFaHBwOU7upaQ0aQE2IMvjlGUPW4oJeHUZizvHh3lL5TD96ChFFa6Z5QtSLYzyTiQjTIdo6CKJzd1lHWM95Vy/SkIvV7pqXn1v1Yh7kQP+/lzmXfuD5Ydt5wVY3LvPlKqnWW/Zu+DPeg2M6XDyKo0dbZgrAX2CyDFZND4cuyzZdTJqy2jhPe9Ubi4DNqXV0WiQkgTaXl0DpE/HgldxZleNxQRXUlEcx8sOqrAOfSUc3AI/lhLu6yYNLX4xlI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 12 Sep 2026, Hugh Dickins wrote:
> On Thu, 10 Sep 2026, Kiryl Shutsemau wrote:
> > On Wed, Sep 09, 2026 at 02:55:41AM -0700, Hugh Dickins wrote:
...
> > > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > > index 8420b1276535..8f5efadf9c7c 100644
> > > --- a/include/linux/mm_inline.h
> > > +++ b/include/linux/mm_inline.h
> > > @@ -346,6 +346,7 @@ static inline void folio_migrate_refs(struct folio *new, const struct folio *old
> > >  enum {
> > >  	LRU_NEXT_NEVER_TAIL = 0,	/* Used by a tail's compound_head */
> > >  	LRU_NEXT_BATCHED = 1,		/* Not used by any aligned pointer */
> > > +	LRU_NEXT_ACTIVATE,
> > >  	NR_LRU_NEXT_FLAGS
> > >  };
> > >  
> > > @@ -358,6 +359,9 @@ bool lru_add_del_folio(struct folio *folio)
> > >  	if (!(lru_next & BIT(LRU_NEXT_BATCHED)))
> > >  		return false;
> > >  
> > > +	if (lru_next & BIT(LRU_NEXT_ACTIVATE))
> > > +		folio_set_active(folio);
> > > +
> > >  	WRITE_ONCE(folio->lru.next, LIST_POISON1);
> > >  	/* BUG_ON(folio->lru_next & BIT(LRU_NEXT_BATCHED)); */
> > >  
> > > diff --git a/mm/folio.c b/mm/folio.c
> > > index a18d8ef6afd5..0b75c3b69d5a 100644
> > > --- a/mm/folio.c
> > > +++ b/mm/folio.c
> > > @@ -256,15 +256,32 @@ static void lru_activate(struct lruvec *lruvec, struct folio *folio)
> > >  
> > >  void folio_activate(struct folio *folio)
> > >  {
> > > +	unsigned long lru_next;
> > > +
> > >  	if (folio_test_active(folio) || folio_test_unevictable(folio) ||
> > >  	    !folio_test_lru(folio))
> > >  		return;
> > >  
> > >  	/*
> > > -	 * XXX: It is curiously difficult to recreate safely the old
> > > -	 * __lru_cache_activate_folio() optimization (folio_set_active()
> > > -	 * directly if it's on the local lru_add fbatch): revisit later.
> > > +	 * This optimization is intended for the common case of folio
> > > +	 * having been recently added to this CPU's lru_add fbatch.
> > > +	 * But since other CPUs can now take it at any instant (after
> > > +	 * a folio_test_clear_lru()), and we may be migrated to another
> > > +	 * CPU, it is simplest just to extend the optimization to all CPUs.
> > > +	 *
> > > +	 * folio_set_active() would be unsafe without the lruvec lock, and
> > > +	 * a folio_test_clear_lru() here might cause a racing drain of the
> > > +	 * lru_add fbatch to skip its lru_add(): so use try_cmpxchg().
> > >  	 */
> > > +	lru_next = READ_ONCE(folio->lru_next);
> > > +	while (lru_next & BIT(LRU_NEXT_BATCHED)) {
> > > +		if (lru_next & BIT(LRU_NEXT_ACTIVATE))
> > > +			return;
> > > +		if (try_cmpxchg(&folio->lru_next, &lru_next,
> > > +				lru_next | BIT(LRU_NEXT_ACTIVATE)))
> > > +			return;
> > 
> > Hm. What prevents the folio from becoming unevictable under us here?
> > I don't see anything.
> > 
> > __folio_add_lru() wouldn't like it:
> > 
> > 	VM_BUG_ON_FOLIO(folio_test_active(folio) &&
> > 			folio_test_unevictable(folio), folio);
> > 
> > folio_lru_list() has the VM_BUG() too.
> 
> You're right, thank you. I thought I had deleted all such VM_BUG_ONs:
> and indeed I had, but only in a patch I later decided was too much for
> this series (removing PG_unevictable, using !folio_evictable() in some
> places, or folio_test_unevictable() testing another POISON in lru_next).
> 
> That excuse is not enough for this series! Yes, I must send a fixup,
> but not today.
> 
> > 
> > I am not sure what the right fix is.
> > 
> > Maybe lru_add_del_folio() should only call folio_set_active() on
> > !folio_test_unevictable() folios?

I was writing the commit message to a 7.1/26 fixup patch,
when I found I just could not describe any possible race here.

(And I was using your first suggestion, above: in the longer term I
prefer what I chose below, but decided it was better not to get into
that now: deleting various VM_BUG_ON_FOLIOs is better argued elsewhere.
There's another of them in folio_migrate_flags().)

folio_activate() has just checked !folio_test_unevictable(), so
it would have to be a race with something which sets the unevictable
flag on this folio at the same time as we find it's LRU_NEXT_BATCHED.

!folio_evictable() might become true at any instant,
but folio_test_unevictable()?

I cannot see what the racer could be: can you? I can see lru_add()
making it unevictable afterwards; and I can see folio migration
(successful or not) carrying unevictable forwards (or setting it
on a freshly allocated folio). But I cannot see any risky race
for folio_activate() or folio_mark_accessed() here.

Hugh

> > 
> > Or should we allow occasional active+unevictable
> 
> Yes, that's what I did, just removed the VM_BUG_ONs: but I'll need
> to check again whether that other patch also had to fix any ordering
> of checks. Offhand, probably not: once the "Unevictable LRU" became
> an oopsing fiction, it was important to check unevictable first:
> unevictable must take precedence, and then it really doesn't matter
> whether active is set or not.
> 
> > so if they are
> > munlocked, they will go directly to active list?
> 
> I didn't think of that, but I don't think that "active", set racily
> back when the folio was assigned "unevictable", bears much relation
> to whether it ought to be put on active or inactive list when later
> made evictable again. We should probably be consistent, and
> consistent with existing behaviour, that they go to inactive when
> made evictable. (I'm not looking at that other patch at present,
> I don't recall where active got cleared in it.)
> 
> Hugh

