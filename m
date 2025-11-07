Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA1FCCCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 11:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE6DD8E0008; Fri,  7 Nov 2025 06:13:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE278E0002; Fri,  7 Nov 2025 06:13:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB9F8E0008; Fri,  7 Nov 2025 06:13:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 910F48E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 06:13:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 304BA1A0462
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:13:35 +0000 (UTC)
X-FDA: 84083550390.21.20F061B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 56DC71C000C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:13:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762514013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eCjmppFrEkfW27at5Tw7hdbaaeCwkxbhpSbepynfi98=;
	b=IYPG3rrpgui1htM3eoOx+f8jJBBvdZUPYtyUwIQwhBesRjhZs7izioPbKzlWIykW1Gjj9d
	FOiVlW1cnlNPkJXDjV3LO5J+IxUZXX9meizZ4DcfQMO3QL7o3TytO4Z3V4a6aTJXbopyIz
	/1Ex1DHMjKjQG8bn6UBaim05ta5YsVI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762514013; a=rsa-sha256;
	cv=none;
	b=f6RmuiP/cqmLroV6TaarocUFK9dK+C0IZCdETTPbvJ63pyZ8N6GRR7DrYGe+ytvt/PNbT/
	aStA6WjP+bBZccJzziYAbH5F8u+OdirNY3F7NfWeLsq++LQ3oJuWPUd4ZvyidXPJh9QTmC
	BpbApQU7406jEz5rkk1QoqSFP0GM2CY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 802C51477;
	Fri,  7 Nov 2025 03:13:24 -0800 (PST)
