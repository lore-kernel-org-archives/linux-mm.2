Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B71606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EGUHcFnr
Received: by kanga.kvack.org (Postfix)
	id 912E16B09D5; Thu, 22 Oct 2026 18:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EB736B09D6; Thu, 22 Oct 2026 18:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802546B09D7; Thu, 22 Oct 2026 18:02:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5655F6B09D5
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:02:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1F5851602E8
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:02:16 +0000 (UTC)
X-FDA: 85351636272.21.40E9469
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5F61C100010
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:02:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EGUHcFnr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792706534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dR5/JZntk+U4h5/aN1mZNZOoNy870AQ8Dt4+e9dHiWk=;
	b=sUrn7I2uiAO+Uu3FPZ6uImI8BhFBLpMqpfIpnIYQ25GhOMYKQBrYxIA0GWxn38mF1pullh
	Jlx1F80JRmXljk4tsHlbZlNBtc0WStRDL4baa2/4qnUgLU3fStT+Y0r/FMrjH+xLHqF4dL
	Rzb48KL3jMCJYPTTjtIjfOFNBFUTxIA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EGUHcFnr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792706534;
	b=2oz4iu2nxwmUzBejZ86teNi0uyTGsUQI03Nq5OKP6HtSTwSvcF1bcx1wva9HvO6T6YkLIN
	zhhrMcFx2/xyPzTOvfNK0HBXIGmJn/CSrZSOwp1IjSrKcIqazQiFkvsaPBpnmwP62sHefA
	HNGyZXTxvfdpc2Zc5iix6trdRvNEaLA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C43DE40885;
	Thu, 22 Oct 2026 22:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5B51F01825;
	Thu, 22 Oct 2026 22:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792706532;
	bh=dR5/JZntk+U4h5/aN1mZNZOoNy870AQ8Dt4+e9dHiWk=;
	h=From:To:Cc:Subject:Date;
	b=EGUHcFnr7xc/2FhXy8vW9EKdFMBOrUFYAiSSVgRcVCJ8KCZVL7QvgGRU5AiYbBJ8w
	 vu9+nE7DIar8Rz00xAuNwdxA2y16Yk9NEdUT937aN90RGWM5HHyVlR/k+Z+/eT6sG9
	 La4ZRwRjO/UjBRh64ltXkBsWybT0wR520MkkYn9jY6YLNcZR3v96BOxDsNH2edG/NK
	 3m0Tkdlu8EbwKwhLd7RWKkUjxqgvPiAG49VUvwZ54Uny9z9BhjLb+JFZ+oizgUd08m
	 HwZ4fNIIEzZC2FP7CT0e+smhpSLKcBVhlaHm+Hnw/cQZJknqIf823NVMfNrj/G9Jqh
	 zy3XjWe6mFyTA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hui.zhu@linux.dev,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhuhui@kylinos.cn,
	baoquan.he@linux.dev,
	liuxiang.277@bytedance.com,
	wangzicheng@honor.com,
	lianux.mm@gmail.com,
	kasong@tencent.com,
	liam@infradead.org,
	surenb@google.com,
	mhocko@suse.com,
	rppt@kernel.org,
	zhangbo56@xiaomi.com,
	lyugaofei@xiaomi.com,
	ridong.chen@linux.dev,
	kunwu.chan@gmail.com
