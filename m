Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15EEFC98309
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:29:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 196736B009B; Wed, 23 Sep 2026 02:29:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 146896B009D; Wed, 23 Sep 2026 02:29:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0350A6B009E; Wed, 23 Sep 2026 02:29:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C642B6B009B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:29:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59B57A070D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:29:05 +0000 (UTC)
X-FDA: 85244049450.28.5B7CE57
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8218118000C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:29:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="oXHdGAu/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790144943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OYZzRE39rM1i8Kn24WfXB8ZLiPdAdycC2kyj5f6F4So=;
	b=QjixQN0N+YjRPpUo0UaJ4Gh18VCicB9tRPRHyZ9fpaht0i0MN12Ewz+qVnVfi3JvS4evhh
	j1ZRxgHN6XCeznYJoJjxVW7wec/cPa1KhXJ54T9QuAldkhbEBoawJcouKt49jUtfxkRmGn
	RaR1+RDBNlErk0Xu6/niKjFc3luIRP0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="oXHdGAu/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790144943;
	b=LSiQp0FceTRzOWtMS32FpghkGM/Dp3YQW+sQKmAzLJ8CxE+5GxowsCweDBY0cU9JiP4Jdn
	gsyzLhiY3KOQJ/1c0b40k/zlY9OM7uJ3NF3STxt/zFRPEtzNnPtS9GLDikRsPKqTUhKm3t
	scKUsnAB0K2WpvDpunDmp45TPJbk0sU=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d9004a1ac0so2356335ad.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790144942; x=1790749742; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OYZzRE39rM1i8Kn24WfXB8ZLiPdAdycC2kyj5f6F4So=;
        b=oXHdGAu/6qmwZRYqlVw0p2zX/3t5oeps4xVHVOWAmQ7fClry/UprrxCg9vU3B7YyEJ
         OpQ/xogmJElw7xljwBK2BtLpNdE475ii6TA/bgimEBcrjVD0Shq5SAW47qUyYWvIAaK5
         YqPWwiEIrZlTpBb617OSMc9l5YUfOCPlwmuRG3JAbqQldOtzPw0JJYvqP6DoDaT+LsjP
         Xi55jsm3OIkk6VKf7+USQrWuvDRbSX9f+SPOGqK9p5gg2ffUBxd0UM4g9gDhPE0pLax4
         u2mqsXm2yiIpPFridrOmkNdX+k4FZE5fKgDwAbOdqbjaho/N78jEdivoo7AJHg33KnVp
         5YJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790144942; x=1790749742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OYZzRE39rM1i8Kn24WfXB8ZLiPdAdycC2kyj5f6F4So=;
        b=WLrWGca+scojyoUlCgaIkF/wIRnwqGuORjnn5VV8UhJuZzPoKoFJKsRy1QRDuW+QNV
         TH4PUazR1quYCA9dPfq4CWKoQODUA5yb4wBGp3qiUOGJLT1sHpJtLNjNokKvQO5og8Pc
         /4aKCDAjlp0GNIBSS57ifXvcQIg8LTWQYrytldXunl8L11fx62ksGmWqaO1Jl9V7exxX
         FwOXfV/yvQcDhnlYwEtTuSF5V0I1McpZODCHvqsVsZtNXafCyHcjGve+uRYF0Bw1oZpZ
         fxDkkphj1CvNtKvuDRaQCfEWMZwhPfUmwJyG2lLG/58Rp1tJb2V/7jtu/yg9lXZnjgIG
         asHQ==
X-Forwarded-Encrypted: i=1; AKwUvBxEXvKvfR56DU4JS+0s4aZ+qVAxigVz3hrIE93M467G18wnghRKrLnwIHISvWit0JyLbu7sziVShA==@kvack.org
X-Gm-Message-State: AFuF++lQGo8VmtV2jux6r2rIMZ0cu8+UN3mAVoD2XUhtV0v4Bp7gpaTi
	oeKUbotRn+OtCbgpMKihpVu/piFCdoWTe9+gcH060VeWavZP9T2qCTqv
X-Gm-Gg: AYBFou1+eNF6vKcYqq4xbZLMFWOn1WH6uWXdVn9fgjY+mrlEZMlHmaBZCHY2fJb3muG
	e7/nU9qHnWBuqkH5grI8glSCfj17XXSLrDhc/41mmOh1YN5dehoXAZ4e4lNo81BF+XxNjxCGiu3
	LBUbj8QTjkez1Vi3FLO6SKUCWX+h2+mPRxalQxcTI4YSpmNNlmUUGrWRDCH6AkQznc2dsDVgyyO
	Vmrof0ECdO1d7Bb/SN1ALyCSs9njjYnCyGHcE55gIoQbTui/Io3u3FZIJ6SP5huaZZpeM8WLedM
	1GFIHA8CWqww0rR1CJcGmP2rfI4Rzcd+8uF5azqv/gLs1+1104MQ2rgk+CUl4wFiZ+udKwhPbGS
	mxlpJukqfJhP3cbma7KMrmENRDwGjCIDQjWrjvFpRWuhdaksguqSN9bEzvDMgXvYZQtCkijY2ZR
	nb8BMbjPMZ8MqyLwnh3wOOR3qn0+BJvO1/4NUvtPhatmAuU6ECwHasOEwl8koKuAnpi0FoORoBj
	XwkmHuAZ4jYUqAg2fhWOII=
