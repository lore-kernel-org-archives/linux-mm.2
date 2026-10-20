Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 760EF606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 02:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=asanFCEu
Received: by kanga.kvack.org (Postfix)
	id 5C87D6B03E1; Mon, 19 Oct 2026 22:14:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579186B03E2; Mon, 19 Oct 2026 22:14:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467D96B03E3; Mon, 19 Oct 2026 22:14:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2B66B03E1
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:14:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F723C085F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:14:16 +0000 (UTC)
X-FDA: 85341384912.07.FBF9151
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id A76E5C0004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:14:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=asanFCEu;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792462454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/kTZQWUcpHzrJy9NMwC8XJWFAf9FL4EwlT1MlBIWbLU=;
	b=2T30SwbrZck60S/0iexWg1NIWQznARqISDLkZmJFTCC4zK+q1LSnSb9Dxo/qkcFF/x8iEX
	0YjBdlAzILy/vkVsHC9asdSqDcsGk/HqOn0s+7SAgVH62MlifZa2wAVKi/NdEwiZ1qFh69
	zSeZ0DtSiWJ1zK19Pj17XDYL9OF+Omk=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=asanFCEu;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792462454;
	b=eCMIC3kpi/A24SA82k+G7tDgKPz75zMaBSnTOF6s2LJ3f42g9MsJn0cdRYMysvqT0DVnfT
	0y+ZuqwLD9mE+2YCrqYIJMxouMlUVQTxM326Dw0Zqfjlgn8mCTgrXBgymqquUzLMVmAkVf
	EIgK7XE8zsTtcrguBuIej2sAxgfZ6Jo=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5bcb4f23ddeso2672511e87.3
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:14:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792462453; cv=none;
        d=google.com; s=arc-20260327;
        b=XOTPIs09ONbhoeuq1FkiSzfh49tSADk+l5tSD8dPOlCozusLhEcMevZEryanAH8MoP
         c9sgopMkiO9RfxEm9VuIdr4LYhBbGVDLAc9IA7th7r5nYIGt4mDRz+X/fBP+P0ShrEze
         0CHuZ/1zWOcqhVI5vzoVB48aHgAc88ItXZ9V+K5TRuvojcHINfgojvgVHaDpgzJQvOMR
         f8oZ170fePHd94dtCnjiOkqkudJrqSX503c2Ui55quXwKdvGXLFh095EognEkDvIX3VC
         ffcBxergSXB4pu2aprdjj9q+fmMKZt6mjyEbhbYA9HP+5kpNe5wANxBQBsF0mYZHWc3i
         1MBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/kTZQWUcpHzrJy9NMwC8XJWFAf9FL4EwlT1MlBIWbLU=;
        fh=ximD3sKT9RPiagZCU0TL8CW2fvtXAF6i2i7hkDwovHE=;
        b=YVvvJ4HDIxKd7sc0zjuga1DocdttcoQkwpqqmJwOVL/pc5iWUTtlERO0kyL/XnSK16
         jF5vSkCyrJpAk63zSrNURDZcED85l8Cq/7v+DjUENehP6nWVjFOjtUwzbSc/SASLsPqS
         XghyZgENwE5rmOygfKk4EKWT3SXYL3FL+N7dT8nVbb6ncVsbQF9ul+Eum4uVLQ1h8cSZ
         f6rtynd2GneYGMEGu4LuzVO1kRqj8CDb+IMl1Qtaig84DC4TurCBUjJzUIzG4hvaSUL+
         BkaAmhbblAkPk/5lm/3t+p5ADHwCp0xm8Bq4s2+P0FssFAOKjDe2Mn64tBLdFKylNCA9
         Amsg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792462453; x=1793067253; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/kTZQWUcpHzrJy9NMwC8XJWFAf9FL4EwlT1MlBIWbLU=;
        b=asanFCEuoLtndqmAwzeYw90SqMYug1EWLBvtCE3AGT88fUSDMYwx5oGn489FrzgVqm
         EowpPwgL4Z4lWoxhCWUQTPOl8RaA9bVTGjutPzltzEn17aKh4ge4p+oJTkS3UyrLMZQ4
         tcIJULNeYl3uRO2kOTTOgx4+ShMphPkRf/pbvSEsgiBwgCbaqfHGMZvIUJyYEdROB6vd
         DQAs+++i0yIxsFo2lgiAsOibbCpxIPjIhRzXD1RiinyBNFxZnj44nJTuqxGiTi/K+hvj
         0CsKrY70rXn5a4+IySZslCFg2h6aaMTloJswvJRY/iuV2SW3vGMlBhF3Ce5a5HOg7UtT
         jEAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792462453; x=1793067253;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/kTZQWUcpHzrJy9NMwC8XJWFAf9FL4EwlT1MlBIWbLU=;
        b=wmIgawxpNKghV31HT6rnjF9F/xas50YxdYLhH6sxUl+eooXI3MeGTEJ3TsL2m4sONH
         QlLu6N5w5f9S1Xz4S+4NWYDxrTZBol92799ePDyEFS7CkWs/DzrY+QnrQCg6sVyCOgUR
         rboSejGyCEUh1ngrvRlWE/9XypLXBhBFPUn+l+Yu44hOP7h6/lnvtDmaAgFnk4VfMLk5
         xYGjT0rQlMeAzDn2fo5CN3bOTffkRbwnQIrYSc+NPMDf/Sl0F4/Bvp/CJ300FZrUHBdm
         /VuPcPBQNyEco5hxc4yl9CLn2MGUGy+330UW5Z8AhqUvSDzKBxB6BFmugOAD/JRO5acx
         SInQ==
