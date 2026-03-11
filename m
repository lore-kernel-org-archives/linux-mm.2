Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 552FA1125876
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 20:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99FFD6B00A1; Wed, 11 Mar 2026 16:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94E146B00A2; Wed, 11 Mar 2026 16:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859ED6B00A4; Wed, 11 Mar 2026 16:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71A1D6B00A1
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:09:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21CA113ABDE
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:09:27 +0000 (UTC)
X-FDA: 84534871974.03.97384B1
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2A8441A0015
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:09:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SZIFaxta;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773259765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQuA0YpIdsrN1RWSmhy/mTOwH1p+GbEMS26GuV96Pq4=;
	b=1A5lKXFQIyUJcWEIDeEPQaFNcQsXZDyuQx31tq6ho8/EMkuyZ1AuRlV5LzqTjLlAhC3nFy
	+CMOT7EtZeT8ogDr48nmTS+DEJln+dFqZoKRzgi3UUA6V5vgWCqkxqevWrxt2Ss9J44Yvf
	h2fjk50ZjBk2Ex3CcyxsDkMlQmH9Dlk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SZIFaxta;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773259765; a=rsa-sha256;
	cv=none;
	b=lQi6/1EhHRpI9Y7Z7IC6H2U6iNP3N+yFvYSbRTjwapq/3aWjMCcK3X5GQSjFGwQzX0WIX2
	v2xV4Bl0AG2fY660mICuUMgQ2BFTmPBBPfknksahx3RoYiAGi+BWU120iydpYBIt8Jpfzd
	NJPFgsokAZ0+2q2j3kIfsVwzKD3Wxio=
Date: Wed, 11 Mar 2026 13:09:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773259759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uQuA0YpIdsrN1RWSmhy/mTOwH1p+GbEMS26GuV96Pq4=;
	b=SZIFaxtaJcxWlYrLTUvftvVaiPSgdlnpcm5+jKsRFAO68U7Szwobz4MYv7xVhXIv7ubHRU
	LP+cHJlbjgIhI5iJTUzVOyy7yAzcMgGTkQ5uZruF91OmDwhGx6c9Zkg84GKMlCOg1os8/7
	I1nHql8jbBTqQIrJMEe1P5uCUdFJlPg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Dave Chinner <david@fromorbit.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: switch deferred split shrinker to list_lru
Message-ID: <abHLtmDvYl5QYCv0@linux.dev>
References: <20260311154358.150977-1-hannes@cmpxchg.org>
 <050ce5bd-4725-468e-acaf-7fca72b84d06@linux.dev>
 <abGpgxsDKeSc6cjR@cmpxchg.org>
 <abHBYss1GDYX4uWe@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abHBYss1GDYX4uWe@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2A8441A0015
