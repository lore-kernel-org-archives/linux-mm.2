Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 638FED12D4C
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 11:57:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B82C86B002A; Wed,  3 Dec 2025 06:57:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5A436B0062; Wed,  3 Dec 2025 06:57:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A97E06B0088; Wed,  3 Dec 2025 06:57:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98E336B002A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 06:57:20 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 44E9351A5C
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:57:20 +0000 (UTC)
X-FDA: 84178009440.06.99A6140
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf25.hostedemail.com (Postfix) with ESMTP id 21567A0010
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:57:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764763038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=ecpNQdXf41snpkLyfzcnnlY/e5tlxah9I5EKanLGJto=;
	b=kE5wuzdVb91nWkJWS1NRNPpfJSM4N5QD/UOKe8FsRMjJxlD4RjGgUDfCXpmd9vwKnupUts
	iohNS+ylTsCZBpvjAMJbewfP871+EUZDcATkOBXCRwGtm0k3Vtq3X/VYfsYyWD95Gnzip9
	iscg1SLrvqHOMvJAJkaakQAIL8ViloI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764763038; a=rsa-sha256;
	cv=none;
	b=8iKWeF5X8VDqDcbJ1Gph659idy6+NjmGmheuJMYSuNd4H3Oxf5rUV6WD0QQKGM2Bx1FQNV
	/2YKPaScGJR8XNhtmoL2joS/30FCtf8FIr4M70rhHdrR1L5+Bvs+Gspu2EXNhCsLpt+yF7
	o92ryryfvYpWs2DvIToFulkQ4tbLAqk=
X-UUID: 2e8cd32ed03f11f0a38c85956e01ac42-20251203
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_TXT, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_C_CI
	GTI_FG_IT, GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD
	AMN_C_TI, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:1f63d534-3ad7-4486-b2a6-722f38e3e2ba,IP:10,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:0
X-CID-INFO: VERSION:1.3.6,REQID:1f63d534-3ad7-4486-b2a6-722f38e3e2ba,IP:10,URL
	:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:0ae958454a45d2f48fefce17dc0a4c5d,BulkI
	D:2512031957094HW49S03,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:
	nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2e8cd32ed03f11f0a38c85956e01ac42-20251203
X-User: zhangguopeng@kylinos.cn
Received: from localhost.localdomain [(223.70.160.239)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1478738078; Wed, 03 Dec 2025 19:57:03 +0800
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	roman.gushchin@linux.dev,
	lance.yang@linux.dev,
	shakeel.butt@linux.dev
Cc: muchun.song@linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v5 0/3] selftests: cgroup: Enhance robustness with polling helpers
Date: Wed,  3 Dec 2025 19:56:28 +0800
Message-Id: <20251203115631.947908-1-zhangguopeng@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 21567A0010
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: m7r8n65c4otwdgr1qjm8zfpem36h95wi
X-HE-Tag: 1764763036-828713
X-HE-Meta: U2FsdGVkX18djeqxPTLrl/5u7VGh7XUgPI6jam0v8JVG9mO4FQyaBmoYBhuM412zaJiWbkY18YUHK1FKPce91ZbIR92dUL2OWQT+8LWnGVK4XhWFi7CLBoJDwlxr/x7rGiUvmmGzvY4NPNh4WXbuG/SW99W4miJTPDTuG02J2AXoJY2xv5dToh5G8r9Uzzh4vxLv8+v5B/OIiFDeZT+RNglwjrGEyAWgQeishPuyLoQqOZ0q+I2s718cEUDqpab5hQELXkySzsWhiizYq7hpE34pRmiNnoH3LMDj5e5YPra7vuFv9Zc42gQ9pkfh9dlqnmvhwwMgFPeYcY+tMvotrCs+tWpNSmkU/zZH65YcgfQZTvTShka1H06HYQaEanQ7u6U7Ylras+yLu//WyluGZscaSOHCUQAxfueAarU0j1uAuMlCc5oN1Jx0tiGSvd8uxAghBN1ysizHwV+t6JAuuTSVZpD7GDKC2zGIHcON9wmoojfsZMEpUXXfI9Uf+uxfVQV2AZn330Um1ckKpzdkZ7uB5ymw3s70ygoBhtnyjN23U7otQHubx+Y9IFu7rgv+NCeYgGLMwqV7uUA5dPlohDz423r88BXXC2UNiiDYZMFLlQkoaaeAu87QDqpFq1RazFW9wTxcfdjMcYV3byZDRU+EsHQSaFHt4PSvsIJ03oaon+kJ2L3nyp+KO7y2MVvs/7tD6yPqWS+bFLUX7TPmzHYIamJL+/YuN34gdsI/jdoakD5INTmyWevuxiluRPV7S7umpig5ogLC+plHORSYX8i6N3LHZ04wG6gRN6pVWTYM1pPJVL2vIDgqBh4xRrjhHExVemDcpN+Mfoo85pQB9p0pyk0TI8YOGJ+0tcnsx2Y0xoJJEcd9t9jBEhbQCJaUbqH2oBLXHL2i8CS5g8vbgO3S/p1XHmSqg7FmxOH4c8/ri6wK59bAl3n1ltUAxcGVUQuAfE62Z9ZvjsLmsFE
 gMILSVfT
 F+pyukxTtO0mNHCElnzSdd4l5fT5O/0KI6eRja22SCq766V/O21yXvmtIyCJXIIEC8YxKx4ULN78CkNJwOeYgzwhb/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This patch series introduces improvements to the cgroup selftests by adding
