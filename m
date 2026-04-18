Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9F68F436B1
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 06:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E49306B0197; Sat, 18 Apr 2026 02:12:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF9BB6B0198; Sat, 18 Apr 2026 02:12:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE8F66B0199; Sat, 18 Apr 2026 02:12:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C1F436B0197
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 02:12:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C65B01A0409
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:12:37 +0000 (UTC)
X-FDA: 84670657554.27.2ECC938
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id AF11410000F
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:12:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k8gfIqwr;
	spf=pass (imf05.hostedemail.com: domain of sef1548@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776492755; a=rsa-sha256;
	cv=pass;
	b=7UcIXqT7CNtsZkGvsPeH/fCheXq6XYETL6EzcJWdDxBe5Bhy0IfPyXfkK9m/CMoHhcCdTw
	4W2VTjJUxCvKAvQJ+JlVKm+mBsmL6FYtqv4Qbt9VxU7FVmpDHGZdrWsP2v4P2IoM1PjV4H
	eLSZ+NL9Jsmx+J2A/5TNnlLX6IWOLUI=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k8gfIqwr;
	spf=pass (imf05.hostedemail.com: domain of sef1548@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776492755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3C/M60s5TyLns1eZdDPM+HgZszGA1MYGLLrN6ugvXw=;
	b=rZT5m2VGNie2sHNS+UFve5G/ZSsjj2f9E9O2NeLoOtQxso0MygGSvDuSR1wSFJeOFB5No0
	QdOc+MdYroiZhSrG/aSm+lkM7NDwszqC4Cc9ozd0x99Jp/u8AEEYqairEo5L6f57s80XMU
	Xsx4KYKPGlabNZOXWBRh/aiL8BL2NEo=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488b8efed61so13863645e9.1
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 23:12:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776492754; cv=none;
        d=google.com; s=arc-20240605;
        b=cBQXPtljWOjaZY8jCSIm1CMvFzdeUrDEwfNeANFNLWYJliQTB6x96vrR9Yf7W3jeI1
         Ak7AIeTlDRveL/F4hK1u9dD58ZGH3LRgT60zObVcGUnzGRTbg754RiDM/jKQ3Q87rWwJ
         BPFgxnse+VblzRGKE00hFUM07rZyZ3Ukj/H+68L0sw+9S0x+Am4FqgtjTDASZZaQ6wOt
         jJUSBy/nWrWxR/qsbZVVtw58rqq/aE9PLkA3FnjZFPHZePRHB+v+xMrRLs6A5dojvLoc
         UU/Vyvqq1BOUz4VwJ/2HpTYnERHSn40W7P8p7Yt1OhFVjAi1D7dz+TaNVM+bIdOBIZTs
         MQGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b3C/M60s5TyLns1eZdDPM+HgZszGA1MYGLLrN6ugvXw=;
        fh=dC6VTFBPIHxUZtlrFyaq1SxWWqr21nkv8SkPsoV22jo=;
        b=imHLCx6ESqU95iiS2gUpe+hdH2megJEhqBQHxBbmv265dFYyggl1QH2jGSBTkrGIVc
         hHp8pfVd6h7y5yjzjVIjjrnkVw/i8Bcp4cjXHvCrRHnE7+Fp2iBJ/CMqNSGsdn0qJwXu
         Pi1Zd1heICH0qJcFTcMkzwRW3nvMSRL2sDjLZzBHvr1qjkOnWzH5jKAIaTcSjU6VNPC3
         e/E3m2I8kGRYGSTQB5DNei0IvJv92QPCh0um6lpgYVLwpLFkyLxHCwNPCUghxIGZRcaZ
         UCIwra5FVRqyWZZnHLEkmqC+T6qJdnXqltFsNjotBczx6AE88xg0zJRAd27apSVhv3D/
         hhoA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776492754; x=1777097554; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b3C/M60s5TyLns1eZdDPM+HgZszGA1MYGLLrN6ugvXw=;
        b=k8gfIqwrDJnPeuZ3qEGr5jbxu4UGpvYG/3M964OhAhrzi9JzfpQ3sqzVb6MB3XRzfg
         MXO0c+UGiGjQW4LlOu8fBBur1xBL+MSV0LhbB8iuM1YAHeg7uXIjIZGS2li/yuE/M7Cm
         4EEnpBcMfCNqbZfJP9AJNSDYjA6Gywa7PHmLnz1zM9PqABcVM2HxUMUA0Deh4c8TkHeh
         l1AjWTB2aasTPX54atVxb4/c0LvPjIxpl5e/LV8SyeK2FCEgbyN/Yx+u1/zOjmJXrhSE
         TBg7f66Fb3PvnPJe9W1XQBi8kbxbuUMgejAGQX5NaIOeZnni/jtnXvJC+hyKd4nn9OJx
         O+GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776492754; x=1777097554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b3C/M60s5TyLns1eZdDPM+HgZszGA1MYGLLrN6ugvXw=;
        b=CtyKipyQUZcJSJSypYpw04sVjgMDOmbzIBd2pd3kxQC/vLrcBvStgL0lajfuI20ScP
         7FBsvc2WCbUUk4xTeiT/eAz8rerF0q0s38NuyzstyoHK0Ev3A3lnzEcpLiWjDjflAVzd
         zaOLBAGSLw2xQUSMm5ipZv5WeNUmATGtOyb8cfcxE6z8qMDMXqf3avS8RBZapy7RnfBB
         On1nXLp4au3UGG9w64KntR5t5uXmdui+NpObUpZfZrO1qP4VACI1SpsR+nQ0BXwWqFeV
         SNUSRH1+5/KWHObdPS6iM/ToNPHx0o6wpKlo19OtR5OvbP1FfVHgQDX2q0z4YJkmBpJz
         81XA==
X-Forwarded-Encrypted: i=1; AFNElJ9p5ymeJSn5WfWRN11nNgkuobG79bojh9K60sAC0cBrqN9QhOUoE13szfDqftz/iSLDiXP74OZgFQ==@kvack.org
X-Gm-Message-State: AOJu0YwNki1LHdNm01BgWZ0ycFecSYqYXs/hKH5RE4qVNJhLsgDD5M3D
	Pb4ql9VkpB5kOV0wcIgFc2uXKb4+k2ah7Tow31dp7ADsy1Z45IZpjcyOlEHvnPPhyt0aBeLQYOr
	GOj35cvxI8d/IpE1PS/gdEbunGKy/UGM=
X-Gm-Gg: AeBDiev1oJdachPQkjzB+BvXchiCuZqCLMcx9WV7qUG7rfU4RgaS7F+2eSiT5IUPl81
	YdJHIKqMBSiEkzNacvETX21mK+5TV8Amzkebgh3EatF59WwbpI4zWgUasuSReSU3fZay07aFZ6D
	0xHG26rRpNa498pinQVnUUwrMGFqMWO4jdUpPtnMt/9brMebaYdbRE7ibfZ8Enk3biNXEI2U1Lr
	Yv829I47LLGOn6K/1AJmRqku/PkwKMJ2ckkVHIS9r16c0yNOLT+cAnO/1/yCranNeeqOPcExXGS
	/FYClvZ9eGZlJL2myUD8wuoD78Qmo7Q+LqMxNmsY9t6hnQv2/zNi
X-Received: by 2002:a05:600c:1e28:b0:488:8be1:ca3a with SMTP id
 5b1f17b1804b1-488fb8b56bcmr80695245e9.15.1776492753973; Fri, 17 Apr 2026
 23:12:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260418000635.17499-1-sef1548@gmail.com> <aeMQ36jFnCKmCSyA@casper.infradead.org>
 <CABZAGREDHwsXMm65_WxEn=v-zTv7_eVqQzQeCRqU2Gyc0aTETQ@mail.gmail.com>
In-Reply-To: <CABZAGREDHwsXMm65_WxEn=v-zTv7_eVqQzQeCRqU2Gyc0aTETQ@mail.gmail.com>
From: Nick Huang <sef1548@gmail.com>
Date: Sat, 18 Apr 2026 14:12:22 +0800
X-Gm-Features: AQROBzCpwOg3xLTc7KyvYORkIX8Q08EHhrIlqTmqbYKrZdQY1xs51voigSyTTRA
Message-ID: <CABZAGRGFpiiEr7Odd5an1+9Z+sX1C6QT2iadv-0hNhxGj8eEyg@mail.gmail.com>
Subject: Re: [PATCH] docs: Add overview and SLUB allocator sections to slab documentation
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AF11410000F
X-Stat-Signature: m9g68bpcnffibe4gw8h39z3gwuto9p54
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776492755-11120
X-HE-Meta: U2FsdGVkX1/4hDqMxy8cneYpX11n051H61WJ1LahGv98ve4GcaXGAGBpvJKGZbb5O3ARM6m8C1A0V+5JIkMYTdMp3lyMjnN5r/4asopBR/jgFOWIsplRDJqgBhhfvbcQARdhEBZdhXMslvDI07flxcgiNNo2tbqLBJxgDqKgvhCMleLXw1IdqHBMRxwWkmVXA+hGWbNT7sIuzc96WFJx500LTdCS4vLi03YU++3qhGGWx1iFe6L2KQU1pgTHtdKm12WVWdNjZbDppqgue7b1V9igx+jYj9jFs01WVoLcpiQJ5W9vfXEAtX2s5BcnloYqNAzTFep0Rpwt6aBjy0VWJHUJIfUNy2eAtP25tFEm/K/RCbFvzZfbSabULFU+JcFvzkjz3STfsZOyQ0FY1Cmf66OFWzuVpvecA2Gk84Iq3sEpqULJ18q4/8TKWeThZ5iYzRhCuBrjw165jJQejDzLGqidFPFO6yi9cvPtZUtYAiXmKfdhcGV43IP5uIQr8ojxd44IBicOZlVbtm9CsWFYcQEZP73F50sBIQ7oGhv27TqoqyJ0MHyRfPxqLESW6hecdNA/tG5qzGZmahqO2xSGIxfKWe40Viq+zcI3PDI2qC98a30APIrjD5YWwXd6j3eedeC2dn7ayVxe1s7xegAoRIx0L9j2PYjvt7i0Omp33TcoPobtQ+zaTsYgNmYKOLf9sUR2CFhLqo2Sd2yRjtFYaj4JFKhoPRcmfA/30YnqZJj3L3DoB7RPZO/AmI123/n+L2sdHY/dEmG6lu8hUUzMxEIn1Giv/NV4aTRB+XPiQ1uxBNbqICde25UFAA9wtpjMHwoCCnrnVULQIJFAFoKU/gEDqiuIPSJUGgtv/GlcA5rvbc0lAwsV7LSZnffMr2OW5NSDs/ffgdlyNKQI5kTJQrBzn4BAmcNbnmDCd7e0pPWMDQdPqQNo5Hxf5a/rOEDW7EQe1p/pSGHcks+q8qy
 FkxD4Utu
 9cOqQzaQH/Xt+GZ0KbGWW6UyNOBhcZxWU3DIlWe5Mb/utXH1fg593rWhlq4N2KbN5pRFiuMV/J+x9mYbwFbsp4RC8hAwFxmwQrtU8ZY8093B6TkiKG7PVwN1cee7T+hcjIpirZFAks8IHWm7cLwwziWzbCUf8d00zynuSLDzN7hIj/o9yLM/VH7wQi/AF4Cn0p+f0tAI7AWocmca0FwMQKNwXSpwZI6ZFSVbLmMQrXZjj4PFPzFQB9vGey2YW/l1sIODYVrt364CKpqbZPNjxceldaxxjS/3fhHURrrj+iKqrcpu5PChtighBZ8M72DdgVdiEZU2JpEh9VGfXa+p59YHCwZCaYpQEUXjU5bKS3r58h1hWAVrzcSEZmwQoPiwzVMoQgst/sfQFJyU1VbaU1bnjBQrAU01oW25LSXQ+y0arc3OriKH+TeRkIRADsG9G7ElVKXepqL8ESLeunyd1957RLPMxrahtiT89cuXJ3dnmv9u8IgQMV0KHmRvoqLS2KLA0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nick Huang <sef1548@gmail.com> =E6=96=BC 2026=E5=B9=B44=E6=9C=8818=E6=97=A5=
=E9=80=B1=E5=85=AD =E4=B8=8B=E5=8D=881:27=E5=AF=AB=E9=81=93=EF=BC=9A
>
> Matthew Wilcox <willy@infradead.org> =E6=96=BC 2026=E5=B9=B44=E6=9C=8818=
=E6=97=A5=E9=80=B1=E5=85=AD =E4=B8=8B=E5=8D=881:04=E5=AF=AB=E9=81=93=EF=BC=
=9A
> >
> > On Sat, Apr 18, 2026 at 12:06:19AM +0000, Nick Huang wrote:
> > > - Add "Overview" section explaining the slab allocator's role and pur=
pose
> > > - Document the three main slab allocator implementations (SLAB, SLUB,=
 SLOB)
Hi Matthew Wilcox
I will remove this sentence in the next version:
=E2=80=9CDocument the three main slab allocator implementations (SLAB, SLUB=
, SLOB).=E2=80=9D
I=E2=80=99m not entirely sure I fully understand your point. If I=E2=80=99v=
e missed
anything, please let me know what needs to be changed. Thank you.

> > Umm.
> >
> > commit 6630e950d532
> > Author: Vlastimil Babka <vbabka@kernel.org>
> > Date:   Tue Feb 28 15:38:07 2023 +0100
> >
> >     mm/slob: remove slob.c
> >
> > commit 16a1d968358a
> > Author: Vlastimil Babka <vbabka@kernel.org>
> > Date:   Mon Oct 2 20:43:43 2023 +0200
> >
> >     mm/slab: remove mm/slab.c and slab_def.h
> >
> > Care to revise?
> >
> Hi Matthew Wilcox
>
> Thanks for pointing this out. You are absolutely right=E2=80=94I overlook=
ed
> the fact that SLAB and SLOB have been removed from the kernel.
> I will remove those sections and ensure the documentation focuses on
> SLUB for the v2 submission. Thanks for the correction.
>
> > > - Highlight SLUB as the default allocator on modern systems
> > > - Add "SLUB Allocator" subsection with detailed information:
> > > - Explain SLUB's design goals and advantages over legacy SLAB
> > > - Document its focus on simplification and performance
> > > - Note support for both uniprocessor and SMP systems
> > >
> > > Signed-off-by: Nick Huang <sef1548@gmail.com>
> > > ---
> > >  Documentation/mm/slab.rst | 26 ++++++++++++++++++++++++++
> > >  1 file changed, 26 insertions(+)
> > >
> > > diff --git a/Documentation/mm/slab.rst b/Documentation/mm/slab.rst
> > > index 2bcc58ada302..2d1d093afb7b 100644
> > > --- a/Documentation/mm/slab.rst
> > > +++ b/Documentation/mm/slab.rst
> > > @@ -4,6 +4,32 @@
> > >  Slab Allocation
> > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >
> > > +Overview
> > > +=3D=3D=3D=3D=3D=3D=3D=3D
> > > +
> > > +The slab allocator is responsible for efficient allocation and reuse=
 of
> > > +small kernel objects. It reduces internal fragmentation and improves
> > > +performance by caching frequently used objects.
> > > +
> > > +The Linux kernel provides multiple slab allocator implementations,
> > > +including SLAB, SLUB, and SLOB. Among these, SLUB is the default
> > > +allocator on most modern systems.
> > > +
> > > +SLUB Allocator
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > +
> > > +Overview
> > > +--------
> > > +
> > > +SLUB is a slab allocator designed to replace the legacy SLAB allocat=
or
> > > +(mm/slab.c). It addresses the complexity, scalability limitations, a=
nd
> > > +memory overhead of the SLAB implementation.
> > > +
> > > +The primary goal of SLUB is to simplify slab allocation while improv=
ing
> > > +performance on both uniprocessor (UP) and symmetric multiprocessing =
(SMP)
> > > +systems.
> > > +
> > > +
> > >  Functions and structures
> > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> > >
> > > --
> > > 2.43.0
> > >
> > >
>
> --
> Regards,
> Nick Huang

--=20
Regards,
Nick Huang

