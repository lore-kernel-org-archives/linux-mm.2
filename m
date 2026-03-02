Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA388EA4E22
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:48:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEA6E6B0088; Mon,  2 Mar 2026 10:48:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1F46B008A; Mon,  2 Mar 2026 10:48:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCE1E6B0092; Mon,  2 Mar 2026 10:48:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B7E6E6B0088
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:48:37 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 45950565FF
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:48:37 +0000 (UTC)
X-FDA: 84501555474.20.2DA6E71
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 24FA0100010
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:48:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qn2tNu2a;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772466515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTECatV7Hem2M5Whzj/+5qLaShaqM0faNoQsDp0E1eI=;
	b=IGkb3C3xyZpIgF64kO7sMO/9Ge8130ZweYIuBD1hOzO+IAaxyKghq244OFPUG37e5utwxn
	+6nyb8OvSQhKB4hQhbsOt9jb0UWIcUrlPzRfMD2cXOUfmicJjo75hAhHYPfQanhm/87QS1
	41RTHusyz0tUvR1/nToSkVa58661U0Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qn2tNu2a;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772466515; a=rsa-sha256;
	cv=none;
	b=C/J65lngBjIcHyjoAw+j06lJDD+dZzXXet5il5Vh8w+Lu8Hwa/4QLKMcemn5WRBRImzyug
	1cPdG1EdxqiSxAS5nVR6cb4IsvNwoaKzCMPEi6137U4YqMVX4kFo9NH9ikZ8Ij8q5unowu
	xkqtAVhSy2g8LpTEZaUvWlHWATKNx1k=
Message-ID: <42a719d3-5fbd-4b96-a150-6c0b4a1521a3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772466512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FTECatV7Hem2M5Whzj/+5qLaShaqM0faNoQsDp0E1eI=;
	b=qn2tNu2asGcPBaNPiLBEHqPA1ISUAYvFdlA3yDgMEjvnV9wFHAHANAKzMMQI7p+eoGhJbw
	GB+5m+Qs2PPeTQk6Pxy5HsBkMVi/kh8tLAqThalAcm3txH4p/T0ROgVUJGN2DzQ2qMT7uD
	UjSW9pewzRKpXJGWz1nxJ1hYJh2XlGg=
Date: Mon, 2 Mar 2026 23:48:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 2/2] x86/tlb: skip redundant sync IPIs for native TLB
 flush
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
 dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260302063048.9479-1-lance.yang@linux.dev>
 <20260302063048.9479-3-lance.yang@linux.dev>
 <20260302145652.GH1395266@noisy.programming.kicks-ass.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260302145652.GH1395266@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 24FA0100010
X-Rspamd-Server: rspam07
X-Stat-Signature: ioq6xdjduksf6mie68um67y944fktnfq
X-Rspam-User: 
X-HE-Tag: 1772466514-53302
X-HE-Meta: U2FsdGVkX1+gSNddjWY9MgZLgw6vlX1H5XMKAN8Z5lauQrBwUFUUmGoSMh9ohUfpYqBAsQ1QokVZcF4utuiQFxfQJPVgKhiWk+pYoBitwtunhjp7F3uOrLmyQBCldEjNz10p2sI6CQ1MMtkXETZwOdZZfPdnRpVY8yfiAmoeJj5C4BRl0nbptghFINZwMDcyueV7I+kcHfGoXwxqFdxSwNVmqorbsyrrNQzv87XWcEjZhEK70Wewt6sdGuz9Txla0W11InzmuweX5Xn/3dDMLPOrt80D49Pj7ceVDm6hoZJx2T6e4pWUxqr6eSO6K30BjUFLPurHNQITUTx5GofWxmZpFw2WfBjdp/qVYBe1AgLk53Hr4EgnhBD7Xu+F5CnPgs/LEw7N7qhVZe1BVbAwqdJQfG+AUKGjP7BJneYd6VVX864CeU76oMIOS89iRdVOEcqGLXSIh7s7dDHdJl5Zw9Yaukh9jHZcXqGnFF+XMAKN6FcX/IN+gaP1yctR7sA0un49AHiuebMVC3usARPZKPYWEIyFr06ufTdXYAQ02ahsQ7KurlJCV7FTHhZ31gv9JEt6zaSuQ5nI/9dR9s14Re5wK880SY20DD9F9aBnsVwoGDggVviN1FhT5SO6I+x6E/4aXJS9SCt9aW2F6P/OGWKjpLkgeliQm05LsGeBk51rgOee5PfBlW/NCpXlje07b9wWvh94OSMQhf+9mg3sjJMbh977IefU1dOxuTd9wI1Xd1TrMSDtuMHKgwfreZeTH4D73I6nVl6a+alTPB4tFiNtgDxUsva/WzRutmcpsHA5uRr+/YvBpARWZ+wJIs+BQgT3EsPH7l9gtt8a6k8VaA0Dya/6mQjy37zu50V6TDIDCLE9sjFxytuxg2EhU5NBX0IBNm7QmWWOw6xTskxU94/7oASBvFzj2usAbdluJyBsAaOaRA2/DBRyxVjwMVujQVHD1gGiBFyT4iEavm4
 0uAiXbSU
 nHQtor6e4gtugp4wH3Ted86LD5mZTRrEJ1bECsKqh0CQ0L1fP2BXC3oAFeEaM8bBMzKAzTwW185xGCQypTa8YAA34FOuZQrYveLzcOCEQe5cfIPObLPstuSvWtbI1ra5Nf2yHP6EJ6zyAsP3r+SanYwe8IuYLIqIOU+2d36uE7KYMaK4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/2 22:56, Peter Zijlstra wrote:
> On Mon, Mar 02, 2026 at 02:30:36PM +0800, Lance Yang wrote:
> 
> 
>> @@ -221,3 +222,18 @@ NOKPROBE_SYMBOL(native_load_idt);
>>   
>>   EXPORT_SYMBOL(pv_ops);
>>   EXPORT_SYMBOL_GPL(pv_info);
>> +
>> +void __init native_pv_tlb_init(void)
>> +{
>> +	/*
>> +	 * If PV backend already set the property, respect it.
>> +	 * Otherwise, check if native TLB flush sends real IPIs to all target
>> +	 * CPUs (i.e., not using INVLPGB broadcast invalidation).
>> +	 */
>> +	if (pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast)
>> +		return;
>> +
>> +	if (pv_ops.mmu.flush_tlb_multi == native_flush_tlb_multi &&
>> +	    !cpu_feature_enabled(X86_FEATURE_INVLPGB))
>> +		pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
>> +}
> 
> How about making this a static_branch instead?

Cool. Thanks for the suggestion!

> 
>> diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
>> index 866ea78ba156..87ef7147eac8 100644
>> --- a/arch/x86/include/asm/tlb.h
>> +++ b/arch/x86/include/asm/tlb.h
>> @@ -5,10 +5,23 @@
>>   #define tlb_flush tlb_flush
>>   static inline void tlb_flush(struct mmu_gather *tlb);
>>   
>> +#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
>> +static inline bool tlb_table_flush_implies_ipi_broadcast(void);
>> +
>>   #include <asm-generic/tlb.h>
>>   #include <linux/kernel.h>
>>   #include <vdso/bits.h>
>>   #include <vdso/page.h>
>> +#include <asm/paravirt.h>
>> +
>> +static inline bool tlb_table_flush_implies_ipi_broadcast(void)
>> +{
>> +#ifdef CONFIG_PARAVIRT
>> +	return pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast;
>> +#else
>> +	return !cpu_feature_enabled(X86_FEATURE_INVLPGB);
>> +#endif
>> +}
> 
> Then this turns into:
> 
> static inline bool tlb_table_flush_implies_ipi_broadcast(void)
> {
> 	return static_branch_likely(&tlb_ipi_broadcast_key);
> }

Right. That would be cleaner and faster, eliminating the branch overhead.

Trying using static_branch on top of this series, something like:

---8<---
diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 87ef7147eac8..409bbf335f26 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -10,17 +10,16 @@ static inline bool 
tlb_table_flush_implies_ipi_broadcast(void);

  #include <asm-generic/tlb.h>
  #include <linux/kernel.h>
+#include <linux/jump_label.h>
  #include <vdso/bits.h>
  #include <vdso/page.h>
  #include <asm/paravirt.h>

+DECLARE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
+
  static inline bool tlb_table_flush_implies_ipi_broadcast(void)
  {
-#ifdef CONFIG_PARAVIRT
-	return pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast;
-#else
-	return !cpu_feature_enabled(X86_FEATURE_INVLPGB);
-#endif
+	return static_branch_likely(&tlb_ipi_broadcast_key);
  }

  static inline void tlb_flush(struct mmu_gather *tlb)
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index b681b8319295..bcf28980c319 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -15,6 +15,7 @@
  #include <linux/kprobes.h>
  #include <linux/pgtable.h>
  #include <linux/static_call.h>
+#include <linux/jump_label.h>

  #include <asm/bug.h>
  #include <asm/paravirt.h>
@@ -223,6 +224,8 @@ NOKPROBE_SYMBOL(native_load_idt);
  EXPORT_SYMBOL(pv_ops);
  EXPORT_SYMBOL_GPL(pv_info);

+DEFINE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
+
  void __init native_pv_tlb_init(void)
  {
  	/*
@@ -230,10 +233,14 @@ void __init native_pv_tlb_init(void)
  	 * Otherwise, check if native TLB flush sends real IPIs to all target
  	 * CPUs (i.e., not using INVLPGB broadcast invalidation).
  	 */
-	if (pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast)
+	if (pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast) {
+		static_branch_enable(&tlb_ipi_broadcast_key);
  		return;
+	}

  	if (pv_ops.mmu.flush_tlb_multi == native_flush_tlb_multi &&
-	    !cpu_feature_enabled(X86_FEATURE_INVLPGB))
+	    !cpu_feature_enabled(X86_FEATURE_INVLPGB)) {
  		pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
+		static_branch_enable(&tlb_ipi_broadcast_key);
+	}
  }
---


Thanks,
Lance


