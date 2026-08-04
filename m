Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08E8AC55172
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC7E6B009B; Mon,  3 Aug 2026 23:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58CA06B009E; Mon,  3 Aug 2026 23:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47C876B009F; Mon,  3 Aug 2026 23:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B3466B009B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:56:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E4CD1A01C1
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:04 +0000 (UTC)
X-FDA: 85062223848.05.574535D
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id DD24A40008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UIjbqkYB;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOzdkIPPNoupexe8+AVOrQT3DBRmXPJ6Kybkle+RLi4=;
	b=bl+9gUjQIkB43Y12ODbFN9gJm2gbhgO/WQ05opokN6a+3wmIbnKhHN8lwSFBF4jrYYqc1/
	mcn44sINrPGNiAXEmdEFemsxU3ktTtPMBc0LcrdSgzIA9apBJ2j1PjgTvxm9kPQO1ATj+V
	2yK5lMuxSf3PgqwvXxAJHGmSmj+D0vE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UIjbqkYB;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815762;
	b=cA0KQZczrHmlHZO4oKtIg92s3UIdwC8q1glseuPnJUIQpi9Ea+NJMf97K2n/4/i1/PM9r2
	a9JDKFiCt+JVEjo/+3T6JJlXCkxNevmPuhApfoL/EU4hv2cIgDjTGl0K1eeIqtnuWhdlvC
	T6McwbPTq4S+jbs+a8E6Hcwptq/6eRw=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cf50c6f235so46295915ad.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785815762; x=1786420562; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bOzdkIPPNoupexe8+AVOrQT3DBRmXPJ6Kybkle+RLi4=;
        b=UIjbqkYBxsI9Du+vHWhnTi5GXOqetNJl1sJ8+n3fD8xALX+sOgtDDKxjDImvIfqRZ9
         Pagn5ZiLhAmsmQzlUzL1PxQmNaKbARpGjfp4THhTXtGj/EFtME0CLQ8q66jZgNAVZvPM
         l6MhHZK+s+gSqdIVmjTCUYIkM3e7fmXvZ1HHJw1sJqQXF0MBlHOlUDfUrFCe1btXhD48
         KAWGczsXMImo9FpskWSfW6d1PxZxKfcon45LwrTBSjSsWl07ggJpFN6BShuhNVmxBzz4
         SRa+1TiEdjakuWK9XgZqCtCE5Noc4kbjJgaWnxxsbtilhd4+qYCINTqTRanfn0zLRklq
         s6Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785815762; x=1786420562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bOzdkIPPNoupexe8+AVOrQT3DBRmXPJ6Kybkle+RLi4=;
        b=OqbHsFrxKqoiULf7ww7tTtqq3muzOxzVVBegvzt1nb3a7giVRN+FG0slq8RY2rCVbU
         3U9pSnDYIbWUirYRa0DCIZDfuWrj5xGyiEfGQDUkNyWsaom1K+vK6QsaZQ0MacoHFR9f
         mYNQ80XLm6KngAIkv5ADXaQcDI6N+8EPLNW7NKc5f3tBIj6qdeUV8894ddfuGeiJEtf9
         NfHvAaos+4vzC9rgzTXOIsvDjhZhI/3FdPeUSpMz5FSmBPjtU3yF/CsQi7gDO96noXVx
         OB0F6Fm0AnsFKqV3iS/SHZq+zTWAm5J9d2Ku0lM5M8hHfOoGtxaW3GAutVCuruBgHQv0
         Uovw==
X-Forwarded-Encrypted: i=1; AHgh+Rpj9xlychquHfIxbc2l/UuAlwXI73AbpmX58Y6nCF6nNSi3SZRmWiEDBXbYt4eT+bHdHQFKWTVRiw==@kvack.org
X-Gm-Message-State: AOJu0YwJP/8Lw9aaBwMP5RpM9Y6yCmOrA9V8nNjhGG106zNbgHvEOYnl
	lvWr3fvc88VA4ehzTaUoA8I4/aR6ezXUVlpCAIMn6TsrQGqWg46qJXBv9eRvOc31M1U=
X-Gm-Gg: AR+sD13AIsz/8JrFZ+bK1HfYco/8GetPwWtd4xIrPsQOYFX50qko//0ShSMsshEwEvv
	b61IkUiap3P+mRM0CrqSg/m4Tt+8WkdROymLLXLE4BudsOkAIsUs1bR1OXLyTyW8l5Cb8kMs/Dr
	MF+SzvV02KMKBGGSi8gBiEz4UNkw0WLCAgMToT64yYoZPeb1yuDf5eWt1XmxUQmKfSQWvxrqqK8
	u0W6UYnGhfuY9IrtZXD0HTu++EvTRf6CemvR0Jd1b+02DiIPVB6e7FrPVkJ/eN0BIKLIqECxtMJ
	423cdwET/cCAMe6krXZ5IqRp7zXAWNJBUV0Xs2jZtThJJFqKykHMqkgIDPIQzaf28EjI2aeDdyQ
	lWMb5YItCYcyZtrqckd3dCX0RHysSZ4XLTyI5h2MCrD3dKyFubChkuF9ByAntA3VroYCmZWcd0u
	NnHZ5Vvj3WszlFYfbpiVwAHL2etGvrR5dAE5zsPI/ukYxJeqzonzrbLCZIQNx+mRBjj1kcP20CF
	CQKpElg
