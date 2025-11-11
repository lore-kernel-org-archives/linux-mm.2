Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 809A9CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 21:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C87558E0007; Tue, 11 Nov 2025 16:42:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C38758E0002; Tue, 11 Nov 2025 16:42:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B27028E0007; Tue, 11 Nov 2025 16:42:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9B58E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:42:49 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FD20139A4F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:42:49 +0000 (UTC)
X-FDA: 84099651258.18.EFB4F5D
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 44C13C0012
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:42:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of djvasi@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=djvasi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762897367; a=rsa-sha256;
	cv=none;
	b=bKbS2cNBzQxwmVsp917nVsq8+sSBnx7BMhDsmawl0pvAt/IPoUcsYXLle4GFc0edCDHOvB
	3iL7Pgrp3DPZrCJ4BJNWsQ4KglucDRWmIgUZiAjQyH/faPWGMfjfQ+tOikJuAjbwbkXwt7
	v7OLNR4evsQ5HScPmrzy4Wn0gBEVASo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of djvasi@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=djvasi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762897367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=37+7hBkhzuE7kcjBfybqxVC8HAYgIXzyLEuWgJ3dqEM=;
	b=3VCv1uEsRXjheVTznQc3RdNF+bYGerIYgzVBWPsJKtyY1yeRYtOD85bqPqhJH3zR3uqliM
	muNdhxN4eAvIQdVc6TxW7F70+HLBBJ3M2cb+zl+DyX1SQqnzNffrKC2v82y9ik7qm/bP/r
	hrvtaNsRTAF69cifE0HNnPXjJDUvtmU=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8b28f983333so22409085a.3
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:42:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762897366; x=1763502166;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=37+7hBkhzuE7kcjBfybqxVC8HAYgIXzyLEuWgJ3dqEM=;
        b=LOGrvG4isN0GoV5tBYKWv4sOsc2bZrM5O0cFNk14Jm2Qe5DvIQ3rlm1CWi6SS9jqI3
         tIXQktUpKT+JDiYcWb+PQG8Se2V+domeZxUu/K/0N/gcymsXAB7L45n0NCRZgYmzToCK
         NkPzPF9ECuS7Jlinf6vodRC82rA1E08uNO4Zoy0rWxid37agstdgB7L3Zl4Us2jOPYwg
         2Yr1rvzkRVDX2BtgzLmPzPyx1UaZkyluHn/HJwB9oNxZqxBP9uQWerc2UZvrGQlkTcBV
         iBGLpSjrqm/YNVcIlXQw5Ik6sOLAI0GBO9Zv7wDKyflnBU6cXXxQfxgauRY1Vu12ZIr3
         nLCA==
X-Forwarded-Encrypted: i=1; AJvYcCWjC0qLey/bRFNNTvDG8jFJbyj0zB9wRs0ddn3NMyQd4n98Gu3TjBg3xwPVUHnIHsHASJ3J8Bo3SA==@kvack.org
X-Gm-Message-State: AOJu0YwkvYof1r8xGv5MAjYrosFH1ZEpEOmY7mMVYT/z54rtkxZ6w3T7
	ov4XoxnQ3YGPHQYIJpcqcW7ZnW68wO2As37IvZ5XJVKoWUpGHrPcmaCu
X-Gm-Gg: ASbGnctiUdkT31HrbE+noOXhHnKGn/kgvOtaCobX4DESqx9OCLdg/4d81rDWvh1Celh
	tHBLvc2KPgCAAvPWRoLubHn4cpCdox7BOG/9ogewJRu/YJpR9fIlnRqodb/GgxgOu3m4jy+MKoT
	2VMW9n3tXYPSiwW0n4m+0MIFTekpj57c7tPIO5lm200/mm8BOhcUO75mzT/r0+y2vGDjoXuPl+A
	Qmte22fHeK+X0bzh0fDAnP1iqYB9X2DaEQMCY6yvlIfvJtobc+9RTa7WmO0s1PogOXITGr+7uZk
	wQHmJksTKP0U06nDRC0Uit6/dhioCmnEIIi0SxaMMm67Z0p15g7NEZy5tToCfpFdR3IvsYHGyrp
	S2ye89BIVjdYC1CGRT62+F0Y2xxadMRzBoLhuM9H54Gzi3cCFJ2fdOE52WS7GyL3auck4cX7t1i
	ovhlaW6z7cd+uO6y2JbOwPdYudw3+XNgKgvi1KFRdlzTf+Wq3hhnNYu4piVFFE/eM=
X-Google-Smtp-Source: AGHT+IG3pd8H8cinV9KY2sxGF9Lqdw5K5u9F1WzBYcrYijYiG5sk7Zas84UeYzEmg+TDrSyPXJndow==
X-Received: by 2002:a05:620a:40c1:b0:8b1:ac18:acc9 with SMTP id af79cd13be357-8b29b77ad4bmr110215985a.32.1762897366312;
        Tue, 11 Nov 2025 13:42:46 -0800 (PST)
