Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86A05C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1DA56B0107; Mon, 21 Sep 2026 07:01:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA74D6B0108; Mon, 21 Sep 2026 07:01:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95226B0109; Mon, 21 Sep 2026 07:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93D446B0107
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:01:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36109160153
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:01:03 +0000 (UTC)
X-FDA: 85237477206.16.53F03AB
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf27.hostedemail.com (Postfix) with ESMTP id 82E8940004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:01:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nouL6dO6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3aw6xagoKCKgdLWVVMNWZbOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--vdonnefort.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3aw6xagoKCKgdLWVVMNWZbOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--vdonnefort.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8VZDFkjWzOugDjBak5KEVL2CvMFyhCyJVy2+GxZNxI=;
	b=wARTwiPbu6BjkF27mH6Q2ezkbHqGEVqFSNsC9OHM1MjuYbw3EqQKT9Hd1fMgCYKNXyr/KU
	cHGW/MuzyX+xx7rFh8q7PWMY6rAxEUxPM0wWJGo7YUUDp8Ztli9NzHNcC2pQgdNnGDVFWS
	80hHuNg7jxqbzJV89uXKhzbr3d8JpAg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988461;
	b=kJkJc5YclEYallE/TzXLnhHQlPrm0uHkFJW70xD+Zt3S17tKaMy5VwRU3cdIfPvte+XLjA
	icx44nWl+5YIu/gXrZRxpZxAY8052mLApLgbUJH6dgQEJZsq1RuG/wVlBsUhVleBZjPSRV
	7KpggEPMHbuPPlBd5hO7eKn8LbIbGZk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nouL6dO6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3aw6xagoKCKgdLWVVMNWZbOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--vdonnefort.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3aw6xagoKCKgdLWVVMNWZbOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--vdonnefort.bounces.google.com
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c29959eb71fso278657166b.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789988460; x=1790593260; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g8VZDFkjWzOugDjBak5KEVL2CvMFyhCyJVy2+GxZNxI=;
        b=nouL6dO65rHnG+JW48uTBEiDerwO0lWidyEMZPIs7hwAMSIjQLgi0uUSsn7wNVqJUN
         9Esa3R0Usry3YMaI7fR9x6Vp5n6YNkGY6VnCWI4kO06WTIDCAd//7A+suf4u4/1afN8k
         KyU7izi0KDuVZRJ+0j3DSvTUB2yn71EKOJVXVvTbnkTNQ0HdT1HXc3miKsU9+VbtA9vt
         aa2eDhwbtAvs3x/cbUSOqmq96A8Holpq2exbl8y+Z3IpqZcZgu+nsx3O4Xk2BYdEAtKU
         Lz+1MJpui31WeAwOSoo8tCA8vObzDiAjBKvY2Wir8ZiP8XufMBM2B82cY2T2aWfEEhWY
         vAaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789988460; x=1790593260;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g8VZDFkjWzOugDjBak5KEVL2CvMFyhCyJVy2+GxZNxI=;
        b=dFP3Qtz9IFkhdYPEd7R5k5zsDraAS8UkKclSYBaXDgJG1IJf6pbtOzIJLpSf8svAA9
         wVZ0L+ZId5egBSI6yeXGC2IMYUadxg7525N9UnuQXzy5wqHgV5z92syWA36L8x0cAbI7
         tvr6K42vCvbwjK87AIU75fQPZCdhbqjaN0lQDtiMUnIHpg+vWPTRy1nPIs4z2whNoQwr
         rfUj8kmvWbMxswDhV/BLWLQe+mj35zZV8h3Xm5MR6YTdzFsxyDNGaK+fTw9CZEar+3nU
         k/iRsf0DWTzUpu97YlZrdkEuG+9C7O5/JoSRyBLti4J1YmQAphUtIWwlNIHaX6wER/l7
         cxOA==