X-Received: by 2002:a17:903:2ac7:b0:2ca:e5c:7fcf with SMTP id d9443c01a7336-2d0521eac7amr124957695ad.3.1785815761731;
        Mon, 03 Aug 2026 20:56:01 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae99af1sm46313695ad.33.2026.08.03.20.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:56:00 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v3 04/17] mm/sparse-vmemmap: initialize shared tail vmemmap pages on allocation
Date: Tue,  4 Aug 2026 11:55:22 +0800
Message-ID: <20260804035535.2846016-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260804035535.2846016-1-songmuchun@bytedance.com>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ztqdp5jmhqthqxttpzdwbr9ta74964xw
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DD24A40008
X-Rspam-User: 
X-HE-Tag: 1785815762-97443
X-HE-Meta: U2FsdGVkX190qlLTBP7ukgJwnGMuI1PAN119473Pk7YgqeXbmZBX12sJGgSTTBIZe2h5/B75HZ+Us7Q86ijZcKjHQHs6+hDOIgTRn5C0TH2EnDYg5Zrq4SPF4r4D74Hzzt4Cu7c7KXFEL698Gy6sz5jUJGbTkXiK9NVCv+OHPBTFlk53Zqb9b81MeC3YLbAK7NYVFtijfn9y0bt+mQtqYlPIikNsfEPPcYo9oYSQUvSl5am6fSafwem6s7q0Cz0zp4rJFG209yn2ava+L8/ITeYR1WaMzY5J9sZrX+qamAovG9UFxfifn7cG2sTtRUUKTSbi4Z1kI/WCYFh8wg2vFaBCFKW1chxYY8K3L7HOPVVHXkFBFNUqbEDuJfq+ip+qTJNO5sL3WQbeO09TymyagX8dV0qyAzpV+1Ex7vLoFGLyQxyUtoIF9aBr60RioxRnbvaKu13iIE8jAKtlFBfqO3UFa2A4wqVu/hLPMPplcvY0fZUxnPa4pbv3DWiZ03gjmwmN0a6Vj//hEWPUFl+JHL6iHGW99nbjiaWPRC3FfWoVJEa6rlz33dt7gZKXNtdj3H1jPSVFv8XqDQgAWmuCpdnhYqIdTyqgnrMK5IEYRHtmGj/bKjBb5mp64D8/B+/bRZo6VySU5SBLnh+G1a9Stus10L7eRKD1CB1wn0vCM7U0DmF09gZ3Xg2e9E6u6fZj/4EJPKDeax6BPoj+hrQBVwzK/QLiMzHnvIIyX3J5e+3l0p5A22Is85JpdpUjCK4mIGG16CjUjDw6yg03mWC/1+M/dBi95DXfh2meyIh/o7NgXSRbgAnYoH8SH4v7rGEItU2NdHYO28hOakj5vpfuUBvQm3wXoFuuiSu+eq1fGb3lqvQdNIdgdcgZRr9r0sH2y56IfqmF7JSoA5BWmA0whOI7K+e10NuAdLbz3IJ0EJju3BPxgfIgiBOVcz9m1LZREQcSXTHWmp6DF0KYmGs
 ptqPz89U
 dbT+DngbC8zJ2/e17zXfjF2nv4Ca+Cz8Ri6CxPrDDqo1pj5fjNmecAh9OpABTwnQ8dAcQuul0MG1hfORzZDjLrURMKORI7fY3lsJLhdfeI4YWFSoysSahJ4V0RRBb1tufHR2K3ax53QVCzokgd4kRZ8gEZMjHWB+j3uf5fTcjPVy47AD5uUAfHTfzdnyqBdoqlTqiKM+7YjAYsS+pgC5aU5Ykd6fefSAv5TP70X+lNe/tMndMy4TVZbSvqo9fIpcHOsFq81R/itUzML5Oqbgm/EWqCVx24wAlwU9lvqW94hKK5iaiFWzpnbZTVBUjy1hsATnDUNgoH/mCqxitF8fgR5niUs4JhNa2uBrRVQw3DSxpjwjoJEUbuoIS/bNwDiUkhyUxzhWCdB8kFg+vZrrXJK0QlG7+yZFD8xUldQuJarxMhXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The shared tail vmemmap page allocated in vmemmap_get_tail() used to be
left uninitialized, because memmap_init_range() would later overwrite
it.  That forced users such as HugeTLB to defer the initialization to
their own setup paths.

Now that memmap_init_range() skips shared tail vmemmap pages, initialize
them immediately in vmemmap_get_tail() with init_compound_tail()
instead.

This moves the initialization to the point where the shared tail page is
allocated and avoids relying on deferred handling in individual users.
The remaining deferred initialization in HugeTLB will be removed once it
switches to the section-based vmemmap optimization mechanism.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index aa6a4a2fae98..107215cf8488 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -338,19 +338,11 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	tail = zone->vmemmap_tails[idx];
 	if (tail)
 		return tail;
-
-	/*
-	 * Only allocate the page, but do not initialize it.
-	 *
-	 * Any initialization done here will be overwritten by memmap_init().
-	 *
-	 * hugetlb_bootmem_struct_page_init() will take care of initialization
-	 * after memmap_init().
-	 */
-
 	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
 	if (!p)
 		return NULL;
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		init_compound_tail(p + i, NULL, order, zone);
 
 	tail = virt_to_page(p);
 	zone->vmemmap_tails[idx] = tail;
-- 
2.54.0


