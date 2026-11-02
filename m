Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9543A606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:04:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC0D56B05C8; Mon,  2 Nov 2026 05:04:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70D96B05C9; Mon,  2 Nov 2026 05:04:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAE2E6B05CA; Mon,  2 Nov 2026 05:04:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DEFA6B05C8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:04:30 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25EFA1C46BC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:04:30 +0000 (UTC)
X-FDA: 85389744300.05.99EA50D
Received: from mail.linx-info.com (mail.linx-info.com [114.247.232.78])
	by imf19.hostedemail.com (Postfix) with ESMTP id E05601A0002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:04:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of gkwang@linx-info.com designates 114.247.232.78 as permitted sender) smtp.mailfrom=gkwang@linx-info.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793613868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bsgXfputfPQiAxudDpHtBy77ru0u4ys8CRqHYkfdZLs=;
	b=QwqXGectJ6Sgkd/YQ/aqPq6cIHHbziB5ZnIqHCh8hpW2+s0H17ahrH3sNwzMrvKT+DLF1c
	vJaJDYYCjqJhSAwXHfbEPRia0/NZJIauHQpu1HBJ1SAH0Q4rynQMNjrer7T6BD086G8Zjv
	tQrslP1IO4Db23HmjS/UihYpPWZLws0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gkwang@linx-info.com designates 114.247.232.78 as permitted sender) smtp.mailfrom=gkwang@linx-info.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793613868;
	b=0KLzK9DU0VtHIV9RpFf7GtqGwmlPQdI+bQS4eJuilakma8UzGgVtJM7tEmAdECNf3k+k+a
	NtpX96rK0xShGTBv2j/bfHMia2MfyteOwewl9XnXAct6uPefg2cm097Sm1bthoO+7VuuqL
	Ihtj0fY18Jwpc3nJmuQX8Kbe1le4aWE=
Received: from localhost (localhost [127.0.0.1])
	by mail.linx-info.com (Postfix) with ESMTP id 5FD36321215;
	Mon,  2 Nov 2026 18:04:24 +0800 (CST)
