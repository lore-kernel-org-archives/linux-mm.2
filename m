Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F4DC87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 17:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 960526B0095; Fri, 25 Jul 2025 13:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9397F6B0096; Fri, 25 Jul 2025 13:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875BA6B0098; Fri, 25 Jul 2025 13:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 773876B0095
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:30:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1FC3E80898
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:30:24 +0000 (UTC)
X-FDA: 83703475968.01.2629A49
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 38483C0006
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:30:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="g/Vnyqya";
	spf=pass (imf10.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.210.53 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753464622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQ0Bu/BvQWMgs0y0itEC4STNhBs0pVrCSveit39+ORc=;
	b=sAMgl71q26AV9NYnQ8X7XcxEtiPqMGIZJemTZLZuDQKwVxA1BsQ0qGqvtWmVIWHxov70FA
	27rF0FompEEm9riGzYimmhSYYgrI21Axly2EzPnNLm7U84zAl5dZ4221L921UzHwB6znVn
	BmtC9liYSoZ0Lnk+Y7VsykVIr11sxPI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="g/Vnyqya";
	spf=pass (imf10.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.210.53 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753464622; a=rsa-sha256;
	cv=none;
	b=xEM9wkOHUQ9R/NMm2I4RL+z3MPqZW+Q7gmWNpZ+KUbiaGbyZphbMZJJkP7asbJitQc23ae
	gTdIzWi+SRuc82RGeM8Sre5+64AjAFq2jww3GCcUFp30r37J4rQYJUPBlzBSIurLduJylh
	dIzjmqatvvyKRdk+Ba+97akCVntMsDQ=
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-72c02e22d96so142357a34.2
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753464621; x=1754069421; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zQ0Bu/BvQWMgs0y0itEC4STNhBs0pVrCSveit39+ORc=;
        b=g/VnyqyaEn+vZKE/Jqu09u75vKGMnzdS87sT4mN3g6ypbZTYYQT8axOAKDu1g+MNk7
         76zIIXa0hXYfW9ION/DHtgsTAhxqEJcbbVraAS0k1l1NPnpUkomFIDpGQfmhvh9zzQum
         jL7QIo6cOTT1YEdTR3vXrYNUUlncYTwHDmyJQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753464621; x=1754069421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zQ0Bu/BvQWMgs0y0itEC4STNhBs0pVrCSveit39+ORc=;
        b=EQbyk9uV9a4OB6oyHtf6ooCIvhp8bkd8/loDT2c6wwpZtdRfbEmA/IdkEJy7tyVqsf
         X3BA55THPCDCBoYY9hXdNcqmZa/eDTlvzQWeQSVJjEBMLQhoHnFmOTQp4q0HKs8GvHfH
         v+3I1UpKW22L9eWL2Al8f5v0WHqjCh2M/FBk4hf8Sbl/IzGZXMuzu+xusOM/cS9R0ryg
         HeKw+3sjxx/vvVVN5w6zagQi8cmklYadihI08Q3itLtKqJmAAPVkZwVajarm95dEO1qV
         lzibA9THZJmn/u0Ho66ZV8rxZTcfRKFnmbYLP5ktAUFzuoLCuvmJFRLqR6WYOxSMa3lA
         dvvQ==
X-Forwarded-Encrypted: i=1; AJvYcCURbOr2cqgxHsoFMvESVY92/5gkPoef/+XIaWVmouIgkd/ZiAJi88cefr/8w0aMt9ZY8pC1xYEjXA==@kvack.org
X-Gm-Message-State: AOJu0YwkcsJj8EOgHqQRCGPfoxxutrXL6Y2wXVL0Rzqzf+9NXQ8/4XjO
	ginY9DWFWC6oeQssC58Js19GvtfOa5KwiviTuoUMiMGJ8qXy7iew2VvtN8opWOoeIyFUa8w5z1Q
	z7+E7aFIH7duZ/5QaLF030QzQoNIsPQ6toZQzTc2D
X-Gm-Gg: ASbGncuu6KtK7VVTtIpweoTmcUdF9PZaUqFgLeH7Z/afi0RlJYd4nxc9yAXCfugwf1V
	qV+RgnrKM2NtSwdKDKZD7ai9+KD1Nf0rg1M6nI7EJRGB3GKtcl0yRNn+o8AiLNEoSsczDjGizZc
	TfvhfIpSyjwpPvVYq6uNg79Q3r4xvyLyh5aB2nFjCSM90wuG4A/S+YhP+Ozk2sveWSa+jrN9vbk
	j6axqbbaoeW0QlUV0WIvLsrZAwgXbXH7SWaM8yd2Rw=
X-Google-Smtp-Source: AGHT+IHnkJmphoDh/b+ws8PYtxQHNySEY2goMZD4LausV3pkCZsARdu+y7zcV959yuoTBZwdv797T/qXFyB5w/Sg2pc=
X-Received: by 2002:a05:6871:610e:b0:297:2582:c66c with SMTP id
 586e51a60fabf-30701615412mr696302fac.0.1753464620858; Fri, 25 Jul 2025
 10:30:20 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1753431105.git.lorenzo.stoakes@oracle.com> <dd50984eff1e242b5f7f0f070a3360ef760e06b8.1753431105.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <dd50984eff1e242b5f7f0f070a3360ef760e06b8.1753431105.git.lorenzo.stoakes@oracle.com>
From: Jeff Xu <jeffxu@chromium.org>
Date: Fri, 25 Jul 2025 10:30:08 -0700
X-Gm-Features: Ac12FXz_xBH_L3lj7AJvo6vEKgPTtF4nqiSbTlrCYQYJlbOo0M4g2knFYQTFhzg
Message-ID: <CABi2SkVeHWt+SKWWodXUNhXZi1Wv9YazEOGWEUJLvgPbopqBrA@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] mm/mseal: simplify and rename VMA gap check
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 38483C0006
X-Rspamd-Server: rspam06
X-Stat-Signature: 68jmhx8p8duxp1uwbsy5oees76xawktr
X-HE-Tag: 1753464622-889921
X-HE-Meta: U2FsdGVkX1+0G1/UcdmD/D34xXvlnwS4S1wTp6TFgKsCSsrnlB8RAN+bD5JCwuN26d63R02lpJ2PWRy/giDopV77CX/0hnz0kBQ0dhJgLjwBrQ2wXXR+zNDZyhXzQEKzeU1sv4joX5e0Iykc9H4CEQpaLWy6ZUBLXyGTvtDf2+Hi1YxaYIM30TU6mWfEPxsbvYDl7XTeuU096P7R0jITidY5gXc6Zks9jVj9Y8mIpT//GJl3rN93oEItwZmdqP1pRruhInwdkLdl7kcpzZyOBa123JL4UWGWI0yX3Xn/78NGXz4n/bnP1lWVn0qjlhBpC8JaSKWxDR/SlT/qde143cn0sWhdt6L6yAPwqM6v9SpAi51C3f/aWjLcLDvCUYphn3JeEWqBkapDightCMdAhZE4OexzFyD4h633TfG0KEBnOSXZ+mG72HAHFcvCLiDA1uRLhiEObbfiOBIcF9e1MLXMO8afM+2VUhfHsfnsog9Iy+FHCFtHHmCBDOdzIwVr613WsDRU7hdP1M8WmS+kk4BsqilSPIJ6ImERtbSSvYIjO7BCQL1YhQHqfdcq2iBGzSa9gY2wxQUwvkZLrquV8z41XECSmHxPi5oPla7Ulrcg+wuU6zu/5V0NEoNJvpOTOBcZ68T+4t53IcjrvLf9uNojHSbd0CkYYACkucKD97fz9NfcU2U2BajVnFg1pec4xJbzg/NWv634zEmzEe2ks+8uXZLaC+igl33irFQCAn5cU92qT4b1+1U1oTYfyGXBUkXJnansTFqqqeh1IQA3U5JjzqwYoE1MHfeWDhExDbkMt/qEWQpqp9h3MwjUZfYwVptexmWeSCLCYjf8o7cvSei3W0CCZmmVKKtkWquZoxldwlW5YYIGZApkoChwh8GGUvzkO6I82rxxDiYEd8LiBKuL7vK92shAsov6y3AvlNq/6WwBrOL7wFpJlJbL2w9x+fySsdQCgRr/iGPeeDO
 2SC/wUa8
 R1fBgzBcrPJgLTfbwPU86242fZ787+Dfr/JLdjGZiLHXqWM9NazZ1+UXco4qTol0uf+PeqiuqYmbJmJ+aDjfcYb9tEbxancfFUFq7OK2g2iBwjPVy4sl0eMZApHxqUHBH3od4aL28G2wnOOjdGJaa2lMfc0vc7TS9uREI+/BxWmQ0hF30mTogzTh2HG84ibe0Wp1aaaTpiOGuVoaROjYtKg7UnA8M6ZKKjtapL5QquiO8YLJzj+e1fkFWb/4K7+y3Ohd8ZcmA/6HH+wKYPpZ2yENgqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

On Fri, Jul 25, 2025 at 1:30=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> The check_mm_seal() function is doing something general - checking whethe=
r
> a range contains only VMAs (or rather that it does NOT contain any
> unmapped regions).
>
> So rename this function to range_contains_unmapped().
>
Thanks for keeping the comments.

In the prior version of this patch, I requested that we keep the
check_mm_seal()  and its comments. And this version keeps the comments
but removes the check_mm_seal() name.

As I said, check_mm_seal() with its comments is a contract for
entry-check for mseal().  My understanding is that you are going to
move range_contains_unmapped() to vma.c. When that happens, mseal()
will lose this entry-check contract.

Contact is a great way to hide implementation details. Could you
please keep check_mm_seal() in mseal.c and create
range_contains_unmapped() in vma.c. Then you can refactor as needed.

Thanks and regards,
-Jeff





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
>  mm/mseal.c | 39 ++++++++++++++++-----------------------
>  1 file changed, 16 insertions(+), 23 deletions(-)
>
> diff --git a/mm/mseal.c b/mm/mseal.c
> index adbcc65e9660..1059322add34 100644
> --- a/mm/mseal.c
> +++ b/mm/mseal.c
> @@ -38,31 +38,28 @@ static int mseal_fixup(struct vma_iterator *vmi, stru=
ct vm_area_struct *vma,
>  }
>
>  /*
> - * Check for do_mseal:
> - * 1> start is part of a valid vma.
> - * 2> end is part of a valid vma.
> - * 3> No gap (unallocated address) between start and end.
> - * 4> map is sealable.
> + * Does the [start, end) range contain any unmapped memory?
> + *
> + * We ensure that:
> + * - start is part of a valid VMA.
> + * - end is part of a valid VMA.
> + * - no gap (unallocated memory) exists between start and end.
>   */
> -static int check_mm_seal(unsigned long start, unsigned long end)
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
> @@ -184,14 +181,10 @@ int do_mseal(unsigned long start, size_t len_in, un=
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

