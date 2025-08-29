Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86FC7CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B756C6B0032; Fri, 29 Aug 2025 19:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D486B0062; Fri, 29 Aug 2025 19:03:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62FF6B007B; Fri, 29 Aug 2025 19:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 931B86B0032
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:03:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B3751409C5
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:03:10 +0000 (UTC)
X-FDA: 83831322540.03.76D4660
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6A40C180005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:03:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eoGqhC9Q;
	spf=pass (imf24.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756508588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHahEkW90E3K8vme96BrNc+kv0QVOb2ty07V9mAlLKc=;
	b=S5sEqTIKOna/qKmGtl+GyYF8bB5VD5N4bzVLuygg8KNP36I8TuohBVKnsG3fy9pLbxSI6V
	yR6f2IMzvozvwK2XJhMgfr+/34EDa8uUCvyWWMLPETo8MMhulG+Qh7NF3dEFszzXcJtBpR
	IsJuqAt74B7yjmHLAmMCI/fr5wp+haw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eoGqhC9Q;
	spf=pass (imf24.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756508588; a=rsa-sha256;
	cv=none;
	b=g9REBfuLO/oAtNZ59x7WjQC5OrlktbPg3wkXxKFXPJPvI/kf2knxyJC13r35FREZqFIyoS
	q6JcPxGd5LaSNZ7sFL1SFNITQs2HJRBG3f/FAqeYX1m03npGNHcacgQcj1zUiXJZlHCPsQ
	UxOj+Jvl4l8Sxaum2IuKnUEgjbO42zw=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b308ace753so20612781cf.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756508587; x=1757113387; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EHahEkW90E3K8vme96BrNc+kv0QVOb2ty07V9mAlLKc=;
        b=eoGqhC9QsdyB+U569zFTE6FJcGV5I/Mg6hhS2o8lAeaFSTZnvnIKUTZXAgrEu2PSH5
         JZfb66YOnhOmF/QZhZ/iwPSLsMWpLvO6LkYoBj+YT4PWKZZv3m6tN8xv7URNUWpXjzFL
         tLYbppl3d6CkgGK9ZQkw9Tyqz1JV+HxtvwIFASYNhMVWkTFEWkhU/1SxHb0YrwLRkpL8
         pu9j3f+eDgzltcWkPi4XgMkaEle+4aGWHFgfoZ4Oqi3IjZA+tK/8674can5nkYFbsCdX
         /9DhTL/8a0XlyILy/f5/rM9fim2l0Z1NwIwj5F1h7ABEtc4zw0zsTexKDarfYxbL1g5V
         nr8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756508587; x=1757113387;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EHahEkW90E3K8vme96BrNc+kv0QVOb2ty07V9mAlLKc=;
        b=m3oGy60e8tuXb9PN7LVJ8mLhFZeSHlG8ILkscJOtwS7/pMSOnGgD4mzUe8CTSWc3yt
         XbA8l6VvrizyvaG58BKJdydhyK1aiYvg2dsPBM5zGIymL/JV/WExquJIwl3kyg6JlPUE
         jS/lPc/5W+LhAC/WD5HFJcroWaE9Zalmq9SKutgqidL8Bk8KLjLcvvDsWcmKTSwSi+n4
         JY6B3KnORKCNCUfHVe/3Bc9FmRjYuGJbUSz03ULekPs5qcOY7UJbiqqzke+NCWr7LDbg
         DL7EcpMMS762C73dc3uRlTM3YLQIJrQBNlwo39pYExTrGOQFTAEtWfY5rhf5ifqxgWXk
         j0xw==
X-Gm-Message-State: AOJu0YySZ9kQfyH3/JLgFrBvMJBGMHWFW2klkbIC2HFIPM0XYuAzorS9
	Z+Jfz5RFh3/CczlX8TSzoC+JKLc02impAmI6Ne9+sCxXJ29YgK5FuPuL4jsDWlYLCVtZHisePhh
	j+ETbNSsapq855yabD9ihRvq8AqonuwQ=
X-Gm-Gg: ASbGncuL5Y5TOo3c7nYFm8W7EHBkx7T/EQFezK6tkayzxHtXH7KkRAbTSipzt7RqHnm
	bVdCgRZobuPkELpoT/tAK0/zgs6kHA7frkm+IooH+M7leT4kH7QNDl2X7BdZDid1HfyDiZJxPFJ
	XHgHjNdhii2WtIdUs9p6iTkz5WOLzMjo8ETiigGH7rSTYVz05JDpRVnKVtsEBrSBDQIaR43zRf5
	i7NnBxZIiFBcvwOGS89R/HtLHxHBg==
X-Google-Smtp-Source: AGHT+IEIYCRuciJtYQI04fSLLqlCBDLF0lt7nU8NQFo+iWPHSQ6IDWvFYIydMBOVUlxgvhfaag1SSff7sZA2WpX/muk=
X-Received: by 2002:ac8:5914:0:b0:4b2:8e4c:71ca with SMTP id
 d75a77b69052e-4b31d89e531mr4292841cf.12.1756508587329; Fri, 29 Aug 2025
 16:03:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250801002131.255068-1-joannelkoong@gmail.com>
 <20250801002131.255068-11-joannelkoong@gmail.com> <20250814163759.GN7942@frogsfrogsfrogs>
 <CAJnrk1a0vBqcbwDGnhr2A-H26Jr=0WauX7A2VLU9wvtV3UtpDQ@mail.gmail.com> <CAJnrk1bqZzKvxxCrok2zqWoy8tXtY+hZF9kXa8PTWmZnihOMTw@mail.gmail.com>
In-Reply-To: <CAJnrk1bqZzKvxxCrok2zqWoy8tXtY+hZF9kXa8PTWmZnihOMTw@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 29 Aug 2025 16:02:54 -0700
X-Gm-Features: Ac12FXw5jDz9qTpnLWvZYMoaFe9FRA8t701a9u-9bJuhJPsiRtiPt18hnfxL7Y8
Message-ID: <CAJnrk1YP2dkmvvMjMg8w3AgVNzQVzq+CDUY3c1+8JRCBcaP2sg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 10/10] iomap: add granular dirty and writeback accounting
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-mm@kvack.org, brauner@kernel.org, willy@infradead.org, jack@suse.cz, 
	hch@infradead.org, linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6A40C180005
X-Rspam-User: 
X-Stat-Signature: npequm7y9rh3urbqm3g31ygxs41dou1g
X-Rspamd-Server: rspam09
X-HE-Tag: 1756508588-661130
X-HE-Meta: U2FsdGVkX1//yz99tXGKXKPg1Aq5rWWKuE9NVvNOu2TgVIaasmC2zjk2ymIpm3lvqGSeKb+lu64GD3cubLcPNI6mgMaCaYtSV3X3zgHksBPpj5xeuyPHMP20kZt3ZmfoQRhq/kgQd3d+U5oQctDec5+LH6qDgTWDRf7paf0dUc4YyCfmBZ5Rr/zkys8sP28kOYvTHfLNuJLPjRpWkHt71ONihUKn1eR/D3Dx3cZPDMuXAUMYmn+tcDoacPH0ls2rFlw4MaYKQIZNBDZPG0NHLt80uHvhbMxgs3twYoLNSFCTzxQkrPUzcG9db+2E7cu9vnT/VT+OwGDfXchtbMGeyYup0wKTQ7AdJbDDTZdLAOJlwsWvGC1yEXb/jGRam6PuZA+OH+khacKaJRjlj4JG3iIH+Wi8efu5mp1X8UptcGegKV5IA0ux1ZjmTVrP6HKNwduDdZne0MZowBow5VoFpEPNL1XDmn1AmpLrR3jyVa14Pen4edAzUgPmafEX4MrUtb4VqhJgx2UKxGoGZcc8tH1hl3U0DDDBXK43V/+MaCZkuanHx4Q0kmox6Fsq9QlURQJKQ2MCXLzGEfzdreww2b2DeZBDyeHx8/Sty24h8Ql7w/p2fgehGf8J2FiQceDZQ6HovNpoF1ywEXiIuneAh5mFHxNy4aB+0NMn1Q74tTdq/fHhrjp0EKjNOSlKDXyb96lfFeGMO9yZ0PZ+Eo9bPCR0Xazo3A+e5gQtNtYWd0jIxJtOL8aBQZqkFoYiB8UjG/DQIRP5pJdQk5m0NLOU/1TL3uzRhBNPHXDcSe6U5D2tzX9rQQlOMfaLCqQi2J6/Uza1c43VQQDSQkIEC4IXcr24gdD2Lk23NrkVHIKCwpdYM3e8eMHfpqRp0w7ObZ4U5LxduraZ0c1E/JeP0NmbKERedyWkq6HXNt+5ZDQwheGiVGL4cCVk/5MqMvocWXmYSPAWhy2AY/EFT2fG1Fj
 nPXVh4DZ
 GIaJ5Nkt+3k2Xa4e4BQElIOc4U1ONpDenTXJRnsOrB7hDciGDcEifqgpZSuys6ECGZ3SXa3WpaWA+Rwsz3AYcSon4x7Q0j50XGzgcvkpFEPPlhvxw1V6MJoQUXIFyifGMwavBH1QXINXdy/DyK+lQNuBnjNPaAZoHtXFnf97YuImUiQtI5FyjNoBpbNpyzDqx8fTclbvnvy4mSEa1j7LL6dDse3u0J93aLfbI1IA0Z3TfYZJjB3pvZotMzf87dF41Z5xYag+y60iADrMpwuixE8QSeRV915ykOMhTSHqTDkJ6a1UvB3DOYqbfzpaHhVHRB+daMdncfMy8Nmm/NjFPeiYW+YKDQwhMS67wzScfDNN3AAjiN96DCEoP2WJRn/Cc9ny9E+bjeAYK2fUsGtxAl/jEYv0Aa3Sya2itzOGYRx4swZc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 5:08=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Fri, Aug 15, 2025 at 11:38=E2=80=AFAM Joanne Koong <joannelkoong@gmail=
.com> wrote:
> >
> > On Thu, Aug 14, 2025 at 9:38=E2=80=AFAM Darrick J. Wong <djwong@kernel.=
org> wrote:
> > >
> > > On Thu, Jul 31, 2025 at 05:21:31PM -0700, Joanne Koong wrote:
> > > > Add granular dirty and writeback accounting for large folios. These
> > > > stats are used by the mm layer for dirty balancing and throttling.
> > > > Having granular dirty and writeback accounting helps prevent
> > > > over-aggressive balancing and throttling.
> > > >
> > > > There are 4 places in iomap this commit affects:
> > > > a) filemap dirtying, which now calls filemap_dirty_folio_pages()
> > > > b) writeback_iter with setting the wbc->no_stats_accounting bit and
> > > > calling clear_dirty_for_io_stats()
> > > > c) starting writeback, which now calls __folio_start_writeback()
> > > > d) ending writeback, which now calls folio_end_writeback_pages()
> > > >
> > > > This relies on using the ifs->state dirty bitmap to track dirty pag=
es in
> > > > the folio. As such, this can only be utilized on filesystems where =
the
> > > > block size >=3D PAGE_SIZE.
> > >
> > > Apologies for my slow responses this month. :)
> >
> > No worries at all, thanks for looking at this.
> > >
> > > I wonder, does this cause an observable change in the writeback
> > > accounting and throttling behavior for non-fuse filesystems like XFS
> > > that use large folios?  I *think* this does actually reduce throttlin=
g
> > > for XFS, but it might not be so noticeable because the limits are muc=
h
> > > more generous outside of fuse?
> >
> > I haven't run any benchmarks on non-fuse filesystems yet but that's
> > what I would expect too. Will run some benchmarks to see!
>
> I ran some benchmarks on xfs for the contrived test case I used for
> fuse (eg writing 2 GB in 128 MB chunks and then doing 50k 50-byte
> random writes) and I don't see any noticeable performance difference.
>
> I re-tested it on fuse but this time with strictlimiting disabled and
> didn't notice any difference on that either, probably because with
> strictlimiting off we don't run into the upper limit in that test so
> there's no extra throttling that needs to be mitigated.
>
> It's unclear to me how often (if at all?) real workloads run up
> against their dirty/writeback limits.
>

