Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 331B1C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 110906B0109; Mon, 21 Sep 2026 07:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04BF66B010C; Mon, 21 Sep 2026 07:01:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C926B010A; Mon, 21 Sep 2026 07:01:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C4AE26B0108
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:01:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49665C011F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:01:04 +0000 (UTC)
X-FDA: 85237477248.28.D2076E9
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	by imf04.hostedemail.com (Postfix) with ESMTP id 97FBA4000F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:01:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=esLgI7Gj;
	spf=pass (imf04.hostedemail.com: domain of 3bQ6xagoKCKofNYXXOPYbdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--vdonnefort.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=3bQ6xagoKCKofNYXXOPYbdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVYg8Lj489hznrzIM+7T33EpvHOqUo3+jajnUbYBZtQ=;
	b=BrkrEQxPQcpAYBX3ujoJRJrmIMdHfSPB/m1lj0BcOz0Jl1i90zwKMjirdjUZv411knoIfT
	prOW7WrnloV/c/npqQ0EPK98chrfiiRyDOhsDhL551EkHWOW4Cazun9JxfnStNTGOcn8Xp
	UEm8/H8dTe8qNpPSxBuw4MjwQcKc9uI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988462;
	b=Ixny21uqrVsXJ4JiNL3wg6XFAIXIT4icYWcwvvfD3NEjx9tl6I+P+WyN2sWScor2SS6c3M
	I1M+QNp6wwDsXJ0HP5ZHfCISa/ACoUA1j5c8RQHSdJAo7I69zBq4rAOoA/8+eCrWvGVGAo
	NnFzk0H/ReickPoFXu3GfiH/3pJPMig=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=esLgI7Gj;
	spf=pass (imf04.hostedemail.com: domain of 3bQ6xagoKCKofNYXXOPYbdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--vdonnefort.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=3bQ6xagoKCKofNYXXOPYbdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49e735659b7so23647535e9.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789988461; x=1790593261; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PVYg8Lj489hznrzIM+7T33EpvHOqUo3+jajnUbYBZtQ=;
        b=esLgI7GjrDbYgG9emHAP6vjw/jpVcrrS+EFERjNu/pvfXp+jqxTj23VN70fY5dXY4m
         ZSCA+FVkPRIyWuPyeP7qVz0c5Pqcze0XgOmu2wCz8YDcOJ8ntGRkkd1yQCo7J+LwpBy1
         Jm/O511r0ybM2M+cdv+bLWkprMBLhyM9AS7D4LMQXbiPCfN6HeJHEAUxrB8+Wj+5H5e/
         y7U/g7ssXwlTtYjpd10a/NVoYMg1crt0ZozCoo0t7zHGxM7lkx2ibbQO3JBYPWrGWpNH
         +eYV/G8gebFcEGrYS50Q3Ln+6/C/TM/LlYHnwCakLN79GNl7/OPL4d2qZU2ZEh/k9HNl
         SRcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789988461; x=1790593261;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PVYg8Lj489hznrzIM+7T33EpvHOqUo3+jajnUbYBZtQ=;
        b=qYuKouob5KD8l5Pd7CDOLJOi+LcDCxmfcuf+L1H5k7wVx/jH5AhvSs6SikvZNvA5tb
         GEiT/G72QDCBj3afAujdTDpK4XLhOZlUvlP9RHjQ5fHvb8d+GqyvbkkRib011HpudmM9
         9PCXSldcvlC8PDc8xAQonfN/zgDBi4RRuQPQxAfzMB31hDiMdVQ25pBeB6phEDtGWTIA
         Ia9aR6zMATzU1O9OiletZ4Zex90viWp4ffiNVfjq4GS8r5kohIUdYsrePhTGcbXbeK8Z
         KcVbnUbw5TUcFuiWZiic/S4T2MMnhaZkrArAopn8VuSypJWwsZ2kfi9pE2clYbPGyX2D
         e2Ag==
X-Forwarded-Encrypted: i=1; AKwUvByMQ2c3nvdRSXuZnxm8tSZFqpG3gNqe8hx4uC700BiZzlEHOxOV4UnTM0DGJ/uqQiZVafo6if5/kA==@kvack.org
X-Gm-Message-State: AFuF++nL9VOjRZ4e1s4xvXwZapoyekxYdhobXz9fajvQrYDfV01xxuXy
	WinEaIQnrxaA7CMf3kpRzTlJpgKBJZ5IDveeFAIbj+NgyMhVRUmUyxgarYKD6yBRiJFN67KJMHP
	gnaqey5a1FtMdGbc/1mSEPg==
X-Received: from wmbd4.prod.google.com ([2002:a05:600c:58c4:b0:49e:81b9:5272])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6217:b0:49e:8418:389d with SMTP id 5b1f17b1804b1-49fc571423dmr133093905e9.9.1789988461055;
 Mon, 21 Sep 2026 04:01:01 -0700 (PDT)
Date: Mon, 21 Sep 2026 12:00:46 +0100
In-Reply-To: <20260921110050.3977591-1-vdonnefort@google.com>
Mime-Version: 1.0
References: <20260921110050.3977591-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260921110050.3977591-5-vdonnefort@google.com>
Subject: [PATCH v2 4/8] arm64: Add support for MEMBLOCK_PTEMAP
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, sudeep.holla@kernel.org, jenswi@kernel.org, 
	robh@kernel.org
Cc: mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org, 
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 86nyct7ra5h6mhbehod7r46mbfbqh1by
X-Rspamd-Queue-Id: 97FBA4000F
X-HE-Tag: 1789988462-112282
X-HE-Meta: U2FsdGVkX1++kR3btgzcIV0V6yZQ9y4pHnJOoPCu3RXMOb6WeQWnlaDAvcDqu5YSU1hMKZjiGb7SEca+lFmqaKzkELNu3NuA0zkBhL4FNEwovUibtYVPo6VOSN/Tyu0ucw/DLaYFi5OOEH+BxiH1im6dEn/k9MUAkLCwVMfqHDbjp53zmmnC8ESwwchnrwcta0RCIIHL0Y8DRBNx52x7qtKz1tZ3i4GpdWN7Fm9k1khRDEkFhXHrlbOW/p4XIeHXzvYOmzMbfx9Jd4xIYznW6wpD1749D+z7KH9jO6Os2zYg65Bmws8wBrQbf79yVIkSvLqjqrrSCw0rtlekCZ8B0KNgeYYnddF4nMgzbI8giioXdP5toKwHo6khvq0hHweF/XUCLtYrnZ1Rr+e9NDssh7rRCz5JgM5pAqnBEDga8apb84oNXVLewSd3X1Z+i1xm7w7MPNnwEF503gQdBVDOfRzB42IZyaJjr33hgSIN82tQ6hbIennB4HaF03LAEUDBomL8/LX0HS+rPbEuWLFZUFYnHLC+P91rXmlzonu6eZtKUoXhJbUhVE5FxdYl55zmpuK0WUTm3tZpn87hyN9mNkM06ph1KKsNz1q9AzoavLOjqPFnNxKR5aIGTSfzSDbQxA1VRECJAySXtOzoHolCTqg13dKFDLmS9ixeJ49WhuktSGxFxGLwsreAolN9hiUTRXnqItN2Ha5JDdKQKvRhYCjtFsxm/QpIKRb/8vWJ8phwubPgwndUCAbfm5a/W4k1gNsAfaXbCCDQwn7I/jfU0EDq5j0kQ/CYk+vcC3J2wK1jcGSzxi32+GAd5L85buKmJw2F2tuMGAuH0AnEanqvpNhvw3kblxEJc2ZWTR5iKl1WLNmVl+C73mIb9NrO+stakSrO0jMLIlD/8voropg6LG0GQD46vJi+WJk4mJKA6kuoBwzP+i1b57LPRNPUjZ5uMeTZfVuA1o9mGiIjpbU
 gptBtSAy
 BCE4hroVj2qhZAJ0APE4KSeRVSmVJ+hcuDVK0NstnBWPInAo6gDOzI2i+gYT36RcfgoWvRNhaCwuuYG8DbHT12YAx9Rvo3J6b8uJ96gP7gSWP/8sm3Qvzdm4OQrikoeLgwD2macxMX+BbJiMmBkhJztxy2bQW/OGEJzfnmjkq/cZGl9w9/ecAVzwuWNSyFOEX44lhZDIzigzr37hQ6ZBH9m8T8yuYoq1xYQZQVPVgo7haGa+IkKeZjR7FCHzMNj50H7+fo/ogApzlQI2kJScRGOQ1N6gxIUmz4k4usxuPrcP7poKsrS4jVyenBLHe/srwKhZ2iMYuJu8oymO6KAUBV160V6kkgSgWdlNvY7Fn6oGhNmNUQqm0WaKkMREEhF91hyk70Z6lRLQ3oEPUEyS+dC87R/PSSkfHbucFKoijopGmx0LH2/NnHl0rWSFosQO2foUSGRQ7GbTrZQRRMmsfzbSblAcwjlS/RPzxEVKJWd2jA7QXijzrgeNVpl1rn5p5bCxfwUbbCDyn7VYaTk/A2NOjV+aHSt073EMDKvrTYk9/4ZQX/ZmRBzQpDu0QVGSTOPsHiN4c2WaS/ZUaFwNfn54KrqpHz1JNG3fQvseZ5tZPDgDrfn0j+CQCt9p6bDY2D0h7IFSPJNhAh72VSdXJB9+X0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With the MEMBLOCK_PTEMAP flag, force a PTE-level mapping.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/mm/mmu.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 79d90226fd5d..6b22b43a5f77 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1184,9 +1184,8 @@ static void __init map_mem(void)
 	phys_addr_t init_begin = __pa_symbol(__init_begin);
 	phys_addr_t init_end = __pa_symbol(__init_end);
 	phys_addr_t kernel_end = __pa_symbol(__bss_stop);
-	phys_addr_t start, end;
 	int flags = NO_EXEC_MAPPINGS;
-	u64 i;
+	struct memblock_region *r;
 
 	/*
 	 * Setting hierarchical PXNTable attributes on table entries covering
@@ -1226,9 +1225,13 @@ static void __init map_mem(void)
 		       flags);
 
 	/* map all the memory banks */
-	for_each_mem_range(i, &start, &end) {
+	for_each_mem_region(r) {
+		phys_addr_t start, end;
+
+		if (memblock_is_nomap(r))
+			continue;
 		/*
-		 * for_each_mem_range may return sub-page-aligned boundaries
+		 * for_each_mem_region may return sub-page-aligned boundaries
 		 * after memblock_mark_nomap() splits regions at byte precision.
 		 * __create_pgd_mapping_locked aligns phys down to PAGE_MASK,
 		 * which could accidentally map no-map memory on the boundary.
@@ -1237,17 +1240,23 @@ static void __init map_mem(void)
 		 * regions. The cost is at most one page of unmapped gap at
 		 * each boundary.
 		 */
-		start = PAGE_ALIGN(start);
-		end = end & PAGE_MASK;
+		start = PAGE_ALIGN(r->base);
+		end = (r->base + r->size) & PAGE_MASK;
 		if (start >= end)
 			continue;
+
+		int rflags = flags;
+
+		if (memblock_is_ptemap(r))
+			rflags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
+
 		/*
 		 * The linear map must allow allocation tags reading/writing
 		 * if MTE is present. Otherwise, it has the same attributes as
 		 * PAGE_KERNEL.
 		 */
 		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
-			       flags);
+			       rflags);
 	}
 }
 
-- 
2.55.0.1082.g2b9226bbc0-goog


