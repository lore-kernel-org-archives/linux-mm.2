Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21D3DCCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 09:36:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2138E0006; Fri,  3 Oct 2025 05:36:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063208E0001; Fri,  3 Oct 2025 05:36:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E945D8E0006; Fri,  3 Oct 2025 05:36:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D066B8E0001
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 05:36:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 840BD5AC7E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:36:04 +0000 (UTC)
X-FDA: 83956296648.16.92F202E
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id 561F910000A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:36:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759484162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PpQeiq8jv9AGAvDe1G+zaA3L2G3TN/dnU1+546d/boI=;
	b=cg6KcCpuerKi/cCmgsOZaluGA5BtRPSSrmJvOlfjBXInN6vhslflUoSYkB8ouQTy7FFMRu
	vVwwr5HCamA7uAsY/0slWniOwldDzKxZytKzlQ8TaUJHA+luLUOJMRTU0XWiVM6Qg1/e+9
	B+W5Vt0yq0uptMg9ybtR5CiN0M+J1aE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759484162; a=rsa-sha256;
	cv=none;
	b=WXjdY0GErpUsRrJco6zoWcJhqZUDVtN9U3XkkZjYmZpKgs5TYXXYA4YrfbzODfK9BUYK6i
	zxGynzynWOruEi7Nw7TN9Rd23SyRydMlJ0SkeYRaO9q+XhFW/y493a7wteJKrzNqHiO8Bh
	g8//9qIsqEl68fpkpczIxrcyXzGjquk=
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cdNk85Vn6z6K8gH;
	Fri,  3 Oct 2025 17:32:48 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id E30771402EF;
	Fri,  3 Oct 2025 17:35:59 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Oct
 2025 10:35:57 +0100
Date: Fri, 3 Oct 2025 10:35:56 +0100
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
Subject: Re: [RFC PATCH V3 08/17] mm: Add throttling of mm scanning using
 scan_size
Message-ID: <20251003103556.00006e3c@huawei.com>
In-Reply-To: <20250814153307.1553061-9-raghavendra.kt@amd.com>
References: <20250814153307.1553061-1-raghavendra.kt@amd.com>
	<20250814153307.1553061-9-raghavendra.kt@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Stat-Signature: p835g3rnaeh16buicz36x3tba9dztifp
X-Rspam-User: 
X-Rspamd-Queue-Id: 561F910000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1759484162-145692
X-HE-Meta: U2FsdGVkX1/cOQVM52tZ1s/YUpreD2zwps5s52AamV8DArqz0rWcbVRBSxOW8oQYUvXzoU+m9g6mfscBzRvCT5R7U72p+dfvws/NkWUQSclrlO/aYT+giDsjgavL3AjB28MdDn/18X9MULBWew0Yr55HNm8nBJi8s6Mt0izGaEnBrfoUeBUBsOsG9K9Rtr7WH7/5A7Rp0Mnf5jZfN8f/XcVODf9GhzdKe4PWai+4Rm+mjcU2+AxnRcy8yBKFK3KOAOFYPu0vb3h5vGMXhYAfxVKjYMaaUkapttjpqFd9ZgLL3UVo3peb5aSNGGZTSV5v8pdyRjp1kxCXkMPj/8knPbXwEcR2RRUXI5DK2ErOX9piNCKCKPzKfpDkIfQSUc3h3ghr4cToKNrJDVjT4HusSPeTeaD00ctbPgoWl8JQTlkNQjRYJQO3cTrSHF+HEZMPad31sne14EPyNQVtkIHsRg4xw4LVlQLBGhJ9r5ss8WgURzhuBslAQ8i3Abi+dbqg3xa2AAUHGDs0grwq3aLzK5H3Vgu1o2/Kj8ktlfoXZR4W+u/9RF6U9EmQFwl4UUYeC3I0Xt98A74sarONQQgc/5B+R3P+0LDtKPTrNaf8AWPDv+j4MmB5A7rEibbyqn6gt8iIwu9DkAXz++wULT89O7Nn/bISDW679mY5WeJ5Fe2I84jEmv6r02yEb4q8TtrGf5iDLdOW+VCbDG/ibLCFsc+mAgr/ew3wiDGsoNmnVCsfcb9lqI2VYU3ue8SRz2xXmQUc10oh17ecRROoGM6YMsN97B+CS3iLqMBLXdXyKYxCbEKZMWnJSiaUaTkdN4f6jlINA0FViXMKAIGaX/bUg9A+TYpIVFCjEftc/PfIGNNtgf+tyOAaGWIhHIXy0VKvlooFysGQk5d+InHvneN6NIDSnHgESGqle0XEp7yfesTIyCA7mOJeo2GWWWskCxuWkAbiiYCkxqfVv4hs6h/
 4AYe9QdL
 E0HlnuU7lmSNxOAQwXbgFsO2AeQcv5164al11KfzAGFwR9PQCipVkM//Wt2lTiRgGXehZls3aLuzIT5vs6r+w9lffJtLe6+DSBivjw0qAHGckDVAT9E6b3rO9lLnq+wkaICZvPwwuuBNsl2G8IXJ+HMhHNtHGaI6dM+0eiNAKIHa9XZ2vU6W1HEyQEN/Kr9yDvYOFGDpgygsm+HhRSPkUleh54QnWIKvKBLwdwK233FMyCxAF4gsatFNnqkxvCFjfhDv5gxC7vNMAyi5fS0yaJ6gjEDBg921g3ldsDilAM0YM304M+pxW7djukGbE97YpQDi/d7jrNENe4qyMggdrkycw0e/kiOU0gmRRrqAfRFMrDnAwsmrbmVBTjPv1Hs/+uTxOrZ0U1FHuWCH5Uw+JcnElTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 15:32:58 +0000
