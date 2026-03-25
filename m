Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF008FEA82F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 07:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECE6F6B0098; Wed, 25 Mar 2026 03:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7F046B0099; Wed, 25 Mar 2026 03:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6E426B009B; Wed, 25 Mar 2026 03:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C244B6B0098
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:40:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 856F41607DD
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:40:25 +0000 (UTC)
X-FDA: 84583787610.30.6BB47C2
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id B762B8000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:40:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gXtG5BnY;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774424424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B0CLR6YbY6BbPn5BbvUeaUgxF//HUlX85mhdlERM2EU=;
	b=K9gIpAmuxXsyx30wDacvSH8q8y9PoSB1cG9iayTrigoX7AC4QIHvPT514Tx/PuTzisxNjN
	MvRDchQ357LBNd+xZiEtJp72hs9ux8/GEM1jB5rGCB4M44vYksZp8NlbzsqnhBAgaGCmLm
	K6eBPBhOP45whfSfMTH5WxsuX9wNazs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gXtG5BnY;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774424424; a=rsa-sha256;
	cv=none;
	b=0ogtOGkbz3IQx1E/kRRF+cXX4LEfqIudqvi8vP+Fe7uEPHRnG1OTw5/u0YxFcYCJ9y58rH
	tTnGZLyJG3JRdWkJPZmKH0NR3YCVoHDUwyFRrnbiNxmNXT99owWuh+dO8U1HaH2cTgrFtq
	k6QNoLWjWyMYqpX6TbX4wrKAmCSPUco=
Message-ID: <5fed0611-434c-4fd4-956c-39f23e0459a1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774424421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B0CLR6YbY6BbPn5BbvUeaUgxF//HUlX85mhdlERM2EU=;
	b=gXtG5BnYmoxr+q9PJgyyvvbmG2Y7X3JRDmYJ6pwDIdQW+l2WQjQHq+YR4OeDKfJQvgrutJ
	rnQrPUSNZo0i//tEs4OKF2kK2m3UlvTKo1dLwCAxV228fWFN0LvtrwSC/HcVVujH/ndpSr
	itpv6UhpawYGqJhloWmooFazaaFOXMY=
Date: Wed, 25 Mar 2026 15:39:56 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] mm: memcontrol: correct the parameter type of
 __mod_memcg{_lruvec}_state()
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
 <90524ca3806e24105ab5f2d69435f57c2ae034cb.1774342371.git.zhengqi.arch@bytedance.com>
 <acM93qmvDFofjWdM@hyeyoo> <5a9d9152-8e23-4438-a322-ec524fd159a6@linux.dev>
 <acNv8w-xNWwZHVo9@hyeyoo> <d86749f2-c4fb-4c7f-b630-27fca222066c@linux.dev>
 <acOQkTDJvieu3sh-@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <acOQkTDJvieu3sh-@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B762B8000B
