Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61C4606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 20:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Wf44q9vo
Received: by kanga.kvack.org (Postfix)
	id B3FF76B08D9; Tue, 27 Oct 2026 16:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B178D6B08DB; Tue, 27 Oct 2026 16:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2E296B08DC; Tue, 27 Oct 2026 16:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 783AF6B08D9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:33:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 048381C4449
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:33:42 +0000 (UTC)
X-FDA: 85369557126.09.3DFDD6F
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0DE8920003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:33:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Wf44q9vo;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793133221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGVzZSBgakxWmcqzfl+9A2MiYwXiZAI9axGmW3aBX1Q=;
	b=qyC3gVsn2A8RXKl3jPQaxpzzZbjpLCQDB5RTmP0wm0HH6fTY+ziqw6T/IXVWzC+kIMriNf
	D7R1diyDLM8xQXGYRu2oqSs+4C9JBnEH/ByP17O5vKrzgzbOGKqD173U0LiWLFhJ2jdMVd
	WC2MGbwp/jHBPhZu7adWjbu55mgoZLw=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Wf44q9vo;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793133221;
	b=PtSLePn00rKdl3Kjldr9VTJPk7G92J1y95XeGRgJU8G1Qj1BNw3Wp0L7xaM91QxbNZNmSZ
	Q/E+e3vDC79vpEoMi8LK6QwLS0+Zd60U7vn6ooBgKW/PGwn50qQCBa9nLuVk8NoN1IEoz5
	6Fncs6DXT7UN4SLtV+Fo6/c3kxhkjns=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-535f598d126so17241cf.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:33:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793133220; cv=none;
        d=google.com; s=arc-20260327;
        b=Ru+6ovlsMeUpEb3/t1r3w6TsPblh2Xx5WqTE1MP6YaHtczLiKfDzBebFyWdQnO1A/5
         vRRHQBqpzSvgVn9b5ggnZgCUzk1esWtAj7jNcJU91hqbTAjHirMhh73RHjdMC+yhC6Zz
         ss70SZM7SOHod4yG2C9Pn472o/yAfU8usanVrKJRG9wyMRCVZg+qSxI/8+mM5X1qpaZ/
         FmnqqZNg87lJwwILNCUJDV3ZPanYevxeQ3yOCICPczM0FJgvjK0xh5NwACttDxizIfYS
         n5Ndg2mD/q3d9ZUfZJlpDf0nQnBdPuUgjyErZ0CdZd8cVAL5k8eDCRFYVY4MP0tPsNRM
         JXjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nGVzZSBgakxWmcqzfl+9A2MiYwXiZAI9axGmW3aBX1Q=;
        fh=6+dQsFtWk596BNFA2BaePOfWChzbx4d7uX89L7iubdA=;
        b=HkA4NcD9Qim2pbZTkauCRg2aavbmF7zb8FUvNP5qwmq9cRzDjPt6GHYBBnEpFCG0R8
         9wMPdmKr3Gb5RypJcr9DIGzTKmOVCZH7rlSRTkvq66zFdLgmnGkLLhp5lLRLoKifLXhL
         ay4LuV5SAvuVvlAcO7BVeDqCBG+ADqxNhASGdCyldrowr66+PvBcrIwfFvjFpfz3ZRsO
         wuB7e4L16TCdzZBEDOHJTPBLl3scns5xFlfVimrLXhpJV5vnj756IQuC02US9WbnoHcG
         NKOZ8SBP+tat7w25/iea642ffP3crWouKfMK/mEQRpW/LJqxYv9um2qrmpD/eOF95SkZ
         /nkg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793133220; x=1793738020; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nGVzZSBgakxWmcqzfl+9A2MiYwXiZAI9axGmW3aBX1Q=;
        b=Wf44q9voyzlmwXSL+968jY49btDCAXVPDv0WQNTBv5day/Z/AIChFuVexEXfkA3bUk
         ZR3jpOC9Injpaw3BtCJsL7Bz9h/t08RJZ/Z05193hqFKM0rFGxoXFVPURwNgCsIgHbUh
         9vO9ScdG78yabdl0f39JAj4JU23CDdqBzlYe11nD2zfdphK5QmKyPE8Hx8fsimdIhyy+
         3uk1YeXmJbYWxvalVJJoGL56w2KxrP2z7wP+hH/3yq/QaCpWvg/JKeJcMYH1D4eRPWKL
         c4H1SVQuoT8cAPg5f5FLAoRaXQuWHADUzVK65hIZWk8fppWb68cl4aXokFrxuYDmKPZO
         a0uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793133220; x=1793738020;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nGVzZSBgakxWmcqzfl+9A2MiYwXiZAI9axGmW3aBX1Q=;
        b=JS9GGHkMx/b4Sj6zdyLdUl5+bRbxEDH6wZlDcFXRRFI3p33Qr2dT41wgE7UUz36B25
         sm2DQayOtc3/ePxeAQ+4r4popfqnRhQuI+9Zid/cj4uYzyajR2mdXjDe5qMfHeX4mzj1
         1Dts4JZM7uv6mwPIXlxW96deNhv+ZKeH2ZM4YkKmlWntiiMLx3Z5pv1+GTNhWpcUxV2g
         qKlFmDDcoqEwrPRU5Yw1lYGnZBj7Wdtrj3itga3GJe5fcFijBOrG2pJjBylQHoQbLBNH
         AYyyTFHhHTgPMky9Wk2Fl16/xxyMiM4+ur25zqJj7WA4dGvgBFBDkiRhqSCLRSPujj6X
         +o3g==
