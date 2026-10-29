Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9866A606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bBn1Lv2S
Received: by kanga.kvack.org (Postfix)
	id A71746B05B4; Thu, 29 Oct 2026 17:09:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48586B05B5; Thu, 29 Oct 2026 17:09:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95DEF6B05B6; Thu, 29 Oct 2026 17:09:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BFD16B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:09:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0AB231A0526
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:09:26 +0000 (UTC)
X-FDA: 85376904732.16.CF1C9E7
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 115EF180008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:09:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bBn1Lv2S;
	spf=pass (imf24.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793308164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7kYdsdZrgEIyd8GSLnE1/erB4mjt9X79rFFJFtO64kU=;
	b=l2NyoAD+xCbDWnuP4NkANedsAh9SDZnfmJ2rueRXEAYpNShIY1hpkxh0xshQZmcvs9UPwM
	tqj9uKI9VYB3WJkdo3OEKn0j5spij7fj38N/hzUXxlbemE6iWoBBRCan8Zh+gglSwaNKkR
	RvAP3Wd5V5fQS0q4a0EWB8iUSWq5jVs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793308164;
	b=uPJczlGBqS0gcxaTqEE3DRtgSvIzi9HrXn7lSi5hTwK9gBFYE1p9xwAVa4xPpP+4d7MFMF
	D4MkHzOLhTIj3i050eNhZQryIDdpTie4FeUiVkPWQyyk83kO8iy/fd2ho88QKoUqNbX5rM
	LJSxQavwQgrs05X7gzCHCpUafjcutnY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bBn1Lv2S;
	spf=pass (imf24.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3ac91f5aa89so893391fa.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:09:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793308162; cv=none;
        d=google.com; s=arc-20260327;
        b=Fxxn8MRbQQaIpHND7IR1qtqyFo7CkiZWCm3uHOfmZI83HuYjKE8UdDNDg3pNnNRUTt
         Xn4xXdvBjHjEzt5tfxkb3Tbtaju2Z/L2WATqDfJ21AgDvZmWuozAh+1mnnIOh2xVO1NT
         9Fq0zDfHtLVkCJHDX6GSMlCRKZOKfDdKkDdr6h+Q5aExpHwdX3GjdvILT5pr8BMd1f9Q
         hYoVXC2vT0NHQb00BYDTdQL5sCZLZxzzJz1+1mYQ9JkituR+CFxILxr8N2MHQ7CAPR0G
         zy3fnnRaKMDsBtigsK2m+fpyxyJhTaQJKK3cNUJfsWbneT3F9E9UP66+N8ZcjtwKQGAG
         6QVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7kYdsdZrgEIyd8GSLnE1/erB4mjt9X79rFFJFtO64kU=;
        fh=VbQowOPwui2vmIHjsmz89qFREDGy8KnjmLL26MsBSco=;
        b=BmbjUJDZ0XhAlKvbJ4BqOA3ZJu7rqiydm1unrwyBeXQNIe7CyhQCbinZrEPKmRviym
         SIP86lgV/8X/mKLAW9Ui25Lf2HKp3QdvFObzSpgIDOXc2Mhx9ZASdpAvktDSbP/peWlS
         3OjtnHfrY9ajJaX7y5HkhOqVMBmpoboxLGLzQ8ccf5wxcUN1Gz958N/NlaksvaL4I7OD
         Sd3NbGy7xjPFJh5dWAdlGL+XpVHEhHAx+/AfwgP923OOrjeHQpgygRiEP9agOblt6e3p
         I4xKDvWhk8kcCspYwQgR5y8r6G4bzyDfIehi9ZAaMwTPuDI1uiVn3kQUi+DWKbSVlRkg
         s6AA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793308162; x=1793912962; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7kYdsdZrgEIyd8GSLnE1/erB4mjt9X79rFFJFtO64kU=;
        b=bBn1Lv2S35tO3wIswzAPUar0tRal7VjF0VflPTaC2RKDppYxfOUJdgjBwP105/iFxu
         DTvSzvltBVlzNcjVmzAu5hZ8/tVfK6f0QXjHDEOd6CHx0OSUP8tueU6ToVKbpomroyY6
         rst9kgxhqf/VW4Egw6EraTpjWQ1+QHV3+eIPM4qOVppjmr4nHyFVUf8tEjCsliJYgi5a
         XlKvXEEqYv8pVGgf+US7AHZsF+Jm/x78sb9LtqZRR46ZQzx5f+gJDsFNAUyEYKesYssI
         YH+w+NGwEX3AhATflWt9sfrip0aR20riyS6KQY96sPk6U2xpsyNUBBjmWh1RTradegEZ
         nTgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793308162; x=1793912962;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7kYdsdZrgEIyd8GSLnE1/erB4mjt9X79rFFJFtO64kU=;
        b=KB9mgFCMIM+9SZTP4s8+/6e+0jP1aQWbQKN6Dg+9RvM1fGs39DLwLO9+QqAvU2zJ/C
         61esQK5jnoXr0WN7dsD2vAZisXstvpw8Od5N6eKIRSDV7Pg1b6J9QeDzleGZ8LwgU5of
         1yFLLUHt2m2jCVFjF/UnIPaxkFFD3s5EoiTMrCNgJK2sRgmBRNMtcY2KdVW4cRPdWgEj
         Mcso4RNmd+TY3ARDfSEInIHJ0CgciJ5hCZmviYsYJAPrbCE/2Ov+J7FcVnpdGPlFNMal
         FX/ZrMNia63bcLDIqabGQ/NFV+GNgXH1toSDR3CSnr6LwTIFSa+9zmBb1kmQ2YpAm7WI
         avfQ==
X-Forwarded-Encrypted: i=1; AKwUvBw+YXtcdBZ69aKznGev8ZjNXSaKdQyIzX9R4qAZqX9wZmBHjz9zkCLKgYZSQzOZN1eydP8b/73VTg==@kvack.org
X-Gm-Message-State: AFq9FYIsUIAHBHj/h43pHqqtMR+LmWgqO9R1BYuSiaE1N4ZSfOQ/zO0Y
	Fhsbad+pQPDKrm+6NjSRcN+8zrLrfdem/I8fJuXsvAr76u0MJ4GU7pWvgbhMaBNPYmtdHGS6ell
	Gx3Jr5qp3ZaAj2smoPXWsu4Cz9yWL5qk=
X-Gm-Gg: AYBFou1FXQ22RImEKCmi5bJDLk7s74cniGrb58sR9rP8QPAX76tS9l0hU9NGxMbH493
	ky/s/MiiBMqpKkHXHeKZrI8+/oivgZBDBWBVIzQl/zgwGBHTf5v9OS3Y0b1Z+PkW8dK4mJK5huI
	UXV1zpOX/6kCYqqXHyabnzKrtXBVwHeoEC9/DTh7ixO6oYl3jA43ZDSOeeaY6maBxbAOjwUUTy+
	kyDFDmPyovMCWAID2wmmzo3rT3rORHRKK48NVqu0rKf7neBeexjFZRrf0nCziO7KyXvMOBHMmWq
	wttRe9wn67Ah0sanzn6s2y/0U/fowtMufJBc9/ToYBgHhp5MaG4W71tTRMXshPxK2UeXDmFc5Pp
	MlApURqsT3m4/rSlIuIYLnrUwPakO2b8W/Ggs
X-Received: by 2002:a05:6512:a94:b0:5bf:b246:87a2 with SMTP id
 2adb3069b0e04-5bfd957b610mr43125e87.10.1793308161793; Thu, 29 Oct 2026
 14:09:21 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com> <auOZBtRqQGzFcbAT@google.com>
In-Reply-To: <auOZBtRqQGzFcbAT@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 29 Oct 2026 14:09:09 -0700
X-Gm-Features: AclHuK-m7JH-ZqoB-jo0yDD7-BAXHkWcLwROF3ZmF0vmqG3Tfo8M-MSswHjw2Rs
Message-ID: <CACpmpocqHHa4z9hkZ6YEm-wmzMqSX5WpPLfku7Om=NenRq_05Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Batched zswap_store() framework with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 115EF180008
X-Stat-Signature: 8ux1yeumx3rpad3tc4k8wd1g4179qjjr
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793308163-341967
X-HE-Meta: U2FsdGVkX1+BnQ6c80ZhMBrS6Oa9ZSOZF/xAyaieXBW8wqLk9cAFgzfkVLs7gas8E8dKhzffWyYrIf1ULI2smF3mHuk+rJFFVsdPubdYdsdEw1lvzc2wurONjysZEKhxjqxU5yrsdb2oPFV+FZ3dUYnU3nF0fPW+C6475BWU9OkAOG4Ug/HKQF7T9kjwr71F4YXEoGI1T2v4OcXQ0VA7Lrb3WZHl5tPz71IWRh9GAg072O16oKcUJ2IeGviNWd2UFdiarusIEyANsWqlYb4ABR4JyTnJJh76A43E3nK016hMZT8ECRwVPcLdnu6RUof5zKXK+tz603P0ZTPa37isr25LzmSC0cF7CkBL3gIdWpGJ8EV02yDKa4E/m7NtiHlS5IGb5QkEkBirl72rICdYyub9BIoGrpUwidzQ053y1Wh7ug11neovoxi3SVU5U4hNTw/yUoBq48peA6ARK3LT5NOqDw/2X3X5Oamnyot5GPfL3QQzvEUJK6avlEqg5tL4jRhejS90wk/ez0sBEf8tOY3BVLno08scND3gsGx3dhintSPIw7igjB/1MWJAwlTEK95rg3DUDrYo7LkceFeWOl4rUc0tCs3YsoqLBpabsM6yt7HnlIG4rPw7iKoCHCktAAPyyFXRH/uDSptetO80gL0X8k8OwCE0nH60p1ExzdaATJMH1AvMSOCKqgdKD/ljPBSu/YZ5+rbqigOdpWwzuwHnWUWZHas5UL8/zEmMKZaBnYGO0a6zRsw5sEaVNDZu1VMaL/ChmMh12ZnETb7q/oAOQ+pMXrfydPIPazrUh8B4Z9ByyhNKLIT9zrnNlUbIgUvvw5DWMw2laDmlYWPgJjqMpf1k8rjPb0C53dCzwV0IDd+TuZtvZ0p8dGE0u6PO2Z1CYUYwHmL6MXK6oCl/eKWYvtK4sa1GNPQZrO46IZGkL0e2Bo85owCjx54Hp3Miue35glGBkT7DYvO+DpD
 nphNNlO6
 YGF6JEAbdwgs5zzZA47Dy2dOeWY7/a5hA15qMbPI28Y6bubmV84ancWcsaO5k7zttQuwsg1w7xD2gApaD33vVg4sF6QY9GMTI8OV1JSNMQidWBEhMJe9CdrYmXWxDXu1WkBaAvVbso4YMmX+KotQ8T3d2kGNF+Dmk1eOe1/HraMrX2fucG2q1mkwJa+mBroqvvacWpJt/QMSlZStoBd8/Fr046OJ5qNsyx47jUcawmNjZPJFcDW7eQxO2995WuIgeA3Q1Q92MH4jFDA5YEtBjGBNplc8JMfOT3CH/TpqCe/5aHg5cXmfyeMS0AMAxw31Lcb51XTdUM34ym0OHYeNA4wAM81OYb2i9ogYkDMDDzQDznTqjm8kyeYWkKvJCVAxsRWwoECRaAOh5LqKTWgo/lYULjlq5Bpn+AUyOUKU0W/YVie5o46Zpg+ZlnfNRdw9kWGdfYGGMhSrQYGH1gr6Ot7Td3ET1GIUqhkk6FxBznW69oK63Eo3VjVGa41XuesancUki2SRqM/7JWlU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 12:12=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Tue, Oct 27, 2026 at 08:04:55PM -0700, Kanchana P. Sridhar wrote:
> >
> > v2: Batched zswap_store() framework with compression batching
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > This series is a spin-off of "v14: zswap compression batching with opti=
mized
> > iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zsw=
ap
> > compression batching enablers. Resuming work on this series following a=
 gap
> > since v14 (January 2026). Please note that my email address and affilia=
tion have
> > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail=
.com. I
> > have retained the original Intel sign-offs on prior patches for histori=
cal
> > attribution while signing off v2 of this series with my current address=
.
> >
> > The main focus of v2 was to establish a reliable and accurate performan=
ce
> > measurement methodology, that addressed the problems with variation in =
v1. This
> > is accomplished and used to validate v2, by reducing usemem to 2 proces=
ses and
> > enabling PMD THP. As the data shows, we get exactly the same "2048kB-zs=
wpout"
> > counts in the baseline and with this series.
> >
> > To summarize the main contribution of this patch series: Batching is in=
troduced
> > in zswap_store() of large folios: we carve out a large folio into batch=
es of
> > ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store each
> > batch. Moving the fundamental operations that need to be happen to stor=
e a page
> > to now work at the granularity of a batch offers opportunities to optim=
ize them
> > from these perspectives:
> >
> > 1) Utilize existing kernel API that minimize obtaining locks for bulk
> >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
> >
> > 2) We keep the working set for each of the core store functionalities
> >    (alloc/initialize zswap entries, compress pages, store pages in zsma=
lloc,
> >    pool/objcg reference increments, objcg charging) to be focused on a
> >    batch, thereby minimizing cache evictions and benefiting from cache
> >    locality.
> >
> > 3) Along the lines of (1), the main zswap_compress() batching routine o=
btains
> >    the comp_ctx mutex lock once per batch, and releases it after it has
> >    processed all pages in that batch.
> >
> > 4) Any zswap store functionality that works on a batch can potentially =
be
> >    optimized via bulk-processing/parallelized as a next step, to furthe=
r improve
> >    performance.
> >
> > Performance data: usemem with 56% over-commit:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Validation was done with mm-unstable as of 10-25-2026 (Baseline) and wi=
th this
> > patch series. To minimize variation in the data, I made these changes t=
o my
> > performance measurement methodology:
> >
> > 1) Reduced the number of usemem processes to 2. Each process tried to a=
llocate
> >    2400M, in a 3G cgroup memory.high budget, effectively accomplishing =
a 56.25%
> >    over-commit.
> >
> > 2) Increased the runtime of the workload to ~9 minutes by enabling PMD =
THP,
> >    i.e., 2048kB mTHP folios.
> >
> > 3) The use of PMD THP forces zswap_store()/zswap_compress() latency to =
be in the
> >    critical path, and thus enables very reliable measurements with bpft=
race.
> >
> > 4) I used lhist() instead of hist() in bpftrace to gather latencies at =
a finer
> >    level of granularity and accuracy.
> >
> > Testing was done on a Chromebook with a QEMU "vng" VM running in Crosti=
ni.
> >
> > Chromebook Diagnostics reports:
> >   Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
> >   RAM: 16GB
> >
> > vng setup:
> >          Memory: 7G
> >            Swap: 3G
> >     Pinned CPUs: 2 (E-Cores: 2,3)
> >
> > zswap compressor:
> >   ZSTD
> >
> > mTHP enabled:
> >   2048kB (PMD THP)
> >
> > I used the help of an LLM to write the bpftrace data post-processing sc=
ripts
> > that generate latency percentiles.
> >
> > vm-scalability/usemem setup:
> >
> >   cgroup memory.high: 3G
> >   2 usemem processes, each allocates 2400M anonymous memory, reads the
> >   Silesia dataset [2] from a pre-fork-allocated buffer into the 2400M,
> >   writes to each unsigned long in the 2400M, sleeps for 10 sec, then
> >   frees the memory and exits.
> >
> >     usemem -w --read-silesia -O -b 1 -s 10 -n 2 2400M
> >
> >  usemem metrics are reported from a single run after starting the QEMU =
VM.
> >  Further, I have tabulated the bpftrace p50/p95/p99 latencies with thes=
e labels:
> >
> >  "zswap_store_higher_order":
> >     zswap_store() of PMD folios.
> >
> >  "zswap_store_order_0":
> >     zswap_store() of order-0 folios.
> >
> >  "zswap_batch_compress_per_page":
> >     zswap_compress() per-page latency of store batches generated from P=
MD
> >     folios.
> >
> >  "zswap_single_compress_per_page":
> >     zswap_compress() per-page latency of order-0 folios.
> >
> >
> >  ----------------------------------------------------------------------=
------
> >  usemem                       Baseline      zswap        zswap   Change=
 with
