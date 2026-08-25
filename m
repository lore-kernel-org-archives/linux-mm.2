Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2C65C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 03:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E8FC6B008C; Mon, 24 Aug 2026 23:28:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472116B0092; Mon, 24 Aug 2026 23:28:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33B1E6B0095; Mon, 24 Aug 2026 23:28:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1D666B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 23:28:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E89BB40304
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 03:28:56 +0000 (UTC)
X-FDA: 85138360272.12.18E74BB
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id F41B0140004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 03:28:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o5zJeNym;
	spf=pass (imf26.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787628535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WoRfjiOpZOtWexROqtJsfc6cj7fXbxuJvS3VpeWJnbY=;
	b=hL4EtJyIZ8zfcDrzt6Jc1ud1XFqo8tH6OXqFwtFEZhQmGyuz7+oqfyplD4L0kg8JqrcSRU
	lEh/bSp7XnquHnQqGFtdaFXshDCk71iuxtkeXb5u0SQ1/IffFT77VpXWpcZem03pMV2D76
	Jsv18LtodlFlTQW+o+iEO75fJK63TLQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787628535;
	b=FEkXWamAguyEJnlXd/U3wi/OK3s+UskH7LXPxJjVY4SomTrfq85vchLAH0gYnJmLs5bzJF
	A1AwlYpyg18ajJddZs0UHnXo5xSf4e2Wmcgxk9Us9GXyVAOOh4MzLvVvUBKVDKphIIW0Xm
	GyKIyTjOgkt5ki18nBuhbxFrpa1657g=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o5zJeNym;
	spf=pass (imf26.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c2055f5a993so477559166b.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:28:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787628533; cv=none;
        d=google.com; s=arc-20260327;
        b=mzImmRUfMSFdIuLv9VjjIYX0UvWIZP5Ri18+OGn2ODETMQJ1eZ7msJb9bO6TRhRGEI
         zQkFzaBu5DDHGP9YvGlA4ppB1egvNgYQC6p1FPNlVDj3IzsneA7j5n+TE1q4TpBCSIvw
         TciTuv88SbTNwDPbtcqrOU9ALdP2IBPfvivLg9wFBGWdE6kR+5RE/sB/OuPf0KpZLPAi
         hVry1sg4o2JMoDi+9EkftJlRcz1Dj0Hvx4boHRgCOsDxcY+JeuGrtOV1pFuJlXay0RuE
         nBJmbMZiUZkZCRxP69WxJRetJjmTe3yk4LGj71Z9I15Xg3awkWN9lu1xM8EQ8ze+VE24
         oDMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WoRfjiOpZOtWexROqtJsfc6cj7fXbxuJvS3VpeWJnbY=;
        fh=0wR0EvCgqdQAz0uLjpFhfEOeKu04T48/wLDj09ORWX4=;
        b=RtOwP3/fmcNlPGdBV0Uilu0I05/V+HPgwqEqYQoWVI09hyiLFBGuIxnerP8cfQbYoI
         RrCBEsw2TbxgsKGXY2XXqCR7/EH538cpLO2uB5YKWe8Ik6a9SncdrBowWdemulBuZRsz
         D+qMov8TiMnHJhPcC8wBNfMto7vLOplarWV4Y3dhxHeoTVdLDQ4f3i8jUM94/bjnp14F
         X8yFlByFq+HdrRoQw5aBGg7ghvCGuVZ6LfYfmJwjPesGNudTffa/Qd/Ms6M3/aWRiSLS
         iutgkI0KkTIXIN4Mt++KQulGlTToTXNLUZ75tS3bhX29pe2ekd9ujkZNH6mSWcQSJyWb
         K1iw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787628533; x=1788233333; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WoRfjiOpZOtWexROqtJsfc6cj7fXbxuJvS3VpeWJnbY=;
        b=o5zJeNymaqB2x0LFJDbWGtrQ2Lnq+9gbm1MRHn+qnUnZ1qrSihdq98TLBcG8EtBTyl
         +KqyBuHmZuZPUy9RI1ahmhhw1cQR4VOA8IIw45GnCKRV/6lOodSzanOb5pNzd3HzUgcV
         vmDOcdocEMGdx22hRpA9caLBMt2FDwPhbx1DLN3Rx7sTXiQAhfAQNhc4lzIvE2dAb1zV
         trmWQ+IT21UxT8UxTDC5tZWYr9iPMOapbI2JTqY5aMOqh//xbLF/shgve6g60J0AuR8k
         gkY+KrUsBCK4q3LbNUqgFpWj0dr5N01s2Y/51tgtMKHCINtDwBpKxNEhwKY6sa/M0OoQ
         7Dfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787628533; x=1788233333;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WoRfjiOpZOtWexROqtJsfc6cj7fXbxuJvS3VpeWJnbY=;
        b=Hww/b2D0mavlcI/COx5grKv4hH0jlPugpxNRHXobJUS04ZYiC+IRToo9uLdN1ZJMVF
         yO+jHcokBSdetM29OKXBP1U/7LQFVrVYcbvTguC0X8U9mnCObjBoKK4CeDL7gFeMd1hc
         Ns1lM5NSbcllwIWNOYq5cC97xC32lFraZdix2xM6pizhlBzauQ/YzkhYsOtZGo63Rxjk
         00iO14x+ZzqA6p/uBX0LgI9cvVuDHMKkXn7if4j9OOpvuoxdYq/Yh6GQyYc0Q/7Y8BD+
         mqA+ObL/gV14QtO1hmob1KGrzIStKzt9zSSDuC7dQMjV0S1UbBUvWuTOryVTJ8o8w8g0
         Pt2A==
X-Forwarded-Encrypted: i=1; AHgh+RqPw09WdlCeCYjtxO5NXXX3SIInhxyFnhz46xOm8Z6aMQNg3GnPgEK3m9E1tlSKA3SDqGkDSM6DHg==@kvack.org
X-Gm-Message-State: AFuF++nGLOisZEHFz3tSMhrVXzoFgInZwykFeRznwMpPrpq5jWCRWsJ8
	9OxiywRZf0bAbCudGkCKxPkSjVTJw2xv3bs726kZdPLNQbSdlGL4iCDktOD1tvNjQG+oYQh1Pje
	OtZuT7pRfKa2PLpbwBopkORILGNAmDjYh0Wqhvbtc
X-Gm-Gg: AR+sD11wD/QSZ+sfVfcsruLbHIvx7IL4LkgHij2GAP8pg/Y55ccqpAjexZHf/aYyiqJ
	6qdESp5CFDl0du2QDpLi2st8qxl5daiPldNaRD0wCaoK7mpKuydmouyFcejNCCQtzMHwfmLBWkj
	V9ng5ZyXD3ldruS7Ii9FXc9kXjhTAwoeGFJmrI1J2kWBWw4hJOaihatTgYzgZrxZ9RIQbkvGukZ
	9sFbk5IEBilVIDZEe7utQTzOD7AMAfRXj7lLFdvIIPPr85moV2G2ooAc4ib+3Z9GmiIoKHaoTvl
	smOrz5EZC7UAlRlX7cQ2wHLC6M1vqkFQenSxLfmbUm+9DsFjO1wpbn4UR+c5C5xnOHDrMWz5m6Y
	sZjCP7PbHbywmEk4PHdK6xhPlmo2IFi50OBZg/nX1JMkJ8rXfesMQ6uEMmTP+fA==
X-Received: by 2002:a17:907:94c9:b0:c1c:2173:d412 with SMTP id
 a640c23a62f3a-c24e5c8bfe3mr296347466b.1.1787628532747; Mon, 24 Aug 2026
 20:28:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com> <aoNGGKYZrOlaJ4mH@arm.com>
In-Reply-To: <aoNGGKYZrOlaJ4mH@arm.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 24 Aug 2026 20:28:15 -0700
X-Gm-Features: AcwNN1XpopclqRmS1SSj7gX5mIcn4wa7id5EaCll1JNV_pEtgQwJbOqOj16l3lE
Message-ID: <CADrL8HVnUY7vs2STH4ENSp0CUWJuPevYSdMG_CNsuUrx5m_P+w@mail.gmail.com>
Subject: Re: [PATCH 00/18] Another attempt at HVO support on arm64
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
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
X-Stat-Signature: 9ksn7bj15gjysdmfwkdposbua7jhrb3k
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F41B0140004
X-HE-Tag: 1787628534-405577
X-HE-Meta: U2FsdGVkX18fPPu7vJmIkF7NI9VVrGcECvef04ZWDR0gGhQsdNTJ3aD4blBTIYdh3kwVr6sxDmorcyuw1E/46PyNg9snBJgorW6LLEKpERIqe+gIvHb24tr4VCV/jjWab2P4hRcQXvPTpyDMGe4EXoEWKbbYdCcc57WyFgInzEzX+n58+b3wleFro54WlFkRMGVvFernADviJDR34PQIrYIk8lTp+3lcScXeNM8KiaYI+gRHaqTSLV7qIo+NYkbFMenVfq9eVD58biUHNgjjUvN2+vSO9yTIWEBrQbBs8HOz7CVzNDYZdQgwrlI1UKXm/eEUvX+NtqCwTj+kMXVDXlrXWSIBrKDOTT5wH14Agd2YF2sSmTA+9UzYo2ayFftkKJWonh0lHmBsRcSOiltwo5neEzv+BLAPC2KAL+XOHdh/haiMuEs+xjeIKQhhxwfwFEynpv3nkCUm6XYgYdvSPNlZBfDOTJp6w5RtBXMWqdWZwbVSu5lq1hbykPVHxI3pFFUXeZe8bsuaTu1BxtuB/qe6axcXNpxVEBuIgBKwJsJId70y5SHw0AI3L6ULVi3j1PZwYuh3Smez2eELeWm/EUjdH6ltUOZrc3+WoVKlmBH8GWKJLbq1QY9wqBPdqo/EOxZArmPgJ/PQQEPTmeIdMKwaMqrv78OlRXBGrNYnjkzPN+zQaxUWL1lehvTmEJQEHn9VDm4SkDwnRmWF1p2WK5Eg0NuAw/Tn3ExkAHJRjKyV5mtjNyRnB0OTSR2yJ1ISw67Ilaea22Ii03ZTpDXTt/sR4Gcl5dOykzmAI799uHRQUM7QMxHJid2fEnVSV5mJS3UHTnKvGyFqQHHFo4OCb14pojGi6GDSatoT198+pc/UP6SfYaQk+DJyw3frpR6LkG/abNuFXG3qK1BcsNkBFkWNcH8Iz+6NJLRKlgv5RGlwjmF3duBOzt1FAenteJbz6vHePqBmGwce6QwLFFh
 1KMqnd3V
 0W3ISyFay9/nawcbrRkoNfq7gv5swWly+QLBZbdwKD5MT83r9rnPtOgPmDLYZRYoS07W6mzIw3lhk0WPFLY3V3kknNWc0AZVU6zOLePcSSFHYertcJ9iW1ts4wG2EpZZ4a6FH8dsP/5uZ8R5zGmM9HT+UJt+sCHMNG+pLOD1qnKyMlfzmGCGg0cnGFrJRKxyoxY42qgfmqn8I3FA6f0T+p0lkempVdICwfL3k0sK5pPqNyiFpp6X+ZTXQbYImXfD9mzTvBSEPigEWrbrg2DrTnAwadjiRAejWHrKBFSWQLE8SK1RrQiHQ4DdJvGGW/fJb1u/0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 10:34=E2=80=AFAM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> Hi James,

Hi Catalin, thanks for your feedback on this series!

> On Wed, Jul 08, 2026 at 03:11:10AM +0000, James Houghton wrote:
> > The following Herd litmus test demonstrates the PTE update routine:
> >
> >   AArch64 TTDFaultlessUpdate
> >   Variant=3Dvmsa
> >   TTHM=3DHA
> >   {
> >    uint64_t x=3D1;
> >    uint64_t y=3D2;
> >    [PTE(x)]=3D(oa:PA(x), af:1);
> >    0:X0=3DPTE(x); 1:X0=3DPTE(x);
> >    0:X1=3Dx; 1:X1=3Dx;
> >    pteval_t 0:X2=3D(oa:PA(x), af:0);
> >    pteval_t 0:X3=3D(oa:PA(y), af:1);
> >   }
> >    P0                | P1             ;
> >    LDR X4,[X0]       | L0:            ;
> >    MOV X5,X4         | LDR X2,[X1]    ;
> >    CAS X4,X2,[X0]    |                ;
> >    DSB ISHST         |                ;
> >    LSR X9,X1,#12     |                ;
> >    TLBI VAALE1IS,X9  |                ;
> >    DSB ISH           |                ;
> >    ISB               |                ;
> >    CAS X2,X3,[X0]    |                ;
> >   exists
> >     0:X5=3D0:X4 /\ (* First CAS must succeed *)
> >     (fault(P1:L0) \/ ~(1:X2=3D2 \/ 1:X2=3D1))
> >
> >   (* This test should not violate BBM requirements. *)
>
> We definitely need a clear statement in the Arm ARM around this. As
> already raised in this thread, we can assume that AF=3D0 entries won't be
> cached in TLB but there's more to the BBM rules. For the dirty bit, we
> have R_SGJBL, we might need something similar for AF in addition to the
> BBM rules update. In theory, I think your approach works but we need the
> memory model experts confirmation and the Arm ARM updated.

I agree; it would be nice if the BBM rules were more explicit about
PTEs with AF=3D0.

The question I find myself wanting an answer to is: "is there ever a
case where a TLBI must be issued for a guaranteed-uncached TTD before
it can be modified?"

I'm pretty convinced that, for Page->Page, there are no such cases
(but I can't really say for sure).

For Block->Table, it's certainly more plausible for there to be such
cases, like your comment on patch 12[1].

[1] https://lore.kernel.org/linux-mm/aoSJcAFMNJ1nPl2H@arm.com/

> I'm not entirely clear what the above litmus test guarantees other than
> not giving a warning. On P1, X2 can be either 1 or 2, otherwise fault
> but that won't happen with HA. I'd rather have something in the 'exists'
> rule explicitly (like a TLB conflict abort; not supported AFAIK but
> maybe that's what fault(P1) was meant to show?).

I should have clarified that the exists clause in this case should
always be negative. So I read it is:

"It should never be the case that: the CAS succeeds AND (P1 takes a
fault OR P1 reads a bogus value)."

It's really useful for HVO not to introduce a window where Linux (e.g.
get_page_unless_zero() callers) might take a fault on the vmemmap;
this is what the fault(P1) part of the clause is conveying (even if it
is obvious). This is actually the main point of the test: to verify we
don't take a fault. The bogus value part is just kind of a sanity
check.

I don't think fault() captures TLB conflict aborts. The lack of a BBM
warning is supposed to indicate that the litmus test has followed BBM
rules properly =3D> TLB conflict aborts should not occur.

>
> In addition to the above test, I wonder whether we could have P1 do two
> consecutive reads from [X1] and check the read values. Maybe go through
> a third mapping, OA(z) with AF=3D0 after the TLBI or just start with AF=
=3D0
> on x. Basically any other tests for coherency like read-after-read etc.,
> check that the behaviour is preserved through AF=3D0 just like going
> through valid=3D0 with BBM (that's something that should eventually be
> runnable on actual hardware to validate where we won't have a BBM
> warning message).

Changing P1 to:

LDR X2,[X1];
LDR X3,[X1];

and using the exists clause:

0:X5=3D0:X4 /\ (fault(P1:L0) \/ (1:X3=3D1 /\ 1:X2=3D2))

remains always false =3D> P1 never reads in reverse order.

    Test TTDFaultlessUpdateRAR Allowed
    States 3
    0:X4=3D(oa:PA(x)); 0:X5=3D(oa:PA(x)); 1:X2=3D1; 1:X3=3D1;  ~Fault(P1:L0=
);
    0:X4=3D(oa:PA(x)); 0:X5=3D(oa:PA(x)); 1:X2=3D1; 1:X3=3D2;  ~Fault(P1:L0=
);
    0:X4=3D(oa:PA(x)); 0:X5=3D(oa:PA(x)); 1:X2=3D2; 1:X3=3D2;  ~Fault(P1:L0=
);
    No
    Witnesses
    Positive: 0 Negative: 140
    Flag Maintenance-scope-for-DSB-ST-is-deprecated

I've tried to write more interesting tests than this, but I can't get
any of them to run in any reasonable amount of time. (This test with
P1 doing two reads took 2.5 minutes.)

Here's one that I was trying:

  AArch64 TTDFaultlessUpdateRAR2
  Variant=3Dvmsa
  TTHM=3DHA
  {
   uint64_t x=3D0;
   uint64_t y=3D2;
   [PTE(x)]=3D(oa:PA(x), af:0);
   0:X0=3DPTE(x);
   1:X1=3Dx; 2:X1=3Dx;
   2:X2=3D1;
   pteval_t 0:X2=3D(oa:PA(x), af:0);
   pteval_t 0:X3=3D(oa:PA(y), af:0);
   pteval_t 0:X4=3D(oa:PA(x), af:1);
  }
   P0                | P1             | P2             ;
   MOV X6,X2         | LDR X2,[X1]    | STR X2,[X1]    ;
   CAS X2,X3,[X0]    | LDR X3,[X1]    |                ;
   MOV X7,X3         |                |                ;
   CAS X3,X4,[X0]    |                |                ;
                     |                |                ;
                     |                |                ;
  exists
    0:X6=3D0:X2 /\ (* First CAS must succeed *)
    0:X7=3D0:X3 /\ (* Second CAS must succeed *)
    (1:X2=3D2 \/ 1:X3=3D2 \/ (1:X3=3D0 /\ 1:X2=3D1))

Let me know if you have any more specific ideas about tests to try.

Thanks!

