Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 345B4C79FA1
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 01:57:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08C9B6B008A; Tue,  8 Sep 2026 21:57:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 064236B008C; Tue,  8 Sep 2026 21:57:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6406B0092; Tue,  8 Sep 2026 21:57:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFAA26B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 21:57:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5BCEE1607E0
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 01:57:18 +0000 (UTC)
X-FDA: 85192561356.28.F2547F8
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id 47C0A40003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 01:57:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WYg9XNmx;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788919036;
	b=7xVQAH+ltOWdc4hAMrIL081XMaanucNAFlMclhae16M1eo+zoRwqaJRAn7GepunsM3v+yL
	7/cU/6RHW30GxtUslqM7c75eQ+QwELGDkqPWana/4/gk0kqXcJ6+8UjNKsYDVDA0H+RdhC
	b6YnuIACVtSbSSIxXheMMBHiaoCsqDI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WYg9XNmx;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788919036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YJX4jMGPn68Bg3x4fB66fOlpPyQ7Wwc4MaKVzswffK0=;
	b=T6iiAJezM5feb9viG51AMyygQqb0STSSV80Nyj2iS7+xqULRztINzE01yloxRrKyNRTqlU
	9lcYbN5jMjA1NfFEc6wm8IpA1wxmxW3L8hxH0CVU8v0BEmhU5hYEm8QszPmgG6AlpHMaBo
	JFzdOyXFrbs6UYErsWX3c3TY43dcGpU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788919032; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=YJX4jMGPn68Bg3x4fB66fOlpPyQ7Wwc4MaKVzswffK0=;
	b=WYg9XNmxl6vWpDj7ZU7mhhAHh1K5x3hWbrRAg+JwLNRcrUIFMJH8ntrG1PVdhszW3bWoCHvycHkCCpkzhUuZEH5N38P+giJxDKNfSa98CvKCVYx8Cd0FW0f47OOwlAsqIS7TQGCY6aJuiLlpiNQoHhOcbbhMys81wrx1EWyRbDg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XAdOQaY_1788919030;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAdOQaY_1788919030 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 09 Sep 2026 09:57:11 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	ridong.chen@linux.dev,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH mm-new v2] mm: mglru: clear the reference counter for rejected folios
