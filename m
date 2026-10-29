Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 082DA606A320
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 23:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=R9MX+2U7
Received: by kanga.kvack.org (Postfix)
	id EE97F6B00EF; Thu, 29 Oct 2026 19:00:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC0F26B05B1; Thu, 29 Oct 2026 19:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD6A56B05B2; Thu, 29 Oct 2026 19:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A42756B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:00:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28328120544
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:00:29 +0000 (UTC)
X-FDA: 85377184578.22.739823B
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf31.hostedemail.com (Postfix) with ESMTP id 08FD720012
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:00:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=R9MX+2U7;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793314827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OjIFR9RHuZyb+FQlUiSJHHP2buOKCHCE0JjDFtdSiWE=;
	b=NwEwNsWqO0fkPHfpjsxOdSzsSiKqjZx0zlvw9GvK4p8jtH2jqhFhU4R1HpCoB4gmDb14U5
	8E9FePWpPqrWQ4XSXRWr1HBRzIgb/3CnJkHMx+w2o8OL8QWXFmhnHBp2vRBoI9KHdrnivG
	8w6KyyBukYeb6CqpDrL7VZhtAWBUNIU=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=R9MX+2U7;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793314827;
	b=nGgCGi2JfeExo6cSYWjjCY68r0q8JlnxUnLKMyJq9zuVOwSPGwJ3e91lbxi5GlwpYG6drA
	uyX5hh3duRx5GSj4eYfEVdKf0toObLFPIhWOzCQJWbnmM1JBXSsTgVsDu/B6p4w2dOFaGA
	KvpltYU7qjnmc4Z9fLzltEt+zgPJdRU=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5bfc2ae6e9dso123459e87.0
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:00:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793314825; cv=none;
        d=google.com; s=arc-20260327;
        b=NLqu2dgBiqvwUTrhJuu1iV6R+LWulYHBW5S7+Zcixr3nWfuiKhxsCYyKJraZMAJ14t
         yiukzmD6IN86lBxoVfHu7tKMNI5eHMPw+jaYKWDuxlWFmGMZ9FGEA1JAU3+2Ex1PAzqL
         ars0lKzrC7p+ENJ5BXXbGHtS8M9pGA8fLTDQjimaW2ARE5VW7WjykRL6hmC9FydlJzHa
         ktDYK7ym9uA+/WoakXCVMYVic1vebbLevss20wFvmSR/FZHmI5N+ceAqI0vWhZibs5BR
         /4tLjF3DkdSUTRpAUrIFTGLNDM2xJEbo/wnapqyXnTmRd8Jr7Y26Fjl+7uDba5mk0MiC
         ljPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OjIFR9RHuZyb+FQlUiSJHHP2buOKCHCE0JjDFtdSiWE=;
        fh=pq5pA1YqaGBjRIanJVvReN555Ibwi8KTblVM6e7Zb04=;
        b=nC8wgso6NSMHpgSo8bd/Fv2r+eJaGiuUEPEK7/W5e8N0WoUP6LHryp5BiopVhRagRh
         Qqa0AuCdWGmrj2jM3P/4y0lDFq7uND8Uo7yGTLUU12yhCpre51lA4DAdRuUHOoavRnvS
         yy0uTWkL4QuLXKFo4Zo4BD4CScTiMS/tWIw3GZILv47A8O8npCD6BIY5+9yTX5KISzAE
         eR9rtGFR8tVirVHr75ETgyjiEKq+gG9DTzNK50RKvP45N0s0Fdg+C78gRdvkv9ctWaj5
         6vTrD7Hdc8aFkJ1EBX8EwgAjqg5U/o/Fn3RabzXG4KdVQwlMc64WsPg9Vwa8MO0ju6Db
         tJIw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793314825; x=1793919625; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OjIFR9RHuZyb+FQlUiSJHHP2buOKCHCE0JjDFtdSiWE=;
        b=R9MX+2U7NsojashcA2kPN3KhjacX23bPE8X+SSXpS5uI1C8M+u6HWbV6z9yT4Pea/K
         9g2LyjOwKHeDFd3lBoncKaXJs/eROja8FVYKqVMERr97uDEvqMBHlfL5CBYMN8BGhQUy
         sOK47uXNhTDSjK/pA1d3YLajcoJoFeT4PSh04zUdd0kZigjoDElqtfQX1ACRYCN59ooK
         g5BHtUDw608BeZ45M16AVq2wjjuSzKmOJ4l+TXX5EBdgQqbolKQM1yukGhPV6fVtIKcq
         Hx0AypnI8M4ZkD9Iqm2/g+8FYnlSJnTcUeMXwPQIyqYmz8IH+aMf0L5/x50GhhR/dtuC
         EGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793314825; x=1793919625;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OjIFR9RHuZyb+FQlUiSJHHP2buOKCHCE0JjDFtdSiWE=;
        b=LxPBEcimjge60uvaSJ7wCqYxhqF33RGFEGqRQawTgLxje/22JFjoitTrf7Qto5n0oX
         UQ909+/l7UUHcXo+HUe/nzV8TXD1RP+T4cUg7HWA5R3nHjiliivORWOk98NOkMCmDCiu
         0HiHIjsZ+RsldHTuD7WWIwIQDlNbBpxf+1GAOhHUl3+l9LnMw+NKywAXhwFH8HD/WQ69
         lk/LqU28i8TwrKcz05AinbdaYlObGSg1av95FHol5XCaaUcAgJ2nlYs1vvv4OC59oLb9
         OMzusWcL/1+r8KCuENPSne4vDeIEW08osvQhSNgjJrwVO/xWBLYkrqPUUjwexGmkLZxT
         vRbg==
