Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 232E5FD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 530BA6B009B; Wed, 25 Feb 2026 11:05:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3EC6B009D; Wed, 25 Feb 2026 11:05:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F1406B009E; Wed, 25 Feb 2026 11:05:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 269336B009B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:05:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BCAC0BA5A6
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:05:02 +0000 (UTC)
X-FDA: 84483452844.26.6131D94
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id BA06840010
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:05:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iZdyR754;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772035500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/BQJ+R+TI33mzFtq5raf6n+ghaSbKffikGrD0MxajU=;
	b=hqLYsU5m6LRkey7ZgV0ZqsKts/ksMuIy4ejVRbrlQPm/VO3SeDt+UwbEH+9WiyxHfhhtPD
	HSotK43UpiknNPdTAArwL0bpIs6H+CvRf1a39fHj2HaCg0H5d6QUD++OhHRWfCPB9M+X6f
	VKaU+jELOwEpSG358Df/mXGVaPesEXc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772035500; a=rsa-sha256;
	cv=pass;
	b=3u6vl5yPm1370VgPtSvLdkoLbBkkMaaw0h4buFh9vc2H6lrJMvxkOa39GsVAf5qlKhi18a
	9S5WN0ZfzRHZr7pbhrhvGqlkiJFXXMkb4FJR9sSQMQ1akWPk1VZqQKqXmwlrOyRCkrK1gT
	ABRCRo6S9AOO54Aq85HmtzLoWFw8he0=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iZdyR754;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5069a785ed2so724061cf.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:05:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772035500; cv=none;
        d=google.com; s=arc-20240605;
        b=Gi++d+x1iQWGIC53m74/MsnnBQRKXLtoZksBaR+Jd40Xczp4dg9f9O2oP+OElyrIwf
         0Oxa8xnWYNH0G7C4/MnSW/PZpWw1BvpQtjsMc+8oTIbuUj6PO5z9hKkptcwX4MvRL3mP
         PhrfKg9+6fw7ofHOwqVkhcgkRWncIeJSTHsN1/+CETPGZxUOhdEfxvQpwvjTJEN8Mp6h
         rFageT71Y6Rqh0X6Tj480mVqJ4rrgMdrIXelGph1NFsL5b1aFV4UHYFaX/g1G/E7djgu
         pD7S/pxAi9O2i80VNvOgbO9k7WVPjYJo+aLgwJ71/HGogQZh4l68bL25+ACxCMQUrG02
         ejjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x/BQJ+R+TI33mzFtq5raf6n+ghaSbKffikGrD0MxajU=;
        fh=fy2sPtlvjaoUtemOfH++ZqImQP+zHR9F3/0xbHk2cds=;
        b=L8mLHt4PUFSitzRCARFVgOir50ScQ1FnriC8EZTpRUP/1dK1VlJq90hBCU6sRB3JEP
         F+3HXvrLmLMCDuUpAypk+Dlw+J3GtETI0TxxazIhU3kx8fu+O1DjHbFw/Khw/r9So9Wj
         Mgbd3OWpzXT6RciwCJzKt0O7eEYdp4PuEXliiQNgAlvN0OIvzYEmjBS9kskXfaED1nLV
         TqWKa8qav7dfqk93wizRhGoWek9wBPHZmBbbPYYCnuO8Nye8FpjVhpaq5FmgwnLA2g1B
         4j2LynE/RXZH/QEO4M2Cy1RI86/9jDINRt9j+QF8tCrqEBwc8LWZO9UiYvsOMZ2mBe5V
         2dAQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772035500; x=1772640300; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x/BQJ+R+TI33mzFtq5raf6n+ghaSbKffikGrD0MxajU=;
        b=iZdyR754c6aCFVam3NoVyIt3CGEF/QjnakbJSSs4QLmO3hgBptgya2BR+FXwmH63K2
         iAu/0Ltt704OtJKUn3doW4GiENI/vyCUa2BAm7v954C3A7pLUJ24XBmDCFCKJHFCbhWe
         GZOS0CVTlsTxlJWkwdJJktU9W0UK/2WvBt0fuTboVSf15RUn32rM5Fbo3+IAWiFvZ3hb
         bQCoqt7VZvGvZXH1nrrERHDkECoY+3wc2PruIB6FSop/Os3CNjiNfTl6qoGULuxNXz1z
         FVhZMCITjRJ5f2FnCzhRf2y97nBOklENweEYTgzTe0+uP3wj+dg0dlIegokkQjv9OJS1
         GgUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772035500; x=1772640300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x/BQJ+R+TI33mzFtq5raf6n+ghaSbKffikGrD0MxajU=;
        b=JyL4Q5J6ZnH2Y1Htc+qQJA8j9rql/2myOTzcDMXZ/GbOlyXFGHrnJcPXBtn69IBPYS
         jttv0JFv5BgdhJiWUWjRReTrpbVYHVOipp1mAkiiQeFzR3nLeTxoX58guMBqQQJEoUgY
         71I0UMlOBQFKFmzjKtkPiu80bY+IC7t3U07QbFiA1F7nBLg+C02VMoY1EJXGy2eRAFJn
         kRwe+zHUtzk8lXyXB0GN/MrZG+Agkv6TJI/7TbC6v7DyOvOpEbwX1+u89fllPBl5l0gq
         YLaY++wOgxLshz7wbaeXZSoIMLoPK8zOER4jD7bdAPf0mzTSar96dbzR7UeCgvTaWtEb
         6YeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrXcTgOqvU6Px+ntHkxMopzTANOpdduTvoNVJKmfCib2did4de2Wx+4cfyyDwwEk35i9BOP0HwsQ==@kvack.org
