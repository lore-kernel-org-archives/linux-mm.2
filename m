Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27BEDD41C36
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 14:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A0366B0006; Thu, 11 Dec 2025 09:00:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751236B0007; Thu, 11 Dec 2025 09:00:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667646B0008; Thu, 11 Dec 2025 09:00:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55D876B0006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:00:02 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1AD5C0176
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 14:00:01 +0000 (UTC)
X-FDA: 84207349002.22.1641DE0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0498240004
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 13:59:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765461600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xs/3AOuZdsztLPquHqeRtr+v3dXXVtUFLlZnFglksuA=;
	b=59BBg+RDX2eC7r93ukW73Gog5cBO5OdjIoCnUNBbjPk8ivhOlLxxSPDmjBmAf1jIU+tjP9
	H/uS6UbbrspwQdCgjUJJ+Us9CpkBme6tvuUOrdGkDpUOWP+tM3xzB4j/NN7e/aTH4jniLp
	PeoGOQE7eI0T/02ZV7Eg+vyZGOIPj5E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765461600; a=rsa-sha256;
	cv=none;
	b=23djOtTv987tkokMOLneFAvXU7/fm8372fD/6lHIoPmkxq2HnLaZPKHBou1Z/C+Bf0TwCy
	upTXj9qhsJgmeBpBsyBTV9rb26MordgLuRAJYZHh8tocxX+bmRi8cS7AwH1cNbUvqsR7I9
	CYifiNGQxjdt3yiEhZ9VFzjNCyg7V/w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DEE41688;
	Thu, 11 Dec 2025 05:59:51 -0800 (PST)
Received: from [10.57.90.205] (unknown [10.57.90.205])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 05CCA3F73B;
	Thu, 11 Dec 2025 05:59:54 -0800 (PST)
Message-ID: <a063f6c5-2785-4a9f-8079-25edb3e54cef@arm.com>
Date: Thu, 11 Dec 2025 13:59:53 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/22] mm: Allow page table accessors to be
 non-idempotent
Content-Language: en-GB
To: Samuel Holland <samuel.holland@sifive.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org
Cc: devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
 Emil Renner Berthing <kernel@esmil.dk>, Rob Herring <robh+dt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-9-samuel.holland@sifive.com>
 <fbfef7fc-4030-462b-b514-498eea6620aa@arm.com>
 <c2597d43-d909-4259-bb5b-9294e4069385@kernel.org>
 <af8fd275-a34d-4b2f-8834-9c85dab2bbae@sifive.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <af8fd275-a34d-4b2f-8834-9c85dab2bbae@sifive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zcnou43wemq5yrsoaefj3xqc6dyze4ak
X-Rspamd-Queue-Id: 0498240004
X-Rspamd-Server: rspam06
X-HE-Tag: 1765461599-236877
X-HE-Meta: U2FsdGVkX19dfxGev89PwfK+S4wb/UycQW2xLhWeDQQbMyBao5vRusPha11YvzMlwVfVwYo63Ez7LhlDYeKQr+qpSMLQt50QW3lbMNUwa3EiIWQGP/9GYvJ6CNr5wLyL9gJE3+LJ1mxnby5/CCbHPza2GKIxolzipahuTaNK/935Pj52m/e1Fcz/KOUFOQ4yERQSn+GD5Hr2XQLOjNuDaPlWIqypto7KNRpcWo2qPaajx0O7RZCjY4M2b/6XCVOVpy7PynOe2oVYSZTHdsYvvsUwzB3FehQNsMQ8Mbh7eko7ymLTTepOSWwWxA6yCL0sHymBopWvnyEdtg0YRu3TT7CjIcf9jsBkcKr+jE0ASJKSrVe6DMI1MwPyUYvdlPyGAvTRryKTB1XpQGF8Gt7jyuO8kQPxkk+8fjthsz7vFnt9E6bnaKu2NDijK/XkWwWPb2BhBd07yH1R8dALuZquL69DjkIpeKDpobQu7whZHm3Av2pioyZ8Gq/JidcbyjxOuamKT+hW9/ZiY47CsP1ip5zymQWt9frkelQrRG9VB4gAybyo5pYSNQXNNHDeQHdrn5/GbxA6E0qS6sfWqY/LQLi/QA5W4AgfrwqvpM3igTqo9LXVnhddbUakmMfidjfOkwv5WMdrHDKFAwpeC2g+4IJclO/kftKFpm2oU8lZ51cmmiasf8PkWmwuQ7zj9uvPrJnPtxwtJm4n9u4xUFSk6NugiEmu0O6cbEu61CA8O82j30Na/5DhsfQwCz+Br1KfU38Cg5JcFMyr57DiBDeE3Nh16xCr+BULLMhBcUB/2Pn+w4hFKEL+kKDok862u6DJ6Bc3uC5wwcV49caKXhuj3Y9fza1gV85mYiAdeLdNb1N6lTkUhJ8VQxyKHq5EeIFL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/12/2025 00:33, Samuel Holland wrote:
> On 2025-11-28 2:47 AM, David Hildenbrand (Red Hat) wrote:
>> On 11/27/25 17:57, Ryan Roberts wrote:
>>> On 13/11/2025 01:45, Samuel Holland wrote:
>>>> Currently, some functions such as pte_offset_map() are passed both
>>>> pointers to hardware page tables, and pointers to previously-read PMD
>>>> entries on the stack. To ensure correctness in the first case, these
>>>> functions must use the page table accessor function (pmdp_get()) to
>>>> dereference the supplied pointer. However, this means pmdp_get() is
>>>> called twice in the second case. This double call must be avoided if
>>>> pmdp_get() applies some non-idempotent transformation to the value.
>>>>
>>>> Avoid the double transformation by calling set_pmd() on the stack
>>>> variables where necessary to keep set_pmd()/pmdp_get() calls balanced.
>>>
>>> I don't think this is a good solution.
>>
>> Agreed,
>>
>>     set_pmd(&pmd, pmd);
>>
>> is rather horrible.
> I agree that this patch is ugly. The only way I see to avoid code like this is
> to refactor (or duplicate) the functions so no function takes pointers to both
> hardware page tables and on-stack page table entries. Is that sort of
> refactoring the right direction to go for v4?

