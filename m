Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74ABAE7C6F9
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 00:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4606B0088; Sat, 31 Jan 2026 19:48:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 782496B0089; Sat, 31 Jan 2026 19:48:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663316B008A; Sat, 31 Jan 2026 19:48:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0AA6B0088
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 19:48:59 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E9F2E5B791
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 00:48:58 +0000 (UTC)
X-FDA: 84394053156.09.D2EDE65
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id CE6B7180006
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 00:48:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LEo89UNX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769906936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IxzRN1GvYKcSA1myNnRhFl1/mDOmpAJaN3X4Z/70v0Y=;
	b=6JPJ71IJ0Eq1SD8Gym6IePuUCBC7LFMDYW9AJf6uUt3fZOGCgbRoz9Kd8ZatYsHC6Dr5yh
	Q/reRCkF5JHeWyLGxRcR1liYeX/7tltupLWJpoRQVWjdr3QV8GRoe1fnB6GJijgnOUsrLs
	2df0zwlad+B9PsZMcSa73kiqKI6EGiY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769906936; a=rsa-sha256;
	cv=pass;
	b=po9QAEENqEpHuNLAwiJAA5Ewa5rM/aYlHKGx0J/4KKLnisT7T5OVXQxSw7WjSFQFZChWiI
	b1ZszmZNPShtUQ7VeEBkaoZOZJQCFDiqqZprddHnZjh1oBBF93Hb74RtWeUad8VaSgWLXB
	66iAH3fPIsU2bH0E0L1fV0TR2HiL1O4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LEo89UNX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-42fbbc3df8fso2506917f8f.2
        for <linux-mm@kvack.org>; Sat, 31 Jan 2026 16:48:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769906935; cv=none;
        d=google.com; s=arc-20240605;
        b=N3OuZ35dMZn+DzRq96cjrFZOFZUKBX7T9hvhq17RtJ4SorBa6MIH+RSvoJzL6EDInn
         8/oXXwH4ZRio4V2NS8kjzAYp5WS3A0ePPnEKa4e7+U6IZtOKq2dbvl/ibhXVhF7Fl3Ha
         ruW5U6oQpDVNQrFx44+X80Z6Mx6+jnyReBfRQFIvjDlN1yeGNhiGav+/3bQx9aZB5lir
         AbJZ3fYJWQ8u5+WFNwvDVlsps84aiiNzJussz4GPBdMnBT86m4AU04ldOwKP0uIfS/F1
         RMk1klkhQfgN6BvFSjWlst4+Nw2w6RgimszZ3KwWuq8itVS1WFsZ9a/mb1zQOWw0CoOU
         N/rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IxzRN1GvYKcSA1myNnRhFl1/mDOmpAJaN3X4Z/70v0Y=;
        fh=uEurEZN1fKnteFQFjrjkR0bkGDlh63lZr8G8muYKTeA=;
        b=HcrzrBvzoU+A+l+xEYZNB+gMxfD0Xe6/g1bRNnxC6oDweeklUAmZVzPmkIqc5je+UE
         7pS8NmAIksQGazJPeiNIVqmPhoY9AUcaIG15LvwECSah3snc5lS3kqhm4W+VQbGK1jWj
         9mC/MaWtOMavgiRZuHKp/4VHiCUD7ccKwQc68Vf4VUPBw0cPSd6voYusatKJ/a5vvPm0
         DL6c2yd4sr8JsIgej2VG2dLjdIBny6cFfjslS27+TWgrs7SMw/RJLwiTQmx38JsFqIF6
         1OqAhLrZzvi20vrsrObPevnSyeVEAJp7lJtMKYc6fpaoaOaDocUgobe6cOcJ60OivBgM
         wb6A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769906935; x=1770511735; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IxzRN1GvYKcSA1myNnRhFl1/mDOmpAJaN3X4Z/70v0Y=;
        b=LEo89UNXyEEzZYBbTZGkwOPKN5xAJ8d0UmsmKnTbaaizeqUdzE5uoHJO1etaQcgmUs
         R+4NixPu0B6qiNdUzrbzKsXNGjjwn/7DpknjdIbbt2+VrnEzPHLKhTOxSZ2qfZqMUk2d
         VhZWXx0AJQbrkraZD3dsx4IexJ5ESLaWu36t6+lIaveYsuIRUIdMUNeKh7C2xUCia3PG
         0HU6NZA13g6j/XXD4/w4tC3swGNNATNkaIeTEWJDspoufLNuZlo9awjM1mCNfm/jQfwI
         VaeNqgxdJkYe7gGuFuLhlRx0HHBwu3CpyKQl02FWNPYxZdkEfT4yrRI1xRX5hPnUpffC
         +cHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769906935; x=1770511735;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IxzRN1GvYKcSA1myNnRhFl1/mDOmpAJaN3X4Z/70v0Y=;
        b=TH7fCO3COUoaDD3aRIrah3Igv88SQH5yeF2Gz42X67KD7C0ARXAHe12y7c+TVQLlzK
         G3doFTy3HTrgg39jISWQ1iZ6M/4mZtCuqUlT/ot/9T2T2IfehIirUwBKqYBdJ6EORt9o
         ftxUZ5Glmofbih4rrbu/gx0lWvM5WqYD1a0vt2PFn4kQvOlYoC362DgxhcyNNi9Ltpb6
         nc/pyROt7qWj77pNCCi2FZF80SDcrISZBOhnSqfR6lIUbMWcAmCD3Ws9vQ3XnnehUPi5
         CVBYo/SXmUB/VpaPQuG04B7r2ycwff4FyCP4REbC19K+i3yU74v7fLfFjnyI24pmsOdV
         1Osg==
