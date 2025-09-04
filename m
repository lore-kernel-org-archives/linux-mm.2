Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90678CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 23:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7C9D8E000A; Thu,  4 Sep 2025 19:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E539E8E0001; Thu,  4 Sep 2025 19:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69BA8E000A; Thu,  4 Sep 2025 19:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C42768E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:59:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 88F5A160454
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:59:30 +0000 (UTC)
X-FDA: 83853237300.01.C1BCE2F
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id C0F0310000A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:59:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="CH/6SYQt";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757030368; a=rsa-sha256;
	cv=none;
	b=brCKEDsSIIH+KGrUy7Zp0txNac9zjlqJiYFx/C8ykNjCx6zJJYpuGdbn3RWEHTDgOLZ7oC
	nPBM60ZsbrW0y5uRsFbNGjkz2/RLKKBfmZdmZaA3L/PQJw88DBVtstqJfuYLEJI0BliQF+
	x5BEZvYPSLhmVl4ADtbPevNt/UIAdgs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="CH/6SYQt";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757030368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJBouPfqG8rk327P5Sr7FS9kMnQsPpnILmql925f154=;
	b=ENEcaEQc249ih2gn5a/u2loiov7DLUejVkJfMmPOnQFPaJWBKapiELaJq39d+oclPUMfOy
	SYLOuwYlIgUyo1mK9Imb0yhbrcfHgHczilb/yZfEarXhX1nqvML/drOtvXPB570FiQcT8b
	0OBsDuAjB5DtEFwg94v+cMcSb98JF5w=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b338d7a540so21080321cf.1
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 16:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757030368; x=1757635168; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jJBouPfqG8rk327P5Sr7FS9kMnQsPpnILmql925f154=;
        b=CH/6SYQtH2DpeZ89+Eim5BPFXHJZu4mOzxsYX03eQP/r32qCY/yu0UB2EXoWeBm5kr
         wqnwOF/CRJhq8hgaDDd9EWNxxcyukpUKbnzXPpXW4KDTtN84ZxVkiPLzhMWHP4IRQPlz
         P5l7N2PscoCp7Ls8faoKz/uRTdBczPdPZGHymDsuadKZzOtzvDn1VdFsRk5i7WRr/WQm
         Ev5xykjxEqPHRo6xd0cgc4T60E5rOx0is/bsXYS96yOriFRibE9cz59EpwcURgVQo9Ne
         rnFDjmBN5egr81PUPunl0VNrpdqZDcGe7fupVa6RWTez81EIm5DPY45dH9s7dy23Fj6q
         P5lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757030368; x=1757635168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jJBouPfqG8rk327P5Sr7FS9kMnQsPpnILmql925f154=;
        b=q0SIToiHRQ8aCHs84g8LY9AsKkMkTpy0oGEWU93HPUkfZsClB/lbq/cKaEX7QZDdQr
         +K5NTgkro6s+2BnVwGS2lVLGCw8Q1cZnI6UY30E9P8awMpNZV/4Yo17F7Fn6NjytJNoD
         l6NlATflR1kLhSO1mH3lexzFMS0MxUbHVJHSZP043OE8FYfOrP1YLtVfgjGbfytHK4+h
         4ROmw/41VfmC05j52kOkYn8lLhFHsTN3r3ybTOHttXyXpi3t2mtwSfDPcYYOXOPBvWyX
         kjErLBteFCtlTnjc0WqIv5zJl43mtieh5Tnv0cU31D3A1LvrT1NRvRniJs3xTtWlzI51
         WuIA==
X-Gm-Message-State: AOJu0YxKZ7Mv728aOVmtv6z1kAHxb6dnzhN8DUKnmwSrCcLT1GpMUA1N
	CT0vCQuXC55L+tC3bRQ+efqKZ9H+zI94u7zGrzJWQaJVdGCvopHRWm18N4Pk1ty8FaSlt/db+5z
	AXUmXnW8XUAXqrrNt/SQD5cmbg5L4Fp4=
X-Gm-Gg: ASbGncupGzZD7WY+bghuweZNiiEIfm2Ez8rKcZzefqYuA81gDmfQGUFGcRsynvDEUlD
	t4dnGbAWC0Hmb2yxRR1XUYekn1NLD2IexljkCX9zqG0O0Iec7QrjeBDSk2v3ynRzB55ausSD8rT
	KoIaxHX/SK7P05qZ/uI51YhgcMfG/ZCDinwenwkU5v9jCGQtnXx7yLy/pjyX3gHKHx0erxXNXli
	VgP/g6A0zCSj60DtfU=
