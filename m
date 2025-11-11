Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 984A2CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 08:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC2058E0012; Tue, 11 Nov 2025 03:01:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73228E0002; Tue, 11 Nov 2025 03:01:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61128E0012; Tue, 11 Nov 2025 03:01:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C24B8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:01:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 66CB488573
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:01:59 +0000 (UTC)
X-FDA: 84097582758.01.CE60DD1
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id 969A62000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:01:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=vMvGc8hC;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=iUqoMMo0;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762848117; a=rsa-sha256;
	cv=none;
	b=a3Oaes+5zMj6k9JJGjum9hMZJF9CSJri6UIPd0gbyvZ4+hnBZo57QCD4Xd/OSeC7PAClGl
	lY8bhrXDcakNs+pRlGZI31wG3oHAzejiD2pM7Cl5oqYCMTp2vLSSRogORPTASAOQgGI8z2
	y4vDtZk57bS9JkuqqzqmQZE9nBoQFiI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=vMvGc8hC;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=iUqoMMo0;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762848117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dx+P3tmh8RRhlJbEuybtXJQuyEPuClVVZRpIZ0Mh1q8=;
	b=itS5dVD4f6+klWkGyVTxmZwREvMhYdUExKhS9L/E69YSV9TqhHz+jKa4lPE7lSY/ZLeoJJ
	xXjgp5Exd5Jqhq8CvjuwZ2Yr6i7ToDa9nG1PbH/VOc5T5ZtOfpBD07r2fZQUlgIUin63t6
	JGlNj48EBEwCM0/G5xXLY7bHhZXxZww=
Date: Tue, 11 Nov 2025 09:01:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1762848115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dx+P3tmh8RRhlJbEuybtXJQuyEPuClVVZRpIZ0Mh1q8=;
	b=vMvGc8hCbnyKYogzWdAmHFKDT2esfKhiN/1WVwqSpRwIuyM0XqM+Hw24fN35m+ziuw1ZwN
	H4+vaj9gT0so58eZaRH8Fghkk14qaV5iKGl816Bvl95Y1+05Nmsa5A22vn6+QLq44OC/av
	mggOpIH2/avhHyT1+xzbnR58gA1b7XoWgsbtocODVQTNhB+0wYf9VyTPM8A41GgLZ5t4bq
	Y7Cd9e8JFK5AD4aMSrGP8yz6Xp7DpeDz7i8KQdHg5RNahP/caaiOW4aB7ElRolz1Ir2Sxe
	+puGZu1XqOOmIOzkpppJzZfHGNC2QM7Jac5cHnosNtxaDwcgYRsK2SVgt4aaIw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1762848115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dx+P3tmh8RRhlJbEuybtXJQuyEPuClVVZRpIZ0Mh1q8=;
	b=iUqoMMo0MCvnlPoaGp1XbX6sIHxU35Loi+T+vRoqwekh2f53jfWu9cCkH5+W+iunP1eY2N
	T/1+j18ur9A+p5Cw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>,
	Clark Williams <clrkwllms@kernel.org>,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 0/4] memcg: cleanup the memcg stats interfaces
Message-ID: <20251111080153.eo8vtb4P@linutronix.de>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <aRKKfdN3B68wxFvN@hyeyoo>
 <24969292-7543-456f-8b80-09c4521507e2@linux.dev>
 <gsew67sciieqxbcczp5mzx4lj6pvvclfrxn6or3pzjqmj7eeic@7bxuwqgnqaum>
 <99429fb8-dcec-43e7-a23b-bee54b8ed6e6@linux.dev>
 <aRKn4kqHx9m9lWfu@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aRKn4kqHx9m9lWfu@hyeyoo>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 969A62000A
