Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E82AC43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C4E96B00F3; Mon, 29 Jun 2026 14:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8273A6B00F5; Mon, 29 Jun 2026 14:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73EE46B00F6; Mon, 29 Jun 2026 14:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 34DC46B00F3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:59:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B60B7C05B1
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:59:08 +0000 (UTC)
X-FDA: 84933862776.01.0E600F8
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id E8D5AC0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:59:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YYmA7ZkJ;
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782759546;
	b=EzmTeem9kjBhC1nIPioluCxZvk2P3BL8s9HDm/LYBUSOLMAz6+lQFX8uVaWOFQw2BOpZ3X
	DnjY/bNoAzJeTjYOAgzLnGnKSUuVX4hN3QyRHbEntYrDOWbiWznpbPQ9VCED/TTsNm/yNL
	JKRmSZ0f6yPeAfTldJX/U4cnPKiMIhM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782759546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ipb9zy/CMdSBlv5dLzabanXHjYoiCYD2Nb/oCjfyVU=;
	b=zCmBbRnlUws56OZZ39NWQ5HVxDFyjBvVhVHhJCEGGQmy1G9PvntPQRJrOBSE4XJ1KUIvNH
	Tli2ar4x1Tmaw8m0ksL6sL91+HJB7RRWVEMUkET9RCUPPMPikvVpo96W0FJ4XyNOcickN4
	4CfHIuHeCayEkAkOqznEG2OLfCsKH1U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YYmA7ZkJ;
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c86214eead7so1192140a12.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782759546; x=1783364346; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ipb9zy/CMdSBlv5dLzabanXHjYoiCYD2Nb/oCjfyVU=;
        b=YYmA7ZkJZ+Czl93ahUnOCY+uRulAucuzqgn1od8+Jz7dj4zzg/f4iV1sbmwogCem10
         pokN/l19gn7wWkhgx7KQ9YB22YgUEMKlx1qzaAJob3+Y82Sb3TvXZMjP8glMmRO6Ldf/
         uV/NPYAXovowsEZ0WesiCMt5Z10w0OH3Tg0CoI+9U8B/XBTu7CVdvAzoc8YOcEaxiiYl
         Dr5Nfh2i70g1NngrRtXEo9BBL+/B7DzKp3t2ML/CTI4ZvSeTIg+zWjGqG1zw60qc6ysV
         MQ7JcpljwsH2cnWUZJTnqdsWy2ELUyVo78ITnMrLoY6EvmIDnygRqIF1oeuADZt3jTPi
         kmGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782759546; x=1783364346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7ipb9zy/CMdSBlv5dLzabanXHjYoiCYD2Nb/oCjfyVU=;
        b=mgPliHJn7UxmkJGdCb2GZcR9VF9dcTU+xu7UnFMb+lSp7A1IlwsPsK9amgaVIBQl2R
         d5UquHqHkYGuS3w6u3WIvI2Dz4mhrL/YlKEi7mcRe69R9fkqorXKf4Sg8YDlcvP+aAz0
         V/3IXLzekWu0SJ9zttEkeKCVjt48W+Smw8K3kGNLDHgWJ+UrgpJ1lZSoRfPf7pQ5KmnM
         wlPCASxsmiRB1JveJxwXjuTWosLrfD6PbyooUwr0NH8A4RnXOjlBT2Qt0FuxbXVrbgBV
         wV2TAACjcGdUp/skKDylRooJqo/R2PYYCkRy6MGaEOePEBEynlkTfh+gaBQxYdyW4tWS
         F5nQ==
X-Forwarded-Encrypted: i=1; AHgh+RoYJcGj9RjjSS1P6YobvYVjdMrcUp2lMpxYLOlqE8rEWOkSt6kRnSAMn5wntbuBTmsXhKUPMHbcfg==@kvack.org
X-Gm-Message-State: AOJu0YwhK3LCnXLOc+pOxmBltEj0T3MKGWk7xORlLq6nrfUtyKmhREnm
	kRiDijd1KVxgWkCX33zO91MWjkDfQQH7P9uXSIPd9mvpTaISiCOpkoCe
X-Gm-Gg: AfdE7clIE5Ap/tuc4lCuXhFlED03qb2OhF6+ZBzb0MxtnbdNtCfU9ewt43rwRUxS2Mq
	HwkCpkJMXNNwLxERr93DsVQJByR2kVeFxL4t1j/BHlYq3czlqXLUi0l0X0OxGZLXcbytVo/a8O5
	H6BQgt3001TNbbOBjTp8yEkt7OS53DxJMiCKhqOh4rcrCHFMXHXt0RSxISHqcciWvoHvk4pcO0K
	Ok7aaf3N6d9Epmt4jC0GqZCiecyL9+x8CfeP4ub2FkY7sNoIj+SdS/KiwYUY91C1j04VMYvml0H
	0BAYtBwmjnlkEmR3/m/6Bd5kuRY8hc/k0SSLko8ZK2ouQXHheID04neMQ6IWEFFGkjxgfZ/aTtk
	wHrrHZY3wHpXpZQr/8IfRYdFye+kJ0y/E9XsK7TrfPw+wNL4rcEpihZAp7FtmK8hKT9LVArBbN3
	TYGSk0YBdR7C1XgB5tYKtJJMj7N6UY5q03to5KCaIg7U8T6QdA2ED9HpF27kfFKBgbpgpF+Qo=
