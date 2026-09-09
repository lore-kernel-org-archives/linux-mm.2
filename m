Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B3AEC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 03:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B26F6B008A; Tue,  8 Sep 2026 23:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264366B008C; Tue,  8 Sep 2026 23:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12C466B0092; Tue,  8 Sep 2026 23:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F47B6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 23:43:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 795FF12084B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:43:50 +0000 (UTC)
X-FDA: 85192829820.05.01F09D5
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 13AB120006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:43:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="ecuV6nf/";
	spf=pass (imf13.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788925428;
	b=sElUlBOkueTjai4Tn+NlkswsZSdGsE5cJikN+fyyt70uM2wNeMvnjonbx1gjKS/6tXr3R5
	wp0KTGcUA8ud+1BZdKPr5s6VqEVbgwt5ew84ky598IlKWJ90QQ02aKu3WvkofCqzwQfYb1
	SirGbXBe41kyIlgjSKBK6gxqFr0HLv8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="ecuV6nf/";
	spf=pass (imf13.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788925428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AUs1qeMV4Avebc488kXwADqOO+7MG6W6kUjE+T02g2E=;
	b=DPIof5Hm3WW88aYRQ6t7ktSO43TGI/78LOyLn/Jtj+TABm6VY/SeohSNVAx10a3mxspqn6
	28sO3AiVokNQi0w0UxPq9c+iQ+abXCP0fo6R7IQcO+Qp9/OgoXa/IyIPSDMsASETpxIxq9
	H8O6Uakbj3cy5TJ0VVzYmsJ5VUXJ4DY=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-853c07a76adso5135082b3a.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 20:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788925427; x=1789530227; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AUs1qeMV4Avebc488kXwADqOO+7MG6W6kUjE+T02g2E=;
        b=ecuV6nf/LrMHR8RHCg1F3e/LthUdzjj9qgUtQXgSyVxum8s3jIRb8tqVbHh84x4Iza
         UGl66stjHQ4qOQqddskZfuLNfzzywPELXATo1PnTCX2WapvH+7bfoGchxPTDzfOp2Y81
         5RTwqKMFzlfmaktNOUTdIcIZS+XPjHk7vwwZ0OFbie7/A+7pIjVT3xuOtV/lIkMqbWK+
         o5DRehsSaC9DkWEGolmSGuu4VHuFW6ERJmLaEO5rfEkFb2rgcmGT+piAYH/l3wztVfID
         WqK7eCssnK/t//XyYpLaR/FCRfNcdym8qf9RiZigzMmnl+FyAp/3A0jkPUeNTGKbCW4J
         h5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788925427; x=1789530227;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AUs1qeMV4Avebc488kXwADqOO+7MG6W6kUjE+T02g2E=;
        b=RNhcmqti5hw8Yjp7O2Tj8um9JFUnaFeCknnSzWU4U7LuVYtwsG/GudPnGd4AJYNU06
         gREOLicZM0YYZvIZahFCnFeHI01a1/FeAUBgv6+WTqpTR63sgF5uDDosB1q8vQdD2AOj
         KAdLgCwnPi5sJWXDf4aAwWuVVtCyjTz+824c8p68CsofP0TINJIRSD06tdnSqlQICQ2l
         7OwkyjfX1xk2yAttBGE2qbjFp73ln4zSkxy1aO1ZVyV1i8mP6l1CNYJyC7ZysaxkKcvf
         xKemXksPATp6vFxnYtexsyW2UHLAM5Nv62XTJDT6TJexLnVVgdapJWYX+2KGwGlDkprD
         prjg==
X-Gm-Message-State: AFuF++n1xwHvAaeVSKSmcRlSCYMaLxJTQvuoHK3UHHWpp1KrUShlca8D
	iMF7poGtuJ4u6U14m1zcVPePnCB4l7XDA5IYC+yMTbyJrY8wml+hJvQ1WdpuF8RxBvGSCjSKy3m
	JMeflAe4=
X-Gm-Gg: AYBFou03jc1+YHULqL164Ha1giINw45JS3OsYmfQynzHrl4C25AEolzz/SEVyB4Kn1j
	srehc3fKbO2rL+mOWe5o8esu9wpKHvbf/IChSYPXis/Yv5W0T+L4tUoekIMUWagSmjTYCgJ70Z+
	dT/zbZ9EZ/j/oEswd+yKuzqj5lmZfuN+c6zndUzON/IBTt47ekqKYUDk5Nwr7XysnNCHQCNaa8N
	jrENqOxtGsGfI8kPg/9HqNkcOoRcN952qkt5ZC+ccttfgbF9PiQVHIvzwQI9OpOFf6caYgUDoqp
	9jYwd7mZwiBKTSy+/8IPSzzbanHuUgudbJu5gnA6oPVaxZmJVvPh4+2te1mfq0Fx71qHenBKCat
	yEKDsno1F3T7lLP2cER+KE3aMsOlqBKEWdeEKJzam9UL6HaD2d4bZP69spjT53l19yKRc9NkGAw
	ZQ7RTNn7EPJpFMQ3uUoJHWDFehgnb+qId7Yc4o6hDOCeI2M1vy+UgeFW7zRUSA17/KG4azaZm3o
	g==
X-Received: by 2002:a05:6a00:440f:b0:84e:b7ed:7d50 with SMTP id d2e1a72fcca58-861684928fcmr45806421b3a.16.1788925426536;
        Tue, 08 Sep 2026 20:43:46 -0700 (PDT)
Received: from localhost ([106.38.226.27])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86153f417f2sm6071019b3a.58.2026.09.08.20.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 20:43:46 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	axboe@kernel.dk,
	tj@kernel.org,
	jack@suse.cz
Subject: [PATCH v3] writeback, memcg: skip foreign dirty tracking for bdev inodes
Date: Wed,  9 Sep 2026 11:43:43 +0800
Message-Id: <20260909034343.340703-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 13AB120006
X-Stat-Signature: 6xpy6k5ojf94mx7bowrnqz6bc3nffpkm
X-Rspam-User: 
X-HE-Tag: 1788925427-816882
X-HE-Meta: U2FsdGVkX18Tx531AGSpteIT2z5wDGyIF6j901LU4FAqUWpA7yglnHl2tyUxc1m9ayKXt8BeREOuJ/NCqUgGsDzcMWFMyN73tmLF/81A5cv8GM9Sw16ME6RC1dRaMS5tkyFE/8PExf85+WxG70MQbGqy3egRkj4sbQY4H5FdG/jaI2YbB/NdQJBwf+XSLoOY9J0mzJutLftiNyoIIhJ4kJdjHcAfFzI3jmwATcrHYTqx/9J2eSO10rRqU+38tP/P5mra7q5hDx2ZMtYMLkwJ/TZ2WfPg17ZunIft2/PwXyvUw8ZH7wFzpV8mYSjfxUIb26JPPQCvoQjn4DfJZd2cfmrM4JNouIDzVbpP8e9tn7BgGMNHNN+xuAMH7a8s4RzWqGCkDDLcxTVHnHzZeXBz73nSnEJXPe0rVIhy9gsF0O2+kinu1Fm89TVQPPiNEVeoliid2btVEPKxQTMUs1R3/5jeHi814WXmQT4a7j2Z0T1nuHIgH/rI17QFTo4/GqwKz8FIfIivaMcTESVc6FqjWdwgkwgwUL+o9W3flyi+Hg81j4liq/WGayHVgdB2QSs+TNFBTRbnV9+/8JPWHFo7t6oV+37Tin2RTSpGFBoOVgB8zp8sRRh6ed3GbE52sjZiuDv4q10zDeVzNLAT/ssOnglQwBXjNTDerRkLfBPqCe9aiUISuvql7zKy56Dov7vZNxNMLUU90CSFI5zHg8dP3tSL1v1UaZKipT0Gx1TD5nPhMLmPF0YM8IdM0zzxMl35d9LcogaapTQ84N34RSooCC6tz2IphBSTr74fXgCu2Tp2uzDtutKaizVpBKKtvCPJzBtGC16fV/rd4rH1jQ006t1kKBCLfQc1aLdNkza8q1r9teC5kTMt1+g7LTWlfbGmPD9k91ON5ov0kz/4aAQz8JJ66GFxM5J7RTKOdg2U/rFHEhQ2y7dyscRRYFf5MmqqhkatTpRMDNjOpFVIACj
 nXu6HxFx
 DcvEppUY9HxPQ0SWudFv7EJtCvLb/WUQ+sFtuSEBV4lPSBzHkju7dnt/qrHJndX4IThn4Ejfg7UEBtAzGq/cO/+KPHwRJrbTTdrzQ1Ic0AIryDb0Ripb5UTccAhY91Zi450ASL9JUrauyzXQ+KhQWP0zH8WkEano3C8/gX1YN64XcpRqztJz00cE6qlEpAUmxUGTCN3neDTXu2Lw2VOUmnGJAhzFaSJkrc8evCCrDVuVd1Da4rxQTRDgYmpDlGmSeBxKEUbRLhLVSB5fsbiYzteR/AMTlfrMi4i/0o7fOqsJtoz8g1Be3+ksN3Cbui+5kWxsj8Fxn5e2SAXDY75kDdVrXeAfp7eizTgdvo74E0wxGK0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The expectation in wbc_detach_inode() that "concurrent write sharing of an
inode is expected to be very rare" does not hold for bdev inodes. On ext4,
metadata from many memcgs shares the same bdev inode, so dirty throttling
in those memcgs can repeatedly trigger foreign flushes of the owner wb.
These flushes can also write ordinary file data, reducing overwrite
coalescing under continuous buffered overwrites. The resulting extra I/O
leaves less device bandwidth for other workloads.

Skip foreign dirty tracking for bdev inodes. Ordinary writeback and
foreign dirty tracking for non-bdev inodes are unchanged.

In a synthetic ext4 test with cgroup v2 (QEMU/KVM, 4 vCPUs, 8 GiB RAM),
device writes are capped at 200 MiB/s. fio repeatedly overwrites a 256 MiB
file in the root wb while four memory- and I/O-limited memcgs generate
metadata and trigger foreign flushes through dirty throttling. A concurrent
fio performs 16 GiB of sequential direct writes on the same filesystem.
Across five pairs with 9 GiB of buffered overwrites per run, mean results
are:

                                      Baseline    Skip bdev
  Overwritten-file device writes       5.60 GiB     1.70 GiB (-69.6%)
  Foreground completion time           104.2 s      89.1 s   (-14.4%)
  Foreground bandwidth                 157.3 MiB/s 183.8 MiB/s
  Foreground p99 completion latency     1434 ms      480 ms

The tradeoff is that memcgs with dirty bdev folios lose this way of
requesting writeback to relieve dirty pressure. In a separate uncapped ext4
test, a memcg with memory.high=256 MiB creates 60,000 files paced at 4,000
files/s, each with a distinct 128-byte xattr, and makes occasional buffered
data writes. The xattrs use external 4 KiB blocks. Across two pairs,
completion is 31-33% slower including final sync, while device writes
remain about 524 MiB.

With 64-byte xattrs stored within the inode, the same paced workload
showed no substantial completion-time regression, including at
memory.high=16 or 32 MiB where the baseline triggered dirty throttling
and foreign flushes.

I believe this external-xattr-heavy workload under memory pressure is
relatively uncommon in practice, and expect the benefits to outweigh the
regression. I therefore consider this an acceptable workaround.

Core fio commands for the overwrite test:

    fio --name=hotspot --filename="$dir/hot.data" --rw=write \
        --bs=64K --ioengine=psync --direct=0 --thread=1 \
        --size=256M --io_size=9216M --rate=64M \
        --refill_buffers=1 --invalidate=0 --eta=never \
        --output-format=json --output="$out/target.json" &
    hot_pid=$!

    sleep 8
    fio --name=foreground --filename="$dir/foreground.data" \
        --rw=write --bs=1M --ioengine=libaio --iodepth=32 \
        --direct=1 --thread=1 --invalidate=0 --size=4096M \
        --io_size=16384M --eta=never --output-format=json \
        --output="$out/foreground.json"
    wait "$hot_pid"

In the log below, base is the original kernel and skip includes this
patch. hot_GiB is device writes for the repeatedly overwritten file,
including final sync; the other performance columns describe foreground
fio.

Full five-pair log:
nohup: ignoring input
[2026-09-05 17:52:10] RESULTS=/tmp/cgwb-20260905-175145; WARNING: reformats /dev/nvme5n1; 5 pair(s), limit=200 MiB/s
[2026-09-05 17:52:10] round-001-base: booting
[2026-09-05 17:52:20] round-001-base: running workload
[2026-09-05 17:55:36] round-001-skip: booting
[2026-09-05 17:55:45] round-001-skip: running workload
[2026-09-05 17:58:57] ROUND 1: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
[2026-09-05 17:58:57]          base    104.574   156.67    156.67    203.82   1434.45     5.862    0
[2026-09-05 17:58:57]          skip     89.125   183.83    183.83    173.62    480.25     1.656    0
[2026-09-05 17:58:57] skip vs base: bandwidth +17.33%, time -14.77%, hotspot IO -71.75%
[2026-09-05 17:58:57] round-002-skip: booting
[2026-09-05 17:59:06] round-002-skip: running workload
[2026-09-05 18:02:18] round-002-base: booting
[2026-09-05 18:02:27] round-002-base: running workload
[2026-09-05 18:05:42] ROUND 2: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
[2026-09-05 18:05:42]          base    103.533   158.25    158.25    201.75   1434.45     5.493    0
[2026-09-05 18:05:42]          skip     89.124   183.83    183.83    173.65    480.25     1.730    0
[2026-09-05 18:05:42] skip vs base: bandwidth +16.17%, time -13.92%, hotspot IO -68.50%
[2026-09-05 18:05:42] round-003-base: booting
[2026-09-05 18:05:52] round-003-base: running workload
[2026-09-05 18:09:06] round-003-skip: booting
[2026-09-05 18:09:15] round-003-skip: running workload
[2026-09-05 18:12:28] ROUND 3: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
[2026-09-05 18:12:28]          base    104.648   156.56    156.56    203.96   1434.45     5.334    1
[2026-09-05 18:12:28]          skip     89.243   183.59    183.59    173.92    480.25     1.824    0
[2026-09-05 18:12:28] skip vs base: bandwidth +17.26%, time -14.72%, hotspot IO -65.80%
[2026-09-05 18:12:28] WARN: runtime diagnostics present; inspect each data/dmesg before using this pair.
[2026-09-05 18:12:28] round-004-skip: booting
[2026-09-05 18:12:37] round-004-skip: running workload
[2026-09-05 18:15:50] round-004-base: booting
[2026-09-05 18:16:00] round-004-base: running workload
[2026-09-05 18:19:15] ROUND 4: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
[2026-09-05 18:19:15]          base    103.565   158.20    158.20    201.84   1434.45     5.497    0
[2026-09-05 18:19:15]          skip     89.124   183.83    183.83    173.57    480.25     1.648    0
[2026-09-05 18:19:15] skip vs base: bandwidth +16.20%, time -13.94%, hotspot IO -70.01%
[2026-09-05 18:19:15] round-005-base: booting
[2026-09-05 18:19:24] round-005-base: running workload
[2026-09-05 18:22:41] round-005-skip: booting
[2026-09-05 18:22:50] round-005-skip: running workload
[2026-09-05 18:26:03] ROUND 5: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
[2026-09-05 18:26:03]          base    104.567   156.68    156.68    203.78   1434.45     5.830    1
[2026-09-05 18:26:03]          skip     89.035   184.02    184.02    173.47    480.25     1.648    0
[2026-09-05 18:26:03] skip vs base: bandwidth +17.44%, time -14.85%, hotspot IO -71.72%
[2026-09-05 18:26:03] WARN: runtime diagnostics present; inspect each data/dmesg before using this pair.
[2026-09-05 18:26:03] DONE: 5 pair(s); all test VMs stopped

Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 mm/memcontrol.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..6e8f7ff7d44a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3898,6 +3898,15 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	u64 oldest_at = now;
 	int oldest = -1;
 	int i;
+	struct address_space *mapping = folio_mapping(folio);
+	struct inode *bdev_inode = mapping ? mapping->host : NULL;
+
+	/*
+	 * Bdev inodes are usually shared by many memcgs so foreign
+	 * tracking leads to frequent flushes which is counterproductive.
+	 */
+	if (bdev_inode && sb_is_blkdev_sb(bdev_inode->i_sb))
+		return;
 
 	trace_track_foreign_dirty(folio, wb);
 
-- 
2.39.5


