Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E62FCC43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6D9A6B00A0; Mon,  6 Jul 2026 04:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E136B00A1; Mon,  6 Jul 2026 04:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0C986B00A2; Mon,  6 Jul 2026 04:44:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E8316B00A0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:44:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 29AFA1C24BF
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:44:03 +0000 (UTC)
X-FDA: 84957714366.24.60FDF6B
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id 585011C0007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:44:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=loL0W1L0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KSbgaZameMZT6Pjy74Ve6SG9Gdi8KRbFPWTiDrhlMw0=;
	b=pjFlzqozHW77pjVKjB9tNcrHMKRkBzel1nDHOpUKixRaA03svyTud75PYvSouNYoDeczLV
	Rs3dKFt49xJjl6oTaNWO9ruqi003C4DRUbvaAouGkcL/Djoby6AUy5f0brOv5Z69Dz2SDB
	bnFcaxKH9k2jiCUT7xJH3CVu6VMiG54=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=loL0W1L0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327441;
	b=vg5F8BWxvZzLdfdUWg+oAXYfSA5IKxL6O2wHX1xdJI6aFR3EbtMntO3IbZOIvnLD6VxIrZ
	r93EXtuqSteIr93Q0UG5IOyRdkISCLw63ItyAvCRQKaPPUxoyKkD0+LTOqwHEkx5wH3TCk
	7RJMzaEUJ/icEX2RxVXLLdovp2Wzajc=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38175907a56so1485915a91.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 01:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783327440; x=1783932240; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KSbgaZameMZT6Pjy74Ve6SG9Gdi8KRbFPWTiDrhlMw0=;
        b=loL0W1L0gx/BMkUvcw3FjEKNbOoyQjhhLWrMOAp8eK41NlmJzRPDIgdi7mGl8DsWMz
         x47lKsCMYNpROYzNUh8m2pouSKRJlnJ2ntOkcVs87pZMe6AAxGk2QXPV+zxZhBgeB/PD
         /dnHQpst9ujVvLh+X5QDU0VoDjTcw2KY1teD0E4sdHE7aWDq4jJGUPtC8C6WIQJu+4PH
         NXNzcqZPtZARe7BkvT1gVQIz/TGaHiBA0gjNILYqwygn0GZfsBb2AcoFF5SbbP2T2kei
         36cLhZ+dYPqefb01uyscO9L0Mw0UJa1qfhLTkLtlWUAHbwyTvOJ1rp2HdlVGgGyMSPFS
         b7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783327440; x=1783932240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KSbgaZameMZT6Pjy74Ve6SG9Gdi8KRbFPWTiDrhlMw0=;
        b=ruPKUDUzzdBZfDG9L+gfoHXtUglGR0vOG0RVokPga3R3UmQm5HujuzFFaOeP7Io4RN
         lzc7vXTUJp76cLivoCDHkJzvIEnnJMHxfrQIL5BKMVwhU+iuLrgwgen20sDQigTayfEz
         hQ8Q+kMJWdM+/lkJpxNQsfPWBCEZJZdjfALXFHCy7V2o64zosdBgpTbihcUQMD+yMfbI
         jnQj839PkIC2DYcniHS2HXA0/rqC+MNkUx73rgzdjdUqNgAM/hknISLul+E2Th4828i/
         LuuA4BzqtcVLdxnD9e2o30qIZnokUeC1UYfZip3Pw6hbZMGt0DYbkquLtvnfIkWpUASK
         +r1g==
X-Forwarded-Encrypted: i=1; AHgh+RrmN1BLGu3H12W0Zku7jnKbgyWmU4IggIn5EGtO8wVyPhNmZY1+LeGiQ9r2eXCknMyr789zHGc49A==@kvack.org
X-Gm-Message-State: AOJu0YxG3JBoxgqzy3vH1akZ8eHcCWyhSGBPzCdJb3W9dNdwnWi/4Sby
	yx1G4QMqe9VUKe+vIUC8uX7fTyNLuAFQcJZzmpGQ/DnYzJU13RmnQ8ES
X-Gm-Gg: AfdE7cnRx+UfleFo1o75rgc5j2EYnOuD26Ntwmt6ZsF72ZNXrAJ2BhFCxWd+dbcdSQH
	UgTW96ZpA5K9r7nDPryUTGBNkXTAB2UfdcugTRImLYQd5J8Lb7Ekp1BOWJ4srddF7mis3byMFwG
	rKm+JU9yqoX91aBJ40IAfYBuER08TiCHah1MbAJJZ0AZjFEZ9pcHRFYPmGSIN9rNhVGHGciSKcD
	KhBZ38IGIbK+1L0u/nHywxCAK46If9UABuE/aOzqiyPYRwJI8JPd7TWSf8tCHK+AxwFEVtnWwiX
	T/ubD1BJfSEScg2cUWq+NnZDXy2Wg+iEd4tBbHPJ5X0swp+1MOtcoxtx9V8ACDB3UfrwrAIxOdG
	cuLnnyyWprdi0gUyU4kGoLOZqozpw+fD1qy3VCxgvkcykMV5EEGqiGBbMOKHXWHb94MqFhO0Ntn
	bwT99UobWUwuDy6q3cf1KmpkAXt1nb+pSeKUI7qtLugQiNxQ==
