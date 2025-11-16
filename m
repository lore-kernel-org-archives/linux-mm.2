Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32BCBCD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 06:40:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 702398E002C; Sun, 16 Nov 2025 01:40:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DA478E0005; Sun, 16 Nov 2025 01:40:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EFF68E002C; Sun, 16 Nov 2025 01:40:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5A28E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 01:40:54 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8940BBFDC
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 06:40:53 +0000 (UTC)
X-FDA: 84115522386.15.3F88E12
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id E78074000D
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 06:40:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of djvasi@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=djvasi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763275252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=A/TBs7BuWibkRX4L1Mxki9I3H1/n/J1InK7hm63Zqwc=;
	b=JvXQvGboi0aYsSdLQN/xgfcfyTnlKUcG3mf0HoZcqMURrecyQWCXOoU4BXqRaaLJN4gAul
	S1hx9rciQl9dRRxC5lR16qy3fuVHUGE5/kC+Yu6FnEODgpPlGFgSQF/WxDYEyRjmYYq9Ut
	IKopx++ehe76JnQ6ZEeWHExBvcrqWV0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763275252; a=rsa-sha256;
	cv=none;
	b=AFztBSgndSgaO8qcwLxUy7yzTZp9r1vPjxURqy52PWP7tm/VO2e91i3yWerocynrGEZErf
	145K5y4dV7TJISY8R+V9syOmy70vpDp98ziIVnxUVlf/UoN6OIDnrkKecuVdWyE4cMGvL9
	CEdwlICFSEGMuzcUhT8orEw79TbJ9OE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of djvasi@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=djvasi@gmail.com;
	dmarc=none
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4e4d9fc4316so29227041cf.2
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 22:40:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763275251; x=1763880051;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A/TBs7BuWibkRX4L1Mxki9I3H1/n/J1InK7hm63Zqwc=;
        b=Wbai1E7CuuFatEhsD3GUpumqXB4kTJQQArDKD0WFbyOiEBckpnHB3fg3aWT0BYCgd5
         4M0LS3L28uNCBw5YLQrDjIIICXdUeeA4TkCmTR9GSCsanDWSvHZKRJrTzxfQHH5FUPoL
         XIX3PBMKiKQwVu+StLaDD6/3FSGgVp5NoBfhHSnTaOcC/Exr7TMAMTfPoaf1HFL+tbhZ
         lFaPZkvKBsYE3ZxDSyZmvCH89z/JaFvDZ+fO/jnJ3MFZToszwoMJUaU1i/6XejdqjwLH
         o3w1Avek1jjUf+TN71uIBo0w8HrtqxW4xXxHTp7x5RMI8M8hpOVy9ZGwbLJ5li3Tex8l
         s3Jg==
X-Forwarded-Encrypted: i=1; AJvYcCWbf0ltSlNX2Qyyj3zVpha5cAg2lQt1NA2RyFw2ZUDXbnCcCZCUXqB8WzuNbE5Lc59/fIIc1eiCGw==@kvack.org
X-Gm-Message-State: AOJu0YwwSz6BcI5uNVDeNqjHLdQxmGXU75y37PXLCHSwc6ZOeXYJii0l
	S2lpwEATHlHBMfFmj61ccFpazHkDMyIcD8Txt+CDUKZXGOkrDAT5Wf6o
X-Gm-Gg: ASbGncvo6+kiEnYWPcR1wLgSNQNynMb4ZaiS9sidWtaTduHbKOtntYHnPPzCcxt6okn
	3ll80mb8b+WMmKR4gGczKqLu7jXmm57d+U30j8M9W3xC7laNNzpActcVq511ic4OYWlmn38l05y
	fOYD+DqlFqCicSLCjf+mxFBuAPpY1dl1gstZ/zBgNm+Kw73PEiGYyAA8EBu/Ef1Xijsu6bCmCxV
	y5I8cpiS7szMdKfVp/hM73/JRcT30F9cLDadXljuPBgx3bnpUwq05+sVT9A5apXP6ReQbc6mEp4
	z6HF5ZO3i20hHngjZZ6TQJ2lhsvQnOl7Ez9OqQ7PktPpBGAaAkRLNlNCEHGzEiphwNHaFbdLrPX
	e3/ljpFG8ozTBCQzv1HqlfOXHoPWgjooxk4OnTSYTgqwIyI4UwDIn7TgeVG0y+aYGW/pCxNUnOG
	xJ5uFhEFUmyyqhU8z/G9Yvt+zXaQsLnQxXU6okn8RzGmPCvalNHbIRPPxLcKe86uXcVMSTOUbjd
	g==
