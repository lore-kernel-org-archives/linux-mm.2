Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 121E2C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 11:03:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6ED06B007B; Thu,  6 Aug 2026 07:03:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E46FB6B0088; Thu,  6 Aug 2026 07:03:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5DA06B008A; Thu,  6 Aug 2026 07:03:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A83766B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:03:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29C80A076F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:03:51 +0000 (UTC)
X-FDA: 85070559462.01.769ACA3
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id 965C420006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:03:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XuSMHdQV;
	spf=pass (imf13.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786014229;
	b=a9XOP5wSSDLkbKWXaxlnKU5grI2QUu7ENKX67DPx+ek/ETmWgAb6N2eIfoNP3cS19+s8dV
	sS2c8KO//qaFcnsvndhEK4pQog7copDMEQJhKFSqNHzL6G2gtrWb8c19m5NtaOJiYY2R/i
	E6WQaG0zTJQF5Jr4QPSViojjO3jy9s8=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XuSMHdQV;
	spf=pass (imf13.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786014229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMaEeVh+/U+NbRzoGC8Idgo7QP/ahOzSH8HwXGJHBcU=;
	b=x2whsgHVCgwMm/NMAXnogJv1BecQ5wihhKGBKBZTVizvI07xRyO8IiysaK0cR+jSd4OG/Y
	EAXT5a3D6VEAEys8Zk5t0ohTZ33dcKhBfOWLk7iTP0uAyjCc/QDRJPTtzRVg+bVYHJ6jrK
	nfXbtCyfRP56bDrwlrwQY4uTEoeCP2Y=
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-448b89f700fso1931505fac.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 04:03:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786014227; cv=none;
        d=google.com; s=arc-20260327;
        b=akH507SSyvIxnzVwjAPes92Kpc1MCIbBJUNQbAeBBrXsrQiwdX1zPXECn/CCbl+YKS
         YpBt/mfFA2XEXg8geUScWfE6e3qhgAyyxltviDvPBJ2xTVZgkl76zSpLd+NyA8qhvRjC
         3/EI1ZZ9+0+MgwOudGVADsmQlZyRPkkDockwWGmCg2cA7ClNM11TV3REE8TJ7PEUeYFR
         Gp+z5lnfUWLkxSm7aR+J91hebkKC0jBXsPPhjZkpchlIrx2HdpbHTO5DmCqOPH18NOGZ
         9pwlp3zWjDEzpC0D9+zFiS4/Lf4Ubv8u8RBC1QlcYCg5n0/Bvic/gokE3CHkTenzPvHi
         ILtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kMaEeVh+/U+NbRzoGC8Idgo7QP/ahOzSH8HwXGJHBcU=;
        fh=gOKpPvR2jBcm7jlx/T/Afr59w9amylWPSuXFx2rUABQ=;
        b=dE55Ct4OPOTMn+yb3nLmpC6/pi46aIllCOeZC8z9cCWxDFXvWH0r804twTL/gEe/+X
         uI6o33lraL1Ey63NAsFjqWhYSm+oG2zyGKc9TDqCQaHVyC8MYt+E3BZhTpgPcAs2FIVJ
         P5OCF5NGtchJ74sSAZONrlvgsPSFN8Ic9KMUo6vVbaAyH/yG22LNOG26O0FRHHY4OUPb
         95VskPbTaY4K6cK0lVjy61Q/PJAS4g3wcw7CcJ0ZJQUhrrvYAnYI4KF0mBrGgEQLllPE
         oEZqFxfL2RiutR3tR+5uThFc4prFEvM/2V2sgDnXSxXXmJ3GUCyF+g9Tw6UQAzmD4yMT
         k5lQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1786014227; x=1786619027; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kMaEeVh+/U+NbRzoGC8Idgo7QP/ahOzSH8HwXGJHBcU=;
        b=XuSMHdQVhdHyE8B9gOUVCOlrg3IcfQRo4qUhhNZkCxEV+gk90IKQzLfguK+dMYoefZ
         Q1INp6GVjdxUbpauO5KLMQgEvGwmrUgwhvFlGSB+BHwEzg2/O5v8v0T6SIyK1q0v1dk/
         nO++mtaFR8/UbyHvz0ICLKQRU8KQQUww1Md3IV2Nv/iSFvCuxUqfgDxcA2gX6bYvYStm
         IKNhkXBAToD8lCwIIlJl7uDhgw4WXtGpBuxYwbs7OQWrKCwSJUu2F88KLsX8PcL0qYYR
         CuUotww5Yc3fkvZLbpsvJdlDpqvLE2jyFc+bwa/w/LFd3+7z/G1bjZymDtDGz7lwRDKW
         sw/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786014227; x=1786619027;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kMaEeVh+/U+NbRzoGC8Idgo7QP/ahOzSH8HwXGJHBcU=;
        b=fw9rgAeskX05Y6l1qzt7zkVW/2CfzdR2e98WXx2Ng3HWTnZi9cHIk82paJg9YtCWbW
         keplHspGfHkHFi4GdGv/sY/shE79Wbr+I0jABWTgkTawK9UxukShMIG1nRxL5Hm3CY9W
         CJas7TjkFxd+03U2PP1zMlzKSZv+QheyGVUOs3oNUYSAGOkycENe3NBf63KyRP8jgf5a
         EinUyLhtkVsx9LgEQcnBiAISGE+7WoxuzkSqzhmXfAtgw2PCJYDc8MOHbVnkxGDPYCwK
         PAYC0CrYriVroMDXw7NSnYWQmPldMcPpjEBHRC7rvrXLeproV1gigbR09mBZYfwP7qic
         oYbg==
X-Forwarded-Encrypted: i=1; AHgh+RobMj1nAIxOT/yGSvpqIu132BADJHHmsvM9P4Q6CVZ35mYqsfYXh2OOe3oA20jpI3/RQhDCyEKEjw==@kvack.org
X-Gm-Message-State: AOJu0Yw1rV7LT8HlHSnEfMNI4fKnNeiRPY4kj1HCo0RD2lUOSkx7/p01
	W/W+kInLQTF2RfwV573PXmlhwZpSYgutVf4IeYo4CEe96JT+SBOn341yaT4lZUT9td/1UkHoJl7
	TY4HJgZkIqUx5qR/KmSU6S1ouctJf/1if3NNcCG7FhA==
X-Gm-Gg: AR+sD13T68LGuZKfB9g2HYZUE1sAgZMe2uGmlg3v0a3P46YxxQuveu3/oPcxOx4rkCm
	nb+epzLsv3H9QKAQmdoqdfxkiyh9/h3vX/BtrQXBRPi1K7YZ0VsDkpVgVRztooRX5QWjcdS0RA3
	S95cbsNvDBNbg6tKoilSmagcIUSPZmy1wQ3KPPd8ktHFWr+IoOSdf6M7afH7BwahMXcHKzM5bYO
	NH+vWGuGZuAgJw6IhwM7c9AcnUOD2TZGkGzgP88n7u01ZPC9Ck79fbMzcUwuOPly0QzrSGAvnzJ
	eMtojPcPScKfnt3D8lrXm/lmQUvrLm4wAPU0Crld4MWd/7g=
X-Received: by 2002:a4a:e910:0:b0:6ac:ac32:b5ff with SMTP id
 006d021491bc7-6ae96c1b306mr7392747eaf.2.1786014225348; Thu, 06 Aug 2026
 04:03:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1784201104.git.cuiyunhui@bytedance.com> <138d74aa9863ae8ff445e16a2798d062895b75bc.1784201104.git.cuiyunhui@bytedance.com>
 <anQ2bW3JxraT6PFY@lucifer>
In-Reply-To: <anQ2bW3JxraT6PFY@lucifer>
From: yunhui cui <cuiyunhui@bytedance.com>
Date: Thu, 6 Aug 2026 19:03:33 +0800
X-Gm-Features: AUfX_myo8uemIR_J8tcaFPQk5bQ_19S-a0xl3xjkzuEjy5SWJNGo65WwssSv6nw
Message-ID: <CAEEQ3wk62WBSJb5JcnPJoVSb+JQq3ZcE4CRmqqTvkAO20XFjbg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v2 10/15] mm/gup: add fast-GUP specific
 lockless PTE helpers
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-riscv@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, kasan-dev@googlegroups.com, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 965C420006
X-Stat-Signature: fqxk4aekmx93zft1zjncno4yrq9pgxcz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786014228-785030
X-HE-Meta: U2FsdGVkX19mBVsnoKFX8LJnIMWCbxY+jEE9Dpc5dv0LO9qK9PBDzP8H0cDh8wVW/XshffqYSZPAN5vtEh20DlOJFG4jPeC1ZqG3qDq5IYMpFmRIm0NxiagbLLUmJVAGAUM2HMzAmAbFEHG5bnOzPbCx7Kd7TqFwwefwd8OsWUNJlKrnIP5H0vc3CMRMNudPqpVg9P3MaL7OXza7v5sTkWL7+ZRjfRRqhiF/KNryUDeF9F1PSmEihTF7i6wzywwaEz2Bhl9FoNHdcePHZpcSGTyVic983rJHU5ltzjna+LkzDm3Qwf9TiwPT+gEOK9wxv/Sz3le3P/NHxhDGWMCgSR/PSZ92kIM16UUXyMgS+aNPhq4DeC4+6gJFCA1PhDGENR81ZA6gYMI7KUsq51eYyKzX16E2/e9iVdCvthwjCYrtKyxS35pXLr1C/0zro/3v01ZhDYVMx2bvB6PTaaG4vRKW7Ud9Y0xZiEbQuuhyxCeWjUUvFcpshh7mk93FANdbhGGWNyfvWNCU81duHDKZO1MFQx4iv/jeZ3gUGEf7MAZNyY2YmnxVD6vGGy9ZtgZeAPfua5Q8VsuEIC+QbiyiZFPFhGPrmcTtUgsqPjxq+e8cB4Hqi/yn9nFWIGhAChrJInhmuHYw31GEd7Za+xaG/7w3Pg4PjfsCSys5gr3tCxBOxU0a1D870fqSre987UaB4QDlsNlS1NcL1kXxFvPYWLXoDwThqeuyvVEX29ADZjbbVZUY9Ul0MVQ0qay7VRr2Z9LnJu+aTK/qL1oef2y1+5flm8l7OGRAOapdU4plpMzL+BJ9mKGqh/XZfL4Usxw+JILHVlTffJDCA3paUR3DQTaPB3MvI+8kWw3VQ+zURyTUd93s1uEPAINb8IrCI3ey31V88L0IM1cNyLieC9axG5fDJ3Lxb/OC7DuGgfem2VEww8R/la22hwP6rkOTJDUYltWvXJIe78KFTXXADet
 dMaEX3MQ
 QCzKon+eCCYR7d9Ey9Y4vN4FBJ3Vwr5agvaln9BbdpycmtWad7JCpk5hbX3xCxuxe9jAzEqJxDINYk5GXuc/U9xrPUVIBBSW7EL/qfy0TEO3AkdWScCnjPDK5TYdia6zwrG80g5wdI7vN1lU8KuZM0KO+7N0RIb1GKP2TmQMJ7nY2R2WNW3OktE4Zx1NNPnLmLSCfoagMsG8yp20ft4jZrvFivTbXXM8LzxQPIMPCJ8Rxlt0d0tkcaZ8zFM1lHqVfoISY86lufHbPG+6qF7lwZpzPBHRomK0cxOj90R0ug6q/XqdBiLwLZAfJt/0mXsNWBekwunUJ2j27mrqP2u/1tU/6kvo1vpYFTGjdshHnoXgB32E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

On Thu, Aug 6, 2026 at 3:35=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> +cc literally everybody you failed to contact...!
>
> Why on earth are you doing sending a series like this which changes core =
mm,
> non-RFC and at v2 to boot, without bothering to Cc relevant people?
>
> I am also very confused as to why you are sending an ostensible RISC-V se=
ries
> then changing how core mm works to fit it, that's not how that works.
>
> And if you're seeking to change core mm send it as an RFC!
>
> On Thu, Jul 16, 2026 at 08:41:45PM +0800, Yunhui Cui wrote:
> > fast-GUP snapshots a PTE without holding the PTL, pins the page, and
> > then revalidates that the PTE did not change. Keep both reads under the
> > same lockless PTE semantics by defaulting the fast-GUP revalidation to
> > ptep_get_lockless().
>
> Why?...

Thanks for the review. Let me first explain the motivation behind patch
10/15, and then address the RFC/Cc and naming issues.

The goal of this patchset is to let RISC-V Svnapot provide contiguous PTE
semantics similar to arm64 contpte: generic MM should still see a normal
per-page PTE view, while RISC-V can fold eligible PTE ranges into the
Svnapot/NAPOT encoding underneath. Because of that, the RISC-V public
ptep_get_lockless() may, for a Svnapot PTE, return the sub-PTE for the
current address expected by generic MM, after checking the whole NAPOT rang=
e
for consistency and aggregating block-wide A/D bits.

fast-GUP has a narrower requirement. It needs the PTE for the current addre=
ss
for permission/PFN/page lookup, then pins the page, and finally checks that
the page table entry it relied on did not change during the pin. fast-GUP d=
oes
not consume the block-wide A/D aggregation. If fast-GUP uses the public
ptep_get_lockless() for both the initial read and the revalidation, it pays
the cost of the NAPOT range scan and A/D aggregation in the fast path, even
though that information is not used.

So patch 10/15 is not trying to wrap a simple equality check. The intent is=
 to
separate two semantics: the current-address PTE consumed by fast-GUP, and t=
he
original PTE snapshot used for post-pin revalidation. On normal architectur=
es
these are the same value, and the default implementation preserves the
existing ptep_get_lockless() behavior. On RISC-V Svnapot, the value consume=
d
by fast-GUP is the sub-PTE, while revalidation compares whether the raw
snapshot has changed.

Patch 11/15 is the RISC-V use of this hook. It avoids the public
ptep_get_lockless() block-wide A/D aggregation path in fast-GUP, while stil=
l
keeping correctness through raw snapshot revalidation. In the 64K THP alway=
s
mode, fio 4K random direct read improved from 2.615M IOPS / 9.97GiB/s to
2.874M IOPS / 11.0GiB/s, and the average clat dropped from 95.54 usec to
86.97 usec.

Regarding the RFC/Cc issue, you are right, I handled that poorly. Although
this series is mainly about RISC-V Svnapot, patch 10/15 adds a generic MM/G=
UP
helper and patch 12/15 also changes the arm64 contpte fast-GUP path, so the=
y
are no longer RISC-V-local changes. I was worried that the large list of
individual recipients from get_maintainer.pl would create too much noise, s=
o
I mostly kept the mailing lists and dropped some individual Cc's. That was =
a
bad call; the relevant maintainers/reviewers should have been Cc'ed
explicitly. Sorry about that.

For the next version, I will split the generic fast-GUP helper out as a
separate RFC, add the relevant MM/GUP/arm64/RISC-V maintainers and reviewer=
s
to Cc, and explain the semantic difference between the PTE consumed by
fast-GUP and the post-pin revalidation snapshot. If I keep the arm64
optimization, I will include the arm64 maintainers/reviewers in that RFC;
otherwise I will drop it from the RISC-V series for now. I will also improv=
e
the naming, such as `rawp`/`raw_pte`, and add comments to make the snapshot
semantics clearer.

>
> >
> > Introduce fast-GUP specific PTE snapshot and revalidation helpers. The
> > default implementation preserves the existing ptep_get_lockless()
> > semantics, while allowing architectures to override the helpers when th=
e
> > public lockless getter provides extra semantics that fast-GUP does not
> > consume.
> >
> > Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
> > ---
> >  include/linux/pgtable.h | 18 ++++++++++++++++++
> >  mm/gup.c                |  6 ++++--
> >  2 files changed, 22 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> > index da14328093a86..62943fcbf7046 100644
> > --- a/include/linux/pgtable.h
> > +++ b/include/linux/pgtable.h
> > @@ -813,6 +813,24 @@ static inline pte_t ptep_get_lockless(pte_t *ptep)
> >  }
> >  #endif
> >
>
> Of course, no comments, helpful!
>
> > +#ifndef gup_ptep_get_lockless
> > +static inline pte_t gup_ptep_get_lockless(pte_t *ptep, pte_t *rawp)
>
> rawp? This is terrible naming.
>
> And 'gup_ptep_get_lockless()' is worse. What on earth is this function me=
ant to
> do? And why is 'gup lockless' considered different from lockless?
>
> And you return the value twice, because of course you do. Why? Who knows.
>
> > +{
> > +     pte_t pte =3D ptep_get_lockless(ptep);
> > +
> > +     *rawp =3D pte;
> > +
> > +     return pte;
> > +}
> > +#endif
> > +
> > +#ifndef gup_ptep_revalidate
> > +static inline bool gup_ptep_revalidate(pte_t *ptep, pte_t raw_pte)
> > +{
> > +     return pte_val(raw_pte) =3D=3D pte_val(ptep_get_lockless(ptep));
> > +}
>
> Again this naming is utterly terrible and I'm at a loss as to why on eart=
h
> you're doing this?
>
> We don't need to abstract equality checks?
>
> > +#endif
> > +
> >  #ifndef pmdp_get_lockless
> >  static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
> >  {
> > diff --git a/mm/gup.c b/mm/gup.c
> > index 99902c15703b0..72fb147193e55 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -2842,10 +2842,12 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t =
*pmdp, unsigned long addr,
> >       if (!ptep)
> >               return 0;
> >       do {
> > -             pte_t pte =3D ptep_get_lockless(ptep);
> > +             pte_t raw_pte, pte;
>
> What on earth is a 'raw' PTE?
>
> >               struct page *page;
> >               struct folio *folio;
> >
> > +             pte =3D gup_ptep_get_lockless(ptep, &raw_pte);
> > +
> >               /*
> >                * Always fallback to ordinary GUP on PROT_NONE-mapped pa=
ges:
> >                * pte_access_permitted() better should reject these page=
s
> > @@ -2871,7 +2873,7 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *p=
mdp, unsigned long addr,
> >                       goto pte_unmap;
> >
> >               if (unlikely(pmd_val(pmd) !=3D pmd_val(pmdp_get_lockless(=
pmdp))) ||
> > -                 unlikely(pte_val(pte) !=3D pte_val(ptep_get_lockless(=
ptep)))) {
> > +                 unlikely(!gup_ptep_revalidate(ptep, raw_pte))) {
>
> Why do we need to refadctor a comparison between a local variable and a l=
ockless
> get?
>
> I'm just so confused by what on earth this patch is meant to be or why it=
's here...
>
> >                       gup_put_folio(folio, 1, flags);
> >                       goto pte_unmap;
> >               }
> > --
> > 2.39.5
> >
> >
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv
>
> --
> Cheers, Lorenzo


Thanks,
Yunhui

