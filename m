Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04C7ACD98E1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 04:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E36516B00A2; Wed, 17 Jun 2026 00:05:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0D9B6B00A4; Wed, 17 Jun 2026 00:05:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5A56B00A5; Wed, 17 Jun 2026 00:05:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4E76B00A2
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 00:05:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0409B1202D9
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:05:00 +0000 (UTC)
X-FDA: 84888064002.09.7401550
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 546D780004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:04:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AKPH2dow;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781669099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CzwO8wyPCbgXUfabywX6hMjgq1NpqudjdbpQdWLuUA0=;
	b=WExnoNaIDgLOG/T+of/pW2N2NNLqjMkClYHRGMDQlLYZod8vCL1V/BbktW5sVhW3JZJbDZ
	auXDReqZKgaTVYVA7zrHwej2QbzOIIVlwiIrteaTfdNmxcixc5n2wd55suBauTlXo+6tE0
	lVsdJNj13167Wndl7QsWT/NFgN8UEJ4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AKPH2dow;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781669099;
	b=qFhIUJv/k+z3e9HFnEamwRp8G8vYxyuUmZn7/CYiMkddy2O2noASXy7vfoZiO4Fe23STsb
	SkJ6XW5cMZDOG0VLguI1ps1BLuiJkZcz/8fWH9/vT655yMivfmVJfbucR26TH0qFrTFYa3
	Q4etaKwSkchsAj3dM04VFjSgh2E3YQU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80699432E9;
	Wed, 17 Jun 2026 04:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8637A1F000E9;
	Wed, 17 Jun 2026 04:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781669098;
	bh=CzwO8wyPCbgXUfabywX6hMjgq1NpqudjdbpQdWLuUA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AKPH2dowmgNQUhdAg8e2TmF2PdIYeK5R1BxU5ykQ1VRs0/4eb3oPKcuL/uZRnY7Ph
	 egEHJSQSc//qPYth6kzOqHh2Tjc1EFix+p79K7uaxY7aauL+EJYdLY8YW0ukrKga2s
	 1RSjtsHo02A1E3JwhyKnrVjb5x02w25adiLF6YTpQTc4gaWxN6BuqX075zuo47a+ZK
	 03HAxKQSxveCXVYnRdzTzyrFKmpgW4vRIH5hm3IzjpdxbQbABx0dz5XBhJI4BVKzMf
	 y0hRYJ9TdSkaQYBoinnNAGxfJF6sMPC3/yL90CRYwiQ67nKI+M//AUkVbWhDSER9Uz
	 odxPNMt3JnjIw==
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
Subject: Re: [PATCH v1 2/3] mm/damon: introduce DAMON_HUGEPAGE for hot region hugepage collapsing
Date: Tue, 16 Jun 2026 21:04:52 -0700
Message-ID: <20260617040452.98621-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260616150316.580819-3-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: iotxi1z8yrby64qp38iux9999gk6n7zi
X-Rspamd-Queue-Id: 546D780004
X-HE-Tag: 1781669099-478896
X-HE-Meta: U2FsdGVkX1/LCkk/3ZU/drqAgiq2f+tHpslQR9bi7bOAhL8dMEDfgeMPCUNJmlxWu4sdM0sAMaKf5+ClFXf0l1Ps7IgjsMeqaJmWAxIzJ2iWhhiYoxw0sRE8kcsRiYBzoB9ir63RuxWd6za33MBxmw+BzvFVc8VRg9OQJFij66XvSt8QzN6vWHydtU/YIPykB+SVPX1UqcVOac1ZivVb0SN38+bcdjaENUBXwLBoNUlJnSMtpwQlYshtH4uHCDzykAjx9Tm+s/oeo+YBowHniuY1mXARy0o7uXwEyN3hfKFOqq1sJmAQRsNTADIYS1gaACdSz6T7PkVavrWOTXAIPksgGkQtDUBuyyvdL6+fJn4mOt3Fn7aAD661wQ5Du9mpeeTuPc7GEjIz5+LVD2ju6zlCbH8mWolWNqB3oQI8eY34ZUuLwqgT/gQ1Qv6w0+yd8rAvCCxV8TKIa3ecdq07DM+eWs7JIvV4eqPcF0vggBSOoCZifLFL8Adsalh/hpye5lPm2XJkGUy/CXZrnX13gNxY5y9c5hoEZ8r71bez2K9NelfSQo6RoqF9H5ntmTziJgAN8laXYbvnLtOevIcyUVq+DHUaT8CFSfnESEZV3dBtPZHmVA1dXsAHfGooSPCXe+CLNff5jZd79TG8fDlZF7Bt2lnSHSgxUU/EYRodvsc5nid4gv5HYYxmzErXD3LamXGwtUlRttO45zrc3N49UC6neOE2Kx4BOpno113MGVxEnNPDnNeEhwojm3n7G26uZ4IKBQNqlOiVtP0flUyG/ad9sOjh0HFMV6/HzcClwOugIH51ZN6XwwRvUsHvRhObpJ5hlIUMWx1jrkgglTa2i3NpH8+z8Ep5mUwIBw/Cs2WGj/8Kj1rbBoCzmW8n69PPsyp29uCYYA2zqltlbGO3SMtCDnxMUeRLandoWjgtt+4SYP8ZQlo5hnj1RInzZzGGON5c0+6WJJmin+xDtWe
 2NgWQU2m
 VJ2NMEhKsVkLLsJKG7kY6njPUmYzzIL3as4ZNSZ0/xVbIH8+opiZNKvSUDhA0OZhu0rI/kyjpmQ/9grEYQ7vKUSGcaWS2u1W1k/VT5oRbX6qWAs417u0Eic+G5JRXPgMXXmm5g+Fs+3LcR08xaAreHKmDoOdNh3dMSByzNg5OeqzMaExleb7huotYB/BxTDjSp5rVOCrR3HFOezjxND61dnpG5KybknZ1bkLP5/xsUNB3s02RxWxW7YLUkMk1wSAqvyiKm17pP2yCyMC7FzQCSK1EOhMZ4ypPPHzfYfoTduFqpq83SwkP+9AuacYF+22nBzVz18ndqOOduZNBioc1M0UNZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Jun 2026 15:03:15 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> This patch introduces a new DAMON module (SAMPLE_DAMON_HPAGE)
