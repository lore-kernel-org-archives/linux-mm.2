Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF801C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 04:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52F246B008C; Tue, 14 Jul 2026 00:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5059B6B0096; Tue, 14 Jul 2026 00:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30A356B008C; Tue, 14 Jul 2026 00:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D98296B0096
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:34:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A3FBA0295
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:46 +0000 (UTC)
X-FDA: 84986116572.22.2759202
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id CC155120007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lFw4SMDE;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784003684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K9M+/498pDyKMm1s0mlHFjJL8e/IqqSwdiOP+0fBImU=;
	b=ubudUJqzm+VMR56TubvXzOlDpQkt7oEEBrb7KPQuR/6S8kNaFB7aroCDu+rHrrFJsmYefM
	opIHa5njDXz3Ct8ThFblX73EYiBu/+I6QuBC+WST4Bp67MUqZXyWmaXZDB6Y1nAYfMwrLw
	uLLqxvCB6IlPaDkmiU6j/5l43kLNzP0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lFw4SMDE;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784003684;
	b=lrxQFpLd7Zd5+xMR5yD75M5vpwvtO9jF7Hp+GJWr/wsKuqV9QXzV3M8RPJPjzdW7/uL0Yr
	5M++mRbG3dPMVwhJiMVaLKntVQ3EElCyan2QMtLc5oiFN9sQ2mRxpTaWibDS5Q34WVxIJT
	/NwfVn8eMdyT7a1HvNatGiUWLqe7F5c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A35F43C64
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D5E1F00ACA;
	Tue, 14 Jul 2026 04:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784003684;
	bh=K9M+/498pDyKMm1s0mlHFjJL8e/IqqSwdiOP+0fBImU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lFw4SMDEogKyEWuA6QtbGBzeT6n0wFQfRE1ayLXO6ZGS0GMl3ZTITnpyo1+Qy+a02
	 AxjZi/yZA4CjXGPHBWyqDOFzJQswXUOnaRub7RrW1o2AwaZwQ2AnChiqfr7pQLSa08
	 DujXVyHhErK/TEZZUkKNAAipDRe/IPBMX3y1gE1z006FfEPJjrzX++vv+gYFyKQdwU
	 +ZLAyxoZQcGxMTnCxdtrVwaM0zkTjUH6S9M9q3iiJ7BHZk+sfmjpCEG0CmmzVPoxTW
	 BqMFY9+w/OmDRLaEMuUQ8nl5PyYsiyWiI+hsl9ouORR4N9dzM+BhyKed1xGyHZVs+Y
	 EoHGhHPbS5WTg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 05/10] mm/damon/core: hide private damos_filter fields
Date: Mon, 13 Jul 2026 21:34:31 -0700
Message-ID: <20260714043437.95811-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714043437.95811-1-sj@kernel.org>
References: <20260714043437.95811-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hgr3i8etjqpwmboocez33qo3dgbzkpjn
X-Rspamd-Queue-Id: CC155120007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784003684-306538
X-HE-Meta: U2FsdGVkX1/z0JHUUMfrJbUG2QUgEcLIFINvKttH0EJT9NeWrhhkfGos2JAVQrLcfz4APNrobTs7UL6wxjmkypSOgmO0mmYpM8FUFFECl0PiQbEdaWPwfe1xITQhQUSHCaxoVPgnd9XhD5cPkKMjEbF0Y+Ec2oAGR1UGcH+u2Ok4or35LHnT9c1mkTycGmFqabt/YHuBzVSsBUd+jHfVW4mB0jVjZ3MI8SrpkLYPhKYiK1SYcBujShMRP256QgXdKCF+7wXW7dIhuAHY1dqRsEx2uOhLt0SAS1cF55axkUXHYiwEf4hirOJ8mwfZ4tpFTnAg9ut17bDTydLR1BwFOGndcwJ6YTCBG5kEGEIFRT9dG4HVV+6JReM8esr2fsiHY0jbA5GdDVCbkhBDFDJkhr+tvbY0lY7yxhBTuUTYcI0wIjcugs9pHjrWg/7SJpS5ZvsmtdJ2Up9P0coR9jlGC8NOWFy1t2SrocjurI21JgqBntgWA4fjXDtqyVK7dB2tc89KD+CVeBp4KsXzG3pz2t7PEwIZL1lRF7jIC954zQXcPUHNkz4uv57V9X8zLPTe008W1P4cpgqnXxwe/bVCnju+uk93247CfWqIgxCJfyOFMLrWMQZOo9pxTj+IOt3KudlcJiETXeA74pnTEc2jHd+IojDhQ6e1khRD0GkIm2iJBc1WdEdFXPcokREDNhmrDoPnK6yjsJjNm2SrPtS/tHHi+9g9HVXExaRbgZ77q9b3J6wiyw0xknIux89BVdgZixby+TXMKGztcet+0Om1QUBAbSqsvxOdh5Fz1apKCJ010ITbdBBeIvX5SQpSMMO1ttdiPoDe0fF7ioZS3cW5E+PEhtemj/ji3WW12wBqu4JYugpMu6F1y04h8T873qjmn6hUuqdnE/SomIo4pxgBQqkgRADI77zSV4Dg63+D/eXX976epaD7vYUJ1QYKDIXZToROPkLhDD7IKvMpf8A
 ab4qHK4f
 5P1cDgyd+VTI8jszonsD1L2ZAr7HImeykOdTBnlzYkQ688JoLjKWitSZOnhyD5J7A+BnNbo6vEE6jATJN1AFyitqpFPT1K+jyFZHHpaV7G0hLbZLBsQNo/zhYewoCvS/SusLUzNTG9dMZ7GIJ7nWJPAqLwV5Wzj4/W4xfNPBs4r0pWxyts2zLmqZQXQaE2l93sozmFbeLaHyjJKmuTD3KuNqRs8w3qTHma2DqaELkSBdsPxfllbu2b7nT2I/Rqt6K35t7ZHtmgD11SS/TJ9afWT6dGOGcMB/UuojMLs0Kl6T/5/rbnUeBpLdqCkileNpS7K49Uc/8wFDaNqqeNvsDE+RbIfi+Gj4pFpwX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_filter->list is intended to be used by only the DAMON core layer.
However, it is mistakenly not marked as private.  Mark as private.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index bd024b89adfa3..15517be3e4960 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -432,7 +432,6 @@ enum damos_filter_type {
  *		&damon_ctx->adaptive_targets if @type is
  *		DAMOS_FILTER_TYPE_TARGET.
  * @sz_range:	Size range if @type is DAMOS_FILTER_TYPE_HUGEPAGE_SIZE.
- * @list:	List head for siblings.
  *
  * Before applying the &damos->action to a memory region, DAMOS checks if each
  * byte of the region matches to this given condition and avoid applying the
@@ -450,6 +449,8 @@ struct damos_filter {
 		int target_idx;
 		struct damon_size_range sz_range;
 	};
+/* private: */
+	/* List head for siblings. */
 	struct list_head list;
 };
 
-- 
2.47.3

