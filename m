Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D712BCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 23:28:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00F076B000C; Thu, 28 Aug 2025 19:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01818E0006; Thu, 28 Aug 2025 19:28:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF1638E0001; Thu, 28 Aug 2025 19:28:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9CF96B000C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:28:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 966931A045D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:28:47 +0000 (UTC)
X-FDA: 83827758294.26.F373F36
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id B8D348000E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:28:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PilDjXBU;
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756423725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5xAEZzGkKzOekVqIS4rKLRu5l7Wsy0HGBRxwvDh6Sc=;
	b=jFUTlkML0U3qL3ZEYsqDiPc7po9RbxcxQh1oJxy9FPebteHH2NCRwiMcHUIoAPoYu1TUpd
	Ao+KxKa9cQ5NoKoIQpfkPV93oF2W1AXGCHUruwma/rJwCM+Qo3aaQ5rHQmopR95FrPZLRC
	LKNdO1qO6zwXA2iuSdgM5x16pC4RkV0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PilDjXBU;
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756423725; a=rsa-sha256;
	cv=none;
	b=nnDXfYrfsSv5N/bGtZ/IX63LDHUIgS1rplHuFnN6sZmgIqkyy4nGry4DZiyg+ndyrvPA45
	GpF6i6O+TKu64aKHzQPgPPFunG/060tqjkuOXNP3wHl0Nj0gVMTqwsR+fvn1XcQytlrwUB
	03GTf/Rwm6wN6OQbHuUs2w3J+7PuONc=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7e8704cdc76so154163785a.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756423725; x=1757028525; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g5xAEZzGkKzOekVqIS4rKLRu5l7Wsy0HGBRxwvDh6Sc=;
        b=PilDjXBUYPzG255Zu0b1ldOAHt64/jNzE3cnfUkxvShf0HH6syIi00EskPEmaiDAd1
         t5yzAYXlCEL+QsQuhhA/mkw1BWrLfkmUiiNxX7wRUkXFdLO8rQFrnB9Usi0zjSMRCfkB
         eURyfS6wo9cyBNqjz8wyYkfcar3OeRtcypP12UnZ6YE8h8E1dQSVxI1HKPXxuHbLFYI4
         6rq5PRTeKXQ1eE+FDeQ+6Vmx0p4v2LRFAsMuzzmLqfNpPwcmeklphoB1cJBCZw8GCaAE
         rQoSXB7rj1hjnTOY4WMAZMm3lRtBuJY1evrR9an0fZu1IK8f7aL+Ir0+wc8Lw7JOkz8/
         fThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756423725; x=1757028525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g5xAEZzGkKzOekVqIS4rKLRu5l7Wsy0HGBRxwvDh6Sc=;
        b=DqAdA70snEPf86vq9GjagqAXV5Mfc9irCFkZMTK1zv3eiQXl2dpHSukHVWtJNhDKYF
         TXOR3beukp0HuqnNaaPkqNjxFmKZRTzxwraijpprlYGTtqVKD4RRYASNjrBvsjbFHvOo
         pFMHl6PZCwTx1YNaiG4+ZSuFyNmcDXEm/gBdZzqlm3deO/nqZmdrLh9jyOXbApQz3578
         L3K8ab+JqWNn4XrlrMje5ipYV8go3WuBIToSIj06VybXdzJGt7/h+scB1yqWt/8n1PVw
         0iDS2f6KnpX4aVFC+Lm4NCdgMCEvL0jGAVNiOb8yeF1zoauerDdVYxqiVkhwP2zd9ScF
         ZfBg==
X-Forwarded-Encrypted: i=1; AJvYcCVWYoC0ynKxQ6t1THxqqcFE8EE/w7JkC1rIp7jiqC8QgkUVtLy7pilTjvULc0lnio0WI1X3QcR45g==@kvack.org
X-Gm-Message-State: AOJu0YxAOb7GfVx//n/Olo0MhRmxBntmf3vbW4utkyonR626YmgdUoka
	FJxcAGL2GbM3IDag3fTkY4Vy6vlpCejOwvkLXOYR+thcHDS1oH3ZTE9D1GQeeqD3cfqFLeMPUsh
	wr4+Iajt0WW3igSCIkTDlBeaK9qVgAfY=
X-Gm-Gg: ASbGnctUW7u8hoAx+MyspjPhmdpc/E8XIyl2K2pawHBe1WnqIqLiIuuv8SgFiiI8Yl1
	d+0xBTT/An69qVLmLcJoNbNXIVQhp8yHH6Nn7EbG0eEU9/G80qNfzpAHNcj47uVt7R0r/e2UJDf
	gsfthSW6nJEqKnfPUMpFRuPnR9gVjMK9kGp2B05vK6R390+XPFt0dQe6PkEor4rRCfAFK/iougn
	MIw4wIZpKwOd0OzeQ==
