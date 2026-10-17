Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39F0BCCA463
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 05:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 347026B0096; Sat, 17 Oct 2026 01:10:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F8356B0098; Sat, 17 Oct 2026 01:10:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E6B6B0099; Sat, 17 Oct 2026 01:10:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE24E6B0096
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 01:10:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8E5B4A0145
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:10:32 +0000 (UTC)
X-FDA: 85330942704.07.18F2051
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9C7D140005
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:10:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c66WkGDJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792213830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vQlYW/4GolznyYu2RkLZZnREvlSq3a4QuJHVVDOo1oA=;
	b=TDGV6Qt+qsgSXjd8tVczc0lmZfAS1xX6DA0pKcQBk6qwmzao4zhbkU9kEuBZOsfOFuB+jT
	AEa6KClWQmY1guFwR6e+R1846miuml4mZHJzkM+ISxsh+/UNaF3XkaoqxnKcLIffGbxuwt
	d8btJLYuWH3K2uouCQjRBAiRSw0U1dY=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c66WkGDJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792213830;
	b=pa5dVpsltQkJ4ALyrZBK0fuC09DCBoaf5kOdjVZXUxbUxSP5gqhMYPs6Y2BONxx40oFulR
	YuejH9DOOdiH1I4BzpRpzmFZaanKftC6XllCqnbljQVMBDb9fGTueFfv+xftyoBw8BgZF+
	4z8AuK6xrah53DKnAOt5qr7eKGKmmso=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5be42ae8eb1so380669e87.2
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:10:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792213829; cv=none;
        d=google.com; s=arc-20260327;
        b=TsUsQWf9V5fjSz/iFmMVfQ8L99LYeqIjRlZ3zWRm+0v9J1S7k84Dr382aJnMiEh5C6
         MG7ZEXySxpm79LTM+IZx3EzKdFKhBIUYHl9YNrEgfbFdy10AK8oPvVtiwIokeyMCEQSp
         hxBnHLrpgI+HTZ0sStyPLN4KNpjmcpK4mtQ5D+KOvGBW3M8KYTBAe7JUdFUTvvZxDnyL
         TsoAdg3HcpmBoF/HdOeDIU7vBsENEsgFDmZBX9BByoNTYVinPXMd6QBMjQ9IaUsiUedM
         lEqRG1LzWKoT4sRa//k0e3K0scLwJY36ICKIYz7X1f5tMijHeEh0EsX6ugcn2WReuoe0
         yWSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vQlYW/4GolznyYu2RkLZZnREvlSq3a4QuJHVVDOo1oA=;
        fh=3RoscBpFDoZ1yM+H4gDDmTGlH4rpmCPvr3miS9oAt9A=;
        b=ZXFFbC+Vp6Ajo9kA6Y0ik4XUft/7Fr1pYiXbIAneVft1p7AcqK9/C1fj2RO7lHoS3p
         fiPM40iuYioZPvf2Fq5B3w7V8gT+Bf0lY0irnw2c+kc8Selw75IExzm/r75pAFPacVxK
         dUUjK7FvZbKBWUcfMaJVvhpx+LzugC2kOiCmKY7nBeKzX9IIiA7SoA/De1sZR9AWkKU+
         kVtOZ8jNybEe5WR6/gZEjsPQYQ7EfhkXhrH+29V9/Fp0Lc9sIE+QQvri41KEfGb8WqQC
         vbaB3sykJx2V1idCPbNYqiNCo4DImM/PVrTcAXM+5nx8rynjIKVnSkvOApfjKj8KsRlF
         6W7w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792213829; x=1792818629; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vQlYW/4GolznyYu2RkLZZnREvlSq3a4QuJHVVDOo1oA=;
        b=c66WkGDJrzE7EAknJOR1cQeKXQmezx0alkbOoN5WoYOpLvgrDRV3AUkLrE5BiEIVtr
         Dd/1lOEmFluY7XU6YF4KEt2jZXgI8P/cRff7oe9iN4eqeK+1W3tWNvepf5nGLb0MUmN+
         OXS0/BBqeJiC6u7OiKPpSFbHQUQEY2wpjmb6/Vaa/lKE9puHxToh1Qn3g9ACJXdU0X6T
         D8h+4FA62JquiRN6w6g+Y9fFN2SleznJ9ezaCxbAJwctjfi4UE4bzyd6z7G/t1y8fluI
         Jfk83yQn1ICCzuUOknv3xSa/WJcXhl7+HV+/QiRHUPVmytKqIphGqwKEca15Q4eWytvE
         7rRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792213829; x=1792818629;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vQlYW/4GolznyYu2RkLZZnREvlSq3a4QuJHVVDOo1oA=;
        b=WIRbt2xXPkkGza119FfIwylResenpw6G5gssgmEMHrXkhxx4r6G12gEcZtypZkHc+K
         qSaXXy+bEEpby+OSDg6ZXz/qH1dag0sBeT76VS8mEsCPejummjBo1+WIAGlBd6/QC90T
         8NtVvOdMADI4Rxf4BtuY/qa8zMl5c5piZ3rs3qb809SloDickkVByCKy5yiXdzpqxvpF
         VzQddbNo2XGg/awZHRbjvWSCLOy4CAFsC37KqU8+uZxFv21SRMgs5StLe4lmowZJZ2re
         fJWBly/BxaYpZnOx9xQsAOby5C4dyfEwMsHbZubgRFIMofWjgldSEAUaKS5jM+CeFAnI
         E12Q==
