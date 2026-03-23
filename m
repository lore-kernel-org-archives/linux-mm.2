Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77B4AF483C8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 16:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAA116B0088; Mon, 23 Mar 2026 12:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5B056B008A; Mon, 23 Mar 2026 12:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A49FB6B008C; Mon, 23 Mar 2026 12:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FD6F6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:53:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A4D8160CA7
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:53:57 +0000 (UTC)
X-FDA: 84577924914.15.A83FAE3
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2B57018000D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:53:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NuPWES+O;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774284835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y1YolZNvxEG/QAR3/d/TQV4ZFhFCEVz5YVBjSz+Js6E=;
	b=rzHdtX7ofo1clGBeusTFCXJIeaebNs0o6jX5gx7rdhyU2rMaoxrp3uadAZ5qBk9btOuesi
	j6zjG5V049PYx4dQgvqYy0OkqHkuEbtqIQdTj/4U0vGgEvUo0+s6whfLZ0JJYAVXi+myN4
	6gh+ATvuWiFBcbZOQMoErMfPbynfIUA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NuPWES+O;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774284835; a=rsa-sha256;
	cv=none;
	b=hL6vQ19EETECuSQLil9rw4RRGU7Vxv/pEXdlE3vuk5zPnb2OoTvEK7yvbWvPE8KBwNUW0R
	B3UPwTTragLCyHsKuxcwbNEUXIT9mbhxWA8bDpJ4yaJyT1Ak3n3gNhb54C7CruKDVL0gnH
	vVcqhQHXVDBxA77tmgpOM611pNqcohc=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-486fb112c09so27546965e9.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774284833; x=1774889633; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y1YolZNvxEG/QAR3/d/TQV4ZFhFCEVz5YVBjSz+Js6E=;
        b=NuPWES+OA8ya3p/tn2sJsfZ+dNEG4vYUA+m0C5x0k1P+Ykd3IxBp3hFHZQLf7CH3dd
         j24W4opr5jTIDN8Q4eK7TBkbl+FVdce/sOzsW5re+thb4JrV1vQI9GWpQJIGfIUJkS6z
         fkXUl6jz6iwv++KWkXPzeLfuKfDDErYgKK5p8vlJx9G3SCHU2tnJ/amJRcKV/5K3htza
         cPRNrKAgOGFt/aRAtKh+V2KqHnCrt4Z+Zm5NEY0xdW1qsmKT4cv/EktfxK/NgSzVMzGa
         1wHj944TXbSHMJyMw1VUDazYrA2bP3ZKEIb8O//Prt2/GjDseaqistZ6FF6k57nAFkBw
         Bjhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774284833; x=1774889633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y1YolZNvxEG/QAR3/d/TQV4ZFhFCEVz5YVBjSz+Js6E=;
        b=XV5dxRFrFp85FCZE4s5elFYwZLtmYGQnYLybz0xkE0u3Xc7q+oqtNKMYT9BbxCRyOs
         W33K1a1e28ReZ/QG+X7Mv9v5riJ1fg8MfOFjY2t1VQ0DRkTcwfoC0VaVEvOYe/LUy1rF
         bFFcU5k/gKJKmAwrUd9pH3VivMwjCtwn+Zd0GAJgrhaNa69klhk04p+ZE/H5Dkqoa1p6
         IOLp7d2BZFFuASFnuBmumZyNkdvCwgoZpZ1g9tzVOJdP9sCEM8j/z3V0WMTgWA+eYgHf
         oa88k21HX28+HMWDn4ARBe9vnVMQ7TfdTcRo1avobH6az+2dnQiTAN9zGeTeP6oXYBZX
         950g==
X-Forwarded-Encrypted: i=1; AJvYcCXoSvNGhKhc4MY37LeAfie51h3SYdqvYKANil+Hnil0dRr6f3PREPRdpZyd6GFskeu6sB+TFVKLmg==@kvack.org
X-Gm-Message-State: AOJu0YwXv6/OuIFSpvG/KJfnn11uBjEV7L7SvSY9OOHPHUSTreU/gJ2u
	2zculEK+1/YHBwXS5s//kBdJLz0VHGWba6Od91UGYCbgXh59/LMvxj1FF/M8dl7dxZ4=
X-Gm-Gg: ATEYQzyPdntrIC6dwWxu7HkII8Z+3lTu6rx7t0aW+bx6+Rf0Keo0COGcBz+QYc7obMh
	uUejpF+6CclZAgpECto60gCS+2GoBRCm9WTjxN/p33RCSJoPr1aA6YZoZRBkxnPAucmEJUdVzQg
	AWjvqRBhgsD9jbm0zf3+N54dQDIYnWHrLbluUXEJMY1iXr2BgszSaDJ8FMWQDHP/MxjrS/DAIWX
	c4PPfnX2V+NRfrv00P81+PQWrcURX3+i8oS9nQJVW9U+/NTFOh0wiOWMRtOD6vKur+03xSv10df
	TqxtXbcDaxZ0ZMU1Oxms2E3oB2lBzrMDQoS1FkoEQdNG08bmZm2/8Q3bSx6H1mVyjfe54qI4TD3
	Z+r/3Swzr0hYddXjduz6laqB+ECME51IO5FeKjN08RHv5OqiuwiyZ1WtP99RIC+CJNqOauGI78D
	hpqnQQwdEGYud9Zyq7oJaB4ZZeRQZs+hW8WhtN
X-Received: by 2002:a05:600c:524e:b0:485:3ae8:2231 with SMTP id 5b1f17b1804b1-486ff01efd8mr171484705e9.30.1774284833402;
        Mon, 23 Mar 2026 09:53:53 -0700 (PDT)
