Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CFEDC88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:04:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1106B008A; Fri, 11 Sep 2026 04:04:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98526B008C; Fri, 11 Sep 2026 04:04:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D6CC6B00B8; Fri, 11 Sep 2026 04:04:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78CF16B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:04:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD5F8140149
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:04:37 +0000 (UTC)
X-FDA: 85200744594.03.B270455
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4E48D4000E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:04:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=Lmx/kq8bTkfOUR0NpajqFRfE+OtUq20iHIjDabLUh18=;
	b=iRLn9VK/mJBJe9HHVffH2n/M+vWsB4zpyFxvsfih+yg99ST8bu/TBhckRKODIKNf68Jt14
	ODyaa7FDrc6DiQQ65QGfgG06H4GCRbs5z9YbNUwMW2dDTZ8ENz6NwnY+CphYYaHuSACJET
	HWc/4m++hUeCs+dA+CbFzj4yZl/YsaI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113876;
	b=GsgVgQNeH66Igk6B2CGWDpoCAidc+9mC7TmLDPAcTdvb6hltO2+kFh30HTVLMAG9aITAE3
	5gLHPLeT4kc9K4a4GWrG/1aFPXL2FECIN3JWn8bONwfGcZaVHnPtxx7EbDAle+T76LRtOZ
	/PicUSpCKC84qwlSdbvVpak+QN5K/ZU=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4hh6Wy6T6vz8Xrrb;
	Fri, 11 Sep 2026 16:04:30 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 68B84Jf9021542;
	Fri, 11 Sep 2026 16:04:19 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 11 Sep 2026 16:04:21 +0800 (CST)
X-Zmail-TransId: 2afa6aa3b605ff5-a4ff6
X-Mailer: Zmail v1.0
Message-ID: <20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn>
Date: Fri, 11 Sep 2026 16:04:21 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <liam@infradead.org>,
        <surenb@google.com>, <rppt@kernel.org>, <ziy@nvidia.com>,
        <baolin.wang@linux.alibaba.com>, <nico.pache@linux.dev>,
        <dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
        <chengming.zhou@linux.dev>, <usama.arif@linux.dev>,
        <gourry@gourry.net>, <harry@kernel.org>, <vbabka@kernel.org>,
        <peterz@infradead.org>, <borntraeger@linux.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: =?UTF-8?B?W1BBVENIIDAvNF0gbW0va3NtOiB1c2UgcGVyLVZNQSBsb2NraW5nIGZvciBmaW5kX21lcmdlYWJsZV92bWEoKQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 68B84Jf9021542
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 11 Sep 2026 16:04:30 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AA3B60E.002/4hh6Wy6T6vz8Xrrb
X-Rspam-User: 
X-Stat-Signature: uxm4z4wyi5oprtotgbu4wrhif16ph5u5
X-Rspamd-Queue-Id: 4E48D4000E
X-Rspamd-Server: rspam07
X-HE-Tag: 1789113875-901925
X-HE-Meta: U2FsdGVkX19xT1UUsyDfi4UXthlBkV5BsO8YBV1YFv0QTjUHbkFwkEVLnO9wpe5xEwoxR/Wly4RFFuk8rLtSWbduPZjfv8VbH288wnWvrFXGDTYv7OwiMUiJc5Lw0wzm0keOMtP8aBAMN0arUyQd16M32uWbsD7QRmOkbbgxrTwpxzqCm9tKZmh4WcBPWKHCTC/hrYAoz3cUMbGl73e21A6vOJpxdG73ThIODNx6JpPxqXVtlS/MQ9WAl1dAIbC1iZMYnh5WuFLhX1I+7jJjyd7NEC5i6EceZaY4K5jwfcknvd+L8XflLR8dOoumVsO9jSo3Ocl5aNzfHsebkwswC0wOGQc7MWK+wvWuDrf/R9R4XLtE0m2yBC6yO7XnQIfb2dKoWzh5GxVzfe8KGb6RRPWMF2Hfkxx8qAaMf77fqn/csu0j3GMlguRzFp6Ah1nLRStv1BnjB7qtL9ribh/sold7WNHNkAtIR0BiDj2R2V21ytQsv+AgcGKBO+A+kR7OhrD/dbC/vhHqWPktEw6vRSQD8psbG1ePQsHj2AqK8zmvIsRj2j2tGCcp91szRoKIhm8lextaKl1fHOOWglPSI8o6R0YzIcy6BHa1bAsbOb6SUPsCi2NT7Z7rOTxK3vHnN24VguFk/eLX38srYS49vsNIFHftIYD6adfufwklcPbS22s3JJF75ywl7ylzP4yAQpVEE3IilWyRwntJV8iIiCZD4+F0PenAtxBj0sm+tpLKhUjyRbUeX7jcg+JKONdNDAMdAu44r8m4xM+COQ0IQmYMLOh5eToGBcg5NkU2ZvcQrFP/CiFLe+Hd2jZb1KGTcuHCOc8iT2AsPF3XYE/7UNjkMeeBHKkXkFL5czY7Pd0EQspBo1PXcbWPEdrWeqroPEBNkw1PmI8d7jXAaC29V0KQev6PvFNMeL4bCd882DoNjZvcqiWk+cfaEVjyA8mMWTIg4TWlC6ZYennYIh4
 oby/M7hT
 SposY2m5q7HXnlB3Bpc3TzSDRIGmVGBflvcuLKFeNsWwvtSCebCPDC/RwTh5+kSgBKNlvFOU8lAbHfp7ffcV98a7v2xSKXSreoxEHyajJ6E6uzvE5Vg7/FiYervGu34jTdOTznG0K08ZtMC5pmIS9ji0RHfCLeWr8h0iVBkFxPLvybqn6DvrMx/Xo8wYgTgb04GkjTzGwOisOUWM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xu Xin (ZTE) <xu.xin@linux.dev>

