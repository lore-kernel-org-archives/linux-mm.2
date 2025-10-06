Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE8C9CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 12:07:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED4EC8E0008; Mon,  6 Oct 2025 08:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAC718E0002; Mon,  6 Oct 2025 08:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE9318E0008; Mon,  6 Oct 2025 08:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C6F2D8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 08:07:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 622AABA090
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 12:07:51 +0000 (UTC)
X-FDA: 83967565542.25.344BC75
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf20.hostedemail.com (Postfix) with ESMTP id 86E0E1C0013
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 12:07:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Mf+ZdI48;
	spf=pass (imf20.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759752469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YLus2oidZhuPLLCuKN6qeIc9LNAh5RPLc15/go5eJq0=;
	b=OBpGTLHBjb431wpNp+Oj0q1AyXQybbyI5UkYam9CaQPT5ZBtvTIS4yemRxIt4TI8oEp+S/
	0IHe3YAdbDO7A2QUkDxp3qClyqRbu9yVv9v/9q2U20kc22nliTpMqKOKuV6OxPxWXUHeD4
	H7TZ4zCDh8hnRW8x7rgHxnoJ95VJztQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Mf+ZdI48;
	spf=pass (imf20.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759752469; a=rsa-sha256;
	cv=none;
	b=7UUxJHeV6Dau+zRxJna6w0rTOPlPDeIP4E6H/LG2XHD261x/WCI5laJDZOVXLqxG5MAnA2
	gqDKSCWgtP0lD9TKp8UE9UfFGqNnwtfhzs9epdwVoq4Ah1+ZqsYcqlzGOuMNYLi9M7JUEs
	j1mKbiG2V8Usz8TvTMEgZprcIutPUz8=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id E7E6D92EEB;
	Mon, 06 Oct 2025 12:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1759752468;
	bh=YLus2oidZhuPLLCuKN6qeIc9LNAh5RPLc15/go5eJq0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Mf+ZdI485yDQ+PKFOAkxc3ov9ZwjDgt6kvSgRE6M3ZzluDdlDxy66UmT/zfUngDeL
	 VIuayN8BcTdaoVROApToZy+38cbx97ER3vxC2waa2GpTWzsualnliNoEshPWEYefW/
	 VUv+yv0oys7msaqm0CPBfyTBMLPL2Hkbr4y6vadY=
Date: Mon, 6 Oct 2025 12:07:30 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: skip folio_activate() for mlocked folios
Message-ID: <aOOxAtD9oeiYlo7G@shell.ilvokhin.com>
References: <aN_bix3wDpwYPoVp@shell.ilvokhin.com>
 <hnpzad4aehmp6ncgwhlinzx55z3zst5dlkhsjphpazccy5lzpv@hfj2eyewuplz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hnpzad4aehmp6ncgwhlinzx55z3zst5dlkhsjphpazccy5lzpv@hfj2eyewuplz>
X-Stat-Signature: ri4abs9ab5tsxfyj7bk81nsb8cu59z8y
X-Rspamd-Queue-Id: 86E0E1C0013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759752469-687369
X-HE-Meta: U2FsdGVkX1+MzCdFKRmneQ9q4rAVLBJDz+baEiX7+ffsZQqG6j1kdC5UvlaaimB6PXCMSj8it3pAS/EacE8YF0G46Mea9jpwkEL/3FQeDgCERehPjqBMR8GSZq/Ly7NbRJmdQA5jHLKPRXpKJSP8uP8PAXVPFxy4ZfOU7/W9beHTOGTu9DGRy6rD+n5fUknu8sG94OIahNXT9sbqq7MuUOon8x0kpk2X4tm2tiYNaueNqNGBZbaMQE4mfz/eO/VNT3d890+9sbOAhVe0/XM0xysAtI8tLPht3ObtylIhdAkO22RRwMEpMP6SEMCfiflDtpxcN5Ui1HbLAcL6dq363ybJ77oloN6BBzmsHmZTLCyTsTcBiFPw2DzBqUicaFge301Yty4txu7PaiQdYRQraBY1HKgqiflNUIzUHlX9yQB7VPuSPVbWPDPOqIeSZVe1IgtUf+QYt7r9zaNKGXDWO4Fdc44MekxypNayBpOZGNkb+h9lEwESYp8RtFHdO5nqcWeHFW5GDcrRChbmrQ4gIMiQWrBQ5MQ25GnJB5tmzhjD6PZFMy9RV0wgWdiO5JLnyRLd3tQ3uoBC3mcw1tT8NTBKfnHYjO0H3mdVEjN7u1S2iZjDyPe8Ffg6cq6cGVUjyaEgOK3i71nVlrRdLusnYdFDmqzSDVdyRPEhDDyJxPXEAONnOx26X/tVkhzPELfc6McHmvnTiMy/3yA3RupcMlvR+/D9roAwdM+oY0iwqTJzWOwveUXnvHt/LsxhFdsuRA4lTgJcD/K9+WWipmmSTkxMICMLFd9VFrOHb5WJJcyOuDDUTuhGyuglH8NfA81lyVn84cdDH9FAb6/VgIYhXxupqCsrctB1MAZQyDhvA3RLTmYHQjvQpMGJY8MXfgSEORUK1rYuJY7xL9envSkBCPtTGyu2uOGd06bjwET+KMVLvUZr/XcMVfikviPXdeA6pS4Y8NQ3GBYpJIqtkg1
 Ttci8FeH
 5Il2qltSO+d8FNaizlJ840nul7JiGQ1XPCw7O/jB1VjxLZke3lUpcu4KBy49q88Zi6xXLK/RV6A/q/70ABNP09b9FwxAChIWFKbFssDs3Zmr89M1qf/SpqhTgLG8LhtusbLTkJSgsJk1kSHfuAE56xVkj3yAvOmCXTe4sDDAa9g9ntSOrve/3pXFWjNV9Ohu8bxrt5wgn981HlblPs27qtNnem5FYQeEFf1qM71y2Dql8yOgouhKTXMPjFK8EfD4Lrx02ELa59UHCWqFf9Qisk4dcxBjUV9wGYGi4YaMWuOMhuRDVftzGOEZ3HOvwzVupkvsMtporGws3BeaJlMQSNRAG1grXCL2MZJCxP0I5eQWkJnQ94sqkfzU8WTEj6aTkNW5xevVZ2mm6Pfs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 03:41:05PM +0100, Kiryl Shutsemau wrote:
> On Fri, Oct 03, 2025 at 02:19:55PM +0000, Dmitry Ilvokhin wrote:
> > __mlock_folio() should update stats, when lruvec_add_folio() is called,
> 
> The update of stats is incidental to moving to unevicable LRU. But okay.
> 

Good point. I'll rephrase commit message in terms of unevicable
LRU instead of stat updates in v2.

> > but if folio_test_clear_lru() check failed, then __mlock_folio() gives
> > up early. From the other hand, folio_mark_accessed() calls
> > folio_activate() which also calls folio_test_clear_lru() down the line.
> > When folio_activate() successfully removed folio from LRU,
> > __mlock_folio() will not update any stats, which will lead to inaccurate
> > values in /proc/meminfo as well as cgroup memory.stat.
> > 
> > To prevent this case from happening also check for folio_test_mlocked()
> > in folio_mark_accessed(). If folio is not yet marked as unevictable, but
> > already marked as mlocked, then skip folio_activate() call to allow
> > __mlock_folio() to make all necessary updates.
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
> 
> I think it is worth starting with the problem statement.
> 
> I like to follow this pattern of commit messages:
> 
> <Background, if needed>
> 
> <Issue statement>
> 
> <Proposed solution>
>

Thanks for suggestion, v2 commit message will much this pattern.

> > 
> > [1]: https://gist.github.com/ilvokhin/e50c3d2ff5d9f70dcbb378c6695386dd
> > 
> > Co-developed-by: Kiryl Shutsemau <kas@kernel.org>
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> 
> Your Co-developed-by is missing. See submitting-patches.rst.
> 

I followed an example of a patch submitted by the From: author from
submitting-patches.rst. This example doesn't have Co-developed-by tag
from the From Author. That's being said, I found both cases usage in the
mm commit log, so I'll add mine Co-developed-by tag in the v2.

> > ---
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
> > -- 
> > 2.47.3
> > 
> 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov

