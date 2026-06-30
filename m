Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12F4BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E254B6B00E0; Tue, 30 Jun 2026 12:42:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFCF66B00E2; Tue, 30 Jun 2026 12:42:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF1566B00E3; Tue, 30 Jun 2026 12:42:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A85D06B00E0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:42:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A2A31C3033
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:42:14 +0000 (UTC)
X-FDA: 84937146588.07.87C85DF
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9A1492000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:42:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E8ia5HiL;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782837732;
	b=QBK13wy7S7otn1M3mrBcWgnwMlP+50KsxQ7oy8vDHT37M3PFRRz862/fqcrMcnDPGLjD0r
	S1z4QDAJI34qobxN88BjzOtYOKbrtIWZuZLSAnm0anlEDIH/fJXSCzSHpfDybOY3sojOUa
	5rF55KBWB7TzKzW7W8zshJ2q6rSsKF8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782837732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GlJpjMuO37BV4xqHjelK/xNiN4sNUJhoBu4u+tTYaUo=;
	b=KlZPjxXZQf75fbsMThzflmKfpUmh7r6E/E6wKXoWr4qXnMwRTCgiVRevrkqq0IRupjJLPt
	qrEOC/jv25UBXw9H7h4xs4MjJPhx7bjitPqkOYQJG7nzEuByTbgqOEmX9f2fL0OvJrpIt1
	G2SVug0CPop38EQJYBHO6BMpFJmtuKw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E8ia5HiL;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782837731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GlJpjMuO37BV4xqHjelK/xNiN4sNUJhoBu4u+tTYaUo=;
	b=E8ia5HiLQ0kR/mnyKqWU6cH2m4PzzUR4qMIHIc/lHk3ZW0srqGR/NltcHB/bMcQPiB84iw
	gCZxOJtbL8SFg8sS7Pf9zYfbFmypnEf8Xr25i52v6bkB0VMhGqjrSHBuahdsBY5XanEum2
	vSlyXvYbXB7C5d1Rapmj8685O2V5jNA=
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
Subject: [PATCH 4/6] mm/huge_memory: move softleaf_to_folio() inside migration branch
Date: Tue, 30 Jun 2026 09:34:41 -0700
Message-ID: <20260630164143.1595669-5-usama.arif@linux.dev>
In-Reply-To: <20260630164143.1595669-1-usama.arif@linux.dev>
References: <20260630164143.1595669-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3r5fm4t34ygsos6qshsanf7mjq5fpo13
X-Rspamd-Queue-Id: 9A1492000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782837732-749265
X-HE-Meta: U2FsdGVkX1/fJjmXNzOTW/cr5PoVbsV0QvtqgRjqWylI+DmhVtXPIcUgdMPDAP/0dbnNjSvBxC0Z311oEJXizphkjoWLPYeSOHp1GNubEzeFOZRQx9QT6cAOGOX+YjvZdrpUKcWfRnu/zctg0JGbEVuCErLasKlk08IflXBvKvJzKjJeVXEsTG7HBuUr2NxYvldMbPkqbEDlUSVGVrounKyYmBtXAvFMv8Tm5sdFheD1pkXM0DqY9OgtLPuljHAsF9g3BoGIc3G3sCijFkuZbKR5DLSsVyUglIh2RnUJOkGEpgWBZ2Sa+sjCWspXjH0LK/3B58+BLiQGcYAafhu28KMW8+3/UhzFw0esWPi4DCOb/9STX6uCc72dSnlRTlfCNps8270fy+nAHs71Fg5xjwOUzSOUZEtBOpKnA0QaWBJvZKS9JEOmUPi1IStOWg81HCQA+xMaw4/K6DLqwAYsXItzeV20lhg5C9xdNjxxLQdKka7w2s66/N1znx9ZLx4JdoFd181E5Fl2azVKOtmwU2MfZOPPq7zJgEJgYX/OYqXTDMgfyA9fTjfj+kIj0nwrqB9WfIrxu8a9eWAT9yOL6xJh3x3UcOrvt0VImlO9qB15G/bcDerrKsPZlnyK49ntgUKAqx5TNHCjAGkd1luxTxTL8u9WpkeZAFpQ/iRTVTtSf3TTq93Bt+1HGDrbVT8pxYrPgpaOVw8PVEANulS+BBXyfE0zwMoTfhNJ+qpiw7HGWxjQTSMVH87TIqUVR0fCqV2oote+DxE5QVZe0s6ZPgsXUVWbQpFRlZYTFOPd+ZRsiBXkS0qYSCBaV403ziWL3UdAvaxp53Zyhs6VulCEnK+rC/+tM/F7/os8K+wVPcbGcZnmsm7+OCRnvvB6nUMCcxqu8Yt3e6uyE/WZtMaJNBdVI/qL0+wGNGfHOx+3mPUZ+h6TfWxP/8F9XYEsh9PM118tKNMrvRVAMSTB5L/
 F7xX193Z
 jOKv77g1zpSfwICepgvWpy2jKxAwkQ67T1cXFK5qksjVKMXIQmLR0k09r6BUeT/E4BB6yXQg68RGCl0xreu1o0+Uy03wJtINfD5xywNgHZU+Mjaws1IOu3v5flQlnVzRMTP264w0H1BZvtREjb7RyLpbWSFCsc2f0Fm+Y4Af9jOjzFMyxxe45T5jDy+OiSVIXFm7fuXwoHg+vDH6mhi6Qd8XKx615xigmmNQ5Gf6REdP8bsWnLQjlXSUNUY+Bhx1dE1nR730IHHZdmvCHYzdFUo0SHdfylpvPDWQm+1AP1kDyiK8cvYFUdNVNki4VNzeqDfnkZUotmE0XMzguUCc0s0oZJrhxOVA273T/pGVTcuHY3lM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

change_non_present_huge_pmd() calls softleaf_to_folio() unconditionally
at the top of the function.  softleaf_to_folio() extracts a PFN from
the entry and converts it to a folio pointer, which is only meaningful
for migration and device_private entries that encode a real PFN.

A swap entry encodes a swap offset instead, so softleaf_to_folio()
would produce a bogus pointer and crash on mprotect() when a PMD swap
entry is present.

Move the call into the migration_write branch where the folio is
actually used, so the function is safe for any non-present PMD type.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d51f53cfbe4f..4aca9cdff73f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2557,11 +2557,12 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
 		bool uffd_wp_resolve)
 {
 	softleaf_t entry = softleaf_from_pmd(*pmd);
-	const struct folio *folio = softleaf_to_folio(entry);
 	pmd_t newpmd;
 
 	VM_WARN_ON(!pmd_is_valid_softleaf(*pmd));
 	if (softleaf_is_migration_write(entry)) {
+		const struct folio *folio = softleaf_to_folio(entry);
+
 		/*
 		 * A protection check is difficult so
 		 * just be safe and disable write
-- 
2.53.0-Meta


