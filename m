Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37315C636B8
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 21:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ACB46B0088; Sun, 22 Feb 2026 16:01:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15A486B0089; Sun, 22 Feb 2026 16:01:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0595A6B008A; Sun, 22 Feb 2026 16:01:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1CB06B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 16:01:12 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F4618C192
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 21:01:12 +0000 (UTC)
X-FDA: 84473312784.08.A564502
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id D99911C0010
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 21:01:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b3BHLLtH;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771794070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5/EreUI3PYEoM8W+N6LkCVXn6S5UJ4yxGlTwX9CuArc=;
	b=o83tu8j2LUx4LCB9lem1uDU0OQAWFAyxbwAS/26ir7nmoJe1/4QSto9lq6Xtu/ldPncug/
	wBFlhbFYxm0MzPVYPNgGl1BpJdk0hhi0rmqbbLrTCcuLBTdvE6H43UP1c2fESsQXTLQnzY
	nvirg97jv28haMp0bjStdhCvrfdqpoI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771794071; a=rsa-sha256;
	cv=none;
	b=vkjH9+Q/qmyRqtULCkf1DrbWe9ASMBqLXdtOg1zG3SVGpqgGpeFRt1vQY+pzSX7HSy4uDe
	KMP5rROzJXvxQ+HBTf3GP+wbUYdRZWWDN6orEcrzmIADXJiGGQ81uxGOFAk9z8c8/coHcK
	34hYF2TKq3ws2eI6terHQNa973YILUQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b3BHLLtH;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 25FB660121
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 21:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8482C116D0;
	Sun, 22 Feb 2026 21:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771794069;
	bh=9dgpyCU7wBH5PiWPlWORpFRzmJ+0P/zw9AKC0VdVIy4=;
	h=From:To:Cc:Subject:Date:From;
	b=b3BHLLtHdoAHRS264ll9CbmqPJT1gNzcglRsv7rq45LwnrTrOBUzhC0bLDgSWMit5
	 QYuZWyIoULVi8VFIlnSY5C1ez1z2AV2XP/PlVBHfg4lhqkOosdeRzsb31hQHEcyl/O
	 Sk/7NR8b46Yb7uKTIPH1ea2AaO+Ly1oEunqbolSDqKZBR+TCH22OLGqXsnLVgIc3bN
	 qvHIURwWzM5Yh6M4w9XNzu4wiQbxF2rGXOgKBgn+wCBh+Yx4YOH4vtBWnBL796iWD/
	 rmhJgqvDT+tDHbwTxsVOs/P/iKF1knFu+qiW4KPvRp7hgQZ3Ydz5PsCnGW3WPEsyoo
	 /z4pbxTbc28Kg==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Yearly Retrospect (2025)
