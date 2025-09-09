Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80128CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 19:05:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8BB8E0003; Tue,  9 Sep 2025 15:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69978E0001; Tue,  9 Sep 2025 15:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C595A8E0003; Tue,  9 Sep 2025 15:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB7798E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:05:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 654EB13B5D5
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:05:44 +0000 (UTC)
X-FDA: 83870641008.13.FAF6785
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf24.hostedemail.com (Postfix) with ESMTP id AD6C4180004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:05:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hztZezzZ;
	spf=pass (imf24.hostedemail.com: domain of 3hXrAaAcKCMgD2ysstsu22uzs.q20zw18B-00y9oqy.25u@flex--zokeefe.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3hXrAaAcKCMgD2ysstsu22uzs.q20zw18B-00y9oqy.25u@flex--zokeefe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757444742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FdPX30UzJgvc8rb2FS3LAFal5bl/d6KCBhdWDQJQT7U=;
	b=pqtnQ1EPvjUNACOd5Gh1sUTB5HhO4waFy4OjfRY2/Yx88tv+MWnqUsQRTNBZ/yJTm1rNwk
	AakCT6IUXH7MuDdUtoYAWz6T0clkFqFqgTI7Et4kFOYzHyM/sqz0dkr9cVyuoK2BnZZdGU
	ELdrs2MZa2dYE67m9TU/6tIF1DIv1kY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757444742; a=rsa-sha256;
	cv=none;
	b=TEtlZTHH+c9rmFd6o7ICQpOC5KqVk7EFs0PqBcyMqKdEg+Nwnj+fgIT5022BN5KPv+/S1u
	Hxlo4IzmmanRgGWIZ+ObkyLgDkKOGs3Y2oV461PillsTHf+xpt4YOCHlHPtPZuL+XMbnah
	fCNAGYVs+XQmKYPj9wbBny+GM+Am6yU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hztZezzZ;
	spf=pass (imf24.hostedemail.com: domain of 3hXrAaAcKCMgD2ysstsu22uzs.q20zw18B-00y9oqy.25u@flex--zokeefe.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3hXrAaAcKCMgD2ysstsu22uzs.q20zw18B-00y9oqy.25u@flex--zokeefe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7724688833bso6291559b3a.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 12:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757444741; x=1758049541; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FdPX30UzJgvc8rb2FS3LAFal5bl/d6KCBhdWDQJQT7U=;
        b=hztZezzZUAIS+0M2yyosSIEQBnwDl9RTXCFu5JN+nz1n9zD3uwuXXFriMOAMndq06b
         qY+wcIyC5ackABfpV6AFhJBywyIZQv9i0xgfoGT5JaBahKHXoxBaHQK476Ts5DsxExii
         c1G/KBLVPXVQGpOXENvwfb0Bb+vAfi/7A0V1mO5CC+KZ/idK7IbKrR2xf1FnFWGru6rL
         lmE6TisJuh+8QDwa/RaGsKFmAG+oFlXkFNVwU3V50FEQzhJ4lWS9yMtBJduchkmFT/YI
         6dsRXLGP2QGlIRUB+opVXN42d4811csYP+cOTs1tBmehJ4SeX6y/H8b0+cJnpHX33f+i
         i2eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757444741; x=1758049541;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FdPX30UzJgvc8rb2FS3LAFal5bl/d6KCBhdWDQJQT7U=;
        b=LvAZXT3Lz+As0Up4S4mtq4Z/wIT/0VLIR1tnnqPX2UuihNpftXq3FTJNQrSdVrGMjb
         aMjns8J7SuT5It6BqK7lRKurCnz2mib2tlQiBJqkbOlQq9ocSb2kPGk5qQ/pQJ/OM+1a
         dpILPD5JnSkSJ+SS36Z4EfkBoV20Q8j2DF3UbfszdXO/D7zyzN8TH1N/23fk2rde+Nff
         VBXV1Fg66HXZ14I7za3WYzqE3c5QD/Aa0VqzGfOuBq1ti+Dl9sjHsKU44ZXf/+teJIH1
         dWMfuzneB9T8/2716g5GuB51yPKKVu21cegZwHUtRbqo1twW3pC/wNr74Ymo+fOGcET4
         m76Q==
X-Forwarded-Encrypted: i=1; AJvYcCWEMCsccXHf5cu4NVrb5rpIA2OvEmD2Z0lRWZC3t9A5uRe6pUWHXIEgbMlNp6x0m+06E2Yqg0H/rQ==@kvack.org
X-Gm-Message-State: AOJu0Yz3dEtsKyn+RefeX9MNxCHfyxW+Xv8rq57a/MB08wlL5aZaM3b3
	QNGuxUHG9o2x/oH73zYXSwY+kEdqCMRhVp9TbZDXr5NQxpQQOFybDIbY6KbYMb3j3e0sSfzro5/
	Z3fJikEP3Og==
X-Google-Smtp-Source: AGHT+IE7x2j8jiGmSa5hAjziFVPfetOC+qsRzdWEflJQ3CeZTBtL/LM/cmENZY4RpAOOGBS9kWw8FhCNJe+8
X-Received: from plgx7.prod.google.com ([2002:a17:902:ec87:b0:24c:be1c:4fa1])
 (user=zokeefe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2447:b0:249:1f5f:f9a2
 with SMTP id d9443c01a7336-2516906b170mr155110685ad.0.1757444741506; Tue, 09
 Sep 2025 12:05:41 -0700 (PDT)
Date: Tue,  9 Sep 2025 12:05:34 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909190534.512801-1-zokeefe@google.com>
Subject: [PATCH] selftests/mm: remove PROT_EXEC req from file-collapse tests
From: "Zach O'Keefe" <zokeefe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: "Zach O'Keefe" <zokeefe@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: AD6C4180004
X-Stat-Signature: qabkm7i1f486s966x9disfj1aj98co8i
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757444742-27376
X-HE-Meta: U2FsdGVkX19M/zhAcdls5BFuYkSKxaGRcqD97NNC8ByZQqOGLPyEmcI7XkxzUtmIbxPon97SO5myKbcmRPxXKyyiLRLIgjztgilj0JwkFuicc9HMaSXsrWQhwiIb8MI3TaA+rSpWF60EfdsIzaCGJyYCZC26f6O58Lce37Q59KDuaVZr5YnNfM1yp+jl2MOKjHRUvlkM3E9Jyct2SRVfMmZti2WXRi8pbNTPzpzj9gPEGc1T+Zwd4xF9fXf8JO5ggeNZLpf0fJqxY9Yj1Avnrc+rZ2fvi9dBM2VRRvXOKNpi/Bg5UhkZTgopY7OUeErFpMxtyb2DHGXR5SqwZWtS5RzeGP5bm0db4a5BSkmL0t6MvkfRAXuBhvAz0ftpVdg2G7vjiIqkIEd09UyIvN1Ne+OGKhWX0r0Tu90ptnX7J2/F52DGOSUewsHsgU7PTVkEn9++gpd8fro7NrFQKsVxv5fvV+klkJyzJR/Kzrb452EKXkfRuD0+gEFhgPLI7itDqhKqUd3MhAz+UWGIskFMNx+JvN0cXurbhjAaTTluMty4mtAQe5ovMM7hUFpxXBxZI8eFoHl2rxQpP8cmCDv19kMRk2RceN/lVmfABAodWX7UMDmQO+iO/lrGO+r0IFp6zyMQPqz1gjevA9v0dubj5rx85XqS4CV1EqzmMhYjAJGnk85PSOXBuu4OmWpVU9qrm2Ev0SUHmzcbd+JvWBDsUu+MT/Q4VzfgzwJ0hH0sym37YiFQJrnveXo2EuRxm5OO5qZO6bHm4mV3zLkroUC0CutVtR+DQyGuZH7UDxQGu5znyAfbFxKnzOjr+oYL9mRBQBxoTMjo1sa+PV2U+xdXQmGLOzgggHYgjM0sQIDJLg3Z3A25X3S9ybXOUMDKGQ36E16N6r+gSHnYDNRyzCFR8XftFgP/hm3wh3kjamigv5ODepXy6XNfWh/F4Ox5Kj1PRJ0FvQUO/bBEWKlmqpU
 5TtXDGp1
 tkpp1N2e/r4y7EgDNRwoqWBhfvlQH3p6jQl5seJMUyKvE+CzkYYHCjg3lJgei7tbv/S06DQYUWCGunlZig2+pkTywXLdhI5z0Dx3dXap58FTJ3Yb057J9kCOgt98kgTyO1ZeuK8Fqze3hIT5zUivu5PRWwG2/0WjMvW1MavFj0/LcC5OLxob9ofrTWMAtV2f9PpEj7vXb2ZNptCfT7epnbpuk1gs9r88MPS3PvIsXjirbu9EjBZpMyf45W7n4mFh+iMcRgbLGY2KzF6PVG+x5d9O2S5m0dsJecdoQvyen8Iub3Rj7yQOR7BIkrTqQ/Mk8YTcj49Uhz7PPKtRRSz9ZnG2z71GHapj5YdPxArB6CJjAHhWJivGUPQMMucxgXcqxseflAp85QLx9yaTktzySo0YA9QS8FTvQMZTlRIZAQnUjwwmaGluapf78pCFGOfY5jQ3BLBZawO8kgO3uiIv8F7z/uhzs4pi0R9vgzhGts3MQQcYtaTGymn+2La5gzq3FNWHcSfCtIKT9WEfnElvHG4+W6r5XupDveK1g5nKgp/+0Q4rAgMUE0KxSjcpFvyen3zz3/RmNXk5vlyRDnQsg5bSjsA3ok25LM+kY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As of v6.8 commit 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibility")
thp collapse no longer requires file-backed mappings be created with
PROT_EXEC.

Remove the overly-strict dependency from thp collapse tests so we test
the least-strict requirement for success.

Signed-off-by: Zach O'Keefe <zokeefe@google.com>
---
 tools/testing/selftests/mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index a18c50d51141..3fe7ef04ac62 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -394,7 +394,7 @@ static void *file_setup_area(int nr_hpages)
 		perror("open()");
 		exit(EXIT_FAILURE);
 	}
-	p = mmap(BASE_ADDR, size, PROT_READ | PROT_EXEC,
+	p = mmap(BASE_ADDR, size, PROT_READ,
 		 MAP_PRIVATE, finfo.fd, 0);
 	if (p == MAP_FAILED || p != BASE_ADDR) {
 		perror("mmap()");
-- 
2.51.0.384.g4c02a37b29-goog


