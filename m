Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A13A1CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 189E26B00C5; Wed, 13 May 2026 09:09:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161656B00C7; Wed, 13 May 2026 09:09:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0785B6B00C8; Wed, 13 May 2026 09:09:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E945B6B00C5
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:09:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A8FC58E8F7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:54 +0000 (UTC)
X-FDA: 84762429108.08.5EB8500
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id C58251C0013
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AahYKIGr;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1fKIdS9sH5LMxvvJtquNIgVu8JwU6IdO6x0CAgaX0p4=;
	b=mStHSAJeo866v0w7pJY26d/fSUYM/sXlSNeeIOXDNgBXS05gs+YUvBIbcBy7F42P3AUX9r
	VrJTRRpWpYk4T8S1uxzDC4EfR3mHLRQwphDwt1KkaJ4tm+0Q/RL0uynW/qXiZUy02Vu0Et
	cdQI85BQYHTeYoXsq2djhNW7A+torEo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677792; a=rsa-sha256;
	cv=none;
	b=7WBAJq7NsgUVU7rWx+0faFz4Nr87jotdJ6S4SoOc4rICAsWg3Pt7gB9nfe3q+WAfNXEPz/
	4tXLwi8sESB9Dn9X8x3XBtgb+V1by2vP537NozQWYNwEHMC1MwYbyFAjo4oN030ncw6Y2a
	GBWuvc280eUrUO22RIYhWKFhU3804yM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AahYKIGr;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ad9a9be502so41298995ad.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677792; x=1779282592; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1fKIdS9sH5LMxvvJtquNIgVu8JwU6IdO6x0CAgaX0p4=;
        b=AahYKIGrzf0FxuJh/7G2LV5DugWUhofqwbhe5hjN/5xy3Tt4wawdmc/4zAIXvUckMV
         vFnTYY3dm7a5C1H/ilYa6me4/ZU4MJBdPs/wrkrqPKqVDcS/l94w3pOslp51HXWD6+/F
         BI0bENprK5y/s3RA0sa3hBr7c6WyBIVCpc7qzCu44jjHo7+ysyQNjxINVYvf2Qvqa16F
         Xc10B7iK8xIBVHvs1XYglv/3WJG53suxu+w01cx1aaiBP8xwCzOrhqTVmQm8qvPWn9qb
         Rbkja+axYuHz/uP5TpzmfiF+37nxLOIcLHMDKvcfIMsWliZTmJMZpZPGUKEZfhGdVQLr
         e8Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677792; x=1779282592;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1fKIdS9sH5LMxvvJtquNIgVu8JwU6IdO6x0CAgaX0p4=;
        b=WIvKZOEdxJcPWlGuB9EaPQyub26DmLUxJzMZ0lrynzT/1zsxtoPa+Ky5OIK8MYfw4r
         PUMz7lNDFywF4rwGI0vjjpM4jdzCIKItcnMt6ZaVtHAhFgkxR3b43Nham3XQttX7tome
         AjHgQeP/I7ZuGgjGxQvsZZgu4QYcuWmYPE9CBooGpQAqAGE7XF93onRqjNkJSrlhhgew
         cLK/07jN1K5LEqDEyr04RR1QS4rJdj/PD6QrhhHomC97yuK9au46kkwcgQ6qEw28HvO+
         pWD8M2+l2ah6snUqhIzXWmBAJgBtamlSVnzDBmtlWH6nlWrHHyQlrC0ysNu+3Dt53eSn
         uhcw==
X-Forwarded-Encrypted: i=1; AFNElJ8Gw0OWoCHWmMnrxJysRgXqX8oZrSXz9pj7WXrr8YDcbOUaPHkvu5qnvGwBZ8Ph2dyVS+IwR/qJ8w==@kvack.org
X-Gm-Message-State: AOJu0YzC+PWeqRO5VnKVkXFU+KaBNErPrWrukCWQxKrtmBBqfX/YFAUk
	s2r28zzH3tRi3Pv1z0L/mBHPFcLgzO+Lh1998CLhLX9jvHIChxyY4AbC//bodm4T8N0=
X-Gm-Gg: Acq92OEdkgNeiBBsQG7Jq6GOE2gkjQLfjvmltkyZ76rBX7amS/e7L3mcQuzZsT6KhPp
	jQJlwRzX4e1k0qP1czdiXNFawXdc0vChlc96pbuaOJhjpcNijw2V4J1Q8UK+77DtXcbP7hqbjdP
	F52p52y2HF+x5zW7BtldYtr6Ry9ISxommKLpCrsB7UmHUCMbej0Ap7v4vrp7PM4XKFCFEKbyeDx
	DBpFvr5+y/T3QwRx3OraPYH0nzY3Txg/LEsGrpTTitJUVrgvWQaVUPcLCgPJzOMiqLkI4U1D45I
	4Y7/wCv7AqCfUwlWhKFTnYY6rkZsAUZGxwf5zLtTOwsmE7o9I9axN5NN83nXQLG8DPaOgnsiS3M
	ksbSZc7Folye8nixzGENl26aZYQ4TiZjw9Ghcez/a3cD1GQT+X8Ug/esVMCccsBc5/odbh//Bmc
	OJIXRH4Y5mu0PwZwqpE9XU8htNSPLwPR7FKiK+F3+y5toZgOtdewfBiY8qbOo=
