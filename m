Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C0C8D38FE3
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CC846B0088; Wed, 14 Jan 2026 11:14:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94FA56B0089; Wed, 14 Jan 2026 11:14:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8246B6B008A; Wed, 14 Jan 2026 11:14:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD656B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:14:39 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF825139CA1
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:14:38 +0000 (UTC)
X-FDA: 84331067436.14.54B2A8D
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3466E1C0013
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:14:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0Y81Sf7C;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768407277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q93diuoOUYNLSYltpcMW0BiBQ6H7cL6eflSlqkA0Ank=;
	b=n+aYWcIJNH9caaZCToEpsX2sfwWH0UgCnJmp567gyaIxWcjYttSaV5MpSEfp8WCJNDapwE
	a+vSDee01fubXSu9IM7GzOblZ4h/DuRFd1lX6Mb5ckT7MDD+5o1dDVbWlz9BjdFleVX7U5
	tR4GmIRMTsQ+v6WfZiztKMmLzgc1oTI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768407277; a=rsa-sha256;
	cv=pass;
	b=8RY5ViwbeimZC8TsmHrrLyOdIq7DaIxLIKdgWzO955xs+/Lm6nKypC1N2TOylS0T9kv/5m
	9b3crpQ9fimNzmlbatrcyiYAH65KpZFsqhXhpizS5w2YTwvELvCcdYwqn0L4StPLhMt+BN
	3LCbG4DnJ9Gib+mr4t84Drfbh91vBT8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0Y81Sf7C;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5014acad6f2so361141cf.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:14:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768407276; cv=none;
        d=google.com; s=arc-20240605;
        b=JbixyaZsIWAQ7eV21NWKoSIRSkR6tDFCErJ3PljgamabBi+j9Zmy0vhF2HugVXgeR8
         McRkHrL1qHWrxSqpzIvw8HxPyFtbNjydCZ5aZ3vmA6cUiSkuwHrQqrGiwCnqWpVMtbUF
         vZ1d5Xx+CUaMYP4nIY9eU/ZSoIhbi0wLMG7l27rqG19Peb5xdcxYHqDILlxGBNSfx1k6
         O0pLmg+021LvNkNQGG0R3f6f39LKNEQzBizeiLGuXqJAz8buHU+bJYqFkGqCCnQn2WcH
         4o4VpJ4kcFDpP5PSKgZRkqyEkCLKMcEBuBeIUe6/WHCd5a4FC3H0P5wYeY3XoBZnSYqI
         xMiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q93diuoOUYNLSYltpcMW0BiBQ6H7cL6eflSlqkA0Ank=;
        fh=LPIJT0I52P1nFGBlWYGXS+Rw8e5YdKCz6HBN0XTsNuo=;
        b=CtPtbwo0DrWwgtSduhYxnEA8YO4ndofENv2LodBbFLMUiyXxbjHowPwCnGXprETL0R
         4JOnIiUMgiQ6s37MUkv1guftbEUyk8O0YNP2XT/CnSJwJmAuzv9twI2Giv/Mbme8bWs8
         wd3363fo4cjp67Lv5l6463OvfZoYeK/JWEhUBAEk64r1+sWAkWTDva+dQy0w6N5h4d9b
         Ca2dvBEhLHsIFppQh3EypBJjzaLdGpR58Jos1I3jb9h1VYHhpsu4po8xKH2OiNdZ6f21
         18KjSkibo66qPLQN4dpOYpZulAuxkr4vKfQkWOOKhitBkGb35/BWiziKQ5bS94K/v3k8
         PmqA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768407276; x=1769012076; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q93diuoOUYNLSYltpcMW0BiBQ6H7cL6eflSlqkA0Ank=;
        b=0Y81Sf7CVqh0SiGaT+9YjDpzkNFdEiVITlAT9fZCn9yoEt0Mj9YJKufyW5RMVanLe9
         BSwO95PdLzmJJhRxwCjDPqv1VSn2KxVrjj91tnx1MMZmkLHF/myLn030sO528bv7y0VH
         tQD841o2N10NoE5xaVm2C2EOZNA3zMRo2B29i4P8eJ+w5RL/NtL7TLNQMo+A2Z83IkR4
         0lOnKiGdPW1rshS7bMFbd7huhzC1NHz6OhZRXKErWLNmFXfvlrX9PfgGrzvzi6f/B4ay
         cIt6tzE5Z87KufWii/tKR553wQex7KVlqzevKQVfs9z0cyaMm5O9QHMi9RgnrYBs22K2
         c2gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768407276; x=1769012076;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q93diuoOUYNLSYltpcMW0BiBQ6H7cL6eflSlqkA0Ank=;
        b=tbGRxuogZ+nN68DJqsL6aNmLC6Jba52jpacHmOEaxIkB6gT9xl+Qf8aWdy6O4rmTOq
         f/m4Y0T5rRUa7yioM4dwNwZ24cIlm8ykgS+6IOh/RTDfV1j9SiU7nJYWg6ckWCVfA5/A
         NZRzbOZdZelNhr37/hpYBTnwS8z5VOHFEjt2So9kqaYnjv4cPVbE7NlxaMUZp8ktVd5h
         gw/p+KEs6Xz+DaWllhPAn4hPBz7MyyW/l+oJnQ74PYcWlwPJjqOKB7iX+ERWbkIqcfmO
         QkJWSSIm7K9uSS5f8VTWMjZtfLrM0lWs2IM7T5tREGwo4J0BSSa9A+0vV93tcEDzokJt
         J3Fg==
