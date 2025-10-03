Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4CDDCAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 12:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C83B8E0005; Fri,  3 Oct 2025 08:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19FD18E0003; Fri,  3 Oct 2025 08:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD088E0005; Fri,  3 Oct 2025 08:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F0D1E8E0003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 08:30:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1A271407CD
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:30:36 +0000 (UTC)
X-FDA: 83956736472.08.299D702
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id ABA444001A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:30:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759494634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tCTk6JhRTxX8/YwftHJzJbBtzijOgzqhcDgKZBhsDTQ=;
	b=1aBEogdrxYUYNS1sinuhQA82vxM2rs4GCr8qDOu5ILDRljkJySY4+M18HQ3NsEpg9p/Yjb
	VT0OhbU7fOSCnFq1ppRjJRPcuDnIVeAK5DuSiTmRbyTymbxdGbgkh1pHuO1hYLjW9Xas6X
	nt1lizKHEi4C+UVZv/1dYPx/ux/A+OY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759494634; a=rsa-sha256;
	cv=none;
	b=S4I6Wk3r6hneFJOXlRlcMzt1gIcmtbTt5rsECAMJPaypj3IFIdA98vVzcnw46b52XRO7Gw
	ntLtOJodfToRhhp9hv9DvR4cqmQWj3fHD9Ay8zv3pdwZz49grl72WN7erDznn2AIhrP5f5
	I2igTEUOvt7e5yj3eNxCHyRiQi/flAs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cdScT5bC2z6L4th;
	Fri,  3 Oct 2025 20:28:09 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 8315114038F;
	Fri,  3 Oct 2025 20:30:28 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Oct
 2025 13:30:27 +0100
Date: Fri, 3 Oct 2025 13:30:25 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Bharata B Rao <bharata@amd.com>, <akpm@linux-foundation.org>,
	<david@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<dave.hansen@intel.com>, <gourry@gourry.net>, <hannes@cmpxchg.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>
Subject: Re: [RFC PATCH v2 7/8] mm: klruscand: use mglru scanning for page
 promotion
Message-ID: <20251003133025.00006f4b@huawei.com>
In-Reply-To: <20250910144653.212066-8-bharata@amd.com>
References: <20250910144653.212066-1-bharata@amd.com>
	<20250910144653.212066-8-bharata@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ABA444001A
X-Stat-Signature: 3xjbwskb5s9zfm5ceephsyq6eyhmesgt
X-Rspam-User: 
X-HE-Tag: 1759494633-583806
X-HE-Meta: U2FsdGVkX19lLRQFq7EGHmXdxnctSZr2BXm+wvF3PSIQaom6Y6iSTAvbSuMHBT2WGIszz7TpkvkPr416CdhcMjETI9AdV+UF6Chkkq37M9/MpZvwNUxF2oo96hw9lX7Ntp2wEhQadRYA/zWkNRicMklmpn4ctsMUa0FOjcrtuRiaGvJiG+8toRyEnVvjuxi6NFYZT5DmC1esWD28rV5UftbtKzp53RfaUaTywxwQfRFTmBtCn+XS/KA+ex6yYYKs2UiHfdwGgZuqT84oXOtg5Iax3bhjdjTYWSsQmmDDB77uZEFF3ELAEAHmd6QvgvlDLx7DytfZ3qlw1K80oSNpxnfS6+A0v5alnpPXNcGFuPyG7NBQZGsLqe1AAmnjaC7oYXmcZbZDzEogPn/0OAkPLhHSw0S3epzjhJNia0qXAy2E5V7UtjuRORtxEgITZrw99tFaxCivtx6DveVE8/pyLmnu0KWpeLQuceaNgs6d9oMvN7yq3uQ88drmqL7OunP+QvlwWSkPUktWonErrQvmzzxWDFUP0g4jzFShLiVN25QjxvWG+gH/L8ITRGj/VjB5IQGoipSxJuTkO87fKsGggo+6BtNGMuf1ytmSo7SLgr6hZjDR7uqNOx8LA7vHSzqp0zs6cSlpSYbzm10tZg/BGxNHNImXk2JUSc3R8J3FywiDxxXMxpszyQ6VhJSXzOOk0vPJwyjn9+6Yio0bV5YPLg9UsguENNmSNowcnfREHxKIiO2h2i07ILK8e4W1XXacP36i7IPdDKlewUDmNOORDbEyXD/l5cT3HtAWP733UvkyFOU62dsak9IfFW+lXWSl6xczODJfuac5ooBw3wva8tZkPBRyE4cBoFXxnl1+lrYc3NWO3QJIh/KtXdDHcv1Mxf9sePs1NH8rzPD6i6wXh6uafXJwwUFPh0qNUgtdWeBQ88ibXpVTIPKpVGtuIuzLwb+P3drbEskJGlca+/Y
 adA0rAhd
 PP3h/YDNCVRdBBvy0tAsGomiY83eciE04yf+QGqi6c2niGUcWM14dkiFVvnNA+QMOiMru5xLisFmUSuMZVDIOcN5unwnOZHWkXjM6aJ3jVEjtqw3u4MXWCg+EE6dIzqmkTs7x4f8bm9eD+YEO99ZOEfghk2LMMqkGeZj8p7wvdvdn33aD5V27pR+mGskun52MFEPnvTgJgQUVSoL3SK1grBHF7ARMEnSXhSvXBRUAH7HBkXK8fvfn7H8LVHiYkWF2CXT7AJKJ266z26G94ujzQ2sFHG8/KAbbmVC+IyziAMy/qajq2EM9ih72E+relQ4cDcbqkrQZc1UCoh7EnPv242hLEB9F2Mz/Zd1H10z4m2Ql3PqiSHxqMwHYgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025 20:16:52 +0530
