Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6078DC4453D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 02:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FB9E6B00BA; Wed, 22 Jul 2026 22:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AB576B00BB; Wed, 22 Jul 2026 22:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2743E6B00BC; Wed, 22 Jul 2026 22:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E99476B00BA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:59:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5741540376
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:59:38 +0000 (UTC)
X-FDA: 85018536036.29.3AB3508
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8CB5840005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:59:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SQEcIDr2;
	spf=pass (imf12.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784775576;
	b=Sq9pJvgAuAbErWl8xpw63AcrPVp9TX8OLNq7jEOmaBJwmSeW+2wDlnKD/69vB2RJ0YjQyn
	ThYT8kEEJipHkB/yckD38HN6yyShUmtK+h5XIjsaLIjCTavT+laRAhtekj/wdu20m3CiFh
	JYgk00YnXatKEHnszGJQrCXeMg4kAzA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SQEcIDr2;
	spf=pass (imf12.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784775576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z8OTpiatQBHFhVb1kcbCtXbO04T0mIjzVEpsj33f5I8=;
	b=6xGKh3SO+dCrT9wkBq8JtlSsAFyYhtAWb17DzvKU9sCtjbGfYRE1xVVbAxSh26m6O9ftpI
	0uUN20Y2vxqHejWvj+DmotvSp3Hvm2pSnQwxFsI8KJEKDTmNVn/ABDYS+PhJXLtcrB6jhv
	cr6lacQo8WqLAzwZipn/dYj6iuwhndg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784775574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z8OTpiatQBHFhVb1kcbCtXbO04T0mIjzVEpsj33f5I8=;
	b=SQEcIDr2tw82PVukVDpkp/Udjvjce6EtsKMOY+rD1choFe5zG8AMa9uPXyGTujI7GyimE0
	zWgRQLzJkCQL4sc59iUPNdKFMOrAi9rGiiIVEIp7O+pl4ZlC0t6ixczeZXmcKnwoD1jEOB
	xBeJ1h+TgFRmmV58WTgs2bIwHG3nJ1Q=
From: Ridong <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>,
	stable@vger.kernel.org
Subject: [PATCH -v3 2/2] mm: vmscan: fix node reclaim ignoring swappiness parameter
Date: Thu, 23 Jul 2026 10:58:58 +0800
Message-Id: <20260723025858.1956584-3-ridong.chen@linux.dev>
In-Reply-To: <20260723025858.1956584-1-ridong.chen@linux.dev>
References: <20260723025858.1956584-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8CB5840005
X-Stat-Signature: r7cj9yaa163rda7o5jqogfyp9pjgrusa
X-Rspam-User: 
X-HE-Tag: 1784775576-189518
X-HE-Meta: U2FsdGVkX1+TevVxl7h++zr9D+8YHmoe1Yal61pIlNuLVXXKOUD+PqRiRdquWFUO+NPbrgv17afisOHy+C1UK8jtymF6LQVfOadeLg99PBRaks0yzKFxD9fE95hE3yUnqneKegQfK73Aaxt5/SFNFCgZn7OEVeB2ZwJjWkGCQbYzRRX25wG9+/MeEFJ32y25N+Ko06hIexW0PmeJbhrz2W1C8IjmE+P42tU+oANxnhkhguBKjAFQCJ0Zb72eHmYfD6EMbKGuXy3Bl13XYULLVzfgPf0d5/1izRQCYmnhu1fHybm2krpws/Qe9mjDccdw8AFBvO0JL14G+1dGCZrZq4tl1QuNIs5pqyPTQg5BDoxLFgGajBVMuozzkYHy+dQNI534UtjIjzNldSNLGuUFA7zbujHcGAZ9lzw3JhZk8t70k2b2GZhWi36amDeGx0Nkak25FW5ioKlex9ddFQNN8KgNszEK3gM8ZraSKPgoaqhxA8Yvch6318TDyLElxi0SbJBBxRSS3EDgLssVy1U2Z/pBC93S9yb5hQphon5ba5zZ4bTxDB2YpXrDiA5ODwHRfou9rpuRAToh32aRq+LKN+8fZASDRzUB88N6TLDuBOTpFiZRAG+DBX3qvHUVFdMzvSYUus3erHPdugxSSrMVNlKMK61IVGoOLUw7xxg5k3GC70WB/kk0U5V4RDDXJ2DfCMEVgjX973RzjEn87qEKRzyCPsXIPQ9Mjo0/aPXLG7vbDK88EUZcpP7nFDHYJcPnls+BkSD0iDoOa7IrA8MPGcVoDk8Sr+yDOE0lPMacFf37Hi/5r1qxMI1DfVJTbNSOM/3v8SYu4eaM8PZykKpomYQ/gPMOTwKzPWax+/wk6tZ8cKx6FDGBjZLD3LLKbGSnj+jfOZOUmgENPEZ6kBA1L7Y8hQUHDVsSSgnOA4Bmxz8B/OvqTwHkDKohSvhSi7mAKvBALWjqjz3vC6b5lzw
 A9FKwURF
 zlUxGT8+9frrcrBST3z7Mlp32ezvwnuJiy4mIFa8q2qcVLWowspiObNIE1XbllWzRNbjPN9Hq3x9COks535s3srVTUknaTiGmrRFy+HWzSKDwX3IRFeKn8ADz3thvVQNBs2EE4yyPfb4VgxryDnEoK+nV4jLp0Z8bKkC66W2JRgP9C1SWcY/MWmrf9Ma2Ovqy4fYsqRIbKqzdOe4yXUwEw2NA2Vs6+O0TuKfOJrLymrE/gziy51e6O3r/HC8SyMkpwTQ9HTtoAQWQt0vyqvBjb7jZqqjAG0X8Fh5SHRLy7yG/xZNW8Uhzr4YeSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

sc_swappiness() had two separate definitions depending on
CONFIG_MEMCG. The !CONFIG_MEMCG variant simply returned
vm_swappiness, ignoring the proactive_swappiness value passed
through scan_control. This caused the swappiness parameter
written to /sys/devices/system/node/nodeX/reclaim to have no
effect when CONFIG_MEMCG is disabled.

Fix this by consolidating sc_swappiness() into a single definition
that checks sc->proactive_swappiness first, then falls back to
mem_cgroup_swappiness() which already handles both CONFIG_MEMCG
and !CONFIG_MEMCG.

Before fix (swappiness=max ignored, mostly file pages reclaimed):

    # cat /proc/sys/vm/swappiness
    60
    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 1840
    pgsteal_anon 25
    pgsteal_file 1815
    # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 18013
    pgsteal_anon 337
    pgsteal_file 17676

After fix (swappiness=max honored, anon pages reclaimed as expected):

    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 0
    pgsteal_anon 0
    pgsteal_file 0
    # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
    # cat /proc/vmstat | grep pgsteal
    pgsteal_kswapd 0
    pgsteal_direct 0
    pgsteal_khugepaged 0
    pgsteal_proactive 16283
    pgsteal_anon 16283
    pgsteal_file 0

Cc: stable@vger.kernel.org # 6.17+
Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Tested-by: Song Hu <husong@kylinos.cn>
Reviewed-by: Song Hu <husong@kylinos.cn>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 06e103f9781e..155167b3614b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -199,6 +199,13 @@ struct scan_control {
  */
 int vm_swappiness = 60;
 
+static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
+{
+	if (sc->proactive && sc->proactive_swappiness)
+		return *sc->proactive_swappiness;
+	return mem_cgroup_swappiness(memcg);
+}
+
 #ifdef CONFIG_MEMCG
 
 /* Returns true for reclaim through cgroup limits or cgroup interfaces. */
@@ -239,13 +246,6 @@ static bool writeback_throttling_sane(struct scan_control *sc)
 #endif
 	return false;
 }
-
-static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
-{
-	if (sc->proactive && sc->proactive_swappiness)
-		return *sc->proactive_swappiness;
-	return mem_cgroup_swappiness(memcg);
-}
 #else
 static bool cgroup_reclaim(struct scan_control *sc)
 {
@@ -261,11 +261,6 @@ static bool writeback_throttling_sane(struct scan_control *sc)
 {
 	return true;
 }
-
-static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
-{
-	return READ_ONCE(vm_swappiness);
-}
 #endif
 
 static void set_task_reclaim_state(struct task_struct *task,
-- 
2.34.1


