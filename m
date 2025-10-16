Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA4B1CCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 07:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 263488E0009; Thu, 16 Oct 2025 03:32:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 214268E0002; Thu, 16 Oct 2025 03:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1031A8E0009; Thu, 16 Oct 2025 03:32:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EFE0B8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 03:32:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9512E855AD
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:32:31 +0000 (UTC)
X-FDA: 84003159702.24.B7F65F8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id CF80E40008
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:32:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760599950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SK6RxrxNXxRFLxyAYlYq9aaMejSm4vU8SsNeGUxqVQo=;
	b=xSO4fj+eNGM0KGLfs1ss+OtLPC0xqZhORwdWEpWwU2zmXLph5vBajvTS5AR5u7+7dgb47c
	pRy1f84fPuYoTuI9Dz0h9Gj5OsUaCxEregJMfXAXeAGq7Zjcepmr9zn9ruHuH8NDlpn4k9
	KR5UQ1YyzH42e9fjfH5OocDRyk5EIOM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760599950; a=rsa-sha256;
	cv=none;
	b=ry0XCrhnp8rwByBzr/UhdvDRkSdQU7J8z8Zgqj4hiedM+wWJAFuqNxvhLm1BCR8T3tYPXp
	xLodfpVpTDlv5rrdo6dLtrelSCKq303//h19AU6u1CoiRLIFWUwazNTTxWciwp9QQQigDN
	X9F/LzWyxlE+E0XTgw+isbIMA1vykPQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B64F21688;
	Thu, 16 Oct 2025 00:32:20 -0700 (PDT)
Received: from [10.57.65.134] (unknown [10.57.65.134])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3F1683F6A8;
	Thu, 16 Oct 2025 00:32:20 -0700 (PDT)
Message-ID: <54f183bb-33ce-4b9c-91a9-827a6ed198d6@arm.com>
Date: Thu, 16 Oct 2025 09:32:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/13] x86/xen: simplify flush_lazy_mmu()
To: Dave Hansen <dave.hansen@intel.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-3-kevin.brodsky@arm.com>
 <35d9cf4f-135e-4786-a4e3-fd3a4a18b800@intel.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <35d9cf4f-135e-4786-a4e3-fd3a4a18b800@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CF80E40008
X-Stat-Signature: bwgu8de7f1t16wwya6hmom5pih954sf1
X-Rspam-User: 
X-HE-Tag: 1760599949-705585
X-HE-Meta: U2FsdGVkX18uTwtmk0sj07Dq+zGJtlYXd2GBr4h9SQiFwKQBzdHgDOr9IwwB1ZUfy59UGiUCJUMG877en6gbwvE443aB5SKuVbIoJEzgqkqKhQL/GfyUtb0ukaivpO86hAnqGGjBvsvgmdSjnnzVwbcmuFeZtvKOMK+dI5TytdAoLtXTTMz7778xjPiNMrCxHRjc7T84F2687LN4IfijqzCEYUsGkoby+DNjUs+dN0lhGKMuFVk8E+UXe64F9vep6kFy4+2GBOHsKCd4ZHVkaGDKh9hp5xfmnf/gOnkbEO3kqmI8y9jZh0MPOX2aCS47Le3mhcpxir42Mlnxjzi8b1brgytUmj/334G3l2d+F+vZeCskOOkrmglUb588diQmHOXMou36xBFhtXXD6cyBCe0BqES5ehLoudnMaP1Rnu/vRmT27MHfgAzEapACpVdL6YYgedm4Ft5FaBlDbfXGuG5A2snKop7wwqPK4Fn/hftgLxZZn0T/COWQlxybuo7OollultpMmUe7JOILAb2WjH7/Hl1pXm+bP3MPydeyCMfTJOHCf/m+vztaGC6M5wMFbw878HqVDzYO8yuHFLUd473V9vGCdSZwaWSxUxueOsjR6Yq5mSnA/a85KrqUMnHc0QopSi2jMqrG+2+6FSmuMOn/IHn3ZacZCwYxO3P3hiEAndJUQ07cquOtIY9CLkx3ziTP6cydDPcLQa01PSmKTWzJIqb/YT6v2GQ56E82UolOylplCdHcehMeAWmIGXsUsxvEEKXhFbpjE3VZCSvcTi9Ws2c90qLE+6iyu3wtWJQCtYL/2sSrv9IuKlxCCTAfQNRbr6D+JNOAsMEkXSxBpvfSg5NXw4AJKS6rIwvpkV5iG6pbaF9hfCwsXlspRt9gdc5ggpTvNtriS0dpLfy3CTx3DX24/mHVJI5anETxeB0w5+bgIBNjoP29ICUohtaZ9NgES57xpjxkdbbHuqd
 /i5SxpAc
 mIH9dgjxd5ihpZPWZ984uB1O/qM5Zjop1ZayRIBbBLfC0pjG6NVKgzzZ/JcUG/zUI4MmA7Esc6VPBr87JirjfVkpZwefimT+4v0pfA+UP9cVElQLARlnlihKjnvkGOhkwqEHHI3aVnrkfXjXN/xsWrQxQD5NlkpjykgxQw+6M0L71SEWU4QFIp+9xK+HJ/JTwlg9/jC89AAWciRhfD7Sl1Q8cDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/10/2025 18:52, Dave Hansen wrote:
> On 10/15/25 01:27, Kevin Brodsky wrote:
>> While at it, we can also avoid preempt_disable() if we are not
>> in lazy MMU mode - xen_get_lazy_mode() should tolerate preemption.
> ...
>>  static void xen_flush_lazy_mmu(void)
>>  {
>> -	preempt_disable();
>> -
>>  	if (xen_get_lazy_mode() == XEN_LAZY_MMU) {
>> -		arch_leave_lazy_mmu_mode();
>> -		arch_enter_lazy_mmu_mode();
>> +		preempt_disable();
>> +		xen_mc_flush();
>> +		preempt_enable();
>>  	}
> But xen_get_lazy_mode() does:
>
> 	this_cpu_read(xen_lazy_mode);
>
> Couldn't preemption end up doing the 'xen_lazy_mode' read and the
> xen_mc_flush() on different CPUs?
>
> That seems like a problem. Is there a reason it's safe?

You're right, I was thinking in terms of task, but xen_mc_flush() does
operate on the current CPU (and it's called when context-switching).
Will restore the original order in v4.

- Kevin


