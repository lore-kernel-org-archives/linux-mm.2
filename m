Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21F80CCD193
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 16:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42D488E00C3; Tue, 14 Oct 2025 12:35:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD6C8E0090; Tue, 14 Oct 2025 12:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5C18E00C3; Tue, 14 Oct 2025 12:35:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1446A8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:35:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A4E2B47898
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:35:38 +0000 (UTC)
X-FDA: 83997270756.26.D4FE228
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id BD2CA10000C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:35:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RNQ2ZbYV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.182 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760459736; a=rsa-sha256;
	cv=none;
	b=Tz3B/LbyOz0t/NBq3Rb0nv9huhaQGMnfiaRjclycKV9wCHUAlwTByIpT1zpYBCnRUeAGAH
	KvhO35CxfdDa8Z4/Y/EiuvMnj9Cl2dTlKD80Jw3Z3Lu+7e/HtJEH0y0E1drUEaOMAwpa+T
	VqYo3oJNAWsQMbw+iSAwUId4i4phIoc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RNQ2ZbYV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.182 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760459736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SqHQ2+KOI4dAk9Brl0lRqwVQjYCUh7n+OdRtoeAkV54=;
	b=mDNTH2XaJ9LdDXd8nKSG9TLUZ/KGl3tyhlSPn/0/kIPvXr67agKpBVRQNyryOotyFVJcLc
	iGLIjpsA4KsWM0uX52n6JNZCyG1HcespL+7sYYtUeJI1cv8dLvOQuXNdEE5I9oHMiNiGv3
	wpb5rrQc9jRhAme+1/XjJkNKOH8+1JI=
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-430ab5ee3afso658275ab.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760459736; x=1761064536; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SqHQ2+KOI4dAk9Brl0lRqwVQjYCUh7n+OdRtoeAkV54=;
        b=RNQ2ZbYVy9p1Wc7yfJjpuW5057vdV6XmMiuFR13zC79P1CQRwM0U7lfLdq/mj340bE
         0TiEYpu1aA1cEmlQ8ihctaq2DoIGkCKLJPDOSaq6o76ZFoZufStzE1DNI75yQZbucX3o
         3LvZ61JrtIr98qMmCl34sheIrsyEye94HrlFX+9NKYuID60xfWkBoBSaEDjZhxCyUr8x
         3MqpZw8Ui0FNZy2331uay2ENxLT3GRSY4rKNAAdeuq3Idwc4xAjBhY8v6EjImyLc5YMI
         dzDMS8Yo6VI02M14mQCgmDMeLlN22VzY0DTIcefyHs0nwt2sZGquebGMdxYU08F83C/T
         flrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760459736; x=1761064536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SqHQ2+KOI4dAk9Brl0lRqwVQjYCUh7n+OdRtoeAkV54=;
        b=sNsf4ukA2jXKGFy8FsOULh1FIvhs06NqLaaFKh2/Fe9gruEecjtc6P0mFbGQ5saSmn
         +49sT/UF6FSd7gBptWmL59XY2DSd3jKn7fZunRS/D+KTbZes9kQ3CdFrwdo/x9/Oh03c
         OBPPjWsHkkR1yH1SjEfde7M8lMFJzZWTF5Rthx9eE7pJt3Vmjs9wY9+p+DMK1bhDDpsM
         RuL0Ixxx0L5g5MnboQsRPRgpdgUVF9kZdHBILZarw0H+LoxZu2uftmMvsyL4YYiYvjEj
         Yy4twMIrWJePXu8kf+8DTC8vbgqg2sfrKki1SGxEPDkOVs3VmfhRxcGikn47b4nNFAym
         zHDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrmzG0p/RSZfoKXn15gHBWq1vPCYTAiHmhPQmZR7+y4YW7WEnrdZSyFwTfZRYYbZ09t3ZQCijTkA==@kvack.org
