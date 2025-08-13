Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82649CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 01:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F0B8E019D; Tue, 12 Aug 2025 21:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCFBF8E0196; Tue, 12 Aug 2025 21:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABE3C8E019D; Tue, 12 Aug 2025 21:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98F148E0196
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 21:10:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 76E0C8208C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:10:30 +0000 (UTC)
X-FDA: 83769953820.17.D81A567
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id A202014000F
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:10:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i2nzFCjH;
	spf=pass (imf26.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755047428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pW+62l2Rgy8wolVJ0jri6hTl1M6VmlbjpXer86yqLTI=;
	b=qQsl0TMkV9Kj/4CIe3saRHl5Wh53bzF72nJpehm5/XArZNEbXRMS85H97kyArAGGc1GQ2D
	Z0Q4xZPtclVFZ/z8gQhwvWQ/pteGNknC3/uJ05GSCAalUQU8malS7sMnZPNBkDDdjLX3bL
	OOwexQ4VacZeqqdNbChuGGQLLjZl0M0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i2nzFCjH;
	spf=pass (imf26.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755047428; a=rsa-sha256;
	cv=none;
	b=YHLY5OrkEDbNuX+LHedo6LNJc1BBfGyn5OAA44RjSg8fv7OFpEOvmNge/Xv9z4MlUBGUh0
	cBMXPBgaU4zRPeLK6vvSS8bMUnIpKnrypdpvcXJFtOTvu9l0glOGc5B/d437nGxCzJ/ZZi
	C9sD1LzJzzsdcdlblcSU5/zfDoBz7qg=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b0c5d57713so47163211cf.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 18:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755047428; x=1755652228; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pW+62l2Rgy8wolVJ0jri6hTl1M6VmlbjpXer86yqLTI=;
        b=i2nzFCjHDfFXr9GJ2TSlb89ZOEOtxRiuZVW0FJ3UNMvjbvBmsGt3gljkVpHQ0WfKlW
         wKWszltA5sLcvGi0BgXPM3ymaSZuOdcm+9c0EFYvTyTt/6QpjC7AcWASYfHNv0Nf//sm
         xVw/ElWokgEjMaIjkctmARsuCWJ34spwdcbrolL/NcWVTuxnFPtMOXJqFQrMH44Hd52d
         FnZvevGY+pJ/GCc3gGSNztMzuE3+jVTgGEiBppeTMbMMMXrDfkFO+AyEIaH/SI+FHpED
         7DWMerIcu/9McyOcC8JCeTUwas7LAvLclfMzACa2nsX28IwEE7Gi3o02q4XJxe9QspNm
         SQyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755047428; x=1755652228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pW+62l2Rgy8wolVJ0jri6hTl1M6VmlbjpXer86yqLTI=;
        b=GW30CSRwZ0xYEiS64ZPT7i7dU5f4scU3japa3ySGQ/8NLbiJbXX2tYLNcJ72WJmOwC
         6bNVfyqvXZIscuEVmkUhOa8gIdXi/ge1WVIxDSmX0W0G0DfxkLWJBSQGZ11fMWLecsPW
         LTT6oRQTVApbwdJZYUkYFwT8bCew+ky6iizQtW5F672xp98BjxJOqOGXahV1emBq8V+v
         LRkKE0j5JD4M/cxYmiZGqUzLV4ZkLGw9uWiJa59YjE2dBTCL70i8deGeDo1o3aOgHOwU
         GBYX5sYUGzUOxSxKh+JUQthJG1TKlsI3B0vP7n5LaUlF2d30fVctBTVuzje3v7Pikvif
         oPPg==
X-Gm-Message-State: AOJu0YxFRlMEZLOQU4QOoqObY5OaDUHQzAKiH3/QO2T8pB+uWcJ3+yeZ
	ehdTZhE4XpOmcrOalqEM3/MEHf0xZGLdgCY69TFI1eBtvPdkIf9HvoGt5PcVRARAqOe7eEECNQg
	FD9aVxuchvUsh9Ysx4a3ejukVExtrw0w=
X-Gm-Gg: ASbGncvg7LnvcZGkvSUbOkZ9C0eopPeLSfwXcBefvp0FdxFxk6DLJZV5jpe0vxA7q9l
	OyOWpxR7/zE8ybGzX79/MMxwNY9ePdEvAzt3cqtD1a8BgCvpxxsXfXkieLMzfi++4mG1W1IsBbJ
	aBWVaUuhpYOeTsnPS/4rNj83699SF/8L/RY6b77dYRS5jZ9B2jLzmPtTAd0zlza4yrh9Euk+QXk
	jDQtCju
X-Google-Smtp-Source: AGHT+IFsdqfj/tAhAllAZAhX+cwUB7Y+BgDDNMcuWhkHOqKdtmIjYTjo0ovZF5HAGl2+tPycP4YoTLIGOYSPd5AVXg0=
X-Received: by 2002:ac8:7e96:0:b0:4b0:89c2:68d9 with SMTP id
 d75a77b69052e-4b0fc87a0ddmr12489431cf.36.1755047427575; Tue, 12 Aug 2025
 18:10:27 -0700 (PDT)
MIME-Version: 1.0
References: <20250801002131.255068-1-joannelkoong@gmail.com>
 <20250801002131.255068-11-joannelkoong@gmail.com> <aJr4D9ec7XG92G--@infradead.org>
In-Reply-To: <aJr4D9ec7XG92G--@infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 12 Aug 2025 18:10:15 -0700
X-Gm-Features: Ac12FXzjpx1VHBeMLwDllX4JQ9W149cx9RY1gnKEqe31VXNLal5My-OjbEmgX9M
Message-ID: <CAJnrk1aLAPqpZZJ9TLBhceVQ2-ZzDGY8qv5_bX2rt5XA5T9QTA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 10/10] iomap: add granular dirty and writeback accounting
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org, brauner@kernel.org, willy@infradead.org, jack@suse.cz, 
	djwong@kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bssn5ueb1ht76eqpbu8gsq9y89wt3a6x
X-Rspam-User: 
X-Rspamd-Queue-Id: A202014000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1755047428-193074
X-HE-Meta: U2FsdGVkX18Jk1taLJdMZkrDfSbBEor/0Y9CTnXyQSPWxFQPHPf2ZbycUXcC4AwUa42VdwPE+ZvAwHdceW6LuW6mNhltN4/V2ddgRg/5z7TzKCaII7wjFlyT5mdi580Mqgwrs7419oA4o8b9AFmpRY9LkjEQZOq8O3RhmVo8rkU1nClvsNJHDvBItsAPlXp+ee5N3zIvM4ChZXkPZdlvQ9CSiATz+UZ3FqMWm8qHFCjPpplP/+3fYjFuY91QuYQlzko2aH5W/jOzBhlx8LgYGw5CL9uH5cCEbbzcbYXfjY5jv4P4sHPtFBAj8Y/BtaX77ZJ6FKMxa3rC9Dwm/bcN7r5FJDHWay+/2Ry1a00TrPIYJhuNFYU8lpj9seONtLgtLD3CMz2BzRCrgpb4rC5VYijERvHs/IaO3vb/WZbCRTYiO+a+5rEbZ/VKiwCNtvu9dw/80LJ6ZG8sgPbMm9UP8lrQmrSZaM0X0O2Y9ATJAC06GEVM6Re6Fm4obWQ10W9dSN3aQ9PEoFcF6owHb4eCdVcYrhdcBkd1zx8zAaDfWKx6UCTFbAg30tp5WYG2yRXRicZ4DdePgl2Rg6KTJXMKz+1pnAG+qXblqn+WJp1zvKpBZHikU3UtuwShe/pPkFZUttQ9+pFW7zFB+Hs+eQK3JTRBGTOaknsp+moF1De06nESghZfrHSHkzhhwkNWKXl0hhFLLeB+8p+8KLKxbly0HKBnmn5Q7fFq1c34yH7fs8HSxDRiJtuZc2fbBZ7D0ci0ATUmkpo4IlqlsKv5LpZ3+g7lK7JdsXqxYDat9ih3ydaQi/x+CfjZvN8HWrDdVAn2ZxPYAgPDJVfFLYC7PLAW4vs7tTBRwnxfFy6HT5g9Tbet9/1BP3GLNBDmuVURAQ0QhsAUZZl+lT8f5jSpJKUvh6B2UySQNWzsW9HoPeVHoJY3HcTeLlLQfptW6xC+T+GFbkClVKUb+zGkuezuNmr
 F9WDFrmH
 PpuZa2baYwyzXo3wdsT/ZoSxeKysBqKA+GhUutRWKjhPoMPexyQa3SfnYYmjlCWkOlNh0ms7vQbdv5/ySTgjkWflqPfIuye/S5DDoDEEl/ln/O8yKf1tO07ooWcljjvHDYwmK+hCOQ9i8w/uOAu3NdcSUmN7a7Y9g2tqJeDRhfryID44sSQq+dN2MrFhACuZJB1ckopNUsC9xS6dqO+OmFVuwkSqkRwNE1fz8hdkcC4xvY+PBVXL0jIeyn1C4Fhcvkn5p0iBH1wulPqXoT375uRGuPWKiR0MLRZNmz4ARhpyLydTTh0hqNVFNXO5vxnvvBElb+5XSqYVoVwdGt8rLCti3S159Oo5bK6I7WUlenYQ9VeEYHPEnO1rmXYcwpUjYjjhOuqsg8L/VIUJBbKlL7B6x7v7QPFs0m7Rv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 1:15=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
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
>
> This adds more sizse to the folio state.  Shouldn't this be the same
> as
>
>     DIV_ROUND_UP(write_bytes_pending, PAGE_SIZE)
>
> anyway?

I don't think we can use write_bytes_pending because writeback for a
folio may be split into multiple requests (eg for fuse, if the ranges
are not contiguous) and each request when it finishes will call
iomap_finish_folio_write() which will decrement write_bytes_pending,
but when the last folio writeback request has finished and we call
folio_end_writeback_pages(), we would need the original value of
write_bytes_pending before any of the decrements. write_bytes_pending
gets decremented since it gets used as a refcount.

I need to look more into whether readahead/read_folio and writeback
run concurrently or not but if not, maybe read_bytes_pending and
write_bytes_pending could be consolidated together.

>
> > +     unsigned end_blk =3D min((unsigned)(i_size_read(inode) >> inode->=
i_blkbits),
> > +                             i_blocks_per_folio(inode, folio));
>
> Overly long line.  Also not sure why the cast is needed to start with?

The cast is needed to avoid the compiler error of comparing a loff_t
with an unsigned int. I see there's a min_t helper, I'll use that
instead then.

>
> > +     unsigned nblks =3D 0;
> > +
> > +     while (start_blk < end_blk) {
> > +             if (ifs_block_is_dirty(folio, ifs, start_blk))
> > +                     nblks++;
> > +             start_blk++;
> > +     }
>
> We have this pattern open coded in a few places.  Maybe factor it into a
> helper first?  And then maybe someone smart can actually make it use
> find_first_bit/find_next_bit.
>
> > +static bool iomap_granular_dirty_pages(struct folio *folio)
> > +{
> > +     struct iomap_folio_state *ifs =3D folio->private;
> > +     struct inode *inode;
> > +     unsigned block_size;
> > +
> > +     if (!ifs)
> > +             return false;
> > +
> > +     inode =3D folio->mapping->host;
> > +     block_size =3D 1 << inode->i_blkbits;
> > +
> > +     if (block_size >=3D PAGE_SIZE) {
> > +             WARN_ON(block_size & (PAGE_SIZE - 1));
> > +             return true;
> > +     }
> > +     return false;
>
> Do we need the WARN_ON?  Both the block and page size must be powers
> of two, so I can't see how it would trigger.  Also this can use the
> i_blocksize helper.

I'll get rid of the WARN_ON and will incorporate your i_blocksize
helper suggestion.

>
> I.e. just turn this into:
>
>         return i_blocksize(folio->mapping->host) >=3D PAGE_SIZE;
>
>
> > +static bool iomap_dirty_folio_range(struct address_space *mapping, str=
uct folio *folio,
>
> Overly long line.

I'll fix up the long lines in the patchset, sorry.

>
> > +     wpc->wbc->no_stats_accounting =3D true;
>
> Who does the writeback accounting now?  Maybe throw in a comment if
> iomap is now doing something different than all the other writeback
> code.

iomap does the writeback accounting now, which happens in
iomap_update_dirty_stats(). I'll add a comment about that.


Thanks,
Joanne
>

