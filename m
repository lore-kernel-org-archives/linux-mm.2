Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99511C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 09:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E5316B0095; Fri, 28 Aug 2026 05:48:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BCCE6B0096; Fri, 28 Aug 2026 05:48:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ABD16B0098; Fri, 28 Aug 2026 05:48:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6361D6B0095
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:48:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D97DBC02A8
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:48:38 +0000 (UTC)
X-FDA: 85150203516.21.2800FC0
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0AF5E10000C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:48:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hIecJAGv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787910517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=glXaJJLLc7413zYTPQe8CxMRLtRUMADuZ7/9ajV0cjY=;
	b=rXfl+5cv3pcj2ccoj/hcTedbcBb0t16wlAl0WTMRoRxM/ZXrDVliTGLo0+uBCH39VG+F75
	o2kowoSCeonAel1SvnYUPF6dhCHXM4g+XRp/aDJDzhroG9vY4XC8B5pBwdI7cQhhdPAUrW
	Pt84BHdINe0pbH/QxZMd81rsK8B8zBE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hIecJAGv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787910517;
	b=pJiSP9M52d8KqqxHbJdPutWk2PGVHSppJnZZgHUx8AA+Q3DWsaaY4waSH5ZD7MeQiC0MtI
	eDi85jg4uRcvtwZsJbVqklofC2228BfxDKsSG45ybEQwqxpzC0AcoYKvkfjsjGBa6IPQt8
	eSIWXZZ2gD/HHGbuGUFmw5TBrNW6X0A=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2d5335cf904so7573565ad.2
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787910516; x=1788515316; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=glXaJJLLc7413zYTPQe8CxMRLtRUMADuZ7/9ajV0cjY=;
        b=hIecJAGvbIpyugGFL+E/FVQn/oGGidRgQYR1x6al+duUlmVyVaKJoOTFtXVJzRke4X
         bv21q9kRyOBJHMAPRhA+qrwIA/bNhYYjkYSSaO+sor//exTqD7zZI1Hmei5f+XEjbtHV
         NDKokYaePpBV8hp6Y15FcHLSktCITZ5CM4XSlSTXXF05tjblQJkylCR+SwfaaqNl4oYz
         vHzjf/e0NWlkIgktRGi5qsZL4z1pASZ0ZOM54NdE0DCwLe3JWCXgPZxthwbisHKrMoIi
         tmirJ+6gMtsy1ZgjJ2zmdQIlD21kdm0nZ1RWkAJ9btTNBxh/wEs7mi6tbIzXYnF1gMYR
         4h2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787910516; x=1788515316;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=glXaJJLLc7413zYTPQe8CxMRLtRUMADuZ7/9ajV0cjY=;
        b=oU8jO2cXil8eexUzYxvJYYAfHCA1ZsKRfT5ncrmwE6QPCDDIF12l1t+lvVChxLFnPg
         yY5tMNo4S2WU2GMAvn9CkLu9Rabi6Nb7l5vF2NvAFXrveGNml8hQpxt9m3rNzxhN+7AF
         l/IaXubjmoTiElELOtzIRYhBCovUQtERWw2I+gKXhjkiSrwDSrCxLURNJjC2anu/Esqy
         +PH24+dYp6495HVMnQzc8uPK1vwty3dcztx5VfgELn3J9zkh3U5eWPRuITnm50I2klAW
         MTPX05bY9sWVaYs8je8Ci+wq4JGRDIhwVLP0JnyerDip2c9Fk3gBUc8tewQ2aFY4jsh0
         qtDw==
X-Gm-Message-State: AFuF++n63ptIcMvjKwyXB0wU74yjjYiRebJkJ2jTJu9qixUyEyyXleOB
	z+KKWztEDo34BbVZjpW9mdy4Tn3O3Vp3ab0AzGeng4fnTGIDdeJ+ATex
