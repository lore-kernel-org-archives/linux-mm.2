Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72CD0CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 11:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A113D8E0005; Mon, 22 Sep 2025 07:16:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1E68E0001; Mon, 22 Sep 2025 07:16:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE848E0005; Mon, 22 Sep 2025 07:16:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 788D48E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 07:16:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F3321DFC74
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 11:16:39 +0000 (UTC)
X-FDA: 83916633318.13.C87F09D
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id 00F4B20015
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 11:16:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf03.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758539797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yf3tS8LjcHTUB7DhIdCOq0tJ8N8WtIUZUbJp93AzpxU=;
	b=3F6zDQKEMmouPvEzgJOsWwPvMj2pAK6uRISijaF+Ean/SZmc9gCf9yynTMt6WlTpiAETog
	3LK3YPTQG4mhHQJSBH9KCRCLlkQYWXHMSm8k1izF6SLdL1/DigvRn+nTDUR2gjeftnNJK9
	aOYExviL1AQCvt8KtiB5rt71bXJAnnc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf03.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758539797; a=rsa-sha256;
	cv=none;
	b=7A0P/gujT5yQuRCm+f3gBWhAHZu+9/WvoIbC294SW2VO1b5FWmmJD59E2pe6DzUYyMTuUl
	buNPdH1V+7oLHsobE6inW35xU9IQHpoQqQGtJZmYMdK/g0pVVc+EaFJheWl6mmvO8R51xi
	HFRVwEZd6RcnCjOOt+8dfr2bzuG34sU=
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cVgRN4FnTz6L5wF;
	Mon, 22 Sep 2025 19:11:44 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 5BE2A140432;
	Mon, 22 Sep 2025 19:16:32 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Sep 2025 14:16:31 +0300
Message-ID: <5a9dd164-8dca-4852-a6ab-bab752a37810@huawei-partners.com>
Date: Mon, 22 Sep 2025 14:16:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm/damon/core: introduce priority concept for
 DAMON
To: Enze Li <lienze@kylinos.cn>, <sj@kernel.org>, <akpm@linux-foundation.org>
CC: <damon@lists.linux.dev>, <linux-mm@kvack.org>, <enze.li@gmx.com>
References: <20250922101022.362822-1-lienze@kylinos.cn>
 <20250922101022.362822-2-lienze@kylinos.cn>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20250922101022.362822-2-lienze@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: y8j83w65srqz7xpfjrg5w4cqd7qcpu88
