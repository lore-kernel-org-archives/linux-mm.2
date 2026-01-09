Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40FEFD26D9B
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 20:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 819636B0005; Fri,  9 Jan 2026 15:05:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C7576B0089; Fri,  9 Jan 2026 15:05:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69F126B008A; Fri,  9 Jan 2026 15:05:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54EF26B0005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:05:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1583DBC011
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 20:05:48 +0000 (UTC)
X-FDA: 84313505976.07.783F82D
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id 259788000E
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 20:05:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JgfxfrnI;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of maze@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=maze@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767989146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ko3JkQ44nAbzOXJyEQ8fT/XizqibmiJrgKY4PUFt/a4=;
	b=JiOZOIet/MctQegsI3S/0xTLM129BEuRKexGrObUVf+hW7xrWS8wAC5gTPzej8LGLWHguT
	t5bVJRvsm3GRw4V2BvUwy7W5yONYoFVj3nPqf10Z5AeSLRwq2ffMLo1BxnjdDGFx6g9kxp
	fG4wafTyEBVYulo8aRrFXUmVyGbX9Ao=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767989146; a=rsa-sha256;
	cv=pass;
	b=KPRJJko2chp79eRC2Ox60fwZEeT70WbfhMd6uQrMOGOLgh3FEQFiwyPZWPaOEC0ZzzUEs+
	zG1XySuB7moYehMVK3UTkTWlZtpzoEcVveykcdOGu1qQjaa4tPH9OBpDt51OiYDjX64Cvw
	1roDtMq+U6zSfypO/v9zJLKWiAOUm94=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JgfxfrnI;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of maze@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=maze@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4edb8d6e98aso98111cf.0
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 12:05:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767989145; cv=none;
        d=google.com; s=arc-20240605;
        b=JWKErJsnqTnrVpiKU6MhSRMfvHz9ET5utYkEnhffVQIEB1etblkWkaEcagxji0F/JW
         CDNlVwVoMnrRELsOG3PQoHOPw0cu1yqohctPybBgPxUoLaBdqQkWZLqpQT68d1JYc1r3
         B/QAiqJWuJoQ2mTTggb5GB4SPXsS2CmbYLFVPHBt/c34S2Fy0NpmA3mr58hCa7Xu9udK
         oQf9N4rm/xP1otGIIw1l4zknxbtom5Xw3eHQs8wcU0JKW5PEjQBKC/FUsZmDMeUce+cB
         +WruaGALVPgg8BGv1Ful7rhLoN4vm0NhwvvvK3b931bhvupVK22C27YYaZ5GTOLn5rVD
         L5rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ko3JkQ44nAbzOXJyEQ8fT/XizqibmiJrgKY4PUFt/a4=;
        fh=rnzPzdqFv6mgBBkWvzgA9cnfNrDuaT77Px0hqxT+88A=;
        b=KMnoRFORlb+pjTTQ9HSKMPdnob2mapD/8rmzjFUSzmm0R18pVUSeocGn0oQWUvHQnZ
         kKo5mZr5iTIU9UDlvOSL8IhZ8Sub5dmfx2QoHFRAqBCqil0r6HpEND70yS6kqghBU18e
         IIpBXaVsmpn63rAHwM8FG7hJan77mGCd2FL0YQVr6pOT3JAt5taIlKr7vsBfOA19dlXD
         WeEk4Q5xSqySNlD5ykbs0WI/moNhCXpSS0Y59lpUbE3+nJYRwHP6DHShudYAiZivgXr1
         oAEyKwi8MngmfZFY9rRvghhN84luQaCJP2HnndxjQlJ5zWJjxoTRXTY7P702bWc9V6U/
         i1rg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767989145; x=1768593945; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ko3JkQ44nAbzOXJyEQ8fT/XizqibmiJrgKY4PUFt/a4=;
        b=JgfxfrnIsfK79kEbsfcEE++UJF+/pwi43tW7eEl/C5fDl0S3MOtDXbrBNDMzqOtP10
         6O8/vQ1b1oMRqUwqTK0SjAcnjbgI5ZmCyrCtUiBrTGOBsoPMKSjWGRleHn52EQSzsMKt
         TTS4cSP4IlziZZn35I/uw5fh2esnXnpLVxEwUJdnVTiKXS0s1o5+H/SdntoT9LksKWw7
         hKh2QEnGQvpaSFh+vZs1v9GRn7qLoqcbta0KCIl1RauC6NhY/T5ZTSBP2qpcCF0pibDF
         mdi97WHUrXPJdXaOYiarcfwvEOXTnDymHoaHY+rs4+2lFRLyesgr49q6QEK8I7n/bLB0
         OzxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767989145; x=1768593945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ko3JkQ44nAbzOXJyEQ8fT/XizqibmiJrgKY4PUFt/a4=;
        b=a4IvI+zmZOU/guAwGisxXyJGVYuapLMorMlGBHKDhA3KBN9bjxsMq5Eny8lLMhV4Wu
         fTQ3B1TWVhbB8GFiow20hOgSuWaZDf3bYege0R8W984XS9ek1AP/uRvYxEdYFKe0BvyA
         Rxu3t11E1OWQVAcrryQTKULM/nWGEuUZvEbwou8pBlMFgi7xEyslQquIKxDVM3aCTBbE
         8Up0oQ+g4PCd0AsrZuf7ocRvCifd48WvVLCJU2UE6hw2hNOL/AmrVSJ9AvvO4voYt3QX
         8fOyj5KH3hYoVxWTVOqSSdM04DgxpCyvNc7AYqzQFPSoHBoiHpQOumYb7yNsmlKjZDig
         0jlw==
