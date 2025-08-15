Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2881FCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 23:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3BA56B0379; Fri, 15 Aug 2025 19:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C14146B037A; Fri, 15 Aug 2025 19:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B29596B037B; Fri, 15 Aug 2025 19:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9FBCC6B0379
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:09:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1FD1F58601
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:09:06 +0000 (UTC)
X-FDA: 83780534292.05.8498CF9
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2D80F10000A
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:09:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eoUvgjqj;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.181 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755299344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=42MdIw/zn0IyOrePf8q8Yhtrpa4xzlqA2mTCVTQGHKI=;
	b=jRoygBisADH982z4Hd8gioWk/PRNSWH1f2JyzwNZ5peI1t4JOWkGVGzqL+4TIS03R3o/A7
	SCAZj2F3NKaq51caVpFMlD59JwPv0dwd6Zh9WeMgkh2yNRKLb7OLwwSPvuK/xV4fKg8WLy
	Efk9wpK9TxKAlb6oMReGpVANihb8DOM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755299344; a=rsa-sha256;
	cv=none;
	b=kD8NoAzaVUzf3fVDJvDVKJF8HoPNRl7dohnmpOqSTbOuygHtrjssWLfiXx2sqlR7Rv/4yZ
	K3U+VQqyDwBBG+gIsvj7XbDkowjefq4apEvwZBDUvJB/Qd/DxmbQDv076+GbPJfTXxHEW1
	MqNECSLdY1XgqNIrjbu9GdQnZo4EDSk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eoUvgjqj;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.181 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3e57002bc23so11393485ab.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755299343; x=1755904143; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=42MdIw/zn0IyOrePf8q8Yhtrpa4xzlqA2mTCVTQGHKI=;
        b=eoUvgjqj3xxblqPThcnCkt48gGV391pJBdCjxF2TtZgeoMzLEg/OzFLUX8oGaYBqjm
         CCucr1jqGtQyBbOBiyp2GGab4emRu5KXCuV82cYRXJFEm0n6RHoENaXfKwSpWV3hOPav
         LLDwJWhnt/c3BXW+HX7BJxldwzjlCcH+h+h3qZA9YVuRuLYhdmXTd3G6CWEDEfe9PSF2
         aaO7l9E5EggUJh3OM3rfXRAiUDMX9hgecQyM6XXmnElQGpUd7YPG6/jx0QN53GGjpAXj
         qGXkAfxb1DtDC1y4jh717YP8cAOP86HbXvlw7LbQoc6Gw0HH7iqIOzABNhpxVqyQ5KmI
         6M4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755299343; x=1755904143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=42MdIw/zn0IyOrePf8q8Yhtrpa4xzlqA2mTCVTQGHKI=;
        b=g+B9Ah8uDZk0gJtCkGtScLeVy3moCQJ7q2wehPNtsBPQ3UokKp27zcU2LYiWUYV0bR
         LJgwKLMR1IxjCwyHs6jc9E9yaY9cniGYL2sdfvpwdsris3xCLkTMLnIWo4i3Vzt9w9o9
         kzUeKQxkXaJhxbEk6kyX0QnLXvggt5Zp4SwfYGVT3BlewEXUVT6mrmtPy887QSi2RkDh
         aeOoXVZZQ8M54Qss/BxyzhjPT9oqsN1RhT7YumUKgsKtz63NzaJL4og1ep0OHfT4xv2m
         PTl/3IcjpODNGLXYDO/+ozVAtYeG3ywzBREUfg9JGdyGu+0JCBni0uXiBSh81MZAooSV
         lOeA==
X-Forwarded-Encrypted: i=1; AJvYcCVepHQIfrubriagewUZEA18ch26S1T/ms2Zs6BTLcoQnR7drLb30+Mlq8+HbgfcjfV3MawT+lf/sg==@kvack.org
X-Gm-Message-State: AOJu0YzFblF5hebvBggzGYlfWjG9WPsUMqP1tuO3qA8Pr9uBPcH7TssA
	gqiGij8NqGvMBk6eSZslQeh3MlH6poY74hsDhIPeA/vdd1wFI+wnwlpe/Kp7JADP8lisnndKWDr
	E5fvcpHxFhwpG1ZcwmaGVreoE32uu1bM=
