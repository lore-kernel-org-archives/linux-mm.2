Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEAD5606A333
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 14:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fotbeN2u
Received: by kanga.kvack.org (Postfix)
	id 668706B05B2; Fri, 27 Nov 2026 09:45:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619576B05B3; Fri, 27 Nov 2026 09:45:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E1EB6B05B4; Fri, 27 Nov 2026 09:45:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A9136B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:45:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7600E1603BF
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 14:45:15 +0000 (UTC)
X-FDA: 85481171790.02.3EC8FFB
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6EC8F100018
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 14:45:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=fotbeN2u;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of elver@google.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795790713;
	b=19bVGcQT+iA7eO6CrxX46U2AYc4KjoJmu5Yk/DkdPLE94ZkzKnSdxNW6El2VU8tLH5hjjM
	pZmt9eaOiIRRRfoyTUc2Aa1dKHP8a2JpOYKZsAG0KS3JSDZVznAhk4YGnxiwpf9II+IYFk
	Q5rdfKk5dRwi+LicqtouM6JFgl/2Cns=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795790713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+soOcz85icrjQ+rUx6UalOaZn1H7TTjovCdJTRxT9c=;
	b=mVKOBMB7CUu2by08sn6nHguRC1Ic5iQF4t4RsjBFZuCbXHU6mJgBZvdtGa4Rj68elxRTzH
	uncThoPiNB5fn0EcDRuwZMuGw3A1aJKAvLgczkeECOvd5B0F3wwQhDSEvyNFm4aVUuzx+u
	U2PJXe31WKzKUZ/2wiMxwQ44lVpiUjM=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=fotbeN2u;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of elver@google.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=elver@google.com
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1b563e32936so4083889c88.1
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 06:45:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795790712; cv=none;
        d=google.com; s=arc-20260327;
        b=G4Iy/rvy6beyv3zo3gvqq/OCKBDBgRuFiyW7GklSTPE+rRMDNArgoR/x/qXLh8ZIk+
         sceQp1ZkxGcTeS21/wRviohAP7v69ws7ZS1WPiS/yvswGvsibERQVP44nkJZucacAckq
         uFUVthdI3ptAoe/Vn7a6LkgZgQuwu1x7GSNi6SUofRYxq/++uhzdjOS4JolbNwpAJOPU
         tMi5+GPw6EcfTz4VE4QaHMDJ/He0cB8dn7x6MNbmfg6DTwCxB1mmxPzXrDPpcLrUCqxF
         5mIdKO1x+OE+SRTSoTun/wrzCdTE3bL1oYj8BV0nkpQGmXtVv+XKsvN3DqH57jHJejxD
         gpFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7+soOcz85icrjQ+rUx6UalOaZn1H7TTjovCdJTRxT9c=;
        fh=oCnV4OdBUPA6P8b0jcFdFp/Mvy+Lg2c1X407ciNr2dE=;
        b=qtb9TYQRKjtapnpjBT76cr9a7QvRMXdZmAdFQJTjSP8qGTRqWZ0bFKJgf4oNe2JALo
         Yqn7RI+ajJyoowKOr61oH+gg576pv4ZMIZXIs5qRPtnJhXlWFs0VBcF2PJQ8e9bMxVFm
         rafwxtapOV+ZvludYnpt8iEyyqZUjpGdBuKKizKHR39AXvIhvkU14hLl6drsawPLjdco
         TriFNCumf1lwtZ+siQWfPS8ymNkcmUN3IxeL5tWFUr2IMbn6fv14/d99kXOVKo1fgVWH
         BQb0nLer+BbtV+Of661cbM8p0rX93vk8QCMmHNPHLWWrwLbC058bjDDsDK0nsr7ExH4T
         +LEg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795790712; x=1796395512; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7+soOcz85icrjQ+rUx6UalOaZn1H7TTjovCdJTRxT9c=;
        b=fotbeN2umzgL2i9+EZtaqw/X/VOtCSWGmud0oCzNbMbHIww/0dc/M73UgpuGv8c5xG
         c98kGJOabbaz7vqRj+o/tNg4adaMkl7keTpRiqrsLzL4hlm7ozOK8Wz1Ebt585kSvp+8
         A/rfpV0tSMgzvPyxfYRntvmo6si75D8UYU3yumGBzJxAIg1Ja+x37j3bvnl3XsDLX1NO
         9N7JPi7gMpvg5k0vNXrP0kN3CD9MmhCqq2LFV165ueKleTsvVCLE0CJqOSoFLc985b+u
         /UyDkDGYWvIIRLy78CFkm+2OfiOAYNV6Lr3VDKP6/+AJslu7sV9kM4Lfjb48P9pckCMx
         LrTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795790712; x=1796395512;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7+soOcz85icrjQ+rUx6UalOaZn1H7TTjovCdJTRxT9c=;
        b=cjhVXD9nRf1OVDdar2V5RUPTVp6OZEebTIE8K53piTTHM0+mVow6lkdILNt0By29Bz
         dVLj2sB6ff5sOMOidx4UwDOW4LlrUpfhmg1t/MHEv9iViRWOLsC8M0EbGwZ6rRdG4HGn
         oMEG4Ze9h3u2jAvi4+rayEEoF8Dh87YWcsUj+y9nEyCT0hQ861jWb8B4pDswbGOr0CCx
         TKp7ah4ruT4JuD3JYwssZ82stuouvrMDeXT5awmLLUOBS0veetIR7aUCB2RTXOxbre1N
         M87N6khdq68YVixHtkifvO1nkAJpWlVhTH78fz5ZuluxH+UVnAyqCDtSJZobngndoixi
         IQ/g==
