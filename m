Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65610D148A3
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 07:37:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0A36B0088; Thu,  8 Jan 2026 02:37:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8DEE6B0093; Thu,  8 Jan 2026 02:37:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B90BE6B0095; Thu,  8 Jan 2026 02:37:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A3B9A6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:37:20 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C3181AB13D
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 07:37:20 +0000 (UTC)
X-FDA: 84307991040.28.C6F6D09
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6A3071C0002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 07:37:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=HnivfEUA;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767857838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aE47zdGf76FlVtBZ+VL1FxmVPBFkqhx8ryie6SUWOPc=;
	b=tB51A1vIBdeDK39VtYn0RWEdIX8YzvYTIM5bPnfklUlylMLz2yjlxP0ARhr4Pza32p4KQW
	THdyMH6Jv/DGPM1YT2b726EYHryAPAmX/3v+1kP19MQ+dftQrpIA0BAJtffkMAwnMwM3Ns
	ZtH/Pup4zcJFrd3rq7gguEiGSjvpYjI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767857838; a=rsa-sha256;
	cv=none;
	b=6BMIHSbydAm3VzG8wwU0YbsNU69iNgdt7NXg+IC/1hAfutFaMyjOwWp5Vc25LIdqzRaNgP
	gxqGktq/0c/f4hK3sRASoxbKNqgPY3YnXR4GScu47Vv3mtSNIX5QQsuDYJkp04uRlrwrOq
	dysxyAlkL6VdPn16W6B4tYicF9pOg0M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=HnivfEUA;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a0d5c365ceso22436955ad.3
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 23:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767857837; x=1768462637; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aE47zdGf76FlVtBZ+VL1FxmVPBFkqhx8ryie6SUWOPc=;
        b=HnivfEUAnJRHy7Y4rJello2HS12Ry02KlZrKj9VvUUyZwOgfLf/zss23m9TBQ6gzHW
         SaE+ClfkHghU/uHN1AzK/JqbOpS0qBD0T0F1PvHYNY/7CXuI30bfOu4IYJ+P/GzkLPfF
         hX/Ju9WfvMvbkzCbJorJLlm7Cd7gtU6TqtGSI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767857837; x=1768462637;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aE47zdGf76FlVtBZ+VL1FxmVPBFkqhx8ryie6SUWOPc=;
        b=Ir/D88SLbiOd8XQbJvJRJS5s9k8hv/2c6w30uPBca3PFtwW1NIGmL7aBAYcrE2ZsRl
         4J3Z81I1zbv+nS4EeX0ahndV6pZMSLY5MXwSQgNSmh/rRT+NbwsxlnH+N4AfdFPGyWO/
         kw5nnn0ORP6Zi8Ovgomd5HaXhXCCJAWs+kJAO1tqk3LVgt1Eezu9oDuCZXi+JeqlEv4a
         feBZvusPpzzQ/gGs3VpbKxSzrbr+vUGg13rsLvHYXFL3dqurc2GU/F6UITH+IG/tBREc
         cOssC/N2+o4KFqpHzV70KcTn+KUXCxjRio9TmEiXW0b6Ftgd2EYjnRIZ2tFnaZfj8RKD
         IEBg==
X-Forwarded-Encrypted: i=1; AJvYcCUEftDlPvmYgTzK2pzF0CifehB69E/1aZAda2CPZpDn+aHZEfGAgUSCwvqlAxnZPhfn5aM4UDJRUw==@kvack.org
X-Gm-Message-State: AOJu0YypoIqZwfmtFyTcTNc1qNJlX4Ibb+FKAH5CW7xP6BqFknIdg3b7
	F2ekDQh6vErOVEgwxGzEI6o/ulNnDQhulYge+n7lm6f/R9SjYHG4xF3NXsxyQE0pGw==
