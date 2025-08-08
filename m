Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36BCBC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 23:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C66196B00A0; Fri,  8 Aug 2025 19:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16416B00A1; Fri,  8 Aug 2025 19:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B05116B00A2; Fri,  8 Aug 2025 19:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B7DD6B00A0
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:37:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51C49BA009
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 23:37:29 +0000 (UTC)
X-FDA: 83755204218.14.8514805
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 67C81A0002
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 23:37:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iGtaYw5Y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754696247; a=rsa-sha256;
	cv=none;
	b=iuYYjodpyhsgjaOihjBLrYBQ/GMJCBGKF4RMubBexTK8MCry5B4D/zkdZwXoA5MTBtPAB0
	iCxAcnAR2KtCY4i+vKhXVnLuc7jy2UpYJ0UIY7lTs2ghKVQQ3gR9uIpckNGMp+wIbXVv81
	2r63Ok2EHxFpOq8naO+uj+IRvLGDuH4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iGtaYw5Y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754696247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FwyZ0i04JHUSsV1rR+O18SvC1OtKGn9TQc4x0d/NlkM=;
	b=ye39rz9jn/5sQlawS0yeD7QPNTaCXolWiMSYCUpFDeyqRZ3bAO87x93XUThBvlf4VaMpLM
	xSdJgRZD0eJemD1p/a5gh/hGkRAw0UWt2JhGhjstz7ZHKTUy52WLGKPbCR268pz3LEsAvX
	xKiDcdfQQPCgljfh/MYxODH3cBXZUw8=
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-875dd57d63bso71612539f.0
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 16:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754696246; x=1755301046; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FwyZ0i04JHUSsV1rR+O18SvC1OtKGn9TQc4x0d/NlkM=;
        b=iGtaYw5YgLq46y5ujA1dpPuRLPwAyu0L15FPUsJYm6K5nFTx2q0ilx18Ot0Mxd7TA3
         jlo316bViUeBGvD3ZlGMDhUT+bCfXWC6Of+DR8GgYuQvrboRAfsBe3uhEhNBlclXzAqZ
         /6nScWytGn8ToENF3J3Pr8cWO91YvF0KAkfD3EdBgWU7AnFcGwWttlYhhuqZUws6X250
         Ojlzs9omJrqJ6uvZqho/OYQZAXaA96Xpl7++nFuD/6knSPf3acdR2fRw9LdydXsdydwm
         xuRLgjcHVjAP6POXtTczFKTgCBOxYdsJVk1IRKcIUcU/FpTPelPcOgABnhVyFPWo2G0/
         KpWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754696246; x=1755301046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FwyZ0i04JHUSsV1rR+O18SvC1OtKGn9TQc4x0d/NlkM=;
        b=RoWWXAUGxwKUesp3LNJ4X+WYZKD1h+tjfRREz9d/BPoQ9TCc8+NgeUYIRdR2Aa3Bf5
         t+g78+2MgkOqk6f8hmDADOamOqJsc8nTBIhwOrxyhlSBz3tlEfGXzh5oD/DpHMe3sqwr
         0gTvv6WJiAU+6u+AQoGqRkPZbJ1QhnvT1L90J7hWXSYqu8qjKO8qZc3nZ+jdC2CAkF1l
         xD/rcTUdSmUJ1tNEoReSC/VtOEEPon4eZj/Zhw/fDSt4HXgWD326/lkA6E/6HzqfYOsy
         TAuIR7GuQkYUXDOIlAYkvt1wTGy6IfH4cN4Ex0tfu/vRCFmAHMIgS9yBBRJnf0wCN5kt
         YQvg==
X-Forwarded-Encrypted: i=1; AJvYcCWSZtkBOnWFYUZhSjY0HpsaZ0wiecxCMRIBF32fT4rhVGMe7WSSSOkxbWX7E26slC816lwqZIx2jw==@kvack.org
X-Gm-Message-State: AOJu0YyGAnOQuGO25l9R18TmqnRRBASRSg5ZjPTj5QmmOXPQY2I4FhXj
	h7qhCLcvjVE25gH0Egc/oo/Q3dfV+lh5GKoRPh5XkPpOCk+geqR1QyfrqjjTh5H32XtUOF7mMcT
	I/uM8z1e2M9LRu4g+0vk5x2WpddGzBSM=
