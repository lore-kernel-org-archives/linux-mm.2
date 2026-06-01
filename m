Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E253CD6E60
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9428C6B02DB; Mon,  1 Jun 2026 04:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919BD6B02DD; Mon,  1 Jun 2026 04:49:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F4C6B02DE; Mon,  1 Jun 2026 04:49:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71E996B02DB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:49:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 35375140621
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:49:24 +0000 (UTC)
X-FDA: 84830719848.18.7A33D43
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3648040004
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:49:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DjVOwFvY;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780303762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=myBbZVt9pZizoKTbw79TdKlIez+dzWm6VMZTcEDpjws=;
	b=OGl1t6Im8nljSC5JpuI2eptyMzGxg9tCR7YnSJP02WW3+itFvVwm6+bSk4REQVyikm82eb
	SrMtt0k/x7ReZi2DnnZTl6qKgN0r/wlaiu2f8BTop0H5SAvC12J2zqq3ycLo2xEu+elYo+
	+YU+wc2ML0tAYKvE1QM7teN2Ty+jtBk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DjVOwFvY;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780303762; a=rsa-sha256;
	cv=none;
	b=Gz4uYheKKuh7g9CPH3DlYqEXEJEN/uUVlCcuN5MVBCZpN8XZedX8xMTkikgHzcJKXoapAr
	JCQhNrpoD5FFpGrXm6775gsIK1/RSCGpIMhBWELa3uPHo6oxpP/71+cdW38Gx7rdQ3fkm2
	ZLER6JfLRQufOhz6DAjUr+u5YqrgSj4=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8423f236418so351160b3a.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 01:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780303761; x=1780908561; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=myBbZVt9pZizoKTbw79TdKlIez+dzWm6VMZTcEDpjws=;
        b=DjVOwFvYVVN+XGGmFJMBQFgNZBZ0QbO6Yo5g2m/BZlVl0EoawKBiobD30nYwnPYyIX
         mle2GdVcxzgNG8r1SVVwDqy69JDPkM0KLuVeGxQhgvGlLFHG/m5p/HQ/oi9De+aAfnoJ
         FlUCq2whm7sFsz4GgZW6gWi+JSScgyMxopCTOJqIfFbhBgQiBAklV3qqJ+gaflnvv3wq
         gWlu1tBjsvHh5Qg3v+TAsyJx63x/UP6wKm1Gshkv5lf1WVzfgJWG5Ha8xgD8di9ZmUpI
         fSs4Abddrk5Jb/pjW0Fr2Q+Fbp6NtwglOXBdy1uTiDPGAP13kxM4q0CVCsLoZyPGd051
         tXpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780303761; x=1780908561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=myBbZVt9pZizoKTbw79TdKlIez+dzWm6VMZTcEDpjws=;
        b=BzFcbO6nsB8U/2xYkwpxD7quLFgmOvih/FcaLFEUjcHTu4VNWZXpZe7mP7wDPVCNLp
         SC+uwcNu3POESNjkP4qe58AxrhkA2CZKAmIAAZREBplZLn9RLUvO490KrPqlcqM1CttL
         piRe/YP3APCmPe97SiuvZZ4T9V7iaY2kc71YGt0S61RXOziBXQHCX+y4Zgi+uNBRWWak
         EL94qvksHc0wAue/3KLFQXGmr/MlLDIVnbifuAPOK5AMqYTOTxi6NQdGhlV2yGb9Hyba
         syrw2sdk0oDWSHWb0WxROw8WfKDqfK2NDNi/fPs79pCrN42C/rstLAYVOq1B3MwnumJx
         OKmg==
X-Forwarded-Encrypted: i=1; AFNElJ9dfwak7pHiZNOUouDygKObTodM/qasoEyw8NumvslkGXRafGi3j+/p+lcY35JEPt258vdOLp+g+w==@kvack.org
X-Gm-Message-State: AOJu0Yy/1oHbO9cVruja8NObLINWXlXwMMYSGjUA6BtlfTWN/t+XSsr7
	j0W7uiz+jYY0hcDM756WoRFBtSVQDGk2S71qRPhvKZ/B2utSNwRfxlclGVjh3XmIbSM=
X-Gm-Gg: Acq92OFdh3HyDQ36yL+KiGUML+Cq551KMK14hc8BUMEmV+Ky9g+9jHLfA185QMiAoPW
	S6GZyakD6Qap2vxmzp8qzZD5w4NWZoml1+VtCmMroK6z+qthx0rswxodCeINwNG7Bau+eNwKiaB
	wN8bls3wKxs3nFt1ir1/0FdJK+k6P28qLuAOPLakvdFw96PEGX4cD5Ss8LVT6iuQ6RqW2Fm/vgU
	EyjYAPS4Xa91wFB6C70v0I1azu4GunzDSK2bONoe6PLjuI37ieIL3fcIjQiKYNAiBfhdpDCRAJ8
	y4iqGeSud6My6tMjfvK7QaczTcjens0Yrs9qTexSvkA8ePhh4eeigtjgFdWOolOrccJEfWQlhWe
	6dj/eb2zFHxejw675WP7cdKYCrciRUeF13+s1sgg2+pth4pdLpZdAjDig1XlKBxYQ9R45xBijq5
	tbfHjB1sz3UD/pWdPt5ziUNlU60GYr8lr7NezllOrqikvMOOUGSHEIPQ==
