Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23797CD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 05:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2830F6B0005; Mon, 15 Jun 2026 01:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2339E6B008A; Mon, 15 Jun 2026 01:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 122996B008C; Mon, 15 Jun 2026 01:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00C2B6B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 01:38:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 44B9E926B7
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 05:38:58 +0000 (UTC)
X-FDA: 84881043156.20.6252BDD
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id 40D721C000A
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 05:38:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cAOl3sJz;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781501936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4bnIeDaNSPPrqMDBXyAFUZle3FRm0a9rX7dbKOylDo=;
	b=pE0/gqDklszRiKpPmjUPHQUpH6Q8oyFqecneTL6BzDgTWbuX8Fbnu2DcqW0xY4/qpRibwh
	84RIMHH69t+n+EKnwhqzxExgwUPMVazOezMPfrldh6o2W/yMLOfSpuMzk2s2Ozvb8kQC4p
	sEVC8iqdreOHWyvhlRLoHKBLq5CzY2k=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cAOl3sJz;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781501936;
	b=K0HrmGEAyggjM2Aq56bhAQYLDMMkC6u1EAtpwfUYjvEFbIBoeA8tUgHZhSnpeXT5Uz2Ch2
	maZYZ/96igyfBnJLhZGsAun7Obe8AwgqoryicjzihehIJoU77fQq4wPdueuJBrPBWUayHF
	EhimTzCdgZ0TTtC+ZD7UB3dRvGUgDr4=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5177d1ff061so744311cf.1
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 22:38:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781501935; cv=none;
        d=google.com; s=arc-20240605;
        b=ZHHYb19F0JdXYD33110F99HlLVlu0ii23bCs5BmB9uzMvTOn743LjHb7EjI/sopzw8
         YNANcqQcS5pNnq7txEygOg60FbphJ1VjPoQIlMBjoK0Dth94xERblNgXeBR/qekDCove
         Ik/HjvE1qNIRv1u8fB/cB/s0X5nt0xN00Xtfxq3j/2FynegVL0v7AhzmeKexMwH9Fta4
         dVvrqpF/PmZE+3asUOgTJ3gZY43y8S1adTTXHocbXQisMcmR/vtrpy7Ux6sVCvk0LzVu
         VsEeOwolwSx2dbN/8Pgi5ptSNzmJXrg8WNo/meZar0WNI5BZdJ/zyRGOsWFJu8fMqJZM
         hLhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z4bnIeDaNSPPrqMDBXyAFUZle3FRm0a9rX7dbKOylDo=;
        fh=SpOpjpAF6NFqF+9aOdU5G8uqs/r2c5uJTh0qH2yy9lg=;
        b=OzYSkLoPv+bjSplUpomxtRUuIzdfDt8B1dRq+zPrAXfHPmhg9dVHw/k/Xdd0WM4IkS
         dMHv0qnrg65KuQDzNMUwspo11briGiq9yJVDP7lIZkL+sZ/uPiHkggZnoLIcr1M2XnYR
         +D+d7DueP4WTXvQ0jbpgQespJmhObOQY0UC/vslwyjEpKoKKWPwUZ2rWTx1rTBG4IRMV
         /hBsTjY9wZOCAw+MYwOEsVkj9KfZMhB1JvdNIlsl35Zh0/aduDptP8Vw985JX5VRRK5J
         Bc/w1id9zuI33XuJcR7OC8pIy4f57QZuAQflym/UV58FV+8ecFjwT1gcu8U+LObs1r3M
         464Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781501935; x=1782106735; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z4bnIeDaNSPPrqMDBXyAFUZle3FRm0a9rX7dbKOylDo=;
        b=cAOl3sJzx6hu8Kpw9nPNAODAHS6m3DqPy+Rv782nScGWAFRldaybnonCc5Xj0n5W85
         RqgWvbreUqZ+gNK//FQY/b/oriOi+Upv8WbDvhVUb1o/NmcbVXd0ifAU7kO9H9Ucmf5d
         81MGBObfvizbRLwTnNLHwMg6ckrQ3d5KXVs+3os9Q1be085Xf9FmPLMB/oQmFffcfu3/
         6JwtUynFRNT9zsCXOQtm2To38WkCHdUYdiIOIVZWsTqNLbKrSUXv9qymddyNXqOVEaYB
         0gdoD7XrDtBuif4sT7kLRC+wukeB0CdqDpHwdyKTJ2ou77PcsWkhSpq3/Fp4BaxK8g6i
         XZ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781501935; x=1782106735;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z4bnIeDaNSPPrqMDBXyAFUZle3FRm0a9rX7dbKOylDo=;
        b=hQu36gOuT6i14IGzuvlXU7ltAinWrS+7RE9haKxQ89YLSQFpNSs9uhz+BxgEhXaPgF
         E035iVJA28nqiXITlHz05UsbFsGUj+O+Mb4t+V4iQa//5QaX+kTJGaI/ZvQw2P2CPcTQ
         cneJYpVXDgLHctq/qu23Spes0jWKQ0XIEm/APfKacA/RqQKGf/7PYk+Du1f3rBURnkrQ
         80mZhLXPVx5aSBeoUfbCoOeCjon5aPkigwDGwzQgdnz8ABZjk8eW4BxgH/eHQZ76syok
         f08WUrgXw3BVC/m5tRDjPsRr+VyyTwFB8lq+vTAq32cpOpCa931z8BF8pvC85VWzZE7e
         jwqw==
