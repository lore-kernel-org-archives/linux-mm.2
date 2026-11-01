Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79EC4606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 23:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MhszX4fT
Received: by kanga.kvack.org (Postfix)
	id 7F1B76B05B4; Sun,  1 Nov 2026 18:55:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A2AC6B05B5; Sun,  1 Nov 2026 18:55:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF516B05B6; Sun,  1 Nov 2026 18:55:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BC0B6B05B4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:55:12 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABBAAC0B42
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 23:55:11 +0000 (UTC)
X-FDA: 85388208822.28.900B450
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3246F40005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 23:55:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MhszX4fT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793577310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=M21Hb6PCgFsdoSAxGF2w8IZsbHlQ7hBdjiLDWWQ75pU=;
	b=WJCIBK6ta78UyxXWwvfM7PTxAj7BrelGH3YMvOCFGTWohx5XMvntsC4J74SK19b4c13yo1
	8GXMucgEEjKjk6ePYZscUuXv+glBT2XxTWmcGIS0aRGOletubJJOx3yDSxFw/ago7K5cvD
	dkgN9Dmotr4K0PXx6PktrRQOQ2cehco=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MhszX4fT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793577310;
	b=dz5BLf3Owep4ca98q3+kq9kdmGU5CkI7ZX541RKcKul+zr24EpadGg4QgKHqiyjNcTijQd
	biGr3ub+aafLnsRXj+679SPgT6q7ZuyTvaj0vh4CLLAYNFVjTvdUBAEOJ5IVadBhpispof
	1f976G1hhj3qEMYd/heoZjckIX3bsVM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0AE5A601FF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 23:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479411F000C1;
	Sun,  1 Nov 2026 23:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793577308;
	bh=M21Hb6PCgFsdoSAxGF2w8IZsbHlQ7hBdjiLDWWQ75pU=;
	h=From:To:Cc:Subject:Date;
	b=MhszX4fT8mOWiqnOIiHXw3vxRARA+OUEj9W7JEv49XVBmmDUoX69hhC9uuRyQO+pw
	 9ruJtG9HhQUOcvvpToBHemZAaGDZ52Cc2IFsSthfBxHy4X2WBD8N9X3F4bA3dzmbtj
	 2DECCEdieQo9WYpPHnuAuJHWJanifmP6WBwYSXIm1JbgRfj8H7L/nDKqqiBJMUyMIQ
	 YJiaPd4AP641196mpW+Uq5uegRs0RLiSalVcj7l8PV9RwUxjVzhggvtlEGVYyajDUn
	 4rkTnrbKz2DbtvSOIcx2UkNAJt689cWGGEnZVJb66wOP3YCOmRNBk8leUCApNc9emR
	 3KyN1Sp0Nyv6w==
