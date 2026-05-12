Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2ADECD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E126B0098; Tue, 12 May 2026 05:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425FB6B009B; Tue, 12 May 2026 05:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C466B009D; Tue, 12 May 2026 05:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1F4696B0098
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:50:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A55C614044C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:50:42 +0000 (UTC)
X-FDA: 84758298324.28.E49E017
Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com [209.85.215.193])
	by imf05.hostedemail.com (Postfix) with ESMTP id E372A10000E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:50:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jEGky+Cw;
	spf=pass (imf05.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.215.193 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778579440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ONOFtYpxI6P6xc2JJjMFTYUnZhNOQ0Ff9/nUOO77MMQ=;
	b=r9FFZuwRyOn6b6pPKoMQqqX/bCSrU+iwduRL3Gr1gdwizJOaot3yQxwY6fgMl1XeHd7LFN
	fFKypoITbFuxAXJp7A5xtF+P+39nTQa9X9IFoHaFxlrVMV5PiM9B8P/UIux2wDBsOYFo7A
	j/msaZIEt/b9S4AzgzmTKn6mEUEhKaQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jEGky+Cw;
	spf=pass (imf05.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.215.193 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778579441; a=rsa-sha256;
	cv=none;
	b=4x1/CCSbOcrIktuTCIH5X8jgAAiaJzPym3IWPBJocxfg2846jLlK/31ctEozbyNxO5z/VJ
	R2yafyspD1rJAPVSgqOrkSckue5sX2RAEtoyjLGZhoODDl8ELz7LuVtiWQ+GoB/n1b8TZa
	F3hBaN8BMyUpFog6OLGPeNnilfcX/00=
Received: by mail-pg1-f193.google.com with SMTP id 41be03b00d2f7-c7ffe8eeaf2so2185707a12.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 02:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778579439; x=1779184239; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ONOFtYpxI6P6xc2JJjMFTYUnZhNOQ0Ff9/nUOO77MMQ=;
        b=jEGky+CwQ7e5rWJSCReUnmcG6g8Z2+CEB2vd7oGKhPzaM123Fl0ThZnzbpbfBRI7Hw
         HLPY4Iv0+41OPXhGei8kiq+smcBlu5kriB0ol0pEB6oalT1CzQNeoQ+83Se6LToiuznN
         wAHnuTuZkpDFqv0+qgLcqKeQZzoljRQw4/6yYOhvgyLye5nQnfBACPTSGnppdWnO/XDQ
         JcyPo6duOdSQpGalov/CaVQO1nAknaj7ARkOnyGsBNXknJ7FOXt8vOKHV9k6MQYcVkCl
         j5ka72Oubest4iW8rS/itUi7tkWpNf1qOBJc2u3xSB1F9PCICq/KiPE77T+BtSMUZpN0
         12KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778579439; x=1779184239;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ONOFtYpxI6P6xc2JJjMFTYUnZhNOQ0Ff9/nUOO77MMQ=;
        b=daxroLITjmlBS+TTPvEA5SWVQ7DJhJnNyY3a9sSOZQpjmYzBSOtM4BEPUh7QSy5A4h
         voOs3aMt9JM4AEmgbi+0pF7a4PloFNHJgcBYDyLXKYh/r4ZmhS8x3dIArvkvvWnS1bDq
         idB+qLWPff2H6TZOxMIZpLRD0li0b9xXefDjwXOiiqAKNwFKgRixQ/BA4am+DsWRi+ld
         w8poI6e9hchbOJBDaBhX9IB+HIbb356mWtLkq4OaEkwk170bdXYvihG0Au9xs283IQm6
         h9HJ607q5I9FFiIM4QEhUalXekCW5DfNLUls48oFpuXvSuEsgZ/Xv0KC2+RvDLOu1liV
         LmFw==
X-Gm-Message-State: AOJu0YznyfQt3v98Hkbkcw7NO2f+Ya32X5yMPHfUuHbtCfCBOrnlz7cU
	J6TkfXczpD9iNelZXKqJzVYAsbG2RuEGOld/rqnIXjWsoHlkaw7xZ/d7B/DQTpVG65KEHg==
X-Gm-Gg: Acq92OF9Cm53LiYQD3+zbOdqOtUaqGOfVpyvf20m22IsyFtvgfxjjEhiB18I8r5TibT
	z4c6H2kUSYqunFFZ59Clbwig7ueRL/0j7pZQiR8vHlSZt+cZM3gxY7aEN6L1fW0mAX1Th6d20jX
	GVi6MT9TbtD8mQnFkPwFDSA8Idlh4hEDatBKgjdrcAbgUQ7x3/hJAfK6tmflCh2YownZv+f4qpP
	UU2zohdDqyjHjBZeGWbtQfO4VCA+LpAMp23eFyc5uoYsllU+Yp3R4F1cD9EF8UJUG3aOidOkLSF
	YFF24G/UVfVy7GqLc1WRHblS8/h9CTl0BfHycdOJto0kkwe9jGO+Ei/j3YisHfwFM3f7vhYVAI2
	bxUQG46zEkAJ7HwFFtQW9SUYdosM6wsCGIRU4c6dBig6vl8n/DfjOw7PNiGDIraCDWgKLXLJJVI
	CFzB9I7aXaJ5rMa1EhlNSRoVMVLQnDHQQqHl8cOQ==
X-Received: by 2002:a05:6a20:9185:b0:39c:cdb:5d78 with SMTP id adf61e73a8af0-3aa5ab713c6mr29960557637.36.1778579439147;
        Tue, 12 May 2026 02:50:39 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83965945101sm22238484b3a.13.2026.05.12.02.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 02:50:38 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
X-Google-Original-From: Wandun Chen <chenwandun@lixiang.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Subject: [PATCH] mm/memory: avoid unnecessary #PF on mTHP allocation race
Date: Tue, 12 May 2026 17:50:31 +0800
Message-ID: <20260512095031.1333997-1-chenwandun@lixiang.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E372A10000E
X-Rspam-User: 
X-Stat-Signature: mt6rggjhfyj1jtjinwz5icymrqiwxxhf
X-HE-Tag: 1778579440-246404
X-HE-Meta: U2FsdGVkX1+YN5Rwfug1ZgnFfXMLgBHQIhHAPgxISJMW2i561wsl9J8SALPZ+i0cZe9LKZmHnLORVzDWpHHkW6cd452AEL/fwgCIV4mostDCyco8qTYV1lRrCHvJwxnQz/2RbV8WCSBzsciQBgPJN+qkOrDH4+mXrO7Uo26VTkQVh0ggL+qij1/3lW0NwweMoT2B9yRryXXnaRUf5cC7M6rd0y9DQ7RBw0yWQ056Ha3VXmFHooqMtIGhUH+n0ABVMyDIUdPWvmshC6dQhun9yjzjr0OzPSV99srUHitQK/IvVzrr2NMF6IfZpkz1zEsEnjfx7dmUq52vGJ9zrQdrm1qCXs3l6SxTrLk6mBis3aekMs4KS3OVciKmET7W6R2KKxB3PomBoccqFaVvdWNb0202enmQrhOL4k2FyfXPnhFDGmsxqWqUmI5N7SXId4YlO6bntNk4u5yhjYQz8iKL1d0hu73wHrD5MWCON/Gr+3nYMunqPlGFNbOSxUb9ga6Yf5uUx370rLtuEhz9cJSbZF55wHWpzgs1eVpsy7drNAD+SWK9903xxrBRGkgEYs7V755U6IQOBd+7hdJxJX0l6Ticyd1GCpkkxBn0cw3X6aUzzBWog5n6QRAPaHEksBwPS3bTqMEqICcRC4m9h3RVdMbfb9wVKIVfjsAypBgTuPP75u9/RfYgkqBjYGtwoFbIGZDMxCtHm1VB5bAEddgRGP5gQ4MBK05pYmDj1W6Wsgw+OPLZ6mEqFym8zJLJQ4R9yQvJWAAWQBelYK1ZkOTVwc+J4WqIyjgj2ZU5FhT4Rfk/OGkd4GHbn1JK6d2BMjddYuyGBAcg9Y45UsyS3OFDwDup7Bu4y5+/nmKYgfZix6y5+doXglaPIitzwTsH9AGvQH4slLyeOhKQB1bhSkQUARcaW24ox0dNiaRCPoB6ypigI+gQ4oZKI5Tqtzyln2GrJrBNKQuk7ouMFnM3dK3
 Bb/sS3dU
 sV0xMHNjVUaHQqCS26ek6YGEKGDWl8z4bOIaBUuwESzxiZIX5v8t73MLP+0CjDsDY7S7bJ5ZJifWEdb5KWtdEKSMEfu0dWGzUnPtx37IPhxDR6Z7C1kf8YKKFyjYHXqY4le8TTk/i+TmaKaCr4sDxoPJwMmQr25iteeQAPS1Vi4UZN/gfrCzR6LKYp41Hi+1K/Vfi7U7nKYJi680xgQ2XjyV6wYMphthQR2Bw2/zBpbiHOd/cNHeNIjbtu7vLbdCflAlYUuywHptFZifAmqH0+c7qIdBkxVrJPNYsyy+hIZA6APJ06E/7cI6R7Z96PUvYrRTwpVzxeGSJothm4TPfDxkd+1taDwlQiAsdj1oYomxr6/qOILt4Api7bOmy2yWNPRP0S5jONtX43QuAtXIki3ABTlF4bnwAKxJrllFyDnU78fsqV5rPW6zg/m6IVOVor8afhId2SrL97PIZXzZflLeDgURcGQ0dKDufkTddkRhLUU5I7Zqjg95baA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an mTHP folio is allocated in do_anonymous_page() and the target
pte range is not fully empty, current code would release the folio
and return.

This results an illusion that a page fault has already been processed
even if the fact is vmf->address itself is still pte_none(). Another
page fault will be triggered again.

The race scenario as below, use 64KB mTHP for example, two threads
of the same process, base page 4KB, range = [X, X + 64KB),
X < Y < X + 64KB

 CPU 0 (writer, faults at X)            CPU 1 (reader, faults at Y)
 --------------------------------       -----------------------------
 do_anonymous_page()                    do_anonymous_page()
     alloc_anon_folio()
     pte_range_none(R) --> true
     vma_alloc_folio() --> 64KB
		                            pte_offset_map_lock(Y)
                                            install zero_pfn PTE at Y
                                            pte_unmap_unlock()
   pte_offset_map_lock(X)
   pte_range_none(R)  -> false, Y is populated
   /* but pte at X is still none */
   goto release
   return 0

In order to avoid this, check if vmf->address has been mapped, if not
mapped, try alloc_anon_folio and subsequent operations again. On
retry, alloc_anon_folio() re-checks pte_range_none() and falls back
to a smaller order, so no infinite loop situation.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>

---
Reproducer (not included in the patch, available on request):
two threads hammer the same 64K mTHP range, writer at offset 0,
reader at offset 32K, per-round barrier, 1024 rounds.

  Minor faults before: writer=1951 reader=973 (927 extra faults)
  Minor faults after:  writer=1024 reader=1022

I'm not sure if this situation often occurs in real workloads.
---
 mm/memory.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0c9d9c2cbf0e..104f5be1de36 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5339,10 +5339,12 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long addr = vmf->address;
+	unsigned long fault_offset;
 	struct folio *folio;
 	vm_fault_t ret = 0;
 	int nr_pages;
 	pte_t entry;
+	bool should_retry = false;
 
 	/* File mapping without ->vm_ops ? */
 	if (vma->vm_flags & VM_SHARED)
@@ -5389,6 +5391,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	ret = vmf_anon_prepare(vmf);
 	if (ret)
 		return ret;
+retry:
 	/* Returns NULL on OOM or ERR_PTR(-EAGAIN) if we must retry the fault */
 	folio = alloc_anon_folio(vmf);
 	if (IS_ERR(folio))
@@ -5413,14 +5416,26 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 		update_mmu_tlb(vma, addr, vmf->pte);
 		goto release;
 	} else if (nr_pages > 1 && !pte_range_none(vmf->pte, nr_pages)) {
-		update_mmu_tlb_range(vma, addr, vmf->pte, nr_pages);
-		goto release;
+		fault_offset = (vmf->address - addr) >> PAGE_SHIFT;
+		if (!pte_none(ptep_get(vmf->pte + fault_offset))) {
+			update_mmu_tlb_range(vma, addr, vmf->pte, nr_pages);
+			goto release;
+		}
+
+		should_retry = true;
 	}
 
 	ret = check_stable_address_space(vma->vm_mm);
 	if (ret)
 		goto release;
 
+	if (should_retry) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		folio_put(folio);
+		should_retry = false;
+		goto retry;
+	}
+
 	/* Deliver the page fault to userland, check inside PT lock */
 	if (userfaultfd_missing(vma)) {
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-- 
2.43.0


