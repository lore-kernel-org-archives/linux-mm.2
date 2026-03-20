Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23CB21099B33
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E6306B00C0; Fri, 20 Mar 2026 14:23:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BD586B00C7; Fri, 20 Mar 2026 14:23:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F226B00CA; Fri, 20 Mar 2026 14:23:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22EFF6B00C0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:23:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B25B9160330
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:46 +0000 (UTC)
X-FDA: 84567264852.09.6B9CE74
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id D756318000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nBJs+VZ9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3r5C9aQgKCBwB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3r5C9aQgKCBwB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hsIAd6ccjWbW954pR6oCy9OY9Eau050KLHgEMawbPLI=;
	b=hii1ohWCly1w8Cddc7+0kmVQFdwvWAPWibHLJ2wScpq01L6YoKUzR+VKsGdp6b/dKVGYCW
	IWhMjlRma96jpzMcjEEeE+MNtyb5WvcWpnikC55YpCRzpuxfILRkZXbqlltQKWXrrvn8sZ
	opHXO9CGB5CFfq4CVEBFWNXdxmgHNhA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031025; a=rsa-sha256;
	cv=none;
	b=lT452LulzJlP76QaHMlUvSv0bG2tQysRFSFUAIEMfZEj/orA6/YTYFZIm6LlUyrlC2snQN
	PcAgR8VVWzK/MGqJtofG8MlsG/1mk27uIuMcOP+xOVSeJcA0GMu4IXlFO9Oef7lZlEMxEa
	O5/BjCG0pklcLJx7gaKexLqNvhpL7TM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nBJs+VZ9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3r5C9aQgKCBwB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3r5C9aQgKCBwB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4870221e1fdso4001055e9.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031023; x=1774635823; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hsIAd6ccjWbW954pR6oCy9OY9Eau050KLHgEMawbPLI=;
        b=nBJs+VZ9DCBy/zTIlvqgYxdtaTZDMNZV87Sbc8Sk5I+bw5Rqcjq1WeOq97jyQkc9tb
         Jx0FOPoLfAe7Zex4/4Bwrk5I3lL4m0zFKbGXZ8Jft8sMIk5RT32WjZlB8aGezGFU/74y
         KiI8UcXIbhlmYi3X4maT0GhH/XHJx9CvVRnYiHbxDyqUIuEM4b4ev3sk1/9k7/FdirRi
         dQA3do1HpM8xdymI5IymoljuISQmtkK3ojwGFBA4fwWuu56CGpWodyf7G8OgSC9dXUaC
         YI7PgYP8ZZAhjsTIOMqEpd9i4EsRVJgRpnPgkMb4y5ZmHcj6g5eXb75kxU7PzDzGS3DF
         xk8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031023; x=1774635823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hsIAd6ccjWbW954pR6oCy9OY9Eau050KLHgEMawbPLI=;
        b=jGpv9OOhmYsg5buGwvtnhP3tdWHZ8RjUmJW8CyQBTicWZ4OWkLFPnXNTX0TpoB4oAd
         eqxpH6SewNk3uI6DGQ1uRbe9Vck7PgMw7xmI+5K+2dS19TB07CWBD1AdQkKCS4roLO/1
         0waOmNvMxYHts4Y1Cq7uz3L6P1/oUPdtnXp8dHdqJeORhOYBiCRMWRfHiH5jNsJBc4jM
         qh3z41+DnDegxVyxMSyVsICKWpeFSSysx0MXTjYn+ozR8Hiu/hdONmyc71BViGDBR7zP
         nR7awJbSDAbIwVCA6wYsJ7PqTxJEeyNRldJ0bJMQggm93+zq76GaBgHs9g+zv14Z3rmd
         y69g==
X-Gm-Message-State: AOJu0YxqAqb29Yb7uj3xOih1Dx/VE35ZpaS2vJsd5xyVq90fHHm3SbRn
	QgHAFSSLBchVESRhi/5Wryd7JqeCUvDnkVYgjwmnsjm71M11176TE8a7Zj89bZ9zqk9bAxWk5wW
	Lx20SoRtEaTt0pQ==
X-Received: from wmbdx7.prod.google.com ([2002:a05:600c:63c7:b0:47d:5bef:a379])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8215:b0:46e:59bd:f7e2 with SMTP id 5b1f17b1804b1-486fe8e4038mr64340455e9.11.1774031023244;
 Fri, 20 Mar 2026 11:23:43 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:28 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-4-28bf1bd54f41@google.com>