X-Forwarded-Encrypted: i=1; AJvYcCVnTmM2jAFfmJ9V+fy+rDM6sTXoRCP3hOv+DNmE8GJ7mso73lEzPnB/vfumotfNnqWuagznEVaaJQ==@kvack.org
X-Gm-Message-State: AOJu0YwDsx6ASXFr3rDS+2O7S1bSfHBdDnywRxb0zz8HM+AppqO66dAN
	ivR/cXQYIPOvNGEkXAVD+oSRy59s+Gp4I0j595SQLOd8jGCp9eS/1or9BIJhO3IKt12KD3kPyoq
	z6ZmYdF78fItA1WH28+z8FT0/24Tiz7s=
X-Gm-Gg: AZuq6aJogfVdZ6igPW6MKhTPA0GeSDD0fh89sPtwkezSCcnImYKO4XxFQ5Jq7nL2DgD
	UmcorPtx8T3ShnEVwLVpGmD1zdkxFppphSQDOedqbEFt/7qsjoyYrF5uDTcau/EXu0hJ6xPmyLU
	Q11JK3DbIbbHMXp9yTbj0TlzaRKUjiGjMuTDI1ojxiD+m14ajOqpVIw5lTJ4LP5P71OrpRTEc64
	pxyMKo9tHjB3WcwnJlbE6qust4UXcApA/liZAHuNeyTAoy+pldygrm4wgZQAzsLuFHz9Q==
X-Received: by 2002:a05:6000:2c01:b0:435:8ec5:d27b with SMTP id
 ffacd0b85a97d-435f3a7bfecmr11333484f8f.26.1769906934865; Sat, 31 Jan 2026
 16:48:54 -0800 (PST)
MIME-Version: 1.0
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <20260125033537.334628-27-kanchana.p.sridhar@intel.com> <CAKEwX=PS7mjuhaazydkE2TOVa5DWQu9521FqH4aXi0yptZQaeA@mail.gmail.com>
 <SJ2PR11MB8472E5DC16759FFE6E23EED0C99CA@SJ2PR11MB8472.namprd11.prod.outlook.com>
