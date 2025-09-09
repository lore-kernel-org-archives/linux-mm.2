Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB4DECA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C49C8E001A; Tue,  9 Sep 2025 05:10:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274B98E0015; Tue,  9 Sep 2025 05:10:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164348E001A; Tue,  9 Sep 2025 05:10:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00C958E0015
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:10:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A1A9413AE72
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:10:55 +0000 (UTC)
X-FDA: 83869142070.28.9F2FE1A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id EA89080005
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:10:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=St/jo3/IjoT+/tBd36JJNTe9cJMOpLH/Kfc1GffKIvY=;
	b=274lZzj+mnu/bMliIICsDVFIoevgOSMtcxllFEHW58GzXnkm0JDakdYQ2mO8Ur2P5NKuvU
	k9GnvE73pm2HaWJlwyAHT4wtaDtOPeM0Q0+mvgY/e0Nxrr/s21tG0PMrRHDR2XOyg46/RR
	EeJEheRO4xXShrC6Lb1UeMzaOM7dxNk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409054; a=rsa-sha256;
	cv=none;
	b=VMDuhBZ7fZrbuC6xnWDNnMniPVl+mtuUKRDcsyadFsarzsrdRc+AUu2wngwqfZgEnQZnxh
	GzvA/594S76x+yHLX8JzdyhedC3gYcwR1K0kGj6jl1Ks0WzijAaFRY7xHPxPfg2vcGhXAt
	CUCx6933Rxg1q8LyNdhn96zfG2KqPhU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A03615A1;
	Tue,  9 Sep 2025 02:10:44 -0700 (PDT)
Received: from [10.57.60.124] (unknown [10.57.60.124])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 358583F63F;
	Tue,  9 Sep 2025 02:10:37 -0700 (PDT)
Message-ID: <652720ae-131e-4de0-bc65-e5c1bdc46186@arm.com>
Date: Tue, 9 Sep 2025 11:10:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] Nesting support for lazy MMU mode
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alexander Gordeev <agordeev@linux.ibm.com>,
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
 <Liam.Howlett@oracle.com>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <c07b8a65-7cef-4ddd-bd94-d2e275edc2a8@lucifer.local>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <c07b8a65-7cef-4ddd-bd94-d2e275edc2a8@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5osyihwj4iw5j4kbmbwjrnzdr6asxjkh
X-Rspam-User: 
X-Rspamd-Queue-Id: EA89080005
X-Rspamd-Server: rspam04
X-HE-Tag: 1757409053-247887
X-HE-Meta: U2FsdGVkX1+3J5eIUMZ7472XqoCXc8+FM1qjasnlDs9CoGXGTfDbgOa43IBzdvwL3aR+kpZ3u3nNQEbtK0Ljp2yeI3yX/w5fehiJmeAG5kwq2gbfgP1nfLsWeWNjem2RKQ1XLrzmFjl5EZNzfxag51baSFqpdr2nz4WtDoR8nSQEuYVwlnLnuG2NXAuNOBce76AxJHE8tLCxZcUUQjoF6frecIHFnB5ku0pPgIAxK3fkdg8aZPiGiCIxdjJIvqOF3RlupbTf8NokZ1GuorRJ8dZdcafx6u02AXmaa2nyw3CDxHYzggLm3sITy0Omy9qjdJDTpGBMRek/0RAOVIat6ADFbzayC5VrnuJJMtIFag5bOyHG/Xre0yGyXK8O+LC93SJteCzNqskQRkpc8N2/wuXpL7DDq0BYGoCU6cvZhAEi2T54Inj6I75+qmeQ504ufcRnGvGEI19h0cDK4M0e+h6m4nA0+x1TJq++yjuFz0kDyHeFCpLgyoxDpN7QQtdU39yzya4dI2TKuNhCDtkG47vBWEJZiUphpRsF1circNiPIc6FVhTWru2MnEStB3unmXYLwpXfZeQCnq7IEU12twyn9Y18Hfjysyxmj+DAbttTxBwV3q1hQnfOvCv7I0px9oMxZ1W4fb05icE9u2PPxaxlq8XoY1LSpWj4CLvgYGmEZcV+ynAaZeQsGmUZx6VrW4ucsluEtWF4uOlQzwkeJoLkEKyOPuyGqFvkmMzihvDvHR4dofDymY2NYvjqhaxX0zNi4oJZzGF62dyYo8Wh2+int7iuAbGhJLApmsA5srOamDBKwa5ZzOfBLIdy5tyaFkvbuAIo7Rpj2aXRfTQjeado1GZbeTcYN8x1kiGd4FYOHed2VZ/Iwqx2GtRieTJybhF7KjoU4isgjue6ybTKkitr9+rCSw11Yo1vHCRgY06ZnZVvQllCXwJrk+TNI26sLy43hg/LMpe9nxdNRep
 1Wuad0+A
 ER90LzgkmExjF5+UJcj9pTQixRDMbsQmVWobqCzyXT8j8GUEgSJ2uPxFUrylns/jq657YScSAIIKFN0uAsXPE2isn+kJL+gSuBVikAZKcKGTbSIC2PFaJ4bPTEjpzkhTHLi9PrcOuzjpRF6o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/09/2025 18:56, Lorenzo Stoakes wrote:
> On Mon, Sep 08, 2025 at 08:39:24AM +0100, Kevin Brodsky wrote:
>> When the lazy MMU mode was introduced eons ago, it wasn't made clear
>> whether such a sequence was legal:
>>
>> 	arch_enter_lazy_mmu_mode()
>> 	...
>> 		arch_enter_lazy_mmu_mode()
>> 		...
>> 		arch_leave_lazy_mmu_mode()
>> 	...
>> 	arch_leave_lazy_mmu_mode()
>>
>> It seems fair to say that nested calls to
>> arch_{enter,leave}_lazy_mmu_mode() were not expected, and most
>> architectures never explicitly supported it.
>
> This is compiling with CONFIG_USERFAULTFD at all commits and series is
> compiling with allmodconfig plus all mm selftests are passing so from my
> side this looks good, thanks for addressing issues and rebasing! :)

Great thank you for that extensive testing, very appreciated! Shall I
add your Reviewed-by to the whole series?

- Kevin

