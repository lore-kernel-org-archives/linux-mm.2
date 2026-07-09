Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB4C0C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D970F6B00A5; Thu,  9 Jul 2026 13:39:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20D56B00A7; Thu,  9 Jul 2026 13:39:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5E316B00A9; Thu,  9 Jul 2026 13:39:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 941576B00A5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:39:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 80A3A168582
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:25 +0000 (UTC)
X-FDA: 84969949890.14.A35EFD4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0279840008
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a+g1M1oD;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618764;
	b=Hk9yQ5KchU+wRQHI8Pt8JmAX+wfng9gRrtbAHMXPBB3oqMaED2anLh9Pez3S+wTzRg6r92
	XIF/8paZBysPnf4V0XcIu/ez1DuKX4umAMo8ZHCIKTIVN8xZgBl08z7wNjtUSss+pie6l3
	M7cEAw5aoSwa4fDppLTMw38FCJpIkaM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a+g1M1oD;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GIKLTijiKnBgrZXcLoBE8VlZLtn/daTEtdVuzKJ4kpE=;
	b=noWhZWWa5Jdax20MQyqBkr4Lg4rBcYluuNu9wcpMtFzOFoi4lg38ycqRd+KymS7WmFvjK5
	YeKpQsgPCaOikPmMpwibMeWZdrXnJq6QTXOKIi9uTU24IPSR67x5tgGHUdg9Mp3/lTSQmd
	Mu7iHwL4VgNFNPO5q5LmVhA3n0yMQkQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F83561381;
	Thu,  9 Jul 2026 17:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22EA91F00A3A;
	Thu,  9 Jul 2026 17:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618763;
	bh=GIKLTijiKnBgrZXcLoBE8VlZLtn/daTEtdVuzKJ4kpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a+g1M1oDufFBFZydVBdmxrJjcJaTrBCkRDeT/XIBd08gpl1wEoGlOx3f13NjoUa+p
	 wz1WAATyzMrRkjhi+H64P2b6Bzm83+JmjSoyqq1LWfsOI76/LkKfRC7DG69mlPIv8C
	 tkjd7rX6MvY6qfRw2mP3UoERGmt27c201PhOHzc/tgA5jlTaH6HQQproNWA9K3dT23
	 sWMjZ34E+MFNA4NmEVtItaSSytuQQNYhNbh63AB7+CWuLCogtgGuI+eO25fU1/s9bl
	 dsjc4ZcnKzfO3y3E5gHiFsAhhspI8y9QvbfVeO6I1/SL/7jnP1yjS/dQnLYUszCTZy
	 EpVxJLH7hSQpQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 20/21] memblock: add memblock_reserved_hugetlb_size()
