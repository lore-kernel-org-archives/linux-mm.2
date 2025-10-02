Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67285CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 13:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84868E000A; Thu,  2 Oct 2025 09:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C588E0002; Thu,  2 Oct 2025 09:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9994E8E000A; Thu,  2 Oct 2025 09:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86DCE8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 09:12:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31A8CC02FA
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:12:17 +0000 (UTC)
X-FDA: 83953212714.13.658B21D
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id 85151140010
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:12:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759410735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RRwzFhX/zSblPOGaDLHB0woVEnsglEq/W9XsYiPUl50=;
	b=jU2jLqV3hTk2QqKjlSzsotyAyWNm5PgmQW0j5XY8fRNrgiYJ5rHdE7bh3M3CWL0rZdvWnv
	+ebTRy3s3usEBOYHQOMmHrIkrjC4VDs01trsVs2tKc2RzznyhSCtwTNehJCg5Bv8V6YRX9
	LXbYBTorbhVRN5j5dEHZy5A6gOz6bhY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759410735; a=rsa-sha256;
	cv=none;
	b=p1PAu8S4hLnZlXIpbBh9+xVXbt9hnR9jYZp65RZfTE6AbeP2qxR3iF/HYH5YzFlZMnh9VQ
	+DcXFL6u1N8FIra+ucIGzkkNE4BC5QcrDv34EmO1s4OThIEY4Aqj2ocCaqOAwWfBUhukN4
	rDxtYMVVkUFU1VrA0H7cMOlFxzACiXQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ccsb730Fzz6L4sd;
	Thu,  2 Oct 2025 21:09:55 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 68093140426;
	Thu,  2 Oct 2025 21:12:11 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 2 Oct
 2025 14:12:09 +0100
Date: Thu, 2 Oct 2025 14:12:07 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Raghavendra K T <raghavendra.kt@amd.com>
CC: <AneeshKumar.KizhakeVeetil@arm.com>, <Michael.Day@amd.com>,
	<akpm@linux-foundation.org>, <bharata@amd.com>, <dave.hansen@intel.com>,
	<david@redhat.com>, <dongjoo.linux.dev@gmail.com>, <feng.tang@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <honggyu.kim@sk.com>,
	<hughd@google.com>, <jhubbard@nvidia.com>, <jon.grimm@amd.com>,
	<k.shutemov@gmail.com>, <kbusch@meta.com>, <kmanaouil.dev@gmail.com>,
	<leesuyeon0506@gmail.com>, <leillc@google.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <nadav.amit@gmail.com>,
	<nphamcs@gmail.com>, <peterz@infradead.org>, <riel@surriel.com>,
	<rientjes@google.com>, <rppt@kernel.org>, <santosh.shukla@amd.com>,
	<shivankg@amd.com>, <shy828301@gmail.com>, <sj@kernel.org>, <vbabka@suse.cz>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <yuanchu@google.com>,
	<kinseyho@google.com>, <hdanton@sina.com>, <harry.yoo@oracle.com>
Subject: Re: [RFC PATCH V3 01/17] mm: Add kscand kthread for PTE A bit scan
Message-ID: <20251002141207.00007b58@huawei.com>
In-Reply-To: <20250814153307.1553061-2-raghavendra.kt@amd.com>
References: <20250814153307.1553061-1-raghavendra.kt@amd.com>
	<20250814153307.1553061-2-raghavendra.kt@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 85151140010
X-Stat-Signature: et19k8jppg1xc1bt4aingeiax1xi74d3
X-Rspam-User: 
X-HE-Tag: 1759410734-92233
X-HE-Meta: U2FsdGVkX1//eX/Zs/0v3WmNx9zSNjigT1arUooAbFQfMv+1lFcq9FWkYIpwV9/sHWZXpVK9QZam2dmfyuY75erMguqWM7RhBeh8KPqnKJakDiK4sLN63A8Ic8igHBx0eNUo5Sjx8QfPZYz/uzg8r3bcskWnm5/HJG0MqFu1TCFnxFyksWxkDPwYj5yQrIPywLmR08+fQvp/jtu2CkgF5oP1K2z/+xWScj66oRQnqepQKIP7rodGKWX+wmABC9sCQ03gS5IJ7/IR6cD4471T8xdeozDhM4orDOfXe1g58V3abZbkhapft0fiPOk08g7A2NcUbMgh4dtDyghYQCbtnAaxx3GJYeofwV/54R4LWbXPNIULLhS4AQ9dXxISbPuJvWFTN8Elte/fSp4u7dodqaxfIPDY8PgIRD7IV986xE+1LVbMYfQARVfmk5nUKN7htQR7uxSgAw4hW0mA2q1Y84rhmPeDR9xcA49kFTS1Sbx4Id4T/CzfN46sDftMXQbN49byBlOzFc7mHFBe16zJF36PDP7DHpQMVFt27s/uHoSzfQ34EcVQuKbvW0PAlTTrTzuHIV8HLyklopR13JG0R0tiqstVWLvCvaExRBZSQhBMjs8Zytc/hpDxR5ekUfE2mJcOCR3vLS9zbs613NHLDw55lTh77EbNfTu1oj90X/noDz5lUAjDTJsRC1CrNe4tuRaeCkoX8EsvWPrsq1Zgp09GL8lV87OKTmWBrZFL/XYQroSRThbMAxG/GdWsoHGuZOaX3mykPoDz5Uv4Y5r+JEEGXz4xExMB2kaxwpEl7rm1x65UpQ5LzTioXmrA9oPO39Khj2PUs0sS/GhDt0oNOYX/RxK9eNgd4i9BYR0TxY72EI8hkuSLs0exe1iCBWSG5Be3qKEVldxbhPRUWFlLL0YC8fJPLqbPNjpGnngVv0zS/EKD5MSJ4WDPaOB9Q4Z/sLR/YbytQBhRb8yjWhS
 0IzoaVhF
 kCwcgVANG8Xyhl/XjPhwGWdwW+souVRg6/jDN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 15:32:51 +0000
