Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 778AEC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 20:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C2C16B00AB; Tue,  7 Jul 2026 16:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 699B96B00AD; Tue,  7 Jul 2026 16:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AFDB6B00AF; Tue,  7 Jul 2026 16:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5DD6B00AB
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:18:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5CF9A0553
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:18:51 +0000 (UTC)
X-FDA: 84963094062.06.51947DC
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id EE7B3C000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:18:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jGB7Utq1;
	spf=pass (imf22.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783455529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ssf8OkM2BtIA8PHjBNZu7yGhktnYzdLzLvhW02L9WZg=;
	b=EggObdsUEnML96dZzAJykf//r+dXXxComGDvbyxHhafCrR+LNZNbMTTIjQzj34s7Zqi9ci
	DUpkEZOcdHZXVhVKXqBcjwxD7QIZRbneYIx8nLZZtfp0y+9MqaThr3E3lvzqIWNEhsLwD1
	Tes/cZeVvhgDQv3ZOvDMTs0RJSeOFJo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jGB7Utq1;
	spf=pass (imf22.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783455529;
	b=fkHlntfBj+ySkOrV3eohK/EmZYXfxjEdq/3aWw8/uO4xHsyKUi+1WDVfR4Wkkd5mw0LWwj
	p6geVe5DwnY9itGkI8Ln+M7BUwCjDD1nwT45ipoMVtTH/rM7/8Muotx5241yf7PZcoZlUg
	/TKZUrNs1VM3+IGQlN6Escyi/usWAE4=
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-43bfe209e45so2146566fac.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 13:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783455529; x=1784060329; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ssf8OkM2BtIA8PHjBNZu7yGhktnYzdLzLvhW02L9WZg=;
        b=jGB7Utq1J2aJmdPWmcfki5wnFQQ1UMr9XYQTOpgPX/Q1tXBXsTcUMvF57mkZqIErVo
         0IxN5wfPeX0Lffg/BaQyz3LgLG7AnYz0RxN0oXFeaTG02Eam0ggW7F8YKDiXm7Rg681j
         BRDiLb48ZXNebPXBaPC43gKP1WcuYKKTgdqGqd4iJoMB0ZHA2TH8Ii0h4nPGv7bfYZJv
         QwR/A+89hNr93gjjzkAdn20DC78xnfL6JEKMH+KGcjV/hGwXT7iKknkeaLXOhDHz0PBE
         MIf0fNSx1I+mmMUmNSHrUEjW7ZC9mUfVRD5+6vaf/W/xe88Rx8uYr/nDAijAARlUfua7
         1clA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783455529; x=1784060329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ssf8OkM2BtIA8PHjBNZu7yGhktnYzdLzLvhW02L9WZg=;
        b=DfYel+5iLsrFsk4XETphJRNoTJlyVbmd/hYgiYwR1efsStKf1ziMf/2l/x2hd0d0ZT
         VD20q1lyDdFyksrPOzEuD7jU5qNlSQVtnJRBr1XvbJkU7t0Vq/XWsyVyaN436W+6zg7M
         t9+zENF3CXxv0tICH9GxFomT1V33aEN/jncfo6ds3SB8iakD4gsJTxBEXeSFVgRehut9
         v/8vs0FanBQ/x0j/xV7h96F+sZwcgXNKbwILnwdY2Mo6QqSUdnQesUTCXc6xxv/irSbq
         z7/cbfXrguAugWdUNPP9icuvOVwteo+muGBHjUDhp8XHTNl/P3rTWAeKE8eMG3WwfrJ5
         8wqA==
X-Forwarded-Encrypted: i=1; AFNElJ9IaZuiHlv2YZ/hTfySMIGz9rG2WmF0edQ1ZWmIGL73h3UWq4GlVV5gyCymOsSoHy6rQJZG6xKKrQ==@kvack.org
X-Gm-Message-State: AOJu0YzJ5Um5hg+Izz2M9nQd8kuKtV7k9UEWCPa7JYlovgTnPSwL/LmJ
	JZ8FpNVNUt1oYGyUPbjXAokOCoHugV9T3pp1a/9TNdOBfaeH4+flhbbq
X-Gm-Gg: AfdE7cm7XNUVn4iAuknwpZQpdtAi2CxANeIHCS5irawc1oFGA3Ulf8yMzM/PzcQweoT
	39pv7lWwoCb3MRFWQv7FEbQrSVWqoovy2XEKHSxwifcllzmnfdvN1ZzbjR/SYNwXt0Anjwi/uGU
	SxM88dQ6S/Jg/Bb1NrxIp1nMkjwfM1lA/7r/HQMKCabD4795xu9Vo8zBkcL+SbZRuZBMMC96+r4
	hWdM74Qn9emweP2fQ7Rxh2rxf+EfHZ2atraA/YOgB8a+Fc10z8SnzSiHezDAZe61Xa8Ars4y51R
	apG2SyQFHoTAkY1mv9orWqg61yAWugonqbyv7Akr1w8sL/DUp9Bmf2RdehDlqNTxbmBLT1xZkAF
	E75zMfiKEJokfqWtQPKYTBaH7GqgvBU9RaS4ekRtIDSwsl+ACmOCdNxPTODKMBgEAuCzaDFeUVx
	Ck0BJ3IzK0QGi6XjTeSIRmnwvAy41nLXwkennreXsa5XNgH5fAxv4G6EQW6GsDk2WM
X-Received: by 2002:a05:6870:7191:b0:447:2e66:ab17 with SMTP id 586e51a60fabf-45106094374mr4457523fac.11.1783455524321;
        Tue, 07 Jul 2026 13:18:44 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:73::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44cfb1d1ff0sm14815254fac.7.2026.07.07.13.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 13:18:43 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: usama.arif@linux.dev,
	alex@ghiti.fr,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred split list
Date: Tue,  7 Jul 2026 13:17:35 -0700
Message-ID: <20260707201735.4113107-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260707201735.4113107-1-joannelkoong@gmail.com>
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EE7B3C000A
X-Stat-Signature: ws6dy8kmyyk1r7xh58qp3g8sebycjamw
X-HE-Tag: 1783455529-420653
X-HE-Meta: U2FsdGVkX1+l0xr5YbWoiDBkHPh0LG3Qw8+x4OpIRq5ng3TSoO7fnixyY6Xom7oMPMgAUW9W2EOgY8QyhdGCDUgE1ITGm3Ku/ELnhObNjJKkWs35wncUop8zjG9ACdSd7s3TXNNUwLXmUbA9fdkaW0MSkedb+B/Yk6mK+rPi+i2uI0Fl2QFG1Rz9FSs5wZ1DUHu1UTUNbAHkP1LvdDlMuUxoihgGZmet2cvrL9kS43VuRrwubJqi+BfxbffZ6jijEFTlZMEQafF0IZqNAEAuwJfemtoYVaYuITm8S6i/LKxY3J5mDtJVRLee2W3C9ZwYKt09uAiziR6fjnlv1KuFpRyLGRGWVZdih8H7tp0AkKI46Ss+uRl2LfyVlqo5QHZXIIGaNE/gQ1tcA3JO8R9GJumJF1yUxT6rSwNXNpKVDZ23HWyn5lC9dnQQqpZoAvrLksN8UmNQ+bit0xdc39HAXdRs7aTLPPUe37TUiEw324eMVt/+oJ7KABKSe1cNq5EyI1pIpghh5l118NatcDy8q28XD02JbOYp6+SLg2cwtMUqRW43zA6zjFYsabiZPXiWoL82roy8/4HJTUE2gCysyrj3wzhGU4c5PKmYyfD2IVJa6z4BXp5fqw3l4zObpnH9IOnBs5nmE19B+tDJvjDSgKlMmM3iUCdTbkOJwJY9t+lG6Gk3Ew/pVHHKN02+ZD6rqdw7yOse6NGQPCOa2PyhqZussbVPUlc74dRGmEDyyIjJJnAZRzZ2RSqGmdjsBW4KMnKCFqgjsgvIyCGp/6SbryvUnfmz6plQMfW4hWI1yB099LxpLCgLskdGcOWPeEK0f0Jh90xHaWz6zx/H52jwf37DpymsoT5viwDRMY5o6I8EpKUJ1v7xdFTqSwR6LrCE2MeWdQ7RH/Ov3d1VMvN37Axg/lN4FU86i7wtY5R1M+5E1t+fMvc74yUqvYYPf1NZaX6sbjkfZatk+kY0eda
 ApgAuJrT
 PSkOe1ZCtatH/kQsh0cebGrxjJYVxUezF6K4vallbOOo6pHJ+yvEuex+l7mg+ydQNJsxUcLdfD1MGEJra49OpSJR7+bxpe5Rz649/HbaoFfvcyREK5oZ3zdfBK02l8giHf6FAKyzKLf3aPU5k3KxaRN1hccIxkDoMvranPaypSGvQQicJvm2oFij4+KD8nOkUvJUKVp/QJHiWNTmelJS64VJ1lNqCgPfYyvd7tP8oVFqm+L4DGTyBHRMT1jXwBvbKC57Ui6M9NyNa7/SeQBqpwbHU50/FCavsXMTNiR8xdPoPDztU5Z7xSh5Hfc0K5CVEpRsJ3Kk6hS6BPpl2MkCS/HhZ5dHV10qIpjoXvxqGLEtOLXlpYbgycITf6JsUQJ86jOyQkcBobdziDJyQ9yZeL+r3HsVX1lYlxfTf8Sb3cvfYneP9wQCZqJDXcfJZ3RelbpJ2o9v7h9BdHlLVB69eJmutwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unlike for PMD-sized folios, an anonymous mTHP folio doesn't get added
to the deferred split list at fault or collapse time. As a result, a
fully mapped mTHP folio that is mostly zero-filled doesn't get split by
the deferred split shrinker when the system is under memory pressure.

Add anonymous mTHP folios to the deferred split list so that if there's
memory pressure, a zero-filled mTHP can be split with its zero pages
remapped to the shared zero page and then reclaimed.

To minimize overhead on the common order-0 fault path, the
deferred_split_folio() call is guarded by an inline folio_test_large()
check.

Suggested-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 6637c5b13c9b..441d918e3dc0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5259,6 +5259,8 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
 	folio_add_lru_vma(folio, vma);
 	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
 	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
+	if (folio_test_large(folio))
+		deferred_split_folio(folio, false);
 }
 
 static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
-- 
2.52.0


