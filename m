Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE4DFCD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 14:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE6E56B0093; Mon, 25 May 2026 10:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C979E6B0095; Mon, 25 May 2026 10:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAD666B0096; Mon, 25 May 2026 10:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A68FB6B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:50:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4C6098B68E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:50:04 +0000 (UTC)
X-FDA: 84806227128.19.5CF746F
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6FFD740006
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:50:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Oo+AYvPq;
	spf=pass (imf17.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779720602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ucSIcO4wSAFyi9/y+041p6DDmf5uXKO9TV+iwW1k9vA=;
	b=FD1jksr68LQqpLhOmc7keRGcIRnd8rJDTHUCN+O2un1oPUvEvMyHl2M0Kl8VFMPyPNwoSH
	NQ5z21JiJqk9P88j58uYChTlGkjxJhGyHRwAInEU5MMdfxwZ1bKdep0MyE7yTUNQAT4sGa
	rpYw8tXX8Nnc6sCspv2/zRNalQWKDuI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779720602; a=rsa-sha256;
	cv=none;
	b=ltn4o5ZNXDAuhVsxGuu5pSZo+FnRokLFt+NZY4acp8oTX4nO37/Iuj2nr0P+Q3rY25WZTM
	J71sOErGo7XLmHS/v8opaQD2g8d+KKSpBzcP7ek+i0dFOxmWE5Bsg6QQpq4v3+fGAX+0iu
	LouCQ1Piyq1yV0J0EdFbv4/5HhgqcbQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Oo+AYvPq;
	spf=pass (imf17.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779720600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ucSIcO4wSAFyi9/y+041p6DDmf5uXKO9TV+iwW1k9vA=;
	b=Oo+AYvPqrAIfQRtBUGJfd+uwofEoQLg3o5NYKUA9HU5F3C11+79MpXYtD09oGCda9IXWie
	Nk1ier+Va67B/2ajvHBSf6VzwAZMaMOeD2xbS9N8Qe2muSc83QHoqk3eBD/l48MmDCnWBD
	fpXbWl/Gg6JYe0b1dSMb8eYMff8GQcw=
From: Kunwu Chan <kunwu.chan@linux.dev>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <chentao@kylinos.cn>,
	Wang Lian <lianux.mm@gmail.com>
Subject: [PATCH] mm/damon: fix stale TLB young-state handling on arm64
Date: Mon, 25 May 2026 22:48:46 +0800
Message-ID: <20260525144846.604907-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: ya7z7diyj935wjnxaia83gb8rqzsj355
X-Rspamd-Queue-Id: 6FFD740006
X-Rspam-User: 
X-HE-Tag: 1779720602-49900
X-HE-Meta: U2FsdGVkX19mkC8FPn7n6h9txAnjcquEGzdA3hl2CgsCiA2rn7Xtyex33R5zyibWPPl2NWNPUG9OOGh4SNLw+UcCfOO/CZONPSR6PWxaj2n2DbkPuwZ3NxbsekIyWwGgBZ6VqDx6p6lh67tI/evc0WH4ob7xliNAK3UqotOh/64OxLGeIuHa/5O5zIwRy7sJXZNjiW3P+i9DvPkT0iqeQPdTLKZ7hqlwhdhX4z3Rx6VS/8l1FbrSEn9cUxGKPcbr4BtHqC504+mpF/9ZU6sB5gWZpjP64AbiEos6rEOu4pdp/iIh5n19zWmOIX37zpjw6Nu5UdV0GThsH01AuXEEcdzjBHC8zYw02MxojnQB6mxQnW8xmZFrxLe30bWkOzOk9uxBKGPhSVvdYf9DYW+a++/1a7LhqChNd92GmM+IR+OSTSFH2IA/6iAUML5wqxuaGa2gnp5bhx9W5otsAnRix/OI9l+nV8ryc5BGAgQ+xANIP7OCIs/K08iz3YDI8txXWD+79L1ohTWFZItO9J1/vbuYBkRI9/aPYg2hwqFrdCHepfgXxgLuwdY6IpltQBKRqA1hdxCaGVFwuNg4tVbgXlVPSpmmRLggTgteFFR7Vo8xA3djkXOJOfrvi7hnYllTcXjomxSWzuxydTnQfvJMbEYutkItLcRwDGy0SJZ8gLQzQ2nLYa9GOEuTRPjSeGUCAdl4irGA4Kb4y+D24BV03LPpblTpcysl4S+MDJ+AQVz2asKYrj59f1Jto2ilqtK/W7/EBjWEgEejGfqa5UN1gArTay88a+xG7gevx2W12U+867nhuf0YTj4cogefrEd2+PtQqLsJIyrqOiUg2CYlH62gh6luIMiQ380Uf3WjOwXrsh2/GmQFNhMde44/tvM8gc5Lhq31AoGyZqo9eIMxQKbTeVDEvu++xcOJ6y5P9vbHI/LoM4J7YoFBE7jjmGvQDLX594nC1rUvy5v66sh
 IDm8xjKj
 atMp99IGNiRPGiZGorgwUlRZhDxziBlj4HJ4ZMqWczaHDu3OS31EnOBOHslQTG0poO2NlftVsqCl7SU2ZtHFdCoGG2faUxFbhYEj23+ZGk9STYJqlUXY17hVeyOdl3j6r4VLDzzR7DCQ/uzUHu+jLnVTgSF5S5pfGl8I0f+p0p4Advb4zHfICFQWZenFv9E9M+LgxPggzEMA+bvQcaZ3eyX3FnZKJDyqzTWsDc8mlfdkqsB09A+antjqOR/lg8zwwrUxQyKLQrAoqSIY3N5uCPozEdDasIUtXWyIFKKVlEXjjpgZJV3BiXgyIsaAcFB7s3QSYeGMSYzG3xyA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <chentao@kylinos.cn>

damon_ptep_mkold() clears the PTE Access Flag so that a later
access will set it again and damon_folio_young() can observe it
via pte_young().

On arm64, however, ptep_test_and_clear_young() clears AF in the
page tables without invalidating the corresponding TLB entry.
Subsequent accesses can therefore continue hitting a stale TLB
entry without a page table walk.  The PTE AF bit stays clear,
pte_young() reports false, and DAMON treats the region as
unaccessed.

folio_set_idle() does not help here.  It updates only software
state, and accesses through a stale TLB entry do not clear the
idle flag.

As a result, nr_accesses stays low regardless of the real access
pattern.  DAMOS schemes fail to match, WSS estimation reports
zero, and actions like pageout never trigger.

Fix this by switching to ptep_clear_flush_young() and
pmdp_clear_flush_young().

On arm64 these perform the required TLB invalidation after
clearing AF.  The invalidation is deferred, but still sufficient
for DAMON's sampling granularity.

On x86, ptep_clear_flush_young() is equivalent to
ptep_test_and_clear_young() for base pages, so there is no
behavioral change.  pmdp_clear_flush_young() additionally performs
a flush at PMD level, matching the existing x86 implementation.

On powerpc, riscv, and s390, the clear_flush variants currently
map back to test_and_clear implementations, so this patch does not
change their behavior.

Reproduced on arm64 (128 CPUs, 7.1.0-rc4):

  before:
    WSS estimation: 50th percentile error 100% (reported as zero)
    apply_interval: schemes never tried

  after:
    WSS estimation: 50th percentile error 0.08%
    apply_interval: passes

Co-developed-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Tested-by: Kunwu Chan <chentao@kylinos.cn>
---
 mm/damon/ops-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 8c6d61342..33d689c14 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -63,7 +63,7 @@ void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr
 	 * device aspects.
 	 */
 	if (likely(pte_present(pteval)))
-		young |= ptep_test_and_clear_young(vma, addr, pte);
+		young |= ptep_clear_flush_young(vma, addr, pte);
 	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
 	if (young)
 		folio_set_young(folio);
@@ -90,7 +90,7 @@ void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr
 		return;
 
 	if (likely(pmd_present(pmdval)))
-		young |= pmdp_test_and_clear_young(vma, addr, pmd);
+		young |= pmdp_clear_flush_young(vma, addr, pmd);
 	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + HPAGE_PMD_SIZE);
 	if (young)
 		folio_set_young(folio);
-- 
2.43.0


