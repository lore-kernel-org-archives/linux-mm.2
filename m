Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE031D1951B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 00:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31E4F6B0089; Mon, 26 Jan 2026 19:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C8EB6B008A; Mon, 26 Jan 2026 19:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C1886B008C; Mon, 26 Jan 2026 19:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D8CF6B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 19:51:58 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDD5ABBF93
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 00:51:57 +0000 (UTC)
X-FDA: 84375916674.23.3FBFA92
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1D46F4000C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 00:51:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YqEHTf4Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769475116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7a9RbCOrROWoP016V3+zUrjci7rmnK6fuyJb7ZGpEk=;
	b=7hcF9F8rrlZCIdoJgdSoXMYYJcEtjhnOsvyvyjmFRudzjOf6FH/+7R14ZxRElKgZB5meqW
	YnCpORBhAP6+DfDThTFrQH8mGPWJDK/uFXh99rwxkT3/jOgMUnYjzGFa2fprH4z3/QaKEW
	/awBw5gZfBF4IMLCdP0pE/NmrIAk4r0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769475116; a=rsa-sha256;
	cv=none;
	b=EBkU/AZNrmroMZxQpX9xz8C6uIAxBANuRe5/MMR5VOrFMlo3UnSqnFpNtJakJGi/vhTeMT
	1TyBh9WKx+dLG2JfJtPiyQwohOl+WlX2gowhxTfbM7XhqDqQtuhA6ZunyXA0dUxrJpTMJc
	6yUMjMoG7jQyYQqPjccbipgDabz6zto=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YqEHTf4Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-11f36012fb2so7266636c88.1
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769475115; x=1770079915; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T7a9RbCOrROWoP016V3+zUrjci7rmnK6fuyJb7ZGpEk=;
        b=YqEHTf4ZFXeTl+q23fY4apbG0jC5nfTL2hZJ1piAccOvQ/WhdxBpu5GI4l3gx+h/La
         t5PyM/TSbzV4VNSbaQtas5DMv94ZXnvJGoNtDKFYIMJnNEUYHTrryqHaolDvQKIsQA+8
         oLrJ7V52/lE0CzC0fE1iC9xY+HU0lv3E+/NbjW+ROmq0BG+N9r6XYylceEJMkXF23YA0
         +gubmouY5zfWidvFvdafdODc7XYdxzU251Fl2Kn6rRlJOrcFtFKIT8RrlSduiO2EhDKb
         voNsAh6yElUx4AOYYFI1JZCSUEJPYodRt+4ScuBczkauPP3DLFz3zLFXurMKOraPrZA9
         97OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769475115; x=1770079915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T7a9RbCOrROWoP016V3+zUrjci7rmnK6fuyJb7ZGpEk=;
        b=h9955cGXEDnzXUaRrLxEbSfSX7lUMcTTlCBfiISC/d1qU8bhfDUvfUwhz9UgoNMSaV
         5z49auYIkce/lWdjB5YPP7lMv0017EhgmCRSOEcomDqOFKjI3MpdfSEQHcXZOO0DVz5K
         SLHCcLBQT2Hfu5Ik+7jL5lIIZw7vFqE8HSaZWIalisK2t0MbWB8QHPitKQOgKzTJ9gJ1
         7C3bj6Li0PnRTVLVn1MaRe+8rnEoyqACEsg9MCSBnjSiVCdgg8XByZ6DSV6ZfYxoYPGK
         WlQMzmsT3j12WrMVVyxbFFOo6NTWOirBLo+KxcNv3PCEAX1cipLIzaFBmvaTyJH69vmw
         0New==
X-Forwarded-Encrypted: i=1; AJvYcCVRl910t/PQNDlhkQlRI89a88UDqM6z0Krm76H7aag1da8NxG/bvV22IsJcDSfUSB676Ft9OZsngA==@kvack.org
X-Gm-Message-State: AOJu0YzjnS1aCigwnhO7qFqsTftGrdzPd9pBF8EOQPc4HpuusO3BQrR+
	BX6Mxt/MBgXu7SBpQWp2tZ9o6c3RjzFInxla0srSkKpqUhfHx4CvEhor
X-Gm-Gg: AZuq6aIDsP5Pkic5S3kUFMD25gWYatrKepVG9VyIgXCle/aVih6c2uVAvYwFpEDntXS
	tX9bZFW4ITk8MHPztT8yf1NVTMHvbb/eFaTuGOEXJ6IhKxloi1AVOFhhmij7SS7EI+0yGQsFWjW
	WqliUDdbUrL+XcaHgru58oWebwSQHLXwNAtMbd7sSqA27UszCoM3mion5bR4abRh6hY5ww6iYUP
	URIX6S3CcdMajnEbpt+4xB/LBfYrwKDfG41BZMa59QWXjRvHFdltKFlwx67f+E7H+DgZPa9lgY3
	zY2czuiOi+2S9VBiOI8lLWKSBNhCEtoKicVnRqZS9TdiMktm5/kqEAKpGobyxGZQgIW3RNDYilM
	v97KKQxabOLIf4EckKKciQewXISSlrcuPyid31Uf9e/QBZkcK5lhu3MG7I+1tL18RP0fCTOJRQ2
	POKLxQyEe/Fq3PoXbHEqvNc6OpZDkIZ+mlDYBeXroIwfs=
X-Received: by 2002:a05:7022:4194:b0:11b:a8e3:847d with SMTP id a92af1059eb24-124a005f2ebmr4510c88.10.1769475113324;
        Mon, 26 Jan 2026 16:51:53 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-1247d91b9e1sm22185065c88.5.2026.01.26.16.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 16:51:52 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 1/3] x86/mm/pat: Convert pte code to use ptdescs
