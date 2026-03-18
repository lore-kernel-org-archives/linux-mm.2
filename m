Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AFE31088E54
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 23:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ADA66B037C; Wed, 18 Mar 2026 19:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95DED6B037E; Wed, 18 Mar 2026 19:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84D526B037F; Wed, 18 Mar 2026 19:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6AC776B037C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:12:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32B6CC0BE4
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:12:29 +0000 (UTC)
X-FDA: 84560734818.23.C9B28BC
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2B98C10000A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:12:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NHw2vmoY;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773875547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BX2iHwtPTib43JUHo2OtCHlhT2FiqspzClwmirSToVw=;
	b=bbBS/dbSnl5NmG75W1dOo1Ssk1oNI3+rvUP1ib3kB4S6La6dNy9o7qYX8hSuLJMCOxDW2M
	BX4H6iKuOHD+FkM2qzpWqvtKnah18qGV6eB8x3QSIiSHuF1Mm4VNo2hrb9Cd0DxGpqVt4Q
	GlOiSQXnkm2vUbBXGNRH/2/ddTQcOWs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773875547; a=rsa-sha256;
	cv=pass;
	b=S59//jMXtnU8IHr8WfeqZJ1ZXASUojAqC2Ra+49OmtxlwYQ7J5GmsljBWfRQiPBh4jMfz/
	0zv4b/rKpnahWMPcsHT96xRpHmf2PKouaqwrt44R5qBKJs+FOyoLxq8gGOS4RpJNavvnv+
	HixtQA1SejKIQOZu17Ab5Vx7hYBySZc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NHw2vmoY;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-38a2f196cbaso260561fa.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:12:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773875545; cv=none;
        d=google.com; s=arc-20240605;
        b=FDG5pKDPL/t2PzfCSuk9PJ0BHb/didwrt7qNZN/mQqAxcN8ZlkdiiBLiZ/lnVUX9nT
         HSn9aknqPCAqzKuBEMK3OzhUj32DOHdMgdrgWJRPnQjT9Z8wMjYmAXapEf8PIw5h02ze
         rOSMzp3HUMMsmutRhbx0WRzGGNHxlVOKjnhuiJ96ZPxQCWUbux5VkwHky6qA7GXJCQpX
         jEeEOcXl8zgnAG2gOBflZTfZnXzeiMiklBZ6n+0s3/eV9r+S2r5wr6VnZdHs5+xvB51i
         h1mwEQz992zyJvbr2eF5fyV2qjNtTPQ9GNJjeDEI4+ZfQY1s+s0l8P/ifwLPIQlUpB9r
         Yl5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BX2iHwtPTib43JUHo2OtCHlhT2FiqspzClwmirSToVw=;
        fh=8qOi5hsJjKPLLfdUG6ixKlgcaaemAO7Iqhprx9yq160=;
        b=AXeu6gAx1CXV9lOJIcYEbmJEMTTav3Kzgu3otNaXfxVsSa7A8Hb12FPZ/8D7Ii57za
         wTPY1k4zICnvInUbVZqE8FNmDJ4ErT12dJNlQOzYDMqHbTkH76MLKjpAec7HfXjM/Ms+
         ss2pyR9OigErMBH2z729qEFwCQ+Yabgw0n0LQea4OIHJq6Z/KaY5Wd/OmVhfet2FAee9
         kAkB3Pa8LTvENjQ+ZCpCiwx98XsDN7jnryWvaBdpEYsNfsSlLGHMhXy6cDjX/ZcJHAke
         4/Nf807iDlZmLufrHk6zB3ieUF6C1d9Q4p/2waTsaGhupGZYrSv9bDII1JOxPCBRvGQR
         yLxw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773875545; x=1774480345; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BX2iHwtPTib43JUHo2OtCHlhT2FiqspzClwmirSToVw=;
        b=NHw2vmoYEdOFKFfo+4eVqWiwH2fyxTneehqtd3pCesys80lsUnkb9u+X3EZEqclia5
         bqrWuCf5kNesn6Mm8QsN3sWqpw4Ixr57xmJPbjCxyZdo/JRLw3wDwS31r9KvynSTZ6dA
         gMysmnpgYygO9hsUb5rQAKuZ47PzdxCsUpC0JG88NGjf00IdqmwmHBUhgBzVnYHDdams
         2Ynryk1ETp7saw3z66HCNCqFBIgEhJYFfwBCRaY4CFZL9+SMpZyA340aCTC1mKhHL89N
         wPdwcXY6d6i8IbrxcqpAKlLBryY7zLXDJUB9XViAYQqP6evN14mxQYLWNQ9zLncklMCq
         qC8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773875545; x=1774480345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BX2iHwtPTib43JUHo2OtCHlhT2FiqspzClwmirSToVw=;
        b=dOnVr3K4zXpwwHGSUfTvnhknqdK3AOeyCVbioSfISsbhnwGgPY2dnVWrh8TxLSfBxX
         GXjD228pUjvMFm0Pjcj9GDpEOvF3V/XcLZN9KNymLQxfaDL80HKmdACP5XBFE3BP/Ob+
         uaI7JyWWyS+IJU5VlzN3xvZt2SrDK+QX4sKtLSj4jIP8gyuesPH0zvk1A0dbtTEZNFnz
         SQ9J9SPVgg+GWpA7SnrGjTYfumDBMppRUR74f3hUn2ppXr/YuPKQYCqVW4MchBUEWhpm
         rUK9CcYd/YOv+mJq7qowcesO8oklrGPNS59C7BJmOprTXybARHYAepOga0HVQQgBufKb
         ng2A==
