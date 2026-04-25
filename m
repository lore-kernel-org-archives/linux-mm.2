Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAD5CFF8860
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 13:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD646B0005; Sat, 25 Apr 2026 09:45:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AE426B008A; Sat, 25 Apr 2026 09:45:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09D8A6B008C; Sat, 25 Apr 2026 09:45:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E701A6B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:45:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97B571B75F6
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 13:45:06 +0000 (UTC)
X-FDA: 84697199412.14.F4BA307
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id BB62AC000B
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 13:45:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eqsAIYRv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777124704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GZa8V4V+L1cbe14Qji0FuVA6E1esCIns+Fs7vnMJGGM=;
	b=AqawxbN5SZQ+y6c0Z+Y4lZbvRx/AhepIFIhE2Bfkz2ki1h3iiH9IWn3YdwuZF+LHPdlbrG
	pVSIXvCx+4WUNJD4Bpr9cpgmhYWjNypxQ0Xmaa/CKuXN4WBro4hOHC2TYwQZXtzpDVUIHs
	Y0EpWWpRk3R9QTZWZOO5j+fX3shSD3A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777124704; a=rsa-sha256;
	cv=none;
	b=m1jqD/4O6TUMgzNfvFSb6JSI9ElNJqj2zK98WcrKqOFYxP8heOek6/LqDnRCBuo1qwBq9f
	zjLA607AaFAKq9UIO+EMB8X93q7X8sAdTGzBqRYApIxK/37s3zOOiOz1RayMm4JnOcVwrT
	8G6bOit+suZsq6htxChbqqq5g0o5eoo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eqsAIYRv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c7973bbc16dso5763120a12.0
        for <linux-mm@kvack.org>; Sat, 25 Apr 2026 06:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777124703; x=1777729503; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GZa8V4V+L1cbe14Qji0FuVA6E1esCIns+Fs7vnMJGGM=;
        b=eqsAIYRvmKW/qlIkpJMto4aUkUVMcGyPA7X/R5+uWdMMHijhJPWWFb3MP9YjDbDHIF
         ojIxZ7FFI7E4dxdKiZjV7l0hgkLCbt2BatcJBwR3DiJ1YAWHhgNP6uM1EtngC0KZQ5cG
         i8OHHBm6+5EbyQFYr6hoM+0UgCiUd6lrxOv+7NebVh+kZpO8qRZ8IVrB2lWhRagB2ild
         DqXihqhrHHzYoS+xd3/YjXoRlNGwKES3eIsZHENtt8b7uOQEWBq7PcHXOuSt+RAzk9eS
         UD4qVciiq5r2IkkJJ0p6wCh1+8w4CUjyBy8agWWORKJSTnw7Ech/t/FyLVPtFdJ50yGG
         H2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777124703; x=1777729503;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GZa8V4V+L1cbe14Qji0FuVA6E1esCIns+Fs7vnMJGGM=;
        b=ZZh60H9HeccVsYPAC3nnfpXG1yIi8YKVe6yGXyIwxhAIW3t8ofRmldmZ8UfOf68/8i
         wgbI9Gq1+8MMplxLVV8aSQb7CcCGntA0pQ6405Qut6KO7QfEX5zOrbCeFkaQlJ6xNaxP
         I1Rei1vGW+F/7gyuk6Dthnu3a6HGSsi1lh1hUgt27Cl+pIW1mtQfgjKBr0wgjwsVJGLW
         xC/yDcJQQhQMxe4ov1ij57j7P47ggY3ls7R78lDr78AfBzrxU2IdqojF/NXhTX0Hfwd3
         BPYzENctzS9xsjdroowwDLCFuRQirhyIWkLZuzyixcC5vk16qaJHmLr5RzGqRoc8K1Ye
         l+GQ==
X-Forwarded-Encrypted: i=1; AFNElJ9pPuUKWat6N3XfpykdGm3q3Ll7XpS4C8b1O6wg1Ui/h8pyxf36etAJ4m3D6H948wccnCOCvsuHcg==@kvack.org
X-Gm-Message-State: AOJu0Yyj8h/AlecveWF3u5KtAdhwR+NWkUzz7+UxEkZ+nYLsjknWrg9H
	RyZn9ompTWKy09y+Alt4tZtezpAZVVozMp8QR+9EO6VYU5Pr8ww8C7o3
X-Gm-Gg: AeBDiet8MgSKoSkEw1wkknmQ+pfnlzy9ynYn4GUl0EbHcAlyvpFHpOh/42U1LD6zEFv
	XIU+RXiFAG3JKZqq/qF4pOxC5VlhWKz41KO2LtMe4JtShWS2pZTD6b+UDslb3QzFBkjiKktZXSL
	OLCD8HlNg7AKOB8Gn7J6N/PRqadNZZ3zRyM4k9BrpCH9pb8wSCVDJdpPmYBVTub/2eaksbwVYTX
	rKDQpE+fubU4KB1cdvvvutfuZd8194Dh+Adj0mXp1LeQmDpXDHVXl0x/m4ShA49Q09j4Vv19nBY
	SsSn4hyLXTQ9b6j0CTeErAu06VQAzA9xix9Zv4jXOXoRMzwfJEeWjmgum605m2x5OfSYXBQC5PX
	x0V4ietoY289Gtlipp16QrIoyUsbp2njeFSSnAlXVUZa6wC/CSSohpMOeljlJpwq+iIFkNPt8be
	NMQkONwZ0LRBT4ouN1VRleKg6jTbXRx6GSzZ4oKp+98J2KtKn/itrqlKzY