Subject: [RFC PATCH v5 00/14] mm: mglru: fix swappiness behavior
Date: Fri, 23 Oct 2026 06:01:49 +0800
Message-Id: <20261022220203.91911-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5F61C100010
X-Rspam-User: 
X-Stat-Signature: tcjj7g71pkcmx743oh9asn53scay9eop
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792706534-406438
X-HE-Meta: U2FsdGVkX18VWK7pSXttW2ucg31dAw0Iips5cpHdSSJm2Ys0u5czuUPtorWbdhMw1mLNTat83BVhDcHGkkh3T5Tj9ouUC+m6w4HznAjHIMo+qR+mUCQ8heUghzjy8Lrka6LRCO9oyrK5s4FMDnYcpLnMLiBR4IBn98kCBk7tpL/vwIRmPWf1/Y8qLma1B5j+a+0YoMBT3vHeu/KOBlExqFJokNf4orhe1VTo1kN835gYaJ2rILZIWr8NIbxAAqIKEv94qLFyCuf7Me4qauF9yHDBdXaczj16mks77xcHsYz6QS/Sp9mMAtXNz0OOlxWTUSU1g9CRTWf4yjy8UhROZb/XBstMHrijBOwrtkVddi+KblBFEJk5r7+loOxyfQcq7+JYEapON9+650KfLTS4aO/mEAYQMzS4/Qh9EiRAaRdIY94djBTfEB+p97jt+hwj3S7WLPrpxjLtpAVCXlshfVLX4/rYylhyxXqE59nKJp3++8/4n+cjnj4FCozOWGS6KIdGAEtkrfKm4iHeXNJGDRPhwHFGQ1rFJr1pj71t1/g+5XnKTNQM9WwgrMJiG8qGMlyAUI0P2FiHl+5PDmFW5hbYEkU9Og75bgGZ/hJb11Z6dL2/k9B8mY1j1qRSe4Noy22U6ccjBLGPUcX8Jczqlx4Z8u5Eve8YzVcWoOevRP7sP27JYXpJ9zMJL5ZgrijKKkEqz3dOvVMIlMbCfXIC9pvoMJgLUudfuVnG9wx3ugRy/lfAzHtDVt35NHvO7Wy1ae1kYk8KrAU1MF8N8YsQQFqKBniW9tk7Pj7z+Z1y4tMwzcs+pwoRJjQHTVU8cgn31BMVuNyZMTzxQvF77BumwJ9jolPr7wEKYNCdkXa5crLbjF91gakk+1IOdYvK1QjSFSlHztS7RA7F80UJTnVLNyqWEp+p8l/khbqBKfKNReQJwb4i2+g/ZLAKFY9BPrN+AGLVLvltT4Map4Ww7uX
 kLo10bfs
 ai39wglQfmCvZ23YfSG836iPXk40fNFLk7nrhxc+rEPdH+k5q4tOFAwO6gDDtaJ5i9vszJ7csJ4f4BeRSwOApv7Piu5H2Ts0CZp8MUyaahJDA9BAAmHc8tP07mHo8RLLXD5kwe9hBMT9BNtR+RJon40UO9+sgcfTLih/KsqSTzi/GA5/iGZgtXfAGgq8J54NVjYLP0eVOsV9oFcLTDP8eRFc6AUNixAhmxFgik3Ps2kQOOCWvjBLBnlVKiIe8aF8/qH3plZE9nXsl3Ijm0Vffg1yXGQemv9oN3AoaKGJHYcvuUsw0PVj5H8jVbRmH+lu3bQyDyR3S+TYGESNgmgeHUM0LCvYlkeIql+WwqACfpEEGx3EnMLxv63jJWZ5UdTnXwDBq65ppnCw8XT13D7Qb5miH7mUwB7nWVYMdAfVJvb7o9lI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Classic LRU respects swappiness, while MGLRU only partially honors it
when selecting the scan type, resulting in a much smaller overall
impact.

For example, when building the kernel in a memcg limited to 1024 MB
of memory, with swappiness=200, CLRU barely scans or reclaims file
pages, while MGLRU still reclaims a significant number of them.
Similarly, with swappiness=1, MGLRU does not reclaim as many file
pages as expected for such an extreme swappiness value:

pgsteal_file
swappiness   CLRU          MGLRU(no patches)
1            5,894,538     756,589
36           799,998       497,282
71           548,331       415,612
106          407,012       383,814
141          253,737       354,249
176          189,003       347,805
200          0             346,078

