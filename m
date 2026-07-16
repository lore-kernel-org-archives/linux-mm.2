Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ADF2C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A6E36B0156; Thu, 16 Jul 2026 11:14:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87E4E6B0157; Thu, 16 Jul 2026 11:14:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76DA06B0158; Thu, 16 Jul 2026 11:14:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4479E6B0156
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:14:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9865E14013F
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:44:43 +0000 (UTC)
X-FDA: 84994608846.15.803450B
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id D1C682000A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:44:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=B8xEfXgC;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf31.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205881;
	b=qrmsFHvqszN8xby/lPDU7iB5fNpHYPvVeUzx66zAW9JVYtarZyt50FDnW75Ol8CGwgkaEA
	G0LBs5TD63uxJZxCXQgYZeDMfR0Or+3eYOFyBM2T8MRYYqyE87GZXMSpreX44QcWMs7HXE
	LwtvwCqyP74ntGY1RtwwaKyCucEHoXU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=B8xEfXgC;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf31.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xl9SXJgNY1wsw8DmDdohBTpB25DAPwcBNYqh5j7w6mI=;
	b=H8Ovt6UebNlT42W4vC4ij9UOlAo2hjS5cKWLAPMN2Cqg/rKH7LNK1VC/R99QDmI4PnIez3
	hOuwwPa5lXj7lsubyV3DSgxon0otA8L4GQmE72g3Z7TauI4C0UZzLhp7XZCb0aMBCT4VJN
	2ZDOHUidPSVH8mYAf6qDE4+7p99eFio=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-ca7c1176317so4836197a12.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 05:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784205881; x=1784810681; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xl9SXJgNY1wsw8DmDdohBTpB25DAPwcBNYqh5j7w6mI=;
        b=B8xEfXgCLIcf0YwyZoh4/OkPmSH52h5bWwzi2DZQqj//RTwaivbhhTeZmE6ruva4WF
         8kZokSICXcUM1lcSE2wQdSrQTRC1M3z/vazIw0YjQGScZMlwWgAoP0j+2IZoU70JK70V
         zQt0Z/geHwl88sQ4mgSulMkuvmwot4inGF8zqDQTFrHcU+3fMaBPZsDvfL++7SSn1/au
         3GR5PU+3rJHJD5AoY0RZg+lD3qmn27pxDYgUFh6REmU9pM/dh0eH1SHyHJY8790/Xn0x
         /hsarbUPY1EXYP9/77xTfk9JCTgMow494TJPqK3o3H1nGO5WGkqNaEzP3RzLGHUzlRV1
         YYMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784205881; x=1784810681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xl9SXJgNY1wsw8DmDdohBTpB25DAPwcBNYqh5j7w6mI=;
        b=P6F6sTHNFMcyAYrkYjd7woSSeMK0pHCn2B5viyJGuuaIMmx1ihAyX0JWxTqQhwnZFw
         nWMT7tWdk6n7XpW1fkU9ELaNMSNrOqjhIiSYp17Wjj6ydTGDEWHxVy6abXMnTk5qpKM3
         VWMT26Bjen/UUJ6neHLA8SEgQPlkeuk11d/V34L6VJVIEGpQoO6Y2gT5etlsZu1gGCaC
         Bu1ldMsYa50aQGbTMS11E3Ii/NGgZkoCUHec8mVzzWrKBtYDC7kNUrywqv9lGMujZtrW
         YQNyeb/w5GLQ8CfZfRvw6I6FgEjEyEKIEyFMSJlOPU48U8F68JDYRaR/haW4T/ESpuvb
         AMMw==
X-Forwarded-Encrypted: i=1; AHgh+RrKTcXOJhG3jKHoiCtPab6DvuOo+XU6E/lv2155bmKZu5Q6M0ZalX6idSCBDBUygVhsbIAn2CxqKA==@kvack.org
X-Gm-Message-State: AOJu0YwpaoHhQnnD1xrpVDHWhqpFNcfQShJ3R1zBRxNkLas/odlGL8Jz
	jEWYYlt6wj+2q5BinlTjFCWjH+FnxOsXGpEibLKxlFpHRxUU3o2zCDyLmxgSjuNFriM=
