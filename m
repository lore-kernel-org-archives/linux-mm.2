Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79011C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 21:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495556B0005; Sun, 28 Jun 2026 17:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447706B0088; Sun, 28 Jun 2026 17:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3363B6B008A; Sun, 28 Jun 2026 17:19:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECDB66B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 17:19:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B0D61C6944
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:19:15 +0000 (UTC)
X-FDA: 84930587070.26.28061BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id DDE44C0003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:19:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oJ9Yiaqb;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782681553;
	b=ofRVEpcMtP+bEBLvNlTfP2Dq6i8lj/FQ/rMQ12myZ6DB1fKR3fDnwET/q3ps7XqaRMhVR5
	yIvRNJnsN3UxjXZv1+d4t/7n/hqJO+uv6dwcXOIF9KqovgmfFHrGJZwaKdR9SbusPg/lo5
	IKLBP3xhrEhTaWnMEx+3yKamZg4ocZo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782681553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LZYPVTpGhzIR/3JidaZiBA9f/a3uk5W26W23VJ/P6O0=;
	b=Nn70PFM5X5Xsm6vCgqMs2qJ9PM23ilNiT3S35gj1MF9nXsMT8TpivVvwC47VKNM/ExC0kW
	l38nnwEuPBGXyZmHvs8UJqAw5wZF3Ptgvpy43cgAI6v/Gc6lIh+yRunSiIlKpov72Oxa70
	cfZ9zZ1j9SUepRi7s8UscdGRx4RTsZY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oJ9Yiaqb;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 402E16001D
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4ADF1F000E9;
	Sun, 28 Jun 2026 21:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782681553;
	bh=LZYPVTpGhzIR/3JidaZiBA9f/a3uk5W26W23VJ/P6O0=;
	h=From:To:Cc:Subject:Date;
	b=oJ9YiaqbF1uA21tYMvB+CmH9tzOY7xlAS3l0YSbBs0Nd/FdG6DfOFfYo+RdNyelVe
	 btFQindtMaH3mAFpVp4W9rFJ5qfQXUzXb1haiienXC/46pXYEmZIBvaXUZFAajG+At
	 WfBg34ljsHMRBEMIasAU0UXi+UWZZVpy/1fX59eSimEv3JOr7Qz7egZclAA98NwcNj
	 Ktvd7H1nXhQsEch8MTrXwWb6FIgN1xR0ir2kcH1ncfKErvyyzWOKiWJMtm7wEpc4Yt
	 Li+1lVtwzgvMI5HMvaAbWv5TTdKuGDZF1oRdqppCyyAEbpPG7jSP+E7WrfLsoOtY5F
	 YFknYK/N2Pa9Q==
