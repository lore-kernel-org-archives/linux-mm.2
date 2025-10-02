Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEFFACAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 16:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3951D8E0008; Thu,  2 Oct 2025 12:24:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345778E0002; Thu,  2 Oct 2025 12:24:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 234658E0008; Thu,  2 Oct 2025 12:24:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DC048E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 12:24:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B5E231DFE0B
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:24:22 +0000 (UTC)
X-FDA: 83953696764.09.CC68ABA
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id BA125A0005
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:24:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759422261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s2ntx40KiF52PROdQM4BuIWZPFvz8PJkqMSMkUyuB88=;
	b=SxISZphj9fRFohWRO3zwoh6BSie7GtKScEUMhqp0U7KAXm1AaagbDI4pjDXAIU0qR0j7Ep
	SBJaMbLmwz/JcZ8SrPhT8D+3Yh0vzASgooaQC6crv13LAzzMjopHuOpVbaSl9OPHhjpZUi
	hMBjSfdbJCUn48bR41Bip4G/tyfB5ss=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759422261; a=rsa-sha256;
	cv=none;
	b=pyOHypZBqYx1c8or9P45SM8tBJ0jeIe9I24XJLobXsS7Tcs3sAiKfodVPYYUzVj7yAWMuG
	14XU+tgIqZeG9Gv+xH+37M04Vy9YmeFmlIQoyQwQvL7JQySD8ZP2sqtepIQt+9GRcVwPQ1
	MIQGCMvVrUQCupjGGcypMxgdKC8iNKw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ccxrp3rrFz6L50J;
	Fri,  3 Oct 2025 00:22:02 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id E0E4C1400D9;
	Fri,  3 Oct 2025 00:24:18 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 2 Oct
 2025 17:24:17 +0100
Date: Thu, 2 Oct 2025 17:24:15 +0100
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
Subject: Re: [RFC PATCH V3 07/17] mm: Add throttling of mm scanning using
 scan_period
Message-ID: <20251002172415.00003140@huawei.com>
In-Reply-To: <20250814153307.1553061-8-raghavendra.kt@amd.com>
References: <20250814153307.1553061-1-raghavendra.kt@amd.com>
	<20250814153307.1553061-8-raghavendra.kt@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BA125A0005
X-Stat-Signature: jysyugsp1orrbywben9dew1nbaopirfe
X-Rspam-User: 
X-HE-Tag: 1759422260-696403
X-HE-Meta: U2FsdGVkX18LvjI4EtGpFBF82mJ2lMyIh7hETDtEPAMrta4/QTS0/svzSUXnNTV0wMipveQg6c/Pe5VvTBz39eY1baZizibUvrV2FvVHtqdzXMW4HND3wNzYTfjR3Ns87pmqUquzlMa62zdd/dZrbi1J2ssWTCZhzzf723t8j73H2fDy3rB9W25ViAMjblTP6oIYFgYfaQYuxxOg1H3xJ9gHVaZJbY1owYe4E0KtU13n7KGeCGmAa2805hgqw8EsP0YFzIdzd2oLycNwqif9vlLYJYd9hnzFgSbvk1vB3gRyBZfdfSpIG4IezBkXh60rAo5K7z6jb5P9bvJRfr6ywBnwQJPKSmDMXDuV26O2GZUpWVrSk6k70hf/7x9eenl8Cms5HE+dzZlPxwGZEju4ynQoFhbRN8r+78rjv1H+TJGgOCIPb9/XL8yNMF5ofs2hC8iBIsmsnbtMhIud2Old+VXSxZi86GSOLOesOK1hgg5UUuF3wSK/Jf4VrN/KCbFct8EFE6oCBaPVb1ZC0Xfpg23C7av3m+56DougojM+0pXfjsY1nn0Asmjvfk+lHzAgjDcztK8W1ZpWGRHSnGAkeWEreVwAh88N8TGNZYVp/ATylk94ZA398b3QRUl6SRSb7sffOlNpJdgYFLL0WOPtqSvDmCCkEvR4x6q55DWE7Gir2FprBR3QMbhXiaPViGNsH9CWs9D8eWzKNrp2oeMzgaV9zRLvEflaRTpwphpw7lZ3ARzZPixKnIcdSpHl+UFEPrO26k6uKE8fxfpAotIHxpwZJZZHVBwx1c79r/LzM5Dc5ypWb+y5VMj7U7CONlF13EWmU4/fLkoYucy3NwLGXZ0tVnxACQnnV6nJrGGf1d89zj3snmtvS9O8B1IjH6XcwRx7DpIpZFE7rh+tFn3xB0O5w/JRMnttH4MQftmeh7LcTQFieyl5pVqsASYT9dmHrkYYUl27JEAjslxE9xS
 JjrUsGzn
 YoduO5bnOJZuhQuN6qWtHNBHP2jy5ySFtyMFspK66qSr7vkD5Crl22HIWi3U2nCuyk8uZxGptKgNVRJg1YAp9Yt5+B3i7h7Lto3+nepLszVYdyxe7zOyfIkw6eV3C5jNjueATdFCcxe4hsfXOlfHf08Gqmc5GhdpuwhwZV3bBswYBJrD7OZg+OWJYbAheQKSB2YZQJi62EIDqcyqIF72PVHyFEzb2XBuftS0ymlELBX1QLWa1N99Z9Mo2XG46e22gx1EYupuMVxq1NPnyQ9gfIf//ZCO9Mqok9/J1UfEau2hATxEv69+S1k4Zpx0nrpYH61ofQcuR0woj3Szz2QYEp2TEZ1ubbeGKq31rSBWj3nd1mlx5GhYF2CXhvK5FsyabOoy4OJJpAP4v+9/GMk2TBDQ9/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 15:32:57 +0000
