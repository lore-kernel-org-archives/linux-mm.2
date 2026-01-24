Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15C74D715C4
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 11:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5906B05B5; Sat, 24 Jan 2026 06:56:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353E66B05B6; Sat, 24 Jan 2026 06:56:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25F8A6B05B7; Sat, 24 Jan 2026 06:56:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 129F66B05B5
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 06:56:23 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 15F5B8ADDC
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 11:56:22 +0000 (UTC)
X-FDA: 84366704604.11.34649EC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 167631A0003
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 11:56:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769255780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0G12KZIK+mzO+ysjyJLj74DLyCOd+TlB9Crxj/Oh7SA=;
	b=53+pnJNPmWziZO+OgiYzYPU56ByI/6RQEpYwmKBxWdxLaiKrUE/BWGx80XK0sPKmWxDqJR
	juMd2ARewkWIXDf1Rl4ZlahlrlObvfM6edPRuJ45WAe4Si857ZCoUN6jFF2MU02QBPJC94
	GhrF6TTFpkLlg+owvEMCklz23yMXJLM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769255780; a=rsa-sha256;
	cv=none;
	b=l9jeTH4u/3QpO+xL0KLAxwkp1D9zHQP7gErZnYkCNkDakhZst1BhVDKLnSxxJaYsIMTTAJ
	yqr99MTkNmuzXOfo5PDrE5FY1DuqAo2eCdITh2pF6nXIPS1tKruLalfsh7/oGJykdGC1jS
	NYmY9+oLrUJFKaoeQ9I7wXuxeQXqCNg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8117C150C;
	Sat, 24 Jan 2026 03:56:12 -0800 (PST)
Received: from [10.163.130.81] (unknown [10.163.130.81])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5512F3F632;
	Sat, 24 Jan 2026 03:56:14 -0800 (PST)
Message-ID: <fa408e3e-36d6-4993-813f-3de4264c6b03@arm.com>
Date: Sat, 24 Jan 2026 17:26:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 5/5] mm/khugepaged: make khugepaged_collapse_control
 static
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Garg, Shivank" <shivankg@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Wei Yang <richard.weiyang@gmail.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>
References: <20260118192253.9263-4-shivankg@amd.com>
 <20260118192253.9263-14-shivankg@amd.com>
 <6486c6dd-2702-4a4d-9662-09639532ce6f@arm.com>
 <afc56f8f-0c22-4bac-a99b-b46df346334d@arm.com>
 <ba4502f7-0c35-460e-a42c-d32dea9ab9eb@amd.com>
 <50da84da-1cd6-4b8b-babd-b6dea405713b@lucifer.local>
 <94c84a3c-8ed9-4bb5-8e64-69bcb8306aba@arm.com>
 <7ac06a41-73c8-4089-873e-7bb4cc1b3e02@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <7ac06a41-73c8-4089-873e-7bb4cc1b3e02@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 167631A0003
