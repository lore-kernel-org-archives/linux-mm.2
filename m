Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20753C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 07:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D638B6B0088; Wed, 16 Sep 2026 03:43:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13C96B008C; Wed, 16 Sep 2026 03:43:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03B26B0092; Wed, 16 Sep 2026 03:43:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D1AE6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:43:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 335921A05F1
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:43:21 +0000 (UTC)
X-FDA: 85218835002.16.6F2B164
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	by imf16.hostedemail.com (Postfix) with ESMTP id C8B7A180006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:43:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=Cc5+dmBY;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf16.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 54.254.200.128 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789544599;
	b=JFdGDdGRMt+v8DK51Q4xksbfnxRsps9dhDyOkb8IHX57A1I6dtEQH4s86KF4n3JsbsYpEg
	HBwXEjsDlwO+AOpXKrsFiBMnsvoBidR5zq7ofD7wVKiivMTTVLcTYFghcMunqEtjhpwfK+
	qLpM4SFipvzv0SHBbreFTRanLRctPx8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=Cc5+dmBY;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf16.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 54.254.200.128 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789544599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GC2uHY6TzEQ871y2a6vw3j4HAppRLJhpctXLjf5YSoc=;
	b=RFSUVoelyOSBAjkgscjLOVjkZAoNjKgOOqspa1P/7lXSiB+AgunPRyP8uqu72bFN/yeG7f
	B+ch+xVRt2+dvRRNdVzCYy2T8OeCEU5I60XAGLUUtyKe8nc5seazM/KTJI6DQpPSacZY9v
	peUWJ4DAh5gxuV/q8ezAavRjliEDnmI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1789544579;
	bh=GC2uHY6TzEQ871y2a6vw3j4HAppRLJhpctXLjf5YSoc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Cc5+dmBYc9vTx/+4oH1bPeoQpSgOGBElqBdyxMghHk5Cd1/B5yOdAOQL/Qt6rQsS/
	 sph8MK2oIqgSfJyIhEmuTkTd8P7qE//YpaApY8hk1vcC/bckdTSzqcFm15VMV4FSzB
	 YNEtmZ2oLdv6BmBFFW92pUNkZTCzbEWYiS7yJ+4U=
