Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08842C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAADC6B00BF; Wed, 16 Sep 2026 08:03:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E36506B00C0; Wed, 16 Sep 2026 08:03:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD6FF6B00C1; Wed, 16 Sep 2026 08:03:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A6D436B00BF
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:03:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40F311206CB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:58 +0000 (UTC)
X-FDA: 85219491756.07.634A574
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 825D5120012
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EAce1fhA;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJHDp9vqJXqFSbKUnrSygcbO2/M2tpxb0Oj00wJTPho=;
	b=F7AmnBwgeQmJQZE3Xc1ADDy7pgWqKXq5/LEVp4/veYufwuhTyC3AyZXx8gsVT4IrlkTSV/
	VA2PiFpGucX8119w101/4btXZMEmuHQgQw4dVih1woLY2gLbJfLUyu174+COg7yssqQ2Yu
	1tabgFPHSd+/4lXESC7p41mOlOJnMns=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789560236;
	b=vl/x34Mp1QdKu5Y2TK6ak5/gMga3qnFA1PHY44E6LotHO5AVouNQFkZr/m6/IPcynZFsZl
	o6z41N4LP4VljJX1GlvnrMQQyNkN5FDx7OR/3zSI4yfL8dTRo0oQsLJtvmnMePb9TvRcCz
	z5j7IKX7mZvNZjRtTdWAvFlawfp21io=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EAce1fhA;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF4D043912;
	Wed, 16 Sep 2026 12:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF581F0089A;
	Wed, 16 Sep 2026 12:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560235;
	bh=DJHDp9vqJXqFSbKUnrSygcbO2/M2tpxb0Oj00wJTPho=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EAce1fhAsPPC3kF2ylU6CATF9nCbEqSmOzx7qUVC9VhipchN28lkPYShtYDFpnw4j
	 dG3GPyU88038isT2JPJkUb/bUoev57I/6LsEjI/rAZ11k37trd6BC27abxzYWYNOEP
	 H8PiUdqA53Oec/qZ6dq9sCFnuf9pCE9N9V6/stGDpGbA0b7pbDXmhE5D1y/G0/VJ/J
	 2qiOpv27g4mGTl+QUnws374gEYEEUDzSEcJOnMyPN0s68mMUJiCBc8HwmmxIRnEYRl
	 ZIefJntx8NH8HODnJHM5afimdQfkzB1S1+k2VPJAloypuVJusewfq99/PSFwFYZwes
	 Q41c2eDiC3Ixg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 16 Sep 2026 15:03:19 +0300
Subject: [PATCH v3 12/13] s390/qdio_setup: Use kmalloc() for the SSQD
 request
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-s390-cio-ready-v3-12-39e4894637d6@kernel.org>
References: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
In-Reply-To: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, 
 Peter Oberparleiter <oberpar@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Vineeth Vijayan <vneethv@linux.ibm.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: uo63f6awi8xtxertdxk66wutne8rko5c
X-Rspamd-Queue-Id: 825D5120012
X-HE-Tag: 1789560236-49284
X-HE-Meta: U2FsdGVkX1/ChHudyiBqAHPHIgElZgXV+YqvcmofHP0jWvolnofzBXjJwKaR3oezvjWNNP6VDrgUdtaA8tOZBWPbDy1BJX9o0p1vggKVVIrRKUVNwXGNUBV4iQaH/jsGkWlYVQ2IJ43hN94wVvkMLSRM5A0ebYxb3P3J3UQFvQzndkGmieSM1cJ/XWzVayv2jbqcT+oI7Knw3FIfW4Hu+LcQU1asUTj0gudI/tcYHk4Z/vb7rvVP3Seee2g+HIWxk4wvg8h1JUxDCwl4IxavoCXSm2+nAj9gy0+hrIe/DdhcjifFx7di2MP0ri43AxBUO6FDziP7np+L8sfe/Y6VN3YKo9tQgxpqz3amqEW2Fyg74YyQVoOl75xEtbKSGb4M/CqEHEB7wiP0fwuFPhQ38CPQPS+lM9sxgZOP5rUwy11ey8WbBZcASt5Ir1jZBFbUBeKb3SsvhXrXcfJje4hv3ziTewj74DekXD2GBKTYQcaQuJ929qmJY91syubdyubU7JXkhHdkIu8TjBPTWpXOGHLyJWDFfPljrkD5iZd0fb+4ojB5CEX9+7svJwzgO3UcdY7TKvFouQMMX9mtVnGBe5gyCb1Lu6FkjtJPfIy6YMeEKwpXCnF5A6iugbOczJvVi96mJIXqgdLfPjOTyKqMmJxUFhUMu953PQzTuS1IPEgn+n9wM6CaNtALZ43xhHqGgrYYDjvm7FdgJ/zSJeqazYv//DiDjEolz8PUMAbbMGii9nvK4PycGRwl6rEaODgQIrjz4CrkIFPnradH4+rjk5i74hUxqRxH23vKY9ZdgISmlg86A2dS70zlDnflTyHqaTRJQa+T4kaRls1SC0fwuSOLR59+k2WDrx8QpZzr4g9S81jddxxQDebD0uVofgzoCnECNF1iU8I4nWnE/VeyKgSRKndK1D8HPg3w2NYvKOF3nls35qa1EhPRVmjMLbEKJDCHMUmxCGSMLdKO3YD
 MMQIfh8Z
 f6AsuyRj8h/b6Bq9/7M8EfS1pwRqFJ3i1hThtId2+6Wq4nzU43aQwEqPz8DV3OeQcvClmKiYiJYekKwbohERKf/iTdRHp0dwKNE+XvzxkCjnFat7HYY3AJxRUpY+Vj2erJe5paNOE5kk/v90XMJiwCYrN8eUpxT9NKNBDXOS5WoD1OEg8zaWZN2pA0KsVuuZUi7elRspgaffly2wmS6pcSXxTkDW87EByBcaIgatlvaISi0lt5PrzlF7yilLis6kDTHSrAH09TBHbr8x4nhPZYxmWh1crGcbKtbRs9PaVHC8sFwEFAXK8kZF/VwpTugzRxZW5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

qdio_setup_get_ssqd() allocates the request block for the Store
Subchannel QDIO Data (SSQD) CHSC command.

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/qdio_setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index d8e9c0872d15d..e1c5c6a8b3b27 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -249,7 +249,7 @@ int qdio_setup_get_ssqd(struct qdio_irq *irq_ptr,
 
 	DBF_EVENT("getssqd:%4x", schid->sch_no);
 	if (!irq_ptr) {
-		ssqd = (struct chsc_ssqd_area *)__get_free_page(GFP_KERNEL);
+		ssqd = kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!ssqd)
 			return -ENOMEM;
 	} else {
@@ -270,7 +270,7 @@ int qdio_setup_get_ssqd(struct qdio_irq *irq_ptr,
 
 out:
 	if (!irq_ptr)
-		free_page((unsigned long)ssqd);
+		kfree(ssqd);
 
 	return rc;
 }

-- 
2.53.0


