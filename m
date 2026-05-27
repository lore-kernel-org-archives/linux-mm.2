Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4586FCD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4A56B00D4; Wed, 27 May 2026 10:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D54FD6B00D6; Wed, 27 May 2026 10:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44146B00D7; Wed, 27 May 2026 10:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF46E6B00D4
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:04:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A0DA1618D2
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:22 +0000 (UTC)
X-FDA: 84813369564.11.A9D597B
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7F1DAA0010
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ii2MSwSV;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779890660; a=rsa-sha256;
	cv=none;
	b=N9sBAqwpTnmuU8KbwA6oaB+jK5uDYFZMd3YKw58SrgbwoogbM1gxyOS0TQ6yanzMddhFeX
	8IEbRH2z1i2c81XhIyJKIUo+vKCHbwIe4ndXumqcYCU6S09PAy2MPIMvzqK8nxPcOBiTx7
	I0z1n8iKPW0dgjE5oFXlLXvrhZLTIrk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ii2MSwSV;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTSySM1IXuxmAttzVws8JAQ2H8JyG4d5fVSSFWyPJsM=;
	b=bFy8Durlt/QhpKBwQExGaaymtvBJ7j4jrd0UeRdDI8euYG+GxwGbLnKzq60COgObN0AsDb
	88MiPrO929IfYOWU2ICV5D962/UKNTclHv3C6XqoNxUYrU1xbeKWMaz9hUjCjyZeo1zfMh
	Zvfg0gJiiwGYDdHq2f0J6L7TcuGCe2w=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-44dd5cb0f81so8339031f8f.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 07:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779890659; x=1780495459; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fTSySM1IXuxmAttzVws8JAQ2H8JyG4d5fVSSFWyPJsM=;
        b=ii2MSwSVqzYn1RkoeZNDy/qwSsAwRWx2eTLwUuV5xvrG4ibIhBhifCyskYuhLKltJm
         v0+w3R/rh9Zo7CGuCz0N7J7NSe+BLXQvtBlJ6ViQUkrq9jnunxu9MD3y/itBJWDSJoeZ
         vm+7wWPJbST5EBnXSvRpwJgk25VXHANdwu9f/YKJwY2Ebt/2U5tffL4BQxCKRX7BTTah
         0DYljMhEp00P/Jm81VSKe1qh2mU//RV1SNSNHtU3rNvXwJjMsVcaRVjmh8YnU5pU3htX
         XoB+L0u7Wp263eSLCS+IbiN0ByuRE5Fg2/h0jesCprn5TqAvjyNqrqfiLZNcLAXKbjAy
         jXHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779890659; x=1780495459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fTSySM1IXuxmAttzVws8JAQ2H8JyG4d5fVSSFWyPJsM=;
        b=Nm+wLey7J9aW4B7g6z5WB/4kXRdbeLCVe7HGfLKvjNshgfZQdrihJbqquCe/TVf+h3
         3VNtW+qB0ZBk49sJ4JZg/qRW3GqmGZXn5JlSYhTlhBrMEPVW4ZnzhtzUdLtPKEwTs8FU
         eFfXIjOBirCukayS9iP0WqT8Zaan6YFV+wOnTN6GJUpuVxToF7QYmDgbwOSn7EUER51q
         HRean3SDlgsjSVC/gPXi5e86ilFeEr9PCuZsYi5mDUDTVP1nJtXrNxVpOHvCj9GehuwC
         jxcJdRp7j5ano2vRaII9jwUyhEMlKvMK3mVscFw58GPF2FP3GAcAhqcskGTLuIzmwX6G
         Vifg==
X-Forwarded-Encrypted: i=1; AFNElJ9JOlqQ9WdaAsZl8BEFPZCtbtDXBiNrUIXjQMbxU4tgZNL0SUPQGywOsUbEZeanBzTKyXd7hLQ/CA==@kvack.org
X-Gm-Message-State: AOJu0YxwW+atouoo+TaGgDqKznkJyV1XwHRaIAsa3HVLShjUA4eioq/R
	T8JdJGaG7scLBexOL82LZ3khXGEZQPfwHtfoXAVpVaNnRipVdcQqhT+B
