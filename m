Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13634C44532
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 00:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 217886B0088; Wed, 22 Jul 2026 20:06:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF656B008C; Wed, 22 Jul 2026 20:06:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 108076B0092; Wed, 22 Jul 2026 20:06:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0C866B0088
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:06:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62B8C16033C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:06:27 +0000 (UTC)
X-FDA: 85018099614.12.334B89F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A59C140003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:06:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JXapcB4F;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784765184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hpCbtcUC2sXXWMpXDvfzAO/B8jNQgdzlMS6y9QE7+7o=;
	b=ezXDzNu9AieGh3WkqfkgTGOn9IzPpFWexTn//fIvgKd6w6n0Lv2N6lVeD4TTsoI7qxwCXk
	gzzBEENg3bTQUjhrHrMDaNg97c9+YEI0EExXM2HVtkjuff/KdPebNivKEWOvcwtj0W6fMu
	eKaT2NxnN9cfol/nWTBZPDGKrDtwrsM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JXapcB4F;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784765184;
	b=P8XM1J/ov1FKe4UXwWGr5ygszmBF3lz3+OvxsPmbVdHS+KI2C6MpFGME7UEWOlLN7pJSTL
	aNUITOobotLpTImY9X7AW8Z/VvlpwfHmNS/VSN9EX0LfjEpZSrMq17Dvk/KhpufCEJSdeR
	OiMIwEFECsbG0NtVVLDE+/IBaQOb7nU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3D6E40E11;
	Thu, 23 Jul 2026 00:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7281F000E9;
	Thu, 23 Jul 2026 00:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784765183;
	bh=hpCbtcUC2sXXWMpXDvfzAO/B8jNQgdzlMS6y9QE7+7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JXapcB4Fokth2Rq05nv7x+iAXVDRQ0PR9QOyVuhfxKEFbJWQyLPi60RkSNLxRZxqO
	 9pzBtvAEpimpGzaeWTYloeDBwBvSVv1U2c5dcFcEwvdDuVrE8vmQfAwA8yzqvnjeg1
	 nWOuRxQ7sd/UjFGMoiC+UxcLxNGgNjqScc6zJeR5R5357xCfD9MIZSrAoIq5olKEZM
	 K32TNU9o9w7rVDymL5iinKM9Vq5Q/uMl7GecKz8AGly0nuG7+eVW75vtfIbhbN7AK3
	 ANK7qFhI3UF7VXhsCr/QitDrDg6asQ07BXFxdgNE27h5WoT57M6zt+DRva3g52D/Ue
	 HvEtdImcFtmFA==
From: SJ Park <sj@kernel.org>
To: pratmal@google.com
Cc: SJ Park <sj@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Greg Thelen <gthelen@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] mm/page_reporting: Add page_reporting_delay_ms sysctl
Date: Wed, 22 Jul 2026 17:06:09 -0700
Message-ID: <20260723000609.95657-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722211517.1898228-1-pratmal@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A59C140003
X-Stat-Signature: nzi6n369uqatdb9n6agmgodgmmu3x9gb
X-HE-Tag: 1784765184-718231
X-HE-Meta: U2FsdGVkX18wH7i1kyVAHvBNZYK2qbiiCKK7xS1GPhGcsFRsZ511QBXoD0elyuxQMRuE5IOLjMk2HeX69oilI8ivKLQOI+VpJFjZu9R46syVINLxtW8tTRBFdin4CL/X73okqsrKIEv7eXx3Hu9XUc1bwBTf0P3TdkDsDT1aERZMLUV/eD22pXOt6zRuFHjqlNdZSVJRxrqhZTFGOHrJQvFOTldy6gUl727F5pWX9krcSuNO+3WAMEcYA9CETWF0j1hfqLDD6u5Zp85ElqoGvWslixrhvZp4h/pSDGBy535jnpt3Y8iEWP/X0UDxp1db/Szo56yq5wA+B6pgGGsFZZTUsDUzYbx/g0gF9txZElQH9/I8KuF1z/oX164DWqY6dOcP4WVup4L6n//YYygkRv+7bBIkNhGn26QF6U1hTWlC6DkHM3Ifp5AB/bsgDYnhFd7qSoUNO55OK7zwqr+pAIa8nRQF0CHADMclSYKYIFbq5eB1Ye60mW/k79l5m81uZhVf9E6Vfx8C6mS8+8SOr+tky4R7syEBDR/csiL86Z9KCbeMaIlbZxvwSHFXKGIASejL3Bx5sDqQiisDqfs64qZSQKWTk3LwnNZbQ8tFvUMnsRhNGVzf/KVBq60WxcP8j077BO40O3SWgnlQi/3q1CH9XYIGLxSrfVFlGhJ5a0NVqkAbqU90BX4KOWQEpozle0SDO71Yn7NQK4Gen49T8jAjGQ665xBl/iKAmVcGMDUjOMeDoB0hbJBDLfO4Th38U9UTanNbmNGtLDcyiAQHOwjbO1/3r2FMtFf6kV/AZ9RJZBabZJtrcvEDZG00eDaumlCSNXtFIrXgPosRVYnQE9HmuFUSK7Fwx1Buhac1Qg/kcya6Jaj3xECVHXP2BbUyTttpttmOc4i7OfDhjLbPJusx6vVnLM2ikU4JtAad9ZI1ejiazW82S0x7H8qIUSPffLvaUKE6nibcWZUraqY
 nyTWaNVN
 Cjy8H7h2xGLha++renMGiY5iAilV+DSDpcp9wx3tg2vPqVpyLAnwUl9u3t6Zizv8HhO0bJocOpG1K11u9BsI33jjzz0uHVqaoNrJfSviAhVgpg9oeFxN6NJsvmB3dWtGsakauEstdYJVHm/kAZN6abCIwy1MexP1Uix5WIcNBghunngYGt9gSLiLSCUb0HbdRDqKEonitQoLgTgoTa/XpBSyToNwamNP7lvJk1ELkAjo55s/rLz8D+RUKnV/CJYo8Irol+Vc7M40Z3R2Y+uVySYpa2nGwjty+NZy+hwHyeLMPHXZpJ+LqAiiNGanXdWCNUAQFur/MLH79p/VE3ZHpqFc3UMUtAyMQtpwpEeCvWVCgD49qlchDyZDWbkMnBsFVVo/LpbLW/4u+xXMxUyvKd2gSAewLGmPbcGrBH7z5VIqdefXTXxrJMv+mjcfC9vfnkNxeCSKDyZQepyJrWZy6kaOMWir4fj7/c+3A7HvDfLTsjlI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_maintainer.pl suggests adding below to the recipients list of this patch.
