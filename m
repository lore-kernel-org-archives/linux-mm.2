Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44E5410AB82F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 23:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86F926B0092; Thu, 26 Mar 2026 19:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F8FD6B0093; Thu, 26 Mar 2026 19:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 699CD6B00BC; Thu, 26 Mar 2026 19:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 512C36B0092
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:44:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0150EE1578
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:44:07 +0000 (UTC)
X-FDA: 84589844934.05.B16202F
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id DCC44140006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:44:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rZmcNRmh;
	spf=pass (imf09.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774568646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L68mNlQ2aNktAeGDkbTqCm2ejfgTC0J1kW+t2jekoYA=;
	b=cumCxnXS+s+anQPpF6OWZM2CNI9ZRhich5lo9n1gmjvUbu4Uedz8RD+b9JjU6UDs+3i+UH
	u1cHNxAiC4aZnKO2cprk1Tq6GA4WjXqJO0s18u4K5M0weDje5T9VBWxEb+jT3wBP02Its4
	/Htc/qa9zAhKqneKx7CJ0+Q3EzxtNs8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rZmcNRmh;
	spf=pass (imf09.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774568646; a=rsa-sha256;
	cv=pass;
	b=eq4rbCtoEW5IdJ5PqJjZaZPV2zhw8aELHkfp72FZAj3eWOJ72Euj+Y+v/li+TKqCLiU/rt
	4cW/AYVuJiLrNqnFWQxASeFppBi/Te3R38tSP+u+LahOxqwV0henvAzsPYbc/ffBY+rvcb
	vnFw08GEybd4IZUEs1W0cESdFSyZpU4=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b93698bb57aso272539366b.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:44:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774568644; cv=none;
        d=google.com; s=arc-20240605;
        b=MC/o2odl0UTLm7K63Si4NKhQvGEhFniCCbfXME4T15v8wmSuGPBEZX92Tgn8hOlKmd
         /l8eoYoEl+0GKDNbK9ZqluDbro7kYOlpWYINa79jF3sciSC33uS0XrAiFWaG/0jW0QZ4
         W2vb694ppML6G4iNiW1dYtDR589x2N51ralhYu0eY3x6ysNEbVFgH/hOh3leeRDUGmQl
         4LQ4l0d1JhKAw57+v3V6yLTSV9Laj2Wa4du0Ko06QOIfThS9qadUjYM4UZX2oJy8yd5S
         imqPSOL3h8199ET09Wm+lxS4yjIleEVwu2D1ow8mKyMv5D/AoT2WNXlhKq0ll0BE0vCQ
         iLTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L68mNlQ2aNktAeGDkbTqCm2ejfgTC0J1kW+t2jekoYA=;
        fh=UBrVlyAC+YkPpf+QFfEb1u4b30QKghyOfBFpXgJ7SQ8=;
        b=PJtG3LW6np6tnjkBlkTlR9tXZQqJodb/HvmMmth8QpnX5SpW198ICcBuJqyATkGz/9
         UTOLlowdRPiQNup2IimImC1eMbA7eE6dX7fZMeoBQ+kaN0zMY2scNa0OEuvkSiUknW2c
         2OA28+gXEuzrSHUzq7hZcYEy3HQyPLsnvNZICodU4l1oDF8a2q/g2gMJ9VBhUGrnKX+K
         BYVTEI8bIVC2ib+lyMx5t3pRso7VPXRPPyFGK1nMA5gJA/OXzF/oMYYoYtLn50QqmHun
         VguLEY0YS+7ZPNlCwf1MYh3MQYLNxPUbJOVbr0Nj9MhjVmM8DmbjqgX4Bc5NOkSSpnPn
         /zKg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774568644; x=1775173444; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L68mNlQ2aNktAeGDkbTqCm2ejfgTC0J1kW+t2jekoYA=;
        b=rZmcNRmh4uB4iKvdx+5TerTLVqIA0pqqf7hM2bgtCCLGJJajywwaS1skh++FTvyt2N
         juzM8Z28nQ0cVk/juVi5w2vg69qM5Zgn0ZtySfEIBiqw6/ilJMp0AAsODwqhmksgtm1A
         Kw2JsEBMKDFkq02BfuJeQQtQZt30OjrWp51/jiHP8uDoSvrv84bNhUabMb5Kk9qfEF6L
         T5ZTtShG5BytAnV3rbvFoGLgiXhG2dJbXb3B/v8ZVN2ErqrREX4ZJow5o9c6fGUAsT3W
         uQoJshapyjUogg1SFHPrMEW3pTdZdzw/w21Gfkx1TkZPveVThzaUFGyoc/FRI1ShHnrj
         wm+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774568644; x=1775173444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L68mNlQ2aNktAeGDkbTqCm2ejfgTC0J1kW+t2jekoYA=;
        b=JDKBzgLgQR1qdO1i3AAl86tHnrTd3JJKIK/ZN6OZKeBHiY5yxrWiuYm1dj+0tbfF2o
         Eyzv8vSiJbdmzMxw/9W+QywOMz609RxUqXwtsryP+jrLep2h3STjexIQy1UsSk0YhfiL
         jxJrau2RjQY0azAAWjRWrY8aRM5nR66Y0d1ghTa2A+RfV6uVM2PBhFCnSeai2XengXF3
         UtLTTjjFuB6rNRkysbfsHGZ8Nke4wRlv4u36qkAuJ++7/11RbD203lRAhEOj/ZoVM4yZ
         y8BvjnT8Z1f6nA7tshB20UPRkdvHt9eXWWtPYxwLgK38jLMy6vreiJRJ7uKIAqRxtQxc
         XWeA==
X-Forwarded-Encrypted: i=1; AJvYcCUCTSRr4CxPaFIMPjb88VRz2hZst/TPOwreK8/66PaYPQryUtXg83RjYboh6NBcKPfwIrDFMacMiQ==@kvack.org
X-Gm-Message-State: AOJu0YyusLY66e8768E15mr/z/BArcOakcyXrSL5tEVLwfwtHCqftgyj
	0+5Up7GqjCse7vb7m3Ew3V7cu2bwE2xRqYqEgKwayhr0Jpqn2lbX1Nw/Fw4NeOjhIOFxuvRZPEK
	Cr1WRUX2cQW5xzcYdeQO2ldhq1G3ehsAkIfwSXBAI
X-Gm-Gg: ATEYQzz5YOYIKd9+wJCULYUhIBEcZO20RfyDEqz0xOG0Mmhxxs/GPGo/AXJHDpnYGOT
	0b3Od3C4kGb5CgZ2gwH8AAk6NrhMkjL1C4o0/v1Sk2/J2hr4Gjgt1oWdtO2BOBYbo/iVK+M57/E
	Ea3ZWxozNpCFNLY3KxLNrIkbRwOYGZbXgxHuBPGmvSDrH3/R2AilRskhUzfif63y0qqGRgSxiMo
	YjhkQwW+E1WOSFfm351HAf/1f6YovGiXzW7s/9meRTVAT5HOdTSnoOfaZxGbJGY3tbmy2l/o5TL
	1KC1/1lzliRNzrWUYjPRBne+MiXrTr3gYM9/j9+Sf5WAuW3VfRKnu8nkI58CTz3xOuka1g==
X-Received: by 2002:a17:907:869f:b0:b98:783:e3a6 with SMTP id
 a640c23a62f3a-b9b51c182f0mr11471766b.2.1774568643684; Thu, 26 Mar 2026
 16:44:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260306171815.3160826-1-rppt@kernel.org> <20260306171815.3160826-9-rppt@kernel.org>
In-Reply-To: <20260306171815.3160826-9-rppt@kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Thu, 26 Mar 2026 16:43:27 -0700
X-Gm-Features: AQROBzDUH86W_vbaQ5IFMdgkIth43YWmx8PcWXXGMYiTu68hLc064Iju9vJWs6M
Message-ID: <CADrL8HWLnuQHEPFN9SZbAd_Lq1USJDV=Di4fsQuztwp4v5oXOg@mail.gmail.com>
Subject: Re: [PATCH v2 08/15] shmem, userfaultfd: use a VMA callback to handle UFFDIO_CONTINUE
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Oscar Salvador <osalvador@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: DCC44140006
X-Stat-Signature: i16y77fxuksq8eh8tttc96zgoerajeso
X-Rspamd-Server: rspam06
X-HE-Tag: 1774568645-673907
X-HE-Meta: U2FsdGVkX18ye9KA/udfe0TZyqv3GqGReR5kdaivFjXhn8r0FEFaDvWGsJLip3a66L6+y7AR+h+jlYZTajt3HGFLs1YEnrHBkYUyDy4zzaf1yhLtKoHwHgitbNoJHb+k2EBMc4S+/Ii1jqdPTjMBS5Sf7JwJSEAdP/1QAvXJxIC6FvjT/BuOwes2AhU2+Ywnw0CdmLMnINXwRG3U2kq8vC/F+TTYu3V9Ai0VHlOhCxBhn9jbHwKgAYo9A1fe1CLu1CA3N1RddohBDx8fWVBw6KA8auf3sOkTtasrT43ErkNRQF7CnrQLnon7dX9rivk+T4cGuYybX/Y4zP8GNbsPaJEwtIZXbFhYkBFzaKhHcoU/4HnrtOf4prw2vFL2h5mifDhZeltAxAAsFoTbCcD/MXEO72fx2pb1LmSfovjmYPhf4FppVI3L09/5Dm6nzT3PgjKHr+2yMjmXYrVPPR03fStqoxFYGb3jqJWgegqF97WGfuNMAofG23X51a65oWH3K09hUOl128DN5nCQp4rDbNQuBqYVudez1yOn+PQl0QScGBZmC3327QE5V1ojgmYfCmLI8h9S57o4AEUewnGnoJlBealvFVuu/fpVQGbEx/pGDiSFZCen0cusVGIrNwKdqW1ZgWdLy9IVePILJ3+c9rPuON0wKKEOdBC7gK8vdTcLG3RNAxcicg4f7sxDf1TsTF1VsUaxBJ0tR0WLYDqil0E0EvjKt0I20FKqY+DeOiQ9XS6pYUlNNW8eYpcTeLsM5IGd8nZY8+Y3Tb3HXFpPTVE54w2p7bkNffdOwqYMaAY025VW4nJ3UGvy4k+4NOwty84wWTXeVElwHdlohGLKwQle4D0Uw0J4LOHlbqmN01xi2F9SjWtPmKWSL/2NQCJOgzAqLklJy+w7AOzFVkDQqdHdpr+kds0uUfSwHmtKqAKHs3ZiqTOWU0VJOYjmtlyIlRyJtxbTPDbX9tlxiNL
 QbhPNUe3
 NZTX0/KCBH5djqbk5MdffeI+XpNb1rhUkKHih24q6Lc0vZwq7aRmhpkTVnlbrDS3AHsx29kLrDEqAKgbmC32h0ZzVPJeGEBGtcb6fVc1cyyz9ENUSMBVsy/+KpopO3Bkm0zZAaRJ3yphbGiMGWhro8V3h5rvUcd+ceKeU0F3tElTzfY95odhb7fOCQWhNbIdzqudb7uXXFgRXV84uzSTT9oJNl+WD5a8+ece7tOJXCr2LoyUWszdIUQ2tUwwe5bfY7sNISJ8PwKbWgfJcFKHspQFzmcQmpjCB4zAGuKrHNftFpaeOCezzDPXFNGGoC1+Uez8Lf+qpoyjRzKwPNviKQhaDzw1mfh0JAGyO2xHtd4nDlGZjwv052Ffp+5cLUaFupz5JfoKAqN5iPZl4WZodybuuhuScTt2ATrP1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 6, 2026 at 9:19=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> When userspace resolves a page fault in a shmem VMA with UFFDIO_CONTINUE
> it needs to get a folio that already exists in the pagecache backing
> that VMA.
>
> Instead of using shmem_get_folio() for that, add a get_folio_noalloc()
> method to 'struct vm_uffd_ops' that will return a folio if it exists in
> the VMA's pagecache at given pgoff.
>
> Implement get_folio_noalloc() method for shmem and slightly refactor
> userfaultfd's mfill_get_vma() and mfill_atomic_pte_continue() to support
> this new API.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I found myself asking why HugeTLB wasn't included here; it's because
we call into hugetlb_mfill_atomic_pte() pretty early. It would be nice
to have HugeTLB implement get_folio_noalloc() and use the same path as
shmem, but we don't have to do that now.

Feel free to add:

Reviewed-by: James Houghton <jthoughton@google.com>

> ---
>  include/linux/userfaultfd_k.h |  7 +++++++
>  mm/shmem.c                    | 15 ++++++++++++++-
>  mm/userfaultfd.c              | 32 ++++++++++++++++----------------
>  3 files changed, 37 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.=
h
> index 56e85ab166c7..66dfc3c164e6 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -84,6 +84,13 @@ extern vm_fault_t handle_userfault(struct vm_fault *vm=
f, unsigned long reason);
>  struct vm_uffd_ops {
>         /* Checks if a VMA can support userfaultfd */
>         bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_f=
lags);
> +       /*
> +        * Called to resolve UFFDIO_CONTINUE request.
> +        * Should return the folio found at pgoff in the VMA's pagecache =
if it
> +        * exists or ERR_PTR otherwise.
> +        * The returned folio is locked and with reference held.
> +        */
> +       struct folio *(*get_folio_noalloc)(struct inode *inode, pgoff_t p=
goff);
>  };
>
>  /* A combined operation mode + behavior flags. */
> diff --git a/mm/shmem.c b/mm/shmem.c
> index f2a25805b9bf..7bd887b64f62 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3295,13 +3295,26 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
>         return ret;
>  }
>
> +static struct folio *shmem_get_folio_noalloc(struct inode *inode, pgoff_=
t pgoff)
> +{
> +       struct folio *folio;
> +       int err;
> +
> +       err =3D shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
> +       if (err)
> +               return ERR_PTR(err);
> +
> +       return folio;
> +}
> +
>  static bool shmem_can_userfault(struct vm_area_struct *vma, vm_flags_t v=
m_flags)
>  {
>         return true;
>  }
>
>  static const struct vm_uffd_ops shmem_uffd_ops =3D {
> -       .can_userfault  =3D shmem_can_userfault,
> +       .can_userfault          =3D shmem_can_userfault,
> +       .get_folio_noalloc      =3D shmem_get_folio_noalloc,
>  };
>  #endif /* CONFIG_USERFAULTFD */
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index b55d4a8d88cc..98ade14eaa5b 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -191,6 +191,7 @@ static int mfill_get_vma(struct mfill_state *state)
>         struct userfaultfd_ctx *ctx =3D state->ctx;
>         uffd_flags_t flags =3D state->flags;
>         struct vm_area_struct *dst_vma;
> +       const struct vm_uffd_ops *ops;
>         int err;
>
>         /*
> @@ -231,10 +232,12 @@ static int mfill_get_vma(struct mfill_state *state)
>         if (is_vm_hugetlb_page(dst_vma))
>                 goto out;
>
> -       if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
> +       ops =3D vma_uffd_ops(dst_vma);
> +       if (!ops)
>                 goto out_unlock;
> -       if (!vma_is_shmem(dst_vma) &&
> -           uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
> +
> +       if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE) &&
> +           !ops->get_folio_noalloc)
>                 goto out_unlock;
>
>  out:
> @@ -577,6 +580,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_sta=
te *state)
>  static int mfill_atomic_pte_continue(struct mfill_state *state)
>  {
>         struct vm_area_struct *dst_vma =3D state->vma;
> +       const struct vm_uffd_ops *ops =3D vma_uffd_ops(dst_vma);
>         unsigned long dst_addr =3D state->dst_addr;
>         pgoff_t pgoff =3D linear_page_index(dst_vma, dst_addr);
>         struct inode *inode =3D file_inode(dst_vma->vm_file);
> @@ -586,16 +590,13 @@ static int mfill_atomic_pte_continue(struct mfill_s=
tate *state)
>         struct page *page;
>         int ret;
>
> -       ret =3D shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
> +       if (!ops)
> +               return -EOPNOTSUPP;

Perhaps WARN_ON_ONCE(!ops)?


> +
> +       folio =3D ops->get_folio_noalloc(inode, pgoff);
>         /* Our caller expects us to return -EFAULT if we failed to find f=
olio */
> -       if (ret =3D=3D -ENOENT)
> -               ret =3D -EFAULT;
> -       if (ret)
> -               goto out;
> -       if (!folio) {
> -               ret =3D -EFAULT;
> -               goto out;
> -       }
> +       if (IS_ERR_OR_NULL(folio))
> +               return -EFAULT;
>
>         page =3D folio_file_page(folio, pgoff);
>         if (PageHWPoison(page)) {
> @@ -609,13 +610,12 @@ static int mfill_atomic_pte_continue(struct mfill_s=
tate *state)
>                 goto out_release;
>
>         folio_unlock(folio);
> -       ret =3D 0;
> -out:
> -       return ret;
> +       return 0;
> +
>  out_release:
>         folio_unlock(folio);
>         folio_put(folio);
> -       goto out;
> +       return ret;
>  }
>
>  /* Handles UFFDIO_POISON for all non-hugetlb VMAs. */
> --
> 2.51.0
>