pgsteal_anon
swappiness   CLRU          MGLRU(no patches)
1            3,962,404     2,768,654
36           2,830,250     2,976,260
71           3,121,386     3,142,954
106          3,521,720     3,382,383
141          3,504,471     2,970,859
176          3,592,335     3,163,130
200          14,095,617    3,209,132

pgscan_file
swappiness   CLRU          MGLRU(no patches)
1            10,270,808    886,997
36           1,010,341     569,036
71           656,136       490,972
106          460,326       436,042
141          295,184       403,132
176          235,147       390,358
200          0             398,363

pgscan_anon
swappiness   CLRU          MGLRU(no patches)
1            19,341,957    5,960,884
36           17,530,774    6,394,951
71           18,624,264    6,673,569
106          20,088,558    6,976,364
141          19,686,813    6,206,580
176          20,936,177    6,344,854
200          45,313,873    6,295,581

refault_file
swappiness   CLRU          MGLRU(no patches)
1            5,795,115     678,254
36           720,877       419,659
71           469,270       338,518
106          331,584       308,983
141          174,509       277,375
176          113,352       272,390
200          0             269,349

refault_anon
swappiness   CLRU          MGLRU(no patches)
1            738,618       578,308
36           451,410       665,723
71           514,961       657,870
106          633,161       786,893
141          648,640       662,673
176          668,779       708,969
200          4,816,312     672,514

In this patchset, patches 1-8 from Kairui introduce a model that uses
refaults to determine nr_to_scan[] for both file and anon in MGLRU.
For each reclaim operation, we calculate how many file and anon
folios to scan, similar to CLRU, rather than relying on
get_type_to_scan() and fallback mechanisms to decide what to
reclaim, which have proven rather unreliable in honoring swappiness.

This model also allows scanning and reclaiming from the two youngest
generations, including the youngest generation itself. This can help
resolve OOM situations[1] and reduce the need for aging.

Patch 9 from Barry fixes a cold/hot inversion exacerbated by patches
1–8 (which also exists in mainline) and improves reclaim efficiency.

Patches 10-13 from Gaofei and Barry optimize aging based on folio
distribution imbalance and improve reclaim behavior at extreme
swappiness values such as 1 and 200.

Patch 14 from Bo Zhang addresses the GFP_NOIO issue in MGLRU.

After the patchset, the results track CLRU across the full swappiness
range (see table below), with more file scanning at low swappiness
and more anon scanning at high swappiness.

pgsteal_file
swappiness   CLRU          MGLRU         MGLRU+patches
1            5,894,538     756,589       7,394,183
36           799,998       497,282       526,176
71           548,331       415,612       433,353
106          407,012       383,814       347,647
141          253,737       354,249       314,437
176          189,003       347,805       261,677
200          0             346,078       188

pgsteal_anon
swappiness   CLRU          MGLRU         MGLRU+patches
1            3,962,404     2,768,654     5,362,153
36           2,830,250     2,976,260     2,736,749
71           3,121,386     3,142,954     3,246,589
106          3,521,720     3,382,383     3,074,851
141          3,504,471     2,970,859     3,178,409
176          3,592,335     3,163,130     3,650,544
200          14,095,617    3,209,132     14,538,399

pgscan_file
swappiness   CLRU          MGLRU         MGLRU+patches
1            10,270,808    886,997       16,246,260
36           1,010,341     569,036       614,389
71           656,136       490,972       484,769
106          460,326       436,042       367,969
141          295,184       403,132       328,943
176          235,147       390,358       268,142
200          0             398,363       188

pgscan_anon
swappiness   CLRU          MGLRU         MGLRU+patches
1            19,341,957    5,960,884     7,646,122
36           17,530,774    6,394,951     5,914,405
71           18,624,264    6,673,569     7,167,762
106          20,088,558    6,976,364     7,821,921
141          19,686,813    6,206,580     8,495,970
176          20,936,177    6,344,854     10,585,375
200          45,313,873    6,295,581     30,313,342

