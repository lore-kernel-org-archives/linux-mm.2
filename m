Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CF9A606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 21:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XhfnJX+o
Received: by kanga.kvack.org (Postfix)
	id 6A8AA6B05B0; Mon, 23 Nov 2026 16:56:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6593A6B05B1; Mon, 23 Nov 2026 16:56:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 549796B05B2; Mon, 23 Nov 2026 16:56:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D6866B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:56:37 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A18951409F0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:56:36 +0000 (UTC)
X-FDA: 85467743592.17.B5245A8
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id AB3AA20004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:56:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XhfnJX+o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795470994;
	b=wgbVtFxrzmELdN+UnE0FF27C8Phn1RrV1vXDLZaRZt/PgHcZqIQnlR50+2WOMeFGjOcmEt
	QIHZr6I7FihWZxMIAL+CzNVwcRFG8X6rB4tXS7bIo5RKMpTvR8CqkhM9K5HCLT4sF9TeL+
	M9YX7hKZ4RZooJZaI6CrPJ7yj6Hzuko=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795470994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IsBnDjv6eKAj53VbUsxqB2MSO2RsWLKcSPlS6sf3OGg=;
	b=N4iIBNfhneqZSbsehIsstakt62wsAvdPPTWchh7wE2c1/1nOkjZGv6lcrAoWURthW82YUp
	sEDWuQq8Ic2fWbNY8RIZ9x+3dBbx/482IyKRbqQknhtPbO7NpxEooPSOVbJ9FiJSQPE6uh
	tw3+e4YAh/fT9xBRT2YAxQ55pstq8qQ=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XhfnJX+o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5bccecba199so3646791e87.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:56:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795470993; cv=none;
        d=google.com; s=arc-20260327;
        b=oZljFt62GqHTeAPHTo39nz4WDhxosl2JDgJt8oFJ3VJAk5Z1xiSEYmX1cQwIMmh91a
         JFWOH5SnYXvyvVJqRixQhMfPWz8dhFSoAuVXKONtYb2ZpM79JCrPmuooKcsHruf7I8go
         d0fwHO2os3gy8uvcJ5HURCslbbeKZOcmQKIxt7XHKbKlBn9TTKYoCK8MLcRVVXODSium
         izwXGYkmC2D2LXSMJ5bfHxAmjmbJ0qJ2fyaJOqpA2eCVSmoQD4Q3xFVldVyPIRs8zK7C
         lxv98zt7bEtHQe4NtL0yvMSjHUmDcN1zn+qqFDD7OAVcMrcJjiSLp5PdI6dU/YeTxyDo
         eRvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IsBnDjv6eKAj53VbUsxqB2MSO2RsWLKcSPlS6sf3OGg=;
        fh=BMY//ChXOz/uPQkeqQHWScNNIoZ53lz2mt2WTgPcVqw=;
        b=Z1sC9vl0Z2tE4L3qkOz4ZTCvPOXHhdHLHbfGHLOY3tHOVMslAc4R6RQLlLSHum3LZm
         3Zp5xdlrR+PuH9mfTLkHV9QcpWUmedppzT0BP7DpTHuL2i9e9bxNaznI6n12KMR8+QNs
         y8LzgRtxLQkUCfXR7LMo/eLpVc8eK3DKnOutvcgZYnkt7HcOqILbQzaooMYjQ01yKYfZ
         nihATK1mw0JQWNIq63GY7Kj6yDLiGfDJQj6aCzHX/WKsBoyLKT5T8cQiXiINENnYqyUr
         GOti97Piuo6YU0owjpr/e+mAp8UaJOICzF/GifezVY6NV3daomF9fZYBCzKlh92bVevI
         Q26g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795470993; x=1796075793; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IsBnDjv6eKAj53VbUsxqB2MSO2RsWLKcSPlS6sf3OGg=;
        b=XhfnJX+oOZxGE96mwUvMJOmiZPUtY384WbAK5ofDICqD2dx5BikgylMc8hHeKPl42R
         qRzcpDU4B1XTYEuVyECwqZUvCikuonkV12rQnOYOBOU8vRuWiK92/WaDtwxP40ap/Bae
         yOAwX2EwfPhWD02ujL83mF59TNjPKouGJOXE+RAlxqGKxccsIIn9i3NuDecuIYKJTkEH
         CHpWTyZD5fRmuLaQ5Qrf5q1JNsdl8mouUNzmXLgN1HA5+TtAxPc/9yUTYZuzLDXNS8B/
         IfYg9lPJUgrgZJM8ZK+9CMfXtVMIhkmbAhvrXqlguMVIdEOcqGryaUupDXvbJBZeRDCW
         ZWjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795470993; x=1796075793;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IsBnDjv6eKAj53VbUsxqB2MSO2RsWLKcSPlS6sf3OGg=;
        b=ssisF8B59QDThPAbbGe1maVRyr8NXZWWzOikj5zISrqgI4f8uIG5UfqRHt/KbPEC8e
         eKZhFImL5x96L0SH9St9IzQs1zulnIAejlJ+DEgIj3f/myZ0EhYcGaQSRAfdKDJsd/Ey
         3vFalXpZVUSYlmnvaX3OqF3A/uzvAGgUpDtsRAAd9u0QgDdWdfquUI5PTtmLd/e19saC
         XjSZUVndXbmndVM/CD4cNAyr4Wee1fdQc96fcZpfaREbPE8B2UgbocwAOSGXXezY9bdX
         MJwixQC7XYXhM4xiafo5lalWTDSceEy7UPtIS0J6rCquySiHOkIPyd8UX/WUqwFcmS5s
         v5PA==
