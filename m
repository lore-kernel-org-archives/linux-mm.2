Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5BBD1093170
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C5916B042F; Thu, 19 Mar 2026 23:18:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69CB96B0432; Thu, 19 Mar 2026 23:18:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B2666B0433; Thu, 19 Mar 2026 23:18:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8F06B042F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:18:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0378213BA30
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:18:43 +0000 (UTC)
X-FDA: 84564984168.08.0737794
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf17.hostedemail.com (Postfix) with ESMTP id D49784000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:18:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MAN43k5j;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773976722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=verEAb8WxJ+vPtV/pZpgjW0L13vr5gbh+nX57J5s9lM=;
	b=jJ5raGx/bP51HloU69ndrNmKB6vrzkAoCkXWOVc8cmhupVtKAnHr5LDlbDmRTJ1twgHolg
	AspKoYg2JCRDyd2M3tpOdaxUvE6aSva86Nsdx0zpqNELDiDnG7Px0kdyhdSzMYlEdZK9RU
	rUG/DiAW5t9m8fJgie0vzV/QgVUKCC0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MAN43k5j;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773976722; a=rsa-sha256;
	cv=none;
	b=gROn2bXW7etxjuEpguvQamomAPvvAnUsc6KrWy3c4IJQphtU5mVX0GZAew3QWSNQKCwQEo
	fQ5/qWQeFSZdMpgI7oSWmIJtrssHkwo4yco5KB9sSl8t2JdIwKGg34RqyWyiiBCy5kTWnQ
	if8Ix3g5h4N4Liyxos1TLiBMu09KrOk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773976718; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=verEAb8WxJ+vPtV/pZpgjW0L13vr5gbh+nX57J5s9lM=;
	b=MAN43k5jP+HELA+PqN7vCywQfTbKEdjK4euvozMr8Mt9T+A2z0qLcArNdQ+JjewSU/Psc23Y3/Hm51VHdexdfIm3jCGeM5PxAiH51aS1XPjfPc02FEfZjxGEaTeNATaeg/VkFA9KeeE5v0ts+XXf4TJ31xezAdGIAutjh0adPt8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X.K7m.g_1773976716;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.K7m.g_1773976716 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Mar 2026 11:18:36 +0800
Message-ID: <66e78b59-f96c-4277-b7d7-473b68ed413f@linux.alibaba.com>
Date: Fri, 20 Mar 2026 11:18:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] mm: change to return bool for the MMU notifier's
 young flag check
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
 <545847c132da5d957cfc74ab19e849b16127aa8f.1773890510.git.baolin.wang@linux.alibaba.com>
 <67c670e2-c98f-490b-bbb9-2960f8175b5a@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <67c670e2-c98f-490b-bbb9-2960f8175b5a@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D49784000A
