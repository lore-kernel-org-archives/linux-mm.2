Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C485C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 21:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082E56B0088; Fri,  4 Sep 2026 17:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00DB06B008A; Fri,  4 Sep 2026 17:14:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEFC56B008C; Fri,  4 Sep 2026 17:14:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD8C56B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:14:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20F9712022D
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 21:14:36 +0000 (UTC)
X-FDA: 85177333752.28.8E656DC
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5222014000B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 21:14:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MJSQK4Zo;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788556474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bvjoQwE4ZDaiwAW0jTIm2X9dCshUZub+PI63iQkxm4U=;
	b=Umd8cBUd5KMCKlpgUiboVp/zmAb3+ciwHo0ed1pfDWFvVp1F9036qv1jVaoZVhQ8vz2cjw
	rhZI73c5fY+47WE8F63MiTj4Xo3WRYH+G6SpVnOmgi9EttHPZoRMqm8K5HLv9dlyBCNV8q
	5Pys6ysSYVdbrWHSKwbu3PWgk4nuqKk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788556474;
	b=Z9q4D3dsEP8saGLjuSmxDCJuafSevEmguh9QgL3J6G4HGTvarvZSZHzuv0slSkWJA9R7sO
	gB2mBpg/ANPlz24bVJFlN6iHKo36S5p8B0vlLSjLZD/hmYZ76BBp7Atjwq1zZ7+IjCRbm4
	0CLCamkYrzsmz6n4G35xLE1PI18IGOc=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MJSQK4Zo;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49b0dbfbf7bso11637475e9.2
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 14:14:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788556473; cv=none;
        d=google.com; s=arc-20260327;
        b=Xezz6DpW98JTuL989Hy8D+esq6xqMHeu7+Ry8jPwXSFhmG2pZlDF1ZmJv/QIYRadHk
         p/3B9nBQJp6/MD7rWdbFu3dTaCtMTD1/7CF4Ws4+LHBOxkCW2vgkym9MxXZI9KKIBfPm
         VScclD7oWMHMXxuckyNWc3emC3/rbY45rvvCm7ql55xePHIJ1g/8h4HjsbB1lHAB3RC1
         AG671E/+1uF7/1nNG0o6pB6GS7kssH1daJ6avzpH37yRiIb+awQpdka+VuvCF+ky2wOW
         6HKdpichjGV9rQRQexD+3Dy1O1icsipGg38hK4jkdpScCHJke1/ek/c/fzeii1vMQpUU
         oSYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=bvjoQwE4ZDaiwAW0jTIm2X9dCshUZub+PI63iQkxm4U=;
        fh=hBu3IdIzriexa/vm7+y9017h0uPr/BW8NbY/CaQ1aaE=;
        b=J01iXmTIXF8w9TYM2wx62hURcYwR98CUW1XuQUU2ZxcuJGHEBMfdBHoAGF3B+cB9BJ
         0jwt1uZZA5o298g2KFS9vUvPLArHqsEFaPpMJJGb4yd6IxeBLvEh04wO4qpr4iJ/hzV9
         cP2I3T2EK1XCrhfcXo1+MErkyqtxlXE1RWCeBUyb4VjQ/uJhSHLp7KZXqDg+2bZsyxYB
         Eqyy4Mk0/as0eSOEMnE0E4LSooVM0WT340lmBzIR1y9i9NNrnnEuh3j6qEWBRRE+OQqy
         ojwpBKPMU5udK8wzh2ICZqUPa9fKrXIJccQ6Q4GQ7mFzOZ4ytkWxjJU05PvUX+8+ytLq
         ZL7A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788556473; x=1789161273; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bvjoQwE4ZDaiwAW0jTIm2X9dCshUZub+PI63iQkxm4U=;
        b=MJSQK4Zoe9hcZsVIVyBRmLxCjesPT4IsRCq8M6024l6qeKYTGmookx83pdg82KtwK6
         bEoVMnbXELmkaKRzpNNVJjaiI1a9JUig004qH+RGFAEHO/v9Spmp2o7RFle/JWU4o5DA
         pInp7TBgxIRW+qZ+k+RT0PBZWo53jYSD/ScFH3m3FuuToS0DuVVBceJ5zJjeCYmkQ1E6
         YVPfNzi4J+Qmf2g1qYbUsF6OtkmB5P5kOLpwyBWtjNzceGPYeBmQs4NUDl+2utQW8a+w
         5InsLe0IvmaGGQAS/zm2jlvVKwpUrZgwigTCCZcR5BW4BoPQsRUFI6w6nz95iuAJW2+N
         YMIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788556473; x=1789161273;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bvjoQwE4ZDaiwAW0jTIm2X9dCshUZub+PI63iQkxm4U=;
        b=JSpdk6CqglU2egv9s4S39lDkW9sF6J59mGHofOl0XX6xiCxkzFSQfytVsFX30MrQF1
         5SctmrpD7veAnSFs52McWzGMHvrikde0e8dXHzxufGxPPkS8uE10e9iPH9tgEfPTIWVM
         AQFtFvpC5AtWZBFzIeDG/fZFjKqW+GzcEVpTx+j1l4LmPJL8qjIsZPZJ9rIQstZG7Vvn
         Euxwthiiwz4zYZHKKJu9OHiOj2WWmAOt9gYc/ZrshfQYMK7q+fLiHknMt29O7MTpOQ86
         uThf8gpFGEuyPZYt/Bik+FGwFM1gLSX/dRPNDWYpEoSWu3vtL6hBqvqs9n6SBUqdH5v5
         kwzg==
