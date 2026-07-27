Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF280C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF9436B008A; Mon, 27 Jul 2026 12:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0716B009F; Mon, 27 Jul 2026 12:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC0556B00B1; Mon, 27 Jul 2026 12:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7470C6B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E29F01C0044
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:54:17 +0000 (UTC)
X-FDA: 85035154554.12.C53FEAC
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id EC3AEC0002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:54:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="dRCF7VV/";
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785171255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9J3NeKXFAEeEgskh+bZEZk/wj/xOrv/sfM8KfzxOVXc=;
	b=4SAX9P73YEA4SB2ZXh0Jlr7dJq8ObpOT+MBjzpwEdc5tRmhU/NvxCvaJpacXxZQoGAWwYz
	HcJHRX8uUEY7amj/3UhEOFlag8NMKwvXhock58N3ZAP2XoV2bBz7nbOj6sqZwfoCFElDsP
	/byla0MJsJFwuPb4c4lW/LgnrDhxYvU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785171255;
	b=Z0tQbCOG2DJcHeQlliQe4NNuSkKQTk1ObCq8ljSS/rMHisa1j0EmF9x4nvBOlcreweLXrk
	sMsLPKVnD14Ai2DQv4McnRfVvRyFyloz5l0WEF+tmtRndp8yZcPODWzSfVcu74eHTmg40S
	qze8JLmFPYOBFtKH0mVYUmgaVbfINyI=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="dRCF7VV/";
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51c01c79467so9101cf.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:54:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785171255; cv=none;
        d=google.com; s=arc-20260327;
        b=M/Yjp1vh+MeomGyW9XZrqSeQ8J4zod+L45YAL5/ZuuMlm4aWhK7hK93HQ7+86dCXos
         2CYVRB/ghStIJMFdHvZuNkpKEyg+CCt4brL8RM5mI2eoIqB2E/DD3U9uwXu98O9zgFnC
         B8Y4jNfV3TWGpbFPAi12KBugJMazYrQZ1u/bGxVGOx15YrCh355dBEKKIbsYAdwX2A5y
         IDbhQmwocRTUKlTNgTlcmE/LiCtao4uwOJteM+3lwZwY5Ide/jsDG11DsJG+PV4qLcvf
         g8W1KY13kZogL6mVmzw+GzwgPSeSq3IHzjGPq0bp5GW1eeSmgnhXa1sgBN7jd0jGY6EA
         UJfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9J3NeKXFAEeEgskh+bZEZk/wj/xOrv/sfM8KfzxOVXc=;
        fh=J9NYCc6gPAAy2A86yXm08dF2kP9jJbUIAfD8iVZ03KE=;
        b=S5OKUIO1U5/po2Qwhud79hs6AxPYGhxA8zLl4ruhe97M9FjLIqW3c7hvRmPsP4GEp/
         cC9/w5odvAXfERPAlG61pgUuGERWrYvC8Qx/S2rrgE0qjyq2fg0WhV76cEYCfUO+/ajE
         KCKq2ZBpzt4x1acQF27/xlAKnvALImDlajOenT44kVoA8TIzi0hEZQTsV6ltQNcMm+OF
         L1lmz3wKkyuCvKj3mkqbF1aZgDpkp3WFEN1/UNV3oikqlGB4vHJ4Rf2ib27Ix9a8cvOw
         h2qLqUeBrk93xnWXrP9IRGZRKWMv8qVFaAQAURnbKyqiXV4u4kH1xJYF5pgvMrDCMAQh
         9UOg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785171255; x=1785776055; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9J3NeKXFAEeEgskh+bZEZk/wj/xOrv/sfM8KfzxOVXc=;
        b=dRCF7VV//sYSPlxBDUlng5ReEfLRfotXRT9CO4o3Kqk144zhYFGQ8LiofU8k6E0wJ0
         xOd2vVeFE826dG58NSuQZiEzZfgj1fzkUYd7kyaS4D78EDCzsrR7wznyF4xPZ/anI28b
         alRSAvr4Jd++FhcaH3Z6KGw/Doy6bAcQvvZJXvsStjyRvZoHo5550N3/do1kftGRVNmU
         GYG0Hx3N+KfA3TyQ/yET+lCNBlmP10OKtaUWTGTBWuCBwKfuXmq5uEVF2nwcJx2Iz0tW
         ujG8u2Dnk45q0el6Qg9Hd5UeRibui8JHP8y4IuHfiKHiqTIrgLMLR99e+Z6RBeyzjCq7
         3SAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785171255; x=1785776055;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9J3NeKXFAEeEgskh+bZEZk/wj/xOrv/sfM8KfzxOVXc=;
        b=DeiqvqdHrYC62lwS1469SProY5hHf842v9CIxUkQaLq0sEoorKlcPHTX8d0l1r/bco
         5/TELIMcRApbwvAFC2Muk0bLc+2thYbc5NnI+SN/zo969z+Y+Ao3VCf4U7LPr4Svo/X6
         MotKQWWAqQMm81qJs4ENotmEAzZdAXIPdiYs1g1uLbgTso4T9FNGmheQbAqYDxVK61OO
         zZp5P9MXxv7CTjIg9Hvx1d9nJrZwWEcxj3QxJzsPe2nqITF0e4CNhyb5w2otDl2jOix6
         Jv4ZbK/RXKi5QvZT9C1WuwDGjLWcH0RzOTsJ3sO6h3Xfjng2UCbT066c57L3aovC51FR
         OHSw==