X-Gm-Gg: ASbGncsRrhc9/VDiyaqCyIVKM0hp11sRer79bKiIS51flEMW3lYK0NfcPuk8zvprL5U
	2qO5FB+VnF4dxtgXz4C7UuhT+o/UAcKvZ3QlCrcmESOhvImC91nFQYfSF+VaXMYakzgKyXoGuUN
	i1oW2tVftKPsatSm/nmzKuM4G+uQt5rVcjiKu9/XdJoVUp97sL/6CDzykWZb/QprWBL8uM/kAFu
	e2EIoI=
X-Google-Smtp-Source: AGHT+IFthbpENU4cR1d+wIfUd2fLqa+M/nb9eoAPF87b/fD4gwDKKoQlmFeYW/ZUpK51HaqrMW1FTYZD29CTtYda3is=
X-Received: by 2002:a05:6e02:1b05:b0:3e5:6bc6:4dcf with SMTP id
 e9e14a558f8ab-3e57e8670damr67303825ab.7.1755299343025; Fri, 15 Aug 2025
 16:09:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAF8kJuN1BH0rqC6czj9govNOugd_5K9ijYcxbWYpEpUdQKn0-A@mail.gmail.com>
 <20250813182024.7250-1-sj@kernel.org> <CAF8kJuONDFj4NAksaR4j_WyDbNwNGYLmTe-o76rqU17La=nkOw@mail.gmail.com>
In-Reply-To: <CAF8kJuONDFj4NAksaR4j_WyDbNwNGYLmTe-o76rqU17La=nkOw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 15 Aug 2025 16:08:50 -0700
X-Gm-Features: Ac12FXyPKTgQ73WeJtuawZdGdFJidghULGlU1JeYubHbQaLPPy9GQfXReZwelH4
Message-ID: <CAKEwX=Mtu3KyNUv_oWFo9vNiWKkmbzMXmG3t=XgpVtG9C_v2mA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: Chris Li <chrisl@kernel.org>
Cc: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2D80F10000A
X-Stat-Signature: iakpic55q36dteij6a5i43ktdkax9m7x
X-HE-Tag: 1755299343-244060
X-HE-Meta: U2FsdGVkX1+koaZLDOhvvuaOMn94dYUdTEt/eiTxgZHfDHjlBe7aIaoYyNxd3T76tUkE8blB+ClFPznsf2/UTvmkq0m4142bLnPNagss8iRYx7T++AVjL4FPNWQSU7DeU1JQ/fRyaDLSUBqp9h97lTz1g7KOQFJ2lh3Z0LQfXAy4sHYvzoU8CHfX82mqZJIyZBkB60YIWHXlMIiCi1i+R7e+JuRZBJstk93N5fyAUvuNVOJ5+m8DcCTOJo61+XGVw0qGbuzNeXFTY2/rXKRSyt5/N2ydVg3XKYelJZCTMB3kV4luaKtNpXeoRY/03yeObxWdRhYn72/5SxJmzK6TOSdQuwZLc5+8QeyY8Y4pIzq2o2CPhE2qB8np6nVQEHteCxTwc8HPBsF9Rw8+kn0RiN9JZU+AsX3jcmcOi2ErWItq2L5o+n955qKs5HKIjgfx9ZZ4Aj+UP/ZwKbYg2cXveG813qYe+wQI6KP8iuQPHa4Jlz2i3+8vY/UKAe6P/Ss47YkZR9sFNn+pt72cScr2GQ+M/fxjwx2x+bQOPOJYWVaQnSmjnWf++xzlyw+TNWmUlG7syOidDqSDSGUVMmRKDi/NjfN9a2jWvejnUe+OMQ6uZyQALBuLElBTMTsvZB2PtjqheirrQ2ubV0B5qIuA7PYMbHWFMJBlSMUF54rsm1sYHWFEwqau6PTo82K/yPxKvkR3oZxA/Rc112YYIdytQzVXYjZKc+w60n5jT8kMehheGF190kBmOesHgXdChIsj6YG831CbgTh7DPp7oSnff2gj7jmu0vPgH71iZv/3a17L++ukyi9qMFHczOqtbjItmkFEYP/TuzlN8Qs2Amy93O9ASIa5/Dq6Rt/WQSD1Hxxo4xDax+GuYnMh8by+JSLimUSmGPGXKhHCnXtjcQWFJ8fkQhvhfUcJVAH2wf90rFTOiJetRvQrMdBzTxPjzAEWzELArwVJ4wqfu8k++i4
 5JBTIvuJ
 FBMHJFZJsOZtTU1jIWYo0I/0v3afmipq7jZJ/hDSGGaShpo4nDzylAOpAIB9H32OhMlpIswFEyUjVuetjLQIzuPG4nYy33fdoP9/hjLDm+OwpDxeWKiHoRwGtYQ6O0JSSC02ntAIZOuE2aEz6YlkupokSHXM9Kva5n0Mt9zrAtKTP9PD1pUOIHJ1s7Uz6B/npSWJ+13qyHeW+sp5ikw/tkJ7BidDO1FYcilKlQPWuaZMlwMWlLg7gNM9z3WJqBka83R0Ql4OcjTY5cMSuFVdfaGWSLUfZj4CRicCf9CIqpRki6+6SOmvy44DXQjOVd2r7fRUUM5oAI1DedhrJyMZpO447u57P12PuGrX+RX4q2cc0LBZOtBkUc6RX+V9CmDJ7W2tAunasbyb+fp3aBThg0bbgxfJyC+fg8t37
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 3:29=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Wed, Aug 13, 2025 at 11:20=E2=80=AFAM SeongJae Park <sj@kernel.org> wr=
ote:
> >
> > My RFC v1[1] was using a kind of such approach.  I changed it to use zp=
ool
> > starting from RFC v2, following the suggestions from Nhat, Johannes and=
 Joshua.
