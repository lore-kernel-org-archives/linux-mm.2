Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F5FF99C6E
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 00:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50D616B0163; Fri, 17 Apr 2026 20:18:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E4416B0164; Fri, 17 Apr 2026 20:18:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FAAB6B0165; Fri, 17 Apr 2026 20:18:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2BFC96B0163
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 20:18:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C93AC8AC25
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 00:18:33 +0000 (UTC)
X-FDA: 84669765306.05.2CDAC7A
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id B242914000B
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 00:18:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z8rQB0nO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776471511; a=rsa-sha256;
	cv=pass;
	b=6+LuZEHCSTwCRlENHLd2J54MJpHurSfjmh7YTVJ7tbG8OkU2eMDrzBz/n1Iu848gv632np
	GNwbwzuf4ctmjtDmHb0uJ08Zx+Y+T7zcge9ojULb1J/dXrHrKrMWeRQuyidFqwhk1TKiaP
	5Z3gZDjk81cCwIsGs4MaFUDsZlWiyhM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z8rQB0nO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776471511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0XDOzN8q+VPnuTOqcSuLlrTd3FPVemEoMe4PjjgpVEI=;
	b=FpSjwlxCP0+jXjWhIT8n73kuuriFy8RqtDXsHsrSRT4HHgsalxfHF8jXBbl+ljFT8VGAmo
	ZXE0I1dfQk7dea3oguIDbnzSsg/FJZx21aDHzwr3+biRJy7EFVyyI49MYEzMYdN/U1DuN6
	PrxrbY0yejVKGfd5iF9acM/Ays+wZ9E=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488879dcbc3so41955e9.0
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 17:18:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776471510; cv=none;
        d=google.com; s=arc-20240605;
        b=YpghLudZqRtWBqZX10pkeWQQiHOGnMbU5QMpGY6MMcvi6qDiBfeV2rlO7MrfoM5DjS
         h0xC9v1tiwWIxqJ0U1/vAye0dsVOOarC7aEB5UA8RkORhoW/WpXtXyumYNZDm3feGkhV
         XxcABLkuBzja3hguYGHwearCj7hZ3lz6qvW/8nVbGXWZUIFJUUiOMTGUgu2mzo6fipC6
         04MkXmr9JSFCTtiqGJY/sZDUXgeAi4kI4Df18ucQiv1BWQxpAKWmZy0QA7s4dmUP80Fx
         KZ2ZqJGp17e227y45C6cRql1zZLZgZXDMozL1vKrpeNc/i1pHpAB3DwaZYzEe5NknCLh
         hpbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0XDOzN8q+VPnuTOqcSuLlrTd3FPVemEoMe4PjjgpVEI=;
        fh=DJ8UP0oKyChtPdIbh96KnBwydrce/DvTCZaI3JciP6A=;
        b=BMOsWFpASb7J9L0smxe4ey/Tv9IH7wMMOwwAlD7TfVgFuQVmLHif9wrFajl5mghO/8
         90girCpONyvPt3jJkG394x0baLsutch66KJ2cp1onWQqjiCvrUc0ZVXvEP/qcgJaXX7C
         DoJmuluNhHCe2lhNhrNoUefy+FpN9zHhU6oWGNPi0j/6naob+xalZz6pxh59Yt1coJRV
         +2De1P4tIA9iWViuJ4iuVhTEwBl5EooA1HWcLWZlcedaOwoEwYiygx8vgmuWgK8cAQJi
         9AGiJGA9SbgU2L7Tmpc7Zid8U4041E1icdgWqE+CRx6ENNVpo1EAiSUCqefufmOR9DQl
         sY6g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776471510; x=1777076310; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0XDOzN8q+VPnuTOqcSuLlrTd3FPVemEoMe4PjjgpVEI=;
        b=Z8rQB0nOGlfOIyVz5XgrM+Hhu3QS08ExszlitHpVCd17z0ssCglCC4aT2MKa/c3v7h
         xG9mwqOtL4axWL/oSYZ0Fais8ni2UrO1C3k2M97BCEb9oFrQUVcHpz4Grno/OtnWvVsS
         c+JNsVrgtyrHchnVlwMalEuSixeRu8U1K1lMPGaZBI/dEvMb28xbW99pcNC42OS8mj5+
         26Cod/zG+IdCoLwvJN8EKNoit2x0VHTnaw7FLqx4l9r16nAQgAbCk7X5hSSMls7nYDtu
         LMuJdm7jasG7ZKcPQApWk8HkVdsht+Qs0j7DmIuQweeAul2WILdqLElb6bGBgufqc9rA
         qvnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776471510; x=1777076310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0XDOzN8q+VPnuTOqcSuLlrTd3FPVemEoMe4PjjgpVEI=;
        b=HUg3eX2jZxpK2R0gSUrCS5he8FpHWM0kanfuSCHEPL6D5lTtmNFXBnD2eabr6IE0WY
         QvPWh1mxH+t2GfMfY4ZxukELorhV/2yHCOfBt0vOCTKg2aVlDF85tsK/5chgaDfeJu+2
         jw1ldHdKDagq59z4xYjYBK+eJt8BmuKj9V6I+PLVLHdWnI1kR1kHaYFTc5QK2g2NVYZ5
         aX4h5QyCzOZly2evMw04GBCesLjrC2PWF/kJCn1YoSGKAPTqeUGqSBrg9DCgfJSW93HJ
         WbazQknulpu30zi6pZLLpfYEcYybwOke1w9l7QCmXx9AdCmQJ6VcmIToO9AkZSWpFBku
         bdQw==