X-Gm-Gg: Acq92OFLH8wN6IjJqOIg9BWKnJRGNSuCahlSQ5+xVBbRX5iIw3RSNoWFHTQLbHa/izS
	0MFkbk1Zmv6doxfh4YeqhItmKiOHmcslkcGAQnNryFjYOvEEiug0wkKzQUemUj85yzG1Ql+9GJz
	WSPnCLiT9EeEo7fcEb2+91b1EQp5UKCE6aV2nmQ3bNWwmXIXDGQm7OAaiS1DapboFGinhyR+ic6
	zAs0BHNGjIpjJDIEoTXGR8RZ/y+IjTufOx6ga/4YjdflJpPT3L/vcGhyK4NaNOd9VqEedA7nlp0
	v545y5EBd4p98NZXXQqfExcqfNFmR6gOG3dSteSetKx2+mm70FOPC+Pd0w43K2Qnz9vzLRZGUci
	K5bWwwEYQCi8hoc+5lfW5aEFGq74eueCPMA/NSBCM8JVknGmONcX3OcDTcZAg4fOnLnKT/3nWDn
	5ZFFBLx7Q288BHybfk+dI3IEeZo3GgneUJz2w3n/nMSfzTqpQVP0/feSHhTfBEkLXtonWSpmrul
	oqPBDmhIF2XMWiMsdPsamEpVN10z4MapA==
X-Received: by 2002:a05:6000:2992:10b0:45e:daa9:f34c with SMTP id ffacd0b85a97d-45edaa9f405mr5335873f8f.26.1779890658948;
        Wed, 27 May 2026 07:04:18 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-45edb558f52sm6693771f8f.14.2026.05.27.07.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 07:04:18 -0700 (PDT)
From: Vishal Moola <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	xen-devel@lists.xenproject.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Vishal Moola <vishal.moola@gmail.com>
Subject: [PATCH 7/9] x86/mm: Convert pgd_page_get_mm() to ptdescs
Date: Wed, 27 May 2026 15:03:14 +0100
Message-ID: <20260527140316.294621-8-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527140316.294621-1-vishal.moola@gmail.com>
References: <20260527140316.294621-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F1DAA0010
X-Rspamd-Server: rspam03
X-Stat-Signature: yapficqkgo7jb7bigxar5znkrgm4e7i1
X-HE-Tag: 1779890660-746326
X-HE-Meta: U2FsdGVkX1+QOLcg6IhoEMceW1cKCDbOTPKRS8olJC5wdWB/WJCNQLm/R+QZEhGPpBkzjfO40hcRWXAFkIlPCvJrQE/iJknG4JMEcGCza2o1n56GGn7bH9kK8lOSyYGEslOigTJirApzAjjWOI6BHzz4KOvNx4DXw9pmVfu9MS3/JCLMh5vAaFDFEs+FTVfE4p6d+9ey2ModgVGCfavIiAnP9CdY/zjXS+xtqaPXcxuIwQ2xyMA5jbOZLUyeqEUJHlVowZ2jznRe3FPixqt+x1kUqWJmCSlC4l/xX52Of6tgMRn+mi6Q/4liityqi1NmZwSzkSwh2Kg4haWCAUWTcv1iJ2KsG0gEGXUvPIDct7vJo7AG+qUhHNOcw6C39Go2JYh6j5Tr43Q5kiLEGQGkvZWJS/HOcYkE6/rLXIZYdoG1SCEw99aKsDLzzftBQRfxqnnI3ghnY04EEHP39l+iRSAckDEhps3oMmtA9qjU8ypLJHHX/01EndlOupPXjmYYqDDxn0KzY9t9mA2fN5jNtX+5NnOgEKu0dxQK8P/5KqbKLt90kwkO5L+xzjoMCQJLXo9b8n3jMiZHJ7SLCxV+HG5Xh8+jbs+9aLZfJfFUKHtR9tcH/wfQusR4ZQfoeFBZflWhGSmQzFyFucQ+LXBgek2dxWZLDd1I9y+MxRhFtRojjF6yDlT+0tJeSBlimPnEEdkCU/D5E+f9Wd790Fap6BbQdGx5CY65oMgGRDq5+rExfpBfOWYQPKcMtxtdaGrIKupjGsPmCsQayQjY5eoQoEI4+oz+cy8qBRvbx/tyzDnRKQpmSIenm+D4rGIVxTpTjsRfERXCTkK1lR8EIj9kPG6q2uRJySWZrBs+7ESEzS1byX5E+153lI5lZxfsr1EthVaJS62geCspsI450yC7tMicfcJSIkPaoZoIce/Zz9PI+x37XjHJQaWD538eBz3eVzaeSw2oD7wSIUKdsCC
 JQDGUiEs
 EnVRODkRcWa5RbMAsXLGHWgwApq+KwBSZli/YJyyDhpdiD9rD75ZY5E0XiXVakKXOwy2uMNjt0MaRjS9ZeykA1NECCiZ176h0GI8PTEJoD6NklpXmL5tC5LZb/yP+SyE2kERCpSDb0+YkbJHmbKAJDoriN2yebRB6ytKA16rK7vHFBZekBc0MbP8LT2oXlUME/M5omS8kmpsPES5ULaXLcyaR6m/evrBKVlK5GrL/hnK7koc3l7PnXi8gtrn5IFAZsLFaqYKHKW5bvJFCiriHO+KjpWlKepzW+bQqi9C3RILhmGRHO3shG8HUz6OdfynoFOmkWPlweKyX5ekiwmZjpZwksAbnry9W5612T0bYn7v8ufIZIRKxPgImrYmhhGEkAfO6vLKmGcHYHvFmvj/M1kxDxvZFMLrMYyQ403gAp7cCIIKwsl6bdLqZj7aM/uVDPqEB81TOdpNegm+seekHFUfbBks6lZ+XcadjQbppO+8LfCv0PI8gyc+LLGVHd3nAKoIU6XiLBqH3+ZUEm3Z6lNXQH4C2+4lJF6+kkktolk3c5/RSfPZ9DN/7kA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert pgd_page_get_mm() to ptdescs. Define struct ptdesc in our
