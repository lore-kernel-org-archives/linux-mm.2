Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89F7AFF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 10:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAD886B0088; Mon, 27 Apr 2026 06:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5F756B008A; Mon, 27 Apr 2026 06:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B75A36B0093; Mon, 27 Apr 2026 06:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A71946B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:55:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D3271B6B13
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:55:14 +0000 (UTC)
X-FDA: 84704028948.11.85B7FB7
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf30.hostedemail.com (Postfix) with ESMTP id C87FB8000C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:55:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vaMgGQQ7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777287312; a=rsa-sha256;
	cv=none;
	b=G6FLH0GRHpofgrb8qITU+W2frB2aVuC70XFycrnHGosPTGd8/yRz6ZxnRWZkk+PyLQ2UEW
	6KvfHR8mvQpYp2YkOZH29GjXpBDcF8t9FElPKFEX/oXp6/5h69DoHOYmHWwonXicEh0vSB
	OAZmdx1v5b6/EDkTn4eQP0O15p29FgU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vaMgGQQ7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777287312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=01pnW2uMOPcCj5rJaZLF3XU0HpXGu/ejkcw5Amteq3k=;
	b=6KY/O+zcD68rBYKMVjkjubMzZz5OaJsr5embdaLxU6+KmEf5VMDJY956Gd+8adxMyZLhZE
	9/HC/a1rX/whQRJi0FOD1uPyk01B8DgDk11bSlBKxXIS5Z+85+fguG8W6p/DdQeeN4qDmm
	TrxxM2lHZc3lkT9L5hy9Djup/te85wk=
Message-ID: <b85cf299-eecb-4868-9d2d-0fc526e6c2eb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777287307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=01pnW2uMOPcCj5rJaZLF3XU0HpXGu/ejkcw5Amteq3k=;
	b=vaMgGQQ7gF+2VqyK2PHIai6pYu6HfSISoVSFz98mGUuSjh+1gSIes28GJnt5DZAkRLBQSq
	gFVoXSjF7QKRBEiqHffysKmWeO4bpkWGKW1ttjvAtlHe19ZrtVpGCE/KKt/YQLFN25RaVG
	jeNlGGytB6UYbm4m59D7aiyiAvlTJ40=
Date: Mon, 27 Apr 2026 18:54:38 +0800
MIME-Version: 1.0
Subject: Re: [syzbot] [mm?] WARNING: bad unlock balance in do_wp_page
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shakeel.butt@linux.dev,
 syzbot <syzbot+7d60b33a8a546263da7c@syzkaller.appspotmail.com>,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, surenb@google.com, syzkaller-bugs@googlegroups.com,
 vbabka@kernel.org, Muchun Song <songmuchun@bytedance.com>
References: <69edca15.170a0220.38e3f1.0000.GAE@google.com>
 <20260426034938.db29d74982a8eb8463f8cf3a@linux-foundation.org>
 <e7187a21-7114-4f42-bf8b-90d6e6b54fa2@linux.dev>
 <20260426105532.43768b24a42744f1b52fdff2@linux-foundation.org>
 <3591c663-a4a9-4c22-97cf-b58b2e7d8a41@linux.dev>
 <20260427034352.6ca48156d613319aac415290@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260427034352.6ca48156d613319aac415290@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: eb98b7nmo46m1qfznyj7fqs93fypttm8