KSM scans VM_MERGEABLE VMAs and currently protects each scan with
mmap_read_lock(). Per-VMA locking allows KSM to read-lock only the VMA
it is actually interested in, so that unrelated mmap()/munmap() activity
in the same mm no longer blocks ksmd.

This series is organized as follows:

  Patch 1 removes an unused 'vma' member from struct folio_walk.  It has
  never been used since its introduction and is pure cleanup.

  Patch 2 adds a 'walk_lock' member to struct folio_walk and extends
  folio_walk_start() to assert the required locking mode.  Existing
  callers are converted to pass PGWALK_RDLOCK, so there is no functional
  change.  This prepares folio_walk_start() for callers that hold a
  per-VMA read lock instead of mmap_read_lock(), which is needed by the
  Patch 4. No functional change.

  Patch 3 tranforms the boolean 'lock_vma' into the enum 'page_walk_lock'
  without any behavior changed, which is prepared for the Patch 4 to use
  per-VMA locking. No functional change.

  Patch 4 introduces find_mergeable_vma_locked(), which uses the
  universal per-VMA locking helper vma_start_read_unlocked() to look up
  and read-lock a VM_MERGEABLE VMA without taking mmap_read_lock().  All
  KSM call sites that previously used find_mergeable_vma() under
  mmap_read_lock() are converted to the new helper, and the locking in
  get_mergeable_page() is switched to PGWALK_VMA_RDLOCK_VERIFY so that
  folio_walk_start() can verify the per-VMA lock is held.

A microbenchmark was run to measure the time KSM takes to merge a
victim region under mmap_lock contention. Under interference from 4 churner
threads, the merge time of the per-VMA KSM-optimized kernel is
significantly reduced by 50%.

Xu Xin (4):
  mm/pagewalk: delete the unused member
  mm: make folio_walk_start()'s locking asserts scalable
  mm/ksm: make break_ksm() more scalable
  mm/ksm: add find_mergeable_vma_locked() to use per-VMA locking

 arch/s390/mm/fault.c     |  4 +-
 include/linux/pagewalk.h |  2 +-
 kernel/events/uprobes.c  |  4 +-
 mm/huge_memory.c         |  4 +-
 mm/ksm.c                 | 85 ++++++++++++++++++++++++----------------
 mm/migrate.c             |  8 +++-
 mm/pagewalk.c            | 10 ++++-
 mm/rmap.c                |  4 +-
 8 files changed, 79 insertions(+), 42 deletions(-)

-- 
2.25.1

