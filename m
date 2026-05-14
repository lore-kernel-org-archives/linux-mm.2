Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD40BCD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47AA46B0096; Thu, 14 May 2026 05:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 451FA6B0098; Thu, 14 May 2026 05:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38F6F6B0099; Thu, 14 May 2026 05:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DA466B0096
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:42:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D5B7E1A053A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:42:11 +0000 (UTC)
X-FDA: 84765534462.07.4801524
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 13108140004
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:42:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Sgj2zxzD;
	spf=pass (imf09.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778751730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rrNbLANiBcQr27ZSAlrK2cxuCnVeM2v9Np9AjqW/V2E=;
	b=qPCiAMi5l7SfSIbGsAiobWPOFvC2sjI834KUHvyxp3qqJa4+3Xk2+xBWJUG7gDCSRhRHGG
	4vcr+OggAkuKt1at8vbHU2emrDuxDdW42PZy3ppV6oaqsn0H0u6P2YGzp8lVKjl4pveKPT
	wXmpC3cneHIynRmZaqL7SxCtJaoggjk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Sgj2zxzD;
	spf=pass (imf09.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778751730; a=rsa-sha256;
	cv=none;
	b=rtb9tlxB4+KKpWpZ6t5+9X7yVUgdhZq/nyXGFdFngnjFOrqdS5tMVXNWJvNdyH/vWhItob
	7/4MssV+OYG1N/l2fGyeAtN3RMre5tJ4ix+Z1D0U37iPQP2KJS3Wrm4zjT0Do3AcgywAbq
	rXESk+gA/DxxtFmBACCSvmoOCtjG6Zw=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c828daf83e2so2264580a12.2
        for <linux-mm@kvack.org>; Thu, 14 May 2026 02:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778751729; x=1779356529; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rrNbLANiBcQr27ZSAlrK2cxuCnVeM2v9Np9AjqW/V2E=;
        b=Sgj2zxzDsJ2O47DuNAIeIbVFnBz68XcxwbwrEtZcAPRnSG4RsQWhA8Xr/FjwKrFKeG
         Q+kOFaPy0bT1ysxtBQenqlCuYdlP/59S6lW8iznSYY/tD2zgN3uJu6Iv42x0KpncD/au
         WuRxc8D1BqGsC3TjWoiJKDAMhLur/7NAkvvG3Z0K7sTtaxNOIGWERRrA9/QjyM0amUer
         Du1HiyrK1B1ZSiVty+PyvHpCYNhq2dOHwsMBu9o4RuB3M3GM55gZ8X0HkmiZc1h5K2eV
         kzI85ATmVp9DU/AgEUVs+xaEDuWCcEF3gE63+B2j8D0GgUA4sTxp93m01OBRPIwASB3L
         2hCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778751729; x=1779356529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rrNbLANiBcQr27ZSAlrK2cxuCnVeM2v9Np9AjqW/V2E=;
        b=FvqpHqpEsl4PHn+ALaXL9PiNN7BiGukwBWDlEKbQVu5XxH829oIkxVbjLWmLGlzMsb
         t5I3tz92UoXYh6lK+hPW7h5mzMeyazaARFOV2iCuAX4coPEVGoklND1xASj85wmeusbF
         PKV7CZLaR30xpj3Fzjs2yWvwpp4U/Lr73jP2/QPm/Kw82uNlxEZaVsCYt1hhxQTnV5Ta
         HbKpmUOtQXZ/fpSdx8R8qTp7riM4SxzKRDZQiTlqhngM90dUpi7uDVUTXoQWr/aAWi3l
         EHF6ACqoJMzHwRzlSGD52fq6Zc/okYST5HELP/jP8vaZRfhMAz4GJlrKwHoGH1uj2K7n
         Q2Hg==
X-Gm-Message-State: AOJu0YxORHSyxLX2dsUBS8FrPFAghOFA87Br+Nm9DWalqfuNeBdH9VG1
	pW8RndRyzBfQ00oLJwjKwSHou9WxA3ki301c+3zbBtq/M81xlnPsMG8GL+icl/bnCIA=
X-Gm-Gg: Acq92OFE4qf8I3odGsJF4BYupOORELV0JBwBuTK5VTN9mmnEWTSFLQRrVUiVKpp0Wu9
	sX3KvH3pBI/Xeccp8jrvROOEw3BGWfRKHHvbx0jYmam4/xPRtDrx9Ky/z4IxobXugdqcc2Yffqx
	lsFsvW+Nw70HX3qMMlECrU9fPo5vPCgIp184/zuh/xajLTxEuJDAQB8BD+B0HqGeeQJb9UJ35YR
	5CFobvjIwSDASFALNuAhnE8edGGBjRGzyq9azSwabqT12coc+8v+qbhV6x3eHOGTmWBd5cRemvn
	4pM+k+s52n73OTmpmzSFl++ijOs1v0pC6pbyY4R6emMu19zAuFrSt91Lr48hCduGHskwfDdtht+
	+ayTMvMGl1WZgMXT0mETJW8ONljdssLBfL0DePtfI0HPNKL+te9pJvZ+uF1OnF56iduK2sqe4I8
	LgiirLoliwUdsC2PY2tNOto1Z/HuiaiHZK41AjQw91+ekOwA==
X-Received: by 2002:a05:6a21:3390:b0:3aa:60e0:b2ed with SMTP id adf61e73a8af0-3afb1009aabmr7737701637.27.1778751728731;
        Thu, 14 May 2026 02:42:08 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb114a70sm2351244a12.22.2026.05.14.02.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 02:42:08 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: baohua@kernel.org,
	Xueyuan.chen21@gmail.com,
	dev.jain@arm.com,
	rppt@kernel.org,
	david@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v2 6/7] mm/vmalloc: align vm_area so vmap() can batch mappings
Date: Thu, 14 May 2026 17:41:07 +0800
Message-Id: <20260514094108.2016201-7-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 13108140004
X-Rspam-User: 
X-Stat-Signature: h4yedets96ootdda733688xdypi4b8wp
X-HE-Tag: 1778751729-825761
X-HE-Meta: U2FsdGVkX18U0nJ6K002m7er+e4kO5QVA1ipnPrjrFHZkgQGeCOk5PY7THklaqjHtOLjpsYXSkSDDoRp20zCuEpo3IokmJnq1v9AGIg8c6bib4VsxX/FmqcaXjcrsCWBtDFS6HvR5N9Fn1MczP+tRmawt2Pvs6Zbp6ehKX4yJxh2xeH7GLOTQojchlAij0Vksod1+Emh4QGvjgFD5q9aRx55BBLyU87DxrrO4j6rSRwUKge7w2ab61wfdi/QG1z6H/U8xW7GHNy3fJnIRlT/MZC47LuDpIwbiLGRWOG+ZqRZdBrL+k42J6a6WysRYklNyG5nNOQLA4dDP9FDDGlwTbGiQpjIBGGN/rhrR2/WWwbJeJ0PWVuA0Dg+Z/AUKurK6bEfNh+f1YgdgxLUhMsPZ1KKjCXSu/Fc+v0Z/HGNMIr26Xe9YF34d0g563WSbD5jRh6LMeDRimtUdbJ8kZoQd9DqjUWhYUbop0oUUL4gRk+FUEmyUaVK1MVkkzJPTVuSEFooCBSfEL7O8AcpSi6Ok9dWNP7TALnzXfQn6tGANptOTkO51o/892ItNbU87vwGvgM6I0lu+++NOCMEhreUiquQFAsjVllcjoXzgx3wkZObqj7LIVUFVISm+Ci3cjzgxm8cB7ZKlcIdjeuVkM1TiOMh0a5oNUzJsHWi+ozx6vmnp8d9tG23MKxq4mHIHZW4Y+zcJH3aKNelrkiGVH/CUQCx7YHwsdq3Q4Qav0f514kAOvQOGOEQ+pJQusMYQzvOvEDfUzmF7hEAFSkDYdmJrXpx8nDrSFVcpQLb9xFSO0sxd33d+r8osG99fx0EjoGk8WcxfaRCZi/RhLZgQ5Te/Alewk49UbW8ntNZ6FZbA9Ad/URV/cdHB3VWvLSesaTfgMjHmpw60aS2i9rjz5yOSFmCCDgK/lOy6mY09FOuICAUOySPrwYBZPxytMcCXtNRRNGursiXclDgv20F0lK
 jRrd7WcF
 HDrlIUitpcyAhlf8KKJGnNet4GIYxGPQ3y/il29KQ//FoaZvkvlXXtgrAO2qJX7shZxW0qcYhGfiRAjC7W3cD8fCqTwudReHDNn/vXNrgcgXNpSu7FYo31YJEQHJd4bZhCDg1lIkBAUpixxl/gEGj9esTle05evCNE4OcOWdZVvB5KQaSUAXvj8Wqwizn+WjQYKnE9KcEKRm+fuTGVVGZWRZErpUYY/RK+dtJqeV/WQ/WeMzPAqW7Kbx56KUcm5kCJUwFSsPcm1OobWWrpyt/A8tOLmLbU7CXaOH+yPdW3xr0/huGUzon0GixsStXN4YhjJcuNmsXOOzlc9lQYTxxqjKMadIwURy4PffV7CAohd2dHpju1eJl6MsmZ0+8J/QztDXLn1u8X+7UXxvCqtqkTgPYPBUQFEoeGm9wyB7U4hX4ShhwKMjCZqxt3efdy4vcjBUQEJaJvmAoEjjAQ0a8i/xXFnChbhxivipCXKOx3mk66qjEOpQ79+FSXixD9OpyDquWnasDTnWo5uxrx02OSBlc9SzJZCPs4OQd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

Try to align the vmap virtual address to PMD_SHIFT or a
larger PTE mapping size hinted by the architecture, so
contiguous pages can be batch-mapped when setting PMD or
PTE entries.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmalloc.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c30a7673e..b3389c8f1 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3591,6 +3591,35 @@ static int __vmap_huge(unsigned long addr, unsigned long end,
 	return err;
 }
 
+static struct vm_struct *get_aligned_vm_area(unsigned long size, unsigned long flags)
+{
+	unsigned int shift = (size >= PMD_SIZE) ? PMD_SHIFT :
+				arch_vmap_pte_supported_shift(size);
+	struct vm_struct *vm_area = NULL;
+
+	/*
+	 * Try to allocate an aligned vm_area so contiguous pages can be
+	 * mapped in batches.
+	 */
+	while (1) {
+		unsigned long align = 1UL << shift;
+
+		vm_area = __get_vm_area_node(size, align, PAGE_SHIFT, flags,
+				VMALLOC_START, VMALLOC_END,
+				NUMA_NO_NODE, GFP_KERNEL,
+				__builtin_return_address(0));
+		if (vm_area || shift <= PAGE_SHIFT)
+			goto out;
+		if (shift == PMD_SHIFT)
+			shift = arch_vmap_pte_supported_shift(size);
+		else if (shift > PAGE_SHIFT)
+			shift = PAGE_SHIFT;
+	}
+
+out:
+	return vm_area;
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3629,7 +3658,7 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	size = (unsigned long)count << PAGE_SHIFT;
-	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
+	area = get_aligned_vm_area(size, flags);
 	if (!area)
 		return NULL;
 
-- 
2.34.1


