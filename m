Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39E0CC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 17:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A7B26B0092; Fri, 28 Aug 2026 13:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 258546B0095; Fri, 28 Aug 2026 13:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16EA86B0096; Fri, 28 Aug 2026 13:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9E166B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:22:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6FD87A3F61
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:22:22 +0000 (UTC)
X-FDA: 85151346924.27.08B196A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D0E71A0008
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:22:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oxphap6G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787937740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nUL0N17ALZrY06F533fPbxuHnDBjD1m79JOt9Vr0x6c=;
	b=mfqoVgqvnfnmvUaBYID/0QLIXIAqB32SwHG4Qu4jVO02I8sTadknzR2eEKNZiuJF7eb/Tn
	UFeJraVUocpo1m3HL0ASN5peqqSg1iLLNq2Mr5N4/fO9wyNcVrfRWH4Fy9c8jD403kKFHB
	OstWfQybuPq6ru+M5pkTESq0AD8Miww=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oxphap6G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787937740;
	b=CUGcALQ7Lu4ziAxj20apx7Vqd59QlAiTS7CcV7mQX4RhKP7zFp5SRKtcyudaaVq2NsVlLh
	EMlP3mMU0Yv/3goS5dGRm08AheWKgG2xQ1SCBqbNMMH3m+X3vFP8m58dSURHBuVjzSTvdT
	eN+TJ8/bmWfrCKZA9w5DBCFkI7FOtDg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 64DF960052;
	Fri, 28 Aug 2026 17:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDB91F000E9;
	Fri, 28 Aug 2026 17:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787937740;
	bh=nUL0N17ALZrY06F533fPbxuHnDBjD1m79JOt9Vr0x6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Oxphap6GVcBvkXtrccfovehpovo3c4pzzOqwnR6ih1XjEA47+LuhVTnYvyxRTQfxA
	 mucZiRPvebttqt1dDr2kaXaer+sjWlje1XgPOXa46594ueir94JEnyAQ9vGV++d/Fn
	 qdvSLMNrTJw3YMQ0BR7dD5ZR24P6pr0solPJmbS4a8KLfM7A1wRwiEU4PYP7T5FSWh
	 zY4CjaWE6ogCw9HsG0vJLW8Mvs6aMojxeROhYUBKs/yXYn3HvILBMCvyt0RLsLWAVp
	 /xwz3Q82kG+oZ+ZZIWLN4+DvWiP1NbFRMsvzjmIOJhZX0xKEddqQFz8oZeUNSRoCXF
	 2gDe40D6UxEwQ==
Date: Fri, 28 Aug 2026 18:21:47 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
Message-ID: <apHDdRSr59mva3ey@lucifer>
References: <20260828-fix_split-v3-0-374022586a4b@arm.com>
 <20260828-fix_split-v3-2-374022586a4b@arm.com>
 <apFMvo8pCzaGKope@gremlin>
 <apFgVvNMbdhYnu6p@e129823.arm.com>
 <apFhDA4e1sBfDOeh@gremlin>
 <apGcu_haNc93cnzU@e129823.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <apGcu_haNc93cnzU@e129823.arm.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 4n1kbzfhqgbx1o1octp63zewb8ew65yu
X-Rspamd-Queue-Id: D0E71A0008
X-HE-Tag: 1787937740-129329
X-HE-Meta: U2FsdGVkX19jgso4bZVk9vNUM0zaG2weCD7kChgSac3CjmWWikjtT2X/GMqDiBwh3TmHDAhOuwENQg4XXI/bZhMxrDKJZGsGZyJh5SDloVzhtdP1hgUl/aogJ7yzez8o2hGiq5YEVDWMXQ29h51UjWK0DdJTDmwdbw9qcunAoKbE72rbfRH9qZP4X1fhdGFN6wVp0DuZ1n0M5gynXdfV8v7xvHc1Al61nlgSfnbxZd2jHVuza+Eq/cjqelCsbRDTTp6dBUbT3oGtJtm05FB+FzwnJaajO/jUk1FKPnXQ6WnFxznYbGaJ0hkivFjc1yvDiSeZtcWRdIVA4ocQw02k7A9c0uI16EGw8YDYK4L65S/dhlFpXZR7UcpcbRfWtc4//M0LBVhaebX2+eV6996rzYPoGdDkNN9Gq2CURQAmoBKL/PuiINVG9cT3VfPXiJFpt1tattfUvG7fQsdTvyTQKX/2e5OWrqMlrcsIFkYxZjZDmt1tXsJqrVoOExDTkgYEHGJ4WKL+luEWIJDpxWBUJrBrtxtfhC/SYjHBM1AXN19RuafS8h60SbRtf83S8WV09N1aMASayWLHUtfcmnt2BigMEjg2xCEqCyYUUWdWE88PvgwbNn4DurItUdRGMb37VwusHwjafkCpzZTfXNUdDQJsepsXoswR9hkGqoCwWuxGhABPbXjBPTUfUDPJBAei1C7rOrNyWvngA7sIFUdwf/xwsG0iuQIx8mO2pdtwGXhET8juwi3pQMLgEzXWYYf6Ks7M75EL3gBNxgLpZ4W81RyE0VfsFeyJHbEXJsKni9AyusdPFCfCsmr4xqybsGmCSJfcUNQaZxp82nzzhslS0UYQZSf4srFqATHuZHvqOGkHpuzkaOlwPh2zto1uPyE6kJiKANI4SA1uA8ekd/W5wfuMLm7MDj4eK7vCqfAJl0qV90rE8XdyJyIPyRVI6TOoTLszQtTXafwfwi1gqY+
 eDCB+fXV
 jjfYfjJWBHQSRpN00R58RbWc45SftKUO9TR67m9iAHA9t6Ayj2+OYMQUeVvrOT4Cjm2W9IF+v8svaRLcmdkzxrtZH/ZxEj8eqnb/iS1YKKJwPZoIGuKYfPi5Vi53YSGFeznBgtvU8JvSeILWdrYSx97pt2fyJNxL4s6c7whHvLUeIuWWHQOpc+iDVwlKIk0feV6U3ibtelu5rmzUdfbvAJ/T6HQe8Y0vvWYZznH2OtSPIVfa/Or0hVUHhRpxYepkc9PCVhCS991RZA+knjuBM4ivr3JhsEXrAKo7VBSYxEZjpmrMlcO+HIsc2udcHKh1whFffS4cmqE4WTUywKhzqwiCojdJOr4pSTFm2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 03:35:39PM +0100, Yeoreum Yun wrote:
> > On Fri, Aug 28, 2026 at 11:17:58AM +0100, Yeoreum Yun wrote:
> > > > On Fri, Aug 28, 2026 at 09:11:34AM +0100, Yeoreum Yun wrote:
> > > > > Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> > > > > glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> > > > > made by memalign().
> > > > >
> > > > > The underlying VMA may start at a different address from the aligned
> > > > > address returned by memalign(). Furthermore, a subsequent
> > > > > madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> > > > > already set.
> > > > >
> > > > > This causes split_huge_page_test to fail because the check_huge_xxx()
> > > > > helpers incorrectly require the address returned by memalign() to
> > > > > match the VMA start address reported in /proc/self/smaps.
> > > >
> > > > Hmm, is the test correctly putting sentinels either side of the VMA? Any test
> > > > that doesn't risks flaking due to unwanted VMA merges.
> > >
> > > I believe that with this change, we don’t need to worry about unwanted
> > > VMA merges when checking for huge pages, since the test no longer relies
> > > on VMA sentinels but directly checks whether the mapping is huge or not.
> >
> > We always need to worry about that though, anything that asserts stuff on a
> > VMA level must prevent unwanted merges first.
> >
> > I guess I'm asking you in a roundabout way to go check and if there isn't
> > isolation like that (i.e. mapping PROT_NONE VMAs around the VMA you want)
> > then to go do that :)
>
> Oh. Sorry not to catch your intend. not for only this series but for
> the future usage, might it sound reasonable to add some mem alloca
> fucntion for the test which could replace memalign() with above concept.
>
> > I think glibc going off and mapping a bigger VMA is possibly a symptom
> > of this not being done.
>
> TBH, what user would generally care whether VMAs are merged or not?
> Anyway, it would be better to add a helper with some PROT_NONE guards
> to prevent unwanted VMA merges while testing.

It's been known to make tests fail, more so obviously when you assert VMA
ranges, but in general it's good practice just to ensure the test is
isolated :)

>
> >
> > >
> > > Also, this flaky failure was not caused by a VMA merge, but by a change
> > > in glibc’s behavior that sets HUGEPAGE for sufficiently large areas.
> >
> > Yep your change is worthwhile reagrdless! :)
>
> Thanks :)
>
> >
> > >
> > > Might for the *NO_HUGEPAGE* setup, there would be a chance to merge
> > > VMA area, But since it seraches the mapping directly, it's fine.
> >
> > As above, generally we should put this protection in case, even if it's
> > unlikely for a VMA with VMA_NOHUGEPAGE_BIT set!
>
> Agree. let me add one for this and replace memalign() used in
> khugepagd and split_huge_page_test at first.

Great thanks!

> >
> > >
> > > >
> > > > >
> > > > > Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
> > > > > /proc/self/smaps to detect huge pages.
> > > >
> > > > You should probably call out the fact you're doing some refactoring here
> > > > also!
> > >
> > > Okay. I'll spell out with some detail. Thanks!
> >
> > Thnks!
> >
> > >
> > > >
> > > > >
> > > > > Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> > > >
> > > > Should always have a Closes: tag if Reported-by: ideally.
> > >
> > > Yes. but talked with personally nothing to close. So Reported-by tag
> > > only. Would it be better to remove?
> >
> > Yeah or Suggested-by maybe? If he said it to you on-list then a Closes:
> > <lore link> works also!
>
> Okay. I'll drop the Reported-by: and change to Suggseted-by.
>
> Thanks!

Thank you! :)

>
> --
> Sincerely,
> Yeoreum Yun

--
Cheers, Lorenzo

