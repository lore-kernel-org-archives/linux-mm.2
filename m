Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF80FCD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA8E96B00A6; Tue, 16 Jun 2026 17:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59BA6B00CE; Tue, 16 Jun 2026 17:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 997506B00DD; Tue, 16 Jun 2026 17:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 731C16B00A6
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:07:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50BCD161A74
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:04 +0000 (UTC)
X-FDA: 84886108608.21.1B795EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id ACBD520014
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPkfFt4K;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781622542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iKJW527X2a4DyTxX/3xqnHNqlZ5qhWrmVwqPolgxgiQ=;
	b=QfDBo8g8WqXL93JMmDKUct/XUG8CWS3jP99AeUjLw8gFcUZ9z6PEf9ttdi2DydWV2jjqeb
	42B7KNeQeYl1fdE8YDjb++jmTcUiEE6W5t37Z4e3RX0hr94a+jMSZ8cyQYSeFnOpRhGlu7
	otSS3GKzJY9hhMnDM7l+574OrjXmqwU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPkfFt4K;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781622542;
	b=zxyhVbnsv4MBMx9yCQ3vBBfG8rcTEh/h10Csbru7gJfYj2dwcXHOcoYa8hMA+znLJx1bN3
	vtNisJdETUcOreAiOPxQ9JvLwknWVadHuU9LdX+FH3Vamjbs8AFHTqX5PwDYiTHsa5sDeb
	fgcQ/30kZKpXG0fFrYONwCh2B5TzOJk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 070684011A;
	Tue, 16 Jun 2026 15:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAD51F00A3D;
	Tue, 16 Jun 2026 15:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781622541;
	bh=iKJW527X2a4DyTxX/3xqnHNqlZ5qhWrmVwqPolgxgiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OPkfFt4KgmzgN4DhuMQCVJn5o7UhWA9RfTeQqzO99cG3zORFg54DXQsFptf6d3gAd
	 JX/tXvvmsSI42Yk5UiWjM2bfzN7kneCYXt2s29WQhXv+sQLvZHlO2YQ1yqUifQZKJ1
	 rAcgOwT42JNSdacCUKE/9zmMLIvTUHjDLw3MdP8msrnSZObqfETfhWfvWXRDi8W3Ff
	 MMFJIhbDs8X55QdPbfZBhVcbOcHowNYHBVIQ6SAMa0pTXcaSDFX3MQ5kAqdCCsm6FP
	 D/WO+G3QBG/imlxXTMP5FqVqO8CespQrCVJg6ryEOUfwSHDOsgY4Xiap6cOPLUN1IV
	 KJR9311dEvrGA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 2 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/9] mm/damon/sysfs-schemes: kobject_del() scheme region dirs
Date: Tue, 16 Jun 2026 08:08:38 -0700
Message-ID: <20260616150844.88305-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260616150844.88305-1-sj@kernel.org>
References: <20260616150844.88305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ACBD520014
X-Stat-Signature: bkb8axo4ou3wxzn1z6bbwfc36c1i6t8t
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781622542-791344
X-HE-Meta: U2FsdGVkX1/Tv2OvFvpufgjPyxhpj9K9e6YaABW7iVSCJlL62Z9o98mCYS70ZujgemXtWSyMUuLnMANGcj4BexmsDDkS38eue1tuukPhL+Xc/agTv79rUniFOWr8zb4dV43OmASZ+odedPVhu3g3UL5O8DxQ4I938x0DKZNCcOsva1uN4CrgEbgCAI/8Q+4Hh4bEM8WrMS+oeJ6h1gMMrlYo21Iuc4myuNyoexPBaxC6xNwbchPz8KAwAPVAL5f6FtFZrV3rCYm/nQp5KStqw+rOOg56iU6WAcQ2lKRFwWyzNnffch9b2u+x01nkl9t96ZS9jKeCnbnmupcTVJTpCwjbxRpuU9z9QNDr2VStQAx1RJYD1kNTTxvqppOB/7Uw2I8XQsTV/LAL7fFDxzhnfsUgcS0i4/6DH79x3qhrAuSOQE/Ci1jgX86vTFr3BgWNLe9D1CgPRpSwF69p5tcxxx1VN1tZVpBD8cJtEMvJzZRDCmZukACnJnULCUx7Usk28ZRbp9nWwAc08XveD5/mjAXXhTwd5fR7pSe+lf9LWAXvlT9OhSVYK306n1/In2wpoximjt8vZ6gEZjvatXheyZq26Lf93zAIQZqc+6+yccmc5lrLsala1Mpmo0xYYnqaq17ocewElGyvDrWRQB4q8S40+fb08qZE3gULoLvk80fFauWXwf6vf7/iwZBQIYt+mZUbz+Qn+KjaRlm/ECxhEsDzmva4cxNDMW7IFs7Vli6Po4XJhVqhrj2H0QM8EB7yHuTNyylPbVsVHrM9AQ+GeCtqywCKhUX7sYP5fYnjGzeV1F8mBTvj6YB5WqmZs7EfrZMZ3NsVKt2jIGIicohbsP+eN+W3qezpEibN78ma91lXrIwkLPdGy+TNfjNsDiO922U0XG/gbnP0OcDRQEvgcmkIclIigCQhF8bGB5qWGooPsJm4Gk81mxNfTdKB+RUKuG4VHljnb0Ahixsu5tZ
 vL69L7ij
 J7oCu6A10lzQhg6dDFebVzJz5Ly/gvOvnmEHkS2dnO8b036jAeoY7kIjPRSvM10Fh/P86kAGEGlrQGX/XEhUBbQ/ku6q7cmUCRVYCGg8TZNtLGXCyHPw9D7FOH0RAM8mjNEndt7zuyRHiqbf+TqC4uCn+13dd1yc1QT3hJjS2ea20U0sBXR+n5YCZDOw1iQiMv93juRo5o554RTNN0k00f2QKBF2UNB3jNB6bKcmQhkgJ09cUdtpVgI3FUJ5LwnsG9DdsnYxA45q9/ZgsSBhNKcpnEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme region directories by adding kobject_del()
calls.

This issue was discovered [1] by Sashiko, though its analysis was
partially incorrect.

[1] https://lore.kernel.org/20260517205828.6204-1-sj@kernel.org

Fixes: 9277d0367ba1 ("mm/damon/sysfs-schemes: implement scheme region directory")
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 37cf6edb54f17..bf08e6e1f1635 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -334,6 +334,7 @@ static void damon_sysfs_scheme_regions_rm_dirs(
 	list_for_each_entry_safe(r, next, &regions->regions_list, list) {
 		damos_sysfs_region_rm_dirs(r);
 		list_del(&r->list);
+		kobject_del(&r->kobj);
 		kobject_put(&r->kobj);
 		regions->nr_regions--;
 	}
-- 
2.47.3

