Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99BA2CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 06:17:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842356B009E; Fri, 16 Oct 2026 02:17:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81B806B009F; Fri, 16 Oct 2026 02:17:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708766B00A0; Fri, 16 Oct 2026 02:17:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41C6B6B009E
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:17:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D7711C32FD
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:17:23 +0000 (UTC)
X-FDA: 85327482366.14.03F1ED9
Received: from mail-pz2-f6.google.com (mail-pz2-f6.google.com [74.125.228.6])
	by imf20.hostedemail.com (Postfix) with ESMTP id CF7BD1C0009
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:17:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rXYzHBDa;
	spf=pass (imf20.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.6 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792131441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EXuyqgfiF9x7HO7+fbFxeGIrd5nFUV6QECR0sZa4nrg=;
	b=5gmW2hj1lqRA/bKVScfPrxf7Qc3pprpkO3b5XqCyR1luML1OD/2Yy1uwgRLKOjgiXnRrTd
	WscyDTHRoTdp452Fsp62haVf54Sm1OpZ/ktlyqTL7+oyz5/wH7ohx4k0TFjuA4lkkUb449
	8e0VbNPp9BnYDpICIvs1RFq84byZQss=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rXYzHBDa;
	spf=pass (imf20.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.6 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792131441;
	b=KIIQH0ikG0ROQEg9E9kOXheI3coAniCNFtGhLepIcDs7DXStlLhQbV9L3hGAxs4K+Aw3Li
	0d1WtrVjY+ygqG4ssqxtPWmNf8ufT69IsIprZy2YH5/9wJiy8p5+y1gp43T3wGmTStXbxY
	un8jUNURA79Kze9dVVzwEG0qe74w6MQ=
Received: by mail-pz2-f6.google.com with SMTP id 41be03b00d2f7-cd613507bd1so462349a12.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792131441; x=1792736241; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EXuyqgfiF9x7HO7+fbFxeGIrd5nFUV6QECR0sZa4nrg=;
        b=rXYzHBDaTGhejshZC2GPjkyqDJn2iAQhM0NNijeSmbr0k4iIyhDliWO1r59u7EZNa/
         WCzqIJYt7MSbvVBXCuMTCENhnKIVPTPD6QnGQTBxEUxstZTOyUjor5O3DCpQjF/fbE/F
         cGR+ZYqVR+1hkdKYtt1Xce1TaKfW2qwUm+ctUp28upgtG3AgUsOpBEK5WUrUilfqM5t2
         Mufu9QSdOYWQG58xZmyNNUjgdaVzqnss3k0oMrG2KRAC8+4/wxXP9uGqJ7vcQ1zsJNpZ
         Qw8yPGPA7w29i0JDJsh/8kNSY8fnPbaMhXA/IQQTabxxLIDvI81FzliLfw6EoPJ0ibpB
         x4Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792131441; x=1792736241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EXuyqgfiF9x7HO7+fbFxeGIrd5nFUV6QECR0sZa4nrg=;
        b=LytQDkwrSM1tepi5AR/ZCFuY+k/1MKm0sDFj5nf8vO6iuQwHU58EG8aHoNCKZbGuxR
         pLUxHrTvHCEHoZtuhyEDI6QkDMoaWNZOqEtRJYGeiQ2hM+gpMffIyxuW0kjGbQwfgA6b
         I+iSuO5wwKd37hrFizTLqR710qWEV9nFe49u8w9ywPwMpX2nktzvyPXF1QgTci9MK/vY
         WS6XgeK/CYn+BFy2JjBypDCw60TI7PVK5I0OaIBLsJWNuqJ21BHOXtikPpDSBg/PbSXc
         rRilr7dLl0JywXGElJK/FLbCVJpUkmu5+K8Qd5tD+X9FqeAe9CVzfgUe1eSofdazgucc
         KIyQ==
X-Forwarded-Encrypted: i=1; AKwUvBxdICi1hn0wyrm8jQKKKG4/W3jeaVG1QAj+3ILhZ9CboD6SXH+unQ9yCKiFHuImTI2ocDvuQEl97g==@kvack.org
X-Gm-Message-State: AFq9FYKasB6HgkXP8gqT6FDBjk4lGJk7AQyoUICNUrCf96E4if1Sx4a1
	N3V40QSaXVTu4qs8VcSXGZ5tDX6grSYL8rVfMplk7YRVjMMegA4OIibx
X-Gm-Gg: AYBFou1sR30Nu08uakAJtgSpCw9bYLnJ7WqS+fzkqfukw6jW2u/uR44UNLS4m0fDwG1
	+FrFPRm9k4pJdXmE7/qDcjTZ0lBK1+Xb9B5RsCxMYUUxIGW+2EjWqCUDOc/vakDnbFjPG02LKOB
	vnOhn8TCt+Hez0gd+QCzuHx80OoaLPOcrpPDfiy7kapdrkLUW15FLArXP+r5ieFcGniE3WAgCoP
	36aSmINLR4YVVnJfPnintsIB6Rli9E2PGBvOwAy/aByV+WmJFj32pwsf1ziqN/G5Ag+OXm5nbFW
	NI/7f7plLrKUUFew2KklqHvkQxAlYDN3/6tI1CzdPE92ip1k7gedqWVtpUUQ/XqfT9oeAai2ITI
	ZnbRNESnAeuvl4t534nFg4HuAEi6bxmMN6V18lNP0c9WQ0ksX5ETq702z4ExRrKREbSdc7Kfz0k
	RMrt/ti3XWkQrb0y0+/fK6r5unp9XUMh0W5r5W53P+AiFW5Kl0QwH46UIWnXAE+iSjdG+kXFVEG
	SVstxspMusvgD+FnIqy9w==
X-Received: by 2002:a05:6a21:1f8a:b0:3de:14ad:ae8a with SMTP id adf61e73a8af0-3e1d04198a7mr7196697637.16.1792131440647;
        Thu, 15 Oct 2026 23:17:20 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f57b334e6sm586375b3a.42.2026.10.15.23.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 23:17:20 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [RESEND PATCH v8 6/8] of: reserved_mem: add dumpable flag to opt-in vmcore
Date: Fri, 16 Oct 2026 14:15:47 +0800
Message-ID: <20261016061549.4181390-7-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016061549.4181390-1-chenwandun1@gmail.com>
References: <20261016061549.4181390-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CF7BD1C0009
X-Rspam-User: 
X-Stat-Signature: cm9a8d5gsz63a63yjk18uf976uq7ybhw
X-HE-Tag: 1792131441-101094
X-HE-Meta: U2FsdGVkX1+/CqTZ8aM9GkwNcLIe0/urbdf93Fl4kABZUkyLkWvzSqtWMgvsNeimpVGmO8HdTJmMszSyndR95YTdJ7FE+TCYlD4N+p32UeSQCbngB1RHXs8ns1b1HEqA6BD7FRPjtKhkiJR9+QblLKOgkNa6XTY/ncsnPnSI8ofYQiQeRxeFa55sN59g8b2YjSpa21t22mLdv8CV+xHY0ImA48MBlY5N1T81X85rGewdah3+f6wxWeTv8EXqgRnR3qCZgqrNRtRW022wzQTGAQTObw8MgRppxZ9Dlr4tjYFrAQM/G4ipXfhkh361eiqaCbbEDlvkMGnKTcNIas6kQEU7Yod26/A4U8Srlhe+rQq8ZyXYg5cXCAjLInVMI+qqAe6xEVmm89A9VWgNWxkItG0kiZIAhrWYVexM+a4IrfCNk+kc9nP3E8dhJfJaLvwkVv7sbDM5mkPLezVk0oEOgU21gncLiHWty2hje6yGwEDiIzGip8+HSVkkUCZ9ztAoYf1/lKXgq475GE2GdUzPYopLSgQBRyucXPKhtl5zthGCIquupHWae9W5UMzp+55sis3VORKFPIThfg7/Kmhn8ftHnkw+nG11zI0r1tBEe8Zj8MrliQDIoz2DhMP5B5pzPRlnap1dfDoaVWRCM/N5clAc7V1T+9qOKaUcQNTT1xK3rtQmfcOb9+CQ5+V0RcYQeodAmx4Yq4wbRP7U3H2ihb5K7C1Tb2ySnxo90tcvjgcJAE42+K3rIWMH/WZuuIaV3m8lgsdWFKmFQocnvT+VYvnHOI3yQIjApGTDil8VBEyIjzWa/ZTgofEg59OSV2eb4cQGp9cVzvaKHLBxRnODLXTJRVVIwY5I5Sd6LiT68b3omJUF87N1wHgYyPzasXUjIUP8ixjFWu4P6p89/3tDvpuVxTTtV6H/n3pFPH9Fntgi6HMAK9YH3xDJnQ6YvY13FYNqEOqgEdFuxyAHI8v
 CF9vt8Cw
 oqfUEsQ7w6u4AESK5XHXszr95UbBzykp5H91gwEBEPlA1V7kpQxgxT4uH95f+EpPOQF3Id9qACyRdGIUSuKigvWTyH9tJ8lWdQig45ISyr4f7uIiJbnhQ4JTQIrHHur43b87/itVle/mMfDd24X+10Yp5qBQ3yN01irydEYaU+cMdqQ2sVfll6NXsSwP8Rupw6JfvnoiuDRZ2/5nGf9ldSlXWzSV2ssqC3qx0GSNKag5DSAvJNKjyAvjjW5m7lWR7xYpVwA72V9/1VA+qqLg8rQjFrDvxcCYkRGjAbhDJEPfl8HlZp6EnZJli2zJV0z43xDSlPR5MTqx8tgmBnkaWR7lmsiYe9bSEv1xwW3i7BJGbuDUZv19pxOUrFzAR2ujdJzGvP9P+r7ZyGWbnWGI8Z2AusJlQ4q7z2VqopD46WA28j6IaYk9PRN5o9OhuiAk0q7jW+fOS9TtMKHijPf2BmxOcRm286iYhZv2OVz1a3ZtqfWG5gOhbDTHclrBaYmF1axc71mEVuoCDHTaj10PLZ4F2TGNSndBdl0X693h1yWGs+lbEqRTE6dHvJZUiViGRqYAlnhGUGMIOdpcKV035L+oltHd5B3rap49+Ly/vmuN0KAWtLDsutxyAQYoQczjxdGtqe4mZ8Wp6Ds+iB/+BW5m50OqEaluL4QRC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Add a 'dumpable' flag to struct reserved_mem to decide whether a
reserved area should be included in the kdump vmcore. Non-dumpable
regions are later marked MEMBLOCK_NODUMP; the filtering itself happens
in memblock, keeping the arch kdump code independent of the DT API.

Most reserved regions are owned by devices and do not contain data
useful for kernel crash analysis, so dumpable default to false.
Reusable CMA regions are different: their pages are handed back to the
buddy allocator and may contain key data for crash analysis, so set
dumpable to true in rmem_cma_setup().

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
---
 include/linux/of_reserved_mem.h | 1 +
 kernel/dma/contiguous.c         | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
index 49da515859f2..99c0f3ccc297 100644
--- a/include/linux/of_reserved_mem.h
+++ b/include/linux/of_reserved_mem.h
@@ -15,6 +15,7 @@ struct reserved_mem {
 	phys_addr_t			base;
 	phys_addr_t			size;
 	void				*priv;
+	bool				dumpable;
 };
 
 struct reserved_mem_ops {
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 90937dc7c627..d7bfc38ac762 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -567,6 +567,7 @@ static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
 		dma_contiguous_default_area = cma;
 
 	rmem->priv = cma;
+	rmem->dumpable = true;
 
 	pr_info("Reserved memory: created CMA memory pool at %pa, size %ld MiB\n",
 		&rmem->base, (unsigned long)rmem->size / SZ_1M);
-- 
2.43.0