> > It was suggested to use zpool to reuse its support of migration, highme=
m
> > handling, and stats.  And I agree their suggestions.  David also raised=
 a
> > question on RFC v2, about the movability behavior changes[2].
>
> Thanks for the pointer, that is an interesting read.
>
> > I agree we will get more metadata overhead.  Nonetheless, I argue it is=
 not a
>
> Keep in mind that is more than just metadata. There is another hidden
> overhead of using zpool to store your full page compared to directly
> using the page.  When the page is read, because most likely the zpool
> back end is not at a position aligned to the page. That zpool page
> will not be able to free immediately, those fragmented zpool will need
> to wait for compaction to free. it.

It's been awhile since I last worked on zsmalloc, but IIRC zsmalloc
handles these pages PAGE_SIZE sized object by just handing out a full
page. I skimmed through zsmalloc code, and it seems like for this
size_class, each zspage just contain one base page?

(check out the logic around ZsHugePage and
calculate_zspage_chain_size() in mm/zsmalloc.c. Confusing name, I
know).

So we won't need compaction to get rid of these buffers for
incompressible pages, at free time. There might still be some extra
overhead (metadata), but at least I assume we can free these pages
easily?

>
> > big problem and can be mitigated in writeback-enabled environments.  He=
nce this
> > feature is disabled on writeback-disabled case.  Next paragraph on the =
original
> > cover letter explains my points about this.
> >
> > >
> > > The pros is that, on the page fault, there is no need to allocate a
> > > new page. You can just move the uncompressed_page into the swap_cache=
.
> > > You save one memcpy on the page fault as well. That will make the
> > > incompressible page fault behave very similar to the minor page fault=
.
> >
> > I agree this can save one memcpy, and that's cool idea!  Nonetheless, t=
his
> > patch is not making the [z]swap-in overhead worse.  Rather, this patch =
also
>
> We might still wait to evaluate the lost/gain vs store the
> incompressible in swap cache. Google actually has an internal patch to
> store the incompressible pages in swap cache and move them out of the
> LRU to another already existing list. I can clean it up a bit and send
> it to the list for comparison. This approach will not mess with the
> zswap LRU because the incompressible data is not moving into zswap.
> There is no page fault to handle the incompressible pages.

We can always iterate to get the best of all worlds :) One objective at a t=
ime.

BTW, May I ask - how/when do we move the incompressible pages out of
the "incompressible LRU"? I believe there needs to be some sort of
scanning mechanism to detect dirtying right?

>
> > slightly improve it for incompressible pages case by skipping the
> > decompression.  Also, if we take this way, I think we should also need =
to make
> > a good answer to the zswapped-page migrations etc.
>
> Yes, if we keep the store page in the zswap approach, we might have to
> optimize inside zsmalloc to handle full page storing better.

