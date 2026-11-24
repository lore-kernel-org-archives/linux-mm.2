Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72A70606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Es5g3dCG
Received: by kanga.kvack.org (Postfix)
	id E0EEC6B0757; Tue, 24 Nov 2026 10:36:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D70DA6B0759; Tue, 24 Nov 2026 10:36:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C38FA6B075A; Tue, 24 Nov 2026 10:36:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C27D6B0757
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:36:49 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FA06A0B1E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:49 +0000 (UTC)
X-FDA: 85470415338.01.B1FA3B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 815471C0010
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Es5g3dCG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534607;
	b=KvG7zCXHAKt8L1PKBbOALGj0mImW6RoqiQcxMmrYoiMkdH1PgNSJCP0nZGM/IWIviAnNg9
	AWaowcpFY6NE6yMO9q+ErFHYxUxkCJ2PnshajiqjfzmJUdXd5PP66IP3eurWQ2gTfUMK8D
	CANRFDtFSbz+QcXKLrl9RD9WXVGR7L4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NN8lp+t1lC6QgLK9X7uxeIzD+QXEer2g4STJ701UeWA=;
	b=7WrjTdnlE3IJuGzkw+dwc3aK/Zwb2Hsr3TQ6oTNYjJmBw/Gc9xymtAvI96AeevN2rLMPmf
	pkxR1wu+/T9WvGJyLgaetbMgJDJuyCXoJjRuw4ZCD969TJW1vUXZwA5zEKUI0cJnXuZaW3
	+p3vl0ADm1hFlHuitua3V97LCUi/9cw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Es5g3dCG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD59444020;
	Tue, 24 Nov 2026 15:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0FD1F000D0;
	Tue, 24 Nov 2026 15:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534606;
	bh=NN8lp+t1lC6QgLK9X7uxeIzD+QXEer2g4STJ701UeWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Es5g3dCGyNbb6SVfb4nZ8JLDh1p5N/4vOPcQbpi67NCwAH12zP/TZc1WwlO0VPFrg
	 dwpj2qWyfQlukkcg3HvqoH1UHQ3wv6w79QCCE/YYANfq6nF1UR68iyi9kCV9OjLRcB
	 dP8wi1zv3iBewFbhOAPe7ofz5PGqa+y7d3MRfTGho+Z39Kgjm14Cfgc+Yr7tpcukyU
	 GU24qg8aHB5EiLcrnclSyUjEEqSlzYuDwN0CQs8vbyd44sGOAmzzUl9kkBCggDYLAL
	 Qv68yc7qWoVmnF+lN7KDvjIfdtEaf6OKjnUeQGpXn7KPWpNMJBxpfdtqN6nlOMko5F
	 UuDCJQWY8JBNQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: [PATCH v2 03/27] mm/damon/core: introduce damon_submit_report()
