Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD05C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 07:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 401A56B0088; Mon, 28 Jul 2025 03:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AEEC6B0089; Mon, 28 Jul 2025 03:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29D506B008A; Mon, 28 Jul 2025 03:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1986A6B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 03:53:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF6F61401B8
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:53:36 +0000 (UTC)
X-FDA: 83712908832.04.E068363
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 049A8120002
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:53:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D0ucn6A0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753689215; a=rsa-sha256;
	cv=none;
	b=Q51OxTioydgrWLNl5VwfmFOTHISLG1WDsw/+ZYuYLrnbvLHxDY5wZ0MZ2SgsLXIDYtcltW
	0niLLIOY9Qq1pv+ikCpv5P15x6ITA2mDde1+Ms0OXDStp6TnWh9ozuezl65MRtJLX57gt4
	yTo96gN2qH4Es/ah1d05LVcIUVu9/RI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D0ucn6A0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753689215;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5loWCTi8sLWbfgpjr5FUZEJQZnH2H/eS0KaFqLlVPog=;
	b=rzBSchuNc1CEMjMQz2F0dgOORYf2+p+RiCU2BGTblJtyzHG6a94AjvfTlogLS8XqhfQvc9
	AJSR2TuUJya8JvDFYEZ/k4IuUx1ikk2Q3iZFCVtaR6jMzl0P7nkqcUCnlopMjNmN0xf9Mu
	DSPZMhaoMTMLvThXKaFd7irxwI37Smk=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-24049d1643aso877785ad.3
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 00:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753689213; x=1754294013; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5loWCTi8sLWbfgpjr5FUZEJQZnH2H/eS0KaFqLlVPog=;
        b=D0ucn6A0748wan+SqcvL0HlpU6GO/DFGr45n8GiSrmYi4XFHlsr3e3johI/8FOcfUO
         5iyx+OiLVsjD92sf6NsGn8zdcimYghSrts8EWk7IXS5Qp11Coztqa6V9tjtJYyD3vIrA
         TPZyCpFm/bayINEosOIjja5ixSwcHD0brkT1fqE7lHDp+TW/YJxYohmwIsa3qvNP/iY8
         Gy9FOdxqtiXmJ6zrSpoXPz5w147q1J+QzEO2CHMNsOBQKRTqyLQI4NbPYFLyNIpZ7jZn
         shRAUWCTtFepSQb17+Hwov02HQiDTRmE4MazOC8YQJxpmWVuFci6KwssQ3zT9pYjO34M
         iV9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753689213; x=1754294013;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5loWCTi8sLWbfgpjr5FUZEJQZnH2H/eS0KaFqLlVPog=;
        b=E/TlU/VAuy2BDkffbhylutVTrsqe4NfoYNJTS4abezc97Vw1ETkQcOGwFwSXxIeWXD
         qfVQ/VolsNmhqm5waEjYtJtv4nAlW3ybx2BhqO2jnbItEM8cDVFtKckY8K4hSi107r0/
         EObfgOtEJh+iJKjnnBZafuyCpdnoVj/6jCFv0Ss2XVU2pzQqA6rKZlmX19O0LES6JxOH
         /YgS0aZIQxCDqA0GVsrTGc8JsLAr+5qDaTLff2LWvHKwZPksPT4NWx6ayvRAq0YTzIU5
         Wy7ukYjXNN/wej+E/nUniZxd/k/83395DHURuSlAHoNIIMAAHMNolMtpDOHkvh9wWPaZ
         D2uA==
X-Gm-Message-State: AOJu0YwNrkhuQ/s8abonU8+HaKDiboAtlRN60m9oiR8FAez0twXDi0cd
	N1zb8fihu69qK6ugjV04y3X6U5FXoXt6cZeM/Wjwd7gV8/PftRhPpIHSrSOyXk6i8hE=
