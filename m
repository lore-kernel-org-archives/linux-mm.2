Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57A70606A6BE
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 23:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EMnpcMSn
Received: by kanga.kvack.org (Postfix)
	id 686C86B05B1; Fri, 20 Nov 2026 18:51:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65DC16B05B2; Fri, 20 Nov 2026 18:51:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54DF66B05B3; Fri, 20 Nov 2026 18:51:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A8246B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:51:22 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ADBDF8026E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:51:21 +0000 (UTC)
X-FDA: 85457146362.16.50E0058
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id B0E27180003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:51:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EMnpcMSn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795218678;
	b=AfIZ6g/t4FgSBMyHOYajwvOtjQFLUidhZBI4+SgRQvl4mrxzsjWN0hrAcwbPAKXT4irqjH
	rbf8Ns1mFSVfeRSKetUjpu0tI5IvjYCu3YjkRrP5ThhHEnatzCfd0mx6ymVEfPvJblBXns
	lhLGEvVGJpDVBDCARz3TV1qOt/KmZTk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795218678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KHxTN0uS+Qg1aDUZNJtoDzFicoj8vWJ+yr5kM/h7aeY=;
	b=VllKjVv5ccAd9HMVG4fz9Cb97NdchJnbd91tkz8YNXFxcHs14FXQCiumr3Yi2TMuQ13Ts0
	GFdEgnto2TIwV4A2YrJoXSj0w0d/LZAsFzvg5cvfP8ksUyxgaLhHJNWNXNGtIkv03lISpW
	86SlaahDfb5fKid2DMNlzc3ktstsugU=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EMnpcMSn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5c1b8120565so848637e87.3
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:51:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795218677; cv=none;
        d=google.com; s=arc-20260327;
        b=VADPg7XOmQM5BWVSDZ0gDr9jH3rwMAOrcuY/uqhhATmdr8pIU6Nwx4353K6bz1eLfZ
         uiV73BfUQOyJShKC0JoWbpg97wwEsV6T930Lz4h7fNYXJpetmM+NdPdd0WwQUH0VLC4R
         1/TwOF896EOTbzfzmDGhnZUyDw4+Qw7mqVOtdQ0oIQX1W59pwZvVqUIOFrCVqBi1MPM9
         oK6W7Ygo9Iu3SHejbJPuYAlkIPxSKMlNVMGIP51z+FDimjFoIF/aSZD7ypiF+AnkKIIG
         r0+ZkfSoojCneKqVGm0lxRgDpjQFeo+vgPfNWqdKOA88aYVZSBqZ5JU0HE3UGNUqyo+g
         x1pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KHxTN0uS+Qg1aDUZNJtoDzFicoj8vWJ+yr5kM/h7aeY=;
        fh=8ogqzSiS3hgC7evdWvL4T4/WltEl4tvKIwpoWdpocl8=;
        b=ON/z7YoAox8I49A+jtScYtGdmYEVmcFl2MfS6slW1rz2Tf7dYMmUjhic/mg4YWEbcX
         YKHpqwZS+nkuDANlEQgkj1HprTu25LDprioZ18Xp3mz4HCQppuTMIpM+zO2EMBGZfemW
         D3vtIm/gRdbQJMi2K2FMPJrQgoilM4R7aPA+5aOhNq4i0L1wZ5U0czfHakUq3uyEnIOH
         Z85+c2g8Fpf16LgDa5qP4oP6hOQO4TTBHnPt1nryMj7JJbAn8FVFhi+d+O59XBwdVDzE
         uzI+BTptZ/X+ELOn3UHeYMY+v1ggTAWUTiMNgOGK47NuOz6Epi4b3rQyOWQc0a8BW5AG
         jzZw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795218677; x=1795823477; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KHxTN0uS+Qg1aDUZNJtoDzFicoj8vWJ+yr5kM/h7aeY=;
        b=EMnpcMSnNQZau8CG6QeEGI9FaXigHzCt8mxIsdXnaf/ySRbXTr+Kcw57z+ibSsLkuF
         MJTBnEQeWBhtHjwFT56yTg3wI1Xok96L6JBMnHqbKC9ESenK/cVl417h4Qg4p+MnVLca
         i2VozokbBws0Dx6eJUmASz0WGAAFsNEbpGVkZshOi0FYZ7aBaihhEjrBA5v7ml1AFTMS
         gQRqKIQbapptssuPBDqHPJ4Nwk4R5LnR/cUHsRaWTgy+9mWmOQ+MeN5yc+A/PxeHMr3n
         aSFwQzwXwZow50Ls6iHUmQGbVp8KAOeYOaIGRBJKYFV4FBiI+m1BTcZNhptVGw3eL/B6
         S8Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795218677; x=1795823477;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KHxTN0uS+Qg1aDUZNJtoDzFicoj8vWJ+yr5kM/h7aeY=;
        b=na23xoPQrPf+kBbGlFjy8pfQIS8RBXfqSY2PXISezLB8PJjvlfIUa3h6/4nXfmHO5k
         +rnGKho61VLjW3prjFLQMrP4htT/RbkGAMKDflnQV/KW6L9ePiqjx80VtlwC4i60/WH9
         ObW+0WF7+WbkawkwzQ6ShFyABBmoroxsOItH/nwbF0z/8wIB/pKpSB5AXZtco1FyW60/
         5zwbhguzyJU+nqJ9VYIH9y8hGaSiKGvKnsdPXGdj9aWw0xh6qxXWGeU5mqSBxQQ3WmMD
         fV/uYgQfBVwvTseEKWyJT6d0xuGqLAQvTs1+8liLbvYJLybnO1XELcIZzlTCdmpHKNZy
         JoLg==
