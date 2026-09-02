Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF0C8C624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:51:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4076C6B0099; Wed,  2 Sep 2026 06:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36BFF6B009B; Wed,  2 Sep 2026 06:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 198196B009F; Wed,  2 Sep 2026 06:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E628F6B0099
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:51:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D3BB80160
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:17 +0000 (UTC)
X-FDA: 85168505394.19.64DE0A5
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf02.hostedemail.com (Postfix) with ESMTP id C51C280008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YP4X6+jI;
	spf=pass (imf02.hostedemail.com: domain of 3ov-XagoKCF0Q8JII9AJMOBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--vdonnefort.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3ov-XagoKCF0Q8JII9AJMOBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788346275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gODwxuTtOVKQ6CMnGDMT0l3+wYWk2p1Ok9ZsUXJwJCE=;
	b=ajMRVQRBuOlzqDqGEpI3Ij4pcQmQB40SZEJJlErFCNmTRxGm7yh7DCuLkDJszlo157JPOo
	CNv4LW+K6JkRFcF97S7XEg74D4x6AtCc0WYJXANU14bVj6ai4WACm5qT41i8cstciUpnO5
	wqDaoen+OMYXQCX3L+czNsRMdmAokhE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788346275;
	b=hwcbr+vSU5irucsccPn9ruzyjQJsPsljPEYKC0sqLHvmFFd9RFxVZle3vTRHPRATY1h2/V
	Bw8yBTGYe1mw4u9jPnszuoKqj7FP7jtGXagw9HVd8vvJ7fjwfAu0AFVih4V3lY3NfZQaEy
	o5ekZkZGoWwkewksZEDfFiMUsOdueGU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YP4X6+jI;
	spf=pass (imf02.hostedemail.com: domain of 3ov-XagoKCF0Q8JII9AJMOBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--vdonnefort.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3ov-XagoKCF0Q8JII9AJMOBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6a68b66b4c0so395399a12.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 03:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788346274; x=1788951074; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gODwxuTtOVKQ6CMnGDMT0l3+wYWk2p1Ok9ZsUXJwJCE=;
        b=YP4X6+jI5GYbmLHJWrxW7aRwPFjmuXqNxaOPgg8uq/0IFcAv8GE9NQre+KhiE/Wbz2
         mikGWA70qNxefd9HlIe6nsMgagn8dd52e7hQU1eMie+S+LyPEQFww6htePKjoWtyX/lm
         Nkzd4nelwphRrGHi3aNAHP+YhGGwLbwjR9+pwYMHKfMuqIPryZq0dfvceP+KbHr3FlBh
         nQkvZ+eUYNbwLcEwl5TJqrdbfv7geDyRxIexJV6+AzhNKWDRYjkAXd/5g1y+ofuyK9ZU
         f5cTUjo3enJTF8j1PXKi09lSPqC67aCToh7CoME81nFJdfzKriI5NnVhp07Z6jFpYGRu
         N1tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788346274; x=1788951074;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gODwxuTtOVKQ6CMnGDMT0l3+wYWk2p1Ok9ZsUXJwJCE=;
        b=X3Ni6Hz9XbXW+5W8fuDorNKgT+6CoG1QtK+o0CcpCw2G1PVWzZP/gMdQc5zITmXpn0
         qIPLm2o0F4ZWYuhAQidtdBvLDK0/vkkvpiln22Z8aUF1jtUelT0kXRJPK+d5xPK+a+lM
         vGWLcexVYodDpl9W+oHCyNdFhi1MUbxlFG/nb7WSEFJ+qrGCgDaj8/qhBt2KMzGlH5ln
         EAd9+QZMPAj3RetMTYhwfsnXRm+vwBsvN39Ch1Hnwagb2VeMH39OSZ6/TgbcnzgM573V
         FV6XgsY4wWU1MM/e4Zc4MKM7bSyvHOfLivL8hgoKsS7qXCoCQ+Ca82u8Pkw/ra0QifDO
         CrxQ==
X-Forwarded-Encrypted: i=1; AKwUvBx+VP31s3ckFgEvt6cML4s/9UlSnaRhLhmwyvEaB4CbVBMQ9f3mWj52mLiAKtwa01ONiRm5TLF5mw==@kvack.org
X-Gm-Message-State: AFuF++kQ3S5tbp0azNVFevWfoAgq2Mnnt6JZ7ggBFY2rP8iPT/XeWJNb
	/J5ZgrDmuEFHlAenPTrs2+gEl3MCWTa3CU4Q7FGFBmm+Gc5hd+1Mq+4cs5QK+fvRvDGES1mCjWB
	zgC76sAuF/M1xpSEaurtAVA==
X-Received: from edy6-n2.prod.google.com ([2002:a05:6402:5346:20b0:6a6:8ab2:8708])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:4284:b0:6a6:32f5:ff40 with SMTP id 4fb4d7f45d1cf-6a682af8134mr2906512a12.20.1788346274084;
 Wed, 02 Sep 2026 03:51:14 -0700 (PDT)
Date: Wed,  2 Sep 2026 11:47:08 +0100
In-Reply-To: <20260902104712.2399797-1-vdonnefort@google.com>
Mime-Version: 1.0
References: <20260902104712.2399797-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260902104712.2399797-7-vdonnefort@google.com>
Subject: [PATCH v9 06/10] arm64: Implement can_set_direct_map_range()
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C51C280008
X-Stat-Signature: yx8frkrpe4btbsrrnbhy1n9ny6wc6odd
X-HE-Tag: 1788346275-473854
X-HE-Meta: U2FsdGVkX18ZMTobo8gwA2zxOXmJs0ziYtao+pI7OLazBgPs4S1VnGR6egUJxLaQVZJt2JIa1h2NcOldwhEmTpPzN+LflDEX3zmzPlMmJv+DY/Db6nHm8bk1r/NiFv9gM5lW2uNlTUonbXQuK8V6ktZemUCyHmJqQumWZr+oOdRv+H9NXIwjvK83aNTV0Ll4xkgclTYKqoAfvIP58AgRQM4h6k/7vxYzzvGzE5o0mstWCAge9eQZtG7POWLjuaOQ0AMdZunemWq3hLh+XRld7whtVK0xRZJBADumVmJVjpwyEgAgZkh9ZU4TGl9eXQziyxQ36i6Iz6Kkw15JBZkLtinwNtgqpKAMkYoog6crXzVvVKYmSdxoQGEoa7emFnO3sgjQUJnRv48adPWJ9XCJTOhECjiYutsn38UZg+P6AsY5lSmfhRp3oxYDwCetBxw6XZWipDX3W6qJoKSRpHTuUg0Z/7jkJhlwTRNL6/7FW+TR3LzNWL8Ui2aYJpKkRsY7fGKXpjHlWRYocoGlP365uyXrPe+xZ5kHBz5RNnfHP+bbr/Of9pDstPSq/HMFNjLnYbUC25a87XyMh0AcVLvQFtZtCaxSaqZ3o21RIO8XDjYtNW1N81hWnw4KPwwsVjlueU2IoxUKqJ30odv+a3IGa0yBMeMvoEJc7cS61pjjYIWzJ49Vt2SOsUD9Lgr67XuZ4QDveUx5xXGxeDJwY3mnl1M4o6DDMxFt4Y46SMyDbgHYt0GNfsSwtVB3FTj2dUfnXobHgQFx3WTsSvPhrdER9qfXo/w8UYw6MhWOzp0sn5DTL7k2NzdRxvpWClL3fLlUwBOjx99ouJIEG+62izbW216ey1kT8D6sZb9aNsV0pFnrMMCDNNndC8wYwpp5ZJIIBMY5IQU+7MqKxcLXpKB8bbOwBVzxvSSVDasH8jUcxoZ1dMpFQGZg2roSZFD7JtCzVRUMcZlr2sF6+WLJLoQ
 PSGaGG17
 fHV2VUhwrHxd4jfZpAdXalNHfaetByZUVgQ33MsZvd1LPQxqxCZzMdgdQZhgM4sT5P515GSciXxDFxviKoCsAwkIZXVbKYFVLvCM/VEHLtgv6IsbjYRd4ElvXvsz66mczvTJCdnqJgZ1gtaG7kPcWEJeWD5vatJUWGOBHRTahlqW81QtPiQRnw6cdlXKmaMDMwqYI8tGN6ZtaoqEqu/TokpgjRgQnrYXl5eaFOq7rrtPGT6grhG+eoSY+7Fangai4T3ExHiL0gXT0Zua06JP3RKVXghiaqJi166tZIKjPA8Q0gSHbk5OuW2YjBcq0tz91T1td18/D7uZ6Z7Y6y0lq4P3e1ke7cvl1YXaNamF0+WYWkmKZXHk3TImYefTQghT9I2KrLk0pl39Fq3LL+k+zb4cmytICdyvpHnIiGPssv3IXBYxCuhXqc+5W9RcGBpOpiAgy+BwQeHkwo549SUOTg8W38uwKQlowb8zqEx64xMvTL7d8X5Z61wfQ3PFOauviuGW/ePMM1KEIBhla/v7tfkdcBXh4yM4b4CA8PKob/GxokldK4af+MLf1C/T1RqMNkaxkBtneCtcbEqnHQydSTwNg7DqU/d3LMFCXPOydi1SVrt4wVHUSyi0uEQnBRM50Jr0HI5dL8Sr/Zh7E7fIdjSN/1vVcUr1kYQpp
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

diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 90f61b17275e..1a37f4ef130b 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -9,6 +9,9 @@
 bool can_set_direct_map(void);
 #define can_set_direct_map can_set_direct_map
 
+bool can_set_direct_map_range(struct page *page, unsigned long nr_pages);
+#define can_set_direct_map_range can_set_direct_map_range
+
 int set_memory_valid(unsigned long addr, int numpages, int enable);
 
 int set_direct_map_invalid_noflush(struct page *page);
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 58898ae53f5d..c59ef17eb0d0 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -103,6 +103,48 @@ bool can_set_direct_map(void)
 		system_supports_bbml3();
 }
 
+bool can_set_direct_map_range(struct page *page, unsigned long nr_pages)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	unsigned long end = addr + nr_pages * PAGE_SIZE;
+
+	if (can_set_direct_map())
+		return true;
+
+	/*
+	 * If !can_set_direct_map() then no one can split blocks and it is safe
+	 * to walk the page-table lockless.
+	 */
+	while (addr < end) {
+		pud_t *pudp, pud;
+		pmd_t *pmdp, pmd;
+		pgd_t *pgdp;
+		p4d_t *p4dp;
+
+		pgdp = pgd_offset_k(addr);
+		if (pgd_none(READ_ONCE(*pgdp)))
+			return false;
+
+		p4dp = p4d_offset(pgdp, addr);
+		if (p4d_none(READ_ONCE(*p4dp)))
+			return false;
+
+		pudp = pud_offset(p4dp, addr);
+		pud = READ_ONCE(*pudp);
+		if (pud_none(pud) || pud_leaf(pud))
+			return false;
+
+		pmdp = pmd_offset(pudp, addr);
+		pmd = READ_ONCE(*pmdp);
+		if (pmd_none(pmd) || pmd_leaf(pmd))
+			return false;
+
+		addr = pmd_addr_end(addr, end);
+	}
+
+	return true;
+}
+
 static int update_range_prot(unsigned long start, unsigned long size,
 			     pgprot_t set_mask, pgprot_t clear_mask)
 {
-- 
2.55.0.970.g62bdec98f9-goog


