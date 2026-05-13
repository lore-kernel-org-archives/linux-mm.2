Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE526CD4F35
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24C5A6B0096; Wed, 13 May 2026 06:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FBA76B0098; Wed, 13 May 2026 06:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EB806B0099; Wed, 13 May 2026 06:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F17A46B0096
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:58:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80CC6120804
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:58:23 +0000 (UTC)
X-FDA: 84762097686.18.13B0B2E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id CBD0C14000D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:58:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CE69JfQI;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778669901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6CFbFFv1siwQ7IMhIlfeqizZ9E/yeguB+EFnxCB9s6o=;
	b=LxTJESAx3vsW4BPwRzGkCz+Z6DKJsEC2yStdNVe/g/Kj72al/C7uYhjDWKC3C5mZoZ1lnB
	SVJ6Pc+nIeeF2Dylx3+/+BEBZv0oni13CCxcjkSwdHpjUXEIsGvZX+KZWWQUU4lYSfwC6x
	HHYP5KNgPSfjyVHGcNi1iHilToxQwz4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CE69JfQI;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778669901; a=rsa-sha256;
	cv=none;
	b=DbzsPcKRpw12uWyk+dOv5Fkv6R3LU2zqcCucJyOISNTjbJLZX4IzvA0Wsz5sURazjetJxq
	43ZPqBuIcoTgx4jeeY3UapfqNnDtrWAc60hjYM+FX29229aMBqN5PLMLcn7Dcc5UJ1qiYH
	sUEtAYTascgCsXI22vENjk9X5fhhmJ4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 819D71655;
	Wed, 13 May 2026 03:58:15 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7F7CE3F7B4;
	Wed, 13 May 2026 03:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778669900; bh=NamPXilA4rJjOKvo9OhmxYnQOChROKpr703f2A0MNL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CE69JfQIYQBEbu15G/3hwUd6A94Vi6U3OZgYwEH3fIYGXOB6hXHTmAVZn517eNaQt
	 0azC9G0CuuL874A8WC3Kuk3SB1PLbFN9Nd41oo/Xc3QKCJU0pPNtp+o2wngGg93l1c
	 N1LhWHOd7Z/DT787YvXTGTmcgY8n8OtAJ50VR88U=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	harry@kernel.org,
	ryabinin.a.a@gmail.com
