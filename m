Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7C1AC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47C326B009B; Wed,  2 Sep 2026 06:51:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4060B6B00A0; Wed,  2 Sep 2026 06:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 319566B009B; Wed,  2 Sep 2026 06:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED9756B009B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:51:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BDCC14016A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:18 +0000 (UTC)
X-FDA: 85168505436.23.4832D18
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf03.hostedemail.com (Postfix) with ESMTP id A536B2000B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=O+KpoB1e;
	spf=pass (imf03.hostedemail.com: domain of 3o_-XagoKCF4R9KJJABKNPCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--vdonnefort.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3o_-XagoKCF4R9KJJABKNPCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788346276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TNWZLpQFf8So7isbdfRHNiNRkktdYQTRcSFjKmsQSY0=;
	b=Zmlx9ltQV4gysnlr+tuTTe1iAT64l4+CcDPCKGBYQbivix2x8Ty0q8FWk7RxriYZrjjR/b
	2aI95XuRzWpe5Po9aW+C75ymQXTI6uUz7mQ+4Qzed18Gm3NK01CVtrLD0PMP5E/zzfDoR6
	3wMk7dMsnUFeYYJSXulvfEr6HNi100o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=O+KpoB1e;
	spf=pass (imf03.hostedemail.com: domain of 3o_-XagoKCF4R9KJJABKNPCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--vdonnefort.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3o_-XagoKCF4R9KJJABKNPCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788346276;
	b=snaI1OWlCRAxISmvBH32LAXpXaIQF+A7FvHrHAy3N8122I575/mPLRQ9Ksd2clk4me7PiB
	0xfw/E5GJV1iaySiWZ4QR9Iyy3p8PoYiiQhLoRaDbpb5gf6NJKlAup79fDQctQr/uanw0X
	Jsudd7WmMjI38RvzRSzZ/yHIetcjHjs=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49cced8309bso7614255e9.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 03:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788346275; x=1788951075; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TNWZLpQFf8So7isbdfRHNiNRkktdYQTRcSFjKmsQSY0=;
        b=O+KpoB1eXYMKq1S8cblodnNNziT88Il1bChfFXKcJMcuecYclF0SaNnQIkv92rnYF2
         gYrrjpKLtTU0862gVN3lpKgOi+/KGWZDAGj5cCnZA7PERfQp8vD9wmctBVTFiJ0XmG6K
         HAx4pVot5DmimLA+9lsGEG/bs7ViCHPbQKlI7/GxWCOPJ92FHy+lqzvww6TEQsM/ODWK
         dlWUKwzlDG3j65lP67ZZx4hu431fEddryPzaC5aB66KnhIs9yrhBK3OieseLVb943Kfm
         yiiGCRDDZxXVPiQvKfmTTBbD62z0VsoRoBzxiRpH6O1JyZ7hLvaY0R2RIX7SyA0qNJjt
         EH9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788346275; x=1788951075;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TNWZLpQFf8So7isbdfRHNiNRkktdYQTRcSFjKmsQSY0=;
        b=Cwj/hTiBphZGq515DmKIUroifJhZEweED4gVjLS7szR7aNEyYAwr3QYBssiKR+CheL
         0WfRKeN3WpN8Lfe9MvrytFYOoyY0vTfSf52yGYdXJIGqFUQd1Dj5TTrWA4cTCWSZ1KMA
         c0bwJt5JmDhJy7fv9vzWFhjDpZUiQ0kT+NZ39VaBvJP43twD7vkLzbGoSmkBmseIATHw
         qHDZ15H5Db2DhhmCIXOuJkg382h+8vaBnMGJe5leI5iCft+yXRTS1vGVbOf9lAK1HqhD
         qrW1plwKJ9N1Byp8AfAp/loZ3rz28vLakbd5zx4NneLb0Z4h7Pz1N2q6FBEPdqBJdECC
         2DXw==
X-Forwarded-Encrypted: i=1; AHgh+RqhN76kJBWOpTU5Vfz7oKF3xJCDwarUOvan2NTUdJI5O0Tag+TXUEmfaPFGYviuAGfINpC+EzszVQ==@kvack.org
X-Gm-Message-State: AFuF++mLmztYgeXGV739+paUhQ3MSg+H735MTS/085jDzU5Rs1SJMiq+
	euNAGXoasF7jHT1HjwvFDmc3VzouZePiE0ROsNQBmSxnB4w/pSzaukPMp5CkJy7D1tSyOZIOS8f
	3LgPPtICIyGqEV2EU4DOmNQ==
X-Received: from wrpe17.prod.google.com ([2002:adf:f351:0:b0:484:3204:23be])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e93:b0:499:cd34:100d with SMTP id 5b1f17b1804b1-49ce57f5235mr66954815e9.7.1788346275192;
 Wed, 02 Sep 2026 03:51:15 -0700 (PDT)
Date: Wed,  2 Sep 2026 11:47:09 +0100
In-Reply-To: <20260902104712.2399797-1-vdonnefort@google.com>
Mime-Version: 1.0
References: <20260902104712.2399797-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260902104712.2399797-8-vdonnefort@google.com>
Subject: [PATCH v9 07/10] arm64: Implement __set_direct_map*()
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
X-Stat-Signature: d91kkf41fuowj919pumeu8bodojqxk3j
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A536B2000B
X-Rspam-User: 
X-HE-Tag: 1788346276-537968
X-HE-Meta: U2FsdGVkX1+dv5tkLo1RTNtrAVsNP+mEGDetBVfPxjbE1Sml++PH5TEH9VZoQWQzqTJfL7iDrDNKZlWZlDolqivMmjNmG2ELdbEJ9QqmCyH6ABZfB441NhjOjH8V+jg42cJj5XBkFy35izmr3SJhCekuvAgwrZVsb0O5nRaddFw5yVXDOdrqO5vhrDDoOUGs36P6W7wYYOk7/YEt+0pvJaqrYAhvCZQSPqSZsGw0+Rtu/3oNoFYkX3+mXoJb7Nb0Hhe/HMkf0aJzmr3RFk4wLIYVHBN9OhZhKSTmxBEhU99/nHFpYWiicTdRkn2EXp7x0mjYflMtqb94DdN4sI22jyOD0dpeO4p+I53aW2EBM+rZBUaHrStHuG704YoulnY23qvZjcrV8to9Cm1+7WWRKYZ8qDLg+/oI9aPnCttuL8pnTbqbtYg8ByOgmAFFtwrG8E9vvOjrxX2hewwXZRULjmU/RhJDl8wrntTIUYDKK6ayHE+3SNQHlfnkZSbsPx4x22CUMzGq0kobnPhBj/EAEd1u0qic55sVMEzZRi3s8cChuHm8bBUL8GkCFMAKUmZ+LZJjv7hJTib5nUqZ3PnwmAp/BgNjCoC5CU5Qh4rjH4QK+/2IqY9Ghc6l17dJEJRbtgvvgkuUFKAWnGClyyqT8jpHlbtH4Vj3Zt+/Y/e2BJl/zRBkWDNf+GZkliv874vGyf8RbEjC3A9O8L3JkUhufwlqM6j7Uk/oTP7/+EUQ/fGiR7L1UCbDINW35ys2EDmp7+PUmfq1GCFop2z8eUQAj2+RbyEXRTOA2/qagC9SNfDk6YG6Q9XjDHXYPNJXBkDa2DL59YYOHnDhCaB2p5u2SGo3t4cRdHi1UlPfpdIcVgyBS655H69/Zhu51hP6kuhpeh7TBnh3UY0wZooRMSaZcWU2rxwsx3vb7NHNXW1sUXNXQE8uuV1Xs1wItvdsLMMaz5s8CKgwdfA5XHuaU9W
 7c3M/6jg
 Os6SEbyDujePjmpXHV8Grthje7opiAGq6JNiS4pgizeZy7Q8pbkRJZ8z7K/3kGoJhqIhSYFIADj0ZrQkPp3Eo+GVXafXEUAbbaVdAHTIUP+LIbcFambDqbVvdQwQTtqlerpuYN9ykDfdd2lVDi0aVOIdYkBkKb6BcB8btItFJlKcwPNO91sjlgj/s5MAvpO51XykfpBaGQHM7QVUFc2sTh0nV/YQ/A9Xa/6zGd6YJRhW8CRHsL/lL1SorsxD/1MdGFVQmBXS5iJVFzXfxVjfxUPGnpcQiwkfJvV1aGIsUozCeJu2Fl6jM0TeGwSS4gB+BkSetHfRq4k63ktxTc4tbbR/yK83uLB/Har4RI8FkJriw2kl0QTp4xfSrVhFaCbxNP+2QO+gGxNQC+yRfi45hdJgcnGMgSaRpc9A4FyxZCorLDVwTSchUUmhBfXwrxNR/YSx11b/hvzhJ9iNMSjttyGPR+HQFbdhV31vLE3YeFzyoPDT7xAH01IPl68O43Xj6ulgtgBFlql6TxnVm5zfOdfSQlt/MHITXlMh/eB8vpG6Z6ljIuKhOix3iiMBXfbSHSfedOB9iB74R1UllS8HEAR0IfDUD9KXZFQ7HfQL2M61Fpgs+2uR9CuIffa+Qc+l4gSDUCw2HWC0h1Hnz4r/v82HLUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add implementation for the unsafe functions __set_direct_map*(). They do
not verify for can_set_direct_map() and expect the caller to do so
beforehand.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 1a37f4ef130b..080a40846bbe 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -16,6 +16,10 @@ int set_memory_valid(unsigned long addr, int numpages, int enable);
 
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
+int __set_direct_map_invalid_noflush(struct page *page);
+#define __set_direct_map_invalid_noflush __set_direct_map_invalid_noflush
+int __set_direct_map_default_noflush(struct page *page);
+#define __set_direct_map_default_noflush __set_direct_map_default_noflush
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index c59ef17eb0d0..28adab0edace 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -294,28 +294,38 @@ int set_memory_valid(unsigned long addr, int numpages, int enable)
 					__pgprot(PTE_PRESENT_VALID_KERNEL));
 }
 
