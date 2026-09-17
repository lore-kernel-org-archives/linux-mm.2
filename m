Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13512C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 04:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 236196B009B; Thu, 17 Sep 2026 00:05:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11BA56B0099; Thu, 17 Sep 2026 00:05:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB01A6B009D; Thu, 17 Sep 2026 00:05:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1E196B009B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:05:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59DA1A2791
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:50 +0000 (UTC)
X-FDA: 85221915660.19.CC8A362
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C4C7F20003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:48 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NLy5Z/jH";
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789617948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PDYFtYaMI0AhnykvPFvkzlsotZmDoTCT5c0S8nqI1O4=;
	b=ZI+VE2Wkw55ommNghZ+gX88eJI4VBLBtc6l7AiCalheqmNa9TVUi7FgolwOumbq2JwaclW
	u8bn7glVKYBGpgO1a2F6+slP1h+N+mYZDDZJTmqKyiQBaaumgt/CfT4pms/wqVZU9QjL3A
	SZocfXJGOj6xG7NL8zTWoxRBfHmumG0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NLy5Z/jH";
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789617948;
	b=LGGZx/nZm3dxFwn6agH9f6PZ1qqsXO/jBg+7M46yIBnQNLhB2D+Aqb8csDRrqWTEfiRbxY
	mUSOdMfhVKLam+61LwTrj5HXGpXXmQ2y6MtWxJkSsHKaxXU+sRlGwE0kNSpIgD0OsM1h5z
	XQfzdzO8Mz2NKuJMThHVnQAtUS0VvnQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D5A3144033;
	Thu, 17 Sep 2026 04:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE3B1F00898;
	Thu, 17 Sep 2026 04:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789617947;
	bh=PDYFtYaMI0AhnykvPFvkzlsotZmDoTCT5c0S8nqI1O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NLy5Z/jH1+4dW/Yv3fuWWsqcwJbHuH4Bx4sq02CzSo0x9EY1cLKhIflZFhRTlu0/f
	 AY6MfHFCp3fRe5oU1QbtD+4yHCYdzXR7W00DWNScRkznBrhufu+aID6C/Hp/cyRKTu
	 C2vkv+AoIhr1n9Ghwr/tfXfb1mkR0Koi3velQZlIbMt77XNMtsJYF7l8U+fHvtOhLQ
	 /gMfhtJ2GWYbc0CMeuZX0o12UAzebRzYCaZCyGNPDCt8Uc53PEPXOS1uLaPUYwFSou
	 smGV+thHWKYurYjIQXR1DBmtSEC1Ce6M09b5AbNPCSuDguhyvkZxlWcgEZagI+W0uy
	 4yYWJsNOPBJ2Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 07/10] mm/damon/tests/core-kunit: test eligible_mem_bp commitment
Date: Wed, 16 Sep 2026 21:05:33 -0700
Message-ID: <20260917040537.107341-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917040537.107341-1-sj@kernel.org>
References: <20260917040537.107341-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C4C7F20003
X-Stat-Signature: 6nugb3u6x38sou4g9sgywzu6ykbt48ae
X-Rspam-User: 
X-HE-Tag: 1789617948-618394
X-HE-Meta: U2FsdGVkX19+OO3g+6jsow2cAkW1My/+IedgMdscvZSReCaZc+AP5iP4zjctN1lpNYEgWKTHnEg6SS/NaNfOr3HK3/tzayBGvMT6Ut+H58P9xw1RX44so1LF3/s18/X6seZysXZB8LcaffQHq5H9IUriELsVXa9Hnfb0TGpUKAxBMke0CL+vF80gNvcIYX6iEeaS/KrfHFY2YaTsu0oZEkl3Qghov3wTIFOvvYTcXUjYvo+Be6VXmf70UwjMWzZZOaAKy5SER43DKO7//l3m3RfbDRmXugBf+ACyrPVC85IRcBW0BjiYpu6x0nMJAldRDZ1cuifjLMdhZq/sE5Tp2FVyVp95EFPBxT0LPB8GyL4XUjOHv5OU56S3dZbTDfVQA6C8BVQtgI0hte1rtBD6JOUOEnGYB1qyTBpLDpOOP/wZRb8b9jwlwZGikieFnRycaR+/llAzYh5PyIhdf1ReocaJEINjRSvV1UpslYun9oNWUAbYHFBvJ1yRB7JGGWS325gRkq70FsWB2LwMiCgEx1taivU+oJ5jM8UpTY8mKykGyCLc8uwRqvQoCHlmuANZ+Da/qbaNMBCtKZmf1l/XatQ/VBHxQUjzib73UbcUQqF+F0eOZxOG+bPPPrKL1Ng3lf/JHFRhqoYhSt/qlLw/wasrNgmC/HxUBBaHhsYxtnmzgMqqv7P7l4KFdZQSkMqExhMDbNlKaTmdLIw1SwD2pMiIrnv5PZDcxhbzvFC1EeUdoaATu11uTBf9iiUMuVVFZAkNYEzXyMpBbgULU0T0GBgkz4noGUEiKV7dnLGrqEmpw/J0WnTnM/WJql999xlMJoOYqYtDd1ejMNhEBicyHMoW66YUALdHUEWfM1i5A9xLT9vaTUSAWr5yefLuqmWRWaAzYNykBlNhZriEaG0V2HrkpbHQWDYFgnQRwdz0uhx7K5tLbDSQVuwFCyRxriolleyWyhkzMF7LAVC/tlb
 eFk2hdNS
 3kLGR//DEzNHK8E0rrkI7xepsFNPQKVkjvrVy4/v+PAVZK33Tl3xcAdY8r1GRx5XwN22rLCXuTy0cz5ff19EwrJqOkoVOJsIyEg2eEhve+5ZkpXLskxjTyJ6jvnESx0t6ugninU73HQIeC9FRqoHoBuUzRmR0tx3M5OS+ElnCx6Z1csuVnF3GgqSFPLtCNLq854X1HKod2/PIjwXKdlquhMPS3tBid3nQRjvRX4SDIqGINeR6Sk9h3w2qJ892TM9WCTf+5EeedOM6XimEPNdQrZXi3g8SO74sGrwTyRCLiKAGM8cFaX7hZiR7BIwJlaqcOOn+4t9Bi9PQrVBDnUGgHnWfoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There was a DAMOS quota goal commit bug [1] that doesn't update the nid
field for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP metric goal.  Add a kunit
test case for confirming nid commitment.

[1] https://lore.kkernel.org/20260827045035.94611-1-sj@kernel.org

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 82c542afaa60e..1244cfeae5e70 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -835,6 +835,9 @@ static void damos_test_commit_quota_goal_for(struct kunit *test,
 		KUNIT_EXPECT_EQ(test, dst->nid, src->nid);
 		KUNIT_EXPECT_EQ(test, dst->memcg_id, src->memcg_id);
 		break;
+	case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
+		KUNIT_EXPECT_EQ(test, dst->nid, src->nid);
+		break;
 	default:
 		break;
 	}
@@ -898,6 +901,13 @@ static void damos_test_commit_quota_goal(struct kunit *test)
 			.current_value = 345,
 			.last_psi_total = 567,
 			});
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal){
+			.metric = DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
+			.target_value = 12,
+			.current_value = 345,
+			.nid = 6,
+			});
 }
 
 static void damos_test_commit_quota_goals_for(struct kunit *test,
-- 
2.47.3

