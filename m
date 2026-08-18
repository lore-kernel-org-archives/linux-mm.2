Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EE4AC5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 15:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7555A6B02E0; Tue, 18 Aug 2026 11:08:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C416B043B; Tue, 18 Aug 2026 11:08:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6432E6B0456; Tue, 18 Aug 2026 11:08:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44FB56B02E0
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:08:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A9F2120114
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:08:43 +0000 (UTC)
X-FDA: 85114722126.30.BE58ED1
Received: from mta1.migadu.com (out-117.mta1.migadu.com [95.215.58.117])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0CF9518000D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:08:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MtXo2V57;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.117 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787065721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbiU5Fa7zeo4VmxHrwTe4J+bX2cyN8YRR7rJw/Mg2mg=;
	b=puWNtJkn0rZazsvCz7bbrw84vBasSSy7WyYvdt8ZDhmeqdj277u3eXgzuOpLdVOvJAzNhR
	lw1zAHo2LBf8ADvZvdZtWcdTFOjR0M+UtOPi2BLGc6BJNUbQNa3wXwSAfKIFHjvokQUuYh
	h+0SNnZJ80iyAMyCC8Fgrm7RfRKmWGg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MtXo2V57;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.117 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787065721;
	b=0mH8LlP+LLUr1XyboVpyozE6bZP4z4rnAixaJ1WDdy9CPADROyTOfSpS4bFtPEe7qY3iFK
	0y7Z4KAnvW+yvlbXSMMCgtPP+DipFY/n644NMec4K7V1T25N8Kf2GHx8v5KgG4qkUdygK+
	ZG+lXT76AKy8g4SS4y1ELyGbGlr8nnw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0FsRmWGrp3IBrt0AhnQA/jZLSq4jcxcIf2nihiOFFb4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787065719; v=1; x=1787670519;
 b=MtXo2V57bPU+QFfVBvnqEoE5Qm1/MW2gFIUDa46SiFiPpmxo8DEEhCxLhdlSbJFHRYOUjyq4
 SPbLVqSCHkkeEmkTeISoFUz8peDQ4gar4l2GE5WFGa1bwHgH3+wkkphxC1GUYD5Ys+5i1ASERsD
 4L0VwfqGtlCrzJbNiNhMsQPU=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:59::)
	by smtp.migadu.com with ESMTPS id e04d93166a86feda;
	Tue, 18 Aug 2026 15:08:39 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 08:08:37 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Joy Chaoyue Xiong <joyxiong@yahoo.com>
Subject: Re: [PATCH] memcg: trim the per-cpu charge stock instead of draining
 it
Message-ID: <aoR1ClkKofp0l9Cs@linux.dev>
References: <20260817234651.666540-1-shakeel.butt@linux.dev>
 <aoQt2zKsQT-rvjd6@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoQt2zKsQT-rvjd6@tiehlicka>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CF9518000D
X-Rspamd-Server: rspam07
X-Stat-Signature: 6eb1ej5qnbj6jxy64wspkr5pefab4hha
X-HE-Tag: 1787065720-449199
X-HE-Meta: U2FsdGVkX1+eaoreHzdIc/s3gBmrFkJShThKqkyLC6xaNwl6cDUogyyugQEr6hd+zzccZTnFmh20J3yCSHkql2jyhm5E8C2Pk2Eu6CDIORhvSHS/odfQUw9F/XaK9sPPzjvLr6LWshD6e4R/jEmrTEt4c2Z21I2RpkN6eNeJYO7c8DC/N7wns+hkeSg1eTHvK0xfo9aJNCrqU0oZnFaJ68v1Y2jzLPbbijJJBojpYaPE+qQ90cP0/TdKxzN17uQwngOkAs/PgnVQYOwYNXDHse+Ypx1BYeUMCOa0K6KXEr2gas77Im/2sx5rnC3ekMOJn6U93YHL8yjQqoqyO7TW6GZG6MQ9rHeR5R7yqbeaYW/DPy6fn+Q/ewGpFD901+NKI2MyqVOP4nfKftTGHLiRwWHHRmmodKkpH8svH+MGstD1GWcEOaJVDys6XHRyv3NTFgAIWdVGT8Ai6i5rRBljmjBS4ZjOPmuOie8dq1JExTdvZTMA7S3OmgvjLWAr7AyDdk09QRXx6QLCZkA/qnfz+wLL/DT5WKM6BjZ6raaMAj8N4iLmaS4Iv334ipRa8B7cmtR6xGFkvqfOQRDHZGiWuMrPrBDbcMYHoeZJdoow9t89IyB2vv7f945FtsInDbrhaQKvxhh+C1IOyar9bQ0O2EMDa30kWye9wdhxa5M1+pS0cctHc9v+M2Mp4Aq/bc2HLc5NjZwhRXIWCx8TwoLkSFgAtkgYSps6o3qONs/u3PvKhlKYL2hRQWWGiq8eLJm74cdTZX8XjHUFO6E1TCZno9kWb+eta7xLyxsBLsTFpl4lQ3gEYXSaOparKCc6aGQZKnNwYEZhx//RDGig/ReKGugD8v1kDbfphOZ1szbMVm3Rw1wiXbAQlihSpTnvmztwArGV+R7XpoVtZTaJRoWeNgz3WP31LRVxCv9HcGmDsbRvqpx+OFWBXW7P7u7OQhWt1UsZw9trZzuExrSTc6J
 z9lpdgpp
 EJWEZk4R6dscCavAo1seEnFkZTQPiImr4Vgot0MMRw/5FCpO7eESWo3Nd8T7DY4VXbD2EfMs5JBd9jWQ9B2zY78v+R0Kea0DTTwr1m/VW/yAEQpt+w+77QOmQg7lflrEEkfcu66KhR1CYD1wkc5sjjK5ud9ETS3a7VCPEKMapF5Zir5VIubI9egxNBsAnSIEyvwQnpmNICsyoerybo88sCKzdvfFm6lVj9ZXOGjegXRoDBH33c/pRXtvE/qS2ZIMtdlxWGNhqYmUrpxqUjHD5hhPsVNwNdNiRClAy+qV1T5DG9ro56ShRe/5+mEedwZk9xPhGzudSrpdwPe1L0K+uytzOjjfI96Zrq4ymzhwY3KlJDNCAH/OqJUgp9o/xnUJ1OII+blnWcnCKzOU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 12:03:07PM +0200, Michal Hocko wrote:
> On Mon 17-08-26 16:46:51, Shakeel Butt wrote:
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
> > batch. Peak cached pages per memcg grows from 64 to 96, the same
> > high-versus-batch tradeoff the page allocator makes.
> 
> The idea is sound. I would just not increase the overall stock size in
> the same patch. Fine tuning can be done independently and ideally with
> some numbers.
> Would it make sense to start with MEMCG_STOCK_HIGH := MEMCG_CHARGE_BATCH 
> and  MEMCG_CHARGE_BATCH := MEMCG_CHARGE_BATCH / 2. That would preserve
> the maximum stock size while preventing all or nothing behavior which is
> indeed suboptimal and pushing charging path to a slower path way too
> aggressively.
> 
> WDYT?

Yes, this makes sense. Let me run the experiment with that workload to make sure
the newer number works and resend the patch.

Thanks for the review.