X-Gm-Message-State: AOJu0Yxd72FYw/28W3UtRr9ub4wE7+Lz+k11gX0v8rSuQcMvlaBU7rNr
	sZkAXMbqqCpcBCMhN1LYZV75QkK74Q5TYXrRwKiD/KZCxtpX4z7Tla3LSAqrcUHsIaau5+botMy
	vQtVyK/fVvBy3UjF8gyP+ES/3YQjtcw0=
X-Gm-Gg: ASbGncvdcsXQzcbUI/SiCE1sLkOtvseWSKt9mfuOkHpYqXOti4UfGaYQG8//dt8zVDg
	TXRFvToqRPLVnWDgPw2Hjuxf8skbUHretREihfYu4jovZk6goLeRpUkIRs2ed38sbT5txvkYxXY
	GQDRAxF5eJ7WjN39tarv6Vrg3fup+U6+yNK9/I1Q38c2SWZjn2A8jGH7arocxbSafoyiDpCa1+D
	P6VFjdSqnR5P6KaZeLUy0RmY3TgZHKVmA==
X-Google-Smtp-Source: AGHT+IEY7VUqCP/6pip0ttgbhxoRwcKJdJpXX3VVQ6uYBVkoIbhkGTsm9CuxqvphgnjFjnFOmjFQm0hmuzbL2sERn1M=
X-Received: by 2002:a05:6e02:1fca:b0:425:8d9b:c430 with SMTP id
 e9e14a558f8ab-42f873559d4mr317681995ab.6.1760459735457; Tue, 14 Oct 2025
 09:35:35 -0700 (PDT)
MIME-Version: 1.0
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-23-kanchana.p.sridhar@intel.com> <2qvfjavbepw3sq2pvvcez6jsc3bxkxej27674l4ztfdza7jqaq@xi6qndkj5xhh>
 <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <xnwqi5jnawvxdciqapfhhkneynsdr3dx36hmqe7jn4shm3uc3y@iyi5qqfubqey>
In-Reply-To: <xnwqi5jnawvxdciqapfhhkneynsdr3dx36hmqe7jn4shm3uc3y@iyi5qqfubqey>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 14 Oct 2025 09:35:24 -0700
X-Gm-Features: AS18NWB_RzfEOc-RbJZxwtIdj_8PcOzqcUoQW3euFgLMr1EXBSVQoQ46xhPlML4
Message-ID: <CAKEwX=NyUR6UE0PhXCaHOdta4=gVvRj7QgZtpPaLADpfXYyvZw@mail.gmail.com>
Subject: Re: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "sj@kernel.org" <sj@kernel.org>, 
	"kasong@tencent.com" <kasong@tencent.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 67prfqogsbnncj8184i1ip4je6jbfxxo
