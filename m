Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03007F436BF
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 05:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D40DF6B0195; Sat, 18 Apr 2026 01:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF14E6B0196; Sat, 18 Apr 2026 01:28:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C070B6B0197; Sat, 18 Apr 2026 01:28:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF1BC6B0195
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 01:28:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 203BBC1B5E
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 05:28:02 +0000 (UTC)
X-FDA: 84670545204.02.92993F1
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 02DAD1C000F
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 05:27:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bCkwkTvy;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of sef1548@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776490080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYAGoFNrWRDm2eh1Ti+BKPYiyqx9cfyfl+NYb+/2tDg=;
	b=CWsZUyIRYU25Vusog91pFIsb3+0bVY5kMuqe3ciQO5ZQyW2aGirees1MfajSanGGkyeUjT
	gB3oLOMKNZc/V0fSjFlmrIejLtGMjijfnKgUug9RoHX96CY5IEUOa6YZooRz7U9DpwmsR+
	ZB0ZeR8HIybwYX7/7O9prflSBdb0AjE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776490080; a=rsa-sha256;
	cv=pass;
	b=jnIDnap5Bq2cwWHuGLEquTwxWXrJf9wkP8df8vxh46CDFmznsEesyfTfdJsx07apt1ZUlJ
	byf+C+zsh3m0Du+0+mE4zMPbUFXtJh6rDWzc9KPCjg28oFmWAYd0jyBWFJpSnRS9waNl28
	BHrcgjWxFJLaUbEd2QRSvYmpv4gmhQ0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bCkwkTvy;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of sef1548@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43cfbd17589so970493f8f.0
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 22:27:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776490078; cv=none;
        d=google.com; s=arc-20240605;
        b=jMJJke0ipgfB44YxffAFOMinjH8h92dPWK5Uvygckh0JuVPq7HvMCDfDS0ht2aiPJb
         BLFmA0h8P1TaaFUuxIaTWGf8C2NRLdaAZxnQHMA7YVMKLaaYuHCDqiim4N3h/MWmt4EO
         +iZTTLQLkJO3yzNCeMEvsGX8A+l2rEwkdKizIHTIRYEpDIQ8vdUh3YAuXL5m0zmFOO78
         0HwCHtddwAOEGzZZIrM6QiThkIAhysUFQNCZI4dmUZayuw0jbop8tZ+L0fWrupc8B3pp
         XRPxMtB9WzrqEmrnFxGESjWVrLmihI05G9c80HuGd/uzZDGSos63px+RvICGFM+CDYV3
         XWmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SYAGoFNrWRDm2eh1Ti+BKPYiyqx9cfyfl+NYb+/2tDg=;
        fh=6P6/JpQO416AP1MhO+syom8AjdMO+CJBgttV2oUkRIE=;
        b=clJNWgBBUSxgu09DM7dhHzjnJ2D2KvhlolAoD6gk4RYMCEHbB21xvfdksPk2P+suEC
         s/qgMhxOLsNnXGEem0bfk4fp/yIyBAv0/X8Uuq0ZTNsxqQ5D4cMrvm/KJGTTDCJ/0AkF
         r/47o1DBjAyZHYV6PeRskFehxi1aIfbuQLRDMbcTx/+QztLiE1f5tCt/3zrjhONK2M2Q
         vKVzKtfGL3gGzPs3QEWO2rRwLmTLD87TjEotvz8KsJXF58b0EpDMIjFioHursHXyzPgz
         VJu3SCGbyU4LPFVYLgl//Dd3VZCDDYdVIqjfw3rl6IM182ZitwYnYzyYd5XtvmqKEjfY
         S32g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776490078; x=1777094878; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SYAGoFNrWRDm2eh1Ti+BKPYiyqx9cfyfl+NYb+/2tDg=;
        b=bCkwkTvylEgBq77dFfzjTtKiN/ph9BL07THacQdF2Lni49OEczF2+pUKcsSOjC6VvV
         QH+If+gKom2swXXVCjpa7UiIQOFUqL5pSnwFtsdYN1ttVvm3ixheFry5O7u1XUKPgwrC
         qG4XCnUEQxV834nAYUuY1cM5IBt5M60Fduulydw6+0V7KRs56oimzJdelUawWlK4wlh6
         sgySDtipRFrZgbLpMf5fEMTnhQhePauZ5p6CSYKEiDaGjviqsMfZjrOCIYFcxHHJz2Ww
         ozUILHtBplmHLTfBysCEaSBt+d4NqsIPBLYRFHSF6eENpIrXzjCoZ4IRgkumf7gg88Yj
         /AsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776490078; x=1777094878;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SYAGoFNrWRDm2eh1Ti+BKPYiyqx9cfyfl+NYb+/2tDg=;
        b=CTIaRKVZDzDRCoq2TRsjS5D69OxVyliIBj3x1KQ3/w7g4CtqEAGq8GO9QEVYBYPPtD
         YWkKpT3fXCrWRUmYxnZPhpzrPNJyeM2KedIu0hP9062jnzWhe5OaTpzgNz1BG07X4VGA
         Um4qdfwGFuVvqEorwSxhma8jCmGvAthlKpUoxCRnh8NszTCi5Qi/Q/cjdLVrhp1YvrPo
         qa5CXU4DHhoysL82xbhIFTL1V03atXBAnIEPF4iHtepig2wyQ/5/+c9aqQK4voUS+gXy
         SeOs7VS3bXgSjy09eRMC7U/92CCJSrrc9/0YpC0BGy5aP9peGABpUzSEp5vExGZjEgvX
         5u0w==
