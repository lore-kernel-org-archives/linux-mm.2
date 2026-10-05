Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AABE1CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 14:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54F426B0088; Mon,  5 Oct 2026 10:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528486B008C; Mon,  5 Oct 2026 10:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4159C6B0092; Mon,  5 Oct 2026 10:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 21CA96B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:16:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F69B12028A
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:16:56 +0000 (UTC)
X-FDA: 85288774032.16.BFF1FBA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9154D1C000B
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:16:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bgzHUU6f;
	spf=pass (imf18.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791209815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXAyPFGuOfJvky6xwcn7tskfN6n5dL/Z9O3DSglTcqs=;
	b=nknECIm5Kl3f+J0HmMgHIAvyyBNcm5i95Uv14scZfQFBMidHdBiY+GmGI2YjOskcxAg6Fq
	wewc8u+xengiv/GbQj8+GQaZxupJo87bOHMz5LrhEI5RjL+lcYzBILn6/w30K3hYQXkxt4
	PiF7ZWaajbQqlGTm3FvZ4A0tD7mI/co=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bgzHUU6f;
	spf=pass (imf18.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791209815;
	b=vuBib+ZxxgJnfI0209e2G+jSrjZ4gWY74xOxlIE8WMrRl4vV+piVlqmOUl0MA0JnTabT21
	UPQiJXtwmsqCb4azQ8jCnZKPM0ZxCPTdB3KnbvNKIv07vLwQHThO3qLy4Woln8AVAcbBjk
	0wYh03W/ierZDc9xuYjGcqx3n6+Bs+Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1826F152B;
	Mon,  5 Oct 2026 07:16:50 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7F253F66F;
	Mon,  5 Oct 2026 07:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791209813; bh=g/PvErAkWqPLLMhfdp6s6oupiEeHn6mW6CPEnvMmZuM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bgzHUU6flQh4WV6N8wrHBOjkrnfRN1RjtIvlMsJTgnfprNOTNrWuI3ZbDwgLxQR6u
	 v7S8MV4n/CktpjfTJ9ZhjsMfIcAKAAGxPtN1AqraVPnHJIKph8wN59edTO4IJ6CtLR
	 dvUlUakISZh2+PUjuHQ8j7SIV0IRr3EekSiHKrfE=
Date: Mon, 5 Oct 2026 15:16:38 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" <linux-arm-kernel@lists.infradead.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)" <bpf@vger.kernel.org>,
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/7] arm64: Batch PSTATE.TCO handling in kernel nofault
 loops
Message-ID: <asOxRkayznzX-K4c@arm.com>
References: <20260824160523.3907021-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824160523.3907021-1-usama.anjum@arm.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9154D1C000B
X-Rspam-User: 
X-Stat-Signature: 7xczuwju963ehtusfdf7gowb18tc1nfw
X-HE-Tag: 1791209814-541247
X-HE-Meta: U2FsdGVkX18NOPH81I4WAIU8D9Hr/oHc5g8qLM9fvbYWzEdPG/jdpOeIoYu1r74Qnq8Vl0Sc4yj+peQc9AV4TP8c20cmg330rsBvwXJrIwh7/6xmp/LDrctrSskcHSCLVJtEQ0NB73s3nGQSPdIeFg2bNz8mV1Jn6UhaW5pHR0/BEdL8jzhxrN9j1WM1MrBzcyg4OkxvISP11w8k+6/K5pCQRjfVV8//w3iu0wPAp9ta36zEEITIaXiOsnb4ezVop6dY5x6T6STwNaC+aeAxJH8V+JSeBglOBWenOG2xJJ86MOECPSRz9EiZ+Iwzy/D5qz1YHBUq18wq86jBVsUhrc8xuah1TU7Im6Zb8nhLcXpdyEEdxbdE1p5W4UZsniXKpjrU6j8FDVMXp3BlL3MBOxggM0/5B+vM5yd1Qzg1SdlK88C82dcxV7hlF7lVt2iHJAp+XRjvoez7exAzCqQTrY89blT91CRNZR2F9ahU7Rt44gsS+zO1vzMl7saDya9BsqzT9uCOSTcXFYkJeQAISVzWeon5l7WtfWhZSL4SN33PJdcGq+4TsKy3OI4SM+l/Y5iwB63WJy8x/44zcctjM4OMvRmqAzAV+UlHjWm76OtYsckOYWnvB0EjfVkWclOZKMtH4QJJlp+CJo0r05oJOfF4Qs02meEU29us/sml+iDhDrbB+H7ygp4883XRNTq6tyC6siiN882bWxPVYTahIjeYWXtoOT66oQnr101+5Gt3CKp7ZqCJD581/UV0ZvczIYib52HTrFaIwDmpnd88Oz+/5Y5y0nVO8PP0YYxDhRzJ92VcsLohd+Bh6G/YdqBqBG8p8+Qgdrgp3DQ2tb4i3Efu8VQ1J/QU9HrlNDe08SRffCxIYLPwLljYrCR0l728tlFpOT/SxspT1fPCzKqnH/hkjqysNpPij5Dr4O38aWypfEOi4pK7nvHAp5x1kSpa0Kmb7ZSLih9JWErRVW6
 SOQEctLs
 O3SoQ4YUXKhZZccGKpqmYmL0S2bn4D8l37k47E7JtuBAa4icgDVE+kR5nSKKd1vHxNmIdrIFdEdCEs6tkJPkvYCoc6RRaSqQTECGUdxc9tWYnO93qM0rklATxUzqmLzc33kVv52Updtfn9wn9bOiECYHWhQG2Ku3I2cSghsp0uM1aCR5Ociibl/1Zt1beR93sTu4JypR5xTc+wKZw1Ksf07afM3Tg7MUtkSzxfCAQ1UItc7M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 05:04:45PM +0100, Muhammad Usama Anjum wrote:
> With Hardware Tag-Based KASAN in asynchronous or asymmetric mode, kernel
> nofault loops currently set and clear PSTATE.TCO around every access.
> 
> Introduce bare nofault accessors, batching hooks, and an internal scope
> guard. Convert maccess page-fault cleanup to scoped form. Skip
> page-fault setup for zero-sized kernel nofault copies and zero-length
> BPF string operations. Then use bare primitives in the maccess and BPF
> loops. For non-empty operations, this reduces the code-derived dynamic
> MSR TCO execution count from 2N to 2. Two-string BPF comparisons fall
> from 4N to 2.
> 
> The BPF changes and an earlier maccess implementation with explicit
> cleanup were tested with QEMU arm64 using Hardware Tag-Based KASAN in
> synchronous, asynchronous, and asymmetric modes. All nine arm64 MTE
> kselftests passed in each mode, as did the 138 focused BPF string_kfuncs
> and varlen subtests. The focused BPF tests also passed with the default
> non-MTE arm64 CPU model. Both final maccess scoped-guard patches were
> arm64 cross-built. Runtime tests have not been rerun after that
> conversion.

TBH, I fail to see the benefit. There's a reduction in the number of
MSR instructions executed in async/asymm mode but does it result in any
improved benchmark numbers? Which workload hits these loops often enough
to matter? They are mostly used by tracing and debug code.

AFAIK, most people wanting to use KASAN in a non-debug environment want
to go for sync mode, where there is no MSR and this series only saves a
few NOPs. We might as well go for a config option to force sync mode (or
off) and remove the unnecessary NOPs, *if* you can show any performance
improvement.

-- 
Catalin

