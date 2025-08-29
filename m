Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1663CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44EDC8E000B; Fri, 29 Aug 2025 11:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427058E0008; Fri, 29 Aug 2025 11:53:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33CD48E000B; Fri, 29 Aug 2025 11:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 211BE8E0008
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:53:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCA7F1406A7
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:53:10 +0000 (UTC)
X-FDA: 83830238940.30.FADA3D0
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 176F220013
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:53:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yy+lqsO1;
	spf=pass (imf13.hostedemail.com: domain of hughd@google.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756482789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VMpbX/2FtFqpgYi77vApNFXCw+W0zMV1YchkzsWEhB8=;
	b=3zYLC2w5ZbykQeqisoG+0M53ZudYifDWWXNYzoSiP+1p+pUd6A31etPvEQDRuMh+w2DanV
	X/A+VBYLKJTFgKbf2yEM//ncjmaFbhYGVy5eazjfzyk59hFFZ1gR0htZ7SICc0omowdVte
	+zeNgGwrtuIwHC1zQjQW4gkydjX3pzA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yy+lqsO1;
	spf=pass (imf13.hostedemail.com: domain of hughd@google.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756482789; a=rsa-sha256;
	cv=none;
	b=bqAESjuAwQpN9OZLDTUa87Q8ljlix6xMpCJ/KXBBtOl9a/Ko3KH7gUbKKOAzhTnG6I/EuW
	g4Q81aSf9/Jq3L8XufkoCrNv1bUTTDgycc5FUr+/0pLGjkjxfoSWwfaOgCS1SnGXcOUTNn
	zg6ax0Dda0ZEIcJcHpSRd5FdFxW1CnU=
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-54475262383so1824678e0c.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756482788; x=1757087588; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VMpbX/2FtFqpgYi77vApNFXCw+W0zMV1YchkzsWEhB8=;
        b=yy+lqsO1D6fLGWHBb6QVmC7I4mZWOzD7RruXLqgJGEXjMhRPLqGa/glJsryxapEzQu
         f8ADw+1t1lWBxVHleV/IYBPTZoLhJiBljFVJkgKhbkP0Kmt28MVDYsNeJrKU4U7j2vvp
         nb2enMFwLBguwQkSv8I+b1YTG8GDGDA+zOqxjwRrQ2/i66ccPbYzUHYNBjktGzYIPyLA
         ZxQ3K5G8QPWlh5i3iYtrneEEBKo9LV11EtwdfcdlPHJ2zSMXOCC9yl9tWOa8huFKe5J2
         rSC7QJoNL1ABTsHgLjbZS2vAe4lgQjcxhzrUMc0Xn7YyFSxtZddkzHJHSJfpQpp9U1Wr
         9+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756482788; x=1757087588;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VMpbX/2FtFqpgYi77vApNFXCw+W0zMV1YchkzsWEhB8=;
        b=Ly6zS6I8onLzAz7hDtyasDSpwfuj4Tie/VYgwu2jLAwUW3Vn0v8qiK4tTLBXW9kj6v
         gNKDXnzCBPknlwKiEt3HbRmWRyQK7cqT1FwDoTsP0wdZS5XrIkLTePlbZw1o/B2eQoR2
         Ro7SWbP/WeUGKr3tVSsQa6MuB3JsMslbsMQ6LrgSzpexRWQ956tq+605/6q5Bwu+fUaV
         AzuguPdQOL2FRa38NI/dr2iEbMQuzYXkK+8HTSt7Bzctec946tFdlyWqMTwPuah8B3rm
         sIW8WwxV/JLTixW4h84Ugx7Pe/eJgjiLXoI7vjhL+BS+vqgo/w1YSPWSEY/fs/VnT5VE
         eigA==
X-Forwarded-Encrypted: i=1; AJvYcCXNjQ7QIkrvqa8nvrrv+nh5YwpXoijj+7g3eeu139RQc9I/J9Dl+htZWOWP/iMUV36Dvt58FGQlBQ==@kvack.org
X-Gm-Message-State: AOJu0YwjBY0wC8hwBroKaYNeHYri+jtiPVNIjoFmIf5NylDxTOLBIFo1
	1+4TKL+6LMh1qsdyFttz+7YWTFRkPAg3LZeUTVbrP7uoUaO9o1YYKLJudxP+wkYgH/TeOzUnWmX
	EE5a1lr6g
X-Gm-Gg: ASbGncuP44rc+n5q9v9jrO/+7reFq40Pp4B15hTC1g+6ilO5ZdXPVeqkiPjzI/kwaKv
	9ERhDhQavXsDo87MHJjh5d8TG6ogEE40NYYQMq6myTPfzg4IjFhUc78pMNZNtrhv0uCxSOiJ0y6
	TJFImdHhQG/epCs6LG6AMlMjjv+NsL57c6DdGmEtbdwu/E7lTtrLkIcuS/lO4RtqbGdmROeOwZ1
	gY94z/ZMzfa0BPDmFHB9p2YrJvSItPv+c4L8FVmPifcaJHHjC0wjWejpMUz4rFbK4dMQV/lZbsI
	ysUJBdN4e8fOexmK/avJwNabcyxz5R4BYq9Z3PpnjpvvF+hVQiGBLnpKyzQmBLsPnaZ77o6YkAE
	kVCxaXzWyGH5F9Aq9/v67UvnGEL7MQYY94FD5RRPbknE6MSQbuTXJ3aDseXdPPm8px4HgnY0aaT
	J1ge1mqIz7K8hiKg==
X-Google-Smtp-Source: AGHT+IGYbdSHodDuTFqyNCLyyFCsXP9AkvMjFSwwU9xyZEIsbEfHIyT2HtUbmAyGlDvSOEG31G+Qvg==
X-Received: by 2002:a05:690c:63c8:b0:71e:6f13:976 with SMTP id 00721157ae682-71fdc2a89f2mr254116157b3.6.1756482424706;
        Fri, 29 Aug 2025 08:47:04 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-721c63530acsm7713727b3.26.2025.08.29.08.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 08:47:03 -0700 (PDT)
Date: Fri, 29 Aug 2025 08:46:52 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Will Deacon <will@kernel.org>
cc: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@redhat.com>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
    Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
    John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>, 
    Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
    Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>, 
    Ge Yang <yangge1116@126.com>
Subject: Re: [PATCH] mm/gup: Drain batched mlock folio processing before
 attempting migration
In-Reply-To: <aLGVsXpyUx9-ZRIl@willie-the-truck>
Message-ID: <7ce169c2-09b7-39e3-d00b-ba1db6dd258c@google.com>
References: <20250815101858.24352-1-will@kernel.org> <c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com> <aKMrOHYbTtDhOP6O@willie-the-truck> <aKM5S4oQYmRIbT3j@willie-the-truck> <9e7d31b9-1eaf-4599-ce42-b80c0c4bb25d@google.com> <8376d8a3-cc36-ae70-0fa8-427e9ca17b9b@google.com>
 <aLGVsXpyUx9-ZRIl@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 176F220013
X-Stat-Signature: fic4hpb7ku7afbdtzschd1txuxu5x6wp
X-Rspam-User: 
X-HE-Tag: 1756482788-608383
X-HE-Meta: U2FsdGVkX1/OXT03kjzm/IHysotSuRamYwoxkvjKjCMbH+ydWwzrmvOB9G7cBtmDU2LnjcWUyDSU+3l6DaqKWZjqiQ8TzJU3tJTw40kz3zE+iprKmd03RmUghj+w3Tn4d+Kkb7oIxy/PVRy5WWUL8n88GagGp/ZDhm+hlNxCBsNnsvNVoW2GXP+ud8NHKqbgqtKDGB/7rx+8yupQGJj8yR9aq2sPr7tkTChdGk+gsPxEJ2gKnTroObBnuBkzo4RRl0H0Rf4iZRu8Zodk3Iyg2nC7h3+iHwsq68R78gJ6ZY0Y9dOW0OqocMHJmpTVJc66MEZmgpsGGJNplcIm3WBnK/vGMVso3S9xzZ9TdaGM+Ksd3dGthtHH5DUZ3TgXsyn7iwGk3L2aPu+/8JTmDTxNHqzuop2QNz9UWFXPCoKwUjhHorZykOif21UKuWdewjsiaQE41yU6NZhYqyF7rchmOADUF/9e9JXP0tCTLmT885IZTFyPwxWM6xyJAiSnM+sgGjzw71Cedl3XnH/o8hkFJhxQRxJDGExpiUfNLL46jBtQMVKxHazN6t9xslByyAik9ax551fMfJAme7qYggRpVGiiuTPti5Q3kYY8SJdE7WKUJAczbked0hZBABdYRDXdKtzpci7Kes+1DpL+nMN7BQUBJs73XFg46aY7+z549mn7j22avCZwN36axCTqahQggRZvHlD9fflqLzdqw7uZ/6n8C6uFDz05/BQd3dmIEwOFtr/6pRCMU6jcmnB4NzN6ytvFp1ArA+FP2D0D56qkPdsEQUKfO9eMQ3Zjj2DoqGlxhMcQ5gJQKnz7GyOqMky3kppRo24l19C8pwxN5MW6kATyu1zaCWtBakNDM4VoQYN9w1ZHIDmMo3q+SM/NxFx6WzWKWMqeyQcV5a8uuHe1/8Az1B3UA1foKJfa3Oe4/IDogUREVYgNurRRIPQV49AOG4bzWty0NIoCqmxmAz2
 c7yFC+bU
 Py7+FLXx33OY2mLghqcC/xzuUwiO7rtOkRDvMpeVEPK96PWtZ0LSjI1ilcZoF0m4SsMJv9xEOFcHWmxyyqoeP7vrp85AuRd5jInZx18G6uM0VSUdmLeZ3x3mi0+Rp9MRjSrItCoBsys/FW69IZ1OdGeyrwBg2ZqP0zc+C7xyPYDbx5Pid7ejkZtwIphN0J6uU5MWxUb33IjoLBDZtVwPS4p7lQ8AjzACdWiHktMzmg4/rE+eDU0TBu0Y5o3De//7ED0XMNHutD2oeQqeMIrSMw3tKj/rTI1iNoKARhxB7SzuorXj2GbZyn4V/5yzPzwXwXHGD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 Aug 2025, Will Deacon wrote:
> On Thu, Aug 28, 2025 at 01:47:14AM -0700, Hugh Dickins wrote:
...
> > 
> > It took several days in search of the least bad compromise, but
> > in the end I concluded the opposite of what we'd intended above.
> > 
> > There is a fundamental incompatibility between my 5.18 2fbb0c10d1e8
> > ("mm/munlock: mlock_page() munlock_page() batch by pagevec")
> > and Ge Yang's 6.11 33dfe9204f29
> > ("mm/gup: clear the LRU flag of a page before adding to LRU batch").
> 
> That's actually pretty good news, as I was initially worried that we'd
> have to backport a fix all the way back to 6.1. From the above, the only
> LTS affected is 6.12.y.

I'm not so sure of that. I think the 6.11 change tickled a particular
sequence that showed up in your testing, but the !folio_test_lru()
was never an adequate test for whether lru_add_drain_all() might help.

I can't try to estimate the probabilities, you'll have to make your
own decision, whether it's worth going back to change a release which
did not (I presume) show problems in real life.

...
> > Unless I'm mistaken, collect_longterm_unpinnable_folios() should
> > never have been relying on folio_test_lru(), and should simply be
> > checking for expected ref_count instead.
> > 
> > Will, please give the portmanteau patch (combination of four)
> > below a try: reversion of 33dfe9204f29 and a later MGLRU fixup,
> > corrected test in collect...(), preparatory lru_add_drain() there.
> > 
> > I hope you won't be proving me wrong again, and I can move on to
> > writing up those four patches (and adding probably three more that
> > make sense in such a series, but should not affect your testing).
> > 
> > I've tested enough to know that it's not harmful, but am hoping
> > to take advantage of your superior testing, particularly in the
> > GUP pin area.  But if you're uneasy with the combination, and would
> > prefer to check just the minimum, then ignore the reversions and try
> > just the mm/gup.c part of it - that will probably be good enough for
> > you even without the reversions.
> 
> Thanks, I'll try to test the whole lot. I was geographically separated
> from my testing device yesterday but I should be able to give it a spin
> later today. I'm _supposed_ to be writing my KVM Forum slides for next
> week, so this offers a perfect opportunity to procrastinate.

Well understood :) And you've already reported on the testing, thanks.

> 
> > Patch is against 6.17-rc3; but if you'd prefer the patch against 6.12
> > (or an intervening release), I already did the backport so please just
> > ask.
> 
> We've got 6.15 working well at the moment, so I'll backport your diff
> to that.
> 
> One question on the diff below:
> 
> > Thanks!
> > 
> >  mm/gup.c    |    5 ++++-
> >  mm/swap.c   |   50 ++++++++++++++++++++++++++------------------------
> >  mm/vmscan.c |    2 +-
> >  3 files changed, 31 insertions(+), 26 deletions(-)
> > 
> > diff --git a/mm/gup.c b/mm/gup.c
> > index adffe663594d..9f7c87f504a9 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -2291,6 +2291,8 @@ static unsigned long collect_longterm_unpinnable_folios(
> >  	struct folio *folio;
> >  	long i = 0;
> >  
> > +	lru_add_drain();
> > +
> >  	for (folio = pofs_get_folio(pofs, i); folio;
> >  	     folio = pofs_next_folio(folio, pofs, &i)) {
> >  
> > @@ -2307,7 +2309,8 @@ static unsigned long collect_longterm_unpinnable_folios(
> >  			continue;
> >  		}
> >  
> > -		if (!folio_test_lru(folio) && drain_allow) {
> > +		if (drain_allow && folio_ref_count(folio) !=
> > +				   folio_expected_ref_count(folio) + 1) {
> >  			lru_add_drain_all();
> 
> How does this synchronise with the folio being added to the mlock batch
> on another CPU?
> 
> need_mlock_drain(), which is what I think lru_add_drain_all() ends up
> using to figure out which CPU batches to process, just looks at the
> 'nr' field in the batch and I can't see anything in mlock_folio() to
> ensure any ordering between adding the folio to the batch and
> incrementing its refcount.
> 
> Then again, my hack to use folio_test_mlocked() would have a similar
> issue because the flag is set (albeit with barrier semantics) before
> adding the folio to the batch, meaning the drain could miss the folio.
> 
> I guess there's some higher-level synchronisation making this all work,
> but it would be good to understand that as I can't see that
> collect_longterm_unpinnable_folios() can rely on much other than the pin.

No such strict synchronization: you've been misled if people have told
you that this pinning migration stuff is deterministically successful:
it's best effort - or will others on the Cc disagree?

Just as there's no synchronization between the calculation inside
folio_expected_ref_count() and the reading of folio's refcount.

It wouldn't make sense for this unpinnable collection to anguish over
such synchronization, when a moment later the migration is liable to
fail (on occasion) for other transient reasons.  All ending up reported
as -ENOMEM apparently? that looks unhelpful.

There is a heavy hammer called lru_cache_disable() in mm/swap.c,
stopping the batching and doing its own lru_add_drain_all(): that is
used by CMA and a few others, but not by this pinning (and I do not
want to argue that it should be).

Hugh