X-Forwarded-Encrypted: i=1; AKwUvBz/CdZlBxtVpUjPpQlD4pRPemEy7XlrdvwHlPTuXljnY0+acqIPRCmUhFluPgvgQ3cVSTScpNSSyA==@kvack.org
X-Gm-Message-State: AFq9FYJlqsJoSgV/qxO5TyNG/RIyr6Ep46hbMWAnGEBGc6kYlwmCriyQ
	hSSrPSrzdYh/BOx9XtW9XGEHM5woz/MYloC1I3OzD116MHX5k7wtLEwUH3ntc/UO1x1ffdliv5i
	RC14xWo1avC5XoQgbYPzA5DbvYpZeDUI=
X-Gm-Gg: AYBFou2A507hD/zBkGKdPSRUhR1GYb5mtFaXezUi0TB57Nd/GrHUH8YOl2E/UH4MgYG
	nZkijYLU5gOVsIfgbiWpLEJfq6zte0dO3vHZ5aSNEKRoTR0Rb76hpeOAH9bguvmJc34ZPMntRiL
	p5Idgjx06OEyk+pl11Kmf/beRuRN8ZLyYxAWWRTVC3y6elsiCBRg3Q8B+RCrgPDTqdKKV2RnNAW
	7bOa9gFgVPCdeDDU6gTgIZowCap13ehYA2VMTr0wEhUft7uNi3OdQS6FjU7ESBMFgUxgqVaShbY
	jjNJuWaezPdkKnWANaVwncm/wjomhd1mWWZbV8Z+S6HAi66cVYbzbDtRyHLZvSyO1krDlyCEqeu
	ctPHC6aEcs95Z2lSQf3guA1GQoca9nPFyaHw4
X-Received: by 2002:a05:6512:32c9:b0:5bf:aad9:df71 with SMTP id
 2adb3069b0e04-5bfd95208d7mr108143e87.7.1793314825046; Thu, 29 Oct 2026
 16:00:25 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-6-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188657@kernel.org>
