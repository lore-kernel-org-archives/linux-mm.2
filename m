Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72C4E606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Bz7LJ1m6
Received: by kanga.kvack.org (Postfix)
	id DF2C06B05C7; Sat, 14 Nov 2026 02:10:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA3316B05C8; Sat, 14 Nov 2026 02:10:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1E006B05C9; Sat, 14 Nov 2026 02:10:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A93F6B05C7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:39 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A26CA7CF3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:39 +0000 (UTC)
X-FDA: 85432851798.01.E0C6F0F
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7925F160003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Bz7LJ1m6;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kuOKXOl2seY2nuHPa7QaSgImf7rgxxNJypl2yP4/rNE=;
	b=n2SDNSufSbGA6wlg6OZxvnNAfmYB/dVHFobnrh5QvsTMp5NgKzQP6bhpnVZCbtXb1ASrlw
	xzVMdDGmgU9YXiy8dGrhaC7binkiNVeuj/0/vshOmh3VtOfjyvURx/sf2DGnJQZ+BBb8vM
	2xQqupSvy+b0/o/dTIRhPc86ZEAIjD0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640237;
	b=zkAp/anSpiKL/RawGZ9higuLy4MR71exmhXKGdmQh5glYF1QKwtN3U8MCjDesYRoG4Xle0
	TxaONgKKCOvlcKK+Jbn4JUxzU+9TQp743yfq5sl00i9KdyB5lH9lShzqimVwGr2lrWEBdM
	KOTTX7nQa8G426y80WHXmdoOnBjla6c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Bz7LJ1m6;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-91ec2d42231so30642846d6.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640236; x=1795245036; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kuOKXOl2seY2nuHPa7QaSgImf7rgxxNJypl2yP4/rNE=;
        b=Bz7LJ1m64OKyNf9y4Jq2nCLZPlo2zNJO+CFCggWS463VDURTxbfunbqBF1xrBSNS+f
         tWG5sZqvqex4yes9CrONVlBo4PKqA+eWarGJT/CMALyL0yM0XzFrXKy2A4FrHIsMk5P1
         L8f9QGSE0RuGtHlVlk4MRsHZgpTcWLIEucOLpWRih5jJU76NwEdYPSwh/C4tR1rqgVtq
         ATeK6xicFra/61kEaaMaNxK6G2vvhRCWNv/Q5d9jyZ0Pla42KRhQYBaInuYhtTf1hwLV
         ErXD1zMwCjfzzcormzg9tG7LrqxlUA2NhFlLWuxMgq+iu2o6qH/WtMb5GMv4QJklHXly
         eftA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640237; x=1795245037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kuOKXOl2seY2nuHPa7QaSgImf7rgxxNJypl2yP4/rNE=;
        b=LE4+KhFSXC59y/2569KjYeanIlDnVdSp/J8CH1F98eGrxhWcFiU2npxUe6tqtHRlju
         imitGM0c2b2+l4iRTG2X7w2fhgqlc6Jc3tjEM33kMFPua17fu1SU5tVMuhuN/o6ZB0qU
         N//gVzfFbyY7B3VowsIeYI7VE84k73RVXCpVNTefbvDeqQ2PODEG/sK5BjdC98UYKwn+
         jT2WCersh/0aHDj2wQsnf0W8m9j+W6xRkcyG/rT+blRYaBMivo+OEDf/wLvnFa9x2E74
         FP0F0lAAq73U6jRug9CIPmu0YoMVrVIkgIUmQ0YDlYudAO0VjQEDZ48giKBS+DIwpo05
         lQDg==
X-Gm-Message-State: APuU4Z9iw+9CpSJ6vpmo6vMAGnzf9tl7HZJeMoXD2L8TvsukcF1vws1a
	cJG41feND3OhjDH9HkjUjZdfg6/LksA1nxxCiMIBs45XB2WIYEe38uVqeQh1pXWqEdIHxOpOiPB
	eLiB4
X-Gm-Gg: AYBFou1Up2DLYBoe9/a03DqPjACiPGMCsEehppBpvakDkFpsu7lXOaYX4bKRaVwq931
	T10dxuGfcLyrRU6TTaAkmODYA0gZ5mwMwClH03wBKDAMi/aK79yBEvZ1MsKlFyzrdgWG0gCh73H
	p593aFQVW2zGOoiPIK0W20CtN6PTtLkCOrAuKbXblfEvNlTQhL0WaHKMmHZE2R7Ha/56+T/cUmL
	ySA13QoahpogNaN0S+E0+fIyoCk07opdku5T7YZhEC4B1ArXpFhLWYshHEU6IR/bmP7sEJdstoi
	s/3n6uDsIzld1dTh6nZWPnWcMTpO8f0nYyQFsYVrbS61aY/ru7G9ZByG05l8GbDB9d0ZAAmwW9n
	G6GkejaNpuQszKgpAaffckyaJdPJYglQKgaA2wyonpYxFiZcvoG6Gu4fo/naIj/y5BJVZzDso2b
	ofCBtb/Lk9/XUipqmOYMkM/Ru6hVm8s4OiZ53BFNgp2miwvvkFr68cj5zytGul6+S3zzJLhofll
	gMXXxiz1VdQUeHYAdw2MiPVmMgtq0fo073SEUAul724uYWZ8+3i4pdntSDgC6ZXhrxj/AVkPEZJ
	LnU1+BMowpSPjyPXlDelZWLGUhzff2BhxQ5s+ANQjdyMGJC2igujt8LtD27w6PEZhomTIO8qsIi
	mElUxcktUfPF/UmQ=
