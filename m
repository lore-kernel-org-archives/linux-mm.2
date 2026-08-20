Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 191C1C5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 14:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 031036B00A3; Thu, 20 Aug 2026 10:30:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 009CC6B00A4; Thu, 20 Aug 2026 10:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E61396B00A5; Thu, 20 Aug 2026 10:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BCF2A6B00A3
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 10:30:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E507A01A3
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:30:08 +0000 (UTC)
X-FDA: 85121882496.13.3B09564
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8D09C80013
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:30:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cklXnxG3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787236206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CwOwRzT4HLDPVaiVOwZWwo/iTTnMhyol3+iVtiyVzuY=;
	b=dcRhoTQNRst3Cd8EIjhyYRlVY6aWgpE6qLhk8PVgMirh7syDacyZfD4KvEOuZNbCs65Ubb
	Nbub/9ZBjb6jbtPqVzP82Pd29Y99+7wxGzhuJSmbB3HEtjfxCbflaJxrfq4P0cnDnkIkOk
	EzLFb56PCi9HETfPHARGSW1C09ydMkU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cklXnxG3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787236206;
	b=5dVItdq/+qMnCbgJoKXtlnirPPiWm4L0WUJpMnGamNf0vJjOFITT7guISuD/sR6uFVjL4d
	cs4qTscxPeSb04kj3mpn1NtkK8XVoJ5+dLyB2uUXCZbWgPQbiO0XdT5atv/ScTAaV3Vnp/
	Gx3OZIGdERQq+UdpGl2vTa3xNG3HvE0=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38e69bdb0fcso1918741a91.1
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787236205; x=1787841005; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CwOwRzT4HLDPVaiVOwZWwo/iTTnMhyol3+iVtiyVzuY=;
        b=cklXnxG3N2sNLpBfqmm/xlxjY/2tgi+3G6KQ3+ZIbEvbkatFHzWWqCg/Im5zN7kpwk
         5mTU5rPoCqXaSxYKAsE+UiMG3BGQZAUukGOQF2qPzGDHcjz1HrTppRqNYEDhZXPfTDIa
         IkEtBgzMHY3hkAe/Kj01ZjNV2IvRJoPD24QZAXKAocW4FDFw794rfOo1tU9NzRAhuJtf
         7kmKEf5rGu7M2IWospH96ctKksDkLQltcj3EFO05txzseFIdBbIXlS7T0MxQmv9PcmhY
         1wkb6n93txbVaBXWxtCaJnZvTfq18TFEYmEU8oMWfzNitSP9XAGkb3kdldtWSp3VH2qH
         J94Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787236205; x=1787841005;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CwOwRzT4HLDPVaiVOwZWwo/iTTnMhyol3+iVtiyVzuY=;
        b=KnoUH8QV4bhHJbt1aFJoXJOAR+XJ4EiTwFVBQRkC08xAZEDLkJ4FHCO+1l3607+rmJ
         /9O2pw+nSw/eIeVUYUOr95jSVKTzJqidEN63JllmtsPU9hbHllvBz5o2f7ToDH3THCrN
         0aoiDy4SfpU7OrWQwh3VpybPQ0W/BhXWKWKIwS7y/HPEZW9HbQGtA6eFaG6cGjW6uj2H
         g9vP4MpoSZsRMpi8dDas9M0t98HkkK/D5nxZGRz2bUjvERW92ZoEh1OnS5cm/1n9t25q
         rMRszECs1elEsmFxnmHMpKsh77kfa3PO9ddBipSxhcbRl4kK5UiEOoOQD1X12c4ByG98
         q+Gg==
X-Forwarded-Encrypted: i=1; AHgh+RqUMs2McPClaLD6W+MbZrRgDTU9aE32jTVGPy9xrEyRnq6Q/JjBL4/5UMjAFbcPzmeGsEKsiJZ0xA==@kvack.org
X-Gm-Message-State: AFuF++nMu02LKBrl9pDjfN8Pz4Ur833znOVWzrHb3U2TNhHL/zqnG7gK
	AioZ4+ENFV2HyNwgiCeCxBZZWMstfZfn6p3SPte7IjfullFxzK18Bmwo