X-Google-Smtp-Source: AGHT+IG7SWs3uBaCgr6Bk63bbgSay78hiDZMZwtKTG8KVcQoJE3BLbhdg8CGYoBFjcBVILlKQkPYKny5F2e9/SRKbkg=
X-Received: by 2002:ac8:5e0c:0:b0:4b5:eab3:66cf with SMTP id
 d75a77b69052e-4b5eab369c6mr5814821cf.30.1757030367682; Thu, 04 Sep 2025
 16:59:27 -0700 (PDT)
MIME-Version: 1.0
References: <20250829233942.3607248-1-joannelkoong@gmail.com> <5qgjrq6l627byybxjs6vzouspeqj6hdrx2ohqbxqkkjy65mtz5@zp6pimrpeu4e>
In-Reply-To: <5qgjrq6l627byybxjs6vzouspeqj6hdrx2ohqbxqkkjy65mtz5@zp6pimrpeu4e>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 4 Sep 2025 16:59:16 -0700
X-Gm-Features: Ac12FXxrKg1CfKQQYXnuIWvXPvLbwk3vb6DFX9OL5MM-vJTNf-WDPPYhOVBjoy4
Message-ID: <CAJnrk1acU+bs2uJTSjTgeGYCMavSpokGbrngoTE-3Hay4KZsWw@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] mm/iomap: add granular dirty and writeback accounting
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, brauner@kernel.org, willy@infradead.org, 
	hch@infradead.org, djwong@kernel.org, jlayton@kernel.org, 
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: C0F0310000A
X-Stat-Signature: 8ufcuqnwbent8zstr7pr8gzimxgzpy8b
X-HE-Tag: 1757030368-325620
X-HE-Meta: U2FsdGVkX1+nY9XRSd4v08qDBfjMyLjlrHA3STHU4ypZ8cM3E5A5uwqjGg7P/cdcKTz69f6QzNGc15n+z/7AbcuD2lipJxjgNJeym/yVfl2cqVzBHqSaUJPqF+Jx3PDRv0rFBy/oBRW7A73t9sxgcUbRk46C6dkTOF4WbRuksFNBfBwoO3Il9qnhEPqBjTgQqL7Z5b9GEWi2XeBemNpQW2OzL9RgN1i79LnD5yPXkOCF6GT6wY0xKmQ03UJHm0rrfR2IjigdL3ALlV+SKis0DZZtx5c/Gglsf9CsftpUuUyI+Vfnum0aYObxYSEGvLr4BoJAx8d5rnObvaxjMsjbrgI1obW24priGuo0ZzWrrElrvz21i56//R7wq0Kg5hgsXJcKRUdLRQwKk+r8AoI69fBB/zClf+mDoTMT9fViGkolLR9R/mxDQo739e0cvrNnkoDMdt1vPV4S6HhqCwUPvNbA50TXE8fnzs49tDGc5JZjuu8b6ilxLjzbhtD2/9qLsYatf6MHf3AeadnCa3sf2YHoOYeGBIBWxvJbEtZ8Nt8MYyIWM2jyAMqx0aoBhfxdg4ioT3vNWEHr+1iR1KTeMZKBeg6cFo3b0IzhOGpKLDzOOpC/0GbmxGsafvCklfApc1EYrnDVQavam9FHMq2ljxmfYVmsrwX/J7hCkdFEb9G4jFvcMtQlC8UB0T0PJxyb2WiU/i2SFJ/H0xaOIAp3SAHti2Jsy7oBBeOabjX7IhXUWR9kfTnOEU/UqQ36pnm23SBCnxp8AiKsS3efb6MkN+WbLIq5DNoD3Qi9UE2feLDbJ3I2EX9s8TwFkSdLhSBPU4TBNR3zeuyJhOh2qGbrWJLPeQC3Sn87WcVvKI7SyCcGMgR++L0tp52DYK4MyflJ2XpXM3Jmt5lE1k3h+APHOVLHRdExhTnGWMxo150BWRRrIplUTDK2qVbFpT+XFLRLJs3vvBKgPnUW0O2kUuA
 7dTfb5UZ
 Lo4NgVUPWV+cw6qBzHOSbzL10OTguzJZ5Jsmfi7R6QK0sepKtx+EThnFinddFlWmopm+Tg+j3e3vald0NuWkLMJJsTgDnqCcxeKj4y8WwkokhteyVkKMvRL/mRRActqprLwUlV55OgkZH+Q9c8oUk14e1WIVctfeABAVl0kjZREYCMCHf/rd+9nK7Zm5NTZki/HJ00riPf7AFIVt2ACIhbdCWXLnuV3PWJ0RNG9rN5B648KXdll2zvaec77Dqm/cal5McxfaoKO7HMPCk2IUGZVwnAJbi2w2YYcZRLc3IyqniXxzVriWkLMyCpG2TkSbq/fBBDvyCA+QrnmY0m71jQPevXiJxL25QFcEC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 4, 2025 at 1:53=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> Hello!
