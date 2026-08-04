Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB39EC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E177D6B00AF; Tue,  4 Aug 2026 00:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEEF96B00B3; Tue,  4 Aug 2026 00:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30566B00B5; Tue,  4 Aug 2026 00:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADBD06B00AF
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:14:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B210040734
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:14:03 +0000 (UTC)
X-FDA: 85062269166.03.56B1016
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8B4B640005
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:14:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kzDwUarm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785816842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2TYt7/NXCNfbzYI+3NGISTe3bg1kbYgcSnqzrzdlGnk=;
	b=cd99PkDbLrPlT8vY6y0ARcwIoJ8aj08HcgKFoMuMU7NvcRwG+FN/tzEotU4I8YR0zexo3W
	4TUTimtLDlQ32RpVwbFMjMPjSNkCkP9W23eoG4T4Lw1b1wEy9jH2sCVLrI4eTCDZ0EtEvn
	G2NQf+hLNWQbrvpNCH8EVJTN4pa4KMI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kzDwUarm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785816842;
	b=rOMXnwrL0aAjJzPn2PNbImVPRDENL+WmchgRweKaQStP6dgU7oENkRbcE/F/YuWrLJhaJA
	t0jnw2s7AjIGxcqghcfrWPE9c5keB/84Jfz3lftMdFLkb1Z6990G7ZIeE2bO/7NsPgdSPa
	6i1uu/WIG46xFBuC8vKKBIKHWVylfrM=
Message-ID: <7e71f6d4-7bc9-449c-a122-49f0e8397150@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785813487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2TYt7/NXCNfbzYI+3NGISTe3bg1kbYgcSnqzrzdlGnk=;
	b=kzDwUarmgBcrC001qK2OiyEX3bI9pMpBTJYaF8KZYpwVs791J9xF9rP4lCDnjQDNllPuJb
	itVJ5XQEOEIFCWnxBLh6cA3O9IUxUTcHBhHr7QCeUnEmmAg8aQrSvtWwFWHkRwmvJ+8K5f
	0R07ZWmLYHS06GnhUrFg3jLhOexpnrs=
Date: Tue, 4 Aug 2026 11:17:58 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3] alloc_tag: expose profiling and compression states
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <d635115cfafcd35c8e3344b418acb1020aba1052.1785794035.git.abhishekbapat@google.com>
 <0b95c0df-8cf6-4ad9-9552-d7c4a657a25c@linux.dev>
Content-Language: en-US
In-Reply-To: <0b95c0df-8cf6-4ad9-9552-d7c4a657a25c@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8B4B640005
X-Stat-Signature: ni6314jx634xopj79be3gindnosdnpt5
X-Rspam-User: 
X-HE-Tag: 1785816841-18974
X-HE-Meta: U2FsdGVkX1+d5JmmKJ8SebHe0GnhlGhPY/lNy+vp9BLzLxVdwHWAhNoqtU2FER+zt1uiA6GRh8ZLilDUpBeLiINxcURg9WBSiVHVgyt9EYbtAakdta7ubF7wFXP3T72Yyo/uIFkBTkvMTaeMMVRmL9dEkUdSQ3+CFZcFerdQ+k7FpUe4BuEyC4E09f41oy1vgshq/uVP2BehrhNVCifhXKXzTh0el3+XfHJO1iKIil2WkFJQNgl8MdRMXqoRQaRPXAWwi5tzUg41Tn9B0RsLRBDlhrz1f+tUoTb5OLWfQn0l/OXd8ViWbnxHlnLT8KGq9HkeHYcSxzM2XQ3jM+H6xk4z+QcGyhyMWAbGSPyK5Om6RzZplbTgF9JnwcZjpkY62YLGSCdkwTLWT8XTrorax1k6ctSRe0OzoalL8Fczd4J2qxjMDRLeZi6n1JKC7eeX3JNaGbOu8UjsdwuiljaneFfyA/2MIbvdf6KlmNTDSz66pygbTo+Gq8hvZfboyNMxZglg3PEd32cLAcKguR9ctZeh5NUedjiKHxNa2J+pRkfvKu99KXQWCyTVRJMjO0oxKYbfUiNUIAr2e/cFvyMSpHguBzR2L2tBLwOH4Swt7uEi9h5cUY1zMaDWm/r6fX1YsD1guSprAdbEeF8atzmPBomQ8wsogPvHpMhlfAySOvvtLMeq26Uds4YOms6p1bl5ixIcX5de+G8CNuFa/PcRyXY7Iy04BoaCPGZRPT+e/j0r/fAKAOCu/VoJeShbRg997Jjjtm8rFfa7yD+D3Giw19hwoVTgIfWF72499hj20kWj2NnVg4R1bRCJFvQUqK1B8ctZDmhH8G5ZiyQc/SJHA4ZhlxEoWtReZjkI2mXRwHD0KIw4wrItbp/imkuL6vHDu0pPgt3Log3+8bzaJi6mhv5tA1P79MGB3VOPoir2mu1gDOV8lYGoPEIZ29vxdoBB6D/k/lMVb1qjjl9yehG
 jpEKNw59
 2/9VZD6ALroxLwlLrTPN+RDphFEGE1NXjw5PgxiZXwQIIZVJg498DttkdlPcyqWEEjtFAv/5psdR8inn5lJXq4N3DnwAVW7tgspbxUKeGslGNMb0VN/zmlYm67Clu+IJdweGNGJu3T1S22A3yn+pbd2JYJ0Ab6Eh0SR5Ku9wUdnh8USIAayB0yfP6Bzv/uYHicPWecejpdJ8VAM5wh0MXnS63VnLlLWbYtjo9Ut56jhwhY4uOkHtoivqNXhJGQ6pXm2Y7jz4PPiLWN1aHQqc5g6092n/YFnM31L5yXPCmrJxixlSKjNepev5ZGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/8/4 10:15, Hao Ge wrote:
> Hi Abhishek
>
>
> Subject says "profiling and compression states", but this
>
> patch only adds the compression sysctl. The profiling state was
>
> already exposed via mem_profiling and is untouched here.
>
> I think we should make this more precise, like:
>
> alloc_tag: expose boot-time compression configuration
>
>
> On 2026/8/4 05:54, Abhishek Bapat wrote:
>> Currently, userspace has limited visibility into the exact active
>> runtime state of memory allocation profiling and its page extension
>> compression ('sysctl.vm.mem_profiling={0|1|never}[,compressed]').
>
>
> Profiling state is already readable via mem_profiling. The gap is
>
> only compression. Also, as we discussed, this sysctl reports
>
> what the user requested at boot rather than the actual runtime state.
>
>
>> While reading the sysctl provides basic on/off status, it is currently
>> impossible for userspace to natively determine whether page-tag
>> compression was successfully enabled without scraping dmesg boot logs.
>>
>> Resolve this ambiguity by exposing the active compression state by
>> adding a new read-only sysctl `vm.mem_profiling_compressed` to output 
>> the
>> state.
>>
>> v3 change:
>> - Added documentation about the behaviour details of the new sysctl.
>>
>> v2 change:
>> - Moved from displaying the state in /proc/allocinfo to a new read-only
>> sysctl.
>
>
> As this is a standalone patch, please put the v2/v3 changelog below 
> the --- line
>
> instead of inside the commit message.
>
>
> Thanks
>
> Best Regards
>
> Hao
>
>
>> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
>> ---
>>   Documentation/mm/allocation-profiling.rst | 13 +++++++++++++
>>   mm/alloc_tag.c                            |  6 ++++++
>>   2 files changed, 19 insertions(+)
>>
>> diff --git a/Documentation/mm/allocation-profiling.rst 
>> b/Documentation/mm/allocation-profiling.rst
>> index c3a28467955f..3ad1e9aacb9a 100644
>> --- a/Documentation/mm/allocation-profiling.rst
>> +++ b/Documentation/mm/allocation-profiling.rst
>> @@ -43,6 +43,19 @@ sysctl:
>>     warnings produced by allocations made while profiling is disabled 
>> and freed
>>     when it's enabled.
>>   +  /proc/sys/vm/mem_profiling_compressed
>> +
>> +  1: Page extension compression is enabled.
>> +
>> +  0: Page extension compression is disabled.
>> +
>> +  This control is read-only and reflects the compression status 
>> initialized at boot.
>> +  Note that, unlike `mem_profiling`, which represents the current 
>> state of profiling,
>> +  `mem_profiling_compressed` represents the state configured at boot 
>> time.


Sorry, I forgot to mention this earlier.

I wonder if we could remove this section:


>> Turning off
>> +  profiling at runtime will implicitly make this sysctl effectively 
>> dormant. However, if
>> +  profiling is toggled off and then toggled on again, it will resume 
>> with compression
>> +  still enabled as long as the value of `mem_profiling_compressed` 
>> is 1.


mem_profiling_compressed only selects the tag storage format (page flags 
vs page_ext).

mem_profiling controls whether allocations are tagged at runtime.

The two are independent: toggling mem_profiling on/off has no effect on

compression. Only shutdown_mem_profiling() tears it down, but by then

the entire allocation profiling subsystem is disabled anyway. There is

no resume path.


>> +
>>   Runtime info:
>>     /proc/allocinfo
>>   diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
>> index 52aece27b00e..877068241f06 100644
>> --- a/mm/alloc_tag.c
>> +++ b/mm/alloc_tag.c
>> @@ -1303,6 +1303,12 @@ static const struct ctl_table 
>> memory_allocation_profiling_sysctls[] = {
>>           .mode        = 0644,
>>           .proc_handler    = proc_mem_profiling_handler,
>>       },
>> +    {
>> +        .procname    = "mem_profiling_compressed",
>> +        .data        = &mem_profiling_compressed,
>> +        .mode        = 0444,
>> +        .proc_handler    = proc_do_static_key,
>> +    },
>>   };
>>     static void __init sysctl_init(void)
>>
>> base-commit: 94f9b3980dd446b56acf1dfed649e9b32a9f3813

