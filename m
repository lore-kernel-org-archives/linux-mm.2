Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1E89D38FEE
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5790A6B0093; Wed, 14 Jan 2026 11:56:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53CCB6B009B; Wed, 14 Jan 2026 11:56:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41E1B6B009E; Wed, 14 Jan 2026 11:56:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 314786B0093
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:56:17 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C98A05944C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:56:16 +0000 (UTC)
X-FDA: 84331172352.29.9D2460A
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id BAF8220019
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:56:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cVdGhete;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768409774; a=rsa-sha256;
	cv=pass;
	b=AzeZOIuC5Wj4jS1la2YYtIeSqZLQmGY2q9kn3Rxi3vgUsWoeiAtK3ElCvOyuBdxBVEzGFK
	o+C15XOhMYpM352HRa09Z0/Tb+0qBe3l3SsKm0SkWPlnl2tJ6GTC4z/WqxqaVH6AkszKqr
	MHyxD2rCJD3ZiupVBJBsqo2BYKiiXLY=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cVdGhete;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768409774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yTF+36UIWJnydGFbwFd4vW3/jAnpAQHtZMxf/xj0fXk=;
	b=cZtgftwrI4+PcjTYXlZb76Hx5ne7h6f2+GiFfpvjvfzCAXuHdwjtjstNCRhpJpTFoPh4g+
	b28zLq99BkdKgSvqqrpawV824yb5nmWLxuQMHvJRuQnnUbRkD7r/l71PF6TM4X+wJ5qJC/
	kkpaPV47YGzg6YxARGDis1OigS4TP/M=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64b66d427e9so9964a12.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:56:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768409773; cv=none;
        d=google.com; s=arc-20240605;
        b=VDNBrFL1OWdar/qPjFyg33h3iluh7th8OUdTmUmFeibLrRiF5Ijogn4hrURiNVVOwi
         N3MKMBnUji2zbQ8/2T3WVds8DwkNVaL7YE3vcIe17GR7QvYsvbjBa6RUvDs2zxpS4MJK
         YlydyHr4pB4pzs3yN1Brl9gjfKLYbUt4qoDRH8Ts03AqStjfL7tltq1RlgY9PqcLQm51
         sksq8vqphJWiF7qMbotFRv7KoqcGXfxxhMmfpghzrfSFgu3RMAnC1IxHNEs1uo6KlN2n
         LkX47jYY1G9cttrYo522Yr7GNdHDpSMzoLKFAIBNTSsQde4bcDwoEAaLbWbYHsrbo0lm
         fxWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yTF+36UIWJnydGFbwFd4vW3/jAnpAQHtZMxf/xj0fXk=;
        fh=GclaYKwtLTWBYZy4OA6daxuawLReufhqC3goLy+3zBo=;
        b=VwPPnfUtvw18UY8tVthJe6eNqAkZvGvULNlDncqh0vYHyIMLpn6fyASy0sZtdKJDw3
         biL3Plu0r2kqgOWU1lneRPK5AmsCKB5g1HumVIsw5RBEPMSubPGgb/rHmKNrENsBh1JD
         EzN8MgZPOodo4Xhh62jsgpJ7ddNyqoE8VYzhfAnwqTJjP274XRvjTJYw79RRLMSrLfXr
         lw5zm1BMe/9oORf2Z7cV9hm8mquH4MdwZQTCaP+OuJhI9Y+zV77UTwlWm2tA0kEArPp1
         zKQX2beIowJ18Qtsy4PCjwlTXFlEZA+ayRsEg8POcjBk9erPuruJWGT0S1l+mN7z6IAs
         SMyQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768409773; x=1769014573; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yTF+36UIWJnydGFbwFd4vW3/jAnpAQHtZMxf/xj0fXk=;
        b=cVdGhete2IknUX6F4Tt1/ulQ80jDPYHw1HequKRE0L5IjCi//rk7A3vVwr8m4inT5B
         gm1Jr9fAwQfOLsctUonEkJcbT73cqSG9MTFr1i+WkX37+AiDChTiWN7p00kY6ICIIBdF
         aAGcTAksMJJSL3kSAd7v7pp/t1oUPFcUamzA40a1IhqGTaAn9JqChW9LPI9r+tfngLg4
         Jr8+M/WX1006guUMBbeKAcaf3zfd0P69xiG70e3WpUswcBtYF3344U2DtMdZMFbt8V6P
         5T4V3vMrWVHPxpG5fSxHqk7WIVifMst/LZll2Lc0bCuwoMrUAaq10DsnUm7SyCWYq33A
         heKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768409773; x=1769014573;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yTF+36UIWJnydGFbwFd4vW3/jAnpAQHtZMxf/xj0fXk=;
        b=b5y/ryJhJtfFSq48SlDIocT3xQh0gQWMuUaTpsEgR5ktQCJk0RA1d9+z4Lbu1iMmtw
         N0oAlYqtjM8oo2atn00kcLfFhBQEiB2sfe9l2/a3Q0+qAUBv2qxtVrdS5AMw/TKVMwh2
         zIC0IcsVRexXY/jawqo/eMPvxs+mPDGUWgB9bMQpZLDZEK0b6+Fu6CKfDSnfHkNyjvs1
         0N0CZWZI+gKGeH4+wUE11Wd5sB+XmGm/rUmYPZH5RHdO7KdXOQ1L2t7uMA++2JKw8pjr
         F0Jm3KzDgSJl+w391itPsA6BJgsioL+6OTZRmsvvIst0tLHAtml704Fa8cghUS/V32pJ
         aNBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCbcjjvoBRfl7NExVkKIXOdj+7Uyw71yc1TWUnewm/mT3nhZ+QFnKVKABU6e1Of7EzXJ+W8TJu4Q==@kvack.org