X-Forwarded-Encrypted: i=1; AFNElJ9b8fUiygddW6OZ8qTSGbcwGl2VQyMUkpE8vjxOPdC73doqphnD2v8+/7N2L05vdJLifcKOOEiuIQ==@kvack.org
X-Gm-Message-State: AOJu0Yx2XwVsUAKI4GNMvKnKdX47ee+zEHihwdQkqVceqjgGY1DJszeh
	5GNVyTNgZXkOIOdEyq9wWHECG9k3jR7311AdfSDAxhpBF6G5P59gthwiVhqeIsFYlNWCDvGE6M6
	8KD7XAtoX3rGY00jmALwHEI56xLzDm3Y=
X-Gm-Gg: AeBDievPdMPwTR5UNcLR+HEvnvyCQ1+wMEcz0JrTdrp2lEpswxZbfvemr8buTcPMUEN
	fVkfKzWnXPGXzWbH09XT0QhYkNQ5Qt0nRwXLdAlE8wr1Mjx754C01VjbLVML2Djl4ljwYKvRqTG
	8jRCcZVSMugfhGdX119RMGHFPe6GC8PRrvS0H2eS5bLp1jnp5tqDcuCDokVAYSZbGsnnt2RXVgF
	PKiZ44ASdr1R/ZVVysDRnA6uD34F+qeK2d5OtbvN1YC7Fp98x0qhIq4zMuvTjuowkUaAHedWMpT
	NVEUKNhXj+Cx/uCAYA==
X-Received: by 2002:adf:fcc9:0:b0:43f:e4f1:bd9b with SMTP id
 ffacd0b85a97d-43fe4f1bdf7mr4968568f8f.30.1776490078315; Fri, 17 Apr 2026
 22:27:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260418000635.17499-1-sef1548@gmail.com> <aeMQ36jFnCKmCSyA@casper.infradead.org>
In-Reply-To: <aeMQ36jFnCKmCSyA@casper.infradead.org>
From: Nick Huang <sef1548@gmail.com>
Date: Sat, 18 Apr 2026 13:27:47 +0800
X-Gm-Features: AQROBzAPUOixr-L6lL7fb9JgEK14SirwWCxHLnfBUgOConJMytgXqwkp5e8GdOo
Message-ID: <CABZAGREDHwsXMm65_WxEn=v-zTv7_eVqQzQeCRqU2Gyc0aTETQ@mail.gmail.com>
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
X-Stat-Signature: ipekg9ojc3xfc9o7z7xnrurdqywifw5p
X-Rspam-User: 
X-Rspamd-Queue-Id: 02DAD1C000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1776490079-430750
X-HE-Meta: U2FsdGVkX1/lfflPE23KlnnLOUFZfPFxzgwLiyGE7xT3qgMwZrwUOSQhpesXLDNLE/DibMwBlsY+b3YiQSEykT+H4YsyLKD1yZAfpLeoxk7qXMMb8wU3UzejOmHGElVzeJlHx5OZw+2xvQg4vQs2lTsE+3ilAnXs0Mq0YhE9IM3l8P0ue+jOfEIszMf9MN5DBqMfd/uwZuQk4J81V02pBg5sdx4RJXqK8AOI3FJK6qm9lv0J9xywrpnMSmO0EmGFtEj3jqd4OhiJXNHL6F41PuoMwaWqI4o9Xyz/CNpBolDjilustBTE4CQwIl7N3agUBhilB9fX6JzPyGOyn+elamk7e2axI2YVqqCKUflv3hdzUjapJpcWIH7GyOUsgDBDx8QeFlg8UM5nY1xXKg9/uoeX6BuCNYaFTpZXFhS2B4IkiehAgqHaSeDKHvuKMt5L7SQriKRmCTVTS2tQY9GttrYq7Ce7QMe6hU9KRkbnts1195K36vauAwLBLQo3Mu6b2YtJy+3PaKu1CIarQzZgPRISNEyTCxLHXROQCFzsaNDhCe/zXtgu+JAuq3/LBLXB/VF4jv0dBBtFhXCPdCcDYKA5PnH/Z0+DQ3QuUhf41Y1TKnVF+XmEG7IQVjdtsJzXa8mUfS6o71v0iJsDscz5G6EDyJIrRsZCxfqT0hsqodR8IQbzYWikCuGXy2LoEq0FUC81eFs8srnaQTjZtK6dUM5k3eKOTflDfSOA2z1x5f2cm2p8UEXQgnNswwbIZ6Q2ciKSW6grRb9MaB6eEe79SH+ekynKfTYaTERWYCTz3NldVidjBWK//JQaw1ULUdU1yF1Aozq9YaABzDLwqe0BPzYdRWCYVCs6qmlt5RHX4JUiS2yn9JDndZVG6er3pFwjqmKC3L7lfPIhZJpp38EmkGfvtO8RVagguCNNLclIQag3gULNrRbMEChk9gFYJuJHWGcD2iM0nPRlxZghWKs
 AAvt6UtJ
 YIrP3T0k12gGzRvt7lUg0rEe2hd/oIGz0KQ7XEU6JPIPUc2lKlB04EksXKmuZWc6kJwUXUnUlG+pF36yqY3b4AECu9FkUd/IRTHcnbHijg4BQQiv5e+aTVYLsbcqYTNo7mXSkTRv1eLtplxsFhjo4V4SJ6o6yLLxxFQNSPussUZBOvtvkewpO0RurItqzCHXIJ1CsX9qhB4dWiNFDNw09h28/VjgNab43OwPrqZ8A0qY2OceBMJ/wZElur66C+yu9bhWUaoFNeZbnQnblPiHkpKJtBjr2BW2XB3dRBzeXPBTTWksaJlSxXzoRyO4LsyZLSBkJ+hdv+CHpomffoiZRmSdOwC46uK3Y5fh3kwkQ4FBBpp3YJqxiUCDk2XNRx4dyPrbivguurSKymA+G/fLN8CKHr7j2Kw1JNoD3Z0GdV0quHXhXpR8qI3J9iO40cD4fAU60uHHEN9UZQhE/vcTR4ynhYi1935UYHajCOgcbg9vdQ8viFLmvF6xbrU1BnXFl64pK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matthew Wilcox <willy@infradead.org> =E6=96=BC 2026=E5=B9=B44=E6=9C=8818=E6=
=97=A5=E9=80=B1=E5=85=AD =E4=B8=8B=E5=8D=881:04=E5=AF=AB=E9=81=93=EF=BC=9A
>
> On Sat, Apr 18, 2026 at 12:06:19AM +0000, Nick Huang wrote:
> > - Add "Overview" section explaining the slab allocator's role and purpo=
se
> > - Document the three main slab allocator implementations (SLAB, SLUB, S=
LOB)
>
> Umm.
>
> commit 6630e950d532
> Author: Vlastimil Babka <vbabka@kernel.org>
> Date:   Tue Feb 28 15:38:07 2023 +0100
>
>     mm/slob: remove slob.c
>
> commit 16a1d968358a
> Author: Vlastimil Babka <vbabka@kernel.org>
> Date:   Mon Oct 2 20:43:43 2023 +0200
>
>     mm/slab: remove mm/slab.c and slab_def.h
>
> Care to revise?
>
Hi Matthew Wilcox

Thanks for pointing this out. You are absolutely right=E2=80=94I overlooked
the fact that SLAB and SLOB have been removed from the kernel.
I will remove those sections and ensure the documentation focuses on
SLUB for the v2 submission. Thanks for the correction.

> > - Highlight SLUB as the default allocator on modern systems
> > - Add "SLUB Allocator" subsection with detailed information:
> > - Explain SLUB's design goals and advantages over legacy SLAB
> > - Document its focus on simplification and performance
> > - Note support for both uniprocessor and SMP systems
> >
> > Signed-off-by: Nick Huang <sef1548@gmail.com>
> > ---
> >  Documentation/mm/slab.rst | 26 ++++++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> >
> > diff --git a/Documentation/mm/slab.rst b/Documentation/mm/slab.rst
> > index 2bcc58ada302..2d1d093afb7b 100644
> > --- a/Documentation/mm/slab.rst
> > +++ b/Documentation/mm/slab.rst
> > @@ -4,6 +4,32 @@
> >  Slab Allocation
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > +Overview
> > +=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +The slab allocator is responsible for efficient allocation and reuse o=
f
> > +small kernel objects. It reduces internal fragmentation and improves
> > +performance by caching frequently used objects.
> > +
> > +The Linux kernel provides multiple slab allocator implementations,
> > +including SLAB, SLUB, and SLOB. Among these, SLUB is the default
> > +allocator on most modern systems.
> > +
> > +SLUB Allocator
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Overview
> > +--------
> > +
> > +SLUB is a slab allocator designed to replace the legacy SLAB allocator
> > +(mm/slab.c). It addresses the complexity, scalability limitations, and
> > +memory overhead of the SLAB implementation.
> > +
> > +The primary goal of SLUB is to simplify slab allocation while improvin=
g
> > +performance on both uniprocessor (UP) and symmetric multiprocessing (S=
MP)
> > +systems.
> > +
> > +
> >  Functions and structures
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> >
> > --
> > 2.43.0
> >
> >

--=20
Regards,
Nick Huang

