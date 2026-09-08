Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E192C79FAB
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B67CE6B00B4; Mon,  7 Sep 2026 23:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3F716B00B5; Mon,  7 Sep 2026 23:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2E056B00B6; Mon,  7 Sep 2026 23:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7BAF56B00B4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:04:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 056B01C1F32
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:16 +0000 (UTC)
X-FDA: 85189101312.02.13044B0
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id E80E4A0004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dPjkBUlz;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788836654;
	b=VDmNMIWXjJawz51I/cOmBoM3llkvH/4SkuAfLGVohC/WMzLQ5l2mXGBYm/g+rMy6nbltnO
	hiXTBKoL4gR6sO9OmGCR7qXMGNWuGMBNiViGvf58OPaWC6BkVbLY6ozy7cUxTF4TTS5blC
	xy3XLalLdBwKyilE4AnHl1zR8OV8pF8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dPjkBUlz;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w9QdH6WsgivxpcgrN4flEbJh0Z1iEZy30Xh6LMeUuak=;
	b=XEQFiLCXbg4vW0nxDgCx/BGNpxCXe/iky/HubW7slWozksVGbUeQO0FaAVkAVf0cLhkyzq
	HUq59XTGHuN+2KxWQlBxu9KolJoMtThbUP/E9+tEnB3HDGcnubHWqQxiM7uTUED2JdBjiW
	WmdaYhU4Q9aE6If0fE6e4Yh2PHolU8k=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84830c774a0so3864386b3a.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 20:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788836653; x=1789441453; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w9QdH6WsgivxpcgrN4flEbJh0Z1iEZy30Xh6LMeUuak=;
        b=dPjkBUlzWAYStDT2I8r6laeCbjQ7ZtkzVBmRlgww17bTPbnGYnQ5KDr2Ru+vt8GrL3
         lewWn7ALslC5w+Z0NwZZk6PV7l0lwe6iidZ/gqmdLez5YvMvM9eWH6dQ5ttRHId8GNqj
         U9AsHkJQa9Gb66tkcOcvQELT691ecLVJMYYq3it10Yw7xMAH8befBAb820NL+BI5Kciy
         nxP8HhE6UcUPfY6UdIFtV9K1VryQ6dlrCbQrXZw79w6YDAaLBY2NLYFvglQS0jgdJk9v
         48Vz6qSd97lU41LiWiXWRomgj49wpWCpSlKyH6tNN/XArUL7MgQuQWYd6UnUpZ9nxpqB
         k3Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788836653; x=1789441453;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=w9QdH6WsgivxpcgrN4flEbJh0Z1iEZy30Xh6LMeUuak=;
        b=SXQMs7fZ1ycxQmW97fzWGQq+OQQJex5PZNu28XNw5Qrhz3QbHX6O6gtLIaCPmLY5Mr
         cBw5BfghbB6JjKZe9SBRG1sSwMCLjh1jxcLk6X3oMR6jPnjXOAg1v/+OPyqhzKqkPynB
         X93cFwFekk3wGP68yfrVUuqw3cWQYNw9TqKrOJ0PCt/W4LXM83YsBDnwz3FkdC5ihCe4
         FjM4+J05poYCvWyxqp03g0wcdeClBexG8AFEZIdmBJnsMoiZY9nqY+djCGQ5sfthdXd/
         TUi1KaMDsJIOle/PFWAnyAvd1hTvToKR0/GQ+rVd/mMqfemaEbSeQUBjptpBu7zCeO4o
         c36Q==
X-Gm-Message-State: AFuF++nOi9PxqP9qE2yTFQaY5v0Hb0sCitmGwj0lEC74GImECPalrsfp
	pmfkAx7qI13C/rCDZ0HBPl0arKjarXD59gNE5ll/1B/HwGp4s5ncAxKLYkOz9taWXtY=
X-Gm-Gg: AYBFou0GXQHtgifhRzTj6xUiKzNAHQ6Mj/KypcybVzanFSyvOY7Z/4eo10jo4eSfjJh
	inYU4klf8bO8P7aJfvbF6JdkDCuNNsbuTo5DUC3hu6Z4kwE5kWcfQ2vTPq7BPVGniTPrb99lWmP
	vHy+JTc8qcHhooUmNpQXpueXCGvVnopGrLjCQb2RJQnZ+NvY/URlx98g/ZALEg/JXkYf3t5D1uf
	kEgB3cBD3X5Q5FqYn9874wdAqDo9+YCnGlyxPeTPJdwwPmDeu9qy1wgUt0yJ9XFI6RvVBc8Az8h
	dPKVnEgwhWu/z5DyRDI4fmZ9FHTDkKqgQABX5O9YY0uQFi3OKIMCYKCumzF/++lagwTQV0rsGVE
	4t3/5t7J99QL+JRedrDkJaSt85j15iHgjm/NiyXOuMEUzfyl6vlMzVVUbKAEXxc1Tyt2IBwRjcK
	puuri7sZfR3Y1gyshWaypgJLsdQYv8AE4m/UU5ryrUBc6FY+xoGSwyZTDnMMDhw+Dp5H7KPq75Z
	eVmOl3TMf1Lhri50GavTO3w
X-Received: by 2002:a05:6a00:3021:b0:857:727c:a1f3 with SMTP id d2e1a72fcca58-8616907fefamr35713322b3a.21.1788836652665;
        Mon, 07 Sep 2026 20:04:12 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152a358a2sm4868234b3a.29.2026.09.07.20.04.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 07 Sep 2026 20:04:11 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 03/11] mm/sparse-vmemmap: open-code init_compound_tail()