X-Stat-Signature: a9tyxihrzyxi3swci9bsu61fhdjuymyp
X-HE-Tag: 1762848117-650672
X-HE-Meta: U2FsdGVkX1/aXjwpn0yKys7ifY0hq37eMlTwTKpGwAHmcMZGpDdCcisewAJKz0BOZsCja7ocUU9WClq2LJEV8AYlfbTnaP+FwQrcuiQmLV8SXlgPB6FLQLyqNRpZN7VCnKcKrZvLm/39uPynoFTQ0IROsLrUWJrr/v7bEYLhTw+qLSSQyflSf+8c+Bgd1IUvkxenjiV6GinMeUadwGUlEjJTJC+Tnsru6liYqi+eQqICQlnwBdcvvlMTyOqTD9WXun7dWGxRsZ9Me6ARt0hnyKANNhTrJPQlR7As+Nml56tXuslzNGEy0yCFohnp0dKOHY4oQdyarASnzQUrRvEvAuos3LSgoAEC76ktMYWCydLj/dMYKjseyVZyCGjeLtaFhSVqBK7Ie3DbbPE1wiD5JL+fi1VYGPLXXagiT4z9cAIXM9wQLH9UA1URtZ8Yge2L81X+cnWHAU/Ad6wHCacz/MoTvX7bO8jHT1jX+2eXbAya2ouGet0HQ4ayJSNkONX/AbhibSFO0iSlGRLFwglPE7bRB+6Zn/qYIVeHYignrCmQKvyqfqCSt5GsX32iaavoO313eVUobPhwfTs70OtInIHehnr2UxLECBhnsSU4iN7YHOnHGVMRbA8bf5BbjVdGqrjblwKIVh7NO2/x9flAc3g+rjb86au2Dvi7udjV35mqvB4OxWQ4pk26+317XYeOkGiOBQ6Pfooo2nl8IRQ7q8RtrWSNCR+/xjwKq55Tr5ivTGn1vdQe52qyXSasu9C4cCAY0qmbZ6vzEpyDDEPH6DvS/DEjnUpFYp1PSOCkK3OhBWoRe91ecgW2SxPaaswgYp49AQdccrJbUFWoBhtHHLgK9jWlD/zkOny08gVjTMBflG9SFrPup3bdzZi+d/NKDASwu8g8S7XrC9Q3vnTIG8GHMuLnHklHoUfP9ol6NzoTeA8IhE8wZspX4gJgMD9BgLdrPW6y6FJj9fSvXtR
 LV1DZNCm
 T7YQx0x1lTl1y3eNr+KS0iQDwhUZ+2D2jOmqNzjW8jRAaS0emNK64be6KLSWojkjgNbJlRWRMWaybohIN56zKLS0GvWvX+eqZeKC7wp9lzWIwfYdEj7nA6AJ3R2s/hbdYpV0eagfDbBIdW4NrDtnPx5ytqikoxM1hmmlPpep8qmE1XtGbbiLakw/0JWDh6aWnI4yS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > I mean converting these places to use spin_lock() instead of
> > spin_lock_irq().
> 
> Just one thing I noticed while looking at __folio_migrate_mapping()...
> 
> - xas_lock_irq() -> xas_unlock() -> local_irq_enable()
> - swap_cluster_get_and_lock_irq() -> swap_cluster_unlock() -> local_irq_enable()
> 
> is wrong because spin_lock_irq() doesn't disable IRQ on PREEMPT_RT.
> 
> Not 100% sure if it would be benign or lead to actual bugs that need
> to be fixed in -stable kernels.
> 
> Cc'ing RT folks again :)

The tail in __folio_migrate_mapping() after xas_unlock()/
swap_cluster_unlock(), is limited to __mod_lruvec_state() based stats
updates. There is a preempt_disable_nested() in __mod_zone_page_state()
to ensure that the update happens on the same CPU and is not preempted.
On PREEMPT_RT there should be no in-IRQ updates of these counters.
The IRQ enable at the end does nothing. There might be CPU migration
between the individual stats updates.
If it remains like this, it is fine. Please don't advertise ;)

Sebastian

