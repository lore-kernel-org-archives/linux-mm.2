Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 292CBCD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 05:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59E7B6B025A; Mon,  1 Jun 2026 01:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54FC06B025B; Mon,  1 Jun 2026 01:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C496B025C; Mon,  1 Jun 2026 01:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 376096B025A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:26:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3F64120502
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:26:51 +0000 (UTC)
X-FDA: 84830209422.08.54F8487
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id E248D4000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:26:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="q8Qc/awu";
	spf=pass (imf01.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780291610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtOXwa25C4vrU9f04Y4XaGTk/Jc7P4Jl39cBxI5Wx9g=;
	b=ZFjEW+AnZg62LP5NHOVjL+lekvABtEZqY8FFO4BvS+759M4H13Pu8+KblB6NH4aJ+4sLZd
	LT55pX1R8immaCJY6JEXNnaGo7Is+RhJkwtO+oHMP1uzmVBNHQL4QVyiiCqyFXpoX7wgzd
	eBZUZ1bVJhd/eIx3yJN8SOXx/8M+DH4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="q8Qc/awu";
	spf=pass (imf01.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780291610; a=rsa-sha256;
	cv=none;
	b=hfQHicZ980BWSFr5wakAt/KJX65EuZUPqxgOCzMR0rtkzY0PnGbAjarxjzsxv9KK3keB/l
	wbdgBH1fXqXyei8LKWlpA0SuiSIJvcrg2SYMSLm1AB8KckzR12Fl0TKpZbGtOJkoRXbxWs
	U9pqHAsLHU1+DQv7juUiDE23VFbFgLQ=
Date: Mon, 1 Jun 2026 13:26:31 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780291606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YtOXwa25C4vrU9f04Y4XaGTk/Jc7P4Jl39cBxI5Wx9g=;
	b=q8Qc/awu8wjej7TCUDd1zk5jcCLgIZMVDtzQBo7W4xXVZzt7QWn5s8/hZlavNEKpJjEs7i
	wnUYqP/4NQW7UjC/PQDIpsKN18xV7sBdRAqaqneh/sAGhG0XI9fdXzugOiM8JTvRjAnks+
	vQ7S+iQwg+dCtSNtx4Rli5akXwoJzWY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/slub: introduce helpers for node partial slab
 state
Message-ID: <ah0VlxGBk11LRg53@fedora>
References: <20260529035120.81304-1-hao.li@linux.dev>
 <20260529035120.81304-2-hao.li@linux.dev>
 <5ed81b4a-1d18-4535-a18c-1bb31969ae78@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ed81b4a-1d18-4535-a18c-1bb31969ae78@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1s7pcnmh5dka4yckp8gy6km1h4ui34dj
X-Rspamd-Queue-Id: E248D4000C
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780291609-272391
X-HE-Meta: U2FsdGVkX1/n2PPU+sO/t34entFeEgBGNjCeC1dO8Qq3kmolMdKtJtnyzEGxFFs8DkDzc3TKEkrhHd5EPzsAraJwWuM3ZACSfkLrGxlSu7LIPa08PpfIkeKCX+1g57zs6BeXi5p85ZU6taNvuKzfnbRDUskcDCwMvUnPEKil2hmwJPu8SCspLO0DjF8NRWy4xyPk61zOjpJHeiRbQxsDCGg+a8z2VYniOiGIEsZvdOPLRYQr+AFiE1f8wyqH9SJemFrF2g24XSdGnRbWdtXtytIWta3dgJLf95wGflS7177N/jxpvc6mIKG7T4NfGfekL+N+J8qDlniSJqEQQzMfUXiMk7RzsAZog0qXITGXl+2aKOaDEcykPnAFBP6cvJYNdH7gaJJVITbKR/Ryaa90Jk/vNOsQajEg6mttXJHIPoWXF9EzWcU7LixjSRP+Dmqwoy697dhnjZidEMLZNDdD65PDMndkY31Ved2Zy/P4pmVDY3rXMxnDYx4zMq9bIipGeEdfEPyAY3j8zLk7Rr+AutDOvSSbM3mIqmUJ+VoZ67GClwuwwh8GqnYyr0FTYKldB5oS/J6jl2SDTfos1T5RrufUHm1LQN9NR4Gd9CgbY5QXYe6/2sEYlmkJLXWLirtnd0t7FeU2gSYfK1w1GJ0L1+7S5t1/pX8xSSf/f4Htk9a7QYzFtRSNp37VvRaenLrT7x13TddJ/fwLBra2N2pUedJpwoJreYr0n+q+NELlxGEV9LWrmC9ACLRuvq1t0JkZkyTzzPmWwp71Hn0ZEyL/lpEpLCUp816ApAu+rJI62o/aFiSSY83nhUq16pW730qR8eHWV28UVWkECyy0X4ddALL8tkFzbsICdBD36Ko5rNLGCZzQcv2w9pO9x1vftFxbFmYmzfI1o1o+hqcX6Fab5/VSZa4bf2mvtOdJc8tcgBbQGmVxhWxbJ2lSBRBLSQTPL9qfWcgM6AjUfHf2amb
 EuVZfHd8
 ARJC5bcDxPvU2Du+Yyo4mJC38QvkS5QobtjA2oizfm9zI0y1f8SCJI+oK8ErZ4SLVF5+MJH4O4xllL6lMhVDzatgrSzNmvu39kw7G4oz+BKKWkJjbaCJd7sWWlCkvk8DczR5nwEOMCWQU567aZPjQ0dWC9MN9xkGViy63gnJsS+65ImKejP3YSCZtwI3EhRy1sshK54WVLh9EfEXMfbAUEQF7cbfR9dPMaZOP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 12:38:48PM +0900, Harry Yoo wrote:
> 
> 
> On 5/29/26 12:50 PM, Hao Li wrote:
> > Wrap partial slab count inc/dec and flag set/clear into
> > helper functions to reduce code duplication.
> > 
> > Note that __add_partial() is called locklessly in
> > early_kmem_cache_node_alloc(), but since there is no such use case for
> > removal, __remove_partial() does not exist.
> 
> nit: __remove_partial() -> clear_partial_node_state()

Ah, in this sentence, I just wanted to clarify that __remove_partial doesn't
exist. it's not a typo :)

> oh wait, it does exist. Let's drop this paragraph?

This paragraph is just a quick side note to explain why __remove_partial()
doesn't exist. I noticed that __add_partial lacks a symmetric counterpart,
which felt a bit abrupt/inconsistent, so I wanted to share some context on why
that is.

Historically, the __remove_partial function did exist. Back then, we had a use
case where free_partial called __remove_partial without holding the lock.
Later, free_partial was changed to call remove_partial under the lock, which is
why __remove_partial was eventually removed in commit
52b4b950b50740bff507a62907e86710743c22e7.

> 
> Otherwise LGTM!
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>


Thanks!

> 
> > Suggested-by: Harry Yoo <harry@kernel.org>
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> 

-- 
Thanks,
Hao

