Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14421606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=A6YbxRLu
Received: by kanga.kvack.org (Postfix)
	id 367F76B00EF; Wed, 28 Oct 2026 23:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317CB6B05B6; Wed, 28 Oct 2026 23:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E1E6B05B7; Wed, 28 Oct 2026 23:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 079A56B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:43:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9155AC0298
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:43:12 +0000 (UTC)
X-FDA: 85374268224.09.2187B73
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 99111140004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:43:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=A6YbxRLu;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793245391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JekMvStiW/W3yoGDfXVkNrB3ZFspUK0TlSYVErjbeDo=;
	b=j46sbXDFDro7XB6MVd4Hvav4JvDRc1huPng9inrXj6I97Z5aLohc+1rynupDr8QTbyCl94
	ARSAEqNXfvW4niLRuCcXNfqHe6/Edk/1RUxYhJduIe8gYu8dTvPQ0DOE9+9qdcJu5IBdtc
	wrV50Xfg2T6ZsyMZ+kuEtPSrHrKT9t4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=A6YbxRLu;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793245391;
	b=r1v//BMICJc9DAFP+NJKD0Oku0wPwxmC27jRypxbpSYQHoZd19lbM/b2amKyXbP+rxOp0C
	GvsD3NiwWEnOlyq2cXl4983LbQWiBH24ZpqDLlnYJ44+iHsN0vwgARqMa77XPSQxdgVMXq
	2L/QxOrkDgitI1qntnPr3gWhri6NBWQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793245386; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=JekMvStiW/W3yoGDfXVkNrB3ZFspUK0TlSYVErjbeDo=;
	b=A6YbxRLu7rwHqPek4FPBXX6/d5mW1mbyFxDM9kmG4Eenzte5xocXDzjLiN+dZMep1feiOT8lD+0BBgqOedNBTrAsDcSghW89k6U2IAhcLE/n1flh2T8hJdFcQo3zDcw1JQzaI92sPNHZRzb4b5wi/KvEWhiQzGvDZXX5es58XlY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XDiFJuP_1793245374;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XDiFJuP_1793245374 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 29 Oct 2026 11:43:03 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>,
	"Kaitao Cheng" <kaitao.cheng@linux.dev>,
	vbabka@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	ziy@nvidia.com,
	wangkefeng.wang@huawei.com,
	tujinjiang@huawei.com,
	mgorman@techsingularity.net,
	chengkaitao@kylinos.cn,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xiangzao@linux.alibaba.com
Subject: [PATCH v2] mm/highmem: refuse to copy hwpoisoned folios in the !copy_mc fallbacks
Date: Thu, 29 Oct 2026 11:42:54 +0800
Message-ID: <20261029034254.2487998-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 99111140004
X-Stat-Signature: fxd1cfngt74ni3c16x34858q6fhb1s6f
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793245389-552730
X-HE-Meta: U2FsdGVkX19qSGkUfIXK5n/bGt6PfP871EETdnmHLdMv1xVhByqZDSqldt2cvQ2T8qpNbjoruzhnX1Sg4g5nhb7AC8uF7aAUDdWyjVFVhPBFX1fH5PcvpeN+JjGFYpMqvFM2HTLrUoir4/n+dHFnsSapPURxIbdDrefwVZcHL0/XggUhwZc7O0C32d4rqwOXuu8FCerRDSFj85wfJ3xPPQ3uRhyDu9rKOQg3QkEr63r0pOIcwdSt1/kRmltENA/hnF+Syh7tP09nvf+cM4WMiK+WdJ4WZyPHWPmvGl1c55dpkv53vD6B7VFwqKFpVOPbDJeStwW64x8sh7TOqxAYA1ysfrgOyck5kcWaPtvI4D0igqbDxTXqr0Bxdl/ws4ruF2n0JORH25nexFU8KDnjeNAcy6/L2LEN1ItqE6E7rd3SRFQN6nQ/6HI+CVTNzJCNUDhqABmLQInGvoNFPj81VFAzhRxN1C8C5KG6DoxkgS5gn8v64nfOQV2mBBmeugNzpHrZYHuidonZ899QnGvzAjUbgU+xFw+/L1EP7Vm1zpDd3HzWrcpk7sTX/PgDYlqhxuv7TPdaVdn/O+ZJuL9ZEQ+RByJePxQwbOyZfoavnh6MVE8lHoD6o6uXG5pU7xyQ4QCEZ9ao8tN4JIt+B7nubNJXj83Z7EDfhFyD4jp6FHnC0jW/opIs3CZOev5NEVIc2SypYlqKMnnnyWlo1K0wCS2iuJWEYK5Lr/Soy7jMmCgJXC5hH9SNM4nppeYwLSnnLyB3PEyunJvPlHWOCDJIHGwimaDtkcJd2ePkP64vM4uvbSaMyegwfUdaGXMiyg7IuVHxEzMIGSS0OQfCuLJMlq33SvtLx8WIVu3T4Q+THQKJI9C7ge+SdceJKNWZMjhDgLXytW4ujzlt5gdhjqxgGG5MqUrdFaK48POZ7OhznpB41Yyzrhex79Ik+bUFpe+Xvg7yE/IOweFSznCPI9n
 6VWPolQG
 SLfOg5onnMQXQJtfaXIo9l/W2SNDv7DIEa+QC0LaxKmV2k37N+RotkpGcMOYbuZo2PC7XND/jWhZ92WxDLj/dyBHob5q+K3AcR/M1IiuMuDFTJ0Iffys5wdJhfjkrH7GesoaaZw8gW00lSHwvTOkAtfXR8yl1OERvF9xhSWyyITdvHJ49XUcISKPhFNw9ji/bzD+0n3CQegOsyVP9uiFYzVRlkIvjEONIByPMu6O9prxgUIb4AB3EPV4aQgBZAI2xzxbuP34Ig3E4Tj3l9cCLSpuiOmrjk2VbzvWSqrsaIpvAwGrkGWxvV6WXcU4xGK7AQSmHDZDXPGM3+w1NgiLkR0+SWSKGBKLwkjBybe7r8sgKBFwf5HHiHqs8vIbmrpVCkP7E7JMSo+3m7X36eGvLZRrYGe6TfHkvnCjyUQ1u5Mu9/PpTfKqDGwvCVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The !copy_mc fallbacks of copy_mc_user_highpage() and