X-Gm-Gg: ASbGncvNf2Dp/xLds2M+ol3HiQnHCe+lCUxoO4TgT4yPmijr/p1y1bx8YLdBh2o7Saf
	mq0pqPedY6bfAWOyDH+U56lbcgbSRLruOf432ScMQJvQilThWJpfgsiRM2ktOsrHivkb5hPQneZ
	seNa1RPymKZt3x05z4fE9Dn0kgoMXbrLBuj//mtyUC9NWlfTMW9L/RTX2jNHnJgW2qT5csVzir9
	ERC5v7Bf3OxYgmMl0Hmfd6sayhum3TORR7gd2iTyIvQ3p198d4h32hujODxuiOJN9E8P2qoXdm6
	uDDW9+K78HBeXKGhGyqxXlDphl1UbntSXI9zudUGxRASiBQS7w1yaGpSO6URtnjQar69D/oq84c
	+Cuca6lgoHivUsPDOC5f2up2BGFyYMzMqQp1g
X-Google-Smtp-Source: AGHT+IHKusCfnBHmQMl6Lm7RUhK/1UT4+sICv+y5w2HRMYDAS5IxSyY8hGfomfsZiBcJ+xqMKxUYxQ==
X-Received: by 2002:a17:903:2a83:b0:235:1171:6d1d with SMTP id d9443c01a7336-23fb2ff9598mr142678195ad.9.1753689212918;
        Mon, 28 Jul 2025 00:53:32 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2401866c2a1sm20272305ad.4.2025.07.28.00.53.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Jul 2025 00:53:32 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Matthew Wilcox <willy@infradead.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v6 0/8] mm/shmem, swap: bugfix and improvement of mTHP swap in
Date: Mon, 28 Jul 2025 15:52:58 +0800
Message-ID: <20250728075306.12704-1-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xpsfo45yhuhkbpbj3y3w5h6iqzi7zdsw
X-Rspam-User: 
X-Rspamd-Queue-Id: 049A8120002
X-Rspamd-Server: rspam02
X-HE-Tag: 1753689214-518158
X-HE-Meta: U2FsdGVkX1+38wpS8l+F9AjPhZUmuvG5DBeiz0ny1u+cJZskKU4ocoV+1xyZlGx+GMF+Wmq8sGSFetslbyLYcT5WOwOl9qwIIPHfErEnmDbJH+cyn1AVnazaOiKvZ391gMWPO0zQ+VnPC8VODXC6MAxYDdvXycfdBD97tU95h9e9KT4bX8wA2qTYNbCCSoC+sKaMbd4D833NauRVrbS/tvMiZpwck0mTU03pEJnpKa1mx/dMQJOVFlhwl+C4mRC60hePZYMjSAyc0dg3ePSBYgVrOohw0pvPvBf0mhns251B8cpkhUVUAd/MEiz9AIDjbeP9ALZQ0IOUyiTFWQ0mPYHYHAv/aSUgfixk5hhlOprMy2xVkJiXb1ZycPrWpZ5bZy/x5XbqxKnwIWt9o68KnMMr4QygiYS+JLKO+ADnSYi5uzViHJWQOUJvXmtQBlYmaexl9tlhT24iZcDH+XNjvddmstldIpmFY+i4I3RlFluqqK4peIc9sKrp5qNHhmUODi5l7QugPo8LEFGi+c1XJRJ6SvksGdz3TgSefJvuEYK9eqxDWr12CsjTTNB3y9m5jFNlUk63BzpZPeIRLCdLaLK0QO2ha587IfCzhDe2+m7cCv2EOTO7tnhlQzLWTdnUe86NiXXH4NU3Xd2lsdpxhp7disuYkzYi+dlp/sMAzIhgImuQKsARIvDfDjxsf2KQmzLdV0r3id7X3Ax1NdaUNSOypPtwHmYWrwbN/99bZqo8Jt8C0As3T8X3XWnrtVvwhoCwbLM/D8BkAXXR0TNToBA6ckJ8G5s0yUPM2f8sAfYLf0cOYiBav5jQiOr01HhGKd9ZPH4GNvJuHEY23KAF+Wzb0AYg1dnvKKPFmN0naLcGDYgMeGm3vxoIyzM8KubIGV0A3jjd2aNJGUdFMaPWomjh8kbQh4avI9ATA2Or5xS640ys4Mrh+SiVP9P65iSUlclCDy27B2E71HkwHNj
 CR7Cm7yN
 dz9t+eitYuUQO8YqIlR9ozzSf+N1VTvbRG79N3Rkk8npYfK4eSbHwsVEdFNgapJektE3Fo9gP8NYJGRjsl8964dL7jAsFWPHm1aqY0d9rL9X4fsHEnHHQ0Crad90bxC1/6KtL+KlumXWOJ8/B/J4LsdnmY56Z/ztzCkHWUKw7s73t1p57tzmD25KEXKx5nO8f6BiWCOGDL3UiNTbSsgc9LudDznMlcenMPL2MCwNmT93CuMH5197N51vVb3+7NZOraiq0B1bE19kc1XBP1tb1Clrwg9wmihq8ESubi3qb+M4pQqIgXIzSBoW6M0megaDXGzhedXIQZVBK5S+Nz8nm0wZbY+CafNC+7k5JjPa58VpBSMRflqbIio7vG9CNy7efFJ5ZFFyPFg43a93jyq3X4PhalOceeqm0v5G82/augKtv+JrZt4hj4+zvXxaN0B3fw+JZ22oB0xV0FzDFN4txCt9S5SJkWHQ8Ybj5giRyhyLSHyyvIaypg6fCM4XgRscL1t1LMbGw4le1TNPCtLuBYcBERudcbJWH/5HScWPk9MgLZ2J0IpqghMWxL0Tokyif+ruIo764XF4YBy/9pN7u5R2gzCLcK6keoDOSODsrICuVYOvesCHywuKXLYB3gdI+3qveU40z/iXjBSR1CY0B927ukw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The current THP swapin path have several problems. It may potentially
