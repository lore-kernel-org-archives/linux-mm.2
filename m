Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8392F483CC
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 17:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 356246B008A; Mon, 23 Mar 2026 13:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DFD86B008C; Mon, 23 Mar 2026 13:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7D76B0092; Mon, 23 Mar 2026 13:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0683E6B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:04:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 997F1C3A73
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:04:55 +0000 (UTC)
X-FDA: 84577952550.18.8136C88
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id CB4B912000D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:04:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=haLtNdYN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774285493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=K5DLXNkfiO9SlRW0vo64Nxeq8oeQwRuyHXAwNoCLJqw=;
	b=DdukpWghOPWuGEK5ySHN1mU4FoIG4/AZmAE8Gvv6Kp1GDm4biYGSs48A/WoACQ95lLIW1+
	fpE8IzoeAceIDp5eg6M8Pifg8zwqVujiiE09+6vwMPFEI7n0wb6LegWZIu7GbJm2s0uuDY
	lRTOJ9bcYqdbQIk5xu3gw/yWbb71n74=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774285493; a=rsa-sha256;
	cv=none;
	b=edUPXbUrMPVMf/Z+thx2yY5ePPGF782UJpXwKbrZ8a+WUN/Gcna3aUo+/epbIPCf4mpyUv
	0Vrlj2+Gkb/izMPFn23HViYEHp506Snmf6+NI7P982K3ATLEmXbGG+O47uQ5//VwBCrQzG
	oQ0wu/V80w2PacsQ7RW5OSCbFzdu3aA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=haLtNdYN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=devnexen@gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48700b1ba53so28267055e9.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774285492; x=1774890292; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K5DLXNkfiO9SlRW0vo64Nxeq8oeQwRuyHXAwNoCLJqw=;
        b=haLtNdYNFYqEH4k5xJAe3vP2Fr9SQE4DkL5AI6Y3g/usd13DYjxl+BwKtyTlNszB+a
         jAPsKv+brVVLsq9XSlg7oQ8mrUizkNqmDuHZE0jzqOdx7X6w8ApiOB0VIRWRue2un5kv
         D9CVG4WFtoauPNuS2Pf7oyJHReU6rSi3KwPqAgaxykv+dbvrGtxyGmMeEWIjsbLvPN7f
         fCHIb6Wp0qfjppWzXJLBZgmXI9HvgR/ea+UEDELZnDDCrklzkrE69C0wm7XRe3Gf49bL
         /qG0EJgEUs6VVXRQ9TuLYBNVwdQwHLwe3PUlfk5sK77+cpD2hpahW5srDybV3gxeoF3A
         eElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774285492; x=1774890292;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K5DLXNkfiO9SlRW0vo64Nxeq8oeQwRuyHXAwNoCLJqw=;
        b=C7MZEi5W0YxJ7ae8dUsdh/Y7Q630xqxnK5is5ePiFb2i92IXO0fBG5h4MAWtumxk5a
         3gi7uBlAebvHGsvxNkVD87tvcNrrrv9J/ujfRxkzLXxM7Tq3cN1emQriyBxQaWULni9w
         Siqcw72HDI50SOl0fDjAX8ywEcirvvhTuvBKa3AyVzb6b0jsDUKMPRVNFdPdO7Xz8cAD
         r7z8iUysiqZ+NAU6WcCuuGcT5M5S3iQ/XwaeUYBB/Exp5LVzNqSSkH/exctUd21+79Uz
         Cw1abbLYm3x97X0mO/XVb9IV4riRcrINaBsIAsFDBKaaXKH2S0PS/oBOBRVPs3ImUSYp
         Mc+g==
X-Gm-Message-State: AOJu0YzFYbRNcFJX8s9OW0Ze9HX2+TCbXHauLiQmox5GekuFh0jtUUN3
	22wgBulWaeHbklJ/nitH4sYWtPsquUt0VlJgv8ZvSStxhiXMAzcUPsvvaKMkAnDR
