Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B71A5CD98F0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 21:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 000118E0009; Thu, 13 Nov 2025 16:54:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF3F28E0002; Thu, 13 Nov 2025 16:54:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2FED8E0009; Thu, 13 Nov 2025 16:54:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D1EB08E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:54:19 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 64A1B138E6D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 21:54:19 +0000 (UTC)
X-FDA: 84106937838.21.E3A58FC
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf15.hostedemail.com (Postfix) with ESMTP id 87820A0006
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 21:54:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D6KMKAFn;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763070857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kiz+P4KoRR6ufskB37zeO1ETp3EAe+922ChTRKXxN74=;
	b=uLeKQoNFVBdFhBpGJv4uAXZSSAhvpWAIGGgpMssYlE9fk5FiUF58Z1Soa8FbvYRu+sb6hx
	L4jgE/Cbzs/xYYNgwf7XFaVhFyFDrTgizu72r06MTSmmZim48vyYcl4mrCIrInLkpxS0AB
	7cfeYAtPabufybDzmnFRblp18fh8W+g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D6KMKAFn;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763070857; a=rsa-sha256;
	cv=none;
	b=J3K6BqdQrSiBuEyoU5eFGlMa/lJUltzUsxthTZMeJNA1VfBAYmrHC5Q3snhUyBZ1+/MV2V
	nyw9ZOZIP8K6gPLFB9KdEDnSoYGkhJeGcJdd+dPlgGuAWnjmlxTKOShesAemjFTI6YxXSm
	ZhldzMXOvipMI4snNAxadkL94rudxII=
Date: Thu, 13 Nov 2025 13:54:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763070855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kiz+P4KoRR6ufskB37zeO1ETp3EAe+922ChTRKXxN74=;
	b=D6KMKAFnhdOuctgrlWsqFPmC1nHzSBU4Y8FjytaHX982niEl14tOHlsQUznR6dXGgTmyBE
	uEG4lUy5HO4Jd5CfGiNaIqaOurNRgsR6yKp65jpIkFWE9jl8qB6AhgDor2G6Wa46lxkaXr
	XfcagihPx5of3JnZnSRh4zsrzdrkDOs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org
Subject: Re: [PATCH v4 14/16] memcg: Convert mem_cgroup_from_obj_folio() to
 mem_cgroup_from_obj_slab()
Message-ID: <72bs7m3juclmj6beuakzkoka2n5vej22qnrxnzsumqfkyfkk2r@gfoxlh4innwk>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-15-willy@infradead.org>
 <20251113161424.GB3465062@cmpxchg.org>
 <45ea66a3-bf8b-4c12-89cd-d15ba26763fa@suse.cz>
 <offnmou66hzgrlbb7owyya6n4onn2g5iuv7matbqfvsigg6wv3@3hlu55yai42z>
 <aRZArvnUeXZulhuX@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRZArvnUeXZulhuX@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 87820A0006