X-Forwarded-Encrypted: i=1; AFNElJ/xrzCoszIFCwOWqvrRiU50GhCrDlJGzWwU5CtH/7eq2uVtcsS1ZHlisD8l5E3smDa+A5kAnPy9zA==@kvack.org
X-Gm-Message-State: AOJu0YyF6voMNh6xwx6gNoJFKyuyulhGNN+vO9kj3IPnF4moZ11ag/KC
	e1J7oryuUDUgNphZglVJBL2NoiWL3EzI1RNN+mSZiTHzqNrnYtmkZquZe5ZIHvvoS7NtFh1W5cz
	H8K4CAZnEfpQxHV4EQR8PzV0TlsKA0l7wIXNUs6wn
X-Gm-Gg: AeBDiesoZNlG57pmzQOFoV/HHnqmy82XiQymYlN+K/i43dfiKxazgZV0Mm0RPjvhrh9
	8ZRoHVtQd67fjPMr3zceAZKiTu/6cMLOBPqPIRWr2VafA2GeTi8ayrsRhJbmXXVgc2GXPKL2Tz6
	mhn4U+tm//lMC43tMXyZI+vlrXN66RnjQSjXGnB00YzWXp6jof2AdYokB7+bQzG8jQROlen+fzC
	twbYPfmWYYEmrcWTR4R0GxNfXuQ3A3W9qEycRITnzAeD/HrQA9UfnmZ89h6M7W4KvTwSYj5msBx
	yys4Dje3H8J0Y+vje8l5QSr7cBfVWU+af4r1xwY9vKTVysePIJmjToufJi4=
X-Received: by 2002:a05:600c:6c48:b0:45f:2940:d194 with SMTP id
 5b1f17b1804b1-4890095fca7mr336595e9.2.1776471509536; Fri, 17 Apr 2026
 17:18:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
 <CACw3F51PC0iB6mfbiceQ_Kh242FN8zdXOfTyE5Pa_5+gjTPPGg@mail.gmail.com>
 <aeD6hpM3t0RZm5mW@gmail.com> <CACw3F50WYH8Vmd9EXx9+3yM=FU5-1WBkNffkGucC+wSjL+=wFQ@mail.gmail.com>
 <aeHy3-vQTQYJlGw5@gmail.com>