pgtable_types so that our declarations recognize ptdesc as an
appropriate page table type.

Now that all callers are using ptdescs, we can pass in that
ptdesc to get the underlying mm_struct.

Signed-off-by: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/include/asm/pgtable.h       | 2 +-
 arch/x86/include/asm/pgtable_types.h | 2 +-
 arch/x86/mm/fault.c                  | 2 +-
 arch/x86/mm/init_64.c                | 4 ++--
 arch/x86/mm/pgtable.c                | 4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 2187e9cfcefa..20e8a6ddd2df 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -50,7 +50,7 @@ void ptdump_walk_user_pgd_level_checkwx(void);
 extern spinlock_t pgd_lock;
 extern struct list_head pgd_list;
 
-extern struct mm_struct *pgd_page_get_mm(struct page *page);
+struct mm_struct *pgd_page_get_mm(struct ptdesc *pt);
 
 extern pmdval_t early_pmd_flags;
 
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 2ec250ba467e..95c7f453db17 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -512,7 +512,7 @@ static inline pgprot_t pgprot_large_2_4k(pgprot_t pgprot)
 	return __pgprot(protval_large_2_4k(pgprot_val(pgprot)));
 }
 
-
+struct ptdesc;
 typedef struct page *pgtable_t;
 
 extern pteval_t __supported_pte_mask;
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 6c72d6668416..4d78c78a0bcc 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -276,7 +276,7 @@ void arch_sync_kernel_mappings(unsigned long start, unsigned long end)
 			spinlock_t *pgt_lock;
 
 			/* the pgt_lock only for Xen */
-			pgt_lock = &pgd_page_get_mm(ptdesc_page(ptdesc))->page_table_lock;
+			pgt_lock = &pgd_page_get_mm(ptdesc)->page_table_lock;
 
 			spin_lock(pgt_lock);
 			vmalloc_sync_one(ptdesc_address(ptdesc), addr);
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index a6ccb83f2d26..a49be75dd713 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -152,7 +152,7 @@ static void sync_global_pgds_l5(unsigned long start, unsigned long end)
 
 			pgd = (pgd_t *)ptdesc_address(ptdesc) + pgd_index(addr);
 			/* the pgt_lock only for Xen */
-			pgt_lock = &pgd_page_get_mm(ptdesc_page(ptdesc))->page_table_lock;
+			pgt_lock = &pgd_page_get_mm(ptdesc)->page_table_lock;
 			spin_lock(pgt_lock);
 
 			if (!pgd_none(*pgd_ref) && !pgd_none(*pgd))
@@ -195,7 +195,7 @@ static void sync_global_pgds_l4(unsigned long start, unsigned long end)
 			pgd = (pgd_t *)ptdesc_address(ptdesc) + pgd_index(addr);
 			p4d = p4d_offset(pgd, addr);
 			/* the pgt_lock only for Xen */
-			pgt_lock = &pgd_page_get_mm(ptdesc_page(ptdesc))->page_table_lock;
+			pgt_lock = &pgd_page_get_mm(ptdesc)->page_table_lock;
 			spin_lock(pgt_lock);
 
 			if (!p4d_none(*p4d_ref) && !p4d_none(*p4d))
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index da7f0a03cf90..070e3d310eca 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -74,9 +74,9 @@ static void pgd_set_mm(pgd_t *pgd, struct mm_struct *mm)
 	virt_to_ptdesc(pgd)->pt_mm = mm;
 }
 
-struct mm_struct *pgd_page_get_mm(struct page *page)
+struct mm_struct *pgd_page_get_mm(struct ptdesc *pt)
 {
-	return page_ptdesc(page)->pt_mm;
+	return pt->pt_mm;
 }
 
 static void pgd_ctor(struct mm_struct *mm, pgd_t *pgd)
-- 
2.54.0


