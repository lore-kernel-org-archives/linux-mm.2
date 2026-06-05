Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF23CCD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F42C6B00B2; Fri,  5 Jun 2026 14:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A44D6B00B4; Fri,  5 Jun 2026 14:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 192556B00B5; Fri,  5 Jun 2026 14:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 025E86B00B2
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:35:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C42541C1223
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:56 +0000 (UTC)
X-FDA: 84846713112.28.A6DCBDE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1E14440013
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RDp1KNMz;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WPKtkl44aSyXLvNV0tx53TGY2duqMQJ5kATLVHTv48Q=;
	b=eXAenbi9dGBGPI8fB5oBsqUiBPZ8RmO4rV9DTV4U6yqUVztxgx5fyflZyEmhfFS76G4KOH
	6gvb3CuO5e5cWp+XhcHzpXryw0uAA0FBbgiHEm0eB7yUgnj8EM386wc4Fbud+huQxKB9x5
	eww32fOS+EAQZkxJs/jkkvmjH77tYUU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RDp1KNMz;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684555;
	b=WpQbORzjwIwQMbytj6WsuSm9K2/9LEYotfNB93uhgnm3dKBPSbPQgY6s+LUav4CbS70t1w
	d07t5fqbnKhEm6s2C0MbaLG4J83dBDyuf0WXNnp66YKCLVFzyFMy8Pa+zf0SRNL0QnnbxA
	Y7cs9zcagmEGopI11lecve8+r3G1Cdc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6622C40E28;
	Fri,  5 Jun 2026 18:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AC11F00893;
	Fri,  5 Jun 2026 18:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684554;
	bh=WPKtkl44aSyXLvNV0tx53TGY2duqMQJ5kATLVHTv48Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RDp1KNMzreXggo/k5UN4yM2Vg2nlZmZX0Wh5BFATiEUCiYt/OzIlMXhoid/ZuvPyN
	 o4JRp+ybptcE3KR0SR3U/GQFA/Br52X8PwyfyCE4K3xKLiNjlhROn0yP1az6fS50Wn
	 bckAsmKkXRIqSnpu1yJiHqNZVyowEnPJ10728SdPQGvjnMmzM9y1joufJMK910774F
	 lRXdWbT6mcNbofW9uEe0x5g2GSQFs7sdkzA/1xaMKVz39RhPwDt8/omJg0HDymZ245
	 xuO+UITtPc5kwdHIQEnEVE5tMo1s3yjeCbPEqych8hP8XehChB+QxjwGezXjXy/QBP
	 zU6rKaEGZ2Wig==
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
Subject: [PATCH v2 17/18] memblock: allow calculating reserved size by flags
Date: Fri,  5 Jun 2026 20:34:50 +0200
Message-ID: <20260605183501.3884950-18-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1E14440013
X-Stat-Signature: 15a3db13jhudko77618uo3p97azujtsx
X-Rspam-User: 
X-HE-Tag: 1780684554-348386
X-HE-Meta: U2FsdGVkX1+cQXm5vpj+uw4p39Gvqo1x3K7DuiJVFxL0844h2uKjPN8NrNRkMrOH0MZcAlM0vt0nUVBKjtcwAUVWZ0o++dTGfIVw/4utX8dlQtwXizVyc9+thXihwMHg6H9qYtd33YkA8yi3bwlkReU+/kUTXwe1hOH3Zv8eVmba2s9A188KFdvPtmWM5+KngPuGqG/ig2k8EFRRk+P9nT0DcvFEO+ZnwhrmG0mZrSVH5QoKbZZvICYjvIh6/KJ/5q4fTS6pn5ZpGP3TVc+XSi1u+X7zp0LtfT8TTq5rn26tFUS/LeVKNlV8ZNxJuVUVJvoXgA+zSyF++0GE7bcWkcNerFdyhdC4qL2PgpG3aH9cGTwKz/kYY7roJDn2VKsicR1uqzqytALdfwiqLLY8WSYcZktGfXXZpIzZrpy6WeU83RbiW6LGp7VXkeDPGcn4HLB4VwIpS24YMAvlUCXwtv/yNiJDbNqvEInj18k/eVJi5CIAn3LuqWAoLZkhYkJfFV8YPhloAzciLvD+ByniNZ7Ll7Ym/tK4L5LLcWNDmua2N9z5AavAecrRYoU5nybPPidmU2gIWXL4V3bJsWIR1g9Au9ljlbHTCba7APCYE2fwjLwvNnPwRflpV6meQI1VagigWZsazdToZ9IO9MsgVLXHEyfUAby5j9yUa40lQ37ewR4/AFhLgitb6JbqgVgFTYYCXv2Hc0fx8Cn2lZaTE2chhx0+Vx++mQ2CmYQ3kg/H9UwiDcJXGBaeRl1Ws5DAmg7zb54/Kk5AUKu/YssCXy2vjamEXMKyxI9W2wUId2Krt8o8nUhpEsijMKuADW1u4EEnBTxUDBQqXCJ+Gp30gRUy2add21fzUFgShBsUtWp4DWAmXNxEIG2TCkV8/DB8HvOjkmjgKS+wRXV90DlNuEXIMT7Yq6kQdDR3HDYGNluPXK2w8u7YhagtzAqbYQd0diPVmkZH8qiCgRMcw9b
 0C6XnGYl
 NMBe/d89kIXsHssiMJ665T3dsrb6Ocd21KjdmgyWdMx6ZYvA27T7eV9rNge6HH/+9vJcU+dWPMSnGKqVy/3fJhTS2qg+0kDcUnPMjXtIlmgcT2occe8ju0cAu9T0vU6nlQUE3oUFE9A2RHkQGy5WPmjD3OrNZiqCwughNQ3BWKAKq0nCx0UoFU58BuYMiKpPH9yWHv6GlBqIWa2B29Utr/fmbkJXJ6Vqh+9alQeHo2zwoW/bPjZtJnb8859Wj79VSXB1uZFP0loKmezU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