X-Received: by 2002:a17:903:2350:b0:2db:31d5:1448 with SMTP id d9443c01a7336-2df69d689a1mr14297125ad.22.1790144942400;
        Tue, 22 Sep 2026 23:29:02 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a516bfdsm5620465ad.5.2026.09.22.23.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 23:29:01 -0700 (PDT)
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
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v9 04/10] arm64/hugetlb: drop the init_mm special case in clear_flush()
Date: Wed, 23 Sep 2026 14:28:26 +0800
Message-Id: <20260923062832.479455-5-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923062832.479455-1-jiangwen6@xiaomi.com>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pyzki9j3rosxepyuigfso57moqrmipp3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8218118000C
X-HE-Tag: 1790144943-606671
X-HE-Meta: U2FsdGVkX1+7W1OInGlhDVgcQPZGsLUjhijY5XJxB4cFEyCsYAXVQSYR9rGcAFPTqvpaIv+v7Rmpwp7IiPt93NsZxa06xZOedEMVVJBUhygWDLui3th+I8OR9V48EjYy9LkN2S4wbKhW8Tc6e7+dDGtHY0gQa5GG0DlvPrD2QjdbvikudX/5gojW08lV2iepdQ0vPhBqiXrBFmEWDcIoZ5yRPF2cMhFi2CWF45xK0/RGYBnUlI1r5QUEatxL8EAIBg5RJjYSRFOoYoxnL4PymU16fKQfE6BnWvm9x7PH4ssJFJa2so+r+OPR0cItOZYnDFkfhc10/B5un24li9TWcaAlBq7yrPTh3AL13t/gOdCrwZlrNgb+45Y1XS9lxQrEf53CyfgyO7gz91pZXusRm0sRFJ6zEf80VLQ05UhjfzCGOgcXLrZoUWb9k1Blealfqjk2nJPbfqqO600xy5k2NZCLSRITVO/RQoKpG6G0JvpvDqO3/4HpBJ1IbN0ADltjpown1b1dFsxiu+PF8Yo4UKdHVV/Ppqwv5/5dGEM8dYVqVQHSAWx8OA4lQBIMG3V9RHdsJx5Go0DNuESwxiw1x9AmyfdAltgeiUJnoctcosBkKQ4Y/Tf4zAgbf9RnqbOhaTrK8oDGtgy4LOhR4oflxIW9DdSXZ/+bu4dWhZr8H44orvIZi/4TNoP7V6ANvxABYHSJj/zphxdVPrZYuE7xgHXYVvL7qGRRcaJ7hfwZ+pEZxVhMuokm2Qtx6X1y4CiMUJ2+guXje1zJaO4sz4Hos3C4yFPJzK44CI3+Iok6efeX1jWIxXbOiSvAY1uL3K8gHouqForAO8W1+9IrBbvkC1iIKWIUmeWlPeeqwznF5zLHOdkr3IWU3GLVJr3BSjLpZCSMWS6cuodxXkbT7xwvRvxQJbZBUMy7McCMvkFN04RFDOJYm9tQIqErnKdcRBswp5CIIgxNKmT8h/SEbQa
 gOooYkFw
 AiM3sP+jzHaZvicXxwb1ahgsNzX2a/JDyL1D91IhZ5ba7OY78Zc1Vg/x2IDZYSOGBK9oI7MtGU/NFS1eX5l3A9nZUU59XHnRMRLvgjK4ivM7/EhfXST/cEnaOsC1TlBy/Gzr/gvLcAlCh0PXTkpCnQXE3P3IS6NYZ/+8eXc89TCJ1XLpenxudXPKwd1It6yX3dYrBz7Ane5/0tAxxkne7RMeRbahDmm9LQVOjNy33PuvtCzukcVpPpIUcxkI5QoISsCsL18x92pDSvLYVkO9O0NUjcIYeSZNeKmkWqloSdlSF4aYfNoNjI6UuuPw9zQC9GWSWl0TARCXpGt3ruA1BGIz3694PdlmtOt9ZT4ruQEVQ2CQ+JXdGoIwgivr78ONes4A33YUMyBUnn4hOp8dKNznZrPZsQqIhpdtREnz4nQW6jJ6VFCoVVbXhS972kE0M3zYz1f81UM/H1JU+jum8/YB9GZBbBBMkuEWRFUkA0tnsSQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

clear_flush() calls flush_tlb_kernel_range() when mm is &init_mm. This
was added by commit 06fc959fcff7 ("arm64/mm: Support huge pte-mapped
pages in vmap") because vmap called set_huge_pte_at(&init_mm, ...).

Now that vmap uses pte_set_huge()/pte_clear_huge(), mm/vmalloc.c is no
longer a caller of set_huge_pte_at() on arm64. The only remaining
callers passing &init_mm are in arch/powerpc, which uses its own
implementation. Remove the dead branch.

No functional change.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
---
 arch/arm64/mm/hugetlbpage.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 8e799c1fe0aa6..ce247b06fe03d 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -206,10 +206,7 @@ static void clear_flush(struct mm_struct *mm,
 	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
 		__ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
 
-	if (mm == &init_mm)
-		flush_tlb_kernel_range(saddr, addr);
-	else
-		__flush_hugetlb_tlb_range(&vma, saddr, addr, pgsize, TLBF_NOWALKCACHE);
+	__flush_hugetlb_tlb_range(&vma, saddr, addr, pgsize, TLBF_NOWALKCACHE);
 }
 
 void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
-- 
2.34.1


