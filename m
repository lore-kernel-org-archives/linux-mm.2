Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0718CFF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 11:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29D866B0088; Wed, 29 Apr 2026 07:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24E4A6B008A; Wed, 29 Apr 2026 07:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13CEF6B008C; Wed, 29 Apr 2026 07:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 033A86B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:58:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 90CC81A0140
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:58:43 +0000 (UTC)
X-FDA: 84711446526.21.00ABAFD
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id C3968C000B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:58:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nwzqrUg3;
	spf=pass (imf10.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777463921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=L/K/1IPCQokHXyXTe7v8JYd9y9SP0z7fbM7deDX4Omk=;
	b=RpwdScH8eoEXfV9WlBfkV4qQ7IUVCNd9kLHzGS+c5WSeCxBLw5A4Eb/DwDT4poxFQGIbM4
	Jnk6wB2F3JbrpVwFEdxYTPnnC2+c92CmCHQAvdiTJpTdZ84RQu0EwXzwY1doDf7GND4Yn+
	YK0whAnTpLBZutxnu/XlFVu9E61vaTM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nwzqrUg3;
	spf=pass (imf10.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777463921; a=rsa-sha256;
	cv=none;
	b=ue5AbDwOlnoQfioq+uG7K2mKqg13s/JTfEfhjTD4/69/rcKYjFpchtJ2GnrSoPE7lGIlO1
	LhOZ+cW5nVACmxZh1i+jkK+2ipeIGVZjKWmDkipNb6P31WLN3xJd9sYbSMf2XjHPzJ6JWc
	e9Y/JbFzb8Q4YHbkXje3d0AePV2xlHI=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-35fc258aaa4so7856835a91.2
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777463920; x=1778068720; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=L/K/1IPCQokHXyXTe7v8JYd9y9SP0z7fbM7deDX4Omk=;
        b=nwzqrUg3f45kNqgmYIYtddopdaSuquCpmqnh3A60k5cJnLNBWrUwUJ2nEzJb0mt+3G
         xoDiovtvuT5C7g668guxzv6sS0ox0nCyGCYA8gYH0TGZl92OxEse7iM9EWIszic/J+1v
         HNgx5PiVqjuwM5PbwBlgZsBpVyimwWBz8kooyaaEt2nZpIQBSuYuHsSs8Omo+hu39ISd
         TXbX1DwASZ8UxwC374I5Ia+NMOZ5wTch/d3SLLe8iefOlWVXnK52x7r5Gy1Xa61tX0kk
         plRUzPRvD4SWdWf8TSRxcx6XAAShDckwalaJyYnGNTtJtWgIWsd70mYv2RguRkllofiF
         zuKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777463921; x=1778068721;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L/K/1IPCQokHXyXTe7v8JYd9y9SP0z7fbM7deDX4Omk=;
        b=k9ndK0MTjt1Zniou6UiEOfmRCO1N7LvBtfsWH3kJExJW3J4ueC1rRCzyCsdxpTX8UN
         6PLlWjCfzSVSD4BnAWEJVMIYc+9Q8DJQO1j8SdhZLkpAmHfsWhqXHp+w3JKbOiXML9I+
         a+oOMUMhxJJ7ayJHZB1weqo4HgeLXRhXYisam8l3DJuzUrKdpLQwPHmCSono4cGJZbvX
         obh2mUwLliy38A5fj+oBRDRQKvjRVpyCiCLg6BUqjhvT+nXqi+eUquRv2lJdzM9/cFSX
         BNxoEaQJRm8VALULdh/bWURnJaSBlas53Z5/eJs18oSNUb3U+kTvlZE/7PPYxVTBYzwZ
         FLog==
X-Forwarded-Encrypted: i=1; AFNElJ9Zw3CcdbJpnnXvmkt8ayvspEPZHzttGTyikpG5wKATnDrlMKrsP28r3l0PIxGoYjixTA+tMzeYMA==@kvack.org
X-Gm-Message-State: AOJu0YxTocUGH3lsMcl+5ApyzDxg1Su3rKQTABZynCZLWLBLhN9/H7xe
	Ax9vlQf9WXj5RRX96k8tMjwYa33DqIf9s/7aBvJ98a7dCpbx8x9LKvur
X-Gm-Gg: AeBDiesNN6nt3FTmt+Ewr2aeh6SlyS19WrBUsjn1lskB5EVauLNOKt4rJPGd8MrZUA9
	fTNZNPFREZCim6PvefA4K1MIBczX7Lh6oBGYzFxnBjbPO9B6ZBarkgvUJHy3omqHc/DssuTJqeE
	c2w1bqAMObe0HQombLXAZFKC2QX11FInALP2xHPn+BKBVfZinKRJoqZn6tizbpshuwrM+HSWWNC
	2NS6FhJK+rbDB8G7GZ4kdV1bizi6U0lLpGubuA+otoMv4N5AzriiPZ/JRSUUB+v+8e0/TZtIJHS
	PKWR5gnDEIwmKFrLmR+eBf3SY9nLObjY9dKXvuKKxv9Qi73GtOaORoCGycLcdQEp7YqPssSRFLj
	Kd3EIw6OwlhyShcHK34iBMW+MAGAWPVesUgesi0xCwDTJCcvU4OefifJdmvUn7fctkL4JxlYeOo
	pMFsdDMDW6n26V94rqqA5pFGgxqHmAfZvdHoV7tR/7
X-Received: by 2002:a17:90b:3c87:b0:35f:c0d7:ac54 with SMTP id 98e67ed59e1d1-36491ff683amr7500827a91.12.1777463920461;
        Wed, 29 Apr 2026 04:58:40 -0700 (PDT)
Received: from vini ([2401:4900:8fcb:3097:5ced:f23a:32ed:4b52])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364a011512dsm2822040a91.4.2026.04.29.04.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 04:58:40 -0700 (PDT)
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	shuah@kernel.org
Cc: ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: [PATCH v5] selftests/mm: khugepaged: initialize file contents via mmap
Date: Wed, 29 Apr 2026 17:28:16 +0530
Message-ID: <20260429115816.98824-1-agarwal.vineet2006@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C3968C000B
X-Stat-Signature: uwir6bihq8woi1ag544hzderj7bhfygm
X-HE-Tag: 1777463921-301591
X-HE-Meta: U2FsdGVkX1+a2dAO85D1JQgPNUBRdvzrUXdV5dqnA68TQJyPqTruME+8OJYv9pj9qcfY6D2kAoDyGIbGdaLHS9WLvb4gcm2I/SupQO1lSFOKfCZLXkCSTZsWLy9nh1+Y+G8iCELZxHiPIiN7CMYlwPwjR2CdiIHLD1PN7osrhUR0BDJJPmKTBOABNrVH584ADqN3HqV457zZwvKnanAXYO1WjvIsVpI2XA0oZGjHF0+O2SUEofJ/fImWeVJskvlK4/NSgQ6vo8x6JuYf5kQZjY/mdG7RfuErjkzsyfQk27cKbIwmqLBh+wjVM3ucKDZLn5xkcEv9bw2M0BJvSghKcLZlCJXzMRKKj/B0Gyjz0LWJQB0HMbBm1b+4A9n8L4tgvJ+8nIJ2agCmJi0i2YJru7pSi4MBP8a//0z+bxCvEbzXvNY0OuyAytPFXxtL2JLRLdY6J6kLV5dvR4XKsfPg125ZkHwYrLvhpFwD//fJ4ptuVP1nUPhvffLsBdI6W+KtXTaTU6bkbtG/RbWHiYWK8CjLcoxrwXarnhn56DjAwUKNTY8KDYzPAIUCgLyUwB7ae0xw4mBFAhXcfgqObxO1jGRAtWYr8+lirk1gqFDvQbJMDNYmRPlhHYTyMMzu9wwZCYf8Nw4plLvUO8crOQ3s1+Yv1G+9t/IYXV3up+eR1MKN4ZlzQkUWD8fGXxQT2rprOXxFq6260B9FKKixrRszPrh8XsHABM3Ucap/k0AbaOL9AUqr6OHVq0Pp8qI2GAzBLQqfEmNoPEzy96GTecAxiWdwcIh6g9Cnq2BxgOm6ZOIUGozfdeT7+5HEa9jWJG/ZdbNvBIFUZ6uRtK1XRRCqR/ALwx9BsjNvpVHwTT/7PUnj/yl7hH04oC8WgD6E8888mVDK2ucJT1WG9eIF/4x2vkt40AhU4bZ0ZU7JRC0YjgNWqvJkkwXCxwP069Xu3B7AYX7NEuyjzGx8ZtwnAyC
 9SJJXFST
 Jwjyw8BH/gq3v0vwKrg/PNqc/29JXSK4bhyrea2jEG7OqT+Qhl8OUhs2eCRmQECPHB0LISImEIgH/kLZMPhjs3ufQRY2xiUbUDxuFdUQ74khmlwj5c/i6wbckTPHY5ZsaelFfKGzLho6/J27c+teWRrmEv4sjiuOsZIxxv1B1Su/ThybeJlqpAFJfx/KdH0XFheLRD2IzhOJhdCgVrbMYUsQW+GiYwIjQFQOvAUUKvodgrs5pAVRWfCYDeQHsX7TOciKV/rmo4j/TbFt4iEWqyOVryXBcm3lLcMBYd4F0H7zsA1K46vGIGypzbdsMgZMt/1CLOHstFNOqIMxT0ca3pGtVWe/QVD2hhnSm03pHZEe5zZEjxG+gxjYx4/Rairc6y745hGZZUa1vcgjHJqAQOIq9mIY3XqlpCta7BEOFpmt1dx1mLNh3r0UIG418CLyYQCfd6DicKkKdo/FaR5U1UD2r+Wcodsiuqx5MLhExxUROBJO1twugpqjfaSBPxFeyR/CDA1tMg2IVN4KmGhvT1u0ojadufu5VWYbpeHHiTb30Hz0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

file_setup_area() currently allocates anonymous memory, fills it,
and writes it into the backing file used for collapse testing.

Instead of copying data through write(), resize the file with
ftruncate(), map it directly with MAP_SHARED, and initialize the
mapped area in place.

This simplifies the setup path and avoids the need for explicit
partial write handling.

Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>

v4 -> v5:
  - Restore msync() to keep folios clean for READ_ONLY_THP_FOR_FS
  - Remove O_DSYNC since msync() handles synchronization
  - Simplify mmap() check and drop unnecessary cleanup in error paths
---
 tools/testing/selftests/mm/khugepaged.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 3fe7ef04ac62..c8393ca52cab 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -373,7 +373,7 @@ static void *file_setup_area(int nr_hpages)
 	unlink(finfo.path);  /* Cleanup from previous failed tests */
 	printf("Creating %s for collapse%s...", finfo.path,
 	       finfo.type == VMA_SHMEM ? " (tmpfs)" : "");
-	fd = open(finfo.path, O_DSYNC | O_CREAT | O_RDWR | O_TRUNC | O_EXCL,
+	fd = open(finfo.path, O_CREAT | O_RDWR | O_TRUNC | O_EXCL,
 		  777);
 	if (fd < 0) {
 		perror("open()");
@@ -381,9 +381,21 @@ static void *file_setup_area(int nr_hpages)
 	}
 
 	size = nr_hpages * hpage_pmd_size;
-	p = alloc_mapping(nr_hpages);
+	if (ftruncate(fd, size)) {
+		perror("ftruncate()");
+		exit(EXIT_FAILURE);
+	}
+	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE,
+		MAP_SHARED, fd, 0);
+	if (p != BASE_ADDR) {
+		perror("mmap()");
+		exit(EXIT_FAILURE);
+	}
 	fill_memory(p, 0, size);
-	write(fd, p, size);
+	if (msync(p, size, MS_SYNC)) {
+		perror("msync()");
+		exit(EXIT_FAILURE);
+	}
 	close(fd);
 	munmap(p, size);
 	success("OK");
-- 
2.54.0


