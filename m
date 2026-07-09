Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A166C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 09:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8D26B0088; Thu,  9 Jul 2026 05:55:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A056B008A; Thu,  9 Jul 2026 05:55:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D519F6B008C; Thu,  9 Jul 2026 05:55:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A5C06B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:55:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20C5C120453
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:55:40 +0000 (UTC)
X-FDA: 84968781240.21.FACACEA
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3593A40002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:55:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gs/boVWv";
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783590938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ElFNuuVHav11jlXT2tYgxUaeRfnidh0joOXtmtl3810=;
	b=hnyMnisvxWw2GJfmK/hO8NZbDV8xD5cP0Z2iYyzVXkznvR0rQfIlHfhljyoWIcR1pt2x18
	lSKmUU00TnQUJaiBMt1nkyhXvq92LFgCx6+PBWEmb/gfSfPqEQxwy8O7J2rpd+TL19Sp5n
	COJnsrxqoqoO3+OyUYLbWQikc6Jnf8k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gs/boVWv";
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783590938;
	b=IX6NXeoHg3p+q5ExYV8j1u0Pi7Pfd3c2foo00nASPA33R3uubh8ZiOisA593kD7WJtdKRx
	anAXdur7NdJR6VAas9J8EqHAtggmHXB1Po6NG8lFGQT2SdhkGFoTf7eqvpTLvUbOhgsEqp
	qWHdoA6vuvOxNg3cbYd2wYaG1PTA0G8=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783590936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ElFNuuVHav11jlXT2tYgxUaeRfnidh0joOXtmtl3810=;
	b=gs/boVWvqp9saHyn5lfka+F54TUV/ESt2lma5lx2+y3wAuHWuvFi8z8bUd7lGvjGqMTCTw
	xmyeNZXZVYS0vLdnhlkQE8ah/XNhliWvKtBS4t+A2AvfTLx7qZAXMayb6YYeJvnPl9Rsen
	rIc9SKpxCht6wdPhAZK/YmtdlttInOc=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 00/18] Another attempt at HVO support on arm64
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CADrL8HVkrojXbBuEX-W=UHBmyyFzqxdGBvtAoPP53SyYa10uag@mail.gmail.com>
Date: Thu, 9 Jul 2026 17:54:45 +0800
Cc: Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oscar Salvador <osalvador@suse.de>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Linu Cherian <linu.cherian@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Nanyong Sun <sunnanyong@huawei.com>,
 Yu Zhao <yuzhao@google.com>,
 Frank van der Linden <fvdl@google.com>,
 David Rientjes <rientjes@google.com>,
 linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <ABB70C2A-316E-4C19-A855-C9920BE105E1@linux.dev>
References: <20260708031129.3503195-1-jthoughton@google.com>
 <FC9E78F0-8FF7-44AF-A848-8401B4702488@linux.dev>
 <CADrL8HVkrojXbBuEX-W=UHBmyyFzqxdGBvtAoPP53SyYa10uag@mail.gmail.com>
