Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80E94D3B7F3
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 01:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 484146B000D; Mon,  8 Dec 2025 20:41:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40B796B0007; Mon,  8 Dec 2025 20:41:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20FF66B000D; Mon,  8 Dec 2025 20:41:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B335F6B0008
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 20:41:18 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F56A1A038D
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:41:18 +0000 (UTC)
X-FDA: 84198229836.23.21E823E
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5655840006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:41:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765244476; a=rsa-sha256;
	cv=none;
	b=PDvXGdhQEolyWHGt3gZd8r+A009qejkt0GWa5x++21ueSaUQRNWgLAu9l9liHBKlLh1BQJ
	2rXF8p44NW/umh7GFmLcJecJadYF203OPahzTsWF4+OfwKiAJ/yN0xSrjIKUYiFD6tEOsT
	8Mw9zny+EVRioeVwJwjluj9CG/adnRs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765244476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=nuWSFiGr26F/TWf7FmiKa8j1DF8bIoei+CFZgycqF20=;
	b=F+Vh2otDVmhxzNFkM21ClbY7wNLpQzlJPgD/iDlRY8+bx1ti0sRNf9LlRgPznMjrKz7O3w
	OTIkoiu34PTNrbMy/97fEdX9BR9SbgD8dNPDwNcnpDPDJyYq6R0DmUaAgCbPDs1uSAf3HQ
	7mRugj9IvMbgHpw8qt1NljX9++z2PYY=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dQM4p03phzYQtjM
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:40:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id A78711A01A5
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:41:10 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP2 (Coremail) with SMTP id Syh0CgBnRlAafjdpkF9fBA--.23909S2;
	Tue, 09 Dec 2025 09:41:08 +0800 (CST)
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
	zhengqi.arch@bytedance.com
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huaweicloud.com,
	zhongjinji@honor.com
Subject: [PATCH -next 0/5] mm/mglru: remove memcg lru
Date: Tue,  9 Dec 2025 01:25:52 +0000
Message-Id: <20251209012557.1949239-1-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBnRlAafjdpkF9fBA--.23909S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tFW3Kr4rAF43Xr4rtw4rGrg_yoW8tFWxpF
	Z3ua47Kw4rCr47GFs7Ka4Uu34fZF4rAw47Wr1vg34fAr9IyFyqvr4xtw4rZFW8CrWSqry3
	Xr1q93W8XF4DAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjTRNJ5oDUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: jbrno9jszynxu7udr91psxpt478skbo8
X-Rspam-User: 
X-Rspamd-Queue-Id: 5655840006
X-Rspamd-Server: rspam01
X-HE-Tag: 1765244474-341048
X-HE-Meta: U2FsdGVkX1/epq9VYJ8LSzbS+fB/EAyxd7I7GGVp5WXSjY5hKZFR0WsXtWV+82nv/xHsOuLjGRiKRrDXYREo0RDc58C30LWqQfTPHrDRiWtNuebFEozFTkRV6GZGPCyJhDhv+wHu6kXfaNuYq3PAnSTsOf/nfEScV1KydTyJaTQoqiF0uuu8DH3uWsk2w5ilyOZUamQwz5Mvw403+ZdZ/58cddZh4o3cWsUZnswQQLsrCpOMX5GuP79YkwtK9PLd7dv6gddVLY+1iQL9wwETC0/gs1BxOJUwqwhKDLHjaNGqg9eZ8cL80WChAEUvwQM8N7fx4ip2S1BLPuw7/73C/INX99W/7ZEtWjXQgKNCmgbVCBk/V7MQC4+Rxv4iTZUIhRBUieQUYFwONsb6+0YEIg3gnmzshqa2lnbXYITBUP8xEtKtyuAMcoqu/02Yd6Ar6HE3vdTKDB5wFwelQ7SDjzjmFZkvjs+RWAdSFExNgSXWynmkHBaJ3x2dpiAmI/CBZMJwNMWxu6dIkYEHMc5zopVom77dQg2SmI8D4Qiwp2QwAadfrwnVX3iLj+WSZnD/o5oRFCo7EhMCHMIP1ftqC1tbOZ1yu8rxXLH7Ux8/L68Iz8nxFC3RllIznfMRvTi9f3crtZCR5ZICE6k4DADl6zT1cdUN680yyMEgLgNuNdzj/fpUOo4BSEbUtnN6OUX3x0VSN/CcP+KHen09JIGPwuXxSoA3Z/bB0dIeVWSQFRD7b1haee9abTYmEVjWFQDmM8/E4Fv11WgCJkfud8yzS5HRbm+s2Fy8xcrPVyXkM5zcyIT+vsbVYKq6cRkqVLKe4836cI677bDIxyin4f9vpBqwBIzOJZ9tpuOXDyl7li5sIit1BfZ5ZC9wW7JxnoOgXeoxqmKd6pWhsURk/5u2SwSW8T1zeAlKnY0dRODAVDpBUCpUPDNmg/NaDd5orTN0vKAmqkF8QrKPC7VT5be
 TyjnoZXH
 l0iQiHzYzS9T+oP3LZmUdsBFZTTrqmglgKpJN8Rsfy7fba49lfzlVV+WYBW7KMbw8WymY0GzbWfyzEHGbrV67Bvb1jCTcBfb/aRq1DVfJwxyqSEV1nzy8vVVOhIHRHdUG0Mb8djpWd+1G01/T64IzFa9Jw474k4uIVDioU125NaAfq4ecP1DaKDb47A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