hang, may cause redundant faults due to false positive swap cache lookup,
and it issues redundant Xarray walks. !CONFIG_TRANSPARENT_HUGEPAGE
builds may also contain unnecessary THP checks.

This series fixes all of the mentioned issues, the code should be more
robust and prepared for the swap table series. Now 4 walks is reduced
to 3 (get order & confirm, confirm, insert folio), !CONFIG_TRANSPARENT_HUGEPAGE
build overhead is also minimized, and comes with a sanity check now.

The performance is slightly better after this series, sequential swap in of
24G data from ZRAM, using transparent_hugepage_tmpfs=always (24 samples each):

Before:         avg: 10.66s, stddev: 0.04
After patch 1:  avg: 10.58s, stddev: 0.04
After patch 2:  avg: 10.65s, stddev: 0.05
After patch 3:  avg: 10.65s, stddev: 0.04
After patch 4:  avg: 10.67s, stddev: 0.04
After patch 5:  avg: 9.79s,  stddev: 0.04
After patch 6:  avg: 9.79s,  stddev: 0.05
After patch 7:  avg: 9.78s,  stddev: 0.05
After patch 8:  avg: 9.79s,  stddev: 0.04

Several patches improve the performance by a little, which is about
~8% faster in total.

Build kernel test showed very slightly improvement, testing with
make -j48 with defconfig in a 768M memcg also using ZRAM as swap,
and transparent_hugepage_tmpfs=always (6 test runs):

Before:         avg: 3334.66s, stddev: 43.76
After patch 1:  avg: 3349.77s, stddev: 18.55
After patch 2:  avg: 3325.01s, stddev: 42.96
After patch 3:  avg: 3354.58s, stddev: 14.62
After patch 4:  avg: 3336.24s, stddev: 32.15
After patch 5:  avg: 3325.13s, stddev: 22.14
After patch 6:  avg: 3285.03s, stddev: 38.95
After patch 7:  avg: 3287.32s, stddev: 26.37
After patch 8:  avg: 3295.87s, stddev: 46.24

---

