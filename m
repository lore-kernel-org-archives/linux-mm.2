Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28444C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359F16B0106; Mon, 21 Sep 2026 07:01:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331546B0107; Mon, 21 Sep 2026 07:01:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1848E6B0108; Mon, 21 Sep 2026 07:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C597A6B0106
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:01:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 475D9C0137
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:01:02 +0000 (UTC)
X-FDA: 85237477164.18.25F7CCC
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf14.hostedemail.com (Postfix) with ESMTP id 79188100004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:01:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gdb8Nl0a;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3ag6xagoKCKccKVUULMVYaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--vdonnefort.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3ag6xagoKCKccKVUULMVYaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--vdonnefort.bounces.google.com
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gdb8Nl0a;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3ag6xagoKCKccKVUULMVYaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--vdonnefort.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3ag6xagoKCKccKVUULMVYaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--vdonnefort.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988460;
	b=CA9F62XGBQ03DGlXfIWNUDdupywSmYBtVowXF1Rhl8hiuImHSDiUeZTIxkO1kmiUO6Uyzp
	pAmtVuUMHMDUTOEYlQSyDxek8H639xpN3UqFPVFYur+7Fw6GsbRf94QLj7/2I63vTiDxE7
	Llj+yqIE1lWMPWvfGKQwPZVeK0bq3AU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U06rcgIn0LVt5Do84ZIYuayP7YCGGpRPbIbmdcyZosY=;
	b=5yTyt8n45H+njQQR5S/cVI2mktp0WUdvyMU/9ey4ZdOa/e09IGrwbDbmuYla1drGx9iC6C
	a9VuNc6B+HO1FzEPd4pWN/x3Spsw22mKAelMOv7Ow+wAX16ZmwuLGX01O5d/SITlcV/oHb
	P5FeLTbQKhuoWrc4dmVMmdYkfpS9QzU=
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6aa82371cb7so1189336a12.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789988459; x=1790593259; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U06rcgIn0LVt5Do84ZIYuayP7YCGGpRPbIbmdcyZosY=;
        b=gdb8Nl0aAqELmp0v894CNitkQpE5IYhiTo2WSxJaavalwsZpCznu69kidOhziH4vPm
         tjQCIjROjmAC8PTHG0e4BPYFOOWJDaF6hOvE9e5qZupwe6lbvCmSW9SeVuAdHu1zulzt
         IOf8sgikpXT7J3Z1FOnvh2R+zI76u6/IumLdiUYBeVI23DMU9XZWG2keFIaaROgjZHxG
         GwrmB8PT7AKFIfQhh2gV6KwHQdfhWu9AOscggSekBuL7AeeMcA/ssLvu0uHv7agq0KCI
         /Hleizm1lwybHvRJC4iP4k5PR6a6g4T+KhlPaw0YutVoLrqpWPgIM7zL/sXE/buwDgCL
         6j+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789988459; x=1790593259;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U06rcgIn0LVt5Do84ZIYuayP7YCGGpRPbIbmdcyZosY=;
        b=azLvYc/SJ0JatlgjqubXEH5gtudgWYWr7Ui4NndfZYZWTJsMTZ2UABRilms3C1aFMg
         Yzcn6nXNu9yd3ELbJ1r1PTujO87coRh6N2J8V0NujvE4FkxTZZZVvI/HmDq25szw6IfO
         /TD2wTjx8aHM/UH2AU/boTxQULQNJ5EoQpDU1rBN3ui60wTHcgPDqSDfgv6NWLLiH2OP
         32my97/3AukAgbNRmPqoh2b5NwYEerTYZCv4HPAh7TZ7Rc9IeOLlQQNHnGPsw/G7bXxT
         Bn0tithgw674yMAeH8NPYS4mappNBajb2hpZqw4d93xzXCfnojNxb4tKSnNygJ4lPYG3
         xXGQ==