From: SJ Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Release Newsletter for v7.2-rc1
Date: Sun, 28 Jun 2026 14:19:03 -0700
Message-ID: <20260628211904.94361-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zxufrd1uczrhmcteh7rhwis9ajiqdh5p
X-Rspam-User: 
X-Rspamd-Queue-Id: DDE44C0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782681553-281327
X-HE-Meta: U2FsdGVkX1+GwVpaQh33qYCb+0H125RE0Bs+qiwgTFywhVGCSqzbe7Ya/0ISoNoYloOe6oVp4zHax62D0RFcTRQPfdA6lPlhq0xNBYGSPIWFbQPPpClxc3uiqNCkvXZ+2S8c1GpFP2L8ndMrRmU+U1BTfB2IhivPXeF58+k0iv+tc7e0i/cdO37amcrDsPY3UiX9UU52D0Emowd2CfLz1gHgPcj9PHXw9MUCCAZ1hLm0rTTpJJnwNvhDK7ejiHRcYHOI8PzcI5KsImE4VmUXJX9KZ4eTHFqxkqxkmMoIdfxEenaplksLUfmXcBnugWz/mjrgNhVjjfuTds4QeDhyTi4p5MFjuHQ5KyakIZOHun4QKkQOeaibxBRamuTUs0wb8rC7DSHfgdkXazbVxG3MJl0KZQQttu01ORI6fMf3bt2c2P4H7iTbc2po166bVg+sqGZA+qDV8csHndSStJwobeF8Rc/XTHSL2GuaHuAMXWQ1OJovarxPK88nUxhzTJnDd39t4RZIaL0v1aH4ej8Q0XvgNANoRKUoGjapvql0JDzje9JtaMt8w8Du0So2sy4o/WQ6H6cKKPqg7lQypqrh8qv8a7h1CC6duK05NfM/UIMBagxkGO9nKirJVReaIJqKaJedszCuavoCAuXrOKv+1AqVUgRoFibNLIe5z2PMEk7CkzA/8txGXQwzi+uetI7Sq2J8PQKZjSB3swsoqravVXefPDpK6Mta/sK6IQsClVUa2D03e0GWi9twvti3Tlr+GmpI5VPquowIa5Yjo9VMvCxi9IQFI00TXb7YHjdurDEqHl13T47h9BxXGJclKk9ysiCwWXVfj+dV+dPB30KPIWq4W3Di+cE2ob2zV/xY56jtU98BQB/YnPGTg+WwbZ86uZu5pt9hxLv+wlj5aO2zBYSCKZGXnHGJM/LLZHDAEWzVCrePI6L9sr3Ua9EaEoi1hRevYkedNyEQtDAHPgd
 +J1OXtgI
 nCYw37U7lVoF5Rhe6Mx+MO8MdFR/EkOlxb5MGI/d0+sb8bS4DvbMnC3cUVV+fcJu633D2lnnccoGkm2u6qM9TRqWOX1rAM8Rk7d8QBhfVmd06l+H0iwxnyVumz1oRRENHn0d9ACxLLqga6KKKUvU98mD6lbZmi9oYsHDFA4uVxjVWU5pJsAP8LBM/8fpmhZOohh2I5ruEwkQqaryQeU7labzTM0+tq8Ywsyt9k21IvLUVz99w040rtBk3c4ows51sQZ/DnZA1IzUMQkUzzVCH6lHvVypvPpdw+j158e7viQGM9oy38Nlt/Ck4z/c0k3ztL3bzC2QoXkp4Hg/G82o7N0PR5/Rw+AVOHDGNwgJepicOYRFh7SriWyggNL5WW++7irG+clwo3AosV1CVE4K5dCUrx5T7Sx7ICRmLzIc1oVrXQBiVzBTj9UITyJGJRMkNVbOxttD5xp7Fje1Ky2j6N/IAwQ+2Uw4PZ3x86B5d64WlrJ5gocxVJCc30rg4uBMRCtzqbt0vNb27JPaMYltYs3uHKIcxjYAe8xhh/KiZ5Nj7JJN7GAn5dobA8iUAsars47j80zCMk3g0g1AAtgF2lY49U84w5nlWIoGAmCIuT+Sb1iVLQEekIyT12TO2EWRMA7ysO2H415mkPh0HHudg87MzfQs9x8TaRJf/yS+2rBg4bhJ8k+lPKjSWe7ea6Hxyo76/7XfwQ7ypxZrx3LQ61+Q6eoLLFt8zQdJHbm02JBGSMxBoyctT4XkdPrm7Qjov8Z9rI6CWR4sJMh39uu/LEgc5fkR2en+8V1futXJGPiZW5KFLk4B3z5oswXZhiN4XSk4W9HV/PFKyVNyWaNzVVlOOYVCIHZRUuQDAUKjK1m2V0Sx+I4cU/AUxg4cgl/zleCLVjY93VkWZbeOw3XEP63Qss2i/RQeUqiItjw11lL6V4Is=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello community,


This newsletter covers DAMON features that landed on the mainline, queued for
the mainline, development statistics and misc events that were interesting to
me that happened in v7.1-rc1..v7.2-rc1 time period (2026-04-26..2026-06-28).

The newsletter covering the previous release cycle (v7.0-rc1..v7.1-rc1) is
also available [1].

TLDR
====

The last development cycle for DAMON was the busiest cycle of its mainline
history (~6 years, since 2021 September).  12 Authors landed 106 DAMON patches
for a number of changes including 7 new features on the mainline.  A roadmap
for extending DAMON to utilize AMD IBS, Intel PEBS like h/w features and do
per-CPUs/threads/reads/writes monitoring is made.

