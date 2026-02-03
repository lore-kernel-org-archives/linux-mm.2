Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88DBAE87835
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 14:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 367D86B0095; Tue,  3 Feb 2026 09:05:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EABD6B0096; Tue,  3 Feb 2026 09:05:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F2376B0098; Tue,  3 Feb 2026 09:05:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2376B0095
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:05:01 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B5BAA59363
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:05:00 +0000 (UTC)
X-FDA: 84403316760.25.779AA4C
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id 38DC01C000F
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:04:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770127498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=up26p6fDjE4wjgeP+vCVpsEMhcYIRMGNR8TI0X1mnVU=;
	b=ORDbkIth3XUWmPsjjdY9dE5S3CXpay2LqUgVsstFoUUfZYQIW159U6eGM4CQqaInVxhFV4
	t0cIyQPsjMf8p7besdTGwU7eopeACLjptMrO8SAScFl5nItUrBrNl6vl7coX4Ro3EFCTs1
	JeyAxa/HjCFI8qVpQPIwKAMpZKde920=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770127498; a=rsa-sha256;
	cv=none;
	b=7DTNb/pofhrUrB8xmcFu503T34NTRE9igQ00vNq78qbi/MxI/sianeXW3q2c/Nnsdk1POq
	FwV3ZHsEoGXvdS8TYFSdyZrVjSxiO3YIYmU2IOQ9E0R5z2shfbhnsVQSjmlA3arHygAGkz
	bYKGIFL2h2bWDlIdiGOjJlxzi9xMXVE=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f54wD03yfzHnGkL;
	Tue,  3 Feb 2026 22:03:56 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 707E140573;
	Tue,  3 Feb 2026 22:04:55 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 3 Feb 2026 17:04:54 +0300
Message-ID: <5f4edc60-691a-4dbc-93db-794f11f7b942@huawei-partners.com>
Date: Tue, 3 Feb 2026 17:04:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 2/4] mm/damon: Support for synchrounous huge pages
 collapse
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260203012304.67686-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260203012304.67686-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 38DC01C000F
X-Stat-Signature: js37ejij7bagtgttp8xygyr7z15xnxd5
X-Rspam-User: 
X-HE-Tag: 1770127498-66017
X-HE-Meta: U2FsdGVkX18Wptb3tPkhF3ERBkd8snh90rMtOJ/hlNbMkiEA9H61RnTMqlIpFGt7RGiSMuD8piITM/GWHes9G0gp17dXx/bx5m0mriYHJYhsr2VZkdMRS9knD3JU9A4gPZkb92eGguIqkhdiYOgsl2+HpUohZgI47i8UqHMq9rF5pIHIdidRG7Qkm+mxAuTaMUjYeh7bO0MyTmMuf33Cyo9eFBDngDWCqT36yzteroMHx2sITo4jvpE7Yg9nbpYHxraUyqao6nNXNrxjH6a7EJ/6s0TDyGN7KFyxOWVpuBdRsFVZd1GoZ96D0VfePHILSv5TkpyCQtWfTp2AC7HJRTcdM7mlzpmG7lyXiIjJEtoGsaQ27nu/npqi4fSlZUNqdb5f9mLALsJSxGouNwbW1xXR9PaMiqB4/UP3Q5pEqqyu/j6krZ0kRe2Xo/OLDtLXnHjFos34OxhFh18SqdIzyeCb8wgl/dIRc2gkg//PajbqcRsXVfSDDiOKbyKLdwugK2s5UU3pmLB0Lo0oguZDp6Ykb1Hzgz5M5fw0CZG/2NzRwRSz3tz8jqpYIWWfTzlVzq1Tc+H3yfZ1VNJTBevbjYQt5t0W90JQKF0FIeTFmMb7027boJ84EMEI383bb/BVUB3RHpu1UppiT2K2XMrHlvlao91AcjdEH0FofXeiTPR6/rx0vopfUS5y2Ys7xfaW8JQT6UJ2xlWOE2vc11rmypxtFrp5PaJzoIGcwFl1ELGiSZ3b0x5+cap9WaNNy1ci1xQNOeSzSKz/5hz3D27C1QHAxh0VCU1iSFy+UwG91Wl/kXkRiThOA++4n8cr3IGYZWUpnk3QqCt+ZVFvCytK0AV3VS3G9vb60eCn4Nr6oI1z2LWAij+qZFfQPe9uhudD9CYcK575ut/u46D/e5fsdA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/3/2026 4:23 AM, SeongJae Park wrote:
> On Mon, 2 Feb 2026 14:56:47 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> * Support for huge pages collapse, which will be used by
>>   dynamic_hugepages module.
>>
>> * Include the new module for compilation
>>
>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
>> ---
>>  include/linux/damon.h | 1 +
>>  mm/damon/Kconfig      | 7 +++++++
>>  mm/damon/Makefile     | 1 +
>>  mm/damon/vaddr.c      | 3 +++
>>  4 files changed, 12 insertions(+)
>>
>> diff --git a/include/linux/damon.h b/include/linux/damon.h
>> index 3813373a9200..de5a994f92c2 100644
>> --- a/include/linux/damon.h
>> +++ b/include/linux/damon.h
>> @@ -142,6 +142,7 @@ enum damos_action {
>>  	DAMOS_LRU_DEPRIO,
>>  	DAMOS_MIGRATE_HOT,
>>  	DAMOS_MIGRATE_COLD,
>> +	DAMOS_COLLAPSE,
> 
> Please update the kernel-doc comments for this new action, by the time you drop
> the RFC tag from this patch series.
> 
>>  	DAMOS_STAT,		/* Do nothing but only record the stat */
>>  	NR_DAMOS_ACTIONS,
>>  };
>> diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
>> index 8c868f7035fc..2355aacb6d12 100644
>> --- a/mm/damon/Kconfig
>> +++ b/mm/damon/Kconfig
>> @@ -110,4 +110,11 @@ config DAMON_STAT_ENABLED_DEFAULT
>>  	  Whether to enable DAMON_STAT by default.  Users can disable it in
>>  	  boot or runtime using its 'enabled' parameter.
>>  
>> +config DAMON_HOT_HUGEPAGE
>> +	bool "Build DAMON-based collapse of hot regions (DAMON_HOT_HUGEPAGES)"
>> +	depends on DAMON_VADDR
>> +	help
>> +	 Collapse hot region into huge pages. Hot regions are determined by
>> +	 DAMON-based sampling
>> +
> 
> Apparently you wanted to introduce the above change on the next patch, but
> mistakenly added here?
> 
> I'm also feeling the name might be better to be simpler.  What about... say,
> just DAMON_HUGEPAGE?  We might want to extend that for general access-aware
> huge pages.

I will move the build stuff into a different commit for the next RFC series.

I agree with the name change, I will do it.

>>  endmenu
>> diff --git a/mm/damon/Makefile b/mm/damon/Makefile
>> index d8d6bf5f8bff..998bddc17819 100644
>> --- a/mm/damon/Makefile
>> +++ b/mm/damon/Makefile
>> @@ -7,3 +7,4 @@ obj-$(CONFIG_DAMON_SYSFS)	+= sysfs-common.o sysfs-schemes.o sysfs.o
>>  obj-$(CONFIG_DAMON_RECLAIM)	+= modules-common.o reclaim.o
>>  obj-$(CONFIG_DAMON_LRU_SORT)	+= modules-common.o lru_sort.o
>>  obj-$(CONFIG_DAMON_STAT)	+= modules-common.o stat.o
>> +obj-$(CONFIG_DAMON_HOT_HUGEPAGE)	+= modules-common.o dynamic_hugepages.o
> 
> Ditto.
> 
>> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
>> index 23ed738a0bd6..4acbc1a6a5be 100644
>> --- a/mm/damon/vaddr.c
>> +++ b/mm/damon/vaddr.c
>> @@ -970,6 +970,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
>>  	case DAMOS_NOHUGEPAGE:
>>  		madv_action = MADV_NOHUGEPAGE;
>>  		break;
>> +	case DAMOS_COLLAPSE:
>> +		madv_action = MADV_COLLAPSE;
>> +		break;
>>  	case DAMOS_MIGRATE_HOT:
>>  	case DAMOS_MIGRATE_COLD:
>>  		return damos_va_migrate(t, r, scheme, sz_filter_passed);
>> -- 
>> 2.43.0
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


