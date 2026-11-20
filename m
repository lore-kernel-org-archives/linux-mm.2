Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC89606A6DD
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 19:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IfRqh/Fl
Received: by kanga.kvack.org (Postfix)
	id ED2366B05B4; Fri, 20 Nov 2026 14:24:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B0F6B05B5; Fri, 20 Nov 2026 14:24:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4AB46B05B6; Fri, 20 Nov 2026 14:24:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3F1C6B05B4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:24:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4484F1A01A2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:24:42 +0000 (UTC)
X-FDA: 85456474404.26.84AC5B4
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id 50575100005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:24:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="IfRqh/Fl";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795202680;
	b=FNi1PKCTFriGqbCszyItgUHQPLTFd6gvJ8lM9ycuXP/sn9vpPqixUHagt5FiPT2gCFDZzc
	DqG1GRInLywMesYIJUfC1uKXEqwbL7Dj6XeQcAu2JCnsRIROCV7R52IaZr0IuUw6TJMBef
	a7o4wqhczy5HBC1zkyqwPYktuqTpqpQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795202680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xcib+K/+9ejSnUqHeRUGsbo8GBDthvLScqBZBkgzZaU=;
	b=1uG0FUv+LHJNQsksKzfZyk08HMC+Z56Hkz0529/a+3J8Lk+gsygghKXIw0mT5g3pHMAYbA
	SvkastOa3TP6x5Tblr2HtxIUEL2txbShJeyeVezR/RA2mWDWEICe+EAW2ggVjWJCU5xGyk
	7YVEPQ7WATNneNIRuUCS/0NZ06X0cCE=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="IfRqh/Fl";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3ae2ab35d82so9883611fa.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:24:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795202679; cv=none;
        d=google.com; s=arc-20260327;
        b=Zghqe0L4lF+JIHBZXDGuY6tA/lAcEE9ZjG8QmlqhIjrTiGwEI/eDD8D6W/8ZZbiiri
         cIwyXl5rrL/aqm0GacvcP3vrnYb53hqDNosnECg/ftj+3oC9WzWSD+V9S22gucm+UH6t
         T5vrRNqSIFe4iTLUquZPk0kxpjJvVZuiG8ZoJsjFv5p0rSbLsBQr3+jzzywlZpbif2LF
         xeRcjWLlyBaK4pVAJqcm05s74LTCXytfZM2N59W3v4BMo+S14MMYvUe363jv6B+dkKhD
         U/oDsh5lT/QHZ7O+aQ9+Mg+t67tS9uUqB1JsKyBdaxsQUWpzd82OkW0SZrmZL0xIb32O
         7BBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xcib+K/+9ejSnUqHeRUGsbo8GBDthvLScqBZBkgzZaU=;
        fh=gf/1EBF+r+xJjQp1oVBwmxYiSxmr8JW+a60qZyYjFQw=;
        b=GaN5CYXCzMSDreRVa0h7fgWvKNarct8uG0P6Fkjt23xuxb+a77joExIWXqRNnEuD+X
         Vavw/dgKiLh+2H6o+VqaA9P4EpU+g7T4sxsM4v2jcI5aN9fEu2k3Ao14Hyh6+ywNs7x7
         8yZ4cG2wil5jjtAg1nrQpAwl9uQSnP/mrSiqPGEL845INLBC+FbFfqbwgki7ZdkUdncE
         5pHHLhKsMssi2WHQIsWA1H3X0+QreDLqlWZFnoS1J8lEgjIexI1aUaFBwtyrtLboo7yv
         YSZBgRnDLlzNIa8t9JhrxuhE8LOwUHfbIDrtSBlx1N4aXeM8A8JDbdWR7Ymbx7aPrgbR
         sTlw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795202679; x=1795807479; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xcib+K/+9ejSnUqHeRUGsbo8GBDthvLScqBZBkgzZaU=;
        b=IfRqh/FlQ2i+KaQ5HqP/FRix2+l3/QLTi26dQQTlnUZKzzTqqWfeCzr0XefI7DSiCY
         IymOeUiougsjYHLg49x7RJNcikc54VG3CygRn1FmnogeOCTfI3yjRsTX2bJVvvsS5OFd
         7E+Obmbr6K205soyJcUzSU4zR37rPTX8GIzSUIRq5hSQRLvuo7zBomuf4QSf40zbtIqB
         KEM/AU+hZD6ECHqcqbl417cuiHM0UXOn27nviF8L6xi/6ZWsI4kv+Cr6Et4EazhoMINp
         tXGfNdqN9ch8Udd2jsIQpezz5emeQzAk+/OwPVwnqKyYcl7GDwrqAiT+LgH9QlUQuMbO
         MmJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795202679; x=1795807479;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xcib+K/+9ejSnUqHeRUGsbo8GBDthvLScqBZBkgzZaU=;
        b=DoKFP0uPlyHwORzFepK6vmXMOZLI03GxnKFtzNADf9LqdhkGha+28bMP83YFiMN5PY
         tq+WjV4oXLZJPDvD0M2wloQ6IZF/kOjv8o2/7FSUQGvymUIOolGdjeGZbTiaIC83/iKx
         WtHLKtuYvSZrYVolGpuVoD6R9eUBTxe4qLZ3ZRcgOD+4/04dLhMJghK0AZpsWzebPbNb
         DYBpU8YRla3KDmmLrswc0fk3Oeszxbo9K3xXl6I5PbE61ebfWUbD1GpSX9VaEnbXX/55
         bgN71tm4SotZfo0IVdjxsmZuqb/1qNcieuGoUnx2Y3ZjLN/nRgaGF+9JDDAJ1EQWxGhV
         kt7A==