X-Gm-Gg: AR+sD12IokKmjbQjzUDp5dIb6AgsHLyV5A3NMbVcVcEPfeirnfWlGY4PobBt8UgQaaW
	KqZv/h5i0fzoP8/ICpg3pEGb/GVmyp4LerGuQl8zT17iwIdUpZqfxDhCV42rx+sCvBQ47Dyl/JT
	nnjCiZm1+sADWfGggn9+jYBuXCGNx2cOtgT+jL6GxX4gduCWoWXQHTEE2QMGUlS5YAkd9hj6QQu
	+uUH7gW1YWkp8MKImCUbR0tOqN+IZYYnGR5zyLunsF3r3arB7PON79YtyNAxJjgw2cdFhgdwH8a
	OVNlh/AuYJiB/CZUh5jrgz8kxFrVqt/MwW+ql9h5+Teb15bGtl5+q2c+tLGg+NFvc1GbCams4iE
	Gud15+GiOt0dcS7FTnjdK4ElEmNui5hhIdR5MmJ2sHVjca0MhSkgIXHU/ZikTY2ebVCGzPoQuYk
	694XXyzjRSqz3WP4X1MZ3vSBhl6oQT0549ZWvvJEclS7rgRB/rF19o8wXVsFiL7U62ubN+eCURt
	Dw1TKV3wmnCNRoG4xv0rCP+Lw==
X-Received: by 2002:a17:90b:2b8e:b0:38e:75f3:ad4d with SMTP id 98e67ed59e1d1-39580f03c97mr25649224a91.7.1787236205247;
        Thu, 20 Aug 2026 07:30:05 -0700 (PDT)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395a9bc47ffsm1036780a91.0.2026.08.20.07.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 07:30:04 -0700 (PDT)
From: Wenjie Qi <qwjhust@gmail.com>
X-Google-Original-From: Wenjie Qi <qiwenjie@xiaomi.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	baohua@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>
Subject: [PATCH] mm: filemap: tighten dropbehind completion context check
Date: Thu, 20 Aug 2026 22:29:56 +0800
Message-ID: <20260820142956.1414337-1-qiwenjie@xiaomi.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8D09C80013
X-Stat-Signature: nndo1hgonhtub6oorr4soj98j19oeq5q
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787236206-176904
X-HE-Meta: U2FsdGVkX1+dYI0seUtGsmlbWIL2dIaZ4v5Prqqf/OM9eEoVMQblcTAoBVMO7xh7o/bL2vUtd2Vu0hRejlthwxa4bopBAv2YRuevMLf8N5YOhlqxnUqM0HnYukAtxOuKNEo1lIB0/Ty50NlcSz11UXGHrKjd/cXDHVog+fpepHJ9IaUA74EtRx7weiUWE3/Jhe+vPiTm1c43fcAtSbcYzI7E8M2lvS5lyT0ZqRgAJfRe9ItYTbaoa3AR7gUji9j56DQYFsUJRc1xD8uSEgY+slyMHv7WOIvq/p/JUn5KZGYdYw0TVn1MD3DCO2uMuidA0p+6AL+JkrvPaoFRVwhLJ8PrXufzZC0fksMYv2dKkEGqCsqqfjRcWZjToygFG77v6IVTlF5/9WIyF8RADi1InsmF+ofZaCWFWml7HubVo8RB5aTmOMKi3Mk+BOxrJrbFGhPA9VstEWyH4QLi/d/B5NDsKS61My8oV74yTEqk1VVo4OrfSjzvlplQY/zDpZEM6m+Rc5avbykp1kTwHocEW5OQLm1sKupASpP00TpID0CPbk64/Zn/s0dgMCJ2ZZtREWxEyke4qPXBd0Yri9ZOTCvTMmvDBhicuMQuBm7tGyI5MZ6KLHsMvagYBeesjceTuHhi8zqv4FQcVkrBRYnGaEp4bBqKxWxvBrGxmOOOMt3J4dxabOU149Wp9ELnwQ5rrrN1O0nypAv9ZI3q8D+O6iRJccVqcl8B1/jPtVaKPVGtqHh0kxx3syPbNLXVj9KDGFzbQ+gunj63MkfycWuhq2lnd+aNKpjoA5AsLy0knnPgfKCgQMqWL3P4h4bfGuiYNAtjlCYARt3QJ8zV5M3D7R3ykSg+pyydRLoqvZE++OU4bnbvor9Fw49kQmW2g2PupyO7P6Bj3baKli+xOIlIWoV8xga7/XMRBUsjRRUykP9e/0SUFeXG876vY3O7DXSri/yFoXsdeceHpKpASQy
 5jxvdhh/
 +nyAtPqLsTqYk+qIxhgS0b1xJRjzG5WGhJOpYXHcsrGYnS0JSF6trcxKqRh+iLBCVc0Gp0QPnjHQELLskazlzVtTxK02smOrXlNGgkxbUt73rJJfLJgYMruuG3Ct7YZXskfjl03WumdIT9OVfP1vTEQWNIpA8Xnn4Elg9qwyGtv8tJeFISy9kw8/qeyPhO5PHEFFuntxSsfVQA7ujlrQCNmHPVUdxveVWB5PuUwIvn5vK7aQD8kPUKKN/7di+walJiGOacisxdSg8yLjU9sSWYdgLLSKbkbpyyonL6OAt0Q9qDaSru65W+8w9OADOAiSVXu/mxGyGLbRgYKJM5CfwkB/Si4lkOJEXKg1GJER4gM0AgzeY8TMwWz43ePI5TdiRQadAkm5JMupJohdQUOBV7k1JbSze20MdMnF0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_end_dropbehind() uses in_task() to keep folio invalidation out of