X-Google-Smtp-Source: AGHT+IG+qzsrR+dRWKF4NmoVX7b6CUaR8vMmbs3TLbWswTg9TED3bCbWhUIV58kjiV3MwgK5w6g1yA==
X-Received: by 2002:a05:622a:1107:b0:4ec:f7de:f5eb with SMTP id d75a77b69052e-4edf20a2ebbmr113268941cf.33.1763275250934;
        Sat, 15 Nov 2025 22:40:50 -0800 (PST)
Received: from [192.168.2.45] (bras-base-mtrlpq3141w-grc-10-65-95-13-196.dsl.bell.ca. [65.95.13.196])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ede87e6fecsm61188021cf.18.2025.11.15.22.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 22:40:50 -0800 (PST)
From: Dave Vasilevsky <dave@vasilevsky.ca>
Date: Sun, 16 Nov 2025 01:40:46 -0500
Subject: [PATCH v3] powerpc, mm: Fix mprotect on book3s 32-bit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251116-vasi-mprotect-g3-v3-1-59a9bd33ba00@vasilevsky.ca>
X-B4-Tracking: v=1; b=H4sIAO1xGWkC/33NwQ6CMAwG4FchPTuzli0MT76H8TDHBosKZCOLh
 PDuDi4mxtjb3/z9ukC0wdsIp2KBYJOPfuhzKA8FmE73rWW+yRmIk0ROFUs6evYcwzBZM7G2ZE4
 5SZVqBAoO+WwM1vnXTl6uOXc+TkOY9w8Jt+0fLCFDVhqJquJKulqft8rDpnifj0bDBib6IHl+I
 JQRpdDUQrubEfSNrOv6BpGaqhz5AAAA
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763275249; l=3309;
 i=dave@vasilevsky.ca; s=20251027; h=from:subject:message-id;
 bh=muIWQccO36YRMVeS5U/f/4/TLToyy8blzhH60i2svbE=;
 b=BqibHhRBraGtc5DC4MXisv7cfh+xdLpFWAQQaxC9fzFoJvdvVanpK8QruKXcOddOsTtRvfNgH
 YlQotamK+KoD0aCejzMYbW1umsa7tkoXkMduqh2O3DDT0rZZS39zLZd