X-Forwarded-Encrypted: i=1; AFNElJ8XgK1zulSU+z85QDGEmsMfPdQ5porT1UaejieKXoHoKJzk8MtabgxUN86e39ZY9PL9ptJVDdMK7w==@kvack.org
X-Gm-Message-State: AOJu0YzBkDgNW/KzfcjV3wTVZlfsZezvCzpsNqNMRbgS9p/QZL3WIVrk
	xH2LS4fnl2TdGetDNSV8yk+9Myj28yleqQU/3xG2awJar35YFLVGF7e/2Bh48bEh/eIAFo9ijS1
	AN9TrvaBYLRtKqTzjBFahlbHYoy2iVUSdWPNmeidE
X-Gm-Gg: Acq92OGopl5SKU+XMa1pmmLNvRO4L+l+Fps06wOqmj4FRDZWRDBlyXTlIxWhGMatQoa
	/+9zips+PR4fyL5BmxEiTiV8/PDNsjEtmKqqpk6rzhts3bROJj+ySTcVPad1lHzz2oKDwXpJM9o
	1OZWM8J5hceKPhqR49TOemC+idhS0Cxo7hVVm/ZdQaZfpV+FkTuXmnBQSlYkep+mKYB4T1vtYL/
	noueIjFxMX4/vp949vmIhfxowD6Wc+iiqlQdRwQUH49W6gFWCW7KiAsRIylMK9o1/FWiia+pI7o
	zUt2mmBrk7wWB6cA
X-Received: by 2002:a05:622a:164d:b0:516:4f62:85e6 with SMTP id
 d75a77b69052e-51955eb53cdmr13355061cf.17.1781501934662; Sun, 14 Jun 2026
 22:38:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-15-7190909db118@kernel.org> <aiurbPx1SISBarBy@fedora>
 <49f1bf1e-fcaf-48fa-a7b1-f8ee78b19762@kernel.org> <aivpob0Zgnbc4AG4@fedora>
