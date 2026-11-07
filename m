Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E672E606A332
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 13:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SM0FBdcC
Received: by kanga.kvack.org (Postfix)
	id 1C2556B05B7; Sat,  7 Nov 2026 08:50:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19A4C6B05B8; Sat,  7 Nov 2026 08:50:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088AA6B05B9; Sat,  7 Nov 2026 08:50:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7F7C6B05B7
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:50:37 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78737A7EC8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:50:37 +0000 (UTC)
X-FDA: 85408458114.22.BBEF585
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 996FE20006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:50:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SM0FBdcC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794059435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LValEK7sCbZl9kgj7RilnfIodlMc9vaM8NFPGguTOMw=;
	b=LMFWeXikudCZYbcmaD7NLo3M/skilbcfqtQWeLJYt2E+fSCh7+C5QfKyLZ/4cG7oYLl0s1
	O48u32SVh+oFtD4eOP5u5wixhH+Nc6pJwB/j0VAQFQPkkB1CMidye0EwOMGZ5kPKEPxygW
	zHpYlio58pqeCBy5+W0aYs0tzccbdDg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SM0FBdcC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794059435;
	b=F7CVv0R7kQ4UmzPXUG+vQZs3LbdyStUr0Q3ciVLsX5dNJ4xahFFSLVccrvsXDXYq2s3yFu
	Y2bnI+WJK8hbPo/T/9JH0mRe7wpZSqy349Yx9RQ+hle/Ku7JUSETRf3sDK+ZNvWcRQacaR
	AMkPuFGz0DMpF5WeKhp6pq4a4QI8sW0=
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-36eb1cb7aabso2441851eec.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 05:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794059434; x=1794664234; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LValEK7sCbZl9kgj7RilnfIodlMc9vaM8NFPGguTOMw=;
        b=SM0FBdcCTZnYFwOZnJw9UNXzkFyrTg3EEHcQVCNRO0FJdH4GaiSWIHpzsBV0xWIIVh
         akhVX7Ai9qSBRqve2uMXikV2UNlhW7vNmoIp+J5fXxkGspb8fFe/CP4wmveTUT8xLaYl
         HDNT7qXsTmTmBxPyLmfFbHEVihNJU74ShjmLpHBcAwUFYUujMAM+r1wu/m/dVu1m8gVE
         kfhfaFEUt5aA9hReYTW2GHR3Cw48HtsRMtRw078ckiUOxvMtPUivcJ2h+Oy+uR6BLWjK
         1+MwRIIBxcg8CR+QjUNSHl3TUUYu9ml4gfnuVcHlf2rAP6I27BUT+gmiy5rH/dmdc0SK
         MJgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794059434; x=1794664234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LValEK7sCbZl9kgj7RilnfIodlMc9vaM8NFPGguTOMw=;
        b=25GvGsetsQ8hV5/niKUhPFnUGwZB6V3XsFC9wxZb6UmZtKoG9vViMRzGxdtUb/hMo8
         +EDZG8iwplNtqHmEIHXy42OMjotchxZyYJCp9OjSgcIUxCtVs18AMBbRdVH3pcdj1q/z
         apabNjwqq9Q03ZKv3R/sr7UR9Zu8MTAvyumHWRsS3Wy9vm/ptNJJBpC+C1+q4sQX698L
         OBdTRqti480xEyY6nEW9C0hY3jZ+CxyxSskWIx7ZGptnoW+k4AkrSQKnbdJvIq6J7cWo
         MwHTh7TO4IYQ1Hqa16TbS2tk7hpkVAhRNpuCFqko4NU/SynuR2nEZqLzdB3JgmVnxfph
         NaKQ==
X-Forwarded-Encrypted: i=1; AL+hErH1+0+IyYN63bM3snpUDiRU3OLoinsYtIE05Et5qmD7xDD8BNQVRQX/zokine8GrbI087bpsaW4AA==@kvack.org
X-Gm-Message-State: APuU4Z8dZdd2LLtg+DhPWZipO4lKXgSRSIppAZ6TC+4dHYvVfVIvE38s
	tglMsnvGQhjn1AWKpogBtr6sHopiLBg1MSpNk/xcFPMreZIJBq3Z0CTs