X-Forwarded-Encrypted: i=1; AJvYcCWGjRKE3BJiufwS/Tn98NErbL3jgX9Rrnmg/uccg0M7+jaAe4C80qnao5vptsxGIA65eFtpQUdNog==@kvack.org
X-Gm-Message-State: AOJu0YxhhKCJpOF3Jo4K3bOtauLkAGwoZRVL6MczfwDwyrnJIOQDYA5Z
	6usqXjMauEqr55jxGE3LFqRUF2RkoR6MhA5czOui8nUHrQc8tbIUFj0vNX2HtTbePr2iknjLxOG
	FSqsdE0KTcRhGfcLB55X/Q7T1yxHVrVMkosy087O8
X-Gm-Gg: AY/fxX4PH3YUi/NlEpZLVlZt9GR7UJPgfsAgSHRccgzv7koOYxg3sM7/saaaKr+MQ44
	M8aWJ/ZNPUZat2URzLL2WLEWF0W74bwO/SQDdcQ2biXn25AM3mYDqLobdOehli3DKBV/i7AMh9u
	8hrZWvfGxGS60DIHrU1eRQPXBq3BzpbQbCerRUTHnQ/mQf3ixzRNmiWX+AYo2+vbQ8vKwL995BZ
	Uonfeu0ZBp+qPoSwGZQcjx6zydh4LiNhlPjH9Cie5SNl7vYn0TR98sQ/h+uBM8htEC/OcgZFRYg
	Sqhxq37P+iceQPjSMsiWE4t8tQ==
X-Received: by 2002:ac8:7d44:0:b0:4ed:ff79:e678 with SMTP id
 d75a77b69052e-5014826ed12mr12939281cf.18.1768407275028; Wed, 14 Jan 2026
 08:14:35 -0800 (PST)
