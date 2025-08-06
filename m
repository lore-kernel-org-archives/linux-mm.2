Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CA0C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 17:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 754128E000B; Wed,  6 Aug 2025 13:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705178E0003; Wed,  6 Aug 2025 13:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F3D08E000B; Wed,  6 Aug 2025 13:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4FDC68E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 13:09:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D133E819C9
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 17:09:44 +0000 (UTC)
X-FDA: 83746969488.11.48BEE23
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id DA21720003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 17:09:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bN1mHeE3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754500182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxfvgCasWuA+gJKWPbYYwoEtVkgTH2JoUrawg5d9Ttc=;
	b=QaAukq2GNnvZ6P6I4ml4aKTZXnIU02ku2atGc7z97gXru4BbCYReEUBQqMZ6kgmAGFEYlX
	X2JKX5rjm/2CVzfYvuWDAOzox3Xpo7Qj5035o/yyneXoiZHIFF3Ej2fYBUhDtrMj/14fM5
	Qq/yuiN8pVYjU6xyDvEHUwvsABPYnPg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754500182; a=rsa-sha256;
	cv=none;
	b=qClPo4zZfsLu3Pd8qWoSjGWlXIT9raMEIG75tc1jtNX3GaVbqY40CfA1HNwD6vX2REb6YX
	tqy59vqRlbTdGpLHZOsSDIpnfUBQVAI8jl86sgGVtRvKpauplgAJYe+Dyl2vM7sdYlYk1Y
	1a9lbjUtYaz4r9Z4OV5FQ0Lp/4LO6Ec=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bN1mHeE3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b099118fedso20041cf.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 10:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754500182; x=1755104982; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AxfvgCasWuA+gJKWPbYYwoEtVkgTH2JoUrawg5d9Ttc=;
        b=bN1mHeE3u22sXHB+HHLs60Pg7S6F0hSmrttvWFt7QfpxGDdcHrhdhG4ljgMBqgSi6G
         KVXEdAU/vYdFQ39n7bOOEkYBp4noyehJ6dl8YfL7dMBpcAlkTjb+fq4IUYtNeC0ADLW5
         K9x3idVS3Fso/AE6p4V3FTgqxJmmef4wu7Lr/5zZpKPZ3C0rXHMs6PI+ybeC0P+K1Bup
         sLmWSk+rL5yP/+QQu9dr2Z88KEt2op90IbmMDT6/4R87F2lF71ZdDuO6uLkfywpcn2Rs
         E2Dbu7hWcAPG7QnEAzKQK8+LWby99inoVkJ64b8AH85UyjJ751hCTEoP7yU6CiUSONSz
         ZyXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754500182; x=1755104982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AxfvgCasWuA+gJKWPbYYwoEtVkgTH2JoUrawg5d9Ttc=;
        b=OiE6sx4p8oRHe/ICfU6u/w9j7fqx6IA7Ghx8B7qcHqnyM0V3RiutcKX+SYc0OQswYp
         vhfa/TpNoP4Zgj82LCBHzStALmubIEsIGWYTuXw+bTSUTNMYUgDawvkd9+g8791V4tby
         ueCVP5haqSLTLE3cgGFJHdQgpV6uI234JFeFZsdXZz1jR+W5H+4ld8y7BzgxBXeL82uj
         PSeagGnJcL9iwAqPhuF9Pnm04kNMNlourwOUN6s7PsdWoPRMuipCb+QL85WLqSPqy0oH
         xbZpj1MK87Epl0+Xv0f+0OW1FCBm16IkoiWzUnohdm+OxAjNCssO6yKvLlenXb58Kcb6
         bTjA==
X-Forwarded-Encrypted: i=1; AJvYcCVcyL0kQ2FY+Rm2Cfwhor4eX1TVsnFTd9UfOcNFGQKRXAZlAu0AWtB9NUMcKjq39LgnbkJFdbfKxw==@kvack.org
X-Gm-Message-State: AOJu0YyzHDKOyQxjZ+yneyEk3Tlr9H9j9JSYaA19mPS3vywDo+Fjztip
	BB4Pzz0Jht/vNGczhsu+Y5VuwZ9xKgUPmvpN0mJWqlmYQy/SwqGny3FuALSc3MfHNKEJivAQG//
	zgo2HZeQot9Gn1e/zm5PhjN0qKfEK0lckloirISDH
