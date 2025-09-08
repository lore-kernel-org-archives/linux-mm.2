Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3642CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 08:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03F3E8E000B; Mon,  8 Sep 2025 04:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31768E0001; Mon,  8 Sep 2025 04:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47208E000B; Mon,  8 Sep 2025 04:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2DA68E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:56:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3006B13C022
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:56:50 +0000 (UTC)
X-FDA: 83865477780.05.058DA19
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf23.hostedemail.com (Postfix) with ESMTP id 41044140002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:56:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wQfgqq8r;
	spf=pass (imf23.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757321808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XKQQNlo0TfpyWma+YA6JB+SzcXFLckK+IlyLWqw7/4Y=;
	b=Tmu62vdKzuN+KVdrx5HIw2JbGX5FPQSsMte86ufGXZ41tvVYzLgKAkH7k7INOKi2fEjQb/
	i1ai1/pSvzqRuGRRcYGwsqrmrYuGWpzu3HRv5UKp4H03uPE14HFvtyf7SL6SBFgtA7cLMo
	MwBC28y0MkgUMIql6SZiwFcSXAqpnEg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wQfgqq8r;
	spf=pass (imf23.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757321808; a=rsa-sha256;
	cv=none;
	b=qccUz+of1gCXrDFBU7AhylFhK/aFHWox9/4zokUl0TY9n3AyF0x5ynwk6t8FT5mCr9Digz
	qMRrCDRW1xXEqhHnAEwIixO0HHS60QLxb57asvv7qAfEsxtpdNAOvuWhvIGhFUUyhwKbTo
	vRLmyRnHfunWT6Mkrq/Gx098tRUB1+4=
Message-ID: <c089b941-97c7-4392-828f-923e8da3510a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757321806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XKQQNlo0TfpyWma+YA6JB+SzcXFLckK+IlyLWqw7/4Y=;
	b=wQfgqq8rLxodgybIZRFdD/kgN3ta6mz+xdpAzih/j5QppO3iZswBVbKWZyS+GBkxdntlZ8
	5SCZQokCfOfpOpNcCbYXeZ60Z5rCrCK8bFUyKpn8tjWXILFvOgib4DdfWeZ8xTgkBirO9U
	b84OcVFZz4t7xKxfvrzb/uDQEFJ3Izs=
Date: Mon, 8 Sep 2025 16:56:40 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/slub: Refactor note_cmpxchg_failure for better
 readability
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250908071922.1062170-1-ye.liu@linux.dev>
 <aL6WTrXczZJYUoGb@hyeyoo>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <aL6WTrXczZJYUoGb@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: mbgtqj8cyfg5xye3ek55omstxk6gf9tu
X-Rspam-User: 
X-Rspamd-Queue-Id: 41044140002
X-Rspamd-Server: rspam05
X-HE-Tag: 1757321808-746258
X-HE-Meta: U2FsdGVkX1/PNFTYPNie+5xHZrndy0i61LXtQIoTFkqO5pqQXGFpO/j9rFOpj363YFFjijl3n0jWSj9JO2iqKRUJTRUh1ZzHXM1ZfGhPo0tOwhGP1D7arKpFSqKZmWynLVW6HuZJ2fuvTxfF6/fBxYpO3zhNZYFhhIbrfSHyjwpPrDwOg1dxixFjQp+O1RbdZOlxdgmo8uMqjdbEgS+QRbAFQQ9GfZhDIgs+OR4m33ItReFap6y8YQqoMjQV5CtN1g4SakFg3c6XvIzeJWj2bnBeHCDTiIm4CWzJTIbtZG86IHbLbjuurZCJw2KkajFUgqsD0mvhkmcDXoGWMehLgjI2FkrUu9l8lM9qMbVxESojm8QzmuZhQxqm/7x/ZREaWjEp6UOQLQEhGALYBiRXiHwz6gp+5PzBATAJShGtuXON0Mao8X1GbBj1iv9QXbwobqhhHOr4p0zrJUny0D/+ymtsSZ1ltSvEkiAc2YaoG7TwjlDayY4mho3wtB6rJBRocqr2WU3HLL6eA1NrhzZ1/UZnTRSOkwEm4HR+lq9hHKyrbZYJYzKRhnLJ89mOHhNAWjPiYQPmnVQ4NikXvuCIAbp5ayE8ZmqrQDcuenhb0JwGAtua4aJw+7enTTQZcfhXH2JPTlerBrlbGak+WcXnqzEYk2it8MQpBQwk7h9ycMb9DW6g/VDJZCQubLyZ5SDx7/oZvs/MK0dsZ9cTzTYKkfausYyH5VYNtPTx9RjZEmVeCfCMc5x1dJv+RbEde2Lhy8+6ITsh8fa6R7gVcTAHZtFJfkmzZQDIXpnkEYLp65APCWXgaqE09z3zgbAfB/UhA5ptpmo0OzdWYB8vuTHi+8Lzg/GGKe/hGOOL2iZPSpeKMf2Q86sjLApinXCpzhX9Q8IcJb7JR3JR6LQnO4NpJ0jLv0UVhCOLweov6vRHTIOyXUHYz0FMteaU2ZQNCmk3wiIekxUiQ3rA6t5QlkJ
 J0PkUSrt
 zM07t1MR/FMIRnyc0njVGtZCn59XwTFn7nwU5qzA/ggw5XCC+cklX/EU9jxlnVJFUJF8cacGQYhaEtZhNxQ16Ec8cFZpdA1qTNEdqX0A4vZxaMBlqUe8J/qLITS8K0nDDg01MDjgia06FZlGla4cr+ubC/DlBGGElz2KTUeV72e1/98jGb+Ul5uooSOF56OToMPrbhMdaNspP4PV7ny29RJgCYhm2+gQoEzBj7uuEdsXLsHgu/0iAP1CaoCYSlvnZfOtyZO5pSozOnZ3+mTVKmIQRARNOH2+jdQkDe23Lwad2D0Cm3e4d3EgV2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/9/8 16:39, Harry Yoo 写道:
> On Mon, Sep 08, 2025 at 03:19:21PM +0800, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> Use IS_ENABLED() and standard if-else to make the code clearer.
>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
> 
> Looks good to me,
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> 
> with a nit,
> 
>>  mm/slub.c | 10 ++++------
>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 30003763d224..34853c0441a6 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -3064,18 +3064,16 @@ static inline void note_cmpxchg_failure(const char *n,
>>  
>>  	pr_info("%s %s: cmpxchg redo ", n, s->name);
>>  
>> -#ifdef CONFIG_PREEMPTION
>> -	if (tid_to_cpu(tid) != tid_to_cpu(actual_tid))
>> +	if (IS_ENABLED(CONFIG_PREEMPTION) && tid_to_cpu(tid) != tid_to_cpu(actual_tid)) {
> 
> nit: insert newline after && as it's more than 80 columns?

I noticed this too, but using the script ./scripts/checkpatch.pl , there were no warnings.

$ ./scripts/checkpatch.pl 0001-mm-slub-Refactor-note_cmpxchg_failure-for-better-rea.patch 
total: 0 errors, 0 warnings, 22 lines checked

0001-mm-slub-Refactor-note_cmpxchg_failure-for-better-rea.patch has no obvious style problems and is ready for submission.


> 
>>  		pr_warn("due to cpu change %d -> %d\n",
>>  			tid_to_cpu(tid), tid_to_cpu(actual_tid));
>> -	else
>> -#endif
>> -	if (tid_to_event(tid) != tid_to_event(actual_tid))
>> +	} else if (tid_to_event(tid) != tid_to_event(actual_tid)) {
>>  		pr_warn("due to cpu running other code. Event %ld->%ld\n",
>>  			tid_to_event(tid), tid_to_event(actual_tid));
>> -	else
>> +	} else {
>>  		pr_warn("for unknown reason: actual=%lx was=%lx target=%lx\n",
>>  			actual_tid, tid, next_tid(tid));
>> +	}
>>  #endif
>>  	stat(s, CMPXCHG_DOUBLE_CPU_FAIL);
>>  }
>> -- 
>> 2.43.0

-- 
Thanks,
Ye Liu


