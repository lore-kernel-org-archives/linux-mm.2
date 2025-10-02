Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F061BCAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 16:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C3818E0003; Thu,  2 Oct 2025 12:03:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 478CA8E0002; Thu,  2 Oct 2025 12:03:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389428E0003; Thu,  2 Oct 2025 12:03:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 243108E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 12:03:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 533C5598A5
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:03:47 +0000 (UTC)
X-FDA: 83953644894.13.53DE3A7
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id 458074000B
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:03:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759421025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5gurbzwjzf3mFlKzZnamFaGKb20PPzdWE3kj9izchsk=;
	b=PcrjmLoHZODL1zv/q2i55V0299/CZA87yS9xk7sLm5Nf/Rjjyh+X8omyKWDCd4NobSNdGg
	oJzno9mNZ/OcV6O69gHuluGVlU/ge9awln4ZPgbsX99x7odPhuHNJdUSwyKW7NkVJ6UbPy
	5L5mpv6R47M/9CsqKQfZ/2GDsOmVgzE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759421025; a=rsa-sha256;
	cv=none;
	b=Q0cWDqA/9c4WbDHbVI1BbKx050s7aHOaz4qIYpUvv8VRZ5AG19vOvAJNIRbqKMYb75JpEt
	GB/zUY6ZCAdj3Y+KqFMrzZ/3x2AbgaI9ua3kal7GZNsVr+TeSk5BIYS6HezuvHd6fL7oUj
	lgji2g0HQgnBf5t9EDSOw38bzdd/Eyo=
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ccxRG3rQDz67ww1;
	Fri,  3 Oct 2025 00:03:22 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 59FAD1400D7;
	Fri,  3 Oct 2025 00:03:43 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 2 Oct
 2025 17:03:41 +0100
Date: Thu, 2 Oct 2025 17:03:40 +0100
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
Subject: Re: [RFC PATCH V3 05/17] mm: Create a separate kthread for
 migration
Message-ID: <20251002170340.00005ccc@huawei.com>
In-Reply-To: <20250814153307.1553061-6-raghavendra.kt@amd.com>
References: <20250814153307.1553061-1-raghavendra.kt@amd.com>
	<20250814153307.1553061-6-raghavendra.kt@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 458074000B
X-Stat-Signature: x4hftfsh5k8wj9c9wydrjcraq5cgp341
X-HE-Tag: 1759421025-889858
X-HE-Meta: U2FsdGVkX18KI7OQHFrFMYWRL2xRFEMVPR4UgyaEg7pm8cxSoh7Pc35VxW7YbD2XCUy0MFU1GF4+pKieGbnICmAs+UZPHghIr4tzeMQplad4qzbmmhNrgB58NkP3AvxG259rOgF/4eHbOkEiG6u7BoBrV721V7MjrR3PPX+GjmO38h/XR+jbPAtPZrJsrgFoJ48qnInFSfIVhpo31uA/hcKs6YRmnv3oG8jKf7BreqOZ6jTA6QzIC4FoK5ZooSNtnbzmgZhunui4KxD8reFJrBlvWtDwrtVuV5PwknHRjfDTxS7lonL9L6Ay4SozzDL7aEvCJ9bc23hSTtuc+jIBmHe8V/FE7EQ0xbR1MZ87+fB0NB15jmVZohxhtkQ+WEiB6owAr6X9S5QY+xToxCfQ0xpvN/Uk4RqMVMLSjtkz0X4bdG4jzL2s17qawLvUJmGwkUObym8YKgeapgMIm9O/kHVNIQFaRUWjENTCCfONagJ5+UFjlAoeSGXitEMrJjsldxlB8bR06Juo3CAzu7rIaawnHEzn/+W2JpgfPwMtI6BBs3yOVKAKH1UQdq6018dzbBQ4gv5hMrm3RVZLBL/Y5qXlsgu39KMPmE2UPP+k7Cp2mZR0biVW3UsvuvLC7ShF23Csf55fUyzMdsAipK44fFksoVyXJ5+s6ulBUVM0eBKkpvcqt4EiNjrJrgiWCiksgcDnl231LGPpiqIua/H4gayo6dnA4rjk6mZ06gFNgc864wiMEBXdZLYidjYTrViz0H4rZrasnZbt/pue9+hF34wfJxHaxO3/YpatZgHmz7HciQ/C7ooKohdv6uBTs3hZohNyqiKxZwXjazWKIHMnovMfraLB+0FD3otDGfcMvwFGb6FL8HvGs9oG9+FvyyB35B5Y45an0rXTM4vXLVzP5RrZx4OUrpDwezNm8BbEV1cSST7ekTcvx+E0AGlotp4lRNRwTI35lcwfkRrDEZZ
 FV9aElqS
 jwatZz5Lr2EeI4+htloiuKe4OtHQb2fia7gyKDmz5G9smHcqclBDbcQmFeAcaSqUhykhGH+dUUK1vlTVxtj8Xal+z54ni69y96Ns0C0GZWxWs3fabfOgqoBjDrVTydfFtEiINcuaRFVI0ptp2i6Ht4twurkMe0i7rCQzJIrwzjMAy9ABGSfK2ydK9ANVmn3dIpibWXhGvmSsgGfEKik72PmYNRgKscDN2rIQtjvRlhhjXyJLy5dNyOCZbdukX5rIxBRmCn31e8tJVsTkkIbXXIZxKUKdKsbIg8pVdPv58EM8xaV5gELVf7BUdDJsGYOWeRUqj1RV85T/KNdciU9jGxi26/mYofFgrtbM+QhuSJWrPtF/oEaBw24F9apO/LcSfJbFM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 15:32:55 +0000
