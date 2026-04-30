Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97F79FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 01:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1B206B0088; Wed, 29 Apr 2026 21:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CD1D6B008A; Wed, 29 Apr 2026 21:26:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3176B008C; Wed, 29 Apr 2026 21:26:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C43F6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:26:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50CA2C24E0
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 01:23:48 +0000 (UTC)
X-FDA: 84713475336.23.D39CC7C
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2E9D74000A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 01:23:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RPpmx5BU;
	spf=pass (imf17.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777512226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1hGcplYVwQABxYlLF+wndCBgicnUwEbPp4jkVLwNR6Q=;
	b=vuMievoIYdJyG5cB72+VQ9oe1C/b+wB3Egi8i8E/vOzD+JTgLtZR2ksUsNNpEthxVz9G8a
	k7PtRRkR8j3VBEKIlfUiVXlplRE2sZqvK7BGSz3qBi9VzKzKl8jOoeOiUAkYkYfAsa53sc
	S0ypei9iqRquiVJaYG+L9jA6LoHYiKo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RPpmx5BU;
	spf=pass (imf17.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777512226; a=rsa-sha256;
	cv=none;
	b=HwAcGVVWBOfRaK7KWAV1bRYetlR9fsUcx8dVLW74IJhALzDBslQFYQlrsxrrsyFo3e2YjA
	yV/RD++Xtr94KOwUoj9Ce6VpD93I8iR9uFjc8yCgJKGQPWw2MF2X07jYxhPfQWO3leqSev
	hCTTk25109JYc1Ge7F8rgtLY+eGE344=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1777512220; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=1hGcplYVwQABxYlLF+wndCBgicnUwEbPp4jkVLwNR6Q=;
	b=RPpmx5BU4EAeJS+Kw9CUpJ22nQ4590c6YuDNDP1Q6Mil5NuQG9ER0f6VwDzOcmHsjGdNyl9W4oCu1Ah8fNDFWCAzoEChgDVBg9kb+lrW8NSuEjf6c1NEEdxqybTZoriDeO4WoNj5SClnAeHpc5s5GBfHb35EXClERC6v2Vh3mfw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=40;SR=0;TI=SMTPD_---0X1zKUK7_1777512216;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X1zKUK7_1777512216 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 30 Apr 2026 09:23:37 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: akpm@linux-foundation.org,  david@kernel.org,
  lorenzo.stoakes@oracle.com,  Liam.Howlett@oracle.com,  vbabka@kernel.org,
  willy@infradead.org,  rppt@kernel.org,  surenb@google.com,
  mhocko@suse.com,  ziy@nvidia.com,  matthew.brost@intel.com,
  joshua.hahnjy@gmail.com,  rakie.kim@sk.com,  byungchul@sk.com,
  gourry@gourry.net,  apopple@nvidia.com,  dave@stgolabs.net,
  Jonathan.Cameron@huawei.com,  rkodsara@amd.com,  vkoul@kernel.org,
  bharata@amd.com,  sj@kernel.org,  weixugc@google.com,
  dan.j.williams@intel.com,  rientjes@google.com,  xuezhengchu@huawei.com,
  yiannis@zptcorp.com,  dave.hansen@intel.com,  hannes@cmpxchg.org,
  jhubbard@nvidia.com,  peterx@redhat.com,  riel@surriel.com,
  shakeel.butt@linux.dev,  stalexan@redhat.com,  tj@kernel.org,
  nifan.cxl@gmail.com,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  Mike Day <michael.day@amd.com>
Subject: Re: [RFC PATCH v4 4/6] mm/migrate: add copy offload registration
 infrastructure
In-Reply-To: <4652f10e-1993-4151-a0f2-1d1623de79f7@amd.com> (Shivank Garg's
	message of "Tue, 28 Apr 2026 17:40:53 +0530")
References: <20260309120725.308854-3-shivankg@amd.com>
	<20260309120725.308854-12-shivankg@amd.com>
	<87o6kdzeei.fsf@DESKTOP-5N7EMDA>
	<70414c31-d928-41a6-89db-eeb0f34ec07d@amd.com>
	<4652f10e-1993-4151-a0f2-1d1623de79f7@amd.com>
Date: Thu, 30 Apr 2026 09:23:36 +0800
Message-ID: <875x59w89z.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: ggkmz8jnj5thkyyimr9qacrh5rs8k1jy
X-Rspamd-Queue-Id: 2E9D74000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777512224-470601
X-HE-Meta: U2FsdGVkX1+jDUaSd9bfFrm+YS6S0cXQy87LEXJ8jQvwm4RUBYwKl2PpCsSoZptZGrKxyaKQyX2aMQNwdM1EKnOGvpCjEtA4nHyIbmSsum7Z79UpThLhnPNaF2WWHZ7FR7k/VNEm5sNBejYGmrngfBdkNaMwWJyQz09AIMOg7fgjI5QDmQZSohiSgcN0rdheJiHttDYJuMtMjiOtYs5X3VGtMyusCSxiUy+Ge6wYzjaB0E0pCdZFvxCwh3xV0fAg4+iE+9wM6QtbdG3K8+fDaLna4aOjdiFW/j2BLvXFTDiWJdJskOL7/C53HjpIUe0CFdmifbmPKtnBk4xNxPnmMJrWumiGm/IMApe2SMSdLSxqKxuT4a81kV/dpDminNRJOJB1r0DlARly5teS7blhu6+E3QS8/adzZHq5ZNLeoaphJ5dcSTtr/a5sxtaZ3c3wmTDt1Br/Bs02Kf/sY8zlzON44ZJc+oxZmdZDg4QLbVYfoUrv7BoFGCXJwNIHtMwjn+HfycHOWYhCqpXaviLd9b/omDpNYDnPs9zYYggaj1zjgxf06f7IbcG6TU0EsPY5v3CTsELPfkzncoksRCKkp69l/Z0+viAvrBeklkRb6rh5tk631EjxTDutWQciIj5OoxGYem/JMWJqd/uHmKLOWzVa/hSoa7ql+ytDJZE+g4HtdqKm0yZEUnF4Qp5Ix8L6iSIfIiEgiDQfX8JcqfybGc8KLp21HSQ5qgDJspunR2on0UwgIXVtKgX2isDD36WpNt5Niz+6nVwLrdDaATjD7NeLeVYhm5T2Ifax5G4JfJ0T8KnKxXmHfaghxlndordN3Qu179DnnHctaeBnts2Uf524btxu+xrIbPXdaBPVnFKHZnOEYiLzKrNoCBHyg5AMjsjFPGzxccaE+7ZTvTQMkv0qnSirHCxn8KzabazOif+ZZos/YW5hSxcrg+DPjjxgPKBQsV5RdUV8oWmcVob
 74f927Xl
 sDHgaS8Ct9LwEzMDgBfbNfJeN2jKeY/8X5G6PsRzyLrUz87zoZ9y8SWnmD+DovDQMJp4kIiRrFGJCYoGe2VZSfEAcBXHz8QcO4UFB5HzRjiv1tatgPaVnZ71oeaIlpPNT9HZi92HBpgzOFOrBFn2eMLTjXC6z+doHiCjBqdcxojz4uUv5Bw5HUkxVroHLGxbzkW2cE4+6QyahresMr9unBIxq1cBWgDJWFHVpR3rpS6YeLIB2Eae8YDExhEOtHP8l03AcfyqSqJNrJgdYhzCmKLJCCudD+z0Ci49cOeGXETqvgBzTxDLgcL7xcAJ1SX/8eGkwsnM6NMilqjb/BXMY5XDFldqabGmHbpR13wAzYCj2husJxvAQpJOCPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Garg, Shivank" <shivankg@amd.com> writes:

> On 4/3/2026 4:41 PM, Garg, Shivank wrote:
>> 
>> 
>> On 3/24/2026 4:24 PM, Huang, Ying wrote:
>>> Shivank Garg <shivankg@amd.com> writes:
>>>
>>>> Introduce CONFIG_MIGRATION_COPY_OFFLOAD, which lets offload driver
>>>
>>> Do we really need a new kconfig option?  IMHO, we have too many now.
>>> Because we have a jump label already, the performance difference should
>>> be trivial.  Can you measure the size difference?
>> 
>> BASELINE (offload=n)
>>    text    data     bss     dec  filename
>>   23577    1632      32   25241  mm/migrate.o
>> 39202900        14159750        6502152 59864802     vmlinux
>> 
>> WITH OFFLOAD (offload=y)
>>    text    data     bss     dec  filename
>>   24444    2568      32   27044  mm/migrate.o
>>     676      64       8     748  mm/migrate_copy_offload.o
>> 39208218        14163942        6498120 59870280     vmlinux
>> 
>> WITHOUT CONFIG (always-on)
>>    text    data     bss     dec  filename
>>   24444    2568      32   27044  mm/migrate.o
>>     676      64       8     748  mm/migrate_copy_offload.o
>> 39208405        14163942        6498120 59870467     vmlinux
>> 
>> It saves around 5.5KB of size, when offload support is disabled.
>> Is it meaningful savings? What do you think?
>> 
>>>
>>>> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
>>>> +extern struct static_key_false migrate_offload_enabled;
>>>> +extern struct srcu_struct migrate_offload_srcu;
>>>> +bool migrate_should_batch_default(int reason);
>>>> +int migrate_offload_start(struct migrator *m);
>>>> +int migrate_offload_stop(struct migrator *m);
>>>
>>> Why not naming the function migrate_offload_register/unregister()?
>>> IMHO, that sounds more natural.
>> 
>> Ack. I'll rename to migrate_offload_register/unregister().
>> 
>>>
>>>>  
>>>> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
>>>> +	/* Check if the offload driver wants to batch for this reason */
>>>> +	if (static_branch_unlikely(&migrate_offload_enabled))
>>>> +		do_batch = static_call(migrate_should_batch)(reason);
>>>
>>> Should batching based on "reason" be determined by the general migrate
>>> code instead of the migrator implementation?  For example, if we only
>>> batch copying for ASYNC migration, we should determine that in
>>> migrate_pages_batch() instead of the migreation implementation.  Or am I
>>> missed something?  If so, can you provide an example?
>>>
>> 
>> My idea was that different drivers may have different cost/benefit
>> profiles(e.g. setup cost, migrate batch-size, etc..) 
>> 
>> For instance, a DMA driver may want to target only bulk migration usecase.
>> And a CPU-thread based driver can be used more broadly, without worrying
>> about setup-costs.
>> 
>> But I agree it's premature with only one-driver.
>> I'll move the reason check with target usecases into migrate_pages_batch()
>> and drop the should_batch() callback. If a future driver needs different
>> filtering, we can add it back then.
>> 
>>>>  
>>>> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
>>>>  	/* Batch-copy eligible folios before the move phase */
>>>>  	if (!list_empty(&src_batch)) {
>>>
>>> Guard with "static_branch_unlikely(&migrate_offload_enabled)" first?
>>> Better to define a inline function to shorten the expression.
>>>
>> 
>> Sure, will add the static_branch_unlikely guard and wrap in a helper
>> function. Thanks.
>
> Coming back to this while reworking the patch.
> I think the static branch guard here is actually redundant. We already check it at
> the per-folio classification that builds src_batch,
> so when offload is disabled src_batch stays empty and the list_empty() check
> short-circuits. I'll still wrap the SRCU + static_call into a helper at this call
> site, as you suggested. Sorry for the flip-flop.

Yes.  It's functionally redundant.  I just want to know whether it can
benefit performance (in a minor way).

---
Best Regards,
Huang, Ying