X-Forwarded-Encrypted: i=1; AL+hErEl2wDWseEX6w61CNaaNP8KqpTYbKbKeVXQrFsIpjIF/dX//GFL7ETXpmuO1oIilQKWyosPijyojQ==@kvack.org
X-Gm-Message-State: APuU4Z9iAGjGUz3fyQqMKZiv6FBk8wZNDlzFYS09gs2q6mrliy5ssdbg
	pQfK2pwPjGWbuSf86HzG9169R7d7x4LmlA3IkWY0neAymJLBqAQG0JL2VhDoh/Ee8aQtVw8tHKs
	4np0ebDcd+Hqu4be0cmgmrCbYDjX1zv8=
X-Gm-Gg: AZFdTZfdXnOjitFFu1q8FQtvEqLMl6qE4n+qXoj8N9nsuTnH6xsu/HxbuDx0yRe4GCR
	NGVIIbwxKVMKGyGXRL69hclT+COMhAD6cj8dWnRSYrHwZ2m6GIniITdnbro50iqyA2RxcNQ+G7Y
	s5sHOCos9PlwDqTboovgSn15wTL/TjcDe64833gxj+qD/5fxgoe9WBHzfbaRJOOWOYT2K80fUBu
	HTkKiXnHg6J7jXi+xNPqWhEzV/mY9OYn7Hse9UXerY+ui2jPkrIzpD0uUpFlr4E3UtHCPLsmil3
	BMippVGgN7ObZki7tZmZL0OfAiKkxvSBKGPJZqqyx0ZLtzQ6NmwLZJp7sTMRbqHaK474/Q35Euu
	9o+GUIE17RRvO2enmJaw16EMgkAlNor2Sr0fM
X-Received: by 2002:a05:6512:a819:20b0:5bf:d551:8c71 with SMTP id
 2adb3069b0e04-5c1bc7d15a5mr838569e87.18.1795202678517; Fri, 20 Nov 2026
 11:24:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-5-kanchanapsridhar2026@gmail.com> <sashiko-outbox-202710@kernel.org>
In-Reply-To: <sashiko-outbox-202710@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 11:24:26 -0800
X-Gm-Features: Aa3M54rU46Ty9WvfOdS1wdoE0OXKdFP_zbBLl2cCiKFxY9ohzryN1SoHktkXPJs
Message-ID: <CACpmpoffJbo-8ba9kxjRn0mrBwzH3u=Cc3Y0kj_rDAnGrjWnRw@mail.gmail.com>
Subject: Re: [PATCH v3 4/8] crypto: acomp - Add API to get a compression
 algorithm's batch-size.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 50575100005
