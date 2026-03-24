Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF3F4E9A768
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AE9D6B0096; Tue, 24 Mar 2026 06:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35E8C6B0098; Tue, 24 Mar 2026 06:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 274C96B0099; Tue, 24 Mar 2026 06:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EECE6B0096
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:54:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96BA2BCBC9
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:54:25 +0000 (UTC)
X-FDA: 84580647690.11.07B55A4
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8A7F6100005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:54:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ya7VqwXY;
	spf=pass (imf05.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774349663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIZl92YtKfb0yqPOgIE+PAZEkENCazVOzf56tfESq80=;
	b=cNauDJU48wI+Es8juH1+fCPcMxlwJjQ975CQKBm+NxUcchvJ6uhgd4joRDeLQna3S1sN5i
	T6uSmHzjjN5kGWqg7lGyaUIV1M25ZtZ6JtnXpq85eAx+eEnFm7jhISUkOnxmVJjt//+z7R
	wUSUS2JFGMzVxAkeVDEGjWMx4jWbvDM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ya7VqwXY;
	spf=pass (imf05.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774349663; a=rsa-sha256;
	cv=none;
	b=PvtFLFMTBX8myrCBilvfuR5BFiUmeLAq8sY7r1zJ+9b4Mu5sOQ861O1Hrc7r8gNuZC8wTY
	9LSLSrTyaUwRH/j5aT583aSBFspIXZkl2JvL017pBSsdJfPTw5CHmD1brR/Yks53EfNdaH
	3as2qJ4yY4EazLykTKV9b86tEI/RUwY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774349657; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=uIZl92YtKfb0yqPOgIE+PAZEkENCazVOzf56tfESq80=;
	b=Ya7VqwXY8Q0gmT8KUP1AuGjYqtOegWft4ssvZi/zAT1ySphRh2Lgd4NM4zTbyh944JWRYAFgaXL1M6mp3TPXX0IOtFdO+pBHGLlixYPKEIul+Kd72ERFtrfGoZ2mDBsb4n0ljISp+ZDKEhw7Sm1W0Ngx20/+vqCOcmctmlgAp8k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=40;SR=0;TI=SMTPD_---0X.eIYMT_1774349653;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X.eIYMT_1774349653 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Mar 2026 18:54:15 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Shivank Garg <shivankg@amd.com>
Cc: <akpm@linux-foundation.org>,  <david@kernel.org>,
  <lorenzo.stoakes@oracle.com>,  <Liam.Howlett@oracle.com>,
  <vbabka@kernel.org>,  <willy@infradead.org>,  <rppt@kernel.org>,
  <surenb@google.com>,  <mhocko@suse.com>,  <ziy@nvidia.com>,
  <matthew.brost@intel.com>,  <joshua.hahnjy@gmail.com>,
  <rakie.kim@sk.com>,  <byungchul@sk.com>,  <gourry@gourry.net>,
  <apopple@nvidia.com>,  <dave@stgolabs.net>,
  <Jonathan.Cameron@huawei.com>,  <rkodsara@amd.com>,  <vkoul@kernel.org>,
  <bharata@amd.com>,  <sj@kernel.org>,  <weixugc@google.com>,
  <dan.j.williams@intel.com>,  <rientjes@google.com>,
  <xuezhengchu@huawei.com>,  <yiannis@zptcorp.com>,
  <dave.hansen@intel.com>,  <hannes@cmpxchg.org>,  <jhubbard@nvidia.com>,
  <peterx@redhat.com>,  <riel@surriel.com>,  <shakeel.butt@linux.dev>,
  <stalexan@redhat.com>,  <tj@kernel.org>,  <nifan.cxl@gmail.com>,
  <linux-kernel@vger.kernel.org>,  <linux-mm@kvack.org>,  Mike Day
 <michael.day@amd.com>
Subject: Re: [RFC PATCH v4 4/6] mm/migrate: add copy offload registration
 infrastructure
In-Reply-To: <20260309120725.308854-12-shivankg@amd.com> (Shivank Garg's
	message of "Mon, 9 Mar 2026 12:07:29 +0000")
References: <20260309120725.308854-3-shivankg@amd.com>
	<20260309120725.308854-12-shivankg@amd.com>
Date: Tue, 24 Mar 2026 18:54:13 +0800
Message-ID: <87o6kdzeei.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A7F6100005
X-Stat-Signature: 4rendcrhw819esf547nnasbchpmr5xje
X-Rspamd-Server: rspam06
X-HE-Tag: 1774349661-203646
X-HE-Meta: U2FsdGVkX19WuomPGUnFxH0f2PiP+9i3AWSDCUWXFxQROepO51ZKnLzshAABq7R5rSA7zGiABTj9XjEivXwkLvhqb+FXCqoShvKaS0SR3qzKe0gzJMjCAHgLyNcAWXOnZGHtXB4pbehHNDyFeyNbUzaekSSFWjqZOrZ35IGRJjCCDcydyzKp4cbul/brN09j3kcIlBvdkhrHiSk/gNko7gJjCJZcqwB2Qidv6R3B+bfNGfBCTfub6XUe5BCnlOkSLE45VmUCJ06anWS/Jd1XCuOXYa2P7LXf5NLLfksMQrDNiojq6u4gwHknmmqYVR473W8MK2Pbt3PjalC2vneRcB3T/qsHLbg1T6ugjOq28u6dUgS4942fTQxc2ErHHeDSvROyiixEzSGgE5iikxu44SGF+LKkYwdh/STtwoauvEQ5GvoDO2QocgfG2JH3lN1a5IF9mZ0249iZknypnc9k78blTlfr8mAuLXiH6T422DMFYDS5ejpXhoVrxgSfWjDrtpevhQm+BiyP/SKQQSsPoy57+p3znh6Jvy1NDittjyzuzfEoBqO6q5bNblDloCQwpG+kTDw8ZSdjZbERER2iTONjIs9lRp/2ZrtiAN5La+dz1wrMd6Cn+lqIM2al/SYMMrpd7ODRHeywrbYNiYh2om92L2DyVtAJd12W/toFYcUmuHLCvpL1gvx5jLibV/2OdA5LIO3hpDLjJQArwoH/9lfjWI1rOVUCeDVCf558WbFysDS0paZ4DZD+8qiYJR0rspVYn3Oo3BAj0bIifkbHM3TuGIHY7V7a533svn8YjoN/EUQpF2VBNWZeEe/hZ6g0lzlESlgB8i36SMaeu0FPSZBC2M4lDhLGDFNfW10l7Z3kKXCCgEmFGQSwA/HbafpqSgnMm7XVm+zbEp70ebIDQtqRsXCxunIep9m268ClhFwPeJ5uFjYrwL9BnDIGEWAlsRsQVgYbDla+EKZPHSw
 YOCwnF9U
 /Q8DsgtJRh92E5Iqw3nqiIfkDFNvRhOtZ1Ids4XciPZFZBttBQ+pMehk/+zDzOrs979CLRcYFbf5Glc61usiV90RT1AOvzKSNvQvIGtU7NLrefQmUeTyPA5BdRm6gvV1uzftAq+qg2QKZF9MP1BRYMBKa8tJybt4iwMsnVKUSbKcpoeQnrRNedxbS8kjHoFz+v4zQHomVvkL2bkMGkrtdiytQEz6/eukKYWSl5RVWWPlPkRahyTFh/RwaV2PhNg0sMJ3w7FmnIKq7aeYZCWrzPvtvixiFbKMpwC0gIbUW9vvp+84YnmHnvu6dw98QpAq5BwLg2SVw8b37hkAChVnFDbPWWVPhHTbwZriyBEQuhYyaV3Y8AbZG/1kK1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shivank Garg <shivankg@amd.com> writes:

> Introduce CONFIG_MIGRATION_COPY_OFFLOAD, which lets offload driver

Do we really need a new kconfig option?  IMHO, we have too many now.
Because we have a jump label already, the performance difference should
be trivial.  Can you measure the size difference?

> (DMA, multi-threaded CPU copy, etc) take over the batch folio copy in
> migrate_pages_batch().
>
> Offload driver fill in a struct migrator with their offload_copy() and
> should_batch() implementation and call migrate_offload_start(), which
> patches the migrate_offload_copy() static_call and flips the
> migrate_offload_enabled static branch. The migrate_offload_stop() call
> reverts both.
>
> Only one migrator can be active a time. A second registration returns
> -EBUSY, and only the active migrator can stop itself. The static_call
> dispatch is under SRCU so synchronize_srcu() in stop path guarantees
> no in-flight copy before the module reference is dropped.
>
> Co-developed-by: Mike Day <michael.day@amd.com>
> Signed-off-by: Mike Day <michael.day@amd.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  include/linux/migrate_copy_offload.h | 34 ++++++++++
>  mm/Kconfig                           |  9 +++
>  mm/Makefile                          |  1 +
>  mm/migrate.c                         | 30 ++++++++-
>  mm/migrate_copy_offload.c            | 99 ++++++++++++++++++++++++++++
>  5 files changed, 171 insertions(+), 2 deletions(-)
>  create mode 100644 include/linux/migrate_copy_offload.h
>  create mode 100644 mm/migrate_copy_offload.c
>
> diff --git a/include/linux/migrate_copy_offload.h b/include/linux/migrate_copy_offload.h
> new file mode 100644
> index 000000000000..ee112826ebdf
> --- /dev/null
> +++ b/include/linux/migrate_copy_offload.h
> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_MIGRATE_COPY_OFFLOAD_H
> +#define _LINUX_MIGRATE_COPY_OFFLOAD_H
> +
> +#include <linux/jump_label.h>
> +#include <linux/srcu.h>
> +#include <linux/types.h>
> +
> +struct list_head;
> +struct module;
> +
> +#define MIGRATOR_NAME_LEN 32
> +
> +struct migrator {
> +	char name[MIGRATOR_NAME_LEN];
> +	int (*offload_copy)(struct list_head *dst_list,
> +			    struct list_head *src_list,
> +			    unsigned int folio_cnt);
> +	bool (*should_batch)(int reason);
> +	struct module *owner;
> +};
> +
> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
> +extern struct static_key_false migrate_offload_enabled;
> +extern struct srcu_struct migrate_offload_srcu;
> +bool migrate_should_batch_default(int reason);
> +int migrate_offload_start(struct migrator *m);
> +int migrate_offload_stop(struct migrator *m);

Why not naming the function migrate_offload_register/unregister()?
IMHO, that sounds more natural.

> +#else
> +static inline int migrate_offload_start(struct migrator *m) { return 0; }
> +static inline int migrate_offload_stop(struct migrator *m) { return 0; }
> +#endif /* CONFIG_MIGRATION_COPY_OFFLOAD */
> +
> +#endif /* _LINUX_MIGRATE_COPY_OFFLOAD_H */
> diff --git a/mm/Kconfig b/mm/Kconfig
> index ebd8ea353687..faf0cae9991b 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -648,6 +648,15 @@ config MIGRATION
>  config DEVICE_MIGRATION
>  	def_bool MIGRATION && ZONE_DEVICE
>  
> +config MIGRATION_COPY_OFFLOAD
> +	bool "Page migration copy offload"
> +	depends on MIGRATION
> +	help
> +	  Adds migration copy offload infrastructure which allow
> +	  offload engines (DMA, multi-threaded CPU copy, etc.) to
> +	  register as the batch-copy provider for page migration
> +	  via migrate_offload_start()/migrate_offload_stop().
> +
>  config ARCH_ENABLE_HUGEPAGE_MIGRATION
>  	bool
>  
> diff --git a/mm/Makefile b/mm/Makefile
> index 8ad2ab08244e..db1ac8097089 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -96,6 +96,7 @@ obj-$(CONFIG_FAILSLAB) += failslab.o
>  obj-$(CONFIG_FAIL_PAGE_ALLOC) += fail_page_alloc.o
>  obj-$(CONFIG_MEMTEST)		+= memtest.o
>  obj-$(CONFIG_MIGRATION) += migrate.o
> +obj-$(CONFIG_MIGRATION_COPY_OFFLOAD) += migrate_copy_offload.o
>  obj-$(CONFIG_NUMA) += memory-tiers.o
>  obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
>  obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 69daa16f9cf3..acaaa9cc0d4f 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -44,6 +44,8 @@
>  #include <linux/memory-tiers.h>
>  #include <linux/pagewalk.h>
>  #include <linux/jump_label.h>
> +#include <linux/static_call.h>
> +#include <linux/migrate_copy_offload.h>
>  
>  #include <asm/tlbflush.h>
>  
> @@ -54,6 +56,17 @@
>  
>  DEFINE_STATIC_KEY_FALSE(migrate_offload_enabled);
>  
> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
> +DEFINE_SRCU(migrate_offload_srcu);
> +DEFINE_STATIC_CALL(migrate_offload_copy, folios_mc_copy);
> +
> +bool migrate_should_batch_default(int reason)
> +{
> +	return false;
> +}
> +DEFINE_STATIC_CALL(migrate_should_batch, migrate_should_batch_default);
> +#endif
> +
>  static const struct movable_operations *offline_movable_ops;
>  static const struct movable_operations *zsmalloc_movable_ops;
>  
> @@ -1820,11 +1833,18 @@ static int migrate_pages_batch(struct list_head *from,
>  	LIST_HEAD(dst_batch);
>  	LIST_HEAD(src_std);
>  	LIST_HEAD(dst_std);
> +	bool do_batch = false;
>  	bool nosplit = (reason == MR_NUMA_MISPLACED);
>  
>  	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
>  			!list_empty(from) && !list_is_singular(from));
>  
> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
> +	/* Check if the offload driver wants to batch for this reason */
> +	if (static_branch_unlikely(&migrate_offload_enabled))
> +		do_batch = static_call(migrate_should_batch)(reason);

Should batching based on "reason" be determined by the general migrate
code instead of the migrator implementation?  For example, if we only
batch copying for ASYNC migration, we should determine that in
migrate_pages_batch() instead of the migreation implementation.  Or am I
missed something?  If so, can you provide an example?

> +#endif
> +
>  	for (pass = 0; pass < nr_pass && retry; pass++) {
>  		retry = 0;
>  		thp_retry = 0;
> @@ -1967,7 +1987,7 @@ static int migrate_pages_batch(struct list_head *from,
>  				break;
>  			case 0:
>  				if (static_branch_unlikely(&migrate_offload_enabled) &&
> -				    folio_supports_batch_copy(folio)) {
> +				    do_batch && folio_supports_batch_copy(folio)) {
>  					list_move_tail(&folio->lru, &src_batch);
>  					list_add_tail(&dst->lru, &dst_batch);
>  					nr_batch++;
> @@ -1997,11 +2017,17 @@ static int migrate_pages_batch(struct list_head *from,
>  	/* Flush TLBs for all unmapped folios */
>  	try_to_unmap_flush();
>  
> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
>  	/* Batch-copy eligible folios before the move phase */
>  	if (!list_empty(&src_batch)) {

Guard with "static_branch_unlikely(&migrate_offload_enabled)" first?
Better to define a inline function to shorten the expression.

> -		rc = folios_mc_copy(&dst_batch, &src_batch, nr_batch);
> +		int idx = srcu_read_lock(&migrate_offload_srcu);
> +
> +		rc = static_call(migrate_offload_copy)(&dst_batch,
> +				&src_batch, nr_batch);
> +		srcu_read_unlock(&migrate_offload_srcu, idx);
>  		batch_copied = (rc == 0);
>  	}
> +#endif
>  
>  	retry = 1;
>  	for (pass = 0; pass < nr_pass && retry; pass++) {
> diff --git a/mm/migrate_copy_offload.c b/mm/migrate_copy_offload.c
> new file mode 100644
> index 000000000000..c22068fe09a0
> --- /dev/null
> +++ b/mm/migrate_copy_offload.c
> @@ -0,0 +1,99 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/jump_label.h>
> +#include <linux/module.h>
> +#include <linux/srcu.h>
> +#include <linux/migrate.h>
> +#include <linux/migrate_copy_offload.h>
> +#include <linux/static_call.h>
> +
> +static DEFINE_MUTEX(migrator_mutex);
> +static struct migrator *active_migrator;
> +
> +DECLARE_STATIC_CALL(migrate_offload_copy, folios_mc_copy);
> +DECLARE_STATIC_CALL(migrate_should_batch, migrate_should_batch_default);
> +
> +/**
> + * migrate_offload_start - register a batch-copy provider for page migration.
> + * @m: migrator to install.
> + *
> + * Only one provider can be active at a time, returns -EBUSY if another migrator
> + * is already registered.
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int migrate_offload_start(struct migrator *m)
> +{
> +	int ret = 0;
> +
> +	if (!m || !m->offload_copy)
> +		return -EINVAL;
> +
> +	mutex_lock(&migrator_mutex);
> +	if (active_migrator) {
> +		ret = -EBUSY;
> +		goto unlock;
> +	}
> +
> +	if (m->owner && !try_module_get(m->owner)) {
> +		ret = -ENODEV;
> +		goto unlock;
> +	}
> +
> +	static_call_update(migrate_offload_copy, m->offload_copy);
> +	static_call_update(migrate_should_batch,
> +		m->should_batch ? m->should_batch : migrate_should_batch_default);
> +	active_migrator = m;
> +	static_branch_enable(&migrate_offload_enabled);
> +
> +unlock:
> +	mutex_unlock(&migrator_mutex);
> +
> +	if (ret)
> +		pr_err("migrate_offload: %s: failed to register (%d)\n",
> +		       m->name, ret);
> +	else
> +		pr_info("migrate_offload: enabled by %s\n", m->name);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(migrate_offload_start);
> +
> +/**
> + * migrate_offload_stop - unregister the active batch-copy provider.
> + * @m: migrator to remove (must be the currently active one).
> + *
> + * Reverts static_call targets and waits for SRCU grace period so that
> + * no in-flight migration is still calling the driver functions before
> + * releasing the module.
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int migrate_offload_stop(struct migrator *m)
> +{
> +	struct module *owner;
> +
> +	mutex_lock(&migrator_mutex);
> +	if (active_migrator != m) {
> +		mutex_unlock(&migrator_mutex);
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Disable the static branch first so new migrate_pages_batch calls
> +	 * won't enter the batch copy path.
> +	 */
> +	static_branch_disable(&migrate_offload_enabled);
> +	static_call_update(migrate_offload_copy, folios_mc_copy);
> +	static_call_update(migrate_should_batch, migrate_should_batch_default);
> +	owner = active_migrator->owner;
> +	active_migrator = NULL;
> +	mutex_unlock(&migrator_mutex);
> +
> +	/* Wait for all in-flight callers to finish before module_put(). */
> +	synchronize_srcu(&migrate_offload_srcu);
> +	if (owner)
> +		module_put(owner);
> +
> +	pr_info("migrate_offload: disabled by %s\n", m->name);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(migrate_offload_stop);

---
Best Regards,
Huang, Ying