In-Reply-To: <SJ2PR11MB8472E5DC16759FFE6E23EED0C99CA@SJ2PR11MB8472.namprd11.prod.outlook.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sat, 31 Jan 2026 16:48:43 -0800
X-Gm-Features: AZwV_Qi4WDbYOooIOPZu2Ppua8Lejwpek0DNwYJiKSz_rJv0IVeNCuN7p921l5s
Message-ID: <CAKEwX=PqWQ_39BuApc_bT1WKQMJyNPDs+Gv0JAU5cTa1KNDj9g@mail.gmail.com>
Subject: Re: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for
 compress batching of large folios.
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
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
	"Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CE6B7180006
X-Stat-Signature: 1conezn9iqf4jss3t7iux39ap6thziyj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769906936-272164
X-HE-Meta: U2FsdGVkX1/9gbpj2rL4MQMBxHiBvgTi130cbCwA8daJvxyFx2r8PQtDcHdWPIsT0xytftpoeMrEL826xeD4p9mnhR0YlYudPjrVnQDntaq9MHrzaDpcjfs2SsBfeZG/2HK8395hSj0YburwAV5WBpLVVsjMLJpe/Zm1FK6lf544WEI4dtVKJA1enG9Xq+iAGAG9IcdcT+XKBxjc5Q3xVT4lstAukgq0fHG755OW4Ztcry3F3wLJXHyYdPz+rtXVVtIGkaEFJ43MOQsEY3Jfq/BCiQVNN4Jk8ClZFMivuVS9PZ1ydHGcv4pqPfDuf7AK15NDBup4KJRS/l2K+7uaZsIyaN0xwVR/jADd7+f3mYYLdHzXAXeYNjoPbYqK8L2xnRBMYC2+dccFuwwNtgPKwP8yl2KkN7rxjcrMaQfnH/dtW7GF3AigV5N3Evi3b092I8R1UP7V2uhYP7Okadp6oksg9mv3JBj6SouJ4Qf+ncVNTq8t12wNkF5lwb3PpDpUFmPEx5sZAdGosDn3JJq8VK/cWraoOjALJhjWxYilmuYlGjfuCyvO47+BzhvQCJvXs/XBt/1ZVcqSBoPnrYxuXrFBXWpNUZvqDDI2Atv7Xlyj2fV1/hmYWAtRjMFNDxMUFdz29e5xaX3GBSTe/sERYvsTaSwO0ZEMUWrM2fA55DkKqUZ6GtwzmQGqyiG+J1AbwnSQO+DhpU9BMtoNczLzW37bO6V1QWCPd1baUcS8Vt5EGM6JN+Jlo+hUDsVZJy8ilFC3fNT/XfR5EpDHRkpDMEjJU00Q24hbhpWXx3iIxXeR+oMExKwj6GGWfb0gooGznIj7pxRKmTs15TdwVZr3z1HO1sbT7U/pOGqgiZqOX1hrhybO2kQAbD3a/A7Mx4H+yQpWY6j4WoUmLwavgR9Vgt/b8Z3u1dbZ24mm0G4TuBntniiz2ScCGy5ZNHMNW3vcSeisYlqEMVsuC5tWEOE
 1VSfjuUB
 tURDUw+LCjTIyHNbCm/7AC92sIpD54yE+itoaxxwYFYVNyYOCTH1gsnJ2IcSQVnxxv4u5efvxBy7ovlkGH+RTqpXpsSmCSKFZwdjkoWDXPG6Zre0yQWq3886UIuC6MfWNaGLDukZ3C6Sr4ABQuhUOGaN2qCW7rJt3HA43iOLPR/BEC2klrO6x+BCVp/Bm5XirlaAaLdhGd5e4EO6GVUasMt6+p7JqUdA+7fMJo/R7ENOc9OLk6SMbXtyTGoroaZTSyesEvVVU5KXldJg6pFYpG2Uwrs7vtKyne52gTSBE3OxPteYtPgMNyt6q237ZL1MlehflSToXWW/fVsyvwujSdmv/P35G99f/qSDa/3sEU99xBZRfehFEGlr3BV/BElHAcY7ueETUe9Zm3LtS9pkZciGSebKV8xLvoxxn/FtP1tY8l0dMqVlySrHX13EXginN0mp4OuEl1VK3HktoOI4i+xsXst3cM+/s/r2+b0fF6o74XVOUpw6MeUPPvBOI5M/x9x7YVqZ8Fdmf4LGqBSjAzJKMCzTNn3VKey4XrtaQ+teBlGUTODCENM/UO0OJR5ScGcMSnSQDcCS6pKcMy85tewVHUrSfQB70hwQREQGWbfP86BjL83GZyUShLaHx6zSnWtWFRH9VK4J8MgZ8LBzRZXkiJR5o5tJX86og0W1qmjqnAd/COVmzZsebzmdTVKmyHimmJy7LQG5kaivUH5MtseRwD1Jorj3/2jx3W+6dOUY5bVQmLEXwrzq31qe93Up8mN6eOwj3gApMn8Gpivg74d5W6HWN0gDpi1Fn9IR+ag+tN0N59rx6n4FT6+oZ99i0bWluF1L1HXUQgWU1cY7uAFLVdnT2IBdqhS2o/2Mei3oVMBDiM4tEg2pTzEODxnFuKKn5faqqzy3PEU2jjR58GqquA3qdOAE6gDc+zoKzS4xo/gbMwbYlfgvpbbyunPcrtbRdzd07xCXMlGkfUee/HWwNFbXq
 jQeYjiuh
 JQ5RQg8AUOi1zwALGZOHBsKvgXoVADYoWizWeGSP7yoWJwlKqADG5c2sxLpdxp5wvLt0vTK4IfG9/uRuUgAJn5xDghNoRLyYi9yO/m3DFo9WnIp84zaYUSOPFCGi+Za9NfLYxhN90OqTU5gmPWPsbg5vDAer9loTwspBK62OqV0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 31, 2026 at 12:32=E2=80=AFPM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
