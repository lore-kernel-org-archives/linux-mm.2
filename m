Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0778BCCA46C
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 03:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDBE56B0092; Fri, 16 Oct 2026 23:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB43D6B0095; Fri, 16 Oct 2026 23:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA2CF6B0096; Fri, 16 Oct 2026 23:03:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 980186B0092
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 23:03:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F374401BC
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 03:03:24 +0000 (UTC)
X-FDA: 85330622328.05.F70A797
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id 369E940003
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 03:03:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T4PsQ5yr;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792206202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ITlG7B4NPmKc5iTiQo1+RWMGxf3FDyH5p5Xf+trlVM=;
	b=pE8LErYU9H5ylqqfrxu294+QA/9SUvbyw2eYp0gTGq/PKX3OVuQXRtpyd8sxbcSVAiqmO0
	4+Ejeg6bR9YdkQkCxKKqV/Te7X+HR8fED+dqz8c7555nmdBgZPnKdjPIlQLu6vmHN948Bs
	RKXXDk6u3jaJ2gTPH9UYiRcLnv7w6ds=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T4PsQ5yr;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792206202;
	b=rjugP+I59NNmPBTV8re1MGS0jLLqcA5ag/6pBtrVHZUQTqvmJPtnSwoz066cDQrdVV8iCn
	Sk89wHh3UdeWBPAkgNMM7zsK1UcfOgIFNegCjmslNVLbNnaO35pu112fTUSe328Wc4QaGC
	kr7zsU51V5FTJhqbCp9oQevvozMYOwA=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5be3ea5a7adso452509e87.2
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 20:03:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792206200; cv=none;
        d=google.com; s=arc-20260327;
        b=F+qk6bs0BRJVtvf7grq5b7FpUwtWHp+a4/cSM9jAN5EqbS85fIiqYPP7WmF9pZo0YG
         5bj4xDcVNLGPku/1FOyFOPE4dveqzRbjH1JBHHdQEPP/clp1ez5VBJJyh4h4VmfL/Oqs
         nzZurT7JyHvsZNbOtecy2b/jaj5kRwLLjrPAqjdjC5G8oIb89chAm5Cb6FnxO51VDM3t
         S9eOxJtq2T8aXnPhPxy7gGxXCEIodKAO4/vBVxmVDxSaEaumIORHjUW3mvw+l6sPIhCV
         3R5ta1dqUz0wt8QKwBaKmT4BNtYTROISFFCHyfx+GjvWFsbEYA0wbCONShW1whODV7bO
         +FjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2ITlG7B4NPmKc5iTiQo1+RWMGxf3FDyH5p5Xf+trlVM=;
        fh=vUdgPtHcjeUk18kEcX5/whqdtiUicM3z2Fy1zfaDdyc=;
        b=nkphZ6HPF3/5TZ6HfwfJOhJ0CuZtQ3OQraRwweu3jy0Ry3yxHoIbjo/nr7aY2bY4Pp
         JSg2c5ybQsRCEh0AE4NyMoUFCm//n4zzFblsXy1cW47/6wIuxcMDnHVb29nqh85oCEKk
         2Jiz7+fvXG3YOdKEc1QlgC0N8DUZtDgSv9CIJBL13aMXH5HbgtArw7CiaYsXCjMMuboP
         xkvJKVPdruKzOUYELjBTKDQHS1nuhx4Yu9ch0d/ddyjp/q4dzHfyCNKBnNjEt6UUnL/k
         bJX+6yHN4tliKpy//uv60cOpaBLVdHm1C99UscFVty2l8QnU6tkQO+CnhYIh2+1/NB97
         6EhQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792206200; x=1792811000; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2ITlG7B4NPmKc5iTiQo1+RWMGxf3FDyH5p5Xf+trlVM=;
        b=T4PsQ5yr/i10Fqn2Wy21wYgFi0rhcBqYmFIJevyClU7KGswOI66fY4TSN9dZuWYFO5
         5ZPfFv89M0zBQ5zp2vC93TOK5xlalXiTJnkY+3iq+3UZb+71jL3nuUgsNEJf+qBFhKDi
         IAed+IMO5AbaIYFGjZ4kdvPvlYf4OsvaTkf6M8FAoXvNtVgjzSXiIZEtBu7JiwXsGoKM
         R7GK9U/6GwzzaauQOOYoPy1s8O/eJ4SDcFmFMSGH6XhjBkAqoMg7GN+PNfGDFVLe01Rz
         mw69I7T8y3U84eZzj0Nh1az9Cyn/+g4DPxpRJ73N8KFco8qYsP6M4CcyTS4F4IHEkV5e
         A34g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792206200; x=1792811000;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2ITlG7B4NPmKc5iTiQo1+RWMGxf3FDyH5p5Xf+trlVM=;
        b=i1rMQLpBk4T4VEtpxJzQYv0liVHgtsspl0rzL8dXK7rYOgV56kaTuYxF0QR9egMNFT
         Q3HXS8ICvMi/2EiZCC/meI5d9ZINaMJb1l3JzviWQt1huB37vc//v80RxhrmFYiPsKSr
         NBlaMpX5aHt4Y04FTK4DhJmJcJpigi+iXQY1q2eL3JLmWWkVirt87PXJOa75urWhN3KX
         5J8pzEXAKOuVMAj3bj6HZGQMKCJu7uowYT5fh2uglFIRAU5ta1GdLfPrge2mFrJoiEXD
         nKJyt4Lb7evRSY+r7Ibk/+kLx+BmD0593D4KfC/59DL4fBYOIhgUm/cUI6ZkEaZW1LHK
         YHMg==
