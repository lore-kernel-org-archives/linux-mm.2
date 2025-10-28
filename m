Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28BEBCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 16:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8780880177; Tue, 28 Oct 2025 12:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 828528013F; Tue, 28 Oct 2025 12:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73D6780177; Tue, 28 Oct 2025 12:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0688013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:16:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 140AC160512
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:16:40 +0000 (UTC)
X-FDA: 84048026160.08.1DD177B
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf13.hostedemail.com (Postfix) with ESMTP id 56BEF20019
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:16:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mN8LxUn5;
	spf=pass (imf13.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761668198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ftyXtMKJiXGvCol0LZq8LgVSc8+XJJVccDr9V2Jw64=;
	b=vEr3GNFyPabqN7Cd7L5et0vxrt3aLClEDvsThett1QgGQyFqVfEBU4Tt1LyC0Awg4qvbci
	ZWo3rmoHT8bFEClcRcL1RETSzuUqq3QrU+CVTJ1R0+fjPqG+p0vUP4urwsgC8lw7CsvV+Y
	EnI2jXi/bkHKcQTbJag8QwpQ2q3glow=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761668198; a=rsa-sha256;
	cv=none;
	b=vtiCF1CnPBBSOmb19seZgcQvl6nDV/8hhHtER5DnrVIFnwuZLQaEQEk/6m+GLuETW4W/gR
	cKYtUERTN//8CVu/D1gjGuwdRDrx4bYp//bOIeIfP+hzUo6pt/qf+Os3hWbHSEZoc7jPqx
	9Mb851O8oPSEPeGXbiw6qOyXgQq5+hg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mN8LxUn5;
	spf=pass (imf13.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761668192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1ftyXtMKJiXGvCol0LZq8LgVSc8+XJJVccDr9V2Jw64=;
	b=mN8LxUn58/1ZZZ/JYFD69p+VTvbUvckaGk22+fnxe34+5t8PYP10haz/y/SISWoUsxA52i
	u2y1/eANPZbA7rvm3e3BNQsgR1RxKB6lu7ZYWnW4DAGhlmqfK0IzwereJpZoSEIvhmA+1m
	D30KR/rPZMO1xkVGtlPFPmVGFEUYDMw=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bot+bpf-ci@kernel.org
Cc: akpm@linux-foundation.org,  linux-kernel@vger.kernel.org,
 ast@kernel.org, surenb@google.com, mhocko@kernel.org,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, andrii@kernel.org,
 inwardvessel@gmail.com, linux-mm@kvack.org, cgroups@vger.kernel.org,
 bpf@vger.kernel.org, martin.lau@kernel.org, song@kernel.org,
 memxor@gmail.com, tj@kernel.org, daniel@iogearbox.net, eddyz87@gmail.com,
 yonghong.song@linux.dev, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH v2 10/23] mm: introduce BPF kfuncs to access memcg
 statistics and events
In-Reply-To: <45ee5e2e857a2e4022eb380f854d2a7cf27f3ec97d75a0200b46be95ae921d3b@mail.kernel.org>
	(bot's message of "Mon, 27 Oct 2025 23:48:14 +0000 (UTC)")
References: <20251027231727.472628-11-roman.gushchin@linux.dev>
	<45ee5e2e857a2e4022eb380f854d2a7cf27f3ec97d75a0200b46be95ae921d3b@mail.kernel.org>
Date: Tue, 28 Oct 2025 09:16:23 -0700
Message-ID: <87cy6757e0.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: fof4fyz4bo4qmtu6xhhco5fnc7g9f3e1
X-Rspam-User: 
X-Rspamd-Queue-Id: 56BEF20019
X-HE-Tag: 1761668198-60038
X-HE-Meta: U2FsdGVkX18kHqNCz7M0rTGr6l5Qeb1Vqeg6Zzvueve/HiPBBD8KfkL5VSg4o2jWsdkeMW5SMQrMjH/a694I3udj+waeEcoFf1XwQx/oRhUN86Xw6QllOJ34cWWlwz7FcpUuoyBMXod/S/I1DNjcU8AgzXj7tk0lD9G1va9k4YpruV1l3qWfw1errfU36OT9QguoK8APvGKfQrfmZTWogArz5PW0Bn+mvNTBYYU/OQXYiZ+eCEwdFSG7TaPpc6GkWE+bs+s3mi0hu6Ae0CC4czQVuR0nsj8mKd6EC/SaxIckKjVhtOzvuqNqOG8EAUI3C5oAov62Pq3cOn3auZ1z4LwG+vMgO7UF1WImC/Rri15zc0N9klnqkO5iVNxi3o4mjlfqAqr/UIdUrRqPPIl4f0/0NDd0fPliq/20cKpoQerwYIjBvLdHxKA6xb2mtNYpvIPJnY/Os5lLR3RTQR0WSEeSQJv3/CfK/ickidglbMLvpqUifVhYmdLrGuecWm+cAz4DTMGXf65a0PWWHJvSe77XoQt42MQklnSuKWkxM7zyFgipldFO+TsJ6ywgeOl3pQ8SspApmeeQLGBGgnJNYegrggAWVhJ16TrslqFpw12O2tjdX406zQZ3TK4S+CapmDanOwuLq1MfmBrjgjsw93wRvlNQuWdFSZQoOHSwgv5p1s6XU6h7L4SWY4lbrPXLbSDCDUMQPHbsLI2+rJ4ORlH/3RBLzNpHljKNlHQRi3htj6HmC+dD1VFY/G5LX1AFJMkGQM4198hBYN7kMNnLIKzBgwmRHnjbAKiarD3bfB/okYE84xc1z+5NnCZGYrjqPND6ncxiAmRRP4xKuRyvnrcW3WeQ9B0G5Xnt/O9N2EYNTnDyV7PoOk5y//Ojsex93GoRzLx3+f1K9kXoYgqc0nQWlsGpOZfCPWgOdT78W32oTzKy5HaXQp2+Kt2oW1iousz4ZeJS54Euwt+Qm2/
 XHlNGlju
 wIgTiSRRhDQjGQ3HPLxj8TeGt+XeoASNIbxZg8Z1nbWgiMPRe/YMmLbDzmsh5C2i+Pk02z5aGF2Em4Du3aNaDVkayJRg6oeew4SCeZN1FnZBU6JQYq4mtsfT2l/BlVkIkMc07pmuorTUH19036sxiiph+bqEE9K82UyH/h6lYyvY0Bj78s0hydXKs7O/LiDWOdLpugcj3fbJN4yLA6oWpJGxjvu/XwcmALOhqNsVKaM8t5vMXQqVFe/667FfZt30mjxhjzROz8uXLKl65PxGcPQ3M6IUr9wCVYi+xRnt3HomgiYY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bot+bpf-ci@kernel.org writes:

> ```
> commit 96abfe0549713749f00e32bff919a759db284a58
> Author: Roman Gushchin <roman.gushchin@linux.dev>
>
> mm: introduce BPF kfuncs to access memcg statistics and events
>
> This patch adds four new BPF kfuncs for accessing memory cgroup statistics
> and events, making them available to all BPF program types for implementing
> OOM policies and accelerating memcg data access.
>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 39a6c7c87..b9e08dddd 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>
> [ ... ]
>
>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>> index 76c342318..387255b8a 100644
>> --- a/mm/bpf_memcontrol.c
>> +++ b/mm/bpf_memcontrol.c
>
> [ ... ]
>
>> @@ -75,6 +75,56 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
>>  	css_put(&memcg->css);
>>  }
>>
>> +/**
>> + * bpf_mem_cgroup_vm_events - Read memory cgroup's vm event counter
>> + * @memcg: memory cgroup
>> + * @event: event id
>> + *
>> + * Allows to read memory cgroup event counters.
>> + */
>> +__bpf_kfunc unsigned long bpf_mem_cgroup_vm_events(struct mem_cgroup *memcg,
>> +						enum vm_event_item event)
>> +{
>> +	return memcg_events(memcg, event);
>> +}
>> +
>> +/**
>> + * bpf_mem_cgroup_usage - Read memory cgroup's usage
>> + * @memcg: memory cgroup
>> + *
>> + * Returns current memory cgroup size in bytes.
>> + */
>> +__bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
>> +{
>> +	return page_counter_read(&memcg->memory);
>> +}
>      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> The documentation says this returns bytes, but page_counter_read() returns
> pages. In mm/memcontrol-v1.c, the existing mem_cgroup_usage() function's
> return value is multiplied by PAGE_SIZE to convert to bytes:
>
>     return (u64)mem_cgroup_usage(memcg, false) * PAGE_SIZE;
>
> Should this function multiply the result by PAGE_SIZE to match its
> documentation, or should the documentation be updated to say it returns
> pages?

Yep, correct, fixed.