In-Reply-To: <aeHy3-vQTQYJlGw5@gmail.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 17 Apr 2026 17:18:16 -0700
X-Gm-Features: AQROBzAXHoEqSDp1Bccru5-GgBP-IH2eoR8meZyY6rzDuCQOHdZk9YxChODZKHE
Message-ID: <CACw3F516bGtU3Qs57wV6K4vCu0O9ir0s7LJnduFq2aA=ivAbug@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] mm/memory-failure: add panic option for
 unrecoverable pages
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Stat-Signature: 16bmjekssecc3pkjbnjhzqyuz5bceszs
X-Rspam-User: 
X-Rspamd-Queue-Id: B242914000B
X-HE-Tag: 1776471511-502719
X-HE-Meta: U2FsdGVkX19AF9XHml4/WKNrtC/jNnn7aAUHm6cSUfOdLSboZ46jldlWfJmYMv41rf+qT1I77ZSoDT8Vt5+b4PGOzz9VpuIGsWgfC7lY9UDgzhO+IGWvsITZg1XeGU3KX+pI0LTJ5QCs7yRtqEcdi+bYjNW3jWlj1jIj6UR4z7OKwdKuN2G2wV7jDAQ0uvWALKt4pYYVdVgsIvWKB9faBQOCt4YAlpzjsdKMOa/iQZjfnC1tWW8ecwZnAjeihqd5YfYnzsRPC6DROnD6xXmG7WgGIC6pjDfTI0IzH3CyqIqzeNz8CItHstqcw6sWty/VHIlmED1JQxJejW838MqT8SD6xd1l1F0vQXGVqYJjrk6Qip8nyXdy8Vk8Ojh4NZeOMwjKF0N5cOo2JDlCc8L2x5P/IWMQFQNO2g5WRhczMqgVH4hDhLNzP33sv/y3zs8/l0OZvw1rETehjC4Xr6e1CTo0BhAyDeaRCiuEwBckNoDm51fQ4oEnYKugJzE/7XXgJSbss+iXBmpf3DAXkR6R02ifL2ful8C9qGJ+54mLRkOgMk+j0I/48fGh41eunWS2E3T18Pm8l87Q/RmR67IiKw2OS83sdDDFjUFzHHMVT1I7gHkOQxKOonrkoPGhHSssUydDOEBS8LbXztVITfpezDqJlj8ZY8L/0xeXv3Orfzleu0i8OdUS54tCVSv25cVsLQx3BQzXTSIud+6Da2n1jAqUK317ebEDA8eC8marTMWxrbK4ZvgQXObQhbZC3afrcyWr6PU5p3l8d44eDBb3h2aPP7pFO79EJuf9FMbdllFc414TCG3AHHLzidZaCdVstbCA0HeFtq7pOCLaFeDf3Xz05rL5OAXlU3gMcYusi7UCH5rghJjGOTKJRA++NpBp8LXmFmhNFiwH5OgKS84hGPcEVjHRnBxp/JP00sndkB/czTfdpwWAMMZrj6AN1z68X1iUTvi7tQTG3m5I6mZ
 RDN2GLNg
 Guo7mXSJKT5AqLWgdUnYGescilkiAZzJQgMan2EnCV9vv049JaO1x4ZKKjpr2nXVFpbUHslFCOdFbTMM1g3LF9CJm9sj1L3kS2k45rQWnwtSRyVTDRfJxfIcx4HT66dJ6qhnE1aeqmHH3yxvYsyiMLTP9trGC3TpSKcCdfa6y1inOwa9753TEp6jSNvxbebTn7PvUi09okg5E9cjRywZP53IXtGnXeb1OibnkZcJ0LUdFe3sD+cfn0krz9sdvfgZAnZGYVpnbdlEJ0RNDURH9eVq9Nal/CDvPMT8PCcGh6BNyh5zEtaveIu85M1J69twvpyUnmazr2ugIkDwHXYLPf4jzkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 2:11=E2=80=AFAM Breno Leitao <leitao@debian.org> wr=
ote:
>
> On Thu, Apr 16, 2026 at 09:26:08AM -0700, Jiaqi Yan wrote:
>
> > So we will always get the same stack trace below, right?
> >
> >           panic+0xb4/0xc0
> >           action_result+0x278/0x340
> >           memory_failure+0x152b/0x1c80
> >
> > IIUC, this stack trace itself doesn't provide any useful information
> > about the memory error, right? What exactly can we use from the stack
> > trace? It is just a side-effect that we failed immediately.
>
> We can use it to correlate problems across a fleet of machines. Let me
> share how crash dump analysis works in large datacenters.
>
> There are thousands of crashes a day (to stay on the low ballpark), and
> different services try to correlate and categorize them into a few
> buckets, something like:
>
>         1. New crash =E2=80=94 needs investigation
>         2. Known issue =E2=80=94 fix is being rolled out
>         3. Hardware problem =E2=80=94 do not spend engineering time on it
>
> When a machine crashes at a random code path like d_lookup() 67 seconds
> after the memory error, the automated triage classifies it as a kernel
> bug in VFS/dcache and assigns it to the filesystem team for
> investigation. Engineers spend time chasing a bug that doesn't exist in
> software =E2=80=94 it's a hardware problem.
>
> With the immediate panic at memory_failure(), the stack trace is always
> recognizable and can be automatically classified as category 3 (hardware
> problem). The static stack trace is the feature, not a limitation: it
> gives triage automation a stable signature to match on.
>
> The value isn't in what the stack trace and the panic() tells a human rea=
ding
> one crash =E2=80=94 it's in what it tells automated systems processing th=
ousands of
> them.

