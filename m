Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7F1AC9830C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 02:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17406B00E4; Sun, 18 Jan 2026 21:18:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5AA6B00E5; Sun, 18 Jan 2026 21:18:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D686B00E6; Sun, 18 Jan 2026 21:18:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 78FB76B00E4
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 21:18:31 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD24D59C87
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 02:18:30 +0000 (UTC)
X-FDA: 84347104380.12.5FFA1B4
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id D70FB140006
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 02:18:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Hr91gsZ/";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768789108; a=rsa-sha256;
	cv=pass;
	b=lgnwt/KzBB9zUeESg1KC23ukzmjYKFJPNnuf4FS83thsyYHQ2ZN9ZB8IMUVCQGNeJmlmhk
	VVEo33e0DlA8RG5syvay5ofJ1eaF12h+MPeQCKvkppzMCHRkNusZd3iOpleCuGRrPatHa6
	spQeZp1ss/lUGEhJxtRnJWo7AHG4Efg=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Hr91gsZ/";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768789108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbVqX0y113pE3VuBeoL43QiSH2p0tgUteB/1HKVBpKw=;
	b=rFuK030IMevkIngtOWyj0DxK7dpBXJdftUqi+84qltO+LJiD+sKX+2Jo41VjMpdw4J/fk/
	PzgkQnGomzp/NMAlzJvqrBVI+4m2OQt+GiS6pqZ76x4mb20/dy5XY6PbXNWNKkSUAfHPNe
	h2jXO9dhxD+wEG8yhKh9f5t4g4DmLCs=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64b8123c333so5917662a12.3
        for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:18:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768789107; cv=none;
        d=google.com; s=arc-20240605;
        b=Inn/IdL9TsDmmErD0JbNM9+GyfOblTcbunFhKWjeem1cEoJvXr826P5XBjp/eVSJQe
         gQtCaP2hKw8VigxpCR6lp3H4AZwIkBCqIJJJN3I8g/agJ8AXCvHzM/O+JL88m9n6mTUR
         m9GxAw+nEgtNzWIIMEDw+IpEmHQyr3/cHgAamIZgGnYEP123HxJh/bY0BO1xBy8WrVhO
         k0lG8at5ZYU6KbDf+34Q9clCsHJB9EWaceS6jQw11mmKmCpqUJ3SiJZCxzazszessxhP
         AEbQJgS0KCoQdPTzFFL8oSYgRQ5pIs0bGELTfaU/g6Qk72IVD+FqeIzUCQ/+bH2XEcp1
         Cj+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lbVqX0y113pE3VuBeoL43QiSH2p0tgUteB/1HKVBpKw=;
        fh=BQyBgRwOzA2wWK60fJ9ODsbhoj5mJQggKlF/Edtm6fU=;
        b=TlTj74YjRoIxcsca67Bcq7g8L0QGZsQGokYR2OGa68gKNdDyNeiYHoURy7piSGIX9s
         /Oc6numyvX9uz9quKRXAupRdZniiCoR5WdS2Emn0/0y30IIWPCKa53XJiTbPAxIAyDTH
         zFH34tgkvZ3f5iaAN01YW4ho8OdxWN05ko9lXqyjIIDRGfcfrKofOj/X2Sf2tXNPIe9V
         3pzoC3Qxv3l7h8xDgLneedLkrqZSmko18TXRhocZjJXNP0L3e+wy3CcOodOobqGvdOMO
         K1OGjytEftW1qKHWlGzqkjO9Yi/l1aJ7YCwXuj3HYmwL5wRZbmbAXmqBISKP60O9Mfnd
         JlEg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768789107; x=1769393907; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lbVqX0y113pE3VuBeoL43QiSH2p0tgUteB/1HKVBpKw=;
        b=Hr91gsZ/CFomL1ZjjPS1DnwoDIWqN3euTQLI8OooUENGins33PTDrePjltd4nQU8uZ
         OLBL37lZOvzCedGB2aaJWK13FQsf4Cf4rOzVpQSdohqyQ0pw9bgAi2z3q6TDyh7+79oq
         rvv67tFmOoSgPInHpI4hJQQPXCHeRobYCuZbolIAXUihX4MvJpO61OOiMCvaSX1DeOZo
         aEwvci0OMT9wYpYVw918AHGnhlFu9BANTJ57pK1eeiWjr7poJVme7Yz+RIsZErPmFU7X
         VZDrvYd1q3CBUdI273DTz7HoDk7T21bRAJw246LIJ3HYNU3Eb3HgPUFMXK2DB1JZMgS6
         Onyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768789107; x=1769393907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lbVqX0y113pE3VuBeoL43QiSH2p0tgUteB/1HKVBpKw=;
        b=ppjH7GnRf2T7KY7odnoiF+5DXlcMYtFO7ffK1A6IPW/ypAwEImBmspMYgRzii+6ulF
         otI6SXiTLG2VZ7/9vCazHmfuuhmfPknEFYub/ZvVU5N9v8stjvLNMyoI0kPxPwy6YQ3x
         X29pM2RV/CYDSMgMpoQZFouDQfybLKqqS1sGHI9lgsJFTk4X5qlkpv7kAy7Q/kMehYQO
         yTsVjHlVnO7ZrK6BK7XPqVDc3C7hQyR2NMDfONiwTLGyq4ZzFRCXJZjG8x2Ot7/LWJFi
         4ZRVJIjTSll80LmB91Oa+uxZvJ4RYV+K5TR2fbKwaNYknIfkBX87qxmnsDUB8F/zaaLd
         NUYw==