X-Forwarded-Encrypted: i=1; AL+hErHC1eH3a7BWVUZfu5ZRSHdtmGRQqzcCgSGu7uJMpWNyf+cpF7GRMOl43ithPxuXzO8cyQJsroA97g==@kvack.org
X-Gm-Message-State: APuU4Z9aBJISUTluMP7Kqb0T0zyxgwBkaDIWmPvF/frvntY8KR19A659
	X1yUhKD1vmdcmH61R+kuUStdT9v5RZZN3TGiz7vMJscMoABXWBpRoNsirwNgSANGx3yQswTakvA
	4eumzhpoxMxpJvwqvbPOj6CZJsgEK9ic=
X-Gm-Gg: AZFdTZd7zrS71nCJkDyLA6tRDBgAK3tSafZ5XgaksssUGZOjwr9eI6t+tkITLY9tzlj
	Ii1zLBikwlWe1cEYqw8k2hxOSDYHTI1Sp7L2c4B2outBqRWL6PGYx1oINKBhWqP4LXLt5hkSMLI
	ZEUlH/52ElU9LSxih/uuszvK1KS5KGQKuhkhUScbRN3useWZQay45HPG5oTUmzm74RaP5hfafDu
	rot7f2qHZzkEZ+oqztYuf2VDZnYfDijTmepbYyUox0g+mRVs+TNgKyFZ4LT8vfh0Aq1FDbo/mYm
	DZzE5wQAh+AfAZrCW6WOh2MjgV1ke/rkIRelCP83vJhiTHu6dqFGDpVsHfPT+XUXOUOchk54ISS
	eECmxfn6iacb4pNHecXW3zLW+gep5d6GEbYbpo6WtQk5CDxwHdcQ0od0HOA==
X-Received: by 2002:a05:6512:3da4:b0:5c1:57ba:f848 with SMTP id
 2adb3069b0e04-5c1bc576a77mr1562754e87.0.1795218676722; Fri, 20 Nov 2026
 15:51:16 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-7-kanchanapsridhar2026@gmail.com> <CAKEwX=Pr6t8w676ztfrONaKrRKoy6NS1priTb2c2XUikNhYU7A@mail.gmail.com>