Raghavendra K T <raghavendra.kt@amd.com> wrote:

> Before this patch, scanning is done on entire virtual address space
> of all the tasks. Now the scan size is shrunk or expanded based on the
> useful pages found in the last scan.
> 
> This helps to quickly get out of unnecessary scanning thus burning
> lesser CPU.
> 
> Drawback: If a useful chunk is at the other end of the VMA space, it
> will delay scanning and migration.
> 
> Shrink/expand algorithm for scan_size:
> X : Number of useful pages in the last scan.
> Y : Number of useful pages found in current scan.
> Initial scan_size is 1GB
>  case 1: (X = 0, Y = 0)
>   Decrease scan_size by 2
>  case 2: (X = 0, Y > 0)
>   Aggressively change to MAX (4GB)
>  case 3: (X > 0, Y = 0 )
>    No change
>  case 4: (X > 0, Y > 0)
>    Increase scan_size by 2
> 
> Scan size is clamped between MIN (256MB) and MAX (4GB)).
> TBD:  Tuning based on real workloads

Seems like a reasonable thing to do, but as you say tuning
data needed to justify how aggressive this should be and
those size limits.

Trivial stuff inline.

> 
> Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
> ---
>  mm/kscand.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/mm/kscand.c b/mm/kscand.c
> index 843069048c61..39a7fcef7de8 100644
> --- a/mm/kscand.c
> +++ b/mm/kscand.c
> @@ -28,10 +28,15 @@
>  
>  static struct task_struct *kscand_thread __read_mostly;
>  static DEFINE_MUTEX(kscand_mutex);
> +

Push that into earlier patch to cut down on churn / noise.


>  /*
>   * Total VMA size to cover during scan.
> + * Min: 256MB default: 1GB max: 4GB
>   */
> +#define KSCAND_SCAN_SIZE_MIN	(256 * 1024 * 1024UL)
> +#define KSCAND_SCAN_SIZE_MAX	(4 * 1024 * 1024 * 1024UL)
>  #define KSCAND_SCAN_SIZE	(1 * 1024 * 1024 * 1024UL)
> +

Likewise.

>  static unsigned long kscand_scan_size __read_mostly = KSCAND_SCAN_SIZE;
>  
>  /*
> @@ -94,6 +99,8 @@ struct kscand_mm_slot {
>  	unsigned long next_scan;
>  	/* Tracks how many useful pages obtained for migration in the last scan */
>  	unsigned long scan_delta;
> +	/* Determines how much VMA address space to be covered in the scanning */
> +	unsigned long scan_size;
>  	long address;
>  	bool is_scanned;
>  };

>  static inline void kscand_update_mmslot_info(struct kscand_mm_slot *mm_slot,
>  				unsigned long total)
>  {
>  	unsigned int scan_period;
>  	unsigned long now;
> +	unsigned long scan_size;

Combining a few of these or assigning at declaration will reduce the code size a bit
which is always nice to have if it doesn't hurt readability.

>  	unsigned long old_scan_delta;
>  
> +	scan_size = mm_slot->scan_size;
>  	scan_period = mm_slot->scan_period;
>  	old_scan_delta = mm_slot->scan_delta;