Date: Sun, 22 Feb 2026 13:01:01 -0800
Message-ID: <20260222210102.153347-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gzzzunu1ytioa8trp3dfncdwwcf1mxax
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D99911C0010
X-HE-Tag: 1771794070-42572
X-HE-Meta: U2FsdGVkX181BuKdu6R4nl9h6cJzCoAEZMdgocjh5fk4LPFLnrFL7t/LMxBpsKzd3eqL2nH0nUXRBpSGiCwZv1PF0j+Rcm48Q3WB0OgM/Fg4QDD4DHGtE2EC1Ujy4ha/5FoF5tpJu5wc5qeCNQqRB3T2/+83Hrivy0ib1RHJtzzRrwyUjC/qyG9A6BmrESuuYBkIm9DyAFWjO2qV9FEyM7ORyaLI78IEJtnk4LmzEMaT7IFM56qeIxP57ErChmtOWGscKIKiEfDL9GFBwkO0ctndMoha1L5S9qV4w5KbzGW0YdU2jSwdkgGqt5+h4vBhmWiE8Bg/C1URhziX+dQMzmvKGCKup0lTfL7w8HnmpIkGExYRJtNDwjFSTIAlG7yn1z+jH4LFyd5MObXxSbMiz7MoENTecDhu2O3WwyZtuDLIIMUkCf4QOdxAHNJqntRZK2nc+BT8Q1sE7lWaBqrw4jPWWP9heZnucq5YyraArgdNOI6nP+TjCwx1RV30AJDJiANLfTzip/3lDzN2CDgvFHweCnE0T//bClLuzJHhc7jW8Ev74sDaXsmLYKLAxIFB2KY1eigofLF6ZP/Z6kc1XOMEADqDjO45wdTye1APosnWijUdRgvUSCTk2+xP2QbheEAYxMDNGHPNyQwQnyaO9teeIGeh06uZle/tJRHCnW62VkA1fZAs/yrnS0SZlLo9K1g2T8JzEDd4hi+D/2xoEMnbQ3tilSt1E+XXQ/JthkvSa+hzaaBpRkrg8Df/iDkRD6D53La9wnST2UmxAd17T1k/c4xtPVG/8gocoXm79pNZnZtDoBl7YdxwXyp6MoGxHwXLjcOhVh46IKmcZ8faX3S07RYkgl2qajnO4mm5p8RF15wbReEc39hlE/sAyqPN+yUUN7wvjLNATTCuk2n3SNfC0DgWVjmhLYU0g/lb3vMCFwoID1EllW7ElzOH5VuJ71GOQpBp3ciGiX8pbN0
 kcPFzzOD
 NE8E+X4dMuOPZorTGmcTNexjpcAgdS1TXTtF8Ptl3U1fQ1zTcgCwwpy2C4Qok19+px/JBWNv52usE+lgsZlMKSTuB7iJBloMuvCR8HKWpxivw21cExpFruiuowsjfPRsSZZ1qJi8517p4JDrgd/7TPKcttcjMLwUNIl6KCytSkioJlY+pXv7tXAHGCJM5RY9j/2CtcmFZjekZjsQ07J1pZhZ2UgdfQpelqSsjmRdsjTgz8UZZY9zZLztjmYNLvk+7OcoN7SMrYN4Rxd2mTtdKtj5mbxfHNbAKVEaEBlV5J+RNtUAI8/kRzLqpts/JQgFcOfER5afMoQgEyfvCjXZpD7jppmFWOfTKsOAxOp00/VyNb7yZBak/UDyGT0SLKyPYsBr0xTdGOrlkBTR8OMj7MRNoGkXIibWzWKpiQWWx6zylOFtJaw180gIwWbJM55lZJcw8Idvlh5a3Eh8MaieTF1YBuptLY6ujANx0tL/1OdUul2Fam9WCV8zIAKTliO9/o6JCtGvWkOObkyCcRLscIwa2HXbG+tHCyG7NNlr/NCt8FdbKJ53EYiZCWjCIz7rEhgcRDTjV/f2xj8iteXyDwCD74DVK4/ZsWutZyahLjRLPnN5NQzXBdPv0wBU7g2piHwgUTNFcuDE/W/Y9vuB1LC9tLLQMzK9Rv8AcmBwOmS1T+vFj3fG1ykdxOSCpLkVQdWoBd0ea1ZpV/l+6rg3CyH5gCb7Q+ZIDl73AcWkUU1mYU1Lx1xSLTGoLUObijN14+Vf29PJrXyKknsLQzSHT0UGhCnSvakQAad0ejBwd1O4BN62TrG0ZkRLY28wiGb1RMmQ78JioXnD97KXrc5k50GcDQXFw0Z78XfzVkEWa7Q9FI6ojPcwStFmD+1ivGk1vJXq0HifHs7f6gfPOvqL6sUd8CRfhxFjkppoA7IauosXBKk+W7Np2alBs1P/XNDQQ1HiETiXF54rYRJLEU0fKNUnAfVkJ
 2zjMkgHe
 8MHZf8CWhv59ovYYGjw3n1SFDDgDizxQ17fYT6MD5SWuRqixj82HgSIDgliGWVqP4scKz9KgHgbFjwooqsOimh7bkHHsEuWOgjAq5WymfcOa3+REoXNTCUYwGJ2TOV2OwPxU+3sL/vdNKGigQ6NxVgt2K1z9VB0hwWntwu1pflh7DaFSHgHgFDi/m1e2gU8s1W2TfRIB17IpQ0llJSCVkBOE5VkKb5NGk5WmBfGHMCan5ubWKfd76T9Uh9+BSzIB7/hVrIUqx7UH98hzbXLZPWu2gWsbEam/nrLAceD1pBJ4aOqwCO/RWE3+Us7kiOyJkvRkqfSbS0jfcAOmHhphoZxZoLSjDtP7HHPVvSicXvkXjFTOBkzv4Fc8xyEA8XnW/OoWIPgaDyMldJsxPZqzzp/1pYMLBJ/L2v+kZqQbb/apUB6QDk85WtzYoPZOs9sZjpo32vOz1W/hELBhq2YaeWDZfBrtkz9M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


It is a bit late, but let me share my retrospect of DAMON development for 2025,
before my memory goes away.  The yearly retrospects for 2022 [1], 2023 [2] and
2024 [3] are also available.

