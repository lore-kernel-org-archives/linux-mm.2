Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3875DCE7AEF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 14:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 981178E0013; Fri, 14 Nov 2025 09:14:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 931EB8E0002; Fri, 14 Nov 2025 09:14:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86F298E0013; Fri, 14 Nov 2025 09:14:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77BCC8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:14:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 214A0B8913
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:14:58 +0000 (UTC)
X-FDA: 84109409076.27.BCEE13D
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3D451A001D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:14:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mmy5Q1fs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763129696; a=rsa-sha256;
	cv=none;
	b=jIkKAmw73i3lqNQzK3c1fDrr/ZUZViGtCnHsIa/xVs/scCTrug53Yuis3RbSxvHHxAHRvc
	QM9o06PpOru5DWq48s7vqoE6sinKRwlUMUpb7FN01UAnr/EDj356l16oNlhb7Gzzohn/AG
	EiAtvr6W9YCCyz5Xl6kEs6VEBeB8J+Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mmy5Q1fs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763129696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ux+5fT0SHoFXYWWV7r6ARLgTLo8QYHEVMWR3wNK0wtk=;
	b=I0lBYD/uSPgZCr58Svx1mTnnNZbxxHTDLkNS9otyxEFM6Mrb81Vi9nkAMf1xVtLlr3Hu5L
	5OSovgyHkyDyMq3xb23jnFqbaFrovJvEPtExX7/0upkyI7YkNZ2ffYEs0BWL0xtTkmnfcB
	tmjXMOxjq99C/oHfoNcQ44zUtYHRzE4=
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-3e4228e0fb7so1005562fac.3
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763129695; x=1763734495; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ux+5fT0SHoFXYWWV7r6ARLgTLo8QYHEVMWR3wNK0wtk=;
        b=Mmy5Q1fs7ynwQFXx45SWKRyKKAohoHfmzNWIprKhJ2HkQJ2YHdV9pw4oOBEzItB+Qt
         TA9WJJoxzMomDredAyAnj5kveM8uCm1UkZl+s9Ui16+oME8fR2E7fdBClyOmAemaq+JB
         VK2EoGaHQ14a35amsn70/713vvRsMX+A5oD11z81Tf0s5IrAnhMaLX36kD7HmP//JAyw
         m9mV9NCJbilrkYfV0DP9Tx3wlvSShWkTNOZ+Cmt/rqrf5OYZPnLc95lqx8ewXCiBWW6/
         CNd+hrOkCJS4plG4O1IMJNiCzrUpSJK1DRK3u/mcDdKhkGYNtRRdvt1vJeBoPYYzOJ3q
         OpMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763129695; x=1763734495;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ux+5fT0SHoFXYWWV7r6ARLgTLo8QYHEVMWR3wNK0wtk=;
        b=g755AZzpGIRZ3/MK8Y4DCp1TwOoJDRbstBnvVR2i/MY1acsVnwsHl4gg1gihoMboP0
         690//Jbn/j+1oAZMtZW2SHjW/3xSWWLUFCJ0VE2E8kTO45/8yPgg7asL+ju7yub6tV7f
         /FqGloFkxpSe3q3VtIWM5KsE5+ovylAJM7ZZ+5CG8txpmHi43wvUx3J8+7AlmiNV94mc
         H1SMp8M+EDiHpTMkSqNfFTxIa39DACxX35lG6V2g98xFBOhxXg0rX8TJ6diISdBfIDCo
         IWzSsYOajs/8Tygo5lr/xLuXeanK0YvcRxKDkzfawYxpP+Jgf/Q8mJhJD5sOHGLdJcCe
         T+Cg==
X-Gm-Message-State: AOJu0YzWcIC4pxWdWzR9XpF4lj1qxDa6eToJlMDVLk55H5QbRsY7vF0Q
	nci6qjya+fKkusvecV7GZt63JlAb4N2WysU7wFbFZHZAvyiT/0QpJJgeovkD/yhOUCW+dvvHj9F
	bSnaTxuv950xY93MXPs7KOEnx/cP9g6A=
