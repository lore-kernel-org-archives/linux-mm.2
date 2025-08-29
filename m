Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4604CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 03:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58328E0003; Thu, 28 Aug 2025 23:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E19368E0001; Thu, 28 Aug 2025 23:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2E388E0003; Thu, 28 Aug 2025 23:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0F718E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:31:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81BA81A051E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:31:35 +0000 (UTC)
X-FDA: 83828370150.19.162EF65
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf28.hostedemail.com (Postfix) with ESMTP id AC022C000B
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:31:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KOeSSg1s;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756438293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ADYcr57ubdWKZAedQhB4LgeKWRv5y3WMX0XjvFo6Wo=;
	b=QUE68WpA2Hl7zgBs9AdtZBfTv+aDggbC14mSWbdzS/G4TLHsG1MQXLKZ8ZIk2TiKZwH8IY
	vi5jlaRB6Y7n7wUrCXxQ6yTSnGcfxaeEzqJy5nVmLS/am757hO6YpFP+XrDfLZZLTKOAKZ
	bkHpMXrxxWkv1LM4C6zc5B4URPEZVgo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KOeSSg1s;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756438293; a=rsa-sha256;
	cv=none;
	b=Fk/WET2vlOB7L67tZcPT46nM+O/6CPsovkmkW8XnJ0tU3e8fMiZI/XTdEAdx4tbk4lLkrs
	aWk8qtaA3ML/ch88yl7C3zsr21LR/Q/pPir4hYNkx25jrLhTCxralG4lhwE02/WYzVF3Qw
	wFInnq+3OFMxQH8pnTWNwcVZqsWz/vE=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7f861f89313so163485285a.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756438293; x=1757043093; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ADYcr57ubdWKZAedQhB4LgeKWRv5y3WMX0XjvFo6Wo=;
        b=KOeSSg1soxIfMqFqeoF0sJtpd8EPCLbNflF0ORWHxnZPV5uXdvV7Iw7C/ELeQkMzCR
         ohD7ZC6ESsCLw4wCT+Jg82Kn1lrbbyf8KzKQFycNZdYc5AVmGSaEbBRJacT3trr63rL9
         yaZSlJzKyx2BxCj3mtj/uVExvNkhP9RhebNn/nSMVl2G8USApLrBEF3SdhWGgbK7BGud
         a/ms31iQhtzThoLMsPyk17Q434uOkxkKNuZbhvtP2tWWpdJ29noXi4QXgvPrAcDWI7Kf
         aLT+eO/2jYC9mSNJgwldYUzNQZLF6oeuzRFJMo/TDg5Au81TDVFAQ7uBQX/sUF+Tww3J
         1c1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756438293; x=1757043093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ADYcr57ubdWKZAedQhB4LgeKWRv5y3WMX0XjvFo6Wo=;
        b=jrIA01EU+jPmkw5gg8VIwgZkjk9XXbxUyqaNjuw3ouQw1SkSo4vqPcxgQnGzZsHP1D
         Z7jLZla8GWEAXsiNT9ul4j+jSIbbyJO2YObunULl9TTyk2EaATM7SDBAMl2uLkplxzTy
         I4Tz+CLqHGim0qP7ikKeXQ7Rz6MLsyP51AGHUR6Ii3zi79zZY9/pVt2LDNovag9r1OrY
         4ZWtuV+MJQTbaqjHXnp21HJQUqDlTjljliXecmscHYwWtX14GtVsO4rrYHnFPmhuPWBe
         OBxGWYKtXl3N8Xr7pgDbXDj2/ddVU6EE9MDLMH04igX+7stSVWip2j3xZPO/9MKYnSjt
         X3MQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPnueHlzPBHonBZHQYEhekkjjBWYmbv1xMchGf3p5e8M6A3mcfa/ts8AvlGBZbBLAGK0fX7umV0w==@kvack.org
X-Gm-Message-State: AOJu0YzMtVNnEIS8jdcPW1N2bIJ7Dw3hHkkPJeryOTtZ/f605WrtyL/g
	nsvxKxtoVqvPzZ80ifXM6A1ChSrzjkzAfpxqOMYUP/G6xXdQUzVpMC+a3hlYjbXeLEUIv67v8hW
	x1MAMCybXcrXPTHs+sUdcVs/EXmQXj3c=
X-Gm-Gg: ASbGncuypWDfFqHf56RsA90ykvr3d1rQJiAPhMnTi0cPGAL7OyRINQuIisv/qcQFd9G
	IxWiaW9Cnpm1tqy9angRvK42k4Oa+SlMAXzUW5epMj1BYK7PW+7yCwGrruNUwgfYO8930DTwpPs
	LiraFdHE2TvxylCuXvgLQs9YE2Au0W0HkjTYejLoLRwNEHISA2bzhHvOMhB+iPdkMTiNhK2EQ1q
	T/Pa98=
