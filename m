Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12172CEFD0C
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 20:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 309906B008A; Tue,  6 Jan 2026 15:59:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E13A6B0092; Tue,  6 Jan 2026 15:59:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B9476B0093; Tue,  6 Jan 2026 15:59:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 086886B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:59:02 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A33C41AC979
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:59:01 +0000 (UTC)
X-FDA: 84302753682.19.9493D13
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id B0E4040010
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:58:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2ovuS9Pm;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767733139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jZmTDTCFrv9l8jR3K2HZi86+beTGTUYM6nRJSha8tIs=;
	b=ogkUKNatRnq/zSizon8Y0Ndda8Y82LfZzqGHyT56KcE6mWZbgtJkZWFUy378fSLeDJiIMe
	rtSCVgKM0wFvvWW1p9Fv5xvHkIW3qHuohdwQOTuSKjd5PpPzAF8sVSpTnM7GwNiPlSGQpo
	GmpEom+dEGwpVBkCnJeZ8v+7xKWk3GU=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2ovuS9Pm;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767733139; a=rsa-sha256;
	cv=pass;
	b=2SaABxLnoCZ7jMRrNHThQYtknrp4+QSwL0aVvqyTj/KSSUxaaAUxCCzwDkiUOZ5R7CxOGx
	JrevbWqNOu4opUsKkrzH6kz8HWT4f1TdupeGrqwXfo5lZT7UL9KRehw618mje0Xf1/Xmbh
	94e+d9X1LEjg8MC5qACOAUnmAd+XMD4=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ee147baf7bso20821cf.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 12:58:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767733139; cv=none;
        d=google.com; s=arc-20240605;
        b=ko85hzqC1qjTR+f0hih3Kg0lraTBDEOvctpK+l5Sut7r7KPCQzRGJRvaWmDVyPhSbt
         yLqn3Sp2Sel0wTxCAwFpmM5UxJ3GorOI3FlrNWhKgXTZD3NYmnHeQ5ioTqQvMwEVbiOb
         7xhQgTZTfXjYjjAYROGfv4qqA/KrmOzrv6CgqTdquU0uClFHspoQqh8wD0uQ8BBq9iRm
         ahgurK7Di8m0LqS64WjAMaqx4RqxD2FwFWGHDn+COlSKjeOxu4rQV0+I34eYhbcotBnL
         el6oH240Nr0uMWgG7qhEmyvvcdGyWowx6hWzIrKCaWPot1XbhOPPkeMtnRSIfiDGxNup
         TxOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jZmTDTCFrv9l8jR3K2HZi86+beTGTUYM6nRJSha8tIs=;
        fh=zMH3OjEo0P3gSrcMGg17Dm6RXwYnQ1rE25qw5uWj6n0=;
        b=KApYGylB5PVQemC6dQE82OH5Sa1rVsBAVI/lPZUmhfSkBG+vDen5n9IMl8/OvnP3PE
         55pRJ64eAqWOQ692mtfRWwrgJM3rA9czr8uHxBiDHk3EQOKYNMoNlS4XPkkHL8I71YdY
         whwDoPMBevyXnRJ6KThgmZ1Vk5PNMCqMczCKVoBDTPG5NFshSJfx5cSm1Ak6KWkPtt46
         MtRSDd0pzJbzUHGD0QQlWOtXe5pwSGxeV+nHsNmJcICVDLmggWuT1dm9iEHYI+hZxYd4
         AHZxhIIMgpbrKdR4c4QbySO2Ikj9fW3SJcbl5m88CIWoY3Gah7/tTR3joCJ7yzsMrJ71
         dlbQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767733139; x=1768337939; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jZmTDTCFrv9l8jR3K2HZi86+beTGTUYM6nRJSha8tIs=;
        b=2ovuS9Pmo9SEaaL2NZp67RNELhj9XIOerNimXDXj3dV1Hn4/fituhzwZ0Tyebx/fXw
         0VxUhJVdZyKvHNDjdSP/aezcZKcybBB9JMLGOkfddrk9UTTOeXCbUwOSYrpFV/SF3lvc
         C5uqzqoWei5CaGCqtmYGCIExebJksUJqTcDBWmSxzFb2ccnb7+79cmLI4cdEFMN1Da+X
         VGdOMlGP2531QnGhWwU07DBND5ym9ZeBXGtmJTjV0JEJgvYQHKk8TjFwmLc5UDlMa5mv
         GvZ7uYsvys4ZhcT2ETw6AWu0eHXaaUNlhYez0jhnJOAwxk8VLqURWfqxlsSFCT6Kwex+
         lbqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767733139; x=1768337939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jZmTDTCFrv9l8jR3K2HZi86+beTGTUYM6nRJSha8tIs=;
        b=iR517bPRlzZlD+KZF/h5/6LMNodnBNQnkI1CFdGt+JJT1dnaTDR+mWzSdg4aG7q6BD
         TVG5leiqYhnwlRL8UB0iR/vBs5fTrh0XLUFqKZ3jsKE5ArbHrojKk8y3Z8LX6t73dQ++
         vfQuUNHviNfkiAPsS02g/yrvUnAbpoi341Y+svSe6uneFUbofuYO7N3wvfEJymXlyZe9
         xKyP7su7ulD0ZivX1geNpDht2v7PPo2kuEpvfl3uOIVeGBujv/WrMoKqgNRmBQ2XeZxs
         MlcrkqAVtPQTmoB8ViatJlYsJ8TOrURuaRAuqRS47cjnKdn7bJE2DdotQ5ZFaevf1zq3
         sP7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVQ+9kzJOeY9k7/KODQCIWVWPK2DW/HFLidc24q34SnEVHHGCmpZC41t+jWGarRHvSepQT04Dmnqw==@kvack.org