X-Received: by 2002:a17:902:690a:b0:2b2:50bd:83b3 with SMTP id d9443c01a7336-2b5f9e8196fmr273111755ad.10.1777124703464;
        Sat, 25 Apr 2026 06:45:03 -0700 (PDT)
Received: from tech-Alienware-m15-R6.. ([122.171.21.105])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fa9fedf0sm310473435ad.6.2026.04.25.06.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2026 06:45:03 -0700 (PDT)
From: Sunny Patel <nueralspacetech@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sunny Patel <nueralspacetech@gmail.com>
Subject: [PATCH] mm/migrate_device: fix pgtable leak in migrate_vma_insert_huge_pmd_page
Date: Sat, 25 Apr 2026 19:14:48 +0530
Message-ID: <20260425134453.23769-1-nueralspacetech@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BB62AC000B
X-Rspamd-Server: rspam04
X-Stat-Signature: doameskrif6rpwi3kjjw3xkxib44qzmh
X-HE-Tag: 1777124704-490148
X-HE-Meta: U2FsdGVkX1841CAOVupMvp4OUBbkDhB39mV87Rsg1EAShXmJs6A5Oy9hgmNY1gvKFOOJiiJuTC2lQfDr+OVdmh9b9oOv3lq71822iGsq8Me0QR6Zxm7tZioTkpjyCds4XcqS1PCfVu1CfQe5b5tVfn6ZbRnuzDSpRpZnUePPtLCyyxCQYTQnbSEvrsS3UW/h+jU4uVaFmMWJKhhdKJlC+S6C0M6ts+NtTolX+66CpcS/I60HtKdIo2kvc2+89xbFplq00J97XCZsuQ8x41CK4fXfs6AXpqQZba5xJ7K+uUVuPvblb+UVGCuXgMP3GrQ8KZFgUcC36Ljdc1FJ+Fa6bllXPOirvhMvc+J7AMJQI9EvM+Zyhsyargw96z/zXH3S7bFA/EQQfaRkU92F7eGnD2NkTW9fpMv7lZacEjOF80PLTrM4OUwNohn+5vjhKMMyH2UXcccx30a5ANooeGyCQ/OVGXqeugbwWCKqew8JfeElKav3J+gr/GUiN1djXDJD7De9CKOq5zVlcKUvQrviaH4WwIpXI/DMkIFaOePWwmx0me3uAJhr+KmDZM2lLLizdDxySO/PdUBsgrTPosJXvWZgAkLP4P2ghtOjAO+AOTjQ9Q46MQs6GfgSGMmphBaKTyKNFvcwLRTY5XHfkjueTZtmbz9eT6baDQXJBJtlK6rAkpm6vcoYna1ge/wh33cyI/29Qyi3GCTpeBAk9LDmLcO9ktiXmk7IaQQ1Ed3Pnu2K5cu/vgmxaXjee+uOszLDabrXSp3zFEeKpHJO5+pUFMzKZ01g4EzuaMgnVe9zSLS1hDW5L2oI+OTH4WC4+v71/eAJRTjHh2wCtwvB/LNGinHVFMboSjmcPbl/Aia9rfJCjvi3zb2Y8bwu6UWW+aHa6kTDhiolvrMkAmVbzOD/tMI6eb9mp9HpQYRJB7+eOn6AkSIPmtoFVxdiKF18TNDK/ncAhiC7paDYMyIcoPp
 uj7Dvb5o
 qgg3dl5qq9gnH5gHLYoec+z6xr6xheTU0v2FhvSJfrzBFN3fUFRS1gB2qc58ueLQeAV93wYDt/MQwP0UX0KQdA/F8iiriae9TSlH667IHFFMR4TzZoE1YWpJFsR8uXBrvt9ad181eEXiKrViADyQmeQE36WobLAXhTeg5V5WQCe0n2Bo0g56YDPKgMAu48LUPWdBJtyh/f8bzfjG4tBAPx/JGOnO9RgRxXWotBqv0CWpARfUArVrUiucVKTRw09W1tI0CyxGmGxMWsOTBV6AJkNs+XnxIIFxYGHqF4fY+5pcUqiDxHdfUD4FFQ2cpazTvM3MY0ePc0LZK+B+ptJ5rSGS+J/FQFjQjU5Pyry3MwIiNn4EgCjVugQIuIbbFhp1GCV8JEH420R3HfBy29srJdS4C1uXnNNZRtHjWfgPuU2XTUfQe3d6Ycaqb0p9W9NYLKbtSEd5NMLc19ctQQyzprK6AdW4ssyNCsCCbIlMn2XeDpNHyOE6mq6rh1UXWHKrtcSjAIkiUqt1w8XbxmAZrHgRbHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When migrate_vma_insert_huge_pmd_page() jumps to unlock_abort due
to a PMD check failure, the pgtable allocated earlier via
pte_alloc_one() is never freed, causing a memory leak.

Add a pte_free() call in the unlock_abort error path to release
the pgtable before returning.

Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
---
 mm/migrate_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index fbfe5715f635..457bab5c7c31 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -893,6 +893,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 
 unlock_abort:
 	spin_unlock(ptl);
+	pte_free(vma->vm_mm, pgtable);
 abort:
 	for (i = 0; i < HPAGE_PMD_NR; i++)
 		src[i] &= ~MIGRATE_PFN_MIGRATE;
-- 
2.43.0