X-Rspamd-Server: rspam07
X-Stat-Signature: ba8h5no67bfz7rbn6dm6nog4wkqdw36i
X-Rspam-User: 
X-HE-Tag: 1773259764-226166
X-HE-Meta: U2FsdGVkX1/YWbFqnAKVXNG3FCyD5JuIKFxMQDl7enxKg8Z/DDH6c9AyEt+M7qQbdj9ZinitGPOTPbzSH0sulpwR/veQSMQF5qj4vLxjYyUH2OumCqZdPMIvDTgMqUtwE9uJERGq9kBaYXwlrQiT2LAocUdwfygyZPzCyRM6ALf7IftHxNp+TpYFtndjm7hSYYkaOMeC6fIC5Mw5Y0z9JbCL3NYsJfI/hocci25bdUdHRTQ5w97buu2MlDHjzfXGlvcFa+SOw83uBwKjLIerPHCknpYZE1eLXdhEen08lSZQuZJOzDSTnG0xjjSURuedGMmYdJ2+3kAaf3g65C3nmuTzTGWKGuckJLar8lp+C/I9ziTwT9y1TX44mmGYRpg0/8Vaz6PYZJALxq0pwkV4wMefbTofvH1p8dYD7lB4KC+Nk2LoAbKMnlrB+7Quyp+LoCdrFXorbDo3VIC1N98TAsRH4KmCxiKHEQIlGdaUF37KlfAevDbyraVfM7O7IrOyj3nX5YfcSBjwPlXfRupx3B6UTqw2B4ofHIc4jV3sVOvLBa0z/DYMlGOTPSK5QmzYGY1prSLKRL2OQsfHlU4J3bRI2LNN4L3HK/VwkgXsny0LzG8DoKK6V3tgJ3DN5w3itkSQU4RddmqN9NIrR3OIns/i7lCHCgiloXZF/aSO30CwSB5+ok6TIH/ZIiRWPWgmXhT5+HxzikMsiqmq1pIAWKHo7f5lepZj5exthGCM4m5suC3FQuF0ITfQz9HUM1eh5AjxMO38XHLoscA1iZaLLZjRRZvIie7+2r+twmjXU1n5uYDM8EbYArHyIPb7kZkgETC2jm/orIH9MyqiIK97ngMvCtTudCFH4HEoMX/eLhp102d/w0/JbPaD7yYp7LS9XqgxgAOlfF2g5FdymYwc/dd3zJhqANSO9p95cnOQxuuDot4fzVTC2J8RqMpC5PN14Zgem1h4u/88fcVBVd2
 2CnbKpcG
 Nfpxw4A+DA2On7XfByBguda7xq1A5IdEBg67wfWjLRc6dam5frEaxoD1/IsCnxsGkZJvnge6v9gAVjIXEignEiqAc9xlrUceijswY/V+KA/BJuR18D2Gk3LyhHOpuYcyT0pjnhaKl2cl5gZ++xqg6GNSJ+Ee5/MITp24DDGOBuIRAxcM/yUsP/YdzyvcGoqhhvQ1N6JR2mwFeSFvFFBm4GIDoWBJc3UqaL7mxKLqp7MvxdP4Vtw9Udj/6dsPlLU76CyOb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 03:24:18PM -0400, Johannes Weiner wrote:
> On Wed, Mar 11, 2026 at 01:42:32PM -0400, Johannes Weiner wrote:
> > On Wed, Mar 11, 2026 at 08:00:29PM +0300, Usama Arif wrote:
> > > On 11/03/2026 18:43, Johannes Weiner wrote:
> > > > @@ -3802,33 +3706,25 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
> > > >  	struct folio *new_folio, *next;
> > > >  	int old_order = folio_order(folio);
> > > >  	int ret = 0;
> > > > -	struct deferred_split *ds_queue;
> > > > +	struct list_lru_one *l;
> > > >  
> > > >  	VM_WARN_ON_ONCE(!mapping && end);
> > > >  	/* Prevent deferred_split_scan() touching ->_refcount */
> > > > -	ds_queue = folio_split_queue_lock(folio);
> > > > +	l = list_lru_lock(&deferred_split_lru, folio_nid(folio), folio_memcg(folio));
> > > 
> > > Hello Johannes!
> > > 
> > > I think we need folio_memcg() to be under rcu_read_lock()? 
> > > folio_memcg() calls obj_cgroup_memcg() which has lockdep_assert_once(rcu_read_lock_held()).
> > > 
> > > folio_split_queue_lock() wraps split_queue_lock() under rcu_read_lock() so wasnt an issue.
> > 
> > In this case, the caller has interrupts disabled, which implies an RCU
> > read-side critical section.
> > 
> > That's also why it's using the plain list_lru_lock(), not the irq
> > variant. Same for the lruvec lock a few lines down. I followed the
> > example of none of that being documented, either ;)
> > 
> > How do folks feel about a VM_WARN_ON(!irqs_disabled()) at the top?
> 
> Okay, lockdep actually does warn. rcu_read_lock_held() is explicit and
> not appeased by implicit RCU sections.
> 
> Paul pointed me to rcu_read_lock_any_held(), which we could use in
> obj_cgroup_memcg() to suppress the splat and permit implicit RCU.
> 
> Or we can make rcu_read_lock() explicit in the above code.
> 
> Any preferences for how we want to handle this in MM code?

I would vote for explicit rcu_read_lock() to be consistent with other places.

