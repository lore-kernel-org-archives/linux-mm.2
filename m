Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1037BC61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 03:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 240216B0088; Wed,  2 Sep 2026 23:17:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0A36B0096; Wed,  2 Sep 2026 23:17:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107866B0099; Wed,  2 Sep 2026 23:17:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E156D6B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:17:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DB2240420
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:17:08 +0000 (UTC)
X-FDA: 85170989736.20.6F95670
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id CD33B180005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:17:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ER3Tiw5I;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788405426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6Ry9aZAR4rOnvuBv9WAZuiM8CW7iBdIw7/zNBIgTZE4=;
	b=4I/zaI0CRZB4Ay9URlzbaI8RvBhXMqFYfZQ/9F3jK1LfyKOo8KbYrjLvvUUt6VZfB7niua
	6HhkJcY1MgK7W6PIpiNBPOWJ90BR7XcgaJJnqjm0KdNfmePQCKIF5y+9K+zxJmi0EQvJMW
	Us2nTGR/wroStJc6v/tfVVi0vhS+768=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ER3Tiw5I;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788405426;
	b=HIzXYyMb42/9XYpNbV+TCLjuXoFFUq/bjyFWtQd0Z10Uw8KxW6kqrG8QPuMz5zguqz7c7z
	Wz8k9NqjxfkdSTx6iNQFMJB0KlasAbyMZRMJMVhFfy6Embi7bG1YU06DRQ1JjfzMDFp9Rw
	UP7eNUrG6jWLZEKW56riimTnwmxoF2g=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2d71a50caa9so25068835ad.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 20:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788405426; x=1789010226; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6Ry9aZAR4rOnvuBv9WAZuiM8CW7iBdIw7/zNBIgTZE4=;
        b=ER3Tiw5IIAdf/+xk8uaKMP70VXB/SHG0pQNz1nsfvj7B0dkbEtQ9wjCpcAcAf1PQhT
         WDpO2E9yGleLeqtThbwJbyTAMWHGF+EVvKBnntytz2kRkxgk/bgNVmBXkR7hH4VSoWty
         wi3HDldy/iFoHrwTWuZ5EaydL9NLf2x5neQtfl3RESnTPmpDn2ZDiDZ1A/k/RpfwxZ4G
         wDUR9yAOIuGjEhPuoj9A83x85RDB5GSGoBS2YJCTl2Wg8ABAm/rBBQ9yAx5rfmoxRTkn
         49Q7Du+yoA9qbycgs+8XNop325yHBuvl1pJ5UFRhlfb5N6+59JJat8aunhxQorfWB7w0
         gy5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788405426; x=1789010226;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6Ry9aZAR4rOnvuBv9WAZuiM8CW7iBdIw7/zNBIgTZE4=;
        b=LlN8iPrgSe1RgSwpdMx43wC4O1qKxoVlbFoQAzcDVslkqc+KNzWODqcxO2DmDeNG4i
         xwqbqawbEYHS+6IoMYadVd63KAwYkAT8AhZQPRFAaB3ynMN7jFD+cqDoKHuxg40aH3Gi
         wfeqGAosNoSWQxvKyF0bY/BZN7jNrB4dwPGDCUtVcaxJHUy/GV5OMSDH3i9IfXNYj6mO
         d7iWEbKbF51eTR+zHXGAbAaQkryiBJdmYf9hjj5Kl0e0Zos/yQon/8+pF70FKxHSjXVh
         GGPotT+hoZgB4bKOO5F2ECUBnV2WIZDs/iqltD0GjjXsaxwxMQfXb9YdIKnnArIGd76B
         K/Hg==
X-Forwarded-Encrypted: i=1; AKwUvBwFK5GBvFZQI9sHMFwGpcFOqDjRaSPL6JsA5yv0Spw8K/SEnby3qJU5iGsC24rXNNr2ZiQxbZbdUg==@kvack.org
X-Gm-Message-State: AFuF++nH8tXEVPd5Gm3HQj/TxekIBI71GURF/yBv5o14qsp98sNGb0jK
	cEN8ZITxpuGmdYgYr7iaFgVHarJZWIgg8q0C2ia8hTbYmAJQolTngEWj
