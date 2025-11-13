Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 113D0CD4F5F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 08:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6E08E0014; Thu, 13 Nov 2025 03:41:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BD9F8E0011; Thu, 13 Nov 2025 03:41:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FA708E0014; Thu, 13 Nov 2025 03:41:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4EE328E0011
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:41:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E644612E5AD
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:41:00 +0000 (UTC)
X-FDA: 84104938680.19.9FEC5BA
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id 53C3EC0009
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:40:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pSAt6uXD;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf10.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763023259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Bi/XPLfLPitz3QFgeWKraJXa3JEmVmi80D2Ta/Izrs=;
	b=ZKA3AVJIQCqVugMWmVas2ERQz/SZ3Orwm80NLx8mcklZakFUjp5tbMaVt9lOZ7ntjQDTot
	j6JDiPK6xxzu+/jkN3zWt7JK7Yc4Q5VV/NuM5/cMqYauhuVyUCMlQ3gfm4BbLZgps0Y5QX
	GW8gOxrAEVIE7Fqn/lkTjQK0/0ahIYo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763023259; a=rsa-sha256;
	cv=none;
	b=Zu5gFsZOtsNFAZj4AE8pKbL1VCxt9/gCjFujYsOy69dUHsAPpYy7ty5g52zuu96hZe0boF
	5tdkUlWlXHS7QNNQWHmAKHKbCfQkxdd7ElsxuEURlBFc2fF8CGMEdWKcL0n2RUCt1InwcO
	u8mPnd6Y0FEA0eqEqdqk22MMyLC1wQU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pSAt6uXD;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf10.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8Bi/XPLfLPitz3QFgeWKraJXa3JEmVmi80D2Ta/Izrs=; b=pSAt6uXDuV54wYKSjed0vjd2l0
	Ow3XeFxH55qemFo4LisNTpjDSMqYRHyiKJFN0tN5MPyRtpOtvAaKDhLa3ADkSACzqW3Ydgv9Q2AjE
	PW1VJGNcFEyFqt5VtNWeFAvNpSsv2QGN2YeWJHptkrncTNGSpHQ7r3jcMpmxXpdUvuYdIfv3De629
	H9n8ZM+obWkoXZC4aPnJcZ6jUrxd8M7nsiYkFKV2KIHJbpoT5a/EdO7RniUh18WmuQ/XFIoi+rgXl
	G2O9CFV41dEGE9WyvbUWFzQRLjSUbSuBegagFiCwXFb9iIZVKOb3KJMUatT97i0UwU3D2TFF7PfRy
	zHdCSH8A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJSsx-0000000A7Qj-1Vux;
	Thu, 13 Nov 2025 08:40:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] mempool: add error injection support