>
> On Fri 29-08-25 16:39:30, Joanne Koong wrote:
> > This patchset adds granular dirty and writeback stats accounting for la=
rge
> > folios.
> >
> > The dirty page balancing logic uses these stats to determine things lik=
e
> > whether the ratelimit has been exceeded, the frequency with which pages=
 need
> > to be written back, if dirtying should be throttled, etc. Currently for=
 large
> > folios, if any byte in the folio is dirtied or written back, all the by=
tes in
> > the folio are accounted as such.
> >
> > In particular, there are four places where dirty and writeback stats ge=
t
> > incremented and decremented as pages get dirtied and written back:
> > a) folio dirtying (filemap_dirty_folio() -> ... -> folio_account_dirtie=
d())
> >    - increments NR_FILE_DIRTY, NR_ZONE_WRITE_PENDING, WB_RECLAIMABLE,
> >      current->nr_dirtied
> >
> > b) writing back a mapping (writeback_iter() -> ... ->
> > folio_clear_dirty_for_io())
> >    - decrements NR_FILE_DIRTY, NR_ZONE_WRITE_PENDING, WB_RECLAIMABLE
> >
> > c) starting writeback on a folio (folio_start_writeback())
> >    - increments WB_WRITEBACK, NR_WRITEBACK, NR_ZONE_WRITE_PENDING
> >
> > d) ending writeback on a folio (folio_end_writeback())
> >    - decrements WB_WRITEBACK, NR_WRITEBACK, NR_ZONE_WRITE_PENDING
>
> I was looking through the patch set. One general concern I have is that i=
t
> all looks somewhat fragile. If you say start writeback on a folio with a
> granular function and happen to end writeback with a non-granular one,
> everything will run fine, just a permanent error in the counters will be
> introduced.  Similarly with a dirtying / starting writeback mismatch. The
> practicality of this issue is demostrated by the fact that you didn't
> convert e.g. folio_redirty_for_writepage() so anybody using it together
> with fine-grained accounting will just silently mess up the counters.
> Another issue of a similar kind is that __folio_migrate_mapping() does no=
t
> support fine-grained accounting (and doesn't even have a way to figure ou=
t
> proper amount to account) so again any page migration may introduce
> permanent errors into counters. One way to deal with this fragility would
> be to have a flag in the mapping that will determine whether the dirty
> accounting is done by MM or the filesystem (iomap code in your case)
> instead of determining it at the call site.
>
> Another concern I have is the limitation to blocksize >=3D PAGE_SIZE you
> mention below. That is kind of annoying for filesystems because generally
> they also have to deal with cases of blocksize < PAGE_SIZE and having two
> ways of accounting in one codebase is a big maintenance burden. But this
> was discussed elsewhere in this series and I think you have settled on
> supporting blocksize < PAGE_SIZE as well?
>
> Finally, there is one general issue for which I'd like to hear opinions o=
f
> MM guys: Dirty throttling is a mechanism to avoid a situation where the
> dirty page cache consumes too big amount of memory which makes page recla=
im
> hard and the machine thrashes as a result or goes OOM. Now if you dirty a
> 2MB folio, it really makes all those 2MB hard to reclaim (neither direct
> reclaim nor kswapd will be able to reclaim such folio) even though only 1=
KB
> in that folio needs actual writeback. In this sense it is actually correc=
t
> to account whole big folio as dirty in the counters - if you accounted on=
ly
> 1KB or even 4KB (page), a user could with some effort make all page cache
> memory dirty and hard to reclaim without crossing the dirty limits. On th=
e
> other hand if only 1KB in a folio trully needs writeback, the writeback
> will be generally significantly faster than with 2MB needing writeback. S=
o
> in this sense it is correct to account amount to data that trully needs
> writeback.
>
> I don't know what the right answer to this "conflict of interests" is. We
> could keep accounting full folios in the global / memcg counters (to
> protect memory reclaim) and do per page (or even finer) accounting in the
> bdi_writeback which is there to avoid excessive accumulation of dirty dat=
a
> (and thus long writeback times) against one device. This should still hel=
p
> your case with FUSE and strictlimit (which is generally constrained by
> bdi_writeback counters). One just needs to have a closer look how hard
> would it be to adapt writeback throttling logic to the different
> granularity of global counters and writeback counters...
>
>                                                                 Honza

Hi Honza,

Thanks for sharing your thoughts on this. Those are good points,
especially the last one about reclaim. I'm curious to hear too what
the mm people think.

If it turns out this patchset is not actually that useful, I'm happy
to drop it.


Thanks,
Joanne

