Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6579FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 09:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 493E06B008C; Tue, 28 Apr 2026 05:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B506B0092; Tue, 28 Apr 2026 05:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 383206B0093; Tue, 28 Apr 2026 05:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 231816B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:52:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B1D371C0967
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:52:40 +0000 (UTC)
X-FDA: 84707500080.02.D167E02
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id AED1740007
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:52:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=enWAr+FD;
	spf=pass (imf27.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777369958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0CkJoR8j2Lu8d3HAduK0D/uOBhQpU/AO08sHTN+Z2A=;
	b=cqEmEQcRa1ioPEGdvf8x2JUL96tk6SrBNj+/LO7iMofu8FzwxeMI+cjehXMVDfcxg2nadV
	ZVoCXYfBO4aUclDcrDw8rvdPKJBVo6htAx3hAQnM3PW/tpwLDqYhoFjdRIBOLdhDD8ASzG
	xWjsHT5rqyRoYayNpGxvWSPnaZUS0hk=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=enWAr+FD;
	spf=pass (imf27.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777369958; a=rsa-sha256;
	cv=pass;
	b=VGryDUMhPd+KE9c7271Aw/94yK8wiiZRIB/xKYZ57mEEx1zq7kEKTJbtJ/U4NYjQ6MgTPb
	4mnFPsANvF0c5qg8hS4CPu9+aN13OBqTYHocCfv0/hPCTG6WmENyrlnvTY1iQQabZ9nMSL
	OMOQ3DHkdr8dTmgrlJflHPEm8lypP+g=
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-610aadb2d9fso3620473137.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:52:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777369958; cv=none;
        d=google.com; s=arc-20240605;
        b=Xv6+53v9nSRRqobAReulntYmYGLsdi+kywYgvM6bWEeQ1AwhOFJB8YOz53uRjTU1Cb
         mA/PhE5oSYlNpiHtVXuZf3oC77wtgjsMxvyFx4NfabUnWb5ZzVuPI8rLIWfvSwu+Z2x3
         7kxv6QC98lTzGMPKLUUsLwNzhsVU2/5NtQJomz++YDsDArFAm8I8z7mjGv2gedXogl++
         q6x4fXAeLAOmN3T+2fXwC4A4w/JBzb4D2mUzqnwgvlqaUlVj4t8ZwIjzSuUK3qJ/t4it
         QS527ToXvVhZOYe2zYswbgZul/b0kbutr/Rp56e8X9bfW7oZ1xypGjVkBL4Bej1w6uP4
         d0mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=d0CkJoR8j2Lu8d3HAduK0D/uOBhQpU/AO08sHTN+Z2A=;
        fh=1NmyW8LL0fSZsa6nDnyNcHjDy8fOH/Wiknx++/6ZtvA=;
        b=WIpIkSKVtmr/7OK9yfgZJ7jE9UmIvr7EpjQ0Xe8MUrnOcurv6WTrysRVatejS7Sox2
         5uRpNQg2vGJMjvlufYeW057Y1vN4b3siCtoVOHSr2BHvUkBTvUxqq8AdhHJdvICsgMEU
         ypHnN0g8y5WthQBLR4/CnMTEve7z2+p5rCDlkhwICBHinyN60jtyCb6PopTGZ6QZiUsr
         dKBKee6l4j5fbagdbgGtF72ox6xmz/rFY/zr++XUK67ZGxmi2GkvRO3+g/vYIBjPk/E2
         CH0hJACk4xwGnHyh41SuBv2BlLIHdZlZBUApPxenEIESl7dwQN/XmG9esiC3y7gEinQF
         Rpfg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777369958; x=1777974758; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=d0CkJoR8j2Lu8d3HAduK0D/uOBhQpU/AO08sHTN+Z2A=;
        b=enWAr+FDW85wFy20StUJxqoffYb7DcFU1bfsEpv8HOnYhLVd8xbZbNTThCxSl8VGHA
         W5v37i+ogojgxgGCoV5zXJaTUN0LKJYYT+Kb/DnzddLeXgut5Vu6kp2OzVSMqTA1vaN4
         8ZFeYno8vCJn+aqbi0mP5ivTgJNR3YjwSYe4JBbLK54VUIdPMmRFUhK+3Es0NOfv0a6y
         XYU0zJh1SgEVHCkmfLZ+r66JRdVQu6KZws2fkUrBV+RdgEAW1qk+aKZKvl1B4LgqnVtp
         MPHGYPbTpQW1i2EvfTurgAerMzyzjCKKryKweE7/8D5oWqwrjqZrraDh6QuuxL7t7avA
         Z1rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777369958; x=1777974758;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d0CkJoR8j2Lu8d3HAduK0D/uOBhQpU/AO08sHTN+Z2A=;
        b=UZAlJ/pCj3GGXD3HQBwPuLpFSJTGsb0EL7EbTtNEGLr42COBJ64rGYGj5grrTwoYdr
         k4s26RxfMZzAQSPm/MFmp+F8T1qzGieIB+htqMzT99pWaUv6tUJ3V5KX/t5hE0/MVB9X
         C+OPw0wGOJ6CZplPmnKiF4KQz/sG7S6tkJ+zc0sSF6myX6DgJPwDTUHkyR8LHtW1T6Wa
         KENDIMt8gW3qxgYf+0XUnYp58XFd5BxsQS32Jpwre/Fu8LNaPR/olTWuuMQLFsMl8YSB
         gjfGhJilKPeZgdse1sMsfcQXFLxzFdvxALsinp6sodDWSHRyrhSw1gNCE1OzZfEawx5C
         kxOQ==
X-Forwarded-Encrypted: i=1; AFNElJ8d+TPbdD63LE5CkigPgaUkoO5LiaIm3rS18SEA/x59e4MRBIbTucwVbi7SoadReszTBCP1U83sQw==@kvack.org
X-Gm-Message-State: AOJu0Yw0KWixEH2VAB78mKg/jiW3e+rhnM4pHmRmuWEhjpAsF1qgWZNm
	jP4NFuczBmcLwvZByUKq1LyRF3Pa6GXK82Cv/Z+qogmKESK4cJkAHEGoOe9Lw0z97pTHoxAXH8t
	j1OmTzV9P8lljH9h+QlXn/SCgHheWb3c=
X-Gm-Gg: AeBDieszAES2ipoldhx4vvJPs5il8NUq4J5mn6z45kohZjPK40dNukmRXhX7Qx4yz5f
	jwKhETNZHVoRNALjOf2sOlDiN8cVRcry8rB2TH8xIe9PsEq1WoLgO8XgOABy/Jo9ai5k4CFEMAy
	vUXOSyFBQ+eDPAbRW2if0rovGqlEUzDGFsfskVa+9UcPaMDz9KGzMY5cDtyrJ0hySZ54boN7lCo
	zaW8+skd5zsfgRC8XhGdF0Yyg1bi1BVVm1VSvnBClqfXUqXp+msodP0bOecTX1ZxrqKG0iAX8bR
	5Ac+aZK7lqPb5Bf2mkVY2AXLg/v7L92PWD6ul9v7n+jOMA7H303B
X-Received: by 2002:a05:6102:1609:b0:60f:7499:9b6b with SMTP id
 ada2fe7eead31-6280bce0851mr590844137.29.1777369957596; Tue, 28 Apr 2026
 02:52:37 -0700 (PDT)
MIME-Version: 1.0
References: <3abf09d8-a98e-4f1b-b8d9-77879a8a2733@kernel.org>
 <20260428094356.60415-1-agarwal.vineet2006@gmail.com> <548dc617-ca19-45f6-852f-adebcf8d3a11@kernel.org>
In-Reply-To: <548dc617-ca19-45f6-852f-adebcf8d3a11@kernel.org>
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Date: Tue, 28 Apr 2026 15:22:26 +0530
X-Gm-Features: AVHnY4Ilq5PoEdZ0E15H1DyT0sO1YYnrXAYSWnfOq_ccLN9PWDcDTH_ZLW37Jtc
Message-ID: <CA+rjy8dFQiqwiGT3Aa-=-ZaHDzeT_87ohEb7ti=Z-DxX2FvTPw@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/mm: khugepaged: initialize file contents via mmap
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, shuah@kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000f4fff0065082300f"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AED1740007
X-Stat-Signature: a47z4o49pngbo3xu44bmr1ndt71b1a4o
X-HE-Tag: 1777369958-628963
X-HE-Meta: U2FsdGVkX18jqNI0CFbCaaGtEAl/VhmsFcQ2I7OJtFR6MGuNg7tktE7H2Q+CuLrkK16eQHuSlhq3SXNblbDk7ySqTrc/br/2R1fjVdiU2pd8YZ5OCbpmGifed6pO1FXm09VPuBpRw40Y4xKoAdygevgwwEEXl1lcdMH7K9Jq7ThByK7UxUNgcWmpGBqQB6DpvK0TrwE0696+Gg56HC2i0BdHJPamu0EVAWwBUnppdz2w4Mn0zZ/65svC3tsrPR8yGIwk7EM2zKF4UrkPFJqQY2hX4whoVKlLC/ell7DEHJ3lc2Hlc7gKfkbluFrKQsNDY/oJacFViurh/5AmKvQ0AVDQ1Uf5FYTLEFTtH6DmO3fMrqCFyx2GHcbOgyH7pgCMGfUT4YIxYLxo40RtS6o8VCIBsFFRvCSr6b3pyzSBfxGTSC8gMshZVVrtl2Bq+AMKqahV5D3pp4G8NxUBgiLzUXTKn3wPqgJnr7+VPFukFB3BPjZeFgDB6XKMBtfIDklXCZsFvZZtwgoVSUue83HEDC+euxECFf+pPazuNRUXLFKdPAJZnIidzfB3X1RbKYsKAfxMw1o2vYzB9yGhiaGa93VUj++nceMPKoTvHqQWleEDH/BNFJWjotv6wt5ucDLr57YGCWIYqdziGhJpPI9ZfT51jmDc1G2N4OHkAa4VXplBQrTGgrQx83yOHRSxGQ6hxOuzSQVoZ2bHS6m3bb3vX5YCN/7LVt8/86VraUVMhqfkdTTdafpCPnf0yU1EMo8rc/DMygxe+WGm4uogIEeWK3OkqomZQEhoMZdu3q9V28XHBkrkOr78GLz4fVz5FoyOHeJC27Fi806PLtB6sSiLepxifiJRtFOhz6zYP6Y256NzTkLGr8/rmBcLmQQJT12yfzv/3ULEHj/lmTzqyca5VYXjqh083hBRCMpLSMTLHeFQ4HVs08U5kRgbEavSOj+8fHGDP2ytnIoY88UrEVr
 cQAPVJ1D
 70NJXeQx2Ehrks0MdEdDl679bqvgZ7JvywQaZCpVfJ+lhOh1k5ftcCFYH5v3/AHVf69acGf+9xC5EJkhIIshOAshBV4soPo2iVI0XJ/vG6NGZX2z+LDiG82UU1/kabB9kvEDwwLLCjJbR0je8fxKC3HHoDMnrn3BEvGt3gSnffHqTHWj10vFT6iLuw/9MhpqfqZW23miV9cSo3gp9MVFN+S5zMg0nee3i2e6PAi1wEECgEDSFhtzTTrn80svHJcrA+fJ32yaOJC+DwmOtwMwKkBuBksB2ql+NqQwfN+j7WrApDmo6DTZaNoBoQLx7xLiiMTZTpMCktRAE0t7kuC3wqKJCxh6D9r6j5t6b9au/fCpCIbgDigsOWB8LaYfHKfoV1M7W2TiT2FPNJwLVIAUDNUa5oFgRs/gjB+NnAAYw4/AKntc21Bx1O0QkcObR9b7F2XaLSM6ocVOsj9dgs/tujh1S+cMCmB3EXYDcWukU5Vja/IYQs6m5gYRJQUvuZ3i/GZfhy0NuIDlAVjdNk42YRYjzA8q0vr/yQHI/mo8oqFJ+uVYqb4HdNKnrfL/VRS1exSlugxF8VRH8o3w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000f4fff0065082300f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

ftruncate() is needed before mmap(), since the file is created with
O_TRUNC and initially has size 0. Without resizing it first, mapping
and accessing the full range can go beyond EOF.

You are right about msync() though =E2=80=94 since all pages are written
through the shared mapping and the test later drops page cache
explicitly, an explicit msync() is unnecessary here.

I'll remove msync() and send a v3.

Thanks,
Vineet




On Tue, 28 Apr 2026 at 15:16, David Hildenbrand (Arm) <david@kernel.org>
wrote:

> On 4/28/26 11:43, Vineet Agarwal wrote:
> > file_setup_area() currently allocates anonymous memory, fills it,
> > and writes it into the backing file used for collapse testing.
> >
> > Instead of copying data through write(), map the file directly with
> > MAP_SHARED after resizing it with ftruncate(), initialize the mapped
> > area in place, and sync it with msync().
> >
> > This simplifies the setup path and avoids the need for explicit
> > partial write handling.
> >
> > Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
> > ---
> >  tools/testing/selftests/mm/khugepaged.c | 25 +++++++++++++++++++++----
> >  1 file changed, 21 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/khugepaged.c
> b/tools/testing/selftests/mm/khugepaged.c
> > index 3fe7ef04ac62..f6e171e1da4f 100644
> > --- a/tools/testing/selftests/mm/khugepaged.c
> > +++ b/tools/testing/selftests/mm/khugepaged.c
> > @@ -369,7 +369,6 @@ static void *file_setup_area(int nr_hpages)
> >       int fd;
> >       void *p;
> >       unsigned long size;
> > -
> >       unlink(finfo.path);  /* Cleanup from previous failed tests */
> >       printf("Creating %s for collapse%s...", finfo.path,
> >              finfo.type =3D=3D VMA_SHMEM ? " (tmpfs)" : "");
> > @@ -381,11 +380,29 @@ static void *file_setup_area(int nr_hpages)
> >       }
> >
> >       size =3D nr_hpages * hpage_pmd_size;
> > -     p =3D alloc_mapping(nr_hpages);
> > +     if (ftruncate(fd, size)) {
> > +             perror("ftruncate()");
> > +             close(fd);
> > +             exit(EXIT_FAILURE);
> > +     }
>
> Why is that required? We write all pages.
>
> > +     p =3D mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE,
> > +             MAP_SHARED, fd, 0);
> > +     if (p =3D=3D MAP_FAILED || p !=3D BASE_ADDR) {
> > +             perror("mmap()");
> > +             close(fd);
> > +             exit(EXIT_FAILURE);
> > +     }
> >       fill_memory(p, 0, size);
> > -     write(fd, p, size);
> > -     close(fd);
> > +
> > +     if (msync(p, size, MS_SYNC)) {
> > +             perror("msync()");
> > +             munmap(p, size);
> > +             close(fd);
> > +             exit(EXIT_FAILURE);
>
> Why is that required?
>
> --
> Cheers,
>
> David
>

--000000000000f4fff0065082300f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><p class=3D"gmail-isSelectedEnd"><span>ftruncate() is need=
ed before mmap(), since the file is created with</span><br><span>O_TRUNC an=
d initially has size 0. Without resizing it first, mapping</span><br><span>=
and accessing the full range can go beyond EOF.</span></p><p class=3D"gmail=
-isSelectedEnd"><span>You are right about msync() though =E2=80=94 since al=
l pages are written</span><br><span>through the shared mapping and the test=
 later drops page cache</span><br><span>explicitly, an explicit msync() is =
unnecessary here.</span></p><p class=3D"gmail-isSelectedEnd"><span>I&#39;ll=
 remove msync() and send a v3.</span></p><p><span>Thanks,</span><br><span>V=
ineet</span></p><p><span><br></span></p><br></div><br><div class=3D"gmail_q=
uote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, 2=
8 Apr 2026 at 15:16, David Hildenbrand (Arm) &lt;<a href=3D"mailto:david@ke=
rnel.org">david@kernel.org</a>&gt; wrote:<br></div><blockquote class=3D"gma=
il_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,2=
04,204);padding-left:1ex">On 4/28/26 11:43, Vineet Agarwal wrote:<br>
&gt; file_setup_area() currently allocates anonymous memory, fills it,<br>
&gt; and writes it into the backing file used for collapse testing.<br>
&gt; <br>
&gt; Instead of copying data through write(), map the file directly with<br=
>
&gt; MAP_SHARED after resizing it with ftruncate(), initialize the mapped<b=
r>
&gt; area in place, and sync it with msync().<br>
&gt; <br>
&gt; This simplifies the setup path and avoids the need for explicit<br>
&gt; partial write handling.<br>
&gt; <br>
&gt; Signed-off-by: Vineet Agarwal &lt;<a href=3D"mailto:agarwal.vineet2006=
@gmail.com" target=3D"_blank">agarwal.vineet2006@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 tools/testing/selftests/mm/khugepaged.c | 25 +++++++++++++++++++=
++----<br>
&gt;=C2=A0 1 file changed, 21 insertions(+), 4 deletions(-)<br>
&gt; <br>
&gt; diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/s=
elftests/mm/khugepaged.c<br>
&gt; index 3fe7ef04ac62..f6e171e1da4f 100644<br>
&gt; --- a/tools/testing/selftests/mm/khugepaged.c<br>
&gt; +++ b/tools/testing/selftests/mm/khugepaged.c<br>
&gt; @@ -369,7 +369,6 @@ static void *file_setup_area(int nr_hpages)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int fd;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0void *p;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long size;<br>
&gt; -<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unlink(finfo.path);=C2=A0 /* Cleanup from pr=
evious failed tests */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0printf(&quot;Creating %s for collapse%s...&q=
uot;, finfo.path,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 finfo.type =3D=3D VMA_=
SHMEM ? &quot; (tmpfs)&quot; : &quot;&quot;);<br>
&gt; @@ -381,11 +380,29 @@ static void *file_setup_area(int nr_hpages)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0size =3D nr_hpages * hpage_pmd_size;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0p =3D alloc_mapping(nr_hpages);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (ftruncate(fd, size)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0perror(&quot;ftruncat=
e()&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0close(fd);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exit(EXIT_FAILURE);<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
<br>
Why is that required? We write all pages.<br>
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0p =3D mmap(BASE_ADDR, size, PROT_READ | PROT_WRIT=
E,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MAP_SHARED, fd, 0);<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0if (p =3D=3D MAP_FAILED || p !=3D BASE_ADDR) {<br=
>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0perror(&quot;mmap()&q=
uot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0close(fd);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exit(EXIT_FAILURE);<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0fill_memory(p, 0, size);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0write(fd, p, size);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0close(fd);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (msync(p, size, MS_SYNC)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0perror(&quot;msync()&=
quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0munmap(p, size);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0close(fd);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exit(EXIT_FAILURE);<b=
r>
<br>
Why is that required?<br>
<br>
-- <br>
Cheers,<br>
<br>
David<br>
</blockquote></div>

--000000000000f4fff0065082300f--