X-Forwarded-Encrypted: i=1; AKwUvBzE1jeVpwpSPHnZ23puTVxQNZjSWNdb8lLbLEg+tLkm+ocii2beqOlbn6kjoBcI/rR2P8rSFLGs4w==@kvack.org
X-Gm-Message-State: AFuF++mZUlaKVeDqiHiWTMGZuNCDZw+DKMuckyE9mEh2IgdAeMe4Txmu
	mxMhKNQQJzdIdULa6ctAxnWdvy2nvUMe/L/x55HE+GbSe/V826trlKV3BqnHMfs7jooU1OBcUh3
	RnNlaNgmFwSQ6SatgzvdpB/CcgjbzY7c=
X-Gm-Gg: AYBFou2mdSwk/5lmuzQxxzy300JOZdd63pd3tJ++4EFNmkmDpCovlsxbwVgk+s702ai
	MCOfTAHGeGzdVsyrQgqasnrRlprAkN/6zgcqj77Kbl35YaF/ehtaoMzBrRV7Mz/+madxO1u82pN
	n+zm8PK8Hq0cQdZN8EnSwCmGggsi2gX1eyRRh0sTTo9xVV4HIxN6BqIJ/LAy/G6O2dnD5bEhirr
	8qIPFBJBN/x8VHK8bNDBkJ+yfcr2ck/HQpMA1n3qXl5xreab3h6ORQDicTmZuMP7iwU8KsLvm5O
	je6BlW9HWp6IzZj+7GBsC0v8I2KOCVJo+pDaIf50jJhh+pcYeA64g605qrQ5JXa5A6LzjMQlr8z
	A
X-Received: by 2002:a05:6000:29d9:b0:484:3310:710f with SMTP id
 ffacd0b85a97d-485872934dcmr13557408f8f.27.1788556472698; Fri, 04 Sep 2026
 14:14:32 -0700 (PDT)
