Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0900D489A3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 13:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DE936B0089; Fri, 16 Jan 2026 08:11:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 188A36B008A; Fri, 16 Jan 2026 08:11:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B56D6B008C; Fri, 16 Jan 2026 08:11:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F07ED6B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:11:42 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 98D1B52CF8
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:11:42 +0000 (UTC)
X-FDA: 84337864044.21.C89843F
Received: from mail-43100.protonmail.ch (mail-43100.protonmail.ch [185.70.43.100])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5EAC34000E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:11:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=NsW4vNWI;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf12.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.100 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768569100; a=rsa-sha256;
	cv=none;
	b=tTagZnKlcK+uhjlw7yVsKViNOQDhYoFOyTtJYQR/8+1tNb3WzxVcM3UwB72gEjs5TTQMYr
	5LIqRBDBexG3go9hiT36Kje3WPuHdo6gy81ctFf5/pcSsa96WMXFX1XzNubmQFIpHS0G7N
	3VoRU8LjBper1AxCrN65KcJg1hirFIY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=NsW4vNWI;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf12.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.100 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768569100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VUy6Z0nl3UN06uLRlgqbdTzfRq3/0KilXmceKHyT+FA=;
	b=OM7EGPlOscHvgqFWgVag1teTREacHuGgv8CTcl9ZpyNyGssn1nZEjjLraHwX6s0xcD7T2B
	TZlmAD+WObKvu9y908CrNjkfjqTFSM5Rx1m0nx+w6sf9ddVQO5T8iCenbXfzEqG2liyWsk
	PjW6sHlGBwZJR5FxVVNRIwHpTsId2fg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768569098; x=1768828298;
	bh=VUy6Z0nl3UN06uLRlgqbdTzfRq3/0KilXmceKHyT+FA=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=NsW4vNWI+sy+jtCwGEepBnQnhkRgbVqOJ8bQNyN7XOu/Bmiv5eUFHRTgDUqIkkZCL
	 3+CCEPXQsQCOIr68mCMChffW/v/xa4NXARE65ARAC1tUdbbVCR0YM/VVD87fT5Hnf4
	 g7uTiInwCUmOnfHiNaRH18bYdqK3XZUA8thcmHVBaNFZ6vrtQYXmnYyJGmjtUTL/eI
	 FeJuldGwl9Kv2xapCx8JUTWPf6JHyDRUjGnR9+bb0IaoSyvCU0fdqXQw8ZvrndtD8c
	 iztvGbaWNit1drtUSc0hgFnX7xkOB7r9nmg0mEFIctA/zk1M/dLih3b+MPcDkmHT6E
	 fi3T+X+l0xZ7Q==
Date: Fri, 16 Jan 2026 13:11:32 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Samuel Holland <samuel.holland@sifive.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, llvm@lists.linux.dev
Subject: Re: [PATCH v8 01/14] kasan: sw_tags: Use arithmetic shift for shadow computation
Message-ID: <aWo31aytvelldfiE@wieczorr-mobl1.localdomain>
In-Reply-To: <2592f303-05f5-4646-b59f-38cb7549834e@gmail.com>
References: <cover.1768233085.git.m.wieczorretman@pm.me> <4f31939d55d886f21c91272398fe43a32ea36b3f.1768233085.git.m.wieczorretman@pm.me> <2592f303-05f5-4646-b59f-38cb7549834e@gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 3ed341666d06b561ea7c217cda5b5d4311dd5d20
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5EAC34000E
X-Stat-Signature: jzht39iyc331uahjng4gdbf9aqhk1kb8
X-Rspam-User: 
X-HE-Tag: 1768569100-941144
X-HE-Meta: U2FsdGVkX1/WpFOHMX4Zf+vmRZY31EXZ/DOEixRlomrN6PqiUXlNLOhUZnlN79scBr/Sbo4tMv+Eq/KXagvon0FJ9LsN/uavdLIG3oH1M6o4KnfnyOWvIxcSIX+NrSVKAgsIA4Rives8tf04ZHE0NadsSgBL3FIkUl3tiT1AKApAzsmtUNK8t8aeuuSflaxwPAKYqfZ52zQh50D8M0PEVW5WgMUkZy+RKS5V8O5A/lkvH9y9S4A/1JHCaqq9BvjR4r33rQVO2kk9WlRateSv6/fW1Tf0a1qHMu8J6n7BV/TcTu4cmqBvU05mYN5CbtKkXGpo561Ql+m5UOGxOntNPk2DYBL5fiXrsG+Y9FVMJnZDTQiJ/EEpYTOz0vfddHy47xkWRdGwDRLYNw2Jqk9jrXqWtaAco0kcQ1FSXDDYQC9k4gx/Nq1tAA/YVjCo5081CKUcFBfSHbWC18mVFMDpogfP/QlSkMY/YaSPBZKfmasJ6jGLon91v0R+mEgHz9V5inE4GS99nYSiiB+6PFfwdQC3mluAG/U7H0haVF8aSm8OIL61VNLy5GnYgmU47JN/0V+8fMhXBuVm3wkbaOoLSmyIbxwCJS9LQUo7axmN7DixkvVLaK9O8UMcjuoWdiJnoFln2PfqAs2fAGfu2Xi3SVdC0ilmh6oE170N00TMCFhNLxA/0gBefJ1xl6/IFIBMxNvgX+onxLBErFTDVJ+SqM99gkAtjMb+ScNuiCzQJKorOHKY6ymU1PmWCJg/4lOmjuK5DXR7bDOnFYEaz+6WvGlLwzXsT60CmFuOFJeqliA07RmLt2hI/2CWl9TCToqxKeNTl/V0j0oRF2Jg6Q92E24yOowsfWwiUWqfJRqUJZDdex4SFWzPWIQZOVxqLqHkdsP9vsjfIVX3I30lxf7gc+lMT/BNT0mFVo0Og311bLHLsOAeKuR44aDkLJb3G+JZaccOF9tNwAy0sYy+gRW
 RBrhZcJ6
 d06ikicCJ3RjlkeYtSYBzpifgIk7DCGeqQIFHVsxNcw38pVc40jySRb2+urBXV6wqzU9vocL4JLR4G6KGPd0GcP6GpEEZmnZ+9/C+WS1o43Ey/+tJlsav6jLEkCZMoxYiDmwmnzesDGa0tZDatej6LyBsRzFAJqwKwavyZc/51bE4tMz/Il/LvfQoS6qdXAB/u6i44hkCO7uVvjdrPQli7hgdN2sPBrKNrEsg5XdzQYH8mEN8Rzm6zffmkgcjzac6fpcfGx3iJdbLmmovTvsRshr/u0vfcEiQ5Flr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for looking at the patches :)

