Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F5A3CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46CF26B0095; Fri,  2 Oct 2026 05:10:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D156B0096; Fri,  2 Oct 2026 05:10:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30C046B0098; Fri,  2 Oct 2026 05:10:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3A3C6B0095
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:10:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 613751C3440
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:23 +0000 (UTC)
X-FDA: 85277115126.18.006F74C
Received: from mail-pj2-f40.google.com (mail-pj2-f40.google.com [74.125.227.168])
	by imf18.hostedemail.com (Postfix) with ESMTP id 869EC1C000B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PJAi6age;
	spf=pass (imf18.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790932221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nTdpftTlHppV79iqmYzW2DHPoEL/OonFlSGPOrnWHYM=;
	b=CIoyrmVM9NbbAxt57R5q1UWmEiDH343NVhJxD301kyuopu7WA5GBte10aLI1JIy3xtbuXx
	VUJBgi84NNpzR7mvZJuoGDtpgaUHK6hrdyDLdkMxioN+o6Fmclh7ku+/ysqTbDLdciIf3Q
	0f3naC/i7PoTOfX4RcnaLpEvLsxGVJ8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PJAi6age;
	spf=pass (imf18.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790932221;
	b=lF+QPBsOILxywCLNLlbr4L32E2h/2rM2/g9tWkWSk1cDkoFrJQD5kkXey8kaQFTNFUOkUE
	UkZzasmkWrNkIdYao2Xzt4TY+ANVXl71coiFVwF3/mK3/ygLfpRxD/oW1V5q202N4vjtAd
	ZpBHNb28sqVYrVnVS9G2FprVORqIUGc=
Received: by mail-pj2-f40.google.com with SMTP id d9443c01a7336-2e494adf48dso5937975ad.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 02:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790932220; x=1791537020; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nTdpftTlHppV79iqmYzW2DHPoEL/OonFlSGPOrnWHYM=;
        b=PJAi6agedPfLqiXyU8USCmMOLbr87+35xJTEE3UnPFWC3qf7BWDpIa1ggqxVHo/i5B
         GVEWDDeShBoOmdzyK71lo9+Y1cR2FGLPflvonL+UzA1h8xYuqdYzUK5S5ZD/dmMVSXCB
         k8HtaNDseBVdLG+Tgi6q53oz51vc71ExOJoU1bjazC2RQJ3rdF1eauI12+fmb51WAZhC
         8AjFfnbvL/sGPRq+2t04pL+GIbcwzXy2LsuuDJS/1oCZXHGH1uyV03pyJnFHqNXoLDNH
         GQCZg8rennXj0/uIgl0fR07cwq0XqiSfQGC7WvIed0Q8VDTNhf/Iu4fbX0AMtZprgKT/
         POpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790932220; x=1791537020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nTdpftTlHppV79iqmYzW2DHPoEL/OonFlSGPOrnWHYM=;
        b=MPCg43GX3z7LtqtJ0hsD6Ggf4+W+Wq5HHtrj7SLltAu3/FLSRCvE3r+aMNLFOzmvUt
         PRRvjlS3HrSxntimh3T++Bfrfg1bTBhffIB8vkP/ZIvHQOir0cOwFjXLQYkFrMYukXAT
         RsYETfMLrLR0VISAz9KXYSAzbcht1+yx8NL4SIxeYHLSnT/+9EpE64+LOVeDxjdx5gXF
         MnrhiJKZgxpAG3qbvx4QMd2IsbTwtjdbLHZef310Vzj50SdFAzz916w7HJuWf6Ee0v/D
         abnHQKoKEXCeKAQT45IhiEbwX3AnWlM+g314tJ1o2RHIaopfBqKJgsMfhmwyJbvimHHZ
         2DYg==
X-Forwarded-Encrypted: i=1; AKwUvBxF4gf48EjlsAwQbZxJ8TYOsbLHNDMnLAYL+PbyzGd7mQyjc2MLeGXLVVC1fMAJDzLSC66OMAyBvQ==@kvack.org
X-Gm-Message-State: AFq9FYI90z/yKLlWXNUsE1R2hpO+kPn4RiYaQlElSO1XsCVd0CHxx+FP
	T2varUjpIlvPKMCBLPA5pchZ/6R/SVUoLqk1eEyst5V+aoxCzxLXRdr7
X-Gm-Gg: AYBFou3QTJCDnLV8+PxBcgBluPFOaPFtpk/Gw7xRn/S1jygNT8yZjrMSBiiNsuQGs1C
	4o1W9yPRydDX43olCdWJBLYEPM+sEWj0cAuG2CN3lcpl3Qv66/JWMcCdoHEZpp9eHwm8yQTaukx
	fMm772icEhjVKMcfuygOIdfRIe+KumjiNS8+jiPhq2bTIgtEVdktW0K1mzmzjQ39shhvBCYCSbh
	YQcwpGonM49CN10AEJqy+3yrlJKvu8+0uN5uD84goqZ+uOZdbedD8p+iigCqcnKSvg8mPg4WHRm
	cugVpQhrIVXpZtvF/CZSZmW/NrtsKjZYllmELS2YwBi1vapsYaj0lAvaSfid2q+mL30o8kgqEpe
	eLn9DgjBnwkkaeYWwADTNr1pF/ik5V+Q7EcG5s0jrAfOvt9TzJPIxtxbaK/7x8Qp57ayHwk3Z1o
	HwMjWjbzNZAaiFNThR17EP6pZI9Wu5DnXuzQ1pMMbfS6Reg1kBeXvO48rr3wLmZzQpgvnKCyD3W
	l4p3yfU5Rj40FFWRsB1lg==
X-Received: by 2002:a17:902:e88e:b0:2e3:598:75d5 with SMTP id d9443c01a7336-2e49b6ad85fmr18169625ad.74.1790932220371;
        Fri, 02 Oct 2026 02:10:20 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49f6ab2b9sm5480555ad.36.2026.10.02.02.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 02:10:18 -0700 (PDT)
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
Subject: [PATCH v10 04/10] arm64/hugetlb: drop the init_mm special case in clear_flush()
Date: Fri,  2 Oct 2026 17:09:41 +0800
Message-Id: <20261002090947.869220-5-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002090947.869220-1-jiangwen6@xiaomi.com>
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 869EC1C000B
X-Stat-Signature: xjokugkboei5dkeak1howjrwozwmaoou
X-Rspam-User: 
X-HE-Tag: 1790932221-718171
X-HE-Meta: U2FsdGVkX1/bwykQitBDZQ3lRgymJK/UJZgsv7UVN02BqNjuu1Ab+hkxd4Hsc+noslrMcQvzN6y4N7enxfHCPSjHVdw8pfvK56Xz0QuyFVrKxCA2/Y5hMz/U+rWIncFqfVga5yNm/De0eH4daGYcMtd6z623+ZHNVdBs7wp3LluG8qiuR3o4vWAngfnQFlmba2u6/2l0V/VgDrdYYG6qsUVBPVwaQlTZrjEQhCeOOir6F40UzE7P4yf5qvdLCu4lOh38cwQnOBpqxb9r9HVbo12bQI1jxNrNHeyehZLxiuAJZSwmXtHgV8tN0SATJfVRXD9KDkPOfep9ZV1u9aQEXkQc4K/xD224xT3XeW+ISjkGXFtx1CmsUv4bKxXQ/dWyZ1icS9nSgwRQ4ITy20cuSWUaV2LSL/oTGT7vLmiGTvvT0z7TckVg1bdlc5lTjez4IaMpz5CW+Ji/JR45BDVF5iFFRV5lEfQLGGt89JNQqyh/k9HvXT13180QLxYsRHcko1JpgiKp3whlawr0JVwcm5SP71UfZxH5kTvIUWTP6PdTZX0pMVLgNql+x4uugcylt+4jwLdmZd6RIbP0RHRmdFywu75K0vSd+ucs19w2txhEoRYAA2G7Veal/atR9+EIaZWgRETHPLC5UlZRayt1QYLgy+UxuQRyuVLhFg5khvXJeMxoy/MsTquvxfx/yOPvhk4gz7IJd+Y2E4nWdqLmt1pniAWdT7ArTHtJ3ggyZk2+UNID94srH6b++4o+nRjr5C2S81/QWa3hc8Zjdcqs6ksvVU5BuBg454gvk9l9mXXU22EVCcgCI4clqf478XVGStaDDhbgkPjI2RBgDnevwWABV7b6PxJNZP59UomHTf1/PfPM33Eqg9HGywpexK94u1AQmgiwkN1whGkEf/XwcrnSwR/nG2SMlBAEk1kBr8yb8UAD0Ok095aIKhyiMVQ56QsnpEis91XaRQFCtZH
 dmNfMGR0
 kHePYr4J0aHyWh3roNAtgePxsJiiidVQv1y9X7aG/NlzF71uNCcBqP5fPRdch9r/BHamkyLpzmE22WnNR0quLw8ZSd7K/VcqWG6e57U5Vi2oq+77Tgte5mjh2GCkUrY75QMa2wYJGVfu3YOlLNBfEYZHBhBzfpW72iQpdrGnbbDpbmyBl/e/Jp1xFCbipZcv/d8ei4Ft+Xi+wOweB2FLR/LBRTL2qHRHqzAcZ1ZsBX8wsahGphCl3mgH36r87IImj9MVJ2MjO+DK+jY3l3//JE9MtXVRQi/fd89hhgGT/O2XkdaZ3wDBqazPZDfGVd7uhktxWm4ceMt5t/pFstUmnmz5206RWMz6VZ+0eHfo1L+W4Ap+LokxnfI2PnWEV8K86UXX7h8dQhSYrS+JxJBBnVTkJ3Btw+eB10y8s7OU4dY0t/aSSe1RimXWNeRcZDLIyekdgAf+s4H5AIebtutS8uvbT/hxWzqPkTp53BnSSuRhQ4rjzdQgHF0ZsLrnqRKGeE5K5JLsIPD2baik=
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
Reviewed-by: Barry Song <baohua@kernel.org>
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


