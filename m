Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E654BFB5188
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 02:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C8CE6B008A; Mon,  6 Apr 2026 22:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59FBA6B008C; Mon,  6 Apr 2026 22:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B5D46B0092; Mon,  6 Apr 2026 22:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E96E6B008A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 22:57:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BB9488C055
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:57:45 +0000 (UTC)
X-FDA: 84630249690.09.C00EAA4
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf16.hostedemail.com (Postfix) with ESMTP id 05BC5180005
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:57:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JJEk76RO;
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775530663; a=rsa-sha256;
	cv=none;
	b=rFd4t9bc8rpOuQeVbhktphONwyaxSmMGOrhR/0jnUqYj/58BdMg7unsf2OV25vZiGIt947
	5lkEQ/KNt317nAjnu8ETy0aODI1u9BoUusEunwoUxkrUcYxfiYuisx/bWl5TtSkwC1QO/R
	+onirznyteces1lV1OxYa1TEL5PR9Ek=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775530663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETgww+HwxHhmO9mtPFnDQxT1EU42o/a0milwkwWeNSg=;
	b=3+uG8PERqHhxzyWX0QK/3XzQUeuEOWm7AZDv/Lo30Eh6eXeNgcwQQbmHbFeD4bJOVKAExs
	uzP139y5sVgB8J3xdkhGSUj0jyA6tQ0tFxZu1244nThxpHqEYFDYA/PN1Hz+gnNHyNMF24
	6IUKNehZklt+Te87nGd4OLHLQcps24A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JJEk76RO;
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ETgww+HwxHhmO9mtPFnDQxT1EU42o/a0milwkwWeNSg=;
	b=JJEk76ROATZJcg+uB4TytQD5rt+o3NIKXmfoiiOyV4i7Ss3LYwRSYNSeP1xYcT7+ck2jzGq1j
	1fL3gTZYY7h1/9QLTuXeYaM6S06MWVCjPRRgNlCYEbxohec4zZZvQhQds9tJIhuwKvuQYWGsJSd
	EuyEd/6cb1TyCiJVFy2dLoQ=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4fqW184C0gzRhQv;
	Tue,  7 Apr 2026 10:51:24 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id E04222025F;
	Tue,  7 Apr 2026 10:57:37 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 7 Apr 2026 10:57:37 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 7 Apr 2026 10:57:36 +0800
Subject: Re: [PATCH v2 2/3] mm/memory-failure: add
 panic_on_unrecoverable_memory_failure sysctl
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <kernel-team@meta.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260331-ecc_panic-v2-0-9e40d0f64f7a@debian.org>
 <20260331-ecc_panic-v2-2-9e40d0f64f7a@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <59c133a7-74a7-4678-d907-add764bbd107@huawei.com>
Date: Tue, 7 Apr 2026 10:57:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260331-ecc_panic-v2-2-9e40d0f64f7a@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 05BC5180005
X-Stat-Signature: 1rpdhmnpodeundcshpuae8ubq6tg9j9s
X-HE-Tag: 1775530662-408858
X-HE-Meta: U2FsdGVkX1+KKLMWCkwyJ0ZY++I7J3sMFrwEEIPKQ/KBc1h//ikZhASjFKRXjrQ+7Dx2gQTqfhlkOna5pGp2zkKNH/OdESN0yzkMiIxZvNi+MSs/DnbIIb2QIqNI6j8S4rXWU/LQ6JLfSxJsJVjo8a+OTjuWH2CAhz7kPaaAhRrcTcg8vDHwRl92mn/t0sE2Oz4wjh+B3TpeexJEVry8FIrcKnmFNCeWsV8tyDfbZKAK+FidZEydKTIN7KihC00EWJFUgrNJXD6bB6k+hi3BiGkHryUooCqpJJDmZowmbcYlrcHX55be0SIV/SgbPpXtvBr5hJWfSbOtWStqgDggyOEXglJIlF6nn0QX9OODehdNDeXf893tntqmlY3ksVafGuxrDuz6ULc0H/0/XvgX/E2WgxR3yxSZh17AQSl/aI4aR1R64SMvks2c97BRdlQaKoj9j1kk5dlnf3AoLXkYno5RW71846j76LXorR4zZdcQa5MVnatWtREEkFqaKphXF6MK20xGxMT5CTx/P1h5Wy8eTQsnpbmOJ1SkW+OMtogz1Tueq2AMHt0ll05diSP+WFy8GnONCpptoh13tl2yIYz9YPBBY3EERFuYfDBLRQxfv77oXxTzb1T1YSNQu30reLmR88mtuqDfQvgcHaL3+OvHz6Gw6bfWCnuH8pnNsza+iAwDPOaJyvqkcMZp/vNBK75KuWIZzSPseVSFLnqg/ZDQMfTETyqGUGwPS5tycDwWiZ47JvFWfmyTfXvNYQEsnKnOCIusnzNbzuvkPEBucZ9IUzmW2VNtLKhN93nmkph2veimgJXJwNb8QKqKlF/C+tgRgi69E7AJtJ7PZh7LLMe/Dk6RDe6+LLIl6e3MkKr5lUut/67cySKjRR4nfEbeN1rZX1+Rgdn7U/Xdir2ov+OV+BsqNe80Wc3J5YhuHoN299PCM+PQdmpU7Emlqc3zRxhhdSVV9l/1fgTxUBl
 vJqzPzug
 2ymbrBqQR9kIrDH3ug2jh6kVQY5Wbnrjwg563IzHBKK6KI+/AKxDCWJPxZW9GYqGb31fqYEo7GXdKvK6PVGvv3Hmlcz9Nv53KoGhUx6OQBZy4hdDVUNdD6O7qQzH07VEES2jEKHCcZ3XBU9yYWg87Ql8wsbeskt/r0MDPInfhvoSpyRjQM58SHNk1E7DwvrP7eoTdO02Mz05ZjpIt5ayoSX8xvo81I9/mUc6Vh/xXSCnoouKYe8Z/6elosK+u9MDWrTycJ3skJ35lkhMirww262MWHggOoESiZv+0KtXrEWmjnlYyuZjIunZVJNs8fPnmBdgnj/s7FJEiyEm8RVH6/DAJVpi9Dx4Ir7WiOlXnvW15wBTAwSWY6IQeChU07L66AzmbmJgsT2/uTcIg0a5SQDhVFTDQWPlmMPGT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/3/31 19:00, Breno Leitao wrote:
> Add a sysctl that allows the system to panic when an unrecoverable
> memory failure is detected. This covers kernel pages, high-order
> kernel pages, and unknown page types that cannot be recovered.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/memory-failure.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 6ff80e01b91a..d0d911c54ff1 100644
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
> @@ -1298,6 +1309,11 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
>  	pr_err("%#lx: recovery action for %s: %s\n",
>  		pfn, action_page_types[type], action_name[result]);
>  
> +	if (sysctl_panic_on_unrecoverable_mf && result == MF_IGNORED &&
> +	    (type == MF_MSG_KERNEL || type == MF_MSG_KERNEL_HIGH_ORDER ||
> +	     type == MF_MSG_UNKNOWN))
> +		panic("Memory failure: %#lx: unrecoverable page", pfn);

Will it be better to add a helper here?

Thanks.
.