X-Gm-Message-State: AOJu0Yyam0ox9cGOJt+3y1GZzeIwOwbLI/HARGGr4LpfV4oYTIO5H+kZ
	PSOm9T+8OuWlCzxYSv6Vm3s9HoHFPB6cA3N8lEcVdVpwJNhwKeb2iv/04PWH1MWwzk8nRq5HTxu
	ZPzq8Yh+uBQVzHdY8i6qHch13cK74lCAP41ONJpwt
X-Gm-Gg: ATEYQzwoP+qF5vnyTQ8Eyeyjvx69X3W0PVo3VyWU3UbRpY0z/FEiL3d5+1QWqYbyhRK
	mZTOQR2DgWwJnJVIcQVOKXB1Ix7EJNgv1QF7QWsAt9uBe362pkVPGxt38n9odmjWwdpgzkwr19K
	GNVf3ZSWHRBgS74qB5PlA/7oMUMs7E0pQIai3PXbakSlFl16UlWNc488VHA3BTY+Fiu5T2YYckc
	Y+0qNgxZJ1zUCMuNWMM9HnbAzIjWCVAoD0IPKu3DiHy7zRIGv+FGPrSjGzRVnT1/ECkYT96VwpP
	DpGuNbHn1RQVs64i9rUkpLr/04NIFQm5EaqwIw==
X-Received: by 2002:a05:622a:413:b0:4ed:ff77:1a85 with SMTP id
 d75a77b69052e-5073a362016mr10340311cf.17.1772035499181; Wed, 25 Feb 2026
 08:04:59 -0800 (PST)
MIME-Version: 1.0
References: <20260224221132.1702713-1-surenb@google.com> <6bebf90c.1ff0.19c92b4998d.Coremail.00107082@163.com>
In-Reply-To: <6bebf90c.1ff0.19c92b4998d.Coremail.00107082@163.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 25 Feb 2026 08:04:47 -0800
X-Gm-Features: AaiRm50Rq-Rv7w21M8RjmtQCzSFI9nv5a06j8jiGlrIkF14Qhab1ylbF28A0bZU
Message-ID: <CAJuCfpFcjgrRtJnY3aOVnvDEUTut14+QwBYMWG_pKyn2QAYtyA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm/slab: mark alloc tags empty for sheafs
 allocated with __GFP_NO_OBJ_EXT
