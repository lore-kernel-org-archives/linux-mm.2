Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCB50C624C2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2376B0095; Mon, 31 Aug 2026 03:54:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D632E6B0096; Mon, 31 Aug 2026 03:54:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52736B0098; Mon, 31 Aug 2026 03:54:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 915446B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:54:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0420E14031C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:54:44 +0000 (UTC)
X-FDA: 85160802930.04.E48DC5A
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id B5FED180004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:54:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MOLarUMm;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788162883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ydg9K+ixOLWYvkyYLVa0DgkFjsmj2k1/+Q4MRUoiR6A=;
	b=igcVb2+gvn694rrvJfengI9O8btIphMOwgjba9YXCazD0OHNf6Y1RnkIoub0TNKaHfscKq
	RTtLoy8K7r/8icxnFwlFMK1rNsFfKHs7CekH5rhsI7WMPPyg+qzQ9sVTsXc4wBoVAxXxnR
	D1HNA1fW0EiwSufFSieeAgF4W9C22eI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788162883;
	b=mctjLyng1rjhCj7BNeY6vhg2J3tQWHxRdNApiDROmNPnE3Z2RVt4TYSbGbFw9SlY3H0o6S
	F6wnPNO5vSrEkyElxkVMvHwJtxzPNrfGkYHIm9xu+CV+zLlrMh0rTHQu35nklfnKDenxTX
	mcrJeSvTib4T5cXcjwmjrB3peSDX/FQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MOLarUMm;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84e84a6c4bfso2870597b3a.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788162881; x=1788767681; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ydg9K+ixOLWYvkyYLVa0DgkFjsmj2k1/+Q4MRUoiR6A=;
        b=MOLarUMm+FVqNx6s0UD083OGJUVm9RvJJ6ASyRiOMWkWkerKtAazW490FKa80U5qUw
         OL2FnvIb/o05xWJZL0SK3dYMHBcjoX6y984v9wGknZGWyFRt0a7HNaI1jbWjJ7W9Py9Z
         Up19zCZApZcMB73P6Bs9qN7bEX4LSnSbN22ke80S1XfqG6gm1OfL9d/AzJe1RUwIeQLB
         YVybhgUNzseYWG2VhMsIy4GZNV5sVMvsqz7d8fbijue0DGB394Kg5O0GPXCEWVMVVlez
         8uX8MfWfGkVUZMrzvIg0Z9vwwYyvNsXdrRbqxpBQ0Iu77/qv+8wQ5aphg1pVBX622ZWm
         nJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788162881; x=1788767681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ydg9K+ixOLWYvkyYLVa0DgkFjsmj2k1/+Q4MRUoiR6A=;
        b=JFKDZHZtmCo5CWwYRFnVINlqXKfhIG12xnQB7Rfi8Miq+0hadkrp8lVI5XJUvpVC2W
         WBpnAGVJK5ecgRyrxvBW+pUo7RMrWl09KoexXeyDnALeiDWpYNXThG3wybDtcH8gf7dD
         n2Uhv/ZuL08AZ8myG3AHLJWF9bpFiLs2T5PgDmtcMLuK/8RSHm6gqMULkVyEiNjywSA3
         oJolUY/qyyWSb3na4CvOi0+XkFz3NRj3jSRNu/AMbBWE/Wn4uUE8S0dCGN2gGEFSPbTY
         MTBCeieuQ7kfIXOqDOoBIWAM5RgIt8LjdhqMLidjZVuYaEem2z0RRw0Q0EfXWMY+Qiad
         J0IA==
X-Gm-Message-State: AFuF++lfBdMVc0AsxgQt5TtGS57D9O7DDEjstWOrMZIZJk3H2h2d1WfV
	AKPmqqTcGfBO/AZ6AlH5/mWgm0v+uJUbrd0HePrYDsbrDPzDxT048CI2l9gA0Hw9HWQ=
X-Gm-Gg: AR+sD13voR7BIGZ5YWrzJi/zPDV+xPL4/zIPDgQPRZJX8H3VnKVaxEd/xxWSOQtk885
	G5CtXLEJF5qsOuT6PfgmtPgYC/Ko7KhBuMMfx38tIek/GLriW8qqPFy/kEQ3ExIgwZmaWLyx1xJ
	/m/bCXpWDJ24PiL91e3iTbEk6y/7lB8Msd8HGjGmv7H95tSMAhcdNsqdpJcWYCEKX7mdzbF+GMx
	XPGVrAeLGmwT/JkGCzGACDnZ3j5wuXo/OF1sQrrs5h7v0/8PcYITzPocBhldHIYmSIl2geesu4k
	eb4C7wG8ydHcy7xk6Q32VdVumCtZEOeuYqh94wdMBP3LF3a0uv9GL24jPpGeR9mF17f43cRQM7Y
	OPHpF3MPyGofhW4e1hl6j2fSgJ1gkKN88j56kvzr388QgUYgYRcZ1+1o7rzU4PDVfCI2hx6PAUk
	tsbPna4zO8KTXI7tIdyjZ5wAWw5JzBv0Ze+P3FPHYg8QohH1hiWfS0mvsdxEW0kUaAOjZkpUTYw
	FrONzWTveb0G4/6XvihX2+1