X-Stat-Signature: j9pf8g6bqe1y8nzrofynarbw87xk3b7m
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773976720-16100
X-HE-Meta: U2FsdGVkX18OrXwjmtoGVO17IrhX+0+hLETEpfJ4f3HRX5NtQnkxFvq5t0amHe3EHhd9OT/c6tiSz74mhzl5NVhoV5llxECMDefajvSYO5ZMszzvtaBY2WFM2e3ulnYVU5YKMvgbNBG9NEOh7wNVD28aOhtQBqJZigBnfafoqkkCAsRnk7Okv+juI2/aCPjhvyey+ukw9JkOsLa02Pf3nw+wA++AwRBlSk4Xf2ZUftcFj1uanUF/Dfat73iSVoFoHGacAeq0N+3JKSW+avHq0KKXJ8BJ+9jHmLEdwvpAG8DetCJBFbuLokIE3I09JqXrYPX+9ZD8saAyD7oIPO3qhNbllQR93ia6U5IQbEhkl2yR7DvcxoLN73wNUvtthDL+UllAoWeGX4Wlmg2m5+Vkkq8fSyhcXSR6Qh99ohnMLlAfoV2dTRJB3KhY0sG+YpiUF3MyLwfDrMz68YrqGEROf/Gka1mf/23JDjTgYxZTe09fq6IKZ5w0udSKRsdVmxAFndb6dr2bHLW4ZbrNf8IHjq9896vG3fNZgin3+2wowRvAWfn+9pYoNv/dIJZEnA6befehxLpcxUUa6o5VNpDd4FWw29dmhwr4DHe/NRHBDd+dU9PNmnz5lkZu4gAl67ABQQSDkMxh4LqPxv2iulHK1SMWNXs8ju5v7IwbNVTmz6rkCwiKanmJudT0pLp30oUsTFumnbEBCmsrI+GKNl+BlApAcDQl4dQrWxUaRs/G4psqw9atg6AKC+NKTgALPShnCoPsoR4E9ervNWvJ4M4H4fg0P8zc7Kgou/E8EvtcEys4suYlj+MIGX+qRSkN6poxrahhUGRdlLcI2eYIYyLLBLCNLIwRJtNs161AqGrrpzg5c0uuoxxd5JASr9UuAQrNIKOP8VSlNvR3DSmQVLiwIMJfc3H8fVGSq6Hf3+o7ZmTF7UdD5e9MXIBE1PnnvW1hzoFdW6iGkT4q85eBlVr
 +8bbYNEE
 r/1VgQSj3vFxVB5Say8nvFYrXAKb8kVBA6+zJdFctOXLuFKHfBkQ3A2zRsI+7H2ZiGWVRRGDdbaq3fJFg6RuooDiNVQgmHzu9+0DaSWtq/EStcanXEi4CL0z3bMwWSYymjVO2G9SNOliBmNnj0qR4ujsXuHt8hJurvZB5bEHwBZKE3YPfLod2hPyeQu+TM+6A/CvKnVgjDFlv8dNnNMh0qBYYdfjgz4Azc6BZE5dVpx/QyvHLsq7J1j2zrYFsKwFQZNQGBtBVTTYW8c2jQkkmH67ZckgM+HlIP8zWlLxJdPgFs+Z8TJcGuzWp3RdNZ+pag5bp4yqYMS88OUuQb01gXfQ8bqV/0CTvwDRvmqjSRmXlIGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/19/26 7:39 PM, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 19, 2026 at 11:24:05AM +0800, Baolin Wang wrote:
>> The MMU notifier young flag check related functions only return whether
>> the young flag was set. Change the return type to bool to make the
>> intention clearer.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> I can see KVM is the only user for the mmu_notifier_ops clear_flush_young,
> clear_young and test_young hooks, which map to
> kvm_mmu_notifier_[clear_flush,clear,test]_young() functions, and you have
> updated them all.

Yes.

> So this LGTM with nits below, and so (with nits addressed as per the other R-b
> tags :):
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> 
> Thanks for doing this! Int as bool is a pet peeve of mine :))

Thanks for reviewing.

