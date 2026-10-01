Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A34D1CA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 21:47:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FDD16B0088; Thu,  1 Oct 2026 17:47:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AECA6B008A; Thu,  1 Oct 2026 17:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79DCB6B008C; Thu,  1 Oct 2026 17:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 535576B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 17:47:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D2FBD1C342A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:47:01 +0000 (UTC)
X-FDA: 85275393042.24.B42A22F
Received: from mail-oi2-f42.google.com (mail-oi2-f42.google.com [74.125.231.234])
	by imf04.hostedemail.com (Postfix) with ESMTP id E8B4C40006
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:46:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZgiA0gPp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of jthoughton@google.com designates 74.125.231.234 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790891219;
	b=B96rfXLmUHWq9t8AqcFg14WBt6UOMTpYlsyKakYA+Ea7eA4+B2gMuEz8wM/CDD9rNL8PsM
	wvQayHcO48U/WVQ0ZhmPgN7fEw0EeGmMKuJ0zJCr8f4+2VCL/ZdZT7r33w530GI6Ed3yPd
	63cnIBjJGkhslMuE+i6V2nNv/KIMMx4=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZgiA0gPp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of jthoughton@google.com designates 74.125.231.234 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790891219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ocYmniOwpUzQLzkBfUho2DWqpF1xLeQVvVLKNcyGJSs=;
	b=jygbQXW3OX39eogLkj8np+hyfcu+CAd5gTWSYI0D42MHAm0JfUnN48oamhX1nMVEL2BLJa
	HNTY2J3zRkvyA8rxd9IO9UbV0VNFk9NfoXqC1zlS4tYpYoBuggiLluatilao10LwN2Qnml
	Ir45YkaG/omPBTJA96G1UXg2PMPc/m8=
Received: by mail-oi2-f42.google.com with SMTP id 5614622812f47-4e7d54b1ccdso3211190b6e.0
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 14:46:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790891219; cv=none;
        d=google.com; s=arc-20260327;
        b=mp6+krCNqSy3RmgXW/5CMIFCtQ0YNm3aft+7jMHi0tRa+1s8PbkKFuhkP22vHpMm+9
         oanjXt7BL/YhqhbSxxDEY5esUiCBCEjZ6MG/Rk6DjUZcBPwHqq1KwNGr2aHA/+2Fz2uF
         q78E1dqsGyakus9lqwB5hV4+UTpmZA+U19q3u3BpYORV3SdCJbd7tatpICx28bpA6isb
         JM5jXUpfiw1/JoFBxq7RJDPy9/OPabnEbHPnb3nr7J+NwKR/gaoT7ijywlZq8YICH/1g
         8Hgk7ZGkK2dUqd8B1AtN7RNPZm8SfAswrCLZeOcw1mG5Z9JPAcrTAQjO0Ue+mNPciC9p
         L7mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ocYmniOwpUzQLzkBfUho2DWqpF1xLeQVvVLKNcyGJSs=;
        fh=OOlDVZEdWI3fo9lTVV/Uv+wKBSoZH0Yv9W2e28vz7Zc=;
        b=SE5qS8RbciLvBTPl2m1IVuhEOhzPlWUmtTa/c03r6Tez1VtgGH6f44a3mjA+iGinkN
         KcXFtYrzgZ96yQwdhsEspHe0Tj0COR1LwSVHiJbTmn3scS4p/1cvTH/0nRk1Y3fFBQLJ
         qQaPZ5vNZgNOdBtW1yTJGlVak9tjQcnU7+hCFEBwCNwileCq1oFUihnJpV6hUJHV3Lzb
         eMgzEAQL508MYgIGhavp0AIST7L5TaWef2uEWFQKuy7+r+E/TzA0phSFYUWSHADHiU1j
         dszV7R26lMdAbPe7IzR93nk7T/fAkKw5tgS5+S1VMLw5p7kBijEbA0jthe/SqkFweEnJ
         1GZQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790891219; x=1791496019; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ocYmniOwpUzQLzkBfUho2DWqpF1xLeQVvVLKNcyGJSs=;
        b=ZgiA0gPpT5MHgq3J5suaT63DXfQT+DYgFHdIf7NC7XgtNvHtw+GPeuZ5d3+jadyAHZ
         f8R2h58l4KU0wfC0dvcoYsz5H2nhEvJwcJFoKy6mlnFsK843lLTe9USjTTW1Nrn0VYjF
         w8XFPDKjz/5T/lyPw12OlDEm7enCg8tDRknBr/cNKOA1ceFoCp8KEa3tO24MgbW7Uulb
         Uqx6HHpqeVtTZwiSX2sgjT8kItNMyaLavwapmOfyTnNv73NkqIIIzej3HhN33/zJh+H4
         qeT4RYDtDaj0fHtWYpw9KkybrZ1arvStg9EsN3RGFFIJWMRs+OuTs2Pz/WhA42aB7gRi
         Y0mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790891219; x=1791496019;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ocYmniOwpUzQLzkBfUho2DWqpF1xLeQVvVLKNcyGJSs=;
        b=Z6aNT4eE6DIAZBPOVc5A6MEY2FkJci/9mUKojXqEHCjf1LM4YnuHXsdeT7rPxq+NpV
         0ULQMP6vess3DB5F0QzcFSYo8TrZQ7nYjKrmOqtbIvI7QsvMmthjcZMSUXLNhE+U7mHM
         oPGWNc2zX50sz/c2TSfHVtutFIr1uO0ACuKJcUdV4qTlBt2/YNKTgUVAT/lZkOedIYW9
         kt2VkGYyM+oGMnwAXNxwZoZMwebgcxGg6ioaC3Zx+tReH88R+Jcaj/ii3DR5pFb0tLBt
         zwKoEY+uAAs+FlqRc3m9OcClF1JNoHr/G9RajsKi8KowbU7zLWBecwg4WOTbcyWdU1RL
         lJyw==
