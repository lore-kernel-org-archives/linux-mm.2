Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C5C2D78763
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 12:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 730B26B008A; Fri, 19 Dec 2025 07:47:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A64B6B008C; Fri, 19 Dec 2025 07:47:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 483D76B0092; Fri, 19 Dec 2025 07:47:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2DF396B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:47:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC0B0B5E66
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:47:03 +0000 (UTC)
X-FDA: 84236195526.01.1C62E45
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf08.hostedemail.com (Postfix) with ESMTP id 11E88160017
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:47:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf08.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766148422; a=rsa-sha256;
	cv=none;
	b=B+vCWh36Bnm9fLKojjaaYHGTW1dwpM1n+DSMIFal08Ct5mr+CS6kfAKS5pnlbxfMNXv/LW
	Xpwh7DM/WjYga5ZqpGZ3p2PiP7rL6rQGzqva2lzzOgtENsxMJC8SStVuR5FuHFLJd5qTrO
	LeEa6yCfjiyxwqF/qGjApezKEhkZqb8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf08.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766148422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=GlKcpYbkIw41H6w82IcqyjgrVyy1fZ0EgNxFxgaaITU=;
	b=WrVQaq6dw4E2wvag2G/8NRZ4Cvf2uQLwQ2UkJt+k8ncM377DfsMg1D5sUqAVOfXY93FiTi
	sphvi2aSNAsqRC14mQE3wQoUVAyItKxwpgpQtNiBmG4APd69lYbiNJ5JaJg8WT/1lXhu+s
	hJ29el6FVphYP3R9yVzEfpXFx1nUbtc=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dXnN0384pzJ46cx;
	Fri, 19 Dec 2025 20:46:24 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 0C5C240576;
	Fri, 19 Dec 2025 20:46:57 +0800 (CST)
Received: from mscphis00972.huawei.com (10.123.68.107) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 19 Dec 2025 15:46:56 +0300
From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
To: <patchwork@huawei.com>
CC: <guohanjun@huawei.com>, <wangkefeng.wang@huawei.com>,
	<weiyongjun1@huawei.com>, <yusongping@huawei.com>, <leijitang@huawei.com>,
	<artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<alexander.grubnikov@huawei.com>, <gorbunov.ivan@h-partners.com>,
	<akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<harry.yoo@oracle.com>, <willy@infradead.org>,
	<gladyshev.ilya1@h-partners.com>, <yuzhao@google.com>,
	<baolin.wang@linux.alibaba.com>, <muchun.song@linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 0/2] mm: improve folio refcount scalability
Date: Fri, 19 Dec 2025 12:46:37 +0000
Message-ID: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.68.107]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 11E88160017
X-Stat-Signature: gnbb3ex3fcn7drwgqtpsodsuq6b1am6q
X-HE-Tag: 1766148421-956527
X-HE-Meta: U2FsdGVkX197FY88ArDTI6wLHmqba+Iprr71dH5s92j1fWSzi9lR7OCP4UjjaGEzrVLFs9vPf+wHeHS33rBg6AraHHUIMFhSs0SqllA34hn9dFue+w6lZyBcfZC6XAYF+U5yIxnXc97cOxnfTg9jRqBwAZj+ipTxq/+qGTZmwsLBSXeeAseLY3LVJHuootLgdf3Hh907ytc9AiyhylpoD7sdYy78PjzM/CSt1/dX00MsC0sVcw3v4IWeO+ommBMv23TfN0rH6otmreK/dv5sVsjH172uPqupAB0snQE8eVgZgiD0gpz8Dme9IqfRKEPnPdqyqnpG9AqD0QMDrnkUFPvBRQxf7gI5OSIOxXiJdVX0k9z8fR3AHu/X/dBpVtAyFb0v29WQYVfElxnWXoy1SnERqGZTLLv8asVrPjHXaRkjYTpXzqG/CjNZzgRxZ1QOlhUkudreStBGed8KCv5vmNFD+Ua6jAR27dpqsOzyFtbBWqU+iyy1+6ic9JCGUz9bp/kAjXpRJjBdjuXZMsgq9V2dg7l4bMM1Fr2usnHGaECxzkuov1Qx6Rb+FHbM2M4DqCD+1khcMM7ksIL/fcWefS/X6bmnXmTJrbQZZWKrmAHSKJrp6xze7T5FGd3kv/3Z4vrKTgw5z4D+Bn8RuGkh/fxUHqrQ/y4UPlMw17JlMTjvdcoQGfOJFg1TiWBq3nSUMwcyenTRet3syziyjGrA1ek5Lkbxc+cQSE0WFIiK7iVJKSVCXiy86WuA1PPtwTdx5PHC90wwxyDhbRTzJTaAfgkoAjJTm4wH8gYqUnC1L4PvDMnVKEcv6emB5rx1mVevC9rrSkEQtdjmF+tMjM/K57ss04A/JnsMbhT8gAU4cWNNrqZotdaBdaNNeSQSYqnR5vWSknpSz/B1nXCMTpq3pDwVpz4ruFFfhuWRrbLRGYlhHJpixtjQ2GuCkmUfBV8Jwf5zh6QDz/gbijTI4gy
 F56ZyDv/
 gYivVAiTFh/YdNyrbq1CZaVhIUE+x0zxQI+x5hfl5KpLVEio2wDsOakukyKmlwipUe1hyoyKagzy+xRnilIHWcbKeYkq4jlnkWeSnYV9p4CWKHAoOznetLNzyMmmJPunOUuU7mMAqwcsdaNEkfqh+lEUIofdQ0BgC5Ne8ejsqcMcGBfUI9Ls/Ox1vzKbZUrNKYxc+EllfORIytciN3glTZ5l+41dcEJHMaYN4wB1MCEmF4Hc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Intro