X-Gm-Gg: ASbGnctTLiMSVvt3Altqw4km2xtGml9F5a93N8S42WsCm0+lgS/dFCg7qL9W9XbMIJB
	mLX28Exg1TKVN1sYfkP1EtfWhA6vEW6qtEOoIlDcCrlS22DmlyIgT+otYR/2dP/TlfBTMeSe9I4
	jpC1OdOWSwANiSVqN5zqKTheEWyNkzDbKMixNkqU7OqiQFFoiVxPKhMUmV5nfZFX0K+8AT4+cXp
	04njj0nvWxm4u5XdL71qkoXrZ279iakq8Tgah0PivQnTZWGBUGBaNg/9BTpr3InxE+3S1M=
X-Google-Smtp-Source: AGHT+IGJDWDMV97flkpsb5aUMgER5tLQeuG5ok2Fj2Zouz9V9QSe0Rnr9MpZgzAjwXmZfgIXo3BPG7KJol94oCl8byc=
X-Received: by 2002:a05:6870:c152:b0:3d2:a6f6:dfdc with SMTP id
 586e51a60fabf-3e869169340mr1898329fac.47.1763129695037; Fri, 14 Nov 2025
 06:14:55 -0800 (PST)
MIME-Version: 1.0
References: <20251114085038.191031-1-peng8420.li@gmail.com> <e5c930a6-f10d-4715-aa80-64152b30d96e@kernel.org>
In-Reply-To: <e5c930a6-f10d-4715-aa80-64152b30d96e@kernel.org>
From: peng li <peng8420.li@gmail.com>
Date: Fri, 14 Nov 2025 22:14:46 +0800
X-Gm-Features: AWmQ_bnuB3QKSeYC1WE4PKHYJdnYKRLzddGVJDritMGaRDngaV7c1hrqhn7e5U4
Message-ID: <CAJFsz5wDOG7PAR0t1mbeuL_R-9LfHR4POcTZUvyakyQ53gVBoQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Remove the "FOLL_TOUCH" test code from gup_test.c.
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, osalvador@suse.de, 
	jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com, 
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com
Content-Type: multipart/alternative; boundary="0000000000002a6cab06438e9f03"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3D451A001D
X-Stat-Signature: dsb99yijii9rkdah9g6szn1wmidz3ry5
X-Rspam-User: 
X-HE-Tag: 1763129696-360555
X-HE-Meta: U2FsdGVkX1+j5M0iCxHuFgMF0OVVJDPeYcJtTby9f+4gzvVXrNhbBsuOCXtv+8uEEYtTiDDcS63sU8Rpr1JpanPEGJlS0OiC8nNG1YsctZ0yFywxVf/ddp3UXBE1cOVcWyQrjiLGoIS1YPhV0sPQ0GKu55Rhu82CqZIBIOH0hKsxESa5R3sl9AcrraolC2ZiDaQlRWWs5NUmH3B1Fp+Aw0V88sLjsbcW1/lGcBixSZsjs/mSH94LcqQG48qVgC67oDIoaAZpiuB92p3SdWLoN1SWhueuXijNPGAaMJLmD31iOef+BDEd3drEFJEbKGaEISQPXjipFqc4rc8qBvmAGjVLVOkkpC1K+SQvhiaUJd2ci4l5vl+t5M35vSjo9vTf2FM7XaaRDsehR4ucvczPiRr3/FGBHHlJ4pJnJhAZX5vFRGRFihSNfe2k35d/e5ULvLoVF+aNFzwuhXdEqQLrXRln7HMS7rPyq8BHvK3jsS3OAOSG9QQHQ3jGQEEtdEb9vTWGI2tJFvxsLg5GRKFRDb5Si2Cte4o+dooM+GV8LN8HFnd7Fpcou4KJpZ8EiO9FARljQ7WCW8amJnjnXGUFa7RQamMH686AfbOLWsn/LYqIvOB8Y3RrOYoRYyZDtB8XMzSM/2k4+EZKHizTy8UzBV2yRJA2pn2PNSsNu21dS9myT+Cqy7SR6M6cRTZ50h6otrZbshKmtanqJMm+BIgJvRJhN1W8G7elNFObEJy5dg4NKCVYJzkgvsvgW7SHvVq0wIgwqdB2gdDHPCbZIaP3gxMJan2KaINo27LdAe4wmJ7dQ5D9BBqHXBQNpHlnXXO24U+/YMQUIy8NnSfz0OneuBxdyGaUyQc45YWg0FhW984aaUQqDeE5Eg4jIA6h9YRUscfl6s3G3hNG9ScsNsrH8D8YEw1hjOK4vy7OeZAkVkiFvQXIF89MYdpLkzs+wydh1mjW5jj1IjRk9o5nQKB
 r2TxZrGP
 S/poPo1cLQ4sgxn2kX2SELX2s6205gmFCxer3nwv/+KENAENJD5bJR13zmKUAbcBz+WOQ6aSnO/TAYwu7AMfPUIrxsmEHVXbtSb+mM1UBW5Cf+JSrDeRTcShNxPqIdXFsa4Df6D6Ruxr/kz/miI4I3Pd3iYEQl0kQFqnnwIdCbbi8DOtmmGbnsjhPI7DtfL4FWW4Zl9g71kMYVsQtqQzv32fMbJSxSG0uRtioro7e7rkJHJVpNDxqELkoeEMhQnywc9Ru2Hr8UYezBTeRSLyhmFmtEavJbR9Qh4jp39jIExF4n8cu862rYMmJJ6bBRfG8rw7gFOefUVBcHoGE9aVhPsmX2gB75YiG5N4UyxuyppPZuuvMeyEuXbXodZLWpOkMtzjTLEVBbxzK8VYYjtUsurRHjeF+XbLmHsPbxigD1e0EoqtJMttfwX3sy0G7ZoMP3CbjV0/DOqxCx81/7Drv0sZWjNW9MpDI/Awb/OGBO3agsKSs/i+ZZIyQuaF8Vff6HaR9rr3kqR9xD5qCYiO1+o15onwFpjrQ2W80vOnECiS0HI+6g9kb9Dqjs/eLIjHEgqhXs6JrHlXB/NBEMlXSGCCFC6+45efikJ8CHw5p6MvUVicdV5fGJht2cuv7UhTyM75qituB5wF3XNyXwVM4TKBImdJsBSnqkm/k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000002a6cab06438e9f03
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