In-Reply-To: <sashiko-outbox-188657@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 29 Oct 2026 16:00:11 -0700
X-Gm-Features: AclHuK8vPy78HoUW065_s9Da2om9WIPFjJ9GZXx-qNzNfH1rQXOgW4zxEQfJFis
Message-ID: <CACpmpofjVP17TpyieQ2khsdRL+FMX9oCEcaNE9Hh+vBfGBO2dA@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 08FD720012
X-Rspam-User: 
X-Stat-Signature: myhjcdz7ggxuufheunc4r158k9kqcjss
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793314827-84396
X-HE-Meta: U2FsdGVkX19cG92sPmkg2iItPba7BW0Jlk8qCtgg2IDg1AUgDsJOeoW9AeJPQkeGQunSRoUDTS+EUCH7Rq3a/NS//82d7hfD5aifIm0pzfpgDd2izj0p7q5fIs1iGM9Ss/ZHZH/n6KkpvJ0vbTHvZIoPt0/sZLCxsuGGQnyO+g5J3LOuHigFdIZCJmNU17AlUM4Uj797zAsU4dhSYRsplDVUoQ5SKx7hT5HTp22CmelHFVG/6SdN/onlInm0CHvR+shJBftyq40xEypXNM7eYCFzhoqDrH+iyHHfbgqcFVPRGFw1jzHJzU/80HqdKEXD3icdCY/1hONRKHrAV33v708vNuQRAzh537S7OvixmhLZmPEhOf02yiHMwru4eiZg/2S6JX1Rd++QLfP3CtAvt1tp+tzNzoMI+iWe+TysVrUNA4YclN5vvrZyqBgc5CPH09s8Ui5sAgcuJ9S9W2kD1MfmPIK3M+1JvvKqLdMFXLgiFq3I70jvHezP6G1Nt3YPuPn7N5sM1qAOSmQHd8wD+dmuqGOFryLXju65O0j9ZK10Vj2TvJ3qFaGf5GT5qN74rOsNj198dbCs3ylTQc1eSGqOPMPI2VqB4OBy1W/n1ruM/SbgqJOSs/uc4Z4erARpLRJ76iuneBHEIqPpLDjsjrYF/WxO07aK1Hidwit/PA+sOfxkoWXoOoVYFPn3wGxZ9QCpmVoBb8FwkUyoAHpnypvYOssPbgQZlQ0idnpS8+sukLwg2rAdXxlES8Rwz7VZjaQ2g5mfRx5vYBJ9ZEQ896CFc6Y95BRK/eZRIMAARo9X5lg/0uf9EX0wtZ59hPePlXxiq9cSceiTCq2cRzajJexdOPjhYn2M89R/y4QJxpvR8lkoMmsC9r4RWsQQWpn2KUmNHtFiFCXmL+vXJQNpOvWpbdPdtHf87tZEeJKL+6z20FW/oF6Ir2O8z3cH2crcUZhovCey4ph8uBOiSxl
 itZ/cJle
 dZ0ikAEBEEfjoj2LZeiJd2tSgTur/5Pt0HmV51Ct/3zZmOYoJbVaT46YUngs/O7v5rhRfVSD4pGsfDokqqLnFyotUdD7xuU0lPhnVWdOKHh6I1ZGUS6L3NUHqtTY3gM3ODAQ63qGMSF7kdCF8j5NScNoOZsqx4e5iqndhbqus+N+vmfq9C4SkEZLFq80i62dfW5xpGI8Rg/m5w8/8QlQc0tkEbPU6eCtNPCE/ueBejfLYvWmk48U+3uc9vNeLD6JzPwiXQXrC5DcgVR4wP2FL1wWTAqJi3mS7no+OMpiMc9drWRbkFn/NAi+Kn/Dg0GQasncVU7wYo2CRDMIibUcFgABL6BeuPU0Yni9xL8ruVSgbpg7zhroczThZ0f0yxda8VLQHHmPPaw7MEqHT50wrSlNVCFqEGAeOtEVr/9ki0f+L/9fzNvozFoWPgeDK6Kr67gpZ8kavpF1i2MIiebH7bnZcYz7lX7+XNB2Kz/tD2Je15BIJ7kKXXfyAlSILopPRmUhqADa/rh9abfLgFbj0ox/jOntGypEHnEoOOG8QSDZdKro=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 8:06=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [High] mm: zswap: off-by-one bitfield width for zswap_entry.length on 2=
