Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8560AD609D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 17:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBF9F6B0005; Tue, 16 Dec 2025 12:47:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6CC26B0088; Tue, 16 Dec 2025 12:47:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6C686B008A; Tue, 16 Dec 2025 12:47:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AE3196B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:47:06 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 40E88134DAD
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 17:47:06 +0000 (UTC)
X-FDA: 84226065252.09.E8CA92D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 57CDAA0015
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 17:47:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765907224; a=rsa-sha256;
	cv=none;
	b=WrpyNopRFfnvnq5xdiseNe46ISALeXhvIDjIu9Yjwhjx51ErKDjwC7MHgoutNmyED2agSa
	TUPfZ+dCUC7JTp7Pyirr+IWljV8dajwJQvh5GXBI+DSPRSJyGAB0tNM0wih5PXywg2VeFA
	ZhfJaigIx8l6qRF9PbAss4QKPjoH7J0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765907224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D1HiroPOif0WbEFnu1y16KcLotAM7+v45t55Xub1H7E=;
	b=rxywjzpCics4bf4CvGnfKi4a4hgMglNFw9UPzt3Ea8dYXLxzqcu5K5zMV1FqOMfISx/Y75
	HVhNSQnchIjg+kUPPXaiB5Jslty2MMrltob5oCeaWzjQNrdgD1W5i60StXmFR3tuWU9D+5
	t8JD2CSqkvrXryoeDcRvWNk39lKnxuc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DBEAFEC;
	Tue, 16 Dec 2025 09:46:56 -0800 (PST)
Received: from [10.57.91.77] (unknown [10.57.91.77])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B66F33F73B;
	Tue, 16 Dec 2025 09:46:59 -0800 (PST)
Message-ID: <7b6a203f-a141-45f7-8a09-a2266e125d22@arm.com>
Date: Tue, 16 Dec 2025 17:46:57 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/22] mm: Allow page table accessors to be
 non-idempotent
Content-Language: en-GB
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Samuel Holland <samuel.holland@sifive.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, devicetree@vger.kernel.org,
 Suren Baghdasaryan <surenb@google.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Conor Dooley <conor@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Alexandre Ghiti <alex@ghiti.fr>, Emil Renner Berthing <kernel@esmil.dk>,
 Rob Herring <robh+dt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-9-samuel.holland@sifive.com>
 <fbfef7fc-4030-462b-b514-498eea6620aa@arm.com>
 <c2597d43-d909-4259-bb5b-9294e4069385@kernel.org>
 <af8fd275-a34d-4b2f-8834-9c85dab2bbae@sifive.com>
 <a063f6c5-2785-4a9f-8079-25edb3e54cef@arm.com>
 <9eda3825-64bf-47d9-ab4a-0a536b2d6474@lucifer.local>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <9eda3825-64bf-47d9-ab4a-0a536b2d6474@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 57CDAA0015
X-Rspamd-Server: rspam04
X-Stat-Signature: tstjwtwknfcuaj7kiff7kohj3ex13cw4
X-HE-Tag: 1765907224-964239
X-HE-Meta: U2FsdGVkX18n/yQUCw5SyyzIBgx30Iily/8OkRb3HIIJ9KlCyOx8jfPFpWVlXkgIQbhdh9JMAJ7aomhayVO/EYsQO0b/Vv539FGNBxSlTTp1aXDOpNb541+qed8oMtDXFJvqA3MLKPnjbupJ7IxzycuNrnD61NiQZP+RbI6mzBIHbCVXLCJvDibA/4LNExwyCHtTXwNkUf8LlI5h0cjj6XQZjMCDwL8+ied7dPCRYN6TopZCmqSPMifyDuM7ZM3W0TQ0rw1QrOZyA+u0e9msisv9JeuHeUB9AxQ6iXQ1sp/So3Gm1zz6MPLEaoz6PX8GRyH0ZV3yevI9p9bHz/JF5rWt/gaMk+l/tffESUhSCakpxWZs29b9fiA7ofIlMOqt+01pq9veOQIicLMckvQ9voIG0JTEOgssu5G6Pthv52V2T1jMSKFZPDI+9s6grv/n0pdUKlcBVt+0LokFNDRmDqFwPTNePt2zFUFnbgQbHJXEPSkBf3VcdsGK08LkeqjvFrH+HiJZmpefJe/tLdIZ9liiwtkByneK2hQlzG7CBPuo3imM//LxB7zbBAg/fH57ye3NRpn42HpEKsw2XrnhTs3RsPhO/EW0F+k/5TYBwFPk2mtf35hBI7uN/rYvFE6MeJjrIJUIAyrXLcpMYyHCCRzXIweY904wj9Wz6216NAB0rsuJbQbkDlfmAa1lmveGpkGC81aed5zBEbKpYYHpdZv6PMs+2TAg4FjhkluX3Cw1bUqW/Jrob2l3RbGDi1ForbF6kGEWqOWKghePaWeiuQivXS/3IKgXzlpzaA8h9/Xf8AbkvujTYBs0PIz3PM/3uKMEC0SGsvMzhSe8ta0XTuGHYkY/QOHgAGpcTjjumo+heJkfkuHxY3sgyTvkzUv/C2MWQ7MM9O2NJ6UphC4WaQ6x6gVSS2+iPuUXtdHIihGAjrXHPimysFbaFt30p1iSBTwwxGM1/w554OQwb55
 1eL9NvhP
 tlVU0pM9WEumSDB/9vpqe2rY0LmeTMT06NnN+WjTTIlmBDzBfLQ65ARrrDDClpeUdXqh8wv5CMOIbDt5/HrNwP5T6toKXHT98jM6UBfzBAkuwX3Bas5qDG9BgQMfybUvUPf42lGolKrA7anyJTGxJvXgc4LBl+BUszhlwl793nr9TnjHpVpgDtWH+6CdkUBEnjMzN9tOIDV+DIGsWiMTfCgsUFDkHgKevT4tWGz5+jG5LaMcAKPqgcZUmzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16/12/2025 10:29, Lorenzo Stoakes wrote:
> On Thu, Dec 11, 2025 at 01:59:53PM +0000, Ryan Roberts wrote:
>> On 11/12/2025 00:33, Samuel Holland wrote:
>>> On 2025-11-28 2:47 AM, David Hildenbrand (Red Hat) wrote:
>>>> On 11/27/25 17:57, Ryan Roberts wrote:
>>>>> On 13/11/2025 01:45, Samuel Holland wrote:
>>>>>> Currently, some functions such as pte_offset_map() are passed both
>>>>>> pointers to hardware page tables, and pointers to previously-read PMD
>>>>>> entries on the stack. To ensure correctness in the first case, these
>>>>>> functions must use the page table accessor function (pmdp_get()) to
>>>>>> dereference the supplied pointer. However, this means pmdp_get() is
>>>>>> called twice in the second case. This double call must be avoided if
>>>>>> pmdp_get() applies some non-idempotent transformation to the value.
>>>>>>
>>>>>> Avoid the double transformation by calling set_pmd() on the stack
>>>>>> variables where necessary to keep set_pmd()/pmdp_get() calls balanced.
>>>>>
>>>>> I don't think this is a good solution.
>>>>
>>>> Agreed,
>>>>
>>>>     set_pmd(&pmd, pmd);
>>>>
>>>> is rather horrible.
>>> I agree that this patch is ugly. The only way I see to avoid code like this is
>>> to refactor (or duplicate) the functions so no function takes pointers to both
>>> hardware page tables and on-stack page table entries. Is that sort of
>>> refactoring the right direction to go for v4?
>>
>> From a quick look at the code, I think that some cases are solvable by
>> refactoring to pass the value instead of the pointer, and leave it to the higher
>> level decide how to read the value from the pointer - it knows if it is pointing
>> to HW pgtable or if it's a (e.g) stack value.
>>
>> But the more I look at the code, the more instances I find where pointers to
>> stack variables are being passed to arch pgtable helpers as if they are HW
>> pgtable entry pointers. (Mainly pmd level).
> 
> Ugh. We do need to nip this in the bud I think!
> 
>>
>> I wonder if we need to bite the bullet and explicitly separate the types? At
>> each level, we have:
>>
>>  1. page table entry value
>>  2. pointer to page table entry _value_ (e.g. pointer to pXX_t on stack)
>>  3. pointer to page table entry in HW pgtable
>>
>> Today, 1 is represented by pte_t, pmd_t, etc. 2 and 3 are represented by the
>> same type; pte_t*, pmd_t*, etc.
>>
>> If we create a new type for 3, it will both document and enforce when type 2 or
>> type 3 is required.
>>
>> e.g:
>>
>> // pte_t: defined by arch.
>> typedef unsigned long pte_t;
>>
>> // ptep_t: new opaque type that can't be dereferenced.
>> struct __ptep_t;
>> typedef struct __ptep_t *ptep_t;
>>
>> // getter/setter responsible for cast & deref as appropriate.
>> pte_t ptep_get(ptep_t ptep)
>> {
>> 	return READ_ONCE(*(pte_t *)ptep);
>> }
> 
> I think we've got ourselves in a jumble with pte vs ptep vs pteval
> vs. etc. etc. and we aren't always consistent with it.
> 
> So I think we ought to put 'hw' somewhere in the name.

Yeah that would probably give the best end result. I was thinking that ptep/pXdp
might reduce churn since we already use it in function names. Stack pointers are
definitely a small minority so easier to change their convention.

But having an explicit "hw" would probably be best.

> 
> And we can also now get away from the overly abbreviated names given we have the
> chance :)
> 
> So something like 'pte_hw_t' perhaps?

sounds good. Or hw_pte_t? Then "pte_t" is still greppable and it better matches
the hw_pte_get() that you have below.

> 
> I like the general concept, though I think it's kinda gross to hide the fact
> that it's a pointer in the typedef _that_ directly.

My aim was to have a type that you can't dereference, can't accidentally pass as
a pte_t* and also can't increment/decrement/index.

