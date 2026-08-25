Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DFA1C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39D856B00B3; Tue, 25 Aug 2026 04:50:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374C76B00B4; Tue, 25 Aug 2026 04:50:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 263106B00B5; Tue, 25 Aug 2026 04:50:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED1C26B00B3
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:50:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B7ECF1C18DF
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:50:13 +0000 (UTC)
X-FDA: 85139169906.10.A94142C
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id F28B6160002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:50:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RKFdwAWa;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imD7OJcy+PM8Ecas8hhVPwhNIQNnPaNcrXb98j5hJcc=;
	b=N+6DgQ9NdOHy79nx6nkUEEL1l50yfDKMM9c7+/2xqpUMCOkLVbrdNxSkcKAt9gjC6L2e5T
	YsrdTOoFWYzKU4geR/VyS00SGn++CnxvkS4zHFVa88+19o+VVz66KS+E9We55qS5PCQcMx
	AzWhA6MEoB8w9lYQj+58aPCFNOY9yJE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RKFdwAWa;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647812;
	b=pUuzn/kO8yMglXeeYFRVWqf5HaiB2r7WjrR19ZlBmqTfcUUxy6gyh0F7nE50ZPHbUPgx5M
	LfcL+6R3C2wHKyeUh5zKy+iy0FtgJaJg3HOrULvFQYYZdSkrH6Z45/lvEAA3gq3e6HiYQC
	RuicpB27LIx1jIxvkQsM9+ENRoXfXq0=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-39652a6e963so377049a91.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787647811; x=1788252611; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=imD7OJcy+PM8Ecas8hhVPwhNIQNnPaNcrXb98j5hJcc=;
        b=RKFdwAWa8QjD2FcCWsukCTi0xtjwNLrJd61ooGFmMImfnDDLWlQh+lNqQuM0RLMtbn
         ttm2QganZMjTnTJr841i62AdH8oH9dgEtvfDPqOkw06EnQHsHlwY1NWvCbny9GvHRZyc
         M2v+vE1KQlaNKZnt/HGjkiH3mdBQ7JbQ9fDbzKVyJvAU/wM5XAc6V7qdNiewHWqlQj0u
         iewpcYMbU/UIIb8RC/HHdvjCwI8bl74D96rI4w1TIfKwUG2DKZz8IfMxrkeCRRIiFHxQ
         KGcx74v+oi1ck+CtihJWwt85yMW/rwNnhvc4BbmrFBlUySei3mbCSWV3X8M8BYgvq9EN
         hE9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647811; x=1788252611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=imD7OJcy+PM8Ecas8hhVPwhNIQNnPaNcrXb98j5hJcc=;
        b=ZKkPQPTIKA/KhDvsNKBVeNjh7YSe4tFIs4OXFYKRlHgt1HOlsGQq66wu/Y0a7hDg7P
         Vzqg0/XbsfU85bOf14JEKy8p2idyBVcfmnnYFefPnn21JXzEIp8DeP4YvLhxF1wrvq6h
         TB8IJuVHQgvDKMEm1wJvAIxLTt1Kjeh0riU3ctwwwLzz1ssfpLgWVHwQrCWz9st4RppQ
         +kBdVEbw15fJkktwb0FwP28X9FAhqran6akqS7cnu4pOXb6KxyCeDaeyqKFW8EEo6pjT
         x2xuxCwhzCoD6o8jj9FoxIfiU7yNc8TZDCcwQS2B1yDvwZVH26dwsM09sczRgg2lBTn9
         E5SA==
X-Forwarded-Encrypted: i=1; AHgh+Rq5CvBKsy4fG4z/AJqjA18Rdirl9F8dEm12J6qmtplHzjIKyV+4tlX646sHdCCo3ZH+jTYsaGOMVg==@kvack.org
X-Gm-Message-State: AFuF++mVvFNWxPah7qjxCJfyuz6QzGxjj2lTieXX0MB8JDJxGywqIADx
	ClOzo5KRJXIsx6MQtI67YU6Oy3+DO4MphCJGHlh6DbPblLrp3K3LKvFha7uTJgX1/DQ=
X-Gm-Gg: AR+sD10OKAcyFGpxbX9fhXPtRVbxOzVagyl8feGD+GPbwMbjt81qBfKHLH1SmOIrloT
	YHo2Kiqng7O3nTvQ9+lB0W78LD5JHvjiTkkkqOnKxb8uy66y+q3+Brd9eZkfTsF9545Q+cPptBg
	hN/y5O8WR0RmZcAZekuzr+3tzYn+FKapwBY7IK9kOOLCpXuUOO3hTJk+0biXyMEGCM+TBOsXYmY
	672C12nBxiUYZTjmO3CACAbv7+koXTNx0NvzgefUnfSDWajsmbKovBRjr0S/Uv65ORl+s7Dw9zY
	VnUpvBf3zwmh/Fx0ErNHgWCZr+ERbT9/QTioQVCVNWntFq9ulhaJmrAMBt9cno6XNAiE5jSaGXJ
	3Ioq+08f5lLqhrCmiATTuJbAK2qe/YBTbSKqjgBVBNoar0f4Spw4rC5fI/C/DbDtUJ7ZK7ijbe3
	hPlHULEr4WN7Pu63sofoPFQ4h0MPGKerWX9+sq6XrvA3ey+FlOV2xbDZbQWHLlp/5A2G77Gv278
	XQ8mmh8zjVr/CftLoCY9o5ubg==