X-Gm-Gg: AYBFou2po6cOxzdKT9EvHAempEKxnHKnT9JeepY2wUpu37eTKQOyWzmozc1V4FdCRQB
	IfNQQH0pW5smXx/OaYWWLvrB9JkPC54t2io/fbjKG8Q5XSeUS/Yp5tX1MBuYQ9zKe8U1Qc87Lf3
	zgXEV+gRZlDj+Kt7z9nlqdh1GlOZ11zuvrIS3te+VPbIfoaekd7AKAP2sKv1cnZq1LsL2EILueu
	NOmJMhgy7ZdwoA58jEUDXMOZ9GVDaJHiZPS/qCO7EgCaMO+JOY6hLB4nGckuYJFQNJh+f7VAPPE
	uwT8Bklmt4K8M473Bd2Rms7+1A1qJsvsKNSH5f/rPK8g+m2bxNdo4pslbqjwqSVxXCPGvWP5AML
	8/VVkPSlsFKy1811cNTstGksso7hrS6YOTfQayjYYgv9AFauZBrQVfCMvJcCDXfMVrrEtyviStH
	/DnBtyp7OhvHwNZU7wgp+Rg5m7bU16UuE1cY9hj4NqigQvyT45DZ+jy1oQ6fiBMbsIIJfKty+dT
	9g=
X-Received: by 2002:a17:903:2290:b0:2d6:ffa1:429b with SMTP id d9443c01a7336-2daec62c280mr119641375ad.7.1788405425604;
        Wed, 02 Sep 2026 20:17:05 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dafe62d1d1sm2831855ad.24.2026.09.02.20.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 20:17:04 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: hpa@zytor.com,
	rmclure@linux.ibm.com,
	andrew+kernel@donnellan.id.au,
	pasha.tatashin@soleen.com,
	kas@kernel.org,
	tj@kernel.org,
	rppt@kernel.org,
	rick.p.edgecombe@intel.com,
	yu-cheng.yu@intel.com,
	orsonpeters@gmail.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	Vernon Yang <yanglincheng@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] x86/mm: Fix pmd_modify() dropping the dirty bit
Date: Thu,  3 Sep 2026 11:16:08 +0800
Message-ID: <20260903031608.1194238-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ujeryhuj19gisa9dhfx88zfodzus558x
X-Rspamd-Queue-Id: CD33B180005
X-HE-Tag: 1788405426-702331
X-HE-Meta: U2FsdGVkX18whVAif9Hza+3NrM491jqmvgU3X1aR7RcY5LHtIA9a8NVEGDtpPBmoM65fGw0qpPP8renJQ+OsyZVUAm18bJ2tLHx2p5KkpAqZj5j/8ZTOIsbVvFZp1n5BQPTjUmZDiorjKNtqBKQP7elzX/4Nt571VwBD/i1IvR39wi7lHLTZmPbNOAZ0h2daH+8OhjEjIaBXTGmXuNkHGKJTGPY9vbqJ0qF3Z1lqLPYIgAVe6OEA/HnFBa4YYv7qfqJrO30RKJt2UA4bWi9W2K0fz5QmL/9kPXAVuahpcnuIUGIG8w/DKCrbLRHcASpL4OC7x1M9ylxrZeVwCaeCKrlGFnJOPE2pj7hSvczO2FwRstrp+kef95eiBP6KSNQUcXCBDzU2x1uwiA5VHYi9hOICihakQThejLtS2ZxCVa9i+wDKBE6iWQiYX5lgVlfAGaSotuy1uUgk3OSoiUE1ZqvadFeb9OVVAqUzityhlsgi6r5mkrZQyUMN1NGkGw9zxW6KlmqGBYjjKVT+1wwdM5PBIkfCC1nYaoDnkKWJe51TCUfpjgbUPrqPmCasCiyvZhFfj9V/yB3gX+NSbmFpa+ecubasGOATHUXehcGzXQQr5+PIRQtuLCbdOLlvwg9eEPzbBxb5Dr80MSBkKy2kNCXHx5NUjlfjrLtmkwZ4lzih2LHey8deNUkSziQZdMMQGnsuYn0ObDzH8niyc/KuPGBkqufVP0PbHKCYjr1caJAqhuYvLexrvbpcp3FomibfoU2Aw6VY1V48sgNYI7K0amXgVawxeFiT7vNvIcQwtGrMYej044pOpmPIQLO/FOm4gVDujhE6l9CdLMqkH5pvq34Tl2UiBNiddlIbNewYtqt3Egx/oKigYNP6i9rLwhn4kLX3bR+1mU+noZ6VueB774xRA1DwXhrLI+SHAYW9fUV60M/iaUcldBq/2Bt9S6SOwRfElTv/dCC4veDeKQu
 eb7w/8jI
 bnBRMcKPKOj/TSKvarkl7VLGG5SCQQJxMmCfWMcAHWxwOMuTqq6on6UsColyENkQupTEjoHmTYmqrJhiwrIb/UvOe7h8LCRxx2+pCFjLgaCQip7Rl6chFhVDDGgU/H2YhxfY4OVQa/KOcP8WDZnT5pi4jz4A+iXpf3YMMVlZ7tZSMroY5Ipm/44btBTDF03cpDaUKPG7sWZmOKngyN5FVNa1ho+5k00nYezUVnndISfDKFODIrteoeN8VfyB481jpXSPctEYbsM8ZcJu2sIs9CLMpRbceW88q7BP/dbGKsKAlGEaUoxtyXtlHYeTRP++B4LRxB5Ho8fDvoXB5kQ3tPP+zeCqJvPTcO6pCBviY0EZ7nMFi1lQftxvtOrhhpycU//yhSEZwLA+ht7kCjftFksgICqBj36rrnFUo4rmjGGCYAQ9S5dumQmtlfQNb/sl0c6ym/xYgi4jzLCD4oAiE2+EID2zJ9yZu+TxmvlV4n8jJUQFLZK6RnamwTLBZrzDZKoQLIJMQ3RrLKGiMy3GMHoFMIhtkwhFdZskBvW7z5plVMt1mZ3u1tAoOUm2rZkFNm6LGo3GZ5wIigCTNiJjjdQyy7vPCblGmzANT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

