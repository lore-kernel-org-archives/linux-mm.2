Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBB73C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 06:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A38B6B0095; Mon, 24 Aug 2026 02:37:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26F8F6B009F; Mon, 24 Aug 2026 02:37:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C0356B0096; Mon, 24 Aug 2026 02:37:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD56C6B0099
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:37:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 32BD34045B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:37:25 +0000 (UTC)
X-FDA: 85135206450.10.BF5940C
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3372D180009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:37:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=DKFhCyrX;
	spf=pass (imf24.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787553443;
	b=v9/4VBT9bKv5C6db+VCHpZcvrfJVxtK/s8dAAkj0U2z6ZN0caFjXs0NNgX9pXd5RKGdMWt
	MmerbXnmeivbUDxMmcieCoE4W9j423hw4qJMtGLcA5hEYzimDLJONUozEBComixWeJqNff
	SYeDbdRkrwakwMFvFyRlHhERss9CaBY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=DKFhCyrX;
	spf=pass (imf24.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787553443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YoZYmxUiL1Mjzl5GKAt2FPQ4t7mEjRszWa8yWlQtOVo=;
	b=cY1mCO4Qg1V0UDS5OYadE1dsivZ60eBORW6xKrh7+mR4gmqmOCNv816mVSfbmDfT+DzyiJ
	6iqLQN51mnBFiY4aiA0Zm3DnCSz9D/v3anNOfmKZJXkcstYNXFP4lOHSqP8A/sbyBw9a6e
	l7JiT2kGsoN+S0eadFGZpeLbfns7P2M=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YoZYmxUiL1Mjzl5GKAt2FPQ4t7mEjRszWa8yWlQtOVo=;
	b=DKFhCyrXpytqlvHZG4S++sZJhdUbLqxUdStsmCEe3eX9ctG243jMTsz9pzReiVTPz2vJLLVTt
	4oAoAJ0izqx5nPOoh6aAS/dUv9RE1m7xoFjsDU3rjv8fF54mSEnWS4df9l+SPO1bfpnXG6uiKP2
	kgzhM9zx/fnidttoxVQgIlg=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hT1CD6Sl1z1K9BV;
	Mon, 24 Aug 2026 14:26:32 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 5866D40578;
	Mon, 24 Aug 2026 14:37:17 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 24 Aug
 2026 14:37:16 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <corbet@lwn.net>, <skhan@linuxfoundation.org>,
	<shr@devkernel.io>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v3 2/2] mm/ksm: fix advisor_min_pages_to_scan description
Date: Mon, 24 Aug 2026 14:10:10 +0800
Message-ID: <20260824061010.3343959-3-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260824061010.3343959-1-tujinjiang@huawei.com>
References: <20260824061010.3343959-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3372D180009
X-Stat-Signature: qjjoftzs1if671op8z6og158nyxbytop
X-HE-Tag: 1787553442-950306
X-HE-Meta: U2FsdGVkX1+H2usAP4RO8IQ5lhZuo+qmX3utnTme8+vOhigSozRVmqFaU/GZuLv0BJwojd1+5CxU5lg8hVsmXAFvN7+oqmTh8RTWf8X5CS8AkeEP7o/TXbH2TS0QBlQuNodtLHeW+3pA3C6sWonTqtj8b6w0Vq2W44cmmb+V0YeMCvZQT6UJwC9NRvLEEz7C7Hfy4hTJqo0afYWZpUJ/XIWadkm22BqTdclMwpgxkIdthiKXsLP3XPStCmNutFz+PY+Brh72HQSvfZ98/W6s9/nEgvpRdwIOcx1O6k0HI9lSXCF5PyKEHnEZxFkBbpZ4wDw+msxLuksIVqWkN/8ZmJ+fXQLqGdqkD8AaR7l1lxOtFOUXKSH/4i22/9DGOJXW2USu+JIlfzLbYQay7qnNkjTcdJYruSmwXwCQF1Kw7sdlR4cdO+U0ksu7vXZIuJebUcqdCR6GPuuMbUgwKH/j3TmCeS8PQTZwj6d+iicEPxUB8z09IbsKwNaJvcK3/OSIzY9btgreI3iUmscPn+wnTWZMfIriIzDIcysQJ/70+VSMUu8uqrCbp6a3STw+yuht0zT9gBLz6b5Autosf8fnmDyRmB63RBOTjh6/mmPA4Mf2p7LG+CnIie5uMP9QZ6jt9FmRx+aouQzEXwjOMngqasqjDs3Dh04wrHwtUgY5Ck9cY842Ct2smNa3D6zJ5Tol6IVoYbsjSJVO7uhEI+X2dfc3v8HrgNVEOSf4m/vLt1WYXUXMz6nFd4smNs+RM8YKO6wVZv9kkzSTJAubt8amdEatrZt50rjxtYZlJiAD+VtmfRAURqYt5D+poNTme3SzaCps00zjAj0qeTX0tcIz5DJJ81X6gqRoFFONAw+KRym7+UoQLhlLgkIS8HVnNz+QblHt4vQ3LV3pfc7GlLfWqT0uo31VkZ/5GFNDoCnLACi9TgPez4q8fi+4ayjImVP3Mf8Lt1X5a1PGtHzwRd4
 KXKQn/NY
 GhqjkMl9kSwiSnx1IQ7yRqyO/6fWvQhuPD8uLhXTF21ExbqxkQ7IGu3Ss2qyYUa76OlneDA5tzU7vGTPpV8yWEDwjMlkNRTmSet5puGxq+wQJy715JkRiKzISyJrNCzHxKtOtjxd+LAdfZeeq0zykVxXUvttIKhy6S2OhybZIy1dDQHjYQi8+tDsU/ShegJjWARq8dvXC98NP4/o5GNTHMhuo4gmkuD50+GhfoaWGQLcN63d1+iKCzZe2YSL5q6HonWx68qR/rX9I8LBaffJr3D8Ppdw8hse3pz/w8V6IkYdyEneFRZ3na3y7zh0ezni071sJjjyjUvP7CquFA1PzU1+fukcutJeMQg01FRcyvKb4GCY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both Documentation/admin-guide/mm/ksm.rst and the comment next to the
variable definition in mm/ksm.c describe advisor_min_pages_to_scan as a
lower limit of the pages_to_scan parameter, but that is not how the
scan-time advisor actually uses it. commit 4e5fa4f5eff6 ("mm/ksm: add ksm
advisor") only uses it to initialize ksm_thread_pages_to_scan when the
scan-time advisor is enabled.

ksm_thread_pages_to_scan is adjusted by scan_time_advisor() after a full
scan finishes. ksm_thread_pages_to_scan could be increased or decreased
depend on the real scan time is longer or shorter than the target scan
time. The min value of ksm_thread_pages_to_scan is only limited by
KSM_ADVISOR_MIN_CPU, so ksm_thread_pages_to_scan could be smaller than
ksm_advisor_min_pages_to_scan.

The semantics of advisor_min_pages_to_scan was updated in the v2 patchset
[1], but the documentation wasn't updated.

Update the documentation and comment to match the semantics of
advisor_min_pages_to_scan.

Link: https://lore.kernel.org/linux-mm/20231028000945.2428830-2-shr@devkernel.io/ [1]
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 Documentation/admin-guide/mm/ksm.rst | 4 ++--
 mm/ksm.c                             | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
index c9f533b10f6f..c329ca747b8c 100644
--- a/Documentation/admin-guide/mm/ksm.rst
+++ b/Documentation/admin-guide/mm/ksm.rst
@@ -183,8 +183,8 @@ advisor_target_scan_time
         pages. The default value is 200 seconds.
 
 advisor_min_pages_to_scan
-        specifies the lower limit of the ``pages_to_scan`` parameter of the
-        scan time advisor. The default is 500.
+        specifies the initial value of the ``pages_to_scan`` parameter of
+        the scan time advisor. The default is 500.
 
 advisor_max_pages_to_scan
         specifies the upper limit of the ``pages_to_scan`` parameter of the
diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..4a6cf8cf5d60 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -342,7 +342,7 @@ static enum ksm_advisor_type ksm_advisor;
  * Only called through the sysfs control interface:
  */
 
-/* At least scan this many pages per batch. */
+/* Initial number of pages to scan per batch. */
 static unsigned long ksm_advisor_min_pages_to_scan = 500;
 
 static void set_advisor_defaults(void)
-- 
2.43.0