X-Forwarded-Encrypted: i=1; AKwUvBx9LSg1ig+mXIMT+44NUNF6BSG8EZ0VV1zX7rLM9RqfdoHNx2Efx/i/gNzQbxeD8XhTUCsSgHGzTw==@kvack.org
X-Gm-Message-State: AFuF++kqzrzvCsxpX7OkbEjPSmJOqGEViDOKfEt9OlkidHylJNIOCG3Y
	XbDeyBl0q/UiXNXCvCgzzsr3cHxHCCCO9zZAG9mqs7LibrtSJT4xRGPvyv5GyN9+4fMNRmMMc2V
	iEHzbjqT4e6XhvK+KUpnBpw==
X-Received: from ejcew23.prod.google.com ([2002:a17:907:9517:b0:c2a:25e5:645a])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:6d17:b0:c26:1649:47a5 with SMTP id a640c23a62f3a-c2a15aeb6c4mr860923766b.27.1789988459841;
 Mon, 21 Sep 2026 04:00:59 -0700 (PDT)
Date: Mon, 21 Sep 2026 12:00:45 +0100
In-Reply-To: <20260921110050.3977591-1-vdonnefort@google.com>
Mime-Version: 1.0
References: <20260921110050.3977591-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260921110050.3977591-4-vdonnefort@google.com>
Subject: [PATCH v2 3/8] arm64: Introduce __set_direct_map*()
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 82E8940004
X-Stat-Signature: 5rord1f55owu9x5m7qopkwxfmd1id5gr
X-HE-Tag: 1789988461-768589
X-HE-Meta: U2FsdGVkX1+bzkR3Nj2x+4r9dHDEgOf4pat0eIwLClMowQ6K1eQrgsU/brSFoc2GO30/JemUDNG1Mf/bl+Gb34peICcGBRJRtC00YwTE30rnPe0ZuUR40DndLnaJUQ01N8Cj8a9AJPuEtuXmm7ITtBDrs2Sr15Tq9K/w93g4Ae47A0n5MMS+uW2HT3Z321EAl3lSy2Zc9vhi0PdnCh8cr3yhBoVeBnX69axLX5ZKc7Ga8R6JRHW3JFlkbOCAaW7RHx2P4v/bJOOZfSONl3VZpmxEQRS3d1A7EjwbKmg3kjSWIdy/TqYT0ZwiBtVV9thXhQyznrqnQLcoGlrCQX1dAQomLHFL62xiJjhtTIPeMlun3iKcJ8FA8VuObXX6B98NQPYRCqMJBrthd4CTkr8xtSTnXcb2pzcQfSKPMIybV4OJNpN6CUSb7sT0hrkg3fNhsnBVutACcTgAcCoZtfmd9/+/lj0xrlzYmw18BpqD9DZDrefSrV68BcNUCQums9Ylz2kewJCcMuJehIdIMiGRLUnarJ3KkgLr3HyfpXqUlwTsvjRi0SZ4eg2SnfVNpqM6AkngJsf9qBmmBZZNEOt2FPwubFYvpjTPw/MQ1+t1iJfFfApllL+OxU+AK0FDMNxagMLla7RCVZTewTUK/Hx/ROD0PfitwXmPRBvB3jVH80IRioOasjYcwxF9xD8GIxarRi/yYPhyF1iwpTlqoey8VlSrsd4kdRIbpEBs3kmHh5UFKYe2nCQcKZR90axrk64IiON2pTg2Cj4C0vWsBlStAHSg65EnlMNsFbnylfpcvpe35667EuttRzvOdRfgfi7AAxnPwI+RkOXDkvK1ZvUiez67jrt3akKu+socuQaFiQsx2iVMz/IED7jvz+H2Ep/Z4hanFi8eExMOJaG0iTmQ2F1+0EoUqetizq3UyTbu1Dg5bkNQB/I21nAUFh19mQ+DvXu7quiRjN3hg8OPVWm
 bMesRgqw
 QGuyQ8D90ahKSjgQnTmkB7mxEYAbvGxuG69ftQ0xmT5NQvRZm+1zazhuPLOa7xj6oY4E2rIh/gcD1EMXpebC4+l3g7BtyKCDyBkJKxe3jmqu7jT9kR/+FjXtaSyPJ7JG2Rs06T4XMNj2os2vf0QzaKhi+fuSB60XclHCFF6wqffsQ0JUXNa+KJvzO2okQb76NO3VkcT2Z/Vj1X5rESVNf83HDEeLAkvPpiRW7X9iGmECHM2WFT1htIopDHw2n4kr873UOOF5pd0JacJaZJuTULGFzEXHKTtt3CnyeIplTywi3LydjDCsjWInM0LqQhA2chsFilXdLK3PoWbpBiAWBsk30wVgPXHqqDQB/29mvo0vjCFuJgQmUiVxxneX9+S7xQViryNkjbIpvhyMiGXcxodHoHRjueFDiVBkbEv6xQFIgJ7xmuWq92hS/4SI28dYBxl+DeMrzqG8XLzuYffiXFuuKZ883AaFBeIDbQ4lbVxw4VA+geXaOLjRI1XSNi4D7iCUW5HMwhzOYKUQVqmqnjEV1juPM5ORRgbHMcXkjyLt3VfOVs2bT7G8NLH/9H7llwQxKtj+gIyCm0rVWp6sxuc5VwK06/HfDtkgdk2ljM0wqG2frmTfm69di1NyF34dokHulxHW5NspFLrWTBvy3Gv+9xeD+x5sbarpd
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
---
 arch/arm64/include/asm/set_memory.h |  4 ++++
 arch/arm64/mm/pageattr.c            | 22 ++++++++++++++++------
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 80bb94a340fd..5e372a02b825 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -16,6 +16,10 @@ int set_memory_valid(unsigned long addr, int numpages, int enable);
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages);
 int set_direct_map_default_noflush(struct page *page, unsigned int numpages);
