Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3594AD2FEF3
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 22:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8890A6B0005; Tue, 27 Jan 2026 17:04:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837246B0089; Tue, 27 Jan 2026 17:04:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C3986B008A; Tue, 27 Jan 2026 17:04:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 594576B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 17:04:58 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC1C358A30
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 22:04:57 +0000 (UTC)
X-FDA: 84379124634.20.525EC57
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7B78A1C000E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 22:04:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jwwlCpHX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qRYhtdXU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jwwlCpHX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qRYhtdXU;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769551495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UymD9quzWShDqRhhHiV4+B6IAQlknYB8RVGTscXzVK0=;
	b=YtU7oyWpOaTM616ET2Sj7ZIB8ugjGthjhsH5i5IZHvZBAUI8OgNudgcrxCuOZlRm1OVhyl
	wFxBD2hExuptiiyvCbPiXSYfpZ6ixWD7aBIZDkE2l3+1huA6ZG6l+VlSLTCLn5Uld9auOg
	w+EV7im+Tp5Q9uemUChNrUvZ/R0DOC8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jwwlCpHX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qRYhtdXU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jwwlCpHX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qRYhtdXU;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769551495; a=rsa-sha256;
	cv=none;
	b=iFUoocWUqNF2ISlULlMxMWhSENcIhUTWQ30G4CnvLUe4lS50p3SKdi4ZvdgZzI+CSEwQsZ
	cgBMwEC4Q68/APrfvU33KLhR5caGv5isFqjYL3UivDIvC1gYpZo7J+ktqTZyaO9zd3Onjb
	wYlo5osmXUh5g6QnRgwwKKG6rURr3ak=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 83A6133917;
	Tue, 27 Jan 2026 22:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769551493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UymD9quzWShDqRhhHiV4+B6IAQlknYB8RVGTscXzVK0=;
	b=jwwlCpHXqQvZ+xeE7q1WMNZx23iXgfToEMhs9vMC+zhHwOgkknhtoHOVX5aBe8RjP6aCtE
	djlkYIX/FYqLjbnkz/n870bp9ADNfHXTtSaB3qZj4G55p1eNabkEQ1lETfKUUe1fNpRlum
	5qjVtnMm8HdO41qKn/O9xz765T38FfA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769551493;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UymD9quzWShDqRhhHiV4+B6IAQlknYB8RVGTscXzVK0=;
	b=qRYhtdXUeVcMtk5qL9w+YPxMbAe8lE0NycJT0O/5x9v4erawUvhg5/fSvMLC2PTVQTHE4E
	Ht1xp224+E4FXjCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769551493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UymD9quzWShDqRhhHiV4+B6IAQlknYB8RVGTscXzVK0=;
	b=jwwlCpHXqQvZ+xeE7q1WMNZx23iXgfToEMhs9vMC+zhHwOgkknhtoHOVX5aBe8RjP6aCtE
	djlkYIX/FYqLjbnkz/n870bp9ADNfHXTtSaB3qZj4G55p1eNabkEQ1lETfKUUe1fNpRlum
	5qjVtnMm8HdO41qKn/O9xz765T38FfA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769551493;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UymD9quzWShDqRhhHiV4+B6IAQlknYB8RVGTscXzVK0=;
	b=qRYhtdXUeVcMtk5qL9w+YPxMbAe8lE0NycJT0O/5x9v4erawUvhg5/fSvMLC2PTVQTHE4E
	Ht1xp224+E4FXjCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 526383EA61;
	Tue, 27 Jan 2026 22:04:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id n56cE4U2eWnjcQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 27 Jan 2026 22:04:53 +0000
Message-ID: <85d872a3-8192-4668-b5c4-c81ffadc74da@suse.cz>
Date: Tue, 27 Jan 2026 23:04:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 18/22] slab: refill sheaves from all nodes
Content-Language: en-US
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-18-041323d506f7@suse.cz>
 <cburjqy3r73ojiaathpxwayvq7up263m3lvrikicrkkybdj2iz@vefohvamiqr4>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <cburjqy3r73ojiaathpxwayvq7up263m3lvrikicrkkybdj2iz@vefohvamiqr4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7B78A1C000E
