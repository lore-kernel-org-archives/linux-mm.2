Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D677ACCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 06:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEA436B009D; Fri, 16 Oct 2026 02:17:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1546B009E; Fri, 16 Oct 2026 02:17:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD86A6B009F; Fri, 16 Oct 2026 02:17:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 733256B009D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:17:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 589A71202CA
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:17:11 +0000 (UTC)
X-FDA: 85327481862.22.43CD0C7
Received: from mail-pz2-f7.google.com (mail-pz2-f7.google.com [74.125.228.7])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8D4D0C0003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:17:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ie5Iu1qv;
	spf=pass (imf28.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.7 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792131429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6w2trImMBsUXcJxF+8CP2LmtHij/l89KoLcRCpS0ni8=;
	b=pu57XW63BOWicmLjTAGn1enJNFdlX7MzqKhEmZZjYNbuprNa3ebkH0PGML3PuZ821PCHqX
	NbY8dFelQrSVVSJdhzi+l+25y8++OSkBsAf/WOEJaB4sHdLW3R4EMuH0fU/YrhJ5fseN1Z
	yPyx6Z1EdMgcPAyVG595SCS8ibcyeks=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792131429;
	b=4k9THARDlw3FCKRjUdK6wd7t5Ec1GqShBL0dcJjUC0LMlM6Zx1hpY6NddMfgmNuH2Y4VUv
	n+VPAFVouMDsXW3ErOBMOhHKygQZGQrsh76PwonfV+Wq5cCy/I96u5FiMJG+0cEckXW+87
	IQq5NA9Ry/B0YO6fzR5pEMWZKDi2iak=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ie5Iu1qv;
	spf=pass (imf28.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.7 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f7.google.com with SMTP id 41be03b00d2f7-cc7c6cc3513so836497a12.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792131428; x=1792736228; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6w2trImMBsUXcJxF+8CP2LmtHij/l89KoLcRCpS0ni8=;
        b=ie5Iu1qvEUkXw30Hk+eRd5TmPtl35DuOM/G34jylkdpeLRNMtXnp29yxcz9u8jy/xo
         bVTCJ+Toy1AJgau5cMlUQeAvgWdYE0gYiHTaXEYk4QVRwzv8hwm2/LE5VgI7CWSJ8MJV
         7Md4pHh/Xw0F0hustPIMG8TmV3+UH8BIwbRr8Ycs9MQlacLzehtoQZTNqcF+PWLqS1dG
         zOGnUslTAxNxkZxG5ZLytw6HVwG2iH0vEtTTrulbLQTALx3aMtGiQmlnmXhKz8Ol3wzg
         8vdj0jb5YgpWH3m9brJW6924OMf6ftNmstZAB2zlR7JX+Oy4JgFmc8KxUf5jK9BNIj5f
         ObEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792131428; x=1792736228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6w2trImMBsUXcJxF+8CP2LmtHij/l89KoLcRCpS0ni8=;
        b=p5Z7dFCLl/J4fyoGQQ8N/2ceNjtrqShoUtw3ufKEn1aZPi/1/YXX63dfdhP5T00dao
         TVS5lLWWzAbhN3fTxtGUIRWunz/Ej9wZcJrAOqkK3Xwv59YAxsFaAcL1AEw1MNDEa1Yl
         ZnqsFz/OuVPcD5uEpEby7iqi4sgp+nKOtbonmumgPt4SlqlAle/4xHKTqriA3qu9EOa4
         Ko8IMKPalYYTl+jSlTFzLpC2yXaS0gfFkFkMpFiRrpEZRu8E73y/lBgX71+b7RsBb5Ob
         74Yb7ylvM5i/GWvuaqstBZ4qvR1i7AGcq0Lt0xJoDVbre0AZzfFYvg0NOAVfCHR4Fcvc
         mTFA==
X-Forwarded-Encrypted: i=1; AKwUvByEsKG4eArpZ8NybEDuqwglCHM7FcdcR3PZXF2BJ+2/By5BTvdF6vFmM3S6wNTA1wIuazhSTTLYQA==@kvack.org
X-Gm-Message-State: AFq9FYJ6vn7i9FuRLqaMAiJ8V2B6CjxEu3hyE16jnRDxwn+iz7UUiTAm
	IflHM03Vmz6eEZGzKP/cxmu9Ji0/vhNFqnYDLAyWbGdvQkNk7+sJt7K9
X-Gm-Gg: AYBFou2f9LhmaAuEAuXraL5XkKjMaRdnxrrgFD7xVx6x328Jk99VFnIpeEd3aY85CYw
	W4HD5y+SKF/GqLR2yEpW2nCyaPMPVe4YRjb8WVy5TfYzQ7nBzg9QWCUBK6eQD4/uhr+wzlhzjkM
	kFyv4RCFWOQA5BdLMGJrqKxmkK9m9da0ChqkXE4ztSdyZnxVGTzf81/7DzOHneG1lwNOCAGe0ke
	A1/2p5VsGX3eD6dRXLgGIUYnzxssDvtLNYrmOtV0Alwmlq+hGE3K8+ZuomiwxctdM8qCmdF2J6M
	s/IBbtSgj6GndYH5ME4fXSJtqEsfamByChnej8FexL+y6UBRPh3gSSNmopd/Z1jW/BlSi/Ei6bc
	nv5jx+ajaMVv0cKB5BQVXxgCdCtr8EYhiUmzezs2iaXPuLJa2knnkt2r5AyIH7e42WehTSTGElR
	5aDUB8nzJbOvAPOQhG+niYwja5Y04/dwrJzs2E67ZcJXvHjtKFCmEBT+bwnP0nfrlDe+dTTa6Wc
	D5HIXF2bHY=
X-Received: by 2002:a05:6a00:3404:b0:881:4b47:f31a with SMTP id d2e1a72fcca58-897c6539ee1mr20053354b3a.11.1792131428281;
        Thu, 15 Oct 2026 23:17:08 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f57b334e6sm586375b3a.42.2026.10.15.23.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 23:17:07 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [RESEND PATCH v8 5/8] memblock: introduce MEMBLOCK_NODUMP flag
Date: Fri, 16 Oct 2026 14:15:46 +0800
Message-ID: <20261016061549.4181390-6-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016061549.4181390-1-chenwandun1@gmail.com>
References: <20261016061549.4181390-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8D4D0C0003
X-Stat-Signature: tktos1qtpbzhrc4atsomwq87gi8xjrw4
X-HE-Tag: 1792131429-222446
X-HE-Meta: U2FsdGVkX1/IrmCKOTe4XIpwGZxBThd9F8CFffi7zoAYfIu2hbEclsMz35aLe8wyH0/0FvlK6v5BdcA2Jp8+ZtlWnfa/zdkexCecoqFUKxZhpRt/Xp8+ppTiW3Nvn5Ob6Ll1ErOgLZh4wRhus3C4OuwN3+JtEp26FKiOIidmQdWh/Xk89/blQ/ksMev4v8ZGb9JwvkdMoaQfsUKBJem0nVSvYbjsmT+5rzf+ABiEz74D4fakxcFDX/cF1rVo0A1ihD2DJH7/aqcIJEPiIuShNDZ5y95x3jfUOS94JK4ajCm8S5vJAgW4/F5PkPEByv20j5oaxs4vDjEN8y3AGxRyusmNdjtxpBOgEOuaWhk6G1bY3Ua1CkUocsEzD43DTUDQ0RaWHUEzm21TjvH3tHVqWbQpkOVGJ5orNi2FD25FkpJCR5r9xxuaJtdCmCbsdCpRCSZOqly59m2f5rHrNUZ188QuKc7Ry2IoG/ovsC3l4ObuShVLVEu4nN7r7iQ2NK1s6B3n9gSmvFcgSbSzwf9y6bEeZUbgOeUUASn/PYwryAayAeD8MAG0Yi5eEjK6xtfdi9Fl7hkh2hi5Pik/Aq7DNFcHUokzLf8i6+kW6Tv3e1BnvQFpBhvWET2oXu4rq+X2IKDxM9LkCNqIWCsHL0kjvJvOgxaYsfPvbc3p0ICF/U8nx6cQMQ0HI1wo8ljOuT6sZQy28sp88G1EPzh00L7hQuVDKHllOh9fHjJyrTFx/gQdDNY46UJMfcn2QSkwKkXJw85uyOWxobAgo8rm/nd6r9BW3VjVPDxALG4N6Bdn6d3c84ucgJdUb3cCN58jeR6fX0iYSpRHXRtGZRthr1aiTUNF8LkGVopj0ggvYDYPLk9XOyAHI6884DgAGWNCZYu6m6jY9dmXzdHfUMC/zdd1uqKITYHNHj/Py5JS07aq5/tDgXjcQOA/eulLe+KH5i3x9RGK56131wcSd23+497
 WjMsUT9Y
 4CuXMMnYMYiTnnsEz/7hJRn3S7wTWApp0lDadme/ZBfCP6a2Ecq3F2NlpGZsdFJHGqmefcZXPX3LI3Aeu6p34X3paD4fTd0CVIXcKCkIOGDJObrmYDObNRnVqU8VUfnjlnk0OYfqHpb2EhAkTFsH8zOsNpVn+ZIl8iIQomtXz3Tw227cDcpr38Y3AE3IQEaO1f5BqswjEH2Z/VJqAWhwEQXQ/59+5f+EUDP2YctU8CTcFALqK8nGuH96GBpFnLCQEfQmXWR17zb5PDdkEzTkTgNVuxwhNCY8pMJ2wQwyCwgQJAJerPjOeKFgYzHfibzf58KwQYxRKdrtv6qvMqDjn+6NoP7L2XSOuzhgZ/GigBC0IQtezPk4NjDltOlOOUr/SbJlHgREH+r5Bis+d3ZpPllenNG1ayJvhkKD+XZowcLliLdB1BFoUzjGMBLfyuYtP3vs8UaPbRfEm+Gqdxh9wz5GEQpdSRg1rWWwNTfkb0UpM4CExeX4TMZk0pvJTuuZWk7NWOuLd9vlmUkoeg4NMXZQaHjTHh2MUK9dGIaOPuamYaNTQOP4PtOMrF5JyY8vM64F9zyZdMS+Nihra1y2J8VpLT9ouh+hrWws0RHDEKZSu2ADc1BmU5Nn6spJbFa1rSa54PkX7sEiayg0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Add MEMBLOCK_NODUMP to mark regions that should be excluded from
kdump vmcores.

The flag is meant for reserved memory that carries no data useful for
crash analysis. Reusable reserved regions such as CMA may hold useful
data, so these regions must not be marked MEMBLOCK_NODUMP. Subsequent
patches wire this up for /reserved-memory entries.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/memblock.h |  9 +++++++++
 mm/memblock.c            | 16 ++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index ea288cf21400..04fbdff2b808 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -52,6 +52,8 @@ extern unsigned long long max_possible_pfn;
  * know is good to use. It is the only memory that allocations may happen from
  * in this phase.
  * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
+ * @MEMBLOCK_NODUMP: exclude from kdump vmcore. It carries no data useful
+ * for crash analysis (e.g. firmware carveouts).
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
@@ -63,6 +65,7 @@ enum memblock_flags {
 	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
 	MEMBLOCK_KHO_NOPRSRV	= 0x40,	/* memory with no KHO preservations */
 	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
+	MEMBLOCK_NODUMP		= 0x100,/* exclude from kdump vmcore */
 };
 
 /**
@@ -160,6 +163,7 @@ int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
 int memblock_mark_kho_noprsrv(phys_addr_t base, phys_addr_t size);
 int memblock_clear_kho_noprsrv(phys_addr_t base, phys_addr_t size);
+int memblock_mark_nodump(phys_addr_t base, phys_addr_t size);
 
 void memblock_free(void *ptr, size_t size);
 
@@ -305,6 +309,11 @@ static inline bool memblock_is_kho_noprsrv(struct memblock_region *m)
 	return m->flags & MEMBLOCK_KHO_NOPRSRV;
 }
 
+static inline bool memblock_is_nodump(struct memblock_region *m)
+{
+	return m->flags & MEMBLOCK_NODUMP;
+}
+
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
 			    unsigned long  *end_pfn);
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
diff --git a/mm/memblock.c b/mm/memblock.c
index cbb172fbf06a..31c89bd64036 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1204,6 +1204,21 @@ __init int memblock_clear_kho_noprsrv(phys_addr_t base, phys_addr_t size)
 				    MEMBLOCK_KHO_NOPRSRV);
 }
 
+/**
+ * memblock_mark_nodump - Mark a memory region with flag MEMBLOCK_NODUMP.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Mark the region as not to be included in crash dumps.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_mark_nodump(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.memory, base, size, 1,
+				    MEMBLOCK_NODUMP);
+}
+
 static bool should_skip_region(struct memblock_type *type,
 			       struct memblock_region *m,
 			       int nid, int flags)
@@ -2880,6 +2895,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_NOPRSRV)] = "KHO_NOPRSRV",
 	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
+	[ilog2(MEMBLOCK_NODUMP)] = "NODUMP",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.43.0