refault_file
swappiness   CLRU          MGLRU         MGLRU+patches
1            5,795,115     678,254       7,315,064
36           720,877       419,659       448,199
71           469,270       338,518       355,269
106          331,584       308,983       270,736
141          174,509       277,375       237,643
176          113,352       272,390       184,908
200          0             269,349       102

refault_anon
swappiness   CLRU          MGLRU         MGLRU+patches
1            738,618       578,308       1,383,725
36           451,410       665,723       543,071
71           514,961       657,870       683,874
106          633,161       786,893       669,716
141          648,640       662,673       719,231
176          668,779       708,969       901,918
200          4,816,312     672,514       5,511,787

[1] https://github.com/ryncsn/emm-test-project/tree/master/file-anon-mix-pressure

RFC v5:
* Remove the aging optimizations, which have been merged - thanks for Baolin,
  Baoqun, Lian Wang, Kairui, Kunwu, Ridong reviewing on this;
* Add Kairui's model for determining nr_to_scan[] for both types.
* Fix cold/hot inversion for rejected folios - Barry.
* Improve and clean up imbalanced aging, and optimize extreme
  swappiness values of 1 and 200 - Gaofei, Barry.
* Address the GFP_NOIO issue in MGLRU - Bo Zhang.
* RFC v4 link:
 https://lore.kernel.org/linux-mm/20260812121658.69965-1-baohua@kernel.org/ 

RFC v4:
* Clean up isolate_folios() based on Baolin's feedback. Thanks!
* Further improve isolate_folios() and scan_folios(), including
  handling of exhausted reclaim types.
* Add fixes and performance improvements to inc_min_seq(),
  and reduce lock contention.
* Improve the handling of imbalanced aging and remaining
  generation-based aging.
*  RFC v3 link:
 https://lore.kernel.org/linux-mm/20260731083843.37811-1-baohua@kernel.org/

RFC v3:
 - Added Ridong's patch of improving isolate_folios() readability;
 - for lru_gen_imbalanced(), apply some suggestions from Zicheng
   and Kairui, considering lruvec size and use macro;
 - drop "mm: mglru: only fall back when reclaim is running at high
   priority"
 - mitigate aging for balanced swappiess value(near middle 100)
   as swappiness bias is less a concern for them; but slightly
   increased aging overhead might not be good.
 *  RFC v2 link:
   https://lore.kernel.org/linux-mm/20260726122123.7614-1-baohua@kernel.org/

RFC v2:
 - Quickly address a few issues raised in the Sashiko comments so
   reviewers can ignore v1 and review a cleaner version instead.
   https://sashiko.dev/#/patchset/20260726012946.18684-1-baohua@kernel.org
   Thanks, Sashiko!

Barry Song (Xiaomi) (3):
  mm/mglru: Avoid placing rejected folios below populated gen
  mm/mglru: Reduce LRU lock contention by shrinking folio batches in
    inc_min_seq
  mm/mglru: Make swappiness=1 file reclaim more aggressive

Bo Zhang (1):
  mm/mglru: Avoid scan anon while swapcache is low for GFP_NOIO
    allocation

Kairui Song (8):
  mm/mglru: report evictable sizes per type
  mm/mglru: extract lruvec_populated_min_seq() helper
  mm/mglru: reclaim from the oldest populated gen
  mm/mglru: lift the forced protection of reclaimer
  mm/mglru: skip zones above reclaim_idx instead of rotating them
  mm/mglru: return for unavailable anon reclaim earlier
  mm/mglru: balance anon and file scan budget by refault rate
  mm/mglru: lift youngest gen protection for higher priority

lyugaofei (2):
  mm/mglru: Run aging when pages are rare outside the youngest gen
  mm/mglru: Avoid prolonged anon reclaim with swappiness=200

 include/linux/mm_inline.h |  22 +-
 mm/vmscan.c               | 482 ++++++++++++++++++++++++--------------
 2 files changed, 332 insertions(+), 172 deletions(-)

-- 
2.34.1


