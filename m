Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B094CDB466
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 23:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08C8A6B0005; Sat, 20 Jun 2026 19:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03E9C6B008A; Sat, 20 Jun 2026 19:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6FA96B008C; Sat, 20 Jun 2026 19:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA0EE6B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 19:34:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A84BC163C
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 23:34:53 +0000 (UTC)
X-FDA: 84901898466.19.2B04B8D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8EE74C0004
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 23:34:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UNXo0yQm;
	spf=pass (imf22.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781998491;
	b=vw0VCeHv+BzAPxHJDDYfJzYzyKZO3SlgNJYJdozHvRBlfCZ4DkCN/A3AGt66bGJmPi/ii8
	cMFNve/MblnahtNssXjkKDojVfvqOAnSF0ULP/lrVghiwAAAor0ZO/L7aJtorEojoy2uTn
	UJgYSxJBPt7Ivgp/U++aGqmZexWx6JQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UNXo0yQm;
	spf=pass (imf22.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781998491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OPqySwjlM5CRQv3Iryy2Knga3elRhDn2ZrarUZX3Msk=;
	b=0Fn3dR9+h1h/pUX1IcHpYcjHqUibEdeAJnx9cJjR5KswUr8ZzeYDKPflWG0K0oebKK2XaY
	kMpy6oF6fVa69LhutwCiLbPLFwTYPck4QvZSX1R5K4T1N5ZcxLEfJHGrx+8cp7qcG3sTIG
	8v1OOFuLNrAuig7/JuLMbEelAxhz3J8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1931601E1;
	Sat, 20 Jun 2026 23:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17C21F000E9;
	Sat, 20 Jun 2026 23:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781998490;
	bh=OPqySwjlM5CRQv3Iryy2Knga3elRhDn2ZrarUZX3Msk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=UNXo0yQmeM7s22VKPCE57kxJzyEObUQrZ+qf1xWfXdFcwsuRIzFwSH7QamifsJN48
	 Lf04uOmgOY5qWAQnhyafplkgFfm4Dv04y2rxvDhSFppBlGjtg3MZPmgvyQOXCmnDqp
	 IY5VZnLZdNoHF47NW1fdP+vkIOAvENZbHnh+WyNmGw4BpEtwunzltzl7tT/jqikOjb
	 yFW+tszuoWLHpDj5NPRLnMlu/PHXx+nxDbSK5QwnLFIFaCTkhB/203hHXtwn8zBHn/
	 VtwEWS183ACG/4CRavqS9RNRLAPzv+tTAsmie+6VVwqSsn+1aduvGv4GKDt8vIevsG
	 IKWPxYQ9CtnAg==
From: Thomas Gleixner <tglx@kernel.org>
To: Zach O'Keefe <zokeefe@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 David Stevens <stevensd@google.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>,
 Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Andy Lutomirski
 <luto@kernel.org>, Xin Li <xin@zytor.com>, Peter Zijlstra
 <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, Kees
 Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
In-Reply-To: <CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
 <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13>
 <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
 <87qzm2b39k.ffs@fw13>
 <CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
Date: Sun, 21 Jun 2026 01:34:47 +0200
Message-ID: <87mrwon5uw.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8EE74C0004
X-Stat-Signature: gtyx998714qz4rfohrnx79iermhiki7y
X-HE-Tag: 1781998491-593926
X-HE-Meta: U2FsdGVkX1+xQBmO77xNiYazyCUc9ofGaaPIFHlrwV2pz9kgXEwQmUHr6S4jMHQsPj2UzTSBH+VQUqZXIvjlr38JJBFytwcTzXFO2fi0Ao1NKPtT+9bKDFhiw5NYE4sAFsGRrlx2Sj03efNgraHwMlUUTVBX7PSUDgF52thq9/SxsjEFpcmBoDnWhPz82mwYpS9iDBo18gEJA7QzfKyc228kJxWRTcBIuR8hPJ410JYDExYDRIe9fJBLmL6Fc/H7Cb4lJmohFvY1NCebRgzZ3W0wchNqXioryjGQ4NcRzDCnGtRzV/L8bOBZ6mXlXUiIvT/+cwp8mwzvGZ3JESr7Pa+XEkSt51YEzdIH1dKD1CyPiRu3qIeQFfcnfkTl6+IudOx1ftR+MWF5hr6Jka5Bc4tK2AiqI4SwuNLR4lcI+0GyQa9+zl/HqH7FFFypVounpQyb1h2y2t5kakqL53qxc9Fca1hEpqC1jBlEPuf7j6mWIfDfI+Da9htOEeQ2Ju3wcBQYBuyMKGCc4r07n39j0USxxMVOOEBIW/e+toW6G3u1r+DJD2Etu7/zsg8LXzJwsxhy50pNteOeFFAyaxMPwbYjwER6FJEbGicSTboMGfvcRV8X3tl6A4elE8dMhyph2FxyzELP2vd2oa+UnOvH6S2M81eL3DhrQAv29wzMglUKCpUhdwxfB1c/sTgaRjYDLBzU439Ge8v39jisDQScEGGylAmwubm8vqllXuhEc8em8yNL+Wui39bHW4QTWbqCDXQObvuimMbJauCjZ4acMC1vaMzUiBLpJ0WJYzC3SWoEvPtLmPEes2PFFRzDmi+x//KQ00iLBn3imxNgqg5clLSZYF2WVF3N5LOzTWFMlz/jddvSmSSRVJWc5WSQCGr/WRorg6z/CkMVknxnRsp3GjcrsiWl022+XOuxlxN7l6S5tVs87wgergiBxq0yjNElDxsLz8/BeFg6uq47xOX
 hCbV4Spc
 XKWdGmw/PR2Eguxa8pT0RWlPktImtzsH4jCZomJAZxEC7/qSzYjlLjUBEW3Wk8+4PRmsLdzCDZvbeKWztAofh/NG17QiajPO5++ghDMV+xB0Kl0hEuPuHa9t2nEbIhGW++urVpoIREv9tM5ht8R6e15E7i22dqyMRm/UxVIuU6vnuwfGh59XvhQeO12ROcfJskZqbz9dQuvs01Q6RxwOMDUjkLVdOxPVl/Gxj6uiUSs8vAVx0Q6DLZjKlROJn3YRAYSv/0UxjBL5DJLL3SHAYBgGyVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 20 2026 at 12:33, Zach O'Keefe wrote:
> On Fri, Jun 19, 2026 at 2:59=E2=80=AFPM Thomas Gleixner <tglx@kernel.org>=
 wrote:
>> The #PF path is considered perfomance critical. But how much the
>> downgrade matters needs actual numbers to analyze under various workload
>> scenarios.
>
> Ya, that's my concern as well, as I don't have a good intuition for
> how perf critical kernel #PF is for real workloads. If this is your
> primary concern, I'll take that as a _good_ thing ; i.e. there's
> nothing architecturally stopping us from doing this downgrade safely.
> We'll still need the analysis, but that can be a later stage -- we're
> more than happy to get this data for all.

No. That's not a later stage optional requirement.

You have a PoC which works for you otherwise you wouldn't have posted
it. So you can trivially microbenchmark the costs of the
up/downgrade. And that's critical information for us but also for
you. If the costs are significant then you really have to think about
the tradeoffs.

Care to read Documentation/process/* carefully? It applies to you as it
applies to anyone else.

>> I've not seen numbers to that effect anywhere. The only numbers provided
>> are marketing material about the memory savings on a freshly booted idle
>> machine. There are _zero_ numbers about the actual real world savings,
>> but claims about the PETABYTE savings possible.
>>
>> Seriously?
>
> This is actually the most understood aspect. With O(100B) active tasks
> fleetwide at any point, it only takes an average savings of O(10KiB)
> per task to get to 1PiB. At least for our fleet, we know the % of
> tasks that use only 4KiB, 8KiB, or require the full 16KiB, and the
> math confirms that we expect O(PiB) aggregate savings. The % of stacks
> requiring the full 16KiB is minuscule, but it still occurs at a rate
> higher than what we can tolerate for SO panics. Given the vast
> majority of stacks never exceed the first 4KiB, this enables the
> significant opportunity.

I know that the potential savings are well understood and my
understanding of math is sufficient to calculate how much tasks and
average saving it takes to save 1PiB on a fleet.

That's a no-brainer, but this is an aggregate saving, which sounds WOW
but does not tell much about anything else.

 1) What's the actual percentage of savings in relation to the overall
    memory?

 2) Does the saving allow you to get more stuff done on a machine, pack
    more threads on it?

 3) Can you actually downsize the memory on the machines?

 4) What is the performance tradeoff for that?

IOW, you fail to tell what the actual benefit of such an intrusive
change is. Just boasting an aggregate Petabyte number does not tell
anything at all.

Let me give you a trivial example with a scenario which I have access
to:

    256  CPUs
    256  GiB Memory
    64k  Threads

Let's assume the full saving of 12k per thread. That sums up to

      64k * 12k =3D 768MB of memory

which is 0.29% of the total 256 GiB of memory. Not so impressive as the
petabyte aggregate number, right?

The workload consumes about 80% of the overall memory and is already
constraint on close to 100% CPU utilization.

Now let's assume that the runtime overhead of this amounts to 1% then
this is a net loss.

Let me turn that around and use a made up example assuming the 1Mio
threads per compute unit taken from some reply in this thread.

Now the full saving of 12k per thread amounts to:

    1M * 12k =3D 12G

which is 4.7% of the overall available memory. Agreed that's a
substantial number.

That 12G saving does not do anything in terms of hardware downsizing.

The only way that has a benefit is when the system is constraint by
overall memory consumption, but has quite some compute capacity left.

IOW, if 1M threads hit the memory limit that means that the savings in
kernel stack consumed memory allows you to add about 4% (~40k) more
threads. If that ups the CPU utilization accordingly then yes, I can see
the benefit. But TBH, if that's the case then you are trying to fix a
user space implementation problem in the kernel.

That said you really have to describe the scenarios where there is a
benefit and I do not buy this "fleet level" argument at all because
there is no single fleet which has a uniform workload distribution.

Aside of that. If your argument holds that there are only a few
scenarios which require a deep stack, then we are better off to identify
them and fix them up rather than trying to hack around the occacional
insanity of deep stack usage by adding complexity for complexity sake.

As you say that you have numbers of your fleet which confirm that the
vast majority of the stack depth is below 4k, you can surely figure out
the information which call chains are actually exceeding the limit.

I prefer to fix such shitty code and downgrade the stacksize in general
instead of papering over the underlying issues which probably have been
ignored for years if not decades.

Have you ever thought about that instead of adding complexity with a
dubious value?

Thanks,

        tglx