I benchmarked it again today but this time with manually setting
/proc/sys/vm/dirty_bytes to 20% of 16 GiB and
/proc/sys/vm/dirty_background_bytes to 10% of 16 GB and testing it on
a more intense workload (the original test scenario but on 10+
threads) and and I see results now on xfs, around 3 seconds (with some
variability of taking 0.3 seconds to 5 seconds sometimes) for writes
prior to this patchset vs. a pretty consistent 0.14 seconds with this
patchset. I ran the test scenario setup a few times but it'd be great
if someone else could also run it to verify it shows up on their
system too.

I set up xfs by following the instructions in the xfstests readme:
    # xfs_io -f -c "falloc 0 10g" test.img
    # xfs_io -f -c "falloc 0 10g" scratch.img
    # mkfs.xfs test.img
    # losetup /dev/loop0 ./test.img
    # losetup /dev/loop1 ./scratch.img
    # mkdir -p /mnt/test && mount /dev/loop0 /mnt/test

and then ran:
sudo sysctl -w vm.dirty_bytes=3D$((3276 * 1024 * 1024)) # roughly 20% of 16=
GB
sudo sysctl -w vm.dirty_background_bytes=3D$((1638*1024*1024)) # roughly
10% of 16 GB

and then ran this test program (ai-generated) https://pastebin.com/CbcwTXjq

I'll send out an updated v2 of this series.


Thanks,
Joanne