X-Forwarded-Encrypted: i=1; AHgh+RpKhJIprQg+FGnUYhS2z2VcOgKn14GmCLWQ3h3QRB5EiHlO5RIh4YZ2yDXjmoSd92V6NhgmMXKtxA==@kvack.org
X-Gm-Message-State: AOJu0Yy4DQCpDSBcfqZhxqHO+UAiUzbX9+N6sQLsrFQtEILqShqb1zuJ
	JEtgcG5ppC4C1NjDJ7QcftMIv8KXmfbPqWpQNcQ/gr4BiFf9/R+pHQdp8nGl9xPHwsprcbkdTLn
	ktwW4yU63OybAzjnimkquN2CodI42LSJEz8U4r3Fq
X-Gm-Gg: AR+sD13Ok/os+LRPbPgnI2zVUXU5FWqrEL3mvVPgEv9PTzNKQoJxh2ZuzVFm49HZk26
	19MG3Nq8+lZd1o0dZYoV+trATdeSu4cP1w9aNUOmEm0w3VKC4lNbXDrwQAledsT3Mmr/pMGaUOC
	3EIfvzsRBCBh74pvd/RUvGDmmXeXwSaM+JabHg7hPpq+5MptwDVYnKe1NaqhHpP3E8Qe3l48HLL
	8GLaMJvPAblTzJrSSCWpTentiIatpxDj7SGM+yIHybZ/wB51Hz/6LewQJ5KQbY+wNLxIvHFNtPe
	Lf4JpAeLlnCI9bGlJxwy8wuKF/aPj3QJmyKxvfvjCZOtcnuzIXEZvTg=
X-Received: by 2002:a05:622a:a9cf:20b0:517:5ac7:332e with SMTP id
 d75a77b69052e-529a5e705b1mr37713121cf.6.1785171254435; Mon, 27 Jul 2026
 09:54:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260724222934.1463812-1-riel@surriel.com> <20260724222934.1463812-6-riel@surriel.com>
