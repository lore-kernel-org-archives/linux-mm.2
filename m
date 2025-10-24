Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B8E6CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 01:56:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6FE8E002F; Thu, 23 Oct 2025 21:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BDB18E0002; Thu, 23 Oct 2025 21:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FA558E002F; Thu, 23 Oct 2025 21:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 500CE8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:56:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 11DD0BE13E
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:56:45 +0000 (UTC)
X-FDA: 84031343970.01.B91F232
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id 25AABC0007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:56:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="FAJT/oZk";
	spf=pass (imf10.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.217.49 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761271003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h3wXd6gCAHDSdcT184SwaO/DYF8T98vh52YBZMXknyg=;
	b=3WBA704/0iXikCOsi9O6QkRnU846QMR6k+CdTOVaa0NJzSlx2Se02JsyG1EK5br0p/SzgJ
	CmyvufzuF85ws0xonQxKnsHrd1jEgWi12VAyyNyU0oo9zLVjnUiZZJCPpkstdktQKSvVTb
	yfejtlFurxWgsq6MbOEjyDxzf7jyLUU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761271003; a=rsa-sha256;
	cv=none;
	b=UyU0vZhODorTZpwGVhgioqTBPmgVeoS+YMYuytMI93WL468MKQS7/IGUecbEKvrw9IfC04
	cOV8fpGn2yuaItNbUmOvCHHI0PPmQb5yBdtpNlmc+Y6CYWO0ay2seyUX15typ4aicmgcxg
	pcrQPFM7C+DEimgrJ89JKk6bS7KLqzI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="FAJT/oZk";
	spf=pass (imf10.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.217.49 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-58de3ab1831so1416045137.3
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761271002; x=1761875802; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3wXd6gCAHDSdcT184SwaO/DYF8T98vh52YBZMXknyg=;
        b=FAJT/oZksgplcQs2yeU6z/H80u+7L7HFJwl5XPkgMlwi+HRKCx0YwTZMuVyYjdPz5y
         RQditqQT+kZm5LqvuWgXV+Lb1PaaH7iltDoZuqvzuV5ckU8l0rBcrZMKsqLBSeuafXd7
         RYJJR2zWMfPfR08qyK2bKSxzZl8Q3/eGL2iSCewvqNrXecLcDLFsNq49CPZx6f655ZOw
         DB7UwL5KpppyLSEZiJoHL92GYy9Y4cpVnG9BD4O10HF8YudoSbqErgP62MnVoPuSCiYT
         oAvAfgmiuQ9HtbVHACMRS7/X2R4G4C22LarXFv8M4IMrcSe7slvRsrXLPkSdnUB+dtfV
         C9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761271002; x=1761875802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h3wXd6gCAHDSdcT184SwaO/DYF8T98vh52YBZMXknyg=;
        b=Mn2F5Pg80py6sUans7khaKmzToq4jht7lUotwQKzrYBLP+1/K9+8GuB19eRryUvL6d
         z3cgf2LoZ7ZzO2a5SSR/lk64mjNbD2v1d0cqYxPIoK8M/R2RT9VvaxTmTjdYpiXfvw3A
         m/Pxe/NwHem89fARCDwybbrnQ/EDMORwHkH7zpi7J4aOqbFpF08rFSB98b+26KzXisqR
         Q3vQ7l5vSg/5r7GGLUwsgodW4y2Hb9JcJ9qRcXO3kaHwiXDcuNNjXT/eLFgI6kNJbzC1
         C/qWsFWbgk6iGoPnoUbzvVZOe2pwH2gr93va2Wh13USRAUJOn8eX62g+1KcwzScndrAy
         G6nQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnZ02auQ7/HeFGZx7wuF9998dKPY2vTpL7kD36769Evs+MdoCNa7KoVlAve7bQGQbO+2i/xr7cxQ==@kvack.org
X-Gm-Message-State: AOJu0YzqEffdp/fFTB9id9ylo0WmoukWCdPXPpCcKAlJeVSPQWKnNhUc
	ctTo1k/qGKZIxl+AK7vgfvxPftM93fk2MaHPGSLT5yIkej7ng+0kZ1MQZNaYlcb0ONGn6zLUPmW
	h2At+Z/0WNT21YrV6S5oUdSpt1l07pbQ=
X-Gm-Gg: ASbGnctPlc3y3qgwRhlZRn4wtvdEtnQ0w5cwtTyqSTujp2wCUlZH3+S0v1CQTVOqAO8
	ewFDCz6gUrwjYlyCwbDHJfGujgeXfJMm5nQYBBozHIrYqNNO0qcQG/6I2EKqtAJG6uiRnI+T4Z7
	pzeOkIJYDiZ2mLaav8dldH+H51VUTtY73Eded3Aeb7+Fzu/+pMp7xPqQmxHivdVWOdSopNz8FzY
	our0eakiPq/D/e2pl6UTX8qy7CU+c3Q/9sZ7fbZUhcJQ/x30vS1Feu7SVkqXhFuOtj/WJI9/eiy
	EbcRxKUfgCFm+sF6O/VSypsFmdii6A==
X-Google-Smtp-Source: AGHT+IGZqTPH/RBOw7fnpSbszzrTIc2/2WIbGOyXrK2o8Ptsd+0ZdioAaS7bZPfKFwDfzMuMlpO2/ngAh30y/Gx7L/U=
X-Received: by 2002:a05:6102:508f:b0:5d6:12fc:76e1 with SMTP id
 ada2fe7eead31-5db3f8c5d89mr162595137.17.1761271001978; Thu, 23 Oct 2025
 18:56:41 -0700 (PDT)
MIME-Version: 1.0
References: <20251023131600.1103431-1-harry.yoo@oracle.com>
 <aPrLF0OUK651M4dk@hyeyoo> <CA+fCnZezoWn40BaS3cgmCeLwjT+5AndzcQLc=wH3BjMCu6_YCw@mail.gmail.com>
In-Reply-To: <CA+fCnZezoWn40BaS3cgmCeLwjT+5AndzcQLc=wH3BjMCu6_YCw@mail.gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 24 Oct 2025 03:56:29 +0200
X-Gm-Features: AWmQ_bnZfgWxvUlSV_cSyZkt3ycyNMFflOIinUoHSDKlFI4Ch_9TGgYATVsEHdg
Message-ID: <CA+fCnZdkWnRpp_eXUaRG_HM7HSDm4fLATpsqJhaxT_WGjhOHLg@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: ensure all metadata in slab object are word-aligned
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>, 
	Alexander Potapenko <glider@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Feng Tang <feng.79.tang@gmail.com>, 
	Christoph Lameter <cl@gentwo.org>, Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: hpye367yked5z4rjzsr4ddyyjnd7j5rr
X-Rspam-User: 
X-Rspamd-Queue-Id: 25AABC0007
X-HE-Tag: 1761271002-122923
X-HE-Meta: U2FsdGVkX18AaIkVGqyOAQz13oeegRhezoKpiGjzmewP9V5AdqM4QXNyxehRTwSwbBgr/82ZngmUq+3Y0Eao3fc/um+QJWwBgcVndyBJLL/Z1mmMfa80Uc+i1RvZLrVe6mnmwns1ZW50A56BZBcEH5KmWTZ7Gg6iZzB6cvHXMaSc9BAwhSNn8M++m4D/TpCVtnJU7vVrHDBthUwGL7uZDZ2tBnPa/oJg3ADnYXN3tvNdPgh3xEZP5mMnsPovfD8iz1HV9GAGdjSKFSMdGl0yXQcPr9ONIO/9uWbYu+kTeywyZOe+f0CFfWKs5vDI053NtLADTFycJu1vrrzBTpLmU7fJvmHvmgMZ4tRnuRPueNp0PHi42F0cxG1VeYGKABi1snofDmgYTdRmrAqeCD3PGcG/pSnBmBrTu3GGfTL7X5euurr/XXpUA9+G0paol5XfnznYDlMhCFakyqv++IUqUD+vxrh8ReuI7h5ciitoNZ13ZDAdEOAMcJg4ixJYOGAogIIn2abO2HDt9lEcl64eSuqD0XPxP5Sv8lcDDqhHqRFSXEL2eVQQD7ejnqQguzvMjNv08yzq48QXeXBni1u2JzP+WbDlRyzRlYYSXJHnyV8WGJkK+n17U+hMO5ZxjxZ6q6cNE8AIdtvleldHU6r+9U+1GjKAkpqyn7ypWW1b9VdLaYOa8j0ixVcvWv/XarAfQUN3Iot32MI00wmsLKI1EyXsgY7zRgoypxS3uOEznjuY+SeQ+O9xxwq/GRMwM6bjdk8R2op9VYE89R1Jhe0rI8EuM+k8oWt/ATbCQOpKG2LoSZVKTwDsB5hv/EwpcCJWdytBLZkVlLt7jf3VtKxvfPCLM9GuE+b7sRrdCH1wJP0CEAMujNxXqha0qbBDfk8GybZ230+Au40eq6E7iup2oHhw2M90JYPS7EdPp+038jiY6ANleLi3MVqX/oLWnEb8/8hMjpE/250QTqVjn/h
 Ki2Rvz93
 ufgbV910W/rpw5iIvq20XvKPgaeJ9IG7z7/+XDTDZOMTdEo457SYP4z/vp/5e49O0FyQYtPRKRXhHVM5ambszLCaMUFtShtmqu4gsBQ1OMrK8yKMDpLJm6uQrNBUI8rX1+FSfLHwyZOtONUi0rU2qdYxXcoC7WcoFgDgLeCUVj0KZmoPNr505KRmHmWQ8qqkY4U1N+biKZ0n4GSd5xtG9G0QRlBxBht04vrZV3z6n9/zjf7ocZ6pOcvjtaH61IUITvGCgKCqacFPA2FPIbl8vCkPZYK6YgsLnF5QDg04Ig/MvXQZAmOhhuJ3yxQLHft/DSJXglSgEIVUxcVub3LD3C0n0BgOpdJcy/9gGU5jVadKkICjqFKs4H1C4Ui5KG4LgdbcCVCqPYeBelKl8BzjSIxuv6oFZrd1HwlX9Md8YQnfSYZZam3QgE5+TtD8KbmLnGy6y9qcZlkxxW4/eVUZvi42N4ofU+TZASVgL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 3:19=E2=80=AFAM Andrey Konovalov <andreyknvl@gmail.=
com> wrote:
>
> On Fri, Oct 24, 2025 at 2:41=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> =
wrote:
> >
> > Adding more details on how I discovered this and why I care:
> >
> > I was developing a feature that uses unused bytes in s->size as the
> > slabobj_ext metadata. Unlike other metadata where slab disables KASAN
> > when accessing it, this should be unpoisoned to avoid adding complexity
> > and overhead when accessing it.
>
> Generally, unpoisoining parts of slabs that should not be accessed by
> non-slab code is undesirable - this would prevent KASAN from detecting
> OOB accesses into that memory.
>
> An alternative to unpoisoning or disabling KASAN could be to add
> helper functions annotated with __no_sanitize_address that do the
> required accesses. And make them inlined when KASAN is disabled to
> avoid the performance hit.
>
> On a side note, you might also need to check whether SW_TAGS KASAN and
> KMSAN would be unhappy with your changes:
>
> - When we do kasan_disable_current() or metadata_access_enable(), we
> also do kasan_reset_tag();
> - In metadata_access_enable(), we disable KMSAN as well.
>
> > This warning is from kasan_unpoison():
> >         if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
> >                 return;
> >
> > on x86_64, the address passed to kasan_{poison,unpoison}() should be at
> > least aligned with 8 bytes.
> >
> > After manual investigation it turns out when the SLAB_STORE_USER flag i=
s
> > specified, any metadata after the original kmalloc request size is
> > misaligned.
> >
> > Questions:
> > - Could it cause any issues other than the one described above?
> > - Does KASAN even support architectures that have issues with unaligned
> >   accesses?
>
> Unaligned accesses are handled just fine. It's just that the start of
> any unpoisoned/accessible memory region must be aligned to 8 (or 16
> for SW_TAGS) bytes due to how KASAN encodes shadow memory values.

Misread your question: my response was about whether unaligned
accesses are instrumented/checked correctly on architectures that do
support them.

For architectures that do not: there might indeed be an issue. Though
there's KASAN support for xtensa and I suppose it works (does xtensa
support unaligned accesses?).

>
> > - How come we haven't seen any issues regarding this so far? :/
>
> As you pointed out, we don't unpoison the memory that stores KASAN
> metadata and instead just disable KASAN error reporting. This is done
> deliberately to allow KASAN catching accesses into that memory that
> happen outside of the slab/KASAN code.