X-Gm-Message-State: AOJu0YwYVZCApf80AqvnVP4ajbSg7x6yDo0ZArbWMgDimqexaFL5An/9
	21V7E3Y2NKf8XCwrQCYx02gU+3qrBAstkNkeYsPgetZ3If55cCVIJpKknMv3tRYsAHXpQje/OiL
	TZ9UFTeBWoSkGn1220oxCnuuorHGrBzLTQ2HHQte8
X-Gm-Gg: AY/fxX6aZUKa5KCCCgXMBb4vfJ/jmH75s4sd2vI8ymic7XSt5qmAj90fokM4XhQWFlK
	J9by+oXF85FZ9jQhnsAI4A7hIOovW8+MhZ0LPYfsCa6Nn5s7avmMT0hFOMe1q9CA2zcg2+mSfNO
	BQHc47Rq1Y2klqW1E0uDqRs4dDJr/Xj5CS8k1F6ZyiWQKJf11mLRee8AIw+mpDTeO1A/rn28x4S
	pJqObP1A259sy3ENwEFM1OAqVtRUbDAcMFhYZ6djJdLpGESAMfm+DSLqQnwj+JAhePAObCEtjsy
	Yhw4EXoIGRwR3fNhS5BkJww1sA==
X-Received: by 2002:aa7:c0da:0:b0:643:6984:cee9 with SMTP id
 4fb4d7f45d1cf-653ebdf7372mr40365a12.12.1768409772913; Wed, 14 Jan 2026
 08:56:12 -0800 (PST)