Date: Tue,  8 Sep 2026 11:03:27 +0800
Message-ID: <20260908030335.96549-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260908030335.96549-1-songmuchun@bytedance.com>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E80E4A0004
X-Stat-Signature: zh7j7k8p4gwhfbf94mute8j8piwamqgz
X-Rspam-User: 
X-HE-Tag: 1788836653-237750
X-HE-Meta: U2FsdGVkX19GY9rJtPlmTtU2+XOmvqn4sPaHMfdNiMbR64Axs4t9nIlJeDFmSkvgNE7U6ScQvw4zOkkF3/Vy/hKueVtfhINRk0Ig1WLk+IvMjU0JdJZk6P/acI2Bkb2yhD9XGjfjRZho6AaYOl/0X1mBtva9WoxgY/aC+zS3sreZWnlEqrryawy5mP22hyrPY/82QzY8rnL+LNBMYe7lfrFTX1p0zarLKYpUz7c3iKdwgPPiMl8wHNgb9L34bSl3dMl3DCqT3C0dSlBhMxE/jlqF7UOjKdit6Vm5sc0F5VeTkazt3mmo56ALkugHIqeWfSkMna5puNNi1uCbrOePeYiOksxFOxXNC/Cy90tUa26ZrT7Va3Xl73j8h4o6qcYcOTOo7hwGD4fRQGo/uCrg6yL0boSez3O8OuZsl0aoYXgLc/MyDEYl/JHWP0fxb6q8mJnH8bWiuAyOuYOtAw/+Hj+rgUBdFTrnKs37W/iLHOFnUu+vp5EKHkJKmlqOJVXAc2pkR+B1indA70elDi53dbYZlpofpHHaKGc7pxKn40uds1O5WOiltUedpyVsnGETWo+RTuA8cVm/HF0qLbKXOs9lYIqHz9DJZehsU6ffqcnUWd/54fABt+GX42qn+4p5NO6AhPzeFnRxkrv31M/kyda1mmuJRaDxsq4lUrFqx3rYHOat298nNlV+x8faqDjq5l+omZaZble+4IFm7fwu+j2/50RwW37yiQv3X5uLVnWXSgZ5FVBCtH5F/PI/UfaP82LmD7UEDvJUl00rb7jNJOBQ7uFGlkYiSvv6CE57wErMbznnQggxQ57dnZM0y2h+EDp32wI67BrBKZB7kMyP4ygz16mttg+F8bJky94KJNzbIJosiR+kFaV0QK8+MVYRjV1eBDSP4ueGwwF/3/YaOWM2oj8xhecS23xSRUD0hp+BDHMy7Wk4jAL6VUJBch9mKx4T/oVIpj/CTcAO7t4
 MoD1oZlN
 k75PNQvr4BFYSY+ziZ/hcFPnlv2z8hpKHMIYHRfq8QFx2gLIexPD4z4hV+KoU/KvY078UORGK6kJRHCABIqqM3EeoDRbStuwpBOCSGgTG41gOYsXv6HU0SSvid5rsv+7F/i2+pAP4kuzPBPHL8t7BFXaiKmRegm6WznlUuP2wQ5Gj7jIdjoTCtirLsRwyZyijocF9kGrRUjkYhMsBTbKJ9VLGotI+chY14EV4C0AJFsyQL4KOMcHTBANTQMbuFAWc91zyafANXlHRlaq4rbNS4FYlHrwKrTBgGpnsSoQmFz7G2bpir/phRVkS8K7IPHe1ucY3By6pj4XxcgG6scZ3I6xBZsr258XrZHHoe8P3ZHqGrusHmZEAFwYlm4PVyEbhDrNw6wcSq9HZg8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

init_compound_tail() is only used by vmemmap_shared_tail_page(), where
the shared tail page setup intentionally passes NULL as the compound head.

Keeping this helper in mm/internal.h exposes that special case to the rest
of the MM code and can make the NULL head argument look generally valid.
Open-code the initialization at the only call site so the special-case use
stays local to sparse vmemmap optimization.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Collect Acked-by from Qi Zheng
---
 mm/internal.h       | 9 ---------
 mm/sparse-vmemmap.c | 5 ++++-
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index da14c56fb24e..0dca33db068f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -786,15 +786,6 @@ static inline void prep_compound_tail(struct page *tail,
 	VM_WARN_ON_ONCE(tail->private);
 }
 
-static inline void init_compound_tail(struct page *tail,
-		const struct page *head, unsigned int order, struct zone *zone)
-{
-	atomic_set(&tail->_mapcount, -1);
-	set_page_node(tail, zone_to_nid(zone));
-	set_page_zone(tail, zone_idx(zone));
-	prep_compound_tail(tail, head, order);
-}
-
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 70143dd8b579..e453ce4675a0 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -189,7 +189,10 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++) {
 		page = (struct page *)addr + i;
 		mm_zero_struct_page(page);
-		init_compound_tail(page, NULL, order, zone);
+		atomic_set(&page->_mapcount, -1);
+		set_page_node(page, zone_to_nid(zone));
+		set_page_zone(page, zone_idx(zone));
+		prep_compound_tail(page, NULL, order);
 	}
 
 	page = virt_to_page(addr);
-- 
2.54.0


