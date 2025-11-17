Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6925ACEBF93
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 07:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8204F8E0009; Mon, 17 Nov 2025 02:05:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7A08E0002; Mon, 17 Nov 2025 02:05:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 734F28E0009; Mon, 17 Nov 2025 02:05:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F4778E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 02:05:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3C4ABDB70
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 07:05:52 +0000 (UTC)
X-FDA: 84119214144.01.928C1FC
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id 24E83160008
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 07:05:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T9EieolL;
	spf=pass (imf08.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763363151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OPUMt3q8BMrQh8jwwwEA3hTMZK9zJ3Iu0NZQEYFFIBo=;
	b=TllZIQbhqEQl0hS/Op/8OGw0txRNJVfe1upgoIVdQTJN+0b6sst3DldZVTr5Hbzx9Efd2H
	I7NBiWKuNz9CKAYTdmcyROFstCZpH3qWC6VjqJYGvBsywdSCQ79ZE8U5kPQ/7sVS1NO1/U
	LD6a+xRlRT7qeNFVkFbgFfh/v0eLEYE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T9EieolL;
	spf=pass (imf08.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763363151; a=rsa-sha256;
	cv=none;
	b=6yEOMx4aPQ6/v53nUwFcN7LgACBRxF4+0SYb1W9dD9YBhv6ECcXvePoaIv+nuzpKVcY7IQ
	Dswq17nm8iXU68BbEjrlQ8Rew37xvlp0n3L5Xz8uURqJBf4Liz3uEWmk9qfmrvLz3pgmQF
	/avW8GGibbq/CG5TnaNFjgprdnYejqo=
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-3ec46e3c65bso300107fac.0
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 23:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763363150; x=1763967950; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OPUMt3q8BMrQh8jwwwEA3hTMZK9zJ3Iu0NZQEYFFIBo=;
        b=T9EieolLuxbx0mQyxyFdeuR9AluFG7zhjlC2B9+nQ0hY0Xo+QBl7hiLDbalcrWFLHb
         08i0mAtoreO1aCVOoTK+Nt7v0dRynPL6kzoop4p+J5E8+lZX4YLsS+VWBw8Xqbzv4P1v
         A+3Gy+JyE4ntkwuRXua1IFme/ibB+BqgZCAlf+VukyGlKoyrEymtxOd6drR9BPbnUFPy
         lTwWEKzxz/YErgUEVK/j2i71nx8XPcS96piuj7HIj2OVWvct/Pc4QmlmnQ7jSXGwXSYc
         d7+pq4W5SAXAasWMLdEueNXGQ0vYmr+baHnHj1NRzH1MKSOGpQ34sz829r5jrt2R1LBI
         Okuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763363150; x=1763967950;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OPUMt3q8BMrQh8jwwwEA3hTMZK9zJ3Iu0NZQEYFFIBo=;
        b=nhkLkFtyObeb3pD67TarEv0KZDWN/G8z8V24uBipzNZGgI00pYNNkiF6sT9ThZV0qY
         N6IrWIkUankwXS9zoYmr4J0ckJdsC2HG8P7lRb4O5VzFqhI7/CkDmdU+Vg9VAvtSNvQp
         zguXsripPlQichUubBU1UBZqNFaIBQwitGIcU/wjaj3xvxzBmBed0BCIv7E8ZV1bcBYu
         9O0cF9BMez09c/BTzmp3vegMSKVms+ftxSjoMnfESqfOiNWim7hRshrQ9MEL/9AzvfVz
         5V8VZup+hsrZL8momEl9Yf7/vgtCTF3ZG5KqjCx6u+7/zilwFEoJ0OQMHEfvYJ41aT0B
         OF6g==
X-Gm-Message-State: AOJu0YzViJ/qUwUii1/SIcc8P9a9jjWrT3QzCoFj0mgVtt//qNeYgwgT
	FNqZEiBu0jQObNzRcNlX8Dwjt0lB9H+/a+vwSY0u16rTlhueAe3waodhoFJseSDJbLD8LRitvr5
	A0neCp7yCjIU9UQId8S6s/9ROXaL71O0=
X-Gm-Gg: ASbGncuOpMUBD7If6/34YmWRrPOl9//mIcc5ViVi9p2JjQxk0iffu40N0Nao8ASvvgO
	gIiJHjyjkrBJ3MdlaRsEbS64m/kbPz4Y5VvmGzf8x1waJCZxPn19SUypTwJrV4cPoZiH2NAGNvJ
	SDqBSdtQ1X+NbFWQNtvHseDdQDTTiZcfNLLYHKaBvG6SkmHjg0NpVjkimlY/0+MfVRnvqRg1dHZ
	Y4cRlkHH9NYYHIwQBJCdv+7YMntAg7OucPgU5hUvU2i2rezdQ4F9coZ2n9t9ZiblOK4P8c=
X-Google-Smtp-Source: AGHT+IH/hN36hG2qWmn12tmyRExnIn2EB0CBleeqOPDTiFzGcJcbAlBDlka/sWn1+UDvgAidI081UBTsEZW2gC5KF+8=
X-Received: by 2002:a05:6871:9e22:b0:3e7:d281:6423 with SMTP id
 586e51a60fabf-3e868fde499mr4275445fac.22.1763363150004; Sun, 16 Nov 2025
 23:05:50 -0800 (PST)
MIME-Version: 1.0
References: <20251114161127.193707-1-peng8420.li@gmail.com> <6869aee5-0093-489d-bac7-fa718bdcb362@nvidia.com>
In-Reply-To: <6869aee5-0093-489d-bac7-fa718bdcb362@nvidia.com>
From: peng li <peng8420.li@gmail.com>
Date: Mon, 17 Nov 2025 15:05:42 +0800
X-Gm-Features: AWmQ_bn9B-_niq4GAMVF8PcnSuD9fO5kftOvS4TVDZKHsSehBdRaIdZhb41_EPo
Message-ID: <CAJFsz5w=a1ZSBZaiADxyM32ucaizQiPFTm7=vC2D4W8OkSUp_w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] Remove the "FOLL_TOUCH" test code from gup_test.c.
To: John Hubbard <jhubbard@nvidia.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@redhat.com, 
	osalvador@suse.de, jgg@ziepe.ca, peterx@redhat.com, 
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 24E83160008
X-Stat-Signature: mftrc3mfu9edo994o71w17ypiijgzi1c
X-Rspam-User: 
X-HE-Tag: 1763363150-744982
X-HE-Meta: U2FsdGVkX19u+0124JfbUm7GynsTIc0LFz2Tk7kHrTDt1SaKSKj+jLxH6qfHoGtIFsE7ChNVlxE//DbIWJwlG0ZKiZ3W/0ngCpWTGunMcVsVdf0X61u0w/EglxS1kOi+aHQdANOVz2PiTbbRoSOTdOeULNFyaYePQy3X2QUYoXZ31u2bLiwPxjA3Rp9Dx/8GTQPrihiJuQIPiGdF67hGgKNLCyEx29VGewO52I2XpyV+UJyBYV5ND1DLeS7uWqzSonU01JKYT6gt9a0rEWkHlKpfkkv6Il+BZ0ObUq48ObQ9pTVvQ+tTK5+ktd3SOa6/73n6kW4bHNunUscc5DFXiHgwfPex6W6A/Zwm1g90PLDdGbmvr1x3UggJ5692S4+OL8XeGwHi5BNuVPlO40gbGqiSbkJ/El4OMXUIjFVKVeONPjxNLJlC9Zhxt3ghSsfOmkrA0Vc2tr6JsB5Q3PyFixeQOdnPbArx+y98GlcXuc+z2OTjWP+uXxhstezV9fi0Km8mo9LXvNgwcG8Coo+3Z/7gNqR0OjEGMJUbatYPs0xGoe7AVfA1G683oQtjzFhaIYePPksUXIFSi/cqAakSXAdIGJA4ghRm2ges5cnEXZE4CKgMZLozxAIMT2PFlICXuopYV3uzXWblxvnuv0izsoxcoGRjflpri+/j7PfARSasYt2LcH/6AU8MNlhyTUQEd5HFQuSCs4nECT242dM21sTyGwjj5zZDrKii8umifR0xwi9VFoZEmay/BLOrZ3LldRHGpxhnzxLCZ+HpFgaCsesvzpPvyG/OGMuNdLBsiA5E+LantDzsOF4KBKYLJSonn3D87iuo9Qa1KFFFi9OJAvwAezq7r/xzeOomp4UNpTVYITU4CX9RIme1Zu86UmaUmsnJeAQgXRDH80gzALzG3INq6CJj0p6HLvQqtPFVCx0DiyfUYlig/b2OzfEf9lBXXNC8YbSdh7+thScKIKp
 qhzDLpZa
 Wp6PN2esFZwWCx1maa0FLh9Z7cBSx4y9ltouRnimyZB8/i0BzdewGBRlPVWO4sE2e32UJekqeeuce4R+M+UT5CV+0I1U/nU40SD1gbBkB5JBmU89t9zQJWuyqpdxlZXINUGg4LAuq2romL5ScbF3SxbauDmqw4dKpUhf4supLvOd9CcnBzeuW8xcmevV85nxt81mNvVaUdbqnef6Nd/xqmfzJqUIjqylBC+LeE1Vn5zHgwbKM7ss3wiOjDTDLsPt682ZE2Lzxxo4BzNiA2BI1YMMjUV+61KMdrNOBN/+Tf57ymHMo6mLU3WFsGxtmU516yo5Dt1IYxTFwbHwQbWwceI4BVfOZGCzgeFe4VIUXkH+EUvQJq0EOOps+9jcfLP14rz7ANqQAPSJ49at6M+eQitdi/mRkykmTKhKjZEZ34yxm96WlBUk+eK1y34Oy6xdqxd6B79nw3LXxRG5KO+81c236LA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

John Hubbard <jhubbard@nvidia.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=8815=E6=
=97=A5=E5=91=A8=E5=85=AD 04:25=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi,
>
> The diffs look good, but the commit log and your replies have many minor
> issues that add up. So you'll want to avoid them in the future, and with
> that in mind, I've listed all of them, along with suggested alternatives.
>
> On 11/14/25 8:11 AM, peng8420.li@gmail.com wrote:
> > From: "peng8420.li" <peng8420.li@gmail.com>
>
> This should be your real name, such as (my first guess)
> "Peng Li" <peng8420.li@gmail.com>.
>
> Also, if you are sending from the same email address as your "From:",
> then the "From:" item shouldn't normally show up (it's harmless here,
> but could be cleaner without it). Check your .gitconfig send-email
> options and you can make it go away.
>
> Also, when replying, your email client is apparently using HTML, please
> fix it to use text only!
>
> Please read the patch submitter guidelines, too:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/process/submitting-patches.rst
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/process/submit-checklist.rst
>
> > Ever since commit 0f20bba1688b ("mm/gup: explicitly define and check
> > internal GUP flags, disallow FOLL_TOUCH") we marked FOLL_TOUCH as a GUP=
-internal flag.
>
> Not "ever since", but simply:
>
> commit 0f20bba1688b ("mm/gup: explicitly define and check internal GUP
> flags, disallow FOLL_TOUCH") marked FOLL_TOUCH as a GUP-internal flag.
>
> Also, it's best to keep the line length within about 72 columns for
> commit messages.
>
> >
> > Therefore, remove the "FOLL_TOUCH" test code from gup_test.c;
>
> Trailing semicolon. Should be a period.
>
> >
> > Otherwise, executing the test command "./gup_test -L -r 100 -z" will re=
port the following warning log:
> > TAP version 13
> > 1..1
> > ENCHMARK: Time: [   39.363371] WARNING: CPU: 1 PID: 117 at mm/gup.c:251=
2 is_valid_gup_args+0x66/0x8c
> > get:2818 put:46 [   39.364043] Modules linked in:
> > us# , truncated [   39.364311] CPU: 1 UID: 0 PID: 117 Comm: gup_test No=
t tainted 6.18.0-rc5-00324-gd09eaf415c87 #29 NONE
> > (size: 0)#
> > [   39.364434] Hardware name: riscv-virtio,qemu (DT)
> > [   39.364546] epc : is_valid_gup_args+0x66/0x8c
> > [   39.364596]  ra : pin_user_pages+0x38/0x78
> > [   39.364630] epc : ffffffff802079e6 ra : ffffffff8020c214 sp : ff2000=
000041bd20
> > [   39.364650]  gp : ffffffff81a26068 tp : ff60000080b3b000 t0 : ff2000=
000041bdf8
> > [   39.364678]  t1 : 000000000000001e t2 : 0000000000000000 s0 : ff2000=
000041bd30
> > [   39.364697]  s1 : ff60000081300000 a0 : ff60000081300000 a1 : 000000=
0000000000
> > [   39.364714]  a2 : ff2000000041bd3c a3 : 0000000000080000 a4 : 000000=
0000000001
> > [   39.364731]  a5 : 0000000000010101 a6 : 0000000000000001 a7 : 000000=
0000000000
> > [   39.364747]  s2 : 00007fff7eeed000 s3 : 0000000000000001 s4 : 00007f=
ff7eeee000
> > [   39.364761]  s5 : 00007fff7eeeb838 s6 : 0000000000000000 s7 : 00007f=
ff7eeed000
> > [   39.364825]  s8 : ff60000081300000 s9 : 0000000000000000 s10: 000000=
0000000002
> > [   39.364842]  s11: 000000092869bfdc t3 : 2152ffffffffffc0 t4 : 000000=
00001fffff
> > [   39.364855]  t5 : ffffffffffffffff t6 : 0000000000000000
> > [   39.364867] status: 0000000200000120 badaddr: ffffffff802079e6 cause=
: 0000000000000003
> > [   39.364949] [<ffffffff802079e6>] is_valid_gup_args+0x66/0x8c
> > [   39.365036] [<ffffffff8020c214>] pin_user_pages+0x38/0x78
> > [   39.365049] [<ffffffff80278f78>] gup_test_ioctl+0x2b4/0xc08
> > [   39.365060] [<ffffffff80297da6>] __riscv_sys_ioctl+0xba/0xc4
> > [   39.365072] [<ffffffff80b93f96>] do_trap_ecall_u+0x296/0x370
> > [   39.365093] [<ffffffff80b9ef06>] handle_exception+0x146/0x152
> > [   39.365220] ---[ end trace 0000000000000000 ]---
> >
>
> We don't need all of this output for such a simple case. Just the
> warning will suffice, and even that is optional for this patch.
>
>
> > Signed-off-by: peng8420.li <peng8420.li@gmail.com>
>
> Same rules for the Signed-off-by: real name needed here.
>
> Combining all of that, your commit message would look like this:
>
>
> From: "Peng Li" <peng8420.li@gmail.com>
>
> commit 0f20bba1688b ("mm/gup: explicitly define and check internal GUP
> flags, disallow FOLL_TOUCH") marked FOLL_TOUCH as a GUP-internal flag.
>
> This causes a warning to fire when running gup_test, for example:
>
>     $ ./gup_test -L -r 100 -z
>
> dmesg:
>     WARNING: CPU: 1 PID: 117 at mm/gup.c:2512 is_valid_gup_args+0x66/0x8c
>
> Therefore, remove the "FOLL_TOUCH" test code from gup_test.c.
>
> Signed-off-by: Peng Li <peng8420.li@gmail.com>
>
> With the commit log fixed up, please feel free to add:
>
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
>
>
> thanks,
> --
> John Hubbard
>
> > ---
> >  tools/testing/selftests/mm/gup_test.c | 22 ++++------------------
> >  1 file changed, 4 insertions(+), 18 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/self=
tests/mm/gup_test.c
> > index 8900b840c17a..75f7134d529d 100644
> > --- a/tools/testing/selftests/mm/gup_test.c
> > +++ b/tools/testing/selftests/mm/gup_test.c
> > @@ -19,7 +19,6 @@
> >
> >  /* Just the flags we need, copied from mm.h: */
> >  #define FOLL_WRITE   0x01    /* check pte is writable */
> > -#define FOLL_TOUCH   0x02    /* mark page accessed */
> >
> >  #define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
> >
> > @@ -93,7 +92,7 @@ int main(int argc, char **argv)
> >  {
> >       struct gup_test gup =3D { 0 };
> >       int filed, i, opt, nr_pages =3D 1, thp =3D -1, write =3D 1, nthre=
ads =3D 1, ret;
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
> >               default:
> >                       ksft_exit_fail_msg("Wrong argument\n");
> >               }
> > @@ -244,18 +239,9 @@ int main(int argc, char **argv)
> >       else if (thp =3D=3D 0)
> >               madvise(p, size, MADV_NOHUGEPAGE);
> >
> > -     /*
> > -      * FOLL_TOUCH, in gup_test, is used as an either/or case: either
> > -      * fault pages in from the kernel via FOLL_TOUCH, or fault them
> > -      * in here, from user space. This allows comparison of performanc=
e
> > -      * between those two cases.
> > -      */
> > -     if (touch) {
> > -             gup.gup_flags |=3D FOLL_TOUCH;
> > -     } else {
> > -             for (; (unsigned long)p < gup.addr + size; p +=3D psize()=
)
> > -                     p[0] =3D 0;
> > -     }
> > +     /* Fault them in here, from user space. */
> > +     for (; (unsigned long)p < gup.addr + size; p +=3D psize())
> > +             p[0] =3D 0;
> >
> >       tid =3D malloc(sizeof(pthread_t) * nthreads);
> >       assert(tid);
>
>

Hi John Hubbard,

Your review suggestions were very helpful.
Please understand that I'm new here. Thank you so much!



Thanks & Cheers!

