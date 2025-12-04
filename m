Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BE59D1F9C5
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 11:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8406F6B0006; Thu,  4 Dec 2025 06:39:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 817876B0011; Thu,  4 Dec 2025 06:39:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 754826B0023; Thu,  4 Dec 2025 06:39:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 648A66B0006
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:39:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 723B7C09A7
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:39:25 +0000 (UTC)
X-FDA: 84181593090.07.F646F50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id EFFE21C0015
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:39:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PE+WiSnZ;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764848364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=69yqmIoyiPubXzFm9eTn6rbyp435f7R4HZkguSHyvhA=;
	b=R2IS2EDQvheW/gaZDDZi6G+MaLoNowtJrTNGXMV69dxIWGEYFB3O8liNdZTRRekzUiX6Wd
	go3hXi3PA/x/GZJRhpCLHmcQvMET14NAGqejb5tyo62FlHcfPOQBJzOQ1hvur2ygQtX2Ff
	kdp1Rmlw3Jx4163LGANhjLnJQ54fRYA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764848364; a=rsa-sha256;
	cv=none;
	b=dGOLyHn2YErTJVUhpMWrbfh+tIwXFoliDqrnWzsxZrDegSnElbLFDRjI/Im48JCvd+m3E7
	jHjB23w6oVOGlKS99Dneo7vPPGKdihPBTIT7w1EmCfYfoVbhjPPSVvvtCWnmRYSLDCQjeO
	7L/8SbW9ZcUn7j9BRdhJlcC5EsU/RaE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PE+WiSnZ;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0DC21601E2;
	Thu,  4 Dec 2025 11:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03C3C4CEFB;
	Thu,  4 Dec 2025 11:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764848362;
	bh=oGOR/Gy9sovZXJOpLcgTuOfyjEMxsxmxhHmHgTDnlvg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PE+WiSnZpBNNRcaVS0QWTpayXH+dWoN5nt+357dXYUJWSjuOlaAsOBoe3SqzwB59R
	 0BhfuC55fmyIKS+5sWgvrif65X9dIQNyx1j8zScdnb4JsSuXTbZHZKOdhJztBH13oI
	 Z2xVQUclq5bzMcDG9oXYqty7pxfA/Wou/aR2Tjfhg2wQpAVF58f5Wxsu7+lh42EsgU
	 tzePMKUtQaqGs3/m7uKwUZJa+NFZNeb3W7vSvEYI4cegv0lxJrfu/RurxuRx1OGmTe
	 IzJrQ0kiAZGVJ74Dcu7D6yrF3jlh37vFw4mnVpHVXtFq7j5uuCInmCGOIVhoeMwI7Z
	 muM8WetLK5bJw==
Message-ID: <b341e7fa-4382-48b5-896a-1a0d347b66ca@kernel.org>
Date: Thu, 4 Dec 2025 12:39:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/12] arm64: mm: replace TIF_LAZY_MMU with
 in_lazy_mmu_mode()
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
 <20251124132228.622678-10-kevin.brodsky@arm.com>
 <89ecddb7-83ee-427b-823b-984204939ecf@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <89ecddb7-83ee-427b-823b-984204939ecf@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EFFE21C0015
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: mipgurxb3p7t318n44g9xdee8qbim6ey
X-HE-Tag: 1764848363-928589
X-HE-Meta: U2FsdGVkX19HQDtkPfuJGjNwMPXmRhUvLKc5MQEkdaU9bn+EWYWJtetA9jQ9iZLubS42YROFGjdUvAoCyfOPxhi+xXe+nOlcdZQmy91dDg+j++OwbQYPvtZWldZEQwc4uLongWYILmUIUgCRbbxQUAoL8EaCw72cPVwsboH9KNzkSyadpHmzvJ68YetHvHtWte7jm4RV71aaVW2VKctGEKVEIvjo4XDJ/YgXalIt1FJwRLgoRVKxk+GU5QbLo/Y0G3EzfYfKI5ljjGv9wz4so0bkLAVqDgmFxCmWCHeBWFWk9th4VBs14UCgXVfHR+DBIG1mTmLRsBjSzCOsKTrF1KxjTDkFxaKi6SUFdhfXgbYdaiYp8f67+X2sosfGeLgizkpnpJaIaPoSA7aLwxL4RE/vMYXEL10nd4yMA7sFq+ucl5mny1lpG7wJjD2+flZQL3IGj97yJvAImMXLwFZs54TT2DeU6Ny9TQuSkrSKkzm7h/vFl6LZc8KKOkVTtduhWky9U4oIwmBwoEkoqSsipNX2H4BWqOIkG9dZvYUzhqSVeCm8hhXpMExIrnE7icYUui3ISrMn/LskrprRv6DbpZrGhmwVc3/ckflFpTiMXTr9Gmdi8NyzCGsodMRaX+l0QMonX4EVqb1XPUIJGJiR398ktcWDgyM5SZTsTtDa+qTZDXGj/k0ZgJ1tIkL0glKk81IIKAq/LVhRfLnrTHoMtI4I17Pn6MAcswkb51pbvvX12KZ4Hkt7xT/dy6hyte2qWpkH62raXHrHhVeRywotckhyezgoYFPZt/ryuG82ahlKbysx3ZVqiVx2x8Yj7VFDbcfGH62H0kxuKP66VmteZ90BEE3xpb1oCMCG4anMkoexIwkGlVD1MzVJNOdjM+U1BrCiJAawZIBKRCxkJaVjPLwcKw1CAuAorn4H3lXw2eGS9f2vMyKBZQHZ+gxDbPghNMmAP7teFmflshRiMOl
 O9qWXdx2
 g+/dHKgxSTQI+pnwF1weF80XNLFk1xVcc1B+p5+9ZSK4A+YbDbtwleYC7T5QvUoICKDmwKxxE1q1lIos=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 07:52, Anshuman Khandual wrote:
> On 24/11/25 6:52 PM, Kevin Brodsky wrote:
>> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
>> mode. As a result we no longer need a TIF flag for that purpose -
>> let's use the new in_lazy_mmu_mode() helper instead.
>>
>> The explicit check for in_interrupt() is no longer necessary either
>> as in_lazy_mmu_mode() always returns false in interrupt context.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>   arch/arm64/include/asm/pgtable.h     | 19 +++----------------
>>   arch/arm64/include/asm/thread_info.h |  3 +--
>>   2 files changed, 4 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index a7d99dee3dc4..dd7ed653a20d 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -62,28 +62,16 @@ static inline void emit_pte_barriers(void)
>>   
>>   static inline void queue_pte_barriers(void)
>>   {
>> -	unsigned long flags;
>> -
>> -	if (in_interrupt()) {
>> -		emit_pte_barriers();
>> -		return;
>> -	}
>> -
>> -	flags = read_thread_flags();
>> -
>> -	if (flags & BIT(TIF_LAZY_MMU)) {
>> +	if (in_lazy_mmu_mode()) {
>>   		/* Avoid the atomic op if already set. */
>> -		if (!(flags & BIT(TIF_LAZY_MMU_PENDING)))
>> +		if (!test_thread_flag(TIF_LAZY_MMU_PENDING))
> 
> A small nit - will it be better not to use test_thread_flag() here and just
> keep checking flags like earlier to avoid non-related changes. Although not
> a problem TBH.

I'd assume the existing code wanted to avoid fetching the flags two 
times? So switching to test_thread_flag() should be fine now.

-- 
Cheers

David

