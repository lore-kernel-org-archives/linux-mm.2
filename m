Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93C6EE81A3A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 15:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F278D6B0088; Mon, 16 Feb 2026 10:29:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED12F6B0089; Mon, 16 Feb 2026 10:29:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E14CC6B008A; Mon, 16 Feb 2026 10:29:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD64C6B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:29:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B6CA1D047
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:29:27 +0000 (UTC)
X-FDA: 84450703974.09.FF26499
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 63A882000C
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:29:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771255765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QyU/1yqbDTt+Tsm+4EXpZVbrSAOuHNabjPfri/+S+fY=;
	b=jfaGuWqmK9SeXrSWM75bXQZS12KZLCSGG3bH1tdPigdNnVd6DP03kpMNs2kjyY/LzvtOIA
	9vaYQ2gaalUZ95wx4mZS0rzrAHNFP+5r8XrQvsmR7j3dlYgRz5XDcOeo9vKxZONUD5QGJd
	Gds3lCpznBV0yTzNyLZKAXSKV+35XRU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771255766; a=rsa-sha256;
	cv=none;
	b=pNsPe1qwpR5nkrGO7wCK+AXozXb5+S1yGqkBpXnqS6NFHSuuLCrE8IxdeJFF6oam+Q7fF8
	Umiurs1FBP9AvJrpEzm80Qpyhi/h+5NR7PjsfXwmgpTJrJMVb5DuMD34KodTyUg0k7i1Bg
	/PQS2zIu/wdfIiL9EnfNJqcVbiGEzIE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C379C1576;
	Mon, 16 Feb 2026 07:29:17 -0800 (PST)
Received: from [10.163.134.253] (unknown [10.163.134.253])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D34753F632;
	Mon, 16 Feb 2026 07:29:20 -0800 (PST)
Message-ID: <89606308-3c03-4dcf-a89d-479258b710e4@arm.com>
Date: Mon, 16 Feb 2026 20:59:17 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: remove HAVE_CMPXCHG_LOCAL
To: Will Deacon <will@kernel.org>, Jisheng Zhang <jszhang@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Dennis Zhou
 <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, maz@kernel.org
References: <20260215033944.16374-1-jszhang@kernel.org>
 <aZL46z1UZkQlF3Dd@willie-the-truck>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aZL46z1UZkQlF3Dd@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 63A882000C
X-Stat-Signature: d1xsiic194dbf4cijf3cworr4ihrn4eq
X-Rspam-User: 
X-HE-Tag: 1771255765-552933
X-HE-Meta: U2FsdGVkX1/fAqwlVY3+LwpvIUDl6bUAyC/oXV6fxEIJ2IZD3Lm3myLcojoSNNH0gYiya3I3IP053OddN9ywgZ76xzzgks9O9aFr5U/Cs21FblZH9dK4jM3RG2EpK9zqHzu2TN6o9qVmb+e8K63x5BFTy3prLkCfVTu9jCsJznbRMybd6CZCWCVfv5CBbV4+/paUo43VwElR1SdKNDa3YcvtgiGDF2XkKhJ3DyBX13pctPdzeQIPY86gqir75fgizS8Fx5v1nghPhU49pxglX6b1Zk6WSiSmyHTUGxYAQ9oQJEkSmCFUkuNVbtVog8xZSSSlqXRnmtf2JBMx/h3d9VaXMgFEs0afd63boHSAFLYgBr7jg2THIQ/gAcAz/j4LTkHl6NnVSeYGi0GhM2A6UK63cDcAm8+n99vRo3bv64Z0EfgZrU2OZzfS5W8fj/FalrZN2/Qd39gkVQTlqrUg08W1ft89SfnQyqEd0EnvIrmu68wFdMtE6eKOkzAS5aQ42wT5R7OvPmgyEbOyZtsDEsPp4ikyr5VY1lU8Pxrc1yTNdmiVdTWu953dPaGLyzgDwpmhMUO6pW9dgmYV7cIH/VY7qRZNjMPNLVDsTrouPP5nQfDVa6qMZyIxfxZnbamaLkM9R8iJJoxQNO6Y1nwqPosq1mjgEPrRPckJBcivNcCCWVQz6DeYtml1C5xc9M8n6Ux3+753cWglsiMnpoc2jsa3wlvSA1GAZ05TcxhQ7wNbxl1hqwJhBFZOqlp8DdGcovxUNw10mQqza/RRDaAN1JBV0Ut4AWaCTQW3tOVFjHGg9+bPxoc8cw+PCqlWkP8yVQRVHyTuKLp83YgPONyaBgRVf8xCBsN2oUMI/nzUjk3PprswEBaAY4aNhIuPNpnic1FE3puNpe8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 16/02/26 4:30 pm, Will Deacon wrote:
> On Sun, Feb 15, 2026 at 11:39:44AM +0800, Jisheng Zhang wrote:
>> It turns out the generic disable/enable irq this_cpu_cmpxchg
>> implementation is faster than LL/SC or lse implementation. Remove
>> HAVE_CMPXCHG_LOCAL for better performance on arm64.
>>
>> Tested on Quad 1.9GHZ CA55 platform:
>> average mod_node_page_state() cost decreases from 167ns to 103ns
>> the spawn (30 duration) benchmark in unixbench is improved
>> from 147494 lps to 150561 lps, improved by 2.1%
>>
>> Tested on Quad 2.1GHZ CA73 platform:
>> average mod_node_page_state() cost decreases from 113ns to 85ns
>> the spawn (30 duration) benchmark in unixbench is improved
>> from 209844 lps to 212581 lps, improved by 1.3%
>>
>> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
>> ---
>>  arch/arm64/Kconfig              |  1 -
>>  arch/arm64/include/asm/percpu.h | 24 ------------------------
>>  2 files changed, 25 deletions(-)
> That is _entirely_ dependent on the system, so this isn't the right
> approach. I also don't think it's something we particularly want to
> micro-optimise to accomodate systems that suck at atomics.