Received: from [10.1.36.52] (unknown [10.1.36.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 21B713F63F;
	Fri,  7 Nov 2025 03:13:28 -0800 (PST)
Message-ID: <84dab8b1-ea28-4dcc-9721-9aaa6fcd12ba@arm.com>
Date: Fri, 7 Nov 2025 11:13:15 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/12] mm: enable lazy_mmu sections to nest
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
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
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-8-kevin.brodsky@arm.com>
 <87ms5050g0.ritesh.list@gmail.com>
 <50d1b63a-88d7-4484-82c0-3bde96e3207d-agordeev@linux.ibm.com>
 <87ikfn3yvs.ritesh.list@gmail.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <87ikfn3yvs.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 56DC71C000C
X-Stat-Signature: rbycwh7gp16hxfngr3qmuc8ydjyqkkxs
X-HE-Tag: 1762514013-849660
X-HE-Meta: U2FsdGVkX19pia4+CS0A/yWS8vKwbRgnptc3xQ42BTCz08GJffUkOsUDPsVqshtxUE4wj45pdYqAozJYG7ZyR3vfgJuVwFAEWCx/uA6nM12EysSWEO5JQUhf0Ev1X0Ul9F9zWAHOal06qeC1rqu2dpHSy6CnVBLg57kIgag+Y7Y4nU8ebPBB9dsogC8i1S6sr5HN0DMH8nC4WazMrmeWxXgtrRwvF2+CioXtVzhScIq5FUvCSLVF9flRPARWa0rZfqZzbPith6MXBd0DBxp9lJrda3Ix2giMUyYvde0X1emE6wyHoiJu0jx84Gm1c9WyMsjOY/tY+Y6RMQ+g/H57xHmfn1NhWiKVm8zh73c6G6WHUNZzA1Who3A9Z1BQKebEJEuIBFszBLesx9j4O0tiTnfAVh3e/BYYEh7TD2h+jfM4BVXFBn7vn7m0Svi9DvbNE9WM1fdCNe5NW30VhvvolxNaRKD8fNhRM+2jvq4+stEjpN84eMdaxZ64ix01ShpGqp4ELq7u58r3Xe1yAq8sgrBXhiOSkn1B8RIpDKwwlT9UumGil2CM6D/t3oJz0I+3qwEobFqjhWIJRLslEQdEgX41A1pCwnL+8ZmvoTzqt5NH7mHZ+3EV7KmoQDZLQ3Tn5L409edmZE0TSnbHDVLpSu8uGLMIjBR/eIYshVhZFMs3fBVYY8L91G2R01nLdWKYx/KA4JCljxdkUpN+V5pUsg9DBiOezZDn2XiZGTidEKl1VGEaIZ22CPOZOKp+ZjfnBqD9rqS2fK3B9CU8Qjqhl4Zzk+BeGSrfzU/X4Zk0KGwtZho1V44qdrjJDYzoOGs7xWndk2ZbKq6p6X0ej9IQBOBDr/Z4F8HM2XepLvWvRIa5+e5ckOsjDku3NyfGnyS+o6wbELB9aPdjigH376H/MTE2DHetjuVx0Cx2u4QGvZHY8WYFTkh1JwPKKYuwwWbrQM/huMTS+mbhS38G4xX
 xESDti17
 adFpH9+qeWJjoMiB4P0jfb3q4nxBy8jHAVrZcP/vORpt4ibweW8r90pzciCm7hLuqLrWdx3m1A/L4ZYq/yZJD9lrsKx5S5xVyNLpBeUD/GJXxKhzLcsD9NbxgV0Elmqw7k4vYTa80j/TtpoRznrdmgb1tlwhdNyGPHJIi+i2L8lIEUn5QaR+/oKw375nRpUnJay+T/PP3gVoPbzSPHAPznjb2nRBkjj/0HqSjvwsFBaNnjlQuKWeOuW9bOI3xBxpBARL4jQ88gKlO1WvrYFQgiDHnW1R/VFBribWl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/11/2025 16:32, Ritesh Harjani (IBM) wrote:
> Alexander Gordeev <agordeev@linux.ibm.com> writes:
>
>> On Wed, Nov 05, 2025 at 02:19:03PM +0530, Ritesh Harjani wrote:
>>>> + * in_lazy_mmu_mode() can be used to check whether the lazy MMU mode is
>>>> + * currently enabled.
>>>>   */
>>>>  #ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>>>>  static inline void lazy_mmu_mode_enable(void)
>>>>  {
>>>> -	arch_enter_lazy_mmu_mode();
>>>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>>>> +
>>>> +	VM_WARN_ON_ONCE(state->nesting_level == U8_MAX);
>>>> +	/* enable() must not be called while paused */
>>>> +	VM_WARN_ON(state->nesting_level > 0 && !state->active);
>>>> +
>>>> +	if (state->nesting_level++ == 0) {
>>>> +		state->active = true;
>>>> +		arch_enter_lazy_mmu_mode();
>>>> +	}
>>>>  }
>>> Some architectures disables preemption in their
>>> arch_enter_lazy_mmu_mode(). So shouldn't the state->active = true should
>>> happen after arch_enter_lazy_mmu_mode() has disabled preemption()? i.e.
>> Do you have some scenario in mind that could cause an issue?
>>
> No not really. But that's a deviation from what previous arch hooks were
> expecting. Although thinking this through - I don't have any usecase
> where this can be a problem.

Which arch hook expectations are you referring to?

> But let me re-visit some of the code paths on ppc64 lazy mmu... 
>
> Looking at the arch specific usecase I see we always do get_cpu_var()
> for accessing the per-cpu batch array which disables preemption before
> accessing the per-cpu structure.. This per-cpu structure is where we
> batch pte updates...

arch_enter() disables preemption so accesses to per-CPU variables
anywhere in the section shouldn't be an issue either way.

The bigger picture (regarding patch 9) is that what in_lazy_mmu_state()
returns is based on the current task's state (not a per-CPU variable),
and always false while in interrupt. As a result whether preemption is
disabled or not should make no difference, only program order matters.

- Kevin

> For e.g... 
>   
>     arch_enter_lazy_mmu_mode()
>         hpte_need_flush()
>             get_cpu_var()   // this takes care of preempt_disable() 
>             adds vpns to per-cpu batch[i]
>             put_cpu_var()   // 
>     arch_leave_lazy_mmu_mode()
>
>> IOW, what could go wrong if the process is scheduled to another
>> CPU before preempt_disable() is called?
> So from above - I don't think your sequence to update
>    state->active = true 
> before calling arch_enter hook should be a problem.
> Based on above this looks mostly ok to me.
>
> -ritesh