X-Received: by 2002:a17:90b:1644:b0:36a:8254:8eb1 with SMTP id 98e67ed59e1d1-3833f2a317dmr6848505a91.6.1783327440316;
        Mon, 06 Jul 2026 01:44:00 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3812815c10fsm4524635a91.13.2026.07.06.01.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 01:43:59 -0700 (PDT)
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
	shanghaoqiang@xiaomi.com,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v5 2/6] arm64/vmalloc: Allow arch_vmap_pte_range_map_size to batch multiple CONT_PTE
Date: Mon,  6 Jul 2026 16:42:28 +0800
Message-Id: <20260706084232.177786-3-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260706084232.177786-1-jiangwen6@xiaomi.com>
References: <20260706084232.177786-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 585011C0007
X-Stat-Signature: g8cdgoysxjz1mgyxmada36grd3mrh9pd
X-HE-Tag: 1783327441-998677
X-HE-Meta: U2FsdGVkX19aLba27HcIBwVz9S4n2GfrrQRoKWK5olPbhIwmfOff/WlXrcz/uKc+U7wgou28zD1Bz+7DUucvi4cTUgsbOmGlh1JrGNInOfZtpH/9q/F7JTXTzUzBLFuSJddpT3CmSYw6lQW6mkeVYX+j0nz+4sxWIokQ0ESzjUhxHcgCPEZxloL2ByvNx2Mazb+2bOaEcHPbOL2Qt0fgcIgcVvPmkMf4KGVyrjGh4KHs+tsvbwwCKOceDdCIEy3m9SdwesWeGxOzxkMozNcZZCoXQ2DREkXnO00ft4oHXHWQBKb5Pr8iObbgjuQQq6ygUEWX6TkpKtYRfhVwhY+Aj1JbMY008QLhYsxQmMV+HjGgcDp9J5AOb6051ZzS+FS6cjMl60bzKiv8Mg2ndvitbtQ33rb23O/82hD8rdY0bcqvd5Bfe0O/FtUXL+/XAt5O1BI99TMlBmeOY81c5j+lQKVFaSh0SYgxsDaYhkzvF2Rbqe3SNT9GHVYoDSV/+YUguQ54Xm4WWRFRkBgvRFG9MiL/2SXK4+x9phIE3Bsh09A6h8LI3iB7r5YKnoWMyEVtnXNKhFYPcr9BvgUFOwlqUrSj+cu+7gSktS9y5xgclLU8ptq29yEd51E+5/Mw4FhJPvdnuK6tIRAkJ3iWUwasTUbpct417kcwr08caUNBazu7oexfD+zpZFD3Lemp1OkurjCsikmzLMP/o6T9q/FonW7QhgFLeoRuaKfxMif+Y4S3vOuu7YBLnMnxu2BsSo+l7b/ce8+2puRPsL4Kdcv/ENB++ashL5hvwBiYtgFKmqKU1HPH82+ecVzFRDd7DRWU385pXhOYL1BsHAh4NBZ9/5SapuWOggsuLnrG4CMmjftDEDdb+k2+2m7Zd2LWNfI6Sue5UuNyCKTyWMfLGGwm8NMXJgwuNS9AG1C58hJY2E8XUlTkCn44mrw7WpL8nrbhk24Ad/K+J8NvGiRGUcg
 ySsI7vzG
 QrQtP289cdac61flNvRuipZsb9Lh2EI0JgbQEC0cf4PZqF0rMTE10ArQYTeUza9U44SGMESecGkEDhVjG0xh2XleL6GhUqyQ10FnMnXnX64KVTc8Muk6QHTDJzqa2M0I01wydNvW7PXwjlGe+zo/4MOKV/3vHa4qIc69Ee3AOqP8qAvvRPF2tHf9mE91nVOc7gslUBlmVc2sM/UziredQ+UO2oQNIODKp6O5lMVUzwSvJ7kM1hXThJYeSwahX0tBt5VkSoDJxws2zP6CoF/pwPtxUrJNQdKfQB2JtMRiKQrUNnj9f39JjC7ZmdKI1TnS1anACUcsYpc6yN0Q3g+itUWdeEhDEYfhFSYYa6PGC/gh2wdworgkWdzJkgdx9E7mrSmXoGiKPm5CAUsd/47UD604pm916HyguB5Cm2fe6S+Mg56gqGvzUYYzK9kY/mE1rkTuqSQe5A9TpBaiYfVDPqF8mZpfYQHgLRHFMgH8xbLrHBKuTB8nqiaEGQgkYZgDHVKMaWHyCsjjUOEVA4oplJk1VlghV3p7sZKtA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
blocks, reducing both PTE setup and TLB flush iterations.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 arch/arm64/include/asm/vmalloc.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
index 4ec1acd3c1b34..7d9c7dc795c42 100644
--- a/arch/arm64/include/asm/vmalloc.h
+++ b/arch/arm64/include/asm/vmalloc.h
@@ -23,6 +23,8 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 						unsigned long end, u64 pfn,
 						unsigned int max_page_shift)
 {
+	unsigned long size;
+
 	/*
 	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
 	 * aligned in both virtual and physical space, then we can pte-map the
@@ -40,7 +42,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
 		return PAGE_SIZE;
 
-	return CONT_PTE_SIZE;
+	size = min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
+	size = rounddown_pow_of_two(size);
+	return size;
 }
 
 #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
-- 
2.34.1


