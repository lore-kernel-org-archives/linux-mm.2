Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8E21D2F349
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 17:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0A46B0005; Tue, 13 Jan 2026 12:32:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6E3A6B0089; Tue, 13 Jan 2026 12:32:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7A246B008A; Tue, 13 Jan 2026 12:32:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A5BAD6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:32:34 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5BCBD1AD5FD
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:32:34 +0000 (UTC)
X-FDA: 84327635028.14.DD89071
Received: from mail-244121.protonmail.ch (mail-244121.protonmail.ch [109.224.244.121])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4F11A40010
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:32:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=gdXMnEdZ;
	spf=pass (imf01.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768325552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7QZm1CZeu8P4ksfxFy+d8iaWyvI0I3DKeA/oH7Yr3/E=;
	b=PUhEsHr8aHLIpGGbsRzg5sE/AtZz0q6HS4W3mCQEeZIEsvr7zpKTHypaW0St/XRbiUhULV
	9shVHr2yBeFX6hRqKmYzfHWcMLRbLgGQq73Gr+klaKBpsBy06Hi9PtEgy+4nc1J/uZvn3X
	qkAj3w3Bp8G/YWZINHmt/WLTBjwu32M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=gdXMnEdZ;
	spf=pass (imf01.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768325552; a=rsa-sha256;
	cv=none;
	b=ks2BjHtsYu3t9LTDYvouYwE1KCR4mIrRiV9pSOzMys+7MePRXiuYrIrqfZd9iZnOpoV/VL
	nPFrAiTdbm+ec0pVaNuJV1Pee00LgrkApxcEZB7ynYoSvwxxtefORIDJa+VJFEf815/cMj
	dvgHZAT9rZlBNn6a1HYrW2xTuP+i/gU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768325549; x=1768584749;
	bh=7QZm1CZeu8P4ksfxFy+d8iaWyvI0I3DKeA/oH7Yr3/E=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=gdXMnEdZmwn+tzH1Y7xVv5t9USdU9qSUiHNLP9uBYfdXrbzyAlzYJYd3+fdOIl8FD
	 4B1cwjyzCxH099YPM8pclhQdJIQFLPHDmdGXpFFHioTnZOh0Vhr5FMwFhvIPEgRIBg
	 imCV25e/DmTbnG9EQkSon6a6pbHZT2E4APl5n9XXqw4a2efie1W1vRw1zvk5GoN2BB
	 CF2NEfpy7D5somELQ6RBkORkPQVKPmlnpRyAdBSR0ORMaXUIdVdaUza5gnyA1Sz/Nl
	 g+SAZB5ORa63g+Togs39Um3ZPXCS0CiWYkzSCzRD7PN/QZwqJO9kQ2EKunsZqH6L8D
	 jLRIbJ2fappbQ==
Date: Tue, 13 Jan 2026 17:32:23 +0000
To: Andrey Konovalov <andreyknvl@gmail.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Samuel Holland <samuel.holland@sifive.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v8 02/14] kasan: arm64: x86: Make special tags arch specific
Message-ID: <aWZ_aRFfWNWiqzik@wieczorr-mobl1.localdomain>
In-Reply-To: <CA+fCnZfQmhSyF9vh3RzreY7zrQ4GbQOp5NbA0bXLHUMG6p28QQ@mail.gmail.com>
References: <cover.1768233085.git.m.wieczorretman@pm.me> <be136bf8d1a6ae9ef98686c3ba0b6a4e2ea2e780.1768233085.git.m.wieczorretman@pm.me> <CA+fCnZfQmhSyF9vh3RzreY7zrQ4GbQOp5NbA0bXLHUMG6p28QQ@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 023a5d308556f78925918902544da2df5131a718
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 85qobz4a3yfnmhhhgxrqi46i5jci5ibx
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F11A40010
X-Rspamd-Server: rspam08
X-HE-Tag: 1768325552-151382
X-HE-Meta: U2FsdGVkX19dTTFP7+Mpfct69G6rMfxEga2srueygQahIBBAm6MJwF+mFW58osWMrNxzVxUKm29lnc5HE1AozFkHHZLAre9D9vYdm/cq0n6qMGJ89KcH6cwYrerbAwTvrOdM4aDVfbg4bpgtcXZhiYkaQZlA+mEdCy6+B9Xqb0HRbbctR6e3Ai+D5pr2xJxEXLb0B3HZBzZeMBZCqfmZFXpQrSKfH529Qnk5wMwRNZqebZ9Vh46JRLpI2WARR+RQw4ix8m2vuXU9SJoLuKEo06RsPywEJsYT55/fxfkcrUOn/bihzzUc05p/Y4kKzmBr8d2iH3NkW6WL2L/0VCBsrt4Yl5OH/qxt4in1cXCIoJEbZmqNroxv77rtQ78K0EsqjM+xJWrE3xrf8aO89izMugAx6KZHIsTHlZOHrai/KSzPDI8cLNKNF6ZVKL3O3ZYhF/Uj+6b0yjIqDPHgWY9W8EYmEeYFKah63R1Z4hx50NZU6mjmwL5T1HI7SNFizoo8vF1OOPoQ+6AKqfr3WOR5iUrzaf6oHBZX7EBReiSVOte/2ujUSwEq4npx/67HuriGE/5QwOkpnzbcshxhAFpz89Z+XghjcT/+BMEoma0x1TabVj0ExSRx0E2howBZwMwylAaxmj7yZcazocosn2hlEaUdNMlBdw6WWEDSuYx+BdNzwqaoQEVQNq7AzVaYkEG3UNGy9ACr1MvFISlM3mgiACHM3hnXcQtWgQUqTurrIxzZqDztHa/iKzIbfMTom62VdbvNkEzaFiebetL7Wh48jfZ0aSkCpYA2lhMt/I2DxhkbNqec2sD3gWNBWVOnpjl/RGBcT6dPwPJb+sPV/fh9ce1P/Q6rJ2L0h8qn+8LMaTKqPV3UDDUN9ItdRfV6sRKdNgYfOMpvW0sFU4hrUj0OfD6R7Nifqgul0qzLtnA4dtxV1VJqz7V4RHrCbVAXEq8uKCs3l5I4bVMJlgrH457
 BnoFsU4R
 5fouqueLArYGokMpN1CvqJbndPaFFLsfW2YmlgeZLvLfs3Z3XhXuFEJq7P1sZ2u6ywTLYEhv9ZODgBw97uuwKISGTnnBGT5A6Pdv2aWuAqgwh7qX39SWwH3VL3ZCrk34OAlvHmjh9oYxRQhwcdVXanpG0WWyYjxLzPiuS5tXkqbHkOOPbHqase8A+9d6FSb8WgQbqCWW3koo6M052pNDJiXdikFg9dsWdjm6wpratPihMmD1k04lwmV7+PU6WrotvTDgxcmAU9w+GuDk5mHpM2nD7YB/p/ZvzFzOnktZCTC42F2rcPCXlu14rFwK5oHxGJBcU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-13 at 02:21:07 +0100, Andrey Konovalov wrote:
>On Mon, Jan 12, 2026 at 6:27=E2=80=AFPM Maciej Wieczor-Retman
><m.wieczorretman@pm.me> wrote:
>>
>> From: Samuel Holland <samuel.holland@sifive.com>
>> diff --git a/arch/x86/include/asm/kasan-tags.h b/arch/x86/include/asm/ka=
san-tags.h
>> new file mode 100644
>> index 000000000000..68ba385bc75c
>> --- /dev/null
>> +++ b/arch/x86/include/asm/kasan-tags.h
>> @@ -0,0 +1,9 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef __ASM_KASAN_TAGS_H
>> +#define __ASM_KASAN_TAGS_H
>> +
>> +#define KASAN_TAG_KERNEL       0xF /* native kernel pointers tag */
>
>One thing that stood out to me here was that for x86, KASAN_TAG_KERNEL
>is defined as a 4-bit value (0xF). Which makes sense, as
>KASAN_TAG_WIDTH =3D=3D 4.
>
>But for arm64, KASAN_TAG_KERNEL and others are defined as 8-bit values
>(0xFF, etc.), even though for HW_TAGS, KASAN_TAG_WIDTH is also =3D=3D 4
>and only the lower 4 bits of these values define the tags.
>
>This happens to work out: for HW_TAGS, __tag_set resets the top byte
>but then uses the given value as is, so the higher 4 bits gets set to
>0xF and the lower set to the tag. And for saving/restoring the tag in
>page->flags, everything also works, as we only store the meaningful
>lower 4 bits in flags, and restore the higher 0xF when doing ^ 0xFF.
>
>But this is not related to this series: I think the way x86 defines
>KASAN_TAG_KERNEL to be 0xF makes sense; we might just need to clean up
>the arm64 implementation at some point.
>

I suppose while there is only one such mode that stands out from the other =
two
there is little hint as to what should be generalized. As you said so far t=
his
scheme we have works - altough it is somewhat convoluted.

One thing I was thinking of was cleaning up all the #ifdefs for different m=
odes
into a more ordered structure. I think there are ~24 ifdefs in mm/kasan.h a=
nd
include/linux/kasan.h and many of them could potentially be merged.

...
>
>Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

Thanks :)

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