X-Forwarded-Encrypted: i=1; AJvYcCXkVLd/pPaqoWpxJqViZpVFbH/P6pACot70XprzWpJEPbldnyGgg2Rf3Mxhk3Kl9oHmMCs+JLsLIA==@kvack.org
X-Gm-Message-State: AOJu0YxHb5be+k+nRw725x1PvrIGBZlmyC++P/G9ClQeJyqSfcKY0sni
	h6z07DpIINl6YuvKrFSDoEs3wI2DcKegej5GnODWc/T80WFaJhcLhRnDgQhfHUfNmqq25t2zx9p
	AV2L6hXq2Qo9Rnx6544CwXvvzX2tYoGkQETap2CoJ
X-Gm-Gg: AY/fxX4pLsd60H1rJVHJGml3Zb3iulpPKT1vj8UlDVlHYO1oenwF5nKq/zkdiftKkBz
	u4ML6IQmjwYiCoDxZkyeY/HfsAhOGv7H+YX/wwxOjMAVPWmscf1RgS163MPQzwfVVguDTi0z4/8
	E8W1JsNFlWKih18LM3q+II4REzRVrpIyZjg4YBgzlintaFQdMnZaTd5fFBYUhqFynruDzeTsvfk
	w93W5Mm6jRGqCaQQg4YBX2TC6nMvjNk/ODe3BzQqoJParJGdQ4ltd31msbqQY12sjngxh8hkIB+
	3z9ldMYl7h9+RlI+UwBQL/xN8lC5
X-Received: by 2002:a05:622a:178b:b0:4f4:bb86:504f with SMTP id
 d75a77b69052e-50118440b8cmr1789941cf.16.1767989144843; Fri, 09 Jan 2026
 12:05:44 -0800 (PST)
MIME-Version: 1.0
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
 <202601071226.8DF7C63@keescook> <btracv3snpi6l4b5upqvag6qz3j4d2k7l7qgzj665ft5m7bn22@m3y73eir2tnt>
 <CANP3RGfLXptZp6widUEyvVzicAB=dwcSx3k7MLtQozhO0NuxZw@mail.gmail.com>
 <CANP3RGeaEQipgRvk2FedpN54Rrq=fKdLs3PN4_+DThpeqQmTXA@mail.gmail.com>
 <CANP3RGcNFgLSgKYPjmro2s1Es04Pnhf+4wHpnSwRX4M8bLDW9g@mail.gmail.com> <aWFKEDwwihxGIbQA@wieczorr-mobl1.localdomain>
In-Reply-To: <aWFKEDwwihxGIbQA@wieczorr-mobl1.localdomain>
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date: Fri, 9 Jan 2026 21:05:32 +0100
X-Gm-Features: AZwV_QhLJQSwWan9rfokapXwPD_hH4leOJZCxSTMQjFkB3XO4UgPvfMA1zeQaVc
Message-ID: <CANP3RGeWLMQEMnC03pUr8=1+e27vma1ggiWGWcpX+PcZ=SsxUg@mail.gmail.com>
Subject: Re: KASAN vs realloc
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Kees Cook <kees@kernel.org>, joonki.min@samsung-slsi.corp-partner.google.com, 
	Andrew Morton <akpm@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Danilo Krummrich <dakr@kernel.org>, jiayuan.chen@linux.dev, 
	syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, 
	Kernel hackers <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 259788000E