Yeah, in this setting, a crash dump with a fixed signature totally makes se=
nse.

>
> > You can still correlate failure with "Memory failure: 0x1: unhandlable
> > page" and keep running until the actual fatal poison consumption takes
> > down the system. Drawback is that these will be cascading events that
> > can be "noisy". What I see is the choice between failing fast versus
> > failing safe.
>
> Correlating the "unhandlable page" log with a later crash is
> theoretically possible but breaks down in practice at scale:
>
> - The crash may happen seconds, minutes, or hours later =E2=80=94 or neve=
r, if
> the page isn't accessed again before a reboot.
>
> - The crash happens on a different CPU, different task, different context
>
> =E2=80=94 there's no breadcrumb linking it back to the memory error.
>
> - Automated triage systems work on stack traces and panic strings, not
> by correlating dmesg lines across time with later crashes.
>
> - The later crash looks completely different depending on the
> architecture. On arm64, you get a "synchronous external abort". On
> x86, it's a machine check exception. On some platforms, it might be a
> generic page fault or a BUG_ON in a subsystem that found inconsistent
> data. There is no single signature to match =E2=80=94 every architecture =
and
> every consumption path produces a different crash, making automated
> correlation essentially impossible.
>
> - Worse, the crash may never happen at all. If the corrupted memory is
> read but the corruption doesn't trigger a fault =E2=80=94 say, a flipped =
bit
> in a permission field, a size, a pointer that still maps to valid
> memory, or a data buffer =E2=80=94 the result is silent data corruption w=
ith
> no crash to correlate against. The system continues operating on wrong
> data with no indication anything went wrong.
>
> Also, I wouldn't call continuing with known-corrupted kernel memory
> "failing safe" =E2=80=94 it's the opposite. The kernel has no mechanism t=
o
> fence off a poisoned slab page or page table from future access.
> Continuing is failing unsafely with a delayed, unpredictable
> consequence.
>
>
> > > Isn't the clean approach way better than the random one?
> >
> > I don't fully agree. In the past upstream has enhanced many kernel mm
> > services (e.g. khugepaged, page migration, dump_user_range()) to
> > recover from memory error in order to improve system availability,
> > given these service or tools can fail safe. Seeing many crashes
> > pointing to a certain in-kernel service at consumption time helped us
> > decide what services we should enhance, and which service we should
> > prioritize. Of course not all kernel code can be recovered from memory
> > error, but that doesn't mean knowing what kernel code often caused
> > crash isn't useful.
>
>
> That's a fair point =E2=80=94 consumption-time crashes have historically =
been
> useful for identifying which kernel services to harden. But I'd argue
> this patch doesn't prevent that analysis, it complements it.
>
> The sysctl defaults to off. Operators who want to observe where poison
> is consumed =E2=80=94 to prioritize which services to enhance =E2=80=94 c=
an leave it
> disabled and get exactly the behavior they have today.
>
> But for operators running large fleets where the priority is fast
> diagnosis and machine replacement rather than kernel hardening research,
> the immediate panic is what they need. They already know the memory is
> bad, they don't need the kernel to keep running to find out which
> subsystem hits it first.
>
> Also, the services you mention =E2=80=94 khugepaged, page migration,
> dump_user_range() =E2=80=94 were enhanced to handle errors in user pages,
> where recovery is possible (kill the process, fail the migration). The
> pages this patch panics on =E2=80=94 reserved pages, unknown page types =
=E2=80=94 are
> kernel memory where _no_ recovery mechanism exists or is likely to exist.

Maybe, but I won't be surprised if one day someone comes up with some idea.

> There's no service to enhance for those; the only options are crash now
> or crash later, given a crucial memory page got lost.
>
> > Anyway, I only have a second opinion on the usefulness of a static
> > stack trace. This fail-fast option is good to have. Thanks!
>
> Thanks for the review! Just to make sure I understand your position corre=
ctly =E2=80=94
> are you saying you'd like changes to the patch, or is this more of a gene=
ral
> observation about the tradeoff?

No change needed. I just hope to get more clarification from you on
the usefulness of the stack track, and I do get it. Thanks!

>
> --breno

