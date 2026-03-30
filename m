Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ADC3FF4956
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 07:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581126B0092; Mon, 30 Mar 2026 03:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531EE6B0095; Mon, 30 Mar 2026 03:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447E06B0096; Mon, 30 Mar 2026 03:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4C16B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:55:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7BA41B897A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:55:12 +0000 (UTC)
X-FDA: 84601968864.06.89426B9
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9EF951C0006
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:55:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=kdRyhgPo;
	spf=pass (imf18.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774857310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gxL/nLHtk8yzJElgrCWa2G5swCzIh9KhW/8g+WYobqw=;
	b=jr4IKPm7tebO5wpO+AN4sw1sXDF0+yPIeFBrgnL3taaQmEIaeLuOexK7xGB+zzYWT2U8GS
	E2ktUprB4wmMUUh9J0pK6GX0bmv5/XvYlbIlK+kd5/M2ICzm3uuL2dA2uS+V/om7kYDl37
	6miLQKuTet0o9cnaFLiFiLXbOmWAo5Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=kdRyhgPo;
	spf=pass (imf18.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774857310; a=rsa-sha256;
	cv=none;
	b=O75F9ySFksXS/WJnEXqgzLmw1Ys0b3CnoAqHstb15iAN3SuXWwjconRFKOetUY3XvxAN+g
	AQlWUHSVxovLejoDGE3XMF5qklFTqWEsoKKaFJua41FXXzJuDHaWKsjMBpmz0KwT9ffTLE
	7xpcR2uP36tk0SmpeZy/FalJlfS9fIs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=gxL/nLHtk8yzJElgrCWa2G5swCzIh9KhW/8g+WYobqw=;
	b=kdRyhgPoF6ynd8J8zQDabTun7D67+34eRkJ+/9iQPVyI8ywedL6hVtwVCtLr2aJawq8obtW0M
	fDXTp5Rn5dZSgRVNcskaQDvbTVawHpsxDvrQs271E4xMZiR5R3hQYnqv74YWERC1dGFxW6JJJaR
	yw7yOw1NLjkcMAarT8N7KUg=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fkk0x160sznTW1;
	Mon, 30 Mar 2026 15:49:37 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 00A104048B;
	Mon, 30 Mar 2026 15:55:02 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 15:55:01 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 15:55:01 +0800
Subject: Re: [PATCH 1/2] mm/memory-failure: add
 panic_on_unrecoverable_memory_failure sysctl
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <kernel-team@meta.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260323-ecc_panic-v1-0-72a1921726c5@debian.org>
 <20260323-ecc_panic-v1-1-72a1921726c5@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <a88d62ee-530c-1a6e-c05f-de324f940b8f@huawei.com>
Date: Mon, 30 Mar 2026 15:55:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260323-ecc_panic-v1-1-72a1921726c5@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9EF951C0006
X-Stat-Signature: ypajet7ytyuk35ojrywi65iui6s68hk7
X-Rspam-User: 
X-HE-Tag: 1774857307-868977
X-HE-Meta: U2FsdGVkX1+k/xL1ljqeD5NeHcbkZAOuFnMPjTkqFycQw4NMAYsaf0rjs5o+CqsaXJkILmqGuZBJpJo4IzBQIDiwo7GZBlDBzqePOxOCS4S+Z8G9M4lozNd/qunOWBkdvLPGmT37dbFYWan5MQUZfvEE180/UhmQWNXVcWh5hxL6kAIL0tsHx9dNilIpGCoXIiPoLGI11uOwSEauF6NlqdGi4Ek4AGAdWmncX64e/WaLuIXg3+lzKkZGFHai4nJGFiUfmE9lpn6r3ghFLiug02JoOeIPj9JEa6yxcr30QPdo8CZ+RI5+RFPhs1IYmxD6c5DQ104GqC7nAyvJZB0bvTufaAWtl/d/AeMi84Ie1ITD6+RXqz+uOAZNncwia/CLgalP1qqnEQr1qAqgBVJpwUL7nD09xK7I2zlwhICxNHoNtx6cB/rZVloVHsP86dV00QRAhIoCBPHLiHE2iDfmJcvHA2faPZuu6b4XVDOzuA25ipFP3mgP6DQ6qfxMYGtev7ACk2jNrbJaEMb6wc2i/aG7qUEqkuw+fSnTaXLjTHOuPEgdqnD91MvQFk2OIIX9tKMX17y+v9Oc8Ny4KUHITM6ozAVcAD2r2nXzmRw9GfVr8d6ViDNgzvV9QnGHJuEU2wyLN0e9NIADzoabdK10Wwz0ahNrDR/2uHBXKvMo6+6s7PcMnfapGdQtxvYVLNaQlmNC8NFsMGChm3apk+e6h5QvFpgAsdD7gn/OR7jNAfSwWP+8sJ2Oohj4L7sDsXAhEc2pc7ZBFgwboA0Wui3TzSyarZVPfoF03i1zWwnb+4uwCkVPJuS5acOHkrs3P02smQxZFj6xFxaRGNZRYSwKoOEvdnVKh8be04NRAYoQQROapTuGh/YYY9+FzvctNhJZwVqX1LCxSXGnMaXhGw5mZxtQt4LO0Zdt5N0+wmyZgSJ5eAtf35u+hNSSDgrQ+JilPe1pcxAY3Z3hgrkkF63
 rPr78cyo
 yT7/svMnTex4/hwODxQmYJazIxE+k9wemmV2MGcJih+sWj/dxIrgq9DAaSGELLtxwlN7tGeINfXn5ltuZwvoGMgNuknuSLQ8cjlTP0wK33xQcTT779qbqZ0kO1fiMAIiL2x9ATJDM/ofGpjyZ0Px0T2TcAA3Q3spe4yv6APFDF0jE/AQiXjhP6k+SukYad7zrUFkYKufYymyIkCT7bS7Ipd272hTRD31bT+uA6qJuEktirbWkiCTAgtGgguRCFJvwrP1UaHxEWFriSET5UI3Hg559wj10Z8po4oJFToZAc4QAACQPK3RQYjp/rJ/e99PxfJ7f1kl5XXnUcDzvJXkJBhB8qN97K6PikpunuTDjmaSWELIK1/fUADs6Zfx/rXw5f1uJpeOi3S4QnjX9gWRI/Nm0XeIwt6krKHGm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/3/23 23:29, Breno Leitao wrote:
> When memory_failure() encounters an in-use kernel page that cannot be
> recovered (slab, page tables, kernel stacks, reserved, vmalloc, etc.),
> it currently logs MF_IGNORED and continues. This leaves corrupted data
> accessible to the kernel, risking silent data corruption or a delayed
> crash when the poisoned cache line is next accessed.
> 
> For example, a multi-bit ECC error on a dentry cache slab page was
> ignored by memory_failure(), and 67 seconds later d_lookup() accessed
> the poisoned cache line, causing a synchronous external abort:
> 
>   [88690.479680] [Hardware Error]: error_type: 3, multi-bit ECC
>   [88690.498473] Memory failure: 0x40272d: unhandlable page.
>   [88690.498619] Memory failure: 0x40272d: recovery action for
>                  get hwpoison page: Ignored
>   ...
>   [88757.847126] Internal error: synchronous external abort:
>                  0000000096000410 [#1] SMP
>   [88758.061075] pc : d_lookup+0x5c/0x220
> 
> Add a new sysctl vm.panic_on_unrecoverable_memory_failure (default 0)
> that, when set to 1, panics immediately on unrecoverable memory
> failures. This provides a clean crash dump at the time of the error
> rather than a delayed crash with potential silent corruption in between.
> 
> The panic is placed in action_result() so that all call sites that log
> MF_MSG_GET_HWPOISON with MF_IGNORED are covered, including the hugetlb
> path in try_memory_failure_hugetlb().
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/memory-failure.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index ee42d43613097..25bd043497195 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -74,6 +74,8 @@ static int sysctl_memory_failure_recovery __read_mostly = 1;
>  
>  static int sysctl_enable_soft_offline __read_mostly = 1;
>  
> +static int sysctl_panic_on_unrecoverable_mf __read_mostly;
> +
>  atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
>  
>  static bool hw_memory_failure __read_mostly = false;
> @@ -155,6 +157,15 @@ static const struct ctl_table memory_failure_table[] = {
>  		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= SYSCTL_ZERO,
>  		.extra2		= SYSCTL_ONE,
> +	},
> +	{
> +		.procname	= "panic_on_unrecoverable_memory_failure",
> +		.data		= &sysctl_panic_on_unrecoverable_mf,
> +		.maxlen		= sizeof(sysctl_panic_on_unrecoverable_mf),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= SYSCTL_ZERO,
> +		.extra2		= SYSCTL_ONE,
>  	}
>  };
>  
> @@ -1298,6 +1309,10 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
>  	pr_err("%#lx: recovery action for %s: %s\n",
>  		pfn, action_page_types[type], action_name[result]);
>  
> +	if (sysctl_panic_on_unrecoverable_mf &&
> +	    type == MF_MSG_GET_HWPOISON && result == MF_IGNORED)
> +		panic("Memory failure: %#lx: unrecoverable page", pfn);

MF_MSG_GET_HWPOISON contains some other scenarios. For example, an isolated folio will
make get_hwpoison_page return -EIO so we will see MF_MSG_GET_HWPOISON and MF_IGNORED in
action_result. But that's recoverable if folio is used by userspace thus panic will be
unacceptable.
Will it better to check type against MF_MSG_KERNEL_HIGH_ORDER?

Thanks.
.

