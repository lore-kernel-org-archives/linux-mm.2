Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFFA2CA0EFF
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 00:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3C928E000D; Wed, 27 Aug 2025 20:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EED118E0001; Wed, 27 Aug 2025 20:08:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDCBD8E000D; Wed, 27 Aug 2025 20:08:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C831C8E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:08:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 577F01195B6
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:08:14 +0000 (UTC)
X-FDA: 83824228908.02.A429020
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 77AF216000D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:08:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XSIPYEX3;
	spf=pass (imf08.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756339692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b36Nwls2M2gX56Ll9j62ZCf9y1Sd4pC4ay7N7C461Vo=;
	b=eFYZQA8uSaoTFfe4VpJBH8sbj0D2mVVsuKPg2g4MO0Mfe7ZubgE1mPoVdQBaYICbsO7MFH
	wj5XUTS+Jxr8QJPWDFlDATmiVVEaG6eSBleapB45wARapbrHOxKcMyDGbVsd5HfsjTLI0g
	0hTL+idgTvbSmdlfBTDzCwpD+8XXX5M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XSIPYEX3;
	spf=pass (imf08.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756339692; a=rsa-sha256;
	cv=none;
	b=QfcRK2P4p/+7f8Hie9u9591QyhhEeCXCIBHv2qqPCtAjiHzU6VxndArxRFNkbnL49I3wdc
	Dt7oeUYVh+2eKpMuun8JTxMZMQiH9tj3x4UjAGRf2ZsvEaqhxXgw4JdNLB4Cal8kz169X5
	oLox5Iivp4/K/Z6QC7yB19ujsWQsr7g=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b109914034so5596341cf.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756339691; x=1756944491; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b36Nwls2M2gX56Ll9j62ZCf9y1Sd4pC4ay7N7C461Vo=;
        b=XSIPYEX3AcRF8YD1UX7Jz9Ctmfe9ds6mMmwHO9WLERI/vmm58lbuTPr3nPPM5EvVVQ
         y6KNITRTT9dvu/SsA5YEzTQSMHjkT9OgkOPQRrIrOtzawX/gR/uD4qSdijRn76ec8xwk
         3Sau9Ns3ld03lhaLAZl8aXliMC1grjIMG1/seGQ/gB0pTIUyT4nToikgs8AZOWxBxtp7
         jdS5Hoa7DYFVNnvqCB312+W99H1WQzpBWbpalpK8wYSzChzUYXj5D85C7ZhsX39p5pkP
         m6sMF5KsE+45KMeAm3ImIKjmWuCCyUFug+0m6IzFtIrBw2/a215GukfsdqU1PNSlIu60
         3lfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756339691; x=1756944491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b36Nwls2M2gX56Ll9j62ZCf9y1Sd4pC4ay7N7C461Vo=;
        b=HgpFfqWEteyybV3Kvk7iFliCNME0cPyhC4nP7Jvmtb5ySavOwtwDKs9FjHkNDENT/y
         Fk6sQvWBxn30OAOFh98tsIXyNhj6PO3PUwIRBV+n/wMJsimJhIs4iXwEEzRNlKEGNbEi
         q6fHG4yfzcuKyOFBKAFConQVxIfuLGuPWd8mtIr9wyppZQxBXLZijsSAU01iL7i7e5rY
         R1XlKCao5nnuoDtkCGc0h1mB1D/S4Xk53yrHkpN4jt3Vk8ZWGcjS6NPb24JcnH3H7F5/
         nD2P9BL2pIvNPaZcAlDYYz/LLMzV4oUt4eQUljVtcC7C5w0kjQzzxUpVPkiUwrYx8z8N
         s7VA==
X-Gm-Message-State: AOJu0YxvhqfqldKQiNQ943pHBicY5p4EF7oofvF5lkkLdsgS/2LF3xvo
	UAqU+5YenOw9Ih790/R2S+t9llnZ+n0Ev3QKg6QoCLkkKEXzXlNVgcwRCQSD8/5PX3Dj2Ogtfm4
	SDsyz4AMP71kSA3c7E5hdvkXehwg6Ym/Y5IYjY4w=
X-Gm-Gg: ASbGncvfyptKHhZXi5haTrXv5OEs9I//y9cREqTZ893LPnWHyQVtDPy33C3sDnt2GG/
	ZCvcbE7XzfrH/OJba6bXY1uWzUfVNcJESNIkC2ymR+x1V42ESWf23+4KgsPfjfiDp58wK+bcPFE
	/oRIeO1pVDQaheOj8NpNp7ZI+SUA4dyA/KqRQ40E2Cuejos/9y5Z7NjJwEK6GNVqgNE/ymUbpPx
	MrXdiyqJMy7JQIJceH48Dss0rRvgA==
X-Google-Smtp-Source: AGHT+IEvEDydXznkcUnU+0JSU6x7dByI77Dd5uuLyP5MMNLK9cpd3c7pj4huvx9fk7DQobDzCWDAzLMQaz7dXW5dIfY=
X-Received: by 2002:a05:622a:1c15:b0:4b2:8ac5:259d with SMTP id
 d75a77b69052e-4b2aab57b30mr269660621cf.70.1756339691549; Wed, 27 Aug 2025
 17:08:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250801002131.255068-1-joannelkoong@gmail.com>
 <20250801002131.255068-11-joannelkoong@gmail.com> <20250814163759.GN7942@frogsfrogsfrogs>
 <CAJnrk1a0vBqcbwDGnhr2A-H26Jr=0WauX7A2VLU9wvtV3UtpDQ@mail.gmail.com>
In-Reply-To: <CAJnrk1a0vBqcbwDGnhr2A-H26Jr=0WauX7A2VLU9wvtV3UtpDQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 27 Aug 2025 17:08:00 -0700
X-Gm-Features: Ac12FXwqLRXibxfrwhj_AuaJ3v6eBASHt1jSpfowrUPGFUx1R4A9sYyAIQxMccI
Message-ID: <CAJnrk1bqZzKvxxCrok2zqWoy8tXtY+hZF9kXa8PTWmZnihOMTw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 10/10] iomap: add granular dirty and writeback accounting
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-mm@kvack.org, brauner@kernel.org, willy@infradead.org, jack@suse.cz, 
	hch@infradead.org, linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 31wrom9uhmgxb9cj8nqq8d3ttyfhxqw3
X-Rspam-User: 
X-Rspamd-Queue-Id: 77AF216000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1756339692-427362
X-HE-Meta: U2FsdGVkX18z5nZn9C2inlPh+CnzCSgjLxwiIAGjud41jqo3d3SgbX65jx3Gxj8VRmTCAcGgnFtTAybeHaI0mykrQ8UgyM/Ft1Vk/0f6agkZVZfGkZfgKx8p8KhlmyZZ8Bq4Y3oClc/R0N4hMTEPfx6Uyk9ku9lXlq0fSRrCpl4kXzzDvkxwlYWH0ehOOIBI82PC+naVX/YcCEDSUI/PqO780+CJPQCamDH72w25xOzW8SkAxYSiJ8WBaZEnhRcPbhwf8cfxVKHwFkJ5RFtGaJPucf3R24JKlxKMEyM/r545yf7SUYLuvg9dUmYsAZCcu0HwRyrx3MrrI2niL95eCD8ltoyZEh+WjwsYHDCSqJTzOJagzLJfDLMqrJqa7CNRdqD6ERFmLSc0FPg1zIUBlEXGxaBLD/0gC1R1CLhJIliUHFfNjVxxhY5NA0TSh82OfbSzQe5OMSPc3Td1PDkMyhHLUNFqmPIv+HWtAewHGnd5Umhn2Wl3oT32dVV4Cu2cYzjWroln67tVI0TgHrWy6Up92X3Lz3tNec1Vujkwjk4K9/OEP43IVXQD8bLO5UYbj1/hSuFwxzLTI4YnnvWK0HV2wyQRKzUbfWw/pqoANfZRa/qOFRL3gyGZgG+Wdzcd0HLjAQp8PmtjVIO0PL3V/8Mw3Wu8rLzReRirxWa8LgMHHvEsmoR9DCiJX0W2Uq6WFSIJT/4eA7wW6ldhbJe4bkMmenuuDvKlyIgQGOpxaxJqza2eMxxKzxGCG4pk/UpEqhN/vcPdEk7bwH5zOvJm2Xt5S8QwQCRaugZ5plx+rceIDttbLFOY8toktAM9vMJbopLUoFQZzvokWpWYmXMsvDZWJ2ZNsTVpEF/K43gaGzxhJNp5IkkXM60rSCEDv9JgrMQz1b2rGy4a23oIx4ODecniPjJ6NhRG6fmQJKj13GKAzM4aqee46ySDL9BYE5MOntsYu4gnb/erPQWNUte
 mK6JEeMh
 4tWgz8VJYFlQ5vqcHlUI5d+67IEQxSeqVGkw2YklQxTutKtrYYaqNLODroXUUFaK44YPcOeVovIsjJb2ccCM1EtFw02vbZ9YLlgAHfmTaPK8Dtcyv5SW62UddUCvB7Yd7rWAyZkioZWeo0//ml9tqntA+rASq/cHUNhjSUx71yAKH6gUH75HQvWgMkDGO+foTm3P4Yvh4YPoHaPutfDgYbuw3Xxix25Q7T4iTG4af+3uou0V8UGJFShDItGD5+BUiYBJTUL5T6Edjzq0HKqdlmS7kGngW8FbvoFjsSilPNpPODPFKJsWkqTAq5E5IOw4OfVcK6WmaHvulpOYgAWkId1xp4r9hcUGZwgLE55wQmNPm3u5M7Exa4x254Q2O/LQx+tnyOUCfNw1oCjbVj3KTytjEPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 11:38=E2=80=AFAM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
>
> On Thu, Aug 14, 2025 at 9:38=E2=80=AFAM Darrick J. Wong <djwong@kernel.or=
g> wrote:
> >
> > On Thu, Jul 31, 2025 at 05:21:31PM -0700, Joanne Koong wrote:
> > > Add granular dirty and writeback accounting for large folios. These
> > > stats are used by the mm layer for dirty balancing and throttling.
> > > Having granular dirty and writeback accounting helps prevent
> > > over-aggressive balancing and throttling.
> > >
> > > There are 4 places in iomap this commit affects:
> > > a) filemap dirtying, which now calls filemap_dirty_folio_pages()
> > > b) writeback_iter with setting the wbc->no_stats_accounting bit and
> > > calling clear_dirty_for_io_stats()
> > > c) starting writeback, which now calls __folio_start_writeback()
> > > d) ending writeback, which now calls folio_end_writeback_pages()
> > >
> > > This relies on using the ifs->state dirty bitmap to track dirty pages=
 in
