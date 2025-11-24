Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3D78CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 14:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359296B002E; Mon, 24 Nov 2025 09:36:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331366B002F; Mon, 24 Nov 2025 09:36:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26D256B0030; Mon, 24 Nov 2025 09:36:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 161306B002E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:36:44 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4A4458E38
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:36:43 +0000 (UTC)
X-FDA: 84145751886.24.5EDA964
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 63AFE14000B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:36:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763995002; a=rsa-sha256;
	cv=none;
	b=DwecN+Fl8ES/hBPwm9GPtQ/xty76sC9VdXFTgvwQCaD5ENEmCTD3dwoslmfy/s2mtLKNZH
	3IBgDdKua1DyVtcz9GlmRc5VGyfgroT/VVNtmmJCrjwFfRTe3xppvJmtH8G60f2ji/Pt3e
	hXIBe5/yKkDM6iowhtEOx9w3J2G7NCM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763995002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YJ471huPf3AbbCsoCzRDaoFvk+dd/VjhisJknTSiicY=;
	b=p1PUkBcyEJ23CAEbr+bTUavJGR+20MEMx1CPwOvY55nNIr4Q9S19bIBF0s57qn0wZf9x/h
	3Domf3ww/tJJRuSTj0fD1DOwW6cI66Ehwnq8quEcQXCXvc+ROIaoneiKrtZE0SAg+q+kVT
	NOpdQ55srwEMRPtS4ZVV/zYS81K8/pc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 80775497;
	Mon, 24 Nov 2025 06:36:32 -0800 (PST)
Received: from [10.57.88.238] (unknown [10.57.88.238])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 94CBA3F6A8;
	Mon, 24 Nov 2025 06:36:34 -0800 (PST)
Message-ID: <b52726c7-ea9c-4743-a68d-3eafce4e5c61@arm.com>
Date: Mon, 24 Nov 2025 14:36:32 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/12] mm: introduce generic lazy_mmu helpers
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
 <20251029100909.3381140-7-kevin.brodsky@arm.com>
 <71418b31-aedb-4600-9558-842515dd6c44@arm.com>
 <b44825dd-aef9-4d3e-91fd-a44122264c23@arm.com>
 <f36ebc15-c724-487a-8e4a-9ca95edc544a@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <f36ebc15-c724-487a-8e4a-9ca95edc544a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 63AFE14000B
X-Rspamd-Server: rspam07
X-Stat-Signature: xf7cunn4t8jap43pjqzhhf8sapuypauz
X-Rspam-User: 
X-HE-Tag: 1763995001-360749
X-HE-Meta: U2FsdGVkX1/Pb4YI6ByLtTL6FFuA1NMgGrZW66mLQbEvRYdpmWv18/ZVewZ79ajXikVYWe5ThuKEWTK+6AaPXLIrCaz0wO17iz0o1ItIvFEdU1imccM4DK7ikrABwUiqN1nh0fzwNaH6q/D+Ys5xVpRQoRzpVHjWjO3gZ6JCl40sKyTCXp264JD/9eN+if2JMRhv+SftKScWMIRw7hHrQtKNYV4dXW8eZq9s5UuJHGePNXfdnkWBPVSSH7vcmDVjyZyc/ftMi3tWTEVj1wIiUHNlh36rZ1ZZv/kqmFMClcyjxYBzwrI8KbmNhg5DVbA8t7IxPALXuNB9s3i6LLNBvokMgokbG72zhAqRq8WYK6YYLAMSeAjL6jugRsU766pSicFjpCwEV9kpG8QUU7CKd02cGqqqAJGvZMO1XeaGQkl3eaaZSlPWgzKzGS8V+Oe6SVh6wLZ1kN3Pv2Dom/cuvxqq66h1XucWOfMneLD3OYjMEbP55J6nTOB8d4yhOBnHXKVhMSlbH6GFXVh0cMBTOn423X4DmA6+QQFNtA23QjFQEmnKIb5afxBsODcjV8m2pynw3b5mVKFs/CSIm3bDWw9xQEJMRKZxT8pxld0qi35tqyj4KmXf7U9UKpM3InX9GNlF5sXVuk7RIOVhFZkKdrZm7bcVkFrwa55dumWBc9chpo5Y5mJzNstKxttmaEJaxxA4wJzVyJpLYYtr/pqu69MbS2EGMV9sUMnN15PgfPnolPHzqT6BgSpOm+wPK/On0w6370ak2Lq8Ln9lRFHChN13OGh98hHWlkQFvy8hqvIf8nyHFalGCPNjWZ3JYZxwsPRRc7uC9shpOYkmqEAmP5V1Qmawn92X1x2iruYn66pZ27i4qrzny2GdYd2ERv0KAaCl+tRBoMPSQjsXYuf4kOPtW/BOG+z80Jgq48AnzrHxo1mIZ3CU50mhK/R3n6Bb6zwyufy+7ox3OqwPwVn
 B8HAQELA
 ui3gIzuwtxBWchqiMTxchAENwj5cyXWoWeqlD53QVLB4+vONg1i5a/eyscZG9ZJMGwyxOaWnzwBbi9BsjeCB/oErpZwf5rutg/7QOzaexU5q83HYHdIZx7eyAhqaDXcg0bpoUnSarogMezQZfo/Pfmx0J4bf5ABq8A4ngrNp71W8GAixFEHBU59AENVPXFRTpd0v0KL0SXNIGkINfPoc2XQj3ZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/11/2025 12:47, Kevin Brodsky wrote:
> On 10/11/2025 11:45, Kevin Brodsky wrote:
>>>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>>>> index b8d37eb037fc..d9c8e94f140f 100644
>>>> --- a/arch/arm64/mm/mmu.c
>>>> +++ b/arch/arm64/mm/mmu.c
>>>> @@ -731,7 +731,7 @@ int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
>>>>  		return -EINVAL;
>>>>  
>>>>  	mutex_lock(&pgtable_split_lock);
>>>> -	arch_enter_lazy_mmu_mode();
>>>> +	lazy_mmu_mode_enable();
>>>>  
>>>>  	/*
>>>>  	 * The split_kernel_leaf_mapping_locked() may sleep, it is not a
>>> This is a bit unfortunate, IMHO. The rest of this comment explains that although
>>> you're not supposed to sleep inside lazy mmu mode, it's fine for arm64's
>>> implementation. But we are no longer calling arm64's implementation; we are
>>> calling a generic function, which does who knows what.
>>>
>>> I think it all still works, but we are no longer containing our assumptions in
>>> arm64 code. We are relying on implementation details of generic code.
>> I see your point. The change itself is still correct (and required
>> considering patch 8), but maybe the documentation of the generic
>> interface should be clarified to guarantee that the generic layer can
>> itself cope with sleeping - without any guarantee regarding the
>> behaviour of arch_*_lazy_mmu_mode.
> 
> Re-reading the existing comment in <linux/pgtable.h>, I think it already
> makes clear that sleeping is not forbidden by design:
> 
>>  * In the general case, no lock is guaranteed to be held between entry
>> and exit
>>  * of the lazy mode. So the implementation must assume preemption may
>> be enabled
>>  * and cpu migration is possible; it must take steps to be robust
>> against this.
> 
> The arch implementation may disable preemption, but arm64 code can rely
> on the arm64 implementation allowing sleeping.

Yeah ok, I buy that!

> 
> - Kevin
> 


