Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72837FF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 13:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A07606B008A; Mon, 27 Apr 2026 09:21:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 991B06B008C; Mon, 27 Apr 2026 09:21:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880ED6B0092; Mon, 27 Apr 2026 09:21:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 788416B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:21:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 334BF1201EC
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:21:24 +0000 (UTC)
X-FDA: 84704397288.14.860E679
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3337D4000B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:21:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777296082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iBRmhQuT0bpPuczQhvspcKpqvf0QcZcmnnOC0J/I0Pg=;
	b=S3O5NEkjwvkyqTCsSMZyS9mcN/8aP5hM9hcpPnsIRX3aPP6jFKig2MbgtE+2HZuzV3eVY0
	xZrQKFyIRKwhwcKEEWoxBNsUJrexKNP3bRCj2sc9b5PPxXnJVV/eIR1n4IgfUmMxCcQWzB
	jWw9IMJhLvaOQX/1eRVZXPY0TfJN+Rc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777296082; a=rsa-sha256;
	cv=none;
	b=UdRhV57RNa5mAlVPTWPeQc/iB+PnJw/5OXTyd8Skbl9qJwEFGXEJYV5wvagfwAjAfPHuSb
	NC0vTTODVtz6xClecH/+Q+D1KQHc5gQKxQOI/ZME1CICziueIYe8Aesuam0UBozC7He/C0
	1+qNzCfD2Xdwdd/i4Qzm2kBOPQ/Apgw=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4g442043pkzHnGhT;
	Mon, 27 Apr 2026 21:20:40 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 6FB1C40584;
	Mon, 27 Apr 2026 21:21:20 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 27 Apr 2026 16:21:19 +0300
Message-ID: <c09f7c82-88d3-4870-9805-f22394b08583@huawei-partners.com>
Date: Mon, 27 Apr 2026 16:21:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 04/19] mm/damon/core: commit probes
To: SeongJae Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260426205222.93895-1-sj@kernel.org>
 <20260426205222.93895-5-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260426205222.93895-5-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: 7w1kiwzqr4rmqw8m9zj5ub6gj7snukgz
X-Rspamd-Queue-Id: 3337D4000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777296081-8740
X-HE-Meta: U2FsdGVkX1+v6xK6zMalxL48PdhksVJaKi/7q8nW0Mok6R5Qd7wo+ajg+LB9CVzuZN6/Vw3+CyJmNCWWXBPnsTU1ZYkdW5OfaRrQaOP2sOtgGZIHk4rCaSFhGFtuPSshEA01XXzhKwCw9yuWmY1Awo/3jfQiuW1DTTyy3xp5ssyoxYok7PnuPRpbnT/jtXDHjAF1WhVR+6GA7nJAucyEkV2peTAMXu9rgrG4ItcfnsCA/T8S33HbYqMmahED/vOhs49TLvDLnhxZoZ/tZMuVWY3UHmSqq4xdhjXOKPziDAsUpBfmF9pjmqXsA0o60b5cS8ScaZWoqBRoKn4GRSQLNK3M/bw/4cRa2BkdstoYCqbbsx7mxgclQWilI2Rpp1LwhopIEWfGiZNfFkvOF3TQFNSS1061gBtqg0R/Rqh1/3ZEe12VoMD+2hKuyZIFpj9p1DcUQabbhBOVzMdXTKu6jizkKRG6HVbUtGMFjT/gwtb7gG8YkLobU/cKahj+bTc+GcOLSG5lKpKy82g5R8pkDZeqbmFoBEfCc9c1n+ibb9o/LMLfEcNp4D0KmPuxGb4qg9gRHlXDo1XUc7kW6ViQw0E5k3Z2HtDDMbAI9X4LT9xIH5CqRmpA3155PMW4kBa+N7APngq+iNqdFjizTENXAGUxzHi8Yk5owtgQLGxHrZ7F7ymn6ms0rfTkqt4Ti48I7Tojw3QJsQAEeC1V+2DyYbEuYo6itJFYBEFK1UWindrE8SujEH+YxCE9iMk6P2/eSZkXsBL/NGMmImdKzzmkwWr9Mslu6siKH5nb8dhU1Of6Okyw2rf1291pSa3RLgOga0TpWiQvTOjBleytJUr/fr3qPf+uPRhegxSOzY2FN372FiKqm9xyoncqafnQAPbb+1flEnAyWYXg+IPLDqdw3gQiew0971QuK+uB12HIRkc6O1bF2t8pA8bmE0N8KkQa/5Q/eZV2aC3qP0seaOZ
 FaPyHl40
 tiaCuRD1Wv01keXmpsjm3gS0dU1oPWHRcnVTZqZI1Jst/1dN5SOXGI/A9flYqWgimfL7mlHmFHtz+0xiRD6HINFRIkres5F41smNDjK3jnsWz/MhgEOjaRyxV0rNvIsffzlKfXTiWNM/ePGpD5Ym7NHvtrnOAOPx8Ga4ZE0I6tq2KFL5MSUzQouHSTi3HHbvWTpxFqCvXGwklAdJDYjQNzJvixlgffIvLkoSoVNyiVDDYUVrKyY2eKDpmdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/26/2026 11:52 PM, SeongJae Park wrote:
> Update damon_commit_ctx() to commit installed data probes, too.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 104 insertions(+)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 170abba8fdf2a..2ab1d6dd47da4 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -129,11 +129,34 @@ void damon_add_filter(struct damon_probe *p, struct damon_filter *f)
>  	list_add_tail(&f->list, &p->filters);
>  }
>  
> +static void damon_del_filter(struct damon_filter *f)
> +{
> +	list_del(&f->list);
> +}
> +
>  static void damon_free_filter(struct damon_filter *f)
>  {
>  	kfree(f);
>  }
>  
> +static void damon_destroy_filter(struct damon_filter *f)
> +{
> +	damon_del_filter(f);
> +	damon_free_filter(f);
> +}
> +
> +static struct damon_filter *damon_nth_filter(int n, struct damon_probe *p)
> +{
> +	struct damon_filter *f;
> +	int i = 0;
> +
> +	damon_for_each_filter(f, p) {
> +		if (i++ == n)
> +			return f;
> +	}
> +	return NULL;
> +}
> +
>  struct damon_probe *damon_new_probe(void)
>  {
>  	struct damon_probe *p;
> @@ -171,6 +194,18 @@ static void damon_destroy_probe(struct damon_probe *p)
>  	damon_free_probe(p);
>  }
>  
> +static struct damon_probe *damon_nth_probe(int n, struct damon_ctx *ctx)
> +{
> +	struct damon_probe *p;
> +	int i = 0;
> +
> +	damon_for_each_probe(p, ctx) {
> +		if (i++ == n)
> +			return p;
> +	}
> +	return NULL;
> +}
> +
>  #ifdef CONFIG_DAMON_DEBUG_SANITY
>  static void damon_verify_new_region(unsigned long start, unsigned long end)
>  {
> @@ -1412,6 +1447,72 @@ static int damon_commit_targets(
>  	return 0;
>  }
>  
> +static void damon_commit_filter(struct damon_filter *dst,
> +		struct damon_filter *src)
> +{
> +	dst->type = src->type;
> +	dst->matching = src->matching;
> +	dst->allow = src->allow;
> +}
> +
> +static int damon_commit_filters(struct damon_probe *dst,
> +		struct damon_probe *src)
> +{
> +	struct damon_filter *dst_filter, *next, *src_filter, *new_filter;
> +	int i = 0, j = 0;
> +
> +	damon_for_each_filter_safe(dst_filter, next, dst) {
> +		src_filter = damon_nth_filter(i++, src);
> +		if (src_filter)
> +			damon_commit_filter(dst_filter, src_filter);
> +		else
> +			damon_destroy_filter(dst_filter);
> +	}
> +
> +	damon_for_each_filter_safe(src_filter, next, src) {
> +		if (j++ < i)
> +			continue;
> +
> +		new_filter = damon_new_filter(src_filter->type,
> +				src_filter->matching, src_filter->allow);
> +		if (!new_filter)
> +			return -ENOMEM;
We should bail out here. If we return an error, we have already
committed some of the filters already. If there is an error, we
should remove any fill that was already added.
> +		damon_add_filter(dst, new_filter);
> +	}
> +	return 0;
> +}
> +
> +static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
> +{
> +	struct damon_probe *dst_probe, *next, *src_probe, *new_probe;
> +	int i = 0, j = 0, err;
> +
> +	damon_for_each_probe_safe(dst_probe, next, dst) {
> +		src_probe = damon_nth_probe(i++, src);
> +		if (src_probe) {
> +			err = damon_commit_filters(dst_probe, src_probe);
> +			if (err)
> +				return err;
> +		} else {
> +			damon_destroy_probe(dst_probe);
> +		}
> +	}
> +
> +	damon_for_each_probe_safe(src_probe, next, src) {
> +		if (j++ < i)
> +			continue;
> +
> +		new_probe = damon_new_probe();
> +		if (!new_probe)
> +			return -ENOMEM;
The same as before, we should bail out.
> +		damon_add_probe(dst, new_probe);
> +		err = damon_commit_filters(new_probe, src_probe);
> +		if (err)
> +			return err;
> +	}
> +	return 0;
> +}
> +
>  /**
>   * damon_commit_ctx() - Commit parameters of a DAMON context to another.
>   * @dst:	The commit destination DAMON context.
> @@ -1453,6 +1554,9 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
>  	}
>  	dst->pause = src->pause;
>  	dst->ops = src->ops;
> +	err = damon_commit_probes(dst, src);
> +	if (err)
> +		return err;
>  	dst->addr_unit = src->addr_unit;
>  	dst->min_region_sz = src->min_region_sz;
>  

-- 
Asier Gutierrez
Huawei


