Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F6DCCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 16:43:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9028680181; Tue, 28 Oct 2025 12:43:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B2F58013F; Tue, 28 Oct 2025 12:43:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A18C80181; Tue, 28 Oct 2025 12:43:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65BA08013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:43:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1FE091A037C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:43:49 +0000 (UTC)
X-FDA: 84048094578.14.17FAC76
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2C45CC0006
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:43:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C9XyJNAQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761669827; a=rsa-sha256;
	cv=none;
	b=hAxo7GELtyrmgMufUX6Z+/z0bxR/DeSq8RtTbYFMX/AO/88u4GCDIPUkronrhyAUjKiGwq
	lsgRWACRcnsnKis/TQDXeUkcxRqSiXj3TgD+KfsSyFw/kuzRMY87zfw+pNHWzrpHSIpA3B
	XSVod2ve8MW1C4Gm+oO29ATQl7Vl16M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C9XyJNAQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761669827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kSNkRhOJhrPtd4Js2oBI0wr+MEc/sKamTAOCSggnfZY=;
	b=y9BEqK5615+FGX8eacjuxaWrI2UE+0q/eUdueJ+66McUJupI2c/cyBTIBtF0Q3d7OG2hbE
	+hsLd1C8lMGTCodv6az9kfmtRm0DrU+CdrCFkwSzmYqAeO+IQ6DhQV+6yrTibu6mQ9JYgr
	0S2XO6XApsqvCU7TVSKNOOCkPVznDt4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761669824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kSNkRhOJhrPtd4Js2oBI0wr+MEc/sKamTAOCSggnfZY=;
	b=C9XyJNAQbLdaKmF6tYaMQJgBraElANn8UZADDHK2VL+pgdD76IApnxrZRyQYAaT6rFTarg
	tYoLJbg0VWb22xMZArp0wH2Ft+STPLO0i2hYX2TtGMWEJM/N10vBHM5tQfD5nGj0ItMa51
	otG8PaOIqzlX0JNrVvhEtQ7NWlSELLQ=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bot+bpf-ci@kernel.org
Cc: akpm@linux-foundation.org,  linux-kernel@vger.kernel.org,
 ast@kernel.org, surenb@google.com, mhocko@kernel.org,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, andrii@kernel.org,
 inwardvessel@gmail.com, linux-mm@kvack.org, cgroups@vger.kernel.org,
 bpf@vger.kernel.org, martin.lau@kernel.org, song@kernel.org,
 memxor@gmail.com, tj@kernel.org, daniel@iogearbox.net, eddyz87@gmail.com,
 yonghong.song@linux.dev, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH v2 13/23] mm: introduce bpf_out_of_memory() BPF kfunc