Date: Thu, 13 Nov 2025 09:39:45 +0100
Message-ID: <20251113084022.1255121-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113084022.1255121-1-hch@lst.de>
References: <20251113084022.1255121-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: bghqecqzc1pdq6g6df35a57ch56eexix
X-Rspam-User: 
X-Rspamd-Queue-Id: 53C3EC0009
X-Rspamd-Server: rspam10
X-HE-Tag: 1763023259-534468
X-HE-Meta: U2FsdGVkX1+NDRtaHG2UEdid1aNHVCVFc4aulOo6mmu5nT3ul/vns2OlxE14vj6HOJM7NJMyA1u8ePyr6d5vo5OHrWKhvTL18JS3W66YqsTJLPUZS2zFDOEFOqFbr2TuuJAl63RgDVhhr1dX+L/8+d5gsw8F6tzaiUQ6RkNA0KXxZmDsQH/RZtLzja70mDenMaj1YJd50KOMJnSVE9QTU1iX/8oV6z7UpHM17QWM8YKNmhfw8/DWjUpU/zHIGqCslcSrsughpGoM9P7RnmiSbXTy6akOA8woWuQfH8gDsY76r/g0MUjFwy844WQE+wSOvfM6VM9QBXMV9yKosbXA9Hc9odarkrdipnFoh4FLhRO4oCET1NtsUNSEBcq4FhLmo/W/4invi04b7ttKH5bCD3h7ll7nswqQPkENSx+Nnumtlu9oZdt7QzdW7y2Zn4xshvcC4qWrUvKrbaTd7q0wtoGvy6xhmWWOgySQpqJJJGuCNavHIUxCQ3ak61gyG1n3XvwOM4VVQgaEUEAAzgSyFvpgnc4Lxv/ubxlmN7HjXp18k6eCBIIShjNFdecsT3U7Z1vrYR0vexPshf+y0HL/CsLFUkNTwsdGqX15VJ1di5DDkLgA440L65sxhP0HqbuJ1pFSGKxhfYbc3EsHAvSBNJPpN7SpwKX7AyFCVlruHAldO9fPASgiiHPLEMYOKqs0gicmR7OL4T9fnXLj2XqvxEyadANTvrEWYR+C88SMHpV0noa6a7yz+vjxHFU3Sb/vAxgNWliPtO0lDMyl0mp5kBudw4IMI7iqqP2nwPs2y5Whk7gguy/g+n/3NjkuSXpGErYo0mcLl9MDrQ7wKlTovZDpR0IMONrZ0NjdVG5rUsR+HObGANNJVdD4KB6/KngH+czvllcgerkrqS8HK42p3lVETjujU3ygybgvukWtJWcgjOZqybPnbfsgKY6efLYZtlMN6ZX1Hej+EFU3M+5
 xyc9URMe
 dvWFubHeJKqu2VRxybo9wuOLjwnYQEeHPCQYMRaaJ3U+TZ+E/DHA7GXLbe5FGMcbQUCcn2kgYz3+uWOrp/iElXnNWLK4GXOHH79GxtALbP7XFrBd6azey07smhI8T0elJx0kLmLdYgJzCt35X8uwETKrs1WoUuKSU2PktrtzePg/eXW4ZmFKqYPBkJ1uR4/aVGKAzwP9tYWVlP9ZqaJPKLAxfxyr7051hbz9iVfb7zvxA4Q3FRbxtIIi68kngDPPtD2idga3aI9+Dsgd4NQJMmdn5P+qcpmmEjfiMxDvIxn6MV0BrPia/CAYe6IjQyFSris812hGbTIM+9rAtkQmH0IbBW4TSRf9w2IH80cYlAB+FUNeNIDSVXQPdwDHlgLA/MpNUm0nDyTEX4MzhZtt6ToBTUZPbp514w5iNR5KkK2Rkb2hFwbidEwmkRMf4fbCqNxDxwG2k0FZWVW3eqQq+R0Flkt4W4MD6LyI++7kOTarfTv4a9R+C43p4yIYeNo6om7h4jJB2TuGqfagi0Y/OZAr23nL6+RnbP1LzSzfkeP5La+asfQg32YydoXMQUCASp6GW5KIk0vUAAuAzzw4UTxk9Mw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a call to should_fail_ex that forces mempool to actually allocate
from the pool to stress the mempool implementation when enabled through
debugfs.  By default should_fail{,_ex} prints a very verbose stack trace
that clutters the kernel log, slows down execution and triggers the
kernel bug detection in xfstests.  Pass FAULT_NOWARN and print a
single-line message notating the caller instead so that full tests
can be run with fault injection.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/mempool.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 1f4701713203..5cf59779cc3d 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -9,7 +9,7 @@
  *  started by Ingo Molnar, Copyright (C) 2001
  *  debugging by David Rientjes, Copyright (C) 2015
  */
-
+#include <linux/fault-inject.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
@@ -20,6 +20,15 @@
 #include <linux/writeback.h>
 #include "slab.h"
 
+static DECLARE_FAULT_ATTR(fail_mempool_alloc);
+
+static int __init mempool_faul_inject_init(void)
+{
+	return PTR_ERR_OR_ZERO(fault_create_debugfs_attr("fail_mempool_alloc",
+			NULL, &fail_mempool_alloc));
+}
+late_initcall(mempool_faul_inject_init);
+
 #ifdef CONFIG_SLUB_DEBUG_ON
 static void poison_error(mempool_t *pool, void *element, size_t size,
 			 size_t byte)
@@ -404,9 +413,15 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
 	gfp_temp = gfp_mask & ~(__GFP_DIRECT_RECLAIM|__GFP_IO);
 
 repeat_alloc:
+	if (should_fail_ex(&fail_mempool_alloc, 1, FAULT_NOWARN)) {
+		pr_info("forcing mempool usage for %pS\n",
+				(void *)_RET_IP_);
+		element = NULL;
+	} else {
+		element = pool->alloc(gfp_temp, pool->pool_data);
+	}
 
-	element = pool->alloc(gfp_temp, pool->pool_data);
-	if (likely(element != NULL))
+	if (likely(element))
 		return element;
 
 	spin_lock_irqsave(&pool->lock, flags);
-- 
2.47.3


