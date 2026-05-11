Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7E81CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C7EB6B00B5; Mon, 11 May 2026 07:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0846B00B8; Mon, 11 May 2026 07:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DCAC6B00B9; Mon, 11 May 2026 07:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F02326B00B5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:55:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD5101C056B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:55:05 +0000 (UTC)
X-FDA: 84754982970.06.E4B33C2
Received: from mail-m82105.xmail.ntesmail.com (mail-m82105.xmail.ntesmail.com [156.224.82.105])
	by imf30.hostedemail.com (Postfix) with ESMTP id D442880008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:55:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf30.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.105 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778500504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=asIEvRkCTtWHC8/+bRUN5Rt+PkEyZqzKOCX9thOMBSI=;
	b=TneUvOJTFeQlOy8mA2ftN4Bk+Y5IS32pISYQjYHYQJQzFPT6y1fiYXUiVfy+NgMRI0uj93
	VuAqKXYFCGo05e1O1jAoEFd61QWo2lTqGxNaVhpt2kFL9nwTM/i9pwDOrkO8noTgivRUwZ
	QAMay1Rs+8HMB7qOuTxVVJfzFA0RSD8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778500504; a=rsa-sha256;
	cv=none;
	b=OnLFLgyRtuQoXLUYCXF+7fSHXShTdSw28gUl6OJ9R9/7HH9gL1eZBFtj2vDgcL5W4exqMw
	YA20lwtPio5uZLamsmsb/CZDxUbqnmptO0J18jIIVNeV3+CUOSn10Wm5Y9Jb/zk1bM/wmJ
	xNw4r/SuHern0pbCgYIEnL+6/BWkVvg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf30.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.105 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 19f960b4e;
	Mon, 11 May 2026 19:54:57 +0800 (GMT+08:00)
Message-ID: <93b0b3ed-2b99-4c2c-bfaa-002f3be27171@easystack.cn>
Date: Mon, 11 May 2026 19:54:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/3] mm/page_owner: add print_mode filter
To: Oscar Salvador <osalvador@suse.de>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 SeongJae Park <sj@kernel.org>
References: <20260511033017.747781-1-zhen.ni@easystack.cn>
 <20260511033017.747781-2-zhen.ni@easystack.cn>
 <agGTb37oElM7rff7@localhost.localdomain>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <agGTb37oElM7rff7@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e16e3ef6d0229kunm9f30c014302091
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaT08aVkIfTEtJGB4ZTx5PSFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D442880008
X-Stat-Signature: onmwtpyy5iywodhd5kwuxh555cjh93me
X-Rspam-User: 
X-HE-Tag: 1778500502-622068
X-HE-Meta: U2FsdGVkX18IX/+cFaXr5ZLhkv2/vy4LGhnUB8R2SvUOHCMrLUuTWQzROIxYGrpC0ooTiAc4QvH4vIGb9L7+PkclZINUdv165p+9X4MkAvbgxM9s/11fxzWBAuN6KwD6hypO4qLyYayVVecm8o6gNpmaOHwwNlzoWTecxmAkAoBKqYwow1yV4zlH21hTHaCnuv8+e0w76lj1mAlEzNfd8xHHaWbmKAvID/xiPJXlEXN1IrgRFXBGrd0pr+mNU6kWvAUxAgvKT5jJg9jIA2LvFCgI6WpTyuqhBggefIBeuX9KpVc7BTDVgnh0eTlv0GY6+aRudDddOoo2U5qefQIdp6KTmzfIEe16EXvQTGwP3yLWNkef/h+r9cRM49e66iMhHLKcUYFkrex+LNb32Zzkvb+d9VPRFredWhqBBQbH/hu/7qBBKeSoXZoL6pWrfyTlVzxaREd+MPYhMD1aHneHZQghy0BksF+E7tKS0WO+6FwPrI1gOZj3S5L40vnWghs7bPvyQEQ6dFFn0O7A/HbRea8aJmnd1PuyQz8GsDsnX8AjFQZrm6jGCRz5Yu5kd6/4bxdWdTgrSzU1D67wszC7PrWWiJkzYfuA/Ec9Wdf5ReudODmQPTwZfbGWeAGNDSYL0jv1yTeSb/L2xFU5fvxsLXLR9DNpQjRme1K6fY9VxifkEpbnBqnTDlFD/2DIPKM17zdiOXeDomeTM9+nVQ0Mp4nwz9od/3JFDrWD2EAquHphSTZgnS+tUhnW/dfuvzLiAVt8W9AZTFzOhkpiisCLfNEMnVJv1retLHK7cXqgifMBNPtJ7JfEztX2Gcz0VV+KP+5wouqF6a9r022oyO5LMgod+soKsfJc041oN9mj5ThgpP475QJRJFsmRN4G5uiXsl67yUkaLDqn0MiSxidhLDOXXVUp8h/szVgjawkcHW18zPdO1hmrBLrDkfZHmpWkddKXh1KLZcr+U2WnW6Z
 Q/2meuuT
 eDEu0x1tyvWfBVpzTX72Yl7u7MEe47Jpcc53hCGeSg0mZrYZo4pXED1/AOvYHCLAxRUoCzqviEdeLv9eXvwEM5W8Q5FSktOmZJCHZgXrogI0GkE7GRlUcHo91zdYsfXl9VfhZNrlabM0xXKITCfarcF/iPA5/ZpENxlyjaRUB9xL6uLnMVlcXz9571VDozIZ5aoi4lotmNAIYapO1vzMzBykfQ2X9UL84tOlLbEVolrHcphBlfGd2ZcCEsJ8J76w6SsTbvBoNybnm5dQSLgQd8hOomA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/5/11 16:29, Oscar Salvador 写道:
> On Mon, May 11, 2026 at 11:30:15AM +0800, Zhen Ni wrote:
>> Add a print_mode filter to page_owner that allows users to choose between
>> printing full stack traces or only stack handles, significantly reducing
>> output size for debugging and analysis.
>>
>> The filter provides a string-based interface under
>> /sys/kernel/debug/page_owner_filter/:
>> - Reading shows the current mode with [] brackets around active option
>> - Writing accepts "full_stack" or "stack_handle" strings
>>
>> The default full_stack mode maintains backward compatibility with existing
>> usage, displaying complete stack traces for each page allocation.
>>
>> The stack_handle mode dramatically reduces log size by showing only
>> the handle number instead of the full stack trace. The mapping from
>> handles to actual stack traces can be obtained via the
>> show_stacks_handles interface.
>>
>> Example usage:
>>    # echo stack_handle > /sys/kernel/debug/page_owner_filter/print_mode
>>    # cat /sys/kernel/debug/page_owner_filter/print_mode
>>    full_stack [stack_handle]
>>    # cat /sys/kernel/debug/page_owner
>>    Page allocated via order 0, migratetype Unmovable, gfp_mask 0x1100ca,
>>    pid 1, tgid 1 (systemd), ts 123456789 ns
>>    PFN 0x1000 type Unmovable Block 1 type Unmovable
>>    Flags 0x3fffe800000084(referenced|lru|active|private|node=0|zone=1)
>>    handle: 17432583
>>    ...
>>
>> Reviewed-by: SeongJae Park <sj@kernel.org>
>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> 
> Overall looks good to me, one comment below
> 
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> 
>> ---
> ...
>> ---
>>   mm/page_owner.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 80 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>> index 8178e0be557f..27a412c52d41 100644
>> --- a/mm/page_owner.c
>> +++ b/mm/page_owner.c
>> @@ -1,5 +1,6 @@
>>   // SPDX-License-Identifier: GPL-2.0
>>   #include <linux/debugfs.h>
>> +#include <linux/fs.h>
> 
> Why do we need this?
> 
The code already gets <linux/fs.h> indirectly through
<linux/debugfs.h>

I will remove it in v7.

Thanks for catching this!
> 

Best regards,
Zhen

