Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5948CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 02:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0EFF8E0111; Tue, 26 Aug 2025 22:04:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9F7C8E0105; Tue, 26 Aug 2025 22:04:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D87458E0111; Tue, 26 Aug 2025 22:04:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C3A9C8E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:04:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CD6658E20
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:04:01 +0000 (UTC)
X-FDA: 83820891882.04.BF07E11
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id 68A428000E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:03:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=G6WZXN8p;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756260239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oEVxPCA6kJd9PIc8bhpPohKEpWmPNTYIVsnrA96TQzY=;
	b=mR5LHw+nvAoTo0gcc+FlKdqkz8NegcQIqrD2Hk1EylmHTnZahe8NsnZKBpvWH3i495blkE
	N4yWra0Y4UHuxgtKDMlypSzYwPU+xAcDZJRcSWhyluTWuDzBr1CEjQwvrU6lZEJflo4C+G
	TKghKCuz0DdDqcDvQBu2X+9fWlyyKgI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756260239; a=rsa-sha256;
	cv=none;
	b=XyCQ//GaI/kK49N+GCmQK5ltlq9WdEFBul/UwLVyRQjZrBbhR8TKDcVmGzLI4+hrmJ4G8F
	s+i8DYVZTl7cY9XEf/C1qk2JjvgGVLl2/pYKsPvBdIXQGt9DN1NJsM4YTjagxSUTFrEGOh
	eQePTTWLj5pVyb88Slz6rga/oGhnSmg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=G6WZXN8p;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4b29b714f8cso128391cf.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756260238; x=1756865038; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEVxPCA6kJd9PIc8bhpPohKEpWmPNTYIVsnrA96TQzY=;
        b=G6WZXN8pMNbF+ZX0q+NTvt+z1dvB0KUjZT/j+u7O4LBToQyl5VYIq42VjPQtB84MFE
         HRZliVtyqz4QAeB9XjfHnFGp+iGRIFiVVArspJpFdNntWOLLx1cWeVBUh24Z0Q7kfBfa
         55JIMtqrjeBRLVnYxkinD4anwo5iyjAVEqifYGf/8CeA8gAiRQZNAimlYTddsNof6x8o
         +/JS0gcR20zHT5vp/O57Xzdou0DRlqFzhqz7/5qk3IBM90scBaB5wgeE36Z/Jr3OhdES
         0sIqq2cMkyn5dKnn2I7eeO+wIpELPRvywFpUCpVhNMU1ny3sksmgEjeohZ4RnyIFl8cl
         XHcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756260238; x=1756865038;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oEVxPCA6kJd9PIc8bhpPohKEpWmPNTYIVsnrA96TQzY=;
        b=OABuVrZJADkLYlnHfLCMM0+kXRIGIk2u3sy0U7HIGl5jzmQ1c0htEZ4oMyNNwuMFEA
         3Wr2ibcWRCdjiVz4MR0t4KKy0PWsawHbRKaN80W4HqEvk3gp4OCOcMQXELcy6JUsfGdE
         MbZc5mGDKQF08AfGLehd0tF64/C+ahbKOEoKnW6ZP49vmNCB4v1t73Yp0bpryRKNdmRN
         JxHFol3HMnuJHGCijO5xKwH/baB47wKdNc76VXqyq0JY3uqGVa3dfyFIGyNfogku6jRY
         e8EuOXW3mvhFfP+rg1+KbsN42OfIyZSRtjcl9GrfSZ/vuyELnx4UhwzcvDRw+LQOGV1c
         UdWA==
X-Forwarded-Encrypted: i=1; AJvYcCVEsiePQljwQQJVjgKkyR3k3WykD6RFh8p7BLChAwO1O/Yaf7udUKT3BocxAVkHLC3zFmVKz70BOg==@kvack.org
X-Gm-Message-State: AOJu0YzQ5RWgpBMHuQ04KnsFwJTGim4cqHdqQ2ur2MgnlpAcIBsIE7vm
	FxoY+YG083HTF6aVLxfvjBCvLmT3ptKSqIZ3NWhgGV0UlheAruRmG48nOCYhhTi5TcW7ulhrQF0
	WCO/ovy2oAhwsn3ckvAV49m/fUREd5HEU4DPHZ8Mh