In-Reply-To: <20260724222934.1463812-6-riel@surriel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 27 Jul 2026 09:54:02 -0700
X-Gm-Features: AUfX_mzFufwAIirM-E2G7uc6c5qo6q7kAXxJ1DRmNIw9P-e8JJQLuLpZZs9WBFA
Message-ID: <CAJuCfpE5svMkGMRi6sxxsuYC6MuKuRfw4rV=nKrDOrsQOB4Upw@mail.gmail.com>
Subject: Re: [PATCH RFC v4 05/12] mm/gup: add get_user_page_vma() to fault in
 a page under a held lock
To: Rik van Riel <riel@surriel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kernel-team@meta.com, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EC3AEC0002
X-Stat-Signature: qqmzc3o9ms3rb4xfk4xxmkb11juineon
X-Rspam-User: 
X-HE-Tag: 1785171255-632055
X-HE-Meta: U2FsdGVkX18R4uRnbUsDc0vkF00xnXLHHUznwkWlNjMuwlF/FdhEQ0i97ocRmZNJWvB9gd+FvS84k26KnvrvoDGS13qYlyHIcmVpQp3D1MXPt8xqjuTZ1/MhLZ15iDLkVsflwkx6U23+dVEHxP0g7jSH8KW+/ikujJ8h1NbhMckABLwk4oWr0rzIhD55947enDHk/XX44QvHAlesdC5uQQgTIpLZar676Flc9ydDAhSI7awmpWqz/0ho/vtptOtCdVvBQb98fXWmR7Q6X+CKc3OAfOajG8lqq1ksNVYlb4Rl9RxsjjboDiwOxAL0LBcJk5ngWznYKC0mznjXCBHOplMcCXTjVtc+hBuzoeEGKzlHzPzyUNspZgxLnNxmvP4o9j2Gnju8YQVJIcz8NedPG7ToPjob15H9wZ5BmNf1RnciLdTJX93pl88wyOaVRN2pSJtjOyWUB7Tka9lixHyCwVUAuCGKaGbERtl4GR1SSaE/wdCT1/5KFUhwcnWQj4t79SaV19X2aWOUyABHcxXqILlFMF6OSBf9jr3dKjxZXtMZQhxj5giCkrGeZpKmodH5Eje4HGv0y9hB2q9A+jiYcWEF1/Bfao4+n3tcs466TAna+elWRGgJG/NSSZrZIZxiCx/MTKKJLV9okrjwPo6+JnecDvuJR/s6Mt5UmnXSOHSHPejJtsMs72KrKlgAk88cUjLeKi1BguIE3EPmxCNIapuGCpp2ZLQWprvAmgNfbehL8hyqLw0V24aZuFXtiMWki37ONxAPUWVqPFMPaP7VsK34CX2vQ6LifWsOuMeYj/z3lsf0uFDQDHmtXZd4MQ7uuTQrMGGNqQScosIiZxVZqfgHeZgqAiEaJgASmuNp9RCMPojqNUN6FnmyoRYK7fakWsIktaijrbCv0fkllPBmBbqWqFx9aJ6cCm6dSaVuRhTElda4xkoHglej4WslfhsYJbHFc/LdcpPnvKeBNfo
 2hZY2Zyf
 S2Z9uVTJhPCGg+PduEBaqroRDbycBXED0S3ufk3WAavytyaKxBk353C95GzIiaxbPawMs1mHHSqHZHC+zen4vXdKLGXqlrtDwm1WYcJQ3pc25qwEGL8KJg1Ujl17YU6ZNdNbOMzKI3lCJINJKp6X1/R3ATFzTn3i5NF25OI6l9mB4frRhur8hJhRCJNOfqIql2jOyB97YDyYBFbFHaqE1WD5EO3go1Q+uKVDdHi+FsRjL5v1QAkSZnNtrBi+QCxaLQf/gePm01HPCpP6wnQwRRm3gfNCv9KUlJtKhDx0VGxhQiH4LF4p4LxjBZi+S7lK2jwRsgNO8tqczJaCD9GLcRVOhrY7qsHzZs4/T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 3:31=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> __access_remote_vm() needs a single page from a VMA it has already
