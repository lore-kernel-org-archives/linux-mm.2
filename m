Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4E1D60A2602
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=O0gCazLU
Received: by kanga.kvack.org (Postfix)
	id B060C6B00EF; Fri, 20 Nov 2026 20:05:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADCFB6B05B0; Fri, 20 Nov 2026 20:05:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F2D46B05B3; Fri, 20 Nov 2026 20:05:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 700546B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:05:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E054716029F
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:05:01 +0000 (UTC)
X-FDA: 85457332002.20.4ECB5E1
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id D9E9F14000B
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:04:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=O0gCazLU;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795223100;
	b=bHb+hBRVmu72FXh0J/nIC6uAbD4v3d16lwDAadkHXdXyzrvqw4dPbP23KpT+axz+AGiCyG
	oOXp2m4cs4gXbYYP9Fgjs3nsWSwzZt8TEkqG6oKiMOWqKHu6j/yUMQJUUKRGjHuzCOpfna
	pe50LaPgA8LEk/V/TL2AyuqCHxiIYqg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eh52j9Q/RVKuR5bJt/KT+uWkjFJZmV3tU4pEpDhX5T0=;
	b=yqF4sFBD2LGsyi+zEAVZ9g8i6mfuFdktGzi+FrFHxGDwb2EXnkCao9w07mqS11VewjT6Hy
	vGtOkKPXFCoPTPRzxQo/dmzw6NjXBBAWkyp05X2/mJU+m6B2pd0KcOF2M743xswIrJLoHs
	Oj25MaZCMeEWacKYmjxhZ5/wjChomzM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=O0gCazLU;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5c14470729eso1253357e87.2
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:04:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795223098; cv=none;
        d=google.com; s=arc-20260327;
        b=iLG1eOk468XtOSJXsqbuPeyDdlFO3bwBbOEt+Rz2zZLtSgdLladrV/oOw2ti1QkoeP
         PvAJyRvyzImC8pVd9pgbqP9MuSgeIRLRKd1TQHgdFQDPM4jKzHz19bUknyonsjcdGSKg
         AejLwEQEoMpIwfAwsH43XcKM/0VMDKnmpERonTFjbX5J8WBRGdqNmmUoeZRNcaq9D4CA
         yl73YzVz5VDBJFnhkzvFllEC66zs/G5YnI2X+bnjSUAN9IeAKH/PmXiEP1u6hUPJtuak
         rHImh1kptGxTQvXr2Kr/cWTG0SbG8TU/OwfLNsJ7osI8fz2qNJtZJ8CptBHMcx2QiFe2
         cpIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Eh52j9Q/RVKuR5bJt/KT+uWkjFJZmV3tU4pEpDhX5T0=;
        fh=T4kvpKl1WbjCygASWd204bD9g1fmTAFg6OfVhOoCntA=;
        b=eYTF6K1Jcw6Nzfep6k35w+/S2ffSOly1ySoNg+u81TRpuXJudQIKCDDbC1DmGrmLvF
         x9+msSDn1Ox3SFFADhRAC62EgGMRnzaVC0DuzOgjOLIzWEcF/SFNJCa2C2mZ0lIOfs4O
         NLO98MAw7mhcsaLKumde0fe2GMSfDOQ6Wj8r7+zLTrybyHvDR5R0vNVFs6k8n0uCRkAC
         IFYjt3o0plyJI1+ERMpU2RdZvo3elq7wdSZUfPzyPLYuopR+kx+53TuvkE62C6gH2f3J
         GWD7TMzws1sujh3mcpqmi5+h5p3HzdMZKwleMMRnrecqIc2z8EOg8mtnPNP7i6Mt6gjV
         9ihA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795223098; x=1795827898; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Eh52j9Q/RVKuR5bJt/KT+uWkjFJZmV3tU4pEpDhX5T0=;
        b=O0gCazLUWNi2hz0gYYQCgW5LsRLOQy+2oP/krBXI/Cv6Qx+AulQpC1WJdzILUk2oKz
         MKo4WqTE4LfH1CAx9WfFuZBLD2I13MIcAcZuZSa7Ke1AYt8NqodaedG7qgcsIgU5JsTR
         In6R8sS2oyR7MYmdEiomE6OuFrFPYlzGJ4Zp/SW3b2tZeX3+/CvMndWRhcKDPr+qnoVO
         mDJsPdJmvFbHPWqv9i7wYowsDo5eVEA7SLxtePzMJ7PI/HWWUls6aP8JFdtc5Bctf/bF
         Icy+6rEVLwcFVjR7TQoGFKvlNYumK20pB96gDitTbp9pBZNesHqyYuUGzxoxGsv8ZnuL
         sBGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795223098; x=1795827898;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Eh52j9Q/RVKuR5bJt/KT+uWkjFJZmV3tU4pEpDhX5T0=;
        b=z8dYRf+eE8iFr4pEygKxOwcU3EeQ2Ek76ENlif/59zhYdAYuKZZlLuG4tJ7f4OZqcK
         keMyVP+NFdZ+UR+jdFvRYTzJU6KJEGugnwxvgyC60tLU06m0bPgSOMmSodhT2K3Drr3f
         HwBt7qv6e65lIFGA4CkLxEVrAEbSIJFFXns6DuCIMsISUfiIBGET/guqE1BRW2ytovdL
         bfRjodXaLSasRbteqkRVT2lG3ux4Au5Zv1te3C9dpYdYZSTBzqb+mclAxwtSGfxNjZuv
         +I2M3r53jgVr1o+g+Qs/7UTWPwqkToFUbLyuphJhsyg34AnlVaySHX4PeftsbHJ1QUw/
         sBRw==