X-Forwarded-Encrypted: i=1; AKwUvByiaRvV4mGp8PodJnLJ132A+f1hnVUalG7MTgkoRRseNBpVtcKiw+Tx1n3i/uXhNDLkvZPhEYucqg==@kvack.org
X-Gm-Message-State: AFq9FYIS1yJtSXMbKpzifUH+vnJ0Kc03RyaCA23csDcv29jO/VkN/JPU
	H/8Q76bicF2iMHfzEHahKRtFRmWuKZDNdlX1K96v3fJLUR7n+LrH06dA6f0yonPMJYpD5DxXixv
	yTzfarWSoOWMRah/PQrOlcVi0A3f4cqz16xCtdXPGoJsb7oLA6Y27l/WAlaE=
X-Gm-Gg: AYBFou0BiVCRzPkrSOk+/02cizMrPSprQVzsL9yzBQH+gMummTh/QItbV3bdQamWUCj
	faz+fMFnu3ctuq4/jJDQ1i6YXEhwqbeRch8kP5Z+ywnEtxfjgeR7SXY499PT4fKKAUw/rMkg4Ln
	n1Yhjb7m8ocL67iyHwu8zo1fAfi/dGcJPxpbrGwrD5TK8uXUMECbxofew4JzVtBV0np+dVel8lY
	F6KLRdKtP0+t+jIBO9v3LWB708h1Gioky6LRxOaWGcj/wPRmOFtP04FhEMC2IDsnSi/XSHputdx
	DWYXFkBVM2bid4l1OCwj6e4DXtlnsdloBlOw2NrGwXoZzyrXxJJRzPfQawTHI6r0wErgcHQeVyt
	cj4JwhGfemRXs18AkIK4W5Tnyd1fzSalOl3x0TAGxVLjUcVxh86JIOgPilr+Jg1qruQA=
X-Received: by 2002:a05:622a:2488:b0:534:b7b2:634f with SMTP id
 d75a77b69052e-53fe2554767mr1314101cf.8.1793133219456; Tue, 27 Oct 2026
 13:33:39 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027-fix-proc-pid-maps-missing-vmas-v2-1-2791cc9fc95f@kernel.org>
 <CAJuCfpELhxhyVQANspX14OBLbghiAqndYcfv1hnmh4Nvo=1vAQ@mail.gmail.com> <auDEn8GmB0H7zj99@gremlin>
