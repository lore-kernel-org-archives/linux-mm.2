Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4031E7E0C2
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 10:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015DF6B0005; Mon,  9 Feb 2026 05:49:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEE8E6B0088; Mon,  9 Feb 2026 05:49:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF1466B0089; Mon,  9 Feb 2026 05:49:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC7536B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 05:49:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 698171B33E3
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:49:16 +0000 (UTC)
X-FDA: 84424596312.25.3EDD66E
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 76E2C4000A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:49:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dhr2KKiR;
	spf=pass (imf17.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770634154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6FJ3pq0bPa4loGkjTlsa5xdiUrKynoZRmuuLaycpRtw=;
	b=h1TSeVWcIxHJ3FAtGsu2Uur7vy1TnfveVnw6KKZDRJkflueKgU4gbP2sbq2Q/y8GWbRDkf
	UnVoD+ONsbTLhYG/VXm5+0gQIL8J9uO3kwSlRe2Jx3LVO52aYWAhLTzDdMTBMcOiimp8XW
	JYSYVrXOtcqWsFvPd7OIVqCJc1j99Rc=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dhr2KKiR;
	spf=pass (imf17.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770634154; a=rsa-sha256;
	cv=pass;
	b=5ha6MhsxCyoxtmACpQLXixv/hXkdFgp3pA3r14Y72Pjx80JdbFj820W1v7X5d0DS9YPK0O
	l5p8XTSFvygx1RbmgDiAO+dxVlCx7xwZiTgxYrvEbAOy6zheFQ0geZz5pTVeAP5UNHXmPO
	GGFAGcGfiutFFpAwYEF8cf9ZntAPu5g=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-50336cffef9so38666121cf.0
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 02:49:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770634153; cv=none;
        d=google.com; s=arc-20240605;
        b=FbhgAOBsJFSraQ2p8TfR3gKkBP4S8uLaRfPxGhpr1J5+XHpqgEGRjZDTcf1OylAI0e
         rzPgbAgCBNwe6nWtr/efuqV/ENtbKxyQEac7yhFXdIbixm+g8VInGJ2XZe4t8w3QS6Eb
         lDtK/pMPcloFbVmirRrubZXh9TRAr+WzD+TyNWE/BJNQwHkw8gU/uK9q8GiOQXGYFQrf
         /pWXl5LqDS88azeJ0WCdmst11QjDRwHvZ/SIlCTpKlU3/sqiBspothJdXMwOWpiusDmv
         9IigHtilSKUAdpcuZrmpec9MTqvRIFgREP1b4ijzH38eQ6dliM4NpPyB2qp5Wau+hz8w
         G7OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6FJ3pq0bPa4loGkjTlsa5xdiUrKynoZRmuuLaycpRtw=;
        fh=yBxrrJSPE8lxw4cX3p6Imllhq61ReOUh5HVWEDFl1uE=;
        b=D9GCjZyBEtCthuk97Dhu6EWvMIJyQi2mmVcOZABjOT8sYzD09cEFj2V59evk7qnn3x
         dc1ifSbuWPQlpxYBojVi0Vye1C2AG5iw1wJ18AlvLuseUvXvoUpqaUqG6NmtPioRPwlk
         oUIVngpzjgQIUEINmb5qAm2AvAkaK2VyYMmE0L0WOrIy8WaK/MfvfbG1BKTpxG1RmD9W
         4NVcD5O5Lmk7CtbJWj3r8GN44Zzi6iy+u71tfuZI3xijdX8aLEFxW8fcaWzU6/nkQFdG
         CdVTdBIjX2W0K+0ezJ0rUi1fdWP7CX2tp7PN8js9N5Uca6zob3YG9Rr+kv884JHX4/fe
         YluA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770634153; x=1771238953; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6FJ3pq0bPa4loGkjTlsa5xdiUrKynoZRmuuLaycpRtw=;
        b=dhr2KKiROKioJhK1ncCekduJTnSttpHugny2kJipobIuG6LBzGjjZkuWRl7/ieZ9rB
         Fgo28BmJVIOlPf9/DQr1GUYbat4jT+ky1e5ur/Ms812VaXYO/11uQQHUkCDaI0VfHuqd
         hnYDk8UmlT2ByjQ2Q4WJOuxDX23+9b9NAv5LzR2jlcKM5TklHXgFT26tH1yo9F1ebmB+
         gxbYFmx1U7o/d6tcoL8t0sP0V2NKv0jOCIOK+EwwK5SMg6W6pcLl2ipXOSDzzwtcWKO+
         jiPf5SN5V2d0JpOv9jkVFUg43o7kkuRrt5XW6T0ny+mnQj/4RF5mLxDZGGT1CFCFQ87O
         ZMUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770634153; x=1771238953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6FJ3pq0bPa4loGkjTlsa5xdiUrKynoZRmuuLaycpRtw=;
        b=qLW7RVtTJ0Eqtfr3Qb1xjWRK8sNWLJPcuxZLYCdNK4ar/IQIUAOAVYVPSU1MqW/LFG
         9n/ecfJnA13D0ebw+DVCvA2YLGCaO4BB6bDXpxQEpeNeMmgVz0ezVtrChfriohFVpwYh
         2fDau3DFgQIj/sdBBqJBQHJvAnwlfm3iD2lTf+TH5Xi21sVrF90Bw3SRicoiBcNq7fUl
         Q7rOV66zVywsZp9bAjH6TILdH3rrTmSMIJJ506+/AA3oHWUP9PdMmYg0jiH686eLKaax
         Trnr9VKQdeVTFxMmqjC7p7XLLRkO6vjeBgF684pRPSskeekGH2dpH3O0PNO4KwsGgn03
         p5aQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0MurGj34DLyx7GthpKBUkDaE8KZuFRSiVokz/nfIMAAWXxqoIJpXbWp3NcQ6SO4TbLConHf8aow==@kvack.org
X-Gm-Message-State: AOJu0YziUUFPX3ow/O6zTvWPrfP4qb/Uxz/FE2dLq1NxJPVe8UIQKZOl
	uejJ1IvwJA8EVGTGkYMTTFzR7jakeQkQtWRkusbHbq5Oi3h0PRz/RCBB52exO2jAUEnTbyIt97P
	kNM+jEKVCTFI1nqWU18IykDoLjjBqwLQ=
X-Gm-Gg: AZuq6aL6iSUN/xpuXzqMojWVprIkMkl+xnafZ2NF2Sd4Y/Ljju0/Rv2NW2/GDVQyqzN
	7ahO/3o3BovFVvQ1Or8a9OtKiJzCyh/hvxeN3tpBWP+O8hNrlpG2H7n0AfDgtSVFOxr4beA5woR
	Q5eXy+9sE9yslBf6xLTlSpmcIQ2hbwzZ5e3ujZivnKMKVDaC3BfMBvcTyE9SSS3njP3K2gMGp6I
	+Esj3A4KHaWo0mXOmNGd0FWHquU4lf0Zf+J7QPcZno6mj1Om3aeE0694He6L/Js1r1vYg==
X-Received: by 2002:ac8:5945:0:b0:4ff:c08a:52c4 with SMTP id
 d75a77b69052e-50639896af2mr154478041cf.18.1770634153220; Mon, 09 Feb 2026
 02:49:13 -0800 (PST)
MIME-Version: 1.0
References: <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260116162652.176054-1-baolin.wang@linux.alibaba.com> <e5175f66-56fd-437b-a183-b2ccc3f54f94@kernel.org>
In-Reply-To: <e5175f66-56fd-437b-a183-b2ccc3f54f94@kernel.org>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 9 Feb 2026 18:49:01 +0800
X-Gm-Features: AZwV_QhWVdqt_7RuXV7-kVSLDw48X3tEZAOO_6ZSqGLxObnJZ5IOCtH-TVz0o1s
Message-ID: <CAGsJ_4w95tTGfanb0NdG5B+ajOUA4LaH7uh+Uxcq0ZNVaqK-Vg@mail.gmail.com>
Subject: Re: [PATCH] mm: rmap: skip batched unmapping for UFFD vmas
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, Liam.Howlett@oracle.com, 
	akpm@linux-foundation.org, catalin.marinas@arm.com, dev.jain@arm.com, 
	harry.yoo@oracle.com, jannh@google.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, riel@surriel.com, rppt@kernel.org, ryan.roberts@arm.com, 
	surenb@google.com, vbabka@suse.cz, will@kernel.org, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: 73u9seng5zfhp6am1wxiwtkrswb9ju1h
X-Rspam-User: 
X-Rspamd-Queue-Id: 76E2C4000A
X-HE-Tag: 1770634154-932410
X-HE-Meta: U2FsdGVkX18otLLbw/oW/sp0BMQINekOhQVx6wEFaMvuDKKI9lli7xzAmSza7duYjOv2G9v42hXWkszhoog27qt+R2SuzSMlcXWiQXNX7WHKY5FwjchQnAxiF9M6VvEL9y9CMPqobp9hSzBJ7Mfut9cDUGTlJV26fULPx/D2qpCH5xz+XindguQA1bshqQRQmLT+FMBnMdT5enYkXDtwq5XKLJ2Qu7idzr7Oq9Y57Ie69GZpU7yi3I0joPQ4SBxlxNrALEO/e7xZusqB9hXYzjlpr0AYy+1aHjAvDi0yCUT9v50ls9UGuCge2xb/KHnNSZmrIKIrVoFP68U1A8F5FbabbV61caCi9m6zIkgIq1UEuwEmpaVNEYy+W3y2LvS4lsmuU4XUZ3F2jgTqdeDL3IFRsTg2rL0UjPn7+f7M5anvhAabgp4zWMECXEl6+SxHYu+DKxxKt2NQBKk5So4Uwg59riMeBCfz4seJCH3LD4VeV1ZuA2X1owkt8Hl4CR1edEYH5yqiIqtZLc6b95NyBKAUe4G15nhIRECICwOnQuJJ6RWqe2RJeuRXfce79frh7kDOj1jc41ZJ1wAd/IWb0njQ9WvPx26D8mizza5xiusARMqpn7SQiUEBNnijP7BzX/GMC0yVh7B3dKEVYAGTO1BwRejZitLI5Gk04EBsfUxS5mdZo5XssDiCYqj1P+1ybHMl/GFDNJIYWLBrz1n3WYSSlymtLrszCzI3q09CUxZX342Ds4+q5tNLuaUoXiSwpHRNKJcBsfurSl0vwOGV9Es82ouLo5mb8Yg8uGvSUq6WmjXG6LpSxDjHJIfWHKFlXQxB1tgeBOXvkgc7JkAfDTlxYVVx2dKkbPb/MnE4WUy8p4gcMz7+SatQBl1mXyOCyN/IzlQkeJpaW492GNF4heipYCDuTWUV33/DmXWeX4qomVBO3RjO+6NQxNz0LoMoz1BRD2mfh9FiZLCQxsf
 i8GBR7ij
 ajSBAXQjmhJi69ZCzXR8F06FD/2r0LZFo95K4ty5jrkUpNoDNBA68tOFenymbXB65Gbb5yA8x4MT/LyOE8D2C6+xeQ1A5uKajsT4iIwXycHnczV0JhuTxkZfeyw+rYNCV89Ptn81j1QetdVa+MWJw3mPcXW1KnDUhVSinPPLf/WB5+uNnyLxlZCFUWYD4SLFvr0dBEe6mHH4fYD2Hyidm79xcBuS/Wq3rKrZZ0pcBT6GkabLJltT05ovzML6ZJE9ugIPMt4W32LvGIBXZg7A1J5GwQ76Guz00RaGwm8BS3Y26wSwv1zUBXk7ks9/UxJMym89EEqinHRCgWMw9uplncION+4erBqeuFEIK2Pi+c6OgVZ7DGH+tgq3dTouTACqJytUBlG2j6zVUgBSFhWSRxdnucJo3HuBmfBy/yhBHeEOrfZpk8fJXqbfgTDIN3cdtjnnYi0xP/srGP6pINpnFlrtLhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 9, 2026 at 5:54=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 1/16/26 17:26, Baolin Wang wrote:
> > As Dev reported[1], it's not ready to support batched unmapping for uff=
d case.
> > Let's still fallback to per-page unmapping for the uffd case.
> >
> > [1] https://lore.kernel.org/linux-mm/20260116082721.275178-1-dev.jain@a=
rm.com/
> > Reported-by: Dev Jain <dev.jain@arm.com>
> > Suggested-by: Barry Song <baohua@kernel.org>
> > Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > ---
> >   mm/rmap.c | 3 +++
> >   1 file changed, 3 insertions(+)
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index f13480cb9f2e..172643092dcf 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -1953,6 +1953,9 @@ static inline unsigned int folio_unmap_pte_batch(=
struct folio *folio,
> >       if (pte_unused(pte))
> >               return 1;
> >
> > +     if (userfaultfd_wp(vma))
> > +             return 1;
> > +
>
> Interesting. I was just wondering why we didn't run into that with lazyfr=
ee folios.
>
> Staring at pte_install_uffd_wp_if_needed(), we never set the marker for
> anonymous VMAs.
>
> So, yeah, if one sets lazyfree on a uffd-wp PTE, the uffd-wp bit will jus=
t get
> zapped alongside. Just like MADV_DONTNEED.
>
>
> I'm fine with that temporary fix. But I guess the non-hacky way to handle=
 this would be:
>
>
>  From 53d016d6e6f624425dbdbc2fb1dec7c91fbef15c Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Mon, 9 Feb 2026 10:52:59 +0100
> Subject: [PATCH] tmp
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>   include/linux/mm_inline.h | 15 ++++++---------
>   mm/memory.c               | 21 +--------------------
>   mm/rmap.c                 |  2 +-
>   3 files changed, 8 insertions(+), 30 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index fa2d6ba811b5..8a9a2c5f5ee3 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -566,9 +566,8 @@ static inline pte_marker copy_pte_marker(
>    *
>    * Returns true if an uffd-wp pte was installed, false otherwise.
>    */
> -static inline bool
> -pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long =
addr,
> -                             pte_t *pte, pte_t pteval)
> +static inline bool install_uffd_wp_ptes_if_needed(struct vm_area_struct =
*vma,
> +               unsigned long addr, pte_t *pte, unsigned int nr, pte_t pt=
eval)
>   {
>         bool arm_uffd_pte =3D false;
>
> @@ -598,13 +597,11 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct=
 *vma, unsigned long addr,
>         if (unlikely(pte_swp_uffd_wp_any(pteval)))
>                 arm_uffd_pte =3D true;
>
> -       if (unlikely(arm_uffd_pte)) {
> -               set_pte_at(vma->vm_mm, addr, pte,
> -                          make_pte_marker(PTE_MARKER_UFFD_WP));
> -               return true;
> -       }
> +       if (likely(!arm_uffd_pte))
> +               return false;
>
> -       return false;
> +       set_ptes(vma->vm_mm, addr, pte, make_pte_marker(PTE_MARKER_UFFD_W=
P), nr);
> +       return true;
>   }
>
>   static inline bool vma_has_recency(const struct vm_area_struct *vma)
> diff --git a/mm/memory.c b/mm/memory.c
> index da360a6eb8a4..0a87d02a9a69 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1592,29 +1592,10 @@ zap_install_uffd_wp_if_needed(struct vm_area_stru=
ct *vma,
>                               unsigned long addr, pte_t *pte, int nr,
>                               struct zap_details *details, pte_t pteval)
>   {
> -       bool was_installed =3D false;
> -
> -       if (!uffd_supports_wp_marker())
> -               return false;
> -
> -       /* Zap on anonymous always means dropping everything */
> -       if (vma_is_anonymous(vma))
> -               return false;
> -
>         if (zap_drop_markers(details))
>                 return false;
>
> -       for (;;) {
> -               /* the PFN in the PTE is irrelevant. */
> -               if (pte_install_uffd_wp_if_needed(vma, addr, pte, pteval)=
)
> -                       was_installed =3D true;
> -               if (--nr =3D=3D 0)
> -                       break;
> -               pte++;
> -               addr +=3D PAGE_SIZE;
> -       }
> -
> -       return was_installed;
> +       return install_uffd_wp_ptes_if_needed(vma, addr, pte, nr, pteval)=
;
>   }
>
>   static __always_inline void zap_present_folio_ptes(struct mmu_gather *t=
lb,
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 7b9879ef442d..f71aacf35925 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2061,7 +2061,7 @@ static bool try_to_unmap_one(struct folio *folio, s=
truct vm_area_struct *vma,
>                  * we may want to replace a none pte with a marker pte if
>                  * it's file-backed, so we don't lose the tracking info.
>                  */
> -               pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pte=
val);
> +               install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, nr=
_pages, pteval);
>
>                 /* Update high watermark before we lower rss */
>                 update_hiwater_rss(mm);
> --
> 2.43.0
>
>
>
> Does somebody have time to look into that? We should also adjust the doc =
of pte_install_uffd_wp_if_needed()
> and turn it into some proper kerneldoc.

I'd nominate Dev, if he has the time, as he has been working on
related changes and is already familiar with this area :-)

https://lore.kernel.org/linux-mm/20260116082721.275178-1-dev.jain@arm.com/

I assume this could be treated as a separate optimization, as
the current temporary fix seems acceptable?

Thanks
Barry

