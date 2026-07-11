Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2667CC44501
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 02:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C14186B0005; Fri, 10 Jul 2026 22:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4E66B0088; Fri, 10 Jul 2026 22:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB576B008A; Fri, 10 Jul 2026 22:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 757566B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 22:22:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2049120406
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 02:22:55 +0000 (UTC)
X-FDA: 84974897910.09.E2EBAC7
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 69BDA100002
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 02:22:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DZZvjHhA;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783736574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pht+H/kaQ/+X/l6EE9OCpbBV+oSMnlhN9E5QSgzooDk=;
	b=Yrst1NdeCewSr0WY8sv2tOr/bBNXdHAd8Cb1/aqn9JL3eseqiGgIgyjlaTsJ2pEdisATvn
	CPSVCECNhkaOn/LvgnKCCIHvk6YT9vunG2E4dxYaXMOOaLYrI0MWdnntPA+LexhzIG+44C
	KoPywohvAS7wfzvI0WQlulrkV84P4pA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DZZvjHhA;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783736574;
	b=Ws3e1Q2xMMigITXHnEXruZjUHB9062USpXhQ9ENa+wYTk86xAFT9x9ApFOhwHbTS2qEieO
	lx9avypwZyU2HrCjTBoGzHCeJBPkMJHWOSNriSIPcxHy8VsfQ1RhbHafzN1HS3Jqicj9ZF
	FmgYVieOi1btyJOWjvKIP4RqAtwAyL4=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783736570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pht+H/kaQ/+X/l6EE9OCpbBV+oSMnlhN9E5QSgzooDk=;
	b=DZZvjHhAgI9ZYO4a6QbqqXey86PHlAJIPVOYc9sV3WjVSnHsr5E2vkAY4NYPPhxS/Wjzzf
	zdTrPn3Dj8PvY5SFi0uiE3xJ2rw25wDaa8+y4kYFopFw8cWzHXGJf06IsEYEfGCOoM/rdp
	vHGqX5ANgOvp1NPVK4onmnEwML2Ilqw=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 00/18] Another attempt at HVO support on arm64
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CADrL8HUCqrzOQGXRDwnitintQHjHCw10n8wo6gChQ2tWvC2JBQ@mail.gmail.com>
Date: Sat, 11 Jul 2026 10:22:02 +0800
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
Message-Id: <674EC6D6-B1F7-447D-B462-861ECA5A99B7@linux.dev>
References: <20260708031129.3503195-1-jthoughton@google.com>
 <FC9E78F0-8FF7-44AF-A848-8401B4702488@linux.dev>
 <CADrL8HVkrojXbBuEX-W=UHBmyyFzqxdGBvtAoPP53SyYa10uag@mail.gmail.com>
 <ABB70C2A-316E-4C19-A855-C9920BE105E1@linux.dev>
 <CADrL8HUCqrzOQGXRDwnitintQHjHCw10n8wo6gChQ2tWvC2JBQ@mail.gmail.com>
To: James Houghton <jthoughton@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 69BDA100002
X-Stat-Signature: zxwd11d751frfy6cab7szonuxfe3giae
X-HE-Tag: 1783736573-613057
X-HE-Meta: U2FsdGVkX19KioJOdnCde6qXtLCZ4Ikowkzwgym79O/COQOFnOCZY+pOMhi4Lpc2dq3cxV89g5UKKzCTbwCUGX0HEo3DPBCVXjsFi5yihhy8ZZnen/QD5xs8xQ46kWg0cc9HQsy02SDSQHBApMWl8ahc9YHRt1ETndD8wJFdM/+4UDxrSiJnhUj8GO/quLsARFh6mTXgIQAnKMzAWy/MO5EkmRngLtGul1uh3gCrDJeWzDhRC59t5rC933+/RKYd3Z4wR1gDn19mB250iS+4jHZwCuT9v9u6ca0u56jdv7V4dNnIMkUdIsV6EOOnPz06tBrB+1frH7tc9Q0sP9KDocAkl+8nvExcXb78uECw4+rvAO8zdQ/e6+ZbwulV64DHcaL+uYhKgaHTCkrGDlE3h/X85+2eeADL/Gl9/CshQpZzDK0tHEH1MoovpwriC8iDeC6d+qpa2IHjexSDe8iC03ym+/raZhmPwQidg+blaJBVm6P8970pJiN4XfjeD9dWb+S7x12ZADcUzDOLp67rlGHmbVKknrssZhYjZ6j6zqzwGRzp7xUXFMrCuuOF3XQ7tZRp8wMrIV4PlLOmaanbcVc3XAglCK1UvAnBPzZtHLabU8Y+t4/D2VHCDaVC5EZqGRHEeMsNt5etBW1X+jKW2FwG0VVvWsLnerP/MGWa9GhxqE2qiE+Bs2kPZqW06dAJeW4b5MeEU4i7uvfLLf9yL/MlCTNe15bgwcGlgfOPPc/7Itj9CtT1NF4Zf0yLq6NbpVQU7O1+vp3aMEDU05u2+/zjo0jXQoeGtNNy50Ele57Dtw+GAUklI+Aabl0+foDko3goEqHEMm4tK57VySa/JOSFsvqu8GcWJv2llY6kTHJJKh1+a3jNDSAqlf9BZATahZLR8lpWQQ2BS1aRvtwWYQiIQYtl9XiX8MjJZweQHWY649UnnAvZxieoQR6XghFy0tTOLCfD7SMBEYnXYxS
 WCK6qV9H
 z5qE7UEIWPgbGE3R1TWyol+TGMHCz0XbVgOMmJ2Bao5LJQt6XsjLUDC+xgW7M+AnalzO1cFbSxPyp0WOhrFOG36RWEovbxXgOOkVtJ9ReAZXXcvx77QXTPn3LSkhOcwKAi3rT+ygzmB942WeSaR2KJ7PaWCEsDvyoH/eSxQ+itX4WkHouW+m0j213IgX7Q73ai2j/xcnFuck7TOH2mGsH6ygQNtp5CZCevbgNjoLT/D5IzYwqbIfe9ka9iOAzY5ID61QK0YhkbBVrXcs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 10, 2026, at 03:04, James Houghton <jthoughton@google.com> =
