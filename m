Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05D1CFCB619
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C56B36B0099; Fri,  6 Mar 2026 10:29:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF3976B009D; Fri,  6 Mar 2026 10:29:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76AF6B009F; Fri,  6 Mar 2026 10:29:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE986B0099
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:29:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5AC0E1B818E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:28 +0000 (UTC)
X-FDA: 84516022416.18.550513D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id AA467C0002
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KuC3k1qZ;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772810966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rfsiGmhc01BRcFOe+jthn4zrRso6eCF1denja9H0Zg=;
	b=FopGQfIQeTfe1hw6leIbxtrU7EL2ZcQdZkf1mbC+0N2p6vP6sntts+OG31R3qDTALZxVHO
	HcEKskmGyAh/biZVBEbu+/srETh57oRGjvLI2+BqitIZFZZVq7Sj4+6/+8OtTc7o2Pu1Qh
	wiIKGboImJ/kP2wZrF7RF4djZ7+4kag=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772810966; a=rsa-sha256;
	cv=none;
	b=vZPZllg0ZzBJ5A7+8OaKqV1ji06N0tUl7Gin1/M53obRvOuZU3/WbZCYttvTIz8sjoFwOB
	l7D5+p7nJ6kjEf1oTK396ABnb4A0Uc8Wr71zPKref4ZNbyEf0HuR+B4wl28n3U+PMOvOPN
	EFSz28ierNWTK/qLT1aY0jgAkZwwyxw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KuC3k1qZ;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30B3644569;
	Fri,  6 Mar 2026 15:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2390C2BCB0;
	Fri,  6 Mar 2026 15:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772810964;
	bh=BLMf6S2CwC1uRw1Za6T26Ewe+0K+xw3rETEPypk9tzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KuC3k1qZgIOPJDD/X46auDKxq3ATjy5gZTmx/CxXFUu3O5B3/YOsoc8RKQTwt/1KX
	 XCxHakNdUY4Q9ufSqNGgUPpWujZkUh74rJ2iEKSwAf6zlqOjSj3aAWcRW+MH+ySKB/
	 hbEG4TUYrrv7xJvJv/jeLTu8wfGeZ0arlCP6nq3xXIF/KitdCAm9KaMEoG52rqwCHf
	 PA64Uv67H13ctUxnBWLTBVGXzGBEJ+p4mH49ubp4CSqNxUW56sWvRQaK+doykJKIHR
	 rePX/kzL7vgS3HM/Eb5PxMe+jdzgqyZHDo4xYwDx/XDxMzKdExacChFuCYa75OIwJ+
	 WLEwl5QXsnuBw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/10] mm/damon/tests/.kunitconifg: enable DAMON_DEBUG_SANITY
Date: Fri,  6 Mar 2026 07:29:12 -0800
Message-ID: <20260306152914.86303-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260306152914.86303-1-sj@kernel.org>
References: <20260306152914.86303-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mg7oyue13x6stehgsfnzgkhpn3hpwfz7
X-Rspamd-Queue-Id: AA467C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1772810966-134174
X-HE-Meta: U2FsdGVkX19tvdQ4SUbShf7vDKktrL/D6YsKbr1Ry+i/LzHQIEXoaOydpdtwveG+qaZBNHEpPBRuBUle6RTIp5mq72qJGCi6V5UkXU2F6Mbv5AfDqae8Qd5kjtb/3UW4r4MIKP/lAzVBHXYVF3agYdZ0GnjqihKOuwr6IDg9RUUT6A66jLtS3cHZ+whTUxTp39/Lx1RXe+RXAi1zHn/BAsvXZS0mmewUlwkCwFfZN/JS+4TcRSAHG084KaQ4jNgbDqIEEduU+azXh4rf9UR0qSFaLG+cF1/CdSTli+yvctArzsoC02KAAI9MbvOxsbBnn/pscnoodI8k7jUQygFU3vDgdvXMOyA34FUousTDvJyj7SC4ufG/RCCNgAEIQR9sV3qRSzA34gbuP+UJkF4vaHwOGrG2YIJ3sCEpUXEAdTiFJwL0GYV/l5hqQjbPPwvxT3+OqSDs9FgY545345i7rQ4QHL7ZknCiN9R0OktAderhiLoaEIwFkMGr8+zP9247/tYW9Eggka3etKMIdiHk78SK1rzZbUxVy6Cr7V25W3QnTkqxYwhBdgUhuMOuEIVhPDsuw/BbmXHbgciwLt+7mchr8UDjXeYY4VHnPH//fzIlVmkW8R5Nor6kPybJR6rOrtSb/Zlm72pDONS2Sctj8cDacewjt4Z2A9KrWaXrvSvPKpZOnDCEi8vcazyhEEk/XqGKQek4auBv7TnlykVkkTmO/EsySVm4XakSJkcRK8GC848L2IK8SgaoSEpwMCmwzSDl7mOe14UkEDxzuBKy5fKojASR7sUwFypOQlMPB//hvEEguyF7DydIvyg8ammgVfeREDNrMinQopcbHyh2epSjXhZdWt17U8jImUtJzBrf8gZ6MCiIR/Q9Tvz8ARTSv79Q3RcnKKGqHY2tbrWqgeGX6/kI6cLkIB/4OeeXeiVtj/6caKWBLwPr9ynwCb9FM//cPYM8eslNES2e55F
 9Udlabw+
 PBeKQqKrJwUSMjJRnhXrElHAToI4gd31klkgFFhbbiQw9U80zki5XJnwQqgqfN0ynhVg77iIkF4WTTMpjR84n3jhRfywKtTW8srtGbyQikCI5ssQ5CMajSX1vuxhxh3ueW50OaBE1f2b5xh1f2asx5RixEwosktc4XZHP4oxdWLzcA+7ijIkukgRemNZMJ3xQZy1mnzWZn7owv5Iu8vaGrEf4vuKf6RV8vAHD5FmZM0KbNlJyoxI4865YEe8Cf+cyjtn7s0r+y7xqO2z6N881fuZWSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CONFIG_DAMON_DEBUG_SANITY is recommended for DAMON development and test
setups.  Enable it on the default configurations for DAMON kunit test
run.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/.kunitconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/tests/.kunitconfig b/mm/damon/tests/.kunitconfig
index 36a450f57b581..144d27e6ecc5c 100644
--- a/mm/damon/tests/.kunitconfig
+++ b/mm/damon/tests/.kunitconfig
@@ -13,3 +13,6 @@ CONFIG_DAMON_VADDR_KUNIT_TEST=y
 CONFIG_SYSFS=y
 CONFIG_DAMON_SYSFS=y
 CONFIG_DAMON_SYSFS_KUNIT_TEST=y
+
+# enable DAMON_DEBUG_SANITY to catch any bug
+CONFIG_DAMON_DEBUG_SANITY=y
-- 
2.47.3

