Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5270CCFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 12:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D7736B0005; Thu, 27 Nov 2025 07:45:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 788226B0023; Thu, 27 Nov 2025 07:45:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 676B96B0029; Thu, 27 Nov 2025 07:45:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52CE66B0005
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 07:45:47 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F2E80C0121
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:45:46 +0000 (UTC)
X-FDA: 84156358692.26.6AFF28B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id DF923140014
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:45:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764247545; a=rsa-sha256;
	cv=none;
	b=F0vYozwgHanDa2+lPE00BvZOwzZrfjJfczuwvO2ohC4yZ7wtnFztox/sSgWN56WfzJZkoU
	o77lbCgD5yopg5qwMOnqAFryBgOBAPu+W3P7ePKNamuAcYM4lLrWaCT4VSkZYZB2KSpODf
	O5rJnBSIEFiM2mC8UN8pTbxplG5S0x8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764247545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n5j7xH8fTEoSKbVxXFkE4YpsGUIr1lBxjhNUPeg+DYg=;
	b=aYJtn8iufYm/c79KPjmxO9h15FwEJ2AquxiIclQAQpoRx4ObcwX7lg53hPCeqv+zKfhKbw
	YQYgGSWbl9ZHd7Tjtj2tDO/0tSSS6aKYr5YDW0KXLfN4sOZ/RU78UwbZL8eTxO8McYrYFc
	GrL/5aMSv/vQi9QsArTGXN+GOtvXqcs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 11C781477;
	Thu, 27 Nov 2025 04:45:36 -0800 (PST)