MIME-Version: 1.0
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com> <5f55507a877028add5fdf8f207f5e333c7a3fc85.1767711638.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <5f55507a877028add5fdf8f207f5e333c7a3fc85.1767711638.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 14 Jan 2026 08:14:23 -0800
X-Gm-Features: AZwV_QhtaP3-kQbC2Idf9OAdoIVTlYCxcwv9H4J_1I_6E5mlAGl3jJqT6VSom4s
Message-ID: <CAJuCfpHoNdg4p__pmdsQepzxSpLe4j_7s17=Y5bicETacP4a+Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] mm/rmap: improve anon_vma_clone(),
 unlink_anon_vmas() comments, add asserts
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3466E1C0013
X-Rspam-User: 
X-Stat-Signature: mxsq4w8bnnhae44zx63wjrkahbs6qh5j
X-HE-Tag: 1768407277-338394
X-HE-Meta: U2FsdGVkX19zbPS8CWd+rWIdYLbnpLpMZMtHyWGt2mQxGCegsPHiYXJUAgvb1tdsq+aYjLmwakhBEb2hFAQXa1ef24O8g4giYSUDVDHe76fQ0mAlZZ2BrmPf1fEtkOdhXJIcbbWXO2iSO5bL43ezJPd05gPpRiw5wKxltVDV+dCAA3/MNS2OvGIf5JV3t1/iquAyHV0nGtIXUKCaLNCBeRvauq8WYTUBM4+0OA6lkG34ndIXuJoZ5f9tYW+a9kplNO9DZwGGj3S0oVz5NeNPpqqwHPgwJL/pmH5QzW0jnyyNIDwSTRe50vr9G4OkPaWNjQtkWp60W++ir5vrAl0SD/YviPalxyYUh38hs/YuCtas1l7pJ3KmsZrPlY73C44tOV7Notcym3/I+dLEBbX1waUsJDul0oJJBsLHVHAAKBrT1PLq03PTvY8qcFrY/ZLT1mbMO4prTpyHCDqr9tVqxAMeaEXwd8fbKQ5p23EBI84SeIlbFYSFWFrAiSFxfxe8hx9jgmEMdB8kB56V6iZ/De9f63hVgEwQy6LUcX/XVZ+783ZFR+5LBFK6Gbz1p0oOnUGIshI1ngRBolksmaXKAxEXlCw8kA+31ZHP8lbZDFXHW0opiRSw0XP/bd2LpoU62X0Hyi2MVnSkVvGnTBmjxrTIK0n1imRSls0V3L4w0i0aKK+ICmz1p8cIAyqC/51jgkwvlmOUjnWGzyy82kcbqIDqHPFvmMp1akF9ww2Q/SJP89nhtCZBubSq9QRbORD4ZodyucrDy/mXv5ikXgwhrz4+NbS0MMv/r5ZMdxD5caXIceiveKWGrWUdRZYdxdAmoYM0eTg7hkmyV0N9YBG15cAc8YOtjSeKYBON726fDj+LG7o9VZJqV0XxVTp0oKR02EAgMnNqXM3w0afkZvKKQjle6ybn1qBav3WS/JS6H5GV0o/nloBuuxLnlhY6zZLTG4/sA52wM3JzvTmdKEs
 FGXS5fmS
 E7YM43mNbtxw34xrahhi00YIJm3r2hgALzN1Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 6, 2026 at 7:13=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> Add kdoc comments and describe exactly what these functions are used for =