X-Stat-Signature: a6baduq78nsgbdxh11ka575bbhgwxuct
X-HE-Tag: 1795202680-12010
X-HE-Meta: U2FsdGVkX199+RFHV4LLDm4du3y2DA9ZZWzxeX4s+ewD0KsfF1ckkctYN0I4Lu4eEOIisON2FSqBjcA2E7R/b1HVVqpy61M8RJjKMiJjQp0/iq8V2yrpaM56daQ30RaBR2tBfEeeNoQuxV33YSmi5V73H4EeR9Ontx6oW40a7rWz/mo0c92LqDvzKfJOvPycr2aEo9s+t2+y072rofIs3Y5TsfPPi2jRK6WfY0S0A56RHxrP1jQzLYdXe5T9BslhQHV3qctJT3vU8urc5o6JaPSngFv7Vt3UdRw+djAzooHTJGkOx+H46BdFjRmZnYd2oszmx7BzGkVvvKcvuhNZOzvCJGSMunFmTCax03lcEQw0X4r2bNtx0ZKwRSsuFNsUDPlClkTuqtDyohZpGO3IthiEZjJ9fqbUaXyttbgGTlkDOXBepdsvpMArdxrfKp+kO6TBXMHUJaLH36WYkxNmRjWWlOvJPf7pVa+xgnVKtEqILG08eAsL2BIjCOPjDqzsjJ1IraskvGwmSgPHDNq5Y1liFjbalOyRojGGe2PPOAvc7/dSn1nsp2rjV77rfAKKuBZq4WfEkW+uGMGLMdQKGMmiVN4pn/bQ7iOQtoLF24Exnnq43StpKnCOujj/ngWgbXIDZUFnFE2KFm+g3MqBKiMXJUnvmRrOBW8yNgfaIUuwce40IpGJ904yyJMOSEakJsdCpsftbjPqLWOCbcPBpAhSM67azaOySvC8cD0VUZ1X31is69xKjzaVtIfQFFP6g6Vhw4aJ6rDNh0wJajASOsFPn+oyqjmlfFTnPsLOlPl3GmC0/+garvtX5Z0KZnHWBUsOJK5+5yh6PFX+tA28WDV4VSiWpAQpnlpSXfBvyEQd4J5wzTFrIV9y8PJs9HcWspH7mm0zvjc3ZfP6i91mtuy/w62Pw2xfRxgCp2RJRDRvEAqk6V3DV638ytEJlog/LC8hmYYJNOmSmBDnErn
 cV4VbV7V
 2AGcJTU33nvsShedNqMVHu/DDjvRKPGEgn9iL3D3YT/ntGc5QwcjPmYVra1hylXEADgb0/+6ueOUxxZUKGUjE5R19dJJKca/PnjJBjSomosXMwQHEmoq/jIfUcTtrJY05mjCeTi3hFFck9dCCt2v5u2sN6ueJvm9DQhkMQ2vJcmic+A8+qlXkolGRov+cjr/cuL6Z32gg1NAsxTTlRR9JPS3uyyZQD+D8gFcl1vWkEHhjtzyluHv2rYsCpKqi1qByUY+yAxGd6puWveT+Bm4zAlXaJgiQIg0YSUU2tgul/Y3m61efwU0fmurMN1KAoZ6AV01qXtcMw0Q6EoIlfDRkEz39JcEjjcIS5KRmuI2p5DLVijYhSN5mbuY6CHCduei4BlcNr3OIEfLuJAXSv4LNGcmkKBBvQNmacFZKQ85sNDA2Hgprux+1mozbgbidCXlSXBEPNK4ATv/WaeV7lPUVHx1vANuHUzznabbvEvXsEHZIQQxC3lUSlMpqz9Si7fbMHoEIp/qIfM/WDqdFe74SKRmwy4aZqL8IOJdWBU2Ucc/63BucDcdVNY5414M32pN4Bn3dkUxz9yYBW7Gss33iDUxaow7mfkItmGzroKZyUiTDBhGQ77BzkSE+H7aGAUgkDGo7cK4iDQ7xkbBNmylFrVOp2xJxMM+MK3j1V20uhWPX9HCqPB2YOxjvUEcL5D4FC2EYoFziNPGvVYh7I8D6P03CMsI1Wz8Svo8U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 11:25=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] crypto: acomp: batch_size gated on acomp_is_async() instead
>   of REQ_SEG
> --
>
> commit 2fa95d403dcc5d6c7b702698b0e306a5d643d3b3
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> crypto: acomp - Add API to get a compression algorithm's batch-size.
>
> This commit adds a batch_size field to struct acomp_alg and introduces
> crypto_acomp_batch_size() to query the maximum batch size supported by an
> acomp transform.
>
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index ac4dc52668b89..df9e42f519c35 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> > @@ -327,6 +327,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
> >  }
> >  EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
> >
> > +unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
> > +{
> > +     if (acomp_is_async(tfm) &&
> > +         (crypto_comp_alg_common(tfm)->base.cra_type =3D=3D &crypto_ac=
omp_type)) {
> > +             struct acomp_alg *alg =3D crypto_acomp_alg(tfm);
> > +
> > +             if (alg && alg->batch_size > 1)
> > +                     return alg->batch_size;
> > +     }
> > +
> > +     return 1;
> > +}
> > +EXPORT_SYMBOL_GPL(crypto_acomp_batch_size);
>
> [Severity: Medium]
> Should crypto_acomp_batch_size() check crypto_acomp_req_seg(tfm) (or
> have crypto_register_acomp() enforce CRYPTO_ALG_REQ_SEG when batch_size
> > 1) instead of gating on acomp_is_async(tfm)?

As described in response to Sashiko's v2 comments, this is kept simple
for now and for the only known use-case which is acomp_is_async(tfm).


>
> crypto_acomp_compress() dispatches segmented requests based on
> crypto_acomp_req_seg(tfm):
>
> crypto/acompress.c:crypto_acomp_compress() {
>     ...
>         if (req->unit_size && acomp_request_issg(req)) {
>                 if (!crypto_acomp_req_seg(tfm))
>                         return acomp_do_req_chain(req, true);
>
>                 return tfm->compress(req);
>         }
>     ...
> }
>
> If an asynchronous acomp_alg sets batch_size > 1 without setting
> CRYPTO_ALG_REQ_SEG in cra_flags, crypto_acomp_batch_size() returns
> alg->batch_size, but crypto_acomp_compress() routes batched requests
> (req->slen > req->unit_size) to acomp_do_req_chain(), which fails with
> -ENOSYS.  Conversely, requiring acomp_is_async(tfm) forces
> crypto_acomp_batch_size() to return 1 for synchronous acomp_alg
> transforms even when they set batch_size > 1 and CRYPTO_ALG_REQ_SEG.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.79=
09-1-kanchanapsridhar2026@gmail.com?part=3D4

