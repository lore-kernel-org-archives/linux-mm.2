Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EF57C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 23:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F9E26B008A; Mon,  7 Sep 2026 19:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35C7C6B008C; Mon,  7 Sep 2026 19:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224986B0092; Mon,  7 Sep 2026 19:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E17D66B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 19:21:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68C8BA0328
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:21:52 +0000 (UTC)
X-FDA: 85188540864.17.26F0D07
Received: from mta0.migadu.com (out-246.mta0.migadu.com [91.218.175.246])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3714340004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:21:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Y/rhkCAh";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.246 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788823310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YhS5/iltLCsUk9UyOE5mjgLEpIQqIyrXmlZ3pPD2P94=;
	b=kUT7EchThVqwxMZm4paM7g5tS279f4erXnoFhbBqOZu2egvEKSAGzNSqYwfpa5WVKADeLB
	roKxuKqSzK8Vj/yOTlnfCkG9fBWC1VZUYJuhcCkCyl0L4y+jD8CTfa6oOx6FoK4pV1Cgwk
	3A/DipGP9qVvSC7VFWcI848Fh5kfhiU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788823310;
	b=xbcRQHECb+0xKYzFPFE8zrJfQSUF6okbfNGfrKJHxGlNcMoAwJpC49xQAkIPvuAg0gOZDB
	Hv+CS/dRY7xT8cxBoKsbTLvrFp2Krcvi+B39Uldiw7C8oRgLlHSJ5xz++EiqH2hTsQbtsf
	F0g5RqqFGyGBEdZVo9M785DV1Yo+7T4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Y/rhkCAh";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.246 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dXcyzj0cv0sTbjRRKi4cwX3Cv6d/R9jjW33EzUucGLY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788823308; v=1; x=1789428108;
 b=Y/rhkCAhBv76xCHNrIdIxvdCtXjAHHV0qQLPjk3jZO1BCcRA601TjKHJK0jSu0wIUwF1px1d
 6NdTKUM9XbUEFI6OMZ9NzKXfARw6wWPiEcKUFOnt34MEejgi7AfJ+1g8HlstzxBHbkR08sHMANP
 nyEXFAUwcfJgNwJGTJblv+mo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id dc786c64e4031727;
	Mon, 07 Sep 2026 23:21:38 +0000
X-Mizu-Trace-ID: dc786c64e4031727
X-Migadu-Flow: FLOW_OUT
Date: Mon, 7 Sep 2026 16:21:33 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	dev@lankhorst.se, mripard@kernel.org, nat@pixelcluster.dev, tj@kernel.org, 
	mkoutny@suse.com, osalvador@suse.de, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, kernel-team@meta.com
Subject: Re: [PATCH v5 4/7] mm/page_counter: use stock in
 page_counter_try_charge
Message-ID: <ap86vDv143VHvrzh@linux.dev>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
 <20260831163752.2193337-5-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831163752.2193337-5-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3714340004
X-Stat-Signature: scnsjqpbk5bmazpzks7fk1zi13dtw1b1
X-Rspam-User: 
X-HE-Tag: 1788823309-592894
X-HE-Meta: U2FsdGVkX19FAgBbWIVpuN9yajPuuQvr3ta+5MUYpiwmGGLh8/aM5gQIN7cdXKOx/DfiPzVoSSX+HGjbnlKOr1x1JA6sm3Xd1PrcANqxkqIADf8hktF0TZNnsRGb5utwKDnOoJtAo4oZA1H/I4gZlSHMftVaXR+TjaMWBmvhl0CruotxO5O0gboFSKtztWutYbNPsoefasgr+UPjkoIpFF445uLoLjoKu4WmgoiJRNJtMWWNZrgXXLL+PFhivvry8doOm8CENr9FZH7kp2bYNthbS3a2hHXtSj1OCX0Qgh1YRlQ4QJFFYD6eIHrL7OhAvjolMcf911uJa1mk7XqTVqo0Cv/opyeaiYkhDe6/thtu6FkGyAcnf1sP9MR3JvMwON5hA2vo9Fqa0ZI8exUBzG+wsdSmDHl0IuF3tyZ6UdthP2FMWuQHIUkQleV8YjJslyj7jjMYTRHiXr5QP2N41RWvC8wmx3TSL4mwxPW6uTeT2jIAAxid71LVCPX6R0yefwKTf1iecOvJceh8ZiHf7l9TrBzftnYOnU+YV0H9FLebWELGh09i/WSEEgr5fUx04FJyff7p9qSd9iF48bMnkAkXdF3EYGVzj2sn7CtW1Ot6M4+6L4393lne+e4/LE0yogysaxoQjis1UnUQtVCTRgpmHsvBI/ZaEDJpkj/fKhkHDRIy63BCxvYau5jXwMBT80Doyb97GpoioDPc42xE1rmV3FF4SHcwDGPVbyCVBQeB7SwmuOniYbRMo1RE4ZJE1kos+705IiK5xhF9NypJvD4E7dzw1IyHdLmlO2erSvVVQzh/emIqAMIjeg7+grZp0UkithQslDCjAjVjfNGYDLlmvnA1dNHE3ZwSg78E3XWpzBo9Z5zJKeb+qjl6X1EYxIN7MwYT1hacAU9OZrjJ1DYC4tpDpz09pTIqbAKygtEzoN0Mi0T5+dGFEOg8uXX2i/zRxVv+AOoCjRtcron
 GDYMxP5d
 QGhoQ+qzEOrFqSzZ0bEBwMbKkMWKDlRejEDPiJsoJ+dRW9NjvLFeEUwQEoSFAXyy5t1/G/pcea6EPUOQeyXVEINdRU3v2bNo41Mp1qzqEQyGFqaf9u89aPZ+DrM8WbyXNPEhVQiW9jqAifk16Un1lzZUGa77By3lKZ+tFAIC6ztSq04+uURLrnvILlagHGkhVmhba5wAUYLDcJrfoVbNnmW+rajboqDBabpMJDXltuA4r9dVY49QwS3aPquU36r/ImMC1/erdMyzCNb5JevOlrk9Mgl5pvaHTLD899I11NsNN3DeMvVq9qevx4jdEBhVPEnc0fSVpGniMsatOci7WHSgLkc115CDE8K95+Ll9PPJATu10v+XPFOIlTHsGEn9ILKvsLfuNLABu7h0ZOgitKRa2wlSBGx7lVcCbMYE9bmatn/KasE6BSVjGL0i/r3nH8GErCxULXhNg/hZdaBV6Z7I2nJCn9o4gKb+4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 09:37:48AM -0700, Joshua Hahn wrote:
> Transparently make page_counter_try_charge attempt to service the charge
> from its stock. We preserve the same semantics as the existing stock
> management in try_charge_memcg:
> 
> 1. Limit-check against the stock. If there is enough, then skip the
>    hierarchy walk and charge to the stock.
> 2. Greedily attempt to fulfill the charge request and refill the stock
>    simultaneously to the hierarchy.
> 3. If this fails, retry the stock and charge without trying to refill
>    the stock, i.e. with the number of pages requested.
> 4. If the greedy attempt succeeds, return excess pages to the stock.
> 
> page_counter_refill_stock() falls back to a hierarchical uncharge when
> there is no stock, in NMI contexts, on lock contention, or for a refill
> larger than the batch.
> 
> The greedy charge is also skipped in NMI where both stock helpers bail
> out since the batch charge would be undone again.
> 
> No functional change intended, since no page_counter enables stock yet
> and counter->batch is left at 0.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  include/linux/page_counter.h |   2 +
>  mm/page_counter.c            | 135 +++++++++++++++++++++++++++++++----
>  2 files changed, 125 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> index c1fe331f34e7e..428ca8e7b2da5 100644
> --- a/include/linux/page_counter.h
> +++ b/include/linux/page_counter.h
> @@ -82,6 +82,8 @@ static inline unsigned long page_counter_read(struct page_counter *counter)
>  
>  void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
>  void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
> +unsigned long page_counter_refill_stock(struct page_counter *counter,
> +					unsigned long overage);
>  bool page_counter_try_charge(struct page_counter *counter,
>  			     unsigned long nr_pages, struct page_counter **fail,
>  			     unsigned long *nr_charged);
> diff --git a/mm/page_counter.c b/mm/page_counter.c
> index 3f61eba695518..a76949abf04e7 100644
> --- a/mm/page_counter.c
> +++ b/mm/page_counter.c
> @@ -113,25 +113,126 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
>  	}
>  }
>  
> +static bool page_counter_consume_stock(struct page_counter *counter,
> +				       unsigned long nr_pages)
> +{
> +	struct page_counter_stock __percpu *stock = READ_ONCE(counter->stock);
> +	struct page_counter_stock *pcp_stock;
> +	unsigned long flags;
> +	bool charged = false;
> +
> +	if (!stock || nr_pages > counter->batch)
> +		return false;
> +
> +	/* raw_spin_trylock isn't enough to protect against nested NMI in UP */

I don't understand what this comment is trying to say. The nested NMI is
confusing.

> +	if (in_nmi())
> +		return false;

You are completely disabling stocks for memcg charges in nmi context. Why? I
assume that is what the comment above trying to explain but it is failing.

IIUC you want to use spin_lock instead of local_trylock because you want to
support draining from remote cpus and spin_lock on UP are simply disable irq and
does not protect from NMI. Maybe you need spin_trylock similar to local_trylock.
Not saying you to implement that but please explain stuff clearly.

> +
> +	/* It's OK to migrate here, since stock is fungible within a counter. */
> +	pcp_stock = raw_cpu_ptr(stock);

migrate between cpus? Why? What are you gaining by allowing that?

> +
> +	if (!raw_spin_trylock_irqsave(&pcp_stock->lock, flags))

Why do you need to disable irqs?

Anyways, you are changing the fast path of the charge drastically. Previously
there was no atomic ops and not irq toggling but this patch is adding atomic op
and irq toggle (not sure about why irq toggle is needed) on the fast path.

I understand that remote draining is the only reason you need to use spin locks
here otherwise you will need to allocate work_struct in page_counter_stock. You
are making these design decisions very silently and implicitly.

How about we decouple the decision of remote drain / spin lock from moving stock
inside page counter? First move the stock to page counter without any spin lock
or remote drain and later in the series you convert to spin lock plus remote
draining with performance numbers.


