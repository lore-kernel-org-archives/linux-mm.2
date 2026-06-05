Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB4D1CD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 11:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D18226B008A; Fri,  5 Jun 2026 07:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9016B008C; Fri,  5 Jun 2026 07:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7D26B0092; Fri,  5 Jun 2026 07:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABCDC6B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:00:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E94040B74
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:00:17 +0000 (UTC)
X-FDA: 84845564874.30.6646B8A
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5851214001A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:00:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf26.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780657215;
	b=rXOMU61ReDIHxwW8ealS+Nk01A073kdrPPrSGcCS11dFWMyCwNoGmXvFzAmZu/slNP7EMs
	eCs2UPAWwta6/pfysrwow5HB9l3RDLzJFUPYD/HaLv57Ikh9UuFq29peUzcdeGEr+D6+OK
	aw/exAuPjtzwkIwT8gd4SFADuEw98H0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf26.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780657215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0lINxcPmpVaC2If8ZBX0Icy37s4iF9IkDas5F8WQ+bQ=;
	b=vxb1GoB8IoWlgvNRuF7HYzMppKXLiZpk8Qn24G6C3DFZx2pL60uRYs9jPNR6LUj+1j1bRq
	TWFFSHYdmmcV0PsaEwIquVkyk5CKxeCuxo8cW6zpFn3sJRocdmrO2ww5jLKtZVRobqPWsw
	80UIUzV8S9m90vdtxORJ7WzmT4t+OeA=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gWz2q2BFtzHnGkQ;
	Fri,  5 Jun 2026 18:59:15 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id A38BC40584;
	Fri,  5 Jun 2026 19:00:10 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 5 Jun 2026 14:00:10 +0300
Message-ID: <cc60cd6b-d841-4b5f-b3f8-b5dd39ea5808@huawei-partners.com>
Date: Fri, 5 Jun 2026 14:00:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 1/4] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto
 tuning
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260605004422.82568-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260605004422.82568-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 5851214001A
X-Stat-Signature: 7crh711yq3iyix91gr1i7suaxtq9zbkg
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780657214-639544
X-HE-Meta: U2FsdGVkX19XdqbGKz5uZLWRvEBoHsnK3C54tMG6OidispUa1GChymkjnAiiNQWsnLhUJ7zgXl/+/hadTS3f7fwDmY1BxKdyb0Up6EBzbsYYfnDqVuO3MK3rugTSUi3JIjkw8dhZrJejBcYXY8qBqmDtFRdEWH9B5w5aEZ+5EPr55IqVOIS1mU9/4Z8qexOPpvki3V8BqQ98FcgsE06sQpn2D7HhFYhqM4DgbBh0QzcIY3Kx2sHfc7SKl3CqpTR0uzU9O9Q40vYq0fqSzZ4XFXlzmpfETcvnzpdKzSEoEKGYQJ0lGnlXpkj1y+oNh5l2PAxD2fN4d8vCZ3VYnrTSn73/XsDJgTvEaUGU0WF4drM5UNN2waU0INTAvGg6xmNODXoFwbtfEPvQ/TVL+yX5oRX0GjCfLgaxErhUX1qIFp22goIlglgAsb5uOcuVYOimiuR0Tnl1lhK4hYTDFE03504l8/MQEQsGem/ofZFs6L8XW4MU9u2zEWkfW8zZ5Dv9Dfqf3BulcGxJa+rEXZuxiUbp0f3U++OIYKrbIhwjbZFaQ3xu7s84AUPjdU+TzcZs4omwTarNkojHAfb92lJzIRAgHEV1cqFO6Q85D5zG6UmgRqcrSrGdAVtiyeeo5nfwt/nfZ3up5qqLku8YYjVNruzk5kQ6DW7LnpGL2n6FI4P+JfkXZYKi4A5Kl53eunlQPN9xDwTpjFZYIoh4xJ4hW3PgcFX3ycGmUwhePQBDJnsrvfFttScxlSk1ESCfWPzLNv2XADNt6/q8f+OhMOVrj9sHC6AfULjaRiqxQrTtvnmJCiRWbhmDxcLcT2I0WNGu72stec5dr+/rj+xgmCHDIMwMH1YMACmeJB51VAEjqcSf0eaMvhkyINc8ITd9Ua1LfR/0vcToWjK+tJQ6DRrJ6j/jZbMES5e75+meT/m6yWSt66R9b+DF9EiGDqG9ny+lEQ1X2yPT6P9RewAzrR6
 FspRDBO0
 uDKvVBB050tPdqbYUdCeWjBfw2bg2dnCl9Qta2jhubm/lTlp66sFK3TjSjDVyVPiiavMictYCv2KSLJErl0OtL/CuJVkDMJJOfcKvS6Cqytm1d+QkU/RzBSnem4ReS0v+JjfHiJJIY0enlMFNigo5/6W8tRH3Yp+OKaXfp5XFh0pdguHMzEJrOKkkEFgaNcumONsGITBGoZobc9tkNDkJxjQlY2IVD8Fij685V3hjUTXTl1RlY8SCMVnaSb+7WuIl+RwtRo/meCwMm/R86NjYeRpt3mX7qwFqIxBL0R61JUnoBQlMl8pgbi5fTz0iH7/LI7vqkmnCxD7NA8Lz/ymjbCo9itxurVVjNqH4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/5/2026 3:44 AM, SeongJae Park wrote:
> On Thu, 4 Jun 2026 15:03:34 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> Introduce DAMOS_QUOTA_HUGEPAGE auto tuning Add a
>> new DAMOS quota goal metric to measure the amount of huge
>> page consumption to total anonymous memory consumption
>> ratio.
> 
> s/anonymous// ?
> 
>>
>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> ---
>>  include/linux/damon.h |  1 +
>>  mm/damon/core.c       | 14 ++++++++++++++
>>  2 files changed, 15 insertions(+)
>>
>> diff --git a/include/linux/damon.h b/include/linux/damon.h
>> index c7a31572689b..8e15a674e893 100644
>> --- a/include/linux/damon.h
>> +++ b/include/linux/damon.h
>> @@ -177,6 +177,7 @@ enum damos_quota_goal_metric {
>>  	DAMOS_QUOTA_ACTIVE_MEM_BP,
>>  	DAMOS_QUOTA_INACTIVE_MEM_BP,
>>  	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
>> +	DAMOS_QUOTA_HUGEPAGE,
> 
> On the previous revision, I suggested renaming this to
> DAMOS_QUOTA_HUGEPAGE_MEM_BP for consistency, but it didn't got your reply.
> Could I ask your opinion?
> 
> Also, I asked you to add the kernel-doc comment before dropping RFC.  I know
> you didn't drop RFC tag yet, but could you consider adding it from the next
> revision?
Sorry, missed it. I will change it.
>>  	NR_DAMOS_QUOTA_GOAL_METRICS,
>>  };
>>  
>> diff --git a/mm/damon/core.c b/mm/damon/core.c
>> index 9f38deddcb30..7fc7477a353a 100644
>> --- a/mm/damon/core.c
>> +++ b/mm/damon/core.c
>> @@ -2536,6 +2536,17 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
>>  	return mult_frac(inactive, 10000, total);
>>  }
>>  
>> +static unsigned int damos_hugepage_mem_bp(void)
>> +{
>> +	unsigned long thp, total;
>> +
>> +	thp = global_node_page_state(NR_ANON_THPS) +
>> +				global_node_page_state(NR_SHMEM_THPS) +
>> +				global_node_page_state(NR_FILE_THPS);
>> +	total = totalram_pages() - global_zone_page_state(NR_FREE_PAGES);
>> +	return mult_frac(thp, 10000, total);
>> +}
> 
> As Sashiko also [1] commented, let's avoid divide by zero by checking if total
> is zero, before calling mult_frac().
> 
> I wouldn't mind ignoring Sashiko's 32-bit concern, but do you have any opinion?
I just answered. I can cast 10.000 to unsigned long. I don't think many people
using 32 bit systems will use over 1.6GB of huge pages, but it makes sense to
be safe anyway.
>> +
>>  static void damos_set_quota_goal_current_value(struct damon_ctx *c,
>>  		struct damos *s, struct damos_quota_goal *goal)
>>  {
>> @@ -2567,6 +2578,9 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
>>  		goal->current_value = damos_get_node_eligible_mem_bp(c, s,
>>  				goal->nid);
>>  		break;
>> +	case DAMOS_QUOTA_HUGEPAGE:
>> +		goal->current_value = damos_hugepage_mem_bp();
>> +		break;
>>  	default:
>>  		break;
>>  	}
>> -- 
>> 2.43.0
> 
> Other than the above comments, looks good to me overall.
> 
> [1] https://lore.kernel.org/20260604151932.93C431F00893@smtp.kernel.org
> 
> 
> Thanks,
> SJ
> 

-- 
Asier Gutierrez
Huawei