MIME-Version: 1.0
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 4 Sep 2026 14:14:20 -0700
X-Gm-Features: AcwNN1VfnacCjCOIsG0-NjVV5-93v6OYjHgRMeo0vufw1HSKHHIhU85YeFRiLtM
Message-ID: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
Subject: Path forward for Virtualized Swap?
To: Kairui Song <kasong@tencent.com>
Cc: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5222014000B
X-Stat-Signature: 7fucist7th1smao5e1wofhfc6wq669uh
X-HE-Tag: 1788556474-712709
X-HE-Meta: U2FsdGVkX1+KxZeeDFsZAbPzYqzKzPQQjFVaomDDF/fC2LMGUZGPzJf/bQIDP339pseLwqsxW2EdRjzknsDvDUYog9EYvgNTyB6ECepLP2mKbG4SmhSvLXpSONuWlB7c6L9k4pErsKLJTbkUWorzDLWKo/Ht51BIo32KxJQ+HCEIBCfPeSXvOc7YdYMkBkne8ZE2HTD/6mrex3ovWOX6WBW9uWaaJWqbd8et2it2Laga6zbxNMK2kxnH14OcngLYaL1MHPnpk/RU7nexxcbUp8N1ryVVyR/LrIgvx3jjCIReICV/pkuyjjsScx+J5ibQd85dkoP1TzdHQgCLbBbNr/hRSTFTUZX0Rm5yCeaf3nu9gXHjK31f6WU6noKXCgeGwXh2mOVkvbC2XgKu4UYJZpDAURxt+4T/Nncy6E7PQk6zhj43wIpJAOGok4wB2oc0qrY9Jc99kW3AQ+NXBs/bDMtPBVFfpA1j5iE5Ill+47mGo37z2jRC5bGoL3catvEO6AN+TMOAaAfBljFbyzjGlnP3gm+mFo0u35mvj8YK8tshoH9W9uD+vWS0CbmBEdRP173YeqtGKIWVcVMukr9CMl4QjKbhI4BBNy1Z6OwGRwTM1BlRv6Gq0K/atyKbc+SG0qKYyyk3G9Mzumj+Pu/YtXge6qc4JU+MDycdR3RMSpOQI/WeQkxKUw2ssf9ky5RXd1p9/GlqCuU7kh/CaZuV6R5iUOSPeCU+x8ymovS1Wg3GCWYSpAac99ayKWNOT7YWPaqm86bfjzzQMZ+8WQdpaiueqAH5/Co22fAbnY2jykRJgHX10NmuymMJliXS8tKaGoJOtWMDx0/DqmA9KoZSILskob29iErIns2RsdncMVFvCc/wXr6rH8vCcsMPuK4Aoj/fLuOPikDhSIT7mTkDoFk/K7qgsBRWNgFTi7bpAZJOzc2G5J/j3Mo0Dd6Sl8sLvEf/BVh8DGFaoT7/cED
 W6+zLCKb
 IjhT0wUpm8tNye0MMv4Ai+vckLgDnEL1JTKnJSR6ZyI3aoWWXepM2Wfd6QwDrHNtJ+M5qTGExlJYNDGfr9Qk7kgDHmQZDJMIkwyzWtneQAv6HIWn4bXb5guOwnYVecBj7gNoS/C+SUOM/mQA322rl1TPBN3tw8pda9f6l08Wv0oxIBQ7bx/kve02uxqyGzxGtglH1NcGM3KgX2bwL7FqnYQbzySt1eTtnymD7hDss4Dn5WvuuPTQNXdYzMDxP1e4Fo0uPHelcm3reAQyrxq1NOlBb47hdgt2pThHE/QK8AJMmTeZH4M4Bvntkn3Yo/+o8HEIhVdotzlFWCn6PnKfsd9k0GUb20SCvz4PZ8PkHF9bIzOPo+uOOnqo1AF7Zg8+gu9olUoqcD7HxMIaNWzt/OQ/Pld/g93xKtEte3ckcsZiwDUT57bc/tXoVbkOrf1hLC+3ZbClEhPafO2MO1ZKAba3iEwZD1Dz8o1/GiG5kSMsklKJAgv3mHw1bUzwnFFco8HmZsSDCaxi+HwKT/SH/PmD/9/ghDaAoIZUp1+HNI6mTlHxycIefDXHNBKQ3fU64J96Qcc5IfXn/84vGN9XCYFWyXEQaQfOhwoJKfbr+NkU3IG43LcNYJgobrIoupxBbu7I5k2co1Zvgrg8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To Kairui, Johannes, Yosry, Chris, David, Andrew, and other (z)swap folks -
I need some help here.

I'd like to ask for a decision, or failing that, the specific thing that
would get us to one. I'd much rather work against a concrete objection than
keep respinning into silence.

Quick recap: today a swapped-out page holds a disk slot even when the data
never reaches disk, like zswap or zero-filled pages. My patch series
(latest version at [10]) puts a virtual entry in the page table instead and
resolves the backing separately, so zswap stops reserving disk it never
uses and can work on machines with no storage swap space at all.

I've been working on this since April 2025, going through 10 revisions (6
on the original design ([1] through [6]) and 4 on the swap-table-based
rewrite ([7] through [10])). I also gave a talk on it at LPC [11].

Throughout the process, I've been very receptive to reviewers - including
parties whose use cases are very different from my own, like zram users and
the ghost-swapfile-style deployments that want zswap with no backing disk
at all - and the current design reflects that:

* Kairui asked that this be optional, not a replacement [12]. It is now:
  vswap is opt-in behind the vswap= cmdline parameter, and with vswap=off
  the existing swap paths aren't touched at all.

* Kairui also pointed out that if I kept shrinking the metadata I'd "end up
  reimplementing the swap table format" [12]. I took that feedback, and
  reworked the entire series on top of swap table.

* Per Chris' requests, I've figured out ways to minimize memory overhead
  [13]. On a zswap-only setup there's almost 0 overhead now, because the
  vtable is merged with zswap's xarray rather than sitting on top of it.
  The indirection is paid for by the tree we delete.

* Johannes pointed out that a physical cluster backing only vswap entries
  still had to allocate a memcg_table, which was an overhead regression
  against my older design on the zswap writeback case [14] (since a swap
  entry occupies multiple levels). I've also fixed this.

* I've spent a lot of time chasing regressions on setups we don't even run
  at Meta - zram in particular [6]. And if anyone's still worried after all
  that, vswap=off keeps the old swap code available.

Numbers are in the v4 cover letter [10]. In terms of performance, vswap is
on par or better than baseline on zswap across memhog, usemem and kernel
build, and vswap=off tracks baseline within noise. I've even included an
A/B experiment on a real production workload (Instagram/django): throughput
on par, latency slightly better, and the swapfile footprint for every zswap
user on the host goes away.

