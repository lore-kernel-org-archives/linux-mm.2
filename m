Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B312DCCA463
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 05:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67A986B0095; Sat, 17 Oct 2026 01:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629A46B0096; Sat, 17 Oct 2026 01:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53FC26B0098; Sat, 17 Oct 2026 01:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 27F9C6B0095
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 01:09:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 749AFC01FD
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:02:29 +0000 (UTC)
X-FDA: 85330922418.02.55A7735
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 84328100008
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:02:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mL9Vco31;
	spf=pass (imf14.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792213347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qA4ufMq4NgXLgUYdkQ43Xh3EEM7qAnRV0fG7/RHdhqY=;
	b=duVd71a52O9ZfGB+f6vyYoDrJeapcvjVQ2UALClqjvCE5RfYSoFYo0wBa7/ELvYArr4cb2
	SrAkAd+fPF/QBn46S9Wy4GIzk+R1M3h1dWxkJTlCckDgPt3szR511kqtxpdtnkAqfprgZ0
	5x6VjEw9lGgMJHTtnK2evqv8PYX63cY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792213347;
	b=3p+E0FfIM4nCoAhs2NMqidyGlXcHkMHVWTQVBk7ex2JqUOecoYJCud1oRG1+rs6+7qq4YB
	/AbVoqyzaYZqVzeMsiM/I3qAQwP26Irt4N8tSBiSAz/asjP5ye8iaE2abdjR7FpHUXCLuZ
	hw/fbAAPl+fXymnsvjtQY6HpsZtAFSs=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mL9Vco31;
	spf=pass (imf14.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5be4d648aacso487756e87.3
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:02:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792213346; cv=none;
        d=google.com; s=arc-20260327;
        b=SvYi6rqD6UF0SdwN5I5Q8aN4tgr/7jWc+1j5O9dNVi8j0q/P3CdmABxh0HMUqNv1XI
         R9qG1fbplpzLg0ZQD3RW9IPF0Iuzaiol/cIlWjWLT6bCAG1wMFcPpMsyJpBuQU60cxe5
         1/UWEUsU9e0xBxjwqbV3aGPneNtNozGVrD7TZgmw14Od9uYftFdWj4/qk15bVcXGr4Bv
         g0R8mY2tHuozSBBaeQ0ceDjqTBLPDvlz7HVeOsm5s2UJ/BNaFBXQkyAbqOLFSySgR5m6
         gk6OYrOMM1LmniKcBVOdkh9jK3HZXHzh7DWXKh0TGqNp/tKjG6NJuYr24TuKmKhxtGyh
         myUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qA4ufMq4NgXLgUYdkQ43Xh3EEM7qAnRV0fG7/RHdhqY=;
        fh=6SPkUASJatPuZobR5kdm8sQYhD0P9TcHaPWxwnmB8eI=;
        b=FElctZBCfFhN2RC2CNzB+0xof3nM5m+JSHGmWBj3SKArADIuLKQdlX4E8zra8HHaiP
         zLNMp/b+3z6mkldHnwkyTVjd18xqQQz3TqqdJRJqsjb5iksBzgLP15zPhYDBIu+AOSA8
         y3ncghEb1d3UgmbzQekJ94z1tXmusPpfhcG8vIdEhlzeJvXbdYLO34YxlmCDzv0FvZQ6
         iGEWSU7BMTOG8dZPgPPh1RxENZKOK0Ahqsni99W9q0PFszxwMTFQgTtX5WIxj3oStW11
         yGjquzkbXzBkozsPkr2eQgcCkTXWhfK/IAum86yVUFussIgU2w6HaX2tHhcKnQrnU04a
         75Og==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792213346; x=1792818146; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qA4ufMq4NgXLgUYdkQ43Xh3EEM7qAnRV0fG7/RHdhqY=;
        b=mL9Vco31M+cXGqYUrDN7NhnU13FqxOYfpCM0hjK0DDt04PW/KWIwAU8A2oLwSXNjS1
         kq6toFh4A/YgWMDpSGFDNZZ3mln/mFmeCb5+7nY1/6qEwS81nxYWbMoFyuUec41pGeM4
         6p2PAQWScdCs/vpiLfJjBgoP2/zdqe0VrCrtCiLgH22fBNix6h702mVUChT3nX24i9xf
         AEOTwg26XOwAkncLUu4JXWOIHsUy0py8NERNHMEFdovosUg6G/xQUBlA0RQZCtva5+s+
         ojKlgUZBgq/K6xxvABP71b/apjGmPa46SVxDaE69vSAWEhPh3pznTeEmqytFd9DNNEy1
         0oIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792213346; x=1792818146;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qA4ufMq4NgXLgUYdkQ43Xh3EEM7qAnRV0fG7/RHdhqY=;
        b=fXAsRtSozvmi7kKweP/YlJHoJmpf2EWinMMHcADVMHGDvPcgfA4Iad51c1O9OLepiL
         TB+o/XFPwOxb2Eg4wHv1Oj4PCmrk+BK3K9F2QOb2+KD5uReHanr9CWv6WYnEeUMhvCg3
         AQXXT3DAGpejE8H9mNaCzC9TkK70W3Rstu189nDKCqN7Ijz8e+K7aAehTlXXHW/lRbmL
         f5FEe3PeECrvHwU1LK3TXHCmUWN6FjZCqj8puX62txE4ynMDZsvGJx/yO/DM8rGrzdPv
         Yk0q7ipktEAxsOR8pMv7f5gFmUea0kqeRG9rGsDaN+sphSKampVle3Ju7pdt8ATqFK/D
         6CBw==
X-Forwarded-Encrypted: i=1; AKwUvBwskOc58nekc2pRsBSK/F7ibBRjndrr0qCbLjGwQ8Fpcw5Q02tQ6A1DPAEUGqDyME1mZRRbglv3AQ==@kvack.org
X-Gm-Message-State: AFq9FYIhWJKCbbuk4DYa7Gjvc5dZqEPVx8rRZl5+FHu2W4e8PQKm4YHA
	SY3n5GfL5OrgXkoI15N7Ftb6KWvtbBtI//mjhIeIxoz+8PnccgzpKMvr6tUgLheg2ISDSLtWgG8
	CzdrM3ztG/VVlPn+p2mHq2meyeDgCgDA=
X-Gm-Gg: AYBFou1oVNXRVOd1Pc75yaS9IOqzdP/kM/Elstzc+dJ3oV7QBOB/MOe0+CuKw4CUqMd
	fyUxvJmCUtQlnQ88ijkURmpyoqzgbHsBdEafnsTqytD74bvxJnprqOW+vwll/1M+R2HVO3LUzt4
	MXenVjlaDr22nLw42zbd0Ji244CaKB24/SE5bFpJ7Ec4m8y04q4MukaORuBl5i5TYPX40sCaSOT
	KcOj1xqccrRWu4dmI+i5KRx0+q6hPaIoqvoSaCwzlytnKcsm8jG3RaVZX+I8hanbQfGFqeLVLfU
	TAlOMqKqAFG3CIziHkqpE4n/2q3lAkQ3F08CJdthRYluHATRJafSXWs=
X-Received: by 2002:a05:6512:3b24:b0:5be:3f7e:7409 with SMTP id
 2adb3069b0e04-5be50a71003mr464282e87.43.1792213345431; Fri, 16 Oct 2026
 22:02:25 -0700 (PDT)
MIME-Version: 1.0
References: <as-jZopKRfuYAiTE@google.com> <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
 <atGqPIpUfX0LDokV@gondor.apana.org.au> <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
 <atL1ok1YkHbA4AaI@gondor.apana.org.au>
In-Reply-To: <atL1ok1YkHbA4AaI@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 16 Oct 2026 22:02:13 -0700
X-Gm-Features: AclHuK83Cy-eJhLJZxzQLRm52k6Crd7V4JEX6EsZtttKAdEO7DhI1ttSz_5rhrM
Message-ID: <CACpmpoe_RXcJM42sTVwk_Qvt3zjAOZhzYZNsRD4xz_1HxDmadg@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: i8qf585otr5t3yosqewz6pw384o6cn88
X-Rspam-User: 
X-Rspamd-Queue-Id: 84328100008
X-Rspamd-Server: rspam10
X-HE-Tag: 1792213347-984360
X-HE-Meta: U2FsdGVkX1/WbZ5QjAZ0J9H4UvRNcClGsrLkI4PeSsQZTVLiO63SkblZ3QL8vgDcQ9bbDDwyx9gwZkri3q7/qvlaeQV4a2t9y8u6FIOIWQaKyatwwPA8teL7h6lpMvfmRL07Y4YAa97pAq/8UhkTJ6ldnN/nSt5VdUVCQqqUM7q94DMJHfeGU/VAis0Wea3fUEOBrjJ7ATOJnGXHE05k2PXJUB0nd9ihIEFUWzwiub0uOw9FHO9ysoequkDkw4g4FkKOdaqBk3gH36NnHpdDE/b5BRkp+6paL5Kva5drCGpXu9hRnhZuFIRWafldEVtJjsdia2pDUeJ002iY91Gv16SGfGwvHF/CLxPkYH+ng9mNq1BQyknlgLfdvppzoZFMtYQBx1+c+X+XaP0lru79YFxR3gIGQldwi4FHu5mihYXAQXj8235ehNrHnHPy9yhYtJNsR4GLEX0t8ii+71yWNZY6IK1TYLQ9OJTqFEE4LRJty2zwrIdpcgNZWRGtddsDTab32Nq4reKIFyMXzDYHV6mheOoBA/NQblN9toRnQKJ0xeX6bdh4h6TPxrynytG6o9BsKuiic3BNJ/DHDE1hoPUa4iMidPuF7Gj/UAwaMnKnvJAtvwaeFNOKrAL5odxHH7L3d93lMnJNSNLpVnOn85Gp/R9kD2fuZOY6/m/rrliJbGcQuJkTY6oolS+3zZXpJt49TY5YZhE+Z3cnWFfJPtJJ+GiyGt+SXz4dBwea6omfKfHZrZFvNUnwwfbOBlibnPmU6Hyxsvp4xvc/qmySjCWinrPVwtIkoqj/xVemd3hz17QWn4w7fFWuZZdrYctVgEzt8t0nydEmZMGKIneMB3QN/EdjZwBQkpTJDWrNQHNN8z6795CEMQY9gtSPavLE7uCtWRtyW9Mt1D5N7G1+aYLMIsFx+SIZ+fS+w+LGkgtIytTpj/95cDqw9vHzvlUP1u4Q1mIIIY1dTyUvQE7
 ZNeb1hM4
 IyUCKCavfcpZ+u1yl5tKQXgbxkTdY6mqcLnLHksPfJGklbJd4RCL498LJvV+vFEPfXwwlmPRSSOLiTUDQfWzblK2feX1XatrmeXb7ODxUWNvsS2iDA4oDQFY9tqKLjMp+czkb7zea+OXZ5JI+KxchuxCjDQeCq/V+uCPK7xReTsLPSfeVnT6NT+UHvYgb8eZW/G+tD1g+d7VrQE5r7xrtqXHYWM1R0F4ndYHqj1BbIvp+HKFrQrlBGWWTZGR+R5syiz9H21fu2QF0W+o6IztcthmfMs+JIKcCUuXn04yvpL0KuyN6MLJ2a30mR/e46AMxEO1GNCXVBCvl2wFn4TwVPp5859aL9Scxj/XXck7CPb6xcy+/ZiTiIku5g1FSx9k/SkiO42U0dBzQPcmCdrj1JOWvJnPKX53w7tulah3Q0TJ2lxZecu3bUeS2zgn22t0HSrnOmSvwgYnf6C6FKjwaQKsw6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 9:12=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Fri, Oct 16, 2026 at 08:03:07PM -0700, Kanchana P. Sridhar wrote:
> >
> > The Average throughput of 10 iterations usemem is 19,058 KB/s. IOW, I
> > don't get the same performance boost as making the localized change in
> > crypto_acomp_compress(), likely because of added computes per compress
> > call (one function call, two conditionals).
>
> What are we comparing against?

Sorry, I should have clarified! The comparison is against having the
conditional and short-circuit in crypto_acomp_compress() [1]. I was
referring to this as the "localized change in crypto_acomp_compress".

10 iterations usemem Average throughput with Conditional &
short-circuit placement in:

crypto_acomp_compress(): 20,946 KB/s
acomp_do_req_chain(): 19,058 KB/s

>
> The thing is that the conditional will have to be there at some
> point as otherwise this becomes pointless.
>
> What if you just do the conditional and short-circuit in
> crypto_acomp_compress?

Yes, this is the first option I tried (20,946 KB/s).

[1]:

int crypto_acomp_compress(struct acomp_req *req)
{
struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);

if (unlikely(acomp_req_on_stack(req) && acomp_is_async(tfm)))
return -EAGAIN;

if (likely(req->unit_size && acomp_request_issg(req))) {
if (likely(!crypto_acomp_req_seg(tfm))) {
int err =3D tfm->compress(req);

req->dst->length =3D unlikely(err) ? err : req->dlen;
return err;
}

return tfm->compress(req);
}

if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
return tfm->compress(req);

return acomp_do_req_chain(req, true);
}

Thanks,
Kanchana

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