X-Rspam-User: 
X-Rspamd-Queue-Id: 00F4B20015
X-Rspamd-Server: rspam04
X-HE-Tag: 1758539795-609486
X-HE-Meta: U2FsdGVkX1/8/D5Hu0ywa8kjcqceSRt2wc/0PGRRRveY+24mE7q6ad7TDZbZCR93/1LKNLwqWmwRJmKiqwcVqLb/jaV+qMs85u1APMa0C5EWF0/DCU5KQ9tMjGKHPd5IrN0y0vjlZaA7RkbSYlXmLGDR11Wy78TvTIUpO8GO6KVsDc0tLqnQ+yVKUOVuq/o5eyLyUg44KsPlEiW35WQQDJ/Gyfh3b/CdpSMvU7NdqUpDxw5wzIv3Z7VZgEZh+rCcrKiba+D1wWRkIBKO3xd4tvnAI0rzitbw3l5a3p/SRRhO0LI6cbEn79wJekkjBcJZzkojGsLKvK7mokIZjZI3j8c8npbhvJk0k0USBxx79ha89hHzv6qfXQnIUw4RUI9yVoT8k05x0XZ0XuzCzquaMZzt3ynA0/fvo0qKa2CiyvJMw1cSDpkSpyhczTbQwzUA5MS/z5SnCZIZn5+kkrrfNSzQHYDkbAIPs6eDjWi6uEoeXId7o8QfELdmQMEeyZG49hhZa8qaUUfujam9/kxXH9DVY4ctqSrh+3yXMWz+XrD+HYvsCxbI18+OI5t3pL5RBnXxN3r9lE6FQHlT9pmsXaYupUNga7qAeg5BzOudDbyKEEZqVFODPmdFl6Izth2uG/ktOjQ3sYglZbB+JLasiMiwktBHCHDRCEADt1/fhDEuJf6eEn5efYcUDg90XF/p0glw8i1Z/hEz8A4Mo/3nhmDxHFCFVknY/GriSQ9q0WoIAC5EuaZBUL8sDg747ZF1nWM4XflASsxnSGUG8Vt8ymCEPdAmUEBS6ZvCYMbt3Ypw8f4tTFEpouHcR8nMr7JG5d4yWeBBrpTwf8AInCVVNwg0Y0p1mWLuvs6K1j8Yr/ZQFgGgNNosvFWhYbcQHcK/GzpC4Y3eYik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 9/22/2025 1:10 PM, Enze Li wrote:
> This patch introduces a priority-based scheme application mechanism to
> DAMON, enhancing its ability to prioritize memory management operations
> for specific processes.  Currently, DAMON applies schemes uniformly
> across all monitored processes without regard to their relative
> importance.  This change allows users to assign a priority value to each
> target process, influencing the frequency with which schemes are applied.
> 
> The core implementation modifies kdamond_apply_schemes to track and apply
> schemes according to user-defined priorities.  For instance, if process A
> has priority 50 and process B has priority 30, damon_do_apply_schemes
> will be called 50 times on A for every 30 times on B.  This ratio
> ensures that higher-priority processes receive more frequent attention
> from DAMON's operations, which can be critical for performance-sensitive
> workloads or prioritized tasks.
> 
> The change maintains the overall fairness and non-starvation properties
> by cycling through targets proportionally.  Existing behavior is
> preserved for targets without a priority assigned, ensuring backward
> compatibility.  This provides system administrators with finer control
> over how DAMON’s memory optimizations are distributed, making the
> subsystem more adaptable to varied use cases and performance
> requirements.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>
> ---
>  include/linux/damon.h |  2 +
>  mm/damon/core.c       | 91 ++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 91 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index f13664c62ddd..a6d3ce186fdc 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -102,6 +102,8 @@ struct damon_target {
>  	unsigned int nr_regions;
>  	struct list_head regions_list;
>  	struct list_head list;
> +	unsigned int priority;
> +	struct list_head pr_list;
>  };
>  
>  /**
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 106ee8b0f2d5..c336914d03cc 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -15,6 +15,7 @@
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/string_choices.h>
> +#include <linux/list_sort.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/damon.h>
> @@ -28,6 +29,11 @@ static DEFINE_MUTEX(damon_lock);
>  static int nr_running_ctxs;
>  static bool running_exclusive_ctxs;
>  
> +static LIST_HEAD(priority_list);
> +static bool init_priority_list;
> +static int priority_level;
> +static int priority_tick;

What would happen if you have 2 kdamond threads running at the same time? 
I guess that you will end up a data race in priority_tick.

> +
>  static DEFINE_MUTEX(damon_ops_lock);
>  static struct damon_operations damon_registered_ops[NR_DAMON_OPS];
>  
> @@ -474,6 +480,7 @@ struct damon_target *damon_new_target(void)
>  	t->nr_regions = 0;
>  	INIT_LIST_HEAD(&t->regions_list);
>  	INIT_LIST_HEAD(&t->list);
> +	t->priority = 0;
>  
>  	return t;
>  }
> @@ -2154,6 +2161,72 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
>  	quota->min_score = score;
>  }
>  
> +static int damon_priority_head(void)
> +{
> +	struct damon_target *t = list_first_entry_or_null(&priority_list,
> +						struct damon_target, pr_list);

Don't we need to check for a null pointer here?

> +
> +	return t->priority;
> +}
> +
> +static int damon_priority_find_next(void)
> +{
> +	struct damon_target *t;
> +
> +	list_for_each_entry(t, &priority_list, pr_list)
> +		if (priority_level > t->priority) {
> +			priority_level = t->priority;
> +			return t->priority;
> +		}
> +	return damon_priority_head();
> +}
> +
> +static bool kdamond_targets_priority_enabled(struct damon_ctx *c)
> +{
> +	struct damon_target *t;
> +
> +	damon_for_each_target(t, c)
> +		if (t->priority > 0)
> +			return true;
> +	return false;
> +}
> +
> +static int damon_priority_cmp(void *priv, const struct list_head *a,
> +			      const struct list_head *b)
> +{
> +	struct damon_target *ta = container_of(a, struct damon_target, pr_list);
> +	struct damon_target *tb = container_of(b, struct damon_target, pr_list);
> +
> +	if (ta->priority < tb->priority)
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +static bool kdamond_targets_priority_init(struct damon_ctx *c)
> +{
> +	struct damon_target *t;
> +
> +	damon_for_each_target(t, c)
> +		list_add_tail(&t->pr_list, &priority_list);
> +
> +	list_for_each_entry(t, &priority_list, pr_list)
> +		pr_debug("damon target priority %d %p\n", t->priority, t->pid);
> +
> +	list_sort(NULL, &priority_list, damon_priority_cmp);
> +
> +	list_for_each_entry(t, &priority_list, pr_list)
> +		pr_debug("damon target priority after sort %d %p\n",
> +			 t->priority, t->pid);
> +
> +	init_priority_list = true;
> +	priority_level = damon_priority_head();
> +	priority_tick = priority_level;
> +	pr_debug("damon target priority init level=%d tick=%d\n",
> +		 priority_level, priority_tick);
> +	return true;
> +}
> +
>  static void kdamond_apply_schemes(struct damon_ctx *c)
>  {
>  	struct damon_target *t;
> @@ -2162,6 +2235,7 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
>  	unsigned long sample_interval = c->attrs.sample_interval ?
>  		c->attrs.sample_interval : 1;
>  	bool has_schemes_to_apply = false;
> +	bool priority_enabled = false;
>  
>  	damon_for_each_scheme(s, c) {
>  		if (c->passed_sample_intervals < s->next_apply_sis)
> @@ -2178,10 +2252,23 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
>  	if (!has_schemes_to_apply)
>  		return;
>  
> +	priority_enabled = kdamond_targets_priority_enabled(c);
> +	if (priority_enabled && !init_priority_list)
> +		kdamond_targets_priority_init(c);

What happens if you later add a new target? priority_list is already
initialized, which means that list sorting will not take place and it will 
break your logic.

> +
>  	mutex_lock(&c->walk_control_lock);
>  	damon_for_each_target(t, c) {
> -		damon_for_each_region_safe(r, next_r, t)
> -			damon_do_apply_schemes(c, t, r);
> +		if (priority_enabled == false ||
> +		    (priority_enabled == true && t->priority == priority_level &&
> +		     priority_tick-- > 0)) {
> +			if (priority_enabled == true && priority_tick <= 0) {
> +				priority_level = damon_priority_find_next();
> +				priority_tick = priority_level;
> +			}
> +			pr_debug("tick() %d(%d)\n", priority_level, priority_tick);
> +			damon_for_each_region_safe(r, next_r, t)
> +				damon_do_apply_schemes(c, t, r);
> +		}
>  	}
>  
>  	damon_for_each_scheme(s, c) {

-- 
Asier Gutierrez
Huawei