X-Gm-Gg: ATEYQzzQ1rWhqAKbA5NNTrL4I4CypBBcL4S5znuierGIR+I04eM3UudDTw61ig0Hntb
	iB0f05LFp4bj2XkNOVpscx1beC1f309vOmhERYrnHh3OK1UjlFnAFE1VcQuesjqeCA1M5AZXEh6
	o4eGn550VD1f3O4Cu34VSrmFYkz/TFLgr6NLBo4eGgNKE6ekq2zEEyE/00w+4yezrXnhQDjpRxJ
	X8lqlW0WzEjOVfaPO7y9jhnAE+ITBmdGosVBrxCa/IU3gsS5vREbzrCBEWFqUVXdlaGdhCMk0Hp
	2xliB1DIqlZR/Ov0lpINsZSDWxSQ6aFDNZ4JUUZoyvKb52bMsEokzqGvVn80fUNUBv6bpE/R9E3
	FkknVNMHCfpPhsYTS1HhTw/znsJRYZ+nnGV7GHCPU7H4bQxDR0/FBHeHlbHwAnsUCkQs9PO8gvW
	s6a19dgbkLKV2Ja+YaFkGVMNAGLuusaGkJtUVB2Yl4Ch8aLKE8mouvTUsI8snKQvye3L22XjkTh
	ZCQYabIvXxF
X-Received: by 2002:a05:600c:3549:b0:485:3fe6:21f5 with SMTP id 5b1f17b1804b1-486fedb5928mr175892525e9.10.1774285492018;
        Mon, 23 Mar 2026 10:04:52 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486fe879d37sm111516965e9.1.2026.03.23.10.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 10:04:51 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>
Cc: linux-mm@kvack.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH] mm/page_io: use folios in sio_write_complete()
Date: Mon, 23 Mar 2026 17:04:49 +0000
Message-ID: <20260323170449.26333-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CB4B912000D
X-Stat-Signature: 419f1m3mri75b6ubeeahyutt6q5sqh8k
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774285493-362425
X-HE-Meta: U2FsdGVkX1/fBbJFFpteNBp8wm4IrNZ0yEDg2XfWS9KfV4d/nntjPveyZfWdUcdRDtp06L+LQ2MdBSt5gM/BIeLiZsMBEJEc60zkv5xEPhN/+BSeIs0P49pnYC9fXKNq034j2lx2FLDhZZnsiB5Rn2iq3lMZnPGX0Psm9GZAo/+JOkdowSiXin0zu9JAhmQeUtps1jBtYYcWch19Lt8+2amQqLmSy7wy5azziiAS36cL2WMBEJW6r4AIaaM23/LzaD9lxvEEN/3ChP2x1gOmTojNki03l/OCZMDBKvWPT7DxMwZysutLIHGrUJDWRu2frOob6ns8YdUU2768I/PzYXlIiKXJ5ji+L1H61pMyWroDQVuHbIKvIX8a7M0wBSN1BnLRtlcG/4OdRcBfUwaCx28MSl4baH9KNUfbIY6sRbeaxRRnYy2VBmkOcsaqcgSh9zGRL2FC1BitWVgth7NWBJj5JzLw2tg1m3P66mGU7qwpcHLnsSwiFFV23Zf2Ypy1Rj9niP2WWXNIwCNUdGO3mPOoTx+0xspTtyvAKZLTzgAYuLq5kc7D5Nq+OUiXUxsgsv8QbmhdXSeabdr2eAbXAZnrBVOBWfejUiZc7T8vNfmty5G0B6ZKIPIfnBF7t3pqO41ewRjmR33wH2Q78gzMvQBebwFUHJxLRd+iFQsCXBeJPYziWC3Q91k4Zwo0n2NejdLkyeqCgH1v8nKucmQjG8gd68NTzMzvjYa+fxJrbLjeN5/BWy3DnHNwTO7y7UX7ReCZVTHEv15jahOEPMhsmyosu1WsnIhX/yhKr7BoJcqfQX6InBuH/EMUiUesrQKMACNkZ0pSsUgfJqOIL8tYXG6ww2eqUhF5gCmuTO0x5bTuUGdje8gF2uciCj14A8AhGy1bEsb4wOnAKLJiNpokvh6X3EVP7gDiPeH21hTk891oAlrSK4Bsd8dbWmCDywC36Mt3IpXnYTFQQkS15f2
 f91PUxsO
 qfBpzM2WkJyYvNoAiCbdSR4a6a9RsFkoqBS1f4yuoWHHiOOxR1ymQsQIalCgVuxgszcuw1+HoSDszaZY+NbJcnD9uipbFprCfEw4YUaqPt+GtDhoK1MdFjp1BEEiDhWQ2tzYIH7c86IZAtvVokYT71sdyleXLNUsTanvr5u27LMXxcYFJ9W+/WUk/3HsP5fVLyQ3AL46ZOK5b4aTSnSdmAZKd13rGYiGFk1FpNt0fLoYhxEG8HbXmfrWnIO4Bn4JmN7pjK1O8kMdhThDJEn7XnEEVnoXOvYBKy/5rY7rnyWeB1AA1hhMxnOjoc8lGChVgmaA8oOgG4d+8oUnBj/F4RNfQ8N3NyKARbcYXcI4mrS+/p73DS52OBDhxVmctQWr/7u+HkKiuBPYbSeWq1mNBv94Xkll62RHjiM1XZ0eBfCKlPiKUlAnHENLtuUwY9C4+++2qqSa5gaop2Bo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert sio_write_complete() from legacy page APIs to folio equivalents,
