Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F44FCD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 19:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D8206B0005; Sat, 20 Jun 2026 15:34:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 789126B008A; Sat, 20 Jun 2026 15:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6789E6B008C; Sat, 20 Jun 2026 15:34:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 39F656B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 15:34:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F6191C1527
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 19:34:15 +0000 (UTC)
X-FDA: 84901292070.24.3B1525E
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id A267F1C0007
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 19:34:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sjzBM35J;
	spf=pass (imf18.hostedemail.com: domain of zokeefe@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781984053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FXyX7vc5u9wMGq9W4a2YM4FAOP3ULVE/Mumnkwk1cdU=;
	b=4w6ySxqeSmNhbH/ctKKgGXhjmFQv3PIXRxUsf/3q79vsz4sEtK+4oNn22BKDRKzyYSJFBY
	X1Sv3hp0A8+LZpjKJkkyVoNy90z66e88NXScAj+ZIZttOlnMNWcCIQLOXN+VCMfKH6uKjD
	9xkNym+ha2+230+HwZJOXpL+Mlv9jbk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781984053;
	b=Nueq5e8XRxYnyfzHTSaJV+bkE9fvbnUr/cJ/DgR1vTp2pg+vCNtCD+9eFhQ4VTPbyKzWKj
	pxOVM/xZm5oBlVaYioqLNAs5LJHcGG4jWddWTUX3X1GHtmS33OlA9N2HzZLTJMOLlfSZ6M
	0ehbnhcEG88YXqrrJ0hpJ0zVBCqSyAA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sjzBM35J;
	spf=pass (imf18.hostedemail.com: domain of zokeefe@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51765331535so361891cf.1
        for <linux-mm@kvack.org>; Sat, 20 Jun 2026 12:34:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781984053; cv=none;
        d=google.com; s=arc-20260327;
        b=HiVU9evZFw+iVux5MaQev/Mh+jLMp+5LeQr+FFqBamhN7eh1ry68p+Rx2kh+CPimjX
         8e2ChFXGOmH6jZtDyAzvJ6tNFpKVSEJQtvKS2a57SDjW2Xpc8/RgSaHuwQ8tTnSRCQdC
         Tt06RMEYGidN4g7QhqHPw5GI5iMeCPgn7MUaGFVxBgMTsyHG17LnHLwPFZJwfCpsGpip
         uibp31p7Hgo8TKRymfKHr6g7VL/AcgdXqwESTzBHTKkwMPOiz5H5cep7XkFe2bowobTf
         leQ0j4WhpF7953YDzdY5lZEuyq02rsYEAeKjHLz5daadRZBKNIft7giSTZFFoegtZ05S
         5n6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FXyX7vc5u9wMGq9W4a2YM4FAOP3ULVE/Mumnkwk1cdU=;
        fh=d723XxPJi9aSNqyouVQ7hgeL5IEQtcBBGpGvwmaoVUE=;
        b=nvVX/03sk5/XxnvzMdV81eTlBpOFxRsA+F+IPrWEhJJLckrHyhrGCnhacBkNk0y3bt
         u5VAL7hwSDF5x7pyPJkD0jPf/qinZPSgLSB1l+N2YuRgnuzYp8VIfejUF3bBGZcWPEVB
         BBn82/GQh1k4pIu1aCPIuWz5eavJVVxR6DClJIk9lAv8JEhyLVW9Jhnh5oEDyhnrCU1X
         oR3RDdV+CGJ8MEVOwi5euORH9dJgnJbGqevM71Wwwtun4wa40ryOhEU1/aBZwHsKtW5B
         LQ99UlevrlNDiHVH8MOFgMnQuZ3QsYj/b5ThXobZ3oY7lIIMWm38nctYLBzqG5D58UyP
         uECA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781984053; x=1782588853; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FXyX7vc5u9wMGq9W4a2YM4FAOP3ULVE/Mumnkwk1cdU=;
        b=sjzBM35J4D29TMulcaLWfrGIEIAZjvcuwfnqaWtGlwVoqBuzilnNlxfRzXdNtF9Raq
         XQHRUFRKlyVhQlOH1t5JUKmtklN3hZ5ShI6VWhMDIqNO1YH5IfuZG5/gTnMmPnW1sTo4
         +uL4etmV7/f7OaNoPZt0r0asqWb0pQNGNVUhSpRZus5sAoF/gAxwjT71/Jcf0djpZpDF
         A2HnuWVcv2GImIb8Q6Oe2rJB4feXl8Dru+xErfSj1weMKI+IY/NuudiT21J4ip8lXG38
         V+k3TJeS7ZdIqouS5LP+p1W0uUkQ4iQV8Ik7kCpM3SfwHidHs30l9khvddQeSf+cUn9d
         tKQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781984053; x=1782588853;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FXyX7vc5u9wMGq9W4a2YM4FAOP3ULVE/Mumnkwk1cdU=;
        b=jhxvjSCmHDF+HnvsRrEhNxs8gSMC/pjZI7sEG01/A2JNt9txONRXJRVdutSHFJPnnB
         RbOdqLUlMF03i1DI4rM0AXDEc/bz/93LU3Vp3zWsy0R0aa+DAc9yfE49URAz1PKFTCjZ
         q6u+VYvdufjZT6aQLkcTvK7hQEi3DatfCoZmXNRXKOsGsj3KCme9jAP9sheW3atwL9kh
         SwxiouijeIuMy6GyBxsm6gNDTz1soWzEmdNfnFy/xqS+Vp8XSuMakqebhr7+Y2rimy9e
         MHTjGT4lgxWJ3Rm3NzTvByZnRYJaTkmyoFYUiwHkRTwDF3ZQkehbceEB7Rvf3gR7YAGM
         bD8A==
X-Forwarded-Encrypted: i=1; AFNElJ9zyNDA/Uk8UVI+U/RJDVpBmmbzuzysxeCwLlAEAfbVm2jG9Z0dtf6hAHKhJPh8Qz5QdVhml13yvw==@kvack.org
X-Gm-Message-State: AOJu0Yw/V9bWuSKhfKJdIW+SDIV84bHK2UeDOI5Kp75qgPmX7E3Loh1z
	63aaCgvBP9k5Hpiq/VYxIpEXw1CRZAMFIXUUyubtemDVaBY1CPVZP6m5n3a3omiwrMLKTR8ZzqD
	cbt/oQn06JpI8do9U+WK7uGdgfHCBxM6OT7Gq33V1
X-Gm-Gg: AfdE7clcwvYcBH+WcJNrNXIs59d3oYSUH0u3kXd48htSUyjTLravP4nqRFPzzOyse83
	Et6sKQR0BJCfptzWlN5Tvq8piunkmypprPR5I92+k/yVt6n5VYdIpHv169ptzu5cQ2uUPLv9Tf5
	oXYx3GL4KyIGqucoLYbbmqkVvV6cVvRNHJ86q5EEso9iRl3XOVfKvtn61NntFvuwQscsEZ/FtmQ
	7qAm9bnlzLn29S3BVcHAATEKL5GXKgEA4pzHTCgC44efiMEkCyWXyA7mfoM/otr/wAEQgi45dk=
X-Received: by 2002:a05:622a:1485:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-519e45706fbmr15902091cf.0.1781984051881; Sat, 20 Jun 2026
 12:34:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com> <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com> <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13>
 <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com> <87qzm2b39k.ffs@fw13>
In-Reply-To: <87qzm2b39k.ffs@fw13>
From: "Zach O'Keefe" <zokeefe@google.com>
Date: Sat, 20 Jun 2026 12:33:35 -0700
X-Gm-Features: AVVi8CcNNKtvXU6HQVEJMJxvCbYjHfHl7YjCSQAcNV5X_3dY4ZUC1d38P8vXapA
Message-ID: <CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: Thomas Gleixner <tglx@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	David Stevens <stevensd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Will Deacon <willdeacon@google.com>, 
	Quentin Perret <qperret@google.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A267F1C0007
X-Rspam-User: 
X-Stat-Signature: pa1s69t886kzrmb4iygjj6ip1i5te973
X-HE-Tag: 1781984053-7559
X-HE-Meta: U2FsdGVkX1/NPGzElr+ZpyxKRSJRCX1At30j/dxB1a6u0Uyngv6H9/sSUZDn31etrPUPVvy/qzpuFArf4MsGADGdj5zbsbUzAXtP0/VvTLUP4voP6BFqfI+4YN8P7/gPPOhJ3yXGZklPvLkYyJ/yGoYyCjSGI7NaveGFSHxiNgfUW4Jxjx4R1UsidgI6iI+mIBQkg0dfpCTWHSJoQsQ9Pmr25/qJPTtPd02Jmz/tCrlMk3yobaZyd/yXhVj/MzTLHVcfq0Mdrso+aVTyZWMWGRu133yHouy9JFcKY9w/5kVyfcILhZe1EFRbw/Y1wLk8v5QbWr8V3lYeJb7Yf3OF0Md33BT+Zn9Z/wSJv+bbsSVBWuEG3g84cplxsngy0r7pVKLFS+0zCT+7CsD6+9WSDH6t1tHNKkT1oLGxI4hc7GjDHxzzKYDbjaFENL4C2vkwNPPC2klSlP+rvsH3pm4vGuMD793R0GEqEom2m+eCoZHPxG2elrspFoK9WeEWiLgZXyqGDeGGfPGNwFgA1xrzPNmoiPsa3wuGr8Yrkn1k1UKoxqX2wqUIVKQzWHENdROto5wWma1FzUrfoaHHxrRe7O6PHr+CKk++yd4rrlzNgD4RdROAyCrub4dxouODEbEgeKG5P1WgreHuS3QNTiSBzxdY4uBFp8cTvu3HMs/8tzSQpdOijKPPDqJoyf/WgXYYHzjb3X5vG+kcLoaxBZ57B6uFK9PBmG0fhlrzxINyGe9pM2n2K1xlKsHCNYqFdXpSSBtq/DgGeLhyA4dIfFdm+V3RdovCSx7osQJ/4wYuzh8aGvqai2L0XGjwLtMngs9NzuVtztNb8S5Swq8WpulR9hYzLQCrMVuu8cSEDXnzFPfan4Ee5uXn8A9amzLRAlG3zu/ULFpIESDLLSal+RMvxtmCOq2qyqaMfmPsVxNhFQy4rwlLCo1bIpahkGq4xNV7B2TwnoYZfvc6dIoPbBg
 Q9EKjp47
 oPxH42kTC1x//DcCPAfdZ+C0DybCiPQc3WUfsBedjYWZ3epAZXubwch98pvjc46Lmz1W33HiQ53CWiCRe0KeW4kTrAx4PQjyDm3E9Ln9TV0+dnvsVT543XwtnXaNkoRdQ1cASfUbXLE4Iwnqk5Ja/6aDYYJhEhtLSAdbc3IsYYdObYJzifbjyokLIdJM2DdyqZvQDfOFGVvqf5epL7ovQD4Yl8Tj1C1zUMypA7a4Gpnah63zcaxPYH2bFwmEsfjXJM669IPpAs96oixs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 2:59=E2=80=AFPM Thomas Gleixner <tglx@kernel.org> w=
rote:

Thomas, thanks again for taking the time to look into this and help out.

> Zach!
>
> On Fri, Jun 19 2026 at 12:20, Zach O'Keefe wrote:
> > While it seems common opinion that the IST-based solution is fragile,
> > what of FRED? It seems like this is exactly the kind of support needed
> > to avoid some of the aforementioned sw "mess" in various x86 exception
> > handling paths. I agree that it's less-than-ideal that we are forced
> > to downgrade exception levels in the common #PF case, but is that an
> > unsurmountable problem? Pardon my ignorance.
>
> The #PF path is considered perfomance critical. But how much the
> downgrade matters needs actual numbers to analyze under various workload
> scenarios.

Ya, that's my concern as well, as I don't have a good intuition for
how perf critical kernel #PF is for real workloads. If this is your
primary concern, I'll take that as a _good_ thing ; i.e. there's
nothing architecturally stopping us from doing this downgrade safely.
We'll still need the analysis, but that can be a later stage -- we're
more than happy to get this data for all.

> I've not seen numbers to that effect anywhere. The only numbers provided
> are marketing material about the memory savings on a freshly booted idle
> machine. There are _zero_ numbers about the actual real world savings,
> but claims about the PETABYTE savings possible.
>
> Seriously?

This is actually the most understood aspect. With O(100B) active tasks
fleetwide at any point, it only takes an average savings of O(10KiB)
per task to get to 1PiB. At least for our fleet, we know the % of
tasks that use only 4KiB, 8KiB, or require the full 16KiB, and the
math confirms that we expect O(PiB) aggregate savings. The % of stacks
requiring the full 16KiB is minuscule, but it still occurs at a rate
higher than what we can tolerate for SO panics. Given the vast
majority of stacks never exceed the first 4KiB, this enables the
significant opportunity.

> > Lastly, I just want to clarify what folks have meant by "extraordinary
> > claims" or "evidence".  Aside from the above discussion on FRED
> > exception handling, the "only" other part of this is the allocation.
>
> Clearly anything which is explained with "shouldn't happen" and
> "unlikely". At cloud scale nothing is unlikely anymore. That's simply the
> reality of statistical math.
>
> As I pointed out before the same applies to the unexplained
> upgrade/downgrade game with external interrupts. Such issues cannot be
> papered over without understanding the root cause as from decades long
> experience they come inevitably back some time down the road. Cloud
> scale even guarantees that.
>
> > Are people concerned about memory unavailability, deadlocking-type
> > issues, or something else? We have considerable design freedom here to
> > avoid certain classes of unreliability, but=E2=80=94barring any clever
> > tricks=E2=80=94I don't know if the allocation can be guaranteed to succ=
eed in
> > all conceivable circumstances. I want to ensure that reality does not
> > present a hard blocker.
>
> First of all the failure scenario has to be clearly defined.
>
> Right now, if I'm reading the patches correctly this simply can end up
> killing the wrong tasks/processes just because an OOM situation results
> in a depletion of the per CPU cache and the very wrong task which runs
> into the deep call stack situation ends up in the creek without a paddle.
>
> Given that you even fail to abort a CPU bringup when the allocation of
> the per CPU stack page cache fails, makes it pretty clear that there has
> been spent exactly zero thoughts about this problem.
>
> Why the heck does this cache refill call have to be unconditionally in
> __schedule() where preemption is disabled and therefore GFP_ATOMIC
> is mandatory? I know "Works for me" (most of the time).
>
> And just because I was looking at the patch in question I found this
> other insanity:
>
> > +     /*
> > +      * Most likely we faulted in the page right next to the last mapp=
ed
> > +      * page in the stack, however, it is possible (but very unlikely)=
 that
> > +      * the faulted page is actually skips some pages in the stack. Ma=
ke sure
> > +      * we do not create  more than one holes in the stack, and map ev=
ery
> > +      * page between the current fault  address and the last page that=
 is
> > +      * mapped in the stack.
> > +      */
>
> Can anyone with a sane mind and the most minimal understanding of the
> kernel's inner working explain to me how the kernel can skip "some
> pages" on the stack?
>
> If the kernel skips a whole page or more then there is a serious bug
> somewhere. I might be missing something, but again the "very unlikely"
> wording which handwaves about it is just disgustingly useless.
>
> I disagree with Dave on the RFC status of this series. It's not even
> close to RFC, it's at PoC status.

Absolutely understood. I'm more interested in constructively working
together (as we can see, we'll need your help) to figure out how the
x86 experts want to approach this vs discussing _this_ series. Perhaps
it was my mistake to necro this thread instead of starting a new,
general discussion. Appologies.

To that end, how would you like to proceed? You may understand the x86
complexities better than anyone, so hopefully you can guide this in
the right direction. How would you like us to approach this?

Thanks again for your time, help, and support,
Zach


> Thanks,
>
>         tglx
>
>
>
>
>
>
>