MIME-Version: 1.0
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com> <9b5a438237e4ea3b19a986a4f8fddb8848cba54a.1767711638.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <9b5a438237e4ea3b19a986a4f8fddb8848cba54a.1767711638.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 14 Jan 2026 08:55:58 -0800
X-Gm-Features: AZwV_QhSbEnB9eAMxxEw_e0l9AFigUqaVaWXSMzZTtnKutpaOknTrgr1OmB44RM
Message-ID: <CAJuCfpGcdZE_Qnm4c7MgyZfZr7fepXuJkc=6ucwUNwUo_JjU0Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] mm/rmap: remove unnecessary root lock dance in
 anon_vma clone, unmap
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BAF8220019
X-Stat-Signature: wkkijo6j18deipostaqj8hsascu6kuhi
X-Rspam-User: 
X-HE-Tag: 1768409774-331855
X-HE-Meta: U2FsdGVkX19usAHHBH6LHNdBtJvN7xMnW1NNuwLNEVyobgui7S48iQbGlLGMj2uFz+q9olRtHEwB2+98b4DO237Ie5tlYjrkQfD7IGLkCrJvDknlpEFVMTQvRyeK5QQTfar++IsCEDPzz4RkmRoxrGYRsFzieuZTRH3ZOf7txcBf9pLa9INE4Gp2My3/V5IRmQAnOqeupu0YWLDmaT6PVBWaW6ZsxkUUwMdOidBthjoFUf4o6yDw9z9Y8fgTKAHkXbbJO5dwblCJ3faaVLZW52oOnYysGHcqbHfcllYKmNK+qluwzloPheGOVBY3iJxP6vqeXGsqEVdorYMNzUpAGy9l47jGnMhM6jp/afajR5ZChh/HISCAhQvVogN7L5u/G5NcGlR4VT52LVrzCCeMkdu3Q71EwkM+SAoUium85/4GlFLYari4t/H+zdV4a6BIXiv+j/JgrdHWyP7Ogw4A8NXU1oSbOz+aNNmRRZcBYB8dMaMlCIIaWNp0BIMRhyd2bPbEdfKJTjxN4Ex2uLn1RcwbORvqGfj5tsSIpnEdhURLri9Y4aiQPaYpNbjjctYdNCWXgBKdrK5TXHPCXOOWe0B0RBvvcfFPuhod+ANjxutjC13ZTPeX+trkPvoo5JEaeVs1SK3eKXN48/MIefpMAbMZODqRrs2DimdEfFrX9SfsKUnV8+ry4EwrmCLlkjNNmGmvTtE/gHOXG0mLRUvOuyZyREjHoTbMdasgYhgcGGg1DhJJIVua8H5GhxX3Q7iH3eSlPwV3QcE7PsX1Gdd4oiZgk45hBRum+5fOimxhdTjpYHNZ/vhSXwpRxMMyzAdvaYLihs55WMkYFUtE/3MmBHN7+Fh9s1XptGCjtNy4qOIBO1MZT7Sv/qtvP/W1/5PFFx0eGLqHOMkWYYid5jQUp4fDaXhtgfbv3F9cQCLpGKKMHvcnS9n2kFqE1QazKUMF3lrvzmc5bd8zWtH/5TO
 zqqv6dxV
 IfbFt6qRRmEqxBdL2h093ZS9ZeFpwDyDXohxZwncK3/8a58BqvGPybQx6OdUQ4sYdbfNQZrtWZiwaTlnyGML1zG5q5D3+/cgqGV/Xwh12epuZeQc3UUjHCvdS4L7B5GnbQXDahcuI0Q2bi6i9g/Fnu5Le6LAtgfSm+azjmXdMKiFlMPucIt0JxaQmXll3RzS/LeELSZK2kTzA8NO8Kcj5gJbGKDYz9u5RNwYHa7NNcJwkr6Aq5Nw2xHlIaelZvyaFUTEEUurXoHmzWdYKZ8L9xaqXcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 6, 2026 at 7:04=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> The root anon_vma of all anon_vma's linked to a VMA must by definition be
> the same - a VMA and all of its descendants/ancestors must exist in the
> same CoW chain.
>
> Commit bb4aa39676f7 ("mm: avoid repeated anon_vma lock/unlock sequences i=
n
> anon_vma_clone()") introduced paranoid checking of the root anon_vma
> remaining the same throughout all AVC's in 2011.
>
> I think 15 years later we can safely assume that this is always the case.
>
> Additionally, since unfaulted VMAs being cloned from or unlinked are
> no-op's, we can simply lock the anon_vma's associated with this rather th=
an
> doing any specific dance around this.
>
> This removes unnecessary checks and makes it clear that the root anon_vma
> is shared between all anon_vma's in a given VMA's anon_vma_chain.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  mm/rmap.c | 51 +++++++++++++++------------------------------------
>  1 file changed, 15 insertions(+), 36 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index de2cbe860566..6ac42671bedd 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -232,32 +232,6 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>         return -ENOMEM;
>  }
>
> -/*
> - * This is a useful helper function for locking the anon_vma root as
> - * we traverse the vma->anon_vma_chain, looping over anon_vma's that
> - * have the same vma.
> - *
> - * Such anon_vma's should have the same root, so you'd expect to see
> - * just a single mutex_lock for the whole traversal.
> - */
> -static inline struct anon_vma *lock_anon_vma_root(struct anon_vma *root,=
 struct anon_vma *anon_vma)
