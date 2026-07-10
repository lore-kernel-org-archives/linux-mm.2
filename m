Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3E9FC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 03:41:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E0D56B0088; Thu,  9 Jul 2026 23:41:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 591646B008A; Thu,  9 Jul 2026 23:41:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47FB86B008C; Thu,  9 Jul 2026 23:41:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13A006B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:41:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 93CCA4036D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:41:10 +0000 (UTC)
X-FDA: 84971466300.07.C672B5F
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4865580007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:41:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L5nIoJYe;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783654869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dT+E5E9n47vACYHi/SVeCwzS+f47nvPEFd7PhC0qToA=;
	b=BgT4wFqpQaCPG0im25518QB+DycLePn34AW6ps0S3uVVJNkvbDdo7G0sSUuGrIUSYVGqka
	jvX71VQ76geSl2I8v4U8N+07GybkdbzojuBvUwBXWEKG5Jms05xvkyqu+VrTQyDCNKZFx1
	j03D9NNurm44QFnnCdAkuaIg2pvPNqo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L5nIoJYe;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783654869;
	b=ltikyEKzPdMx70nh1aENJ9b2m305GQjmN74PwC6JotoMg/HfxNoJz1ZNqxDlyCf74bAslU
	vN+579bQzcioziz3t92HQ8Ej8l52qjZG+gGClj/Nt+HlIgZeA0c0W8T9oGfggG/D8zmxpc
	gtdSX/q/rKdeSdIoVv6IOJGqrUnP6fw=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783654866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dT+E5E9n47vACYHi/SVeCwzS+f47nvPEFd7PhC0qToA=;
	b=L5nIoJYeemj6cziwYQ+w0kGI/cJG5cb7TAiIiYmixAHOtBjE71QaTmOoYtquMkdnefmccV
	ZsSDe8sqIhk9NjdVJMCFyGsO+7W+NBqb9ky4nF+CWhgl+SPl8/RvCxuCVhzGwKsOWGHWpq
	+hPtlQ3byDkxV1RAmYaNtRB0FuqvP08=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 00/18] Another attempt at HVO support on arm64
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CADrL8HUCqrzOQGXRDwnitintQHjHCw10n8wo6gChQ2tWvC2JBQ@mail.gmail.com>
Date: Fri, 10 Jul 2026 11:40:10 +0800
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
Message-Id: <F2693104-180B-44CF-9F3D-CBDE26151EA3@linux.dev>
References: <20260708031129.3503195-1-jthoughton@google.com>
 <FC9E78F0-8FF7-44AF-A848-8401B4702488@linux.dev>
 <CADrL8HVkrojXbBuEX-W=UHBmyyFzqxdGBvtAoPP53SyYa10uag@mail.gmail.com>
 <ABB70C2A-316E-4C19-A855-C9920BE105E1@linux.dev>
 <CADrL8HUCqrzOQGXRDwnitintQHjHCw10n8wo6gChQ2tWvC2JBQ@mail.gmail.com>
