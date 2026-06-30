Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89E1CC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461336B00E4; Tue, 30 Jun 2026 12:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411EF6B00E8; Tue, 30 Jun 2026 12:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 328526B00E9; Tue, 30 Jun 2026 12:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0232F6B00E4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:42:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A1B5120591
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:42:19 +0000 (UTC)
X-FDA: 84937146798.16.FAD4017
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id D392E40003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:42:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J1E0HIIY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782837737;
	b=mfsZ+NfbQGgD6Hn+WHtsm6SlJEJAvYXYHO89LWqSIrsaInFjN7uxfv23XuM0y2+0+9Q7vJ
	uVUIDgnrYUAjmKcu2M7Ep6WpOua+u3D39EQ3XYX4xZ8hNO+BJRiw3v/QMxFruV5t5Bhue+
	AVQy//5GofSAG3Clc9BlqW4SXXYmrAI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782837737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E2Pk/YCQISKEKdqI9CNpA/Beuyy69gT72eUl6QsyWiU=;
	b=l4uuI0Rr25Jb9rmwive6ZjLF/ocjZqlc67ZXDgtL8PjhJxUQgGWIO3XL+/bx6xKGVfu4cE
	o4l+RSCdhLnXTXFDhYs7cNUu0f+g2EpM4HE0YBDfFBKWM2TliT1LO7YGEgPuZqaf4ntUXE
	dddzqTgmTZQ6TXlB0XKWHOyztlA7Eds=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J1E0HIIY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782837736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E2Pk/YCQISKEKdqI9CNpA/Beuyy69gT72eUl6QsyWiU=;
	b=J1E0HIIYwzeaqNOLpdX4zMrxhsmAH4NXqDG3z5dmjWirr3YeASvm/KTaUUekh/nzw3yXWJ
	PXiO7fkOHZKM6Yl3vXsTWOlp8BeG2lftBwrYN9q6kVMGSXYPbep0CGLx8WjOqXhyQuGWsh
	qBCYxBg4l/TAI72OyaFGy3ysQB464Q8=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 5/6] mm/migrate_device: move softleaf_to_folio() inside device-private branch
Date: Tue, 30 Jun 2026 09:34:42 -0700
Message-ID: <20260630164143.1595669-6-usama.arif@linux.dev>
In-Reply-To: <20260630164143.1595669-1-usama.arif@linux.dev>
References: <20260630164143.1595669-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D392E40003
X-Rspam-User: 
X-Stat-Signature: iazfrzznc1q9yb8om91fhcibxdgcf16k
X-HE-Tag: 1782837737-704243
X-HE-Meta: U2FsdGVkX1/tFNG4hcmZNnCBPF6T9hb8WwYUarF/k7zSZUtk3njUJMbsBoEFNG6hB4TMCmzgS4wJE4a3f6sRJKpTaM2qHTq0Nft3kvPZ9isYhcOtN1ZiESQKpmr5yZIYHEwmtzQxj9YdvXd+eHV7Cz8nkDU/ApnAns9AIpXNGIzIjdy6eANWiyX2MYEgyXl7NYOXwyGcGPIhMKFGMGLtSmAmyZE6QCDDoOK2GxcnSXd8vjJUJxEwR/4qFZwwHbbdTiPWUbwdssBIvh/axfQCO/MzXYMmE/U7wGPGzaF3uyeVukyIBN3EzlwrWIVaJMfZB9z8QBUJDjihI5CQ+nzf+5H+ZRm3QwouZ+GztiHWW2MwlxBZTgX7ptjG2VVVqfeL/MO7D0q6XXgS00fu6LukQSNzrYWPRJFq36yNBKljRlzyRVtEWUk7edInE06xRoWyRjtGtVn/CuC6KK+YwLG22JXk4DbVU9WvzIf2WKXEuemzHrkdYVHGBdF4rWqdLJUilZv7rmoWkSnyIopwYmrbED90mSfOkjNDQVIc6bph1NW4uEddMaNYCFJrMA7rEGAN7jNenkQBerJwZFI3q/+oVkpdscM50VJkmS6IS9h+g6lK3vl52X4s0iWitScb4dgE5LmPKQ4ppXn2KpluXGoVQ/cCiqWoCIiJ2IvRL6XLh31TxsP8DYyfD0Uv47YPUfmW8DF9pwUuF6LDu7dIcOlJEf7q9qzd5eNTOZMwtzSE6+iogbkcNQPB7iXfujstBR0gcLZPQrJ0p5m4oLnQq5sv00u/CpgL0l7TzqFqeigDsK5NXhkZyR8giQzCLi4ReNQXDnb1YN2iqWodXoJ8k3MzzEMrIKpZhb4zYIvC6p6mt7LyW4s3OlMRL+aWE0TA5kt0BMpkX4sz27sqUhq4inJBod4UlfDWoCvJLthvVUdKtqo37wwUnVsatxhhPShYuEOtKAehWBujkCLexYbbksP
 Zan+w7L8
 GfUNFanG2Wgm478CShJV06kxE3zCVq3PlW+dkEusWl8x5do9ejR8j9i2uXdxHevmM/Q6cr2zRUI70NDVVp9Xb2QYjOFSTdeOaaoIvmwjVTEtD0EyJr7a53dSsdWTUziS96II1oPd8+aGH+XzJQb8hrXa6XnQiHw9oRuUCHpWYQMeDOSqmroM0NrtiTZdn6dumPhL1tihyIOKNL0yvH4lQOpehmsDE/j6WR+V+P+kS6Z5fwFkQwpcDxU5lvt1zK8Nknfs9DIGgqTiNhZ8cnA8Jh4sGFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

migrate_vma_collect_pmd() calls softleaf_to_folio() on a non-present
PMD before checking the entry's type.  softleaf_to_folio() converts
the entry's offset to a PFN, which is only meaningful for migration
or device-private entries.

A PMD swap entry's offset is a swap offset, not a PFN, so the
lookup would either return a bogus folio pointer or trip pfn_to_page
validation on a debug kernel.  In the non-device-private path the
returned folio is then unused (the OR short-circuits to
migrate_vma_collect_skip()), but the lookup itself is already
unsafe.

Move the softleaf_to_folio() call inside the device-private branch
where the folio is actually needed, mirroring the equivalent
change_non_present_huge_pmd() fix.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/migrate_device.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index aa948db49501..36287e958b2a 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -166,11 +166,14 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
 	} else if (!pmd_present(*pmdp)) {
 		const softleaf_t entry = softleaf_from_pmd(*pmdp);
 
-		folio = softleaf_to_folio(entry);
-
 		if (!softleaf_is_device_private(entry) ||
-			!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
-			(folio->pgmap->owner != migrate->pgmap_owner)) {
+		    !(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE)) {
+			spin_unlock(ptl);
+			return migrate_vma_collect_skip(start, end, walk);
+		}
+
+		folio = softleaf_to_folio(entry);
+		if (folio->pgmap->owner != migrate->pgmap_owner) {
 			spin_unlock(ptl);
 			return migrate_vma_collect_skip(start, end, walk);
 		}
-- 
2.53.0-Meta


