Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2AC3C61DFD
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 19:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782FF6B0093; Sat, 21 Feb 2026 14:36:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72DD76B009E; Sat, 21 Feb 2026 14:36:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 675BA6B0093; Sat, 21 Feb 2026 14:36:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4820C6B0099
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 14:36:40 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DCB8D1C0D5
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:39 +0000 (UTC)
X-FDA: 84469470918.30.D087138
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4374680003
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C9t+9Jz2;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771702598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rfsiGmhc01BRcFOe+jthn4zrRso6eCF1denja9H0Zg=;
	b=WPj7efX0PTX1FuyC81sF9ySaGC+5Y4nPLfUIO5/op7PtE5jw3kTO1hLaKGHP45iONSJrsm
	kUGPsaNl/gaUBKjsHMXZ8qjy6PUrFAPo/lECOI4x0CXJUTlL8xwtWI9cTLaKxAD6/B1gLj
	CsrXuAzZ3IEhtuIwrrw8TOl6KdsVIvw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771702598; a=rsa-sha256;
	cv=none;
	b=yuXWGXvWQV8h3S8JMnjumrwTB8jj1hIP71L2C+StI6gdE5Aro/Q6v1OF0o/fcMz2+vDfVr
	WF5KJ1MF23SStBrSRT98u1o4euyfWVEhIRNGf5hdhhbAylcpOOBy/GJ+qfvdg+8jb0ONHo
	96N5P6Rnaz3H3LL1lLY49JTKV5gscoo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C9t+9Jz2;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A28E44539;
	Sat, 21 Feb 2026 19:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CC1C2BC86;
	Sat, 21 Feb 2026 19:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771702597;
	bh=BLMf6S2CwC1uRw1Za6T26Ewe+0K+xw3rETEPypk9tzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C9t+9Jz2hPriFjK93TVr0kL3267n6+R42N2n8VOHwQv5agnOpvqATVqVnAs6mYeJm
	 +jZ4j4ch1N3NYgkCQDXyClUwsO7Pc8NzeLulg0ok3FhJmvecX/JCvcbAl10foHRcuB
	 wLWPSfzEKGFv51WI3SPLtLH1z+U8nZX/2vPST3mDPKjOOAhNB/jBsZhuvJFz3q/4SW
	 q1fGqkjXmcnDd+yGMIWKed55s7RyH8fKJvHntiEQtHC3L3GrwQG4kQjKAoU5pwvi2a
	 c3diqLvXjRbg/Cvnp0m79+SFhrEe43XikHTdiz1L516/jdlbYWtmPA93R3Yn77Jg/Q
	 lCDWB2zdWQ64A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 09/10] mm/damon/tests/.kunitconifg: enable DAMON_DEBUG_SANITY
Date: Sat, 21 Feb 2026 11:36:26 -0800
Message-ID: <20260221193629.19332-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260221193629.19332-1-sj@kernel.org>
References: <20260221193629.19332-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: t5bw7g9nyuixfnen8rginmdtzahu4cyy
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4374680003
X-HE-Tag: 1771702598-673556
X-HE-Meta: U2FsdGVkX1/HuFeAswQlF9kFok7cWATj82j+I54WL9af8qt9Bxsu4w9gYla0mkqWUc7FOfibzjtWVUKAFDax+pfn68OPr6bf0zcl6FG8CBhv8lq7COtQlyK6/0SmJHSw0HMat6IJzOUZOqntL6GxSjld/NkEVa7LgeXlAgzYnYw+o7CCiwElm6WxrjQQg4VytaMcyYO0iMjGkA1YsuLmgvB+BnJwDQd8wZ4FmwUbJQdbo4Z95XmA+upZWhQq4U4fcsLnMMolWPBLG/XwkYbOSTomEflAchxS3ICNCy1g2PX2YI2zysqHICeyBcgLJwmdo5JW/Z4bJtWrFsIg6A/XAWNFbWNMegEjbgBrKGw1X180ywmDPVEHIzC5CJIqlKMbcBXJIw8KdmoFmlQRzkDHNSYQrcVFeZwn6cLnvYIA7wtldDNk3R+/RUJqeJG71iT+QRlN4SEelfr/NWZOTFNfSdkCcuLxyQsYpnhgWvRZFliUieatrpPl+GGO6VncRFnGOCxrX6Za1hxA4irVLKLdH3XocuZEJlo5wRFqXG++jSIQ0bLdA7V/zEy9YnmVxPs3jUNnWFnY65PAIPEKzQW6dOLZgrUxQmbvIeG49lNyZH7KlFAgznv3kPQR/fCAqTtJSmT0scVgtT1DAvqs1GOEs4EXYpTfdJAxqA+j2lmh6JNjzILaIgGAYix4bEZsAsweLqd/2KuvZ1StqSHStfXh+vVfEMV668MEvZmx2byaF3ZRU0IpcTNfHwbuuE5YkREXjr/QroJQeMZMDbiD+nILqTPIzhGV5O9aO7NQhpuuVeHkGpFaEGHvvkegxrRWGQRIPp8llhSq2qp8YJgsXy0eIMA3ivjhVupoXVfyy8+taa3W5iYEBSyz3TZ6PKBAUAt2FaND8UeNLR/h0HnO5WaTM9hcBO3S7B7tm1Oima9n2HI2kUg4y74RJAfonESxuZ7Ny9XJ8gEMab22CXyakEh
 QCG7507k
 fLkp/1CnZdISK2M7n1D6Aer+6ch3vrt1lNizURFCgXSH3qaeft2mijsYU4cmSCNZgxeFE3VRtR/U00E3UGeLdAtN5ondTLHb353V6DY8vQjyeFpodh3YvMQNxXOC6oNg0x1dpoeVAZmkpbjIn3byx1OFw4YC9T0MI79ptSjmh3hFRZM1reDXIG403GEJJTa4q0p7c4Hgm8s9cC56ciOWd8vt/QujLRZGfMSRmnvCqFbDbIVWMl30LX4BIjq458Xq1oLZMD4n8HNfKy0V/e2lVjXAaAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