To: James Houghton <jthoughton@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3593A40002
X-Stat-Signature: 8jiignni36guy5741hg7i1nwzo3y6jex
X-HE-Tag: 1783590938-645444
X-HE-Meta: U2FsdGVkX1/f300YsPpWazNn9lyApKLyGFtvXHkFyE5ovuaInAHJJJsZ2HAgB4KI4czj5xcL4lNFolB2/jpy6HW0eXOthV3FCB8Tx9efxpNoVEUUGo/OzVJyC/wRQNxCTf48vQQZzm6Ld5qBedorIhJg0j90drXQ1yhXKkv4j5XEingVmJ7pmC87au/BceU6YDF1BE5DBgvuCSGgYD3PHC7nhx7dtWf+2AztWOtrXxihrP/pfO2DRO0PUrgDDUdHAHA3N3qWhm/BC95Ynz7qKxUaLRHyL0Box1cKmpjhlYwEdeIZlC4ZzTPNrhNbsLE/rIXAgbmApfm8kr0sHS/6C/IZePIjTI527A1cxlTzgnQqJMqY/EnzBStdaqj7TxyGPquF/TYTOaSpiXcIWQ3ZuS+PqstwzV2KjUYe83vOUqOp80Y1Z0uBam2edlmf2WDEan+RmDxDUypIFoE3ulMunqIwhz2CGr6jPMU18iahK0ZSAmIK9Axq9KWCfFbyx2TwFDky2c1NcZRJjyCXvgoHOFc2xIJQPk9k1hCLkf8B4vq6SOgMo2v7/iZd6bUiAhVoKTErJ6jH8bH4T/TNYOE15XtDjUfCZ13eH2QMddkLjfVX5nRLt4x80Rf+y45qRo0QLAlaUotr8pkjmwyd0PahyT1O9FK/G+xi9wGgoB1UYUDk6vSUkrzp7tXXFa5Aet0jurGv0QNLhFVuXwawgKWEVkYOAblknx9soqyRXzFJZIQwHotvJa4OhkqXg6VQvUif+9Ay5XuNdK0oVO91xo8HwZest4WOr5Htny79XCVCrEtIrD0r+MXfqNm09Zg7Mf6WTVFK1Al+1xQ8td7GzGblQyQPnNgYen+kjoGiURm1ZN8ceR+CJZWrszMYkb0+EnSdijfprmwTBmv+ZLbjlf6BM3chaeaU+dju4ZJo0/sKceQ1vM8+ORYKL6WZA/sAYyodHEzMt6ZSSnqXVXiKCgl
 PTsikCSJ
 hvMBaEYM8fxgHf1C5gvPirJjA68vRCV849rLwgHvfI68egMsi3w2cb7NJU+1Jtcl1IBgZYck9vcdnYajaCHQktvP15/+Pj0a+wqnTWwe00WJTINbbuwZBA5FhTs5RYH+eH6jBRMgg+sL//eB+OgQhzn2vfY0A8Ac7uMeWzCiBPz4t3kbnxwRfbCgzJ/2w69+UXwyf1O11PtiWJiHCfMO0ILiyta4PBreXriMCuC2Ec0QYVDcJrwO0KjbXt/LoGVYpXHbo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 9, 2026, at 00:49, James Houghton <jthoughton@google.com> =
wrote:
>=20
> On Wed, Jul 8, 2026 at 1:41=E2=80=AFAM Muchun Song =
<muchun.song@linux.dev> wrote:
>>> On Jul 8, 2026, at 11:11, James Houghton <jthoughton@google.com> =
wrote:
>>>=20
>>> Hi everyone,
>>>=20
>>> This patch series uses a trick with the Access Flag on CPUs that =
support
>>> hardware update of the AF to update vmemmap page table entries =
without
>>> introducing a time window where CPUs accessing the vmemmap might =
fault.
>>>=20
>>> By avoiding faults, the HugeTLB vmemmap optimization (HVO) can be
>>> implemented correctly on arm64 in a much more straightforward way =
than
>>> previously attempted, most recently here[1] (please see [1] for a
>>> breakdown of the other approaches attempted before).
>>=20
>> Hi,
>>=20
>> Thanks for your ongoing efforts on supporting HVO on arm64. This is =
truly
>> one of the most useful features that arm64 has been missing for a =
while.
>=20
> Hi Muchun,

Hi,

>=20
> Thanks for taking a look so quickly. :)
>=20
>>>=20
>>> For large-memory systems that allocate most of their available =
memory to
>>> HugeTLB, HVO saves a huge amount of memory (1.5% of system memory).
>>>=20
>>> This series has four parts:
>>> 1. Some preparatory changes (patches 1-3)
>>> 1. Bare minimum HVO support (patches 4-10)
>>=20
>> It looks like there is a typo in the number here.
>=20
> Oh yes, so there is. I'll fix it in the next version of the cover =
letter.
>=20
>>> 2. Drop BBML2_NOABORT requirement for HVO (patches 11-13)
>>> 3. Drop the user-configurable Kconfig for HVO (patches 14-18)
>>>=20
>>> Parts 3 and 4 are technically optional. More details below.
>>>=20
>>> The main functional caveat with this series is that bootmem HugeTLB
>>> pages are not "pre-HVOed". They will be HVOed, but because at =
pre-HVO
>>> time SMP CPUs have not been enabled, we cannot query for full system
>>> support.
>>=20
>> Do you mean that the support for AF might vary across different CPUs?
>> I'm not that familiar with arm64, so it seems a bit strange to me =
that
>> such basic hardware features can differ so much from one CPU to =
another.
>=20
> Yes, hardware updates of the Access Flag is a per-CPU feature. It is
> available for a CPU to use if TCR_EL1.HA is set. TCR_EL1 is a system
> register; each CPU has its own. (Linux will always enable HW AF for a
> CPU when it is onlined[1] if support is advertised, so we simply need
> to check if support is advertised to know that it is in fact enabled.)
>=20
> These days it is not uncommon for a system to have two (or more?)
> different core implementations, like with "fast" cores and "efficient"
> cores.
>=20
> [1] See the CONFIG_ARM64_HW_AFDBM bits in arch/arm64/mm/proc.S

