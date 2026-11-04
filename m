Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA1A606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 02:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=JlwZ4/Fk
Received: by kanga.kvack.org (Postfix)
	id 8CC4C6B05BF; Tue,  3 Nov 2026 21:36:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2916B05C0; Tue,  3 Nov 2026 21:36:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CDA96B05C1; Tue,  3 Nov 2026 21:36:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 350996B05BF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:36:30 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6592A0631
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:36:29 +0000 (UTC)
X-FDA: 85395872898.23.E924F82
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id DAD1E80005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:36:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="JlwZ4/Fk";
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793759787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y0mn0lCTeJh6YvCHtCywa6O+LBHG8JthBO+lQUGYTQk=;
	b=QpJuwHasriC5iUYDVGEbfSME4Q1/45tYedUfE5y8EmvVLOv9wWfMWzG0agMa6IpyzFko2W
	vUHK6aNKHJqCHLAtP2LnTgYQ+HdSfLuJX4PNmSJ6p+wJ8DUHaL3mhh3clztxVueEAjvOto
	La9A0B30/LmHNeHX8b0tngKFPXp+26o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793759787;
	b=Pdhz3IUlAvZvoJktzYSO1DNS+FrLQ+c7S/n+Bzl7iDBfWyJpAgd3WGvstPp1sKUxB4gYJy
	R1BDGWuBU9Y4dfEYV5uLZXSGTMKsxUZ8G9QJda4AfbkkGCx3uxSmVmETCOfDGXJCHqBqJo
	S6dtoVhUpUNfbB0JSvFYHQQMi98EtuM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="JlwZ4/Fk";
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8a05da1cc1fso129031b3a.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 18:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793759787; x=1794364587; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y0mn0lCTeJh6YvCHtCywa6O+LBHG8JthBO+lQUGYTQk=;
        b=JlwZ4/FkIEJ18P3Uh++TlDKRjIsOg/pjGFnp9N28/q5MeXKAANIUCYzuLWgZPy0pTK
         4YuZ7QHBexEscSa2nGUzyXBiTudR1QesGAvJgBohP/Iza1H98RagJYLvQR0Hx2s0EFz0
         UHXx1EVv8oCHDjmtp6sHFVNJbRa5AGl1aTfE/YS15x2rjHSDCZ+i6x1ZD56w5zZCLqfm
         IJEdNK6iLtW4H2dq/7ioSQqhCyVx1iwsHsJOM5gFB4lCYsTzBcvGr0KVZzx/raWs89hF
         mIC3RRIvt/7GfZxTebempQLjaJ+lFaufbwYgOXRuX/OLVGdkVRmI+6nwrzqxecB+3Jny
         lz5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793759787; x=1794364587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y0mn0lCTeJh6YvCHtCywa6O+LBHG8JthBO+lQUGYTQk=;
        b=evB0qrHy0XrcMFsRiIhLdSgEKq29u9ZreRG53uo4IJ7gZkIHxv2KQgqYU/O27+BvIW
         sYMvz9tdTqfw5nXG6qHwimJBu+AjmEptwdUH2Kj5ppyoTbFraZKvGDsB9lQi2ql4BNso
         7i0huw0zSYW7ySHy/Us2wEPnkTyq0UNvofxTxtUSK0/u6SV2XdGz5EsGDPzMi7QCTqU+
         MdUROwhvt+sqVc17OWCSjbX6zoRV90Em/ko1LF2J+hGpUBSW/rFMU+krTBlJ210zTfUF
         CBk2D3hcWeWH4PxVsZ/fVT28UTPxBZzqYf8Y1F2TEBUbun5aD1Q/jRVA5azp9iY6u4U3
         LqJA==
X-Forwarded-Encrypted: i=1; AKwUvBxYUywVj9EdwfGRdouOJrcnbsNaNVmbDGBu9Spj/axHncYI8ajaNMMK732HzpR0JltOM7zBngq1Wg==@kvack.org
X-Gm-Message-State: APuU4Z8NU/BdZRi38ol1w4kjw32JJ0ybX8CyvqS03ejjCkAe6rrAinl2
	ZR/MdcjumZP4NCgDLzwjgU4isYJQXkS62hjGN+iRS5pagSQRCVOvKHYM69cHX2GSchg=
