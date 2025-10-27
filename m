Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D7FDCCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 13:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68EE880053; Mon, 27 Oct 2025 09:32:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F578000A; Mon, 27 Oct 2025 09:32:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57C7B80053; Mon, 27 Oct 2025 09:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 422748000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:32:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7EB0C0115
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 13:32:55 +0000 (UTC)
X-FDA: 84043984710.08.84F4732
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id AFDEA40009
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 13:32:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761571974; a=rsa-sha256;
	cv=none;
	b=KF3jgWVvDg15NJVLMw4r62PQ5H5bwfnxWRjU5Q95wRNWflV0AXGUFF6P/pJ9V77LLKUdM3
	/c1uw/p4ErCHcMQxpM6AF4fQmEK8u1VOt6bA1G+PMoJ4nUpi2zjSNVjXdBvVynX+J5qFZp
	OKrxZJCaRdqn0z6lpXBlUCRc3CjPD7s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761571974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LZIV7DiVBQ9ZGj7Mw+AxaUbETtcLCEViFbmC0IEP6UQ=;
	b=tlicdbbd3nIn2fz6s5ojqJElbWzn/Ub7R9+98SN3X7IJv/+plLukxsg+GvP0WRDaAgOZVQ
	49qH4PIZ4Ow+S1ZRvkEKETJdcudTy0/E4orcqaMSiS0mbqIRHh7VCNbt6MFqj959W099xE
	4/Azn6791rMR9p2UKR8K6EJcmMY0FCw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1A07175D;
	Mon, 27 Oct 2025 06:32:44 -0700 (PDT)
Received: from [10.57.68.196] (unknown [10.57.68.196])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF5AF3F673;
	Mon, 27 Oct 2025 06:32:45 -0700 (PDT)
Message-ID: <2be0732d-d8fb-424d-bc4e-443cc49d0092@arm.com>
Date: Mon, 27 Oct 2025 14:32:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/13] x86/xen: use lazy_mmu_state when
 context-switching
To: David Hildenbrand <david@redhat.com>,
 Demi Marie Obenour <demiobenour@gmail.com>,
 David Woodhouse <dwmw2@infradead.org>, linux-mm@kvack.org
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
 <70723f4a-f42b-4d94-9344-5824e48bfad1@redhat.com>
 <3ff4aaeb-61ce-4b72-ba90-1b66374b1b95@gmail.com>
 <6c9bd0c6-0968-41ac-b0b4-53c881748cfb@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <6c9bd0c6-0968-41ac-b0b4-53c881748cfb@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zoh9up55ue7djoohotj7s5h5rngigf9f