In-Reply-To: <CAKEwX=Pr6t8w676ztfrONaKrRKoy6NS1priTb2c2XUikNhYU7A@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 15:51:04 -0800
X-Gm-Features: Aa3M54pGq-g0FQY51hIMaRGadQCw3Jar2bC1oRgHGQK3b2ePQ8Bn-IWKzW3So3o
Message-ID: <CACpmpocuNQE=6m=WJ7oX_1ZP0WvwQm4T=6KFv3ya2k7oNvM=yw@mail.gmail.com>
Subject: Re: [PATCH v4 6/8] mm: zswap: Store large folios in batches.
To: Nhat Pham <nphamcs@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B0E27180003
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: tkmk83xy6kuk8yhzmsxcgfyzri6upknw
X-HE-Tag: 1795218678-425243
X-HE-Meta: U2FsdGVkX1+/PlDebhaJ8QxskS0yNLoY+1PZfbIblXMmVCkWJfP9MXX7yKfwBFfvAuj3/3iXSfslb5wtcLbUPLDy/vjVxMlV9EdWvWG8Nd/3bYv4O3q/AKH1E6ixGoxCBii3mjRgpPDIFyQKhN35ghC8hSzIiNHw1nS9dvn/JvIN/2ynLymJ3xnN5dRCciXgLiDfxYHLufGqKCJMskw8NXN0xT9fJ8kuoLRiCMJ2Ih0WfBE9xH1onawxn+cfhpebl/iC6med9nOQwOWQUEZFObekvCPRwK132yMcfHJdURbaztPw0tkma/yaqN64dDtG/QJz8doWAJe4B4Jjx0BuKWwbRtro2YErUHnYloEC5BELak7t3AmMcSkc9hFyCD6JqE/1+nkD18omDecyRLNn8HnWSnrnbHJQqyK/QlJpvH3hFJPYvfwPraSdPuSowjkEsJ3Fn37d3WM8dERfYbcEywbO6Y78Z55Z/IjRQ9zt2ZPrUb82poVUwMVYVwGHk6Baas2+g1sh0QhkYghWD+XScMl/6sk6WX9fsmX4Kth3EdDOwuFosIvVhAGANwdoDC4b5SAheTijRlb0AgNJlsyA0vPnxUYU/2jvArhHjSekxd8gHXp0PrRhOCs2Y1FKfulcJ9PkPpFPVoIqL2EBp2nNRwgNQlo/2xQbh8suQGZXu602Fpt4RpIjkTclVqEn0yTWCOGKCHVVnvgGF7/MGGk16Dlj44w459WZbd6sOLPM4r9TQJJKpymTgyd1uIUfS49zk4wIND0GD3zlqhP9Mg/Ub2JxUDzKlh38wKc5fjufDTaWtO42z3S4XgKEhO+6ogq6C2HqtPwJEIYr5Th8pigowFu9onOvXaIeUJotZHsG0pcN3c42MsVlu2HUk5h2UItmI4ADkti0tr5qBiQcH5aLRkkwob0eiKnTnj24mQNEgyZxh/iHKhDMRoWMTzjppB2h034V4E41eeoxvNieI8P
 iNmK3crO
 rcZ0ZkyhE4S1JVtiNY5q+Tw3pnEdWjploLNewaOg1f+4Ezysh/UziA/vLoOnU+/kalY232vUZ0BRW97gMCekiRpsWgVv+O88ryTtUOrWqx1ASK5+6+I69HpeqqIQ8Cv9TsJcLriXcsplWua/6+MbXZDUHQ2UVWmVgu98c5BaNhZWPA65fpxGHWyvZS5XhDPeHwm7+FA3giw2bELirxuk/IO2qRvGRmg6UPnpztHOQpEK0DeFptAoUzqitbw1qGSRE5xM9iu3RYdudJztp73ZPmCLnQCyBwKo+ADqXiWd3cuvtIWfxJ7+ZW6VuHhZKdnyjL2/p1Qp2/oJo2Wo2gkt0j1Z/Tyms2hQ2QwwOZVJQvtk2mODp5GtPE478X6bUxBHiM5e4qtnmu8TYw4FIDMxbXchz4e0vgSjuFfU6QKL9xH3Dx02oHR4TKFQsQCB3vNU53Rc6NJElOmYToNXLndA4NjT/2AJDL6s47r8Sr8WwYwR3HMkr5HvVEu20GKqFB1TrhEL2aYC0+W5Zq9fewF3IDQhigyB60NVbUjmXdp387imaps2EDITk6sDcIm6uN6JNlybWqdG8FNEu49yI5qWfaRyFwVtaKXipJJrx9ncGDv0RgMbZI6yFskDOwSJA9nUfL4Pmgq7xuM+E3MUbNaso8iN25T2TqVghKzop
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 3:25=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > Use batching when storing large folios in zswap. A new constant,
> > ZSWAP_MAX_BATCH_SIZE is defined as 4U to support processing batches of
> > up to 4 pages at a time while storing large folios. This commit
> > modifies the "store single page" approach to "store a batch of pages".
> >
> > As part of CPU onlining per-CPU acomp_ctx setup, ZSWAP_MAX_BATCH_SIZE
> > compression buffers are allocated to eventually be able to compress and
> > store ZSWAP_MAX_BATCH_SIZE pages. This happens in subsequent commits.
> >
> > For existing software compressors, the extra overhead is the
> > the extra 'buffers' pointer, 3 additional elements in 'buffers' and 3
> > additional 4K space per 'buffers[i]': in all ~12 KB per-CPU on
> > x86_64. Only the first buffer is currently used.
> >
> > zswap_store_page() is replaced with zswap_store_pages(), which processe=
s
> > a batch of pages and allows for batching optimizations. For now, only
> > optimize allocating entries by using batch allocations from the slab
> > cache.
> >
> > Avoid repeatedly calling mem_cgroup_zswap_writeback_enabled() for every
> > page and only call it once for the folio, since the entire folio is
> > charged to a single memcg. Similarly, obtain the nid once to use during
> > each batch store of a folio. To facilitate this, a "struct
> > zswap_store_context" is introduced to keep function parameter lists
> > concise.
> >
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> > ---
> >  mm/zswap.c | 307 +++++++++++++++++++++++++++++++++++++----------------
> >  1 file changed, 217 insertions(+), 90 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 78d9694f75b5..df59ab0c1029 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -85,6 +85,9 @@ static bool zswap_pool_reached_full;
> >
> >  #define ZSWAP_PARAM_UNSET ""
> >
> > +/* Limit the batch size to limit per-CPU memory usage for dst buffers.=
 */