X-Forwarded-Encrypted: i=1; AKwUvBwyhJ8eadSb54t/Z7cekIQNLqPVwz0TJNo29QyAkLIHvBMxE9wjyHhUHRDbVA6dskf4Nvl4fqKezg==@kvack.org
X-Gm-Message-State: AFq9FYIITdj0UoUpOFENcBgUK6lzC9PkgnglZFZN2D3gFIUXiZwkAMye
	W5IX6xaImWO4IfyOcq6nwLImzO1HDTPAHLUQvc9i52fhwvCCiTCi2Hx0VgjaHjSlVQtxJFcNnUh
	Yk73xCbmubtAbMx6eoc1w9lkHKJtyM/8=
X-Gm-Gg: AYBFou2V+2bDh5VPPxJL6brUhsg7278CW/yWDhfpJ8Z0jnHnbIZxeojVuIPpxy2l8js
	JEfB3Szjgukp3FwVhpMv26od+J1cetD7bLN8ZFIl/NXM5nZgpl+YIFbSM92b3ZOA/bUAk9vSS3Y
	QKoSxCzat3NG163oBaJwFzf6d/RFPP6EaxP5qgr6n5som+StGYc3SG0REdb6wlXhmwHY4KMTDCi
	O3VBqS33olqVxD2nOYYZ3tlXdyrzYLZVbvUhVaQV7o67RcxoXNaRBcj/W9wEaEcTEErz4a5bpv4
	MGRqlWUoBhiTrCcEm9h/snhsr0QWmykQEECPp4p2GEXHxWeexhHEbVw=
X-Received: by 2002:ac2:5691:0:b0:5bc:e13b:3922 with SMTP id
 2adb3069b0e04-5be509a6de1mr460213e87.0.1792206200169; Fri, 16 Oct 2026
 20:03:20 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <as-jZopKRfuYAiTE@google.com> <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com> <atGqPIpUfX0LDokV@gondor.apana.org.au>
