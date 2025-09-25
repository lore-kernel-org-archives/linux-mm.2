Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11E31CAC5B3
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 16:27:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A328E0002; Thu, 25 Sep 2025 12:27:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 540EB8E0001; Thu, 25 Sep 2025 12:27:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 456D48E0002; Thu, 25 Sep 2025 12:27:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 34FEA8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:27:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFE2EB9605
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:27:43 +0000 (UTC)
X-FDA: 83928303606.28.8C40AE4
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2554320009
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:27:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=q6RfKmzy;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758817662; a=rsa-sha256;
	cv=none;
	b=dAqzJo8CnzFr6PDJES4E313p73Js52J52juiPDYmNcrxMndTAVZPbSgoD+yIIsZRMNjpcb
	ljjN3zf7EyoZZUOaBilIfuODPGZtoQtkzpVhhkZOG0asgix8xgVT7KWdJdQHaJDPmM1ilX
	35UzHl0/yHkaCZJTsk9Q1SdjnOtBRpc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=q6RfKmzy;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758817662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8alXX8Vx5P1PMvrrz8A15t1lUKetKpLPe18RveHqZ44=;
	b=R4bLU+3m5ea4ZtLCysNTcBv14q2FpGBT+3AbC1DWsmgwlDOsaKyOWqiZUCqVzq4kJpyZjN
	Yq368pw1hrJRT8K7ai8peh3iIIYOBCT7Nyt5S2iGV4kTBp+6S2XezUPELGJ3LY+8OXB2ar
	UPbuSJaN+76dKdLAlfUh+gOcefGd0Ag=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4c73047a75cso432181cf.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758817661; x=1759422461; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8alXX8Vx5P1PMvrrz8A15t1lUKetKpLPe18RveHqZ44=;
        b=q6RfKmzyfxPlfgLxD4YpnseUe3Q1PpK5ZqsR7sgquXCM8TDSJofrTuFferZvHAbkpA
         dTmeQuMcwahE7I09d+9LTwdMGceeruna4BBESX/lNibR5g8aJE4c2QMVh9WwI6gc9b7w
         TGtD7slyH2rKi+38rtsKT6T6ptWIm7nsVMLwqwcc/oQnyRGszB6Rdv+GsUmiVgcluu6k
         N2EE0M5tGYpHfQfPhGO0CRkfDfe0WPMlnuPW0D4nPA5v6g42IUHqCyAt3w2QaUtsvy+D
         izGYd4BY0j95qEX2z9eumTynTL40Z1jdGIfcENFS3NlCAWT76O4Qrzwn5399wXZCTuIL
         JJ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758817661; x=1759422461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8alXX8Vx5P1PMvrrz8A15t1lUKetKpLPe18RveHqZ44=;
        b=IvbVOzL79kejFpQo9Ki+RlqpRvpHNeG8/IL8UBIycGD0Jl7qT315Nu/a0Gs8q1mri6
         V/WJyjLFUcsS/rt5jGTErzFzSBlpDWfY4h3KQMrhXs5+XMGNpQP3/H557TsYC5ZD8aF8
         1NWYo+GlcdluI3DIhcYnvjcusMrL/LSGtWQZuAgQOVGAk2rpPVtdWG40nLW7jr1fWr6K
         oeZo2jhawQ+5StoLD2lLXxFivJ12BATNHEwbIG6bJBpWgO6mvI2prUHpxa+u5B9qwY3/
         T2Qne2nZ3jVHekrjxfId3GtpwFRAON4R0cpDRWXrS3ySij8vY8O8lowBBpmaGJ5rXvzP
         ieXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWu48NV+JADo3dOFlneUoHN00peeAMJRptxx7kgUrKaddzv9WSbfBYkW+9FbJ/rAfSuWNxw+nm+TA==@kvack.org
X-Gm-Message-State: AOJu0Yz26NSqCnIOWmHAExcgXvn8wdoUQJU62OE6yn6CC97LdLh6toqs
	6TWfkI6MYx36RLWC4nYxvAKAg2IMfqMKZqw+QjAafCl/6Cavop+1LO4/OljQKFjVDWYlDYxcXkl
	0qgmdZIs530+uBWvebxLSw/PhBFg1DJ3L45834U33