Let me add them.  I show you already Cc-ed David, but with his old email
address.

- David Hildenbrand <david@kernel.org>
- Lorenzo Stoakes <ljs@kernel.org>
- "Liam R. Howlett" <liam@infradead.org>
- Mike Rapoport <rppt@kernel.org>
- Jonathan Corbet <corbet@lwn.net>
- Shuah Khan <skhan@linuxfoundation.org>
- linux-doc@vger.kernel.org

On Wed, 22 Jul 2026 21:15:17 +0000 pratmal@google.com wrote:

> From: Pratyush Mallick <pratmal@google.com>
> 
> Currently, the free page reporting daemon uses a hardcoded delay of
> (2 HZ) between reporting intervals. While this is a reasonable
> default, it lacks the flexibility to adapt to varying guest workloads.
> 
> A low delay allows aggressive memory reclamation, returning unused
> pages to the host as quickly as possible. However, during spiky
> allocation/free churn, this immediate reporting can lead to a severe
> performance penalty (nested page faults) as the guest re-allocates memory
> that the host has just unmapped. In these scenarios, there is benefit
> from increasing the delay to batch free pages over a longer window,
> absorbing the churn without hypercall and re-fault overhead.
> 
> This patch refactors the delay into a dynamically tunable sysctl,
> /proc/sys/vm/page_reporting_delay_ms, measured in milliseconds. The value
> defaults to 2000ms to precisely match the original (2 HZ) behavior.
> 
> Signed-off-by: Pratyush Mallick <pratmal@google.com>
> ---
> v2:
>  - Documented page_reporting_delay_ms in Documentation/admin-guide/sysctl/vm.rst.
>  - v1: https://lore.kernel.org/linux-mm/20260722192935.1646848-1-pratmal@google.com/T/#u
> v1: Fixed feedback from RFC.
>  - Added lower and upper cap to sysctl value.
>  - Reverted the reordering on page_reporting_delay_ms.
>  - Dropped the mod_delayed_work() change.
>  - RFC: https://lore.kernel.org/linux-mm/20260714171456.2350037-1-pratmal@google.com/T/#u
>  Documentation/admin-guide/sysctl/vm.rst | 13 +++++++++++
>  mm/page_reporting.c                     | 30 ++++++++++++++++++++++---
>  2 files changed, 40 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> index b9b0c218bfb4..6efa460b4547 100644
> --- a/Documentation/admin-guide/sysctl/vm.rst
> +++ b/Documentation/admin-guide/sysctl/vm.rst
> @@ -66,6 +66,7 @@ Currently, these files are in /proc/sys/vm:
>  - overcommit_ratio
>  - page-cluster
>  - page_lock_unfairness
> +- page_reporting_delay
>  - panic_on_oom
>  - percpu_pagelist_high_fraction
>  - stat_interval
> @@ -896,6 +897,18 @@ stolen from under a waiter. After the lock is stolen the number of times
>  specified in this file (default is 5), the "fair lock handoff" semantics
>  will apply, and the waiter will only be awakened if the lock can be taken.
>  
> +page_reporting_delay
> +=======================