X-Gm-Gg: AYBFou1e+58lvxn6Q3kCr1it8UpV+VGwzNJp01Cg0IrTQvuXbJe0MmAVM5APhd2rS02
	moXWyR8V312raloBUNYOQZ+DkgZ7P9+xghFE2LvZ6QCp8A+VfPdkgEQYs3wJ2wGNm5bTd9Bz9Bv
	x/7HuSEs6uVVoBSuNcw30BXMMzVAH70npGu/qjZKdcv6/35IY5le+bK2PvVWQQiD2nBWbdbiuLv
	J+PqmKdwdHEt5PrlIhphsbXryRMBI6tX2sCBKNZ+a+sY8tWeEABFc8E217xK5vm5V8Xtgw3pQa4
	5U70F5yL7E9rnmbJ7DCa54rITcDc4okZwRvyNVAg+j0JRjKbCg/CDrYYCUxnaF+UXMV+bnzGbio
	YHI3kGzB2+CQVv4pTvq41Cl75auycQP4nCSzJL9hEA8XApvVv/zMQWzu+KKTDR23CRwf8pAATAb
	JBSFGOk8c99wIbNQeTN196si3aMKcRmnsBLAR46NXjPLj6a6ORXnklMj+qsC96S5TjXOfXz4mDi
	H5h9pVAgq3ChcU0gY+b3KnZbo/ovkM0xSBZL4mURHOxgEZ9gxVnhEwZHZF0fiU1Y7qIwzRrZCLo
	KQsh/RULFDi0p+5tua7ktum8eNBP2iKhTG31hlGrUQ5axOIgMCnG9mu0yQ==