X-Stat-Signature: z7dica8381nr9ryy476jpde8nr3ekpe3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774424423-187031
X-HE-Meta: U2FsdGVkX1/3TAgAnp9G5dPw2s1rcH+GOLxgc1rNA7Fr80PtAnW4SGB4OyszPXIw0WGm7mM1sW9dOEj23yACIDaTS0NtcGYEyh1H/+jezORlu73wZqIboQDmalaaaPnYnp7LRKcs3d/clFqmxy/IYultWp4zzrl9L/OIPWK0X4fpCWlVQm+tnb633/l2cz03wZUmgZppXrh6jOPLGRe1KTkrOsK1uydzF25l5bduEuyvGKqXHS2OY+oSnurGSIytaLNtvP25BXSVnLyN3t34fVpm8jfpE0DAQUlQP6hZA7DF/BYVV9YhjielGHBL0NYuDKJrN93gKA5oSC678FCRFffmDtWA6dk+6coH+s6Q+C6JJ+c3YZuvvNYbGykqlsQRu2u1O8rFNVnvszpfM6WVTfGxtk1uNqcGpwbYSwyxgKtS/wSex49cYmqiVSdvAtPclo0HOat3odrR57tdsfCWxZSPPUPhvmXmuKahhvk1nONJqCEn2XGI5lNpc1yB8v8unbOlbqJ/fiAguVwaQiVxN275vV/ZaAVL87xd3uWW4iFVA5j2iD6UQOJX3ATwdBMzOgWemYVWcVJCw6jp8g/HnRVGHlikXZ+0nhbwnFbCv4duJAC0drndckSaZTjUHrAMxrd4BppW+SEKt8uTXp9GSs03po4c6NrKYjX+hFVR+aMlHQpOvOe4w2BKfYRP4qjQQkg57riJYql/CC/aDehj2OedsxCFh0WCWJTb63jmFo9EXaHpCDUyymd1fdoLTn+nEbWRUf7nXMPYBmvH7EZQ2G0+2EnlqPm4rO5tV/yr2+tcx9U2Byau0bpR0BF5bX1OHSFH9GSDocnhZhltF0V/8TUIMkCJaBpLCXessp4pPkYmAcUN7Y0a67SU1t3pkl/gxp3Uqw/Kck1SjBR/4gFhpqHyF3Owlo2EbAJh8dK1kevUO/VKAvUMFYU/KsKHe0iIWg877h8rJ0yiOc6lTB2
 /Zc59kny
 DDSvsUj5dxrgy4/6lT4UYAO+hPTggX9ZBM+H35C3mjOaxnDvEviUfH2YRGIPAqmqhNmy6cskKsyuRnQS0zk2BEeMIH1Ap46CCqs0z4ikiWbCf2LirB8zeN6IDRlyQx4Fm1W11LSifwQT+4frzJsj5wUpTsrBB/hodaBFY/FdCn8JdFV6zXe6+9/SvEzMvwuVlPCefrVv5ZFgQhQEADuiAsvvxp02bQ2Uym3VcKnPu87P+QCX88gYCfNQENekBhLSc6N7WO9xixcaHpnUdHf0+AJxUakqphH2pW1xBMzKY8Eckq4SPfCURqUcnicejdI2638zNkrq31ylXSEcxamB5GCJPYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/25/26 3:36 PM, Harry Yoo (Oracle) wrote:
> On Wed, Mar 25, 2026 at 03:26:46PM +0800, Qi Zheng wrote:
>>
>>
>> On 3/25/26 1:17 PM, Harry Yoo (Oracle) wrote:
>>> On Wed, Mar 25, 2026 at 11:25:06AM +0800, Qi Zheng wrote:
>>>> On 3/25/26 9:43 AM, Harry Yoo (Oracle) wrote:
>>>>> On Tue, Mar 24, 2026 at 07:31:28PM +0800, Qi Zheng wrote:
>>>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>>
>>>>>> The __mod_memcg_state() and __mod_memcg_lruvec_state() were used to
>>>>>> reparent non-hierarchical stats, the values passed to them might exceed
>>>>>> the upper limit of the type int, so correct the val parameter type of them
>>>>>> to long.
>>>>>>
>>>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>> ---
>>>>>>     include/trace/events/memcg.h | 10 +++++-----
>>>>>>     mm/memcontrol.c              |  8 ++++----
>>>>>>     2 files changed, 9 insertions(+), 9 deletions(-)
>>>>>>
>>>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>>>> index 7fb9cbc10dfbb..4a78550f6174e 100644
>>>>>> --- a/mm/memcontrol.c
>>>>>> +++ b/mm/memcontrol.c
>>>>>> @@ -527,7 +527,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>>>>>>     #ifdef CONFIG_MEMCG_V1
>>>>>>     static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
>>>>>> -				     enum node_stat_item idx, int val);
>>>>>> +				     enum node_stat_item idx, long val);
>>>>>>     void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>>>>>>     				       struct mem_cgroup *parent, int idx)
>>>>>> @@ -784,7 +784,7 @@ static int memcg_page_state_unit(int item);
>>>>>>      * Normalize the value passed into memcg_rstat_updated() to be in pages. Round
>>>>>>      * up non-zero sub-page updates to 1 page as zero page updates are ignored.
>>>>>>      */
>>>>>> -static int memcg_state_val_in_pages(int idx, int val)
>>>>>> +static long memcg_state_val_in_pages(int idx, long val)
>>>>>>     {
>>>>>>     	int unit = memcg_page_state_unit(idx);
>>>>>
>>>>> Sashiko AI made an interesting argument [1] that this could lead to
>>>>> incorrectly returning a very large positive number. Let me verify that.
>>>>>
>>>>> [1] https://sashiko.dev/#/patchset/cover.1774342371.git.zhengqi.arch%40bytedance.com
>>>>>
>>>>> Sashiko wrote:
>>>>>> Does this change inadvertently break the handling of negative byte-sized
>>>>>> updates?
>>>>>> Looking at the rest of the function:
>>>>>> 	if (!val || unit == PAGE_SIZE)
>>>>>> 		return val;
>>>>>> 	else
>>>>>> 		return max(val * unit / PAGE_SIZE, 1UL);
>>>>>
>>>>>> PAGE_SIZE is defined as an unsigned long.
>>>>>
>>>>> Right, it's defined as 1UL << PAGE_SHIFT.
>>>>>
>>>>>> When val is negative, such as during uncharging of byte-sized stats like
>>>>>> MEMCG_ZSWAP_B, the expression val * unit is a negative long.
>>>>>
>>>>> Right.
>>>>>
>>>>>> Dividing a signed long by an unsigned long causes the signed long to be
>>>>>> promoted to unsigned before division,
>>>>>
>>>>> Right.
>>>>>
>>>>>> resulting in a massive positive
>>>>>> number instead of a small negative one.
>>>>>
>>>>> Let's look at an example (assuming unit is 1).
>>>>>
>>>>> val = val * unit = -16384 (-16 KiB)
>>>>> val * unit / PAGE_SIZE = 0xFFFFFFFFFFFFC000 / PAGE_SIZE = 0x3FFFFFFFFFFFFF
>>>>> max(0x3FFFFFFFFFFFFF, 1UL) = 0x3FFFFFFFFFF
>>>>>
>>>>> Yeah, that's a massive positive number.
>>>>>
>>>>> Hmm but how did it work when it was int?
>>>>>
>>>>> val = val * unit = -16384 (-16KiB)
>>>>> val * unit / PAGE_SIZE = 0xFFFFFFFFFFFFC000 / PAGE_SIZE = 0x3FFFFFFFFFFFFF
>>>>> max(val * unit / PAGE_SIZE, 1UL) = 0x3FFFFFFFFFFFFF
>>>>> (int)0x3FFFFFFFFFFFFF = 0xFFFFFFFF = (-1)
>>>>>
>>>>> That's incorrect. It should have been -4?
>>>>>
>>>>>> Before this change, the function returned an int, which implicitly truncated
>>>>>> the massive unsigned 64-bit result to a 32-bit int, accidentally yielding the
>>>>>> correct negative arithmetic value.
>>>>>
>>>>> So... "accidentally yielding the correct negative arithemetic value"
>>>>> is wrong.
>>>>>
>>>>> Sounds like it's been subtly broken even before this patch and nobody
>>>>> noticed.
>>>>
>>>> Thank you for such a detailed analysis! And I think you are right.
>>>
>>> No problem ;)
>>>
>>>> The memcg_state_val_in_pages() is only to make @val to be in pages, so
>>>> perhaps we can avoid the above problem by taking the absolute value
>>>> first?
>>
>> For more clearly, here is the diff:
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 6491ca74b3398..2b34805b01476 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -787,11 +787,17 @@ static int memcg_page_state_unit(int item);
>>   static long memcg_state_val_in_pages(int idx, long val)
>>   {
>>          int unit = memcg_page_state_unit(idx);
>> +       unsigned long uval;
>> +       long res;
>>
>>          if (!val || unit == PAGE_SIZE)
>>                  return val;
>> -       else
>> -               return max(val * unit / PAGE_SIZE, 1UL);
>> +
>> +       uval = val < 0 ? -(unsigned long)val : (unsigned long)val;
> 
> We could use abs() macro in linux/math.h here :)
> 
> val should not be LONG_MIN, but it should be fine
> to assume it won't reach LONG_MIN.

OK, will use abs() macro.

> 
>> +
>> +       res = max(mult_frac(uval, unit, PAGE_SIZE), 1UL);
>> +
>> +       return val < 0 ? -res : res;
>>   }
>>
>>   #ifdef CONFIG_MEMCG_V1
>>
>>> That would work for memcg_rstat_updated(),
>>> but not for trace_mod_memcg_state()?
>>
>> Why? The trace_mod_memcg_state() seems to accept 'long' type,
>> am I missing something?
> 
> Nevermind. Without the diff, I misunderstood what you meant.

OK, will apply this diff and send the v2.

Thanks,
Qi

> 
> Thanks!
> 


