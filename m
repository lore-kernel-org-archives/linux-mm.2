Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59448109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8DBE6B0114; Sat, 21 Mar 2026 14:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E516B0119; Sat, 21 Mar 2026 14:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B235A6B0116; Sat, 21 Mar 2026 14:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 873D56B0117
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:13:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5AFDF1A057E
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:58 +0000 (UTC)
X-FDA: 84570868956.20.FB22B4A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id B1BC31C0004
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dT8d3GyB;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7zkmJLFhrZtgZb5xv0tfELwAXDyT6rXUNKl5w+JrAw=;
	b=cyikGCML9dxsSWWiVIerWNdbCZ3yeyL950AJr4yQwm0DFPl6BYM+chHthETBITy16t6Hm8
	cPGld6YnaywzQeIQwG3o1iU3Uut0uf8U1CFaWQWIMhA42/tG3YW4fukJAtipGSy+eLsC7y
	I9MIXznB6xbbJphjw9/4L+kXGaAtEJk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dT8d3GyB;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116836; a=rsa-sha256;
	cv=none;
	b=HUtYDV/YFnckH/oLv5vpeKPapMC+qh0QAFQ16zFZJqLN3zi64lSpcPXrfNXEhqVi8iGN6j
	CLaXt+rGIHc2d3H6Ui7rph8ns8IRg9dOnysjv90jRHNUd+OWbF1Lo+KqkcYxmXY5qbR3tB
	OHIXPa61nksFdIdshWQvQ/20j5ggETs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 381AB44706;
	Sat, 21 Mar 2026 18:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27ACC19421;
	Sat, 21 Mar 2026 18:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774116835;
	bh=9O26QoN+V9tNeSexEgjKx5Rwm+ySmwIIy3Pdsz7ovf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dT8d3GyB6zVZkEyl72/a+qTGJXfgfCsJ9j16RcnhPKe/l0LMckmgt3mfnxQXxc+Rc
	 kKaUABp3Gr66ZXxL6g3/l/RA/8Vr0gNkOVXBZsLY2kPMiRTwCLdujJk17JHfWEnnFA
	 HeuUHtqKpvqiouN+7utYbwby20NbUcR9QMICVuSByCvG8+evIQhRfdXcCJ6C8ZYjgC
	 MU3JTo3mozQarP1bCTMdRuWiWPfj4FzCEpdda3dEzKeMOVI93BSApy++T51sahwq8H
	 6HaYMkAcoWpG1qhvxuoohx+HHko8iWEJmeuwpsw9/TPcfwo+FLOuQKLru9GeN1SXzR
	 Zacd51aK8ZiaQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/10] selftests/damon/drgn_dump_damon_status: dump pause
Date: Sat, 21 Mar 2026 11:13:38 -0700
Message-ID: <20260321181343.93971-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321181343.93971-1-sj@kernel.org>
References: <20260321181343.93971-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jimjqcroe9oqdk4nj9epecczzrzr58w1
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: B1BC31C0004
X-HE-Tag: 1774116836-248481
X-HE-Meta: U2FsdGVkX19yTolphME/Q05PgO/Ay8kYko3RwgAwHvUqtzb9A7ZUKR0qiiyDqDUnnQgAz9VUAw2l4EYDWhIcOSS7du0DVkRm+c/cVn1/73YKiz3IaZYq0EQOsWXptOrcFmESnLga72UB3mvDHBRff0Hkmcn12Z/tAk6WSg09dAvk1NQS14Y8/myLbRXZBbLG/asd5C0UXB6lyNjaK+rSFGeszw0IOF/7D2qQSzMR6Sit6pUnMz48WczohzMiRKnAjwhvLSKCkdqNn4GCcA3jRxkSGz7nkZqZ8PZgYQ9UUGbP6djgEX1FLMDFTuzHTCkXW1msarOY2LhT4f5nNZ9P1eO2NFKLSjl0n1gXzFBOHbko9vhd9MifCKK3/9DtiQrxV3aZJ3zAm8DlKYhTh/dB052OuqrNHl4cx9HfZZBXpdid7C8FvJmOeBt4wI9EFuhF4ke/zD5LHWWwCVAJE7hu01mSVZvlf0uI49lnRJNdTF4XNA1h6xi1zA6J6a6r8J99glMWxuSUefVTby4CRx26oSXOnqzlnISdwxhX8zc5yka7JrtnWrnX0KCRmlFbQEEHK/ShFVOQA0gunaCta/H70yu99ZhKLNt2RPlzPWq1sLlpPBpmYepBriTWV5iGDxOP+xdJXwTAJlo0A9SBzB20L61gZC84AJoKjrB3Ib6cy3F0iX6CRwkv1PSZxq/LdopOpqcPWtie688V/QsU4LpZ/g1+gF2t06CPc8vcTtN98j+uBPR0wKBhtT8uLzaktgI0hFi5ldMIRnDUrxGmRniIZwgbWBoa1lXDCWy81hukJ2OMU3DRGkf0ITNdfVr2u6YAoFYWti9NDIaFFlD5ZZi2FNKlHmXfj1VJacnkmBDMHcgmfIwF6Pj5kxVJKUBIy/S7hJy6b8qUCK/X/gFAH5SDmrlW72J91b46tAMEo4h/j9njwuo27hIYFAI0kVTEm2F9LLImPKA2CDa91jvJIE0
 egrqnwVK
 u4ZJkdc1wP6qARP0ywazFfAmhCGfP+0/r4X2hmJSbCN5rUFBkzS/57Sy/jOPrZBBF9vn7WKgHRhX+8AOtpblqahjuU9GDx57R3h3BjU0AVD8Y428Kw4O6tWJrKnYNQKpojT3j/LJKmXNarbGxYVr1dH1CxJRHS6Z1Xel0VbStfGSUIB9/H2j/yxjsmb8OzYCl+NVcy16SZyXqq7N3SgtDFqhirskkcT445vcUFVcvqTj3nDydzSs8oMQABp35XoXD+RM3jt+FD6AwYczh3UNW6wuENA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drgn_dump_damon_status is not dumping the damon_ctx->pause parameter
value, so it cannot be tested.  Dump it for future tests.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/drgn_dump_damon_status.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index af99b07a4f565..5b90eb8e7ef88 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -200,6 +200,7 @@ def damon_ctx_to_dict(ctx):
         ['attrs', attrs_to_dict],
         ['adaptive_targets', targets_to_list],
         ['schemes', schemes_to_list],
+        ['pause', bool],
         ])
 
 def main():
-- 
2.47.3

