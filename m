Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAE80606A330
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mhbHX4Lz
Received: by kanga.kvack.org (Postfix)
	id E84BB6B05B0; Fri, 13 Nov 2026 13:55:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2F016B05B3; Fri, 13 Nov 2026 13:55:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D276B05B5; Fri, 13 Nov 2026 13:55:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A2E916B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:55:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 559FEC0188
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:55:51 +0000 (UTC)
X-FDA: 85431000102.16.7595924
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id A06F11C0006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:55:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mhbHX4Lz;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IL2ZDHTivJXAZxExPQOlakmXtpTkWanMmcraAEGCXQ0=;
	b=SoxCSahMaZy66PWZGsJTNwrtiUP9xynWQFbS7VbNHEX8o4GfORiZSQqPMFDsisjdBWfYo0
	++g1qawtQdpPESfIKoVCwdvHwL+zKPi5uubmo9VH2GhwfSREzXrPYEj79lg1KvO7lKLvHH
	AZetagauj/T6K4As96DYtc1PRvFxnd4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596149;
	b=zEFudpg8bj+LjPOn8aNc8LLqXJmI9V3XXfKCwfDy3DPhA9/a+GJPRwSeB9Bnvy0xrSfMJC
	rW7JAtlfHFf9Zjdj4rkiHPM8iXk/kl1B+hEjgJ+CfkIA9su+KVCmtsSqhoe3EKOpz7NVqy
	OLYmAE5M3qIWngNbgNzDQu2m3LPdImA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mhbHX4Lz;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D1305400E1;
	Fri, 13 Nov 2026 18:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC8A1F000C4;
	Fri, 13 Nov 2026 18:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596148;
	bh=IL2ZDHTivJXAZxExPQOlakmXtpTkWanMmcraAEGCXQ0=;
	h=From:To:Cc:Subject:Date;
	b=mhbHX4LzYZ11AhyNACAQLD0O9t57YnPG/RlnHVUXt4NcbyM+Kr4eeiKtOllZEn8+2
	 1aIB2ECFvMIG/LHeQptTJtT8ujO3JYoxDg2I2OLdduSTbd8OJCFyLex2Xob+B3Y6L3
	 8P/1DYKaleD9/TJ0BmWqro2nu+46D1Mmanzgx/m6hkSV5+InB2cnR69wm5jRz7UTTn
	 6GW31ITJJFYy+kmeRCE7459EoW2vyII8uIHJxWMQ8au2PGnz2Z607iX/v9oKvrch5V
	 2prXYp1Jslv4n9nrM/CpXjZwlTZrG0hmr9hjV0zPfT2b7l5z1Wg9TVWJGwg5DhFpu4
	 eICOyzOD3QL+A==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v8 00/16] mm: mglru: fix swappiness behavior
