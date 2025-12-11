Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76A84D41C04
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 08:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1FDD6B0007; Thu, 11 Dec 2025 03:11:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD0116B0008; Thu, 11 Dec 2025 03:11:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0D0E6B000A; Thu, 11 Dec 2025 03:11:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 885376B0007
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 03:11:25 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 419071607B6
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:11:25 +0000 (UTC)
X-FDA: 84206470530.20.765E276
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5A85A140005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:11:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=YwhHX+7f;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf26.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765440683; a=rsa-sha256;
	cv=none;
	b=A8gT34SZ+IYi1fe42Oo5oNTVL8zYfh02sFcQXs8DdhfltykAQVhZW3gOY68pTNTeD0IQf1
	bcRPvZigrPrbkFlraKiy0glL9ogxP4tS2gbhfZpyUakkDUuYDjh7CUkksp+K7+e3xEZJso
	mm9VTRpIV8Qo5DY/EzqqYJ9pPc3V00U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=YwhHX+7f;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf26.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765440683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YNQZnTQ0626Obvsj0xN2Cn7Wp4q2P4JXSbnrSwkFkdw=;
	b=Q5K9J+gx6rhzTvQ4vahOQ6lodTfxCBwdg0bqmAgdvZ0d/YHzk6Ufe84CNNxID5pNaHQ9ia
	ALW73vED72CHH1ygWFp2Iva4SypeovIRi4IVOw8bEJEZexaXtejqqfQl2GvHP7PRlCqti+
	D3witVBsvLl/n11fFZ/hE/NVHuIxuOE=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-bf5ac50827dso470471a12.2
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1765440682; x=1766045482; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YNQZnTQ0626Obvsj0xN2Cn7Wp4q2P4JXSbnrSwkFkdw=;
        b=YwhHX+7fKMY+GypbfFp0X3N+x+9tDYFh3o/nGLqwfPgmbOLqI5es0nny/54KKe4Y9a
         e1ycZap/yq/2wmbVV/A5JOX6aDKXu81ai+11dBleWfiyBM603bK7JWPZwktCbsQ/1Udh
         LeXd5HnnsxoPoNOIKT0CSQ8iOD6/PsMPwXFhuRFgByxfOjbtO+pRjyk0q7GXyVs1nsQW
         /hIxOH+XhvKjNfF0nyHKcdxRIce+zp/QwHu94Hwnsp0SXKsRxfPt/CAzzdOpNrSDSRQ/
         br/YHhhXpCy3DsCTPLfXazW3GnWTBiNvc2MNeHcSphivbpa4mFd0HSf55NRiYrYOe23M
         x8Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765440682; x=1766045482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YNQZnTQ0626Obvsj0xN2Cn7Wp4q2P4JXSbnrSwkFkdw=;
        b=VlS3Nq9WoXrqlNsnld2Xop/Sl5+OpMZeuKKGTgcpO+mtHhCpVhZTf6ZfkJ9HBK7rdi
         Oz6PodffKvefsWdxxGye8xsTlkyBB1rH3815Eq9AO+opdxvXa6RfpcK6szrZr3tqC6CL
         zHLhi6HbHU0WOto5WQ19F6yv1BXruFkxqU9GlXtZwOQ05tndDiSRj4DBGSODqeAyJ657
         mBlLIvAGsj1Vyqp7HzzF/SDxk2qTpQG/CpLVGaRcxmLfOw5bIwN7PUfU75oRc2fKOWTj
         AsikF8HYOCTw/a3WQU+NzJYUMxZeh7BOd1tJna8oL4oM1JJtZ1/lieLSySeL4Htq+lop
         +flA==
X-Forwarded-Encrypted: i=1; AJvYcCUfZqqfTfR+ofl8Om/EA8DOJIWQ8DzlbItk2n3y4kEWE/YvHSAtXAkOqCwYXyjCgEC5KXub3XkYTA==@kvack.org
X-Gm-Message-State: AOJu0YzhSyCLhapGW9ZHvkYe5dzyazLLB8DLV/mUCb2djYf7yjlUtUag
	aNeoJ4s+NsWgxeDUvT+Zz2nN5HxP4dXki8qIK8zUr+PunwBHrhYTrF3/hlOOsrLmrEU=
X-Gm-Gg: AY/fxX5RAhMwjSVZspmH5fUaJ2dzPQGe6UavNMOqsYbJHgCdIWE+npHfb/UWEF1o8f7
	hffNrZaXBrVDTcYlOkBTpRRPIrS/1VJ/x33lDU6mpl1q+alPnE31B0kJS5XOeimzoFEBl0lpsx5
	tOgQtlvE4NMLr1E3TJqGjtWIq8+BvfpPn4pMv26rloGrUcgus8ClwAtCffIoHl3Sa4C2QwjZmUc
	byI/l33dyc4modYJXiYAg9aLiCj+HLHqGQFX+h2V5jfgwqZN2nFFIT/VBxAN+Kr9oHt0BZjvNAk
	ppt7GPqC54GeYDwzK/hZLy9KGrwb5rclWg0FhW763x0UpOOY4qkMslkNX9msW6nLDTkgjLMkORm
	2ccpKlHosA9hhxDhWmcl+ZbvM10LyJ3o7WBZ1+JtlEqN79rKtP3XnZG2iomYXyh6yeGj2XCXaK4
	pLPdGQkTS5JCiSL9ub7r3XbYuKSToPj7xg