X-Rspam-User: 
X-Stat-Signature: i8ooeg6duys677dw9e7ofs87nkctbrbm
X-HE-Tag: 1767989146-542750
X-HE-Meta: U2FsdGVkX1/vb1OXgR5Heccv0Wsl7LYNdAnfB+OfL1a6DgkEKPIe8OEENNvC29SQTM/++51tbi0mbbMJLMX4dtnvU0IrfUaR8V9YG6M5y4v6COL+KwkXU8tUCzvayGbGu7sqa0SuXnvNpVkpRatsG6EAj0DJuAtLN+0jlWdcNlczb+f55GGWMLv0vIHnWfW38EjQ92yoci8y+6alONd7RZFlgI8oHHwLPdn648qAGtBNpTpzs3Qp3Gl49gQ/67r/jO7ct/IQheM55+9zqtCrPq5wzjnLMVJs6vYjHhwyhA5BKG0NWVVDSvtZGpvBX+lXx2NjRiNJQAObD47vocEK78Wpn2oMOSIveTLIyEL3wrVrkbNABlxCYoWhM9pWuOS0ghQHZg3lEXfH1rROTnzCaV25fMlALKyMOP8OS/gJsm6HHhPerqvUKQEUey1bcsxucaz5BwkYM8rK1qBSJvDlQftZMt064Q1Cam1lcVkc5I6SOnNt8bdRX24kEpJ63XCo8rmbjoa0PRGvj2lkwtD0k9T9h2ecJ4lbkiGXXB7E/tKTVTj86CK3vw76wS5lDBqSQgmjGEMcZIKi1TVIgva2mj99yqBHpPBbLFwKxnUOzSRfYrS/J1RxXoHl712QEmzoOF/GetMEf2gwA7RNC7yybIpt2USmAjpbLQAGHPUyu3KW6X+2f5/jivm2k71cLImtaBtnHpeAKbYHEeCKaLLQ4/3WCTMIMcifIpsp3HsAd36/GsXMnkleTMaMkPlYWoNwWOBMb6JzHnuAL8Trm8U5PWSGtmGTKbqORnPDftZzqAa+9eOen7nm11MHH9lIgSlbmCb+cUXKzAvqw3ZDzIUKMjlT4yG0rH5sJouqnIWo2lnzdjW93CA6/4LxyJYlngZkbnLKK7BZlm4kx23j9N+EeZXxykx6m7lknWPShHSbnSWbw8s2Ir/KMRHPTvivL4YwW5hTIaM1bJPCB71OUdo
 PiNs6Y6m
 JMMIq7Y01Pyy+xs2gwQFp1MHs88DgJ3VEgl0Tgq38TC84w55nPgaEzRMHDTlT6dFyzkUqQM1Tn7c8inKT3apylWjX686KUdiUjtQIIV8yJgDttRDt98O2WNZTQSjg6XKKzAfbEXInROfUTbb8eZSswFhXIHSQlaJdKihtIEalFCzd7d/ivJ1X90RJ5J0WuoYBaLCfHMG+znjW6ADfXTJJ2VZ/9Yy2KqLxA/IgruMxUa6ShX25FMW3NgcJfvnserRaDJp4RZ8XOKFKaQHepvxt5pjrslhqHv4koPGFgV2ZTofHR60gVbuoUkl9uWoWfengzfALGqBoe0IX+QbWmpDC0mXu3o7iA7pC4mcjqZQUDiVaJyw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 9, 2026 at 7:55=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> Okay, so as I understand it, the issue is centered around adding a size t=
