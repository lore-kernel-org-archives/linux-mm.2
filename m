Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 031DACCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 03:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEB306B009F; Thu, 15 Oct 2026 23:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2686B00A0; Thu, 15 Oct 2026 23:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8AD6B00A1; Thu, 15 Oct 2026 23:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8C996B009F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:10:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B1A38028D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:10:31 +0000 (UTC)
X-FDA: 85327011462.05.23C7FE8
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4FC8880006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:10:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rGsj3NLC;
	spf=pass (imf30.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792120229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EXuyqgfiF9x7HO7+fbFxeGIrd5nFUV6QECR0sZa4nrg=;
	b=19UnX5sfy9dyZ0s/LFe1+7qB/B9CFs0xyv0X13556qHq5xHT7Q/WWYkOkFDXZygDMGro0h
	MfABtUVLXRg4n8vjqvlv92AGgV0xcG++YQLMxSjCEQU6hQ24mZm8drDSHbhntOb6pW7Her
	o6B0CPDQTdImMnI2aHN503lQ3C2QMF4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792120229;
	b=yJlOo42RzVohOW97svilozz/jArxe7oQLkuG2Skvvuc+ZwWGoEvqzmMY8x+CJBq/53B3Qh
	iVNAMyQ1OHv0IZy3+ldMIWqyPSS0vT3gkySjqMrk1ndA9zOnMK0g6pk/uJNWy48vKHCIdW
	PfroaUVyk/PuLd5iu/cdMu1+TR62Tr4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rGsj3NLC;
	spf=pass (imf30.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-39569e136f9so1779515a91.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792120228; x=1792725028; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EXuyqgfiF9x7HO7+fbFxeGIrd5nFUV6QECR0sZa4nrg=;
        b=rGsj3NLCcaavwZ5coOgjlP+7Ss5ETWIChq241w7xISfFK1xmqj0R9/LbrPgjwlpXCP
         KBQ5ZILY/faTsgNMoJQG8D+bydMd82xHZ5BTMGd6SHlbzs50klGCHbG3cqm1J942bOJh
         czvk5InReHzcjzbL0lyRl17ELX54vM1J13TBQeKMkHHPNLQgn14nt4fIBmSA4eWSyAlZ
         czXhvcH+VOaFOVV6nBhbpd9S9ok21VIk5StPUBeRMMu26d4Q6fANo5OQF7wDj29xQhIZ
         +leT+L1+vBfFdHuOuqQbBfi6/RzySGA0mcCW+oReSLU+QoSq5ckfWuDvGECxEP4y1vFb
         9Mzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120228; x=1792725028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EXuyqgfiF9x7HO7+fbFxeGIrd5nFUV6QECR0sZa4nrg=;
        b=Kcdnn1BcZNhDvmZJdczS4OV7xWbXXPK6Z8jRmOXMNgQxFyU6ipxyTysqSORpyKpdnN
         zOqDmikTwPi7XjxJ425pXGEBZ+lMKO9g+6h+sKAHr+O9PUc9PB4fzZ+04LM6gbI7Jyco
         dg9CFAlT3g/h61pW5zaHPfjd9IClcLVdpr8orkUugm8PNhEEzaIt3jfzA95LdfKwHMqO
         B8y6CEcYLOma5T7Mku/QuJOdwned+WkrqXhArNhMGNHq7uA6gGcyiMLH8uhHjWFHMZGt
         pehPmqHZpTXSSpcyF25nqvbKwlsaM5iexNoStNrqY7vs85jdrEXvbu85vTdpd0DoF9so
         yz2A==
X-Forwarded-Encrypted: i=1; AKwUvBy5yikfYkVN/O3+JOkcuLwBhlyTthd0lxDVOFaY6JDktooqP+T3w//gVrR+5esr0bVY8w2drsBsjw==@kvack.org
X-Gm-Message-State: AFq9FYIOKgHUctFcguDRyAokeGVrpX6H1Wig5bRhwiU7xFYyiNYEUggC
	XAW/XplWZcviDQL8TI3N7wCBaizMdL0AYvM5zzsro4QTp8G5FYtwwkD2
X-Gm-Gg: AYBFou16vyojJ1kBYmT6HKkvZ2ktXePzcPTcEavrqRezXuMpYol7UUQd7hyP5BZEfcc
	PJuO5/6WMfSfNJmvkPH+6+LYchKW4EO4QXbCAf58zNrmA4IMoAWeJ/b/NoFYh228Ursc+bWR7ZJ
	mGdvchTvG2vd5dxgIxal1iL6DeXwRncAn7+lfPRGLBWHScUtq+Bp3G1Ah7wMBfcjiItWZCwmKVA
	id6dWv1YGd/ngCkoWq87osyDSUCcWEBfEzQvuauuTTFiUSKn26yYHSt7UtX/lTkNo9coKf3/j9Y
	2jtFvsupT8QgnBfQbsVKN8nm1aWruENeQQudV7e3neTo1z6CjsrEk37aK4xstsb+YhM4ZWSOybS
	IdDQEAFqGRFkhQeksxN70z6RHqiHjcKT4strzBfgPfXS1BuFxOsP6lw4OcZ6UGybFJqWOn83+M+
	U94gmoN1KXwNmYgQOXIc54crkaTpu2ogR0jXl/ZwVh0w7+P7XMJyWUipP9j5AqeNFxH7q3QLFKS
	JmUD7OrSyURzhUiFDYf1Q==
X-Received: by 2002:a17:90b:2d86:b0:3a7:d2b5:2e99 with SMTP id 98e67ed59e1d1-3ab3a60d1eamr16967413a91.20.1792120228159;
        Thu, 15 Oct 2026 20:10:28 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd3cc73c7sm370085a91.4.2026.10.15.20.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:10:27 -0700 (PDT)
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
Subject: [PATCH v8 6/8] of: reserved_mem: add dumpable flag to opt-in vmcore
Date: Fri, 16 Oct 2026 11:08:53 +0800
Message-ID: <20261016030855.4062882-7-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016030855.4062882-1-chenwandun1@gmail.com>
References: <20261016030855.4062882-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4FC8880006
X-Rspam-User: 
X-Stat-Signature: oxbu56ak9t3ae9e7z8yg58mi1ummwebe
X-HE-Tag: 1792120229-39176
X-HE-Meta: U2FsdGVkX1+QsZSujAbumYIalf1vkL9pejJBVtxMc4FOLqJBxMWpfPUYwVKnZddH5YWzAEfr8SPOgEjMDUuh4rWCs/t0384SlaF4N97cN/58mIx09mr27d1xS8OrYS1bqUjRpRQR9YSHI0fko5b5a5T1Cha1e7kDZG3Oj8HAl0a7E1k2rhjdSzFiMBzK4Fxpm2bSzJ3fGBk1BA95C8RufeVxrPk9RxsgZfFXq5c7QcS6pz2jrvpZtr092wjcrQkA+BuVhIzlyNEDnfcm4/E93d9TPF7cG2VoPJmXeE7XQRVThp8PPtpHo/NauFHSb5C5IM8O0hLWLCspky2Ousls84Vf0mLwnLLNO+pcIT207TQ9pt/laBLb388vRk2OGUxM7EMfgkwa5gz+cFa0HeDCNZfXKr0mjf1FB88EYgCePwO6DDbOFVhsMHZnOXaH+0ELfvzqza/sVaRVzzvvVUWMiFIzcLpg3sQMaSasfp4y47tWH46/s47kasHMCMMBhnQ5jY/ScMbMKywTfS0f6sP+xhp8y52WL9TVG3yJ65Ue/tUQ4rqLcpDG3xThwcGeWNfi+kyZN2bEh/1CVC3seP1l4UNSnaAm2ZqsfoUM/LMZOOXmP1N/dSk3j1tDpoCZibP8lySynrI6q5A6/RGKH+2N8Pz1HhCozF4NTJdP1F0QV3UtPY/AWj6R0mmGIueAVOxXHzywuAZ434yQdjGiuTo1105G4pDJwFNKjRX21S1zL5acUBvfT8no0V4cDxwk0TyxYPiMaBit2guFMsZhHaTL4bRWpc0Cp6IdM2LN656tEQGl4Rbm48rCbXh3kM53LnIQ4xVsxWAiNsm9DBk17AZWDYyzj0tOvf2n7VNW36yR/IpqIt985Uil89zKrVhGiSTZ0qwrM47nWd3QwJZ/vySRuHyGbM6ttGZeWVAHgmXGDPRXTKOzUYJ7XeRqRbCexmNqyBiLnFm9nu4eWTrbCy0
 RgruQv1V
 KvtvsPQMgc+kF6Jb83jMTnd7wOpqNg24+4WW9f8C2CfEmlgZK1p1Dg/KF3sLk//bfIgzRBRu6taWLi/wabwpFbKVP2EONRMSP0gjsXItNj+dA9SzjoZJbttdTjo9gCz6O7PfAdJDyxRLeMjAt4HSFjIQMQy2c9Zk+x0RctWMwZazudEfX/kbZHaUKrxnFKnZPo+Cut/xgmAFbVo4LVdDyDTRr3W95TEZfpWqjBlGZc/yk7pA14GpNLRcz/V/PnmEgy6t/gsJgqQPJKZ2JJ0UlhFlOpN9K56cL0Jnx/SINR9+482qFhcPXpiYr3z+sdN+S6im+5Q52Rx4nFnE6RjU5vwiNCzTaBaLFJGEMJqz3P4leaRvIXPLDsPjUm74cojmmVytox5OaJ3oJ940GTwdGbc8cQTVnNb0w9bLBxv5SLbHS2PgZmE7nHHZU5NQETJSMHjSDHCtppfqwVIyOGA3pymDeB8b4N/j+ofmLnzFA5o1XX3sqNl9QSa46nFIrPEuN2n/qsD6U0yslANcaQbphPr57kARs9/sDHTHC
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