=====
This patch optimizes small file read performance and overall folio refcount
scalability by refactoring page_ref_add_unless [core of folio_try_get].
This is alternative approach to previous attempts to fix small read
performance by avoiding refcount bumps [1][2].

Overview
========
Current refcount implementation is using zero counter as locked (dead/frozen)
state, which required CAS loop for increments to avoid temporary unlocks in
try_get functions. These CAS loops became a serialization point for otherwise
scalable and fast read side.

Proposed implementation separates "locked" logic from the counting, allowing
the use of optimistic fetch_add() instead of CAS. For more details, please
refer to the commit message of the patch itself.

Proposed logic maintains the same public API as before, including all existing
memory barrier guarantees.

Drawbacks
=========
In theory, an optimistic fetch_add can overflow the atomic_t and reset the
locked state. Currently, this is mitigated via a single CAS operation after
the "failed" fetch_add, which tries to reset the counter to a locked zero.
While this best-effort approach doesn't have any strong guarantees, it's
unrealistic that there will be 2^31 highly contended try_get calls on a locked
folio, and in each of these calls, the CAS operation will fail.

If this guarantee isn't sufficient, it can be improved by performing a full
CAS loop when the counter is approaching overflow.

Performance
===========
Performance was measured using a simple custom benchmark based on
will-it-scale[3]. This benchmark spawns N pinned threads/processes that
execute the following loop:
``
char buf[]
fd = open(/* same file in tmpfs */);

while (true) {
    pread(fd, buf, /* read size = */ 64, /* offset = */0)
}
``
While this is a synthetic load, it does highlight existing issue and
doesn't differ a lot from benchmarking in [2] patch.

This benchmark measures operations per second in the inner loop and the
results across all workers. Performance was tested on top of v6.15 kernel[4]
on two platforms. Since threads and processes showed similar performance on
both systems, only the thread results are provided below. The performance
improvement scales linearly between the CPU counts shown.

Platform 1: 2 x E5-2690 v3, 12C/12T each [disabled SMT]

#threads | vanilla | patched | boost (%)
       1 | 1343381 | 1344401 |  +0.1
       2 | 2186160 | 2455837 | +12.3
       5 | 5277092 | 6108030 | +15.7
      10 | 5858123 | 7506328 | +28.1
      12 | 6484445 | 8137706 | +25.5
         /* Cross socket NUMA */
      14 | 3145860 | 4247391 | +35.0
      16 | 2350840 | 4262707 | +81.3
      18 | 2378825 | 4121415 | +73.2
      20 | 2438475 | 4683548 | +92.1
      24 | 2325998 | 4529737 | +94.7

Platform 2: 2 x AMD EPYC 9654, 96C/192T each [enabled SMT]

#threads | vanilla | patched | boost (%)
       1 | 1077276 | 1081653 |  +0.4
       5 | 4286838 | 4682513 |  +9.2
      10 | 1698095 | 1902753 | +12.1
      20 | 1662266 | 1921603 | +15.6
      49 | 1486745 | 1828926 | +23.0
      97 | 1617365 | 2052635 | +26.9
         /* Cross socket NUMA */
     105 | 1368319 | 1798862 | +31.5
     136 | 1008071 | 1393055 | +38.2
     168 |  879332 | 1245210 | +41.6
               /* SMT */
     193 |  905432 | 1294833 | +43.0
     289 |  851988 | 1313110 | +54.1
     353 |  771288 | 1347165 | +74.7

[1] https://lore.kernel.org/linux-mm/CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com/
[2] https://lore.kernel.org/linux-mm/20251017141536.577466-1-kirill@shutemov.name/
[3] https://github.com/antonblanchard/will-it-scale
[4] There were no changes to page_ref.h between v6.15 and v6.18 or any
    significant performance changes on the read side in mm/filemap.c

Gladyshev Ilya (2):
  mm: make ref_unless functions unless_zero only
  mm: implement page refcount locking via dedicated bit

 include/linux/mm.h         |  2 +-
 include/linux/page-flags.h |  9 ++++++---
 include/linux/page_ref.h   | 35 ++++++++++++++++++++++++++---------
 3 files changed, 33 insertions(+), 13 deletions(-)

-- 
2.43.0


