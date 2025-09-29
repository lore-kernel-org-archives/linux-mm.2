Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88FD8CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 12:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1C9C8E0027; Mon, 29 Sep 2025 08:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F1E28E0002; Mon, 29 Sep 2025 08:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956048E0027; Mon, 29 Sep 2025 08:00:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 851048E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 08:00:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 213D686904
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 12:00:59 +0000 (UTC)
X-FDA: 83942146638.22.153CD47
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 045E54001F
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 12:00:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759147257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=ePN+Vst+8RSfMgdAoB+6bnOGOnIYqMLzuA++D08llVg=;
	b=qDqulOj2P2mB0paHBLgdsuGqdpxTVGyh8M/u8BK5dxGOqegqysRV/1+gUrho5GkmoiOk/j
	2SZFnXxuOtVfIv2o8eFxz/20uTrneLWudO5jpiuXC5ntK4uyvskCOSJ2+q57TewVMW5YFj
	Och0lODTrmIDzBfg2YRg3JJlDPhaM/o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759147257; a=rsa-sha256;
	cv=none;
	b=g9C1V/R2hBtBKovSoc8UO2WJcHqJN2Xy44yBwkVQSYDdsL9AO2e6PXmjD9O5PfnLAUadT/
	wkAZAgU7emKo+/A1IZM4qD2dgA+JSWa7AXhfs7P2G1LmxAPIYQO6rn22r1IqAzGzIYAqld
	EZZTppFAM6AoGenb+SL2a0d4xDu3fu4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6BE7150C;
	Mon, 29 Sep 2025 05:00:47 -0700 (PDT)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9229F3F66E;
	Mon, 29 Sep 2025 05:00:54 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation/mm: Drop pxx_mkdevmap() descriptions from page table helpers
Date: Mon, 29 Sep 2025 13:00:45 +0100
Message-Id: <20250929120045.1109707-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 045E54001F
X-Stat-Signature: kgd6bxxrc86m7kzdf313xphb1prm4e6n
X-HE-Tag: 1759147256-101763
X-HE-Meta: U2FsdGVkX18F7A1rr7XiWT8XYhPILK1SjZdot5c/RgU5mB1FpQkLsqo72kBAmWsp3xDjOt5g6Cwkb7wWNdcGCeZ1PIIqg5A1HjGTVUPmFv18HV1BDrA1DRTgnOF45KYG8CkMP8yYI2jatG4nb6RyTNAkucfJrT7lY0rHRW4U/Wx4+J6xxKlaef0/1k2WM4ATIMF1qrpkn1+at2a2+5goKT588ds0lJdCm8q0ww276j6L4xGbuQ9dxKHLXTIe8EqsOkjZ+ty44uWZJ0BPzSwirzwEQOBofqNs4rW10CKM+6DSjYPdqgOYatfbt7Gnpp1KdNCEqUPH/neFURlVASUIc6fEvsTHnCtFY+1V2BuLks5w0ZgR5gYLTcfs1/oTWhT1HHZFtl+86v9oIaRcORvdqGXZZQNC44L4jIH1Qn1zzx5nuKaP64td/I5dKhXKMu6lretq1rKy1FL+UkdDzZi3rahHNibYTxfB4MblGpwPPiO1bXhUXcvV88tlj9GhURwGUnlwpiTKmR2RCSjcVz6BNUxCEEqV2Ajzas0FGedGSwYKvzlRk6MSUIupXiMOr4g8waMisBHFgPaDDeExgwouXfJX4z5kBucKhcpuZkUxf2rTU2Yg9pall+9nhd8t+5Oh/00bQk+EhkgWr4azb1Os/4lPAK+GbU4MqtaZ0hG7kEJQhhLg+/U0Cadl0gvZPdMl/d8hr/+qVX5nhQbE7fD3eSZrqYCEq0xwrv16ImrEXeyVVrRU6BJtQ24fzQSthEJvnQe33oJD5aprWRbcbb6IAYrN9Oauc78TNy8X8EZ/0bkoRrPWv6ksiywDfAKwmcQphqfvH/JRHcrfomW7F9fcKRIcExkAS61ike2SRGAE4lZPncythzgsh4mF6X7jSYuDqRZcD8ExeFBfMkyWwGsHIc1tXp9qF1owZ79tUNtsA9hNyvjuiSjpQosP07vqte4YE5a9CfqyU+8uuS7QCTy
 FwMerSxG
 /n25M+dUvzupRU+YHRpXyRaoqtXyADW89xV/UEks+prGUFfbjLuMCs0MrcTI9ypB7NYWzUh6WwV9REv+S9Ef+AHxCs7pUhDFMFIBzynQK+7uD9VpsOuxkYtZfdRhkeGN3z0diIGlDUZoQpGEmvfsYIt7REhfOdZ+oPRlJiL8cmGGJDU87G9XfiipcD3n5soijde4XiW8UYt0z/WSx8QrIZ7knvHmqxr7xOLuMb8gq6mpyfQ4InNpqPGyzJObYXOTIs5kZfIRmkoMt54zpKvcFtEOQH4VV7LdhjZh7fzyQvZE8iJvJaxLIo/di//nZ3plR/T6qhPqAWfbVybUIeU4nVCETj2C/cHhcEKCosIcztga0moVqOOlqtsyyUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove pxx_mkdevmap() descriptions, as these helper functions have already
been dropped (including DEBUG_VM_PGTABLE test) via the commit d438d2734170
("mm: remove devmap related functions and page table bits").

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 Documentation/mm/arch_pgtable_helpers.rst | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/Documentation/mm/arch_pgtable_helpers.rst b/Documentation/mm/arch_pgtable_helpers.rst
index ba2f658bc241..2447b8a4b08c 100644
--- a/Documentation/mm/arch_pgtable_helpers.rst
+++ b/Documentation/mm/arch_pgtable_helpers.rst
@@ -52,8 +52,6 @@ PTE Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pte_mkspecial             | Creates a special PTE                            |
 +---------------------------+--------------------------------------------------+
-| pte_mkdevmap              | Creates a ZONE_DEVICE mapped PTE                 |
-+---------------------------+--------------------------------------------------+
 | pte_mksoft_dirty          | Creates a soft dirty PTE                         |
 +---------------------------+--------------------------------------------------+
 | pte_clear_soft_dirty      | Clears a soft dirty PTE                          |
@@ -124,8 +122,6 @@ PMD Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pmd_mkspecial             | Creates a special PMD                            |
 +---------------------------+--------------------------------------------------+
-| pmd_mkdevmap              | Creates a ZONE_DEVICE mapped PMD                 |
-+---------------------------+--------------------------------------------------+
 | pmd_mksoft_dirty          | Creates a soft dirty PMD                         |
 +---------------------------+--------------------------------------------------+
 | pmd_clear_soft_dirty      | Clears a soft dirty PMD                          |
@@ -185,8 +181,6 @@ PUD Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pud_wrprotect             | Creates a write protected PUD                    |
 +---------------------------+--------------------------------------------------+
-| pud_mkdevmap              | Creates a ZONE_DEVICE mapped PUD                 |
-+---------------------------+--------------------------------------------------+
 | pud_mkinvalid             | Invalidates a present PUD; do not call for       |
 |                           | non-present PUD [1]                              |
 +---------------------------+--------------------------------------------------+
-- 
2.30.2


