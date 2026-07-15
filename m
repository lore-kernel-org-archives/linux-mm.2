Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25C37C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08B696B00A6; Wed, 15 Jul 2026 10:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B3F6B00A9; Wed, 15 Jul 2026 10:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1EBC6B00AA; Wed, 15 Jul 2026 10:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9AA8F6B00A6
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:34:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17949C0166
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:08:54 +0000 (UTC)
X-FDA: 84990889788.05.FDC95FB
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4277B40009
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:08:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jc6FppQP;
	spf=pass (imf17.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784117332;
	b=LhGADQ+nn+9/4dz6Fe6BYgdxA/FOBEm5azu29FVbFPuHPlOhuzVwwfauxykTFRBJElppRj
	4K2HEiLcqX4b+bFP54odJn+WazenXBEJFgJoszznE/HtGTVK6WSC9X7GIJSHZDrrJVaC3I
	gsydUG7tUW+JlHiKXBG8Z9KNpLXCn3E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jc6FppQP;
	spf=pass (imf17.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784117332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E3pHMdsibx37YzyzqXGwFL/dQqT2DUhJgZdMFQuT3hs=;
	b=XOJ0PY9AN/a3Gt4XKQsJF0X79ow+jgbtyUJhzdyw1l9E9G9hxF1vTHz1qfJX4BjO8sev2y
	MGhabYe9cCXb/abaPxO9b1sVa8pXvcmxGjtouyQPTXvO184U3kfwMTh2pbSrjuMDKkf9jX
	xwZeef+A/w8xE2UZC0ipVP9Pc8U0R2E=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ceae1ed204so24852945ad.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784117331; x=1784722131; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E3pHMdsibx37YzyzqXGwFL/dQqT2DUhJgZdMFQuT3hs=;
        b=Jc6FppQPwKeZOOYNUGq9u8jE5hhtSke4IW2MJfOYtNFu9IaU26RLL+T2sk2d46IG+x
         XfV1g49rnmQy/opwMuyYUfAT7inzH4ORw0JvFdIFAjL6H6nCCKY4Iz1CnZDAxVdiT4eg
         BDjD+D+2DgYokS00MTGnR+9sJlneZxRa2bV6P4YNk+r6axvnAMP4nvoDVpsoi1zTx8uC
         o/6ZPlAyn/+Y6ppA1Pt9OZ5Q/4mfGd5a4HIs16HEYwjiSqcPrqNlPKV8jxyip0jv0St0
         KYgqGWapVGa0wIhALziD5gS42j6Frmkj86a/OUvw5mUDbnmT4/O1wsJTy+sVG0tx0sP9
         uRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784117331; x=1784722131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=E3pHMdsibx37YzyzqXGwFL/dQqT2DUhJgZdMFQuT3hs=;
        b=Ae/4mwvuHjRsDch4i3pi/fCcnrSPeEyoBJKqaFtAH7VY6LgSP9lYMMiW+3iPvYgQVU
         KQmdvim1ivVzUCvTk+8jtDjezw5laqGXZ/xIdMf8qBy+knjK43/MMXqPcxWa9T3/vD6d
         7BbuB+rowCU93MrxFbHqxt+I3o2PEtmygPn47kQ/aT1zs7Sj+0ufk/mxs88lkMDyaZwM
         ys3vaEZjJ8nPbY+E/fsG4xjlEssk6PzXvdkkNIfCqz0IrbHKQ3wQGBquHKg0Ytx5w8jF
         F0f79lGW7PNT0KMAG8cfOhQry7sqovp72qSxC0cgNz9Jg3QQyagqX8bLWqxFDqMPwFz1
         9RIQ==
X-Forwarded-Encrypted: i=1; AHgh+RqypbSoTmRWjBIG0KJfK1glKQCxa4UCSS0p/xHEGqDMimMYuf18sZ83zpR2yT9PuDYZkjIcDX6kTw==@kvack.org
X-Gm-Message-State: AOJu0Yz4hUhuyjv4IIr1gG+O+BHMJQEr1A0A4qfbXHXHV0POX7/kBxlV
	T8+93CSEX8eGekZDtxTOaouAmZviHMDklQbrHDjRAP4jwR3mSXZtgeK9
X-Gm-Gg: AfdE7cm/XJC7QXPkcvJLAcUZV/Qp0lM2tRSvPikUnPpKsPNNc/YR/X+xRMRvyQFlmkb
	ZqBcnnBpwuu/zGh+JU8q4yXuilvdlsVlPI9L7IfzP//wVWX5PHXPuv8VHz3/gTauT18k2eRrhyR
	LYIsJMFNgWFlQgQePMOYGSRb9KgNfRHmVHAzpDoykHLYsLc22XjkTjJH0waDyF/Z4RQKIeyxem7
	UaZU10N8nTzo7Yhyf1qNCXJT4vhuOICe0FraiitZSjo+W2IjWKRCYseh2FbsCO9qo25wTrSfeRy
	z+K7kARHVR+QqXfbzDGnCIcrD+aXtLPKJ7gSCmParP1JgYFUmxypj1EBQemMB2GthMT6pcmgFUk
	z52kbf6AcZVmyejpix9u2a946v23wdaW5F7cuwcp/7LtuL765DYXYTNYqx92btR8jAhMV0jtN4W
	3Gs1dTroIMQxQs4OWMqHXRc3QQgFblMZB5kGjylBZoozBtLg==
X-Received: by 2002:a17:902:d2c6:b0:2ca:cb8a:f26b with SMTP id d9443c01a7336-2ce9e5a5774mr161404365ad.10.1784117331030;
        Wed, 15 Jul 2026 05:08:51 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf105bc642sm1216325ad.63.2026.07.15.05.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 05:08:50 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Leo Yan <leo.yan@arm.com>
Subject: [PATCH v7 5/7] mm/vmalloc: Extract vm_shift() to consolidate mapping shift selection
Date: Wed, 15 Jul 2026 20:08:11 +0800
Message-Id: <20260715120813.3609949-6-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4277B40009
X-Stat-Signature: 8knffy68wsk4emd7tzjfkw7rhmmf4ipr
X-HE-Tag: 1784117332-184532
X-HE-Meta: U2FsdGVkX1+2ocHEzr7rRsaZ53QqubB5O2Umkb2puuI26rhJcI6z0a0QKXyHk5C4hUJrkWjLohw4AcDs64L1TuVMV2pVzrDVScT/BGB+F3gBtYFxBHyIsWUPZrkCClCTdoclUfAV81cUNlVkedpvXc8dzyDTVxcPOaTcGe+4DoNFCyjcqbtrLq7YrK4aGl0CujZba4KvXgJOVH+5ZnSxKeRW2aElfepsmXUZAzKrZGMX+NaRjpDCFTds3bhyFW2qZm67gi9eLRIykCdyVNzyjMiL0UMMazPLgZIsS8LHuBb6XiOhowFpe0bhOtaJF+ZHXl22feR3RYQG7kIbF/EbP61INUyBI62qgvWzulB41M9nnK814A0QxvLGJ609tiK1d3Jg8rTdeX7Z+OEKqSYjSgPkBJiNnrjo/SVfTM/nCxU4DERoWsCi7RmzCPIv3yT2FtPqkrgmTVc0zfGje8lQqQouRaE7N1J7w8NC011ZH3ulTOBp4luF1GLaLN1x3x5tXPdujVEnyOnqiMU8CntihmiaFzJ+rxktU0UUbTrE+JexYTDhzUP1xQetJW2rmjVK/eOnefifuj84a0YcXQTNadTuANxsGJMFp6HmmfSfA20ih/jg9/+TS7IcsaBg+7NYH0wZaab0dPJ7PdqCoY4hiU0Jn0XjgCkaoVpSdBdEP8vJPQFpFYAhUIHNbDR5E6QtT6g87VAmWa2ChSdFBvo1pJJpkT/MEVt2ts9sf128oE+T5uXC6hNUriFqD+Hqd5dXjlD1gOoC1QM3DZjmGs+89NfgoC8HAXNgM5U1RAoQJ5VMryGP/KJntmrFkjEZ+IPYecPO8gaXDjDAbDgNO9kwvHYmTNkQ+/72DR5u8jsbvyXvDrYdooKHaJPs1KoN2T1x5++zWdKglR8ocN7VNGstCwXcJG7SM/ujLlcEw1b+v1Zm1NKbWcHjQWxNbsLzpnkWxzBvHVYdZUmNXIyj6mt
 o5nFX8/M
 0Q1s+CfkcQBDW1xMq6tZB1kny3kEgxEqs3GKS/eTJZr8YPyk6No0E+a6cl43aHoGpumr9vhrsP5+WK62FqLGoFwmbEatpZh/R4JVrW0CzO40GP1r5lQJJMccoPVTwjkqaBcsnbda2ZfniU6Z0WM67yNBJWPSR7WSlIHkRKcGzVExoENF7XfrNhXfgvg0bSQOiMn4W4+r/uQaSr96Vi1NEMujjbVgGC1due9jFb8jjmpJP1hrTK1u9tLt9jrdEAVpE1FN0NF8sI2jGNtFOc2hZlOqWwCEbU4rqzwHiO9VMBfCG4uvkZ5DJmQ+J9TSCIWd7uhgjWoTy1lNlb5xq8QeC3fIbBlxQxHghZmQmoaTqlrcM6UP1b/rmvih/eK51ZnVOsYHZcLGNPlCrZ/aLw9C6XqsoBZxEAfffR9DwS7goBACVWsmNDzaQkfc9dzpczP8hq4w3Rv/M4uKMtjHROtlLTn63uHOKghrfySwdb267K4xXfJDeq/UV+tHPT19aMV+GOWmVv1jFKgtk4zcofiG7DwYa7qOTEVCpQr2qU9YNeb4kRRjOSSwuZ3eebk4Qe20DG9sD8Z1iCVbC/kc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the vmalloc mapping shift selection from
__vmalloc_node_range_noprof() into vm_shift(), preparing for reuse by the
vmap batching path.

No functional change.

Suggested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
---
 mm/vmalloc.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index afc695d5973e8..a1e025120e9df 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3549,6 +3549,14 @@ void vunmap(const void *addr)
 }
 EXPORT_SYMBOL(vunmap);

+static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
+{
+	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
+		return PMD_SHIFT;
+
+	return arch_vmap_pte_supported_shift(size);
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -4047,11 +4055,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		 * supporting them.
 		 */

-		if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
-			shift = PMD_SHIFT;
-		else
-			shift = arch_vmap_pte_supported_shift(size);
-
+		shift = vm_shift(prot, size);
 		align = max(original_align, 1UL << shift);
 	}

--
2.34.1