Summary
=======

2025 was the busiest year for DAMON development of its history.  33 people made
390 commits for DAMON in 2025.  Those numbers are 65 % and 157 % increase from
those of 2024.  Before 2025, 2022 was the busiest year that 32 people made 210
commits for DAMON.

Contributions from Meta except myself (observabilities for hugepages and LRU),
Micron (access-aware runtime memory interleaving for CXL memory), Huawei (arm32
LPAE support), SK hynix (memory tiering related fixes) and individuals
(important fixes and refactoring) were impressive and notable.

Major motivations that led DAMON development in 2025 were self-tuning,
system/fleet observability and memory tiering.

Events
======

There were many events in 2025.  Introducing only a few notable ones.  A more
exhaustive list of events is also available at DAMON project site [4].

Adoptions
---------

In April, OpenSuse kernels build-enabled [5] DAMON.

In June, DAMON was build-enabled on mainline by default [6], and reverted [7]
by Linus Torvalds.

In October, DAMON module for system/fleet-wide access monitoring (DAMON_STAT)
has build-enabled [8] on Debian kernels.

DAMON Feature Releases
----------------------

Many DAMON features have developed and landed on the mainline in 2025.  Listing
only a few of those that stands out to me.  A more exhaustive list of features is
available on DAMON user-space tool's DAMON features list [9].

In February, Linux 6.14-rc1 was released, with page level monitoring [10]
feature.

In April, Linux 6.15-rc1 was released.  Usama and Naht from Meta contributed
huge pages [11] and LRU pages [12] monitoring/operation extensions.  The
release also introduced the monitoring intervals goal auto-tuning [13], which
made DAMON just work.

In June, Linux 6.16-rc1 was released, with DAMON's memory tiering automation
support [14].  The feature is not only for memory tiering but general per-NUMA
utilization based access-aware system operations automation, though.

In August, Linux 6.17-rc1 was released.  In this release, Bijan and Ravi from
Micron contributed access-aware runtime memory interleaving features [15] for
their CXL memory tiering solution.  A module for fleet-wide access monitoring
(DAMON_STAT) [16] is also introduced.

In October, Linux 6.18-rc1 was released.  In this release, Quanmin from Huawei
contributed [17] arm32 Large Physical Address Extension support.  Yueyang Pan
from Meta contributed [18] huge pages observability on virtual address space.

In December, Linux 6.19-rc1 was released.  In this release, per-node per-memcg
memory utilization based DAMOS automation [19] is introduced.  Motivation of
the feature was per-cgroup memory tiering.

Presentations
-------------

2025 was an interesting year in terms of presentation, since I found two
presentations from someone other than myself that introduced DAMON use cases.

In October, Asier from Huawei presented a DAMON use case for THP [20] at
OSSummit EU in August.

In November, Ravi from Micron presented a DAMON use case for CXL memory tiering
aiming both latency and bandwidth improvements [21] at Linux Memory Hotness and
Promotion meeting.

I also led some sessions at conferences in 2025.

In February, I presented DAMON in whole, at FOSDEM [22].

In March, I led two sessions discussing DAMON development status and future
at LSF/MM/BPF [23].

In June, I introduced DAMON's new intervals autotuning feature [24] at
OSSummit NA.

In September, I introduced DAMON's monitoring mechanism and usage [25] at Kernel
Recipes.

In December, I led two DAMON discussion sessions [26,27] and one presentation
[28] at LPC special-purpose memory micro-conference, system monitoring
micro-conference, and refereed track, respectively.

Statistics
==========

