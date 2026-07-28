Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 439AAC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 06:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E4D36B007B; Tue, 28 Jul 2026 02:02:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16E6E6B008C; Tue, 28 Jul 2026 02:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0644C6B0093; Tue, 28 Jul 2026 02:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2BAC6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 02:02:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9EF911202C9
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:54:22 +0000 (UTC)
X-FDA: 85037120364.21.97E4B88
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf08.hostedemail.com (Postfix) with ESMTP id 06898160007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:54:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Ed2a5/UU";
	spf=pass (imf08.hostedemail.com: domain of 3C0RoagoKCI490uzs9vGuuy66y3w.u64305CF-442Dsu2.69y@flex--richardycc.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3C0RoagoKCI490uzs9vGuuy66y3w.u64305CF-442Dsu2.69y@flex--richardycc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785218061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TbaUQQC+pn/OWUqlcfjUbKPPwPnDIi5tfzFCEzmCL34=;
	b=kYVAdHo0XP71W2lWphB+bMrrBRHKPR7YILKhJuW5Z7oHLqkq/ohCmbq9KQ1LPdYJzy6+He
	Zz+f1JwzRIeE0urkTLkVButB5GX7F6OIY6s//0P7zJv+eMnVz+SAxJ/rL3UxHLCUskBS4T
	6N6WoFFztPHydP9ug1mugM8HVX5WKRo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785218061;
	b=XFEcNYYCDb9w/4SSmzNJuBPNZue2NZ/DtuoQz8frxt88o2f/6UPApWeY7TovAyYxudmxiT
	EdwIaOMDojxwk5ZsQsnk6D8QW5kdonmtYS5drwhpKIlpgDzD29MMJqFQW8WksvjDUHdelR
	GFThb6CR+8ZpegMi/3xFWAAz/k1fyt4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Ed2a5/UU";
	spf=pass (imf08.hostedemail.com: domain of 3C0RoagoKCI490uzs9vGuuy66y3w.u64305CF-442Dsu2.69y@flex--richardycc.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3C0RoagoKCI490uzs9vGuuy66y3w.u64305CF-442Dsu2.69y@flex--richardycc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84e3d575d6eso6370342b3a.3
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785218060; x=1785822860; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TbaUQQC+pn/OWUqlcfjUbKPPwPnDIi5tfzFCEzmCL34=;
        b=Ed2a5/UU1fMw5B+0HMz6lD6qcX7DhZmnYuZ8GirrDsVYLvPtF5smPuFQ86bpYoBjly
         bIkq48ZpxGVbSmDMWXa15rgK7A2KqOlC6pEFsea5KlQnzowzAt2uQHHRLcx0oyO0zTX8
         L5iE1D7eJFPXOZjy6fJE9T3VYgHYEaUwHFTUBjYBRlhTxmfH5tEmS8az+XxkPyBzREk0
         7McLPTJfNiZsT+sPWDJ24x5eeYTkyILfArE/xxR0/wOOL+5wP9WCgeQDJdl1lfWJeBz2
         WFYOIPGytTFZJs7v2P+7Mb43R5Dseff5k13vUKs1s4rxF/fuWjfut6PzIRlGHbzlTFvM
         nQjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785218060; x=1785822860;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TbaUQQC+pn/OWUqlcfjUbKPPwPnDIi5tfzFCEzmCL34=;
        b=XEYxRtj6zzTn5Q1f+N7HeqyZyTt2N1PXYkwAUdo2Hbj5L2ABU4sJ6jkwJaHcnXpYYs
         HMHiWGpxrfuXIDh2kBAAadeFyZz3QePMRWK0oJGB9DfBfvlXFU8XbCTbh1O6Qh48Kkbo
         EU7dAqrBTyhwFtYb8b2UqcDAbqRIYnAQuqd2Lf+REVZmZYFvlvtB004w0Y/2yuzD1MXO
         lp9OiwkVMlsseQJvauGwGD/hrrY9ySNHBSZzjRYJe7Vflk2C/rjndocrRGSWr79ukKL7
         veN4eB1ll15Fcl4tvCoHh2CRNGGpXXTcujayj2abWwRb1cDzdiFIX/Y0GjiPKb8g0Ygu
         u8rA==
X-Forwarded-Encrypted: i=1; AHgh+RppVsk3TQ9ibA0luwoiSz6rG8GTlkV3EpDsTspbQAnmOoJ4W1u1ZnK8KU06aN81pu7kdFwI8Jch+A==@kvack.org
X-Gm-Message-State: AOJu0YwQabYo6RpYUkGKnCDUsFsA+hphkbHfrk6zFFOvhhIfMxrxDtqj
	k572rrdYb0Il71LeoALudYOgebsktuoeIF3apa9DAI7iXA2QH0ZA4Z9vwhMSmJf2RtGZGa6Frw0
	esYtnjHVly96Uxdc8ISDD
X-Received: from pfbmb2.prod.google.com ([2002:a05:6a00:7602:b0:847:80c0:ec04])
 (user=richardycc job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:94d3:b0:848:77b2:20a with SMTP id d2e1a72fcca58-84e933203d0mr966896b3a.39.1785218059622;
 Mon, 27 Jul 2026 22:54:19 -0700 (PDT)
Date: Tue, 28 Jul 2026 05:53:33 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260728055333.421080-1-richardycc@google.com>
Subject: [PATCH] mm/zsmalloc: fix release order of locks in zs_page_migrate()
From: Richard Chang <richardycc@google.com>
To: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Liu <liumartin@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Richard Chang <richardycc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 06898160007
X-Stat-Signature: ryw788s434kbg57m8m4nj8z3e7gjhchp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785218060-527594
X-HE-Meta: U2FsdGVkX1/zRSPe3IJxgtX42sqomncc1bT+6wEL5h/loOJmrnqm2/HGe9VVUFNYsI1Vb8Wh1prETrKqsJ8Laa4obeyWNdgTQhK8jXfIQ8nYrBIu+vVFRxc0SnCdpTFN3qILnsd+GyXkLZ6uPCJXl2jd5Qv74dAvnf7sdMR1OqdiSFXT2eZpkWEzmpdecp27AqJh2xVrCk0peX28yF9FwJPiMszY2BUzh1RBXFWTHXgBlosJcH4KZLLabDfz6oXxdETJaZ3T4BNfE1+gJNCw36Vkc2FS32SY6UiL+TxFXXmvphJP0hZICRtwc3Q1SVOqNIRMRjNJAcE9flfdITf9IRq15cezL6pYc15k6Yaj7nV9l2DcAJyPAf2ZgVeoflgquktwLaGpDtuhmTWcY1Bhj0l1y5ZGu1ACTej/sL1Stwc4iXyYUcqrTPHhlKNTU0rdJ97YakugHUFyccaw5yqYwLO/Sl9YyjgYc9DSWdQOFQGJkLkAyY6dB2zCfvK84hkAvLjUhiP7kk5gk4o5bbh2ICKwq5qTHKyOQX3gjytO62C2Ct6Rq31wG7vbC6QeLQbpHHPL+7by1GYBD/rtO2XqkxlB0l8WVcA0mBUy5oeLMh87gHQJbGc6URbsl+UCB8HZB3a44fbF3mbjitOUvZti6EPUc7TvGcCec2r0FIzR8pKwzvEjiltTtBoKq078fTpV/np31859plFPSfvQLuuBLb3xBm281FzogZURGmLrttJRHT0AgHqiYNZXEHTlj+k6q8s+bTn4cnxDCRp4bIY+dnCVjaszdftBjJDiljyljik8a1dIjXldyTkHd+jI917ej3D2oh6UdaLzmAu2diMguc98dohYrLWhxq3e/ulzpSslMQvTgV6aox3UHr0/jo8rbfTPtjE1z+P/SyiRK0jmVYOkM1Vs10pVvrRWeKC05bKJU1X9mPvJRBUazRg6slQPnFQenGlERdrfY4lvOIA
 DtmgKBr9
 uZDVxUTQLYlH2FvdjhasDOIji1Z8nMyKKaYc26YFjHOURRjAbItoSUXWG4Syf6RrWEGYWD4hqsNh37rI4pQEPGkaZXNl4p11EXiQtsQ3RkYTT1ZvQiHlHIjXWFGOGNe11RXYZmuC7VvrlqIll7rZrxsAzuKgojSn2HIR6umvCujSjJ7miWiLEhiyd8ATGH4yDibiwF37K2U8vpVghFHvnHU8fz4/Xwz4tK2CO7DP3obCa3Ynu/h1GODTCmy1kf/6yXv+OaWJyRZEHm0/HI+ngayWITh4xrzZIVEe2/rq40gYnyC/xih/lr4PYhuU+O3alhz7jf/FkWpcA4+9yxraisymi34uvUN3uogMwnSNg/Q7pkI98MD1v1Z0LzuWipJUdub6AH9S40LYUbFXdatS2ClHVoOrVdUqmXN+Dbrsotlzpl33tzNnfx0ccW3jpAJYAfYZQq9LBrpxFaHY3rnt+J1ysudvJ8TO3aZwjYvChqNC91/s4uDa1aewKxSM4yGWAU34jajtlQf6/kut7e6jtf/NEvEQJppTo2PJ2vsfegtiDA6vXxgCrzIL8EP/wj5RLY9sbdyf2J3JV1+dsJFCrBlsTnLInX1ckMdSsDChOPy7UVfxm1WuPfj1b1McP3p9A5tP0d5hAPY9NXajYqBtK9V1RHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In zs_page_migrate(), locks are acquired in the following order:
  1. write_lock(&pool->lock)
  2. spin_lock(&class->lock)
  3. zspage_write_trylock(zspage)

However, upon successful page migration, they were being released in
forward acquisition (FIFO) order:
  1. write_unlock(&pool->lock)
  2. spin_unlock(&class->lock)
  3. zspage_write_unlock(zspage)

Fix the unlocking order to release locks in strict reverse (LIFO)
order of acquisition:
  3. zspage_write_unlock(zspage)
  2. spin_unlock(&class->lock)
  1. write_unlock(&pool->lock)

Releasing locks in reverse order of acquisition adheres to standard
kernel locking hygiene, prevents potential lock ordering and lockdep
inconsistencies.

Signed-off-by: Richard Chang <richardycc@google.com>
---
 mm/zsmalloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 83f5820c45f9..b09299115886 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1772,9 +1772,9 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 	 * Since we complete the data copy and set up new zspage structure,
 	 * it's okay to release migration_lock.
 	 */
-	write_unlock(&pool->lock);
-	spin_unlock(&class->lock);
 	zspage_write_unlock(zspage);
+	spin_unlock(&class->lock);
+	write_unlock(&pool->lock);
 
 	zpdesc_get(newzpdesc);
 	if (zpdesc_zone(newzpdesc) != zpdesc_zone(zpdesc)) {
-- 
2.55.0.229.g6434b31f56-goog