In-Reply-To: <auDEn8GmB0H7zj99@gremlin>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 27 Oct 2026 13:33:28 -0700
X-Gm-Features: AclHuK9xIitY88h9-xQmFSg95vDMG0XSmM9H59NNZztoY7Pi5T1zymOIAg7NNiM
Message-ID: <CAJuCfpFqYcbw4rOhd+Q4PGryXjzTxYXpwmS7Ag_cbtPOYBW0Aw@mail.gmail.com>
Subject: Re: [PATCH v2] fs/proc/task_mmu: fix missed VMAs when reading
 /proc/PID/maps and friends
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Shakeel Butt <shakeel.butt@linux.dev>, SJ Park <sj@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0DE8920003
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: okcrsz9jr96jqp7qfbpiiumtbcbpxg6y
X-HE-Tag: 1793133220-236846
X-HE-Meta: U2FsdGVkX1/U6c/B7tmwPqQHtixVSL8NpUH3vemQEND4bZqY0T0oNFn3gJvWlf8NCJpID/+2S4njIyUG6LkUvDWxC3CFRACkakHOSMHUAy5i8hW4rOEzjYpUgs8WUV9afqNekEfm3A+1eJAaAzIKKCKDrlsYbbr5+XSPNyCT8VOas9E86z65rNR3MG0mQGwgUEYPFqXKbi76IfiYnoo+ojgW+aCTMKehMDYFuGCLlrUACqxVS9UYm3TiQ86cV9enIqclHP/iktrJiqflAGTRt4TtT+lX41Q26xAWFco2R0WzB/9/axooJu3jiMA2BYKZQ6WkcZruNyLvtOy6MSwJKv+7ZA7ECPN5QaaPDvSrWNOl3aTw84n/9fqsqWuhzdIXdXeBfTy6WTQ9sWVXDV4k16Pub/5whOW6HizOMVoho9wtvbruBcgSnWJZtPYHU1Cm+KjvzRsWq6GyIOidkBBddx1tQsikoUkua3BlXSPfutlx5Y+imLw09smIej+8b+2GAXQ8xKEd5BEZ98gtVtBF4//AgqjRCjxAx+cUsneOAXOEUB8RwJz3abhqhrvUFdihRCBUxQWaR1htqm31Yv8bujlt+fbpUw9idL5mKGgxvUz6KOtUvT3FujIY+SoAqa8yV4LKEZaC17QE57+ElPagc296oJSM+q40D0cHDlvYCYq5LPAnoutp8N/PWzBY3dGsV/bsYB/qyy/0olLBX0yNDR5ve6W7Bj390UBeb48n0SoBrhWdcsdrAEAbBtdlAJ9HlZjRt4fL1ZLSW1HHNacgZISrqDSeOva2KaoLCnmOW+n7poclDrcoD49iQbSDIpz6AGWrdESWP4JeQgiyXLvQPc2T3iVqtqx/9Nld7vauofcNvM390J/7kaUHZZyEGYlJtN69ko6vUxktKj8bcUkEi8cExCD+1glFm91/3sxrTVKQMOTToSydjK98MAcCB6nKo7iHVkA7k3anta5w0BI
 oRMgROze
 MzG9jl542frE+gfAICZWAYEiLr8UMrqWpGmn96kX85tm+R3YiQ84djD434wtKVUntjkz9KdjMr3pFESHABzZvF/VJAq0Ej1bciTLCp1avE11/EnkZGjjTs/B4PFHoP3tABJ+SQq48lmo9Avs9TTif/nsOA7W8IqAMi3BpX19P0CHBWsSLh9MfRpPVAFA/zhowarR6j7eVhI6nBiwW9g4dVo8r5YFEAsJ5GMSkm0IIm6BnP4/vxS9+vC+p//y7vKb1/rhc7qRdzp6miIHEBv5pX4f82jYK0atULdIJbY2Iw+nKwYj4aIeV6jbSkGwVW2y8P1aWAZWxZD0BSU0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 10:49=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> On Tue, Oct 27, 2026 at 08:34:10AM -0700, Suren Baghdasaryan wrote:
> > Overall the code looks correct bit I have a couple of questions below.
>
> Thanks!

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> >
> > > ---
> > > Note that I decided it's best to defer any VMA iterator stuff to a
> > > follow-up - with the abstractions added it's clear what's going on an=
d
> > > easier for backporting.
> >
> > Ok. But once we get VMA iterator validation routine implemented, we
> > won't need vma_rcu_iter and its helpers, I think. Are you ok with the
> > fact that most of this change will have to be removed later?
>
> No, I don't think this is correct.
>
> The iterator can't validate itself - the failure case is invisible to it,
> something changed in the tree and it has no way of knowing, it has to be
> prompted to re-init etc.
>
> I tried a version of the code with vma_iter_next_before() and it really d=
idn't
> provide much delta.
>
> So I think any version of this has to have the rvmi stuff.

Hmm. I though the fact that we store from_addr and can compare it with
mas->last could help us detect VMA skips but I'll have to think some
more about this.

>
> In any case, I am happy to replace all this with whatever makes most sens=
e
> going forwards.
>
> Key here is to fix the bug + get it backported :) [ before moving on to t=
he
> N other AI-reported bugs ;) ]

Understood. Yeah, I'm not going to nitpick here as you have your hands
full. If we find a better way we can improve it later.

>
> > > +static inline void vma_rcu_iter_init(struct vma_rcu_iter *rvmi,
> > > +               struct mm_struct *mm, struct vma_iterator *vmi,
> > > +               unsigned long addr)
> > > +{
> > > +       vma_iter_init(vmi, mm, addr);
> > > +       rvmi->mm =3D mm;
> > > +       rvmi->vmi =3D vmi;
> > > +       rvmi->mm_wr_seq =3D UINT_MAX; /* Start odd so changed by defa=
ult. */
> >
> > Why not initialize mm_wr_seq correctly using
> > mmap_lock_speculate_try_begin(mm, &rvmi->mm_wr_seq)? That way on the
> > first call to lock_next_vma() you won't be resetting vmi
> > unnecessarily.
>
> It doesn't really save anything, the init already sets you up in start st=
ate
> where you need to do a traversal anyway, and vma_next() will trigger a wa=
lk
> either way.

You might end up with an extra vma_iter_set() call but it's not critical at=
 all.

>
> What's useful about it is it makes it such that only lock_next_vma() does=
 the
> speculation (and thus sampling of mm_wr_seq).

OTOH you won't be exposing these odd/even seqcount details. Anyway,
I'm fine with what you have.

>
> > > @@ -471,14 +505,9 @@ struct vm_area_struct *lock_next_vma(struct mm_s=
truct *mm,
> > >          * installed ahead of it. Otherwise we might observe a gap th=
at should
> > >          * not be there.
> > >          */
> > > -       if (from_addr < vma->vm_start) {
> > > -               /* Verify only if the address space might have change=
d since vma lookup. */
> > > -               if (!mmap_unlocked || mmap_lock_speculate_retry(mm, m=
m_wr_seq)) {
> > > -                       vma_iter_set(vmi, from_addr);
> > > -                       if (vma !=3D vma_next(vmi))
> > > -                               goto fallback_unlock;
> > > -               }
> > > -       }
> > > +       if (from_addr < vma->vm_start &&
> > > +           vma_rcu_iter_may_have_skipped(rvmi, from_addr, vma->vm_st=
art - 1))
> > > +               goto fallback_unlock;
> >
> > Before this change we fell back only if the new search yielded a
> > different VMA (the vma !=3D vma_next(vmi) condition) while now we
> > fallback unconditionally. Note that the VMA that we are rechecking is
> > already locked, so it can't change. Was the previous logic invalid?
>
> It's not unconditional - it requires that we have progressed and we may h=
ave
> skipped a VMA change.
>
> The 'we have progressed' bit was there before (from_addr < vma->vm_start)=
, and
> vma_rcu_iter_may_have_skipped() wraps the previous check plus actually wa=
lks to
> check if something is there to traverse,

Ok, I see. vma_rcu_iter_may_have_skipped() effectively replaces (vma
!=3D vma_next(vmi)).

>
> So this is strictly an improvement.
>
> And yes the previous logic was invalid - the issue is with an unlocked VM=
A
> in the range [from_addr, vma->vm_start - 1].
>
> It's really the gap that's the problem AND a race against node replacemen=
t,
> which means that 'X' is skipped by vma_next().
>
> vma_next() is a walk to from_addr, then runs mas_next_slot() which advanc=
es
> to the next entry. If a gap, then the walk assigns mas->last to the end o=
f
> the gap, and if a node is killed before that happens, due to a VMA
> expanding _backwards_ like:
>
> vma_iter_set(vmi, from_addr), then mas_walk() from mas_find():
>
>         from_addr
>            |
>            v
>  |---------|      |-----|   |---------|
>  |    A    |      |  X  |   |    B    |
>  |---------|      |-----|   |---------|
>            ^     ^
>            |     |
>      mas->index  mas->last
>
> The walk lands in the gap. mas_next_slot() saves mas->last as its
> rewalk point.
>
> X expands backwards, the node containing the gap is replaced:
>
>         from_addr
>            |
>            v
>  |---------|  |---------|   |---------|
>  |    A    |  |    X    |   |    B    |
>  |---------|  |---------|   |---------|
>                  ^
>                  |
>              mas->last
>
> mas_next_slot() finds the node dead and calls mas_rewalk(mas->last),
> which now lands inside X:
>
>         from_addr
>            |
>            v
>  |---------|  |---------|   |---------|
>  |    A    |  |    X    |   |    B    |
>  |---------|  |---------|   |---------|
>                ^        ^
>                |        |
>          mas->index  mas->last
>
> mas_next_slot() then advances past the entry it is on, which is X:
>
>         from_addr           vmi
>            |                |
>            v                v
>  |---------|  |---------|   |---------|
>  |    A    |  |    X    |   |    B    |
>  |---------|  |---------|   |---------|
>
> So vma_next() returns B, having stepped over X. We lock B:
>
>         from_addr           vmi
>            |                |
>            v                v
>  |---------|  |---------|   |---------|
>  |    A    |  |    X    |   |    B    |
>  |---------|  |---------|   |---------|
>                               locked

Ok, so here we hit this "if (from_addr < vma->vm_start)" condition and
have to verify that we did not skip a VMA.

>
> Then if you get (really) unlucky, the same race happens again for the
> existing code:
>
> vma_iter_set(vmi, from_addr);
> if (vma !=3D vma_next(vmi))
>     goto fallback_unlock;
>
> The walk lands in the gap before X, something else is merged into X from
> below, the rewalk lands inside X and the advance steps over it again:
>
>         from_addr           vmi
>            |                |
>            v                v
>  |---------| |----------|   |---------|
>  |    A    | |     X    |   |    B    |
>  |---------| |----------|   |---------|
>                               locked
>
> And suddenly vma =3D=3D vma_next(vmi), no fallback, and X is never report=
ed.

Got it. The same skip must happen the first time and then during our
verification. Thanks for the detailed explanation.

>
> With the new approach you simply can't miss it, as
> vma_rcu_iter_maybe_changed() will see a change could have happened, and
> vma_range_is_empty() tells you explicitly, with a brand new separate walk=
,
> whether e.g. X is there.

Yep, that function name is indeed very clear.

>
> It's finnicky, finnicky stuff, which is probably why AI found it :))
>
> --
> Cheers, Lorenzo