X-Forwarded-Encrypted: i=1; AKwUvBxTMB/5bbr6Oxoj2zzNYKpA57+39vQO3m3i0kl0wsAQjKYNeS6J9RnVvTEXApicMJOrWHSBLDx1IQ==@kvack.org
X-Gm-Message-State: AFq9FYL/uez0SGQBBp6eVVQOg4mzJQpgXpoMMz5HOSL9PDo2S7crHNch
	3vk33GVLSRf7nz5kEKmx39aNdPUNw9Cc1S4/F4aCZi8kB+DixjFvOaEynqWFwFSuZ9qDsOOcDeC
	qF7H9DJtIzkfUPYWpIF2a3GFm3TCMm1A=
X-Gm-Gg: AYBFou0Ar8/fMYxVxE3a01cwjdyvl4QFZfGuLKrVVMq0xRna+0d2YY5ZQbJzHFUrD2h
	2hMo2+AC1KxFHmG7EbfStFxkxV3zPat3i7dJcSSA+l3gzreXfIHhfhFU6CjSbc/7vCQZfXF2JEF
	g2aubArYGuXSnXerChFECjpwYc4/8bDZ2nQMCWUQO9HEyUAQVf3atWUqmIF11H6WQ/Va60+152z
	I1YyQy8C2o2D87LZzgBHlE2vADZW9p1ydaBbRlrmdngJ09cM9Ag0J5874EgjUHm00zoARjLPt78
	H7IHNtS9s7QOdcNs4WMcOaaEEOoXF6k5iDYU3vKk6D7YNYe91uC5gFuelPs9eDvF4mfYSHGUi6I
	ig1hlRNy5ABP6kjHfFXp4DsojPQAm9FwkRDSS
X-Received: by 2002:ac2:51ce:0:b0:5be:598f:2736 with SMTP id
 2adb3069b0e04-5be598f282bmr1905487e87.47.1792462452600; Mon, 19 Oct 2026
 19:14:12 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
 <atGqPIpUfX0LDokV@gondor.apana.org.au> <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
 <atL1ok1YkHbA4AaI@gondor.apana.org.au> <CACpmpoe_RXcJM42sTVwk_Qvt3zjAOZhzYZNsRD4xz_1HxDmadg@mail.gmail.com>
 <atMCfhB63koot230@gondor.apana.org.au> <CACpmpocZGHpTTOq+xa2bTnS-=gdUa8+E_KKJm41H_dSfbGikYQ@mail.gmail.com>
 <atadE_kZz45KAeuE@google.com>