in
> detail, pointing out importantly that the anon_vma_clone() !dst->anon_vma
> && src->anon_vma dance is ONLY for fork.
>
> Both are confusing functions that will be refactored in a subsequent patc=
h
> but the first stage is establishing documentation and some invariants.
>
> Add some basic CONFIG_DEBUG_VM asserts that help document expected state,
> specifically:
>
> anon_vma_clone()
> - mmap write lock held.
> - We do nothing if src VMA is not faulted.
> - The destination VMA has no anon_vma_chain yet.
> - We are always operating on the same active VMA (i.e. vma->anon_vma).
> - If not forking, must operate on the same mm_struct.
>
> unlink_anon_vmas()
> - mmap lock held (write lock except when freeing page tables).
> - That unfaulted VMAs are no-ops.
>
> We are presented with a special case when anon_vma_clone() fails to
> allocate memory, where we have a VMA with partially set up anon_vma state=
.
> Since we hold the exclusive mmap write lock, and since we are cloning fro=
m
> a source VMA which consequently can't also have its anon_vma state
> modified, we know no anon_vma referenced can be empty.
>
> This allows us to significantly simplify this case and just remove
> anon_vma_chain objects associated with the VMA, so we add a specific
> partial cleanup path for this scenario.
>
> This also allows us to drop the hack of setting vma->anon_vma to NULL
> before unlinking anon_vma state in this scenario.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
>  mm/rmap.c | 130 +++++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 104 insertions(+), 26 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index c86f1135222b..54ccf884d90a 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -258,30 +258,62 @@ static inline void unlock_anon_vma_root(struct anon=
_vma *root)
>                 up_write(&root->rwsem);
>  }
>
> -/*
> - * Attach the anon_vmas from src to dst.
> - * Returns 0 on success, -ENOMEM on failure.
> - *
> - * anon_vma_clone() is called by vma_expand(), vma_merge(), __split_vma(=
),
> - * copy_vma() and anon_vma_fork(). The first four want an exact copy of =
src,
> - * while the last one, anon_vma_fork(), may try to reuse an existing ano=
n_vma to
> - * prevent endless growth of anon_vma. Since dst->anon_vma is set to NUL=
L before
> - * call, we can identify this case by checking (!dst->anon_vma &&
> - * src->anon_vma).
> - *
> - * If (!dst->anon_vma && src->anon_vma) is true, this function tries to =
find
> - * and reuse existing anon_vma which has no vmas and only one child anon=
_vma.
> - * This prevents degradation of anon_vma hierarchy to endless linear cha=
in in
> - * case of constantly forking task. On the other hand, an anon_vma with =
more
> - * than one child isn't reused even if there was no alive vma, thus rmap
> - * walker has a good chance of avoiding scanning the whole hierarchy whe=
n it
> - * searches where page is mapped.
> +static void check_anon_vma_clone(struct vm_area_struct *dst,
> +                                struct vm_area_struct *src)
> +{
> +       /* The write lock must be held. */
> +       mmap_assert_write_locked(src->vm_mm);
> +       /* If not a fork (implied by dst->anon_vma) then must be on same =
mm. */
> +       VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm !=3D src->vm_mm);
> +
> +       /* If we have anything to do src->anon_vma must be provided. */
> +       VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chai=
n));
> +       VM_WARN_ON_ONCE(!src->anon_vma && dst->anon_vma);
> +       /* We are establishing a new anon_vma_chain. */
> +       VM_WARN_ON_ONCE(!list_empty(&dst->anon_vma_chain));
> +       /*
> +        * On fork, dst->anon_vma is set NULL (temporarily). Otherwise, a=
non_vma
> +        * must be the same across dst and src.
> +        */
> +       VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma !=3D src->anon_vma=
);
> +}
> +
> +static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
> +
> +/**
> + * anon_vma_clone - Establishes new anon_vma_chain objects in @dst linki=
ng to
> + * all of the anon_vma objects contained within @src anon_vma_chain's.
> + * @dst: The destination VMA with an empty anon_vma_chain.
> + * @src: The source VMA we wish to duplicate.
> + *
> + * This is the heart of the VMA side of the anon_vma implementation - we=
 invoke
> + * this function whenever we need to set up a new VMA's anon_vma state.
> + *
> + * This is invoked for:
> + *
> + * - VMA Merge, but only when @dst is unfaulted and @src is faulted - me=
aning we
> + *   clone @src into @dst.
> + * - VMA split.
> + * - VMA (m)remap.
> + * - Fork of faulted VMA.
> + *
> + * In all cases other than fork this is simply a duplication. Fork addit=
ionally
> + * adds a new active anon_vma.
> + *
> + * ONLY in the case of fork do we try to 'reuse' existing anon_vma's in =
an
> + * anon_vma hierarchy, reusing anon_vma's which have no VMA associated w=
ith them
> + * but do have a single child. This is to avoid waste of memory when rep=
eatedly
> + * forking.
> + *
> + * Returns: 0 on success, -ENOMEM on failure.
>   */
>  int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *sr=
c)
>  {
>         struct anon_vma_chain *avc, *pavc;
>         struct anon_vma *root =3D NULL;
>
> +       check_anon_vma_clone(dst, src);
> +
>         list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma)=
 {
>                 struct anon_vma *anon_vma;
>
> @@ -315,14 +347,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struc=
t vm_area_struct *src)
>         return 0;
>
>   enomem_failure:
> -       /*
> -        * dst->anon_vma is dropped here otherwise its num_active_vmas ca=
n
> -        * be incorrectly decremented in unlink_anon_vmas().
> -        * We can safely do this because callers of anon_vma_clone() don'=
t care
> -        * about dst->anon_vma if anon_vma_clone() failed.
> -        */
> -       dst->anon_vma =3D NULL;
> -       unlink_anon_vmas(dst);
> +       cleanup_partial_anon_vmas(dst);
>         return -ENOMEM;
>  }
>
> @@ -393,11 +418,64 @@ int anon_vma_fork(struct vm_area_struct *vma, struc=
t vm_area_struct *pvma)
>         return -ENOMEM;
>  }
>
> +/*
> + * In the unfortunate case of anon_vma_clone() failing to allocate memor=
y we
> + * have to clean things up.
> + *
> + * On clone we hold the exclusive mmap write lock, so we can't race
> + * unlink_anon_vmas(). Since we're cloning, we know we can't have empty
> + * anon_vma's, since existing anon_vma's are what we're cloning from.

nit: At first I got confused because it's possible that vma->anon_vma
(which is dst->anon_vma) can be NULL but then I realized you are
talking about avc->anon_vma here. Maybe change the comment to use
avc->anon_vma instead of anon_vma for clarity?

> + *
> + * So this function needs only traverse the anon_vma_chain and free each
> + * allocated anon_vma_chain.
> + */
> +static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
> +{
> +       struct anon_vma_chain *avc, *next;
> +       bool locked =3D false;
> +
> +       /*
> +        * We exclude everybody else from being able to modify anon_vma's
> +        * underneath us.
> +        */
> +       mmap_assert_locked(vma->vm_mm);
> +
> +       list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vm=
a) {
> +               struct anon_vma *anon_vma =3D avc->anon_vma;
> +
> +               /* All anon_vma's share the same root. */
> +               if (!locked) {
> +                       anon_vma_lock_write(anon_vma);
> +                       locked =3D true;
> +               }
> +
> +               anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
> +               list_del(&avc->same_vma);
> +               anon_vma_chain_free(avc);
> +       }

