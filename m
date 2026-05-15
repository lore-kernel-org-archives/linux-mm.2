Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88C9ACD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D5C46B0088; Thu, 14 May 2026 20:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3842A6B008A; Thu, 14 May 2026 20:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24B3E6B008C; Thu, 14 May 2026 20:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 154466B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B299F160D5A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:47 +0000 (UTC)
X-FDA: 84767809014.12.D301DEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1ED0240007
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F++H+KOl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GUjn4VM6HCECCOLwoFQIA8RXV5nFXwPqDZ3mG51DVmY=;
	b=t2MvsIjq2wZ/Rgrk15wAu3OtKhDbqbV8EfNYcQ3M06y/x8f+5aw50Q23lsMilQdAtD6wBg
	FBZdmuqKbNR1er1FpZIBA+n7Ktywta3QA1ja+xMZLoFBgsZSyn5xclvp0byQKMUJvzmr5s
	BPqMdQNM8HtLcyjA09Hgw5QaU5vVRxg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805886; a=rsa-sha256;
	cv=none;
	b=m1xW4wUarRMibiji0wY5lIVHxPdRasAKqitCtYWj1x6vAn+Z4jMikGOF9QFWie+xPSDy04
	g2TMqLl934MHUaEov4j1E2uNpHxqlT0B0TO3LyUqjatWLm1semL5ig4wdt2pOZYIOTqb4E
	pONnE7sdrXZJk3qPQM9Q9Gvqf1yxiwg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F++H+KOl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D0DD44720
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A52C2BCF6;
	Fri, 15 May 2026 00:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805884;
	bh=8LT/D7TOnQRawE1lXMWBuu0a3XIQelloreA4qB43lWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F++H+KOlO8MkMRFskBBG0uJWm7L5IQ1LPJ09nhxBk6XE0A7rwOF/Z3+ayz0m0/Lxn
	 jajmFr4tcELhu1v+vGb9IXiX3JPeBbBxG49JXmsOAT4BnSQacCKpoFNU3Ef9x/V77n
	 OZd7nu1mgTrfG7hPtD6cEvHqM0k/cp7j8+EEgi8XdaakFOrlHBNV0wKM+pwD4V8HFE
	 0SQquwLoAsL5cZnPW101qK5/1Pjzr081BUFQXysh//fXYxWdk393r3Qtajz84zesWM
	 5RKGjwTzHIuTAG1okjniO1BM5lNLjTVvOUlCMOCvbNoOf3w251Ip5hp7hJenv742Nc
	 aREvz/5OIvPHQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 01/28] mm/damon/core: introduce struct damon_probe
Date: Thu, 14 May 2026 17:44:02 -0700
Message-ID: <20260515004433.128933-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1ED0240007
X-Rspamd-Server: rspam04
X-Stat-Signature: 97wr66767qyepmyaxs56kiiw9q4px4da
X-HE-Tag: 1778805885-829662
X-HE-Meta: U2FsdGVkX19aIiBQKj2trkgi8JfVHxAdZQGXhiFo+Pr4P7mhYU5Mvda7M67bnmxa5UAIrGSktLcfZfTwzP+tOHBBuWpb4zJTBNBjAgpePexZCjqaLjUE5yINeSFUq97Y6nKA8PefW/Fo1JGplTEgB3DBS2hCtDMeyZol4oYl5Kh3sI3OTgouGBIiJiLsTBIF3ZukRI2+5BCA0Vr/XW1Sw+1SkPTWBSn2mYO10MoLJ6xuic3uLW8Rz2OX9wYqBlSlfOta8JMQp4cDx7b1TMlRkrtKzBpF+TJw14WBKuWtLZUqyDA2GZKg9zi26DmtimXZkP0jg2bPnBiUVnU9WRwWlYcuFewonHAEeY4PrqrGkLz3zC4q/vO6gZ3QrsYJGbk7OL276n3sw0tiU9MxTcGieowb9fZZe2yMlUVyNOPWZRkNzIZ0yCdAldzZL6Lgl6C+HRd8dnxd/YJoRQqgr4bNpvldm6FZFS/pBzMMV0Q4LbV4d5LID4dlUdIjdxpX6c36+wX7JmXjmVer2anqbKhBZYINR0BQ1L5TjMw7vGPNkSK10Z8P1sEeOWf/pO33B8oSeVTF06IeygLcrKr2HOP3yRUs/Q3SygeRQpFf1jeih5ehVfPmD72NZebL/z6a1IDESFvzBA/aaXY+qH9928oPidySOyRx7uyRDHpc9GLFcmrO8i7HuUDMatKv4o1zD/wqnwvTM+w752sb66MeeCrfO3SEri4kLwveyIrMpKIUFOiiSL/c964gUdUjqitgZiYuJjAgFGXd5QhZMS8y/tLvmbI869GTlxv9RhXphDeMWvhBgCQVANgb5Vd8k7iKJKvZgxKJw3VSteaxMZJpHtNUERAsfkdul9gQ53ckUxZG2piQ2HTnUcO8Py847EMwDvE6BYdKUcCSwpiya3mkFnPEO7YPrjLQMgr5diIdjzFvRTNbep89q7dkKvfbTxkPjj3cmJPB4jwmGe8ouEKv/CD
 vDLPkAmT
 yDFnCCNXWPtx3BGyZvZ1dAsIa99162V/i3Ig9H0t7LBI6AlK7gr08Rkv9gReoFcQSm4pmezbZ/mBykhZ//5Uee4S7XCon5GUWhqWSzeic7jYczoQ1rUYvC/bLPwXJ+Jh0memmCFslgxLEUPpWU8BQ3NEutxQmgIYDzR0nqRyuzD6nqmKU2eku5lDg0TwJRpINu/HN9BC1NvwjQiRCKefbiNZ9d/ngDTsuVaz8F+vcFOH4FnNlHaZLIpPAz2UbwfFEMW/biV+vcX/pCKy4xGn5u6r3cbfwNjZVdKph7bSIZuIMOk6w/DLU1SKUAMZoJYUVfz4ubes4GYds3lNIPHubkIyZJUyR4/WbK04B17M1yAKapp/UYBSUhwkl2g5YPUbrhfeA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a data structure for data attribute probe.  It is just a
linked list header at this step.  It will be extended in a way that it
can determine if a given memory has a specific data attribute.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f2cdb7c3f5e6c..a8fff5325b010 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -721,6 +721,15 @@ struct damon_intervals_goal {
 	unsigned long max_sample_us;
 };
 
+/**
+ * struct damon_probe - Data region attribute probe.
+ *
+ * @list:	Siblings list.
+ */
+struct damon_probe {
+	struct list_head list;
+};
+
 /**
  * struct damon_attrs - Monitoring attributes for accuracy/overhead control.
  *
-- 
2.47.3

