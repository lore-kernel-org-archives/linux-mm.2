Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDBF9E8305D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 08:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1950C6B0089; Tue,  3 Feb 2026 03:02:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143C16B008A; Tue,  3 Feb 2026 03:02:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0247E6B008C; Tue,  3 Feb 2026 03:02:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E381C6B0089
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 03:02:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4ED9C13AB87
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 08:02:22 +0000 (UTC)
X-FDA: 84402402924.14.5A11BB6
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5ABBD12000B
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 08:02:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770105740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=T5Y3VFjbL8FXYKdtBBNEpk0FI5qp5s592aXvr3hB6w0=;
	b=UkHXTCKG3Eg+SWwVV15UirUno85F2sboyuOXJjjWAAWHlo1i77oC862KR9zfrMyK4vQ9Tq
	/W3TwBQ117S9xCaJREOm9uCqzl3N5PmsbKi88NXQYSToE/+cjSvOvjuXaRm588BdfMAK7c
	tWmvlqOdZCW6+AbsTybKtXBrnDhecKc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770105740; a=rsa-sha256;
	cv=none;
	b=ayb4n3QkZ9XN2pWMMhRLTJr16bUpDQieS+qr5TWLVZjURjkEp5xFiBxLsr90/l0FB1/wvo
	5hUs0eI8KM7PhOwBikPup9PyJHFUm5TNPz0jBSFFxpE45H5vdUV/KdYcBAnF050GnoMX8q
	nMXLDZ3BrraLNx0NwhLCDwjjlNWn9HA=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 613828wR3635453;
	Tue, 3 Feb 2026 02:02:09 -0600
Message-ID: <ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
Subject: [PATCH] mm: Fix memblock_free_late() when using deferred struct page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-mm@kvack.org
Cc: Mike Rapoport <rppt@kernel.org>
Date: Tue, 03 Feb 2026 19:02:08 +1100
Autocrypt: addr=benh@kernel.crashing.org; prefer-encrypt=mutual;
 keydata=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
 C2iMOsFIbhTtIEf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspamd-Server: rspam12
X-Stat-Signature: ac1f5zhioem5356kcxz5qq9xoaf31grh
X-Rspamd-Queue-Id: 5ABBD12000B
X-Rspam-User: 
X-HE-Tag: 1770105740-542202
X-HE-Meta: U2FsdGVkX1+fmkqmtnSI9K1VBIzohj8QN64R5zG1BcF4E+o540+V5tTaFfFQyW96gAB47hWzcYe/eUTNITmOcvCkzuj10m9CLyZ0/w+MpHrZDgvD6uLSJOO2U5hfl0lgByBxnPmLw1Skie5CH5Qe2wnnVqedE2O5pT4EGJGIR+V11zkoDgv8VCp402IcUu12srk64BfdoUMX0nYPpogxaS5s6apK5Nd3YZrVmbyiIPuDp6UrwKeeOxG5EKztVQCadj2NKZatMxBe52T0wZfqoXDMC20UZHi6wEPUeVe3OhaBCklZJyIkjZiVqrdOb92FtunSDPET0mmsw4O4Hn1yWk9PXXt4qacqB+FENOQMd4kEBUEb8V4uBj9K8VRWArmeobGMCfqYYKP890tm9GSJ0rexZ7OLO09GUgeEWIM4+Ynm5Byiki7jbybQPL+cZjah3mGw1MxGmTwMzqG+WPf6ZgQuAFYrmWFUnXVWcrxQk7rzbiNBuDrO6+pOdXmd1zPeLmMeF6wrZQIvmQk8hfvJXAC9n0pP3RmruUvE0VF7a3TgQNlKOe3KFsMWgnIxZjok8sNAZ+6K+tzf2qXcN6JuyGO+EtpPK1KtUycSh1yg5a7uEy1LP5zbuAxmZN2TYxVqveKS8AmJ2Pv2Mz5GEH3xZAnqZTY/8PsMVygfqY8KDwBIyU/4RskDiZ8UOa//8Mbggld1D4xUXxNjWuj1KXDbni9GuOjl1OeTAfhtHLLkOAhkovCHjHiocatxw7QQYCKO02Cml+XuJXzMO9giP0enkXsI48cBCCqeToiriEKjSVA5zZ6zHGiuDNKM1Or3b2s1TIhKIKLqQPyMPhZV9xT38tow2P3EJhflp5bzE/XE2fxF70Dr/UpyRd+nWMlL9zGOoT6sbvlxNOKkR8sYPBu4jLzTMsh04S5PjiKTTrr/2kk5kqjsa1DftX58o2x+4l3wfcY7S7ECPHE8bKf5cXG
 9vrdigWs
 Ifu/hApmCz3mDS9BoU6Liiw/LDkDsWLXTmG3tRIAGXyGTA4qJfwA+RcpfJ00i58Es9s/p2MKHnAHNh6HWxU0urvos4TiPn2y8ol2rHoo04nagjeueBOzEaDtVorPCgEKuivU1LqVcNBgwQcT20Lev3L7AcUVkzSugfAsD+LwhHdMCNHM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, when using deferred struct page init, we may end up not
