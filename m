Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 245EDC88E40
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 03:29:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0446B008C; Thu, 10 Sep 2026 23:29:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A10B6B0093; Thu, 10 Sep 2026 23:29:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED1E06B0095; Thu, 10 Sep 2026 23:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B09EA6B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:29:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D6521206BF
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:29:46 +0000 (UTC)
X-FDA: 85200051972.22.793DCED
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id A122080002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:29:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=UUgkruso;
	spf=pass (imf02.hostedemail.com: domain of mingyu.he@shopee.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789097384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=i0Kt7XnkPOmENiinuVzqr2b19eJklmr7Bc9jhStDXZA=;
	b=0uqksiiNrX2hBJDrcNIItQwpRjf8BWSo7b3/RunOSAhO8TDHOMefOkub2J6LXiXzej5hZD
	xKulrvOZKkdcEXF8lsjdwT0O+VODckM+trjaujqEEezhNLekOqlfoRQQi4OjIYsgaEddNl
	X4LSMnmtMtc/1F7eppXKc2CJHa0RtKg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789097384;
	b=mcJOppezLfw9dBj98QY628H0SQAiBsTj9SKzlGqjI/uoHhZH3shDVd1wee7SvC1cbPWRLn
	vvf4vzHxdqtcpVIF/sUqhrGhoSyW+bJ/pT7RPqdmD/Nie+8DvSvRuFD2aqwXmwjgjjjONi
	P1HlVIy1b5a8eOAwXU4NnOg1wv0/Cc0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=UUgkruso;
	spf=pass (imf02.hostedemail.com: domain of mingyu.he@shopee.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38759bcd877so517930a91.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 20:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1789097383; x=1789702183; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i0Kt7XnkPOmENiinuVzqr2b19eJklmr7Bc9jhStDXZA=;
        b=UUgkrusog75/aE27hljGvYv5mjQTg2gQY+cGdbeKlPE9cHl/vwv8N+WDJ/zYMUOYyt
         CLLJR+35DlMta4gpCk5/RhM5GNNZuX1+z4B9UUVyDlzAZix2HoKj6Lw2hdNtxAv/qW0W
         N+Tl0pCnoOP89kcJJJsXoyQ5LbtShas+hLmvF3ajb5Xt4mJ5K4vbl8cfjWHSmGt1bMFN
         m28bMIVyovRFeTvUNQDqJMJ7BRTHtUJHKFk2KzdHzwwC1zJ/8i+w/MgF0dB4OrzFmE+q
         t3mA4JdCCMKUaA6XNfutfyYgN4I4EINzN3ohT/bQ2YJAmr/ZAjVYqYPryUnndNq6+NIo
         jswQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789097383; x=1789702183;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i0Kt7XnkPOmENiinuVzqr2b19eJklmr7Bc9jhStDXZA=;
        b=mq4fdL7Frb8CIQJ2ZcA4THzpNU+hNdeiFLX4rF0I+r3cmchiZuS5HGkgHTVkBl+WSx
         s1aophdanFODD6vUSbQcky0NVu/cA5TzZtjCyEF9nibefamPMpb6aZY551ctwnvOiGJh
         Qd79orpKGKvYrdKyt9T0uhj9gQJSGd6Nv0MZfqSQROSqxwmOMsbdB3ExMQ/5TzW8nVxd
         7zxaKXKPR6j9rPzzsVkXKRjX7mMCLNNwoKhdNfX7BXzperbD67n3wK2y3/pjiQDzmDCU
         n6Vh0fZDypJyoiHxd3oJS/Ts4MVzGVI9MQgHISQEKuI7zy6pdnzG2Ze3Y5wHWdo1rfMS
         0uuQ==
X-Forwarded-Encrypted: i=1; AKwUvBzUIiNFJ+gZw28UdQU/wARBul1eNSTz+d+GtgUilbLqNg3NYdGNEa2Hd16lj11A46y1OKJ0+0vwRA==@kvack.org
X-Gm-Message-State: AFuF++nQrIAuQ/NDKw5Czgl4NWSlp+tYwo2lxojOQYSbDe2Y30XsX4Or
	xjPuUVHhklSRSYVPwJiOdFHRtpu76mn1L2ygIi04bn3HKd3TWgelfjkAC7AqOVLaI64=
X-Gm-Gg: AYBFou2eRsEdf1zNMw5w3ALUn9ylq4eJmUIYHECUK1oSFXcR/0mFoTJbCHQqrgCRJTB
	RYF8jGFou7bqdpIErpmEwmM3YNYgdMUY1An5bRRq/qNQ1IosgViWxoHnqXlUw7kM7fFts73ApnX
	9R19+afs+YJkg16pHwuun/hsYoL0tEPZH6iFd3gm/qLrjfQlbHA0hEYcwp+7bO0zF6bJoArtokU
	abqNxLQ0h0zC14aNFko64iKCv0fBsBpDDyFO9LgizhvmhX73mm33aeP79EydQYR7ABGYfz9hNVv
	BfaDFaWyYiKOjm+n0RUZMBkV26lTptzYDAjKGZ8Ws45/mluHpImav3g0sIP7x3TAWJAHippwSuf
	uWHg0q1tgdvI4UpqSnLZi/Hq4FlQMwW0fGfGTdnAwtBggS0aP8nocq+Iu968ALKMWm0bSUKmWc4
	mFmAZKzGFQRyo+Dyy5yh5e2y+E0/CMBIc8awEySDSGh4ajUnuI9aPBRAtnEHuGd+N4QHnXMrLEA
	6Zhp6VjZ1J+5VvkGyO4bj3TobiFLNf08H0UIvUlPtxWEkXm720zCfshgcAlhwlMAPNpyGRYzAtc
	i4vPTyM=
X-Received: by 2002:a17:90b:3a44:b0:381:cef1:11ac with SMTP id 98e67ed59e1d1-39d9bd923aamr3589455a91.10.1789097383267;
        Thu, 10 Sep 2026 20:29:43 -0700 (PDT)
Received: from LPMV6FJ9FM.cn.corp.seagroup.com (static-ip-254-9-104-152.rev.dyxnet.com. [152.104.9.254])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d9b2ae3adsm523859a91.1.2026.09.10.20.29.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 20:29:42 -0700 (PDT)
From: Runli <mingyu.he@shopee.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	littleswimmingwhale@gmail.com,
	Runli <mingyu.he@shopee.com>
Subject: [PATCH] memcg: keep propagating stats updates to ancestors
Date: Fri, 11 Sep 2026 11:29:05 +0800
Message-Id: <20260911032905.63683-1-mingyu.he@shopee.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A122080002
X-Stat-Signature: z8rwnkb9h1wk6gygjamukrcmmxkgxges
X-Rspam-User: 
X-HE-Tag: 1789097384-481565
X-HE-Meta: U2FsdGVkX1+l4BR7HNCSCTizqXqq0nDYbB4UuEuAb7gpyhuqMKjsZWHaNXlK4BcFK8dC/yns++SOB5ZeKo4bjV4w9a0p1ct3yUJwtYayVeXnwct6vhsWn5xq+Q7fAQ956+pCKfmoLq3jGCcLstktJ3go24nVDLa84iE/RzwBlQD8mxUhvXRLVa63RNyZ5Wb4U00qFi/cOBDUHTuF1rnVpKBRLtWM3rKF5kI1KAZXY/6MLzoD1FkzYCuAGpo71gThzGyjeGbvhwfPcsIZ01Z2xQCxgWmnVFlCoxUzaedWtO+tVRR6cuGS7SbSqKzpKf/qDKw5mRBwVQvLZnRpTZVGQ+MXVFNt9dv/s3rn8qfveDvJ0wti36KKG4Qi3V+HHNcCe1nTuE1c0lSx33HbRAr4PgAkFrCrMje64PY0YCsPyOUG7uwpOFve/tqsNqTshkTzxShVVtk8MzakxdDnMvCGTkhu4XjG3U0h+AxjXb3hEwNfQOvVhrQqGO+nGCbTIyYwbM3MvVZBM9Gw/HUt3mr1JGAcCVxlZobFusaEYuLsrgazO3xpurlhiF3SnrBNs8H9XH1LYNxOHHpPmw6QF2SH5kLm1b5f3c4KP5Eud+H2JUxv4n2HASjfbH0xsFegmoLuZ3MCf1raw4uZmAA3YMAunwQJhuqhYIKh+WcuA9BP5P+/vsRCH0V6EMEYpfD2m9DU+rzhZ0wxU9V++ysOsx3eqa+HM0oqaZVAJSQgDgi1bRxHcfLJASllGa0PJ6N5tWyWPAqtjDRrEtj/5No4DcWd9TROHMx0TekPtf3q3DepfuZOgNsnTmyK/T/Rmw4MRjUi4D8aOGvJYAmJ3n+vRQWB1FW3nXaxJdcDAs+LWy+Gvv34zxsyVBgSqfPATECYruE2cqqHBt4kF+asGI28DnlW7Iw61Ph5EWIcF+f3oMF8SxqRpj93pz+EdEOZd4LSEueeWe3ASRdBNlr72ioBNw/
 xs9TZ6yD
 4L+9kuuwpIlBnu2i/lCaR7A2LNdTxDpP7lgbfofceGgBxbya5W/DFBkLCGjx1b6xWV87aK2pKaCKxLpRQycemauotAxvmiaJQpVMQ4rXsC4IFDEBSTIhi1PWKeQ1pifnExFk4XqykjbeuZ4O/0D/++InVx/wrQeSh8YTC3Mj+l8jBJ7cj5S58wfFXEs48V8gYhDSO5DVV6mDt45ce6A+IbgZEdXhdj0QAFaTK4LiDSck1araGJC8H440xRSz4PhbbC9NtJIxWvnVhxw4PJnv9twTT+wRGQVDjBL77SVS5kVCirnJVOG7tJPDtWlQeM6FPLFf+IHZW0iz1c7RnISAE84qoRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcg_rstat_updated() stops walking the ancestors when a memcg exceeds
the flush threshold. A concurrent flush can leave an ancestor below the
threshold, so the early exit prevents it from receiving further updates.

Consider root and leaf on a 4-CPU system, with a threshold of 256.
CPU 0 is flushing another CPU's stats after CPU 1's stats have already
been flushed. The counts below are shared stats_updates counters:

  CPU 0 (root flush)                CPU 1 (leaf updates)
  ------------------               --------------------
  clear leaf->stats_updates
                                   add 64 to leaf and root
  clear root->stats_updates
  finish flush
                                   leaf = 64, root = 0
                                   4 more batches of 64:
                                     leaf = 320, root = 256
                                   next update:
                                     leaf > threshold
                                     break; root is not updated

Root remains at the threshold, which is insufficient to trigger a flush,
while further leaf updates keep taking the early exit. The periodic
forced flush restores progress, but until then the root's aggregated
statistics can fall far behind. For example, page cache grows at rate of
1 GiB/s, a two-second wait can leave the reported usage about 2 GiB below
the actual usage.

Skip only the flushable node and continue walking its ancestors, so each
ancestor can accumulate updates until it exceeds the flush threshold.

Fixes: 60cada258dfe ("memcg: optimize memcg_rstat_updated")
Signed-off-by: Runli <mingyu.he@shopee.com>
---
Testing:
Based on commit 893e11787f78, with and without this patch,
  using 32 concurrent instances of:
  netperf -H 127.0.0.1 -p 12875 -t TCP_STREAM -l 60 \
          -T <client_cpu>,<server_cpu> -P 0 -v 0 -f m -- -m 1024

Both netperf and netserver ran in the same leaf memcg, directly below
root (root -> leaf), with memory bound to NUMA node 0.
Each kernel was tested for five 60-second runs after a 10-second warmup.

Median aggregate throughput decreased from 107.26 to 105.23 Gbit/s
(1.9%) with this change.

I think fixing the correctness issue is worth the roughly 2% throughput
cost.

 mm/memcontrol.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..4600d9c9244e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -729,12 +729,11 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, long val,
 	for (; statc_pcpu; statc_pcpu = statc->parent_pcpu) {
 		statc = this_cpu_ptr(statc_pcpu);
 		/*
-		 * If @memcg is already flushable then all its ancestors are
-		 * flushable as well and also there is no need to increase
-		 * stats_updates.
+		 * A concurrent flush may have reset an ancestor's counter.
+		 * Skip this node if flushable, but keep walking the ancestors.
 		 */
 		if (memcg_vmstats_needs_flush(statc->vmstats))
-			break;
+			continue;
 
 		stats_updates = this_cpu_add_return(statc_pcpu->stats_updates,
 						    abs(val));
-- 
2.43.0

