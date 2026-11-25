Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D4E0606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 09:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xdkIyMXz
Received: by kanga.kvack.org (Postfix)
	id 42A3F6B096D; Wed, 25 Nov 2026 04:48:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4B16B05C7; Wed, 25 Nov 2026 04:48:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275EC6B0970; Wed, 25 Nov 2026 04:48:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F23F36B096D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:48:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D87EB80E26
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:48:43 +0000 (UTC)
X-FDA: 85473166926.10.AF3B5A3
Received: from mta0.migadu.com (out-87.mta0.migadu.com [91.218.175.87])
	by imf20.hostedemail.com (Postfix) with ESMTP id D160E1C0004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:48:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xdkIyMXz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.87 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795600122;
	b=UfFETcB8OJfszE/Qz9Sm5ecd1NzyqxBoNRNX+cfFhUOPhIfwJvna5ZuhJpMkormHvouTSX
	gXEHyAqMJ7lWh2DO1HEvso0CgfLKetWUvO7wAv7O1L8F2zy2DX5lJEOK7cxlREauqTOIwj
	ujr7GuQVZlhjswPsFlWNcdCmJvMZgwY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795600122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2VfJ6bjv4e27WAuru/P4AIutJffL5p589T07LBcmHCU=;
	b=TxfDb7Z3w03fnxfDDceNlTG00z5TtzPEkCXbw5/cx8HocyOkpOn/yIidP7jDeRoaK9Jtiq
	aZ2FPLB6T0dGhzqWRV/4wrS4Cv7UtAi4OxtH4055bGwbaJkR/GbxiyOkCXyvnBPdhoUyRs
	rAURyFU/VPcsJtf/+Q/3U0tj5AHmsjE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xdkIyMXz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.87 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2VfJ6bjv4e27WAuru/P4AIutJffL5p589T07LBcmHCU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795600120; v=1; x=1796204920;
 b=xdkIyMXzAD+2GKgttya0QgKXIDHXTAqb/1cV4Mu1pch3DIrX5nVIHqOF8EGiGFYzg5Rr62DQ
 5rSH9gAO1pRAekElGxgtSAEov2yJlHGLo3HwVTfTqlblenxGDi+6GqJuBWF/pcmCUWYK2beK0c3
 92sZc9UsgJ3mVtavJ69vV2pc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f807f146e8e08fa1;
	Wed, 25 Nov 2026 09:48:40 +0000