X-Gm-Gg: AY/fxX5CbvacO1rlOlj9u0hlSocJKkL3AoZLBwoA5kQ6kxL2LJhpEFZ1cOoDkbyO6Ij
	e8WDmpdOMIq7Yqb7pN+b0C+DTmVNJWnDyA3cGpJT3/AlNIC1wLJH8vUhbvOh4GBCPylV1P5TFIR
	uhI8VM6EfFUeeCRs3hw2r1cvVv+1u8ZPX20dI+b/5mY24cIfinK4QvBofAc+Xi5YH+4Wlg5HhtE
	VKLXXN/lMHpKSS/3GYBiGROmQ/aI/7Xdk/ykggRcJDu/+Z8hjTGuKZtNPCV3wy2cvt/T22yBJjg
	Poh7p3Ism49aTZDUZe6a8PG9YCezb/UMeu1jz/buV/q69uE7RW5pNf8Sv9YTKQV6PNV6vBvsRCa
	1peikep4pFxb7OVw6mynxSDNYLlNIs17YLdkhRQtf1/0lSriax9095cGXLp6J+hXMSX1M9jckK4
	uxEHXGHCBlTOJRU+IIKOM04LpeJnPN9XioAyezlxMmrZCw9GGxBNY=
X-Google-Smtp-Source: AGHT+IH844iuSf8xlyXtOjjlLiS4k6UYPV39SJzHTZOnHi/NkWFKlGFTjYXpfFEq+vsN0+5ooUwGqg==
X-Received: by 2002:a17:902:e78c:b0:29f:2ec4:83eb with SMTP id d9443c01a7336-2a3ee4e6740mr53698905ad.53.1767857837249;
        Wed, 07 Jan 2026 23:37:17 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:7bef:7c13:79b4:e9de])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c4893dsm68875995ad.28.2026.01.07.23.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 23:37:16 -0800 (PST)
Date: Thu, 8 Jan 2026 16:37:11 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <utnvn4oupcmohosp6d3qti54qmdppg2xfw622dq6zz7t66a6ma@2pentzdw3zgk>
References: <gg5zdpzrk47tljbnaudcy2gnsodyhmmar23qb57b67bhx6ntje@eq2fcrl2dk4z>
 <v5veb673xrz6z3tevfdymhuik7nltojrvcqyjih4ds7co4p4hr@5e7ngdkrxo32>
 <5p4iyah6zlrnxpbsis32c4m5lrjj3pq7xwcugq35d2entwfai2@n2r6y3ga2ie5>
 <7q5gqpfshnc3lfhzxughpks3fc2knw2delpm5io2oe54monydl@5isuxnjputjr>
 <aVyYuS_usi-lpHkM@gondor.apana.org.au>
 <dou7g3n5fpynsab7hmxf4bgmqdewtdhkkiriwlghxzyduick7h@bsi3q2kivvbs>
 <aV3uXguDCaVAbY53@gondor.apana.org.au>
 <9b7d6e6292c64f21b8d09def1b6723f02faffe88@linux.dev>
 <53zplsrqc66z4ea64cosy53zvttuuhgxr2ik7uw6i2zgluegyz@d3ulgntwnyw4>
 <llj3jf5evsp7f2wl2hmm6mouqzwzolvdnu4yquhxbgsgaqvsda@ltct5tqpzmyo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <llj3jf5evsp7f2wl2hmm6mouqzwzolvdnu4yquhxbgsgaqvsda@ltct5tqpzmyo>