Received: from [192.168.2.45] (bras-base-mtrlpq3141w-grc-10-65-95-13-196.dsl.bell.ca. [65.95.13.196])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29a9e6e6asm59918585a.35.2025.11.11.13.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 13:42:45 -0800 (PST)
From: Dave Vasilevsky <dave@vasilevsky.ca>
Date: Tue, 11 Nov 2025 16:42:41 -0500
Subject: [PATCH v2] powerpc, mm: Fix mprotect on book3s 32-bit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251111-vasi-mprotect-g3-v2-1-881c94afbc42@vasilevsky.ca>
X-B4-Tracking: v=1; b=H4sIANCtE2kC/32NQQ6DIBBFr2Jm3WkAJdKueo/GBcFBJ23VACE1x
 rsXPUCX7+f/9zeIFJgi3KsNAmWOPE8F1KUCN9ppIOS+MCihtBSqxWwj42cJcyKXcKjRG69Va/p
 GNgLKbAnk+Xsqn13hkWOaw3o+ZHmkf2RZosTaaWlaYbS/2cdReVOOr/XqLHT7vv8A7zcQxrQAA
 AA=
X-Change-ID: 20251027-vasi-mprotect-g3-f8f5278d4140
To: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Nadav Amit <nadav.amit@gmail.com>, 
 "Peter Zijlstra (Intel)" <peterz@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ritesh Harjani <ritesh.list@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, linux-mm@kvack.org, 
 Dave Vasilevsky <dave@vasilevsky.ca>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762897365; l=3254;
 i=dave@vasilevsky.ca; s=20251027; h=from:subject:message-id;
 bh=Zit10IcjEQgZrlYn+H0pI2muI6sNj2U/B2zs6yrH+H8=;
 b=dn4omO7A8DZD+V7wNR4W4X80lGIpHjLAHsjIoZ421FOXmVeJST9kiGMlzTgaFTHCkeKQGUtcc
 o99hIiot/c+D1dhxLbSDf+lTXlQ2Eq/JmuM7PJ3WbD/2uIodH6yvTEe
X-Developer-Key: i=dave@vasilevsky.ca; a=ed25519;
 pk=Jsd1btZeqqg6x6y73Dx0YrleQb3A3pCBnUeE0qmoKq4=
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 44C13C0012
X-Stat-Signature: mfbppzijziwm95dzq9wrwhdeibhgh1jk
X-Rspam-User: 
X-HE-Tag: 1762897367-705814
X-HE-Meta: U2FsdGVkX19w84qdnKbGHNhx6/EnfT/8/W/8631eR/4yn1DDldezuqP2SBmEJDnWmAig1Ukzd9Y6z/7zvFT4798Bfn1VYiV2SPhWh+rBWQ4xG+qIGjed+VmbTjLSYwlaMa37MJ0JJSjXMuHTLpNGHLxyRwRtKbbyvrIpgTNWmPmx4D7Vglqb00QtrT1zhSF/34q2n0+Gx7LSThV8mdk8jyt8Y2AQIFZncfdvwA1hTqIRwnXWa4UXy442YTNpfLtrXLhmsmnt+fnUhTksG2DQNgHEQJTSw9glbf2OsuT/QMuqmXuScHQshR6J/V2Yg6P03MxKePHHjvRerCnjIfsVmM4Jrz7/M/Lq/tFOn1wbE+omH/hKrSckzeJgNLCfEhk1LugqJXCDJzbHtSiVm0rRflYWA4l/IMT+0hWKGFTZiyjmNQVrRMkvvZTCAX7+uvkK8rNHbDdaNKrsO0ICFgWoULXiJNivlSnydm6ATw5/gsRwYsyFZ1kV1Rqm4gCK8dMaxk/ckt/Oct8hgmG4z9uB+ChXd1cvofP7qBAtkNG49ogX6L0I6PU2j5Y+MrPzKYMwyzOFNjA4EAzB76MEtdvXZgRjto4uGUtauIAhEVu+3oZc/UOqzvEYFQzdYZOptw6yymgqbNg1/3306KlnN4CaQ01aYR78uIR5G/5y6We4xwVhSyWprjFj/+FT6+PrByW8nHExe+vfJnerE1mn8aYE+R7yPpa1xWiteOSm+RxmDTLaQdlj0GuLZucDJ2yvF4TCpkLTzf0qHNW+7Z0PvBTxfApKIMISSHgxpS6WLvU6LGl/SEfTMtPUXtc0kVpB+JC6iLfLCFiV8sy1j5/hrqmK6qxbnxU4zuISQtSl3LGjiZx5O0ojogfEU73dO55UsgFy8JkLnOjHzDYG4w5Ysw9BfdReE7K/arTmHonPWzpZuzX0sOfRWauH6mvWsfv3yEchv1rT7PsWeIuXMw6es0F
 QMEt3xkJ
 mdkYn8mFpnKgYw/DTqSoQ3J8jOnkHUPXaYeuiQ4cXXTNpl8yhUr2eIj2eKv8Pk+T70An6GPyLqIzR+2gEWrJNaAtS+/9rP9U92AXL+dk+YYxGvSrPP+RxVPij80dgqTTW7LR6BymOXtOJ/5rUqWGHCmKxo7C+9cXcULeKuQzlADuK8Nzugm8Y6m/j71pAjPXNCUOJBCoI72nz7i6cq44KlQhwfAFKODm47PJqBZT6gPNzYKdxiByaMZsMJoPSSp5k+sSeMq+iJAm5f539iQ5PkGQ1WfxaJtEA7QN0kiX4zeZ0EegrcPfk5FCdmpDyVR9JFUiSTv7TY567OERMXw9P+/niLWHJdj+RfDJGbBLZTgPGz63GYkHpfi8zgl5RLKQ2FLB1V7fwphErSba+IBrRh0yjvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 32-bit book3s with hash-MMUs, tlb_flush() was a no-op. This was
