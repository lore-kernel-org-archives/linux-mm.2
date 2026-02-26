Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B89AFC5930
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BFCE6B00B5; Thu, 26 Feb 2026 06:34:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 849C96B00B7; Thu, 26 Feb 2026 06:34:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 776B06B00B8; Thu, 26 Feb 2026 06:34:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5E56B00B5
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:34:58 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 28B011D084
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:34:58 +0000 (UTC)
X-FDA: 84486401076.21.553F5A4
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5FA31140009
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:34:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QzYEVMog;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8OsjUNu05V/Xcz8HI7pnG5Up/ePNSaNnSj1ALtPKgps=;
	b=nD9GVDY0lRcbKSSQfxwGkyypjuwwTLF7JxxC/Aut2Z/8ksb976t7MI77c90dQL7krmL9+/
	CS1jAcia1xImyI7KiHUiKqGpvSPfmehmtMJcJDbRymLDYeKPURIB863kNcFSW9WMrTDRdH
	XaSGPD6AaUArfjN0japtPKK2dKh8V5U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QzYEVMog;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105696; a=rsa-sha256;
	cv=none;
	b=QUS4eCYdOv59xBWuFTCZDldBLb0u26XiX486/qOr97xUPBqiFLA7ZbSHKuvJK+ab/d/ySM
	3TZrvtRysGQND6eiuh20yZTWKlsLEFzt2dW4fNQcurbxL/JBmMpjbqg3qfJAoh2NGbTvNk
	/J1yrt8lQrxIpKrBLNXUKkCfsptSZ+Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8OsjUNu05V/Xcz8HI7pnG5Up/ePNSaNnSj1ALtPKgps=;
	b=QzYEVMogdec0mY0J3RwU6Gr0HY5yw0g0PC/NnZW/DkMBCuL1u6KkUPmfl0LnrwBZt3mQvH
	6feN36V2Wav1NYWbEYKn+KdkhTLakwltwaJjj6dePky67MgNDAo4NhXA6gniUjonuoiq0T
	kN0P5eVVcfWnMjq8z+u3t6YjpBzNfhE=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [RFC v2 18/21] selftests/mm: add partial_mprotect test for change_pmd_range
Date: Thu, 26 Feb 2026 03:23:47 -0800
Message-ID: <20260226113233.3987674-19-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5FA31140009
X-Stat-Signature: x44bqaazjpgkbr1psmyon17a616urtsy
X-Rspam-User: 
X-HE-Tag: 1772105696-383853
X-HE-Meta: U2FsdGVkX1//xtcPXyBr7BBZu9/HB9PsBeIb9GLMc/sAg3MUvFzSLQlqzv5rl8hSYcKsg9Nb6gC7ietoNmds+0s5PGXqY+xQLrdqvA9JQfZNirrLT1cb0chD5gICAS8EOPRCDS+pXKuz3Vx+rutBg51DgaE+7GriW6/gqiWDrZuG2ecnIapC/sLXLrO1F5U4hvHw4XzvCz9Uy+KaJ1nLrswUmFE74OMaGE8KdrWb4Wtiv3SqY8QpTS1Mq/5fU4aIQGVbgTFdcVze8HDgmRAiDARWTTp8I365py72ANXwE/xOP0gcLuXetSETaPAg+jSGHkZndMuG+OMY7HJgviQECKQfEwKlhPAp8N8lhN4np7k4OzP8a7xzLpxEVkxw1EwZVkz7hMrcfXaFNzhiJKS5jmLh6N7QNWOOKLcNMSKH4cNUeVpX8K2whdSg3Ktrmc8DytpK2BLxi/F/DfkLXmFRy0yWXJQaVmv1367zd8Kw8RIS58YAPRLwZlyDxvqQiCgI9TuMDUbxViuUjZ5DwvI0E50wzfurYK7pMtGK8z6nr8ZauNxnCFfT1RsosM+PVrfLdIpNNf3IHGz4WzhHaS0IyFPwYv8Xrco5G4PvuUWY3YliaGdmdky8E5b14rmO4REd75cgxw2amZzhJK5DohKaowNZh628Sk8F9keqJoO6gqRzeCCRIjppcjPbzZppOL2CdW5GGE8TvjtO0ss3SiBerEqE/PV/4ysr493P0EDyhzyMeypKOWOdqsVCXiBltdIqtJcD+7UCDAusL3VqYcqzed7bRyhVgcqARdRYrlaYHGNUdKIrqcArzzAcWHkJZwrXC88Ta3oQm8ClPg2Grr0wAYNkDuuBXeUpQsgMGRI6M1k7iM8e0ZK9pgg4dF/b0E4iUmvCe+/L9fJbkUe8OolJmxHLnA1ydzCqNauNRDYvR7jrEdfUX0hng0uvqCNGAhyPBMqpX7YQJHPTfQlNawn
 k9l7mAkU
 7aFpsmRZio+aTxKOlSxCxMEteaSVMxpITW+3W7EgH7oBX8nwIH8mhqFbAT12z7Kx4XkszlNJ4+OB4B58ysAzmI8FWtHZzUmLdZ9HhhAvPlZmMbaQi1kreyD4019eJhOIs5ooD7M34kRLsKfJgxJL/utsoNePDf8A+hAzd9U+DQcb7qgYUwcqBf4e2QXUJKmWmE/0YioWHKLX72WUVnGjyrK+jrlYNwOZng9PbrTNltdbU530dOCdF+8yqRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add test for partial mprotect on THP which exercises change_pmd_range().
This verifies that partial mprotect correctly splits the PMD, applies
protection only to the requested portion, and leaves the rest of the
mapping writable.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 .../testing/selftests/mm/thp_pmd_split_test.c | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/mm/thp_pmd_split_test.c b/tools/testing/selftests/mm/thp_pmd_split_test.c
index 0f54ac04760d5..4944a5a516da9 100644
--- a/tools/testing/selftests/mm/thp_pmd_split_test.c
+++ b/tools/testing/selftests/mm/thp_pmd_split_test.c
@@ -146,4 +146,35 @@ TEST_F(thp_pmd_split, partial_munmap)
 		self->split_pmd_failed_before);
 }
 
+/*
+ * Partial mprotect on THP (change_pmd_range)
+ *
+ * Tests that partial mprotect of a THP correctly splits the PMD and
+ * applies protection only to the requested portion. This exercises
+ * the mprotect path which now handles split failures.
+ */
+TEST_F(thp_pmd_split, partial_mprotect)
+{
+	volatile unsigned char *ptr = (volatile unsigned char *)self->aligned;
+	int ret;
+
+	ret = allocate_thp(self->aligned, self->pmdsize);
+	if (ret)
+		SKIP(return, "Failed to allocate THP");
+
+	/* Partial mprotect - make middle page read-only */
+	ret = mprotect((char *)self->aligned + self->pagesize, self->pagesize, PROT_READ);
+	ASSERT_EQ(ret, 0);
+
+	/* Verify we can still write to non-protected pages */
+	ptr[0] = 0xDD;
+	ptr[self->pmdsize - 1] = 0xEE;
+
+	ASSERT_EQ(ptr[0], (unsigned char)0xDD);
+	ASSERT_EQ(ptr[self->pmdsize - 1], (unsigned char)0xEE);
+
+	log_and_check_pmd_split(_metadata, self->split_pmd_before,
+		self->split_pmd_failed_before);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