X-Gm-Message-State: AOJu0Yx2XFA4dsuMqs0woqF5pdky5AN+DEHrkxp7W+TSt5xvVgh0Q4O2
	P2pha/VWPMuWz5UhLBKEyKvq8BKSViSKpR7s5OYtI+jPEfbSKHDNoCJ/KhNJfw0fVIF399gcnLy
	LGV1KBZLI3AQvxfNy6DfIrRsq5r19wAc=
X-Gm-Gg: AY/fxX5YSQqJnorFXqlaEwit0mwHaYJ11MZgrdDfFRXFYdY3VroQOIIEV2TbToI/i4n
	ZrH3pMWroM2oBrnyEcgzqy+N0RaE917FSZ+cFTNFX+ghJBAoRr2plvt0xhv1Lkcy5kcZop+UnF7
	1+vf1lil+tzZh5amXECvt9xTfZxalRNH3gL0cTLbjWheNC4VxNkcQRiL3QM3+rM4zv/wHJFzd3r
	6rhfAXNYS1qvrm3qGfAnXbZ3ohFPdj8hB1csjrkfvKBJEw1q0evq/ZIoB+iFSxi7DP82eK9oNzP
	cV7WwYRLRMTQl/2vhw5NH4V5PbA=
X-Received: by 2002:a05:6402:2709:b0:64b:63d0:90b5 with SMTP id
 4fb4d7f45d1cf-654bb32c773mr7864449a12.17.1768789106902; Sun, 18 Jan 2026
 18:18:26 -0800 (PST)