wrote:
>=20
> On Thu, Jul 9, 2026 at 2:55=E2=80=AFAM Muchun Song =
<muchun.song@linux.dev> wrote:
>>> On Jul 9, 2026, at 00:49, James Houghton <jthoughton@google.com> =
wrote:
>>>=20
>>> On Wed, Jul 8, 2026 at 1:41=E2=80=AFAM Muchun Song =
<muchun.song@linux.dev> wrote:
>>>> Do you mean that the support for AF might vary across different =
CPUs?
>>>> I'm not that familiar with arm64, so it seems a bit strange to me =
that
>>>> such basic hardware features can differ so much from one CPU to =
another.
>>>=20
>>> Yes, hardware updates of the Access Flag is a per-CPU feature. It is
>>> available for a CPU to use if TCR_EL1.HA is set. TCR_EL1 is a system
>>> register; each CPU has its own. (Linux will always enable HW AF for =
a
>>> CPU when it is onlined[1] if support is advertised, so we simply =
need
>>> to check if support is advertised to know that it is in fact =
enabled.)
>>>=20
>>> These days it is not uncommon for a system to have two (or more?)
>>> different core implementations, like with "fast" cores and =
"efficient"
>>> cores.
>>>=20
>>> [1] See the CONFIG_ARM64_HW_AFDBM bits in arch/arm64/mm/proc.S
>>=20
>> Thanks for your detailed explanation. When enabling HVO via the =
cmdline,
>> can we simply prevent CPUs that do not support AF from coming online?
>> Would implementing it this way be much simpler? In practice, =
developers
>> definitely know whether the current system is suitable for enabling =
HVO.
>> If some CPUs do not support AF, they would just need to evaluate the
>> trade-off between memory savings and having fewer online CPUs than =
expected.
>>=20
>> For scenarios where HVO is enabled via sysctl, we simply need to =
check
>> if all CPUs support AF. If any do not, the system should return an =
error.
>>=20
>> Then, we can proceed with the Pre-HVO.
>=20
> I don't think it makes sense to try to implement pre-HVO.
>=20
> We cannot do HVO if any boot CPUs do not support HW AF, as HW AF will
> be required to free the HugeTLB pages later, which we should continue
> to support. Pre-HVO (today anyway) happens before all boot CPUs are
> onlined. IMO it is not okay to prevent boot CPUs from onlining.
>=20
> Let's say for a moment that HVO cannot be toggled at run-time, then
> the best we can do is:
> - If a user does not specify hugetlb_free_vmemmap=3D1, we can always
> allow onlining of late CPUs
> - If a user specifies hugetlb_free_vmemmap=3D1 but not all boot CPUs
> support HW AF, we can always allow onlining of late CPUs.
> - If a user specifies hugetlb_free_vmemmap=3D1 and all boot CPUs =
support
> HW AF, we must not allow onlining incompatible late CPUs.
>=20
> HVO compatibility has to be modeled as an Arm system feature. To
> support conditional onlining of late CPUs based on whether or not "HVO
> is being used", we still need the extra cpufeature.c logic.
>=20
> So if HVO cannot be toggled at run-time, we can simplify the
> definition of "is HVO being used?" (for the purposes of determining if
> late CPUs can be onlined). We can simplify it from what it is now
> ("are there any optimized pages?") to
> "vmemmap_optimize_enabled=3D=3Dtrue?". That allows us to drop patch 15

I believe this conversion logic is sound. If a user proactively enables
HVO via the command line, it clearly indicates they intend to use it.
Otherwise, there would be no reason for them to enable it and then leave
it idle.

> (which then needs a slight change to patch 17), but that's about it.
> So this is a slight simplification, which is nice.
>=20
> If you (or the Arm folks) feel strongly, I'm happy to write this =
simplification.

I really like the simplification here. To keep this series as simple as
possible for the first step, we also could focus strictly on bringing =
HVO
support to ARM64 by making it depend entirely on BBML2_NOABORT. This =
keeps
the initial scope highly contained, which should make it much easier to =
review.

Muchun

>=20
>>> I'm hoping you can look at patches 1-3 anyway. I think they're the
>>> right thing to do, even without the arm64 changes.
>>=20
>> Yes, I've looked it over. I think that making modifications across
>> several areas will be much simpler on top of my refactored codebase.
>> For example:
>>=20
>> - In patch 2: There is no longer a need to move vmemmap_get_tail().
>> - In patch 3: Handling partially-HVOed pages becomes straightforward
>>               because vmemmap_restore_pte() no longer relies on
>>               ->vmemmap_tail to detect whether a restoration is =
needed.
>> - In patch 4: I have updated the ->remap_pte callback to return an =
int
>>               as well, making it easy to adapt your changes.
>>=20
>> Overall, the implementation is significantly cleaner, so I won't list
>> every detail here.
>=20
> Thanks! Good to know I can basically drop those patches. :)
>=20
> Please CC me on these HVO simplifications when you send them out, =
thanks!