Subject: [PATCH v2 04/22] mm: Create flags arg for __apply_to_page_range()
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D756318000D
X-Stat-Signature: nwhk7km9xtxqzbrq4bs9rr37aj7qzqw4
X-Rspam-User: 
X-HE-Tag: 1774031024-366863
X-HE-Meta: U2FsdGVkX1+1F47dNbuQsrgI0ODORESIEjDsbDJGajrFStBRyhLUnHPEu4FM2z1XJbLfjBrjcyhte9hCUTuPYpYuUr3r8sTUeKuQNsXrG5p/sEIiN1R4Fe9GlnVzrlBwzdGJjwPzzdhEOb8+7ewXLXOQ+aP0vDkSZXqzTITmHlCjiMrqKdNUmQAU5e9K3UjCM5mIPMINlRzx3ePU85YGwA2rp0RdzNAPC9AYO9+TgqUcZThJ9VsLSKggJbrC/bWmYYiFo6Uoh5JMnHBSi5QpvtCq6xskjsPpOnGeAJ767Wc/oH4kLEQhgvfN5TXIqr47uNOivyaMd2a3s61u4R3ZLAq25AgsJmbcDN0n8uQaIPzhVXpC2AiCg+D1Wwa3yG7xY1y4f1ktVlQ0cNW3A6kw93et3BuJVyNBkzLZAo0Nrv3ljTKWEpJlNkvLQElh15le5/ZAwtyzfUpTqMaqVM5UyGK6FnSDGVWUtl4ecybw38E8IGOOxkadN3EoWHDp2EAEsQQBxcAdNuKZelwhmPaDVDOmw1zFPxL+N+W7lH+pQP/mF3FIxLEPnhIOaoLKFQCVI7MYjtZAt+Ya/A6qWc28x5LJmZHYRzMiVIutU3Xe/nOkKrITcnVkOwLciwoQJrwOwzO6cI6Nv8aqMbukTfAoLTcmxl4ZJAGqsSOdctwWg0u4y406nO3sLnwYBaay8Btvg5jdVyUFSDDQvE582GtxfcvehtCTl2reDUfZqXE7GYVAT9A7vZHhf4ZsNxCgps+WQc84+X4D+xt/csEaN4YNMPcFkRtbP1JfDWNcXbESvkBxSOCNr8WlYlHueGU6FaejOH/ReX4WTjTzSYDKy66wb4ZopzTvzB6TQANGFb+7TAH080wkUd3tlccpViC30LnWbLj0/vhFEQ6PoMqFy8sVmCq0DrmaFrmH5a28hXKv/OVMFKF5W5cV3uey1Rdw4dJbnE3FNyeIIka1tC+oY8z
 6NlpiY0a
 PzjCI6NqXw+cSZQHJXbnJunMmfAkxTOuR9Zuca1BbgZKww/wiWzvkdb111QmoyWcUl0DnTuqboUg4UAR2HYwTd9l8Q0An1ZxxCXkm/9HUPmqT2Flc1md5NIJ1RHwnNKHudZrPghsjGssR/dh6HF6f5LX2EBlKFSD8l5RlZF0rhYb+0B0Aq8lzsV/kaRb5YeetHcWFOuFoQq63gW1ml1YoxAPM9LrBZWaUSMG7WNy6P0ao3kew42Y0Oa4ctMCZSeSoLsb26xCayhzqcdXXQQy+qD/XlQCyeWPcOP+9S0cry0QOWsq37UMRS/qqXqXYUlrYNa3gdpLIqY9idB9QD8ez4GYfJ9sLG7pU3tlL3qWdQE2zwRKYmsb/+KzVgB1a24lOp2QzeTkvq2WM4AQ+VIFPVN7+JUZnb2/VcrxAfMPF60moZXet9QWFw0DZsg8tBinI16H5kBXx9mfvcC1fAsOn/7WGW7hZBaBUeza2vZN8akHcbmFBV1z4lQB/UxS9DvEjgiV36Gyu03Jr8TeXPTqCbljzHcm0IlFQOT2nSAitYQOruqby32gi7EdIGUWp7mpgpjRxun4e5mlhOIdKE9IIt6Bt7qB2L15fVjOGSTXD2eJm+lBQQVjCKw/eWW0w1I0x6fln6OKFs+CaUlc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Preparatory patch, no functional change intended.

To prepare for making this function more generic, convert the boolean
"create" arg into a flags arg with a single flag that has the same
meaning.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/internal.h | 10 ++++++++++
 mm/memory.c   | 29 +++++++++++++++++------------
 2 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index f98f4746ac412..4b389431b1639 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1870,4 +1870,14 @@ static inline int get_sysctl_max_map_count(void)
 	return READ_ONCE(sysctl_max_map_count);
 }
 
