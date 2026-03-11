Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FCA21125821
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 13:45:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED2346B0088; Wed, 11 Mar 2026 09:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E78C66B0089; Wed, 11 Mar 2026 09:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D599B6B008A; Wed, 11 Mar 2026 09:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A389B6B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:45:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43AFA1601CF
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:45:14 +0000 (UTC)
X-FDA: 84533903748.20.48E44E9
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id 500E840008
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:45:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773236712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p0GQEnmOojhZ2crtcMaz3qNU9XJfPZRSWaczd0xtofA=;
	b=qbhI/T05MnRikQgWD41asr1HSr79IWPncMMpYGQSqzfs9TUR35ZsBXO5+T0/VWLMePdqqi
	Rhb3iJRdGLCwxvnjjEiZEH3ywRVQURDJg1aTUx8B65pmHLmuF4gJENZvE/xCS5yQ/aMZiC
	f5o8NWj81jlCv2pIW/HisHhv9VNURxU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773236712; a=rsa-sha256;
	cv=none;
	b=TzkKWTX6BE0JxIoE7LMdP2J3SGIp+31+Jl/Lv8f6mw/EeCUwz7ZrwgrgRwMYn3B6tP4azu
	JNf1+o7zihgpJ2xmzQMaJKcvDkblInRYaIgsKDKVu+n7KdtpY3dYCLdtORDZWYtzlkgqvN
	VGRMm3E0s4RuFdcdXfJ7Ls2HPNfxRRs=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fWBnl37nczHnGh7;
	Wed, 11 Mar 2026 21:44:59 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 319F640569;
	Wed, 11 Mar 2026 21:45:07 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 11 Mar 2026 16:45:06 +0300
Message-ID: <2895abe3-96f7-4428-8161-a8223ec758b7@huawei-partners.com>
Date: Wed, 11 Mar 2026 16:45:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 3/4] mm/damon: New module with hot application
 detection
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260311041114.91406-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260311041114.91406-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 500E840008
X-Stat-Signature: j4yre93k8bh78n3dys9orqouh37334s6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773236711-299112
X-HE-Meta: U2FsdGVkX1+Fs0SWwp7FA3576Yj1YtlnVlE03BEjr2NnPv9GFLOuOYybL5Fh9fFVlPW1w7lEO6QaB1/Csrv+q1SbVVBvEhY5fn80qhE4G9Kvw3HJXNTB1uq5O5Qzq3iTTwN2AuMxHS5wljmVz/3cS9cH97oPHD/6TxtDDQ1qnigAho/ai06rHFAu/c0czNRknxjILN4sbecAHdVOJIbVkLG7VajBkDwvFA2Qxv9xc/S/r02R3aoCjRfI1tDS3BdrcvX2aTuK1HLhoLWpg6tx4k5sGg1FkxMakdBxvQ1GvCtRsdIYc81CrZpk09k/yvGPjoCWWi98MOQfCVrFmRqq3PlL73AmY9xPMzYYgiNz1oCl2JfMX/is59r5Fu/9B+JgE2J58hUANSeJl8+Lm0uSDB7cE5vu8FeNAz+smLIbDXd06UUDU/AuXqfZiUxptnw8N5bAULdFxTel6/xoK9FgAGh3kPizp2b/iD/TwxnQ19ONRuPztRCuywuHokCNfU4V5c5LV9ol37wROcOuA7bq/EkMG7XqRcX/5hPn77SBzmU86Z6ZNzTCVROXUkFTKl0xq9R160XlGLQcsuNqn+Pf7FEyr06pt+7ARuF0Nne+Pf2U2mwuGxIUrWLqMW0REPP+VfPS8SwQxZsCN1WxqP93dHsHILrg5TAJG/DYt+83M9GaG6/dCqkUiD2NUlPtrlBBv4GAhmR5n+c3AZdt0L2oenPScKtSqWq9CgjeR6uwP+IynlsCWZHzVKDVCnZzxD/D4CfC1W/HBwkqs2XK+Fc6umCcfn5jVBrfnX6iGQQIeCNshLIoDhfAdLdgOVELx7U0ypzpBuCI72BNmJsCjDQJoKSkSct3h2o8QUs98g4ale4RUCrfZbOArIGSYRpVRBV846XceHxqr2egjP7dDyItN7bk2vsgjqYh2suGZvAUDMgrztGtNQ0ywsqOydWDwIVS+ceT0RHKj+O4X9N3ywD
 a8/rJ2s7
 6cK0zf6dAtGWaPjRpJYTa14da3J/ammJaaXfXJJTSRrYean72aOhbGgotSkmJssQVngx45t8FpZJXeh6Bq7ho52cMIfPQd01ulLTMw9A4rbeb7YXdipjovae+m/NkEl315a2RwmzzIqTpC0DIou77rDyWSxpVkRqGG3FxUVGh8oAiefcoThNlkL4PTrxMdp5xBJu3dfdVIeYYD0BNpCEeOnZFqiIdKvGbqji3J6LOP7dsw6yTZ7E3OzPE7ZzlcN2SqmzoFOjFKz/GDT6yI8IPrRvIU8CUvkDNd2VwWapOidKQI/hbuV5Ms6jaULzJbm5YeoI1niBTMXu+ZVc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/11/2026 7:11 AM, SeongJae Park wrote:
> On Tue, 10 Mar 2026 16:24:19 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> I'd like to discuss about this in a high level, but I'd like to do that on the
> cover letter.  To this patch, I'm therefore adding comments for only details
> that stand out immeadiately to me.

I will update the cover letter to add more details for the next version.

>>
>> 1. It first launches a new kthread called damon_dynamic. This thread
>> will behave as a supervisor, launching new kdamond threads for all
>> the processes we want to montiored. The tasks are sorted
>> by utime delta. For the top N tasks, a new kdamond thread will be
>> launched.
> 
> If I read the cover letter and the code of this patch correctly, seems the last
> two sentences of the above paragraph is outdated.  Please correct me if I'm
> wrong.

Correct, I forgot to delete it.

> 
>> Applications which turn cold will have their kdamond
>> stopped.
>>
>> The processes are supplied by the monitored_pids parameter. When the
>> module is enabled, it will go through all the monitored_pids, start
>> the supervisor and a new kdamond thread for each of the tasks. This
>> tasks can be modified and applied using the commit_input parameters.
>> In that case, we will stop any kdamond thread for tasks that are not
>> going to be monitored anymore, and start a new kdamond thread for each
>> new task to be monitored. For tasks that were monitored before and are
>> still monitored after commiting a new monitored_pids list, kdamond
>> threads are left intact.
>>
>> 2. Initially we don't know the min_access for each of the task. We
>> want to find the highest min_access when collapses start happening.
>> For that we have an initial threashold of 90, which we will lower
>> until a collpase occurs.
>>
>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
>> ---
>>  mm/damon/Kconfig          |   7 +
>>  mm/damon/Makefile         |   1 +
>>  mm/damon/hugepage.c (new) | 441 ++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 449 insertions(+)
>>
>> diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
>> index 8c868f7035fc..2355aacb6d12 100644
>> --- a/mm/damon/Kconfig
>> +++ b/mm/damon/Kconfig
>> @@ -110,4 +110,11 @@ config DAMON_STAT_ENABLED_DEFAULT
>>  	  Whether to enable DAMON_STAT by default.  Users can disable it in
>>  	  boot or runtime using its 'enabled' parameter.
>>  
>> +config DAMON_HOT_HUGEPAGE
> 
> I'd suggest renaming to DAMON_HUGEPAGE.

OK