To: David Wang <00107082@163.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, harry.yoo@oracle.com, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: odjsywchms6b38sqob1jkhcinbhwnyo9
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BA06840010
X-HE-Tag: 1772035500-492728
X-HE-Meta: U2FsdGVkX18nlUsulb56XXj4/4Dl83mZ8PYEW14Uy0TSLtsqr9a1Dfw2ffNi9QzgBhxlsob6hm7nkUFi07mXFb2rL7rOMOPrtDXnmW9ENpqxl5850fY9Mu7FG+ZYEm4PDP+tb/uFyrgWnpdPoDffcKG4tt/Ma3CE/Y/ZqFuSYMBsY5jSrMZLOMoG1ZeqMa0/TzpiUZ2X15+MxmBUPp++njE7J1Ip9QOAvZ5U0bJrXFRK06XamudIo/G653AZ6OBE8ChAZV3tqEZ/AkrUQ8iK0w4G0ZRqniEYVeWHUXWPEb7vwP5VW+3sXO3gNbpOafxHqGhZoety9kPkngX5GdM6QtFsJ6cS76IptPtPvmoPKFMDO4gVxGnvYOfonj+CwGamyb+ZLI6NpyNI7LJMG6grYlBjQ8Adxdb/wz8p1RVYkPhea9bf9IaIr+wMl50pa0QCKlooibvYpzzS4u9o5bld6QSC4IJG2OWO4Uc1l0rv/wzAKBZbJTQDCMARBKS4+k9gBL2oWia/JLx2Q3MuwWT+c4CQjdB8OGCmakgikcMzM+mhIwAGeYqQb4r7Zti4iiq3oUJU52FNPDFH0B6JFtovaMb2SpDcnWsMjd4zM65vxaEiCdRizD0E4jK3GTuSdfbYBE8Rd2XNl+VcXsp10cpNkE1C1kqIfeEjpwy6gb1sSIZUJlKhZxil0bLJpvQ2U1vri41N8f8LQ7ZejMdDTxN4syLcA82UAmmH2sF+KvJXuvVl5desLDkVeVCUF+/mF0Q9zm5JA8v7UftOh6KLigZAsolGFHw2U6FgZTkLG7qEJNXJZUO//LeiWX99kmQ/LHcagyEXEHiwlTm43WuTBHVVPncyIKwJqbemfdrItd5GxAYExNK1zuIn8Tb2y5yjqruQnaTxzcvUNxO5y8wV0q0SsbiytcpNs5iAmZIxvqRDdUFC+zd/KqAcC2snb4HH3uCC703cp0uFogt3/+tuUiC
 MB3SW7ed
 ub3V1EQegfFBbby8bAA+f9SoR934QymNtTcdgJLuxiko6EfiWv2ubt/RTQrH/ETVE2gZubGhCFCPkeee8Yy8edu1OYMd/UYsVHyfpDZB6CryOrGsM9xBpgPlWto9lgLvhmq7VQRwjRXwl8KqEoYagILFajCm3Eegf1XajfGnhZndy3Y6dGff90AdUq6s5oAY6wdKHEStgi7fN/Snux6bXAqTdAHnJ2bXUxlP09NMgOBnmERbxJoLLc/O9XwAJIIio1WBMe0wUy2NjBXHfqamjQmerrL9a1pEpXz4iByNxdv+pVBB8VLMYdmrZ+6ziG0ZZ5wYOl+62YdTkGjWSIZ0KGPNeDi5GRFfoLoJfyWQ7T7SQvElZsyDcXPWOy3Anycic+EAvIo9ddzLvK/vmsAEosCWN2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 6:50=E2=80=AFPM David Wang <00107082@163.com> wrote=