Raghavendra K T <raghavendra.kt@amd.com> wrote:

> Also add a config option for the same.
> 
> High level design:
> 
> While (1):
>   Scan the slowtier pages belonging to VMAs of a task.
>   Add to migation list.
> 
> A separate thread:
>   Migrate scanned pages to a toptier node based on heuristics.
> 
> The overall code is influenced by khugepaged design.
> 
> Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>

Hi Raghavendra,

A few comments inline.

Thanks,

Jonathan

> diff --git a/mm/kscand.c b/mm/kscand.c
> new file mode 100644
> index 000000000000..f7bbbc70c86a
> --- /dev/null
> +++ b/mm/kscand.c
> @@ -0,0 +1,163 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/mm.h>

Good to pick an order for includes.   Various options, my personal
preference is alphabetical with groups of linux/* asm/* and local headers.

> +#include <linux/mm_types.h>
> +#include <linux/sched.h>
> +#include <linux/sched/mm.h>
> +#include <linux/mmu_notifier.h>
> +#include <linux/swap.h>
> +#include <linux/mm_inline.h>
> +#include <linux/kthread.h>
> +#include <linux/string.h>
> +#include <linux/delay.h>
> +#include <linux/cleanup.h>
> +
> +#include <asm/pgalloc.h>
> +#include "internal.h"
...


> +static void kscand_wait_work(void)
> +{
> +	const unsigned long scan_sleep_jiffies =
> +		msecs_to_jiffies(kscand_scan_sleep_ms);
> +
> +	if (!scan_sleep_jiffies)
> +		return;
> +
> +	kscand_sleep_expire = jiffies + scan_sleep_jiffies;
> +
> +	/* Allows kthread to pause scanning */
> +	wait_event_timeout(kscand_wait, kscand_should_wakeup(),
> +			scan_sleep_jiffies);
> +}

Trivial but more consistent I think to have a blank line here.

> +static void kscand_do_scan(void)
> +{
> +	unsigned long iter = 0, mms_to_scan;
> +
> +	mms_to_scan = READ_ONCE(kscand_mms_to_scan);
Slightly nicer perhaps as

	unsigned long iter = 0;
	unsigned long mms_to_scan = READ_ONCE(kscand_mms_to_scan);

> +
> +	while (true) {
> +		if (unlikely(kthread_should_stop()) ||
> +			!READ_ONCE(kscand_scan_enabled))
> +			break;
> +
> +		if (kscand_has_work())
> +			msleep(100);
> +
> +		iter++;
> +
> +		if (iter >= mms_to_scan)
> +			break;
> +		cond_resched();
> +	}
> +}
> +

> +
> +static int start_kscand(void)
> +{
> +	struct task_struct *kthread;
> +
> +	guard(mutex)(&kscand_mutex);
> +
> +	if (kscand_thread)
> +		return 0;
> +
> +	kthread = kthread_run(kscand, NULL, "kscand");
> +	if (IS_ERR(kscand_thread)) {

That looks like the wrong variable to check.

> +		pr_err("kscand: kthread_run(kscand) failed\n");
> +		return PTR_ERR(kthread);
> +	}
> +
> +	kscand_thread = kthread;
> +	pr_info("kscand: Successfully started kscand");
> +
> +	if (!list_empty(&kscand_scan.mm_head))

You have kscand_has_work() for this.

> +		wake_up_interruptible(&kscand_wait);
> +
> +	return 0;
> +}
> +
> +static int stop_kscand(void)
> +{
> +	guard(mutex)(&kscand_mutex);
> +
> +	if (kscand_thread) {
> +		kthread_stop(kscand_thread);
> +		kscand_thread = NULL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __init kscand_init(void)
> +{
> +	int err;
> +
> +	err = start_kscand();
> +	if (err)
> +		goto err_kscand;
This breaks the nice principle of side effect free calls
on error. If start_kscand() has failed, I'd not really expect to have
have stop explicitly.   I'm not sure you actually do need to do so.


> +
> +	return 0;
> +
> +err_kscand:
> +	stop_kscand();
> +
> +	return err;
> +}
> +subsys_initcall(kscand_init);


