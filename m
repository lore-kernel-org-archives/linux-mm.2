Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72391CA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 05:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373406B008A; Fri,  9 Oct 2026 01:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34AB26B008C; Fri,  9 Oct 2026 01:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 287926B0093; Fri,  9 Oct 2026 01:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 039BD6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 01:19:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 610EBC01E0
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 05:19:05 +0000 (UTC)
X-FDA: 85301933850.02.452C452
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf30.hostedemail.com (Postfix) with ESMTP id B446280006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 05:19:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791523144;
	b=F2gajyGpZe7wFnL9a1U696aFCgfgZrmhILPJihWBURKJLhLDq2CaJ1S10AY65/KoJNlSj5
	QWdnx2M0olM7O0srWOvK8OIQS8zoJY+WSaSrro+0OwrLcvk8T57Wsi4SZA/Mt7UrfM5v0M
	g5Q5o6CCW5oduxWEY07JwxnjcxYHf5M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791523144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=6iCpXFqa+RJjTdiiC42jzb94BsanjCrKGV8uiBfaDvA=;
	b=zmkxINdcbg+jxEQxOTnI83FX9rgJp8ty3Uh9SpylF5vFNCdPQQZBhYcthUaBAqDhpROz+a
	yt+j2aXw76cUb7IZM0VVLD1WD4crf8PFRqHxxBKeBCsvKSsZAroXZrwdksdrHcA3n+goHc
	eed/oVY2S3OWN+QZz91VqgELaJjWl28=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xF30U-0001uh-5a;
	Fri, 09 Oct 2026 01:18:58 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	I Hsin Cheng <richard120310@gmail.com>,
	Ching-Chun Huang <jserv@ccns.ncku.edu.tw>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] lib/plist: fix plist_requeue() shortcut inserting the node at the list head
Date: Fri,  9 Oct 2026 01:18:47 -0400
Message-ID: <20261009051857.758182-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B446280006
X-Rspam-User: 
X-Stat-Signature: q8eaofbcywcrrcf6uzudyfaeubrtbrgp
X-HE-Tag: 1791523143-810061
X-HE-Meta: U2FsdGVkX18eg7COUEk6+M1Gi01mNdx4bA2zGV+WvMpGjbweh1DnlcchDrM7r94hfvr/MCng3Hzd99dtb/XlhC5wSI60DaSfxwO/gPJSYI+w0wEpko7qnaBMemSsM2y0ga1nWezxEnYCvpi/1KVrWX+c/2dbczOFd/iTNEj/ASWfJNBY5a9WEPBvzXjaSBbIDNDmJpN+AuULC7qInjpR9eva4RuWwsmc7PDfX8+2aMLnf59nEtCQKpU7+2qlvrV+EwrUgRy4UD1B/WUNEEWhDo5CxaCGpyzd0fFewn7N+qlZAMgfoarhUtDIm/u+cwbydmbHTdHLZwiH68ggPzwCJcl1YV4W7FxKyScaa1K7nc15ILHNXMObIa1AVxOAS9pTW42Xzoe6IfCTg/tWjUG4Z/WL407EIct8IafhZw0wsykQ6eoeg9qfMRVhOGHfGEUJZU1xRT2AF+T+xYzwez3VlZDC7kmZxKNTxal7EUY1h1Gflta6nyGIQbkQ3yJuZBo8/pRimHkjQD3ru1kYsmbHTV4b7Q9G1bA1PwKJTCRfwzx/7JZyD9eFWgmOJmxkatYBdthFuAJpV/OmtZP6nRTMeXSu3pjfpT8VaMgQAieTAi/MoNFTC6NFUZq7fqErW6ZgIMdTxD1AGNMYp0pmdV699Zj3zy+30Dm6Y9DQ7f3W5sIkGAWH4gZ2USxX8lU78YdIlQ6CjdkLER0mvLzHf6h0DThpkeNSPRjKc5Q8CzntMr96mFKLoAstmAnSnH4hSFlMeqP3XYsRivEoFOUKqy1qmpQi1Bi9yfqIRXtk62R+ELtEral0Mmso8ms3W8LLnCcqJng4jL+cGKQm6Q715aUXwvmrL+9ctPZjGBPuReZd7OmkBX6dybNVnxlxMfWSifpKenhvIp6SbGzWOaQ3Vl06BZ60NuwV2enRrU6XuxU9JldwpipB1mw8jSt9/SfPNZB3eO4ym17TD09FMa9jaQR
 NKDbxgeu
 qhXuPlIZm1GBvXZhFTOKWoFu76Lj+r9/4EAbJj80kb6/N9mNTfzgX/EmFPrqTt/ib107nxsMArHy2YQ/JaCUxsAZPlXumwTULlqchiPJztNdDq9Y0v5kcOXiQP2mgA/XhT0XiVTOOjuZcaEdkNqRm6x1q8S7cTMOqsS54SFa88HPU1bSjqSSDyPq87A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