X-Forwarded-Encrypted: i=1; AL+hErHNytqjjK4cgf6By//HpeUZ0Mf0aYujT1vonQgMDPc3FzupinII/QqMPjOK666n8vGzvATB1SKpCQ==@kvack.org
X-Gm-Message-State: APuU4Z+nszSGeEo5AAXGxWyOPWaAGAPuK+MrlQPSzxugz5QtO6/TXxpe
	q7ZnYt6zp2cqcpL83ySA0m/QBZI3HYkzdJkk6GDAg/ltdUANRp2wBD+NJd46n2ALsajZWk3kiWQ
	7vg6sNgIm2KYhv8IOw+4RFiy1SB6WMBqErS7MFErB
X-Gm-Gg: AZFdTZemr7CsGQAL1CFsZpxTeKmhZ8D8EVgIB+GSscY11omhzXf9ULQfrTx+XMy9lpj
	Q/1aIy/A2TIxu/s+9zGe3+J3+aZHxM24OM+Y1wry9tKMrD7p9YlnWGuacgam8vHQDkIQo7rYP+e
	pWPVCxbTcOgGitpwdTF37RIKEjO3TMPmclwok96YhASdZKgi4Y/b8U8VYh4nv9ji5df8YyGO4N9
	LwTZATtimMs77KSrnHTMQejAqj4DHq17XofWIXotc9yU9k9neDNzafHf89s37P2NxMLxSHHHWyQ
	SUzXXbEzRAgtADcyR352qDqYia5ThjU1ekZnjbVN18y3pdMEzv2J1x22kjGsHd7xHGxXhvsNWwe
	bbjqBVd6nGMoY3q47V0s56Ml4WQMndoQOKh8OZS49Q5bp9gEChyQjWMSudtEABrEltCg=
X-Received: by 2002:a05:701b:4583:10b0:185:33ab:4d55 with SMTP id
 a92af1059eb24-1b5569101fdmr23007327c88.29.1795790711142; Fri, 27 Nov 2026
 06:45:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261127-kfence_guard_zero-v1-1-cb33d3ee653b@kernel.org>