X-Gm-Gg: AfdE7ck+8AELLYFLFoDaLqd1FAzK9sIVCNjvclKVeWVs5e2wjwJDt7np6pgDagRhocX
	BP8oDW8Sk8PDWD92snJTVlGm5ABTJg81KSihoOzTo9NH7UJ4DRJGCQID8AmkkPaTfbFc2Seg8WK
	ph7p0lEXWBlqUQxATpVfCb8dd1Vc27Sesf/1NWAMneShsUgMKzBiJ83G5Y/R9P0Tejh79HATKhQ
	cXZ/bVsSbz9BAh2xZ7SYpJqGCACa/+Qj7qr5CMSV8OftEa24dgy9zqRr8PYnRQ9GVr9OET/HWuW
	wIGL43gY1jsqTDJtxSmKagdV2IchKUagdA1I0c1wb5+uNY/P0W3GmE/oTRD1WpyeQj9SsFp5YSi
	Jj6zUDaaiOIUDnTqe0VpHQnTdYbNj9jVIQSl2XvD1RBb0BqtfAmSdPXsb6SfpcZOtuhz29bokq5
	veGGoibRaiFA2TTVT+pifei3U=
X-Received: by 2002:a05:6a21:114c:b0:3b4:b275:c5b1 with SMTP id adf61e73a8af0-3c36c1cf118mr8945730637.26.1784205880687;
        Thu, 16 Jul 2026 05:44:40 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([2408:8606:1800:501::2:f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258eeaba2sm1730793a12.12.2026.07.16.05.44.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jul 2026 05:44:39 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Yunhui Cui <cuiyunhui@bytedance.com>
Subject: [PATCH v2 13/15] riscv/mm: remove redundant TLB flush in napotpte_convert
Date: Thu, 16 Jul 2026 20:41:48 +0800
Message-Id: <e55fb906990083b05272648f5299514a68cf8456.1784201104.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <cover.1784201104.git.cuiyunhui@bytedance.com>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D1C682000A
X-Rspam-User: 
X-Stat-Signature: mib3ckrx86hp6u6whgroheq1kyk5q7dj
X-Rspamd-Server: rspam03
X-HE-Tag: 1784205881-131850
X-HE-Meta: U2FsdGVkX1/91yyCRSai32H2NIc7uFC+EL4dxBxO8f5yn0QBsTiiAMkLgZJscVrK2le9XkMEUhO776RIhU1FtWp13aa6LetFkp2+55tKCoHpLncGVxb3XjfNMvgaJBTlCZW8To5a0PQ1jxG5LeYFsx0xFFRDYcYsBlmsATY1Mp2GQkeB5Qoe85eEX6ENaCE3yvN5UmIxvzaTl9RGdvX5IQ3mVk8bhfXyAhGULZ/A6e3pb8mC38Fsq6717uVvPX/WfEVmoKJJcEW2u08MGXTnVmBWH9GsETZxmxRuPPx3zXewG9ZAyrbaFUq8m76GdQcN8K53SDRfNZ8xWR8O2aE0tdLWTeVOEnZkY2pdInkkRC5FKd/ExglfTFYCj+7Y+u1/Upvk2nZb1P6yoFcQ7HZGqpC25y3O5YBYObSo65nYM3xZa/ZXQrAdsTiy5eKBVu+lt56xipqZ+4ljYhTMSLXxl6P36NQKKRSMzQdrOisx9XLxQVwxaWX954F3oSJt/9BkJQf7iQ9mPszfOMQ0uP0mv6bBo8y40vv87HZDrRUFBg8+RA1RoD77WaS6g9FtxVhrUnmJE7zb9QWsMJFnrr4RV9C6ecc0O14WwAqigKdXq8amB+vYeBDpN6tNpXqZ/R3QSYAXWasqqnvhSWuyevOc2zSPdsoXYzuT3StK4HdrQSHNncUUHpAOEuPN7tQHnv3UZ37NKMscDffkmZ1Uqf0y4fHT9zLOrvpRuTnNv4YQJkmxydm7vsA+0UblUA/oXZNvg02Dh1jY9zvFvfBxnO/jSOhmucLhwerl6b8lQImj4vTblcI6i0RIhv0WMAcVvRy4OBPHyBXsZhMCGTSLLStAhwZZ+gs3QCimMnjJTiu1XlxMPaj74TObn8Tat63fOX2ZIpCovnMhcs5ngGfDMBq2UWRdoC6KgRTnvm5dbHWqrV1b5qUGtxIGKggaqIA08hYZn4J0b+Bmj22arx3f7By
 VudttJYD
 62iDNRa7k0d510dlc6/I8ZtD0EW6BPxW1w1/B0ucJdvvFpP/NN4WclD9wrbJs0Mae0BTBVc62usmrHvXsjKXsAqKCxl/jQ4XrW42Mve75/dbKU0JRVfkJ8js6r+Z+VqpHsMmAibG+q+oJ3VpmPM/F56zTdXUWJtlQ3KtIwvmJ7pa5DDnpoq6r/ZJcOvkrIr0PDYj7T875sfsN+xqhSGdDbDmXwGgPlavSPny9aPZxVDU/inLDXKLGp0K2f5MEqWfBJ/KO45RblL7fS0YHJDGz4f+rYrB3Zc1Vbf9x2tEJvxhMn/AsaP8weV/w1bnn5WxuyO3NEWenah6gqreBqNYD//gRggks/WCNLzGbDisM9REw35wd1TrktCXApJoCvO+RYcPPT50+sYFnjGvZFmY6aVzPuOCycndwBRwat5+S33M7AF0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

napotpte_convert() switches a NAPOT block between the Svnapot encoding
and the equivalent set of base PTEs. The conversion itself preserves the
effective translations: PFNs and permissions are kept the same while the
page-table representation changes.

Do not issue an SFENCE.VMA in the middle of this representation change.
For partial updates, such as unfolding a writable NAPOT block before
write-protecting one subrange, a flush at conversion time would not be the
operation that enforces the final permission downgrade. Writable base-PTE
translations could still be refilled after the conversion and before the
subrange is write-protected. The required TLB maintenance belongs to the
operation that actually changes the effective mapping.

The RISC-V privileged architecture discussion clarifies that Svnapot is
an encoding of a naturally aligned range. When napotpte_convert() only
switches between the NAPOT encoding and the corresponding set of base PTEs
for the same effective translations, the conversion itself does not
require an extra TLB invalidation beyond the usual page-table update
rules.

Link: https://lists.riscv.org/g/tech-privileged/message/2950
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/mm/contpte.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/mm/contpte.c b/arch/riscv/mm/contpte.c
index b0b8ff0aade3a..8289f39d6e188 100644
--- a/arch/riscv/mm/contpte.c
+++ b/arch/riscv/mm/contpte.c
@@ -129,7 +129,7 @@ static pte_t __get_and_clear_full_ptes(struct mm_struct *mm,
 static void napotpte_convert(struct mm_struct *mm, unsigned long addr,
 			     pte_t *ptep, pte_t target)
 {
-	unsigned long start_addr, end, ptent_addr;
+	unsigned long start_addr, ptent_addr;
 	pte_t *start_ptep;
 	pte_t ptent, pte;
 	unsigned int i, nr;
@@ -137,7 +137,6 @@ static void napotpte_convert(struct mm_struct *mm, unsigned long addr,
 	start_addr = napot_align_addr(addr);
 	start_ptep = napot_align_ptep(ptep);
 	nr = napotpte_pte_num();
-	end = start_addr + napotpte_size();
 
 	for (i = 0; i < nr; i++) {
 		ptent_addr = start_addr + i * PAGE_SIZE;
@@ -150,8 +149,15 @@ static void napotpte_convert(struct mm_struct *mm, unsigned long addr,
 			target = pte_mkyoung(target);
 	}
 
-	flush_tlb_mm_range(mm, start_addr, end, PAGE_SIZE);
-
+	/*
+	 * This conversion only changes the representation of the same
+	 * effective translations: NAPOT encoding <-> equivalent base PTEs.
+	 * A flush here would not replace the TLB maintenance required by a
+	 * later permission downgrade, because writable base-PTE translations
+	 * could be refilled after this conversion and before that downgrade.
+	 * Leave TLB invalidation to the operation that changes the effective
+	 * mapping.
+	 */
 	page_table_check_ptes_set(mm, start_addr, start_ptep, target, nr);
 	if (pte_napot(target)) {
 		for (i = 0; i < nr; i++)
-- 
2.39.5


