Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52468CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:04:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B76F76B00A2; Mon, 25 May 2026 11:04:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B00A66B00A3; Mon, 25 May 2026 11:04:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF036B00A4; Mon, 25 May 2026 11:04:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E5886B00A2
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:04:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 51173140125
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:04:38 +0000 (UTC)
X-FDA: 84806263836.11.EA8F66E
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0006140013
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:04:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779721475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N4JuhTRHi9V0ptrs13VnhBficZlrhoJBJ9VGe4IhqRw=;
	b=vNWyRfeBtBqKdCstxcAv9BgpC+0xrwr49lL0Ioif3dX1Dkevv6RUH/Q+4/SYFUKp2+iaVV
	ZD5IM5+SKjjsICXzLls/ICKvV54oMSmLsDpKcX6/YN+xuw6TPVa59lue73GMA5b0J0AxIS
	LK+W8KWzeHWQfahUzEKYo4wBXjggsek=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779721475; a=rsa-sha256;
	cv=none;
	b=ncEoQi1ccjRrFVR3OTDx/EGboqT1++rabu/7WfRpCe1QFNV/eA+zVgcqm3xT2IH4pqBhVs
	l6cFJscS+50mNAXp5Q/ChqKJPrEw0l8lyNY7oYYQaxt9/yu0wEPbqVVLRRDeLwIVs+JAja
	uqd/Idsyws0JKHujh92dtcIMoGUD+fc=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gPJzs6bxRzJ467l;
	Mon, 25 May 2026 23:03:37 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 7889A4058B;
	Mon, 25 May 2026 23:04:26 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 25 May 2026 18:04:25 +0300
Message-ID: <fd55452e-8c4c-4983-a403-bd1ab7ac73f6@huawei-partners.com>
Date: Mon, 25 May 2026 18:04:25 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 2/4] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto
 tuning
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260523172725.89221-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260523172725.89221-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: 1ksbc38fkzxb7y8djk5sa3kedbaic58f
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0006140013
X-HE-Tag: 1779721474-246303
X-HE-Meta: U2FsdGVkX19eu86sUWBuYBOsa60nUswKN8a5jEZlnMAMBGGyD4bmDvv3M3xuNjUgUw+/4GgLA5dizHcRQlw9a1OP013T2aKVv9DtwyVHxdA+23U3qJpkspT0ZklLeY6YZULuAZKIlDhk9i06zi47cJCZvpshjokIMYCOWtQNJyddN6+OkH1+PvkXcn+4W2aCSz0Y+AyziS4IzgpZJAY0qg6TNnEwis5AYdBQSAF0OjYPKKcav4ShR5hKDIiJFc/9M0jOYBuE8zHVqRzAP84s9x1SEWIWtRSHSQafYe2fBziaOdVl8vx4dh6flOloKhtM7fh1ETqxQ5bNkwsPNtsZHqfxmh/osF8Q4B0MyIsAOfpDANAH7uLHTEUeO6Mzg1/e6wSO8iVPEbyNZldC7cvvR9h2f7Q+glhmU7BXstGNoVMs53adcKzLTRNDBOiQlFEW0NdquNNZ2vvWM6WevPISOMqE0p7FJIXbKR7eKjNd8eyBGKlltbXyimeVST3B5R872AADp73q7C6RvwA+Y6ROkFLuwcNMyFxzmP4i/5xhrrrs5SiS74Oq3fO9vhZJB4Pl97WQ3vx0uMMJD9iINwaESCOXZT7DSO5+YjQgO7p3pyo4XnF4KvXV34RPNVoHZNQDinUGBbLhi6YuD60Uca6eHjEe648RfeuLpv8ThN4QiA5S2gb6xHfS9mhmIq4aS3BLf8JVAz3OEhOO+aIJjCWcNBnwNXlLi2j8U9BxjPQvFRt4TRCzJ4lycAB536Eyv9ELzNCoXaBSqjurHJxjLRGPnEH8sGlI4iMaQM6KCzD1HA0ewfqxG4UrVjy5sWE9bAO/UY2LBGRIFscstaehNy0ek1b8urxd6p7XkB298eAmqY7H7ctTvv/fy7L7BO+K1+62yXLnx97oIj9dyf6e3GWjG7mJaBqZH3esgiNLoQ991AcXurbbtBo9aJ/fHt2wUse04DIOqHYbDPpSTuzwIy2
 z6fX/FhC
 S0S1Vsjo66ieq+3r1rjGqUl9BDSjVeqZ4xVjVt2ym5NeBE8X5HZ/ayztEneon1I6BUj6ocNeNQB57pNiZNtqVo3R7wtUrl6oFuolAarFwC4v42qptWRqPKPOJWLGo1VaiXlPdCgr8Van0pRtElXqixTunCPQHrD7qHaVfyi97zpJ3QQ6zqmpIFWOde4bNmvgL4zC47tSWPXDewjgKJLXQMz3yekiuG0WaFXB6hUVCoFn+FJ5tkcnZNlsyfSPN5R/UvDsDorvS7SqrHPlqmuLs6s9e+gTqiI/Z5jqW3iLeZJEp0w5+yoGiqQDMeEdJ2h4A3x+ipNIEH1kz1zY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/23/2026 8:27 PM, SeongJae Park wrote:
> On Fri, 22 May 2026 14:55:16 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> Introduce DAMOS_QUOTA_HUGEPAGE auto tuning Add a new DAMOS quota goal
> 
> I'd suggest to rename it to DAMOS_QUOTA_HUGEPAGE_BP for consistency.
> 
> Also, you missed the ending period after 'tuning'.
> 
>> metric to measure the amount of huge page consumption to total
>> anonymous memory consumption ratio.
> 
> Why against anonymous memory only?
Well, that was my first approach. All the projects that I have done
recently were related to anonymous memory. I'll test it with total
THP user vs total memory consumption and see if everything works
in the same way.
> 
>>
>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> ---
>>  include/linux/damon.h |  1 +
>>  mm/damon/core.c       | 15 +++++++++++++++
>>  2 files changed, 16 insertions(+)
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
>>  	NR_DAMOS_QUOTA_GOAL_METRICS,
>>  };
> 
> Before you drop RFC tag, please ensure to add kernel-doc comment for tyhe new
> value.
I will do it. Thanks for the reminder.
>>  
>> diff --git a/mm/damon/core.c b/mm/damon/core.c
>> index 9f38deddcb30..1f1cf10aa241 100644
>> --- a/mm/damon/core.c
>> +++ b/mm/damon/core.c
>> @@ -2536,6 +2536,18 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
>>  	return mult_frac(inactive, 10000, total);
>>  }
>>  
>> +/*
>> + * Returns anon hugepage memory to total anon memory use ratio.
>> + */
>> +static unsigned int damos_get_used_hugepage_mem_bp(void)
>> +{
>> +	unsigned long used_hugepages, total_used;
>> + 
>> +	used_hugepages = global_node_page_state(NR_ANON_THPS);
>> +	total_used = global_node_page_state(NR_ANON_MAPPED);
>> +	return mult_frac(used_hugepages, 10000, total_used);
> 
> So this function returns anon THP to total anon pages ratio.  Why only anon
> THP?  Also as I asked above, why only total anon?
> 
> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei


