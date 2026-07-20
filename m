Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 149EBC44525
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E1E96B00BE; Mon, 20 Jul 2026 05:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BB336B00CE; Mon, 20 Jul 2026 05:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ABF36B00D2; Mon, 20 Jul 2026 05:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE7C26B00BE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:47:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5FEC11A07AE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:47:32 +0000 (UTC)
X-FDA: 85008677544.02.7134662
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf13.hostedemail.com (Postfix) with ESMTP id AB03320006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:47:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=TfAwzd9h;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf13.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540850;
	b=YWj4vXqC26F/9nIuO6UhOCFsnSF0lNMi3OSXbC4Sx6ukQgiM69DoAH94GmBVUZJ7dDFd8D
	/piuA4TDPPPdS7yd8zLR9G2tWdGsW/s1sHPcTA/khntRqyOT+QmZfedmQQnMnAOYNgDl58
	8JGCBq4RW2rSUV8cjHa+urMOr3P75m8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=TfAwzd9h;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf13.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nYPufc9vJgZQgfGaq7EwQsT9y5mRrKBC2QSET+yH5J4=;
	b=3KldtYvN47jqu/C1DQaHzgtLGblVWGVN2ODphg741iRgnMqO9F33z61KGPDbYzYssYDfK1
	ujpFX7eo3xiTIdY7O9oaT1qXogkdglnKIgiTg8I9ISvOHcTZjQes+r8+xdBoqLlaVtXqQT
	XFa0mn2w05DeGB6WB7T9rlB+VhsKHoI=
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nYPufc9vJgZQgfGaq7EwQsT9y5mRrKBC2QSET+yH5J4=;
	b=TfAwzd9hM1GQaYzd0y32K6hbhXaqJCx2Hkc6LVK3wz1/UQYG38I66oi18XdZ0DFubo8jO8d9g
	1U2QeVWzNuxu7WfCq8p2ph1UWke7QsZFuNIRZ8eTT5nonUoM7rrPljJIq3UJFo+0yHLDB4nfmXr
	9S6FBCBvgKqz+5LMel4dgpw=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4h3bJp4fvQzJ4673;
	Mon, 20 Jul 2026 17:47:06 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id F130940569;
	Mon, 20 Jul 2026 17:47:24 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Jul 2026 12:47:24 +0300
Message-ID: <e01fa50e-b9a7-4c0b-ba70-6088b8d6ddfd@huawei-partners.com>
Date: Mon, 20 Jul 2026 12:47:23 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 1/3] mm/damon: introduce DAMOS_SPLIT action
To: Lian Wang <lianux.mm@gmail.com>, <damon@lists.linux.dev>,
	<linux-mm@kvack.org>
CC: <sj@kernel.org>, <akpm@linux-foundation.org>,
	<linux-kernel@vger.kernel.org>, <david@kernel.org>, <ljs@kernel.org>,
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <npache@redhat.com>,
	<ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>, <ryan.roberts@arm.com>,
	<daichaobing@sangfor.com.cn>, <wangkefeng.wang@huawei.com>,
	<zengheng4@huawei.com>, <kasong@tencent.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <lianux.wang@processmission.com>,
	<kunwu.chan@linux.dev>
References: <20260720030327.80153-1-lianux.mm@gmail.com>
 <20260720030327.80153-2-lianux.mm@gmail.com>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260720030327.80153-2-lianux.mm@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: AB03320006
