Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 382BFCAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 13:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9409E8E0006; Mon,  6 Oct 2025 09:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918218E0002; Mon,  6 Oct 2025 09:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854BD8E0006; Mon,  6 Oct 2025 09:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 752548E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 09:05:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 21C411A059F
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:05:10 +0000 (UTC)
X-FDA: 83967709980.12.7595996
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4118C40011
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:05:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=0HtQHuSZ;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759755908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=afYS5PVhnvRrPOZj/B9ZhYZyPYcWHB/01N4lbx0g2tI=;
	b=oMqYWrAU/Sms0t4ZfaOUk6P6GtECEfh6jbm2x9KNkRMEkuwQ6Tg+cG4S0TiWheIf6nkS+b
	9wlu7XrLTT5cXF0BSDgv1UM5JNaTXVjOxNVvsyex1ANAblbF7LV0/m+ERdJb6TiUW0Ir39
	pM4f9QhR34+trBDNMHpxbLkEATXMAVg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=0HtQHuSZ;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759755908; a=rsa-sha256;
	cv=none;
	b=bT2ADYyDtgjTf0as6jyy/63EVkoHgXs+QGCcw7+q3MbEiVE0dTNWE3DYvSgn9+C2FJCxlp
	zO+EqnQOIV3aOuczPXj/QaIdoKh3aEPCBzeq3elBlkwwgOAjq/eRdQAORfP2UnF4nJ+XGS
	NqQo7OFuxkhZY9pXsVXwY8sp4B9UomU=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id B73FE92EF7;
	Mon, 06 Oct 2025 13:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1759755906;
	bh=afYS5PVhnvRrPOZj/B9ZhYZyPYcWHB/01N4lbx0g2tI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=0HtQHuSZBnFpUkGKMfHfoapqemFnAl/1IcRfsDbXw3mDcs2EdZ43Nt/zc8t3t0W5O
	 lB+aP+Vha7opGAjDUK3kU8wcBAiagcFunY2MAd7I/UwPgvGtiBmysvSNH83WzZde3A
	 UwNc6U/UyJw37ZLfU0xsEFGZNPv/CSgIsVw2PFR8=
Date: Mon, 6 Oct 2025 13:05:05 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: skip folio_activate() for mlocked folios
Message-ID: <aOO-gUHQmF6zyLwM@shell.ilvokhin.com>
References: <aN_bix3wDpwYPoVp@shell.ilvokhin.com>
 <550dd78f-bf85-41d6-9c3b-472784b2d94e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <550dd78f-bf85-41d6-9c3b-472784b2d94e@gmail.com>
X-Rspamd-Queue-Id: 4118C40011
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: namadjdubrrd5mf1wfoh1b16qfxircpx
X-HE-Tag: 1759755908-873033
X-HE-Meta: U2FsdGVkX19yWOOxAjAfOeotcEsk8ZbBt2CCEGRiaj+32oUPNwP+JazUuAiWYjCLwA44NAgJ+SIRmWzL0kLizoI8LPE0ItYEsQKFGvO4TSVem0lnAszMA5y2HtXKUzy0lZpQGPWCFSsc/NxwIobTQulKbfcPHIqDsSjRvOoPqIrBgg2nctMPJLSI29ERXIKYg0BcmLRv52N6JESHMWvAEqgv/yWg4axALMpIiArTyNXsqgekN/5yrvFenj+zMi3Q0bhiq4QL+5IgWlzMsvx2uYCuwdUBx1won+0vMsJYBeYc3rZhVQ3k6U4Pbu37Pm/0VbnyahbZXn9xNh8IE/lxYBfm6wkLjanFJZcJIN5auYk+dUXfKNTG/2P756EwLLnwu7xZ4cQPeGT8xsEVTPBodC8ohOEa1jWjqG/m4nn+nFgUeWh+gcU58JOhQsjQc5c+dB9M2kfRKmMiCF0RIG98FcTT29KDDyOGZN0PkkSzqb+b3GBqfZOV8qjnOwPt/j3gIFk239VH100DBn0RMWDVOWtIkNlPrD1BNNjbBuGOvzwK/wUyCFhBnMZbxJc9BEcW2bILHg5AaoOl6mpWMCcibDfwUMu2CKsdTI2+mLGFG0FQJLFgrOja79ZuOcoFYrm5TExrfWwijK10xUUMzpa4TvDqxnbv2/w8aTXtPrJFfw844RFgjXvyccZ5IBZgoSmxJIoRqFJ0QqndAKsE0l2LKgQHcyaY1u3wr13d+GakR6m/N8TuBdmmrmxDp1wBK5lE+MWAb+yZxAoRH5DGUjesiC10whbU72F7TTKADTnsukc1afCfNlGMNgWsjjOOBR16uBPlskOIeSd61YyYduhJUy/PdyBeSLkNSGmDCjA6H2sUX6OUxiI7GscCS50kfs8EAqqteQnLJqJOeBLxoSuiRVtYu639QiTI0xi47GlyBZkk92foENq9HeLctcYP+PQXVHCiMvGKfhsQz3l7pnl
 mo/pR6+O
 i/KdwZJyj7la3pV8+7Mad2oI4PxOyfnlW8NAtd0dOpIxHqJj0W48AW1ApY02n54JjFCZZ90oT1+fKn6AaKibxgaq2YVM83B1pvRkp/ildGDCLlt2/3wTP/dl+7K3Z69WiFgRMIJgCdNbqSjCgAPnp3h2Hknlf9vW+Em+MsqTpE4GsUQIgCz7+Qwp+7cT4QhjOw6I6sN2YgZKB/YqojNL/l+5nW3SFncTc6dorC4kzs8o//WzWx1cUXFSJbkC+xAm+oZwBbgXQwJJ4zXI5NSxzgXXfAjq2f4f0KfCrXAUW+KHggBmrM4AqxcPdKtSFooULTlbI4y36BwzmqlyejoeRe2MmffNoSFgZhm1CYuUiu9GMm7rb7WEfLOJucha5VOCoo/pEp0dBABdeHi7IXENaxLJftWGKokngU2NN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 03:36:08PM +0100, Usama Arif wrote:
> 
> 
> On 03/10/2025 15:19, Dmitry Ilvokhin wrote:
> > __mlock_folio() should update stats, when lruvec_add_folio() is called,
> > but if folio_test_clear_lru() check failed, then __mlock_folio() gives
> 
> nit: s/failed/fails/

I'll cut commit message in v2, so phrase will not be there anymore.

> > up early. From the other hand, folio_mark_accessed() calls
> 
> nit: s/From/On/

This one as well.

> > folio_activate() which also calls folio_test_clear_lru() down the line.
> > When folio_activate() successfully removed folio from LRU,
> > __mlock_folio() will not update any stats, which will lead to inaccurate
> > values in /proc/meminfo as well as cgroup memory.stat.
> > 
> > To prevent this case from happening also check for folio_test_mlocked()
> > in folio_mark_accessed(). If folio is not yet marked as unevictable, but
> > already marked as mlocked, then skip folio_activate() call to allow
> > __mlock_folio() to make all necessary updates.
> 
> Would it make sense to write over here that its safe to skip activating
> an mlocked folio?

Good point, will mention that, because that's my understanding as well.
I think mlocked folio should end up in the unevictable LRU eventually
and if so, mlocked folio being in active LRU is temporary anyway, so it
is should be safe to skip folio_activate() for mlocked folios.

> > 
> > To observe the problem mmap() and mlock() big file and check Unevictable
> > and Mlocked values from /proc/meminfo. On freshly booted system without
> > any other mlocked memory we expect them to match or be quite close.
> > 
> > See below for more detailed reproduction steps. Source code of stat.c
> > is available at [1].
> > 
> >   $ head -c 8G < /dev/urandom > /tmp/random.bin
> > 
> >   $ cc -pedantic -Wall -std=c99 stat.c -O3 -o /tmp/stat
> >   $ /tmp/stat
> >   Unevictable:     8389668 kB
> >   Mlocked:         8389700 kB
> > 
> >   Need to run binary twice. Problem does not reproduce on the first run,
> >   but always reproduces on the second run.
> > 
> >   $ /tmp/stat
> >   Unevictable:     5374676 kB
> >   Mlocked:         8389332 kB
> > 
> > [1]: https://gist.github.com/ilvokhin/e50c3d2ff5d9f70dcbb378c6695386dd
> > 
> > Co-developed-by: Kiryl Shutsemau <kas@kernel.org>
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > ---
> 
> 
> Thanks for the patch!
> 
> Personally I would just use the comment you have written below to create the commit message.
> You probably dont really need to write all the function calls paths?
> 

I'll cut commit message a bit in v2 and make it more succinct, thanks
for the feedback.

> Also, I don't think you need () for all the functions in the commit message, although
> thats my personal preference.
> 
> Apart from changes in the commit message, lgtm.
> 
> Feel free to add after commit message fixups.
> 
> Acked-by: Usama Arif <usamaarif642@gmail.com>
> 

Thanks for the review.

> 
> >  mm/swap.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/mm/swap.c b/mm/swap.c
> > index 2260dcd2775e..f682f070160b 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -469,6 +469,16 @@ void folio_mark_accessed(struct folio *folio)
> >  		 * this list is never rotated or maintained, so marking an
> >  		 * unevictable page accessed has no effect.
> >  		 */
> > +	} else if (folio_test_mlocked(folio)) {
> > +		/*
> > +		 * Pages that are mlocked, but not yet on unevictable LRU.
> > +		 * They might be still in mlock_fbatch waiting to be processed
> > +		 * and activating it here might interfere with
> > +		 * mlock_folio_batch(). __mlock_folio() will fail
> > +		 * folio_test_clear_lru() check and give up. It happens because
> > +		 * __folio_batch_add_and_move() clears LRU flag, when adding
> > +		 * folio to activate batch.
> > +		 */
> >  	} else if (!folio_test_active(folio)) {
> >  		/*
> >  		 * If the folio is on the LRU, queue it for activation via
> 

