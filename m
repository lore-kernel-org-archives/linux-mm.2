Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1AEDE7491E
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 07:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F26086B0095; Wed, 24 Dec 2025 02:45:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7AE86B008A; Wed, 24 Dec 2025 02:45:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C544E6B008A; Wed, 24 Dec 2025 02:45:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 776D96B008C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:45:44 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20DB81405FA
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:45:44 +0000 (UTC)
X-FDA: 84253580208.26.2236297
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id EF3D0C0007
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:45:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766562342; a=rsa-sha256;
	cv=none;
	b=7MwpszmrJav21+ecGQWyLrrCGmmb+tuwxxiylBShJ9ZhvpoQGQ1aIXypEKw3qH9d5D/poz
	YZQ+3Fnx87ab3K1CSOfdGh1+WEyVymbTWRvAEwpGNlVzcuLLsw0AefcT7O2n+Ptsm32512
	29p7MwnaQIpZZ0fPqtEjMalbREUbJfg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766562342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=cvqqe7Ff25RKx4wXu5yBCnTjKmDy9DTMJPBHY1cUKL8=;
	b=JcdSlG77cW2wzFsNGuWCtvDEfW916ZSCGNeaM4u1kRp/QqmbEuNy0I3kv1wlXJ2yJenWKY
	cCoHsFvzM7YFW47a6AWLs6vmr9mJl6sNvzf9DE0eROgGW7N0zt5bEo3ElesodSePiEbAr4
	xwD08+Z4D4US2A4MHwZ0iooHw15vgMI=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dbkSB6lzRzKHMMy
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 15:45:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6EDB940572
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 15:45:34 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgA3l_cMmktp9pcvBQ--.63051S2;
	Wed, 24 Dec 2025 15:45:33 +0800 (CST)
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
	zhengqi.arch@bytedance.com,
	mkoutny@suse.com
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huaweicloud.com
Subject: [PATCH -next v2 0/7] mm/mglru: remove memcg lru
Date: Wed, 24 Dec 2025 07:30:25 +0000
Message-Id: <20251224073032.161911-1-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3l_cMmktp9pcvBQ--.63051S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZw18JF4rXFyfKF48Xr48Crg_yoW5XF4xpF
	Z3Wasrtw4rAFWUXFs7K3W7u34fZa18Aw47WrZYg34fArs0y3WDZr4xtw4ruFW8CrWSqr17
	Xrn8C3W8XF4UAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EF3D0C0007
X-Stat-Signature: drtaeo5asbjuw9sfqkhcmje7trnupykx
X-Rspam-User: 
X-HE-Tag: 1766562339-161772
X-HE-Meta: U2FsdGVkX19Oah0XFIIL619wJ06JfYPAUSM/HtPCu9XLCjCYB5ZySpjtfD4JuO2RW7U5nX8zHmZVmWdraiqzdJvBjxjZCy1kS59hrqZ9w12/SpKuFElvuYTpMM9jqvNlOWv1Mvh40Azg2b4E7rgehJQbqHTwiHpuGf9SJD/nNe584/nXvdY7ywSxTsGvVRyK/s7tTCVLnV2TVcs4XQwGGTMpQsLHvotlOd2rdgq6jkm/PwqTcSSis+n/VGU99g9D7kzoW5kzLVe3UPI0dt3WguEHorP6nm45504NFAsHY2nkMRfr5maDf9IgADZhkXir57Ha/JdOwvB/th2TMtBibIucvzVSrmm5gqrGqk+vy5qRwrJRJqbP1VeOUZ74PdyfOzXKYqXZOPSnHcLsgsrEyYerhDSXAYfpcCuS6hulk6YNbfV6UYiqrDL6BRr4qWGnd6K5pdXoA/jyUpPThcQuyZG1Rj7myG3EMrOVflC5BFlJHHQ1jFjbzk5gWnUe3BOlYsqp+uj4oiHaxa6vWkqOOaUXtONcaB5HCpnhrGfIFPgKolQ7unfLUW7q9hY/TBGBoVmdYkQnA9432XS+/WPiVjf6gVQx3Wo8+cdH8pG9oPzkM8QWUXd+OC13W39pm2QSwJ4Ehui3mZqL+4+0q/sllqaOoiB4zHFSnFiTvkWpf9d4V3KXtSEGdRw3OThG7fHIXaTi0E3wlVWI4lWVMsk25mwfDSAL70ZK8f53X0+6HEmfzmPHULb9IRxOCQthRUVjfpFNXG5DKg7RgbXe9nuL6DGNJsN/7+qv2ONfxAUgTYebO8moYfX5PS55yUOE0a39lahWA9YRKLdFQgt1gVtNlqiqpFK8hziELYlYqZ9UlnSetWl2Iae68Xne2N4gjpc1R5GK7lxbqo9ReZfGhtIb7Zhn+kDHxySuVp1asilesIszB7GL7rcQSsomb9T4uEyqqOpIEww3OoKD66jLYrD
 piJabOP1
 tlBQw+o+hikUa6btrkrezE7ZleTD4wIrwPZCOnKFpQf5kof1DMPGBAa6MRHV8Wl81tAsPaIWAW4anlV8lL6rDNHZTm2Q5XDSQO4A5QWhilVYGiPuL8aNF9IlDvzNbi3Gbk9v154163Dv5pR93lJ/UNQtHzCVkbdXHI5FMipFJdHIFGdLpF8oPbZhNxUG+Rb/VHcnJkfzdkoA8FR3OWMhMSQycohBE3p0tsKu3+9jJUnFi8eM=
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
3. Patches 3–7 combine shrink_many and shrink_node_memcgs
   (This reorganization is clearer after switching to mem_cgroup_iter)

[1] https://lore.kernel.org/r/20251126171513.GC135004@cmpxchg.org
[2] https://lore.kernel.org/r/20221222041905.2431096-7-yuzhao@google.com

---

Changes in v2:
1. Patch 1 now aligns more closely with shrink_node_memcgs
2. Patch 3 separates the flush_reclaim_state() changes into its own patch
3. Incorporated feedback/suggestions from Johannes and Shakeel.

Changes from RFC series:
1. Updated the test result data.
2. Added patches 3–5 to combine shrink_many and shrink_node_memcgs.

Chen Ridong (7):
  mm/mglru: use mem_cgroup_iter for global reclaim
  mm/mglru: remove memcg lru
  mm/mglru: make calls to flush_reclaim_state() similar for MGLRU and
    non-MGLRU
  mm/mglru: rename should_abort_scan to lru_gen_should_abort_scan
  mm/mglru: extend lru_gen_shrink_lruvec to support root reclaim
  mm/mglru: combine shrink_many into shrink_node_memcgs
  mm/mglru: remove memcg disable handling from lru_gen_shrink_node

 Documentation/mm/multigen_lru.rst |  30 ---
 include/linux/mmzone.h            |  89 ---------
 mm/memcontrol-v1.c                |   6 -
 mm/memcontrol.c                   |   4 -
 mm/mm_init.c                      |   1 -
 mm/vmscan.c                       | 313 +++---------------------------
 6 files changed, 31 insertions(+), 412 deletions(-)

-- 
2.34.1