X-Rspam-User: 
X-Stat-Signature: qqmjj9h3u8w1wtqkopcqigy9syxeuysc
X-Rspamd-Server: rspam03
X-HE-Tag: 1784540848-700199
X-HE-Meta: U2FsdGVkX19hmA3jMWFCU4kQgYdSowF1IEq43lt8nN12cEcnkFcn5NAOK19O/MYxUgsw8hOB7sLzqo2tGip+f3ptTnsTKv/4bWXhPKbdsiTZ8Bt1kqInISEBPQfSXmeb8D4Qfp2/LVTpaEswnKo6kUhbPZ4GXDSqBuqKpA8e1GCvkDgWR/EZaAMFq5nXL05AtoOeGA+d7Cde7QKtOUK/UPgcfS6run3X5izSHHINo7Flan/6MGwOVN7jb0gcIuL8sR53s6MhYIm0QyA9vTQyYvChSZEv6NrKMgUcg8h/XsLudRpKnMYiEBkADB+TeP0EZA7DYXHsyuOXSOXlws/cvK67HpTnKacFhDl9azSRWPUxsEG3xWAGHg1ZAIwzw6qor1TXjTavFiUud4MdOuL1cbZG3vr/PVzBEoPmBX9u0drYgA9EJ+NioSHXcg76rKlHPO/UNnEjn58TqZzN57Kg6ohv1OB9OmWXd2klR9zONbQZorEjldbTfhgiMzQRMzBHAGyacDE7DsSEr2EabxicZwg+RBU6lBZr5P77pEKi5P12UAu4FeSD5smk1ZrHQGHAMYcL3+dkrkd0nA9WpzxcpxIgy2dIDLU2JYiIubnTG47pn7KTBJjG1OynPC+mZJYBkfXfXGykVZ/WsUifZXE0+gO+OrUPzIRviVUhXualOhCIRPrh7hQz5CF+X5dIlz0meAMWCuhJd4l0395JezRFcwZDFhv1oCLee8pEli1BCPX0Kt/Ue8auGk39+nQZuTJMNRUkQQ1K3KrVyWopge0+NmsP6FGMlZ+OQEKbAcwDuu9BxcU57S6D35B5a1zXEteaXzZUbKMQ9MHnS6VZY1qg+mCJ2MCDQB5/6r20GDpOKK42oCyuYnjYXHbtf8e+7LH185J47CshqkdVaUxfjP/H0Tr+2+/D2raal94fXszY5Nkuzb2vRXku5yRaU63Om2uax8pBwuA0JjMbADuorwM
 ybkZgu6D
 OqIEnwh22WxXHqLoU4wcWGeeS5yM6YdSj08yK+iIPuWmuKrkXkv0T6RmhUiPgY/rUmY3B2auI40nd8ozV65TWJS+J93VvrIgO5lo8wJBW0pW1BIOfZwis8wpW6VZ332q7yzX342CZLS1ocLB/07skGfUOdZX9UEDwV/yzXCPheDqJZMBZ5+qKSiY6+H/SkObHsvfy0cy9Q6W2dH/HwMMIlljfxs0CYfKtLYHI0jBZHcGZ94vFiHm5wCd4hEFHJtSTNyUYy1sgmkOVV4Rb2oW7sjy2R0cXoi3txGQiaet525ToXskHhiGZePVwd/H0ubVt2X+VGu1utAJvPIibDHDMr8cMP1+9f7g4ZbxbBbAvnzQBXImroopNHXWnwfmV1ZSJtp9LRLctEoG7JK5UNc2Igu7yAbbQxGPuEiU0uYEcAa45TbhmrIs5aYFg8EqIZMCzTX8CQOrEGYjMiV/4gWW+6HRIoGjlWmKlKXxU+TEkA6hhY2DRCwv+x7g8OQOopfq3StA2C1Xp8eerplNTe3xXggV4uqAv+kL4foNm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/20/2026 6:03 AM, Lian Wang wrote:
> Add a new DAMOS action, DAMOS_SPLIT, that splits large folios in the
> target region down to a smaller order.  A new per-scheme field and sysfs
> file, target_order, selects the split target: 0 for order-0 base pages,
> or 2..HPAGE_PMD_ORDER-1 for a smaller mTHP order (order-1 is rejected at
> store time since anonymous THPs cannot be split to order-1).
> 
> Unlike DAMOS_COLLAPSE which builds large folios, splitting only dismantles
> them; it allocates nothing, copies nothing, and no THP admission policy
> applies.  khugepaged deliberately refuses to collapse a folio to a
> smaller order, leaving the shrink direction to callers like this one.
> 
> This patch adds the DAMOS_SPLIT action, the ``order`` field (placed in
> the existing union alongside target_nid and migrate_dests), its sysfs
> interface, and documentation.  The vaddr operations set handler is added
> in the next patch.
> 
> Link: https://lore.kernel.org/20260605161422.213817-9-npache@redhat.com/
>  ("mm/khugepaged: skip collapsing mTHP to smaller orders")
> 
> 
> 
> Co-developed-by: Kunwu Chan <kunwu.chan@linux.dev>
> Signed-off-by: Kunwu Chan <kunwu.chan@linux.dev>
> Signed-off-by: Lian Wang (Processmission) <lianux.mm@gmail.com>
> ---
>  .../ABI/testing/sysfs-kernel-mm-damon         |  7 +++
>  Documentation/mm/damon/design.rst             |  5 ++
>  include/linux/damon.h                         | 15 ++++--
>  mm/damon/core.c                               |  2 +
>  mm/damon/sysfs-schemes.c                      | 48 +++++++++++++++++++
>  tools/testing/selftests/damon/sysfs.py        | 11 +++--
>  6 files changed, 79 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
> index 907a504fb64c..ee8e260a631c 100644
> --- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
> +++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
> @@ -265,6 +265,13 @@ Contact:	SJ Park <sj@kernel.org>
>  Description:	Action's target NUMA node id.  Supported by only relevant
>  		actions.
>  
> +What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/target_order
> +Date:		Jul 2026
> +Contact:	SJ Park <sj@kernel.org>
Shouldn't this point to your email address?
> +Description:	Target folio order for the ``split`` action.  Large folios in
> +		the target region are split down to this order.  Valid values
> +		are 0 (order-0 base pages) and 2..HPAGE_PMD_ORDER-1.
> +
>  What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/apply_interval_us
>  Date:		Sep 2023
>  Contact:	SJ Park <sj@kernel.org>
> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> index aed6cb1cf483..87a801954b1b 100644
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -549,6 +549,11 @@ that supports each action are as below.
>     Supported by ``vaddr`` and ``fvaddr`` operations set. When
>     TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
>     fail.
> + - ``split``: Split each large folio in the region down to the order specified
> +   by the scheme's ``target_order`` (``0`` for order-0 base pages, or
> +   ``2..HPAGE_PMD_ORDER-1``).  Supported by ``vaddr`` and ``fvaddr`` operations
> +   set. When TRANSPARENT_HUGEPAGE is disabled, the application of the action
> +   will just fail.
>   - ``lru_prio``: Prioritize the region on its LRU lists.
>     Supported by ``paddr`` operations set.
>   - ``lru_deprio``: Deprioritize the region on its LRU lists.
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index f69442a9d431..88b61b900a36 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -110,6 +110,7 @@ struct damon_target {
>   * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
>   * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
>   * @DAMOS_COLLAPSE:	Call ``madvise()`` for the region with MADV_COLLAPSE.
> + * @DAMOS_SPLIT:	Split each large folio in the region to a smaller order.
>   * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
>   * @DAMOS_LRU_DEPRIO:	Deprioritize the region on its LRU lists.
>   * @DAMOS_MIGRATE_HOT:  Migrate the regions prioritizing warmer regions.
> @@ -130,6 +131,7 @@ enum damos_action {
>  	DAMOS_HUGEPAGE,
>  	DAMOS_NOHUGEPAGE,
>  	DAMOS_COLLAPSE,
> +	DAMOS_SPLIT,
>  	DAMOS_LRU_PRIO,
>  	DAMOS_LRU_DEPRIO,
>  	DAMOS_MIGRATE_HOT,
> @@ -582,10 +584,15 @@ struct damos {
>  	struct damos_quota quota;
>  	struct damos_watermarks wmarks;
>  	union {
> -		struct {
> -			int target_nid;
> -			struct damos_migrate_dests migrate_dests;
> -		};
> +		int target_nid;
> +		struct damos_migrate_dests migrate_dests;
Shouldn't we keep target_nid and migrate_dests together using a
struct, as in the initial code?
> +		/*
> +		 * @order: target folio order for DAMOS_SPLIT.
> +		 * Split large folios down to this order.  0 for
> +		 * order-0 base pages, 2..HPAGE_PMD_ORDER-1 for
> +		 * smaller mTHP.  Order-1 is rejected.
> +		 */
> +		unsigned int order;
>  	};
>  	struct list_head core_filters;
>  	struct list_head ops_filters;
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 806a67d02a6e..394c62455ad5 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -693,6 +693,7 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
>  		return NULL;
>  	scheme->pattern = *pattern;
>  	scheme->action = action;
> +	scheme->order = 0;
>  	scheme->apply_interval_us = apply_interval_us;
>  	/*
>  	 * next_apply_sis will be set when kdamond starts.  While kdamond is
> @@ -1446,6 +1447,7 @@ static int damos_commit(struct damos *dst, struct damos *src)
>  
>  	dst->pattern = src->pattern;
>  	dst->action = src->action;
> +	dst->order = src->order;
>  	dst->apply_interval_us = src->apply_interval_us;
>  
>  	err = damos_commit_quota(&dst->quota, &src->quota);
> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> index 32f495a96b17..725ed81ccf6c 100644
> --- a/mm/damon/sysfs-schemes.c
> +++ b/mm/damon/sysfs-schemes.c
> @@ -4,7 +4,9 @@
>   */
>  
>  #include <linux/slab.h>
> +#include <linux/mm.h>
>  #include <linux/numa.h>
> +#include <linux/huge_mm.h>
>  
>  #include "sysfs-common.h"
>  
> @@ -2260,6 +2262,7 @@ struct damon_sysfs_scheme {
>  	struct damon_sysfs_stats *stats;
>  	struct damon_sysfs_scheme_regions *tried_regions;
>  	int target_nid;
> +	unsigned int target_order;
>  	struct damos_sysfs_dests *dests;
>  };
>  
> @@ -2293,6 +2296,10 @@ static struct damos_sysfs_action_name damos_sysfs_action_names[] = {
>  		.action = DAMOS_COLLAPSE,
>  		.name = "collapse",
>  	},
> +	{
> +		.action = DAMOS_SPLIT,
> +		.name = "split",
> +	},
>  	{
>  		.action = DAMOS_LRU_PRIO,
>  		.name = "lru_prio",
> @@ -2326,6 +2333,7 @@ static struct damon_sysfs_scheme *damon_sysfs_scheme_alloc(
>  	scheme->action = action;
>  	scheme->apply_interval_us = apply_interval_us;
>  	scheme->target_nid = NUMA_NO_NODE;
> +	scheme->target_order = 0;
>  	return scheme;
>  }
>  
> @@ -2645,6 +2653,40 @@ static ssize_t target_nid_store(struct kobject *kobj,
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
Move the variable declaration to the top of the function.
> +
> +	err = kstrtouint(buf, 0, &val);
> +	if (err)
> +		return err;
> +
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	/* Valid split targets: 0 (order-0 base pages) or 2..HPAGE_PMD_ORDER-1. */
> +	if (val != 0 && (val < 2 || val >= HPAGE_PMD_ORDER))
> +		return -EINVAL;
> +#else
> +	if (val != 0)
> +		return -EINVAL;
> +#endif
> +
> +	scheme->target_order = val;
> +	return count;
> +}
> +
>  static void damon_sysfs_scheme_release(struct kobject *kobj)
>  {
>  	kfree(container_of(kobj, struct damon_sysfs_scheme, kobj));
> @@ -2659,10 +2701,14 @@ static struct kobj_attribute damon_sysfs_scheme_apply_interval_us_attr =
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
> @@ -3011,6 +3057,8 @@ static struct damos *damon_sysfs_mk_scheme(
>  	if (!scheme)
>  		return NULL;
>  
> +	scheme->order = sysfs_scheme->target_order;
> +
>  	err = damos_sysfs_add_quota_score(sysfs_quotas->goals, &scheme->quota);
>  	if (err) {
>  		damon_destroy_scheme(scheme);
> diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
> index 3ffa054b6386..49d3c319dfd8 100755
> --- a/tools/testing/selftests/damon/sysfs.py
> +++ b/tools/testing/selftests/damon/sysfs.py
> @@ -131,11 +131,12 @@ def assert_scheme_committed(scheme, dump):
>              'hugepage': 3,
>              'nohugepage': 4,
>              'collapse': 5,
> -            'lru_prio': 6,
> -            'lru_deprio': 7,
> -            'migrate_hot': 8,
> -            'migrate_cold': 9,
> -            'stat': 10,
> +            'split': 6,
> +            'lru_prio': 7,
> +            'lru_deprio': 8,
> +            'migrate_hot': 9,
> +            'migrate_cold': 10,
> +            'stat': 11,
>              }
>      assert_true(dump['action'] == action_val[scheme.action], 'action', dump)
>      assert_true(dump['apply_interval_us'] == scheme. apply_interval_us,
> 

-- 
Asier Gutierrez
Huawei