o the
> pointer - because in that case it can be unaligned and it can trigger war=
nings.
>
> So what do you think about changing these two:
>
>                 kasan_poison_vmalloc(p + size, old_size - size);
>                 kasan_unpoison_vmalloc(p + old_size, size - old_size,
>
> into something along these lines:
>
>                 kasan_poison_vmalloc(round_up(p + size, KASAN_GRANULE_SIZ=
E), old_size - size);
>                 kasan_unpoison_vmalloc(p + round_down(old_size, KASAN_GRA=
NULE_SIZE), size - old_size,
>
> From what I've read in the code the second argument should be rounded_up(=
) at
> some point anyway. In the shrinking case we don't want to poison the last
> granule of the new reallocated memory chunk so we round_up(size). And in =
the
> enlarging case it would be just as correct to give up on adding anything =
to the
> 'p' pointer - but that'd be inefficient since we don't need to KASAN-touc=
h this
> memory chunk - so we round_down the lower boundry to get all of the new s=
pace in
> KASAN aligned chunks.
>
> Did I get it correctly? Or is there some flaw in the logic above?

I think:
  kasan_poison_vmalloc(round_up(p + size, KASAN_GRANULE_SIZE), old_size - s=
ize);
since you round up argument 1, you need to lower argument 2 to match.
Otherwise it can cover an extra granule.

Consider p =3D granule (16-byte) aligned, size =3D 1, old_size =3D 31

Previously (old_size) we had 2 granules (1 byte short), now (size) we
have exactly one (very short one), so we should poison just the 2nd
granule.

This means we need to call poison(p + 16, 16);

--

Perhaps you need to just do something like:
  size_up =3D round_up(size, GRANULE)
  kasan_poison_vmalloc(p + size_up, old_size - size_up);

this is assuming p is GRANULE aligned.

likely the 2nd argument needs to be rounded up or down.
Possibly one way for poison and the other for unpoison?

You can only poison a granule that is fully covered.  So you need to
round up the start and round down the length.
You need to unpoison even partial granules, so you need to round down
the start and round up the length.

But really you're not rounding lengths, you're rounding the start and
end offsets, and then calculating length as end offset - start offset.

Note though, that I'm not certain.  Perhaps the tail 'fraction' of
granule at the end can actually always be poisoned safely, since no
other alloc could live there anyway.

Maybe this entire logic just needs to round size/old_size up to a
granule size much earlier??

>
> --
> Kind regards
> Maciej Wiecz=C3=B3r-Retman
>
> On 2026-01-07 at 22:55:21 +0100, Maciej =C5=BBenczykowski wrote:
> >> WARNING: Actually I'm not sure if this is the *right* stack trace.
> >> This might be on a bare 6.18 without the latest extra 4 patches.
> >> I'm not finding a more recent stack trace.
> >
> >Found comments from Samsung dev:
> >
> >But another panic came after those fixes [ie. 4 patches] applied.
> >struct bpf_insn_aux_data is 88byte, so panic on warn set when old_size
> >ends with 0x8.
> >It seems like vrealloc cannot handle that case.
> >
> >  84.536021] [4:     netbpfload:  771] ------------[ cut here ]---------=
---
> >[   84.536196] [4:     netbpfload:  771] WARNING: CPU: 4 PID: 771 at
> >mm/kasan/shadow.c:174 __kasan_unpoison_vmalloc+0x94/0xa0
> >....
> >[   84.773445] [4:     netbpfload:  771] CPU: 4 UID: 0 PID: 771 Comm:
> >netbpfload Tainted: G           OE
> >6.18.1-android17-0-g41be44edb8d5-4k #1 PREEMPT
> >70442b615e7d1d560808f482eb5d71810120225e
> >[   84.789323] [4:     netbpfload:  771] Tainted: [O]=3DOOT_MODULE,
> >[E]=3DUNSIGNED_MODULE
> >[   84.795311] [4:     netbpfload:  771] Hardware name: Samsung xxxx
> >[   84.802519] [4:     netbpfload:  771] pstate: 03402005 (nzcv daif
> >+PAN -UAO +TCO +DIT -SSBS BTYPE=3D--)
> >[   84.810152] [4:     netbpfload:  771] pc : __kasan_unpoison_vmalloc+0=
x94/0xa0
> >[   84.815708] [4:     netbpfload:  771] lr : __kasan_unpoison_vmalloc+0=
x24/0xa0
> >[   84.821264] [4:     netbpfload:  771] sp : ffffffc0a97e77a0
> >[   84.825256] [4:     netbpfload:  771] x29: ffffffc0a97e77a0 x28:
> >3bffff8837198670 x27: 0000000000008000
> >[   84.833069] [4:     netbpfload:  771] x26: 41ffff8837ef8e00 x25:
> >ffffffffffffffa8 x24: 00000000000071c8
> >[   84.840880] [4:     netbpfload:  771] x23: 0000000000000001 x22:
> >00000000ffffffff x21: 000000000000000e
> >[   84.848694] [4:     netbpfload:  771] x20: 0000000000000058 x19:
> >c3ffffc0a8f271c8 x18: ffffffc082f1c100
> >[   84.856504] [4:     netbpfload:  771] x17: 000000003688d116 x16:
> >000000003688d116 x15: ffffff8837efff80
> >[   84.864317] [4:     netbpfload:  771] x14: 0000000000000180 x13:
> >0000000000000000 x12: e6ffff8837eff700
> >[   84.872129] [4:     netbpfload:  771] x11: 0000000000000041 x10:
> >0000000000000000 x9 : fffffffebf800000
> >[   84.879941] [4:     netbpfload:  771] x8 : ffffffc0a8f271c8 x7 :
> >0000000000000000 x6 : ffffffc0805bef3c
> >[   84.887754] [4:     netbpfload:  771] x5 : 0000000000000000 x4 :
> >0000000000000000 x3 : ffffffc080234b6c
> >[   84.895566] [4:     netbpfload:  771] x2 : 000000000000000e x1 :
> >0000000000000058 x0 : 0000000000000001
> >[   84.903377] [4:     netbpfload:  771] Call trace:
> >[   84.906502] [4:     netbpfload:  771]  __kasan_unpoison_vmalloc+0x94/=
0xa0 (P)
> >[   84.912058] [4:     netbpfload:  771]  vrealloc_node_align_noprof+0xd=
c/0x2e4
> >[   84.917525] [4:     netbpfload:  771]  bpf_patch_insn_data+0xb0/0x378
> >[   84.922384] [4:     netbpfload:  771]  bpf_check+0x25a4/0x8ef0
> >[   84.926638] [4:     netbpfload:  771]  bpf_prog_load+0x8dc/0x990
> >[   84.931065] [4:     netbpfload:  771]  __sys_bpf+0x340/0x524
> >
> >[   79.334574][  T827] bpf_patch_insn_data: insn_aux_data size realloc
> >at abffffc08ef41000 to 330
> >[   79.334919][  T827] bpf_patch_insn_data: insn_aux_data at 55ffffc0a9c=
00000
> >
> >[   79.335151][  T827] bpf_patch_insn_data: insn_aux_data size realloc
> >at 55ffffc0a9c00000 to 331
> >[   79.336331][  T827] vrealloc_node_align_noprof: p=3D55ffffc0a9c00000
> >old_size=3D7170
> >[   79.343898][  T827] vrealloc_node_align_noprof: size=3D71c8 alloced_s=
ize=3D8000
> >[   79.350782][  T827] bpf_patch_insn_data: insn_aux_data at 55ffffc0a9c=
00000
> >
> >[   79.357591][  T827] bpf_patch_insn_data: insn_aux_data size realloc
> >at 55ffffc0a9c00000 to 332
> >[   79.366174][  T827] vrealloc_node_align_noprof: p=3D55ffffc0a9c00000
> >old_size=3D71c8
> >[   79.373588][  T827] vrealloc_node_align_noprof: size=3D7220 alloced_s=
ize=3D8000
> >[   79.380485][  T827] kasan_unpoison: after kasan_reset_tag
> >addr=3Dffffffc0a9c071c8(granule mask=3Df)
> >
> >I added 8 bytes dummy data to avoid "p + old_size" was not ended with
> >8, it booted well.
> >
> >diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> >index 4c497e839526..f9d3448321e8 100644
> >--- a/include/linux/bpf_verifier.h
> >+++ b/include/linux/bpf_verifier.h
> >@@ -581,6 +581,7 @@ struct bpf_insn_aux_data {
> >        u32 scc;
> >        /* registers alive before this instruction. */
> >        u16 live_regs_before;
> >+       u16 buf[4];     // TEST
> > };
> >
> >maze: Likely if 8 bytes worked then 'u8 buf[7]' would too?
> >
> >it will be 88bytes + 7 bytes =3D 95 bytes(=3D0x5f) which is in the range
> >of granule mask(=3D0xf)
> >
> >I don't think it works, but it works.
>

--
Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google