Why don't you make the lengths of the line and the section title same?

> +
> +This value determines the delay in milliseconds between free page
> +reporting intervals. A lower delay allows aggressive memory
> +reclamation by returning unused pages to the host quickly, while a
> +higher delay helps to batch free pages over a longer window, absorbing
> +allocation/free churn without hypercall and re-fault overhead.
> +
> +The default value is 2000 (2 seconds). The minimum allowed value is
> +0 (immediate reporting) and the maximum allowed value is 10000 (10 seconds).

So it is milliseconds.  Why don't you add the unit to the name, like
page_reporting_delay_ms?

Also, coule you elaborate why there is 10 seconds maximum limit?  What's the
problem of having no limit, and why 10 seconds is the reasonable one?

> +
>  panic_on_oom
>  ============
>  
> diff --git a/mm/page_reporting.c b/mm/page_reporting.c
> index 942e84b6908a..805da4bc1101 100644
> --- a/mm/page_reporting.c
> +++ b/mm/page_reporting.c
> @@ -6,6 +6,7 @@
>  #include <linux/export.h>
>  #include <linux/module.h>
>  #include <linux/delay.h>
> +#include <linux/sysctl.h>
>  #include <linux/scatterlist.h>

Too trivial nit, but, why don't you put the sysctl.h at the end of the list?

>  
>  #include "page_reporting.h"
> @@ -47,7 +48,10 @@ MODULE_PARM_DESC(page_reporting_order, "Set page reporting order");
>   */
>  EXPORT_SYMBOL_GPL(page_reporting_order);
>  
> -#define PAGE_REPORTING_DELAY	(2 * HZ)
> +#define PAGE_REPORTING_DELAY_MS_MAX	(10 * MSEC_PER_SEC)
> +
> +static unsigned int page_reporting_delay_ms = 2 * MSEC_PER_SEC;
> +static unsigned int page_reporting_delay_ms_max = PAGE_REPORTING_DELAY_MS_MAX;
>  static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
>  
>  enum {
> @@ -56,6 +60,19 @@ enum {
>  	PAGE_REPORTING_ACTIVE
>  };
>  
> +
> +static struct ctl_table page_reporting_sysctls[] = {
> +	{
> +		.procname	= "page_reporting_delay",
> +		.data		= &page_reporting_delay_ms,
> +		.maxlen		= sizeof(unsigned int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_douintvec_minmax,
> +		.extra1		= SYSCTL_ZERO,
> +		.extra2		= &page_reporting_delay_ms_max,
> +	},
> +};
> +
>  /* request page reporting */
>  static void
>  __page_reporting_request(struct page_reporting_dev_info *prdev)
> @@ -80,7 +97,7 @@ __page_reporting_request(struct page_reporting_dev_info *prdev)
>  	 * now we are limiting this to running no more than once every
>  	 * couple of seconds.
>  	 */
> -	schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
> +	schedule_delayed_work(&prdev->work, msecs_to_jiffies(page_reporting_delay_ms));
>  }

A trivial comment again.  Why don't you wrap the above line for 80 columns
limit?  I know that's not a hard limit anymore and I show a few lines of this
file already exceeds 80 columns.  But seems most lines of this file is still
keeping the 80 columns limit?

>  
>  /* notify prdev of free page reporting request */
> @@ -340,7 +357,7 @@ static void page_reporting_process(struct work_struct *work)
>  	 */
>  	state = atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDLE);
>  	if (state == PAGE_REPORTING_REQUESTED)
> -		schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
> +		schedule_delayed_work(&prdev->work, msecs_to_jiffies(page_reporting_delay_ms));

Ditto.

>  }
>  
>  static DEFINE_MUTEX(page_reporting_mutex);
> @@ -416,3 +433,10 @@ void page_reporting_unregister(struct page_reporting_dev_info *prdev)
>  	mutex_unlock(&page_reporting_mutex);
>  }
>  EXPORT_SYMBOL_GPL(page_reporting_unregister);
> +
> +static int __init page_reporting_sysctl_init(void)
> +{
> +	register_sysctl_init("vm", page_reporting_sysctls);
> +	return 0;
> +}
> +late_initcall(page_reporting_sysctl_init);
> -- 
> 2.55.0.229.g6434b31f56-goog


Thanks,
SJ

