Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE95606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G5T8AON7
Received: by kanga.kvack.org (Postfix)
	id 5D7A16B02E8; Thu, 22 Oct 2026 18:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 589086B02ED; Thu, 22 Oct 2026 18:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49F346B02EF; Thu, 22 Oct 2026 18:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 136476B02E8
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:20:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88FAB1C1CB3
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:20:00 +0000 (UTC)
X-FDA: 85351680960.17.4DA347B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 97A504000A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:19:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G5T8AON7;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792707598;
	b=hcOqW3ls5gXeMSU9UG+8d3aGuky5uOvXObkgrb5cGfpIL4vt6/DKECFwesIwrESp61FcCE
	SkiB+kiDHGHhywGYXtuH0m4f/Fxx/AZLliIOxCA1+YTNzY1wIMP08puzavdUmc3lWN+AM6
	OErKULL2vW5EWWLAkuOoJtI4xBBpG+M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G5T8AON7;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792707598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZWgLZl94yfWWHBwe8ZSS9sK2vaYD91ERYkHK7zkpQtw=;
	b=GbPnJiQn+VGLlCTj9BBKU7B1LnR4FbKY351PoyDuE0fFam+F/ZxGRbnByA6+edssilEJ93
	/hYfvvZZGHytZzN93KKQfGfp4Diencg1FPcZ5oM6ZFI26kEI2cj6ojCMhqJa/eYi4mmGVP
	yr2DRhIeZxWmF/G21uWTUwK19Dx1sXw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8551543E70
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C92A1F01825
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792707597;
	bh=ZWgLZl94yfWWHBwe8ZSS9sK2vaYD91ERYkHK7zkpQtw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=G5T8AON76TT8gpbtQKF1JmSrAGG4M04UAl1w44ScxNRfkcmxSCfhB7F6cwnZMhdCO
	 GAhukxyV0WSYVhpoOqtgeBhLi0Zrn0Yatc48REFP4fyQKaGekhsGhgaUS9GuQ/MKPq
	 p8ARJPktwuv1Psg6ZwYHKeAOKhBV6rw0bVEQY3c1EVLqam9PYAHYc9JexIFE4PUJPj
	 dq+yfp0eVzJO4f2kkv9JlEIHWhMASTAge/qL7i1hs/j2C7ZTmhtha/zSK99l11vaGd
	 Er2n1t8jFBibCZz4/vOM6NM7uv5z6+Ha9uJSGTengjCvjcNjAdj701gdyP4F63OIHx
	 WI4YS4cw1ZNXg==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c43fbcb4393so41655866b.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:19:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByAdbJVBR99XvQZ+mwi+qaoD1bnrHS01oVYZAtIMzHnzls5UDvsPVNixbrmkTGvq0mzhqPRZUz/RQ==@kvack.org
X-Gm-Message-State: AFq9FYJe88t65gKQ1en/V+nYAFIelS1hsBUcQzDmDNQ8mS3E9B8v5jgt
	nisITyeLIPUC+TXbGxWsVJmcYCB/otzPuAIsKGksS2ID4sjMX51BsZpaCCFfCbpekcaR83gn9x4
	QnnO41dW5TiR0BTevQNA3ckp9cw/CUns=
X-Received: by 2002:a17:906:9f8b:b0:c43:6d40:4f84 with SMTP id
 a640c23a62f3a-c46a8d5e426mr93984966b.4.1792707596230; Thu, 22 Oct 2026
 15:19:56 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021205626.3286270-1-suseendranb@google.com>
 <20261021205626.3286270-2-suseendranb@google.com> <atnFygk8xsQ-8Mj5@gondor.apana.org.au>
 <CAO9r8zOtFTuPm_aR8wrzYsxzNGKQ9pUy76g0eNk_HsPmi6YW-A@mail.gmail.com>
In-Reply-To: <CAO9r8zOtFTuPm_aR8wrzYsxzNGKQ9pUy76g0eNk_HsPmi6YW-A@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 22 Oct 2026 15:19:45 -0700
X-Gmail-Original-Message-ID: <CAO9r8zP2cNFQ=CW4LZ0ttXtr3Q2PLs4A=rgMDZoSo=JVNuYpKA@mail.gmail.com>
X-Gm-Features: AclHuK8jTz73VDjeomuMASBJUg8buDlto1wF_KsKwup243lKYN2RVWgimlLIvpQ
Message-ID: <CAO9r8zP2cNFQ=CW4LZ0ttXtr3Q2PLs4A=rgMDZoSo=JVNuYpKA@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: return -ENOSPC on compression destination overflow
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Suseendran Bhaskaran <suseendranb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"David S . Miller" <davem@davemloft.net>, Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Nick Terrell <terrelln@fb.com>, 
	David Sterba <dsterba@suse.com>, SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 97A504000A
