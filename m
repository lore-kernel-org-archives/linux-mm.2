Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21774CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 13:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DFE58E000C; Thu,  2 Oct 2025 09:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B78A8E0002; Thu,  2 Oct 2025 09:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CDE28E000C; Thu,  2 Oct 2025 09:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3747D8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 09:23:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB0C21A04B6
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:23:26 +0000 (UTC)
X-FDA: 83953240812.26.8098FBB
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id B84F6A0017
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:23:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759411404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LIURaOA+URx+5mEQKBEKqo0HUaLoDx871EgxsvfJwzw=;
	b=HCxpPon1aSJBu6p7aaXqhOXmZXpSWaCfcHv4FqiTW2XYSsYS2WfJGgskJkTaod43COCS+N
	yjfBmlWJicVZCPCa8rrWs8do8C91XlFZh3obYD89ReifMUc1L/Er99b5DIjgP2sqbhJYfb
	GhPl5Gt1EJVNOt47jZfbJsCmlgGsCA4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759411404; a=rsa-sha256;
	cv=none;
	b=YhVgAlO/VrUrR9ndqWLMphITWk+FeRdq1MV4+OX91JiZ6ouZtfJ4RkNpD2UdGUWvMbuk56
	M9bvQ1b0GnXVnF6Xvd5RRl1kRqnAyJTYYu4/dl1uRtsmRdYMuNAaD6V8UVnCwcAw8xTwSE
	8YAu8qEtEY2Q2j9pL2Ay3eSOkQW+7hk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ccsqz2cMyz6L4t4;
	Thu,  2 Oct 2025 21:21:03 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 5D8661402EB;
	Thu,  2 Oct 2025 21:23:19 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 2 Oct
 2025 14:23:17 +0100
Date: Thu, 2 Oct 2025 14:23:15 +0100
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
Subject: Re: [RFC PATCH V3 02/17] mm: Maintain mm_struct list in the system
Message-ID: <20251002142315.000072f2@huawei.com>
In-Reply-To: <20250814153307.1553061-3-raghavendra.kt@amd.com>
References: <20250814153307.1553061-1-raghavendra.kt@amd.com>
	<20250814153307.1553061-3-raghavendra.kt@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B84F6A0017
X-Stat-Signature: g5kwrpdg8izx94kgta4nr3jkq36st1wq
X-Rspam-User: 
X-HE-Tag: 1759411403-330462
X-HE-Meta: U2FsdGVkX18C7ZdYwiv8Y0WfJBj6KzwsJ/cngC/QYU/H3OrZgD7M8T5VaeqveXcMS1OxpVQBrCB7bLE9fGFsNJW602k0Kw110q9H42cl7lGv2yGG12fEBW/BOcPc/S7pawt21gAFH6ppsbfFxgC8YJD8cmyHJoIH8hyWC884RT1vFEjXgNEbIiv+xcGHiMnxVJrGZzvQ6GUXsozmfyd9l3zfIUgnhqBfc6aPwzsvoRanUJYy6dvGVvxbCemvAwu5gj9IwUmsyeJceBUWKdDwVGs+wrHFl9BwiXdfc9FDPxWnQPiAPGWGQ8lLw1v1DJfp+jhLOuSxeFxXiJd+yZXVzJl0kdx17/+yKqsKlQjPrl2cVMLw9fQUrqP0hRzOZJaQOSNV4+l+rEYTAV9C0Gb69Dg+2OetNHm7uG0yGSwfdHZR7jKt7ehLqQGFpM3osQ4MEFISRNc9tEyaI9X3aqyc+iYrsAItuTr+D3yJcUEID75OiBC8n08Mp9lPkw1RdSyHq/2XSezRhyW63HApAwQGpgIfg8hmWULiDLF7jQMngAeceqqanITsjv+Tu4QucN82nYG9QNgXZu3KsaAuPydIedbSTwc9n7s7jHiri9f6jMCZXyamThyn7G0BzXWrzAEeYCm6nJUD7sC37B6pF9RpLjTLCA0AwYCiw/igKTa0Og2C5spPBUAEcv92i9I7tw5vIIg9Jr5j7xgdkISmc09cTfyfqV0QiLvkpXg9QlMy1xM1BH68c8902Y9ZaU+377Jpd3h3NuzdGAxliq3kWiBZs+l7k+ZJVV001mR3IZwqaiFufgZX62eBI1kVOUaJWDulMwegDXxR7x6BNO8Ek9RiC7qVgAU+1AdSaIKSCED5NpWwRiKk6fsOKynFyd/v06S3jPEqUvCFQn7AYaDjaXb6tAdErCZPoumkeeNqAlp3NsAxywlOIl51V3JjXrKBuDlSrThKLHOigFdlxaN39Bs
 URuf/BPj
 nStFcM2HM/0LuKysqYXYbe4Y/2jL2su/VNOS3/t0UNYBq3G+AzLpI5Cty04W69BrM9PWMp1qT6wNzxMAymvnRDi1hb4jjkNgTaddMW8WIFtQEWDwi3PfKatBwjQcjJBfEaSsKULdwIKFfJR35vH5NpPnHxWCj9Y68Giav7Hw6WA1kW/bH28d8nEhGIfrcZHMeWcnRc9ySYEUFIixJM1M19XrMYF1/VC42tZEh90I/A9sZH9JSe4i4zQBuWtc1LJaHNPydbfv0j+gyYiVWvdcqWFqBT/ZBBBU0NwKPN5cI2TWF4SFjdG67my9zvHgiF1D5s8TLXj57TLc3sT00+ztsmMsKCwyVjnR+Dp186iS1cnEEJ3keclpGhtONSyki1dtHwSAI4LGMhdy1q9OK1bTe8SCeBfR8JjQyHG+I4FakQ4lClg4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 15:32:52 +0000
