Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31E48CFC29B
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 17:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842126B0023; Fri, 21 Nov 2025 12:50:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F33E6B002E; Fri, 21 Nov 2025 12:50:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E1C96B008A; Fri, 21 Nov 2025 12:50:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5D0E06B0023
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:50:22 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2FC581A0650
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:50:22 +0000 (UTC)
X-FDA: 84135353484.23.364FA23
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf16.hostedemail.com (Postfix) with ESMTP id 743D6180011
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:50:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FVyheUlJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763747420; a=rsa-sha256;
	cv=none;
	b=o3o+Jp2qdbsBEAHSO2Mjx4qkkTD6igGDLNttGwfHi0X4m/NqbDtn20r2Atk/Av+LnOg8un
	aSL8Ov4xzMh6JZphUsJscteJ/BwTibTgEyrOs6Uy7GcNEo3LDndjLuwW0M+OPSa6D4Hl+N
	hXFkpi153ax59fMwb6vqi59mccdGYZg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FVyheUlJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763747420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbpdozOYhy0BMLI8lFThkkg/d76zv4kCPJ/fwh1/PTM=;
	b=yyLctM8ZlrNKRmBp0yq0ELlK46NlEM5g7nK03q4Ba31SJZN+EBxT9/DM9OEKYITAWsTbtj
	/lGh/0sl9VbGvHHFhI69YuTtb3KL5XemOHQf/6rPjUeW1rmSILCVTgDI7tIxrAGCdLkdcN
	pPeB7MdfD7rYtmqRCBR78zToBbbeIzs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763747420; x=1795283420;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YckklQG/5FwUbczH+x3i0icUWdCO2DJMQNFuo3RKWck=;
  b=FVyheUlJzVhJL3JGisYBBEkTlXOmx8yCJ5XvE8PCn2ptH6noFN/Mtv40
   /I3vByKjLnHoqkLiww3VU/NOY/MlPRkLeUyAKG1V4CFhS1gXOxnCqP1Ej
   Wre4+R8kYUUFUarf0df/QEtQhtajubJQld0Gxz4+YYe8pnr3Jb/sPHMrn
   s6HPF2ZNSlaauiSS8ygN34RxGGXnX4jbQ/dbwNMewFZWC50AKwGA2Cg5i
   qUELmN3lWL+O4TXAQZ//bP/ZfZ02G/u90AcxR6rq7zz1pKMxyh9vDlC7b
   wh9W/eyiUnNhqxVSMypVcI+uLfGbc7BzeAwQHZ0KwYMzfZNgLYoZPo7Ba
   g==;
X-CSE-ConnectionGUID: oyHf2g22RCOcYpyEPIpLZA==
X-CSE-MsgGUID: cM2h7DEEReatPXff/kJc5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11620"; a="69465921"
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="69465921"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 09:50:17 -0800
X-CSE-ConnectionGUID: TALVmW4IQoSpoxqsJrQTWg==
X-CSE-MsgGUID: pw0Ufr6DT1ewmiN2aWhOIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="222378181"
Received: from schen9-mobl4.amr.corp.intel.com (HELO [10.125.110.60]) ([10.125.110.60])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 09:50:15 -0800
Message-ID: <2837ea3e-c0b8-46b0-b8da-bf06906d124d@intel.com>
Date: Fri, 21 Nov 2025 09:50:14 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v7 30/31] x86/mm, mm/vmalloc: Defer kernel TLB flush
 IPIs under CONFIG_COALESCE_TLBI=y
To: Valentin Schneider <vschneid@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, rcu@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker <frederic@kernel.org>,
 "Paul E. McKenney" <paulmck@kernel.org>, Jason Baron <jbaron@akamai.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ardb@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>,
 "David S. Miller" <davem@davemloft.net>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Masahiro Yamada <masahiroy@kernel.org>, Han Shen <shenhan@google.com>,
 Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>,
 Dan Carpenter <dan.carpenter@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>, Clark Williams <williams@redhat.com>,
 Yair Podemsky <ypodemsk@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
 <20251114151428.1064524-10-vschneid@redhat.com>
 <bad9eaaa-561a-498a-90d1-fe3a3ab8ba37@intel.com>
 <xhsmh5xb3thh6.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <xhsmh5xb3thh6.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 743D6180011