+int __set_direct_map_invalid_noflush(struct page *page, unsigned int numpages);
+#define __set_direct_map_invalid_noflush __set_direct_map_invalid_noflush
+int __set_direct_map_default_noflush(struct page *page, unsigned int numpages);
+#define __set_direct_map_default_noflush __set_direct_map_default_noflush
 bool kernel_page_present(struct page *page);
 
 int set_memory_encrypted(unsigned long addr, int numpages);
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 5fcdb292905f..3aaba7f988ce 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -301,28 +301,38 @@ int set_memory_valid(unsigned long addr, int numpages, int enable)
 					__pgprot(PTE_PRESENT_VALID_KERNEL));
 }
 
-int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages)
+int __set_direct_map_invalid_noflush(struct page *page, unsigned int numpages)
 {
 	pgprot_t clear_mask = __pgprot(PTE_PRESENT_VALID_KERNEL);
 	pgprot_t set_mask = __pgprot(PTE_PRESENT_INVALID);
 
+	return update_range_prot((unsigned long)page_address(page),
+				 PAGE_SIZE * numpages, set_mask, clear_mask);
+}
+
+int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages)
+{
 	if (!can_set_direct_map())
 		return 0;
 
+	return __set_direct_map_invalid_noflush(page, numpages);
+}
+
+int __set_direct_map_default_noflush(struct page *page, unsigned int numpages)
+{
+	pgprot_t set_mask = __pgprot(PTE_PRESENT_VALID_KERNEL | PTE_WRITE);
+	pgprot_t clear_mask = __pgprot(PTE_PRESENT_INVALID | PTE_RDONLY);
+
 	return update_range_prot((unsigned long)page_address(page),
 				 PAGE_SIZE * numpages, set_mask, clear_mask);
 }
 
 int set_direct_map_default_noflush(struct page *page, unsigned int numpages)
 {
-	pgprot_t set_mask = __pgprot(PTE_PRESENT_VALID_KERNEL | PTE_WRITE);
-	pgprot_t clear_mask = __pgprot(PTE_PRESENT_INVALID | PTE_RDONLY);
-
 	if (!can_set_direct_map())
 		return 0;
 
-	return update_range_prot((unsigned long)page_address(page),
-				 PAGE_SIZE * numpages, set_mask, clear_mask);
+	return __set_direct_map_default_noflush(page, numpages);
 }
 
 static int __set_memory_enc_dec(unsigned long addr,
-- 
2.55.0.1082.g2b9226bbc0-goog