X-Forwarded-Encrypted: i=1; AL+hErEuq8FdAEOgJovL8hRy0MGxwlmq7+g6qJKBrzSxggRNqe+AnbRAlV3BCEQvhvHkVz3JTv5Z7IW8gg==@kvack.org
X-Gm-Message-State: APuU4Z+fK2lMRu4glWfCv3hIYpj5KbHaKXm8IHGzorhW51mEyZC2eTrf
	bTNteGNZQejqS72FZiQxO/X12xKLSUwm3BauYn5zT/ZSlPwr3Px4z+I86H4qLP453MngUWV7KDG
	gH32FcD+Fz8Gqvt7nW0CDsCPAi9IbBaQ=
X-Gm-Gg: AZFdTZdJqzeDLM3l0EaENgswkLxA8yZfQlLZWs5OZnmvJmnUhHzXSEVdJtvgaKhN9G4
	9kEJw2PicUNZVfIT1INAgXLAbVpUQq7keWzJdPxl8GDBxskf66JrBItwrn4qPGH5zo0+w1aOvRy
	Rz9cWx/Dy/rIYgOagF4TdMe+s0yH9gRojJsnLmlGnMuxKo3BguZrIT+YgKx06MaeUZw0i5jwGYQ
	UMHIfHHMA/oZB65zYu2ovky2ueyQ6VF7kznFWARdvSFbYz+QKj0jtMCW4HjIUGlgHStaf5Djb8t
	pdRZbc3vE6hSHaCY45TGHrOK0pqeAmmAz3xafE9zN/YXMYB/2t77mrTt4AQpl4FHZAOrffpgwBt
	indSOdmwieJVeRcczzABF96HNtlSEWuYMtzjf
X-Received: by 2002:a05:6512:1288:b0:5c3:182f:babb with SMTP id
 2adb3069b0e04-5c3182fbbc3mr874548e87.4.1795470992660; Mon, 23 Nov 2026
 13:56:32 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-4-kanchanapsridhar2026@gmail.com> <sashiko-outbox-202709@kernel.org>
 <CACpmpodxjJ3ZQt4xOsWfWQNjgMtPzKx0oGMy+mJTU1wxVWdMUw@mail.gmail.com> <awQCFZSSng2LLGnX@gondor.apana.org.au>
