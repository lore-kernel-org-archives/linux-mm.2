Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C54C4450E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:57:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 603E76B00DA; Wed, 15 Jul 2026 09:57:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DA686B00ED; Wed, 15 Jul 2026 09:57:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 517496B00EE; Wed, 15 Jul 2026 09:57:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 300A76B00DA
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:57:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A85B8A010C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:57:21 +0000 (UTC)
X-FDA: 84991163082.15.4B22C1A
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by imf23.hostedemail.com (Postfix) with ESMTP id D636914000B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:57:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=e40lC7Oi;
	dmarc=pass (policy=quarantine) header.from=morinfr.org;
	spf=pass (imf23.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.2 as permitted sender) smtp.mailfrom=guillaume@morinfr.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784123840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=G7VxAEwsvMZYF3YHhiMlCegcO6deIqLt2QOBSrhF7qQ=;
	b=4asn45+6Rbz9h1kfjINJA/RSphf8oOW6sR/59AHWN9bVai+Q19sRtL7mga0UzqDPtakuhF
	ggZPsuvqL89ExGizvjBOwDxvdcbwS6mquoregeoCvYfiy4BTyEkrSeTB5XtqFXXXOyoRrR
	e/C4grEPD5rafaHWQXDi91lBd7hbjKA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=e40lC7Oi;
	dmarc=pass (policy=quarantine) header.from=morinfr.org;
	spf=pass (imf23.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.2 as permitted sender) smtp.mailfrom=guillaume@morinfr.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784123840;
	b=W+rkmRnGiwtx5FYTutL5gmdkt9n8e8/G7ka18yw9WrdQLQvp5JjFP8Oby62ihR8Ph2uR54
	Jm/VSTmF/Iv8cgnTNgm9fXnSU2kb/n8SdEmGsx6lIKAZlOD7yVYDRstlrrrik0PHt3hBRO
	fbHF9a8wToQSXJlG3hJ65tTuCEpKKIQ=
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp2-g21.free.fr (Postfix) with ESMTPS id 014092003CC;
	Wed, 15 Jul 2026 15:57:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=G7VxAEwsvMZYF3YHhiMlCegcO6deIqLt2QOBSrhF7qQ=; b=e40lC7OiMIGEEp0UqWtjtCx3UQ
	CRn/QjINObJwgXfhDXwQWGc8Qtm1mXWyKm8Sieo0yLNokLqVOvdCL2yKaJ6hxTsT4itLT8M7wnNP8
	vR0w7WVklfRI5oS1qEhGw39ilX5uMBxb1jvReRcVFhbYR0/EYXxqlIrM0lfm0+Z1vZe4=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.98.2)
	(envelope-from <guillaume@morinfr.org>)
	id 1wk06r-00000004FaQ-1OjY;
	Wed, 15 Jul 2026 15:57:13 +0200
Date: Wed, 15 Jul 2026 15:57:13 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: linux-mm@kvack.org
Cc: muchun.song@linux.dev, leitao@debian.org,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH] hugetlb: only adjust reservation during unmapping if
 mapcount is 0
Message-ID: <aleRuVBaWu6eTCJb@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D636914000B
X-Stat-Signature: y7obigrjb7oj1d97ip5fwsfqobewtfny
X-HE-Tag: 1784123839-221101
X-HE-Meta: U2FsdGVkX1/d1FPRLiLQr8EuckraM0IiQ4crI7UQJCF6/5WRjP1Q9rhJWJ0lPh9c+VZ3VkB4maRYloPno0E5Q+T7zW7fWpTCdF93hioCH535PEgT1H3qM+PisdT9RBEBny1ghgf8yHw64k3s7nP8nyZ1ao61ShWByNFkfLkHeok/2GfU62QtvjD7dEad8FtLqAIvJrH+x/oRdLlYLltIOcCxMpq1nBvDBv2kRjJ8IFkoHZoQnagUsc7WV11St9CS2OAKwf6vz7NqSouuhQuQL1rxDxUp5m18yu3COi0XZZ4furV84FutdniGUxw9iBcDIbNUji8oZhB/Du2QT8VNn6U9BBwaJI6HIjfUYxhNggd4MUbObTs4Y3dXocGGhrvzmwRF1Pa4gUXdLCrT/Mf5UfYtZqSaJwjX/BCYgDhCI1a+s3y0dWQLiJZMqbom8XapCjaoQ77GVz/1DyGjKa8Bhkvu2XoPPmn8ERBCUxzzDK3nUzeYis+kydFzpudI0auWW+tytP80tVyUV6Dv2AKvd4SkuxcTcGWRH8xEkDsfdD59HlYH8Ujn8BOoQq40veunfVEE4x+yN/ERODKJeqOoTinTxIDoXmIVIrjAXdESOFX5s5CxD3jl+/VmQyNTCWW6yk1tcnsprM/6PbSVjNCQ//k1cyuIf6fo3S5ia0UvwFl9Z7vnXFj409O8Oo1GioPwcwR+ME0jwW+3el4cqhY/s+IioSmIAMI/arHW7mmfjAKIQlbvY6KXFeL/DV7Wklj+Ok7X7+kLXTSjYpg5T5uBypH2WmaZzPQ7kb7xazTcWdraV/2etQCeyiC6Z5zA54QB/edN9JwTroothUpmmKmFrjqldTyv2rjQoIZuEN9iDbtLjIh8v2KA32JmD8U62gAKtub17bKeImVqBerIxmbypgUNYkz/dpR6fxKbDYMCY+zrb4s05pc6gwJ+f9Rdp9ds+kNd2NPuwJGh0fyEbc2
 KzyW/IYy
 FBLS4zWQQB/SkhZLJoMxQBhXTvTQw5nGf3OBr3ruK1Po7NG4EVYBz5TFCm5Qr5q0lmPIWGtZT3At5aDk1FljuDfyfpx07xAwNPX0PnvZgW2QGLedmPjEGzAdWpqKw1rP3QEiHvfrKNrnYw3O2pfQpE9iAiaeQKruFhRuq+bj/9A4c1OZ01ndLKCtdJvJeabQc/Kx5DnLKvKFEv+IhFE9UVlg1u6DdQ8UEmjT2qikQ9zpZPbQMD0yNjDXuJPVjvAwtIM6eA+X5T2JmH7vFTOSPHG41bHgL6LRi/huBUgFFDNsdjJ5UglET+aGtpZIlAbQ+pQLsCv0KMxIZPQbvNaBFsNYg2IunMjWl9SJDmbh5MJSKQB+VoGuSBKkl2iSXADETHm8G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since df7a6d1f6405, __unmap_hugepage_range can adjust reservations. In
the case of folio mapped in both a parent and a child, if the parent
unmaps the range first, the reservation adjustment will result in
an underflow of the reserved count. Once the child unmaps the range, the
count is restored.
This patch changes __unmap_hugepage_range() so it now checks the
mapcount before adjusting the reservation.

Link: https://lore.kernel.org/all/alEJkwn5VlTTH_ZX@bender.morinfr.org/
Fixes: df7a6d1f6405 ("mm/hugetlb: restore the reservation if needed")
Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Breno Leitao <leitao@debian.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..c0167a09a0c4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5252,7 +5252,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 		spin_lock_irq(&hugetlb_lock);
 		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
-		    folio_test_anon(folio)) {
+		    folio_mapcount(folio) == 0 && folio_test_anon(folio)) {
 			folio_set_hugetlb_restore_reserve(folio);
 			/* Reservation to be adjusted after the spin lock */
 			adjust_reservation = true;
-- 
2.39.1


-- 
Guillaume Morin <guillaume@morinfr.org>

