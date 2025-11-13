Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9455CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 542838E0028; Wed, 12 Nov 2025 20:47:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CB3E8E0014; Wed, 12 Nov 2025 20:47:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31EDA8E0028; Wed, 12 Nov 2025 20:47:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 143058E0014
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DBF8F4D02B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:15 +0000 (UTC)
X-FDA: 84103896030.23.DC2EF69
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0DF17160009
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=DgcYpSLJ;
	spf=pass (imf08.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ZA59qppRNlQ/gH4ZwlxZVtJjkZuT0TezTthNgG0I08=;
	b=qz+iu80DOTj2Ek+0gX8r+lctofdR9TC+KfeSOhAUStSibi3VpBL4nKwXmBVWtqJyQTp22s
	w4mDGBV+eyaMGvUuNisiBMVIXbEPHKbhA/EmdPR1DSWZhp1QA0LPm0Iq7lHYpTsXA2rqEv
	PHeVT2/Z2XBPUdk9qO4uxhGceKkMmyk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998434; a=rsa-sha256;
	cv=none;
	b=2KETV1pB5rYK2M/xZmBlzKRgHMOrdbEC52Win6a0rly2yuLZ3P7H+e2p50xfRYEwtYnkjA
	SgwGfd6oaW9GVAhIHiDmMOO1UFfMvwBYVUhzv4r8wl8afLjRpTDoDkkY0HcA+6S/UUBgQ6
	VZQWgG4HdSklIFQPQ3VztFv4YJyvA7c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=DgcYpSLJ;
	spf=pass (imf08.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-bc274b8b15bso211792a12.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998433; x=1763603233; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ZA59qppRNlQ/gH4ZwlxZVtJjkZuT0TezTthNgG0I08=;
        b=DgcYpSLJsOgh+O+DdxWnSAOdcdJmoMHP/IckwGw4NEKNyb7loD6FYtt3H30aX7eEYi
         1xsvXvXhzqFcfd33dZp2DVXcEygg/EgHhMLBrOaK+S3ggoie+oJtImuDnPAEeYU07qDR
         CH6kISSShlONJYFBhTUL6WUX/F2JzfkApfOzxTF3JGmbafO0upRWL1ynZ1xVYtQBnMnh
         3ihLOPvCU2eLCce3uHrtKGHKuVQKo90S3jEFwC+mbpunp+w61LOWIiupLTF+roqoNOYv
         6WkS/IZzjf6ZcR4bVxLDqj0ZVWginGn3Hz+U5uDoKJFjzj4x+sBOVSfSV22uicH7iFV0
         9qSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998433; x=1763603233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4ZA59qppRNlQ/gH4ZwlxZVtJjkZuT0TezTthNgG0I08=;
        b=jL/WciMN6U71Kkya07U/7FiSWPMnNRTXcDi9p6BkyRD6D19sglggd5OxofIeq2M27M
         egn9ppFZFVHcWhtZ2yNTkJcIsC7DeCszvIKpIErALNDhsht4QWCSWevJLZCiHvs5CrC7
         ayo9mwQq5Zg2LojU79lBI5XC+tbhiowW6saPrS93uSktitO1awyhjY+3fwiPV4XKVxJT
         VLNUqFaeIMBlj3ccmK2NwH4I8NcGzTA4IF393nwo7NBMF/443oCYsBWeKQDQ9XvryQ9a
         /qe0k+aGMnWI0hulUDqfvSroc6bs5cGU3SKILuwW6GnXPydGhZ0ngn9mhlW6azNedQyd
         ZrIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYwL81Re0w+T5Tb2Sk+gEE1njs1He7dA+tQQP4KhmgE8BLNJBQr75OAZkgNUgO7cOs9XYkREpWiA==@kvack.org
X-Gm-Message-State: AOJu0YyeZQ1IgGFhJbZOG7TT+1PLpHD/XdRbxZd0B5X15Z5R57tkLT4S
	8D1WFbbNivlaX2YyK46v2Wyj8aXe8T0hA03NM0PqFuynFEYZ9SsAfKyOo7NTkiI65aI=
X-Gm-Gg: ASbGncswSoejxcvKFEF+ucpvR2CnJI9X9PwUmkyxDqy8rRSpd32dYivFDNbgJDraNVw
	YwJ6ryoPJxLB/fLUJlyQEhoDPh7ZX9xfwmWP6lTt7BKlonSF/m7YQMkfmUCLiEsWCbdliQ+I7Zr
	YiXqSe80Hu/v7iXOa3m7sOOAcVdDLtvWwpLFUQUb7BQK++WshYLYWBmR0SZtRMUcfBsT9Wj+tSz
	LK25gqOJSqlH1m5RPMgTrN1ZCh6ej+dtJ4qrzZ9F9UaV1a2O3Vgene7uxjJXl/uHK7EPwFA8mQa
	GPkNucasB3xkaE5ZgdPpzGV7wS+E+NfVkpt+qWEBI1TwIoyOfBMqUrg2Ne86cZX13lPn2kyGQH8
	kH33+ClG02f98LXVFOIKamaVh6gzCGzYDz0l/dmN+aOppEi68pHFBfVGD1jPkaXKJBoXUDWlS5j
	l03ubvGddaiXG49O+vObmAIFvniXU1wDWW
X-Google-Smtp-Source: AGHT+IEls7n+vPL3afsY1HaiLuKxeTZ1hxOSzGPwxU5ZDyX/ao4U4NfMKSzGsMG6BjM8vErLRKhy9g==
X-Received: by 2002:a17:902:ccd1:b0:295:7806:1d7b with SMTP id d9443c01a7336-2984eddee65mr65789335ad.45.1762998432890;
        Wed, 12 Nov 2025 17:47:12 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:12 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: devicetree@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 09/22] riscv: hibernate: Replace open-coded pXXp_get()
Date: Wed, 12 Nov 2025 17:45:22 -0800
Message-ID: <20251113014656.2605447-10-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 0DF17160009
X-Stat-Signature: gus54eupd4yasctxpghjujmtfnr5ei33
X-HE-Tag: 1762998433-754992
X-HE-Meta: U2FsdGVkX1+o7YRwVZwU9+dOZzhfHbT3F2mHqdxAeBek61IHPVT9iZZui0RbWMjCcp4F3a0MWNusOUFYN3I2yy55QZOehXtMd4hNsX/s1CNI8EY0dDEPsiW0zfHfqKSjbDFW9yvDD0mpdjeT5Em8u1IBMmmFQL+lsmpBQI5kPJ+U8RSJtgVZx7iEPLGDkJSusGl//Uy3mmj4vDOXHXQ78S1QYqwtTZD5dn6oaWJMzEwGvdVxYmoT3YZowFf+/WZtOazaVZ/vmIb6AOX7c+V9uAqrkKY3YWsr9wAfU7v7saIxJKdVboj03gxVS3asirVcUaCCC3dnEHMbqgiWDDT1TkkxASzoJ4jvE0hTqvrwXvuyM+SPUQEayHxsue7lZ1++9JQq4gGgJ+SkJ8JtQ5x/Ub6gPhUORCj2aKK+d+H2cC8vKmp4LU4Vj2knFEuPHjMNSEz2w4vZAqUyIQEmEq6pd188msaj83A0Vf5ZfUuc8UNzVyRGeb4Zv7gaxZjYGxEH4z9Cpl9hXnOGhS2sUuzxD+V1VuNFjVj8eCgu+iiB2a1xRc3eeO5v93IB+3XILTUkcD14S45OWnPskXiUAM4yfw/Y3h2iqWm+gGQVDsAK8aHxF9w54sLXFC4uiGFg6zT/SUc1GYKAb3RqTNPXbIvxolJ0xTUsjn+0Dr+Xb58u0Opj0Wvc3VwAYTD5BZXmQk0LSbyLqh552OIhT9TxpgRUGPBL3/gp45kRsZLVVr/x8HQebxhwsbK+5HCdTPu3iIivvO+gVNql7Cl18QlXErNV1buW5alP4UQMGN+L55tfeoS/tuly68Orf861A98EVY8s9HuC/rKIO2WpaXpqpHKjU0AiIndZpnx8wl8jV4sYqDWvpMpZTz2lkLCtRiR25DLSny+uIAgP6WkvOl8bifRuIpLlDwC/lcmwKTWRA2apWDak4C2yGKA7sVe8htAt2ekpZlRPtrRtbCwV1gW/aMH
 KOI7/tfi
 Gvxp9IWCES7xfrtUfT+CzhuclNi3Zi9QXiT817uYJ4XrDN8dfbPFzc/Iq6Pi9uNbNtZ0bVJiLpabl8SKIjXo643YpJId3GR7NMNRGG9QDmqQAO+J91pWM7YurISXSqOtuYegjLKLwRXIfU/evYqPPCYWgt+KiASl5VNxBJVXz1aEDWydvVCHKlfBNlaYc4/7ovq6QsbVTewRodqhFHo/+WxOL8kYKnwteQSbOD8vH/cvNgxwdFDO9gBn7DXXRgGgXx7RUvmi3CqVnSxjZr+tRlE8+SbJ70BzwftmgBloiqa4Qs4tS9SIwgBsBXBSFkbvevsnFIx3OhvEe+FoUrqQoaJGrtJXM3ZxuQLKdipQWHdDPac91aeZjFL795womJAphp9uWfO9yGkNbwJvIdjvOrSnY4d/GiRZbfcGjH6/TI1LclKeyDBYstfbLHfmLt4RJ3TpX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the semantically appropriate accessor function instead of open
coding the implementation. This will become important once these
functions start transforming the PTE value on some platforms.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

(no changes since v2)

Changes in v2:
 - New patch for v2

 arch/riscv/kernel/hibernate.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/kernel/hibernate.c b/arch/riscv/kernel/hibernate.c
index 671b686c0158..2a9bc9d9e776 100644
--- a/arch/riscv/kernel/hibernate.c
+++ b/arch/riscv/kernel/hibernate.c
@@ -171,7 +171,7 @@ static int temp_pgtable_map_pte(pmd_t *dst_pmdp, pmd_t *src_pmdp, unsigned long
 	pte_t *src_ptep;
 	pte_t *dst_ptep;
 
-	if (pmd_none(READ_ONCE(*dst_pmdp))) {
+	if (pmd_none(pmdp_get(dst_pmdp))) {
 		dst_ptep = (pte_t *)get_safe_page(GFP_ATOMIC);
 		if (!dst_ptep)
 			return -ENOMEM;
@@ -183,7 +183,7 @@ static int temp_pgtable_map_pte(pmd_t *dst_pmdp, pmd_t *src_pmdp, unsigned long
 	src_ptep = pte_offset_kernel(src_pmdp, start);
 
 	do {
-		pte_t pte = READ_ONCE(*src_ptep);
+		pte_t pte = ptep_get(src_ptep);
 
 		if (pte_present(pte))
 			set_pte(dst_ptep, __pte(pte_val(pte) | pgprot_val(prot)));
@@ -200,7 +200,7 @@ static int temp_pgtable_map_pmd(pud_t *dst_pudp, pud_t *src_pudp, unsigned long
 	pmd_t *src_pmdp;
 	pmd_t *dst_pmdp;
 
-	if (pud_none(READ_ONCE(*dst_pudp))) {
+	if (pud_none(pudp_get(dst_pudp))) {
 		dst_pmdp = (pmd_t *)get_safe_page(GFP_ATOMIC);
 		if (!dst_pmdp)
 			return -ENOMEM;
@@ -212,7 +212,7 @@ static int temp_pgtable_map_pmd(pud_t *dst_pudp, pud_t *src_pudp, unsigned long
 	src_pmdp = pmd_offset(src_pudp, start);
 
 	do {
-		pmd_t pmd = READ_ONCE(*src_pmdp);
+		pmd_t pmd = pmdp_get(src_pmdp);
 
 		next = pmd_addr_end(start, end);
 
@@ -239,7 +239,7 @@ static int temp_pgtable_map_pud(p4d_t *dst_p4dp, p4d_t *src_p4dp, unsigned long
 	pud_t *dst_pudp;
 	pud_t *src_pudp;
 
-	if (p4d_none(READ_ONCE(*dst_p4dp))) {
+	if (p4d_none(p4dp_get(dst_p4dp))) {
 		dst_pudp = (pud_t *)get_safe_page(GFP_ATOMIC);
 		if (!dst_pudp)
 			return -ENOMEM;
@@ -251,7 +251,7 @@ static int temp_pgtable_map_pud(p4d_t *dst_p4dp, p4d_t *src_p4dp, unsigned long
 	src_pudp = pud_offset(src_p4dp, start);
 
 	do {
-		pud_t pud = READ_ONCE(*src_pudp);
+		pud_t pud = pudp_get(src_pudp);
 
 		next = pud_addr_end(start, end);
 
@@ -278,7 +278,7 @@ static int temp_pgtable_map_p4d(pgd_t *dst_pgdp, pgd_t *src_pgdp, unsigned long
 	p4d_t *dst_p4dp;
 	p4d_t *src_p4dp;
 
-	if (pgd_none(READ_ONCE(*dst_pgdp))) {
+	if (pgd_none(pgdp_get(dst_pgdp))) {
 		dst_p4dp = (p4d_t *)get_safe_page(GFP_ATOMIC);
 		if (!dst_p4dp)
 			return -ENOMEM;
@@ -290,7 +290,7 @@ static int temp_pgtable_map_p4d(pgd_t *dst_pgdp, pgd_t *src_pgdp, unsigned long
 	src_p4dp = p4d_offset(src_pgdp, start);
 
 	do {
-		p4d_t p4d = READ_ONCE(*src_p4dp);
+		p4d_t p4d = p4dp_get(src_p4dp);
 
 		next = p4d_addr_end(start, end);
 
@@ -317,7 +317,7 @@ static int temp_pgtable_mapping(pgd_t *pgdp, unsigned long start, unsigned long
 	unsigned long ret;
 
 	do {
-		pgd_t pgd = READ_ONCE(*src_pgdp);
+		pgd_t pgd = pgdp_get(src_pgdp);
 
 		next = pgd_addr_end(start, end);
 
-- 
2.47.2