X-Forwarded-Encrypted: i=1; AL+hErHHCil9Dz3UuvzUlGGUdpvhCaCq6/RrQqUzwMYQhO5ogzTNAkLmqiKWbBRKmzMCaacpxaI2OT52GQ==@kvack.org
X-Gm-Message-State: APuU4Z/dgjFLa/aCXfORQ9HACOjK/QFoJ5lU+IyYusc9Sa6lqo7SKNoo
	TUo9/NHqMqlm1aYmkBTuu61goNzxeale0qAvgCZ3H7xd4JOT6Cedeu6QyGf4VBnMlMTPAi9CFIH
	52zHSWZQ5sBF9m5twyKZHnL2pCQmM0VQ=
X-Gm-Gg: AZFdTZdCaTwT1WptCAD0n1O/jIM/Qa4qN2+O8dxrxErWFcz7YipI4oXM965gG9st7HV
	z0C+dcJ3RiM43PtE2ZpdYo3LDHkGWLnNQm0YNdQ2dtBqAgFPLcnmNhEU1/jzJ6vIbAZ1cSWAEo3
	nop5Hk0RBmRba4YvCvZPWqPtPEYS9KTfLF+HI2mPKI5XXkVdLnehMIdnmczEBQLeHDnsBK7KBAI
	UaeXhWPzvor/2DAQpEUNB7wRDZTU6YKvcHARZz/1gLtrM1fwya/jEsUN4Ndaak/cMAUFLBlWv2D
	Xrc4TvYb/9lzvUsz8utr4HLIap/uMh9KnrRxCVKbl1uboKI/Abn9RkT50avRiqZFDNou2NTiQig
	UmI6JcfQ2GPLsYuf26wJ/N9q0W5ocguA34syZ
X-Received: by 2002:a05:6512:3d24:b0:5c1:4c4b:6b68 with SMTP id
 2adb3069b0e04-5c1bc802f62mr1541232e87.31.1795223097637; Fri, 20 Nov 2026
 17:04:57 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com> <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