interrupt context. Task context alone is not sufficient: preemption can
still be disabled, or the task can be in a preemptible RCU read-side
critical section, while filemap_end_dropbehind() may reach
folio_unmap_invalidate() and sleep.

Use the established conservative three-part atomic-context test: reject
preemptible RCU read-side sections, reject configurations without
PREEMPT_COUNT, and otherwise require a preemptible context. Unsafe
completions retain the existing best-effort behavior and skip invalidation.

Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
---
 mm/filemap.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 6afec6368..0616057e6 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -45,6 +45,7 @@
 #include <linux/migrate.h>
 #include <linux/pipe_fs_i.h>
 #include <linux/splice.h>
+#include <linux/rcupdate.h>
 #include <linux/rcupdate_wait.h>
 #include <linux/sched/mm.h>
 #include <linux/sysctl.h>
@@ -1620,6 +1621,15 @@ static void filemap_end_dropbehind(struct folio *folio)
 		folio_unmap_invalidate(mapping, folio, 0);
 }
 
+static bool folio_dropbehind_in_atomic(void)
+{
+	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
+		return true;
+	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
+		return true;
+	return !preemptible();
+}
+
 /*
  * If folio was marked as dropbehind, then pages should be dropped when writeback
  * completes. Do that now. If we fail, it's likely because of a big folio -
@@ -1631,13 +1641,12 @@ void folio_end_dropbehind(struct folio *folio)
 		return;
 
 	/*
-	 * Hitting !in_task() should not happen off RWF_DONTCACHE writeback,
-	 * but can happen if normal writeback just happens to find dirty folios
-	 * that were created as part of uncached writeback, and that writeback
-	 * would otherwise not need non-IRQ handling. Just skip the
+	 * Hitting an atomic context should not happen from RWF_DONTCACHE
+	 * writeback, but can happen if normal writeback just happens to find
+	 * dirty folios created as part of uncached writeback. Just skip the
 	 * invalidation in that case.
 	 */
-	if (in_task() && folio_trylock(folio)) {
+	if (!folio_dropbehind_in_atomic() && folio_trylock(folio)) {
 		filemap_end_dropbehind(folio);
 		folio_unlock(folio);
 	}
-- 
2.43.0


