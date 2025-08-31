Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95983CA0FF2
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 08:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CAD06B0005; Sun, 31 Aug 2025 04:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27AED6B0006; Sun, 31 Aug 2025 04:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 190D06B0007; Sun, 31 Aug 2025 04:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9BB56B0005
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 04:58:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 60A1E58D37
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 08:58:09 +0000 (UTC)
X-FDA: 83836450698.13.8CC91D2
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id AC91040003
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 08:58:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3PWdVtL1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of hughd@google.com designates 209.85.219.181 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756630687; a=rsa-sha256;
	cv=none;
	b=20tgcqL2IVaGlK/c5BIJVGwtwgCGPKRZXl3DsEpWEw+3X4kH8xg85IJbArqxLoSWBFMsju
	CcYI9JrUZsVFkzLyJdNIsx6cW7n9xUU3PBVlPcYNHKib/RYNL/aRR2dwwWl8ZoleswrSWd
	fDkIq5wvYnSxH88aigQNcDM0Cd3Y3ck=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3PWdVtL1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of hughd@google.com designates 209.85.219.181 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756630687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5ZeU6lVaTvKgctWHbYTWm3oYBbzhyHIjCKCjF1PmS6I=;
	b=t288WDDeOuADcJcKzyZ35kPcI/jIhjouXcSxKH6Oqtd4KDkc0b4Xr3GyVSivAFerF/6IJn
	9ff4m7XH1w0Ah0lB50nKT6jZrQC21NftvHKnw26yfQ55FFvsMp9YT5rNJqfOefznx0Iymn
	8zBU27HP/IHVF/DmFfHhBeqphFDkRbw=
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e98b75eb577so150202276.1
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 01:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756630687; x=1757235487; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5ZeU6lVaTvKgctWHbYTWm3oYBbzhyHIjCKCjF1PmS6I=;
        b=3PWdVtL1xgwNw8tQ85KqrfxI21GR/rxOrF/WVqw3yB4YpcxW49Vq9vUmXlM7wgKsvu
         Uq7u+QiV6l7btAU9H3c510kb0lttGj0engOwP4I5AaLfx3pMwmfOeue8BrSRS5eOsOmQ
         Ki/gQZwHaEPelnIYvgJ57GPLJbDMgrxe/cTqr/mkT+4RvjPLrCVrAQsxUrub+fzA/QMr
         ALciwNqb070nSkCusgdkrRmGuOPBmnNfSi5bfof+qyOZ13xAHs+WpfgHduYTbu0VgIyn
         RCN8FUROHF0XhrAKLZXTNwkXjWW4T6/kawg4Rv0ULeTGzDZKEFmEGhySi2vf2KHGc4AI
         17aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756630687; x=1757235487;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5ZeU6lVaTvKgctWHbYTWm3oYBbzhyHIjCKCjF1PmS6I=;
        b=snqGyFq0n06MazL7enznNG/AX0py5Jt/xVZJRjUd0OfKGELQ7jE1jX2xiUPcc/zNoZ
         tb+vCuTsPPb8XcmWhv3VaIRR9XhGt/2fy6W4awkOSzln11gz6IGS/QFaF6hB25MAKkAx
         CfMmScpUBj6qANgBBvRgwGXDNtM6evTAbX48cIklr1+om8fbq46gMvW4jy05yQxdA+vv
         TMCnFtFfh4Y2kex7Rft1WaZrKy22Actv/+Np/m3SDnW8LyoR1zxrW+tJtdLVYoKD/0os
         S18OEPfmXUrz97gDi+G1LQDGmtbwJRo8WPEQ/Qap8JYn0UIpt6Ce/F9eKWG/NSS+Rxma
         GExA==
X-Forwarded-Encrypted: i=1; AJvYcCVlsFK39TC9+F609kPfQhEhC1PdwUVNM/xb3PZLb+7epOn/9KDE0nLHZZUmD5MflDItpy06TYfUrw==@kvack.org
X-Gm-Message-State: AOJu0YytkGzcdU3cp8sCUGQLofEkpHF4hwdWrEZM4sITbn8blUX6a/Cq
	mG6JWLZGWT+HlEM7dPRnE5I+ng1oCFEX+eLuuRqg3aKHUcruOX22MI8v0kvbh101kw==
X-Gm-Gg: ASbGnctZymtfpVlUgQnIvj1VS6N4dYS2QD1Potcr5ok5D6nFiq5XJivBNIiAKoisiZV
	CrRu+ekUQ7RDm8MJMk7Dj6Jd4VtFOQ68E9rb6IU1ANZw81NUSKzCrgTBXCImdbVDzAvHnHdUiOq
	iO4nVa28YIwX4HirE8LEiPoGhBYhWDcrHTnOFywEtBwnZWQbnnU1PEZA2uWdAVxB+C2C/egaFCq
	s6+CiOapqG7KyIR93rNUsr74KAXPnHOuZzLMThxJQ95bjnP43/KeM9/7VSe95v4bjhoaVwE1a1e
	85j3XBrvkhfw562teVwXKcpGmfKar7DJyLm+efuD3x9ycJ+bBJg7NANt7/ZTru0B3lGbz7mWE9L
	8BOHjb4tnmzrgVPYWyGIEoqmJ4coQ4fEFvEbOXv9JioFcDl5Mu8xmH8Ww19j1BTo17CXRE5l6Qz
	M3b2cXDnC8nMU2eQU0EWe5KbID
