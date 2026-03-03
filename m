Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36415EDA694
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 16:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6DB6B0089; Tue,  3 Mar 2026 11:26:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97E156B0098; Tue,  3 Mar 2026 11:26:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B4B26B009B; Tue,  3 Mar 2026 11:26:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9F66B0089
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:26:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C5A7139550
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:26:44 +0000 (UTC)
X-FDA: 84505280328.16.30AEFFF
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id C780B180018
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:26:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cTct34xt;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772555202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KWZ2Q88mCamuBtdqha7mUqDv9x9r6pDkpjHI+V+2Iuk=;
	b=0D8YioA5Q5BPftJyfeKO+GeUS/Y9xKYcXhi0SQwR04Z1XGfvg54F41eKZnKmcpKZoKegZV
	f8MLwyCEqWE90HuiQ5gdoZIClrl3jW4EW4eJ04EqIimvYQCn6o8OGd1QI7C27CvF+ejEtP
	akOkZQK8r9X+oXvZi1YOKrvn3yYcoiE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cTct34xt;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772555202; a=rsa-sha256;
	cv=none;
	b=6GRw3JwBqKpzMhn5MJiuXSd/HCG5sp4RKW6VzFASQhZVVsRqDqZBQqLVj9xAaRdz8dSBAK
	gM0ew7Nw5F05a1+FTXCNOmAWwhWg1zUX7cLTkHvPZ7M0Zf/IZPgpQY9qlQXdv6mXGvRGwB
	mtiYyGv/7i1f1C4II6qJ5812cEPP3dI=
Date: Tue, 3 Mar 2026 08:26:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772555199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KWZ2Q88mCamuBtdqha7mUqDv9x9r6pDkpjHI+V+2Iuk=;
	b=cTct34xtiw6UR8JCa5DZiQShjiTVn3S5vutC2R8hjpvh0fvfPB7sIcEkVQf5PVaPUOsDgw
	GqfOywqGUWr+JlDAE+MQRWf2kugQdKM6+VZtboockpUKIh1M73Pijxkld7/AO6m/7+azjf
	xB1dcAQPS3aOKgl2l9uuAU7qOxT+suc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mm: memcg: separate slab stat accounting from objcg
 charge cache
Message-ID: <aacLODh5BY45Zp9s@linux.dev>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-6-hannes@cmpxchg.org>
 <ji2jjt4vtmt2ox7wzytpivttc4z7j3u6cwmv23r6xit5322gns@te4t4djl5nlk>
 <541a6661-7bfe-4517-a32c-5839002c61e5@kernel.org>
 <aablae2eFl9ne5fW@linux.dev>
 <aacBoazC21TAi-Q2@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aacBoazC21TAi-Q2@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C780B180018
X-Rspamd-Server: rspam07
X-Stat-Signature: 38acm31eyaab63t87jjouhie4j3pztp7
X-Rspam-User: 
X-HE-Tag: 1772555201-271919
X-HE-Meta: U2FsdGVkX1+CXWRPw4E+EYw2AtLN3zs7BFK3iuW1mkWIxuMP2UO99HRL3cnWPMkW10CTFlWz9mGTodX0cOC0f4/gOQeNNNYNVTSZv2VhxSm8iqrpqLin4eVZfH+BxdqHonljeSo6+AM3quagQLcllo0u/zAP3jlg7lxT1DbdGo+ui9GUyLx9cBVjnyqB7oIUw72iBB4GPEHtyso/NYfCCm6ct0BKFibZtBWLODA348DbVUM1sQj3zC3wLapIjlO24544CnflUdNxYFoRQSKU5s35tRxhrWMh1o/qjUfd1gOgJnKLnQOn5xX+tm+l6zspImfn4PqZaycKOCt/HwDz9KctbDDDPkDHymaBm3Z82jiWloNl8Jsk7TNj6eIQBxlDs88DSxhgUcOnXZDVh5A8ywRlZ3AXtz6Nw7iYj4Gz56Jpn3rDbIl8pDeGcgstrK3bO0BCu9bKZEuCeBb5731S7iSiVLajqTIKnlax48wzkaB5HalYmhD5ZERiELdK2OK+9pwwauLb5Nl5njn1/H7FPB+uKiAnf/HI2k2t41sJ/RdnPfXFxohVaN/JYFRglpvAvwWATOXmS4/wWZziskuRWpUOChqVYCRNWhOZsNFyjrFUWPBVxTBrlCDv2FA2E7MZ3W/FRoZn2rH6K4F+KstoOFGTWUvaPCSfKEZm1k6SfTLxupqm4PPiGK9aUsi3H4EuWcFCfbCpbIPpoWbG4ZklAwNSoIUplF1XgdQa2A7LM0goqiuJnr2A6/J63SY2glzhWBWRC2ua7I0wyqnb0204prqmeTz1m0btcpUWcir7k126fMT0PWC+rHflT5lE1fzPYy2JjLFQRV7IY45Tb/XN1h2LEx0wXNrqsJ42Jr3UYVl5e5dYcRFhHuPRZbZYisTCSV3qmRGX8P/GVtqtgJ2WuzOZuJ9brVu9/qvb5nKq8HJtfDvdwaMqP0dfuIDsYlRyh4e1RUthLeYKAF5WNFf
 oM38UdVc
 iEp2GFjVWJZYvg0FyQAn4gOa3172G6xGSwn1doH7B7BKv22F3MwDob+O+JJR8CYBdP95sGwp92jqRgr2EXr+LuhD88dE9o68d7O6lVnnjRf6geXtq/IfxbC2q5t39O9CElmn1YLkSIkjQfjAvX4OeLQi3x4S5/acrTosOT6As2Y4qSxAairv4mcyIrGfar+AKWvUDGi+wD/p7yBOMn/mhvrJOnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 10:43:29AM -0500, Johannes Weiner wrote:
> On Tue, Mar 03, 2026 at 05:45:18AM -0800, Shakeel Butt wrote:
> > On Tue, Mar 03, 2026 at 11:42:31AM +0100, Vlastimil Babka (SUSE) wrote:
> > > On 3/3/26 09:54, Hao Li wrote:
> > > > On Mon, Mar 02, 2026 at 02:50:18PM -0500, Johannes Weiner wrote:
> > > >>  
> > > >> +static void refill_obj_stock(struct obj_cgroup *objcg,
> > > >> +			     unsigned int nr_bytes,
> > > >> +			     bool allow_uncharge)
> > > >> +{
> > > >> +	struct obj_stock_pcp *stock = trylock_stock();
> > > >> +	__refill_obj_stock(objcg, stock, nr_bytes, allow_uncharge);
> > > >> +	unlock_stock(stock);
> > > > 
> > > > Hi Johannes,
> > > > 
> > > > I noticed that after this patch, obj_cgroup_uncharge_pages() is now inside
> > > > the obj_stock.lock critical section. Since obj_cgroup_uncharge_pages() calls
> > > > refill_stock(), which seems non-trivial, this might increase the lock hold time.
> > > > In particular, could that lead to more failed trylocks for IRQ handlers on
> > > > non-RT kernel (or for tasks that preempt others on RT kernel)?
> 
> Good catch. I did ponder this, but forgot by the time I wrote the
> changelog.
> 
> > > Yes, it also seems a bit self-defeating? (at least in theory)
> > > 
> > > refill_obj_stock()
> > >   trylock_stock()
> > >   __refill_obj_stock()
> > >     obj_cgroup_uncharge_pages()
> > >       refill_stock()
> > >         local_trylock() -> nested, will fail
> > 
> > Not really as the local_locks are different i.e. memcg_stock.lock in
> > refill_stock() and obj_stock.lock in refill_obj_stock().
> 
> Right, refilling the *byte* stock could produce enough excess that we
> refill the *page* stock. Which in turn could produce enough excess
> that we drain that back to the page counters (shared atomics).
> 
> > However Hao's concern is valid and I think it can be easily fixed by
> > moving obj_cgroup_uncharge_pages() out of obj_stock.lock.
> 
> Note that we now have multiple callsites of __refill_obj_stock(). Do
> we care enough to move this to the caller?
> 
> There are a few other places with a similar pattern:
> 
> - drain_obj_stock(): calls memcg_uncharge() under the lock
> - drain_stock(): calls memcg_uncharge() under the lock
> - refill_stock(): still does full drain_stock()
> 
> All of these could be more intentional about only updating the per-cpu
> data under the lock and the page counters outside of it.
> 
> Given that IRQ allocations/frees are rare, nested ones even rarer, and
> the "slowpath" is a few extra atomics, I'm not sure it's worth the
> code complication. At least until proven otherwise.
> 
> What do you think?

Yes this makes sense. We already have at least one evidence (bug Hao fixed) that
these are very rare, so optimizing for such cases will just increase complexity
without real benefit.