X-Forwarded-Encrypted: i=1; AKwUvBxfUJr4HrZppl5J205J/q4NALKgJco4je+4R12hlCT1TGw90d9nLjKvHuOkhC5QgQsqYm3gZYcuBg==@kvack.org
X-Gm-Message-State: AFq9FYI95eL92U7XsR6JEpIy7ABbv3oINl5zY0J+rPLcoKzK7H3IiK61
	ODfcrVxsRE+4OeziL4seSrQbdaAL2qRe3uiNh5OBEel1f8lcfWxt+X9JtwTAmy+15uUmYTmbz+h
	JDFNitWBOQ+SZ0BhHLWvKsrf4BWaBiCY=
X-Gm-Gg: AYBFou0dp6fJIHxwrdZ3zKCKMUI+lsCkfkVKRshbU2+8h/V1Aru06KUpO2yKknnJFuR
	QpQM8SC2wON+Zfu7WEbqPo06HZtjnTL/2e2YyRs5jdYP1rVMoLA5mDK9sPDUFdw/BiRBfRq73vr
	+sFUPebQOkNUJENwTmL9/eyaeG5KxDfxJeVn11HChOQNt2S61nYpdsAeQVLK7bp6OGQGhk2tTZY
	+rJb6PsTlx0DpybCDQLGw4wiV4EksIe1Qus7u+4C29zUYUMnuHF6LKTBTf6R1V0kv9d25CU45gb
	Im8op1/Qv4Ivyb/MihQWbcTMVbnvJ9gPI0u/hU1z3fmERkI0eJCH1p8=
X-Received: by 2002:a05:6512:3d86:b0:5b8:f3d5:f2f1 with SMTP id
 2adb3069b0e04-5be50a70ea5mr520864e87.44.1792213828898; Fri, 16 Oct 2026
 22:10:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
 <atGqPIpUfX0LDokV@gondor.apana.org.au> <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
 <atL1ok1YkHbA4AaI@gondor.apana.org.au> <CACpmpoe_RXcJM42sTVwk_Qvt3zjAOZhzYZNsRD4xz_1HxDmadg@mail.gmail.com>
 <atMCfhB63koot230@gondor.apana.org.au>
