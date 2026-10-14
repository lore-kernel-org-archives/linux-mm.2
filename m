Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D392CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 01:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4D56B0088; Tue, 13 Oct 2026 21:17:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2658D6B008A; Tue, 13 Oct 2026 21:17:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154996B008C; Tue, 13 Oct 2026 21:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA2E46B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:17:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E7B114039E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 01:17:37 +0000 (UTC)
X-FDA: 85319469354.01.C89AF28
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 565FE140006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 01:17:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a59RhD0+;
	spf=pass (imf26.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791940655;
	b=eWI4PYfImv134P7SAxsbZb85S1fhP0Hc/U0ZarEeosxYMnSs1lrDQ0IQeXIAB0k+C1I24F
	jsIbmAODphRZS/wSi42FsTYFNA/S2NUYfIqs6eyUl1GbzYv/mAdRY96g4bXytzXY0K1auf
	/vGyE14Hfh+brS4n9Rkq9c7xD1AJs40=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a59RhD0+;
	spf=pass (imf26.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791940655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wyQBM5A+sbr/bsu9Xm3Evkx/SvDUAAi47Tsf2PiRHKk=;
	b=zJYvuw8P7RsUckv/2KqjSKhIn9WC7bGVx93TikiPvb8cYl/t5dBIEWXw+HDSUc47pzz75z
	JoAhC2LE2/UaKQ16Yi+da+MkxK0/OJvq8l485HQ+881KU/qGp5lR9s03XrQXgba+qktq6S
	ht+Hz+H0j+1UXEMQMruG8r9CnViub6M=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5ba36cc21cdso3207017e87.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 18:17:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791940653; cv=none;
        d=google.com; s=arc-20260327;
        b=jfMoe57CtiZlf5z9qtJiN8WVzllujF3ZxxnxXBOAp5IgRbF/kqbZJfa433QCWqw+xX
         m6uSRu9RG+VXaRpP8ynhQwuCO+NyITX3Lgv2AjvdVn3gfI5LOH8z8gCnUcSo/N1Izxaq
         g/ZzXQL4Wv1Vmz+m+pIL7rf9jWNdJ44HVMbUk01EDdSXhjgMG2PbdWtcsY3N5f4ciMGZ
         VnUXCh6DK3jlKgnMHjIA0gG1rdeOhiXbGHkN9LS8UpaonhCc1qTqQE0uUVqOTtUNrYw8
         sBgc5hLoZhYv28ouLZz7Sn52vooCkNEhKnzTIg/yT/H8HP9xCGLuXDDhOVi3rfRyXKWw
         ljTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wyQBM5A+sbr/bsu9Xm3Evkx/SvDUAAi47Tsf2PiRHKk=;
        fh=CF2X8UTXpFZ37Z1hKgKXeRalO3Bg/a+lrPol+0qPJYw=;
        b=Gza471xxiBi662RTPDFy+cnl67PAGNFfQq1ZJ60M1MqngAa7okX4JgLavEH0ed6w1g
         1tN9KVWXH8MSiseI+HcsijoOaAt+IGZPtVMraQW7gk3M3NKN+0gunG9kgDYz2LJuC4Ox
         jckuGjwk81HI5cZL7cJmEUmUMOv1gMxW4899l0m+sQxqNj600ojbONNZazSsew3gMFTz
         Rvr3+jOYhmz+XWKeVXMMUBI9Y9QAU5DM5Fw8Xtp0zbTo5VfCaixD7P9O7orOtEVJu6a3
         lC6FRUFkJUAYQab3CH4+0TiFZNr+DyeBF2QPbpyUMRqnKWk79YrDOeCB94viULdb+z67
         rZOQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791940653; x=1792545453; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wyQBM5A+sbr/bsu9Xm3Evkx/SvDUAAi47Tsf2PiRHKk=;
        b=a59RhD0+w7S7Im8+lgul+zf7zx26iW7TCl6705Qc9cZYIEoOdU2vjW47H8Md3bhNOj
         y0pDgHZIC1n4V2DtU0creV1AoOJhfkJzPyIMFED6gEte+sRs9GqH+PZdrEVBOdwz8x2O
         vJHe/wgb1lxR11eQJOl42WPIiOX4AfoBxh48Cui9rwzK3Di0PkQ9M2x+72bdyGlt8hUu
         TWkNiUfs6A3g3Td1m+TzmpLIfv/dKQGAnj10W+hOinS1L6Rto5gdMg2tGnHZNYZL/OhG
         VTUHjihPVt6KQdgPoMnql+pT+TSJfb02XxBpdjBmm7mVeoXdhhZGHvesP7qd6E5bcJi9
         YIIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791940653; x=1792545453;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wyQBM5A+sbr/bsu9Xm3Evkx/SvDUAAi47Tsf2PiRHKk=;
        b=yeHlQKRh3lpcJ/QtkTn8PDbNs5qIuu1reupDur7DtwtPVqtXP8vTx6Z/P/nv7L0jvt
         CvTmD1UO4EG7jIMCEMEIdQ4AVjqFpdfzSHvM0rNOkgSxtdE7Wo+w/3kyeJeh3xvXIN+g
         Fjp1yV0db07LrB2emUiE47PhiFUvfeRqWzzmZtN4rEpxX33RVRfjE90cUP9UUe+cdHVG
         DHr0oykiVsRbM7lk5ru5XLgNXz1CeSr3hvGkgDq8jGDmaomSUlfYfrY0usO40oD2Cy9X
         4NvRC+Sw37hZ313nOctxxtJYEYhvv+MUQwi0ENGalK7hJDFq9wckveGvOsuZU1VG9Ji5
         An0w==
X-Forwarded-Encrypted: i=1; AKwUvByF3ksdvlJsqLhSKqu73e9DdUTEEdU+xu2CqFPyuVcwDurbM2ztcMGPNMh0KnQsce4y3X6PH5H0tQ==@kvack.org
X-Gm-Message-State: AFq9FYITKzYDrC4pmgiONiGvm5FQWZY5qBtZYnTumKL6OwykyoyBeqV5
	pgUaIctSSV8lznFD7hGGGtiAJC+4oCi++opSm9nccQx7uBNu+SEJNuIlTIiDWm+v04copffevUl
	isY2Zg7i0c/wMKcUZOs6yxWASkdoQT1A=
X-Gm-Gg: AYBFou1WIFxDFH4BA2ZsdFd5bamLyAPIC/39a2PXrufgh21mCii3K+K9HLlOKi/sKA3
	tNtuep7SC5I/qX3QmhLMubKcKG3RDEkEUtJv7WGdqDKtyrFI7IKO8M/zF5KVd7oaOJzcW83sCfv
	Eapl4WvpwpMhbj4Y+Zhr7F74LkZHBJALw/K7tzfnbCw+qzCwa+MrMUqAuR55Ax/+ff41nqZbO5h
	wp7Nq/wNEQ3kpzWHdGLoNR/B21IZ14VOXkmKsd4TgPXv731awWJ9d2HK2yQmPZijQtYvF0UcQsU
	LPqWBtLdsc+QnceC6HGPwJnVJGTtixXK9nXK9BUKyDZMR6iP2Ydc6p4=
X-Received: by 2002:a05:6512:b8d:b0:5bb:7c8e:15b2 with SMTP id
 2adb3069b0e04-5bcde6c4f1cmr5490083e87.31.1791940653284; Tue, 13 Oct 2026
 18:17:33 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-6-kanchanapsridhar2026@gmail.com> <as7JC8o2kggiq_ss@google.com>
In-Reply-To: <as7JC8o2kggiq_ss@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Tue, 13 Oct 2026 18:17:20 -0700
X-Gm-Features: AclHuK9N-1t0qH1Ne5SzX5aznAgKqSCO5xi8WT7N5o98qXn1u4mrNoAaAXjfoHU
Message-ID: <CACpmpofXMGBP70Rn7jHLwOF38GRKMUGoW3rb1Jp2SPH7ygKcfw@mail.gmail.com>
Subject: Re: [PATCH v1 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: w1ih1kne7ciuwq5qyjqkj4j5hittu6zy
X-Rspamd-Queue-Id: 565FE140006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791940655-349785
X-HE-Meta: U2FsdGVkX18HOUjGPTH26WeZeuuNmGa5SQznh74Q/ba/Qrnux89XzNCacezEC2Ru1+IUoE2Cd6IHPbIjFCreK7TfXQMnmYGC2z9TG0pZfGVbNH0fefIY7NZa8etK6LsD7DcyFUrIBefb6RZCJ0cUA7TB0i6MR/2ZYiO9QPKVBsPeiwYnnmcdGnOFr2/Ltmvn9Q0vOCHVi4MZRruv6yMbDA+tAyxe7MitiK2g+H8tw+5bQrdW/aYtyrvjsfgZzSD0FYtm/wJIZjINCJpnOZJZhzgXkIgBwBXyehHIA/hLDCIhn0vAFdeoIZmi5fZzJ48Vk2JkBLLTIHqs0LA/W0LO4b6b47Wsai7Svia/LPAD8L5pSlMQUuKYiqZpi+tDN5AmhJiDsx9Gd3NougS4K+vAcQtWwzof98XfNbA1b8yT3KzZJDws1Z9wAqtRssfN+318YZfdi6FPFX4nXYsRtLuBXX3Jpz5R2dyjvQDz5bIkVFgdDlZGBSg7HveKEX/P3SP78xMMOXidlsFYpAbeL05AufMLUSny1ctpKlVInB6u3TvenRvfp2LIfbPoHQ/kN1Sjb4jG1rU6FTGeFrfGywsMjdTYZKDF5YgexUfpj14Y8F96G99N+1GuIPrW92VgPmuDk3ow0zA8bgIvuTK8LL6wHB3iIlSai3Yqi23OgIT6/UGCpJSJ4BH5LftdODLdA2uvI8O547j5hcqX9uT4bK8SGNV93I8flb9F+ZKl4SxLkYLMtd9gLXokDJ3tyhQ/ZAS2sDpqnOLUGvTktPi7RUvSWVYLAOWkIP6Q4dpnAATcISPn1T4S+5QlOueU1Yg8rKppe75jakvtdshIiF+3OJY7DdmxTxo+38w+QxG9SyehCkQkO9pKR2jHcmnSeRinqWTAfZXoSQYoe6g5i4rVHAT9eYIGAKZlgdPxtGDf7kjYIrlmNcFpwxaFS/Mpn7NYob1anlac/2tT7Ry3MfRgn/F
 gctTPJq8
 a4cmsEl7T5L4xQ2LXG4x2KJDpbuVee7ldoJk6Hyw6V64tshVgGZ7+g6Iy8IuucPDz3Y20UyF5vKZspiuoAT5L8O+hl3/o4NhRdxyZFDkigB2F/cCYgzatitk+UHIb6+sPNE1h4uB7/JZcetfSoK6aR+BqDzeVFDdAIUGKtG66O86J0z8A5N1crZnJB3Kgf8+jclnLUxwNMaSnMpgkfvQLzLRqjAilb6GE9km/PqyRcaLGBQlorP3DgHdIJOZwDIpVeUT5CpaC79tw7Yj46IAx3LhXFY5WufNmok3qjr/EvWD3lIG6udK36svIY5uJfYd90/j7ePC2ndSVi3O9qXvhZxHkBwLuFVB5SKcSHam4qpQeWLM3UVBK9xCqAhQmu9UWyYezn2ma2yPqk3nZxeS4WfXWL4xUjfekN55avj76326NXmDe8KmpC66T7nuFuIg1DgVlKg4Q2uLRXODjWhSQLArQ87y72I5vIkrUa/hnuVrKU0VXqLPKTLKMHQ1RbLkjqbuXYmhbkpEeLSI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 5:18=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 08, 2026 at 11:28:11AM -0700, Kanchana P. Sridhar wrote:
> > When storing a folio in zswap, save the folio's node id in the zswap
> > entry instead of relying on the zswap_entry being allocated on the same
> > node. This enables optimizations such as batch allocation of zswap
> > entries for large folios using kmem_cache_alloc_bulk() that does not
> > support specifying a node id.
> >
> > The size of the zswap_entry remains unchanged as 'referenced' is lumped
> > in with the 'length' (as it doesn't need a full unsigned int anyway).
> >
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> > ---
> >  mm/zswap.c | 23 +++++++++++------------
> >  1 file changed, 11 insertions(+), 12 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index ca513a9f89e3..c2731d3acb2c 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -194,6 +194,7 @@ static struct shrinker *zswap_shrinker;
> >   *              writeback logic. The entry is only reclaimed by the wr=
iteback
> >   *              logic if referenced is unset. See comments in the shri=
nker
> >   *              section for context.
> > + * nid - NUMA node id of the page for which this is the zswap entry.
> >   * pool_idx - id of the zswap_pool that the entry's data is in.
> >   * handle - zsmalloc allocation handle that stores the compressed page=
 data
> >   * objcg - the obj_cgroup that the compressed memory is charged to
> > @@ -201,8 +202,11 @@ static struct shrinker *zswap_shrinker;
> >   */
> >  struct zswap_entry {
> >       swp_entry_t swpentry;
> > -     unsigned int length;
> > -     bool referenced;
> > +     struct {
> > +             unsigned int length:31;
> > +             bool referenced:1;
> > +     };
> > +     int nid;
>
> This will increase the size of the struct now with pool_idx, right?

I was gathering the struct size with the struct {unsigned int
length:31; bool referenced:1} as suggested in v14, for my before/after
comparisons:

before:
struct zswap_entry {
        swp_entry_t                swpentry;             /*     0     8 */
        struct {
                unsigned int       length:31;            /*     8: 0  4 */

                /* Bitfield combined with next fields */

                bool               referenced:1;         /*    11: 7  1 */
        };                                               /*     8     4 */
        int                        nid;                  /*    12     4 */
        u8                         pool_idx;             /*    16     1 */

        /* XXX 7 bytes hole, try to pack */

        long unsigned int          handle;               /*    24     8 */
        struct obj_cgroup *        objcg;                /*    32     8 */
        struct list_head           lru;                  /*    40    16 */

        /* size: 56, cachelines: 1, members: 7 */
        /* sum members: 49, holes: 1, sum holes: 7 */
        /* last cacheline: 56 bytes */
};

after:
struct zswap_entry {
        swp_entry_t                swpentry;             /*     0     8 */
        struct {
                unsigned int       length:31;            /*     8: 0  4 */

                /* Bitfield combined with next fields */

                bool               referenced:1;         /*    11: 7  1 */
        };                                               /*     8     4 */
        int                        nid;                  /*    12     4 */
        long unsigned int          handle;               /*    16     8 */
        struct obj_cgroup *        objcg;                /*    24     8 */
        struct list_head           lru;                  /*    32    16 */
        u8                         pool_idx;             /*    48     1 */

        /* size: 56, cachelines: 1, members: 7 */
        /* padding: 7 */
        /* last cacheline: 56 bytes */
};

And decided to go with the placement in patch 7, since it also
separates out members by compress/decompress path accesses. pool_idx
is set once, and never changes. Further, moving pool_idx to the end
gets rid of holes.

>
> Before you patch on x86_64:
>
> struct zswap_entry {
>         swp_entry_t                swpentry;             /*     0     8 *=
/
>         unsigned int               length;               /*     8     4 *=
/
>         bool                       referenced;           /*    12     1 *=
/
>         u8                         pool_idx;             /*    13     1 *=
/
>
>         /* XXX 2 bytes hole, try to pack */
>
>         unsigned long              handle;               /*    16     8 *=
/
>         struct obj_cgroup *        objcg;                /*    24     8 *=
/
>         struct list_head           lru;                  /*    32    16 *=
/
>
>         /* size: 48, cachelines: 1, members: 7 */
>         /* sum members: 46, holes: 1, sum holes: 2 */
>         /* last cacheline: 48 bytes */
> };
>
> After:
>
> struct zswap_entry {
>         swp_entry_t                swpentry;             /*     0     8 *=
/
>         struct {
>                 unsigned int       length:31;            /*     8: 0  4 *=
/
>
>                 /* Bitfield combined with next fields */
>
>                 bool               referenced:1;         /*    11: 7  1 *=
/
>         };                                               /*     8     4 *=
/
>         struct {
>                 unsigned int               length:31;            /*     0=
: 0  4 */
>
>                 /* Bitfield combined with next fields */
>
>                 bool                       referenced:1;         /*     3=
: 7  1 */
>
>                 /* size: 4, cachelines: 1, members: 2 */
>                 /* last cacheline: 4 bytes */
>         };
>
>         int                        nid;                  /*    12     4 *=
/
>         u8                         pool_idx;             /*    16     1 *=
/
>
>         /* XXX 7 bytes hole, try to pack */
>
>         unsigned long              handle;               /*    24     8 *=
/
>         struct obj_cgroup *        objcg;                /*    32     8 *=
/
>         struct list_head           lru;                  /*    40    16 *=
/
>
>         /* size: 56, cachelines: 1, members: 7 */
>         /* sum members: 49, holes: 1, sum holes: 7 */
>         /* last cacheline: 56 bytes */
> };
>
> I think we want to reorder the fields. We can probably also avoid the
> bitfield if the maximum page size is 64K (is it?)

It seems on ARM64, the max page size is 64K, however on PPC, it can be
256K. So it appears we need at least 18 bits on currently supported
architectures.
If you agree with the pool_idx placement to be moved to the end as
proposed in patch 7, I can try and optimize this further, by limiting
the "unsigned int length:18", if you think this makes sense.

>
> struct zswap_entry {
>         swp_entry_t                swpentry;             /*     0     8 *=
/
>         u16                        length;               /*     8     2 *=
/
>         u8                         pool_idx;             /*    10     1 *=
/
>         bool                       referenced;           /*    11     1 *=
/
>         int                        nid;                  /*    12     4 *=
/
>         unsigned long              handle;               /*    16     8 *=
/
>         struct obj_cgroup *        objcg;                /*    24     8 *=
/
>         struct list_head           lru;                  /*    32    16 *=
/
>
>         /* size: 48, cachelines: 1, members: 8 */
>         /* last cacheline: 48 bytes */
> };
>
>
> >       u8 pool_idx;
> >       unsigned long handle;
> >       struct obj_cgroup *objcg;
> > @@ -672,14 +676,8 @@ static int zswap_enabled_param_set(const char *val=
,
> >  * lru functions
> >  **********************************/
> >
> > -static inline int entry_to_nid(struct zswap_entry *entry)
> > -{
> > -     return page_to_nid(virt_to_page(entry));
> > -}
> > -
> >  static void zswap_lru_add(struct zswap_entry *entry)
> >  {
> > -     int nid =3D entry_to_nid(entry);
> >       struct mem_cgroup *memcg;
> >
> >       /*
> > @@ -696,19 +694,18 @@ static void zswap_lru_add(struct zswap_entry *ent=
ry)
> >       rcu_read_lock();
> >       memcg =3D obj_cgroup_memcg(entry->objcg);
> >       /* will always succeed */
> > -     list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
> > +     list_lru_add(&zswap_list_lru, &entry->lru, entry->nid, memcg);
> >       rcu_read_unlock();
> >  }
> >
> >  static void zswap_lru_del(struct zswap_entry *entry)
> >  {
> > -     int nid =3D entry_to_nid(entry);
> >       struct mem_cgroup *memcg;
> >
> >       rcu_read_lock();
> >       memcg =3D obj_cgroup_memcg(entry->objcg);
> >       /* will always succeed */
> > -     list_lru_del(&zswap_list_lru, &entry->lru, nid, memcg);
> > +     list_lru_del(&zswap_list_lru, &entry->lru, entry->nid, memcg);
> >       rcu_read_unlock();
> >  }
> >
> > @@ -1449,9 +1446,10 @@ static bool zswap_store_page(struct folio *folio=
, long index,
> >  {
> >       swp_entry_t page_swpentry =3D folio_swap_entry(folio, index);
> >       struct zswap_entry *entry, *old;
> > +     int nid =3D folio_nid(folio);
> >
> >       /* allocate entry */
> > -     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
> > +     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, nid);
>
> We don't need to allocate the entry on the same node anymore, should we
> drop this and let the slab allocator handle it as it sees fit?

Was this a recent change? I see the folio_nid(folio) on my version of
mm-unstable as of 10-3-2026. Let me check, and yes, allowing the slab
allocated handle this is probably a good idea.

Along the same lines, I have been working on replacing zsmalloc with
direct SLAB allocations for the zswap compressed data storage and see
very promising results: memory savings and latency improvements. I
will submit an RFC shortly.

>
> >       if (!entry) {
> >               zswap_reject_kmemcache_fail++;
> >               return false;
> > @@ -1466,6 +1464,7 @@ static bool zswap_store_page(struct folio *folio,=
 long index,
> >        * to an unrelated live pool.
> >        */
> >       entry->pool_idx =3D pool->idx;
> > +     entry->nid =3D nid;
> >
> >       old =3D xa_store(swap_zswap_tree(page_swpentry),
> >                      swp_offset(page_swpentry),
> > --
> > 2.39.5
> >