> > +#define ZSWAP_MAX_BATCH_SIZE 4U
> > +
> >  static int zswap_setup(void);
> >
> >  /* Enable/disable zswap */
> > @@ -144,10 +147,12 @@ struct zswap_acomp_req {
> >         struct mutex mutex;
> >  };
> >
> > -/* The compression mutex also protects the output buffer. */
> > +/*
> > + * The compression mutex also protects the output buffer(s).
> > + */
> >  struct zswap_comp_ctx {
> >         struct zswap_acomp_req areq;
> > -       u8 *buffer;
> > +       u8 **buffers;
> >  };
> >
> >  /* Separate requests, so that decompression does not wait for compress=
ion. */
> > @@ -162,6 +167,7 @@ struct crypto_acomp_ctx {
> >   * The only case where lru_lock is not acquired while holding tree.loc=
k is
> >   * when a zswap_entry is taken off the lru for writeback, in that case=
 it
> >   * needs to be verified that it's still valid in the tree.
> > + *
> >   */
> >  struct zswap_pool {
> >         struct zs_pool *zs_pool;
> > @@ -226,6 +232,15 @@ struct zswap_entry {
> >         struct list_head lru;
> >  };
> >
> > +struct zswap_store_context {
> > +       struct folio *folio;
> > +       long folio_start;
> > +       bool wb_enabled;
> > +       int nid;
> > +       u8 nr_pages;
> > +       struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
> > +};
> > +
> >  /*
> >   * No RCU section is needed around the returned pointer: a stored entr=
y pins
> >   * its pool via percpu_ref (taken in zswap_store_page()), so the id ca=
nnot be
> > @@ -284,6 +299,8 @@ static void __zswap_pool_empty(struct percpu_ref *r=
ef);
> >
> >  static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
> >  {
> > +       u8 i;
> > +
> >         if (!acomp_ctx)
> >                 return;
> >
> > @@ -302,8 +319,12 @@ static void acomp_ctx_free(struct crypto_acomp_ctx=
 *acomp_ctx)
> >
> >         acomp_ctx->acomp =3D NULL;
> >
> > -       kfree(acomp_ctx->comp.buffer);
> > -       acomp_ctx->comp.buffer =3D NULL;
> > +       if (acomp_ctx->comp.buffers) {
> > +               for (i =3D 0; i < ZSWAP_MAX_BATCH_SIZE; ++i)
> > +                       kfree(acomp_ctx->comp.buffers[i]);
> > +               kfree(acomp_ctx->comp.buffers);
> > +       }
> > +       acomp_ctx->comp.buffers =3D NULL;
> >  }
> >
> >  static struct zswap_pool *zswap_pool_create(char *compressor)
> > @@ -388,6 +409,7 @@ static struct zswap_pool *zswap_pool_create(char *c=
ompressor)
> >  cpuhp_add_fail:
> >         for_each_possible_cpu(cpu)
> >                 acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu));
> > +
> >  error:
> >         if (pool->acomp_ctx)
> >                 free_percpu(pool->acomp_ctx);
> > @@ -778,6 +800,44 @@ static void zswap_entry_cache_free(struct zswap_en=
try *entry)
> >         kmem_cache_free(zswap_entry_cache, entry);
> >  }
> >
> > +static inline void zswap_entries_cache_free_batch(
> > +       struct zswap_entry **entries,
> > +       u8 nr_entries)
> > +{
> > +       /*
> > +        * It is okay to use this to free entries allocated separately
> > +        * by zswap_entry_cache_alloc().
> > +        */
> > +       kmem_cache_free_bulk(zswap_entry_cache, nr_entries, (void **)en=
tries);
> > +}
> > +
> > +static bool zswap_entries_cache_alloc_batch(
> > +       struct zswap_store_context *zc,
> > +       gfp_t gfp)
> > +{
> > +       u8 i;
> > +
> > +       bool ret =3D kmem_cache_alloc_bulk(zswap_entry_cache, gfp,
> > +                                        zc->nr_pages, (void **)zc->ent=
ries);
> > +
> > +       if (likely(ret)) {
> > +               for (i =3D 0; i < zc->nr_pages; ++i)
> > +                       zs_handle_init(&zc->entries[i]->handle);
> > +       } else {
> > +               for (i =3D 0; i < zc->nr_pages; ++i) {
> > +                       zc->entries[i] =3D zswap_entry_cache_alloc(GFP_=
KERNEL);
>
> Oh and why are we using GFP_KERNEL in the fallback path, but passing a
> gfp to kmem_cache_alloc_bulk above?
>
> (and it seems like the only caller of
> zswap_entries_cache_alloc_batch() passed GFP_KERNEL for gfp anyway?).
>
> Let's just drop gfp and use GFP_KERNEL if that's the intention?

Good catch! Makes sense, I will drop the gfp and use GFP_KERNEL in the next=
 rev.

Thanks,
Kanchana

