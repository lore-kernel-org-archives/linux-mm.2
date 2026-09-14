Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75E40C88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17F386B00AA; Mon, 14 Sep 2026 10:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1570A6B00AB; Mon, 14 Sep 2026 10:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0944D6B00AD; Mon, 14 Sep 2026 10:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D14A06B00AA
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:23:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 704131A010F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:23:40 +0000 (UTC)
X-FDA: 85212586200.16.7F95A4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id D056F1C0006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:23:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QfbPjnCU;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=as3OPkNFsYYWKFBQO9tZASdaFQXU9TrMOPenfE/ek3g=;
	b=Ow5rcY0hgnJ4g6OZy4ObIyKUMgFz0RTw0f0wn6MoREiiAsc2Q3HP5sMYprMxZorIZrrPGs
	wt4CWx8RIfsvhnZXShdYjfgauSw2mB2AQeguIWV+wznexhtJuEQOEhmWLNezgLvyOTRSM3
	RKNjuXm8QJEEcfqoTJ9Ce4d0ZuhY2Rc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QfbPjnCU;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395818;
	b=wbus7bQZZv+SD3OBRKGIahmVyze+Mf34OHJqqGSU0Mrnzw9P8NOUHC2Z7wg8Bv5xe+MxVI
	EJQxDz61uO/kbU4kP5wgQD+zzZOUFIHl46jj4erIe+qAS5WgsuWmPIKlNmB+FZrhaush+t
	MucU6s9h3hM6yS8k9XUx0pC3PiSBbDI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FFDC601EF;
	Mon, 14 Sep 2026 14:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D851F00898;
	Mon, 14 Sep 2026 14:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395818;
	bh=as3OPkNFsYYWKFBQO9tZASdaFQXU9TrMOPenfE/ek3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QfbPjnCU+7FZv9NkV7ueIUM52aqYwMTjeAfgvF58Ws5kEex/XIBHYQog+p4kXhpZo
	 Jr8AVptoounx//8OBjL4AvZZ8QKunrk1w2OQ3E/hpRr2Yu1aGHKCXyQD9+OiARcccp
	 Fre97vt4S3P4ZH1aAnTqXJw+EFHK64DKtbwa8uC4szNMv36ls5U0u/e9Y01flpGLXQ
	 Vwm0tQHVRlGbybAGU85NbUGCVmuBfJ3dmdytN1UYurJZQ2Zl1hhfctEvcTmFWdVuFU
	 E7/IYXrHiX7a3qNFWpwNa6ysYEJilXwJMMOEYZkzh77c8LVOPXx3mk3mWOr6BeUbfm
	 WbSDnmwPpcx8g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 8/8] mm/damon/core-kunit: test invalid damos filter commits
Date: Mon, 14 Sep 2026 07:23:25 -0700
Message-ID: <20260914142327.92510-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914142327.92510-1-sj@kernel.org>
References: <20260914142327.92510-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5nfkcx6pdqhpcjoksgpt4hdk9qynk9rc
X-Rspamd-Queue-Id: D056F1C0006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789395818-444720
X-HE-Meta: U2FsdGVkX19BhjctOK7fzo0zdTUSofvPO/MmkvXWD0j9fG6GcPYbyvcHj2qc9D4GbzXY6WsAMAGtMcsyHHNA8hSgp0d0RovU3CopXHkpgnknu5VT0BSpqnpNG7B/rDM2dX/fxhcBROMhhtU3tjT7Or+dGiWsmCdxjdOUDzBa+b/UT/zQd094eh7zNUXaeuTDzaAvGtLzjooQsewnBL52Cxgq7MlIF4peiPOfG1lNcv3Sowte5hykRm49v8Ft4L6iBHuNBzcxEhiX8bYudXyIsmO8brN8muBc+pVKPlsR2zVBPVRbcfPefG05OQvkLrmTUqCGZpUCBK5ovIzIsyrp/x7nVIGBWYdZpAZxBVCplhqsPZvJcptne13FTQAe7CwSWEtwg3Mcn9ldqS2berWFBB/CTcYncCCkppcoQ4dq/t1OJWbXeP5hh3TAPimWEvdXKfFXfbkcjP+v0+cTskG1DNOIyAVgLnEVToJZMrZ1QU/JmL/hva6EYITghjufZe7FY57zxAzrFzwwulYAy93PTGAoc91Z4ZwRIjKGbqPmFvvZWpicmt5loLHPLebWlT48e8wQTIdpWb6gkcel8N81X33ATpJlzN5BSVMn8sbnVFyrqtv2se38VC+AUsiHzkH2htz+rH8IrCy6rqlZjN4Sah6viRYFY77JvL2tuXbOaKzqQ287e1G8Kh6R3ToE8LqWwpnycCe4Nhzw2MGWDS+F8d3JG2rfqU4IhqMmMJ+fgoEee/lO03dyp1gm+LaQl8Qb1rxP0W+BuYYwbXXhtGB47T/H+W9UX1kCqxho0UCaR4JMHWz4GiMeay/plt0V1KgLf1WecJokJIRlDlI7hkNasm7ggxYLBQ4nhHVT0vW6AyVWOmq2gbUmvjii0PhcE8WHlt62zfxaxa6AsKL0FaNVZo+Aw1Mfz22OMqy7uRyj2OKckOnhXBoh2nsNa/Q0nuDl4MeHLVwcLURWSy89Ssf
 uI11vjtC
 ROgtOp3wN2HIf+sC2wMVoiwGmDYQuC/hmaT3CayhQscEZpddMJNzbQZ5TyyPstT0NxLrMfp7LEm7i7ZqouKn12Y1LN4FIRcBAw2xtu8nnrwEr2Qi4DJqRrSDzhGI9qQtAj7aYyZXrFStLOWMEja+NmqhjRa8Ptd+t/hWXZQbzijRTkDnyOyvxyAyaaQHFUIVE4Tc3UvqMN04AK/Ic9Z287Td7IN0NqClC3tFnE2KlEzYr2sk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add test cases for testing the validation of damos filter arguments in
commit time.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index c9941f3bfb42b..5da84caf4124d 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1195,6 +1195,13 @@ static void damos_test_commit_filter(struct kunit *test)
 			.allow = false,
 			.sz_range = {.min = 234, .max = 345},
 			}, false);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_HUGEPAGE_SIZE,
+			.matching = false,
+			.allow = false,
+			.sz_range = {.min = 456, .max = 123},
+			}, true);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_UNMAPPED,
@@ -1208,6 +1215,13 @@ static void damos_test_commit_filter(struct kunit *test)
 			.allow = false,
 			.addr_range = {.start = 456, .end = 567},
 			}, false);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_ADDR,
+			.matching = false,
+			.allow = false,
+			.addr_range = {.start = 567, .end = 456},
+			}, true);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_TARGET,
-- 
2.47.3