In-Reply-To: <aivpob0Zgnbc4AG4@fedora>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 14 Jun 2026 22:38:43 -0700
X-Gm-Features: AVVi8Cdhr2RooHXSlNvj28OLPacEXOJK306RRvpVNfECIcIuVo5lz4eM6C6SxwQ
Message-ID: <CAJuCfpFNftMYw0XoHyN1QAWfm7NYmeuY1T_NGbYy8boGO48MOg@mail.gmail.com>
Subject: Re: [PATCH v2 15/16] mm/slab: remove __GFP_NO_OBJ_EXT usage from alloc_slab_obj_exts()
To: Hao Li <hao.li@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Hao Ge <hao.ge@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: dp7r5b5e6bfpcybuurpc3dcam1344cnr
X-Rspamd-Queue-Id: 40D721C000A
X-HE-Tag: 1781501936-123998
X-HE-Meta: U2FsdGVkX1+0NOmvOZvcX05cfHXwC+jtltSdfuPN4yIxvJ4iz2idCebHUyLw7fugzltgyYqS+Iduq24lIRAF2zuVlub1spn+TV4/16GrQM3RR68FAP26tSsVmKR9C0K2lqUVmRV9gk/kEBG9qMeDfmB3RyTMGcE2uhz8lpSFG7y8qOurmPusrDSZeC47iRUdde6UIVXD976NpoI+/Oi/epaqIjfc5MuUa+IF3ws9RpKf7RlXjI0be4ZFEg6btS/lWE08u7FTfRttuA1JRIgBZNwqFC74fabUpiPvJuImHq4sUiRfjgot1qfVkT70bFmYcodrrCPblzGGr6ySZXbfX8vCOn7WmnTxq3DtVGMYDjK8y33Xy6A455x8wA02ojnz2lu0YkNDbX5qV5TTZKovbWcQdUv2VLmM3cryqROX42gcmGjqLt61exppBqUWYeLRisdonkJ76755A4Z6wjHXsLDQQB5BMRyak1n0OYH4uI7M05dSunYefVSG0/p/lh6pNZePn52ik3oF2X1nQ4H4pYc4jF5l+nHLZmlhM5boCek7iuaxoUC3SwPMNG/Bz7XsDoZ/zomVMhTnu+CRF2IfUvjEmi0ByQB4P43J9ouPhBaMk2TJQO+K3jnjGYrdbmuS01bc9p1sPzNkyekwsi4FM7S+/NsnTjsLL91lT4yYDu7cdqgS93uJEI5hsOLNdcfZjv1jhVBDseHY6J6B0Ls4J0FLH1J50WeexA6GbbcWaUB3+T5B2fDrAVEqK1k8LScvn3al0m8Mp3mVFGB7o3BRqUIlBoj3Uvx/CeA58DEdIBRpu9ZAPjeLoRGKims/38diAFim/slv+2lSmx+8qO5xA2i3FNpvLSKK2pwwGKE0fW4jbCIwpDrmJMjDswLELKWPA8XPQncZUBKTvLfUNyx5PHJN8OR8J5V2Qh0ViNVqr4PZlgTPnXL9yNUketM8Prp15zvqWuq1wNKxJEfVMhx
 xWDlvT4u
 fI/ybWhkHvt5DCbWJRzhwmfhwpcukAeEqFhsCtoQXX8jNHT6v6oFN2xOJ5XcKHIONqcUfJ77PDzuY1QYu8DNBWKgl5Pt5RZhyZHpLYj4EEnzYkr/HEc1ESh6Ur7x7rqLbcB8YXAP83Mpc/ix9C5mTozzBEw/Humx8GAUGYnyy0fG1BsfpiOb0psSuGzEa3XYWO4VILzCjmHwoKNml9fTFQpbST7AAuh+bjJ5+S3MIxzmS62aGRYr5RlWfzZcFZC0Boxr+Q/Dfi4/IcU+s7SMXXHeYCebT53G81pLMyBbS9M8FkIqWoJac1xRR8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 4:30=E2=80=AFAM Hao Li <hao.li@linux.dev> wrote:
>
> On Fri, Jun 12, 2026 at 12:17:45PM +0200, Vlastimil Babka (SUSE) wrote:
> > On 6/12/26 08:54, Hao Li wrote:
> > > On Wed, Jun 10, 2026 at 05:40:17PM +0200, Vlastimil Babka (SUSE) wrot=
e:
> > >> __GFP_NO_OBJ_EXT has limited scope within the slab allocator itself =
and
> > >> gfp flags are a scarce resource, unlike slab's alloc_flags.
> > >>
> > >> Introduce SLAB_ALLOC_NO_RECURSE alloc flag that has the same intent =
as
> > >> __GFP_NO_OBJ_EXT but a more generic name, meaning that a kmalloc()
> > >> family function should not recurse into another kmalloc*() for the
> > >> purposes of allocating auxiliary structures (obj_ext arrays or sheav=
es).
> > >>
> > >> First, replace the __GFP_NO_OBJ_EXT for allocating obj_ext arrays in
> > >> alloc_slab_obj_exts(). Make use of the newly added kmalloc_flags()
> > >> function, where we can pass alloc_flags with SLAB_ALLOC_NO_RECURSE
> > >> added. This will also pass through SLAB_ALLOC_TRYLOCK so we don't ne=
ed
> > >> to special case kmalloc_nolock() anymore.
> > >>
> > >> Note that until now the kmalloc_nolock() ignored the incoming gfp fl=
ags
> > >> and hardcoded __GFP_ZERO | __GFP_NO_OBJ_EXT. But it's correct to pas=
s on
> > >> the incoming gfp flags (only augmented with __GFP_ZERO), because if
> > >> alloc_flags contain SLAB_ALLOC_TRYLOCK, the incoming gfp flags have =
to
> > >> be also compatible with it.
> > >>
> > >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > >> ---
> > >>  mm/slab.h |  1 +
> > >>  mm/slub.c | 13 +++++--------
> > >>  2 files changed, 6 insertions(+), 8 deletions(-)
> > >>
> > >> diff --git a/mm/slab.h b/mm/slab.h
> > >> index 45bfcfb35a9c..509f330654b8 100644
> > >> --- a/mm/slab.h
> > >> +++ b/mm/slab.h
> > >> @@ -21,6 +21,7 @@
> > >>  #define SLAB_ALLOC_DEFAULT        0x00 /* no flags */
> > >>  #define SLAB_ALLOC_TRYLOCK        0x01 /* a kmalloc_nolock() alloca=
tion */
> > >>  #define SLAB_ALLOC_NEW_SLAB       0x02 /* a flag for alloc_slab_obj=
_exts() */
> > >> +#define SLAB_ALLOC_NO_RECURSE     0x04 /* prevent kmalloc() recursi=
on */
> > >>
> > >>  static inline bool alloc_flags_allow_spinning(const unsigned int al=
loc_flags)
> > >>  {
> > >> diff --git a/mm/slub.c b/mm/slub.c
> > >> index cbb38bd01e46..7dfbd0251aa2 100644
> > >> --- a/mm/slub.c
> > >> +++ b/mm/slub.c
> > >> @@ -2167,15 +2167,12 @@ int alloc_slab_obj_exts(struct slab *slab, s=
truct kmem_cache *s,
> > >>
> > >>    gfp &=3D ~OBJCGS_CLEAR_MASK;
> > >>    /* Prevent recursive extension vector allocation */
> > >> -  gfp |=3D __GFP_NO_OBJ_EXT;
> > >> +  alloc_flags |=3D SLAB_ALLOC_NO_RECURSE;
> > >>
> > >>    sz =3D obj_exts_alloc_size(s, slab, gfp);
> > >>
> > >
> > > For the original calls to kmalloc_nolock and kmalloc_node, I notice a=
 difference:
> > >
> > >> -  if (unlikely(!allow_spin))
> > >> -          vec =3D kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
> > >> -                               slab_nid(slab));
> > >
> > > kmalloc_nolock completely discarded `gfp` flags.
> > >
> > >> -  else
> > >> -          vec =3D kmalloc_node(sz, gfp | __GFP_ZERO, slab_nid(slab)=
);
> > >
> > > while kmalloc_node preserved and passed it along.
> > >
> > >> +  /* This will use kmalloc_nolock() if alloc_flags say so */
> > >> +  vec =3D kmalloc_flags(sz, gfp | __GFP_ZERO, alloc_flags, slab_nid=
(slab));
> > >
> > > Now both paths are merged into kmalloc_flags, the gfp flags are
> > > unconditionally carried through. It seems this might carry some unwan=
ted flags.
> > >
> > > I traced the call path and found that ___slab_alloc sets the __GFP_TH=
ISNODE
> > > for trynode_flags. If this flag propagates all the way into
> > > kmalloc_flags->...->__kmalloc_nolock_noprof, it will trigger the
> > > VM_WARN_ON_ONCE warning. Maybe we need to strip the original gfp if
> > > `!allow_spin`.
> >
> > Thanks. This should do the job in a more generic way I hope?
> >
>
> Yeah, this is more elegant.
>
> > diff --git a/mm/slub.c b/mm/slub.c
> > index f9b8dc56bb57..0bf53f70c9be 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2047,12 +2047,15 @@ static inline void dec_slabs_node(struct kmem_c=
ache *s, int node,
> >  #endif /* CONFIG_SLUB_DEBUG */
> >
> >  /*
> > - * The allocated objcg pointers array is not accounted directly.
> > + * The allocated objcg pointers array or sheaf is not accounted direct=
ly.
> >   * Moreover, it should not come from DMA buffer and is not readily
> > - * reclaimable. So those GFP bits should be masked off.
> > + * reclaimable. Node restriction for the parent allocation also should
> > + * not apply to the slab's internal objects.
> > + * So those GFP bits should be masked off.
> >   */
> >  #define OBJCGS_CLEAR_MASK      (__GFP_DMA | __GFP_RECLAIMABLE | \
> > -                               __GFP_ACCOUNT | __GFP_NOFAIL)
> > +                               __GFP_ACCOUNT | __GFP_NOFAIL |
> > +                               __GFP_THISNODE )
>
> Good idea! Both code and comments make sense to me.

Makes sense. I see
https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=3Dsl=
ab/for-next
already implementing this and also keeping __GFP_NO_OBJ_EXT and
SLAB_ALLOC_NO_RECURSE both used. That version looks good to me, so
I'll wait for v3.

At the end of this series, we end up with no users of __GFP_NO_OBJ_EXT
but we still keep it defined. I'm guessing you leave it because of the
new patch [1] which aliases __GFP_NO_OBJ_EXT? I will have to make that
mechanism work without a GFP flag, possibly using a similar approach.
CC'ing Hao Ge to be in the loop of these changes. I'll work with him
on aliminating that __GFP_NO_OBJ_EXT alias.

[1] https://lore.kernel.org/all/20260604024008.46592-1-hao.ge@linux.dev/

>
> >
> >  #ifdef CONFIG_SLAB_OBJ_EXT
> >
> >
>
> --
> Thanks,
> Hao

