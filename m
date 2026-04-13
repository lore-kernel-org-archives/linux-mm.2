Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D880E64007
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 06:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E48B76B0092; Mon, 13 Apr 2026 02:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCDCA6B0096; Mon, 13 Apr 2026 02:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C95BB6B0095; Mon, 13 Apr 2026 02:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B35AB6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 02:21:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77DD7C3A1E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:21:31 +0000 (UTC)
X-FDA: 84652535982.24.2D28029
Received: from mailgw2.hygon.cn (unknown [101.204.27.37])
	by imf18.hostedemail.com (Postfix) with ESMTP id 08ECD1C0002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:21:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776061289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=8i8mPauj/f/nJuhyMXnVTFcajYsPl5NLDtfrWoT0Kbc=;
	b=RQ1iZiiOLua+vJwtF+UHW/XB5GtI/Ie2syVYKWZWCQdMLlLluReGSMgNSLGCtRlb31RcFc
	PBvEgMPv0Du5iJFkwTy6tRTFvqXRt4eqWGzm6e4GZw7zXZ7DDjY0bdqSbdGU47PQUXlr1W
	nnvJrvZbYhJvxMc0s3MBAOWmqE9dzIE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776061289; a=rsa-sha256;
	cv=none;
	b=g4+mNb+bnBNTpAKG1wPn15o9amY3S1xp/7HEyeP8vVKJX6I6G66AVCnsKHKbYEjfnV5WzN
	9oPlMcO3sQfGjxE6g9dxGLFDblt89yXd2q+Hgfu/tIo9RPVcvRbMGr+mL/ABHtVcmCu6nd
	UJGXwa4LPIhnUDr9auvzXo3H0YZyamY=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4fvHNX68Ypz1YQpmD;
	Mon, 13 Apr 2026 14:21:16 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4fvHNW0JZ7z1YQpmD;
	Mon, 13 Apr 2026 14:21:15 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id F402830004D3;
	Mon, 13 Apr 2026 14:19:21 +0800 (CST)
Received: from SH-HV00110.Hygon.cn (172.19.26.208) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 13 Apr
 2026 14:21:13 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<muchun.song@linux.dev>, <osalvador@suse.de>,
	<linux-trace-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-parisc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>, Huang
 Shijie <huangsj@hygon.cn>