Date: Wed,  9 Sep 2026 09:57:04 +0800
Message-ID: <9214e36bf738fcfba86acc8cea85dff4010f66b0.1788918714.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 47C0A40003
X-Stat-Signature: yemj5fb3scx3hkayi7b7mecb435uysks
X-Rspam-User: 
X-HE-Tag: 1788919034-888875
X-HE-Meta: U2FsdGVkX19dpszP8XeFZWLe9EuvLZEHS3GaQYpFQ/93SHkN3EHCT3LzZYGEoAo5KyufoA8zK1x2R+uKqygB+Wbk3dOLVf39wDb0bTL5+JMX7kqFrQFo4zsHm4Zh+CYO3S76+/cjIdPKIticrH5g+cVkjphveszqfup2zAyzAgArR6peI4jjpg/MkaKH0TvnioQDqxV4h9P3SoFScl6s2NhvotESe2TSV1aSKxMf/9h78lmx/fH2s01uefLqfOHkpC6RcdVaq2tgM78aWbh1bxyfVWFZiI6EV45jU+9VUz5yWz/8hfaC9AyLULKqTPDzh0iZG4f5qWAx+IFG4UV5y8Gj2dEESKyush2MC7eonpn0QIRBmNv9PLzGJMStX0aIDlOPv0kOOMyb65uKZ42QQfrKAjMOpco82iNrI2xnVezfnZ3vzTMmSRqtWTyQtRLN9n4vGh0iD43WpGqXUJ5mC3iZGQfX7lDQDsFGN9P3Sf5qO6A/rebtT0mTY8RyY+PWaPDf1AuibHaTUob7jQoZuvQdO/Zi5BITDx/pXbq/IDvNzEf85Q6zHoBMn8YNL99jsViekHtyQFcXA7agqjQWHp8gf4krPYl001MfJqzYc0sCAVBr3ehOzs4U8U1O0kDEnqxMbnTe+JgAdS6fr/RtM5CFrowd7KtpQ2GNQtLA/hnt1HYHL8CJmzKVm+t8SoDPpo/wMygROe+0pD04RpO7qjYgtfVXJdeEoRuqZVaw1bkitMJHy+uG2rSFPs9NCNMxoyw1AjhJI0L0saYRq4jp5OmfMGjBpSCbUBVbZobGcByHP8paD0wGYC0YqwWkkIJJc0L6x4F1s2cqw4ORSG9oamREQcllCcBONXVL09PJ9+cNQA8v3KZycS9cvFaHxP++/ZSaOKOmtIgZ/k12kbCPLa2uSbkfH8uEId7kYYzs7Av4EMA1NHk/Py+hqorZjwLBJF0RuHJnIVU3RN6TZlW
 RLfQr8k3
 YjDfbd+g+tF6F2cU2PxSUWKTfpcEjGli6GHUk5iUGiDUBWkErMrWfVHvQBLbPmCEAtoer0ynJYHH9kU2GdexnC3E4n05NqRzHzgkADl7loOtH49kI4GliS5pkPIewHyck+TFzcB1/4uWKGW9fW62zWX7vZQrssdv2qfu/x/YIYbDSfmhg1lOYfNSE26/YXuXO9C8oLc/k8WkcSMB0+GSlWzatN3nMJclyQWs1z1JR+BKpA+zYRLexX/n6QDb/BcmCIlrQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As per the comment on LRU_REFS_FLAGS, when accessed folios are promoted to
a new generation, LRU_REFS_FLAGS should be cleared so that the reference
counter can start over.

For folios rejected by shrink_folio_list(), we clear LRU_REFS_FLAGS and
set the PG_active flag when lru_gen_folio_seq() would place them in the
oldest generation. That's fine.

But for rejected folios where lru_gen_folio_seq() returns a generation
other than the oldest one (which can be treated as a promotion), we do
not clear LRU_REFS_FLAGS. This can violate the promotion mechanism. And
this means the rejected folio enters the new generation with stale, inflated
tier bits, which can inflate reference counts and distort eviction
statistics for these rejected folios.

Fix this by clearing LRU_REFS_FLAGS for rejected folios. Of course, I need
to evaluate the impact of the changes, which mainly falls into 3 cases:
1. When lru_gen_folio_seq() returns the oldest generation for rejected folios,
there are no logic changes, and they will be put back into the 2nd youngest
generation.
2. For rejected folios with PG_active set by shrink_folio_list(), we only
clear the LRU_REFS_FLAGS and do not change the generation.
3. For rejected folios with PG_referenced set, the original code would put
them back into the 2nd oldest generation. After this patch, we will put them
back into the 2nd youngest generation.

I think case 3 is also reasonable, before commmit 6cbdd9726fb5 ("mm/mglru:
use folio_mark_accessed to replace folio_set_active"), a rejected referenced
folio was also put back to the 2nd youngest gen. Meanwhile, I didn't see
any noticeable performance impact on my 32-core Arm machine when running
'make -j32' to build the kernel inside a 3G-limited memcg with either zram
or NVMe swap.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Changes from v1:
 - Update the commit message.
 - Clear LRU_REFS_FLAGS earlier.
---
 mm/vmscan.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 40d3f1b48a74..1557679aadb1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5020,11 +5020,12 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			continue;
 		}
 
+		/* See the comments on LRU_REFS_FLAGS */
+		folio_set_lru_refs(folio, 0);
+
 		/* don't add rejected folios to the oldest generation */
-		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
-			folio_set_lru_refs(folio, 0);
+		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
 			folio_set_active(folio);
-		}
 	}
 
 	move_folios_to_lru(&list);
-- 
2.47.3