Changes Landed on 7.1
=====================

All changs that were landed on v7.1-rc1 have successfully landed on v7.1.  The
changes include selective DAMOS auto-tuning algorithms (commit 8719c59c4b928).
Read the newsletter for 7.1-rc1 [1] for more details of the changes.

Chanegs Landed for 7.2
======================

During the 7.2-rc1 merge window, 95 DAMON patches have landed via the MM pull
requests [2,3].  Introducing a few of changes that could introduce non-trivial
user impacts.

New Features
------------

In the merge window, below user-visible new features are added.

1. Commit 9138e27a3bc38: "mm/damon: add node_eligible_mem_bp goal metric"
2. Commit c7ec7d5f6b3d1 "mm/damon: introduce DAMOS failed region quota charge
   ratio"
3. Commit 3b9e3cc0405b4 "mm/damon: let DAMON be paused and resumed"
4. Commit 70d8797c15d64 "mm/damon/reclaim,lru_sort: monitor all system rams by
   default"
5. Commit 0453f857eb32c "mm/damon/reclaim: support monitoring intervals
   auto-tuning"
6. Commit 3a0bc9568c354 "mm/damon/stat: add kdamond_pid parameter".
7. Commit 45c49d9fd6089 "mm/damon: introduce data attributes monitoring".

Feature 1 is developed by Ravi at Micron, for their auto-tuned dynamic
DRAM/CXL memory interleaving for memory bandwidth optimization.

Features 2 and 3 make DAMOS be more deterministically controllable.

Features 4-6 improves DAMON modules for easier control and more reliable
operations.

Feature 7 introduces the data attributes monitoring, which enables light-weight
page level (e.g., cgroup-aware) access monitoring.  It will also be the
foundation of the ongoing collaboration project.

Deprecation
-----------

In the merge window, below change for deprecating one user-visible feature is
also merged.  It deprecates a directory in DAMON sysfs interface. Users can
replace it with its alternatives, 'core_filters/' and 'ops_filters/'
directories.  We will continue supporting the deprecated feature for a while,
but will eventually remove it.  Please update your usages, or request holding
the removal if it is really needed for you.

- Commit 7e6cc9f954aa3: "mm/damon/sysfs: document filters/ directory as
  deprecated"

Changes Cooking for >7.3
========================

A number of patches are queued and being developed for 7.3-rc1.  My personal
tree for those (damon/next) contains 231 downstream patches as of this writing.
Not all the patches are aiming to be merged into 7.3-rc1.  However, apparently
the next cycle will also not be a very idle cycle.

Statistics
==========

Putting simple statistics for the last release period.  Tools other than git
that are used here for getting the numbers are available [4,5] at GitHub.

In short, this cycle was the busiest cycle of DAMON development history.

Number of DAMON Commits
-----------------------

Eleven DAMON hotfixes have landed on 7.1.

    $ git log v7.1-rc1..v7.1 --oneline --no-merges -- \
            mm/damon include/linux/damon.h \
            Documentation/mm/damon/ Documentation/admin-guide/mm/damon/ \
	    Documentation/ABI/testing/sysfs-kernel-mm-damon \
            include/trace/events/damon.h samples/damon/
            tools/testing/selftests/damon | wc -l
    11

Ninty two DAMON changes have landed on 7.2-rc1 during the merge window.

    $ git log v7.1..v7.2-rc1 --oneline --no-merges -- \
            mm/damon include/linux/damon.h \
            Documentation/mm/damon/ Documentation/admin-guide/mm/damon/ \
	    Documentation/ABI/testing/sysfs-kernel-mm-damon \
            include/trace/events/damon.h samples/damon/ \
            tools/testing/selftests/damon | wc -l
    95

The numbers for the last seven release cycles are like below:

    7.1   fixes:  11  7.2   changes:  95
    7.0   fixes:  9   7.1   changes:  64
    6.19  fixes:  7   7.0   changes:  68
    6.18  fixes:  7   6.19  changes:  78
    6.17  fixes:  15  6.18  changes:  41
    6.16  fixes:  8   6.17  changes:  93
    6.15  fixes:  0   6.16  changes:  22