X-Stat-Signature: reim8ss3dw6kbfdfikgnix68ocgidotf
X-Rspam-User: 
X-HE-Tag: 1769551495-844299
X-HE-Meta: U2FsdGVkX1+W8HVcycsX74JjH+N1uXWPB+G/eLpVrMrQEuXVw9LMzmoWCVZGoDiQYZUWoOqsdORzX6Se5gr5BTg7QQa0GBBdgfMVS7XURm8GeR4kkTQxq51Xbht6qb7N+SrdglVQmETbaiXNkkZvzUxn9Q1gmOEA1t7v7y+gicojOKxGh0S4nYkpW8N3ujw1bPziV632qy1C6GvU90GII5tdMknwnfFmEipSymbWhdW6Q2CR2v9loLkuZr8m0quCzVL19baLVkrrVabh5ySeAjT5WP0mUoDntBFdrPhI6BVDTmBhaWpH0KhDQ+6u4pwhPnVzrAD5B//hZ5hR4n29OaC8dCG3gyKEDbzlTtW4IuKjEfwfKJOZ024d7dNHraFUuCVkF8zbXI47lbBS0c0gfBncvsGYzovFlvzns0mkudShBMfvEj91WLOe2Uvu21Dn9hpsdit6b37oLF/68FQ0JbKy+EqzxA/kRAhzOoeWvqkd7k+kd9SAG7lKExPHNq1HhdDNV9+r4X9b6TjI+2Y/Qsgn+33ZODmSyQ0xu1rBQXrYEn8ZHneaOL4kD/2O3K25E5ZrnOIAdhKnx7acHRILtPVfUAJG0DWOM8Jk1AxHf6PC/iepp131d5vbRhIiO/T4dlxTPOCjLGlYEDSEmH5osihxRqYhXU6M7IC0aCcfugRfLf5bk1Y0RCFukYbhA5VxCoFEGL9TTsd+cJhFVXFpICgWX33OazMuJFommmqotd8HfVdvkm8V9RBPOEQvpdCew98V/TnIm3M74xr8bQiZxUuHwEjeXW+gWyUIjjCOIZeFfJnEXI7zxVhB2a+59BhUqgMg96qsIr1p1MD00jfGE8ubT2lHMvxMirZ2MMMdpAjQWoE3zj/uJxezPiYddsG1YgJGYAvfYTs35kCITDRe7/IoLGsENOn/gynVxWwX7s0wCosjCA6y8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/27/26 15:28, Mateusz Guzik wrote:
> On Fri, Jan 23, 2026 at 07:52:56AM +0100, Vlastimil Babka wrote:
>> __refill_objects() currently only attempts to get partial slabs from the
>> local node and then allocates new slab(s). Expand it to trying also
>> other nodes while observing the remote node defrag ratio, similarly to
>> get_any_partial().
>> 
>> This will prevent allocating new slabs on a node while other nodes have
>> many free slabs. It does mean sheaves will contain non-local objects in
>> that case. Allocations that care about specific node will still be
>> served appropriately, but might get a slowpath allocation.
> 
> While I can agree pulling memory from other nodes is necessary in some
> cases, I believe the patch as proposed is way too agressive and the
> commit message does not justify it.

OK it's not elaborated on much, but "similarly to get_any_partial()" means
we try to behave similarly to how this was handled before sheaves, where the
very same decisions were used to obtain cpu (partial) slabs from the remote
node.

The reason is that the bots can then hopefully compare before/after sheaves
based on the real differences between those caching approaches, and not such
subtle side-effects as different numa tradeoffs.

But for bisecting performance regressions, it seems it was a mistake that I
did this part as a standalone patch and not immediately as part of patch 10
- because it was already doing too much.

> Interestingly there were already reports concerning this, for example:
> https://lore.kernel.org/oe-lkp/202601132136.77efd6d7-lkp@intel.com/T/#u
> 
> quoting:
> * [vbabka:b4/sheaves-for-all-rebased] [slab]  aa8fdb9e25: will-it-scale.per_process_ops 46.5% regression

And that's the problem as it's showing before/after this commit only. But it
should also mean that patch 10 could have improved things by effectively
removing the remote numa refill aspect temporarily. Maybe it was too noisy
for a benefit report. It would be interesting to see the before/after whole
series.

> The system at hand has merely 2 nodes and it already got:
> 
>          %stddev     %change         %stddev
>              \          |                \  
>       7274 ± 13%     -27.0%       5310 ± 16%  perf-c2c.DRAM.local
>       1458 ± 14%    +272.3%       5431 ± 10%  perf-c2c.DRAM.remote
>      77502 ±  9%     -58.6%      32066 ± 11%  perf-c2c.HITM.local
>     150.83 ± 12%   +2150.3%       3394 ± 12%  perf-c2c.HITM.remote
>      77653 ±  9%     -54.3%      35460 ± 10%  perf-c2c.HITM.total
> 
> As in a significant increase in traffic.

I however doubt the regression would be so severe if this was only about "we
allocated more remote objects so we are now accessing them more slower". But
more on that later.

> Things have to be way worse on systems with 4 and more nodes.
> 
> This is not a microbenchmark-specific problem either -- any cache miss
> on memory allocated like that induces interconnect traffic. That's a
> real slowdown in real workloads.