X-QQ-mid: esmtpsz20t1789544575tdce502f5
X-QQ-Originating-IP: MFlZU4grfHATUCmYhWGj7hiotv7USuKZFxkNblM3mXs=
Received: from zzz-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 16 Sep 2026 15:42:42 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9278055536101676971
From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
To: Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	SeongJae Park <sj@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Kairui Song <ryncsn@gmail.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH RFC v2 00/15] mm/mglru: frequency guided promotion (MGLRU-FG) and flag cleanup
Date: Wed, 16 Sep 2026 15:42:41 +0800
Message-ID: <EF8E0336FFC4841B+20260916074241.3373002-1-zhaozhengzhuo@uniontech.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: NAeO0+xU6W769OBubAh1qVtaxG3Zsynl5V5opSTVuZngx038riODAy4c
	jNAK2gwCQUCfzrNgNUTlh8m2x9LaYXc1ucKyH1Qf0eshl5VJ5BGuurx2xudHuJVEt7OlZwf
	Irnov5FoDZEn224OUQL1vkouLQAM9dVpZgKBXAHORBBsuCZJ/JXfOB6cnALyCMdoY8Xl7rQ
	SIDVN/yws+wBtbWaOz1QWr+4k9KPtnU2AAmwyTsyb8k5ItGm8L2Qb9tIc0p/l5HrJ6Pdrwh
	JldiHVPK+kOGUyBSXUoXdIxotIKs74fNgMLqcj7atvjDd3cqTFIK93XPG0+jll6f0lz1FCv
	82OwCZcf8OHXkT+czht60Dhbb2z/40NC8kn95g5JZIeXhbjrNDsxGw68isXh8B3Z12lOnen
	JuTkWQAi9MXObUIR/g7gdmJAcZ1+V7ApKWHbFA9GP2sK4EYSlMPqOEEWPfM4kCfQNBOVdyB
	oxRBeJ6EJGM/+RsY1XOw1W6MIsVQNIEqi/c8+GHa/xea0HeSCH27fiSyp92nmSkd6oqp412
	WDzgCEkpP5Iaj/NGn5k3LI1mi/0tzJsR3N/ZOCaB2I9UsP3SJ7Dpb5luYLNXZe1KRZRDzaR
	fJ15MwT73c8vgE35ZCNfl/9PJDopezNcBg+vcKSuiXuAoWWtnRJAVlmnVyq6slX+mobiFOL
	6GC7pZcoXDysIu8y94MGBdfjZ35Z5IZCuUg4ZdlqM1pMQYV1IARX8CDr8ZmLInOY8Bct99g
	kUBM3ash4VJLKprtNchSy34G8TrIfu9oajEOkUeOLHowZltYou2xcT6kkViWXZwXal0YQ19
	Qtb18ohIRXaNLiZYaTZkza0e1Djz+gE7EsAVdHWyNq5Cxoi4PjAnQzgpmai4oyaTOcpvlAG
	CguEOwtveVqy74D8sgJ0PasRhGoc33R99NisVNiIb17xz56wA3wXPAVESq9LyYgHhPllEIJ
	5OEVWyPxh/pQUmLnGZoIUgzCQAc33TL++N/IApraEXH2YHB70qLoW9AexaNSdEXp+rHWpys
	jPnKq1S9R+yKvwJXvJYv8lCbAH6LKaRN1dAXjs8IIPIYQ/qvwTbZn9fbM7w5Vxiky0YRGyt
	8aCTaEAkBmE
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C8B7A180006
X-Stat-Signature: qeni4f4ufqaue6y6dkas44q48njucgr5
X-HE-Tag: 1789544597-290389
X-HE-Meta: U2FsdGVkX1/+IFthu9QB8WGlsxcI0bjZZmyL05X+asnDpV02yEn08Qm0vQVrElxSN/w3J6+5IgMMKY3mW6enX7hdTvCPTPnMrj23cdA8fCFw5mPPGVgrYwnJ2g9nxDD94uJKNdXjPgNW1CxVj6A/0os+vCYhM1ViEdK9E7mEqvNFVS6tIT8ZjNsSjES5AYi6nGB7UFp7chwPklphvOr2C3vnIa9sboGzebZ2bCRoHBLx6w55adE6ymWlYUUE/k/sbt9fc58QjUTTexxVtxrWiq80JvdK22Hb+dquZp1QloxQIvdBIERJmPN8QnlmYBAG1vzBQDLR1JvtI7jr1RPJg2whE/uvz2RLc5NxSQAvKtjjb95UnzYopDgUoPgTM51IcF0Qnct7kAmopXqLBkDnIkmrLiG/DWo1dAcsZsVO4/3shTkW7dS/Ue01CPuwhaFJ5NSnoB3EtsZSfnkT6omjVFNDXVrg6p6mqO/wLhLnoi9+uHscFhlwaKW0U66A2koaKx0LNA1AfBIGobTVra7e935CYq70FHXbbPrnkutcPrvHfvuIZ6kD26D/wTLAfbS4KJnrAth2muuTr0OsjnZasFXbXlyVn5rcfZS1WlEeM+Teyiw2t29oJGzZVbUjuvosO/YnybxqeAV88npmFI1Wz1Sh6pMXghrDhRWtLCmFdw2pzfk6KXYvVtWPtikPAfz7qINMg7SagPpJjAPtQsN2eLzWlkAB+trtz+0tRZwcOjP1OgZgJVUJ34c/NqxZtmcEv7RrP5f2UJfbqC61GkF2D7tb5xU9G0Bt46iav6bkQ8TGpJAC7gDQPea/4NV1bbkg9UIbZhQ9BgTyfvGN8hz1gzIT639I1RUFCRMyz9oCdQoxMH2NqoZxn1slzKU0xw8JY4HvCWefaDJDFbwP/AFWjnwZc1VrpN1snvvpZ+Krae30FjPwawYvSMeeCk/iq+2zcf6xYQIAC67P2iJEYuY
 bEIpi+dt
 vLuVvvY9UdPveUTFb3Ec9wYGye2q5MdyQVf3m8pTaqdtVtAcGfGqhK4jO6OEbfdprje7BTX/MYhbdv6IEPcBeremlvp8HJB173f2DJ1yrk1clHq6p2/NPsEOlmiJFPbeyHLepRofFUUk42kF0BKrz0LS230RUjMut75wkrtK2Fvh71VBF/+eisrGofEXP75hQnig6z6aS83kyVG6o5r+for7kMQqSrklVqK7JpVqtsGTijAi6Wl3GoeZ70Ho3ZsBUrEJvM3k3UHLbA5xy7KxlOg+lci3GjtUTBnpeqc5XgVwki2qsgQjgx5WfYpgKfX1XHYflS6EKQigEqscaTNVxrBFIOL5OwiFIX/HCR+fsgOFkn1zvMnEf7xpjtwEiEFshBa1DgbX3P/7xDKtBSFa415dPTyZddprmrDQX5Ak874+iMFkYntLLno5PlJiyQ+TbgAWxAuGrqzrQmUlAkgzonH1CQIzVYGUghZLH1mQl4U1caFc1903lOSTybROOMJzryx4n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