Like previous yearly retrospects, I ran my script [29] to see DAMON development
statistics as below.  In 2025, 33 people made 390 commits for DAMON.  Huge
appreciation to all grateful contributors.

    $ ./lazybox/version_control/authors.py ./linux --skip_merge_commits \
            --linux_subsystems DAMON --year 2025
    1. SeongJae Park <sj@kernel.org>: 310 commits
    2. Quanmin Yan <yanquanmin1@huawei.com>: 10 commits
    3. Bijan Tabatabai <bijantabatab@micron.com>: 10 commits
    4. Enze Li <lienze@kylinos.cn>: 8 commits
    5. Sang-Heon Jeon <ekffu200098@gmail.com>: 8 commits
    6. Honggyu Kim <honggyu.kim@sk.com>: 6 commits
    7. Usama Arif <usamaarif642@gmail.com>: 6 commits
    8. Akinobu Mita <akinobu.mita@gmail.com>: 3 commits
    9. Yueyang Pan <pyyjason@gmail.com>: 2 commits
    10. Yunjeong Mun <yunjeong.mun@sk.com>: 2 commits
    11. Nhat Pham <nphamcs@gmail.com>: 2 commits
    12. David Hildenbrand <david@redhat.com>: 2 commits
    13. Arnd Bergmann <arnd@arndb.de>: 1 commits
    14. Dan Carpenter <dan.carpenter@linaro.org>: 1 commits
    15. Lorenzo Stoakes <lorenzo.stoakes@oracle.com>: 1 commits
    16. Balbir Singh <balbirs@nvidia.com>: 1 commits
    17. Swaraj Gaikwad <swarajgaikwad1925@gmail.com>: 1 commits
    18. Lokesh Gidra <lokeshgidra@google.com>: 1 commits
    19. jianyun.gao <jianyungao89@gmail.com>: 1 commits
    20. Alexandre Ghiti <alexghiti@rivosinc.com>: 1 commits
    21. Qianfeng Rong <rongqianfeng@vivo.com>: 1 commits
    22. Stanislav Fort <stanislav.fort@aisle.com>: 1 commits
    23. Bjorn Helgaas <bhelgaas@google.com>: 1 commits
    24. Nathan Gao <zcgao@amazon.com>: 1 commits
    25. Linus Torvalds <torvalds@linux-foundation.org>: 1 commits
    26. Thushara.M.S <thusharms@gmail.com>: 1 commits
    27. Su Hui <suhui@nfschina.com>: 1 commits
    28. Taotao Chen <chentaotao@didiglobal.com>: 1 commits
    29. Seongjun Kim <bus710@gmail.com>: 1 commits
    30. Marcelo Moreira <marcelomoreira1905@gmail.com>: 1 commits
    # 33 authors, 390 commits in total

It is a dramatic increase of the amount from that of 2024.  In 2024, 20 people
made 157 commits.  So 65 % increase of developers, and 148 % increase of
commits.

2025 was not just busier than 2024.  It was the busiest year in DAMON's
history.  The stats for the whole history of DAMON are as below.

    $ ./lazybox/version_control/authors.py ./linux --skip_merge_commits \
            --linux_subsystems DAMON --year 2024
    [...]
    # 20 authors, 157 commits in total

    $ ./lazybox/version_control/authors.py ./linux --skip_merge_commits \
            --linux_subsystems DAMON --year 2023
    [...]
    # 25 authors, 180 commits in total

    $ ./lazybox/version_control/authors.py ./linux --skip_merge_commits \
            --linux_subsystems DAMON --year 2022
    [...]
    # 32 authors, 210 commits in total

    $ ./lazybox/version_control/authors.py ./linux --skip_merge_commits \
            --linux_subsystems DAMON --year 2021
    [...]
    # 11 authors, 75 commits in total

2022 was the busiest year where 32 developers made 210 commits.  Compared to
the year, the increase of the number of developers (3.12 %) is trivial.  But the
increase of the number of commits (85.71 %) is still impressive.

Again, huge appreciation to all grateful developers!

DAMON User-space Tool
---------------------

Development of the DAMON user-space tool was also busier than 2024.  12 people
made 1,309 commits in 2025.  In 2024, 8 people made 1,031 commits.  Note that
the 2024 statistic counts me twice.  Again, huge appreciation to all
grateful developers!

    $ ./lazybox/version_control/authors.py ./damo --year 2025
    1. SeongJae Park <sj@kernel.org>: 1291 commits
    2. Bijan Tabatabai <bijantabatab@micron.com>: 3 commits
    3. Usama Arif <usamaarif642@gmail.com>: 3 commits
    4. Andrew Paniakin <apanyaki@amazon.com>: 2 commits
    5. Bijan Tabatabai <btabatabai@wisc.edu>: 2 commits
    6. Wu Cheng Han <hank20010209@gmail.com>: 2 commits
    7. Michel Lind <salimma@fedoraproject.org>: 1 commits
    8. SeungSu Baek <ssbaek@korea.ac.kr>: 1 commits
    9. Bijan Tabatabai <bijan311@gmail.com>: 1 commits
    10. Nhat Pham <nphamcs@gmail.com>: 1 commits
    11. wangchuanguo <wangchuanguo@inspur.com>: 1 commits
    12. Akinobu Mita <akinobu.mita@gmail.com>: 1 commits
    # 12 authors, 1309 commits in total

    $ ./lazybox/version_control/authors.py ./damo --year 2024
    1. SeongJae Park <sj@kernel.org>: 753 commits
    2. SeongJae Park <sj38.park@gmail.com>: 264 commits
    3. Mithun Veluri <velurimithun38@gmail.com>: 4 commits
    4. Honggyu Kim <honggyu.kim@sk.com>: 3 commits
    5. m8 <umusasadik@gmail.com>: 2 commits
    6. Yunjeong Mun <yunjeong.mun@sk.com>: 2 commits
    7. Akinobu Mita <akinobu.mita@gmail.com>: 1 commits
    8. Alex Rusuf <yorha.op@gmail.com>: 1 commits
    9. Piyush Thange <pthange19@gmail.com>: 1 commits
    # 9 authors, 1031 commits in total