Sure, but that bad?

> Admittedly I don't know what the policy is at the moment, it may be
> things already suck.

As I was saying, basically the same as before sheaves, just via different
caching mechanism.
BTW there's a tunable for this -
/sys/kernel/slab/xx/remote_node_defrag_ratio

> A basic test for sanity is this: suppose you have a process whose all
> threads are bound to one node. absent memory shortage in the local
> node and allocations which somehow explicitly request a different node,
> is it going to get local memory from kmalloc et al?

All memory local? Not guaranteed.

> To my understanding with the patch at hand the answer is no.

Which is not a new thing.

> Then not only this particular process is penalized for its lifetime, but
> everything else is penalized on top -- even ignoring straight up penalty
> for interconnect traffic, there is only so much it can handle to begin
> with.
> 
> Readily usable slabs in other nodes should be of no significance as long
> as there are enough resources locally.

Note that in general this approach can easily bite us in the end, as when
there are no more enough resources locally, it might be too late. Not
completely fitting example, but see

https://lore.kernel.org/all/20251219-costly-noretry-thisnode-fix-v1-1-e1085a4a0c34@suse.cz/
 
> If you are looking to reduce total memory usage, I would instead check
> how things work out for resuing the same backing pages for differently
> sizes objects (I mean is it even implemented?) and would investigate if

This would be too complex and contrary to the basic slab design.

> additional kmalloc slab sizes would help -- there are power-of-2 jumps
> all the way to 8k. Chances are decent sizes like 384 and 768 bytes would
> in fact drop real memory requirement.
I don't think it's about trading off minimizing memory requirements
elsewhere to allow excessive per-node waste here. Sure we can tune the
decisions here to only go for remote nodes when the amount of slabs there is
more out of balance than currently, etc. But we should not eliminate it
completely.

> iow, I think this patch should be dropped at least for the time being

Because it's not introducing new behavior, I think it shouldn't.

However I think I found a possible improvement that should not be a tradeoff
but a reasonable win. Because I noticed in the profiles also:

     54.93           +17.5       72.46        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath

And part of it is likely due to contending on the list_lock due to the
remote refills. So we could make those trylock only and see if it helps.


----8<----

From 5ac96a0bde0c3ea5cecfb4e478e49c9f6deb9c19 Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Tue, 27 Jan 2026 22:40:26 +0100
Subject: [PATCH] slub: avoid list_lock contention from __refill_objects_any()

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7d7e1ae1922f..3458dfbab85d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3378,7 +3378,8 @@ static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags);
 
 static bool get_partial_node_bulk(struct kmem_cache *s,
 				  struct kmem_cache_node *n,
-				  struct partial_bulk_context *pc)
+				  struct partial_bulk_context *pc,
+				  bool allow_spin)
 {
 	struct slab *slab, *slab2;
 	unsigned int total_free = 0;
@@ -3390,7 +3391,10 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
 
 	INIT_LIST_HEAD(&pc->slabs);
 
-	spin_lock_irqsave(&n->list_lock, flags);
+	if (allow_spin)
+		spin_lock_irqsave(&n->list_lock, flags);
+	else if (!spin_trylock_irqsave(&n->list_lock, flags))
+		return false;
 
 	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
 		struct freelist_counters flc;
@@ -6544,7 +6548,8 @@ EXPORT_SYMBOL(kmem_cache_free_bulk);
 
 static unsigned int
 __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
-		      unsigned int max, struct kmem_cache_node *n)
+		      unsigned int max, struct kmem_cache_node *n,
+		      bool allow_spin)
 {
 	struct partial_bulk_context pc;
 	struct slab *slab, *slab2;
@@ -6556,7 +6561,7 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 	pc.min_objects = min;
 	pc.max_objects = max;
 
-	if (!get_partial_node_bulk(s, n, &pc))
+	if (!get_partial_node_bulk(s, n, &pc, allow_spin))
 		return 0;
 
 	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
@@ -6650,7 +6655,8 @@ __refill_objects_any(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min
 					n->nr_partial <= s->min_partial)
 				continue;
 
-			r = __refill_objects_node(s, p, gfp, min, max, n);
+			r = __refill_objects_node(s, p, gfp, min, max, n,
+						  /* allow_spin = */ false);
 			refilled += r;
 
 			if (r >= min) {
@@ -6691,7 +6697,8 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 		return 0;
 
 	refilled = __refill_objects_node(s, p, gfp, min, max,
-					 get_node(s, local_node));
+					 get_node(s, local_node),
+					 /* allow_spin = */ true);
 	if (refilled >= min)
 		return refilled;
 
-- 
2.52.0