Hi Will,

As I mention in the other email, the suspect is not the atomics, but
preempt_disable(). On Apple M3, the regression reported in [1] resolves
by removing preempt_disable/enable in _pcp_protect_return. To prove
this another way, I disabled CONFIG_ARM64_HAS_LSE_ATOMICS and the
regression worsened, indicating that at least on Apple M3 the
atomics are faster.

It may help to confirm this hypothesis on other hardware - perhaps
Jisheng can test with this change on his hardware and confirm
whether he gets the same performance improvement.

By coincidence, Yang Shi has been discussing the this_cpu_* overhead
at [2].

[1] https://lore.kernel.org/all/1052a452-9ba3-4da7-be47-7d27d27b3d1d@arm.com/
[2] https://lore.kernel.org/all/CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com/

>
> Will
>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 38dba5f7e4d2..5e7e2e65d5a5 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -205,7 +205,6 @@ config ARM64
>>  	select HAVE_EBPF_JIT
>>  	select HAVE_C_RECORDMCOUNT
>>  	select HAVE_CMPXCHG_DOUBLE
>> -	select HAVE_CMPXCHG_LOCAL
>>  	select HAVE_CONTEXT_TRACKING_USER
>>  	select HAVE_DEBUG_KMEMLEAK
>>  	select HAVE_DMA_CONTIGUOUS
>> diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
>> index b57b2bb00967..70ffe566cb4b 100644
>> --- a/arch/arm64/include/asm/percpu.h
>> +++ b/arch/arm64/include/asm/percpu.h
>> @@ -232,30 +232,6 @@ PERCPU_RET_OP(add, add, ldadd)
>>  #define this_cpu_xchg_8(pcp, val)	\
>>  	_pcp_protect_return(xchg_relaxed, pcp, val)
>>  
>> -#define this_cpu_cmpxchg_1(pcp, o, n)	\
>> -	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
>> -#define this_cpu_cmpxchg_2(pcp, o, n)	\
>> -	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
>> -#define this_cpu_cmpxchg_4(pcp, o, n)	\
>> -	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
>> -#define this_cpu_cmpxchg_8(pcp, o, n)	\
>> -	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
>> -
>> -#define this_cpu_cmpxchg64(pcp, o, n)	this_cpu_cmpxchg_8(pcp, o, n)
>> -
>> -#define this_cpu_cmpxchg128(pcp, o, n)					\
>> -({									\
>> -	typedef typeof(pcp) pcp_op_T__;					\
>> -	u128 old__, new__, ret__;					\
>> -	pcp_op_T__ *ptr__;						\
>> -	old__ = o;							\
>> -	new__ = n;							\
>> -	preempt_disable_notrace();					\
>> -	ptr__ = raw_cpu_ptr(&(pcp));					\
>> -	ret__ = cmpxchg128_local((void *)ptr__, old__, new__);		\
>> -	preempt_enable_notrace();					\
>> -	ret__;								\
>> -})
>>  
>>  #ifdef __KVM_NVHE_HYPERVISOR__
>>  extern unsigned long __hyp_per_cpu_offset(unsigned int cpu);
>> -- 
>> 2.51.0
>>