In-Reply-To: <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 17:04:45 -0800
X-Gm-Features: Aa3M54qT3ZtjD22EaLRJUtBbQryoUqmzjt-YjHsfdzKJaoAYzbDgBoEjNV0-lBI
Message-ID: <CACpmpod+crauW5g5fiU-2qg-GTg6roSi6j10Wg4cPR3qnni-PQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] Batched zswap_store() framework with compression batching
To: Nhat Pham <nphamcs@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: y6uin6fpsky9xo7wgzehnqhfb9b8b4oe
X-Rspamd-Queue-Id: D9E9F14000B
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795223099-926912
X-HE-Meta: U2FsdGVkX18hd/TT13IOQpb82i/VTSyXx+Hw6wNtelmRe6vWZuurUi8A2Z9b9cCl9R6yMsacm53imYH243cm3DJSGdXC8AkaY8gCanazV/dVIyMoObU4Mz9tIWJmvyGT5wR/OLtO5svZDus1nJmS+wmbw7G5msk1LS8KHW2M9yGYa37hy9LQJRMzM094IkjhKC8TS4LahgKBXnZUpqlDk2IO0TS3+OLUH+U0Iqi3LQX/idhhwC1/qqKvQkGmfj+syB2l5ILn5LwElJZD0e9L9Itkl93rEcTY9X746Mb21kADt58ItsZQcIPCP149pUdvY2+EFox4475u9hGx5UkQzySXHTCwpkKM/vE229i+wYGp5YM2H4xOLjsJq6Fmd1GmsHsC7FQGk8gpY5o3I3qNIvGqjPuknp66GmzL1isOW6JosNexGokgiYpafVCRQHO1EqmwbByCLZwhPhV294T8ErhP01Fg54bjOEpnRrqxTZ2RQGFC+eqYDACOgiMmaMl6LX+Z+hKxOk+zZqdOHzDA4YYLQGCc/qJYAycsI9Dd4IuhqvZCcghB8KFewXYqrR/91KeorE6m3RfbwH3eHdPsI4nEFu2K+t7Yn+f0UvqloMjDZoVvk5q15udcN8NAa8zjtACYo62ePApZchFdZuQ1HKo3F/5dl930RcxDpiKBO4Wyh0OetzON/SCN2nDanCy0/ewuTfH5g6gf9CtygRRYZXPmtkdQ4ZzPuaXFK082TsspbwyeZWCmza3ZfC/siHHjr3PhCkx5d8DQejf8Uh4YDwAwQb9u+D4PWo2e9cfVb1neprIguZI0Y+1SIBM1ed74LEtet4gVmDwDBF6XQN/qOOOCtxjS/Zcb/A0YX8CzxlK9pM1zB7HcT6dc4gt8U1rEsO1/Ia5Rb/hJ2N4xrnRWdujaezyuI7sApDlexhU1pbpf957gsB7nY87luK8za8H8Wvp9WpiuMmHHSAdJrTu
 JtsRrVTF
 Wo7Y5qMOE42+m9m3Mvg9GhJeIMAJhivDk9FhUSem/DDWwIWWlQZMiCYV/w2CXAYVxNjkkm9DnY/NXMRHLuRaTlgYOgJ6DDnJEwoYkdxd/3M+1gzeVvQa6b50smDmBc70SMmcIcw/xuRrzbPIwZ1Ub/wYV4C3HEt/rRSph9faFeSLNGQ4AnxXZ+O3btoCjYWNXFUPdVq4pPRF1vcvDSp1Yhths67H82cxKR4mfiI9oRDKrFWMU9/uHOAweevSxsrfmo8vM2fHBVBefDz7XCgWkdlHd1e0sFukQorHggV45ijdfXDvC/2xAQZZnPf1WfA/wuTjffuKmar4xQY6H81zBImKrw1c+S2kPT1LVJwRAJAQSs6clZquFPi5CPMvSLow6QrNNOVbwJr1m0+/ZKp5njxmCNgeVSVzI5iaRgYjGPwhWJUv2zmcMTxoXa1ZcX1x26aRANhaebGHFGfbwVcC1Lm6K1LgFQa1YJYLmPx7JqU7fYCj+Z6MpjX9Eb7OXmcfQoqyD1WRasrejEO5g8mDv5n6GPe5FtkI7fwWNEAy01pWisLelXCDFYdaNOfpY414OPxyZMkXSuPAT9q13pzv3r/YU8F+JangAWKeUWjHPiTay8rU6vosfF7fTjr1+Ss0zXq5fkdBrosi8uzbTktfgqsyLIexJXcUmdVg2xJ52EkEgkbMPTvLCeHtLLioHsiErCc43tngqKdM+p6NJ2CCrRf942Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 3:16=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> >
> > v4: Batched zswap_store() framework with compression batching
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
> > attribution while signing off v4 of this series with my current address=
.
> >
> > The main focus of v4 was to establish a performance measurement methodo=
logy to
> > quantify the benefits to high level metrics by using zswap compression
> > batching. This was done using an Intel Sapphire Rapids bare-metal insta=
nce with
> > 48 physical cores and by running "usemem30", i.e., 30 concurrent usemem
> > processes, each of which allocates 10G, in a 150G memory.high contraine=
d cgroup,
> > for 10 iterations. The environment was set up to minimize performance j=
itter so
> > we can understand the system-level/workload-level advantages of zswap
> > compression batching when running workloads at scale.
> >
> > To summarize the main contribution of this patch series: Batching is in=
troduced
> > in zswap_store() of large folios: we carve out a large folio into batch=
es of
> > ZSWAP_MAX_BATCH_SIZE (4 pages) for software compressors, and store each
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
> > Performance testing: usemem30 with 100% over-commit:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > Validation was done with mm-unstable as of 11-17-2026 (Baseline: commit
> > 866f761fd414) and with this patch series.
> >
> > v4 was validated on an Intel Xeon Sapphire Rapids bare-metal instance w=
ith
> > 48 cores.
> >
> >  Bare-metal instance specs:
> >  --------------------------
> >  - 48 physical cores
> >  - 190G RAM
> >  - 200G SWAP disk partition
> >
> >  Workload: 30 concurrent usemem processes, each allocates 10G:
> >  -------------------------------------------------------------
> >  The vm-scalability "usemem" test (unmodified version) was run in a
> >  cgroup with memory.high fixed at 150G. There is no swap limit set for =
the
> >  cgroup.
> >
> >  To quantify the performance benefit of zswap compress batching at scal=
e,
> >  30 usemem processes were run ("usemem30"), each allocating and writing=
 10G of
