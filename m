Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5FFDC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93FDE6B0095; Wed,  2 Sep 2026 09:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893CE6B0096; Wed,  2 Sep 2026 09:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7107A6B0099; Wed,  2 Sep 2026 09:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F8C16B0095
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:17:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BCB81801DB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:17:05 +0000 (UTC)
X-FDA: 85168872810.24.D0B8261
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf01.hostedemail.com (Postfix) with ESMTP id C7BDD40014
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:17:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=b0wTimjL;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8Vx1ScIjzS7o5RooSf6BJ0hm6c4fipiuqGVHNi/yfPc=;
	b=YUDP/+1dMlERN/3DA572Pm3fd+bAP+li0pmQojPtLLbNX++46beeAhVaLWh1L5LYSJkg2Q
	vg+PdAgp94c5k0TP25V8ZxwpgOBukMn+/nmkeRJVRL40JH4t8f3Tw2b4BTE/dEfTpQIGrk
	pVfCs6SGBKJzOzFgQBB6iqYo8F6kQdw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=b0wTimjL;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355024;
	b=4+p3uoozVAwOFIfF6CQ6tAYpMRPLXnhiVV+jAyYPxlF1GaJmQGHLfpuDfmDZxyAFEirbIz
	0XVPYXyGGFk7PQtPQT+DZyfabU0wvjgva0iTj8biFcT3I6mejv1XkbjG573eEXnNcIwiux
	q5Af9m7TGIdW6dM3Zc0n9esGFgFczzo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8Vx1ScIjzS7o5RooSf6BJ0hm6c4fipiuqGVHNi/yfPc=;
	b=b0wTimjL5yFHsuCctPVCTE2FOh8S5GitqHT22vK8JOB+49aUeA9Vqe+MAMTt64JwHR17H0BtU
	ZXDdThC2FXwumgtxxhexKeOrHkX6hFzYi51twKBje7cBcrGCDdLqv1FH/Vu3qre/cAzAylFjoOK
	c84eBNRDdjtou0MoSr/1qtI=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hZjdb19D2z12LDV;
	Wed,  2 Sep 2026 21:05:39 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 5DFF24058C;
	Wed,  2 Sep 2026 21:16:55 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 2 Sep
 2026 21:16:54 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <david@kernel.org>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <ljs@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 0/4] mm: replace PF_KCOMPACTD/PF_KSWAPD with kthread_func()
Date: Wed, 2 Sep 2026 21:16:49 +0800
Message-ID: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Stat-Signature: i4i57n6xnupi98m8p8afue6bfbte7yw4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C7BDD40014
X-Rspam-User: 
X-HE-Tag: 1788355023-559499
X-HE-Meta: U2FsdGVkX18KFHB9esxEaAsh/rkvX4TMw//DGA0FRCuSI4Nbw3cCjTmVBBCtUO7X0T1/HFQPbVnp9km+SBZ5xh04QSIHT0o0amhjm41F8DCVGtZWS23jCQ3oYy3W5rnejvpC8KLJc3saeN/pOHRg3ux5NxCsz0DWLVohQcFv1SUcvlxdgqn4DlTCjfofzKOjwj9LIQeMFV2lQDk0L/1A0woLqKVqP332y6jZDTt5UlPCalCr5+67ulzpV0v42A7d8f4uZgIv1sPzqc7S8gluOkab6G7x5DM4nlvNHCbAmxIf3Y5U7uq66pYlNVnInS3iYkSSlo3bYq/9x5e14JthskjuBsR9U6G2LNbSpP3HRMbYlJkVhum3GpiKmIuKwxSLVn6XbMvJu3k30YlrtKuCmTEe9IReKv2+egfjQbkcMXcXdS8OHLKkrk1uMI4ynqj2K/CVCAK60DsiJRpPWqaAmsRdKgxu0CND/EYnzZ/+Wi/PAGZ9Z57tXevlqGYoyzyeeIWgKOa/SCMhfzhoZKnwMWpcHXwuDFIY1+355no1smaOPhZPM2X8wEUu0GfuM7m8BRlA+C0lePrvFSL+fmkGQaCM/FaKQzIfwRRDhzG3nz2zFk1r3/OIIeSB/h++Gep8kd/2Zl9HrnTzTLuCOWQpJl0Gc8rZoQW0KhP26Fy2UsyrkmJRDM1AmIPprLFRaiepaQWqavT+1Eu4FQDi4psbpXw481xcVtG8Vs/+y4s8oFx/3U9nZUHeGPhsPAae8iS5p6ENZL75xMs5RYNMdlG+qcmbpMRgoaMceBeFse0Vm6XL8NNhgpU2q0lX9R9j6k2NCALre68hOpvh9DeoiXa1wYmKiVUWB+h4Z+d/2GE++QUpZ6nN99BjAuW6HqwEfg21gy/DeQS97nZ0udhddum4VQgwebk/e5NYDXZntl8t9bA/AIcBdS0IAQcV1tYlf5ctoWXCniKGFolDjQL3KwA
 srH/G86j
 Zzn/s1JAehe2KSK5nBopIN8PT6/rILGhagd4Woxaa8xkX1zT5kn1tSmCeejWsh6K66Hksy5jqFqSF62eugTmq6V8F5ioH5rtSerEz2qsNAYCJGYFnDcwqspPIdgR1G8R34M7QY/qp1DjbyBlEDXc/Dx1jYoiinNpI3GHWJfLMLRPAeR8zmMXuJJALlfgB7fCjUz9IYM5O2izfmOzhSPyo7t0kq8REd6p/TxcOppWz7N74RcDpunXUTouWMKJs8ESRjjZcrv4DexGMwtM8wvrtickwP8XUJWhGPmwdukSH2p2PWBfiDquyFMbdhG5riPeR9Vs7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The task_struct->flags field is a limited 32-bit resource. Two flag bits,
PF_KCOMPACTD and PF_KSWAPD, are used to identify whether a kernel thread
is kcompactd or kswapd. Converting these to use kthread_func() frees up
two valuable flag bits for future use.

Kefeng Wang (4):
  xfs: remove dead kswapd flag inheritance from btree split worker
  iomap: simplify writepages reclaim guard
  mm: replace PF_KSWAPD flag with kthread_func() check
  mm: replace PF_KCOMPACTD flag with kthread_func() check

 fs/iomap/buffered-io.c                   |  3 +--
 fs/xfs/libxfs/xfs_btree.c                | 18 +-----------------
 fs/xfs/xfs_platform.h                    |  4 ----
 include/linux/compaction.h               | 11 ++++++-----
 include/linux/sched.h                    |  4 ++--
 include/linux/swap.h                     |  7 +------
 mm/compaction.c                          |  9 ++++++---
 mm/vmscan.c                              | 10 ++++++++--
 tools/sched_ext/include/scx/common.bpf.h |  2 --
 9 files changed, 25 insertions(+), 43 deletions(-)

-- 
2.55.0