This gives us a framework where the architecture can completely virtualize the
pgtable if it likes; and the compiler can enforce that higher level code can't
accidentally work around it.

I have a couple of use cases where these properties will come in handy; arm64
now defines 128-bit pgtables. We have a prototype adding it to the kernel, but
at the moment it has to be a compile time descision so that all the generic code
knows the size of the entries. It would be preferable to make it a boot time
decision, based on the HW capabilities (or cmdline, ...). But for that, we need
to better insulate the physical pgtables from the core-mm. This concept solves that.

> 
> So perhaps be less horrid if it was something like:
> 
> typedef struct {
> 	pte_t *ptr;
> } pte_hw_t;
> 
> Perhaps?

I _think_ that works for the above, and it is certainly nicer.

pte_hw_t pte_table = pte_alloc(...);
for (i = 0; i < PTRS_PER_PTE; i++)
	hw_pte_get(pte_table[i]);

I think that would fail to compile, right? Which is what we want. Instead we
need something like:

pte_hw_t hwpte = pte_alloc(...);
for (i = 0; i < PTRS_PER_PTE; i++, hwpte = hw_pte_next(hwpte))
	hw_pte_get(hwpte);

> 
> Then could have:
> 
> pte_t hw_pte_get(pte_hw_t pte_hw)
> {
> 	return READ_ONCE(*pte_hw.ptr);
> }
> 
>>
>> int do_stuff(void)
>> {
>> 	// value on stack: ok
>> 	pte_t mypte;
>>
>> 	// pointer to value on stack: ok
>> 	pte_t *pmypte = &mypte;
>>
>> 	// handle to entry on stack: not allowed by compiler!
>> 	ptep_t myptep = &mypte;
>>
>> 	// handle to entry in pgtable: ok
>> 	ptep_t myptep = pte_offset_kernel(...);
>>
>> 	// read value of pgtable entry: ok
>> 	pte_t val = ptep_get(myptep);
>>
>> 	// attempt to pass pointer to stack variable: not allowed by compiler!
>> 	pte_t val = ptep_get(&mypte);
>>
>> 	// attempt to directly dereference ptep: not allowed by compiler!
>> 	pte_t val = *myptep;
>> }
>>
>>
>> We could do this incrementally by initially typedefing ptep_t to be:
>> typedef pte_t *ptep_t;
> 
> Hm yeah still hate the idea of typedef'ing this as a ptr so directly.

What's the problem with it?

> 
> Obviously this would make an incremental thing a little harder, but could have
> this stuff on top of existing logic and make it incremental by changing logic
> bit-by-bit?

I'm not sure... sounds to me like we would need to convert absolutely everything
including arches that are difficult for most people to test. With the "typedef
pte_t *hw_pte_t;" approach, you can go bit-by-bit and leave those unloved arches
alone entirely.

> 
>>
>> Then we could flip the switch arch-by-arch to enable the stronger checking. We
>> likely wouldn't need to convert arches that don't care.
>>
>> I think by doing this, it will expose all the current issues and force us to fix
>> them properly.
> 
> Yeah this is nice.
> 
>>
>> On the related subject of conversion to pXXp_get(); I've been looking into this
>> and personally, I think we should have 2 helper flavours at each level:
>>
>>  - pXXd_get()      optimizable by compiler; defaults to C dereference
>>  - pXXd_get_once() single-copy-atomic and unmovable by compiler
> 
> Yes!
> 
> There is some _real_ confusion about when and when we don't need to do this.

I think the requirements are basically this:

"_ONCE" gives 2 properties; single-copy-atomicity and compiler can't move/remove
instructions.

SCA is important to prevent tearing if the HW can update the PTE concurrently
with SW reading it (i.e. HW access/dirty) or if SW is reading without holding
the PTL. But there are times when it doesn't matter if the PTE gets torn because
you are only comparing the result using pte_none() or pte_same().

The "compiler can't move/remove" property (I'm sure there is a formal name for
this?) is important for lockless walkers. Probably you could achieve similar
results by using barrier()?

> 
> Though wouldn't having a typdef separating out a hw entry imply that hw entry ->
> get once, sw entry -> get?

No; you should never use the accessor methods for sw entries - they are just
variables - read them normally. If all HW accesses use "once", then the compiler
can't optimize away the accesses for the folded pgtable case.

> 
>>
>> It simplifies the converstion process, and reduces the risk of bugs
>> significantly (go read about the arm32 issues discussed in Anshuman's series if
>> you haven't done already).
> 
> Though I haven't read this series so can't remember actually if there were cases
> where even with hw entries we wanted to sometimes READ_ONCE() and sometimes not?

Yes exactly that.

> 
>>
>> I appreciate this is all probably a lot more work than you would prefer to sign
>> up for, I'd be happy to collaborate if we get concensus that this approach makes
>> sense. What do you think?
>>
>> Thanks,
>> Ryan
>>
> 
> Thanks for this concept, overall very much in agreement!

I think it would work but it's going to be a lot of churn. But if you think it's
worth it and we'll be able to get it in, then I'm up for working on it in the
background.

> 
> Cheers, Lorenzo


