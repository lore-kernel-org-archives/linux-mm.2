Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40C4A606D81A
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 20:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fcq25Rk9
Received: by kanga.kvack.org (Postfix)
	id 52B636B05B6; Sat,  7 Nov 2026 15:10:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4444C6B05B7; Sat,  7 Nov 2026 15:10:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356066B05B9; Sat,  7 Nov 2026 15:10:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E75A66B05B6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:10:15 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FAF012032B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:15 +0000 (UTC)
X-FDA: 85409414790.07.271F4BE
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5DA6D140003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794082213;
	b=H3jZuMMJ1egBBPz7Z6MOrHlCaD6Zju2d7W2BYuP3hLypvCCsOSqDFdLVIWFmWC1tM/+4iT
	20sbth2hn3NAJY/RtH7W4fKKuRSNzU0RcPtYdhlwZ7lUzzv0cs8dTtxjz8/ql5COhunco1
	48uSseOrWhKwrimlkSZeedEoTfkZJ3A=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794082213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7U2bcNPCrBwzjsXKuwnPci/B9bQIw0g0WjpcO31XJk=;
	b=geMkr1WDB4F8Xyf/7ICYEnZ1g9BUTBOrgQ327Xh9RdBp4m4wn47+ILZN07VDF56QoHTWDp
	sNhtgfuHeS9mnd0FHGefseR3UeP7sXsIVpiw54J5I7U5EFk+uq9/jwfGGXAHa7ZQC7YIui
	Y7Wq5M7vpL40ad5DrpruOXUsh7gdjNM=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E43251203D4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:12 +0000 (UTC)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B4CA540229
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:12 +0000 (UTC)
X-FDA: 85409414664.08.4F3A1E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1BD5116000B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:10 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794082211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7U2bcNPCrBwzjsXKuwnPci/B9bQIw0g0WjpcO31XJk=;
	b=JbjbpYgXr+VA6g2zXzaKAzbhZYTH6aw7/ciqnCEvUFGFvIqocGFN+Z/noMBTRvGjpjk5XQ
	iWyTrO7I3xIyitDFCft9vSpVf839oaYDpKTDstCY1DmEBDsfbMlURmOtM0Fhkrfrnz1uF4
	LlTGoKTqt3pzxjtbRk6LExZrnjrniik=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794082211;
	b=6/AheQ4oL7pw0qceoIZqYcUyY1XF9Fgiw5HsuiSvV/Dc6MEZtvftEtXBFjpkmu6Vfh7/wB
	QOB5N9VGtFVQl2tq1hWxupUjOc88+qtWILn+izfVek+iuLfuTDmJAEtnpKspx1C2WsKzAs
	osoGkTYQznsLwGEzxswHfGhVZGoiao8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fcq25Rk9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BBAF61198;
	Sat,  7 Nov 2026 20:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AF21F0089F;
	Sat,  7 Nov 2026 20:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794082210;
	bh=/7U2bcNPCrBwzjsXKuwnPci/B9bQIw0g0WjpcO31XJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fcq25Rk9wDih03eqM0dlNBTkWHIQAQD2kLZ5vXyWgLDMhBS9qeC3I8FfEBwhMhEf5
	 WJlUtvd4IkD/ZrhOhG0kfhzn+zb++D1EDsXx+U46Moy5n08Bm0hTEUomea+lvNLq1u
	 xnh0YWrBaZNSiy8vMQdCRThX61jNJIg0r8pA6PmkJ7l2tJ18u4ovuZDW7PyodO1Oqd
	 MnJJY/dbYC3hMLp3sEcoNKq3ty6L7XxbW/ss3j//RouhSFwkjMo9jHswkjynehnQBQ
	 +0RHzXZMImB6M/kRwS396C4Xr+uC8nUiM1TQLcpfMIA36rIF7YQ656aps/7dS+u3lr
	 ZWt0p6pO1oX0A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [RFC PATCH 6.18.y 2/5] mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