>>   include/linux/mmu_notifier.h | 76 +++++++++++++++++-------------------
>>   mm/internal.h                | 16 ++++----
>>   mm/mmu_notifier.c            | 20 +++++-----
>>   virt/kvm/kvm_main.c          | 40 +++++++++----------
>>   4 files changed, 72 insertions(+), 80 deletions(-)
>>
>> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
>> index 3705d350c863..17f2cdc77dd5 100644
>> --- a/include/linux/mmu_notifier.h
>> +++ b/include/linux/mmu_notifier.h
>> @@ -97,20 +97,20 @@ struct mmu_notifier_ops {
>>   	 * Start-end is necessary in case the secondary MMU is mapping the page
>>   	 * at a smaller granularity than the primary MMU.
>>   	 */
>> -	int (*clear_flush_young)(struct mmu_notifier *subscription,
>> -				 struct mm_struct *mm,
>> -				 unsigned long start,
>> -				 unsigned long end);
>> +	bool (*clear_flush_young)(struct mmu_notifier *subscription,
>> +				  struct mm_struct *mm,
>> +				  unsigned long start,
>> +				  unsigned long end);
>>
>>   	/*
>>   	 * clear_young is a lightweight version of clear_flush_young. Like the
>>   	 * latter, it is supposed to test-and-clear the young/accessed bitflag
>>   	 * in the secondary pte, but it may omit flushing the secondary tlb.
>>   	 */
>> -	int (*clear_young)(struct mmu_notifier *subscription,
>> -			   struct mm_struct *mm,
>> -			   unsigned long start,
>> -			   unsigned long end);
>> +	bool (*clear_young)(struct mmu_notifier *subscription,
>> +			    struct mm_struct *mm,
>> +			    unsigned long start,
>> +			    unsigned long end);
>>
>>   	/*
>>   	 * test_young is called to check the young/accessed bitflag in
>> @@ -118,9 +118,9 @@ struct mmu_notifier_ops {
>>   	 * frequently used without actually clearing the flag or tearing
>>   	 * down the secondary mapping on the page.
>>   	 */
>> -	int (*test_young)(struct mmu_notifier *subscription,
>> -			  struct mm_struct *mm,
>> -			  unsigned long address);
>> +	bool (*test_young)(struct mmu_notifier *subscription,
>> +			   struct mm_struct *mm,
>> +			   unsigned long address);
>>
>>   	/*
>>   	 * invalidate_range_start() and invalidate_range_end() must be
>> @@ -376,14 +376,12 @@ mmu_interval_check_retry(struct mmu_interval_notifier *interval_sub,
>>
>>   extern void __mmu_notifier_subscriptions_destroy(struct mm_struct *mm);
>>   extern void __mmu_notifier_release(struct mm_struct *mm);
>> -extern int __mmu_notifier_clear_flush_young(struct mm_struct *mm,
>> -					  unsigned long start,
>> -					  unsigned long end);
>> -extern int __mmu_notifier_clear_young(struct mm_struct *mm,
>> -				      unsigned long start,
>> -				      unsigned long end);
>> -extern int __mmu_notifier_test_young(struct mm_struct *mm,
>> -				     unsigned long address);
>> +bool __mmu_notifier_clear_flush_young(struct mm_struct *mm,
>> +		unsigned long start, unsigned long end);
>> +bool __mmu_notifier_clear_young(struct mm_struct *mm,
>> +		unsigned long start, unsigned long end);
>> +bool __mmu_notifier_test_young(struct mm_struct *mm,
>> +		unsigned long address);
>>   extern int __mmu_notifier_invalidate_range_start(struct mmu_notifier_range *r);
>>   extern void __mmu_notifier_invalidate_range_end(struct mmu_notifier_range *r);
>>   extern void __mmu_notifier_arch_invalidate_secondary_tlbs(struct mm_struct *mm,
> 
> I mean damn, at this point maybe it's legit to drop the surrounding externs here
> too? But maybe not :))

I prefer to leave the others as is:)

[snip]

>>
>> -static __always_inline int kvm_age_hva_range(struct mmu_notifier *mn,
>> -						unsigned long start,
>> -						unsigned long end,
>> -						gfn_handler_t handler,
>> -						bool flush_on_ret)
>> +static __always_inline bool kvm_age_hva_range(struct mmu_notifier *mn,
>> +					      unsigned long start,
>> +					      unsigned long end,
>> +					      gfn_handler_t handler,
>> +					      bool flush_on_ret)
> 
> Can we please fix this terrrible indentation while we're here :)?
> 
> static __always_inline bool kvm_age_hva_range(struct mmu_notifier *mn,
> 		unsigned long start, unsigned long end, gfn_handler_t handler,
> 		bool flush_on_ret)
> 
> Would be nicer, thanks!

Will do if KVM maintainers are also happy with this.