From: SJ Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Release Newsletter for v7.4-rc1
Date: Sun,  1 Nov 2026 15:55:00 -0800
Message-ID: <20261101235500.102023-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3246F40005
X-Stat-Signature: br4m3zs54gkjtxkt19qn5nof718hs4kd
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793577310-725561
X-HE-Meta: U2FsdGVkX1/L4fDs5Kd4KEHWhA1JysMjN9WB1BpTs2V96bUpBPUJ4ZEfCscokTf/8LjK+Sb36ULAPigIE8FtBcNC15tOlae9epETA7X2/4O1e0iWU6CvyB6n8jOfw6StsClPOcwHtQ9yquso9d9FVEgEPxbZGpx591GkLl7EjMfHtaLf9aWYzu46K226WR5M3qQNMyqSK6SodF+3PMEDWmZ5Aaza0bGbUzgigd8oBuFKFqfULuQmXuP1AqfU5V7SsTh2dD4rCJeTr8DnT+aMJvrxSIxjWVmvX/1GeoeX9oPrMXgeQ6nv1E2x4Ak1JUTlWNz3TLtf5V9HjzYsELREQvvNooH1juYmV6LeUVusaatncumJNVKxeiBSkfN8y0M8z7yGreMEAdRf20rERPoKkQM+rGVEnCC6yvjcB0syfb/Ce7PRcWkELDGnabJXdt6UHHQgaUKmTdrP2KIw3EvdhqkSaS78NZAb9ikO7bQ7t2BhNuGehcGm6U1HAMk8P899RoDmYu6CIrB1Do2EtQUdtbR0pB1kj+LM230MvU8+IHL+Qwn/dwUfs2POMGteyR6esuZCqJTJJyGZP8LBLgboFXzJv3TmvPHABXI30rsTsebeOkmLRXcpiQ+sBDMPvd0O4ZkeQI01HWoiozsPeG7pwX831fc++eG+oN00gs3NXgHO10Wi+9tqK59bQfEGo4loQzDEia8/bD/+8zPVy6NLosP0sWdqYYiFXaUFA+3lLI9Ut1PyTorjBmxTI0QBA33pS8VC14EwxQ3ncxA5Pq/uYCsG4/c1RnP8z2VgrL33CKPCMURXwrvOybz5/km8aTgidfPULM7RgyU55e1aDQw5zaflmao7gJwfyZrz8qiCWQLZosKFHz5+ewc/L/atTyFf45PhRFRQAiIOHQhQpUmTrH4ci+J3Ez9Gr6hQcnBseSsOWZjz3LK2w6ZvV8TOFfoCFT4Da5pktlTGBzr8HsC
 kRupVVyD
 5ma7ND5lL6OcNI6AK7aD0I+L844AIj/9ro0J8ZmH78DnoVgYGP0t5AuSH2J8qEVX/dcWJ0QyEwHTZkj+ZqizlxkYTS/0Q0RSxcF/B+O6sQyMb8Wqm41P4DP24dW+PsNGuizqf4une94hij3VOd/8WjiSho8S10TkGr+pjx4fQoHyPH2R0SGy9MtRS6gZRGUF35qW1D99XIPcVsQWSoUuhKh1kV485GhlqxDXzYXtceJ6afRH62CqjBaJGaY0m9mn/yg85Ms7I7lRX6YNwS1iUNoTtPmf/XOrrySmQsU6Ir4jXOj/UBDVch3EuIaH/VeLYr+u9hYzUINfRa6mpmzwJ1TdTMnprqVK1Hg9PWc3N/4lr/Cxo9/b74GXRHJ/wcaJMY+sqtBllxHfS6OB/unfnYCOW5jnpnzjPe6Gc7cfeoEe+VzHsrDNbsMdRCF7ieBu9wKjw2kSzo0Y/mCcIx9usTtRlAdb7qzCO2zlNvv3fAdVFvUjVSmXe2GwOKQ8CMH4qkzjOkExRIfmQ2PX0h8Ect9AAnBRAoysKJmyD7dFDNEzRdlqL8V4w19HnFk50A9WgxtIMPwbLmNbBEMOqHoDxAN9zGsl+G9OCoNguAlpOqgQsvDu+FNI3CcuUGFEMSVhTV4rOZktY9C9NtEPbtwYMVtEGhu+xfCiLWO40AdX5Lmo1ETod427dJLWoOr7S1DhQZg26xo7WkPCMPYOTDtXMrYdG6CAj4QnxOUHbdWN9bjMu64vTnKWtFDrICRs2yNtMSAU65JzqUu6vC8OnfkvHOVJKv9bmO/ztJREPcoVwwkmx19nqAqyPv+g5Yds90S9MIFlyK67CYQI+KzX+awlZw0JgAK4DfQlIzelxhy0+txr/hnuN161VcGm2n6QmWR6cVVIc8TQuAn2TAo8WcwNNM7ssQ0HnWRKcJ64hen60dXrcBQBEJlC9YtFE7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello community,


This newsletter covers DAMON features that landed on or queued for the
mainline, development statistics and misc events that were noteworthy in my
opinion, that were happened from v7.3-rc1 (2026-08-30) to v7.4-rc1 (2026-11-01)
time period.

The newsletter covering the previous release cycle (v7.2-rc1..v7.3-rc1) is
also available [1].

TL;DR
=====

23 authors made 159 commits with 3,260 lines of changes for DAMON on the Linux
mainline.  7 new features are landed with important optimizations and fixes.
It was another busiest cycle in DAMON history, in terms of the number of
authors, the number of merge window commits and mail traffic.  Nonetheless, the
speed of the growth of the number in recent cycles started reducing.