V5: https://lore.kernel.org/linux-mm/20250710033706.71042-1-ryncsn@gmail.com/
Updates:
- Add shmem_confirm_swap back for Patch 1, and fix xas_nomem handling:
  https://lore.kernel.org/linux-mm/CAMgjq7DfPXS4PkpGK-zem2L1gZD0dekbAyHa-CPHjf=eonoFXg@mail.gmail.com/
- Fix typo and comments [ Baolin Wang, Hugh Dickins ]
- Rebase the rest of this series. There is basically no change to follow
  up patches except trivial conflicts. Only patch 1 is a bit different
  from before.
- Adding the shmem_confirm_swap back in Patch 1 V6 slowed down shmem
  swapin by about ~2% compares to V5 but it's still a ~8% gain.

V4: https://lore.kernel.org/linux-mm/20250704181748.63181-1-ryncsn@gmail.com/
Updates:
- Merge patch 5 into patch 8 to fix a intermediate code error. [ Baolin
  Wang ]
-6517755a04ae4d82d1220d690944359f1dbea686 Instead of passing two swap entries, calculate the new order 0 entry
  in shmem_swap_alloc_folio, to improve code readability. [ Baolin Wang ]
- Rebase on top of mm-new.

V3: https://lore.kernel.org/linux-mm/20250627062020.534-1-ryncsn@gmail.com/
Updates:
- Split and reorganize a few intermediate patches [ Baolin Wang ]
- Fix a duplicated fault issue that may occur in one intermediate patch
  [ Baolin Wang ]
- Improve variable naming [ Baolin Wang ]
- Fix a wrong error value problem, return proper error value when direct
  swapin failed.
- No major code change from V3.

V2: https://lore.kernel.org/linux-mm/20250619175538.15799-1-ryncsn@gmail.com/
Updates:
- Split the clean up patch into 3 individual patches [ Baolin Wang ]
- Fix a code error in the first patch [ Baolin Wang ]
- I found there are some other remaining issue that can be fixed after
  the clean up so includes these too: fix major fault counter, and clean
  up the goto labels.

V1: https://lore.kernel.org/linux-mm/20250617183503.10527-1-ryncsn@gmail.com/
Updates:
- Improve of funtion name and variable names, also commit message [ Kemeng Shi,
  Dev Jain ]
- Correct Fixes: tag [ Andrew Morton ]
- Collect Reviewed-by.

Two of the patches in this series comes from the swap table series [1],
and worth noting that the performance gain of this series is independent
to the swap table series, we'll see another bigger performance gain and
reduce of memory usage after the swap table series.

I found these issues while trying to split the shmem changes out of the
swap table series for easier reviewing, and found several more issues
while doing stress tests for performance comparision. Barry also mentioned
that CONFIG_TRANSPARENT_HUGEPAGE may have redundant checks [2] and I
managed to clean them up properly too.

No issue found with a few days of stress testing.

Link: https://lore.kernel.org/linux-mm/20250514201729.48420-1-ryncsn@gmail.com/ [1]
Link: https://lore.kernel.org/linux-mm/CAMgjq7AsKFz7UN+seR5atznE_RBTDC9qjDmwN5saMe+KL3b1mQ@mail.gmail.com/ [2]

Kairui Song (8):
  mm/shmem, swap: improve cached mTHP handling and fix potential hang
  mm/shmem, swap: avoid redundant Xarray lookup during swapin
  mm/shmem, swap: tidy up THP swapin checks
  mm/shmem, swap: tidy up swap entry splitting
  mm/shmem, swap: never use swap cache and readahead for
    SWP_SYNCHRONOUS_IO
  mm/shmem, swap: simplify swapin path and result handling
  mm/shmem, swap: rework swap entry and index calculation for large
    swapin
  mm/shmem, swap: fix major fault counting

 mm/shmem.c | 275 +++++++++++++++++++++++++++++------------------------
 1 file changed, 152 insertions(+), 123 deletions(-)

-- 
2.50.1


