Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7948FC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:36:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287726B00D3; Tue, 14 Jul 2026 10:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265A86B00DA; Tue, 14 Jul 2026 10:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03B696B00D8; Tue, 14 Jul 2026 10:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C22676B00D1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:35:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 156B51603C2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:59 +0000 (UTC)
X-FDA: 84987631638.09.D5FD1DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8877220006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WnjEMvgF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784039757;
	b=pVG3hGVx5vyKF/Z/hxdGoHge4rDrHvE9OnU+DAwwa45nB+SHJ06VDKcWqj+1VCUyUtl3Hd
	Kr2nJ5YSq0tTR6eH6vXatjJEV4Sqs2nc+bb7Yq1uJ5+p0ceZAtLkHUf6lmrLm+62SHKUqi
	Uztl2y59+AA1HaXfvCfTbu3xWdPJmq4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WnjEMvgF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784039757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K9M+/498pDyKMm1s0mlHFjJL8e/IqqSwdiOP+0fBImU=;
	b=DqwlZicq91KlrVrNCpFAIbfj6kYlPwgMqFEhYz2m/+7hX//MAlmUkBLWhhB11wW0vyS33V
	OEJJqtRLolGaXsgprVCfwQxHFqs+6QE3VljpwJ51rgr+eHCWjiOc5aYIETxlan7Pvwdi4u
	fm1ooFtIxIxANR94oUlbgDf3/zE8+SY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D774C43779;
	Tue, 14 Jul 2026 14:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957F31F000E9;
	Tue, 14 Jul 2026 14:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784039756;
	bh=K9M+/498pDyKMm1s0mlHFjJL8e/IqqSwdiOP+0fBImU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WnjEMvgFAHBy/bzZQA4a7f1Y36g5vw4oxOI3sJN/eEZTgH4K8axXPJnwr649a+LFa
	 DlbXW0ZCc5W06Wuksp76J+nGs2n6y+gQu/2x4rV1S7JZ6R/f6HSbjDk9gX6yA0nF0r
	 7sKafT7Og+gChSqB8vcM9rj4dWncysS+TXLjhs6thBw+wkPC4z5yvvVZuzo+V00S2s
	 n6xx3u1qr7rFe1ou6nF8dohhyKs3foNBHilrfNSyZ5T490c695QCroKE/uvZU+DR3E
	 c8cSOlxmtTQO+9fli2Ju/xndl0khBw+w5HQBbbZRt28kn3+uTBzow6denRKj88hF6q
	 MQEKH2adAzeQQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/10] mm/damon/core: hide private damos_filter fields
Date: Tue, 14 Jul 2026 07:35:38 -0700
Message-ID: <20260714143544.101305-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714143544.101305-1-sj@kernel.org>
References: <20260714143544.101305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8877220006
X-Rspam-User: 
X-Stat-Signature: 9ue8dac1dgjwe9cu63nxnm887w5adex9
X-Rspamd-Server: rspam03
X-HE-Tag: 1784039757-156507
X-HE-Meta: U2FsdGVkX18gVuXNaLwg4W/NxWJAicjoq8vH2SRwLjsHfRE4l1ZUErUqb/uNLPrcemSJGoQSsgme8gmXjvQQduWWgaIU9B9JQVklzFWQ/yWQbeboKWlV5C3u3+PdQBMEoo2L/M4JRxf2vWGoUNHyEEM7Wthyr79mZYB8T4ZtBcgdkBIyqugNKT3/mSjPyjWrXCJJxj6DhXkn74TMhDBKMJLkdBSC1IGL95QObpHZtlmOP3AU9/XwaRSitN1ezX5gUh6jDBwQKHl0L4pa3cRHsoifOzOxY4Dfc+EGVE7DNIABTzFD4rzgEUKDE8oFRFWcI+TiV8hgwJiQBz7kldOAAsczyc5mPWxgYyeGLDVUBtHHC8AGyIP8ISAKdN6caNLmS7oe16vQUSB+gVRoo0ag/gBqb8/6ccGJdtY336JhVSM296yd+QYf+uGPy2bRlSHWLAvyFkQc0+4zcEaZFURd+19qfk52N/ZOHtK5iABJScoVvL5OIToRHVio0xzBV6iI61AuvJVDLnSzgk9wrpOp+f+E61SKVl48yZixS00RUlG1SZY02xOwGrtqS3NKCNFnynARVlh3CM/L7h29XFYo97pgA8g96T92rTawWAaJ2Zw1zbw6c/bmla2Tt1aP3Ybs3loTqg7WIaEqWQuYGyoR7OzEdbmmbUaqbzP1Mm8MC+z0csbnPpAqdAURt/fQjPW/ZX5WvoSHqC7f+fAC7tcsRxo00xXXkVz7shwgECFgfJUvtcUJmrnGonMgEYVSANuugQJBuJLSbMJCWKARaQKI2ZZmdAcYiPiNndDafhgYf4qDxJz2Yflq8Lpk3jBozbkZqSuAytaZsp/CsnlUIXZE0JtmKvCVt7Vac1kGcZnCjZImUzD931FbZZp2LyPzfFVtZKTER/6o1fiSpeXqHMUtc8QxedTaueqFDEXpHlyQmkBeNZTO+xTkwhQ5IrAA2gEODVf7XFD436d2xgJ9gRE
 Vft8XWEm
 68c2No+yssmeNqYLV2q1UMrVR+mY5J7H5iqg6j4VADyWGu47wD456AY7QQRosKLb89B3ChLN5N3PHQfqdC1tQx2JG9l9kQADqkoL8Z1sRyf7oGn1qrUsKktf4zINHwUx8xvfFTYGJ5LYZMiD8HCxdaFBczPH8GqgGOvOPWtOrqKhCxRvd5Xmx86AQe7UkvZnSU24B/LBOgHKq5CIseu0SUO9lObmwn4AAsEO7J+QTSNcmoVwFlkG3huOiwvBx2wYkO7bvrAZelzesV9R3dZVjeK0McA==
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

