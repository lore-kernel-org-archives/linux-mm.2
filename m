Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37357CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 18:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBF7C8E0209; Fri, 15 Aug 2025 14:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98D08E0001; Fri, 15 Aug 2025 14:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD4978E0209; Fri, 15 Aug 2025 14:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A80318E0001
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 14:39:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F6C1B7A15
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 18:39:01 +0000 (UTC)
X-FDA: 83779853682.03.5631E93
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4DFC318000D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 18:38:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q57aBMn4;
	spf=pass (imf24.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755283139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gwAXxLY8fmeaxd9qf43Lujd9rKXNUCEjbpzfTeqryII=;
	b=xvw1QfFaI+xSiq3KPlMw8F8n9fpLTt3vVPBItjRxhmeTxC4TlorTMcjCfrXRQpOdbO8o0o
	nB0d26b91/c2Xs4HZtofU9pGzrT1eKGJ5soYazZBZPG6OPDNATyji3cs0e3JQVrdKCCkwn
	azTqHDRE4N5MBGX0HLIp9rCsq868CpE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q57aBMn4;
	spf=pass (imf24.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755283139; a=rsa-sha256;
	cv=none;
	b=b9HejW6Y6VQVgTNqeEl3ywtgvfsTm+71TgJeX9JBpHeS15qBGEkeJRJuV/i9zmKkPxHsaL
	Cv0sSnKy2RMlb8S3Rf/v4M7f6Rnpw9mO6mb4ivpWtc2liGMqwsIhM3BG/WKKP4JfSrUM4q
	LIWI6yBBRpp975Ueh9QMT87EH40iM30=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7e8704e9687so234763985a.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755283138; x=1755887938; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gwAXxLY8fmeaxd9qf43Lujd9rKXNUCEjbpzfTeqryII=;
        b=Q57aBMn4fFzcAssUTMrdDwdEHxqzLlk0D/QkY2cHxoRM9Y8iYIZXFsmKkWFT1OdQzN
         PVW0stjtN+3pJmGZUZIESZKWGj4WIXkphsKmZtzsHxzprfiCr3OLOJKCch18Hz9VThCQ
         HJn/+dd3Xa9wSzmsBvKGXRMLQftX0RxNwmW2hEyra2ytGS0lX93loXdi49cDkLj58YBv
         pQKleZA2lpZ3GRXL9Nu8GVigBRzVvNBJWRcljZE6/e+qraBt6cCjq/kXFQzsQlE23urH
         u8JCclKZb01/IYO3dPjmNqLcw3Piv1dqWKizwgWrNRBucKYUCES1E4I62fXekO0oIduY
         s2+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755283138; x=1755887938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gwAXxLY8fmeaxd9qf43Lujd9rKXNUCEjbpzfTeqryII=;
        b=aSZaW3FX8vXB4RehAYVLrPpA/qi6y4k1FM6UVt4WDlxlZRuEk4WC1+Ir6cmVeak6Y3
         m7cIdYCFElD7D2jL9oRTyEBqt+WvfVwdA746lQKsYZkO0qxGLW/0B+tez5OMb77IGJiR
         7RFr4mZYhRCDZs9oE1kdg/zeaeIWKVNt5GIwLvIYJF/bP/pC2bbF3tb3L6HoKTlmYquQ
         IOg5PioAQRr8AWwQrhQJhcgW+OW2CT1NUJoWLDD7ZwGWpKP9MK67EOxsE7H126QZyE+u
         RUWkDM5wEfEhL4T2eyYypZHP2ifn5wqP21d5qM50oj8EKaiUxkeUXImS8UyfgAgMFMja
         WJ1Q==
X-Gm-Message-State: AOJu0Ywtz1fwhTvM8XMSrh68VDNjwkbOfeSj9TeiZJlwDud3nxndjB+D
	AhRmCA0aElTosvlc0mtW9vhQtMYxU7oVRREcZTHCwnIDhhGVl1UyIY9au5y6rs9fQ7+5Fozfwxd
	7a8GcCvZ6bknv9PKCdhuFsp8YrnrW6DU=
X-Gm-Gg: ASbGncuIoCLUPD5jZmn0nHmITJQRl9NJ+rjjtqW2QNMSdR1h5YnV4eYbJdzG1mu9Ufe
	bYJKUF6Dp7PCBglVuoh3TPjb2pgBI51mtCaB+RgFnxw5KmuMIqnewg3t+KchBGWG4MlM/R6m00u
	BSk5g1d++ta/qUAcuilmgFecGyxRV2W1KJEVx3/yFxLgpuR0fD/d/N1xYvIJ3ys4/AaAp5yjT+0
	w0BxRmXv4lx4Wp+pIo=
X-Google-Smtp-Source: AGHT+IHAt0ffkvixYLAAK0FiNUs86CcOS9oLiN5NW1g96oBVK+g09pmJiV8fpiJsad3IIH0IGQiC2NqX99u235i4n5Q=
X-Received: by 2002:a05:620a:1a04:b0:7d4:3bcc:85bf with SMTP id
 af79cd13be357-7e87dfd75a9mr459325585a.12.1755283138288; Fri, 15 Aug 2025
 11:38:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250801002131.255068-1-joannelkoong@gmail.com>
 <20250801002131.255068-11-joannelkoong@gmail.com> <20250814163759.GN7942@frogsfrogsfrogs>
In-Reply-To: <20250814163759.GN7942@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 15 Aug 2025 11:38:47 -0700
X-Gm-Features: Ac12FXwgNSzjLd-7pzv2yGDIlw23znYURkdMbkX30pg1fVeN2kx5bS6G8eV5ecM
Message-ID: <CAJnrk1a0vBqcbwDGnhr2A-H26Jr=0WauX7A2VLU9wvtV3UtpDQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 10/10] iomap: add granular dirty and writeback accounting
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-mm@kvack.org, brauner@kernel.org, willy@infradead.org, jack@suse.cz, 
	hch@infradead.org, linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4DFC318000D
X-Rspam-User: 
X-Stat-Signature: oysz8b4h5cgigfzy3cc9e9rrymm4d8fq
X-Rspamd-Server: rspam09
X-HE-Tag: 1755283139-943562
X-HE-Meta: U2FsdGVkX1/qags4/pyQOghdj0bOqc8s5FGq4nVUpLnvnhZf8sreFYVVEiGSMFW50Cn/vRa/sqEI6gHgfFfzxICVd4FhrTxnBrtTg1ag6eeSnpak+xvYs2o9MtWdw43vibkgOtifmBngxImWkNj89K0WCpRmH0X/CS8pHd7FSgTslngQHwJwGtcKuD4ag+rQFKcnukCy/o89jILHbQF456X+gSv0eXzCcONkbFnDus+Dk9c+UU88glTHg/k6a6CCpS7Npm/1BZ/Z/YWGYwh1llCN9hIUgtrpWUF25gLXloMjHOTBBZVO82QFSHqOdc7B96B4D5Tir5fuG++wD9Uo4PqtOJneojFYLloM2LRzPb1Lnswi5usorixRN9Q0Xv93OMpXI6Sie4q2oHn3aE1pmzS2gLGrklYPSuOz3xWubOo6g6J9uVVrgxgHfQ/lWClOehSflM/J25ZfIcv+zsnW6e3KOAaystZWxrGfjE8qPSZcjWCjhlsPSxNDRWXFH0oNTt2m3bCJOHun/3WTymTeghYZDmM2ATp8kwCmqkf4GKfd/lUOQ6ABdTrC3I0Y3PiBxeiWCHO1VZH44atn8wYKxVDOZarwijbYhDr5oc1+ImKwlPRzq13YNT6k0sveCya2Nop6qtTx0aY08qYlvI7M3LKbJASdAgcSvHuH+xMfkN9dn1CEXm9GqZ2GxPwd/xFN4MR87x+u6NbGyqo4nJMmQE9yteCGrblDazLukYjImI8fFtfpTFqscuGTBYOUXVtlVkyZzrtLvCcQUoP4OsQYChkdcZkZ4VrHydV+q0K1di4Enr7gr9R1jF5z9LeqcgU0Nd0/zuI3ckt5ASWhSWUbLEABQqe3/IiQudWYZBlpct+rriELY0xin6k3iDEyze5HJW9n6rTUDr6uOVnpv8xpVEE6jteelO60MbOFXswYU/ogoW0orQi8c+uQQFESuk/f11Z7SXGLAEK/IMjbkUk
 fErouwe1
 LohCsuxQuiszDjIFKEkbYsuJGnAp+rx1hiGpaOrCr++IRDuq0RaPxvRQHdLvxX7luEdN7cHxaRlddqTRPdw0WPBTZy+1iKXrhVzWArnT5WkNVTzlpcEMNJeAESP/im9TEN8wGi1zJRXckynZPQSR5tKZJvxVn3VAUrovh//bjpqP/M95Lxp1GbRRs6w98E+yb1EulKtP/mVPlSjXkM1jKlGr+f86iq95vdhMa6zKC5VDWEdIaxDDFVSap7547jrd4uelaQ/Ujg1Ti8Ydm73h9I6MmQ1yO/0klb+XqHqbn0g2GvrrVY6poR9Vwe7H0MYUlBn/in1RCgVCNp8IR85GHpaX6C/Oq6LKTNaCk7DGr6AtUDnmlZRF4oWI0sYAYpYw2ldKAKtRRU0Z40WgwOnadEb0tKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 9:38=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Thu, Jul 31, 2025 at 05:21:31PM -0700, Joanne Koong wrote:
> > Add granular dirty and writeback accounting for large folios. These
> > stats are used by the mm layer for dirty balancing and throttling.
> > Having granular dirty and writeback accounting helps prevent
> > over-aggressive balancing and throttling.
> >
> > There are 4 places in iomap this commit affects:
> > a) filemap dirtying, which now calls filemap_dirty_folio_pages()
> > b) writeback_iter with setting the wbc->no_stats_accounting bit and
> > calling clear_dirty_for_io_stats()
> > c) starting writeback, which now calls __folio_start_writeback()
> > d) ending writeback, which now calls folio_end_writeback_pages()
> >
> > This relies on using the ifs->state dirty bitmap to track dirty pages i=
n
> > the folio. As such, this can only be utilized on filesystems where the
> > block size >=3D PAGE_SIZE.
>
> Apologies for my slow responses this month. :)