X-Received: by 2002:a05:6a00:9081:b0:847:9223:9726 with SMTP id d2e1a72fcca58-8479fe56b4emr318904b3a.18.1782759545854;
        Mon, 29 Jun 2026 11:59:05 -0700 (PDT)
Received: from fedora.hsd1.ca.comcast.net ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-8479ff8f959sm223955b3a.3.2026.06.29.11.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 11:59:05 -0700 (PDT)
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
	Vishal Moola <vishal.moola@gmail.com>,
	William Kucharski <william.kucharski@linux.dev>
Subject: [PATCH v2 7/9] x86/mm: Convert pgd_page_get_mm() to ptdescs
Date: Mon, 29 Jun 2026 11:57:40 -0700
Message-ID: <20260629185742.126987-8-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629185742.126987-1-vishal.moola@gmail.com>
References: <20260629185742.126987-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: cp3hmz6yqemaro41ezyhe8zihknr9wdd
X-Rspamd-Queue-Id: E8D5AC0005
X-Rspamd-Server: rspam06
X-HE-Tag: 1782759546-853510
X-HE-Meta: U2FsdGVkX1+M60YBWY8uxiTvFHpOYo1OyApEBoQg/sZkSW54X2fhUGatXkLpx2zn075UYG5f/4ERGoxNjcWIhF9GVx7nurEETecuNvWt2zH6fXKO5L70bsBa9l639aWJOytj6RGz/Ap1dKj55a209+RtQYr082REABprFhnTRBHpACqJ5TaXdt74dsqAZjkWkvvHm3DJTHL0aWnE6zCIZawBBnIFpDNzdYWRE7P1sIppZcaHFEUIsyoN2xUbRJVRP3ItyIAErjg167VDnsA2fWadi6YnLpfolGBorxDDxl3ynH/9Atl9hW+1HomAXnIZSyYrLDYxalcMbcXVC+Auf2e5+zbkMsfCyKGDlk2pjfcHLGoTVpzWRSyM2mCAkdblY8zh0Xq1hQJzKBwleb3oHWD++sq4MY0PgTi9OQm7bctPWnulgU7NHd7Hd5Ly3dbG1xj9dKjgwtMH7JiMHOGn4orwJR/01lv+sd7Ni2fkB06wrtGmJF6ie9RmR9qIclF3kOiaSwAn9WJ6dQNsP2K5UKbc+KUzn7qmI9Tht3t0FOWq9rPxkSkuih67nrsQpaZ32HqTc3tkBuG+6sy4TI2XCFX3tWeOxCcv04vdMUE69yzpIZlzMxhFQ1HPXxDztc9KA6BcR71WJPNDMpQCY7nGdwS+auWF5vUMLNx5mgJ7IVXtnfjFvs9hVTwri8WiWVD4IJcKWt03w6mP7wZzDM4RGTsU5C/L2fxuATn86kRAWSIsjt7o5z2xbXkZCilbVO+wXU96tMDI+2rOdoVjDhtY8RcBFpQiu1BrJB7N0XnJL1YQoFf3fjNlSe6mSkHakaxcA4GloU4BPXkVrw9SS7Znod3rHd8eBJDp3lx6QGzJhEX7HgFTL/SqLRGq337to75QVXDAJByU+pYn+FKUqBxgZQO0IkhnbjGpdEF1gRoO/KufSDQFy86OU6Y0obbiojrMRAvto4BgzBIulDQOZyb
 SUdcEnOr
 +ba3Y+LI6N+IA+oNtsekGofECc/upUVeHpPnjoHcvmBASIblcr9aSoWed0o2rxS5sl8F0PMIl0EehQiPW/YUs0pdBQ2+GtCZbj5gheQhFwIu3xhM+UiNboDdb6zGO+U13HvVZYL0/0UZrsFsyr1zX1HmzR3QOEhTpCWrzQrh0jeU6szNcwsOjw5t5+zwOfW7IF04YzP3cyZFMYwncU2cVN076glmFL4txG27lxlHPkaywrjgntp9fwFu99BT/dVM8/bHAy5c4Qo/LefTbYeSk/r0MOG1vtJw7JWWAIz6sGRYVvfM08uirDaTrjX6pz0C9XdtCxW6hiJvvccBJUTMEz//yBLwahvyyNaeBDYabvZ8eQFwNGLzFsNuXaXdanXezq1pLXHrnpKofWzkiSxyStbx1hXBO0CocGDcd2aTtnJPqvVbpj3ZGrdRCjrZPAiH8M+B9Rrryyv3ojzfgxaUuJb9hgS98J207VaPEF0lYeOLg3zw0XOgYol91EFYFwyqrezmJWWmmPHp2Wh8p6K43ksI8K4sUTIDbPzV7
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

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: William Kucharski <william.kucharski@linux.dev>
Signed-off-by: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/include/asm/pgtable.h       | 2 +-
 arch/x86/include/asm/pgtable_types.h | 2 +-
 arch/x86/mm/fault.c                  | 2 +-
 arch/x86/mm/init_64.c                | 4 ++--
 arch/x86/mm/pgtable.c                | 4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index ac295ca6c92f..dd046f29ec31 100644
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
index c31ffeac0714..aa88370ce739 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -282,7 +282,7 @@ void arch_sync_kernel_mappings(unsigned long start, unsigned long end)
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
index f32facdb3035..cb03f5a2b243 100644
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