MIME-Version: 1.0
References: <20260119-shmem-swap-fix-v2-1-034c946fd393@tencent.com> <20260118113315.b102a7728769f05c5aeec57c@linux-foundation.org>
In-Reply-To: <20260118113315.b102a7728769f05c5aeec57c@linux-foundation.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 19 Jan 2026 10:17:50 +0800
X-Gm-Features: AZwV_QhWLKnQHBcRkTfFshMsakcIqTl3ORpdLGOWc9aOTRMJJIchJq1TGdxna8M
Message-ID: <CAMgjq7AA1LoLopoFrmRBh5KiL75VtBORfTaR2Lafq3OttD5cDQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm/shmem, swap: fix race of truncate and swap entry split
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Chris Li <chrisl@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 39hhaju5jw6gpui4zsuugtmmu9ikugki
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D70FB140006
X-HE-Tag: 1768789108-475770
X-HE-Meta: U2FsdGVkX18LITVMDct58qDm7G/pB0ByGPBBoNc5bKqPLNVVppjGosi1SdnyqhkUmLK4zOaPe44HoxHb0uGuncba18VI92qQiwAbRrwcdoyFTYCyjYoLL5/RPv+MRY36+DnklYP+Qe+qzlXbRmAXcyZQdvC3uerHwqFluIGVy/WM/8kVEZBAykRW2kgI/YBnVS0RCE57K/FzsaSMWKa85rXJcuWVo8qM1y0EAmKKyElxcPr/ohUrqAWGnnJlOndwk2qok9DNE8mIFiUwcyEsldSzY2RLrHGgvGsUTHsl0zhMm9Kr9ZDVyX7X531gpXUeFnjwAxQZK/tTQUJczatj8P7BzCiphFsPPt8JUjRFyV9vYyTa78d1wwcKx/Ky6+RZeAXo0xioY22jZwV7P6lPesBvRHQcY/DyQaclKYH4+ksi7KIGMqmhN1itk2Lej40gAm1xWWBFaJOYj8oW4yK3FaWtoqNFjFObZYcodi1r9YXTHk2HZmQ3aTkpquOhtU5QhnvbmuI8T3iLcvL4BhYlVJ4ScqtL7bDLN4TesqZMAJn+llUOAZr6B9nrW8TMuF1xXswDOUyUHAY0LCnHUQmzTdq/WWl44WnNVDDguX+oM5q4QNHYW+6S3BT17U8tEMUlpl5o2kZzPaUHtSiUUbkrh70RoTH0bE42eSiGeQaWiyNPSqYrH8A6yP366kkcr4lb/vKQYF8XwVKjq2BKJGY9p4zbmSD6PE5npcYyah5t2hs3F6em2KjGpzG21MjD/l5YaS3qh9+1AWlH4QBMUVqF535Mmj9HHyX1qgPJsDnI/P7XJE6OF56EAl6+iyNS1tTGo29xDOhnx3pr5/OKxab3iTLMu32nq+FHTcnCXST+D1YgqdeDfDNnXnFFBidicOTbV7pgHFsusxflLFHtBmZA+Mj4ux4QVBjjGMGAh9UPQS4Fon9z72pkFpSAqLrJkHqUwa4l4aUa8dgXy6hxa0v
 3KGjlCFb
 PZB5MOWiqs/7+bxLz8COQ63qBrPCsJpE+MxMluTQiyMrCOB0CiUreZbFL6cTInw2cz9KxTRzW+HoD1LbbEeJ+WXjoSjahxl6L6XAB7z0X+gvW1UtO+es2ZMMpvwP3QS/WuLVzcVZgS5VhZKdFEQSavlzuJfObNwG/laCJQQj6JOLQYhKCDL6+GBz9habOCwtMI6wqANlzMxMOmPfqHeT4gawZL8441ylTTFHmNlRQEkEe85RgnxkWKvKIyrqYVIN4X/OjzwsUKlrRbRSTlzo/MJAJwUeWseXx/qK6C8ZMzCp2jhL8/l8zPhgXQGUKQWHMK0nYoEyhyQHvkptOaRxbkLphkldS8D4PHY2VhI8vvQ9mPydk3a2XGo1Nkkn6N3HLI+4irSiq7dC4cFLavqYYogYsVc8oI6eUj1ckO2gR3pToM2aAu92z8DAJTmmqMgvzKwRMmyfdj8+6drtnHXvfmF7mf0sd7yqkySKCyimV1whE2W5U7SW8pQc44FvSYB0J07xq2LSjZiCL2DRKFw74afyuJok4BnpHtST6DUeDHpl/Knbf0zJigX7ZS0S4vZ8eWudNu6iw6n9BNoxLEReKse4m/qpnfzm6ItkydjBJVTUCQ6GiDECEEWi0dA/as+2i1DdoVlazF9KK94I7lQIW5ExIKRfrM7mf0TqI5FeKWq8MrbyD3hUGIl3dmswfbDA4uG2spwYeOMfsXHpfajYoj3RgQSeqLKOy8x+p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 3:33=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 19 Jan 2026 00:55:59 +0800 Kairui Song <ryncsn@gmail.com> wrote:
>
> > From: Kairui Song <kasong@tencent.com>
> >
> > I observed random swapoff hangs and kernel panics when stress testing
> > ZSWAP with shmem. After applying this patch, all problems are gone.
> >
> > Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
>
> September 2024.
>
> Seems about right.  A researcher recently found that kernel bugs take two=
 years
> to fix.  https://pebblebed.com/blog/kernel-bugs?ref=3Ditsfoss.com
>
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -962,17 +962,29 @@ static void shmem_delete_from_page_cache(struct f=
olio *folio, void *radswap)
> >   * being freed).
> >   */
> >  static long shmem_free_swap(struct address_space *mapping,
> > -                         pgoff_t index, void *radswap)
> > +                         pgoff_t index, pgoff_t end, void *radswap)
> >  {
> > -     int order =3D xa_get_order(&mapping->i_pages, index);
> > -     void *old;
> > +     XA_STATE(xas, &mapping->i_pages, index);
> > +     unsigned int nr_pages =3D 0;
> > +     pgoff_t base;
> > +     void *entry;
> >
> > -     old =3D xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0=
);
> > -     if (old !=3D radswap)
> > -             return 0;
> > -     swap_put_entries_direct(radix_to_swp_entry(radswap), 1 << order);
> > +     xas_lock_irq(&xas);
> > +     entry =3D xas_load(&xas);
> > +     if (entry =3D=3D radswap) {
> > +             nr_pages =3D 1 << xas_get_order(&xas);
> > +             base =3D round_down(xas.xa_index, nr_pages);
> > +             if (base < index || base + nr_pages - 1 > end)
> > +                     nr_pages =3D 0;
> > +             else
> > +                     xas_store(&xas, NULL);
> > +     }
> > +     xas_unlock_irq(&xas);
> > +
> > +     if (nr_pages)
> > +             swap_put_entries_direct(radix_to_swp_entry(radswap), nr_p=
ages);
> >
> > -     return 1 << order;
> > +     return nr_pages;
> >  }
> >
>
> What tree was this prepared against?
>
> Both Linus mainline and mm.git have
>
> : static long shmem_free_swap(struct address_space *mapping,
> :                           pgoff_t index, void *radswap)
> : {
> :       int order =3D xa_get_order(&mapping->i_pages, index);
> :       void *old;
> :
> :       old =3D xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0=
);
> :       if (old !=3D radswap)
> :               return 0;
> :       free_swap_and_cache_nr(radix_to_swp_entry(radswap), 1 << order);
> :
> :       return 1 << order;
> : }
>
> but that free_swap_and_cache_nr() call is absent from your tree.

Oh, I tested and sent this patch based on mm-unstable, because the bug
was found while I was testing swap table series. This is a 2 year old
existing bug though. Swapoff during high system pressure is not a very
common thing, and maybe mTHP for shmem is currently not very commonly
used either? So maybe that's why no one found this issue.

free_swap_and_cache_nr is renamed to swap_put_entries_direct in
mm-unstable, it's irrelevant to this fix or bug. The rename change was
made here:
https://lore.kernel.org/linux-mm/20251220-swap-table-p2-v5-14-8862a265a033@=
tencent.com/

Should I resend this patch base on the mainline and rebase that
series? Or should we merge this in mm-unstable first then I can
send seperate fixes for stable?