Bharata B Rao <bharata@amd.com> wrote:

> From: Kinsey Ho <kinseyho@google.com>
> 
> Introduce a new kernel daemon, klruscand, that periodically invokes the
> MGLRU page table walk. It leverages the new callbacks to gather access
> information and forwards it to the pghot hot page tracking sub-system
> for promotion decisions.
> 
> This benefits from reusing the existing MGLRU page table walk
> infrastructure, which is optimized with features such as hierarchical
> scanning and bloom filters to reduce CPU overhead.
> 
> As an additional optimization to be added in the future, we can tune
> the scan intervals for each memcg.
> 
> Signed-off-by: Kinsey Ho <kinseyho@google.com>
> Signed-off-by: Yuanchu Xie <yuanchu@google.com>
> Signed-off-by: Bharata B Rao <bharata@amd.com>
> 	[Reduced the scan interval to 100ms, pfn_t to unsigned long]
Some very minor comments inline.  I know even less about the stuff this
is using than IBS (and I don't know much about that ;)

J
> ---
>  mm/Kconfig     |   8 ++++
>  mm/Makefile    |   1 +
>  mm/klruscand.c | 118 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 127 insertions(+)
>  create mode 100644 mm/klruscand.c
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 8b236eb874cf..6d53c1208729 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1393,6 +1393,14 @@ config PGHOT
>  	  by various sources. Asynchronous promotion is done by per-node
>  	  kernel threads.
>  
> +config KLRUSCAND
> +	bool "Kernel lower tier access scan daemon"
> +	default y

Why default to y? That's very rarely done for new features.

> +	depends on PGHOT && LRU_GEN_WALKS_MMU
> +	help
> +	  Scan for accesses from lower tiers by invoking MGLRU to perform
> +	  page table walks.

> diff --git a/mm/klruscand.c b/mm/klruscand.c
> new file mode 100644
> index 000000000000..1a51aab29bd9
> --- /dev/null
> +++ b/mm/klruscand.c
> @@ -0,0 +1,118 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <linux/memcontrol.h>

Probably pick some ordering scheme for includes.
I'm not spotting what is currently used here.

> +#include <linux/kthread.h>
> +#include <linux/module.h>
> +#include <linux/vmalloc.h>
> +#include <linux/random.h>
> +#include <linux/migrate.h>
> +#include <linux/mm_inline.h>
> +#include <linux/slab.h>
> +#include <linux/sched/clock.h>
> +#include <linux/memory-tiers.h>
> +#include <linux/sched/mm.h>
> +#include <linux/sched.h>
> +#include <linux/pghot.h>
> +
> +#include "internal.h"
> +
> +#define KLRUSCAND_INTERVAL_MS 100
> +#define BATCH_SIZE (2 << 16)
> +
> +static struct task_struct *scan_thread;
> +static unsigned long pfn_batch[BATCH_SIZE];
> +static int batch_index;
> +
> +static void flush_cb(void)
> +{
> +	int i = 0;
> +
> +	for (; i < batch_index; i++) {
> +		u64 pfn = pfn_batch[i];

Why dance through types?  pfn_batch is unsigned long and it is
cast back to that below.

> +
> +		pghot_record_access((unsigned long)pfn, NUMA_NO_NODE,
> +					PGHOT_PGTABLE_SCAN, jiffies);
> +
> +		if (i % 16 == 0)

No problem with this, but maybe a comment on why 16?

> +			cond_resched();
> +	}
> +	batch_index = 0;
> +}

> +static int klruscand_run(void *unused)
> +{
> +	struct lru_gen_mm_walk *walk;
> +
> +	walk = kzalloc(sizeof(*walk),
> +		       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);

Maybe use __free() magic so we can forget about having to clear this up on exit.
Entirely up to you though as doesn't simplify code much in this case.

> +	if (!walk)
> +		return -ENOMEM;
> +
> +	while (!kthread_should_stop()) {
> +		unsigned long next_wake_time;
> +		long sleep_time;
> +		struct mem_cgroup *memcg;
> +		int flags;
> +		int nid;
> +
> +		next_wake_time = jiffies + msecs_to_jiffies(KLRUSCAND_INTERVAL_MS);
> +
> +		for_each_node_state(nid, N_MEMORY) {
> +			pg_data_t *pgdat = NODE_DATA(nid);
> +			struct reclaim_state rs = { 0 };
> +
> +			if (node_is_toptier(nid))
> +				continue;
> +
> +			rs.mm_walk = walk;
> +			set_task_reclaim_state(current, &rs);
> +			flags = memalloc_noreclaim_save();
> +
> +			memcg = mem_cgroup_iter(NULL, NULL, NULL);
> +			do {
> +				struct lruvec *lruvec =
> +					mem_cgroup_lruvec(memcg, pgdat);
> +				unsigned long max_seq =
> +					READ_ONCE((lruvec)->lrugen.max_seq);
> +
> +				lru_gen_scan_lruvec(lruvec, max_seq,
> +						    accessed_cb, flush_cb);
> +				cond_resched();
> +			} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
> +
> +			memalloc_noreclaim_restore(flags);
> +			set_task_reclaim_state(current, NULL);
> +			memset(walk, 0, sizeof(*walk));
> +		}
> +
> +		sleep_time = next_wake_time - jiffies;
> +		if (sleep_time > 0 && sleep_time != MAX_SCHEDULE_TIMEOUT)
> +			schedule_timeout_idle(sleep_time);
> +	}
> +	kfree(walk);
> +	return 0;
> +}