X-Forwarded-Encrypted: i=1; AJvYcCWm+uzO9l3dFXj7I14IWBCYNjVTLAgHvZeBX9XprZP7HzJ8GcF2AwbXHVN9jP1kaV7Uc+FiGqJEDQ==@kvack.org
X-Gm-Message-State: AOJu0Yx1klZZQzqITtCdUCtcw8oIjMKfzLt/RiO2+m3Wkl7smt0kupaM
	pf6XeesAElh7EB6W7JEI3lb37XW4MOZoNPUEMWch5uhAA2PGit0DzBWHnbCVIjlEiepUfAvag29
	1hLKWJMmuishOyiwLUKAHUmoyKY3UxlY=
X-Gm-Gg: ATEYQzyLHZqGNxv6IetEteWCbc5HjyC9g9NwVOzIWVYB6UoaVex10PpRQWmlTFXzFYl
	ONI7dzh3dlhCKEucCo16XcyLCiRF/e71Oq3lsxfu1tpUUKF+WCHTaNyj8s9WDUxFAjfqilrO2nh
	3VAYIXlqmpptvK+8PqhW+ekjo0nGiIHkIM1V/4ARZklpS49UBOBsxdIdELouyd6YTRB+2zy+KUx
	GADWiiNq8/BmLyRN6U2WsdBL0WHqu/VLPzFvsOzhq7jDZrRzQUyuFkwqe34zKr5XWbM/RmM3pkR
	bIlcuCFDI38JlwI9lG/+aIjQWoWslbLXFO5MbcO0ZW1HN86L53z19Jp3E4twxsHhrA==
X-Received: by 2002:a2e:9bd8:0:b0:38a:4de2:85d7 with SMTP id
 38308e7fff4ca-38bd57813f6mr16258931fa.3.1773875544905; Wed, 18 Mar 2026
 16:12:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260318222953.441758-1-nphamcs@gmail.com>
In-Reply-To: <20260318222953.441758-1-nphamcs@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 18 Mar 2026 16:12:13 -0700
X-Gm-Features: AaiRm52Vh6KL3hLud6f_VY3t_swyNqO1ijXNToeNb-CGlcr3QBKt9nfVJNa08qE
Message-ID: <CAKEwX=MV9axc+2V2y65hZ6s2tHc4_mU_aJ-94FQpmU3XZ9AnFA@mail.gmail.com>
Subject: Re: [PATCH v4 00/21] Virtual Swap Space
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, apopple@nvidia.com, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, 
	lenb@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev, 
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, rafael@kernel.org, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2B98C10000A
X-Stat-Signature: twojmdogx5xnnntwr99aqsint6kdmkcb
X-Rspam-User: 
X-HE-Tag: 1773875546-666390
X-HE-Meta: U2FsdGVkX19F2zSvpGaF8GQW8q0Xmw+eeW9dpLxwuJuZjDlsXKh/SIemknXk/iXdmnYW1lzrieKl//wH0djD5JJSRwhufrAq7dNb4DIdaPB9hy+wXoN6swaTCu6WhNONnQgCFNeQ8D6OrHf8ubJppxFuy9qh02zX+saoVViKb2wubKC3uDZVpZVFbKjlnbgq/FYeacREhp/hT8op0AghcZ9FEedWE/ebZbqmNr2oW2y8jUsAxxV2n7HaH3GwaO9QGICBsWee3R6/g7pXch2T2V74Uw1qXAjXF78r7uwZ43Cubv0MfNJFf28YQRzlaoluIgUoXWzyVf1mS7Y6gXjF3/ZmPCq42T7QdN/fCuCd7rjJwiAlN9Ghfu85JEttyvYRqEl8joZK7ySOqpbNiw9IkTiZ+dX3fEZHzyjyVsxOrFsKb4WOYF0weX7tpnix0zHZWFPraJ74Cit/XX2LAmPXr7+n1RgtCVB7q+Rvq817RvRDWVAGYurxCoRHnvQuO3wgF2MbVeETKX3lWgFsTfcq0FNn0JXEQonCnetBp0//uLp+6a0yidz8yvgs5NIi8VumMFIb4jdvQi5X2F50dgtrIgWNxsPh4YRW1VSje1x+B2oFaWVd/VlHCsPg8O89F7PJ/uCi8CW/pj8nqWrrAtpkt5ZBjiR2FcohVcQE1vBaCqpO64odz182oBeieQWL3yjLjOvuGE6sFRIZkcHut8B/076o0L06B1AjLnQ3uRlY/Guz8PqywE3Vc7QeHqg4e23oU/9iXcB4HcxT5TkgAvV2DdfgemuvMwIvuVx4YAL0Qap+j08K7IRcDlC2QA90rAPWaM0BRfy0AxrnthfqsBP/BejAZ2ZqZxHxtWvW8DO24ODSWCCIFdpifwu072Fp0CmgBCQ1cRboC35Izxuu9dzk4O4wTANBKK2393QI9NoLVaHZ6ck+0Jn8W8jrUmSW4i+BrKb9LWqKQ9tvbgNq8M5
 VBPlci7Q
 7HRVGtH46Fcl/659pC6L/B7vLL37G90SqAlTAxw0R1OPcoYzonkidyeoSa5PW7lpszo1BceP+5eHRxblrlp5qv40ELWoxMzWLKBSahKSDs5X3u8FMB0eDhmiR6aY1AUxjUO2QBJ4zSI6R5yK+XejqCxMamt6b4nlS2Zs7SfR1LWAPYeZYdKqTj8OJsWR3BFxPEVOL93Mz6o54K/zyjVfk+IXv9jj7yp7RG3x+aIp4o4vDMX7jJPDPNiHMHG85lNxxAqFaBycFCS8Ilu+aWJWhxAccVLbp1/oEUhPQ39RglEMrYkzDdrndTMEG9nBkkHhD+zAE/2JYxERoqyL6+j6k7XrTZOPH1HzEbyNVXb0GWGxH5CZ5JA+UY34vLPEtmrPAKMVT78WLrsxZjYiXa535tdM0izMOEBzIG0YvC7b0Gi8+DVYxV9vsPePltrlttECdDeWLd+/ivqW4YVIoNTqjV15B3nXNzMzfjF6w4L1/VMwfzjc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 3:29=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>