X-Gm-Gg: AYBFou0LZB/V4woCMvKXn8eMUx0hJdxUaImjtzvcgg+Ov9ojnL0nxUX03rP4OA4KpKy
	Y9Zx2BPYw3soUvAdVqjKe8zTzzrE49laEc534ppiZRPUoW1wGGkn8ru1lFDSWNRei0uPxxwKNCr
	ls2B6MEjQ+34EMqMI0ZTLR9mwDYwKg6Nn8YZlMJFXp3B/d4pEXcjffGJognYWti8viGfapq20OM
	fkKaMxAtfR7ybvACXDFKERnJJnhJNKRCdAVsdpxQ74ncnUQJyINhXAUV/xRD+Sp6FqmvGNRv91o
	L3jZPDYsd932axWVUs19TmvL3SUw3tWYpKlC3/qBZ2RnvKp3V5zCfUyMfubMgHbQRqYWMy5f/BD
	5Y3iBe4bXe+Fa2u9JzQoBSvggzdeAmofVDpQKhz2d3SDJVw9an3kdA0WUsb7auEdOpM4d+dTP0k
	0hFYTZPExfrCQOMAHprDuZ9aUlSz9x8egZlF6ddDMnYhYPOREdoCyLOcSFDxYuOmwJB3XGUEJlv
	CPIjHrJYsAdur6VQsEpIL5CDH34vkR2Wf3WQmflYKBRsNsWHoMc91BLpQWf+fvwJvnLGT40O7k1
	C59xOn+T0cWrWBIGXvCLyAr+HzXhVhL3uQ+C0qS2KheqNQquXGI=
X-Received: by 2002:a05:6a21:6197:b0:3e2:168b:d317 with SMTP id adf61e73a8af0-3e928d8ad35mr12759117637.44.1793759786727;
        Tue, 03 Nov 2026 18:36:26 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b09bc3d1f2sm240815b3a.50.2026.11.03.18.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 18:36:25 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 11/12] mm: hugetlb_vmemmap: unify vmemmap range restoration
Date: Wed,  4 Nov 2026 10:35:09 +0800
Message-ID: <20261104023510.260766-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104023510.260766-1-songmuchun@bytedance.com>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DAD1E80005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wnjq5y1m8pq6koymbn761w594tnaufor
X-Rspam-User: 
X-HE-Tag: 1793759787-278012
X-HE-Meta: U2FsdGVkX180e/koNE0grbBXEf9TDwWFkqEe+Km7WoVKpb9IUIAw4xsFofat/mqdut5qxgvC5JWF/YFPSK0H5acwNNv1naOJUTgBciII+VtihX2hH+XP0Amq56P87e+2SP6Edgxg4Fpr3V2BQdkN1LhIdp7WL3BjIQkx1xe273TkJ0b3n55khQRaPELIHQa0Nrtg71AdghzO5+DFcFpgynRXPGmy1+V5tlteKvJGqbfJPeFXPScSm8ICVsBsI2shGbf8GZxXGTJ9G8e87tyT+PMDYwXZAKpoTSUUi82ynbrDTERoQsiWnHDO338QoWNQWHR8mHtEXFMZV9JTUdDd+bTmGFBwRm3JQf+RD174chmJPFeEcA9gxiaT7+NbhZwP65NxuYVpdp7bplpsicd8PHCLIQKuGX6fDDkJZCnr/a71oo2Hno6QkvYacYXTnX+AB3uOhh1EV256LwPoCrRm/qeU+nfnRUG54tAquRB/NPHmQq+j1cQfFRoMaznnyRYw23jrM4OCeJ4s3hj6R7AQ+IW+ISnBL7QN6Hu/WgKj47f3ATde9yyWVT6k6U5lhqhQvyNgd4vEcWyBTyXdB0Aifg1j6ueppIgnSZnjV8lBOF5ptIX/tIEdovHgbjdG4fwOhuxgKYoK8NLJgw9u6sHfhz+nX+tqkR9VZGdrB1qMvNha9X2jO5+4RrdMmqQMJ6L3StFHqiPPrOSaQm1EJdoefjZTvzeIYVDH7qSRUpp1EX485jRscWho1gML4/mhkpohzojoisIA2VQNZPmpmHZ2+rwtxqxz4i5vxf6CRr+Sw1UM+UDiVbE5H9x4YfljjwQfclxfZU65ltK6tq7PP9gS+kGFwoPPXGpnpF8U9WpdqTWJCboFgzciTF0JdlqwWEPrc1HUQ7Gu26owK1QwKvIPyzKS91kiINoVZ59H0HH7zwhl2Q/C1yj3B+0nlJjtzucaZo9zx3BJAOGhXe4Zw9E
 t2SDbi1x
 x5Lx4tc9U2bdchpwspFRgj2VDWAQBSPP7PJBFubSxu0yuVnJHxSRrstueiMCasa4DLmoT6lonZ7h98pna2eHY+jbNiuRNzJ3+z2STHzqntCOz6uzKVtzWiBj1Ut2JkACCq2tks45fw2is6f27nML4oxwCXrYlJRT3BCAKtlVOzEqHJCohq1Fr3xeVgo6DP5+2PTzlE3XtTMt0ggFHY7UcRAeAIDDdUWPbzCLH68JiiWIAXSii0gcYCSQ68mPEMYfl4F05rQ388W05DH9d70yM+OswWNhVfQQJfFTkPTkFmXNViOKbAqSvz5uzz8xIu2aLDica02YfGD7daNKh01RyiH6A32N/LawlXr78ruYAYX1y/6mewV/1d6YJFL4bRVuvGoOa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Restoring an optimized folio and rolling back a partial optimization
