Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A27C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 18:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0888E00AD; Thu, 24 Jul 2025 14:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87B298E007C; Thu, 24 Jul 2025 14:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742978E00AD; Thu, 24 Jul 2025 14:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CA238E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:41:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D387E804BA
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:41:13 +0000 (UTC)
X-FDA: 83700025626.25.AB22FC0
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id F0A26C0006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:41:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=j+hMgds2;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf22.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.53 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753382472; a=rsa-sha256;
	cv=none;
	b=jXyWCTJKIJ3RLlsReWJok3CwN6adbG56qop0QVu2ASPm1m9Qxz3nI3JzVb105YGHqwbOTA
	7CnnRbza6AmA5ON2AT+qJeGfBLNjLwSumL5m+rJGq1DulHBrGofJsdfoU+lqRbleYS7lyS
	/3RqLfzZ4V0k7sf6wJP/WfeJyUanEIk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=j+hMgds2;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf22.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.53 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753382472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pdGmQQBULDak1afO6wOGgGVbsIT5jshSzS0GzXEZM9Q=;
	b=Smz64f1n538WjkJs5vWa6XvChzD/YFJdTgqN8BV220vBmpAgKEHszZgnI5xT2ByQzuGzcI
	kVYamvmjfDDbVGJx84B61JHaGPmXdEaslky13UGqG9XNA1wFjq1Vgt7mjaY4VcFG8r2ez0
	ipXPRHENG1wCel2oRd6mfhyw2RolLZA=
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-2ffaa4b4f32so31658fac.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753382471; x=1753987271; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pdGmQQBULDak1afO6wOGgGVbsIT5jshSzS0GzXEZM9Q=;
        b=j+hMgds26HpP33Ycf0maw9wa2Hp5JCdFZx0aVaK5xDMqHdVq65YnJTL73Cdof0IyNb
         5sP4J98+ewj9NCq+caNiGrWD+ragnrD/OPHuGS/HDmrqxRIBsbjd6nQolOrnjqFQ/jl7
         pb92JEMxQwYiRd2z3/BOLtnxXPxvVSl3/Qhq0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753382471; x=1753987271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pdGmQQBULDak1afO6wOGgGVbsIT5jshSzS0GzXEZM9Q=;
        b=GWlxFZNGPMiCiAdTJxrxb4eEHMui2q5iyLp2wJP2c93BCWTDzaWUPcjkMnyn3aTrNV
         m60Ugy8ap2FxPhDe6A4q5Ut68LmpGQx+X/jx+5EnDQSYhi2UdYlxd67Sla7BHVoyUbjv
         eL1cxIv8paNrezURhWc3AgaDAiCEnx4PUYeTAEYX5y03+7WbYbEPHLwBZoEYnUQHTAaz
         zJxyQh0M0PpHoyRJOfFt/xCerqtsKZtZdgN4xx9OL6Xpjno2y9Y7mdGdtRn8ysOEPu/W
         W+k/99irwmHjK6LInDSs5CfGKdF6HN6uIeJ/JpXLFVCuws0LEr2xO9MkJfpK8SzQ+tKU
         Mcgg==
X-Forwarded-Encrypted: i=1; AJvYcCXArlXxPpEgc3cWkehiP1FFuJjS9IKhQF/AWdLYh0iSNforiuiiti4TOMuYxWX9DoNerq3T0dHglg==@kvack.org
X-Gm-Message-State: AOJu0Yx/CEXciI5Fqz4/0Jdcw8h4etv+fuwlkcjjyhDjT43bD8PyCZK4
	w1LnYVQ4S1yg6SLUGMvap2zwC8RVNGDXGMHViJ9/iYWrrFnyGQv9JPYnJf5PVdN6FXf8Q59jdJc
	m70+ddQpQcKuyjPhNfE7wcA6FhLOZAnEM28pzKVyO