+/*
+ * Create a mapping if it doesn't exist. (Otherwise, skip regions with no
+ * existing mapping, and return an error for regions with no leaf pagetable).
+ */
+#define PGRANGE_CREATE		(1 << 0)
+
+int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
+			  unsigned long size, pte_fn_t fn,
+			  void *data, unsigned int flags);
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/memory.c b/mm/memory.c
index 219b9bf6cae00..7e55014e5560b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3208,9 +3208,10 @@ EXPORT_SYMBOL(vm_iomap_memory);
 
 static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 				     unsigned long addr, unsigned long end,
-				     pte_fn_t fn, void *data, bool create,
+				     pte_fn_t fn, void *data, unsigned int flags,
 				     pgtbl_mod_mask *mask)
 {
+	bool create = flags & PGRANGE_CREATE;
 	pte_t *pte, *mapped_pte;
 	int err = 0;
 	spinlock_t *ptl;
@@ -3251,10 +3252,11 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 
 static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 				     unsigned long addr, unsigned long end,
-				     pte_fn_t fn, void *data, bool create,
+				     pte_fn_t fn, void *data, unsigned int flags,
 				     pgtbl_mod_mask *mask)
 {
 	pmd_t *pmd;
+	bool create = flags & PGRANGE_CREATE;
 	unsigned long next;
 	int err = 0;
 
@@ -3279,7 +3281,7 @@ static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 			pmd_clear_bad(pmd);
 		}
 		err = apply_to_pte_range(mm, pmd, addr, next,
-					 fn, data, create, mask);
+					 fn, data, flags, mask);
 		if (err)
 			break;
 	} while (pmd++, addr = next, addr != end);
@@ -3289,10 +3291,11 @@ static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 
 static int apply_to_pud_range(struct mm_struct *mm, p4d_t *p4d,
 				     unsigned long addr, unsigned long end,
-				     pte_fn_t fn, void *data, bool create,
+				     pte_fn_t fn, void *data, unsigned int flags,
 				     pgtbl_mod_mask *mask)
 {
 	pud_t *pud;
+	bool create = flags & PGRANGE_CREATE;
 	unsigned long next;
 	int err = 0;
 
@@ -3325,10 +3328,11 @@ static int apply_to_pud_range(struct mm_struct *mm, p4d_t *p4d,
 
 static int apply_to_p4d_range(struct mm_struct *mm, pgd_t *pgd,
 				     unsigned long addr, unsigned long end,
-				     pte_fn_t fn, void *data, bool create,
+				     pte_fn_t fn, void *data, unsigned int flags,
 				     pgtbl_mod_mask *mask)
 {
 	p4d_t *p4d;
+	bool create = flags & PGRANGE_CREATE;
 	unsigned long next;
 	int err = 0;
 
@@ -3351,7 +3355,7 @@ static int apply_to_p4d_range(struct mm_struct *mm, pgd_t *pgd,
 			p4d_clear_bad(p4d);
 		}
 		err = apply_to_pud_range(mm, p4d, addr, next,
-					 fn, data, create, mask);
+					 fn, data, flags, mask);
 		if (err)
 			break;
 	} while (p4d++, addr = next, addr != end);
@@ -3359,11 +3363,12 @@ static int apply_to_p4d_range(struct mm_struct *mm, pgd_t *pgd,
 	return err;
 }
 
-static int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
-				 unsigned long size, pte_fn_t fn,
-				 void *data, bool create)
+int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
+			  unsigned long size, pte_fn_t fn,
+			  void *data, unsigned int flags)
 {
 	pgd_t *pgd;
+	bool create = flags & PGRANGE_CREATE;
 	unsigned long start = addr, next;
 	unsigned long end = addr + size;
 	pgtbl_mod_mask mask = 0;
@@ -3387,7 +3392,7 @@ static int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 			pgd_clear_bad(pgd);
 		}
 		err = apply_to_p4d_range(mm, pgd, addr, next,
-					 fn, data, create, &mask);
+					 fn, data, flags, &mask);
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
@@ -3405,7 +3410,7 @@ static int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 int apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 			unsigned long size, pte_fn_t fn, void *data)
 {
-	return __apply_to_page_range(mm, addr, size, fn, data, true);
+	return __apply_to_page_range(mm, addr, size, fn, data, PGRANGE_CREATE);
 }
 EXPORT_SYMBOL_GPL(apply_to_page_range);
 
@@ -3419,7 +3424,7 @@ EXPORT_SYMBOL_GPL(apply_to_page_range);
 int apply_to_existing_page_range(struct mm_struct *mm, unsigned long addr,
 				 unsigned long size, pte_fn_t fn, void *data)
 {
-	return __apply_to_page_range(mm, addr, size, fn, data, false);
+	return __apply_to_page_range(mm, addr, size, fn, data, 0);
 }
 
 /*

-- 
2.51.2