X-Rspamd-Server: rspam07
X-Stat-Signature: g3fsmebdasg44qxhc6d9zw8at9tsd4oy
X-HE-Tag: 1769255779-725311
X-HE-Meta: U2FsdGVkX1+0ULyAUgzwJIXqtOw8Jx2zIVxvtjq3oNzXlbG0ss9mqT0ebCxNK1A9q9VF5pXBMQH2oWVbeuIlyE4IoQpAdyQYIVkmLRXRz+0d87zyvhFIeAXiqV55fcrZpjs0Je1PqCXW0Psb2kiBCbg37HhdxeygGopYKBQUMW6sH3IRLm/rs/BCpJPojXKpu+R/y5xg2FN6/YtBG6j/r7WYyV3ppwWCpVDJSInYqpmQjxaQ9XuP6JZR2D4LvhgdNLE8Tg7Qz66JwnUon4DJtt+2YyYxjKVcurmEJ+XX4SSGlczjur9e51rtGWK37URGSZ1BHu+FnfBI6SOXFw+roxxLsO5tXYSEedg5hzkmFoP62XxJc2vUvgOvuEwJMdImhJafSDCoJI3qEZpZdoeU0ID2XJhlLC7DCmCHLHzDfJuVhvXKoMo9upLHnLwA09ET+oPgpZqW3Iq7M/qG3SGBbTSb3UrZYIz9lvsdASl3RDebGVwVauhFgfgRAC4DPshIu7i5wAo6sjphQsODlFhOs4RSXo5YKa8J4MR8JsqiDcc1Fhj9XWiljVOjt4NWVSMtjRjAHky9wRgY1iVHQ042vRTmBHIhhpaYNCpwA0w7f7y6thHVbG0USTHoxBV4NFP9eiCm03+CUHNdsWFlYD7ykkVSUdcJx5BlWhUYr4WR18gBrdipH9R3Q0U65mzMxymSaix3gwwF9o1SLYzK2G+nKzPkelr9A9VovtXOtrjDdI/meSZ45/0BtnFhqkfRofeNILvOqFtgiirmoBBsNwA5UJ6fPKIs+vD5d5dfwtHbyxyTKJflIUM6CrLpSZe7CzTT6xgoZogvxc8VS6l5RK6Rb/WJQbmd+hV9E1nz+efuT+A+c7V0mB+/OQI8mvHIQB3OKlRRRYrBcVQ1y5bgYGVHCfEATAFve9LxLUNDDHUlKx5MBqdrfP2TPg96/HmQSbrQ2z+/1T8A5ODJhs7VmO9
 mFbMCtS+
 Urmjrb00DqUswR7wnC/iF4uz+gIGOj2Si58vTYojbV67eyA6GePBRTqW08rvdYgAFdy4SQ4bChtzu4MpRnlISAvaci8b1cfVl7pk7jG8atI1wZlWSxH0W7TqDmfg3KX49D8JQV6BT/q54B57swdiRIpYYc15ZE1KM1ZaKFsd3eSoQV2CRF7rXfEil9jXxn3raEYKfNlaZeTqunmYIpMP0K2biVgColl1WQRjHVX6xhnOkGqAv+YiiF/QH+u1vfwEXNK521ijct97ALDHZBMGpJw6zBU0bJD10K5jjdwz5+XNrlH6fWQfUpB06vlnOzlHVQAk8z2bNJMkAuh/MkShWVFyh7Y6yrxbDABwL9NWBqlkN3gzLUnZlQo2WSphFa8jH7xAgH9rBcmXZcL9un2+5AjB0CnDi3fDuGk4YWegNZ/k5gz+rcHn2yuzfcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 24/01/26 5:10 pm, Lorenzo Stoakes wrote:
> On Sat, Jan 24, 2026 at 04:24:24PM +0530, Dev Jain wrote:
>> On 24/01/26 2:31 pm, Lorenzo Stoakes wrote:
>>> NAK to this change....
>>>
>>> On Fri, Jan 23, 2026 at 03:03:58PM +0530, Garg, Shivank wrote:
>>>> On 1/23/2026 1:18 PM, Dev Jain wrote:
>>>>> On 22/01/26 2:58 pm, Dev Jain wrote:
>>>>>> On 19/01/26 12:53 am, Shivank Garg wrote:
>>>>>>> The global variable 'khugepaged_collapse_control' is not used outside of
>>>>>>> mm/khugepaged.c. Make it static to limit its scope.
>>>>>>>
>>>>>>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>>>>>> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>>>>>>> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>>>>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>>>>>> ---
>>>>>>>  mm/khugepaged.c | 2 +-
>>>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>>>> index 1667abae6d8d..fba6aea5bea6 100644
>>>>>>> --- a/mm/khugepaged.c
>>>>>>> +++ b/mm/khugepaged.c
>>>>>>> @@ -827,7 +827,7 @@ static void khugepaged_alloc_sleep(void)
>>>>>>>  	remove_wait_queue(&khugepaged_wait, &wait);
>>>>>>>  }
>>>>>>>
>>>>>>> -struct collapse_control khugepaged_collapse_control = {
>>>>>>> +static struct collapse_control khugepaged_collapse_control = {
>>>>>>>  	.is_khugepaged = true,
>>>>>>>  };
>>>>>>>
>>>>>> Will it not be better to just remove this variable? In madvise_collapse,
>>>>>> we defined cc as a local variable and set .is_khugepaged = false. The
>>>>>> same can be done in int khugepaged() - define a local variable and set
>>>>>> .is_khugepaged = true.
>>>>> Since this patch has been stabilized already by 4 R-bs, it may be a headache
>>>>> to now remove this, we can do my suggestion later.
>>>>>
>>>>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>>>>>
>>>> Thank you Dev for the feedback and review.
>>>>
>>>> I've attached the patch implementing your suggestion and sending this as a separate
>>>> follow-up to avoid disrupting the current series.
>>>>
>>>> I’m happy to queue it for next cycle or if it’s acceptable now, please take it.
>>>>
>>>> Thanks for the suggestion!
>>>>
>>>> Regards,
>>>> Shivank
>>>>
>>>> ---
>>>> From: Shivank Garg <shivankg@amd.com>
>>>> Date: Thu, 22 Jan 2026 12:36:28 +0000
>>>> Subject: [PATCH] mm/khugepaged: convert khugepaged_collapse_control to local
>>>>  variable in khugepaged()
>>>>
>>>> Make khugepaged_collapse_control a local variable in khugepaged() instead
>>>> of static global, consistent with how madvise_collapse() handles its
>>>> collapse_control. Static storage is unnecessary here as node_load and
>>>> alloc_nmask are reset per-VMA during scanning.
>>>>
>>>> No functional change.
>>>>
>>>> Suggested-by: Dev Jain <dev.jain@arm.com>
>>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>>> ---
>>>>  mm/khugepaged.c | 9 ++++-----
>>>>  1 file changed, 4 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index 9f790ec34400..c18d2ce639b1 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -829,10 +829,6 @@ static void khugepaged_alloc_sleep(void)
>>>>  	remove_wait_queue(&khugepaged_wait, &wait);
>>>>  }
>>>>
>>>> -static struct collapse_control khugepaged_collapse_control = {
>>>> -	.is_khugepaged = true,
>>>> -};
>>>> -
>>>>  static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
>>>>  {
>>>>  	int i;
>>>> @@ -2629,13 +2625,16 @@ static void khugepaged_wait_work(void)
>>>>
>>>>  static int khugepaged(void *none)
>>>>  {
>>>> +	struct collapse_control cc = {
>>>> +		.is_khugepaged = true,
>>>> +	};
>>>>  	struct mm_slot *slot;
>>>>
>>>>  	set_freezable();
>>>>  	set_user_nice(current, MAX_NICE);
>>>>
>>>>  	while (!kthread_should_stop()) {
>>>> -		khugepaged_do_scan(&khugepaged_collapse_control);
>>>> +		khugepaged_do_scan(&cc);
>>>>  		khugepaged_wait_work();
>>>>  	}
>>>>
>>>> --
>>>> 2.43.0
>>>>
>>>>
>>>>
>>>>
>>> Andrew's already commented but this is terribly mistaken.
>>>
>>> The argument against it (why did nobody check...) is that this struct is HUGE
>>> and there's really no benefit to doing this.
>>>
>>> Nico's series makes this struct even bigger (...!)
>>>
>>> Dev - PLEASE use pahole or sizeof(...) or something before suggesting moving
>>> things like this on to the stack, in future e.g.:
>>>
>>> $ pahole collapse_control
>>> struct collapse_control {
>>> 	bool                       is_khugepaged;        /*     0     1 */
>>>
>>> 	/* XXX 3 bytes hole, try to pack */
>>>
>>> 	u32                        node_load[1024];      /*     4  4096 */
>>>
>>> 	/* XXX 4 bytes hole, try to pack */
>>>
>>> 	/* --- cacheline 64 boundary (4096 bytes) was 8 bytes ago --- */
>>> 	nodemask_t                 alloc_nmask;          /*  4104   128 */
>>>
>>> 	/* size: 4232, cachelines: 67, members: 3 */
>>> 	/* sum members: 4225, holes: 2, sum holes: 7 */
>>> 	/* last cacheline: 8 bytes */
>>> };
>>>
>>> Making this static was fine. Leave it as-is.
>> I wasn't suggesting that! When I said
>>
>> "In madvise_collapse, we defined cc as a local variable and set .is_khugepaged = false. The
>> same can be done in int khugepaged() - define a local variable and set .is_khugepaged = true."
> Yeah I would suggest more precision in your language in future :) 'as a local
> variable' and set . not -> is_khugepaged true... I can see why Shivank
> interpreted it at as a stack variable.
>
>> madvise_collapse does kmalloc() to allocate this large struct. I was suggesting to do the
>> same for khugepaged, to enforce consistency.
> As I said in reply to Andrew, NAK to the kmalloc idea too.
>
> This consistency argument is nonsense, madvise_collapse() does that because
> _there can be multiple instances_ of the cc around for different processes, you
> literally _have_ to kmalloc there.

Ah yes nice observation : ) Thanks.

>
> For khugepaged this isn't the case. We're good as we are.
>
> Thanks, Lorenzo