copy_mc_highpage() return 0 after a plain copy.  With PG_hwpoison
set while the data stays readable, there is no fault to recover
from: the copy completes, the destination folio carries no poison
marker, and the poison is consumed silently.

Check the source page with is_page_hwpoison() in both fallbacks,
before and after the copy, and return PAGE_SIZE, the
not-copied-bytes convention of the real copy_mc paths, so the
callers take their existing error paths.  On archs with copy_mc
this code does not compile.

Measured on arm64, where the fallback code compiles (10 rounds
each): COW copy throughput 1043.67 MB/s before and 1043.26 MB/s
after the patch, fork latency 348 vs 359 us, forced migration 57396
vs 57654 MB/s - all within run-to-run noise.

Suggested-by: "Huang, Ying" <ying.huang@linux.alibaba.com>
Suggested-by: Kaitao Cheng <kaitao.cheng@linux.dev>
Assisted-by: LLM
Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
Link: https://lore.kernel.org/r/877bjowf9i.fsf@DESKTOP-5N7EMDA/
---

Changes since v1:

v1: https://lore.kernel.org/r/20261026025724.1430747-1-xiangzao@linux.alibaba.com/

- Check before the copy as well, so data the flag already
  condemns is not read (Huang Ying, David Hildenbrand).
- Use is_page_hwpoison() instead of folio_contain_hwpoisoned_page()
  (sashiko review, Shivank Garg): the folio-level predicate misses a
  poisoned tail page in the memory_failure() window, and refuses
  clean siblings of a poisoned subpage.

 include/linux/highmem.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index d7aac9de1c8a..d0e33cacae90 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -473,13 +473,25 @@ static inline int copy_mc_highpage(struct page *to, struct page *from)
 static inline int copy_mc_user_highpage(struct page *to, struct page *from,
 					unsigned long vaddr, struct vm_area_struct *vma)
 {
+	/* Don't touch data that is already marked poisoned. */
+	if (is_page_hwpoison(from))
+		return PAGE_SIZE;
 	copy_user_highpage(to, from, vaddr, vma);
+	/* The flag can also land while the copy runs. */
+	if (is_page_hwpoison(from))
+		return PAGE_SIZE;
 	return 0;
 }
 
 static inline int copy_mc_highpage(struct page *to, struct page *from)
 {
+	/* Don't touch data that is already marked poisoned. */
+	if (is_page_hwpoison(from))
+		return PAGE_SIZE;
 	copy_highpage(to, from);
+	/* The flag can also land while the copy runs. */
+	if (is_page_hwpoison(from))
+		return PAGE_SIZE;
 	return 0;
 }
 #endif
-- 
2.43.7