Received: from localhost (109-81-82-100.rct.o2.cz. [109.81.82.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f8b949e1sm601004325e9.9.2026.03.23.09.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 09:53:53 -0700 (PDT)
Date: Mon, 23 Mar 2026 17:53:52 +0100
From: Michal Hocko <mhocko@suse.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	John Ogness <john.ogness@linutronix.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [RFC] mm, page_alloc: reintroduce page allocation stall warning
Message-ID: <acFwIJTk0L6CWuW2@tiehlicka>
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
X-Rspam-User: 
X-Stat-Signature: nk4qm1byf9mzghyqs3y34b11ibpcxb7p
X-Rspamd-Queue-Id: 2B57018000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1774284834-563895
X-HE-Meta: U2FsdGVkX1/lvSVMyuvWsqHXqiHOacjugJEKJPEDqXo5atg89KkdEodzpKRgqI2+DuEXBKRVZ9k2/RAW+RkkyFe+xvJc92VRU9kIgQ+0yH5kW9mqLHmr7iO+R8LJuWf7969RwvWVpm1rF3Elm7UqHQsNNIekznbOMSRUJj3m120hYG64IH6UW2H7bL1srSGRQO8x3SfcpabDQ/cdurw+qYFcdIzINYTMQ6KWHhW1LqjI4elD6iARdGPRcQOaJynkJtGlcq/UH2WQ+XXiCxAA6/CVkWJjBMYM853caVCBAG18QXqhhu7Sksbxx6yvVUx0YHHxsxoW6l5kpiNwU1m3scpeUw6lP5pvI3sZ0htkyQeLRQD73ZdDWrga1C48qWBhGt8bOXnRu7vPqD/q/+HA+Ejr0X9zBfl8Fuo9cSfhPYl+nEXhDZoFXWy3Zq83tn18v4WXGwp0giPQD3JDdvkOeBfNa7E+rmbmSrPdbXpKcSKoCS5SH9eM76qMYekodstxcjH76JhKZ7EVTCixD0JMumxE4PAQQPR7a+UZMvubGRKLYuPTX1XdOv4RPqhndte0RuqBgvgVzA3UCXb4hoAcFExlFydjG5kIjDeKNaRWncVkNDO/GL1YIw5o93i8waCxVsovB+dPs6V6zVuC2ZV/gvgkExGJWU+rRRgyQ1fcOExLV1D3l9Hot+bJaNtL+BPb/lAEbSZaFkOYztA5LO6PpoBal1Ig4DAD1PmG1KprQ3BzmiXO4fNoR5RHIMRDV0bFHER9nFsE9zfhAHya7J9ZEg6rxOJ9y6KPR8psYH4Ed41lB8Ao7QjGmvqltR1Xg86rvSA1zhHisfNTXH5tNtXO9+cGKgqfzREoIq8YzzLlI7EWR1VXyGuAjx5uYyDC8o/pWnX15DxKFPluK/nyRhwlQL8hkcC2z1HhrJ8/91s22ASyfcopW/BYlhiwkyMXC9eX5DwD6USJcdEByceAMNz
 Lm1goIcS
 CwPdJeiE1GPW1D9CyjVuBdSpH8uq5efX0chtNigHrf+26wguJ7b4ABol64QKhlPeZ87cBEMxciaMx6Oq+zd+QATi2D3GchYTackchXadPIdplAmIc7fY0KZExeQD5p6yH+9aSEBrzLXsx8CtR6ptW8N9RekH26plGnJgPEDO865FDSSWlVnDuJovgjDOMZq6eRwV/eUcmeToVnkmok+bkLM7aTJGTUT845kqzQ+pbT/2fmwmzW+OirmGTT0mdWY1o/kvYrlp7iE2aklzOo2QOpzggRQgOAw8d0EMWGL31OzwcB3cJz8tsi22ID9BCFEVgMqrhHKtjkxXBeiQ2sFVkyv5i4Yo0MRMqwnyesLb5MxMJ06mBv2Fmo0ucHZLUputiuNch9gmwvQs/qRqgPRXE0j/krQ6vUC/PPHTI0NFlN8YzjIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 21-03-26 20:03:16, David Rientjes wrote:
> Previously, we had warnings when a single page allocation took longer
> than reasonably expected.  This was introduced in commit 63f53dea0c98
> ("mm: warn about allocations which stall for too long").
> 
> The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
> warn about allocations which stall for too long") but for reasons
> unrelated to the warning itself.
> 
> Page allocation stalls in excess of 10 seconds are always useful to debug
> because they can result in severe userspace unresponsiveness.  Adding
> this artifact can be used to correlate with userspace going out to lunch
> and to understand the state of memory at the time.
> 
> There should be a reasonable expectation that this warning will never
> trigger given it is very passive, it starts with a 10 second floor to
> begin with.  If it does trigger, this reveals an issue that should be
> fixed: a single page allocation should never loop for more than 10
> seconds without oom killing to make memory available.
> 
> Unlike the original implementation, this implementation only reports
> stalls that are at least a second longer than the longest stall reported
> thus far.

Am all for reintroducing the warning in some shape. The biggest problem
back then was printk being too eager to stomp all the work at a single
executing context. Not sure this is still the case. Let's add printk
maintainers.
Also it makes some sense to differentiate stalled callers and show_mem
which is more verbose. The former tells us who is affected and the
second will give us more context and we want to get some information
about all of them. The latter can be printed much less often as it will
describe situation for a batch of concurrent ones.

> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/page_alloc.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4706,6 +4706,36 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
>  	return false;
>  }
>  
> +static unsigned long max_alloc_stall_warn_msecs = 10 * 1000L;
> +
> +static void check_alloc_stall_warn(gfp_t gfp_mask, nodemask_t *nodemask,
> +				   unsigned int order, unsigned long alloc_start_time)
> +{
> +	static DEFINE_SPINLOCK(max_alloc_stall_lock);
> +	unsigned long stall_msecs = jiffies_to_msecs(jiffies - alloc_start_time);
> +	unsigned long flags;
> +
> +	if (likely(stall_msecs <= READ_ONCE(max_alloc_stall_warn_msecs)))
> +		return;
> +	if (gfp_mask & __GFP_NOWARN)
> +		return;
> +
> +	spin_lock_irqsave(&max_alloc_stall_lock, flags);
> +	if (stall_msecs > max_alloc_stall_warn_msecs) {
> +		pr_warn("%s: page allocation stall for %lu secs: order:%d, mode:%#x(%pGg) nodemask=%*pbl",
> +			current->comm, stall_msecs / MSEC_PER_SEC, order, gfp_mask, &gfp_mask,
> +			nodemask_pr_args(nodemask));
> +		cpuset_print_current_mems_allowed();
> +		pr_cont("\n");
> +		dump_stack();
> +		warn_alloc_show_mem(gfp_mask, nodemask);
> +
> +		/* Only print future stalls that are more than a second longer */
> +		WRITE_ONCE(max_alloc_stall_warn_msecs, stall_msecs + MSEC_PER_SEC);
> +	}
> +	spin_unlock_irqrestore(&max_alloc_stall_lock, flags);
> +}
> +
>  static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  						struct alloc_context *ac)
> @@ -4726,6 +4756,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	int reserve_flags;
>  	bool compact_first = false;
>  	bool can_retry_reserves = true;
> +	unsigned long alloc_start_time = jiffies;
>  
>  	if (unlikely(nofail)) {
>  		/*
> @@ -4990,6 +5021,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	warn_alloc(gfp_mask, ac->nodemask,
>  			"page allocation failure: order:%u", order);
>  got_pg:
> +	check_alloc_stall_warn(gfp_mask, ac->nodemask, order, alloc_start_time);
>  	return page;
>  }
>  

-- 
Michal Hocko
SUSE Labs