Changes Landed on 7.3
=====================

All 146 commits that were landed on v7.3-rc1 have successfully landed on v7.3.
In addition to those, 7 additional hotfixes have merged into 7.3.

Those from 7.3-rc1 include a few user-visible and impactful features and
optimizations.  To pick only two among those, data attributes-only monitoring
feature (commit 37aae41c1056) and pseudo moving probe_hits sum optimization
(commit aa497a270f68) are introduced.  Those make DAMON extending to work from
only data access to general data attributes more complete.  Read the previous
newsletter [1] for more details.


Changes Landed for 7.4
======================

During the 7.3-rc1 merge window, 152 DAMON patches have landed via the MM pull
requests [2,3].  Introducing a few of changes that could introduce non-trivial
impacts.

New Features
------------

In this merge window, below seven new features are added.

1. Commit f465dc71aba0: Patch series "mm/damon: Introduce a huge page
   collapsing mechanism using auto tuning", v4.
2. Commit f138b7b98ec5: Patch series "mm/damon: introduce data access-as-a-data
   attribute", v1.1.
3. Commit df8060e66580: Patch series "mm/damon/vaddr: support
   {prep,apply}_probes".
4. Commit f8facff65cb3: Patch series "mm/damon: introduce pgidle_set probe
   filter type".
5. Commit 724468135d75: Patch series "mm/damon: introduce probe_hits_wsum DAMOS
   core filter", v2.
6. Commit 222636c8c139: Patch series "mm/damon: introduce hugepage_size probe
   filter".
7. Commit de6632aa7851: Patch series "mm/damon: introduce damos quota goal
   target metric complement flag".

The first feature is contributed by Asier Gutierrez from Huawei.  It allows
DAMOS automatically collapsing huge pages to make no more, no less but a
specific portion of system memory be backed by huge pages, to get huge page
benefit while controlling the amount of internal fragmentation.

The next five features are all for data attributes extension.  Second feature
makes data access monitoring can be replaced by data attributes monitoring.
Third feature adds virtual address support for the attributes monitoring.
Fourth feature makes attributes monitoring more useful for cold and actionable
memory detection.  Fifth feature allows data attributes based DAMOS.  Sixth
feature extends attributes monitoring for another attribute, hugepage-ness.

The seventh feature makes DAMOS quota goal to be easily customizable for more
flexible use cases.

Optimizations
-------------

Below important optimization is added in this merge window.

1. Commit 3453f37fed8e: Patch series "mm/damon: support access monitoring of
   hugetlb-backed memory", v3.

DAMON was not supporting monitoring of accesses on hugetlb-backed memory.
Krishna Iyer from Crusoe found this is making their access pattern monitoring
on their setup difficult.  Krishna further developed and contributed this huge
optimization that allows DAMON monitoring hugetlb memory.

Refactoring and Bug Fixes
-------------------------

Quite a number of changes in the 7.4-rc1 merge window were for fixing DAMON
bugs and refactoring code to be more tolerant to future bugs.  Because the
changes are quite spread around, not listing most of the commits here.

While most fixed bugs were minor ones, below fix was for a nasty and impactful
bug that is noteworthy.

1. Commit f166586f74dd: "mm/damon/ops-common: use a page-aligned address in
   damon_ptep_mkold()"

The bug causes difficult-to-debug memory corruption on arm64.  It was found and
fixed by Nathan Gao from AWS.  Nathan found it from their Amazon Linux 2027
preview works.

Changes Cooking for >7.4
========================

A number of patches are queued and being developed for future mainline landing.
Three hotfixes are queued in mm.git.  My personal tree for those (damon/next)
contains 142 downstream patches as of this writing.  Not all the patches are
ready to, or intended to be merged in near future.  Some will be squashed or
broken down.  Anyway, the number was 214 for the last release cycle.  This
cycle is likely to be less busier than the last cycle.

Statistics
==========

Putting simple statistics for the last release period.  Tools other than git
that are used here for getting the numbers are available [4,5] at GitHub.

In short, while the amount of hotfixes in the non-merge window decreased, the
number of changes for the merge window broke the record.  In terms of total
number of commits, though, the continued trend of the increase has stopped.

