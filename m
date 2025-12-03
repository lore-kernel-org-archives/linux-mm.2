Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3B35D15DAB
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 16:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32A206B0029; Wed,  3 Dec 2025 11:24:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3020A6B002A; Wed,  3 Dec 2025 11:24:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23EB56B002B; Wed,  3 Dec 2025 11:24:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16F8F6B0029
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:24:51 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62961BB095
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 16:24:48 +0000 (UTC)
X-FDA: 84178683456.17.CB2724A
Received: from mail-10629.protonmail.ch (mail-10629.protonmail.ch [79.135.106.29])
	by imf25.hostedemail.com (Postfix) with ESMTP id 46541A0003
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 16:24:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=lEgqJXRZ;
	spf=pass (imf25.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.29 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764779086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uYhB0X4kqL3Bw7rIqDJ1oTSdN5flbXlU0EovctUC5cg=;
	b=BQQ8Q365ysLu6vhcuXqNUJzqeU+SYRobPmUUYXo8AZcDvDAVp1k1/QS9LWrD8RXuKQoVZW
	8xfNmb/zO+o8qW0azyX/JbswZ1Kl1tDH3rbtL593NQBOGCgbOXpTRZY/yHK59vj9FrEVAM
	tCJXXUpN/YUVwyaaUiyYvbuik9uNayE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764779086; a=rsa-sha256;
	cv=none;
	b=QHPQNEinn95jHtrTbDEO4z69KbJTb6tANhgEmXeW/rt40WIH34ieajldGKR8KtQmIATxo1
	zaO7KJBwH0bpFrxdGwVBy7cF4O4pByXQIwARhAlfRtgSP0FGHR3AzmtX6EEySWSp6GeZVA
	zGvF03bpgRmA+ew/RnNjJdXUEjq2EIY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=lEgqJXRZ;
	spf=pass (imf25.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.29 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764779083; x=1765038283;
	bh=uYhB0X4kqL3Bw7rIqDJ1oTSdN5flbXlU0EovctUC5cg=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=lEgqJXRZLW4oBURmYtj6mfljuMNw2sHU3RyU0n8jtqXfnoRWGI63Pxk6Q0tzxL7+j
	 s7aNz8ueEwlJCIY+Ux3q/ZJDIZwXNSxBIe9mUfdOzWu73XT0bcOzJIxEklLTbNhyqI
	 cWrM3vODcmVKzWxg/44O4ukTCb5AtYj8n217QIzWe3OdgZbFItTvzDy4NkJ0S3Pn61
	 YFfDNAybDHiRv2IlgCg/lWP/rtqjWsups+PZgT9+u187vckvKPkqmlPnH6bpsS3CjQ
	 w7t6j1pOrAkYN7DfEfghad+qdm8bha+5Ye1uOCEpQ/Cm8LjBLzGTgaQyW1f1hkyZyF
	 vBeGV7ZrbBTJA==
Date: Wed, 03 Dec 2025 16:24:36 +0000
To: Andrey Konovalov <andreyknvl@gmail.com>
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Cc: jiayuan.chen@linux.dev, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>, stable@vger.kernel.org, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] kasan: Unpoison vms[area] addresses with a common tag
Message-ID: <phrugqbctcakjmy2jhea56k5kwqszuua646cxfj4afrj5wk4wg@gdji4pf7kzhz>
In-Reply-To: <CA+fCnZdzBdC4hdjOLa5U_9g=MhhBfNW24n+gHpYNqW8taY_Vzg@mail.gmail.com>
References: <cover.1764685296.git.m.wieczorretman@pm.me> <325c5fa1043408f1afe94abab202cde9878240c5.1764685296.git.m.wieczorretman@pm.me> <CA+fCnZdzBdC4hdjOLa5U_9g=MhhBfNW24n+gHpYNqW8taY_Vzg@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 4ee2cb0b262a61c236058e955b9c6d1886736ca1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 46541A0003
X-Stat-Signature: 8d17nq993c9remih7bhbgmsapjoy9ntw
X-HE-Tag: 1764779086-23174
X-HE-Meta: U2FsdGVkX1+nWBRicvP6EaDALp5j4DCTQDAAyI9iYYvMBlzhoGO2IJR1xngmIdBNSGLsLIgKRpa5bVFl64b+W91Crx+wClfFWWTtDAB9HLKcAXd81oR/3TdQcIK+hMIBHVQibXwisXZ+6bu3uQMYiU5veXLiofI+RYC6AxtT9bu6dXIJ0Tkx8TS3Od1Yw44PV1WTO3pUzp9xz72TgmZzIm6vrJfKqU3VGNfzG/YL7d2aUZWPERDbOAvqGejs+O3TKDDbKBKhyoO6ff9DtnDh0fXkEt2t5Q/F5eFN13DS362pOihBw1M9ArZ3MHlIj/ysj3lKaFBm9rS6Q0H6xsG4iMtdNsGu1ZKeKT+aQvtaqB0Q0l2nonl3Sj1DKag6TCQLTiX1XUB5Q9gAnCwWlBKq/pth0VrzXiQf6Ivsf9O8lebkko7yRyW033WYjaeXOClI94cT5stUTJaS3xO2RFzL2Rk4UvzwhdkjIamBnAF1yW/I+tcyaA+Xwb92GnJQv03RKDjJBV0Fmqa6ZKysbxTA6fzTVvE35pFEtiaulI9rZFp8yjGmTEWkkXz7F0cTlZV0j6peu2iY8QBTo7V0KKgQRXbaEQOxXiEHuxNakXMX2TOEf8SVcfqujKk9akAlRUTrd6EYE4zb3ytrKpTPeGgtPPOYxlcbiZNQq0HVptRRhcVb26UPLpaHHiAzhIY/LgQPWJe89oTzZ2Qbd6fuAefKD6sap/mznfimcV83l7/XFsSG9PKrrTroXQKF2nuSBIAw403RjdDwIRlyT39ghjXtB+XZiGs6OeDUAKYvdCJ86vlrXZVxj4KBb35L294aV0HZX3fBtCwUaqlwb4GduMaml0B875OPjgLDfyySS9qquy1JZJL6+QzuFxpa9qZTxqcTE69eMKR5jVDIGtWPjElMD/uMasclxbKmhBlsl2Nm78SCjhrMkBQJLGnTZO88MQUvVpf2miFP2Yvv7UAj0fk
 skQk5Sgm
 jafHNmY5tiAutS1+azxjbWRyTb/6hWsgixLhduxw6udwZKakqWLL7Dei6g/kRqb91b+ZrX+qHcGoFZp/+srM1bVNQ3tdOqHFmIF9P9Cyn6NGR8UXO/5FvYIVP5zF9leGtvfbjSYxFs43QhMtNDLs3W3nAO7qgvj9DAh8DpPcZ4METn5OC0P0gsu0b0tshBNLjkzPCtPBPX4EVN0OK1y/I1MlgAtpoiEnidMHbUKQenjj+Fefc9Kr0osMp8lKUelAxoI0IJW6+fbuziQ+AwE1ghIjjurY1tE1aRCdNHHba+yNbOT2MSBJFY3Ju6yBh5lNErjMGNfRoadCeqdXPn13uX/SWgl878yjy40Vk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-03 at 16:53:01 +0100, Andrey Konovalov wrote:
>On Tue, Dec 2, 2025 at 3:29=E2=80=AFPM Maciej Wieczor-Retman
><m.wieczorretman@pm.me> wrote:
>>
>> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>>
>> A KASAN tag mismatch, possibly causing a kernel panic, can be observed
>> on systems with a tag-based KASAN enabled and with multiple NUMA nodes.
>> It was reported on arm64 and reproduced on x86. It can be explained in
>> the following points:
>>
>>         1. There can be more than one virtual memory chunk.
>>         2. Chunk's base address has a tag.
>>         3. The base address points at the first chunk and thus inherits
>>            the tag of the first chunk.
>>         4. The subsequent chunks will be accessed with the tag from the
>>            first chunk.
>>         5. Thus, the subsequent chunks need to have their tag set to
>>            match that of the first chunk.
>>
>> Use the modified __kasan_unpoison_vmalloc() to pass the tag of the first
>> vm_struct's address when vm_structs are unpoisoned in
>> pcpu_get_vm_areas(). Assigning a common tag resolves the pcpu chunk
>> address mismatch.
>>
>> Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
>> Cc: <stable@vger.kernel.org> # 6.1+
>> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>> ---
>> Changelog v2:
>> - Revise the whole patch to match the fixed refactorization from the
>>   first patch.
>>
>> Changelog v1:
>> - Rewrite the patch message to point at the user impact of the issue.
>> - Move helper to common.c so it can be compiled in all KASAN modes.
>>
>>  mm/kasan/common.c  |  3 ++-
>>  mm/kasan/hw_tags.c | 12 ++++++++----
>>  mm/kasan/shadow.c  | 15 +++++++++++----
>>  3 files changed, 21 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
>> index 7884ea7d13f9..e5a867a5670b 100644
>> --- a/mm/kasan/common.c
>> +++ b/mm/kasan/common.c
>> @@ -591,11 +591,12 @@ void kasan_unpoison_vmap_areas(struct vm_struct **=
vms, int nr_vms,
>>         unsigned long size;
>>         void *addr;
>>         int area;
>> +       u8 tag =3D get_tag(vms[0]->addr);
>>
>>         for (area =3D 0 ; area < nr_vms ; area++) {
>>                 size =3D vms[area]->size;
>>                 addr =3D vms[area]->addr;
>> -               vms[area]->addr =3D __kasan_unpoison_vmap_areas(addr, si=
ze, flags);
>> +               vms[area]->addr =3D __kasan_unpoison_vmap_areas(addr, si=
ze, flags, tag);
>
>I'm thinking what you can do here is:
>
>vms[area]->addr =3D set_tag(addr, tag);
>__kasan_unpoison_vmalloc(addr, size, flags | KASAN_VMALLOC_KEEP_TAG);


I noticed that something like this wouldn't work once I started trying
to rebase my work onto Jiayuan's. The line:
+       u8 tag =3D get_tag(vms[0]->addr);
is wrong and should be
+       u8 tag =3D kasan_random_tag();
I was sure the vms[0]->addr was already tagged (I recall checking this
so I'm not sure if something changed or my previous check was wrong) but
the problem here is that vms[0]->addr, vms[1]->addr ... were unpoisoned
with random addresses, specifically different random addresses. So then
later in the pcpu chunk code vms[1] related pointers would get the tag
from vms[0]->addr.

So I think we still need a separate way to do __kasan_unpoison_vmalloc
with a specific tag.

>
>This is with the assumption that Jiayuan's patch is changed to add
>KASAN_VMALLOC_KEEP_TAG to kasan_vmalloc_flags_t.
>
>Then you should not need that extra __kasan_random_unpoison_vmalloc helper=
.

I already rewrote the patch rebased onto Jiayuan's patch. I was able to
ditch the __kasan_random_unpoison_vmalloc but I needed to add
__kasan_unpoison_vrealloc - so I can pass the tag of the start pointer
to __kasan_unpoison_vmalloc. I was hoping to post it today/tomorrow so
Jiayuan can check my changes don't break his solution. I'm just waiting
to check it compiles against all the fun kernel configs.

--=20
kind regards
Maciej Wiecz=C3=B3r-Retman


