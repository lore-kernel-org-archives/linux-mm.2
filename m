Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1761CA0EE6
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 04:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67E9B6B00A2; Thu, 21 Aug 2025 00:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62F156B00A3; Thu, 21 Aug 2025 00:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51DC36B00A4; Thu, 21 Aug 2025 00:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E1726B00A2
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 00:29:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C00DF11701A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 04:29:18 +0000 (UTC)
X-FDA: 83799485196.02.C5064F8
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id DC960140009
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 04:29:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kVUbISOi;
	spf=pass (imf23.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.46 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755750556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8A9C6Y9ZJgiMsi/J5YHom1KPP5jSn1ZRQFc25n88ZJs=;
	b=h3NEv4ehWQppW6tSuT5XCpesuEighqSzu+eAFoER6JqFO42+DpR5o9LUsHIsfeKBqR5ouE
	SaM2+0jyhxCsn2jmAKpd6+8SFDorCna7Cal0cKCva2OZZdTB9DWE3YN+3NUH2Z1A96NGAn
	AzZ39HxkAaLqQoJEgbzGYJ6iClK3Y4A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kVUbISOi;
	spf=pass (imf23.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.46 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755750556; a=rsa-sha256;
	cv=none;
	b=APQqhuUYb6/yyPaHEg27VbcjQCyxo//nRtjHVoqvFWyHIBgQJPkgDuXqSouAqSiMJavzS3
	AkydLQjYzwHnLazzXYO+u7kyG3SvNqtF19Xo80jK9XkygnTpYROGUayHIb/SYGlkcRU1TT
	9qdy95Lq6L+co01ly/KU21Sga04ofV4=
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-61beb53bc95so262338eaf.0
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755750556; x=1756355356; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8A9C6Y9ZJgiMsi/J5YHom1KPP5jSn1ZRQFc25n88ZJs=;
        b=kVUbISOitXj6i2nZCatwcwIDbRAA5/EwnrgUZMiKDrJaBc74gIpsmqSGhONuiVOrB5
         k1PKoFxNbtGUWKS4NAcKkwK80cy7KBBW2SPIiaAlbCBab/Z8XV0qMexyPTuMMvJd9vei
         xtkBOzV32amxgwpvxcar2JfH1wopVyhorueiMkHVPkJEf9Z4NlYdc58uyo2F+cd9NURW
         bm/mzTqT3Zsowyq71FA2EJOMVoaGHQ1XXGRxvgevkKO3E7UfTH3K7FvxJECOtUzIffhD
         k4jU1Z9pFc4wAfLl9ezFyR8EolU5BanBT/WUzzmm94Xm2dpM/zBRta9GlJBGfIBYAcEq
         pURg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755750556; x=1756355356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8A9C6Y9ZJgiMsi/J5YHom1KPP5jSn1ZRQFc25n88ZJs=;
        b=pX8sUOsOTkQvbyrDJD8J4pnnc2xVW9KGY91xPwDHr5zXmhmkcpI0+PF1EukWlnWFWY
         TTipxnD9hq5ht8N1LHAxCFS7O5VdakLpjDuZXmSYRZMuvaZUr4NVKxqBaxs/fraZc6FH
         QNaogh30KRtVHm0f62agGO5WQsFcO4DNsoWG+LZ8LUdCY7qybSLS3ENf1BgYYCjs1WBO
         hew701A65ps5Mt4VbZJx05NLVA9wUNYSJg2tt897TzoX4muYXy9YqanUmANHl5ZMPQsF
         oApfXaWTLuXCqzFtQgpbBFm6rLhN/4G9kKbuSD3yz6SRFSzUcSY5cE9ix5HK87VTReL4
         gRiw==
X-Forwarded-Encrypted: i=1; AJvYcCW0rf4v0r8Q7rvJYsNbscBjmp/HAiiWa2+2R4aNRsGvaVoIhs5ELsCpNP4M5f2cTPoKewRQpDIJXw==@kvack.org
X-Gm-Message-State: AOJu0YyRINWD3BWdlqWODf6K/8sewV1OLnj4BDrQyyPuoJPCIpCK/zDX
	TTbcUbxfCM3KObPeXevtCoIZLZsygYiOS+2uc2ha+4RzRMnIztNJYAW3Aus239wHAn5a6Xu0CuP
	OIoRFBTKVVVZnVjrlRwua6JleD5fFWXA=
X-Gm-Gg: ASbGncuUt+0T8hRGPCXHUPWYpIq1ULSez1+bkM3JSR6zqHIRlvtAFz5csMge2nk23Aw
	ajLYqB4uT/rnD92CK07542P3P+rhPUjkFGP9nki1Ux8ofC8xyATd6qUKecxu4pc46FjbKaOr7JH
	opFLbyXvIQLVb/0hN8qRS3arGrgQuhkRsztgUZ/W2wNDvn/4Leau0+YcdpZxG+LI28KAXwYfFDN
	nIcUyJHQEWlYfs=
X-Google-Smtp-Source: AGHT+IFDjBecc8GcRKMiu+HH3tdyg2aCQxSoKPoBmiKjiHISG5ASpJZTZMSnkG+iLjHlpiuFK45BniXIU9XuY1I+13I=
X-Received: by 2002:a05:6820:620:b0:61c:648:5f96 with SMTP id
 006d021491bc7-61dab2967d9mr478856eaf.0.1755750555517; Wed, 20 Aug 2025
 21:29:15 -0700 (PDT)
MIME-Version: 1.0
References: <CABFDxMGmVgswVoZFgBz=7xqA59M7fMt0jw2QHqWjm-W9tZktWg@mail.gmail.com>
 <20250821025423.90825-1-sj@kernel.org>
In-Reply-To: <20250821025423.90825-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Thu, 21 Aug 2025 13:29:04 +0900
X-Gm-Features: Ac12FXxwmBhLAYwhb250Nr3Mb1TYmrDdE6eHzv4fHnin_s3-I2GxsKQVwH7Y8BI
Message-ID: <CABFDxME5ZEAn+6=0GRWybTi-xBzbhhz7U38pMni3SdKjA+Aj-A@mail.gmail.com>
Subject: Re: [PATCH v2] mm/damon/core: set quota->charged_from to jiffies at
 first charge window
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bpas8tm8gjk1xzgdm8gbobz3x7dcxt8m
X-Rspam-User: 
X-Rspamd-Queue-Id: DC960140009
X-Rspamd-Server: rspam05
X-HE-Tag: 1755750556-647745
X-HE-Meta: U2FsdGVkX1/qBFx8OLisRLgMqgxlZHTLNsJwkXxoL10xdQKmfIJNnr7CUUuYKGaTnvbBwkaoe6aCcDc4uklVAKL485U4yyFdcY33EPRdfudC0S8DgUgSbFiBr98/iV5869Dj/vDgRj+QJOmN1k8UCi53U/2pEKRck42POEqljce93vRyEFMdhfNoHSxZ9HxFgb46yiRZ6eMrsZTOJr45aAf12iHWt/XEeWfsc3IMvARvPXzPHTer34HbLohQ3qkHFv+dIQ/s3xQHKMBbXinpZHER0LNcTzHahj8qjpewXkiGpgPlntG65s2G//RG6QUR/CUzH6GBHvSHd19KIOJBlelN4Rd6UUimO22c76G6e/tzbjHkQKea54HX3d2PUtCfvP0xVPnI3DArLjek62F1Hf56Ny8wXDeNAzwL/RAQ/I3edC9OTBW8S/De/r9bg8JLGVVTusBpE7ykN3LRzJa/9oiZj/pfunOW9zGgPiouI5P64pO1h36osIxpd3DtDaqbuk8pmh6VF2MVxydzSr08n4VpqO0AKG0uuW/aZp+U9PynhmJHUVGr9eVdBsMdgz9+jrvI5A1rhowlJ6X9Isg8QXiKt1IpFVfTnorXcOGfiv07O0vLMMKhK49S+Gq3tIIpEMT6gDUqE7nUWjHg11tkNSX4sEYCwO4s2iMe3eXKydFY4T7qSU/hokp5pzPSfb3NaskS453Sg10Nm9dAr0/wiO/zOOJPeS9DmS05ts8LdvO51Ru+iNhQxBQ2jeAy9HCmztC4XfmgtinFZjNiXRPRt1uRsX0aLzg574mtNzIRpACf3MgqIRTve5a8IfmxF2PG72im55GjyjOK8htX3HSCKCYZtiUmPPQ2d5Xj+cFIohlTPwfAyrzGDk0zyFE2ioPiFTQ/wXSyT2eyEjNC5dGp6etMYlU+y/0tAZEC/1oWlPSvY3zVvMwWqraXb3qKXrVkkSXg9WW9A6S6OVFlSsL
 7/q/pQNI
 Dz+aVq9vUCT/YJ1YV2dCfYBXFZ4ED+Ugt4KN7UGruYF0Qn06kSGiNk6XtATF8sxsNVu0Si3bUAkj7r7Vyo5h1axlEF1NarTbHRT3t+wsjpqxGnHhFRL1/+ZLLKJKG+GQMJxApuQ12fcAUsB1khM43XiAf+O+AAhgKOL6AIt/Ci7nevNbCUjXUp8+3kTXVSidYHRrShhlX/8U1QT13Gqph9d2OhBepjaIZ1v0n1ACRe93f+dzv4Pil1R1giW5edB+TQHuGaFD5yGrGOT+pYzV3lkC9Bc5/4l8b+nzw61JrMmHP0TWpKhX1DyfA4LSmy3Sd/NyEHQ+Jc4tZ+WgdVINRUYgA3Ma2URZAHL7kYIwqROx+uC/cXKSglJg2xbqfa0QSPJg9Kn6Kl7EaBorAcj+CsNRfv73mjKYRiisOE0FPYOKlZZ46EWRqKEio7agNJ6ACIQzO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 11:54=E2=80=AFAM SeongJae Park <sj@kernel.org> wrot=
e:
>
> On Thu, 21 Aug 2025 10:08:03 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>=
 wrote:
>
> > On Thu, Aug 21, 2025 at 3:27=E2=80=AFAM SeongJae Park <sj@kernel.org> w=
rote:
> > >
> > > On Wed, 20 Aug 2025 22:18:53 +0900 Sang-Heon Jeon <ekffu200098@gmail.=
com> wrote:
> > >
> > > > Hello, SeongJae
> > > >
> > > > On Wed, Aug 20, 2025 at 2:27=E2=80=AFAM SeongJae Park <sj@kernel.or=
g> wrote:
> > > > >
> > > > > On Wed, 20 Aug 2025 00:01:23 +0900 Sang-Heon Jeon <ekffu200098@gm=
ail.com> wrote:
> [...]
> > I think that I checked about user impact already but it should be
> > insufficient. As you said, I should discuss it first. Anyway, the
> > whole thing is my mistake. I'm really so sorry.
>
> Everyone makes mistakes.  You don't need to apologize.
>
> >
> > So, Would it be better to send an RFC patch even now, instead of
> > asking on this email thread? (I'll make next v3 patch with RFC tag,
> > it's not question of v3 direction and just about remained question on
> > this email thread)
>
> If you unsure something and there is no reason to send a patch without a
> discussion for the point, please discuss first.  To be honest I don't
> understand the above question at all.

Ah, I just mean that I need to make a new RFC patch instead of
replying to this email thread. I'll just keep asking about previous
comments on this email thread.

> >
> > > >
> > > > In the logic before this patch is applied, I think
> > > > time_after_eq(jiffies, ...) should only evaluate to false when the =
MSB
> > > > of jiffies is 1 and charged_from is 0. because if charging has
> > > > occurred, it changes charge_from to jiffies at that time.
> > >
> > > It is not the only case that time_after_eq() can be evaluated to fals=
e.  Maybe
> > > you're saying only about the just-after-boot running case?  If so, pl=
ease
> > > clarify.  You and I know the context, but others may not.  I hope the=
 commit
> > > message be nicer for them.
> >
> > I think it is not just-after-boot running case also whole and only
> > case, because charging changes charged_from to jiffies. if it is not
> > the only case, could you please describe the specific case?
>
> I don't understand the first sentence.  But...
>
> I mean, time_after_eq() can return false for many cases including just wh=
en the
> time is before.  Suppose a case that the first and the second arguments a=
re,
> say, 5000 and 7000.

I think my previous explanation is not enough. I just want to say,
time_after_eq return false, but user expected true case; And I think
that's the point we want to fix.

Maybe I can change my previous question like this, "Is there any
situation, that charged_from has been updated before and even though
reset_interval has passed but time_after_equal() returns false".

I asked this question because I think that kind of situation can't
exist and minimum version of Fixes patch(5.16) uses esz in the same
way as it is now. So I think that we shouldn't use "stop working" in
the commit message.

As I was writing this, I thought about your comments deeply again.
Since you describe the current state of esz as a bug, I think you
might want to write "stop working" to comments, because I think you're
thinking that some fixes patch could change esz initialized value
(also reasonable, I agree)

I think adding an explanation of the above knowledge is good to help
newcomers to understand DAMON well. Also, Could you please check the
above question for a more detailed commit message?

> >
> > > > Therefore,
> > > > esz should also be zero because it is initialized with charged_from=
.
> > > > So I think the real user impact is that "quota is not applied", rat=
her
> > > > than "stops working". If my understanding is wrong, please let me k=
now
> > > > what point is wrong.
> > >
> > > Thank you for clarifying your view.  The code is behaving in the way =
you
> > > described above.  It is because damon_set_effective_quota(), which se=
ts the
> > > esz, is called only when the time_after_eq() call returns true.
> > >
> > > However, this is a bug rather than an intended behavior.  The current=
 behavior
> > > is making the first charging window just be wasted without doing noth=
ing.
> > >
> > > Probably the bug was introduced by the commit that introduced esz.
> >
> > Thanks for your explanation. I'll try to cover this point in the next
> > patch as well.
>
> If you gonna send a patch for fixing this bug, make it as a separate one,
> please.

I didn't mean newer code changes, just commit messge. As you said code
change should be created with another patch, if it has another
intension; Also, i didn't have any plan yet. I'm trying to resolve
this patch first

> [...]
> > > So what I'm saying is that I tink this patch's commit message can be =
more nice
> > > to readers.
> >
> > You're right. I'll try to make the commit message more clear. I'm
> > really sorry for bothering you.
>
> Again, you don't need to apologize.

Maybe, I just want to express my gratitude :)

>
> Thanks,
> SJ
>
> [...]

Best Regards
Sang-Heon Jeon