Number of Hotfixes and Non-hotfixes
-----------------------------------

7 DAMON hotfixes have landed on 7.3.

    git -C ./ log v7.3-rc1..v7.3 --oneline --no-merges -- \
            Documentation/ABI/testing/sysfs-kernel-mm-damon \
            Documentation/admin-guide/mm/damon/ Documentation/mm/damon/ \
            Documentation/vm/damon/ include/linux/damon.h \
            include/trace/events/damon.h mm/damon/ samples/damon/ \
            tools/testing/selftests/damon  | wc -l
    7

152 DAMON changes have landed on 7.4-rc1 during the merge
window.

    git -C ./ log v7.3..v7.4-rc1 --oneline --no-merges -- \
            Documentation/ABI/testing/sysfs-kernel-mm-damon \
            Documentation/admin-guide/mm/damon/ Documentation/mm/damon/ \
            Documentation/vm/damon/ include/linux/damon.h \
            include/trace/events/damon.h mm/damon/ samples/damon/ \
            tools/testing/selftests/damon  | wc -l
    152


The numbers for the last ten release cycles are like below:

    7.3   fixes:  7   7.4   changes:0  total:159
    7.2   fixes:  15  7.3   changes:0  total:161
    7.1   fixes:  11  7.2   changes:0  total:106
    7.0   fixes:  9   7.1   changes:0  total:73
    6.19  fixes:  7   7.0   changes:0  total:75
    6.18  fixes:  7   6.19  changes:0  total:85
    6.17  fixes:  15  6.18  changes:0  total:56
    6.16  fixes:  8   6.17  changes:0  total:101
    6.15  fixes:  0   6.16  changes:0  total:22
    6.14  fixes:  6   6.15  changes:0  total:68

Since 7.1 development cycle, DAMON development was only getting busier for
every cycle in terms of the total number of commits.  7.4 development cycle
stopped the trend.  It was mainly due to the decreased number of hotfixes that
merged after the merge window.  In terms of the merge window only changes, it
broke the record again.  But, obviously the speed of the growth of the number
is reduced.

Authors, Commits and Changed Lines
----------------------------------