Date: Thu,  9 Jul 2026 19:38:09 +0200
Message-ID: <20260709173821.429921-21-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0279840008
X-Stat-Signature: wfm1pcusr9864e8pinuk6fbgruo7e1fk
X-HE-Tag: 1783618763-394831
X-HE-Meta: U2FsdGVkX1+cGchmwFotB/sQcWoI39rZoTB9RwrJpQi+1zkBtHeIki41RVgcB3o8CTVze4Y3WQ2sWfgaASLgMmo9wph8EPHhguy4LsuQ+racoxWg5vtR6gx2J+pxlOGItymL9SVR/Ff98ycnxCjCn6uFTmNfhTIuwEJVd65FE7Dx9oYT1HfAQelCzC1FtrUTlhrJdF36Cn9Julk1idGsyebyknbpb3Va6k3zRdeCfXeLdZluE3v/5IC4OJKivt6F5vQIi3RbylVr6EpagV/0GKfpDsMpS3q+GlaEX9modVQW7PTfvKCZku7ypyKhugY4St4KWu4lqQRjB7vldkpnkz7YkkN08n3hGXcmv/8olQwCL0tlTcVkSo2TEHFN5uNyBZwemB11fJ751+o2znFZwFXIM1j2EkwGtrUsXrh3Ao4Yn7ZdEusVvu7L5q6Qb7OIgiBLGdkTybgY6KfvPhrewVwpt+/c2S7oK1lKzJA4nrdaGlUOQbusOwqX848Dy5FWnREnZ3Cwco9BKiczahzaEeZUnOCHLyURyLBMsPIQObhQZN8n6k3tyBDMYDp8PJIlrbgLTeUHP3RjjU46A239PxEIodj1J7S4A75YPjrIxj39YoBNf7hnI+hvFq3TFDn3egD+0f4oK3sIyyUo6LZgvMS8n7Po+4pbRj6jSV63AvuGqXTbRZwvTrreGaYx41psSufjPYixLe2vp6Ngou4Zkl6QyRWMcKZrxuKU2ekrGMnoWEGz0NwC19t250daHIzp2iLMJEqHVFaTfYfNykHciIWnaUjZ2OGrRw6jK8rTnSZQ93unXO1Ss+p4fxOXkRfSIbbZ5W/bIPRlZ/UyBzri34qOuOUb2IZSR3taS8YpWh64ohnClh20fEeUExtNHB9EjWc1qnBYlXbFJh3pnCzQWHk3BZN0PweccSnCUoAAG+61PNi9jx6xDp9rifDOVwx+SX7f7s59H67ldaDXoEL
 7IW0w6C7
 Tyrd8ADFeSsEiyuHAQjThLAgXxY4Nl0qgQxgaykVGnXwgeTSSkUcbNMv7c4Ajuon2Q0pzAM1qaipP8cL7EbLYgCqeUxg18+PJUPVkjiCm4FEdrTamMmcTR7Ff2PrCeXPPc54o8YF2o8xGFqsL3v3rYKizsRkMBALzLj9wJVQ6DrqPd+pMzHfDiMqkzI8h/VS0ykkBpGLbRc++Pfi/IN5eXfQLPycZk9TwKdHsBqpqmjvL+lxbH/zqPH37bW2epGilmKmUmt02Z9/cgMR+Dy2TVehAyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Similar to memblock_reserved_kern_size(), but calculates only the memory
reserved for hugetlb pages. This is needed in an upcoming commit that
subtracts hugetlb reservation size when computing the size of KHO
scratch areas.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/memblock.h |  1 +
 mm/memblock.c            | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 678fe466529a..d62db9e776cf 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -487,6 +487,7 @@ static inline __init_memblock bool memblock_bottom_up(void)
 phys_addr_t memblock_phys_mem_size(void);
 phys_addr_t memblock_reserved_size(void);
 phys_addr_t memblock_reserved_kern_size(phys_addr_t limit, int nid);
+phys_addr_t memblock_reserved_hugetlb_size(phys_addr_t limit, int nid);
 unsigned long memblock_estimated_nr_free_pages(void);
 phys_addr_t memblock_start_of_DRAM(void);
 phys_addr_t memblock_end_of_DRAM(void);
diff --git a/mm/memblock.c b/mm/memblock.c
index ba6d887ea18e..c10dfb054806 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1893,6 +1893,28 @@ phys_addr_t __init_memblock memblock_reserved_size(void)
 	return memblock.reserved.total_size;
 }
 
+phys_addr_t __init_memblock memblock_reserved_hugetlb_size(phys_addr_t limit, int nid)
+{
+	struct memblock_region *r;
+	phys_addr_t total = 0;
+
+	for_each_reserved_mem_region(r) {
+		phys_addr_t size = r->size;
+
+		if (r->base > limit)
+			break;
+
+		if (r->base + r->size > limit)
+			size = limit - r->base;
+
+		if (nid == memblock_get_region_node(r) || !numa_valid_node(nid))
+			if (r->flags & MEMBLOCK_RSRV_HUGETLB)
+				total += size;
+	}
+
+	return total;
+}
+
 phys_addr_t __init_memblock memblock_reserved_kern_size(phys_addr_t limit, int nid)
 {
 	struct memblock_region *r;
-- 
2.55.0.141.g00534a21ce-goog