Date: Sat,  7 Nov 2026 12:09:58 -0800
Message-ID: <20261107201001.206120-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107201001.206120-1-sj@kernel.org>
References: <20261107201001.206120-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HE-Meta: U2FsdGVkX1/+CWVM7cnDsX1lEqiHkcPtfeiTbglJ+40ITVSd2EBIktiIienwoBaF1+vCSNsZl6eHjOWqao7CYv/gALy/1zujFMOSUbPVKmd2a0V09ClEc/yy9iRUaTz0YxogxERi9D19Y2KhBGLfTJo3GQylzR2sDFkEa0KRNxsLMKymR0WNhtEe9yP29N9Ky9pNGkoKCb04qkfNyYV7LH7fza1ZPU829NudqCcUu2R5BIRJJ3ntNBINEyniX2sBJ6Y0IspVY8ZZivt2MXpzL5rWtFOPF9ZFjR3lVB9nsJTZ0coP6a3BS4YsQvW0YxbmS35VyV9DArs1qwyJOYovRt4XrxeRzZryBAqRWF4xkQbGYEZ0iFCiz+OHkifpkj2iFVZjAtzjlwTuPatDR80/+ZMis3Kxa6lHJ4DLyhU92oh568gomhsQlAsKRS/shqgo1y+epdX3AxCn2/W9uoLIezn7t2/wUYcrmhomzwRJo/5gLr+c2T+TahlIuZsvwlYTb6asIisDiAZar4szVMpSGO9UreqwbgVP3Gi6r0iYn9yVfhDVsWFKjDw30yHaAbiooS9S+LwlpVxUw0+NdpeIw/zkOUXT6aOVVTdREXyGq0rO3gwQbudVPCq9wuM+kleGsLYMXoHQUWwXYuJf6beq4wNQkQ59bYETNlAdQr7kYyFpuUj0Jqi7+YSS4PpBgrRXu85B9kNTG6mADTr/OcwidIHOcoLF0LAB/z1n9VZwEgCm7kcvaLHxqUxnSGsl4rTW2roYYIj4m//UNDo5wzRqnifXngjrQNFNtTZHnH1ynNugEL0sFzk3iOJ0jraFHfzh81E/JhoTHXGs8nB3fD72WVQ1UHY4gcEdpW80V6/8tiWyfdH/vPCptQtV97RB60m2Ug64PXxuVjNj/SO4V7FFo07TSZ8/CYCDfzsl/+YvRDzb7GXpJfXWJKRQnQ2tOa1YTz8e/C/5GqwDUxxm6hY
 RK/x3B/R
 09RMWqmrbOiVLdrHPHc300ZY+p0LiYRV2ZpG9DRy+DLHvLrb6hJtrIjgzzUiGJhfxhuYPoBCpbGYEg/bdiR8EhS9INFClHi565dvuXwu5BK0YEBFp8c/8hZuXn0SnQZI8KlD7Bit1BjApQCEsAHpWPDHWCrK+Iycl1JMdKnP7psTl4nKpp/UI3YXzZEPVOlmZv6MohwOKi+M7K5luk2OHYWDP6TPuDACndXLLT09R+/FaAMmSr/dpyTEpadXm2QZNgLYqMute9ouzmSMfn8YDra9r/JykbbGuvtm4kU0IPSsToqrm99wsEVvxMtQLZNHrYWEP+CP0+e3Ut00FMscP2bhe5+BmwezF07iYiCHyLbH6qbu6ihOLGY35yAG3pETP+Q5VYgVv2IjRhQvYzcch3sRafPkTTQZdMcAfymt8lG5QgbezWsNrpBL72q1oGvhLoje20GTCQhZQiik5Hh+8099kjqKlGDNucw/AaxVoZkRftiDcKtmVAHi2qo6ZkV/WARuToQHjJ8IDRfg=
X-Rspam-User: 
X-Stat-Signature: dizn49mppspts166zkrs5ewhkaj9x1e3
X-HE-Tag-Orig: 1794082210-449948
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5DA6D140003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794082213-333555
X-HE-Meta: U2FsdGVkX1/TpxfABMljyXlvQPNG36ecDszenCZCKKGpc6pAfC0YkMvfGUIl0BqR0rdc0xMfQkfzamrIH8kP5I43D8AfnNx5QrXFZXaojSjlnyR/Rxtb513gLYLgAuzc3O0c+p8/jE/f8bfLpe9VGpcBS/eHRsIFOL0QprFnwJ60W+69MQ9uQWxDcqt1gNZNcw6aisaztl1iTPo6RzQFjVZ1CJun1EkskGoiiVrtcwtnH+ZaczjkvAHP+GSLEKg9ONngBhNiqEj4PHiecHd5hY3VKyBoijEtupQpcYL7BPALYoNGG/HwCv1GoYPHLkk+9ocSSPfMBhK2S53JThH9nHXNMPCdO88p/R69jMj3Rvppb5oItBvIZhNfOB0cW8sVHjVq6DDpMXR17+09rfuqnWHSrKSLL4mmeY4F/mKbUh9dZCcUfaZsl3bn4AESrJbBU9IYx5M4a/6s8vM/cqxHgyg+vRlFihNidn8v/yg6Uze7olX8ELuFw2kStPYE1BfaUEsXU8fu23ZriKt7raYRrDE1vRGS1BDTyVCmYxcYPslI2vwOdXfs4I11l5cOUauWwXxekpBVVRhritH7kKAH5WpHF8n/awjXfmQivAchWkUZLtN6NAOtVyNICCI0iRt8+fyZEnuZmDvE9mVje8LBnh6rngAAONbQusHS0Ypc2yGFhRNqn6kKF/zkf0xZKU8PvvZyQo6/0DJ1cueRO9eAaIgn2+CBpqFBOgQcCooViJ1SdLmMpGbBJRhrsjQmF8ZFlgCMB36M0zu31yzIQk2oLhHv9au3RDKh9oAh1blvA8U96fI9cSOcVPF7JwLeY0qSyFYPDK2cXkYcqTQ3iND62MA5HCLQseDA4GcBwPS561qcP+pYxCtlcYSFhABRKrEJcf9PK8Tuyyj7eCX4FjtgCU0qaOWfxuCL5UPDQv9s9cDoNU9SSIb4npfats9XejdYg8oK4yxZZoEsqEhg033
 kJB6Jql6
 mFvsqXzmvzv07GIi7l5YmdsV+A1RXRu5AMhSsx+GGg3IVS8eECvSH7NM0N2AF8fQku7gUOZBZlcDV/trwo+gutAbHQQa3v4+MyVaczI/4mCTDYd59CnjjnchpS8Sd7ABQMKo1reLSLwTTSWQBN6/+9fdYj1yFGae06kOih12DGAjtwONRcdZeNO0uW3V9lezOW8QdydotTgvXxmMR1NHDmfU98nRahbXVsabIo/GfezdcbDgb7gXfjocRd1b4PjQf/xJKSTWQSrMZaiL5jYNAV1u3fAwPHqWpdmIwO2ouC8qNyRMIZHJ/ulAn5cjUcr8aRq9mlXquL85jl7xiPvOKUsFLgcjZ+5dXcG69AB4Uzh7x2dcDHCeSjrBstRx2tpncddzeOeFSIPbvXrFis0uTNfDWcH2qhzoIwDOk0wvavq6dNMdzGdSkfHLxk50+2jTYI6v+RkCnWHP9RS8+u786ti7rpNM+oi/8prHQK7FWI/tOZod8nO8iTIi6m6M3n0D5Y/EitQT0/OyfzbmHMaNAV9LyMcPgNs3O490nKGU6Ka/bn1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When DAMOS_QUOTA_SOME_MEM_PSI_US metric damos quota goal is set, the PSI
