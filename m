Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA64CD6ACED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CAB76B0092; Thu, 18 Dec 2025 06:46:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ABD66B0093; Thu, 18 Dec 2025 06:46:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2C16B0095; Thu, 18 Dec 2025 06:46:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9C86B0092
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:46:12 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DFBBDBE3BD
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:46:11 +0000 (UTC)
X-FDA: 84232413342.06.8E1A113
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 242F0C000A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:46:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JXjhQ9d9;
	spf=pass (imf28.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=klourencodev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766058370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fBGcG1BLiQ2zaZ95rCMCUY85ldMmsMYuYWfOeiat7uc=;
	b=1iGJSiMj/6J3vV6KUcclcCxOIdKY+pc0FpXiezaJbxPEfLjw1o6H2bAwHIUD7LWDioZlCd
	ybMiERtBhVYO36o/ePj73BRYzdL6RWtK6Uc48Rq/i8L1lJGyf782NX2g5k6Yhg+a2qCSTL
	6ctTRZZjjFgm4VkQms6EN1L5LH2kBXg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JXjhQ9d9;
	spf=pass (imf28.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=klourencodev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766058370; a=rsa-sha256;
	cv=none;
	b=cK13wnCMQjTWoySIY7RiF8Km5S46pWTYMknGUI08KrhR2G2/paGyYZ7DTLDP1/K7NGQ9ea
	6hXgv4hOsVD0aQ0SRDrCmfvw6C+VQ7rcSXiQtq/mgVXONSQUpkbRIaotzaNwrGJhYbUMqJ
	EsyzEFOiYhliFWHKOROnoIyt+BpPv0g=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47796a837c7so3971365e9.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766058368; x=1766663168; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fBGcG1BLiQ2zaZ95rCMCUY85ldMmsMYuYWfOeiat7uc=;
        b=JXjhQ9d9dHBmiGHDABUkAgGMMhlk7HDwpUtnFezb2dlYe6yxlVim3C78uDnpD2yHkf
         hUObRhiO2/zH9MtAYkSZkDcL9ZjRQOXLUsKlI1u2YIhZMiQSt2WsMoD450aPBB0kZAmT
         i5IskbL/KPnBzHu6YPmwnuOV+vp+8FCFlJDbCxmEnZpoVDkTruaLKQShsk/NRQXltOB3
         EOrug27H0I0Dyk1RqSV5yIFaor8FB+7EjDbGsPR9qBzZAD0ZJFjaEsMh6Fa4xe5CjZrT
         2Z/vmlqn4qBPxK2YcELiBaT2+LxXXybfd5WKg5cb6i8rpIKAX5lnc+KtUxQndIpy0m/Q
         3Hzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766058368; x=1766663168;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fBGcG1BLiQ2zaZ95rCMCUY85ldMmsMYuYWfOeiat7uc=;
        b=bMChZYKO0u+IKzK3HbA+pSOCV5+8ZzJcPwSWPsQ3sdf0gbakSkWZNsiqyf7fEhrJTN
         s6Wl9QX6AI1tnoYePDcEDLtP7iYSKkZ3Q6W0LLK8s/KGZX3q8itp3rQN9qRaq2pACW7q
         ggr2NDiX4OVR8KMkigYTuf5nURZIU2D6EHwu9aceP4Fm1iu2WDArWaG6rk4RVOKAIF9v
         bzAvb4QIQKDdlw0IVogQszMBbT0JGlX9dE1Qf0+kQ40u4wqL/bE91JRhI13PB83nuz+H
         RyUWps1PV9VcnABg65EeJSBop7aaaIZG8tQNjlanZPi+QA4HR5pSLLUd1P444dKnyC9/
         aDxw==
X-Gm-Message-State: AOJu0Yw8UykMcF737th15zj0Y2Zo/3ir6x3uOqQ/tB3XTIvyG07VlZ7x
	5rudiaVu44KaVdO9eUhiVQAdum2eodLk4NW4nUvGD7D9J0HBCXc20eGoV9WGJw==
X-Gm-Gg: AY/fxX40ZewvilunY+QmcnBsrlqMZaGpc913MkMNrNE6iM/fJkGMVzM1YhEzGw3bb6i
	EXtt+z7QbQ0ApJkbepL3042n7r3sFWO1RnrjQ8DIdZYNJt/9p0PRsIwKyTcuWZ/Efo4a6kGPTNC
	2/Qb/mBOumPeK12GyScQPR4KMtAhiwQcRK6X6mRqQ4czkJvR6N1hhcFeORlQ1II4rUaSTvbtYqg
	ecugTioz9Tx+Kd6yYZLpopImV5+myzTBDOZb9xFuWdi21eFXgfZNRRZ2Q5XQuxn2kgGGLyHUSTQ
	3K4vgGVG2fWLx/yTZz39SobmuHvhCmeIfkUxE3uZYgYfpV6lCKQb1fvCbOCigMwv8lw+IQ74O3O
	61dDyrsAjzSjFsOY3PSn8GqR/iK6E46dB+/sALmrBDJKbvANuMx4VwAzieNzC3nc/DUeEKP/6C0
	RI2UeZjhnMYZZT1Csb2rXYuMUIxEUvj0yU2cmFaTTdcCB87veVbTDpOtmh3m+8qQ/CsxZkACU6B
	k27GPkIS5c0zAx/+g==
X-Google-Smtp-Source: AGHT+IGLlzBk6jf8IaSULTjKtfmj9TBUm+vT3WknWApoxz1X5mlU0bNnkkQQ52jqlvV5jxq3NdiwVw==
X-Received: by 2002:a05:600c:6208:b0:47b:df60:8a14 with SMTP id 5b1f17b1804b1-47be1e27cd2mr36597995e9.9.1766058368242;
        Thu, 18 Dec 2025 03:46:08 -0800 (PST)
Received: from desktop-mu90jgd.home (2a01cb0006769b001185461c960a9b50.ipv6.abo.wanadoo.fr. [2a01:cb00:676:9b00:1185:461c:960a:9b50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be3aa7cd0sm13235495e9.8.2025.12.18.03.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 03:46:07 -0800 (PST)
From: klourencodev@gmail.com
To: linux-mm@kvack.org
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	Kevin Lourenco <klourencodev@gmail.com>,
	Kevin Lourenco <k.lourenco@criteo.com>
Subject: [PATCH] mm/hugetlb: fix typos in comments
Date: Thu, 18 Dec 2025 12:46:05 +0100
Message-ID: <20251218114605.12502-1-klourencodev@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hbggzjxirso9bhdzxppcxx5rttkbqjrg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 242F0C000A
X-HE-Tag: 1766058369-844800
X-HE-Meta: U2FsdGVkX1+Po+j4rtZklUtYKmqNgjRj5zwQk5/soEe3mmb5Jmfj3++OX63OCmyU8d093bw+v1Zn8eGkolEMebX1wTB8HDJmD/Aajne/JX3u12pSsc8OdExIH+EalCZlNaE8mD9Vf8jsBpTMkpeVtxVD6geUS/uBXKQ9RCBl4lI/p8CdQmG75wqVYJjUI6HXx4qKde6jkoYpUTdVk9FPLM7SkA7jw9nsmvL3Y4+TiWUCPvltgTF9Dv8tqSfbiY9PIB5Lm9Qjf/yNURL0mmWTEs8LvIZahDVJAXA39TuvBr55kEC0DLqrniY5eu5mfbpG5AxfdAukUjjmEtX8U1oWzip8z/oUfxnyGnf/KbyRgfl+6/i9h6ySgekpM5YyGgFWL8fX/YkatVS3IEEhShCsCoYRCtvOgkcaNmuKQQovPiIVY0+/LexWKA/hjIxnVOHMV0EOU8nslum7nNnXcmz96K7tq327D5SPBb07ighWSQim+RTsIaFZyayy1LKNZjM4dmSJGzC4XZjhUKfeQbu8sVPk7ad/jPAkLX9VurBLi5C8F9DmJ4PsM2PERLIwkwfoeZpptsnLvnukdiePf6CQS/UM0cwjAYO6cza5YIioZmfLWL8HxKwlDjvQI6zg6ECczOoqyYNW3gp2h8OLgHuTmEnQTGIEAyna+qhGr2bABRt7nit28Iooj8o9tw6ctv1/JbWjzNgoLbWRfNXjGFBVvWCn778d9Gsi+I1vXtiXt+ZPBg9Br2fAJzIglWcYlEFQM1a3nRVycvGNaD4e/Y1V5JGcoOGfz2Hzf+uxa+YvnFL6q4shLkWvrSU6b9BjrGEZbAWpZqGs7qIozGPxfuqc6MWNK8rple7LhpZjI46qMuUy6azP0wszk9bXUo0ljip1tr8gCve0jZ4i/OTHJFQlwwMSDZjV+qVHn7HB2c7rdcUQlkVvWPtU9blzecbumQCRsFbV4mXLwdGaOv6qGNh
 JU9Mgnx6
 kiBFlvXWs+U4xnOe/cZ6lSE99mM8h9sVi/4rih+HnEBrZfOjAmFm1ag9WGRAgRly/gdjpnRDW53Jv2orWfm3dd6EcufwZorTwWjcohHD70Oqj/DevdXLt23urNQ+b/UG+86nddKinZhUsvAO29QZVQGTPzfoxl+OUXXfYduhc7D2kyNHCuwjT81CznPBNis4u/AtHATPSQAPWVan19Vp2kMqtBWE3kG1w1sEEks8yEr9c/9mhKznIczRTHMbWCO0n6Tvm6yNOmXs/0kIXtMolVtBjclvbiegyzLtXx8ngWr3M/740JogODydbDZh5SgkNtWx0jQbZiBmagrxElD235AdMJcj6h/rQl+GZSPIvfV9jv3Q6pg1NqcQR3koe7zD5UtXocmtNQKOEiGrUFWl0hVPGQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kevin Lourenco <klourencodev@gmail.com>

Correct minor spelling mistakes in several files under hugetlb files.
No functional changes.

Signed-off-by: Kevin Lourenco <k.lourenco@criteo.com>
---
 mm/hugetlb.c         | 2 +-
 mm/hugetlb_sysfs.c   | 2 +-
 mm/hugetlb_vmemmap.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 51273baec9e5..07b182550892 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1342,7 +1342,7 @@ static struct folio *dequeue_hugetlb_folio_nodemask(struct hstate *h, gfp_t gfp_
 	struct zoneref *z;
 	int node = NUMA_NO_NODE;
 
-	/* 'nid' should not be NUMA_NO_NODE. Try to catch any misuse of it and rectifiy. */
+	/* 'nid' should not be NUMA_NO_NODE. Try to catch any misuse of it and rectify. */
 	if (nid == NUMA_NO_NODE)
 		nid = numa_node_id();
 
diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
index 79ece91406bf..4fd1c7566450 100644
--- a/mm/hugetlb_sysfs.c
+++ b/mm/hugetlb_sysfs.c
@@ -208,7 +208,7 @@ static ssize_t demote_store(struct kobject *kobj,
 		long rc;
 
 		/*
-		 * Check for available pages to demote each time thorough the
+		 * Check for available pages to demote each time through the
 		 * loop as demote_pool_huge_page will drop hugetlb_lock.
 		 */
 		if (nid != NUMA_NO_NODE)
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 9d01f883fd71..3c8389e8c5ff 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -746,7 +746,7 @@ void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
 
-/* Return true of a bootmem allocated HugeTLB page should be pre-HVO-ed */
+/* Return true if a bootmem allocated HugeTLB page should be pre-HVO-ed */
 static bool vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
 {
 	unsigned long section_size, psize, pmd_vmemmap_size;
@@ -795,7 +795,7 @@ void __init hugetlb_vmemmap_init_early(int nid)
 	void *map;
 
 	/*
-	 * Noting to do if bootmem pages were not allocated
+	 * Nothing to do if bootmem pages were not allocated
 	 * early in boot, or if HVO wasn't enabled in the
 	 * first place.
 	 */
-- 
2.47.3


