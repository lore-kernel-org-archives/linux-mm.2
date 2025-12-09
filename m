Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF2E0D3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 14:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 331C76B0005; Tue,  9 Dec 2025 09:51:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E2856B0007; Tue,  9 Dec 2025 09:51:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220166B0008; Tue,  9 Dec 2025 09:51:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 114E96B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:51:11 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B29161DFFB6
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 14:51:10 +0000 (UTC)
X-FDA: 84200220300.15.C637FE8
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9754E40003
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 14:51:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765291868; a=rsa-sha256;
	cv=none;
	b=W0ss9lTzYPQJXDElEfx+/mCtl0UGxVJ6g4wFEryFGTCmZLR5RPYBHCpl87ITrA5PjJXSx4
	qbZGjTny0wcOQg68C2NkjYn9H6hlOihVsSVZy47HIQv0VpZSERTEmmQM23KB6j8OOO1kyT
	U30ojcFpeavmuoDnMjG2tnYHcNSqDrE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765291868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=2sSvg1E52OAdJO5CRmxBntMce6vBrVG3qTjPESUgVTU=;
	b=IKZg8LU9uGzYVW250oxFC6Zrj0NnlpY30kliTUkySnbMActJZCH69Blk+CQaoKu9r1dr58
	dbkle7ZG1n7/RUjMqsZQw73F68kbqvOiNUWWUVbR5RFYPHwEyuH4RSMRYCHcS3n5qs7lKk
	Z01wV3ZLF6ntitiBo66aXUTjrjsVvN8=
X-UUID: 78812056d50e11f0a38c85956e01ac42-20251209
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, UD_TRUSTED
	CIE_GOOD_SPF, CIE_UNKNOWN, GTI_FG_BS, GTI_C_CI, GTI_FG_IC
	GTI_FG_IT, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:5aca313a-6b53-4e05-8cc9-d8fd65a0c629,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:5aca313a-6b53-4e05-8cc9-d8fd65a0c629,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:d0969ff4c2f5e0348c8b557d1f52115a,BulkI
	D:2512092243430WAGPXSZ,BulkQuantity:1,Recheck:0,SF:17|19|38|66|78|102|127|
	898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:40,Q
	S:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,
	ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_ULS,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 78812056d50e11f0a38c85956e01ac42-20251209
