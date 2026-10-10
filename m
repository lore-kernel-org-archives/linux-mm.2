Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D563CA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 11:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DDE46B0088; Sat, 10 Oct 2026 07:55:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28EDD6B008A; Sat, 10 Oct 2026 07:55:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 186DB6B008C; Sat, 10 Oct 2026 07:55:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8D2D6B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:55:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6DC1EA83E0
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 11:55:39 +0000 (UTC)
X-FDA: 85306561998.24.1645329
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 05290C0005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 11:55:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=P3lm7VRZ;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791633337;
	b=kMgoHP8Gdvt4hOogubd4swWAFyiklxRDVuwT/kSMsWXmeywCXq6U9elY6+uEjGi2WSEAy4
	p6mhAQvKP8y31PYhhywq8KypREb4KNEUmJrtdo/y4zbwkvV2aK8LVR7Z+sgWi2oaCt0x7W
	nbm24pEVQ/YrViVvyA2JYqeTY4Yt2+E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=P3lm7VRZ;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791633337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X4UPkDBQVV7L4PDyWtNF9o8eWvpDhSzjJx3UHj11yEY=;
	b=b+NWOcpJk2/wq4K117BESZUphMPzp0TZ/hpW9bONVSpghrjOe9B3P1yhX2temm3Cbegj05
	vYC+zKzrsv7jnapKX0f8pFmCW0rihrHfV7OCDIfRh0Sx4g0D3UGvUzp5wqcW8haqlUORTX
	RX5zlY9IGilJEfaAFmVUPVq7cU0anm4=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc52c1b8286so239920a12.1
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791633335; x=1792238135; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X4UPkDBQVV7L4PDyWtNF9o8eWvpDhSzjJx3UHj11yEY=;
        b=P3lm7VRZbiLBtKX65hcCi/GKMylSgzYxVyIVPjXa8ofzIjyTtFWvXwBdX8m/nqSjuI
         n0OUEWBRgyIl9myZWXs8Vv7Y/tj+YH0hk7Gfs7XmrJxwOzH9AP3JPzjg+ra7x1Nc4xQu
         4pRzyy2MU8y0+4ozWiBR/Cixjbw7EDqPM936gI4VY0x4efOT/Z9wJ3KoeCtVzyONQHGb
         +av8SwjbHrJ0HcRQ6fysTL10R6vperhF30aq17FfOtokPSHRd0s4k0fHZQ/yjw2UJgsa
         FGAfjeavWtI8F2mur7kpIAtBfSbSa8lFaFPSKWDwaxgKcPeSI5+hJQaYHgktrfam6LJt
         RPDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791633335; x=1792238135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=X4UPkDBQVV7L4PDyWtNF9o8eWvpDhSzjJx3UHj11yEY=;
        b=zHQTHgo8DFaAH3EqqnLqnd3uIvZKfrxXJOxr8c9gqcIluSPeluJqbrLdi/zX4j67pA
         0xufk8rtEtChDzHjkeNPkQCowFQSfJnzpe+q7nXwEkDCFClsztGBdR2d+milGasaGOjb
         3tHsegK0IeSdS9NsSdLT6FZkvQlSO52tsjf92YejO8mTFia7W7uuCwUnkps0GNVeXdBq
         f2bSFYlmU5F0qTc9aCxvCQDccBZUyzDowvYA8MsQ3w8FJ1rOG+dnzRr9uUZ2RH2Icju3
         Eg1BtTTPuGt3tn+vUdiR0mjFYEciwMp4a5LFfJglx0kl6rgV8FR4qshfV9syXfvVeV/s
         Of+w==
X-Forwarded-Encrypted: i=1; AKwUvBy6zMtEMKmm2Z1/xzuk6qtmmKlK6V06gG9aG7G8wProJNMu8aA0bNrzhX5PWzCAQcLqvAsUv+hPZg==@kvack.org
X-Gm-Message-State: AFq9FYKLLaTmbD4WPpphOJHATet7ejqAxibtJ/6rEJpXt92jv0geSw/H
	fH+I2ItH13oKNOLaHnC1gCb+4kqFjEtiPAOJe1EDRGJxLFFdkEsoofJvE69Q20eB/cY=
X-Gm-Gg: AYBFou2ddr3e55UTtZo/la2+6zmeBMJoHafat3DEazFBkywz2gpAjtw01J0won0CMw3
	yTXSQTeLsaqlRuXOSdBLC5VwjGdv5etq7XW4MUmiWqwM34MGRjnbcaPIYZVFq+TG/6xVApyo/LG
	031CzdfX5H5vAa5Hu8BFrxNd8LUHEVqAxD1Bj+qhdwKwfVWgEPQEOYCMyhrEOURVh5EYwg77w8V
	k7Lo5YBtgFYorBW90wppnVnx9g5j16uq3Xb5iWHqcYN42VGm9hDw43T9MzsE5UfsPArMH/v+/Rn
	qZq7OQVu9BJjJsjaP7kdmAPrtNjKEqQ5mwk0OLKVK/ZdYZpaNCuVzOGvft1kANWps5aPq6b6XO+
	rIXqnm1X/TW9Az60n4d3eN66ko/+CNCMLZnnM0jqJROlHHuX9t0UVBprfns25ME71PXuKIBCAYb
	fl+szK9nGx+JYDMo/Y9ocuL+mSTmDfvG7dgq5xmhTGeECCjVYWFx9l19w8vGGj7FU+rC4W3lan4
	tLg2+rxjEnPh358/CKa
