Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42331CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 16:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 647D180173; Tue, 28 Oct 2025 12:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61FC48013F; Tue, 28 Oct 2025 12:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C8980173; Tue, 28 Oct 2025 12:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 473108013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:11:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 12B2712AB77
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:11:02 +0000 (UTC)
X-FDA: 84048011964.15.034579E
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id 59909180002
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:11:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SyxgsjzA;
	spf=pass (imf06.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761667860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4PZj+Z/AUd5TD2H5mliXY1n/lg/WeR66f3O6rTVgL0=;
	b=6wj34v88tqP+79YQTPSss7zQ9GaDFt/xvmalpRQfABSAl+3g07w8WlFE1V14DWuGbD/uSf
	Mq05MlAW/GKqKZHwJXzlPHMY5QYuLwgOsstA4icf/ed29wNNaEOQ8heOzPKXcRhXFnKe9Z
	H3cQcfaLza/IyXdmircMOuOPIiI0D0E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SyxgsjzA;
	spf=pass (imf06.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761667860; a=rsa-sha256;
	cv=none;
	b=mJetJcBUujQT6DUKwXAeqzX9DI6+9kzYxI3wQZMS3seYu2Cps9uRYmSHSaPx586kO29JA5
	Ac28v29+OnVSMhYDfSJrxlxHf7TjqlkJ5iIbSz5CH3xulz/a99V/QZ0B30DsrKCDJbiGaf
	oPilYyDWNDIR3hvwCu1j8CShrkdk8vA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761667858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D4PZj+Z/AUd5TD2H5mliXY1n/lg/WeR66f3O6rTVgL0=;
	b=SyxgsjzAaP3eQ9upztzSYWfJ4WsFRqyGC+WNAlDIHsVjNFkuLy+80+fxZhJbxoF71KM/Sb
	2dXtGFR0Z9YliT37NCbk2o9jgMkSzntlWrQPUd9ujQ4NC2Ewk5O6GCMZUgB8sGf6/K33Ov
	Tv8wxDHZwyaHL5z9MiCmBhWGX4QJh9c=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bot+bpf-ci@kernel.org
Cc: akpm@linux-foundation.org,  linux-kernel@vger.kernel.org,
 ast@kernel.org, surenb@google.com, mhocko@kernel.org,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, andrii@kernel.org,
 inwardvessel@gmail.com, linux-mm@kvack.org, cgroups@vger.kernel.org,
 bpf@vger.kernel.org, martin.lau@kernel.org, song@kernel.org,
 memxor@gmail.com, tj@kernel.org, daniel@iogearbox.net, eddyz87@gmail.com,
 yonghong.song@linux.dev, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH v2 08/23] mm: introduce BPF kfuncs to deal with memcg
 pointers
In-Reply-To: <2c91977fcab04be6305bf4be57e825f7e84005d16667adcdfad0585be506537c@mail.kernel.org>
	(bot's message of "Mon, 27 Oct 2025 23:48:21 +0000 (UTC)")
References: <20251027231727.472628-9-roman.gushchin@linux.dev>
	<2c91977fcab04be6305bf4be57e825f7e84005d16667adcdfad0585be506537c@mail.kernel.org>
Date: Tue, 28 Oct 2025 09:10:47 -0700
Message-ID: <87ldkv57nc.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 59909180002
X-Stat-Signature: ju9mermpid6b5ai5d7pnq8j49nnomenj
X-Rspam-User: 
X-HE-Tag: 1761667860-804939
X-HE-Meta: U2FsdGVkX18g/YZtDOYCqjJx6AWmJBO31YicRhTAnjtQEGfrWO5No8qj3Ea74yxukfHifBLTv77vwsPXKmKPvrnEC5868th4L6AlGkBfltqjKMrlyQ0xvbayiYap8aywl8knijCbX3zm4fp6KWiS2olANif2yJrqna1dPeVBwHCw0UlwzeptJFVyI48Ibf40CGrKmtrWKnFRN6zDw+dHt4l7dvs/86/zK1JTeSYnhJWh51NaNjKilIH6is/4KqrIo4dn4FVPX/399eCw1rpPSKAaebammru7MIikppXgR5sSsFt+5cvKclySBv/LZRPE3qsCu99w4SdajNQitbGf51eU6GDFcs48tfU/xhqEK2rBweh0JEg44z07ra9l/pjhgpKXPD4RzqswIKymlCD1zB7jKMb5lllIN1BtE+FwHy/cVa87TrnFgUFooEHEy40xA/zm8cQx77rTzWwNE8ITUXef/0wzRBaHGsacKsjcBnOu/LVufv0oFKx/cehdqbMy3RZ3416UE9Tf8bCgvuT+ezZI3COVWkyvYokqCeH6xS3RMjHmHNQaOTEIKmo8lARXGYGj3T7P03DLWLqL5Y+59Cvf7WLoHXqXLAnDOs28lwTYWWHbOQx7QczvJrac6gsEYd2j/y6E+n/bgwekLh3LrH3oQ8U2hm3u5XltcfiVMKrWPudM7EqiQtlH5VE4QYEP5bK4DWGKdaawCbVXT5NAnZdP5Cze1GV20SIN+jHVFFeiHhw6qlURIRwyHlT/nNw4o9TtDWXPNU2l8tJBtVQ85YmZz6mcjDTrJ69iFrBUw9w1d8GzuFxRq5H7iAKa46t+4Yra1uXD0DBYH+5vBs2wzBnii/0A26L6bNUBfkSMWrSY5nXgqhICAHTrM9Gfj5HFz8OwPWkBwkDQVIlOKpsrIzpnaHo/RMm7V6xPGsojCBwoGLCDeP6PcXXbWP5Ju99a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bot+bpf-ci@kernel.org writes:

> ```
> commit ec8e2e1769704b4f69261f36e6aaf035d47c5f0f
> Author: Roman Gushchin <roman.gushchin@linux.dev>
>
> mm: introduce BPF kfuncs to deal with memcg pointers
>
> This commit introduces two new BPF kfuncs for converting css pointers
> to memcg pointers with proper reference counting: bpf_get_mem_cgroup()
> and bpf_put_mem_cgroup().
>
>> diff --git a/mm/Makefile b/mm/Makefile
>> index 051e88c69..2d8f9beb3 100644
>> --- a/mm/Makefile
>> +++ b/mm/Makefile
>> @@ -107,6 +107,7 @@ obj-$(CONFIG_MEMCG) += swap_cgroup.o
>>  endif
>>  ifdef CONFIG_BPF_SYSCALL
>>  obj-y += bpf_oom.o
>> +obj-$(CONFIG_MEMCG) += bpf_memcontrol.o
>>  endif
>>  obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
>>  obj-$(CONFIG_GUP_TEST) += gup_test.o
>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>> new file mode 100644
>> index 000000000..1e4609774
>> --- /dev/null
>> +++ b/mm/bpf_memcontrol.c
>> @@ -0,0 +1,88 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +/*
>> + * Memory Controller-related BPF kfuncs and auxiliary code
>> + *
>> + * Author: Roman Gushchin <roman.gushchin@linux.dev>
>> + */
>> +
>> +#include <linux/memcontrol.h>
>> +#include <linux/bpf.h>
>> +
>> +__bpf_kfunc_start_defs();
>> +
>> +/**
>> + * bpf_get_mem_cgroup - Get a reference to a memory cgroup
>> + * @css: pointer to the css structure
>> + *
>> + * Returns a pointer to a mem_cgroup structure after bumping
>> + * the corresponding css's reference counter.
>> + *
>> + * It's fine to pass a css which belongs to any cgroup controller,
>> + * e.g. unified hierarchy's main css.
>> + *
>> + * Implements KF_ACQUIRE semantics.
>> + */
>> +__bpf_kfunc struct mem_cgroup *
>> +bpf_get_mem_cgroup(struct cgroup_subsys_state *css)
>> +{
>> +	struct mem_cgroup *memcg = NULL;
>> +	bool rcu_unlock = false;
>> +
>> +	if (!root_mem_cgroup)
>> +		return NULL;
>> +
>> +	if (root_mem_cgroup->css.ss != css->ss) {
>                                             ^^^^^^^
>
> Can this dereference a NULL css pointer?  The function checks css for
> NULL at line 42 with "if (css && css_tryget(css))", which suggests css
> can be NULL.  If a BPF program calls this function with a NULL css,
> wouldn't it crash here before reaching that check?

Here css passed as an argument to bpf_get_mem_cgroup() can't be NULL,
because the BPF verifier guarantees that it's a valid css pointer.

However the result of rcu_dereference_raw(cgroup->subsys[ssid]) can be
NULL, this is why the "if (css && css_tryget(css))" check is required
down below.

