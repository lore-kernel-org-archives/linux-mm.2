Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C4ED2ECE9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:58:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D078C6B0413; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B569C6B040C; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 789846B0415; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2DD0B6B040C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF4211405A9
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:57:57 +0000 (UTC)
X-FDA: 84352495794.25.5D977CA
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id C2DCF1C000F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:57:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768917476; a=rsa-sha256;
	cv=none;
	b=bsq6HWeGRt++HlgYClK98K6WfPIyEGTF8QJos03TXuYwGdr2qI2JzVVQCUNDh5r6Za3lLD
	KZk24GfYernTR7BkXVm36A+QHdfLPd8kiG+KO0YAwgLxymz8sPuvdid43/Y22r7GdBXvGH
	J22psBDKwYUDUf4SFRn4v6KeeZ0xQQU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768917476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=BwHnQaUQ3XWkLs9uRmDdn58bo5Ir+sIZvbUVuV5j1ac=;
	b=qr37o4B5zZITQXD7fO1c4b1LKjwVEaCu6R4Hd/UqbckGhQ5cSMQmKDh1B/74urxhZYewnM
	ZVD6QZ6J7kGwpFTF1Fpoky+KcWBQ/hKLi+sAQYA1CMl49tPxu1s9ydr+0b0WM7gP0yQ3r0
	86pT61yj+XAdRnbeyMmt2lZ+copfbJU=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dwTR70MBKzYQvHP
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:57:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B47A44058C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:57:46 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgCnCPnQiW9pwhTxEQ--.10691S2;
	Tue, 20 Jan 2026 21:57:43 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	zhengqi.arch@bytedance.com
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huaweicloud.com,
	ryncsn@gmail.com
Subject: [RFC PATCH -next 0/7] Introduce heat-level memcg reclaim
Date: Tue, 20 Jan 2026 13:42:49 +0000
Message-Id: <20260120134256.2271710-1-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCPnQiW9pwhTxEQ--.10691S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZw1Utw1rJFW7WrWUWw1Utrb_yoW5AFyUpa
	93Wasxtws5JF15AanrAayUWrWfZrn7J3W3XF98Kr97Ar13AFyvvFWIkr1ruFWDCrWxtry3
	XrnF93WDWF4DAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjTRRBT5DUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C2DCF1C000F
X-Stat-Signature: d51etp9khigrbhbpof5ohytqkf9kwxfu
X-Rspam-User: 
X-HE-Tag: 1768917471-847399
X-HE-Meta: U2FsdGVkX1+JcUbg4X98JMR+U23ltI9FcwSpXeNNmlvFHXBWck0XLvO1YbboIGtGAO05nrC9fnE3uYHP96oGN4smiU1HkNRYLxQHmm2QpNUHuxeSggkyn4IXAfWo8UthTYzZI3TQcfFGZH2YwRd7u778V4lH85ClGLgGLH1s50axwaeyDn5mPJymfJLUFNU170+SKWKwtPZhzbPmbg+YvCRYkSV0UAHiM6eaCqmGSrE7lozVImbX5J756Dln/+MRB7UFcYj2PrMqB5PhWaiiMOxeQrLjYNbbgV6Zci5yBMKFbTHZ8ktAPIA7VOFcvX9iX1a1/YiqSeaHB7CmlgN5vhytO/9SLZqglqARKFyRIUiulomf34Wo+EHXgc7dcPDig1jiyX8x3HIC3yDiY1u9UNhzD5hSPCq0hP4Zh7K3oKvO4LPXv1AQu0mp64m5GokbkzdeszGACmnuFsG/9hvaUZcruz90KNMLQn+n3raCHDV3ZInjm6myInlkJqOfMDzFEIBGM2yPnxEeEPQys7+gEbmyq/2ahS6cpu0n/wuPpvL+jKeu37aZb4+wraG4M/XUMIY0U1oEpZU5zW4JlvEtzgt36pfryvfQk2Bnox+LHui+EqobxCcQey3ZZt8IL+YazcZkaS1h0XJedjCceAZevkFrkEA4Th4efMbOOPHhWC5Ga95UiT4sWzX9eN1pw61+kBu3HBTGvXZPgTQcFhhDXmoWUKD5Ihxb4hVDoho1w7L7t0qfVN3Vub6sAzaZnX+frB+KBXeh13sdW1y90HVrxhRJU/HNnZeO1tnmyzwuM31Id/wi6eE1++zf5pM+ix8ojsPJVEfqH5FbgVqxNRFXlmMoN0nLhTu4IHuiGXxirDIclH6yaLOsQABMGfZli9/NnIhfKidi+mg7OUOyQMraHIJcVmgn8Wdkf4HPo9cNL4nahMZeOkbnOzDYkNXl9gPnhJDa0sinSERWgV65KhW
 YZ5Y7DEX
 Wv3XLQXq6esDrVaPtcbT/bQb1YwNwRV59OiYJHVPbR4n2WOvVizG4KioLbyuqztBEUDJ+ip1oCyQU0U3wE2COHr7IszyvIBN0li/ym1X9bKhSGSfzJEsT7yDHB8R/Z7TOnFihOq8kBvffx8SUCht4R4WQ8uqtbgYdpWl43SeSiI5sZssVDAEXSu0Mb+9yOggg5MWY+7Xx9UG4nkvRx6Dt0jgIKWKyuN7kH+bV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