X-Gm-Gg: ASbGncsaUU0Yj6wKxEkvjTU1TPlYTLvhI8SVktgilwFF4g/8PRyS7HWgWg7zXSONAea
	G9il1Uuix7QNN2yKOt9VD6elCb/7EW/AHm+/gef3Utit7X8+/k4uhU+yHrA7nehWuax2oiWcgNB
	lLj4TszEXv4zHHLmcWSLminDFb6XsaJu3tB/dAA35OSG66gp4vYRchnS2lxfhifNicai7zMrF8S
	obNUAoO8pX4rz53lAwwLIqmoc9Of+2oVxRBPc9sCvFq
X-Google-Smtp-Source: AGHT+IE0U/Akn6KfZdQi3hMHKTNsTfXUBE073v8846IgqYIdAQipp1ZoMFszJSAgEACETdUsriBu3KVMJALctBt0kw0=
X-Received: by 2002:a05:622a:1819:b0:4b3:8ee:521b with SMTP id
 d75a77b69052e-4da23acea56mr8611721cf.0.1758817660558; Thu, 25 Sep 2025
 09:27:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz> <20250910-slub-percpu-caches-v8-8-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-8-ca3099d8352c@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 25 Sep 2025 09:27:29 -0700
X-Gm-Features: AS18NWDS5gKmUrtto-cMdIoznAg_NnCQ2mSnzIo1N59ebSpUh4KtZjXH7s5mmh0
Message-ID: <CAJuCfpEL1n+yVJDK0UWxP9CYgu28z6yLUzDWXBKyF0Oyukt1XA@mail.gmail.com>
Subject: Re: [PATCH v8 08/23] slab: allow NUMA restricted allocations to use
 percpu sheaves
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2554320009
X-Stat-Signature: sueqrdcwqsmjk4hu98i1d56a1kuonqrw
X-Rspam-User: 
X-HE-Tag: 1758817661-556768
X-HE-Meta: U2FsdGVkX19nlq2ahZ5mYvsRJQyBenEGtbkDoA1vim0BwicOVEIGNGK/8zTgSv0bh7XXHS+AiP12cEX1R4TiSAL4XPRBQVXx8u9+cCOJZwA6PnGJ6HtIJSScOkV28HXKREaUQAJFuEzeCfKhsUW3jjxyo/t1E8DzdUHA547Px/09mIUmWTsFsO2imP5zeHoh2SNvxukrDPgk/QCj5mQikKmmmDK8MdMSff2WBFHl60PhnSFpuoUSwe/xQLeP4jdGDwvrOzpFC/OINud4/kz5iQcwnmLlcbKRYYQFqUGn9soSpK5xYGKcmdSwtEbyh6tgq1WNzT6lAGqrxBVhYnTjVAKISdc3/xzR8uR/zKS5PC3W7pNFbUi+B2ZZQUKmluDuux84muEDGQk41gAQRVq2kXiEp8KXnwJfIiSDMEVWzJttu87DIKp+0vP9rTmzks2hgZ/Cj48d8Sbj1QbyxPNw0ApCDNKyGdIco4GaqUxtwZPloYOvKBCvHNS04n3SlOKXeTdnjm5rrh7/MxA9G/1EougbFbtkhr+A6okemvWdIOfiIentyKNPuEcg/3pwhDKXxS54455pTlM9+AvbNQxvtjR+eYcma6nBVLEH4bgieb+7lqQz7AQ5a/3rAyfTCKBqcB/8wRRF+otxYv4gp9NyjUUmQwfmYQIgXgsRx+ql3tPI8K5oyoS9iVrAeCqDwXIR+FV7aiFfALdR3nUXZqKRpSm/4CQT8mROSCkzAu+TYtmsiXE7gxjNbzd4PQeGJGgRiqGk9lyA4l6OURa09mRToI9Ze/69HNXpARLyRaG5Pj8x81O9dHRmUkaBkxrKMNk0KdHGlXl07DBMPcLUPd+6bp80hv0mt+FeVSHAnlSTLCImOmWHUBzgiuKuDj9UsGI6YWUzb7phA5jKumXkuvGnjDv+HspLPjXjoWKV7M2kG8Eo7dvDIaBuiLnYaOUC8TgRlz+rR0pnogBR6jZCwI4
 apNA1qit
 nqpTDJrLKuXRnl2iEbP2/8NPb+fXZaqzgz1bc/5wZJx5HziPEFvNGm3FW3jskSFM65Pv+2U/sPCXlaT1modho0O3Slx0jIscbrB7IV4/XBc20GJPSXbEgchxswKIWWV6anQNMu64LSHcN9+nPwn9Trw9WzcGqF1LsPnI+DhhXxFHc5f4zRDhG9jEujp37vYC9jS/bl/fqUhSm5U4nLlQxYga0/ig8hbQYQRH97LdL8mJOnzqIaFJIpOaw/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 1:01=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> Currently allocations asking for a specific node explicitly or via