> -{
> -       struct anon_vma *new_root =3D anon_vma->root;
> -       if (new_root !=3D root) {
> -               if (WARN_ON_ONCE(root))
> -                       up_write(&root->rwsem);
> -               root =3D new_root;
> -               down_write(&root->rwsem);
> -       }
> -       return root;
> -}
> -
> -static inline void unlock_anon_vma_root(struct anon_vma *root)
> -{
> -       if (root)
> -               up_write(&root->rwsem);
> -}
> -
>  static void check_anon_vma_clone(struct vm_area_struct *dst,
>                                  struct vm_area_struct *src)
>  {
> @@ -310,26 +284,28 @@ static void cleanup_partial_anon_vmas(struct vm_are=
a_struct *vma);
>  int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *sr=
c)
>  {
>         struct anon_vma_chain *avc, *pavc;
> -       struct anon_vma *root =3D NULL;
>
>         check_anon_vma_clone(dst, src);
>
>         if (!src->anon_vma)
>                 return 0;
>
> +       check_anon_vma_clone(dst, src);

check_anon_vma_clone() was already called 4 lines above. I'm guessing
this was accidentally carried over from the previous version?

> +
> +       /* All anon_vma's share the same root. */
> +       anon_vma_lock_write(src->anon_vma);
>         list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma)=
 {
>                 struct anon_vma *anon_vma;
>
>                 avc =3D anon_vma_chain_alloc(GFP_NOWAIT);
>                 if (unlikely(!avc)) {
> -                       unlock_anon_vma_root(root);
> -                       root =3D NULL;
> +                       anon_vma_unlock_write(src->anon_vma);
>                         avc =3D anon_vma_chain_alloc(GFP_KERNEL);
>                         if (!avc)
>                                 goto enomem_failure;
> +                       anon_vma_lock_write(src->anon_vma);
>                 }
>                 anon_vma =3D pavc->anon_vma;
> -               root =3D lock_anon_vma_root(root, anon_vma);
>                 anon_vma_chain_link(dst, avc, anon_vma);
>
>                 /*
> @@ -346,7 +322,8 @@ int anon_vma_clone(struct vm_area_struct *dst, struct=
 vm_area_struct *src)
>         }
>         if (dst->anon_vma)
>                 dst->anon_vma->num_active_vmas++;
> -       unlock_anon_vma_root(root);
> +
> +       anon_vma_unlock_write(src->anon_vma);
>         return 0;
>
>   enomem_failure:
> @@ -471,17 +448,19 @@ static void cleanup_partial_anon_vmas(struct vm_are=
a_struct *vma)
>  void unlink_anon_vmas(struct vm_area_struct *vma)
>  {
>         struct anon_vma_chain *avc, *next;
> -       struct anon_vma *root =3D NULL;
> +       struct anon_vma *active_anon_vma =3D vma->anon_vma;
>
>         /* Always hold mmap lock, read-lock on unmap possibly. */
>         mmap_assert_locked(vma->vm_mm);
>
>         /* Unfaulted is a no-op. */
> -       if (!vma->anon_vma) {
> +       if (!active_anon_vma) {
>                 VM_WARN_ON_ONCE(!list_empty(&vma->anon_vma_chain));
>                 return;
>         }
>
> +       anon_vma_lock_write(active_anon_vma);
> +
>         /*
>          * Unlink each anon_vma chained to the VMA.  This list is ordered
>          * from newest to oldest, ensuring the root anon_vma gets freed l=
ast.
> @@ -489,7 +468,6 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
>         list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vm=
a) {
>                 struct anon_vma *anon_vma =3D avc->anon_vma;
>
> -               root =3D lock_anon_vma_root(root, anon_vma);
>                 anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
>
>                 /*
> @@ -505,13 +483,14 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
>                 anon_vma_chain_free(avc);
>         }
>
> -       vma->anon_vma->num_active_vmas--;
> +       active_anon_vma->num_active_vmas--;
>         /*
>          * vma would still be needed after unlink, and anon_vma will be p=
repared
>          * when handle fault.
>          */
>         vma->anon_vma =3D NULL;
> -       unlock_anon_vma_root(root);
> +       anon_vma_unlock_write(active_anon_vma);
> +
>
>         /*
>          * Iterate the list once more, it now only contains empty and unl=
inked
> --
> 2.52.0
>