X-Stat-Signature: nco4yecz7ctrmsi8wmmsjhywed3gjbr6
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792707598-548618
X-HE-Meta: U2FsdGVkX1+zfmrMtgF/AHgFeD1Oz314EEqTN6MQu5xRW60SzSB5FhJ/moVzjEmMQGio9aTdmKCfyxrv9cWR6yu7auDBPbIZQWUxpb7HDMd0WFEHMhV6SYTdiQEsYSh125/OZe35qdfLIWYtOerWLNJlMYfEM9Mj46fNpq02UcoU3Xbd/m1w4V05Pqy9B4yQVCAqjQuqw+yxRleF6lDh8P5bnq+pwPSBZTzdt5OjC/paor9UxH/JFw4TVwb4+jwmb1zZCdabl+XBqs4+22kcJt94AWhTyfL2BFU6Iw+R0gODLMGJU2H5T3p5k0Xs1zR6hDAMRQsBdV+t07R+czfZX68UxQqOesFI2hhDi5jUPv2MQ6tWo/UkGOgf2hQIvksmaxNAoIxLZDPEw7g+Zrw33mYidq1D9BpAiBFoYQtIzEthJrwxPaYe+0vmMbMXipUnBitoIoAV1zkBaG3XG1lNoiwoMXx4bLtXu6qbeWgFZ1UWCRXlH4jt50iEp/ixRU+3vKeEzQ4HFi7AdZQ8l4181dpwfuaPeGM9dFvUGlv1/EkeR11S08Ca+m+MTbe/GE76MfCyN0HzGXbGkj6Xdi4f74z0mlia8NVIAcAHgjTBpL/7s0PmTRPXF3RcsFlPVzc0f21z9Dka3IBl8YYMjiQA8K/4wAu88Tm0yyivUGiQn5H0FKIHFlX5hLqyXLapZMwhMfpBdmDF3BbusB6rnpri/egxDXLXr5NtLc//2DFKBSVK+Z6wdmK5ZReyHIxYqn6ySi5EIOUBoEvLRGwxDebMKlWrykSNErFjJ24x6ukLbkcd8b1zDo0KOUKJzSOm247Cs03+k8kVlXknkPNInfUKB3yOSkVN+h+sMibIF40ra+KhlHquylTQ6K4urgqEoPhHSioGobQQEjtnChKawy66WlLK03oz5kQlYLXxLm5HOweAyWQRfBhzyVekEfiEI4mFY4+m4LF6VAoS+G1HNP9
 AnccD1Ys
 FH5nJoTOCjuPMH7iGrVZaRuJdfnByxLeeG8vTilSXMQ2segiMMTh4BxdxFeoWEN9QRkX/fyka6Cwz23fb1YwA6WW3TBxwuALa0ZeAhpXQ1eznjV2eGPqEJX1l5zi36tID9+Va2+/wa7JXM6hBiucr2MLGCiypJly/bfYniG7yqGcDFY/iVTBGnl/ph6xL9Nzl0/pSh1sEdXG0lgHPsDehnmCo+1uzpJBQwNqkeDc69iQ8LuuWcsO8hAKgd0GAV+Fp9qyN6xLR77PlD37fgkRw5Al78UUWmXd9oWZkIQC7SIzILqvdz8MICsKTx/S6eSsksfm383QHZfE9tCL1ekHNPwSPzZZwbWPINoy37ajZiI/fHZ7kK/346RmgJblFvKZ4td9DwCaX2TMtKD0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 8:34=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 22, 2026 at 1:14=E2=80=AFAM Herbert Xu <herbert@gondor.apana.=
org.au> wrote:
> >
> > On Wed, Oct 21, 2026 at 08:56:25PM +0000, Suseendran Bhaskaran wrote:
> > > In the acomp/scomp compression interface, callers pass a bounded
> > > destination buffer and rely on the return code to distinguish a
> > > destination buffer overflow (incompressible input) from genuine
> > > compressor failures (such as invalid parameters, uninitialized state,=
 or
> > > hardware errors).
> > >
> > > While the multi-segment streaming path in zstd_compress(),
> > > crypto/deflate.c, and lib/842/842_compress.c returns -ENOSPC when the
> > > destination buffer runs out of space, the single-buffer path
> > > zstd_compress_one() (taken when input and output are contiguous singl=
e
> > > pages, such as in zswap) as well as lz4, lz4hc, lzo, and lzo-rle retu=
rn
> > > -EINVAL instead of -ENOSPC on destination buffer overflow.
> > >
> > > For users such as zswap, which reduced its per-CPU compression buffer=
 to
> > > a single page in commit 0b1bf60c324a ("mm/zswap: reduce the size of t=
he
> > > compression buffer to a single page"), incompressible pages typically
> > > overflow the PAGE_SIZE destination buffer due to compressor header/to=
ken
> > > overhead. Because these compressors return -EINVAL rather than -ENOSP=
C,
> > > zswap cannot distinguish a destination buffer overflow from a compres=
sor
> > > failure, causing broken debugfs error accounting (reject_compress_fai=
l
> > > vs. reject_compress_poor) or masking real compressor errors.
> > >
> > > Update zstd_compress_one(), lz4, lz4hc, lzo, and lzo-rle to return
> > > -ENOSPC when the compressed output overflows the destination buffer,
> > > matching the streaming path in zstd_compress(), deflate, and 842.
> > >
> > > Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
> > > Signed-off-by: Suseendran Bhaskaran <suseendranb@google.com>
> > > ---
> > >  crypto/lz4.c     | 2 +-
> > >  crypto/lz4hc.c   | 2 +-
> > >  crypto/lzo-rle.c | 2 +-
> > >  crypto/lzo.c     | 2 +-
> > >  crypto/zstd.c    | 5 ++++-
> > >  5 files changed, 8 insertions(+), 5 deletions(-)
> >
> > I can take this patch through the cryptodev tree.  Is that OK with
> > you Yosry?
>
> Thanks Herbert. I think we should wait to see how patch #2 turns out.
> If I understand correctly, as of now patch #2 keys off -ENOSPC to make
> a behavioral change in zswap, so the zswap patch would need to land
> *after* this patch. Unless you want to fast track this to Linus right
> away?

Patch 2 will be re-sent separately, so please feel free to take this
patch as-is. Thanks!

