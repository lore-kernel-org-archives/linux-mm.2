Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 407E8CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 01:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8238E8E0006; Wed, 10 Sep 2025 21:02:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FAD28E0001; Wed, 10 Sep 2025 21:02:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710408E0006; Wed, 10 Sep 2025 21:02:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B1138E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 21:02:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E720EB8915
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:02:10 +0000 (UTC)
X-FDA: 83875168020.23.2766F61
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 14157140002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:02:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YZxOmNl1;
	spf=pass (imf09.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757552529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6RyKxrXBphbUIxCwH62JzKN1u04ZKF0pThPVVL+cJk=;
	b=3UzeSN1yqjoUEeL2Em2rVMSlbXv5uJf9UaMNlTM0XQTMCBtvubV+5vMxHPcjYybbbk8Eid
	vH2HF7uikqTSrjZE8ud/z2r/i9pdwLVcwfbxbuDMMK9EZamHKXK5phg3kkrGoO5ptsSHrM
	ofSPXpoA9HtPOeTzHDJ9O7KCIefR2KI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757552529; a=rsa-sha256;
	cv=none;
	b=B5aiI/wcn07Lf8Olcm7W3gvS96C6/0W4wyp9kjupYrTmkSjVifezrRCkFgYmcd7uy0qI7h
	8vq1QyjzvTjC0R65RCI3wveptkLt+FDf6LHiFY4qVDG17+ew701aWn9D3IYEQb2WSJhFSc
	EcnpCnHGYoe0aG3iAjc/vemQ6Ak1i3k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YZxOmNl1;
	spf=pass (imf09.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-77256e75eacso167638b3a.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 18:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757552528; x=1758157328; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c6RyKxrXBphbUIxCwH62JzKN1u04ZKF0pThPVVL+cJk=;
        b=YZxOmNl12hJce7RpFvlNblOmNUcldnjUn1/YO530WZQqyvemJ7tG1QM4uOvfrFtfQW
         lMu7SPuFdcESt1P9I4Ns80ofI11udHV3/vJvU3IFDY9SadjitG6LO+QpNo8813BK+mfG
         x6seyTEUsK2edHwTWmCIxntP10KHJLdYKli4w8e7zkcI6L7kFc7Fu8vc/MZC8xxuV44Q
         Fdi1srIAkFqYX55jNaH0KuOe+m+UqEbDqn6kdGqrB+2ARBEyuEh2UQc7yCCjvDlxVHnV
         OQWlYi8d90uvXgOsLRK8sn0uRc40BgbF0/bbQgEKwN0YPCxJ/WRRjGfVdQOrV9gkzg25
         g7QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757552528; x=1758157328;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c6RyKxrXBphbUIxCwH62JzKN1u04ZKF0pThPVVL+cJk=;
        b=ZKovDw+U+qwZ5R92kaneZUHzRPhRCgTCxXqSVbewba3B8ffbx+WklKaRe/vldnFxvB
         mj2ISpOQGPtvb1oxeQ+Rzjj1JRce+mES6PutvFiK7oGD4+UEz1hzykIQwNfxQm9i2TVO
         u7dkeyVy9ZfttnDUuO0Vu70GXJ118l77QOCgyXJVWm1o+uAROA1B3on25Mlvj9qnTRAT
         uWCQTEBa4dzGCjRinWzl0COtA3Xm61+UVW4va8TL4Eha3M0wIXxewcJFASwIhoSLD3E8
         O/mHMt4aGcsXFYK3nEVcZs0GfMDlaS+cDYFckh/hLojigZSj4O515CgcK+NwiW6s96rA
         Adog==
X-Forwarded-Encrypted: i=1; AJvYcCUDzhq/XfFLwsseNZdGzCjLW7SmTAEAuUfEb1LVlKt1/cZQI9MAoseTuCLhnGg0G1RXydA/NWaPCw==@kvack.org
X-Gm-Message-State: AOJu0YwtcUpB4chXT6+gHa7TO4t5ysxFgn0xDtmavia/AJ73ETdkMGYB
	klhWnHcS2Uz80V9Qhe9U1+z7oMGM5cekXJZXxdEjLq/mnQD6jc7r7mom
X-Gm-Gg: ASbGncvnX5knt7JCLRiT2fWPTfNANhvtyD1lVx+py0gMqrQuf11lR1+Hq6N88d/LEQ8
	XZlSP+MLHVGP7tQasg0Wh0eQOTbzjERE9HcX9zgiMGSYLEveuRHht9E47w5e5slc7bhfWqHuzO9
	u8coF1gxN6HdKb/xdSoEXF2sBi5i8ejxQRmAYMrvMHU0ZpqjwJwDWEWzIP54nY2tSJgmDjWtiC8
	fY4xBtQtq9wnVuERZJuU3Z1Tsl7TiF14us3W9UnlNyvzgu/3E9OUEQRanRulHOBrAI3N8Mmyaym
	nmqwfagxs9IguWuVvBojAldfWos0c5BIO4M881qwKpyNFpc7bQODpS03UsrfmYSwdovIZKfKK1f
	AWTR69jyzDXxqWf72cEzD36SWaVs=
X-Google-Smtp-Source: AGHT+IHWKYeBfZHFw5wp0lGo2/j/+43qoXRd/Q4Cw1fK4Uyl50WB09aLvc51pAjyyTCeRnBJqpSTow==
X-Received: by 2002:a05:6a00:4652:b0:772:5ba4:d75 with SMTP id d2e1a72fcca58-7742dd1270emr21626263b3a.4.1757552527499;
        Wed, 10 Sep 2025 18:02:07 -0700 (PDT)
Received: from [127.0.0.1] ([2a11:3:200::20f3])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607b34254sm122807b3a.75.2025.09.10.18.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 18:02:06 -0700 (PDT)
Message-ID: <5ed43490-6894-4780-8faf-52d5f25bf3cc@gmail.com>
Date: Thu, 11 Sep 2025 09:01:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/19] x86/hw_breakpoint: introduce
 arch_reinstall_hw_breakpoint() for atomic context
Content-Language: en-US
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 "Naveen N . Rao" <naveen@kernel.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com,
 "David S. Miller" <davem@davemloft.net>, Steven Rostedt
 <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 "Liang, Kan" <kan.liang@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
 <20250910052335.1151048-2-wangjinchao600@gmail.com>
 <20250911094609.5f30e9767ffc3040068ed052@kernel.org>
From: Jinchao Wang <wangjinchao600@gmail.com>
In-Reply-To: <20250911094609.5f30e9767ffc3040068ed052@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 14157140002
X-Stat-Signature: mczijiwq87gfaymry6nf84t1g7t87yq1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757552528-238971
X-HE-Meta: U2FsdGVkX18ofx8gP14AcxDbdNFk9pTqbyVnY+hV+lg9FSUcCUyYJIZVt9Bo+NTpRf3aO9/x1WnWJXyI0ieeCJE56KtQjC/07oMSJZzvL9mlWMsyykWs98cn3U++edhLeNTIdoISsvM4Opvb+EttFm6gpkp2qfF1Rhk30WGA8TahYfgA2gCrAOsG0C3v1JZte8yZlpwmHwdlebmhfXq8WSgRU896REAcL+4ze+hoXLpZD/ckkt+fTsDe6FbhHpkMpoeaJd740MPzLQADrfjmSpuw6NgtB3/VIgIbshRLDFy+9vpcoS4BdgWLAP1lp74iBNyxBClXmRUsYbjfN2IDL9VlLol0F+y2cO60KEFxglYMOXjGqMGo3e+YuoT38cCp4dH6cNtpi7vyIQAw2WqufgSKxFWc5mxLlxXyabvh8EY1ooSLAZqLnIn6JQvkUH+5arhDPgQbJgJSvFgRTtbfh9kuBdSeqH6U1QpAkU/8P1o7e8lkZlmG535s33bqjpetgsX0bxBxWQvH+quNdzeurcZ9JUGCXkMMMn5YPMf7TrwCYqplplpmp0RaePeUvrEInKyKVupoawdVlHiulVN+8HTyvNEzF4SpGM6PPVt1139nBnha+JrhF3qlwfJCzEcHevqAtbHf8d/ZU3wL/xrqa+x3IzTPOGRtGB0rW+6C+X8F8Ufq/215tIsmKBYJzlQd7ULdVV9GbIIHYQAjl7a4s3TlzzjPEDTOvnvl6OAMt7ydKsyD5j5utkQSAX0hAaX9yGCnvCwwupxHNvzaCTNfdDlBiK1xiGkXM7mxaU7jbqd9mhJh23k1YIlWB8RePKSxuOLOpYQNCEBch9VdI2+VviTL7dVkSFsnmaxZvwxcJ58QFwuUSFN73lDOBjF4tzQCreqbsfcxETXQjc4pcnSEzS+UgwL3bKV9ZxZwpENwnxm0FsIz7kPBGptqFjROazeM5HodhtzSf6TNtsQhoUn
 GFSa2Njp
 Ly3BMqmanzCHumvwX6HOOge16NPpPcxbYVfB41PF7tM90pJB5zKTAOIS5CH2KtWSuAaDY0SjebNcOM7qdTuu839JeTHVhGDVYwNPC6s7AADICPX35uF6tRQTrRxX0Dt5upo9pOTwy/yt+idV8qVWnPmDKRcc7jAIGLeFIb7JZXZuk6yaLP1/f3kfARfytnaToC6NFUCkHZu7/Yye4Nj1E50PpxNmhlVOBFZI4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/11/25 08:46, Masami Hiramatsu (Google) wrote:
> Hi Jinchao,
>
> On Wed, 10 Sep 2025 13:23:10 +0800
> Jinchao Wang <wangjinchao600@gmail.com> wrote:
>
>> Introduce arch_reinstall_hw_breakpoint() to update hardware breakpoint
>> parameters (address, length, type) without freeing and reallocating the
>> debug register slot.
>>
>> This allows atomic updates in contexts where memory allocation is not
>> permitted, such as kprobe handlers.
>>
>> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
>> ---
>>   arch/x86/include/asm/hw_breakpoint.h |  1 +
>>   arch/x86/kernel/hw_breakpoint.c      | 50 ++++++++++++++++++++++++++++
>>   2 files changed, 51 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
>> index 0bc931cd0698..bb7c70ad22fe 100644
>> --- a/arch/x86/include/asm/hw_breakpoint.h
>> +++ b/arch/x86/include/asm/hw_breakpoint.h
>> @@ -59,6 +59,7 @@ extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
>>   
>>   
>>   int arch_install_hw_breakpoint(struct perf_event *bp);
>> +int arch_reinstall_hw_breakpoint(struct perf_event *bp);
>>   void arch_uninstall_hw_breakpoint(struct perf_event *bp);
>>   void hw_breakpoint_pmu_read(struct perf_event *bp);
>>   void hw_breakpoint_pmu_unthrottle(struct perf_event *bp);
>> diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
>> index b01644c949b2..89135229ed21 100644
>> --- a/arch/x86/kernel/hw_breakpoint.c
>> +++ b/arch/x86/kernel/hw_breakpoint.c
>> @@ -132,6 +132,56 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
>>   	return 0;
>>   }
>>   
>> +/*
>> + * Reinstall a hardware breakpoint on the current CPU.
>> + *
>> + * This function is used to re-establish a perf counter hardware breakpoint.
>> + * It finds the debug address register slot previously allocated for the
>> + * breakpoint and re-enables it by writing the address to the debug register
>> + * and setting the corresponding bits in the debug control register (DR7).
>> + *
>> + * It is expected that the breakpoint's event context lock is already held
>> + * and interrupts are disabled, ensuring atomicity and safety from other
>> + * event handlers.
>> + */
>> +int arch_reinstall_hw_breakpoint(struct perf_event *bp)
>> +{
>> +	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
>> +	unsigned long *dr7;
>> +	int i;
>> +
>> +	lockdep_assert_irqs_disabled();
>> +
>> +	for (i = 0; i < HBP_NUM; i++) {
>> +		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
>> +
>> +		if (*slot == bp)
>> +			break;
>> +	}
>> +
>> +	if (WARN_ONCE(i == HBP_NUM, "Can't find a matching breakpoint slot"))
>> +		return -EINVAL;
>> +
>> +	set_debugreg(info->address, i);
>> +	__this_cpu_write(cpu_debugreg[i], info->address);
>> +
>> +	dr7 = this_cpu_ptr(&cpu_dr7);
>> +	*dr7 |= encode_dr7(i, info->len, info->type);
>> +
>> +	/*
>> +	 * Ensure we first write cpu_dr7 before we set the DR7 register.
>> +	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
>> +	 */
>> +	barrier();
>> +
>> +	set_debugreg(*dr7, 7);
>> +	if (info->mask)
>> +		amd_set_dr_addr_mask(info->mask, i);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(arch_reinstall_hw_breakpoint);
> Please do not expose the arch dependent symbol. Instead, you should
> expose an arch independent wrapper.
>
> Anyway, you also need to share the same code with arch_install_hw_breakpoint()
> like below;
>
> Thanks,

You are right. The arch-dependent symbol has been removed and the code 
is shared

with arch_install_hw_breakpoint() in the next version of the patch.

https://lore.kernel.org/lkml/20250910093951.1330637-1-wangjinchao600@gmail.com


>
> diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
> index 89135229ed21..2f3c5406999e 100644
> --- a/arch/x86/kernel/hw_breakpoint.c
> +++ b/arch/x86/kernel/hw_breakpoint.c
> @@ -84,6 +84,28 @@ int decode_dr7(unsigned long dr7, int bpnum, unsigned *len, unsigned *type)
>   	return (dr7 >> (bpnum * DR_ENABLE_SIZE)) & 0x3;
>   }
>   
> +static void __arch_install_hw_breakpoint(struct perf_event *bp, int regno)
> +{
> +	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
> +	unsigned long *dr7;
> +
> +	set_debugreg(info->address, regno);
> +	__this_cpu_write(cpu_debugreg[i], info->address);
> +
> +	dr7 = this_cpu_ptr(&cpu_dr7);
> +	*dr7 |= encode_dr7(i, info->len, info->type);
> +
> +	/*
> +	 * Ensure we first write cpu_dr7 before we set the DR7 register.
> +	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
> +	 */
> +	barrier();
> +
> +	set_debugreg(*dr7, 7);
> +	if (info->mask)
> +		amd_set_dr_addr_mask(info->mask, i);
> +}
> +
>   /*
>    * Install a perf counter breakpoint.
>    *
> @@ -95,8 +117,6 @@ int decode_dr7(unsigned long dr7, int bpnum, unsigned *len, unsigned *type)
>    */
>   int arch_install_hw_breakpoint(struct perf_event *bp)
>   {
> -	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
> -	unsigned long *dr7;
>   	int i;
>   
>   	lockdep_assert_irqs_disabled();
> @@ -113,22 +133,7 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
>   	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
>   		return -EBUSY;
>   
> -	set_debugreg(info->address, i);
> -	__this_cpu_write(cpu_debugreg[i], info->address);
> -
> -	dr7 = this_cpu_ptr(&cpu_dr7);
> -	*dr7 |= encode_dr7(i, info->len, info->type);
> -
> -	/*
> -	 * Ensure we first write cpu_dr7 before we set the DR7 register.
> -	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
> -	 */
> -	barrier();
> -
> -	set_debugreg(*dr7, 7);
> -	if (info->mask)
> -		amd_set_dr_addr_mask(info->mask, i);
> -
> +	__arch_install_hw_breakpoint(bp, i);
>   	return 0;
>   }
>   
> @@ -146,8 +151,6 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
>    */
>   int arch_reinstall_hw_breakpoint(struct perf_event *bp)
>   {
> -	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
> -	unsigned long *dr7;
>   	int i;
>   
>   	lockdep_assert_irqs_disabled();
> @@ -162,22 +165,7 @@ int arch_reinstall_hw_breakpoint(struct perf_event *bp)
>   	if (WARN_ONCE(i == HBP_NUM, "Can't find a matching breakpoint slot"))
>   		return -EINVAL;
>   
> -	set_debugreg(info->address, i);
> -	__this_cpu_write(cpu_debugreg[i], info->address);
> -
> -	dr7 = this_cpu_ptr(&cpu_dr7);
> -	*dr7 |= encode_dr7(i, info->len, info->type);
> -
> -	/*
> -	 * Ensure we first write cpu_dr7 before we set the DR7 register.
> -	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
> -	 */
> -	barrier();
> -
> -	set_debugreg(*dr7, 7);
> -	if (info->mask)
> -		amd_set_dr_addr_mask(info->mask, i);
> -
> +	__arch_install_hw_breakpoint(bp, i);
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(arch_reinstall_hw_breakpoint);
>
-- 
Thanks,
Jinchao


