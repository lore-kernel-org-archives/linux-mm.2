Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81DADC61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 213996B009F; Tue, 25 Aug 2026 04:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EBAE6B00A0; Tue, 25 Aug 2026 04:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08CE26B00A1; Tue, 25 Aug 2026 04:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA09D6B009F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:49:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25E0A1C18DF
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:20 +0000 (UTC)
X-FDA: 85139167680.29.E27736C
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3992A8000A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GGj2nl2H;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOzdkIPPNoupexe8+AVOrQT3DBRmXPJ6Kybkle+RLi4=;
	b=Wp/oymoB4NQhSd/avgqXfMHkmApNdEkGrUSsP65KTpUUx5rxscCr2waMl8AiyZ9ksmwvTD
	zGPDJhQfH0SH5dtyEpKlFcmVxamNWb3KFhm9Z04eKLbUKRDEqCv5muuRKGvCNl6SIK4vKc
	s6azlMKEa7deKfbiaTz3qsG65+kuEIs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GGj2nl2H;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647758;
	b=JLUCZ8sSwbfbfN6QYgBjkh3UVjwP6kGTrXAT+MnJwaoF+HX5LNJSNS9pIZ44FYRlykbI+0
	hZagpeI8q5i6X1Fq7l0KK9a94q0n+SjDkbWdPO+qo7BBr88LwtPaVpB3vo8Ies8pECy15r
	8Lu6ieXQxinAeFQkotJ3tLqGUekWAYA=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cbedda4c154so2766180a12.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787647757; x=1788252557; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bOzdkIPPNoupexe8+AVOrQT3DBRmXPJ6Kybkle+RLi4=;
        b=GGj2nl2H5nk+VR9l8Qb49KMbGO2aB0aKOwNEzix+FINhbsxLu5Er0A/4sr6hc0lG5Z
         B8goLOL4YVOuRqsfGI5mX5lU3WyqPuvp3MGYYBOvu8Xt0FCviIBoepdAVSeruxFf6UW7
         rFwEVBgZ/uXvOy2yGQiafl3yBNSXr56BWoi0qIBfb14/IaQQf5ceX/rhW+p9RZO+yPWy
         yp6xPc1I7mIs6nk4cZRqHJkBK5IfC3QqkFeiO25JSElwiroZcczU0gnIq5iR9bEySS14
         0eGaB9HN9qIsBkVlYFKmK+Pig6EKIct1Y5yHtJYwyW3vedjcgR9oDIiDXYXIhvylQ18Z
         WwZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647757; x=1788252557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bOzdkIPPNoupexe8+AVOrQT3DBRmXPJ6Kybkle+RLi4=;
        b=r/ljkPwgNTBh2fk/6h5XTpg+gALzFRXRSWO/Ocr78eLb6VtVtaC5AAaCr20s0cKjG/
         2UKpCiyCSRcO4ey5rtHgLIpEtNJPGgUvszO6nos9SED0OyJ14PKiiRFK+N10yOrMFfqV
         a79Ez/Z6uhokUoI+INhM2FCA2sk7a8zAEKW+qB7I5HQRw/wD46s+RazX6ToPaOl+VgYG
         VBubSYkkMFsNrQB9OZc2kbSI/6Yz/k2L6znrF48b3Ch/5/XolfV6HtSFz9eYPeqzdW2e
         gRcEjKRC3HTg9bs2IqdlxN3dGL+tTrdrBTY03KTW9SCTetZ83Fsrz8A0D9ahogDFllIV
         b5dw==
X-Forwarded-Encrypted: i=1; AHgh+RobDFLZIgaSOrKKE4qGK+/t746jCeSrr+iKuq4EDWL/X7ogmz6G/JUNhKNt4XmOy/wKZ2dVQsECOg==@kvack.org
X-Gm-Message-State: AFuF++lolnYmfEkOYdDZg8sadPOpVoSGEedICR4PJporAXt3L4RVaYbU
	HjjmFwQgG892BqzlqzOp3kzkL/5m5BdxLNmmMausDVeepml7fJas3axbEDKBkJGL/Le7FqvSvLY
	8WX5oFfg=
X-Gm-Gg: AR+sD11D9Lw3x17+LPZ4aP5wI2RjZfoY7NkwCC2uUlJHfxhEh3FVSelg+jre2Jjnl5Q
	OL1/USZ2pbSBTe55txdlne0O0reNQDEnFvvJ56uHKn7VDLGUQ+QbcEM7TyBFddMXja5fYJJ8ltB
	LDUjZEy9zNkCK/Mo1DJ/9gOwvN19X9LvPjUb8VHqgHB5CKWmgo5D09WJuz6QtHNAGgoOWuPpab5
	NYnrWgNJVuFKhCp8FBl68fLt4M6Osy04YXxjUuLoYDd1P+DGQR7/oMRIUowuNa+6Z2qYnTGdGjD
	uFD/MNqHthf/Vm4AOCUXqYFIeOsVdOSdTlY9ys+VxVKkJ/B+C/rFaJAkdTM7VTqF8ApYYYvDJPU
	2UzUHDx/z/HHn52205IovlXdDpw+4mvghZWzJwb5wuLscAmGMhRGUeTykXSwWKS9KFEKRfDuhLZ
	6t0n0+KAo9/vjkFuE2kXO2SXAYb42yubXPcVg70VgGfS/KtfvraUli2ERRMYEufdsAWVBRbPrg7
	HDqGIKd/1JCf9gyJ9t7KhAb0A==