Raghavendra K T <raghavendra.kt@amd.com> wrote:

> Having independent thread helps in:
>  - Alleviating the need for multiple scanning threads
>  - Aids to control batch migration (TBD)
>  - Migration throttling (TBD)
> 
> Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
A few superficial things inline.

> ---
>  mm/kscand.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 74 insertions(+)
> 
> diff --git a/mm/kscand.c b/mm/kscand.c
> index 7552ce32beea..55efd0a6e5ba 100644
> --- a/mm/kscand.c
> +++ b/mm/kscand.c
> @@ -4,6 +4,7 @@
>  #include <linux/sched.h>
>  #include <linux/sched/mm.h>
>  #include <linux/mmu_notifier.h>
> +#include <linux/migrate.h>
>  #include <linux/rmap.h>
>  #include <linux/pagewalk.h>
>  #include <linux/page_ext.h>
> @@ -41,6 +42,15 @@ static unsigned long kscand_mms_to_scan __read_mostly = KSCAND_MMS_TO_SCAN;
>  
>  bool kscand_scan_enabled = true;
>  static bool need_wakeup;
> +static bool migrated_need_wakeup;
> +
> +/* How long to pause between two migration cycles */
> +static unsigned int kmigrate_sleep_ms __read_mostly = 20;
> +
> +static struct task_struct *kmigrated_thread __read_mostly;
> +static DEFINE_MUTEX(kmigrated_mutex);
> +static DECLARE_WAIT_QUEUE_HEAD(kmigrated_wait);
> +static unsigned long kmigrated_sleep_expire;
>  
>  static unsigned long kscand_sleep_expire;
>  
> @@ -79,6 +89,7 @@ struct kscand_scanctrl {
>  };
>  
>  struct kscand_scanctrl kscand_scanctrl;
> +
Unrelated change. If you want it make sure to push back to earlier patch.


>  /* Per folio information used for migration */
>  struct kscand_migrate_info {
>  	struct list_head migrate_node;
> @@ -134,6 +145,19 @@ static inline bool is_valid_folio(struct folio *folio)
>  	return true;
>  }
>  
> +static inline void kmigrated_wait_work(void)
> +{
> +	const unsigned long migrate_sleep_jiffies =
> +		msecs_to_jiffies(kmigrate_sleep_ms);
> +
> +	if (!migrate_sleep_jiffies)
> +		return;
> +
> +	kmigrated_sleep_expire = jiffies + migrate_sleep_jiffies;
> +	wait_event_timeout(kmigrated_wait,
> +			true,
> +			migrate_sleep_jiffies);

Unusual line wrapping.  I'd go nearer to 80 chars and put at least
some paramters on same line.

> +}

>  static inline void init_list(void)
>  {
>  	INIT_LIST_HEAD(&kscand_scanctrl.scan_list);
> @@ -559,8 +626,15 @@ static int __init kscand_init(void)
>  	if (err)
>  		goto err_kscand;
>  
> +	err = start_kmigrated();
> +	if (err)
> +		goto err_kmigrated;

Similar comment to earlier on not expecting side effects of a thread to stop
if the start failed.

> +
>  	return 0;
>  
> +err_kmigrated:
> +	stop_kmigrated();
> +
>  err_kscand:
>  	stop_kscand();
>  	kscand_destroy();