Cc: Dev Jain <dev.jain@arm.com>,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	kasan-dev@googlegroups.com,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com
Subject: [PATCH 3/3] vmalloc: hw_tags: optimize vmalloc redzoning
Date: Wed, 13 May 2026 16:27:34 +0530
Message-Id: <20260513105734.3380544-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260513105734.3380544-1-dev.jain@arm.com>
References: <20260513105734.3380544-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CBD0C14000D
X-Rspamd-Server: rspam06
X-Stat-Signature: eodu843rsfcxbtdm51mrgg71gwrrpyzt
X-HE-Tag: 1778669901-401287
X-HE-Meta: U2FsdGVkX1+qbulrXfMIpbn6/SGOdZy90V3rDLSuZRU7cjPAUhlH0y4eyY1JYreiqhFn7NrAkue04k6XGgubPJb9TsNrYacA9FKo+EqEt8L4h2VKqjc/ZVy2Y/7SMeDwMoVrUSXM0ZRlYZJrOAqKGI/85Xk7WO1uY+0zw+yYkrkEWLljJ7lWR2cKMtwyZwCIzIcYeUVMW3L6LoenwKppBFaAKj2ySWDB/uuk90+waFHkJmExB5PptSOb8MryzknJPv2fwOPyiPvZXXCy7FFocWpKlbdGcV0+cNS1/5m3GCKAkGrUTHhXa/Z9j9JFzHjeb7ixDBNU4dbav0OuzZcFnrslWHC5exUCmDqWvP5+t01EPMWYTcoTvb3Xn2meMEfdXvW5LwKohdqDLIZTZs2LkP39nGQpd96fPEmgOY7mf3YjRPMrCyZsj53Un1PWIj85rOYU05vOPQ07ibv96dkrLO4vuOB9k/ZG2dXF18IYgF7SF+Qmte+woSSbnbiuK7egDvhyyEW6tKS08pL5Y5hbiu807GCDqHIfDjRhUsF1HQqZyuY0b3vS63lYZFiQQjilTOD/e+v3j1hIvq8UjzIM8foCVYF7QFYDzLWO2zlsnkC4dVO4IYSHKaKsNfNonXj/I4Q9svi03XyueZL0sjY8dO7R2HUYXo+lZK0hozSfcw5ooFxxTjuSrZI0VvU7lVZ7DGZhzCcGlJK15TqECvOsv43qNUMNOqMqYgCY9jFDpSgjuncpLQFfneE9pUcXQvKyNNlLiZZ3xlvPHQlcoNvyez2lflsha51fpa2GLHcNZc1RD9I++E13UuPYZRPGRR3X0RIr3XTrlCqMzh7FPMIdFVrFX6AjYuz/ti91d3rUcaH/VWHoIxqB1dONBbQ18AxM/wfUgjI9tvauyt2AFSgrREscRsBtkgRq0Pt7Y+R0hoQ8GdhiLgWLrr60x383rArSZi/clen0OrQRnqP6xMf
 IzO/MwQ5
 jgI1MGshAluxQNT8nzQriJhkPDtqkEb2X4l0TL7JzOlZQyVD7zvd7GO6dYM3XM7N+MdB5nxyeI1Jr9yBySp47jIFyEvkSh041AM7Vo38/mYPIZd9EVIrK6zklrXYdtDHTTUbu3x6noKVkiVA5usoKTc+fclKOfYO6wDZ5JpKVJPbFI5B8lNsxcPhKNnGSmQIN9XWqss5UU7uv14aywKiqLm0qAHR6r3Fzij6vgMAHgpBp4nzXhTWM4Zx5iLGiEhA4uaj36EwSLJ34n20DTRchyiFO9/XhOxz2ylsMt75AEEWb7bSDfG2x/fWPv3NeUGiun0WgVkf6m0Al4lfKGbosgocrT1oO1+c0GykXGOGbBz77tPM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the allocation size is less than a page, vmalloc first unpoisons the
entire page, then poisons the tail with KASAN_TAG_INVALID (for hw tags),
to catch OOB.

Instead, unpoison the allocation length, and then poison the tail,
saving some work.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/kasan/hw_tags.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index cbef5e450954..7c94f71b5f12 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -364,9 +364,6 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
 	tag = (flags & KASAN_VMALLOC_KEEP_TAG) ? get_tag(start) : kasan_random_tag();
 	start = set_tag(start, tag);
 
-	/* Unpoison and initialize memory up to size. */
-	kasan_unpoison(start, size, flags & KASAN_VMALLOC_INIT);
-
 	/*
 	 * Explicitly poison and initialize the in-page vmalloc() redzone.
 	 * Unlike software KASAN modes, hardware tag-based KASAN doesn't
@@ -375,8 +372,14 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
 	redzone_start = round_up((unsigned long)start + size,
 				 KASAN_GRANULE_SIZE);
 	redzone_size = round_up(redzone_start, PAGE_SIZE) - redzone_start;
-	kasan_poison((void *)redzone_start, redzone_size, KASAN_TAG_INVALID,
-		     flags & KASAN_VMALLOC_INIT);
+
+	/* Unpoison and initialize memory before the redzone. */
+	kasan_unpoison(start, redzone_start - (unsigned long)start,
+		       flags & KASAN_VMALLOC_INIT);
+
+	if (redzone_size)
+		kasan_poison((void *)redzone_start, redzone_size,
+			     KASAN_TAG_INVALID, flags & KASAN_VMALLOC_INIT);
 
 	/*
 	 * Set per-page tag flags to allow accessing physical memory for the
-- 
2.43.0