> >  memory, and sleeping for 10 sec before exiting.
> >
> >   usemem -w -O -b 5 -s 10 -n 30 10g
> >   echo 0 > /sys/module/zswap/parameters/shrinker_enabled
> >
> >  Performance validation methodology:
> >  -----------------------------------
> >  These settings were used to minimize variation:
> >
> >  - All cores were fixed to run at 2.4GHz with "performance" scaling gov=
ernor.
> >  - Turbo boost was disabled.
> >  - CPU power-saving C-states restricted with:
> >
> >      GRUB_CMDLINE_LINUX_DEFAULT=3D"intel_idle.max_cstate=3D1 processor.=
max_cstate=3D1"
> >
> >  The usemem30 experiments were run with the baseline mm-unstable as of
> >  11-17-2026 (commit 866f761fd414) and with this patch-series.
> >
> >  After booting into each kernel:
> >
> >   1) Constrain the cgroup's memory.high to 150G.
> >
> >   2) Run 2 warm-up iterations of usemem30. Don't use this data for benc=
hmarking
> >      since sys time typically skews higher for initial runs.
> >
> >   3) Next, run 10 benchmarking iterations of usemem30:
> >      - Log these high-level metrics: Sys time and individual usemem thr=
oughput.
> >
> >   4) Sys time and Throughput metrics were gathered for three mTHP setti=
ngs:
> >
> >      - 2048kB
> >      - 1024kB
> >      - 64kB
> >
> >   5) Benchmark summary data includes Sys time and Throughput components=
 from the
> >      10 iterations of usemem30:
> >
> >      - Total Samples
> >      - Mean Value
> >      - Std Deviation
> >      - CoV (Variance): Coefficient of variation (relative standard devi=
ation)
> >        measures spread relative to the mean rather than statistical var=
iance.
> >
> >  An LLM was used to help generate the benchmarking and data processing =
scripts.
> >
> > usemem30 Benchmarking Summary:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> >
> >  ---------------------------------------------------
> >     Improvement with v4 zswap compress batching
> >  ---------------------------------------------------
> >   mTHP enabled:       2048kB     1024kB       64kB
> >  ---------------------------------------------------
> >       Sys time:      -13.87%     -2.64%     -1.72%
> >     Throughput:       +3.85%     +0.42%     +1.31%
> >  ---------------------------------------------------
>
> Have you tried perf-ing the store path to see what was the overhead
> source (before and after this optimization)? I'm curious.
>
> Mostly LGTM - still taking a look...

Thanks Nhat, for reviewing the code and providing valuable feedback!
Thanks also for your time.

Forgot to mention: ZSTD is the zswap compressor used. I will also
reply to your comment in the other email, along with more setup
details.
All zswap parameters (max pool percent, shrinker) are defaults.

I did analyze the performance of the store path using bpftrace to
understand what was the overhead source before and after this
optimization. My experiments used PMD folios to maximize the zswap
store/compress batching samples so the traces are helpful in
understanding how the optimizations are eliminating overhead.
Although, this was done with v3 and my earlier, memory constrained
QEMU setup running on Chromebook/Crostini.

These are the bpftrace p50/p95/p99 latencies. The labels mean:

 "zswap_store_higher_order_folio":
    zswap_store() of PMD folios.

 "zswap_store_order0_folio":
    zswap_store() of order-0 folios.

 "zswap_batch_compress_per_page":
    zswap_compress() per-page latency of store batches generated from PMD
    folios.

 "zswap_single_compress_per_page":
    zswap_compress() per-page latency of order-0 folios.

 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
   usemem PMD THP BPFTRACE
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
           Baseline           zswap           zswap          Change    Chan=
