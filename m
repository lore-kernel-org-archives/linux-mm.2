Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0411606A32E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 13:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QgzofAw1
Received: by kanga.kvack.org (Postfix)
	id C707F6B05B6; Sat,  7 Nov 2026 08:50:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47A86B05B7; Sat,  7 Nov 2026 08:50:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5E096B05B8; Sat,  7 Nov 2026 08:50:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9092A6B05B6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:50:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 250FE160315
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:50:31 +0000 (UTC)
X-FDA: 85408457862.11.8322DB5
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5783EC0004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:50:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QgzofAw1;
	spf=pass (imf10.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794059429;
	b=rbwm2TEcL+rZU4AshDuPnEDX9CY7NEa7pGfVYPBAYV3H1nrCMU83CvoFn/nTs80G/GCXz3
	ZHpq6EyIraExkoYxBgwLrEx69S+jUDao9SaGRaB6Kblt3qSjSRtAYBs8VBZdlwLg4tBHF7
	XShrMQ1E0dipcnuy182CC2acjArKyLw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QgzofAw1;
	spf=pass (imf10.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794059429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Af7cKlFoogk/50NAo6rFkgmdxcBnIE+i0cwBb3cAFcE=;
	b=p5GSjx9TaHFiTjDgHxAlhC5wKS2kBTq+LRLMrEtYPIIKBHTbPMQTlLq4KA0/kHGeQ+0mf5
	QYX11oGJ7pTedrnnLHvrnxnYbsKoxAj2g3TARzl4+y0CSfp2+pOoFOv8kYjSljk1f5Yxj/
	ejttCatbi+SHR6f0y9Tg4FscRTm6B78=
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-36fb88ea38cso645157eec.1
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 05:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794059428; x=1794664228; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Af7cKlFoogk/50NAo6rFkgmdxcBnIE+i0cwBb3cAFcE=;
        b=QgzofAw1dTvMmd2bSVR9y3jaUEFovvPVzfazBjmQtH9NfAYhXO0d8HcZVk8188QssR
         xZBbyCE1z5RJeU3jpyUlx5Q4ZePJAZydXj8XHO6sCCiLSBqj5l11rpXKreL2lKRDs059
         v6Mj2QqQkefwRzNpKbI1rMNhUhu+/7TW2CMKuxPrV8o4JJjEXyn45FIDKZef5fvcH99P
         s2bqSYwXUTwZGZCwksKxVAUKwmqUB+rrF5IApGTB878yReU0Ac9KE68IhoSKhzc3v2c3
         hj0gdqA6OkdYLfsQQCdL8iAQhB9XICDXTqBOO9QV1JfdkqItXBUcg1wYL9wktl7/YK0m
         b15w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794059428; x=1794664228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Af7cKlFoogk/50NAo6rFkgmdxcBnIE+i0cwBb3cAFcE=;
        b=bcGLkOHgZfIPjbKh0cacaq6s+Ldwfr9SYWPCujKUu6ksT/6BI5ieUWtauy0NQJILhx
         brf5abkwJV/OviEfM1GMmC8f6ZNdeqiSUs+LmITiYbQd6+3cNRBBQmlcxrN7fXtPanxV
         7kteHV2FHil79t7SLfK5/w4AsUycqGJe43aq2a9thuWU7Re3yGpJuHHn1ci494TY3O9Z
         3qMqP6m7EFZ6+4mXkMEWBE0+sxS3l3WDmzRUiZVhXtKM7lRsYJZtvOTfRjThctZos6KT
         ltxp0fBvmTmbFMYorHrrpb+QOR2ho3eHBwtCdKHumUZ8NNnhRTyM9Bi2onDy2Bupljpk
         8TdQ==
X-Forwarded-Encrypted: i=1; AKwUvBx+6MBi6PXthsus6N1oUr7EgQVXs1zkosJno55KMaNCSSGxYXcFr0l5RaLN6NQS/+R/7uthsREtvQ==@kvack.org
X-Gm-Message-State: APuU4Z+LHzGCUohkGxs+NBRsuXekcRVuZOipnCTpDS3Qowz6Ju420JYY
	xdJxorMl0qPaX+SvSCuedBhWXmai7pQvoICp4qW28n5AlMac0Vni7+Wy
X-Gm-Gg: AYBFou340oI1Vy7sQkVjerdbLjbNMONpP8LY2YWUi063kGNPyQ474OaMEdV86wIBoih
	apuCseF5ntWfxNglbcnWKfJH5gSPC8HrpkmpWTu12U7Hva26kwqibnlSWKnC4qlmH4feIlzvcL1
	5LBOmwB8RCR+hpab5FWi4TW2fTY57BB6/7cVN3zfolWcdw0scNhNc5cwcL/XnX+/+ZHSjPBRDJl
	1wDc9RQIwSNmMGfet9KXCKrjcfRMGjAR/YlxVlT17/bPlVVn4js1S7ZDTO65dv+Vjw9iZu3/kjw
	Q2ENfWHSIO4bo1LIXisqzpWg79+BU+nS2QuaEas0LyZ0jvkk+z3VJU7zRJsKckAB/PR4tll/42d
	f9actYfIlbiMFlTl2MKbg+B2xnty1yzlpP994kOGHkXbV7jTyrIrZILJr3GDOdguK1WhIZKdQuv
	982HINvc1OB3EzW0vMs/kffg/RcxKBUT8mAx0+zadeu8fro+mvvTDnofUcr2+uuzZr0my+35hUK
	cLCThyGOYv5HtxX34eH+ppSnvpPYmRbyFyUymHtblaW7q+jscvbQzk4emafc6ZFerQcWq7BrnBi
	ruyYp8f3KZ8xpndC9iW9Y7AINV7DNTVpWgwzOgednha0Ivk4Dq2aputCBg==
X-Received: by 2002:a05:7300:c00c:10b0:343:5f5f:eef0 with SMTP id 5a478bee46e88-370f7c856a4mr3702462eec.21.1794059427852;
        Sat, 07 Nov 2026 05:50:27 -0800 (PST)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa922c6c7sm21280820eec.10.2026.11.07.05.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 05:50:27 -0800 (PST)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	urezki@gmail.com,
	linux-mm@kvack.org
Cc: baohua@kernel.org,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	rppt@kernel.org,
	leo.yan@arm.com,
	xueyuan.chen21@gmail.com,
	chleroy@kernel.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ajd@linux.ibm.com,
	jiangwen6@xiaomi.com,
	jiangwenxiaomi@gmail.com,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v12 04/10] arm64/hugetlb: drop the init_mm special case in clear_flush()
Date: Sat,  7 Nov 2026 21:49:47 +0800
Message-Id: <20261107134953.748622-5-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
References: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xarxonpwwdbt6z8nwe985zcoy3dytr1y
X-Rspamd-Queue-Id: 5783EC0004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794059429-404396
X-HE-Meta: U2FsdGVkX1/wc1NyKBwYCI/btaXFlIyrBC7XVK0XLm3QGZVo9gXa9ZnWgpQL6ByKkhXPmlgkJ6ao4C6w1qouDrP08+JV5V2DGrV6UvhZgv5zOw0jUI174Qic4IzUxmmyqvaxWyg77MpLKhGAaF9D92of99rYiyNNUcuC45qZV0H6WfrIQLhyqN1uqVcPEzhzQfe69Pu80rBIr9xWD82Gx6yQE4yk2qSQ82Nfil7loVfjljYlZxb54R6XyRnf7a6zUaEfARvbFFnIngwYj+l3QhcD3yg0XhJ8ACFWnRVzI1t8fzEeW4yIlvTVeoQbjqHvXBcsUHCHU80+B4FAFB6tQypMVLFiczfIgdApWVSokHJd4cwZq9VtRWQEXoRgXWPwtfUoUWJqUUFz/DFsgyokExDL2pRwXpyPzGlGs4lwE7W1JlFyIQGuNq7C1HOR/E+nttePpm6Z7sXsw7j9QfVAxfBHOlA2hm5gX2VsINJUv9ikvQWHmbF2T0OQgxw/sWWPBclwLhjxmqY+SsqTzGn+mQeEdVTfywS70zRWMRZzp7DQoniVji/BeN+WKIWAK2CyAQd/K0BV4ayVtASVO5IHd3iQsLlBA+4VuhTodNea0kzHQOEQ5aFxeHe7gfQaK817uBNGm5wzRMeq17YWH/07SkI+S6shwJDPZVnV3qpVzDhPr/Bauw5VTmaUNht64KusOQjfrFOll+n7QfEOWELCZv3ZGUCO1lgfhpFAzt3vQIN7ERYBawlUZb2Z4FsZy7TD/tTgnQpIUkNa6LAIomyv9Zyn+HeKke+Us0b5tJiPT6RNVQUPGB/f/+M2iIBcP8fcBgwSltSzzyQ+1F+KqR0ThRaScZWz9o4nHXByBsZv8zygB8T0ZHKxgYf4JaekWGMohxhim6K7Llz2EPOiJK2JzEmvG2vL+/I3Ke0VC/CG8vSY/0AkHEFtJfVKUADQ2dT0mHS/uNhZtb2iHnFOz4d
 RXuJkZ02
 kTHZwmaO21iQKxu1bqYavbt5msAZFvwNGSqvMSPX7EcKUMg+RDcOM2an2T376fOiYVf55YGxiC4p6ZHPIABYO85b8436Wh4r1uJYXI67/EGZjqGYcBuJUhUu0u18GWTyic1zaGRXeei2OX0C04ijd2ZZcpL75zTmgXB1D6kluTRsjuC7PE05Z/+enxiplIAFpydTYjzKH/wy4TAh0LNae4GYRwfv5QgMhwecC879AM61ZSw5e5X0QYrha8sf09PB765N55kBNoHFTplkJcnleMiMrV0vbs59kFWstmZEyvNG1dfqNFxvhFvjStcq/hRiPjtAjWilKGXIL5hnJwNCbbvaba173nuKLQdZ5oRtXAMw8sug+aqVBCsg8YFm35Qsx93xPfxwhdy7gsIQb159cn7OfiDZ03f44HE7RMR+D8AATKWLvldvpy/J3xl/YGZx45j3qhdflysnMlgjozxLpTwJrH/CwksXS4erJ8imYr/DIFIwA/E8RrvEWg3G4xw2KmmUZIVQwN/sqSOaC/84pLhzHCm+5Zur8TfutrcZj357r8tWBUn+N1a7wUtpXXmSFeYuiUgM0e5j6mf549OTqt9FaONDjoMIJZVaMPpCM0LDdX6AMkccBV2LTGECU1JhR4pYr5WO2yhjX3PM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wen Jiang <jiangwen6@xiaomi.com>

clear_flush() calls flush_tlb_kernel_range() when mm is &init_mm. This
was added by commit 06fc959fcff7 ("arm64/mm: Support huge pte-mapped
pages in vmap") because vmap called set_huge_pte_at(&init_mm, ...).

Now that vmap uses vmap_pte_set_huge()/vmap_pte_clear_huge(),
mm/vmalloc.c is no longer a caller of set_huge_pte_at() on arm64. The
only remaining callers passing &init_mm are in arch/powerpc, which uses
its own implementation. Remove the dead branch.

No functional change.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
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


