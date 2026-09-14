Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86C61C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 11:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B9186B008C; Mon, 14 Sep 2026 07:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769556B0092; Mon, 14 Sep 2026 07:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65F6A6B0093; Mon, 14 Sep 2026 07:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B33D6B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:29:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4407F80322
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:29:43 +0000 (UTC)
X-FDA: 85212147846.09.EBE9A39
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0175B18000A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:29:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dzGCSFDG;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789385381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uJJuVJ8DPJj/Z8t/RBxJPr6rrha8u2eMESrY/Huz/tU=;
	b=lHnpLem535On0P12Fo+Y0XAbnQz+uPr0wlnpm50njJReJeHUeQox3jnUFbFMxIwxR+SP1M
	xkhyp6u/sJnal8sLyaQipj9Ojd3+WCvDz5DmECr11tZ6TqH+ev53PV9uDknAIgf+5/yHld
	Z9HCSfG6zEW7UW2cNwNxYuUpldaSxlk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789385381;
	b=YrXfYITpZ/b3QpgFGH/j7Qg5+jrQ5tmNo+HDYqNgNfPwPg8w00w75OsHSAn5I5Sa2LHnj7
	LREkWF5xvuDE4GUFV/jTNOKhDzOT2vBW+kW/7JeYHotB+Kr5B4D/5bh7U3I+qhWbTonB5m
	5dJ+1KHbB2RSGfGfnF/GKSLDT8Z//sU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dzGCSFDG;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789385374; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=uJJuVJ8DPJj/Z8t/RBxJPr6rrha8u2eMESrY/Huz/tU=;
	b=dzGCSFDGacQ2lEBN8f7MaLP1U+C48t/PAqQwtWEB9lhCOWxeWKsrHvRdcbVjuftXduI0uIOtbk+m44TQcnnO7eUOZUG6Lb+xeRVideE2jpWuGnnQmyaxzlTHpKiCAXM16LTBDPkXatNF5sP8X+ZpgFJCN4kkpklODnyWmL6FK+w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XAvlfye_1789385370;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAvlfye_1789385370 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 14 Sep 2026 19:29:30 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: kasong@tencent.com,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	ridong.chen@linux.dev,
	baoquan.he@linux.dev,
	shakeel.butt@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm: mglru: clear the reference counter for rejected folios
Date: Mon, 14 Sep 2026 19:29:22 +0800
Message-ID: <7384df363c12e4acdaa2e0428420cd8eed320ee7.1789384831.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9bszos5w6ec58ntg49jkfu71nukz36f3
X-Rspam-User: 
X-Rspamd-Queue-Id: 0175B18000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1789385379-193581
X-HE-Meta: U2FsdGVkX18rnFm/lgi+bIxAi2tEokpFK/L6wJsVGk4f4+1+ICzjdJL/I3GNCHKCwkocvD5k0NsP6Ga5ZTxHkvKIuNg8XIR5xIhe/avQFpmgaA2GyytSllJHHM4ILNmfLyZMLWpCmI58JZYXd44Wyu8aG0wdPo5vUI7SacVRSmnfEKYxnXvzxoceE+9qhWiVgasuCWCP2K2z2sd0jBP0qOu/Bm5JUAuetZsYdBEFfbZPEtRQzs1nk5zPdsr600IsqcMisSrOrb+sL4iHsqnAzNgKFHd6t54vyFHpdo9U3jEV2j46rPtHchoak1HDEtDpyEJaBZjrcXMCX6hGkhxvO7QIRq+GJC4M9DhskHLBuDFzhN9OZi2flLPZozRt47FJi8wuS4E1ClA1QJIeav8GEzYRslomR4YRziKbHD8ObyF/Q0vYoQfVSH+Qd5lN27XJN5360/yfEsdtQAnpXjfYJ48xDRDFD9Ceyr9xRK84mhYpqLw45aS7lu1an6Cbi6iXMGP4v/ogROloGT8rqOQTcuR5HVh9RJ1q5PCmwrKcbFPYJWuO6JReWxdvpyVa5zQFH1xl0nb7OrPigqZPjzVsb2IgfqQ7qBkm6xQ5ttodsnAh1V1RRiCpzII/a2LT4yWiRE6l7ge41NAkvbsSKdSvbPnOFsBm0CNAaZxrlEenL0TS7riY6smbARXo2mZRLDPqpR5Kh/KCJ+481JRtIMZJfE9pjHir1+nL0ldFFZDR0FmsxdhTBzM57HraITdAvyADPHfZGnSwbTYNM8cnswnejOCPsgj/ILi5D8N/c0NLUU9+NaQWNwnIlch0LBem9W522EdUVIHYa8G0xeq3oqE+NC6AbjLevhDhxM/v0H39ps3XVHUy1fi+pmiTSWJfVB5HcqbqGxFIo3D56jqD+kpan+al6PAZiuKTdYMax+WP3teX52SU9bTxObMb4CkdUG1GuOy+SG95sRKJlUoPfPy
 56qeDQ6R
 g8SiMkwQbslvqVH/rHCwOCXIhZV8J6628GV9ChALF3OssG4fyRS7PUsc5NnnRApF6y6dGsi1TLeb3gh3jKSz+3fPJx7kbPINa4pYWWcMi0CdF74AEqvRl6YhGOJyLRixyx/lzD39XYvGgdMhOMQOdVL7QMlgfs4C0G9OgJYKPQKkCXXaP7dMIhl4DpOsGFlOKlkfGvcpinh5XUC6C2bJhlvnwo5E5wUcWtlrY7bq2dKS7ICadMUOOGkarHi6estsrQlFGNZJnfa5DA8F9XPGedWiwTRsJwaLPb994x+SxWDtG1EA=
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

Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Changes from v2:
 - Update the comments per Kairui.
 - Collect reviewed tags from Baoquan, Kairui and Barry. Thanks.
Changes from v1:
 - Update the commit message.
 - Clear LRU_REFS_FLAGS earlier.
---
 mm/vmscan.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0a4355ddb63c..386ed743a766 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5071,11 +5071,15 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			continue;
 		}
 
-		/* don't add rejected folios to the oldest generation */
-		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
-			folio_set_lru_refs(folio, 0);
+		/*
+		 * See the comments on LRU_REFS_FLAGS.
+		 *
+		 * The rejected folios are never added to the oldest generation,
+		 * so this effectively promotes them by at least one generation.
+		 */
+		folio_set_lru_refs(folio, 0);
+		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
 			folio_set_active(folio);
-		}
 	}
 
 	move_folios_to_lru(&list);
-- 
2.47.3