X-Received: by 2002:a05:6a00:3487:b0:842:3c77:5996 with SMTP id d2e1a72fcca58-85994491148mr5360786b3a.1.1788162881545;
        Mon, 31 Aug 2026 00:54:41 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f330f88csm3590256a12.10.2026.08.31.00.54.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 31 Aug 2026 00:54:41 -0700 (PDT)
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
Subject: [PATCH 03/11] mm/sparse-vmemmap: open-code init_compound_tail()
Date: Mon, 31 Aug 2026 15:53:34 +0800
Message-ID: <20260831075342.57563-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831075342.57563-1-songmuchun@bytedance.com>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 63y8fshtohpbnigmdcg3ibxu1x9p6jxg
X-Rspamd-Queue-Id: B5FED180004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788162882-194157
X-HE-Meta: U2FsdGVkX1/DAYmvE/c+g0VWLq6iTwZTXQhjKnqrV+a78S4yZQDYr7VkMRpFcNfSSphAvvFlb2QKfPpBDiov5rzEpYkimFpthwFX7WwAA1KTl0Lkq5RrPF5LKAcVTV1BC+H15nlOjtw31cb7I2tjtRNf2dTFyVBa0WxcqFqHXi7F3D+86vBZ9g/P4DrxsN/kB0O0JZL6Nw1+Ruq1D4+/cLZ4uza0nOwje8g5TRCGRpNtgoCOIbGv/mJbTEOoqfS5ay6m9qkm+medNhgJEn7jM6ye2sXrcViuGFZpBnwbOxe+6n8+2QUNE8o68iu95yAb+5IaEguinVVdJCmtTPN89nyT46+05YGLw2IifbXMoSRmb8pTeoD7nJz3zNz6XI1OYthLgCOVRBA+ll3qd4MKSkJwwQKNvTvO9S1UvZ6ajyxtQlhquDTTaDTiFAh5ACe9c1Azw5wvlnZgv1UAhHNK6jpQnypZVyTehoYGTCSsGB0xuGpRD+dIZFpc9803mMl/xeFL7hVPQKm6BO53CfFiQZHPvB8u9b+NF7tqbCUsStR1jOly/L0pjCcdd/18TUEB+WlpFQ0ZQwkwpPwQ0UufsR5ry1sHTy8Vtb46TrBIkWzF7BYpm6WwQYTW9dje5MVFn53VtGNhQIFS3xVSZRvE9yMGEi6gQxVwUFGjiL9vKiW0Pe8HzjFxu8sirEhlso58oO+H+Qger0c/mqAVx4wiRm3DGpMBO0r3G081jRdMKvsIDCGpA+wjy9/USfkphGc83NHujTtAKwH5Te9bv2oCzT3KExJnPvy5KbQVC9O/nnPat1TNf2J4azr2EsKNxVteNmFT4i3ScSXf9cbBNR46oCywbD/r04qF8DTarlUt1jVZu8UQlAyyg+5qP3ayhzrhSwUL1LmporK1xjIye0ht1T9VtzXtyGPauBzFz0rth+OEMwf2tbK1F29KqlxTnEPxBKgZYP3V2uFMtovkRJX
 iE3LiDYo
 Cjsce0CuAbNrMUYZG4YHBOq7ANs8F5hdfFp4Gobjpk1zVTWtAqhZwNs3qZ33GB2EJhGQuOu4ASQ8GqpNaVOoleP+MZihUO1yvaM3FpGYgyEgZ0W1iK+EoUNXrTXodILWfHLUORhcWjUwZvb3sm2bNSwwZcAbBAyxDsK7KPPW9G8Qw5+K+yaW6AXtSJqQiqHC7D7FaXeGEms60OVNk63L3/d3Hu5s3FHxH4tPoMxPXXmUSSnmaNGBnPKmbX5VMIi/yn0mBKf5qmFHb93p6h0n72QizSBEJhp4gpPct7XEORd0laGs/JwOJfBjvN9xTjDwlb6rjG68KH74/xJlMynl9Q+09J14lpoKuBs+x4aRIdiBurph1U8kYVzuHkMLjF03+XCEIRGshXRrJv2w=
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
---
 mm/internal.h       | 9 ---------
 mm/sparse-vmemmap.c | 5 ++++-
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index e16f1250b25c..5ddb49680b06 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -783,15 +783,6 @@ static inline void prep_compound_tail(struct page *tail,
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