plist_requeue() moves a node to the end of its priority run.  Since commit
95d4b3450ebe ("lib/plist.c: add shortcut for plist_requeue()"), when the
node was the head of its run it skips the scan of the remaining nodes of
that run and takes node_next from the prio_list of the node's successor,
which replaced it as the run head in plist_del():

	iter = list_entry(iter->prio_list.next, struct plist_node, prio_list);
	node_next = &iter->node_list;

prio_list is a ring of the first nodes of each priority run, without a
sentinel.  For every run but the last one, iter->prio_list.next is the
head of the next run and the shortcut is correct.  For the last run it
wraps around to the head of the FIRST run, and list_add_tail() then
inserts the node in front of the whole list, ahead of nodes with a lower
prio value.  The list is no longer sorted:

	before requeue(B):  A(1) B(2) C(2)
	after  requeue(B):  B(2) A(1) C(2)

The condition is: at least two priority runs, the node is the first node
of the last run, and it has a successor with the same priority.  A single
run is unaffected, because a one-element prio_list ring is list_empty()
and the slow path runs.

The only caller is swap_alloc_slow() in mm/swapfile.c, which requeues a
swap device within its priority group.  With several swap devices on more
than one priority level, where the lowest priority level has two or more
devices, rotating the first device of that level moves it ahead of all
higher-priority devices, so subsequent swap allocations go to a
low-priority device first.

Only take the shortcut's node_next when the next ring entry really is a
higher-priority run; otherwise append the node at the end of the list.

The CONFIG_DEBUG_PLIST self-test did not catch this because it only
requeues nodes it has just added, which are always the last of their run,
so plist_requeue() returns early every time.  Add a deterministic test
case for the failing shape; plist_test_check() verifies the ordering and
the prio_list ring after it.

The bug was found while attempting to prove plist_requeue() against a
specification stating that the list stays sorted, in the MachCSL
verification of the Linux kernel on RISC-V; the proof failed at this
arm and the prover produced the counterexample above.  The fix and the
test case were drafted with Claude Code (Claude Fable 5.1) and reviewed
and tested by hand: the three functions were transcribed to a userspace
harness that reproduces the misordering before the fix and the expected
order after it, and lib/plist.o builds with CONFIG_DEBUG_PLIST=y.

Fixes: 95d4b3450ebe ("lib/plist.c: add shortcut for plist_requeue()")
Cc: stable@vger.kernel.org
Cc: I Hsin Cheng <richard120310@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---
 lib/plist.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/lib/plist.c b/lib/plist.c
index a5bef38add43..20291872923a 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -174,11 +174,17 @@ void plist_requeue(struct plist_node *node, struct plist_head *head)
 	/*
 	 * After plist_del(), iter is the replacement of the node.  If the node
 	 * was on prio_list, take shortcut to find node_next instead of looping.
+	 *
+	 * prio_list is a ring of the first nodes of each priority run, without
+	 * a sentinel: if node's run is the last one, iter->prio_list.next wraps
+	 * around to the first run, and node must be appended at the end of the
+	 * list instead of being inserted in front of it.
 	 */
 	if (!list_empty(&iter->prio_list)) {
 		iter = list_entry(iter->prio_list.next, struct plist_node,
 				  prio_list);
-		node_next = &iter->node_list;
+		if (iter->prio > node->prio)
+			node_next = &iter->node_list;
 		goto queue;
 	}
 
@@ -276,6 +282,25 @@ static int  __init plist_test(void)
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
2.56.0