I believe it already does - check my response above. But I can be wrong.

>
> > So, if we agree on my justification about the metadata overhead, I thin=
k this
> > could be done as a followup work of this patch?
>
> Sure. I am most interested in getting the best overall solution. No
> objects to get it now vs later.

Agree. We can always iterate on solutions. No big deal.

>
> >
> > >
> > > The cons is that, now zpool does not account for uncompressed pages,
> > > on the second thought, that can be a con as well, the page is not
> > > compressed, why should it account as compressed pages?
> >
> > I agree it might look weird.  But, in my humble opinion, in a perspecti=
ve of
> > thinking it as zswap backend storage, and by thinking the definition of
> > compression in a flexible way, this may be understandable and not cause=
 real
> > user problems?
>
> I think the real problem is hiding the real error with non errors like
> data not compressible. If you want to store uncompressed data in the
> zswap layer by design, that is fine. Just need to reason the trade off
> vs other options like store in swap cache etc.
>
> > [...]
> > > >  mm/zswap.c | 36 ++++++++++++++++++++++++++++++++++--
> > > >  1 file changed, 34 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > > index 3c0fd8a13718..0fb940d03268 100644
> > > > --- a/mm/zswap.c
> > > > +++ b/mm/zswap.c
> > > > @@ -60,6 +60,8 @@ static u64 zswap_written_back_pages;
> > > >  static u64 zswap_reject_reclaim_fail;
> > > >  /* Store failed due to compression algorithm failure */
> > > >  static u64 zswap_reject_compress_fail;
> > > > +/* Compression into a size of <PAGE_SIZE failed */
> > > > +static u64 zswap_compress_fail;
> > > >  /* Compressed page was too big for the allocator to (optimally) st=
ore */
> > > >  static u64 zswap_reject_compress_poor;
> > > >  /* Load or writeback failed due to decompression failure */
> > > > @@ -976,8 +978,26 @@ static bool zswap_compress(struct page *page, =
struct zswap_entry *entry,
> > > >          */
> > > >         comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ct=
x->req), &acomp_ctx->wait);
> > > >         dlen =3D acomp_ctx->req->dlen;
> > > > -       if (comp_ret)
> > > > -               goto unlock;
> > > > +
> > > > +       /*
> > > > +        * If a page cannot be compressed into a size smaller than =
PAGE_SIZE,
> > > > +        * save the content as is without a compression, to keep th=
e LRU order
> > > > +        * of writebacks.  If writeback is disabled, reject the pag=
e since it
> > > > +        * only adds metadata overhead.  swap_writeout() will put t=
he page back
> > > > +        * to the active LRU list in the case.
> > > > +        */
> > > > +       if (comp_ret || dlen >=3D PAGE_SIZE) {
> > > > +               zswap_compress_fail++;
> > >
> > > I feel that mixing comp_ret and dlen size if tested here complicates
> > > the nested if statement and the behavior as well.
> > > One behavior change is that, if the comp_ret !=3D 0, it means the
> > > compression crypt engine has some error. e.g. have some bad chip
> > > always fail the compression. That is a different error case than the
> > > compression was successful and the compression rate is not good. In
> > > this case the patch makes the page store in zpool for cryto engine
> > > failure, which does not help.
> >
> > I agree the code has rooms to improve, in terms of the readability, and=
 keeping
> > fine grained observailibty.
> >
> > >
> > > Is there any reason you want to store the page in zpool when the
> > > compression engine (not the ratio) fails?
> >
> > The main problem this patch tries to solve is the LRU order corruption.=
  In any
> > case, I want to keep the order if possible.
>
> In that case, does it mean that in order to keep the LRU, you never
> want to write from zswap to a real back end device? That will make
> zswap behave more like a standalone tier.
>
> >
> > >
> > > What do you say about the following alternative, this keeps the
> > > original behavior if compression engines fail.
> > >
> > >      if (comp_ret) {
> > >           zswap_compress_egine_fail++;
> >
> > I agree this counter can be useful.
>
> Ack.
>
> >
> > >           goto unlock;
> >
> > This will make the page go directly to underlying slower swap device, a=
nd hence
> > cause LRU order inversion.  So unfortuately I have to say this is not t=
he
> > behavior I want.
>
> Ack, that is a design choice. I understand now.
>
> >
> > I agree engine failure is not frequent, so this behavior might not real=
ly make
> > problem to me.  But, still I don't see a reason to let the page go dire=
ctly to
> > swap and make LRU order unexpected.
> >
> > >      }
> > >
> > >      if (dlen >=3D PAGE_SIZE) {
> > >         zswap_compress_fail++;
> >
> > I define compress failure here as a failure of attempt to compress the =
given
> > page's content into a size smaller than PAGE_SIZE.  It is a superset in=
cludin.
> > both "ratio" failure and "engine" failure.  Hence I think zswap_compres=
s_fail
> > should be increased even in the upper case.
>
> I slept over it a bit. Now I think we should make this a counter of
> how many uncompressed pages count stored in zswap. Preperbelly as per
> memcg counter.

Actually, yeah I asked about this counter in a review in an earlier
version as well, then I completely forgot about it :)


> I saw that you implement it as a counter in your V1. Does the zsmalloc
> already track this information in the zspool class? Having this per

Kinda sorta. If we build the kernel with CONFIG_ZSMALLOC_STAT, we can
get the number of objects in each size_class.

Each time we read, I believe we have to read every size class though.
So it's kinda annoying. Whereas here, we can just read an atomic
counter? :)