X-Mizu-Trace-ID: f807f146e8e08fa1
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 04/19] hugetlb_vmemmap: Use try_update_vmemmap_pte to
 update in-use PTEs
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CADrL8HXQShKvEu_6KVq0wZXbPjWMcR73yZ38iuePxPRZMDjXmg@mail.gmail.com>
Date: Wed, 25 Nov 2026 17:48:21 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Linu Cherian <linu.cherian@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Nanyong Sun <sunnanyong@huawei.com>,
 Yu Zhao <yuzhao@google.com>,
 Frank van der Linden <fvdl@google.com>,
 David Rientjes <rientjes@google.com>,
 linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5747F7E9-14A1-4CBA-BA2B-BDB8A3CC26E9@linux.dev>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-5-jthoughton@google.com>
 <4508589C-2E30-4DAB-9465-73121835D0D8@linux.dev>
 <CADrL8HUstWR2pajfYYzRqL7HziVfzZAXJas6MqJkK6pVxSzXEg@mail.gmail.com>
 <4A195604-B83B-4608-B32E-5F6CC85AE96F@linux.dev>
 <CADrL8HXQShKvEu_6KVq0wZXbPjWMcR73yZ38iuePxPRZMDjXmg@mail.gmail.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: ywsuq6byoq7a1dpsa7uh4wgmggg93x8u
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D160E1C0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1795600121-50061
X-HE-Meta: U2FsdGVkX198+8BVt6k8KEP1ARjC7I23I/tKzPkvkzCyO1q0efJ/vFZ/BR79GlQGM3/P85jEljVgR6ydqw1GnVYzdKAzmIot1HbSvjwhjzS9M7EIgi8dHfC+TAhKgWLmMs607Pyvsk9zTpQWZAD6SsI6/uPBmcg+ExSWtbH5LBtXtQ+O1jgVqlZzZOcletFUnEl6WOiSMPjBftIF1SThmC/Ac1Iv9rvXzwOaunXyAwx6GEwqP4RDr3ASGDTBgTGRarKp7tkVa7MHNTma4d6iVo7AlfIbAfdspbPpEMeJKD7WfPbF5zKX1sehDD5EX4LVtqOBHmbQ/c3T14zhWFR64zcqsTccWAPSnZb3zddxMYszqNDyoo0R7bLA9BFpyWP4g7edFtyHP8byqYr+04HFVCQnCcaPXewQcu3EmfPOc8W5ePNt32mao++be9SdO9FA2XZyDWQHo16PMzEyKSE97RSE6OtoQBsLOcAb5VYRc2A//5tjbcwTf/+SBbet1E9XPnQgGxYTdt1Kbjf2eIyf7VPsRYG9SOfhZBS4xDZdzj/W95cSeSA9ebV02mUROfwgjToquiwfPcogxaV23AdHUeqp6VKjEbVSWEgT0rp74cj21uGgq149XFFW5ZvdNhvZl0sa90OLMXUEUQtZQJkZveVeIqtsHFfQGgUZQW1o27JmFCqPnxu1HUzSiTRfqXAm4+N4eZjUR6O1CDQQPTDVqWXDoHbv9tzx90CnZdWf4OzO2uJGaUzndtPrkfjYLAFIRwWKLePbTeyopx1pTgyzzrX14fcVEzzJ8RZLSi1rESyrUP3U8+lNIF9DIM52MmfoqzMmpyJ6JBqxAOs+KkeGab58RNLp50kCzW7gu+ZMhlIt4wtJEX7K59m7crKl0w/NKS1t1Bkn+VSHAlQLECrD9JKNI9WhF84OhBpC/C9hhSgOhbArUrGf40LT6Xi0974VWENXKXW7avrLOXAKnMY
 2Q5GTCRd
 mv6CNIWevExjwWht/ZntEoygw1nLSBbD9u4lLoxbvNEgt0dMbrVRu9z8GJEmbHB43rO+3fD5ZPc2eY6k/RPq5qeXf+3rCX6PDjihwFp55AMle2zcM68eAXjG5uax198at5HQBuzx328FFY7kQ1aWIb2qA/XEkNAjQ+9GqBeW2/egSe2LH9/5RmO/HD85orcyQ7MoK26PnBrpootpcAJeNfD3ET0I87z7GOEGX3w+6ibaY0KH44tvRddYDMMIAutI4YQh+07DR8cXcmisPcgDNe5P4/aGrCjJKDkuEPgt8YNG9zrYEGAbQQKTZPHfgyjeiOeMo5RUKtEFyA8sp7KLSGBb0g/tZDElW6ZB9KlSzYbbiYe4QjlNKMELdeagKSODjMJ1f6StLh+FiR/QGcjjXy/1Uew3gJnlbRGhKpaUEyVpST5CufXmBgJlfJlx1ixaG/MkwEwrXKahTQLlF6V1avXvnu39lf/3cn43klmE93KNaM6R3ForYdtDi6Qjbm92lJaGoFlEJ5fnIUwHsFyl383+VqjOoXrxd0RWWhZNIo4oQZ0w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 25, 2026, at 00:29, James Houghton <jthoughton@google.com> =
wrote:
>=20
> On Mon, Nov 23, 2026 at 9:29=E2=80=AFPM Muchun Song =
<muchun.song@linux.dev> wrote:
>>=20
>>>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>>>> index bc1353f03b08..ab33df268955 100644
>>>>> --- a/include/linux/pgtable.h
>>>>> +++ b/include/linux/pgtable.h
>>>>> @@ -458,6 +458,28 @@ static inline void set_ptes(struct mm_struct =
*mm, unsigned long addr,
>>>>> #endif
>>>>> #define set_pte_at(mm, addr, ptep, pte) set_ptes(mm, addr, ptep, =
pte, 1)
>>>>>=20
>>>>> +#ifdef ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
>>>>=20
>>>> Why not ARCH_WANTS_VMEMMAP_UPDATE_PTE? Then x86, loogarch and =
RISC-V do not need define
>>>> this macro in their ptable.h.
>>>=20
>>> You're basically asking to make this opt-out instead of opt-in, =
right?
>>=20
>> Yes, exactly.
>>=20
>>>=20
>>> I like making the different architectures explicitly opt in to the
>>> generic implementation; it forces any new architecture to decide if
>>> the generic implementation is correct for them. But I don't feel
>>> strongly.
>>=20
>> We already have an opt-in config: ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP.
>> It already forces new architectures to pay attention to it.
>=20
> Right, but that opt-in is different. Requiring architectures to
> manually specify ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE forces them
> to think about whether or not they need their own population routine.
> But yeah, I guess we can just assume that any new architecture
> implementing HVO should have already checked that. Okay.

Don't worry. I'm planning to rewrite the HVO documentation with a =
dedicated
chapter that tells architecture guys which hardware features must be =
supported
and what adaptations are needed when enabling this feature, so there =
won't be
any issues.

Thanks,
Muchun

>=20
>>> I'll switch it to opt-out in v4 unless you or someone else tells me =
otherwise.
>=20
> So I'll stick with this; I'll switch it to opt-out.
>=20
> Thanks, Muchun!


