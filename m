Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 163A4CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 10:08:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BD258E000B; Tue, 11 Nov 2025 05:08:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66DC68E0002; Tue, 11 Nov 2025 05:08:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55CC18E000B; Tue, 11 Nov 2025 05:08:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 411858E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:08:23 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B881B591EC
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:08:22 +0000 (UTC)
X-FDA: 84097901244.29.502D7F8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 943D61A0005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:08:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762855701; a=rsa-sha256;
	cv=none;
	b=L7Je6K0FjajdsUCKsJFxypZ/lmYRB3tnNaWTEh4Wl0LOE19IT5iwGt6vYD4t3TtJX2ZCCz
	ZEaOtDvmAKv5JJgex2taa2Z1O6leG8eTy0DrlVN4oAaFkHYxTrQsaA7xOSFeYvN0jLDZvA
	YVnpIZeQWApg+65Ogg5o/H4S3ZO9RhI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762855701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t+WmW7yNqD2aweWk296ozfzQ200USyv416afCxbmVnk=;
	b=eQcroHYJCUdlQiR2YgoFqacu1K9ZxXnUJL/WUc2blp8xuA2SQsCX9AvNzjJ+5bZmgFnDSo
	+Sobufab2LILpB+Nz8E1UoMSV1+PSwBLs2GUstorHR4MPvPhhOMkTpXO7mf9JsMqPRrRIl
	lPFyVZwVGhh9Ee8CdXPmwNm+ySWcV4Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ACCFF2F;
	Tue, 11 Nov 2025 02:08:11 -0800 (PST)
Received: from [10.57.88.30] (unknown [10.57.88.30])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D9E443F63F;
	Tue, 11 Nov 2025 02:08:13 -0800 (PST)
Message-ID: <e2497863-8cbf-42b2-8f83-2c7b46fd1f47@arm.com>
Date: Tue, 11 Nov 2025 10:08:12 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] x86/xen: simplify flush_lazy_mmu()
Content-Language: en-GB
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
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
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-3-kevin.brodsky@arm.com>
 <b165098a-8164-4664-aaaf-1e8c4391d797@arm.com>
 <b21fb5b9-2e7f-4cbc-ae62-015b1317a9bd@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <b21fb5b9-2e7f-4cbc-ae62-015b1317a9bd@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 943D61A0005
X-Stat-Signature: 8d7zx8i3ucsgc3y4zbdyminposhxqs46
X-HE-Tag: 1762855700-155324
X-HE-Meta: U2FsdGVkX18sbFZUHCCfkPQLEz/n9110a/h6Zc5hL1FEnm3AjGJf1bE5A45NRcNp24A7QWcZwyho+88X8XUnW9mpLjX1DeLqzG6eUJdv3hLJpK2gjILKkuD0Lnu1V2Dd2Uc2OxzQb+w0YUf0Gph7Q+ogUG+PcIoGh7NrynuPFN4HMm+//Csua8l9hpdOpMKg0PXG6ETr4HeS3v/swRuHWXcMVU+RsjA3Za3AntVuBDSmWyyqzRPFqruCYQ6ni7VHN6t3AQNroyfn9yUBLsEY7brrCV/FRh8fK0Bj08URX1xaE2uR+YYU+zckDxK33hhvZz3Lh2Ykbc6TvUlSghJe2gedtX23u11HNjkK/poO2h0bnlLw9DkCBnRwfUXOB0hGsKjerMIfzQoo/193BdocdKplvL/ey+T0BiIOMjetvxFdUc36NVt2R5oXnykrYCZs13AIC20DItylN5D+ocDVl3LhCoWwiHR5AVFNPXG15MGSVr5S8073MuWyEHxzDF7VMYKwQJRCMHzixjE8Gtr69tX6FLaSRhVIvcEa5kO8lxUmYWMHc92gwp1nFrO6tPU4tjPDpDP/CHPs3CM0qHFNdsgL1IMa7D6ieLiYJgXoVYlApjzdICfqa5uQiBOAQuBJZDQHlEgMXlgnAdIZZpl98Hi1GjJENQ9efkSYkrwkZkwCN7ivd/ukQz4+9glVWjvLNPlC4b3DabxYW4Y9SihS4YnhYBYqDV2nNiLkGn7IbiQnbeLhpNAOGu22SBV0g05lK18YAm4o2kJp/5tjj3V5NWnTZkR52UJXAsmS5dzlY8bhOqtKiYkjH1vRRTtcyS3/e0Aqct6ex85ZQ1awcHISUtbnRWG8UHiOnFepCcwCig8r8OFmWY6tJTzYPfrPBLDVNZ0ecfK02N0PPluXQNQS/bzFYsRSbkPUPA0QenVtK2KHXCj6AvrVWg+EM3iarYtWNYDEspjPwmXAK5NkjYO
 oSwnMHJN
 zvLztFFJv10JTyY5TL1pYQdtjo5va2lt6k+GiMH+719hHPE9fPPhvsawmnRCYIn7uBrxicMpysHCntvhV795Amxr3Z8iYPQDevysaNpTYTgmjDEHmIku42XHXUageXInYr1K953cczYAJC3D4pRWE5xfQNBkaXCZyydnBMVNNMlh0CV3qNqRb6aimCbmaSQDc4ptwV6HSk2TBNkLhPCO0seavXwKgm9eJlAKM+nJ3qzJrb+YF4f7nGMZkJrTyAwGS3QnPe6oZoygz7AQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/11/2025 10:36, Kevin Brodsky wrote:
> On 07/11/2025 12:31, Ryan Roberts wrote:
>> On 29/10/2025 10:08, Kevin Brodsky wrote:
>>> arch_flush_lazy_mmu_mode() is called when outstanding batched
>>> pgtable operations must be completed immediately. There should
>>> however be no need to leave and re-enter lazy MMU completely. The
>>> only part of that sequence that we really need is xen_mc_flush();
>>> call it directly.
>>>
>>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> This looks functionally equivalent to me, so:
>>
>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>>
>> But I don't think this tidy up is strictly necessary for your series to work?
>> (perhaps I'll change my mind on that as I go through it).
> 
> I initially thought it might be, but in the end I think you're right -
> it should still work fine without this patch.
> 
> Still, I'd rather avoid unnecessary calls to arch_enter() and
> arch_leave() as it makes it harder to reason about what is called where.
> Namely, keeping them here means that a nested call to
> lazy_mmu_mode_disable() would cause arch_leave() then arch_enter() to be
> called - rather unexpected.
> 
> The only calls to arch_enter() and arch_leave() that are left after this
> series are the ones in <linux/pgtable.h> and the Xen context-switching
> logic (the one case where calling arch hooks directly is justified, see
> discussion on v3 [1]).

OK yeah, sounds reasonable.

> 
> - Kevin
> 
> [1]
> https://lore.kernel.org/all/390e41ae-4b66-40c1-935f-7a1794ba0b71@arm.com/


