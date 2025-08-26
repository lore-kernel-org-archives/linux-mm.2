Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFDDFCA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:19:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 240FB8E00AA; Tue, 26 Aug 2025 03:19:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1CE8E00A8; Tue, 26 Aug 2025 03:19:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107C38E00AA; Tue, 26 Aug 2025 03:19:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F37938E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:19:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66C181A0698
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:19:55 +0000 (UTC)
X-FDA: 83818059150.23.844D3DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C3B4B140003
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:19:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sdgKK5NM;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756192793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=s4MfRbOx/PfJdqzudFixXlPsu9Rk1LL03ujYMZgklIk=;
	b=GQVuLsZJLUC9Y+SMJGF/OT25gD80sTkSHp+EyTmwe81mtcfXzn4+HPGqN0nPfxFAhG+K/I
	YfDi4j6PQ07VKug0fB3DWRs3PN7guQ6yhPKLuAULzVCmFsh6VgzEW3snjkV1jLLon+n5D3
	AGHyHcmi2wWRmzVShfqONbCt3PTBBQc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sdgKK5NM;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756192793; a=rsa-sha256;
	cv=none;
	b=LpRot6r9OIb4DYLfsaT+peVFMMCt0mleS5gd0BCZ+5DN40mQeXBDyVppzQQsbySlPUhBiS
	cPs5n5UtmWjK8SmSUaQvTKbA6PHDTVdgzdFzQQqIt+uFZPam+qv4J50Kd7qzRqLnewGFIW
	SCoI5Yhc/TJchIFxxfIYLgn2EgZRTsI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 792B1403BD;
	Tue, 26 Aug 2025 07:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C343AC4CEF1;
	Tue, 26 Aug 2025 07:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756192792;
	bh=+PZJcpckpQZWq32DLv7x5km52DGDqx/XmxaGBNY8ZqU=;
	h=From:To:Cc:Subject:Date:From;
	b=sdgKK5NM1tDNEgsXTnvq26XugvjucYJ4kit5xOKN5Wgc6IfvlszRa9kW/Xm7LZp+z
	 LQxaOCLPZ2w8VapMKHiCS5KgiTdoEg/i0dvwuLrugGUrkQiMjcFrJCS41a7/dOdr+6
	 B2pWCbGoPveA9UmX1RheYgCyXtac850SQ1beWjkinM+m3x6Nd9ll8qQfTYzcXHpSWH
	 1J8scG50xjhxtgfxf3oESRFjWKdUeexMU20z4ZcW9yjlKb86572kU4Zpv9XFiIqdT4
	 g5wOD3VYOj97N0VjdfQK0coteGLeU2+/lhfhEdGFuHKNFX2nraAaMrtuvR9Ko3yO3o
	 qtOZzpNkIVjfw==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] memblock: fix kernel-doc for MEMBLOCK_RSRV_NOINIT