both restore a vmemmap range, but the operation is currently implemented
separately in each path.

Use a single range-restoration path for both cases, making rollback an
explicit bounded form of normal restoration.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v3:
- Collect Reviewed-by from Mike Rapoport

v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index e424cb0b1a78..0dcbc2b72384 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -287,6 +287,18 @@ static int vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 	return 0;
 }
 
+static inline int vmemmap_restore_range(unsigned long start, unsigned long end,
+		struct list_head *vmemmap_pages, unsigned long flags)
+{
+	struct vmemmap_remap_walk walk = {
+		.remap_pte	= vmemmap_restore_pte,
+		.vmemmap_pages	= vmemmap_pages,
+		.flags		= flags,
+	};
+
+	return vmemmap_remap_range(start, end, &walk);
+}
+
 /**
  * vmemmap_remap_split - split the vmemmap virtual address range [@start, @end)
  *                      backing PMDs of the directmap into PTEs
@@ -345,19 +357,7 @@ static int vmemmap_optimize_folio(const struct folio *folio,
 		return ret;
 
 	end = start + walk.nr_walked * PAGE_SIZE;
-
-	/*
-	 * vmemmap_pages contains pages from the previous vmemmap_remap_range()
-	 * call which failed.  These are pages which were removed from
-	 * the vmemmap. They will be restored in the following call.
-	 */
-	walk = (struct vmemmap_remap_walk) {
-		.remap_pte	= vmemmap_restore_pte,
-		.vmemmap_pages	= vmemmap_pages,
-		.flags		= 0,
-	};
-
-	vmemmap_remap_range(start, end, &walk);
+	vmemmap_restore_range(start, end, vmemmap_pages, 0);
 
 	return ret;
 }
@@ -379,17 +379,12 @@ static int vmemmap_restore_folio(const struct folio *folio, unsigned long flags)
 	int nid = folio_nid(folio);
 	unsigned long start = (unsigned long)folio_page(folio, 0);
 	unsigned long end = start + folio_vmemmap_size(folio);
-	struct vmemmap_remap_walk walk = {
-		.remap_pte	= vmemmap_restore_pte,
-		.vmemmap_pages	= &vmemmap_pages,
-		.flags		= flags,
-	};
 
 	start += VMEMMAP_OPTIMIZATION_SIZE;
 	if (alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE, nid))
 		return -ENOMEM;
 
-	return vmemmap_remap_range(start, end, &walk);
+	return vmemmap_restore_range(start, end, &vmemmap_pages, flags);
 }
 
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
-- 
2.54.0


