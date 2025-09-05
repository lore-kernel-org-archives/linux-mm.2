Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93695CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 12:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C54926B000D; Fri,  5 Sep 2025 08:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C466B000E; Fri,  5 Sep 2025 08:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B692F6B0011; Fri,  5 Sep 2025 08:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A58DD6B000D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 08:22:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3E737B63CA
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:22:57 +0000 (UTC)
X-FDA: 83855110794.02.3A6DDFB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8F60940012
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:22:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757074975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ywmDAG7PE2fj1+B2GkU5RbYTyU3sAGy8lTlonC3Qgos=;
	b=5ddhZ1ms1rKtdmCYSCNH6iQt3dS8q+mtr6fT2MSVHofiRwDsN/uSG3Ovo36CeXefheha7/
	HWw8oKjv5FuBqYA4C1e+Hhb5dRCItZ8iz6nynpmLWweM5cTUgPTRvD405F8b9uN+7eOGZQ
	AsxRwRZd3wfNgSFMOfvfIz52ZsBWEkc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757074975; a=rsa-sha256;
	cv=none;
	b=BlcNYuxmiFImFe2uuqrv/IHp2CoD7kb8EKiV9fNr+BwYbVmPZptPrpPaFnllyJOJQ/Wbhb
	cqLC76V9QqJc3vjYvaM9e3PB4BN1SEO6EBrT9HNbfPRfPcMoS8w9DsXl2KeJGfkjUCCCqp
	WaVoCjkKt6bfjK7rfEqSLGs8Eat/0dI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2012D153B;
	Fri,  5 Sep 2025 05:22:46 -0700 (PDT)
Received: from [10.57.60.42] (unknown [10.57.60.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7BF93F63F;
	Fri,  5 Sep 2025 05:22:48 -0700 (PDT)
Message-ID: <a18f9cbd-490d-4270-8707-4ed6d730cfcd@arm.com>
Date: Fri, 5 Sep 2025 14:22:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] mm: introduce local state for lazy_mmu sections
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
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org
References: <20250904125736.3918646-1-kevin.brodsky@arm.com>
 <20250904125736.3918646-3-kevin.brodsky@arm.com>
 <22131943-3f92-4f5a-be28-7b668c07a25c@lucifer.local>
 <75db1f58-98b3-463c-af4f-2ce9878cba9f@arm.com>
 <2aed0b3b-1a70-4c89-9177-8de4fabb2237@lucifer.local>
 <e6072568-1b98-4a7f-8d30-65417a440bb7@lucifer.local>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <e6072568-1b98-4a7f-8d30-65417a440bb7@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8F60940012
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jt66bmia9aptsid4byg9jud89o5ab7xq
X-HE-Tag: 1757074975-43265
X-HE-Meta: U2FsdGVkX1+ypyEWi/+2t0D4nUtHmtQIO1WOLJQgLa+css5VhbPDh5ScfVtfMOYObvBsAuUOTQzjncU/LLHYFkq18t6z3xX3y1poJaecNQ0URt8lxbHlyJDgbZM4txjJW47e9pIAjZYgqK/YjP0Jdvw+mC1CRtHx9e8A9pZ3Eopn5jivXa9adiyvWhUwUQ9QNRh+2sKdbI+wXve9IHCT4ozpjUhM1/J9+mq92V1mgTrcRuI3JM6B8dJsITw66OpT+eMUEIvRalajQGbwMGfOKZXJcQr1XPPJJ9699aaE/6i+/3MvUOrKIIpLDeyNV+m9n1+YkhDIL7SzI/V1Iy5ojnQFzzNPzU7mlKxjN8yTTwig8Va7PlcCyULt0je1DjCnfL7dQDjkrRN66zDIUeCoX105vLmV7DQUFrrEIzWxtohIhJDvcVbWe2smPYoxU4wkEQNqs+kXSHzzkKgsOHIQTe+8S9AmrIT6r4KnWy2ysoEwwX9FZrUIliBFJeiETJYBNiSVk3oLEnPIG6bC5Io2JNzZy2E/R4gc8ftlqJycg9DrppX74/GSds76pnp/GJGU65bloiWJJeCa4u4Ebp1BRP1ylnTpc5vqoJZy3v9IZcXE284iCQwlyZr/W3wpnRpfdOHuN9TVH2vnAJC/GLPO9cVHDRURTY7d1zV3XMjJqOC8XcreJBIuOAKSOFELZ3WtekMpnJ9SNlHDcDUuIe8yugZn7OzdVpUSFgeGi8WObD9O3BrLoAR2BF8SahGP53fD1TMerHeRGi2AGm+iCrplEmd0P1cbPh9OSB7QMAeRROy0cBZDchrHO+ehiwmw5ZPOy8+WvF6l1Nfk9/uPVpYqWrjShtayxpDebDeSM3Yh5TslSnXMQ8Y1wheekzlIW+Rj2q8OeKnRINMZsqxDg7g4ikKIKjsNXRWoT6x+PTxUHIBRsnxhEq20gwFPBDM+syJYZq+y4YguCnQQhFSl53k
 cbyZzeon
 DnUiJJP7OgVtgyCoulXlFA1vkxlnAAuOUH70h3XZsxxpmE0YGm1gybdj7J3DTjlIRl1t/0TprT3PxqsKLfvGSFLT8Nj8tBn2jJxo9uSiG/UyDBO5SqGTlVSWx5twqcMsgy3qbi2imq9xyXx3wvUJoJE4YqAMV5psUhkk4lmAEdiAjAb8/668wuxLRJtE6hry50YSK6Xga7zSMI0zuo/pQsY0vfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/09/2025 13:37, Lorenzo Stoakes wrote:
> On Fri, Sep 05, 2025 at 12:21:40PM +0100, Lorenzo Stoakes wrote:
>> You should really base on mm-new.
>>
>> You need to account for everything that is potentially going to go
>> upstream. mm-stable is generally not actually populated all too well until
>> shortly before merge window anyway.
> Just to note that mm-unstable is also fine. Despite its name, it's substantially
> more stable than mm-new, which can even break the build and appears to have no
> checks performed on it at all.

Thanks for the overview - I had a general idea about those branches but
I wasn't sure what the standard practice was. I'll rebase on mm-unstable
to start with.

- Kevin

