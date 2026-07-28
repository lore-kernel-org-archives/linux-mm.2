Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80189C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A4266B009B; Tue, 28 Jul 2026 01:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 106686B009E; Tue, 28 Jul 2026 01:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE8706B009D; Tue, 28 Jul 2026 01:28:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC39D6B0099
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:28:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3EFE91C0433
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:20 +0000 (UTC)
X-FDA: 85037054760.22.5EC3833
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A3D82180008
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FRUjvaI8;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785216498;
	b=ceH3PNrKlpZarJ0CIXTLdQQkzyppM8lL4fo3EUo3vINet8hWqAy0d3MYg1zd6LZcUPsRTJ
	ZZZFw+Mf9ApZjrYzYAWRASaZcccIXAesBycD+5G8Xr6bqzRld00mI8W32mdsYx1LPDKfqk
	Y+qUwx4kdBM7+XsbxHN72M/6UgEc7js=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FRUjvaI8;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785216498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOFGYop7G5CT0IvbShe/iVSTs0keWEcjAd/ooP0VIE4=;
	b=yqw3ly8KTB02CkJBusPXBDM9DHP0/NBCL6CqKAhzbCNaQf0IBnZh+Sf3kMtlJPbeeuGRz2
	/TfvylWvKp9dHEAzhe2hiXlf/UStktpfejRtr88gmSvmIpQ9CmDAVOVfwwcWYOT4r0xeDP
	3HN6vw9clYTCpHT+SA0MnQVLRUc7vwE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC02E4326B;
	Tue, 28 Jul 2026 05:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCA61F00ADB;
	Tue, 28 Jul 2026 05:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785216497;
	bh=SOFGYop7G5CT0IvbShe/iVSTs0keWEcjAd/ooP0VIE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FRUjvaI8UZK0DqChqTkQHSOQHLIsAkK1WBKhqUbCViUNDznXWW13+m+Wv0t2Zfar4
	 2tgCS+aASXEOfu2mTKuWp8nRGw+pCEYCatqsLeiAHftk13ktR79nyz9u/96cj0fpGa
	 hncLVZZ41bENBYxUDK+/UjZ2i7c0dWJRg8M5tlzgzMMelPqiKwFXXN8NhqFk94JuBL
	 tWp9yS895Ckly9pVOinHuvasKapBoQHoxsWKexSoRmrWVChD0WMKjgfOX2BtCY3v6H
	 D3UYt0v71VcY3LzAGANEF3XCcyOrRO15euSEUW6HOwDiGlfeW20qqgQPprS/ObT1Y/
	 Y/TKShU0ENTWA==
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
Subject: [RFC PATCH 05/10] mm/damon/tests/core-kunit: test <=0 size damon_set_regions() inputs
Date: Mon, 27 Jul 2026 22:28:04 -0700
Message-ID: <20260728052811.192712-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728052811.192712-1-sj@kernel.org>
References: <20260728052811.192712-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: egh8smq664mi5bup534pthacxmde9git
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A3D82180008
X-Rspam-User: 
X-HE-Tag: 1785216498-430270
X-HE-Meta: U2FsdGVkX1/Ak1CRLd5VyU53kFd7Mec8lzFdFTDksYSSTlSg1rcoDMkCykMSN7vER6tOdW/r2S1LBzvfC8vugQ/CX9gUjXjYPowpAUGslT3IHpuuXO6ateN605L1CcAJizUzANpKuD+i33rQhzrDJ3xYNKHjb3L3atJUhXUDWjmSuTtwdW+e6DDPTmNeKtNyZZLqxxwOsxEkcCwU+FAeIJ2zVZ8jT15T6Id52hAUu29xbwEFev3S4UJmGc2SLEKyrFsxJ8bZw59AyNUz3aNmqLDvVnJumciuO5s8ncxrF0utPIpQNjQI7KBUVgmorVxcgkj3mv9b8HXVlLOGO4ErJwudkPa7/YdXRZnd9ry3Heqg9a1iCUgvSE2kM6psEewfFNlQq4tUzHGSBFvzY1hEE4Ncm033dD3yOwAP3dYYw61fgRZWtMZFg7F1SRUgMZWG9fHkQzkc3dQoCW17mvqjs6C4nuBtkNAaAClLU0DT6HdPbso8cJ2YvZ/Uelax4gUUtkmV91DHq5IaAx4zreq05KLsPiDiz9gMHxiu3VWeX7jPqpR96/jZ8x9iFVwIStpm6HsNoG/gly9XkM6j+A93H4Q4oc2iHllk1Z5MkraxmwKWDzcbKn6+AkNT5i04dEB1IDnlbCGihOBmSb4DjTc080d3sxNODfmZ9byJqUYgMfM5XWHG6Y5ZeRNCWM+/J7mDGYFKAWBeTsmj0JEYsU5qUie8jjbBB4WIEQpu61SHB8jmT4hR+iyKDgR/NOi5T9uSsaYBrlqnVWenk5SiNlleURua2TWK18KgehCfIL+RCZBqfkrqHm6lTsGFG33YcmXtw3kba9c9vxs7NQBNJ+y+4as9veAkXVCATBzaPR6QJV505a4AJAZatByIZS7gb9+gmEkPuhwzQoFF+GcuaeoKDF5nPDJ/QfdIZIzXWyr2FN/kNJkshqKk5PdTy9mcy7QktLu8h5rJySLtbYne7qo
 y+ZCYDL+
 RsDI33AGQZLjdgmCz6ShENqwfJeZeSQ+VUl7/sZ1XN2vIOS6kI3400WeDPGb0nqEyEGWpbYt55IWOA2labmlt+cPUnLkowHnYab5wVKbc1OTepWlyuoH8+1xUiz0fvFCmln3b7iRDxqKamWcdyBgkGPaqDbVUpc9p8elB6tTDs5Nv8GYrtHm2JkoG4tszKyen9BeXIT1SucdNx/Ui1L6DR0FM+oz3KrFjLohzwhZGswP3NOlCj42SzXXrS2X9ZL3FGvFZzPt69FgEIUAqnBcQMtpe3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 1292c0ecb1ca ("mm/damon/core: validate ranges in
damon_set_regions()") disallowed passing zero or negative size input
ranges to damon_set_regions().  Add kunit test cases for those inputs.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index befc1196d6d60..ac15393a7935b 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -592,6 +592,20 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 25, .end = 40},
 			{.start = 44, .end = 50},
 			}, 3, 0);
+	/* Zero size regions should return -EINVAL. */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){}, 0,
+			(struct damon_addr_range[]){
+			{.start = 42, .end = 42},
+			}, 1, 1,
+			(struct damon_addr_range[]){}, 0, -EINVAL);
+	/* Negative size regions should return -EINVAL. */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){}, 0,
+			(struct damon_addr_range[]){
+			{.start = 42, .end = 21},
+			}, 1, 1,
+			(struct damon_addr_range[]){}, 0, -EINVAL);
 }
 
 static void damon_test_update_monitoring_result(struct kunit *test)
-- 
2.47.3

