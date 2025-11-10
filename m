Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE606CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 23:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD5D8E0008; Mon, 10 Nov 2025 18:20:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5108E0003; Mon, 10 Nov 2025 18:20:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 112068E0008; Mon, 10 Nov 2025 18:20:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 030458E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:20:25 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8DA19C02D9
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 23:20:24 +0000 (UTC)
X-FDA: 84096268368.23.A836782
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf12.hostedemail.com (Postfix) with ESMTP id CCD1A4000F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 23:20:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Txz1v+Iv;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762816823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hjnGKgt3w9/pB/cswaD8pehI2RAflAw/BUPrIWTcUcI=;
	b=Q2KR39z6WLHGes0gcExXFQMVrJ3yjzbdEEuh5QH7P0zts02WkiJEuclmt/d5n25HI9EXkO
	klcwxRxOT2V9mKIRVmW9iIDT1hrVFAz1x9bbCdjVtq0/y/JufdFJ9dLfO7jvMZRB6HVq4L
	T4/tjCrsC8Hqgn+lf0FkMcE98ZOV/OY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Txz1v+Iv;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762816823; a=rsa-sha256;
	cv=none;
	b=7dAqFdwLUmcUk1lWWOMbd3Xz1qxCFMcMtwf6D0UT7QItPG5kBrf3v8hhRSnX6XGf1u+hJy
	P5JbjYk9KjiBsIXOkLlX11bhdRcixV53aQPUUROq9Fb+L3x67SnYAf2TEnq/wKaMQ7P8fZ
	/Lqll2Fx6I7cyzbBy0iBm8Mw5wv71IQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762816818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hjnGKgt3w9/pB/cswaD8pehI2RAflAw/BUPrIWTcUcI=;
	b=Txz1v+IvOSQC0AVE5RL+lbiRoJXfy9JWLKyNM2SbMcL2mNzkxa6GfZja0hFiYL5iZEmXAm
	/jcEY762YjQ2dl6QWZ5hTUTfs186asirIiJWp9poY5RmDvEQ8TpiUG4LfPPzW/X4Ma1UNM
	65eK+ujABEKNeQ3UwZ5PgPW5c8yW/zE=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: [PATCH 0/4] memcg: cleanup the memcg stats interfaces
Date: Mon, 10 Nov 2025 15:20:04 -0800
Message-ID: <20251110232008.1352063-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CCD1A4000F
X-Stat-Signature: ydi34353eh3ed9pu59fr6kynqd7z8r6d
X-Rspam-User: 
X-HE-Tag: 1762816822-142701
X-HE-Meta: U2FsdGVkX19054sJGRdnOxEwUE/ZinJBL0fVaPFKd75Hra5knpDDBtwBHhHC0Dh7BtQoepInGuvobl52DWcs9xW06cczlOMbC3OLmQQ1EpvSIlJ7+7BH1pkMZbgUZGjwPPgPxZKBTh0MDShYayiE9GY+5Ui7Uo/OUsjlFrrj20r6X/7xpk/DY51RQ7tRJh9bCnPdnMf78hHy/N0kLN94aeLaUfVHEMpBlXF0vFWfu/B5sOHPgO5taXPITzz+KQQk4ZxzBQNi2IcpuiYIMgGnFbO/Wi/ovj4i0Ue4UDLE1P7CEp7czH+C/1Vey038t5xBExI1pIrchR5jf0Rgm3gM2T5xDj/VL4QXx6P2TM6IzvNsqhCeQezrmbZpKFQ0hROrK0lhGCLSJC7J7hgXYkxKOtmhF26t/HnlN16fAtLSkytIol5uDw6H+fBBYso6Kb3G0DBj3YvgJrwx2QAUVGUo3d2BrkgeD4dFO3Y3/4PcOwYilmPXbEoPT0Ax6OhJIqnClGfmlCdeR2tQJO889BPD2KulRr8CvMB0NUIqsthaRILJ//GTuGTyKvS+6P1e1gTC4vtAA30a2K9kI1qMpiaTn6JBfERk4mfwps07IOspHEpfUtKBKqteGSFWemVp23ifkFPpgwxe9nQi30LasliLgHAAzvPvxbsTPU9K3Sb23Rveai94s8LHmEMufUXQ7/L8DwPlQIGm9l++VbFrSfTB8sAw4M16U51820RiXiRAWwHes5ZO9qbHmAhs2PUiWhdy2ohGs8AJs0JAy/2MOv5iZRSluniRqyXo2r26y8wDAj+1TnNfYNSbY2y9IbjGOhJNGtMb2hQQUVn9vT1U4+ISDX/rqf6/y0hSBKnKcu/ikwbtS6uVvLUJIj19idh0as77jrjdzkrTraGFbY+SE3BciPkYrIp2jjSxOeTDJy0pRCwSmjkLci5e5/19hL+9T4YktxOGSLiKxs4Tg6UHv6P
 OB6ndj4j
 VtvkQHiQfSeKY+qj2jnX+VLnSf8IwOx88sqWyRnkxbpWE9AKtbH4bytCWZxQqQE4K5xOsalSElS4gv4vtEvGjrd9lh/LjAnCN/P/mC2/by/1E4GgYRYR5B1WamC9WOomxrFsptcndnHG0eR/KPV3YpXWvR1FpG323ZZHkFSXlOEn6oSmykOhgSjb/2G530AtXq6f6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memcg stats are safe against irq (and nmi) context and thus does not
require disabling irqs. However for some stats which are also maintained
at node level, it is using irq unsafe interface and thus requiring the
users to still disables irqs or use interfaces which explicitly disables
irqs. Let's move memcg code to use irq safe node level stats function
which is already optimized for architectures with HAVE_CMPXCHG_LOCAL
(all major ones), so there will not be any performance penalty for its
usage.

Shakeel Butt (4):
  memcg: use mod_node_page_state to update stats
  memcg: remove __mod_lruvec_kmem_state
  memcg: remove __mod_lruvec_state
  memcg: remove __lruvec_stat_mod_folio

 include/linux/memcontrol.h | 28 ++++------------------
 include/linux/mm_inline.h  |  2 +-
 include/linux/vmstat.h     | 48 ++------------------------------------
 mm/filemap.c               | 20 ++++++++--------
 mm/huge_memory.c           |  4 ++--
 mm/khugepaged.c            |  8 +++----
 mm/memcontrol.c            | 20 ++++++++--------
 mm/migrate.c               | 20 ++++++++--------
 mm/page-writeback.c        |  2 +-
 mm/rmap.c                  |  4 ++--
 mm/shmem.c                 |  6 ++---
 mm/vmscan.c                |  4 ++--
 mm/workingset.c            |  2 +-
 13 files changed, 53 insertions(+), 115 deletions(-)

-- 
2.47.3