X-Rspamd-Queue-Id: BD2CA10000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760459736-11404
X-HE-Meta: U2FsdGVkX18ySbBcP7AeRVSyymAnw7PR9Cu0wKnZi5ZYgslUFr0uYhUvjPlf/GVewuAh8jQjvC/ZjA595sxyTClWJQnXNLVTBwzTcEgESnx4fj/nO5xaC+PCjQlu3ZgnWoPDv/2iSHiDK8J8BBjUSZv9eSFe+WvhSPyy+aEvpr+tyBPvwqEjuuSHpDfLvQgV3kQFIud53KEfVniS1nua3Deo0BmFvzDU6bqCB8y++EKLRM/rRHKV5BgxO2fchziOhlsjI/ngWPPcviygaMhHs7rvJ9r4LUp9+gLLzTiKIa8wE8QQaC6MNnqaG6z2w1TlDaXQRzb8QwlLd28cFb/2jtvldbPw/RXBjZsVRxH+VzDpMQPwY4AH1wMsadvb2wja68dpnpUHlFQbkneh9hU1KXfLxUO6Uwksxq3V5chYLv5E9wiws8SKtoVBd4jcd0LItCJnypb8c0CFpVjBYdzvMlKv2Es5LDktTaQzBSbt+YFSvIl04snDdmE+FbC+P29St9PMTDDzTicKmBwIJ86q1SaJ5m89yepCaozAufVwstIFsI4Ghv+5ZoHoT3kpY0bBPmYMmR4jotdzF1kXeU8/0aVFKHfyks9YiBsl19hNyDjGDxqg4v0sY4Al/vjMrBN0fax1g5cYq1q1dVfpwUpLhq4AbfTEOEOtUqwT66bpKNOmRrDC5OO4Uqi4l5c0GVsHXHXnpOueST9lkqmZskp9JZAND6FFsiTsQPBZa3DxwKYaAkOTIgTgewzgpB9pTfCvybFbA3W3Cthhq6h7bWaiaeozCOQbnVZ++7wmf/UHJVkLI9syW/NCob4vnOoI79K5lzKhhE9ixFl1bn2WPs3BsMqNE9IkNZmIlQM17laV37y2aXOUI2HLEYo6qY61WHbWMEWYADxz89LZ06YvVWJaRRhEZhAJsjKQBv6xA1oNyuIUJWn/YHnjeF3RuZ4tfRwRKWRLliNjofHcq9Asm+m
 MyFkbsQl
 VzMS92YIQnP13ct00NkOIHdDU5sSepwDuzeWCELImNGZ2QRNaC7//DPvIavUZ0FX0KaixQN26RzZot62egACIRGaO4XB+kMja41d6ya7iJDh5x1MsFkYUUgCgsm9zQCA8bK6Y7WtAJBGd3Ndnz1Xx1LU5UtU7tk81AtMR8+UUfiyJrmLZCEyM/SEbQQRM1QanA3SpGZeFdztuFtrqy7saWpe45uNdEwvOwjBp2zOVNXzZhgwYFUkjWnw4omBA0e5wVW3liQO14jOjDHkT/semdoMdWptH31VMnFxg2BKqJAIuAkR6Z5l+JjgeaTne+wx29f/Rm66E6ELKmofaxgM3zI5WaOi8YvezUpOU2W5shQ84YtO8ZRRCikvBkCxxRuBmD9YXpZ5X4q7E9xAM2VmvjWxndW1BgtHsGXqdQBG6QKMhibbq6I9GY89DJ72V5AfxRAvJGxpbUZhtOd8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 8:29=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> [..]