The 6.17 development cycle was the busiest DAMON development cycle in history
(~6 years since 5.15).  This cycle broke the record.

Contributors
------------

In this cycle, 12 people made 106 grateful DAMON commits on the Linux mainline.

    $ ./lazybox/version_control/authors.py ./linux --skip_merge_commits \
            --linux_subsystems DAMON --since v7.1-rc1 --until v7.2-rc1
    1. SeongJae Park <sj@kernel.org>: 91 commits
    2. Liew Rui Yan <aethernet65535@gmail.com>: 4 commits
    3. Maksym Shcherba <maksym.shcherba@lnu.edu.ua>: 2 commits
    4. Zenghui Yu <zenghui.yu@linux.dev>: 1 commits
    5. Sakurai Shun <ssh1326@icloud.com>: 1 commits
    6. niecheng <niecheng1@uniontech.com>: 1 commits
    7. Kefeng Wang <wangkefeng.wang@huawei.com>: 1 commits
    8. Vineet Agarwal <agarwal.vineet2006@gmail.com>: 1 commits
    9. Jiayuan Chen <jiayuan.chen@shopee.com>: 1 commits
    10. Asier Gutierrez <gutierrez.asier@huawei-partners.com>: 1 commits
    11. Cheng-Han Wu <hank20010209@gmail.com>: 1 commits
    12. Ravi Jonnalagadda <ravis.opensrc@gmail.com>: 1 commits
    # 12 authors, 106 commits in total

The last lines for the last eight release cycles are like below:

    7.2-rc1:   #  12  authors,  106  commits  in  total
    7.1-rc1:   #  8   authors,  73   commits  in  total
    7.0-rc1:   #  12  authors,  75   commits  in  total
    6.19-rc1:  #  10  authors,  85   commits  in  total
    6.18-rc1:  #  11  authors,  56   commits  in  total
    6.17-rc1:  #  7   authors,  101  commits  in  total
    6.16-rc1:  #  5   authors,  22   commits  in  total
    6.15-rc1:  #  7   authors,  68   commits  in  total

DAMON user-space tool (damo) also got a significant amount of changes.

    $ ./lazybox/version_control/authors.py ./damo --skip_merge_commits \
            --since 2026-04-26 --until 2026-06-28
    1. SeongJae Park <sj@kernel.org>: 146 commits
    2. Sean Jackson <sjackson@crusoe.ai>: 2 commits
    3. Kunwu Chan <kunwu.chan@gmail.com>: 2 commits
    4. Zeyu Wang <wangzeyu2024@lzu.edu.cn>: 1 commits
    # 4 authors, 151 commits in total

The last line was "1 authors, 123 commits in total" for the last cycle [1].
Both the number of contributors and the number of commits have significantly
increased.

Mailing List Traffic
--------------------

DAMON mailing list was quite busy.

    $ hkml list damon --since v7.1-rc1 --until v7.2-rc1 \
            --collapse --stat_only --stdout
    # stat for total mails
    # 1480 mails, 163 threads, 141 new threads
    # 670 patches, 125 series
    [...]

The traffic for the last cycle period was like below.

    $ hkml list damon --since v7.0-rc1 --until v7.1-rc1 \
            --collapse --stat_only --stdout
    # stat for total mails
    # 1098 mails, 152 threads, 147 new threads
    # 450 patches, 129 series
    [...]

The traffic has also sigificantly increased.  Since the traffic is not only for
the 7.2-rc1 but also for 7.3-rc1, 7.3-rc1 might have even more DAMON changes.

Events
======

Ravi from Micron landed DAMOS_QUOTA_ELIGIBLE_MEM_BP patch [6] for auto-tuned
DRAM/CXL memory dynamic interleaving has finally reached the mainline.

A few DAMON topics were discussed in LSFMMBPF'26.  The topics included
- update of DAMON developments for CXL and memory tiering and plan for general
  NUMA management,
