Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE86CCFC500
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 19:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2736B0012; Fri, 21 Nov 2025 14:49:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D528D6B00A4; Fri, 21 Nov 2025 14:49:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B577D6B009B; Fri, 21 Nov 2025 14:49:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 92E186B0010
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:49:22 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F0A61A06CF
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:49:20 +0000 (UTC)
X-FDA: 84135653280.10.5203598
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id A42D218001E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:49:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lu7g4J5p;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763754558; a=rsa-sha256;
	cv=none;
	b=pXfOeLfOG6odbLdL+1kiaas4S0+t/aoRLo2kOn+jU3sy9tf1Z8KOYQIRAgfVOtb2ZI4l2h
	ElQQehj9hhaU/ZXjFmmeynyxNuglIQLxAZv3LUjfyOCz7a8RwN0kBta8JqWnjO639CasmJ
	lYKelOD79i0e/2KKCfVozQAkIdk94PE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lu7g4J5p;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763754558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fCu4vGF6Xm1d3tl07Bb7cQ7dZZjuJ/g5WogLPoUkwxA=;
	b=UGdY7dbsGv34nVo/q9H3GbLE4ZUTqlv+o7vsz7lZBANzZxVXdE6P9mTPVI+Je1/bV2wI+I
	EfTaGZ+61YeP9ScumHZHVMbwaT6pXIT1wiPvdgVj2CBObGUnlJcb8leFa3gd+8wWKrefIE
	L8wCAERLFpEZxet6TtB7qM+FW6GqPsM=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-880570bdef8so27210206d6.3
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1763754557; x=1764359357; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fCu4vGF6Xm1d3tl07Bb7cQ7dZZjuJ/g5WogLPoUkwxA=;
        b=lu7g4J5p2bYe4VtN4/1zwXtBNCeeG/dNCAnEA7+z3Vo7HDA2ixo8a9zzJd6MDsIN3V
         ab8cNhV+i2hysBEWKwphzLvvNaOMSKN7KtkiexYaXXRHKFtiEBVQIN6FzuBK0Uf0vN+j
         GU3t2KcyUReoZsE7wrvLNI4QfSZh6wgOGa3JjEv9RyVX5ELgsmNoO1V/bAAUFWELYl1P
         lnXfIE9BsK9C0LCDqzIlQL7/LRdgxKndopIB4X6t7czfpb47TDgNSwNRWkLVtl7JWG01
         hZl6Rgap3lB+E6WYTypflJi3bjofIXDCNvznkNXAEkmOKLusPWVWzcB+k89NUYQOEbps
         9Diw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763754557; x=1764359357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fCu4vGF6Xm1d3tl07Bb7cQ7dZZjuJ/g5WogLPoUkwxA=;
        b=EMXvsFodxrWnQG7pGfvNAaR5JA6qhqCfG9xzHBSvww7ElNRwM6zj6lwTsYTq4rmLfw
         LrdxfIPw4UXetV9N95kQQymMBMndBSlB9enca+Yuu0RUYOd5ZHEJH1OUkl77FZYhSGjr
         RfipHLu6HvfO0Vdo5VFqTgPWjhKJzZbfmKTdJcFXcyrpNP/qmiFDIm6dUCHi534qFNNG
         i3MkldZ0S/MBAEWB0UC97hWh6kGWtDEYCavcH/dYIunzlsTgZb0lpzJTat/vWirckBcz
         wB7UeXBYoOq/1MTnYDRunermmte6dr3K4SMJzCy6sRAj85PGUVpbM3M4pVsHzXGpiyvV
         TcKw==
X-Gm-Message-State: AOJu0Ywt+g6ufL7WRBgMnpAPB4/dY7wQlghPiCMmADUkCnUGvEc/yf2E
	K6USqQLYV1Cu/qHlh7sCokM3huT2b1redBtF+fCOrOtluXCaQf2oEWRW/PLyZK9RYN8jG8iHeAy
	ua+AM
X-Gm-Gg: ASbGncvUBb8WtXt7DJ96rbeEL0YpRKniwZW10BG8QzSZSqWyUH4CWrc1qrH6Mcdrvt9
	umwRPIAOqAgVWzCRx9tA9s+CNRiRLZAIK84ghKskn8GG3vdi4yU4msIEKVTPQhl5dymG2Vw02av
	iPZt1Y/rqQU7K8z0UGRyJQC6eq3ZVav36XEd7vbdwjCPoz5XFlOXJJhU9NK+FEoXrxKH8U9BUBc
	91RBeRQdh5L6z9Ko4DEjnDcXBpQTHRowFh7O647h0pUNkKEyWy4SWUqEbF8lIjaUusAXmv+xMP5
	smdyQqnh5XcZC6XrffGe+fsRiysHw7Tvr+StgOgJGhkIDhD11yrWKjuGIEE+uWvHRQ+Gxfil8z9
	1aBNEWNfvtg4XaSrm6XByJE4msmKOFmXwjsUAixFGt/cZVumSfH0MFMYSMwYZq0ADkzhTk9pXR0
	wEFnOM3/E6Nij/aUqHTf93LHdeOnpk1ruk79mTfrEYeqqggJaWI75YoFcjbz4Y2pi7Kf9FHlzFH
	38=