Raghavendra K T <raghavendra.kt@amd.com> wrote:

> The list is used to iterate over all the mm and do PTE A bit scanning.
> mm_slot infrastructure is reused to aid insert and lookup of mm_struct.
> 
> CC: linux-fsdevel@vger.kernel.org

This is part of the tags block.  Some tools moan if you have blank lines
in that.  Alternatively push it below the --- and it won't end up in
the git commit but tooling will still add the +CC.

> 
> Suggested-by: Bharata B Rao <bharata@amd.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>

A few minor comments on formatting.

> diff --git a/mm/kscand.c b/mm/kscand.c
> index f7bbbc70c86a..d5b0d3041b0f 100644
> --- a/mm/kscand.c
> +++ b/mm/kscand.c

> +void __kscand_enter(struct mm_struct *mm)
> +{
> +	struct kscand_mm_slot *kscand_slot;
> +	struct mm_slot *slot;
> +	int wakeup;
> +
> +	/* __kscand_exit() must not run from under us */
> +	VM_BUG_ON_MM(kscand_test_exit(mm), mm);
> +
> +	kscand_slot = mm_slot_alloc(kscand_slot_cache);
> +
Similar to below. I'd keep call and error check more closely coupled
visually by dropping this blank line.

> +	if (!kscand_slot)
> +		return;
> +
> +	slot = &kscand_slot->slot;
> +
> +	spin_lock(&kscand_mm_lock);
> +	mm_slot_insert(kscand_slots_hash, mm, slot);
> +
> +	wakeup = list_empty(&kscand_scan.mm_head);

Looks familiar.

wakeup = kscand_has_work()

Or maybe just get rid of that helper and check it explicitly like this.


> +	list_add_tail(&slot->mm_node, &kscand_scan.mm_head);
> +	spin_unlock(&kscand_mm_lock);
> +
> +	mmgrab(mm);
> +	if (wakeup)
> +		wake_up_interruptible(&kscand_wait);
> +}

> +
>  static int start_kscand(void)
>  {
>  	struct task_struct *kthread;
> @@ -149,6 +228,12 @@ static int __init kscand_init(void)
>  {
>  	int err;
>  
> +	kscand_slot_cache = KMEM_CACHE(kscand_mm_slot, 0);
> +

I'd drop this blank line. Keep the call and the error check tightly coupled
in one block of code.

> +	if (!kscand_slot_cache) {
> +		pr_err("kscand: kmem_cache error");
> +		return -ENOMEM;
> +	}
>  	err = start_kscand();
>  	if (err)
>  		goto err_kscand;
> @@ -157,6 +242,7 @@ static int __init kscand_init(void)
>  
>  err_kscand:
>  	stop_kscand();
> +	kscand_destroy();
>  
>  	return err;
>  }