X-Received: by 2002:a17:903:b06:b0:2b2:50bd:83b3 with SMTP id d9443c01a7336-2bd27176414mr37032205ad.10.1778677791500;
        Wed, 13 May 2026 06:09:51 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.09.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:09:51 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 25/69] mm/sparse-vmemmap: Initialize shared tail vmemmap pages on allocation
Date: Wed, 13 May 2026 21:04:53 +0800
Message-ID: <20260513130542.35604-26-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C58251C0013
X-Stat-Signature: rhwgfxm9ttng7ik1xxtr91g545n4cgob
X-Rspam-User: 
X-HE-Tag: 1778677792-344465
X-HE-Meta: U2FsdGVkX181Ui68m4RdEqQkbZgLslp/HT6eDg3yiF7q1cvnTMxvdITB0FO8QiIDyZ+dxiTPyh8jX6kl41ZJ9XHis5eySKyBTlbICR0jUVkNd07wU/Z+j21VLvLLNHHYiFSqAC/4RGcRGMrMCLrwhYPPdshpS+XrMUL9apwbjtsbt3vzIRpSgD29oujgXZ+ziNwGqv2pJC7Nrl+qX3igw9D9YBdb4jm3UawHv5Xchzkgxyejq5vYsEVGHwtMZWdIAdyxqIh66L6A5IrVjHP8gWyP4NfuPK6mJ3iSL/6m7N+C4B/lCPSDWwEUOkFotVBc9zhcvrYcwryJYEPLQdFFa9psLzAnQxVjLkOGoWJqteF3zZZl4W4fLvYaVr1v3ZNQEdwt2bd6uqM9frOdmEeDt7TH7RQtf/Oe9myj95Q62wvFj9+bUEijW7zh+lLTqlvEwDE/XvOVNJyqpf7jKyDtbzP4GiD/fINyLiCu6odWIDoOFLLvsbVrGEcQcAh+tfwjYSR71oIh6mKl9X1ufejAP/IzcqaIdc4itEUT445MJjdLRsPhKArNuhXh4KE+RSdp9MR+7XMsHibv7ny9ye6a6NN7Sp1yLxgLUVvplFuHcsiGZ9bfFmwOA00SQR1fSWP8O5CV5j3+2L1ZtD63QNQvbVIjQKfIgI3UKT6CwE10hRxIZtPdQjpptHC7yNvv3p5ysqol1d4fYqlocfnNvNQe4R9B9JGGyL7lOY0KE71d4HBudgs5wn5hxS06X2bYsDzaORREOTzroqacYjiqrvMUM1B2yze4mS977S+OH67+H97uOKAbakSGqXYDDxbKVLJtIeRlXcJ7AscVUbmXhNgpPMd7nwJfwRYEOtHoitFsTihuUexAZvuUl1T61ya3hLxFLXpOj774Pp/XwgfDFjvr+arR4kJ8WTvIR72AaCchvHIGVOTRVC4SZvKh8sQinzTuapbegOZK+q0klt+T8Mk
 JuwUtTjM
 vbvD6hSwYD2yihFkG0KrAsd3XNx1im305ocjWj2nMiIlI5FdNdZaiFEk01qF8Yjoadva0bH7G6In1MhLe/Z3aT4/jOLmfXSXiaOp4Fvu4o9eB0tZ6Jp+GMFlWPzZRzIMOM+h+79jz7orWf6KgXyBRHy4yEhEUtxvdCxYBR7I2I7t0UVjoE0O14JSiWrekq8PBupTZ6KGLrmszC9O00W9/dMgdBjFehdiWW0uYIVxRFmoqOex+srwbmj/MnaDg6F6h/zSau872fw35PEeFglci/Oar8JdPBzFU8o3U8axYuloD3OJPdfZ7jBN6RuixDbWa1P6SqMr0t95P5Q1eox9rFVkDkPqHp+WQKWmD
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
switches to the section compound page order mechanism.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 39529245d790..60d5330a8399 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -328,18 +328,11 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	if (tail)
 		return tail;
 
-	/*
-	 * Only allocate the page, but do not initialize it.
-	 *
-	 * Any initialization done here will be overwritten by memmap_init().
-	 *
-	 * hugetlb_vmemmap_init() will take care of initialization after
-	 * memmap_init().
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


