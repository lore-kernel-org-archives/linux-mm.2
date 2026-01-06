Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 653D9CEFD0C
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 21:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C82DE6B00AB; Tue,  6 Jan 2026 16:20:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C876B00AC; Tue,  6 Jan 2026 16:20:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04926B00AD; Tue,  6 Jan 2026 16:20:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 998A16B00AB
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:20:46 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23B6E5D0B9
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:20:46 +0000 (UTC)
X-FDA: 84302808492.08.42FA2D9
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0C7321A0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:20:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mDSyjlDF;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767734444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3dGEzAyvhIQxfi89wOpHCfP7sC0Yh8V2PTA10IoVoY=;
	b=3inXE/krNyCPg6B971mlSSv2IARcQsDP67nUZ85YookHYbBaXZVDSjFaQNKByvaa6Fs079
	E6yvqUFollmOtaNnUvqYDT1KZ3/Rrj5CZbTLTmiOhapqQQqxPfTiTtZeErSJ+s5+5uhBwD
	P0aKUUlr8UIwYgem9A/THEwZE5/9Buc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mDSyjlDF;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767734444; a=rsa-sha256;
	cv=pass;
	b=4PE0rZPg9rqJVMxp/pbsDMecUHrP1ILGd6fsCbnOMThqptPBAbgYNEtACSn+aZkZ7KvkXz
	PY/so370nyU2ljYmPJW49hs6oGbIv+avAHo7mpvS2W1IAQLDgx3Ntezr5/tYcS3Ks66d7F
	TZfPLGT/cBi0VikvIR7pK77GzkD1LMY=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6505d147ce4so2789a12.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 13:20:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767734442; cv=none;
        d=google.com; s=arc-20240605;
        b=htvhWFmKBBs4/9YChYUaUvIT1mqeUZisWsJHQZ9+ZrPB2RtPi9kkdCTDBl1JjJOPlZ
         WSOApAzP8sZq54EBnoZZb2LBOpGZsEqxWCvFzDzA+dynjJzP5WzljS3U0/nhrhknUnSI
         ShUDoqCJQoUsec9fJhvlH7n7Z/SXLRPGoCZfyIoFsvBLecwpc8t/+XAIBcdPzgknr46N
         ScmsEqCurS86EuCn6r0q3abgOputAPdG5E7RTgyMi9R+0XFeB6LGFLvaL6XwPWHwXnRQ
         aCAu4FlV+J5nbscI2PVkgdVK5qYFFv2F9NdS3LrqHyV8JaN1PNsZDX1cJmXHhoDJDiV2
         0zog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G3dGEzAyvhIQxfi89wOpHCfP7sC0Yh8V2PTA10IoVoY=;
        fh=+l52Pbjp0YAo6slDJv4J0hTB4ooi9fMoVhlMPolwtn4=;
        b=SVORgmHi08Y4Xbl3Jd3Nju7HOWjRbWFl1M1VI8vxExra9mldplH7LSZ0X4wvL6ytTG
         fqa50NPD+Zbrf6VGW0Fw33JipQ7eSOXDQnpLQ8Hm0aND3OQTrE69Tkn7zn//bqxdwsGU
         AsY4r8rHPy6Uv4j6AaAmKJP9RVRHYHMNC1K91tLdiP47MJPk8iC8RtgL4gbhl+4c1fB0
         iQS2Rb+f07DUos/oHldOEJRRV1BJEIzcMQk6QRWmbjDgnyuqZqZJi1xJhnAbndYUqYtw
         xu4mgfCGzfJV+6VS2R0CMGTjxyNWoRFiYdh2np/7Kk854HQ1b0lyhBSwQ9I+FxKvkYed
         vfRg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767734442; x=1768339242; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G3dGEzAyvhIQxfi89wOpHCfP7sC0Yh8V2PTA10IoVoY=;
        b=mDSyjlDFr3PU9Cbsj9haCuFT7X9CkYE7fmVXZM6Z6e7iqxSVqVcJHDiMkU4/fSwGx/
         oLwXnJLeJ/ZSB8K+iFX54UNqhZjn9zokd6qPV2BxhzUq0MuhSfO6+ErRmnHozzBfCHGa
         WwUPz8pMVKquOdcg5LhedUwM3DJ9W+WWOwS+wPgXylMBYvFgnOE5BGtJvnCKBmKNJHXW
         pGF7Cuj0yhLB3L5BJaC2QIYqDaTJoMGHdct7yDh0kF5jL11NegZ//28LrtQAspuyFGa3
         F2WN1pU/Y36VBe2+FUXJTl2B66WOhEw6/b04XSf76zWFKg72Nz4WsQpoapZ+DldBh0gj
         cEBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767734442; x=1768339242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G3dGEzAyvhIQxfi89wOpHCfP7sC0Yh8V2PTA10IoVoY=;
        b=hvM0HrGdZsTLserUpdXmj2Uuy3sOb4YtKny6d8RcTWyWT/P3YmPxk20ENILY+N/rZl
         WAv+dS8IlQ8gJ35L1Uf3IFzfwzw8C7gFPVKits6k6rVvcL6y7MkdaBUXrin6PmTZPz6N
         LMGK2AcvViqjXtbe4bhqgBXVsTzwKkHUu1VCfjXDfN575nyIppuuMSEbyqerd357+tKF
         33Yd7OuPK5cV5hPo12nnLDePmyp17rbNHhD8azQxBEgh9jFLpIhO56VA/UOGQc6Iv93a
         rrJU/RiKY74A8V5MbyuKVtLufqIy0efBYh0Qjlj59xzP9azSYxtnvvjoa8kVwsGwOVP1
         +IVA==
