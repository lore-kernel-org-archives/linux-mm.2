Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67188606A330
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qhdEvMbJ
Received: by kanga.kvack.org (Postfix)
	id 695AA6B05C7; Tue, 10 Nov 2026 06:26:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66C376B05C8; Tue, 10 Nov 2026 06:26:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A98F6B05C9; Tue, 10 Nov 2026 06:26:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3B2346B05C7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:26:58 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2217C054C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:26:57 +0000 (UTC)
X-FDA: 85418982474.10.D2A8032
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf09.hostedemail.com (Postfix) with ESMTP id DEF46140005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:26:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qhdEvMbJ;
	spf=pass (imf09.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794310016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sgZZOtBRQaNmECyPC9mpOVxtec1C2dAIZknHoGcx5pA=;
	b=M2VkvJ1CwMjdrJv+YEyXPsOEM0ORY769pBAuLzVv1J1mjFUGvcK6ZH309w/h1F4942fMQu
	DPzKFz4g9CttAR33hcIzlBRGnqY4OrHr/yjFbLPLSaYZwwi3xFF8aXdYsE9vHKO4H4Xb65
	/n4h1i6JJrNWN0EZZvTfdwTbh7jKNdM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794310016;
	b=JImmHk78ucZ3OGJ5LLHYsSYSQNxDJ7/A57U38BLoEDaSShtkONrijzDYH3HYNJ+W5+fr+G
	5KG6YEtUUCwafnJl7svK1DeZCiZ+iJUQ6B+ZHq8yQXKBZSzQv3Oe2XV4+1Xks0KzAkHrju
	qJhVBY804EbLbKPmjswTgDi+Uz5Gnfk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qhdEvMbJ;
	spf=pass (imf09.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794310011; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=sgZZOtBRQaNmECyPC9mpOVxtec1C2dAIZknHoGcx5pA=;
	b=qhdEvMbJE3N2xvnvcVAcY2kfI8lTO9qxoqbyUTzyrV/AjF/yiWhpctIzr/KD/LaXlggvrrWDfQm7om0/4BmjavBPd9fTYf7UiloFPgdS1aq/QBHZmUncHh3AEmpZlHMcbBnuxV8O8PAwbhokEsjd98kP2DsTqWpMxZZv1hUwzvg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XEV55hJ_1794310001;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XEV55hJ_1794310001 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 19:26:50 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>,
	"Kaitao Cheng" <kaitao.cheng@linux.dev>,
	"Garg, Shivank" <shivankg@amd.com>,
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
Subject: [PATCH v3] mm/highmem: refuse to copy hwpoisoned folios in the !copy_mc fallbacks
Date: Tue, 10 Nov 2026 19:26:41 +0800
Message-ID: <20261110112641.1196786-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fnxjjmadn1z5dfsmq4uxy949asci7ywe
X-Rspamd-Queue-Id: DEF46140005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794310014-660942
X-HE-Meta: U2FsdGVkX1/7EQ+ybRhDS/KmSu79fLWsMWbLLyc/Q5TiVAzgFNyREZfjj39oMMZFfMv0+MVQjWmWm71SPlV3ruPN3uVOX5HPosGjrCSsRauXmDULyCg7PdQdO8Swp4sRA8RU9Z8Iy9pHK1VwbKVZrtE+pcZA1Xj10q1DeSaM3nadG+wjv034LPrQv7LCpYwtvBJntVUCgKz6U2K/MZTqO9pJRJ04LiR979mTk144diL7w5Wv3UL1htPMsWsN591cVPMD+RRPqnnhxRyT7nS7fAKG75d2z7ULf2VNeFeOiW15M/5s4jvZMf8kkUD4h3ulD07PsSERy2EI+AOepdK+5VOWHoOZ/VHXx0sOR8klXOHFs/VmnFA1c5aDFTSfuqMqQj86Q7dbvNtevyFVeuOdcWEOEtB91CMtOUENp3i2+WuLXFRiWpru0C+S0G/RS7oBDubldtwFntuteKQ5srpsUHO3CK8cA3GWqhU3rGaBNE0t2mAEbpbi3uHoU+2wcJVw47MGIN0h8uFhrswoPaVCs52uxxN3B7TVz9rIakX1tYpPQMiiOuUwQgJFZ+QF2jCWjBerIg+a5eERv7fQIaygsh47A04GEGHcAhpcif6txOgfAkj33Dk+4e4gnUzz5XbfHaIfnU1RgztEcGVdeYGbSo6ZdsMPicjlFJFvuMM+1DiWFCY6emeZK8LsBXam7mVPOZ9S/2zCykOqHrSPYsG5EXLTWoGe3TTFNK3QFsP1pjFCcr2T+NoM/rP1Hc1mNqbtQAxJvcWyIF2wuLUeYUFrqocis8Xfban72JgN8gQSTSk/+l+/4AEjqNJ8CwFsYj4ORi0wZ60T5AoM4MU70plvEUzMSvXM7GxKdZOvlz1tzeXvHQ+2O/jLX9i8A7pGYU+buyys24kI2S2dEJ3rx8benp9RyR42j7tDVjshR8nkkoXP5j0V1aoq0hLECOUBr9OcEIemVeAfa/J0pCgjQjt
 +Af3oa7B
 zW3++CYOw8HLMf577eeLPWY7U0w5vKe4TI8xfgHKjYiE0nwkshrxxj/MPUYh1eXm52MQcvMAUuHVdeC+9Blu7fj2cpY8NL4fy220ZSXhjS61WxhzD0TcYvQN8Y/steGU3T5tTQdMDj716FyZ3Jc++uiCmmqaj9V4PMGgsVYEGPPRCY+hB4eXI4fGboVbnUftYHhd7RM0iIG50shbO1gf8oLrLZ9nOOFSpY9zFmTy2tgI5/4jyMOa2wRVa+O0390tSyPWfieRvZlA4Nk7qQkiBVJqUfEFVQGib1J2wYIvzJQbKhzs1ocFCUsIfyUAUSV2T+BKRcrvUBA6PgsucZHe+2XcbC3I8LTccWo3NcwQxovERSWZY/5daBqQHL//Zp/U+7xUgwLfVy1YPJARxtcfC5HLnzqlUFEwN1g0thkZJUj/q4rWmn7wLnyhtag==
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
before the copy, and return PAGE_SIZE, the not-copied-bytes
convention of the real copy_mc paths, so the callers take their
existing error paths.  On archs with copy_mc this code does not
compile.

Measured on arm64, where the fallback code compiles: a
kernel-space microbenchmark measures 90.00 ns per copy before the
patch and 90.71 ns after, 0.8% of the copy itself.

Suggested-by: "Huang, Ying" <ying.huang@linux.alibaba.com>
Suggested-by: Kaitao Cheng <kaitao.cheng@linux.dev>
Assisted-by: LLM
Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
Link: https://lore.kernel.org/r/877bjowf9i.fsf@DESKTOP-5N7EMDA/
---

Changes since v2:

v2: https://lore.kernel.org/r/20261029034254.2487998-1-xiangzao@linux.alibaba.com/

- Keep only the check before the copy (Huang Ying): the copy is
  back-to-back with the check, so a flag landing within the copy is
  negligible.

- Add the kernel-space microbenchmark asked for during v2 review
  (Huang Ying).  The bare copy and the copy with the check are
  interleaved in the same boot, 20 rounds of 200k copies each, with
  the CPU pinned; the zero-variance baseline bounds the resolution
  below 1 ns.

 include/linux/highmem.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index d7aac9de1c8a..c3240f70471d 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -473,12 +473,18 @@ static inline int copy_mc_highpage(struct page *to, struct page *from)
 static inline int copy_mc_user_highpage(struct page *to, struct page *from,
 					unsigned long vaddr, struct vm_area_struct *vma)
 {
+	/* Don't touch data that is already marked poisoned. */
+	if (is_page_hwpoison(from))
+		return PAGE_SIZE;
 	copy_user_highpage(to, from, vaddr, vma);
 	return 0;
 }
 
 static inline int copy_mc_highpage(struct page *to, struct page *from)
 {
+	/* Don't touch data that is already marked poisoned. */
+	if (is_page_hwpoison(from))
+		return PAGE_SIZE;
 	copy_highpage(to, from);
 	return 0;
 }
-- 
2.43.7


