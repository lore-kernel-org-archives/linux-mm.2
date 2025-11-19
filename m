Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22B6DCF3187
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 10:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D7B06B0062; Wed, 19 Nov 2025 05:20:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 788DD6B008C; Wed, 19 Nov 2025 05:20:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 676E96B00AE; Wed, 19 Nov 2025 05:20:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 500626B0062
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:20:07 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8206F14040E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:20:02 +0000 (UTC)
X-FDA: 84126961044.03.2D3A01E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B5EE4160002
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:20:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XKzsfyak;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763547600; a=rsa-sha256;
	cv=none;
	b=ubrr9WEl8vDG+/XVvWjjt4hLQFfMYQWgzBhX4t+2y5fUppvrt+yZCe+RXqjVJo19DMVQMo
	n8gfKej4ipBInRmDD/+x/oLYvf0GXF1Z40RGTezMFjiC3z5Jp/iNIy6eaM4KGWrxnK7vH/
	/+/rzNJUHvwkh2+99Aqttwv1gXLJf38=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XKzsfyak;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763547600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y0rdwwjsXpeRwB9NhZAk3xyU/erTdr/J8x8SlVHkjww=;
	b=mOrlvLIvtMQfL259k2QmMrLnCvpPk4P6YFay+AqNCJT1e2XLDDwfwakSs+5mADZtMNi3NF
	R0aB5/iDP5kJsc+nUwc81Zu4F11NmL6ELAnTgEJFSdG9uPtz/kxy/MHLI1wplJZjia8OFM
	hsNjQYrcSSydTnbdWSrD80ufD69hAP0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C94044412;
	Wed, 19 Nov 2025 10:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED579C113D0;
	Wed, 19 Nov 2025 10:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763547599;
	bh=8gID8BLUqz27ftdyuyVystLlDDq4KdFYCustoOe54RY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XKzsfyaktYk1NfN18S9hccOsNg6wsjdvBDLtH0msz229ZMI3K2CpzJjlq9zogKst2
	 IpRt8Vacn6bPvhAXJdPHwvnVsyk6/LZ60Qv8L+fBjOvTfDozVL9UROfYk950jLCsWS
	 z34Iocb3hYkWz25pZf8wW4+AEb0QYUxLALyXcNTRJvEqAW1in4xBVuLd65R+AO4LmD
	 3mR3cklLqI+9GQ2KEyAt9BlaxeG6te4kJv7JSGHicczEifcPTgrsoQEfXUbh9/ck8O
	 H/mZ5W6d8h1ftYMiR98ZlqQUntxOjDHk0Ldf3QsAumi71SRiq5wve77UId9Sr0YPuj
	 rsuuFhSqOdrMg==
Message-ID: <9386032c-9840-49da-83f9-74b112f3e752@kernel.org>
Date: Wed, 19 Nov 2025 11:19:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] mm: make PT_RECLAIM depend on
 MMU_GATHER_RCU_TABLE_FREE && 64BIT
To: Qi Zheng <qi.zheng@linux.dev>, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, peterz@infradead.org, dev.jain@arm.com,
 akpm@linux-foundation.org, ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
 <0a4d1e6f0bf299cafd1fc624f965bd1ca542cea8.1763117269.git.zhengqi.arch@bytedance.com>
 <355d3bf3-c6bc-403e-9f19-89259d868611@kernel.org>
 <195baf7c-1f4e-46a4-a4aa-e68e7d00c0f9@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <195baf7c-1f4e-46a4-a4aa-e68e7d00c0f9@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B5EE4160002
X-Stat-Signature: efmbehmqfx9uuxx6daw4yx1q3x3m5ss1
X-HE-Tag: 1763547600-475194
X-HE-Meta: U2FsdGVkX18XohlrWfbz7BapzhvC20UqVOHEweT8uPEyVfqJV+J2oR9q0im0Ehhm8em4WFZ/tO1tuZD3i4EH6/qPbPk2cCwt6P0wN28JWFTsTqzrwdak9TW2iXaws7s6tFIN+VZEikvd/z4he0E0ehsQXTJzZ/lFWy3IymBPUqIvuAJJiYVltYEo+BN4yxpZ4Nir3S2yEKlegTQlnCihBXJSejEWVQLGvU3bjBKtuBAL7ke9l06H+ggo/RqXMUSzo/ZxkZ6Jin6CE6H69f5ljrMIY2nyPuA9qHGK6goUoI8jzwOEgBDA2B/USgeoQ1vUvqat9SxLeFw0fbPFL2PzXPg1jyBLyUdCWT/cSMtxcDQ6/0bMeps4nu4ccI1RXk3P09rmbEGHQmu+4meAzE5IU3qeiw3lyYdI6ijz33lGdHa5r2xdBA4BIGQ61gOyE6sawCcab3UpF7SObnF4o32UTpDJLZS06BTmHhzykTw0loEmYKF4E38ZpmYTO1CVnO1W3WU6SkRFnN/XE8NjAx0+D+Uy/HvJ0TR9UodMffeIQlkfN6jlY6RYLv9gnOtlFC0Am3r6nIAEVIa7NOWGJ7fP+/+H0I4lR3kPWCZSl0v8QmqSUVl84AKRmF4pf8Dp1g91f+RC67RjknwZSGJHVXiYM2/IPV5GS0aT9O4aT7eQqo0kp7mJpA+mGf/A9kIYooPEDvWhJOYajw6FgAi9xyKDnMsbN0KIdDMgtLNuveWDvReCG5zguDg4yQBysF15Gtmy0yJWDfqyxLnW0bd628pk9DZ9JkDX/bJio+DcMcL8kDw3s336dJ4+VVqlzfYO4YzcQbzYisBm8iQmi5EJ9l6RDSBd46OxhLqNYh4guYIrcCLh7Y7jMVznM0T0IcgsLaF4NKoQNoTzekoLTb/F9irUAs+Gr7BTAO+NNBix+H1PfRXQOo596mYTiboPAfXMMjRJRmUm785U0UcINj87O4u
 DulIRFE4
 dTRjedUVwmQGsQ5gSu/BiVqVR6wlbyZe4JC4DGDh7xrefGPOyxWCkYMQc3rzFkFOWSdglZF1YKBEHPEpbl3JkCdKZqYoGouWAaRPxQuTiOoY3T/9lJERhOAGP/Dwul+d3rP9KRIlS9Uc/CBvH/fuSpKnN0lRqq2oJbalPOwSqLsds76YhZ8WfRlkPw9TFB4wcJnTaUJyp2EQIaVvR38WgToitCH/llyumbjVXjCjqj5YN2oRwSi0Z9FZ7MrYFIlNclJ0uxWOPY3EkJ4fEBFCEucrU5WD1G8ayvl2FRTb5zozGBAlTnBjflz1as41Crq1bVfYWDcT9A4ov1atIgAcreOH0LEbvIm3ZfPeJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.11.25 13:02, Qi Zheng wrote:
> 
> 
> On 11/18/25 12:57 AM, David Hildenbrand (Red Hat) wrote:
>> On 14.11.25 12:11, Qi Zheng wrote:
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Subject: s/&&/&/
> 
> will do.
> 
>>
>>>
>>> Make PT_RECLAIM depend on MMU_GATHER_RCU_TABLE_FREE so that PT_RECLAIM
>>> can
>>> be enabled by default on all architectures that support
>>> MMU_GATHER_RCU_TABLE_FREE.
>>>
>>> Considering that a large number of PTE page table pages (such as 100GB+)
>>> can only be caused on a 64-bit system, let PT_RECLAIM also depend on
>>> 64BIT.
>>>
>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>> ---
>>>    arch/x86/Kconfig | 1 -
>>>    mm/Kconfig       | 6 +-----
>>>    2 files changed, 1 insertion(+), 6 deletions(-)
>>>
>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>> index eac2e86056902..96bff81fd4787 100644
>>> --- a/arch/x86/Kconfig
>>> +++ b/arch/x86/Kconfig
>>> @@ -330,7 +330,6 @@ config X86
>>>        select FUNCTION_ALIGNMENT_4B
>>>        imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>>>        select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>>> -    select ARCH_SUPPORTS_PT_RECLAIM        if X86_64
>>>        select ARCH_SUPPORTS_SCHED_SMT        if SMP
>>>        select SCHED_SMT            if SMP
>>>        select ARCH_SUPPORTS_SCHED_CLUSTER    if SMP
>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>> index a5a90b169435d..e795fbd69e50c 100644
>>> --- a/mm/Kconfig
>>> +++ b/mm/Kconfig
>>> @@ -1440,14 +1440,10 @@ config ARCH_HAS_USER_SHADOW_STACK
>>>          The architecture has hardware support for userspace shadow call
>>>              stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>>> -config ARCH_SUPPORTS_PT_RECLAIM
>>> -    def_bool n
>>> -
>>>    config PT_RECLAIM
>>>        bool "reclaim empty user page table pages"
>>>        default y
>>> -    depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>>> -    select MMU_GATHER_RCU_TABLE_FREE
>>> +    depends on MMU_GATHER_RCU_TABLE_FREE && MMU && SMP && 64BIT
>>
>> Who would we have MMU_GATHER_RCU_TABLE_FREE without MMU? (can we drop
>> the MMU part)
> 
> OK.
> 
>>
>> Why do we care about SMP in the first place? (can we frop SMP)
> 
> OK.
> 
>>
>> But I also wonder why we need "MMU_GATHER_RCU_TABLE_FREE && 64BIT":
>>
>> Would it be harmful on 32bit (sure, we might not reclaim as much, but
>> still there is memory to be reclaimed?)?
> 
> This is also fine on 32bit, but the benefits are not significant, So I
> chose to enable it only on 64-bit.

Right. Address space is smaller, but also memory is smaller. Not that I 
think we strictly *must* to support 32bit, I merely wonder why we 
wouldn't just enable it here.

OTOH, if there is a good reason we cannot enable it, we can definitely 
just keep it 64bit only.

> 
> I actually tried enabling MMU_GATHER_RCU_TABLE_FREE on all
> architectures, and apart from sparc32 being a bit troublesome (because
> it uses mm->page_table_lock for synchronization within
> __pte_free_tlb()), the modifications were relatively simple.
> 
>>
>> If all 64BIT support MMU_GATHER_RCU_TABLE_FREE (as you previously
>> state), why can't we only check for 64BIT?
> 
> OK, will do.

This was also more of a question for discussion:

Would it make sense to have

config PT_RECLAIM
	def_bool y
	depends on MMU_GATHER_RCU_TABLE_FREE

(a) Would we want to make it configurable (why?)
(b) Do we really care about SMP (why?)
(c) Do we want to limit to 64bit (why?)
(d) Do we really need the MMU check in addition to
     MMU_GATHER_RCU_TABLE_FREE


-- 
Cheers

David