Subject: [PATCH 0/3] mm: split the file's i_mmap tree for NUMA
Date: Mon, 13 Apr 2026 14:20:39 +0800
Message-ID: <20260413062042.804-1-huangsj@hygon.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.26.208]
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Queue-Id: 08ECD1C0002
X-Stat-Signature: 5pq5w9xeymyrd7ytpteuc5k67kk9aaea
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776061287-45796
X-HE-Meta: U2FsdGVkX1+8+eekBeEr+Hs+t94saCow6Y2gocXtuIO9u3eI5i2J5ml0MFBWaWP8KokoTeHn0+6DvnJSI616fCYgBR9AwaCxBbVSkBZnddz+Iwd6xNIWvlA1asUAmHqd+ilfLV5f++DActWOsBet1d6UOXuaUQisZD2svLNwjMy4ZQAno6R0+z/43FdmTJtqB81r6HSMDTKnG8xq2Pp6cOPK91Iq3n0xs7QH7fZosufHGz611me4y+AbwjobM8fRSwWnfdT3MunPZP/JCDj/0sHeryEO7RwLJyLuMUZkSc3HTvyBr4iF4ZKTFsq8eRBkPbYIQ2Oj0afqkPTZd/zXEL2RA9ks49uydv6YohNz8Ma7n0YJOFtsBPG4B+sKt0j3CNdICXZNn+Dkb40t7IBCfzGjvtRpNGQ0bkqgmWh3lRu+Ip38ahJnMTucejI38qjZ9h6DQqw7GkuYnzKmCW8l41oep8dnpwB7fHTO3+RnelGg1rYkVrWAawQPvgjtWQ/q+0rukr0GJrwr9uHLwYPzHlYP0/zhhnzT/FbLU1UXRBEjnVUBHQhRQ7vqFulJW1m5SvwAeh1n48wj3HemRoQg6EaKudwTxS39g9b4TxCsIEKrxKHx+DOFYZIP9mnFUMwB/DH9gWqT0FqwPH/p5vCLThrUBuWatycGx3H7sCek8XpJHyZAY12FxSdQxnGWhuVixq9yHYSJqAOD2sfpnSq9GsAvisAy6dBUFUyOcuKlwq4/5xPirClTIW4toSKqlb12ayX+bSaBnq2DCKrcTv14KCj4cFy1zyjOrwa7j+7w0uAGz7qW008Jru1pE7uowbD8ghPvn7QkzESe8yaV5Fz04SbwTyKJ8DdLAgMZPPF8lztHkQUoLxzKZzwztmZhFhdVWeLuvn/y1ghWL0U9nn/r3zar8YnaGDDLjR0MOOZxcr+g7hBbc/w87crGzskLccWvKtE+xbbkuTGpP8AsgqG
 DYsSd+xz
 Jh027Tcyv2OaCr5Q99soaNoMS3qHgFsMrdanv81NZaSqFhf5se9/EG9BntfN8zl0CKhjRtC5D+KQCYJpohGywFuQ4To1NA6B7Lw5bmuh6DjYkstT2ifqygNBV8tfh43MDejgBNONAOtpRbV6SN7HGmDq9NeCYsFlE6Oj92AKeyTlctsjKv7hkEy0lujvAslYUTDU/bFVW6VRzKiCRHXXiZfiwgqNgwDaLG7SCJLcHTpylmDGpbjUvWt1hPf0LAYH76WGzc80OMZ+3snTtDbf8mRPLEeYOnk6UUR31iiYr6gZWuCr9dshIi9WzgtDKM2R3VOzcQ53I1RiL/u+QDXzi9MqWYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  In NUMA, there are maybe many NUMA nodes and many CPUs.
For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
In the UnixBench tests, there is a test "execl" which tests
the execve system call.

  When we test our server with "./Run -c 384 execl",
the test result is not good enough. The i_mmap locks contended heavily on
"libc.so" and "ld.so". For example, the i_mmap tree for "libc.so" can have 
over 6000 VMAs, all the VMAs can be in different NUMA mode.
The insert/remove operations do not run quickly enough.

patch 1 & patch 2 are try to hide the direct access of i_mmap.
patch 3 splits the i_mmap into sibling trees, and we can get better 
performance with this patch set:
    we can get 77% performance improvement(10 times average)


Huang Shijie (3):
  mm: use mapping_mapped to simplify the code
  mm: use get_i_mmap_root to access the file's i_mmap
  mm: split the file's i_mmap tree for NUMA

 arch/arm/mm/fault-armv.c   |  3 ++-
 arch/arm/mm/flush.c        |  3 ++-
 arch/nios2/mm/cacheflush.c |  3 ++-
 arch/parisc/kernel/cache.c |  4 ++-
 fs/dax.c                   |  3 ++-
 fs/hugetlbfs/inode.c       | 10 +++----
 fs/inode.c                 | 55 +++++++++++++++++++++++++++++++++++++-
 include/linux/fs.h         | 40 +++++++++++++++++++++++++++
 include/linux/mm.h         | 33 +++++++++++++++++++++++
 include/linux/mm_types.h   |  1 +
 kernel/events/uprobes.c    |  3 ++-
 mm/hugetlb.c               |  7 +++--
 mm/khugepaged.c            |  6 +++--
 mm/memory-failure.c        |  8 +++---
 mm/memory.c                |  8 +++---
 mm/mmap.c                  |  3 ++-
 mm/nommu.c                 | 11 +++++---
 mm/pagewalk.c              |  2 +-
 mm/rmap.c                  |  2 +-
 mm/vma.c                   | 36 +++++++++++++++++++------
 mm/vma_init.c              |  1 +
 21 files changed, 204 insertions(+), 38 deletions(-)

-- 
2.43.0



