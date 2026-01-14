Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A01EDD31A16
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAD886B0005; Wed, 14 Jan 2026 02:25:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80516B0088; Wed, 14 Jan 2026 02:25:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB6F56B0089; Wed, 14 Jan 2026 02:25:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CB4FD6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:25:39 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 727A31BA5C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:25:39 +0000 (UTC)
X-FDA: 84329734398.20.3D55796
Received: from smtp-out3.simply.com (smtp-out3.simply.com [94.231.106.210])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8497B140002
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:25:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=c4SqqxTq;
	spf=pass (imf23.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768375537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+QBpOtA3H6xidkI1ONmiWsTt0NU6CuZMGASd99AdC9o=;
	b=SqYJdLfMiCQls32KWjndBPr7p2QagkMbnATWAmOLZfdmt9ZosFlp+ARGqP03xFge2vLNc8
	dGyvdRK46kiM4/uHfMdbPRB3Q61fgugcs7/+esGvAkeed1yAm8eINf7mON66n6eL2xVMUe
	r7cgJQyWdswbsXFOumZNxVw2HpUhsnY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=c4SqqxTq;
	spf=pass (imf23.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768375537; a=rsa-sha256;
	cv=none;
	b=Lk1CUtVRUrFudGBvSdwjCY2YJ9Zera/B8SdW0aaYrXaJaLiwkj1W95JgNrF7KNrMAPiLg+
	3BO/SoKH7hhPvLBSjes5B9OkqDuWjlIJL60jGTPBgq6EtFTNw6r5SNpPsizEa9PVO3pLq7
	EbiqInJUwFq1GT3Mf0vcfJoWjKHfm54=
Received: from localhost (localhost [127.0.0.1])
	by smtp.simply.com (Simply.com) with ESMTP id 4drd1q6zYpz1DR2l;
	Wed, 14 Jan 2026 08:25:35 +0100 (CET)
Received: from [192.168.0.25] (h-98-128-223-123.NA.cust.bahnhof.se [98.128.223.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by smtp.simply.com (Simply.com) with ESMTPSA id 4drd1q44hrz1DDhH;
	Wed, 14 Jan 2026 08:25:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
	s=simplycom2; t=1768375535;
	bh=+QBpOtA3H6xidkI1ONmiWsTt0NU6CuZMGASd99AdC9o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=c4SqqxTqRyZW6GiGzW3EQ1/DX4NuN/R50gplUIWWXpHha2xT5UeWo3RelFqYi4296
	 +ucx8iDatl9tLt3ksR8EobqWQdAYKQ22dazm00PAy64ss6jWX0t6JQvNkQ0YaWSIfX
	 CUzdxBfwXhXDWbnl2wMFhtmw56Z2DgjpMnB7b4bba7xub+MbaDtgC3bHF5msY+uAQn
	 jV6pIDD1CJbBRoK1fft1/qVF0dKmB4HmPuxq3D6qrc+n+Gs8DF7pEG/rYAOcfo2SKD
	 1XC+VMRJVzDLkXxQmWv0uazA5JOU7GSVhGV0H77PHt0pLkkuS5Y0iPxOzeHuhj6jno
	 5k1tmtch/dBag==
Message-ID: <8cddb02c-6bc0-4c1b-85c5-a00e3e75b63a@gaisler.com>
Date: Wed, 14 Jan 2026 08:25:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] sparc/mm: export symbols for lazy_mmu_mode KUnit tests
To: Kevin Brodsky <kevin.brodsky@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 "David Hildenbrand (Red Hat)" <david@kernel.org>, sparclinux@vger.kernel.org
References: <20251216201403.4647a4f9861d3122ee9e90d7@linux-foundation.org>
 <20251218100541.2667405-1-kevin.brodsky@arm.com>
 <3ae6e07c-c99e-476e-b9d8-49b999e87197@arm.com>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <3ae6e07c-c99e-476e-b9d8-49b999e87197@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: snoxdywzps58ghghadwxxg3w3t9iidpd
X-Rspam-User: 
X-Rspamd-Queue-Id: 8497B140002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768375537-734962
X-HE-Meta: U2FsdGVkX1/KuQ447Yndb6ImZiNTNdHBDcI0gPBuSBbQgK5OJiQRHVpYcjUX/1eKWUPVrSCvuvS95FHMVzE9IqcN24aATFko4B2EbvPOzlhQmKpB8JiY6oYoz1qNCIvFgKdQ57UHq57OxZ8wxrCdiS5v/kG1Z3zDI6i9L8xuCwp1hnIJqDwBfrdDgRjiQ/2jFfNcjL/eW+E8B/acbek1oX3GF7vn1VxNXB6jCWv2Z37qfdE3Wgvcj0pyJa/h9NsjYlTvfjX6LOZGhPWq79apHwZhhrHWxgocp5++myzR4yDT6Mv4tAA2m/VDCAGI3uNNWFixBRtfl/OMds2GE4Rbo9tCV4072uxcsKQy6HfsFDzAGezNrJT8PUSTrEJ1mVNDDswaSgT8//PEzCFCJy/dW7ipXT1GRPencD5Q9OrJRzsbrtI/2dcExer7ewnWyViIqYvnp86jC4dYugWPKwYDF8hfZnGJjvLNe9XvGP/arBfcAt2qFwWc7jLqPt1042adoHvuLNVpEfIZUGIadqIM/rXaa5Wnm2n5G/xCbw9b3mH3TC9zUjFFscTuhTIsta8eQS4hqw7EBbXmgHgM0ASxv/AckyAUQ/NC+SnvvNDpvqzYLN7Udv6mqUdK5FREHXH1463nwTRb30Ps6ET/CLrpar5t22lQTzZ+OE1K8pTk1do/RAK/IFxgfT4aae7g0f1y012PYLNfOGblvkVw0P4B5+lMZmMuhl/3RJhuGGj9024vp80qFBGfFIHRQ7JOdcd4yr7hzvNG6BeLsS3vpz3Fv3PwVC5wClc143pNWi13AEi6oXnBpm8lEdPumnTfxysaEaiaHFWJraYFEVhAbucVLssTlwIHazeflHi4d0ixVb0Gh5vwZErWJj/I+ZAYEtWaOH7mJZvmz5ICgQ7RptQ4Vk3ZefcbYcn5W31q9aXzjFN82dwwrHi81buQ1cGrMn/Cfe+3nrCXricyDOH6ysh
 XzSlVxkB
 eJvw3OrDOMA+JakCifx6VK7BliGW+nK2p5/8huoJnKufc+TauO6GDcJvbpp0sW8t8KgEoi7UEwoOGGoEZFheLuJWHXaBIID6JGJc8g0m1KV1fFSuBld/Yt5xb+cqcsQNYWDNazIQ9rfy7da2shMBaP4Q0kIi7nOYZCScEIlD20+v/AQJz+qcsQXhaCzbU2Ar2EP+8C697LijmMoyLzribxEn8eu3/plDjERy3MZGTgceJTlktxkFymnkq4kUJqMrc46xLfnRZYIB0u1bS678jmYQoshJozHz625YhaWicEwq1B3WhWPmnZwcvYzG2GmmbfAHKYIjG8oaOpE/k3gZ+/9LdDgHY+mb2qma6XlZMJYqlgQRbqDeYTR2RJuvb1vpJrpYcS3WlEClhSr9EH2ljojnlMrahXOGSrDUcTWsjAklPJXwviaCzo99yJobdMS+58+iwViEnuMrKnSzqRqGNzyOj2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-12 11:09, Kevin Brodsky wrote:
> On 18/12/2025 11:05, Kevin Brodsky wrote:
>> Upcoming KUnit tests will call lazy_mmu_mode_{enable,disable}.
>> These tests may be built as a module, and because of inlining this
>> means that arch_{enter,flush,leave}_lazy_mmu_mode need to be
>> exported.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>
>> The CI reports that sparc needs pretty much the same time treatment as
>> powerpc... Here's another patch to take care of that.
>>
>> Andrew, could you please add it after the powerpc one? At this point it's
>> probably best to remove the comment above MODULE_IMPORT_NS() in
>> mm/tests/lazy_mmu_mode_kunit.c. Thank you and sorry for the noise!
> 
> Gentle ping - I think we need this patch in mm-unstable, the CI has been
> complaining as well. Thanks!

I get this problem as well, which is solved by this patch.

>> ---
>>  arch/sparc/mm/tlb.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
>> index 3a852071d260..6d9dd5eb1328 100644
>> --- a/arch/sparc/mm/tlb.c
>> +++ b/arch/sparc/mm/tlb.c
>> @@ -11,6 +11,8 @@
>>  #include <linux/preempt.h>
>>  #include <linux/pagemap.h>
>>  
>> +#include <kunit/visibility.h>
>> +
>>  #include <asm/tlbflush.h>
>>  #include <asm/cacheflush.h>
>>  #include <asm/mmu_context.h>
>> @@ -54,6 +56,8 @@ void arch_enter_lazy_mmu_mode(void)
>>  {
>>  	preempt_disable();
>>  }
>> +/* For lazy_mmu_mode KUnit tests */
>> +EXPORT_SYMBOL_IF_KUNIT(arch_enter_lazy_mmu_mode);
>>  
>>  void arch_flush_lazy_mmu_mode(void)
>>  {
>> @@ -62,12 +66,14 @@ void arch_flush_lazy_mmu_mode(void)
>>  	if (tb->tlb_nr)
>>  		flush_tlb_pending();
>>  }
>> +EXPORT_SYMBOL_IF_KUNIT(arch_flush_lazy_mmu_mode);
>>  
>>  void arch_leave_lazy_mmu_mode(void)
>>  {
>>  	arch_flush_lazy_mmu_mode();
>>  	preempt_enable();
>>  }
>> +EXPORT_SYMBOL_IF_KUNIT(arch_leave_lazy_mmu_mode);
>>  
>>  static void tlb_batch_add_one(struct mm_struct *mm, unsigned long vaddr,
>>  			      bool exec, unsigned int hugepage_shift)
>>
>> base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
Regardless of if it becomes a patch of its own in the end, or is
folded into another:

Acked-by: Andreas Larsson <andreas@gaisler.com>

Cheers,
Andreas