X-Gm-Gg: AR+sD13tx9ZX0I/UussihDrX8Asz3chCWt0n2e2KRS9bpSHAD3P4B5Q0iKvCwdXzHfn
	VXMEBjmVIpHol03n8DuhkZSjKjMeZj0WwVxImyZxrsWuE0FMupVmIEfYURXRe572SgUVtYd9d47
	76TqcuMgBeVg6TAur48YLZA+TLQu+TPrtbbcxUnX53A9RDVmy9nPwmiSVA6XRfdix7LCnqvcmOz
	fpu3wD5VQvMamZl2zJg56ea4fQ0QOoN3mUVDHsbZOEOEGh+62gSlybWjyllRQJgwVZ/IJHsfmxq
	Nx1gnk1ohMjEUpdJCOjAnqv6701xIGC1VyxC4bhCYj/pSkFnZDdkT9ruQpYzVIz3ndY7bm4i2p4
	hdv6ChUhkyi8D6DnTc5BH9yBftS6Nch4/eKJwLozsxSYpYb19k44PODgefZxogNinlqmNstBKCS
	A8NRLDpDhKn+QtyONsQj7z+CSpMg9cdQihOt6J0s6ApafbeDkthA0kCFytQUDSNC8i6ENLnkBHn
	FcfBUE=
X-Received: by 2002:a17:903:3a8b:b0:2c9:d88e:f996 with SMTP id d9443c01a7336-2d74dee96b5mr108548445ad.9.1787910515336;
        Fri, 28 Aug 2026 02:48:35 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d759531f5csm3778075ad.28.2026.08.28.02.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 02:48:34 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <kunwu.chan@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/mremap: fix locked_vm accounting for MREMAP_DONTUNMAP
Date: Fri, 28 Aug 2026 17:48:22 +0800
Message-ID: <20260828094823.594279-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0AF5E10000C
X-Stat-Signature: dz18gocixope4mtmuu696edqn9xrj571
X-Rspam-User: 
X-HE-Tag: 1787910516-194525
X-HE-Meta: U2FsdGVkX1+BK9YMbS3arvSNvWik40DmFDekDPEcBYYV7B0vC1KEqep12lwwbKgFXzMoIe5HQfpf6TDalyQBf5hQL21CZ/mK1RHxaIe0O7zei5yOBWXiE5XeHErK0k/XmPT19PMDsck8KfaffYEEJOOVpYjKGdOIZXsHftBnPLF9TS4mm6DD8ZosiVfu9wimJzwgM77+AkwF+jQC/YgwEenBWtGI8GhvE5E9O5uqLVGTprycpzOBpwCjyyxhM7v39UROUMyogeESVEgLT7Srx3ESyk0+gaTYLyKo0bYnMYrZ+wctd7qO8PLco8w6Ebgk+QRif0yplnlcal2vuF4P2iZ1YkWN0OOTzZrZhw30ZvacQTKyF/PHg9gAYTdDyKRPcEJe7APKKQyVEzJkiRiPVKTyPKJGtpm+hKgADtpi8aufEH648ErJ0/KSpaZZNEpKKuubbd9ODnj3MLpR7Si/8Wpk+HApu2rBGDmhyXfC1+JuBkvLmb2kpbUrmfs3nQGucSe9XtijcWnq1m77gYr7kE7QTlb8WvATAp9WXU89Nr3TSDXapPDc3BEtYahNOO+DtJR6z+KDm8SvwSEd8ioj1nUXIMaAOlWLOr/ZU4kH2KRGBdfJ8Qsu+do1vMfOzC7BKeG9jeG9Sco2tYEEPP+usQz5En/PRVoH/vz/tLLilFJsKzVLMNNS/dlWo8RPX5awvAIoB53R4c/RQpwvBBoQyMsab+XecFPBeG00caWnsP3yAAwv1fOyMnb8rRoYbZ1zGsYx12pCxwPxBnjlDWn9OuiGvYszOo4//B2XylwTM0/IqCgk3a8l9A88aCfmP4y9VuLbP1lrtbR1fcHfn7D5iKWAAw1c/DORUHbZ1rmF5aKAJwANmOhQKV/Sbp5EPRxwrXahXkp2L5j/6/yH/O6Is2DdIas4LMkbbqY6/dIRnaAEIjdIUSE1d7toBwBXHSu/gE2mLDAKQUlBx0O1/xM
 QVP/x0ob
 IINcNcDray4aAdBQKmsgWNhOlEgDE6sGGIbCWcNur+EVgi6o/D2+GnS/Rydg1O5+eHV46Z6deNapX8hB0RAMPwtTgWabjMw8rcpbBaWXd8UOi8mDr41a+RAYy+ib05Cn/WyRAJ7aolbftE2HoVc39Z3nslQKAosMzKbPAyakSyXjTS/fefsIceaMZ+0N/GBGMns6oU2G+3qBMpDwV4s5ngf4jln4JwidgjRkdqo67rr/Fg2MkzRzgGQdXn7EhRzijeaOutCINU+HcqfNQCoXpBytwPdYMQsXQy9sF072ngAvycuUDrlSWV6GRRi4eJImCU7q1MEEENiItd2TxzqD4Eb3tkWS53ccCLh+QG3eLcA68m82rdmG7/uUtd3jKRqJIvTV2jK2FVZJKhAjZOU7KoKRT7y2NevuQ0kVKir88AQ3fUwyDhPPLZMBZRW9ZpFrsOHdMlVgjxCMOLlaAKS3Q6gpYLDcQFJID4XSBD8WsmNSeEwAeRTjguTmcyrdxPUCZwsY7TWT91iMkTSo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <kunwu.chan@gmail.com>

