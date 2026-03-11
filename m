Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4965AFD88F9
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 04:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6303B6B0005; Wed, 11 Mar 2026 00:52:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DAB96B0089; Wed, 11 Mar 2026 00:52:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E6EA6B008A; Wed, 11 Mar 2026 00:52:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 27DD86B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:52:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D1A01403E7
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:52:23 +0000 (UTC)
X-FDA: 84532560966.14.ADC5130
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id AA837A000E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:52:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YgPf4gzY;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773204742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcx2tEiM5H2TyNtKlNF/IXle4ed2aOsVuUva7tVU4ck=;
	b=UPVD/2pXA2udJqnMYnTxi4Ga2fDosKpw1uzj0nkU32DFBk2vAQSrz3hZoLTgweK/lUhAV3
	fBvovceb+fiDawZZIr73oy4mQRZVQLAfco6DEeD0y4ONi8vKaGpzVXN8fNV7QWcR11QllV
	kXXN2rYHnYBnibcOxJwL1o1VYs9LwxY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YgPf4gzY;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773204742; a=rsa-sha256;
	cv=none;
	b=DIGaHm8YUVQ3DhmROPapnIQTWfH4lcSoZ+0wlBiLLCVb+93+pQWrmhXmj4p46VZqM72zBA
	eX3BE9kiMy981WjE3Zl/e4ij1Yi5Qw1wRiqotvrIYKfpnbu8Ijg9CK8XKccMl0mowyBnjL
	MHeOzptWcRZWS7TsfHzkps6cgb6kr/M=
Message-ID: <be82a89f-aef2-4fd9-9304-a5c9b4e3e125@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773204739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vcx2tEiM5H2TyNtKlNF/IXle4ed2aOsVuUva7tVU4ck=;
	b=YgPf4gzYEQFnc2G2R71vHKH2wNhu/NkhsvJENqvp6gxGBcUCh2KRtpTtTaVSAoN1E+H5Ud
	+TPEdKlc5NZpMYuA/F7u2br/L4behR5oIf4nDTpHfXXZS5Knx9645OuyL8op5axLAWqubH
	ikU6AJ2BLGupt/sqhbtQ/Dy8Xm8yeyU=
Date: Wed, 11 Mar 2026 12:52:02 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 2/4] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>, Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org,
 kernel-team@meta.com, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
References: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
 <20260310-thp_logs-v5-2-686099175bf6@debian.org>
 <20260311031229.mloqvlmmqipr7k2h@master>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260311031229.mloqvlmmqipr7k2h@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ur4e5c68qkrth8c61ufao9b63ktefot4
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: AA837A000E
X-HE-Tag: 1773204741-187813
X-HE-Meta: U2FsdGVkX1+Zj4aa3s6QHp9yBKe4zhwA+V9RRMVf4VuiObfNSQnERJNVC7Y+ULA3L0220EDJa7O4QuQGuxH0LAwcOYe5TIl9D2JYMAZNSuCVrycZT6QVWQ9J3/hPghpMDBQKuxLXu60w3AHHpZpgMXLBny8vclH5W/swcUp/HVpsk/8vo0MVJoZEOiZ3If7K2/6ZH6UCGxBNv5wt9zzbjfnTH/8AClsxU0g9Kqmt1ijl6FGs6e3dTGs+X5KxfRsRC4HKVoFx/hqsVm1RON8JCRP3NRdLL9PYGW2isudDgmyS3ntUOPlc/1BIUTaYJsg78Z9ytv6+hYQTJ8DeXJRfQruWnCMMnGwuKlwiY6YA1J5j88QRRo4KuS+DN2SZPqiH/sJk63nicrf3dRhRuQq+ksawdqExcJP1ZYSdOoutIniOR5w3SiOI0cJckR8ZsbCdKQg8aPD4jZYkvV8pI1ydWCt9IuLYBySoJa9qwUG15e1R9lGjOiWe17cJquCzfAe8mvgpDENEeo4qBeeuTfu0dX1G70A8JbAnJPZLAh/dNDTaRD1E48/SPy52y4Q1jkRIee09q6746zvMvRL5Ft4h7kak3p0N8avtsWVOKbrV6/o2tYrN19bqf05rjHG6rjxpubt9JrQVLfdzgZW0PzZd4W17eUFKPbuqXhkWvqOz+8haV5/jIicSw4L0PTUij1vUF1uSuvJ0VsyvrwXvRcdmkdxv+RaeaVuIqS6u97KVO3FUoKebFo89A94G1QgJq/pwYum3GHq4UeydOGsko+w6v3U1400mlv1Q7lgiTJzScdfCsXSPt44peSfCqOv/plbghLxDcQfdIolq3GGvGf6CoNWec9W7jxNf7lboGGaSs9ouT7WRIEjbVXbXAahqQY6GOGEFkkDxhsVWrE0ChCIOVbzzi1o2HY9IFg0aZSTH5mwsh1ZP9ljTxEALxAiYWL7AWHb3nv2rxIXSiKYvIfm
 nrJPaxw4
 aw1yc7yp0L/Sr1GOuj6qjUZZc1o+dwWz6ARcZjDY0tztrA/rv6FUXkzBVa9qO9XX3RR7vblaaNywROtk1MEgbYfimwTm6RjWi/Lbq34OpCswkarzNesAGlhu+rW9WrDyh0frFlTZukVAdiGPwuzAnN53EW1NRScgAPbZYVhGnBY5L7kjJNIH/YdN5Q2wHinA6GpaeInxXzDJrJHlA+k210JToS/VvlSBiWzfZOdoxpOTSxirYgvtgXGdsehyTYxhjYq9t3PwjHE4XDv7Pr5eubHL9CSKzfD4R0iDVfuR5qQ3tWcmgXUEs3JVJMGCo0+lIWW1CbNCqOnTZRhCWNeNvvQG6RPCFC2rwyVJVfMldha8+GD6Ia/3Hlj3+fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/11 11:12, Wei Yang wrote:
> On Tue, Mar 10, 2026 at 10:57:08AM -0700, Breno Leitao wrote:
>> Consolidate the repeated spin_lock/set_bit/clear_bit pattern in
>> anon_enabled_store() into a new change_anon_orders() helper that
>> loops over an orders[] array, setting the bit for the selected mode
>> and clearing the others.
>>
>> Introduce enum anon_enabled_mode and anon_enabled_mode_strings[]
>> for the per-order anon THP setting.
>>
>> Use sysfs_match_string() with the anon_enabled_mode_strings[] table
>> to replace the if/else chain of sysfs_streq() calls.
>>
>> The helper uses test_and_set_bit()/test_and_clear_bit() to track
>> whether the state actually changed, so start_stop_khugepaged() is
>> only called when needed. When the mode is unchanged,
>> set_recommended_min_free_kbytes() is called directly to preserve
>> the watermark recalculation behavior of the original code.
>>
>> Signed-off-by: Breno Leitao <leitao@debian.org>
>> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>> ---
>> mm/huge_memory.c | 84 +++++++++++++++++++++++++++++++++++---------------------
>> 1 file changed, 52 insertions(+), 32 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 8e2746ea74adf..e19dda5aaf195 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -316,6 +316,20 @@ static ssize_t enabled_show(struct kobject *kobj,
>> 	return sysfs_emit(buf, "%s\n", output);
>> }
>>
>> +enum anon_enabled_mode {
>> +	ANON_ENABLED_ALWAYS	= 0,
>> +	ANON_ENABLED_MADVISE	= 1,
>> +	ANON_ENABLED_INHERIT	= 2,
>> +	ANON_ENABLED_NEVER	= 3,
>> +};
>> +
>> +static const char * const anon_enabled_mode_strings[] = {
>> +	[ANON_ENABLED_ALWAYS]	= "always",
>> +	[ANON_ENABLED_MADVISE]	= "madvise",
>> +	[ANON_ENABLED_INHERIT]	= "inherit",
>> +	[ANON_ENABLED_NEVER]	= "never",
>> +};
>> +
> 
> Just one trivial thing, maybe keep the sequence as the sysfs output?
> 
> Currently the output of /sys/kernel/transparent_hugepage/hugepages-xxxkB is
> 
>      always inherit madvise [never]
> 
> But no strong opinion on this.

Yeah, keeping the enum order consistent with the sysfs output looks 
sensible :)

Apart from that, LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