X-Gm-Gg: ASbGnctJAQQtNabYYIDfH0KLCqqhngnQIHO1/MrwKfLW+rNs2WE4qgjoHzbrEHdyhA/
	EWqofo8ntHzJGUghqr8BqhTYOHdTVCjOGxZYQzV/9oB+cXVkIhtC3v9udIyj9anprZcD7SxGP6k
	DqXTooTqR7q/YCfeXK4OhEcCEc+HP/gE41ke+WFqIoWKZaKTz4JklO7XaLn4mCQQ4J94NOpN/75
	/20t0g=
X-Google-Smtp-Source: AGHT+IHLaEoTMjMD8pdwPzFLh1E6zMxTpQjSGEy4GPemYztcQ4b1SGs4adIr7g5CA0pDGINZG+M/dm9yG96sxIMnffI=
X-Received: by 2002:a05:6602:2cd6:b0:881:8957:d55e with SMTP id
 ca18e2360f4ac-883e4b1921amr1453030539f.3.1754696246284; Fri, 08 Aug 2025
 16:37:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=Nm08xZVR0Zk2fOvXBmeWe5wggvTXN6+hD84S7T9L=eBQ@mail.gmail.com>
 <20250807235427.4743-1-sj@kernel.org>
In-Reply-To: <20250807235427.4743-1-sj@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 8 Aug 2025 16:37:15 -0700
X-Gm-Features: Ac12FXwa-g5rKO_VKfSLJneuBpYcraR2f6GUwJhc5UzCuPKjdW3Oppb4-OVWFbg
Message-ID: <CAKEwX=NF-HBs_sMMm5v82SHFnv5SUrNjOR-=6KJcxQsNt=26Rw@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 67C81A0002
X-Stat-Signature: bypa5z5aka9j4x1mp5ahi5675en4g579
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754696247-369326
X-HE-Meta: U2FsdGVkX1/lP3az6JomFuLEldtDEjxMQp21PRYfWYRM1rgh5x0XreKBKptgxoVy+yhFQtw7XsQMre476pcWTquTAW+J+XyDH3L2FmqnsoHK5/4sSEyNb4W0LA4sTJcfGN5X7gdQgxJqMdQLbNTde3TU3q2KqNLdW9+oEw1BkGlqVR9qmPLSYGopRbm6wSA45rVkxp7BGvvRC6dbb3QbQNJSYs2r49o9veNZ1q4OpiJEkmRVGI+ZpgyCK7MN0X6PGla9EBIL0iKHyorICDMdQ2G6RrGLZLCLNlKRPLI3sAv2yXicfC0GZWe4c9Bu0tWGBqwEX/oHHcVgT0GgT62olYR3ZPAJFBRaw3qZKP+bc5A+kkVF4MLmM9K6zWpsuq1qhHk3DQu+2qEvO53NpuKB/lceBTv9bLdwXTw85pC9FQgcnxMromQv8VDyi5ePaAZziHnKneB0oSnRdRICdhb4fV9ofhsm6w4KpX4K8fNwMRuZtY+WOtlDwI3ga7tt9EcgeIClQtmXppGOfEoujg8PNbWkg7VP377Y/bfZDdr6v6sjieSK0cGCkOeaaCUtSYBSt9c6BPYcf5u8fVqjoqC2Nyy2cuLyyrA3e2PtGoszC/47oZDCuwBx80jlkOAISESMCXlUfky0fmKJGRoKKZsaGK013wv/ONNgtM00BKCWmvv4D8wQzQsnC/0Ojtl1Z/FDxZyQkQGCJ0ZkUKyasyrfbgK8VK23v5MGmoB5yJWVquJMzJ9GsY9zuPWtO8iIAy251a8eF/2KW7bYI3fcfxEPiorx8EskbE8o6TRU5SosNUt56Y3fbhZGPfwyM2osZUFTpB9suj3+lAIKMNq7/H2DpnA+hHovtMYqtfoMcanO0DhOOV8pFyzM1fHeK8aRqNbqJRjtFJNG8iTKWfjIpYCrjepRDieFYdgUDWIlVG/2WAOtme56LQQi/QVLpWLGFS9/VuPqWd1vSSkM8QVp5dD
 roeICYZL
 9plcytm6LOQE1ZUqG0saZuF+JnO5GBXcgatXaW52vOBqthVyKcmgFMT+CdRWnkpomZV0EFmmvHzzuqEG52Z8cgKPXRhNo/lRPTW6E8Me21xRi6iEhVh/M+PIMAwtkKJOt4441bpd8amGxk83VtiLh53z2xP1wydXmiRyZtXLQ+e6K3evU+ETYevcc3leNGDXiq0uUHw5Lz/1RDms9kKkJdVDdr9Tmbxd15PlvTVPfCDZTiG+P8LV1dVv+Svygv/WXgSwRgDMpzI/PayUSJoYrbafsgESCBEyrLdHaBuxLAkSG6CTYp02YVbWkPQyjBAAVh3QOEz3Ru8NF7sb72cAICHwU4SFAGeZTY4JvYnk8KKuKHavzcH8tXG79R794TxvBJ37CiLFWmQVXw4UALUMK4rIE1R1S21kNZ9TZxI2lNe/ozO06WekOoRFMBZM/2at11F8pAmZNnpycYbE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 7, 2025 at 4:54=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote:
