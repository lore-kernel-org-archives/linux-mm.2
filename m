Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32C9DCA0EED
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 05:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B1C96B00B3; Mon, 25 Aug 2025 01:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 589376B00B4; Mon, 25 Aug 2025 01:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C5F26B00B5; Mon, 25 Aug 2025 01:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 381126B00B3
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 01:39:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A40DE14020A
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 05:39:10 +0000 (UTC)
X-FDA: 83814176460.19.C2F7112
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf09.hostedemail.com (Postfix) with ESMTP id B92D4140009
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 05:39:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=fafnno6i;
	spf=pass (imf09.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756100349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LE7zGxWMAH8njov+JwT71yg831S+C58Rr2jhVSVOVZg=;
	b=rhDRvRYryj+Rd532rQrN9NeP6OAeswAC77QEuYV0NPXoBtoDSDh0QgY/Cojd2INtwYQ3a5
	wRV/JFZR63q2K5S6aNUznIaDFLB0YBJyXvdjpmPgx1vZN6t/WRUzKkt8uN/RRYaDNXbh2m
	T6IK9N3dGlTBUAidv0rEU4ImQUfOgx4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=fafnno6i;
	spf=pass (imf09.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756100349; a=rsa-sha256;
	cv=none;
	b=6GqEEp9OHeDdEPLIubbejAgyWe49hPgXP+qVUKJOI/FjkiZpmT5p6v8Aac9AU+sjmIh8dE
	jSh1TWxRUhIJ8f1rZ6svXAJ4PlaKk8xsrSk6of+ov3n/7lgZvlH+NZa2stPjb0azgt8DrA
	uApDA1XRfSqoxT9EV9dCEQoSdOHgzuc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LE7zGxWMAH8njov+JwT71yg831S+C58Rr2jhVSVOVZg=; b=fafnno6izLAUTtnGjIhzUHVapl
	NMFmtyRJEWADdP5q2HvCBsDGi5VuS0pqxt11KxOCtG1S9nE9DeZAn9iihgZGvynS7VToAf2XJqild
	HL4Tq64QcDzT8Fa3y56csOcpC4XttkiO87m404Mk6jKTxkEHBdqq1Dr78IS6JKJGM2aVZl4VgEfCW
	NTJABJNNeusue/cCD4qEfnc9mfgluYbCvFGrY6ZoHiWPIy7HtEMH3Eihlt7yXrlRaO9krQEXOG3wR
	3OEwb+xFdwIKzbFOs804ccj+CjpL/t4+NXOdlwEw4veKkUYMTLWLeYU7m2Qo9TpU2CdFmz3AAAMyi
	cAQ0hYWQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uqPfZ-00H0c1-1Z;
	Mon, 25 Aug 2025 13:38:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 25 Aug 2025 13:38:57 +0800
Date: Mon, 25 Aug 2025 13:38:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Message-ID: <aKv28XTvAITuq-p8@gondor.apana.org.au>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
 <aJ7FSUdvxtZyiHBq@gondor.apana.org.au>
 <PH7PR11MB812143269E98B00ED4E5BE4DC93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR11MB812143269E98B00ED4E5BE4DC93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B92D4140009
X-Stat-Signature: ycfyjj68jwdjjrnbunbg4cr64zy53jy3
X-Rspam-User: 
X-HE-Tag: 1756100346-215146
X-HE-Meta: U2FsdGVkX1/5pc+Pa3XhiJzOA+Jyg6HlNnRHUAqC4hwXEawJKshDHQG3/vi1oQibqTmPWx7KY7FLUjZE8Ym9SL6fDGuTpF/RmlOjJQvv4ih+S3/ektCLO5srBN2CTqVS3/Cwd4wbb9UUtfDAiXuV02nHnF9MaMEPPi0jnlJahYGT8QPRY1eoJSmdXDt8HApQCsfR/nnujbByPHokKmI/75hC6EZ3RsB7BVOEn0IyhM2MaOeankqznlHJ7A68I/ycSia4eaxYkPU2Tyq2PsQOvYih/V8e2Kq6Sk4En5CcrpUecyPnejPGiLwUIwJn+4GiNuZ4D0q8X0GzZAWfbKhnGill4aB7JZBDzejPV2HIWMr9w3DQp6d7ehozUHvYLB9Zw5jgNLWnkXtN2p8f894idYHqvni5duVSWq9aqHZaHBcWdl1GEYzfT86for9LoeFcRUfirgzMPkUE5fIRdIOmpl0UzLv0H0ikMfv/mnp3mVSQIXu0bauLTcOGGUx2YeGFkjLCypNMHaRqMQVB064E4d+iTRUY9SwIG+MBk2R80hNOm4Y7kdQDZ5XudiSL2A4Zi3HNETh4ja7Ku+P27blgCpLsrxRKyzfphOJZk+umVGpVSS0cnC60e7+gxkFIHNMn1gkH8x6ogfIX6ZE9RLsi+RQWRPzOtHSRWJc+NHSPhYU7UFsm++yk1lNvIzzxL/5A8VPxnvGw6rLN3eFYrNkntj3PaAZdZ2J1ZekifA6beARbX0Bw1RhqyZnRA7XZ2yjubmSN1/dSGDmiKYjSEdVRO+GIfewWkVxmPKuCEbSzAzOvJt52TH2UaXQllR3UVbPgfyIbQEt/n4+Jcj4FtiRjFiqSre7CMJ0dIsx2TyRiBtap1L6g1bvqcYOCHmq4t3JWKndKWi829EQYetl3E0dF3UKERLx/ricVDLBuungV9ju8m+Qqt8/4thD4gAqOZoVMXmCnDxCCihCpJCWzZvY
 E9JP8dyP
 dgR5X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 07:26:34PM +0000, Sridhar, Kanchana P wrote:
>
> 1) The zswap per-CPU acomp_ctx has two sg_tables added, one each for
>    inputs/outputs, with nents set to the pool->compr_batch_size (1 for software
>    compressors). This per-CPU data incurs additional memory overhead per-CPU,
>    however this is memory that will anyway be allocated on the stack in
>    zswap_compress(); and less memory overhead than the latter because we know
>    exactly how many sg_table scatterlists to allocate for the given pool
>    (assuming we don't kmalloc in zswap_compress()). I will make sure to quantify
>    the overhead in v12's commit logs.

There is no need for any SG lists for the source.  The folio should
be submitted as the source.

So only the destination requires an SG list.

> 6) "For the source, nothing needs to be done because the folio could be passed
>    in as is.". As far as I know, this cannot be accomplished without
>    modifications to the crypto API for software compressors, because compressed
>    buffers need to be stored in the zswap/zram zs_pools at PAGE_SIZE
>    granularity.

Sure.  But all it needs is one central fallback path in the acompress
API.  I can do this for you.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

