Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E20CD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 17:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 354A76B008C; Sun,  3 May 2026 13:24:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32C366B0092; Sun,  3 May 2026 13:24:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2423C6B0093; Sun,  3 May 2026 13:24:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E4BE6B008C
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:24:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B65D916086D
	for <linux-mm@kvack.org>; Sun,  3 May 2026 17:24:52 +0000 (UTC)
X-FDA: 84726783624.28.10DF898
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id C55C940002
	for <linux-mm@kvack.org>; Sun,  3 May 2026 17:24:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B+hNf4mU;
	spf=pass (imf27.hostedemail.com: domain of charsyam@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777829090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JY5LSBoQoK2scNI9ks7oXEsa9hffwFwJ1QlfXrt/gD4=;
	b=SgGaFfOu8IB02dqytmm1xtputIPXiwPXAz+cn8z25mEWv+fzQI1mxmoxUWaCq260WNrTdP
	5xODoqLNgl5+ZmWVcNIq5o9CcldiLxsq49EHIqYxJZ0xSzVxIJYTIvm5nX7sPc+1Zi3eWF
	mt0btUjr7pfipLH/hm95s2iG/xvzJlo=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B+hNf4mU;
	spf=pass (imf27.hostedemail.com: domain of charsyam@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777829090; a=rsa-sha256;
	cv=pass;
	b=oJVpbHQiAgBuJBTJhtOTN4GsYJWtXO+9JJtNOqPJDuNXO2NzRJ0bsQJqrsX5ULx1AmFJig
	FRzCdUhvsr6Wiyq+5bzOJQnbB49+1L5HlOU/4FG49pEUnEge2ypDLHCXx90bPL9jC+Zgbo
	q7Eq7oj5xQGiatOZtBe2emKNZWRlJIM=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-65c2428c49eso382452d50.0
        for <linux-mm@kvack.org>; Sun, 03 May 2026 10:24:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777829090; cv=none;
        d=google.com; s=arc-20240605;
        b=DB2G9XtSSCrdr9xzg/Wi+C/TznqypJxbwq+rurCgn+e9rF8+Zj+AcYb/a36C1P9wYX
         qjArGOgUHNQpRaOJY5bQ/mbr7ORMF31w2XlQVKesUXIURTWxZM9J4lJo/0ECdPEUheON
         P143+6V7zoaGOEBeWTs74hNtJvCswJqiWjm25YNGPvKNk7814lBIhvmKVI+A0UhbpQ+/
         U2nRfdauy6dIHA1S0T+ROemGpDDAhGTM2/EzIeOiAS04li+t7Po07oAz6DXcwUOlCGJA
         N87obOZ0pJ5yLAQ0kT0zdSIHyeBVTawgbes1xyu7CDd/512GYcN00+N604PuA4wIbCrK
         X5KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JY5LSBoQoK2scNI9ks7oXEsa9hffwFwJ1QlfXrt/gD4=;
        fh=SG/AYDaTBXN2+W7FtWL5FWQitjkN2WrvaLSbAf6bMlI=;
        b=Vf42A6hUuqit3v4TnZMZ+2vktpngmsV47ZHRLg4/WsXCavqdhiKHLPVo1LbK9ohxoj
         cLmtnVbuaOCLdSj/AoiorqMRj79IYcqGrH+Abh4+fIaN1XJjeyO+xiLc5ym/VfXDbpLL
         zBaZHPQmrl0DZXv4dNkEgNqoexOIElb0sUAz0VmkgKMDaTsZ/ehe42ioQFXjAT9Mb685
         CB5DSLNSoYeVacG7WOOvWlCep8a8xURXnR60reg6O/dNrtZzGEkS+U+o2lmCnhfPcC32
         t/5MysVqvQW1Txjdk0iLjt7WNd8DxVptVPmPTcpNoRkzgFyqXuS+OQvOLpbv1A0k7nya
         CkPw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777829090; x=1778433890; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JY5LSBoQoK2scNI9ks7oXEsa9hffwFwJ1QlfXrt/gD4=;
        b=B+hNf4mUiD8wUnN6Q8hJD71Cpy7t3k1oqTWMOVvCxEwp+VdImSv8EaQ2Bc8ppUdPXq
         V9so2BCfzN4NhJekQYtbLo+adt58ayLTf/m9T0IUiEMX/OAy0wENDWYV/VugwFPBznZS
         trYoVg9aVVt95E0OEdJTGnX9cRURBW3dGTD4Kr8Z1+T25uEHho0C7ELg8C4hRONi7Zt9
         jU6+04JPReB9JqB7MjCGXE7TxTLSeOCj9+r5IL/yENz7Ot/ocIfiymNrtwNtg+ArQD4j
         DpIei5cAZkWB0GmKnYideQd6hR8WfnhD61yEpozcwaxzLiNon6d30aN2VSalkil1SsuG
         H96g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777829090; x=1778433890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JY5LSBoQoK2scNI9ks7oXEsa9hffwFwJ1QlfXrt/gD4=;
        b=GEOEInKpA1b44Hv4xsXoEWAIZZGsxa8VbzqSss85BAph3LqJWr4/7lRUN1CD0dViFu
         ZjzPopLdiQ8IjoC6232VHWcvRUDFRUQz7lIxSFV+Hp+mQ//JzEYZAhFtfbHcCspDtwQV
         ey41rHe9sxOi0zWYhbzHuNZNIwyDHgShp6hAK5pjP2JXDbj5Zu8Yy1NeEfDLCfi/gWpj
         hryffW604aCVhPdFroq+tBm1DmNY5/dFm70IZg+RPFoh7rVRliewRlNflP91UZQD+H4S
         xpmsprRAmalZCzQ84x4qf5VveLp6/Jit/+g1tWCm1fxbj/jzfm6Q/Rzz8W9ttqxU3FhY
         GVbw==
X-Forwarded-Encrypted: i=1; AFNElJ86QabbGGrCel26CM40MGEaRdTcxXQy11Drb7cVand94rQubWxqxxPEB8xvgWyVYtNwqdilj9Tifg==@kvack.org
X-Gm-Message-State: AOJu0YxvRSHjIpC0bLYJDLhruU+FufSxgkadBAfsuiiiNpTe2VG9CtEH
	c0iFiti24kxsjJwg6JSyS/oaPThvCGpPb/E7kNxqYbsvZzsZgEJa1S96x0lNFKERfcKDcg3K9Ou
	PfPPuy6balALOREEhlYd6G8tMxKuDkWA=
X-Gm-Gg: AeBDiethZZoUgJY53EYfzE4kgSy/J0BbNqGXs0TajMY+HAZBgwIUVj7APMb2MylqEK4
	u7Pfuyo6wAGUoEDaNSlflcIeghuXy26qY/Zj4ghT+sn3xBYk3bZOvOrDUfr+XXuzzdS78CU/fmc
	g4Gai4Ad25W1H19HVkBCzgB7Z3PvNkU+Tsv/57ZUMzS/iKM8OQ1y/LUF7c9kO1Bv6nP1LRCB9zW
	tg9rx/N1A03IJy3GcrUkrlycVukXSNPjJzhKl0gSAgcexV2Tk+OVoqvbrRs5P8CK8jA3+ZLl8Ue
	Fd0/TyPdkNOZE2LKHBU=
X-Received: by 2002:a05:690e:1509:b0:653:9e2:1059 with SMTP id
 956f58d0204a3-65c3d885405mr3910018d50.0.1777829089678; Sun, 03 May 2026
 10:24:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260430195651.287659-1-devnexen@gmail.com> <afUih+XwGTHsR0HY@yjaykim-PowerEdge-T330>
In-Reply-To: <afUih+XwGTHsR0HY@yjaykim-PowerEdge-T330>
From: CharSyam <charsyam@gmail.com>
Date: Mon, 4 May 2026 02:24:38 +0900
X-Gm-Features: AVHnY4LrEw5_6VQukKkSO0GARd7hylbgWbog9Ju3xEhrnLElgO_VmcGdg9-i61s
Message-ID: <CAMrLSE71rs1TyoFwCjChY4bEMX-qz01_QKdkAUQmZOSrMMEzbg@mail.gmail.com>
Subject: Re: [PATCH] mm/swap, PM: hibernate: atomically replace hibernation pin
To: YoungJun Park <youngjun.park@lge.com>
Cc: David Carlier <devnexen@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C55C940002
X-Stat-Signature: 1ca59zrzh8x889rt4ky8rqyy73ejxd9c
X-HE-Tag: 1777829090-815303
X-HE-Meta: U2FsdGVkX1/ojCaAkLrzmvv65yG42BQF0wqrbeuk4uhi3aN73dge6TEiq+Ix1VpLTn6PLE4z5mtfCiX17b9JxnpjRY5w2olVrnit1PM769JDSRmLSN/hRrWX9ac2Ueq2BLsRlDy4dbrlGiVOvimJEF78UTabUfPziZEEz+VsiyYPROL1cXEd9j8DYBOSAGYiMPY0u8ZrW1JKzPnS7EzbH/4x01FlL6PkbVt/Jh8oOIcwg+CaEJwVtl5orLe9py24rYEM0xcgjOnF7zZ1m4lZCSo9L4tfedsfamiVnjQyjyGHkYXPHusSHSUB8YLCAHze2NuG2Ll0vVg2v4BWqt1ugg1IcKMZGVGrZL58DuIRQLIJjZVnEARUqjdz72m8c8mRgWGBD3UD9JpXN1WG2GHYLt2nfOuiOq+NlJH0TfLr0BUTjlPa7qg0acTh/eUk0Hegg70fYTmweYCJ2zTQtWiAsJe0kzrWcNfXbDGiL7XVXU0ZPMwrNIRisiEvYwwOksPIPbH3jAV7azenjR3n38Cj9UUZvBYbfT1y42wPW525pl2ck38lx95ysZXlOgWlOz29mLPxacUNkQH7zFeVCXYMIEdykwMM6REDxl1JgBXfDR3z0/Dkpip5UhLA49hI8qPUIIW/Rcq2BkzvV3C5l+Wgj9a2PLmGptmqrYQJ7OzNbYe2eR2EoCSyS3SAQ3ct+SH7rQtoalvDckQfG/wmLQxhtuG9+WsneZVHUxL4KQm5B/raOMwCy96ZXa4Ob/pcDjKMabgKtrfqW9mXnKJz7r/BG+MEAXQs9NzMhZRcM/FJNM7tEtAl+Ub1bHqknD2ukTns88ESo3vcmp3to/ndXN0PAQVQyM56SxkJxqnEOfoCWjmqCG7NsDOvOUMdqRGc9NyCiuO0nSw4yPvvn2YSrK2ebbqiHic2YN0TYG70Q0IRczXaxUaIkGjR2oEYE7l0gI4EoYfJH+Mkl3Hk7nPtsnP
 qyJapIdv
 O475ju5OD1U+3Il32OGX7Bb0lmVN/yxIAqvqd+s/s+vBy5TwOmc34bUJ27/5JG4DtYRmnGnm3n7G7t2Ly1yy4hKB8qPoI/Eu5Yk1Van6zyfC4JGSuATiBOEPO7vXgwgwOKQAGB83bO5g0q9ihB0PphBl1EvKbxi1RC+5EjiiPusjK07eaGQIsUIhcfnGBtvytixmk33A1LzIiAaUDxz65iJASqAdtmFdqApqF14vJcslL6O9dGA/nygTGlVSLJbnXjd/Psr2jREyZjHCNOj0pmBB5EnPhVBp3vIgxlvcO3aHbTSb9fKYpp+nyo5P1m/rwmdwDfJXnik+q9tw2hBMhp6IPpT3H20VOuEEuSrA8P4ZtFRIaaKA3mKzdqPx40H7Ea9kuthqckSOIxHFvLz1v2RsljmIoj7tKtMKLRy+QviHnGDwPd6MCJdd1KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David, Youngjun,

Thanks for the discussion.

This is essentially the same direction as my v1, where I introduced a
repin-style helper to transfer the SWP_HIBERNATION pin under a single
swap_lock critical section.

After Youngjun's review, I reworked it in v2 to avoid adding a new
single-call-site helper and instead reused the existing
find/pin/unpin helpers. The current v2 approach keeps the existing
pin on failure and avoids introducing a new API.

Given that this is more of a hardening improvement than a strict bug
fix, I think the v2 approach is a simpler fit without adding extra API
surface.

Happy to adjust if there are specific concerns.

Thanks,
DaeMyung


2026=EB=85=84 5=EC=9B=94 2=EC=9D=BC (=ED=86=A0) =EC=98=A4=EC=A0=84 7:00, Yo=
ungJun Park <youngjun.park@lge.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On Thu, Apr 30, 2026 at 08:56:51PM +0100, David Carlier wrote:
> > snapshot_set_swap_area() unpins the previously selected swap device
> > and pins the new one in two separate swap_lock critical sections.
> > In the gap between them, swapoff() observes SWP_HIBERNATION cleared,
> > bypasses the guard, and tears down the device, reopening the race
> > the SWP_HIBERNATION pin was meant to close. The window is reachable
> > on any SNAPSHOT_SET_SWAP_AREA call after the snapshot device is
> > opened for hibernation, and on any retry after the resume path's
> > first selection.
> >
> > Add repin_hibernation_swap_type(), which looks up the new device,
> > clears the old SWP_HIBERNATION flag and sets the new one under a
> > single swap_lock acquisition. The same-device case is short-
> > circuited so userspace can re-select the same swap area without
> > tripping WARN_ON_ONCE and -EBUSY. Switch snapshot_set_swap_area()
> > to the new helper.
> >
> > A failed lookup now preserves the previous pin instead of dropping
> > it, so a bad SNAPSHOT_SET_SWAP_AREA leaves the prior selection
> > intact. The open and release paths keep using
> > pin_hibernation_swap_type() and unpin_hibernation_swap_type().
> >
> > The race was identified during AI-assisted review of the
> > SWP_HIBERNATION pinning series.
> >
> > Fixes: 8e6e0d845823 ("mm/swap, PM: hibernate: fix swapoff race in uswsu=
sp by pinning swap device")
> > Assisted-by: Codex (gpt-5-codex)
> > Signed-off-by: David Carlier <devnexen@gmail.com>
> > ---
> >  include/linux/swap.h |  2 ++
> >  kernel/power/user.c  | 17 ++++--------
> >  mm/swapfile.c        | 61 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 68 insertions(+), 12 deletions(-)
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 1930f81e6be4..213ecb627a39 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -436,6 +436,8 @@ static inline long get_nr_swap_pages(void)
> >  extern void si_swapinfo(struct sysinfo *);
> >  extern int pin_hibernation_swap_type(dev_t device, sector_t offset);
> >  extern void unpin_hibernation_swap_type(int type);
> > +extern int repin_hibernation_swap_type(int old_type, dev_t device,
> > +                                       sector_t offset);
> >  extern int find_hibernation_swap_type(dev_t device, sector_t offset);
> >  int find_first_swap(dev_t *device);
> >  extern unsigned int count_swap_pages(int, int);
> > diff --git a/kernel/power/user.c b/kernel/power/user.c
> > index d0fcfba7ac23..6e4f40e49319 100644
> > --- a/kernel/power/user.c
> > +++ b/kernel/power/user.c
> > @@ -218,6 +218,7 @@ static int snapshot_set_swap_area(struct snapshot_d=
ata *data,
> >  {
> >       sector_t offset;
> >       dev_t swdev;
> > +     int new_type;
> >
> >       if (swsusp_swap_in_use())
> >               return -EPERM;
> > @@ -238,19 +239,11 @@ static int snapshot_set_swap_area(struct snapshot=
_data *data,
> >               offset =3D swap_area.offset;
> >       }
> >
> > -     /*
> > -      * Unpin the swap device if a swap area was already
> > -      * set by SNAPSHOT_SET_SWAP_AREA.
> > -      */
> > -     unpin_hibernation_swap_type(data->swap);
> > +     new_type =3D repin_hibernation_swap_type(data->swap, swdev, offse=
t);
> > +     if (new_type < 0)
> > +             return new_type;
> >
> > -     /*
> > -      * User space encodes device types as two-byte values,
> > -      * so we need to recode them
> > -      */
> > -     data->swap =3D pin_hibernation_swap_type(swdev, offset);
> > -     if (data->swap < 0)
> > -             return swdev ? -ENODEV : -EINVAL;
> > +     data->swap =3D new_type;
> >       data->dev =3D swdev;
> >       return 0;
> >  }
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index c7e173b93e11..4840fd40f36f 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -2219,6 +2219,67 @@ int pin_hibernation_swap_type(dev_t device, sect=
or_t offset)
> >       return type;
> >  }
> >
> > +/**
> > + * repin_hibernation_swap_type - Atomically replace the hibernation pi=
n
> > + * @old_type: Swap type currently pinned (or < 0 if none).
> > + * @device:   Block device of the new resume image.
> > + * @offset:   Offset identifying the new swap area.
> > + *
> > + * Look up the swap device for @device/@offset and atomically transfer
> > + * the SWP_HIBERNATION pin from @old_type (if valid) to the new device=
,
> > + * all under a single swap_lock critical section. This closes the
> > + * swapoff() window that exists when callers unpin and re-pin in two
> > + * separate operations.
> > + *
> > + * If the new device cannot be located, the existing pin on @old_type
> > + * is preserved and an error is returned. If @old_type already refers
> > + * to the same swap_info_struct as the new lookup, no flag changes are
> > + * made and @old_type is returned.
> > + *
> > + * Return:
> > + * >=3D 0 on success (new swap type).
> > + * -EINVAL if @device is invalid.
> > + * -ENODEV if the swap device is not found.
> > + * -EBUSY  if the new device is already pinned by another context.
> > + */
> > +int repin_hibernation_swap_type(int old_type, dev_t device, sector_t o=
ffset)
> > +{
> > +     struct swap_info_struct *old_si, *new_si;
> > +     int new_type;
> > +
> > +     spin_lock(&swap_lock);
> > +
> > +     new_type =3D __find_hibernation_swap_type(device, offset);
> > +     if (new_type < 0) {
> > +             spin_unlock(&swap_lock);
> > +             return new_type;
> > +     }
> > +
> > +     new_si =3D swap_type_to_info(new_type);
> > +     if (WARN_ON_ONCE(!new_si)) {
> > +             spin_unlock(&swap_lock);
> > +             return -ENODEV;
> > +     }
> > +
> > +     old_si =3D swap_type_to_info(old_type);
> > +     if (new_si =3D=3D old_si) {
> > +             spin_unlock(&swap_lock);
> > +             return new_type;
> > +     }
> > +
> > +     if (WARN_ON_ONCE(new_si->flags & SWP_HIBERNATION)) {
> > +             spin_unlock(&swap_lock);
> > +             return -EBUSY;
> > +     }
> > +
> > +     if (old_si)
> > +             old_si->flags &=3D ~SWP_HIBERNATION;
> > +     new_si->flags |=3D SWP_HIBERNATION;
> > +
> > +     spin_unlock(&swap_lock);
> > +     return new_type;
> > +}
> > +
> >  /**
> >   * unpin_hibernation_swap_type - Unpin the swap device for hibernation
> >   * @type: Swap type previously returned by pin_hibernation_swap_type()
> > --
> > 2.53.0
>
> I also caught up on this thread late due to travel.
> Sorry.
>
> Hello David Carlier,
>
> It looks like the same issue and approach was raised previously:
> https://lore.kernel.org/all/20260414143200.1267932-1-charsyam@gmail.com/#=
t
> (+CC DaeMyung)
>
> I had suggested improving the fix by reusing the existing APIs
> rather than adding a new one. v2 was posted along those lines:
> https://lore.kernel.org/all/20260414164937.1363887-1-charsyam@gmail.com/
>
> To restate the points from that earlier review.
>
> 1. I think it is acceptable to release the existing pin when the
>    new set operation fails. there is no significant side effect
>    (see the earlier review for details).
>
> 2. If we still want to fix it, reusing the existing APIs seems
>    preferable to adding a new one.
>
> Chris, Andrew - please take the prior thread into account during review.
>
> Thanks,
> Youngjun Park
>

