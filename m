Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73C85CCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 17:04:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5A3D8E005A; Wed, 15 Oct 2025 13:04:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0A618E0005; Wed, 15 Oct 2025 13:04:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D22F8E005A; Wed, 15 Oct 2025 13:04:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 77B618E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:04:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D3821DE2B2
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:04:38 +0000 (UTC)
X-FDA: 84000972636.23.6C3DB22
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3CAAEA0016
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:04:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QnToWEGj;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760547876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0PsUZ3DTLz/FEbE6bE6qcXBs0nMzCEfwi8X1s4NPS5U=;
	b=dW9ajx1xi0CrbwZw+3uixg4PD2d0S5VMuRo+Hzv34YnYxHgtkL4KOeOJ0Dtmph0eHIAftq
	PJ95h8rM2oCeJCsZMDqX0/LcL3zWwWfvgkNiyG/6lewqCANR78LzmFjXZadp5j8JMpD4B4
	mAJnh5G4f+xPV+535M9op/aicinX48s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760547876; a=rsa-sha256;
	cv=none;
	b=8RB8ghcmc6o1ECDSZ6KtOhqEmoA9Od1Ewn3MmJiK4HqrGcwnttjDp8KiBtcO4S70uKVJP7
	WHpYoEMw4Xx+7NtnHBSs7oBTBDJQeQw636orA+8GcOQPWV9aauRhqWLdcoctyF8qEdH4sf
	i/TKPgrX5EeNTwJeAWUgPz7tOvV6h+o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QnToWEGj;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-887764c2868so739642039f.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760547875; x=1761152675; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0PsUZ3DTLz/FEbE6bE6qcXBs0nMzCEfwi8X1s4NPS5U=;
        b=QnToWEGjIrCeJbkKHftPDp8lXQ/Jji3t3N61feu6LFu3IbfQ58dytp7eWbJZcarf71
         /JdWOL/xDWxB2PXEAngBTVsONMZAK9aKgKEkiA8/KbWDx7u/Tx2f4S8wpqfV/v1Pmb6M
         COVLi2htfflhfo3kv6G9+RIlJ2ss8dM7xIzZdmxzVP/i2ctl8DkkH+mDHsdG3MtjIgZI
         zYhtLdVw8VXr6vn/z1hHqtdNZ6dD8JfIbo02p8IXBqmJ/w6GNr2HVYWRLYyeGWIYHFSD
         S95B3LgOtrolXuc/mWpfB9NSFXJg9qPsNjSemWgH9IUO5lrgYgfunHquLlijqgp3+PZk
         W1Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760547875; x=1761152675;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0PsUZ3DTLz/FEbE6bE6qcXBs0nMzCEfwi8X1s4NPS5U=;
        b=lfPTQYAqKOgYnXIpnO2SFqkauDoskMpYn3jIRqbfmYg+gcNfnFtf1QhTrHxN+QTiOa
         iKngf1FZsOANRN4FKUC85GJpZihtPnqPZ9g6Dg7m1hxb5KDulwsaiDErBlChuuTYRCb3
         t6TZtjXAazyOHIH+qJPSt7ny14jxulUPIFR9pI/CU4O63gKtBBSbWHB7hBDhCXb0EDo9
         vTApIb3zzj3orajdFFvnDoiV6BsIHlb3bNKXEkBfULRzPj/fqiyADapmAaNTZlhis6d8
         nYCfJg8BiEynK2z1f5mhTkJ5QNTfq9wkD7wEkfdNWx84cnEVRQoJl7+4KdPUzXV5S9ap
         X8RQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMF4yBVuPKTytHghGtktv1s6eaMwPKsBvqc9w22wBBt90BnfWxSbjstRJ895l0bI2RJ0FLRfWmMA==@kvack.org
X-Gm-Message-State: AOJu0YwlTDyF0/Q/2kOmJaencvlMqxuCp3LsYaDDdURMF9zaaJewkE3i
	QRBpRcRL5FYny+Fvu14DFqlthHtOqNlnEoYCsuAQhHHuq76nqt21nheza4XNs6Vvn+NNmkywXdv
	msBW04DbJ61F5fIXgPAsuzKm9SahDd0U=