> 
>> +	bool "Build DAMON-based collapse of hot regions (DAMON_HOT_HUGEPAGES)"
>> +	depends on DAMON_VADDR
>> +	help
>> +	 Collapse hot region into huge pages. Hot regions are determined by
>> +	 DAMON-based sampling
>> +
>>  endmenu
>> diff --git a/mm/damon/Makefile b/mm/damon/Makefile
>> index d8d6bf5f8bff..ac3afbc81cc7 100644
>> --- a/mm/damon/Makefile
>> +++ b/mm/damon/Makefile
>> @@ -7,3 +7,4 @@ obj-$(CONFIG_DAMON_SYSFS)	+= sysfs-common.o sysfs-schemes.o sysfs.o
>>  obj-$(CONFIG_DAMON_RECLAIM)	+= modules-common.o reclaim.o
>>  obj-$(CONFIG_DAMON_LRU_SORT)	+= modules-common.o lru_sort.o
>>  obj-$(CONFIG_DAMON_STAT)	+= modules-common.o stat.o
>> +obj-$(CONFIG_DAMON_HOT_HUGEPAGE)	+= modules-common.o hugepage.o
>> diff --git a/mm/damon/hugepage.c b/mm/damon/hugepage.c
>> new file mode 100644
>> index 000000000000..ccd31c48d391
>> --- /dev/null
>> +++ b/mm/damon/hugepage.c
>> @@ -0,0 +1,441 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2026 HUAWEI, Inc.
>> + *             https://www.huawei.com
>> + *
>> + * Author: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> + */
>> +
>> +#define pr_fmt(fmt) "damon-hugepage: " fmt
>> +
>> +#include <linux/damon.h>
>> +#include <linux/kstrtox.h>
>> +#include <linux/module.h>
>> +
>> +#include "modules-common.h"
>> +
>> +#ifdef MODULE_PARAM_PREFIX
>> +#undef MODULE_PARAM_PREFIX
>> +#endif
>> +#define MODULE_PARAM_PREFIX "damon_hugepage."
>> +
>> +#define MAX_MONITORED_PIDS 100
>> +#define HIGHEST_MIN_ACCESS 90
>> +#define HIGH_ACC_THRESHOLD 50
>> +#define MID_ACC_THRESHOLD 15
>> +#define LOW_ACC_THRESHOLD 2
> 
> On your setup where the sampling interval is 5ms and the aggregation interval
> is 100ms, nr_accesses of each DAMON region can be up to only 20.  So above
> thresholds may better to be lowered.
> 
>> +
>> +static struct task_struct *monitor_thread;
>> +
>> +struct mutex enable_disable_lock;
>> +
>> +/*
>> + * Enable or disable DAMON_HUGEPAGE.
>> + *
>> + * You can enable DAMON_HUGEPAGE by setting the value of this parameter
>> + * as ``Y``. Setting it as ``N`` disables DAMON_HOT_HUGEPAGE.  Note that
>> + * DAMON_HOT_HUGEPAGE could do no real monitoring and reclamation due to the
> 
> s/DAMON_HOT_HUGEPAGE/DAMON_HUGEPAGE/ ?

I will change it.

> 
>> + * watermarks-based activation condition.  Refer to below descriptions for the
>> + * watermarks parameter for this.
> 
> On RFC v1 discussion [1], you mentioned you will update this comment.  But I
> find no change?

I will add links to future discuessions.

> 
>> + */
>> +static bool enabled __read_mostly;
>> +
>> +/*
>> + * Make DAMON_HUGEPAGE reads the input parameters again, except ``enabled``.
>> + *
>> + * Input parameters that updated while DAMON_HUGEPAGE is running are not applied
>> + * by default.  Once this parameter is set as ``Y``, DAMON_HUGEPAGE reads values
>> + * of parametrs except ``enabled`` again.  Once the re-reading is done, this
>> + * parameter is set as ``N``.  If invalid parameters are found while the
>> + * re-reading, DAMON_HUGEPAGE will be disabled.
>> + */
>> +static bool commit_inputs __read_mostly;
>> +module_param(commit_inputs, bool, 0600);
>> +
>> +/*
>> + * DAMON_HUGEPAGE monitoring period in microseconds.
>> + * 5000000 = 5s
>> + */
>> +static unsigned long monitor_period __read_mostly = 5000000;
>> +module_param(monitor_period, ulong, 0600);
>> +
>> +static long monitored_pids[MAX_MONITORED_PIDS];
>> +static int num_monitored_pids;
>> +module_param_array(monitored_pids, long, &num_monitored_pids, 0600);
>> +
>> +static struct damos_quota damon_hugepage_quota = {
>> +	/* use up to 10 ms time, reclaim up to 128 MiB per 1 sec by default */
>> +	.ms = 10,
>> +	.sz = 0,
>> +	.reset_interval = 1000,
>> +	/* Within the quota, page out older regions first. */
>> +	.weight_sz = 0,
>> +	.weight_nr_accesses = 0,
>> +	.weight_age = 1
> 
> You may want to prioritize hot memory region under the quota.  If so, you would
> need to set weight_nr_acceses to non-zero.
> 
>> +};
>> +DEFINE_DAMON_MODULES_DAMOS_TIME_QUOTA(damon_hugepage_quota);
>> +
>> +static struct damos_watermarks damon_hugepage_wmarks = {
>> +	.metric = DAMOS_WMARK_FREE_MEM_RATE,
>> +	.interval = 5000000, /* 5 seconds */
>> +	.high = 900, /* 90 percent */
>> +	.mid = 800, /* 80 percent */
>> +	.low = 50, /* 5 percent */
>> +};
>> +DEFINE_DAMON_MODULES_WMARKS_PARAMS(damon_hugepage_wmarks);
> 
> In the RFC v1 discussion, you also mentioned you will remove the above, but
> seems it is forgotten?
> 
> Also, my understadning of your reply on the previous discussion was that you
> don't really want to use watermarks in this module, and therefore you want to
> remove it.  Am I correct?  If I'm not, maybe I'm still not understanding the
> intention of the watermarks.  Can you please enlighten me?

Since I refactored heavily the previous code, I forgot to delete this bit.
I will remove it now.

>> +
>> +static struct damon_attrs damon_hugepage_mon_attrs = {
>> +	.sample_interval = 5000, /* 5 ms */
>> +	.aggr_interval = 100000, /* 100 ms */
>> +	.ops_update_interval = 0,
> 
> Is ops_update_interval = 0 really your intention?

I didn't think about it. I will set it to 60 seconds, as in other modules.

> 
>> +	.min_nr_regions = 10,
>> +	.max_nr_regions = 1000,
>> +};
>> +DEFINE_DAMON_MODULES_MON_ATTRS_PARAMS(damon_hugepage_mon_attrs);
>> +
>> +struct hugepage_task {
>> +	struct damon_ctx *ctx;
>> +	int pid;
>> +	struct damon_target *target;
>> +	struct damon_call_control call_control;
>> +	struct list_head list;
>> +};
>> +
>> +static struct damos *damon_hugepage_new_scheme(int min_access,
>> +						   enum damos_action action)
>> +{
>> +	struct damos_access_pattern pattern = {
>> +		/* Find regions having PAGE_SIZE or larger size */
> 
> s/PAGE_SIZE/PMD_SIZE/ ?
> 
>> +		.min_sz_region = PMD_SIZE,
>> +		.max_sz_region = ULONG_MAX,
>> +		/* and not accessed at all */
> 
> Seems the above comment should be updated.
> 
>> +		.min_nr_accesses = min_access,
>> +		.max_nr_accesses = 100,
> 
> Because you set sampling interval 5ms and aggregatin interval 100ms,
> nr_accesses of each DAMON region can be up to only 20 (100ms / 5ms).
> max_nr_accesses may better to be 20 to clarifyt that.
> 
>> +		/* for min_age or more micro-seconds */
>> +		.min_age_region = 0,
>> +		.max_age_region = UINT_MAX,
>> +	};
>> +
>> +	return damon_new_scheme(
>> +		&pattern,
>> +		/* synchrounous partial collapse as soon as found */
>> +		action, 0,
>> +		/* under the quota. */
>> +		&damon_hugepage_quota,
>> +		/* (De)activate this according to the watermarks. */
>> +		&damon_hugepage_wmarks, NUMA_NO_NODE);
> 
> Again, I'm not sure if you really want to use watermarks, and if so, what is
> the intention.

Right, I will remove this code.

>> +}
>> +
>> +static int damon_hugepage_apply_parameters(
>> +				struct hugepage_task *monitored_task,
>> +				int min_access,
>> +				enum damos_action action)
>> +{
>> +	struct damos *scheme;
>> +	struct damon_ctx *param_ctx;
>> +	struct damon_target *param_target;
>> +	struct damos_filter *filter;
>> +	int err;
>> +	struct pid *spid;
>> +
>> +	err = damon_modules_new_ctx_target(&param_ctx, &param_target,
>> +					   DAMON_OPS_VADDR);
>> +	if (err)
>> +		return err;
> 
> You should deallocate param_ctx before returning the error.

Not sure about this. As far as I know, damon_modules_new_paddr_ctx_target
will destroy the context in case there is an error. In fact, reclaim and 
lru_sort modules just return error when damon_modules_new_paddr_ctx_target
fails, no cleanup used.

> 
>> +
>> +	spid = find_get_pid(monitored_task->pid);
>> +	if (!spid)
>> +		return err;
> 
> Again, please deallocate param_ctx before returning the error.

OK

> 
>> +
>> +	param_target->pid = spid;
>> +
>> +	err = damon_set_attrs(param_ctx, &damon_hugepage_mon_attrs);
>> +	if (err)
>> +		goto out;
>> +
>> +	err = -ENOMEM;
>> +	scheme = damon_hugepage_new_scheme(min_access, action);
>> +	if (!scheme)
>> +		goto out;
>> +
>> +	damon_set_schemes(param_ctx, &scheme, 1);
>> +
>> +	filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true, false);
>> +	if (!filter)
>> +		goto out;
>> +	damos_add_filter(scheme, filter);
> 
> What's the intention of the above filter?

Also, I will remove it.

>> +
>> +	err = damon_commit_ctx(monitored_task->ctx, param_ctx);
>> +out:
>> +	damon_destroy_ctx(param_ctx);
>> +	return err;
>> +}
>> +
>> +static int damon_hugepage_damon_call_fn(void *arg)
>> +{
>> +	struct hugepage_task *monitored_task = arg;
>> +	struct damon_ctx *ctx = monitored_task->ctx;
>> +	struct damos *scheme;
>> +	int err = 0;
>> +	int min_access;
>> +	struct damos_stat stat;
>> +
>> +	damon_for_each_scheme(scheme, ctx)
>> +		stat = scheme->stat;
>> +	scheme = list_first_entry(&ctx->schemes, struct damos, list);
>> +
>> +	if (ctx->passed_sample_intervals < scheme->next_apply_sis)
>> +		return err;
>> +
>> +	if (stat.nr_applied)
>> +		return err;
>> +
>> +	min_access = scheme->pattern.min_nr_accesses;
>> +
>> +	if (min_access > HIGH_ACC_THRESHOLD) {
>> +		min_access = min_access - 10;
>> +		err = damon_hugepage_apply_parameters(
>> +			monitored_task, min_access, DAMOS_COLLAPSE);
>> +	} else if (min_access > MID_ACC_THRESHOLD) {
>> +		min_access = min_access - 5;
>> +		err = damon_hugepage_apply_parameters(
>> +			monitored_task, min_access, DAMOS_COLLAPSE);
>> +	} else if (min_access > LOW_ACC_THRESHOLD) {
>> +		min_access = min_access - 1;
>> +		err = damon_hugepage_apply_parameters(
>> +			monitored_task, min_access, DAMOS_COLLAPSE);
>> +	}
>> +	return err;
>> +}
>> +
>> +static int damon_hugepage_init_task(struct hugepage_task *monitored_task)
>> +{
>> +	int err = 0;
>> +	struct damon_ctx *ctx = monitored_task->ctx;
>> +	struct damon_target *target = monitored_task->target;
>> +	struct pid *spid;
>> +
>> +	if (!ctx || !target)
>> +		damon_modules_new_ctx_target(&ctx, &target, DAMON_OPS_VADDR);
>> +
>> +	if (damon_is_running(ctx))
>> +		return 0;
>> +
>> +	spid = find_get_pid(monitored_task->pid);
>> +	if (!spid)
>> +		return err;
>> +
>> +	target->pid = spid;
>> +
>> +	monitored_task->call_control.fn = damon_hugepage_damon_call_fn;
>> +	monitored_task->call_control.repeat = true;
>> +	monitored_task->call_control.data = monitored_task;
>> +
>> +	struct damos *scheme = damon_hugepage_new_scheme(
>> +			HIGHEST_MIN_ACCESS, DAMOS_COLLAPSE);
>> +	if (!scheme)
>> +		return -ENOMEM;
>> +
>> +	damon_set_schemes(ctx, &scheme, 1);
>> +
>> +	monitored_task->ctx = ctx;
>> +	err = damon_start(&monitored_task->ctx, 1, false);
>> +	if (err)
>> +		return err;
>> +
>> +	return damon_call(monitored_task->ctx, &monitored_task->call_control);
>> +}
>> +
>> +static int add_monitored_task(int pid, struct list_head *task_monitor)
>> +{
>> +	struct hugepage_task *new_hugepage_task;
>> +	int err;
>> +
>> +	new_hugepage_task = kzalloc_obj(*new_hugepage_task);
>> +	if (!new_hugepage_task)
>> +		return -ENOMEM;
>> +
>> +	new_hugepage_task->pid = pid;
>> +	INIT_LIST_HEAD(&new_hugepage_task->list);
>> +	err = damon_hugepage_init_task(new_hugepage_task);
>> +	if (err)
>> +		return err;
>> +	list_add(&new_hugepage_task->list, task_monitor);
>> +	return 0;
>> +}
>> +
>> +static int damon_hugepage_handle_commit_inputs(
>> +		struct list_head *monitored_tasks)
>> +{
>> +	int i = 0;
>> +	int err = 0;
>> +	bool found;
>> +	struct hugepage_task *monitored_task, *tmp;
>> +
>> +	if (!commit_inputs)
>> +		return 0;
>> +
>> +	while (i < MAX_MONITORED_PIDS) {
>> +		if (!monitored_pids[i])
>> +			break;
>> +
>> +		found = false;
>> +
>> +		rcu_read_lock();
>> +		if (!find_vpid(monitored_pids[i])) {
>> +			rcu_read_unlock();
>> +			continue;
>> +		}
>> +
>> +		rcu_read_unlock();
>> +
>> +		list_for_each_entry_safe(monitored_task, tmp, monitored_tasks, list) {
> 
> Please wrap lines for the 80 columns limit.

Interesting, when check it, i was less than 80 columns. Even if I copy this line
and paste it into any text editor, I still get less than 80 characters.

> 
>> +			if (monitored_task->pid == monitored_pids[i]) {
>> +				list_move(&monitored_task->list, monitored_tasks);
>> +				found = true;
>> +				break;
>> +			}
>> +		}
>> +		if (!found) {
>> +			err = add_monitored_task(monitored_pids[i], monitored_tasks);
>> +			/* Skip failed tasks */
>> +			if (err)
>> +				continue;
>> +		}
>> +		i++;
>> +	}
>> +
>> +	i = 0;
>> +	list_for_each_entry_safe(monitored_task, tmp, monitored_tasks, list) {
>> +		i++;
>> +		if (i <= num_monitored_pids)
>> +			continue;
>> +
>> +		err = damon_stop(&monitored_task->ctx, 1);
>> +		damon_destroy_ctx(monitored_task->ctx);
>> +		list_del(&monitored_task->list);
>> +		kfree(monitored_task);
>> +	}
>> +
>> +	commit_inputs = false;
>> +	return err;
>> +}
>> +
>> +static int damon_manager_monitor_thread(void *data)
>> +{
>> +	int err = 0;
>> +	int i;
>> +	struct hugepage_task *entry, *tmp;
>> +
>> +	LIST_HEAD(monitored_tasks);
>> +
>> +	for (i = 0; i < MAX_MONITORED_PIDS; i++) {
>> +		if (!monitored_pids[i])
>> +			break;
>> +
>> +		rcu_read_lock();
>> +		if (!find_vpid(monitored_pids[i])) {
>> +			rcu_read_unlock();
>> +			continue;
>> +		}
>> +		rcu_read_unlock();
>> +
>> +		add_monitored_task(monitored_pids[i], &monitored_tasks);
>> +	}
>> +
>> +
>> +	while (!kthread_should_stop()) {
>> +		schedule_timeout_idle(usecs_to_jiffies(monitor_period));
>> +		err = damon_hugepage_handle_commit_inputs(&monitored_tasks);
>> +		if (err)
>> +			break;
>> +	}
>> +
>> +	list_for_each_entry_safe(entry, tmp, &monitored_tasks, list) {
>> +		err = damon_stop(&entry->ctx, 1);
>> +		damon_destroy_ctx(entry->ctx);
>> +	}
>> +
>> +	for (int i = 0; i < MAX_MONITORED_PIDS;) {
> 
> You can just resue i after initializing here, instead of defining it again.

Again, left overs from the previous refactor. My bad.

> 
>> +		monitored_pids[i] = 0;
>> +		i++;
>> +	}
>> +	return err;
>> +}
>> +
>> +static int damon_hugepage_start_monitor_thread(void)
>> +{
>> +	num_monitored_pids = 0;
>> +	monitor_thread = kthread_create(damon_manager_monitor_thread, NULL,
>> +				 "damon_dynamic");
>> +
>> +	if (IS_ERR(monitor_thread))
>> +		return PTR_ERR(monitor_thread);
>> +
>> +	wake_up_process(monitor_thread);
>> +	return 0;
>> +}
>> +
>> +static int damon_hugepage_turn(bool on)
>> +{
>> +	int err = 0;
>> +
>> +	mutex_lock(&enable_disable_lock);
>> +	if (!on) {
>> +		if (monitor_thread) {
>> +			kthread_stop(monitor_thread);
>> +			monitor_thread = NULL;
>> +		}
>> +		goto out;
>> +	}
>> +	err = damon_hugepage_start_monitor_thread();
>> +out:
>> +	mutex_unlock(&enable_disable_lock);
>> +	return err;
>> +}
>> +
>> +static int damon_hugepage_enabled_store(const char *val,
>> +				const struct kernel_param *kp)
>> +{
>> +	bool is_enabled = enabled;
>> +	bool enable;
>> +	int err;
>> +
>> +	err = kstrtobool(val, &enable);
>> +	if (err)
>> +		return err;
>> +
>> +	if (is_enabled == enable)
>> +		return 0;
>> +
>> +	err = damon_hugepage_turn(enable);
>> +	if (err)
>> +		return err;
>> +
>> +	enabled = enable;
>> +	return err;
>> +}
>> +
>> +static const struct kernel_param_ops enabled_param_ops = {
>> +	.set = damon_hugepage_enabled_store,
>> +	.get = param_get_bool,
>> +};
>> +
>> +module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
>> +MODULE_PARM_DESC(enabled,
>> +	"Enable or disable DAMON_DYNAMIC_HUGEPAGES (default: disabled)");
> 
> s/DYNAMIC_// ?

OK

> 
>> +
>> +static int __init damon_hugepage_init(void)
>> +{
>> +	int err;
>> +
>> +	/* 'enabled' has set before this function, probably via command line */
>> +	if (enabled)
>> +		err = damon_hugepage_turn(true);
>> +
>> +	if (err && enabled)
>> +		enabled = false;
>> +	return err;
>> +}
>> +
>> +module_init(damon_hugepage_init);
>> -- 
>> 2.43.0
> 
> [1] https://lore.kernel.org/00aa6914-8e52-49a2-9875-588efc096c5e@huawei-partners.com
> 
> 
> Thanks,
> SJ
> 

-- 
Asier Gutierrez
Huawei


