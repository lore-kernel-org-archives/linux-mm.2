Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A57DFD715E3
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 10:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076516B05AA; Sat, 24 Jan 2026 05:54:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 040956B05AC; Sat, 24 Jan 2026 05:54:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC3336B05AD; Sat, 24 Jan 2026 05:54:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DE1E36B05AA
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 05:54:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85CD71AF7DE
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 10:54:35 +0000 (UTC)
X-FDA: 84366548910.21.292F64D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 55DC4180006
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 10:54:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769252073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fMAwNz0sojOEAi0asUtJ7iAY4xQLEoyU8P+hPSsqP98=;
	b=bkcAVuv/WjSyTeYBy7QPhG5MClL/p8jO6k+99mhIfgj+guoE44p4e44/qPlNGiJpJRjQV0
	COEQnBvs4bDfsp166RcjiqS5BArHrmMgAVrSReb8oiKAlr45vcc3vP4/k9mS4lKpmujxlM
	UFowQAvp1NgbnQL54lelnEmloIx8Mec=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769252073; a=rsa-sha256;
	cv=none;
	b=rZxl9l5mDwIYySyaoxX9CUv3/tpkIEGvsxmF/lPI7s2QRrTtlGLmn0vw6HT6Iz8HKuNk6H
	Qfl17qNuLJfGwUkS+qNFYsc+ITR2Cd3B1YA8A7tr7b3hBA8wpr2zgQ785nvInt6is81BVv
	bKourukAoS24tgUdCLmd38+KHiSYNIc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BC13150C;
	Sat, 24 Jan 2026 02:54:25 -0800 (PST)
Received: from [10.164.10.250] (unknown [10.164.10.250])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B52993F73F;
	Sat, 24 Jan 2026 02:54:27 -0800 (PST)
Message-ID: <94c84a3c-8ed9-4bb5-8e64-69bcb8306aba@arm.com>
Date: Sat, 24 Jan 2026 16:24:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 5/5] mm/khugepaged: make khugepaged_collapse_control
 static
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Garg, Shivank" <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <50da84da-1cd6-4b8b-babd-b6dea405713b@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uhbcsif4nf64stg7cqbiwxuq719sy95k
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 55DC4180006
X-HE-Tag: 1769252073-817670
X-HE-Meta: U2FsdGVkX19yZxNVmKLpgx4LRKyOzum0/GwODrFYah5tHWkGNwUy36VJ2mPgh224d7cQVnyiszVwLRQNjaSkjIv88Loy9ohxch2BeACQJemHTk2C4hXB4j2vlayAj/4Ll+hJLtZOkxdru/U61CyyXEXMG/q6gikUtAwv9iOhYCcR2M2vOVgd3wr3a4r8MApsoiEFSR544b7s4QBNBmiJZPsbPycYs2afmTgoo5rpr8UrU/CDFJA+i/Xw2v6all8TXPodFU/YW/ueWhEzSCTOk/MehKm8KjJVoNitURMZdGk8T5KEqGPmyf8Hz1rnE1opPqbWauc8sFvlfoQAIOagJkL9bwWHJCktE8J2EfALwjG1nvWTgYxqVqftqE7Gn6cgBoYKW516DEwyH7n+AXi97cO45izfgitYSOZRkP+Ju2/ROIjzHmDr6MrfRzP3LowroCEFVakSaJWpnvspcBS4fIpBrqOAlWcamMst83VdIjLq075eqhjJQh4iNO0ga8jU1/QNXeP4W0mYEmBas/rlw4xtyk3uq4/bnwZ2tp2DPl5dALlowVmMjPZxzICq7gSEANgAUfVlBl2lJGbjeglMwKMEq3igLCKPzxtM1Uf9aq9swhz3i3AcUTF2efc97qDSAeRNTE982VLy2dMZZ1slPY8JOfflXOyEdhiAZaQ5jLQq5Dtsci6HHiKDbH1jqW0/ILg4g5+Rzby2a3GXt+abzeQCE+YmMPkk/DgdH4HyMjs800F2eRhLgoUkrHDgJ+YZ07cLNZT+UoWCXYscI0Uwyqg/2c8dgSekiXafKl3/4DW6TERKQ5bo7xBLB8G2u/BWB8hWTOaZXpiTbW85BoWPQ3Vpp/Zm8XkbsaWbLesohYFIKP/gxexMhlI96yWbBKY2zALl0+VQag5ONu7DvVybY9nOXOqLXwrEamLN1t2wQBtULb87EjUAnmWPXUMYnjMAMcl2uzULlSCzngmyKKH
 o7PJ6B69
 Uj37ZNlJYN7MIQxBbFQuBXPb++OBk74niz6BhD+S0b8SfNWIFooor6PWBGw9EMlMKL81q0c1wklU6uS9MmJ50pu2sJEq8qh/yEMV3ZTT26slrzKMT3iL2n4UFKVgQKlqf0MtF6cSm6VCBrYcBuqQOtHTVw27UPqaXST2ozSVzaV6RowRPZL3pL4QiR6Pd0pnOgScW8Q3vF33MgMV3XkfU+eo3Vmapbz4O3Apox0nIMlWtZgJ/cHnl/6oUD1Ji0U99KCZJtRW1KtWUdRaoW0NYznfSfGoGhL7MeXlud4yRB0z8nBs23AFw5P7n8A4sFtQr/pi7X14UFGbt5lERtdPU0KWLC5tlUTPo8tBGtaXMvB6urJMQldovIQe9j26VlLjuORpRwo3QufDNdC5HYSYFQzyTF/B/HkY/fn8tZFwkylTshdevUMnCL2T26A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 24/01/26 2:31 pm, Lorenzo Stoakes wrote:
> NAK to this change....
>
> On Fri, Jan 23, 2026 at 03:03:58PM +0530, Garg, Shivank wrote:
>>
>> On 1/23/2026 1:18 PM, Dev Jain wrote:
>>> On 22/01/26 2:58 pm, Dev Jain wrote:
>>>> On 19/01/26 12:53 am, Shivank Garg wrote:
>>>>> The global variable 'khugepaged_collapse_control' is not used outside of
>>>>> mm/khugepaged.c. Make it static to limit its scope.
>>>>>
>>>>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>>>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>>>> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>>>>> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>>>> ---
>>>>>  mm/khugepaged.c | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>> index 1667abae6d8d..fba6aea5bea6 100644
>>>>> --- a/mm/khugepaged.c
>>>>> +++ b/mm/khugepaged.c
>>>>> @@ -827,7 +827,7 @@ static void khugepaged_alloc_sleep(void)
>>>>>  	remove_wait_queue(&khugepaged_wait, &wait);
>>>>>  }
>>>>>
>>>>> -struct collapse_control khugepaged_collapse_control = {
>>>>> +static struct collapse_control khugepaged_collapse_control = {
>>>>>  	.is_khugepaged = true,
>>>>>  };
>>>>>
>>>> Will it not be better to just remove this variable? In madvise_collapse,
>>>> we defined cc as a local variable and set .is_khugepaged = false. The
>>>> same can be done in int khugepaged() - define a local variable and set
>>>> .is_khugepaged = true.
>>> Since this patch has been stabilized already by 4 R-bs, it may be a headache
>>> to now remove this, we can do my suggestion later.
>>>
>>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>>>
>>>>
>> Thank you Dev for the feedback and review.
>>
>> I've attached the patch implementing your suggestion and sending this as a separate
>> follow-up to avoid disrupting the current series.
>>
>> I’m happy to queue it for next cycle or if it’s acceptable now, please take it.
>>
>> Thanks for the suggestion!
>>
>> Regards,
>> Shivank
>>
>> ---
>> From: Shivank Garg <shivankg@amd.com>
>> Date: Thu, 22 Jan 2026 12:36:28 +0000
>> Subject: [PATCH] mm/khugepaged: convert khugepaged_collapse_control to local
>>  variable in khugepaged()
>>
>> Make khugepaged_collapse_control a local variable in khugepaged() instead
>> of static global, consistent with how madvise_collapse() handles its
>> collapse_control. Static storage is unnecessary here as node_load and
>> alloc_nmask are reset per-VMA during scanning.
>>
>> No functional change.
>>
>> Suggested-by: Dev Jain <dev.jain@arm.com>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>>  mm/khugepaged.c | 9 ++++-----
>>  1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 9f790ec34400..c18d2ce639b1 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -829,10 +829,6 @@ static void khugepaged_alloc_sleep(void)
>>  	remove_wait_queue(&khugepaged_wait, &wait);
>>  }
>>
>> -static struct collapse_control khugepaged_collapse_control = {
>> -	.is_khugepaged = true,
>> -};
>> -
>>  static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
>>  {
>>  	int i;
>> @@ -2629,13 +2625,16 @@ static void khugepaged_wait_work(void)
>>
>>  static int khugepaged(void *none)
>>  {
>> +	struct collapse_control cc = {
>> +		.is_khugepaged = true,
>> +	};
>>  	struct mm_slot *slot;
>>
>>  	set_freezable();
>>  	set_user_nice(current, MAX_NICE);
>>
>>  	while (!kthread_should_stop()) {
>> -		khugepaged_do_scan(&khugepaged_collapse_control);
>> +		khugepaged_do_scan(&cc);
>>  		khugepaged_wait_work();
>>  	}
>>
>> --
>> 2.43.0
>>
>>
>>
>>
> Andrew's already commented but this is terribly mistaken.
>
> The argument against it (why did nobody check...) is that this struct is HUGE
> and there's really no benefit to doing this.
>
> Nico's series makes this struct even bigger (...!)
>
> Dev - PLEASE use pahole or sizeof(...) or something before suggesting moving
> things like this on to the stack, in future e.g.:
>
> $ pahole collapse_control
> struct collapse_control {
> 	bool                       is_khugepaged;        /*     0     1 */
>
> 	/* XXX 3 bytes hole, try to pack */
>
> 	u32                        node_load[1024];      /*     4  4096 */
>
> 	/* XXX 4 bytes hole, try to pack */
>
> 	/* --- cacheline 64 boundary (4096 bytes) was 8 bytes ago --- */
> 	nodemask_t                 alloc_nmask;          /*  4104   128 */
>
> 	/* size: 4232, cachelines: 67, members: 3 */
> 	/* sum members: 4225, holes: 2, sum holes: 7 */
> 	/* last cacheline: 8 bytes */
> };
>
> Making this static was fine. Leave it as-is.

I wasn't suggesting that! When I said

"In madvise_collapse, we defined cc as a local variable and set .is_khugepaged = false. The
same can be done in int khugepaged() - define a local variable and set .is_khugepaged = true."

madvise_collapse does kmalloc() to allocate this large struct. I was suggesting to do the
same for khugepaged, to enforce consistency.

>
> Thanks, Lorenzo