X-Forwarded-Encrypted: i=1; AKwUvBzU/aDmjWBTxWrZ5L+F9/A8GNFdIkfwNoBPAfr1qdGWrR9SDsodJ55Bq372cQQOb6eRoFsd08LOqg==@kvack.org
X-Gm-Message-State: AFuF++l6SxWaJFMcznFg+TlYUBpT2FjO75lojQiIDpq7UG4TC6qooJWr
	HbUcoN+uJBIRSmuezLxIcFJEgnB7Z6jGyVH1Yk+W4FUSSs5FSruXmnIguvm6FZhQQTYj4Y0a8Gn
	ToLcUcZdN0/wDtLdtEv/aLA==
X-Received: from edea12.prod.google.com ([2002:a05:6402:a18c:b0:6a6:1a9:f70f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:23d5:b0:6a5:f814:2278 with SMTP id 4fb4d7f45d1cf-6aa577f5a1dmr7324139a12.2.1789988458556;
 Mon, 21 Sep 2026 04:00:58 -0700 (PDT)
Date: Mon, 21 Sep 2026 12:00:44 +0100
In-Reply-To: <20260921110050.3977591-1-vdonnefort@google.com>
Mime-Version: 1.0
References: <20260921110050.3977591-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260921110050.3977591-3-vdonnefort@google.com>
Subject: [PATCH v2 2/8] arm64: Introduce can_set_direct_map_range()
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, sudeep.holla@kernel.org, jenswi@kernel.org, 
	robh@kernel.org
Cc: mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org, 
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 79188100004
X-Stat-Signature: 8ydcwdpwidn3c5przo4g3azbb1yacpr9
X-Rspamd-Server: rspam01
X-HE-Tag: 1789988460-572365
X-HE-Meta: U2FsdGVkX18659cwQyGOWxz1AIKuFqDBodSTWx91MRmoU3wCC83pQ6PxRpE72LPVO+XTm9hwsgrmot5k1a7JcWpu9zjEjbpFlSujTF6KeYY/T2PmVKdJ22DeIJYcjn3TzVv1+Kxtfd2gIaYufrTTeuKMnxrMn4KxLLGI7bJBglXnyk7OVNEmStHKdJi0N/rIxSE1F/0laA6jN3KpBWoDl2yzNd3iX6lCVbwCq4R2zeCXHKsJAHLROLO0vNwdmD3PirOkh9d2lxZ0ORLTfWX1cHozbv7uRB2//zA7Mm9xhdfa586xfBIEk4a2oLQZLINestaSmUS5eafLKP0cc2p/xWTC2nn1kJ8TX3RXIXDofVjouRH3lcDMG95e7e1NUjK9ws4s5/yJxTsEEBqRCZcjQ34rZxY2fWpAuulvP1miXaonDk1UK1K/WJeQB9VhTcKwRnFusDwEV5fq53exR1MNXEctqBF4X4STYHmIdYesR0YRkXXtATglAs1+SaaWooE+msvqHERAvEW3sxqm/WPRJiIPVByyu6+5y1GI4qPcQS250qlfU1SQ4Z3sMbgNRkQpnP1c0BFkijXI/LO09hADBg7gSmmC1snAHYk9A3mrjSSaoS3aYvUvtGfuK2IdADuqA7EW3pvNGSJWNQUb2nUp1VIWCtYetpwys/QlYuEi2lTOLhUmzQQQUQkcL+09o8yqE9ID/EJp+5AUDiMJ6rO7K45y6tLObEPPwofLwAa9nIrTcgntU3Eqs6OXL61qe+AM5Fb3R0WsnKeJJ3kcAcTbUiKfHDZgsy7Yw0Gxm1fZL8XJ1qN+Oc/j8UQ07dR/CWtPUhysoGMSKf0yNIV1LEGcCo22NVUXoIKZPR0yYxBbWRebzIFPZGr/fjFQIcWGvtJbEHA7CVlbBHc7+f0mtKEaZZIJFuNiPA4qtWs9M5YsqPXARSjf8tQRPM8Qc09Aff4jvIcPe5X6vXPa1NF49Fs
 Z8e+e/gG
 8VaOTN3jD7StfI9lmYb2cG1qHe/1pVSzQ7YFWConY7GIgaR3Oqk4FC8bCGIcfNdKS+A9yhZ8ikX7wv8e9M9TFlhh1DhN2DLZoaICihgEbJkP0MeF2ljfVXDeRIisNWrC8pl+PVzsumSs/9gMEHyxzUW/R0F7S3EMXPvmCnlO4pXAEb4Zt5xEEgnF3XO1C8ep1U27ymNdOL7NmoUaE+ecZt+ea9Mr98HtBnanatQB7dYOaark2GQLOvU5syzFxoo50UBk2ojDC8JeROQo8KoD4KxzftgjsdDnHsthCW02mfonNqdC93VqCMfCo0bIvOwiCIGHVbZ1/zeqBng62kbymZ5d+qsxoeAbEdiS259dfTewMOMWL62TH45JhpdCBkFU0A+nwY5+A5OpKgIbQl0EOlAL7EogF9HZNPzG7UsR7sjr/aVkXFObmS9r0n0RyvhEOsEEAl5Po6ZgyQEqAYs0XMz1w6A35YjwJfgAd3XCuE+gCw+j0vCN/tPtirbF9Lqnhmipkr65o+MTcw1Snnf59sH9WxM4jrcmmpeC9C8ifMOCvExirm7CPXs9UWzerG0qEBt3S9+yfr+oq6kPPYY9aRrQPs4je/ld4Uy8noMVJmJOji12VTS5ioQU7kg0BpAgd8SQnCzHh+OVJUs9ZXfuD6V14gEC9HEIWQQ6D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For systems where can_set_direct_map() is false, it is still possible
that a subregion of the direct map can be modified if it is mapped at
the last-level. Add an implementation for can_set_direct_map_range(). It
falls back to a page table walk to verify the mapping level if
can_set_direct_map() is false.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/set_memory.h |  3 ++
 arch/arm64/mm/pageattr.c            | 50 +++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 0091ba12200e..80bb94a340fd 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -9,6 +9,9 @@
 bool can_set_direct_map(void);
 #define can_set_direct_map can_set_direct_map
 
+bool can_set_direct_map_range(struct page *page, unsigned long numpages);
+#define can_set_direct_map_range can_set_direct_map_range
+
 int set_memory_valid(unsigned long addr, int numpages, int enable);
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages);
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 132938b32eb1..5fcdb292905f 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -102,6 +102,56 @@ bool can_set_direct_map(void)
 		arm64_kfence_can_set_direct_map() || is_realm_world();
 }
 
