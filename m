Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91055CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 10:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7F308E000A; Fri,  3 Oct 2025 06:10:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56FB8E0001; Fri,  3 Oct 2025 06:10:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6D348E000A; Fri,  3 Oct 2025 06:10:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B32CC8E0001
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 06:10:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6449314073F
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:10:42 +0000 (UTC)
X-FDA: 83956383924.28.9111852
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6A8A5C000E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:10:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759486240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z5LE5la4vH515j8B8M4gP9iPiY+KxqkA0CjAyviV8oI=;
	b=fwcf7uKy9J3d5E/Lpu5K7y5u48WtPtFZODfLqZANf/18sMYUVeS/wHriS32CskkdI+iU2N
	7kkoJNoummi/s06n0UsHm5PByI/d3/TmGsgxRK+fDb+Rs11WeZ9epjxNVLCkrZfNCJOYLG
	g56EeaHe0bbZMB/dD4x5W4TaHCerT8A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759486240; a=rsa-sha256;
	cv=none;
	b=2NHdfDeMSWGmayvmTkSHjwvTWALMGTG/qV3deTZXVkFdnzbv2s/JPeiQVh8477kf1iFSTP
	3+52uUCXJAQoHzov4guET8Zq+SS8rHQIVIah/KUjtgbVTSPeS39JlOhAiXwYu6vBFF13fO
	cyoW78pjbFEtWJ4RDEzKiqsmEVl74kA=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cdPYK6YGHz67bVD;
	Fri,  3 Oct 2025 18:10:13 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 256911400D9;
	Fri,  3 Oct 2025 18:10:37 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Oct
 2025 11:10:34 +0100
Date: Fri, 3 Oct 2025 11:10:32 +0100
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
Subject: Re: [RFC PATCH V3 11/17] mm/kscand: Implement migration failure
 feedback
Message-ID: <20251003111032.00004688@huawei.com>
In-Reply-To: <20250814153307.1553061-12-raghavendra.kt@amd.com>
References: <20250814153307.1553061-1-raghavendra.kt@amd.com>
	<20250814153307.1553061-12-raghavendra.kt@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Queue-Id: 6A8A5C000E
X-Rspamd-Server: rspam05
X-Stat-Signature: i6jtpmpm544aqwn31h1kazc7kz874iry
X-Rspam-User: 
X-HE-Tag: 1759486240-500787
X-HE-Meta: U2FsdGVkX19jl61VkLVV05XYNkgbnvbMYR2u0A/A8teU1GxNolgogKFTMwGHqwZdjYyqn0JlztvL6QjoWUuqolMnbtUsFXSzbGGa6cUqOyUbxb+rPmYxc3v2FH/YjpF9BU46Jca07LC/tQZBoRmtdXXLj9KhTbjfsMYCD9ux8YmXc9JTp6LuG1QVdT/dpXn+s5UdGnWfidc3wPTupsJcBrgMCWG0T5kWaK45FnRyM+qmb7GOJ0KuX1rnNZjMiaM4rhaqH+20C+GyZUPJazDDwmEg4ie/iTLfu2jCY/equFVVj0NwCw69Sqm5v8DmqydbgsNH4IvRw3IEKN6AoADH/7L3OKRjg2O2PJ051mGIhWI93UUICs3SeOVUfOEz87OObKPmCzWUv9poP51OuFpZli3GSyyxaU3InFB96GPpMgZu7Qz+7tiE00NuTxWVTfxJeqPiQdZ6QVYz0DDguBIaO5zyBEpt9i/GCPhEakCQJo33vP6wGctoA4hVweGbjdBTQOyO/s5INofh6gvUWL9l7YHsYD2e3WFRTsF6dSIMMauf239cs5ThXMOCWxCKU+yM7aufXLVbCUTAd4tUHIZbowiOZIk2BSeh+4YwOqMq6uR1xHG42Lmoh91CxaG/P6/aVXJmqe0JMw9j3KVeAlCMLX5RDiNgiTTq3zkHRHyWh3tmJ5lQvzqlFEq9hgqs3qRgGF6zk5JZLb1MtJgodCuXQhjIsStib75v2nLdyyu+ENgC05ukyLFZyOm2c0XzTQt5SwXR2u1KDeBBWDf2WA87IFDn4tIkWzSDjQ/2oIYV50cQXL5GK5q5YLcvKB7rV532FRDqmCCwP743JoHSCZ+a+TB+oEV9iOwlFGBKxR+szlSvToUgrYs7y93P8BkqIGllwRlBCBkfJwt6OpCOUAn7r0jHFHVAHJl490372fIxNcxnbXVeEnQ7pT5rZpnF/UxIn6rW8w/mSST70utfSV9
 PqKRvbfv
 3MDEmjjc+tv7OYxCYDc2j9RoB34rhIxcQ+cUhLvZ08lVlp8gGeT3EjT5AOVCpjsrKrOorsrFyzyxfYTuc8HIz3nQdrY7x+e689EZ38wnofyrS7sEfizP+UM+8+eXJnaZkp2XcZFwUpathIWxRO4/iyAPKGRh9tL7207JMQphDRZWGzCn8ED9mDEXApOKYRBJMrazWRq9XuJ0yj6l6wNXkEKNrCBsUAc16OZoOdnh7okBFKVLYTwdeLd3IKJzdmmJfedBR+NRz8NvqDihhTNKucQF0Yb55z5B7rPh4EUNkofIEg0Cy9OtqFhhaBW7uuCn+GNQi5QP6s0jXqE0nH4MiDOMioAFXx+GAQngr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 15:33:01 +0000
