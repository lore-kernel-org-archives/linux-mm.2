Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8364BCD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:05:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5C726B03F0; Tue,  2 Jun 2026 03:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33BB6B03F2; Tue,  2 Jun 2026 03:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49BC6B03FE; Tue,  2 Jun 2026 03:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A2DA46B03F0
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:05:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A8C1162BEA
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:05:44 +0000 (UTC)
X-FDA: 84834087408.03.A5EC7FB
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf03.hostedemail.com (Postfix) with ESMTP id 353122000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:05:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Bs1n6fFK;
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780383942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywNJBGpmmj9NFHoVdWRVSdCZGNodVCyyTVIIC+PjNKE=;
	b=UGRum0SHT81hubcLDjw0jAyRD5hlLJuLBEyDalG89wlJw1ojBUNPgwDJ/Qbv95q2TXMxMv
	jLcwVZEypA8u88cXksCu8Z0xEQXyqhMGmxlO1NyvqTryq3QWgk25oQcDJoBPyf2Bqq2Ve3
	OolixSV/beDQujrgpx63xXJPhnZ55aM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780383942;
	b=Gv4VY4BvbWB+5UZhsHQRw4N7U9tMYClj6ke71ffUYkY9Ylv3PoddZrqqcWXONec7UpIJA9
	CuIOsygcabk+qkXGkOMdND3fX+TxEURUbKRG7ejAoF64E+anUioLqSeijxkEw+kc/uOEXm
	EL7sWFbGOLxlNlsSCyppBVaBLtzzcnQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Bs1n6fFK;
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ywNJBGpmmj9NFHoVdWRVSdCZGNodVCyyTVIIC+PjNKE=;
	b=Bs1n6fFKha43sqYhA2tcjSKsQDx7BaUGA6NUMdju6QLI/zIcoj6MivYNkd4KB5UzwgTwlRGRz
	DBaCYzG3lmH9nMWSDaCaN/QE0DF2txBBIS+FXHu0AyqAciCTvM6wFX81QkZB7TvYIsS+e91oBXo
	OMxjbX/ncrB1e4iZFAn9le4=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4gV1q845Hhz1T4fx;
	Tue,  2 Jun 2026 14:57:24 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 1C5BA4056D;
	Tue,  2 Jun 2026 15:05:34 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Jun 2026 15:05:33 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Jun 2026 15:05:32 +0800
Subject: Re: [PATCH v8 4/6] mm/memory-failure: add panic option for
 unrecoverable pages
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <kernel-team@meta.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
 <20260527-ecc_panic-v8-4-9ea0cfa16bb0@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <4d7b720a-7975-8a4d-a00e-e888d63812a0@huawei.com>