> > > > @@ -158,6 +161,8 @@ struct zswap_pool {
> > > >   struct work_struct release_work;
> > > >   struct hlist_node node;
> > > >   char tfm_name[CRYPTO_MAX_ALG_NAME];
> > > > + u8 compr_batch_size;
> > > > + u8 store_batch_size;
> > >
> > > I don't think we need to store store_batch_size, seems trivial to
> > > calculate at store time (perhaps in a helper).
> > >
> > > Taking a step back, is there any benefit to limiting store_batch_size=
 to
> > > compr_batch_size? Is there a disadvantage to using
> > > ZSWAP_MAX_BATCH_SIZE
> > > even if it's higher than the HW compression batch size?
> >
> > Thanks Yosry, for the code review comments. I had a discussion with
> > Barry earlier on these very same topics as follow up to his review comm=
ents
> > for v11, starting with [1]. Can you please go through the rationale for
> > these design choices, and let me know if you have any questions:
> >
> > [1]: https://patchwork.kernel.org/comment/26530319/
>
> I am surprised that calculating the value in zswap_store() causes a
> regression, but I am fine with keeping the precalculation in this case.
>
> I think there's a bigger problem here tho, more below.
>
> > > > + */
> > > > +static __always_inline int zswap_entries_cache_alloc_batch(void
> > > **entries,
> > > > +                                                    unsigned int
> > > nr_entries,
> > > > +                                                    gfp_t gfp)
> > > > +{
> > > > + return kmem_cache_alloc_bulk(zswap_entry_cache, gfp, nr_entries,
> > > entries);
> > >
> > > We currently use kmem_cache_alloc_node() in zswap_entry_cache_alloc()=
 to
> > > allocate the entry on the same node as the compressed page. We use
> > > entry_to_nid() to get the node for LRU operations.
> > >
> > > This breaks that assumption.
> >
> > You bring up a good point. I was looking at the code in slub.c and my
> > understanding thus far is that both, bulk allocations and kmem_cache_al=
loc_node()
> > allocations are made from a per-CPU "cpu_slab" that is allocated by SLU=
B.
> >
> > IIUC, the concern you are raising is in the mainline, the entry is allo=
cated on
> > the same node as the compressed page, and gets added to the LRU list of=
 that
> > node. IOW, the node to which the compressed page belongs is the one to =
whose
> > LRU the entry will be added.
> >
> > With this patch, with kmem_cache_alloc_bulk(), the entry will be create=
d on
> > the per-CPU slab of the CPU on which zswap_store() is called and will b=
e
> > added to the LRU of that per-CPU slab's NUMA node. Hence, the end resul=
t
> > could potentially be that the zswap_entry for a page could potentially =
be
> > on a different NUMA node/memcg than the page's NUMA node.

I think only the NUMA node is the problem, not the memcg.

> >
> > This is my thinking as to how this will impact the zswap shrinker:
> >
> > 1) memcg shrinker: if the memcg the entry ends up in is on the zswap_li=
st_lru,
> >     the entry will be written back.
> > 2) Global shrinker: will cycle through all memcg's that have pages in t=
he
> >     zswap_list_lru, and the entry will be written back.
> >
> > Based on this, it is not clear to me if there is a problem, and would l=
ike to
> > request you, Nhat and others to provide insights as well.
> >
> > Interestingly, most of the code in slub.c has unlikely(!node_match(slab=
, node)).
> > Does this imply some higher level mm slab allocation requirements?
> >
> > I am Ok with just calling zswap_entry_cache_alloc() for "nr_pages" if w=
e
> > think this would be more correct.
>
> I saw your other response as well, but I think one thing is not clear
> here. The zswap entry will get written back "eventually", sure, but
> that's not the problem.
>
> If the zswap entry is on the wrong node lru, two things happen:
> (a) When the "right" node is under memory pressure, we cannot free this
>     entry by writing it back since it's not available in the lru.
> (b) When the "wrong" node is under memory pressure, it will potentially
>     writeback entries from other nodes AND report them as being freed
>     from this node.
>
> Both (a) and (b) cause less effective reclaim from the zswap shrinker.
> Additionally (b) causes the shrinker to report the wrong amount of freed
> memory from the node. While this may not be significant today, it's very
> possible that more heuristics start relying on this number in the
> future.
>
> I don't believe we should put zswap entries on the wrong LRU, but I will
> defer to Nhat for the final verdict if he has a different opinion.

Oh shoot. Yeah I missed that part.

In the past, we sort of did not care - zswap was very poorly designed
for NUMA architecture in general, and most of our test setups have
been single-node, so these kinds of discrepancies did not show up in
performance numbers.

But we are getting more multi-node systems:

1. Bigger hosts (memory-wise) tend to also have more than one nodes.
It scales better that way (especially because a lot of structures and
locks protecting them are node-partitioned).

2. We have also seen different memory media that are often expressed
to the kernel as nodes: CXL, GPU memory, etc.

This will necessitate tightening memory placement. We recently had to
fix one such issue:

https://github.com/torvalds/linux/commit/56e5a103a721d0ef139bba7ff3d3ada6c8=
217d5b

So I'm a bit nervous about this change, which will make us use the wrong LR=
U...

Some work around:

1. Can we squeeze an extra int field anywhere in struct zswap_entry?

2. Can we pump nid all the way to zswap_lru_add()?

