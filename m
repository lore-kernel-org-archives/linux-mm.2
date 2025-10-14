Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AF69CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 08:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A76178E00C9; Tue, 14 Oct 2025 04:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FFA68E0005; Tue, 14 Oct 2025 04:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7228E00C9; Tue, 14 Oct 2025 04:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 70D2A8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:19:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23F061DF042
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:19:05 +0000 (UTC)
X-FDA: 83996019450.21.01E09DD
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4255EA0004
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:19:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FkHSsady;
	spf=pass (imf15.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760429943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5OeyEYLseuiwt3LveByP/Aul19aE1+Npt1dW+qDVh4s=;
	b=D+VS4jLHkq/z8LtOlyHmExZS1RE0cNpm0gBTCXzGAQGajXuSrFfFPhDKazY945GYrLbXQa
	xEw81/qwkzmdDxat1Sk7bIKrFmofT6MmiRKrY8kxCcahz+NztalKe++JkLgxGeNUEVhelP
	YyxuPN9pkiILUKtAFc7MG6/B9RunUuI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760429943; a=rsa-sha256;
	cv=none;
	b=7WkoL3m9Zjdt2ESPp4IzjjxpZ1H553sshFk9t+UbaYStX+esoXOymg/C1NkUq0g5cN/p4d
	CeJesRaPcq+N3yGH1bvLlKHQdqqoBks3AoCqBQbIbNWcfRwtLKnnJtun4WHY4wVFfabKtN
	apneCAeIZ4Vtmyqcu2/0gsT6xnPZeqQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FkHSsady;
	spf=pass (imf15.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760429941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5OeyEYLseuiwt3LveByP/Aul19aE1+Npt1dW+qDVh4s=;
	b=FkHSsadyvJojzqrbq8TTDnPtANwM1U4aJvbeB8PGG7xSL1OG+S10cFC3JQ/I+4CPU1b4dj
	fMCiIHrDn1lhOe4rn/ZvqM3aMM+MT+LfhiyhRc16/SmQrP6ICeEzV70wfXAbWYC/TJ9Jk3
	pz+a6RoB7tLMgqx6ViN4sYT/hqSDRs0=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1] mm/vmscan: Add retry logic for cgroups with memory.low in kswapd
Date: Tue, 14 Oct 2025 16:18:49 +0800
Message-ID: <20251014081850.65379-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: 9ufyxbuzkc7wbjxotm83ja64fkkewnwy
X-Rspam-User: 
X-Rspamd-Queue-Id: 4255EA0004
X-HE-Tag: 1760429943-393535
X-HE-Meta: U2FsdGVkX1+MmyqbYEL8/dFdoLB8CQPpT982YGvgGi2aQtN3+kGSn8Vex98LEpsq6jG+GWeRafLFKcy5KfxAs290DkNd0gJ49utrxUcLlm4bfGGOKKan5At6ggKk4VrIDl4OgZGwV/TWZiaEekyVM2WvQ8xsJXqfgFkmKxKijySxN/OxSXkXeIrbPwDATDIKnn+eHb9jXCGtBMq6rT5zowHxWeOJNmx8nM7Mq2BOM2pc+Gog+C2WqhvKUB1KQ1Ql7XZarNMik/e/BzCQXxXuYrFwWetT2y3BM5++2CqkTeSirwf2Uy6BeFz5WcQTa1ESB1Il6ZZCS1X64bEykfpeGoZ89aihm6kCHYx2cUMBOlc5aaeGQdN3Bo7ex3RYmqaWpP8ZHwd/k+ObBWX4C2FGyk517oScF4MK9rLl6whs+IdoDa13EzoXrqPTsUKvVpupe4kMqSK8P4yHpHpt9IizqSRGG9uPQvtQns+aogcFeNBTfF+/rA/MGDd7Kcz2Bg39DvKq0bJN8WQCrNChnzXC3NZjiQN3qyB6eiMkVLDryJ9PvyGja4YK9yuKNszGR56AdZ+Qdm68iWO216ZiGyEk+TA15+iUl/GL3RZlDfUo6cMdfoiMvEzIwb14xvlLwcdueRwZM68lYa3Aau72KI48cNzOf3R81vf8H7pd+IFdsR2wr0+B03/FP3G7sHkSwquS1iEsxJs3jJlD/LYJitn24WGSX2rQcWDiPiWrKG+JCN7+zfusoxrJwaUReITIkPQ5deQLmbRV4MnkzzY1frN3SwVcCPGFanfzGaseeWA7kG6v4uzvvt9cGgruCgoQNEieDF3UxyH34zoWsn1yfjV5LH2ulKzhsEwV+eHwmqw6sPqs0INbcufe9tjWbSjjTdA1LrT3KAw75gB30YFEtRoOT1j50EHSxGxOfftq06M0kjBMU4cLrq6L0nIeOOo8k8+p5LRttC77e0p0iKIaaeo
 49XAdbeN
 E1OGKXMVEn1QA3l/eLfkOI4s8kGQwH0fgLFKl8dNRltWAiDLa27pzNBnwdoYuPhxYnJW2yCpCucUsjqE4xR8l+GK8KewPj5SXcZ7lcA7XqQhiJDh9+B5ekYh/O34Xf5NOwCQB5gYH9k9WVS9v+eqlAg6F8HbUsdQD/3zK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We can set memory.low for cgroups as a soft protection limit. When the
kernel cannot reclaim any pages from other cgroups, it retries reclaim
while ignoring the memory.low protection of the skipped cgroups.

Currently, this retry logic only works in direct reclaim path, but is
missing in the kswapd asynchronous reclaim. Typically, a cgroup may
contain some cold pages that could be reclaimed even when memory.low is
set.

This change adds retry logic to kswapd: if the first reclaim attempt fails
to reclaim any pages and some cgroups were skipped due to memory.low
protection, kswapd will perform a second reclaim pass ignoring memory.low
restrictions.

This ensures more consistent reclaim behavior between direct reclaim and
kswapd. By allowing kswapd to reclaim more proactively from protected
cgroups under global memory pressure, this optimization can help reduce
the occurrence of direct reclaim, which is more disruptive to application
performance.

Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
 mm/vmscan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c80fcae7f2a1..231c66fcdfd8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7147,6 +7147,13 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 		goto restart;
 	}
 
+	/* Restart if we skipped the memory low event */
+	if (sc.memcg_low_skipped && !sc.memcg_low_reclaim &&
+	    sc.priority < 1) {
+		sc.memcg_low_reclaim = 1;
+		goto restart;
+	}
+
 	if (!sc.nr_reclaimed)
 		atomic_inc(&pgdat->kswapd_failures);
 
-- 
2.43.0