X-Received: by 2002:a17:90b:4b0a:b0:38d:ddc2:7ccb with SMTP id 98e67ed59e1d1-396462ff21fmr8688371a91.1.1787647756678;
        Tue, 25 Aug 2026 01:49:16 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm2873386a91.17.2026.08.25.01.49.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 01:49:16 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v5 04/17] mm/sparse-vmemmap: initialize shared tail vmemmap pages on allocation
Date: Tue, 25 Aug 2026 16:45:55 +0800
Message-ID: <20260825084608.47437-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oqe185oesqg9wqabhwjz69wz5ygdneb6
X-Rspamd-Queue-Id: 3992A8000A
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787647758-107790
X-HE-Meta: U2FsdGVkX1+GcFXhHZKQcvAyOl7RQI1ZNRcPVw/YrwnogblxR3y7THVE5tg20QXgvEre40oBH6zLX0fn+m6s/mDao69qBwI1HDCz3oL9nq1f+J7cvwYAYb77ucI4EclotBSfz/XEDKsJjlFuhpNiwlqrX4I7gVAp4HnKckSIpdqYrLF+f8eAC3nmoBt+xOofNY5KN0lf1Hu3W56fAFw4LfJiP78ADDhnLdGeI/xJrU5Q/IJ33rpa1WR0Pe8wg7BzwBwLP4hl5fCwUWEZXWWTM51kUMqAAsIWUcGJf61FmA90B7HdO2tHzIHbxUmDw6qMITC0V9jAbVggWGR4el37s61EuOYNqKTBb9Y/jInfvG64q5H1C4Abj3uU+GGyfo1iossWQkzB7JiuGew7U//vBDT1S3L5CxAtdjFk2o+ioiLzVXhNgjO4qTeOIoAln5zUXF18Gn5npJPqQ3hkwEb/qPJBAqptK9MDRa999abXouVGZMZTLESqRGtRRINLJMwS4Vjg79ox0KlcvGvUc6sSXmtslUc4KOKI4jdZgc9ZqU0+k8aRhbZN9Reo688YwMiJrhAh6LtQYYUlgCxGVxbGfDcedVdOkVz3+h6fJbO5kznzm2De0wFX5ksICR+yy5tpaPD9WIRjr1U2jpjTjNU12TjiOxFebMFzHJB7/qNMSryb8ttvzwgB6ggeEur5oPdbBh26uMe6yNxc2oXAW5sIVEjgRfNh0weT2X1LSmK83B6LXgQpwrKBGZISf7vo/h0bY5zKk0o8FaMIDwGAyFa+cTm0zdpki8UACyxAWs+hemCGG9ENCjjRmuN5kFmE4UIym2QMJpaHKEZGER1aKLHlNiYawZLcf89jWJwD4ptVaqSZXEOu1S51L+X+iMWVDCi56Z8M/bijqoK6LKZYqB6TgH5x/ofT/qpB5XzRo8DjWEstP1mrB2dUf32uXHiAIavRMhRWSHEV3EFPSO0HOj8
 +IkyD7am
 MrDtxmvVwJz52ll9ANiksIaOZShxt32Ik/1Ad+7RevA571YW+AdBNsHf7Vud6aF76BXqqCdAOjpNPefdlG6ZiI35jm9vNVH7OrYIt46oeEDYR16bQPEFkEsjbjAZYcirPRn3b2ls5kzSEh4DjfK0GcWHVV13m5ecOxE+BgRzTTalwbLwnT/nHcy6SOvOuWIGkHTE1oj8/9XgWp+LJ8aLbZJuOYkw2prQmtt0yVjs/JtPQmF1a83HgfXFG6bvYiuYXrBP79Hk2y7gWZw3wA9Mgwoch3LjAtHcCs3IMAfC7muCiKtXKm7AjExA6uxbtm8YZA3gfIxCajRZXBOavQuYgE3HzENllN/7B3fRzsaJ+64uNtFYoKrAU8aI17oSF4RlSMyIE+45IHGDOJFGaYQCt4Cjye9XZEmobETOlflN9ysydjKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The shared tail vmemmap page allocated in vmemmap_get_tail() used to be
left uninitialized, because memmap_init_range() would later overwrite
it.  That forced users such as HugeTLB to defer the initialization to
their own setup paths.

Now that memmap_init_range() skips shared tail vmemmap pages, initialize
them immediately in vmemmap_get_tail() with init_compound_tail()
instead.

This moves the initialization to the point where the shared tail page is
allocated and avoids relying on deferred handling in individual users.
The remaining deferred initialization in HugeTLB will be removed once it
switches to the section-based vmemmap optimization mechanism.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index aa6a4a2fae98..107215cf8488 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -338,19 +338,11 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	tail = zone->vmemmap_tails[idx];
 	if (tail)
 		return tail;
-
-	/*
-	 * Only allocate the page, but do not initialize it.
-	 *
-	 * Any initialization done here will be overwritten by memmap_init().
-	 *
-	 * hugetlb_bootmem_struct_page_init() will take care of initialization
-	 * after memmap_init().
-	 */
-
 	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
 	if (!p)
 		return NULL;
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		init_compound_tail(p + i, NULL, order, zone);
 
 	tail = virt_to_page(p);
 	zone->vmemmap_tails[idx] = tail;
-- 
2.54.0