X-Gm-Gg: ASbGncto9zh8qlHB7piYKu5gq7gaSYgnKk90wnkdbEqfDBOS7khez1V+JjTCOC8Y38b
	IYLHhor4GY+KWh4u3THgiVmsTPJr6peO9FRCEFqxBGec9znJ3b9Qi4DAlq4PC37uG9nEIw5PWiK
	RvCMMY01ncjIICrGtMuFaOz6M3MrvlyDcfRrtiLD8iXJm0JfEN8+w+d+GyRItHvLHOl2ZIpFvbl
	FMkb0jjFF0n4hAqnLlAjVu7SfsQLLGy0CxJDRHksbsn
X-Google-Smtp-Source: AGHT+IGrcvHIVQYOlqUaFYBFUyNOXU4ruQhVF9+HEzslzVdiNACSpnhen54dqXbCCN8AswusBpC2oObBqP/2j6eL3zU=
X-Received: by 2002:a05:6602:3c7:b0:93e:3805:4683 with SMTP id
 ca18e2360f4ac-93e38054c07mr1683662739f.1.1760547874846; Wed, 15 Oct 2025
 10:04:34 -0700 (PDT)
MIME-Version: 1.0
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-23-kanchana.p.sridhar@intel.com> <2qvfjavbepw3sq2pvvcez6jsc3bxkxej27674l4ztfdza7jqaq@xi6qndkj5xhh>
 <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <xnwqi5jnawvxdciqapfhhkneynsdr3dx36hmqe7jn4shm3uc3y@iyi5qqfubqey>
 <CAKEwX=NyUR6UE0PhXCaHOdta4=gVvRj7QgZtpPaLADpfXYyvZw@mail.gmail.com> <PH7PR11MB812102541D5106A6D0E21E28C9E8A@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB812102541D5106A6D0E21E28C9E8A@PH7PR11MB8121.namprd11.prod.outlook.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 15 Oct 2025 10:04:24 -0700