>
> On Thu, 7 Aug 2025 16:03:54 -0700 Nhat Pham <nphamcs@gmail.com> wrote:
>
> > On Thu, Aug 7, 2025 at 11:16=E2=80=AFAM SeongJae Park <sj@kernel.org> w=
rote:
> > >
> > > When zswap writeback is enabled and it fails compressing a given page=
,
> > > the page is swapped out to the backing swap device.  This behavior
> > > breaks the zswap's writeback LRU order, and hence users can experienc=
e
> > > unexpected latency spikes.  If the page is compressed without failure=
,
> > > but results in a size of PAGE_SIZE, the LRU order is kept, but the
> > > decompression overhead for loading the page back on the later access =
is
> > > unnecessary.
> >
> > Maybe add the writeback disabled story - we added to get around this
> > latency issue, but that solution was not satisfactory either: wasting
> > cpu cycles retrying incompressible pages, especially when we're under
> > reclaim/memory pressure, and we've reclaimed most if not all other
> > sources.
> >
> > This problem was pointed out by Yosry:
> >
> > https://lore.kernel.org/all/CAJD7tkZXS-UJVAFfvxJ0nNgTzWBiqepPYA4hEozi01=
_qktkitg@mail.gmail.com/
>
> Thank you for sharing the detailed context, I will add this history with =
the
> link to the last paragraph of this section, or the 'Related Works' sectio=
n.
>
> >
> > >
> > > Keep the LRU order and optimize unnecessary decompression overheads i=
n
> > > those cases, by storing the original content as-is in zpool.  The len=
gth
> > > field of zswap_entry will be set appropriately, as PAGE_SIZE,  Hence
> > > whether it is saved as-is or not (whether decompression is unnecessar=
y)
> > > is identified by 'zswap_entry->length =3D PAGE_SIZE'.
> > >
> > > Because the uncompressed data is saved in zpool, same to the compress=
ed
> > > ones, this introduces no change in terms of memory management includi=
ng
> > > movability and migratability of involved pages.
> > >
> > > This change is also not increasing per zswap entry metadata overhead.
> > > But as the number of incompressible pages increases, total zswap
> > > metadata overhead is proportionally increased.  The overhead should n=
ot
> > > be problematic in usual cases, since the zswap metadata for single zs=
wap
> > > entry is much smaller than PAGE_SIZE, and in common zswap use cases
> > > there should be a sufficient amount of compressible pages.  Also it c=
an
> > > be mitigated by the zswap writeback.
> > >
> > > When the writeback is disabled, the additional overhead could be
> > > problematic.  For the case, keep the current behavior that just retur=
ns
> > > the failure and let swap_writeout() put the page back to the active L=
RU
> > > list in the case.  It is known to be suboptimal when the incompressib=
le
> > > pages are cold, since the incompressible pages will continuously be
> > > tried to be zswapped out, and burn CPU cycles for compression attempt=
s
> > > that will anyway fails.  One imaginable solution for the problem is
> > > reusing the swapped-out page and its struct page to store in the zswa=
p
> > > pool.  But that's out of the scope of this patch.
> > >
> > > Tests
> > > -----
> [...]
> > > --- a/mm/zswap.c
> > > +++ b/mm/zswap.c
> > > @@ -976,8 +976,25 @@ static bool zswap_compress(struct page *page, st=
ruct zswap_entry *entry,
> > >          */
> > >         comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx-=
>req), &acomp_ctx->wait);
> > >         dlen =3D acomp_ctx->req->dlen;
> > > -       if (comp_ret)
> > > -               goto unlock;
> > > +
> > > +       /*
> > > +        * If a page cannot be compressed into a size smaller than PA=
GE_SIZE,
> > > +        * save the content as is without a compression, to keep the =
LRU order
> > > +        * of writebacks.  If writeback is disabled, reject the page =
since it
> > > +        * only adds metadata overhead.  swap_writeout() will put the=
 page back
> > > +        * to the active LRU list in the case.
> > > +        */
> > > +       if (comp_ret || dlen >=3D PAGE_SIZE) {
> > > +               if (mem_cgroup_zswap_writeback_enabled(
> > > +                                       folio_memcg(page_folio(page))=
)) {
> > > +                       comp_ret =3D 0;
> > > +                       dlen =3D PAGE_SIZE;
> > > +                       memcpy_from_page(dst, page, 0, dlen);
> >
> > I wonder if we can save one memcpy here. Would it be safe to map the pa=
ge:
> >
> > dst =3D kmap_local_page(page);
>
> Sounds good, I will do so in the next version.
>
> >
> > then, after we're done with storing (i.e after zpool_obj_write()), do:
> >
> > if (dlen =3D PAGE_SIZE)
> >     kunmap(dst);
> >
> > (don't forget to unmap the page in the failure paths too!)
>
> Sure, I think the 'unlock' label would be appropriate part to add the unm=
ap
> code.  I also got your correction of s/kunmap/kunmap_local() in the reply=
.  I
> will not miss that on the next version.
>
> >
> > > +               } else {
> > > +                       comp_ret =3D comp_ret ? : -EINVAL;
> >
> > Does this keep the value of comp_ret if comp_ret !=3D 0 lol.
>
> Yes.
>
> > Syntax
> > looks weird to me.
>
> I agree it could look weird.  I prefer keeping the code in a way more fam=
iliar
> to ones who will keep maintain the file.  So I will modify this as below,=
 in
> the next version.
>
>     comp_ret ? comp_ret : -EINVAL
>
> >
> > > +                       goto unlock;
> > > +               }
> > > +       }
> >
> > Also, can we fix the counter value?
> >
> > I assume we want:
> >
> > else if (comp_ret || dlen =3D PAGE_SIZE)
> >      zswap_reject_compress_fail++;
> >
> > or something like that.
>
> I'm not very clearly getting your point.
>
> I was thinking we should increase the counter if we "reject" the page (do=
es not
> save the content in the zpool) due to failing at compressing the page's c=
ontent
> into a size smaller than PAGE_SIZE.  This patch implements the behavior.
>
> Am I missing a mis-implementation of the behavior in this patch, or the
> behavior is not what you think it should be?  More elaboration of your po=
int
> would be helpful for me.

Ah yeah, maybe "reject compress fail" is not a good name here. But
sometimes I like to know how many times we fail to compress, even if
we do save them.

We can rename it to just "zswap_compress_fail", but that's breaking
API, so it's kind of annoying. Maybe "zswap_stored_uncompressed_pages"
suffices (see comment below).

Johannes, any suggestions on what to do here?

>
> >
> > And what happened to the incompressible page stored counter? :)
>
> I don't get what counter you are asking about.  Could you please elaborat=
e?

