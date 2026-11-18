Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D8BF606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 07:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=J7jSSrjT
Received: by kanga.kvack.org (Postfix)
	id 441916B05B5; Wed, 18 Nov 2026 02:00:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 419B16B05B6; Wed, 18 Nov 2026 02:00:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32F846B05B7; Wed, 18 Nov 2026 02:00:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 043856B05B5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:00:54 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01F1BC067F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:00:52 +0000 (UTC)
X-FDA: 85447342386.09.1CD2855
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf12.hostedemail.com (Postfix) with ESMTP id 897C14000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:00:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=J7jSSrjT;
	spf=pass (imf12.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794985251;
	b=P5u+R+B1kUMrqWmB//kBgT2S05LLqXWNGWZVqGSvL1Xl+X84Tp+J2yaw8sJ1uYVKTZIu8j
	xERV6nCzWfkw3rfOH/kkR75ha9K0o/hEO5plMeQSl4ZRKR0NhqdUcczdkT0Qcq6Amx94YW
	xxWogbnaJewf4D9TNpTus+98gnTocpE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=J7jSSrjT;
	spf=pass (imf12.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794985251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P7MAWPsIyxJf7EbFe+B6P/kIKs4QOghNXNz4nngxpow=;
	b=DBOsHi0TGu4gC3xcl2CpXeKTdQMWMui0jo/1M2fmwq5/tK+Gl9mH+xDTUzzoAQoh26OwsM
	Y+Rj5Y+dFM8CzrI4ZywHsSwDx2hRNqCk78apzpCA9mEXe7WdFT4hElKz7PDpKsshvmrDYE
	FcFrH6XXq/jZTXipC4J9e4GUILygfcc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=P7MAWPsIyxJf7EbFe+B6P/kIKs4QOghNXNz4nngxpow=;
	b=J7jSSrjT45mE5pHwCz2jP6dil7Qtqxs30D1JSCVyUZxDpTWnLABaUARqY/hWeyFvY/IB9XGsp
	P+tfgFIg8WIVjm1rA89skfheUdG6YkoeqBaYgCDEUNGssDh+oDpRHRydEVFk6/GpGQol0k0xnUJ
	vFIRtHpdkDpniGa5blvowA4=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4jTstD2f2Yz1T4KR;
	Wed, 18 Nov 2026 15:00:04 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id E0224203AB;
	Wed, 18 Nov 2026 15:00:43 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 18 Nov 2026 15:00:40 +0800
Subject: Re: [PATCH v6 5/7] drivers/base/memory: count the poison a block
 already holds when creating it
To: Breno Leitao <leitao@debian.org>
CC: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<driver-core@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<rmikey@meta.com>, <riel@surriel.com>, <harry@kernel.org>,
	<kernel-team@meta.com>, Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador
	<osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, <kas@kernel.org>,
	<kexec@lists.infradead.org>, Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	<shakeel.butt@linux.dev>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-5-f304255147da@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <f0f5e60a-819e-68e7-09b2-4080f4716e9e@huawei.com>
Date: Wed, 18 Nov 2026 15:00:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261016-hwpoison-kho-v6-5-f304255147da@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 897C14000A
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: ah7hhhqp7nh3idw84rauazytwdstycwe
X-Rspam-User: 
X-HE-Tag: 1794985249-923841
X-HE-Meta: U2FsdGVkX18g9Y61jh70n9RMSQlhG2141TtmXQMqwIXZtOZyaY+zRkkKwrien8wnok8eTpl7fgmbujt1+p56zyt5G6DEobP2k132N5JO2K8u+DIK7rxRXTjm4kH4+56ZyHxyTG3Yl2nJVUzrvx4/W1+hZCRWc/ry9iT4pBw8hX/bU0R3+IV3JegTTdBaKi1Se+5zkc9y9KDI67Hr8IZjqyZGkVxGSFRu9oZLAl6XOJqyf98h69ZC5VRo0/rKrtQgPd/RlMb5JH/yuNqOopwfdaeZWi7VTm8tsrIXESicBO8/XO6e8iseZ+bkvo6f1dfPRjryApY9gAZt9rtTrFeO/ZiBerpXi8LP/zZMHJk+WnykJp/5etdyhSL7Rx9POiLNcbSloLNrDrp+5DmT9UNPnSSG0OWxEzfvflieK9rsYIMj/8ugB91iWJB600gMX2nCUXc53q7OS8Jo42GxuN0pSy7WzkUK9rL/tw0G2FGjqo1KyU3+szEH76EwgzO/Q3TMq0eQhTQhndV27xSumwapsbj+4ebueuoyZ0dKwjQG6VSNmATxdfiJtxL1mNdwOsc9RCVs1oShGluBLvUaRiRj8bmSLmZhlKqIQQ737ua7XjsodvoHGRcG+dinZirNz8hbUpnxakM56h4tepPPE9/KoESY0zFphO9hJ3QdmDkKsz/3ySr4AQ3XzFdAd3gwYSRABC3OyF0H9iCapKqwlXX61OznjdkSOXGJHednND5jY3j5mO2zoVYWrKRwlqxAl/8ChQnFK/RB/xtDIrur3f/37fUK/CGcOU8+SfHsZsVhtbX0l9HJ8VSl8Wajc/+muPznP5+jgQkIYWtl8Y2F99D9Ct0AxyIXqqKBwEfLj5Ot+lUwjnyyNrRtxg2rvTJAx872le1tBC/JSmPoAkNyiQNZ2s2tGkxItY9V0fmr3/fBj94Nwj4fJQVMAyjqwobJ+VC8mqCLFTnvse7VabFuWjl
 bpcf4Sq3
 qEshn3rIB4jcczXW44xhyjqHdd7o32lOcg4Q3KeYOaWPs5NQsu9/EkSgErwtSmkMn/JtnotRSZnTeISBxexaHLFUcvCBJLsBhbW+uy1uVQW3YCO13EU/tmpKLyliXhtkHsS48RNG+MNbfMap/aMb+YOaJHdLqxIyV45pQ8vVEBt4b9msWIFE2SAjtwrgSJzE2fhvOgeXPWG9MKk6VM8WfZ8aX53ew2e3ZvMrIkhtPfxQ6EnH5dcO5Z8AKVd3/H0A/SbHqc8P9OUcvH/Kr5q2Z/YOeTHOB+KqP1xmMMmgxCKW8AaHyeJHnMHdT2NAlgRAjw1bLO9F9B8JRLqAYCKYyj1fpInhYGdg+Od0dy/S6nVQ+s9nML9H6ezBzKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/10/16 20:15, Breno Leitao wrote:
> A frame flagged poisoned before memory_dev_init() runs cannot be counted
> on its memory block. memblk_nr_poison_inc() divides by sections_per_block,
> which memory_dev_init() sets, and the block does not exist yet. The block
> is then created reading zero, however many of its frames are poisoned.
> 
> Until now nothing could poison a frame that early. It becomes possible
> once a kernel flags the frames it inherits from the one that kexeced into
> it, as it initializes its memmap.
> 
> memory_block_online() refuses a block that holds a poisoned frame, and a
> counter stuck at zero lets one through.
> 
> Count what a block holds when it is created at boot. The walk sits behind
> num_poisoned_pages, so a machine with no poison does not pay for it.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  drivers/base/memory.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 5eead3346f1e32..77481f375c2206 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -220,11 +220,16 @@ int memory_notify(enum memory_block_state state, void *v)
>  
>  #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
>  static unsigned long memblk_nr_poison(struct memory_block *mem);
> +static void memblk_nr_poison_init(struct memory_block *mem);
>  #else
>  static inline unsigned long memblk_nr_poison(struct memory_block *mem)
>  {
>  	return 0;
>  }
> +
> +static inline void memblk_nr_poison_init(struct memory_block *mem)
> +{
> +}

If defined(CONFIG_MEMORY_FAILURE) but CONFIG_MEMORY_HOTPLUG is not defined, memory block
created at boot time will lose nr_hwpoison count. Is this expected?

>  #endif
>  
>  /*
> @@ -807,6 +812,7 @@ static int add_memory_block(unsigned long block_id, int nid, unsigned long state
>  	mem->state = state;
>  	mem->nid = nid;
>  	INIT_LIST_HEAD(&mem->group_next);
> +	memblk_nr_poison_init(mem);
>  
>  #ifndef CONFIG_NUMA
>  	if (state == MEM_ONLINE)
> @@ -1251,4 +1257,28 @@ static unsigned long memblk_nr_poison(struct memory_block *mem)
>  {
>  	return atomic_long_read(&mem->nr_hwpoison);
>  }
> +
> +/*
> + * Frames poisoned before the block existed were never counted on it. Count
> + * them now, or the first unpoison takes the counter below zero.
> + */
> +static void memblk_nr_poison_init(struct memory_block *mem)
> +{
> +	unsigned long pfn = section_nr_to_pfn(mem->start_section_nr);
> +	unsigned long end = pfn + PAGES_PER_SECTION * sections_per_block;
> +	unsigned long nr = 0;
> +
> +	/* A hotplugged block is created before its pages are online. */
> +	if (mem->state != MEM_ONLINE || !atomic_long_read(&num_poisoned_pages))
> +		return;
> +
> +	for (; pfn < end; pfn++) {
> +		struct page *page = pfn_to_online_page(pfn);

Above comment says the pages of this memory block are not online. So pfn_to_online_page
here will return the wanted page?

> +
> +		if (page && PageHWPoison(page))
> +			nr++;

Now that the table is a bitmap with one bit per 2MB of physical memory, would it be more
appropriate to process it at 2 MB granularity?

Thanks.
.