X-Gm-Features: AS18NWCmhQjk7Q5ZDuFDuVGKSrttUEbTEhYpzHsGMWN3hs2nvrL8NcFRr0CqthU
Message-ID: <CAKEwX=NkaaCkoyULr4J+5-F+L5bRhM0F8JsV2DS0Mk=xYhncRw@mail.gmail.com>
Subject: Re: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, 
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
X-Rspamd-Server: rspam05
X-Stat-Signature: 8868mpure9cbca88zmqzyqqbmkjq1hqb
X-Rspam-User: 
X-Rspamd-Queue-Id: 3CAAEA0016
X-HE-Tag: 1760547876-766836
X-HE-Meta: U2FsdGVkX18gQaRAjIEMM9INOOsa9fI2X3Y4FNkggQ18vBrX0RDWQjhogjZPf6OkVYlA5swbGREDKur05g/nrIWZDfka64HXHb1/XTbvPpoUxDoLr2JniV3twMCQeEE0ar/urFrmwEyIzjt3s55FVym52BWYy9Xx0v0KipgdT+TaJvaxCNgxHSSTnA0aI8qHDuNuDt3jnbFcA1WICVhtLewAE1brZMwYE8KIoC/PvYM9mA3TqAF5Iwwximm3Pot2+TzD9KiP4govAZB7KTmkPlxMZKORV55ZffwnXhAQTmmHZ4GSjYDDPgfVMkbuMQIhYIfAHagSIb/WJF0hP6MO3WENV+vd6NSlhBDLzezuzWLKSzsfw0/R04F+D0W3BTT0P3IkJuZwacVIcr+Qokfat0AK1fgoa0GmG2OtwRszpxOjBfFFaslm2adICfOG+6V2PxPcjRU3CYpkWyZEf2mtaaGCHXR4K74foM/VN7NFaU+m6i39GaOAnKbphk0f015YOPGnmiIFWbDsslJkw0shXrOZCQEdK85sR5oYJVCrlxs1qE0nZRHG5H5HS7HT7ztXebw30ypbRXaSCHg/RHD8BRjMRJyUyJ3EpYBYMcOHTmYC4q1MR/gbFKbR2s9yRZyjdqVDaQKisLJurursves4yvPY2q9N2StpDOKsn8WI4nstcEEsyFJsUyKYT5MDFrJ9gP96xwNBQ7WtGivfslwIbBxZrokELLbGoTqn8QPp2tEwxNAX8SA6LzUS5Sin1AmFBfHkyYURiLhsLyp+9hHyZD9+erji5Aa/QDDxf1B5N1NwppleXB8t9q3Esqb7GKYoZF+YkZdc2UxG3A6e48yv1z4bQxYJAh0ZJy5IzRN0bfRHsPsifqrrV4mM7ufL7JtlTOT0fugqS1YALIXS/Zj9BMJ9jYD9pRp6tjZpZsNYTCEtbUtvSOktc019I6Ep+hFG4omJySDvhCWGPIPbpmh
 hkGvRiqG
 Q2n4vxYAuC8isaCNa6bKUz/APwceMUsIruM5hXWSFxP9thPY2BCBeF+erUb/NaV3L6FbpbBYcoEsY338iXOsVDFxvNxPCKSBe2hALx1w11hAJ9Pss8DBi+XUFIHGvch8PSiHUhsRSkSwdObAoD0J7i745cxqOhEj5LmNiHOQ1YXRkHeYtP6lo8Jv65O8b4vQ2DsuAnCnFyc0ENiOrvGonqbDM4t9A6iD+rxaI6DN3cTkDfB33Ph16S+V7Xp2Gv5QLtRsywqV89S+Ah+gUbLoKUhEBn8A7slPUOvo7p/rehQ9QbOUmvaXgmbVjYq+DS0JFAQrZ0DqpYCVaqrTZisUnNfb+W2vz0gzYAkPe7bds1FzUvKa7WtJwtqs8OA6iZwyZw+RaBDQl0vVDHleB2c+cweYDLF07Kt/cuDzSs0lGLrv/SX7aXhG9H0O9YDeM5VFtT0nSWNdAdgTu7c31kna0t0sV2jiuwHHRUwbd5RtrUfoepMHlusfDZDXu52ByfYil6eR+mUj849PdIWveJQffx4LKPtce725oh5vgNs30imodfmd+bYHA+5s5Uk9VvMcBFIxM4pgzOOXN3RJo3iZBhh53nO+7ikhh8apPHrRS+Nq0jmLZP1gbgca9AyAYfNO60SxPx8zvSBgOWG8pxkvYL7siLksb86ylZjW34WBTMYi9TvwPBS7FXEBV1G/0qGihaA5/empMF/eLKzDc4/tXL9yqE9OXBv9SNRGfmJhKAPV//6rvnrxqW+NOXwCbTEBXejhwJ4msJBfr+Z0rCbh4nLtcAfXtmFzYxyQuZPrMqToyMZVSJFaJ3UzQ99WmlkC9aUodvgPYb0Hh9KQn1MKxgtBlmwAT90sPFsr4+Vht7i4NPesPksdrnO4+XZO5Jh4Z7X+urusTCPtbHesROvMZvK5NvGo6ZaHhAtu/ou3oYzYzEpgV1f4iqIXwXB01hS4kkbiveJ+anXQKUW+lN+9zmZDWiUDT
 M03WwX2J
 OaC0ASj2GRXfau8zVjSQLi7ulGQ0zqGG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 8:42=E2=80=AFPM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