Raghavendra K T <raghavendra.kt@amd.com> wrote:

> Before this patch, scanning of tasks' mm is done continuously and also
> at the same rate.
> 
> Improve that by adding a throttling logic:
> 1) If there were useful pages found during last scan and current scan,
> decrease the scan_period (to increase scan rate) by TUNE_PERCENT (15%).
> 
> 2) If there were no useful pages found in last scan, and there are
> candidate migration pages in the current scan decrease the scan_period
> aggressively by 2 power SCAN_CHANGE_SCALE (2^3 = 8 now).

Explain why those values were chosen.

> 
> Vice versa is done for the reverse case.
> Scan period is clamped between MIN (600ms) and MAX (5sec).
> 
> Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>

Various minor comments inline.

Thanks,

Jonathan

> ---
>  mm/kscand.c | 110 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 109 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/kscand.c b/mm/kscand.c
> index 5cd2764114df..843069048c61 100644
> --- a/mm/kscand.c
> +++ b/mm/kscand.c
> @@ -20,6 +20,7 @@
>  #include <linux/string.h>
>  #include <linux/delay.h>
>  #include <linux/cleanup.h>
> +#include <linux/minmax.h>
>  
>  #include <asm/pgalloc.h>
>  #include "internal.h"
> @@ -33,6 +34,16 @@ static DEFINE_MUTEX(kscand_mutex);
>  #define KSCAND_SCAN_SIZE	(1 * 1024 * 1024 * 1024UL)
>  static unsigned long kscand_scan_size __read_mostly = KSCAND_SCAN_SIZE;
>  
> +/*
> + * Scan period for each mm.
> + * Min: 600ms default: 2sec Max: 5sec
> + */
> +#define KSCAND_SCAN_PERIOD_MAX	5000U
> +#define KSCAND_SCAN_PERIOD_MIN	600U
> +#define KSCAND_SCAN_PERIOD		2000U
> +
> +static unsigned int kscand_mm_scan_period_ms __read_mostly = KSCAND_SCAN_PERIOD;
> +
>  /* How long to pause between two scan cycles */
>  static unsigned int kscand_scan_sleep_ms __read_mostly = 20;
>  
> @@ -78,6 +89,11 @@ static struct kmem_cache *kmigrated_slot_cache __read_mostly;
>  /* Per mm information collected to control VMA scanning */
>  struct kscand_mm_slot {
>  	struct mm_slot slot;
> +	/* Unit: ms. Determines how aften mm scan should happen. */

Name it scan_period_ms and you can drop the unit comment + that info is
conveyed everywhere it is used.  You do that for the global so why not here as well.

> +	unsigned int scan_period;
> +	unsigned long next_scan;
> +	/* Tracks how many useful pages obtained for migration in the last scan */
> +	unsigned long scan_delta;
>  	long address;
>  	bool is_scanned;
>  };
> @@ -715,13 +731,92 @@ static void kmigrated_migrate_folio(void)
>  	}
>  }

> +/* Maintains stability of scan_period by decaying last time accessed pages */
> +#define SCAN_DECAY_SHIFT	4
> +/*
> + * X : Number of useful pages in the last scan.
> + * Y : Number of useful pages found in current scan.
> + * Tuning scan_period:
> + *	Initial scan_period is 2s.
> + *	case 1: (X = 0, Y = 0)
> + *		Increase scan_period by SCAN_PERIOD_TUNE_PERCENT.
> + *	case 2: (X = 0, Y > 0)
> + *		Decrease scan_period by (2 << SCAN_PERIOD_CHANGE_SCALE).
> + *	case 3: (X > 0, Y = 0 )
> + *		Increase scan_period by (2 << SCAN_PERIOD_CHANGE_SCALE).
> + *	case 4: (X > 0, Y > 0)
> + *		Decrease scan_period by SCAN_PERIOD_TUNE_PERCENT.
> + */
> +static inline void kscand_update_mmslot_info(struct kscand_mm_slot *mm_slot,
> +				unsigned long total)