The memcg LRU was originally introduced to improve scalability during
global reclaim, but it only supports gen lru global reclaim and its
implementation has become complex. Moreover, it has caused performance
regressions when dealing with a large number of memory cgroups [1].

Previous attempts to remove memcg LRU by switching back to iteration
implementation brought performance regression [3].

This series introduces a per-memcg heat level mechanism for reclaim,
aiming to unify gen lru and traditional LRU global reclaim. The core
idea is to track per-node per-memcg reclaim state, including heat,
last_decay, and last_refault. Three reclaim heat levels are defined:
cold, warm, and hot. Cold memcgs are reclaimed first; only if cold
memcgs cannot reclaim enough pages, warm memcgs become eligible for
reclaim. Hot memcgs are reclaimed last.

While the heat level design can be applied to all memcg reclaim scenarios,
this series takes a conservative approach and initially applies it only
to global reclaim. The first few patches introduce the heat level
infrastructure and apply it to traditional LRU global reclaim. The
subsequent patches gradually migrate gen lru global reclaim to the
heat-level-based approach, with the final patch combining shrink_many
into shrink_node_memcgs to complete the transition.

Performance results show significant improvements:

Traditional LRU results (2-hour run of test [2]):
Throughput (number of requests)         before     after        Change
Total                                   1,734,169  2,353,717    +35%

Gen LRU results (24-hour run of test [2]):
Throughput (number of requests)         before     after        Change
Total                                   22,879,701 25,331,956   +10%

The performance tests are based on next branch commit:
commit ef0d146624b0 ("Add linux-next specific files for 20251219")

This series has been rebased on next-20260119:
commit d08c85ac8894 ("Add linux-next specific files for 20260119")

[1] https://lore.kernel.org/r/20251126171513.GC135004@cmpxchg.org
[2] https://lore.kernel.org/r/20221222041905.2431096-7-yuzhao@google.com
[3] https://lore.kernel.org/lkml/20251224073032.161911-1-chenridong@huaweicloud.com/

Chen Ridong (7):
  vmscan: add memcg heat level for reclaim
  mm/mglru: make calls to flush_reclaim_state() similar for MGLRU and
    non-MGLRU
  mm/mglru: rename should_abort_scan to lru_gen_should_abort_scan
  mm/mglru: extend lru_gen_shrink_lruvec to support root reclaim
  mm/mglru: combine shrink_many into shrink_node_memcgs
  mm/mglru: remove memcg disable handling from lru_gen_shrink_node
  mm/mglru: remove memcg lru

 Documentation/mm/multigen_lru.rst |  30 --
 include/linux/memcontrol.h        |   7 +
 include/linux/mmzone.h            |  89 -----
 mm/memcontrol-v1.c                |   6 -
 mm/memcontrol.c                   |   7 +-
 mm/mm_init.c                      |   1 -
 mm/vmscan.c                       | 547 ++++++++++++------------------
 7 files changed, 231 insertions(+), 456 deletions(-)

-- 
2.34.1