In-Reply-To: <atadE_kZz45KAeuE@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Mon, 19 Oct 2026 19:13:59 -0700
X-Gm-Features: AclHuK-O5GRznQ-4uEfzEMIrac0t16SF_OufPYrMOIRqkz_NpjCJyWmJTsaVlc4
Message-ID: <CACpmpofy3P7ukri8vukWte8x2sYz1pNCVXXAN9YtL6=A3BeejA@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A76E5C0004
X-Rspam-User: 
X-Stat-Signature: 6zwewijz793oqmoxn6pxihrbxqcncusz
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792462454-203807
X-HE-Meta: U2FsdGVkX19CP/8HnFQTrqTJ622w6RJgdrjFvr5NfRneM7ZWW7orawK6Yj8iwLT4FLcbQraj0gSKd9rqHof7rSzWzqUSA+cvDTHrs3RNfFizbVfUYPv8Ds+/JrYhgeN25PfDMx9S7z6hK8g6U1cYWMAWVk1SwHiTonJkBBoRczbMnd5YDHw76QYG43kQRg0Js98LA8RAUTdN8mri3oB70W9xSK+65XC97Uo7U1TzwljyPN0rQlNd4IlDrgktVZt5RGtHy8QmnlTFExt7+YJaBMOKimviP51OngM+zrnxu/5whb/OEB0zWPcmg1KMWwDgXR6Vc97yrNJJijvdF4gLLLr57Rq3AHcdcFPqgm1gz3FODB+SY2jJUwJbRaySdln1+YuVOgJ5BvOp2uHGYy0Tt46vm7lHfFJX9zx89DoNevmzpFlUV/5ggP57rn+C6g6kz2QmLIvPRMpzaSLQe58KNyuO8ddOEfGcdYDKZKdV5/dEGZvPTrvi8y7b1w+2za4n11gKgjdd9DJY6pJbaj3ltDnnf/VOR/X9PNf5SdyP2RFgifFfbQ0hZ1Nxq6FEL1TWF4cbuUqZWNzfY3crgRX9Kn+H+r0LQ44hSLuXe7pdEThvwJSUyqrfT33n8QB3eMAwYg1VdkVCB0q7PUxkXVbT09mpVZ3F+G6NsmFb4JNrje0jHmE1wu6c7SEG9Q/4rWgEGQyfqOrbhvwkBGvf6Wwo3Elo/ZF7o1pM0FaMZRNObnpbVj8deLn+NGlPAB7/R0SRm7zRcb21igrsNRD67WZ54gisuHRH33qz28ARa8IdUcBwaZ/061JqB4Hz/WwDFj8JPSVEuv0sUShQt+x6MeayfvoJ6PoAhW/beZlMtCR35oKLrFWASkwML/TlMOBD33TC6MvVe9dTqdCpU9dRjY9T3ASk3YKhNZzwGj66kQk94pIsqqaYUzf8u4wu791bLaj5wAhFY4KKVR0fuuBTrdu
 DSWQpj8F
 DpAzyidNmQ0NdPsyfap5Ns+8xXv9941c4ooLMzbTqoDs9YNeulpx7LL5TMCf7KHJcc7WVHFTCJxEWYRXvGCFHT3OL3gpnPW1uV1F4okLf22R7Kpc1Rp2IvA3y0o20R0DohV+bnDT0rZ9FvzhHsqCC64mJk/qtEEiOowt1Awhqj8Iv4omLOKfCh54JgqC7lk1xlGXrAU/KssGCnuAoIWnsBcCxtzT96BSyxfQGo5dQ6nXvZtoq8sv26pX2TZo47k03Ma8mAinXixN3JHzOZEDC403vKwEujUxV93ZPEuwweEpMPbRz8w3zoT2SCZRYS2yqjCBfExAlGyh/6EzDkttez+iTCK4vDtsa0m+GxdBcnb2BtkdJaLkbjndx2Dq1/yzF082jJdKhJXiXY9bZ285imo0QZp+QRuC+eW+osYzsrWqgbbKJ5KXhkM75LQjQ1mX+L0CvYH+G+gaicPA+zBOY6QZPIhjgiQS/F+r+PSFYptjgAHV3L0NOgtxto4Jfh4BfDpE8VbRjmYG3u0V567I3ZxPj3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 3:50=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Sun, Oct 18, 2026 at 06:35:01PM -0700, Kanchana P. Sridhar wrote:
> > On Fri, Oct 16, 2026 at 10:07=E2=80=AFPM Herbert Xu <herbert@gondor.apa=
na.org.au> wrote:
> > >
> > > On Fri, Oct 16, 2026 at 10:02:13PM -0700, Kanchana P. Sridhar wrote:
> > > [ .. ]
> > >
> > > That isn't quite right though.  We need to ensure that it really
> > > is a singleton before taking the short-cut.  So you need at
> > > least one conditional:
> > >
> > >         if (likely(req->unit_size =3D=3D req->slen))
> > >                 take short-cut
> >
> > I added the check for the singleton req [2]. I hope this looks Ok.
> >
> > With the latest crypto_acomp_compress(), the batch compress latency
> > improves considerably:
> >
> > usemem 10 iterations average throughput:
> >
> >    patch 6 (store batching only): 19,119 KB/s
> > patch 8 (+ compress batching): 24,076 KB/s (+25.93%)
>
> This is exactly what I mean by the numbers varying too much to draw
> any conclusions. I am not sure if it's the VM setup or the usemem test
> itself, but previously it was argued that the short-circuit in
> crypto_acomp_compress() was ~10% faster than the one in
> acomp_do_req_chain() (20,946 vs 19,058 KB/s) due to avoiding a function
> call and two conditionals, and now *adding* a conditional improves
> performance by 15% (20,946 -> 24,076 KB/s)?

I would like to clarify a few things:

1) The short-circuit in crypto_acomp_compress() that gave the 20,946
KB/s was missing the req->unit_size =3D=3D req->slen "singleton check".
However, it gave better performance than the baseline patch 3 in v1,
which went through the complete acomp_do_req_chain() protocol (save
req, do one req, finish req, etc.).

2) When I added the same short-circuit in acomp_do_req_chain(), it did
not give as good performance as (1).

3) Herbert pointed out the short-circuit was missing the singleton check.

4) I added the singleton check into the original short-circuit (1),
and this did not degrade performance. It meets the functional
requirements for crypto, per Herbert's feedback.

5) I cannot make comparisons between "a function call + 2
conditionals" (2) and the functionally correct implementation in (4).
The functionally correct solution is qualified with "likely"
annotations, which can explain the performance improvement.

>
> Moreover, for zswap with ZSTD the added check is always true: the batch
> size is 1, so slen =3D=3D unit_size =3D=3D PAGE_SIZE for every request. T=
he
> previous version and this one execute the same code, so the 15%
> difference can only be noise. With the stddev you reported (~5.4k KB/s
> over 10 iterations), both differences are well within the noise.
>
> I think something is wrong with the performance testing methodology
> here. The results are self-contradicting and do not make much sense to
> me. Did I miss something?

The previous version and this one don't execute the same code, as
clarified above.

I don't see how the results are self-contradicting. Can you clarify
what you mean by this?

OTOH, the zswap_compress() bpftrace results are clearly reinforcing
the benefits of compress batching.

"Sequential_zswap_compress" is stopping after patch 6.
"Batched_zswap_compress" is stopping after patch 8.

I hope we can agree based on the bpftrace data that
Batched_zswap_compress outperforms Sequential_zswap_compress.

>
> >
> > bpftrace measurement of zswap compress latency per-page:
> >
> > Sequential_zswap_compress  nr_samples     p25     p50      p75
> > p95       p99
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> > zswap_compress_ns_per_page  1,722,489  43,947  57,791   88,489
> > 130,165   323,961
> >
> > Batched_zswap_compress     nr_samples     p25     p50      p75
> > p95       p99
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> > zswap_compress_ns_per_page    665,267  41,511  54,915   77,707
> > 124,648   213,962
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> >  Latency saving (ns)                   -2,435  -2,876  -10,782
> > -5,517  -109,999
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>
> I measured zswap_store() (not zswap_compress()), to get the per-folio
> latency, and it didn't seem to change much beyond noise in my testing. I
> also notice that the number of samples is very different between cases.
>

I was addressing your earlier question about why not just stop after
store batching, and why batching of compressions is needed. I would
greatly appreciate it if you can review the zswap_compress()
sequential vs. batching per-page latency data from the bpftrace and
let me know if this convinces you?

I thought the overall zswap_store_pages() architecture had general
buy-in, since we bulk allocate entries, etc optimizations to minimize
locks. Please correct me if I am wrong. IOW, I am focusing on
gathering bpftrace data of zswap_compress() with batching since this
was the main patch that needs buy-in.

If we are on the same page thus far, can you please let me know why
bpftrace of zswap_store() is important, and if I should gather this in
my environment. I am happy to do so, but not sure what it will
prove/disprove.

Thanks,
Kanchana

