Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A4A7CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 12:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E7336B0027; Mon, 24 Nov 2025 07:48:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BEBA6B0028; Mon, 24 Nov 2025 07:48:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB6F6B0029; Mon, 24 Nov 2025 07:48:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5D27D6B0028
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:48:08 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 234F813A7C0
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:48:08 +0000 (UTC)
X-FDA: 84145478256.16.20B743D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id E726880006
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:48:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763988486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pU+jnmvgd+G4YbcI1jrZhswEj1b5jzOEmkm4kKdxr30=;
	b=jdmXvAmQGPKrzVDYcZ+Iu4BbJ4JIMejaAmK9y5rY1/16OezWviDy+9QJrUIivwgkdMW+8h
	CG3T9WBwZfiqM3G3RDUWHCoxHnsteMfkfWWY3ofYyBQqAxovMEtKItFyHJelqo6OHfb1uq
	ObJwWS5bQaoHMPk8AcFr4XISyG88bYw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763988486; a=rsa-sha256;
	cv=none;
	b=NQCJi98Jmtq1hIJB71xD7zJZ1XX6M6Elvvsi1TMyWB/+DoIj4I6f6OmsfxhD96SvHr43o9
	fHgyyIZhRDsx/3lq6/o6lubkaewHYN4PBQ3jV4SS09+sF6KIYgI7mAsBOvrT/OBtObHaiq
	Vi/2LfvzcXW3uZRN4k66WkWnbeBz+m4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57038497;
	Mon, 24 Nov 2025 04:47:57 -0800 (PST)
Received: from [10.57.40.193] (unknown [10.57.40.193])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AEF4F3F6A8;
	Mon, 24 Nov 2025 04:47:56 -0800 (PST)
Message-ID: <f36ebc15-c724-487a-8e4a-9ca95edc544a@arm.com>
Date: Mon, 24 Nov 2025 13:47:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/12] mm: introduce generic lazy_mmu helpers
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org
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
Content-Language: en-GB
In-Reply-To: <b44825dd-aef9-4d3e-91fd-a44122264c23@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E726880006
X-Stat-Signature: i5xahyf5efz39ewbjwf48img55shi6pc
X-Rspam-User: 
X-HE-Tag: 1763988485-539836
X-HE-Meta: U2FsdGVkX1+9Nj4dDrV/Pe7REaXA/eXVR4PYVMy/BLAwM6mbkmoQHJTg/3wKMLyVIYxDP7VjlXqfJ3Tid5/FFpVkK6zc8g/tlZoAtCHCtNAb01w6o5HqhpFUt9ijIaIRAFuf2CiQbueIhUGMtChq/SgKVTawrczzJjlKobc6xSf8JCmh35owhrr/5kkoWbAVhqX68WTF1IdOyujBOXYvVCyFhVA/tBdfGbMndP79t1cU4fRNhM19IjtikGQxVDn5V7D7YU5G2I+lgJ66sUKmROcPRXcy9cG5Z7lcc6hlMUZLuusrlq3vjzxBCkBjlUDofDYaEYW5NYntyBe1MMmuD3w6IdxbFj5MdcxTGfu/lAZTshF0CSgbT2UwKazNJxYCpcTLFiSpAFz5m75ltFTcnOzacnuGZ2Eqv/MSH5pL3zrH6WrGzShh+ZCe9YonxfKc5y0ynXYbbh3bAJPMEDovkUTcGwv50HmaWk2iVDbQoq46DHPeGi2QmMXUvDzLReA9Yc0UreZJ/S9o6c6HJeI7EzpSc7WxtlXjzw/tdLQPqQds4JT4G4zLuPe5GiXSnPpwUm8zcQCBXz0jCRcYfUpanMDk/c07xsYiYgLu67z+/mc141tcgwe2EzN/49r7Zb8JeDlyGFbz9rjhaa9aeXVibqA/+nPtdXWy7Ss5SM/KWosK7EvHs9c4D5Jx8UH5A7XYztnNSr9v7XRw+I6Vxpi0XT0foYbl5KkNeJuB4BvigodEMHHTVM5Cz+RzXNSUJSnO5fPyWco9lBjdYLM2s7HPb8rUV7VBc0+FYO+jjlH8T0YHkz+HtHihsX9ZqyJ/2OuqfQQc60IkFNQLakIMllsc0rwzs+LJK9MXfBSZnEYrXq27N0QAPUHCizENknvQhbiwDPBjzjmSYwGjX6r7nmcfovUdQO+OTGLc9Rkj8YdSYgAUZCkafp0X9xnPClmrMZZ+if8acStS6pBSXOuWGIi
 5AQ/I+xX
 +F0oFbjtekpAv9o1iPTFpYLnJXwVJlZkfqasYEQ1G32XXUfgtHQOSAJPLAffKIN4+Ycum4TApeDp3P+quhMY4xXF8dDwJ98erFpy6f0cF6AWZtL7Y7BzmqxhGucUxYGn94xrYDVs034L6jkYjqdkCCpkTqhMZwXnUNxcAPZ7V2JeKiEukjLwjD8CN7Q9+rj6QRFlraR5JXSVzLTSfCOImjbAWYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/11/2025 11:45, Kevin Brodsky wrote:
>>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>>> index b8d37eb037fc..d9c8e94f140f 100644
>>> --- a/arch/arm64/mm/mmu.c
>>> +++ b/arch/arm64/mm/mmu.c
>>> @@ -731,7 +731,7 @@ int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
>>>  		return -EINVAL;
>>>  
>>>  	mutex_lock(&pgtable_split_lock);
>>> -	arch_enter_lazy_mmu_mode();
>>> +	lazy_mmu_mode_enable();
>>>  
>>>  	/*
>>>  	 * The split_kernel_leaf_mapping_locked() may sleep, it is not a
>> This is a bit unfortunate, IMHO. The rest of this comment explains that although
>> you're not supposed to sleep inside lazy mmu mode, it's fine for arm64's
>> implementation. But we are no longer calling arm64's implementation; we are
>> calling a generic function, which does who knows what.
>>
>> I think it all still works, but we are no longer containing our assumptions in
>> arm64 code. We are relying on implementation details of generic code.
> I see your point. The change itself is still correct (and required
> considering patch 8), but maybe the documentation of the generic
> interface should be clarified to guarantee that the generic layer can
> itself cope with sleeping - without any guarantee regarding the
> behaviour of arch_*_lazy_mmu_mode.

Re-reading the existing comment in <linux/pgtable.h>, I think it already
makes clear that sleeping is not forbidden by design:

>  * In the general case, no lock is guaranteed to be held between entry
> and exit
>  * of the lazy mode. So the implementation must assume preemption may
> be enabled
>  * and cpu migration is possible; it must take steps to be robust
> against this.

The arch implementation may disable preemption, but arm64 code can rely
on the arm64 implementation allowing sleeping.

- Kevin