> which collapses hot regions into huge pages.
> 
> SAMPLE_DAMON_HPAGE operates in the virtual memory space, for a
> specific task. The user is expected to supply the PID of the task
> that is going to be monitored through the target_pid module
> variable.

s/variable/parameter/ ?

> 
> SAMPLE_DAMON_HPAGE uses the hugepage auto-tune mechanism to
> increase or decrease the aggressiveness of page collapsing. User
> autotuning is also available for additional tuning aggressiveness
> control.

Is the user autotuning really needed for this sample module?  I'm concerned if
it is unnecessarily making the code complicated.  Can we drop this?

> 
> The module also includes changes to the DAMON compilation,

I think this is not true?

> so that
> the module can be enabled or disabled.
> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> ---
>  samples/damon/Kconfig       |  14 +++
>  samples/damon/Makefile      |   1 +
>  samples/damon/hpage.c (new) | 207 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 222 insertions(+)
> 
> diff --git a/samples/damon/Kconfig b/samples/damon/Kconfig
> index cbf96fd8a8bf..1ef0b12c32e6 100644
> --- a/samples/damon/Kconfig
> +++ b/samples/damon/Kconfig
> @@ -40,4 +40,18 @@ config SAMPLE_DAMON_MTIER
>  
>  	  If unsure, say N.
>  
> +config SAMPLE_DAMON_HPAGE
> +	bool "Build DAMON-based collapse of hot regions (SAMPLE_DAMON_HPAGE)"

Please make this be consistent to other sample modules.  E.g., DAMON sample
module for ...

> +	depends on DAMON && DAMON_VADDR && TRANSPARENT_HUGEPAGE
> +	help
> +	  This builds DAMON sample module for collapsing regions into huge pages.

... for huge pages collapsing?

> +
> +	  This module monitors a certain PID provided by the user through
> +	  target_pid attribute. Hot regions are determined by DAMON-based

Please use two spaces between sentences, consistent to others.

> +	  sampling. Collapsing occurs according to the quota goal using total

"DAMON-based sampling" sounds verbose and technically not making much sense.
How about just "DAMON"?

> +	  memory usage to huge page usage ratio. The ratio is set by the user

huge page to total memory usage ratio?

> +	  through a module attribute.

s/attribute/parameter/ ?