On 2026-01-15 at 23:42:02 +0100, Andrey Ryabinin wrote:
>
>
>On 1/12/26 6:27 PM, Maciej Wieczor-Retman wrote:
> =20
>> diff --git a/mm/kasan/report.c b/mm/kasan/report.c
>> index 62c01b4527eb..b5beb1b10bd2 100644
>> --- a/mm/kasan/report.c
>> +++ b/mm/kasan/report.c
>> @@ -642,11 +642,39 @@ void kasan_non_canonical_hook(unsigned long addr)
>>  =09const char *bug_type;
>> =20
>>  =09/*
>> -=09 * All addresses that came as a result of the memory-to-shadow mappi=
ng
>> -=09 * (even for bogus pointers) must be >=3D KASAN_SHADOW_OFFSET.
>> +=09 * For Generic KASAN, kasan_mem_to_shadow() uses the logical right s=
hift
>> +=09 * and never overflows with the chosen KASAN_SHADOW_OFFSET values (o=
n
>> +=09 * both x86 and arm64). Thus, the possible shadow addresses (even fo=
r
>> +=09 * bogus pointers) belong to a single contiguous region that is the
>> +=09 * result of kasan_mem_to_shadow() applied to the whole address spac=
e.
>>  =09 */
>> -=09if (addr < KASAN_SHADOW_OFFSET)
>> -=09=09return;
>> +=09if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
>> +=09=09if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0ULL)) ||
>> +=09=09    addr > (unsigned long)kasan_mem_to_shadow((void *)(~0ULL)))
>> +=09=09=09return;
>> +=09}
>> +
>> +=09/*
>> +=09 * For Software Tag-Based KASAN, kasan_mem_to_shadow() uses the
>> +=09 * arithmetic shift. Normally, this would make checking for a possib=
le
>> +=09 * shadow address complicated, as the shadow address computation
>> +=09 * operation would overflow only for some memory addresses. However,=
 due
>> +=09 * to the chosen KASAN_SHADOW_OFFSET values and the fact the
>> +=09 * kasan_mem_to_shadow() only operates on pointers with the tag rese=
t,
>> +=09 * the overflow always happens.
>> +=09 *
>> +=09 * For arm64, the top byte of the pointer gets reset to 0xFF. Thus, =
the
>> +=09 * possible shadow addresses belong to a region that is the result o=
f
>> +=09 * kasan_mem_to_shadow() applied to the memory range
>> +=09 * [0xFF000000000000, 0xFFFFFFFFFFFFFFFF]. Despite the overflow, the
>                  ^ Missing couple 00 here
>
>> +=09 * resulting possible shadow region is contiguous, as the overflow
>> +=09 * happens for both 0xFF000000000000 and 0xFFFFFFFFFFFFFFFF.
>                                  ^ same as above

Hah, right, thank you!

>
>> +=09 */
>> +=09if (IS_ENABLED(CONFIG_KASAN_SW_TAGS) && IS_ENABLED(CONFIG_ARM64)) {
>> +=09=09if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0xFFULL <<=
 56)) ||
>
>This will not work for inline mode because compiler uses logical shift.
>Consider NULL-ptr derefernce. Compiler will calculate shadow address for 0=
 as:
>      (((0x0 | 0xffULL) << 56) >> 4)+0xffff800000000000ULL =3D 0x0fef8000.=
...0
>Which is less than ((0xFF00...00LL) >> 4) +  0xffff800000000000ULL =3D 0xf=
fff800...0
>So we will bail out here.
>Perhaps we could do addr |=3D 0xFFLL to fix this

I suppose it should work; tried it in a python script by shoving various
addresses into this check. Pushing addresses through a logical shift
memory_to_shadow normally would return early as you noticed, and after 'add=
r |=3D
0xFFLL' it seems to work as expected. And I didn't really catch any incorre=
ct
address slipping by this scheme either. Thanks, I'll correct it.

>
>> +=09=09    addr > (unsigned long)kasan_mem_to_shadow((void *)(~0ULL)))
>> +=09=09=09return;
>> +=09}
>> =20
>>  =09orig_addr =3D (unsigned long)kasan_shadow_to_mem((void *)addr);
>> =20

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