X-Google-Smtp-Source: AGHT+IGEZ/VVLdhbW4pwfoESF2nMHOvYZKZwWWhXDB21nwadZKTlaRoN2bwKZej7UBthdgBvEuoaeEf77PMv3GxcBqk=
X-Received: by 2002:a05:620a:178d:b0:7f2:32f6:6059 with SMTP id
 af79cd13be357-7f232f66372mr2304183185a.73.1756438292389; Thu, 28 Aug 2025
 20:31:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-25-kanchana.p.sridhar@intel.com> <CAGsJ_4xMYUHo_SRc=1jgP6jMNosA_NP3HCitSMKwx=5ScJ0Cng@mail.gmail.com>
 <PH7PR11MB81213032EE672C69B3FC3370C93AA@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB81213032EE672C69B3FC3370C93AA@PH7PR11MB8121.namprd11.prod.outlook.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 29 Aug 2025 11:31:21 +0800
X-Gm-Features: Ac12FXwkrbOj6-86gUqhlz-rQd1S-Zr7JQZDpGn6f_G18CtOphnH5OXwGLiRBic
Message-ID: <CAGsJ_4xH7aU37w03-4MSJs7Bik6pShLfad8RY8TSzj37AcGwDg@mail.gmail.com>
Subject: Re: [PATCH v11 24/24] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AC022C000B
X-Stat-Signature: niefsk3sryawhgmyhqahaqnuo5hf6c3h
X-Rspam-User: 
X-HE-Tag: 1756438293-512366
X-HE-Meta: U2FsdGVkX18W8Z1SfLsy9VKgS/mS58YW3Yg1JXHBEzbmpTqkN5/y5XOO5/2iXwvb1dDsWGe5ID2Y7O2PNb8DEBovgLUVrRTMQTbZzRT5BTj5EFtZ0nk7+V+MAD6ixX5G+TvnnSz7nuKR+il/PgxEn3IAHivqqupiIHLmZVtfe+h8s/adV26BhGyJSRYntinL67PeIR2hCiAl4lTVhJuCcMjfA1f4B1I1t/6WRYbqs1IKYW2bC1bEUpX00WF9IiQ1GHXoMkeOsgsPHNGe3XvgyKHKB3K046lRPMvkhuy+1R1oafyQXS0ayd05ZkDhmIaIR5Zyj7+3p9LkefQ6UhG71AtRGcFsYtI9mIMM6Y7S3hVrXN/REsaHlg7y7u9UNovl0qTFCtuHTMNPsV5YqFygXmzPYpAWYoihVTY4Xsm2sNT6+tIx9GnXJJLcqgSOuq7WA3MxjPHSbMpx7osm/Ajf8l+Hf5GBRqOmEgDFKmAbEE6ity9ip4VPSguF1sGbFrrCS8lceCQ3eqAr2g+HSFqGzIsB1nfR6erpvoBiDAxkZnCoka7v+P2Q4JVrnOUAbNUMvmXZdJ1ulUu+YbwQyijWIavlohPRST+GhZBl9GRKtxhRtjjSG8O5s/qEryoS0uaJFf+IG9PCP3QRNg6hyZTaplHToLj9s3iH/N+KnX92crxmCSJFAZ3d9PV0tb00kspFPSlUE0gmAiKHYPoJSLOUJa1sHZah7nuKQgCS7j/20+KM11hLej8p8PqvNtCsvyIUP1uwP88Il7y7T5KrXLnjFf8CpoDrA/Ky8tsOEdvgPP9hY1S+KokuzWQbVl8G6zUXF0Y59+j/xCLQI4lwqHAsSRlIUyNIG2tufjzYMVYITaoMSgAc+gBkSWKafCV0xvvTL3cwmBGrGqiyK2tFhkS2uJrRPcuqTXqGCviQvSlBt6FKUh0yAnAgJ1bvOpB3KXGP5slntiws+jhruTA8u/t
 GSsB15jK
 BUIQ4t7+Bg8+n1Wv4mWHQ0KvmXBJUT9pzP6C3Jlz+wfjl1CmCd82hFauPEoq88RHuNbQrt+8q36nKz746e+hr1PA+ueglRl3yBPVUlpqLW7YS0Rjeh3Jp5ernLDa8KIaMI/U8I1d4rwN5YFs4JXKSfnMq/M1gc+zJWq64yJArN+MQvNTDMVdd0URFp6nsZ3+98TA4tLOxbvGAwftBs/HBRzEoELjT1QMUG2VnEfime1k7CYSOfG20tm09eJtkh31mJ9xaGafz4cUofEIcojdRNpF5t24U4PRXRQfL/pm2ipMZAuBW6vTKshlr+p+jS1ea/QGNcyRpQiw+MN0HhkdAYLqETou8vg3EGhYkpKplFq5G7BLMOkZeNw1BeNXtiY3w5ePbeO3VKlJqtAk5MrVIc+LhLSCJZM2qt1EEGMQW7lYnZBRItmZ6S92HciEn12JrqLpy7lnMl2uVyPH0iD/1gmaSumtnC2MzKlkjH8DweWaCVgTPyk8Ot1H5nCsLLhBIpTgjJCJjDPUtJR5FqcLWNzk9sJ40IFFQVYtt6XPbkN+nxeFwTgfDOPY23hhomzE5hMqrg9IGaiSK24FQUxTgHJP9lfP66FkRo8jLnqJjxzuocthIf7h5CwkQ32KdTP2y4BNNIVOHxzQjTHtVfty++RfbHt8EeUePhg3A+ET0e1fHQtPPQUS04jeqEYADUjgZ800fmq7oc+uuNhICTW3O4ohLbxvLe461LnCdvNxoPjx3KTI5bl8NT2p8iqGJNSm+qBzNroJCekpwKCmt41pR1k0EoVffJxvS7Fgu1daReQRkrL39N9OWuZBaH5lwGJOtXGhcwLMNEhceZ8zDmmQ+WfSNheoTBhjuXF3Xl5VPOKl+fh4IHefWWE0WwVKW8fwVybyHz94M37tL3AUm/wXME5GA73kKFcWv4xuYiYGTfMz7eHp2GohA2W2SBAAPDhMma9cVQ/b83dWTi4ERnjNbqOTG9vb3
 9DNSuKKn
 Z1ag59HQTxWZ1RpQ5Am/rQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 11:05=E2=80=AFAM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
