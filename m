Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F417AC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 15:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E9236B019F; Tue, 18 Aug 2026 11:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0876B027C; Tue, 18 Aug 2026 11:07:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F18B96B0285; Tue, 18 Aug 2026 11:07:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCF356B019F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:07:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B01D71A0308
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:06:40 +0000 (UTC)
X-FDA: 85114716960.14.3381D28
Received: from mta0.migadu.com (out-38.mta0.migadu.com [91.218.175.38])
	by imf22.hostedemail.com (Postfix) with ESMTP id E5B8AC0009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:06:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RDFrwmnC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.38 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787065598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/fRujFq7M0/lSqG+T/ZkDBENqJh0xUPsFPMpCK6V2pU=;
	b=zqkw5AB0Cd68Mcoa0sEIBOK4YH8P1ye8IhA7SKI9r2AA3cGGRdgA3ifp+pBbcIk67L4AeU
	jD3tkBU7TBIkIgdrxg1oUuz122juGHmIiJZzgDIgtgWKQ3+z57cNQh5lDGcjGH4+UIszcl
	qb7LDnujo6b9D5cxKDwFsrorvV+aamo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RDFrwmnC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.38 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787065598;
	b=azd3n3HNqBkxKPmquWM914XZllEE3PJdFBonduvelcZQ6va5q91+mIhfnorPUUj5UaEMsJ
	vQfRY2ViR7hGT8k+7wikKmSXjsMjN3IXXyWfyJV8zqJejZe5fYTwsPLiyS8cy8GKQ6Ewgp
	uCOsV3bs3EIOVR7mfwLlicKGjABfUW0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cPHeBY5KTM96nrxv4hgyFw1PuHSjJCWzO7Hqsh/Ysd0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787065593; v=1; x=1787670393;
 b=RDFrwmnC4ZcelxCWWFpLf+K1TP6VLaNw/HWd6Lo9F4HSqcntST6xDw/IBr5jRgBuM3epJNll
 +CZyQO8aIS7Xo7qtFUY0iWdC4bQqrg9KuIqyeQcNwQHXDhEwDr+FlugwQwCMNoRqY7xfR2qVsbU
 jv7YRb7iLq+ZmKonJ9vegl34=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:17::)
	by smtp.migadu.com with ESMTPS id 5b5f1f43086e936f;
	Tue, 18 Aug 2026 15:06:23 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 08:06:22 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Tao Cui <cui.tao@linux.dev>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hannes@cmpxchg.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] mm: page_counter: reject empty string in
 page_counter_memparse()
Message-ID: <aoRz72_zdMai_RNV@linux.dev>
References: <20260817042652.74136-1-cui.tao@linux.dev>
 <aoMzchLCCz5hiFHp@linux.dev>
 <aoQNtIRvqXRh-x4u@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoQNtIRvqXRh-x4u@tiehlicka>