X-Gm-Message-State: AOJu0YwL9eBp5DwmaxMM2J4aXL4YMBppFFiB/kp+5g8CIQhM4Dh7GtGG
	iJVxihbOl0tTUXOXdPMlnY/Cbs3cw+sjWAzQ9ln3xC0CaRpsglUnHB9USldMuDaGrGWNnLDWgA6
	Oh+Y19BAm75/r07/SOtsOjVfj1nB+o3NnpI+vSy2L
X-Gm-Gg: AY/fxX7lTohbDyJx6CKbqSkf4Mp4BKM89Mo6pBRPNFduOTAyne0gDvEBVkpTtH0K83h
	fbrVLJBDx49NuNVUE/7S44yJcqmb5T3wHbNMsH+KN31x3xtFb4TGE+npvALYQeXNtjIuUacOmKr
	K6gNlJXP2Vvm0TiROnjOlsOvOqa9txiuAkEwSKbBN9lStBalPFa72/wSnakhEbDtfENWGuYKDQr
	8gloGfZ4cZTdJNrfRgS0wt2lp0ZGMWm5SyuLTVT44uz8rf/UpoaLRORj7/TePSFup1sYy5MKLM8
	bbkffdci4dAtDHKw19hku2u7dA==
X-Received: by 2002:a05:622a:1823:b0:4e8:aa24:80ec with SMTP id
 d75a77b69052e-4ffb3e2184fmr2375731cf.14.1767733138378; Tue, 06 Jan 2026
 12:58:58 -0800 (PST)