Received: from mail.linx-info.com ([127.0.0.1])
	by localhost (mail.linx-info.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UpQ_qoaeNUmA; Mon,  2 Nov 2026 18:04:24 +0800 (CST)
Received: from DiGouShu (unknown [172.22.21.200])
	by mail.linx-info.com (Postfix) with ESMTPSA id 485823211C6;
	Mon,  2 Nov 2026 18:04:24 +0800 (CST)
Date: Mon, 2 Nov 2026 18:04:23 +0800
From: Wang Guangke <gkwang@linx-info.com>
To: SJ Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/stat: avoid overflow in
 estimated_memory_bandwidth calculation
Message-ID: <auhgJ74TeQOIvTtO@DiGouShu>
References: <20261101180001.167198-1-gkwang@linx-info.com>
 <20261101191344.85683-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261101191344.85683-1-sj@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E05601A0002
X-Stat-Signature: bhxwibgszeo95o7spuzwy8nqxjtnb1fy
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793613866-944652
X-HE-Meta: U2FsdGVkX19jkjwA0W1nW0wM/bS0nKQ/9cIdshNqB0fmlddzAizC0K1Gjb25x/f2P20XjY+DY7USkON9vZjei+39zKBCKuRdavJ4xKu9tEWJJwidgQgLqD12XtpdGw5sVxPPMe1FjaInlxmnzkUCBhuyZUkObZgYpz+2JDFRKyWwdt/+tJxvxQy3BNUQa0phhM+0GF8cV6zuG3TjiF9cwoe/cgMonvIfGXd+GeCItySe6//KQigiEJ5iNo4rkjSn3ujalPOYAednDAL8JBmgdOD0La1wOsxXwlNWsKGabEBAvYWAJhq1rBxbsit+7gGV5PaJiruxr8Mpaont2mD7moraeQCg+1HiJLSUbZ/11bGbO3Dac86jKm9SxQU4Gskr0/LoNMS5r1m4uIkHTph95i+dNchgyLix8EAinpP7T1deSP86iebVipcT3zvPh0UGJLgdOubTOfUet+9tQ4eKlx5ee8xW8rkrLrslfgXD2K0VppUVIih8LaNs3ISOiuBNpm839TTXynBbTxOP/WrV2xFhYj07HYsJJ5E1h2KMs+ciy8IQ+K1MoWF6O1QqpXwZRYj0HzfycwZiAaOhdtP3/+GIf+e6oSucQ72xK5o9XPNNRU59B3i9DKQTDhvZUDVzP5QstsI9Xwgd4Yo+qSY5i/ra9lLeXhtuCD6bv2O/JFMnk/P+O71fAZmNuDsRG+EMW32ngyJ6jpguvxPqHiUKwTqkifqZ5mqP+1U1chg9VRBWOLVE+HlDsN6Y5LQhqWQPtxYFcZibtua0F91MVyuGX+VHScZR+lfe9X32IEMr8VjKLhCWj40PWgSStcQPFWB6YZPxyRfKsol/0oTbgtUaUaJplYRZ9+r/pliLuo6NKcwjkV8xT7AYE3N2uaqqFWRAuQh6eS5TohcjWp12zzDEsO1zLqbndx4nvqjVdo7Mx1/dd/ylz0EIB2zMVszvMeOlGVhfjiA6gTXVF/ilKsq
 dpnG0Vy0
 G/+i2rA7k1SRaqytl4eyV+cuvDunNnlmrkvmjyk+5pFhFU/wzLUXRJXjUMURCvOa9xhm4yhv5DencLv3loPqo4r0o4yEgDDmOtw0sREoRy5m1CWz/2T9Kw+ar7GieNA0UU+dWavrqaSV+BWa6ioXTwagI+itxTwZ7ROagwcBCL+EnOsqOlQQJqCoN5Jp7pq2l/9AVuK67OhWg4SrLsDDaC7TdoJzJfmVdl6N/msC6haDEWCw06jw7qyle11HcPp/5vpAYhALUHGLgJm7nsOrtyiYL0WbvNBXhKE0syEuRUvQudYQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,
Thanks for your review.

On Sun, Nov 01, 2026 at 11:13:43AM -0800, SJ Park wrote:
> Hello Wang,
> 
> On Mon,  2 Nov 2026 02:00:01 +0800 Wang Guangke <gkwang@linx-info.com> wrote:
> 
> > The calculation of estimated_memory_bandwidth computes
> > access_bytes * USEC_PER_MSEC * MSEC_PER_SEC / aggr_interval directly.
> > On 32-bit systems, the intermediate product
> > access_bytes * USEC_PER_MSEC * MSEC_PER_SEC may overflow before the
> > division is performed.
> 
> Do you find this issue from real usage?  Or, jsut theoretical?  Could you
> please clarify it, and user impacts of the issue?

I found it by code inspection, not from real usage on a 32-bit system.

The parameter estimated_memory_bandwidth of the damon_stat
module is calculated from access_bytes * USEC_PER_MSEC *
MSEC_PER_SEC (= USEC_PER_SEC) / c->attrs.aggr_interval,
and users read it via
/sys/module/damon_stat/parameters/estimated_memory_bandwidth.

The maximum value of a 32-bit unsigned integer is 4294967295. Therefore,
in the product access_bytes * USEC_PER_SEC, once access_bytes exceeds 4294,
the 32-bit value is bound to overflow. Users reading
/sys/module/damon_stat/parameters/estimated_memory_bandwidth
on 32-bit systems will get a wrong value.

To see whether real workloads exceed this threshold, I printed the
intermediate values of the computation via a tracepoint on a 64-bit
system.

on 64-bit system:
    ~ # echo 1 > /sys/kernel/debug/tracing/event/damon/estimated_memory_bandwidth
    ~ # cat /sys/kernel/debug/tracing/trace
    ...
           kdamond.0-78      [003] .....  7507.959114: estimated_memory_bandwidth: access_bytes=5536956416, c->attrs.aggr_interval=200000000

I observed that access_bytes can far exceed 4294.

In addition, I used qemu-system-i386 to emulate a 32-bit system and
performed the same verification:

on 32-bit system:
without-patch:
    ~ # cat /sys/kernel/debug/tracing/trace
    ...
           kdamond.0-45      [000] .....  1809.507372: estimated_memory_bandwidth: access_bytes=15237120, c->attrs.aggr_interval=7910660
    ~ # cat /sys/module/damon_stat/parameters/estimated_memory_bandwidth
    362
    ~ # echo "15237120 * 1000 * 1000 / 7910660" | bc
    1926150

The module parameter value (362) does not match the expected value
(1926150), so an overflow has occurred.

with-patch:
    ~ # cat /sys/kernel/debug/tracing/trace
    ...
           kdamond.0-45      [000] .....   212.682057: estimated_memory_bandwidth: access_bytes=7503872, c->attrs.aggr_interval=3615680
    ~ # cat /sys/module/damon_stat/parameters/estimated_memory_bandwidth
    2075369
    ~ # echo "7503872 * 1000 * 1000 / 3615680" | bc
    2075369

The module parameter value (2075369) matches the expected value.
> 
> > 
> > Fix it by splitting the division into quotient and remainder,
> > multiplying each part separately.
> 
> Thank you for this patch.
> 
> > 
> > Fixes: fabdd1e911da ("mm/damon/stat: calculate and expose estimated
> > memory bandwidth")
> 
> Please do not wrap Fixes: tag line.

Sorry, I will not wrap it in v2.
> 
> Could you clarify why you do not Cc stable@?

Sorry, I missed it. I will Cc stable@ in v2.
> 
> > 
> > Signed-off-by: Wang Guangke <gkwang@linx-info.com>
> > ---
> >  mm/damon/stat.c | 17 +++++++++++------
> >  1 file changed, 11 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> > index b05b68f73e10..7cfa3a8d6801 100644
> > --- a/mm/damon/stat.c
> > +++ b/mm/damon/stat.c
> > @@ -32,8 +32,8 @@ static bool enabled __read_mostly = IS_ENABLED(
> >  module_param_cb(enabled, &enabled_param_ops, NULL, 0600);
> >  MODULE_PARM_DESC(enabled, "Enable of disable DAMON_STAT");
> >  
> > -static unsigned long estimated_memory_bandwidth __read_mostly;
> > -module_param(estimated_memory_bandwidth, ulong, 0400);
> > +static u64 estimated_memory_bandwidth __read_mostly;
> > +module_param(estimated_memory_bandwidth, ullong, 0400);
> >  MODULE_PARM_DESC(estimated_memory_bandwidth,
> >  		"Estimated memory bandwidth usage in bytes per second");
> >  
> > @@ -55,15 +55,20 @@ static void damon_stat_set_estimated_memory_bandwidth(struct damon_ctx *c)
> >  {
> >  	struct damon_target *t;
> >  	struct damon_region *r;
> > -	unsigned long access_bytes = 0;
> > +	u64 access_bytes = 0;
> > +	u64 remainder, bytes_per_interval;
> >  
> >  	damon_for_each_target(t, c) {
> >  		damon_for_each_region(r, t)
> > -			access_bytes += (r->ar.end - r->ar.start) *
> > +			access_bytes += (u64)(r->ar.end - r->ar.start) *
> >  				r->nr_accesses;
> >  	}
> > -	estimated_memory_bandwidth = access_bytes * USEC_PER_MSEC *
> > -		MSEC_PER_SEC / c->attrs.aggr_interval;
> > +	bytes_per_interval = div64_u64_rem(access_bytes,
> > +			c->attrs.aggr_interval, &remainder);
> 
> This is not bytes per interval but bytes per microsecond.  Let's rename the
> variable to bytes_per_us.
> 
> > +	estimated_memory_bandwidth =
> > +		bytes_per_interval * USEC_PER_MSEC * MSEC_PER_SEC +
> > +		div64_u64(remainder * USEC_PER_MSEC * MSEC_PER_SEC,
> > +				c->attrs.aggr_interval);
> 
> Let's use USEC_PER_SEC instead of 'USEC_PER_MSEC * MSEC_PER_SEC'.

Thanks, I will rename the variable to bytes_per_us, and use USEC_PER_SEC
instead of 'USEC_PER_MSEC * MSEC_PER_SEC'.
> 
> >  }
> >  
> >  static int damon_stat_idletime(const struct damon_region *r)
> > -- 
> > 2.47.3
> > 
> > 
> 
> 
> Thanks,
> SJ
> 
Thanks,
Wang Guangke