X-Stat-Signature: e7pbw8x7aapnkczexfufc1f5yakcjjdx
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6A3071C0002
X-Rspam-User: 
X-HE-Tag: 1767857838-384840
X-HE-Meta: U2FsdGVkX18pZitkxysrNaqTWfoAnxmvl2YMX4qFPJcHnch7mW4W10ieW0DynBPLGRBHBNXKFbmYF2CuESmQ+IuWtMqIVuJsDmLW/89tMrHMV0+FesbCGGv0urk2b1FtK/QF3wKTZ4Pnic05IoxiNkeQeCu8Fa2TAo942p4vMJJY3qXp+7h0R0djLZrHlnLmEWA4ojklav+AfUQY7IsjaWKox4nKJoXznH+m6ds8MWg7JWZllk8Fgn24cbMDS1/kExfTuSBSP1wDNh0laRM2Ids70R05N9crb5z/b5rDALAnO8qodylzFexB0972SI/v+er7Wz+cyjZIVLPIsJRAoVDvlPt2g37LcwoDUf4SoQoQIEpRhq4YkXJwCVSUUClIhXRmhlCGQwVMtGmedyDT98b6JqURNP4MpX1sIBN4uzeAeryVyiIupwP5hmrweeJbuWhReppVFij66LNQS3UTaYakeibJLevsLJbA6tJKXEI4WcFcJEzIBjcBCpuP2rNkGsslxoGacouzplyRsGgMaG5LbtSCpx7uIc8ky3K6mIR41wzNF2A1zM/ZAP83e9tEgkATf0QcsddwiL1N19ZoPUlAJrECodbgQSWpBECbHIT1nSfGSnCjObX7ztQpcvdFMm1mu9MgcABaRoFOELujCu9bKC6J86iCXviSWsM1z/My7whDbZ5KvRkPEcaolISg5AKvUp/tg3JEp8e41UVHOeWeHBKL78RC4syhkN7dK0V8L+PBnGHPor4RBb/qmUYJPIKIM/3oAOrsyugLRGLX/fBKHWA7/lbkYp2sqUN66LGEw/JjvtyZCWnEA478XNZ2YjK/mGWfEWQzQlmTOovgS61htyWRWKF8DN/G4MGm+BTZU2shZPuHqt8m/+ZnG6XqwZy02yRICPJTL+92P+IYpveDHryRV4g2T2LnggAt6cudxpT40mjbXflU5XXyk38PdhqiUoarzH28YHmlZI+
 BV7mzQjC
 JUMqOLUB1Y0U31nvhxSbYzW9K8BzMXlx5vGea9ZLGNxwFjRelbt3nPxSU3qXtMj/Zad+8tIziLch+Ke3H9WlaCUWX8nvmn3VOQj9wugl2r4mqVBaDZ84RyArPl2HdL5W+bFPozfusWeCvrngfa6nWbkNlrxNToaZRzuwhZI99BtiVX6Dg74s9I/EQxXNH+0mLKlHFL2GI0HEWjg/WF6G7aCNBMoui9RKFi8++qnKzo2n2j0MgMT7tX/6jb+eVoJ/STpEuksv0LjlE0O2bcs7CZQnh0yQeFn5083T+KnbcvSddCmu7dT54i1jJsTxzpghYek/IZHJJ7vHGm5Zpf65cYkdR0oesZ1vrFO0mZ4HunCyQNjU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/07 17:12), Yosry Ahmed wrote:
> On Wed, Jan 07, 2026 at 02:43:42PM +0900, Sergey Senozhatsky wrote:
> > On (26/01/07 05:39), Yosry Ahmed wrote:
> > > > On Tue, Jan 06, 2026 at 04:24:45PM +0000, Yosry Ahmed wrote:
> > [..]
> > > > Adding native SG support to LZO simply means removing the memcpy that
> > > > scomp would otherwise have to do.
> > > 
> > > Yeah the effort to add native support to compressors can be done
> > > separately. For zswap, I think the most common compressors are
> > > actually zstd and LZ4.
> > 
> > I think it's the same for chromeos: lz4 (primary) and zstd
> > (secondary/recompression).  zstd looks very complicated,
> > not sure if we really want to diverge its codebase from
> > the upstream (meta github repo).
> 
> I think there's value in using SG lists even if we do not have support
> for lz4 or zstd. We'll remove the memcpy() logic in zsmalloc and the
> kmap handling memcpy() in zswap if we just pass SG lists from zsmalloc
> to zswap/zram.

Yeah I agree, I guess I can cook something up.

For transition period we can have:
- current "memcpy" API
  for zswap

- SG-list API

I can vmap either on the zram side or have new zsmalloc vmap API
(alongside the memcpy and SG-list APIs).

Once crypto API supports SG-list and algorithms tunables I can
switch zram over from zcomp to crypto API and remove memcpy and
vmap APIs from zsmalloc.