Date: Tue, 26 Aug 2025 10:19:46 +0300
Message-ID: <20250826071947.1949725-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wb5c5cgtxrm6z6u65g5gffhj1tew6nrn
X-Rspam-User: 
X-Rspamd-Queue-Id: C3B4B140003
X-Rspamd-Server: rspam05
X-HE-Tag: 1756192793-123946
X-HE-Meta: U2FsdGVkX1+Ph3qsWkJg7ibcnGnGUWc1h+b+4YfpGnczLOaGOVefPS8KgbBjGneYwur7tPZXQUAGuEu3lqcdDw8qyWfkenViwOOVZI2+ttePCsKp3QwVpnul7QjClFvO6koZcwK2XurhWf3s6Es4DlX7IYE1ZitCrkievfbDN4xwR2Kxh0dksDHxyC+JgPeSfLVJPUASANV/3Bjx0POU6wT/9lels/Z9IcXeMQyLq/Vt5hDfcozRTe89ge967VFS/JlcSukebnl+thrH+reamlnESuwJzqeP1a1PRDfjPRw6Amllidxm3/DUZHxlrRqc3aKWd2mSFf7Aq42PwnrZqFUfszHubAGs5I88rCG8MUAEFlT/FRO+3znq7IZQ/dsFg/JkyTcZ0v7C1/2KQhHLRmnEwHCGnt32j91FTtrNEwpt058sh3K/0m3qBeJWfqG+BWRevc+ngcf7Yx4fiYr0qjgRZiCnKuigH19oB+28xZg2BzCsrBfqTsuZql6TFeti+CcA3UVZ+x4kFuKssHUe/acjptpd661mfa5DY5zkvRiLK27G7Lmz1o1P6CvKP6FP72hzNSLayIwEJJKOsBLngVKr3yJnM1GY/ko38E2UKMu0quc9k0Bnk+8EoOia0U4pkKhUDkdr3ae4p3czVqb1uhnIJvaD1/wyWZF7LBRy8o8ILxKN3ayacoz88ZJWIp2MfQOakBI+GBsGnz0gz3llhDnxEI6w+f8vzZCBBw/bnWIjgLkf85DELJf4xyFxeL4legLCMQ0Pg4I31j0HXBNDcSwFKPk7QTd/Np6/Evlx5fYuyaJw0Hhuvc8lCzGZmd205zixBrf9ExehrE0Czu195RTtYSl3ezgs1lqRLjCuzGQI5dwLRRuKoBGZoKi5Ky3iYrcbqpcPiRzXPT5zCRGBsieYmV6YGLRaJ8jtOoXIrJqKkhY7pcHLLzwYTI1pmFV07Cps/ODwqWag5k+mahv
 PeBGkmpa
 ZHBmv4J6vTSzQQlLBO2cDtKOTkRspgzPatg+6DNoeBOaoCPZjNoqLEcRnqKf5uddnW/SEEDd+90WkSOrj8hH+jimHp5ItR9jlnN1BeYa507D5kwMfae3EH8JogCmJtQQoeuuenxkBhojLKC406nA2PP3pLyPSdJ7Eh7uSHV44xr/0Ipjxvw8weSUNDYmscBTRlcYeAlLmmhdIob8VHD5Kt6ZF4hyFCUaAiA5SYQmshwaA8NAWnwdLVDaVHmKiLnOPORa4pmoQdsu6kof0xc8CiNLfmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

The kernel-doc description of MEMBLOCK_RSRV_NOINIT and
memblock_reserved_mark_noinit() do not accurately describe their
functionality.

Expand their kernel doc to make it clear that the user of
MEMBLOCK_RSRV_NOINIT is responsible to properly initialize the struct pages
for such regions and add more details about effects of using this flag.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/memblock.h |  5 +++--
 mm/memblock.c            | 15 +++++++++++----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index b96746376e17..fcda8481de9a 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -40,8 +40,9 @@ extern unsigned long long max_possible_pfn;
  * via a driver, and never indicated in the firmware-provided memory map as
  * system RAM. This corresponds to IORESOURCE_SYSRAM_DRIVER_MANAGED in the
  * kernel resource tree.
- * @MEMBLOCK_RSRV_NOINIT: memory region for which struct pages are
- * not initialized (only for reserved regions).
+ * @MEMBLOCK_RSRV_NOINIT: reserved memory region for which struct pages are not
+ * fully initialized. Users of this flag are responsible to properly initialize
+ * struct pages of this region
  * @MEMBLOCK_RSRV_KERN: memory region that is reserved for kernel use,
  * either explictitly with memblock_reserve_kern() or via memblock
  * allocation APIs. All memblock allocations set this flag.
diff --git a/mm/memblock.c b/mm/memblock.c
index 154f1d73b61f..46b411fb3630 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1091,13 +1091,20 @@ int __init_memblock memblock_clear_nomap(phys_addr_t base, phys_addr_t size)
 
 /**
  * memblock_reserved_mark_noinit - Mark a reserved memory region with flag
- * MEMBLOCK_RSRV_NOINIT which results in the struct pages not being initialized
- * for this region.
+ * MEMBLOCK_RSRV_NOINIT
+ *
  * @base: the base phys addr of the region
  * @size: the size of the region
  *
- * struct pages will not be initialized for reserved memory regions marked with
- * %MEMBLOCK_RSRV_NOINIT.
+ * The struct pages for the reserved regions marked %MEMBLOCK_RSRV_NOINIT will
+ * not be fully initialized to allow the caller optimize their initialization.
+ *
+ * When %CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, setting this flag
+ * completely bypasses the initialization of struct pages for such region.
+ *
+ * When %CONFIG_DEFERRED_STRUCT_PAGE_INIT is disabled, struct pages in this
+ * region will be initialized with default values but won't be marked as
+ * reserved.
  *
  * Return: 0 on success, -errno on failure.
  */
-- 
2.50.1