In-Reply-To: <2b04ce21d82f2118c291c49ace22d685bcbbd45d203b2f676556d3e5a90eebd1@mail.kernel.org>
	(bot's message of "Mon, 27 Oct 2025 23:57:21 +0000 (UTC)")
References: <20251027232206.473085-3-roman.gushchin@linux.dev>
	<2b04ce21d82f2118c291c49ace22d685bcbbd45d203b2f676556d3e5a90eebd1@mail.kernel.org>
Date: Tue, 28 Oct 2025 09:43:36 -0700
Message-ID: <87cy673rk7.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2C45CC0006
X-Stat-Signature: 9ifkk5wjhs4cm8eba8ykwepgpm4d1xep
X-HE-Tag: 1761669826-340304
X-HE-Meta: U2FsdGVkX1931OewFnee0X+XVYhK1AdK3yzFPMQJxik8S35oPI1f+bxv98QZc3qiq7eB0fWPEaMUdv6FZ7TqfizfN0HyTmDajHZ9++TvzhrNeBZ23U4p5Am92KYcQjiSzrKOK5+kp+Q16O/Vrd5lbgezPs9D09T9LRp2yD2QZ5EarC03Emy4Hkasm1h17e2o/iGQU+6MMhTLuy9hBFoQFvSPE+dDwXi2COznVCeencm7uku5VorPuZ71OOJAQTRTBdGpRTZ2PO+nDVU2cl0ooXYiQF5GdO6/S9ebN2f8PWSkLtOawOUM+AjU+ubuXV9Eu2hOQeBi+4hPvg4/GovRzLUHNqup/lcv00+Sd49r00FZUg+Q4h6rKxD2jZwyRCpq4NVj/JJlnYSmiDbdFdvchsB8v9pwvOeJD3VKRwZvlWEYOwjeHUDeadNg/6WW18YgOc4BqEf8I4p2vye7hk6WrKX44cQBeDLqchQ1CFMSzJ0G7YOg74LSoFUl22xPiUv4iebRuH/iAytBN9+/kHaUdIzlw8o6In3K1Qq8dKlDzvL75g/Aqw4mgJM622riJ/BoK0dzOiGkZsbNE0mee9Z1+qPApDp+ST9KM12D2nuOK99ARJOT+zkrp5MNRfrNuXmgiWa3kB9IMZu67nCebopkocI+LMhCYqgVgBJhT0dtMg5a4CsmmAbbpaHkIbFhFbyxhWjPS1A/OpAxAk/tpWH5kv69uI85DNn+nkbI5/LphosaH/zWLFL/uYr3HDoI2AFrq7QSPDRs4EI8724Bg6ebzoVfmy+fAl/YhAKdggOCPsgvPRFAfO46VXP4Uv76D6iGfnZzR+3zOxQ6PTNgdmlEhwUQ219kIHr2hQBJoB/XlS3jEx9nvtD/bReOqAvwnXpAHsMtQsC2gHov3oMmPKhPAXN6qZ7juMejMxlkVfutF0oiZFb3cxOLz8lNkob/bGffV6FEQg6quKp2I7zqb4C
 43/VB6md
 QW235HYrO7INFO1O3bTrUD6ufE06zzqy3d26EywT446YhNFqWV0wsrUQDzmdbrHq3zRJcN4CbEXqyBWG3fGwt10W+EJpPPJs46L4EVGKQcgzbrgqyhDBa4UBbYoNZOpqslq42lR2sXwDWKaCY9OVzDBtrKN5/uv1Tnd6Tuiy89VrOk06M/1BnmTbXMBZLbHA8TeqXhUrmKuwSlHlHyMQ4zi2RQbatR2OH9iv70i9wJcgHbeaz/RENtWYOGj3UPYV8J0JdIoAc7yl45HMAdjHvyBdzvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bot+bpf-ci@kernel.org writes:

> ```
> commit bce57b9b96e05731a14c7e10a364fdd9b733cda2
> Author: Roman Gushchin <roman.gushchin@linux.dev>
>
> mm: introduce bpf_out_of_memory() BPF kfunc
>
> This patch introduces bpf_out_of_memory() BPF kfunc to allow BPF programs
> to declare OOM events and trigger the kernel OOM handling mechanism. The
> function accepts a nullable memcg pointer for system-wide or memcg-scoped
> OOMs.
>
>> diff --git a/include/linux/oom.h b/include/linux/oom.h
>> index 721087952..3cbdcd013 100644
>> --- a/include/linux/oom.h
>> +++ b/include/linux/oom.h
>> @@ -21,6 +21,11 @@ enum oom_constraint {
>>  	CONSTRAINT_MEMCG,
>>  };
>>
>> +enum bpf_oom_flags {
>> +	BPF_OOM_FLAGS_WAIT_ON_OOM_LOCK = 1 << 0,
>> +	BPF_OOM_FLAGS_LAST = 1 << 1,
>> +};
>> +
>>  /*
>>   * Details of the page allocation that triggered the oom killer that are used to
>>   * determine what should be killed.
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index 3c86cd755..d7fca4bf5 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>
> [ ... ]
>
>> +/**
>> + * bpf_out_of_memory - declare Out Of Memory state and invoke OOM killer
>> + * @memcg__nullable: memcg or NULL for system-wide OOMs
>> + * @order: order of page which wasn't allocated
>> + * @flags: flags
>> + * @constraint_text__nullable: custom constraint description for the OOM report
>> + *
>> + * Declares the Out Of Memory state and invokes the OOM killer.
>> + *
>> + * OOM handlers are synchronized using the oom_lock mutex. If wait_on_oom_lock
>> + * is true, the function will wait on it. Otherwise it bails out with -EBUSY
>> + * if oom_lock is contended.
>> + *
>> + * Generally it's advised to pass wait_on_oom_lock=false for global OOMs
>> + * and wait_on_oom_lock=true for memcg-scoped OOMs.
>> + *
>> + * Returns 1 if the forward progress was achieved and some memory was freed.
>> + * Returns a negative value if an error occurred.
>> + */
>> +__bpf_kfunc int bpf_out_of_memory(struct mem_cgroup *memcg__nullable,
>> +				  int order, u64 flags)
>> +{
>> +	struct oom_control oc = {
>> +		.memcg = memcg__nullable,
>> +		.order = order,
>> +	};
>
> Can bpf_out_of_memory() work correctly for system-wide OOMs with
> uninitialized gfp_mask?
>
> Looking at out_of_memory():
>
>     if (!(oc->gfp_mask & __GFP_FS) && !is_memcg_oom(oc))
>         return true;
>
> With gfp_mask=0 and memcg=NULL (system-wide OOM), this evaluates to:
> !(0 & __GFP_FS) && !false = true, causing an early return without
> invoking the OOM killer. The comment in out_of_memory() explains this
> check is about allocation context: "The OOM killer does not compensate
> for IO-less reclaim."
>
> All other callers of out_of_memory() initialize gfp_mask:
> - mm/page_alloc.c: .gfp_mask = gfp_mask
> - mm/memcontrol.c: .gfp_mask = gfp_mask
>
> For memcg OOMs, the code works because is_memcg_oom(oc) is true,
> bypassing the check. But for system-wide OOMs (NULL memcg), won't this
> cause the function to return immediately without killing any process?

This is a good catch! It must be .gfp_mask = GFP_KERNEL.

Fixed.

Thanks!