Date: Tue, 24 Nov 2026 07:36:09 -0800
Message-ID: <20261124153636.91854-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 815471C0010
X-Stat-Signature: pap5qgyzicw56ipdin5i6fmryka4jf1k
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795534607-325825
X-HE-Meta: U2FsdGVkX18I0jZfw0s5PgX4ZP8IVFvg1prha+jq8sqnq6hgt+FyjM9nm/x/sXxW0GP/F0TRHZsOshFZB9mZMGT0Qi8Ff5mUu+36yJo3hix9KyxPXkfJ4GprWXqyyO6K4JnKEutnskRB3XZ9gGBafrLVvdQEK/2Lo2v2e2k2WmgCPSvnrHEp2MRQSBFFUmuUeITefw/hkcHY6xJeg3TZgw2SGAcFArd7t7e0fwwmUbnRIPDlplycjH3CfWa5sj72DWFvBPiuZNaUprPj/T64yprkr6hEh/M6dtsWjQuyu29MHyaz+UKtaOVSUFAY1LQ3gMgK2WUA8uOMa+3r5lijPbySwFQi2/HlwL64KoqP3unCo6d/v0cfE5pYw7k39EG3EVirdI8L/Q7GeAfDHF8vxutjXmTboD5SRVJ+NP5e22EW5E3B66VGYlPpUfUQXo4zws48/q+mMX1wLVSHQ5PZquhOvlG+aDT9fvDDTMNp/VHgLz0VkWJNCLNCQKHEwrNiUbDhEBV2lN3vsnwGg2JmI4ePTuQBKHwc9V+eobPI2du0/ii1paNS6wH8elUKr2UAww1OBrTZ3Mgw9oXyY5zq7pGaLJtUfJylypv8fzAHJfUZQbdIf6Jmmk4E/kyJvaTIRmv1my8fo2ZLIOhCEa7nB3MunF4blHYo/lW84/f4q109dBFASdWxj8ruK7osuMCeH3NL2fpU3JCkLG3wFN0SDAWjQgx0cOrI7QHQryLk75t1jnJRgqwR8/e1ZNM0Hj93BTH7gp9ImJ70j9PbOn6RxmOGnlRIKOwDLYLkyBzOwgS2MvwlOqMZlJPFKplnxrvc8H/K0cCuXk9VsgDbFxjvwKJ+BBlCmaURtugY9QXnK99M4z3tiDoydjTT5HWUZAxXDwxbOXwFhNXUVcP2Bcu/+w4SLKPAOMlVpjrMm3Na5/paWivDY5EU5x995GZvGJAJyVucvhuSYIgOnnDep5m
 b59QmEXH
 F1Nf5JHBr7WxLz00wtWYhBR/Q6wqS/gUMKKb4lrVSqQMAGA9YrFFR+0DN8csNsRWvnpwudu8cep8Qc6WwGWKHZ9hjiY1MaL0vEsxkwzdhSDnD5jhmFSnoeWKsDAzg9f01OhjWs6x/JUOUMNAvrRmd1cOZCvENApRVzXXokIP7VlgczU0NKjKl21fTincQfUZd2Rx/gWfEWpr10bxDjzSFMELHCSrQMxCpP+CwjhmM9B98DHPVEiOdidMJl1cCYPlG141vRkg5zLzNLy9BRdd/nD/ei9PNkOJiBw3VNVmMODB0vNiYiKOgKv61+QwcWxdhMgnFFTtOwy+G9ByLWOTu7BDIdxqoGA+Mk1IbVIQN+uS6UEQ+k17lWIYyhlb2VxZartsygxc6O3B+0cGaAM+jcle3AtQHSK2cx1HNn0B3ke/ez8Lo5XENcVLWGY5IghXu5rTEH5m4gs7Xs+4gujUR2nMrV2sXZrI+BchpoQh+CaDt8wX+kLdLUsftD/gJvWvrLaF1WgbOmxxeCO/lP8gc7ZmCEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement and expose a new DAMON API function for submitting a data
attribute report.  Any kernel component in any context including NMI
context can use it to report their finding of data attribute information
for a given memory.

The function copies the content of the report into the DAMON-internal
report queue.  The copy is done in a ring buffer-like manner, without
being blocked for consumption.  As a result, the queue keeps the latest
reports up to its capacity.

Use simple CAS-based try-locking.  If any parallel submission is
detected, simply forgive the submission.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 2520c036306f3..30c0ab8d88c2c 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1193,6 +1193,8 @@ int damon_kdamond_pid(struct damon_ctx *ctx);
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
+int damon_submit_report(struct damon_report *report);
+
 int damon_set_region_system_rams_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
 				unsigned long addr_unit,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 8293b69169856..ae6ef43e5653f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2356,6 +2356,36 @@ struct damon_report_queue {
 
 static struct damon_report_queue damon_report_queue;
 
+/**
+ * damon_submit_report() - Enqueue a given report to DAMON internal buffer.
+ * @report:	The report to enqueue.
+ *
+ * This function can be called from any context including the NMI context.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int damon_submit_report(struct damon_report *report)
+{
+	struct damon_report_queue *queue;
+	int lock_old_val;
+
+	queue = &damon_report_queue;
+	report->jiffies = jiffies;
+	lock_old_val = atomic_cmpxchg(&queue->lock, 0, 1);
+	if (lock_old_val)
+		return -EBUSY;
+
+	if (queue->tail == queue->size)
+		queue->tail = 0;
+	queue->reports[queue->tail] = *report;
+	queue->tail++;
+	if (queue->nr_reports < queue->size)
+		queue->nr_reports++;
+	/* cmpxchg is known to be faster than xchg */
+	atomic_cmpxchg(&queue->lock, 1, 0);
+	return 0;
+}
+
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
-- 
2.47.3

