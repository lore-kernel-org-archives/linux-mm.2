Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0291BE9380E
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 03:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A2F26B0089; Sun, 12 Apr 2026 23:42:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453F46B008A; Sun, 12 Apr 2026 23:42:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36A126B0092; Sun, 12 Apr 2026 23:42:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 293256B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 23:42:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AAB54140C39
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:42:29 +0000 (UTC)
X-FDA: 84652135218.03.9CE62F0
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf28.hostedemail.com (Postfix) with ESMTP id D5EE3C0006
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:42:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=UBAiCWrY;
	spf=pass (imf28.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776051747; a=rsa-sha256;
	cv=none;
	b=7v4BIS+i8RVPZ2OWIvouk8EbJmNU2HoJ0QYcbMrG5v2EMJmyDQeej7UtwrDYzZfDS1JVyB
	23ycmUQA10NEt7Eh/ACv6DVSpbxhywhCw5k/+au9UF+i3WhJrlRTLKYmaFLdootcyLMEsZ
	2xqmV+R9ojlP66l4JTsUHBQMwqNA68A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776051747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VMBgE/Gsm0n04DIPKSxZD/WWr/ajg+HN9qmWHOd2nLM=;
	b=fNxWOPHJwwkDuaC1rD9MmsMjDwm6t0ltj2fx6YbD3W8uaHTKWKX9Pa9IKh7oyWOKbidv/X
	/RWZY3eL1kSa95vRek+7HdZidzR5X68HKMuAKq+1GdBWzf1LdLgAHKNof+/06JzYdoQl3r
	Zs9rL+PCGHMZOb2LQQZLHzXjRA0o3mg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=UBAiCWrY;
	spf=pass (imf28.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=VMBgE/Gsm0n04DIPKSxZD/WWr/ajg+HN9qmWHOd2nLM=;
	b=UBAiCWrYyWVLxflrm6gIeQAmeDDsz2uzinYSsE/+GLgGs818dvZT0Lldpd1SE/SsmosenhEbj
	4ZWfz0Bm9fdQTtyjbsQi18FPjFDNEJTE2Smu8uSDdbwbJExZI2KmC2IPx/ykS3ucY8qbIImKVbR
	EOL3oOYUY8SKJosN5lGRDQg=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4fvCkH2j1Bz1T4Gh;
	Mon, 13 Apr 2026 11:36:23 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id D9D0740574;
	Mon, 13 Apr 2026 11:42:20 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Apr 2026 11:42:20 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Apr 2026 11:42:19 +0800
Subject: Re: [PATCH v2 2/3] mm/memory-failure: add
 panic_on_unrecoverable_memory_failure sysctl
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <kernel-team@meta.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260331-ecc_panic-v2-0-9e40d0f64f7a@debian.org>
 <20260331-ecc_panic-v2-2-9e40d0f64f7a@debian.org>
 <59c133a7-74a7-4678-d907-add764bbd107@huawei.com>
 <adkFQF7QH8Jc3p3U@gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <15315535-3881-e2db-02d4-907235dd98b7@huawei.com>
Date: Mon, 13 Apr 2026 11:42:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <adkFQF7QH8Jc3p3U@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D5EE3C0006
X-Stat-Signature: mpgf8ub433kbywsg6oja1ejp9fmyt8g7
X-HE-Tag: 1776051745-160539
X-HE-Meta: U2FsdGVkX18yno9uPP0OL93PMoUN+xRQZeKsA0KeLv3XVYqVZZuQorVQtOvpDaFeIS8QUAIwZBOHWfMMoAwUjir+tyuSm4thnOZ4n3GKT0huxIwa4Hb0h2FiZhrEtWnhjpdK2698ICie1stoVVP3jbkI4mqOuD1317OmzvHdaplODlrYUSuKG7XktnWOR1aR+qabWjQe4a7H84I6cjgIrxjnf4ZzrB1SkPAT3Whs5QOB/YP+z7a6ZOd/f/t98v1klbHkOYlD1RFtXQMpdYJjDQuwPk1eBis23iYe3j74CSeJCOP1m4b1szjY0yrBEjKDu1Z43jB8gjP6znmy2AcvpBTD8OXsovjRUR7sfPCaiKk+sdgytTGNfxrsx5fhWKza9IjMMYZQth3Wwebq0vrxGAZp3dXUrYSZWio/uUVnkGE77VCFSFdtgH/RC909xj8XCdtNO5/GrHpVzyXDH3PIeQh3aS2a7dFMKsvEJN90RcB+bF7dQArUuRPG1eRjilQvrPYiY6/iFoLWcV2ktxjwL9LrCWiClCo+P2NBCX2YxNuRonu93+8ACro59jkBFOig/paNmGZqbjVBuOWzZho+IxxRQE0oGGQ/2mEMr/81ydW+BNyHOHumWOGecrbFdP2JsiCHInJn3akGsHu4X8vYbyUhnY63falZQdGVKiChRQErn6u8mKYUgGTu0tOy6+LhQqzXU9FTclxv6xMJTX973i4AFmESEpj2FbPfbXOXvXUECrEDd2StJSubFBPH27jDv4eCtHWjhVKWYWrA4KqKLY3Hese569HtT2vVZ4n3+7ROsCB2G1wqTz9tIEtuUIjEpvHIcxVfrJhoAqQCwUcUHVLtPwWXyZ48aukVZA8LsS3FOmgIddip41p61wTx4Q4FJUkna4HQEdCsq/PF3BvJY2EXiGxlovz30bPgmIFE2fHf/bTKvmUWlHHwlKM1k7EwJuuQmX0G+klweBgCU8G
 kW6H4a7b
 eKe1W9DPAlIdd1T4xafOhgqrgCFB1NEiZSq6xvgRfA60TqqqZGYynQ6QEkA0FSPN2yQT6U7DZzYV/fjBkNgNECuKRrXak0QNl5pIDv/q+VdUHIF77OPogbcqzBC0HF/gFysGhF0UtBAD8/GRq+Q5eMGfR2x7VbKDY+z2xrMg/HYLLnibkXMLoJ74Ld5FnRmSBC6URsKEPKpkTvCbvPSjIStxZP/oY+PC+Z572fGZQOVlOQkjknL1JdvnTQhbUeLROvgAMIyMZJL+OIh43Zcd6GSqbeZ1wwr4NupnpWoN1dfunFwLxvSySGN6xVRxwFFJLICQHECDRZgPF6fAwyhUn3fd3pTFysHCC6tQD6f00ZtE+gh9qURQr+DGrPiZkVMrtpJAkgvMIHMRmYEl1vrczdX7BC58h+xyf5P89
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/10 22:17, Breno Leitao wrote:
> On Tue, Apr 07, 2026 at 10:57:36AM +0800, Miaohe Lin wrote:
>> On 2026/3/31 19:00, Breno Leitao wrote:
>>> +	if (sysctl_panic_on_unrecoverable_mf && result == MF_IGNORED &&
>>> +	    (type == MF_MSG_KERNEL || type == MF_MSG_KERNEL_HIGH_ORDER ||
>>> +	     type == MF_MSG_UNKNOWN))
>>> +		panic("Memory failure: %#lx: unrecoverable page", pfn);
>>
>> Will it be better to add a helper here?
> 
> Yes, a helper would make things easier to read and digest. Thanks for
> the feedback. This is what I have in mind:
> 
> commit 36d5b3cbbe6d6abfe3296b7b21135a5f01e743eb
> Author: Breno Leitao <leitao@debian.org>
> Date:   Mon Mar 23 08:00:29 2026 -0700
> 
>     mm/memory-failure: add panic_on_unrecoverable_memory_failure sysctl
>     
>     Add a sysctl that allows the system to panic when an unrecoverable
>     memory failure is detected. This covers kernel pages, high-order
>     kernel pages, and unknown page types that cannot be recovered.
>     
>     Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 6ff80e01b91a4..a29b6688fe2d3 100644
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
> @@ -1281,6 +1292,16 @@ static void update_per_node_mf_stats(unsigned long pfn,
>  	++mf_stats->total;
>  }
>  
> +static bool is_unrecoverable_memory_failure(enum mf_action_page_type type,
> +					    enum mf_result result)

Thanks for your update.

> +{
> +	return sysctl_panic_on_unrecoverable_mf &&
> +	       result == MF_IGNORED &&
> +	       (type == MF_MSG_KERNEL ||
> +		type == MF_MSG_KERNEL_HIGH_ORDER ||
> +		type == MF_MSG_UNKNOWN);
> +}
> +
>  /*
>   * "Dirty/Clean" indication is not 100% accurate due to the possibility of
>   * setting PG_dirty outside page lock. See also comment above set_page_dirty().
> @@ -1298,6 +1319,9 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
>  	pr_err("%#lx: recovery action for %s: %s\n",
>  		pfn, action_page_types[type], action_name[result]);
>  
> +	if (is_unrecoverable_memory_failure(type, result))

Would it be better to name it as panic_on_unrecoverable_mf() or something like it?
This function determines whether panic on the specified memory error.

Thanks.
.