> +
> +	  If unsure, say N.
> +
>  endmenu
> diff --git a/samples/damon/Makefile b/samples/damon/Makefile
> index 72f68cbf422a..a348dc74ddcb 100644
> --- a/samples/damon/Makefile
> +++ b/samples/damon/Makefile
> @@ -3,3 +3,4 @@
>  obj-$(CONFIG_SAMPLE_DAMON_WSSE) += wsse.o
>  obj-$(CONFIG_SAMPLE_DAMON_PRCL) += prcl.o
>  obj-$(CONFIG_SAMPLE_DAMON_MTIER) += mtier.o
> +obj-$(CONFIG_SAMPLE_DAMON_HUGEPAGE) += hpage.o

... Can this be compiled...?

> diff --git a/samples/damon/hpage.c b/samples/damon/hpage.c
> new file mode 100644
> index 000000000000..ebbe5e1be1a1
> --- /dev/null
> +++ b/samples/damon/hpage.c
> @@ -0,0 +1,207 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2026 HUAWEI, Inc.
> + *             https://www.huawei.com
> + *
> + * Author: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> + */
> +
> +#define pr_fmt(fmt) "damon_sample_hpage: " fmt
> +
> +#include <linux/damon.h>
> +#include <linux/kstrtox.h>
> +#include <linux/module.h>
> +
> +#ifdef MODULE_PARAM_PREFIX
> +#undef MODULE_PARAM_PREFIX
> +#endif
> +#define MODULE_PARAM_PREFIX "damon_sample_hpage."
> +
> +static bool enabled __read_mostly;
> +
> +static unsigned long target_pid;
> +module_param(target_pid, ulong, 0600);

Why 'ulong'?  I think 'int' is enough?

> +
> +/* By default, total huge pages to system memory usage ratio set to 10% */
> +static unsigned long quota_percentage_hugepage __read_mostly = 1000;
> +module_param(quota_percentage_hugepage, ulong, 0600);

"percentage" in the name sounds weird.  What about hugepage_mem_bp or
target_hugepage_mem_bp?

> +
> +static unsigned long quota_autotune_feedback __read_mostly;
> +module_param(quota_autotune_feedback, ulong, 0600);

I'm not really sure if this is really needed.  If not, could we drop this?

> +
> +static struct damon_ctx *ctx;
> +static struct pid *target_pidp;
> +
> +static int damon_sample_hpage_damon_call_fn(void *data)
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

What's the purpose of this function?  If not really  needed, can we drop?

> +
> +static struct damon_call_control call_control = {
> +	.fn = damon_sample_hpage_damon_call_fn,
> +	.repeat = true,
> +};
> +
> +static int damon_sample_hpage_start(void)
> +{
> +	int err;
> +	struct damon_target *target;
> +	struct damos *scheme;
> +	struct damos_quota_goal *goal;
> +
> +	pr_info("start\n");
> +
> +

Let's have only one blank line.

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

I don't really suggest time quota to people nowadays.  Size quota is easier to
understand and sufficient in many cases in my humble opinion.  Did you find it
is really helpful and essential for this module?  If not, could we unset time
quota?

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

Seems this module is not really utilizing the user input feedback.  To use that
in real, the module should periodically read user's input and feed that to
DAMON core.  I find no code doing that in this module.  If it is not really
being used, I'd suggest to drop this.

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
> +static void damon_sample_hpage_stop(void)
> +{
> +	pr_info("stop\n");
> +	if (ctx) {
> +		damon_stop(&ctx, 1);
> +		damon_destroy_ctx(ctx);
> +	}
> +}
> +static int damon_sample_hpage_enabled_store(const char *val,
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
> +		err = damon_sample_hpage_start();
> +		if (err)
> +			enabled = false;
> +		return err;
> +	}
> +	damon_sample_hpage_stop();
> +	return 0;
> +}
> +
> +static const struct kernel_param_ops enabled_param_ops = {
> +	.set = damon_sample_hpage_enabled_store,
> +	.get = param_get_bool,
> +};
> +
> +module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
> +MODULE_PARM_DESC(enabled,
> +	"Enable or disable DAMON_HUGEPAGE (default: disabled)");

s/DAMON_HUGEPAGE/DAMON_SAMPLE_HPAGE/ ?

"(default: disabled)" seems unnecessary.  Could you please remove that?

> +
> +static int __init damon_sample_hpage_init(void)
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
> +		err = damon_sample_hpage_start();
> +		if (err)
> +			enabled = false;
> +	}
> +	return err;
> +}
> +
> +module_init(damon_sample_hpage_init);
> -- 
> 2.43.0


Thanks,
SJ