:
>
> At 2026-02-25 06:11:32, "Suren Baghdasaryan" <surenb@google.com> wrote:
> >alloc_empty_sheaf() allocates sheafs from SLAB_KMALLOC caches using
> >__GFP_NO_OBJ_EXT to avoid recursion, however it does not mark their
> >allocation tags empty before freeing, which results in a warning when
> >CONFIG_MEM_ALLOC_PROFILING_DEBUG is set. Fix this by marking allocation
> >tags for such allocations as empty.
> >
> >Reported-by: David Wang <00107082@163.com>
> >Closes: https://lore.kernel.org/all/20260223155128.3849-1-00107082@163.c=
om/
> >Analyzed-by: Harry Yoo <harry.yoo@oracle.com>
> >Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >---
> > mm/slab.h |  4 ++--
> > mm/slub.c | 23 +++++++++++++++--------
> > 2 files changed, 17 insertions(+), 10 deletions(-)
> >
> >diff --git a/mm/slab.h b/mm/slab.h
> >index 71c7261bf822..f6ef862b60ef 100644
> >--- a/mm/slab.h
> >+++ b/mm/slab.h
> >@@ -290,14 +290,14 @@ static inline void *nearest_obj(struct kmem_cache =
*cache,
> >
> > /* Determine object index from a given position */
> > static inline unsigned int __obj_to_index(const struct kmem_cache *cach=
e,
> >-                                        void *addr, void *obj)
> >+                                        void *addr, const void *obj)
> > {
> >       return reciprocal_divide(kasan_reset_tag(obj) - addr,
> >                                cache->reciprocal_size);
> > }
> >
> > static inline unsigned int obj_to_index(const struct kmem_cache *cache,
> >-                                      const struct slab *slab, void *ob=
j)
> >+                                      const struct slab *slab, const vo=
id *obj)
> > {
> >       if (is_kfence_address(obj))
> >               return 0;
> >diff --git a/mm/slub.c b/mm/slub.c
> >index 862642c165ed..5c76e55eee7d 100644
> >--- a/mm/slub.c
> >+++ b/mm/slub.c
> >@@ -2041,18 +2041,18 @@ static inline void dec_slabs_node(struct kmem_ca=
che *s, int node,
> >
> > #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> >
> >-static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
> >+static inline void mark_objexts_empty(const void *obj)
> > {
> >-      struct slab *obj_exts_slab;
> >+      struct slab *obj_slab;
> >       unsigned long slab_exts;
> >
> >-      obj_exts_slab =3D virt_to_slab(obj_exts);
> >-      slab_exts =3D slab_obj_exts(obj_exts_slab);
> >+      obj_slab =3D virt_to_slab(obj);
> >+      slab_exts =3D slab_obj_exts(obj_slab);
> >       if (slab_exts) {
> >               get_slab_obj_exts(slab_exts);
> >-              unsigned int offs =3D obj_to_index(obj_exts_slab->slab_ca=
che,
> >-                                               obj_exts_slab, obj_exts)=
;
> >-              struct slabobj_ext *ext =3D slab_obj_ext(obj_exts_slab,
> >+              unsigned int offs =3D obj_to_index(obj_slab->slab_cache,
> >+                                               obj_slab, obj);
> >+              struct slabobj_ext *ext =3D slab_obj_ext(obj_slab,
> >                                                      slab_exts, offs);
> >
> >               if (unlikely(is_codetag_empty(&ext->ref))) {
> >@@ -2090,7 +2090,7 @@ static inline void handle_failed_objexts_alloc(uns=
igned long obj_exts,
> >
> > #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
> >
> >-static inline void mark_objexts_empty(struct slabobj_ext *obj_exts) {}
> >+static inline void mark_objexts_empty(const void *obj) {}
> > static inline bool mark_failed_objexts_alloc(struct slab *slab) { retur=
n false; }
> > static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
> >                       struct slabobj_ext *vec, unsigned int objects) {}
> >@@ -2312,6 +2312,10 @@ static void alloc_slab_obj_exts_early(struct kmem=
_cache *s, struct slab *slab)
> >
> > #else /* CONFIG_SLAB_OBJ_EXT */
> >
> >+static inline void mark_objexts_empty(const void *obj)
> >+{
> >+}
> >+
> > static inline void init_slab_obj_exts(struct slab *slab)
> > {
> > }
> >@@ -2783,6 +2787,9 @@ static inline struct slab_sheaf *alloc_empty_sheaf=
(struct kmem_cache *s,
> >
> > static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *s=
heaf)
> > {
> >+      if (s->flags & SLAB_KMALLOC)
> >+              mark_objexts_empty(sheaf);
> >+
> >       kfree(sheaf);
> >
> >       stat(s, SHEAF_FREE);
> >
> >base-commit: 7dff99b354601dd01829e1511711846e04340a69
> >--
> >2.53.0.414.gf7e9f6c205-goog
>
> Tested-by: David Wang <00107082@163.com>

Thanks!
>
>
> David