Date: Tue, 2 Jun 2026 15:05:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260527-ecc_panic-v8-4-9ea0cfa16bb0@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 353122000A
X-Stat-Signature: y58mb6hsj81fiafkhzh5kwc1uan1uoud
X-HE-Tag: 1780383939-309533
X-HE-Meta: U2FsdGVkX19CYZQz15i+yN0CRC3l5X2EMkKssxBqZaTsZ9pc+dkGr5hssQLNOYS1pnyAtNvt+mfP95E+MvGThc9WcO7uhAnu1vQTcYi3FttFBe78x4nT53NPCdesimiyx9VvmTcvqhoUW73/+v2y6JV4rFUnDUIVrniKHqAJ2eJ50srwpDo2QSpT8ZSycg3eoN5uLKmP/qwnr3io/DNql5K+h4LM46Pfuvf6x7KasiweJOuErjpzVq1sToKPt5L+xzjD4AdgHmuTmDRx1m7Rkah05G4NJgblWb9Q0bTGH9NDttG1yVd6FK/8BUaapcf1qyxAwRpTJ9JLi59beY+eVBQZttVq12QnEPPu0zrWkxK0NFcyJ/8VOHVGZd2uyWRrT4v7dOUvNi2mDblOHvN/HMOnUDndSbThlJ6Kq6zNh15aZMJaY2f7pUMRan0mxZmzf00lCvL4d4gTnfWbnFavvUJ7sXoAISvAhUOIB6E43VqUA1OEqzjlnH6LNwZTnxLyT6pjq2/owzZNEs1h/DzbsNp4bHT6YS6D1lmia04ivokCZYtPJJTrhtWBTkmW13IkraklOVVtHlhYQUnSSj0g/4j3S7xp7vKTIOtJofwdjZtLsZT6QQVqt/2rqCeqlxEYFxcm4C8ZvxhkeTKwe/1kDvJmH2GONENVEljZtKbZ/HlM86RJO0QonDk+QUTJz0ImIGCIEkZuW7hqyV4N7s1BY17M1xU8NXfvdNup8q7o1EmuT6aaPcIgHzns3aTmlxOEBrjvAT1UIPc8OfLetfrNrHnYUtarFZrxRmN2Rmm5/1golUQyklRy3fOBQsoWwcJTa6GDOJKiRjzIDls6ilf4AfPizdVUeSx51/L5QjjbE7zxyj+cNM/t9yclCWdbtjntlrix2cNIHPOJo6qkFpFhBAReyiOfRiNqDSuLGiU0kWyaVazVqmGhQjZiRQapP0WCLDIhTAJsguFHikW8KmW
 LLqUxwkz
 fhy8GkR4tx/R3yCSb6MhXvbWjklNsGnfifeg3y4JCVggVugattFvj/74aFCU58vDV768T99G28ij187Ia/+KCVpX8dyRDSlWt17QxS5zBtPE73k0CAcvtXp9yr/mcAf1Tf60k8Tqja82T7vrkXDMMuD9p0vAJbAUdhee7/RYtlCfo9aht/3LLx7uZi1ZIHyFbK8zfv6Hvi+bfGcR9/jf3WwNXPviics4dwyBz1utwXtqpju2mw+ZTm6l0gVuVskHWdBEN3s8nZnavUgSmChNQxGuwprx3MImFfcrKTuoC7ty1EK6cui370ejcbwBaMNTPNR7KxnXgV8ki5VBrr8m1JkotC4F88IxZUOpCX8WPG/28fi7PSTaqnWPCFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/27 22:06, Breno Leitao wrote:
> Add a sysctl panic_on_unrecoverable_memory_failure (disabled by
> default) that triggers a kernel panic when memory_failure()
> encounters pages that cannot be recovered.  This provides a clean
> crash with useful debug information rather than allowing silent
> data corruption or a delayed crash at an unrelated code path.
> 
> Panic eligibility is intentionally narrow: only MF_MSG_KERNEL with
> result == MF_IGNORED panics.  After the previous patch, MF_MSG_KERNEL
> covers PG_reserved pages and the kernel-owned pages promoted from
> get_hwpoison_page() via -ENOTRECOVERABLE (slab, page tables,
> large-kmalloc).
> 
> All other action types are excluded:
> 
> - MF_MSG_GET_HWPOISON and MF_MSG_KERNEL_HIGH_ORDER can be reached by
>   transient refcount races with the page allocator (an in-flight buddy
>   allocation has refcount 0 and is no longer on the buddy free list,
>   briefly), and panicking on them would risk killing the box for what
>   is actually a recoverable userspace page.
> 
> - MF_MSG_UNKNOWN means identify_page_state() could not classify the
>   page; that is precisely the wrong basis for a panic decision.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/memory-failure.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 14c0a958638c..dcd53dbc6aec 100644
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
> @@ -1255,6 +1266,15 @@ static void update_per_node_mf_stats(unsigned long pfn,
>  	++mf_stats->total;
>  }
>  
> +static bool panic_on_unrecoverable_mf(enum mf_action_page_type type,
> +				      enum mf_result result)
> +{
> +	if (!sysctl_panic_on_unrecoverable_mf || result != MF_IGNORED)
> +		return false;
> +
> +	return type == MF_MSG_KERNEL;

Would it be more straightforward to write as something like:

if (!sysctl_panic_on_unrecoverable_mf)
	return false;

return (type == MF_MSG_KERNEL && result == MF_IGNORED);

Thanks.
.

