Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5117FCEE32A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 15:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9A3D6B002C; Tue, 18 Nov 2025 10:49:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A23876B0089; Tue, 18 Nov 2025 10:49:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EB846B009B; Tue, 18 Nov 2025 10:49:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76A1F6B002C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:49:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25854C04A8
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:49:49 +0000 (UTC)
X-FDA: 84124163298.19.E341CB0
Received: from mail-106121.protonmail.ch (mail-106121.protonmail.ch [79.135.106.121])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4C0758000D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:49:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="VU/bLwEu";
	spf=pass (imf02.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763480987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a9ZfR2miDizST+NAQHBsA4FP50QJXQbD9wrCS0aDhy8=;
	b=0ZZfK/N5vkKkW2DvkLENHp9JZrS34xoh3iLE1R+yBAO7pc9CokY15vLfsWQTOpsMnXZGzD
	7L4+jJDQnwYjidLKQJmfVmRYTutnJJW4SVVDPb7+iRFJWjWqHVvHIGsk+Mtae4Q3TGJLxR
	1Id+akdcT94z6IYZNrCQ5XixIyvp3oo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="VU/bLwEu";
	spf=pass (imf02.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763480987; a=rsa-sha256;
	cv=none;
	b=YlS0i0s+j7eMoDw8WWdlo9ypZv9Iovw67fkVUYJ2hs3q9/zCWnuMXh900SV8D0cYpsxh7h
	6n62MvJXlnAm/g6mMROErM3l91yPc2dhx+GcpASf/Bw1B7tMYgoaSlCxiq/v6TYBZiesno
	appxSDIx7+iiwFWrrlnkO3o10ZZBUb8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1763480981; x=1763740181;
	bh=a9ZfR2miDizST+NAQHBsA4FP50QJXQbD9wrCS0aDhy8=;
	h=Date:To:From:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=VU/bLwEuIA8h9TCyJ9L4mIWEDwhoUAZ5oktm+sibJB8c9aTCHAxh4iEjZUrUcj6WK
	 DdWYM7vyaQOmZlh5HL5Rop5CGc1TZipkU5l3spES7VnHm/wUUlnVytrI8uH5q7ufRi
	 fJw0DGDWl+PDb+suCmmvDLbYmrbGD/oONn1SpgQgOMNsVeLROqr98iWpCJYovuu/sN
	 41PWpyT55lKaZwMubphsuvZFYg/YtTETtW1C8gMcytVRWd8U1Gal8gOTSiTCz1xJ+K
	 7NTB37EXbP+Q7djtplgrpcbD/6KUccafGQHCQks1468PHcx+U+AH4aBTr4zCMgXQ4E
	 UAncnjv3o9aLg==
Date: Tue, 18 Nov 2025 15:49:28 +0000
To: Alexander Potapenko <glider@google.com>, xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de,
	surenb@google.com, ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Subject: Re: [PATCH v6 06/18] x86/kasan: Add arch specific kasan functions
Message-ID: <tide3xvqthah7m7ji6bfzb5i3ofabgwf45bn3qvvzsurnswh6z@wjxzriavwlp5>
In-Reply-To: <6nifmxti2xfbnrdtxbosojfw52sofc7zkyjcbcyeawz5lt372f@h6ksdfqddk4z>
References: <cover.1761763681.git.m.wieczorretman@pm.me> <5be986faa12ed1176889c3ba25852c42674305f4.1761763681.git.m.wieczorretman@pm.me> <CAG_fn=XFXFAvKS2+bc66FR+gw7rfSybETAOBUR_vneaVdF5F9A@mail.gmail.com> <6nifmxti2xfbnrdtxbosojfw52sofc7zkyjcbcyeawz5lt372f@h6ksdfqddk4z>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 2d31863a5f203112dd7296a62db9ab5faf481d58
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4C0758000D
X-Stat-Signature: kskh78ech67u6z44oua4q7r6b76fn3fc
X-Rspam-User: 
X-HE-Tag: 1763480987-274547
X-HE-Meta: U2FsdGVkX19qHnKOfJIvN4VYdHdbthnrRwXB1cfeclPtAX3FgPM8vV4MpvRbjChecXO1b1xGuzYVceHjhed2NIQY8d8naF/AHXHcoFq3nolLJfmZTstXKdDhiqadnjZjUANz00eyBrJKx4ddCD7+GhdNzjlRHYaV0xZvUm+bOkkDupkGpvt2zp+rSxoj7JY2A2B749RtWceNaLK9sOgB45Fi0YoBR0ePt4r3U3ZnY3enCgcfFspabEZS2X+Ezez6yuRUPIdWVYK7OecEMQ12fdiSU2nAy6RoeNXFjLtIca1l3oda/HNdoeNRsbdDnr5pnX8YFHdDrSO+mjS07uZ9xXmjpwwdJfphJzCfpjvXLHRDBYhFu2uG5WBn7Crdd7Y/ltKyBWvyRkb/7E5xGIxHEtrIFR+zsS8IdQz2jcYmvUoCLTvvW0KbPjhiHAeAaJx84BZDF+IzESCWckYbZ4W9/zHRQ8Zkfbwe38tevIphL8lceZZ8F2Agr6R/2YjBAau1tSr/bsNXo7/GglsxkquektFKs6IjvZOHPy1KAiHJccinCUDGhZk0q/DCS3Rzr9Qd1Fj0CYxLzP0hRuL1UHzWXaU+aHaEtDnnnjdmph2Ui5JbXnvLieA9Nhv0j0xqFFd3beG+Ws2s6gBPe3ILYY83xyqEMNvjxJ+Co0AZMG+iYvJ/yKrymP8qRZPXssiPonMvtK3Xnv7aUbrw4P9xZ+2Y0azPAyP5Rk78/VRW/LT3jUQiEOklj+nociLgi1HaLSPdnFeV29bPDOaYmvtuvPzKkBA0jatqlpJxTrrPODunED+PUIsAc8tG/hd8jQahNBewL/YTrP7WvR1El27ef0VvjcdFAjPcBFKLXZgbtYkFDj+eOFgxHh8Au1NMjxrFH5aeZM+qaNmS1Veb1a3Lf8SQTJdjB/T76EoDQeAlf4b623HSTRdGykCMCxvNbs14EmxvfELMAHS2B56ocbNdHRU
 9nIwtGET
 f4bmEmLhIzRForxJHvpmWQjQ3kXHTw9HJF248n8l7LSTpso/i8tfX0yZrJGwNU2MgD/Wn/K2CsmNuvd8uw9PTC88up+AnuPz7xszP7cYOOxlvuMm/pvK7ENs79zMCc1sOYzWimxSkyCE2nbILfVdRyApEGLoNow2ZqqOc9+9VGj9wmqw8P6Z6iXhhJSvu/UzypdMYReG4gIf2svqVZFumWjCRSusYmKbl9wrK6rUvab+Evy5IY4AsgsimCBygGkK9MrvCl8MqXwsZCkT7/yA4gnTA8FnQWMXnnMrGcf6TCvUZtqp7TSasP93k5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-17 at 18:41:35 +0000, Maciej Wiecz=C3=B3r-Retman wrote:
>On 2025-11-11 at 10:31:13 +0100, Alexander Potapenko wrote:
>>> +#ifdef CONFIG_64BIT
>>> +static inline void *__tag_set(const void *__addr, u8 tag)
>>> +{
>>> +       u64 addr =3D (u64)__addr;
>>> +
>>> +       addr &=3D ~__tag_shifted(KASAN_TAG_MASK);
>>
>>KASAN_TAG_MASK is only defined in Patch 07, does this patch compile?
>
>Seems I forgot to remove it from patch 7. It's originally defined
>in the mmzone.h file and looked cleaner there according to Andrey.
>
>Thanks for noticing it's still in patch 7, I'll get rid of it.

You were right before, after removing that define in patch 7 it doesn't
compile. I think I'll just open code this definition here:

>>> +       addr &=3D ~__tag_shifted((1UL << KASAN_TAG_WIDTH) - 1);

I don't see a nicer solution here if taking things from mmzone.h is out
of the question. I suppose a #ifndef KASAN_TAG_MASK placed here that
would just shadow the one in mmzone.h could work too?


