Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C53ACD98C7
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 00:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 802F26B0005; Thu, 11 Jun 2026 20:46:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4596B0088; Thu, 11 Jun 2026 20:46:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9706B008C; Thu, 11 Jun 2026 20:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5ABD26B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:46:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D546C1408B3
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:46:55 +0000 (UTC)
X-FDA: 84869420790.24.584DFE4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3D4DE4000B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:46:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h3LTfzHK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781225214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BnweIYH/JMjaDEd73Vn3e0rE2LtQJRp1HCXXBFmLUyA=;
	b=TEi/gNiIiVGOcKZnfUdL2o4HdrdIjwK2ThY5sItRd2dPhbU3hxCEDn9ho75jK4aoATKcw9
	5Kwcm7BZd5TLT2eA9VFOP4s3ZKEsyTQetoykRHQpkxPfUEssf7ei1epqRXveZ11YLEj87c
	vmQuYhwFD7AP+YHUhL1ZLOO3nTrRuCk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h3LTfzHK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781225214;
	b=orw9EwvfMoJYc86uUhSKIMwVfxrG9V747f/AWg1cKpOEpPvV1T6io7VnE2tuzsTv4b9KsO
	9Lu3zxkTeclQYEkOtLzmeJkpKHTImDkcaN5RzBA3sPDmh+17HpDJwzw3cvUl6esB3mDN0g
	9tK/Oj++Sq/j0piHCeJvrBwX32/qCKc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BBC7D600AF;
	Fri, 12 Jun 2026 00:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109251F000E9;
	Fri, 12 Jun 2026 00:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781225213;
	bh=BnweIYH/JMjaDEd73Vn3e0rE2LtQJRp1HCXXBFmLUyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h3LTfzHKMYboINiwd3ooX0j+YhJGwT22FANnXDTJT71maVgr1315v/nDQKPuKU2Ya
	 d+LkcQpjuNMcfZf5INTYE6s4Ny7A5GtKKtLBZOrS4SeSBt7WwHTT8xeB5mIlrM7QtW
	 DsHU2Z5n72H/0Zbmgezm+9tqcF9J3P0FWRVexRdJ84ux88NqBt6c1E+nzA9u0cz7mK
	 9KTDZZU9Us7JA1UY4Ov4Zra7aOXHRsR+mf+qOhGCg68FfduORgPc9B/KzZcyZIFvyi
	 dALlHmfuVQqji9CMATLsPWFOGv1R74UnRsGjXpsHrGd6s3OoYaMP3YQONBaDNN0Aq3
	 5GkfiHmZ5mRUA==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 2/4] mm/damon: introduce DAMON_HUGEPAGE for hot region hugepage collapsing