Date: Mon, 26 Jan 2026 16:51:38 -0800
Message-ID: <20260127005140.197847-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260127005140.197847-1-vishal.moola@gmail.com>
References: <20260127005140.197847-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1D46F4000C
X-Stat-Signature: idaodx6eaihyga5fnxjbx5h3a78dr84p
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769475115-508618
X-HE-Meta: U2FsdGVkX1+UkKOp6CKSwIgw2BccRJE57kTNZlQ0qNVwvEmjfpzIQ41Tm/rvUsq3aXpvqHcvaqIA4llnp7OwYd8L20y41f2EqJqTkfQ50wu/ildPql+OYNtAxf/9E72dLWHsHaFz99RCzRJdh7rBzE/OpATb+ijAy2Ld/BSXHCNB50Oc7OpPMmrGVETnLHmSsTsqXNXI/V0ujyLT1zGcNZFnOFGTjvmIc3xx8PlGLxENn7TABDT/Kndb8NtyQZBHJzz3FNzaqsa02PuO3OGwDnNCGaz2iUR/s+70+LUQeKNeCpflHmR7guO3hyYLUEBwFRJb53lZOJN4r8WZhKzoJrg5UDx9FtFazYhkfCF6rZbhCAtxXAOgDnhSIHgaFQbrj1mDjBuyq9rLd1fKXNRD7mB56+uA3SelvDDmJzcVg6yOUJgdRE/v9xOhugr9rAfxMzU0RxJESP0hnOsETMdFw+3dUIsqg0FdnydMgYLWlFN7HkVMmI9htSx67dYrNPjkFplTdvHcNA+RmzvmbQkwqH1CIjZZhSfHLWXEG4mkAWkcVCpm8iaTTeJ5kZSki409PWcmuOMCD/0Q1ImN704sCfdL+bcjGHlMQldXV0W0KvwxiZvPP5yCCENisUzgn6SoOdpB/qb8ye4p6iXeFGsg3DUbGn7JoNIZEin2HlkN2R+yHT48kHqWbSqdmJRyTRj8dVvZeUjZ2qo20571ojKaPkTdFQ2hnh8ERRmOhIixAYc78WUTHX2mnC6okzhIqgQj42wVlVL6SfM2RfJzju/G4/fiEPpFVDTf7jj5z2/pV6EcespFMwqIN69qOOeVtZmbFsNjMapeXs4s/Sv4+zpFaSkCMRnYkCMU1EjfMN60uH9veuBfaQvaw/2PGs2epOL9+oBqouvjqzhLzZDlj6QT13gKdNA/VcYAf7IbDpUl/2/oEAM4nqx5K4wyBW7IBpszrdiJr9L50Dh022wXPT7
 67u27EkX
 BmguGDRwS5aY81ps/QudFxAYRdawEM5cuKENU/x7l3m3Blk5cOwGWQTeZkfh9yAKYxQMCMkZ0HtoGpruILceREcdMxeimnCK9iJ4OZ6l1/km2PfARDXyxYSJt9E7Ewjrx9fU0qnrJhDfMGg8Le8B4yagzFwoCKfG0FMopocutXaXjOcWUb4XPLGgPERWa5tzIJwMpGZd0XZd8tn7ih53dO2dlHS9keHk/1ZKRcJMBdVU8/PC+f56pgZukuyFtlBAN4KRxBqksN/KFxGZ2SU4OFkGEtNrXvQhfdLPgaAX8dfgiAzCjAzzL+he9WAbErcgM0tFjzAAg+E4hEDDW6Xno3o7Htt5QYxbWt4wu6WiPmfqWhUhILmHp0CylwR1MNAfo9jiVw37sudNHYVDZ61YOcsE5ca30WJSU1MZsNhve+dBaB5+UE1MeeQH+WwWUDxAbVk4AivtQrLOonZyF6ucWRTngMAalAL8iVL9OL+don0wEWRcYQNDNDG8TwrBApEhIqwkV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to separately allocate ptdescs from pages, we need all allocation
and free sites to use the appropriate functions. Convert these pte
allocation/free sites to use ptdescs.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 6c6eb486f7a6..2dcb565d8f9b 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1408,7 +1408,7 @@ static bool try_to_free_pte_page(pte_t *pte)
 		if (!pte_none(pte[i]))
 			return false;
 
-	free_page((unsigned long)pte);
+	pagetable_free(virt_to_ptdesc((void *)pte));
 	return true;
 }
 
@@ -1537,9 +1537,10 @@ static void unmap_pud_range(p4d_t *p4d, unsigned long start, unsigned long end)
 	 */
 }
 
-static int alloc_pte_page(pmd_t *pmd)
+static int alloc_pte_ptdesc(pmd_t *pmd)
 {
-	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
+	pte_t *pte = (pte_t *) ptdesc_address(
+			pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0));
 	if (!pte)
 		return -1;
 
@@ -1600,7 +1601,7 @@ static long populate_pmd(struct cpa_data *cpa,
 		 */
 		pmd = pmd_offset(pud, start);
 		if (pmd_none(*pmd))
-			if (alloc_pte_page(pmd))
+			if (alloc_pte_ptdesc(pmd))
 				return -1;
 
 		populate_pte(cpa, start, pre_end, cur_pages, pmd, pgprot);
@@ -1641,7 +1642,7 @@ static long populate_pmd(struct cpa_data *cpa,
 	if (start < end) {
 		pmd = pmd_offset(pud, start);
 		if (pmd_none(*pmd))
-			if (alloc_pte_page(pmd))
+			if (alloc_pte_ptdesc(pmd))
 				return -1;
 
 		populate_pte(cpa, start, end, num_pages - cur_pages,
-- 
2.52.0


