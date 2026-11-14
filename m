Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C6B606A332
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gh7SvrVi
Received: by kanga.kvack.org (Postfix)
	id 5AB8F6B00EF; Sat, 14 Nov 2026 09:43:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55B1C6B05B0; Sat, 14 Nov 2026 09:43:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471446B05B1; Sat, 14 Nov 2026 09:43:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2F86B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:43:50 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A79FF80420
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:43:49 +0000 (UTC)
X-FDA: 85433993778.07.2ADC097
Received: from mta0.migadu.com (out-82.mta0.migadu.com [91.218.175.82])
	by imf15.hostedemail.com (Postfix) with ESMTP id 97D3BA000C
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:43:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gh7SvrVi;
	spf=pass (imf15.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794667428;
	b=Krj/iOqdis43KlK2ravK/K/ZCtPJnjs5q02UuvohU1d39eLvuPb+caA6gdUND6yeLg/igR
	Q7YAW4tJQduK93LYvxLtZszEEDOhdQwijYfspyEoypbCGJo+QhX8jV0+G9ImI2lBYZWSOd
	iyE/VB8db/fpENTCt3llSYQPxcSs+EA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gh7SvrVi;
	spf=pass (imf15.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794667428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQfy721NNRPf+g5PYMlJDCkNFHuywBK8RJ9ovzc/M4g=;
	b=kB5J1y1hTPVb0odBgLFR2OCP/yaMxmgycQOP8NHoaSgZawIAv/YO9NyBO4rCw8qep8i+gL
	vgYKgqIFpYi097HfFmENBx4y6AxjC/Lo2w7PWBCIJ0qSoCkOz8YNZ5E3HJ/1cZiMezyQ7h
	t2+0fhI5iC+LNuBpnAxlCo+EKYOyFrw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nVJDnAuiRTm3tfpghP9IJ2QoHn4bNdNRote40uYVmok=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794667425; v=1; x=1795272225;
 b=gh7SvrViVdvLo74BP+WLY44sj9oq8ojTkBek32BlanZAyuqbnr8Zro64mEKQTMyA3o2qcPkG
 4NXHVu7hOnWH86hwLcrl9uK5IFGBPLpkSKDp1jHy3mLaqB3aQy8H08qme4eV7zdplwyWGvSkWke
 q+JSSzMe3SUkZX3pr4nOYNmQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id d35b197d40729a00;
	Sat, 14 Nov 2026 14:43:45 +0000
X-Mizu-Trace-ID: d35b197d40729a00
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: david@kernel.org
Cc: chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	xu.xin@linux.dev
Subject: Re: [PATCH 2/2] mm/ksm: add initialization helpers for scan_get_next_rmap_item()
Date: Sat, 14 Nov 2026 22:43:38 +0800
Message-Id: <20261114144338.644122-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <00521fb1-121d-4aef-9278-fb6b36755291@kernel.org>
References: <00521fb1-121d-4aef-9278-fb6b36755291@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u6spj1d4dy436oh8ah7c8aydu4g9zfsm
X-Rspamd-Queue-Id: 97D3BA000C
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794667427-732006
X-HE-Meta: U2FsdGVkX18lf4OivOd3kKbGb9N4m5Qot0R6yOC1dLbwlEqG9cCSb4sP3lRn7ujoNTDfJHTgXQ1gpjDMQpmDv8KyMz/x3AIGx41jmWntMAS0zLLFF9YAc7IWAb010hJT+GO86a65geKbetFPFcNFE795ISTM6LuYyF8qdXyLZliawtn4gqWYfYm7HNrPYyMp3tuaalNDD9mlC/g7ZJcYds7SfuNyNDYiyZQDj9f61QQWMW4M3Xq8BMN08Na6/whSpOvFDqq9O+UFm0KpjvoROVVzw3OjuGUvt5Wjfdpu8dEnTMhICs67mPVXbpokWYMKJhxqV13Zku+nSSoeUcrMa1d4m+hrZjFxevE9V4CZGs3ZpxY4f9ssdYpMAuPrJBUlH9Cue4OXryot243zEvBrQcnvH0RY7hyXjU8GbyeSS950746p4B7MIYrZJrhxXK2DyH0p0QmJ9b/277mAABCwxDq4wu58watEHeLSdYU29hMAFMOTP5wW49BDU1ZNtDQGRe7L0hZtRU5ZhsTy2HwYKwAzJk8ec1J9DxJmWmeJwmW3v8cfLZdB9Kzny8GXl7mNiUY7Tw87ssLqY/ibCHYG3sOU3r5Fh3eZ6D+IykM6XfHKsltN9XECAVwIEH/c++v4ST0X4FOFoh2xjQXoSdr/cKKv+Cyvpa03T0MANZs7UOcDecZMl9Boeqxs3icSHyGWIvr/AA3LRTMh1AJeDrHDNIejGD/kuLoOnDLPAXMWbXecxi1Og+4/zE7GZ3PztdQgTlfw1KLtLqzVXqT5PZLIZZg27udDOfHG2xZlZNtQaNjHX1swMCSjIfplBcRF9Jj9SfIMzIZg6s/VFCNvrL9YLsW22KXiZeq7tf+4i/0/52ZuZoGW5jLq2oeTgWeP0lU+LfV3UM7Keu9BjD2p0z+Oll4qX5upzU9JdN0S6OB1Cdr0IyjWr/Po5Q3IXL2auyHUP13OSGloqMLEzVkL33C
 8Ujwepev
 fHYpuY5FQWw80tDSXQ4s+V4JZUNJr1El7XK4Ag0thAJ0WrpKloE6TzNhbZfCDQSX54htttUbX/09ndmktIqFoKYcGZkgqYQ85TZHWHOHI6CAOJkhWGQhemr6OuA4kPy55bDvhSRDVzUUpjhX1lbC5cIr7vDDRdy6cFYIMwzEZ/dB259SNNE7YNM+rTo2S2E4UJeMHY47DS1Hcyc2V3lRs3LJxNHBRe9HmM1hXQPA+nnc9xWIQ9fDD3J8RG7PTZOVpHA2AMae2caEg75sXHWJ7VqL2THZwxO3Yuqbnc6k2KjRzw2+1jtsAb994IQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index 49977bcf04f7..e79e64372e49 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -2640,6 +2640,49 @@ static void ksm_reset_unstable_trees(void)
> >  		root_unstable_tree[nid] = RB_ROOT;
> >  }
> >  
> > +static bool scan_begin_new_cycle(void)
> > +{
> > +	/* Check if the cursor points to the head. */
> > +	if (ksm_scan.mm_slot != &ksm_mm_head)
> > +		return false;
> > +
> > +	/*
> > +	 * A number of pages can hang around indefinitely in per-cpu
> > +	 * LRU cache, raised page count preventing write_protect_page
> > +	 * from merging them.  Though it doesn't really matter much,
> > +	 * it is puzzling to see some stuck in pages_volatile until
> > +	 * other activity jostles them out, and they also prevented
> > +	 * LTP's KSM test from succeeding deterministically; so drain
> > +	 * them here (here rather than on entry to ksm_do_scan(),
> > +	 * so we don't IPI too often when pages_to_scan is set low).
> > +	 */
> > +	lru_add_drain_all();
> > +	return true;
> > +}
> > +
> 
> Can we just leave the lru_add_drain_all() where it is, or what's the reason for
> that change?

Sure, There was no special reason for moving lru_add_drain_all()—I just wanted to
keep low-level details out of the main scan function to make it look cleaner.
Since it is going to be removed soon anyway, leaving it in place makes total
sense.

> 
> Note that that might soon get removed either way, so I wouldn't worry about it.
> 
> Then, I would rename the function into something like
> 
> "scan_should_start_new_cycle"
> 
> And keep it simple.

I will rename the helper to scan_should_start_new_cycle(), keep it simple,
and send out v2 shortly.