[...]

Argh I copied my draft cover letter over the diffstat. My apologies -
here's the rest of the cover letter. Base commit is
05f7e89ab9731565d8a62e3b5d1ec206485eeb0b for your convenience (it's at
the bottom too - this should be 6.19).

Nhat Pham (21):
  mm/swap: decouple swap cache from physical swap infrastructure
  swap: rearrange the swap header file
  mm: swap: add an abstract API for locking out swapoff
  zswap: add new helpers for zswap entry operations
  mm/swap: add a new function to check if a swap entry is in swap
    cached.
  mm: swap: add a separate type for physical swap slots
  mm: create scaffolds for the new virtual swap implementation
  zswap: prepare zswap for swap virtualization
  mm: swap: allocate a virtual swap slot for each swapped out page
  swap: move swap cache to virtual swap descriptor
  zswap: move zswap entry management to the virtual swap descriptor
  swap: implement the swap_cgroup API using virtual swap
  swap: manage swap entry lifecycle at the virtual swap layer
  mm: swap: decouple virtual swap slot from backing store
  zswap: do not start zswap shrinker if there is no physical swap slots
  swap: do not unnecesarily pin readahead swap entries
  swapfile: remove zeromap bitmap
  memcg: swap: only charge physical swap slots
  swap: simplify swapoff using virtual swap
  swapfile: replace the swap map with bitmaps
  vswap: batch contiguous vswap free calls

 Documentation/mm/swap-table.rst |   69 --
 MAINTAINERS                     |    3 +-
 include/linux/cpuhotplug.h      |    1 +
 include/linux/memcontrol.h      |    6 +
 include/linux/mm_types.h        |   16 +
 include/linux/shmem_fs.h        |    7 +-
 include/linux/swap.h            |  185 ++-
 include/linux/swap_cgroup.h     |   13 -
 include/linux/swapops.h         |   25 +
 include/linux/zswap.h           |   17 +-
 kernel/power/swap.c             |    6 +-
 mm/Makefile                     |    5 +-
 mm/filemap.c                    |   14 +-
 mm/huge_memory.c                |   11 +-
 mm/internal.h                   |   24 +-
 mm/madvise.c                    |    2 +-
 mm/memcontrol-v1.c              |    6 +
 mm/memcontrol.c                 |  144 ++-
 mm/memory.c                     |  109 +-
 mm/migrate.c                    |   13 +-
 mm/mincore.c                    |   15 +-
 mm/page_io.c                    |   83 +-
 mm/shmem.c                      |  227 +---
 mm/swap.h                       |  179 +--
 mm/swap_cgroup.c                |  172 ---
 mm/swap_state.c                 |  306 +----
 mm/swap_table.h                 |   78 +-
 mm/swapfile.c                   | 1517 ++++-------------------
 mm/userfaultfd.c                |   18 +-
 mm/vmscan.c                     |   28 +-
 mm/vswap.c                      | 2008 +++++++++++++++++++++++++++++++
 mm/zswap.c                      |  142 +--
 32 files changed, 2942 insertions(+), 2507 deletions(-)
 delete mode 100644 Documentation/mm/swap-table.rst
 delete mode 100644 mm/swap_cgroup.c
 create mode 100644 mm/vswap.c


base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b

--
2.52.0