In-Reply-To: <awQCFZSSng2LLGnX@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Mon, 23 Nov 2026 13:56:19 -0800
X-Gm-Features: Aa3M54p_TqduI_blaS975gQ75G_K0GBpeL9JMLLoILwNrNsOHcRCidEuPO6_fQk
Message-ID: <CACpmpocCqenTNv62dGoeSLP2zs-AXJYhXM-tj2cytm4zQTj1cA@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] crypto: acomp - Add trivial segmentation wrapper.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AB3AA20004
X-Stat-Signature: wau4h4x11d4k4dssr9nmh33qfo161uf9
X-Rspam-User:
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795470994-990273
X-HE-Meta: U2FsdGVkX1+JoRbWToJ08NVsCjvvvM/Y6SgVTlAXAF5zKHf78/3FJOdfYhgOrun+vN6IgVUYbA3Lct+MDlKrDiWT2t5BPZiHJs0pEekDt24yCwjZPmJfcgJTstbRKaAGEYbWFCKZJ5s54PqHga7eD0uyidAoWmNAi1Tg70NAc9xs3FL0wnqNCzzHMgd8m2i6baWwzPHCuPhgftTENJpgNC86vcVkzbq3HKMel/udlhO09ynyTunH2XTyU9bNW15EF2rJBT6wY6lHoCa/ovmWzAcUCHg2pKIFKPr7bPE0IBIdk9YRQdY+Sfqqd/tZcRCtIF24pB3luLUNkoL5DmGcuIL08nGV1zqrzTQ1iNxOPCBKX+0mqQQqW7T6rHWMNLE1Ge6rz9LP8XZ3kF/bxvYScYpXmPnrteGEAQgvJ54JgkDWelSMPQLqnjeSkq//ZUGzHa5vJ+sDq8vedX1kZrkhRCgQ7d+wqo+6W5obY/ltDYHpcURP7hf1WYUZYcW7XjhcVBC4PEKUF9VdvGwP22UsnPUU4vi7H7TO/zAdQs40DUAQmRf77srpUagSzloBY7B43cFO4QEhyx20LBRdqKtPQqUcBk3LrjdVNoNRl7uIKHtKGZmNbLz6jpvea1oi+pcKupJ92dyHtRlOZVJNh1AvFo+pzmQitat3YcjsYJQ23uNjS/U5Tjlnputzx0+zKVIw2/kZ8fq7OV98z37Hytu/sNGW6eemv7NuZso5WYgTVHwt05Ajzn3qDnQZZbTmoK6I8CQifQNkrn9aN/yVOvn/5ko4rDx8DX3O5w6pvn8oQuUCwO7F40cGCpOG0/PAOuTSyLHaLNtV4kYZdtme4lShLaj01zf5uqpDmmoq1W5LklQJJcloA+DHBSpxp/iW09V25wkZKvduyu7tJDSab8EKhbhdHuLm0IvXYA3E4+O0NqjqFNKWoECo/XNJ1OdYklRcF3Hmiz6TsOEVxdiHbwN
 CP+wP0tK
 p7CkVOgCRLHApLg1GkuCFqzr+ZPDibpW324/y1yncM4Kjxhq8voXZvZdoV5RBw/J2a2wH8ltgFgsv10m+1GCYIf622lWaiqKlbbsfi+WyFKJ90Bz7NJgry4WV1evah4hBtfYL+mb8cthwbk7YEcO8iCWPbvV9o2f0m+rkVP5p2DRGjT3B9+2W4mtIQDDoJz6cGRYuyNEUun8i/xqR4IgSeh4w2Gm/RPEdTFwcnVB2rMfynwGsYnURsH4gj5mCtPb8wSpUojr58c17xyY/leayAE93XO3zTI0oEmH2Pn80JVy+sb0ni7JOX15+jeYjGtBha5JPCHKDgcalHC4mzQlxC6QXcLnKFjfzjE9mF1OYJU1YUVpwHvIObtUYabIOEfFxdRVvHLWiyHd4FsIg2VnkJnLP4dAcfvt8wEefX8YqjsdZ04zSI3ICh2iyKViKVZJD23LkRyWqguAn/DLJrpjsqkbpKe25/bH71rSibSyzGHPhRBTUBWc88rX91LwQNZ59t8kr3mZd06mp0SdBGlCDYnDxl70EqAkWX6BzonvolNl/X/B8ka2rQENYOS1to/J58JTUmkd9xe45ku+3iLnJLa+qAU3P4z9Ey8NbXshVv4JqS+4onb2ib18fH4vWxRb6rVq454lUb8GXW0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 1:06=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Fri, Nov 20, 2026 at 11:24:19AM -0800, Kanchana P. Sridhar wrote:
> >
> > > [Severity: Medium]
> > > Can acomp_reqchain_finish() corrupt the destination buffer when a req=
uest
> > > with a non-zero req->unit_size uses virtual addresses?
> > >
> > > In struct acomp_req, dst and dvirt share an anonymous union.  When
> > > acomp_do_req_chain() handles a virtual-address request
> > > (CRYPTO_ACOMP_REQ_DST_VIRT), acomp_reqchain_virt() restores the raw u=
8 *
> > > buffer pointer into req->dvirt before acomp_restore_req() restores
> > > req->unit_size.  Writing to req->dst->length then treats req->dvirt a=
s a
> > > struct scatterlist * and overwrites 4 bytes inside the caller's outpu=
t
> > > buffer.
> > >
> > > In addition, acomp_do_req_chain() is called for decompression (comp =
=3D=3D false),
> > > so a decompression request with req->unit_size set will also hit the
> > > compression-only req->slen > req->unit_size check and write to
> > > req->dst->length.
> >
> > Herbert, is it Ok if this can be addressed as a follow-on to this patch=
-series?
>
> I think this case needs to be outlawed since our API doesn't support
> virtual addresses being used for dst.
>
> IOW the code needs to abort on entry if unit_size is set and virtual
> addresses are used.

Hi Herbert,

Do you think the following will suffice, because from what I can tell,
it should, but I could be missing something:

diff --git a/crypto/acompress.c b/crypto/acompress.c
index df9e42f519c3..f0ff821b3560 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -247,7 +247,7 @@ static int acomp_reqchain_finish(struct acomp_req
*req, int err)
        acomp_reqchain_virt(req);
        acomp_restore_req(req);

-       if (req->unit_size)
+       if (req->unit_size && !acomp_request_dst_isvirt(req))
                req->dst->length =3D unlikely(err) ? err : req->dlen;

        return err;

Also, I think we need the following check in acomp_do_req_chain(), can
you please review:

diff --git a/crypto/acompress.c b/crypto/acompress.c
index df9e42f519c3..e04cd3124fdf 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -274,7 +274,9 @@ static int acomp_do_req_chain(struct acomp_req
*req, bool comp)
 {
        int err;

-       if (unlikely(req->unit_size && req->slen > req->unit_size))
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

