Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3391ACCFA02
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CFD28E0002; Sat,  1 Nov 2025 14:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 780428E0005; Sat,  1 Nov 2025 14:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695E18E0002; Sat,  1 Nov 2025 14:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 556A58E0006
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0036D88E7C
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:38 +0000 (UTC)
X-FDA: 84062853756.08.A9E14CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 70BD840009
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p+gwKDO0;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PZtEoBBhGJ9sDDZAIVqwS9v/HAJlIS2ng3NQHb19cU=;
	b=sXemO7W8i9Crj4CyZkB2u+NGVDjEQnNRhBjuU4dpyIt48mMVMAbT3nFrKDq7vUITJ0C5Sq
	RYOOrBU7x+h0/LCuknLT2hR4EtuUKNP3ciNRyHhwCs4nQ8Z9avg7tJOnqmPN/I2gM7BzZe
	fYmLjzGZqBC/FzVoe4I5Ca0jfSXrrkY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021237; a=rsa-sha256;
	cv=none;
	b=V7H69OFhd7ka8g4j8Tlgwrhs4kPVgtaAEx/bK+MkapCOf9xg3JQxzov9Bnfyrl43s7gOV0
	c3hVmfLXyLcECV1HHcQd6bUMCI92VMbZWJIvk78gr+i0tjfQTrMomiWVJ/FfPjJ+2Bn1nm
	QHgdzFS0s7NKUqxN1mkhlT93VSA2sdA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p+gwKDO0;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C59A5601EF;
	Sat,  1 Nov 2025 18:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D3DC113D0;
	Sat,  1 Nov 2025 18:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021236;
	bh=LcoET9NixI9B2TvJ7D7SHN7zAnAoJR3IY93L52/J7TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+gwKDO0ijHRuQy1R1itqxNm+fWJPJkcg/5tdoBhu/LO8YyfDY0i2qgW+/hhIxj69
	 9Rg3qKTNE4us2cqc+1a+DFYugOQhB7N2SRM7IdhqFTRs34R3g6qdn5WsG1g6xVImok
	 5iurUisrwIKPqPY65gaPTpPIasKBBnU+zO6jCcSZkDaG1bya6LYwX4QggkeFXYKNex
	 aAgedJwYp5rbPFRxmt5Gg4UjK8i5ESF+JfDxIXKN+QV4LBfCUas5uxQqNsaImzNx4L
	 LS7sW0uQ7/68s33NPWGKPlQl1IpS8C3pp2nuSJHEZ96inJdk45k4hbR5iZp5sQigHx
	 fkluiQe984sww==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/22] mm/damon/tests/core-kunit: fix memory leak in damon_test_set_filters_default_reject()
Date: Sat,  1 Nov 2025 11:19:55 -0700
Message-ID: <20251101182021.74868-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: kb38fsx7ird7rotjbo3su6ncggebehz3
X-Rspam-User: 
X-Rspamd-Queue-Id: 70BD840009
X-HE-Tag: 1762021237-620373
X-HE-Meta: U2FsdGVkX18vW8pTlqrJOQsRomHCY4gzl7nuRJR9e7oGtqpctssisIZktPSUc2bpN1zmoOIVJ0X2b4zPjkHCNJY9Vp9fLxVpYygQvOy4soEuNbihR3sI/3NeaygnTqXSluAfatxF6cSLGHsuXSsjvqhAQCeXGCBOoNK5G6DQGE5tFGLTJoeqt9oEzlfHc8YN0R6FCFvJTPecU1fLuCdwS50hDeCKzqNMUpI9ajEnNRvZqQxXenT0GspD6BdA0A38or+MUFwex883kaq/Y22YxgMcHRfKRT9n89iWykNqZvmn0HUP+qKi/rX1QM5+9Iol+IlECam4A4yZzOlYmczCbB2KWnrb7s3uO0sAIfH7KKE3WdG08pAlUW8C8kmnhgc0jnur/eajqMQLUSp70Vq2+Y6mtGAfvM7+5GHwMW6nvX3WFgWrh7IBJnckCrW1N2dh+h+KxE4lTxfeYOy3tlYlBDytAaURHbibnURwzL03Y8Yd6u1Q+ATFA+k9xloEqkqwG2QvH0qXrejEl2G4dK9uuLI3HkG/eJgI3ewheauZ2x6+3vc97k8LJg9IBQnld00v/zKIjKb7bBLNau0VWU7G4pUAGmBUCzXeA5XhDysOwiUj9ZkTlinK8a2sGCweHWh/RM5hL9HpstosvMnuM+XmKytlwX1olJ4Bg8pJx5sbwnxiNp+Ieh0b5jS9rq0yuxW3+nRP+r55jV0XON8PIY691ifo/l06aHSxfdGyY6Rmi8nPXyCZ/OOYzRgb9ILOsH3eh9UJhOb/+irXJIdcRtmCd1cjRglYlsLfGJfm1BZfM9n5N1h63xRUHFiSNades44PTvH3lSdywgIWnUNm9GRTp77C2/rS3jrr8qtYSsWCj6rBughJ03haBT1yqAL4qjDnjiK11ry5aIS6FVDMQjTZX0c5mmk/d7MkWDOsbkGcd644MNkV+OFCHJhPXOAm1++qd0Ymx66k2eBc6sKhpyv
 AGTS3pGs
 F93Aal3z90JyHzHlgNw9Lhm4AZLNdbb+sfd/OpD2hPB9WcInHvT9TZkNoSUGqEz/kcI7CHyKch79x06CEVgEgjLrvFKv9dTU/1HcgCXjMSEayT2T6ilRR2l4T0fK85/hEb5P6MsDm3BK+ZaydUii4oXaYn3KK3/fYcbNtSL6j+v3PyiQsWz/OiYyo2hPkKyCTj89HBhD+0yDinfNXACUmdcjBJVCk/tOzp50jvrJWgJ8Z/Jzk4vk81QHD9n3x4xTu0EiJyRJVe65F8NCLiYpB4dmSAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kunit test function for damos_set_filters_default_reject() allocates two
'struct damos_filter' objects and not deallocates those, so that the
memory for the two objects are leaked for every time the test runs.  Fix
this by deallocating those objects at the end of the test code.

Fixes: 094fb14913c7 ("mm/damon/tests/core-kunit: add a test for damos_set_filters_default_reject()")
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 51369e35298b..69ca44f9270b 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -598,6 +598,9 @@ static void damon_test_set_filters_default_reject(struct kunit *test)
 	 */
 	KUNIT_EXPECT_EQ(test, scheme.core_filters_default_reject, false);
 	KUNIT_EXPECT_EQ(test, scheme.ops_filters_default_reject, true);
+
+	damos_free_filter(anon_filter);
+	damos_free_filter(target_filter);
 }
 
 static struct kunit_case damon_test_cases[] = {
-- 
2.47.3

