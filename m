Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4B8AC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 07:10:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4866B0096; Thu,  6 Aug 2026 03:10:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B94036B0098; Thu,  6 Aug 2026 03:10:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA9AF6B0099; Thu,  6 Aug 2026 03:10:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA476B0096
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:10:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 249B21A0683
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:10:23 +0000 (UTC)
X-FDA: 85069971126.26.A18992E
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 57FB640004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:10:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r8uEaDtz;
	spf=pass (imf11.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786000221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NholKuWtQvEG00t+vpLZ7cw0VYR49OMbVtszbQdNqzA=;
	b=XFg8c7CnPmosmhdgMicCiI5b7H2i5zh0qtdXGc76CeNcnaeb5TZdl5gmxJkJfwzRXxND4/
	I5ktovMFipn5jx8dIvbqY8O4a5a5K8GtAJ0lGYsp+phAsS3osgBm5Ti7BCQGRijiKvQSGF
	X2rlJe4gXso4uImUATDCdLHhTn5EYbk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786000221;
	b=VGnAm3ITgkonFfqDPmVmmA+w/csVkx5S+vqRe93MzufwXDCEPOW7TgncX17/vnUUSAYH/L
	2eDZ6fsSbOW6zQoOjl/NfGF9HPUd2mOoPtFiFi0E34u21AiBo3J01MibYSFQV6IFTCWbTM
	ZQDMG0zIvMtvo5w6CLrAGG/zusSoEGM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r8uEaDtz;
	spf=pass (imf11.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-84eb992a881so1712608b3a.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 00:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786000220; x=1786605020; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NholKuWtQvEG00t+vpLZ7cw0VYR49OMbVtszbQdNqzA=;
        b=r8uEaDtz/1B1R/KkfjNA6Loit4/OxM9eJXAvgIU13+KN93ZyFVS3TIXRG+gdkET48M
         OOWWnvp3CoGj0X9qbQEx+hMOBQPCIxyNYR8YCYqNM2XWiW+qOqE8AzcXwZ4YCuu40lRF
         y5S1UKArPf3X3XP8Ohn1gIqGc6OTvpyBBfBYRygI6t2DpM8PUJn+sjJbVBgiAvOO3bIE
         pbD8d0eigYUD1aL5Wf1Y6r+tZfBrokwmHD3dHnaT0rfZ7PDRpkgE3v75sVlH+mqgcgaH
         k3V3Yez7BOA3cVE+08FcVENmhD/m0BWmAcK5aywbtHLh7Y4ooG70Vw66soTct2Z98eB1
         ED5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786000220; x=1786605020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NholKuWtQvEG00t+vpLZ7cw0VYR49OMbVtszbQdNqzA=;
        b=nsPeifso3fjMK9WIJ/HwbfOULrngo1nc/04UwyJCHOf8KN/+g+gDRHQBIVFrlePi4j
         +zcHfCLkvrOBiOl7ZEYH9nPqQI9qoBtv9H1ayP6izKu2Ag/VKbrRNOv6CqmpjK3sNSjR
         EJiqFpCnpbh2UnGYXqFOB98GJuX+pua5quz7038yG7ptxG6Irmo1MPRzeg+5sVLCJNZO
         XLmQ6XqpOs5rpuhAq/ZwQDKIV1EL7DcCnAoCqlpu2ul3sxvwZGpi9hF+WL1Zq7+ErQT2
         JT0JzRqrN7mMMRKTrWj7StsXQep7GG3KYwrTLA1e2yVj5bvcxwsoCmX/XEFCWGbjh+ln
         juMg==
X-Gm-Message-State: AOJu0YyrKgWkKSwCWRjfH6Wp4qEaU5cZ4FJIuWgFqz0aiFJM9j4zgoQ/
	jdjj6Ffymix5ar9CYzSnCBCmaTyci/EDDSgWQqAbyppZYlAnO2lKxrds
X-Gm-Gg: AR+sD13uyD3SboKSs+X6vysMEBxcCx4hmY/OmM8mPt+bchQ42lec78c4PulJm18id0r
	2LPsfmZup612cupKdAUSxeErhUabjyvJiH6EgWooXNwKHyOVOnUpw+y+ElZ8TTwDZutDHWaAINR
	ACIuMsQucDoJ2mDdE+ColEUxfbebeS7xzdv2eoIhd7aErOcgdfxLS5kg2xHqPWpSQK/5nJfdvz/
	TL92Yc8y/1ljbL/ZtEmTTEFicOoZS0YlXNwLQ0Suw03FRR47+frOWdgoMFJcos+7U1xx0Z1opYN
	2Lq6FOgBtQAWnoXt2bOa9gopUW6zn7WWbXYTQO23Ko+Tg7MfTenEtEO1mYgk0Ic/kgtIu+hV1kX
	qI9nI579sJLsWBJ/B+boieGOXFt9rD7uKvwJUYEtFh/1ZJQR93qacWsBWePpIDdJZfC44/sbiQ9
	Ntk0SDkgy+5aWBdQePFoWw9XNPyAR6AgCIoq3KzGMr8V4qq4DudggqEnClCX6r0AEHn2WrKLh+L
	VfKCxJfNr8F6+CLv/skKqsdA5M=
X-Received: by 2002:a05:6a00:2e1a:b0:848:42a7:1854 with SMTP id d2e1a72fcca58-84f2e0c9c90mr13382273b3a.39.1786000219033;
        Thu, 06 Aug 2026 00:10:19 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f45bc9cffsm760154b3a.59.2026.08.06.00.10.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 06 Aug 2026 00:10:18 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH v4 2/2] mm/zswap: Support batch writeback in shrink_memcg()
Date: Thu,  6 Aug 2026 15:09:43 +0800
Message-Id: <20260806070943.95542-3-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260806070943.95542-1-jiahao.kernel@gmail.com>
References: <20260806070943.95542-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 57FB640004
X-Rspam-User: 
X-Stat-Signature: izd76hja6bbwhdbmnrqpe8o6dmakhphi
X-HE-Tag: 1786000221-808771
X-HE-Meta: U2FsdGVkX1/euxmQqqoaDTaUrDo9INcRS1zqVu8MTpa7ULlYdixz5F+jjTkMVpWgym799RrwR+qbdCJieuAPLIQmOqI8AVDeXZB+f64nAjGHsy1xIb9HTJaHjdIRYUNGWA2CVES9CHdEI4KRUj+xsZM/VN5a/Uuf5Mj3Ep5jDJsx83Usa6NTDOe30TzY25GlVWrp6FrywE3Ht7JVUnekMpgqCsW8Z87lpGS7aDe++UsW97au3yQr8KL9/YdvRq0FA+plSJE54bJeFLMQLamiRXW7ScNCyyrb08lhzlInm5ymIyGBm2oJD8WTuLlRsO6sUQglOetl8SO8t/C1U4Rzzl33BrY5/vBCiaEZSx3tCzhejiTqZpYOa37xm6CeXomK2iG24C0SsYFLwey6KOwRBoGRlgcqihG7qPOOSMEgeSJCtQRg43s4vZRVDfIon/dVG6W2A8gAlQmqO/6zJVMjaxDNartZYB3WAEUzxFZDLxRN3WfnhVIcyzJp3eE3kDc0m62U+IgCV9UGtpln1xizfi0SevBwQChcoLjjNSEDWgBw+1RWXFhhzQiZ1cFdq3iZKCTyg8dbszwrIP+KuyD2bxvlNRyuShLO8635Obr0OUmsV9X0HDtG3uS5+mfMlYhzBMYB0StjbZMUFGvimLv8EkgG5OjXTE+pgxBLkkLBk0V4YAg1oLs3jaidTeK0ozjoArmq3NJpXQEa7u32uTz6vUD+xQgeaJhSR8DFxwupBmMuGXRwoe5bmjL95Lj29JH46KBoJoFZynIorrh0FnP+dXA+mGrPTL7vzBkx0OzL7YZVBkygmhBwlFTdWlo6WQsPM+RCLOr6yhdDtT8ha3DXMAbxjyCgRy1Se+kuRHjQkygH+mWLd4dSiVIsfL6bSboDBJ3UgTVdQylRuFVOOnV1rzlwUQj/FL4JHJpxIriSfmy5tcFoFyhJL9zbyN8UV2KDD/VDgjM8r9J234bfMsr
 HFeajSM6
 j5XurDo/0CqJIRYPm5WhgsBUS1dr5/3t4Rjc+tK8ckSiVu5n4QwIte/c/KNPyz8tva+TwPa37SJav8rEynYSLxgMl6jOfdrEC9HLLXxm79ecEeBcN0WvbOghKpQZ3a9r6yO1YkGmpApiykNGFRqz4a5bs7xe/ijyiSXKlDpS185faxe7GipvcVfzsSbuEgu6gZUpjAUVY664oLhCgdEIyEb7ThjysXC2pEsVYgHKMjYQZhmnTu3GXJDZLZPyJkFbxigNFPmZuL8ZBMfnXEkqZgR09NLDyt+m4MAkIdBOsbHoC7zTrt5ooZcb98UAjYECJR2EcCGIOlPpeBV5OepLQZqFmkM3lgGyXYBf7X5iRwHo5NCu2+ayYV0XbddNVwypyIbrznANZ62rpLDfEI+0LbuLSztR6pPcFmtUlYFfOn3VTcbEBE9Hfdl96Orod2ErWpwOKtHYbd0EuLYtd1k9hp5gllCbXlrRdTYAcyj4Gzp2drZrxUcvAmJBYNDUn60/NBHg1HGwLIZN6DfhOPIoGM/NtlscG6kPOzWI1cvvDPEwbKKs9vBuiEIuUE3EF8TuxP0DoP7e4j5TeNaS4bfC6S9A20F6XR/3c/4NsxqIHmdcPwqxDbUOWtEL/vnjTntCVId1JbVFOYP+87a0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

Currently, shrink_memcg() writes back at most one entry per-node during
its traversal. This makes shrink_worker() inefficient, as it must
repeatedly re-enter shrink_memcg() to make any substantial progress.
Under high memory pressure, this can cause the writeback speed to be
too slow to keep up with refaults, leading to zswap store failures and
forcing pages to skip zswap and go directly to disk, which results in
an LRU inversion.

To address this, extend the per-node scan budget in shrink_memcg() from a
single entry to up to SWAP_CLUSTER_MAX pages, enabling batch writeback for
both the shrink_worker() and zswap_store() paths.

Test Setup:
- Total memory: 32 GB, 1 NUMA node.
- zswap settings: accept_threshold_percent=50, shrinker_enabled=N.

Test Case 1:
Set max_pool_percent=1, allocate 512MB of anonymous pages, and fill them
with random data (to avoid compression). Then, use cgroup memory.reclaim
to force a large amount of anonymous pages into zswap. At an interval of
2ms, allocate a 4K anonymous page where the first 4 bytes are random numbers
and the rest are zeros, and then trigger reclamation of this 4K page through
cgroup memory.reclaim. When the pool threshold is reached, shrink_memcg()
will be triggered.
The test data after running for 120s is as follows:
                                Baseline      Patched
shrink_worker wakeups              5,363          169
shrink_memcg calls            11,373,201      350,703
written_back pages                40,212       40,241
zswap_store calls                161,190      163,753
   store succeeded (ret=1)       102,743      117,183
   store rejected (ret=0)         58,447       46,570
   store reject rate                ~36%        ~28%
pool_limit_hit delta              55,826       33,760
pswpout                           98,659       86,811
pswpin                                 2            0

Test Case 2:
We evaluated the following two sub-configurations using stress-ng inside
a cgroup capped at memory.max=1G for 120 seconds:
  Test Case 2a (max_pool_percent=1): Continuously triggers the global
  zswap pool limit, thereby waking up shrink_worker() to perform asynchronous
  shrinking.
  Test Case 2b (zswap.max=320M, max_pool_percent=50): Continuously triggers
  the cgroup's zswap.max limit, thereby invoking synchronous shrinking.
Command executed for both setups:
   bash -c 'echo $$ > /sys/fs/cgroup/zswaptest/cgroup.procs ; \
   exec stress-ng --vm 4 --vm-bytes 4G --vm-keep --vm-method rand-set -t \
120s -q'

Test Case 2a (max_pool_percent=1):
                                Baseline       Patched
shrink_worker wakeups              5,640         1,308
shrink_memcg calls             8,481,500     3,140,972
written_back pages                   260       468,216
zswap_store calls              2,742,756     2,011,269
   store succeeded (ret=1)       934,640       947,988
   store rejected (ret=0)      1,808,116     1,063,281
   store reject rate                ~66%          ~52%
pool_limit_hit delta           1,181,310       196,882
pswpout                        1,808,376     1,531,497
pswpin                         4,288,497     3,635,365
Test Case 2b (zswap.max=320M, max_pool_percent=50):
                                Baseline       Patched
shrink_worker wakeups                 0              0
shrink_memcg calls              687,608         54,002
written_back pages              639,176        846,663
zswap_store calls             1,224,222      1,228,548
   store succeeded (ret=1)      992,816      1,208,123
   store rejected (ret=0)       231,431         20,425
   store reject rate               ~19%            ~2%
pool_limit_hit delta                  0              0
pswpout                         870,745        867,360
pswpin                        1,707,823      1,216,814

Under identical workloads and runtimes, batched zswap shrinking
exhibits a significant reduction in both shrink_worker() wakeups
and shrink_memcg() calls. Furthermore, the sharp drop in both pswpin
and zswap_store() rejections demonstrates that batching zswap shrink
operations effectively mitigates zswap_store() failures caused by
hitting the pool limit. This significantly prevents pages from bypassing
zswap and falling back directly to disk, thereby reducing LRU inversion.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 mm/zswap.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 48fc7b575e24..ebbfe85ba7e8 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1275,6 +1275,14 @@ static struct shrinker *zswap_alloc_shrinker(void)
 	return shrinker;
 }
 
+/*
+ * Scan up to SWAP_CLUSTER_MAX pages on each per-node zswap LRU of @memcg
+ * and write back the reclaimable ones.
+ *
+ * Return: 0 if at least one entry was written back, -EAGAIN if entries
+ * were scanned but none could be written back, or -ENOENT if @memcg has
+ * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
+ */
 static int shrink_memcg(struct mem_cgroup *memcg)
 {
 	int nid, shrunk = 0, scanned = 0;
@@ -1290,13 +1298,14 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 		return -ENOENT;
 
 	for_each_node_state(nid, N_NORMAL_MEMORY) {
-		unsigned long nr_to_walk = 1;
+		unsigned long nr_to_walk = SWAP_CLUSTER_MAX;
 
 		shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
 					    &shrink_memcg_cb, NULL, &nr_to_walk);
-		scanned += 1 - nr_to_walk;
+		scanned += SWAP_CLUSTER_MAX - nr_to_walk;
 	}
 
+	/* Nothing was scanned: every LRU under @memcg was empty. */
 	if (!scanned)
 		return -ENOENT;
 
-- 
2.34.1


