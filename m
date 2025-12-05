Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B36DD2F7CC
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 12:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 764396B0150; Fri,  5 Dec 2025 07:56:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73C056B0152; Fri,  5 Dec 2025 07:56:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 678B46B0153; Fri,  5 Dec 2025 07:56:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5779A6B0150
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:56:25 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E7E821A00E9
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 12:56:24 +0000 (UTC)
X-FDA: 84185415888.16.3517F24
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 284DFC0009
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 12:56:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764939383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/5/J1xrrQ4v7y7EnDQHi7nPKin/NlY5YRzNA1rygu68=;
	b=oFpMm+HIBPbmQDxJYugb2sCl/y9RKNHykU4fWSbXAZfdDpiK9nTnZ3Z9WzjuyRSNYcBhhl
	h6/EnDSQj9DZlvRrfPMpCrpvQLAexUfycgwDqEDakQ/c/d5/JoeT4sk5hiDtUq8wd4AdeD
	iO7izmBkR/oJ82+IpwJnFU9uQm6g7Bk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764939383; a=rsa-sha256;
	cv=none;
	b=mRs1YvCs7OWRHzL3K4ngTi3eKINILmYNxBpBk2RVZDU4NI2ZnR1VoP4ZkWw5EG7tJnHc/A
	rre3GKSsHlqp+Gej5VEPj2NutXtvRj07Qn4ADbW1Hdk7O3QFcmDAe37LMR1UbxAfb5plos
	49dBSgneO6dL60rdkAN3aMrejhvRQgU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D48521575;
	Fri,  5 Dec 2025 04:56:14 -0800 (PST)
Received: from [10.44.160.68] (e126510-lin.lund.arm.com [10.44.160.68])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 903273F59E;
	Fri,  5 Dec 2025 04:56:14 -0800 (PST)
Message-ID: <89e76670-4a7b-46b6-ba55-d225dbb68cbd@arm.com>
Date: Fri, 5 Dec 2025 13:56:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] mm: enable lazy_mmu sections to nest
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
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
 <2dfd54d7-fe2a-4921-85ff-a581392a777a@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <2dfd54d7-fe2a-4921-85ff-a581392a777a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 284DFC0009
X-Stat-Signature: tmcf1d6itp9mswkj1u5y9wgsrtct4rgp
X-HE-Tag: 1764939382-269812
X-HE-Meta: U2FsdGVkX19zUCnb4WYH4uWBDIdHE2vgQUxQd31OP2RMkDgCBWPMDAEDUHaWe4xdqAOJV2+94myujF6WpZZxFX6nwZBFBBFlV08A+wKxenJdMxwOIEfIVDavhMxKllCj6pG2AFACkavgkR9C4E6o5jySwVVOwtyoJGOs1jYCAWPpwYjuM75Oywh4sDJquUpBH2E645H7trEEvOSttCk127LhH6KdEh8gpotk2ZCC40RHlDC70GdpLX0EmelRtaoIAjtAclM4Nw3d+s2oZ69E5+tuaOwvrteInh7Y79eyUUaKgf1AxrIg+SK9LTY8jn7i8w9GR1j2HtO46gCVckl1uDtV2MCPagMHo19vRDTV4n2YCVKbXugCR+SrWD0QQ5wYI4B4vJL97wE3ugvfjBYpOVYkQiPhfgjbt0xTCa3VZA7r6Zak8nFkmMbWbDwSy7EVDJ4zquIGUn4ZOogiMc5ttrb5vIS6nfpR7hSeJz47XVQ1jwBkszRWFxRnya9GUiRrQCUKmUcUvKbvM9nm3aFVZdTQqK9hYMBPNd4wTP/3LrmbZuHm6jKv5Uvp/xNn+/iezNcgPs9lQ3QSJsbUA2L14QrJkK9MJN4b/8WrI/4wJ/kflYiLQm2pZ/f+xymQzek000RLwZ0G2E8zTg3gFjUOKbVhAXd/MoG2j2bBo59Eg0iahHk9zosbHYDefA6glEkshDwQbu4O15ulNqSRy72383Nl9L6eV+ZyKPUuDE05WH+9UMax+8jBE5ptISXlMbgVsh1Oa1afmTOd85YDc6dCmotkrbYab5ZoLHUh/MPhB5N0Dbk17VrsCSpmMjEunNbop0jd6Y06xb1kkrYs1lyUm75IbAiHsD1prOpyJR2J8jXJEr1IjzKxb1Dmkwwvic15VODjHT+ymEwpM+43zD9NLvHFyRqYeEM1WthjgkaPhOnGQSGvjeCKeySqSvtLxSeSCxkI8uDax0vrPPZnrk6
 Z7cmAdS1
 O6pqFOwD0Nz6cQ9wmNkyGYOQNPLXci/iErJuf/WSi5AtewhvgmP+GmUZlFvAV1byyr6t6HDjkBfV39zykrafShltKGP4XT/0Q3laGjfmHyaoEn5hT+JQwpN3EX5RKBr+gwzJttkePbktokzmKijAOpU8lBl22i/Q5qbv7m3FFJXRf/HsWtJDxLsyfn0Rra3boPl/abWsmXsgydvhBR/aecpUeHFRYRulf4H/Y4DiF45o36kmsBA5Q1wOCKQbSU4EwHjOHq3wIhM3/EJMP9xIlThQ19RGQM+RF29FLHTYuoRVxjSTsS6ZSCvUfvDXOllZryRID1Ai5n1Y99q99SOKmzjjUtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/12/2025 07:23, Anshuman Khandual wrote:
>> [...]
>>
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index 8ff6fdb4b13d..24fdb6f5c2e1 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -230,39 +230,140 @@ static inline int pmd_dirty(pmd_t pmd)
>>   * (In practice, for user PTE updates, the appropriate page table lock(s) are
>>   * held, but for kernel PTE updates, no lock is held). The mode is disabled in
>>   * interrupt context and calls to the lazy_mmu API have no effect.
>> - * Nesting is not permitted.
>> + *
>> + * The lazy MMU mode is enabled for a given block of code using:
>> + *
>> + *   lazy_mmu_mode_enable();
>> + *   <code>
>> + *   lazy_mmu_mode_disable();
>> + *
>> + * Nesting is permitted: <code> may itself use an enable()/disable() pair.
>> + * A nested call to enable() has no functional effect; however disable() causes
>> + * any batched architectural state to be flushed regardless of nesting. After a
> Just wondering if there is a method for these generic helpers to ensure that platform
> really does the required flushing on _disable() or the expected platform semantics is
> only described via this comment alone ?

From the generic layer's perspective, flushing means calling
arch_flush_lazy_mmu_mode(). Like the other arch_*_lazy_mmu_mode helpers,
the actual semantics is unspecified - an arch could choose not to do
anything on flush if that's not required for page table changes to be
visible. There is actually an example of this in the kpkeys page table
hardening series [1] (this isn't doing any batching so there is nothing
to flush either).

[1]
https://lore.kernel.org/linux-hardening/20250815085512.2182322-19-kevin.brodsky@arm.com/

>> + * call to disable(), the caller can therefore rely on all previous page table
>> + * modifications to have taken effect, but the lazy MMU mode may still be
>> + * enabled.
>> + *
>> + * In certain cases, it may be desirable to temporarily pause the lazy MMU mode.
>> + * This can be done using:
>> + *
>> + *   lazy_mmu_mode_pause();
>> + *   <code>
>> + *   lazy_mmu_mode_resume();
>> + *
>> + * pause() ensures that the mode is exited regardless of the nesting level;
>> + * resume() re-enters the mode at the same nesting level. Any call to the
>> + * lazy_mmu_mode_* API between those two calls has no effect. In particular,
>> + * this means that pause()/resume() pairs may nest.
>> + *
>> + * in_lazy_mmu_mode() can be used to check whether the lazy MMU mode is
>> + * currently enabled.
> Just wondering - could a corresponding test be included probably via KUNIT_TEST
> to ensure the above described semantics are being followed.

Checking that is_lazy_mmu_mode_active() returns the right value at
different call depths should be doable, yes. I suppose that could live
in some file under mm/tests/ (doesn't exist yet but that's the preferred
approach for KUnit tests).

- Kevin