X-Gm-Gg: ASbGnctVMEtLYCxJBgVxnauvHBbsx2Cn6xBuDPWfDGHWOz5VVaWabT99eEimp4YvBIO
	SOAdNiwidKhu5mCn3lfw6RawqYHFJ4WsFu8kZ10YLPYMfgR83xDGdgLeg94mzlg6nd5SivljlvR
	uofZ4977mgQpPoDbyucF85pDFsPsXt2yBiygIzaDAM11iqQcUqpB7dwqxxOKsDZ7GYW3q/2PUm1
	pFA4UqemBFHRzqcMCjdUCTj/K6EBWYe1VW1OEnqBH6mNWKl
X-Google-Smtp-Source: AGHT+IEMhHGLxiZthvv92hddLeh6VUsA2wNqyUMxu2FRa4/Ps+p8BXpPEcOIySKHKsvBGcHbKtUDuUxzy9tvSikqDlk=
X-Received: by 2002:a05:622a:8319:b0:4b0:9c14:2fec with SMTP id
 d75a77b69052e-4b09c143728mr2217691cf.8.1754500181246; Wed, 06 Aug 2025
 10:09:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250806154015.769024-1-surenb@google.com> <aJOJI-YZ0TTxEzV9@x1.local>
In-Reply-To: <aJOJI-YZ0TTxEzV9@x1.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 6 Aug 2025 10:09:30 -0700
X-Gm-Features: Ac12FXyt05U3kXqXIXEA0tOR0TWPYJFTgr2w2Z1A_F-UmeFYAUN8QHXxx2B-yHA
Message-ID: <CAJuCfpGGGJfnvzzdhOEwsXRWPm1nJoPcm2FcrYnkcJtc9W96gA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] userfaultfd: fix a crash in UFFDIO_MOVE with some
 non-present PMDs
To: Peter Xu <peterx@redhat.com>
Cc: akpm@linux-foundation.org, david@redhat.com, aarcange@redhat.com, 
	lokeshgidra@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1mpysnqu9d9cx4xqpkwtmqtzpuag5hdx
X-Rspamd-Queue-Id: DA21720003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754500182-415631
X-HE-Meta: U2FsdGVkX1/hx0J878ucTI7mc9Yu3BXb14WbZHmUbbWy0Y0IDGOfurfHppwXX9jNy0db7jjP4zIxTuzS71RT/PfrQf2DtypbIwCbZ2r/FrsWDYSEsuTd2oplZGnWfXBU+832LhfsWMCxGugBoTEoDjFjLp1Rl7xYFa7FRhy5/Ksju8ME2hsfIiVqwadD1obwLvNXG7A3gQcbAKAK6EfchixHgIarhNUumqglCrtd8B7jId2xFWOUNIapU9nHPRZx4gvTItvGEypyDiNT5RtbYQK6Xw+ZlQ/fLFqZFIoR1l14f9oJx/tl0oZgtt0RO7QaEezSTgvCwAYS3IQqu58SYhL3Lox3BkYB7tyH99OZtjpJO7lHQTGYZZdq4Lvg1wLydICW0bJU+6lFBFhKBDxa/WwWUJZdNTmcgN01v69KnYQ5WwmKG+POX4dSFk/+hr74gNuDvNNKxAPyyb0sFICJnxXINbKWFGeGYHS1/b+Vcbe3G649grXf7lrrC4FTWVhTSOyEQHBI6F8HFA8mcmEadSwNVjSHwKkacDPf8jFVj2kgUWwDMNvpKF5z7wyiR8X9Moe1nMdWaMMSD9iMnxg0kKBWPnmHSfl5Gbcnmr+u3tiCAuzOxZf5kHyzadmS2+KunlLnXkJD04ccmFmoTIJhkpCPrZIH4DhXUbm2DjGTInWH3Zt8BZrxmNlpL4JeokL2tIl18UKjhO14IqCPv9jVYYuTg7/wRHy4qB0kUVsgKcw7LZ5fgNv0onGB+Az9oQQDOwe6bpdDLx9I141Zi1f1iupMqUFWmtKqJXhpeYxlSSZbPIIdAsnX84YX7lgbSl0PYCEe1iGOI7/+O+Ti/wIu19LtwCQl7ydylTFaRhw78B8FA3URRQphBszYD0PPGNsGiptJTVh/PwcDFJDtPO5C1Bu/xQwi2Y+fqgX++5S9dsT/Rw8AnaOc2AFU0UpT+Dk+tONuuoPujie4pAaW+gd
 NlpIkAMj
 6+JY05m+5bbOT4IUK8TfqmrDlX77PYe5/ok2fQTMrEkkqEPafWpF8GdQXz7+UG8ITM5lPkXroCErnuG0xILo2G99M6IbPz26ki8ZVfeyZ8swaCICwKpVfec3u50SDPXrt0//n0s/jpKieyhtBqx9pTupDAvoYPcXp0KTX4xwPqdHkdrh1TmK5Df7Jd3DrQH09tDKmEZg0ZvX2UZV041fH31Eb/DLHnEpcOOvTQtcPaG1v+ngRmFIg37msvFBaB6/LDuo1yunNG0U2QYVJfF449VVRaEaMrNib2qu4PjD2mFsXKInKIosi3uUgcFv+uS50mDNf9MemcWHe9btHWBYo/JBcAq7Squcn/Z6cGg5jEZhcNOlzWDxUVMcKsl9WxDK04h1UPdQ+T3ZDAP352GGeXmERhh8z2LmyJGKBeaYxhjkDg2JWCJ1xgBk9VkdNXg5OwNwlifXUpN+VYOxwO/MO9ENioUx3m/gd2jXHMZP1SzmpcjrxP3Qqw5SWIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 6, 2025 at 9:56=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote:
>
> On Wed, Aug 06, 2025 at 08:40:15AM -0700, Suren Baghdasaryan wrote:
> > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
>
> The migration entry can appear with/without ALLOW_SRC_HOLES, right?  Mayb=
e
> drop this line?

Yes, you are right. I'll update.

>
> If we need another repost, the subject can further be tailored to mention
> migration entry too rather than non-present.  IMHO that's clearer on
> explaining the issue this patch is fixing (e.g. a valid transhuge THP can
> also have present bit cleared).
>
> > encounters a non-present PMD (migration entry), it proceeds with folio
> > access even though the folio is not present. Add the missing check and
>
> IMHO "... even though folio is not present" is pretty vague.  Maybe
> "... even though it's a swap entry"?  Fundamentally it's because of the
> different layouts of normal THP v.s. a swap entry, hence pmd_folio() shou=
ld
> not be used on top of swap entries.

Well, technically a migration entry is a non_swap_entry(), so calling
migration entries "swap entries" is confusing to me. Any better
wording we can use or do you think that's ok?

>
> > let split_huge_pmd() handle migration entries.
> >
> > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@go=
ogle.com/
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Cc: stable@vger.kernel.org
> > ---
> > Changes since v2 [1]
> > - Updated the title and changelog, per David Hildenbrand
> > - Removed extra checks for non-present not-migration PMD entries,
> > per Peter Xu
> >
> > [1] https://lore.kernel.org/all/20250731154442.319568-1-surenb@google.c=
om/
> >
> >  mm/userfaultfd.c | 17 ++++++++++-------
> >  1 file changed, 10 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 5431c9dd7fd7..116481606be8 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -1826,13 +1826,16 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx,=
 unsigned long dst_start,
> >                       /* Check if we can move the pmd without splitting=
 it. */
> >                       if (move_splits_huge_pmd(dst_addr, src_addr, src_=
start + len) ||
> >                           !pmd_none(dst_pmdval)) {
> > -                             struct folio *folio =3D pmd_folio(*src_pm=
d);
> > -
> > -                             if (!folio || (!is_huge_zero_folio(folio)=
 &&
> > -                                            !PageAnonExclusive(&folio-=
>page))) {
> > -                                     spin_unlock(ptl);
> > -                                     err =3D -EBUSY;
> > -                                     break;
> > +                             /* Can be a migration entry */
> > +                             if (pmd_present(*src_pmd)) {
> > +                                     struct folio *folio =3D pmd_folio=
(*src_pmd);
> > +
> > +                                     if (!folio || (!is_huge_zero_foli=
o(folio) &&
> > +                                                    !PageAnonExclusive=
(&folio->page))) {
> > +                                             spin_unlock(ptl);
> > +                                             err =3D -EBUSY;
> > +                                             break;
> > +                                     }
> >                               }
>
> The change itself looks all correct, thanks.  If you agree with above
> commit message / subject updates, feel free to take this after some
> amendment of the commit message:
>
> Reviewed-by: Peter Xu <peterx@redhat.com>
>
> >
> >                               spin_unlock(ptl);
> >
> > base-commit: 8e7e0c6d09502e44aa7a8fce0821e042a6ec03d1
> > --
> > 2.50.1.565.gc32cd1483b-goog
> >
>
> --
> Peter Xu
>