I meant "zswap_stored_uncompressed_pages" in your RFC v1.

That could give us a nice breakdown of how much memory in zswap is
actually compressed memory, and how much is uncompressed.

>
> >
> >
> > >
> > >         zpool =3D pool->zpool;
> > >         gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MO=
VABLE;
> > > @@ -1012,6 +1029,14 @@ static bool zswap_decompress(struct zswap_entr=
y *entry, struct folio *folio)
> > >         acomp_ctx =3D acomp_ctx_get_cpu_lock(entry->pool);
> > >         obj =3D zpool_obj_read_begin(zpool, entry->handle, acomp_ctx-=
>buffer);
> > >
> > > +       /* zswap entries of PAGE_SIZE are not compressed. */
> > of length?
>
> Thank you for this nice suggestion, I will change the comment so, in the =
next
> version.
>
> >
> >
> > > +       if (entry->length =3D PAGE_SIZE) {
> > > +               memcpy_to_folio(folio, 0, obj, entry->length);
> > > +               zpool_obj_read_end(zpool, entry->handle, obj);
> > > +               acomp_ctx_put_unlock(acomp_ctx);
> > > +               return true;
> > > +       }
> > > +
> > >         /*
> > >          * zpool_obj_read_begin() might return a kmap address of high=
mem when
> > >          * acomp_ctx->buffer is not used.  However, sg_init_one() doe=
s not
> > >
> > > base-commit: 2ec534125ae474292175ae198483c545eac2161d
> > > --
> > > 2.39.5
> >
>
> Thank you for your nice review and comments :)
>
>
> Thanks,
> SJ