Following up on my earlier v1 test report [1], I tested the complete v2
series on a small WSL2 box. Applied on the stated base-commit
9958290885035431e2494159f555e332c3c14906 (mm-new): all 15 patches
applied with git am, zero conflicts, and the resulting diffstat matches
the cover letter exactly (20 files, +812/-499).

Environment
===========
WSL2 VM on a 32G Windows host, 12 CPUs, deepin 23 userspace, swap on an
NVMe-backed virtual disk. VM memory was 15G/4G swap for the kernel
build, fio and sqlite-grep runs, and 20G/8G for the DB and browser
workloads. The distro WSL kernel ships without CONFIG_LRU_GEN, so both
kernels were built from the distro config plus CONFIG_LRU_GEN=y +
CONFIG_LRU_GEN_ENABLED=y; the two kernel configs differ only in
LOCALVERSION. MGLRU was toggled at runtime via
/sys/kernel/mm/lru_gen/enabled for the CLRU/MGLRU split, as in your own
harness. Workloads were scaled proportionally to this smaller box as
noted below.

In summary: no After-vs-Before regression anywhere in my matrix, clear
wins on fio miss rate, Chromium&Node and sqlite hot-path stability,
both MGLRU modes consistently ahead of CLRU, and classical LRU
untouched (MGLRU-off runs agree across the two kernels within <1% on
every metric). Both kernels survived ~8h of heavy memory pressure with
zero panics/BUGs/warnings. One caveat: your +13.4% MongoDB gain did not
reproduce at my scaled 12-thread setup (+0.7%), but no regression
either. Android was not tested (no real device here).

Build kernel test
=================
make -j12 in a 3G memcg, disk swap, kernel and build output on the same
disk (your -j48/NVMe setup scaled to 12 CPUs), single run per point.
Your 16-point swappiness sweep scaled down to {60, 100}; note that with
swappiness=0 the build gets OOM-killed inside the 3G memcg and never
completes on this box, so that point could not be measured:

swappiness 60:
        real     refault_file  refault_anon  pswpout
CLRU    1114.6s     4,645,990       825,316  3,401,489
Before  1101.1s     3,772,987       628,921  2,871,346
After   1091.9s     3,710,332       663,956  2,900,774

swappiness 100:
        real     refault_file  refault_anon  pswpout
CLRU    1124.6s     4,475,974       741,947  3,470,739
Before  1086.6s     3,764,594       757,247  3,002,297
After   1078.8s     3,715,202       651,335  3,108,020

MGLRU clearly beats CLRU (real -1.2~-4.1%, refault_file -16~-20%,
pswpout -10~-16%); After is at par or slightly better than Before
(-0.7~-0.8% real), matching the small deltas in your cover letter.
Repeatability checks: a rerun of Before/sw60 landed within 0.7%
(1093.0s), and CLRU agrees across the two kernels within 0.9% (sw60:
1114.6s vs 1104.9s), so the series does not disturb classical LRU.

MongoDB YCSB workloadb [2]
==========================
recordcount 20M, operationcount 6M (as yours), 16G memcg (as yours),
default WiredTiger cache, 12 threads (scaled from 48), disk swap. One
discarded warm-up run, then 5 measured runs, ops/s:

CLRU:         21242 20607 19591 19595 19360  (median 19,595)
MGLRU Before: 20943 20429 20085 20937 20842  (median 20,842)
MGLRU After:  20993 20404 20922 21031 21332  (median 20,993)

After >= Before (+0.7%) >> CLRU (+7.1%). Your +13.4% did not show up at
this shallower thread count, but there is no regression either.
Interesting side note: CLRU degraded monotonically across the 5
back-to-back runs (-9%) while both MGLRU configs stayed flat.

