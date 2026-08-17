Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F77C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 05:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EFAB6B038E; Mon, 17 Aug 2026 01:41:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A1D36B0392; Mon, 17 Aug 2026 01:41:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7156B039C; Mon, 17 Aug 2026 01:41:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 584176B038E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 01:41:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C6B8A1A06AA
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:41:04 +0000 (UTC)
X-FDA: 85109662848.07.C9C019C
Received: from mta1.migadu.com (out-73.mta1.migadu.com [95.215.58.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id C1298C000A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:41:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U6lISe9a;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.73 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786945263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=130pcrhjcoKMRGTzF8GG3rQKdb20ZPoIWRannswMZ5Y=;
	b=3SlaWiywh+P+kpDlKLqrL/jOx610jbu4Ah8uSxrKlhQx+/bz5IlcFaOpboe2AngPH35sQc
	KJQcZxUZTCJOE7pPrPWBeK80+YzMofdLIHnZchNiiLw9nHBYrs/1zBvaO1c59nU/uFrr/V
	frgEiqHlIb1yFuQ/zGGzmNowJBODUos=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U6lISe9a;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.73 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786945263;
	b=jqrDHz5Alj9fvISpxm0R9X7GRrBf1I4ZsI+6iias6enX5MMvBdNtxGzhcBUlxy6Vpao5Om
	c/6S8nX0rWHf+zy4o+Dhrnxp2BSUQczj49aV0EPgeCQ5jwQ/2ybQJ5jqHgEol3bgX8HUBc
	qDf6gOd4UmDGeSQVdivx6bd6k4ZwyI0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DILIHbnqaUpEeThjZgXr1gFeEMPrU2O6UtIr10vba0E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786945261; v=1; x=1787550061;
 b=U6lISe9aRrKkGMa932VSAurosfsoOgdU7njApQp7glvWira4JCHBEIU32S1AcWT6L2pnyoyh
 54WR4Z0kcrOE6uTdwVlwkYfb3fvFig26SdExiyy1Gh8Pby4Q0JRdUMDN6+AoiRm4f70KIo70p0n
 LgP8DofuLfvS62AQYNSYiZ3U=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.42.12.33] (116.128.244.169)
	by smtp.migadu.com with ESMTPS id a463d7034eb81a89;
	Mon, 17 Aug 2026 05:41:01 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <27f2ea45-cfee-40d4-8cf1-5955574c48bf@linux.dev>
Date: Mon, 17 Aug 2026 13:41:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/3] alloc_tag: remove /proc/allocinfo outside of
 mod_lock
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Aaron Tomlin <atomlin@atomlin.com>, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260813093421.135230-1-hao.ge@linux.dev>
 <20260813093421.135230-4-hao.ge@linux.dev>
 <CAJuCfpGfQrYJ=Rgrar-8btsiUCg=OQotWPou0J-mpMFNzrJC6A@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpGfQrYJ=Rgrar-8btsiUCg=OQotWPou0J-mpMFNzrJC6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C1298C000A
X-Stat-Signature: nc1os6u5rzs836wutdgjxdk4g4t79rs1
X-Rspam-User: 
X-HE-Tag: 1786945262-217555
X-HE-Meta: U2FsdGVkX18JRTJl+AV3tvHKjPaYIUXP6uJ2CmivTQdIBTy6FRRmh5BCVGd6TkeIK38sbLlHO/hH53Mc42VBmtIxA7Kq5dFinsFkHmxmeIWMs+v77fHnpI5/q7m9rKBfR0h7yebNXh5skqf4w2t4wHiIukp/Fb239eUpr+HfstxYVlLCRWIVwsFueTCDqMIEZO9ZUngJlULgr9sBgOEbjQko1xt15afUPy16bid8V830X3/zCoDPl4oGjDON9OgaJ/FtdApwiP4HAjl8cX/MasC/gyCVM1Vh/vXsqFL+NDN9gHzW+kgIR5+/Ca+/K3e7918gEpt8PCp+658qXwiW00Vu/Q8Ittp1e+zj1Jo68wYtaqe+5KmbzUkUxF7ENE52RyYolmeJWlS3IL/KVh8WMu5u5HWpBgqz1mVkaf0j7JeyyMimr6+ZPjhq+WUPj4Cd0fXFbIFsOnqvQJF/XZCaOPhWq8iocGGiZtvawWJgTmlbifi3CM7a6kcAWUi/jMPNEMjHrS/iS6BIIHRz1Eua9bBZVF3M9xWlNu3Q7T4xfNH0lc1j00exNL9xKZtJLax7dOpcIhqFkB4yINjhj6v76RGDAYpmC0ljgdq0LemKWq2B+WzlrAW2p9P7vll7wDGMl5ay6fH/OkUqzB++xJkxAE7zhOf3PKJOsoLxMFPNzlQh+VfrDo1K47gcDwOyKIL7njS24I+ZdPkRd+jKzZI3t+t05x6icMqrFF/sf/kg/4hEj8IhkMW3n6H1OLeJhCebYHm6Ki7pfzAHHSvM/V1MMjEcXHGLRKfd5JvMspWUhjvhTEFW043Xd/ti1qUTuW7FHvWZQJ6p/Xeqh09T68YBCDumna20f8C7TJkakoBsVSsV4cV9yxY0hAZ+nP1qGEb8s+BUI/nMMEESRPfmFMqVw/51NQruUQkPGCvR9an0M4rbeWy1NjjXwkyOJksY4ZMPFELPg8Oh4C9Odwn0GjT
 0VeYktPU
 ClcyZBa0FkVk8kbAuDRWhffAwJu2Zmowi3nuVKeOR/fy8AszSguy+Zw+ZgWnMC3YoXvDh67jNtdnMWYl0R2n0Ugan5f5RvTyEYNIV1LA63se2Zy6CRGATYD81d0d0kfXovNcgDTb+0y+vzXgUbK34PtEyGl4B92AWLBBfRAU17xj2DQoyGYlQ2Cb80v+dFDIPybl3TDC32EMXL7fYiK2o8LInA/xk7pijvyjrltwoQpgy98oeBkpSlztvEKEhIh5b1ybFl1ztXOEgkbgIcXd3KKS/oYZpQQTw/7FVPJC17M4ILxWv3B1GauC4YspUtV0K9cJO95VcVsDGSldvdTNGcyeryV9Cz+3ONwCc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren

On 2026/8/15 14:51, Suren Baghdasaryan wrote:
> On Thu, Aug 13, 2026 at 2:34 AM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> shutdown_mem_profiling() calls remove_proc_entry() from
>> reserve_module_tags(), which runs under mod_lock held for write.
>> remove_proc_entry() waits for readers, and a reader takes mod_lock for
>> read in allocinfo_start():
>>
>>   CPU0 (insmod)                      CPU1 (read /proc/allocinfo)
>>   ----------------                   ----------------------------
>>   reserve_module_tags()
>>     down_write(&mod_lock)  [held]
>>                                      use_pde()            [in_use++]
>>                                      allocinfo_start()
>>                                        down_read(&mod_lock)  <- blocks
>>     shutdown_mem_profiling()
>>       remove_proc_entry()
>>         wait for in_use == 0         <- blocks
> 
> Yes, this is indeed a possible race.
> 
>>
>> Move remove_proc_entry() to a workqueue.
>>
>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
> 
> I think all these issues were reported by Sashiko, so you should add a
> Reported-by tag.
> 

Right, I'll add them. Patches 1 and 3 will be resent as a standalone
two-patch series with the Reported-by tags included.
Thanks a lot for all the help on this series.

Thanks
Best Regards
Hao

>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> 
> LGTM
> 
>> ---
>>  mm/alloc_tag.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
>> index 7481180dadd2..b80f5a151f28 100644
>> --- a/mm/alloc_tag.c
>> +++ b/mm/alloc_tag.c
>> @@ -591,6 +591,13 @@ void pgalloc_tag_swap(struct folio *new, struct folio *old)
>>         put_page_tag_ref(handle_new);
>>  }
>>
>> +static void remove_allocinfo_file(struct work_struct *work)
>> +{
>> +       remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
>> +}
>> +
>> +static DECLARE_WORK(remove_allocinfo_work, remove_allocinfo_file);
>> +
>>  static void shutdown_mem_profiling(bool remove_file)
>>  {
>>         if (mem_alloc_profiling_enabled())
>> @@ -600,7 +607,7 @@ static void shutdown_mem_profiling(bool remove_file)
>>                 return;
>>
>>         if (remove_file)
>> -               remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
>> +               schedule_work(&remove_allocinfo_work);
>>         mem_profiling_support = false;
>>  }
>>
>> --
>> 2.25.1
>>

