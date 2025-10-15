Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D02D0CCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 17:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20FF68E005F; Wed, 15 Oct 2025 13:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199D08E0005; Wed, 15 Oct 2025 13:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060B68E005F; Wed, 15 Oct 2025 13:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1F8A8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:50:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84A55140247
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:50:57 +0000 (UTC)
X-FDA: 84001089354.24.ACA51F3
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id AE88380007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:50:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iCNwfYXO;
	spf=pass (imf02.hostedemail.com: domain of manish1588@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=manish1588@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760550655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Bhhd94uikYZ0M57TCKhsGF3XmQPdd62RUy7Czm1T+JY=;
	b=jtukb2qyKlScgzeyLqVHePlurlDd9nw5DiQpyBJspVYifsZhBFv7gA6K7e+5vp4R9t5X8c
	xDg+N4XrD4KZras268dD6T1wA/qffJZSl2NScluy50VGbWi5yqhl91OSLny7/SF+z/ZC6c
	/13DMVYv9A+QbRPClFZ5sDzLERTPI+c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iCNwfYXO;
	spf=pass (imf02.hostedemail.com: domain of manish1588@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=manish1588@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760550655; a=rsa-sha256;
	cv=none;
	b=8N8h7YnErPjK5DQANOntg7UIPfNf2FGUoUlVyJuyrwUCQUAJI/VBKHXD1CauSq0V+LCKsh
	NYzpDEVdB2i7b3SnrUr3cahZCuxGhe5uBYLtCJPnMraiQePLUVO/t6XzSYQEjsASpFhh7D
	phxGwYWF7V+Ictkff5pmHI25m1ZltLc=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-789fb76b466so6310222b3a.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760550654; x=1761155454; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Bhhd94uikYZ0M57TCKhsGF3XmQPdd62RUy7Czm1T+JY=;
        b=iCNwfYXOCZ3ZkSQMyfft3QQQ9nayOD/q3VHTWYpvjI/EfIAxPxvEl3NC5ZDRfaxii6
         nXrET6fQdZ8p8IHOyekE7gzq7u+0lov/j9OLn17KX/0qjSJdq68tZriwyTimK1mwf/Nq
         5xMGqBYPSXX5ieHHShnXxZjSYjY7FW3l8RCxdqm2Lwo69VK5ACErEofgQpwM9Jhe6QQa
         MGsUWe87NcNxBtvmm7xXLl9bKydnNunODNPmyFF5kcV/LZDmAdXcnolJw1cNbcfwwtwr
         7ariGyt9Q8wMYI4zlgkNXFV/ciySQLY2UqbPoMooAyI9F4FpBd0+MxIakZDiTuMXI2hp
         nVjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760550654; x=1761155454;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bhhd94uikYZ0M57TCKhsGF3XmQPdd62RUy7Czm1T+JY=;
        b=aLNZ585S1dRgvzstVe/pkKsuUfkwUqW/WBGJ/yBciNkRbRN2fNYB+V8VpXVkTdDh9K
         ZLv9PPqox3+xKqvqg7iG7yP7t17FmRqkHFNFWptgOJMS9LSHQY/VptKOJSP/6WiS1wSN
         rLDwpmy8bDw0oiADoVlcM/GOgafNPguxSkuPRsoAGbA+F+BIYQ5AJUNpQvnwcczniDS1
         zeWYNghB3cxRtKI/K/6ut/4h7HH2N/FEtNT+uukk3dPW6PSBNd8e/Gh8Qcr5p3tCFscc
         IaTg3SRh/Ch9kEmE1K4oA9FGl7T1g6uAOQPEEa6YVPMlW2mcrcfwJXqGVGjG3ekosCCW
         k9eQ==
X-Forwarded-Encrypted: i=1; AJvYcCWi0e+9ho5AN+iBzam332jPUQZM8AVU/738YwqvAk+K4tsCcjq2k0F0nvA4ah+26PqzFMlA0PHPQQ==@kvack.org
X-Gm-Message-State: AOJu0YwGX2faH7WEVHEO+k07AYYZlM43puwc7BRLs12IJJbR82nCAVzy
	dSvPD2xaswbC2AeQncAE1K+Nc2rVC77ZIaOgFgkwJA8agGlhmk6vla7Y
X-Gm-Gg: ASbGncv5MZzYHXDG9yCQjQgkYGR6TtELhH9ZVLZYFfVLESvsFI5NXf3GbCRnHSS6DOo
	odw9pT3r8BWn4v18Fl1p7f3pxVNzag4aDMwxex0TFdeA3jKJZTeQLFNJDLMwAevmkZFvsN+699Z
	NLz3yjP2YJv4rqarogMkVouXtdgfyb3kGn88QCsHpGyL/hBmcPbiNZ3IPTMLa23T6pd2L4bgxTY
	GD1gei6+ofGIogdRymNmh9J4b1tv5on+yvT/Wz3dYjAQlDHdzABZ5nfVE3Jb6scNhV6ntV/pS0S
	/2ZSCQlQ0NuaNcDBpf/icNXKlppyomXeebZZERO/NeQuMU+kq9Qg6JBLWoVvGKgZsViNTLJFnoG
	QeY9PntEMBfqz4khScLC9nqiag9/meU3jWrW33BXxzemtocOhGFOz1FileYZBw5c=
X-Google-Smtp-Source: AGHT+IEarAggh1iZ8jsVCPzM3oT+9cjTgRfUuCh+BSAmgke/WR8EXgzmjltOTGkP9T9W3tY5eKi9wg==
X-Received: by 2002:a17:90b:1b07:b0:330:4604:3ae8 with SMTP id 98e67ed59e1d1-33b513b3887mr35836227a91.21.1760550654433;
        Wed, 15 Oct 2025 10:50:54 -0700 (PDT)
Received: from muxbit.. ([2401:4900:1cba:d8c2:3f55:be8f:65f9:7af1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33ba86b9f13sm11728a91.15.2025.10.15.10.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 10:50:53 -0700 (PDT)
From: Manish Kumar <manish1588@gmail.com>
To: akpm@linux-foundation.org
Cc: vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Manish Kumar <manish1588@gmail.com>
Subject: [PATCH] mm/page_isolation: clarify FIXME around shrink_slab() in memory hotplug
Date: Wed, 15 Oct 2025 23:20:41 +0530
Message-ID: <20251015175041.40408-1-manish1588@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AE88380007
X-Stat-Signature: xxmgc3583emcfcwcrpyuk5urpygtsu9e
X-Rspam-User: 
X-HE-Tag: 1760550655-902427
X-HE-Meta: U2FsdGVkX1/xSb07MJ2MsktKSzuqVz1hXVElnRNcTGADhgYu857N/BaERO0nJZuI5CVHlxc7XM1rw/rCLlAtGPRsyM5JVJen0FD0dvpV3X5arKhyz3CV+iVxxDf+t1xU8vPu4m6lUNYNzKZLbzfsibsKQ7MfPC0MPQDO+pdaxpDwuNnY8zxOLwhK/NHZfU7zHHo0wtEZqspL/o7svHHZAYSuR1hGuHH7tWLn37l0DWGVK0wYxefvyg3qDt+RPipXCJ0xJj9CoVokGz9VtFFnNDZWLUB5L+hBVyQufA9+EPzLIKDVYxP4Z8h/Wz436N/Qpzq/3Xj6AbplVasGabzL8lMOC7qXxfkoTjm5ea4VR9O90hcfV5s23QPVxYbpB7agWAAGbetv4Y7aTND2lt8oxteupBk6Sz0aOgECmmwaiNkO+gJskQXkQJYxqqkZV26lhnijYxHXsDLSKj8H0KHamsGuuh9L5qB1shSDPd+9nbzo49Nac+JCxJ9eyLDfE+XfSnSPU3jD1A9B+ewcQkQ2S+k0XJYFhuixvPADO5HuDtcNjc8TxsLOlnMf+BdMeXUoKhP32uNxYWJ1tm4Z3UZ3LZiimOA+yJPsHGbwqqk25Ux0SKedR6UXMzoq0iLIcysQClsxEH3YGiaSDBJPmtNQ31OglRHT+5c/UFNnSyz5gcbG++INYjQP75+ytF6m2YIQo3yf20VOOrP708mnJAtimd4dKdQ6ksNHLKv0y4qWn2c35emlPv6EztO/9BiqQJrwSCqKGlhO9c9truC9FuU/yOAPxXrt6MJqCdf2afSPUHqcebwEph8tlCPwamRq0ZFboiWlJ9wZova4Oc34qGZdihDNai6v9SJbOcLcDV38bqTTzEF/4rEK0bgOi2jrKIBjRJcWnzx8e0JZWa/6F6hEC8cGMJtXRS8RtDNTImIIHDTEWBdId4MDDBTF6Mm5d0DD9qSR4ugAt/1bDe2s3sx
 KfYCMtlk
 C8aQcrs1o99pFMwXBfZmRg0MuP0eM77P9QR7SU5xEwOzFQBQZsr0GOVVALQDQb4mZeITUah7NBgbLHM3doXEQVsM3B7LfoiNosMh3nBU6B2z7sildPJalJ76nQ/9Fq680pG/6emGb5N/FTp2po0MFxWSDSVo3hnElpUo+qIqtXOmW3s1SMIRBnYy/Nq1qqRwZG3EGbmkJgJy7BDr9/9ZGtzQRxKd6g/y5fo0O0WYeCax5oC0C0l3cV1L8XbCp68tELwg/oc2QnNv8/nfmDXQ42+DYvAF0AWAvIhBgOKQmzO72AmRQSLZtgOTNGCnACwfEIDy9kERnWgCl5OYRssklaOYyk78FfaA/2XeQ/9tIgTaPMeMCtRzMDkkRepNX4rBj4irnoFe3VyrhxmK785Ja7m2ooFzU9n42RrPvREcASRMfhT/EuHNZxxrevOgi3BvoQPyl+XecY5OnMyP1gTr5kP5DWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing FIXME comment notes that memory hotplug doesn't invoke
shrink_slab() directly. This patch adds context explaining that this is
an intentional design choice to avoid recursion or deadlocks in the
memory reclaim path, as slab shrinking is handled by vmscan.

Signed-off-by: Manish Kumar <manish1588@gmail.com>
---
 mm/page_isolation.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index b2fc5266e3d2..2ca20c3f0a97 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -176,10 +176,16 @@ static int set_migratetype_isolate(struct page *page, int migratetype, int isol_
 
 	/*
 	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
-	 * We just check MOVABLE pages.
+	 *
+	 * This is an intentional limitation: invoking shrink_slab() from a
+	 * hotplug path can cause reclaim recursion or deadlock if the normal
+	 * memory reclaim (vmscan) path is already active. Slab shrinking is
+	 * handled by the vmscan reclaim code under normal operation, so hotplug
+	 * avoids direct calls into shrink_slab() to prevent reentrancy issues.
+	 *
+	 * We therefore only check MOVABLE pages here.
 	 *
 	 * Pass the intersection of [start_pfn, end_pfn) and the page's pageblock
-	 * to avoid redundant checks.
 	 */
 	check_unmovable_start = max(page_to_pfn(page), start_pfn);
 	check_unmovable_end = min(pageblock_end_pfn(page_to_pfn(page)),
-- 
2.43.0