> cgroup information we can evaluate how  much zswap is saving. Some
> jobs like databases might store a lot of hash value and encrypted data
> which is not compressible. In that case, we might just pass the whole

Hmmm actually, this might be a good point. Lemme think about it a bit more.

(but again, worst case scenario, we can send a follow up patch to add
these counters).

> zswap tier as a whole. The overall compression ratio will reflect that
> as well. Having the separate per memcg counter is kind of useful as
> well.
>
> >
> > We can discuss about re-defining and re-naming what each stat means, of=
 course,
> > if you want.  But I think even if we keep the current definitions and n=
ames, we
> > can still get the ratio failures if we add your nicely suggested
> > zswap_compress_engine_fail, as
> > 'zswap_compress_fail - zswap_compress_engine_fail', so we might not rea=
lly need
> > re-definition and re-naming?
>
> I am actually less interested in the absolute failure number which
> keeps increasing, more on how much incompressible zswap is stored.
> That counter + number of engine errors should be perfect.
>
> >
> > >         if (!mem_cgroup_zswap_writeback_enabled(
> > >                                       folio_memcg(page_folio(page))))=
 {
> > >               comp_ret =3D -EINVAL;
> > >               goto unlock;
> > >         }
> > >        dlen =3D PAGE_SIZE;
> > >        dst =3D kmap_local_page(page);
> > >     }
> > >
> > > Overall I feel this alternative is simpler and easier to read.
> >
> > I agree this code is nice to read.  Nonetheless I have to say the behav=
ior is
> > somewhat different from what I want.
>
> Even if you keep the current behavior, you can move the invert the
> test condition and then remove the "else + goto" similar to the above.
> That will make your code less and flatter. I will need to think about
> whether we can assign the return value less.
>
> Another point I would like to make is that you currently make the cut
> off threshold as page size. The ideal threshold might be something
> slightly smaller than page size. The reason is that the zsmalloc has a
> fixed size chuck to store it. If your page is close to full, it will
> store the data in the same class as the full page. You are not gaining
> anything from zsmalloc if the store page compression ratio is 95%.
> That 5% will be in the waste in the zsmalloc class fragment anyway. So
> the trade off is, decompress 95% of a page vs memcpy 100% of a page.
> It is likely memcpy 100% is faster. I don't know the exact ideal cut
> off of threshold. If I had to guess, I would guess below 90%.
>
> >
> > > I can
> > > be biased towards my own code :-).
> > > I think we should treat the compression engine failure separately fro=
m
> > > the compression rate failure. The engine failure is rare and we shoul=
d
> > > know about it as a real error. The compression rate failure is normal=
.
> >
> > Again, I agree having the observability would be nice.  I can add a new=
 counter
> > for that, like below attached patch, for example.
>
> I would love that. Make that per memcg if possible :-)
>
> >
> > [1] https://lore.kernel.org/20250730234059.4603-1-sj@kernel.org
> > [2] https://lore.kernel.org/761a2899-6fd9-4bfe-aeaf-23bce0baa0f1@redhat=
.com
>
> Thanks for the pointer, good read.
>
> Chris