As below. I'd make total a local variable for now.

> +{
> +	unsigned int scan_period;
> +	unsigned long now;
> +	unsigned long old_scan_delta;

Might as well combine these two lines.

> +
> +	scan_period = mm_slot->scan_period;
> +	old_scan_delta = mm_slot->scan_delta;
> +
> +	/* decay old value */
> +	total = (old_scan_delta >> SCAN_DECAY_SHIFT) + total;
> +
> +	/* XXX: Hack to get rid of continuously failing/unmigrateable pages */
> +	if (total < KSCAND_IGNORE_SCAN_THR)
> +		total = 0;
> +
> +	/*
> +	 * case 1: old_scan_delta and new delta are similar, (slow) TUNE_PERCENT used.
> +	 * case 2: old_scan_delta and new delta are different. (fast) CHANGE_SCALE used.
> +	 * TBD:
> +	 * 1. Further tune scan_period based on delta between last and current scan delta.
> +	 * 2. Optimize calculation
> +	 */
> +	if (!old_scan_delta && !total) {
> +		scan_period = (100 + SCAN_PERIOD_TUNE_PERCENT) * scan_period;
> +		scan_period /= 100;
> +	} else if (old_scan_delta && total) {
> +		scan_period = (100 - SCAN_PERIOD_TUNE_PERCENT) * scan_period;
> +		scan_period /= 100;
> +	} else if (old_scan_delta && !total) {
> +		scan_period = scan_period << SCAN_PERIOD_CHANGE_SCALE;
> +	} else {
> +		scan_period = scan_period >> SCAN_PERIOD_CHANGE_SCALE;
> +	}
> +
> +	scan_period = clamp(scan_period, KSCAND_SCAN_PERIOD_MIN, KSCAND_SCAN_PERIOD_MAX);
> +
> +	now = jiffies;
> +	mm_slot->next_scan = now + msecs_to_jiffies(scan_period);
> +	mm_slot->scan_period = scan_period;
> +	mm_slot->scan_delta = total;
> +}
> +
>  static unsigned long kscand_scan_mm_slot(void)
>  {
>  	bool next_mm = false;
>  	bool update_mmslot_info = false;
>  
> +	unsigned int mm_slot_scan_period;
> +	unsigned long now;
> +	unsigned long mm_slot_next_scan;
>  	unsigned long vma_scanned_size = 0;
>  	unsigned long address;
> +	unsigned long total = 0;

Given this never changes in this patch I'd drop the parameter
from kscand_update_mmslot_info() and bring it back when you have code
that passes in non 0.

>  
>  	struct mm_slot *slot;
>  	struct mm_struct *mm;
> @@ -746,6 +841,8 @@ static unsigned long kscand_scan_mm_slot(void)
>  
>  	mm = slot->mm;
>  	mm_slot->is_scanned = true;
> +	mm_slot_next_scan = mm_slot->next_scan;
> +	mm_slot_scan_period = mm_slot->scan_period;
>  	spin_unlock(&kscand_mm_lock);
>  
>  	if (unlikely(!mmap_read_trylock(mm)))
> @@ -756,6 +853,11 @@ static unsigned long kscand_scan_mm_slot(void)
>  		goto outerloop;
>  	}
>  
> +	now = jiffies;
> +
> +	if (mm_slot_next_scan && time_before(now, mm_slot_next_scan))

If now is only used once, seems better just to put jiffies in the call
and drop local variable.


> +		goto outerloop;
> +
>  	VMA_ITERATOR(vmi, mm, address);
>  
>  	kmigrated_mm_slot = kmigrated_get_mm_slot(mm, false);
> @@ -786,8 +888,10 @@ static unsigned long kscand_scan_mm_slot(void)
>  
>  	update_mmslot_info = true;
>  
> -	if (update_mmslot_info)
> +	if (update_mmslot_info) {
>  		mm_slot->address = address;
> +		kscand_update_mmslot_info(mm_slot, total);
> +	}
>  
>  outerloop:
>  	/* exit_mmap will destroy ptes after this */
> @@ -889,6 +993,10 @@ void __kscand_enter(struct mm_struct *mm)
>  		return;
>  
>  	kscand_slot->address = 0;
> +	kscand_slot->scan_period = kscand_mm_scan_period_ms;
> +	kscand_slot->next_scan = 0;
> +	kscand_slot->scan_delta = 0;
> +
>  	slot = &kscand_slot->slot;
>  
>  	spin_lock(&kscand_mm_lock);