In this cycle, 23 people made grateful 159 commits with 3260 lines of changes
for DAMON on the Linux mainline.

    $ # stat for number of commits
    $ ./lazybox/version_control/authors.py ./linux/ \
            --since v7.3-rc1 --until v7.4-rc1 \
            --skip_merge_commits --linux_subsystems DAMON
    1. SJ Park <sj@kernel.org>: 111 commits
    2. Liew Rui Yan <aethernet65535@gmail.com>: 9 commits
    3. Zenghui Yu (Huawei) <zenghui.yu@linux.dev>: 5 commits
    4. Karl Mehltretter <kmehltretter@gmail.com>: 4 commits
    5. Donggeun Yoo <donggeunyoo.kernel@gmail.com>: 4 commits
    6. Krishna Iyer <kiyer@crusoe.ai>: 3 commits
    7. Asier Gutierrez <gutierrez.asier@huawei-partners.com>: 3 commits
    8. Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>: 2 commits
    9. Enze Li <lienze@kylinos.cn>: 2 commits
    10. Cheng-Han Wu <hank20010209@gmail.com>: 2 commits
    11. Jason Angelov <jasonangelov@ucla.edu>: 2 commits
    12. Gregory Price <gourry@gourry.net>: 1 commits
    13. Arnd Bergmann <arnd@arndb.de>: 1 commits
    14. Karthikeyan KS <karthiproffesional@gmail.com>: 1 commits
    15. Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>: 1 commits
    16. Xuewen Wang <wangxuewen@kylinos.cn>: 1 commits
    17. Kunwu Chan <kunwu.chan@gmail.com>: 1 commits
    18. Eva Kurchatova <eva.kurchatova@virtuozzo.com>: 1 commits
    19. zhaozhengzhuo <zhaozhengzhuo@uniontech.com>: 1 commits
    20. Hari Mishal <harimishal1@gmail.com>: 1 commits
    21. Li Youhong <liyouhong@kylinos.cn>: 1 commits
    22. Nathan Gao <zcgao@amazon.com>: 1 commits
    23. Kees Cook <kees+treewide@kernel.org>: 1 commits
    # 23 authors, 159 commits in total

    $ # stat for number of lines
    $ ./lazybox/version_control/authors.py ./worktree.linux/ \
            --since v7.3-rc1 --until v7.4-rc1 --skip_merge_commits \
            --linux_subsystems DAMON --sortby lines
    1. SJ Park <sj@kernel.org>: 2056 lines
    2. Donggeun Yoo <donggeunyoo.kernel@gmail.com>: 367 lines
    3. Karl Mehltretter <kmehltretter@gmail.com>: 186 lines
    4. Krishna Iyer <kiyer@crusoe.ai>: 171 lines
    5. Liew Rui Yan <aethernet65535@gmail.com>: 98 lines
    6. Jason Angelov <jasonangelov@ucla.edu>: 64 lines
    7. Zenghui Yu (Huawei) <zenghui.yu@linux.dev>: 50 lines
    8. zhaozhengzhuo <zhaozhengzhuo@uniontech.com>: 38 lines
    9. Enze Li <lienze@kylinos.cn>: 34 lines
    10. Li Youhong <liyouhong@kylinos.cn>: 30 lines
    11. Asier Gutierrez <gutierrez.asier@huawei-partners.com>: 27 lines
    12. Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>: 26 lines
    13. Eva Kurchatova <eva.kurchatova@virtuozzo.com>: 21 lines
    14. Cheng-Han Wu <hank20010209@gmail.com>: 21 lines
    15. Kunwu Chan <kunwu.chan@gmail.com>: 19 lines
    16. Gregory Price <gourry@gourry.net>: 16 lines
    17. Arnd Bergmann <arnd@arndb.de>: 9 lines
    18. Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>: 8 lines
    19. Nathan Gao <zcgao@amazon.com>: 7 lines
    20. Hari Mishal <harimishal1@gmail.com>: 4 lines
    21. Karthikeyan KS <karthiproffesional@gmail.com>: 3 lines
    22. Xuewen Wang <wangxuewen@kylinos.cn>: 3 lines
    23. Kees Cook <kees+treewide@kernel.org>: 2 lines
    # 23 authors, 3260 lines in total

Snapshots of the number of authors, commits and changed lines for the last ten
cycles are below.  The snapshots for the entire DAMON history is also available
[6] at the DAMON project blog.

    <version>  <nr_authors>  <nr_commits>  <nr_lines>
    v7.3-rc1   23            159           3260
    v7.3-rc1   21            162           2283
    v7.2-rc1   14            109           3311
    v7.1-rc1   9             77            1070
    v7.0-rc1   12            75            1279
    v6.19-rc1  10            85            1640
    v6.18-rc1  13            59            864
    v6.17-rc1  8             104           3785
    v6.16-rc1  5             22            564
    v6.15-rc1  7             68            1479

In terms of number of contributors, this was the busiest cycle in DAMON's
development history.  The speed of the growth of the number has obviously
reduced, though.

DAMON user-space tool (damo) also got an amount of changes.

    ../lazybox/version_control/authors.py ../damo \
    	--since 2026-08-30T13:34:40-07:00 --until 2026-11-01T13:26:31-08:00 \
            --skip_merge_commits
    1. SJ Park <sj@kernel.org>: 105 commits
    # 1 authors, 105 commits in total

The last line for the last cycle [1] was "5 authors, 261 commits in total".  So
interestingly the amount of changes for the DAMON user-space tool was reduced
compared to the last cycle.

Mailing List Traffic
--------------------

The DAMON mailing list was quite busy.

    hkml list damon --since v7.3-rc1 --until v7.4-rc1 --collapse \
            --stat_only --stdout --ignore_cache
    # stat for total mails
    # 2132 mails, 255 threads, 245 new threads
    # 749 patches, 180 series
    [...]