X-Forwarded-Encrypted: i=1; AJvYcCVskivFpwjasrP1X3JMilgSJ83A8u9GL2wSzXPg5e9rVmuFHGH6UM9vek5AvqLh9Dm+4dKzwK0DUQ==@kvack.org
X-Gm-Message-State: AOJu0YzXxHXz1qbAQEImHejb1M5wPxXrEqUV0GufUk3nvBeAYwHmbh1U
	WJ8Jq921esXujXEzlMHtliNm1zkf/yFC+6TSVp0hYkzVdY5kps5cXVgXNG618NQ4C0UgSCW5VxY
	nkxqDgjJ1slCMeG3YgudOb2HpHqehdjiy+AUuQU+M
X-Gm-Gg: AY/fxX7EzoA0IluRnxQ3yOxZ9O68fyz1xouQiJaZYxH3hIwbyMrYrwZPc7vAQ6oZ65M
	FHu4IwNl0Yp4snRJfqKRtxNKpyvTpo+prbZnho1FsUnrIxNdkFuOxvRo/1PawZBDoxUeYNEfrPM
	HXTiBFWtUXZqAO468FpeP4Bb4phVxFqL+K/NCIJfhaGE/b8Z9q7YDnrXswYKAq6OF0N24ie2mnM
	eZVmhEHgcufvbRbEnfbNmZjBbtzsBMIyTnVIae72E+wrgmwYLCd7nFORMos7rGq0eYgx+e0O4pp
	dr+ns9DJzWmIrN56KfmEegdHzg==
X-Google-Smtp-Source: AGHT+IEcvWgNFI9a+FTZMbphSlXQ8Zuxx6/i+WqW+It0LG3jn6ton00nUSvPJB/CSFIAnA6s6y0NkLqvQo6im5YeY34=
X-Received: by 2002:aa7:c90f:0:b0:643:6975:5381 with SMTP id
 4fb4d7f45d1cf-65097c5bc4amr7334a12.15.1767734442183; Tue, 06 Jan 2026
 13:20:42 -0800 (PST)
