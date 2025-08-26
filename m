Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B9B9CA0FF2
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 16:26:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E3C16B02B9; Tue, 26 Aug 2025 12:26:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 394A26B02BA; Tue, 26 Aug 2025 12:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AA6D6B02BB; Tue, 26 Aug 2025 12:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 160626B02B9
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:26:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B961F1601D5
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:26:42 +0000 (UTC)
X-FDA: 83819437044.28.056E172
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id BFFC2120011
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:26:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hn8oV7H9;
	spf=pass (imf29.hostedemail.com: domain of pranav.tyagi03@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=pranav.tyagi03@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756225600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5zGMY0B+wsQd0Wnquc7Hok6cqc/WBPDwGcUcIfHRhk=;
	b=JgEfYO0Yz8Ar+pILXCB+g3pL3YBsJEAQQRBMxPjxldFMAzeJmNXd4YAwVBqG9XmtZuMMQy
	i5Mf2cUwjuBKHZ2LODyPnQBe4V4M5NNx3aILNWXFDIpD+SZHRiNp4MiGAl7k3rgWVxTuNi
	UCKophFHgQFjnjxlYw3CpXshcgVJTvM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756225600; a=rsa-sha256;
	cv=none;
	b=pHkAZUs1UB6i/pTMdv2C1/ZIZf1c080QLiqE9w3iAZmFG1qJr5hfGObGCWZhBG5FzppN7A
	7Jtot+YL8n3yOyjW8wFiDaeBK6U+kRnaC0yKg4FNge6ipreAoA57hfACETohdoIkntXMqB
	hNgH8PQQiwsjMCkkjuzUPCNgIsyOfhI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hn8oV7H9;
	spf=pass (imf29.hostedemail.com: domain of pranav.tyagi03@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=pranav.tyagi03@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-3367f35d031so14896901fa.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756225599; x=1756830399; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I5zGMY0B+wsQd0Wnquc7Hok6cqc/WBPDwGcUcIfHRhk=;
        b=hn8oV7H94svRdRkxGdB70jdqzBwY0ux+qG4U698BEJ+0PP4C7cUgvZS2FAB3Ft8q7w
         56DTCARFNbnovQ1TVP3L2USowg6bri8Sdx4Bwg40aE2Rf6OWnlyPBS9YLNTOY302VhmH
         wVbHpHC1mhg/V8daa5nmIrOEy0EO0WdiWnKbY2Ke9IHkdSSAxTzds5A/WKbHz7gRNP7h
         qheiBeKhV+Ufxj/XLYBe3Jv5BK0MOi8O8xdmLPhwIpaDa8PEoEFnSf4G1kppC3NbT5Bj
         j47S++zS8Eide9VysWRCddp9CLW17HDk8WXmT6X/Z0BWqYo9DD3CkM3yvmyzsoin3zDN
         O8Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756225599; x=1756830399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I5zGMY0B+wsQd0Wnquc7Hok6cqc/WBPDwGcUcIfHRhk=;
        b=qVbmgBEH1In7ej4YHicuOMTKznP/ZLnW8KtC7Fq+4XvVBPwy8GAWrvYSflzHD8xxzx
         XZ9LLSqc59bob1kKlxa2skfDnCATebau3IIWgS2CF6hMVwbh7dZKMbUmYQ5T1G/xhwVQ
         POD29MUHrZF+K8GWgAjpvp4qlnMQxlx5VxCAgf57aRVyHrzFj36znwg2En2kekoQBZOW
         7afAAkEUiEBiukgsuLpHpL9uyo2pECwOO2aSvCFowO78AdopfaBJguGn7HSJP9IgOW1m
         xpVr4k9sf/e9yD5sf/q2wB8ft3oumj6q4ra50JZs034z70RU31/14ODTlee93LCuq6xG
         nOGw==
X-Forwarded-Encrypted: i=1; AJvYcCWKedpvl9TM1gyV/RgAA6cv1HBSfxkaRRbqhe41HVnIkHKYfzLYTi7Oq2Xucqmm/R5zenOZDTGVWw==@kvack.org
X-Gm-Message-State: AOJu0Ywizgn3E2EtjaSmdDP39MZSXOofG4vITWJ0yvbaqigQGzW8dZCe
	oO7Nn1ICKvVs55G9/waU8akJWM7T4HdzhuSxjcfhge3mFRZr1RahCqJRYiLsJjah/cXYU54kty9
	2W+w6btXJCzU/nnEOLYCGxKDpEL7vT8k=
X-Gm-Gg: ASbGncuSuyxfRDpDRxRl+XDIBPuRQlHFKbDxLwg+XdCk9lJkiRpJ3XhW3SUz+Pj++oK
	ZK/JWfKyJ8HkX1UMO3xtXtx4244YsB53op78pYuUnKZn7PlpB2xAbD9PLy5f+Tu8mNXvjXU7O8L
	Y1KTbo25ZjGHFl1nkBOvbn5SC8TGibM+oAnQ+AqXokzs/egQdptzKgPQ43324O9e0dgDFGjIYbN
	YDRzms1UNhxL8n8rd+rykHlHDYrk6lCddRFaBe3VQ==
X-Google-Smtp-Source: AGHT+IHkb64c4bZS+NGaeP4VCluu/PBLB8BKBtdaSeEYU+WxbjYgL2JboP1sxe+Bh7hVlYsMPO1uy+hpvD/0fQSHB0E=
X-Received: by 2002:a2e:be92:0:b0:331:f04d:e689 with SMTP id
 38308e7fff4ca-33650fc8436mr45721141fa.41.1756225598840; Tue, 26 Aug 2025
 09:26:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250730142301.6754-1-pranav.tyagi03@gmail.com> <20250806164841.2907972-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20250806164841.2907972-1-joshua.hahnjy@gmail.com>
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
Date: Tue, 26 Aug 2025 21:56:26 +0530
X-Gm-Features: Ac12FXydsbaI3ePxtk_Pq8B7Slgn4iz04KSeXyYj_cYZPkXFV1_OSHzZmmvB410
Message-ID: <CAH4c4jJmCP8w8mbeTpOhNvWCgb9U1A+ssny3nSw9Qg5tEnqVcw@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: use __auto_type in swap() macro
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: akpm@linux-foundation.org, peterx@redhat.com, shuah@kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BFFC2120011
X-Stat-Signature: 5oqtzhxyhorspeqf9ixrwhs5f1hup7u4
X-HE-Tag: 1756225600-485044
X-HE-Meta: U2FsdGVkX18Z3R9sv49emyP7Ke1KOzms1JxgDpbf/8wRiRagFcaBbi7l13vqm/lHy5Oe9cJoao+OdxfusAu+wuLj6jkAWHKGSNAhPsWB6Bqnj39Buy+Q6xluog/gpjsSzVYwRx51BYyuShNtHYtU+NOrjQjtMznspw1WJEBIaDQ8BlW23ZXxcnewI/odQpzt9LPZSLsb7l6R+1gtoLly5WNc+oQJTcehx86i8x1ASwXCcGqHEg19OstdNWs+7Zlb4NchmnLs7xW3ORYkz29oKV5JPQLbUCm3WOsxA9eseLCZcyU9+3+9tlTukrC0hMI+6fduFLHCIDzp1073VCkmqIHJZh9p6kV3Hj3KZyXTtRHwecwJnOx8YYoKJIhQk8n0W0vojsTXSU0kgY9ddBb2el8DvIFApDZ7WSE/xlQudxZIRYBcJa1j6aOYrnuoadfu8XTPBzRfMEbjYuxERXNAOoxD07xep9vpAMS4yluxvuO3UtVHCG/jnNHbWi2RVKz+NFIQlREMQyPt/MDSCVb/1Stspd4bEsysadfVJL5Qmz/xGZJUM9qlh0IMb/WyI+XQQUk53nTz5E1CSu0JAmDuzjn0xrA1nB8XDhHTQ9YTtd6WbJyEYHWUSCTjJnavoBJvEu3WbRf9ug62GXo8oBiBjrFQI84eX0nJIf1WCHEoG/GVDyA65fGsVZfczFU6NIzWrAc5FecJ2x4o8YvLGowIB/PMMIHf6DkQZCRdYsxbjNKHRGA4dFFEz2n21VufawiiAKbzBPMGMTh67K9pKkx9vKs0wm81uHf9ZoSzGGmjq9dLZbEFRA4zCKEnRKOvIKoyxnVLhSYI7XxL4amMOgktG/Xu43/V5HU2Mo4bPX5TPGL7WSR5qANjfL/NurH13qV0QYcb1YQp8pkNrKa8jAI0Ynf4iVjAQGP18GxD4nwJ/Pq9y/1KeAJgkwTZ61U/viuj2x1qwwQ3Wh5lfPKkCoH
 /9i8UE91
 6UqxeyGCWHXfMJ1DJ10FohLWHU5cKUUa4HfhJr1E7BI9Cgo4+VRyjpezm5yoGWvVlB3xeZ0/H9/6+Jlg0cSNknqCxxihrqTGGUu3MHBtEoPz6sB8BMjisDjFSgp6uR/G0bj89RQUjffhsafzrhCz1QLalZLv4hjiAti165wShjzWl1C3VTwSigzx6Rf/kxiVg6oecCt1Yd13AJiWAn/53rzA8lnqpenUT/HcNAZTpXhGDiH89lTpZInAtTKH4aWvjXEhgdypfroE9+LlQVaZVXdtEt0KS3auHfVCiY23nExNLIsT2nRdzotAmrRttud0ca2O5DLvJHsGq/Ul7r4oHZzozcf9wIsGSmmdQzhXpOg8GdZEV56WKagOg6Wsrk1WLlemp1cQ003SKkdavEtKtnxRG3FddG4lk9Bqd6dpeo0woiJyJpvYbzYhQswNU/uAdQxfc151bbdM08Sw9zJs1bhdLDmp7Vw8DncDBSMtGctxf5V/7s70ILf15zq4ry7knyTy6w+1VMzdgdaw1nM1hV0b8WvnJFuyIwZV5sCtJ/j2Fy50=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 6, 2025 at 10:18=E2=80=AFPM Joshua Hahn <joshua.hahnjy@gmail.co=
m> wrote:
>
> On Wed, 30 Jul 2025 19:53:01 +0530 Pranav Tyagi <pranav.tyagi03@gmail.com=
> wrote:
>
> Hi Pranav,
>
> Thank you for this patch! Sorry for the late response, thank you for bump=
ing
> the patch. I just have a few comments about the commit message.
>
> > Replace typeof() with __auto_type in the swap() macro in uffd-stress.c.
> > __auto_type was introduced in GCC 4.9 and reduces the compile time for
> > all compilers. No functional changes intended.
>
> From what I understand, the compiler optimizations from typeof() --> __au=
to_type
> applies when the argument is a variably modified type. It seems like this
> internal definition of swap() is only used within selftests/mm/uffd-stres=
s.c,
> and in particular is only used twice, in these two lines:
>
> /* prepare next bounce */
> swap(area_src, area_dst);
>
> swap(area_src_alias, area_dst_alias);
>
> Where area_src, area_dst, area_src_alias, area_dst_alias are all char * w=
hich
> the compiler knows the size of at compile time. Given this, I wonder if t=
here
> are any compile time speedups.
>
> But this is just my understanding, based on a quick look at the code. Ple=
ase
> feel free to correct me, if I am incorrectly understanding your changes o=
r if
> my understanding of __auto_type is incorrect : -)
>
> With that said, I think the main benefit that we get from using __auto_ty=
pe
> has more to do with readability. Since __auto_type can only be used to
> declare local variables (as we are doing here), maybe we can rephrase the
> commit to be about improving readability, and not compile time?
>
> Again, please let me know if I am overlooking something.
>
> One other thought -- while this internal definition of swap() is confined=
 to
> selftests/mm/uffd-stress.c, there is another identical definition in
> include/linux/minmax.h that may be used more widely across not only mm
> stresstests, but across subsystems as well. Without having taken a deeper
> look into this, perhaps this version of swap is indeed called on some dat=
a
> structures with variable type, and we might be able to see some tangible
> compile time improvements?
>
> In any case, this change looks good to me, but maybe a new commit message
> that can more closely describe the effects would be better : -) Once you =
add
> those changes, please feel free to add my review tag for the mm selftest =
change:
>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>
> > Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> > ---
> >  tools/testing/selftests/mm/uffd-stress.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/s=
elftests/mm/uffd-stress.c
> > index 40af7f67c407..c0f64df5085c 100644
> > --- a/tools/testing/selftests/mm/uffd-stress.c
> > +++ b/tools/testing/selftests/mm/uffd-stress.c
> > @@ -51,7 +51,7 @@ static char *zeropage;
> >  pthread_attr_t attr;
> >
> >  #define swap(a, b) \
> > -     do { typeof(a) __tmp =3D (a); (a) =3D (b); (b) =3D __tmp; } while=
 (0)
> > +     do { __auto_type __tmp =3D (a); (a) =3D (b); (b) =3D __tmp; } whi=
le (0)
> >
> >  const char *examples =3D
> >       "# Run anonymous memory test on 100MiB region with 99999 bounces:=
\n"
> > --
> > 2.49.0
>
> Sent using hkml (https://github.com/sjp38/hackermail)

Hi Joshua,

Thanks for the detailed review and I sincerely apologize for the delayed
response.

You=E2=80=99re correct =E2=80=94 __auto_type mainly provides compiler optim=
izations when the
argument is a variably modified type and in this case the compiler already
knows the size of the arguments at compile time. The motivation here is mor=
e
about readability and consistency, as __auto_type is already used in severa=
l
places within selftests. This patch has since been picked up into the
mm-unstable branch.

I also looked at the swap() definition in include/linux/minmax.h, which is
indeed more widely used across subsystems. That version may offer tangible
compile-time improvements in cases involving variable argument types and I
plan to follow up with a patch there.

Thanks again for the thorough review.

Regards
Pranav Tyagi