X-Gm-Gg: ASbGncvbpwcC6+SZFVrJVMf2mx0ecOCkDhl82sI9QGW8d1cvJugcG7hbXKB7kwP/am5
	xJaBYWAGTV5yv3rB59iicltL81Sqe6/n3Ab1ldldd8ysgFUfdcaEynUo7NxWavT445Mz9BIGDV0
	x8mIpSdg30PpBEl2H7Yl/ic8DMErJM2c0vLUn2lDYEWjiX7xOdAKwdgcT8KgxueDPNWAWLzs3nj
	qqbcmlzW06ZdpsRSsUUEgYTXbKo6G2XQN+P
X-Google-Smtp-Source: AGHT+IEoYM1EWKvzwa2CPrTTDfzZ7Ksf2AOfnilQct0N6oYa/w+7054kRqvJaSR7CoWM8egO7TBFq4f8ZqpZ1JK1c6I=
X-Received: by 2002:a05:6870:d2c6:b0:2e9:fd62:9068 with SMTP id
 586e51a60fabf-306c73182d7mr2083260fac.10.1753382470954; Thu, 24 Jul 2025
 11:41:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com> <f4dda4c4840c69b2ea735bcb6d54ae70d527a48a.1752687069.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <f4dda4c4840c69b2ea735bcb6d54ae70d527a48a.1752687069.git.lorenzo.stoakes@oracle.com>
From: Jeff Xu <jeffxu@chromium.org>
Date: Thu, 24 Jul 2025 11:40:59 -0700
X-Gm-Features: Ac12FXybD_pjPvOBCwcY-hNwuSV51_tRDl2BKwa1m5oQnEMvCGJNkN39CTK8H50
Message-ID: <CABi2SkWgp1M5FWbo8p6_byF+5FzQtcSg3ui0rQ9Mpy6z2_BB5Q@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] mm/mseal: Simplify and rename VMA gap check
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kees Cook <kees@kernel.org>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F0A26C0006
X-Stat-Signature: kxjrbp4fi3onyzkttiax9ybjctdmgp4z
X-Rspam-User: 
X-HE-Tag: 1753382471-847153
X-HE-Meta: U2FsdGVkX1/TWSafJrJrwE+X4gvG34GgQ6tix0FpDeFUXlalFsHe5+E7FREPRF/B439BWDYNKME0EwGMX/68uNboxiuQfQd23iuz1ZRFsGbKLrmLI0UH4gPNM+WEQVfIA6kzDDzTeCwMGGw6hgQhb0an2tZlgP4gtDmjiVzrdYMZie08g/uf2HxzGS4SvWjW4CDkZa8cFAC4gVSlIVAbN4ETG/aEE/0/0H6XTVZhY36jW8PxIUsYAOHkljyg5anWAIwK4ozcbiuW+w97FsgP2nmSTj+WLwDcSsHoxleUquA6WE4gapMWoZ0xjWYqZSlQIi+wYSCu2ojjw9DueY5u0baqTzgb6eDHjP2AWHeBmqiX27XW2rCWnTPnWAb7B07w4Aat+u8CiZIO9GTnMwpXLLSlLm2pXQK5lZTal/7VRLgcLGXXRJN4FBP2YfP9pXl0h6RvhUTKTLuKVGDbKAN0CPTSW+W9rC5tAZyaNplmpLN2Q8JNsZE2551YLRI1O1fj2nE4BIXM34nD1CIQUdMJSf9auH8p4/iZ1eTdPX5EC7dGSJhaJph9zCBv8NXtu+UEamdDzJZyJDK0QnMRnueFOH1YFpkEQkUFbb/xNN6qQG3cU5xLzg+FdybpcuMpgszuh3rMr0gPiAojV/WAfZoi+hNYh09mHk7n4R1ZidCCe5YGeSDu56U1825Xr/ly1tF7dkpPMiqR9/KEMCiKbzLsi9gIA451G3gsNikDv8wtq91jHaxtcQiChG7+GcnLLphDh9eaiYt+2q83+XtLGo1g2PViRWmSs1k4Vuvqfn7aUYoC4GFGF8lxS5gCrwtXaswPoWxtTjX206+jAAWzEjkFGrJwaF1/2KHdIZ2ElY+zWfXrD8E4KzZtdW0xlrIkYrR61vtt5bfURocszPQoE9oYQQ4NneEyZYC3AqGsfTehBoTOlYZJXYQwmhRWGKmmFPpq5QDP3Brs1HgsjEuMri9
 A9qZDrUy
 OmKAj5qKNaqv+sn9OchqqoiPQxhRM2yA2LojEL/TiSpCagWY2BEYQmAS1rI5Z8wkevuGNgB33kvVmfTx3b6OG8+pc3t+OowxN0Wj8oUO3v05CSWq7l0nyAM0YF0+LITzRAdW29comDeqffEfObGPSXVXYQM/u4OR7O6QRd2xoVC/KjABBtHr3WXKnsuzRHkgAUZE6OFKEbCs2buE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