Date: Thu, 11 Jun 2026 17:46:45 -0700
Message-ID: <20260612004645.83801-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260611150244.3454699-3-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3D4DE4000B
X-Stat-Signature: 49x6ba9zokbrmnwwwfra6ayzjq9z5wwd
X-HE-Tag: 1781225214-549984
X-HE-Meta: U2FsdGVkX181/gXLJ9rlge2UiCVY6iUxNeHNzg2oRAez0oHwKlM8WNUSJUmQxWCp9AyaYq0zSlURL6Z8UKo9ht8UNaXyG2G8T+evTSKpvIQa4OB5oH0j437aa/+zZuerTAk9XysJKfqnApiyYwuF76PHuhNn5DClD7e8kOO3pYCbpp/ratoR3Vb6YaHpMySd577+exlitlH6pljkjMNAAiP4l5zk76YhqmL9pWltVwBko9RHozvatmYakFzfLtKHOmpPC/v7qpyQTFMgb8GTaX3ixrzE+9m1DNcOLzo9vIsRjwKAVuHays0RH6qBsKEMbsEtt4CqHKMJ7gtxkVfs7CO9NTWWGnT9IK7fhcgkBny3dzpHKWsmiUFx7EJYkSC0HkdIrITKzs7y21UhHFGyfHEn13eRw2Yhy14pNJsyi3bEUK4c2ILKD631QEPkCim2mpF3WJ/7XXBglljLsBs1Z0uZgio9Q5l15L4THSEuiuNrM6cORlWsSBkOZJUZq0/IzrOc1LUbnQ/gu60N723CKmCLBq3soZaPdr4CKejFwiS2O4TMHiniQN8+QBe8ZXtgCwZa/wCwlgXdV9CEqmjCOKUexohEazljBPNb0we4eRXHP45T+ADB5cCrNL8IKizgCSTGK/Oy73Q75BpKdGQVq2GJhaTlHR1CpBKoJWoo3tY7thaeztTtMlDsAmZBUGq90DR9+mbMi+Qm3wiVZJ9f4B5/mOmx00v0AkCh27ZBfmu7rEalDf+S3RICVnqMfN+zlxyWSa7tAoFMwjvmQ1+EssA+XrA02blmhDREsuTsJ/OkXhchYSaZQVZm+S+8opgI7k2H4qM834XzbPQD9v6aKmgcnAJnvT/rdmx4kMiGjRZNwWe/twO0bL4TcUG58ibPZ39z+95JfmF9Vbth3EMt/OV5G94/bMQaYIBlbai9otbsA4sLgid+38NVwyYikk9oaLpDzixlcnegyzNj0MS
 TPrVlDdJ
 RDkvs1DWIDqro3p2A66YRfjmqopvo8Un6/O4X12zuUT9XOJe92K4vdBrggRYoNtem85vzm4kScRQFncDJetECuSaM4o01A2S5uCCl+XaDE1qxjPkHkLpydto34vrMRj16AvvGA8t1omnbHyo9DHX+UTH/38sYjPnxICuqMFIyzW1Ln4JKeecbyXa7PNoqXo/Rl8EGn1/FL7TwAOFiHj9bcTQ0EODnSPJX30nVnC5pSZjAnjNraxv4O0JL4PjfmCtki8GrigBSOZa36amLChAPMCf7G6eD1l9VA/MUiI3kHIeHfargbAy+auquf2geF3/0Qwp6+a/57eLn1a/YX5b7NFGqYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Jun 2026 15:02:42 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> This patch introduces a new DAMON module (SAMPLE_DAMON_HUGEPAGE)
> which collapses hot regions into huge pages.

To the previous revision, I suggested SAMPLE_DAMON_HPAGE.  Because you didn't
comment more, I thought my suggestion is accepted.  Can you please elaborate
why you use this name instead of the suggested one?

If there is no special reason, could you please do 's/hugepage/hpage/a' for
this patch?

> 
> SAMPLE_DAMON_HUGEPAGE operates in the virtual memory space, for a
> specific task. The user is expected to supply the PID of the task
> that is going to be monitored through the monitored_pid module
> variable.
> 
> SAMPLE_DAMON_HUGEPAGE uses the hugepage auto-tune mechanism to
> increase or decrease the aggressiveness of page collapsing. User
> autotuning is also available for additional tuning aggressiveness
> control.
> 
> The module also includes changes to the DAMON compilation, so that
> the module can be enabled or disabled.

The above sentence is wrong?

> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> ---
>  samples/damon/Kconfig          |  12 ++
>  samples/damon/Makefile         |   1 +
>  samples/damon/hugepage.c (new) | 207 +++++++++++++++++++++++++++++++++
>  3 files changed, 220 insertions(+)
> 
> diff --git a/samples/damon/Kconfig b/samples/damon/Kconfig
> index cbf96fd8a8bf..512f150aaabb 100644
> --- a/samples/damon/Kconfig
> +++ b/samples/damon/Kconfig
> @@ -40,4 +40,16 @@ config SAMPLE_DAMON_MTIER
>  
>  	  If unsure, say N.
>  
> +config SAMPLE_DAMON_HUGEPAGE
> +	bool "Build DAMON-based collapse of hot regions (SAMPLE_DAMON_HUGEPAGE)"
> +	depends on DAMON && DAMON_VADDR
> +	help
> +	  This module monitors a certain PID provided by the user through
> +	  monitored_pid attribute. Hot regions are determined by DAMON-based

target_pid?

