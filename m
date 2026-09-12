Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84646C88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 11:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62D1D6B0092; Sat, 12 Sep 2026 07:08:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DE156B0093; Sat, 12 Sep 2026 07:08:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CF5A6B0095; Sat, 12 Sep 2026 07:08:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1DBC46B0092
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 07:08:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EB74E40268
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 11:08:45 +0000 (UTC)
X-FDA: 85204837410.16.E935F27
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4D0DF20005
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 11:08:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=T1gGisrg;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789211324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9WoLZKX+VYEAJ1h2MzFjGfo+B6Qip7pZn2KfalQNbIs=;
	b=WmX0xA8DDOInnUHSSup7PZ7BnEeUe7JWk/hyUw9RPXdtA2TFrh01fRaEvOm8yGa72kV+d5
	PAc+6mAY18Uu1niyD8sJv09l/t3PlRa3mKGzMKWLXZJhrYTTIeWgnyOIbUTjFifOfYhbgN
	EOQrl0W8M1Gi8XYsoaQaum75Z5ZJDvY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789211324;
	b=vL2XkdZBdmRmxPiYwLBy26cIy/iFXiRE6/gs40Bl3JV5AAQHvL5hHyDIYOqXIuRS57/R4T
	+OD8XAYdkGGopvPe9W9PHm8iJ7/4lH5S/ppmhQ6tvLzImukjS7QKtw/XGWHeTKC4UkWenl
	yM8KHp6jibGzQTcguZM0UVPE+Dwbg9Q=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=T1gGisrg;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530de452c33so9780531cf.1
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 04:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789211323; x=1789816123; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9WoLZKX+VYEAJ1h2MzFjGfo+B6Qip7pZn2KfalQNbIs=;
        b=T1gGisrglQUXoZcnirpeQBClRboluOCv4Pt9MOIvAaM1Gwtc4YupnBOrBCHhFogSyF
         bIkroPl9u8H8zoGmVhbAWjVsnMp+Uw5D9C5rnBRkDNhe8cYMASlqgHJ7KMNT+/iboVsq
         NY1MY+qWOgiPvo2jcQqBPMzpSkl0bH99RZxWRk71q5FFsyuig0+tlJHu3iQReKFxRBT3
         mOGFYdBc9DlgdIiIvOoOGF3dsRehIha/NMDILn1Pp38Oy1rgKspqZx00/HkNElWnZcIO
         TU6YBKSrq/CAe7s4rxF8Y1PiT12ca+linqXLSgwtT50x7mHm7m2NpJz1J9dCxO2+JOux
         lfiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789211323; x=1789816123;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9WoLZKX+VYEAJ1h2MzFjGfo+B6Qip7pZn2KfalQNbIs=;
        b=YIEsOw0KtaBdZobbx8sqPFIkjTbci1Jnw8+ravSRS5UtAtZ4rFfZu+3bpsdLjCEH+3
         t4HLDcTAzWlSY7xDmx38wlJwcR0CsDvjwIkHvv6gNwF6RWYbl3khi6Vp+ol+e2/6pwHG
         XfFmAgf7w3b76s/nEnBveqS/71VdUR0sc09dby3VlgT/cR7DlCmrVcuXcO7vmiJKJ/Sh
         ZTxEPWhYS0vhMG8bS5zBDFT8EQgAuT6zXETVFgVo9LP0aQl7cIP+d1bkTjW3cMoQ3o3R
         fzvO5auH+HMevt56a4+Z2GWOH3QILsUwk0gN4BxPcdugS1xKwpFp8cdySxlu5jkpPj6J
         +yyA==
X-Gm-Message-State: AFuF++kaAdSSfLrqRP/ycJrOrhZBNlMd9UZ+dYBCDzuOqKi589QizJtx
	lZ2Q51rnfd+wbedVDYtwtaiIzAmalWj+DXQiatgZehJ2wBCO6/oOLJq5tjlrfeeKnkuFnuZKTHr
	lnFA9
X-Gm-Gg: AYBFou3WYTgxrD5up8aOLe2bJuKFXm7RI8iDnGFqyVyICsn+bJmpH5sq8racIQ0zpAs
	vsPdEGRj5nX9maVGvKo1jNh/GtPL0AB+U6YQKy9MRb5EolAEv2mnCW1CNUs2sMh7DB3zB02ebKu
	mmL6hAoLENRkjSfY/3U4mR0XvE4XvC0PZWSoTgH2cfTSmB/cfeQFPNyFgzuM0WwU0DcyHqoA5P3
	JYdEIOdmofoK9kpIVUEs87E0wT3hjTO5ZY5wRQgrBC0LEW9q9uEssko98rVE1BWR4gtdh6q+bs6
	INVrZOaf++r6oNbPn5195yW9VC1Eez/1vp7b++MHQIZxWYeYBXSSDXPQWQCYIUlGEncDnSztpyD
	LNx49K5wdkE4Oz4Nn6aYfzdYhBjQ1W5l+qpcz8owVOYpR7FBUUbEKi8N6wPifG+cQPRfbb0JT2M
	IWyq2E/QTBFssmWzoOJqvq5dTAr3W745gUFJZLTHt+P4pc81LcItP4kUCwEXYKbedgyORiUyueF
	Nt4Refq6g8LU8xrGiNG6+1G/KrXaX0vFYjbDB8kWUPSYsZqV0PTJe3Q81pT