X-Forwarded-Encrypted: i=1; AKwUvBxyYBM2Zihd9ULuEuhhn8e5f93us3ZeeXERuAGnU3KIzrZb5UFFe/M7o5ZeE/KoMK9mX725Y/x/YQ==@kvack.org
X-Gm-Message-State: AFuF++nJ8fgS2GpTWHfPh5H4xg86obmOi2YmniZ03nwi+CmdlpeAk3AQ
	JfnBE2mltYg33/g1RxjcgXQHyiyPydFTc8QqKDk6o4oA1OuGIYJ6E1dpkWhNzhDXvioehWWSbs3
	ATeGc9OtutypzKKKJ/gnpM9Om4CVycO1BhGc26p95
X-Gm-Gg: AYBFou0nkB3FIZTFfiCDLVKta/B/3XErbcad/81D8AMqv8C5hgZBJxG1eZTCbkdzOMW
	O5BTQic4p4Eun7RcvXRshyzx6qwqYA95BO4e5nZXs82ka7NmiiveVrTLfvrSLFHQIdpLKNGyBgk
	9SeCvbBKv55gBVPyUM4a2pa7oGnNOgtfmh0y4fGDgJIePZArD8Fy8oFuJiWebN12Ig2xAhs8vhc
	MraGbKjV1jUPB1d0+io/PrUg4yCyiJdVKZPAXOCx5cm+IbP1CXMPylgkiCmFwoWECM86tkbvBTr
	jxSyozECO5+sBexSllM51eGBjJqDkwoO63aGvm/MzdP7w5oTd3co495enOJlk72nVEu9xI72coR
	LlZOJ43gWv9Fasqy29MrXNZGqkIDPUV34LVQQ3Cm4psQpqxGv+jjMOCqXEIPg5cZvicAhoQyB0H
	WgljmsBwpcWn9ZuMiOxfw+y73k7Mwb2L6D
X-Received: by 2002:a05:6808:6801:b0:4c2:13aa:fa13 with SMTP id
 5614622812f47-4f526a4c766mr560451b6e.1.1790891218159; Thu, 01 Oct 2026
 14:46:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260910023411.514987-1-jthoughton@google.com>
 <20260910023411.514987-2-jthoughton@google.com> <4de1dfb3-b349-4916-9fe0-6b9697583ac7@kernel.org>
In-Reply-To: <4de1dfb3-b349-4916-9fe0-6b9697583ac7@kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Thu, 1 Oct 2026 14:46:19 -0700
X-Gm-Features: AclHuK98r7ykwb9PPu4rvO8bCfnoLUsj40t9KEUmqr0UOwQY_g67sQ82-mtG4fE
Message-ID: <CADrL8HVyhedf3PFCbfdh6KPk_wJjT4+aa8180t75xSMwvo2B=A@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm: selftests: Adjust the MADV_COLLAPSE uffd-minor selftests
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, liam@infradead.org, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Yang Shi <shy828301@gmail.com>, zokeefe@google.com, 
	hughd@google.com, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: ezeb64ymghgyucda9cb7wa6ww4xud88h