>
> > -----Original Message-----
> > From: Nhat Pham <nphamcs@gmail.com>
> > Sent: Tuesday, October 14, 2025 9:35 AM
> > To: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Cc: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>; linux-
> > kernel@vger.kernel.org; linux-mm@kvack.org; hannes@cmpxchg.org;
> > chengming.zhou@linux.dev; usamaarif642@gmail.com;
> > ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.co=
m>;
> > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v12 22/23] mm: zswap: zswap_store() will process a
> > large folio in batches.
> >
> > On Tue, Oct 14, 2025 at 8:29=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.=
dev>
> > wrote:
> > >
> > > [..]
> > > > > > @@ -158,6 +161,8 @@ struct zswap_pool {
> > > > > >   struct work_struct release_work;
> > > > > >   struct hlist_node node;
> > > > > >   char tfm_name[CRYPTO_MAX_ALG_NAME];
> > > > > > + u8 compr_batch_size;
> > > > > > + u8 store_batch_size;
> > > > >
> > > > > I don't think we need to store store_batch_size, seems trivial to
> > > > > calculate at store time (perhaps in a helper).
> > > > >
> > > > > Taking a step back, is there any benefit to limiting store_batch_=
size to
> > > > > compr_batch_size? Is there a disadvantage to using
> > > > > ZSWAP_MAX_BATCH_SIZE
> > > > > even if it's higher than the HW compression batch size?
> > > >
> > > > Thanks Yosry, for the code review comments. I had a discussion with
> > > > Barry earlier on these very same topics as follow up to his review
> > comments
> > > > for v11, starting with [1]. Can you please go through the rationale=
 for
> > > > these design choices, and let me know if you have any questions:
> > > >
> > > > [1]: https://patchwork.kernel.org/comment/26530319/
> > >
> > > I am surprised that calculating the value in zswap_store() causes a
> > > regression, but I am fine with keeping the precalculation in this cas=
e.
> > >
> > > I think there's a bigger problem here tho, more below.
> > >
> > > > > > + */
> > > > > > +static __always_inline int zswap_entries_cache_alloc_batch(voi=
d
> > > > > **entries,
> > > > > > +                                                    unsigned i=
nt
> > > > > nr_entries,
> > > > > > +                                                    gfp_t gfp)
> > > > > > +{
> > > > > > + return kmem_cache_alloc_bulk(zswap_entry_cache, gfp, nr_entri=
es,
> > > > > entries);
> > > > >
> > > > > We currently use kmem_cache_alloc_node() in
> > zswap_entry_cache_alloc() to
> > > > > allocate the entry on the same node as the compressed page. We us=
e
> > > > > entry_to_nid() to get the node for LRU operations.
> > > > >
> > > > > This breaks that assumption.
> > > >
> > > > You bring up a good point. I was looking at the code in slub.c and =
my
> > > > understanding thus far is that both, bulk allocations and
> > kmem_cache_alloc_node()
> > > > allocations are made from a per-CPU "cpu_slab" that is allocated by=
 SLUB.
> > > >
> > > > IIUC, the concern you are raising is in the mainline, the entry is =
allocated
> > on
> > > > the same node as the compressed page, and gets added to the LRU lis=
t of
> > that
> > > > node. IOW, the node to which the compressed page belongs is the one=
 to
> > whose
> > > > LRU the entry will be added.
> > > >
> > > > With this patch, with kmem_cache_alloc_bulk(), the entry will be cr=
eated
> > on
> > > > the per-CPU slab of the CPU on which zswap_store() is called and wi=
ll be
> > > > added to the LRU of that per-CPU slab's NUMA node. Hence, the end
> > result
> > > > could potentially be that the zswap_entry for a page could potentia=
lly be
> > > > on a different NUMA node/memcg than the page's NUMA node.
> >
> > I think only the NUMA node is the problem, not the memcg.
> >
> > > >
> > > > This is my thinking as to how this will impact the zswap shrinker:
> > > >
> > > > 1) memcg shrinker: if the memcg the entry ends up in is on the
> > zswap_list_lru,
> > > >     the entry will be written back.
> > > > 2) Global shrinker: will cycle through all memcg's that have pages =
in the
> > > >     zswap_list_lru, and the entry will be written back.
> > > >
> > > > Based on this, it is not clear to me if there is a problem, and wou=
ld like to
> > > > request you, Nhat and others to provide insights as well.
> > > >
> > > > Interestingly, most of the code in slub.c has unlikely(!node_match(=
slab,
> > node)).
> > > > Does this imply some higher level mm slab allocation requirements?
> > > >
> > > > I am Ok with just calling zswap_entry_cache_alloc() for "nr_pages" =
if we
> > > > think this would be more correct.
> > >
> > > I saw your other response as well, but I think one thing is not clear
> > > here. The zswap entry will get written back "eventually", sure, but
> > > that's not the problem.
> > >
> > > If the zswap entry is on the wrong node lru, two things happen:
> > > (a) When the "right" node is under memory pressure, we cannot free th=
is
> > >     entry by writing it back since it's not available in the lru.
> > > (b) When the "wrong" node is under memory pressure, it will potential=
ly
> > >     writeback entries from other nodes AND report them as being freed
> > >     from this node.
> > >
> > > Both (a) and (b) cause less effective reclaim from the zswap shrinker=
.
> > > Additionally (b) causes the shrinker to report the wrong amount of fr=
eed
> > > memory from the node. While this may not be significant today, it's v=
ery
> > > possible that more heuristics start relying on this number in the
> > > future.
> > >
> > > I don't believe we should put zswap entries on the wrong LRU, but I w=
ill
> > > defer to Nhat for the final verdict if he has a different opinion.
> >
> > Oh shoot. Yeah I missed that part.
> >
> > In the past, we sort of did not care - zswap was very poorly designed
> > for NUMA architecture in general, and most of our test setups have
> > been single-node, so these kinds of discrepancies did not show up in
> > performance numbers.
> >
> > But we are getting more multi-node systems:
> >
> > 1. Bigger hosts (memory-wise) tend to also have more than one nodes.
> > It scales better that way (especially because a lot of structures and
> > locks protecting them are node-partitioned).
> >
> > 2. We have also seen different memory media that are often expressed
> > to the kernel as nodes: CXL, GPU memory, etc.
> >
> > This will necessitate tightening memory placement. We recently had to
> > fix one such issue:
> >
> > https://github.com/torvalds/linux/commit/56e5a103a721d0ef139bba7ff3d3a
> > da6c8217d5b
> >
> > So I'm a bit nervous about this change, which will make us use the wron=
g
> > LRU...
> >
> > Some work around:
> >
> > 1. Can we squeeze an extra int field anywhere in struct zswap_entry?
> >
> > 2. Can we pump nid all the way to zswap_lru_add()?
> >
> > This is still not 100% ideal - the metadata (struct zswap_entry) will
> > still be allocated on the wrong node. But at least the data are
> > properly managed, i.e on the right LRU.
>
> Thanks, Nhat and Yosry for the discussion. Thank you Nhat, for the
> zsmalloc change log reference and for the work arounds!
>
> Following your suggestion in (2), can we pass in the folio's nid from
> zswap_store_pages() to zswap_lru_add(), as follows:
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 263bc6d7f5c6..44665deece80 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -694,9 +694,9 @@ static inline int entry_to_nid(struct zswap_entry *en=
try)
>         return page_to_nid(virt_to_page(entry));
>  }
>
> -static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry =
*entry)
> +static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry =
*entry,
> +                         int nid)
>  {
> -       int nid =3D entry_to_nid(entry);
>         struct mem_cgroup *memcg;
>
>         /*
> @@ -1758,7 +1758,7 @@ static bool zswap_store_pages(struct folio *folio,
>                  *    an incoherent entry.
>                  */
>                 if (likely(entry->length))
> -                       zswap_lru_add(&zswap_list_lru, entry);
> +                       zswap_lru_add(&zswap_list_lru, entry, nid);
>         }
>
>         return true;
> --
>
> I believe this will add the entry to the LRU node of the folio being
> compressed. If so, we may be able to avoid adding an int field to
> struct zswap_entry?

Hmm that might not work for zswap_lru_del() :(

zswap_entry_free() might be called in context where we do not have
access to the node information (zswap_load()) for e.g.

Another alternative: can we instead determine the node from the
compressed object's storage? i.e store zswap_entry in the LRU
corresponding to the node that holds the compressed data?

You'll probably need the new zsmalloc API to get the node information.
And can zsmalloc migrate a backing page to a different node? This
seems complicated...

Taking a step back though, do we have to use the bulk allocation API
here? Calling the single-allocation version 512 times for a PMD-sized
page is no worse than the status quo, correct? We can leave this part
unoptimized for now - in the future, if the use case justifies it, we
can talk to slab allocator maintainers and ask for guidance on a
lock-optimized cross-node bulk allocation API.