MIME-Version: 1.0
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <454c0680d4fdd5504b1e90b2fdaa098bd70d4d2d.1765970117.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpEWwdnNs458wSb__C0eHSEvbvJ9nK3ryQWLTjA3+b3BmQ@mail.gmail.com> <2ec5bf63-139e-4e8b-85e2-efb48adc93fb@lucifer.local>
In-Reply-To: <2ec5bf63-139e-4e8b-85e2-efb48adc93fb@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 6 Jan 2026 12:58:46 -0800
X-Gm-Features: AQt7F2rPbWNeRtSEGklIh1KUrY4FEgTup2fKk8HSjQYnJiuX7lUvgcI16gg4KoU
Message-ID: <CAJuCfpGQQid_VPx9Y1TE4ozXEQM8tWixxLDnS3cvrM3sdT84QQ@mail.gmail.com>
Subject: Re: [PATCH 3/8] mm/rmap: remove unnecessary root lock dance in
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
X-Stat-Signature: p5m747np7ysf5cniy4ncitaiaebiipa1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B0E4040010
X-HE-Tag: 1767733139-926568
X-HE-Meta: U2FsdGVkX195pYTN33f3Qp6R/q8sLMFZ3edoKau+1zyK3gbM25dIaRBYd5iyxKpuqs7NuDLHDyR2CpQBASq7Vr3ejxuJJi8cyDn8uBRAQRiyWgRAB+vzsndOHDOMhfRr/JLsj88EuzqacxnrUaYCniyCg2KWhEaeHJhlVeS0giD0sjpEvSf3FSDDXg+I/qDiuJxFj1uvd8C38PVlJyofyE1imw0/JXOP9RMK89JQzTUQKsSdbRA64jGZsthYhLPn4uqtSiH0EHYeOIwX2ho2Wp/qmR0duIfbLqLPEA1WtF/QTWBUVRergPKVsaBiqc8/SDp+OsmcgzZXRLBMXAspeDpYezfb7dANWbsg/U5fz5P6ytAyRvpzLG57VCZdR7dhZvBQQC6CZpG914p3RhcF8PKKLTGLrEum71FgPpHUx5+3kjS1qC86eQAP+2PTJcBaQbizG1vieN3RUyCkF+2dTcDa4JWDVnz4eNt1HA0+A+pYLWXsmF4VTrbo9JDCtGhT8mwfHYl1+TA0U7Aw/16Dltg4SXqTFVB1/N/juZmWUv/9oUN+C6UuoHCF/aQWLgqELHQrCfET4gwiUcwdNVT6A4ziq/MaTmycevFcF2DipYMT5D/WtIva8ba1Hc4zdvKwxxS1gXRGKPflp96+f7WCJNO4Jg78hv5YXKH5lxWLRAZGcGGW8njIEI3UcB9d+nYJiOd4IQT6h1s2KTUqL4wxuwaLyWPgpyjhKwMUW/DlWAPcNFmqJSlmB1hZ1jLS3u+41/VKh3lNhSmw3reey4w58SQYtUbz/aNmMNmwaJQoWN9rwHgBHegEB2FJaINuQXUwMC/qcBoCi6XBSWW/JvJx4yB6Nx4rKF+jSdGOOL9sRhB7rVezk+87mSpfj1Xcy4/WIXVqyfZJMXpE/UMGygcb01U4bedws4UAKfo6YZC4T+ISRKdfghJuiSWhSfY7PVrnpyfsLtOjPK2p8QHaEEg
 Hv9U6DP3
 DoagXvwEWlMe0CXbgjmPrJKfLWejgVUL/31f2kW2nmE4FgGMvG1uHCAhb0XcnCTJ5mbsdUtWFoKOOgtAEjqGr2cz39uQ2cRPsBn1Lht6dpxQixW0a7pWHQE4hgpka7Hm0yEEjh9nWJkx51/3iNyTfsyJN2LPBqTZGdJWWdrZ4rnZls4a9cI/DSH9xywIrU/m2eaALBQaptX09/vzs4iKzPVhpDbpeJw9WFQI1+4mZoc0YEso/iM3RG0WvPbZRxoyJDyUdOMUF7/92JovnXIMNsVIaJfc9ywS5a59MMxFPL7gCL8xC8ftpGOKWlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 6, 2026 at 5:58=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Mon, Dec 29, 2025 at 02:17:53PM -0800, Suren Baghdasaryan wrote:
> > On Wed, Dec 17, 2025 at 4:27=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > The root anon_vma of all anon_vma's linked to a VMA must by definitio=
n be
> > > the same - a VMA and all of its descendants/ancestors must exist in t=
he
> > > same CoW chain.
> > >
> > > Commit bb4aa39676f7 ("mm: avoid repeated anon_vma lock/unlock sequenc=
es in
> > > anon_vma_clone()") introduced paranoid checking of the root anon_vma
> > > remaining the same throughout all AVC's in 2011.
> > >
> > > I think 15 years later we can safely assume that this is always the c=
ase.
> > >
> > > Additionally, since unfaulted VMAs being cloned from or unlinked are
> > > no-op's, we can simply lock the anon_vma's associated with this rathe=
r than
> > > doing any specific dance around this.
> > >
> > > This removes unnecessary checks and makes it clear that the root anon=
_vma
> > > is shared between all anon_vma's in a given VMA's anon_vma_chain.
> > >
> > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > ---
> > >  mm/rmap.c | 48 ++++++++++++------------------------------------
> > >  1 file changed, 12 insertions(+), 36 deletions(-)
> > >
> > > diff --git a/mm/rmap.c b/mm/rmap.c
> > > index 9332d1cbc643..60134a566073 100644
> > > --- a/mm/rmap.c
> > > +++ b/mm/rmap.c
> > > @@ -231,32 +231,6 @@ int __anon_vma_prepare(struct vm_area_struct *vm=
a)
> > >         return -ENOMEM;
> > >  }
> > >
> > > -/*
> > > - * This is a useful helper function for locking the anon_vma root as
> > > - * we traverse the vma->anon_vma_chain, looping over anon_vma's that
> > > - * have the same vma.
> > > - *
> > > - * Such anon_vma's should have the same root, so you'd expect to see
> > > - * just a single mutex_lock for the whole traversal.
> > > - */
> > > -static inline struct anon_vma *lock_anon_vma_root(struct anon_vma *r=
oot, struct anon_vma *anon_vma)
> > > -{
> > > -       struct anon_vma *new_root =3D anon_vma->root;
> > > -       if (new_root !=3D root) {
> > > -               if (WARN_ON_ONCE(root))
> > > -                       up_write(&root->rwsem);
> > > -               root =3D new_root;
> > > -               down_write(&root->rwsem);
> > > -       }
> > > -       return root;
> > > -}
> > > -
> > > -static inline void unlock_anon_vma_root(struct anon_vma *root)
> > > -{
> > > -       if (root)
> > > -               up_write(&root->rwsem);
> > > -}
> > > -
> > >  static void check_anon_vma_clone(struct vm_area_struct *dst,
> > >                                  struct vm_area_struct *src)
> > >  {
> > > @@ -307,26 +281,25 @@ static void check_anon_vma_clone(struct vm_area=
_struct *dst,
> > >  int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct=
 *src)
> > >  {
> > >         struct anon_vma_chain *avc, *pavc;
> > > -       struct anon_vma *root =3D NULL;
> > >
> > >         if (!src->anon_vma)
> > >                 return 0;
> > >
> > >         check_anon_vma_clone(dst, src);
> > >
> > > +       anon_vma_lock_write(src->anon_vma);
> > >         list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_=
vma) {
> > >                 struct anon_vma *anon_vma;
> > >
> > >                 avc =3D anon_vma_chain_alloc(GFP_NOWAIT);
> > >                 if (unlikely(!avc)) {
> > > -                       unlock_anon_vma_root(root);
> > > -                       root =3D NULL;
> > > +                       anon_vma_unlock_write(src->anon_vma);
> > >                         avc =3D anon_vma_chain_alloc(GFP_KERNEL);
> > >                         if (!avc)
> > >                                 goto enomem_failure;
> > > +                       anon_vma_lock_write(src->anon_vma);
> >
> > So, we drop and then reacquire src->anon_vma->root->rwsem, expecting
> > src->anon_vma and src->anon_vma->root to be the same. And IIUC
>
> I mean did you read the commit message? :)
>
> We're not expecting that, they _have_ to be the same. It simply makes no =
sense
> for them _not_ to be the same.

Sorry, maybe I chose my words badly to explain my concern. I meant
that we expect those fields to still be valid between the time when we
drop and re-ackquire the lock. The comment next to anon_vma.rwsem
definition says "W: modification, R: walking the list". Here we are
walking the list with the lock but are dropping the lock in the
process. I think there needs to be an explanation why this is safe.


>
> This is kind of the entire point of the patch.
>
> > src->vm_mm's mmap lock is what guarantees all this. If so, could you
> > please add a clarifying comment here?
>
> No that's not what guarantees it? I don't understand what you mean?
>
> I mean in a sense, if you had a totally broken situation where you didn't=
 take
> exclusive locks and could do some horribly broken racing here, then sure =
you
> might end up with something broken, but I think it's super confusing to s=
ay 'oh
> this lock guarantees it', well no it guarantees that you aren't completel=
y
> broken, what guarantees the shared root is how anon_vma_fork() works, whi=
ch is
> to:
>
> - Clone.
> - If not reused an anon_vma (which by recursion would also have same root=
)
>   allocate new anon_vma.
> - If allocated new, set root to source VMA's anon_vma, which by definitio=
n also
>   has to be in its anon_vma_chain and have the same root (itself, if we'r=
e
>   cloning from the ultimate parent).
>
> But I don't think it'd be helpful to document all this, or we get into _a=
dding_
> confusion by putting _too much_ in a comment.
>
> So I guess I'll just say,a s I do in the newly introduced
> clenaup_partial_anon_vmas():
>
>         /* All anon_vma's share the same root. */

Yeah, my concern was not the root being different but that the list
itself is stable after we drop the lock.

>
> >
> > >                 }
> > >                 anon_vma =3D pavc->anon_vma;
> > > -               root =3D lock_anon_vma_root(root, anon_vma);
> > >                 anon_vma_chain_link(dst, avc, anon_vma);
> > >
> > >                 /*
> > > @@ -343,7 +316,8 @@ int anon_vma_clone(struct vm_area_struct *dst, st=
ruct vm_area_struct *src)
> > >         }
> > >         if (dst->anon_vma)
> > >                 dst->anon_vma->num_active_vmas++;
> > > -       unlock_anon_vma_root(root);
> > > +
> > > +       anon_vma_unlock_write(src->anon_vma);
> > >         return 0;
> > >
> > >   enomem_failure:
> > > @@ -438,15 +412,17 @@ int anon_vma_fork(struct vm_area_struct *vma, s=
truct vm_area_struct *pvma)
> > >  void unlink_anon_vmas(struct vm_area_struct *vma)
> > >  {
> > >         struct anon_vma_chain *avc, *next;
> > > -       struct anon_vma *root =3D NULL;
> > > +       struct anon_vma *active_anon_vma =3D vma->anon_vma;
> > >
> > >         /* Always hold mmap lock, read-lock on unmap possibly. */
> > >         mmap_assert_locked(vma->vm_mm);
> > >
> > >         /* Unfaulted is a no-op. */
> > > -       if (!vma->anon_vma)
> > > +       if (!active_anon_vma)
> > >                 return;
> > >
> > > +       anon_vma_lock_write(active_anon_vma);
> > > +
> > >         /*
> > >          * Unlink each anon_vma chained to the VMA.  This list is ord=
ered
> > >          * from newest to oldest, ensuring the root anon_vma gets fre=
ed last.
> > > @@ -454,7 +430,6 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
> > >         list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, sam=
e_vma) {
> > >                 struct anon_vma *anon_vma =3D avc->anon_vma;
> > >
> > > -               root =3D lock_anon_vma_root(root, anon_vma);
> > >                 anon_vma_interval_tree_remove(avc, &anon_vma->rb_root=
);
> > >
> > >                 /*
> > > @@ -470,13 +445,14 @@ void unlink_anon_vmas(struct vm_area_struct *vm=
a)
> > >                 anon_vma_chain_free(avc);
> > >         }
> > >
> > > -       vma->anon_vma->num_active_vmas--;
> > > +       active_anon_vma->num_active_vmas--;
> > >         /*
> > >          * vma would still be needed after unlink, and anon_vma will =
be prepared
> > >          * when handle fault.
> > >          */
> > >         vma->anon_vma =3D NULL;
> > > -       unlock_anon_vma_root(root);
> > > +       anon_vma_unlock_write(active_anon_vma);
> > > +
> > >
> > >         /*
> > >          * Iterate the list once more, it now only contains empty and=
 unlinked
> > > --
> > > 2.52.0
> > >