X-Stat-Signature: 8mg7y9rwtd6ghq5aw1t9sa1fwh9nhuzu
X-Rspam-User: 
X-HE-Tag: 1763070857-162471
X-HE-Meta: U2FsdGVkX1/DfJ4eX3vyBa3h/SAkFHCyg/szOW4wwUH7X40UEBA5Cu/hMmEnbbOF9JIXqbKweoPUM6XgCa2jclEIm1pOmwz+A5ChJF5sC1sNGvNW3gO6SWcno191YbIs0VdAFcBbZSmVTGutiEGpNUu+Ntl2qxIn/14eODhvhCWswkjqL32yA612OMjXyYYdIRdj4aJHYQ6ZyWhN0jK+qKO7oRk4+kMfOg/0r7164a/q1kyA3fKSwULJg+PYRRgjOVprg7kg/VFIhUhdeM6T9uOhGKr6B/UT/dwgRlMVumVwwa1OY9miXqC6R7OM22y4dfFDFv/pI1N+0iWdvVGptQqUG20PwPXWwHVIjctQqX1ZkI5l9xJF7MUouHmCo/voq9mpUco3Wb8X+Tj7XTS3q4zmLCPq38mTkUHx5K6qxm8YGs/NCQOs+hIwW00joVxBkn5l00etFhg8XrdOjzNCS5a0bWoSAIc+0G1T+sQ2UONBpvm3aFSWrTwgODL1T+cTQ6dsEZ3hsiQim4lcqhLY05LSIfb5ZuQ7Q70oZm+CqzrstVVTL9UrD6z0QSF/XnmVzARYmh/Ftokx7Ha32pWWSoUawNQnbEKEVu2sXuZXuFdObWQdqaTk+6Ytj2cf41ZpaicgSC5WIvjwzC1YW7IXJvGXTUFd/Tep5UCQNUsSPdDjfxwjFGE9Puuk6/CXniCi+IdykfFczY9yH4JaPKM5n5XuyQDkpt1uzz6cyOvQvlRf8qgTovwoPRVPLObZzSUVh/UKpYkb7b9InJznNAJgj8uKcKv+75ZKjuE6ugyySntpEGlUeOLHpv0uMtFZw3eAJmeCa6FJwiAsb7AopbEcFIk/gJl6wXJD9HWVCb2Hv+tGtNNa5hRuWO4lzLhJowtAlIT48Pp7J0g5ToWXOWF8ntj4hApW1rpeozeOq5uFPP56qoEfzUkSEp3nGKE2vzxO+UBeZK1PrRQmqLircp2
 Bu/Uzamj
 7wMW4t8PXk99zjeRpdDpIZEvS/kHqF9zk4MicU/79aRZBdGaeDQEMOazvzcYJ7p4P6OFE8rGh/1Ah2hEO5WeKN1+9L8bqzEj+6i3HhtgFBtk6NK88lYeHFQ0qXos2SlOC4vBb5mYkZZZQSTXxwZTSR4WB4cAU/gXs63SX/Tvgh12U3Ud4YaSnHIsK3mh5iHdAnLWtIuw7kZ1qMj+1dej4lngQgSQDu+pybv8muCcImc/Sx6GKLqL6sENttk3CR5DtIyPV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 08:33:50PM +0000, Matthew Wilcox wrote:
> On Thu, Nov 13, 2025 at 11:42:01AM -0800, Shakeel Butt wrote:
> > On Thu, Nov 13, 2025 at 05:28:59PM +0100, Vlastimil Babka wrote:
> > > > E.g. !vmap kernel stack pages -> mod_lruvec_kmem_state -> mem_cgroup_from_obj_slab
> > > > 
> > > > How about:
> > > > 
> > > > 	if ((slab = virt_to_slap(p)))
> > > > 		return mem_cgroup_from_obj_slab(slab, p);
> > > > 	return folio_memcg_check(virt_to_folio(p), p);
> > > 
> > > page_memcg_check() maybe instead? we shouldn't get a tail page here, no?
> > 
> > Do you mean page_memcg_check(virt_to_page(p), p)? But virt_to_page(p)
> > can return tail page, right?
> 
> Only if it's legitimate to call mod_lruvec_kmem_state() with "a pointer
> to somewhere inside the object" rather than "a pointer to the object".
> 
> For example, it's legitimate to call copy_to_user() with a pointer
> somewhere inside the object, so the usercopy code has to handle that
> case.  But it's only legitimate to call kfree() with a pointer that's
> at the start of an object, so kfree() can cheerfully BUG_ON()
> PageTail(virt_to_page(p)).

Yes it makes sense. Though for slab objects we are allowing to pass any
address within the object (address of list_head for list_lru) to
mem_cgroup_from_slab_obj() (and thus mod_lruvec_kmem_state()) but for
normal kernel memory, if we use virt_to_page() then we will restrict to
the starting address. Anyways just noticed this pecularity, not
suggesting to do anything differently.

