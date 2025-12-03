Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2394D116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 07:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9754C6B000E; Wed,  3 Dec 2025 02:30:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926176B0010; Wed,  3 Dec 2025 02:30:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83BF16B0011; Wed,  3 Dec 2025 02:30:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 740656B000E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 02:30:23 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A119B1403F5
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 07:30:20 +0000 (UTC)
X-FDA: 84177336600.09.E32FD59
Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	by imf30.hostedemail.com (Postfix) with ESMTP id CC6F080002
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 07:30:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=OOAew4S9;
	spf=pass (imf30.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764747019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CDRU707d2INpmwpTAfBR2VrUuDWM3CQSFKF4zJkZLpc=;
	b=AUgcbcK23E+SzAiJGtAXzshzaVmZzdGPMS5TonDp75M+/XXCARUClqtL/PvzTlqq7IB7gT
	rF8TMHS3Vgi4z5nx/QJN164e7C0VYaI0WR25LFGRF41W/FxSdbl3MMaiKB85rXV9ERcbuX
	pQILZkQmP7DBgIlNPingUcFLBSJhoa0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764747019; a=rsa-sha256;
	cv=none;
	b=FZD5Z65Uz3xMhOVM6DdlVfS5ebawvurg4k59MA2UMxTJWANWzCwWTN+p1w1vWs67MfLNtl
	WWi2GVLifIIFb05zodPjWzgS2aN2MgHtYtWhYJwG4cIET4xM1FnROdtOcOy8SIzyf3rPhX
	xkNGLNwXoZdZiZoZoZwVju2ojWDIadU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=OOAew4S9;
	spf=pass (imf30.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764747016; x=1765006216;
	bh=CDRU707d2INpmwpTAfBR2VrUuDWM3CQSFKF4zJkZLpc=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=OOAew4S9QEHV8Cdmz22rEdkYi6SFNVv93POgRaL6Xe8I3qWoNThzBhj2VGF+PzAtj
	 h383Dv2Zp0lnXpfCoZRGvAArwv+8JCkFemWkbq6yWDlm7KSnhG6h/DFxCARKJmBAuX
	 qdV1V9sx5Bz+DF5UYeANcnxuM0p10lmqkKNRmj0r4o0a0EGUsShuBne3nR+zwhjv9j
	 1H/96A27lFI5H/k+KZvF9yfKzB6MLZ6qXaHl7OaDCzp3zHUEJk6/+nrN1FIRXoIqTV
	 dVdJA1vv1hUs73U69CaY4RRGY7MlpyFGIu4iS6HWAOmDHko9yUzGvaxDKmztJ/wAiT
	 MpRbBJZP7ld1w==
Date: Wed, 03 Dec 2025 07:30:10 +0000
To: Jiayuan Chen <jiayuan.chen@linux.dev>
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Cc: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-mm@kvack.org, syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Danilo Krummrich <dakr@kernel.org>, Kees Cook <kees@kernel.org>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/kasan: Fix incorrect unpoisoning in vrealloc for KASAN
Message-ID: <wkcpaobuckopokvqfyb37ugox24bpcyzl6pztaz42s6byzf4pg@z4ndbjoxbjq7>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 4c6696efba181766eb8a1fc4beeaf0a6b1777034
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CC6F080002
X-Stat-Signature: uy86f9rzx54deahrky4xca19hhogo4ya
X-Rspam-User: 
X-HE-Tag: 1764747018-412296
X-HE-Meta: U2FsdGVkX19KKn0tDk80c1tFKt7wyVXzGvAvqPM0/LZJHP5/ALyChvC6aLFTtUpQLFgl1gS5wrW6ZvE3VYOSQkfp0vyy8IGNtFIGOjnh4VTYG4dRUnyc2faVLWfRQnMCpbfx9BR04HI4j6xOW5XXiy625BGmAfPbQNaaz6piuwfI1U/qlTfW9h77Qs9B/+23QTTxB+MO6xyRVyeZjy6a8GgU5M6Eju2FhLlOeAh9e4F2PMpp54Ub4T22+koxP6+CpDyaVblrxHnxG1gV7KC6Pl14oFrWzQCjIhAGaiLnsiuJ/DJnUEzn7ekrBmrPdIwnxHWUYVphRJcwwqpgho9gKRLEux6vAabvRELlMXO4gIwEFZv7UKOz8TfDnZQwMWZ/suIvjX43wicxlvt8VZp3Ta1P5JedKhCnCvQYIxyru3g18yMRj/dJkqzKFqHs7S6F6C1ex9B8Aoc2AYoMdronOdVNiBuzNSZ9oQneYiLFOCY1X7UhnOc5rNyHAZ0fPsf4HpduwuE9xbkGuSeOR1wwmV/cnjVc4ZtzdyMvc7MJFNRRy4oejBAKjoSXMli0nlOeH4xliB135eDJYr53PQXSt/NSxCIvppaabJKse2+QjHpbZ1P3TON8NR6SAzmejz1uYWwrwKAlyy0IfYstuSaQ3c4bx0KSb7YO4bimH8c31FYinA4+SL5KTqQOcai7kpALWmvbJi/Ri+8ToJL/xER9gSiujrGt0+UqUZej+K70Us5vKGzX68ZijsFnnCsiSYUTWn6TKl62oY2C+GYx/3Rl6MC1LRrut8dB9TltNjitEK+R5eC9M4jaj5tdya3m+eCvtLU/9nC54Yt6pqMAjSUjgfRl2p7VIEGXF4WtpDZ4RI3TZpI3y52fywWTmfb5eUZnpguSqPd+GKH7EufdOR3+a3EeOVxHde2n8y4kYTdIAKDdarYKK98inLyLdO66NoxhN2qUKXNUwiH4QCRTg2W
 xEYs4v9f
 XPSUYvYnAxn45jAXZiou+iQx9kkpfvRIu9I0q44rfVYTWR22U9M+Fl/8jq/e3yyrR5kcsv2BTujCn/WOTw7BWjfRVSBCdYXzkeEILi07m5VW6TbFYWPv3Hgy9bPKTGc/YxRO2BENvDMtNqpCYJdsIOiDGqCfy6A7OPrC6PFocj3iEueTVDlEs+sp/Oy9+6O4v70+Yq3h7wrrELt4o++3TFKfrVu7gMQWtJGB3fYDrio9w3jX6DKvmzUxqwpXhi0DLJ8Ejjt4fpUPy6sb6RLccR39Cjiee8x9KFT6tdR4Yk0gaar3arv/d/e+aCZnqKhowOiA2JCJMBOIb/FaktKgyHczC9lOhN09aIlTqqfeXE5e9O2BMMU/CWSSaqus8KfUtnU/pfw6GO2SabPBOEha5VAN2xp3phyS1eaVm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-03 at 02:05:11 +0000, Jiayuan Chen wrote:
>December 3, 2025 at 04:48, "Maciej Wieczor-Retman"
><maciej.wieczor-retman@intel.com
>mailto:maciej.wieczor-retman@intel.com?to=3D%22Maciej%20Wieczor-Retman%22%=
20%3Cmaciej.wieczor-retman%40intel.com%3E
>> wrote:
>>=20
>> Hi, I'm working on [1]. As Andrew pointed out to me the patches are quit=
e
>> similar. I was wondering if you mind if the reuse_tag was an actual tag =
value?
>> Instead of just bool toggling the usage of kasan_random_tag()?
>>=20
>> I tested the problem I'm seeing, with your patch and the tags end up bei=
ng reset.
>> That's because the vms[area] pointers that I want to unpoison don't have=
 a tag
>> set, but generating a different random tag for each vms[] pointer crashe=
s the
>> kernel down the line. So __kasan_unpoison_vmalloc() needs to be called o=
n each
>> one but with the same tag.
>>=20
>> Arguably I noticed my series also just resets the tags right now, but I'=
m
>> working to correct it at the moment. I can send a fixed version tomorrow=
. Just
>> wanted to ask if having __kasan_unpoison_vmalloc() set an actual predefi=
ned tag
>> is a problem from your point of view?
>>=20
>> [1] https://lore.kernel.org/all/cover.1764685296.git.m.wieczorretman@pm.=
me/
>>=20
>
>
>Hi Maciej,
>
>It seems we're focusing on different issues, but feel free to reuse or mod=
ify the 'reuse_tag'.
>It's intended to preserve the tag in one 'vma'.
>
>I'd also be happy to help reproduce and test your changes to ensure the is=
sue I encountered
>isn't regressed once you send a patch based on mine.=20
>
>Thanks.

Yes, the final issues are different, just we both want to use
__kasan_unpoison_vmalloc slightly differently.

Okay, then I'll rebase my patches onto your patch, restest on my end and
resubmit my series. I'll add you to CC and reply in this thread too.
Thanks :)

kind regards
Maciej Wiecz=C3=B3r-Retman


