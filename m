Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7814CCAC593
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 11:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D309D8E000B; Mon, 15 Sep 2025 07:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D09198E0001; Mon, 15 Sep 2025 07:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1EBF8E000B; Mon, 15 Sep 2025 07:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD0A78E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:19:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC95A140607
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:19:42 +0000 (UTC)
X-FDA: 83891239404.10.22713A1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id B001E14000A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:19:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757935181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ezmIh4yAIIyC5Ofx9OYfMJK6a3eTs8fzX06OGshPKFg=;
	b=S9l6WurDRXOS9KXmeu1V0DTEf9jawzOzMsTSlfjbGEYGr9FBnICcUndXmttoEt7UZKV3am
	WXcoLfHzIGyV9fwNZN8qcJ3c2VmezkWxrbSs6yowmThBl7hS1d2MOj2cJZQOoq6Cag8/of
	ywotwq+WNo0sUa+lmEguauTG6ZFjJrw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757935181; a=rsa-sha256;
	cv=none;
	b=ZF4N4R+Qo8g/2jyhXDlm3auEmwNUCc2CYktuo/+CHAVVtb38u0fuTYsFm6QdJ/EYZayqhY
	Azf7Ejmm/iZ62+hLRjgTyoHAcaELI/a0v90J3AFo0pk+liTM/PKG0HBRpqgcRikyjJq8LE
	m9KBFL5L4sJPzssXasZC2hVvO7J3Mn8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D6971424;
	Mon, 15 Sep 2025 04:19:31 -0700 (PDT)
Received: from [10.57.70.220] (unknown [10.57.70.220])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C7D73F694;
	Mon, 15 Sep 2025 04:19:34 -0700 (PDT)
Message-ID: <d407a381-099b-4ec6-a20e-aeff4f3d750f@arm.com>
Date: Mon, 15 Sep 2025 13:19:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] Nesting support for lazy MMU mode
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
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
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
 Mark Rutland <Mark.Rutland@arm.com>
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908191602.61160a7990b9ea418de758c7@linux-foundation.org>
 <d1b4ff2a-052f-4556-91ae-273962edbed0@redhat.com>
 <338ef811-1dab-4c4e-bc5f-8ebd8cb68435@arm.com>
 <5a0818bb-75d4-47df-925c-0102f7d598f4-agordeev@linux.ibm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <5a0818bb-75d4-47df-925c-0102f7d598f4-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B001E14000A
X-Stat-Signature: yk6aus8eryoghfcuga1pmpkq93w7od8a
X-Rspam-User: 
X-HE-Tag: 1757935180-444025
X-HE-Meta: U2FsdGVkX1+tf4l8jSM8CtAgqWVkd2yefltWunmDBYiKJIFFue4TRysTB4zVu9qrAHclAhy4/cCbVS7fxdJshgBY1dr4XDMzI0gYgk0lplRZ0zswu9zRUXoigckUzDZL4citXOGGunxR4YT6PKl9j0q1TPLOMUpvJdvCcCTzShlqomUbOslcRWIVYlwdyp55MYqM9lP8E05thjn0VQMUKDtpbAhLh4coVvcCzlzi5lZEePhiPJb9ayXHuy/qgedt3Wkls6OAqFZeqIlX5YrZwhRHq7dqxWTQ5fDuCRg0J1vurIAloxSmHIwrcRNlUjTQESNTzwURYiCgSVmRu5uK+zscnaMkL0sBw8Q7usKGEN2ICfND2p1n3CaCVEhGXCPick3aFZ+4MGMXeTtcKLMb5WRJXWjF2BswYmqFuQBZ+V39h0OAbehJJbwoeRCu15sK2/sEjvp/7TI71Oo0X4akur11J2KK1uH/MVNUWiobevm3wL9dalDjPhHprt681dOfdv38WZxfYzbPZKu9CL/hchOgig2D5Vy9aI0uKKaKheqGmBdMXHdf7q0RFrFB2ZrDhNIiaTsr4SdTXjGdw4xepP8oo8Jp2fAHAMtBTjDWO6J8Vueqm2fN1NY6fei1DJTXJIMyzk+Q3DoULDm7zgPg3VRPCvp/tBBW2Kpt3gssq3wPPIMjFrtTeDQKNquUA4AhHBDTQhdrJ/cvuRXTq9HWq2hcWu369DAcmolLlHybGF92CerysLkqH+3W7dkz9XfMld3mBexf3bD1zrphasH+Is53MtyPSvoE1GEu8fRhlVAU+d6p3097e0c1aqbLJPddu9nhQ8aUVuNA1qpfUVav9EEmtMuhX6sF881TOexC2Y54IcRucUsNEmA0LUZ8xIs3K4K8fWXO7zVNiLs5P393y+KtWRI2pTMwC2JBcLdghAlHtsBoM9+yixZFgbizjvp4TPE5ORTG5X7INHfAAZd
 QV8zYb9w
 a4eqFOXSWxcbZx9kAgoKtMkM3kNIAtkVtmxrh5/gmbMumn4ECCzQZyj/oMBO5DEfwXAvYHmEAuDUMurMrXXf3AFJASA47vUev6UWN5TVeFQOn3apuX/B3cRMe2UCfbG576gSteCBarovTcNhcoB9jp0NdlcdBC0HdylVHs3bKKNhE79U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/09/2025 08:28, Alexander Gordeev wrote:
> On Fri, Sep 12, 2025 at 05:25:27PM +0200, Kevin Brodsky wrote:
>
> Hi Kevin,
>
>> Based on the outcome of the discussion with David on patch 2 [1p], there
>> is indeed an alternative approach that we should seriously consider. In
>> summary:
>>
>> * Keep the API stateless, handle nesting with a counter in task_struct
>> * Introduce new functions to temporarily disable lazy_mmu without
>> impacting nesting, track that with a bool in task_struct (addresses the
>> situation in mm/kasan/shadow.c and possibly some x86 cases too)
>> * Move as much handling from arch_* to generic functions
>>
>> What the new generic infrastructure would look like:
>>
>> struct task_struct {
>>     ...
>> #ifdef CONFIG_ARCH_LAZY_MMU
>>     struct {
>>         uint8_t count;
>>         bool enabled; /* or paused, see below */
>>     } lazy_mmu_state;
>> #endif
>> }
>>
>> * lazy_mmu_mode_enable():
> This helper is parameter-free, assuming the MMU unit does not need any
> configuration other than turning it on/off. That is currently true, but
> (as I noted in my other mail) I am going to introduce a friend enable
> function that accepts parameters, creates an arch-specific state and
> uses it while the lazy mmu mode is active.

Yes I think that's fine.

> That does not impact your design (AFAICT), except one change below.
>
>>     if (!lazy_mmu_state.count) {
>>         arch_enter_lazy_mmu_mode();
>>         lazy_mmu_state.enabled = true;
>>     }
>>     lazy_mmu_state.count++;
>>
>> * lazy_mmu_mode_disable():
>>     lazy_mmu_count--;
>>     if (!lazy_mmu_state.count) {
>>         lazy_mmu_state.enabled = false;
>>         arch_leave_lazy_mmu_mode();
>>     } else {
>>         arch_flush_lazy_mmu_mode();
>>     }
>>
>> * lazy_mmu_mode_pause():
>>     lazy_mmu_state.enabled = false;
>>     arch_leave_lazy_mmu_mode();
> This needs to be arch_pause_lazy_mmu_mode(), otherwise the arch-specific
> state will be lost.
>
>> * lazy_mmu_mode_resume();
>>     arch_enter_lazy_mmu_mode();
> Conversely, this needs to be arch_resume_lazy_mmu_mode(). And it can not
> be arch_enter_lazy_mmu_mode(), since a lazy_mmu_mode_resume() caller does
> not know the parameters passed to the lazy_mmu_mode_enable(...)-friend.

Got it, that makes sense. Even without your proposal, it is probably a
good idea to allow arch's to behave differently on pause/resume.

I hope we can avoid forcing all arch's to define arch_pause/arch_resume
though, since only s390 will use it for the foreseeable future. Using
optional macros should do the trick.

- Kevin