David Hildenbrand (Red Hat) <david@kernel.org> =E4=BA=8E2025=E5=B9=B411=E6=
=9C=8814=E6=97=A5=E5=91=A8=E4=BA=94 17:06=E5=86=99=E9=81=93=EF=BC=9A
>
> On 14.11.25 09:50, peng8420.li@gmail.com wrote:
> > From: "peng8420.li" <peng8420.li@gmail.com>
> >
> >  From submission 0f20bba1688bdf3b32df0162511a67d4eda15790, we know that
"FOLL_TOUCH" is only for internal scope use;
>
> That is not the proper way to cite commit IDs. Likely checkpatch.pl would
complain here.
>
> "Ever since commit 0f20bba1688b ("mm/gup: explicitly define and check
> internal GUP flags, disallow FOLL_TOUCH") we marked FOLL_TOUCH as a
GUP-internal flag."
>
Got it, will remember to execute checkpatch.pl :)

> >
> > Therefore, remove the "FOLL_TOUCH" test code from gup_test.c;
> >
> > Otherwise, executing the test command "./gup_test -L -r 100 -z" will
report the following warning log:
> > TAP version 13
> > 1..1
> > ENCHMARK: Time: [   39.363371] WARNING: CPU: 1 PID: 117 at
mm/gup.c:2512 is_valid_gup_args+0x66/0x8c
> > get:2818 put:46 [   39.364043] Modules linked in:
> > us# , truncated [   39.364311] CPU: 1 UID: 0 PID: 117 Comm: gup_test
Not tainted 6.18.0-rc5-00324-gd09eaf415c87 #29 NONE
> > (size: 0)#
> > [   39.364434] Hardware name: riscv-virtio,qemu (DT)
> > [   39.364546] epc : is_valid_gup_args+0x66/0x8c
> > [   39.364596]  ra : pin_user_pages+0x38/0x78
> > [   39.364630] epc : ffffffff802079e6 ra : ffffffff8020c214 sp :
ff2000000041bd20
> > [   39.364650]  gp : ffffffff81a26068 tp : ff60000080b3b000 t0 :
ff2000000041bdf8
> > [   39.364678]  t1 : 000000000000001e t2 : 0000000000000000 s0 :
ff2000000041bd30
> > [   39.364697]  s1 : ff60000081300000 a0 : ff60000081300000 a1 :
0000000000000000
> > [   39.364714]  a2 : ff2000000041bd3c a3 : 0000000000080000 a4 :
0000000000000001
> > [   39.364731]  a5 : 0000000000010101 a6 : 0000000000000001 a7 :
0000000000000000
> > [   39.364747]  s2 : 00007fff7eeed000 s3 : 0000000000000001 s4 :
00007fff7eeee000
> > [   39.364761]  s5 : 00007fff7eeeb838 s6 : 0000000000000000 s7 :
00007fff7eeed000
> > [   39.364825]  s8 : ff60000081300000 s9 : 0000000000000000 s10:
0000000000000002
> > [   39.364842]  s11: 000000092869bfdc t3 : 2152ffffffffffc0 t4 :
00000000001fffff
> > [   39.364855]  t5 : ffffffffffffffff t6 : 0000000000000000
> > [   39.364867] status: 0000000200000120 badaddr: ffffffff802079e6
cause: 0000000000000003
> > [   39.364949] [<ffffffff802079e6>] is_valid_gup_args+0x66/0x8c
> > [   39.365036] [<ffffffff8020c214>] pin_user_pages+0x38/0x78
> > [   39.365049] [<ffffffff80278f78>] gup_test_ioctl+0x2b4/0xc08
> > [   39.365060] [<ffffffff80297da6>] __riscv_sys_ioctl+0xba/0xc4
> > [   39.365072] [<ffffffff80b93f96>] do_trap_ecall_u+0x296/0x370
> > [   39.365093] [<ffffffff80b9ef06>] handle_exception+0x146/0x152
> > [   39.365220] ---[ end trace 0000000000000000 ]---
> > ok 1 ioctl status 0
>
> Right, gup_tests simply forward any flags we pass in. I wonder if we woul=
d
> want to filter them for ones we expect to test?