X-Google-Smtp-Source: AGHT+IG9dqf0v9B4cNprbTA7zUMYBwOa7Uq6IGQrFQsG5rT3a7SmZdhcZHPObNG9JdyxtkduL8KD+Nlyyk3kPIqkw2Q=
X-Received: by 2002:a05:620a:3913:b0:7fb:d5c5:a4df with SMTP id
 af79cd13be357-7fbd5c5a6b0mr253670785a.34.1756423724471; Thu, 28 Aug 2025
 16:28:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-23-kanchana.p.sridhar@intel.com> <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
 <PH7PR11MB8121532CE4368DF5BAA6D46DC939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xMuLPy3+mAxzOj6SfnFZaDf+B=WkmbrCNqv8gvK080Fw@mail.gmail.com>
 <PH7PR11MB8121B86E65349F5CF854CA57C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zt9zQFh1mz6gpQOCWBOjz1osN9jTd62uKGf865vRwuLA@mail.gmail.com>
 <PH7PR11MB8121C1B5965584AA8E59C0B7C938A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zjPxSjrSomm3E3gOuW+AqiTKwUHJ34q9m9aJb3y3vEKw@mail.gmail.com> <PH7PR11MB81211DD54822167C6BA238D5C93BA@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB81211DD54822167C6BA238D5C93BA@PH7PR11MB8121.namprd11.prod.outlook.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 29 Aug 2025 11:28:33 +1200
X-Gm-Features: Ac12FXymL-oJOFhtfchGYmwxY8_PFVTDmAseMPSDCZcsDDSfx-7l2g2_r4lHbbs
Message-ID: <CAGsJ_4xy3mksbwj61qnNrSpcFgkanEK0tCzJcjQgVF-oAyXe8A@mail.gmail.com>
Subject: Re: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B8D348000E
X-Stat-Signature: 1gshs8b7htkhowo97m3cu9rnsq5e45en
X-Rspam-User: 
X-HE-Tag: 1756423725-22767
X-HE-Meta: U2FsdGVkX19icE5XLV9Yk28f4RBiJnEHQGN0nIJcaQ/orK2zA9wNgdnuVDTsUWB9H3GxQ2MYrtm93N4va81tPOwXHI8XV8x5hzwEZPX3irMMUmK1/foCIhWjePNBOTSEMDBnzM4Y+l1oV3FtTn6yDCw6aaTgGb9TNNCWj6Uk7OPsdUG5V2TT24J2McBEC7EZ8iDextJuf5FniRAlxJM7aI5BmYEH1WcFaZb+q5Q8rbuj+RNszmTwDaLG1uXD7hRI0zUd4AGZPQmur7lYPh6P1qgoUKjjh8kNtQo8QBxv9HTB0pmGt2c5W5imzb/pn1tSRS33JPevW8JJYvURPlp30PQG08mdpp1LDX94696PpiNDBXBeCI0kylaEX9tRhD8VudqwW8bpHy/u1oJy3kuJPtA17qZE7TxJ28KWUjqi4XHvgb1PAtmogczMtfm5PsvMOerPGFRhD6UjATdPOPrrolXbcTVcdBhKmd2f+89RFMsiohDT/wgFOKu2v2eTc55460u6c5aQtE/lxbNRn8iVHSb/h5HkdG+iL3bFyoFSjx2CyJWpvYTi/OO+BbA83i5zbTldo7nr/sDlznelhxWDKBCtG9MqAbSpkO6/Jt8vn8kOhRMTS8dYgUs2VYBmuxPHuioh+ZGbja1dca1B1d5qG2gV+NmsvKAghoz0ytEczP0vMCuRfsGDoqVufqUKnaFr29cr7Ih3qoPtF3cP3dv7bUMhPBXG6nEyfv2UIzHBpVshY51Y3PYvFWWz6k7+dAzIELcEzvnbdTouvk3kIVkIvel4xJpzUBuSSRDN3bQQLKnfRF1nKaTONWTaY6V5J44/ovMbpmW2ncER5KTqewjsTSxaBBNU0FP95gBoZioESSyR+ehbkZotoQpoKJ95akOyYyLOXYvo1tnymy0apzYNkYoYS70t1pMh4qTKuV068VAMMWpxAJr4EnabL/ioc/1kK5V+LCYtmZpz9AK/BJZ
 zJWcHoHW
 vbtc+5girekeVGLguRmNec0nstVuagFn3vBAhCC1UznPyi9QbuuQPlLHFJLOwT5JuHrYinV4LhK1f1wl5tjyKX2hIPMOD0u16nKS+/gNgzm8/hiEHUIWZGtjS3VNviDfe9rIgkwoskjsmQTRiMpKxAc9BK6PyC7jUd6A2SU8w5pqaDb+Fj1NrxZgyyOiVJXefCfdsuYuH9zeAy41j95XcoM4M9UUCqDI8a13OIxp5xGzf91wLwdBvGH6hrzvxifPO22UYjJSi2h5FMIn8T0GLfjLx7ZZJagNySiPZffnW4lDIUZKDbOD/6uc50I/1kKbAzAdj8yow/0wbJbQnKsxBZguwywrt/4CmpdkvquhD+WGIuPeAKXqR8iFvLpXVYMqo/pQeLhEFpzM3jTs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >
> > If ZSWAP_MAX_BATCH_SIZE is set to 8 and there is no hardware batching,
> > compression is done with a step size of 1. If the hardware step size is=
 4,
> > compression occurs in two steps. If the hardware step size is 6, the fi=
rst
> > compression uses a step size of 6, and the second uses a step size of 2=
.
> > Do you think this will work?
>
> Hi Barry,
>
> This would be non-optimal from code simplicity and latency perspectives.
> One of the benefits of using the hardware accelerator's "batch parallelis=
m"
> is cost amortization across the batch. We might lose this benefit if we m=
ake
> multiple calls to zswap_compress() to ask the hardware accelerator to
> batch compress in smaller batches. Compression throughput would also
> be sub-optimal.

I guess it wouldn=E2=80=99t be an issue if both ZSWAP_MAX_BATCH_SIZE and
pool->compr_batch_size are powers of two. As you mentioned, we still
gain improvement with ZSWAP_MAX_BATCH_SIZE batching even when
pool->compr_batch_size =3D=3D 1, by compressing pages one by one but
batching other work such as zswap_entries_cache_alloc_batch() ?

>
> In my patch-series, the rule is simple: if an algorithm has specified a
> batch-size, carve out the folio by that "batch-size" # of pages to be
> compressed as a batch in zswap_compress(). This custom batch-size
> is capped at ZSWAP_MAX_BATCH_SIZE.
>
> If an algorithm has not specified a batch-size, the default batch-size
> is 1. In this case, carve out the folio by ZSWAP_MAX_BATCH_SIZE
> # of pages to be compressed as a batch in zswap_compress().

Yes, I understand your rule. However, having two global variables is still
somewhat confusing. It might be clearer to use a single variable with a
comment, since one variable can clearly determine the value of the other.

Can we get the batch_size at runtime based on pool->compr_batch_size?

/*
 * If hardware compression supports batching, we use the hardware step size=
.
 * Otherwise, we use ZSWAP_MAX_BATCH_SIZE for batching, but still compress
 * one page at a time.
 */
batch_size =3D pool->compr_batch_size > 1 ? pool->compr_batch_size :
             ZSWAP_MAX_BATCH_SIZE;

We probably don=E2=80=99t need this if both pool->compr_batch_size and
ZSWAP_MAX_BATCH_SIZE are powers of two?

>
> >
> > I don=E2=80=99t quite understand why you want to save
> > ZSWAP_MAX_BATCH_SIZE - X resources, since even without hardware
> > batching
> > you are still allocating all ZSWAP_MAX_BATCH_SIZE resources. This is th=
e
> > case for all platforms except yours.
>
> Not sure I understand.. Just to clarify, this is not done to save on reso=
urces,
> rather for the reasons stated above.
>
> We are already saving on resources by only allocating only
> "pool->compr_batch_size" number of resources
> (*not* ZSWAP_MAX_BATCH_SIZE resources):
>
>         pool->compr_batch_size =3D min(ZSWAP_MAX_BATCH_SIZE,
>                                      crypto_acomp_batch_size(acomp_ctx->a=
comp));
>
> For non-Intel platforms, this means only 1 dst buffer is allocated, as
> explained in the commit log for this patch.

you are right. I misunderstood your code :-)

>
> " A "u8 compr_batch_size" member is added to "struct zswap_pool", as per
> Yosry's suggestion. pool->compr_batch_size is set as the minimum of the
> compressor's max batch-size and ZSWAP_MAX_BATCH_SIZE. Accordingly, it
> proceeds to allocate the necessary compression dst buffers in the
> per-CPU acomp_ctx."

This is fine, but it still doesn=E2=80=99t provide a strong reason for havi=
ng
two global variables when one can fully determine the value of the other.

Thanks
Barry

