Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDC99D3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 14:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EB226B008C; Mon, 29 Dec 2025 09:55:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C0036B0092; Mon, 29 Dec 2025 09:55:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AE106B0093; Mon, 29 Dec 2025 09:55:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19ACB6B008C
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:55:07 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFADFCE6A7
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:55:06 +0000 (UTC)
X-FDA: 84272806212.16.28372E8
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id D6C77120005
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:55:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf29.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767020104; a=rsa-sha256;
	cv=none;
	b=6UkDYPiJQQ2/ehnaqssSebbm2uy+dz6iKjtGxUN6S33a2nQayd7bpTLT0lcis9WlG69t1Y
	I6rPj6turjhIs+eSnuVyfQDDTRyV6YFY2vXbQXrYkm/+kbmCEvd6m7OEuBNLXaB0HtRjBh
	BFarNtuwF9VNfnjPb252A176VmgORQU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf29.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767020104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K2pBV4vyT2c4GBUcrUp/G3rP2JcNWZOiRH8LtGLdyis=;
	b=fHHGZwqU2/S1S7iNwHDVvL6qnAUzkvYXZdZgpLy7+oC6wSrjhkQNHhS2+gC0NJeiCQ+l3v
	5x4P+ZouXUK8FJb1Mqhd9VTZEM8OWT/F77/Ab6ZqnPDD9b8ORJdjN8PpH/+pHa1EtdE4px
	F5B7SR/8uUC9c05R+DTwQ+9PQbP5jyA=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34ccb7ad166so8452633a91.2
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:55:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767020104; x=1767624904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K2pBV4vyT2c4GBUcrUp/G3rP2JcNWZOiRH8LtGLdyis=;
        b=SVxs1A1iszLYqDiodM00ObK9S6S1DQYodmBGPcviZJNkZhA1zLXtQfkb5wOpzfusJb
         8n69fRDDerv2jVClqrzyVIqHyeZdHGUKveGAyhCPFPDQQG6pqC8GAu2N7hHebL2r12th
         obeuABSzDRWJLAYRV/NJTAp/qWsI47xQdLIAP3gJ3AaBhNtsduOiQgWbuYKuGa/eqO+d
         whmrPvM5FETn5lvwGL3KD5xoHJLc9WWG1EPbTQMatqzXQ4s0bOnz77QIM6ODX+kIR/nu
         xNs4+AfJ1wtPK++pwnxiukP7NTbxhn8T2IO5ZmM/CjVzUc3W3cv877fIFBdR5hXq1ZQe
         KrsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtqP3XR9ehr5duCAY7LqTs8C+jcGF0oJW8CLpMOVM3q2n9aQoK28vNrTZnHau8oeLEghqJvEVMgA==@kvack.org
X-Gm-Message-State: AOJu0YyQel6Cs6h0Yii/yac3VOMlqIufzuXr7/0ly9CZrObxtJ6yOwQ7
	5Z4CY9YdXZ2CO30aPKh6sgrDZWwUxKGWtHfO+PARFvm8XOiyRe3gE9Y+
X-Gm-Gg: AY/fxX6oL1UFgTRmfO+KQ40e73wbHn85+kei8iuSEiesDbKmPVbZRdoEpLOK0YfzFdS
	8nSc1hT4434O/OKUzW9Uzj3Sq4JhN8qYxI2e4P9Tp925IZJCWQdGlzESuammY8z1+h2PXrbDvK/
	VN/KNtw7Oj6VtR0Y+b28ieAC8r1qWoAt0NvR+J4lS3eC0v4odDVjdpXcrVfks/ErUu5e4vqjmWc
	725WOlKjTLrNAemz6UCaprzEP+oMS5eRYUbOZKECH30KssIAU1p8iZtg3Jkpr8F9qoU5ZbvuRuR
	AFz4sz/1DKDNlxDAcOZ7NpKcaXxQnch6ID0l+jy+VnAgIlLUxXZlzM7fC33xUuLdTu4ITFU8gDt
	XyrtGTpknRfQf5OptvjXgpkPjXsQtN+zLdivmOxWpQOELLppIXkFqoyzxr6SVo+XpBtRIVoBWjH
	q0w3c7E+a6E+CE3I2WJqT/