unnoticed because all uses until recently were for unmaps, and thus
handled by __tlb_remove_tlb_entry().

After commit 4a18419f71cd ("mm/mprotect: use mmu_gather") in kernel 5.19,
tlb_gather_mmu() started being used for mprotect as well. This caused
mprotect to simply not work on these machines:

  int *ptr = mmap(NULL, 4096, PROT_READ|PROT_WRITE,
                  MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
  *ptr = 1; // force HPTE to be created
  mprotect(ptr, 4096, PROT_READ);
  *ptr = 2; // should segfault, but succeeds

Fixed by making tlb_flush() actually flush TLB pages. This finally
agrees with the behaviour of boot3s64's tlb_flush().

Fixes: 4a18419f71cd ("mm/mprotect: use mmu_gather")
Signed-off-by: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: stable@vger.kernel.org
---
Changes in v2:
- Flush entire TLB if full mm is requested.
- Link to v1: https://lore.kernel.org/r/20251027-vasi-mprotect-g3-v1-1-3c5187085f9a@vasilevsky.ca
---
 arch/powerpc/include/asm/book3s/32/tlbflush.h | 8 ++++++--
 arch/powerpc/mm/book3s32/tlb.c                | 9 +++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/32/tlbflush.h b/arch/powerpc/include/asm/book3s/32/tlbflush.h
index e43534da5207aa3b0cb3c07b78e29b833c141f3f..b8c587ad2ea954f179246a57d6e86e45e91dcfdc 100644
--- a/arch/powerpc/include/asm/book3s/32/tlbflush.h
+++ b/arch/powerpc/include/asm/book3s/32/tlbflush.h
@@ -11,6 +11,7 @@
 void hash__flush_tlb_mm(struct mm_struct *mm);
 void hash__flush_tlb_page(struct vm_area_struct *vma, unsigned long vmaddr);
 void hash__flush_range(struct mm_struct *mm, unsigned long start, unsigned long end);
+void hash__flush_gather(struct mmu_gather *tlb);
 
 #ifdef CONFIG_SMP
 void _tlbie(unsigned long address);
@@ -28,9 +29,12 @@ void _tlbia(void);
  */
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
-	/* 603 needs to flush the whole TLB here since it doesn't use a hash table. */
-	if (!mmu_has_feature(MMU_FTR_HPTE_TABLE))
+	if (mmu_has_feature(MMU_FTR_HPTE_TABLE)) {
+		hash__flush_gather(tlb);
+	} else {
+		/* 603 needs to flush the whole TLB here since it doesn't use a hash table. */
 		_tlbia();
+	}
 }
 
 static inline void flush_range(struct mm_struct *mm, unsigned long start, unsigned long end)
diff --git a/arch/powerpc/mm/book3s32/tlb.c b/arch/powerpc/mm/book3s32/tlb.c
index 9ad6b56bfec96e989b96f027d075ad5812500854..e54a7b0112322e5818d80facd2e3c7722e6dd520 100644
--- a/arch/powerpc/mm/book3s32/tlb.c
+++ b/arch/powerpc/mm/book3s32/tlb.c
@@ -105,3 +105,12 @@ void hash__flush_tlb_page(struct vm_area_struct *vma, unsigned long vmaddr)
 		flush_hash_pages(mm->context.id, vmaddr, pmd_val(*pmd), 1);
 }
 EXPORT_SYMBOL(hash__flush_tlb_page);
+
+void hash__flush_gather(struct mmu_gather *tlb)
+{
+	if (tlb->fullmm || tlb->need_flush_all)
+		hash__flush_tlb_mm(tlb->mm);
+	else
+		hash__flush_range(tlb->mm, tlb->start, tlb->end);
+}
+EXPORT_SYMBOL(hash__flush_gather);

---
base-commit: 24172e0d79900908cf5ebf366600616d29c9b417
change-id: 20251027-vasi-mprotect-g3-f8f5278d4140

Best regards,
-- 
Dave Vasilevsky <dave@vasilevsky.ca>