X-Rspamd-Queue-Id: E5B8AC0009
X-Stat-Signature: oj4tbu59mtikonywtcjjymg65fiiwpni
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787065596-145034
X-HE-Meta: U2FsdGVkX18KEs5fb0pnaI5zoQ+9y4XQFhvVdi/z3vsGoh2pG+GobZvL/3Zbt4wE8SOmeAUV6OlNpKB0Epyw7+cj4mLl/KsYqWEVznakbEknZtCi6CjNlMQyZ66b8MJaBu/J9AZmbVhAxteIF/gQVW1gNyN6TJEA6zVQfdnzuzJp728lrd/tjeWlPbegdPbbSbp3jzaeg4I/C599b7H76maY0BKXjVdjpE5307qSROg9ugr0OBvBXT0dnO8qZHD6swyZila87DRCgyopd9iOc1Lt1rTicpFuSdFpBQuH39PRyLzk927KrREVQIsv6lmJFoociCsGY9fiFN8gSFAqPf0udivb9rgyf87UBjzOr83XexCN11p1ZzaG1HxS4nazhn/7VfX2l5TNM6c7LlFRjIqqYoFpN7r2zjVQA+dh7RU9TyTNRMY3KeSboeu9ZtfyXxA6ijh0mBlx3ZviesC8CG7rgfTVN9R0rUcEtIREEjWZ/OfabSMOKkPVF+glc3+fo+k/vs95fGPZY6X+AcRWfDXx/Fufy+YiyM8NhiP/UFTn3PfsSzRSEsPhBzlkIs84dG7PbO534yqI5bsX0GFjrBBNOPye61MYCL3WCI8QaC1jM3V+LX5KbJ1a/biR0ZD1L8E2arT6ZI58OgT9KyF7qMEeBx5NyK51Pu9Cg2nG4FxUwzIqgBw9CGM2LAdEO1Ggf17N44rQbmQK7ULUMIajZqIzqDD3E+KbK04s1WVuoujompZrGwI86WvuwNX+xjF5uXgT2YI1qOL6BBTfClldZE08PtORKirFjbDC7YD5BjkOOTuD6Q4Qh4P8lTMiQ+0WWNnDhej2QVCLG7+zQ/qxcoUtnri+Vb5jYBjqpaJuNuhEG6w3O9wmODaKNun3reSnP7SXzU0f86h/+w11+CfElDcMbkRM3ypkgrfRVfaFpDA2CXWzNBvGcZvzeFRxhMgVJj+UJBd1PjWvJwqb5/z
 iYSzEevj
 lPNuN6G25HdJlOUEjWmjHsHxf2w9sDet6ADgHn/dSU3ayUMQ0y3Ch8fsNbi57nKqR68PYEWvyHezxQXUbQ+dWh0XGYnZokfQGOCoOmpRxcPQBJx9v0CA7vY39gTDngUDgWUybjLEmZm8yZe93Gwf4TWTjKk/W22AZFVDPLBqZRYQ7QSst4eNumZXXrzURtUneDfbBNIQBjzhOShBJD7TQAoZUgsg5U4yT73gFS08kI80YF2f0gWdjXZy/jJUVLIoJRjM/64gDNmBMyQqMt1AQgoTYa4HC+kPYxl5Ft0OBTVfDdAIkCug53KJQPa3bVXDL9Kf1C2+2uaof8msJ3hrN2c1ASzl+nRtznBnd+s8Sne2sqniI0ZsKXS+gbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 09:45:56AM +0200, Michal Hocko wrote:
> On Mon 17-08-26 09:16:40, Shakeel Butt wrote:
> > On Mon, Aug 17, 2026 at 12:26:52PM +0800, Tao Cui wrote:
> > > From: Tao Cui <cuitao@kylinos.cn>
> > > 
> > > memparse() consumes no characters on an empty input and leaves the
> > > end pointer at the terminating NUL.  The only validation in
> > > page_counter_memparse() checks for trailing characters, so an empty
> > > input slips through and the limit becomes 0.
> > > 
> > > All limit write callbacks of the memory controller strstrip() the
> > > input before calling this helper, so a script that writes an unset
> > > variable hits this path:
> > > 
> > >   LIMIT=
> > >   echo "$LIMIT" > $CG/memory.max
> > >   echo $?
> > >   0
> > >   cat $CG/memory.max
> > >   0
> > > 
> > > Nothing reports the mistake: the limit is now 0 and the OOM killer
> > > goes after every task in the cgroup.  The same happens for
> > > memory.min, memory.low, memory.high, memory.swap.high,
> > > memory.swap.max and memory.zswap.max, where 0 silently removes the
> > > protection or disables swap and zswap.
> > > 
> > > Reject the input when no characters were consumed, which is the one
> > > case the trailing-character check cannot catch.
> > > 
> > > Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
> > > Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> > > ---
> > >  mm/page_counter.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/mm/page_counter.c b/mm/page_counter.c
> > > index 661e0f2a5127..d14db705b04f 100644
> > > --- a/mm/page_counter.c
> > > +++ b/mm/page_counter.c
> > > @@ -281,7 +281,7 @@ int page_counter_memparse(const char *buf, const char *max,
> > >  	}
> > >  
> > >  	bytes = memparse(buf, &end);
> > > -	if (*end != '\0')
> > > +	if (*end != '\0' || end == buf)
> > >  		return -EINVAL;
> > 
> > I wonder if someone started depending on this behavior. In that case it is
> > better to return error instead of silently ignore, so we will hear complains
> > loudly. This looks good to me.
> 
> This is backward incompatible change and I am wondering why should we
> even risk regression.

Mainly I was wondering if this is intentional or unintentional. If this us
unintentional, can we fix it without anyone noticing?

However if we are ok with this then let's make is formal and make this a
documented behavior. I don't have any strong opinion either way but I think you
are saying it safer to just assume this is intentional. Fine with me.

Tao, can you send a patch to Documentation/admin-guide/cgroup-v2.rst which
explicitly mention this behavior?

