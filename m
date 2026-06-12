Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72354CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 19:41:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4B7B6B00A2; Fri, 12 Jun 2026 15:41:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22D26B00A4; Fri, 12 Jun 2026 15:41:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38F16B00A5; Fri, 12 Jun 2026 15:41:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92B1E6B00A2
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:41:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 309484021A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:41:47 +0000 (UTC)
X-FDA: 84872280654.23.AE368C5
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id DAA621C000B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:41:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf21.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781293305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PLnccTUK/2Ohma9qh2Sl//YknfHTeFcH/15bVGwPrUY=;
	b=TkPGlWtsfM3cgd8wqSPIaFFvHYFkZZ6D21ETtMxHyXf9phYiWgPD1AKZdRfAzKzSPhIrga
	Rebsi9trJkQ4U8qF0+b9+eAh4eUo6UN5AK42ajs3hE35rDjfKVO3DlzTJ29TGxgxqQtQ3G
	sRbtlPIE8HSAxNf5qRTgBzGiiStD3sI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf21.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781293305;
	b=pj/w8hBP/g0HZ1NSJsnmBF13xvYw5O5nTkvovwxBrA53XYOTrNdmzi92FikkIN2SlVpzHj
	x0Qp+/FVdYPy2ukuYrtqbdea36QwECygDaa3ebf4dmWzigSw3ysJivUhCfkz1kZ9L1wegm
	TvRhKgD3CmLG9Psp1CckUEnAZIi42zM=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gcVJD6VcvzHnGd6;
	Sat, 13 Jun 2026 03:41:32 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id D613A40584;
	Sat, 13 Jun 2026 03:41:41 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 12 Jun 2026 22:41:41 +0300
Message-ID: <bc56417c-aa05-4a93-a098-62bcd805628a@huawei-partners.com>
Date: Fri, 12 Jun 2026 22:41:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 2/4] mm/damon: introduce DAMON_HUGEPAGE for hot
 region hugepage collapsing
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260612004645.83801-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260612004645.83801-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: DAA621C000B
X-Rspam-User: 
X-Stat-Signature: jwqm6bypje9xihgmfqx7kkbwks1axkfe
X-Rspamd-Server: rspam09
X-HE-Tag: 1781293304-343075
X-HE-Meta: U2FsdGVkX19XgzFmQP0XEN1j4Cio6Sa7Uf2/M/q1mDUtcaNjtTeehp5EZchOXWgneL4FYvCVB3pF0elcJ5MLQQhrL9mmH8EmDv5u6pwm6fYVWH98dp2OsMp4V40K2HSOs9sQASdBx5ErcEncHTvFGhP8MbLwP01GBonykIwt4sRr0qEDSmwZIuhm7f5cLV8fxU9J3he9l3est10UUp+uJkq8IH27GOrET2FFP9HiuG77rMiy5sJZ6Q23i1/Vk92I7B35vOrrvNaFAT/BKEqNdBa8UpoIjm5ZU2yuzO5pDtipq9XVOBLAsrH7Rz8gHaJspb/BaMTeZZ+RMlN9y9cdjp50Hjlon3fZAOWKUdokHEN2piwMFBrGz8hwBVvyjIPtZ/3wMsdnbts70ybU2OgfnKCNCdIyAhGpYhdNgHqRlW1NbTABpg2hYYZrGlpXNsy76/MtDjT0M2eQBOfGWN6D/MkFx0E14EbURXrjQY6i+Sv3ARFvf30ecGF91IegYvz5Jqg6vfXEj4noPfEyBVB/0+CSkqXVY00jE8lEA4RgMx1EeZYqLYoeq9laVgyRUi1+ju1ZP4Sw0uHoS3e8uIFy/dCjilqZtMBnOI/aJeP8hhe85hQtZ2ssox8p3qHZIW8hGPDDpK0+rlNtC8319X1XIeAYscup15Pf8lTvRz5FkSR39oLxe4iIiPYBl5iP+VdLFCGiJqkUALDjJKulfEpEfKoiob19ZJSfOtRNE9N6g60jAYCcL86dxaw/gubwW/JVR51QHWUCDyPA/OhQGP9qmSCdqaICfVu+xXv/FVOweQezUjV8ggKAmDXiykBHNQekb2xMndxmMZ91Xxnb6P5KAy271lLuiXzGk7YMAzJOrJ/kV2//vtE3pzrZJ3NwdO5+YWFtkyXqjJ5tG8AJnDzFqaeH605OwhazeaQop5iCVX9XKqmGCkJAlcMsjEouDW9aKPdMqsoJeT6r7W3AWsm
 KAsbxFfd
 /UPtmi60neicxEKj30wHcV9lBJ8l9GILImMyU6cAEd4bGADoPjK0AaO8Hu6cS0jr+AzyUwjR1FxeZg5YqZ4v9I8MDibQeFefwPo5Ocj4JyqAouVYMTskslQzQsCoVjPp/EwDTtT6ffN3UMTjhwO4zZLP9oYoalZdlISgrIkFDlukRH5Qj0hHeSREpRn9gMjcTScBsvxA8tzEygOF2lO7Mfp5yrdyW/C8MuiNPiO+1+0zkFfVy6XHY9sQi4uKGKUMAQDsaNVmhgGxi1vAczuo1eHphszbyYH12WzNMM4fekU3ivjn71XIvkeABh6IF/XOIEeu9WabFPD8F9f7Psxg82kPA6BcY0FlCuSGTVr4BJgnFqvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/12/2026 3:46 AM, SeongJae Park wrote:
> On Thu, 11 Jun 2026 15:02:42 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> This patch introduces a new DAMON module (SAMPLE_DAMON_HUGEPAGE)
>> which collapses hot regions into huge pages.
> 
> To the previous revision, I suggested SAMPLE_DAMON_HPAGE.  Because you didn't
> comment more, I thought my suggestion is accepted.  Can you please elaborate
> why you use this name instead of the suggested one?
> 
> If there is no special reason, could you please do 's/hugepage/hpage/a' for
> this patch?
I thought hugepage should be fine. I'll rename it.
>>
>> SAMPLE_DAMON_HUGEPAGE operates in the virtual memory space, for a
>> specific task. The user is expected to supply the PID of the task
>> that is going to be monitored through the monitored_pid module
>> variable.
>>
>> SAMPLE_DAMON_HUGEPAGE uses the hugepage auto-tune mechanism to
>> increase or decrease the aggressiveness of page collapsing. User
>> autotuning is also available for additional tuning aggressiveness
>> control.
>>
>> The module also includes changes to the DAMON compilation, so that
>> the module can be enabled or disabled.
> 
> The above sentence is wrong?
> 
>>
>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> ---
>>  samples/damon/Kconfig          |  12 ++
>>  samples/damon/Makefile         |   1 +
>>  samples/damon/hugepage.c (new) | 207 +++++++++++++++++++++++++++++++++
>>  3 files changed, 220 insertions(+)
>>
>> diff --git a/samples/damon/Kconfig b/samples/damon/Kconfig
>> index cbf96fd8a8bf..512f150aaabb 100644
>> --- a/samples/damon/Kconfig
>> +++ b/samples/damon/Kconfig
>> @@ -40,4 +40,16 @@ config SAMPLE_DAMON_MTIER
>>  
>>  	  If unsure, say N.
>>  
>> +config SAMPLE_DAMON_HUGEPAGE
>> +	bool "Build DAMON-based collapse of hot regions (SAMPLE_DAMON_HUGEPAGE)"
>> +	depends on DAMON && DAMON_VADDR
>> +	help
>> +	  This module monitors a certain PID provided by the user through
>> +	  monitored_pid attribute. Hot regions are determined by DAMON-based
> 
> target_pid?
Right, I renamed the parameter in the module but not in the config. I'll change it.
>> +	  sampling. Collapsing occurs according to the quota goal using total
>> +	  memory usage to huge page usage ratio. The ratio is set by the user
>> +	  through a module attribute.
>> +
>> +	  If unsure, say N.
> 
> Please give a simple one sentence at the beginning of the help message, like
> other sample modules.
OK, I will do it.
>> +
>>  endmenu
>> diff --git a/samples/damon/Makefile b/samples/damon/Makefile
>> index 72f68cbf422a..96bde2c44846 100644
>> --- a/samples/damon/Makefile
>> +++ b/samples/damon/Makefile
>> @@ -3,3 +3,4 @@
>>  obj-$(CONFIG_SAMPLE_DAMON_WSSE) += wsse.o
>>  obj-$(CONFIG_SAMPLE_DAMON_PRCL) += prcl.o
>>  obj-$(CONFIG_SAMPLE_DAMON_MTIER) += mtier.o
>> +obj-$(CONFIG_SAMPLE_DAMON_HUGEPAGE)	+= hugepage.o
>> diff --git a/samples/damon/hugepage.c b/samples/damon/hugepage.c
>> new file mode 100644
>> index 000000000000..2c7fd213a8db
>> --- /dev/null
>> +++ b/samples/damon/hugepage.c
>> @@ -0,0 +1,207 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2026 HUAWEI, Inc.
>> + *             https://www.huawei.com
>> + *
>> + * Author: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> + */
>> +
>> +#define pr_fmt(fmt) "damon_sample_hugepage: " fmt
>> +
>> +#include <linux/damon.h>
>> +#include <linux/kstrtox.h>
>> +#include <linux/module.h>
>> +
>> +#ifdef MODULE_PARAM_PREFIX
>> +#undef MODULE_PARAM_PREFIX
>> +#endif
>> +#define MODULE_PARAM_PREFIX "damon_sample_hugepage."
>> +
>> +static bool enabled __read_mostly;
>> +
>> +static unsigned long target_pid;
>> +module_param(target_pid, ulong, 0600);
>> +
>> +/* By default, total huge pages to system memory usage ratio set to 10% */
>> +static unsigned long quota_percentage_hugepage __read_mostly = 1000;
>> +module_param(quota_percentage_hugepage, ulong, 0600);
>> +
>> +static unsigned long quota_autotune_feedback __read_mostly;
>> +module_param(quota_autotune_feedback, ulong, 0600);
>> +
>> +static struct damon_ctx *ctx;
>> +static struct pid *target_pidp;
>> +
>> +static int damon_sample_hugepage_damon_call_fn(void *data)
>> +{
>> +	struct damon_ctx *c = data;
>> +	struct damon_target *t;
>> +
>> +	damon_for_each_target(t, c) {
>> +		struct damon_region *r;
>> +		unsigned long hugepages = 0;
>> +
>> +		damon_for_each_region(r, t) {
>> +			if (r->nr_accesses > 0)
>> +				hugepages += r->ar.end - r->ar.start;
>> +		}
>> +		hugepages = hugepages / HPAGE_PMD_SIZE;
>> +		pr_info("hugepage: %lu\n", hugepages);
>> +	}
>> +	return 0;
>> +}
>> +
>> +static struct damon_call_control call_control = {
>> +	.fn = damon_sample_hugepage_damon_call_fn,
>> +	.repeat = true,
>> +};
>> +
>> +static int damon_sample_hugepage_start(void)
>> +{
>> +	int err;
>> +	struct damon_target *target;
>> +	struct damos *scheme;
>> +	struct damos_quota_goal *goal;
>> +
>> +	pr_info("start\n");
>> +
>> +
>> +	ctx = damon_new_ctx();
>> +	if (!ctx)
>> +		return -ENOMEM;
>> +	if (damon_select_ops(ctx, DAMON_OPS_VADDR)) {
>> +		damon_destroy_ctx(ctx);
>> +		return -EINVAL;
>> +	}
>> +
>> +	target = damon_new_target();
>> +	if (!target) {
>> +		damon_destroy_ctx(ctx);
>> +		return -ENOMEM;
>> +	}
>> +	damon_add_target(ctx, target);
>> +	target_pidp = find_get_pid(target_pid);
>> +	if (!target_pidp) {
>> +		damon_destroy_ctx(ctx);
>> +		return -EINVAL;
>> +	}
>> +	target->pid = target_pidp;
>> +
>> +	scheme = damon_new_scheme(&(struct damos_access_pattern) {
>> +				.min_sz_region = HPAGE_PMD_SIZE,
>> +				.max_sz_region = ULONG_MAX,
>> +				.min_nr_accesses = 0,
>> +				.max_nr_accesses = UINT_MAX,
>> +				.min_age_region = 50,
>> +				.max_age_region = UINT_MAX},
>> +				DAMOS_COLLAPSE, 0,
>> +				&(struct damos_quota) {
>> +				.ms = 10,
>> +				.sz = 128 * 1024 * 1024,
>> +				.reset_interval = 1000,
>> +				.weight_sz = 0,
>> +				.weight_nr_accesses = 1,
>> +				.weight_age = 1,
>> +				.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL},
>> +				&(struct damos_watermarks){}, NUMA_NO_NODE);
>> +	if (!scheme) {
>> +		damon_destroy_ctx(ctx);
>> +		return -ENOMEM;
>> +	}
>> +	damon_set_schemes(ctx, &scheme, 1);
>> +	goal = damos_new_quota_goal(DAMOS_QUOTA_HUGEPAGE_MEM_BP,
>> +				quota_percentage_hugepage);
>> +	if (!goal) {
>> +		damon_destroy_ctx(ctx);
>> +		return -ENOMEM;
>> +	}
>> +	damos_add_quota_goal(&scheme->quota, goal);
>> +
>> +	if (quota_autotune_feedback) {
>> +		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
>> +		if (!goal) {
>> +			damon_destroy_ctx(ctx);
>> +			return -ENOMEM;
>> +		}
>> +		goal->current_value = quota_autotune_feedback;
>> +		damos_add_quota_goal(&scheme->quota, goal);
>> +	}
>> +
>> +	err = damon_start(&ctx, 1, true);
>> +	if (err) {
>> +		damon_destroy_ctx(ctx);
>> +		return err;
>> +	}
>> +
>> +	call_control.data = ctx;
>> +	err = damon_call(ctx, &call_control);
>> +	if (err) {
>> +		damon_stop(&ctx, 1);
>> +		damon_destroy_ctx(ctx);
>> +	}
>> +	return err;
>> +}
>> +
>> +static void damon_sample_hugepage_stop(void)
>> +{
>> +	pr_info("stop\n");
>> +	if (ctx) {
>> +		damon_stop(&ctx, 1);
>> +		damon_destroy_ctx(ctx);
>> +	}
>> +}
>> +static int damon_sample_hugepage_enabled_store(const char *val,
>> +				const struct kernel_param *kp)
>> +{
>> +	bool is_enabled = enabled;
>> +	int err;
>> +
>> +	err = kstrtobool(val, &enabled);
>> +	if (err)
>> +		return err;
>> +
>> +	if (enabled == is_enabled)
>> +		return 0;
>> +
>> +	if (!damon_initialized())
>> +		return 0;
>> +
>> +	if (enabled) {
>> +		err = damon_sample_hugepage_start();
>> +		if (err)
>> +			enabled = false;
>> +		return err;
>> +	}
>> +	damon_sample_hugepage_stop();
>> +	return 0;
>> +}
>> +
>> +static const struct kernel_param_ops enabled_param_ops = {
>> +	.set = damon_sample_hugepage_enabled_store,
>> +	.get = param_get_bool,
>> +};
>> +
>> +module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
>> +MODULE_PARM_DESC(enabled,
>> +	"Enable or disable DAMON_HUGEPAGE (default: disabled)");
>> +
>> +static int __init damon_sample_hugepage_init(void)
>> +{
>> +	int err = 0;
>> +
>> +	if (!damon_initialized()) {
>> +		if (enabled)
>> +			enabled = false;
>> +		pr_warn("Module not initialized\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	if (enabled) {
>> +		err = damon_sample_hugepage_start();
>> +		if (err)
>> +			enabled = false;
>> +	}
>> +	return err;
>> +}
>> +
>> +module_init(damon_sample_hugepage_init);
>> -- 
>> 2.43.0
> 
> Looks good overall, except the name that is not consistent to other sample
> modules.
> 
> The wrong sentence in the commit message makes me feel this patch is not really
> ready for a review of details, though.  I therefore skipped reviewing each
> details.  Could you plese thoroughly check details in the next revision?  I
> will reiterate more details in the next revision, then.
OK
> 
> Thanks,
> SJ
> 

-- 
Asier Gutierrez
Huawei