When mremap() is called with MREMAP_DONTUNMAP on a locked VMA,
vrm_stat_account() increments mm->locked_vm for the new VMA while the
source VMA is still marked VM_LOCKED.

For a normal mremap(), the source VMA is subsequently unmapped and the
munmap path decrements mm->locked_vm, balancing this accounting.

With MREMAP_DONTUNMAP, the source VMA is left in place and
dontunmap_complete() clears VMA_LOCKED_MASK.  When the source VMA is
subsequently unmapped, VMA_LOCKED_BIT is already clear, so the munmap
path does not undo the increment from vrm_stat_account().  This leaves
mm->locked_vm over-accounted.

Undo the locked_vm increment in dontunmap_complete() before clearing
VMA_LOCKED_MASK.  MREMAP_DONTUNMAP requires old_len == new_len, and
only VMA_LOCKED_BIT is checked to match the accounting performed by
vrm_stat_account().

Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
Cc: stable@vger.kernel.org
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 mm/mremap.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index e8df5cdb0ac..37ea5ee1986 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1334,6 +1334,14 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
 	unsigned long old_start = vrm->vma->vm_start;
 	unsigned long old_end = vrm->vma->vm_end;
 
+	/*
+	 * vrm_stat_account() accounted the new VMA while the source VMA
+	 * was still locked.  Since DONTUNMAP leaves the source VMA in
+	 * place after clearing VMA_LOCKED_MASK, undo that accounting here.
+	 */
+	if (vma_test(vrm->vma, VMA_LOCKED_BIT))
+		vrm->vma->vm_mm->locked_vm -= vrm->old_len >> PAGE_SHIFT;
+
 	/* We always clear VMA_LOCKED[ONFAULT]_BIT on the old VMA. */
 	vma_clear_flags_mask(vrm->vma, VMA_LOCKED_MASK);
 
@@ -1343,8 +1351,6 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
 	 */
 	if (new_vma != vrm->vma && start == old_start && end == old_end)
 		unlink_anon_vmas(vrm->vma);
-
-	/* Because we won't unmap we don't need to touch locked_vm. */
 }
 
 static unsigned long move_vma(struct vma_remap_struct *vrm)
-- 
2.43.0