> >  PMD THP                   mm-unstable      store     compress      com=
press
> >                             10-25-2026   batching     batching      bat=
ching
> >                                         (patch 6)    (patch 8)         =
 %
> >  ----------------------------------------------------------------------=
------
> >  usemem process 1                6,353      7,240        7,428
> >   Throughput (KB/s)
> >
> >  usemem process 2                6,352      7,236        7,422
> >   Throughput (KB/s)
> >
> >  Average Throughput (KB/s)       6,353      7,238        7,425        1=
7%
> >  ----------------------------------------------------------------------=
------
> >  usemem process 1              484,580    308,903      257,230
> >   Time to free memory (usecs)
> >
> >  usemem process 2              518,928    438,585      446,958
> >   Time to free memory (usecs)
> >
> >  Average Time to               501,754    373,744      352,094       -3=
0%
> >   Free Memory (usecs)
> >  ----------------------------------------------------------------------=
---------
> >
> >  ----------------------------------------------------------------------=
---------
> >  usemem                          Baseline        zswap        zswap    =
   Change
> >  PMD THP                      mm-unstable        store     compress    =
     with
> >  BPFTRACE                      10-25-2026     batching     batching    =
 compress
> >                                              (patch 6)    (patch 8)    =
 batching
> >                                                                        =
     (ns)
