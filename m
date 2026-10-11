Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC742CA9EC5
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 01:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DFC96B0088; Sat, 10 Oct 2026 21:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769A06B008A; Sat, 10 Oct 2026 21:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67FA66B008C; Sat, 10 Oct 2026 21:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 377E66B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:22:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A4171C3E3E
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 01:22:51 +0000 (UTC)
X-FDA: 85308596142.30.1E8A64E
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf29.hostedemail.com (Postfix) with ESMTP id EEDE6120004
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 01:22:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791681770;
	b=WmHfj4F9KculXLj9CvcLwwWr2c5uNaVuJJ1FpaaDFoAjaBP8mME2rq90OwT5WjuUgQrtdD
	FkqdjgruaTT/3ZZXI2dR2dCD9M06SdXeY9p/Dj18DfVju3jjnN4bOOMhRyw0eaVzdfbfZs
	69HyRA7xc4hwA4Z59rPqhktEZ5i3k2M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791681770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xpa9+dD/STajmYb7aK6ertpt++xKe1aiL4N+uf26pBo=;
	b=8bpLkcNho0ArkwOo7mH91Mv9csJKUgFZOoV8ogxI+KpvNwETCTuX8uO2yY7TXv79rEV+27
	jPNvPlQpUpKCfoi0fi+Zi/1l4zThoqqEcUAKvGxQaRuCCmLSsbn14LZli756WNC6Un31Nu
	PiYXUpHUh8WM4YFj1gPu97nLe+kuruE=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xFiH0-008ATg-6H;
	Sat, 10 Oct 2026 21:22:46 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Adam Harshbarger <handyhandyman.adam@gmail.com>,
	I Hsin Cheng <richard120310@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] lib/plist: add a plist_test case for plist_requeue() on the last priority bucket
Date: Sat, 10 Oct 2026 21:22:33 -0400
Message-ID: <20261011012245.765558-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261010181016.44f5e2883b6820bb32c04204@linux-foundation.org>
References: <20261010181016.44f5e2883b6820bb32c04204@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EEDE6120004
X-Rspam-User: 
X-Stat-Signature: 8sk8mwzgx4udwknzdxadb4t7ydza1k1c
X-HE-Tag: 1791681769-143521
X-HE-Meta: U2FsdGVkX1+d3JQS+wo3lmorhGwoPtVR+B6wWGJO3ANFCCNqKXhqyrjg99C1bOgUe9JgRztflE25HcdVYwSvOvXQ7JyExYFArXsZ8aYymoq2pYYwSIug7y1sVJoALS0V2ytuHhLKWG0KNhUC2fUrv1y1ZBBUbdEkuDfAsfVn//U6Td/jvHOpZwYmQP2ZycE/DmSiwQGl0PnESrAzcMeuUUsF//WAH7BrI6wvvQsRCjn7S6w8ZjQOYcOjwcQMDT+wfc8n5eUw2/63qv9HY7CJsNWR5kSr7N5HJQ7RtTALM26XF4RV0qyE3rm9rVGLsAeI0f9U1DCzYzqwf0nKXTqQ93x0nfxqFuegHFpL/LNkXyLQc3B1tEQVrGS8GBkL/N5pWg3XIOAmuDe/b0Acj47h0Ds4O8UeDQR/jmGnSnLQ0xB5NPjRjeEYRSHkPv89mvr5r6jVJw/PWgNtu6RTPpBFUIm2/hm3OtN/wULjcMWqGDOZcqUJ9iNMPEZZXKb8NCDL98McWcPoUq34hy5Yv+gkxfpIYNx+zKY/A3G+CorLdlb4p6zmOvopommaM+sWrmfal0s22of6g2JGVQTJc1cKW5apSVs3hJ6lCa779KBSQAsuqQLAx6PvVJE3g5mrE68pzn/fM4KR2UrweE4WOIRNgRb2B3bL2Q4Zbvn22K1sDs3mWptwLKYwXVoGw9hnUv4PPqHamEs05/0V4yuN7yGS0N8krP7tl0WBa6lpx0Zr4XScggt5YDCXAL4AABgNKT/TQ/nfQaez4uDIGne4XXoLDw+YPzDdvkqTMfZQswJF6jAtDmu4gPYjCSG77NT7SQfkL2p1rDF39NlT5JYPuSDfdxKXLgJX2Ky/ipmikxYAvDyrVwNRHAz9zupuDKKTNL3jSl3dOXkWu/npqgp98qo5c7IBTWiqDfvuJl4KTo6WdXJoN/PgirFQdQ9JLSL7G/zcO3IzLf+Lg7btOzJf9LH
 A7VjySZl
 REU9mjSWDNDt9WNnAPJrco46pXkqB6Tmjwjx22Z1YlDXlb32YkBZ8mwRl+C4LsH+XVIfWm4CJIWK+793OpBsxA3QLwTPeveNnoT6yhts9sjB0w4mjj1VsDwzWSIe0GQAw9w4npXzgLjF/v4Qu8j9IYoM1uRMtxGuXQEGpRERqDF90q8mDGMayJ3brVCZqHgpOZcAiipcZqiUlUTnijHS9N4cErHa4EzEEgrPpW/ZDvdHxq64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The plist_requeue() shortcut inserted the node at the head of the list
when the node was the first of the last priority bucket and had a
successor of the same priority, with an earlier bucket present (fixed
by "lib/plist: fix plist_requeue() corrupting order in the last
bucket").  The CONFIG_DEBUG_PLIST self-test did not catch it: it only
requeues nodes it has just added, which are always the last of their
bucket, so plist_requeue() returned early every time, and
plist_test_check() only verifies the links, not that the shortcut's
insertion point is correct.

Add a deterministic case for the failing shape: A(1) B(2) C(2), requeue
B.  plist_test_check() verifies the node_list and prio_list links and
the ordering, and the new BUG_ON() checks that B ended up at the end of
the list rather than in front of A.

Before the fix the case produces B(2) A(1) C(2) and the BUG_ON() fires;
with the fix it produces A(1) C(2) B(2).  Verified with the three
functions transcribed to a userspace harness driving this exact case
against mainline (fails), the queued fix (passes) and the alternative
fix I had posted (passes); lib/plist.o builds with CONFIG_DEBUG_PLIST=y
(LLVM=1 ARCH=riscv).  Not booted.

Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---
 lib/plist.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/lib/plist.c b/lib/plist.c
index b0273533c04d..ac3f55dc49e5 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -283,6 +283,25 @@ static int  __init plist_test(void)
 		plist_test_check(nr_expect);
 	}
 
+	/*
+	 * Requeue a node which is the first of the last priority run and has
+	 * a successor of the same priority, with an earlier run present: the
+	 * shortcut in plist_requeue() must append it at the end of the list,
+	 * not in front of the first run.  The random test above never
+	 * exercises this, since it only requeues nodes it has just added,
+	 * which are always the last of their run.
+	 */
+	plist_head_init(&test_head);
+	for (i = 0; i < 3; i++) {
+		plist_node_init(test_node + i, i ? 2 : 1);
+		plist_add(test_node + i, &test_head);
+	}
+	plist_test_requeue(test_node + 1);
+	plist_test_check(3);
+	BUG_ON(plist_last(&test_head) != test_node + 1);
+	for (i = 0; i < 3; i++)
+		plist_del(test_node + i, &test_head);
+
 	printk(KERN_DEBUG "end plist test\n");
 
 	/* Worst case test for plist_add() */
-- 
2.55.0


