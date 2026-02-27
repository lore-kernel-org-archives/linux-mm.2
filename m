Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40EFFFD9E2D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 02:57:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5392A6B008A; Thu, 26 Feb 2026 21:57:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 520F16B0093; Thu, 26 Feb 2026 21:57:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ADC46B0092; Thu, 26 Feb 2026 21:57:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA36C6B008A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:57:24 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC515B99D1
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:57:24 +0000 (UTC)
X-FDA: 84488725608.02.C907427
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id 62EFB120007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:57:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of yebin@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yebin@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772161042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=e4WzCN7hvfyAaB2K76RFcJjIeM52ExTFhHzhfS/2O7M=;
	b=vwb5KATidQ+exyM7wiVUkYwS93+xD0Ihgja1/6miRMDdwnm89RGphMLYrj2DyprLKtCZJx
	6VGWgOekzRPhr8TLyt1Rl3R2+H50RcFw5E8X45D9wIulJ32WDEVhIl4A06eUq591/ftBQg
	oa7IF8Ew9j/d4teLe3AuPcJPu+me5ZU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of yebin@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yebin@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772161042; a=rsa-sha256;
	cv=none;
	b=wKqyc8oRFYTWtvKC+zRhylMjaUbrJhqlvte9aAspOIApOS4U/EmUpyo3PgADy5DUj9K5L/
	fR7dXtRlYdPk3tWpSqVCOowrpabgTR4r1v4lLqM6f+svWU9bEkoZD+IVRcArVE47LXJHRp
	QCO+QDL9x7sRVkeAhEYdx1EE2XOI5us=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fMXym4nb9zKHMMt
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:56:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E25AE4058C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:57:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgBXuPgJCKFpsEGdIw--.32070S4;
	Fri, 27 Feb 2026 10:57:13 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@fromorbit.com,
	zhengqi.arch@bytedance.com,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	yebin10@huawei.com
Subject: [PATCH v3 0/3] add support for drop_caches for individual filesystem
Date: Fri, 27 Feb 2026 10:55:45 +0800
Message-Id: <20260227025548.2252380-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXuPgJCKFpsEGdIw--.32070S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw1fCF4UKw4kJr4xZw1xGrg_yoW8Cr1xpa
	9ruw15Kr4rAF1fGr93Aw48Z3WFvw4kua17t3ZxWw1FyrnxAFyIvrnI93y5XFyDZrW7uw4q
	v3WDtr1Yg34DZw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
	0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWU
	tVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
	CY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAF
	wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
	7IUbmii3UUUUU==
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 62EFB120007
X-Stat-Signature: 3s4ia5twx4arrx8by7uq5cqwygkuju7h
X-Rspam-User: 
X-HE-Tag: 1772161040-932620
X-HE-Meta: U2FsdGVkX18atnz9J9PLCD8NjYfUS6YYC4+cZMMNC25atgDGbNPakrFKrlxHlNgkM4E1sGoWVzPFiyEYzyufwMgT4OKk0S1kO/95iWc8WGK7/bW0SgXCWYlPBgeinbcUWdfeBD3hvGC/XtgaHWmAhAQ65c7z/xIlfOZyRvGf0AxT5i/Br+0FzDie1mbdTiRICd4YfvKuHWNaFwg1/On6yWLiMyzDPwmvDL0YaNNMdlLk3Ljj42yhlw1d8eFTa/E7yu/hBknFIEecN4WxcozcH9XXEcvopOzjgJW8mGdIgqpYjBySm8AzB17ecu1lQJHLmXxVL0VA94Yeq2FQtf5E63V6A9MZeD/SDlK2dWjWdKct2yGTrzF5ryNoGoJKNSvCzwr3yWbbLBM8B12VqGivr6mAmLQDyYxzoAJ4bW1XvU4eB3kvbkWR1qCsecfg4/0u7mbD2YmqAeyb3lMsqKsiSoiIY9rLIdquHo/ds7cqJX51suPbMW2r+KynAO47JdVawEdPLxQ6ikvweoCs3G9eZYOnUs82EfNSCw/U4rfhOJ+WiS9z2iMHM6dlEbKy5L2HwKh7Dajpf3dQRrYAE5IWtN+2Em73RJN7bWUgRYnZQVAObY6fD+guIf8l3LF0Ha4FwxgB/EwoHl2SlNFZVG89Oi2wNgKh2KsZho8fYRylYvW+5EUvGt2B8Z0+qrKuQthmirzhE+f2sJOdwBg8LQnDwVdYmK2hQAQs71TwuSokAEb11Ser59rZ1paTkELHdie6SM7r20kvKcUPhtgFsp/OH6Y1L8eD8e2Cd8KPzzohYPUK3aT4mfLwa7zj8yHyK8G7eP/7Tr5rlEnr7DAkNMV/G6DOPT7OOlS7Vls7Axz7+2w2vUREWTDN5sjoKo7kuI4VaVgmKF4DGbIOt1VVnKPP719R5hIfQvEHUWkePO5c3A71MlB8zGKTOL2rW0+VCZxJ17YeImiT2DLVpsHDXHU
 2uaAnfPv
 ReS83L9L5MK6UeGWjV8An9cxhUbPZc4ePmIYO9KdXuT6furKqNhKXovrfJ6190r/eBne2cDIk00Sj/TpQRSh/EfihD67LTU//Ca7hSTGaHmEjAAcRMuV+40V6VQU9rrFPC8CvAweOj64P//F5uzcBzFSS6scaP5rmeHkQYwfnwBHogYlDEAtX+mc4GzL6xrf/8AQ7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Bin <yebin10@huawei.com>

In order to better analyze the issue of file system uninstallation caused
by kernel module opening files, it is necessary to perform dentry recycling
on a single file system. But now, apart from global dentry recycling, it is
not supported to do dentry recycling on a single file system separately.
This feature has usage scenarios in problem localization scenarios.At the
same time, it also provides users with a slightly fine-grained
pagecache/entry recycling mechanism.
This patchset supports the recycling of pagecache/entry for individual file
systems.

Diff v3 vs v2
1. Introduce introduce drop_sb_dentry_inode() helper instead of
reclaim_dcache_sb()/reclaim_icache_sb() helper for reclaim dentry/inode.
2. Fixing compilation issues in specific architectures and configurations.

Diff v2 vs v1:
1. Fix possible live lock for shrink_icache_sb().
2. Introduce reclaim_dcache_sb() for reclaim dentry.
3. Fix potential deadlocks as follows:
https://lore.kernel.org/linux-fsdevel/00000000000098f75506153551a1@google.com/
After some consideration, it was decided that this feature would primarily
be used for debugging purposes. Instead of adding a new IOCTL command, the
task_work mechanism was employed to address potential deadlock issues.

Ye Bin (3):
  mm/vmscan: introduce drop_sb_dentry_inode() helper
  sysctl: add support for drop_caches for individual filesystem
  Documentation: add instructions for using 'drop_fs_caches sysctl'
    sysctl

 Documentation/admin-guide/sysctl/vm.rst |  44 +++++++++
 fs/drop_caches.c                        | 125 ++++++++++++++++++++++++
 include/linux/mm.h                      |   1 +
 mm/internal.h                           |   3 +
 mm/shrinker.c                           |   4 +-
 mm/vmscan.c                             |  50 ++++++++++
 6 files changed, 225 insertions(+), 2 deletions(-)

-- 
2.34.1


