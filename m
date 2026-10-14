Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C77A2C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77AC86B009F; Wed, 14 Oct 2026 14:30:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704996B00A0; Wed, 14 Oct 2026 14:30:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CB936B00A1; Wed, 14 Oct 2026 14:30:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6316B009F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:30:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B756212046A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:37 +0000 (UTC)
X-FDA: 85322072514.13.DB8B89E
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0AA44120005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jTJq+SMA;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792002636;
	b=OxXOoy/Kv0PiFUzhK1UQ9DqK5a4QEOwDUQ14ZkLlbAdHZyf1KL33n0aKmWJvjI8uRXupra
	zHPu5ePtejM78nB1jt0heGFV972OXI2XmOStUWv6hQsJhsqMLvhRXe0ZybMq7iKpI3ruFs
	axap8caBQ60RX2XYDzZS4dF8MJpMzns=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jTJq+SMA;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792002636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NqHIExQRgXi1oeOkHNuWD0OjF5Gt5qjGM1Q50YZlDZM=;
	b=MJl55L4CZQZEMwYUVmcBgK6GCnLo1mY5+o7VpRbvKzb1ei5gjeIkcByGwQS5hIhffWdMdc
	7ZCSaZ4emImuEcoyWkOdJ/IbuBifhnhxf+mILej5WbHoFJV25bMK2JGN4nyv0EG7x4wmoE
	vUON3TbdW10tPuSA5V5xYCmk+LMs2Q4=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-91054f537ccso50321506d6.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792002635; x=1792607435; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NqHIExQRgXi1oeOkHNuWD0OjF5Gt5qjGM1Q50YZlDZM=;
        b=jTJq+SMAcDLeWeOytiFoXk5lMmhOCWDXxTRyZ6IOvHEi/SLL/M7H2f3W9qFVRJjW+E
         s/17MzplUfreLqVlzoUQ0R1TOqwCbzhbbui8+1nBqX2XYsPANFIvIBbRYA2DZrVxOpFF
         yl6WzZQeLhlxZdBZWBHc05mut9tM0y9H+2BnltQy5FHgDv1Cj4u+4sG5P4frutDOajF5
         5xlsZY2CcOd2lBn++ShOlMV+dXnp2+ATQdjw7KUY2Wp+7u+4UP2YSOwXs/yDbCDAn0uc
         hQPdVfmKsZvfC8buHIto08PJ+f5LOjqfZdIe0/4pWKiM5AH6KvzmdZjAZlkM0oTu4NPT
         InUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792002635; x=1792607435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NqHIExQRgXi1oeOkHNuWD0OjF5Gt5qjGM1Q50YZlDZM=;
        b=duS19/EkYCC2aqlbzN1rI73p2ERpurFAhX8+TVI85jaJLjOBfub/8ly1+MeS62p6y0
         c0IdnJqEuIzr2gt6SPysvj+h2gC3NMih1+UtsUoF74NxOPdPdssJ+mKa+J6ttnhJr2mv
         hhgzEjxiJ3ZiQbFAYDcPHKDWttcH31sGlc/Kq6s2C00lu1PE/q/mP6BxeYGhJveimeul
         pWX4Tsl+PUZh5HTHwyCYYU6x8Fw8NOoPM/W1ko3X+8OgEYLfX3Vs9eTw68PPmM0jWlCr
         x7keU+TbF5hjiuvhaEvxD4RmucB6253YxF0dWcGCxaz0ryTEgX/v7Y5L7wXq8IDuCUR/
         AWTQ==
X-Gm-Message-State: AFq9FYLKmZ9OU3l1rhX5G1UFEfNVPq6qR2tAJvx1DmVSwqF+yJAqYGuW
	gFMKb9BuElwGJqp7bUYDtg5kJcu+JZ9eII33dVlE3rRRUF8liJoE8Ryg12j9o1teG1b+vKGXXPV
	gjXXwiWc=
X-Gm-Gg: AYBFou0SOcb7DUAw2WdHgWixRrEvUEW1tKF7Pp6LrSwO/0pfjfw5OqKpd+fpqiXPsAR
	SIM/1eTGp3KdI7sN1yHqgbZerelwuIBBbTKihY/VWv0kiRohiYizvIGuwGZYeetLj/27y5QEssc
	Q5QPl56WUzm6LsfHebgCbOLDEftIdF5lHhEAq4IghGK0Qlr7TQw+GMF3Vxy7rn8QH68H81AOgn7
	wvLJXTYEWd+/1MHD4KEB+EazDNv+pRhLkCyzX4Uz4Mm3UzfYgkV4ADYvLHDakw4N3hLmdIoE9pI
	x33hVKF0GAxsgKQeFT8WawQPE3aINeMgstCbKijY6Y+/4NCygUUTD+1z8YS7IZPzSweCIabUdGb
	pWw0DzL88PPqsWGg7w3cn7sfCzna+cfDNXBB37OqyNyv2bc2afRoCtAah3wLqRX5JQHikQT4x83
	sdPMX5EfJWbgAtiFX/vwntI6cSDWYj+auJz+Gw2ptgVNQAQ/PjRHFWEDHal41CuQeTxer1ncH0c
	0F7r0fI2QAOFd3Fluv5cvnBqOlhg5EidUCGXC/UDDZ4FTY0zwSdEvUadt6/
X-Received: by 2002:a05:620a:26a4:b0:93c:c73c:91f9 with SMTP id af79cd13be357-93ebd21f2afmr2707599385a.31.1792002635158;
        Wed, 14 Oct 2026 11:30:35 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef508811esm556593085a.36.2026.10.14.11.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 11:30:34 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com
