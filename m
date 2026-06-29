Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50C82C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 01:43:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA07C6B0088; Sun, 28 Jun 2026 21:43:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51576B008A; Sun, 28 Jun 2026 21:43:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C184D6B0092; Sun, 28 Jun 2026 21:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A03B26B0088
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:43:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 117811678D3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 01:43:54 +0000 (UTC)
X-FDA: 84931253988.17.B9547BC
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1C846120003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 01:43:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b="Nf/a3CqX";
	spf=pass (imf29.hostedemail.com: domain of chenyichong@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782697432;
	b=7ExInjLBnOqmvZxH56nsGb0TSOMFndvrBEWfTI4vy+glTNgNBVVHd7yed86ARP0SrdYjAN
	64TXdrz9LqAlmIcr37C7QhwlUp+GGdgNc6MXXcAzxaB/+pNH4b+FnjkYYXbMgd3r6XcGj7
	sEFlZAwgpwD6m5UhA7SfGpLcJYXy16o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782697432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZnJoJtBgzZIFDWcRoWx5iyO1CtG4HR83S4oC98/yBA=;
	b=Q3mlrNdiuui6Y/cZYCjPyAfBYc6bfinObkMbxQAnHe0g22KdTtGxWlDsRjhlt+ErMq1Aqy
	aFTvZ9U4cGzjrKM3HGY3CsW3bjlZIkW3vHr9TaUUpHiOBJpZc9xBDd0ERDrdWH/YgDZzDT
	EAovfhiG+Z4QGl5CuX9OO0xFwr8DHyM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b="Nf/a3CqX";
	spf=pass (imf29.hostedemail.com: domain of chenyichong@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782697411;
	bh=dZnJoJtBgzZIFDWcRoWx5iyO1CtG4HR83S4oC98/yBA=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=Nf/a3CqXhrHeDOETsMwiD7ZIqG0Jxvkibr2DrQSPg7gCG3zbHRD4jzAbrGdscmpDa
	 BF87pvcNxV1bTothzWQlSSdGeqvpRo/CkMvfQoI1/VUMQ/qgGIOGHt7Ekwysm9U7Ph
	 uEkqbRZjBiLEdcJ04vYtPjnLxMNMXQovRTEVoKUU=
X-QQ-mid: zesmtpsz7t1782697407ta4b31b1f
X-QQ-Originating-IP: OqzAURa061oPDky5k7zvEf6/MGg2MwwXWpM2iYqAlzI=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 29 Jun 2026 09:43:24 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14938799598701627117
EX-QQ-RecipientCnt: 7
From: Yichong Chen <chenyichong@uniontech.com>
To: akpm@linux-foundation.org
Cc: vishal.moola@gmail.com,
	ye.liu@linux.dev,
	zhen.ni@easystack.cn,
	chenyichong@uniontech.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/3] tools/mm/page_owner_sort: return explicit filter results
Date: Mon, 29 Jun 2026 09:43:14 +0800
Message-Id: <20260629014316.130307-2-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260629014316.130307-1-chenyichong@uniontech.com>
References: <20260629014316.130307-1-chenyichong@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NJV4ECYAIEtcwxGDUQI8g32CIL64oCT6VkXbABEvrjnzcGqPY25uJ/I0
	6QZYxMMGzF7/NPKPPJ9pT2PmxieWP2wd1HrmKNSYGx7+51PGtnQ1M2WI08azx7Vxiu694eZ
	qTQkOQxxG4FQo0TPgIP5IsbgGOqwnNhnGoECu0bfi5kfUPbn4Hcp7xQsEdDehCFKDuivpBp
	hMWC6lDz7cNsohzc2sT0O7mZC2p7mL5X+jVO8q89mYhhYZ0SnQioVBXLYHu8u3+KlnHNW1r
	4AqYJbNT08s5K+9Sy88TLo7lXiB22fZp0grKWnC5dXzmCI0WFBgTzSkcqyJNk26r6dh1B4z
	udofIWYrb5X5VdMsNluvFaRQEMhTevbas239uwCANfmqQ3d5m0UU/DEDVQ0EcVK7Xzw65/5
	HVLYF4AlzYOO9lUZw7f9ldjcMabWAkG3qTBF2gijgqni20ewnacdp9MltDIMAoBIkFacAs1
	2gmp9kC2RryxXJTnPIeKHJqBry423EEp1NGigZlQMIIs8lfb/BsbOCLfjdXynsi88aPFCBs
	fQHJmgMbfZTtpT4j7GEg+S7tClTNVUsGudU6cLXknLTbiuynJq4PDsU+Y2t/F0LD3VjA5Yi
	7/iZv9WqPwkVxeAkmvYWKaAgbgcwF8KkOM5gujTwg/90YAwFfXccDUIV/mor0q94TfXHR2x
	CUVNurYDTkIvyTGxkStNmGQ6jQu/hSMkFwtsMtz8bkQhzrhB+cJRPlzL8ahxeMMwWItBlWw
	/nD2qRz3g8qfAQM7j6tJvGS487pnqV9NhtZldO/qe/Wj0v9+BU5fcZtCdCVLOqiV1uxTyRA
	/nJM52cC4DHd9IKLBzvD5Q4Bwk+fLmm7FuOszynnCM3XZgQgSnS0VYurLzIL0ziJhf8j4GS
	vl5uugk6EFTZqQK5x7jJddruWNTkBpFJO/Gd89U4pL1ROjv8rT6Xg2g/DHneL6Hoc5nmSQb
	CDKnfCRuQ81EEGS8RvDingqEJ9ujK/T/upll3M1s5R8UFeOKE/sllgkkMLUctV1/nOOeivM
	DxRn8DAYCGbBbD9BaAegT8F3fJ2W/x90bg6u47/qNDVrpTR39Z
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Stat-Signature: g1biq5h15baouuo9h8mi3ukjhmxewnpy
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1C846120003
X-HE-Tag: 1782697430-522726
X-HE-Meta: U2FsdGVkX18Ls5oeMOTAd9ml5ACGYJplQLPF88+bPuQFBMb4iaMvVjUWLcC39bDnUuNuJ0G6qPl95Ja9pOIA2/dU366gbnZWpYkBITf3j5hs/GvCdFVyKSvvr6i0KgYuwwNOQ6Kd8d9XUB/Dp+yX5JmkK7lsLCNEFl207IhfVjW0jfS6rmODu4HyyY4YvDQJUEx1eypqJoy1LsUWSM/o0/1imHfq7W5d6z1KuKkMCxwbuEJjpXGZxqBzNiWUyRfAOLlxbYQ2HByKqdI9FQG9NN3k3Q/OHqubA1uBbOrjS4HyMHeMSE8XrC1+37C3LmACQCn48jt0Loapu6aabm6gLehqZI2rB/6PubC6clZzAKA96iI+xf5V6X4lgw+DvZm18Zt0SLs2hNt+9iIRz+YNj5xpFeb+xhEd2xPh6AWpXxFLXUeLMPGKOpttaAOzPdCJfEZtjqJtVLbRChwzOKBLwt6de77MgczFSSiMwbW/sfVglE2yoyiTDrKFsC7zZTihCkjqBTV63tHqtmQTsHLNhNK0vanLsqoY0Ns3ibnqHDsPc6UrySsrtly0D0e24ergHa30TAzMGWx7cENTHHsfE5qY48T2/Tow8y0Zm894L6xLF8FwGwOdkwxlmNAbkdfrg/3QVFwgwQf5SDOUdiEsBmyh/4rVm3S33txdMvSlLr+1IyIZe/zJxdR/o1h3XCAwEULuffNxuKQb178DugLajl9hAxCaHAXUvGVEUuJFRWs8ewiCjOiQzWmUcLfQmrJHDdcv6KHrD4RD/6q3TdRISqB9/PPLtE2Qi6HL75uG+Tk0BKSr4eBNwUIVYFvc+ka7xYm3bSbdLPYUAaXwLR8DM2GJI8Z7Ca3ufYqjJFVNTDE+vci08Rz9zO17FllVQ55qcG49WMvj+lp2h4cvgvKJflmZ4Q5iRCqlAHTs4SnC2oY9VSFLVLz3RVq0K8NyPukcRIKFqAxKYwX6/LGb+Vm
 uUdHEVkl
 Wh0opuwdlxXKbky7udbFYwF587EAI+XzdueaNZouLBqNrjm/tPbXCSYQtxXpgZdgpz0RJG6l5r8Sy93pIcRRUXP01dtq9Y3FHhiQ8mUwkEYq9DdTNBBCQohKIyfiJmgA3C5yCAO/boyBPH8Pt4yE1qyujgOyOw12FcWrz+jEfHdsvFKdkt/OP8fo7NUOMdjOPvchgjkuGBv17vvWSGaluNL6vO7kkK52wZAM9+flwgw2kkqLow2aUKjBJW4C05LWJ6xdUT4pLSCNt+hYzmHJ+fIzlQqEgtAfrcNsiN+/2aPv8jVROdIxU8xHTvyruraVYhXWcuqtB7Ti54Em3I6tyPFzu41AwpGgNruYj8LxQEvyJJYZf1aHh3INtSNTora92lJ0Xw0MZljaZwTJlo8DztyZKEPq2kBabm4nRtHSRFhA3kvs4rIqQAPeezNruoDso4JaKKqs0hujWDH+xR2V0hTBVTGxVfa20UAprPuJFuPOLT5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename is_need() to filter_record() and make the filter path return
explicit error, skip, and match results. This lets callers distinguish
allocation failures from records that simply do not match active filters.

Reviewed-by: Vishal Moola <vishal.moola@gmail.com>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
 tools/mm/page_owner_sort.c | 40 +++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index e6954909401c..3c754826cec5 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -43,6 +43,13 @@ enum FILTER_BIT {
 	FILTER_TGID = 1<<2,
 	FILTER_COMM = 1<<3
 };
+
+enum FILTER_RESULT {
+	FILTER_ERROR,
+	FILTER_SKIP,
+	FILTER_MATCH
+};
+
 enum CULL_BIT {
 	CULL_PID = 1<<1,
 	CULL_TGID = 1<<2,
@@ -372,6 +379,9 @@ static char *get_comm(char *buf)
 {
 	char *comm_str = malloc(TASK_COMM_LEN);
 
+	if (!comm_str)
+		return NULL;
+
 	memset(comm_str, 0, TASK_COMM_LEN);
 
 	search_pattern(&comm_pattern, comm_str, buf);
@@ -450,32 +460,44 @@ static bool match_str_list(const char *str, char **list, int list_size)
 	return false;
 }
 
-static bool is_need(char *buf)
+static enum FILTER_RESULT filter_record(char *buf)
 {
+	char *comm;
+
 	if ((filter & FILTER_PID) && !match_num_list(get_pid(buf), fc.pids, fc.pids_size))
-		return false;
+		return FILTER_SKIP;
 	if ((filter & FILTER_TGID) &&
 		!match_num_list(get_tgid(buf), fc.tgids, fc.tgids_size))
-		return false;
+		return FILTER_SKIP;
+	if (!(filter & FILTER_COMM))
+		return FILTER_MATCH;
 
-	char *comm = get_comm(buf);
+	comm = get_comm(buf);
+	if (!comm)
+		return FILTER_ERROR;
 
-	if ((filter & FILTER_COMM) &&
-	!match_str_list(comm, fc.comms, fc.comms_size)) {
+	if (!match_str_list(comm, fc.comms, fc.comms_size)) {
 		free(comm);
-		return false;
+		return FILTER_SKIP;
 	}
 	free(comm);
-	return true;
+	return FILTER_MATCH;
 }
 
 static bool add_list(char *buf, int len, char *ext_buf)
 {
+	enum FILTER_RESULT filter_result;
+
 	if (list_size == max_size) {
 		fprintf(stderr, "max_size too small??\n");
 		return false;
 	}
-	if (!is_need(buf))
+	filter_result = filter_record(buf);
+	if (filter_result == FILTER_ERROR) {
+		fprintf(stderr, "Out of memory\n");
+		return false;
+	}
+	if (filter_result == FILTER_SKIP)
 		return true;
 	list[list_size].pid = get_pid(buf);
 	list[list_size].tgid = get_tgid(buf);
-- 
2.51.0