Paper Citations
---------------

I published two academic papers introducing DAMON in 2019 [14] and 2022 [15].
The number of citations for the two papers continued its exponential increase,
as below.

    2019-published paper: 10 (2024) -> 18 (2025)
    2022-published paper: 7  (2024) -> 14 (2025)

Conclusion
==========

So, 2025 was the busiest year of DAMON development in its history.  That was
motivated by automation, observability, and memory tiering needs.  Meta,
Micron, Huawei, SK hynix and individuals made the major selfish ;) and grateful
contributions.

References
==========

[1] 2022 retro: https://lore.kernel.org/20221229171209.162356-1-sj@kernel.org/
[2] 2023 retro: https://lore.kernel.org/20231231222250.140364-1-sj@kernel.org/
[3] 2024 retro: https://lore.kernel.org/20260216210625.68098-1-sj@kernel.org/
[4] 2025 DAMON news: https://damonitor.github.io/posts/damon_news/#2025
[5] OpenSUSE DAMON enable news: https://social.kernel.org/notice/AtQ94OoroZhOGuGuAq
[6] DAMON enablement: https://lore.kernel.org/all/20250610173228.49109-1-sj@kernel.org/
[7] DAMON enablement revert: https://git.kernel.org/torvalds/c/aef17cb3d3c438540
[8] DAMON_STAT enablement on Debian: https://salsa.debian.org/kernel-team/linux/-/merge_requests/1616
[9] 2025 DAMON features list: https://github.com/damonitor/damo/blob/next/src/_damon_features.py#L235
[10] page-level monitoring: https://git.kernel.org/torvalds/c/626ffabe67c2359f3
[11] hugepage monitoring: https://git.kernel.org/torvalds/c/0431c42622612a96cce
[12] LRU-active monitoring: https://git.kernel.org/torvalds/c/3b23a44f1f1967415
[13] intervals autotune: https://git.kernel.org/torvalds/c/1eb3471bf5749ff3769e
[14] memory tiering automation: https://git.kernel.org/torvalds/c/0e1c773b501f3
[15] memory interleaving: https://git.kernel.org/torvalds/c/a2c24eae5a15f79673e
[16] damon_stat: https://git.kernel.org/torvalds/c/369c415e60732b7c8ed333688915
[17] arm32 lpae: https://git.kernel.org/torvalds/c/09a616cbb371e6b843e536f00e38
[18] hugepage on vaddr: https://git.kernel.org/torvalds/c/408b299a62ec207fa5f21
[19] memcg tiering: https://git.kernel.org/torvalds/c/d3946c5f4c1c5db63532eb433
[20] THP use case at OSSummit EU: https://sched.co/25Vrh
[21] Ravi at hotness meeting: https://lore.kernel.org/all/d952a84f-332e-8f7a-4816-2c1cbd8f5b00@google.com/
[22] Talk at FOSDEM: https://archive.fosdem.org/2025/schedule/event/fosdem-2025-4396-damon-kernel-subsystem-for-data-access-monitoring-and-access-aware-system-operations/
[23] Sessions at LSF/MM/BPF: https://lwn.net/Articles/1016525/
[24] Talk at OSSummit NA: https://ossna2024.sched.com/event/1aBOg
[25] Talk at Kernel Recipes: https://kernel-recipes.org/en/2025/schedule/overcoming-observer-effects-in-memory-management-with-damon/
[26] Session1 at LPC: https://lpc.events/event/19/contributions/2066/
[27] Session2 at LPC: https://lpc.events/event/19/contributions/2059/
[28] Talk at LPC: https://lpc.events/event/19/contributions/2075/
[29] authors.py: https://github.com/sjp38/lazybox/blob/master/version_control/authors.py


Thanks,
SJ

