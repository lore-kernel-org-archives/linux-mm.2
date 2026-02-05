Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B5B6E91264
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 06:08:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7EB96B0089; Thu,  5 Feb 2026 01:08:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2C416B009B; Thu,  5 Feb 2026 01:08:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00EC6B009D; Thu,  5 Feb 2026 01:08:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C32C6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:08:37 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E2B38B8BD
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:08:37 +0000 (UTC)
X-FDA: 84409373874.29.72EF5ED
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2DAFBC0008
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:08:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="embKr/fJ";
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770271715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AvtrECUNno08lmBFsY7oojO+h0Qj3mKXIQodqxeE2jw=;
	b=RIgmqmRvpnjhRCl3zbteuMQIY/7tUd1qxwf+YqkJs9KDLdBdvW490jNF2RCO4kpNEEyzXJ
	P79MtbVEoGtYfd1dphlf14jBl9vdYrzQnd3U0y0BJbTlMoZjwgda+52OYCunL02dauJVJw
	JmXycaxQJcG6d1UZwC35xBPxHEvCeYU=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="embKr/fJ";
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770271715; a=rsa-sha256;
	cv=pass;
	b=NCF8RsGOioaieTBo1utUPgIxmCcRNo0copb2e+Z9HLpI8cZLXuGy7YXpPeKaJdLV9n4rZ5
	l+SGkWAG/1FBBNuQX7y2CglcWEwjODwDuLpc3g3LEZwrrCwDTAKTWU5iY0tDccXWwioTQX
	GUF/u1YDpO/uv7GrlbdyarOIuUNHN8k=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-59b6c13b68dso1511221e87.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 22:08:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770271713; cv=none;
        d=google.com; s=arc-20240605;
        b=GbHNptKLnFcMzqI3y9L8waUMyQqWnknP0ufxqtHLusO7RmG+BuhdzltEqorNW8ppCj
         VqbTSfvc3Gq9+ag06ducziztJezMcDRoDzHd8l4xABnTHmxn7m98sYeQxoE1t1tfC+5o
         YK94mv9UYSGXoebAlFUl7f9WEslN46BZ4cKGLLe+P/qmxjDCysz5VT5HrYyb9wHSiaSW
         csmL4saTElF+3294pF+Do8x1z82wMd/19s2M3pGB0+3DIx5udbvQY0AC1m3hEmysmzel
         dMEihtkch75uSmuCeeHijXK9wrfg7V60eY0cwQoBDbX9oqcQ0ozuSDUDc4VisH6pxrce
         qu1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AvtrECUNno08lmBFsY7oojO+h0Qj3mKXIQodqxeE2jw=;
        fh=7lAw7GJSabWWVPiovogljjy1HIpkyhkQMoZajotW9+M=;
        b=auK91jOiMz1zXn+9rAgbhLkWWxRrmqizNrEfg1BozgHcLgRGiTNR4rcZme2YndOnvp
         IC8Spa2tBI2T4Jv3Nud30yeD3uOR2ErjxRLhBcmIi7fff9CJgkvF7BLi6sAqVOYmN28v
         DKvE5ARpropfPWY5gl6Fuc/+JTB6R+tnvpUbEoC50S6cpcmkcc14kRh3cREz1MfnG9pU
         U2OzivwOwlOoHGtsgjZA8qmHTYKI+WipLkDNzkG88vLwyudxFQZ1HTchOCtH4CZqSm94
         e78ykKDYM8TrnSGyTea2UcvIa67rgtR2kd0mEerHU8Op+43TGrXljzXY3Dq+XI4K6cU3
         SFhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770271713; x=1770876513; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AvtrECUNno08lmBFsY7oojO+h0Qj3mKXIQodqxeE2jw=;
        b=embKr/fJhN82v5PynODGffcKlq/tIJaRdEm7RHQb9iFqIiDITQ8164Qk63yBvtFkVM
         JjPPERhN3ONGqAw/8jTC+GMMh94HN6kYZwKIxDjuzpNyCW0ZYVqdahRziESSYbCSAhYD
         3c4+DVPrBN5nDpxMxQEGRBPWwtDtK7hIoSpEIa3T4BJTZCwoZdvXulJuPPHk38Er5++N
         /L6Ur1JPznCe71UfriB56L4woRipXNAnB2TB4ldNalPn4ofNxIuIW43BrGowR1MvVbtW
         gHufZOye9QYDcsCJNHkYbPh5FAr4pS+08UtSUKv/vG9vyYpnohf2lY1SAxeji13sbv9C
         bueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770271713; x=1770876513;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AvtrECUNno08lmBFsY7oojO+h0Qj3mKXIQodqxeE2jw=;
        b=TcLpM4gkGT7iWga4GThWUwFK81PBwosOKTqxuLlcgP84rJCI0Mi/SuUMRswZlcrXsJ
         RcVR5iBQ0++C7n7NIv4ZR80dA21SG1u3hVXG2+JSsbSTAhIqp/FSp8YzDw0URU2KUtLd
         vnEFcajdde5dC3EXovw7//Uy8us6oYeRdpf5pqR0albCV1nI9gf1g1Q3tCdeaH/bL8/D
         PEi8HXGpgEejyRrqCTAz1IXQD413OICl3yFtypFFzBymx7HIWGkyQDs8+Jj4N9YNY/pr
         E7cD+MjJoCD3k/jpGQ27bDvzZM8nd8yOSQCt8059N42QCN9SvZ6nHGQQY0GpcXM0ndSp
         3APA==
X-Forwarded-Encrypted: i=1; AJvYcCXSu8666O/WTO/s/JZWbisLlr51PoI9p6IlVqkCYPCs5V4m3x93Qc+i6+vj7Yal1EIVaeEvu3GPiA==@kvack.org
X-Gm-Message-State: AOJu0YxKD8FBfoiJWye81893gjRitod/PvRUXpEp/W+sAqvkSlkrwAc5
	CTWC515DCqpU28DJug8YR+Xf+it/qO0x7avb0dj9I8KlZx/wWhvleHf7hqk0zAQ39ld8FD/mrg1
	DrftbW65VIWLvQjG4RUk9ZA1SSgl2/hk=
X-Gm-Gg: AZuq6aJvOh27+SYQ+zyqadYXdf32V2dWHua1+I7qTILFQ2zBDS5C/GCDNbQOv12pAXs
	rEayCwNVne0TUyjkWRcF2kxFhCsTtfOk0Lgn4IenzQnSJlxDgYa2NIgzOOHok6w1ork8wVMnFUF
	MHrMoCJWkjm+MLGsp3lF6HxwtKcB3W8dtL9tuwG1ER8k0iwHHseexKYMlYY9KDtUGC1LDaNVP2K
	Oj6nAiZ8QqF3zNLufuzX8yNMo/bHjFLzr7XJfsny/Llfzt8azZSooG88FKRySUmXH4LpdI=
X-Received: by 2002:a2e:be2c:0:b0:37e:6e31:c9bb with SMTP id
 38308e7fff4ca-386a1051d33mr6748661fa.21.1770271713108; Wed, 04 Feb 2026
 22:08:33 -0800 (PST)
MIME-Version: 1.0
References: <20260201122554.1470071-1-vernon2gm@gmail.com> <20260201122554.1470071-3-vernon2gm@gmail.com>
 <fd67a91f-3930-4bd8-886b-13f7783f4aec@kernel.org>
In-Reply-To: <fd67a91f-3930-4bd8-886b-13f7783f4aec@kernel.org>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Thu, 5 Feb 2026 14:08:21 +0800
X-Gm-Features: AZwV_QgJ1itecnrz_WA9XDtkROxFA-nZhx6P3k0MURlrErGMoic8ckWxQ0XnSug
Message-ID: <CACZaFFNGFWv3FG8spJDLfLTe=0QWuBWL+Lbs+W3h9vGL=jrT6Q@mail.gmail.com>
Subject: Re: [PATCH mm-new v6 2/5] mm: khugepaged: refine scan progress number
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DAFBC0008
X-Rspamd-Server: rspam07
X-Stat-Signature: pify7otuh1kjbt61ibu54s7ba3sisssc
X-HE-Tag: 1770271714-419178
X-HE-Meta: U2FsdGVkX1+qYHcJSqtIq+zakesqd1kljs7TKj5IJ3Bp+skekDqvDo9WAqSf6Ert549PV03IbO0l9rKewbzO+ZuwlZ3Cuwc2QMZd/RJrhFLQZ+bnEPy06jx5W2ftZJHmNYjvVZk/fBQ5VOGgzI8tSdd8LMZHMF48hIZeiEd7fgBFu6SlUyF0YEtMjogU1wuodHW0NDq2AdXd9Iw+N1Za6nUEiX55d6CLWywamVOOebSmriq6WJP9p91/1FtG5uVW8+wPdNMWrcaH0bRcsrD9RbJuT2BOnrsMaLZyHT889ljjJgFTYTipDh05L8P3Z/79G/l9VExygq5dnDlCZvyyCVFU865QwmGfTaMfajogmvvGTCW54DBFdcGGMv9L4/eB++bMPBuVNRpBq1WEPKsa5mIscZQ1i6tlqP00UdoPsZsy3qjJT2PjEztaDIafm5+JmxbI41i6y/qQ7khIhSGjS4lPA0IVNc9JlBtkj3obanjsoMGwSjn8zzJLpVvVW+2OagpJm5/VG9SdDoo0C9nTyzOEwiczYYN6g3GhjFUNCWGlX0aZ/Y2ERDCfZrKJ/Alf8qbaZ2+qiGlc4e8O5gZ4TAf2Y4eAJDKiUJQgVmcRgjnjlwV8V6Tky1EC7J9T4YTEDF/qU6mzusDiPVYy+IlqMCnPevowWPYiTn6pv18Bi6hS6p50w86hRZXPdIKpDjIobI6zlcWnHECylqPE4psQIwNJJ7YM5zJQZrhy4rT0dCxoLMF4RjTYGOIVsuwmyJsA+ZwdmDph73aaXl3DSR+x5KYS3BPxDwbDz0547Mnf7hMKlK3zHYm3KIOg6JUGDV2Y0rJTveRA4bW4mgR6Ui5zX/25qb4ssARVu0AtaAw8T/JXzT0XrR5dNo6Ge688N7ifxQV5Hz4zHEPNJjwTFl+meleAcjo+4c2WjkBiaA1LgACh+MUlPMMdxNBv4LW6/M/0q90QjiY03ZBy+T4kwda
 MAjTYN75
 daqNBI5mlPUKu7l7drKmGMKxAxT6KWHLlSIwh8R43Rb1llMtKbyU35ghPI/Xq9q1IZTESIDwfFonI+wJWdCHahgONhNvKvSIofsNnfLaJWYbLd+uCQd8AJTrWuJFAPPq2YJvCH1LKnZ49BYDNd9iTxTM8yVx8MbArwy3yISr1GGzBIu3fnmiFXs7to6uq1XgwQWbxyjV9+hNM8Q5zwqdz0p4Gp5hKmZEXEXF60ZPjoPypRWW40Auux4q7Aaf4wU5r7zY7qPgFBwgZtA6zlaRt5RKjaJj/1wVT3vgN26nyx01LpHaS2zymTINrcdV9b1X7E4ZvwG1pSyMc4D9SqzlSN1IeDp15/RT3OBRlWoywewRQbHYfMXMODdRdvUrzAPbNQMa7g4sTNcli51Eh7aHOWViagbETXB7GXVMjFLBBjmtgWxJcLJjI+IQgngkyilBKY1G+K60fcSFL6xpxGz5Vop4M8ohr6jMoRWHxNuUZU+C0VmRFjBEdKEvHqxuilAO36wfmtm49N6hm2ps=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 5, 2026 at 5:35=E2=80=AFAM David Hildenbrand (arm) <david@kerne=
l.org> wrote:
>
> [...]
>
> > +     if (cur_progress) {
> > +             if (_pte >=3D pte + HPAGE_PMD_NR)
> > +                     *cur_progress =3D HPAGE_PMD_NR;
> > +             else
> > +                     *cur_progress =3D _pte - pte + 1;
>
> *cur_progress =3D max(_pte - pte + 1, HPAGE_PMD_NR);

I guess, your meaning is "min(_pte - pte + 1, HPAGE_PMD_NR)", not max().

> ?
>
> It's still a bit nasty, though.
>
> Can't we just add one at the beginning of the loop and let the compiler
> optimize that? ;)

I'm also worried that the compiler can't optimize this since the body of
the loop is complex, as with Dev's opinion [1].

[1] https://lore.kernel.org/linux-mm/7c4b5933-7bbd-4ad7-baef-830304a09485@a=
rm.com

If you have a strong recommendation for this, please let me know, Thanks!

> > +     }
> >       pte_unmap_unlock(pte, ptl);
> >       if (result =3D=3D SCAN_SUCCEED) {
> >               result =3D collapse_huge_page(mm, start_addr, referenced,
> > @@ -2286,8 +2301,9 @@ static enum scan_result collapse_file(struct mm_s=
truct *mm, unsigned long addr,
> >       return result;
> >   }
> >
> > -static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,=
 unsigned long addr,
> > -             struct file *file, pgoff_t start, struct collapse_control=
 *cc)
> > +static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
> > +             unsigned long addr, struct file *file, pgoff_t start,
> > +             unsigned int *cur_progress, struct collapse_control *cc)
> >   {
> >       struct folio *folio =3D NULL;
> >       struct address_space *mapping =3D file->f_mapping;
> > @@ -2376,6 +2392,8 @@ static enum scan_result hpage_collapse_scan_file(=
struct mm_struct *mm, unsigned
> >                       cond_resched_rcu();
> >               }
> >       }
> > +     if (cur_progress)
> > +             *cur_progress =3D max(xas.xa_index - start, 1UL);
> I would really just keep it simple here and do a
>
> *cur_progress =3D HPAGE_PMD_NR;
>
> This stuff is hard to reason about, so I would just leave the file case
> essentially unchanged.
>
> IIRC, it would not affect the numbers you report in the patch description=
?

Yes, Let's keep it simple, always equal to HPAGE_PMD_NR in file case.

--
Thanks,
Vernon