X-Rspamd-Server: rspam07
X-Stat-Signature: qjuz48erzhphsyk4fhuhfg33u41ojrex
X-Rspam-User: 
X-HE-Tag: 1763747419-92599
X-HE-Meta: U2FsdGVkX18a2SpCbqxEYtuq5WDOACFq6zf9de31X930OpylIeQ5Yy+uOf6I8u7MpP4sFcgm+tfXxifaCvaY3F1gxcmL4OJh1QWRAcfWa/+l0cRncLMZ6s08pO0tcOZlLljSHx7NYqAP/E65sKmdeWh6UL4MjAuRFYaIVqLFvkEavrC0jvYW4UMswFf5HkHK6IQR9kO7hLOKR467tvow2OBRbhMiH3vF9g0v5JTyX9SJxig1vzWQQmOuZiJquvyUPbqUu5BiNSbQsUd7LxcVJVcSE3q7vAZrm05xVNaK0svW8ZKwh9VMzR+1SG5oyX0Cl9wULJpkFyJIy1b8/Eyd25onGVsyiU7SI91EduSFBK2JaTVu1VTz5W2UEOsqK1wuTNWQjflGbPPhlhQqr0vHbKEnxQc1w0W/TA7VrAtmeJDxzpDysjnsEik6tPmS2Jw4vqfGFUF/jXtSaceJztyJwpS4wriOzd6n6x3YOhZnZb3+yLjekLAzlG8xtafQcJA1xaFgylcI7wrCmPCuH2YlZg2PaXtqjw1jnjedwNdICdEr1VRXm0Sr71DZaBf6SYy/7AVO84KR+VGr/IksdgLai+lstB/qRCXJ4t4OxSbFNkK6UheheJlTI/Ft+05FQni8EfTl7jq4pUNkust2GO60u6oJi+UU0B7gmieIQBkEDU3f2C3H6+sI4YyPl59wcURlpVxmEgbyvugKpGxoFCpHuOUf/J1onVDXY7CHme0l5IVJcWZBERphybJVHjbBkFc8iaLzaVawCNl6cHbYUJw+sV4kVd0PFo1g+Scwf1JPqRnOYtCQUy6pConAHqI/YZZ268a5HNrmtP0f5Cpwi8RGOzQhAF/rW+sDMisbcnnroJshquD+wHUtuO7bnX1nIuyJM/demWMWh6VWVU1PjFe1VtzuAETGImFepHTkXUBv5OIGxkkOZR+kLeqy2/HWv7niTPoVqkV5M5ccWOJN+kl
 D+qiSXQq
 K2OWkccmLco5XZXA7ie0VTI8nx6i2Doh0SDdW7QMnbsg/mgYryI/cNY9CEkNfTqSyIntxfTPoCndKUwJCyn80kndmflpS8sEwKz54aBIRGNazeYH5Qo5/1GoguFKd67zDAEYVCOo1RHORIIbQaEfMCHTVAIl0Yb+5Ke7nphIYgQgeTXFoT70+ozUXkk1zWLqsSwo1XRNlsXYYDPPqfLSkeckM8wm5Hm+YHE1I/Z5gVUlx2SSbGhgXNkg0NHyOju1QJ43JOgj1Hj4qz5ETkTBSEMVb9bX0WYZBGcEr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/21/25 09:37, Valentin Schneider wrote:
> On 19/11/25 10:31, Dave Hansen wrote:
>> On 11/14/25 07:14, Valentin Schneider wrote:
>>> +static bool flush_tlb_kernel_cond(int cpu, void *info)
>>> +{
>>> +	return housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE) ||
>>> +	       per_cpu(kernel_cr3_loaded, cpu);
>>> +}
>>
>> Is it OK that 'kernel_cr3_loaded' can be be stale? Since it's not part
>> of the instruction that actually sets CR3, there's a window between when
>> 'kernel_cr3_loaded' is set (or cleared) and CR3 is actually written.
>>
>> Is that OK?
>>
>> It seems like it could lead to both unnecessary IPIs being sent and for
>> IPIs to be missed.
>>
> 
> So the pattern is
> 
>   SWITCH_TO_KERNEL_CR3
>   FLUSH
>   KERNEL_CR3_LOADED := 1
> 
>   KERNEL_CR3_LOADED := 0
>   SWITCH_TO_USER_CR3
> 
> 
> The 0 -> 1 transition has a window between the unconditional flush and the
> write to 1 where a remote flush IPI may be omitted. Given that the write is
> immediately following the unconditional flush, that would really be just
> two flushes racing with each other,

Let me fix that for you. When you wrote "a remote flush IPI may be
omitted" you meant to write: "there's a bug." ;)

In the end, KERNEL_CR3_LOADED==0 means, "you don't need to send this CPU
flushing IPIs because it will flush the TLB itself before touching
memory that needs a flush".

   SWITCH_TO_KERNEL_CR3
   FLUSH
   // On kernel CR3, *AND* not getting IPIs
   KERNEL_CR3_LOADED := 1

> but I could punt the kernel_cr3_loaded
> write above the unconditional flush.

Yes, that would eliminate the window, as long as the memory ordering is
right. You not only need to have the KERNEL_CR3_LOADED:=1 CPU set that
variable, you need to ensure that it has seen the page table update.

> The 1 -> 0 transition is less problematic, worst case a remote flush races
> with the CPU returning to userspace and it'll get interrupted back to
> kernelspace.

It's also not just "returning to userspace". It could well be *in*
userspace by the point the IPI shows up. It's not the end of the world,
and the window isn't infinitely long. But there certainly is still a
possibility of getting spurious interrupts for the precious NOHZ_FULL
task while it's in userspace.