> >  ----------------------------------------------------------------------=
---------
> >  zswap_batch_compress_per_page (ns):
> >                          p50                                 40,086    =
    1,569
> >                          p95                                 54,689    =
  -64,505
> >                          p99                                 83,248    =
  -88,488
> >  ----------------------------------------------------------------------=
---------
> >  zswap_single_compress_per_page (ns):
> >                          p50       38,517       38,352       36,650    =
   -1,867
> >                          p95      119,194      121,174      133,678    =
   14,484
> >                          p99      171,736      158,601      169,010    =
   -2,726
> >  ----------------------------------------------------------------------=
---------
> >  zswap_store_higher_order (ns):
> >                          p50   21,012,222   21,322,885   20,176,667    =
 -835,556
> >                          p95   25,643,500   26,204,375   24,485,000   -=
1,158,500
> >                          p99   28,567,400   38,577,750   26,158,000   -=
2,409,400
> >  ----------------------------------------------------------------------=
---------
> >  zswap_store_order_0 (ns):
> >                          p50       37,601       36,994       37,568    =
      -33
> >                          p95      123,731      137,034      128,366    =
    4,635
> >                          p99      159,965      169,282      175,618    =
   15,653
> >  ----------------------------------------------------------------------=
---------
> >  vmstat summary:
> >  ----------------------------------------------------------------------=
---------
> >  zswpin                         1,104,226      993,412    1,091,146
> >  zswpout                        1,688,181    1,582,664    1,669,671
> >  2048kB-alloc                       2,500        2,505        2,500
> >  2048kB-zswpout                     1,535        1,535        1,535
> >  2048kB-swpout-fallback               927          929          875
> >  ----------------------------------------------------------------------=
---------
> >
> >  Detailed vmstat & zswap stats after workload finishes:
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> >
> >  ------------------------------------------------------
> >  usemem                          Baseline        zswap
> >  PMD THP                      mm-unstable     compress
> >                                10-25-2026     batching
> >                                              (patch 8)
> >
> >  ------------------------------------------------------
> >  vmstat:
> >  ------------------------------------------------------
> >  pswpin                               0              0
> >  pswpout                              0              0
> >  thp_swpout                           0              0
> >  thp_swpout_fallback                927            875
> >  swpin_zero                           0              0
> >  swpout_zero                          0              0
> >  zswpin                       1,104,226      1,091,146
> >  zswpout                      1,688,181      1,669,671
> >  zswpwb                               0              0
> >  nrswpin                              0              0
> >  nrswpout                             0              0
> >  pgmajfault                     173,554        173,774
> >  nr_free_pages                1,753,879      1,755,195
> >  nr_free_pages_blocks         1,651,712      1,667,072
> >  2048kB-alloc                     2,500          2,500
> >  2048kB-zswpout                   1,535          1,535
> >  2048kB-swpout                        0              0
> >  2048kB-swpout-fallback             927            875
> >  2048kB-swpin                         0              0
> >  memory.current                 352,256        499,712
> >  memory.swap.current                  0              0
> >  ------------------------------------------------------
> >  zswap stats:
> >  ------------------------------------------------------
> >  pool_limit_hit                       0              0
> >  written_back_pages                   0              0
> >  reject_alloc_fail                    0              0
> >  reject_kmemcache_fail                0              0
> >  reject_reclaim_fail                  0              0
> >  reject_compress_fail                 0              0
> >  reject_compress_poor                 0              0
> >  decompress_fail                      0              0
> >  stored_incompressible_pages          0              0
> >  stored_pages                         0              0
> >  pool_total_size                      0              0
> >  ------------------------------------------------------
>
> As mentioned in the previous version, I cannot reproduce these results,
> mainly because the noise is too high. Digging a bit deeper, it's because
> the throttling from memory.high varies. Hacking in a change to make
> calculate_high_delay() always return 0 (no memory.high stalls) paints a
> clearer picture about throughput improvements from the series up to
> patch 6 and patch 8. With that, I see 1-2% improvement in throughput
> with patch 6, and almost no improvement with patch 8 on top. Similarly,
> for zswap store latency for high-order folios, I see a slight (~1-2%)
> improvement with patch 6, but almost none with patch 8 on top.

Thanks Yosry, for sharing this. Let me also see if I can replicate
this hack on my end, and its impact on latency.

>
> In order to make meaningful progress, can you send patches 5-6
> separately? I assume that 1-4 are prep for 7-8, so 5-6 are standalone. I
> also think patch 6 will be simplified if we drop the prep work for
> patches 7-8?

It shouldn't be a problem to send patches 5-6 separately, but I would
like to measure the latency impact with the hack and confirm the
latency results in my environment, so we can figure out a plan on how
to proceed. Patches 5-6 alone only achieve bulk allocation of
zswap_entries. It could be possible to bundle in patch 8, which
generalizes the store batching framework, but let's revisit on how
best to make meaningful progress.

Patches 5-6 have a dependency on the batch_size for allocating
acomp_ctx resources, which is for the compress batching improvements
in patch 7-8.

>
> Also, PTAL at Sashiko reviews before respinning.

Sure.

Thanks,
Kanchana