X-User: lienze@kylinos.cn
Received: from ubuntu.. [(61.48.214.33)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1831383406; Tue, 09 Dec 2025 22:50:57 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [RFC PATCH 0/2] mm/damon: Introduce basic auto-tuning framework with priority support
Date: Tue,  9 Dec 2025 22:50:24 +0800
Message-ID: <20251209145026.3263754-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9754E40003
X-Stat-Signature: 96ja1s9xszk193zwqb8xeokicyhjwk89
X-Rspam-User: 
X-HE-Tag: 1765291866-979039
X-HE-Meta: U2FsdGVkX18J4RWY3NyRoKgU3XeK+o1K/sa3kwv1OLeIUowGQs7fK1BCtGOWHUXA8AUuhWKhJAiljKvcscLVNTir49PWgsWB35BUUJPNSzbDUX9Ax4eu77DexaEbaYm1kmL0hUIYGsc3ttXii4oHiO5Bcb4j2IZSGdFmXkoGGDN3pS4LDlz6rx/vs20u4GdsSVFHrxvbxSnb+sH8j7vTtnAMb+i1kIOW4On7jNOpiKpnFhRS4GcDm3XtWFMNCRkDmygVS4o97JFROQOa8aqaPgJJlR/XBhssljd0PiMwL9KESDZVKljy/HKxR6oQLm0j3KxLgRvjWIOYpQEW/k6rkgNTNplKuEjTYYE1mYcUJZcZ6yqcPLEpG48OZ1Q8maY8VEA8VJYq9c2Nct7uT4fHeoAs6KuRd99E43zcZKJcn9HTCNCPWRlUby0Z36otzAK9oiX7DoEYzsV676AecXghBiur1Wwo3s7FEvTjdVtysrzRjxgShPfmLHDGRauYdX0eTVpZI9iLvMAz8lWOKjzMekN1XvcvTRj4OisZ3+aBH52sDEqjEI0B9gp9cQBWfXJIAUw/dtk/3bfOFqk6aJ4EkFIeqKWrfP+IGTThjq52B5HWq5JV6QgRnhH4ZKEe15gc0O6KqhpwRABtOStjuqhNd0jYLyOKYnp9fpM3qdwXUN/v6zeQoHC7pZICU/v0ji8poW9h1imhwJ8EmRFRGTzBPBZ2VPT3TgPNiRh5MIwjcMKLpug+v5HEGZixyJaROeJzh9uc5vhyjfeD3OEufVlFX8dSGn2M0XnrPJ44H84uuUhRzpGNbG9rKlZ9eLQiUVXqpPhBgSyBESGvVeAN9WcigIk8p/DbhvLhYXot9FQz5L5dZvmndmLfroU+X+URscL92d+1bDmrC8lETLzBTK9pFq2stUv+EvHCmT5jd6na3U708/81kqz5yWrJfF4WuQMhjYSRCI+ehQ/m3ycPYU6
 DnycrpBU
 VcT6AteXLmR0t1jpdkeaUXQUrWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, users need to manually tune multiple parameters (e.g.,
watermarks, quotas) for different workloads when using DAMON.  This
increases the barrier to entry and complicates adoption.  This patchset
aims to lower this barrier by introducing a basic auto-tuning
framework for DAMON, which allows the system to automatically adapt
DAMON's operational parameters based on user-provided hints and system
state.

The core idea is to allow users to assign a simple priority level to
each monitoring target.  Based on these priorities and the current system
conditions (initially focusing on free memory), the framework
dynamically adjusts DAMON's parameters.  The initial implementation
focuses on the automatic management of watermarks.

While the auto-tuning functionality could be implemented in user space
as a separate daemon, integrating it directly into the DAMON kernel
subsystem offers distinct advantages essential for a memory management
automation feature.  First, it delivers superior performance and
real-time responsiveness by executing tuning logic within the monitoring
thread (kdamond) context, eliminating the latency and overhead of
frequent kernel-user space context switches and system calls.  This
ensures parameter adjustments can keep pace with DAMON's monitoring
cycles.  Second, it provides inherent reliability as the tuning logic
becomes an integral part of the DAMON context, immune to failures of any
user-space process (e.g., termination by the OOM killer) and requiring
no additional service management.  Finally, it offers a simplified,
out-of-the-box experience where users enable auto-tuning through a
single configuration without needing to install, maintain, or ensure
version compatibility of an external tool.  This kernel-based approach
aligns with the goal of creating a robust, low-overhead, and truly
self-adaptive memory management subsystem.

You may want to verify this framework using the following testing
procedure:

 # git clone -b v2 https://github.com/lienze/damo.git
 # cd damo
 # ./damo start --target_pid $(pidof <target1>) --priority 50 \
 --target_pid $(pidof <target2>) --priority 30 --damos_action \
 pageout

Enze Li (2):
  mm/damon/auto-tuning: introduce DAMON-based auto-tunning module
  mm/damon/sysfs: introduce priority sysfs interface

 include/linux/damon.h  |   3 +
 mm/damon/Kconfig       |  11 ++
 mm/damon/Makefile      |   1 +
 mm/damon/auto-tuning.c | 244 +++++++++++++++++++++++++++++++++++++++++
 mm/damon/auto-tuning.h |  10 ++
 mm/damon/core.c        |  11 ++
 mm/damon/sysfs.c       |  41 +++++++
 7 files changed, 321 insertions(+)
 create mode 100644 mm/damon/auto-tuning.c
 create mode 100644 mm/damon/auto-tuning.h

-- 
2.52.0