This is still not 100% ideal - the metadata (struct zswap_entry) will
still be allocated on the wrong node. But at least the data are
properly managed, i.e on the right LRU.

>
> > >
> > > Does it actually matter if we do the initializations here vs. right
> > > before inserting to the LRU (current behavior)?
> >
> > Yes, it impacts batching performance with software quite a bit.
>
> Taking a step back, based on discussions in this thread and others, it
> seems like the performance of zswap_store() is very sensitive to minor
> changes like this one, calculating the store size, etc.
>
> I don't recall this being the case before this patch series. It seems
> like an artifact of batching affecting performance negatively and
> a collection of micro-optimizations and "correct" placement of code/data
> to fix it. This seems to be very fragile.

I agree. This seems troubling.

What's the variance of your benchmark results, Kanchana? I have found
that kernel build tests can have quite a bit of variance, but is it as
big as the performance difference of these minor changes (i.e, can it
explain the "regression")?

>
> It is very possible that an incoming change will move the
> initializations or make other changes to the code, that will seemingly
> cause regressions when they really shouldn't.
>
> Additionally, what may seem optimal on the CPU you are testing on maybe
> be suboptimal for other CPUs. I think the big problem here is not where
> to initialize the entry or whether to precompute the store batch size,
> it's why the code has become extremely sensitive to these changes when
> it shouldn't be. zswap_store() is not a fast path by any means, and
> people will not expect such changes to cause meaningful regressions.

Agree. These micro-optimizations seem very fragile.

