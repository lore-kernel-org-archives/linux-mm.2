Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F0E7C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 03:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5DFA6B009E; Sun,  5 Jul 2026 23:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0EF56B009F; Sun,  5 Jul 2026 23:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFCC26B00A0; Sun,  5 Jul 2026 23:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1906B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 23:25:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD29514026E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 03:25:29 +0000 (UTC)
X-FDA: 84956911578.12.70109E2
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id 929CE180009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 03:25:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HMvSN6s8;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783308328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rfnZ/lC4Rb2GAMPajAZjxcZCPKg4CeTNBMYP2PQYiAY=;
	b=iQvMLeObFAe1aJFcFYBzhAgwQlOrQCNcKqeSsWwGjVhhin2e4388oQGKaEHkBAezay9tE6
	8qYgC4c/oyR93LiHhA1rAV1DEHJJT32Ww9XUilQOchdOfDPLIxxDcQp47Wj0F5ijA5z5Pr
	DjhuW27gCmODApAIf892PwdzinB4PNg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HMvSN6s8;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783308328;
	b=IkVSJx4FDClDIGN8KQsW4g/6CNGgd4cJcflnBXy9Oy3lrisgtNPO9U4ISmoRIwoKCa/Fyd
	SPRu1+kluY1wQDXEchvbxZ8gvFUYxVYACW73L0G3HMboK1v37wh7DtiRPwQvknEz8kcS7t
	fjlQ859+MIjzoGPMLnKWjBctw/Favu4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783308324; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=rfnZ/lC4Rb2GAMPajAZjxcZCPKg4CeTNBMYP2PQYiAY=;
	b=HMvSN6s8GFhZN1qSjS1rK/av6d2ENo8yrNsIt1OWAAISn7/WK+n/C5AztvCWDn01xSJTAsw20zBzmPK3esZgEXc5crmOYys1H8lE3EnCwFhrPU/3nTjYz3+na9HpU4K2zq9CHMG9cNCTErl9pnjQ+1M+vz36Ahgo8nC0JfbA8dM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X6PRHzq_1783308322;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6PRHzq_1783308322 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 06 Jul 2026 11:25:23 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	stable@vger.kernel.org
Cc: kasong@tencent.com,
	baohua@kernel.org,
	machao26@xiaomi.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.18.y] mm: shmem: fix potential livelock issue for shmem direct swapin
