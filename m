Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC0ECA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 12:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64CE6B00F6; Tue, 19 Aug 2025 08:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B43828E0016; Tue, 19 Aug 2025 08:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7F2F6B00F6; Tue, 19 Aug 2025 08:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9629C6B00F6
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:04:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4CD511DE09A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:04:03 +0000 (UTC)
X-FDA: 83793373566.06.4CF7503
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf23.hostedemail.com (Postfix) with ESMTP id AEAF2140004
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:03:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755605041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YgWRdLf1462UNgz1/z5wPe56KkLemvESs846zMLr0n0=;
	b=YqZp7m3m1ixFqejiPH73spUmlu1tbLb6NcPylUCedtwSyUMAhuLO90dWLd5bPcmTjOn1Hn
	n4mZOGHMI0Pd1fSee0xQeDBcf4T+N4FaqiOIpKWB+2Tf0jNqBpBVhJRDbQGNpEfn6FdOxw
	lgtF6O160u4jdbbli6jVnfsjeBe+iLs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755605041; a=rsa-sha256;
	cv=none;
	b=LTMg7eSKprh0gAlTzCR1FadKk5pwIHb4NFKLi+BB+rVoxKvIRX6p/LTTfwPcf6kos6kHo3
	92bOmenjAhPvVfuTmslk5hjieADONQZphh7J7nfRPbDBEWQ8ZrUmQZAKeZI8+7/9nSGvKa
	uprdRpRsXy57TLkzfwX0WG9MIpv8+Is=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c5pCD09CCz14MdQ;
	Tue, 19 Aug 2025 20:03:52 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 6927118007F;
	Tue, 19 Aug 2025 20:03:55 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 19 Aug 2025 20:03:54 +0800
Message-ID: <8ee28bfb-9434-4c3e-b039-6c80c00af1cd@huawei.com>
Date: Tue, 19 Aug 2025 20:03:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] of_numa: fix uninitialized memory nodes causing kernel
 panic
To: Yin Tirui <yintirui@huawei.com>, <robh@kernel.org>,
	<saravanak@google.com>, <dan.j.williams@intel.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <rppt@kernel.org>,
	<Jonathan.Cameron@huawei.com>, <devicetree@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: <chenjun102@huawei.com>
References: <20250819075510.2079961-1-yintirui@huawei.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20250819075510.2079961-1-yintirui@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: t4n6y9fp8uq5ig5xiahw1d5icbzuzmsk
X-Rspam-User: 
X-Rspamd-Queue-Id: AEAF2140004
X-Rspamd-Server: rspam01
X-HE-Tag: 1755605039-309287
X-HE-Meta: U2FsdGVkX1+qsYzvNdK97pwueoc5biDxKn7tLSzeoofkwv1o21p5iixqk2azTv5um8OaY6Mjpjbu+otaWV+0ZL2JUdyXzAk3wQf73Wg1H6RxVnvqVndAt3ntZaFsn6I1O9S/gFcFfL3C8BG5jswZmuXFqoOJ9LARUJo8dQvZuyZmknSVJZpvIVLKzkHTYR770Wxe8UzMxfiBl5qCUVXVToPXZ29ehfen/+QQreRevQKhIn4BJI7BDiyBXF1xpB86Xri8pLilb3r12PYDVDEztp/1J73fgndJXXHPGFTWXNE0ooV4cHHCZmzRmiN9iIptOgwrhFroH55jQFQ/43X2lOuv7hex12+CKBTqOW8VOdh6VGNZQtiWNLUtbyd/BOvwvLt99sUrXxHzRmLHcRxgnZ2VTWFjUemRUeVXTIoVeU7vqLMNssySu5WRbnK1yFwRJyNpTpf75vmnlqi3ZSCEchyJRvDB0vgH3HEYsrRapw8hRlOJnOqTNNLGSqxLzjkuIKonBVhwlup98LNdss59QXXieqjurn5q6M/g6Iwq0LdrMpeU2r0t0qLo/Yb3UUgP6ifm+/6IRrqI0WEX6Brm/u4QnghjOcaTQni71Ktdcpp7Y9duhlLZRnHmV9YIuWcxDM6zAI06AT9z8pfafdcoDH5PDC8QvOZX99Sdy95fmNGh2JfdSKLnB2HWiUognJ7Faw3S7G44s+6jJV0WrW/4z8tZjaeUucXDabzNolALF4THumJ289JUdc7fe7klOOh5Z5UIVimiD7OfP+BVu15qFT8z+X23ZLGF6ZVmbFyMYkmtnAF+vlGDAfm19UTH4p1IlDEWK52+o9RKG0jqCXUZqu7qtDEIaXujstDSKSU5fWTSQw1w1f05IoL/2VrvTVEZ9DxeM705HBWq5pZywMSlDRBHVUqS093GkcdWYh766yQt7cZaGQU4/KeClAWWHuheWUHjQjuDhx2beXUUpQQ
 GhEm7Xxl
 tiXbhQBuHnQE3SjgpjeJZ3SypFqi9ZkiK0sXpR+b5R6gZ5mehqB1mkJ6y/wulwgdFqLBP4/eWqCEIUxofyqq2MMz9ofXiAGpqAsNiLxS1d/B5Zw4nfDRHuJ4ez5GOtHwJRni6p1VxxNb2s0pbmUAkSNillHK9tbAPywYgesFsTVh2E0kxG6cTfusIh/Iiu7Xqv2MDXkgZyL06H7rYBM+t5E9Qt0DafFSp7HEyMbKdCoH6cWhZY4xtxuWRdQod6jq8jI+pZjHcv1Scq/PBdXEqCObEDjUAczc198XgOp1rGZYSUGtDu2oJFcG+sNevJAcY+oxfplQmi39+ZnFnOez3Pzcu9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/19 15:55, Yin Tirui wrote:
> When there are memory-only nodes (nodes without CPUs), these nodes
> are not properly initialized, causing kernel panic during boot.
> 
...
> 
> v2: Move the changes to the of_numa related. Correct the fixes tag.
> v3: Only amend commit message with no code changes.
> 

This part should be moved under "---",

Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>


> Cc: stable@vger.kernel.org
> Fixes: 767507654c22 ("arch_numa: switch over to numa_memblks")
> Signed-off-by: Yin Tirui <yintirui@huawei.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---
>   drivers/of/of_numa.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/of/of_numa.c b/drivers/of/of_numa.c
> index 230d5f628c1b..cd2dc8e825c9 100644
> --- a/drivers/of/of_numa.c
> +++ b/drivers/of/of_numa.c
> @@ -59,8 +59,11 @@ static int __init of_numa_parse_memory_nodes(void)
>   			r = -EINVAL;
>   		}
>   
> -		for (i = 0; !r && !of_address_to_resource(np, i, &rsrc); i++)
> +		for (i = 0; !r && !of_address_to_resource(np, i, &rsrc); i++) {
>   			r = numa_add_memblk(nid, rsrc.start, rsrc.end + 1);
> +			if (!r)
> +				node_set(nid, numa_nodes_parsed);
> +		}
>   
>   		if (!i || r) {
>   			of_node_put(np);