>
> > -----Original Message-----
> > From: Nhat Pham <nphamcs@gmail.com>
> > Sent: Friday, January 30, 2026 5:13 PM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; yosry.ahmed@linux.dev; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.co=
m>;
> > Cabiddu, Giovanni <giovanni.cabiddu@intel.com>; Feghali, Wajdi K
> > <wajdi.k.feghali@intel.com>
> > Subject: Re: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for
> > compress batching of large folios.
> >
> > On Sat, Jan 24, 2026 at 7:36=E2=80=AFPM Kanchana P Sridhar
> > <kanchana.p.sridhar@intel.com> wrote:
> > >
> > > We introduce a new batching implementation of zswap_compress() for
> > > compressors that do and do not support batching. This eliminates code
> > > duplication and facilitates code maintainability with the introductio=
n
> > > of compress batching.
> > >
> > > The vectorized implementation of calling the earlier zswap_compress()
> > > sequentially, one page at a time in zswap_store_pages(), is replaced
> > > with this new version of zswap_compress() that accepts multiple pages=
 to
> > > compress as a batch.
> > >
> > > If the compressor does not support batching, each page in the batch i=
s
> > > compressed and stored sequentially. If the compressor supports batchi=
ng,
> > > for e.g., 'deflate-iaa', the Intel IAA hardware accelerator, the batc=
h
> > > is compressed in parallel in hardware.
> > >
> > > If the batch is compressed without errors, the compressed buffers for
> > > the batch are stored in zsmalloc. In case of compression errors, the
> > > current behavior based on whether the folio is enabled for zswap
> > > writeback, is preserved.
> > >
> > > The batched zswap_compress() incorporates Herbert's suggestion for
> > > SG lists to represent the batch's inputs/outputs to interface with th=
e
> > > crypto API [1].
> > >
> > > Performance data:
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > As suggested by Barry, this is the performance data gathered on Intel
> > > Sapphire Rapids with two workloads:
> > >
> > > 1) 30 usemem processes in a 150 GB memory limited cgroup, each
> > >    allocates 10G, i.e, effectively running at 50% memory pressure.
> > > 2) kernel_compilation "defconfig", 32 threads, cgroup memory limit se=
t
> > >    to 1.7 GiB (50% memory pressure, since baseline memory usage is 3.=
4
> > >    GiB): data averaged across 10 runs.
> > >
> > > To keep comparisons simple, all testing was done without the
> > > zswap shrinker.
> > >
> > >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >   IAA                 mm-unstable-1-23-2026             v14
> > >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >     zswap compressor            deflate-iaa     deflate-iaa   IAA Bat=
ching
> > >                                                                   vs.
> > >                                                             IAA Seque=
ntial
> > >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >  usemem30, 64K folios:
> > >
> > >     Total throughput (KB/s)       6,226,967      10,551,714       69%
> > >     Average throughput (KB/s)       207,565         351,723       69%
> > >     elapsed time (sec)                99.19           67.45      -32%
> > >     sys time (sec)                 2,356.19        1,580.47      -33%
> > >
> > >  usemem30, PMD folios:
> > >
> > >     Total throughput (KB/s)       6,347,201      11,315,500       78%
> > >     Average throughput (KB/s)       211,573         377,183       78%
> > >     elapsed time (sec)                88.14           63.37      -28%
> > >     sys time (sec)                 2,025.53        1,455.23      -28%
> > >
> > >  kernel_compilation, 64K folios:
> > >
> > >     elapsed time (sec)               100.10           98.74     -1.4%
> > >     sys time (sec)                   308.72          301.23       -2%
> > >
> > >  kernel_compilation, PMD folios:
> > >
> > >     elapsed time (sec)                95.29           93.44     -1.9%
> > >     sys time (sec)                   346.21          344.48     -0.5%
> > >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >
> > >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >   ZSTD                mm-unstable-1-23-2026             v14
> > >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >     zswap compressor                   zstd            zstd     v14 Z=
STD
> > >                                                              Improvem=
ent
> > >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >  usemem30, 64K folios:
> > >
> > >     Total throughput (KB/s)       6,032,326       6,047,448      0.3%
> > >     Average throughput (KB/s)       201,077         201,581      0.3%
> > >     elapsed time (sec)                97.52           95.33     -2.2%
> > >     sys time (sec)                 2,415.40        2,328.38       -4%
> > >
> > >  usemem30, PMD folios:
> > >
> > >     Total throughput (KB/s)       6,570,404       6,623,962      0.8%
> > >     Average throughput (KB/s)       219,013         220,798      0.8%
> > >     elapsed time (sec)                89.17           88.25       -1%
> > >     sys time (sec)                 2,126.69        2,043.08       -4%
> > >
> > >  kernel_compilation, 64K folios:
> > >
> > >     elapsed time (sec)               100.89           99.98     -0.9%
> > >     sys time (sec)                   417.49          414.62     -0.7%
> > >
> > >  kernel_compilation, PMD folios:
> > >
> > >     elapsed time (sec)                98.26           97.38     -0.9%
> > >     sys time (sec)                   487.14          473.16     -2.9%
> > >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > The rest of the patch changelog (architectural and future
> > considerations)  can stay in the cover letter. Let's not duplicate
> > information :)
> >
> > Keep the patch changelog limited to only the changes in the patch
> > itself (unless we need some clarifications imminently relevant).
>
> Hi Nhat,
>
> Thanks for this comment. Yosry had also pointed this out in [1]. I have
> been including the architectural and future considerations in this change=
 log
> since Andrew had asked me to do so. I hope this is Ok?

Ah hmmmmm. For some reasons I was under the assumption that usually
Andrew would concatenate the patch cover letter and the patch
changelog before merging. Oh well.

If Andrew prefers including that here then I'm fine with it.

>
> [1]: https://patchwork.kernel.org/comment/26706240/
>
> >
> > I'll review the remainder of the patch later :)
>
> Sure.
>
> Thanks,
> Kanchana

