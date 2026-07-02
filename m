Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 098FEC43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D0426B0148; Thu,  2 Jul 2026 20:51:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8436B0149; Thu,  2 Jul 2026 20:51:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EB0B6B014C; Thu,  2 Jul 2026 20:51:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD2436B0149
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:51:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 858C78CAE4
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 18:51:53 +0000 (UTC)
X-FDA: 84944730906.25.75DF64F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id F1D811C0007
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 18:51:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQozmxJd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783018312;
	b=RMIcwxd/yqf3jKu+Zfkksnx7jlpncoCvWLUJv7aO9RGADz8kyz024W7LOCtiR6OwKmM1oN
	u7hOjxyEfWx2XzWlC8RvdpzQYHdLX/r6kG0VrSpW0KiLMv3lTyJPFZAF6FcCWLon8sP4VM
	KylkUrUu/glgdFRUNDfvaq3zhE4ag00=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783018312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GRvPQ6/Z0g76HRnzKKDLecrWTfumsay2ZV4G7sApkk8=;
	b=JY4iu++h7s5p6/Fn7tcQBVDH1pP94HOgd1qAh+AXBrah4SL2SsfWGmSNuNHo76ONBL5Oin
	yhaAwaa5Z5cyNQXVZpMtdZY5gw67n3a8RFa0H0uRBLbq1jpj+ItBlfj76GU53FrPHVWvGM
	t0u0myBHd7d9FueQY6hdnFxLat+syH8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQozmxJd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 506A3601CB;
	Thu,  2 Jul 2026 18:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA611F000E9;
	Thu,  2 Jul 2026 18:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783018310;
	bh=GRvPQ6/Z0g76HRnzKKDLecrWTfumsay2ZV4G7sApkk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQozmxJdkoRbRH5oLgqkPWRBXd+Qnd82D6mUzoSS5n4Q6rQTo02sW3z9jkxnXDNtF
	 776BYNsJFUH2Gm6HxCjpw3Xqf5qdYWHJssvWv+lKw+CZxzNkj+VAjXjHqCZ7YzyTfx
	 ZF8bQlg18Pt/G9dwGXoeLoYSE9yR9alB8rt7l5XpXGXh3iBBsu7RjZ8BJ34KI5+K0U
	 LlhTdioZY7ZLfHuXzHBceHgdWcbzQSEAocedZqJVsl/3UhnqFr3VsTYC0kHuBY7cEl
	 fTnCTkoIoTeULVqalWWKq8qvkkdqo08zG6EwZBrAkP6MLJ28dhWHWLuiN1gmutMWJP
	 uDp/y5CCWdbGA==
From: SJ Park <sj@kernel.org>
To: Lian Wang <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	daichaobing@sangfor.com.cn,
	kunwu.chan@gmail.com
Subject: Re: [RESEND RFC PATCH v2 1/5] mm/damon: add target_order field for DAMOS_COLLAPSE
Date: Thu,  2 Jul 2026 11:51:37 -0700
Message-ID: <20260702185137.91227-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702094633.75658-2-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F1D811C0007
X-Stat-Signature: dtrxshntco5hrutpntkhg3wjsqtdqf3z
X-Rspam-User: 
X-HE-Tag: 1783018311-136391
X-HE-Meta: U2FsdGVkX1/BC1efhxCo3kG/bRerWSqkFyZql7BXbTf0iPHMYtoDpNnnc9sfvyO5n6rxgcRDGymfEUdZNysHHRH93oxB31m/gB8xbt4/rPD3Ci3rmhOy2kozhgHEmReNnTP3Yb5x8zX3ktfKgCZ5cV6MjXp5ExZkJCRzA2SM5BE2/g3ljjuiAPBQGfNs/CTCseCG82LRAWSzLdofzdfLXJMzOY2sG9zzJCZ8nEQG3GZYU/OPtqCVlF9mNlA0TsqRMuecngaQwBES1AwTOs8OCkW3zwZgN0l3J/K/cwgq1EVBGQv5NC2hA6S0v95vrgMFNo1Qf5j/r93xEpjPSC2tDE3A+pyZAe3Fy81WnbDSMr/59ate8xs5mlMpw5FsF8gh9pT1sZxX0PAWohv2TZONBVu3aSl+MPAULCh52mC0eq9cwkiun0Vse+jAfT3SvtF8/2/jzyyNVc0x8bmjMBXaC+CZ+J2jDPwKYsprodmc3OJ5L61xXmvwLOcCu0YaxWcWMMzf4N8TVr51bVVfzq+VKnMU0QilKBfs+pV5C8WBPntAPxVpMRkevG3bNlDWuEOMXke10EoDWipzSd9ukFoHgGIPmw8OiiAgkzkAvfI4Fjb9JqtcE6wsBi+Q0ZhF371HKR7yrbsX6z3K6qTR0b0a27KFe2G8A1PZjlkjJyd0PS6o1FNrEOrQqeoyYSUFelupoRQ1hIqHLTq/znzxSUhj6cPX5JxCQxg9Z9GS/APHY/YwPGAVrJltFhLOp6fEvteIgAJRJD1LPEShLcltrb+7ia2Rm7GLS7BVyRzliXifkXy2nNlW3mWR5YQ/3rizFoIOHwl8zyGHH4/aAcEirqUwJfXV2xk1HjmTj1ji7kouyJpXXQ0WdSW0kcFitUX8ltHlFoX3m325JYT7Jbg+RON6DNnBThklCHlbYAPV6BujIOrLExAzFhiKaPH3kJJVAkVh/ZFNlG+m9zamjJtHw+x
 1YHMmqs1
 nFOWHF0mvcjFtHwD1cJ098vQ4g4iBlkTUn5SWdXeX+UPz/dmcT/cU80xoxIO+Cl9U9DIp5OaUDDpsNh8WSZNEgvG4Q2ccziivA2nI2pjUyOoqCch8b9cVN1hNmL33ae1RzFoKTwWrwY6n5HESnTjiWZFxQNi7BubBcWYKJZKtmtzZ86vaZjz/xpgJ9VAK8zaARwe4XmgAHj3gM2JrmlD9lx41plmWMNAX9nAKQXNw6g1Up4O1Po5Hs1LR+PTwsm0H1fSPFCxQQbYsJaZ7bQ0U92+x4ksiU/f0MVH8KMz+2a/NXm4AjG4pbm1R/NtCYekhGyOgAc8tuDnz7bYagPBpbb9i/EUXxTLFtcgQMz4Jx+ifA9HfMhoi4xMKFyNTfyhOlHDWRbAt730gbtIhOmVDQCofyNqgFEizVIBF0ssKrs0zIhKJUt+zrvGn3BPcoJB7lvnQ3kF2gZ/CguG6ZOnoW1bfb/Z5W0vIoa6QyO12gUTxzOc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Jul 2026 17:46:29 +0800 Lian Wang <lianux.mm@gmail.com> wrote:

> DAMOS_COLLAPSE currently collapses into PMD-size THP only.  Add a
> target_order field to express per-order mTHP collapse intent.  Zero
> means system default (PMD order, same as current behavior).  Valid
> values are 0 and 2..HPAGE_PMD_ORDER.
> 
> Wire up the sysfs interface: a per-scheme rw file "target_order".

Unless there is a name conflict, let's just call it "order".

> Validate at store time that the value is in range, and warn at scheme
> creation time if DAMOS_COLLAPSE is used with an unsupported non-PMD
> order, resetting to 0.

I'm working [1] on centralize the user parameter validations into core layer.
It is fine to have this for now.  But once the core layer validation is merged
into mm-new, let's use it for the validation.  That is, just let the user
writes invalidate target order.  But eventual attempt to use that via
damon_start() or damon_commit() will fail.

> 
> The actual mTHP application via the khugepaged wrapper will be added
> in subsequent patches.
> 
> Co-developed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Lian Wang <lianux.wang@processmission.com>

Having two Signed-off-by: looks odd.  If you want to give a credit to your
employer, you can add that to your signature, like:

Signed-off-by: Lian Wang (Your employer name) <lianux.mm@gmail.com>

That's a de-facto standard in mm community.

> ---
>  include/linux/damon.h    |  5 ++++
>  mm/damon/core.c          |  2 ++
>  mm/damon/sysfs-schemes.c | 61 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 68 insertions(+)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 6f7edb3590ef..5a0587556573 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -572,6 +572,11 @@ struct damos_migrate_dests {
>  struct damos {
>  	struct damos_access_pattern pattern;
>  	enum damos_action action;
> +	/*
> +	 * @target_order: target order for mTHP actions (DAMOS_COLLAPSE).
> +	 * 0 means system default (PMD order).  Valid: 0, 2..HPAGE_PMD_ORDER.
> +	 */
> +	unsigned int target_order;
>  	unsigned long apply_interval_us;

Let's rename to 'order'.  And put it in the union having 'target_nid' and
'migrate_dests'.

>  /* private: internal use only */
>  	/*
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 265d51ade25b..be54defd4646 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -579,6 +579,7 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
>  
>  	scheme->migrate_dests = (struct damos_migrate_dests){};
>  	scheme->target_nid = target_nid;
> +	scheme->target_order = 0;
>  
>  	return scheme;
>  }
> @@ -1278,6 +1279,7 @@ static int damos_commit(struct damos *dst, struct damos *src)
>  
>  	dst->wmarks = src->wmarks;
>  	dst->target_nid = src->target_nid;
> +	dst->target_order = src->target_order;
>  
>  	err = damos_commit_dests(&dst->migrate_dests, &src->migrate_dests);
>  	if (err)
> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> index 329cfd0bbe9f..7dcd582ded86 100644
> --- a/mm/damon/sysfs-schemes.c
> +++ b/mm/damon/sysfs-schemes.c
> @@ -6,7 +6,9 @@
>   */
>  
>  #include <linux/slab.h>
> +#include <linux/mm.h>
>  #include <linux/numa.h>
> +#include <linux/huge_mm.h>
>  
>  #include "sysfs-common.h"
>  
> @@ -2257,6 +2259,7 @@ struct damon_sysfs_scheme {
>  	struct damon_sysfs_stats *stats;
>  	struct damon_sysfs_scheme_regions *tried_regions;
>  	int target_nid;
> +	unsigned int target_order;

Let's rename to 'order' if there is no problem.  Same for below.

>  	struct damos_sysfs_dests *dests;
>  };
>  
> @@ -2323,6 +2326,7 @@ static struct damon_sysfs_scheme *damon_sysfs_scheme_alloc(
>  	scheme->action = action;
>  	scheme->apply_interval_us = apply_interval_us;
>  	scheme->target_nid = NUMA_NO_NODE;
> +	scheme->target_order = 0;
>  	return scheme;
>  }
>  
> @@ -2642,6 +2646,39 @@ static ssize_t target_nid_store(struct kobject *kobj,
>  	return err ? err : count;
>  }
>  
> +static ssize_t target_order_show(struct kobject *kobj,
> +		struct kobj_attribute *attr, char *buf)
> +{
> +	struct damon_sysfs_scheme *scheme = container_of(kobj,
> +			struct damon_sysfs_scheme, kobj);
> +
> +	return sysfs_emit(buf, "%u\n", scheme->target_order);
> +}
> +
> +static ssize_t target_order_store(struct kobject *kobj,
> +		struct kobj_attribute *attr, const char *buf, size_t count)
> +{
> +	struct damon_sysfs_scheme *scheme = container_of(kobj,
> +			struct damon_sysfs_scheme, kobj);
> +	unsigned int val;
> +	int err;
> +
> +	err = kstrtouint(buf, 0, &val);
> +	if (err)
> +		return err;
> +
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	if (val != 0 && (val < 2 || val > HPAGE_PMD_ORDER))
> +		return -EINVAL;
> +#else
> +	if (val != 0)
> +		return -EINVAL;
> +#endif

As I mentioned above, this should eventually removed in lieu of core layer
parameters validation.

> +
> +	scheme->target_order = val;
> +	return count;
> +}
> +
>  static void damon_sysfs_scheme_release(struct kobject *kobj)
>  {
>  	kfree(container_of(kobj, struct damon_sysfs_scheme, kobj));
> @@ -2656,10 +2693,14 @@ static struct kobj_attribute damon_sysfs_scheme_apply_interval_us_attr =
>  static struct kobj_attribute damon_sysfs_scheme_target_nid_attr =
>  		__ATTR_RW_MODE(target_nid, 0600);
>  
> +static struct kobj_attribute damon_sysfs_scheme_target_order_attr =
> +		__ATTR_RW_MODE(target_order, 0600);
> +
>  static struct attribute *damon_sysfs_scheme_attrs[] = {
>  	&damon_sysfs_scheme_action_attr.attr,
>  	&damon_sysfs_scheme_apply_interval_us_attr.attr,
>  	&damon_sysfs_scheme_target_nid_attr.attr,
> +	&damon_sysfs_scheme_target_order_attr.attr,
>  	NULL,
>  };
>  ATTRIBUTE_GROUPS(damon_sysfs_scheme);
> @@ -2970,6 +3011,7 @@ static struct damos *damon_sysfs_mk_scheme(
>  	struct damon_sysfs_weights *sysfs_weights = sysfs_quotas->weights;
>  	struct damon_sysfs_watermarks *sysfs_wmarks = sysfs_scheme->watermarks;
>  	struct damos *scheme;
> +	unsigned int target_order;
>  	int err;
>  
>  	struct damos_access_pattern pattern = {
> @@ -3005,6 +3047,25 @@ static struct damos *damon_sysfs_mk_scheme(
>  	if (!scheme)
>  		return NULL;
>  
> +	target_order = sysfs_scheme->target_order;
> +
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	if (sysfs_scheme->action == DAMOS_COLLAPSE &&
> +	    target_order != 0 &&
> +	    target_order != HPAGE_PMD_ORDER) {
> +		pr_warn("DAMON collapse: target_order %u not supported, only PMD order (%u) is available. Use 0 or %u.\n",
> +			target_order,
> +			HPAGE_PMD_ORDER, HPAGE_PMD_ORDER);
> +		target_order = 0;
> +	}

Ditto.  This validation should eventually be removed.

> +#else
> +	if (sysfs_scheme->action == DAMOS_COLLAPSE && target_order != 0) {
> +		pr_warn("DAMON collapse: target_order not supported without THP. Use 0.\n");
> +		target_order = 0;
> +	}
> +#endif
> +	scheme->target_order = target_order;
> +
>  	err = damos_sysfs_add_quota_score(sysfs_quotas->goals, &scheme->quota);
>  	if (err) {
>  		damon_destroy_scheme(scheme);

Overall, looks good.

[1] https://lore.kerneel.org/20260701144815.113325-1-sj@kernel.org


Thanks,
SJ

[...]