- a plan for extending DAMON to Data Attributes Monitoring and Operations
  eNgine that will cover per-cgroup light-weight access monitoring,
- a way for extending DAMON to enable per-CPUs/threads/reads/writes monitoring,
- ways to use DAMON for huge pages, and
- DAMON Enabled Compute Systems (DAMON-X).
Refer to LWN's great article [7] summarizing the discussions.

Akinobu continued [8] perf event based DAMON extension.  Ravi implemented [9]
h/w sampled access reports  that can utilize AMB IBS and Intel PEBS on it.  We
made a roadmap [10] for making it all upstreamed by LSFMMBPF'27.

Bijan from UW-Madison published a paper [11] for the dynamic memory
interleaving for tiered memory system at ISMM'26.  Apparently the work was a
collaboration between UW-Madison and Micron.

Asier from Huawei continued [12] work on DAMOS auto-tuning goal for THP.
Wang Lian shared [13] an RFC patch series and plans for adding mTHP collapse/split
management and ARM SPE feedback utilization to DAMON.

DAMON project blog got its first and grateful post contribution [14] from Kunwu
Chan, for its TLB policy.

The Chinese Kernel Community organized a meetup [15], with a session for DAMON.

Liew Rui Yan shared [16] their user-space program for auto-tuning of
DAMON-based reclamation, dama.

New Letter Subscription
=======================

This newsletter series is posted to DAMON mailing list [17] and archived on the
project blog [18], for each release.  If you want a reliable delivery of this
newsletter series to your inbox, subscribing to the mailing list [18] could be
an option.  If the mailing list traffic is too much, feel free to ask me (send
mail to sj@kernel.org) to [b]cc you for each newsletter posting.

References
==========

[1] 7.1-rc1 news: https://lore.kernel.org/20260428150817.125575-1-sj@kernel.org
[2] First MM PR for 7.2-rc1:
    https://lore.kernel.org/20260618093027.803700be945480575260b0f3@linux-foundation.org/
[3] Second MM PR for 7.2-rc1:
    https://lore.kernel.org/20260623085840.0819c7694831ca2055e6a733@linux-foundation.org/
[4] authors.py: https://github.com/sjp38/lazybox/blob/master/version_control/authors.py
[5] hkml: https://github.com/hackermail
[6] DAMOS_QUOTA_ELIGIBLE_MEM_BP patch:
    https://lore.kernel.org/20260428030520.701-1-ravis.opensrc@gmail.com
[7] LWN artile for LSFMMBPF'26 DAMON session: https://lwn.net/Articles/1071256/
[8] perf event extension:
    https://lore.kernel.org/20260423004211.7037-1-akinobu.mita@gmail.com
[9] H/W sampled access repors:
    https://lore.kernel.org/20260529165640.820-1-ravis.opensrc@gmail.com
[10] DAMON extension roadmap:
     https://lore.kernel.org/all/20260525225208.1179-1-sj@kernel.org/
[11] Dynamic interleaving paper: https://dl.acm.org/doi/10.1145/3814942.3816137
[12] DAMOS_HUGEPAGE_MEM_BP:
     https://lore.kernel.org/20260616150316.580819-1-gutierrez.asier@huawei-partners.com
[13] mTHP and ARM SPE:
     https://lore.kernel.org/20260618094838.32805-1-lianux.mm@gmail.com
[14] DAMON tlb flush poste: https://damonitor.github.io/posts/tlb_flush_policy/
[15] Chinese kernel meetup:
     https://www.linkedin.com/posts/wang-lian-03b180271_linuxkernel-opensource-kerneldevelopment-share-7475789130229223425-CCk9/?utm_source=share&utm_medium=member_desktop&rcm=ACoAAAuQ2s0BFPM2rGjEAKbwpwDB53YY6CCA9lY
[16] dama: https://lore.kernel.org/20260628085155.20828-1-aethernet65535@gmail.com
[17] DAMON mailing list: https://lore.kernel.org/damon
[18] News letter on project blog: https://damonitor.github.io/tags/release_news/
[18] Mailing list subscription guide:
     https://subspace.kernel.org/subscribing.html


Thanks,
SJ