X-Received: by 2002:a05:6214:3b85:b0:91c:15ce:66ce with SMTP id 6a1803df08f44-91f24194ac5mr80511276d6.11.1794640236685;
        Fri, 13 Nov 2026 23:10:36 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:36 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 15/22] mm/oom_kill: compare OOM constraints against common memory
Date: Sat, 14 Nov 2026 02:09:52 -0500
Message-ID: <20261114070959.3490008-16-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: s5gouezajuh36fbm3iw1yxb88iqnawkf
X-Rspamd-Queue-Id: 7925F160003
X-Rspam-User: 
X-HE-Tag: 1794640237-592467
X-HE-Meta: U2FsdGVkX18SjDxdVgQDC2vQlnKOQY0WZp8p7L6+/gEcCzsJUOtwMzY5oX9y4IrCEOxDFA05wGIQUHobECzSQxwX6Ak92tPZ3Ydl80u7FOo5VIZgYAS8SoRGcMJhTmJH9rugmpc3eCXsF/JLXi1O4+p//GV2YcsZ8QASoxAsjrig8t2CLzFfCQU8RVoJFtT4PRNSnCijNQWZpQvJhvzIoO3qSkxkQpd1HFtC0RpWtwsg9nAFxgn6UAS7tTvnmWki3uzoFn325ejMo5k1z6acMRnn1sBEA1ycZGcR31NKMpH5bNffyexbtgT3tfny9hWzf2vNy3/LRtfOUMMZqncA2qTDFFj5CWGLWaYCdSPjubYoHOeA85MX+gbS6pmHWl5J0Jnrg3oJpC3RLNxzIq2bo/B1g7ZDTmvD/gC7ebfhUcTSgF6VHdiuUgGoPGlpHLiPNqjoqqqTZJws71UZsCXDADDPGtlZWXLSqkDp1HdVdNhzdZIPTYgFtA9fXl8IZ2Sk7i1AyqmdTKwTpiUf+xMpuvRrep3Svo4MOZwuol3gSTuHp1IlDBoj7n0rK1HdCvtoXNPpWAYr+WgDmj0yFuiMmw9fmVwi87gg6CS5dYDWNCDVOQKmQpYodzUbeaQtCm9F1c8dcqgoJiEMXtGzCcIF5dp+dovzQuwAehZNxNSfCcw5UZD3jzHYeWPg/dLqDLSTNtrNewPNB0250+xP94Bis+Lo87k/qRgrtqR5W5bE6itaOaQX8Ba1s23KLV6J1GHsukzLukyqapG83qG2FyuF/UaQ+68dIOfapgdB/EDAbbuSXqHbWFrH3MPTIac95R2SxEDslmlQdxERKDrBBPGjRv+GdtmMO/xb3XkbsPgCy6vPqT1qbnv2o+5I4nVGsN5ZrSNRix2vivW/8pyz1emk8ZOY3K7VtEGozg+Z0MUiAwAtOWYy/RSpwzbUkMX7622inzwjVx0M/FqDCKrr+/L
 bsYs8d6L
 yjK/W8q0G4QvhxDTm+XDgkb9m1UFblcOR8MKCugXaEwsdyu1A5JocNSYGXDIuJFznh8fNpl8QVTEejGPZKiSYtaHH9Y75pIsttJp7lJQczDf1/zZl970DDzaskM0tCgMQqiyPGwOjmK+emgq8zHYJHP+0ZmxqaoAGlfm+FFkKlrwrSP5AD/icwJBGZSPCmvBTCnDfBKhZ9jeN4rXiJ/DmpHQrUTjOgir05r3uxfUzMAzeVEg+aYQ2NbuLvci8bB09qG3duDlpbQzu1/LW4SMZRm7yQAeJ09nBzmIhIl4o6nQaXDOeUqD/2FfWmilOG4e0bJsJF5E9BxlLsKecyP+IXRJt/0BfuEC6PVshcT73OZ+Dp9+bTBNjMbCiTC9K8lJ0Ii/t7kLMyyBAypKksCejbZlVMo449+NciesO81U4uMpdqPY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Ordinary allocations reach only common-memory zonelists. Compare policy
and cpuset constraints against N_MEMORY_COMMON, so nodes outside it
neither make an otherwise global policy appear constrained nor inflate
the constrained capacity.

All memory is common at this point, so behavior is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/oom_kill.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5d48bd862c27b..1ec22bdad1fd4 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -274,9 +274,9 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
 	 * get_page_from_freelist().
 	 */
 	if (oc->nodemask &&
-	    !nodes_subset(node_states[N_MEMORY], *oc->nodemask)) {
+	    !nodes_subset(node_states[N_MEMORY_COMMON], *oc->nodemask)) {
 		oc->totalpages = total_swap_pages;
-		for_each_node_mask(nid, *oc->nodemask)
+		for_each_node_mask_state(nid, *oc->nodemask, N_MEMORY_COMMON)
 			oc->totalpages += node_present_pages(nid);
 		return CONSTRAINT_MEMORY_POLICY;
 	}
@@ -289,7 +289,8 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
 
 	if (cpuset_limited) {
 		oc->totalpages = total_swap_pages;
-		for_each_node_mask(nid, cpuset_current_mems_allowed)
+		for_each_node_mask_state(nid, cpuset_current_mems_allowed,
+					 N_MEMORY_COMMON)
 			oc->totalpages += node_present_pages(nid);
 		return CONSTRAINT_CPUSET;
 	}
-- 
2.53.1-Meta