Are you missing "if (locked) anon_vma_unlock_write()" here?
You could also avoid using "locked" variable by setting anon_vma =3D
NULL initially and using "if (anon_vma)" as an equivalent of "if
(locked)"

> +}
> +
> +/**
> + * unlink_anon_vmas() - remove all links between a VMA and anon_vma's, f=
reeing
> + * anon_vma_chain objects.
> + * @vma: The VMA whose links to anon_vma objects is to be severed.
> + *
> + * As part of the process anon_vma_chain's are freed,
> + * anon_vma->num_children,num_active_vmas is updated as required and, if=
 the
> + * relevant anon_vma references no further VMAs, its reference count is
> + * decremented.
> + */
>  void unlink_anon_vmas(struct vm_area_struct *vma)
>  {
>         struct anon_vma_chain *avc, *next;
>         struct anon_vma *root =3D NULL;
>
> +       /* Always hold mmap lock, read-lock on unmap possibly. */
> +       mmap_assert_locked(vma->vm_mm);
> +
> +       /* Unfaulted is a no-op. */
> +       VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chai=
n));
> +
>         /*
>          * Unlink each anon_vma chained to the VMA.  This list is ordered
>          * from newest to oldest, ensuring the root anon_vma gets freed l=
ast.
> --
> 2.52.0
>