To: James Houghton <jthoughton@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4865580007
X-Stat-Signature: hkq4hb9be54dna6tyq7i5kackm4xe6nn
X-HE-Tag: 1783654868-692487
X-HE-Meta: U2FsdGVkX1/ebsNYCyNpG2zIb1IwaF05Ao5wjLTxw2LjMVSpsumKnB78E06NW6xZGLo005u395Wn7SAoLkND4J/Bwd3VzorrpaBULOw6Q14NriymYlXAQ/n52jQvtFGxNwdo0LBFLsHQXsZYGayZHmPzb6okfuxOtFr7L/kU1oD8RvJHwXv6AEH/gBfdbf5aSA48n31RBv9ZDfATbm2ik1/2Ix7XmJfLixp/l5dOZwEv77PS63tC9u+HSd67PfF4TraoBC3bwbtQopEJ+9xOtP9NqMNZenqMgFMXtX/D5FAB3zy+36vzNaAnV+i6kUTjIJ7QFOS3Ele43gPcHzTj7h3k1rbHyjJXvBBUTkiI+XRpUjPfp/b+57atTXHWyTaHiBydy4/7HzVKnlhA9X9T2Yrsq3u4Z0GUQDfQP0KhS+3XFpeM/uuU0Mbu6huZX730GOxrkZ7Rp4izBpId4g9ZjDSeWCY/TC/q19HIVhNgbyMzxRQA5XHhkaHjRUx7rkBIQM5dumyGDrEHnjnzaSiK3bXO7WfslpnOhs2o/8l8fiYLidGKyLtNBuCuomgr3mFEiLSlqwblBsg72mcytp61adqJNEVNFjbTcJD13V4vvr0ux7m/UDDkvEo8kx/5amuOLSzhW6VZyucSYwIgOUtSjtTSU8qUhsiljx/8S4VmNJJbpZdddPcKNlxzy2Lm6/vjvSwPa0mddvvmpdZcwiVfKxTVmzWMK6TSonHk70KS5k8oyoueMiu2rjSRqdNFJNa/RfokydbtItfLDPmpEOOPNTHSg0jkpYv4Ho6UXhdd8YrjOtPeijBdRTk+rIp1rhLFfqmSuerRTAzO9SyfftEJxsgdcetT7HvKBn8bGOR0Eos0SWpVvxqGEOFhUlp+pt542dCEzlLvx9UlIYPplRGQIOhhhu5CUhwuKocnpmzUoDYW86+4sxRuM2XeNtEtj2vb9Q+CGz1EYodSgHUTa+A
 KhcVKvL8
 3MDLjwnDnB++nDPoder2U2/vHC0iO9D5QFqStAwkOG6fvpcFLcTQV5boDVSmIBBkbM+Hzmi1oi0j0N8udgZPzMJKyKUgOKq3LputDwqbREBgGKCFb4IKwdL9sSirYW4C7XSGp4pm0PAnvZ/1jHW3TrtdkpyFJOTAlcYJvG/Z1KlWBRQAPZhlYTWVK+l3/0xdfocApkQKUr9HGMw54fUKbEYBgom9DNVCYYQnufJFOJmAiJIW3kZhP/c83qWavvC+p203h
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

When the boot CPU starts, it first checks if the hardware (the current
boot CPU) supports AF (The selection of the Boot CPU is critical here
If the user really wants to enable HVO). If AF is supported and HVO is
enabled via cmdline, we perform a Pre-HVO. Subsequently, any CPUs that
do not support AF will be prevented from coming online.

If the boot CPU does not support AF, enabling HVO is not =
permitted=E2=80=94neither
via cmdline nor sysctl. All CPUs are allowed to be online.

Once the system has started, there is only one way to enable HVO, and
that is through sysctl. 1) If the current system includes any CPUs that =
do
not support AF, enabling HVO is not permitted (unless the user chooses =
to
take these CPUs that don't support AF offline). 2) If all online CPUs in =
the
current system support AF, then HVO can be enabled. In this case, the
system must also block any CPUs that do not support AF from coming =
online
in the future. Of course, if a user specifically wants those CPUs to be
allowed to come online, they can choose to disable HVO first (At the =
same time,
this means that the HVO-optimized HugeTLB must be freed first as well).

My proposal assumes that even though the system supports different types =
of
CPUs, their support for AF (I suppose this is a very basic feature =
nowadays)
is generally the same. I believe that for servers (Only servers stand to
benefit more from HVO), there shouldn't be a mix of those that support =
AF
and those that don't. At the very least, such a situation would be =
extremely
uncommon. I believe this may be acceptable. That said, if we go this =
route,
is there a way to simplify the code implementation even further?. Of =
course,
this is just my personal speculation. Please let me know if I've missed
anything.

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
> (which then needs a slight change to patch 17), but that's about it.
> So this is a slight simplification, which is nice.
>=20
> If you (or the Arm folks) feel strongly, I'm happy to write this =
simplification.
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

No problem. Will do.

Thanks.