X-Received: by 2002:a05:6a00:3a0e:b0:838:29b3:9ed1 with SMTP id d2e1a72fcca58-842255c8233mr8977076b3a.41.1780303760714;
        Mon, 01 Jun 2026 01:49:20 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84232ef8172sm6316230b3a.12.2026.06.01.01.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 01:49:20 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>
Cc: Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	WANG Xuerui <kernel@xen0n.name>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v3 4/5] loongarch/mm: drop vmemmap_check_pmd helper and use generic code
Date: Mon,  1 Jun 2026 16:48:43 +0800
Message-ID: <20260601084845.3792171-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601084845.3792171-1-songmuchun@bytedance.com>
References: <20260601084845.3792171-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3648040004
X-Stat-Signature: fj457exfugnia5kuui31x7rks3ezj5jo
X-Rspam-User: 
X-HE-Tag: 1780303761-485216
X-HE-Meta: U2FsdGVkX18CJ1Q72fIdM2MVMGpzuWkZNmalyxZj+cFMP3YHVmGA0wVEwt13jn8oRU6Obw5Va1t1Se4fgmsEQ2C47DUsjGZZ02x0dzOpaEZ6PMp9TIN408OscyJIjyUtUSNtKPDLIR8X++MX+/3oMl+CuVp6Bo1okBwl2nqmLnbSfxooDBRd4fnfXtwCz+OTICLHrv4MfdGEIuZOQtoqLBJZhJBOqHtkGfmOLgvg4apaDCYBvnMIgfh/OwiPqYQhg8P5HU4M8r6YNvQwy0peGGeYtUmjviXEXkIfmQL4zs6G+/I+aIW6ibyNUR0i6+lTdllEiM2Eegk0XHTAPCHESt1PIkf5WizMIqhnv8ow711NLKNfqY1J08MGrAQ3BbM/rUFhbO6W7f+m45clidib39AJ1FQ8PJNgHEwE/o4uqQjPk4Zd+LhCXNeUd7M5XoXLHMyVD2n3bvcfYFk850fdjLkKgc0VArFvxmn7faWrY/PYY3V70PH9NI2jkjGvXgV8t41QnI6qkQEBT0Om7XbSirvh+C5ke7vDiWuWRDD74QdUY3sVrJAcCq7uyeEGIuE1M1IzmcmxQToZ43rf1FL9YtBkwnF+029wa/y2RI5dZUUAAZC6ikZBORer9cPn/R/troh7uCR3SNAzdcrahnDtaPWQf97d60wGTI5MZigYPYAORP3NjYR0WJeT+K0v6lZF+f03SIHrFZEcpjBsETBzm7FDpUUAnOOMs1M9D250bR1ZsLqYJQNbUSP8+/j6I8zwVnWkPH7YKMNMhxM/qEcxP2EFEoThpEPdVSAE+2csErYkj0y3fHh+H5CRh2LufuJwojF4dAha5mbNc/x5tHMINk2K7gBeBeTvUYRuaK6YYh6xDKwhVaK42KhC+5zXqyQvBWmE1JzRtWf8CA4rRMR+GIqjQGw9O7ng0RV7NBuVJNlZLELV4T/z1Lt/XFi5tPQZUvIPwZ86YqaNSzlqs/W
 rw6x07hH
 xRiUvWtIga/ryauaw3qv6ZO52aCez0eHCbLSZKS/8NjXvH0Wyw/UrlmirEb+HsXSX29ik2IZfUEqddLVOulWY5O5eEnt7xyCjyeauqrW6VQOTTxHGiPtzt9w/5Rrsfj5FZdrdOjIpYZ3jmWiBDqH68rNBiNxoIQ8MXMLdGh5sPFto0f34otnb3tBll7z0aZiYTiapptpk9otFt9u+7W6J7f8z3mn2G3D6IWlZhmpsnLNh0wNCrIjdYu1qaIlFf3Vi2U3NVs9lkwiga8CKNZyJKB0rm/DlaCWgOfCIIaqOqNDACsRZORBEQw33oBkpg0sOfmk7U2zf0uwr5wViBd/5ZjG4yh8nVFPmJW1Yb34GtaA9Rk8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The generic implementations now suffice; remove the loongarch copies.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/loongarch/mm/init.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 687980b6e91f..3407030f3e7a 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -140,17 +140,6 @@ void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 	set_pmd_at(&init_mm, addr, pmd, entry);
 }
 
-int __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
-				unsigned long addr, unsigned long next)
-{
-	int huge = pmd_val(pmdp_get(pmd)) & _PAGE_HUGE;
-
-	if (huge)
-		vmemmap_verify((pte_t *)pmd, node, addr, next);
-
-	return huge;
-}
-
 int __meminit vmemmap_populate(unsigned long start, unsigned long end,
 			       int node, struct vmem_altmap *altmap)
 {
-- 
2.54.0


