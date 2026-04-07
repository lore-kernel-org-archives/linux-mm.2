Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C144EDB7DF
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 10:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30D66B0088; Tue,  7 Apr 2026 06:03:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1BC6B0089; Tue,  7 Apr 2026 06:03:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6F16B008A; Tue,  7 Apr 2026 06:03:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AB5D6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:03:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 133B15A7CF
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:03:35 +0000 (UTC)
X-FDA: 84631322790.01.44B1927
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id D0E47180004
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:03:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o86HUI89;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775556213; a=rsa-sha256;
	cv=none;
	b=hvJgknOMxZiXW7cWdrjUOkDJOmo+aYs5Eml6iCC6alVxP3czHb/9aa3n2Kir77uW+yN8BI
	0XCTjKzR4OOREPEmY5iJG9gPA7E/X8XaMjN82IkyZn3mQv+awh++7oQnc4I8fxPnosiQJw
	XPxUYD4p66GCUFQcQsCtFPGCQYSUAT8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775556213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=W1wNHcMUrRgAHGDgB1gxeB7wyCO1ksdZstgGcDHOw4s=;
	b=jnGCitCHHVunnlhL74IaKyQXmkgxDU264niP3EG6zMveJrb2k22Pla+HKOjvzwdOw4wKNZ
	xeaQ7GDIXoxjw9t41/1w9N944em1awTm57l8dE9LHxpCVFVhQP1bqwCK7BLr+YrLRi923b
	7wn4KHmFynT9Nx/CTQ9pIycmo5+uGXk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o86HUI89;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775556209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=W1wNHcMUrRgAHGDgB1gxeB7wyCO1ksdZstgGcDHOw4s=;
	b=o86HUI89rg9hZA8LmXsYQrcEWivSI5WRZ/OsQ0xO91mzlyje11mdqSIYxCnN++b55PyQ1p
	kcKFvOOH0GhCvfau4cakCw2kJiKDC2Xgr2nnbJyrtYG6kj4H4G31vtDokYAoYRGKujRtFf
	ro36EdB0eXrse9AoxOs4SkjhmxuJYng=
From: Hao Li <hao.li@linux.dev>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH v2] slub: clarify kmem_cache_refill_sheaf() comments
Date: Tue,  7 Apr 2026 17:59:10 +0800
Message-ID: <20260407100255.40035-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D0E47180004
X-Stat-Signature: da6xmte94sgie53e4hwmqgoszifyt16c
X-HE-Tag: 1775556211-427759
X-HE-Meta: U2FsdGVkX18yQUXz25bab3MdZx/M3Udf/ToX1Wn39njp1R6EA2YA4iVtWPjlS3JnqScSmVDJEqT8RkeyG7zArSHiv8GkOFB4rYx5+qja+WPCyosF2OVs6DSZb4fwH3zPdSLp5dd+2mfpUnfn8Qkg8d266ciIP6K2C/23hEakZYO0M+gJOyPeFjWLSvTrma2SmZ4VLMVSdt12sGINaEPEfz4YrFlmvbCH92s1il1kG9ZLG0JqHzKiIwnB8mDoc5F52CCfQlm7Tzoh/AtjIflikB6t5qQ8lmCYgrK/rYk9BhpsD0t6tFfP7KcpQ9IKjz+iDgR/smsIRQYcZZcMaJnAFpWtUkZ0QKfvEGOVy0a/xMNK0C37FW4XpC/kGJdri8L5wXjghm8nVOS8yajIKXxOFB9xVr/ltG+OXjp0PXsleNlInQuXxiGfsax4Cou5cYHK4YXxf9Us7SdC6J8IEjGKUzjwbEgC3gfdKKjE415pg0lWizHSV6WtNqqOr2NPERv9P3uHIPSSm1rfyCxdGPAZzQuWOoWv7cMQQxV/Vug0K0/IBkBEB7w+50XyR+6LvJ2yZxLH1QHZdce8uX7ey7l0lrz+QkfwtaLDxD8upcEsmafYK9odlsiXnfk+GP+8G3obSpryl1+twqpg1K/nhSZyTMG4PpuHcArL1KKS4y4vnR4AMQw/TFZCmU9zGGj1fQbqdtFEhnTuNWjGAFQcMxub9nurdkJJQH660ANjD7APt4CAa5zkwKCVD3SxzZx0KWaRRBLrXKf7Upn60+1gpKoTDSxkhwnMTcjYhAUTVSS4E/aItJvtjbqatnR2M5AjUGsCBgv07RMt4j0myQwQG8iqwVYvwt4weEEmBoX6qvWERJ4CW8tQ57KqHYyjaNxVC71Qs5mEf5P6A0KEnLtWiKN7k+i+sXmGQxXlsgoOWit51OArFr6cdvtHP1CqwS8tSWZ1dj5j0baAUHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the in-place refill case, some objects may already have been added
before the function returns -ENOMEM.
Clarify this behavior and polish the rest of the comment for readability.

Signed-off-by: Hao Li <hao.li@linux.dev>
---
Thanks Harry for suggestions on v1!
---
 mm/slub.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 4927407c9699..a45eb1bd2ce5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5120,12 +5120,15 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 }
 
 /*
- * refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
- * the given size
+ * Refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
+ * the given size.
  *
- * the sheaf might be replaced by a new one when requesting more than
- * s->sheaf_capacity objects if such replacement is necessary, but the refill
- * fails (returning -ENOMEM), the existing sheaf is left intact
+ * Return: 0 on success. The sheaf will contain at least @size objects.
+ * The sheaf might be replaced with a new one if more than sheaf->capacity
+ * objects are requested.
+ *
+ * Return: -ENOMEM on failure. The refill might partially fill the existing
+ * sheaf or leave it unchanged, but it will not replace the existing sheaf.
  *
  * In practice we always refill to full sheaf's capacity.
  */
-- 
2.50.1