X-Google-Smtp-Source: AGHT+IEf9Iv5nOPUSm+mp/HKv1O5w/lt7w1F73FenhI+IdA1+6z3gDDv4Fw3i4Tf4eeD+0sQQsI38w==
X-Received: by 2002:a17:90b:560c:b0:32d:e780:e9d5 with SMTP id 98e67ed59e1d1-34e921c3003mr21256159a91.22.1767020103739;
        Mon, 29 Dec 2025 06:55:03 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([103.88.46.167])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70dbcb6esm31557603a91.9.2025.12.29.06.54.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Dec 2025 06:55:03 -0800 (PST)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v2 3/3] mm: embed TLB flush IPI check in tlb_remove_table_sync_one()
Date: Mon, 29 Dec 2025 22:52:45 +0800
Message-ID: <20251229145245.85452-4-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251229145245.85452-1-lance.yang@linux.dev>
References: <20251229145245.85452-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D6C77120005
X-Stat-Signature: 1t983edcft1ak1kdwi38ccuaz1shg6oc
X-HE-Tag: 1767020104-154981
X-HE-Meta: U2FsdGVkX19biwhSx4gEMMWz/n74euDySz+fVXrzH8E4JHSS6oSf0suA9SyLZEvtoLfCd+U3wVc7GFDXHYH0PM+mTTcF1z+Lg/9jUhrmdnun15nfhBSCeMKYIVLPq4A9fjdYmFL9OU8fRdYG6JVM80e57xn5g3UbBSSRSs03PIp8GiHnNDbQo0t86ISXZoQt1p3sOaTkLETO+C9o2i2bc0NKDrlBL55uEOeIUZvvJ8L36ogW5OyPNifUQLbWTS7VkYbXSxFgmzdHFdmIfqbfuV92sCB1Rh9IfAi426XSvKtW0UvraFSd090hF+0vN0GYnJisN3hFDEAGqFtyyuQRA+joVKc/EVE4tq/d87TbX2FAmz+fTE46qrkKE2Y7MSCEepM8xJrPRWNKYo4TdC7p3avrG+KjbY0/2Z2zJqOb42vqHnCbyL8CJuAqqbG7eDXLe1aWlNPVOtxPqTvV8VwR/sqIqomnyTLjyavZsJ61+JgD8dYrqo0g6hRxZ+KncnezE6pfA6mGKY8EW1HzlEUyEW+4GeJhv9ovQJ86SYJ7p6fib/ivgOXuFA31P1WlsITSm7nnBlb8DX4pjlrOwc4+8aTrrDKgwrkagIGDF+f7F0aoz/0dkVwYyKaTaENN1MXPRWFOxUNsvkDhAgQd1kHovspcAOunIzBJr7pxc2tOl5sRaH5kTZ6bofwBHhqCix+XuEhQwnqC2comm+DeV4PKo6HKwXsTRDbknnSjpc4VBG17t2DiNeSCIBl5rJMopk+EAb8MT95pSOb4U29KBTDUohmx1rTGHlWPkByGDVIHRxt7J2QGOJv/6IUg7E1hOFI9ZDCrumm+EH6JQu0sGCm/XTgEnOJKgrzyPIEqgzQQ6m9RnSF2C57N0g7TWe1dZSQOD46Rsr0F6PegezPpTj1vlNqasLM+V+LuJmjRuapdV4TMWq2zoPrTgNt6f8LDSyFdi6y7vcyoOO4Dzd4S1Se
 0DjNqZtN
 OYq5EozEbo22Ehs1BTFzwjOIjz3+dtzuMfNRBcPuzrmhlrMQP81sDvtMhbn/mMroqm3BTkihY42oOqMKbsrHOGZr9sG6Kc/20gm3l1hA8ug7tMKbU07i5SFgrmIRwgeiFr+Jug/TjGYywfa5RNKqnfQyP9AbwqTK/tUyL7DFPyEQEktovL3RSkC2a3/I29RQu/j+WMbHml3UG2blmS0k+B5lLAfya3wGMK/lIcp2LZTS0Opsln3wKW8/fBeGLW8PdCGRz5wPnCU/pYKpzRFnUX0aGHDk+eOhiNHw07Der+aZTdW8+/RRalA40qAW6IzDIN0ytrMar9kKOIsAJDzKZWuBv0bM85DbGZGwP3De1wBEE5u1uMf+JSXrY5yPqkB07K+mJSCZbP92nLE8m1aCwgiBHAB1Fi4mV/btDWWTVfLEMO3hLxVCvpn4bcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Embed the tlb_table_flush_implies_ipi_broadcast() check directly inside