memblock_reserved_kern_size() returns the total size of all reserved
areas flagged RSRV_KERN. KHO also needs total size of all reserved areas
flagged HUGETLB to correctly size its scratch areas.

Refactor memblock_reserved_kern_size() into
memblock_reserved_size_flags(). The new function returns total size of
all reserved areas which match _any_ of the flags.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/memblock.h           |  3 ++-
 kernel/liveupdate/kexec_handover.c | 14 ++++++++------
 mm/memblock.c                      |  8 +++++---
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index b3b4a6145fad..a3b57066611d 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -487,7 +487,8 @@ static inline __init_memblock bool memblock_bottom_up(void)
 
 phys_addr_t memblock_phys_mem_size(void);
 phys_addr_t memblock_reserved_size(void);
-phys_addr_t memblock_reserved_kern_size(phys_addr_t limit, int nid);
+phys_addr_t memblock_reserved_size_flags(phys_addr_t limit, int nid,
+					 enum memblock_flags flags);
 unsigned long memblock_estimated_nr_free_pages(void);
 phys_addr_t memblock_start_of_DRAM(void);
 phys_addr_t memblock_end_of_DRAM(void);
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 8540608b8602..b3c33f150e85 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -749,13 +749,15 @@ static void __init scratch_size_update(void)
 	if (scratch_scale) {
 		phys_addr_t size;
 
-		size = memblock_reserved_kern_size(ARCH_LOW_ADDRESS_LIMIT,
-						   NUMA_NO_NODE);
+		size = memblock_reserved_size_flags(ARCH_LOW_ADDRESS_LIMIT,
+						    NUMA_NO_NODE,
+						    MEMBLOCK_RSRV_KERN);
 		size = size * scratch_scale / 100;
 		scratch_size_lowmem = size;
 
-		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
-						   NUMA_NO_NODE);
+		size = memblock_reserved_size_flags(MEMBLOCK_ALLOC_ANYWHERE,
+						    NUMA_NO_NODE,
+						    MEMBLOCK_RSRV_KERN);
 		size = size * scratch_scale / 100 - scratch_size_lowmem;
 		scratch_size_global = size;
 	}
@@ -773,8 +775,8 @@ static phys_addr_t __init scratch_size_node(int nid)
 	phys_addr_t size;
 
 	if (scratch_scale) {
-		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
-						   nid);
+		size = memblock_reserved_size_flags(MEMBLOCK_ALLOC_ANYWHERE,
+						    nid, MEMBLOCK_RSRV_KERN);
 		size = size * scratch_scale / 100;
 	} else {
 		size = scratch_size_pernode;
diff --git a/mm/memblock.c b/mm/memblock.c
index 131e54dd5d8d..cc21f877cb67 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1893,7 +1893,8 @@ phys_addr_t __init_memblock memblock_reserved_size(void)
 	return memblock.reserved.total_size;
 }
 
-phys_addr_t __init_memblock memblock_reserved_kern_size(phys_addr_t limit, int nid)
+phys_addr_t __init_memblock memblock_reserved_size_flags(phys_addr_t limit, int nid,
+							 enum memblock_flags flags)
 {
 	struct memblock_region *r;
 	phys_addr_t total = 0;
@@ -1908,7 +1909,7 @@ phys_addr_t __init_memblock memblock_reserved_kern_size(phys_addr_t limit, int n
 			size = limit - r->base;
 
 		if (nid == memblock_get_region_node(r) || !numa_valid_node(nid))
-			if (r->flags & MEMBLOCK_RSRV_KERN)
+			if (r->flags & flags)
 				total += size;
 	}
 
@@ -1930,7 +1931,8 @@ phys_addr_t __init_memblock memblock_reserved_kern_size(phys_addr_t limit, int n
 unsigned long __init memblock_estimated_nr_free_pages(void)
 {
 	return PHYS_PFN(memblock_phys_mem_size() -
-			memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE, NUMA_NO_NODE));
+			memblock_reserved_size_flags(MEMBLOCK_ALLOC_ANYWHERE, NUMA_NO_NODE,
+						     MEMBLOCK_RSRV_KERN));
 }
 
 /* lowest address */
-- 
2.54.0.1032.g2f8565e1d1-goog