X-Rspam-User: 
X-Rspamd-Queue-Id: C87FB8000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1777287310-862448
X-HE-Meta: U2FsdGVkX188/8lYV8FOkf5Tmjoy+uiC9RB4sVN0DAo6kJUrzAO7f87NNLOk+T6zWLo1oNPfHypbCE/woFDNqqPJdy6S/3Id+WS31pcAupZNwnI5bjwNXPRi3P3vXl6/K+JrrYw+xgDDFObjmVEF4P6mN/9LckZogH19IZ2EbeyjOZm9Ni+Boydqv4+Ec6ujxfqSD7T5HJxWtx0Vx+dxz8qZrFnutNttK8tZ22icN4WEp0fPmhNMF9cYALSBOv4OIBNN3HNmVp0nnjRoPT84RknFhbfdiXBvWEeGy8TwQmSMFJAe45R3qBHWE71erA+uEZ4HJw+VYB7w46Bez+oHGS9NIFpmhRkWBvQONkwfchO/qGbyYw8fnvquf5P0NPjqwiGi7tgL7givOHLdq/rrL+3sXLHN85GMUxxaeJL++pgTM1H+RR6obXN+8GovtHdg4qR6aUpyLzzN/6RuOeQ7wFkyPZQRkctmtCNe0ZHRGU/F33F6rqjJ92b/fGrCxf4wzvmryFiBLjRug0HrU0ekHItWEdGp/aKn4ZBLdmm8Y/I8ibAB9dro754Y8A0reGKu5/4mQNbSQzRms/TbwcSywsGiQOMfp1kjjhQyGZT7OhaR1B/tijso2gprHC8e+1T/ry26PN8psfJQpPKhxR6ES0k8XO/PaWEiO0Z0t87JhSRNuux82YSpa8eoiuRSxrRMPLWOtQzgyEfEJ5hrZJMmd7wS+UHj3C5y6AOBafkMo627VxXxVoYqbDXxs1XWT4mGYNsNZGk3WrbsYZd5/Y9f33k9HGqfYcusKX2z9mynfvvBYFgvOFJysCfgo4JtMfHwQp2s9eTuH+nBz3UWoEGmGu/6aFFmTXb9IFOy080Lk983WJBpVjZV/uhL8AvHlzUb7m31Gl42QEMpTD2EC7WtUOCWoTa1LBb9Vn1/tXhJwRl3muaHOVO1Le4sc5rNluI+IKfJ5zuSVw+hcMF0Lxh
 vCEIGe+s
 M+422ZAYnK0anUqwuBoXrn5m4NC82SgdIrvqhkCQ9qt1YbJWEKGFhGLGEAG0KAq4CvdAfu4Llc/SW5oJJbaMZdBqgKs4RhiInVg1VxrlQnjW/wxfze4V6azZ6r0ECx5tYhfLarUy8e7FnnIFo+K+2HfO0eQADRRZliu9ZrUv9a7UYheFfgP6AML/BailUP7/dUIvNqtYdI7EC37zcIzFKgOIQ14ofOpqKOIFXjcWy69Pq7c2YGtiNym8QYq0KvOjBDpuITNtRSnJV4wjfcLx+9kfC4isd7P5KGER4sPEWJFHxXbXXcfym6ZqLejzBTh3rOhK8Nu08FfTJrjRxzKJmA+LCF4RE3kpbzrVy7qgX+aoAgLc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/27/26 6:43 PM, Andrew Morton wrote:
> On Mon, 27 Apr 2026 15:24:10 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>>
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -805,10 +805,15 @@ static long memcg_state_val_in_pages(int idx, long
>> val)
>>     * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid
>> race with
>>     * reparenting of non-hierarchical state_locals.
>>     */
>> -static inline struct mem_cgroup *get_non_dying_memcg_start(struct
>> mem_cgroup *memcg)
>> +static inline struct mem_cgroup *get_non_dying_memcg_start(struct
>> mem_cgroup *memcg,
>> +							   bool *locked)
> 
> Sometimes this is called "locked", sometimes "rcu_locked".  Let's be
> consistent please.

OK.

> 
>>    {
>> -	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>> +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
>> +		*locked = false;
>>    		return memcg;
>> +	}
> 
> I was thinking we could use a single bit in the task_struct for this:

Maybe this isn't the good idea.

It feels a bit weird to add a new member to task_struct just to fix a
minor bug in mm. :(

> 
> --- a/mm/memcontrol.c~a
> +++ a/mm/memcontrol.c
> @@ -810,6 +810,8 @@ static inline struct mem_cgroup *get_non
>   	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>   		return memcg;
>   
> +	current->foo = 1;
> +
>   	rcu_read_lock();
>   
>   	while (memcg_is_dying(memcg))
> @@ -820,9 +822,11 @@ static inline struct mem_cgroup *get_non
>   
>   static inline void get_non_dying_memcg_end(void)
>   {
> -	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +	if (current->foo == 0)
>   		return;
>   
> +	current->foo = 0;
> +
>   	rcu_read_unlock();
>   }
>   #else
> _
> 
> That doesn't work if get_non_dying_memcg_start/get_non_dying_memcg_end
> calls can nest?  If they can nest then we'd need a counter in the
> task_struct.



> 