The memcg LRU was introduced to improve scalability in global reclaim,
but its implementation has grown complex and can cause performance
regressions when creating many memory cgroups [1].

This series implements mem_cgroup_iter with a reclaim cookie in
shrink_many() for global reclaim, following the pattern already used in
shrink_node_memcgs(), an approach suggested by Johannes [1]. The new
design maintains good fairness across cgroups by preserving iteration
state between reclaim passes.

Testing was performed using the original stress test from Yu Zhao [2] on a
1 TB, 4-node NUMA system. The results show:

    pgsteal:
                                        memcg LRU    memcg iter
    stddev(pgsteal) / mean(pgsteal)     106.03%       93.20%
    sum(pgsteal) / sum(requested)        98.10%       99.28%
    
    workingset_refault_anon:
                                        memcg LRU    memcg iter
    stddev(refault) / mean(refault)     193.97%      134.67%
    sum(refault)                       1,963,229    2,027,567

The new implementation shows clear fairness improvements, reducing the
standard deviation relative to the mean by 12.8 percentage points for
pgsteal and bringing the pgsteal ratio closer to 100%. Refault counts
increased by 3.2% (from 1,963,229 to 2,027,567).

To simplify review:
1. Patch 1 uses mem_cgroup_iter with reclaim cookie in shrink_many()
2. Patch 2 removes the now-unused memcg LRU code
3. Patches 3–5 combine shrink_many and shrink_node_memcgs
   (This reorganization is clearer after switching to mem_cgroup_iter)

---

Changes from RFC series:
1. Updated the test result data.
2. Added patches 3–5 to combine shrink_many and shrink_node_memcgs.

RFC: https://lore.kernel.org/all/20251204123124.1822965-1-chenridong@huaweicloud.com/

Chen Ridong (5):
  mm/mglru: use mem_cgroup_iter for global reclaim
  mm/mglru: remove memcg lru
  mm/mglru: extend shrink_one for both lrugen and non-lrugen
  mm/mglru: combine shrink_many into shrink_node_memcgs
  mm/mglru: factor lrugen state out of shrink_lruvec

 Documentation/mm/multigen_lru.rst |  30 ---
 include/linux/mmzone.h            |  89 --------
 mm/memcontrol-v1.c                |   6 -
 mm/memcontrol.c                   |   4 -
 mm/mm_init.c                      |   1 -
 mm/vmscan.c                       | 332 ++++--------------------------
 6 files changed, 44 insertions(+), 418 deletions(-)

-- 
2.34.1


