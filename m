Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB675C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD3F6B009D; Thu, 17 Sep 2026 01:30:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 187356B009E; Thu, 17 Sep 2026 01:30:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09E156B009F; Thu, 17 Sep 2026 01:30:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E41B96B009D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:30:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7371780234
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:30:14 +0000 (UTC)
X-FDA: 85222128348.21.C90E910
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf01.hostedemail.com (Postfix) with ESMTP id 923B84000C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:30:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ULTvPNJI;
	spf=pass (imf01.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789623012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ynKYarepbWl9Bt2lXEeL1/lRyqq80+H1joWy3Adf4T8=;
	b=0iKSSiH3iPJd+ptgtrTurEzu1zcs/5XFhHW+EHWIfuV9Gso3to+TyTEKT+K1W2A+7ArsTb
	jxlqZhUSt1pvjQfv/y86Uor5HrTNuoI+8AUMfpGRWoxT6qMzmwyI53bPAeI5TaGF0EGU8E
	l7XFtRlZ6ovkAC88PMRw1qWaB3pYTT8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ULTvPNJI;
	spf=pass (imf01.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789623012;
	b=O5U5P1zLRpQYDRtTD4qFrAuDZZiPdf33cAIPHaHw2s5dNmly4Gnz0mHG9LyZBnQqHPX47g
	p/lVK5EI5YUWDcSXJAC7X/t3YqpI6ABn52WD3PlbX8F54buvVTHIMwFBum8j2DFiGab5Pd
	DFDDJUtxBH+G6gCWX9oz1lcxUKW1xqg=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747eb79f7so3209835ad.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789623011; x=1790227811; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ynKYarepbWl9Bt2lXEeL1/lRyqq80+H1joWy3Adf4T8=;
        b=ULTvPNJIshTLbDbRqgRdPy4VmnTyHYkvs6MtRE99tX2kBsXZC6dqUaFxX98gZp1u6P
         7tqPgM8oUUOovQNXpQkFprBASQVqYYcdYQUGKFjdzonMSKLDqO03RIMrTu1Ym2OnBTze
         6o4FjOYxkeQpMUR80BkrxNPTK3/leSSZRt33YjjtcaoED/LSUQCvowl28WEYK8QWHWoq
         qo3HAF5ZlGK3eNV97CJusUZiO54LQs4lQwMTF7TfPWyH7bquet+c9WTQdZBlv6GcchoG
         4EHaYF6KwcBiRAx8Y5gKPq3Drl0EypTxEeVzMkKKrdI3gGBLpUYt13K3HzFS+uMA9kun
         3Q2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789623011; x=1790227811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ynKYarepbWl9Bt2lXEeL1/lRyqq80+H1joWy3Adf4T8=;
        b=po6Eks4eNt6DJc3dPxm+UzcHnrsvcvNgOV7WC6FxclvKtMUDKjPRMN+tgFj1E3RKMB
         nYK2qkKhIHEhbMYMrwA6bSeJjO5At2FWmIXk/zGTFf7f6c/AAm5Ojb9T/XhmY0Z5L4p7
         Yw5Bsbvg1fzC+dGYrvs2YroxqTi2hXrauyaRCVLiDCrZCWOBoIBlykPHfXzDetpZS1WS
         GLIF91mCCIsBsHUALkOZq1NXGQtikIQZjzOfZmuGVDtxede21/qNaldmd+9n+bbzGVSz
         p56QDKjAW9cZHVEX8hazVc3yfXHS9B9jEM0CnRVn5zJ9pdD6HFdrhPKVHwDFOmkWmI92
         c/zQ==
X-Forwarded-Encrypted: i=1; AKwUvBx8gWDRQ/KHb2tP6v1uaBkZElYGeblQBVGUooY3KNNVNCJsvV5khZP/Q+CwJuqy8IBesYW+6MFktg==@kvack.org
X-Gm-Message-State: AFuF++n5yLwk4MO/nU2u/FXJBVMBJrH76UPeUa5RzBTKzR2A0rNAgf+b
	CP3StdRBEv+n+6sBNwwXjktNrutu2zzxtkzPZJqu6kztjfo9Bes5NmwB
X-Gm-Gg: AYBFou1s9klmjEACa4mGEDwKO8AJViepjWab2PuB8DefmOeQSJPHKJNgPkilSI9Hzm8
	qOraUDLbJdoMUsMFYhjyZKy+fZoppxaE60TiPqKreTP2AYZweYTJaMIM9Qpj4XkvX8L6INmxBqv
	C2NaA50xtNsGQPNMOywjn60h+o0N6C6m5UqfO4gjiIIl6VfOCqHxFZQihpM8ekypjXdmS2ZbPzA
	vV6m52XfxiCCITWtD9skuL5z3hlMukWq8DggRZ/z3IaE+JOBNpeiht/nhCeS5vhhvdAb3lyPIcA
	FUBeHZAWK5Jxvk7TwpmqvH7wk/PyZXUGjv13MjSHroz7Hb9OEqZxHZXLCtmCjtfJPOReQhni1Ow
	dyvEoO1J7GaorxDjLfXsAd5OhMncEfRMrI8yv16EHlUres/d7VCvQkRTpciOkNP3+fL9FyMBZM9
	uZzs7FpjirCLXiX9E5Fz6r5SVLJHmp0UQDD3OeqwJSUgr8rUK8ljpSMn3NKC2pXYkD0SIr8xIf6
	3BVhY6+bKV6qSrcZO7Gyc+fzok=
X-Received: by 2002:a17:90b:2803:b0:39d:ef3e:9035 with SMTP id 98e67ed59e1d1-39e1e324463mr17718864a91.10.1789623011402;
        Wed, 16 Sep 2026 22:30:11 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e3abada87sm1955836a91.14.2026.09.16.22.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 22:30:10 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
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
Subject: [PATCH v8 04/10] arm64/hugetlb: drop the init_mm special case in clear_flush()
Date: Thu, 17 Sep 2026 13:29:27 +0800
Message-Id: <20260917052933.188679-5-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 923B84000C
X-Stat-Signature: ttdr71633t9wicracpur7umkbm4b8g95
X-Rspam-User: 
X-HE-Tag: 1789623012-911143
X-HE-Meta: U2FsdGVkX19ZrOq682cRAoUQoXNun4JqSuarTynGoppMDbrCdlhMoVRdh9zOEfu7wVsS0V3c/arXIzGXRutMP/9PItZsV6AymwGkxiO2Hd3zSaAZYVqxskfQSQA7V5DsWXslb5NN5ctFg32FxbTGZYgWjRN22GLcJmRwPLZHcqMOqrb6PQb3G+j5aCfP2tl0E2sBnclRKiKBhOTTj4Co2DZfY4joTIyNPkS5N41wJADupmA8ZLw4MG2GTBNXOTwBQ1nex/d9Qhfie9jF0SJzJYMQCpu3SjqqspTChCCgw29nTX9+9VUbtosKrp41gZlyLyye6iztdGSW6Pw/d+4E6rnNiP+PeWq3r+dRuu+lrAzoF67liXtpkdzGsChkomaP97HFGbYSSmpsFCvThZrhzsPEu+Seu05uqUdnuWaCPzCmkmpT25KscB2eAA75CKOYBJ6AGWojo+qyzvTpdd7D4lqfObB/6bUzRk/B9mP2YsuSIYhfirg1ofMmAxNXfRPEcWqv4jZ1agvd5/ovZSOzSGTLxqoyLilzFYXMibmj+8V3YXeMBxS+bNZEehp5r6NgtpxiYgFS4gMfw5Gr+bbjxMor/VRHs+EiO4BxrMYPt3IooLTakF5l5Z17mNndgnjnEUN0cI85xnRyA/w5AcaJJpQMUvt5e/56zYT/rYOJo4CUd9yWhaXOLCJj2wkS6ZvJM97SJb97jDiRUx7rRdFAbFGSyfgfE9qQh/xe2/JQTH6IEOSdGyoT6DhlSzaYS7FiedtP6ikiMy9DA+1zm+gOBG37Lgjosk/pafKZZRlVYPoF2QkQDzAc1w51DNrEScaN+h/X8nPYi9kuntuskHHfc6REe20QmgKQGgUMqKm1ckeuB9uW+k3GARg0MvX4TLve8g1zy3zn4KOxIFRpqEFw7bT2soVoYMmdQtmznCI760a3HuwMkJPG0vtIieYoNvx3EPfoxEuI7rph7nER3By
 IYhX5Fdn
 1fSZ1Ed1z9eGffmYR90FXhWtQYW0K0et8qCx90c+8F6T9bBbh9aSidvC+IU3pNzXmDgM8X1FQ94wwPuO25GWye35R8Vn1cD9R7ZFf6e3iXrBd+SVZ2CdyG37cda0tPvQOVqT22q4DXx042VNFBMRxANbQxH+1Ev21s5e/F/b5F5hY61FeUi5GW7uzkcHUJdjN6tHLe4IEAx3O4wQHA/FfS0DTnaGollno4BxTE+F59FHXd8f4ZBkHSQg1wm43nX1ThlOQbQN4or/CAsELdyn12bZuBGxnrhBlqxbK61aNXpj8ScCQ2KvqlZl/0veSuIm1pi/7/+yiZpj1i6114eV+901CrGsC8NrujwdSiEogUv7gEOwjoN2qI22FrgpDtgD75zyB/d61BR/zPOPHFBANgFsccMmmRNOmlWwP0xC+1+qUUdDFy1gYb2WAR2l391X4a57xv0EIM0r/CJQ+4IsJJxe9ZQNuhjA+7GpUTqQwp4YMr/SFuf0h6eA4CT8qN34Izif5zBitAZKlxx97l+KQtb8hgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wen Jiang <jiangwen6@xiaomi.com>

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