In-Reply-To: <20261127-kfence_guard_zero-v1-1-cb33d3ee653b@kernel.org>
From: Marco Elver <elver@google.com>
Date: Fri, 27 Nov 2026 15:44:34 +0100
X-Gm-Features: Aa3M54qdoQi7OKCQcfSUbsWCvDOffwZ5dGpocVkbNLLADG4G6DF6s34QSxjhyWI
Message-ID: <CANpmjNNTOc0h3yG8n3CHLsmqNH-+Y454=9cATn6rM0dXA-nYFw@mail.gmail.com>
Subject: Re: [PATCH] kfence: use a nofault store to zero the guard page
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Chris Mason <mason@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6EC8F100018
X-Rspam-User:
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: j3y67bxed8ha7jtccnd1hhbt5akzktb4
X-HE-Tag: 1795790713-736132
X-HE-Meta: U2FsdGVkX19m1WW9Wta3yCTQOeqqPe8cLlBDKduU/UvJB27HDFO/OeHaz9ElXfohvdl/Q+XxX73CUh3+11xbnpqDpynDpVlhfJU9vv+z3zOpuzhnuOhHKkFJWtZMEN7zOnaFLHGeWrG1lJLoQZiOk0BG+L2lOWPFR4zaFLcvyqvqDcEtUFkAIaVGqtrWU81Q7RAL2hTkY7LMdFkglrEQiZCyklTawBrL1/DZZIUxi9eey6lSdJy2Ka8HLV77+ZGo8jmjzzYf9+L8VxoQG0pWIrQ7+rvMN/CIiQt9adB3oNlMl7MTXKUOIVNxaadfhgtCzaiNI+qBaiz/wRgpIsybxZpV6XQnOUSKcdN24gSOAmA1BUZ1tbsZKJve59eAjKCUfzwNK4a3c9XwErCozRc7zinVTsxk34Yf3pj/DCmI/BvzUoTvjH+q+Mn1fljzLf5p/DGMPvDFR/2cO0jbC+mj/cV8VMvEARk5789JCEuxXcSmG6N79Zd8hw/ZJcHq1ZjylVBq+0tq9ggu5ATI5+n9v1ephHajuL1+XAMY0eo7Uzwr+9S72V7vBRRbrcytaDCP8dfpljJ2CTOd1DRYzJIgI57L4Sf8xzeOIvC79V+vnkdJS7FlEv65SqztgOXflxjdweHT59ybgChMoFzDWqlv8ccPeJZhIk/ZwfZdS0aFQNwqrBj1uKrgziNvKj+liDWW6wFHtJjZyBik2E/KDdRX1xJgWLSywA6qCrQ/3KxB4XkLsfkfz2OmWbrXY4eces2Cp7ujF2fivtyWgS8jgQKobZLCC3SPuReGJMzFm97tUyMIr9qlM5rMM8Sjq2GvM+cL/l4/1tWjGXqVF4+txAC7JZ4Em0RcPz42vJUk3Pv+g9ozEymiPmCvOS+47yn4nPGgLjOYYIxolfzrM3foL560Sr+VPNSeua/dD3biIDjXxpemyCySa0+6nawSGGLgpR4OdTWKm1Yomg28fSWIu+X
 t2rTQSO5
 QwXcziBZjhA/HcA13DKyVOqt1Y2erwOytTBSG0oiDv7GpqKu0gPVPOZNzS+URQP9pNm+CAtM9C81AzFE66BFe12Cqc/PtjOtrS5z0Q0qjEnfAOkAeUl1t8PD7X6zjn70PbWntWXWOnpv8t9kgCVYJBzcGdr5NOiCkmYwKBuoAxbmhxdI+aY/OuB7jqWpRmcZ/FUsZ/5fHo+V2VTmy4aoAtGXg59Kr0Xug/DZR/hcQw6U74rMqXa31gzaGzOBXOhMrSC3kGKSDsAaaSY26PiLV9+lbJ5uFjzmq6Ll1ibadsU5aRjgcxkkgLK6h11UtygzNCoPFS4+bEIQTtkcLkNzPWcXDHzjplQh5faYHEzFr9A4YN0q0aOf/yAf/2s/OHpgneQ5mNP0qYRx60ukCUDBngqfXt3JFLA0C31DBHXk8Id+q6f+xYE3n+j2SkXVnaW7ERBnqum2QbP1Lu9YwN53g2Oix/ndrHIhe3DtfsaIJwnzclkqsOjtEQzeW0DKa7IAknwvo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 27 Nov 2026 at 11:04, David Hildenbrand (Arm) <david@kernel.org> wrote:
>
> From: Chris Mason <mason@kernel.org>
>
> After an out-of-bounds report, freeing the reported object can deadlock
> on its own meta->lock with interrupts disabled, or trigger a false
> out-of-bounds report on a neighbouring object.
>
> With kfence.fault=oops, this can happen more reliably, without races.
>
> kfence_guarded_free() zeroes the guard page that meta->unprotected_page
> points at while holding meta->lock, assuming that the page is
> unprotected. However, the page might still be protected:
>
>  - kfence_handle_page_fault() calls kfence_unprotect() only after
>    dropping the lock, so a concurrent free is possible.
>
>  - With kfence.fault=oops, kfence_handle_fault() calls BUG(), so we
>    never get to kfence_unprotect().
>
>  - If both neighbours of a guard page recorded it, freeing the first one
>    protects it again.
>
> The store then faults, and kfence_handle_page_fault() either tries to
> take the meta->lock we are holding, or reports a bogus out-of-bounds
> access on the other neighbour.
>
> Let's fix it by zeroing the page with copy_to_kernel_nofault(), so that
> a store to a protected page simply fails. All architectures that
> support KFENCE try exception fixups before they call
> kfence_handle_page_fault().
>
> Skipping the zeroing is fine: either the other neighbour zeroed the page
> before protecting it, or it was never unprotected.
>
> This is a quick fix: nothing serializes the protection of a guard page
> against the fault handler, so after a racing free the page can stay
> unprotected and we will not report later out-of-bounds accesses to it.
> Add a TODO as a reminder to sort that out properly.

If an OOB occurred, the kernel is already in a bad state, and any
recovery attempts are best-effort, so this fix here is "good enough"
for this intent. You could drop the TODO and just leave the comment.

We wanted to avoid someone exploiting the lack of zeroing, and zeroing
may prevent some info-leaks, but I never actually have seen that this
is reliably possible. Because the only way to get to that memory is
with more OOBs; those can all be killed with kfence.fault=oops.

> Fixes: 94868a1e127b ("kfence: zero guard page after out-of-bounds access")
> Fixes: da735962d05c ("kfence: add kfence.fault parameter")
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: adjust comment and description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Marco Elver <elver@google.com>

> ---
> I think the underlying problem should be fixed at some point. If this
> quick fix here is not acceptable, kfence people please take over and
> fix it properly right away :)
> ---
>  mm/kfence/core.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index bae787fd9baf7..02a07676ac7aa 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -33,6 +33,7 @@
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include <linux/string.h>
> +#include <linux/uaccess.h>
>
>  #include <asm/kfence.h>
>
> @@ -553,7 +554,16 @@ static void kfence_guarded_free(void *addr, struct kfence_metadata *meta, bool z
>
>         /* Restore page protection if there was an OOB access. */
>         if (meta->unprotected_page) {
> -               memzero_explicit((void *)ALIGN_DOWN(meta->unprotected_page, PAGE_SIZE), PAGE_SIZE);
> +               /*
> +                * The fault handler may not have unprotected the page, or
> +                * freeing a neighbouring object may have re-protected it. Don't
> +                * fault, otherwise we can deadlock on meta->lock.
> +                *
> +                * TODO: Serialize the protection of guard pages against the
> +                * fault handler, so that we always find the page unprotected.
> +                */
> +               copy_to_kernel_nofault((void *)ALIGN_DOWN(meta->unprotected_page, PAGE_SIZE),
> +                                      page_address(ZERO_PAGE(0)), PAGE_SIZE);
>                 kfence_protect(meta->unprotected_page);
>                 meta->unprotected_page = 0;
>         }
>
> ---
> base-commit: 739e2d979b66be560b608a38c4ff86150ec090be
> change-id: 20261127-kfence_guard_zero-fda6d21938a4
>
> Best regards,
> --
> David Hildenbrand (Arm) <david@kernel.org>
>