Now, on xswap. Baoquan's working on a series [15] that covers some of the
same ground, and the VM_SPARSE cluster_info idea in it is genuinely good.
I've been reviewing that lineage since July [16] and I'd like whatever
lands to end up with the best parts of both. From my perspective the
differences are:

1. Userspace knobs. xswap asks the admin for a size (a percent of RAM) plus
   a per-device limit to tune afterwards. I'm not aware of any use case
   that needs those, and I don't think users have a good way to answer the
   question anyway - sizing swap for compressed memory depends on memory
   size, workload, and compression ratio all at once. That's precisely the
   provisioning problem vswap exists to remove. The kernel should be as
   transparent and dynamic as possible here, and not add knobs unless
   there's a use case for them.

2. Writeback support. Writeback is core functionality for zswap, not an
   add-on, and a design needs to account for it from the start. This came
   up before, in the discussion around Chris' ghost swapfile RFC [17]: for
   a solution here to be acceptable, it has to work with the primary
   usecase and support disk writeback. Without it, whatever zswap won't
   take (incompressible pages especially) has nowhere to go, and cold
   compressed data can never leave RAM.

3. Cgroup charging behavior. vswap/xswap shouldn't be charged against the
   swap usage counter. It's fundamentally a different resource from
   physical swapfile space, and memory.swap.* should read 0 when nothing is
   on disk [18]. I made the longer argument for this in [19].

4. Data structure (xarray vs sparse vmalloc array). Even with xarray, vswap
   is already on par with or beating baseline. I like the sparse array
   idea, but why are we landing an optimization before the feature itself,
   without any A/B data showing the difference matters?

One thing I do want to be clear about: I'm glad other people care about
this problem. Chris' ghost swapfile and Baoquan's xswap are both going
after the same set of problems, and that's a good sign. It means this is
real and shared, not something only Meta runs into.

What's been harder is the shape of the engagement. Alternatives keep
getting posted and pushed that don't cover all the requirements, while this
series sits without review. I don't think I'm owed anyone's interest in the
problems I care about. But I do think working code, with benchmarks and
production exposure behind it, deserves a fair hearing next to in-progress
proposals.

So what I'm asking for: I'd like us to converge rather than keep two series
in flight. My preference is that we land vswap first, then build Baoquan's
sparse array on top of it as an optimization. That gets the feature in, and
by then we'd have the A/B data to show whether the sparse array actually
beats the xarray.

If you think that's the wrong order, I'd genuinely like to understand why -
after 17 months and 10 revisions I still don't have a clear picture of the
objection.

[1] https://lore.kernel.org/all/20250407234223.1059191-1-nphamcs@gmail.com/
[2] https://lore.kernel.org/all/20250429233848.3093350-1-nphamcs@gmail.com/
[3] https://lore.kernel.org/all/20260208215839.87595-1-nphamcs@gmail.com/
[4] https://lore.kernel.org/all/20260318222953.441758-1-nphamcs@gmail.com/
[5] https://lore.kernel.org/all/20260320192735.748051-1-nphamcs@gmail.com/
[6] https://lore.kernel.org/all/20260505153854.1612033-1-nphamcs@gmail.com/
[7] https://lore.kernel.org/all/20260528212955.1912856-1-nphamcs@gmail.com/
[8] https://lore.kernel.org/all/20260612193738.2183968-1-nphamcs@gmail.com/
[9] https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.com/
[10] https://lore.kernel.org/all/20260825153238.2695446-1-nphamcs@gmail.com/
[11] https://lwn.net/Articles/1016136/
[12] https://lore.kernel.org/all/CAMgjq7AQNGK-a=AOgvn4-V+zGO21QMbMTVbrYSW_R2oDSLoC+A@mail.gmail.com/
[13] https://lore.kernel.org/all/CACePvbVXQWgcPD-bgK7iDba4NFLo2tT89ZbLOa03maJU4er4ag@mail.gmail.com/
[14] https://lore.kernel.org/all/aZyFxKGXc8J6PIij@cmpxchg.org/
[15] https://lore.kernel.org/all/20260827094509.1016740-1-hebaoquan@kylinos.cn/
[16] https://lore.kernel.org/lkml/CAKEwX=Pe+qMZd2xhnU-PAGQtgXkp56c-JwYCbt2Lux9htgB67Q@mail.gmail.com/
[17] https://lore.kernel.org/all/20251121114011.GA71307@cmpxchg.org/
[18] https://lore.kernel.org/all/anYIboHEUZb4fhHv@cmpxchg.org/
[19] https://lore.kernel.org/all/CAKEwX=P4syV38jAVCWq198r2OHXXc=xA-fx1dk6+qYef6yzxWQ@mail.gmail.com/