Date: Sat, 14 Nov 2026 02:55:25 +0800
Message-Id: <20261113185541.70203-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: wxi7h41m9yn7hhdncdptc3zghgha9fjn
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A06F11C0006
X-Rspam-User: 
X-HE-Tag: 1794596149-41958
X-HE-Meta: U2FsdGVkX19ISabAefY7Mj67y1siYOgnExulGDmUAjU7psGk3SWUkO5OZXl9JNEFXLaTvN7Vbk6dJdyNuxaw5TY6Tl8C4gm+UuXEULbsR71N430O4qiKE8Ycj1kpwlZ6149CgYllR18B92cD7DC8G42n9uR56HONxKM0UUTL7yZ/VRI67SvLa5sx0KFH2v13fjCikJvAZCIF2HkEu9LVYH0v6C1EKkXAGs2Y4vsUls9E3862JDJhymgw5AnpWQHgBxVMUXwq4fTTRsUus2fI1Yn+o+8RFirPPBAbjpMr9H8R4LPaGihnSR+bVdKdP1oTZA/tZE6ie8jTx5ZmcgG9x8zpychTksugddKqihWqcxfl2E7FuEnBOp6b/WPsLjxXlRFbuuzCPSux0z6QlfsUO+SjS11mLI9JCrUbkt9hngolX/SDY2E590Bqs1HJ4GSrXinij3Ga5o0boxU0xvf5jM8FXv7abd1mvi4iKGNajlTks2KqMQSNHmSNcimka6Ow3tIf9yJn+u37PhaJvvcQMn74MN2HlWuhKVIVlM8TxSTv45zDcj+tT8HXt79H4Ang9/luetShcnRgtiYvI2DHwrN0SqoCAZ0+ZDF/awk//cyhds7CsgPbAI/lCJQO91hXmjWLJI5z8lYky4/SE+5kVGT2K75Kb8O3kQMtxHinQAZRLvJvGLo+I/XDFar9GVXt2pF05DlNOHHNxbczKRaX+Albg2PDvOC2ucN99P3nzSSCvWJIeGRufXH9mhJOba8vguHYsOkgo3bPCYE9TITBc6vud9dYqBRkCDumJlWu9c3U6IaDP82Wdk6jLxnmA0CMVlJqImUlxqrpTAuaqOP/LlI0EzVOWJOJcMBhkCzmoW2Ixhu30w9mR7oBfaWXpq27wCcUGzpXpVBiTSwaAYtrvrjfj/PcfSxd9XT9I3mZdMs1G0qnodSoSdn4rsousE3hUziWOmpjL2g+VXg8Nbu
 Rq8x2NKN
 5I8ek0NMjijArPsfCGxGdDeSivyOP6n9/8Q7yUzqg0eSc8n2wagD/digrLn3SNFPqGeMk60do5q33osXrK7+ma385A5fRw1/32F0JQ/Upsq+Q0DVi5NoEcnktrP5JLoRTlKjlKO1FFAgednce3zMwXXgjpxq5i6/+gdU5L3YM6Ymn5kixjUHK5mELe9L5km7dNyTSD1wwEu5GHgd9zN7bkiZuHkdqn6uqDonXg+B/42e5WqqpqGW61Kybul8jPk1KVfmvW94Tn1z6TFZyYuendlw68XMdMpKurStO/Ld36LnopYawUlVsMkkNk0pVwhiBTMfkIpiXu2sfyjE0uwkTGJQ8SCgMydgZ4OZqAlVmKXsWp2wZFKZqkHBv717fCIj+x826Ztm2phehNBhYyP6wuiS3m1oTpXAEI/qb4lh3y2kJvaUzvAa3tfvPBVRmOht3fBB5c8yXcCr4fC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Classic LRU respects swappiness, while MGLRU only weakly
honors it when selecting the scan type. The fallback logic
can easily override the bias established by
get_type_to_scan(). As a result, swappiness has a much
smaller overall impact when changing from 1 to 200, as
shown by the data presented later in this cover letter.

In this patchset, patches 1-8 from Kairui introduce a model that uses
refaults to determine nr_to_scan[] for both file and anon in MGLRU.
For each reclaim operation, we calculate how many file and anon
folios to scan, similar to CLRU, rather than relying on
get_type_to_scan() and fallback mechanisms to decide what to
reclaim, which have proven rather unreliable in honoring swappiness.
This model also allows scanning and reclaiming from the two youngest
generations, including the youngest generation itself. This can help
resolve OOM situations[1] and reduce the need for aging.

As Kairui mentioned, the OOM reproducer was demonstrated
previously [2], and that series was merged in v7 [3].
The problem was largely alleviated as described, but not
completely fixed. Under higher memory pressure, the system
could still hit OOM. Before this series, Kairui could still
reproduce OOM after hundreds of iterations. With the fixing
patch in this series applied, the problem no longer occurs.

Patch 9 from Barry fixes a cold/hot inversion exacerbated by patches
1–8 (which also exists in mainline) and improves reclaim efficiency.

Patches 10-15 from Gaofei and Barry optimize aging based on folio
distribution imbalance and improve reclaim behavior at extreme
swappiness values such as 1 and 200.

Patch 16 from Bo Zhang addresses the GFP_NOIO issue in MGLRU.

After the patchset, the results track CLRU across the full swappiness
range (see table below), with more file scanning at low swappiness
and more anon scanning at high swappiness.

pgsteal_file
swappiness   CLRU          MGLRU         MGLRU+patches
1            6,620,680     745,968       6,190,575
36           807,807       508,974       525,304
71           553,144       417,700       405,545
106          402,880       402,474       348,365
141          240,293       337,797       305,170
176          187,682       330,045       231,038
200          0             343,949       256

pgsteal_anon
swappiness   CLRU          MGLRU         MGLRU+patches
1            4,436,199     2,671,934     5,103,813
36           2,858,117     3,032,747     3,134,511
71           3,042,392     2,827,735     3,170,171
106          3,292,622     3,184,314     3,225,293
141          3,612,869     2,999,000     3,590,478
176          3,827,154     3,134,127     3,873,163
200          13,825,283    3,269,753     14,399,074

