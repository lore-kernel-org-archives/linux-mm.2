Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6014CCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 14:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF4508E0003; Mon, 15 Sep 2025 10:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC4C8E0002; Mon, 15 Sep 2025 10:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09A08E0003; Mon, 15 Sep 2025 10:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F3A98E0002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:27:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 58B2411AA49
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:27:04 +0000 (UTC)
X-FDA: 83891711568.19.96DD0AC
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4E4F98000E
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:27:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RMtWfSvN;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757946422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YAWgOkmD5YFn/glj5ESxRFYtDt9wouSNosBxkMLToC4=;
	b=qjtmSVZy+SKaVsuNg1nKCYct6wACSUqJZVk2IH7QBxUHNgOOr9V+bd0L/miybFiMrmxNfR
	kuD5gBj/90D8RUFnJunbPM0luUs5gnsI+Q2fk2Y2PsK0VMFa75AS73jniA1w2uXx/IVsI6
	1oVg4JdphPivBhtZBMqJZ4Hrruy9rT0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757946422; a=rsa-sha256;
	cv=none;
	b=XxGW3CmIYzivW2KtJQXR6mNoJTQTGjAPyaoR9fLBhM2TKv2beEH9YvhEI4qSBxZz4tw/Dc
	3s3d36MplvMcBJ/L+7PnN4PpEa2L1h2loF2K2xGjrcH3/WwCPjBVGo8gBAR7bY6E6GEmmr
	GNG+LjsZVIJQbLULxIOANUaG9PNBiKg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RMtWfSvN;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <4ee7a430-f92d-409b-89a8-f084605eda98@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757946419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YAWgOkmD5YFn/glj5ESxRFYtDt9wouSNosBxkMLToC4=;
	b=RMtWfSvN2qkTyq23TvknU+5jvUqth0eJ3sjEEUmnn10qqNEr6tx9r+h0yY6RMyv1kCk0r4
	zIyPO366ZYwoY+5zfGRmEq3DkpIg3KMU79RepORdOGYx5bnKvzJ05r4u3mgoznxoLYHDSH
	2oZZ2LDu6Zv8X1czsurKsRzk4EJeSoY=
Date: Mon, 15 Sep 2025 22:26:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 2/3] mm: clean up and expose is_guard_pte_marker()
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Kairui Song <kasong@tencent.com>
References: <20250914143547.27687-1-lance.yang@linux.dev>
 <20250914143547.27687-3-lance.yang@linux.dev>
 <a0133269-82dc-4249-bb78-202b44a4a25e@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <a0133269-82dc-4249-bb78-202b44a4a25e@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4E4F98000E
X-Stat-Signature: kt9pswdwitzz37ri4otgbwx3omeexea6
X-Rspam-User: 
X-HE-Tag: 1757946422-253248
X-HE-Meta: U2FsdGVkX1+ETEeRHMU7pKISyxO0Neag8xMD+2u5FUXA7F9wZ5oAkjPqsH1QADjECgQLGs2gh37WweA/kQdNc+O+hs906N+EIbzdzEtbP++Vswni3MvG6d71o89WI+YZFtGhHeRCNxFdfp5BkH+sIL2yTQVUVQ8Sz+SDDcO2qEwFYSIQZC5f2HckJeS6+BnpeZvhleTI44QDm5JLkB0qYtlgjfW94k3Wy5dGMsouc4s5ki/Z2EQUs10tdxXdvuuhXEs0nMd2Gi7CZ0spOrjrHkOj8h38FAnXtEsRTNsvkSpGsmF0TgN2LLe7hIRS57cd34OwGGJu7t4m0iTKkklQlRMnKEMTrmGL49yJWSIW9dIDsW5LBS4XG1cOo3A+hYRhtLuLN3Wck7TXSiim+np1sL8U/3GgSTI/ByzsewpZc0M9wrpguiacye6CyanAQ6UfFmQMLDCI4oql/SKrPb5bagIyhHqfYAPJfKmZVYWjAKOraSSz5LDPgIpBnYo4xRjfFvy60W7HNLEiahfrUotCE+6SnAo0uH/26boCIrK2J8bdDshUBekI6X6VxrK8/3qiHbtA4FtTxs52D2869gVyiNcfB/vuuTlRgxLbIcRNucUUgFw5gMWuLW6uuyCMAdU6mx7d2uqRIqjJFpeqZbq4UY4Lkol3o5XVQgg+0GpiQfgJPcSeUMtJPesn4xKn9AChAMrYOyCJt7CQCX8t1Ka/LJ0vYXG1yKcgziv72SdINO5Nyz93Mv9TuzGAgyMzzuqw1A7p6b2keG206JW7HZMHNMlT5RyEbw8BgIc6VLiFN07BEXmKzjtFNQS6o7NTKytiz/loEy7KD9uwIneZ1a8EVMcV19LXX9d6ACBniogjX3yEnaqdanhSjKGjUmBarLAI6oC+LT61nw/pPSCYoVBznqBxRdgXe0RkL1zRGdyc8qaSg05l+/HsOo4JGFx6fIrAzu0u/tbeUGRX9b3L86Z
 zV7kSQ46
 XtwqiQspbpH3rUdamfPebQcl5fEk6yxSZn3XzDnyM6dXAsx6trDI4zfemuUaQaRXd3hNzPs1+kQrH7wguLMUA/8GHEs3f7r5E4o+Uh7KmesWjBPYIz84tS/nX8YlB6mSslLTze3BkivPKK4lDgBYPuXdmvdJhS3O3S6L2VyAhGbUs7cggSoBI5mpYOkCUbjtrNgm2oxRGL7xGRPZGlZhzPEXPPakJ+KUVrDCaSeNIEWlBC3SuJa8q3zVgY19RXAMs5TOfTEsjMd0oloIKqOkyv2AuFrzZZPclU/ePi3BzulY78A8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