delta for the feedback loop is calculated using
damos_quota_goal->last_psi_total.  However, it is initialized only after
the first feedback loop.  The first iteration of the loop uses the
uninitialized value.  As a result, the feedback loop can change the
effective quota in an unexpected way at the first iteration.

The user impact of the issue is not big, because the issue impacts only
the first iteration of the feedback loop.  The feedback loop also has an
internal cap of the quota adjustment.  The wrong adjustment will soon be
corrected over a few iterations.  For this reason, doing no initialization
at commit time was intentional.  It is also explicitly commented.  That
said, nobody likes behaviors that are unexpected or difficult to be
expected.

Check last_psi_total initialization and skip the tuning round when it is
not initialized.  For this, initialize last_psi_total with U64_MAX in the
goal creation and the goal commit time.  U64_MAX means the field is not
initialized.  The tuning round shows the value and adjusts it to guarantee
the current quota is maintained for the round, and last_psi_total is
correctly initialized on the next round.

Before this change, committing a new PSI goal on an existing PSI goal with
goal-only DAMON sysfs command (commit_schemes_quota_goals) just worked.
After this change, the tuning round right after the commit will be
unnecessarily skipped, because last_psi_total is unconditionally marked as
not initialized in the damos_commit_quota_goal_union().  This is an
intended tradeoff for simplicity.  Skipping just one round of tuning is no
problem.  Meanwhile it makes both the code and the behavior simple to
understand.

Also update the quota goal commit unit test for changed last_psi_total
setup behavior.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260902002725.108635-3-sj@kernel.org
Link: https://lore.kernel.org/20260718005316.89585-1-sj@kernel.org [1]
Fixes: 2dbb60f789cb ("mm/damon/core: implement PSI metric DAMOS quota goal")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Tested-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Cc: <stable@vger.kernel.org> # 6.9.x
(cherry picked from commit 29c6084658af41b5b1fefd873d26d441830ced34)
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4c536a9b958e4..f2666770b5436 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -348,6 +348,8 @@ struct damos_quota_goal *damos_new_quota_goal(
 		return NULL;
 	goal->metric = metric;
 	goal->target_value = target_value;
+	if (metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		goal->last_psi_total = U64_MAX;
 	INIT_LIST_HEAD(&goal->list);
 	return goal;
 }
@@ -798,6 +800,9 @@ static void damos_commit_quota_goal_union(
 		struct damos_quota_goal *dst, struct damos_quota_goal *src)
 {
 	switch (dst->metric) {
+	case DAMOS_QUOTA_SOME_MEM_PSI_US:
+		dst->last_psi_total = U64_MAX;
+		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
 		dst->nid = src->nid;
@@ -816,7 +821,6 @@ static int damos_commit_quota_goal(
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
-	/* keep last_psi_total as is, since it will be updated in next cycle */
 	damos_commit_quota_goal_union(dst, src);
 	return 0;
 }
@@ -2171,7 +2175,12 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 		break;
 	case DAMOS_QUOTA_SOME_MEM_PSI_US:
 		now_psi_total = damos_get_some_mem_psi_total();
-		goal->current_value = now_psi_total - goal->last_psi_total;
+		/* uninitialized last_psi_total; make no effect this round */
+		if (goal->last_psi_total == U64_MAX)
+			goal->current_value = goal->target_value;
+		else
+			goal->current_value = now_psi_total -
+				goal->last_psi_total;
 		goal->last_psi_total = now_psi_total;
 		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
-- 
2.47.3