My own caveat: my first attempt capped WiredTiger's cache at 8G, which
pushed the workload into a swap-thrash regime where Before actually
won; with the default cache size that inversion disappears, so it was
my test artifact, not a patch issue.

Chromium & Node.js test [3]
===========================
Yu Zhao's original per-pair workload, scaled: 4 server+client pairs
(each server capped at 4G as in the original), 30 min per config
(yours: 1h), disk swap (yours: zram). Total requests:

CLRU:         72572
MGLRU Before: 76638
MGLRU After:  84303 (+10.0% vs Before, +16.2% vs CLRU)

After also had the best tail: 1 request >= 16s vs 8 for Before (CLRU
had none, but at the lowest throughput).

FIO cached with zipf
====================
Same recipe as yours, scaled down: 16 jobs x 1.5G files (24G total) in
an 8G cgroup, 4k sync buffered randread, ramp 45s + run 600s, two of
your zipf points, single run per config:

Avg IOPS (higher is better):
+--------+-----------+-----------+-----------+
| zipf   | CLRU      | Before    | After     |
+--------+-----------+-----------+-----------+
|  0.9   |   450,323 |   449,141 |   473,428 |
|  1.2   | 2,515,146 | 2,389,242 | 2,615,904 |
+--------+-----------+-----------+-----------+

Miss rate (refault/read, lower is better):
+--------+--------+--------+--------+
| zipf   | CLRU   | Before | After  |
+--------+--------+--------+--------+
|  0.9   | 0.1735 | 0.1758 | 0.1641 |
|  1.2   | 0.0211 | 0.0234 | 0.0195 |
+--------+--------+--------+--------+

Reproduces your observations: After lowers the miss rate -6.7% (z0.9)
and -16.7% (z1.2) vs Before (-5.4% / -7.6% vs CLRU) while IOPS also
rise (+5.4% / +9.5%); Before being slightly worse than CLRU on miss
rate also reproduced. Caveat: single run per config here.

LevelDB Scan/Get [4]
====================
The cache_ext paper's own artifact (its My-YCSB + LevelDB fork),
mixed_get_scan (95% get + 5% scan, scan_length 10000, zipf 0.99), 4
threads, 240s warm-up + 240s measured, 3 iterations per config with a
fresh DB copy per iteration. Scaled: 128M-entry ~28G DB (paper: 512M /
110G) in a 2.5G memcg, keeping the paper's ~11:1 DB:memcg ratio, swap
off as in the paper. ops/s per iteration:

CLRU:         13718 / 14179 / 13262  (median 13,718)
MGLRU Before: 18625 / 14433 / 14309  (median 14,433)
MGLRU After:  13152 / 14328 / 14420  (median 14,328)

After is at parity with Before (-0.7%, noise) and +4.5% vs CLRU -- same
direction as your +7.7%, and consistent with your own table where After
essentially matches mainline MGLRU on this test.

SQLite and grep [5]
===================
Your harness as-is (300M memcg, as in run.sh), 5 runs per config after
drop_caches. Hot lookup (1000 hot-index lookups):

CLRU:         122 ms median, bimodal 10.7~183 ms
MGLRU Before: 12.4 ms median, noisy 9.8~179 ms
MGLRU After:  10.5 ms median, stable 10.1~11.5 ms

Same ordering as your 10.58 < 14.51 << 567 story (CLRU degrades to a
bimodal distribution here rather than the collapsed mode). On the cold
scans, both MGLRU modes beat CLRU by ~17%.

One observation: in the harness's multi-tier test (large cold scans
coexisting with hot lookups), baseline MGLRU had an incidental win on
the hot part (~2.35s vs CLRU 3.15s) and After returns to ~3.1s --
consistent with your LevelDB discussion of dropping the refs==1
second-oldest-gen bump. Not a problem, just something I noticed.

Others
======
Not tested: Android (needs a real device; this box has no nested KVM).

Full raw logs available on request.

Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>

Thanks,
zhaozhengzhuo

[1] https://lore.kernel.org/linux-mm/92DCEFFD13221261+20260828102344.1537874-1-zhaozhengzhuo@uniontech.com/
[2] https://github.com/brianfrankcooper/YCSB/blob/master/workloads/workloadb
[3] https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@google.com/
[4] https://dl.acm.org/doi/10.1145/3731569.3764820 (artifact: https://github.com/cache-ext/cache_ext)
[5] https://github.com/ryncsn/emm-test-project/tree/master/sqlite-grep