No worries at all, thanks for looking at this.
>
> I wonder, does this cause an observable change in the writeback
> accounting and throttling behavior for non-fuse filesystems like XFS
> that use large folios?  I *think* this does actually reduce throttling
> for XFS, but it might not be so noticeable because the limits are much
> more generous outside of fuse?

I haven't run any benchmarks on non-fuse filesystems yet but that's
what I would expect too. Will run some benchmarks to see!

>
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  fs/iomap/buffered-io.c | 136 ++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 128 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index bcc6e0e5334e..626c3c8399cc 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -20,6 +20,8 @@ struct iomap_folio_state {
> >       spinlock_t              state_lock;
> >       unsigned int            read_bytes_pending;
> >       atomic_t                write_bytes_pending;
> > +     /* number of pages being currently written back */
> > +     unsigned                nr_pages_writeback;
> >
> >       /*
> >        * Each block has two bits in this bitmap:
> > @@ -81,6 +83,25 @@ static inline bool ifs_block_is_dirty(struct folio *=
folio,
> >       return test_bit(block + blks_per_folio, ifs->state);
> >  }
> >
> > +static unsigned ifs_count_dirty_pages(struct folio *folio)
> > +{
> > +     struct iomap_folio_state *ifs =3D folio->private;
> > +     struct inode *inode =3D folio->mapping->host;
> > +     unsigned block_size =3D 1 << inode->i_blkbits;
> > +     unsigned start_blk =3D 0;
> > +     unsigned end_blk =3D min((unsigned)(i_size_read(inode) >> inode->=
i_blkbits),
> > +                             i_blocks_per_folio(inode, folio));
> > +     unsigned nblks =3D 0;
> > +
> > +     while (start_blk < end_blk) {
> > +             if (ifs_block_is_dirty(folio, ifs, start_blk))
> > +                     nblks++;
> > +             start_blk++;
> > +     }
>
> Hmm, isn't this bitmap_weight(ifs->state, blks_per_folio) ?
>
> Ohh wait no, the dirty bitmap doesn't start on a byte boundary because
> the format of the bitmap is [uptodate bits][dirty bits].
>
> Maybe those two should be reversed, because I bet the dirty state gets
> changed a lot more over the lifetime of a folio than the uptodate bits.

I think there's the find_next_bit() helper (which Christoph also
pointed out) that could probably be used here instead. Or at least
that's how I see a lot of the driver code doing it for their bitmaps.