X-Rspam-User: 
X-Rspamd-Queue-Id: E8B4C40006
X-HE-Tag: 1790891219-460938
X-HE-Meta: U2FsdGVkX1/t5lw6B2nnKEFDocBBqxHeIuCojpTlVQLwnzsKMvKskS2PO8i988OFI4pKuScIVxceNkBg+yj9kogO83vVRhzkfmg0/oqy4L89V/0J6J7CTAolErHgyhU5agZW+uZlb1MjlX1Jd1XIpDRl7xmVwWJPkTI/2jREXiAhqN6xsHM8NqDqZy67DK1PnCCT9KQXazkpWlaOWIIWEV9BFMX0PpwBEYNNTrYS83nlLYbBYSNhxgFlHeJSTId48itcy8Plef5Zhz0UP7c1h/Zw5MbXeUPTNTlu7HWUUMEVZ3+feElP3I1GkdlQ1r51C9j7Cc9ln7WU51c5MfwoY1ZvfObyxoMrL591s/HhZMdWmTQ10Lw36P2lWEwSLmBMPeWOiFFzCOQgSC/GeVFAEVRQ+ys/FE5roOIT79e1lPLHbeoPO1owWM8SXQd8SfsEZzUu4UKGIXsFyRlSNOJkRA1tDO9Glb9R/SC0FO9lnUOMUXpzCMcDsL3+jsPb4qvdLx7EnuCluPsVjtD+y9o9yu5jn/e+OvChCSRCRZrm6CBXaH4uD6KENgaYG5WKOfl0NP8+BzG8TqHVDJsMhRhSokDqPwYE9CVP5NSokLJp4DXUVTuIjDKXE5mNAwxzOPz0KjJRlroNdWOyQf8kl10AawTZzypQIUjy4ZIKltiwyUjYwnf1iU+zih/o5m9xjsP0B1sRe36lBda8E8qPu9+uPtMavMXzBLR59+WsUqtBj73+HMwV4/gl03AJURf5/54pQe8Afoai9LTYcfXu5X5mNXsnAJXvRIjuldUmngQYQnEIEMXN0D4vIiktjpO5MBcMiQQtjQmbhKfq4r6g494VXJ8G8q10ZclqDNm+Kcf1ZDbNPGJPkEag4qrmrG48id77oKle6P0Dn5LXl18M/wrEGKqzdcqqykN69J8q+2p5N4HgyL9YCUc+N7faeKC6p1zz58mPvOQtjYkD8JAR/ia
 oi/83M2h
 OrxvUa6S+yb3+CLqU49VGloNZLqJDcDaiVXmv39dEgcWNjE1Xfwtbe7Y/OXqENRNgWZcUPT5To1JVkHffOxYOHtLAgMejnQM8zU3JNHiLouoHSNqDqinSHwiA2pwGueByukEnsxBUSl9jqFFPsYkSQz2w7d5zl3vRkYTsZtm0eaK66B8Wj/xp1L37A4RPzc8uryqvoheiqN2398mw2aJQDwgKibYykg+NoJSayBm9j5mflC6w4Qo6OoM6rEDkYDKwDTYXdR8H2hPizUNVCTZu9BrGypQwe/2nR7Yary4tVSc7/FnkcNG86/ZEGTpFKhay5gdGHMcsUM1SxeI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 12:00=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/10/26 04:34, James Houghton wrote:
> > The behavior of MADV_COLLAPSE with uffd-minor VMAs has changed:
> > MADV_COLLAPSE will no longer install PTEs where none existed before.
>
> Misleading: MADV_COLLAPSE installed a PMD not PTEs?

Yeah, that's fair. I've updated it to this:

  The behavior of MADV_COLLAPSE with uffd-minor VMAs has changed.
  Previously, MADV_COLLAPSE would install PMDs in parts of a VMA where
  PTEs may be missing, essentially suppressing userfaultfd minor faults.
  Now, MADV_COLLAPSE returns -EINVAL for uffd-minor VMAs. Update the
  selftest to demonstrate this new behavior.

>
> > Update the selftest to demonstrate this new behavior.
> >
> > On an unpatched kernel, the test will hit "unexpected memory contents
> > after collapse".
> >
> > If the selftest is left unpatched but the kernel is patched, the
> > selftest will SKIP when it gets EINVAL back from MADV_COLLAPSE.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >  tools/testing/selftests/mm/uffd-unit-tests.c | 75 ++++++++++++++++++--
> >  1 file changed, 68 insertions(+), 7 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testi=
ng/selftests/mm/uffd-unit-tests.c
> > index ef9b3956bdcf..6f2360f9b75d 100644
> > --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> > +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> > @@ -518,19 +518,34 @@ static void uffd_wp_fork_pin_with_event_test(uffd=
_global_test_opts_t *gopts, uff
> >       uffd_wp_fork_pin_test_common(gopts, args, true);
> >  }
> >
> > -static void check_memory_contents(uffd_global_test_opts_t *gopts, char=
 *p)