X-Google-Smtp-Source: AGHT+IFPgoEnNZyGUJk1reAfEp0MPmaNRO1jxIqJ9m+UBwVTWL0d3lGmxqCZdPWFumUC8Zzv5D9+Mw==
X-Received: by 2002:a05:693c:40d2:b0:2a4:3592:c612 with SMTP id 5a478bee46e88-2ac05597433mr3442194eec.35.1765440682152;
        Thu, 11 Dec 2025 00:11:22 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ac191e1eabsm3914759eec.4.2025.12.11.00.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 00:11:21 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH 1/2] mm/debug_vm_pgtable: Use set_pXd() to write page tables
Date: Thu, 11 Dec 2025 00:11:11 -0800
Message-ID: <20251211081117.1126521-2-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251211081117.1126521-1-samuel.holland@sifive.com>
References: <20251211081117.1126521-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5A85A140005
X-Stat-Signature: os3pn3a836em37wir4cg9qtymdmm7qhr
X-Rspam-User: 
X-HE-Tag: 1765440683-386359
X-HE-Meta: U2FsdGVkX1/q8/eqAWDkil8IbrfiO+40ua+J+SP2PyVP5Aqt9EeF4ZQkAnuTrOcAu0fU7enBOVyqkJUzpJ0+Pj+S5bXEXSK9luqjhGgJHv/ux+lYuliL7J/qVIOBgscDEbjwTr0AO1Cwip09uu5PZIzaz1QF4i1rxsTO0tPvnVFySZq5jK7kbGdrfi9CeyQxScNCQ5D7wmLj0fQtvj708iAFLqPvGjZAVHwBLPFlkVExm6+A55PcWeT9Ik2kyt95Ar30pk7yj4a29dYw4QFeDJX0hDkgaYd2y8mqJjGAs2bQDdTLDuFvm+l7aisn5yhAWd/H1KQ6xvfRpajje5HrtXLptqpSfUPWKrx3cZG+Q6V8bArxk8l6w0ThT1At1S/L6gD1TtwfqFvdTfo+YAoyfpvFAxEzgbK5tnJLocN9OK2hZ8uansYuRx54Kqb7iwiJh+UzOgetMNztVgnVD5QDVJJBmGjj5yAKuXW+O4wiSsrFWr1kKwc1q6Ox5eT0lzVhhfWd4wCeBLmHbu30FR0voy8XIyzo0QJQnoQxsVVDKDwijJjnRFNM9Ukz0K/4utUEo0PnsY6vXdiaQ+VSJq6tCa6+BC0oNYVKA48c2UYIATBeGhQlkb6567+mFsVglEw4PEYdFb4HZQBjfj/DhXNaXeWl8epm5Ruj9qCNnljjJwPCnoCI0F7f5t0OIBYoLRMHAJPa3PjgEr45KhMgy4VKohVCED7UuCrxlVWhlNUvHEyT9PEHFUCv6GlzaJgpDWd9uc/FrxA83SHabkMkJhhVlYPZubYz3iglYVXcLbP0HjVuE6vBzZlSlOZTb9IrOBBjciyJtawJaofLMf2npJy55/DvpBKImmmOb9V31K0XUM9yG9bG5yCzIv4DpshB9UYmUfF54d1mKkbjGUykJ7X5A7UbaNB8nsUwY9SGX7UzXN9K59CupTZfJwzZcjYP31Irpl4SfFkLez8kubnYAzf
 pxf7aUO9
 p8enO1zKydY41LU560SpC6091vRvd0mKoVhcbcCc+tzXmU99Epg/MNVw/loEjVXDCP+7EPDzE+Lea6zeHesTIOQ36LsqMidFQybiqBJEpLxFleblLcD3HABtiURODPrjmGuKhj+oE15YrFtaP4cAByYsR+agVFu5AbP4WaMWXYX1RN7cdpTuc6iLIzb49Yc/A69HgwzhQltBeirJ67fgPsizl1L5vOhIJUDYJt4V+K7sbCDeFnzTrNLWUttiOROIpvDo0t1CSH/JbRZHyzFlu8Ita/2GtYOzC/iWiE1le/3yE3YOoCLX9rWfdvoAOs9hhFPtVng6TA5j8cnWMBfVc93w8zN18qQVyTChYRRTFMKqN3A6M2UYDOLCkGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generic code must always use the architecture-provided helper function
to write page tables.

Fixes: a5c3b9ffb0f4 ("mm/debug_vm_pgtable: add tests validating advanced arch page table helpers")
Fixes: c0fe07b0aa72 ("mm/debug_vm_pgtable: use struct pgtable_debug_args in PMD modifying tests")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

 mm/debug_vm_pgtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index ae9b9310d96fd..8c7996d6c1f2a 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -445,7 +445,7 @@ static void __init pmd_huge_tests(struct pgtable_debug_args *args)
 	 * X86 defined pmd_set_huge() verifies that the given
 	 * PMD is not a populated non-leaf entry.
 	 */
-	WRITE_ONCE(*args->pmdp, __pmd(0));
+	set_pmd(args->pmdp, __pmd(0));
 	WARN_ON(!pmd_set_huge(args->pmdp, __pfn_to_phys(args->fixed_pmd_pfn), args->page_prot));
 	WARN_ON(!pmd_clear_huge(args->pmdp));
 	pmd = pmdp_get(args->pmdp);
@@ -465,7 +465,7 @@ static void __init pud_huge_tests(struct pgtable_debug_args *args)
 	 * X86 defined pud_set_huge() verifies that the given
 	 * PUD is not a populated non-leaf entry.
 	 */
-	WRITE_ONCE(*args->pudp, __pud(0));
+	set_pud(args->pudp, __pud(0));
 	WARN_ON(!pud_set_huge(args->pudp, __pfn_to_phys(args->fixed_pud_pfn), args->page_prot));
 	WARN_ON(!pud_clear_huge(args->pudp));
 	pud = pudp_get(args->pudp);
-- 
2.47.2