-int set_direct_map_invalid_noflush(struct page *page)
+int __set_direct_map_invalid_noflush(struct page *page)
 {
 	pgprot_t clear_mask = __pgprot(PTE_PRESENT_VALID_KERNEL);
 	pgprot_t set_mask = __pgprot(PTE_PRESENT_INVALID);
 
+	return update_range_prot((unsigned long)page_address(page),
+				 PAGE_SIZE, set_mask, clear_mask);
+}
+
+int set_direct_map_invalid_noflush(struct page *page)
+{
 	if (!can_set_direct_map())
 		return 0;
 
+	return __set_direct_map_invalid_noflush(page);
+}
+
+int __set_direct_map_default_noflush(struct page *page)
+{
+	pgprot_t set_mask = __pgprot(PTE_PRESENT_VALID_KERNEL | PTE_WRITE);
+	pgprot_t clear_mask = __pgprot(PTE_PRESENT_INVALID | PTE_RDONLY);
+
 	return update_range_prot((unsigned long)page_address(page),
 				 PAGE_SIZE, set_mask, clear_mask);
 }
 
 int set_direct_map_default_noflush(struct page *page)
 {
-	pgprot_t set_mask = __pgprot(PTE_PRESENT_VALID_KERNEL | PTE_WRITE);
-	pgprot_t clear_mask = __pgprot(PTE_PRESENT_INVALID | PTE_RDONLY);
-
 	if (!can_set_direct_map())
 		return 0;
 
-	return update_range_prot((unsigned long)page_address(page),
-				 PAGE_SIZE, set_mask, clear_mask);
+	return __set_direct_map_default_noflush(page);
 }
 
 static int __set_memory_enc_dec(unsigned long addr,
-- 
2.55.0.970.g62bdec98f9-goog