From a quick look at the code, I think that some cases are solvable by
refactoring to pass the value instead of the pointer, and leave it to the higher
level decide how to read the value from the pointer - it knows if it is pointing
to HW pgtable or if it's a (e.g) stack value.

But the more I look at the code, the more instances I find where pointers to
stack variables are being passed to arch pgtable helpers as if they are HW
pgtable entry pointers. (Mainly pmd level).

I wonder if we need to bite the bullet and explicitly separate the types? At
each level, we have:

 1. page table entry value
 2. pointer to page table entry _value_ (e.g. pointer to pXX_t on stack)
 3. pointer to page table entry in HW pgtable

Today, 1 is represented by pte_t, pmd_t, etc. 2 and 3 are represented by the
same type; pte_t*, pmd_t*, etc.

If we create a new type for 3, it will both document and enforce when type 2 or
type 3 is required.

e.g:

// pte_t: defined by arch.
typedef unsigned long pte_t;

// ptep_t: new opaque type that can't be dereferenced.
struct __ptep_t;
typedef struct __ptep_t *ptep_t;

// getter/setter responsible for cast & deref as appropriate.
pte_t ptep_get(ptep_t ptep)
{
	return READ_ONCE(*(pte_t *)ptep);
}

int do_stuff(void)
{
	// value on stack: ok
	pte_t mypte;

	// pointer to value on stack: ok
	pte_t *pmypte = &mypte;

	// handle to entry on stack: not allowed by compiler!
	ptep_t myptep = &mypte;

	// handle to entry in pgtable: ok
	ptep_t myptep = pte_offset_kernel(...);

	// read value of pgtable entry: ok
	pte_t val = ptep_get(myptep);

	// attempt to pass pointer to stack variable: not allowed by compiler!
	pte_t val = ptep_get(&mypte);

	// attempt to directly dereference ptep: not allowed by compiler!
	pte_t val = *myptep;
}


We could do this incrementally by initially typedefing ptep_t to be:
typedef pte_t *ptep_t;

Then we could flip the switch arch-by-arch to enable the stronger checking. We
likely wouldn't need to convert arches that don't care.

I think by doing this, it will expose all the current issues and force us to fix
them properly.

On the related subject of conversion to pXXp_get(); I've been looking into this
and personally, I think we should have 2 helper flavours at each level:

 - pXXd_get()      optimizable by compiler; defaults to C dereference
 - pXXd_get_once() single-copy-atomic and unmovable by compiler

It simplifies the converstion process, and reduces the risk of bugs
significantly (go read about the arm32 issues discussed in Anshuman's series if
you haven't done already).

I appreciate this is all probably a lot more work than you would prefer to sign
up for, I'd be happy to collaborate if we get concensus that this approach makes
sense. What do you think?

Thanks,
Ryan


