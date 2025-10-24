Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3AB6CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 543F38E00B0; Fri, 24 Oct 2025 11:05:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CEA48E0042; Fri, 24 Oct 2025 11:05:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E33F8E00B0; Fri, 24 Oct 2025 11:05:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2BBA78E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:05:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC5395DB0F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:05:20 +0000 (UTC)
X-FDA: 84033331200.25.4F6F95E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id EA6694001D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:05:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761318319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mFsntFKm3sLCSsUTazR6Zz09gRvrPjOBy+0/EZ6kZlE=;
	b=WEOw2bJ/8raeSkCU+dqanie8b99KAM5LSY3IK5Ya8/D7gzjH0dBeCYiNkyT5E1YRNVvRwc
	N2r+o9L/kiWV+lZCGbAZX/KrOkQ2h3SNX2Ki+Sd/qFoVK54Df2ra7e7ivWN/YpPRUWRzHz
	FNkyLe9xNKfqjFmMaP8Dx8PfawN0oY8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761318319; a=rsa-sha256;
	cv=none;
	b=8rJgKDE9fF8tMv8FMRhooWGr72x9dLpOsNRxN1+NOhJa2Ns8e9amUebA9RWv4kInw7TPmk
	/Y8pxDyUMVxQ3jeLbxaPGEu8mYo0l/fsE54zHYzcjWyU6lugTN0CU4RRFO9pe1tApjgYwR
	zMTXDRISV6n9CC4bIHndLuzCEJLEYdc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29D6E14BF;
	Fri, 24 Oct 2025 08:05:10 -0700 (PDT)
Received: from [10.57.67.38] (unknown [10.57.67.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 519063F63F;
	Fri, 24 Oct 2025 08:05:10 -0700 (PDT)
Message-ID: <6ed9f404-9939-4e9f-b5aa-4253bef46df1@arm.com>
Date: Fri, 24 Oct 2025 17:05:07 +0200
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
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <348e5f1c5a90e4ab0f14b4d997baf7169745bf04.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 7dhqn8eq639k7sp5gjr5dmgikgga4ytp
X-Rspam-User: 
X-Rspamd-Queue-Id: EA6694001D
X-HE-Tag: 1761318318-861729
X-HE-Meta: U2FsdGVkX18wA+cuZyq4+wbjH2i8s3MS0bx8p6aqjwfm/fH7In/hodLezxC+BWF81271C7Z5iQ+TSyXxXEcR9tvtwTtfBMzBkOSCWsnqb9PmhudZKDresofowcTo8HRnVZn33Id7/MHs1ZdG72ixY/5RQeNtM0ckDTLs8U5wKYoDAgxCHVHUlnpjCrBz8xsEgdisCT7g/5e1Vcq3dN5rG8xRFlrBqlA0bhkQ6LZdCtCLWVAPqoXBbOOekMgwAepgou9yIRU/Z9cBRTiNSg7t/KCXsYpwTV637uhCBC4BaOY77FnbrIkYOs4JN0VcNcg8X4Z3JvaCxT19PDACgoEABQREIp4Sjs1PyYTulaPGSDuZCi1eKewRWd1+xvJmmT26k2t4lDfj6gNHQ4Hsw0M0bUPX+/t+MnF2Ux9lcP+qFn/As07HIbgm4VQC/oVUUo29tpNRVjFjbOS9oRb4aBvUs9rcOSOQQxcg6oxdKQfB5JxK5LywuANMRv66Wq746+0dkHys/OIaAdasQiESsKvh3TDuDydRFwesf8+rfG7Xfi7TNQmHyqlsl73ochlcdnHr/GAlJ6K15H/pY8DFaIoSuvnMqN2LlglcqQoX1cR3uBdEy8kUkkQLo81C40cGWh4lRLzPtQRqssveRR+TLtDZfSsgdE6bjzXZhzCNVCYAQr0iDx9llf9/xCkHpi2Y/K7L5LUPTPCTbU95cttuTGBo6fJuzw8lXEUuLn67SwJzptMaSULIEyFdmH4kOyJBEz+QiltesrFvPniaFNn44e5NMVVUfb05Q8UblA9Uv+2q4s9EO+f2rD0FbB2mc0/42jUSoWr3pY+FqwRZnHs3GNF8q1BO4YZzVXUFIyk31CEVmgCpo4ewJWrN5lMcl2wXiNctMg21JbLAuBEqN642OcWaL7l/7mA1+Z1HS4PNK4kZfuPubEkPn1xMQQRoONqXl6qKVFLNUzoZTIf7TVr/GJ9
 0KmFpyRx
 0IER+qBCaLIf5DpWHhkDk59N/g/9ZFrpyze3wyMfNRWQer2SXWeAjj8KSuaPJUMH1Wc4OTBZFFEZj66PjXPwU1eEUJbEXolKFZ3X31A9voe/iLFuaDfZuwI+QKazD66Q5rX8i9e3rE5ob/dG0HZkz2wpcpeniSjG7e447hPUAeRdx3sZeQR5YIMF9rGZwd3nUKzgV/4xi/3IBBE3Wf378+ItJslktlJq54UkgmEImCUzt22+3ND85NOfqaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/10/2025 16:47, David Woodhouse wrote:
> On Thu, 2025-10-23 at 22:06 +0200, David Hildenbrand wrote:
>> On 15.10.25 10:27, Kevin Brodsky wrote:
>>> We currently set a TIF flag when scheduling out a task that is in
>>> lazy MMU mode, in order to restore it when the task is scheduled
>>> again.
>>>
>>> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
>>> mode in task_struct::lazy_mmu_state. We can therefore check that
>>> state when switching to the new task, instead of using a separate
>>> TIF flag.
>>>
>>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>> ---
>>
>> Looks ok to me, but I hope we get some confirmation from x86 / xen
>> folks.
>
> I know tglx has shouted at me in the past for precisely this reminder,
> but you know you can test Xen guests under QEMU/KVM now and don't need
> to actually run Xen? Has this been boot tested?

I considered boot-testing a Xen guest (considering the Xen-specific
changes in this series), but having no idea how to go about it I quickly
gave up... Happy to follow instructions :)

- Kevin