> mempolicy in strict_numa node bypass percpu sheaves. Since sheaves
> contain mostly local objects, we can try allocating from them if the
> local node happens to be the requested node or allowed by the mempolicy.
> If we find the object from percpu sheaves is not from the expected node,
> we skip the sheaves - this should be rare.
>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slub.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 46 insertions(+), 7 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 9699d048b2cd08ee75c4cc3d1e460868704520b1..3746c0229cc2f9658a589416c=
63c21fbf2850c44 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4888,18 +4888,43 @@ __pcs_replace_empty_main(struct kmem_cache *s, st=
ruct slub_percpu_sheaves *pcs,
>  }
>
>  static __fastpath_inline
> -void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp)
> +void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
>  {
>         struct slub_percpu_sheaves *pcs;
> +       bool node_requested;
>         void *object;
>
>  #ifdef CONFIG_NUMA
> -       if (static_branch_unlikely(&strict_numa)) {
> -               if (current->mempolicy)
> -                       return NULL;
> +       if (static_branch_unlikely(&strict_numa) &&
> +                        node =3D=3D NUMA_NO_NODE) {
> +
> +               struct mempolicy *mpol =3D current->mempolicy;
> +
> +               if (mpol) {
> +                       /*
> +                        * Special BIND rule support. If the local node
> +                        * is in permitted set then do not redirect
> +                        * to a particular node.
> +                        * Otherwise we apply the memory policy to get
> +                        * the node we need to allocate on.
> +                        */
> +                       if (mpol->mode !=3D MPOL_BIND ||
> +                                       !node_isset(numa_mem_id(), mpol->=
nodes))
> +
> +                               node =3D mempolicy_slab_node();
> +               }
>         }
>  #endif
>
> +       node_requested =3D IS_ENABLED(CONFIG_NUMA) && node !=3D NUMA_NO_N=
ODE;
> +
> +       /*
> +        * We assume the percpu sheaves contain only local objects althou=
gh it's
> +        * not completely guaranteed, so we verify later.
> +        */
> +       if (unlikely(node_requested && node !=3D numa_mem_id()))
> +               return NULL;
> +
>         if (!local_trylock(&s->cpu_sheaves->lock))
>                 return NULL;
>
> @@ -4911,7 +4936,21 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t g=
fp)
>                         return NULL;
>         }
>
> -       object =3D pcs->main->objects[--pcs->main->size];
> +       object =3D pcs->main->objects[pcs->main->size - 1];
> +
> +       if (unlikely(node_requested)) {
> +               /*
> +                * Verify that the object was from the node we want. This=
 could
> +                * be false because of cpu migration during an unlocked p=
art of
> +                * the current allocation or previous freeing process.
> +                */
> +               if (folio_nid(virt_to_folio(object)) !=3D node) {
> +                       local_unlock(&s->cpu_sheaves->lock);
> +                       return NULL;
> +               }
> +       }
> +
> +       pcs->main->size--;
>
>         local_unlock(&s->cpu_sheaves->lock);
>
> @@ -5011,8 +5050,8 @@ static __fastpath_inline void *slab_alloc_node(stru=
ct kmem_cache *s, struct list
>         if (unlikely(object))
>                 goto out;
>
> -       if (s->cpu_sheaves && node =3D=3D NUMA_NO_NODE)
> -               object =3D alloc_from_pcs(s, gfpflags);
> +       if (s->cpu_sheaves)
> +               object =3D alloc_from_pcs(s, gfpflags, node);
>
>         if (!object)
>                 object =3D __slab_alloc_node(s, gfpflags, node, addr, ori=
g_size);
>
> --
> 2.51.0
>