In-Reply-To: <atMCfhB63koot230@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 16 Oct 2026 22:10:16 -0700
X-Gm-Features: AclHuK84HsIT1U2LdVEFrL_f9VcnNP3gGMKOf310qvYc_nXv3zBiGFi7dT1VC2w
Message-ID: <CACpmpod1mPeJFoP0teZ3jc3B5z8Xhz6SDQ2FiLY7VERExG5zKQ@mail.gmail.com>
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
X-Rspamd-Queue-Id: 9C7D140005
X-Stat-Signature: hz96domm3jsxyqtsom8tpcgtuxoyob8f
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792213830-744282
X-HE-Meta: U2FsdGVkX182b4hEo0I+3Hc5mJB6UcWdDlH70zMJu6YyYZao/iPpfJfbLjcFuSU2NORLXa7LbufdrweQxK8oEst/vh/uDm5JqQ7ZPJULrcz0lKPmcfUDxlj141gMzRwlCJ4zJMZE5uGIs2txOxFuSdohS8F9oplRyT2OPxLtwoI9VJ87dgDza+qD71UqM6jV7+vDbbYALUhSqMqI+Uu+7tJe2oeh2Uhl59beZhT6curLqJFnngtGPvXOMaa716tFGzNCQKK+xIahwmC2w3O6MPxTq57HZPKNbLxTgg7U9JC5OOEgkS18JGFmGJ6wNoCokU4LuZKlFb6y5AlhOLStS78NKXgmBcV/TV0ASUlB5bQa1Yj6HJ54AxTkVNfJFnE5DsEAnKiGJoX7GD5ZV8DMM5osW3MFqO1Zv1WIsJMnljxPAhsoSVnbPcJ9wMtT+tazjtDVfAk7nI7NhDwlaqk69kQ6gAzdU4OHJDLftyBRGe3C5nCK6DPvDMinOzNM2JpDGunzkVNtFe+hMkiQFG9d7pg62QFHt+VdUOoX/ZM0lXeqhX0QL8Ydh6zmjk+3o1XZomzh9tZ3mdegxkX8ecaN7Zr2llfzhF7ycazSLYPn8QSQXy5mFVGCl5ooL6i3QvVRoypW40x7PM9K3r2agVUJaVn3CgqWYjXbj7VHA67EEb8AxkV+ecG1MIizeDdHlM/JuTGqix6EWkW4NQDVZVNS5werNU6dgVPmlIAnLQB6Hi5bWdVvewtEl+kSzTZyhAMEYc10bU79ru17kegie3v6+oatcfIMURYYjj7z1C0T5KPNXQdiaSh2AxQSRza2SjhheGWGCIH7oAk7EZQxGtnEfdvAfIea8YXzSQxZGWbYuWOAlUtJhwPA+gSkN2WEi88cv2fuZg+D5UXrE3ZD5BsC9UmDy3SXi09rNIjnPHLmaf+WNFt21PcD6Itj6sCUX9smlO/PLkw4iOmYHu2PI0Y
 35qWeRsd
 giEiD+zt+oGwpMtrNTh5QuINQ9iN4MAATPHemhJcUdIvH2f3C+ggXXo+msgcE/iRAHgG3yAmuqhjRr1Iz5JTKdebLMq8RvIcB9sRDICgIrbp7Xdx53sinhrHwh5OviUIwqKoLCXvBoVbPNEE/SrtmaxJiWED2KMs62m5SrO11yPhpIaNhKj9EMwM4s4HsXHQDK3DkhuEu3HV3cCbIzcG+f/Q0oVFM1nyRPthvp6hgRs2RJfM+vC96snSy+S2uX/+/mmnqUfuAs4WPoAEqXDNux2Tee+5/tCEDfqCNQQt00Xst2pWdxONynV3waNuF+TZNxum2FZi7BAAKtt9ZmIG39puC1Pf7LcBPbK9mXolRTWDG3nG1Su1tReJHRG1Wk2y0DYXYo2jNZHIUKlDBwgin/0TMKJH5GlE7UQinCZqmFv3XCdUDT5v8gw5wFFMx2Gwvv0Y8jtlORwYqUdAfh5R4+N3mhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 10:07=E2=80=AFPM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:
>
> On Fri, Oct 16, 2026 at 10:02:13PM -0700, Kanchana P. Sridhar wrote:
> >
> > > What if you just do the conditional and short-circuit in
> > > crypto_acomp_compress?
> >
> > Yes, this is the first option I tried (20,946 KB/s).
> >
> > [1]:
> >
> > int crypto_acomp_compress(struct acomp_req *req)
> > {
> > struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);
> >
> > if (unlikely(acomp_req_on_stack(req) && acomp_is_async(tfm)))
> > return -EAGAIN;
> >
> > if (likely(req->unit_size && acomp_request_issg(req))) {
> > if (likely(!crypto_acomp_req_seg(tfm))) {
> > int err =3D tfm->compress(req);
> >
> > req->dst->length =3D unlikely(err) ? err : req->dlen;
> > return err;
> > }
> >
> > return tfm->compress(req);
> > }
> >
> > if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
> > return tfm->compress(req);
> >
> > return acomp_do_req_chain(req, true);
> > }
>
> That isn't quite right though.  We need to ensure that it really
> is a singleton before taking the short-cut.  So you need at
> least one conditional:
>
>         if (likely(req->unit_size =3D=3D req->slen))
>                 take short-cut
>

Got it. I will give this a try and let you know. Thanks!

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