Thanks for your detailed explanation. When enabling HVO via the cmdline,
can we simply prevent CPUs that do not support AF from coming online?
Would implementing it this way be much simpler? In practice, developers
definitely know whether the current system is suitable for enabling HVO.
If some CPUs do not support AF, they would just need to evaluate the
trade-off between memory savings and having fewer online CPUs than =
expected.

For scenarios where HVO is enabled via sysctl, we simply need to check
if all CPUs support AF. If any do not, the system should return an =
error.

Then, we can proceed with the Pre-HVO.

>=20
>>> This series is based on 7.2-rc2 (0e35b9b6ec0f).
>>>=20
>>> This series almost 100% cleanly applies to mm-new, which has some of
>>> Muchun's HVO patches, with one trivial conflict. I imagine this =
series
>>> will conflict pretty heavily with some of Muchun's other patches[2].
>>=20
>> You know, as we iterate on HVO, the codebase is becoming increasingly
>> complex and difficult to maintain. Aside from the work in [2] that =
you
>> mentioned, I actually have some local patches aimed at refactoring
>> hugetlb_vmemmap.c as well to reduce this maintenance complexity. I =
really
>> want to avoid piling more code on top of it right now, as that would
>> only make things worse.
>>=20
>> Therefore, my personal suggestion is that if this approach is
>> theoretically validated on arm64, it it better to wait until the HVO
>> refactoring is complete, and then review your work based on the clean
>> codebase. For now, what we need to focus on is evaluating the =
feasibility
>> and soundness of the approach itself. What do you think?
>=20
> I agree. The first order of business should be for the Arm folks to
> tell me if they think this approach is unsound (though I've been
> chatting with Will about this for quite some time :)).
>=20
> I'm happy to rebase on top of your refactoring work when it is ready.
>=20
>>>=20
>>> -- The AF trick --
>>>=20
>>> The trick is that translations with the AF unset cannot be cached in =
the
>>> TLB (see Rule R_DWZCQ in the Arm ARM), so they can be atomically =
updated
>>> without needing a full break-before-make sequence.
>>>=20
>>> So the PTE update sequence becomes:
>>> 1. Atomically clear the AF on the existing PTE.
>>> 2. Invalidate the TLB.
>>> 3. cmpxchg the AF=3D0 PTE with the new PTE. If this fails, goto 1.
>>>=20
>>> If there is a CPU on the system that does not support hardware =
access
>>> flag updates, clearing the AF is problematic, as those CPUs might =
fault
>>> on the vmemmap usage. Therefore, HVO compatbility checks all CPUs =
for HW
>>> AF updates.
>>=20
>> Sorry, I am not familiar with arm64, so I will leave it to the arm64
>> maintainers (or experts) to verify the feasibility here. Once the =
viability
>> of the approach is confirmed, I will look into the HVO-related =
implementation
>> details and consider how to support this feature on top of the =
refactored
>> code in the future.
>=20
> Sounds good, thanks Muchun.
>=20
> I'm hoping you can look at patches 1-3 anyway. I think they're the
> right thing to do, even without the arm64 changes.

Yes, I've looked it over. I think that making modifications across
several areas will be much simpler on top of my refactored codebase.
For example:

 - In patch 2: There is no longer a need to move vmemmap_get_tail().
 - In patch 3: Handling partially-HVOed pages becomes straightforward
               because vmemmap_restore_pte() no longer relies on
               ->vmemmap_tail to detect whether a restoration is needed.
 - In patch 4: I have updated the ->remap_pte callback to return an int
               as well, making it easy to adapt your changes.

Overall, the implementation is significantly cleaner, so I won't list
every detail here.

Muchun,
Thanks.

>=20
>>> -- Application to HVO --
>>>=20
>>> HVO relies on the following page table transitions:
>>> - When enabling HVO for a page, PMD block entries in the vmemmap are
>>>   shattered into PMD table entries. The first PTE remains mapped
>>>   normally (RW mapping to a real page of struct pages), but the
>>>   remaining PTEs in the vmemmap are mapped read-only to a shared
>>>   page of struct pages (that is, there is an OA change and a
>>>   permissions change).
>>=20
>> Just to clarify, does OA mean Output Address? Please spell it out for
>> readers who are less familiar with this context.
>=20
> That's right, sorry about that. I'll spell it out more clearly in
> future versions of the series.
>=20
> Thanks, Muchun!