>
> >
> > >
> > > > + for (i =3D 0; i < nr_pages; ++i) {
> > > > +         entries[i]->handle =3D (unsigned long)ERR_PTR(-EINVAL);
> > > > +         entries[i]->pool =3D pool;
> > > > +         entries[i]->swpentry =3D page_swap_entry(folio_page(folio=
,
> > > start + i));
> > > > +         entries[i]->objcg =3D objcg;
> > > > +         entries[i]->referenced =3D true;
> > > > +         INIT_LIST_HEAD(&entries[i]->lru);
> > > > + }
> > > >
> > > > - old =3D xa_store(swap_zswap_tree(page_swpentry),
> > > > -                swp_offset(page_swpentry),
> > > > -                entry, GFP_KERNEL);
> > > > - if (xa_is_err(old)) {
> > > > -         int err =3D xa_err(old);
> > > > + for (i =3D 0; i < nr_pages; ++i) {
> > > > +         struct page *page =3D folio_page(folio, start + i);
> > > >
> > > > -         WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray error:
> > > %d\n", err);
> > > > -         zswap_reject_alloc_fail++;
> > > > -         goto store_failed;
> > > > +         if (!zswap_compress(page, entries[i], pool, folio_wb))
> > > > +                 goto store_pages_failed;
> > > >   }
> > > >
> > > > - /*
> > > > -  * We may have had an existing entry that became stale when
> > > > -  * the folio was redirtied and now the new version is being
> > > > -  * swapped out. Get rid of the old.
> > > > -  */
> > > > - if (old)
> > > > -         zswap_entry_free(old);
> > > > + for (i =3D 0; i < nr_pages; ++i) {
> > > > +         struct zswap_entry *old, *entry =3D entries[i];
> > > >
> > > > - /*
> > > > -  * The entry is successfully compressed and stored in the tree, t=
here is
> > > > -  * no further possibility of failure. Grab refs to the pool and o=
bjcg,
> > > > -  * charge zswap memory, and increment zswap_stored_pages.
> > > > -  * The opposite actions will be performed by zswap_entry_free()
> > > > -  * when the entry is removed from the tree.
> > > > -  */
> > > > - zswap_pool_get(pool);
> > > > - if (objcg) {
> > > > -         obj_cgroup_get(objcg);
> > > > -         obj_cgroup_charge_zswap(objcg, entry->length);
> > > > - }
> > > > - atomic_long_inc(&zswap_stored_pages);
> > > > - if (entry->length =3D=3D PAGE_SIZE)
> > > > -         atomic_long_inc(&zswap_stored_incompressible_pages);
> > > > +         old =3D xa_store(swap_zswap_tree(entry->swpentry),
> > > > +                        swp_offset(entry->swpentry),
> > > > +                        entry, GFP_KERNEL);
> > > > +         if (unlikely(xa_is_err(old))) {
> > > > +                 int err =3D xa_err(old);
> > > >
> > > > - /*
> > > > -  * We finish initializing the entry while it's already in xarray.
> > > > -  * This is safe because:
> > > > -  *
> > > > -  * 1. Concurrent stores and invalidations are excluded by folio l=
ock.
> > > > -  *
> > > > -  * 2. Writeback is excluded by the entry not being on the LRU yet=
.
> > > > -  *    The publishing order matters to prevent writeback from seei=
ng
> > > > -  *    an incoherent entry.
> > > > -  */
> > > > - entry->pool =3D pool;
> > > > - entry->swpentry =3D page_swpentry;
> > > > - entry->objcg =3D objcg;
> > > > - entry->referenced =3D true;
> > > > - if (entry->length) {
> > > > -         INIT_LIST_HEAD(&entry->lru);
> > > > -         zswap_lru_add(&zswap_list_lru, entry);
> > > > +                 WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray
> > > error: %d\n", err);
> > > > +                 zswap_reject_alloc_fail++;
> > > > +                 /*
> > > > +                  * Entries up to this point have been stored in t=
he
> > > > +                  * xarray. zswap_store() will erase them from the
> > > xarray
> > > > +                  * and call zswap_entry_free(). Local cleanup in
> > > > +                  * 'store_pages_failed' only needs to happen for
> > > > +                  * entries from [@i to @nr_pages).
> > > > +                  */
> > > > +                 store_fail_idx =3D i;
> > > > +                 goto store_pages_failed;
> > > > +         }
> > > > +
> > > > +         /*
> > > > +          * We may have had an existing entry that became stale wh=
en
> > > > +          * the folio was redirtied and now the new version is bei=
ng
> > > > +          * swapped out. Get rid of the old.
> > > > +          */
> > > > +         if (unlikely(old))
> > > > +                 zswap_entry_free(old);
> > > > +
> > > > +         /*
> > > > +          * The entry is successfully compressed and stored in the=
 tree,
> > > there is
> > > > +          * no further possibility of failure. Grab refs to the po=
ol and
> > > objcg,
> > > > +          * charge zswap memory, and increment
> > > zswap_stored_pages.
> > > > +          * The opposite actions will be performed by
> > > zswap_entry_free()
> > > > +          * when the entry is removed from the tree.
> > > > +          */
> > >
> > > But there *is* further possibility of failure if a subsequent entry
> > > xa_store() fails, right?
> >
> > This comment is referring to this specific entry.
>
> I think it's currently misleading in its current form. Perhaps:
>
> The entry is successfully compressed and stored in the tree, and further
> failures will be cleaned up in zswap_store().
>
> >
> > >
> > > Seems like if xa_store() fails we do not cleanup previously charged
> > > objects, pool references, zswap_stored_pages, etc. Instead of rolling
> > > all this back on failure, can we do all the xarray stores first and o=
nly
> > > do the rest when we're at a point where no failure can happen? Would
> > > that cause a performance regression?
> >
> > It would make the code more complicated and thus cause a performance
> > regression. I have tried to balance code simplicity (which impacts perf=
ormance)
> > with correctness here. The "store_failed_idx" ensures that all partial =
work done
> > in zswap_store_pages() for this batch, is cleaned up.
> >
> > The rest is handled in zswap_store() when it sees an error returned by
> > zswap_store_pages().
>
> Right, I missed the part about zswap_store() handling this, the comment
> above confused me.