X-Received: by 2002:a05:693c:66cc:20b0:36a:1452:8dad with SMTP id 5a478bee46e88-36f7612b26dmr7574830eec.20.1794059434348;
        Sat, 07 Nov 2026 05:50:34 -0800 (PST)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa922c6c7sm21280820eec.10.2026.11.07.05.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 05:50:33 -0800 (PST)
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
Subject: [PATCH v12 05/10] arm64/vmalloc: allow arch_vmap_pte_range_map_size() to batch multiple CONT_PTE
Date: Sat,  7 Nov 2026 21:49:48 +0800
Message-Id: <20261107134953.748622-6-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
References: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 996FE20006
X-Stat-Signature: ff9ndgjb4sob6bjt7jrab9q7mo91yo46
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794059435-265640
X-HE-Meta: U2FsdGVkX18JNgbpcioJ9fsJyveoECDGBEOoEWANMg7J9+xPUncA0WGjmyAEsa3rAu/obSexTQk8N69vv656m0elWKnqWc8UOUGrSRTiv+n1oZlFE9nomghaO8AiE50ZOO/wGuwnWpsaxYXRfuFpJ0OK8jcpsS5pR8wjmmOuAwZlFidNAeKxGCb1WZZbF97zBjRKKnieMRRpDXkhvnXdYq3uMCb+Lce9lgraf7+Z6+HdFWXQAJCqhnplohnHpYRrp875Rq8hbhCCKp8lhSR/7/d6FIpeiOMmUbg7Fhspgkxu/UoD19/MnCClwW5ibDonDrkPpulmciWxhAl4GTCClwCFRkajp2rwkkI+6eY0uqhvXrq31F5FEdA9Ejjz2FeRalk1SKvM22t+2A+GibiVDg8Z3BsHSOMxfjuBCfjH29jwpvxU8EjvN7NvqiHEgQar+qwwfVTOeN/f1e8RR4Ppq544rUsVxnYip6lDpF6APD1wYou3NOkjh8eJwzAUlqUwDvepayhLEiXeWjts7etFr4u4F6ScRnqrpKqLu04nnJ8oUmcBl7yaEXo9LfzWnvusO5LjTmrx4zWhNgXNf+sXRM2E9w8X/E4pJ088J7UlqZ8PU4RyA8Y5VrSSJFtzAt+dTfc/7ijr0/63blpHy4kRGdwoyr3SHeWRksJPxtsVvre4RoJnfImjjXXY93t3+FzZSaQNiRapbq6PVUSg5/7/M+vlQvKaYLR3tIC8IHTkJO8hJdpday2gaODyj9BLCLAQYHCMinONNkP7Kw+kxyC1imnWdPU0D/N3TRk+w4nGJO0HXARd7dXpshXJqBStPvHbt2nkgTF3/+2gjDj46iEHkRCONRjrP4wuOA74PryGULQoRRkXW3vhGQXrtr1W/Eoi6DWbn2B3+d4M5ZB57MweJaeno+I6TQYWq+7x2eAkF4XmIOOPvpmEJYTRpIFa8yPKTxoarcmYcrvw1xn5s9b
 DhFQ85bI
 5uZyjLh+onECuHWUv+TyUbIIOI6nt8dVqODETrNJWjRTOIGSnsL2KJDMzO+zJczII5MoO8WDMSXTcpiaWTSqF7Iq8MxKIZz6qFv2OFbRDhMYOjzldjQ32OvPVYqVOPB+8VCCCsuPpmbimT0H9kHUL6uqnhO79+Dkkcdd/S88I0X+zizSbPFB0ERILV0MWa0NzR9WNseY+fFins+tdDoSiivLY+m0HTlII8z/lsrWxJbJCwp0fulwKnl2HTY7K3jMuhdRR558wcnAfCg9Q5sM37dLEbgoed92L6vArIAwouqgviuzicw/KLivnbwgQsSzqVKDkSwv6+uw12Y6+HAG2i6072QSoDgd5GatbCAN/SJsHEIfVvMme6kDrFMJ1rbOloAJeTWfTo1CZceBqM5blS0uAI8DfMQHK7hy06WTsMoYp5eOgJrwCr8wJud2RMeMHkfMtnwMtCz1qLbT99kh6hQjW9MmehSmYHuotaTXc0kbAqHqLiYQ9MRs4yAdp3uu1t+9kY9PHVFbRq/f3b/KeGH8tBXU631pl99K+kdg180qF3v/pbis0sixXyziT/aw8QNM1rsQZ6B/xh6klM51YEvMLSHKa/bPiN79VxQ3u7UHyL5z0BlKcKbFht2Bc3dgs2kowqSu5TVLhZ1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
blocks, reducing both PTE setup and TLB flush iterations.

Previously the function returned a single CONT_PTE_SIZE for an aligned
range, so the caller mapped one CONT_PTE block per iteration. Now, for a
CONT_PTE_SIZE-aligned range, it returns the largest CONT_PTE-aligned size
that fits within both the remaining range and the caller's max_page_shift,
so a single vmap_pte_set_huge() call installs several CONT_PTE blocks at
once.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 arch/arm64/include/asm/vmalloc.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
index 4ec1acd3c1b34..c29704a19e276 100644
--- a/arch/arm64/include/asm/vmalloc.h
+++ b/arch/arm64/include/asm/vmalloc.h
@@ -23,10 +23,12 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 						unsigned long end, u64 pfn,
 						unsigned int max_page_shift)
 {
+	unsigned long size;
+
 	/*
-	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
-	 * aligned in both virtual and physical space, then we can pte-map the
-	 * block using the PTE_CONT bit for more efficient use of the TLB.
+	 * If the range is at least CONT_PTE_SIZE and naturally aligned in both
+	 * virtual and physical space, return the largest CONT_PTE-aligned size
+	 * that fits, for more efficient use of the TLB.
 	 */
 	if (max_page_shift < CONT_PTE_SHIFT)
 		return PAGE_SIZE;
@@ -40,7 +42,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
 		return PAGE_SIZE;
 
-	return CONT_PTE_SIZE;
+	size = min(end - addr, 1UL << max_page_shift);
+	size = round_down(size, CONT_PTE_SIZE);
+	return size;
 }
 
 #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
-- 
2.34.1