X-Received: by 2002:a05:622a:14cd:b0:52f:c0f4:5 with SMTP id d75a77b69052e-530c8569d2dmr120227601cf.17.1789211323502;
        Sat, 12 Sep 2026 04:08:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530d5e946a0sm33925171cf.25.2026.09.12.04.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 04:08:43 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	wangjiexun@tinylab.org,
	sashiko-bot <sashiko-bot@kernel.org>,
	stable@vger.kernel.org,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
Date: Sat, 12 Sep 2026 07:08:32 -0400
Message-ID: <20260912110832.3203902-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8k13ce3nzwiinwccm55tw3mhwri9m5o7
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D0DF20005
X-Rspamd-Server: rspam03
X-HE-Tag: 1789211324-371250
X-HE-Meta: U2FsdGVkX1/7VE0/c0ZU62Cjl/yDzWXIx+XuEM8CH3NHcnIbrDE06MrDquUn/QDKwvMUs0ilL94ordZmhpzaSY0PxQVlt0ayW1d48a7qTAwVmXl6dhKxhl+UJFP1APiaFvu7Tu90XyHC6xG0W90luBONPFqWH1bju/fu93Yxi/LUacK7KPx5eJ4z4lLYAuKZPhJsNWjERmPsyojQrlT9saT6B6gohsHI+QvUUsruwS44MIjzZA7n52gwk2KG4wkuXwpRlLq2YImuGnTXGi39SGesZOeqVNf08q2VQ3DV9qoClDxWh0IFrC1NZHkOOSpV3eY9nf//2KJwqPH7QforMJSfwuTIYOUD5+mETv8z7nBf8VGaUPu3r7fgQFub2eOjDNrq+t2LhwEdXzlnOhc+nPfX1liXtzM7LJotyBfYIRnS0e1+uveajW4Q5SLJhP9PG/gqwyusAGpG73ZoiMS51ncg9Cm8zX8ZI3NpoZBuS8ttg5uX8XVfoZ6PFjU+ehsfcXlChKz5bdBf2VMQrOZuOksPlYM1dvgyCEK6VgMOCSdaybDGIC2CyaxzqQ6ouol6kobD3fIGgUbqnSjVS77lKfIjl2Z6peSWvHPnZPoJDhcFhvZ7kU3VuRqaM5Wkkc2k8+Tw+mYSPybcACNKRK/vLD98ZTT2ckt3HDm19QYRbhebUDQNfhDvEfdtRMY7aqN3R2qFUM2rR69UbvD8pgjcSUT/ULBTMarCN8X/oQUiY0YaydGo8nHlkAcDP4ApJdejX4rYLGXDdBgnD2RMbuXJsw+Ji3I2mo4zXwU1PvUL5Jj7yjyyzXzZx6czB9AuGL2NsS2TIMcuCoMf7fLwP9z6Ls0pP9z74Ckd6jMJiXYSoyaLfi/C1Y++mAI7igx127Nja01bbFYb4UYguUcMSy4aognLCbdtLGmOfIeIfxEvvdOy4yG82X7LKVKy/OTNwUXkAWgDjqQ0xxmssyTfTKQ
 cLL0FtKr
 aA8h3eRdS6FL8fJjWutaU5zbxkMo1hsxGbyZaVngKn58TPdS8ftzk6xrVDiZ1eYMobp/c2PQ3HiXUgGDdEYZFyvz0G5yUcc8bng8XBh17yApagfvSbenA559x+luBExfZnDvw0pvHFCYIOwDXe6RNtnNjPAmgOEp7TnVbUE/jN+XIE8enO9SN/7As622EDRLrYjePrrmm1yzAe+g3QjEOp7nkz71uy25MUwBWENFZ3XfDsl2heDrb0UFgYOXawRz4/PaMux6NbDDb3mA6yy5bgK1peNGrU+xvl1T4QcozTPlk8hmUuPiTrcfB1pCrD6m7wXLjow7cqra8+ITR2wO+lnEILZjEjMNqtRgDfqNERMxZG0Gz6DosI70eGYKBq5NB3rDp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MADV_PAGEOUT collects isolated folios on a local list before reclaiming
them after the PTE walk.  The reschedule path drops the PTE lock and then
restarts the mapping with pte_offset_map_lock().

A concurrent operation can remove or replace the PTE table while the lock
is dropped, causing pte_offset_map_lock() to return NULL.  Returning directly
in that case bypasses reclaim_pages(), leaving the collected folios off the
LRU with elevated references.

Route the failure through the existing cleanup path so any isolated folios
are reclaimed or put back.

Simplest userland pseudo-code reproducer:

p = mmap(PMD_SIZE, ANONYMOUS);
touch_every_page(p, PMD_SIZE);
parallel {
   while (1) madvise(p, PMD_SIZE, MADV_PAGEOUT);
   while (1) {
       madvise(p, PMD_SIZE, MADV_DONTNEED);
       touch_every_page(p, PMD_SIZE);
   }
}

Reproduced in qemu trivially with some explicit widening of the race window.

Fixes: b2f557a21bc8 ("mm/madvise: add cond_resched() in madvise_cold_or_pageout_pte_range()")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260821150912.183976-1-gourry@gourry.net
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 574aa2bb7c7e..ba5a3d77241a 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -464,7 +464,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 restart:
 	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (!start_pte)
-		return 0;
+		goto out;
 	flush_tlb_batched_pending(mm);
 	lazy_mmu_mode_enable();
 	for (; addr < end; pte += nr, addr += nr * PAGE_SIZE) {
@@ -568,6 +568,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			folio_deactivate(folio);
 	}
 
+out:
 	if (start_pte) {
 		lazy_mmu_mode_disable();
 		pte_unmap_unlock(start_pte, ptl);
-- 
2.55.0


