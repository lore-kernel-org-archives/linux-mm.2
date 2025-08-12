Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06895CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 02:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786C88E00AC; Mon, 11 Aug 2025 22:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75E5B8E0045; Mon, 11 Aug 2025 22:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6740A8E00AC; Mon, 11 Aug 2025 22:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 555D68E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 22:01:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DCEA71A017E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 02:01:08 +0000 (UTC)
X-FDA: 83766452616.29.3989D9C
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf19.hostedemail.com (Postfix) with ESMTP id 444931A0007
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 02:01:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754964067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gNEQkRCwd5MBEJT02u2C81WJMNb8DyUO6Geb8dfcgWw=;
	b=O2Gd4VqdHYfaBXBF3MHeGjUze4qCTTSIRgOJu4zewqCnwDHt4RVZdSxw30pmztezV4cybw
	wMieLEiQqI0y4U/G+Har2sMvvbH0x1F7yg262vEXQ00pZD2uJEtwhjSkOJzfKw2K0D+fON
	KoY++ZjegtNk7lDjxzjXH/hk9aNgBng=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754964067; a=rsa-sha256;
	cv=none;
	b=JoG4EnmMuoVpudJoosUlBX8EOt4ZTw362FuNIj88sVfhES/pLG1qcORk4EN258V0GCwyDc
	yLnXQXhApQjTrWf2XdDXBohgVFLR7il/gi0ekHKYXPOWnq0cIM1ZU6U3eQV8T8E1ShxwSf
	Q4brc4nKPSUQBqAGpoZGoDe/KAmTVss=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c1F4z6yqVz13N5J;
	Tue, 12 Aug 2025 09:57:39 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A86B140259;
	Tue, 12 Aug 2025 10:01:02 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 12 Aug 2025 10:01:02 +0800
Received: from [10.173.125.236] (10.173.125.236) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 12 Aug 2025 10:01:01 +0800
Subject: Re: [PATCH v2] mm/memory-failure: fix infinite UCE for VM_PFNMAP'ed
 page
To: Jinjiang Tu <tujinjiang@huawei.com>
CC: <wangkefeng.wang@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <xueshuai@linux.alibaba.com>,
	<david@redhat.com>, <ziy@nvidia.com>, <osalvador@suse.de>,
	<linux-mm@kvack.org>
References: <20250811043323.899130-1-tujinjiang@huawei.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <c39474a9-31b2-7df8-8ce8-229f706b05de@huawei.com>
Date: Tue, 12 Aug 2025 10:01:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20250811043323.899130-1-tujinjiang@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.236]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 444931A0007
X-Stat-Signature: tay1ndswwk6eob3ks3jksewt5tqgesqc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754964065-791575
X-HE-Meta: U2FsdGVkX18/DAiqe6r7L1bR4EFo3Duiwt2GT6jiZm0XBkzGwTIaN1rvGSvHln/U2pNa4MxEzeksAvnga6CmIEQrUbuHAC7T2Nu6ZpALYOpge+lXC2PhsjtsjOCCMtjnHyO64KLUv3Nk6GtVvOAfKynAqMR/OrHzK8lmTB7eLIg5T1HBQT9hQlvOgX50w7g8MGXTMNoUr6JyR98OCmJRDBoWns4wYE94TVn1hdaNuiPCWxGQlY8WkCm3b1ytYNNvaopjPUYbFotnUw8ePfGqaabJB8cxVkQXBD+1Jrm8kwem2nzRo4psIJfiwmw7FasmWgOZtDrGcH+wtCcFiexDOTioDaHE05BRZTBMds6vuW/tdrIiFmHoidlBD6Mu9rTx8hvuw9z+SUU2I2KivKyTUHtkstGl8n1E9oPFwod41tMQRKZBuuR9Y7VbK+S92nIprBfYL7rDIDc1WhP/+oXW6Ho7zrdRJvhWRx8j9n3iFthfPioet9ZzicN6qBWIf2Gz32qB6tZvgSwLCq42rWw+BhZNqNfhu3TEPr1UEYygDv819neml7HpZDlfPjOAPaL6nzxhNls9N2Tt9QaiCzG91/WmK40vpPRmIIjtVti0SYW0qwvo13C4JhJ3kZTqz0PSjwyWgCkSAi7oZ7TLQ3RB6Ov8pIpYLiop7NEjOdhK+yBmgiXGPPM8RuX8/lLxL8zMndkDoKCx11xEGQJBL2oxlbHn1HTbvJBUQmzubU4R+AfSqAJYPyTQHhNxECWN3z6d5BUWRekS5ke6T/CTSJ1IVZ3FW6z93zhNa5sdVDL2HdFMrOgxumCVOcyrRLx1pK8saL7+GLL/mmNh8/+iPPeo8+uuPeksLrhBu+aTqFMs4jY3OkUWaoU8I9jmuFF6qNKbd2PiwmMbh1Yj7yXImuXWEsyRnfbzD1OXAXJoEV5ccKU30ptQDT0A7iYnAFK4pUuxEbzRZKIin6PDJJnNx/x
 pFyu6mER
 DKr3U3kaw8f6sMGUkgOxG87dIqbBTaGPfMp8tqqS505eP5mA9wHhMddsvMNyBmB/suzBdJ/HCHSgOR5L9YIApsBySaeGbD16xRDvQhA7CHMF6BeuiG7SwmiEDiHPdy+kTYan/DP1peYfWWAI4hGTz8o2PMKQ3jN59RM7wvjw+/4QTfIkjRUVtyfQ+jahcCA9L0h7rlKwH57LB789scsy/iXDVaXIWcve5A+RdNZZayHz8ynwfdISN4P0pDoLL/KOVFpfFwpqg9qaVN2A97tFlM36zD9AzubGUK/vtRyWtzsOI3Ev+Ps7AEE+f23cz2n1S2QA6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/8/11 12:33, Jinjiang Tu wrote:
> When memory_failure() is called for a already hwpoisoned pfn backed with
> struct page, kill_accessing_process() will conditionally send a SIGBUS to
> the current (triggering) process if it maps the page.
> 
> However, in case the page is not ordinarily mapped, but was mapped through
> remap_pfn_range(), kill_accessing_process() wouldn't identify it as mapped
> even though hwpoison_pte_range() would be prepared to handle it, because
> walk_page_range() will skip VM_PFNMAP as default in walk_page_test(). As
> a result, walk_page_range() will return 0, assuming "not mapped" and SIGBUS
> will be skipped. The user task will trigger UCE infinitely because it will
> not receive a SIGBUS on access and simply retry.
> 
> Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes
> with recovered clean pages"), kill_accessing_process() will return EFAULT.
> For x86, the current task will be killed in kill_me_maybe().
> 
> To fix it, add .test_walk callback for hwpoison_walk_ops to process
> VM_PFNMAP VMAs too.
> 
> Fixes: aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes with recovered clean pages")
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
> Changelog since v1:
>  * update patch description, suggested by David Hildenbrand 
> 
>  mm/memory-failure.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index e2e685b971bb..fa6a8f2cdebc 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -853,9 +853,16 @@ static int hwpoison_hugetlb_range(pte_t *ptep, unsigned long hmask,
>  #define hwpoison_hugetlb_range	NULL
>  #endif
>  

It might be better to add a comment on why below hwpoison_test_walk is needed.
It looks somewhat weird as hwpoison_test_walk simply return 0.

> +static int hwpoison_test_walk(unsigned long start, unsigned long end,
> +			     struct mm_walk *walk)
> +{
> +	return 0;
> +}
> +

Anyway, this patch looks good to me.
Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

