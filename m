Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63ECBCA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 15:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FDFA8E0002; Thu, 21 Aug 2025 11:01:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6708E0001; Thu, 21 Aug 2025 11:01:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8142F8E0002; Thu, 21 Aug 2025 11:01:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 718458E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:01:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43C79116F84
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:01:43 +0000 (UTC)
X-FDA: 83801078886.14.732A4C7
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7E70D1C0021
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:01:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y8Sy9zCP;
	spf=pass (imf18.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755788501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tB+DMyj4Av0qeCkXneBazCG+Q65ylB41dq0xGCgL1iI=;
	b=cWPzcerSBGjOdvv1u8QJtCb3e96rLufoICn0ODk/8AZKLCp4vTAc500l+UH79A8aw5Of3M
	x74mAOq3On9FWTdrPqoXTssbZpw8L2NpDIkk45Cl/p1u4sX3XI+POWzzrC6YNgn6SjQ3y4
	vxr27bSLG8B/lLWNAuKAIeH5nlVIMsA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y8Sy9zCP;
	spf=pass (imf18.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755788501; a=rsa-sha256;
	cv=none;
	b=8qbFp1oUehUoJVAB1tCj8GfZFNaE+PSHOZJEwN13eknj+kbCOsYSDoeDhcAHrmy3nmZZk4
	0zjg0XfQj9Au1Oh56xtblw+7uY1cOkLkl8v1QNwQ+8W5YauKNbqtX7am66JF51GVeRiw7K
	IBwc9ET6ug+BV6KJHy9ObhAPqs25wkQ=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-70ba7aa13dcso9447136d6.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755788500; x=1756393300; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tB+DMyj4Av0qeCkXneBazCG+Q65ylB41dq0xGCgL1iI=;
        b=Y8Sy9zCPnNduMHIOp9AT4HdWouE52VNBwcB4X7HXWSINuKskuittDOUaMW6u9eJVWS
         ITDJYkQG5Gu8lTkiOH0dq1qaGBQvAcCdFy0WEAOf5y7MAOZYLlkPhraBRflnfORPp/CW
         lYcRKAbpBqKuioDh1vHdEqvVV7w1HUTp0nV7ImDjLAy8zBOtA9iM1++CSGQGckicrSgo
         i8N/I6oAbkT+FK9q6Qx1xYYoNtM26VZMUlH+niokRoovInHWzTaLDuAtqOKZYzAAR222
         QEYTMfgR6zV4en2yKHP2nYlTa3LbSA1jTr8FZVtuFHJMmFG5I+GYHqR7WoqE6KbSuz/S
         3wfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755788500; x=1756393300;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tB+DMyj4Av0qeCkXneBazCG+Q65ylB41dq0xGCgL1iI=;
        b=OQ98RrBEygeCVnU6n13nrPeyXtltUIx3+KsHFBG8M9cd/uxiKttH1sgkjplpqBSKdA
         dSkbmTxxh1oPR0LYXswiXB259qt+n8yF+qhrcUfR01Z94hbszw4ZPFkxnU6KWtagKx6m
         OgYO9io81PULNI3Bsjx2e2UskP5s/g3hEm1ICe/zQNRdliWB56SgtwFRTdT1B2AZR1+6
         xebuKM5fO2jDCvyKDJlyBQxOpndSSjqmxVIY0zffrZ0mA/Xh3zV7UmxsMl3AVth4o/bO
         muQ03pCWjHfVycfavTdmY06nafnoEnh9jjnPTU7QiYyQ8sdIJ51CaV18lMrgmXcGjPWj
         gXRQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/nwHamzri6EoZ0xZ/JIVPgyTchPGK42zsBehJZPzASckxf42zEOyoU4ffe3geFUNfsKTzY9VWIQ==@kvack.org
X-Gm-Message-State: AOJu0Yz0Zs1cQeNsiNE9jQ0VnoNyrtGUy8nA9K2CoJYFrIEUPLqu1coE
	xctxcyXy2CWtKHkwOevtlDtkPfDXSPnVj59AT+S1TJ3dipCsG16EVMyb
X-Gm-Gg: ASbGncthwBvCTZjSQNOHa32+wEUW1V0MTG0RptyibKst4w0HhiyGlpQcpfX0zqNkQGK
	4OQr3wDYIP44tbmITOq6ihIcYhPCQMzx2e2g6nvfB84TkdOqJ90OEfkuwW7QGIKQlQFOpucnoAM
	ZWbCogWB9hmdULZ+pnipRMPrW0rS7RNbDwYjqpQHQDvJmP4YrhzDIA0mbG8nUIlIxleA0xREcDb
	gI0bax23FYDTAjuXgmZBIkgtFM/UA85j+vSvYF4dV8HGdBWXj5gTpy+qPUSMAceRHc8f5Cmdf6C
	ryD+mqoCLzKxKtzAzwM3bWcWFS2auQxzSOxFG4m1uTa5R5BRyn+AK8+MTHPSc3u70PJRS1SjdIf
	GMb9WznTLny/uuqlmXHIWBRiyEeMf4A==
X-Google-Smtp-Source: AGHT+IF15zg/AFRM7X2wh5Ve8Kfa0vQKLUoVyNgZbfdhWi8ABlqiLpdgxK+l2N8gXQ3fMNSqs4kNqQ==
X-Received: by 2002:ad4:4ee9:0:b0:6fb:25f:ac8c with SMTP id 6a1803df08f44-70d88f6bde6mr32000456d6.31.1755788444609;
        Thu, 21 Aug 2025 08:00:44 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:1::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70bb3ddaadasm85404516d6.70.2025.08.21.08.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 08:00:44 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH] mm/huge_memory: remove enforce_sysfs from __thp_vma_allowable_orders
Date: Thu, 21 Aug 2025 16:00:38 +0100
Message-ID: <20250821150038.2025521-1-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7E70D1C0021
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: uuf1w3e8uccd1gx74jrirgn1j7go134d
X-HE-Tag: 1755788501-420470
X-HE-Meta: U2FsdGVkX1/Igq5Bhg7sehNMKx3sE4liFXAcaL6dAgaSIRWOT25mWW6KprsTJrcAJlYahdzxHZf1ndKUQmn+7zY2v3QQQKIRl73wPBrxM7H/t46d+WSOvN6ji0zqLAJkW9EJxegnN2ax+AnizspHbL6luBxpNS332QbOglRCsEeq43+77qgelJGMPXNIEbLwNzbrc+Tq4Bp7uXXfQNJf6hpq/i65wQwFZhNDk8XcM8IM+IhTp23rOWzblspZtJjCATWWDcl54I9JfOCO7ANx87RgTsr8CZ/aPuZlRdTcfzcidib9b4ILWoxxdhqu96IqAjOC0/W1iUnTc9yEC0XU8tE8xeF6PngBUsKHEV/6iSeoPtHmGwot6lD+MaOFR9fGrmuyFIKYCNb3j34CNHBXtxdV6cCUHgGWBHPNQt87cCMvGFqdPzxcb0pwpNKaq10aY3H8U1/LY6Jh543Opz+NS1a1qgJvRsiHqkFrDtROLwci+ZolSz1jMf9QX6L87Z7S+BjB5RkyMFkatEqXNbn7Of0lr4V0DlyuJnnsX1WaLFk4m1NIhz6EVFVmOGSpFsYthWOxuilDOI0glBMsDk8OF3UUWgG1jREkXY/sKR+2Sm8EXd2rEUBc0Cws6IpU7sUhHZmZp6INxYPSrmpIz22+aQKBlUpI8I4TtQk/R0RVsQ0bgkVdO+vr7Z4pm/wtZV7Ztj7ndSJ274uCbQ5NCA+DL0JqCT/L9UTsTErlljOifUvWcgLrmOOBV1DK5y83xwrfHrB8PpcJUE+BywcuAp7qAuzHWnwmNcnJBbWv933GnVDzpTPCB2X1RgRb7VgR8bV9qQrr1PfFZDkU1/J+8ImSXb8vjFRhCpD9UFrIBIYSGvfOIOSYtuGp8nOyrX8WzAvSxvZtO50M+izKNyfe3WTerSUU/7S3YOCc9AVFrc1XRhNcjUofbMd8IxhX3laPNV/l17yL4DOwxx1Y6hPty/L
 FNbHmtOL
 dBgQLm9tiYn4X0aLR5V+VYhg48tsKIyNRDBnQTjDVM+ysKpI1MbX7cElmXehX3bhZ3bgfQwdfFG+oyz2GHYUhCKpDrqXkiSu8cmvdRoqdZ5uWONRguaF1H9M/nce8MxcbzJPTPXufLzQfhAXbbI/CXGgc/C3FsMOkTE4qRhONXmO9zIZ+zd7CBAntrJHBYXDNTl05yqIrIpCBllN05b+ap8MWVQ1/6h8kiSvdn3GIhisinHPvGKXzzaKKMsRqCQ/nwVs7ff9Huu/G4PMjegVuc7YPP+g1bpWcTEbDhkORNF+nldiLcQ/RM2ODXNQS/bPKxz0GACjSjgs2M3T1zoN4hPZI9QQv0dXAtDFpB3+GanK7cHHCTFR7Gm7UWmKLLL2JX/+Gm/3t7p4PJmov7xBIj5+7OTQ5pfE2B2v7d/BBaR6z1ibIZij5gA3csA0SvWHvv7W6SUo9NOf24Unf0CPQNu309IaJylk2/k8vrNSVJTmHSL9urO20tZLKOXFW7NWuoXXEagGAfStr3yf3tSBbalDNJl4ztfqZlu4z3DAsqErxx5nA9df+XmIrRc9IY9bNyddDIpsn5B6ruMiy0sJsrQQYaMBwvlAUV5ee
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Using forced_collapse directly is clearer and enforce_sysfs is not
really needed.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
This was agreed upon in [1]
[1] https://lore.kernel.org/all/cd99f0f2-260d-4494-bbf6-99daec3e0683@gmail.com/
---
 mm/huge_memory.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6fd714bd04844..5220dbc9fcb31 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -105,7 +105,6 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	const bool smaps = type == TVA_SMAPS;
 	const bool in_pf = type == TVA_PAGEFAULT;
 	const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
-	const bool enforce_sysfs = !forced_collapse;
 	unsigned long supported_orders;
 
 	/* Check the intersection of requested and supported orders. */
@@ -168,14 +167,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!in_pf && shmem_file(vma->vm_file))
 		return orders & shmem_allowable_huge_orders(file_inode(vma->vm_file),
 						   vma, vma->vm_pgoff, 0,
-						   !enforce_sysfs);
+						   forced_collapse);
 
 	if (!vma_is_anonymous(vma)) {
 		/*
-		 * Enforce sysfs THP requirements as necessary. Anonymous vmas
+		 * Enforce THP collapse requirements as necessary. Anonymous vmas
 		 * were already handled in thp_vma_allowable_orders().
 		 */
-		if (enforce_sysfs &&
+		if (!forced_collapse &&
 		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
 						    !hugepage_global_always())))
 			return 0;
-- 
2.47.3