X-Google-Smtp-Source: AGHT+IEhv+G8RBUzMh+8oocyhb+0JLA1GHE6vZtzTByY9E4gGylLDC6UdEPNzNuUx9tTfYuRYvL8PQ==
X-Received: by 2002:a05:6902:100b:b0:e97:e05:3260 with SMTP id 3f1490d57ef6-e98a581adcemr4810208276.14.1756630686478;
        Sun, 31 Aug 2025 01:58:06 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e98ac57b5fasm973601276.24.2025.08.31.01.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 01:58:05 -0700 (PDT)
Date: Sun, 31 Aug 2025 01:57:50 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Hildenbrand <david@redhat.com>, Shivank Garg <shivankg@amd.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Christoph Hellwig <hch@infradead.org>, Keir Fraser <keirf@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
    Frederick Mayle <fmayle@google.com>, Peter Xu <peterx@redhat.com>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Alexander Krabler <Alexander.Krabler@kuka.com>, 
    Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: [PATCH 0/7] mm: better GUP pin lru_add_drain_all()
Message-ID: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: AC91040003
X-Stat-Signature: qtq7sehzxeiktdk3qsm1tocrtq197bwn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756630687-276330
X-HE-Meta: U2FsdGVkX1/VPGhcK5yT2yjJwJ29n6M+rD61f5XFTGGLzHtgG9y44a9ejHbKkVNrwtRkkFiBqDYWhvo+N3NKiySh7Uv99PmPkfIIQketuzWF56YPkalzW+PfG2ENWYdoykOF6YoJ2itr8I6fbJB/qYyd43YGRyz7S0aJ/2Lix9mY7t+Tk91qgtmZAsSnCBnMnHS57rRBdlVQj75PlRoWTqWKjmy5gizkb8Ex4AeTGlKcq/Rbs1OJg/Eq8mdsyqatP2zUsvrFYLisP058njRKpH80BYhiSGWalOGrAei2jZVStsk6FfbRc3sGHUhE2OfRRIHwTwLJUp25aX7B+gJbyBsrCHf+SxFh/tj7IF8h/cmT10PHpKwD6jnFOfVho5k5lt/EFmrSrnT6tsCSRTiaATW4MnfkXJzS8fTVRVCwbHdvSN+3C9/1SUl2/ThyDMcY5K7shv1EGfIgNHi/fEIL8zMob1MTFOxsQPsuo5m5dEgdVJro86S/MvYmIGIp3Sh2CDzCLQeneE0C96lb2zTyWf4X8X25nLwRZ9GviUzpexyZOC62RZ5j+ecvCUmPTw2wh1ZfYsUYH7dV70JfRcReRSDO6BdPYEobT5FqNROEckGW53cnGcXjV1Hl9+5F1pdh3TQElXiLYc0Ds2QqfiSZ6djmO2tywiOv+La8UF8axrceMFsXyCsC7AhVCR1BaWtcxjJTXcbv2jKyYv3qHFLDMC6HfSZ/PxLa9sRdQ5l2ZLx0ZE3mr1oQ9+rStKXKfHUBy1kpXquD41ZdUReqlagVYyCgup5C1/FNeCWrlMzwmy+whGNFKba20DMmUqZs2ReV4OmA9RBacXf4h3ArIe2n4qX3u56fyXwyVJiYvSOmy8Op1L6wmDo+/AWU4T9ExTRXTGbH89qIUnRR2wCjBuZVCPA5MYMbUJBUH4GIE8F3VDOmCmOc07q9mMApNUyQ73nOhAwbAdz8CMWozs0DniC
 eNKRbK4v
 7D5xvL75ll/x8eRFYspTKK3cJT1om4Mly8FlsDZ31w+xr3k//DYtAG7repYHyDxXCaiHj18Ti5Zkas04fR4djEbgPiBA1sUccrDDyRAJVe/ZSvwhsxnRdZnAjwnsOnwvrVuw0LGXS8983GtnCBwJ0CFSA8BWjlhoYqvb53u1TUaZSzjj6r4mwivmAZw27ZO6y5ZX9FqudNQ8It2aM08lEaDbq5xeznCbXHYrMtCqet2zCxldWqqhk78I2MZFe0BC6SwfiLdb2EkBjZqrEy/LVsJK2YIbqOuaA61Z2wZZ/0d5MrHM9MlS3XkBLqCVRxB1aUdHQOAMMVrCkfD1bJWJyXg76tlwGoiYi6cNjx5Sz3EoXIGo9WCQbdXmw8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Series of lru_add_drain_all()-related patches, arising from recent
mm/gup migration report from Will Deacon.  Based on 6.17-rc3 but apply
to latest mm.git.  I suggest all but 7/7 be hotfixes going to 6.17 and
stable, but you might not be persuaded by "counter the increase" ones.

1/7 mm: fix folio_expected_ref_count() when PG_private_2
2/7 mm/gup: check ref_count instead of lru before migration
3/7 mm/gup: local lru_add_drain() to avoid lru_add_drain_all()
4/7 mm: Revert "mm/gup: clear the LRU flag of a page before
5/7 mm: Revert "mm: vmscan.c: fix OOM on swap stress test"
6/7 mm: folio_may_be_cached() unless folio_test_large()
7/7 mm: lru_add_drain_all() do local lru_add_drain() first

 include/linux/mm.h   |  4 ++--
 include/linux/swap.h | 10 ++++++++++
 mm/gup.c             |  6 +++++-
 mm/mlock.c           |  6 +++---
 mm/swap.c            | 53 ++++++++++++++++++++++++++++------------------------
 mm/vmscan.c          |  2 +-
 6 files changed, 50 insertions(+), 31 deletions(-)

Thanks,
Hugh

