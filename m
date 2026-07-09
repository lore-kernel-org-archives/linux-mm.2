Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74F62C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 11:26:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 679D66B008C; Thu,  9 Jul 2026 07:26:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651F46B0092; Thu,  9 Jul 2026 07:26:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A556B0093; Thu,  9 Jul 2026 07:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5476B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:26:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A57A7C01FD
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:26:13 +0000 (UTC)
X-FDA: 84969009426.22.1C97546
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7FA31A0004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:26:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ckWWnCQ0;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783596372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJkQbYDrizZdEszOQSdVvOLkhzaQUCCImlFR4zOjeQQ=;
	b=ozgFH557Gp1Nk+Z6HjkzwD0BVa3Wbd/pCG/1HTIOnxcxRWzS5I3iL0ZLiJ0ZXWWBJeAgS5
	ALeqWuEJrlRffL6/8gSZQYkg3k6I1xLMomQTxx2+by56ZvOR29+fD0SkPnnGpuNCqI5YTr
	OXpqwWKU5uPNZUcyXke46w48gfyHQu0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ckWWnCQ0;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783596372;
	b=tE3ffsQ9yrHa+Manu/ZD4Z5jJR95mr1EXm1ozbvvLYH2vu94RcDeuRzbLYrz9nE0KUeH4z
	mr96TaL5Dt6Am9B+xXa1mz4tC93dun/AL7rBe6Gk2ZeJ6p0QW47o6/WtlqJvbcOe0AOjCP
	CDPq3gl7G2gU+1UtuU1p0+hOcmsVGA4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783596366; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=yJkQbYDrizZdEszOQSdVvOLkhzaQUCCImlFR4zOjeQQ=;
 b=ckWWnCQ0n5uaBYjphnlUeOq4Z/eI1uC2u4Q4U0HKL+u2O/aHJ3Rw/X9DT75z+81h3bEL8S
 bZFVVOYIO7EqbhhOQHI2SqCU1O78O/DX/iMEa494KtWvkjTJQBg7QM00lVQoKdttSa8v32
 K0XLFF43ehtH2hqzONy87nMLrNjfWdDIGonVWkwknpe7aHOH+OeI4vUZsQPBg7fMfY0GY9
 kw1aGT40BocwNDPDJqGlkdxUa/xBfWZbxZhMJtsdjUXtqT+IvvNqSoVMMMX9l13/ksSAqd
 j7uRu2VrL60xfV4bwvAl/4o2igE8oCFXpjf8lU1UY2ZRUvtSVQjes9+n9YMccw==
Date: Thu,  9 Jul 2026 19:25:13 +0800
Message-Id: <20260709112520.24857-2-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <20260709112520.24857-1-lizhe.67@bytedance.com>
Subject: [PATCH v6 1/8] mm: fix stale ZONE_DEVICE refcount comment
Content-Type: text/plain; charset=UTF-8
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a4f854c+f875e8+kvack.org+lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
References: <20260709112520.24857-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <x86@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7FA31A0004
X-Stat-Signature: ufkhn68y8gdrp4ukdsq5rzpjuhm4ye3j
X-HE-Tag: 1783596371-325786
X-HE-Meta: U2FsdGVkX1+5SQmcT1DjbBANazRkCpsyf8yfyQvVI6MWAX4nHGh5N/4Hj5z15mVB5qFQgICBTsAIw1vpIqqGEvxTn9eXK7awVxAaAHI3LPDsdUPFHJxHsTTO+u3zaHnkelgzQb+YvTr6l/1OtOpOhniXY9BEyWMkQi0DspIyGLUh3Nf3Ai1Y2dev/ljBaCXIIbprEkm+pmbEw+CdkprnoGhs4gLo9hQxK2ay8hZBgT7HS65A2NkwiK4Ctu+//b2SCVIsdSKyCijoj+Qnzl5HfrQewTxCl9oLajYIoMuYpQemazSj7jfReXxXPSBWiPNEyVuOwtJ+6AF+DYeVZFk+BUa4OBHAFmJ1VY8+Wo+1vPV7kpldHSGovWXR4O9wcYWMFPMKUy3e1p1eeqnELQWAp5F465g8dhbV2Ci8X5lUzSxDGi02yk9mwhypGDNBCVrQNSAShv7mlgH1qMx553o7Mo9LJ0RjnZjO8hPwpbN2EPBEeeQbNt4SGTb8D8wBbMWHFGFoAfVnVRLT93DJMV+KjvcvrmzQ6bR2pc9bxYcIa3jn+gDgDeO2lhQJazNF0DbGzHvrEAluVshw3c+9lQTiL55x3qyG3QssnzwDyKfSVJAqG40VsKHvs6xUq4IAjf4J04f1SSzdUSok+UfgC5xrKIoXE/UNGMBjW983SZd49sWNkiYzR/Ld/EGLZl4GPHRNbPq6TD+iJqHxyIQwVf8kj+48Ix6trgXF+JgVhoI8DQSTO5DW38foDtpYVRzU9JqKZtcExf6VRXiK44+Jdqk4CBh8sipt+VuuSn6dg4jJoDeDfEugJYIPPQFZOVIUzn1zd17+0nvi5GF3gEZ8sWws9F8rC9WLiqmzcEWWEkiklBj44qZyJLxpcYbr+B+bXKnieO3HAecqoUpTApCWWLJhGTQTS9IyP/4broK4CjAS3g+Oa4UdZES5pJTe3hcS8Qd+A0/t7E6CSEEHVD3hsnV
 JhHZ5U44
 C93TBDD3nE8sGkLNNv8IBPsm3PWbumQLJ4hKk0FDByq5jSchRx/4oaguJgP/rjhhBZU9+ikCkaeeztgYHJEkow70JSkOuuFvSJg7fqTshjs46RBSZEerT51yU53falJmhlaWf+SJuEygINX2Z/5ruAP7poO90bgZRmpGj6wukU/4PfgtrhPk4af6ENuEfcLa5xZ4NsL0dPjNje9Bzh6tP+o5VwGXDP5kjEb7ClJosAxZDL9YQh5ltBgJHlju5L1WnsKtV+AdlrQ3FLG+gp+8Bwat3gwlzb58vZzlShzv+q/H0dZMwwT7DtTIGSa5hBXKvHeL4K+r2dvwr0obPbliVcF3rfppZO/Rpomhn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment in __init_zone_device_page() still uses the old
MEMORY_TYPE_* names and implies that FS_DAX pages regain a
refcount of 1 in the free path. That no longer matches the code.

Update the comment to describe the current policy correctly:
MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free path,
while the remaining ZONE_DEVICE types start from 0 here and raise the
count again when the allocator or driver hands the page out.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
---
 mm/mm_init.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 0f64909e8d20..95808ab5cfdb 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1030,13 +1030,9 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	page->zone_device_data = NULL;
 
 	/*
-	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
-	 * directly to the driver page allocator which will set the page count
-	 * to 1 when allocating the page.
-	 *
-	 * MEMORY_TYPE_GENERIC and MEMORY_TYPE_FS_DAX pages automatically have
-	 * their refcount reset to one whenever they are freed (ie. after
-	 * their refcount drops to 0).
+	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
+	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
+	 * the count again when the allocator or driver hands the page out.
 	 */
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_FS_DAX:
-- 
2.20.1