> looked up and locked, faulting it in when necessary, under either the
> mmap lock or the per-VMA lock. get_user_pages_remote() does not fit: it
> hard codes the mmap lock and re-looks-up the VMA, neither of which is
> wanted here.
>
> Add get_user_page_vma(), a simplified __get_user_pages() that walks the
> page tables with follow_page_mask(), faults a missing page in with
> faultin_page(), and on success returns it with a reference and the
> caller's lock still held. Like __get_user_pages() it runs
> check_vma_flags(), so callers need not pre-check the VMA.
>
> A VM_IO/VM_PFNMAP VMA is the exception to that check: it can still hold
> COWed pages that have a struct page, so follow_page_mask() is allowed to
> look for one. Memory with no struct page -- a raw PFN, or a present PFN
> reported as -EEXIST -- is returned as -EFAULT, so the caller can reach it
> through vma->vm_ops->access().
>
> The caller sets FOLL_VMA_LOCK when it holds the per-VMA lock rather than
> the mmap lock, which reaches the fault code as FAULT_FLAG_VMA_LOCK.
>
> Anything that cannot complete under the per-VMA lock -- a dropped fault,
> a userfaultfd VMA (uffd assumes current is the faulting task), a hard
> error, or ->access() memory -- releases the lock and returns -EAGAIN,
> so the caller retries under the mmap lock.
>
> faultin_page() reports these retries as -EAGAIN for both lock types;
> only the mmap caller records the dropped lock in *locked.
>
> A VM_FAULT_ERROR decoding to no errno now returns -EFAULT instead of

In "decoding to no errno" sounds weird. Maybe drop "no"?