> > > the folio. As such, this can only be utilized on filesystems where th=
e
> > > block size >=3D PAGE_SIZE.
> >
> > Apologies for my slow responses this month. :)
>
> No worries at all, thanks for looking at this.
> >
> > I wonder, does this cause an observable change in the writeback
> > accounting and throttling behavior for non-fuse filesystems like XFS
> > that use large folios?  I *think* this does actually reduce throttling
> > for XFS, but it might not be so noticeable because the limits are much
> > more generous outside of fuse?
>
> I haven't run any benchmarks on non-fuse filesystems yet but that's
> what I would expect too. Will run some benchmarks to see!

I ran some benchmarks on xfs for the contrived test case I used for
fuse (eg writing 2 GB in 128 MB chunks and then doing 50k 50-byte
random writes) and I don't see any noticeable performance difference.

I re-tested it on fuse but this time with strictlimiting disabled and
didn't notice any difference on that either, probably because with
strictlimiting off we don't run into the upper limit in that test so
there's no extra throttling that needs to be mitigated.

It's unclear to me how often (if at all?) real workloads run up
against their dirty/writeback limits.

>
> >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  fs/iomap/buffered-io.c | 136 ++++++++++++++++++++++++++++++++++++++-=
--
> > >  1 file changed, 128 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > > index bcc6e0e5334e..626c3c8399cc 100644
> > > --- a/fs/iomap/buffered-io.c
> > > +++ b/fs/iomap/buffered-io.c
> > > @@ -20,6 +20,8 @@ struct iomap_folio_state {
> > >       spinlock_t              state_lock;
> > >       unsigned int            read_bytes_pending;
> > >       atomic_t                write_bytes_pending;
> > > +     /* number of pages being currently written back */
> > > +     unsigned                nr_pages_writeback;
> > >
> > >       /*
> > >        * Each block has two bits in this bitmap:
> > > @@ -81,6 +83,25 @@ static inline bool ifs_block_is_dirty(struct folio=
 *folio,
> > >       return test_bit(block + blks_per_folio, ifs->state);
> > >  }
> > >
> > > +static unsigned ifs_count_dirty_pages(struct folio *folio)
> > > +{
> > > +     struct iomap_folio_state *ifs =3D folio->private;
> > > +     struct inode *inode =3D folio->mapping->host;
> > > +     unsigned block_size =3D 1 << inode->i_blkbits;
> > > +     unsigned start_blk =3D 0;
> > > +     unsigned end_blk =3D min((unsigned)(i_size_read(inode) >> inode=
->i_blkbits),
> > > +                             i_blocks_per_folio(inode, folio));
> > > +     unsigned nblks =3D 0;
> > > +
> > > +     while (start_blk < end_blk) {
> > > +             if (ifs_block_is_dirty(folio, ifs, start_blk))
> > > +                     nblks++;
> > > +             start_blk++;
> > > +     }
> >
> > Hmm, isn't this bitmap_weight(ifs->state, blks_per_folio) ?
> >
> > Ohh wait no, the dirty bitmap doesn't start on a byte boundary because
> > the format of the bitmap is [uptodate bits][dirty bits].
> >
> > Maybe those two should be reversed, because I bet the dirty state gets
> > changed a lot more over the lifetime of a folio than the uptodate bits.
>
> I think there's the find_next_bit() helper (which Christoph also
> pointed out) that could probably be used here instead. Or at least
> that's how I see a lot of the driver code doing it for their bitmaps.

