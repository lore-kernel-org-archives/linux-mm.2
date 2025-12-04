Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B310D1F9D8
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 12:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 981656B002A; Thu,  4 Dec 2025 07:46:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8186E6B002E; Thu,  4 Dec 2025 07:46:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6430F6B002D; Thu,  4 Dec 2025 07:46:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 474376B002C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 07:46:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E55F5C013B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:46:48 +0000 (UTC)
X-FDA: 84181762896.30.4988E16
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2516FC0002
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:46:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764852407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=iHyMdqt2o9e90HhI7SLEUTXZ4WM6G4Zc12NhJKcwRps=;
	b=31k3mlHzyd4ay2pHxaibsc7LsWBUIbelf47y9XGFWJvVOC5hlvlB0e4aefKT7DDhylR580
	RdDWnCNv/lLr6SES+OBeHOzJPqHjKTv5DXm3CZFHj7GO7yAWNTVfcnmsOvGSKZmpiB4Nck
	j7YUnn5VmIecSU2keqscORRtOvrT3Z0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764852407; a=rsa-sha256;
	cv=none;
	b=zxFFAbNw1+F1btL54C7wPJ/FLVF6PxcGzMTtvNF0jy6TXCp0IDlhshh+Q/J40hY4RCIuoA
	irjuP3XBbAQMZ/qb9kVJq3mHkJgs2YSeGEw6Dd1+FLVRDZ5aIdaT8Xva4m7Eg15zUOn/9B
	k01kh8yVJEJt//RXeNyPm0CHd8pCaKs=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dMZ553hsXzYQthk
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:46:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 8AB221A07BD
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:46:38 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP2 (Coremail) with SMTP id Syh0CgB3VlCRgjFp+BRLAg--.31494S2;
	Thu, 04 Dec 2025 20:46:34 +0800 (CST)
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
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	yuzhao@google.com,
	zhengqi.arch@bytedance.com
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huawei.com
Subject: [RFC PATCH -next 0/2]  mm/mglru: remove memcg lru
Date: Thu,  4 Dec 2025 12:31:22 +0000
Message-Id: <20251204123124.1822965-1-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgB3VlCRgjFp+BRLAg--.31494S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tFWfXw4xCw18Wr4DXr4rGrg_yoW8Aw43pF
	Z3Cay2qw1rJ34xGFs7K3WI934xZa4rGr47XryFgw1xAwsIyFn0vryIkr4rWFWUCryrtF43
	Xrn0y3W8XryUAw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
	0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8
	ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
	CY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAF
	wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
	7IU07PEDUUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2516FC0002
X-Stat-Signature: ffphd14kf6j14jmj3ucs9qmz6j1jgbmh
X-Rspam-User: 
X-HE-Tag: 1764852403-743458
X-HE-Meta: U2FsdGVkX1/ogtXYcn1OQ8GznWWla07haSf7odfShOlIc0vIyXJdjYY01dkZszQ1oI3Ciyh/TyRurtgRM00NfqNMYIH6QpIPCIrWJPitB1XJgNbL0KnE97LFFf3XpGWY6zDFAhnmMUXc6UvSiar5B5Vub76odvFJOf+ZCJHt3AIQ18t8zLwoVeFJA2I1zdc59nNg9r8NExi8vN6ZKTUFdMg66ilQaZAORWTAjrGhesmAVeaDeZ96W29JKBUWbHxf44FUGp75GJHuC3uBebw90Bx7+Lw9ASdKviEMSsYxRxDXzfJN2OdqMrh1lgSrtpbkNmcS8cHZT+Xt11gjj3EkIhoZcvi4xZwi5hA20WxzjbO8xUI2O94sZlbPUuc8TzXpy/pmeKO5JVKhVsndNImD1RXm1AT/k+Y0eQDkl6aFil2HeUPGnCpL6UcqgtvQOnmSfuQ/5HxcMaojgl+Y2c3Fe+buLjiyY5Pg8LFaUcHF7hu4U03Yzr+gOJzksMn0qxUcLj8yq0BUXJ8EDsV0/2GhrdOCqUJ4xLABH1866uJPcqivPJPj8+3yESItCCjnuRkYvzCi8annei3zBkhBOxlBUUQ2KToGUL20QlsiSdHMTqOw4UQuDNetqbf9SjzIm7zV9Avnmg+cAcpE5l94V8bMK9E9hX4xnPjHHroDLC2kk+qYVdfQAZ0L+WXNxY/AcqP1tDriZYV1TKwfiM8RbLMshy5dqWkgpmBMmCFHmOHg0mtvd+/Tt39D1qaZAOZSV6m8qP3dx67RWQfQr3zAHb1farF4NAbAep5ipDZmAg89sv2L0SmCPwmQ5kWLeJLMuGMfVIF/I8lFf0d65qxtbMh62sdUiJJmhAaE1pNg/O3p1jmg5H44kkWWfZRDJobrB/pJen4dkxUytVnRJ5pBfgo9nkPWAW7xOr2QRN4EsYB1hLvhO5ilP1e9TITY0KVtpHKXUscWotg+anH2qtOvYxw
 QYzjdpOA
 debYHqh/sSQ44BG+WdKmAnOp2NTR4+nemKpTDhWzK9sWObcl5dAUi33WM9vTH8kFGBwKLP2NxDFwOT9FcEtnyBgOSJRgIWy1Klk01OjLf5sT2r07DvyZdeOZv+prmRkNsYzrZ3cPnqEGA0qHuAD9roZLaDlxtMiF99+hCYE2inZYZHAEUXwoYDnruXZY9QggJF+CZLN5miaLUIjU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

The memcg LRU was introduced for global reclaim to improve scalability,
but its implementation has grown complex. Moreover, it can cause
performance regressions when creating a large number of memory cgroups [1].

This series implements mem_cgroup_iter with a reclaim cookie in
shrink_many() for global reclaim, following the pattern already established
in shrink_node_memcgs(), an approach suggested by Johannes [1]. The new
approach provides good fairness across cgroups by preserving iteration
state between reclaim passes.

Testing was performed using the original stress test from Zhao Yu [2] on a
1 TB, 4-node NUMA system. The results show:

                                            before         after
    stddev(pgsteal) / mean(pgsteal)            91.2%         75.7%
    sum(pgsteal) / sum(requested)             216.4%        230.5%

The new implementation reduces the standard deviation relative to the mean
by 15.5 percentage points, indicating improved fairness in memory reclaim
distribution. The total pages reclaimed increased from 85,086,871 to
90,633,890 (6.5% increase), resulting in a higher ratio of actual to
requested reclaim.

To simplify review:
- Patch 1 uses mem_cgroup_iter with reclaim cookie in shrink_many()
- Patch 2 removes the now-unused memcg LRU code

[1] https://lore.kernel.org/r/20251126171513.GC135004@cmpxchg.org
[2] https://lore.kernel.org/r/20221222041905.2431096-7-yuzhao@google.com

Chen Ridong (2):
  mm/mglru: use mem_cgroup_iter for global reclaim
  mm/mglru: remove memcg lru

 Documentation/mm/multigen_lru.rst |  30 ----
 include/linux/mmzone.h            |  89 ----------
 mm/memcontrol-v1.c                |   6 -
 mm/memcontrol.c                   |   4 -
 mm/mm_init.c                      |   1 -
 mm/vmscan.c                       | 270 ++++--------------------------
 6 files changed, 37 insertions(+), 363 deletions(-)

-- 
2.34.1