+static int can_set_direct_map_pud_entry(pud_t *pud, unsigned long addr,
+					unsigned long next, struct mm_walk *walk)
+{
+	if (pud_leaf(pudp_get(pud)))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int can_set_direct_map_pmd_entry(pmd_t *pmd, unsigned long addr,
+					unsigned long next, struct mm_walk *walk)
+{
+	if (pmd_leaf(pmdp_get(pmd)))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int can_set_direct_map_pte_hole(unsigned long addr, unsigned long next,
+				       int depth, struct mm_walk *walk)
+{
+	return -EINVAL;
+}
+
+static const struct mm_walk_ops can_set_direct_map_ops = {
+	.pud_entry	= can_set_direct_map_pud_entry,
+	.pmd_entry	= can_set_direct_map_pmd_entry,
+	.pte_hole	= can_set_direct_map_pte_hole,
+};
+
+bool can_set_direct_map_range(struct page *page, unsigned long numpages)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	unsigned long end = addr + numpages * PAGE_SIZE;
+
+	if (can_set_direct_map())
+		return true;
+
+	if (!numpages)
+		return false;
+
+	/*
+	 * If !can_set_direct_map() then no one can split blocks and it is safe
+	 * to walk the page-table lockless.
+	 */
+	return !walk_kernel_page_table_range_lockless(addr, end,
+						      &can_set_direct_map_ops,
+						      NULL, NULL);
+}
+
 static int update_range_prot(unsigned long start, unsigned long size,
 			     pgprot_t set_mask, pgprot_t clear_mask)
 {
-- 
2.55.0.1082.g2b9226bbc0-goog


