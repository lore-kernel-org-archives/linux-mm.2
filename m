Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 972C1CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 07:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91A088E0005; Mon,  8 Sep 2025 03:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA728E0001; Mon,  8 Sep 2025 03:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E03F8E0005; Mon,  8 Sep 2025 03:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D0198E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:32:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13F2BBC741
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:32:22 +0000 (UTC)
X-FDA: 83865264924.24.1607EAF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id D664514000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:32:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757316740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FTbsn9ueX//BY69AI+6lqPyl2zCJvGI1tcc+SkL1r0Q=;
	b=PTjGys/gjkxUEE33t65EEQAWPyBtcEQg09QLkOVt2CydG/AWrfKrR9J3myGKudLg1Cs5Z6
	Uw8C3BAn310R5Sx6duujGCyIhRILRKlPjEGyJgW+JMh0dfXrnrTiA3zJYOVaSzyRm/rcXy
	UFSAMFBCKCQcWBc3aXE3modxK6K5Fuw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757316740; a=rsa-sha256;
	cv=none;
	b=T2k7KvnIOTUk5WaCvzgzulbGLqearDa8d8mE8ETln4wKKS7xeszO0JCnUVBwGfU6lIOUbH
	328yShTnN5CoN94IxHGtjz0KKBp2kGjiYiqRXez8dHoGseBHmrSlshyeE26wL9D40+L1f/
	6FMGKCPWmPIBx63T1trpvqaPsORjB1g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F1201692;
	Mon,  8 Sep 2025 00:32:10 -0700 (PDT)
Received: from [10.57.58.69] (unknown [10.57.58.69])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A2713F63F;
	Mon,  8 Sep 2025 00:32:12 -0700 (PDT)
Message-ID: <16a63f8a-fe9f-4a65-be45-7260858734bd@arm.com>
Date: Mon, 8 Sep 2025 09:32:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] x86/xen: support nested lazy_mmu sections (again)
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org
References: <20250904125736.3918646-1-kevin.brodsky@arm.com>
 <20250904125736.3918646-5-kevin.brodsky@arm.com>
 <d3adc2a0-5888-411e-ac7c-9df45e3389c9-agordeev@linux.ibm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <d3adc2a0-5888-411e-ac7c-9df45e3389c9-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D664514000A
X-Stat-Signature: tczzi9gnyqwwzman41ryeakccdxf8diy
X-Rspam-User: 
X-HE-Tag: 1757316739-21726
X-HE-Meta: U2FsdGVkX19kMbesSmxaHpXUiVrLnbmuWbF5IbcPVLFxPSOZyUQ/l39rf24+8vbEeC8xSGP62ACpn1Xwtw0lkwR/jCEVuQ4qmdSQEtHNvOwkZ26a35l2sR4fb4Lh/uVepwRlK4T1Pyikb2bwvSWqsHq6bw3FSy7Ffh6IPTFO8WJI7H9m6LtvouW61qIM1RWAsqihw//CgWgHzf4gJqlbE3U1Aj01MvNKv7W6PKYbKmDCSYg5/aEzE8/xWNYqGA+VFPaZeLU1JPTrBFYGvmnLEwo579AJ0+FRwg1CerB/uQhxS7sPI+F8YCN4tlTz1qIwMIo0OOKuHI063KTjx6SGuYMCoGYv0wahRQEFOsctNjTVCUNWoz3zJ2klxguikfKXOSVT9wgTvuMYyUzZLz/kRrKefRH/15xHKQLJFbPiB6og2oYxS/D0L1mESXIlKMJIbI/caR5QCagrjoxekRFZLYXq7WJRcfC8AH3Rdbt/K7KQJPFg9g+Vdg54QwTC8D82eWPivIZ3go8PNlNk/pJHp3HOWFmdI9WuPZ39RTEvjWoAsNjK7swC0E40BuEL/YNBf+kSxqjN9F5WQMc34/fFFMnyx5cxg2fNFdHHTDXZUQqaCu1inI2s/ZPsVx8Kujw7KUZ9OjUYul9P9cHTLKz4Pt7+985Eze6OYyBc28d1X7xP/a4WArKKfdN4OvsFT/Vosc9znpRLHvNp8kLq4ndAeficsmR/xEO6thOb8QfiF1Ce48Oernfo/DPKVbfOVRPWyRScbY41QC93FHNyrH4JTgg+qpw9b8su5wIFvJQSnBrxCCV10Z5JoRAvedWEXiC5UXxSzUFypgE5Tf+jangCnPCPcVZpqy6I/NAIKETCZDncxQu9R0KbMxfNbpwsYuJCshS9EqulpSfjBz7ehJPoyatwOEzI37KHjGBNCekCAw3ii1/kAahk21C1Oov6hC/mnXkDfz7M+MPrDVjxW5s
 6+xaZS+l
 9Vl2TltyE2VCBnnkUNdBw221Wg4kGD3NgZWdI4gd400a0ZDx9fLD88fFCOrzpBWrGR/Fk8ThftyekJ7DvYR0L0arZen1HiJnQVvAWJkD3QWHdWtdytSGq0nyZUYBhwKpNmZAd4vZf+or5zvJzJgQmjbs1e3X5jDrQRsReYxDAJI3FG5kz5oIZmd3ClyZog/kJx31V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/09/2025 17:48, Alexander Gordeev wrote:
> On Thu, Sep 04, 2025 at 01:57:33PM +0100, Kevin Brodsky wrote:
> ...
>> -static void xen_enter_lazy_mmu(void)
>> +static lazy_mmu_state_t xen_enter_lazy_mmu(void)
>>  {
>> +	if (this_cpu_read(xen_lazy_mode) == XEN_LAZY_MMU)
>> +		return LAZY_MMU_NESTED;
>> +
>>  	enter_lazy(XEN_LAZY_MMU);
>> +	return LAZY_MMU_DEFAULT;
>>  }
>>  
>>  static void xen_flush_lazy_mmu(void)
>> @@ -2167,11 +2171,12 @@ static void __init xen_post_allocator_init(void)
>>  	pv_ops.mmu.write_cr3 = &xen_write_cr3;
>>  }
>>  
>> -static void xen_leave_lazy_mmu(void)
>> +static void xen_leave_lazy_mmu(lazy_mmu_state_t state)
>>  {
>>  	preempt_disable();
>>  	xen_mc_flush();
>> -	leave_lazy(XEN_LAZY_MMU);
>> +	if (state != LAZY_MMU_NESTED)
>> +		leave_lazy(XEN_LAZY_MMU);
> Based on xen_enter_lazy_mmu(), whether this condition needs to be
> executed with the preemption disabled?

AFAIU xen_mc_flush() needs preemption to be disabled. I don't think
{enter,leave}_lazy() do, but this patch doesn't introduce any change
from that perspective. I suppose it doesn't hurt that
xen_leave_lazy_mmu() calls leave_lazy() with preemption disabled.

> Or may be this_cpu_read(xen_lazy_mode) + enter_lazy(XEN_LAZY_MMU)
> should be executed with the preemption disabled?

Adding another this_cpu_read(xen_lazy_mode) in xen_enter_lazy_mmu()
shouldn't change the situation, i.e. preemption should still be safe. If
preemption occurs in the middle of that function,
xen_{start,end}_context_switch() will do the right thing to save/restore
xen_lazy_mode.

- Kevin

