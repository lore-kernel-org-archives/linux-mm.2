Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34BAA60A261F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fRh9t9bq
Received: by kanga.kvack.org (Postfix)
	id 4BC7B6B05BB; Tue, 10 Nov 2026 06:25:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494056B05BC; Tue, 10 Nov 2026 06:25:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1B06B05BD; Tue, 10 Nov 2026 06:25:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 190476B05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:25:05 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1558405A3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:25:04 +0000 (UTC)
X-FDA: 85418977728.22.210AAFE
Received: from mta1.migadu.com (out-138.mta1.migadu.com [95.215.58.138])
	by imf09.hostedemail.com (Postfix) with ESMTP id C039F140005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:25:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fRh9t9bq;
	spf=pass (imf09.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.138 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794309903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4P6LhsQ/fmPy4a5lBGBrNsm6TX2VeTBD7E46ZsyMbw=;
	b=fm2o2czYg8a0aBsn8vrThtAh3z8zBLNWtxY73jHCsRYX/+jcqDruidQvbYeaJ+IWUN84DG
	LQTg269KJixE0UqxwML9qkiaS6JSX060mU6NZdRqS2P2cSSgCUr0p3fZuji1NLgNOQRyX9
	N1+yxaigtsFg7aHCLMtSf1+fG4P+bL0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fRh9t9bq;
	spf=pass (imf09.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.138 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794309903;
	b=u50YUt66S837uVhCoIX7dXP9zaNeY26xDU8WfvOCCqo1r58u9qm9q6/1Uq5JH8QC6YnM7R
	q+GwgRi7Yr0d3rYOSd7VCn206vwEScZHkO6O6AuwT1mBz1xalVOxssQZkCejLCnzmVniNZ
	c4k+dezpgLwZgTWp9G4OiSY4nhWUpWI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+BC/knlX3zAYieQSABgTL8lI4HMkwqXZ9TtJrVcUkfo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794309901; v=1; x=1794914701;
 b=fRh9t9bqwuJwWnU5UKDpMM1ujVrKmiPY9fh0jBO+sR1zq4FW8d5SgsPHoCP/gMNOhQlCcLwg
 J9S+IpH0VFjgqCIWS/eTEMybOgf2yRlUsgxZ0djPrsYmhhFWgvbK3sl21688xRHP/8HKV5QOh8u
 tevumLT1KzR8IPOyN5eoSu6g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6399328dcb90171d;
	Tue, 10 Nov 2026 11:25:01 +0000
X-Mizu-Trace-ID: 6399328dcb90171d
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v4 5/9] mm/vmalloc: BUG_ON() on an unaligned range in __vunmap_range_noflush()
Date: Tue, 10 Nov 2026 19:25:42 +0800
Message-Id: <20261110112546.261415-6-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261110112546.261415-1-hao.ge@linux.dev>
References: <20261110112546.261415-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hh86mb4f85p53ri3zmkp9roo1kwxhhum
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C039F140005
X-HE-Tag: 1794309902-228827
X-HE-Meta: U2FsdGVkX19eqy0mAouBW1gS9/DV0kBzUmJCofHH6UMqq9cXwZgN74bsk+bKRzPKkAJRXbTJN589tBSFfgLpeOpZ0BIF+V4f+57yDUWLTC/am/SpZSYvBD5jWN4u0g5frWVGWH1Z0zGimP5L2KEWFuaKTxW7b52l+rgx5qIYfZBbwqBmJ1zBIC7uNdB00xelewM5J/7KgwJQOgUGyBl8GNzfCMD7mgKbJnUkyBtRTl1RPNz79bKJtQzV7woXZZIkbJ5TUkxEEi+xlvrzIpfJ0wHf0Y2ApwJvUHiee8sDTEmQ1lxn/krK3LxZK9eblGxhOtaraoz5qzuwiwxICGevV94dRZVAmDuABQxu/9cIehWHhXDMVhWz0/CxNwzC37xY3vJSi2Yf3DqGGPLkI01o28SrGTMkqz/GbHdTevqggAyjnV2TTif1H7nAjiT4x00QsrshPzjqfY05/R63HwvOo8WOU16bgX78AK8y6iNX1xHEeEyYoRDfjO9RBNbHRFrc3wI8Av23lJhNejh2mqBn8+v+OXb0mVV+VpqMGh7p3cxaCd9ZLaKXOyTHl65+WHVkFjH8ZLb6y4Z0Rzd+PQ50jrNEill9W4H0r+rx/29cbGCPWuC4O8azt2UkA6LzQmkmIPwam2GDxCfJii149USNWGDOzaBWgkX+w7592eCzIRxRAY+65rSi0+AnxZIVOJutRK2Zl1aOGrKibgnGSQqiMyUFCCwm1D38cDGQVyGOeqv5shXF5ACw8OUaotYAAXrukR4XjDgXgI5D8puF9O/I16kwzIfVgC+W9aRQNmVMoMR8oKIpzGRMOcSLLPHOcitKQSRnXC0rSUtiJ+yHb2uBJ6zHStGZpt0y5XMKa9bJKmB549q7VoqyDl+zNQVOIzP1Kev5zR0oCgrvJGwFI78oRRhIu83Tvk/uOCWbWX295dRUCxB5rMA5nRYFmDnGFnut/SwPs3UUqJsZyCEnVE+
 lZEg3fcw
 zft3w7+DGV6Ovsm554LO0yWOTSyAiLO5WjzoWnY321Mqth8KtRZyUebUJWBQGjz3FE4bexMM9RJTF3rFJVQxlfKVirZ+Yy9fATezZyrvCx2gkHZQ5h4Z0tC3HC6eu9bx2XPvdriKTLgbogqJtE2Hr9H54Z7OThSyqsItOD1IAzSqwngokM7ZH9OuVH6rxwrNnVKfE6+Cy8as2LeDPiq+QzQQdUb2xdOPISHviSJq5kZ9b8sy4z2RjqOXeplKXYdTq/Ahhlrkr8bu++ySdv9hMd3bAacn5LvNS3DGXcX27EQw1Vpal87MzPTuxFj6T0TVNXcGHaw6NGd6B02ZNWsWKXGQFfEEA/sHS7n6Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The PTE loop of the unmap path stops only at addr == end.  With an
unaligned end addr never lands on end, so the loop walks past the
range and keeps clearing.  With an unaligned start the loop begins
in the page containing start, which extends below the range.  Either
way the unmap clears the mappings adjacent to the range, and that is
nearly impossible to debug afterwards.

vmap only installs page-aligned, page-granular mappings, so an
unaligned unmap request is never a legitimate teardown, and there is
no way to tell which pages the caller meant.  Check addr and end at
the entry of __vunmap_range_noflush() and bug out before any PTE is
cleared.

Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/vmalloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 86fbb1d2b27a..0565cbfe325c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -518,6 +518,8 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
 	pgtbl_mod_mask mask = 0;
 
 	BUG_ON(addr >= end);
+	BUG_ON(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end));
+
 	pgd = pgd_offset_k(addr);
 	do {
 		next = pgd_addr_end(addr, end);
-- 
2.25.1