X-Received: by 2002:a17:90b:2543:b0:395:8124:ac53 with SMTP id 98e67ed59e1d1-39645aaa837mr5929896a91.6.1787647810763;
        Tue, 25 Aug 2026 01:50:10 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm2873386a91.17.2026.08.25.01.50.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 01:50:10 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v5 17/17] mm/hugetlb: localize HUGE_BOOTMEM_ZONES_VALID
Date: Tue, 25 Aug 2026 16:46:08 +0800
Message-ID: <20260825084608.47437-18-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5uz1k9qnh4btwocq78rtciieo8no9iai
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F28B6160002
X-HE-Tag: 1787647811-605584
X-HE-Meta: U2FsdGVkX1+Guf4nkFy7wVf199M7HZclovLHN+9prc6UkFqvt3UqMqZETUOgmm1xT2fH/5fnHjLG770YMPamqVQd0Wfd1B35pViaiNyLcIK8OT3BscnyWQlpdB2xz5bgBakVvEhVGxwS/OY9glR0J7y7OgUtCMkzCMgMHD9IEPBIqQ1uX4g3adU8wXj9Z4ekXM3FABkQ4fYdFDqxHPnBOt60vYCUh8S0vKtx/ulJ4GjC5pKRE+3ZBAIerRoqpSikc0snf4exvimlksZ8sn1zv3Kx2TSzppNI4WqXBHPMwa36jMGEF47W6g0ZYKuUD82stEcEU8fuv7Q+sX6y0X2iQxKwLMLzzcJfIoxiskNHDFvScpg5xAcqdeFw9Oe4k6qZGWRXTAqDuzd6xvqthAwGe4o2DpqJJ9voc9d4+00arTjks+lCI8TocFIb9VzXgeO9zJ1zvvwlaLpm3SuAqbsVnnbMZ5l0dSeQr0JmRWPQ6ZEugUI66XqkHB0rwwPgGGhiYIX5b6oFCXkq/aVpYst+fyQC9zFWPqTGkizvzE9kicD4TKAp+2+7S54lTZ8tT1qBVt99c4nWAxp5PQcHZF//uLaUtzPQRXbJOdf8PRrLm1gUuCJ8+Jf3YrbNhy8THBVkA3vlNeVc/z1zh/XqoAoRqtj5Gusj3ZLpH+yBSBWSdbUB4rqVoBxhPJIel/ylzeeystqLfYWnfqiBVh8Q7/ZnV71rk4FuQdfdq7+/nziwZ8plM5AYtEqdtQxQT7pQ6UrbFbX4XPrJEyU0xgwT4ulFudeUY/tySlRMCJK1Vs/JMgxDMA5AZEhkfXGF2gWGoIVl8xVXe7R2jFoP76nh8HDqalkNRUqNCHEpTPlGmfXwF67FfpLT+ePm37oQpMbGJR7hQHhKC4QUA0uytAdg8E31+iSdaRnvq1+/JfhfqIqx6EWL8OcwOYNsN7mb9X65WdHp1kOBDKzW0aUgnqQ6xjp
 66/w7g5o
 RdY1PZgxE5kYl1A+3rAzRo6Yuqi0OhxbPDbPZgNQnkOnyMpKnb2o9F5HvGF7kr384vyskMAPFCiAvoJwm4CGmMnsFEKSOe3puP7Zfx8gD9BGWBiEoBvVuARaOiiepx4WpaFZNqIbc9gA8SD8QqISU7bAjKxYVZ4QXEMJAlUNqTA6vNR8XqWSM3QGSSEpwdqnJwoIbIYLTIXbvYOGeIax7GTMFa6tKz0RZR/fgavaKnmeKG94SumMq4DkvbhvIDmqqHDaivgtrvQfcB3HqztPgkSjDk27lmFIPzRptYZ+x2IyVMnealpJF1qYANcGJT6t8/4fUmMPZqtCy/plLi8j5sYEgT6pPEXDtRI0mIWKC+7fEcretwWksX08CfZejkOX7zaj9mU0Md6DiffMsHfU6eoQ14bUxQ+JiwE0W0fs1jf31YOpfF0/pqY8eVXt/ZurjRZZWdamCNVwvwIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HUGE_BOOTMEM_ZONES_VALID is only used by the huge_bootmem_page flag
handling in mm/hugetlb.c. Keep the definition next to that private data
structure instead of exposing it through the public hugetlb header.

No functional change is intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/hugetlb.h | 2 --
 mm/hugetlb.c            | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 255a258f11d1..900c95e346b2 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -675,8 +675,6 @@ struct hstate {
 	char name[HSTATE_NAME_LEN];
 };
 
-#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
-
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 51d386b8b5c1..3fb261d9214f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -55,6 +55,8 @@
 #include "sparse.h"
 #include <linux/page-isolation.h>
 
+#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
+
 struct huge_bootmem_page {
 	struct list_head list;
 	struct hstate *hstate;
-- 
2.54.0