In-Reply-To: <atGqPIpUfX0LDokV@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 16 Oct 2026 20:03:07 -0700
X-Gm-Features: AclHuK9xQKLEm9ED0FPrZSYZivJi3qifBTa2ucE7flkZGwWDvl2MosDfqLg1aQY
Message-ID: <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
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
X-Rspamd-Queue-Id: 369E940003
X-Stat-Signature: katkxirmmduqc38zaxof9xnk9fwmuwmy
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792206202-320858
X-HE-Meta: U2FsdGVkX1/WADa5hHdoa7wOQkaneM5h1CzALKQOOwxt4aQC5sL71+1QPICwkOu/IlwgKnPKdflk13aBdq55iXzffGfKknZ8FAOFyTwOao3tuqtLfuD5V1r/uUZE4s4mHAKnVWI+AQlDFjHZ97RTXeuwTYJDh+A1QAqZrFvZ5ACy5ICpK1cel752mb1nEVX7U66r2EgVAIPGhv5sQAkiTCLa5nfzy4u6U50CrlfuCwoz1n12m4u1qOaK0QaDAk+3m8io1juFkJmzwxXWVnPOx6uXRv78R4KUERbTtpNdImJQkDPDUPAsDfqrn8c1OwIB5qFrI3+bOPrlA1dg63GmYttWCXyQHWvUzI42bbZQBVleK3JQeVARSymxfa73Js85EXKlO55sYuw3t35JqM6hlaQq2iU0avbrjuXrBRBhZyRXDg3MUuKmojC/bc8qvJI82jh0l3dqNvMgxrLr9P3gjr44BtAi/PiWyixYlqayGonpS7RJjCemZQVgy8SQoUsdUcuoNxd/xbWWLE1uwlKDyFZb6j4Z9DXorVUBP/gfHnc8ukgi4rDsgPtCTtvFjfbL0ZwWkp9vX0vtEj2iOvmdXfpp2bvi88/cSUgGqNjuk3CcghJr7lDCtlhBYkzZFlByPAkZnVPCoBfJn3KlRTowFpjhagLI3QsWmwCkIfUvSScjUib1VlfTm91bz+FX6Go3adNT6TfEiD2ytLMkYpwJLAx7NsugPBmG0/uDOryFmWvANkiRa4ieZ/kAoBd1uBiT7uWlR+O6sWTCzVHwEfNViOOZMhqIRvbxcY38EcoM9Uf1fUxLqrY0hf/OM4Yn1Mu0/raH6Wnb9WZVoWgsadr1/RYiUkYGW6a1aRBRnwVLOHxub/DQLVi7Q6WcKewoUSX0Rk1dx6ckNBCK/3HaxEyvX7gjLr/btHBiWRxp2KIPI2HEl5mS+lcETqz0AXdgsd2BqGrPR4X9klWKMmn+iMl
 KIE6iAmK
 S91MCkMOBa1GXRVmsgBrILAhR+czcmtWLt24fm/O9H/09kUvKBp2vKgRcqZBTCdxqoYCcQUHRRoOwm+lg54QRDUJ3+i56lSOom5eWkiMNQg3tE/DQ8ZhDPlfGPhSeCEmc0dynashVhJbGQgSGVn7J+TbN0+pnWYn4glAEdTSgwVdjYij5AT0wDUYUIM9VlnsGI07E74pkOU8Nk76YifGLMZEi718cH2uPA3iL62TCpEOtuSmw+06gg0j9Bvpg9Ve4EeiEhxZlPAWmtcZLahSBM6yjakuKaRq4MjuX4mnYtUOfBcqW+j4lSit35VkhTeVlXOvls2zvMqhWp067H4QfKmBy+Lou8L68co0LiHruX85Le94pD0+LIaCimFPG0sgRdpkhb/6FPuzVNE2O4IsCy7ulTx/WXYx0xm4NGww2l5kD+SkR45zTeSnAHjc9L2SIX1SfqCgukPCyuAixpOLFBlY/cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 9:38=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Thu, Oct 15, 2026 at 08:32:21PM -0700, Kanchana P. Sridhar wrote:
> >
> > If you are Ok with all this, we will need Herbert's Ok for this change
> > in patch 3:
> >
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index 192ea996e779..db8e4c82b900 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> > @@ -293,8 +293,12 @@ int crypto_acomp_compress(struct acomp_req *req)
> >                 return -EAGAIN;
> >
> >         if (likely(req->unit_size && acomp_request_issg(req))) {
> > -               if (!crypto_acomp_req_seg(tfm))
> > -                       return acomp_do_req_chain(req, true);
> > +               if (likely(!crypto_acomp_req_seg(tfm))) {
> > +                       int err =3D tfm->compress(req);
> > +
> > +                       req->dst->length =3D unlikely(err) ? err : req-=
>dlen;
> > +                       return err;
> > +               }
>
> What if you put this short-circuit into acomp_do_req_chain instead,
> does it still give you the same performance boost?

I made the suggested change as follows:

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 192ea996e779..6697cf5944a3 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -271,11 +271,19 @@ static void acomp_reqchain_done(void *data, int err)

 static int acomp_do_req_chain(struct acomp_req *req, bool comp)
 {
+ struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);
  int err;

  if (unlikely(req->unit_size && req->slen > req->unit_size))
  return -ENOSYS;

+ if (likely(acomp_request_issg(req) &&
+   !crypto_acomp_req_seg(tfm) && comp)) {
+ err =3D tfm->compress(req);
+ req->dst->length =3D unlikely(err) ? err : req->dlen;
+ return err;
+ }
+
  acomp_save_req(req, acomp_reqchain_done);

  err =3D acomp_do_one_req(req, comp);
@@ -293,7 +301,7 @@ int crypto_acomp_compress(struct acomp_req *req)
  return -EAGAIN;

  if (likely(req->unit_size && acomp_request_issg(req))) {
- if (!crypto_acomp_req_seg(tfm))
+ if (likely(!crypto_acomp_req_seg(tfm)))
  return acomp_do_req_chain(req, true);

  return tfm->compress(req);

The Average throughput of 10 iterations usemem is 19,058 KB/s. IOW, I
don't get the same performance boost as making the localized change in
crypto_acomp_compress(), likely because of added computes per compress
call (one function call, two conditionals).

I think the localized change in crypto_acomp_compress() looks a bit
cleaner as compared to the special-casing for "comp" in the generic
acomp_do_req_chain().

In any case, please let me know if the above data helps.

Thanks!

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

