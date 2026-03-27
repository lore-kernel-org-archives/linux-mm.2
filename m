Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E97FB10A1E63
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 533D26B00CD; Thu, 26 Mar 2026 22:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E4DA6B00CF; Thu, 26 Mar 2026 22:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 422166B00D0; Thu, 26 Mar 2026 22:16:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 320156B00CD
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:16:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E73878BF6B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:16:32 +0000 (UTC)
X-FDA: 84590229024.21.9DF8916
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2A66518000D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:16:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LBA+DGA7;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577791; a=rsa-sha256;
	cv=none;
	b=fNC0OthOGvKnM+69j4RpwSG0SOlzssDGqgYvL/Xok6JT047+9sMUoFfLBud6nv6V13U+WO
	bvojhhkD51u/mEXYntwmKR25+gcNn5Il4SF8lLsKZiluF1onzcGIe8vU5KgDVCC/LH87Ev
	2199jFeZU63kucRef5Hu3a2vF9gulFg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/HdPBhl1cpZOUmiZuBTWaeHIDSWjs3qo4yxLZnBGpA=;
	b=cpBKYZWCyZborgo4csUGevUkuqV02rhGs8FbzBwrSp5F+etKBJiZMBj2xvkgI6mBlgF32T
	jTkXnAdfpPMmlYU8QyasVKiEYWyT+hd1rmtJNW5v7ft4UwNfBoQMTJA6z96OQjbAOGeRTK
	iCLSVWsyEDCFh2rTBKkqA3mVWFRdiAQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LBA+DGA7;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6/HdPBhl1cpZOUmiZuBTWaeHIDSWjs3qo4yxLZnBGpA=;
	b=LBA+DGA7C1hpEc4UK/USzbeWl9ofYAB9golUoHkRx3arz+0f+tCFBPShuiq8sFBcmjRcuj
	BkqIUVWSZWrzlncJMS6q2HSKiSIKaHundpnJFyYH9WZp0Dq8jBzWfRFloYOIU6zqnN8+4q
	hwvlj8SU2eHG55dpFcr7cLa/cO3P9xE=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
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
Subject: [v3 24/24] selftests/mm: add madv_dontneed_partial test
Date: Thu, 26 Mar 2026 19:09:06 -0700
Message-ID: <20260327021403.214713-25-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2A66518000D
X-Stat-Signature: 6hei19nwj73jjpn48bebec4dxcpoy55d
X-HE-Tag: 1774577790-143935
X-HE-Meta: U2FsdGVkX1/bxU9dh36G52L34KRTUDWT919oimEU2XF+SwRk8ltUCEl/aHOdwTYnL86ey+jo9PL/6g8a4j5E/5+vPDxwpc6l2wKCllI3VKwKRiDRDJwTTs2B0Wm4UZIlHb1/Quj2dhzzMN/pGjlVp0ZxRc+50jdVMIeFZpulSnK+LVbSLPu1Imj23puBzrYNCFTiSGHl2LadMKwYQ9UWT9uLeRHznBOUF8cYcyGDi6Zez8akFtQBXC/AtWnfh4s8EU+gExEHdNkLMHz7iVmPxeKdq7ucllw3+t1fiMOz4/CiVZ4PlOTCZqg+Zts07pfhyu6+5H/o7VX/Uhn00vWgqJZpMONQWqZgGL9+ffLIrs+RN+kgQi5nX8rOcOvDWjvG3Lnxn76qPsYGNGfdgOfsOmc3r1yZ648dFe2v5oO1bEWd+vXmOmIDxg2hVPzUUK1tD+UlpANTabAC5Nv3cS5Z5OPW/Xr8rsqqinn2HGr1czaaZILxI0BnMVhaGdaC0D0QhRnjrSa0qO/E/qVs335A+dlP2qR8kqWsOIYoMhNX/freIUdD3m+lfdS+EXRvPb0lPOldFbCtzVgp+2cXZzOjFoDTmh60Gycyax8OzR4IthWRS93whF1Tu8+gBFfadG5DiEVNNZD0aZrsgOtpTaycEe53rdewYE2gRX29Hss2lQj6H0yoSN/6uNX9JfuML2Jhnf4YWR/4UFigs3nti5svv+kED76kDLmXAlVSUfgeVwJ898s+r4nmS4CKqsRyJ91WwhKhA/cAVcNAtbJTSuHBP7PCQ5ufBAcDIOqcIkhuLfzGmWbaUL6USJlTCdxxVCvX6QoY9jS63Lqd+lO2Bi8+B5LFrc91rqREC5RI1ziwn1x17432nUk4IUEYhiBhfrVkwVH+8ZAdkwG8fQp/I5/0VfcWDpocwWyMhnZcpit5TDrUgiKtBzLsRy8aOzs59ZF+dxte9j3m72D/HqwL01I
 gz5Vb0ad
 5JmGDy7yDPnufglVfDLChjomS8qO5koDX1seq6e4KoL8fpdX4mHz+eX5xvJFgRGEjYNsaLjyhmGqzT1sgpyuake6YYJ3DejPaKqpI00shoJ+UJM6VvyGvDX7mSILF6u6gqkX0GfGuw0FiK2psEEteOePZA86iQaMKzFEHexLN9q2ObJEqg8r6rTWGc3HprM8AR4cLkws47rEv65tyeq2u+iJIcptw6pLlXE+GRbBBYST9gPsHB6S3GmzNbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add test for partial MADV_DONTNEED on THP. This verifies that
MADV_DONTNEED correctly triggers a PMD split, discards only the
requested page (which becomes zero-filled), and preserves data
in the surrounding pages.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 .../testing/selftests/mm/thp_pmd_split_test.c | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/mm/thp_pmd_split_test.c b/tools/testing/selftests/mm/thp_pmd_split_test.c
index 1f29296759a5b..060ca1e341b75 100644
--- a/tools/testing/selftests/mm/thp_pmd_split_test.c
+++ b/tools/testing/selftests/mm/thp_pmd_split_test.c
@@ -253,4 +253,38 @@ TEST_F(thp_pmd_split, partial_mremap)
 		self->split_pmd_failed_before);
 }
 
+/*
+ * MADV_DONTNEED on THP
+ *
+ * Tests that MADV_DONTNEED on a partial THP correctly handles
+ * the PMD split and discards only the requested pages.
+ */
+TEST_F(thp_pmd_split, partial_madv_dontneed)
+{
+	volatile unsigned char *ptr = (volatile unsigned char *)self->aligned;
+	int ret;
+
+	ret = allocate_thp(self->aligned, self->pmdsize);
+	if (ret)
+		SKIP(return, "Failed to allocate THP");
+
+	/* Write pattern */
+	memset(self->aligned, 0xDD, self->pmdsize);
+
+	/* Partial MADV_DONTNEED - discard middle page */
+	ret = madvise((char *)self->aligned + self->pagesize, self->pagesize, MADV_DONTNEED);
+	ASSERT_EQ(ret, 0);
+
+	/* Verify non-discarded pages still have data */
+	ASSERT_EQ(ptr[0], (unsigned char)0xDD);
+	ASSERT_EQ(ptr[2 * self->pagesize], (unsigned char)0xDD);
+	ASSERT_EQ(ptr[self->pmdsize - 1], (unsigned char)0xDD);
+
+	/* Discarded page should be zero */
+	ASSERT_EQ(ptr[self->pagesize], (unsigned char)0x00);
+
+	log_and_check_pmd_split(_metadata, self->split_pmd_before,
+		self->split_pmd_failed_before);
+}
+
 TEST_HARNESS_MAIN
-- 
2.52.0