pgscan_file
swappiness   CLRU          MGLRU         MGLRU+patches
1            11,853,625    877,311       12,715,103
36           1,016,826     582,783       612,867
71           662,823       474,772       443,149
106          496,374       451,285       364,203
141          277,109       382,604       327,444
176          206,261       372,059       236,838
200          0             393,608       256

pgscan_anon
swappiness   CLRU          MGLRU         MGLRU+patches
1            20,804,386    5,847,747     7,142,640
36           17,830,330    6,740,075     6,297,912
71           18,357,293    6,126,194     7,046,149
106          19,938,920    6,431,355     7,876,121
141          19,609,579    5,997,762     9,672,762
176          21,612,749    6,071,032     11,195,357
200          44,776,474    6,544,125     30,225,030

refault_file
swappiness   CLRU          MGLRU         MGLRU+patches
1            6,523,070     667,302       6,103,539
36           722,110       431,585       448,161
71           477,062       340,241       331,108
106          327,610       324,747       272,266
141          161,827       265,959       228,015
176          115,551       258,515       172,882
200          0             268,049       212

refault_anon
swappiness   CLRU          MGLRU         MGLRU+patches
1            867,728       552,829       1,415,594
36           419,635       657,745       668,238
71           536,299       611,345       672,096
106          580,742       693,689       728,319
141          706,151       639,850       817,954
176          706,499       685,086       949,643
200          4,693,850     733,273       5,475,622

With a normal swappiness setting (without extreme bias), I
see almost no noticeable performance difference between
the two versions.

For example, with `swappiness=60`, the average results
over 5 rounds are:

metric          W/o patch     W/ patch
real            1m49.273s     1m49.051s
user            25m33.186s    25m31.778s
sys             3m41.851s     3m40.721s

[1] https://github.com/ryncsn/emm-test-project/tree/master/file-anon-mix-pressure
[2] https://lore.kernel.org/all/20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com/
[3] https://lore.kernel.org/linux-mm/20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com/

v8:
* Fixed Gaofei Lyu's name;
* for debugfs proactive reclaim, use DEF_PRIORITY;
* refine no-populatable aging (limit frequency, allow an aging
  after eviction returns 0 scanned)
* refine "restrict eviction accounting to eligible zones" for
  potential premature OOM;
* Collect Baolin's reviewed-by tag, thanks!
v7 link:
  https://lore.kernel.org/linux-mm/20261111232603.9934-1-baohua@kernel.org/

v7:
* fix a build error of bisect and address some other sashiko minor comments;
* add no-populatable aging;
v6 link:
  https://lore.kernel.org/linux-mm/20261110202025.25736-1-baohua@kernel.org/

v6:
* rebase on top of mm-new(a lot of conflicts due to recent active mglru
  developments);
* only count eligible zones below sc->reclaim_idx for
  lruvec_evictable_size() and lru_gen_imbalanced();
* GFP_NOIO further fixing by Bo Zhang, exclude unreclaimable type
  in lruvec_evictable_size().
* Add Kunwu's reviewed-by, thanks!
* RFC v5 link:
 https://lore.kernel.org/linux-mm/20261022220203.91911-1-baohua@kernel.org/

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

Barry Song (Xiaomi) (5):
  mm/mglru: Avoid placing rejected folios below populated gen
  mm/mglru: Run aging when one type has no populatable folios
  mm/mglru: Restrict eviction accounting to eligible zones
  mm/mglru: Reduce LRU lock contention by shrinking folio batches in
    inc_min_seq
  mm/mglru: Make swappiness=1 file reclaim more aggressive

Bo Zhang (1):
  mm/mglru: Avoid scan anon while swapcache is low for GFP_NOIO
    allocation

Gaofei Lyu (2):
  mm/mglru: Run aging when pages are rare outside the youngest gen
  mm/mglru: Avoid prolonged anon reclaim with swappiness=200

Kairui Song (8):
  mm/mglru: report evictable sizes per type
  mm/mglru: extract lruvec_populated_min_seq() helper
  mm/mglru: reclaim from the oldest populated gen
  mm/mglru: lift the forced protection of reclaimer
  mm/mglru: skip zones above reclaim_idx instead of rotating them
  mm/mglru: return for unavailable anon reclaim earlier
  mm/mglru: balance anon and file scan budget by refault rate
  mm/mglru: lift youngest gen protection for higher priority

 include/linux/mm_inline.h |  22 +-
 mm/trace_vmscan.h         |   4 +-
 mm/vmscan.c               | 516 +++++++++++++++++++++++++-------------
 mm/vmscan.h               |   5 +-
 4 files changed, 366 insertions(+), 181 deletions(-)

-- 
2.39.3 (Apple Git-146)