tlb_remove_table_sync_one() instead of requiring every caller to check
it explicitly. This relies on callers to do the right thing: flush with
freed_tables=true or unshared_tables=true beforehand.

All existing callers satisfy this requirement:

1. mm/khugepaged.c:1188 (collapse_huge_page):

   pmdp_collapse_flush(vma, address, pmd)
   -> flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE)
      -> flush_tlb_mm_range(mm, ..., freed_tables = true)
         -> flush_tlb_multi(mm_cpumask(mm), info)

   So freed_tables=true before calling tlb_remove_table_sync_one().

2. include/asm-generic/tlb.h:861 (tlb_flush_unshared_tables):

   tlb_flush_mmu_tlbonly(tlb)
   -> tlb_flush(tlb)
      -> flush_tlb_mm_range(mm, ..., unshared_tables = true)
         -> flush_tlb_multi(mm_cpumask(mm), info)

   unshared_tables=true (equivalent to freed_tables for sending IPIs).

3. mm/mmu_gather.c:341 (__tlb_remove_table_one):

   When we can't allocate a batch page in tlb_remove_table(), we do:

   tlb_table_invalidate(tlb)
   -> tlb_flush_mmu_tlbonly(tlb)
      -> flush_tlb_mm_range(mm, ..., freed_tables = true)
         -> flush_tlb_multi(mm_cpumask(mm), info)

   Then:
   tlb_remove_table_one(table)
   -> __tlb_remove_table_one(table) // if !CONFIG_PT_RECLAIM
      -> tlb_remove_table_sync_one()

   freed_tables=true, and this should work too.

   Why is tlb->freed_tables guaranteed? Because callers like
   pte_free_tlb() (via free_pte_range) set freed_tables=true before
   calling __pte_free_tlb(), which then calls tlb_remove_table().
   We cannot free page tables without freed_tables=true.

   Note that tlb_remove_table_sync_one() was a NOP on bare metal x86
   (CONFIG_MMU_GATHER_RCU_TABLE_FREE=n) before commit a37259732a7d
   ("x86/mm: Make MMU_GATHER_RCU_TABLE_FREE unconditional").

4-5. mm/khugepaged.c:1683,1819 (pmdp_get_lockless_sync macro):

   Same as #1. These also use pmdp_collapse_flush() beforehand.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/mmu_gather.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 7468ec388455..7b588643cbae 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -276,6 +276,10 @@ static void tlb_remove_table_smp_sync(void *arg)
 
 void tlb_remove_table_sync_one(void)
 {
+	/* Skip the IPI if the TLB flush already synchronized with other CPUs. */
+	if (tlb_table_flush_implies_ipi_broadcast())
+		return;
+
 	/*
 	 * This isn't an RCU grace period and hence the page-tables cannot be
 	 * assumed to be actually RCU-freed.
-- 
2.49.0