X-Received: by 2002:a17:90b:2d06:b0:3a7:cffb:8b8c with SMTP id 98e67ed59e1d1-3ab3ad0e976mr2419519a91.43.1791633334534;
        Sat, 10 Oct 2026 04:55:34 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab36ed040dsm9813293a91.6.2026.10.10.04.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 04:55:33 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH] fixup! mm/mm_init: add zone mismatch warning during page init
Date: Sat, 10 Oct 2026 19:55:23 +0800
Message-ID: <20261010115523.4005071-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261010075755.83339-7-songmuchun@bytedance.com>
References: <20261010075755.83339-7-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 05290C0005
X-Rspam-User: 
X-Stat-Signature: atuf8aume35m1t7jqbrn886idmwp3ay6
X-HE-Tag: 1791633335-575285
X-HE-Meta: U2FsdGVkX194W5JCunR6lMRhYuaa+5qIVItSbjJS3wr36dvpVP5lJwYC+nVGAX6h+TlV8ZXTnFj6c1bZBoeiGuigU+Fns+ZgXpv/L+JzAyL5WdeIPw9048Os5fZH3PJ+NCy7Icz/3X2pLLVPQLvJTu2OQvv3JtysINdoAkZFQCXAyhXeLgxokN3OGCtJdMMyBf7jyZDza0YhT1a8iWJRQXXq3I03sPQMCQVTOc0SdeimtFTNPbFL83U8JBz2aBNlY+0rYvZvdVONgtrWNJLQ3KxWLx2UbSwcK7Rv+bkqXtm5EtWbky1jPt81ii/H9ADVCY060d7MVMsI78Pxmm1fuzObfxtQ7m7ZGJJK+3g+i4ot44RpgvJ4qx8Hgdkxih2a9RIq15o8omcOtwVBJ8fCPLpXykim3SVk7xzumd4HwSXgE8UC3eLGySLzlhgvFPdFxBJ1iRHA8+Vl2dvQhhLml3/hzt1LkRio7YUUPRhAE+LUeanhDn80JwJ8zWhLQZdzvyhj19ugMwkBrW41lgz9X/ZSDbOWU9IEc8Con5bOqdcPcwYlpvFZmK0now4ZdaoOZI3G9d3m2SzYDkPTnJkjQuScg0IQqzETahlU5N85gKhn07W/j3tiBbbXahmAC3TEuOY/23r5fn++KTV107xLWBNEe+97CqUeXEAO5djxvP36Ok7CrTFozNBAjEF/Z6c8nNjGYsa1/UtcyEo1mcULIksj073elXY3S6yksgbL6GdEiFQn9dFIHLOX+ozN+xitq3KzDCVDw5+zVBF0O9i8J+1h0FdXVXvmYTd2I9lfSBqQFZ8dGAlyo/jWteSyXlvqFFjqH6nalTdg+iLlanvUokuE4Muk+fKypMrJgM2SJvkXAAFxN4c+jsVCIOg0TZk3DxX5U+R5rOwX0x1bZvgVt4TlcUHY1/EGYrwo44g7FkNhyde/obaRESomfUuub94MfGmux3FOQ+Kyuq/rMWP
 nDclvKJ3
 j/JV17FVTqsFDN18T905T7lidjvOuhzKRbwwRgQPnyqcg5NULKjG5WYZNLewAYMzxtt5OpY3UN1qurHSriqWN4t+0ZLbXJcHsd/ZTkX0Z/0yLj39Z7K1Tvro7uvFhAlcO1jaQeScS9oq8DrzZIItsKAjXo8YXOYF+MdPGESRTqdlMqFkekZsAjRmZ+uQd1tQDFCMvX1pxdKqrUtbEdQog+GbYUsUGamD9aUwH+MxG/eVMoKLfWfpDH4qW9sze8hYwyuJ/X1VFS0vqCr0u5Qdojn9UIA9hyg9WhuCOMQU6Xg/Qb41Xl/LlYUfUwabTycr/esLQqK2DRN7SZakJ72h94mc1nXdt2rbF/tvTWaivquGijQ6mFQZapRGHhfsfCxdMI6cMoJIWQ9kMotH/q0izM2//AGAeUBkdtIsojLBmYDbCEQBeqZxTtQo/69aLbAA/Fnwwv+CGhAKTi9rSuayyoVodPfHQQrfcq8G4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the ordering of shared and retained struct page initialization.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 6deae33db882..4c17a892924d 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -618,6 +618,10 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
 	if (!is_highmem_idx(zone))
 		set_page_address(page, __va(pfn << PAGE_SHIFT));
 #endif
+	/*
+	 * Shared tail struct pages are initialized during vmemmap population,
+	 * before retained struct pages reach here.
+	 */
 	vmemmap_optimization_verify_zone(page);
 }
 
-- 
2.54.0


