Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEF64CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 13:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2BC380054; Mon, 27 Oct 2025 09:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03778000A; Mon, 27 Oct 2025 09:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C401A80054; Mon, 27 Oct 2025 09:38:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B011D8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:38:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 42306160110
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 13:38:13 +0000 (UTC)
X-FDA: 84043998066.11.F814050
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5C91240012
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 13:38:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761572291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yg4tHkrWB8iD6I0E177EhXaJTLbrmVH+67p7EVU8ik0=;
	b=kUEwOLRNxz89s7aPfmG2rVS+OnAgYh34DgnAdHgOyFNftXj/2tmPvXpb6Lo0d28VQs5Uw+
	aSSlAmPmpdQFCuWZZbXKtNDfI1ZJjkJgvaSIhcGWJWnIkPVFBjC+khu36WFKPh4Q6N98TL
	QDlIOYXOuZAIShbrjyC3XSkTzwE1Sy4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761572291; a=rsa-sha256;
	cv=none;
	b=4P5rXgBM/CMvrsSNH4sTxXSKl7TYi/CHPNxkfsD/9vSrp5b1hVu2AsiIQcwKJgXhoDl6/q
	U8BwRtNG8I7RL72b9+cZU0f79PDymIu9cEO7gTIgNalu5lL5boO8LRfe4XNkHjoCLIuI9g
	NG89IcYOSsAA8X5EluISLghmMbRzyz4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 593A4175D;
	Mon, 27 Oct 2025 06:38:02 -0700 (PDT)
Received: from [10.57.68.196] (unknown [10.57.68.196])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0FD233F673;
	Mon, 27 Oct 2025 06:38:02 -0700 (PDT)
Message-ID: <1db69026-199c-4cee-bb3b-1217f8a3afad@arm.com>
Date: Mon, 27 Oct 2025 14:38:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/13] x86/xen: use lazy_mmu_state when
 context-switching
To: David Woodhouse <dwmw2@infradead.org>,
 David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
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
 <20251015082727.2395128-12-kevin.brodsky@arm.com>
 <f0067f35-1048-4788-8401-f71d297f56f3@redhat.com>
 <348e5f1c5a90e4ab0f14b4d997baf7169745bf04.camel@infradead.org>
 <6ed9f404-9939-4e9f-b5aa-4253bef46df1@arm.com>
 <7324616a8d2631aa8132f725f9f6551e3e6b21dd.camel@infradead.org>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <7324616a8d2631aa8132f725f9f6551e3e6b21dd.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: ohg9uar6j7tommsif45zbj1a36ydg4uy
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C91240012
X-HE-Tag: 1761572291-749188
X-HE-Meta: U2FsdGVkX1+AFkuaftXatRlQso19j8ET6RRPSyljdaRNzUTfa/icdDR9s/i2Aihq7Hmq9SMFKfLIYTjzQ5KKXwJm2yDBEq1atYU030khE6ILKp6n0bJ0pYBQwg6wfJdiFdcS6mTHWER6vNqnXuUvCaSX8vYnxg3Hd9jrba5x52BMrNoyJR06hlguDs0cX7cV/2F72XXy2JmF0UWwHGs5ypmE59OrqWcIhr76sioFY87fVNO13L0fvtBtHVjHCHJwwwMcSLno24ohvWPWSAFH8lkpDqvsLU2DujxPM8b6fNKWyqMffkrnGFrnYDgmYa/q5EYwOskYVzaoj/XUWtvrPseXbSfee5HSYqXOhJ4QEkUgrscmxD2yqwp3gsAsGdBqLb7LZphPwk1+BZrj4l82R5+zSC0+M8w/1vurBZ5Q3bB3Bef3QPhCDAlLq7tFNLFiEfNApZrYG+nQCH9MtUuhiPjf/qKm1x0HDjGTCgJUoFsHYck2ILt6cBXJ9HXyOj4sxC3POyqa7v6FPwBviZt6flSOZkRd/fGKQAQyhYLfcQQDEyY53ir7rCzOwC8/J/zqdgCC1HeSnj/+0+/XnDo9vh6V12c0tofu70RxFqU/i2jjd1OWzHDviQIGfUKz3lb0MEVxPmGbm6WHQNf+py+vxIeFTXuTPeeVKDRfT5xlSHCu4wnZJrs+BiJXIfW+j1Oe142hEnEhFgVFAiNEmmZQf0lS3eC00OKinqqotGFHD0Mq5onMEJBzGVt5Cm1b5vjs0cjRoJmuDId8OvuMBc8WCHmsSWYKVgA42kMGoHqxxjcEcRiKg6GBfpb5k/a7BCkyZxBaYnLSv+eEfHU0A+t6b71CoK7/kXAxblBbJ81V1M+p30jlGrD6Sg50s4GN+5wEi0uEoQm6ia3H775Kw0Y6gwgRHAIk2xn+7jRP9n4Ccr6XQi8b7e+iK1Ad6bOrPBdImY3mmSxXP0CrBBgKBN6
 h2AxNl+B
 gABH1BULMXio7lnSo1/XGCa4njLRv9kYg/CiCgqSnu72pCdcf3GEHndlDnfKlvK2uupDjeDhVnXQJqQqcqL8mcf1VxlZ4vqDU5Hb8GnP5ggrWS+C5TRvae3f/fy0WVh6qyuo4NB/Uhqupzv9AyHCvD4zT7B5sQ9V6VeR5Drg4QbR2LyXCx+I6YRGAYjmnZ8rMbk6hDhlBaMeY9vwjKJnxoUzTSsUMtQJIvUY2iJo6w/O0Zn3Y7ZGc98dsuPBwmil5afIGxZXf6UNlgAYXFsHUp1GnTyZIfot3nbyhcGi0rI7XofzbgvCMZLcPYbD/oGlpYtAtpY3IEQ+36LE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/10/2025 17:17, David Woodhouse wrote:
> On Fri, 2025-10-24 at 17:05 +0200, Kevin Brodsky wrote:
>> On 24/10/2025 16:47, David Woodhouse wrote:
>>> On Thu, 2025-10-23 at 22:06 +0200, David Hildenbrand wrote:
>>>> On 15.10.25 10:27, Kevin Brodsky wrote:
>>>>> We currently set a TIF flag when scheduling out a task that is in
>>>>> lazy MMU mode, in order to restore it when the task is scheduled
>>>>> again.
>>>>>
>>>>> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
>>>>> mode in task_struct::lazy_mmu_state. We can therefore check that
>>>>> state when switching to the new task, instead of using a separate
>>>>> TIF flag.
>>>>>
>>>>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>>>> ---
>>>> Looks ok to me, but I hope we get some confirmation from x86 / xen
>>>> folks.
>>> I know tglx has shouted at me in the past for precisely this reminder,
>>> but you know you can test Xen guests under QEMU/KVM now and don't need
>>> to actually run Xen? Has this been boot tested?
>> I considered boot-testing a Xen guest (considering the Xen-specific
>> changes in this series), but having no idea how to go about it I quickly
>> gave up... Happy to follow instructions :)
> https://qemu-project.gitlab.io/qemu/system/i386/xen.html covers booting
> Xen HVM guests, and near the bottom PV guests too (for which you do
> need a copy of Xen to run in QEMU with '--kernel xen', and your
> distro's build should suffice for that).
>
> Let me know if you have any trouble. Here's a sample command line which
> works here...
>
> qemu-system-x86_64 -display none --accel kvm,xen-version=0x40011,kernel-irqchip=split -drive file=/var/lib/libvirt/images/fedora28.qcow2,if=xen -kernel ~/git/linux-2.6/arch/x86/boot/bzImage -append "root=/dev/xvda1 console=ttyS0" -serial mon:stdio

Thanks this is helpful! Unfortunately lazy_mmu is only used in the PV
case, so I'd need to run a PV guest. And the distro I'm using (Arch
Linux) does not have a Xen package :/ It can be built from source from
the AUR but that looks rather involved. Are there some prebuilt binaries
I could grab and just point QEMU to?

- Kevin