Date: Mon,  6 Jul 2026 11:25:13 +0800
Message-ID: <173f3fd983d735155d47e9e39d27f0c2d62a7c31.1783307463.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 929CE180009
X-Stat-Signature: fq8peapzctcrrk1azusg5uiiqepqnuhz
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783308326-458542
X-HE-Meta: U2FsdGVkX1+ORq4qWwLqwzjYttZ00NTsG/YncS/EDzaAf/yJcAr12AE1SF2iXJGmJY5ZfoIn4A1JDGrbGZh0ErgE4bGMx/X/15O96PPOnzG0vdRWQXwIfoYAy1vWFdWtqOL8LjRywpBXO65XLhovggitMayWSAfIlrCK7ZPo40MKUemnzFxbZ3psN8QznItA+fVhQDSBFRIoVGOcLGisHYb3BV6hcl9JCqmP5/rNOvxWF6uxEPs5LsNHq8SfpfeKqvpIR84IkzLnHzr5JR06/yXaBI/5j570E6BAkmPEWqQx0LzwaRI+5df5cceKkUa/oD8jmmRZw9fVoEw9LWpOl/o8eNhb9LPqaovZjdZo1PRTX+UCK3UN88Fcpe6MSQzZM6hnzfG/j3J+xCn2824qA+zsgk4XAyMVChPic6FSRoa3+4En87h+6lMxnvB3GDGe39rb8FNWMnH3A6yOkRaY6DyyUC6QylUOrm5HC0cpb95tlYsQsI5QKCF/1yENUjrDtXrPcc6LHisEo8a0LHp64j85MCH5FYtt1yFqpG5wCdAtLgns7d4D41CyaasXYcEsp5KYk5NGoSZMv2t8EjnXeOg4B85IUXkcHRcDLAu8K5lPJOdCLHeGxVpmlGfjwg8oslMisAdOFbv/XVYUXc6bIFtHftbKloaBAI0sUx/7Bgh45rVebvcNntbuCYX40rrz4LQPEZr+F5QrB8JTPr7GL8KFH/TPssybLvrOMUp5C8bQ983KRlhvFfZt2CgcYSbRQudKFRICsRdCQywrpqjv4zrB6ZZw/ApgOlm0u4v5Xp+UQh/IgMDvgqDXWnheSGMehAVIZAfwSN4vEqMGEzUsfguGjkkyHFQ42KfyGA806eIImOlNdZsO+mEyw5Gpr+JTEi6qShAkD3EfXlGk7I4IM9zA+L5vclE1UgW9FaWH/+9S9j+0sUAe+SpRRYK6q6QuChGanBAFnc9uGlzR9dv
 QCc7y++N
 90gs7tGb2FYEYf3LK7up7bSsg4kmL8UKeF95fiupvrMfukQc5sfL+D+S9sXEyzknVYUdMoTmqmujT6Rk3xm3dMSHFe9+zcCIcW76eJKuuATFhm2bIQRu0mDLhQT+PnEmcybX3iXp1Gfus1uAV2Rr5tLAmnIGXtxMlgeeriWS01u/ay9jyS1qjsVbJgbt+XcyxrU0to810CAID9woJXNcnzSOfwl/UHnRPaZdQn01c95vJYUetm3w7CRnk9zz0zqlfpkvWh7tdYanuKag+xkjjkxMBIhWMremA4JpmCaQDU+L2Ce3kKMMxHHsRF1aoDD9dHsZT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When skipping swapcache for synchronous IO swap devices, swapcache_prepare()
is used to prevent parallel swapin from proceeding with the swap cache flag.
However, on PREEMPT kernels this can lead to a livelock, as reported by Chao[1]:

Thread A starts direct swapin of a shmem folio and calls swapcache_prepare()
to set SWAP_HAS_CACHE. It may then be preempted inside workingset_refault().
Meanwhile, a higher priority thread B also attempts direct swapin of the same
shmem swap entry. Since swapcache_prepare() already marks the entry, thread B
repeatedly gets -EEXIST and busy-loops waiting for thread A to finish. But as
thread B runs at higher priority, thread A cannot preempt it, resulting in
starvation and a livelock.

Fix it by yielding the CPU with schedule_timeout_uninterruptible(1) when
swapcache_prepare() fails, following the same approach used in commits
029c4628b2eb ("mm: swap: get rid of livelock in swapin readahead") and
13ddaf26be32 ("mm/swap: fix race when skipping swapcache").

Note that mainline does not have this potential issue, which has already been
resolved by Kairui's swap refactoring work[2].

[1] https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiaomi.com/
[2] https://lore.kernel.org/all/20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com/
Fixes: 1dd44c0af4fa ("mm: shmem: skip swapcache for swapin of synchronous swap device")
Reported-by: Ma Chao <machao26@xiaomi.com>
Closes: https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiaomi.com/
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Hi Chao, could you try this patch to check if it fixes your issue? Thanks.
---
 mm/shmem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 94c5b0d78ac3..d4cb57b3b0ef 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2066,6 +2066,8 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 	if (swapcache_prepare(entry, nr_pages)) {
 		folio_put(new);
 		new = ERR_PTR(-EEXIST);
+		/* Relax a bit to prevent rapid repeated page faults */
+		schedule_timeout_uninterruptible(1);
 		/* Try smaller folio to avoid cache conflict */
 		goto fallback;
 	}
-- 
2.47.3