Raghavendra K T <raghavendra.kt@amd.com> wrote:

>  Before this, scanning kthread continues to scan even after
> migration fails. To control migration, scanning is slowed down
> based on the failure/success ratio obtained from migration
> thread.
> 
>  Decaying failure ratio is maintained for 1024 migration window.
> The ratio further contributes to approximately 10% scaling of
> scan_period.
Perhaps it's worth adding a cover letter section describing all the
heuristics briefly so we have a central place to understand what
needs tuning against workloads before this merges?

J

> 
> Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
> ---
>  mm/kscand.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/mm/kscand.c b/mm/kscand.c
> index bf975e82357d..41321d373be7 100644
> --- a/mm/kscand.c
> +++ b/mm/kscand.c
> @@ -146,6 +146,8 @@ struct kmigrated_mm_slot {
>  	spinlock_t migrate_lock;
>  	/* Head of per mm migration list */
>  	struct list_head migrate_head;
> +	/* Indicates weighted success, failure */
> +	int msuccess, mfailed, fratio;
>  };
>  
>  /* System wide list of mms that maintain migration list */
> @@ -812,13 +814,45 @@ static void kscand_collect_mm_slot(struct kscand_mm_slot *mm_slot)
>  	}
>  }
>  
> +static int kmigrated_get_mstat_fratio(struct mm_struct *mm)
> +{
> +	int fratio = 0;
> +	struct kmigrated_mm_slot *mm_slot = NULL;
> +	struct mm_slot *slot;
> +
> +	guard(spinlock)(&kscand_migrate_lock);
> +
> +	slot = mm_slot_lookup(kmigrated_slots_hash, mm);
> +	mm_slot = mm_slot_entry(slot, struct kmigrated_mm_slot, mm_slot);
> +
> +	if (mm_slot)
> +		fratio =  mm_slot->fratio;

Extra space after =

> +
> +	return fratio;
> +}
> +
> +static void update_mstat_ratio(struct kmigrated_mm_slot *mm_slot,
> +				int msuccess, int mfailed)
> +{
> +	mm_slot->msuccess = (mm_slot->msuccess >> 2) + msuccess;
> +	mm_slot->mfailed = (mm_slot->mfailed >> 2) + mfailed;
> +	mm_slot->fratio = mm_slot->mfailed * 100;
> +	mm_slot->fratio /=  (mm_slot->msuccess + mm_slot->mfailed);

extra space after =

> +}
> +
> +#define MSTAT_UPDATE_FREQ	1024
> +
>  static void kmigrated_migrate_mm(struct kmigrated_mm_slot *mm_slot)
>  {
> +	int mfailed = 0;
> +	int msuccess = 0;
> +	int mstat_counter;
>  	int ret = 0, dest = -1;
>  	struct mm_slot *slot;
>  	struct mm_struct *mm;
>  	struct kscand_migrate_info *info, *tmp;
>  
> +	mstat_counter = MSTAT_UPDATE_FREQ;

Might as well set at declaration above.

>  	spin_lock(&mm_slot->migrate_lock);
>  
>  	slot = &mm_slot->mm_slot;
> @@ -842,11 +876,23 @@ static void kmigrated_migrate_mm(struct kmigrated_mm_slot *mm_slot)
>  			}
>  
>  			ret = kmigrated_promote_folio(info, mm, dest);
> +			mstat_counter--;
> +
> +			/* TBD: encode migrated count here, currently assume folio_nr_pages */
> +			if (!ret)
> +				msuccess++;
> +			else
> +				mfailed++;
>  
>  			kfree(info);
>  
>  			cond_resched();
>  			spin_lock(&mm_slot->migrate_lock);
> +			if (!mstat_counter) {
> +				update_mstat_ratio(mm_slot, msuccess, mfailed);
> +				msuccess  = mfailed = 0;

extra space before =

> +				mstat_counter = MSTAT_UPDATE_FREQ;
> +			}
>  		}
>  	}