Subject: [PATCH v2 04/10] mm/madvise: factor the cold and pageout folio split
Date: Wed, 14 Oct 2026 14:30:18 -0400
Message-ID: <20261014183024.2075709-5-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014183024.2075709-1-gourry@gourry.net>
References: <20261014183024.2075709-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0AA44120005
X-Rspam-User: 
X-Stat-Signature: cqno7zuo8eqpapcq795rqew5nfqyg78i
X-HE-Tag: 1792002635-113661
X-HE-Meta: U2FsdGVkX19ZfE74G3E2iUwTUzBTN5jI8XVPS8gKfNl3g4kP8UsXZA5ZLILKmjMhUV1RKfiO4knB++Vmz3eze8xDQjnPM6+l5d7BPPPhnadWuRmcueUGbMu3qqJ7jM2p7ala9z71kj6+UXHg8dJZ9nNycIzWph6xvJpwwG+qjTaopUKg+fu084yTz+TNtJqSAK+7H2N/XBzDoTpx6Fbjq1I5W03XikwHvTnKpew9JXVkgkoAkvG073ywik/OIavboOq1117jOHrQUehFQT8Xq3q3uNiEZ9CZLX6F8GjmKOa5aBl8BJBKs1OOU21yxxiSS8+J3nAexvLjCBpYyi9hFuK1LqHGssLOg+v82ILQz1nHMfUTqwZRi66yqz38sWHS6FmA5DjjGBo99DH4fWtKZ9WQR1wgy3iI0Ye0Eg3X2VWN7xOP/Q3UYo9OSxfXA/nZKASpKCPvA1rVZMYQaDu5WZXXsWQcun5ZQv5I7QUSmT9/g+yFC8CyBMvO9dP7yONWfpScpz49EJFk2SsIY89dAyGXCSjAfvqIsMaIoG76U31pMXYabGPwIe/3NTgTrwhrzNue17H8S7hHt1kW6GI0b1h39jrulZjxHvLHNvkThaoz49m6optIrsJDipeGET/4tY65tTRQewqAee+dfJr1roZDYjaGk4ILsSY3sjfOeX7Pvv7t1pge2ZviiL0hC6UFZalWI9hLvhK9rS29+yYOvTQ8SWenCwFWIhrdPE2SOH7uhac4Ts9OY3oPIY+ruIo5C8DQBrz50rq2UzO0G2aNm9VtjS+yLe8rKZ/ebD9x6MzBm0w+jlc+fieFvolrrZYj5v5dra09xpuGQ2++COsfrI+DHFIpshuRmUpMjHgVcxDPgNvl8AX4FGorMzR95TmNscijvYGSFhus0QCBOvM1sLRnNF4fxq+oaYbA3Kun+iN04r3jpUKjIlDGQ8bApzAdZhz5MtXbNTy/1HBIpUY
 8f02Clas
 jMzQiflKkmNrtduIZR1Qr+WJKE/SYhp1hwUn2pVcA9jxMYWewDMOobE9+Lv/IpBE7YgSIOxjpoo6UVqYw9K2yOTlyXSH86XK5t16OgwL94JlxfTNGnhnfGktrCbXgiofL3rANgYG9mqZ8aEep6/6ZiqfPsT1vvCONzAidJI4QV7VZw2FoSmcUSOjg1KAowhrrBddc/rdwzTq6YH0S0n1zX3af+jFf/IDr/4GJvSA5KCZCIkQrx8/WOpTA/AHzZKKSyFUjRMjCx6bhEzzyGyyAY+j53TkovbFdZKXhWfUnn0BG1hA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both the huge-PMD and PTE paths of madvise_lru_pmd_entry() split a folio
they hold locked and referenced, then drop the lock and the reference,
with the same three calls open-coded at each site.

Move that sequence into madvise_lru_split_folio(), which returns the
result of split_folio().

No functional change intended.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index d3edc056ef57..1bb4f9f0e73a 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -397,6 +397,16 @@ static bool madvise_lru_folio_is_filtered(struct folio *folio,
 	       (pageout_anon_only && !folio_test_anon(folio));
 }
 
+/* Split a locked and referenced folio, then drop the lock and reference. */
+static int madvise_lru_split_folio(struct folio *folio)
+{
+	int err = split_folio(folio);
+
+	folio_unlock(folio);
+	folio_put(folio);
+	return err;
+}
+
 static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long end, struct mm_walk *walk)
 {
@@ -445,16 +455,11 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 			goto huge_unlock;
 
 		if (next - addr != HPAGE_PMD_SIZE) {
-			int err;
-
 			if (!folio_trylock(folio))
 				goto huge_unlock;
 			folio_get(folio);
 			spin_unlock(ptl);
-			err = split_folio(folio);
-			folio_unlock(folio);
-			folio_put(folio);
-			if (!err)
+			if (!madvise_lru_split_folio(folio))
 				goto regular_folio;
 			return 0;
 		}
@@ -526,9 +531,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 				lazy_mmu_mode_disable();
 				pte_unmap_unlock(start_pte, ptl);
 				start_pte = NULL;
-				err = split_folio(folio);
-				folio_unlock(folio);
-				folio_put(folio);
+				err = madvise_lru_split_folio(folio);
 				start_pte = pte =
 					pte_offset_map_lock(mm, pmd, addr, &ptl);
 				if (!start_pte)
-- 
2.56.0