> BUG(), warning under CONFIG_DEBUG_VM. This relaxes the same case on the
> existing __get_user_pages() path too.
>
> Assisted-by: Claude:claude-opus-4.8
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  mm/gup.c      | 176 +++++++++++++++++++++++++++++++++++++++++++-------
>  mm/internal.h |   8 ++-
>  2 files changed, 159 insertions(+), 25 deletions(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index dcece7b5253c..cb7245b7542f 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1080,9 +1080,16 @@ static int get_gate_page(struct mm_struct *mm, uns=
igned long address,
>  }
>
>  /*
> - * mmap_lock must be held on entry.  If @flags has FOLL_UNLOCKABLE but n=
ot
> - * FOLL_NOWAIT, the mmap_lock may be released.  If it is, *@locked will =
be set
> - * to 0 and -EBUSY returned.
> + * The caller holds either the mmap lock, or the per-VMA lock (with
> + * FOLL_VMA_LOCK), on entry. If @flags has FOLL_UNLOCKABLE but not FOLL_=
NOWAIT,
> + * the mmap_lock may be released. If it is, *@locked will be set to 0 an=
d
> + * -EAGAIN returned.
> + *
> + * The return value does not depend on the lock type: a fault that made
> + * progress but needs a retry (VM_FAULT_RETRY / VM_FAULT_COMPLETED) is r=
eported
> + * as -EAGAIN for both the mmap lock and the per-VMA lock (FOLL_VMA_LOCK=
). Only
> + * the *@locked side effect is lock-type specific, as the per-VMA lock p=
ath has
> + * no unlockable mmap_lock to drop.
>   */
>  static int faultin_page(struct vm_area_struct *vma,
>                 unsigned long address, unsigned int flags, bool unshare,
> @@ -1097,6 +1104,8 @@ static int faultin_page(struct vm_area_struct *vma,
>                 fault_flags |=3D FAULT_FLAG_WRITE;
>         if (flags & FOLL_REMOTE)
>                 fault_flags |=3D FAULT_FLAG_REMOTE;
> +       if (flags & FOLL_VMA_LOCK)
> +               fault_flags |=3D FAULT_FLAG_VMA_LOCK;
>         if (flags & FOLL_UNLOCKABLE) {
>                 fault_flags |=3D FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILL=
ABLE;
>                 /*
> @@ -1125,41 +1134,160 @@ static int faultin_page(struct vm_area_struct *v=
ma,
>
>         ret =3D handle_mm_fault(vma, address, fault_flags, NULL);
>
> +       /*
> +        * A fully completed fault (VM_FAULT_COMPLETED) or one that needs=
 a retry
> +        * (VM_FAULT_RETRY) has released the lock it was holding. Report =
both as
> +        * -EAGAIN so the caller retries: the mmap lock caller retakes it=
 here,
> +        * the per-VMA lock caller (FOLL_VMA_LOCK) falls back to the mmap=
 lock.
> +        *
> +        * Dropping the mmap lock is recorded in *@locked. There is no su=
ch lock
> +        * to drop under the per-VMA lock, where @locked is not used, so =
leave it
> +        * alone in that case.

"There is no such lock to drop under the per-VMA lock" is a bit
confusing. Maybe change it to "Under per-VMA lock we are not holding
mmap_lock, therefore @locked is not modified."
To avoid more confusion I would rename @locked parameter in this
function to @mmap_locked. I think that would make things more clear.

> +        */
>         if (ret & VM_FAULT_COMPLETED) {
> -               /*
> -                * With FAULT_FLAG_RETRY_NOWAIT we'll never release the
> -                * mmap lock in the page fault handler. Sanity check this=
.
> -                */
> -               WARN_ON_ONCE(fault_flags & FAULT_FLAG_RETRY_NOWAIT);
> -               *locked =3D 0;
> -
> -               /*
> -                * We should do the same as VM_FAULT_RETRY, but let's not
> -                * return -EBUSY since that's not reflecting the reality =
of
> -                * what has happened - we've just fully completed a page
> -                * fault, with the mmap lock released.  Use -EAGAIN to sh=
ow
> -                * that we want to take the mmap lock _again_.

This comment explains why after completing the fault handling we still
return -EAGAIN. I think it's still relevant for when we use mmap_lock.
Why are you removing it?

> -                */
> +               if (!(flags & FOLL_VMA_LOCK)) {
> +                       /*
> +                        * With FAULT_FLAG_RETRY_NOWAIT we'll never relea=
se the
> +                        * mmap lock in the page fault handler. Sanity ch=
eck this.
> +                        */
> +                       WARN_ON_ONCE(fault_flags & FAULT_FLAG_RETRY_NOWAI=
T);
> +                       *locked =3D 0;
> +               }
>                 return -EAGAIN;
>         }
>
>         if (ret & VM_FAULT_ERROR) {
>                 int err =3D vm_fault_to_errno(ret, flags);
>
> -               if (err)
> -                       return err;
> -               BUG();
> +               /*
> +                * VM_FAULT_ERROR always decodes to an errno; a zero here=
 would
> +                * mean handle_mm_fault() returned an unexpected combinat=
ion.
> +                * Report -EFAULT rather than crash: under the per-VMA lo=
ck the
> +                * mmap lock retry produces the definitive result.

I don't follow this logic. If handle_mm_fault() under per-VMA locks
returns something unexpected, shouldn't we return -EAGAIN to retry
under mmap_lock and get the definitive result?

> +                */
> +               VM_WARN_ON_ONCE(!err);
> +               return err ? err : -EFAULT;
>         }
>
>         if (ret & VM_FAULT_RETRY) {
> -               if (!(fault_flags & FAULT_FLAG_RETRY_NOWAIT))
> +               if (!(flags & FOLL_VMA_LOCK) &&
> +                   !(fault_flags & FAULT_FLAG_RETRY_NOWAIT))
>                         *locked =3D 0;
> -               return -EBUSY;
> +               return -EAGAIN;

This changes the returned error code even when we operate under
mmpa_lock. What's the reason for it?


>         }
>
>         return 0;
>  }
>
> +/*
> + * get_user_page_vma - get one page from @vma, whose lock the caller alr=
eady
> + * holds: the mmap lock, or (with FOLL_VMA_LOCK) the per-VMA lock. Walks=
 the
> + * page tables, faulting the page in if needed, and on success returns i=
t with
> + * a reference and the lock still held.
> + *
> + * Runs check_vma_flags() like __get_user_pages(), so callers need not p=
re-check
> + * the VMA; most rejections are returned as their error. A VM_IO/VM_PFNM=
AP VMA
> + * is the exception: a COWed page with a struct page is returned, while =
a raw
> + * PFN has none and yields -EFAULT, to be reached via vma->vm_ops->acces=
s().
> + *
> + * Under FOLL_VMA_LOCK, anything that cannot be finished under the per-V=
MA lock
> + * (a dropped fault, userfaultfd, a hard error, or ->access() memory) re=
leases
> + * the lock and returns -EAGAIN, so the caller retries under the mmap lo=
ck.
> + */
> +struct page *get_user_page_vma(struct vm_area_struct *vma, unsigned long=
 addr,
> +                              unsigned int gup_flags)
> +{
> +       bool vma_locked =3D gup_flags & FOLL_VMA_LOCK;
> +       unsigned long page_mask;
> +       struct page *page;
> +       int locked =3D 1;
> +       bool pfnmap;
> +       int ret;
> +
> +       /*
> +        * Two lock modes are supported: the mmap lock, with neither flag=
, or
> +        * the per-VMA lock, with both FOLL_VMA_LOCK and FOLL_UNLOCKABLE.=
 An
> +        * unlockable mmap fault would drop the lock and report it in *lo=
cked,
> +        * which this function does not relay, so reject a lone flag.
> +        */
> +       VM_WARN_ON_ONCE(!(gup_flags & FOLL_VMA_LOCK) !=3D !(gup_flags & F=
OLL_UNLOCKABLE));
> +
> +       /*
> +        * Validate the VMA up front, like __get_user_pages(). A VM_IO/VM=
_PFNMAP
> +        * VMA is not rejected outright: it can hold COWed pages that hav=
e a
> +        * struct page; let follow_page_mask() look for them, and treat o=
nly
> +        * its struct-page-less PFNs as unreachable. Other rejections
> +        * (secretmem, permissions, etc) result in immediate failure.
> +        */
> +       ret =3D check_vma_flags(vma, gup_flags, VM_IO | VM_PFNMAP);

I assume get_user_page_vma() will be called multiple times for the
same VMA. Would it make sense to validate the VMA only once (at the
level of the caller) instead of doing that for each page? Of you don't
want to rely on the caller to do that?

> +       if (ret)
> +               goto fail;
> +       pfnmap =3D vma->vm_flags & (VM_IO | VM_PFNMAP);
> +
> +       for (;;) {
> +               if (fatal_signal_pending(current)) {
> +                       ret =3D -EINTR;
> +                       goto fail;
> +               }
> +               cond_resched();
> +
> +               /* follow_page_mask() requires @page_mask; it is unused h=
ere. */
> +               page =3D follow_page_mask(vma, addr,
> +                                       gup_flags | FOLL_TOUCH | FOLL_GET=
,
> +                                       &page_mask);
> +               if (!IS_ERR_OR_NULL(page)) {
> +                       /* Match __get_user_pages(): flush for VIVT/alias=
ing caches. */
> +                       flush_anon_page(vma, page, addr);
> +                       flush_dcache_page(page);
> +                       return page;
> +               }
> +
> +               /*
> +                * No struct page: a raw PFN of a VM_IO/VM_PFNMAP VMA, wh=
ether
> +                * seen by the up-front check (@pfnmap) or reported as -E=
EXIST
> +                * for a present PFN. Return -EFAULT so the caller reache=
s it
> +                * through vma->vm_ops->access().
> +                */
> +               if (pfnmap || PTR_ERR(page) =3D=3D -EEXIST) {
> +                       ret =3D -EFAULT;
> +                       goto fail;
> +               }
> +               /* A hard error from the walk itself. */
> +               if (page && PTR_ERR(page) !=3D -EMLINK) {
> +                       ret =3D PTR_ERR(page);
> +                       goto fail;
> +               }
> +
> +               /*
> +                * The page is not present, or needs unsharing. A remote =
fault
> +                * under the per-VMA lock cannot deliver userfaultfd (whi=
ch
> +                * assumes current is the faulting task), so fall back fo=
r those.
> +                */
> +               if (vma_locked && userfaultfd_armed(vma)) {
> +                       ret =3D -EAGAIN;
> +                       goto fail;
> +               }
> +               ret =3D faultin_page(vma, addr, gup_flags | FOLL_REMOTE |=
 FOLL_GET,
> +                                  PTR_ERR(page) =3D=3D -EMLINK, &locked)=
;
> +               if (ret =3D=3D -EAGAIN)
> +                       return ERR_PTR(-EAGAIN);        /* fault released=
 the per-VMA lock */
> +               if (ret)
> +                       goto fail;
> +       }
> +
> +fail:
> +       /*
> +        * Under the per-VMA lock the caller cannot reach ->access() or a=
ct on a
> +        * hard error (both need the mmap lock), so release the lock and =
have it
> +        * retry there; the mmap-lock pass produces the definitive error.
> +        */
> +       if (vma_locked) {
> +               vma_end_read(vma);
> +               return ERR_PTR(-EAGAIN);
> +       }
> +       return ERR_PTR(ret);
> +}
> +
>  /*
>   * Writing to file-backed mappings which require folio dirty tracking us=
ing GUP
>   * is a fundamentally broken operation, as kernel write access to GUP ma=
ppings
> @@ -1197,8 +1325,8 @@ static bool writable_file_mapping_allowed(struct vm=
_area_struct *vma,
>         return !vma_needs_dirty_tracking(vma);
>  }
>
> -static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup=
_flags,
> -                          vm_flags_t ignore_flags)
> +int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags,
> +                   vm_flags_t ignore_flags)
>  {
>         vm_flags_t vm_flags =3D vma->vm_flags;
>         int write =3D (gup_flags & FOLL_WRITE);
> diff --git a/mm/internal.h b/mm/internal.h
> index 181e79f1d6a2..706f7f08fd18 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1595,6 +1595,10 @@ struct vm_struct *__get_vm_area_node(unsigned long=
 size,
>   */
>  int __must_check try_grab_folio(struct folio *folio, int refs,
>                                 unsigned int flags);
> +int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags,
> +                   vm_flags_t ignore_flags);
> +struct page *get_user_page_vma(struct vm_area_struct *vma, unsigned long=
 addr,
> +                              unsigned int gup_flags);
>
>  /*
>   * mm/huge_memory.c
> @@ -1641,11 +1645,13 @@ enum {
>         FOLL_UNLOCKABLE =3D 1 << 21,
>         /* VMA lookup+checks compatible with MADV_POPULATE_(READ|WRITE) *=
/
>         FOLL_MADV_POPULATE =3D 1 << 22,
> +       /* caller holds the per-VMA lock, not the mmap lock */
> +       FOLL_VMA_LOCK =3D 1 << 23,
>  };
>
>  #define INTERNAL_GUP_FLAGS (FOLL_TOUCH | FOLL_TRIED | FOLL_REMOTE | FOLL=
_PIN | \
>                             FOLL_FAST_ONLY | FOLL_UNLOCKABLE | \
> -                           FOLL_MADV_POPULATE)
> +                           FOLL_MADV_POPULATE | FOLL_VMA_LOCK)
>
>  /*
>   * Indicates for which pages that are write-protected in the page table,
> --
> 2.53.0-Meta
>

