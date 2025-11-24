Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B82BCFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 12:39:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9CE96B0022; Mon, 24 Nov 2025 07:39:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D74946B0024; Mon, 24 Nov 2025 07:39:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1CD6B0026; Mon, 24 Nov 2025 07:39:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3F1C6B0022
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:39:14 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83102C034A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:39:14 +0000 (UTC)
X-FDA: 84145455828.07.09E64FD
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5672B10000B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:39:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763987952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=lUe/xF65odkCtqQf4pXAiJD/g+wTm4zBse3sMFMIs9I=;
	b=nXdNytiNlCkKAEzpFeYomzK/HkwhZ2PIA3jW1nQL6vBz7Z9swim90kTimMZbfxpcNOsBN3
	AvVBbG6hVbzcEde0hqzDbUY7uxyuGHcYmtd1AdOtlvcEOuVzJzTdk25vQyTtRO2AA0bZoM
	Xd9EoJnjgY6+JB7NbKc+LnGrr2Wgdj0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763987952; a=rsa-sha256;
	cv=none;
	b=DjUTNSuN4JC5d1rVdqEoJ6ObAvacNIE9vz5zgeo1SM7VXNbiVfCT/Ht65wHD0yitTr10Yx
	8GbsuOua59u15g7Oz/1555mQzj/MSAr0H4gxD6whjSJbdzaqaUgwEFueGuXfs5Og4o+L23
	xnwdVHKvMQ1WUf0yfsKuWw41La2DP5k=
X-UUID: 8b4ad87cc93211f0a38c85956e01ac42-20251124
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_TXT, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:88bebdd3-d934-44fa-8b73-642896c7f9ab,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:88bebdd3-d934-44fa-8b73-642896c7f9ab,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:f8a3e4e67c69aabc7ababf260f050834,BulkI
	D:251124203903YDS2QYJG,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8b4ad87cc93211f0a38c85956e01ac42-20251124
X-User: zhangguopeng@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 368504848; Mon, 24 Nov 2025 20:38:57 +0800
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	mkoutny@suse.com,
	muchun.song@linux.dev
Cc: lance.yang@linux.dev,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v4 0/3] selftests: cgroup: Enhance robustness with polling helpers
Date: Mon, 24 Nov 2025 20:38:13 +0800
Message-Id: <20251124123816.486164-1-zhangguopeng@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5672B10000B
X-Stat-Signature: esimftafk9cgtko61yqo7ba8djp1pi5h
X-Rspam-User: 
X-HE-Tag: 1763987950-841079
X-HE-Meta: U2FsdGVkX190YVH8lu24+9qelopm52jC5Kmo8X8p2COubvLaVET4bjfFpdeQlUGcAYzI/zLBr+4uBN6UANhonanu8RcsT1V58G2Cat245NpFeNIhiwVsEYH6roqhe8cFn4lLG3utIwEu1ggLVNSF5phzEwkdDvMF4+xtRzdtt/CrXfDbyTb5x1eD6MmfM6E4bMKPupS9ivReZRVXx+HZlF7bXLun73s+7zlBx7DAdLJy+8YyXnaTq+lu2G+gvMZLKOQbnYvaYS9L9NCJK7W+jtQHO/DMJL8xWQu9dvqXdiuMfLLjGvPNX1fikphV6FciEdH2nb/XxnosaB0EBMPlnJ/mp97BiTqfkClCID/mQ3pz0wewhExMqxLyZP225CFQOcyxmcwmQVpWfa1phqeJEGcTEDzQ+Ofn8xFjtbE3TkIjocDUINgBuIY26J6J4nzIJrNWy9L44wYxkboM+A7PbBQWqLiFqBaxscLh3ofQvVyxZtrNb6q8yM5hQijNg32nSmyelvddw2732o6hKFVp8KxEBWkAQ52VvBa5QuQAGkOxg045K4afXebVUvhfMfKaN9Nn2VzK683iH+6FQNgFMOqZKPFfrPPpyzWGGaj+D8YGCzam3uqjOK3WDfS0uso5df8Jd0sIorsLOfINbpW7RnInQed+LjR5T/wuM3G015u5d3fx6qlFEPI7IZgrVZOUwzxZHIqRC+NeQ4N4bbRVDixyhTTIXI73LnJDCgSCvn6jma0fF9bfKiPb0UrTgxjJsms+/uG35KFNK386FBGwzMVl+Cx32UVum32ZD2/Mf04uwTYHVwGFDdnLc/LM6Asb1yFnA+gNLiM6VFHQk+PjmCHyy2j01BJi6RAXv8zMJ8v5T+fK89Qfh/46IWYUtPVDAd4zII9IZr8qJAqmE+vH+ej/nANAAgc+x2AWG+IyS/kcbma22TMlQR+pNCKcbFn15VXwRfsw7/59pdPwslF
 DxyKn3D4
 e07tG4WbVOBf0Kq5tzWxnzz1mJMGq1wjPOz1+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This patch series introduces improvements to the cgroup selftests by adding helper functions to better handle 
asynchronous updates in cgroup statistics. These changes are especially useful for managing cgroup stats like 
memory.stat and cgroup.stat, which can be affected by delays (e.g., RCPU callbacks and asynchronous rstat flushing).

v4:
 - Patch 1/3: Adds the `cg_read_key_long_poll()` helper to poll cgroup keys with retries and configurable intervals.
 - Patch 2/3: Updates `test_memcg_sock()` to use `cg_read_key_long_poll()` for handling delayed "sock" counter updates in memory.stat.
 - Patch 3/3: Replaces `sleep` and retry logic in `test_kmem_dead_cgroups()` with `cg_read_key_long_poll()` for waiting on `nr_dying_descendants`.

v3:
 - Move `MEMCG_SOCKSTAT_WAIT_*` defines after the `#include` block as suggested.

v2:
 - Clarify the rationale for the 3s timeout and mention the periodic rstat flush interval (FLUSH_TIME = 2*HZ) in the comment.
 - Replace hardcoded retry count and wait interval with macros to avoid magic numbers and make the timeout calculation explicit.

Thanks to Michal Koutný for the suggestion to introduce the polling helper, and to Lance Yang for the review.

Guopeng Zhang (3):
  selftests: cgroup: Add cg_read_key_long_poll() to poll a cgroup key
    with retries
  selftests: cgroup: make test_memcg_sock robust against delayed sock
    stats
  selftests: cgroup: Replace sleep with cg_read_key_long_poll() for
    waiting on nr_dying_descendants

 .../selftests/cgroup/lib/cgroup_util.c        | 21 +++++++++++++
 .../cgroup/lib/include/cgroup_util.h          |  5 +++
 tools/testing/selftests/cgroup/test_kmem.c    | 31 ++++++++-----------
 .../selftests/cgroup/test_memcontrol.c        | 20 +++++++++++-
 4 files changed, 58 insertions(+), 19 deletions(-)

-- 
2.25.1


