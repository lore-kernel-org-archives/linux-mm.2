Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6D8C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 18:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF7366B027F; Thu, 24 Jul 2025 14:39:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA60A6B0280; Thu, 24 Jul 2025 14:39:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C95AF6B0281; Thu, 24 Jul 2025 14:39:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B43996B027F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:39:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 34608140514
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:39:20 +0000 (UTC)
X-FDA: 83700020880.10.CDF168E
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id 435F112000D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:39:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=c5PgFBWU;
	spf=pass (imf29.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.50 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753382358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mTygwA+Sg/2M91c6LKoJyN6AlUtwLV9EUMVMJxfPrDo=;
	b=GmtpUt4IngJ9puY511ZOmocA58P82dz+qyygkwBjOF5tFSwbkkYPmXQELm//n+L5q7n7qa
	XH4t6I+zgWa5XZUmrqdv80fEfK7xLhb78wdJ6JLSC9xVx5EH+JoXGFYLrZOj07uFRFjF5d
	uS5T+E2+Lffp496nys4753b9SnE8Sfg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753382358; a=rsa-sha256;
	cv=none;
	b=Zp82JPjnUVo0GcSuF/vnmVu7OKnhVjlAQvYEsjh3/mB2/7OWFOdWOw3Je7ktJBe2LMNUT1
	4ZKnemoAw2bxzkjN/KcFV/TcnAXa1Wfwjztw5LSHh4pxm5KeCn72I1Z9sNSDhxURPQqR5Z
	mgma/Lu89P/fTQg5sYw2Fk/k6C/tKOc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=c5PgFBWU;
	spf=pass (imf29.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.50 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-2f3b9afe4a0so31547fac.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753382357; x=1753987157; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mTygwA+Sg/2M91c6LKoJyN6AlUtwLV9EUMVMJxfPrDo=;
        b=c5PgFBWU5f6oh5s5j5ATboLRQjZVUP1JsdU83N80fTMmhjk4WZZSEm/05/qWgySvKk
         a/2RLBjWOI+6lqPQbTlhInZigUHfstLzTNfVXNfwFAE4lEpmai7E2cMr7GQdII4mtD3j
         G/lZ63/1sSMAJ0TXkK91hpn9lkXD5bnVL9M/E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753382357; x=1753987157;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mTygwA+Sg/2M91c6LKoJyN6AlUtwLV9EUMVMJxfPrDo=;
        b=iq+31iPXBUSwyRCX1r6t32bSzaSs/di+BTgx3Aa+GAuejjsUrkXvrKNoqR9o28nw5r
         tMKAOAz6rOzJzVa6jAJ827PcYWL7/HVETESb9CYGRCDIuKdW5g08rsQLFiJP5/4lo97x
         ip1JoCU5LqJ9X7L7s3GinJKDMugnh8UJ96t2RDvoYt8XKgSALpA+B/Wna+4xWrrmWAFA
         68gAsvf7q4IQVynLxJtTxjLiziY+f2geQzpSa/O6ul9MGxonL73w8shhhSIZji0fAOSu
         JRpLFHXUFDC/HTXZmTXlW/iqw8rmQa3lGB9DBSNx5WBhAOCzCgjigjs2N1dryJdWRrYR
         6kKg==
X-Forwarded-Encrypted: i=1; AJvYcCXvq/2bCWA1PF5FPFCQVgK4D1mmU03St/rn+fHphAdRihBIMynNwjTchq1A6Go/FZmcYj9OK10eRQ==@kvack.org
X-Gm-Message-State: AOJu0YwKgrMpyCmuhIs6ZY5yuRCbUij1JbBd2Gsh/1PX6RlNPUPiUz1c
	5gGjWkstc0S4PuX5cpXfxJHc5c/UK6ANPwZhFvm0Sb7QtTDDMuDnCTmTv86GS3sJM8eg+jlFGdG
	EhTXVoWW9xN34WmahBMnNS/tZv2dWIxoWmJ2ZHADH
X-Gm-Gg: ASbGncvcX5QjwejrWEnNRGoeQQ58CT56D/MJEW92+6Jl0wrS5aFlNN0hWQuBGSdioLr
	gitzQNewFI+BObchZKz70h0bKFzm4MygFsPa051zW5MakQbB51FouxEWg/j0IorKUmfENtfLHeV
	o66+baBZn60DLQXZU1jfEtQnVT1afIbF3zoqh+PwPEdq6PW0sVrq5R8BIz/YOK3myqHhRvMpeBE
	Q8rbkaHLXixSXwPQhw32ATSjBVN9N0aGsWQ
X-Google-Smtp-Source: AGHT+IE5v9YXwfMOrt4s6GrcLKH0pUBp6im1qkTMz2i1XtnKS0z4XfcSpoeZckBljPkj00IULZuSGmCS50+4/FTBEaI=
X-Received: by 2002:a05:6870:9598:b0:2d5:d5f:3b12 with SMTP id
 586e51a60fabf-306c702ee61mr2152191fac.6.1753382356998; Thu, 24 Jul 2025
 11:39:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com> <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
From: Jeff Xu <jeffxu@chromium.org>
Date: Thu, 24 Jul 2025 11:39:05 -0700
X-Gm-Features: Ac12FXzeXb-f21M0mzyxQUbrHRmdaCixRPUSYkvBZx5nezL9EZHQfshIAmP4xVM
Message-ID: <CABi2SkU75e7tXcpgnLbDhqSJBWVPOvmfMh2uPsU3mUjMUhhYqw@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kees Cook <kees@kernel.org>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 435F112000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: a74no4jhjqxnzyt3qh3ykb7t5copfuay
X-HE-Tag: 1753382358-61820
X-HE-Meta: U2FsdGVkX1+nCnByXJ8CunHo0uiSOJw6MkzGui/wIxnw6Umhk8RZMv+1mKVWOGTnCwvocH7qPxzm9iwdcolVj7CmyqPtodSaxWLGGNqHE4hEcwbHKQhJqRmB9EZNviPfj6j+XUrJ/KyC87dv1rsZ+ysimUOJjoOmIniK3E0HyWWHOCstyUN8vWgA9Q13twZX8sro07L8p4Ppz+F9m7OGKOXfH70BC1+GibvneoMG6t2GcEDu0eQ5r3bjh+nqkc9wyezJrTXyBh+sxa0mPwc1VZLTWTFGuPt1hqSDswBH7GQRMXnjRITR8gRsAQP38qrPGmKb4zug1V4+5T3czmutC3V7jCDJUGhksH1mLtNY7nDH2Pqhyp6k62dSXFXHWJC2bE9yFouU2jju81RYWG44cmlrUT6Dd+OtxCqb4ljFg4nJ4mXDD3nhNz3lLN96Yz/3rdVTPgAvNg8026thXDy7J97vIqOIvYz7dp57QnLK+rPoB0/pCkbWJHq2pfOVnaJ57Q89KqTB6YWZq1k7wWjyC5K+tiU62NU3t5fnroF4EVhm0COX9leSGNP+JMN8PuIcGVpzPHnDF9xFe/PA6ou1H/dgJIG2L6Ymm/ne0Iz6OsQvYw8xd2XvDiCETyOpNqaOHBQ696DRXDUHUcMPrtR1bNHB4keO7/ZmFLW/x2yYIsPwMgtItXDMgr+rWVOdxRmA/ORalHinnubGxcoSxt/ZP1AqK7513ZZbKmLvfnrVvbEbSL18k0dKGq47eVF5A4FE4J4S9yMyeDHx248nwJ8Hsblm2UTBCpll1rmyQ/cr6Mu0p3YQ2ZfR01WZ4/80pJmXzvYGBb6HaKNqf4GeRMRszV5Hq0q9CU6wEzttGNcSc5WzDeAf/po++TaeJmMlJsdodYCSKPSaTdL8+igEZN5adXfCibTnRYOGBKBvlUhw1s8v8avVY4kaEGR0uRnnT5UOCt2zQyzvVY++dGFjIYQ
 wtpNeq7i
 KY6FeSwV12cJbQSloVBP7PT3bsBaqU9vZ+erK0f307ddqfv8VU7/+yIcbR2XoHi2b6W/pHSSWgpGahhh9JIjltrk7OBxWSY2j03hHTdGGFsP0S9waB1zWux7q4V4FdpIfzGPp1dPuFuT0w+urJbHDgsBLxl81H0928WgKepMvKVsm+tfokEQcuF90WzqAIi91qsTfeQHVtMAhFrX7V0XVreXHcyyNJETm/H7J+f0cxgikCOV0+s9OdCGc3D46R1V29QvJqm8WIvNuIH1MytXZdFT1nCievpgDhH8tDgjjmKdtBp7PDGenKTxarzMl1Ik26auIHqXC5Nj3cm1OOknpbY8qEHRtyLUch6kGsw3WbqzC/VVWoSPbua1I6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

This change has two parts: a non-functional refactoring work of moving
function from mseal.c to madvise.c, and a functional change to the
behavior of madvise under mseal. Would you consider splitting the
change into two parts? which seems to be a common practice at
supplying patches in lkml.

On Wed, Jul 16, 2025 at 10:38=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> The madvise() logic is inexplicably performed in mm/mseal.c - this ought
> to be located in mm/madvise.c.
>
This is part one of a non-functional refactoring work to move a
function from mseal.c to madvise.c.

There are two main reasons why I initially wanted to keep all
mseal-related functions in mseal.c:

1 Keeping all mseal related logic in mseal.c makes it easier for
developers to find all the impacted areas of mseal.
2 mseal is not supported in 32 bits, and mseal.c is excluded from 32
bits build (see makefile).This would prevent accidentally using mseal
in code paths shared between 32-bit and 64-bit architectures. It also
avoids adding #Ifdef in the .c file, which is recommended by the mm
coding standard (I received comments about avoiding  #ifdef in .c  in
the past).

Point 2 can go aways if 32 bits mseal support is coming soon, same as
my other comments for patch 1/5.

Point 1 remains. However, I want to focus on the functional change
part of this patch, rather than the other aspects.

> Additionally can_modify_vma_madv() is inconsistently named and, in
> combination with is_ro_anon(), is very confusing logic.
>
> Put a static function in mm/madvise.c instead - can_madvise_modify() -
> that spells out exactly what's happening.  Also explicitly check for an
> anon VMA.
>
> Also add commentary to explain what's going on.
>
> Essentially - we disallow discarding of data in mseal()'d mappings in
> instances where the user couldn't otherwise write to that data.
>
> Shared mappings are always backed, so no discard will actually truly
> discard the data.  Read-only anonymous and MAP_PRIVATE file-backed
> mappings are the ones we are interested in.
>
> We make a change to the logic here to correct a mistake - we must disallo=
w
> discard of read-only MAP_PRIVATE file-backed mappings, which previously w=
e
> were not.
>
> The justification for this change is to account for the case where:
>
> 1. A MAP_PRIVATE R/W file-backed mapping is established.
> 2. The mapping is written to, which backs it with anonymous memory.
> 3. The mapping is mprotect()'d read-only.
> 4. The mapping is mseal()'d.
>
> If we were to now allow discard of this data, it would mean mseal() would
> not prevent the unrecoverable discarding of data and it was thus violate
> the semantics of sealed VMAs.
>
This is the functional change and the most important area that I would
like to discuss in this patch series.

Since Jann Horn first highlighted [1] the problematic behavior of
destructive madvise for anonymous mapping during initial discussions
of mseal(), the proper solution has been open to discussion and
exploration. Linus Torvalds has expressed interest [2] in fixing this
within madvise itself, without requiring mseal, and I copied it here
for ease of reference:

=E2=80=9CHmm. I actually would be happier if we just made that change in
general. Maybe even without sealing, but I agree that it *definitely*
makes sense in general as a sealing thing.=E2=80=9D

After mseal was merged, Pedro Falcato raised a valid concern regarding
file-backed private mappings. The issue is that these mappings can be
written to, and subsequently changed to read-only, which is precisely
the problem this patch aims to fix. I attempted to address this in
[3]. However, that patch was rejected due to the introduction of a new
vm_flags, which was a valid rejection as it wasn't the ideal solution.
Nevertheless, it sparked an interesting discussion, with me raising a
point that userspace might use this feature to free up RAM for
file-backed private mapping that is never written to,  and input about
this topic from Vlastimil Babka [4] is about MADV_COLD/MADV_PAGEOUT.

A detail about userspace calling those madvise for file-backed private
mapping. Previously, I added extra logging in the kernel, and observed
many instances of those calls  during Android phone startup, although
I haven=E2=80=99t delved into the reason behind why user space calls those,
e.g. if it is from an individual app or Android platform.

Incidentally, recently while I was studying selinux code, particularly
exemod permission [5] , I learned that selinux utilizes vma->anon_vma
to identify file-backed mappings that have been written to.  Jann
pointed out to me that the kernel creates a COW mapping when a private
file-backed mapping is written. Now I'm wondering if this could be the
answer to our problem. We could try having destructive madvise check
vma->anon_vma and reject the call if it's true. I haven't had a chance
to test this theory yet, though.

To summarize all the discussion points so far:
1. It's questionable behavior for madvise to allow destructive
behavior for read-only anonymous mappings, regardless of mseal state.
2. We could potentially fix point 1 within madvise itself, without
involving mseal, as Linus desires.
3. Android userspace uses destructive madvise to free up RAM, but I
need to take a closer look at the patterns and usage to understand why
they do that.
4. We could ask applications to switch to non-destructive madvise,
like MADV_COLD or MADV_PAGEOUT. Or, another option is that we could
switch the kernel to use non-destructive madvise implicitly for
destructive madvise in suitable situations.
5. We could investigate more based on vma->anon_vma

Link: https://lore.kernel.org/lkml/CAG48ez3ShUYey+ZAFsU2i1RpQn0a5eOs2hzQ426=
FkcgnfUGLvA@mail.gmail.com/
[1]
Link: https://lore.kernel.org/lkml/CAHk-=3DwiVhHmnXviy1xqStLRozC4ziSugTk=3D=
1JOc8ORWd2_0h7g@mail.gmail.com/
[2]
Link: https://lore.kernel.org/all/20241017005105.3047458-2-jeffxu@chromium.=
org/
[3]
Link: https://lore.kernel.org/all/8f68ad82-2f60-49f8-b150-0cf183c9cc71@suse=
.cz/
[4]
Link: https://elixir.bootlin.com/linux/v6.15.7/source/security/selinux/hook=
s.c#L3878
[5]

> Finally, update the mseal tests, which were asserting previously that a
> read-only MAP_PRIVATE file-backed mapping could be discarded.
>
The test you are updating is not intended for the scenario this patch
is aimed to fix: i.e. the scenario:
1. A MAP_PRIVATE R/W file-backed mapping is established.
2. The mapping is written to, which backs it with anonymous memory.
3. The mapping is mprotect()'d read-only.
4. The mapping is mseal()'d.

The test case doesn't include steps 1, 2, and 3, is it possible to
keep the existing one and create a new test case? But I don't think
that's the main discussion point. We can revisit test cases once we've
fully discussed the design.

Thanks and regards,
-Jeff
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/madvise.c                            | 63 ++++++++++++++++++++++++-
>  mm/mseal.c                              | 49 -------------------
>  mm/vma.h                                |  7 ---
>  tools/testing/selftests/mm/mseal_test.c |  3 +-
>  4 files changed, 63 insertions(+), 59 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 2bf80989d5b6..dc3d8497b0f4 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -19,6 +19,7 @@
>  #include <linux/sched.h>
>  #include <linux/sched/mm.h>
>  #include <linux/mm_inline.h>
> +#include <linux/mmu_context.h>
>  #include <linux/string.h>
>  #include <linux/uio.h>
>  #include <linux/ksm.h>
> @@ -1255,6 +1256,66 @@ static long madvise_guard_remove(struct madvise_be=
havior *madv_behavior)
>                                &guard_remove_walk_ops, NULL);
>  }
>
> +#ifdef CONFIG_64BIT
> +/* Does the madvise operation result in discarding of mapped data? */
> +static bool is_discard(int behavior)
> +{
> +       switch (behavior) {
> +       case MADV_FREE:
> +       case MADV_DONTNEED:
> +       case MADV_DONTNEED_LOCKED:
> +       case MADV_REMOVE:
> +       case MADV_DONTFORK:
> +       case MADV_WIPEONFORK:
> +       case MADV_GUARD_INSTALL:
> +               return true;
> +       }
> +
> +       return false;
> +}
> +
> +/*
> + * We are restricted from madvise()'ing mseal()'d VMAs only in very part=
icular
> + * circumstances - discarding of data from read-only anonymous SEALED ma=
ppings.
> + *
> + * This is because users cannot trivally discard data from these VMAs, a=
nd may
> + * only do so via an appropriate madvise() call.
> + */
> +static bool can_madvise_modify(struct madvise_behavior *madv_behavior)
> +{
> +       struct vm_area_struct *vma =3D madv_behavior->vma;
> +
> +       /* If the VMA isn't sealed we're good. */
> +       if (can_modify_vma(vma))
> +               return true;
> +
> +       /* For a sealed VMA, we only care about discard operations. */
> +       if (!is_discard(madv_behavior->behavior))
> +               return true;
> +
> +       /*
> +        * But shared mappings are fine, as dirty pages will be written t=
o a
> +        * backing store regardless of discard.
> +        */
> +       if (vma->vm_flags & VM_SHARED)
> +               return true;
> +
> +       /* If the user could write to the mapping anyway, then this is fi=
ne. */
> +       if ((vma->vm_flags & VM_WRITE) &&
> +           arch_vma_access_permitted(vma, /* write=3D */ true,
> +                       /* execute=3D */ false, /* foreign=3D */ false))
> +               return true;
> +
> +       /* Otherwise, we are not permitted to perform this operation. */
> +       return false;
> +}
> +#else
> +static bool can_madvise_modify(struct madvise_behavior *madv_behavior)
> +{
> +       return true;
> +}
> +#endif
> +
>  /*
>   * Apply an madvise behavior to a region of a vma.  madvise_update_vma
>   * will handle splitting a vm area into separate areas, each area with i=
ts own
> @@ -1268,7 +1329,7 @@ static int madvise_vma_behavior(struct madvise_beha=
vior *madv_behavior)
>         struct madvise_behavior_range *range =3D &madv_behavior->range;
>         int error;
>
> -       if (unlikely(!can_modify_vma_madv(madv_behavior->vma, behavior)))
> +       if (unlikely(!can_madvise_modify(madv_behavior)))
>                 return -EPERM;
>
>         switch (behavior) {
> diff --git a/mm/mseal.c b/mm/mseal.c
> index c27197ac04e8..1308e88ab184 100644
> --- a/mm/mseal.c
> +++ b/mm/mseal.c
> @@ -11,7 +11,6 @@
>  #include <linux/mman.h>
>  #include <linux/mm.h>
>  #include <linux/mm_inline.h>
> -#include <linux/mmu_context.h>
>  #include <linux/syscalls.h>
>  #include <linux/sched.h>
>  #include "internal.h"
> @@ -21,54 +20,6 @@ static inline void set_vma_sealed(struct vm_area_struc=
t *vma)
>         vm_flags_set(vma, VM_SEALED);
>  }
>
> -static bool is_madv_discard(int behavior)
> -{
> -       switch (behavior) {
> -       case MADV_FREE:
> -       case MADV_DONTNEED:
> -       case MADV_DONTNEED_LOCKED:
> -       case MADV_REMOVE:
> -       case MADV_DONTFORK:
> -       case MADV_WIPEONFORK:
> -       case MADV_GUARD_INSTALL:
> -               return true;
> -       }
> -
> -       return false;
> -}
> -
> -static bool is_ro_anon(struct vm_area_struct *vma)
> -{
> -       /* check anonymous mapping. */
> -       if (vma->vm_file || vma->vm_flags & VM_SHARED)
> -               return false;
> -
> -       /*
> -        * check for non-writable:
> -        * PROT=3DRO or PKRU is not writeable.
> -        */
> -       if (!(vma->vm_flags & VM_WRITE) ||
> -               !arch_vma_access_permitted(vma, true, false, false))
> -               return true;
> -
> -       return false;
> -}
> -
> -/*
> - * Check if a vma is allowed to be modified by madvise.
> - */
> -bool can_modify_vma_madv(struct vm_area_struct *vma, int behavior)
> -{
> -       if (!is_madv_discard(behavior))
> -               return true;
> -
> -       if (unlikely(!can_modify_vma(vma) && is_ro_anon(vma)))
> -               return false;
> -
> -       /* Allow by default. */
> -       return true;
> -}
> -
>  static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *=
vma,
>                 struct vm_area_struct **prev, unsigned long start,
>                 unsigned long end, vm_flags_t newflags)
> diff --git a/mm/vma.h b/mm/vma.h
> index acdcc515c459..85db5e880fcc 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -577,8 +577,6 @@ static inline bool can_modify_vma(struct vm_area_stru=
ct *vma)
>         return true;
>  }
>
> -bool can_modify_vma_madv(struct vm_area_struct *vma, int behavior);
> -
>  #else
>
>  static inline bool can_modify_vma(struct vm_area_struct *vma)
> @@ -586,11 +584,6 @@ static inline bool can_modify_vma(struct vm_area_str=
uct *vma)
>         return true;
>  }
>
> -static inline bool can_modify_vma_madv(struct vm_area_struct *vma, int b=
ehavior)
> -{
> -       return true;
> -}
> -
>  #endif
>
>  #if defined(CONFIG_STACK_GROWSUP)
> diff --git a/tools/testing/selftests/mm/mseal_test.c b/tools/testing/self=
tests/mm/mseal_test.c
> index 005f29c86484..34c042da4de2 100644
> --- a/tools/testing/selftests/mm/mseal_test.c
> +++ b/tools/testing/selftests/mm/mseal_test.c
> @@ -1712,7 +1712,6 @@ static void test_seal_discard_ro_anon_on_filebacked=
(bool seal)
>         unsigned long size =3D 4 * page_size;
>         int ret;
>         int fd;
> -       unsigned long mapflags =3D MAP_PRIVATE;
>
>         fd =3D memfd_create("test", 0);
>         FAIL_TEST_IF_FALSE(fd > 0);
> @@ -1720,7 +1719,7 @@ static void test_seal_discard_ro_anon_on_filebacked=
(bool seal)
>         ret =3D fallocate(fd, 0, 0, size);
>         FAIL_TEST_IF_FALSE(!ret);
>
> -       ptr =3D mmap(NULL, size, PROT_READ, mapflags, fd, 0);
> +       ptr =3D mmap(NULL, size, PROT_READ, MAP_SHARED, fd, 0);
>         FAIL_TEST_IF_FALSE(ptr !=3D MAP_FAILED);
>
>         if (seal) {
> --
> 2.50.1
>

