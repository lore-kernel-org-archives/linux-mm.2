Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B60B9606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 19:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vEUAo/hT
Received: by kanga.kvack.org (Postfix)
	id B60AA6B0AA2; Wed, 25 Nov 2026 14:08:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37136B0AA3; Wed, 25 Nov 2026 14:08:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26C16B0AA4; Wed, 25 Nov 2026 14:08:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BD556B0AA2
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:08:37 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1D1A81041
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:08:36 +0000 (UTC)
X-FDA: 85474577832.22.B71F2E8
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id B55CC1C0008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:08:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="vEUAo/hT";
	spf=pass (imf21.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795633714;
	b=R5wVGioIRaCwDxFpMOt2q11fV0jZeEU4qR/ooCnL2xt+MKkUh6DUgktwCQcyzKhaX041P4
	E3ikIEayBszMRCFSNE0vKM41kf5/5XEvBxQz7Wd4ul7uYTJRyXhKO5cZzJyGX33DJ4FR3d
	myMyiIdGpASPNATqyvmL6xe4V604i3c=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795633714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5Ib3pZkCzaItYZ7rw16OjgJtmjHoVVIe/AJzjYQtM8=;
	b=zL1g8v1Tv/0xKOfJ6rQLGJX/sabFWoZ+V9A5AKykn4ZFfXgqpqo84v4GGTzNwpSo1DTK3+
	Bp1k/4eDtnuGIlH2c23hMLBXJB7ddQ3rEOaoKF4xJWQZRwwUc9slgmrS4Yh+zeuShHLdCe
	GG85NKdNCgexbPIs9j5I48IvkHPBPhk=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="vEUAo/hT";
	spf=pass (imf21.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5c10dc41270so6565520e87.2
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:08:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795633713; cv=none;
        d=google.com; s=arc-20260327;
        b=NDrT2SXP/L+V7BBXk6dTF+/UydioxQ3vKvfHupwJ55xhvCjmQHDMxoiXUbyGp8707Y
         CyyIUpBQJwP34jJ6EO1Yx20UePRaHTDacSq8V7TIdFBVL8PWixZU/Qsj4lyE/d9k/go+
         eETTFgdBIk8QILosICzCFg3ekmE2p5enz9IPHancKKj4nbRQUXwtemM5+U5rsnMrZAcT
         myf83rXmM2S7P7pJJCd3xVImnezy7RwQHsX0DpBw6rlS3tiM6RCMD+mQyr1Wn97PLClk
         PT8HUSmgQFK7FB60kjTGoud0ivtbHf0A/LK0FH/sAd3QPEHTGRqBImN5fKtQEQ+F6Qx0
         rQPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b5Ib3pZkCzaItYZ7rw16OjgJtmjHoVVIe/AJzjYQtM8=;
        fh=mbSa7//kdjyJqXKn/P/yiXF5LQfiz7qQZlr4R7b/KrM=;
        b=Cy3GLjTbg5np8JJrrdNN/MwDt2Dd6M1DocqBaVsImk3gbjFOvH8bHEE5BGXkLNsYqt
         vyU9yy/mYasX8620NswmyuOr15H9HiIIXyNzvIaLoIp3MIa0qTRqwI9BV8bre+ojdQSb
         3S/OcyKdLhpPQTGEwZMlzp1c+EzIKOF4GYXtV9taSPCBjMYIdqjRNrgqxhdPuzjsG/ey
         hffVywub9KBTnnAbvFqxIEFC/ZjNgEJBAAe/qJuTX6jXJw6Mt7NBJTyeqPUowe6PL68o
         XRkHUzazoYM69cks0nNti5A3nl0PiIfLO4taZbZkIG+3wN3HmdqtxYR8QTudixymkyHE
         HWAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795633713; x=1796238513; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=b5Ib3pZkCzaItYZ7rw16OjgJtmjHoVVIe/AJzjYQtM8=;
        b=vEUAo/hTG9gMRBOLNGJFm1YOd78ERVubE4LeZ+bTDyaXpOS+OQ0hVG29dAQA7Ebw/K
         74USWoqaTse/UVg+llh0djQA52V8Yd5m8ntVXSe6fRjoTI3uY6NfpAlJd0RU4DczifSY
         sh0vCUOkDnL3yCyjkQ86s0lKc7S3Jg1k8Ect0HlFAU2GYIfGXy7X0t0kyGYHPKqt0RJX
         8Uqm5FMxY5ucGwtrDOfk4Y74Gy/YFgtcCyCUXwRTyhWVtlVZDvzPrmyKJD+Rmtdze7kq
         rlrYmqssWx48qcbdAtY3VjYCIpNIhNYpjsdDJxjZWZuA2v96yd2W2CZyq3kWvZg8rpvW
         6kOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795633713; x=1796238513;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b5Ib3pZkCzaItYZ7rw16OjgJtmjHoVVIe/AJzjYQtM8=;
        b=wUnlEHT2oZJuz8mOJGey4kc2LYXWOLAZAWhiIgBX2IE1gE1N7I+9Cdb0syTQo6Pt/R
         mVJv2jAW6r/hArANQmXLi0kHpblR0rLwK8Bg1u0E0XE/YSOx7MLDN+WnD8IMvqL3wgov
         Bo5KKZ5mnfmNA5W6YBnqDAmkRBKo0PZdXnKs/j9ai6ppVEY5Y+S+fdD/sCt5XZvD+OXE
         Ii20r7YyPrLeIKgx/lLg7Q+Xd5Bbx46xT+PiXmHtJOSD+6nc0Nv2yeNilaNq1TlFLiej
         YeZUBs8vYuTFBqBLHl2YJ9P7ZcIQdGDeChmq8IpUF86m8xy0FRyysBdFIcXdEx063isI
         6gZQ==
X-Forwarded-Encrypted: i=1; AL+hErGThVEAyWGnOEhf5NSADmXtuedGUm76AyH5U0Cp9awkUBcokoTeUhOa/K4/YWD3SqXpNY8iQqPYBA==@kvack.org
X-Gm-Message-State: APuU4Z8o4fr/R0U/VTKMjKfebCDS5DiDIe0xLzDd9HBJP5yzUPT6h+dv
	fwWi0iLckyVMaStYT/2YlWjUdcZSf0qecM5RtakwJpruCeLkebMzYpe+OYmUD6tKDZ75Ho8EvPg
	ced6l6KHvzb76HNrDCnkCEc65fUNabg8=
X-Gm-Gg: AZFdTZcan5wI7Ez8d2f+vHOV5wIIX/XlIWhz7KwQxx1Ccbo6MUQ8azWRriDL/bDo2Vv
	CIsggEPzZed43AY5pUtq6RFtrtLrJXX8uvHkIwdNjFQkWySWloeJlFODBEEc0H6lXMuInv+t7Ah
	uATAS6t2Ycu+V6XrSgD9r6sHHp5xUKfqC/ktmD3UCP525Wj3HVxG5srcbilLd3ee+dXUT7B4Wwy
	2p8gjcCc7E7+W8xv8lIIimrz/eNZ0IQ/Fqbk5KWw4IXWMXknvWON26xL0oBMXCPKt/wz6PK+gc4
	Uvtyr/XQdgXHpv0iSky16CgE1/1fUT1xHA686wYkmwQtfR6vRkaHikpb5gjWBeeY7Y82QmT7wKJ
	ImnsCKNBvSA/WdpTXjmVLpN6EBZP+iWXCqeDo
X-Received: by 2002:a05:6512:2255:b0:5c1:4f2b:a2ba with SMTP id
 2adb3069b0e04-5c1bc7da45bmr6431675e87.34.1795633712661; Wed, 25 Nov 2026
 11:08:32 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-4-kanchanapsridhar2026@gmail.com> <sashiko-outbox-202709@kernel.org>
 <CACpmpodxjJ3ZQt4xOsWfWQNjgMtPzKx0oGMy+mJTU1wxVWdMUw@mail.gmail.com>
 <awQCFZSSng2LLGnX@gondor.apana.org.au> <CACpmpocCqenTNv62dGoeSLP2zs-AXJYhXM-tj2cytm4zQTj1cA@mail.gmail.com>
 <awafBxDtUoIQW9iR@gondor.apana.org.au>
In-Reply-To: <awafBxDtUoIQW9iR@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Wed, 25 Nov 2026 11:08:20 -0800
X-Gm-Features: Aa3M54rDO2n4sQnCYgEeJJ0BwJAh3cqFRPzK3u4L4boBFDbFL3ETCr5fTYtU7WA
Message-ID: <CACpmpocWW7pWGYiF==DupmZDB0-jETu32C3-9NYY8nssKcDm-g@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] crypto: acomp - Add trivial segmentation wrapper.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B55CC1C0008
X-Rspam-User:
X-Stat-Signature: fw73d4p8q1ez78s4oqp8zrxhyz1uxuxt
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795633714-514985
X-HE-Meta: U2FsdGVkX18SQnp+vGytXSVFy7n65ZmkvrtBoagZ6VQKVqBCdkoINz8J5cnsQKszWvUEw4gS4qr1M4Pet2ljmZc4ZJLZCiS/7ezHWZC1OGyDo8IdDALocSAdJlSv+Anzl1nVUgB1/1EQi0d8ILGYNMFAYEUKN8zh6RoLyFyDrmZbDcrJyoOlGHVsOrkNW9elop/JlWvC4naeCF0hcZwS0APELImYyTQw3oIM2qZeiqNi+wy0fG+IMIlb+M2ZN+ELK81jyG9ZMKfu9eqvfA3JMAqSwaX6RgQYU0WVvf4xTEQFJgscPxvc7LCp1/HLZ1iDF3HZ0fXm4QDNpvbfadQ+c+vJgJE0zy09La1TbFFnr/PzszYd1mmTOqZWMQAsVDgi8lcZIOcXa6nxrcOqtMDu/Fm7C5C3sHKySjl4aMJkH9kAgaALKWNpfOAz4MX++fesTEk4DS0NTz4ZWLJTMDJnfokb1L4xo0pCaviSGbRNCwIRVGJutBUtkVL10gCD0mxct/5GYJc9mR2H9c6jPpyzj1z145CBm8sjEhNyzsM4iiA8lCJnwtLq03dXjsL3ep7CtFfSw2LSkefl0l5t1ou7MrWLWxPfTAQmsP7pCxadiPCuzlATBaSJVNvCKdlH5g3FXkEHZy1TgiHD7zLNCzyGNfEySw2PHeN+d/RJngAsGbik22a0WujxFPquWhoGwg0kcQA+AKdgLpESq1yH1Qcpyt5vImFP84/zdcgwnyM2DCtdk51OSR4V65AGFKj2GO/p2m7GoikqI1q3bLBY0fJqrVacedmrDAFBrTp1crr5K+15AILnGeO7CqCii+4ZvmFqhcJyReIA+sHjtNBHjyQTf2rCeymUoO8XAuylUuSLwuMku8CVThp0iZgxvXkQwukC1fH6hsgLuwPY9aaiO8ufIj3a6GaOW3iXDQ++nQG42VCFr+eRJq5B+ym08V0lFB85ipI2+yAdiYfXJOtbi27
 brQHVrAD
 dGac3sQEfcaOgXVpheMA8n1HbYZWX/VNfxWxH37SynDEpcQ5QSDQw/n/JUkGynh3UR9pz1VuuvKDUhPOuWxATMQvieW5HBOHWClhAfOr8nSG3nX3eWCRH5rd2VGxkTe0f+8+hYN7fmoXJjRVJcDvsqsgDFjLa3OOxccABENvkb0VZyxy7gW2Du9FU1s6D98u8mZUB7musmTpsqz/ZffJhgVmbQ0nomaqdm2cm01ONXWKFT0+vfhZH5gbNBe8uTjHqRieJpOTw4RI1M6Nbl83XH73hJEtA/fiAa7jhe1NBNbt4ARuacdJIzOJQAbdhrwbWQaNTEl7XKvd0btOAjQx+pxgTQTEGtkYjQq8P/FSo3re/P4DL5nETclnAH5ckMCQQSQFSEyNGF65gV7bkRF4g/iCJDDiCSMmpnpbd56QHKBh8zhnIgedJJ9u+rdtHyx5GYocH5MmUPBHuY7yNeAZu+nti63i1UwBSyngcQHikxQHKjRH0+gYJyWrI952FGKUP18vTXRxHdfr0MMFrVT1EWCbT9oqcLLDbgQYziOGE3/FXCPeiB6JDaCrK5R4n3n2ohIGGqA6t2blbJrcjFXD0ISmMq2SlcO+XmPExUf4RmXS14+ECoylffOqQHe8q8RB7IsQ5gX4xelFQ4BI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 12:41=E2=80=AFAM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:
>
> On Mon, Nov 23, 2026 at 01:56:19PM -0800, Kanchana P. Sridhar wrote:
> >
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index df9e42f519c3..f0ff821b3560 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> > @@ -247,7 +247,7 @@ static int acomp_reqchain_finish(struct acomp_req
> > *req, int err)
> >         acomp_reqchain_virt(req);
> >         acomp_restore_req(req);
> >
> > -       if (req->unit_size)
> > +       if (req->unit_size && !acomp_request_dst_isvirt(req))
> >                 req->dst->length =3D unlikely(err) ? err : req->dlen;
>
> I think this should return -EINVAL in the sense that using a
> virtual address with unit_size cannot be supported as it makes
> no sense at the API level.

Sounds good. Does this look Ok to you?

diff --git a/crypto/acompress.c b/crypto/acompress.c
index df9e42f519c3..88f912103e8f 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -274,7 +274,12 @@ static int acomp_do_req_chain(struct acomp_req
*req, bool comp)
 {
        int err;

-       if (unlikely(req->unit_size && req->slen > req->unit_size))
+       if (unlikely(req->unit_size && acomp_request_dst_isvirt(req)))
+               return -EINVAL;
+
+       if (unlikely(req->unit_size &&
+                       ((comp && req->slen > req->unit_size) ||
+                        (!comp && req->dlen > req->unit_size))))
                return -ENOSYS;

        acomp_save_req(req, acomp_reqchain_done);

Thanks,
Kanchana

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