X-Google-Smtp-Source: AGHT+IE2F33/aV15dBpLUqML4c2rwJTzLPxP1aiweOtFKKoG7RdiJY5ucGpqcZFX6ZZLkQZFa7NeSA==
X-Received: by 2002:a05:6214:1d23:b0:81c:96cc:f7ec with SMTP id 6a1803df08f44-8847c4d6a27mr53002466d6.12.1763754557467;
        Fri, 21 Nov 2025 11:49:17 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e574918sm44510266d6.46.2025.11.21.11.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 11:49:17 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [RESEND PATCH 2/2] hugetlb: add __read_mostly to sysctl_hugetlb_shm_group
Date: Fri, 21 Nov 2025 14:48:59 -0500
Message-ID: <20251121194859.265259-2-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251121194859.265259-1-gourry@gourry.net>
References: <20251121194859.265259-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A42D218001E
X-Stat-Signature: bdeq891ojk8qazfsbpz64dnc9kp5bh8p
X-HE-Tag: 1763754558-591439
X-HE-Meta: U2FsdGVkX1+FG6qFO/PW5qYqLSIYpHxKlW2oDIFGIJajw0Bij+QNx81SP2FInpT0afi1jed5D1klGKtU2yDATzGKEi/MHqHjYXDG5nx3wI1LBg+6VLXkhtJwWKx7O9fvV6NHwAeBDNRQFj7jNMUVOa3LWNV82uBlqt2d7v+6RhWMYViXoEPG2AEoqY9HUySTLQRrj0q99RAW7HlksuQcERw4slhc//2LzqtHfbZUcSIVF9hwHPKAyAKX2QZDPQP0sBXiuZAgxMb5wo46D49ESK4kbelnCk8OShKGiNq12/2bVVfaN9T3GaYANMOQp4i5Cgb/NBxZkr7nKe0qBkrzEdh+peVUwk/JzoPgNXvpikFSshVw4wjJhrHYgLPFds9oBen7olHm8VamPRFJFawcRd4dhGKToCjgtva+uFsTldGE/Idi9nCp0ppXHlVqibvT00iJeMEdk3JuvVjxYYgL4wlBGN+5WOjEe6jfBoL0InRqexkP47fWUoFDF1ObxM3/yQRsGG0YdoGmyCHtDqBjEqDF2HESr9yNrp+gvYx9u7rplwshe3CJL8U33jkmzwtkcJKjAHF9vFBeGKpTG8J2IsC7SUY5nIf7jyj++5KYHBtR+7LmAs2voQ6yYfQSYGbT6yZOnCQIK9sTzKiXGzmJSveJDcUhm354iibGq8McvwmK0Ftd81kiBP3CwUkRMwwZwBrBexoQTr6DABWx7L6rw4pscfP7zZxeFCeIBMBFVNMSvumFR5rXAv6vNFLyyJoNlGZ0n2Fe76om77OYHY3zrniiXVe2L1saLaEwz0Xm9/EysZPLOcfNoxYAXWzK/mu/dbCcSph0y+/EFPAs+gRqHwXTa42LPtlO4NmJ5k1QtfkdtckE4VXTwpF+RfVx6BeYJ2Pn1QE4WZhqX+Uz7D1G9NDKpqLj7inl/sIhEWmmb7KKCMhPICgU29i+EMLslpHQFgJC7xsU5ILrviK1Z1W
 7qdj+SIo
 P+Nvb5xWRmnAFPI9Sjoebox9sJt2g8q4WNNCG80Xcg/ddL+hEiOAJOHE6lsXkTYwkQYELiQGSq5PCDSC0sUBlTQQcE8GAG4j4PNg9KfRIjy7FTfxT4NQW0fZGTUmZwqnZ6yAoXPEqeDkgIfemgNHvy9d83ei9KYjjVF6AgkHPbY04CS37lYFEZPDzrjvrZQEltUnlj6o+fXjju8odYKhenUfGibcEUncD/iti7LnMo2guVMPUGFyKQv8TCQupjyWufvb3JGj98DMo5lwoy1PM3AuAOMVdxm9w+j8XdHc6i5XE4kpsipHWUDTxdeSHre4L1P6rMBFSVsybtCGTNCBhAmTFTrZHW3xE6gOhVhK7juIE7kLjHLwv6PCEQ8Z0VngoRAxWmErIe0ajq/fqe7rWP9GtezeieIaI/56rSPRIvkOs9hHKPfK/kh/5zolbDvCQL1g8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sysctl bits are mostly-read values.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
 include/linux/hugetlb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index d5282d52493b..d6705157c41d 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -172,7 +172,7 @@ bool hugetlbfs_pagecache_present(struct hstate *h,
 
 struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
 
-extern int sysctl_hugetlb_shm_group;
+extern int sysctl_hugetlb_shm_group __read_mostly;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
 void hugetlb_bootmem_alloc(void);
-- 
2.51.1