a helper function to better handle asynchronous updates in cgroup statistics.
These changes are especially useful for managing cgroup stats like
memory.stat and cgroup.stat, which can be affected by delays (e.g., RCU
callbacks and asynchronous rstat flushing).

Patch 1/3 adds cg_read_key_long_poll(), a generic helper to poll a numeric
key in a cgroup file until it reaches an expected value or a retry limit is
hit. Patches 2/3 and 3/3 convert existing tests to use this helper, making
them more robust on busy systems.

v5:
 - Drop the "/* 3s total */" comment from MEMCG_SOCKSTAT_WAIT_RETRIES as
   suggested by Shakeel, so it does not become stale if the wait interval
   changes.
 - Elaborate in the commit message of patch 3/3 on the rationale behind the
   8s timeout in test_kmem_dead_cgroups(), and add a comment next to
   KMEM_DEAD_WAIT_RETRIES explaining that it is a generous upper bound
   derived from stress testing and not tied to a specific kernel constant.
 - Add Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev> to this series.
 - Link to v4: https://lore.kernel.org/all/20251124123816.486164-1-zhangguopeng@kylinos.cn/

v4:
 - Patch 1/3: Add the cg_read_key_long_poll() helper to poll cgroup keys
   with retries and configurable intervals.
 - Patch 2/3: Update test_memcg_sock() to use cg_read_key_long_poll() for
   handling delayed "sock " counter updates in memory.stat.
 - Patch 3/3: Replace the sleep-and-retry logic in test_kmem_dead_cgroups()
   with cg_read_key_long_poll() for waiting on nr_dying_descendants.
 - Link to v3: https://lore.kernel.org/all/p655qedqjaakrnqpytc6dltejfluxo6jrffcltfz2ivonmk6lb@bxf5xlgo4iw2/

v3:
 - Move MEMCG_SOCKSTAT_WAIT_* defines after the #include block as suggested.
 - Link to v2: https://lore.kernel.org/all/5ad2b75f-748a-4e93-8d11-63295bda0cbf@linux.dev/

v2:
 - Clarify the rationale for the 3s timeout and mention the periodic rstat
   flush interval (FLUSH_TIME = 2 * HZ) in the comment.
 - Replace hardcoded retry count and wait interval with macros to avoid
   magic numbers and make the timeout calculation explicit.
 - Link to v1: https://lore.kernel.org/all/20251119122758.85610-1-ioworker0@gmail.com/

Thanks to Michal Koutný for the suggestion, and to Lance Yang and Shakeel Butt for their reviews and feedback.

Guopeng Zhang (3):
  selftests: cgroup: Add cg_read_key_long_poll() to poll a cgroup key
    with retries
  selftests: cgroup: make test_memcg_sock robust against delayed sock
    stats
  selftests: cgroup: Replace sleep with cg_read_key_long_poll() for
    waiting on nr_dying_descendants

 .../selftests/cgroup/lib/cgroup_util.c        | 21 ++++++++++++
 .../cgroup/lib/include/cgroup_util.h          |  5 +++
 tools/testing/selftests/cgroup/test_kmem.c    | 33 +++++++++----------
 .../selftests/cgroup/test_memcontrol.c        | 20 ++++++++++-
 4 files changed, 60 insertions(+), 19 deletions(-)

-- 
2.25.1