matching the conversion already done for sio_read_complete() in commit
6a8c068774ad ("mm/page_io: use a folio in sio_read_complete()").

Replace set_page_dirty(), ClearPageReclaim() and end_page_writeback()
with folio_mark_dirty(), folio_clear_reclaim() and folio_end_writeback()
respectively, saving implicit calls to compound_head().

Also replace page_swap_entry() with a direct folio->swap access since
bvec entries are always set via bvec_set_folio(), meaning bv_page is
always the head page.

Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/page_io.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 63b262f4c5a9..6c7ab3c394ad 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -348,7 +348,6 @@ int sio_pool_init(void)
 static void sio_write_complete(struct kiocb *iocb, long ret)
 {
 	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
-	struct page *page = sio->bvec[0].bv_page;
 	int p;
 
 	if (ret != sio->len) {
@@ -356,21 +355,24 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 		 * In the case of swap-over-nfs, this can be a
 		 * temporary failure if the system has limited
 		 * memory for allocating transmit buffers.
-		 * Mark the page dirty and avoid
+		 * Mark the folio dirty and avoid
 		 * folio_rotate_reclaimable but rate-limit the
 		 * messages.
 		 */
+		struct folio *folio = page_folio(sio->bvec[0].bv_page);
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
-				   ret, swap_dev_pos(page_swap_entry(page)));
+				   ret, swap_dev_pos(folio->swap));
 		for (p = 0; p < sio->pages; p++) {
-			page = sio->bvec[p].bv_page;
-			set_page_dirty(page);
-			ClearPageReclaim(page);
+			folio = page_folio(sio->bvec[p].bv_page);
+			folio_mark_dirty(folio);
+			folio_clear_reclaim(folio);
 		}
 	}
 
-	for (p = 0; p < sio->pages; p++)
-		end_page_writeback(sio->bvec[p].bv_page);
+	for (p = 0; p < sio->pages; p++) {
+		struct folio *folio = page_folio(sio->bvec[p].bv_page);
+		folio_end_writeback(folio);
+	}
 
 	mempool_free(sio, sio_pool);
 }
-- 
2.53.0