On Wed, Jul 16, 2025 at 10:38=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> The check_mm_seal() function is doing something general - checking whethe=
r
> a range contains only VMAs (or rather that it does NOT contain any
> unmapped regions).
>
> So rename this function to range_contains_unmapped().
>
> Additionally simplify the logic, we are simply checking whether the last
> vma->vm_end has either a VMA starting after it or ends before the end
> parameter.
>
> This check is rather dubious, so it is sensible to keep it local to
> mm/mseal.c as at a later stage it may be removed, and we don't want any
> other mm code to perform such a check.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/mseal.c | 36 +++++++++++-------------------------
>  1 file changed, 11 insertions(+), 25 deletions(-)
>
> diff --git a/mm/mseal.c b/mm/mseal.c
> index adbcc65e9660..61c07b1369cb 100644
> --- a/mm/mseal.c
> +++ b/mm/mseal.c
> @@ -37,32 +37,22 @@ static int mseal_fixup(struct vma_iterator *vmi, stru=
ct vm_area_struct *vma,
>         return ret;
>  }
>
> -/*
> - * Check for do_mseal:
> - * 1> start is part of a valid vma.
> - * 2> end is part of a valid vma.
> - * 3> No gap (unallocated address) between start and end.
> - * 4> map is sealable.
> - */
> -static int check_mm_seal(unsigned long start, unsigned long end)
Is it possible to leave the check_mm_seal() function together with its
header comments? My original reason was to have a contract that
documents the exact entry check for mseal(). That way, no matter how
the code is refactored in the future, as long as the contract remains
true, I won't need to worry about behavior changes for mseal(). This
could be helpful if you move range_contains_unmapped into vma.c in the
future.

Note: "4> map is sealable." can be removed,  which is obsolete, we no
longer use sealable flags.

Thanks and regards,
-Jeff
> +/* Does the [start, end) range contain any unmapped memory? */
> +static bool range_contains_unmapped(struct mm_struct *mm,
> +               unsigned long start, unsigned long end)
>  {
>         struct vm_area_struct *vma;
> -       unsigned long nstart =3D start;
> +       unsigned long prev_end =3D start;
>         VMA_ITERATOR(vmi, current->mm, start);
>
> -       /* going through each vma to check. */
>         for_each_vma_range(vmi, vma, end) {
> -               if (vma->vm_start > nstart)
> -                       /* unallocated memory found. */
> -                       return -ENOMEM;
> -
> -               if (vma->vm_end >=3D end)
> -                       return 0;
> +               if (vma->vm_start > prev_end)
> +                       return true;
>
> -               nstart =3D vma->vm_end;
> +               prev_end =3D vma->vm_end;
>         }
>
> -       return -ENOMEM;
> +       return prev_end < end;
>  }
>
>  /*
> @@ -184,14 +174,10 @@ int do_mseal(unsigned long start, size_t len_in, un=
signed long flags)
>         if (mmap_write_lock_killable(mm))
>                 return -EINTR;
>
> -       /*
> -        * First pass, this helps to avoid
> -        * partial sealing in case of error in input address range,
> -        * e.g. ENOMEM error.
> -        */
> -       ret =3D check_mm_seal(start, end);
> -       if (ret)
> +       if (range_contains_unmapped(mm, start, end)) {
> +               ret =3D -ENOMEM;
>                 goto out;
> +       }
>
>         /*
>          * Second pass, this should success, unless there are errors
> --
> 2.50.1
>

