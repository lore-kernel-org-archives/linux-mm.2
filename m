Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29ACECEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 18:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67CA38E0017; Mon, 17 Nov 2025 13:58:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62C5F8E0002; Mon, 17 Nov 2025 13:58:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B998E0017; Mon, 17 Nov 2025 13:58:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3932E8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:58:28 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC487B77C7
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:58:27 +0000 (UTC)
X-FDA: 84121009854.03.C656963
Received: from mail-244124.protonmail.ch (mail-244124.protonmail.ch [109.224.244.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id CB9EA1A0007
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:58:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=aSMS2vsg;
	spf=pass (imf19.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.124 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763405906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fhxihtRxC0rWih6zRhIQ0MI/4P4VUJvqw2WCiJpsAFs=;
	b=GKZCCEs504ODOXc4AqhtCKky84peOEfVS9zjKgkPZHuweAZMW7L/Myw34+zmkwb4atk0bV
	xBILIvyd/1R8001yU/I0XQgxAbFIKBFQ4P41fxXPjpBQ0B0crm5ZDMU+hCGC1KyGOyacOk
	MsEGxerQk6VHHRxnXs1QGMj6si6X+7k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763405906; a=rsa-sha256;
	cv=none;
	b=UkKxOtpNo/3cPhgkPqJOG11pxH2iG+5FZCmUJhmU5AoD0IbNv+XEg15AuuGHVn52jma78m
	g3j5joQ4ooGEny/SkfheZbrT0inJvzFhMdv2QCMfmrmWIDPL0rLt+3t/gWBTNRiCW+aq1k
	9ZIxMt7Ise60EhJEuvtD/Kv8kp0m80w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=aSMS2vsg;
	spf=pass (imf19.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.124 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1763405903; x=1763665103;
	bh=fhxihtRxC0rWih6zRhIQ0MI/4P4VUJvqw2WCiJpsAFs=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=aSMS2vsgjqhABOKKmX+n7L/nYKJ4HsmbQTEgXiTOoY3Cd2FK585onBnDDSJ+D1ZmH
	 dj6ZPber0hjFh12DL2S+g5C29ScBlcj2WoRImmKPbgy4i8WhVJyy1lvNs9oM4w0oU/
	 CdnnnUK2oTosOTZImq1kqIdX65kFrGdsMX9ZnjZQ6L7F4kO+aqbkZ1DTfWbTj6eQdK
	 rjx8bj6r7nJy22ERnAhd4ghyneoMQLaymChmrZsLvuFej+A7MHrbAXuLjU92A95Q/f
	 87n5KZbG4GiCTECbznvPERG1bGaG3N+iGeAnP03gABCYzQCdmLEbvi1S4rUGkQhQr2
	 v1Q7mLEQN4nTw==
Date: Mon, 17 Nov 2025 18:58:12 +0000
To: Alexander Potapenko <glider@google.com>
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, ardb@kernel.org,
	Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 10/18] x86/mm: Physical address comparisons in fill_p*d/pte
Message-ID: <j6s4vcbtgjas2ktnpx7etguc2nccxa3o5hz3vabes7fn7gfb5e@xxbiwnnps64e>
In-Reply-To: <CAG_fn=Ut9JUpStLiO+GsoBpn3d_EyyttcuBby=EKzuxkKdcKcw@mail.gmail.com>
References: <cover.1761763681.git.m.wieczorretman@pm.me> <da6cee1f1e596da12ef6e57202c26ec802f7528a.1761763681.git.m.wieczorretman@pm.me> <CAG_fn=Ut9JUpStLiO+GsoBpn3d_EyyttcuBby=EKzuxkKdcKcw@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 5443841a22fdb0cd19c2ceb9e40b8cdbb4f4e884
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CB9EA1A0007
X-Stat-Signature: gdemsftgwqsurrxbkyg7jya991aaq6xt
X-Rspam-User: 
X-HE-Tag: 1763405905-222138
X-HE-Meta: U2FsdGVkX183ycGZB3oLkEpgIDETFt9UWrYquRC1nw4nA+Rvnhlmlu9Ig0nJO15M+6XpLBzd0Yjq4QNpd91ns37O92CVzuQKCNDGBZiH7MiAlg8MAUMLmargU9dBNZAGfpxT9+fEJBwLafFt10JZ5mh1DCfL9G5gYNppdESxcHU2oPT0oK1n6IPofrzIaw8SfX154e03aCEpLnlPZJk9igTnMz0bxdYV1snbStN/ubh8y34xTvGD+Fw0wRyAgKrCgVsqAQJVnZqSma52n5v/SnZRBJbjVHuBHs8JoeSEdXTx1G1uisSOCu0j9HVTcnX6GJpr1tWVSvDkPzAD/gU8LnfGmHPsklUQgWjAAtWYpRDANSy3ek66fIhQ2fMNUFFifSbVkyrp6gOdzsCTo5m3VoZlV6xsZq3CWvvItlShfQQjUA6nhUce0CZ6i0YtFfcsfw9Kn39tMlyb1VJAE81olb2mnZNwuhdGlBW2wGFUvyyetzpqW5wrvXE8jiK2u0WVRJWpZ41yR9wp2cDhEnm57krDHEvtF0DBOETKmktzZANt7WqpTSw3FIYOGiBX44hdcU0K8Ayn2s1BU6/F0za+U9M6Q3Sl0rVmK/E8LTg0fjLkbVAShWQv685rspAlkrwLyMKMgW4X76r1YOH6sKQOLW6oW2iJjquejdIvm8BK9mPQeUTaqn0AlN4zvZpcOSCtzkB+r07NW/jzXt0ZlbIn8pXe/opIIeZJFwezD+3AlpmeiPAnjpSRcIRx6sRe6TLdf+XM4XFF88jW53HBRqtd5yZO1KYb73u7uLaZ2LP9i0Qc2efVjCYLnwJyQlbxC5JBpfu+KJ7DbW3e07UgpOBiirwtZmNxA61utp+qI2nbAsUvlRTgMKcKENx0X6f+KRu2/AkChS3NDxOS+HaKM8HXTPpilaKD0Jt37WatYeg+6zs6mzM2z5s82Rllii0SN0UQ2uOtKdKOPU/3gNs5Ag1
 JWGHxHwx
 qvojuAzX2jR7yUOr0+b9BQNeCrsog95xYKG/FibfykPvX5d57AzdGBP/oNgeInPmK74vgQhmv/TB8M7k92+f8/FuJNoOsvmBgIR6GE4TrbnbcyqpglyeojIrI19rjUq4kIbNlxE8KTTqepzeSz+M4T4okkbMeqF2s8yFfRKbTl+cGhsaLnKMNYshWYGc95ci1bj3VF/5zvSG59shhG0ftEG/n9Mck1ahD8tduUDNca3VGcgkJGcp9e0H059nSdNlwrwLTUiLBmqtUJGG+g8QhmhqayDKKaYIERneR4LejnrFFmaIkaI5ihDIu2u05psd4ztCXhNDgTmaQ8TRje3e8Km1MiEIHe0hBP7Zjcjj+rDSlJZTT751dUSbuprN7KRiLmqS3kunp4rBqwaDYjPN5wrteeUrrGwhh0lTh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-10 at 17:24:38 +0100, Alexander Potapenko wrote:
>On Wed, Oct 29, 2025 at 9:07=E2=80=AFPM Maciej Wieczor-Retman
><m.wieczorretman@pm.me> wrote:
>>
>> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>>
>> Calculating page offset returns a pointer without a tag. When comparing
>> the calculated offset to a tagged page pointer an error is raised
>> because they are not equal.
>>
>> Change pointer comparisons to physical address comparisons as to avoid
>> issues with tagged pointers that pointer arithmetic would create. Open
>> code pte_offset_kernel(), pmd_offset(), pud_offset() and p4d_offset().
>> Because one parameter is always zero and the rest of the function
>> insides are enclosed inside __va(), removing that layer lowers the
>> complexity of final assembly.
>>
>> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>> ---
>> Changelog v2:
>> - Open code *_offset() to avoid it's internal __va().
>>
>>  arch/x86/mm/init_64.c | 11 +++++++----
>>  1 file changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>> index 0e4270e20fad..2d79fc0cf391 100644
>> --- a/arch/x86/mm/init_64.c
>> +++ b/arch/x86/mm/init_64.c
>> @@ -269,7 +269,10 @@ static p4d_t *fill_p4d(pgd_t *pgd, unsigned long va=
ddr)
>>         if (pgd_none(*pgd)) {
>>                 p4d_t *p4d =3D (p4d_t *)spp_getpage();
>>                 pgd_populate(&init_mm, pgd, p4d);
>> -               if (p4d !=3D p4d_offset(pgd, 0))
>> +
>> +               if (__pa(p4d) !=3D (pgtable_l5_enabled() ?
>> +                                 __pa(pgd) :
>> +                                 (unsigned long)pgd_val(*pgd) & PTE_PFN=
_MASK))
>
>Did you test with both 4- and 5-level paging?
>If I understand correctly, p4d and pgd are supposed to be the same
>under !pgtable_l5_enabled().

Yes, I do test on both paging modes. Looking at p4d_offset() I think I
got the cases reversed somehow. Weird that it didn't raise any issues
afterwards. Thanks for pointing it out :)