Received: from [10.57.43.59] (unknown [10.57.43.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC00D3F73B;
	Thu, 27 Nov 2025 04:45:35 -0800 (PST)
Message-ID: <0cb512ba-de15-4ba6-a85a-8287ab67fb53@arm.com>
Date: Thu, 27 Nov 2025 13:45:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] mm: enable lazy_mmu sections to nest
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
 <20251124132228.622678-9-kevin.brodsky@arm.com>
 <4d0eab1a-e1dc-49cf-8640-727c9734233d-agordeev@linux.ibm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <4d0eab1a-e1dc-49cf-8640-727c9734233d-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DF923140014
X-Stat-Signature: c8hyr3pc47xzjajozak5sy411c9zoicy
X-Rspam-User: 
X-HE-Tag: 1764247544-136895
X-HE-Meta: U2FsdGVkX1/sg72JAzDszGDUlD/Q3rSTZmJ2JuZf1pUMWzc65kTp+alGOi7xIOCrJNIDkV2eAeVD5/CWni71TnYjB+eMtvhfzx0la9R9plMpY+QLp4TPbWljgyZwuOv2/wYUr86eMIOag263y0wDn4qlOkepU9koGd3Jamu/knX8xRA4XcWwWUVyPxpd+2iwocVdAHE++tPUAEiVMzgbnNmPk16QxL4OkcOhuJigIawpu1cqMbaqzGcSXpzBQE+tunnva6P9tgQkuB1wyrFeL1H0RptrRWFhIph+IY41w2MPdA6x82LDJ57TXhyHv/VchD3TlbIgUPko02j1OMZtV03vsN7Cfua0gsnNRr+C20GXkCEx95AJZEvGq9qvieOKg5RlwrXh7QHX6eVm8w1XJRtecrWcibaSJWQkZYfi052r9j9mplZMuEwpZntAs/RiUOkbA5lbcJjsG5C1mbdWuFyY7szuKIeb+bn2m34dIpR93uIwYfBnX7NfSaZwqa2wKM/Rfn23rO5nOHt508FQ7puAaVG1Cld9qwjLl2SKzibWx774qOJzHcGhvvB1rv/rykA6j0MsLGEwQ7C+Hp5Hpd/O3STK4vr/4W/vbu9k0+8eUvO5pM6z+qucWLVe6Iw4N7N8HtMRmAFb/CbKlG+/TedflNdRuMpXpspT5yCEz9EGHzeXTsmpOVzvOSydgdublOylAF0hr96/X44y9eOhFKJO6FWh3UJeCpIj0nXt2LKQLdxvKTQxhQzFHh+fnfStdvKtDu6VeJO1GZ7jCYFDJgJ5KNdBTM+t+m/RKtLA6JgXiSJrQRGyWKAi4/30rQTebkkahFjudwpscfZU9LHbnpWVwG+GdTs4Kyi4M0dulfI7ACVTK5VrSWcOehZMIsI1Em4TWaudwGi2Ntah3Fo+NVbSsj96LDoaWipUTb34LANocmVne4zjxHsQBanPvDjnLKv5QBSGz5o80JPHIo7
 8MRibasc
 2KKeR46WSnoUdP0yQUYDJofhOM0YksAw+RSsZqI4dn2cz6tNz9kE9gNYt02VindEszS2Inci3C6h3qZnXBv+YlITmbuXptfWdizgjDtdnQDPcZBu3uiDw4LgG5HGXJzRhhDSZHqOZpsHaLIhCNdhNregASzKSvmJ85wtu6PCc0ou+jom2R5WL/V4WtJWGZAVj2i5ZA2m4yP03UfQrueKTSKbJbRIbWuRgSYDGplpSSgpUaAsPH3djFwOLZEmgp2iYSHzM+tY4B163G9/J99RNm6PpS0Ai4Gb4gdB1G6jDtzeMIfTfXCiSGunVPB+1UEOg7onZKZKC9vSyjWKgoaS2h7cxEk6vBr5nnnaofLZggrKElw5DJGYyfYb1S4A6I474L557R1cFy3UVQmU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/11/2025 13:33, Alexander Gordeev wrote:
> On Mon, Nov 24, 2025 at 01:22:24PM +0000, Kevin Brodsky wrote:
>
> Hi Kevin,
>
> ...
>> +/**
>> + * lazy_mmu_mode_pause() - Pause the lazy MMU mode.
>> + *
>> + * Pauses the lazy MMU mode; if it is currently active, disables it and calls
>> + * arch_leave_lazy_mmu_mode().
>> + *
>> + * Must be paired with a call to lazy_mmu_mode_resume(). Calls to the
>> + * lazy_mmu_mode_* API have no effect until the matching resume() call.
> Sorry if it was discussed already - if yes, I somehow missed it. If I read
> the whole thing correctly enter()/pause() interleaving is not forbidden?

Correct, any call inside pause()/resume() is now allowed (but
effectively ignored). See discussion with Ryan in v4 [1].

[1]
https://lore.kernel.org/all/824bf705-e9d6-4eeb-9532-9059fa56427f@arm.com/

> lazy_mmu_mode_enable()
> 	lazy_mmu_mode_pause()
> 		lazy_mmu_mode_enable()
> 		...
> 		lazy_mmu_mode_disable()
> 	lazy_mmu_mode_resume()
> lazy_mmu_mode_disable()
>
>> + *
>> + * Has no effect if called:
>> + * - While paused (inside another pause()/resume() pair)
>> + * - In interrupt context
>> + */
>>  static inline void lazy_mmu_mode_pause(void)
>>  {
>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>> +
>>  	if (in_interrupt())
>>  		return;
>>  
>> -	arch_leave_lazy_mmu_mode();
>> +	VM_WARN_ON_ONCE(state->pause_count == U8_MAX);
>> +
>> +	if (state->pause_count++ == 0 && state->enable_count > 0)
>> +		arch_leave_lazy_mmu_mode();
>>  }
>>  
>> +/**
>> + * lazy_mmu_mode_pause() - Resume the lazy MMU mode.
>                     resume() ?

Good catch! One copy-paste too many...

- Kevin

>> + *
>> + * Resumes the lazy MMU mode; if it was active at the point where the matching
>> + * call to lazy_mmu_mode_pause() was made, re-enables it and calls
>> + * arch_enter_lazy_mmu_mode().
>> + *
>> + * Must match a call to lazy_mmu_mode_pause().
>> + *
>> + * Has no effect if called:
>> + * - While paused (inside another pause()/resume() pair)
>> + * - In interrupt context
>> + */
>>  static inline void lazy_mmu_mode_resume(void)
>>  {
>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>> +
>>  	if (in_interrupt())
>>  		return;
>>  
>> -	arch_enter_lazy_mmu_mode();
>> +	VM_WARN_ON_ONCE(state->pause_count == 0);
>> +
>> +	if (--state->pause_count == 0 && state->enable_count > 0)
>> +		arch_enter_lazy_mmu_mode();
>>  }
> ...
> Thanks!