MIME-Version: 1.0
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <4ce4ec09b92664091e8935982d83dde3a4c7f898.1765970117.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpHWUj6npkpMsgHmLHMk4NHRzaDyDG2oQk1SuQ53swcMSA@mail.gmail.com> <03723727-7fdf-4f06-8117-bbe2d6c2b7f7@lucifer.local>
In-Reply-To: <03723727-7fdf-4f06-8117-bbe2d6c2b7f7@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 6 Jan 2026 13:20:29 -0800
X-Gm-Features: AQt7F2qEiHWOjdWMT1089zNBJOWU_k13wb_cWMTlcUPlU8EuW4TE9TKXr8ze4S8
Message-ID: <CAJuCfpFvAOBVyv+UaTS+_9scTdPmo2-vsTE98-XSOpZZe=_VhQ@mail.gmail.com>
Subject: Re: [PATCH 7/8] mm/rmap: allocate anon_vma_chain objects unlocked
 when possible
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0C7321A0005
X-Stat-Signature: pefxdeeoomj8ky49pr75iauf7ssajr65
X-Rspam-User: 
X-HE-Tag: 1767734443-352868
X-HE-Meta: U2FsdGVkX1+7Y0cDVZvjCDwsKtrg0yMNTWnNVW11mPi2/5hpIjKw62ZrW4EZy2lgMZ66M/754igAK5V2T4XZ835kfYEDHYCaLCbMqbpXV1VIfbQYcwDMH2nFEaPagdS/bf9qYyT/cRU6wGkZtj42oBh4eEKWfHVt72S9KKesk1z5y7GkCsPaZTFSv7pBSEvFeKHxE77DsZDhd841Qww1wlMf67NaJqAg16QYbss1TNDzpSMAnG8dRy+dDV//2hKDitjD+mCOIzu1sZ6ksiRO03HwuHY7HhoMycV7IzHpkpSB6TFR6BfT2ECcFVCTb+tT3ulB78HkPYG4DPHmKQw3Q9n0vV9YvGptS17Wmi4hHrpPkf32w/o2a+oXDQlS4D+DYENK3Tdoutjvf5hu26T/9dvd/N09L5AnMLcOsHNKTZOVAmcJ8KgtrvqD7IWu2ZgMV/NgGOrLUQCyv1IXEYAPU7glfTaolZJ0DpZZiMpJ+leoZkmAhCQqXXyP8hHD0NOfmYMwrz+6iexXNr71o0SCu7Aae2Si5UI+qOpfsQk6gbuiWcRaB9E3I9iRqsK8vc7KFkJujzCRCvqCMat9Y0g79ysBjouOqu2hzzCt4k2mRXWKmt/2cvkTExeuBEHiM3i/zN1shyFZth5iHEZKNuG/SJ+X1XyGNW/LFZjQ6g+2za/M0Ib3BUxLbFlOlcdxb5P8AR9lRydVIIUDelc9l9zl1BC++0SEqnDTOTxvlQp4RAZofqXIArylvPKlTDrwsjqhXWQJzK7ggXph+BNAc2g5r4QJt9XGpFzobC9txjpnf8OzOkDtSQFEz8spx1G4op5+bGuH0sN4KYA0l7dXjNew//No9EN1EpAGKk5fXkbFhP1S4fB6RT/sPydJsVk7p4yTC5pB2TQAMR5/RPMuQAEbihs4FjK0MXZcCMkky1f8fTcaedxGkOlxhROS44dVL8LMW90DunYmxIq7XpVLYvj
 3rxtWWE7
 vUjKXgkCMyGuxHDFQqRQOaBKKiawj39kf9tJtEWH/wOmpVarc70uwcKWygWjddCNlxpLfxWDzRO7RTBB2pEVYAf+dBgZqarAn+gOzccVUwBVmsh/twx7NYxJjtGdd9AXfAemtqPzhNT4Vj6H3AxkditvoDSouxgqwtL9Po8ZtpN6RwlPasnL/zHkN+fFuVB4X08HYi06pBjeIAahaVgwPnNLwRftTBtRFx8bGqKRfnYF1ML7LSrbMUs34kztV5KhIfxsiYaGUO6CxXoPTeqAKNChWU8YslSVgZO6kSgUvqfB1YeFgDeUSBFJajEYruf8rNXPw8039ZaM+FOF2zF23wsF03N5rlHE+i5pABQ27BfAkJg29q1ei0J/7eAU13LbBtLD9hiDrFTTBEG8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 6, 2026 at 6:17=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Dec 30, 2025 at 01:35:41PM -0800, Suren Baghdasaryan wrote:
> > On Wed, Dec 17, 2025 at 4:27=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > There is no reason to allocate the anon_vma_chain under the anon_vma =
write
> > > lock when cloning - we can in fact assign these to the destination VM=
A
> > > safely as we hold the exclusive mmap lock and therefore preclude anyb=
ody
> > > else accessing these fields.
> > >
> > > We only need take the anon_vma write lock when we link rbtree edges f=
rom
> > > the anon_vma to the newly established AVCs.
> > >
> > > This also allows us to eliminate the weird GFP_NOWAIT, GFP_KERNEL dan=
ce
> > > introduced in commit dd34739c03f2 ("mm: avoid anon_vma_chain allocati=
on
> > > under anon_vma lock"), further simplifying this logic.
> > >
> > > This should reduce lock anon_vma contention, and clarifies exactly wh=
ere
> > > the anon_vma lock is required.
> > >
> > > We cannot adjust __anon_vma_prepare() in the same way as this is only
> > > protected by VMA read lock, so we have to perform the allocation here=
 under
> > > the anon_vma write lock and page_table_lock (to protect against racin=
g
> > > threads), and we wish to retain the lock ordering.
> > >
> > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >
> > One nit but otherwise nice cleanup.
> >
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>
> Thanks!
>
> One nice thing with the separate cleanup_partial_anon_vmas()'s function
> introduced as part of this review (thanks for the good spot!) is we can n=
ow
> simplify this _even further_ since we don't even insert anything into the
> interval tree at the point of allocation, and so freeing is just a case o=
f
> freeing up AVC's.
>
> >
> > > ---
> > >  mm/rmap.c | 49 +++++++++++++++++++++++++++++--------------------
> > >  1 file changed, 29 insertions(+), 20 deletions(-)
> > >
> > > diff --git a/mm/rmap.c b/mm/rmap.c
> > > index 60134a566073..de9de6d71c23 100644
> > > --- a/mm/rmap.c
> > > +++ b/mm/rmap.c
> > > @@ -146,14 +146,13 @@ static void anon_vma_chain_free(struct anon_vma=
_chain *anon_vma_chain)
> > >         kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
> > >  }
> > >
> > > -static void anon_vma_chain_link(struct vm_area_struct *vma,
> > > -                               struct anon_vma_chain *avc,
> > > -                               struct anon_vma *anon_vma)
> > > +static void anon_vma_chain_assign(struct vm_area_struct *vma,
> > > +                                 struct anon_vma_chain *avc,
> > > +                                 struct anon_vma *anon_vma)
> > >  {
> > >         avc->vma =3D vma;
> > >         avc->anon_vma =3D anon_vma;
> > >         list_add(&avc->same_vma, &vma->anon_vma_chain);
> > > -       anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
> > >  }
> > >
> > >  /**
> > > @@ -210,7 +209,8 @@ int __anon_vma_prepare(struct vm_area_struct *vma=
)
> > >         spin_lock(&mm->page_table_lock);
> > >         if (likely(!vma->anon_vma)) {
> > >                 vma->anon_vma =3D anon_vma;
> > > -               anon_vma_chain_link(vma, avc, anon_vma);
> > > +               anon_vma_chain_assign(vma, avc, anon_vma);
> > > +               anon_vma_interval_tree_insert(avc, &anon_vma->rb_root=
);
> > >                 anon_vma->num_active_vmas++;
> > >                 allocated =3D NULL;
> > >                 avc =3D NULL;
> > > @@ -287,20 +287,28 @@ int anon_vma_clone(struct vm_area_struct *dst, =
struct vm_area_struct *src)
> > >
> > >         check_anon_vma_clone(dst, src);
> > >
> > > +       /*
> > > +        * Allocate AVCs. We don't need an anon_vma lock for this as =
we
> > > +        * are not updating the anon_vma rbtree nor are we changing
> > > +        * anon_vma statistics.
> > > +        *
> > > +        * We hold the mmap write lock so there's no possibliity of
> >
> > To be more specific, we are holding src's mmap write lock. I think
> > clarifying that will avoid any confusion.
>
> Well, it's the same mm for both right? :)

Hmm. I think in dup_mmap()->anon_vma_fork()->anon_vma_clone() call
chain the dst->vm_mm and src->vm_mm are different, no? After
assignment at https://elixir.bootlin.com/linux/v6.19-rc4/source/mm/mmap.c#L=
1779
src->vm_mm is pointing to oldmm while dst->vm_mm is pointing to mm. Am
I reading this wrong?

> and actually the observations
> would be made around dst no? As that's where the unlinked AVC's are being
> established.
>
> I think more clear is 'We hold the exclusive mmap write lock' just to
> highlight that it excludes anybody else from accessing these fields in th=
e
> VMA.
>
> >
> > > +        * the unlinked AVC's being observed yet.
> > > +        */
> > > +       list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
> > > +               avc =3D anon_vma_chain_alloc(GFP_KERNEL);
> > > +               if (!avc)
> > > +                       goto enomem_failure;
> > > +
> > > +               anon_vma_chain_assign(dst, avc, pavc->anon_vma);
> > > +       }
> > > +
> > > +       /* Now link the anon_vma's back to the newly inserted AVCs. *=
/
> > >         anon_vma_lock_write(src->anon_vma);
> > > -       list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_=
vma) {
> > > -               struct anon_vma *anon_vma;
> > > -
> > > -               avc =3D anon_vma_chain_alloc(GFP_NOWAIT);
> > > -               if (unlikely(!avc)) {
> > > -                       anon_vma_unlock_write(src->anon_vma);
> > > -                       avc =3D anon_vma_chain_alloc(GFP_KERNEL);
> > > -                       if (!avc)
> > > -                               goto enomem_failure;
> > > -                       anon_vma_lock_write(src->anon_vma);
> > > -               }
> > > -               anon_vma =3D pavc->anon_vma;
> > > -               anon_vma_chain_link(dst, avc, anon_vma);
> > > +       list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_v=
ma) {
> > > +               struct anon_vma *anon_vma =3D avc->anon_vma;
> > > +
> > > +               anon_vma_interval_tree_insert(avc, &anon_vma->rb_root=
);
> > >
> > >                 /*
> > >                  * Reuse existing anon_vma if it has no vma and only =
one
> > > @@ -316,7 +324,6 @@ int anon_vma_clone(struct vm_area_struct *dst, st=
ruct vm_area_struct *src)
> > >         }
> > >         if (dst->anon_vma)
> > >                 dst->anon_vma->num_active_vmas++;
> > > -
> > >         anon_vma_unlock_write(src->anon_vma);
> > >         return 0;
> > >
> > > @@ -385,8 +392,10 @@ int anon_vma_fork(struct vm_area_struct *vma, st=
ruct vm_area_struct *pvma)
> > >         get_anon_vma(anon_vma->root);
> > >         /* Mark this anon_vma as the one where our new (COWed) pages =
go. */
> > >         vma->anon_vma =3D anon_vma;
> > > +       anon_vma_chain_assign(vma, avc, anon_vma);
> > > +       /* Now let rmap see it. */
> > >         anon_vma_lock_write(anon_vma);
> > > -       anon_vma_chain_link(vma, avc, anon_vma);
> > > +       anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
> > >         anon_vma->parent->num_children++;
> > >         anon_vma_unlock_write(anon_vma);
> > >
> > > --
> > > 2.52.0
> > >

