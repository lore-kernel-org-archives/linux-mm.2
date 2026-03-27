Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF68B10A62D1
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24DD36B00C9; Thu, 26 Mar 2026 22:16:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FE5B6B00CB; Thu, 26 Mar 2026 22:16:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B906B00CC; Thu, 26 Mar 2026 22:16:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0606C6B00C9
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:16:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE864E157E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:16:20 +0000 (UTC)
X-FDA: 84590228520.16.0FE0206
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 26FA320008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:16:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nFrkNXxv;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+u28b+kGwOwWeo4iPTn5u1dAfo4aLeElFP2cFybYpB4=;
	b=n5EM03RkNT/jCUNwRbwNASmcv38Il5AhLLIikz+O31Rgr7J1gqvNTNJL4d/P6HjczjOspN
	1kXsDTF3dyuwYg9Mzbk9cVWTShQH8/O1XeVqaOJhXpAFxCVqEf7/1qGpZgLYe4S3B4Mn4P
	SPJwt1njmQwmfneO3LVWGE6Py5XhjLM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577779; a=rsa-sha256;
	cv=none;
	b=3HLRQ2jayUwm4Zkr2uNO9A0VfbAcWhJ4K/mP791eMXxmaaYpUfeVHGBARmCYmUohkdFfQO
	cfbr4dhhMqNYrdDEE/tjpQIfFljFzzVSQJIXnf0L+jV7NmZHeVZ97QZQ+8j2QEsbooVgk6
	cgyjs88A6e1uDLUmsH/9W712xDiMhKk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nFrkNXxv;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+u28b+kGwOwWeo4iPTn5u1dAfo4aLeElFP2cFybYpB4=;
	b=nFrkNXxvndBSqppjWyV9ntkfxnDZ0DtuCQnUOY5sup4Cn3dvGfyt7wUKnT4xAdfcGQUu19
	prxL9x0QtRJ7eGgfh7QoH8qmgtTOcQ/tFTBltl+w+k5V6XIa5MkQdNn/z6ZBfUXndUQ60X
	oH4UtoxyWYliZvg4O6754ph/DAJrixE=
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
Subject: [v3 22/24] selftests/mm: add partial_mlock test
Date: Thu, 26 Mar 2026 19:09:04 -0700
Message-ID: <20260327021403.214713-23-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 26FA320008
X-Stat-Signature: 9fuz97csr5aqbc1f3hhjm3sr6c5p4qak
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774577778-840880
X-HE-Meta: U2FsdGVkX18f6TH8oSydh2pDJOqXDMf21D9zl9ou03dYlM6mptMFPrK5aRKbZVLPDAG6a+rr1JYfXc9GtBm0juIx0vJzR+UwZSXDQdARzaIPicTD8puG1kSGwp7Np4vrmVw2PjrKaZ/8VjTXETXFBT74gPh1kq9ahIiVi0ZrRrfKskZsvdahmTopBYlGvkuJcB+L71cKXUrSb+MDoq3DVt4hPyxzZCS0d+Lo2OAypV0idXvfbiyga8E4obGEiWQAzi1bPj5nIsHuJAcuWAQHvqTRSVFnTMcNe7T8qHib49l22XmwrWd4JI6Hkf6QesFHxbST+aqixe3bDnUZ2aWeCztQZIAlRiHecukVtT/syvB9s8ERDl0Rqe3An0AwzQqueXotqx154sKORgIwiE68ApwCtXtvu/fl31GdAlTP3WGBJoKZWoVK8JyxEDUIDBjdHtZYRpxZeFKANjMUwPymGN7Z73DM7Cz/R0cyaQ1U7gPtrWJgIEuId0hBmYDyMD3Lb8w5BuYgA9z33YDqTCHC5UqxjcBdqZ5c/ToudLA6tE0OJQmtrk3yAKKns0wA9lZa7fsK/fkPv0WTh9robfxQl79L9ZuTE+iux1Hq8CczCKcuLxWKJ272g+P7I1NCYWvujvy34LBbRmV81euAjEyGwXWDJWkKX1e19xiSWSY6TYpa+b4urbrZADzdf1iI4h9RwxXC39O/v77avAx/3Wy/0ZHeZLD1dTvZpAed+ZSv79FKN6mQe3otuhg70nhR3MlLQM8AIMUjV4yzUA3l8ItJJ9q/MsY3Bx4XGaQ3UjUkrF7thamZYg/3+ZYwp/mqFxPSmmoR07w5ZHUFPcPTSyvRGMrqkaoWy3ZNZU5YO/V9cx7HxCbymkbsUY1AjwXm/5DF6XCxImYZz4Xi3kISVESU9ngO2qPRO2soAkTvmbgvzfnqv0UfoBu/CokpbigqEe1qCKnB4p9mhqI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add test for partial mlock on THP which exercises walk_page_range()
with a subset of the THP. This should trigger a PMD split since
mlock operates at page granularity.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 .../testing/selftests/mm/thp_pmd_split_test.c | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/testing/selftests/mm/thp_pmd_split_test.c b/tools/testing/selftests/mm/thp_pmd_split_test.c
index 4944a5a516da9..3c9f05457efec 100644
--- a/tools/testing/selftests/mm/thp_pmd_split_test.c
+++ b/tools/testing/selftests/mm/thp_pmd_split_test.c
@@ -177,4 +177,30 @@ TEST_F(thp_pmd_split, partial_mprotect)
 		self->split_pmd_failed_before);
 }
 
+/*
+ * Partial mlock triggering split (walk_page_range)
+ *
+ * Tests mlock on a partial THP region which should trigger a PMD split.
+ */
+TEST_F(thp_pmd_split, partial_mlock)
+{
+	int ret;
+
+	ret = allocate_thp(self->aligned, self->pmdsize);
+	if (ret)
+		SKIP(return, "Failed to allocate THP");
+
+	/* Partial mlock - should trigger PMD split */
+	ret = mlock((char *)self->aligned + self->pagesize, self->pagesize);
+	if (ret && errno == ENOMEM)
+		SKIP(return, "mlock failed with ENOMEM (resource limit)");
+	ASSERT_EQ(ret, 0);
+
+	/* Cleanup */
+	munlock((char *)self->aligned + self->pagesize, self->pagesize);
+
+	log_and_check_pmd_split(_metadata, self->split_pmd_before,
+		self->split_pmd_failed_before);
+}
+
 TEST_HARNESS_MAIN
-- 
2.52.0