This's a good idea.
Perhaps next, we can take some time to select those non-inetrnal flags in
"mm_types. h" and add them to the test.

enum {
    /* check pte is writable */
    FOLL_WRITE =3D 1 << 0,
   ... ... ...
    FOLL_HONOR_NUMA_FAULT =3D 1 << 12,

    /* See also internal only FOLL flags in mm/internal.h */
};

>
>
> I guess we should add
>
> Fixes: 0f20bba1688b ("mm/gup: explicitly define and check internal GUP
flags, disallow FOLL_TOUCH")
>
> Although it's a bit complicated with gup_tests.
>
> >
> > Signed-off-by: peng8420.li <peng8420.li@gmail.com>
> > ---
> >   tools/testing/selftests/mm/gup_test.c | 22 ++++------------------
> >   1 file changed, 4 insertions(+), 18 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/gup_test.c
b/tools/testing/selftests/mm/gup_test.c
> > index 8900b840c17a..75f7134d529d 100644
> > --- a/tools/testing/selftests/mm/gup_test.c
> > +++ b/tools/testing/selftests/mm/gup_test.c
> > @@ -19,7 +19,6 @@
> >
> >   /* Just the flags we need, copied from mm.h: */
> >   #define FOLL_WRITE  0x01    /* check pte is writable */
> > -#define FOLL_TOUCH   0x02    /* mark page accessed */
> >
> >   #define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
> >
> > @@ -93,7 +92,7 @@ int main(int argc, char **argv)
> >   {
> >       struct gup_test gup =3D { 0 };
> >       int filed, i, opt, nr_pages =3D 1, thp =3D -1, write =3D 1, nthre=
ads =3D
1, ret;
> > -     int flags =3D MAP_PRIVATE, touch =3D 0;
> > +     int flags =3D MAP_PRIVATE;
> >       char *file =3D "/dev/zero";
> >       pthread_t *tid;
> >       char *p;
> > @@ -170,10 +169,6 @@ int main(int argc, char **argv)
> >               case 'H':
> >                       flags |=3D (MAP_HUGETLB | MAP_ANONYMOUS);
> >                       break;
> > -             case 'z':
> > -                     /* fault pages in gup, do not fault in userland *=
/
> > -                     touch =3D 1;
> > -                     break;
>
> AFAIKT, run_vmtests.sh does not set that flag, so dropping it should be
fine.

Okay.
Thanks for your suggestion, which allowed me to start organizing the second
version :)

>
> --
> Cheers
>
> David

--0000000000002a6cab06438e9f03
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br>David Hildenbrand (Red Hat) &lt;<a href=3D"mailto:davi=
d@kernel.org">david@kernel.org</a>&gt; =E4=BA=8E2025=E5=B9=B411=E6=9C=8814=
=E6=97=A5=E5=91=A8=E4=BA=94 17:06=E5=86=99=E9=81=93=EF=BC=9A<br>&gt;<br>&gt=
; On 14.11.25 09:50, <a href=3D"mailto:peng8420.li@gmail.com">peng8420.li@g=
mail.com</a> wrote:<br>&gt; &gt; From: &quot;<a href=3D"http://peng8420.li"=
>peng8420.li</a>&quot; &lt;<a href=3D"mailto:peng8420.li@gmail.com">peng842=
0.li@gmail.com</a>&gt;<br>&gt; &gt;<br>&gt; &gt; =C2=A0From submission 0f20=
bba1688bdf3b32df0162511a67d4eda15790, we know that &quot;FOLL_TOUCH&quot; i=
s only for internal scope use;<br>&gt;<br>&gt; That is not the proper way t=
o cite commit IDs. Likely <a href=3D"http://checkpatch.pl">checkpatch.pl</a=
> would complain here.<br>&gt;<br>&gt; &quot;Ever since commit 0f20bba1688b=
 (&quot;mm/gup: explicitly define and check<br>&gt; internal GUP flags, dis=
allow FOLL_TOUCH&quot;) we marked FOLL_TOUCH as a GUP-internal flag.&quot;<=
br>&gt;<br>Got it, will remember to execute <a href=3D"http://checkpatch.pl=
">checkpatch.pl</a> :)<br><br>&gt; &gt;<br>&gt; &gt; Therefore, remove the =
&quot;FOLL_TOUCH&quot; test code from gup_test.c;<br>&gt; &gt;<br>&gt; &gt;=
 Otherwise, executing the test command &quot;./gup_test -L -r 100 -z&quot; =
will report the following warning log:<br>&gt; &gt; TAP version 13<br>&gt; =
&gt; 1..1<br>&gt; &gt; ENCHMARK: Time: [ =C2=A0 39.363371] WARNING: CPU: 1 =
PID: 117 at mm/gup.c:2512 is_valid_gup_args+0x66/0x8c<br>&gt; &gt; get:2818=
 put:46 [ =C2=A0 39.364043] Modules linked in:<br>&gt; &gt; us# , truncated=
 [ =C2=A0 39.364311] CPU: 1 UID: 0 PID: 117 Comm: gup_test Not tainted 6.18=
.0-rc5-00324-gd09eaf415c87 #29 NONE<br>&gt; &gt; (size: 0)#<br>&gt; &gt; [ =
=C2=A0 39.364434] Hardware name: riscv-virtio,qemu (DT)<br>&gt; &gt; [ =C2=
=A0 39.364546] epc : is_valid_gup_args+0x66/0x8c<br>&gt; &gt; [ =C2=A0 39.3=
64596] =C2=A0ra : pin_user_pages+0x38/0x78<br>&gt; &gt; [ =C2=A0 39.364630]=
 epc : ffffffff802079e6 ra : ffffffff8020c214 sp : ff2000000041bd20<br>&gt;=
 &gt; [ =C2=A0 39.364650] =C2=A0gp : ffffffff81a26068 tp : ff60000080b3b000=
 t0 : ff2000000041bdf8<br>&gt; &gt; [ =C2=A0 39.364678] =C2=A0t1 : 00000000=
0000001e t2 : 0000000000000000 s0 : ff2000000041bd30<br>&gt; &gt; [ =C2=A0 =
39.364697] =C2=A0s1 : ff60000081300000 a0 : ff60000081300000 a1 : 000000000=
0000000<br>&gt; &gt; [ =C2=A0 39.364714] =C2=A0a2 : ff2000000041bd3c a3 : 0=
000000000080000 a4 : 0000000000000001<br>&gt; &gt; [ =C2=A0 39.364731] =C2=
=A0a5 : 0000000000010101 a6 : 0000000000000001 a7 : 0000000000000000<br>&gt=
; &gt; [ =C2=A0 39.364747] =C2=A0s2 : 00007fff7eeed000 s3 : 000000000000000=
1 s4 : 00007fff7eeee000<br>&gt; &gt; [ =C2=A0 39.364761] =C2=A0s5 : 00007ff=
f7eeeb838 s6 : 0000000000000000 s7 : 00007fff7eeed000<br>&gt; &gt; [ =C2=A0=
 39.364825] =C2=A0s8 : ff60000081300000 s9 : 0000000000000000 s10: 00000000=
00000002<br>&gt; &gt; [ =C2=A0 39.364842] =C2=A0s11: 000000092869bfdc t3 : =
2152ffffffffffc0 t4 : 00000000001fffff<br>&gt; &gt; [ =C2=A0 39.364855] =C2=
=A0t5 : ffffffffffffffff t6 : 0000000000000000<br>&gt; &gt; [ =C2=A0 39.364=
867] status: 0000000200000120 badaddr: ffffffff802079e6 cause: 000000000000=
0003<br>&gt; &gt; [ =C2=A0 39.364949] [&lt;ffffffff802079e6&gt;] is_valid_g=
up_args+0x66/0x8c<br>&gt; &gt; [ =C2=A0 39.365036] [&lt;ffffffff8020c214&gt=
;] pin_user_pages+0x38/0x78<br>&gt; &gt; [ =C2=A0 39.365049] [&lt;ffffffff8=
0278f78&gt;] gup_test_ioctl+0x2b4/0xc08<br>&gt; &gt; [ =C2=A0 39.365060] [&=
lt;ffffffff80297da6&gt;] __riscv_sys_ioctl+0xba/0xc4<br>&gt; &gt; [ =C2=A0 =
39.365072] [&lt;ffffffff80b93f96&gt;] do_trap_ecall_u+0x296/0x370<br>&gt; &=
gt; [ =C2=A0 39.365093] [&lt;ffffffff80b9ef06&gt;] handle_exception+0x146/0=
x152<br>&gt; &gt; [ =C2=A0 39.365220] ---[ end trace 0000000000000000 ]---<=
br>&gt; &gt; ok 1 ioctl status 0<br>&gt;<br>&gt; Right, gup_tests simply fo=
rward any flags we pass in. I wonder if we would<br>&gt; want to filter the=
m for ones we expect to test?<br><br>This&#39;s a good idea.<br>Perhaps nex=
t, we can take some time to select those non-inetrnal flags in &quot;mm_typ=
es. h&quot; and add them to the test.<div><br>enum {<br>=C2=A0 =C2=A0 /* ch=
eck pte is writable */<br>=C2=A0 =C2=A0 FOLL_WRITE =3D 1 &lt;&lt; 0,<br>=C2=
=A0 =C2=A0... ... ...<br>=C2=A0 =C2=A0 FOLL_HONOR_NUMA_FAULT =3D 1 &lt;&lt;=
 12,<br><br>=C2=A0 =C2=A0 /* See also internal only FOLL flags in mm/intern=
al.h */<br>};<div><br>&gt;<br>&gt;<br>&gt; I guess we should add<br>&gt;<br=
>&gt; Fixes: 0f20bba1688b (&quot;mm/gup: explicitly define and check intern=
al GUP flags, disallow FOLL_TOUCH&quot;)<br>&gt;<br>&gt; Although it&#39;s =
a bit complicated with gup_tests.<br>&gt;<br>&gt; &gt;<br>&gt; &gt; Signed-=
off-by: <a href=3D"http://peng8420.li">peng8420.li</a> &lt;<a href=3D"mailt=
o:peng8420.li@gmail.com">peng8420.li@gmail.com</a>&gt;<br>&gt; &gt; ---<br>=
&gt; &gt; =C2=A0 tools/testing/selftests/mm/gup_test.c | 22 ++++-----------=
-------<br>&gt; &gt; =C2=A0 1 file changed, 4 insertions(+), 18 deletions(-=
)<br>&gt; &gt;<br>&gt; &gt; diff --git a/tools/testing/selftests/mm/gup_tes=
t.c b/tools/testing/selftests/mm/gup_test.c<br>&gt; &gt; index 8900b840c17a=
..75f7134d529d 100644<br>&gt; &gt; --- a/tools/testing/selftests/mm/gup_tes=
t.c<br>&gt; &gt; +++ b/tools/testing/selftests/mm/gup_test.c<br>&gt; &gt; @=
@ -19,7 +19,6 @@<br>&gt; &gt; =C2=A0<br>&gt; &gt; =C2=A0 /* Just the flags =
we need, copied from mm.h: */<br>&gt; &gt; =C2=A0 #define FOLL_WRITE =C2=A0=
0x01 =C2=A0 =C2=A0/* check pte is writable */<br>&gt; &gt; -#define FOLL_TO=
UCH =C2=A0 0x02 =C2=A0 =C2=A0/* mark page accessed */<br>&gt; &gt; =C2=A0<b=
r>&gt; &gt; =C2=A0 #define GUP_TEST_FILE &quot;/sys/kernel/debug/gup_test&q=
uot;<br>&gt; &gt; =C2=A0<br>&gt; &gt; @@ -93,7 +92,7 @@ int main(int argc, =
char **argv)<br>&gt; &gt; =C2=A0 {<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 struct=
 gup_test gup =3D { 0 };<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 int filed, i, op=
t, nr_pages =3D 1, thp =3D -1, write =3D 1, nthreads =3D 1, ret;<br>&gt; &g=
t; - =C2=A0 =C2=A0 int flags =3D MAP_PRIVATE, touch =3D 0;<br>&gt; &gt; + =
=C2=A0 =C2=A0 int flags =3D MAP_PRIVATE;<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =
char *file =3D &quot;/dev/zero&quot;;<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 pth=
read_t *tid;<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 char *p;<br>&gt; &gt; @@ -17=
0,10 +169,6 @@ int main(int argc, char **argv)<br>&gt; &gt; =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case &#39;H&#39;:<br>&gt; &gt; =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 flags=
 |=3D (MAP_HUGETLB | MAP_ANONYMOUS);<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>&gt; &gt; - =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case &#39;z&#39;:<br>&gt; &gt; - =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* fa=
ult pages in gup, do not fault in userland */<br>&gt; &gt; - =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 touch =3D 1;<br>&gt=
; &gt; - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 break;<br>&gt;<br>&gt; AFAIKT, run_vmtests.sh does not set that flag, s=
o dropping it should be fine.</div><div><br></div><div><div style=3D""><spa=
n style=3D"padding:5px 0px" class=3D"gmail-">Okay.</span></div><div style=
=3D""><span style=3D"padding:5px 0px" class=3D"gmail-">Thanks for your sugg=
estion, which allowed me to start organizing the second version :)</span></=
div></div><div><br>&gt;<br>&gt; --<br>&gt; Cheers<br>&gt;<br>&gt; David</di=
v></div></div>

--0000000000002a6cab06438e9f03--