X-Rspamd-Queue-Id: AFDEA40009
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761571973-556025
X-HE-Meta: U2FsdGVkX1+rcYhcPfMj0aFQ8cHfA5fqtrZ/AU0MZe9OWKb+MUbuL9xylNaNyjvni4wFXCo0Qp+ZXrEsm+mhyxZJ6XS3yZJK7WK7KG+/pISzHS5JSHAZJmdQl4TwNzXv740ExCoJQ7TkCfuxRhRBO9aDtHPMTaea3mBD7InUDlEtdI1gI+S0tu/nKgqze/OwQUORrOqddbZqwqFIgMdS7+yNLruQ/aNzG/Ea4cVv+6ftUQO2+IQYxwp8wty57vClBe5K1/6bJtcLFZYZN0UhYYi6eZfieG/Y9IAEWqGXocU0tSZqWpQP96yfkLXY+BY4Gcumi70XJtaawByI7OjN3oXjcvVLaPMqeLsGTIX5kw06BxOSd+AT8DKx1cIMrPLb6EF/LHknCg2ilL9d9dY9YR1SjMnpKZqnvPw7htJ9vXNTktyn/O/fObTAovmo3B+ZAXLAgLo/BNM/fdlQaL436FNWfnImwlFHEnPZnj7DSlf7RMpSocSTu+LlGatQ8WS8CbNRqzzDQwKsaYIdVfXYph4kujKMTt5B3smtm6hwuYEvna50UWGG+y5ulwaE+XArTq0OMvmCwnNR4TH6tOa5RNzGy2NHRRmsXSBBfKNF6VMzy+vV8l13+ZFfap/5Imq2zGC+QiYAWzyONXV/5axx/sXVdX/2syrEDiI5t6jbXN+4eCnCpL4iYdsK0MT0FpSQYS7poquK3oi2hgSuKamJB+G6nEuVTifx0+oWxrt5sz2xUyz/a2wJG8tspxckQM+wTdfkVh8u3g040bAcinQCDBuw/LPZ/w0G4U7AjNFjvveGeImmqAdy4RyRIo7qu8g9SkiQCznnKiOVFr8N3y6XLVatWLjZWW5Klc5rj/gJS1qzfqQZulZOJkNXH1tUt5QmlTdrz2JS7W/o/W4iDbrYGMZ9MdGRAw0nLOrnYM/etidBkSpfGxWDfiO+FN0Uz9xS6urKbA7OPvaT6Tl7zBD
 Fxhx426F
 MvagrmZwxsSCuOAhGFykJMocfzMbh/MdZipx4SY8pQTeYsGuxH9Z1oYGO4ibwiauMPILjIe3fYH79eyjqI8ibAyL6z4bFzDgrrcJMSA9UdisBYjTt8ZQZQVRvt1mB50Iw5n1rWtFNWIsk5DH/B10ls1FmlHvOKatdZsy38Ay9Ej5av9cpZyd790PvsCBZfOxZ+lUzXn1gdZd84Ap81Gi/16j9ZyIzsJXRNNd557zNCNJi311vBQ0HC4VJnCVy5kh3D57AArHj/knsMg94UbfyMj3oyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/10/2025 13:29, David Hildenbrand wrote:
> On 25.10.25 00:52, Demi Marie Obenour wrote:
>> On 10/24/25 10:51, David Hildenbrand wrote:
>>> On 24.10.25 16:47, David Woodhouse wrote:
>>>> On Thu, 2025-10-23 at 22:06 +0200, David Hildenbrand wrote:
>>>>> On 15.10.25 10:27, Kevin Brodsky wrote:
>>>>>> We currently set a TIF flag when scheduling out a task that is in
>>>>>> lazy MMU mode, in order to restore it when the task is scheduled
>>>>>> again.
>>>>>>
>>>>>> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
>>>>>> mode in task_struct::lazy_mmu_state. We can therefore check that
>>>>>> state when switching to the new task, instead of using a separate
>>>>>> TIF flag.
>>>>>>
>>>>>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>>>>> ---
>>>>>
>>>>>
>>>>> Looks ok to me, but I hope we get some confirmation from x86 / xen
>>>>> folks.
>>>>
>>>>
>>>> I know tglx has shouted at me in the past for precisely this reminder,
>>>> but you know you can test Xen guests under QEMU/KVM now and don't need
>>>> to actually run Xen? Has this been boot tested?
>>>
>>> And after that, boot-testing sparc as well? :D
>>>
>>> If it's easy, why not. But other people should not suffer for all the
>>> XEN hacks we keep dragging along.
>>
>> Which hacks?  Serious question.  Is this just for Xen PV or is HVM
>> also affected?
>
> In the context of this series, XEN_LAZY_MMU.

FWIW in that particular case it's relatively easy to tell this is
specific to Xen PV (this is only used in mmu_pv.c and enlighten_pv.c).
Knowing what to test is certainly not obvious in general, though.

- Kevin

>
> Your question regarding PV/HVM emphasizes my point: how is a submitter
> supposed to know which XEN combinations to test (and how to test
> them), to not confidentially break something here.
>
> We really need guidance+help from the XEN folks here.