> +	  sampling. Collapsing occurs according to the quota goal using total
> +	  memory usage to huge page usage ratio. The ratio is set by the user
> +	  through a module attribute.
> +
> +	  If unsure, say N.

Please give a simple one sentence at the beginning of the help message, like
other sample modules.

> +
>  endmenu
> diff --git a/samples/damon/Makefile b/samples/damon/Makefile
> index 72f68cbf422a..96bde2c44846 100644
> --- a/samples/damon/Makefile
> +++ b/samples/damon/Makefile
> @@ -3,3 +3,4 @@
>  obj-$(CONFIG_SAMPLE_DAMON_WSSE) += wsse.o
>  obj-$(CONFIG_SAMPLE_DAMON_PRCL) += prcl.o
>  obj-$(CONFIG_SAMPLE_DAMON_MTIER) += mtier.o
> +obj-$(CONFIG_SAMPLE_DAMON_HUGEPAGE)	+= hugepage.o
> diff --git a/samples/damon/hugepage.c b/samples/damon/hugepage.c
> new file mode 100644
> index 000000000000..2c7fd213a8db
> --- /dev/null
> +++ b/samples/damon/hugepage.c
> @@ -0,0 +1,207 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2026 HUAWEI, Inc.
> + *             https://www.huawei.com
> + *
> + * Author: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> + */
> +
> +#define pr_fmt(fmt) "damon_sample_hugepage: " fmt
> +
> +#include <linux/damon.h>
> +#include <linux/kstrtox.h>
> +#include <linux/module.h>
> +
> +#ifdef MODULE_PARAM_PREFIX
> +#undef MODULE_PARAM_PREFIX
> +#endif
> +#define MODULE_PARAM_PREFIX "damon_sample_hugepage."
> +
> +static bool enabled __read_mostly;
> +
> +static unsigned long target_pid;
> +module_param(target_pid, ulong, 0600);
> +
> +/* By default, total huge pages to system memory usage ratio set to 10% */
> +static unsigned long quota_percentage_hugepage __read_mostly = 1000;
> +module_param(quota_percentage_hugepage, ulong, 0600);
> +
> +static unsigned long quota_autotune_feedback __read_mostly;
> +module_param(quota_autotune_feedback, ulong, 0600);
> +
> +static struct damon_ctx *ctx;
> +static struct pid *target_pidp;
> +
> +static int damon_sample_hugepage_damon_call_fn(void *data)
> +{
> +	struct damon_ctx *c = data;
> +	struct damon_target *t;
> +
> +	damon_for_each_target(t, c) {
> +		struct damon_region *r;
> +		unsigned long hugepages = 0;
> +
> +		damon_for_each_region(r, t) {
> +			if (r->nr_accesses > 0)
> +				hugepages += r->ar.end - r->ar.start;
> +		}
> +		hugepages = hugepages / HPAGE_PMD_SIZE;
> +		pr_info("hugepage: %lu\n", hugepages);
> +	}
> +	return 0;
> +}
> +
> +static struct damon_call_control call_control = {
> +	.fn = damon_sample_hugepage_damon_call_fn,
> +	.repeat = true,
> +};
> +
> +static int damon_sample_hugepage_start(void)
> +{
> +	int err;
> +	struct damon_target *target;
> +	struct damos *scheme;
> +	struct damos_quota_goal *goal;
> +
> +	pr_info("start\n");
> +
> +
> +	ctx = damon_new_ctx();
> +	if (!ctx)
> +		return -ENOMEM;
> +	if (damon_select_ops(ctx, DAMON_OPS_VADDR)) {
> +		damon_destroy_ctx(ctx);
> +		return -EINVAL;
> +	}
> +
> +	target = damon_new_target();
> +	if (!target) {
> +		damon_destroy_ctx(ctx);
> +		return -ENOMEM;
> +	}
> +	damon_add_target(ctx, target);
> +	target_pidp = find_get_pid(target_pid);
> +	if (!target_pidp) {
> +		damon_destroy_ctx(ctx);
> +		return -EINVAL;
> +	}
> +	target->pid = target_pidp;
> +
> +	scheme = damon_new_scheme(&(struct damos_access_pattern) {
> +				.min_sz_region = HPAGE_PMD_SIZE,
> +				.max_sz_region = ULONG_MAX,
> +				.min_nr_accesses = 0,
> +				.max_nr_accesses = UINT_MAX,
> +				.min_age_region = 50,
> +				.max_age_region = UINT_MAX},
> +				DAMOS_COLLAPSE, 0,
> +				&(struct damos_quota) {
> +				.ms = 10,
> +				.sz = 128 * 1024 * 1024,
> +				.reset_interval = 1000,
> +				.weight_sz = 0,
> +				.weight_nr_accesses = 1,
> +				.weight_age = 1,
> +				.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL},
> +				&(struct damos_watermarks){}, NUMA_NO_NODE);
> +	if (!scheme) {
> +		damon_destroy_ctx(ctx);
> +		return -ENOMEM;
> +	}
> +	damon_set_schemes(ctx, &scheme, 1);
> +	goal = damos_new_quota_goal(DAMOS_QUOTA_HUGEPAGE_MEM_BP,
> +				quota_percentage_hugepage);
> +	if (!goal) {
> +		damon_destroy_ctx(ctx);
> +		return -ENOMEM;
> +	}
> +	damos_add_quota_goal(&scheme->quota, goal);
> +
> +	if (quota_autotune_feedback) {
> +		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
> +		if (!goal) {
> +			damon_destroy_ctx(ctx);
> +			return -ENOMEM;
> +		}
> +		goal->current_value = quota_autotune_feedback;
> +		damos_add_quota_goal(&scheme->quota, goal);
> +	}
> +
> +	err = damon_start(&ctx, 1, true);
> +	if (err) {
> +		damon_destroy_ctx(ctx);
> +		return err;
> +	}
> +
> +	call_control.data = ctx;
> +	err = damon_call(ctx, &call_control);
> +	if (err) {
> +		damon_stop(&ctx, 1);
> +		damon_destroy_ctx(ctx);
> +	}
> +	return err;
> +}
> +
> +static void damon_sample_hugepage_stop(void)
> +{
> +	pr_info("stop\n");
> +	if (ctx) {
> +		damon_stop(&ctx, 1);
> +		damon_destroy_ctx(ctx);
> +	}
> +}
> +static int damon_sample_hugepage_enabled_store(const char *val,
> +				const struct kernel_param *kp)
> +{
> +	bool is_enabled = enabled;
> +	int err;
> +
> +	err = kstrtobool(val, &enabled);
> +	if (err)
> +		return err;
> +
> +	if (enabled == is_enabled)
> +		return 0;
> +
> +	if (!damon_initialized())
> +		return 0;
> +
> +	if (enabled) {
> +		err = damon_sample_hugepage_start();
> +		if (err)
> +			enabled = false;
> +		return err;
> +	}
> +	damon_sample_hugepage_stop();
> +	return 0;
> +}
> +
> +static const struct kernel_param_ops enabled_param_ops = {
> +	.set = damon_sample_hugepage_enabled_store,
> +	.get = param_get_bool,
> +};
> +
> +module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
> +MODULE_PARM_DESC(enabled,
> +	"Enable or disable DAMON_HUGEPAGE (default: disabled)");
> +
> +static int __init damon_sample_hugepage_init(void)
> +{
> +	int err = 0;
> +
> +	if (!damon_initialized()) {
> +		if (enabled)
> +			enabled = false;
> +		pr_warn("Module not initialized\n");
> +		return -ENOMEM;
> +	}
> +
> +	if (enabled) {
> +		err = damon_sample_hugepage_start();
> +		if (err)
> +			enabled = false;
> +	}
> +	return err;
> +}
> +
> +module_init(damon_sample_hugepage_init);
> -- 
> 2.43.0

Looks good overall, except the name that is not consistent to other sample
modules.

The wrong sentence in the commit message makes me feel this patch is not really
ready for a review of details, though.  I therefore skipped reviewing each
details.  Could you plese thoroughly check details in the next revision?  I
will reiterate more details in the next revision, then.


Thanks,
SJ