X-Developer-Key: i=dave@vasilevsky.ca; a=ed25519;
 pk=Jsd1btZeqqg6x6y73Dx0YrleQb3A3pCBnUeE0qmoKq4=
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: E78074000D
X-Stat-Signature: b9a49euauomdw16ors4mnqoyfim88s98
X-HE-Tag: 1763275251-651454
X-HE-Meta: U2FsdGVkX18WuHfQI9tff7QU9sfJKzyZzc+09eBvx2lbDN5cQPu8GuU+BMxQc/1mRFH6tZ7nQ0CAD7FyjIffl1OKskwGDU5LdGRXROJbiYCyxWCzAtwpQReWdnsTWoAp8jW4ixpIK4i+C9okjZP55f6HjVQACbUOWTebMvBlNZjHeL+8rcqU6r5C1oAKVecncZenCZEgI1RPPDIEkCcjkncXMUON72Y8E+KDMDtZ2vUe5VwNP2B2FovGvd4UHHMEhd4+FITnzutdG5RXGV9WnQwGkAJGwbqkouXaLUBgF/x2MRupNamgbdJ10BH2dnVCnPzLaD4BMs2Ar7iRwDhz+LZANBcJS4Idt70eprQMX7g4YdPA5bSk6gX07z/2k2GiGj3v0YzKxe4HmUiJ0M3Gk+WU4dX6xrMN7dZD5OtDSBTI1sri98WEsuPJyBwJ0UcimJwqdhWCyztMZNb/Ky4LULLWL+e7uoKDrPEH3JVKxe+UTVTgxIw5xPWpb8ScGypsyWTBjQsfxr/0uI4XaFGmkDC344ymlGodb4556rAzow4z+Dwxi6kGVoK8+ewdJfDC5KSkP51UUiyVKurxFJpQlIDLsBShWPtasqiVQYELidD/Ucn6IjXFFzgb6uYfFztlS/VqcSDkBFAxrv9r6mQ/btMwQGDpdrYEfRgy7+oBBjHzrZoYZzVIQcE13OkIOKARZgetLDZpt72nK7lQ7qjQIhVkQWH7/JbLf0C+w7kwsTCZWO6DmtA+0v0wlpFUQzhA9lHJow3H5P60eSFgjVpfxNX2kfR1a8rqhUKbIzeZckp1RhmxWQ+pEecwnBToT1D1GZZXhgfLiOIBmiRWK34ditrXDNaSOIa2MTO6Vfw+xDMsYmkCIDpYGxn829p0M+XDK9sQ88PJ8MltROoB3Cje9Wh4ipiqeYo8itA3U6ZoHNT3ia2Jm7oGCCufCY8nvg+PcLTqfkSaxd3VQoJZ2gh
 ezCTC5aw
 UTcd4R5+mjDIa/MIK/N+QLXEChSIAZoqRGgfNMk/jB13injbFcyVadoN+P9MmzcnTtEKuGgamdTfZJnwGsFPGwJduthOtvwJHG1BTcMWTUM0fqgZy5c726Ug35OaL7ScxE2tzlAWpeK424tk39673Wl6KKEB9Yv7AUraox7qAiPr5l9IXixRXNlKh3mtr/1A7ZBGAhTArTtrS2wz0gNxcabeYLSDWOvjUM5BcR+m5aCgdhU/CUaWmwJHJrn9l6Hr/+DtVn5qArFfZrKvxeBhX+QeW5exwY4jy3oOKQ/P1i1LGFLIHwDPx7uSKnpOkrPM/Pc8uV8XCXZ0FbBniqIt+u6+zVRA6bRfExrdXg+sSGQQUKi0Sozh0CUvGdj+LlObFNVKZzUYsg9Boyy02eALVbyYtO3+8ovnVWeQriqxFVLEat98mfNmqyziATlcsE789jUVLz95c8YRCvD3zrz/Tme8/Xk5lI8W8wVJlaRUMhtIUmZ+6GE9qhx4gfYbrWSDbp6a7gKWUyJVty1e3IW8Xfx7VVw==
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
Cc: stable@vger.kernel.org
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Dave Vasilevsky <dave@vasilevsky.ca>
---
Changes in v3:
- Fix formatting
- Link to v2: https://lore.kernel.org/r/20251111-vasi-mprotect-g3-v2-1-881c94afbc42@vasilevsky.ca

Changes in v2:
- Flush entire TLB if full mm is requested.
- Link to v1: https://lore.kernel.org/r/20251027-vasi-mprotect-g3-v1-1-3c5187085f9a@vasilevsky.ca
---
 arch/powerpc/include/asm/book3s/32/tlbflush.h | 5 ++++-
 arch/powerpc/mm/book3s32/tlb.c                | 9 +++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/book3s/32/tlbflush.h b/arch/powerpc/include/asm/book3s/32/tlbflush.h
index e43534da5207aa3b0cb3c07b78e29b833c141f3f..4be2200a3c7e1e8307f5ce1f1d5d28047429c106 100644
--- a/arch/powerpc/include/asm/book3s/32/tlbflush.h
+++ b/arch/powerpc/include/asm/book3s/32/tlbflush.h
@@ -11,6 +11,7 @@
 void hash__flush_tlb_mm(struct mm_struct *mm);
 void hash__flush_tlb_page(struct vm_area_struct *vma, unsigned long vmaddr);
 void hash__flush_range(struct mm_struct *mm, unsigned long start, unsigned long end);
+void hash__flush_gather(struct mmu_gather *tlb);
 
 #ifdef CONFIG_SMP
 void _tlbie(unsigned long address);
@@ -29,7 +30,9 @@ void _tlbia(void);
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
 	/* 603 needs to flush the whole TLB here since it doesn't use a hash table. */
-	if (!mmu_has_feature(MMU_FTR_HPTE_TABLE))
+	if (mmu_has_feature(MMU_FTR_HPTE_TABLE))
+		hash__flush_gather(tlb);
+	else
 		_tlbia();
 }
 
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