pmd_modify() masks the old value with (_HPAGE_CHG_MASK & ~_PAGE_DIRTY),
silently discarding the hardware dirty bit.  The subsequent
pmd_mksaveddirty() call is supposed to transfer _PAGE_DIRTY into
_PAGE_SAVED_DIRTY when write-protecting, but the dirty bit was already
stripped from the value, so there is nothing left to transfer.

Contrast with pte_modify(), which keeps _PAGE_DIRTY_BITS in its mask,
and pud_modify(), which keeps _HPAGE_CHG_MASK untouched: pmd_modify()
is the odd one out.  Any pmd_modify() on a writable, dirty PMD loses
the dirty state.

One visible consequence is data loss with MADV_FREE on PMD-mapped THP:

    memset(buf, 0x5A, size);          // PMD-mapped THP, PMD dirty
    madvise(buf, size, MADV_FREE);    // PMD cleaned but left writable,
                                      // folio marked lazyfree
    memset(buf, 0x5A, size);          // hardware sets _PAGE_DIRTY again
    mprotect(buf, size, PROT_READ);   // pmd_modify() drops the dirty bit
    mprotect(buf, size, PROT_READ|PROT_WRITE);
    // ... memory pressure ...

Reclaim (e.g. under memcg pressure) then finds the lazyfree folio with
no dirty bit set anywhere and frees it in
__discard_anon_folio_pmd_locked(), even though the data was rewritten
after MADV_FREE; subsequent reads fault in fresh zero pages.  NUMA
hinting alone can trigger the same loss, as do_huge_pmd_numa_page()
restores the PMD through pmd_modify() as well.

PMD-mapped file THPs are affected too: mprotect()/NUMA hinting dropping
the dirty bit means rewritten data is never written back.

Fix it by keeping _PAGE_DIRTY in the preserved mask, exactly like
pte_modify() and pud_modify() do.  The existing
pmd_mksaveddirty()/pmd_clear_saveddirty() pair then performs the
hardware-dirty <-> saved-dirty transition based on the write bit,
preserving the shadow-stack encoding rules.

Closes: https://lore.kernel.org/r/CAJxLxMUGu1-L+O_nAONOwOXnS=cNbNApCWqdthRjd76LThtSPg@mail.gmail.com/
Fixes: bb3aadf7d446 ("x86/mm: Start actually marking _PAGE_SAVED_DIRTY")
Cc: stable@vger.kernel.org
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 arch/x86/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index d5f4917c1edc..d551120a7c88 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -806,7 +806,7 @@ static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
 	pmdval_t val = pmd_val(pmd), oldval = val;
 	pmd_t pmd_result;
 
-	val &= (_HPAGE_CHG_MASK & ~_PAGE_DIRTY);
+	val &= _HPAGE_CHG_MASK;
 	val |= check_pgprot(newprot) & ~_HPAGE_CHG_MASK;
 	val = flip_protnone_guard(oldval, val, PHYSICAL_PMD_PAGE_MASK);
 
-- 
2.53.0


