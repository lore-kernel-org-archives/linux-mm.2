Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F500606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AnSddiiG
Received: by kanga.kvack.org (Postfix)
	id 357CB6B02E9; Thu, 22 Oct 2026 18:52:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E1AE6B02EA; Thu, 22 Oct 2026 18:52:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AA346B02ED; Thu, 22 Oct 2026 18:52:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E87DB6B02E9
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:52:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0EA9FA025B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:52:58 +0000 (UTC)
X-FDA: 85351764036.11.4BBCAAB
Received: from mta0.migadu.com (out-2.mta0.migadu.com [91.218.175.2])
	by imf20.hostedemail.com (Postfix) with ESMTP id E58AB1C0004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:52:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AnSddiiG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.2 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792709576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eFP7exUez9GGOtJ+smGmBVLg4Y3+zmrZrmNma5qSW4w=;
	b=kWH0gjXGSRnQOLbaljv0lQD7ZPR1cHmWZQ9z1NWcxo/jZRYL+6zD2dS0HH8nWr/SCmep6E
	mqamIeHnaR0iSKIzwX6YGPyZ3dbHzhFMtiqOf2PYJXQfnlxCbKkYdlIhD2WRY1cotpRH2J
	OpO4yTWxDaAx2Pk04+j9V9O2snz0Wdo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AnSddiiG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.2 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792709576;
	b=4tY1ffNalYG241m6s/8Rymp4pPApzNlE4U3Iu7YqvhDg7WKkIPxDXiMgRaRD1kpV4di9l2
	sAE/j+4YFDUGHIJZBKDo58N+NvQ1TGg1YAy2oiqnS8NVnww8wQHJkaB4F3CWwJtLLKSuxN
	9A5QuSbeqRHs+8lzd3cz40t3qUQOup0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VuEHBkjmYNYLgKZ9YnKdlHZbNCNfQZmriQK22FO6a38=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792709574; v=1; x=1793314374;
 b=AnSddiiGBk015l6rIxyItypoyRc8nAMVaqeECu3YHpxKsNIhRQGvrx7fCVtbO4kKu0KsB8Mo
 nE63PIboSlE/dw/JzD97LKOzqOOhQKG2M9AwcIkxFBsQxN539l+RRdD0j3Dfj5xNWDiblZZ/60T
 EsQ6AhnpIL1n8Os1jXSPxaZQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3f89389d0b74c4ae;
	Thu, 22 Oct 2026 22:52:54 +0000
X-Mizu-Trace-ID: 3f89389d0b74c4ae
X-Migadu-Flow: FLOW_OUT
Date: Thu, 22 Oct 2026 15:52:53 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/2] memcg: don't go through the lruvec for folio and
 kmem lruvec stat updates
Message-ID: <atqTqvZRVHk0IVQV@linux.dev>
References: <20261022223930.138779-1-joannelkoong@gmail.com>
 <20261022223930.138779-3-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022223930.138779-3-joannelkoong@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E58AB1C0004
X-Stat-Signature: ruqsnqgjw6jrzb58dtp79qtpoowriu4n
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792709575-38810
X-HE-Meta: U2FsdGVkX18MhRx4v8N/HxziZRZwebZI5KEIfxUkx+qgA6bs0v2ulXvFDLiqARWxZl5vai8VenXpPUoNdhWSzs3UZbwkyrUuu8UxedF0yvDJDHvNOChu98uEPrMmFxPzAISNsZWrO7O4OAz6xa9flpwx9jlRv3MhrbnLzQ4pUqo8SZotZ3l42XKJEhkCW/c4yjbJhOVxmEAQF6c3max/mXy7K1vH9hmGjvoxgKFVAbpewKY/39CVVjpNj+SrFSWfQKujUjXIFl1GtiAoeZ8aE+hwX6De5R/fP8AcR3RUD4wc1m3TjsEZTnozeU5OWxsDXf90moc0HCToIZJ7Nrha2gNc3dawx/WaZaK/f5lbjh9LCZPKVwI4aR826dTyLbpai7stn8DMzILu7wXxbdmoFp72ZXUn4ibURziTXX3J+zUy2PC7+UKLGlboLQFk8I1Q6+C940ph+Dwd6ONtlUdOqpLpeXexpXRdQ9dQlQHKoqvS/esMDs5yvzD8UdePmXNi1H0wBjry7a5owNe7+6L1sVe3a7DWM50BiGme+aZerILRaQMRHygeqr0bTtuyWAbh1cekg+BVlUHV7RnGv56ZO8bOwrf/TAGFn1QmAkR4vBimyZZA9jT+MAp8FAWciGGX+Ty8AFKOQdoi2xvllvJp19DS6X3Pdvq5yDkD4T4Z0NsEodFYPWEUH1V0aDyiO9Ee/AKqaAYOaoPojr4PjaJ3d1O1EVMr2EkJN0AXoDnWF7gZsAtKFvoR1LKu4Od+00ZxbKTSgEB5vvrOTaUNS8N7ts789BdvuvHt3govxpUbkW9lHSmGNKybx6EUxY04mvWZFq60zE2T/ZdcdbXZAWxTRYYPv2il+i39JGSp3CU2vE/H0ovDpX3hzi81q7NmbiO88MVwGniHdqgfJXPC38q2ilYxQBRK40EOkZstQwpiokS/lKtZTiFZlNEEDkwD54x+KM82b4IcTgDQoVS/3al
 ePDXFgkF
 KOOWpEsIqTmqyMsyISbt+dVj/n9U4zD+hZR29A9OXlnZYOTaX4vyL2SJ3E5HFyLMHaHFKzzKLbDRH9p8oVHHOZfwyosbBpesWJ/pH36DiqN9Rd3TuZHPVKVOPDReKhtwfoBe468IfvbD2Gbqb01wfpRTuRZmggSiba+B4sudFN3qPFstaiNahQtBmeZFjaT6arRjAu1DC0eZm/73jzalSVWtQbYKvXGMiQ2oy3P2pPkXey71kAbthiNgBJhFtWQG4vTR2jYHWj6XrrVz3HSbHZsqwiUkZo7wLN3YT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 03:39:30PM -0700, Joanne Koong wrote:
> lruvec_stat_mod_folio() and mod_lruvec_kmem_state() already know the memcg
> and the node, but look up the lruvec with mem_cgroup_lruvec() and update
> the stats through mod_lruvec_state(), which reads lruvec->pgdat and
> mem_cgroup_per_node->memcg to get them back. lruvec->pgdat shares a
> 128-byte cacheline pair with lines that the lru_lock holder writes
> constantly (lru_lock or lru_zone_size[], depending on the alignment of
> struct mem_cgroup_per_node), so on CPUs that do spatial prefetching
> these per-folio stat updates contend with the lru_lock holder.
> 
> Pass the memcg and node they already know to mod_memcg_node_state()
> instead.
> 
> On top of the mem_cgroup_per_node rearrangement, on a 2-socket Skylake
> (80 CPUs) with threads faulting in and freeing shmem in a single memcg,
> this improves throughput by about 3% at 20 threads (5.59M -> 5.77M
> pages/sec) and 2% at 80 threads (8.66M -> 8.82M).
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

