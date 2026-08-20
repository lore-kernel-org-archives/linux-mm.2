Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBA09C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 16:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81AFE6B0095; Thu, 20 Aug 2026 12:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC0F6B009B; Thu, 20 Aug 2026 12:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BA636B009D; Thu, 20 Aug 2026 12:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 451C06B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 12:07:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4CFFC01E5
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 16:07:21 +0000 (UTC)
X-FDA: 85122127482.22.6C23D25
Received: from mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf19.hostedemail.com (Postfix) with ESMTP id 212B01A0007
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 16:07:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cSrQCUts;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787242040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5TEzgRHqQnlHUmpoMCHqh5AqBWrf9mxlhLnu1JiLT4o=;
	b=V7nKgOaGWIKg7JaZo6ONFE0dvojlJzu4jHnUW87FKt84xNL9MEyntUPQJzgmmv1VCxlNV8
	p0HS/zBkBhEuZOKpRtO10akv/23kF2JxvqFRrCp+qwU5uvzItVkyFmWZhcdSBO2U/rH0Hq
	bSZHXi0YyOupAWAZZ1MYTYeXQcFBFAk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787242040;
	b=5EYDNHVq/eOUPzE1GJ258JxIM3ramZ+ugKKD/lXXu2KTgqYhpIZSGYtvKjudO2m8Y3ILyR
	dMR0xNrrtXRcyeRHR6AuJY3EqdweoBwEh0JTSYJBy2WS+c/J7IvgqWjQE5JnR/4gGsRQm+
	LrgWcffUhecKhzsus32k0NRbkFt71co=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cSrQCUts;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=53SX5U3+Y6dAV0m87LKeZ/fGFLwXadUJZBiDVWK3OgM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787242036; v=1; x=1787846836;
 b=cSrQCUtsGSKKM8WP8dMXSLKA7grkxh77CAF0F5rwEEnnEuSoViv4E6nZ3u8E/KYEaF7SwvlE
 pV5/JyYoEF72vHukP8HEteshtCsXAP3n+DCkxpXmYtdE+WKQt/stZB6HHyBNSYHTSDWmI9Sel2E
 xIz01UUhP4oJKIJH5ynFmy+M=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:5::)
	by smtp.migadu.com with ESMTPS id e4605afa8f177308;
	Thu, 20 Aug 2026 16:06:30 +0000
X-Mizu-Trace-ID: e4605afa8f177308
X-Migadu-Flow: FLOW_OUT
Date: Thu, 20 Aug 2026 09:06:29 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Joy Chaoyue Xiong <cxiong@meta.com>
Subject: Re: [PATCH v2] memcg: trim the per-cpu charge stock instead of
 draining it
Message-ID: <aoclMssJAyYw2aCn@linux.dev>
References: <20260820012010.2016086-1-shakeel.butt@linux.dev>
 <aoanalsTiGmL69LN@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoanalsTiGmL69LN@tiehlicka>
X-Rspam-User: 
X-Stat-Signature: rs9z3eioxrdhibnggjun1gg9fiiwq7ia
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 212B01A0007
X-HE-Tag: 1787242037-705378
X-HE-Meta: U2FsdGVkX1+bCFS/QLEWi+dxRyenjnSXgPd7cyx7qCnGjB7Oyd35uhMgYEYDv28H1qduLyfyQbWJEnUVXRaUu3SerX+WwdYi4MIhA4EMMsmaW5kjB4slJrFT22nYo/fB2AsXIENglsTXgDaz6SiXWFrb/iKGTApUCUZIdcEI0ujknTaye2akTaysgxzp3hLg2D/Q56nnTzw8PaFkmh9dA9pBgZxN+36FCR6Fyq5uVOYCoVZCJfdALqog9AiyPzaUcGAvcwAnqD9+sXIQDl08nUXJBKlNm3sdXAS3MIWTEm7r7ozyjof2ZvwBVPefvUW7erAAv7G/YpESBYVxbdrcr6GpwdPWQHCP5LrbfQdRvoihoy1cd+9627azFRyFQcQ3vSW4LkuAfxLCnpZSDwAvJMdSHYtnActOgK+UkEf6Me9r/Urs7QtA6cSQoCAOPqbpqZ5HJU/olZ0xvlbTLcOc5HxueOybcT8DfXkeJwAelBXT8ve3ltdNPiXOrBl3i2XHDZjF7BXSiLubciE5e9GZlO9LVSjU+C+mWsWpYnhFc9sCOkF0WTwzz+/Nl7hB74JShJB4H2/f3OxBp5r/X8tzhL4w0keAlkHw9LTU8kct+i5cax1E0SAFZIrcVlw3TUXQ8DuloIOvQ8BohBCEN/2gZtVetMU/qkw606VPimprYafjI4w7IAZX4vbWtP7aXNbvMAcsO9CQ5/+aXcXy9wD8RmDQwOFtXAuFqbwgE1wujRlT39j4VYdo6Hv0hCz/AzDaVy3nwIhWgMbqZUQpehaBhEVGUREx+h7iNCOfWygYGZI+FDzWEITgy/MMvrI1aLJygTREueLH+1aUM4+TQXqFkCyO/lTIsYkTe6FNYfDV8AAWzqVS7BFdSe+7h7nrwSZYsNSCIuamXzpDp0AYjfYi+TMDdKc+bJmW2rNVGM6Uju7weONjgASx9VFd2zqOG4VdCrgJBmGZW7wC6+J3L8n
 zYDrZCIl
 kMIxXdBGrlSTwOk4OJJBdiWx6zjAxaRAr78B/2B5aWZQjogn9TK26npO2leH60K51YVpH8AvN01cURiuccYPP0piuoga5nNDk9jrLVz/r/1VmfVu+nnRXbnXCdeL4fg3vgv6gnevV5O3XrERuwur2r6q5W091caa4lhT6YSmdjEKoxsrBgedvG1wL5DhyIriq49ziEa8V35nXnGFz9ZZrX5ZISv4kAIY8y2hMWVYPC5uPbMI6utQCBQESmb5fcbGIHHG4bmxpnHRWIJ12cM9fJ2vPK4vOrTJp7Rcer0fVC6z7AL9JsmMZhrtgxhytZTZLCx87GVl7xF2fGYrKFo1/Gw3HL3rAs5oWhBtauE5ietQgu/W6ssDSEmbWF20zQW5UCILoA7gftAQW/VKbpEHFayg6WGScHCTAZOSjOwU00HrKaB2Y87AtHqRyZTPYhcxiapNdzGMlec0VTKiWCb9gprgkY12QP5fBt3wdGSd3lBA/PWvTYj2efFPkzN3qRVnBxKOe9W8EWSdTwc2XuVK0KkZ7STK0nVa8xN4P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 09:06:18AM +0200, Michal Hocko wrote:
> On Wed 19-08-26 18:20:10, Shakeel Butt wrote:
> > Joy reported that an application generating a request/response traffic
> > pattern spends 44.6% to 57.0% of CPU in the memcg charge/uncharge path
> > for a range of message sizes, against 0.27% to 0.71% outside that range.
> > Running from the root memcg, where socket memory accounting is skipped,
> > recovers the performance.
> > 
> > Tracing the charge path showed that the application generates a pattern
> > where the write syscall charges one page and the read syscall uncharges
> > two pages on the same CPU. This hits a corner case in the memcg percpu
> > stock code that thrashes the stock continuously.
> > 
> > In the memcg percpu stock code, MEMCG_CHARGE_BATCH (64) is both the high
> > watermark and the emptying target, i.e. on a request to charge one page
> > the kernel charges MEMCG_CHARGE_BATCH pages and caches
> > (MEMCG_CHARGE_BATCH - 1) of them in the percpu stock. The following
> > uncharge of 2 pages takes the cached count to (MEMCG_CHARGE_BATCH + 1),
> > and refill_stock() then empties the cache completely. With such a
> > pattern the percpu stock becomes completely ineffective.
> > 
> > Instead of a single boundary point for charges, use the technique the
> > page allocator uses for its own percpu caches, which keeps the watermark
> > and the emptying target apart: nr_pcp_free() frees between batch and
> > high - batch pages, leaving at least pcp->batch on the list. Add a high
> > watermark MEMCG_STOCK_HIGH and, once the cached count goes over it,
> > return only the pages above MEMCG_STOCK_LOW. The watermarks are
> > MEMCG_CHARGE_BATCH apart, so a page_counter update still covers a full
> > batch.
> > 
> > For now, keep MEMCG_STOCK_HIGH same as MEMCG_CHARGE_BATCH and in
> > future we will reevaluate if it makes sense to increase it.
> > 
> > Reported-by: Joy Chaoyue Xiong <cxiong@meta.com>
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks.

> One minor nit
> 
> > ---
> > 
> > Changes since v1:
> > http://lore.kernel.org/20260817234651.666540-1-shakeel.butt@linux.dev
> > - Kept the upper limit of memcg stock same as before (Michal)
> > 
> >  mm/memcontrol.c | 25 +++++++++++++++++++------
> >  1 file changed, 19 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 17da1f43b7d3..58e4d23cf5e0 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> [...]
> > @@ -2254,9 +2264,12 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> >  			empty_slot = i;
> >  		if (memcg == READ_ONCE(stock->cached[i])) {
> >  			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
> > +			if (stock_pages > MEMCG_STOCK_HIGH) {
> > +				memcg_uncharge(memcg,
> > +					       stock_pages - MEMCG_STOCK_LOW);
> > +				stock_pages = MEMCG_STOCK_LOW;
> 
> I would find it easier to read to keep the update in sync with
> memcg_uncharge, i.e.
> 				stock_pages = WRITE_ONCE(stock_pages - MEMCG_STOCK_LOW)

Sorry I am not sure I understand your suggestion. The WRITE_ONCE() is throwing
me off.

> > +			}
> >  			WRITE_ONCE(stock->nr_pages[i], stock_pages);
> > -			if (stock_pages > MEMCG_CHARGE_BATCH)
> > -				drain_stock(stock, i);
> >  			success = true;
> >  			break;
> >  		}
> > -- 
> > 2.53.0-Meta
> 
> -- 
> Michal Hocko
> SUSE Labs

