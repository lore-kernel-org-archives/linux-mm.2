Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D413FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 04:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1AD76B0005; Mon, 13 Jul 2026 00:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEB666B0088; Mon, 13 Jul 2026 00:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA906B008A; Mon, 13 Jul 2026 00:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 864716B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 00:59:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A9491C4322
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:59:49 +0000 (UTC)
X-FDA: 84982550898.06.86619E8
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2DE6F1C0004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:59:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="p6/THTyW";
	spf=pass (imf21.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783918787;
	b=H7L+eus4krtuzjHvNDpB1wMLaH0o8aEqIOoRFQFNYF1qQ4eAy27hhVyolSMFsLA/g4VWSy
	ZnCNhpvtX+DgPCCshLkwa3kGSmiU3XHGbX8htS0zeQLrNC0o4XgF4xMZ5Euo6iQnnnOwfz
	3lGSS0H6DKVkaR3I1H3SOhsBuVR8Gbc=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="p6/THTyW";
	spf=pass (imf21.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783918787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XFuNRut7vlpifKdq/gCKY+rZGjMz9I4gBz4L78ICh/E=;
	b=lBmF8kV71KUhoIryJQzSRN9uYO/+XHUKPPl6TX9G5nQCtq2+v2jgdxST/+NQQnpDxUEkZ+
	HjaCJ3lnZ8MW1huOFlDPRFih0HY2cE8RRht846pkVRM1m/wv+ola0y4FPKqcLt13BrfNLs
	+5SWtBr4mc8zFsA3ur2uEUjsToS55tU=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c1630cc8d43so110508966b.1
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 21:59:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783918786; cv=none;
        d=google.com; s=arc-20260327;
        b=IY35bh+ZrZdHhyyqazC9R0+EZPPnciL9qTUxGrxRmByOfb9Q4OJvpp2ztPGAyMQwG3
         tavCYGv+tRwKy/sp7UUa0ZptQqY1yJEv/qzkv0DTy6NOsoJtSbiU1np5V5lIuIISNJFr
         CzEfFjcJlTLl6T0uvQEOYuR3EvJ/1odat8lovRgKchWxKdxi49GCn2Y5wNOux0CnwucA
         gn3CKHXhEtOmRxT9/VhTTauiSI0AkYebFrz9H6WaKFSG7PYNCDS0QSOBdhfkrE2GLe/7
         /KmXIR/nBzq2VEgTU215JVUtDulW+HLUwHVl6Okc4tYbBoWRHkJ3F8YLEajyFvKjjGOU
         8i5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XFuNRut7vlpifKdq/gCKY+rZGjMz9I4gBz4L78ICh/E=;
        fh=BtMIm5bDPrLzRyXJdYX4/9GrqiOkzeAHbXyGzy+AtQU=;
        b=UjZg2FlSnK1eAePN/HL0v+JRkhl9AExSVbiX0fWqUBGGQL5qKVyQ5tlVZZfuQy9zj1
         79f3482gpNg1lnugr0IEUriin1xBSKpnmD0xgWhDcMrZJ1FAyEeDqvWPzKgBxg4THE5A
         oUgPnOt6mv5wirsaX0hv3c5lvPcXnYl277SbiN6sLGmMMlH69jStWYOCXI0ZgWHAk9ec
         lHHKo2cEJuPZqDMaWeOH7oP6uNBqk7UpBLTjVH3vd3MtVZeEcDlQMCz3tYHLOiwzHTzD
         55qQmWgxJDUMYc6Rg9EvLBfMi13YKt1TCNxTRLymuOr1zW4xjYrS4H4e8oL+6jUFJ6j3
         sX8Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783918786; x=1784523586; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XFuNRut7vlpifKdq/gCKY+rZGjMz9I4gBz4L78ICh/E=;
        b=p6/THTyWGDbBvzR0yFCUt6GXg0aUow1mwd6QfTi9TgctI/oq3cixE8/8EftN3EMrEI
         Yr5USMYPlUBQ+3HTIaWsMZsRvj1+0lezrkmwfVi59i47eezBwJf5FXkh84VtaeQJ/Y5h
         BUvm3JxsS4hpZbxSM0vxpYdzfNZq+UIkbcedNhDelctDYr43ysEtMkfaAFoPdb2BjlH+
         a68JqJU22qum0sIFtdckngezbDFnCY7BpO9yjtqoHINqpi92DsvcdoMhZUdIuMRTQ6Mg
         qrbyibu05S9OTmAn37UyyqKmxZmhhvtTVf4idVscwVzNMtHEpiTQqrJ27S21K56oL9Z1
         S4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783918786; x=1784523586;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XFuNRut7vlpifKdq/gCKY+rZGjMz9I4gBz4L78ICh/E=;
        b=dVH+rT9kFuAIp5nx7bUO9guT7OxFQuJ09TerKDH6Tf2oN8sqg0BNMOjOEUkzoa8RbE
         /okkVVKaTPLLvEBo9kLdcXcPcW+1ZhlLj3OtMHXh2e3h5wwFgaIIljvpRXW10EoeJIhf
         NIwUVUx/F4MFe7yjnaUBdtJHFpeCK10UaJr1RGGyySXS7bBihqa8D5JsQWzpLdTHdYDq
         ThSfhJ+nE9s2g3aFxZywm2YihyMNAHafo7nFSnrhIO3EfDl/iQG8jG/QScbvz+0MMWeo
         ZQSGN9KOQsQoOLY35avlUYHSFkGzFhOvOcxOK7/jmeRfqazCpszqKFdwpO99FCy4IIPZ
         ND2A==
X-Forwarded-Encrypted: i=1; AHgh+RrDFsx0WZp/qx84/c4YAiO7uAoXaMosa8FEwYHfQ1Sqo/o3RGxwS62LMgUAmJ1BnnQRf/y+AglOzw==@kvack.org
X-Gm-Message-State: AOJu0YyVtEzQaz7scRBZtL6CGqvo9bHd9Jhi2e4MgM52PRa8NnZWiZfh
	pbrrSOqSWbApw0EAvMK7dgBYzCzwyzDQi1AlCWo+T6llwFwWJsevl275SlyaHxqsSzw6mGWEePn
	PS+fbwANAa0GU1eYwacqItN2My6Tc/XAF4ICsQPuj
X-Gm-Gg: AfdE7cnzz9ly8swASWjC8y0Abj4nUn16R97bhnaudP+PwRXZmEEabjfJYlua6/SvG+g
	umtJLDkuuhjCXYUHZ3Zw/MDbaYopSL8qxXdGDov798hwZom9jMKoB76ZZEdsMcq3MJ7BaejSwQ+
	gP4oTHpNYwDisOoV32WoxcT6hsM5GV7D10CzsZwju2OZXY/4lhszW+37ObqeGkTRtAXEznIwwhA
	wAjpCExIuE5LSI5X3gDOpR8yujl8BVHfV+YThgKpFOUTXAst6BOCyVUjZjojBRcL6k3+wGqXnfX
	vRWTFK61Ws7f3ok3ZJRqkfcr5Q9Os44kjccyIQ==
X-Received: by 2002:a17:907:7212:b0:c12:6c2e:ad2 with SMTP id
 a640c23a62f3a-c161f58f14bmr326089266b.57.1783918785309; Sun, 12 Jul 2026
 21:59:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com> <3B2B37B5-16DE-4DB0-8A78-4CB8636C1A86@linux.dev>
In-Reply-To: <3B2B37B5-16DE-4DB0-8A78-4CB8636C1A86@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Sun, 12 Jul 2026 21:59:07 -0700
X-Gm-Features: AVVi8CcLGq0YSly3OF5m8P18-3XA_YkiDDB6TSCPkAkKN6byJ-cGb8WLxIValzM
Message-ID: <CADrL8HXNoRA_cnR7KVPwN6zA32E744OKOfTmDMReoykzR39H8Q@mail.gmail.com>
Subject: Re: [PATCH 00/18] Another attempt at HVO support on arm64
To: Muchun Song <muchun.song@linux.dev>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Oscar Salvador <osalvador@suse.de>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2DE6F1C0004
X-Stat-Signature: qxk549munh9m47ik85w7md6w6a9ik7ud
X-HE-Tag: 1783918787-399955
X-HE-Meta: U2FsdGVkX197BwgzrmcNg27Y1+dz6Y7Mjfbq+VTN53Sv/bElFuUgp2sFMYIeSgU9LLJkKEcYTRF1Zy1FAbDTFZYR9aGcuj9V82/vCS6GFvBeMamvNwQmaXKazhTOIHkfXfA0gxIYmmzZMWdUsCUbJ+s4YFZsnRNzfseK7AqRx6tbihWp9hwO1dxrDB6Ezf3dQT2O4djYKmSvf4P9ObH4uTM+JSVRGOUlIUz4u6QqjsWVglZFGkmnpXeJWqFlKwyc71eydJChzCWdtgO0VFGNGPYYiqHijnG8WPnhk5XJlZfr7zx3nQfrBUCiLwwbY7LkyXH+7G3oTtNx6hy66Y0QShn1NJhfghqweR83gMne9+RjdLO1m87eTGrZ6veZx3rOkuWUZuUkKarufY2tWjmCu7pYlr6szKzTlYl+wuX6+hHX1ifqQZfD+GepEvi+klqoFqCG6L0fz1cVu6de8Z6pRZItds44FU046A7/g0AzY1Ir//dwkE+2+h/BTH1vGhnaAr9vla3KWar+SwSP8sp0Zs5qPSZsNIRS1kp58SNfs0RiPzEARRNMZK1Bu4cG3LmjE2rLM9FRyWxjjWKYd82QUhMV35b6vkjOBBfIgmpnHiBef5TJkJru4hEM/GRcLNGRxyJfuiHM9Ux+MT3FYuAvmLh4dYfLDDx/yPabB3v3uLRjj/1acCg6lC4zCm000vMmSpRA24ch8qg+RZfHKUH7f0hP769gmXg6K8BP+WrL5E+DRaGANAHpVVgmA0Wf/LThOr5z4Vn6nkq+A89cwnKmMtNsPkUN+P5SznuA/P16+a+kN4/lkvikBDoOPWM5vv1ekfFsdvPMwUpP5RPkDE73B542zdnGrUF967dd3Mbeh9NjY85yNrtrokySMvRvVQOjEM8q8UNT/PzpBjvxaaxxtm5OvcF4iJKK5IM2mtv1TYu78XcevLBb+2qza3aT+w+SLD/uOXNLgahJL5bCJkq
 UmIJcRwG
 n+G8QdQcARSNInZzcMqS+TOPOGG15CyvK6KhTl3rv5Cj1j2wMYFNEh+o1LRdu0SUMmn3VqcEL/GhPJz5Xdx2cba5FqTDEPWXNI0D8fP1n191F34aH5a/gWatjYZsW3ZSb4CZ6SboQRmBCORK+Hp+9gX9RcXtQW1Km0iM9SJ043M5/2kpqnav+zGsS8ElSQo42fFgH+rM6VqYUl9qllvVVubMgDTITql/fMgVeFQsTRR2KQzEBuA6HAwor8ZQ3Sh+82hRBDlQ/DgGyKJ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 9, 2026 at 9:59=E2=80=AFPM Muchun Song <muchun.song@linux.dev> =
wrote:
> > On Jul 8, 2026, at 11:11, James Houghton <jthoughton@google.com> wrote:
> >
> > Hi everyone,
> >
> > This patch series uses a trick with the Access Flag on CPUs that suppor=
t
> > hardware update of the AF to update vmemmap page table entries without
> > introducing a time window where CPUs accessing the vmemmap might fault.
>
> Hi James,
>
> I was just looking into the Arm ARM specification regarding the TLB cachi=
ng
> behavior to better understand the "AF trick" used here, and came across a=
 few
> sections that got me a bit confused.
>
> Specifically, Section D8.5.1 [1] states Rule RDWZCQ:
>
>         "Descriptors with AF set to zero can never be cached in a TLB. Fo=
r more
>          information about when translation table entries are permitted t=
o be
>          cached in a TLB, see Translation Lookaside Buffers."
>
> This indeed seems to support the core assumption of the AF trick. However=
, when
> following the reference to Section D8.16 "Translation Lookaside Buffers" =
[2], it
> defines the following rule for permitted caching (RSQBCS):
>
>         "When address translation is enabled, a translation table entry f=
or an
>          in-context translation regime that does not cause a Translation =
fault,
>          an Address size fault, or an Access flag fault is permitted to b=
e cached
>          in a TLB or intermediate TLB caching structure as the result of =
an
>          explicit or speculative access."
>
> This is exactly where my confusion lies, as these two descriptions in the=
 spec
> feel directly contradictory when FEAT_HAF(hardware management of the Acce=
ss flag)
> is enabled.

I don't think it intends to say that "translation table entries with
AF=3D0 may be cached" just because they don't cause Access flag faults.

It is likely that this clause was written before FEAT_HAFDBS/FEAT_HAF
existed. Re-reading it with that in mind makes the meaning clearer:
PTEs with AF=3D1 may be cached if the architecture otherwise allows it.

There is another clause, in D8.5 "Hardware updates of the translation
tables", I_RGQLZ: "If hardware does not update the AF from 0 to 1,
then the descriptor is not permitted to be cached in a TLB." I think
this supports my interpretation.

I am convinced that it is impossible for an implementation not to
conform to Rule R_DWZCQ (PTEs with AF=3D0 cannot be cached) while
supporting HW AF correctly. Let me try to explain why.

For HW AF to function correctly:
 1. Setting AF=3D1 must be done atomically, otherwise hardware could set
a bit in an invalid PTE. (This would break Linux swp_entrys.)
 2. The AF=3D0 translation cannot be used, otherwise we could
potentially drop AF updates.

If an implementation used the translation before coherently setting
AF=3D1 to perform an architectural memory access, then it must choose
either to set AF=3D1 on a PTE that may have since changed (perhaps to an
invalid PTE) or drop the AF update entirely. Either way HW AF is
broken.

Please also see I_GXGPN: "When the translation of an architecturally
executed memory access occurs, the architecture requires that AF is
set to 1."

> On one hand, Section D8.5.1 [1] explicitly uses the word "never" for AF=
=3D0
> descriptors. On the other hand, under FEAT_HAF, an entry with AF=3D0 does=
 not cause
> an Access flag fault anymore, because the hardware is capable of updating=
 the AF
> automatically. This technically makes it eligible for speculative caching=
 under
> Rule RSQBCS in Section D8.16 [2].
>
> My question is: which part of the spec reflects the actual architectural =
intent
> when FEAT_HAF is enabled? Is an entry with AF=3D0 permitted to be specula=
tively
> cached in the TLB by the hardware under FEAT_HAF, or does the "never" in =
RDWZCQ
> still hold absolute priority?
>
> Please let me know if I have misread the specification or missed some ove=
rriding
> constraints here.

Thanks for making me look a little harder into this; it's a good
question. I hope my reply above makes you more comfortable with the AF
trick. I also hope to hear more from the Arm folks as well.

Thanks Muchun!

