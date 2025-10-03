Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 979BFCCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 09:41:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1CC08E0007; Fri,  3 Oct 2025 05:41:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF4E38E0001; Fri,  3 Oct 2025 05:41:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C314F8E0007; Fri,  3 Oct 2025 05:41:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFF1A8E0001
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 05:41:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A3DFC0742
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:41:51 +0000 (UTC)
X-FDA: 83956311222.03.F2F3E7A
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 96EC0140007
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:41:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759484508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eWLj7T/EJ2OEAL6KYzhlBQvi5OgM3yiH1Dl4hMKL80U=;
	b=RYIHFUDTHtL4TQnBBlUQhjrf44oQLVQDOkr4TB4I5gVsuqZqxU5uJLueSPiYt09D2PwbhA
	aQQZs3ugUn9wu1LHa6eosi5yGAB0/doL3wASCJM0krsfopw2x3nJij5kvs4KkZGRb3HMuW
	omvBIrvGOwGEnmiimrr78uF12lrOQzg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759484508; a=rsa-sha256;
	cv=none;
	b=cLgLiFF/IfBQSHLxnG3gCSWa2lPY3+6y1Ie7pXl33f4Cee79fMNLs7UaZskvs/2P/Ld5Om
	BhJn3cdw1HszrCZftfl8TKbljLgGHzkujVS0vv7ahKDUI0PCpWAOESkEmaEaybK7AZfIkX
	PoHo2vu9L8SDvfgfGvZjyIRc20Wm84Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cdNsq1bKyz6L4tL;
	Fri,  3 Oct 2025 17:39:27 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 9E68B1400D9;
	Fri,  3 Oct 2025 17:41:45 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Oct
 2025 10:41:43 +0100
Date: Fri, 3 Oct 2025 10:41:41 +0100
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
Subject: Re: [RFC PATCH V3 09/17] mm: Add initial scan delay
Message-ID: <20251003104141.00001744@huawei.com>
In-Reply-To: <20250814153307.1553061-10-raghavendra.kt@amd.com>
References: <20250814153307.1553061-1-raghavendra.kt@amd.com>
	<20250814153307.1553061-10-raghavendra.kt@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Stat-Signature: spys6uc1oyuxct6zqeje3zb7xbcrrb4e
X-Rspam-User: 
X-Rspamd-Queue-Id: 96EC0140007
X-Rspamd-Server: rspam10
X-HE-Tag: 1759484508-126477
X-HE-Meta: U2FsdGVkX1+PnHNeVARBoF1Osto1eQsySf2VvWngZeCfOzpTydWnxRSenqv8Ki2fl/Li10Gy37z0H0ilC69XJg9urNl0telnZ2UgUEF5cCxmLolyDZgVoG8Yaxe6Gqg0LAHPs3xhK/FwtoDUJV8dckBsoH8Siv4Roj67yXPrk9wnhD9s/zZlqFomjV3q4pa6jHEzYnjyxRvoN5w9lovpjBtUX6E00MKUMT7eqDxEeFQ6QaXCEg6W4p51fsQbdJkzT8bAJlXfOmZcNnvCIYz2vp07zPiIW6H+pvVNQeLJOE6ME2xe1Mcgl9Xc0E6soi2HfyGNs+47yTf4QXTyC6wtlDEkHQF6DgR1l8pn4B/5PsNSVIyNLUT9g2lJCfdLcPSLaZy8i9C7fTgQEvzO+Y7UagzOw08SRU8El+OOLjQC0bEzfc9Mn9YPVVAPSNK7PRByJaEjEbMiPxIcy21OLYWDs8sCwkYHswwGqKe9YNxyXwO80aK5toxOGvZ9beSRJkaeDVZ2RRVpBt312GdxIIgvXsg/YMFJvh8VhVDK8tWerrFfLA+L7Hmwc8dEL94n1Jtd3M1IZh94Mv6bMrWclJ2s6xoDWBnzASxeKANFLDtzEfoSMDT37eSUccIH/zNWfTfoDsSGY6hjr3VmyMg8ozun0xAvXNy40sXe9A0yGVRmAJuSBf3iiy9kI6FhGlOfeHFeOztKAx6GukuhsQn5Z+a0jc61CvrJBPtqlquBBbHawPgSSMypBLsvdu/pt696lyaky/dsR3SdE5OBYA7/CcMr0mmVeWi/Z4R/gPPS462+CaatLDrbvQqlm21iXV6l/G6vHwwgsYjBBXE2dGEDsjknvHkfKbhdKzdGR2Tio2Ef1ECSZPZ/jP4AdVnoMZlTrlmf0vm8Tbefaq+9Ux5gAIKKIjiRbbKqSP89GkuszMcOr1KVprIZ+tNPlzGZStSYq2airrmZO4D5d66lskr6el7
 nczOqkQ6
 Da++GcHV6P2YqSGknxk6UwYwPskOo5fxsge8iML9MqpPQP5NI1FOqxW+upvWe+GiBgqKqJbt2WZUQazHdWYbszQmK4Ymiq5R6JxgJQFpZ3KmREScfs/C2lDuLZspfyeCntRfxLUkpGinyVuboISt2b7aM/e2mWxTTDi0ryf2tlLCQw36x0pnjJZnQHSS5HmmM/I4XAFijt9UP6XFmpT7gixAVWG0t5kRhJdTs7Cx1avMTrBNNJ2KX0GTJNRZEa0HNli1AHexFC+OpViBmVIhM9x+tbSidM7PbCEA/tTljCcFIThitImzYDzov+XeoGM7gwg7a/fHNZy9B8S7rYY2GxpxHBaCKjYl3MRcj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 15:32:59 +0000
Raghavendra K T <raghavendra.kt@amd.com> wrote:

>  This is  to prevent unnecessary scanning of short lived tasks
> to reduce CPU burning.
Add a tiny bit on why reusing the existing sysctl value.
Also useful to add a comment here on current default of that
so when considering this algorithm we know what it is.


> 
> Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
> ---
>  mm/kscand.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/kscand.c b/mm/kscand.c
> index 39a7fcef7de8..880c3693866d 100644
> --- a/mm/kscand.c
> +++ b/mm/kscand.c
> @@ -28,6 +28,7 @@
>  
>  static struct task_struct *kscand_thread __read_mostly;
>  static DEFINE_MUTEX(kscand_mutex);
> +extern unsigned int sysctl_numa_balancing_scan_delay;

Maybe we need to move the declaration from kernel/sched/sched.h
I'd rather see that than a somewhat hidden away extern declaration.

>  
>  /*
>   * Total VMA size to cover during scan.
> @@ -1010,6 +1011,7 @@ void __kscand_enter(struct mm_struct *mm)
>  {
>  	struct kscand_mm_slot *kscand_slot;
>  	struct mm_slot *slot;
> +	unsigned long now;
>  	int wakeup;
>  
>  	/* __kscand_exit() must not run from under us */
> @@ -1020,10 +1022,12 @@ void __kscand_enter(struct mm_struct *mm)
>  	if (!kscand_slot)
>  		return;
>  
> +	now = jiffies;
>  	kscand_slot->address = 0;
>  	kscand_slot->scan_period = kscand_mm_scan_period_ms;
>  	kscand_slot->scan_size = kscand_scan_size;
> -	kscand_slot->next_scan = 0;
> +	kscand_slot->next_scan = now +
> +			2 * msecs_to_jiffies(sysctl_numa_balancing_scan_delay);

I think one tab beyond line above is enough for indent here.

>  	kscand_slot->scan_delta = 0;
>  
>  	slot = &kscand_slot->slot;