freeing the pages depending on where they are. Typically this happens
when efi_free_boot_services() tries to free UEFI Boot Services pages.

We can hit the !early_page_initialised() test in memblock_free_pages()
since the deferred initializer hasn't even started yet. As a result we
drop the pages on the floor.

Now, memblock_free_late() should only ever be called for pages that
are reserved, and thus for which the struct page has already been
initialized by memmap_init_reserved_pages().

So it should be safe to just free them normally and ignore the deferred
initializer, which will skip over them as it skips over anything still
in the memblock reserved list.

This recovers something like 130MB of RAM on EC2 t3a.nano instances who
only have 512MB to begin with (as to why UEFI uses that much, that's a
question for another day).

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 mm/internal.h | 2 +-
 mm/memblock.c | 6 ++++--
 mm/mm_init.c  | 4 ++--
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 9e0577413087c..fe6da7c30caf0 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -660,7 +660,7 @@ extern int __isolate_free_page(struct page *page,
unsigned int order);
 extern void __putback_isolated_page(struct page *page, unsigned int
order,
 				    int mt);
 extern void memblock_free_pages(struct page *page, unsigned long pfn,
-					unsigned int order);
+				unsigned int order, bool reserved);
 extern void __free_pages_core(struct page *page, unsigned int order,
 		enum meminit_context context);
=20
diff --git a/mm/memblock.c b/mm/memblock.c
index 3d7b0114442c4..b836b638615d0 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1718,8 +1718,10 @@ void __init memblock_free_late(phys_addr_t base,
phys_addr_t size)
 	cursor =3D PFN_UP(base);
 	end =3D PFN_DOWN(base + size);
=20
+	/* Only free pages that were reserved */
+	VM_WARN_ON(!memblock_is_region_reserved(base, size));
 	for (; cursor < end; cursor++) {
-		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
+		memblock_free_pages(pfn_to_page(cursor), cursor, 0,
true);
 		totalram_pages_inc();
 	}
 }
@@ -2141,7 +2143,7 @@ static void __init __free_pages_memory(unsigned
long start, unsigned long end)
 		while (start + (1UL << order) > end)
 			order--;
=20
-		memblock_free_pages(pfn_to_page(start), start, order);
+		memblock_free_pages(pfn_to_page(start), start, order,
false);
=20
 		start +=3D (1UL << order);
 	}
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 624c1f90ce050..34dc39a21b4bb 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2440,9 +2440,9 @@ void *__init alloc_large_system_hash(const char
*tablename,
 }
=20
 void __init memblock_free_pages(struct page *page, unsigned long pfn,
-							unsigned int
order)
+				unsigned int order, bool reserved)
 {
-	if (IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT)) {
+	if (IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT) && !reserved)
{
 		int nid =3D early_pfn_to_nid(pfn);
=20
 		if (!early_page_initialised(pfn, nid))
--=20
2.43.0