The traffic for the last ten cycles were like below.  The numbers for the
entire DAMON development history is also available [6] at DAMON project blog.

    <version>  <nr_mails>  <nr_threads>  <nr_new_threads>  <nr_patches>  <nr_series>
    v7.4-rc1   2132        255           245               749           180
    v7.3-rc1   2019        183           180               871           148
    v7.2-rc1   1486        164           142               671           126
    v7.1-rc1   1098        152           147               450           129
    v7.0-rc1   426         111           58                223           43
    v6.19-rc1  414         48            43                222           38
    v6.18-rc1  563         82            62                211           53
    v6.17-rc1  499         78            72                256           64
    v6.16-rc1  147         40            31                63            22
    v6.15-rc1  263         56            41                176           34
    v6.14-rc1  260         55            34                154           23

So the traffic is continuously increasing, in terms of the number of mails and
threads.  But the speed of the growth of the number is getting slower than the
last few cycles, in terms of the total number of mails.  Nonetheless, this was
yet another busiest cycle in DAMON's history.

Events
======

Krishna Iyer from Crusoe continued work [7] for hugetlb pages monitoring
support.  As a result, the support landed on the mainline for 7.4.

Nathan Gao from AWS found and fixed [8] a nasty memory corruption bug in DAMON,
as a part of their Amazon Linux 2027 preview work.

Beyond page table access-bit DAMON extension milestone 2 is [9] officially
started.

Ravi shared [10] new versions of RFC patches for AMB IBS/Intel PEBS based damon

Enze Li posted [11] a patch series for adding DAMON's rust support.  Because of
the lack of my Rust understanding and Rust sysfs support, we postponed the
patch series.  But the day for DAMON's Rust support is apparently not very far.

DeepSeek revealed [12] their DAMON usage.  They are saving 21.2% memory for
agent systems using DAMON as one of the components.

First DAMON (nano) Conference [13] is held at LPC in Prague.

RFC v0 [14] for beyond-page table a-bit milestone 2 design is posted.  The
design is rapidly being evolved with more changes [15], though.

Newsletter Subscription
=======================

This newsletter series is posted to DAMON mailing list [16] and archived on the
project blog [17], for each release.  If you want a reliable delivery of this
newsletter series to your inbox, subscribing to the mailing list [18] could be
an option.  If the mailing list traffic is too much, feel free to ask me (send
mail to sj@kernel.org) to [b]cc you for each newsletter posting.

References
==========

[1] 7.3-rc1 news: https://lore.kernel.org/20260830235014.64406-1-sj@kernel.org/
[2] First MM PR for 7.4-rc1:
    https://lore.kernel.org/all/20261019220030.056b79bf972b9d6a9c1aa931@linux-foundation.org/
[3] Second MM PR for 7.4-rc1:
    https://lore.kernel.org/20261026152120.c6ed2222b64943914563232f@linux-foundation.org/
[4] authors.py: https://github.com/sjp38/lazybox/blob/master/version_control/authors.py
[5] hkml: https://github.com/hackermail
[6] DAMON development stat history: https://damonitor.github.io/posts/dev_stat/
[7] DAMON hugetlb monitoring support:
    https://lore.kernel.org/20260908135156.97481-1-sj@kernel.org
[8] DAMON memory corruption fix:
    https://lore.kernel.org/20260904002829.116381-1-sj@kernel.org
[9] Beyong page table a-bit DAMON extension milestone 2 start:
    https://lore.kernel.org/20260905171537.84217-1-sj@kernel.org
[10] hardware-sample based DAMON prototype:
     https://lore.kernel.org/20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com
[11] DAMON Rust support:
     https://lore.kernel.org/20260927072812.2393456-1-lienze@kylinos.cn
[12] DeepSeek's DAMON use case:
     https://lore.kernel.org/20260925054408.10431-1-lance.yang@linux.dev
[13] DAMON (nano) Conference: https://lpc.events/event/20/contributions/2453/
[14] Beyond page table a-bit milestone 2 design:
     https://lore.kernel.org/20261017195747.89961-1-sj@kernel.org
[15] Beyond page table a-bit milestone 2 design update:
     https://lore.kernel.org/20261101183404.85322-1-sj@kernel.org/
[16] DAMON mailing list: https://lore.kernel.org/damon
[17] News letter on project blog:
     https://damonitor.github.io/tags/release_news/
[18] Mailing list subscription guide:
     https://subspace.kernel.org/subscribing.html


Thanks,
SJ