X-Gm-Gg: ASbGncs5Rnn9ndabVPpWjDkgaQi0/11oBQNdMnVhdaIbckwIBucCWpZqYztcUCsOB1E
	q5x42d8M7Ts5pOs6I+yws16a+z3oNQaVsK1f3CB0w5eMvyCIgAzTZq4sJPK39Kk2p24My2v/NjR
	w5fGcX2JJBs0e8HsLH1/bx2wiGQSKuMLn6mmabzfsOHEbl9qhP09B/EinN+vRWmVBP6ixDHE7Rd
	v7ol7qO6vCgc8+W0ZZYKts=
X-Google-Smtp-Source: AGHT+IGHtlhh0VeckNbHAmlQ5S3gzzBpECXGOQvdXGjlOYoxZxhVip/09NFraMdVHLQbgCey4/aMUVeZBI1/PDbyvZQ=
X-Received: by 2002:a05:622a:4a0c:b0:4a7:179e:5fec with SMTP id
 d75a77b69052e-4b2eac6a173mr5480691cf.15.1756260238092; Tue, 26 Aug 2025
 19:03:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-13-b792cd830f5d@suse.cz> <CAJuCfpEjaw+4Ay-Yx=unHev+M4M9FmNmz_PSYmtsFn3EToLBxg@mail.gmail.com>
 <6rvzsp6i6p6kc63acbg7hmqlsfx5htvyg5rax3llrauwwyzg4e@f436k2inorfe>
In-Reply-To: <6rvzsp6i6p6kc63acbg7hmqlsfx5htvyg5rax3llrauwwyzg4e@f436k2inorfe>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 26 Aug 2025 19:03:46 -0700
X-Gm-Features: Ac12FXzSeNiZvXDErfLgt2l37tNkMytOYphilgAYuXMgRYjKC_nzXLjq5XayMtI
Message-ID: <CAJuCfpGPP_fR2KvcmHxFbUkZY8p4GQOt2X-bU+PY7nUeRg489w@mail.gmail.com>
Subject: Re: [PATCH v5 13/14] maple_tree: Add single node allocation support
 to maple state
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 68A428000E
X-Stat-Signature: 3i8g7oefc18ucqjik8r186qe1zzh5rys
X-HE-Tag: 1756260239-492543
X-HE-Meta: U2FsdGVkX18haDe9JzQDop6unu6RyMRtBr9dIvSVbPkT2Xw/aY+Lne8d7T57LPgHgZpkQGtMCIM5RshhXeoLSo9v5debm/E33JMV8y3uMxxh9IkM1XqQbLQ1+aSF0O0hkdhXix9nHc/bzm+bzDGa1mnl3fgmGDwzJTrsAeS0vmFM43O6jaNvYCcvauWAXZw67zz6AtyotGIOPYUTu3RDmjGZusezmkYY3RmPVgzg/LTYK9InTIuDEXXUXlWZOJNZvD+7zKSG9rAgrJqZgmqTGZW36L88AJ68QhZ6QEjTj9ZlxhHM07jLUFhx1lmHKO/zNJ/sEVuvLEIF+gJy4aySOtD3+tlZyRLV177fwU+GO2KY9OnV1vjv+TkkU4ehR3Nwrr54RqI/rYnks0OIrffBUBMCYIWPdk8KwbxggeE5cTs/f9u9Hy6dtIfzTtbryLOYDLnT8SdsOD0iLw0/KwmBd7qjhSNHwbrUe8A0j/jPVV1BnniTRREUITw+VWleoyYZKAZpEx25xVHk1CMS3WQRF8djuRFe3ViEaIbyoLCpP00IGgzdQCzqnPWok2Ui7KK50ssq3s2VkA/HBWbmO6kmW/WUiCBLBcMIPplE2nY6XGAVbZ9Wd2ZAD42TzTufMDSWvZOa5phE04xjYyaDZB3DirX0NUnnn95Oa5LSYhg6GRv6G2jWEvFIA6KDLn3zdqrFwVpfYUArg+m4bK3OyEnztoxI2VGwB+CfTphtlW3OOo6yo4j8Qfrc8bFpAi+Sr5IZVU2unCQKI6pDpPGoqHH9paVnx0UA6zF+9eNrMKf2Gn9j0fyjXJq+iwe8Ww1wsuOLhR3y6cOuXkHP730s7f+Cv//QXbtFI+dJKfqlep9sflOKwCDzHzaKFoYCcS3jRFRuuLsU4Ng4ljzaL2Hl4YxxbX4awjmjOc+AJUf1FQ5QsibKbi0vjQSuJWlyBZv9gDs0FT3ZHE7Em5lVryhhiZ2
 I+vBkf2w
 hcQNX0HnYUmJqhf7q+wqTchAU/iCNUXEXlW/6KCuuxS2aPsgtJXVbohnIbZrPZhea3HfkE+hCJgNFgIulhfCzC9hDkXSvPhg6+sBzPOaBAea/IGqlTPsUY1RtrokJyn3++7jwaK972uEIRSgf27wlPlR6o9ufLfmX0VLWVRFLX2AdxxO6juzpxnYbrLOu26vT2V5z90EWOCaFVx4vkR6u0tHWruxnyaJK4wxvMp1Mp+iWPdmcspXgzd1+UC/GhrW0B/Lq1PXlmsDfS/5LHnNFCvVRYfzt46mvUUAj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 8:11=E2=80=AFAM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> * Suren Baghdasaryan <surenb@google.com> [250822 16:25]:
> > On Wed, Jul 23, 2025 at 6:35=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> > >
> > > From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
> > >
> > > The fast path through a write will require replacing a single node in
> > > the tree.  Using a sheaf (32 nodes) is too heavy for the fast path, s=
o
> > > special case the node store operation by just allocating one node in =
the
> > > maple state.
> > >
> > > Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
> > > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > > ---
> > >  include/linux/maple_tree.h |  4 +++-
> > >  lib/maple_tree.c           | 47 ++++++++++++++++++++++++++++++++++++=
++++------
> > >  2 files changed, 44 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
> > > index 3cf1ae9dde7ce43fa20ae400c01fefad048c302e..61eb5e7d09ad0133978e3=
ac4b2af66710421e769 100644
> > > --- a/include/linux/maple_tree.h
> > > +++ b/include/linux/maple_tree.h
> > > @@ -443,6 +443,7 @@ struct ma_state {
> > >         unsigned long min;              /* The minimum index of this =
node - implied pivot min */
> > >         unsigned long max;              /* The maximum index of this =
node - implied pivot max */
> > >         struct slab_sheaf *sheaf;       /* Allocated nodes for this o=
peration */
> > > +       struct maple_node *alloc;       /* allocated nodes */
> > >         unsigned long node_request;
> > >         enum maple_status status;       /* The status of the state (a=
ctive, start, none, etc) */
> > >         unsigned char depth;            /* depth of tree descent duri=
ng write */
> > > @@ -491,8 +492,9 @@ struct ma_wr_state {
> > >                 .status =3D ma_start,                                =
     \
> > >                 .min =3D 0,                                          =
     \
> > >                 .max =3D ULONG_MAX,                                  =
     \
> > > -               .node_request=3D 0,                                  =
     \
> > >                 .sheaf =3D NULL,                                     =
     \
> > > +               .alloc =3D NULL,                                     =
     \
> > > +               .node_request=3D 0,                                  =
     \
> > >                 .mas_flags =3D 0,                                    =
     \
> > >                 .store_type =3D wr_invalid,                          =
     \
> > >         }
> > > diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> > > index 3c3c14a76d98ded3b619c178d64099b464a2ca23..9aa782b1497f224e7366e=
bbd65f997523ee0c8ab 100644
> > > --- a/lib/maple_tree.c
> > > +++ b/lib/maple_tree.c
> > > @@ -1101,16 +1101,23 @@ static int mas_ascend(struct ma_state *mas)
> > >   *
> > >   * Return: A pointer to a maple node.
> > >   */
> > > -static inline struct maple_node *mas_pop_node(struct ma_state *mas)
> > > +static __always_inline struct maple_node *mas_pop_node(struct ma_sta=
te *mas)
> > >  {
> > >         struct maple_node *ret;
> > >
> > > +       if (mas->alloc) {
> > > +               ret =3D mas->alloc;
> > > +               mas->alloc =3D NULL;
> > > +               goto out;
> > > +       }
> > > +
> > >         if (WARN_ON_ONCE(!mas->sheaf))
> > >                 return NULL;
> > >
> > >         ret =3D kmem_cache_alloc_from_sheaf(maple_node_cache, GFP_NOW=
AIT, mas->sheaf);
> > > -       memset(ret, 0, sizeof(*ret));
> > >
> > > +out:
> > > +       memset(ret, 0, sizeof(*ret));
> > >         return ret;
> > >  }
> > >
> > > @@ -1121,9 +1128,34 @@ static inline struct maple_node *mas_pop_node(=
struct ma_state *mas)
> > >   */
> > >  static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
> > >  {
> > > -       if (unlikely(mas->sheaf)) {
> > > -               unsigned long refill =3D mas->node_request;
> > > +       if (!mas->node_request)
> > > +               return;
> > > +
> > > +       if (mas->node_request =3D=3D 1) {
> > > +               if (mas->sheaf)
> > > +                       goto use_sheaf;
> > > +
> > > +               if (mas->alloc)
> > > +                       return;
> > >
> > > +               mas->alloc =3D mt_alloc_one(gfp);
> > > +               if (!mas->alloc)
> > > +                       goto error;
> > > +
> > > +               mas->node_request =3D 0;
> > > +               return;
> > > +       }
> > > +
> > > +use_sheaf:
> > > +       if (unlikely(mas->alloc)) {
> >
> > When would this condition happen?
>
>
> This would be the case if we have one node allocated and requested more
> than one node.  That is, a chained request for nodes that ends up having
> the alloc set and requesting a sheaf.

Ah, ok. So this is also a recovery case when we thought we need only
one node and then the situation changed and we need more than one?

>
> > Do we really need to free mas->alloc
> > here or it can be reused for the next 1-node allocation?
>
> Most calls end in mas_destroy() so that won't happen today.
>
> We could reduce the number of allocations requested to the sheaf and let
> the code find the mas->alloc first and use that.
>
> But remember, we are getting into this situation where code did a
> mas_preallocate() then figured they needed to do something else (error
> recovery, or changed the vma flags and now it can merge..) and will now
> need additional nodes.  So this is a rare case, so I figured just free
> it was the safest thing.

Ok, got it. Both situations would be part of the unusual recovery
case. Makes sense then. Thanks!


>
>
> > > +               mt_free_one(mas->alloc);
> > > +               mas->alloc =3D NULL;
> > > +       }
> > > +
> > > +       if (mas->sheaf) {
> > > +               unsigned long refill;
> > > +
> > > +               refill =3D mas->node_request;
> > >                 if(kmem_cache_sheaf_size(mas->sheaf) >=3D refill) {
> > >                         mas->node_request =3D 0;
> > >                         return;
> > > @@ -5386,8 +5418,11 @@ void mas_destroy(struct ma_state *mas)
> > >         mas->node_request =3D 0;
> > >         if (mas->sheaf)
> > >                 mt_return_sheaf(mas->sheaf);
> > > -
> > >         mas->sheaf =3D NULL;
> > > +
> > > +       if (mas->alloc)
> > > +               mt_free_one(mas->alloc);
> > > +       mas->alloc =3D NULL;
> > >  }
> > >  EXPORT_SYMBOL_GPL(mas_destroy);
> > >
> > > @@ -6074,7 +6109,7 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
> > >                 mas_alloc_nodes(mas, gfp);
> > >         }
> > >
> > > -       if (!mas->sheaf)
> > > +       if (!mas->sheaf && !mas->alloc)
> > >                 return false;
> > >
> > >         mas->status =3D ma_start;
> > >
> > > --
> > > 2.50.1
> > >