> > +static int __check_memory_contents(unsigned long offset,
> > +                                unsigned long nr_pages,
> > +                                uffd_global_test_opts_t *gopts,
> > +                                char *p)
>
> Two tabs look better ;)

Fixed (I think).

>
> >  {
> >       unsigned long i, j;
> >       uint8_t expected_byte;
> >
> > -     for (i =3D 0; i < gopts->nr_pages; ++i) {
> > +     if (nr_pages + offset < nr_pages)
> > +             err("overflow in memory check");
> > +     if (nr_pages + offset > gopts->nr_pages)
> > +             err("out of bounds memory check");
> > +
> > +     for (i =3D offset; i < offset + nr_pages; ++i) {
> >               expected_byte =3D ~((uint8_t)(i % ((uint8_t)-1)));
> >               for (j =3D 0; j < gopts->page_size; j++) {
> >                       uint8_t v =3D *(uint8_t *)(p + (i * gopts->page_s=
ize) + j);
> >                       if (v !=3D expected_byte)
> > -                             err("unexpected page contents");
> > +                             return 1;
> >               }
> >       }
> > +
> > +     return 0;
> > +}
> > +
> > +static int check_memory_contents(uffd_global_test_opts_t *gopts, char =
*p)
> > +{
> > +     return __check_memory_contents(0, gopts->nr_pages, gopts, p);
> >  }
> >
> >  static void uffd_minor_test_common(uffd_global_test_opts_t *gopts, boo=
l test_collapse, bool test_wp)
> > @@ -539,6 +554,8 @@ static void uffd_minor_test_common(uffd_global_test=
_opts_t *gopts, bool test_col
> >       pthread_t uffd_mon;
> >       char c =3D '\0';
> >       struct uffd_args args =3D { 0 };
> > +     unsigned long checked =3D 0;
> > +     bool bad_contents;
>
> Through in an empty line. Or better
>
> struct uffd_args args =3D { .gopts =3D gopts };

Done. Thanks.

> >
> >       /*
> > @@ -564,24 +581,65 @@ static void uffd_minor_test_common(uffd_global_te=
st_opts_t *gopts, bool test_col
> >       if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
> >               err("uffd_poll_thread create");
> >
> > +     if (test_collapse) {
> > +             /*
> > +              * Read just a single page and try collapsing. The collap=
se
> > +              * should either be rejected or be a no-op.
> > +              */
> > +             if (__check_memory_contents(0, 1, gopts, gopts->area_dst_=
alias))
> > +                     err("unexpected memory contents before collapse")=
;
> > +
> > +             /* MADV_COLLAPSE might return EINVAL for uffd-minor VMAs.=
 */
> > +             madvise(gopts->area_dst_alias, gopts->nr_pages * gopts->p=
age_size,
> > +                     MADV_COLLAPSE);
>
> Add an explicit check for expected errnos?

Done (just EINVAL).

>
> > +             /*
> > +              * If the above collapse mapped pages that were not expli=
citly
> > +              * CONTINUE'd, the below __check_memory_contents() will n=
ot
> > +              * fault on some pages, resulting in incorrect contents. =
The
> > +              * PTE for the first page may get retracted, so avoid che=
cking
> > +              * that page, as we might take a second fault, flipping t=
he
> > +              * contents a second time.
> > +              */
> > +             checked =3D 1;
>
> I'm not an expert on this code. But a trivial check to see whether there =
is
> something in the page tables that shouldn't be there is through the help =
of
> pagemap_is_populated().
>
> Maybe that would help to simplify things, not sure.

I've reworded the explanation here. I think it's better just to have
this `checked` stuff rather than checking `pagemap_is_populated()`.
Either way, we need to conditionally skip checking the first page,
that's the real annoyance.

New explanation/comment:

  If the above collapse mapped pages that were not explicitly
  CONTINUE'd, the below __check_memory_contents() will not
  fault on some pages, resulting in incorrect contents.

  In the correct case, when MADV_COLLAPSE doesn't map pages
  that were not mapped before, it may still retract existing
  PTEs for the region. Reaccesses to previously userfault'ed
  pages will trigger a *second* userfault and flip the
  contents again, which appears as a missed userfault. Ignore
  the page we already accessed to avoid this.