ge
        mm-unstable           store        compress            with      wi=
th
         10-25-2026        batching        batching        compress  compre=
ss
                        (patch 6-7)       (patch 8)        batching  batchi=
ng
                                                               (ns)       %
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
  zswap_store_order0_folio (ns):
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
  p50        39,631          37,538          37,765          -1,866    -4.7=
1%
  p95        53,088          49,690          49,349          -3,739    -7.0=
4%
  p99        65,065          63,529          57,404          -7,661   -11.7=
7%
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
  zswap_store_higher_order_folio (ns):
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
  p50    21,460,366      21,201,411      20,383,233      -1,077,133    -5.0=
2%
  p95    25,975,341      27,558,253      25,045,350        -929,991    -3.5=
8%
  p99    29,538,493      61,926,648      27,184,835      -2,353,658    -7.9=
7%
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
  zswap_single_compress_per_page (ns):
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
  p50        37,545          39,320          37,218            -327    -0.8=
7%
  p95        51,549          66,503          51,481             -68    -0.1=
3%
  p99        89,866         134,854          87,091          -2,775    -3.0=
9%
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
  zswap_batch_compress_per_page (ns):
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
  p50                                        40,493           2,948     7.8=
5%
  p95                                        56,944           5,395    10.4=
7%
  p99                                        76,242         -13,624   -15.1=
6%
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

Analysis:
=3D=3D=3D=3D=3D=3D=3D=3D=3D

 The batching of zswap_store() phases, and compress batching
optimizations benefit zswap_store() and zswap_compress_per_page()
median and tail latencies
 for PMD folios and base 4K folios. The benefits are attributable
firstly to the store batching framework added in patches 6-7, that is
fully utilized to improve
 zswap_compress() latency by giving it a batch of pages to be compressed.

Gains seen from store batching alone (patches 6-7) are due to:

1) Bulk allocating the zswap entries for the batch,
2) Minimizing computes by getting the wb_enabled once per PMD folio,
rather than per-page,
3) Fewer function calls: zswap_store_pages() called once every 4
pages, rather than per-page.

Furthermore, the batch compression added in patch 8 improves latency
significantly, even more than that obtained by store batching alone,
for these reasons:

The overall approach for making the zswap_store() code more efficient, has =
been:

a) Minimize computes, especially conditionals. For e.g. crypto API
that set things up for a batch, rather than for a page.
b) The working set is kept focused on batch-centric data pertaining to
a handful of operations on the batch, to minimize cache evictions and
benefit from cache locality.
c) Each block of compute in zswap_compress() is doing checks/state
changes for a batch, which I believe simplifies the architecture and
allows us to build further optimizations.

Specifically:

1) Per-CPU sg_table with ZSWAP_MAX_BATCH_SIZE scatterlists that are
statically mapped to compression dst buffers for that CPU, thereby
minimizing local SG lists initialization, and using compact new
crypto_acomp API introduced in patches 1-4 that set up an acomp_req's
src/dst to be SG lists.

2) Patch 6 allocates ZSWAP_MAX_BATCH_SIZE destination buffers in the
per-CPU acomp_ctx, for an added memory overhead of ~12 KB per-CPU.
However, it allows us to not have to immediately call zs_store() with
the compressed buffer, but instead continue to compress the next page.
I haven't quantified this with perf event counters, but my guess is
this minimizes cache evictions because we are focused on running a
focused set of computes on a specific data set.

3) A one-shot zswap_update_entries() does all the zsmalloc handle
allocation and copying for the batch.

4) Bulk accounting for the batch instead of per-page.

5) Single point error-handling in zswap_store_pages() to avoid
conditionals, so as to not wash away batching gains.

6) By making zswap_compress() more efficient, we are able to lock the
comp mutex per batch of ZSWAP_MAX_BATCH_SIZE (4) pages instead of
per-page.

7) Optimize most-likely-to-succeed fast paths, move conditionals and
error processing to less-likely code (which is also consolidated to a
single error handling label).

8) Don't proceed to next stage of batch processing until this stage is
successful for its specific functionality scope. This minimizes
computes by avoiding if-then-else checks per-page.

The bpftraces highlight exceptions in p50/p95 batch compress latencies
(normalized per-page), even though the p99 batch compress latency
improves by 15% over mm-unstable. Batch compress latency can be
optimized further in subsequent patches. The batching framework
established in this series allows us to make locking and
bulk-processing improvements in each stage of zswap_store().

Please feel free to share any additional insights you may have as you
review the code!

Thanks,
Kanchana