56KB pages
> - [Medium] mm: zswap: shrink_memcg() skips non-N_NORMAL_MEMORY nodes in z=
swap_list_lru
> --
>
> commit c4aa889f59a75fcf871276fd68b4a4738afe132b
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> mm: zswap: Store the folio's node id in the zswap_entry.
>
> This commit stores the folio's NUMA node ID directly in struct zswap_entr=
y
> instead of deriving it from the slab page backing the entry, and converts
> zswap_entry_cache_alloc() to use node-agnostic slab allocation. To keep t=
he
> structure size unchanged, it packs length and referenced into bitfields.
>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index e1d57a7d95950..19b7d60bc7d2a 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -180,6 +180,7 @@ struct zswap_pool {
> >   */
> >  #define ZSWAP_FIRST_POOL_ID 1
> >  #define ZSWAP_MAX_POOL_ID U8_MAX
> > +#define ZSWAP_MAX_COMPR_LENGTH_SHIFT 18U
> >  static DEFINE_XARRAY_FLAGS(zswap_pools, XA_FLAGS_ALLOC1 | XA_FLAGS_LOC=
K_BH);
> >  static struct zswap_pool __rcu *zswap_current_pool;
> >
> > @@ -206,15 +207,19 @@ static struct shrinker *zswap_shrinker;
> >   *              logic if referenced is unset. See comments in the shri=
nker
> >   *              section for context.
> >   * pool_idx - id of the zswap_pool that the entry's data is in.
> > + * nid - NUMA node id of the page for which this is the zswap entry.
> >   * handle - zsmalloc allocation handle that stores the compressed page=
 data
> >   * objcg - the obj_cgroup that the compressed memory is charged to
> >   * lru - handle to the pool's lru used to evict pages.
> >   */
> >  struct zswap_entry {
> >       swp_entry_t swpentry;
> > -     unsigned int length;
> > -     bool referenced;
> > -     u8 pool_idx;
> > +     struct {
> > +             unsigned int length:ZSWAP_MAX_COMPR_LENGTH_SHIFT;
> > +             bool referenced:1U;
> > +             u8 pool_idx;
> > +     };
>
> [Severity: High]
> Can entry->length overflow to 0 when storing an incompressible page on a
> kernel with 256KB pages (PAGE_SHIFT =3D=3D 18)?

Good catch. This has been addressed by setting
ZSWAP_MAX_COMPR_LENGTH_SHIFT to 19U and the build time assertion check
for BUILD_BUG_ON(ZSWAP_MAX_COMPR_LENGTH_SHIFT <=3D PAGE_SHIFT)), as per
Sashiko's suggestion.

[ .. ]

>
> > @@ -1507,9 +1506,10 @@ static bool zswap_store_page(struct folio *folio=
, long index,
> >  {
> >       swp_entry_t page_swpentry =3D folio_swap_entry(folio, index);
> >       struct zswap_entry *entry, *old;
> > +     int nid =3D folio_nid(folio);
> >
> >       /* allocate entry */
> > -     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
> > +     entry =3D zswap_entry_cache_alloc(GFP_KERNEL);
> >       if (!entry) {
> >               zswap_reject_kmemcache_fail++;
> >               return false;
> > @@ -1524,6 +1524,7 @@ static bool zswap_store_page(struct folio *folio,=
 long index,
> >        * to an unrelated live pool.
> >        */
> >       entry->pool_idx =3D pool->idx;
> > +     entry->nid =3D nid;
>
> [Severity: Medium]
> What happens during cgroup or pool reclaim in shrink_memcg() if the swapp=
ed
> folio resides on a NUMA node without normal memory (for example, a
> ZONE_MOVABLE-only or ZONE_HIGHMEM-only node)?
>
> Previously, entry_to_nid() derived the node from virt_to_page(entry), whi=
ch
> was allocated from slab with GFP_KERNEL and therefore always resided on a
> node in N_NORMAL_MEMORY.
>
> With entry->nid now set to folio_nid(folio) in zswap_store_page(), anonym=
ous
> and shmem folios allocated with GFP_HIGHUSER_MOVABLE can have an entry->n=
id
> that is in N_MEMORY, but not in N_NORMAL_MEMORY. zswap_lru_add() inserts
> those entries into zswap_list_lru for entry->nid, but shrink_memcg() only
> walks N_NORMAL_MEMORY nodes:
>
> mm/zswap.c:shrink_memcg() {
>     ...
>         for_each_node_state(nid, N_NORMAL_MEMORY) {
>                 unsigned long nr_to_walk =3D SWAP_CLUSTER_MAX;
>
>                 shrunk +=3D list_lru_walk_one(&zswap_list_lru, nid, memcg=
,
>                                             &shrink_memcg_cb, NULL, &nr_t=
o_walk);
>                 scanned +=3D SWAP_CLUSTER_MAX - nr_to_walk;
>         }
> }
>
> Should shrink_memcg() iterate over N_MEMORY instead of N_NORMAL_MEMORY so
> that entries from movable-only or highmem-only nodes can be reclaimed by
> shrink_worker() and mem_cgroup_try_charge_zswap()?

Conversely, is the previous behavior correct? The entry is created on
a node in N_NORMAL_MEMORY, and when that node is under memory pressure
the folio (allocated on ZONE_MOVABLE-only or ZONE_HIGHMEM-only node)
could get written back. This doesn't resolve the memory pressure for
the node on which the entry is allocated.

Nhat/Yosry/Johannes: Does Sashiko's suggestion for the shrink_memcg()
modification look Ok to you?

Thanks,
Kanchana
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.17=
923-1-kanchanapsridhar2026@gmail.com?part=3D5