Thanks for taking time to review!

On 2025/9/15 21:54, Lorenzo Stoakes wrote:
> On Sun, Sep 14, 2025 at 10:35:46PM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> is_guard_pte_marker() performs a redundant check because it calls both
>> is_pte_marker() and is_guard_swp_entry(), both of which internally check
>> for a PTE marker.
>>
>> is_guard_pte_marker()
>>   |- is_pte_marker()
>>   |   `- is_pte_marker_entry()  // First check
>>   `- is_guard_swp_entry()
>>       `- is_pte_marker_entry()  // Second, redundant check
>>
> 
> I mean, it expands to:
> 
> is_swap_pte(pte) && is_pte_marker_entry(pte_to_swp_entry(pte)) &&
> is_pte_marker_entry(pte_to_swp_entry(pte))

Yes, that's a much clearer way to lay it out ;)

> 
> So I don't think it's really unreasonable to expect compiler magic here...
> 
> But you're right that I should have just used is_swap_pte() really, it's a bit
> silly not to, so this is fine :)

Exactly. Glad we're on the same page!

> 
>> While a modern compiler could likely optimize this away, let's have clean
>> code and not rely on it ;)
> 
> Please don't put smileys in commit messages :) as cute as they are, this is
> going on the permanent kernel record and while we all love them, it's
> probably not the best place to put them :P
> 
>>
>> Also, make it available for hugepage collapsing code.
> 
> Nit but put a newline after this.

Got it. Will fix up all nits in v2.

> 
> I think probably if I'm really really nitty I'd say that you should put
> this bit first, as it's the primary motivation for the change, and put the
> refactoring stuff after.

Ah, right. The motivation for exposing the helper should come first. I'll
reorder this changelog in v2.

> 
>> Cc: Kairui Song <kasong@tencent.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> 
> This seems fine to me, so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks,
Lance

> 
>> ---
>>   include/linux/swapops.h | 6 ++++++
>>   mm/madvise.c            | 6 ------
>>   2 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
>> index 59c5889a4d54..7f5684fa043b 100644
>> --- a/include/linux/swapops.h
>> +++ b/include/linux/swapops.h
>> @@ -469,6 +469,12 @@ static inline int is_guard_swp_entry(swp_entry_t entry)
>>   		(pte_marker_get(entry) & PTE_MARKER_GUARD);
>>   }
>>
>> +static inline bool is_guard_pte_marker(pte_t ptent)
>> +{
>> +	return is_swap_pte(ptent) &&
>> +	       is_guard_swp_entry(pte_to_swp_entry(ptent));
>> +}
>> +
>>   /*
>>    * This is a special version to check pte_none() just to cover the case when
>>    * the pte is a pte marker.  It existed because in many cases the pte marker
>> diff --git a/mm/madvise.c b/mm/madvise.c
>> index 35ed4ab0d7c5..bd46e6788fac 100644
>> --- a/mm/madvise.c
>> +++ b/mm/madvise.c
>> @@ -1069,12 +1069,6 @@ static bool is_valid_guard_vma(struct vm_area_struct *vma, bool allow_locked)
>>   	return !(vma->vm_flags & disallowed);
>>   }
>>
>> -static bool is_guard_pte_marker(pte_t ptent)
>> -{
>> -	return is_pte_marker(ptent) &&
>> -		is_guard_swp_entry(pte_to_swp_entry(ptent));
>> -}
>> -
>>   static int guard_install_pud_entry(pud_t *pud, unsigned long addr,
>>   				   unsigned long next, struct mm_walk *walk)
>>   {
>> --
>> 2.49.0
>>