>
> > -----Original Message-----
> > From: Barry Song <21cnbao@gmail.com>
> > Sent: Thursday, August 28, 2025 4:54 PM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
> > chengming.zhou@linux.dev; usamaarif642@gmail.com;
> > ryan.roberts@arm.com; ying.huang@linux.alibaba.com; akpm@linux-
> > foundation.org; senozhatsky@chromium.org; linux-crypto@vger.kernel.org;
> > herbert@gondor.apana.org.au; davem@davemloft.net;
> > clabbe@baylibre.com; ardb@kernel.org; ebiggers@google.com;
> > surenb@google.com; Accardi, Kristen C <kristen.c.accardi@intel.com>;
> > Gomes, Vinicius <vinicius.gomes@intel.com>; Feghali, Wajdi K
> > <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v11 24/24] mm: zswap: Batched zswap_compress() with
> > compress batching of large folios.
> >
> > > +static bool zswap_compress(struct folio *folio, long start, unsigned=
 int
> > nr_pages,
> > > +                          struct zswap_entry *entries[], struct zswa=
p_pool *pool,
> > > +                          int node_id)
> > >  {
> > >         struct crypto_acomp_ctx *acomp_ctx;
> > >         struct scatterlist input, output;
> > > -       int comp_ret =3D 0, alloc_ret =3D 0;
> > > -       unsigned int dlen =3D PAGE_SIZE;
> > > -       unsigned long handle;
> > > -       struct zpool *zpool;
> > > +       struct zpool *zpool =3D pool->zpool;
> > > +
> > > +       unsigned int dlens[ZSWAP_MAX_BATCH_SIZE];
> > > +       int errors[ZSWAP_MAX_BATCH_SIZE];
> > > +
> > > +       unsigned int nr_comps =3D min(nr_pages, pool->compr_batch_siz=
e);
> > > +       unsigned int i, j;
> > > +       int err;
> > >         gfp_t gfp;
> > > -       u8 *dst;
> > > +
> > > +       gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM |
> > __GFP_MOVABLE;
> > >
> > >         acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
> > >
> > >         mutex_lock(&acomp_ctx->mutex);
> > >
> > > -       dst =3D acomp_ctx->buffers[0];
> > > -       sg_init_table(&input, 1);
> > > -       sg_set_page(&input, page, PAGE_SIZE, 0);
> > > -
> > >         /*
> > > -        * We need PAGE_SIZE * 2 here since there maybe over-compress=
ion
> > case,
> > > -        * and hardware-accelerators may won't check the dst buffer s=
ize, so
> > > -        * giving the dst buffer with enough length to avoid buffer o=
verflow.
> > > +        * Note:
> > > +        * [i] refers to the incoming batch space and is used to
> > > +        *     index into the folio pages, @entries and @errors.
> > >          */
> > > -       sg_init_one(&output, dst, PAGE_SIZE * 2);
> > > -       acomp_request_set_params(acomp_ctx->req, &input, &output,
> > PAGE_SIZE, dlen);
> > > +       for (i =3D 0; i < nr_pages; i +=3D nr_comps) {
> > > +               if (nr_comps =3D=3D 1) {
> > > +                       sg_init_table(&input, 1);
> > > +                       sg_set_page(&input, folio_page(folio, start +=
 i), PAGE_SIZE, 0);
> > >
> > > -       /*
> > > -        * it maybe looks a little bit silly that we send an asynchro=
nous request,
> > > -        * then wait for its completion synchronously. This makes the=
 process
> > look
> > > -        * synchronous in fact.
> > > -        * Theoretically, acomp supports users send multiple acomp re=
quests in
> > one
> > > -        * acomp instance, then get those requests done simultaneousl=
y. but in
> > this
> > > -        * case, zswap actually does store and load page by page, the=
re is no
> > > -        * existing method to send the second page before the first p=
age is
> > done
> > > -        * in one thread doing zwap.
> > > -        * but in different threads running on different cpu, we have=
 different
> > > -        * acomp instance, so multiple threads can do (de)compression=
 in
> > parallel.
> > > -        */
> > > -       comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx-
> > >req), &acomp_ctx->wait);
> > > -       dlen =3D acomp_ctx->req->dlen;
> > > -       if (comp_ret)
> > > -               goto unlock;
> > > +                       /*
> > > +                        * We need PAGE_SIZE * 2 here since there may=
be over-
> > compression case,
> > > +                        * and hardware-accelerators may won't check =
the dst buffer
> > size, so
> > > +                        * giving the dst buffer with enough length t=
o avoid buffer
> > overflow.
> > > +                        */
> > > +                       sg_init_one(&output, acomp_ctx->buffers[0], P=
AGE_SIZE * 2);
> > > +                       acomp_request_set_params(acomp_ctx->req, &inp=
ut,
> > > +                                                &output, PAGE_SIZE, =
PAGE_SIZE);
> > > +
> > > +                       errors[i] =3D
> > crypto_wait_req(crypto_acomp_compress(acomp_ctx->req),
> > > +                                                   &acomp_ctx->wait)=
;
> > > +                       if (unlikely(errors[i]))
> > > +                               goto compress_error;
> > > +
> > > +                       dlens[i] =3D acomp_ctx->req->dlen;
> > > +               } else {
> > > +                       struct page *pages[ZSWAP_MAX_BATCH_SIZE];
> > > +                       unsigned int k;
> > > +
> > > +                       for (k =3D 0; k < nr_pages; ++k)
> > > +                               pages[k] =3D folio_page(folio, start =
+ k);
> > > +
> > > +                       struct swap_batch_comp_data batch_comp_data =
=3D {
> > > +                               .pages =3D pages,
> > > +                               .dsts =3D acomp_ctx->buffers,
> > > +                               .dlens =3D dlens,
> > > +                               .errors =3D errors,
> > > +                               .nr_comps =3D nr_pages,
> > > +                       };
> >
> > Why would this work given that nr_pages might be larger than
> > pool->compr_batch_size?
>
> You mean the batching call? For batching compressors, nr_pages
> is always <=3D pool->batch_size. For batching compressors, pool->batch_si=
ze
> is the pool->compr_batch_size.

I=E2=80=99m actually confused that this feels inconsistent with the earlier

    unsigned int nr_comps =3D min(nr_pages, pool->compr_batch_size);

So why not just use nr_comps instead?

>
> >
> > unsigned int nr_comps =3D min(nr_pages, pool->compr_batch_size);
> >
> > So this actually doesn=E2=80=99t happen unless pool->compr_batch_size =
=3D=3D 1,
> > but the code is confusing, right?
> >
> > > +
> > > +                       acomp_ctx->req->kernel_data =3D &batch_comp_d=
ata;
> >
> > Can you actually pass a request larger than pool->compr_batch_size
> > to the crypto driver?
>
> Clarification above..
>
> >
> > By the way, swap_batch_comp_data seems like a poor name. Why should
> > crypto drivers know anything about swap_? kernel_data isn=E2=80=99t ide=
al either;
> > maybe batch_data would be better ?
>
> This will be changing in v12 to use an SG list based on Herbert's suggest=
ions.
>

Cool. Thanks!

Thanks
Barry

