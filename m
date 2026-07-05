Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57DB6C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 10:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0E156B009F; Sun,  5 Jul 2026 06:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BE896B00A0; Sun,  5 Jul 2026 06:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 886CA6B00A1; Sun,  5 Jul 2026 06:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5856B009F
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 06:46:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B360D168FB1
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 10:46:35 +0000 (UTC)
X-FDA: 84954394350.12.B19D9EB
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5D0C820004
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 10:46:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DoYO8MDG;
	spf=pass (imf03.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783248394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GnkaflooJuq+75MzIOC8R8WADgK2S3FqDMqMUUtqTh8=;
	b=2G/Y1Fnq4QUxS9HegDrx7VbS2jTZpMMxjkNWUOEFn2YVUd5fQlLmQwewLCT46TJbmawbHd
	LbwUV2zzGL8Ma2OQu5flXJ+cTHR5OuUxqj5SBdE7PrQ1EX6FKKGO+ui0OLFwtYUTWUwbkT
	JiCo7Y2pkX1btrUNTYJAHEDMQFauEko=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783248394;
	b=eDSDpfD7XgbVhnzpaR81kcxEjV59RUuxpjl71rxyUrdIQq/tsn10qVK1qnOlGSFj+QF9HQ
	QVDux4tUl9Wfng8KHaFyoKYPDnvExtIv4oGiV1HgIj/ZTvaFY7iZJDJnMtDmZHZQka6Xnd
	+9w6myqkwOqFbY7xvCWdHoFGhPcWJyM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DoYO8MDG;
	spf=pass (imf03.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783248391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GnkaflooJuq+75MzIOC8R8WADgK2S3FqDMqMUUtqTh8=;
	b=DoYO8MDGjmdJHrsSObOQOgFFtmpP+RP5ONXbpXOQaFFRKC5cL8tE4NAkRtOB/0gHYpLrRL
	lPB5iJjb6fknrxsY6CLoJORzPjmp1OAmt2L3M8pklrieXvjrpjZkBDMaK5wwPjmLE8Oofl
	p6aBgMfnvx1WFps0ALmhOQixwsbhk4o=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 05 Jul 2026 10:46:19 +0000
Message-Id: <DJQKSKCN9KIB.25WIOU9KF9CNV@linux.dev>
Cc: "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/secretmem: disable under HIGHMEM
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Brendan Jackman"
 <jackmanb@google.com>
References: <20260703-secretmem-highmem-v1-1-30d5ff944664@google.com>
 <20260704192603.40aa80cf9242b77aa75e8d8d@linux-foundation.org>
In-Reply-To: <20260704192603.40aa80cf9242b77aa75e8d8d@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5D0C820004
X-Stat-Signature: aeph15igs5rprpd1jjr4workdeb117xn
X-HE-Tag: 1783248393-641485
X-HE-Meta: U2FsdGVkX19ELBRkBYQKI+tXx7lwORYUyHQD4qKs/65lJwh1XdkawthAr3jas4jC2b8OazKT1n62ZpzekaQsEkqrcEK1F+pPf39uXu3EYbMO56zo0DuL2f80sg5DabVSasnd5Nd+XkgS/wTD+aJWKqcXLLUqgapwGSaaeEkf8okcXbd4FB93fuJQI84kpc+4Jvt5bSFuFPOfVrv3cXBu+7tuofNM1ennaYqv//x0PkU0ljw7hAKVXCDFF1zZc8CzjmEqJ1zb4aoRM5LcFvcJvGxDLbwlyPD/kUZI+MTxoLp+cFVxQzgRDL4jTR/MJx3xo7ZgiosiCaaxM6eJLVvorjaKD8mYFci1mxkqfkpXVp9AeCbq/Sr7D0DzVky/sVimnVemIy7ve/5AY6lOt64DPvLUpFMpUzu5F+z8sDqkKQIlrouyBwN12tAexbFpMzti4Mf1Ohh8V5q8m1KTLrTqXtQ2EfHsNSYhn68JBfCRGswPrHZEEqsccwbmqFr7eg4J+FH1/NblVDggIaZfkkPfjLZP9/poyxmINXw9jLzoAPTvf6Myi6XYHmboBQVHqeAB57Emark5PHWnpfV3HI8oMvTmc3xmpgJf+o516PL6T09hCdFj2818L2rYXdk5/shLEp8emV4lkl7zNxCR7TlqwJLW7QV67NX/iGjj8QLI8E+1MrX59sOqiawPkpYD0Zrzwy5KowQUziVRDorcVE5GsNdYrRPpqDPSGVvuYNT3Rv2jlKBmHBHj8GdVlORbpVX2P/frjL9GHjPsmCHPeR89g4Hp07aArc4UMyoujPhJxSUhzRlcHQUd2wjNsuLQF5Cc4m6tAuuRe8QzF7v00ZohFUQQ1kTYFlTngfGh6w/pmU/W7TYeBfR2+6ZC7ptSudIWvYIHNC9/jLjkMVbV3rHQw2FjbPXTl9NaPkmt4QDszsn79E5UrcUAEucKzpsitRZ2a4lO+Dejx8qydMbTZJ9
 qpdeYh0w
 8g7YelCcBe3+LQj1c03PyFiO9bxpRxayOaQFaKYWMFXJn3A98mNJLVmcDjJKbbNTvL1yjoB6ASgsWeVZG7bQa6gevKeAQBpovYxl0Vaqzf/aclMOo2F7uo8qHebvZRZowbSuKr/K59tA+auGyqxBLgjVRBjY9DBPVKFwDq+OLAZhYHu6mS8AMr1pKrpAWa3OSq9Yg5jbkn4OaAwL67fRIcNnwXOVHXkCDuAvWbnspWIpfPYyRYoG//pXZm0M067uRkHNi4Tr290IQ/TJKHFABmlYDo6WQmpombnNWCv825IuTCvM7fwX7zAIdmGnUa6RbCDZ/ITogfXMbiX7sP4Xj1pMUOzdwfUf+/PFrd7RSWnl+X6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Jul 5, 2026 at 2:26 AM UTC, Andrew Morton wrote:
> On Fri, 03 Jul 2026 14:48:26 +0000 Brendan Jackman <jackmanb@google.com> =
wrote:
>
>> secretmem_fault() allocates a folio with GFP_HIGHUSER and then calls
>> set_direct_map_valid_noflush()
>
> set_direct_map_invalid_noflush()?

Yup thanks.

>> without checking folio_test_highmem().
>> This causes a warning and process crash (vibe-coded reproducer in Link
>> below):
>>=20
>> Su[   30.071284] ------------[ cut here ]------------
>> ccessfully allocated and mapped 2097152000 bytes at 0x3a449000
>> Populating memor[   30.074614] CPA: called for zero pte. vaddr =3D 0 cpa=
->vaddr =3D 0
>> y...
>> [   30.078636] WARNING: arch/x86/mm/pat/set_memory.c:1840 at __cpa_proce=
ss_fault+0x34d/0x360, CPU#5: allocate_secret/570
>> [   30.084789] CPU: 5 UID: 0 PID: 570 Comm: allocate_secret Not tainted =
7.1.0-14063-g4edcdefd4083-dirty #10 PREEMPTLAZY
>> [   30.090937] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BI=
OS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
>> [   30.097543] EIP: __cpa_process_fault+0x34d/0x360
>> [   30.100514] Code: ff ff 85 c0 0f 89 7d fe ff ff e9 3d fe ff ff 8b 03 =
8b 00 c7 04 24 c8 ff 64 c1 89 44 24 08 8b 45 e8 89 44 24 04 e8 53 7
>> a 00 00 <0f> 0b c7 45 f0 f2 ff ff ff e9 fc fc ff ff 90 8d 74 26 00 55 25=
 00
>> [   30.110829] EAX: 00000000 EBX: f64afe98 ECX: 00000000 EDX: 00000000
>> [   30.114799] ESI: 00000000 EDI: f64afe98 EBP: f64afe04 ESP: f64afdcc
>> [   30.118785] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 0001=
0246
>> [   30.123020] CR0: 80050033 CR2: 46c48ffc CR3: 038c8000 CR4: 00000690
>> [   30.127010] Call Trace:
>> [   30.129078]  __change_page_attr_set_clr+0x5e7/0x870
>> [   30.132275]  ? console_unlock+0x99/0x130
>> [   30.135069]  ? irq_work_queue+0x36/0x70
>> [   30.137853]  ? page_address+0xd3/0xf0
>> [   30.140421]  set_direct_map_invalid_noflush+0x52/0x60
>> [   30.143782]  secretmem_fault+0x128/0x210
>> [   30.146560]  __do_fault+0x25/0x90
>> [   30.149053]  handle_mm_fault+0x6d1/0xcb0
>> [   30.151759]  exc_page_fault+0x135/0x3b0
>> [   30.154487]  ? doublefault_shim+0x150/0x150
>> [   30.157416]  handle_exception+0x130/0x130
>> [   30.160137] EIP: 0x804d29f
>> [   30.162307] Code: 89 54 08 e1 89 54 08 e5 89 54 08 e9 89 54 08 ed c3 =
0f b6 44 24 08 89 7c 24 0c 69 c0 01 01 01 01 8b 7c 24 04 f7 c7 0f 0
>> 0 00 00 <89> 44 0f fc 75 0e c1 e9 02 f3 ab 8b 44 24 04 8b 7c 24 0c c3 31=
 d2
>> [   30.172936] EAX: 5a5a5a5a EBX: 00000000 ECX: 0c800000 EDX: 3a449000
>> [   30.176927] ESI: 00000000 EDI: 3a449000 EBP: bfbbae18 ESP: bfbbadac
>> [   30.180897] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 0001=
0246
>> [   30.185161]  ? doublefault_shim+0x150/0x150
>> [   30.187979] ---[ end trace 0000000000000000 ]---
>> Bus error                  (core dumped) ./allocate_secret_i686 2000M
>>=20
>> The equivalent bug was pointed out by a local Sashiko instance on
>> https://lore.kernel.org/all/20260410151746.61150-3-kalyazin@amazon.com/
>>=20
>> This hasn't been reproduced it on older kernel versions but from code
>> inspection the bug seems to go back to the original introduction in
>> commit 1507f51255c9f ("mm: introduce memfd_secret system call to create
>> "secret" memory areas"). If this configuration has always been broken,
>> dropping support is not really a regression, so do that.
>
> Well OK, but the secretmem code is still wrong.  The patch protects
> people from hitting the bug but leaves the bug in place.  Surely it would=
 be
> better to fix the bug?

I don't think the code is wrong if highmem is disabled. Certainly
there is an implicit coupling between the .c file and the Kconfig file,
but we could always add a BUILD_BUG_ON(IS_ENABLED(CONFIG_SECRETMEM)) to
the relevant bit of code to make it explicit.

> Is that as simple as adding the folio_test_highmem() test? =20

This would fix the WARN+SIGBUS but I don't think it resolves the fact
that this configuration is completely untested - there are likely other
functional bugs? But more importantly, I am not sure if secretmem
actually does its security job if kmap_local_page() isn't a NOP. I
think shipping a "security feature" that doesn't do what it says would
be really terrible. (It might work totally fine, I dunno, but it would
require some research and deep thinking that I don't really want to do
for a configuration with no users).

> Or switching to GFP_KERNEL? =20

... Oh, that's a nice idea though :)

Any thoughts from Mike on that? I think it might be just as good as this
patch? And then you can still use secretmem reliably on a 32bit build=20
as long as you have <1G RAM (or whatever the limit is).

> You already have a reproducer (thanks), so this doesn't
> sound like a lot of work?
>
> (Should set_direct_map_invalid_noflush() WARN if passed a highmem page,
> something like that?)

The message is a bit weird ("called for zero pte") and the code seems
fiddlier than it needs to be, but to me it looks like the x86 code is
handling this correctly. __cpa_addr() returns 0 and
then __cpa_process_fault() WARNs.=20

