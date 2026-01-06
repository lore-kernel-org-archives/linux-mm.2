Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40CD0C47BCF
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 09:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EE3D6B0088; Tue,  6 Jan 2026 04:29:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89BF66B0093; Tue,  6 Jan 2026 04:29:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79EB26B0095; Tue,  6 Jan 2026 04:29:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6BAE86B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:29:12 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AEB4A1B19A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:29:11 +0000 (UTC)
X-FDA: 84301015302.09.9409915
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 032D8C000D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:29:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uxTKCkUn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767691750; a=rsa-sha256;
	cv=none;
	b=O/JXd3wp+QXFiCKWQ5Pc8pMxYrW299vvDoWPTgteOOsmWGQ9CgzFBmQltMCg3qUFL7XbI0
	/fnc+BlnzSCjBoLqe0z3dTGByUTmWDknm7YzJFjtRX7GiJEbYFTfizEiiKCsOwOgW8KBIe
	J3biBUIlASAqm1ub7HaeQUuo4nuX8Z0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uxTKCkUn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767691750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/cfVmAPkdKJIaKPKJXgxdYbTA4pwSPAjsaYAfiDVVLk=;
	b=D5/ozDo3bQGBqwa8TuCRD84VnqaHzduNRmnXGoy5bWw3BR4hvc2je2eBLJFUOWit3yYXTX
	FN4+RRBgSblEoARjuhoO27jgDbzhhN9Qx1CWFWqEYoNj3kB93rZPOlrEbAW5Tsm5rf8yH8
	GVbnZez9cYlAdm2fikd9HNeV1XW+EpE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 133026014C;
	Tue,  6 Jan 2026 09:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCC7C116C6;
	Tue,  6 Jan 2026 09:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767691748;
	bh=FSh84bU2dXc5DUPed3Z3ZEewqGC8mmHOAR0wDd9Ta18=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uxTKCkUnriphMbAcvilCkpzvrbbnoHD6hkkqBkw8S/anXzdY5oG7YCTKx6OBK3OCq
	 VMYDbLkXy5fKXLvNoAcXJ6X22uyA7BaCHMvUsrTh0myYWeW9K+v/Itp+STtj9ie+L6
	 5aWXHYR3CJVqe6pCg49ULwtJixFRnojlgacdYUJxZLRnWvrCHAaG2Exji9j3betrte
	 d4CT+m5qDFL19kkzm1XdMyr7lyQO6Z0cPov0M7e9Mu56gytci8RTMnydDDWZ//e6N8
	 2LxiZyrhOvLh+qvTIJdJqv0FUQ/CT7hsF3acpGNcWnDM72lWxfBTASyiU7CJ2aufIp
	 9MGQ6n3aRZKsw==
Message-ID: <cbcc95f1-5039-4fe3-bc7a-c8edc29f5b11@kernel.org>
Date: Tue, 6 Jan 2026 10:29:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] kernel/fork: Update obsolete use_mm references to
 kthread_use_mm
To: Michal Hocko <mhocko@suse.com>,
 =?UTF-8?B?bWluZ3podS53YW5nKOeOi+aYjuePoCk=?= <mingzhu.wang@transsion.com>
Cc: "kees@kernel.org" <kees@kernel.org>, "mingo@redhat.com"
 <mingo@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
 "mgorman@suse.de" <mgorman@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
 <surenb@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Jiazi Li <jqqlijiazi@gmail.com>
References: <KUZPR04MB89656F6F10537974E46766E08F87A@KUZPR04MB8965.apcprd04.prod.outlook.com>
 <aVzVVTS3gjtz4XNB@tiehlicka>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aVzVVTS3gjtz4XNB@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 032D8C000D
X-Rspamd-Server: rspam10
X-Stat-Signature: mfz19my7ycniwyyiat6oe1m5kyysmnkb
X-HE-Tag: 1767691749-591497
X-HE-Meta: U2FsdGVkX1/2Apnw1b6sJ4XHlKdJ4f3bWRa8lBDov7hmieD/kCfIMnlXQfLZiYs+32aL0H39Q4q2l1su+qtfSTSufXYxERfjjhjJkGY+eomoSjd7EswPq6ZdvkYFBwQq0ZB81TI0NUHqF+36HgELQrHnQbzsdGyBIwV5Yyl3OeUHv3IHUsFhjjgjPmAPgrwaz5B2OSM8uWCrmACI6Rqyjg1C5Ot2XKrig6+9IoVo9CFNCCHljbLwRmHwql034wxF/IJyiBriMNL/E7qj8GXu61HyedcGCJhH2hfmqdck5g/qay70ruPxtKraN7dfqJx7S1fJuWhH33bec4ucNqzkvApAml2Y3XcrGEJIoJr54mCahBByIHQ1ff/8oZDHvb8zMs5ZaY71SEZjGagZyww+mo9MBa0wk9r2IOVeQFBfCgOiYqBbUmNmzlE5TSPsgRUxp6QlTU1EEHxhvnWP+NaqTtLmn7Ln9LL7amynRLVT+LWijmoVT+vY1g/ycyQnX7nMYQgHPE9/Yb+UwQb4LE5l7Qwwd3vWT3ZdZi7+c0JOaHSgCzX8riQlNB6qscKUtL0EQuzMZ58UwuyzUNCEdp1EArwxhMJkvjOVgVF3RuEDh+kawpyYjmPfIkQjIXX8MOXyUKaue/QF68/fn3q6aRnQHK96jmeu03xAHv/gWfzXDFxkk6bB912gxeMrDMU2EFl4ipneXmCq0P4smnSel7CN2MduTTQOnkFAGuVbL2dmeh9LhEFDGymhwUZr6s/q7C+ZRCs6qs6zvJ91hxhhSrpaBQZSUMg6iLwScfYUOkiPWBmq+it9UpvpcM2fZTxEuBJsMwmlAVf6PyugTeH9a6hxYiQf2XlI812uhOOcQ5i39DgJ71W4pFGzxmFXuReQ8EUu0nDExkwSAAlzRIv+Ea6f4+SCDNiH++8GkK2i5TKslVtPP+SlF6vdUcuEFe9L1+pGJPdcPU8A5jlZv0BxpVq
 GnHgld7A
 GZp3j15ls1EJm2Yi5dZhQzW9dBmEFKSO6DCKU0yP5idmplghT5680eIjJv6KtuXQFqUTFkFgaPXU7w+rsgacv6EUgiTQ/NWvg2XRiXZiTcE/jFOZNqJuSJIQX8dTc+0I1iyzaLK7M01HR53tebDRJOJTLGxucPaghmyQFVs5DDeZdUfV3eYGPTOeQOsckse2+4eL90z4T43+xDUcFUhpjCPbPfeTF6EXlbUzUPHSpIoVlLHqFmdBFD/TC4c4tcvn4SaU4tvNwBr/y9mmzsWTpwrRG0RF4paYCM+TDrO34Rf2slfjvcs7bK9NIBnBoEye+mkqtdIkT9if+6BLBsRQG4iYbtmMcV8oRTpM4nLc5kuNrzKgXsQw7jliIIj/kRm/1yx0zgnhE5Ahhp0gMZNRK9dlq9b1eRlCsWoq98y1u4caH48ao3VOBEUlnrYOEJsqucip0xFAjo0vKArRSXPKL0cP2wg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 10:26, Michal Hocko wrote:
> On Tue 06-01-26 07:05:28, mingzhu.wang(王明珠) wrote:
>> The comment for get_task_mm() in kernel/fork.c incorrectly references the deprecated function `use_mm()`, which has been renamed to `kthread_use_mm()` in kernel/kthread.c.
>> This patch updates the documentation to reflect the current function names, ensuring accuracy when developers refer to the kernel thread memory context API.
>> No functional changes were introduced.
>>
>> Signed-off-by: mingzhu.wang <mingzhu.wang@transsion.com>
>> ---
>>   kernel/fork.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/fork.c b/kernel/fork.c index c4ada32598bd..64e228c541bc 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -1312,7 +1312,7 @@ struct file *get_task_exe_file(struct task_struct *task)
>>    * @task: The task.
>>    *
>>    * Returns %NULL if the task has no mm.  Checks PF_KTHREAD (meaning
>> - * this kernel workthread has transiently adopted a user mm with use_mm,
>> + * this kernel workthread has transiently adopted a user mm with
>> + kthread_use_mm,
> 
> Please do not wrap the line here.

But please do so in the patch description, where the maximum should 
usually be 72 characters per line. :)

-- 
Cheers

David

